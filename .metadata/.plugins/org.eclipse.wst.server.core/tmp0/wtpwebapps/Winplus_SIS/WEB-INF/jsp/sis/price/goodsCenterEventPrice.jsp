<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ total_layout : Object / 페이지 Layout DhtmlXLayout
		
		■ left_layout : Object / 페이지 Layout DhtmlXLayout
		■ left_ribbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ left_grid : Object / 메뉴별화면 조회 DhtmlXGrid
		■ left_grid_columns : Array / left_grid DhtmlXGrid Header
		
		■ right_top_layout : Object / 페이지 Layout DhtmlXLayout
		■ right_top_ribbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ right_top_grid : Object / 메뉴별화면 조회 DhtmlXGrid
		■ right_top_grid_columns : Array / right_top_grid DhtmlXGrid Header
		
		■ right_bottom_layout : Object / 페이지 Layout DhtmlXLayout
		■ right_bottom_ribbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ right_bottom_grid : Object / 메뉴별화면 조회 DhtmlXGrid
		■ right_bottom_grid_columns : Array / right_bottom_grid DhtmlXGrid Header
		
	--%>
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	
	var total_layout;
	var left_layout;
	var left_ribbon;
	var left_grid;
	var left_grid_columns;

	var right_top_layout;
	var right_top_ribbon;
	var right_top_grid;
	var right_top_grid_columns;
	var right_top_gridDataProcessor;
	
	var erpRightGoodsLayout;
	var right_bottom_layout;
	var right_bottom_grid;
	var right_bottom_grid_columns;
	
	var isValidPage;
	var pageType;
	
	$(document).ready(function(){
		if("${menuDto.menu_cd}" == "00560"){
			pageType = "S";
			isValidPage = true;
		}else if("${menuDto.menu_cd}" == "00693"){
			pageType = "P";
			isValidPage = true;
		}else{
			isValidPage = false;
		}
		
		init_total_layout();
		init_left_layout();
		init_right_top_layout();
		init_right_bottom_layout();
		
		if(!isValidPage){
			$erp.alertMessage({
				"alertMessage" : "메뉴명이 변경되어 페이지가 제대로 작동하지 않을 수 있습니다. 소스코드를 확인해주세요.",
				"alertCode" : null,
				"alertType" : "error",
				"isAjax" : false
			});
		}
		
		//모든 레이아웃 초기화 함수 호출후 등록해주세요.
		$erp.asyncObjAllOnCreated(function(){
			searchLeftGrid();
		});
	});
	
	<%-- total_layout 관련 초기화 시작 --%>
	function init_total_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3L"
			, cells: [
				{id: "a", text: "행사그룹 관리", 	header:true, fix_size:[false, true], width:740}
				,{id: "b", text: "${menuDto.menu_nm}", header:true, fix_size:[false, false]}
				,{id: "c", text: "거래처 관리", header:true, fix_size:[false, false]}
			]		
		});
		total_layout.cells("a").attachObject("div_left_layout");
		total_layout.cells("b").attachObject("div_right_top_layout");
		total_layout.cells("b").setHeight(450);
		total_layout.cells("c").attachObject("div_right_bottom_layout");
		total_layout.cells("c").setHeight(450);
		
		total_layout.setSeparatorSize(0, 5);
		total_layout.setSeparatorSize(1, 5);
	}
	<%-- total_layout 관련 초기화 끝 --%>
	
	<%-- left_layout 관련 초기화 시작 --%>
	function init_left_layout(){
		
		left_layout = new dhtmlXLayoutObject({
			parent: "div_left_layout"
			,skin : ERP_LAYOUT_CURRENT_SKINS
			,pattern: "3E"
			,cells: [
				{id: "a", text: "조회조건", header:false, fix_size:[true, true]}
				,{id: "b", text: "리본", header:false, fix_size:[true, true]}
				,{id: "c", text: "그리드", header:false}
			]
		});
		left_layout.cells("a").attachObject("div_left_table");
		left_layout.cells("a").setHeight($erp.getTableHeight(3));
		left_layout.cells("b").attachObject("div_left_ribbon");
		left_layout.cells("b").setHeight(36);
		left_layout.cells("c").attachObject("div_left_grid");
		
		left_layout.setSeparatorSize(0, 1);
		left_layout.setSeparatorSize(1, 1);
		
		left_layout.captureEventOnParentResize(total_layout);
		
		//----------테이블
		cmbEVENT_STATE = $erp.getDhtmlXComboCommonCode("cmbEVENT_STATE", "EVENT_STATE","EVENT_STATE", 120, "-상태-", false, "");
		
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, "B01", function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, "");
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			});
 			$erp.objReadonly(["cmbORGN_DIV_CD", "cmbORGN_CD"]);
		});
		
		
		//----------리본
		left_ribbon = new dhtmlXRibbon({
			parent : "div_left_ribbon"
			,skin : ERP_RIBBON_CURRENT_SKINS
			,icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			,items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_grid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					,{id : "add_grid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					,{id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					,{id : "save_grid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					,{id : "excel_grid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					,{id : "excel_grid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
				]}
			]
		});
		
		left_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				searchLeftGrid();
			}else if (itemId == "add_grid"){
				var uid = left_grid.uid();
				left_grid.addRow(uid,null,0);
				left_grid.selectRow(left_grid.getRowIndex(uid));
				if(pageType =="S"){
					left_grid.cells(uid, left_grid.getColIndexById("EVENT_TYPE")).setValue("매출");
				}else if(pageType == "P"){
					left_grid.cells(uid, left_grid.getColIndexById("EVENT_TYPE")).setValue("매입");
				}
				$erp.setDhtmlXGridFooterRowCount(left_grid);
			}else if (itemId == "delete_grid"){
				$erp.deleteGridCheckedRows(left_grid);
			}else if (itemId == "save_grid"){
				
				$erp.gridValidationCheck(left_grid, function(){
					var data1 = {"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue(), "ORGN_CD" : cmbORGN_CD.getSelectedValue()};
					data1["REG_ID"] = "${empSessionDto.emp_no}";
					var data2 = $erp.dataSerializeOfGrid(left_grid,false,data1);
					
					var url = "/sis/price/insertCenterEventList.do";
					var send_data = {"listMap" : data2};
					var if_success = function(data){
						$erp.alertSuccessMesage(function(){
							left_ribbon.callEvent("onClick", ["search_grid"]);
						});
					}
					
					var if_error = function(XHR, status, error){
					
					}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, left_layout);
				});
				
			}else if (itemId == "excel_grid"){
				$erp.exportGridToExcel({
					"grid" : left_grid
					,"fileName" : "행사그룹등록양식"
					,"isOnlyEssentialColumn" : true
					,"excludeColumnIdList" : []
					,"isIncludeHidden" : false
					,"isExcludeGridData" : false
				});
			}else if (itemId == "excel_grid_upload"){
				var convertModuleUrl = ""; //엑셀로 컨버트 하는 모듈을 다른것을 사용하고자 할때만 사용
				var uploadFileLimitCount = 1; //파일 업로드 개수 제한
				var onUploadFile = function(files, uploadData, toGrid){
					$erp.uploadDataParse(this, files, uploadData, toGrid, "EVENT_TITLE", "add", [], []);
				}
				var onUploadComplete = function(uploadedFileInfoList, toGrid, result){
					
				}
				var onBeforeFileAdd = function(file){};
				var onBeforeClear = function(){};
					$erp.excelUploadPopup(left_grid, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			}
		});
		
		//----------그리드
		left_grid_columns = [
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			,{id : "EVENT_GRUP_CD", label:["행사그룹코드"], type: "ro", width: "90", align : "left", isHidden : false, isEssential : false}
			,{id : "EVENT_TITLE", label:["행사제목"], type: "ed", width: "220", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "EVENT_TYPE", label:["유형"], type: "combo", width: "60", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["PUR_SALE_TYPE"]}
			,{id : "BEGIN_DATE", label:["적용시작일"], type: "dhxCalendarA", width: "80", align : "center", isHidden : false, isEssential : true}
			,{id : "END_DATE", label:["적용종료일"], type: "dhxCalendarA", width: "80", align : "center", isHidden : false, isEssential : true}
			,{id : "EVENT_STATE", label:["사용(Y/N)"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode :["YN_CD","YN"]}
			,{id : "CHG_REMK", label:["행사사유"], type: "ed", width: "200", align : "left", isHidden : false, isEssential : false}
		];
		
		left_grid = new dhtmlXGridObject({
			parent: "div_left_grid"
			,skin : ERP_GRID_CURRENT_SKINS
			,image_path : ERP_GRID_CURRENT_IMAGE_PATH
			,columns : left_grid_columns
		});
		
		left_grid.captureEventOnParentResize(left_layout);

		$erp.initGrid(left_grid, {useAutoAddRowPaste : true, standardColumnId : "EVENT_TITLE", deleteDuplication : true, overrideDuplication : false, editableColumnIdListOfInsertedRows : [], notEditableColumnIdListOfInsertedRows : []});
		
		left_grid.attachEvent("onRowDblClicked", function(rId, cInd){
			if(cInd != this.getColIndexById("EVENT_TITLE") && cInd != this.getColIndexById("BEGIN_DATE") && cInd != this.getColIndexById("END_DATE") && cInd != this.getColIndexById("EVENT_STATE")){
				right_top_ribbon.callEvent("onClick",["search_grid"]);
				right_bottom_ribbon.callEvent("onClick",["search_grid"]);
			}else{
				EVENT_TITLE = left_grid.cells(rId, left_grid.getColIndexById("EVENT_TITLE")).getValue();
				BEGIN_DATE = left_grid.cells(rId, left_grid.getColIndexById("BEGIN_DATE")).getValue();
				END_DATE = left_grid.cells(rId, left_grid.getColIndexById("END_DATE")).getValue();
				EVENT_STATE = left_grid.cells(rId, left_grid.getColIndexById("EVENT_STATE")).getValue();
				left_grid.editCell(EVENT_TITLE, BEGIN_DATE, END_DATE, EVENT_STATE);
			}
		});
	}
	
	function searchLeftGrid() {
		var send_data = $erp.dataSerialize("tb_search_01");
		send_data["PAGE_TYPE"] = pageType;
		
		var url = "/sis/price/getCenterEventList.do";
		var if_success = function(data){
			$erp.clearDhtmlXGrid(left_grid); //기존데이터 삭제
			if($erp.isEmpty(data.gridDataList)){
				//검색 결과 없음
				$erp.addDhtmlXGridNoDataPrintRow(left_grid, '<spring:message code="info.common.noDataSearch" />');
			}else{
				left_grid.parse(data.gridDataList,'js');
			}
			$erp.setDhtmlXGridFooterRowCount(left_grid); // 현재 행수 계산
		}
		
		var if_error = function(){
		
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, left_layout);
	}
	
	<%-- left_layout 관련 초기화 끝 --%>
	

	<%-- right_top_layout 관련 초기화 시작 --%>
	//오른쪽
	function init_right_top_layout(){
		right_top_layout = new dhtmlXLayoutObject({
			parent: "div_right_top_layout"
			,skin : ERP_LAYOUT_CURRENT_SKINS
			,pattern: "2E"
			,cells: [
// 				{id: "a", text: "조회조건", header:false, width:300}
				{id: "a", text: "리본", header:false, fix_size : [false, true]}
				,{id: "b", text: "그리드", header:false, fix_size : [false, true]}
			]
		});
		
		right_top_layout.captureEventOnParentResize(total_layout); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.
		
		right_top_layout.cells("a").attachObject("div_right_top_ribbon");
		right_top_layout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		right_top_layout.cells("b").attachObject("div_right_top_grid");
		
		right_top_layout.setSeparatorSize(0, 1);
		
		//----------리본
		right_top_ribbon = new dhtmlXRibbon({
			parent : "div_right_top_ribbon"
			,skin : ERP_RIBBON_CURRENT_SKINS
			,icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			,items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_grid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					,{id : "add_grid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true, isHidden : true}
					,{id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true, isHidden : true}
					,{id : "save_grid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true, isHidden : true}
					,{id : "excel_grid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, isHidden : true}
					,{id : "excel_grid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, isHidden : true}
				]}
			]
		});
		
		var warning_pr_rowId_obj = {};
		right_top_ribbon.attachEvent("onClick", function(itemId, bId){
			var selectedRowId = left_grid.getSelectedRowId();
			if(!selectedRowId){
				$erp.alertMessage({
					"alertMessage" : "선택된 행사가 없습니다.",
					"alertType" : "error",
					"isAjax" : false
				});
				return;
			}
			var selectedEVENT_GRUP_CD = left_grid.cells(selectedRowId, left_grid.getColIndexById("EVENT_GRUP_CD")).getValue();
			if(itemId == "search_grid"){
				var url = "/sis/price/getCenterEventGoodsList.do";
				var send_data = $erp.unionObjArray([$erp.dataSerialize("tb_search_01"),{"EVENT_GRUP_CD" : selectedEVENT_GRUP_CD}]);
				var if_success = function(data){
					$erp.clearDhtmlXGrid(right_top_grid); //기존데이터 삭제
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(right_top_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						right_top_grid.parse(data.gridDataList,'js');
					}
					warning_pr_rowId_obj = {};
					$erp.setDhtmlXGridFooterRowCount(right_top_grid);	// 현재 행수 계산
				}
				
				var if_error = function(XHR, status, error){
				}
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			}else if (itemId == "add_grid"){
				var ORGN_DIV_CD = cmbORGN_DIV_CD.getSelectedValue();
				var onClickRibbonAddData = function(popupGrid){
					//dataState : checked,selected  //copyType : add,new
					var popup = erpPopupWindows.window("openSearchGoodsGridPopup");
					popup.progressOn();
					$erp.copyRowsGridToGrid(popupGrid, right_top_grid, ["BCD_CD","BCD_NM"], ["BCD_CD","BCD_NM"], "checked", "add", ["BCD_CD"], [], {"TAX_YN" : "Y", "USE_YN" : "Y"}, {"TAX_YN" : "Y", "USE_YN" : "Y"}, function(result){
						popup.progressOff();
						popup.close();
						
						loadGoods(result);
					},false);
				}
				$erp.openSearchGoodsPopup(null, onClickRibbonAddData,{"ORGN_DIV_CD" : ORGN_DIV_CD});
			}else if (itemId == "delete_grid"){
				$erp.deleteGridCheckedRows(right_top_grid);
			}else if (itemId == "save_grid"){
				if(pageType =="S"){
					var isExistWarning = false;
					var firstWarningRowIndex = -999;
					var warningRowCount = 0;
					for(key in warning_pr_rowId_obj){
						if(warning_pr_rowId_obj[key] != null){
							if(firstWarningRowIndex == -999){
								isExistWarning = true;
								firstWarningRowIndex = right_top_grid.getRowIndex(key);
							}
							warningRowCount++;
						}
					}
					
					var exec = function(){
						$erp.gridValidationCheck(right_top_grid, function(){
							var url = "/sis/price/crudCenterEventGoodsList.do";
//							var data1 = $erp.unionObjArray([$erp.dataSerialize("tb_search_01"),{"EVENT_GRUP_CD" : selectedEVENT_GRUP_CD}]);
							var data2 = $erp.dataSerializeOfGridByCRUD(right_top_grid, false, {"EVENT_GRUP_CD" : selectedEVENT_GRUP_CD});
							var send_data = data2;
							var if_success = function(data){
								if(data.isErrorExist == 1){
									$erp.alertMessage({
										"alertMessage" : data.errorMessage,
										"alertCode" : "저장에 실패하였습니다.",
										"alertType" : "error",
										"isAjax" : false,
										"alertCallbackFn" : function(){
//											right_top_ribbon.callEvent("onClick",["search_grid"]);
										}
									});
									
								}else{
									$erp.alertSuccessMesage(function(){
										right_top_ribbon.callEvent("onClick",["search_grid"]);
									});
								}
							}
							var if_error = function(XHR, status, error){
							}
							$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, right_top_layout);
						});
					};
					
					if(isExistWarning){
						
						//마지막으로 추가한 로우 선택
						right_top_grid.selectRow(firstWarningRowIndex,false,false,true);
						// 1.인덱스
						// 2.선택만 할 것인지 선택 이벤트도 발생시킬 것인지
						// 3.이전 선택유지하면서 추가로 선택 할 것인지(다중선택)
						// 4.그리드의 현재 보이지 않는 위치에 있으면 스크롤 해서 보여줄 것인지
						
						$erp.confirmMessage({
							"alertMessage" : "기준이익율보다 낮은 행사상품이 있습니다.<br/>계속 진행 하시겠습니까?<br/>[저이익율 상품수 : " + warningRowCount + "]",
							"alertType" : "alert",
							"isAjax" : false,
							"alertCallbackFn" : function(){
								exec();
							},
							"alertCallbackFnParam" : [],
							"alertCallbackFnFalse" : function(){},
							"alertCallbackFnParamFalse" : []
						});
					}else{
						exec();
					}
				}else if(pageType =="P"){
					var execp = function(){
						$erp.gridValidationCheck(right_top_grid, function(){
							var url = "/sis/price/crudCenterEventGoodsPurList.do";
//							var data1 = $erp.unionObjArray([$erp.dataSerialize("tb_search_01"),{"EVENT_GRUP_CD" : selectedEVENT_GRUP_CD}]);
							var data2 = $erp.dataSerializeOfGridByCRUD(right_top_grid, false, {"EVENT_GRUP_CD" : selectedEVENT_GRUP_CD});
							var send_data = data2;
							var if_success = function(data){
								if(data.isErrorExist == 1){
									$erp.alertMessage({
										"alertMessage" : data.errorMessage,
										"alertCode" : "저장에 실패하였습니다.",
										"alertType" : "error",
										"isAjax" : false,
										"alertCallbackFn" : function(){
//											right_top_ribbon.callEvent("onClick",["search_grid"]);
										}
									});
									
								}else{
									$erp.alertSuccessMesage(function(){
										right_top_ribbon.callEvent("onClick",["search_grid"]);
									});
								}
							}
							var if_error = function(XHR, status, error){
							}
							$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
						});
					};
					
					execp();
				}
			}else if (itemId == "excel_grid"){
				if(pageType == "S"){
					$erp.exportGridToExcel({	
						"grid" : right_top_grid
						,"fileName" : "행사상품등록양식(판매)"
						,"isOnlyEssentialColumn" : true	//필수컬럼만
						,"excludeColumnIdList" : []		//추가로 제외하고 싶은 컬럼 아이디 리스트
						,"isIncludeHidden" : false		//히든컬럼 포함
						,"isExcludeGridData" : false	//그리드 데이터 제외
					});
				}else if(pageType == "P"){
					$erp.exportGridToExcel({
						"grid" : right_top_grid
						,"fileName" : "행사상품등록양식(구매)"
						,"isOnlyEssentialColumn" : true	//필수컬럼만
						,"excludeColumnIdList" : []		//추가로 제외하고 싶은 컬럼 아이디 리스트
						,"isIncludeHidden" : false		//히든컬럼 포함
						,"isExcludeGridData" : false	//그리드 데이터 제외
					});
				}
			}else if (itemId == "excel_grid_upload"){
				var convertModuleUrl = ""; //엑셀로 컨버트 하는 모듈을 다른것을 사용하고자 할때만 사용
				var uploadFileLimitCount = 1; //파일 업로드 개수 제한
				var onUploadFile = function(files, uploadData, toGrid){
					$erp.uploadDataParse(this, files, uploadData, toGrid, "BCD_CD", "add", ["BCD_CD"], []);
				}
				var onUploadComplete = function(uploadedFileInfoList, toGrid, result){
					loadGoods(result);
				}
				var onBeforeFileAdd = function(file){};
				var onBeforeClear = function(){};
				$erp.excelUploadPopup(right_top_grid, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			}
			
		});
		
		//----------그리드
		if(pageType == "S"){
			right_top_grid_columns = [
				{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
				,{id : "CHECK", label:["#master_checkbox"], type: "ch", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
				,{id : "BCD_CD", label:["상품바코드"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
				,{id : "BCD_NM", label:["상품명"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : false}
				,{id : "DIMEN_NM", label:["규격"], type: "ro", width: "70", sort : "str", align : "left", isHidden : false, isEssential : false}
				,{id : "SALE_PRICE", label:["정상출고가"], type: "ron", width: "100", sort : "int", align : "right", numberFormat : "0,000", isEssential : false}
				,{id : "PROF_RATE", label:["기준이익율"], type: "ron", width: "100", sort : "int", align : "right", numberFormat : "0.00%", isEssential : false}
				,{id : "RCMD_SALE_PRICE", label:["권장판매가"], type: "ron", width: "100", sort : "int", align : "right", numberFormat : "0,000", isEssential : false}
				,{id : "SALE_EVENT_PRICE", label:["행사출고가"], type: "edn", width: "100", sort : "int", align : "right", numberFormat : "0,000", isEssential : true, isSelectAll : true}
				,{id : "CHANGE_PROF_RATE", label:["행사이익율"], type: "ron", width: "100", sort : "int", align : "right", numberFormat : "0.00%", isEssential : false}
				,{id : "TAX_YN", label:["부가세(Y/N)"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["YN_CD","YN"]}
				,{id : "USE_YN", label:["사용(Y/N)"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["YN_CD","YN"]}
				,{id : "REMK", label:["비고"], type: "ed", width: "150", sort : "int", align : "left", isEssential : false}
			];
			
			right_top_grid = new dhtmlXGridObject({
				parent: "div_right_top_grid"
				,skin : ERP_GRID_CURRENT_SKINS
				,image_path : ERP_GRID_CURRENT_IMAGE_PATH
				,columns : right_top_grid_columns
			});
			
			right_top_grid.captureEventOnParentResize(right_top_layout);

			$erp.initGrid(right_top_grid, {useAutoAddRowPaste : true, standardColumnId : "BCD_CD", deleteDuplication : true, overrideDuplication : false, editableColumnIdListOfInsertedRows : ["BCD_CD"], notEditableColumnIdListOfInsertedRows : []});
			
			//requestAddRowCount						//아무런 처리없이 추가 요청한 데이터 초기 로우수
			//newAddRowDataList							//새로 추가된 로우 데이타 리스트
			//standardColumnValue_indexAndRowId_obj		//기준 컬럼의 값을 key, [인덱스,로우아이디]를 value 로 가진 객체
			//insertedRowIndexList						//로우 상태가 inserted 인 로우인덱스 리스트
			//editableColumnIdListOfInsertedRows		//로우 상태가 inserted 인 로우의 수정가능한 컬럼 Id 리스트
			//notEditableColumnIdListOfInsertedRows		//로우 상태가 inserted 인 로우의 수정불가능한 컬럼 Id 리스트
			//duplicationCount_in_toGridDataList		//toGrid 에 추가중 발생한 중복 데이터 개수
			right_top_grid.attachEvent("onEndPaste", function(result){
				loadGoods(result);
			});
			
			right_top_grid.attachEvent("onCellChanged", function (rowId,columnIdx,newValue){
				if(right_top_grid.getColumnId(columnIdx) == "SALE_EVENT_PRICE"){
					let sp; 				//센터출고가
					let pr; 				//기준이익율
					let original_price;
					let change_pr_price;	//변경된 이익액
					let change_pr;			//변경된 이익율
					
					sp = right_top_grid.cells(rowId, right_top_grid.getColIndexById("SALE_PRICE")).getValue();
					
					if(newValue == 0){
						
					}else{
						if(sp == newValue){
							pr = right_top_grid.cells(rowId, right_top_grid.getColIndexById("PROF_RATE")).getValue();
							change_pr = pr;
							right_top_grid.cells(rowId, right_top_grid.getColIndexById("CHANGE_PROF_RATE")).setValue(pr);
						}else{
							sp = parseInt(sp);
							pr = parseFloat(right_top_grid.cells(rowId, right_top_grid.getColIndexById("PROF_RATE")).getValue());
							original_price = sp/(100 + pr)*100;
							change_pr_price = newValue - original_price; //변경된 이익액
							if(change_pr_price == 0){
								change_pr = 0;
							}else{
								change_pr = (change_pr_price/newValue)*100;
							}
						}
						
						setTimeout(function(){
							right_top_grid.cells(rowId, right_top_grid.getColIndexById("CHANGE_PROF_RATE")).setValue(change_pr);
							
							if(change_pr < pr){
								right_top_grid.cells(rowId, right_top_grid.getColIndexById("SALE_EVENT_PRICE")).setBgColor('#F6CED8');
								right_top_grid.cells(rowId, right_top_grid.getColIndexById("CHANGE_PROF_RATE")).setBgColor('#F6CED8');
								right_top_grid.cells(rowId, right_top_grid.getColIndexById("TAX_YN")).setBgColor('#FFFFE0');
								right_top_grid.cells(rowId, right_top_grid.getColIndexById("USE_YN")).setBgColor('#FFFFE0');
								warning_pr_rowId_obj[rowId] = rowId;
							}else{
								right_top_grid.cells(rowId, right_top_grid.getColIndexById("SALE_EVENT_PRICE")).setBgColor('#FFFFE0');
								right_top_grid.cells(rowId, right_top_grid.getColIndexById("CHANGE_PROF_RATE")).setBgColor('#FFFFFF');
								right_top_grid.cells(rowId, right_top_grid.getColIndexById("TAX_YN")).setBgColor('#FFFFE0');
								right_top_grid.cells(rowId, right_top_grid.getColIndexById("USE_YN")).setBgColor('#FFFFE0');
								warning_pr_rowId_obj[rowId] = null;
							}
							
						},50);
					}
				}
			});
		}else if(pageType == "P"){
			right_top_grid_columns = [
				{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
				,{id : "CHECK", label:["#master_checkbox"], type: "ch", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
				,{id : "BCD_CD", label:["상품바코드"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
				,{id : "BCD_NM", label:["상품명"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : false}
				,{id : "DIMEN_NM", label:["규격"], type: "ro", width: "70", sort : "str", align : "left", isHidden : false, isEssential : false}
				,{id : "PUR_PRICE", label:["정상입고가"], type: "ron", width: "100", sort : "int", align : "right", numberFormat : "0,000", isEssential : false}
				,{id : "PROF_RATE", label:["기준이익율"], type: "ron", width: "100", sort : "int", align : "right", numberFormat : "0.00%", isEssential : false, isHidden : true}
				,{id : "SALE_EVENT_PRICE", label:["행사입고가"], type: "edn", width: "100", sort : "int", align : "right", numberFormat : "0,000", isEssential : true, isSelectAll : true}
				,{id : "CHANGE_PROF_RATE", label:["행사이익율"], type: "ron", width: "100", sort : "int", align : "right", numberFormat : "0.00%", isEssential : false}
				,{id : "TAX_YN", label:["부가세"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["YN_CD","YN"]}
				,{id : "USE_YN", label:["사용"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["YN_CD","YN"]}
				,{id : "REMK", label:["비고"], type: "ed", width: "150", sort : "int", align : "left", isEssential : false}
			];
			
			right_top_grid = new dhtmlXGridObject({
				parent: "div_right_top_grid"
				,skin : ERP_GRID_CURRENT_SKINS
				,image_path : ERP_GRID_CURRENT_IMAGE_PATH
				,columns : right_top_grid_columns
			});
			
			$erp.initGrid(right_top_grid, {useAutoAddRowPaste : true, standardColumnId : "BCD_CD", deleteDuplication : true, overrideDuplication : false, editableColumnIdListOfInsertedRows : ["BCD_CD"], notEditableColumnIdListOfInsertedRows : []});
			right_top_grid.attachEvent("onEndPaste", function(result){
				loadGoods(result);
			});
			right_top_grid.enableColumnMove(true);
			
			right_top_grid.attachEvent("onCellChanged", function (rowId,columnIdx,newValue){
				if(right_top_grid.getColumnId(columnIdx) == "SALE_EVENT_PRICE"){
					let pr; 				//정상입고가
					let sp; 				//행사입고가
					let change_pr;			//행사이익율
					
					pr = right_top_grid.cells(rowId, right_top_grid.getColIndexById("PUR_PRICE")).getValue();
					sp = right_top_grid.cells(rowId, right_top_grid.getColIndexById("SALE_EVENT_PRICE")).getValue();
					
					pr = parseInt(pr);
					sp = parseInt(sp);
					
					change_pr = 100-((sp/pr) * 100);
					
					right_top_grid.cells(rowId, right_top_grid.getColIndexById("CHANGE_PROF_RATE")).setValue(change_pr);
					
					setTimeout(function(){
						right_top_grid.cells(rowId, right_top_grid.getColIndexById("CHANGE_PROF_RATE")).setValue(change_pr);
							
						if(change_pr < 0){
							right_top_grid.cells(rowId, right_top_grid.getColIndexById("SALE_EVENT_PRICE")).setBgColor('#F6CED8');
							right_top_grid.cells(rowId, right_top_grid.getColIndexById("CHANGE_PROF_RATE")).setBgColor('#F6CED8');
							right_top_grid.cells(rowId, right_top_grid.getColIndexById("TAX_YN")).setBgColor('#FFFFE0');
							right_top_grid.cells(rowId, right_top_grid.getColIndexById("USE_YN")).setBgColor('#FFFFE0');
							warning_pr_rowId_obj[rowId] = rowId;
						}else{
							right_top_grid.cells(rowId, right_top_grid.getColIndexById("SALE_EVENT_PRICE")).setBgColor('#FFFFE0');
							right_top_grid.cells(rowId, right_top_grid.getColIndexById("CHANGE_PROF_RATE")).setBgColor('#FFFFFF');
							right_top_grid.cells(rowId, right_top_grid.getColIndexById("TAX_YN")).setBgColor('#FFFFE0');
							right_top_grid.cells(rowId, right_top_grid.getColIndexById("USE_YN")).setBgColor('#FFFFE0');
							warning_pr_rowId_obj[rowId] = null;
						}
							
					},50);
				}	
			});
		}
	}
	
	function loadGoods(result){
		var loadGoodsList = [];
		for(var index in result.newAddRowDataList){
			loadGoodsList.push(result.newAddRowDataList[index]["BCD_CD"]);
		}
		var url = "/sis/price/getCenterEventGoodsInfo.do";
		var send_data = {"loadGoodsList" : loadGoodsList};
		var if_success = function(data){
			var gridDataList = data.gridDataList;
			if(pageType == "S"){
				for(var index in gridDataList){
					right_top_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], right_top_grid.getColIndexById("BCD_NM")).setValue(gridDataList[index]["BCD_NM"]);
					right_top_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], right_top_grid.getColIndexById("DIMEN_NM")).setValue(gridDataList[index]["DIMEN_NM"]);
					right_top_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], right_top_grid.getColIndexById("SALE_PRICE")).setValue(gridDataList[index]["SALE_PRICE"]);
					right_top_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], right_top_grid.getColIndexById("PROF_RATE")).setValue(gridDataList[index]["PROF_RATE"]);
					right_top_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], right_top_grid.getColIndexById("RCMD_SALE_PRICE")).setValue(gridDataList[index]["RCMD_SALE_PRICE"]);
					right_top_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], right_top_grid.getColIndexById("TAX_YN")).setValue("Y");
					right_top_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], right_top_grid.getColIndexById("USE_YN")).setValue("Y");
					result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]].push("로드완료");
				}
			}else if(pageType == "P"){
				for(var index in gridDataList){
					right_top_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], right_top_grid.getColIndexById("BCD_NM")).setValue(gridDataList[index]["BCD_NM"]);
					right_top_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], right_top_grid.getColIndexById("DIMEN_NM")).setValue(gridDataList[index]["DIMEN_NM"]);
					right_top_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], right_top_grid.getColIndexById("PUR_PRICE")).setValue(gridDataList[index]["PUR_PRICE"]);
					right_top_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], right_top_grid.getColIndexById("TAX_YN")).setValue("Y");
					right_top_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], right_top_grid.getColIndexById("USE_YN")).setValue("Y");
					result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]].push("로드완료");
				}
			}
			var notExistList = [];
			var value;
			var state;
			var dp = right_top_grid.getDataProcessor();
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["BCD_CD"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			$erp.deleteGridRows(right_top_grid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>[무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			if(right_top_grid.getRowsNum() == 0){
				right_top_ribbon.callEvent("onClick",["search_grid"]);
				return;
			}
			
			$erp.setDhtmlXGridFooterRowCount(right_top_grid);	// 현재 행수 계산
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, right_top_layout);
	}
	<%-- right_top_layout 관련 초기화 끝 --%>
	
	<%-- right_bottom_layout 관련 초기화 시작 --%>
	function init_right_bottom_layout(){
		right_bottom_layout = new dhtmlXLayoutObject({
			parent: "div_right_bottom_layout"
			,skin : ERP_LAYOUT_CURRENT_SKINS
			,pattern: "2E"
			,cells: [
//				{id: "a", text: "조회조건", header:false, width:300}
				{id: "a", text: "리본", header:false, fix_size : [false, true]}
				,{id: "b", text: "그리드", header:false, fix_size : [false, true]}
			]
		});
		right_bottom_layout.captureEventOnParentResize(total_layout); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.
		
		right_bottom_layout.cells("a").attachObject("div_right_bottom_ribbon");
		right_bottom_layout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		right_bottom_layout.cells("b").attachObject("div_right_bottom_grid");
		
		right_bottom_layout.setSeparatorSize(0, 1);
		
		//----------리본
		right_bottom_ribbon = new dhtmlXRibbon({
			parent : "div_right_bottom_ribbon"
			,skin : ERP_RIBBON_CURRENT_SKINS
			,icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			,items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_grid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					,{id : "add_grid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					,{id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					,{id : "save_grid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					,{id : "excel_grid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					,{id : "excel_grid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, isHidden : true}
				]}
			]
		});
		
		right_bottom_ribbon.attachEvent("onClick", function(itemId, bId){
			var selectedRowId = left_grid.getSelectedRowId();
			if(!selectedRowId){
				$erp.alertMessage({
					"alertMessage" : "선택된 행사가 없습니다.",
					"alertType" : "error",
					"isAjax" : false
				});
				return;
			}
			var selectedEVENT_GRUP_CD = left_grid.cells(selectedRowId, left_grid.getColIndexById("EVENT_GRUP_CD")).getValue();
			if(itemId == "search_grid"){
				var url = "/sis/price/getCenterEventCustmrList.do";
				var send_data = $erp.unionObjArray([$erp.dataSerialize("tb_search_01"),{"EVENT_GRUP_CD" : selectedEVENT_GRUP_CD}]);
				var if_success = function(data){
					$erp.clearDhtmlXGrid(right_bottom_grid); //기존데이터 삭제
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(right_bottom_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						right_bottom_grid.parse(data.gridDataList,'js');
					}
					$erp.setDhtmlXGridFooterRowCount(right_bottom_grid);	// 현재 행수 계산
				}
				
				var if_error = function(XHR, status, error){
				}
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, null);
			}else if (itemId == "add_grid"){
				if(pageType == "S"){
					var onClickRibbonAddData = function(popupGrid){
						//dataState : checked,selected  //copyType : add,new
						var popup = erpPopupWindows.window("openSearchCustmrGridPopup");
						popup.progressOn();
						//dataState : checked,selected  //copyType : add,new
						$erp.copyRowsGridToGrid(popupGrid, right_bottom_grid, ["CUSTMR_CD","CUSTMR_NM","PUR_SALE_TYPE","USE_YN"], ["CUSTMR_CD","CUSTMR_NM","TRADE_TYPE","USE_YN"], "checked", "add", ["CUSTMR_CD"], [], {"TAX_YN" : "Y", "USE_YN" : "Y"}, {"TAX_YN" : "Y", "USE_YN" : "Y"}, function(){
							popup.progressOff();
							popup.close();
						});
					}
					$erp.searchCustmrPopup(null, "2", onClickRibbonAddData);
				}else if(pageType == "P"){
					var onClickRibbonAddData = function(popupGrid){
						//dataState : checked,selected  //copyType : add,new
						var popup = erpPopupWindows.window("openSearchCustmrGridPopup");
						popup.progressOn();
						//dataState : checked,selected  //copyType : add,new
						$erp.copyRowsGridToGrid(popupGrid, right_bottom_grid, ["CUSTMR_CD","CUSTMR_NM","PUR_SALE_TYPE","USE_YN"], ["CUSTMR_CD","CUSTMR_NM","TRADE_TYPE","USE_YN"], "checked", "add", ["CUSTMR_CD"], [], {"TAX_YN" : "Y", "USE_YN" : "Y"}, {"TAX_YN" : "Y", "USE_YN" : "Y"}, function(){
							popup.progressOff();
							popup.close();
						});
					}
					$erp.searchCustmrPopup(null, "1", onClickRibbonAddData);
				}
			}else if (itemId == "delete_grid"){
				$erp.deleteGridCheckedRows(right_bottom_grid);
			}else if (itemId == "save_grid"){
				var url = "/sis/price/crudCenterEventCustmrList.do";
//				var data1 = $erp.unionObjArray([$erp.dataSerialize("tb_search_01"),{"EVENT_GRUP_CD" : selectedEVENT_GRUP_CD}]);
				var data2 = $erp.dataSerializeOfGridByCRUD(right_bottom_grid,false, {"EVENT_GRUP_CD" : selectedEVENT_GRUP_CD});
				var send_data = data2;
				var if_success = function(data){
					if(data.isErrorExist == 1){
						$erp.alertMessage({
							"alertMessage" : data.errorMessage,
							"alertCode" : "저장에 실패하였습니다.",
							"alertType" : "error",
							"isAjax" : false,
							"alertCallbackFn" : function(){
//								right_bottom_ribbon.callEvent("onClick",["search_grid"]);
							}
						});
					}else{
						$erp.alertSuccessMesage(function(){
							right_bottom_ribbon.callEvent("onClick",["search_grid"]);
						});
					}
				}
				var if_error = function(XHR, status, error){
				}
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, right_bottom_layout);
			}else if (itemId == "excel_grid"){
				$erp.exportGridToExcel({
					"grid" : right_bottom_grid
					,"fileName" : "행사거래처등록양식"
					,"isOnlyEssentialColumn" : true
					,"excludeColumnIdList" : []
					,"isIncludeHidden" : false
					,"isExcludeGridData" : false
				});
			}else if (itemId == "excel_grid_upload"){
				var convertModuleUrl = ""; //엑셀로 컨버트 하는 모듈을 다른것을 사용하고자 할때만 사용
				var uploadFileLimitCount = 1; //파일 업로드 개수 제한
				var onUploadFile = function(files, uploadData, toGrid){
					$erp.uploadDataParse(this, files, uploadData, toGrid, "CUSTMR_CD", "add", ["CUSTMR_CD"], []);
				}
				var onUploadComplete = function(uploadedFileInfoList, toGrid, result){
					loadCustmr(result);
				}
				var onBeforeFileAdd = function(file){};
				var onBeforeClear = function(){};
				$erp.excelUploadPopup(right_bottom_grid, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			}
		});
		
		//----------그리드
		right_bottom_grid_columns = [
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "CHECK", label:["#master_checkbox"], type: "ch", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			,{id : "GRUP_NM", label:["거래처그룹명"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "CUSTMR_NM", label:["거래처명"], type: "ro", width: "240", align : "left", isHidden : false, isEssential : false}
			,{id : "TRADE_TYPE", label:["거래유형"], type: "combo", width: "80", align : "center", isHidden : false, isEssential : false, commonCode : "TRADE_TYPE", isDisabled : true}
			,{id : "USE_YN", label:["사용(Y/N)"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["YN_CD","YN"]}
			,{id : "GRUP_CD", label:["거래처그룹코드"], type: "ro", width: "90", sort : "str", align : "left", isHidden : true, isEssential : true}
			,{id : "CUSTMR_CD", label:["거래처코드"], type: "ro", width: "90", sort : "str", align : "center", isHidden : false, isEssential : true}
		];
		
		right_bottom_grid = new dhtmlXGridObject({
			parent: "div_right_bottom_grid"
			,skin : ERP_GRID_CURRENT_SKINS
			,image_path : ERP_GRID_CURRENT_IMAGE_PATH
			,columns : right_bottom_grid_columns
		});

		right_bottom_grid.captureEventOnParentResize(right_bottom_layout);
		
		$erp.initGrid(right_bottom_grid, {useAutoAddRowPaste : true, standardColumnId : "CUSTMR_CD", deleteDuplication : true, overrideDuplication : false, editableColumnIdListOfInsertedRows : ["CUSTMR_CD"], notEditableColumnIdListOfInsertedRows : []});
		
		//requestAddRowCount						//아무런 처리없이 추가 요청한 데이터 초기 로우수
		//newAddRowDataList							//새로 추가된 로우 데이타 리스트
		//standardColumnValue_indexAndRowId_obj		//기준 컬럼의 값을 key, [인덱스,로우아이디]를 value 로 가진 객체
		//insertedRowIndexList						//로우 상태가 inserted 인 로우인덱스 리스트
		//editableColumnIdListOfInsertedRows		//로우 상태가 inserted 인 로우의 수정가능한 컬럼 Id 리스트
		//notEditableColumnIdListOfInsertedRows		//로우 상태가 inserted 인 로우의 수정불가능한 컬럼 Id 리스트
		//duplicationCount_in_toGridDataList		//toGrid 에 추가중 발생한 중복 데이터 개수
		right_bottom_grid.attachEvent("onEndPaste", function(result){
			loadCustmr(result);
		});

	}
	
	function loadCustmr(result){
		var loadCustmrList = [];
		var data;
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];
			loadCustmrList.push(data["CUSTMR_CD"]);
		}
		
		var url = "/sis/price/getCenterEventCustmrInfo.do";
		var send_data = {"loadCustmrList" : loadCustmrList};
		var if_success = function(data){
			var gridDataList = data.gridDataList;
			for(var index in gridDataList){
				right_bottom_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["CUSTMR_CD"]][1], right_bottom_grid.getColIndexById("CUSTMR_NM")).setValue(gridDataList[index]["CUSTMR_NM"]);
				right_bottom_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["CUSTMR_CD"]][1], right_bottom_grid.getColIndexById("TRADE_TYPE")).setValue(gridDataList[index]["TRADE_TYPE"]);
