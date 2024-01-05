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
		■ detailGrid : Object / 화면 조회 DhtmlXGrid
		■ detailGridColumns : Array / detailGrid DhtmlXGrid Header
		■ detailGridDataProcessor : Object/ detailGrid DhtmlXDataProcessor
		
		■ cmbUSE_YN : Object / 사용여부 DhtmlXCombo (공통코드 : YN_CD)
	--%>
	var erpLayout;
	
	var erpSubLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	
	var erpDetailSubLayout;
	var erpDetailRibbon;
	var detailGrid;
	var detailGridColumns;
	var detailGridDataProcessor;
	
	var cmbUSE_YN;
	
	$(document).ready(function(){		
		initErpLayout();		
		
		initErpSubLayout();
		initErpRibbon();
		initErpGrid();
		
		initDetailSubLayout();
		initDetailRibbon();
		initDetailGrid();
		
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
				, {id: "b", text: "고정 값 상세관리", header:true}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_sub_layout");
		erpLayout.cells("b").attachObject("div_erp_detail_sub_layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpSubLayout.setSizes();
			erpDetailSubLayout.setSizes();
			erpGrid.setSizes();
			detailGrid.setSizes();
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
					//, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
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
		    	/* $erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "공통코드"		
		    		, "isForm" : false
		    	}); */
		    } else if (itemId == "print_erpGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){ // maxLength
		erpGridColumns = [
			  {id : "NO", 			label : ["NO", "#rspan"], 				type : "cntr", 	width : "30", 	sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", 		label : ["#master_checkbox", "#rspan"], type : "ch", 	width : "40", 	sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "SELECT", 		label : ["선택", "#rspan"], 				type : "ra", 	width : "40", 	sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "TABLE_NM_EN", 	label : ["테이블 명(영문)", "#text_filter"], 	type : "ro", 	width : "150", 	sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "TABLE_DESC", 	label : ["설명", "#text_filter"], 		type : "ed", 	width : "150", 	sort : "str", align : "left", 	isHidden : false, isEssential : true}
			, {id : "USE_YN", 		label : ["사용여부", "#select_filter"], 	type : "combo", width : "60", 	sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["YN_CD","YN"]}
			, {id : "REG_PROGRM", 	label : ["등록프로그램", "#rspan"], 			type : "ro", 	width : "130", 	sort : "str", align : "left", 	isHidden : false, isEssential : false}
			, {id : "REG_ID", 		label : ["등록자", "#rspan"], 				type : "ro", 	width : "100", 	sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "REG_DT", 		label : ["등록일시", "#rspan"], 			type : "ro", 	width : "140", 	sort : "str", align : "left", 	isHidden : false, isEssential : false}
			, {id : "UPD_PROGRM", 	label : ["수정프로그램", "#rspan"], 			type : "ro", 	width : "130", 	sort : "str", align : "left", 	isHidden : false, isEssential : false}
			, {id : "UPD_ID", 		label : ["수정자", "#rspan"], 				type : "ro", 	width : "100", 	sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "UPD_DT", 		label : ["수정일시", "#rspan"], 			type : "ro", 	width : "140", 	sort : "str", align : "left", 	isHidden : false, isEssential : false}
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
				var table = this.cells(rId, this.getColIndexById("TABLE_NM_EN")).getValue();
				searchDetailGrid(table);
			}
		});
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchErpGridValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var table = document.getElementById("txtTABLE_NM_EN").value;
		
		if(!$erp.isEmpty(table) && table.length > 50){
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
		
		var table = document.getElementById("txtTABLE_NM_EN").value;
		var use_yn = cmbUSE_YN.getSelectedValue();
		
		erpLayout.progressOn();
		
		$.ajax({
			url : "/addin/fixedvalues/SELECT_addInFixedValuesMaster.do"
			,data : {
				"TABLE_NM_EN" : table
				, "USE_YN" : use_yn
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					document.getElementById("txtSELECT_TABLE_NM_EN").value = "";
					$erp.clearDhtmlXGrid(erpGrid);
					$erp.clearDhtmlXGrid(detailGrid);
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
		erpGrid.setCellExcellType(uid, erpGrid.getColIndexById("TABLE_NM_EN"), "ed");
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
			url : "/addin/fixedvalues/CUD_addInFixedValuesMaster.do"
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
	function initDetailSubLayout(){
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
	function initDetailRibbon(){
		erpDetailRibbon = new dhtmlXRibbon({
			parent : "div_erp_detail_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "add_detailGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_detailGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_detailGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					//, {id : "excel_detailGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
				]}							
			]
		});
		
		erpDetailRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_detailGrid"){
		    	addDetailGrid();
		    } else if (itemId == "delete_detailGrid"){
		    	deleteDetailGrid();
		    } else if (itemId == "save_detailGrid"){
		    	saveDetailGrid();
		    } else if (itemId == "excel_detailGrid"){
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : detailGrid
		    		, "fileName" : "테이블의 고정 값 디테일정보"
		    		, "isForm" : false
		    	});
		    } else if (itemId == "print_detailGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpDetailRibbon 관련 Function 끝 --%>
	
	<%-- ■ detailGrid 관련 Function 시작 --%>	
	<%-- detailGrid 초기화 Function --%>	
	function initDetailGrid(){
		detailGridColumns = [
			{id : "NO", label : ["NO", "#rspan"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label : ["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "SEQ", 	 label : ["번호", "#rspan"], 				type : "ron", 	width : "40", 	sort : "str", align : "center", isHidden : true,  isEssential : false}
			, {id : "TABLE_NM_EN", label : ["공통코드", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "COLUMN_NM_EN", label : ["컬럼 명(영문)", "#text_filter"], type : "ro", width : "150", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "COLUMN_VALUE", label : ["값", "#text_filter"], type : "ed", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "COLUMN_VALUE_DESC", label : ["설명", "#text_filter"], type : "ed", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "USE_YN", label : ["사용여부", "#select_filter"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["YN_CD","YN"]}
			, {id : "REG_PROGRM", label : ["등록프로그램", "#rspan"], type : "ro", width : "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "REG_ID", label : ["등록자", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "REG_DT", label : ["등록일시", "#rspan"], type : "ro", width : "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "UPD_PROGRM", label : ["수정프로그램", "#rspan"], type : "ro", width : "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "UPD_ID", label : ["수정자", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "UPD_DT", label : ["수정일시", "#rspan"], type : "ro", width : "140", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		detailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : detailGridColumns			
		});		
		/* detailGrid.splitAt(detailGrid.getColIndexById("ORDR")); */
		
		detailGrid.attachEvent("onKeyPress",onKeyPressed);
		detailGrid.enableBlockSelection();
		
		detailGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(detailGrid);
		$erp.initGridComboCell(detailGrid);		
		detailGrid.enableAccessKeyMap(true);
		$erp.attachDhtmlXGridFooterRowCount(detailGrid, '<spring:message code="grid.allRowCount" />');		
		
		detailGridDataProcessor = new dataProcessor();
		detailGridDataProcessor.init(detailGrid);
		detailGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(detailGrid);
	}
	
	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			if (!detailGrid._selectionArea) return alert("You need to select a block area in grid first");
				detailGrid.setCSVDelimiter("\t");
				detailGrid.copyBlockToClipboard();
			}
			if(code==86&&ctrl){
				detailGrid.setCSVDelimiter("\t");
				detailGrid.pasteBlockFromClipboard();
			}
		return true;
	}

	
	<%-- detailGrid 조회 유효성 검사 Function --%>
	function isSearchDetailGridValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var select_table = document.getElementById("txtSELECT_TABLE_NM_EN").value;
		
		if($erp.isEmpty(select_table)){
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
	
	<%-- detailGrid 조회 Function --%>
	function searchDetailGrid(table){
		if(!$erp.isEmpty(table)){
			document.getElementById("txtSELECT_TABLE_NM_EN").value=table;
		}	
		if(!isSearchDetailGridValidate()){ return false; }
		
		erpLayout.progressOn();
		
		var select_table = document.getElementById("txtSELECT_TABLE_NM_EN").value;
		
		$.ajax({
			url : "/addin/fixedvalues/SELECT_addInFixedValuesDetail.do"
			,data : {
				"TABLE_NM_EN" : select_table
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(detailGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							detailGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						detailGrid.parse(gridDataList, 'js');	
					}
				}
				$erp.setDhtmlXGridFooterRowCount(detailGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- detailGrid 추가 Function --%>
	function addDetailGrid(){
		if(!isSearchDetailGridValidate()){ return false; }
		
		var uid = detailGrid.uid();
		detailGrid.addRow(uid);
		
		var table = document.getElementById("txtSELECT_TABLE_NM_EN").value;
		detailGrid.cells(uid, detailGrid.getColIndexById("TABLE_NM_EN")).setValue(table);
		detailGrid.setCellExcellType(uid, detailGrid.getColIndexById("COLUMN_NM_EN"), "ed");
		
		detailGrid.selectRow(detailGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(detailGrid);
	}
	
	<%-- detailGrid 삭제 Function --%>
	function deleteDetailGrid(){
		var gridRowCount = detailGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = detailGrid.getRowId(i);
			var check = detailGrid.cells(rId, detailGrid.getColIndexById("CHECK")).getValue();
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
			detailGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(detailGrid);
	}
	
	<%-- detailGrid 저장 Function --%>
	function saveDetailGrid(){
		if(detailGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(detailGrid);
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
		var paramData = $erp.serializeDhtmlXGridData(detailGrid);		
		$.ajax({
			url : "/addin/fixedvalues/CUD_addInFixedValuesDetail.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.alertSuccessMesage(onAfterSaveDetailGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- detailGrid 저장 후 Function --%>
	function onAfterSaveDetailGrid(){
		searchDetailGrid();
	}
	<%-- ■ detailGrid 관련 Function 끝 --%>
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
				<th>테이블 명</th>
				<td><input type="text" id="txtTABLE_NM_EN" name="TABLE_NM_EN" class="input_common" maxlength="20" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid);"></td>
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
				<th>선택된 테이블 명</th>
				<td><input type="text" id="txtSELECT_TABLE_NM_EN" name="SELECT_TABLE_NM_EN" class="input_common input_readonly" readonly="readonly" maxlength="20" ></td>
			</tr>
		</table>
	</div>
</body>
</html>