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
	
	var erpLayout;
	var erpLeftLayout;
	var erpRightLayout;
	
	var erpGroupRibbon;
	var erpGoodsRibbon;
	var erpGroupGrid;
	var erpGrid;
	var erpGroupGridColumns;
	var erpGridColumns;
	var erpGroupGridDataProcessor;
	var erpGridDataProcessor;
	
	var cmbCUSTMR_GRUP;
	
	$(document).ready(function(){
		initErpLayout();
		initErpLeftLayout();
		initErpRightLayout();
		
		initGroupRibbon();
		initGoodsRibbon();
		
		initErpGroupGrid();
		initErpGoodsGrid();
		initDhtmlXCombo();
		
		$erp.asyncObjAllOnCreated(function(){
			LUI.exclude_auth_cd = "ALL,1,5,6";
			searchGroupList();
		});
	});

	
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2U"
			, cells : [
				{id: "a", text : "고객사구매가능상품관리", header : true}
				, {id: "b", text : "상품목록", header : true, fix_size:[true, true]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_left_layout");
		erpLayout.cells("a").setWidth(600);
		erpLayout.cells("b").attachObject("div_erp_right_layout");
		
		erpLayout.setSeparatorSize(1,0);
		
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpLeftLayout.setSizes();
			erpRigthLayout.setSizes();
		});
	}
	
	function initErpLeftLayout(){
		erpLeftLayout = new dhtmlXLayoutObject({
			parent : "div_erp_left_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "거래처그룹조건영역", header : false, fix_size:[true, true]}
				, {id: "b", text: "거래처그룹리본영역", header : false, fix_size:[true, true]}
				, {id: "c", text: "거래처그룹그리드영역", header : false, fix_size:[true, true]}
			]
		});
		
		erpLeftLayout.cells("a").attachObject("div_erp_group_search");
		erpLeftLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftLayout.cells("b").attachObject("div_erp_group_ribbon");
		erpLeftLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftLayout.cells("c").attachObject("div_erp_group_grid");
		
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpLeftLayout.setSizes();
			erpGroupGrid.setSizes();
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
// 					, {id : "delete_group_Grid", type : "button", text:'삭제', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
				]}
			]
		});
		
		erpGroupRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erp_group_Grid"){
				searchGroupList();
			} else if(itemId == "delete_group_Grid"){
				deleteErpGroupGrid();
			} 
		});
		
	}
	
	function initErpRightLayout(){
		erpRigthLayout = new dhtmlXLayoutObject({
			parent : "div_erp_right_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "상품목록리본영역", header: false}
				, {id: "b", text: "그리드영역", header: false, fix_size:[true, true]}
			]
		});
		
		erpRigthLayout.cells("a").attachObject("div_erp_goods_ribbon");
		erpRigthLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRigthLayout.cells("b").attachObject("div_erp_goods_grid");
		
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpRigthLayout.setSizes();
			erpGrid.setSizes();
		});
	}
	
	function initGoodsRibbon() {
		erpGoodsRibbon = new dhtmlXRibbon({
			parent : "div_erp_goods_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : "rows", list : [
					{id : "add_erp_goods_Grid", type : "button", text:'추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "save_erp_goods_Grid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}
			]
		});
		
		erpGoodsRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "add_erp_goods_Grid") {
				openSearchGoodsGridPopup();
			} else if(itemId == "save_erp_goods_Grid"){
				saveErpGoodsGrid();
			}
		});
	}
	
	function initErpGroupGrid() {
		erpGroupGridColumns = [
		{id: "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
		, {id : "CUSTMR_CD", label:["거래처코드"], type: "combo", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
		, {id : "CUSTMR_NM", label:["거래처명"], type: "combo", width: "250", sort : "str", align : "left", isHidden : false, isEssential : false}
		, {id : "SUPR_TYPE", label:["거래처유형"], type: "combo", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
		, {id : "RESP_USER_NM", label:["영업담당자"], type: "ro", width: "130", sort : "int", align : "left", isHidden : false, isEssential : false}
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
		
		erpGroupGrid.attachEvent("onRowDblClicked", function(rId){
			var CUSTMR_CD = erpGroupGrid.cells(rId, erpGroupGrid.getColIndexById("CUSTMR_CD")).getValue();
			searchGoodsList(CUSTMR_CD);
		});
	}
	
	function initErpGoodsGrid() {
		erpGridColumns = [
			{id: "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_NM", label:["상품명"], type: "ro", width: "350", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "USE_YN", label:["사용여부"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["USE_CD","YN"]}
			];
			
			erpGrid = new dhtmlXGridObject({
				parent : "div_erp_goods_grid"
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : erpGridColumns
			});
			
			$erp.initGridCustomCell(erpGrid);
			
			erpGridDataProcessor = $erp.initGrid(erpGrid, {useAutoAddRowPaste : true, standardColumnId : "BCD_CD", deleteDuplication : true, overrideDuplication : false, editableColumnIdListOfInsertedRows : ["BCD_CD"], notEditableColumnIdListOfInsertedRows : []});
			erpGrid.attachEvent("onEndPaste", function(result){
				pasteGoods(result);
			});
	}
	
	<%-- 상품 붙여넣기 function --%>
	function pasteGoods(result){
		var pasteGoodsList = [];
		var data;
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];
			pasteGoodsList.push(data["BCD_CD"]);
		}
		var url = "/sis/market/getBargainGoodsInfo.do";
		var send_data = {"loadGoodsList" : pasteGoodsList};
		
		var if_success = function(data){
			var gridDataList = data.gridDataList;
			
			for(var index in gridDataList){
				erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGrid.getColIndexById("BCD_NM")).setValue(gridDataList[index]["BCD_NM"]);
				erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGrid.getColIndexById("USE_YN")).setValue("Y");
				result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]].push("로드완료");
			}	
			
			var notExistList = [];
			var value;
			var state;
			var dp = erpGrid.getDataProcessor();
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["BCD_CD"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			$erp.deleteGridRows(erpGrid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>[무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			if(erpGrid.getRowsNum() == 0){
				erpGrid.callEvent("onClick",["searchGoodsList"]);
				return;
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpGrid); // 현재 행수 계산
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpRightLayout);
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
	
	function searchGroupList(){
		paramGridData ={};
		paramGridData["CUSTMR_GRUP"] = cmbCUSTMR_GRUP.getSelectedValue();
		paramGridData["KEY_WORD"] = $("#txtKEY_WORD").val();
		erpLeftLayout.progressOn();
		$.ajax({
			url : "/sis/basic/getCustmrGoodsSearch.do"
			,data : paramGridData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLeftLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGroupGrid);
					$erp.clearDhtmlXGrid(erpGrid);
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
	
	function searchGoodsList(CUSTMR_CD) {
		paramGridData={};
		paramGridData["CUSTMR_CD"] = CUSTMR_CD;
		erpRigthLayout.progressOn();
		$.ajax({
			url : "/sis/basic/getCustmrGoodsDetailSearch.do"
			,data : paramGridData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRigthLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGrid);
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
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function onDetailKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpGrid.setCSVDelimiter("\t");
			erpGrid.copyBlockToClipboard();
		}
		if(code==86&&ctrl){
			erpGrid.setCSVDelimiter("\t");
			erpGrid.pasteBlockFromClipboard();
		}
			
		return true;
	}
	
	function saveErpGoodsGrid() {
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
		
		erpLayout.progressOn();
	
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);
		var rId = erpGroupGrid.getSelectedRowId();
		paramData['CUSTMR_CD'] = erpGroupGrid.cells(rId, erpGroupGrid.getColIndexById("CUSTMR_CD")).getValue();
		$.ajax({
			url : "/sis/basic/saveCustmrGoodsSearch.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertMessage({
						"alertMessage" : "저장이 완료되었습니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
					
					var rId = erpGroupGrid.getSelectedRowId();
					var CUSTMR_CD = erpGroupGrid.cells(rId, erpGroupGrid.getColIndexById("CUSTMR_CD")).getValue();
					
					searchGoodsList(CUSTMR_CD);
					$erp.setDhtmlXGridFooterRowCount(erpGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function initDhtmlXCombo(){
		cmbCUSTMR_GRUP = $erp.getDhtmlXComboCommonCode("cmbCUSTMR_GRUP", "cmbCUSTMR_GRUP", ["CUSTMR_GRUP","","S"], 100, "모두조회", false);
	}
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(){
		var onClickRibbonAddData = function(popupGrid){
			//dataState : checked,selected  //copyType : add,new
			var popup = erpPopupWindows.window("openSearchGoodsGridPopup");
			popup.progressOn();
			$erp.copyRowsGridToGrid(popupGrid, erpGrid, ["BCD_CD","GOODS_NM"], ["BCD_CD","BCD_NM"], "checked", "add", ["BCD_CD"], [], {}, {"USE_YN" : "Y"}, function(result){
				popup.progressOff();
				popup.close();
			},false);
		}
		$erp.openSearchGoodsPopup(null,onClickRibbonAddData,{"ORGN_DIV_CD" : "B01"});
	}
</script>
</head>
<body>
	<div id="div_erp_left_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_group_search" class="div_erp_contents_search" style="display:none;">
			<table class="table_search">
				<colgroup>
					<col width="65px">
					<col width="150px">
					<col width="85px">
					<col width="*">
				</colgroup>
				<tr>
					<th>검색어</th>
					<td>
						<input type="text" id="txtKEY_WORD" name="txtKEY_WORD" class="input_common" maxlength="100"/>
					</td>
					<th>거래처유형</th>
					<td><div id="cmbCUSTMR_GRUP"></div></td>
				</tr>
			</table>
		</div>
	</div>
	<div id="div_erp_group_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_group_grid" class="div_grid_full_size" style="display:none"></div>
	
	<div id="div_erp_right_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_goods_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_goods_grid" class="div_grid_full_size" style="display:none"></div>
	
</body>
</html>