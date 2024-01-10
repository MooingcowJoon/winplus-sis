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
		■ erpTree : Object / 메뉴 목록 DhtmlXTree
		■ erpLeftSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpLeftRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpLeftGrid : Object / 메뉴별화면 조회 DhtmlXGrid
		■ erpLeftGridColumns : Array / erpLeftGrid DhtmlXGrid Header
		■ erpLeftGridDataProcessor : Object/ erpLeftGridDataProcessor DhtmlXDataProcessor
		
		■ erpRightSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 화면 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / erpLeftGrid DhtmlXGrid Header
		
		■ cmbUSE_YN : Object / 사용여부 DhtmlXCombo (공통코드 : YN_CD)
		■ cmbCMMN_YN : Object / 공통여부 DhtmlXCombo (공통코드 : YN_CD)
	--%>
	var erpLayout;
	var erpTree;
	
	var erpLeftSubLayout;
	var erpLeftRibbon;
	var erpLeftGrid;
	var erpLeftGridColumns;
	var erpLeftGridDataProcessor;
	
	var erpRightSubLayout;
	var erpRightRibbon;
	var erpRightGrid;
	var erpRightGridColumns;
	
	var currentErpTreeId;
	var cmbUSE_YN;
	var cmbCMMN_YN;
	
	$(document).ready(function(){		
		initErpLayout();		
		initErpTree();
		
		initErpLeftSubLayout();
		initErpLeftRibbon();
		initErpLeftGrid();
		
		initErpRightSubLayout();
		initErpRightRibbon();
		initErpRightGrid();
		
		initDhtmlXCombo();
		searchErpTree();
		searchErpRightGrid();
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3W"
			, cells: [
				{id: "a", text: "${menuDto.menu_nm}", header:true, width:220}
				, {id: "b", text: "선택메뉴별화면목록", header:true, width:795, fix_size : [false, true]}
				, {id: "c", text: "전체화면목록", header:true}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_tree");
		erpLayout.cells("b").attachObject("div_erp_left_sub_layout");
		erpLayout.cells("c").attachObject("div_erp_right_sub_layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpLeftSubLayout.setSizes();
			erpRightSubLayout.setSizes();
			erpLeftGrid.setSizes();
			erpRightGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpTree 관련 Function 시작 --%>
	<%-- erpTree 초기화 Function --%>
	function initErpTree(){
		erpTree = new dhtmlXTreeObject({
			parent : "div_erp_tree"
			, skin : ERP_TREE_CURRENT_SKINS			
			, image_path : ERP_TREE_CURRENT_IMAGE_PATH
		});
		erpTree.attachEvent("onClick", function(id){
			if(!$erp.isEmpty(id)){
				<%-- 최상위 일 경우 완전 초기화 --%>
				if(id == "#root"){
					currentErpTreeId = null;
					$erp.clearInputInElement("tb_erp_data");
				} else {
					crud = null;
					currentErpTreeId = id;
					searchErpLeftGrid();
				}
			}
		});
	}
	
	<%-- erpTree 조회 Function --%>
	function searchErpTree(){
		erpLayout.progressOn();
		
		$.ajax({
			url : "/common/system/menu/menuByScreenManagementR1.do"
			,data : {}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					var menuTreeMap = data.menuTreeMap;
					var menuTreeDataList = menuTreeMap.item;
					if($erp.isEmpty(menuTreeDataList)){
						$erp.alertMessage({
							"alertMessage" : "grid.noSearchData"
							, "alertCode" : null
							, "alertType" : "info"
						});
					} else {
						erpTree.deleteChildItems(0);
						erpTree.parse(menuTreeMap, 'json');
						currentErpTreeId = null;
						$erp.clearInputInElement("tb_erp_data");
						erpTree.openAllItems("0");
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpTree 관련 Function 끝 --%>
	
	<%--
	**********************************************************************
	* ※ Left 영역
	**********************************************************************
	--%>	
	
	<%-- ■ erpLeftSubLayout 관련 Function 시작 --%>
	<%-- erpLeftSubLayout 초기화 Function --%>
	function initErpLeftSubLayout(){
		erpLeftSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_left_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, width:200}
				, {id: "b", text: "", header:false, fix_size : [false, true]}
				, {id: "c", text: "", header:false, fix_size : [true, true]}
			]		
			, fullScreen : true
		});
		erpLeftSubLayout.cells("a").attachObject("div_erp_left_contents_search");
		erpLeftSubLayout.cells("a").setHeight(65);
		erpLeftSubLayout.cells("b").attachObject("div_erp_left_ribbon");
		erpLeftSubLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftSubLayout.cells("c").attachObject("div_erp_left_grid");
		
		erpLeftSubLayout.setSeparatorSize(1, 0);
	}	
	<%-- ■ erpLeftSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpLeftRibbon 관련 Function 시작 --%>
	<%-- erpLeftRibbon 초기화 Function --%>
	function initErpLeftRibbon(){
		erpLeftRibbon = new dhtmlXRibbon({
			parent : "div_erp_left_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					//{id : "search_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true, unused : true}
					{id : "add_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					//, {id : "excel_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : true}
					//, {id : "print_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, unused : true}	
				]}							
			]
		});
		
		erpLeftRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpLeftGrid"){
		    	
		    } else if (itemId == "add_erpLeftGrid"){
		    	addErpLeftGrid();
		    } else if (itemId == "delete_erpLeftGrid"){
		    	deleteErpLeftGrid();
		    } else if (itemId == "save_erpLeftGrid"){
		    	saveErpLeftGrid();
		    } else if (itemId == "excel_erpLeftGrid"){
		    	
		    } else if (itemId == "print_erpLeftGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpLeftRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpLeftGrid 관련 Function 시작 --%>	
	<%-- erpLeftGrid 초기화 Function --%>	
	function initErpLeftGrid(){
		erpLeftGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "MENU_CD", label:["메뉴코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "SCRIN_CD", label:["화면코드", "#text_filter"], type: "ro", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "SCRIN_NM", label:["화면명", "#text_filter"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SCRIN_PATH", label:["화면경로", "#text_filter"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MAIN_YN", label:["메인여부", "#select_filter"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["YN_CD","YN"]}
			, {id : "USE_YN", label:["메뉴화면<br/>연동사용여부", "#select_filter"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["YN_CD","YN"]}
			, {id : "SCRIN_USE_YN", label:["화면사용여부상태", "#select_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["YN_CD","YN"]}			
			, {id : "REG_PROGRM", label:["등록프로그램", "#rspan"], type: "ro", width: "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "REG_ID", label:["등록자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "REG_DT", label:["등록일시", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "UPD_PROGRM", label:["수정프로그램", "#rspan"], type: "ro", width: "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "UPD_ID", label:["수정자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "UPD_DT", label:["수정일시", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpLeftGrid = new dhtmlXGridObject({
			parent: "div_erp_left_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpLeftGridColumns			
		});		
		erpLeftGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpLeftGrid);
		$erp.initGridComboCell(erpLeftGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpLeftGrid, '<spring:message code="grid.allRowCount" />');
		
		erpLeftGridDataProcessor = new dataProcessor();
		erpLeftGridDataProcessor.init(erpLeftGrid);
		erpLeftGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpLeftGrid);
	}
	
	<%-- erpLeftGrid 조회 유효성 검사 Function --%>
	function isSearchErpLeftGridValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(currentErpTreeId)){
			isValidated = false;
			alertMessage = "error.common.noSelectedData";
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
	
	<%-- erpLeftGrid 조회 Function --%>
	function searchErpLeftGrid(){
		if(!isSearchErpLeftGridValidate()){
			return;
		}
		
		erpLayout.progressOn();
		
		$.ajax({
			url : "/common/system/menu/menuByScreenManagementR2.do"
			,data : {
				"MENU_CD" : currentErpTreeId
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpLeftGrid);
					$erp.clearInputInElement("tb_erp_left_data");
					var dataMap = data.dataMap;
					if($erp.isEmpty(dataMap)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpLeftGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {						
						$erp.bindTextValue(dataMap, "tb_erp_left_data");						
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
									erpLeftGrid
									, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpLeftGrid.parse(gridDataList, 'js');
						}
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpLeftGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpLeftGrid 추가 유효성 검사 Function --%>
	function isAddErpLeftGridValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var erpRightGridRowCount = erpRightGrid.getRowsNum();
		
		if($erp.isEmpty(currentErpTreeId)){
			isValidated = false;
			alertMessage = "error.common.noSelectedData";
			alertCode = "-1";
		} else 	if(erpRightGridRowCount == 0){
			isValidated = false;
			alertMessage = "error.common.noSelectedRow";
			alertCode = "-2";
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
	
	<%-- erpLeftGrid 추가 Function --%>
	function addErpLeftGrid(){
		if(!isAddErpLeftGridValidate()) { return false };
				
		var erpRightGridRowCount = erpRightGrid.getRowsNum();
		for(var i = 0; i < erpRightGridRowCount; i++){
			var rightRId = erpRightGrid.getRowId(i);
			var check = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("CHECK")).getValue();
			if(check == 1){
				var scrin_cd = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("SCRIN_CD")).getValue();
				var erpLeftGridRowCount = erpLeftGrid.getRowsNum();
				var isAble = true;
				for(var j = 0; j < erpLeftGridRowCount ; j++){
					var leftRid = erpLeftGrid.getRowId(j);
					var menuByScrin_cd = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("SCRIN_CD")).getValue();
					if(scrin_cd == menuByScrin_cd){
						isAble = false;
						break;
					}
				}
				if(isAble === true){
					var uid = erpLeftGrid.uid();
					erpLeftGrid.addRow(uid);
					
					var scrin_nm = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("SCRIN_NM")).getValue();
					var scrin_path = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("SCRIN_PATH")).getValue();					
					var main_yn = "N";
					var use_yn = "Y";
					var scrin_use_yn = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("USE_YN")).getValue();
					
					erpLeftGrid.cells(uid, erpLeftGrid.getColIndexById("MENU_CD")).setValue(currentErpTreeId);
					erpLeftGrid.cells(uid, erpLeftGrid.getColIndexById("SCRIN_CD")).setValue(scrin_cd);
					erpLeftGrid.cells(uid, erpLeftGrid.getColIndexById("SCRIN_NM")).setValue(scrin_nm);
					erpLeftGrid.cells(uid, erpLeftGrid.getColIndexById("SCRIN_PATH")).setValue(scrin_path);
					erpLeftGrid.cells(uid, erpLeftGrid.getColIndexById("MAIN_YN")).setValue(main_yn);
					erpLeftGrid.cells(uid, erpLeftGrid.getColIndexById("USE_YN")).setValue(use_yn);
					erpLeftGrid.cells(uid, erpLeftGrid.getColIndexById("SCRIN_USE_YN")).setValue(scrin_use_yn);
				}
			}
		}
		$erp.setDhtmlXGridFooterRowCount(erpLeftGrid);
	}
	
	<%-- erpLeftGrid 삭제 Function --%>
	function deleteErpLeftGrid(){
		var gridRowCount = erpLeftGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpLeftGrid.getRowId(i);
			var check = erpLeftGrid.cells(rId, erpLeftGrid.getColIndexById("CHECK")).getValue();
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
			erpLeftGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpLeftGrid);
	}
	
	<%-- erpLeftGrid 저장 유효성 검사 Function --%>
	function isSaveErpLeftGridValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var isMainYesCount = 0;
		var erpLeftGridRowCount = erpLeftGrid.getRowsNum();
		for(var i = 0; i < erpLeftGridRowCount ; i++){
			var rId = erpLeftGrid.getRowId(i);
			var tempStatus = erpLeftGrid.getDataProcessor().getState(rId);
			var status = "R";
			if(tempStatus == "inserted"){
				status = "C";
			} else if (tempStatus == "updated"){
				status = "U";
			} else if (tempStatus == "deleted") {
				status = "D";
			}
			
			var main_yn = erpLeftGrid.cells(rId, erpLeftGrid.getColIndexById("MAIN_YN")).getValue();
			<%-- 삭제 건은 검사 안함 --%>
			if(status != "D" && main_yn == "Y"){
				isMainYesCount++;
			}
		}
		
		if(isMainYesCount > 1){
			isValidated = false;
			alertMessage = "error.common.system.menu.menuByScreenManagement.main_yn.mustCountOne";
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
	
	<%-- erpLeftGrid 저장 Function --%>
	function saveErpLeftGrid(){
		if(erpLeftGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpLeftGrid);
		if(validResultMap.isError){
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		if(!isSaveErpLeftGridValidate()){ return false; }
		
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpLeftGrid);		
		$.ajax({
			url : "/common/system/menu/menuByScreenManagementCUD1.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.alertSuccessMesage(onAfterSaveErpLeftGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpLeftGrid 저장 후 Function --%>
	function onAfterSaveErpLeftGrid(){
		searchErpLeftGrid();
	}
	<%-- ■ erpLeftGrid 관련 Function 끝 --%>
	
	<%--
	**********************************************************************
	* ※ Right 영역
	**********************************************************************
	--%>
	<%-- ■ erpRightSubLayout 관련 Function 시작 --%>
	<%-- erpRightSubLayout 초기화 Function --%>
	function initErpRightSubLayout(){
		erpRightSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_right_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, width:200}
				, {id: "b", text: "", header:false, fix_size : [false, true]}
				, {id: "c", text: "", header:false, fix_size : [true, true]}
			]		
			, fullScreen : true
		});
		erpRightSubLayout.cells("a").attachObject("div_erp_right_contents_search");
		erpRightSubLayout.cells("a").setHeight(65);
		erpRightSubLayout.cells("b").attachObject("div_erp_right_ribbon");
		erpRightSubLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightSubLayout.cells("c").attachObject("div_erp_right_grid");
		
		erpRightSubLayout.setSeparatorSize(1, 0);
	}	
	<%-- ■ erpRightSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRightRibbon 관련 Function 시작 --%>
	<%-- erpRightRibbon 초기화 Function --%>
	function initErpRightRibbon(){
		erpRightRibbon = new dhtmlXRibbon({
			parent : "div_erp_right_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpRightGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					//, {id : "add_erpRightGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true, unused : true}
					//, {id : "delete_erpRightGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true, unused : true}
					//, {id : "save_erpRightGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true, unused : true}
					//, {id : "excel_erpRightGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : true}
					//, {id : "print_erpRightGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, unused : true}	
				]}							
			]
		});
		
		erpRightRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpRightGrid"){
		    	searchErpRightGrid();
		    } else if (itemId == "add_erpRightGrid"){
		    	
		    } else if (itemId == "delete_erpRightGrid"){
		    	
		    } else if (itemId == "save_erpRightGrid"){
		    	
		    } else if (itemId == "excel_erpRightGrid"){
		    	
		    } else if (itemId == "print_erpRightGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpRightRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpRightGrid 관련 Function 시작 --%>	
	<%-- erpRightGrid 초기화 Function --%>	
	function initErpRightGrid(){
		erpRightGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "SCRIN_CD", label:["화면코드", "#text_filter"], type: "ro", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "SCRIN_NM", label:["화면명", "#text_filter"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SCRIN_PATH", label:["화면경로", "#text_filter"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "USE_YN", label:["사용여부", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "CMMN_YN", label:["공통여부", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
		];
		
		erpRightGrid = new dhtmlXGridObject({
			parent: "div_erp_right_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpRightGridColumns			
		});		
		erpRightGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpRightGrid);
		$erp.initGridComboCell(erpRightGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpRightGrid, '<spring:message code="grid.allRowCount" />');
	}
	
	<%-- erpRightGrid 조회 유효성 검사 Function --%>
	function isSearchErpRightGridValidate(){
		var isValidated = true;		
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var scrin_cd = document.getElementById("txtSCRIN_CD").value;
		
		if($erp.isLengthOver(scrin_cd, 50)){
			isValidated = false;
			alertMessage = "error.common.system.menu.scrin_nm.length50Over";
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
	
	<%-- erpRightGrid 조회 Function --%>
	function searchErpRightGrid(){
		if(!isSearchErpRightGridValidate()){
			return;
		}
		
		erpLayout.progressOn();
		
		var scrin_cd = document.getElementById("txtSCRIN_CD").value;
		var use_yn = cmbUSE_YN.getSelectedValue();
		var cmmn_yn = cmbCMMN_YN.getSelectedValue();
		
		$.ajax({
			url : "/common/system/menu/menuByScreenManagementR3.do"
			,data : {
				"SCRIN_CD" : scrin_cd
				, "USE_YN" : use_yn
				, "CMMN_YN" : cmmn_yn
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpRightGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpRightGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpRightGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpRightGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlxCombo 관련 Function 시작 --%>
	<%-- dhtmlxCombo 초기화 Function --%>
	function initDhtmlXCombo(){
		cmbUSE_YN = $erp.getDhtmlXCombo('cmbUSE_YN', 'USE_YN', ['YN_CD','YN'], 100, true);
		cmbCMMN_YN = $erp.getDhtmlXCombo('cmbCMMN_YN', 'CMMN_YN', ['YN_CD','YN'], 100, true);
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_tree" class="div_tree_full_size"></div>		
	
	<div id="div_erp_left_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_left_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_left_grid" class="div_grid_full_size" style="display:none"></div>
	
	<div id="div_erp_right_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_right_ribbon" class="div_ribbon_full_size" style="display:none"></div>	
	<div id="div_erp_right_grid" class="div_grid_full_size" style="display:none"></div>	
	
	<div id="div_erp_left_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_left_data" class="table_search">
			<colgroup>
				<col width="150px">
				<col width="150px">
				<col width="150px">
				<col width="*">				
			</colgroup>
			<tr>
				<th>선택 메뉴코드</th>
				<td><input type="text" id="txtMENU_CD" name="MENU_CD" class="input_common input_readonly" maxlength="20" readonly="readonly"></td>
				<th>선택 메뉴명</th>
				<td><input type="text" id="txtMENU_NM" name="MENU_NM" class="input_common input_readonly" maxlength="50" readonly="readonly"></td>				
			</tr>
			<tr>
				<th>선택 메뉴 메인 화면코드</th>
				<td><input type="text" id="txtMAIN_SCRIN_CD" name="MAIN_SCRIN_CD" class="input_common input_readonly" maxlength="20" readonly="readonly"></td>
				<th>선택 메뉴 메인 화면명</th>
				<td><input type="text" id="txtMAIN_SCRIN_NM" name="MAIN_SCRIN_NM" class="input_common input_readonly" maxlength="50" readonly="readonly"></td>				
			</tr>
		</table>
	</div>
	<div id="div_erp_right_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="150px">
				<col width="150px">
				<col width="150px">
				<col width="*">		
			</colgroup>
			<tr>
				<th>화면코드/화면명</th>
				<td colspan="3"><input type="text" id="txtSCRIN_CD" name="SCRIN_CD" class="input_common" maxlength="505" onkeydown="$erp.onEnterKeyDown(event, searchErpRightGrid);"></td>				
			</tr>
			<tr>
				<th>사용여부</th>
				<td><div id="cmbUSE_YN"></div></td>
				<th>공통여부</th>
				<td><div id="cmbCMMN_YN"></div></td>
			</tr>
		</table>
	</div>
</body>
</html>