//				right_bottom_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["CUSTMR_CD"]][1], right_bottom_grid.getColIndexById("USE_YN")).setValue("Y");
				result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["CUSTMR_CD"]].push("로드완료");
			}
			
			var notExistList = [];
			var value;
			var state;
			var dp = right_bottom_grid.getDataProcessor();
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["CUSTMR_CD"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			
			$erp.deleteGridRows(right_bottom_grid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>[무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			if(right_bottom_grid.getRowsNum() == 0){
				right_bottom_ribbon.callEvent("onClick",["search_grid"]);
				return;
			}
			
			$erp.setDhtmlXGridFooterRowCount(right_bottom_grid); // 현재 행수 계산
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, right_bottom_layout);
	}
	<%-- right_bottom_layout 관련 초기화 끝 --%>
	
</script>
</head>
<body>
	<%-- 왼쪽 --%>
	<div id="div_left_layout" class="samyang_div" style="display:none">
		
		<div id="div_left_table" class="samyang_div" style="display:none">
			<table id="tb_search_01" class="table">
				<colgroup>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th colspan="1">법인구분</th>
					<td colspan="6"><div id="cmbORGN_DIV_CD"></div></td>
					<td colspan="4"><div id="cmbORGN_CD" style="display:none"></div></td>
				</tr>
				<tr>
					<th colspan="1">행사가그룹</th>
					<td colspan="2">
						<input type="hidden" id="txtEVENT_GRUP_CD" name="EVENT_GRUP_CD" value="">
						<input type="text" id="txtEVENT_GRUP_NM" name="EVENT_GRUP_NM" value="" class="input_common input_readonly" maxlength="20" readonly="readonly">
						<input type="button" id="search_member_code" class="input_common_button" onclick="openGoodsEventPriceGroupPopup()" value="검색"/>
					</td>
					<th colspan="1">사용여부</th>
					<td colspan="4">
						<div style="float:left;" id="cmbEVENT_STATE"></div>
					</td>
				</tr>
				<tr>
					<th>적용일자</th>
					<td colspan="7">
						<input type="text" id="txtDATE_FR" class="input_calendar" value=""/>
						<span style="float: left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO" class="input_calendar" value="" style="float: left; margin-left: 6px;"/>
					</td>
				</tr>
			</table>
		</div>
	
		<div id="div_left_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_left_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	
	<%-- 오른쪽 상단 --%>
	<div id="div_right_top_layout" class="samyang_div" style="display:none">
		<div id="div_right_top_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_right_top_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	
	<%-- 오른쪽 하단 --%>
	<div id="div_right_bottom_layout" class="samyang_div" style="display:none">
		<div id="div_right_bottom_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_right_bottom_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	
</body>
</html>