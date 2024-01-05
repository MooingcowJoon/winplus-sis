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
	LUI.exclude_auth_cd = "ALL,1";
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openGoodsGroupGridPopup");
	var erpPopupLayout;
	var erpPopupLeftLayout;
	var erpPopupRightLayout;
	var erpGroupRibbon;
	var erpGoodsRibbon;
	var erpGroupGrid;
	var erpGoodsGrid;
	var erpCustmrGrid;
	var erpGroupGridColumns;
	var erpGoodsGridColumns;
	var erpCustmrGridColumns;
	var erpGroupGridDataProcessor;
	var erpGoodsGridDataProcessor;
	var erpCustmrGridDataProcessor;
	var erpPopupDetailGrid;
	var GRUP_CD;
	var GoodsGroupDetailList;
	var check_value = 0;
	var prev_check_rId;
	var result_radio;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	


	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("사용자별그룹관리팝업");
		}
		initErpPopupLayout();
		initErpLeftLayout();
		initErpRightLayout();
		initGroupRibbon();
		initGoodsRibbon();
		initErpGroupGrid();
		initErpGoodsGrid();
		initDthmlxCombo();
		
		$erp.asyncObjAllOnCreated(function(){
			searchGroupList();
		});
	});

	
	function initErpPopupLayout() {
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2U"
			, cells : [
				{id: "a", text : "사용자별그룹", header : true, width: 540}
				, {id: "b", text : "사용자별그룹상세", header : true}
			]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_left_layout");
		erpPopupLayout.cells("b").attachObject("div_erp_right_layout");
		
		erpPopupLayout.setSeparatorSize(1,0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupLeftLayout.setSizes();
			erpPopupRightLayout.setSizes();
		});
	}
	
	function initErpLeftLayout(){
		erpPopupLeftLayout = new dhtmlXLayoutObject({
			parent : "div_erp_left_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				 {id: "a", text: "사용자별그룹조회조건", header : false, fix_size:[true, true]}
				, {id: "b", text: "사용자별그룹리본영역", header : false, fix_size:[true, true]}
				, {id: "c", text: "사용자별그룹그리드영역", header : false, fix_size:[true, true]}
			]
		});
		
		erpPopupLeftLayout.cells("a").attachObject("div_erp_group_search_codition");
		erpPopupLeftLayout.cells("a").setHeight(58);
		erpPopupLeftLayout.cells("b").attachObject("div_erp_group_ribbon");
		erpPopupLeftLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLeftLayout.cells("c").attachObject("div_erp_group_grid");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpPopupLeftLayout, function(names){
			erpGroupGrid.setSizes();
			erpCustmrGrid.setSizes();
			erpGoodsGrid.setSizes();
		});
		
	}
	
	
	function initGroupRibbon() {
		erpGroupRibbon = new dhtmlXRibbon({
			parent : "div_erp_group_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : "rows", list : [
					{id : "search_erp_group_Grid", type : "button", text :'그룹조회', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					, {id : "add_erp_group_Grid", type : "button", text :'그룹추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_group_Grid", type : "button", text:'그룹삭제', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erp_group_Grid", type : "button", text:'그룹저장', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					, {id : "apply_erp_group_Grid", type : "button", text:'그룹적용', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : true}
				]}           
			]
		});
		
		erpGroupRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erp_group_Grid"){
				searchGroupList();
			} else if(itemId == "add_erp_group_Grid") {
				addErpGroupGrid();
			} else if(itemId == "delete_group_Grid"){
				deleteErpGroupGrid();
			} else if(itemId == "save_erp_group_Grid"){
				saveErpGroupGrid();
			} else if(itemId == "apply_erp_group_Grid"){
				UseGoodsGroup();
			}
		});
		
	}
	
	function initErpRightLayout(){
		erpPopupRightLayout = new dhtmlXLayoutObject({
			parent : "div_erp_right_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "사용자별그룹상세리본영역", header: false}
				, {id: "b", text: "사용자별그룹상세그리드영역", header: false, fix_size:[true, true]}
			]
		});
		
		erpPopupRightLayout.cells("a").attachObject("div_erp_goods_ribbon");
		erpPopupRightLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupRightLayout.cells("b").attachObject("div_erp_detail_grid");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpPopupLeftLayout, function(names){
			erpGroupGrid.setSizes();
			erpCustmrGrid.setSizes();
			erpGoodsGrid.setSizes();
		});
	}
	
	function initGoodsRibbon() {
		erpGoodsRibbon = new dhtmlXRibbon({
			parent : "div_erp_goods_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : "rows", list : [
					{id : "search_erp_goods_Grid", type : "button", text : '조회', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					, {id : "add_erp_goods_Grid", type : "button", text:'추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_erp_goods_Grid", type : "button", text:'삭제', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erp_goods_Grid", type : "button", text:'내역저장', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}           
			]
		});
		
		erpGoodsRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erp_goods_Grid") {
				if(result_radio == "G"){
					openSearchGoodsGridPopup();
				} else if(result_radio == "C"){
					openSearchCustmrGridPopup();
				}
			} else if(itemId == "add_erp_goods_Grid") {
				if(result_radio == "G") {
					addErpDetailGrid(erpGoodsGrid);
				} else if(result_radio == "C") {
					addErpDetailGrid(erpCustmrGrid);
				}
			} else if(itemId == "delete_erp_goods_Grid"){
				if(result_radio == "G"){
					deleteErpDetailGrid(erpGoodsGrid);
				} else if(result_radio == "C"){
					deleteErpDetailGrid(erpCustmrGrid);
				}
			} else if(itemId == "save_erp_goods_Grid"){
				if(result_radio == "G") {
					saveErpDetailGrid(erpGoodsGrid);					
				} else if(result_radio == "C") {
					saveErpDetailGrid(erpCustmrGrid);
				}
			}
		});
	}
	
	function initErpGroupGrid() {
		erpGroupGridColumns = [
		  {id: "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		  , {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
		  , {id : "SELECT", label : ["선택"], type : "ra", width : "40", sort : "str", align : "center", isHidden : false, isEssential : false}
		  , {id : "GRUP_TYPE", label:["그룹유형"], type: "combo", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false, commonCode:"USER_GRUP_TYPE"}
		  , {id : "ORGN_CD", label:["점포명"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : ["ORGN_CD", "", "", "", "", "MK"]}
		  , {id : "GRUP_CD", label:["그룹코드"], type: "ro", width: "120", sort : "int", align : "center", isHidden : true, isEssential : false}
		  , {id : "GRUP_NM", label:["그룹명"], type: "ed", width: "120", sort : "int", align : "left", isHidden : false, isEssential : true}
		  , {id : "RESP_USER", label:["담당자"], type: "ro", width: "100", sort : "int", align : "center", isHidden : false, isEssential : false}
		  , {id : "CDATE", label:["등록일시"], type: "ro", width: "130", sort : "int", align : "center", isHidden : false, isEssential : false}
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
		
		erpGroupGrid.attachEvent("onCheck", function(rId,cInd, state){
			if(cInd == this.getColIndexById("SELECT")){
				GRUP_CD = this.cells(rId, this.getColIndexById("GRUP_CD")).getValue();
				searchDetailList(GRUP_CD);
			}
		 });
		
	}
	
	function initErpGoodsGrid() {
		erpPopupDetailGrid = {};
		
		// ================================== 상품그룹상세 ========================================================
		erpGoodsGridColumns = [
   		  {id: "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		  , {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
		  , {id : "SEQ", label:["순서"], type: "ro", width: "120", sort : "int", align : "center", isHidden : true, isEssential : false}
		  , {id : "ORGN_CD", label:["조직코드"], type: "ro", width: "120", sort : "int", align : "center", isHidden : true, isEssential : false}
		  , {id : "GRUP_CD", label:["그룹코드"], type: "ro", width: "120", sort : "int", align : "center", isHidden : true, isEssential : false}
		  , {id : "OBJ_CD", label:["상품바코드"], type: "edn", width: "100", sort : "int", align : "left", isHidden : false, isEssential : false}
		  , {id : "OBJ_NM", label:["상품명"], type: "ro", width: "170", sort : "int", align : "left", isHidden : false, isEssential : false}
		  , {id : "DIMEN_NM", label:["규격"], type: "ro", width: "100", sort : "int", align : "left", isHidden : false, isEssential : false}                  
		  , {id : "SALE_PRICE", label:["판매가"], type: "ron", width: "120", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
   		];
   		
   		erpGoodsGrid = new dhtmlXGridObject({
   			parent : "div_erp_goods_grid"
   			, skin : ERP_GRID_CURRENT_SKINS
   			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
   			, columns : erpGoodsGridColumns
   		});
   		
   		
   		erpGoodsGrid.attachEvent("onRowPaste", function(rId){   //엑셀붙여넣기시 자동으로 행추가
			var tmpRowIndex = erpGoodsGrid.getRowIndex(rId);
			if(erpGoodsGrid.getRowId((tmpRowIndex+1)) == null || erpGoodsGrid.getRowId((tmpRowIndex+1)) == "null" || erpGoodsGrid.getRowId((tmpRowIndex+1)) == undefined || erpGoodsGrid.getRowId((tmpRowIndex+1)) == "undefined" ){
				addErpDetailGrid(erpGoodsGrid);
			}
			getDetailGoodsList(rId); // 바코드 붙여넣기 완료 시 상품정보 가져오기
        });
   		
   		erpGoodsGrid.attachEvent("onKeyPress",onDetailKeyPressed);
   		erpGoodsGrid.enableBlockSelection();
   		erpGoodsGrid.enableDistributedParsing(true, 100, 50);
   		erpGoodsGrid.enableAccessKeyMap(true);
   		$erp.initGridCustomCell(erpGoodsGrid);
   		$erp.initGridComboCell(erpGoodsGrid);				
   		$erp.attachDhtmlXGridFooterRowCount(erpGoodsGrid, '<spring:message code="grid.allRowCount" />');
   		
   		erpGoodsGridDataProcessor = new dataProcessor();
   		erpGoodsGridDataProcessor.init(erpGoodsGrid);
   		erpGoodsGridDataProcessor.setUpdateMode("off");
   		$erp.initGridDataColumns(erpGoodsGrid);
   		$erp.attachDhtmlXGridFooterPaging(erpGoodsGrid, 100);
   		
   		erpPopupDetailGrid["div_erp_goods_grid"] = erpGoodsGrid;
   		
   		document.getElementById("div_erp_goods_grid").style.display = "block";
   		
   		
   		// ================================ 거래처그룹상세 ================================
   		erpCustmrGridColumns = [
   				{id: "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
	  		  , {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
	  		  , {id : "SEQ", label:["순서"], type: "ron", width: "80", sort : "int", align : "center", isHidden : true, isEssential : false}
	  		  , {id : "ORGN_CD", label:["조직코드"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false}
	  		  , {id : "GRUP_CD", label:["그룹코드"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false}
	  		  , {id : "OBJ_CD", label:["거래처코드"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
	  		  , {id : "OBJ_NM", label:["거래처명"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
   		];
   		
   		erpCustmrGrid = new dhtmlXGridObject({
   			parent : "div_erp_custmr_grid"
   			, skin : ERP_GRID_CURRENT_SKINS
   			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
   			, columns : erpCustmrGridColumns
   		});
   		
   		erpCustmrGrid.enableDistributedParsing(true, 100, 50);
   		$erp.initGridCustomCell(erpCustmrGrid);
   		$erp.initGridComboCell(erpCustmrGrid);				
   		$erp.attachDhtmlXGridFooterRowCount(erpCustmrGrid, '<spring:message code="grid.allRowCount" />');
   		
   		erpCustmrGridDataProcessor = new dataProcessor();
   		erpCustmrGridDataProcessor.init(erpCustmrGrid);
   		erpCustmrGridDataProcessor.setUpdateMode("off");
   		$erp.initGridDataColumns(erpCustmrGrid);
   		$erp.attachDhtmlXGridFooterPaging(erpCustmrGrid, 100);
   		
   		erpPopupDetailGrid["div_erp_custmr_grid"] = erpCustmrGrid;
	}
	
	function addErpGroupGrid(){
		var uid = erpGroupGrid.uid();
		erpGroupGrid.addRow(uid);
		erpGroupGrid.selectRow(erpGroupGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpGroupGrid);
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
		paramData["GRUP_TYPE"] = result_radio;
		console.log(paramData);
		$.ajax({
			url : "/common/popup/SaveGoodsGroupList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					searchGroupList();
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function searchGroupList(){
		var rdo_goods = document.getElementById("condition_goods").checked;
		var rdo_custmr = document.getElementById("condition_custmr").checked;
		result_radio = "";
		
		if(rdo_goods == true){
			result_radio = "G";
			document.getElementById("div_erp_goods_grid").style.display = "block";
			document.getElementById("div_erp_custmr_grid").style.display = "none";
			$erp.clearDhtmlXGrid(erpCustmrGrid);
		} else if(rdo_custmr == true){
			result_radio = "C";
			document.getElementById("div_erp_goods_grid").style.display = "none";
			document.getElementById("div_erp_custmr_grid").style.display = "block";
			$erp.clearDhtmlXGrid(erpGoodsGrid);
		}
		
		$.ajax({
			url : "/common/popup/SearchGoodsGroupList.do"
			,data : {
				"GRUP_TYPE" : result_radio
				, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
				, "ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGroupGrid);
					$erp.clearDhtmlXGrid(erpGoodsGrid);
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
	
	function searchDetailList(group_cd) {
		var selected_rId = erpGroupGrid.getCheckedRows(erpGroupGrid.getColIndexById("SELECT"));
		var selected_grup_orgn_cd = erpGroupGrid.cells(selected_rId, erpGroupGrid.getColIndexById("ORGN_CD")).getValue();
		$.ajax({
			url : "/common/popup/SearchGoodsGroupDetailList.do"
			,data : {
				"GRUP_CD" : group_cd
				, "GRUP_TYPE" : result_radio
				, "ORGN_CD" : selected_grup_orgn_cd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					if(result_radio == "G") {
						$erp.clearDhtmlXGrid(erpGoodsGrid);
						
						var gridDataList = data.gridDataList;
						
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpGoodsGrid
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpGoodsGrid.parse(gridDataList, 'js');	
						}
					} else if(result_radio == "C"){
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
				}
				$erp.setDhtmlXGridFooterRowCount(erpGoodsGrid);
				$erp.setDhtmlXGridFooterRowCount(erpCustmrGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function openSearchGoodsGridPopup(){
		var ra_check = 0;
		var gridRowCount = erpGroupGrid.getRowsNum();
		for(var i = 0 ; i < gridRowCount ; i++){
			ra_check += erpGroupGrid.cells(erpGroupGrid.getRowId(i), erpGroupGrid.getColIndexById("SELECT")).getValue();
		}
		
		if(ra_check == 0){
			$erp.alertMessage({
				"alertMessage" : "error.sis.usergrup_no_selected"
				, "alertCode" : null
				, "alertType" : "error"
			});
		} else {
			var pur_sale_type = "1";
			var onClickRibbonAddData = function(popupGrid){
				//dataState : checked,selected  //copyType : add,new
				var popup = erpPopupWindows.window("openSearchGoodsGridPopup");
	    		popup.progressOn();
				$erp.copyRowsGridToGrid(popupGrid, erpGoodsGrid, ["BCD_CD","BCD_NM", "ORGN_CD"], ["OBJ_CD","OBJ_NM", "ORGN_CD"], "checked", "add", [], [], null, {"GRUP_CD" : GRUP_CD}, function(){
					popup.progressOff();
					popup.close();
				}, false);
	    	}
			$erp.openSearchGoodsPopup(null, onClickRibbonAddData, {"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue() , "ORGN_CD" : cmbORGN_CD.getSelectedValue()});
		}
	}
	
	function openSearchCustmrGridPopup() {
		var ra_check = 0;
		var gridRowCount = erpGroupGrid.getRowsNum();
		for(var i = 0 ; i < gridRowCount ; i++){
			ra_check += erpGroupGrid.cells(erpGroupGrid.getRowId(i), erpGroupGrid.getColIndexById("SELECT")).getValue();
		}
		
		if(ra_check == 0){
			$erp.alertMessage({
				"alertMessage" : "error.sis.usergrup_no_selected"
				, "alertCode" : null
				, "alertType" : "error"
			});
		} else {
		
			var pur_sale_type = "1";
			
			var onClickRibbonAddData = function(popupGrid){
				var selected_rId = erpGroupGrid.getCheckedRows(erpGroupGrid.getColIndexById("SELECT"));
				var selected_grup_orgn_cd = erpGroupGrid.cells(selected_rId, erpGroupGrid.getColIndexById("ORGN_CD")).getValue();
				//dataState : checked,selected  //copyType : add,new
				var popup = erpPopupWindows.window("openSearchCustmrGridPopup");
	    		popup.progressOn();
				$erp.copyRowsGridToGrid(popupGrid, erpCustmrGrid, ["CUSTMR_CD","CUSTMR_NM"], ["OBJ_CD","OBJ_NM"], "checked", "add", [], [], null, {"GRUP_CD" : GRUP_CD, "ORGN_CD" : selected_grup_orgn_cd}, function(){
					popup.progressOff();
					popup.close();
				}, false);
	    	}
			
			$erp.searchCustmrPopup(null, pur_sale_type, onClickRibbonAddData);
		}
	}
	
	function addErpDetailGrid(DetailGrid){
		var ra_check = 0;
		var gridRowCount = erpGroupGrid.getRowsNum();
		for(var i = 0 ; i < gridRowCount ; i++){
			ra_check += erpGroupGrid.cells(erpGroupGrid.getRowId(i), erpGroupGrid.getColIndexById("SELECT")).getValue();
		}
		
		if(ra_check == 0){
			$erp.alertMessage({
				"alertMessage" : "error.sis.usergrup_no_selected"
				, "alertCode" : null
				, "alertType" : "error"
			});
		} else {
			var uid = DetailGrid.uid();
			DetailGrid.addRow(uid);
			DetailGrid.selectRow(DetailGrid.getRowIndex(uid));
			$erp.setDhtmlXGridFooterRowCount(DetailGrid);
		}
	}
	
	function deleteErpDetailGrid(erpDetailGrid){
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
	
	function onDetailKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpGoodsGrid.setCSVDelimiter("\t");
			erpGoodsGrid.copyBlockToClipboard();
		}
		if(code==86&&ctrl){
			erpGoodsGrid.setCSVDelimiter("\t");
			erpGoodsGrid.pasteBlockFromClipboard();
		}
			
		return true;
	}
	
	function getDetailGoodsList(rId) {
		var BCD_CD = erpGoodsGrid.cells(rId, erpGoodsGrid.getColIndexById("BCD_CD")).getValue();
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/common/popup/getGoodsGrupSelectedList.do"
			,data : {
				"BCD_CD" : erpGoodsGrid.cells(rId, erpGoodsGrid.getColIndexById("BCD_CD")).getValue()
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
								erpGoodsGrid
							,  '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpGoodsGrid.cells(rId, erpGoodsGrid.getColIndexById("GOODS_NO")).setValue(gridDataList[0].GOODS_NO);
						erpGoodsGrid.cells(rId, erpGoodsGrid.getColIndexById("GOODS_NM")).setValue(gridDataList[0].GOODS_NM);
						erpGoodsGrid.cells(rId, erpGoodsGrid.getColIndexById("BCD_CD")).setValue(gridDataList[0].BCD_CD);
						erpGoodsGrid.cells(rId, erpGoodsGrid.getColIndexById("DIMEN_NM")).setValue(gridDataList[0].DIMEN_NM);
						erpGoodsGrid.cells(uid, erpGoodsGrid.getColIndexById("SALE_PRICE")).setValue(gridDataList[0].SALE_PRICE);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		
	}
	
	function saveErpDetailGrid(erpDetailGrid) {
		var selected_grid_nm = erpDetailGrid.divId;
		var all_rows_num = 0;
		var delete_rId_list = [];
		all_rows_num = erpDetailGrid.getRowsNum();
		for(var i = 0 ; i < all_rows_num ; i++){
			if(erpDetailGrid.cells(erpDetailGrid.getRowId(i), erpDetailGrid.getColIndexById("OBJ_NM")).getValue() == ""){
				delete_rId_list.push(erpDetailGrid.getRowId(i));
			}
		}
		for(var j = 0 ; j < delete_rId_list.length ; j++){
			erpDetailGrid.deleteRow(delete_rId_list[j]);
		}
		
		var erpDetailGridDataProcessor = new dataProcessor();
		
		if(erpDetailGrid.divId == "div_erp_custmr_grid") {
			erpDetailGridDataProcessor = erpCustmrGridDataProcessor;
		} else if(erpDetailGrid.divId == "div_erp_goods_grid") {
			erpDetailGridDataProcessor = erpGoodsGridDataProcessor;
		}
		
		
		if(erpDetailGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpDetailGrid);
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
		var paramData = $erp.serializeDhtmlXGridData(erpDetailGrid);
		$.ajax({
			url : "/common/popup/SaveGoodsGroupDetailList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					searchDetailList(GRUP_CD);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function UseGoodsGroup() {
		var selected_row = erpGroupGrid.getCheckedRows(erpGroupGrid.getColIndexById("SELECT"));
		
		if(selected_row == ""){
			$erp.alertMessage({
				"alertMessage" : "그룹을 선택 후 적용가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else{
			if(!$erp.isEmpty(GoodsGroupDetailList) && typeof GoodsGroupDetailList === 'function'){
				GoodsGroupDetailList(erpGroupGrid);
			}
		}
	}
	
	function initDthmlxCombo(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 180, null, true, null, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 120, null, false, null);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), null, false, null);
			}); 
		});
	}
	
	function alertMessage(param){
		$erp.alertMessage(param);
	}
	
</script>
</head>
<body>
	<div id="div_erp_left_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_group_search_codition" class="div_erp_contents_search" style="display:none;">
			<table class="table_search">
				<colgroup>
					<col width="85px">
					<col width="200px">
					<col width="85px">
					<col width="*">
				</colgroup>
				<tr>
					<th>법인구분</th>
					<td>
						<div id="cmbORGN_DIV_CD"></div>
					</td>
					<th>조직명</th>
					<td>
						<div id="cmbORGN_CD"></div>
					</td>
				</tr>
			</table>
			<input type="radio" id="condition_goods" name="condition" value="G" style="margin-left: 18px;" onchange="searchGroupList()" checked>상품그룹
			<input type="radio" id="condition_custmr" name="condition" value="C" onchange="searchGroupList()">거래처그룹
			<br><br>
		</div>
		<div id="div_erp_group_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_group_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	
	<div id="div_erp_right_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_goods_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_detail_grid" class="div_grid_full_size" style="display:none">
			<div id="div_erp_goods_grid" class="div_grid_full_size" style="display:none"></div>
			<div id="div_erp_custmr_grid" class="div_grid_full_size" style="display:none"></div>
		</div>
	</div>
	
</body>
</html>