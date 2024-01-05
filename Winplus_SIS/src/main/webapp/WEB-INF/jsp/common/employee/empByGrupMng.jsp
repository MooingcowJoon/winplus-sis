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
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	var erpPopupLayout;
	var erpPopupLeftLayout;
	var erpPopupRightLayout;
	var erpGroupRibbon;
	var erpCustmrRibbon;
	var erpGroupGrid;
	var erpCustmrGrid;
	var erpGroupGridColumns;
	var erpCustmrGridColumns;
	var erpGroupGridDataProcessor;
	var erpCustmrGridDataProcessor;
	var GRUP_CD = "";
	var select_orgn_cd = "";
	var check_value = 0;
	var prev_check_rId;
	var cmbORGN_CD;
	
	$(document).ready(function(){
		initErpPopupLayout();
		initErpLeftLayout();
		initGroupRibbon();
		initErpGroupGrid();
		initErpRightLayout();
		initCustmrRibbon();
		initErpCustmrGrid();
		initDhtmlXCombo();
		
		searchGroupList();
		
	});

	function initErpPopupLayout() {
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2U"
			, cells : [
				{id: "a", text : "거래처그룹", header : true}
				, {id: "b", text : "거래처그룹상세", header : true, fix_size:[true, true]}
			]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_left_layout");
		erpPopupLayout.cells("a").setWidth(820);
		erpPopupLayout.cells("b").attachObject("div_erp_right_layout");
		
		erpPopupLayout.setSeparatorSize(1,0);
		
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupLeftLayout.setSizes();
			erpPopupRigthLayout.setSizes();
		});
	}
	
	function initErpLeftLayout(){
		erpPopupLeftLayout = new dhtmlXLayoutObject({
			parent : "div_erp_left_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "거래처그룹조건영역", header : false, fix_size:[true, true]}
				, {id: "b", text: "거래처그룹리본영역", header : false, fix_size:[true, true]}
				, {id: "c", text: "거래처그룹그리드영역", header : false, fix_size:[true, true]}
			]
		});
		
		erpPopupLeftLayout.cells("a").attachObject("div_erp_group_search");
		erpPopupLeftLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLeftLayout.cells("b").attachObject("div_erp_group_ribbon");
		erpPopupLeftLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLeftLayout.cells("c").attachObject("div_erp_group_grid");
		
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupLeftLayout.setSizes();
			erpGroupGrid.setSizes();
			//erpCustmrGrid.setSizes();
		});
	}
	
	
	function initGroupRibbon() {
		erpGroupRibbon = new dhtmlXRibbon({
			parent : "div_erp_group_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : "rows", list : [
					{id : "search_erp_group_Grid", type : "button", text :'조회', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					, {id : "add_erp_group_Grid", type : "button", text :'추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_group_Grid", type : "button", text:'삭제', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erp_group_Grid", type : "button", text:'저장', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					//, {id : "apply_erp_group_Grid", type : "button", text:'그룹적용', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : true}
				]}
			]
		});
		
		erpGroupRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erp_group_Grid"){
				searchGroupList();
			}else if(itemId == "add_erp_group_Grid") {
				addErpGroupGrid();
			} else if(itemId == "delete_group_Grid"){
				deleteErpGroupGrid();
			} else if(itemId == "save_erp_group_Grid"){
				saveErpGroupGrid();
			}
		});
		
	}
	
	function initErpRightLayout(){
		erpPopupRigthLayout = new dhtmlXLayoutObject({
			parent : "div_erp_right_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "거래처집합상세리본영역", header: false}
				, {id: "b", text: "거래처집합상세그리드영역", header: false, fix_size:[true, true]}
			]
		});
		
		erpPopupRigthLayout.cells("a").attachObject("div_erp_custmr_ribbon");
		erpPopupRigthLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupRigthLayout.cells("b").attachObject("div_erp_custmr_grid");
		
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupRigthLayout.setSizes();
			//erpGroupGrid.setSizes();
			erpCustmrGrid.setSizes();
		});
	}
	
	function initCustmrRibbon() {
		erpCustmrRibbon = new dhtmlXRibbon({
			parent : "div_erp_custmr_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : "rows", list : [
					{id : "search_erp_custmr_Grid", type : "button", text : '추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					//, {id : "add_erp_custmr_Grid", type : "button", text:'거래처추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_erp_custmr_Grid", type : "button", text:'삭제', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erp_custmr_Grid", type : "button", text:'저장', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}           
			]
		});
		
		erpCustmrRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erp_custmr_Grid") {
				if(GRUP_CD == ""){
					$erp.alertMessage({
						"alertMessage" : "사용자별거래처그룹을 지정 후 이용가능합니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
				}else {
					openSearchCustmrGridPopup();
				}
			}/*  else if(itemId == "add_erp_custmr_Grid") {
				addErpCustmrGrid();
			}  */else if(itemId == "delete_erp_custmr_Grid"){
				deleteErpCustmrGrid();
			} else if(itemId == "save_erp_custmr_Grid"){
				saveErpCustmrGrid();
			}
		});
	}
	
	function initErpGroupGrid() {
		erpGroupGridColumns = [
		{id: "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
		, {id : "ORGN_CD", label:["조직명"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true, commonCode : ["ORGN_CD", "", "", "", "", "MK"]}
		, {id : "GRUP_CD", label:["거래처그룹"], type: "ro", width: "100", sort : "int", align : "center", isHidden : false, isEssential : false}
		, {id : "GRUP_NM", label:["거래처집합명"], type: "ed", width: "200", sort : "int", align : "left", isHidden : false, isEssential : true}
		, {id : "USE_YN", label:["사용여부"], type: "combo", width: "90", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["USE_CD","YN"]}
		, {id : "RESP_USER", label:["담당자"], type: "ro", width: "100", sort : "int", align : "center", isHidden : false, isEssential : false}
		, {id : "CDATE", label:["등록일시"], type: "ro", width: "140", sort : "date", align : "center", isHidden : false, isEssential : false}
		];
		
		erpGroupGrid = new dhtmlXGridObject({
			parent : "div_erp_group_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGroupGridColumns
		});
		
		erpGroupGrid.enableDistributedParsing(true, 100, 50);
		erpGroupGrid.enableBlockSelection();
		$erp.initGridCustomCell(erpGroupGrid);
		$erp.initGridComboCell(erpGroupGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpGroupGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGroupGridDataProcessor = new dataProcessor();
		erpGroupGridDataProcessor.init(erpGroupGrid);
		erpGroupGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpGroupGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGroupGrid, 100);
		
		erpGroupGrid.attachEvent("onRowDblClicked", function(rId, cInd){
			if(cInd != this.getColIndexById("GRUP_NM") && cInd != this.getColIndexById("USE_YN") && cInd != this.getColIndexById("ORGN_CD")){
				GRUP_CD = erpGroupGrid.cells(rId, erpGroupGrid.getColIndexById("GRUP_CD")).getValue();
				select_orgn_cd = erpGroupGrid.cells(rId, erpGroupGrid.getColIndexById("ORGN_CD")).getValue();
				
				searchCustmrList(GRUP_CD, select_orgn_cd);
			}else{
				GRUP_NM = erpGroupGrid.cells(rId, erpGroupGrid.getColIndexById("GRUP_NM")).getValue();
				USE_YN = erpGroupGrid.cells(rId, erpGroupGrid.getColIndexById("USE_YN")).getValue();
				ORGN_CD = erpGroupGrid.cells(rId, erpGroupGrid.getColIndexById("ORGN_CD")).getValue();
				erpGroupGrid.editCell();
			}
		});
	
		erpGroupGrid.attachEvent("onCheck", function(rId,cInd, state){
			if(cInd == this.getColIndexById("CHECK")){
				if(check_value == 0){
					prev_check_rId = rId;
					check_value = check_value +  1;
				} else {
					if(prev_check_rId != rId){
						if(this.cells(prev_check_rId, this.getColIndexById("CHECK")).getValue() == 1) {
							this.cells(prev_check_rId, this.getColIndexById("CHECK")).setValue(0);
							prev_check_rId = rId;
						}
					}else {
						check_value = 0;
					}
				}
			}
			
		 });
		
	}
	
	function initErpCustmrGrid() {
		erpCustmrGridColumns = [
		{id: "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
		, {id : "ORGN_CD", label:["조직코드"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
		, {id : "GRUP_CD", label:["거래처그룹"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
		, {id : "SEQ", label:["순번"], type: "ro", width: "30", sort : "str", align : "center", isHidden : true, isEssential : false}
		, {id : "OBJ_CD", label:["거래처코드"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
		, {id : "PUR_SALE_TYPE", label:["거래구분"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["PUR_SALE_TYPE"], isDisabled : true}
		, {id : "OBJ_NM", label:["거래처명"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : false}
		, {id : "USE_YN", label:["사용여부"], type: "combo", width: "85", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["USE_CD","YN"]}
		];
		
		erpCustmrGrid = new dhtmlXGridObject({
			parent : "div_erp_custmr_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpCustmrGridColumns
		});
		
		erpCustmrGrid.attachEvent("onKeyPress",onDetailKeyPressed);
		erpCustmrGrid.enableBlockSelection();
		erpCustmrGrid.enableDistributedParsing(true, 100, 50);
		erpCustmrGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpCustmrGrid);
		$erp.initGridComboCell(erpCustmrGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpCustmrGrid, '<spring:message code="grid.allRowCount" />');
		
		erpCustmrGridDataProcessor = new dataProcessor();
		erpCustmrGridDataProcessor.init(erpCustmrGrid);
		erpCustmrGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpCustmrGrid);
		$erp.attachDhtmlXGridFooterPaging(erpCustmrGrid, 100);
	}
	
	function addErpGroupGrid(){
		var selected_orgn_cd = cmbORGN_CD.getSelectedValue();
		console.log(selected_orgn_cd);
		if(selected_orgn_cd == ""){
			$erp.alertMessage({
				"alertMessage" : "'센터/직영점'을 선택 후에 그룹추가 가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		} else {
			var uid = erpGroupGrid.uid();
			erpGroupGrid.addRow(uid);
			erpGroupGrid.selectRow(erpGroupGrid.getRowIndex(uid));
			erpGroupGrid.cells(uid, erpGroupGrid.getColIndexById("ORGN_CD")).setValue(selected_orgn_cd);
			erpGroupGrid.cells(uid, erpGroupGrid.getColIndexById("GRUP_CD")).setValue("신규");
			$erp.setDhtmlXGridFooterRowCount(erpGroupGrid);
		}
	}
	
	function deleteErpGroupGrid(){
		var gridRowCount = erpGroupGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpGroupGrid.getRowId(i);
			var check = erpGroupGrid.cells(rId, erpGroupGrid.getColIndexById("CHECK")).getValue();
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
			erpGroupGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpGroupGrid);
	}
	
	function saveErpGroupGrid(){
		if(erpGroupGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpGroupGrid);
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		erpPopupLayout.progressOn();
		//var paramData = $erp.dataSerializeOfGrid(erpGroupGrid); //대리님 소스
		var paramData = $erp.serializeDhtmlXGridData(erpGroupGrid);
		$.ajax({
			url : "/common/employee/saveEmpByGrupList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpCustmrGrid);
					searchGroupList();
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		erpPopupLayout.progressOff();
	}
	
	function searchGroupList(){
		erpPopupLeftLayout.progressOn();
		$.ajax({
			url : "/common/employee/getEmpByGrupList.do"
			,data : {
				"ORGN_CD" : cmbORGN_CD.getSelectedValue()
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupLeftLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGroupGrid);
					$erp.clearDhtmlXGrid(erpCustmrGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGroupGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpGroupGrid.parse(gridDataList, 'js');	
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGroupGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function searchCustmrList(group_cd, orgn_cd) {
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/common/employee/getEmpGrupDetailList.do"
			,data : {
				"GRUP_CD" : group_cd
				, "ORGN_CD" : orgn_cd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpCustmrGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpCustmrGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpCustmrGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpCustmrGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function openSearchCustmrGridPopup(){
		var pur_sale_type = "3"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		
		var onRowSelect = function(id, ind) {
			console.log(this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue());
			console.log(this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue());
			var custmr_cd = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			var custmr_nm = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			
			var uid = erpCustmrGrid.uid();
			erpCustmrGrid.addRow(uid);
			erpCustmrGrid.selectRow(erpCustmrGrid.getRowIndex(uid));
			erpCustmrGrid.cells(uid, erpCustmrGrid.getColIndexById("OBJ_CD")).setValue(custmr_cd);
			erpCustmrGrid.cells(uid, erpCustmrGrid.getColIndexById("OBJ_NM")).setValue(custmr_nm);
			erpCustmrGrid.cells(uid, erpCustmrGrid.getColIndexById("GRUP_CD")).setValue(GRUP_CD);
			erpCustmrGrid.cells(uid, erpCustmrGrid.getColIndexById("USE_YN")).setValue("Y");
			$erp.setDhtmlXGridFooterRowCount(erpCustmrGrid);
			
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		
		var onClickRibbonAddData = function(popupGrid){
			//dataState : checked,selected  //copyType : add,new
			var popup = erpPopupWindows.window("openSearchCustmrGridPopup");
			popup.progressOn();
			$erp.copyRowsGridToGrid(popupGrid, erpCustmrGrid, ["CUSTMR_CD","CUSTMR_NM"], ["OBJ_CD","OBJ_NM"], "checked", "add", ["USE_YN"], [], {"USE_YN" : "Y", }, {"USE_YN" : "Y", "GRUP_CD" : GRUP_CD}, function(){
				popup.progressOff();
				popup.close();
			}, false);
		}
		
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type, onClickRibbonAddData);
	}
	
	function deleteErpCustmrGrid(){
		var gridRowCount = erpCustmrGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpCustmrGrid.getRowId(i);
			var check = erpCustmrGrid.cells(rId, erpCustmrGrid.getColIndexById("CHECK")).getValue();
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
			erpCustmrGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpCustmrGrid);
	}
	
	function onDetailKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpCustmrGrid.setCSVDelimiter("\t");
			erpCustmrGrid.copyBlockToClipboard();
		}
		if(code==86&&ctrl){
			erpCustmrGrid.setCSVDelimiter("\t");
			erpCustmrGrid.pasteBlockFromClipboard();
		}
			
		return true;
	}
	
	function saveErpCustmrGrid() {
		if(erpCustmrGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpCustmrGrid);
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		erpPopupLayout.progressOn();
		//var paramData = $erp.dataSerializeOfGrid(erpGroupGrid); //대리님 소스
		var paramData = $erp.serializeDhtmlXGridData(erpCustmrGrid);
		paramData["ORGN_CD"] = select_orgn_cd;
		$.ajax({
			url : "/common/employee/saveEmpByGrupDetailList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var resultRowCnt = data.resultRowCnt;
					if($erp.isEmpty(resultRowCnt)){
						console.log("0건이 저장되었습니다.");
					} else {
						console.log("총 " + resultRowCnt + "건이 수정 또는 추가되었습니다.");	
						searchCustmrList(GRUP_CD, select_orgn_cd);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function initDhtmlXCombo(){
		var searchable = 1;
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",")
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
			searchable = 2;
			}
		}
		if(searchable == 1 ){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 110, false, LUI.LUI_orgn_cd);
		}else if(searchable == 2){
			cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD", "", "", "", "","MK"], 100, "모두조회", false, LUI.LUI_orgn_cd);
		}
	}
</script>
</head>
<body>
	<div id="div_erp_left_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_group_search" class="div_erp_contents_search" style="display:none;">
			<table class="table_search">
				<colgroup>
					<col width="85px">
					<col width="*">
				</colgroup>
				<tr>
					<th>조직명</th>
					<td>
						<div id="cmbORGN_CD"></div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="div_erp_group_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_group_grid" class="div_grid_full_size" style="display:none"></div>
	
	<div id="div_erp_right_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_custmr_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_custmr_grid" class="div_grid_full_size" style="display:none"></div>
	
</body>
</html>