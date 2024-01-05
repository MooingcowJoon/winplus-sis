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
	var erpGrupLayout;
	var erpGoodsLayout;
	var erpCustmrLayout;
	var erpGrupRibbon;
	var erpGoodsRibbon;
	var erpGrupGrid;
	var erpGoodsGrid;
	var erpCustmrGrid;
	var erpGrupGridColumns;
	var erpGoodsGridColumns;
	var erpCustmrGridColumns;
	
	var erpGrupGridDateColumns;
	var erpGrupGridDataProcessor;
	var erpGoodsGridDateColumns;
	var erpGoodsGridDataProcessor;
	var erpCustmrDateColumns;
	var erpCustmrDataProcessor;
	
	var cmbCUSTMR_SALE_PRICE;
	var cmbUSE_YN;
	
	var today = $erp.getToday("");
	var lastYear = today.substring(0, 4)-1;
	var thisYear = today.substring(0, 4);
	var thisMonth = today.substring(4, 6);
	var thisday = today.substring(6, 8);
 	var fromDate = lastYear + "-" + thisMonth + "-" +thisday;
	var toDate = thisYear + "-" + thisMonth + "-" + thisday;
	
	$(document).ready(function(){
		
		initErpLayout();
		
		initErpGrupLayout();
		initErpGoodsLayout();
		initErpCustmrLayout();
		
		initErpGrupRibbon();
		initErpGoodsRibbon();
		
		initErpGrupGrid();
		initErpGoodsGrid();
		initErpCustmrGrid();
		
		initDhtmlXCombo();
		
		document.getElementById("txtDATE_FR").value=fromDate;
		document.getElementById("txtDATE_TO").value=toDate;
		
		$erp.asyncObjAllOnCreated(function(){
			searchErpGrupGrid();
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3J"
			, cells : [
				{id: "a", text: "기준가등록그룹 등록/조회", header: true , fix_size:[false, false], width:550}
				, {id : "b", text: "기준가등록상품 등록/조회", header: true, fix_size:[false, true]}
				, {id : "c", text: "거래처리스트", header: true, fix_size:[false, false]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_grup_layout");
		erpLayout.cells("a").setHeight(500);
		erpLayout.cells("b").attachObject("div_erp_goods_layout");
		erpLayout.cells("c").attachObject("div_erp_custmr_layout");
		
		erpLayout.setSeparatorSize(0, 5);
		erpLayout.setSeparatorSize(1, 5);
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpGrupLayout 관련 Function 시작 --%>
	<%-- erpGrupLayout 초기화 Function --%>
	function initErpGrupLayout(){
		erpGrupLayout = new dhtmlXLayoutObject({
			parent: "div_erp_grup_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건", header:false , fix_size:[true, true]}
				, {id: "b", text: "리본", header:false , fix_size:[true, true]}
				, {id: "c", text: "그리드", header:false}
			]		
		});
		erpGrupLayout.cells("a").attachObject("div_erp_grup_table");
		erpGrupLayout.cells("a").setHeight(38);
		erpGrupLayout.cells("b").attachObject("div_erp_grup_ribbon");
		erpGrupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpGrupLayout.cells("c").attachObject("div_erp_grup_grid");
		
		erpGrupLayout.setSeparatorSize(0, 1);
		erpGrupLayout.setSeparatorSize(1, 1);
	}	
	<%-- ■ erpGrupLayout 관련 Function 끝 --%>
	
	<%-- ■ erpGoodsLayout 관련 Function 시작 --%>
	<%-- erpGoodsLayout 초기화 Function --%>
	function initErpGoodsLayout() {
		erpGoodsLayout = new dhtmlXLayoutObject({
			parent : "div_erp_goods_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "리본", header: false , fix_size:[false, true]}
				, {id: "b", text: "그리드", header: false , fix_size:[false, true]}
			]
		});
		erpGoodsLayout.captureEventOnParentResize(erpLayout);
		
		erpGoodsLayout.cells("a").attachObject("div_erp_goods_ribbon");
		erpGoodsLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpGoodsLayout.cells("b").attachObject("div_erp_goods_grid");
		
		erpGoodsLayout.setSeparatorSize(0, 1);
	}
	<%-- ■ erpGoodsLayout 관련 Function 끝 --%>
	
	<%-- ■ erpCustmrLayout 관련 Function 시작 --%>
	<%-- erpCustmrLayout 초기화 Function --%>
	function initErpCustmrLayout() {
		erpCustmrLayout = new dhtmlXLayoutObject({
			parent : "div_erp_custmr_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "1C"
			, cells : [
				{id: "a", text: "그리드", header: false , fix_size:[false, true]}
			]
		});
		erpCustmrLayout.captureEventOnParentResize(erpLayout);
		erpCustmrLayout.cells("a").attachObject("div_erp_custmr_grid");
		
		erpCustmrLayout.setSeparatorSize(0, 1);
	}
	<%-- ■ erpCustmrLayout 관련 Function 끝 --%>
	
	<%-- ■ erpGrupRibbon 관련 Function 시작 --%>
	function initErpGrupRibbon() {
		erpGrupRibbon = new dhtmlXRibbon({
			parent : "div_erp_grup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
					, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false} 
				]}
			]
		});	
		
		erpGrupRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "add_erpGrid") {
				addErpGrupGrid();
			}else if(itemId == "search_erpGrid") {
				searchErpGrupGrid();
			}else if (itemId == "delete_erpGrid"){
				deleteGrupErpGrid();
			}else if (itemId == "save_erpGrid"){
				saveErpGrupGrid();
			}
		});
	}
	<%-- ■ erpGrupRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGoodsRibbon 관련 Function 시작 --%>
	function initErpGoodsRibbon() {
		erpGoodsRibbon = new dhtmlXRibbon({
			parent : "div_erp_goods_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "add_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
					, {id : "delete_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					, {id : "save_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false} 
					, {id : "excelForm_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					, {id : "excel_subgrid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, isHidden : true}				
				]}
			]
		});	
		
		erpGoodsRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_sub_erpGrid"){
				var gridRowCount = erpGrupGrid.getRowsNum();
				for(var i = 0; i < gridRowCount; i++){
					var rId = erpGrupGrid.getRowId(i);
					var detailcheck = erpGrupGrid.cells(rId, erpGrupGrid.getColIndexById("SELECT")).getValue();
					if(detailcheck == 1) {
						openSearchGoodsGridPopup();
						return false;
					}
				} 
				$erp.alertMessage({
					"alertMessage" : "거래처기준가그룹을 선택 후 이용가능합니다."
					, "alertType" : "alert"
					, "isAjax" : false
				});
			}else if (itemId == "delete_sub_erpGrid"){
				deleteErpGoodsGrid();
			}else if (itemId == "save_sub_erpGrid"){
				saveErpGoodsGrid();
			}else if(itemId == "excelForm_sub_erpGrid"){
				$erp.exportGridToExcel({
					"grid" : erpGoodsGrid
					, "fileName" : "고객그룹별_기준가관리_양식"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : true
				});
			}else if(itemId == "excel_subgrid_upload") {
				var convertModuleUrl = ""; //엑셀로 컨버트 하는 모듈을 다른것을 사용하고자 할때만 사용
				var uploadFileLimitCount = 1; //파일 업로드 개수 제한
				var onUploadFile = function(files, uploadData, toGrid){
					$erp.uploadDataParse(this, files, uploadData, toGrid, "BCD_CD", "add", ["BCD_CD"], []);
				}
				var onUploadComplete = function(uploadedFileInfoList, toGrid, result){
					pasteGoods(result);
				}
				var onBeforeFileAdd = function(file){};
				var onBeforeClear = function(){};
				$erp.excelUploadPopup(erpGoodsGrid, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			}
		});
	}
	<%-- ■ erpGoodsRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrupGrid 관련 Function 시작 --%>
	function initErpGrupGrid(){
		erpGrupGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "SELECT", label : ["선택", "#rspan"], type : "ra", width : "35", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "STD_PRICE_GRUP_NM", label:["거래처기준가그룹", "#select_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "STD_PRICE_GRUP", label:["거래처기준가그룹코드", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "CUSTMR_GRUP", label:["거래처그룹", "#select_filter"], type: "combo", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true, commonCode : ['CUSTMR_GRUP']}
			, {id : "STRT_DATE", label:["적용시작일", "#rspan"], type: "ed", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "USE_YN", label:["사용구분", "#rspan" ], type: "combo", width: "75", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["USE_CD" , "YN"]}
			];
		
		erpGrupGrid = new dhtmlXGridObject({
			parent: "div_erp_grup_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGrupGridColumns
		});	
		
		erpGrupGrid.attachEvent("onKeyPress",onKeyGrupPressed);
		erpGrupGrid.enableBlockSelection();
		erpGrupGrid.enableDistributedParsing(true, 100, 50);
		erpGrupGrid.enableAccessKeyMap(true);
		erpGrupGrid.enableColumnMove(true);
		erpGrupGrid.setDateFormat("%Y-%m-%d", "%Y-%m-%d");
		$erp.initGridCustomCell(erpGrupGrid);
		$erp.initGridComboCell(erpGrupGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrupGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpGrupGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGrupGridDataProcessor = new dataProcessor();
		erpGrupGridDataProcessor.init(erpGrupGrid);
		erpGrupGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrupGrid);
		
		erpGrupGrid.attachEvent("onCheck", function(rId,cInd){
			if(cInd == this.getColIndexById("SELECT")){
				var paramData = {};
				paramData["STD_PRICE_GRUP"] = this.cells(rId, this.getColIndexById("STD_PRICE_GRUP")).getValue();
				paramData["CUSTMR_GRUP"] = this.cells(rId, this.getColIndexById("CUSTMR_GRUP")).getValue();
				
				searchErpCustmrGrid(paramData);
				searchErpGoodsGrid();
				}
			});
	}
	<%-- ■ erpGrupGrid 관련 Function 끝 --%>
	
	<%-- ■ erpGoodsGrid 관련 Function 시작 --%>
	function initErpGoodsGrid(){
		erpGoodsGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "GOODS_NO", label:["상품코드", "#text_filter"], type: "ro", width: "95", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드", "#text_filter"], type: "ro", width: "110", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "BCD_NM", label:["상품명", "#text_filter"], type: "ro", width: "230", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "PUR_PRICE", label:["기준매입가", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_PRICE", label:["기준출고가", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "STD_SALE_PRICE", label:["적용출고가", "#rspan"], type: "edn", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true}
			, {id : "PROF_RATE", label:["이익율", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "00.00%"}
			, {id : "TAX_YN", label:["부가세", "#select_filter"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ['USE_CD', 'YN']}
			, {id : "USE_YN", label:["사용", "#select_filter"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ['USE_CD', 'YN']}
			, {id : "REMK", label:["비고", "#rspan"], type: "ro", width: "125", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "STD_PRICE_GRUP", label:["거래처기준가그룹코드", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "CUSTMR_GRUP", label:["거래처그룹", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			];
		
		erpGoodsGrid = new dhtmlXGridObject({
			parent: "div_erp_goods_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGoodsGridColumns
		});	
		
		$erp.initGridCustomCell(erpGoodsGrid);
		erpGoodsGridDataProcessor = $erp.initGrid(erpGoodsGrid, {useAutoAddRowPaste : true, standardColumnId : "BCD_CD", deleteDuplication : true, overrideDuplication : false, editableColumnIdListOfInsertedRows : ["BCD_CD"], notEditableColumnIdListOfInsertedRows : []});
		
		erpGoodsGrid.attachEvent("onCellChanged", function (rowId,columnIdx,newValue){
			var warning_pr_rowId_obj = {};
			if(erpGoodsGrid.getColumnId(columnIdx) == "STD_SALE_PRICE"){
				let sp; 				//정상판매
				let ep; 				//특매판매
				let change_ep;			//할인율
				let change_ep_price;	//할인
				
				sp = erpGoodsGrid.cells(rowId, erpGoodsGrid.getColIndexById("PUR_PRICE")).getValue();
				ep = erpGoodsGrid.cells(rowId, erpGoodsGrid.getColIndexById("STD_SALE_PRICE")).getValue();
				
				sp = parseInt(sp);
				ep = parseInt(ep);
				
				change_ep = ((ep-sp)/sp) * 100;
				
				erpGoodsGrid.cells(rowId, erpGoodsGrid.getColIndexById("PROF_RATE")).setValue(change_ep);
				
				setTimeout(function(){
					if(change_ep < 0){
						erpGoodsGrid.cells(rowId, erpGoodsGrid.getColIndexById("PROF_RATE")).setBgColor('#F6CED8');
						warning_pr_rowId_obj[rowId] = rowId;
					}
				},50);
			}	
		});
		
		erpGoodsGrid.attachEvent("onEndPaste", function(result){
			if(check == "1" || check == "BCD_CD"){
				pasteGoods(result);
			}
		});
		
		erpGoodsGrid.attachEvent("onRowSelect", function(rId, Ind){
			check = erpGoodsGrid.getColumnId(Ind);
		});
		
		erpGoodsGrid.attachEvent("onEmptyClick", function(ev){
			check = "1";
		});
		
	}
	<%-- ■ erpGoodsGrid 관련 Function 끝 --%>
	
	<%-- ■ erpCustmrGrid 관련 Function 시작 --%>
	function initErpCustmrGrid(){
		erpCustmrGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CUSTMR_CD", label:["거래처코드", "#rspan"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CUSTMR_NM", label:["거래처명", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CORP_NO", label:["사업자번호", "#rspan"], type: "ro", width: "90", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CUSTMR_GRUP", label:["거래처그룹", "#rspan"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : ['CUSTMR_GRUP']}
			, {id : "CDATE", label:["생성일자", "#rspan"], type: "ro", width: "75", sort : "str", align : "left", isHidden : false, isEssential : false}
			];
		
		erpCustmrGrid = new dhtmlXGridObject({
			parent: "div_erp_custmr_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpCustmrGridColumns
		});	
		
		erpCustmrGrid.attachEvent("onKeyPress",onKeyCustmrPressed);
		erpCustmrGrid.enableBlockSelection();
		erpCustmrGrid.enableDistributedParsing(true, 100, 50);
		erpCustmrGrid.enableAccessKeyMap(true);
		erpCustmrGrid.enableColumnMove(true);
		erpCustmrGrid.setDateFormat("%Y-%m-%d", "%Y-%m-%d");
		$erp.initGridCustomCell(erpCustmrGrid);
		$erp.initGridComboCell(erpCustmrGrid);
		$erp.attachDhtmlXGridFooterPaging(erpCustmrGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpCustmrGrid, '<spring:message code="grid.allRowCount" />');
		
		erpCustmrGridDataProcessor = new dataProcessor();
		erpCustmrGridDataProcessor.init(erpCustmrGrid);
		erpCustmrGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpCustmrGrid);
		
	}
	<%-- ■ erpCustmrGrid 관련 Function 끝 --%>
	
	<%-- ■ erpGrupGrid 조회 Function 시작 --%>
	function searchErpGrupGrid(){
		var paramData = {};
		paramData["STD_PRICE_GRUP"] =cmbCUSTMR_SALE_PRICE.getSelectedValue();
		paramData["DATE_FR"] = document.getElementById("txtDATE_FR").value;
		paramData["DATE_TO"] = document.getElementById("txtDATE_TO").value;
		console.log(paramData);
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/basic/getGrupStdPrice.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGrupGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrupGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpGrupGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrupGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpGrupGrid 조회 Function 끝 --%>
	
	<%-- ■ addErpGrupGrid 추가 Function 시작 --%>
	function addErpGrupGrid(){
		var date = $erp.getToday("");
		
		var uid = erpGrupGrid.uid();
		erpGrupGrid.addRow(uid,null,0);
		
		erpGrupGrid.selectRow(erpGrupGrid.getRowIndex(uid));
		erpGrupGrid.cells(uid, erpGrupGrid.getColIndexById("USE_YN")).setValue("Y");
		erpGrupGrid.cells(uid, erpGrupGrid.getColIndexById("STRT_DATE")).setValue(date);
		$erp.setDhtmlXGridFooterRowCount(erpGrupGrid);
	}
	<%-- ■ addErpGrid 추가 Function 끝 --%>
	
	<%-- ■ saveErpGrupGrid 저장 Function 시작 --%>
	function saveErpGrupGrid() {
		if(erpGrupGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpGrupGrid);
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		erpGrupLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpGrupGrid);
		$.ajax({
			url : "/sis/basic/saveGrupStdPrice.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpGrupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertMessage({
						"alertMessage" : "완료되었습니다."
						, "alertCode" : null
						, "alertType" : "alert"
						, "isAjax" : false
						,"alertCallbackFn" : function confirmAgain(){
							searchErpGrupGrid();
						}
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpGrupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ saveErpGrupGrid 저장 Function 끝 --%>
	
	<%-- ■ deleteGrupErpGrid  삭제 Function 시작--%>
	function deleteGrupErpGrid(){
		var gridRowCount = erpGrupGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		
		var deleteRowIdArray = [];
		var check = "";
		
		for(var i = 0 ; i < RowCountArray.length ; i++){
			check = erpGrupGrid.cells(RowCountArray[i], erpGrupGrid.getColIndexById("CHECK")).getValue();
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
			erpGrupGrid.deleteRow(deleteRowIdArray[j]);
		}
			
		$erp.setDhtmlXGridFooterRowCount(erpGrupGrid);
		
		saveErpGrupGrid();
	}
	
	<%-- ■ erpCustmrGrid 조회 Function 시작 --%>
	function searchErpCustmrGrid(paramData){
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/basic/getStdPriceCustmrList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
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
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpCustmrGrid 조회 Function 끝 --%>
	
	<%-- ■ erpGoodsGrid 조회 Function 시작 --%>
	function searchErpGoodsGrid(){
		var selectedRowId = erpGrupGrid.getCheckedRows(erpGrupGrid.getColIndexById("SELECT"));
		var CUSTMR_GRUP = erpGrupGrid.cells(selectedRowId, erpGrupGrid.getColIndexById("CUSTMR_GRUP")).getValue();
		var STD_PRICE_GRUP = erpGrupGrid.cells(selectedRowId, erpGrupGrid.getColIndexById("STD_PRICE_GRUP")).getValue();
		
		var paramData ={};
		paramData["STD_PRICE_GRUP"] = STD_PRICE_GRUP;
		paramData["CUSTMR_GRUP"] = CUSTMR_GRUP;
		
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/basic/getGoodsStdPrice.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
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
				}
				$erp.setDhtmlXGridFooterRowCount(erpGoodsGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpGoodsGrid 조회 Function 끝 --%>
	
	<%-- ■ saveErpGoodsGrid 저장 Function 시작 --%>
	function saveErpGoodsGrid() {
		if(erpGoodsGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpGoodsGrid);
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		erpGoodsLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpGoodsGrid);
		$.ajax({
			url : "/sis/basic/saveGoodsStdPrice.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpGoodsLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertMessage({
						"alertMessage" : "완료되었습니다."
						, "alertCode" : null
						, "alertType" : "alert"
						, "isAjax" : false
						,"alertCallbackFn" : function confirmAgain(){
							searchErpGoodsGrid();
						}
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpGoodsLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ saveErpGoodsGrid 저장 Function 끝 --%>
	
	<%-- ■ deleteErpGoodsGrid  삭제 Function 시작--%>
	function deleteErpGoodsGrid(){
		var gridRowCount = erpGoodsGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		
		var deleteRowIdArray = [];
		var check = "";
		
		for(var i = 0 ; i < RowCountArray.length ; i++){
			check = erpGoodsGrid.cells(RowCountArray[i], erpGoodsGrid.getColIndexById("CHECK")).getValue();
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
			erpGoodsGrid.deleteRow(deleteRowIdArray[j]);
		}
			
		$erp.setDhtmlXGridFooterRowCount(erpGoodsGrid);
		
		$erp.confirmMessage({
			"alertMessage" : "삭제시 해당 품목을 다시 사용하기 위해선<br><span style='color:red; font-weight:bold;'>재등록</span>을 해야 합니다.&nbsp재사용을 위해서는<br>사용여부를 <span style='color:red; font-weight:bold;'>'N'</span>으로 설정하시기 바랍니다.<br>진행하시겠습니까?",
			"alertType" : "alert",
			"isAjax" : false,
			"alertCallbackFn" : function confirmAgain(){
					saveErpGoodsGrid();
			}
		});
	}
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(){
		var onClickRibbonAddData = function(popupGrid){
			var popup = erpPopupWindows.window("openSearchGoodsGridPopup");
			popup.progressOn();
			$erp.copyRowsGridToGrid(popupGrid, erpGoodsGrid, ["BCD_CD","BCD_NM","DIMEN_NM"], ["BCD_CD","BCD_NM","DIMEN_NM"], "checked", "add", ["BCD_CD"], [], {}, {}, function(result){
				popup.progressOff();
				popup.close();
				
				pasteGoods(result);
			},false);
		}
		$erp.openSearchGoodsPopup(null,onClickRibbonAddData,{"ORGN_DIV_CD" : "B01"});
	}
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 끝 Function --%>
	
	<%-- 상품 붙여넣기 function 시작--%>
	function pasteGoods(result){
		var selectedRowId = erpGrupGrid.getCheckedRows(erpGrupGrid.getColIndexById("SELECT"));
		var CUSTMR_GRUP = erpGrupGrid.cells(selectedRowId, erpGrupGrid.getColIndexById("CUSTMR_GRUP")).getValue();
		var STD_PRICE_GRUP= erpGrupGrid.cells(selectedRowId, erpGrupGrid.getColIndexById("STD_PRICE_GRUP")).getValue();
		
		var loadGoodsList = [];
		var data;
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];
			loadGoodsList.push(data["BCD_CD"]);
		}
		
		var url = "/sis/basic/getStdPriceGoodsManagementInfo.do";
		var send_data = {"loadGoodsList" : loadGoodsList};
		
		var if_success = function(data){
			var gridDataList = data.gridDataList;
			for(var index in gridDataList){
				erpGoodsGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGoodsGrid.getColIndexById("TAX_YN")).setValue('Y');
				erpGoodsGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGoodsGrid.getColIndexById("USE_YN")).setValue('Y');
				erpGoodsGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGoodsGrid.getColIndexById("STD_PRICE_GRUP")).setValue(STD_PRICE_GRUP);
				erpGoodsGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGoodsGrid.getColIndexById("CUSTMR_GRUP")).setValue(CUSTMR_GRUP);
				erpGoodsGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGoodsGrid.getColIndexById("PUR_PRICE")).setValue(gridDataList[index]["PUR_PRICE"]);
				erpGoodsGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGoodsGrid.getColIndexById("GOODS_NO")).setValue(gridDataList[index]["GOODS_NO"]);
				erpGoodsGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGoodsGrid.getColIndexById("BCD_NM")).setValue(gridDataList[index]["BCD_NM"]);
				erpGoodsGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGoodsGrid.getColIndexById("DIMEN_NM")).setValue(gridDataList[index]["DIMEN_NM"]);
				erpGoodsGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGoodsGrid.getColIndexById("SALE_PRICE")).setValue(gridDataList[index]["SALE_PRICE"]);
				result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]].push("로드완료");
			}	
			var notExistList = [];
			var value;
			var state;
			var dp = erpGoodsGrid.getDataProcessor();
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["BCD_CD"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			$erp.deleteGridRows(erpGoodsGrid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			if(erpGoodsGrid.getRowsNum() == 0){
				erpGoodsGrid.callEvent("onClick",["searchErpGoodsGrid"]);
				return;
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpGoodsGrid); // 현재 행수 계산
			
		}
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpGoodsLayout);
	}
	<%-- 상품 붙여넣기 function 끝--%>
	
	<%-- onKeyGrupPressed GrupGrid_Keypressed Function --%>
	function onKeyGrupPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpGrupGrid.setCSVDelimiter("\t");
			erpGrupGrid.copyBlockToClipboard()
		}
		if(code==86&&ctrl){
			erpGrupGrid.setCSVDelimiter("\t");
			erpGrupGrid.pasteBlockFromClipboard()
		}
		return true;
	}
	
	<%-- onKeyCustmrPressed CustmrGrid_Keypressed Function --%>
	function onKeyCustmrPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpCustmrGrid.setCSVDelimiter("\t");
			erpCustmrGrid.copyBlockToClipboard()
		}
		if(code==86&&ctrl){
			erpCustmrGrid.setCSVDelimiter("\t");
			erpCustmrGrid.pasteBlockFromClipboard()
		}
		return true;
	}
	
	<%-- dhtmlxCombo 초기화 Function --%>
	function initDhtmlXCombo(){
// 		cmbUSE_YN = $erp.getDhtmlXComboCommonCode('cmbUSE_YN', 'USE_CD',['USE_CD', 'YN'], 100, "모두조회", false,"Y");
		cmbCUSTMR_SALE_PRICE = $erp.getDhtmlXComboTableCode("cmbCUSTMR_SALE_PRICE", "CUSTMR_SALE_PRICE", "/sis/code/getSearchStdPriceCdList.do", null, 130, "모두조회", false);
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_grup_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_grup_table" class="samyang_div" style="display:none">
			<table id = "tb_search_01" class = "table_search">
					<colgroup>
					<col width="105px"/>
					<col width="125px"/>
					<col width="50px"/>
					<col width="200px"/>
				</colgroup>
				<tr>
					<th>거래처기준가그룹</th>
					<td><div id="cmbCUSTMR_SALE_PRICE"></div> </td>
					<th>적용일자</th>
					<td>
						<input type="text" id="txtDATE_FR" class="input_calendar" value=""/>
						<span style="float: left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO" class="input_calendar" value="" style="float: left; margin-left: 6px;"/>
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_grup_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_grup_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	<div id="div_erp_goods_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_goods_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_goods_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	<div id="div_erp_custmr_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_custmr_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>