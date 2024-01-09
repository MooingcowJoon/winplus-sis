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
	var cmbORGN_CD;
	var check;
	
	var All_checkList = "";
	var Code_List = "";
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var todayDate = thisYear + "-" + thisMonth 
	
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
				{id: "a", text: "특매그룹 관리", header: false , fix_size:[true, true]}
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
		
		document.getElementById("EVENT_TYPE").innerHTML = '<input type="radio" id="Search_Condition" name="Search_Condition" value="all" checked="true">전체<input type="radio" id="Search_Condition" name="Search_Condition" value="general">일반 특매그룹<input type="radio" id="Search_Condition" name="Search_Condition" value="bargain">우선 특매그룹';
	}	
	<%-- ■ erpMainLayout 관련 Function 끝 --%>
	
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
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	function initErpRibbon() {
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_main_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "add_erpGrid", type : "button", text:'새 특매그룹 추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
					, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false} 
					, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					, {id : "excelForm_erpGrid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					, {id : "excel_grid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, isHidden : true}				
				]}
			]
		});	
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "add_erpGrid") {
				openAddNewBargainGroupPopup();
			}else if(itemId == "search_erpGrid") {
				searchErpGrid();
			} else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
			} else if (itemId == "save_erpGrid"){
				saveErpGrid();
			} else if(itemId == "excel_erpGrid") {
				$erp.exportGridToExcel({
					"grid" : erpGrid
					, "fileName" : "특매관리그룹"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			} else if(itemId == "excelForm_erpGrid") {
				$erp.exportGridToExcel({
					"grid" : erpGrid
					, "fileName" : "특매관리그룹양식"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : true
				});
			} else if(itemId == "excel_grid_upload") {
				var convertModuleUrl = ""; //엑셀로 컨버트 하는 모듈을 다른것을 사용하고자 할때만 사용
				var uploadFileLimitCount = 1; //파일 업로드 개수 제한
				var onUploadFile = function(files, uploadData, toGrid){
					$erp.uploadDataParse(this, files, uploadData, toGrid, "EVENT_CD", "add", [], ["EVENT_CD"]);
				};
				var onUploadComplete = function(uploadedFileInfoList, toGrid, result){
					saveErpGrid();
				};
				var onBeforeFileAdd = function(file){};
				var onBeforeClear = function(){};
				$erp.excelUploadPopup(erpGrid, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			}
		});
	}
	
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
					, {id : "excel_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					, {id : "excelForm_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					, {id : "excel_subgrid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, isHidden : true}				
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
					"alertMessage" : "특매그룹을 선택 후 이용가능합니다."
					, "alertType" : "alert"
					, "isAjax" : false
				});
			}else if (itemId == "delete_sub_erpGrid"){
				deleteErpSubGrid();
			}else if (itemId == "save_sub_erpGrid"){
				saveErpSubGrid();
			}else if(itemId == "excel_sub_erpGrid") {
				$erp.exportGridToExcel({
					"grid" : erpSubGrid
					, "fileName" : "특매관리상품"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			}else if(itemId == "excelForm_sub_erpGrid") {
				$erp.exportGridToExcel({
					"grid" : erpSubGrid
					, "fileName" : "특매관리상품양식"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : true
				});
			} else if(itemId == "excel_subgrid_upload") {
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
				$erp.excelUploadPopup(erpSubGrid, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid(){
		erpGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false} 	
			, {id : "SELECT", label : ["선택", "#rspan"], type : "ra", width : "35", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}  
			, {id : "EVENT_NM", label:["타이틀", "#rspan"], type: "ed", width: "250", sort : "str", align : "left", isHidden : false, isEssential : true, isSelectAll: true, maxLength : 100}
			, {id : "ORGN_CD", label : ["직영점", "#rspan"], type : "combo", width : "70", sort : "str", align : "left", isHidden : false, isEssential : true, commonCode : ["ORGN_CD" , "MK"]}
			, {id : "EVENT_STRT_DATE", label:["시작일", "#rspan"], type: "edn", width: "80", sort : "date", align : "center", isHidden : false, isEssential : true, isSelectAll: true, maxLength : 10}
			, {id : "EVENT_END_DATE", label:["종료일", "#rspan"], type: "edn", width: "80", sort : "date", align : "center", isHidden : false, isEssential : true, isSelectAll: true, maxLength : 10}
			, {id : "USE_YN", label:["사용구분", "#rspan" ], type: "combo", width: "70", sort : "str", align : "left", isHidden : false, isEssential : true, commonCode : ["USE_CD" , "YN"]}
			, {id : "CDATE", label:["등록일시", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "GOODS_CNT", label:["상품개수", "#rspan"], type: "ro", width: "60", sort : "str", align : "right", isHidden : false, isEssential : false}
			, {id : "MDATE", label:["수정일시", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "ORGN_DIV_CD", label:["조직구분코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "EVENT_CD", label:["특매코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "EVENT_TYPE", label:["특매구분", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["PRIORITY_EVENT_YN"]}
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
		erpGrid.enableColumnMove(true);
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
			var EVENT_CD = this.cells(rId, this.getColIndexById("EVENT_CD")).getValue();
			var ORGN_CD = this.cells(rId, this.getColIndexById("ORGN_CD")).getValue();
			var ORGN_DIV_CD = this.cells(rId, this.getColIndexById("ORGN_DIV_CD")).getValue();
			
			searchErpSubGrid(EVENT_CD, ORGN_CD, ORGN_DIV_CD);
			}
		});
	}
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		erpMainLayout.progressOn();
		var paramData = {};
		paramData["SEARCH_FROM_DATE"] = document.getElementById("SEARCH_FROM_DATE").value;
		paramData["SEARCH_TYPE"] = $('input[name=Search_Condition]:checked').val();
		paramData["USE_YN"] = cmbUSE_YN.getSelectedValue();
		paramData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		paramData["EVENT_GOODS_STATE"] = $('input[name=Invalid_Condition]:checked').length;
		$.ajax({
				url: "/sis/market/getBargainManagementList.do"
				, data : paramData
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpMainLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpGrid);
						$erp.clearDhtmlXGrid(erpSubGrid);
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
					erpMainLayout.progressOff();
				}, error : function(jqXHR, textStatus, errorThrown){
					erpMainLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- erpGrid 조회 Function 끝--%>
	
	<%-- saveErpGrid 저장 Function --%>
	function saveErpGrid() {
		var gridRowCount = erpGrid.getRowsNum();
		var lastRowNum = gridRowCount-1;
		var lastRid = erpGrid.getRowId(lastRowNum);
		var lastRowcheck = erpGrid.cells(lastRid, erpGrid.getColIndexById("EVENT_NM")).getValue();
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
		
		erpMainLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);
		$.ajax({
			url : "/sis/market/saveBargainManagementList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpMainLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertSuccessMesage(onAfterSaveErpGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpMainLayout.progressOff();
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
	
	<%-- erpGrid 추가 Function 끝 --%>
	
	<%-- ■ erpDetailGrid 관련 Function 시작 --%>
	<%-- erpDetailGrid 초기화 Function --%>
	function initErpSubGrid(){
		erpSubGridColumns = [
			{id : "NO", label:["순번", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "280", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "90", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ed", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true, isSelectAll: true, maxLength : 20}
			, {id : "PUR_PRICE", label:["정상매입", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "SALE_PRICE", label:["정상판매", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "EVENT_PUR_PRICE", label:["특매매입", "#rspan"], type: "edn", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000", isSelectAll: true, maxLength : 10}
			, {id : "EVENT_GOODS_PRICE", label:["특매판매", "#rspan"], type: "edn", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000", isSelectAll: true, maxLength : 10}
			, {id : "EVENT_GOODS_DC_QTY", label:["단위", "#rspan"], type: "edn", width: "60", sort : "str", align : "center", isHidden : false, isEssential : true, isSelectAll: true, maxLength : 10}
			, {id : "EVENT_GOODS_DC_TYPE", label:["할인유형", "#rspan" ], type: "combo", width: "70", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["EVENT_GOODS_DC_TYPE"]}
			, {id : "DC_PRICE", label:["할인", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false , numberFormat : "0,000"}
			, {id : "DC_RATE", label:["할인율", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "00.00%"}
			, {id : "POINT_SAVE_EX_YN", label:["포인트적립", "#rspan"], type: "combo", width: "65", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["USE_CD" , "YN"]}
			, {id : "EVENT_GOODS_FEE_AMT", label:["수수료", "#rspan"], type: "ro", width: "60", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "ONE_TIME_LIMIT_QTY", label:["1회제한", "#rspan"], type: "edn", width: "60", sort : "str", align : "center", isHidden : false, isEssential : true, isSelectAll: true, maxLength : 10}
			, {id : "EVENT_LIMIT_QTY", label:["전체한정", "#rspan"], type: "edn", width: "60", sort : "str", align : "center", isHidden : false, isEssential : true, isSelectAll: true, maxLength : 10}
			, {id : "EVENT_APPLY_HH_FROM", label:["시작시간", "#rspan"], type: "edn", width: "60", sort : "str", align : "center", isHidden : false, isEssential : true, isSelectAll: true, maxLength : 2}
			, {id : "EVENT_APPLY_HH_TO", label:["종료시간", "#rspan"], type: "edn", width: "60", sort : "str", align : "center", isHidden : false, isEssential : true, isSelectAll: true, maxLength : 2}
			, {id : "EVENT_GOODS_STATE", label:["상품상태", "#rspan"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isEssential :true, commonCode : ["USE_CD" , "YN"]}
			, {id : "EVENT_CD", label:["특매코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "ORGN_CD", label:["조직명", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false, commonCode : ["ORGN_CD" , "MK"]}
			, {id : "ORGN_DIV_CD", label:["법인구분", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "EVENT_STRT_DATE", label:["시작일", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "EVENT_END_DATE", label:["종료일", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "EVENT_PUR_PRICE_APPLY_FROM", label:["특매매입적용기간FROM", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "EVENT_PUR_PRICE_APPLY_TO", label:["특매매입적용기간TO", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "EVENT_GOODS_SALE_QTY", label:["특매상품판매수", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "GOODS_TOT_DC_AMT", label:["상품총할인금액", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "EVENT_GOODS_SEQ", label:["특매상품순번", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "EVENT_GOODS_RANK", label:["특매상품순위", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
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
		
		erpSubGrid.attachEvent("onCellChanged", function (rowId,columnIdx,newValue){
			var warning_pr_rowId_obj = {};
			if(erpSubGrid.getColumnId(columnIdx) == "EVENT_GOODS_PRICE"){
				let sp; 				//정상판매
				let ep; 				//특매판매
				let change_ep;			//할인율
				let change_ep_price;	//할인
				
				sp = erpSubGrid.cells(rowId, erpSubGrid.getColIndexById("SALE_PRICE")).getValue();
				ep = erpSubGrid.cells(rowId, erpSubGrid.getColIndexById("EVENT_GOODS_PRICE")).getValue();
				
				sp = parseInt(sp);
				ep = parseInt(ep);
				
				change_ep_price = sp-ep;
				change_ep = ((sp-ep)/sp) * 100;
				
				erpSubGrid.cells(rowId, erpSubGrid.getColIndexById("DC_PRICE")).setValue(change_ep_price);
				erpSubGrid.cells(rowId, erpSubGrid.getColIndexById("DC_RATE")).setValue(change_ep);
				
				setTimeout(function(){
					erpSubGrid.cells(rowId, erpSubGrid.getColIndexById("DC_PRICE")).setValue(change_ep_price);
					erpSubGrid.cells(rowId, erpSubGrid.getColIndexById("DC_RATE")).setValue(change_ep);
					
					if(change_ep < 0){
						erpSubGrid.cells(rowId, erpSubGrid.getColIndexById("EVENT_GOODS_PRICE")).setBgColor('#F6CED8');
						erpSubGrid.cells(rowId, erpSubGrid.getColIndexById("DC_RATE")).setBgColor('#F6CED8');
						warning_pr_rowId_obj[rowId] = rowId;
					}
				},50);
			}	
		});
	}
	<%-- ■ erpDetailGrid 관련 Function 끝 --%>
	
	<%-- 상품 엑셀업로드 function --%>
	function loadGoods(result){
		var selectedRowId = erpGrid.getCheckedRows(erpGrid.getColIndexById("SELECT"));
		var ORGN_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_CD")).getValue();
		var ORGN_DIV_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_DIV_CD")).getValue();
		var EVENT_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("EVENT_CD")).getValue();
		var EVENT_STRT_DATE = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("EVENT_STRT_DATE")).getValue();
		var EVENT_END_DATE = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("EVENT_END_DATE")).getValue();
		
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
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_CD")).setValue(EVENT_CD);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_STRT_DATE")).setValue(EVENT_STRT_DATE);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_END_DATE")).setValue(EVENT_END_DATE);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_GOODS_SALE_QTY")).setValue('0');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_GOODS_FEE_AMT")).setValue("0");
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("GOODS_TOT_DC_AMT")).setValue('0');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_GOODS_SEQ")).setValue('1');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_GOODS_RANK")).setValue('0');
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
	
	<%-- 상품 붙여넣기 function --%>
	function pasteGoods(result){
		var selectedRowId = erpGrid.getCheckedRows(erpGrid.getColIndexById("SELECT"));
		var ORGN_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_CD")).getValue();
		var ORGN_DIV_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_DIV_CD")).getValue();
		var EVENT_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("EVENT_CD")).getValue();
		var EVENT_STRT_DATE = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("EVENT_STRT_DATE")).getValue();
		var EVENT_END_DATE = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("EVENT_END_DATE")).getValue();
		
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
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_CD")).setValue(EVENT_CD);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_STRT_DATE")).setValue(EVENT_STRT_DATE);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_END_DATE")).setValue(EVENT_END_DATE);
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("POINT_SAVE_EX_YN")).setValue('N');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_GOODS_SALE_QTY")).setValue('0');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_GOODS_FEE_AMT")).setValue("0");
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_GOODS_STATE")).setValue('Y');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("GOODS_TOT_DC_AMT")).setValue('0');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_GOODS_SEQ")).setValue('1');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_GOODS_RANK")).setValue('0');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_GOODS_DC_QTY")).setValue('1');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_GOODS_DC_TYPE")).setValue('1');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("ONE_TIME_LIMIT_QTY")).setValue('-1');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_LIMIT_QTY")).setValue('-1');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_APPLY_HH_FROM")).setValue('00');
				erpSubGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpSubGrid.getColIndexById("EVENT_APPLY_HH_TO")).setValue('00');
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
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
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
	
	<%-- erpSubGrid 조회 Function --%>
	function searchErpSubGrid(EVENT_CD, ORGN_CD, ORGN_DIV_CD){
		erpSubLayout.progressOn();
		var selectedRowId = erpGrid.getCheckedRows(erpGrid.getColIndexById("SELECT"));
		var paramData = {};
		paramData["EVENT_CD"] = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("EVENT_CD")).getValue();
		paramData["ORGN_CD"] = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_CD")).getValue();
		paramData["ORGN_DIV_CD"] = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_DIV_CD")).getValue();
		paramData["EVENT_GOODS_STATE"] = $('input[name=Invalid_Condition]:checked').length;
		paramData["ORGN_APPLY_YN"] = $('input[name=orgn_apply_yn]:checked').length;
		$.ajax({
			url : "/sis/market/getBargainManagementSubList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpSubLayout.progressOff();
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
				erpSubLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		
	}
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(EVENT_CD, ORGN_CD, ORGN_DIV_CD){
		var selectedRowId = erpGrid.getCheckedRows(erpGrid.getColIndexById("SELECT"));
		var ORGN_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_CD")).getValue();
		var ORGN_DIV_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("ORGN_DIV_CD")).getValue();
		var EVENT_CD = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("EVENT_CD")).getValue();
		var EVENT_STRT_DATE = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("EVENT_STRT_DATE")).getValue();
		var EVENT_END_DATE = erpGrid.cells(selectedRowId, erpGrid.getColIndexById("EVENT_END_DATE")).getValue();
	
		var onClickRibbonAddData = function(popupGrid){
			//dataState : checked,selected  //copyType : add,new
			var popup = erpPopupWindows.window("openSearchGoodsGridPopup");
			popup.progressOn();
			$erp.copyRowsGridToGrid(popupGrid, erpSubGrid, ["BCD_CD","BCD_NM"], ["BCD_CD","BCD_NM"], "checked", "add", ["BCD_CD"], [], {"ORGN_CD" : ORGN_CD, "ORGN_DIV_CD" : ORGN_DIV_CD, "EVENT_CD" : EVENT_CD, "EVENT_STRT_DATE" : EVENT_STRT_DATE, "EVENT_END_DATE" : EVENT_END_DATE}, {"ORGN_CD" : ORGN_CD, "ORGN_DIV_CD" : ORGN_DIV_CD, "EVENT_CD" : EVENT_CD, "EVENT_STRT_DATE" : EVENT_STRT_DATE, "EVENT_END_DATE" : EVENT_END_DATE}, function(result){
				popup.progressOff();
				popup.close();
				
				pasteGoods(result);
			},false);
		}
		$erp.openSearchGoodsPopup(null,onClickRibbonAddData,{"ORGN_CD" : ORGN_CD  ,"ORGN_DIV_CD" : ORGN_DIV_CD});
	}
	
	<%-- saveErpSubGrid 저장 Function --%>
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
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpSubGrid);
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		var allIds = erpSubGrid.getAllRowIds(",");
		var allIdArray = allIds.split(",");
		
		var deleteRowIdArray = [];
		
		for(var i = 0 ; i < allIdArray.length ; i++) {
			var goods_nm = erpSubGrid.cells(allIdArray[i], erpSubGrid.getColIndexById("BCD_NM")).getValue();
			if(goods_nm == "조회정보없음"){
				console.log("조회정보없음");
				deleteRowIdArray.push(allIdArray[i]);
			}
		}
		
		for(var j = 0 ; j < deleteRowIdArray.length ; j++){
			console.log("deleteRow >> " + deleteRowIdArray[j]);
			erpSubGrid.deleteRow(deleteRowIdArray[j]); 
		}
		
		erpSubLayout.progressOn();
		
		var paramData = $erp.serializeDhtmlXGridData(erpSubGrid);
		var orgnApplyYn = $('#orgn_apply_yn').is(":checked");
		paramData["ORGN_APPLY_YN"] = orgnApplyYn;
		$.ajax({
			url : "/sis/market/saveBargainSubList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpSubLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertSuccessMesage(onAfterSaveErpSubGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpSubLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpSubGrid 저장 후 Function --%>
	function onAfterSaveErpSubGrid(){
		searchErpSubGrid();
	}
	
	<%-- deleteErpDetailGrid 삭제 Function --%>
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
	
	<%-- onKeyPressed 특매그룹 목록Grid_Keypressed Function --%>
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
	
	<%-- openAddNewBargainGroupPopup 새특매그룹추가 팝업 열림 Function --%>
	function openAddNewBargainGroupPopup(){
		var onClickAddData = function(EVENT_STRT_DATE, EVENT_END_DATE, EVENT_NM, EVENT_TYPE, ORGN_CD, ORGN_NM, USE_YN, EVENT_NAME){
			if(EVENT_STRT_DATE > EVENT_END_DATE){
				alert("날짜를 다시 지정해주세요.");
			}else if(EVENT_NAME == ""){
				alert("타이틀을 작성해주세요.");
			}else{
				var isValidated = true;
				var alertMessage = "";
				var alertCode = "";
				var alertType = "error";
				
				if(!isValidated){
					$erp.alertMessage({
						"alertMessage" : "필수 입력 항목이 남아있습니다."
						, "alertCode" : null
						, "alertType" : "alert"
						, "isAjax" : false
					});
				}else{
					var check;
					if(ORGN_CD[0] != ""){
						check = 0;
					}else if(ORGN_CD[0] == ""){
						check = 1;
					}
					
					for(var i = check ; i < ORGN_CD.length ; i ++) {
						if(i != ORGN_CD.length) {
						var uid = erpGrid.uid();
						erpGrid.addRow(uid);
						erpGrid.cells(uid, erpGrid.getColIndexById("EVENT_NM")).setValue(EVENT_NM);
						erpGrid.cells(uid, erpGrid.getColIndexById("ORGN_CD")).setValue(ORGN_CD[i]);
						erpGrid.cells(uid, erpGrid.getColIndexById("EVENT_STRT_DATE")).setValue(EVENT_STRT_DATE);
						erpGrid.cells(uid, erpGrid.getColIndexById("EVENT_END_DATE")).setValue(EVENT_END_DATE);
						erpGrid.cells(uid, erpGrid.getColIndexById("EVENT_TYPE")).setValue(EVENT_TYPE);
						erpGrid.cells(uid, erpGrid.getColIndexById("GOODS_CNT")).setValue("0");
						erpGrid.cells(uid, erpGrid.getColIndexById("USE_YN")).setValue(USE_YN);
						
						$erp.setDhtmlXGridFooterRowCount(erpGrid);
						}
					}
					$erp.closePopup2("openAddNewBargainGroupPopup");
					saveErpGrid();
				} 
			}
		}
		$erp.openAddNewBargainGroupPopup(onClickAddData);
	}
	
	<%-- dhtmlxCombo 초기화 Function --%>
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
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 100, null, false, LUI.LUI_orgn_cd);
		}
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>

</script>
</head>
<body>
	<div id="div_erp_main_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_main_table" class="samyang_div" style="display:none">
			<table id = "tb_search_01" class = "table_search">
				<colgroup>
					<col width="80px"/>
					<col width="270px"/>
					<col width="50px"/>
					<col width="90px"/>
					<col width="80px"/>
					<col width="110px"/>
					<col width="80px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th>특매그룹</th>
					<td>
						<div id="EVENT_TYPE"></div>
					</td>
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
					<col width="110px"/>
					<col width="125px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<td>
						<input type="checkbox" id="Invalid_Condition" name="Invalid_Condition" value="all">특매무효포함
					</td>
					<td>
						<input type="checkbox" id="orgn_apply_yn" name="orgn_apply_yn" value="all">동일이벤트적용
					</td>
					<td>
						&#60;상품바코드를 화면에 복사&붙여넣기 하여 상품을 추가할 수 있습니다.&#62;
					</td> 
				</tr>
			</table>
		</div>
		<div id="div_erp_sub_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_sub_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>