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
	
	var erpGridDateColumns;
	var erpGridDataProcessor;
	var erpSubGridDateColumns;
	var erpSubGridDataProcessor;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var todayDate = thisYear + "-" + thisMonth
	
	var cmbUSE_YN;
	var cmbORGN_CD;
	var AUTHOR_CD = "${screenDto.author_cd}";
	var Code_List="";
	var crud;
	var paramGridData = {};
	var check;
	
	$(document).ready(function(){
		
		initErpLayout();
		
		initErpMainLayout();
		initErpSubLayout();
		
		initErpRibbon();
		initErpSubRibbon();
		
		initErpGrid();
		initErpSubGrid();
		
		document.getElementById("SEARCH_FROM_DATE").value=todayDate;
		initDhtmlXCombo();
		
		$erp.asyncObjAllOnCreated(function(){
			searchErpGrid();
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "이종상품 관리", header: false , fix_size:[true, true]}
				, {id : "b", text: "상세내역", header: false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_main_layout");
		erpLayout.cells("a").setHeight(350);
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
		erpMainLayout.cells("a").setHeight(38);
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
					, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false} 
					, {id : "add_erpGrid", type : "button", text:'묶음할인 그룹 등록', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid") {
				searchErpGrid();
			} else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
			} else if (itemId == "save_erpGrid"){
				saveErpGrid();
			} else if (itemId == "add_erpGrid"){
				openNewBundleGroupPopup();
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid(){
		erpGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "SELECT", label : ["선택", "#rspan"], type : "ra", width : "35", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}  
			, {id : "BUDL_NM", label:["타이틀", "#rspan"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ORGN_CD", label:["직영점", "#rspan"], type: "combo", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			, {id : "ORGN_DIV_CD", label:["조직구분코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "BUDL_STRT_DATE", label:["시작일", "#rspan"], type: "ro", width: "80", sort : "date", align : "center", isHidden : false, isEssential : true}
			, {id : "BUDL_END_DATE", label:["종료일", "#rspan"], type: "ro", width: "80", sort : "date", align : "center", isHidden : false, isEssential : true}
			, {id : "BUDL_STATE", label:["사용구분", "#rspan" ], type: "combo", width: "65", sort : "str", align : "left", isHidden : false, isEssential : false, commonCode : ["USE_CD" , "YN"]}
			, {id : "CDATE", label:["등록일시", "#rspan"], type: "ro", width: "90", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MDATE", label:["수정일시", "#rspan"], type: "ro", width: "90", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "POINT_SAVE_EX_YN", label:["적립", "#rspan"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["POINT_SAVE_EX_YN"]}
			, {id : "MEMO", label:["메모", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BUDL_QTY", label:["상품개수", "#rspan"], type: "ro", width: "65", sort : "str", align : "right", isHidden : false, isEssential : false}
			, {id : "BUDL_CD", label:["번들코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "BUDL_DC_TYPE", label:["번들할인유형", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "BUDL_APPLY_VALUE", label:["번들적용값", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "BUDL_APPLY_UNIT", label:["번들적용단위", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
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
		erpGrid.setDateFormat("%Y-%m-%d", "%Y-%m-%d");
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
				var BUDL_CD = this.cells(rId, this.getColIndexById("BUDL_CD")).getValue();
				var ORGN_CD = this.cells(rId, this.getColIndexById("ORGN_CD")).getValue();
				
				searchErpSubGrid(BUDL_CD, ORGN_CD);
			}
		});
		
		erpGrid.attachEvent("onRowDblClicked",function(rId,cInd){
			crud = "U";
			openRetouchBundlePopup();
		});
		
		crud = "R";
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 조회 Function --%>
	function searchErpGrid(){
		erpLayout.progressOn();
		paramGridData["SEARCH_FROM_DATE"] = document.getElementById("SEARCH_FROM_DATE").value;
		paramGridData["USE_YN"] = cmbUSE_YN.getSelectedValue();
		paramGridData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		
		$.ajax({
				url: "/sis/market/getDoubleMainList.do"
				, data : paramGridData
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpGrid);
						$erp.clearDhtmlXGrid(erpSubGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpGrid
								,'<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpGrid);
					erpLayout.progressOff();
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpGrid 조회 Function 끝--%>
	
	<%-- ■ saveErpGrid 저장 Function 시작 --%>
	function saveErpGrid() {
		var gridRowCount = erpGrid.getRowsNum();
		var lastRowNum = gridRowCount-1;
		var lastRid = erpGrid.getRowId(lastRowNum);
		var lastRowcheck = erpGrid.cells(lastRid, erpGrid.getColIndexById("BUDL_NM")).getValue();
		if(lastRowcheck == null || lastRowcheck == "null" || lastRowcheck == undefined || lastRowcheck == "undefined" || lastRowcheck == "") {
			erpGrid.deleteRow(lastRid);
		}
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
			$.ajax({
				url : "/sis/market/saveDoubleList.do"
				,data : paramData
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.alertSuccessMesage(onAfterSaveErpGrid);
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	
	<%-- ■ erpGrid 저장 후 Function --%>
	function onAfterSaveErpGrid(){
		searchErpGrid();
	}
	<%-- ■ saveErpGrid 저장 Function 끝--%>
	
	<%-- ■ deleteErpGrid 삭제 Function --%>
	function deleteErpGrid(){
		$erp.confirmMessage({
			"alertMessage" : "해당 그룹의 상품들도 모두 삭제됩니다.<br>진행하시겠습니까?",
			"alertType" : "alert",
			"isAjax" : false,
			"alertCallbackFn" : function confirmAgain(){
		
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
			
			saveErpGrid();
			}
		});
	}
	<%-- ■ deleteErpGrid 저장 Function 끝--%>
	
	<%-- ■ erpSubLayout 관련 Function 시작 --%>
	<%-- erpSubLayout 초기화 Function --%>
	function initErpSubLayout() {
		erpSubLayout = new dhtmlXLayoutObject({
			parent : "div_erp_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "조회조건", header: false , fix_size:[true, true]}
				, {id: "b", text: "리본", header: false , fix_size:[true, true]}
				, {id: "c", text: "그리드", header: false , fix_size:[true, true]}
			]
		});
		erpSubLayout.cells("a").attachObject("div_erp_sub_table");
		erpSubLayout.cells("a").setHeight(35);
		erpSubLayout.cells("b").attachObject("div_erp_sub_ribbon");
		erpSubLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpSubLayout.cells("c").attachObject("div_erp_sub_grid");
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
					{id : "add_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
					, {id : "delete_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					, {id : "save_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false}
				]}
			]
		});
		
		erpSubRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_sub_erpGrid"){
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
					"alertMessage" : "이종상품그룹 선택 후 이용가능합니다."
					, "alertType" : "alert"
					, "isAjax" : false
				});
			}else if (itemId == "delete_sub_erpGrid"){
				deleteErpSubGrid();
			} else if (itemId == "save_sub_erpGrid"){
				saveErpSubGrid();
			}
		});
	}
	<%-- ■ erpSubRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpSubGrid 관련 Function 시작 --%>	
	<%-- erpSubGrid 초기화 Function --%>	
	function initErpSubGrid(){
		erpSubGridColumns = [
			{id : "NO", label:["순번", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "280", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "90", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "PUR_PRICE", label:["정상매입", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "SALE_PRICE", label:["정상판매", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "BUDL_PUR_PRICE", label:["특매매입", "#rspan"], type: "edn", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			, {id : "BUDL_SALE_PRICE", label:["특매판매", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "POINT_SAVE_EX_YN", label:["적립", "#rspan"], type: "combo", width: "50", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["POINT_SAVE_EX_YN"]}
			, {id : "CDATE", label:["상품등록일", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MDATE", label:["상품수정일", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "BUDL_CD", label:["번들코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "ORGN_CD", label:["조직명", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "ORGN_DIV_CD", label:["법인구분", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "BUDL_STRT_DATE", label:["시작일", "#rspan"], type: "ro", width: "75", sort : "date", align : "center", isHidden : true, isEssential : true}
			, {id : "BUDL_END_DATE", label:["종료일", "#rspan"], type: "ro", width: "75", sort : "date", align : "center", isHidden : true, isEssential : true}
			, {id : "BUDL_DC_TYPE", label:["번들할인유형", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "BUDL_APPLY_VALUE", label:["번들적용값", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "BUDL_APPLY_UNIT", label:["번들적용단위", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "BUDL_STATE", label:["사용구분", "#rspan" ], type: "ro", width: "65", sort : "str", align : "left", isHidden : true, isEssential : false}
			
		];
		
		erpSubGrid = new dhtmlXGridObject({
			parent: "div_erp_sub_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpSubGridColumns
		});
		
		$erp.initGridCustomCell(erpSubGrid);
		
		erpSubGridDataProcessor = $erp.initGrid(erpSubGrid, {useAutoAddRowPaste : true, standardColumnId : "BCD_CD", deleteDuplication : true, overrideDuplication : false, editableColumnIdListOfInsertedRows : ["BCD_CD"], notEditableColumnIdListOfInsertedRows : []});
		
		erpSubGrid.attachEvent("onEndPaste", function(result){
			if(check == "1" || check == "BCD_CD"){
				pasteGoods(result);
			}
		});
		
		erpSubGrid.attachEvent("onRowSelect", function(rId, Ind){
			check = erpSubGrid.getColumnId(Ind);
		});
		
		erpSubGrid.attachEvent("onEmptyClick", function(ev){
			check = "1";
		});
		
		
	}
	<%-- ■ erpSubGrid 관련 Function 끝 --%>
	
	<%-- ■ erpSubGrid 조회 Function 시작 --%>
	function searchErpSubGrid(BUDL_CD, ORGN_CD){
		var selectedRowId = erpGrid.getCheckedRows(erpGrid.getColIndexById("SELECT"));
		var BUDL_NM = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("BUDL_NM")).getValue();
		var BUDL_APPLY_UNIT = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("BUDL_APPLY_UNIT")).getValue();
		var BUDL_APPLY_VALUE = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("BUDL_APPLY_VALUE")).getValue();
		
		document.getElementById("txtBUDL_APPLY_VALUE").value = BUDL_APPLY_VALUE;
		document.getElementById("txtBUDL_APPLY_UNIT").value = BUDL_APPLY_UNIT;
		document.getElementById("txtBUDL_NM").value = BUDL_NM;
		
		var paramData = {};
		paramData["BUDL_CD"] = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("BUDL_CD")).getValue();
		paramData["ORGN_CD"] = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_CD")).getValue();
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/market/getDoubleSubList.do"
			,data : paramData
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
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpSubGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		
	}
	<%-- ■ erpSubGrid 조회 Function 끝 --%>
	
	<%-- ■ saveErpSubGrid 저장 Function 시작 --%>
	function saveErpSubGrid() {
		var gridRowCount = erpSubGrid.getRowsNum();
		var lastRowNum = gridRowCount-1;
		var lastRid = erpSubGrid.getRowId(lastRowNum);
		var lastRowcheck = erpSubGrid.cells(lastRid, erpSubGrid.getColIndexById("BCD_NM")).getValue();
		if(lastRowcheck == null || lastRowcheck == "null" || lastRowcheck == undefined || lastRowcheck == "undefined" || lastRowcheck == "") {
			erpSubGrid.deleteRow(lastRid);
		}
		
		if(erpSubGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		erpLayout.progressOn();
		var checkList="";
		var gridCount = erpSubGrid.getRowsNum();
		for(var i = 0 ;   i < gridCount ; i++){
			var rid = erpSubGrid.getRowId(i);
			var rowCheck = erpSubGrid.cells(rid, erpSubGrid.getColIndexById("BUDL_SALE_PRICE")).getValue();
			checkList += rowCheck;
		}
		
		if(checkList.indexOf("-") != -1){
			$erp.alertMessage({
				"alertMessage" : "특매판매가에 <span style='color:red; font-weight:bold;'>0원 이하의 상품</span>이 존재합니다.<br>확인바랍니다."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false,
				"alertCallbackFn" : function confirmAgain(){
					var paramData = $erp.serializeDhtmlXGridData(erpSubGrid);
					$.ajax({
						url : "/sis/market/saveDoubleSubList.do"
						,data : paramData
						,method : "POST"
						,dataType : "JSON"
						,success : function(data) {
							erpLayout.progressOff();
							if(data.isError){
								$erp.ajaxErrorMessage(data);
							}else {
								$erp.alertSuccessMesage(onAfterSaveErpSubGrid);
							}
						}, error : function(jqXHR, textStatus, errorThrown){
							erpLayout.progressOff();
							$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
						}
					});
				}
			});
		}else{
			var paramData = $erp.serializeDhtmlXGridData(erpSubGrid);
			$.ajax({
				url : "/sis/market/saveDoubleSubList.do"
				,data : paramData
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.alertSuccessMesage(onAfterSaveErpSubGrid);
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	
	}
	
	<%-- ■ erpSubGrid 저장 후 Function --%>
	function onAfterSaveErpSubGrid(){
		searchErpSubGrid();
	}
	<%-- ■ saveErpGrid 저장 Function 끝--%>

	<%-- ■ deleteErpSubGrid 삭제 Function 시작--%>
	function deleteErpSubGrid(){
		var gridRowCount = erpSubGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
			
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
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}
			
		for(var j = 0; j < deleteRowIdArray.length; j++){
			erpSubGrid.deleteRow(deleteRowIdArray[j]);
		}
			
		$erp.setDhtmlXGridFooterRowCount(erpSubGrid);
	}
	<%-- ■ deleteErpSubGrid 삭제 Function 끝--%>
	
	<%-- 상품 붙여넣기 function --%>
	function pasteGoods(result){
		var selectedRowId = erpGrid.getCheckedRows(erpGrid.getColIndexById("SELECT"));
		var ORGN_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_CD")).getValue();
		var ORGN_DIV_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_DIV_CD")).getValue();
		var BUDL_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("BUDL_CD")).getValue();
		var POINT_SAVE_EX_YN = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("POINT_SAVE_EX_YN")).getValue();
		var BUDL_STRT_DATE = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("BUDL_STRT_DATE")).getValue();
		var BUDL_END_DATE = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("BUDL_END_DATE")).getValue();
		var BUDL_STATE = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("BUDL_STATE")).getValue();
		var BUDL_DC_TYPE = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("BUDL_DC_TYPE")).getValue();
		var BUDL_APPLY_VALUE = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("BUDL_APPLY_VALUE")).getValue();
		var BUDL_APPLY_UNIT = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("BUDL_APPLY_UNIT")).getValue();
		
		var loadGoodsList = [];
		var data;
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];
			loadGoodsList.push(data["BCD_CD"]);
		}
		var url = "/sis/market/getBargainGoodsInfo.do";
		var send_data = {"loadGoodsList" : loadGoodsList};
		
		var if_success = function(data){
			var gridDataList = data.gridDataList;
			
			for(var index in gridDataList){
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("BCD_NM")).setValue(gridDataList[index]["BCD_NM"]);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("DIMEN_NM")).setValue(gridDataList[index]["DIMEN_NM"]);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("SALE_PRICE")).setValue(gridDataList[index]["SALE_PRICE"]);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("PUR_PRICE")).setValue(gridDataList[index]["PUR_PRICE"]);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("ORGN_CD")).setValue(ORGN_CD);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("ORGN_DIV_CD")).setValue(ORGN_DIV_CD);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("BUDL_STATE")).setValue(BUDL_STATE);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("BUDL_CD")).setValue(BUDL_CD);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("POINT_SAVE_EX_YN")).setValue(POINT_SAVE_EX_YN);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("BUDL_STRT_DATE")).setValue(BUDL_STRT_DATE);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("BUDL_END_DATE")).setValue(BUDL_END_DATE);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("BUDL_CD")).setValue(BUDL_CD);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("BUDL_DC_TYPE")).setValue(BUDL_DC_TYPE);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("BUDL_APPLY_VALUE")).setValue(BUDL_APPLY_VALUE);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("BUDL_APPLY_UNIT")).setValue(BUDL_APPLY_UNIT);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("BUDL_PUR_PRICE")).setValue(gridDataList[index]["PUR_PRICE"]);
				result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]].push("로드완료");
			}
			
			var notExistList = [];
			var value;
			var state;
			var dp = erpSubGrid.getDataProcessor();
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["BCD_CD"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			$erp.deleteGridRows(erpSubGrid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>[무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			if(erpSubGrid.getRowsNum() == 0){
				erpSubGrid.callEvent("onClick",["searchErpSubGrid"]);
				return;
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpSubGrid); // 현재 행수 계산
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
	}
	
	<%-- ■ onKeyPressed 이종상품그룹 목록Grid_Keypressed Function 시작 --%>
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
	<%-- ■ onKeyPressed 이종상품그룹 목록Grid_Keypressed Function 끝--%>
	
	<%-- dhtmlxCombo 초기화 Function 시작--%>
	function initDhtmlXCombo(){
		cmbUSE_YN = $erp.getDhtmlXComboCommonCode('cmbUSE_YN', 'USE_CD',['USE_CD', 'YN'], 100, "전체", false);
		
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",");
		var searchable = 1;
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
				searchable = 2;
			}
		}
		
		if(searchable == 2 ){
			cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK"], 100, "모두조회", false, LUI.LUI_orgn_cd);
		}else {
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 90, null, false, LUI.LUI_orgn_cd);
		}
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
	
	<%-- openNewBundleGroupPopup 묶음할인 그룹 등록 팝업 열림 Function --%>
	function openNewBundleGroupPopup(){
		var onClickAddData = function(BUDL_STRT_DATE, BUDL_END_DATE, BUDL_NM, MEMO, BUDL_APPLY_UNIT, BUDL_APPLY_VALUE, POINT_SAVE_EX_YN,BUDL_DC_TYPE,ORGN_CD,BUDL_STATE,BUDL_APPLY_VALUE,BUDL_APPLY_UNIT){
			var isValidated = true;
			var alertMessage = "";
			var alertCode = "";
			var alertType = "error";
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					, "alertCode" : alertCode
					, "alertType" : alertType
				});
			}else{
				var uid =0;
				var uid = erpGrid.uid();
				erpGrid.addRow(uid);
				
				erpGrid.cells(uid, erpGrid.getColIndexById("BUDL_NM")).setValue(BUDL_NM);
				erpGrid.cells(uid, erpGrid.getColIndexById("ORGN_CD")).setValue(ORGN_CD);
				erpGrid.cells(uid, erpGrid.getColIndexById("BUDL_STRT_DATE")).setValue(BUDL_STRT_DATE);
				erpGrid.cells(uid, erpGrid.getColIndexById("BUDL_END_DATE")).setValue(BUDL_END_DATE);
				erpGrid.cells(uid, erpGrid.getColIndexById("POINT_SAVE_EX_YN")).setValue(POINT_SAVE_EX_YN);
				erpGrid.cells(uid, erpGrid.getColIndexById("MEMO")).setValue(MEMO);
				erpGrid.cells(uid, erpGrid.getColIndexById("BUDL_QTY")).setValue(0);
				erpGrid.cells(uid, erpGrid.getColIndexById("BUDL_STATE")).setValue(BUDL_STATE);
				erpGrid.cells(uid, erpGrid.getColIndexById("BUDL_DC_TYPE")).setValue(BUDL_DC_TYPE);
				erpGrid.cells(uid, erpGrid.getColIndexById("BUDL_APPLY_VALUE")).setValue(BUDL_APPLY_VALUE);
				erpGrid.cells(uid, erpGrid.getColIndexById("BUDL_APPLY_UNIT")).setValue(BUDL_APPLY_UNIT);
				erpGrid.cells(uid, erpGrid.getColIndexById("BUDL_APPLY_UNIT")).setValue(BUDL_APPLY_UNIT);
				
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
				
				$erp.closePopup2("openNewBundleGroupPopup");
				saveErpGrid();
			}
		}
		$erp.openNewBundleGroupPopup(onClickAddData);
	}
	
	<%-- openRetouchBundlePopup 묶음할인 그룹 수정 팝업 열림 Function --%>
	function openRetouchBundlePopup(){
		var selectedRow = erpGrid.getSelectedRowId();
		var paramMap = new Object();
		
		paramMap.BUDL_NM = erpGrid.cells(selectedRow,erpGrid.getColIndexById("BUDL_NM")).getValue();
		paramMap.ORGN_CD = erpGrid.cells(selectedRow,erpGrid.getColIndexById("ORGN_CD")).getValue();
		paramMap.BUDL_STRT_DATE = erpGrid.cells(selectedRow,erpGrid.getColIndexById("BUDL_STRT_DATE")).getValue();
		paramMap.BUDL_END_DATE = erpGrid.cells(selectedRow,erpGrid.getColIndexById("BUDL_END_DATE")).getValue();
		paramMap.BUDL_STATE = erpGrid.cells(selectedRow,erpGrid.getColIndexById("BUDL_STATE")).getValue();
		paramMap.BUDL_APPLY_VALUE = erpGrid.cells(selectedRow,erpGrid.getColIndexById("BUDL_APPLY_VALUE")).getValue();
		paramMap.BUDL_APPLY_UNIT = erpGrid.cells(selectedRow,erpGrid.getColIndexById("BUDL_APPLY_UNIT")).getValue();
		paramMap.MEMO = erpGrid.cells(selectedRow,erpGrid.getColIndexById("MEMO")).getValue();
		paramMap.BUDL_DC_TYPE = erpGrid.cells(selectedRow,erpGrid.getColIndexById("BUDL_DC_TYPE")).getValue();
		paramMap.POINT_SAVE_EX_YN = erpGrid.cells(selectedRow,erpGrid.getColIndexById("POINT_SAVE_EX_YN")).getValue();
		paramMap.BUDL_CD = erpGrid.cells(selectedRow,erpGrid.getColIndexById("BUDL_CD")).getValue();
		
		$erp.openRetouchBundlePopup({"doubleInfo" : JSON.stringify(paramMap)});
	}
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(){
		var selectedRowId = erpGrid.getCheckedRows(erpGrid.getColIndexById("SELECT"));
		var ORGN_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_CD")).getValue();
		var ORGN_DIV_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_DIV_CD")).getValue();
		var BUDL_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("BUDL_CD")).getValue();
		var onClickRibbonAddData = function(popupGrid){
			//dataState : checked,selected  //copyType : add,new
			var popup = erpPopupWindows.window("openSearchGoodsGridPopup");
			popup.progressOn();
			$erp.copyRowsGridToGrid(popupGrid, erpSubGrid, ["BCD_CD","GOODS_NM"], ["BCD_CD","BCD_NM"], "checked", "add", ["BCD_CD"], [], {}, {}, function(result){
				popup.progressOff();
				popup.close();
				
				pasteGoods(result);
			},false);
		}
		$erp.openSearchGoodsPopup(null,onClickRibbonAddData,{"ORGN_CD" : ORGN_CD  ,"ORGN_DIV_CD" : ORGN_DIV_CD});
	}
