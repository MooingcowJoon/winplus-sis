<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript">
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 메뉴별화면 조회 DhtmlXGrid
		■ erpGridColumns : Array / erpGrid DhtmlXGrid Header
		■ erpGridDataProcessor : Object/ erpGridDataProcessor DhtmlXDataProcessor
		
		■ erpDetailSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpDetailRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpDetailGrid : Object / 화면 조회 DhtmlXGrid
		■ erpDetailGridColumns : Array / erpDetailGrid DhtmlXGrid Header
		■ erpDetailGridDataProcessor : Object/ erpDetailGrid DhtmlXDataProcessor
		
		■ cmbUSE_YN : Object / 사용여부 DhtmlXCombo (트리코드 : YN_CD)
	--%>
	var erpLayout;
	
	var erpSubLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	
	var erpDetailSubLayout;
	var erpDetailRibbon;
	var erpDetailGrid;
	var erpDetailGridColumns;
	var erpDetailGridDataProcessor;
	
	var cmbUSE_YN;
	
	$(document).ready(function(){		
		initErpLayout();		
		
		initErpSubLayout();
		initErpRibbon();
		initErpGrid();
		
		initErpDetailSubLayout();
		initErpDetailRibbon();
		initErpDetailGrid();
		
		initDhtmlXCombo();
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2U"
			, cells: [
				{id: "a", text: "${menuDto.menu_nm}", header:true, width:750}
				, {id: "b", text: "트리상세코드관리", header:true}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_sub_layout");
		erpLayout.cells("b").attachObject("div_erp_detail_sub_layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpSubLayout.setSizes();
			erpDetailSubLayout.setSizes();
			erpGrid.setSizes();
			erpDetailGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ dhtmlxCombo 관련 Function 시작 --%>
	<%-- dhtmlxCombo 초기화 Function --%>
	function initDhtmlXCombo(){
		cmbUSE_YN = $erp.getDhtmlXCombo('cmbUSE_YN', 'USE_YN', ['YN_CD','YN'], 100, true);
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
	
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
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, width:60}
				, {id: "b", text: "", header:false, fix_size : [false, true]}
				, {id: "c", text: "", header:false}
			]		
			, fullScreen : true
		});
		erpSubLayout.cells("a").attachObject("div_erp_contents_search");
		erpSubLayout.cells("a").setHeight(38);
		erpSubLayout.cells("b").attachObject("div_erp_ribbon");
		erpSubLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpSubLayout.cells("c").attachObject("div_erp_grid");
		
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
					, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					//, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}	
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "add_erpGrid"){
		    	addErpGrid();
		    } else if (itemId == "delete_erpGrid"){
		    	deleteErpGrid();
		    } else if (itemId == "save_erpGrid"){
		    	saveErpGrid();
		    } else if (itemId == "excel_erpGrid"){
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "트리코드"		
		    		, "isForm" : false
		    	});
		    } else if (itemId == "print_erpGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			  {id : "NO", 				label : ["NO", "#rspan"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", 			label : ["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "SELECT", 			label : ["선택", "#rspan"], type : "ra", width : "40", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "TREE_CODE", 		label : ["트리코드", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "TREE_CODE_NAME", 	label : ["트리코드명", "#text_filter"], type : "ed", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "DESCRIPTION", 		label : ["트리코드설명", "#text_filter"], type : "ed", width : "200", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "USE_YN", 			label : ["사용여부", "#select_filter"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "YN_CD"}
			, {id : "BEGIN_DATE", 		label : ["시작일자", "#text_filter"], type : "dhxCalendarA", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "END_DATE", 		label : ["종료일자", "#text_filter"], type : "dhxCalendarA", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "REG_PROGRM", 		label : ["등록프로그램", "#rspan"], type : "ro", width : "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "REG_ID", 			label : ["등록자", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "REG_DT", 			label : ["등록일시", "#rspan"], type : "ro", width : "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "UPD_PROGRM", 		label : ["수정프로그램", "#rspan"], type : "ro", width : "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "UPD_ID", 			label : ["수정자", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "UPD_DT", 			label : ["수정일시", "#rspan"], type : "ro", width : "140", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns			
		});		
		erpGrid.enableDistributedParsing(true, 100, 50);
		erpGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);		
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 150);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpGrid);
		
		erpGrid.attachEvent("onCheck", function(rId,cInd){
			if(cInd == this.getColIndexById("SELECT")){
				var TREE_CODE = this.cells(rId, this.getColIndexById("TREE_CODE")).getValue();
				searchErpDetailGrid(TREE_CODE);
			}
		 });
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchErpGridValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var TREE_CODE = document.getElementById("txtTREE_CODE").value;
		
		if(!$erp.isEmpty(TREE_CODE) && TREE_CODE.length > 50){
			isValidated = false;
			alertMessage = "error.common.system.common.cmmn_nm.length50Over";
			alertCode = "-1";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		if(!isSearchErpGridValidate()){
			return;
		}
		
		var TREE_CODE = document.getElementById("txtTREE_CODE").value;
		var use_yn = cmbUSE_YN.getSelectedValue();
		
		erpLayout.progressOn();
		
		$.ajax({
			url : "/common/system/code/getTreeCodeTable.do"
			,data : {
				"TREE_CODE" : TREE_CODE
				, "USE_YN" : use_yn
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					document.getElementById("txtSELECT_TREE_CODE").value = "";
					$erp.clearDhtmlXGrid(erpGrid);
					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
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
	
	<%-- erpGrid 추가 Function --%>
	function addErpGrid(){
		var uid = erpGrid.uid();
		erpGrid.addRow(uid);
		erpGrid.setCellExcellType(uid, erpGrid.getColIndexById("TREE_CODE"), "ed");
		erpGrid.setCellExcellType(uid, erpGrid.getColIndexById("SELECT"), "ro");
		erpGrid.cells(uid, erpGrid.getColIndexById("SELECT")).setValue("");
		erpGrid.selectRow(erpGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	<%-- erpGrid 삭제 Function --%>
	function deleteErpGrid(){
		var gridRowCount = erpGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpGrid.getRowId(i);
			var check = erpGrid.cells(rId, erpGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(rId);
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
		
		for(var i = 0; i < deleteRowIdArray.length; i++){
			erpGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	<%-- erpGrid 저장 Function --%>
	function saveErpGrid(){
		if(erpGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpGrid);
		if(validResultMap.isError){
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);		
		$.ajax({
			url : "/common/system/code/cudTreeCodeTable.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.alertSuccessMesage(onAfterSaveErpGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpGrid 저장 후 Function --%>
	function onAfterSaveErpGrid(){
		searchErpGrid();
	}
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
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, fix_size : [false, true]}
				, {id: "b", text: "", header:false, fix_size : [false, true]}
				, {id: "c", text: "", header:false}
			]		
			, fullScreen : true
		});
		erpDetailSubLayout.cells("a").attachObject("div_erp_detail_contents_search");
		erpDetailSubLayout.cells("a").setHeight(38);
		erpDetailSubLayout.cells("b").attachObject("div_erp_detail_ribbon");
		erpDetailSubLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpDetailSubLayout.cells("c").attachObject("div_erp_detail_grid");
		
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
					{id : "add_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					, {id : "excel_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
				]}							
			]
		});
		
		erpDetailRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_erpDetailGrid"){
		    	addErpDetailGrid();
		    } else if (itemId == "delete_erpDetailGrid"){
		    	deleteErpDetailGrid();
		    } else if (itemId == "save_erpDetailGrid"){
		    	saveErpDetailGrid();
		    } else if (itemId == "excel_erpDetailGrid"){
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : erpDetailGrid
		    		, "fileName" : "트리상세코드"
		    		, "isForm" : false
		    	});
		    } else if (itemId == "print_erpDetailGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpDetailRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpDetailGrid 관련 Function 시작 --%>	
	<%-- erpDetailGrid 초기화 Function --%>	
	function initErpDetailGrid(){
		erpDetailGridColumns = [
			  {id : "NO", 						label : ["NO", "#rspan"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", 					label : ["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "TREE_CODE", 				label : ["트리코드", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "TREE_DETAIL_CODE", 		label : ["트리상세코드", "#text_filter"], type : "ro", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "TREE_DETAIL_CODE_NAME", 	label : ["트리상세코드명", "#text_filter"], type : "ed", width : "150", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "CODE_SEQ", 				label : ["순번", "#text_filter"], type : "edn", width : "40", sort : "int", align : "center", isHidden : false, isEssential : true}
			, {id : "TREE_DETAIL_UPPER_CODE", 	label : ["상위트리상세코드", "#text_filter"], type : "ed", width : "90", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "STEP", 					label : ["스텝", "#text_filter"], type : "edn", width : "40", sort : "int", align : "center", isHidden : false, isEssential : true}
			, {id : "USE_YN", 					label : ["사용여부", "#select_filter"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "YN_CD"}
			, {id : "BEGIN_DATE", 				label : ["시작일자", "#text_filter"], type : "dhxCalendarA", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "END_DATE", 				label : ["종료일자", "#text_filter"], type : "dhxCalendarA", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "REG_PROGRM", 				label : ["등록프로그램", "#rspan"], type : "ro", width : "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "REG_ID", 					label : ["등록자", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "REG_DT", 					label : ["등록일시", "#rspan"], type : "ro", width : "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "UPD_PROGRM", 				label : ["수정프로그램", "#rspan"], type : "ro", width : "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "UPD_ID", 					label : ["수정자", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "UPD_DT", 					label : ["수정일시", "#rspan"], type : "ro", width : "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMO", 					label : ["비고", "#text_filter"], type : "ed", width : "200", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpDetailGridColumns			
		});		
		/* erpDetailGrid.splitAt(erpDetailGrid.getColIndexById("ORDR")); */
		
		erpDetailGrid.attachEvent("onKeyPress",onKeyPressed);
		erpDetailGrid.enableBlockSelection();
		
		erpDetailGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpDetailGrid);
		$erp.initGridComboCell(erpDetailGrid);		
		erpDetailGrid.enableAccessKeyMap(true);
		$erp.attachDhtmlXGridFooterRowCount(erpDetailGrid, '<spring:message code="grid.allRowCount" />');		
		
		erpDetailGridDataProcessor = new dataProcessor();
		erpDetailGridDataProcessor.init(erpDetailGrid);
		erpDetailGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpDetailGrid);
	}
	
	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			if (!erpDetailGrid._selectionArea) return alert("You need to select a block area in grid first");
			erpDetailGrid.setCSVDelimiter("\t");
			erpDetailGrid.copyBlockToClipboard()
			}
			if(code==86&&ctrl){
				erpDetailGrid.setCSVDelimiter("\t");
				erpDetailGrid.pasteBlockFromClipboard()
			}
		return true;
	}
	function showClipboard(){
		if (window.clipboardData)
			document.getElementById("ser_1").value = window.clipboardData.getData("Text");
	}
	
	<%-- erpDetailGrid 조회 유효성 검사 Function --%>
	function isSearchErpDetailGridValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var select_TREE_CODE = document.getElementById("txtSELECT_TREE_CODE").value;
		
		if($erp.isEmpty(select_TREE_CODE)){
			isValidated = false;
			alertMessage = "error.common.system.code.noSelectedCommonCode";
			alertCode = "-1";
		} 		
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
	
	<%-- erpDetailGrid 조회 Function --%>
	function searchErpDetailGrid(TREE_CODE){
		if(!$erp.isEmpty(TREE_CODE)){
			document.getElementById("txtSELECT_TREE_CODE").value=TREE_CODE;
		}	
		if(!isSearchErpDetailGridValidate()){ return false; }
		
		erpLayout.progressOn();
		
		var select_TREE_CODE = document.getElementById("txtSELECT_TREE_CODE").value;
		
		$.ajax({
			url : "/common/system/code/getTreeDetailCodeTable.do"
			,data : {
				"TREE_CODE" : select_TREE_CODE
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
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
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpDetailGrid 추가 Function --%>
	function addErpDetailGrid(){
		if(!isSearchErpDetailGridValidate()){ return false; }
		
		var uid = erpDetailGrid.uid();
		erpDetailGrid.addRow(uid);
		
		var TREE_CODE = document.getElementById("txtSELECT_TREE_CODE").value;
		erpDetailGrid.cells(uid, erpDetailGrid.getColIndexById("TREE_CODE")).setValue(TREE_CODE);
		erpDetailGrid.setCellExcellType(uid, erpDetailGrid.getColIndexById("TREE_DETAIL_CODE"), "ed");
		erpDetailGrid.selectRow(erpDetailGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
	}
	
	<%-- erpDetailGrid 삭제 Function --%>
	function deleteErpDetailGrid(){
		var gridRowCount = erpDetailGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpDetailGrid.getRowId(i);
			var check = erpDetailGrid.cells(rId, erpDetailGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(rId);
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
		
		for(var i = 0; i < deleteRowIdArray.length; i++){
			erpDetailGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
	}
	
	<%-- erpDetailGrid 저장 Function --%>
	function saveErpDetailGrid(){
		if(erpDetailGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpDetailGrid);
		if(validResultMap.isError){
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpDetailGrid);		
		$.ajax({
			url : "/common/system/code/cudTreeDetailCodeTable.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.alertSuccessMesage(onAfterSaveErpDetailGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpDetailGrid 저장 후 Function --%>
	function onAfterSaveErpDetailGrid(){
		searchErpDetailGrid();
	}
	<%-- ■ erpDetailGrid 관련 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_tree" class="div_tree_full_size"></div>		
	
	<div id="div_erp_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
	
	<div id="div_erp_detail_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_detail_ribbon" class="div_ribbon_full_size" style="display:none"></div>	
	<div id="div_erp_detail_grid" class="div_grid_full_size" style="display:none"></div>	
	
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="150px">
				<col width="150px">
				<col width="150px">
				<col width="*">				
			</colgroup>
			<tr>
				<th>트리코드/트리코드명</th>
				<td><input type="text" id="txtTREE_CODE" name="TREE_CODE" class="input_common" maxlength="20" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid);"></td>
				<th>사용여부</th>
				<td><div id="cmbUSE_YN"></div></td>				
			</tr>
		</table>
	</div>
	
	<div id="div_erp_detail_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="150px">
				<col width="*">
			</colgroup>
			<tr>
				<th>선택된 트리코드</th>
				<td><input type="text" id="txtSELECT_TREE_CODE" name="SELECT_TREE_CODE" class="input_common input_readonly" readonly="readonly" maxlength="20" ></td>
			</tr>
		</table>
	</div>
</body>
</html>