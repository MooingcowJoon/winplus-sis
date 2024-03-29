<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript">

	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_orgn_type = "PS,CS";

<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 메뉴별화면 조회 DhtmlXGrid
		■ erpGridColumns : Array / erpGrid DhtmlXGrid Header
		■ erpGridDataProcessor : Object/ erpGridDataProcessor DhtmlXDataProcessor
		■ erpDetailGridDataProcessor : Object/ erpGridDataProcessor DhtmlXDataProcessor
		
		■ erpDetailSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpDetailRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpDetailGrid : Object / 화면 조회 DhtmlXGrid
		■ erpDetailGridColumns : Array / erpDetailGrid DhtmlXGrid Header
		■ erpDetailGridDataProcessor : Object/ erpDetailGrid DhtmlXDataProcessor
		
	--%>
	
	var erpLayout;
	
	var erpSubLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	
	var erpDetailSubLayout;
	var erpDetailRibbon;
	var erpDetailGrid;
	var erpDetailGridColumns;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var erpGidDataProcessor;
	var erpDetailGridDataProcessor;
	
	var cmbSearch;
	var initOC = 0;
	
	var Code_List = "";
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	$(document).ready(function(){
		
		initErpLayout();
		initDhtmlXCombo();
		
		initErpSubLayout();
		initErpRibbon();
		initErpGrid();
		
		initErpDetailSubLayout();
		initErpDetailRibbon();
		initErpDetailGrid();
		
		$erp.asyncObjAllOnCreated(function(){
			searchErpGrid();
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3T"
			, cells: [
				{id: "a", text: "점포선택영역", header:false}
				, {id: "b", text: "저울상품 그룹", header:true, width:440}
				, {id: "c", text: "저울상품 상품 목록", header:true}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_select_combo");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_sub_layout");
		erpLayout.cells("c").attachObject("div_erp_detail_sub_layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpSubLayout.setSizes();
			erpDetailSubLayout.setSizes();
			erpGrid.setSizes();
			erpDetailGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%--
	**********************************************************************
	* ※ Master 영역
	**********************************************************************
	--%>	
	
	<%-- ■ erpSubLayout 관련 Function 시작 --%>
	<%-- erpSubLayout 초기화 Function --%>
	function initErpSubLayout(){
		erpSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				 {id: "a", text: "", header:false, fix_size : [false, true]}
				, {id: "b", text: "", header:false}
			]
			, fullScreen : true
		});
		erpSubLayout.cells("a").attachObject("div_erp_ribbon");
		erpSubLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpSubLayout.cells("b").attachObject("div_erp_grid");
		
		erpSubLayout.setSeparatorSize(1, 0);
	}	
	<%-- ■ erpSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					 {id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					, {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchErpGrid();
			}else if (itemId == "add_erpGrid"){
				addErpGrid();
			}else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
			}else if (itemId == "save_erpGrid"){
				saveErpGrid();
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "35", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false} 
			,{id : "SELECT", label : ["선택", "#rspan"], type : "ra", width : "35", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "ORGN_CD", label : ["직영점", "#rspan"], type : "combo", width : "70", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			, {id : "ORGN_DIV_CD", label:["법인구분", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "SCALE_NM", label:["저울상품그룹명", "#rspan"], type: "ed", width: "95", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "USE_YN", label:["사용구분", "#rspan" ], type: "combo", width: "75", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["USE_CD" , "YN"]}
			, {id : "MDATE", label:["수정일시", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "SCALE_CD", label:["저울그룹코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		
		erpGrid.attachEvent("onRowPaste", function(rId){
			var tmpRowIndex = erpGrid.getRowIndex(rId);
			if(erpGrid.getRowId((tmpRowIndex+1)) == undefined || erpGrid.getRowId((tmpRowIndex+1)) == "undefined" ){
				addErpGrid();
			}
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
		
		erpGrid.attachEvent("onCheck", function(rId,cInd){
			if(cInd == this.getColIndexById("SELECT")){
				var scale_cd = this.cells(rId, this.getColIndexById("SCALE_CD")).getValue();
				var orgn_cd = this.cells(rId, this.getColIndexById("ORGN_CD")).getValue();
				
				searchErpDetailGrid(scale_cd, orgn_cd);
			}
		});
	}
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		var paramData = {};
		paramData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		erpSubLayout.progressOn();
		$.ajax({
				url: "/sis/standardInfo/goods/getGoodsBalanceList.do"
				, data : paramData
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpSubLayout.progressOn();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpGrid);
						$erp.clearDhtmlXGrid(erpDetailGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpGrid
								, '<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpGrid);
					erpSubLayout.progressOff();
				}, error : function(jqXHR, textStatus, errorThrown){
				erpSubLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpGrid 조회 Function 끝--%>
	
	<%-- erpGrid 추가 Function --%>
	<%-- addErpGrid 추가 Function --%>
		function addErpGrid(){
			var orgn_cd = cmbORGN_CD.getSelectedValue();
			
			if (orgn_cd != ""){
				var uid = erpGrid.uid();
				erpGrid.addRow(uid);
				erpGrid.selectRow(erpGrid.getRowIndex(uid));
				erpGrid.cells(uid, erpGrid.getColIndexById("ORGN_CD")).setValue(orgn_cd);
				
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
			} else{ 
				$erp.alertMessage({
					"alertMessage" : "조직명을 선택해 주세요.",
					"alertType" : "alert",
					"isAjax" : false
				});
			}
		}
		
	<%-- saveErpGrid 저장 Function --%>
	function saveErpGrid() {
		if(erpGridDataProcessor.getSyncState()){
				$erp.alertMessage({
					"alertMessage" : "error.common.noChanged"
					, "alertCode" : null
					, "alertType" : "error"
				});
				return false;
			}
			
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
			
			erpSubLayout.progressOn();
			var paramData = $erp.serializeDhtmlXGridData(erpGrid);
			$.ajax({
				url : "/sis/standardInfo/goods/SaveBalanceList.do"
				,data : paramData
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					erpSubLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.alertSuccessMesage(onAfterSaveErpGrid);
					}
				}, error : function(jqXHR, textStatus, errorThrown){
				erpSubLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpGrid 저장 후 Function --%>
	function onAfterSaveErpGrid(){
		searchErpGrid();
	}
	
	<%-- deleteErpGrid 삭제 Function --%>
	function deleteErpGrid(){
		var gridRowCount = erpGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		
		var deleteRowIdArray = [];
		var check = "";
		
		for(var i = 0 ; i < RowCountArray.length ; i++){
			check = erpGrid.cells(RowCountArray[i], erpGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(RowCountArray[i]);
			}
		}
		
		if(deleteRowIdArray.length == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}
		
		for(var j = 0; j < deleteRowIdArray.length; j++){
			erpGrid.deleteRow(deleteRowIdArray[j]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	<%-- erpGrid 추가 Function 끝 --%>
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%--
	**********************************************************************
	* ※ Detail 영역
	**********************************************************************
	--%>
	<%-- ■ erpDetailSubLayout 관련 Function 시작 --%>
	<%-- erpDetailSubLayout 초기화 Function --%>
	function initErpDetailSubLayout(){
		erpDetailSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_detail_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				 {id: "a", text: "", header:false, fix_size : [false, true]}
				, {id: "b", text: "", header:false}
			]
			, fullScreen : true
		});
		erpDetailSubLayout.cells("a").attachObject("div_erp_detail_ribbon");
		erpDetailSubLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpDetailSubLayout.cells("b").attachObject("div_erp_detail_grid");
		
		erpDetailSubLayout.setSeparatorSize(1, 0);
	}	
	<%-- ■ erpDetailSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpDetailRibbon 관련 Function 시작 --%>
	<%-- erpDetailRibbon 초기화 Function --%>
	function initErpDetailRibbon(){
		erpDetailRibbon = new dhtmlXRibbon({
			parent : "div_erp_detail_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "add_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
					, {id : "delete_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					, {id : "save_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false}
					, {id : "excel_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
				]}
			]
		});
		
		erpDetailRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_erpDetailGrid"){
				var gridRowCount = erpGrid.getRowsNum();
				for(var i = 0; i < gridRowCount; i++){
					var rId = erpGrid.getRowId(i);
					var detailcheck = erpGrid.cells(rId, erpGrid.getColIndexById("SELECT")).getValue();
					if(detailcheck == 1) {
						openSearchGoodsGridPopup();
						return false;
					}
				}
				$erp.alertMessage({
					"alertMessage" : "저울상품그룹을 선택 후 이용가능합니다."
					, "alertType" : "alert"
					, "isAjax" : false
				});
			}else if (itemId == "delete_erpDetailGrid"){
				deleteErpDetailGrid();
			}else if (itemId == "save_erpDetailGrid"){
				saveErpDetailGrid();
			}else if (itemId == "excel_erpDetailGrid"){
				$erp.exportGridToExcel({
					"grid" : erpDetailGrid
					, "fileName" : "저울상품관리"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			}
		});
	}
	<%-- ■ erpDetailRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpDetailGrid 관련 Function 시작 --%>
	<%-- erpDetailGrid 초기화 Function --%>
	function initErpDetailGrid(){
		erpDetailGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "NO", label:["NO", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "GOODS_NM", label:["상품명", "#rspan"], type: "ro", width: "220", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "180", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "SALE_PRICE", label:["기준단가", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "USE_YN", label:["사용구분", "#rspan" ], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["USE_CD" , "YN"]}
			, {id : "CDATE", label:["등록일시", "#rspan"], type: "ro", width: "130", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "MDATE", label:["수정일시", "#rspan"], type: "ro", width: "130", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_CD", label:["점포코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "SCALE_CD", label:["점포코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
		];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpDetailGridColumns
		});
		
		$erp.initGridCustomCell(erpDetailGrid);
		erpDetailGridDataProcessor = $erp.initGrid(erpDetailGrid, {useAutoAddRowPaste : true, standardColumnId : "BCD_CD", deleteDuplication : true , overrideDuplication : false , editableColumnIdListOfInsertedRows : ["BCD_CD", "USE_YN"], notEditableColumnIdListOfInsertedRows : ["SALE_PRICE"]})

		erpDetailGrid.attachEvent("onEndPaste", function(result){
			pasteGoods(result);
		});
	}
	<%-- ■ erpDetailGrid 관련 Function 끝 --%>
	
	<%-- 상품 가져오기 function --%>
	function pasteGoods(result) {
		var selectedRowId = erpGrid.getCheckedRows(erpGrid.getColIndexById("SELECT"));
		var ORGN_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_CD")).getValue();
		var SCALE_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("SCALE_CD")).getValue();
		
		var loadGoodsList = [];
		var data;
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];
			loadGoodsList.push(data["BCD_CD"]);
		}
		var url =  "/sis/standardInfo/goods/getBalanceDetailList.do"
		var send_data = {
				"loadGoodsList" : loadGoodsList
				, "ORGN_CD" : ORGN_CD		
		};
		
		var if_success = function(data){
			var gridDataList = data.gridDataList;
			for(var index in gridDataList){
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("GOODS_NM")).setValue(gridDataList[index].BCD_NM);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("SALE_PRICE")).setValue(gridDataList[index].SALE_PRICE);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("GOODS_NO")).setValue(gridDataList[index].GOODS_NO);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("SCALE_CD")).setValue(SCALE_CD);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("ORGN_CD")).setValue(ORGN_CD);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("USE_YN")).setValue("Y");
				result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]].push("로드완료");
			}
			
			var notExistList = [];
			var value;
			var state;
			var dp = erpDetailGrid.getDataProcessor();
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["BCD_CD"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			$erp.deleteGridRows(erpDetailGrid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>[무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			if(erpDetailGrid.getRowsNum() == 0){
				erpDetailGrid.callEvent("onClick",["searchErpDetailGrid"]);
				return;
			}
			$erp.setDhtmlXGridFooterRowCount(erpDetailGrid); // 현재 행수 계산
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpDetailSubLayout);
	}
	
	<%-- erpDetailGrid 조회 Function --%>
	function searchErpDetailGrid(){ 
		var selectedRowId = erpGrid.getCheckedRows(erpGrid.getColIndexById("SELECT"));
		var SCALE_CD =erpGrid.cells(selectedRowId, erpGrid.getColIndexById("SCALE_CD")).getValue();
		if(SCALE_CD == ""){
			$erp.alertMessage({
				"alertMessage" : "저울상품 그룹을 저장 후 이용가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else{
			var paramData = {};
			paramData["ORGN_CD"] = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_CD")).getValue();
			paramData["SCALE_CD"] = SCALE_CD;
			erpDetailSubLayout.progressOn();
			$.ajax({
				url : "/sis/standardInfo/goods/getGoodsBalanceDetailList.do"
				,data : paramData
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpDetailSubLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						$erp.clearDhtmlXGrid(erpDetailGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpDetailGrid
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpDetailGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpDetailSubLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	<%-- erpDetailGrid 조회 Function 끝--%>
	
	<%-- onKeyPressed 저울상품 그룹Grid_Keypressed Function --%>
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
	
	<%-- openSearchCutmrPopup 거래처조회팝업열림 Function --%> //test
	function openSearchCutmrPopup() {
		var parentWindow = window;
		var params = {};
		$erp.openSearchCutmrPopup(parentWindow);
	}
	
	function initDhtmlXCombo(){
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",");
		var searchable = 1;
		console.log(search_cd_Arr);
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "ALL" || search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5"){
				searchable = 2;
			}
		}
		
		if(searchable == 2 ){
			cmbORGN_CD = $erp.getDhtmlXComboCommonCode("SELECT_ORGN", "cmbORGN_CD", ["ORGN_CD","MK", "", "", "", "MK"], 100, "모두조회", false, LUI.LUI_orgn_cd);
		} else {
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("SELECT_ORGN", "cmbORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 100, null, false, LUI.LUI_orgn_cd);
		}
	}
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup() {
		var selectedRowId = erpGrid.getCheckedRows(erpGrid.getColIndexById("SELECT"));
		var SCALE_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("SCALE_CD")).getValue();
		var ORGN_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_CD")).getValue();
		var ORGN_DIV_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_DIV_CD")).getValue();
		
		var onClickAddData = function(erpPopupGrid) {
			var popup = erpPopupWindows.window("openSearchGoodsGridPopup");
			popup.progressOn();
			$erp.copyRowsGridToGrid(erpPopupGrid, erpDetailGrid, ["BCD_CD","BCD_NM", "SALE_PRICE"], ["BCD_CD","BCD_NM", "SALE_PRICE"], "checked", "add", ["BCD_CD"], [], null, {"ORGN_CD" : ORGN_CD, "ORGN_DIV_CD" : ORGN_DIV_CD, "SCALE_CD" : SCALE_CD, "USE_YN" : "Y"}, function(result){
				popup.progressOff();
				popup.close();
				pasteGoods(result);
			},false);
		}
		$erp.openSearchGoodsPopup(null, onClickAddData, {"ORGN_CD" : ORGN_CD  ,"ORGN_DIV_CD" : ORGN_DIV_CD});
	}
	
	<%-- saveErpDetailGrid 저장 Function --%>
	function saveErpDetailGrid() {
		var gridRowCount = erpDetailGrid.getRowsNum();
		var lastRowNum = gridRowCount-1;
		var lastRid = erpDetailGrid.getRowId(lastRowNum);
		var lastRowcheck = erpDetailGrid.cells(lastRid, erpDetailGrid.getColIndexById("GOODS_NM")).getValue();
		if(lastRowcheck == null || lastRowcheck == "null" || lastRowcheck == undefined || lastRowcheck == "undefined" || lastRowcheck == "") {
			erpDetailGrid.deleteRow(lastRid);
		}
		
		if(erpDetailGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var allIds = erpDetailGrid.getAllRowIds(",");
		var allIdArray = allIds.split(",");
		
		var deleteRowIdArray = [];
		
		for(var i = 0 ; i < allIdArray.length ; i++) {
			var goods_nm = erpDetailGrid.cells(allIdArray[i], erpDetailGrid.getColIndexById("GOODS_NM")).getValue();
			if(goods_nm == "조회정보없음"){
				console.log("조회정보없음");
				deleteRowIdArray.push(allIdArray[i]);
			}
		}
		
		for(var j = 0 ; j < deleteRowIdArray.length ; j++){
			console.log("deleteRow >> " + deleteRowIdArray[j]);
			erpDetailGrid.deleteRow(deleteRowIdArray[j]); 
		}
		
		erpDetailSubLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpDetailGrid);
		$.ajax({
			url : "/sis/standardInfo/goods/saveBalanceDetailList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpDetailSubLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertSuccessMesage(onAfterSaveErpDetailGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpDetailSubLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpDetailGrid 저장 후 Function --%>
	function onAfterSaveErpDetailGrid(){
		searchErpDetailGrid();
	}
	
	<%-- deleteErpDetailGrid 삭제 Function --%>
	function deleteErpDetailGrid(){
		var gridRowCount = erpDetailGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		
		var deleteRowIdArray = [];
		var check = "";
		
		for(var i = 0 ; i < RowCountArray.length ; i++){
			check = erpDetailGrid.cells(RowCountArray[i], erpDetailGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(RowCountArray[i]);
			}
		}
		
		if(deleteRowIdArray.length == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}
		
		for(var j = 0; j < deleteRowIdArray.length; j++){
			erpDetailGrid.deleteRow(deleteRowIdArray[j]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
	}
</script>
</head>
<body>
	<div id="div_erp_select_combo" class="div_layout_full_size div_common_contents_full_size" style="display:none;">
	<table id="tb_erp_data" class="table_search">
		<colgroup>
			<col width="50px;">
			<col width="190px;">
			<col width="*px;">
		</colgroup>
		<tr>
			<th>조직명</th>
			<td>
				<div id="SELECT_ORGN"></div>
			</td>
		</tr>
	</table>
	</div>
	<div id="div_erp_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
	
	<div id="div_erp_detail_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_detail_ribbon" class="div_ribbon_full_size" style="display:none"></div>	
	<div id="div_erp_detail_grid" class="div_grid_full_size" style="display:none"></div>	
</body>
</html>