</script>
</head>
<body>
	<div id="div_erp_main_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_main_table" class="samyang_div" style="display:none">
			<table id = "tb_search_01" class = "table_search">
				<colgroup>
					<col width="60px"/>
					<col width="110px"/>
					<col width="60px"/>
					<col width="110px"/>
					<col width="80px"/>
					<col width="110px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th>기간</th>
					<td>
						<input type="text" id="SEARCH_FROM_DATE" name="SEARCH_FROM_DATE" class="input_calendar_ym default_date" style="margin-left: 10px;" >
					</td>
					<th>조직명</th>
					<td>
						<div id="cmbORGN_CD"></div>
					</td>
					<th>사용구분</th>
					<td>
						<div id="cmbUSE_YN"></div>
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_main_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_main_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	<div id="div_erp_sub_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_sub_table" class="samyang_div" style="display:none">
			<table id = "tb_search_02" class = "table_search">
				<colgroup>
					<col width="60px"/>
					<col width="160px"/>
					<col width="20px"/>
					<col width="37px"/>
					<col width="115px"/>
					<col width="110px"/>
					<col width="35px"/>
					<col width="*px"/>
				</colgroup>
				<tr>
					<th>그룹</th>
					<td>
						<input type="text" id="txtBUDL_NM" name="txtCLSE_CD" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 150px;">
					</td>
					<th></th>
					<td>
						<input type="text" id="txtBUDL_APPLY_UNIT" name="txtBUDL_APPLY_UNIT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 30px; text-align:right;">
					</td>
					<th>개  이상 판매시 할인</th>
					<td>
						<input type="text" id="txtBUDL_APPLY_VALUE" name="txtBUDL_APPLY_VALUE" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width:100px; text-align:right;">
					</td>
					<th>원/%</th>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;&#60;상품바코드를 화면에 복사&붙여넣기 하여 상품을 추가할 수 있습니다.&#62;
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_sub_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_sub_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>