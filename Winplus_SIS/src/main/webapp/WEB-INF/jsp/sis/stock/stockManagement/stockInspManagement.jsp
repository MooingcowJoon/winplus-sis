<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">

	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');

	var erpLayout;
	var erpMainLayout;
	var erpSubLayout;
	var erpRibbon;
	var erpSubRibbon;
	var erpGrid;
	var erpSubGrid;
	var erpGridColumns;
	var erpSubGridColumns;
	var cmbORGN_CD;
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	var erpGridDateColumns;
	var erpGridDataProcessor;
	var erpSubGridDateColumns;
	var erpSubGridDataProcessor;
	
	var strUNI_KEY = "";
	var selected_orgn_cd;
	var selected_orgn_div_cd;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
	
		initErpLayout();
		
		initErpMainLayout();
		initErpSubLayout();
		
		initErpRibbon();
		initErpSubRibbon();
		
		initErpGrid();
		initErpSubGrid();
		
		initDhtmlXCombo();
		document.getElementById("searchDate").value=today;
		
		$erp.asyncObjAllOnCreated(function(){
			
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "재고실사 관리", header: false , fix_size:[true, true]}
				, {id : "b", text: "상세내역", header: false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_main_layout");
		erpLayout.cells("a").setHeight(400);
		erpLayout.cells("b").attachObject("div_erp_sub_layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpMainLayout.setSizes();
			erpGrid.setSizes();
			erpSubLayout.setSizes();
			erpSubGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpMainLayout 관련 Function 시작 --%>
	<%-- erpMainLayout 초기화 Function --%>
	function initErpMainLayout(){
		erpMainLayout = new dhtmlXLayoutObject({
			parent: "div_erp_main_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건", header:false , fix_size:[true, true]}
				, {id: "b", text: "리본", header:false , fix_size:[true, true]}
				, {id: "c", text: "그리드", header:false , fix_size:[true, true]}
			]		
		});
		erpMainLayout.cells("a").attachObject("div_erp_main_table");
		erpMainLayout.cells("a").setHeight($erp.getTableHeight(1));
		erpMainLayout.cells("b").attachObject("div_erp_main_ribbon");
		erpMainLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpMainLayout.cells("c").attachObject("div_erp_main_grid");	
	}	
	<%-- ■ erpMainLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	function initErpRibbon() {
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_main_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					, {id : "addInspData_erpGrid", type : "button", text:'재고실사 데이터 생성', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : false}
				]}
			]
		});	
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid") {
				searchErpGrid();
				searchErpSubGrid();
			} else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
			} else if (itemId == "addInspData_erpGrid"){
				var gridRowCount = erpGrid.getAllRowIds(",");
				var RowCountArray = gridRowCount.split(",");
				if(gridRowCount == ""){
					$erp.alertMessage({
						"alertMessage" : "error.common.noCheckedData"
						, "alertCode" : null
						, "alertType" : "notice"
					});
				}else{
					var addInspRowIdArray = [];
					var check = "";
					
					for(var i = 0 ; i < RowCountArray.length ; i++){
						check = erpGrid.cells(RowCountArray[i], erpGrid.getColIndexById("CHECK")).getValue();
						if(check == "1"){
							addInspRowIdArray.push(RowCountArray[i]);
						}
					}
					
					if(addInspRowIdArray.length == 0){
						$erp.alertMessage({
							"alertMessage" : "error.common.noCheckedData"
							, "alertCode" : null
							, "alertType" : "notice"
						});
						return;
					}else{
						$erp.confirmMessage({
							"alertMessage" : "재고실사 데이터를 생성하시겠습니까?",
							"alertType" : "alert",
							"isAjax" : false,
							"alertCallbackFn" : function(){
								saveErpGrid();
							}
						});
					}
				}
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid(){
		erpGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			,{id : "ORGN_CD", label : ["직영점", "#rspan"], type : "combo", width : "75", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			,{id : "ORGN_DIV_CD", label : ["조직구분코드", "#rspan"], type : "ro", width : "75", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "STORE_AREA", label:["실사구역", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "RESP_USER", label:["담당자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			,{id : "TOT_GOODS_NM", label:["품목명", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "TOT_CNT", label:["수량", "#rspan"], type: "ron", width: "85", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			,{id : "CDATE", label:["CDATE", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "UNI_KEY", label:["UNI_KEY", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_main_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});	
		
		erpGrid.attachEvent("onKeyPress",onKeyPressed);
		erpGrid.enableBlockSelection();
		erpGrid.enableDistributedParsing(true, 100, 50);
		erpGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		
		erpGrid.attachEvent("onRowDblClicked",function(rId,cInd){
			var ORGN_CD = erpGrid.cells(rId, erpGrid.getColIndexById("ORGN_CD")).getValue();
			var STORE_AREA = erpGrid.cells(rId, erpGrid.getColIndexById("STORE_AREA")).getValue();
			openStockInspListPopup(ORGN_CD, STORE_AREA);
		});
		
		
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		var str = document.getElementById("searchDate").value;
		var SEARCH_FROM_DATE = str.replace(/\-/g,'');
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		
		erpLayout.progressOn();
		$.ajax({
				url: "/sis/stock/stockManagement/getstockInspList.do" //재고실사 상단 조회
				, data : {
					 "SEARCH_FROM_DATE" : SEARCH_FROM_DATE
					 , "ORGN_CD" : ORGN_CD
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpGrid
								,  '<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
		});
	}
	<%-- erpGrid 조회 Function 끝--%>
	
	<%-- saveErpGrid 저장 Function --%>
	function saveErpGrid() {
		var str = document.getElementById("searchDate").value;
		var SEARCH_FROM_DATE = str.replace(/\-/g,'');
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpGrid);
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		
		var selectedRowId = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
		var checkList = selectedRowId.split(',');
		
		for(var i = 0 ; i < checkList.length ; i ++) {
			if(i != checkList.length -1){
				strUNI_KEY += erpGrid.cells(checkList[i], erpGrid.getColIndexById("UNI_KEY")).getValue() + ",";
			} else {
				strUNI_KEY += erpGrid.cells(checkList[i], erpGrid.getColIndexById("UNI_KEY")).getValue();
			}
		} 
		
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/stock/stockManagement/saveStockInspList.do" //재고실사 데이터 생성
			, data : { 
				"ORGN_CD" : ORGN_CD
				, "UNI_KEY" : strUNI_KEY
				, "SEARCH_FROM_DATE" : SEARCH_FROM_DATE
			}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpSubGrid);
					$erp.alertMessage({
						"alertMessage" : "생성이 완료 되었습니다.",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							searchErpSubGrid();
						}
					});
					strUNI_KEY="";
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- deleteErpGrid 삭제 Function --%>
	function deleteErpGrid(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var searchDate = document.getElementById("searchDate").value.replace(/\-/g,'');
		var orgnCd = cmbORGN_CD.getSelectedValue();
		
		if(searchDate == null || searchDate == ""){
			isValidated = false;
			alertMessage = "조회일자를 지정해야 합니다.";
			alertCode = "1";
		} else if(orgnCd == null || orgnCd == ""){
			isValidated = false;
			alertMessage = "선택된 직영점이 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : alertType
				,"isAjax" : false
				,"alertCallbackFn" : function(){
					if(alertCode == "1"){
						document.getElementById("searchDate").focus();
					}
				}
			});
		}else{
			var gridCheckedRowIds = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
			if(gridCheckedRowIds == ""){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
			}else{
				var gridCheckedRowArray = gridCheckedRowIds.split(",");
				
				if(gridCheckedRowArray == "NoDataPrintRow" || gridCheckedRowArray.length == 0){
					$erp.alertMessage({
						"alertMessage" : "error.common.noCheckedData"
						, "alertCode" : null
						, "alertType" : "notice"
					});
					return;
				}else{
					$erp.confirmMessage({
						"alertMessage" : "PDA자료를 삭제하시겠습니까?",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							
							var gridUnikeys = "";
							
							
							for(var i=0; i<gridCheckedRowArray.length; i++) {
								if(i != gridCheckedRowArray.length-1){
									gridUnikeys += erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("UNI_KEY")).getValue() + ",";
								} else {
									gridUnikeys += erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("UNI_KEY")).getValue();
								}
							}
							
							erpLayout.progressOn();
							$.ajax({
								url : "/sis/stock/transInOut/deletePdaData.do" //PDA자료 삭제
								, data : {
									"PDA_DATE" : searchDate
									,"OUT_ORGN_CD" : orgnCd
									,"UNI_KEYS" : gridUnikeys
									,"PDA_DATA_TYPE" : "1"			// 재고실사
								}
								, method : "POST"
								, dataType : "JSON"
								, success : function(data) {
									erpLayout.progressOff();
									if(data.isError){
										$erp.ajaxErrorMessage(data);
									}else {
										if(data.resultMsg == "SUCCESS"){
											$erp.clearDhtmlXGrid(erpGrid);
											$erp.alertMessage({
												"alertMessage" : "삭제가 완료 되었습니다.",
												"alertType" : "alert",
												"isAjax" : false,
												"alertCallbackFn" : function(){
													searchErpGrid();
												}
											});
										}else{
											$erp.alertMessage({
												"alertMessage" : "삭제 실패 하였습니다.",
												"alertType" : "alert",
												"isAjax" : false
											});
										}
									}
								}, error : function(jqXHR, textStatus, errorThrown){
									erpLayout.progressOff();
									$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
								}
							});
						}
					});
				}
			}
		}
	}
	<%-- erpGrid 삭제 Function 끝 --%>
	
	<%-- ■ erpSubLayout 관련 Function 시작 --%>
	<%-- erpSubLayout 초기화 Function --%>
	function initErpSubLayout() {
		erpSubLayout = new dhtmlXLayoutObject({
			parent : "div_erp_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				 {id: "a", text: "리본", header: false , fix_size:[true, true]}
				, {id: "b", text: "그리드", header: false , fix_size:[true, true]}
			]
		});
		
		erpSubLayout.cells("a").attachObject("div_erp_sub_ribbon");
		erpSubLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpSubLayout.cells("b").attachObject("div_erp_sub_grid");
	}
	<%-- ■ erpSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpSubRibbon 관련 Function 시작 --%>
	function initErpSubRibbon() {
		erpSubRibbon = new dhtmlXRibbon({
			parent : "div_erp_sub_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					//{id : "search_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					{id : "add_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
					,{id : "delete_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					,{id : "save_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false} 
					,{id : "excel_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : false}
					,{id : "addPart_sub_erpGrid", type : "button", text:'부분실사 적용', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : false}
					,{id : "addFull_sub_erpGrid", type : "button", text:'전체실사 적용', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : false}				
				]}
			]
		});	
		
		erpSubRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_sub_erpGrid"){
				var allRowIds = erpSubGrid.getAllRowIds();
				if(allRowIds == ""){
					$erp.alertMessage({
						"alertMessage" : "info.common.noData"
						, "alertCode" : null
						, "alertType" : "notice"
					});
				}else{
					openSearchGoodsGridPopup();
				}
			}else if (itemId == "search_sub_erpGrid"){
			}else if (itemId == "delete_sub_erpGrid"){
				deleteErpSubGrid();
			} else if (itemId == "save_sub_erpGrid"){
				saveErpSubGrid();
			} else if(itemId == "excel_sub_erpGrid") {
				$erp.exportDhtmlXGridExcel({
					"grid" : erpSubGrid
					, "fileName" : "재고실사관리"
					, "isForm" : false
				});
			} else if(itemId == "addPart_sub_erpGrid") {
				var allRowIds = erpSubGrid.getAllRowIds();
				if(allRowIds == ""){
					$erp.alertMessage({
						"alertMessage" : "info.common.noData"
						, "alertCode" : null
						, "alertType" : "notice"
					});
				}else{
					$erp.confirmMessage({
						"alertMessage" : "<span style='color:red; font-weight:bold;'>입력된 자료에 해당하는 품목</span>에 대해 현 재고가 적용 됩니다. 적용하시겠습니까?",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							savePartErpGrid();
						}
					});
				}
			} else if(itemId == "addFull_sub_erpGrid") {
				var allRowIds = erpSubGrid.getAllRowIds();
				if(allRowIds == ""){
					$erp.alertMessage({
						"alertMessage" : "info.common.noData"
						, "alertCode" : null
						, "alertType" : "notice"
					});
				}else{
					$erp.confirmMessage({
						"alertMessage" : "입력된 자료 기준으로 <span style='color:red; font-weight:bold;'>모든 품목과 현 재고</span>가 적용 됩니다. 적용하시겠습니까?",
						"alertType" : "alert",
						"isAjax" : false,
						"fontcolor" :"red",
						"alertCallbackFn" : function(){
							saveFullErpGrid();
						}
					});
				}
			}
		});
	}
	<%-- ■ erpSubRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpSubGrid 관련 Function 시작 --%>
	<%-- erpSubGrid 초기화 Function --%>
	function initErpSubGrid(){
		erpSubGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ro", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			,{id : "ORGN_CD", label : ["직영점", "#rspan"], type : "combo", width : "75", sort : "str", align : "center", isHidden : false, isEssential : true, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			,{id : "MODI_DATE", label : ["일자", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : true, isDisabled : true}
			,{id : "BCD_NM", label:["품목명", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "GOODS_BCD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false }
			,{id : "STOCK_QTY", label:["전산재고", "#rspan"], type: "ron", width: "85", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "INSP_QTY", label:["실사수량", "#rspan"], type: "ron", width: "85", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll: true, maxLength: 7}
			,{id : "INSP_CONV_QTY", label:["변환수량", "#rspan"], type: "ron", width: "85", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "DIFF_QTY", label:["차이수량", "#rspan"], type: "ron", width: "85", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "T_TYPE", label:["FLAG", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : false }
			,{id : "CDATE", label:["CDATE", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : false }
		];
		
		erpSubGrid = new dhtmlXGridObject({
			parent: "div_erp_sub_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpSubGridColumns
		});
	
		erpSubGrid.attachEvent("onRowPaste", function(rId){   //엑셀붙여넣기시 자동으로 행추가
			var tmpRowIndex = erpSubGrid.getRowIndex(rId);
			if(erpSubGrid.getRowId((tmpRowIndex+1)) == null || erpSubGrid.getRowId((tmpRowIndex+1)) == "null" || erpSubGrid.getRowId((tmpRowIndex+1)) == undefined || erpSubGrid.getRowId((tmpRowIndex+1)) == "undefined" ){
				addErpSubGrid();
			}
			getDetailGoodsList(rId); // 바코드 붙여넣기 완료 시 상품정보 가져오기
		});
		
		erpSubGrid.attachEvent("onKeyPress",onDetailKeyPressed);
		erpSubGrid.enableBlockSelection();
		erpSubGrid.enableDistributedParsing(true, 100, 50);		
		erpSubGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpSubGrid);
		$erp.initGridComboCell(erpSubGrid);
		$erp.attachDhtmlXGridFooterPaging(erpSubGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpSubGrid, '<spring:message code="grid.allRowCount" />');
		
		erpSubGridDataProcessor = new dataProcessor();
		erpSubGridDataProcessor.init(erpSubGrid);
		erpSubGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpSubGrid);
	
	}
	<%-- ■ erpSubGrid 관련 Function 끝 --%>
	
	<%-- erpSubGrid 조회 Function --%>
	function searchErpSubGrid(){
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		var str = document.getElementById("searchDate").value;
		var SEARCH_FROM_DATE = str.replace(/\-/g,'');
		
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/stock/stockManagement/getstockInspSubList.do" //재고실사 하단 조회
			,data : {
				 "ORGN_CD" : ORGN_CD
				, "SEARCH_FROM_DATE" : SEARCH_FROM_DATE
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpSubGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpSubGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpSubGrid.parse(gridDataList, 'js');
						
						var allRowIds = erpSubGrid.getAllRowIds();
						var allRowArray = allRowIds.split(",");
						for(var i in gridDataList){
							if(gridDataList[i].T_TYPE== "INSP"){
								erpSubGrid.setCellExcellType(allRowArray[i],erpSubGrid.getColIndexById("CHECK"),"ch");
								erpSubGrid.setCellExcellType(allRowArray[i],erpSubGrid.getColIndexById("INSP_QTY"),"edn");
							}else if(gridDataList[i].T_TYPE == "STOCK"){
								erpSubGrid.cells(allRowArray[i],erpSubGrid.getColIndexById("CHECK")).setValue("소계");
							}
						}
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpSubGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- erpSubGrid 조회 Function 끝--%>
	
	<%-- saveErpSubGrid 저장 Function --%>
	function saveErpSubGrid() {
		if(erpSubGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		$erp.confirmMessage({
			"alertMessage" : '<spring:message code="alert.common.saveData" />'
			,"alertType" : "alert"
			,"isAjax" : false
			,"alertCallbackFn" : function(){
				var paramData = $erp.serializeDhtmlXGridData(erpSubGrid);
				
				erpLayout.progressOn();
				$.ajax({
					url : "/sis/stock/stockManagement/saveStockInspSubList.do" //재고실사하단저장
					,data : paramData
					,method : "POST"
					,dataType : "JSON"
					,success : function(data) {
						erpLayout.progressOff();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else {
							$erp.alertMessage({
								"alertMessage" : '<spring:message code="info.common.saveSuccess" />'
								,"alertType" : "notice"
								,"isAjax" : false
								,"alertCallbackFn" : function(){
									searchErpSubGrid();
								}
							});
						}
					}, error : function(jqXHR, textStatus, errorThrown){
						erpLayout.progressOff();
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
			}
		});
	}
	<%-- saveErpSubGrid 저장 Function 끝 --%>
	
	<%-- deleteErpSubGrid 삭제 Function --%>
	function deleteErpSubGrid(){
		var gridRowCount = erpSubGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		if(gridRowCount == ""){
			$erp.alertMessage({
				"alertMessage" : "error.common.noCheckedData"
				, "alertCode" : null
				, "alertType" : "notice"
			});
		}else{
			var deleteRowIdArray = [];
			var check = "";
			
			for(var i = 0 ; i < RowCountArray.length ; i++){
				check = erpSubGrid.cells(RowCountArray[i], erpSubGrid.getColIndexById("CHECK")).getValue();
				if(check == "1"){
					deleteRowIdArray.push(RowCountArray[i]);
				}
			}
			
			if(deleteRowIdArray.length == 0){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
				return;
			}
			
			for(var j = 0; j < deleteRowIdArray.length; j++){
				erpSubGrid.deleteRow(deleteRowIdArray[j]);
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpSubGrid);
		}
	}
	<%-- deleteErpSubGrid 삭제 Function 끝 --%>
	
	<%-- savePartErpGrid 저장 Function --%>
	function savePartErpGrid() {
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		var str = document.getElementById("searchDate").value;
		var SEARCH_FROM_DATE = str.replace(/\-/g,'');
			
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/stock/stockManagement/savePartStockInspList.do" //부분실사적용
			, data : {	
					"ORGN_CD" : ORGN_CD
					, "SEARCH_FROM_DATE" : SEARCH_FROM_DATE
				}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertMessage({
						"alertMessage" : "생성이 완료 되었습니다.",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							searchErpSubGrid();
						}
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- saveFullErpGrid 저장 Function --%>
	function saveFullErpGrid() {
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		var str = document.getElementById("searchDate").value;
		var SEARCH_FROM_DATE = str.replace(/\-/g,''); 
			
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/stock/stockManagement/saveFullStockInspList.do" //전체실사적용
			, data : {	
				"ORGN_CD" : ORGN_CD
				, "SEARCH_FROM_DATE" : SEARCH_FROM_DATE
			}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertMessage({
						"alertMessage" : "생성이 완료 되었습니다.",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							searchErpSubGrid();
						}
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(ORGN_CD, CDATE){
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		var str = document.getElementById("searchDate").value;
		var SEARCH_FROM_DATE = str.replace(/\-/g,'');
		
		var onClickAddData = function(erpGoodsGrid) {
			var isValidated = true;
			var alertMessage = "";
			var alertCode = "";
			var alertType = "error";
			
			var check = erpGoodsGrid.getCheckedRows(erpGoodsGrid.getColIndexById("CHECK")); // 조회된 그리드내역 중 선택한 row 번호 문자열로 넘어옴 ex) 1,5,7,10
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					, "alertCode" : alertCode
					, "alertType" : alertType
				});
			}else{
				var checkList = check.split(',');
			
				for(var i = 0 ; i < checkList.length ; i ++) {
					var uid = erpSubGrid.uid();
					erpSubGrid.addRow(uid);
				
					erpSubGrid.cells(uid, erpSubGrid.getColIndexById("BCD_NM")).setValue(erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("BCD_NM")).getValue());
					erpSubGrid.cells(uid, erpSubGrid.getColIndexById("GOODS_BCD")).setValue(erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("BCD_CD")).getValue());
					erpSubGrid.cells(uid, erpSubGrid.getColIndexById("ORGN_CD")).setValue(ORGN_CD);
					erpSubGrid.cells(uid, erpSubGrid.getColIndexById("MODI_DATE")).setValue(SEARCH_FROM_DATE);
					erpSubGrid.cells(uid, erpSubGrid.getColIndexById("T_TYPE")).setValue("INSP");
					erpSubGrid.setCellExcellType(uid,erpSubGrid.getColIndexById("CHECK"),"ch");
					erpSubGrid.setCellExcellType(uid,erpSubGrid.getColIndexById("INSP_QTY"),"edn");
					$erp.setDhtmlXGridFooterRowCount(erpSubGrid);
					erpSubGrid.selectRowById(uid,false,true,false);
				}
				$erp.closePopup2("openSearchGoodsGridPopup"); 
			}
		}
		$erp.openSearchGoodsPopup(null,onClickAddData);
	}
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",");
		var searchable = 1;
		console.log(search_cd_Arr);
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
				searchable = 2;
			}
		}
		
		 if(searchable == 2 ){
			 cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK","","","","MK"], 100, null, false, LUI.LUI_orgn_cd);
		} else {
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 90, null, false, LUI.LUI_orgn_cd);
		}
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- onKeyPressed 그룹 목록Grid_Keypressed Function --%>
	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpGrid.setCSVDelimiter("\t");
			erpGrid.copyBlockToClipboard()
		}
		if(code==86&&ctrl){
			erpGrid.setCSVDelimiter("\t");
			erpGrid.pasteBlockFromClipboard()
		}
		return true;
	}
	
	<%-- onDetailKeyPressed 그룹 상품 목록Grid_Keypressed Function --%>
	function onDetailKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpSubGrid.setCSVDelimiter("\t");
			erpSubGrid.copyBlockToClipboard();
		}
		if(code==86&&ctrl){
			erpSubGrid.setCSVDelimiter("\t");
			erpSubGrid.pasteBlockFromClipboard();
		}
		return true;
	}
	
	<%-- openStockInspListPopup 재고실사관리 상세목록 팝업 열림 Function --%>
	function openStockInspListPopup(ORGN_CD, STORE_AREA){
		var SEARCH_FROM_DATE = document.getElementById("searchDate").value;
		$erp.openStockInspListPopup(ORGN_CD, SEARCH_FROM_DATE, STORE_AREA);
	}
	
	function enterSearchToMainGrid(kcode){
		if(kcode == 13){
			document.getElementById("searchDate").blur();
			searchErpGrid();
		}
	}
</script>
</head>
<body>
	<div id="div_erp_main_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_main_table" class="samyang_div" style="display:none">
			<table id = "tb_search_01" class = "table">
				<colgroup>
					<col width="80px"/>
					<col width="120px"/>
					<col width="80px"/>
					<col width="*px"/>
				</colgroup>
				<tr>
					<th>일자</th>
					<td>
						<input type="text" id="searchDate" name="searchDate" class="input_common input_calendar" style="margin-left:10px;" onkeydown="enterSearchToMainGrid(event.keyCode);">
					</td>
					<th>조직명</th>
					<td>
						<div id="cmbORGN_CD" style="margin-left:10px;"></div>
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_main_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_main_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	<div id="div_erp_sub_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_sub_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_sub_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>