<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js"></script>
<script type="text/javascript">

	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpMainLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
		■ erpSubRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGoodsGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpDateGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridGoodsColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDateColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
		■ erpGridDataGoodsProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
		■ erpGridDataDateProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
		■ searchDateFrom : String / 기간(갑) 시작일
		■ searchDateTo : String / 기간(갑) 마지막일
		■ erpSubGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ cmbPUR_TYPE : Object / 판매유형 selectBox
	--%>
	
	var erpLayout;
	var erpMainLayout;
	var erpSubLayout;
	var erpRibbon;
	var erpSubRibbon;
	var erpGrid;
	var erpGoodsGrid;
	var erpAllGoodsGrid;
	var erpDateGrid;
	var erpAllDateGrid;
	var erpGridColumns;
	var erpGridGoodsColumns;
	var erpGridDateColumns;
	var erpGridDataProcessor;
	var erpGridDataGoodsProcessor;
	var erpGridDataDateProcessor;
	var searchDateFrom;
	var searchDateTo;
	var erpSubGrid;
	var cmbPUR_TYPE;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var check_num = 0;
	
	$(document).ready(function(){
		initErpLayout();
		initErpMainLayout();
		initDhtmlXCombo();
		initErpSubLayout();
		initErpRibbon();
		initErpSubRibbon();
		initErpGrid();
		initErpSubGrid();
		GridContextMenu(erpPartGrid);
		gubunType();
	});
	
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "일_수수료공급사별 조회", header: true}
				, {id : "b", text: "상세내역", header: true}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_main_layout");
		erpLayout.cells("b").attachObject("div_erp_sub_layout");
		
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpMainLayout.setSizes();
			erpPartGrid.setSizes();
			erpAllGrid.setSizes();
			erpSubLayout.setSizes();
			erpGoodsGrid.setSizes();
			erpAllGoodsGrid.setSizes();
			erpDateGrid.setSizes();
			erpAllDateGrid.setSizes();
		});
	}
	
	function initErpMainLayout() {
		erpMainLayout = new dhtmlXLayoutObject({
			parent : "div_erp_main_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "", header: false}
				, {id: "b", text: "", header: false, fix_size:[true, true]}
				, {id: "c", text: "", header: false}
			]
		});
		
		erpMainLayout.cells("a").attachObject("div_erp_contents_search");
		erpMainLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpMainLayout.cells("b").attachObject("div_erp_ribbon");
		erpMainLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpMainLayout.cells("c").attachObject("div_erp_grid");
		
		erpMainLayout.setSeparatorSize(1, 0);
	}
	
	function initErpSubLayout() {
		erpSubLayout = new dhtmlXLayoutObject({
			parent : "div_erp_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "", header: false}
				, {id: "b", text: "", header: false, fix_size:[true, true]}
				, {id: "c", text: "", header: false}
			]
		});
		
		erpSubLayout.cells("a").attachObject("div_erp_search_condition");
		erpSubLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpSubLayout.cells("b").attachObject("div_erp_sub_ribbon");
		erpSubLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpSubLayout.cells("c").attachObject("div_erp_sub_grid");
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	function initErpRibbon() {
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : false}
				]}							
			]
		});	
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid") {
				isMainSearchValidate();
			} else if(itemId == "excel_erpGrid") {
				$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "일레포트-수수료공급사별"	
		    		, "isForm" : false
		    	});
			} else if(itemId == "print_erpGrid") {
				
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
					{id : "search_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "excel_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					, {id : "print_sub_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : false}
				]}							
			]
		});	
		
		erpSubRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_sub_erpGrid") {
				
			} else if(itemId == "excel_sub_erpGrid") {
				$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGoodsGrid
		    		, "fileName" : "일레포트-수수료공급사별 상세상품내역"		
		    		, "isForm" : false
		    	});
			} else if(itemId == "print_sub_erpGrid") {
				
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid() {
		erpGrid = {};
		
		erpPartGridColumns = [
				{id : "gubun", label:["No", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}              
   			  , {id : "SURP_CD", label:["공급사코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
   			  , {id : "CUSTMR_NM", label:["공급사명", "#rspan"], type: "ro", width: "160", sort : "str", align : "left", isHidden : false, isEssential : false}
   			  , {id : "goods_bcode", label:["거래", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   			  , {id : "SALE_AMT", label:["매출액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   			  , {id : "SALE_FEE_AMT", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   			  , {id : "SALE_CARD_AMT", label:["카드금액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   			  , {id : "", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   			  , {id : "POINT_SAVE_AMT", label:["포인트적립", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   			  , {id : "", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   			  , {id : "", label:["수수료합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   			  , {id : "", label:["지급액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   		];
   		
   		erpPartGrid = new dhtmlXGridObject({
   			parent: "div_erp_part_grid"			
   			, skin : ERP_GRID_CURRENT_SKINS
   			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
   			, columns : erpPartGridColumns
   			, splitAt : 1
   		});		
   		erpPartGrid.enableDistributedParsing(true, 100, 50);
   		$erp.initGridCustomCell(erpPartGrid);
   		$erp.initGridComboCell(erpPartGrid);				
   		$erp.attachDhtmlXGridFooterRowCount(erpPartGrid, '<spring:message code="grid.allRowCount" />');
   		
   		erpGridDataProcessor = new dataProcessor();
   		erpGridDataProcessor.init(erpPartGrid);
   		erpGridDataProcessor.setUpdateMode("off");
   		$erp.initGridDataColumns(erpPartGrid);
   		$erp.attachDhtmlXGridFooterPaging(erpPartGrid, 100);
   		
   		erpPartGrid.attachEvent("onRowDblClicked", function(rId){
   			var custmr_cd = this.cells(rId, this.getColIndexById("SURP_CD")).getValue();
   			var custmr_nm = this.cells(rId, this.getColIndexById("CUSTMR_NM")).getValue();
   			
   			isSubSearchValidate(custmr_cd, custmr_nm);
   		});
   		
   		erpGrid["div_erp_part_grid"] = erpPartGrid;
		
   		document.getElementById("div_erp_part_grid").style.display = "block";
   		
   		
   		erpAllGridColumns = [
			{id : "gubun", label:["No", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}              
			  , {id : "SURP_CD", label:["공급사코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "CUSTMR_NM", label:["공급사명", "#rspan"], type: "ro", width: "160", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["거래", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["매출액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["카드금액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["현금영수증", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["포인트적립", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["캐시백적립", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["수수료합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["지급액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpAllGrid = new dhtmlXGridObject({
			parent: "div_erp_all_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpAllGridColumns
			, splitAt : 1
		});		
		erpAllGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpAllGrid);
		$erp.initGridComboCell(erpAllGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpAllGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpAllGrid);
		erpGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpAllGrid);
		$erp.attachDhtmlXGridFooterPaging(erpAllGrid, 100);
		
		erpAllGrid.attachEvent("onRowDblClicked", function(rId){
			var custmr_cd = this.cells(rId, this.getColIndexById("SURP_CD")).getValue();
   			var custmr_nm = this.cells(rId, this.getColIndexById("CUSTMR_NM")).getValue();
   			
   			isSubSearchValidate(custmr_cd, custmr_nm);
		});
		
		erpGrid["div_erp_all_grid"] = erpAllGrid;
	}
	
	function GridContextMenu(SelectedErpGrid){
		var items = [
			{id: "All_Columns", 					text: "펼쳐보기"},
			{id: "Part_Columns", 					text: "줄여보기"},
		];
		
		var onRightClick = function(id, zoneId, cas){
			console.log("onRightClick");
			var selectedRowsData;
			
			var prefixId = id.split("_____")[0];
			var value = id.split("_____")[1];
			
			console.log("id : " + id);
			console.log("prefixId : " + prefixId);
			console.log("value : " + value);
			
			if(prefixId == "All_Columns"){
				document.getElementById("div_erp_all_grid").style.display = "block";
				document.getElementById("div_erp_part_grid").style.display = "none";
				GridContextMenu(erpAllGrid);
			}else if(prefixId == "Part_Columns"){
				document.getElementById("div_erp_all_grid").style.display = "none";
				document.getElementById("div_erp_part_grid").style.display = "block";
				GridContextMenu(erpPartGrid);
			}else {
				$erp.alertMessage({
					"alertMessage" : "아직 구현되지 않았습니다. " + id,
					"alertType" : "alert",
					"isAjax" : false
				});
			}
		}
		
		$cm.useGridRightClick(SelectedErpGrid, items , onRightClick);
	}
	
	
	function initErpSubGrid(){
		erpSubGrid = {};
		
		var grid_Columns_goods = [
			{id : "gubun", label:["No", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}              
 			  , {id : "GOODS_NM", label:["상품명", "#rspan"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "SALE_CNT", label:["매출량", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "SALE_AMT", label:["매출액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "SALE_FEE_AMT", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "SALE_CARD_AMT", label:["카드금액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "POINT_SAVE_AMT", label:["포인트적립", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "goods_bcode", label:["수수료합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "goods_bcode", label:["지급액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpGoodsGrid = new dhtmlXGridObject({
			parent: "div_erp_goods_grid"			
   			, skin : ERP_GRID_CURRENT_SKINS
   			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
   			, columns : grid_Columns_goods
		});
		
		erpGoodsGrid.enableDistributedParsing(true, 100, 50);
   		$erp.initGridCustomCell(erpGoodsGrid);
   		$erp.initGridComboCell(erpGoodsGrid);				
   		$erp.attachDhtmlXGridFooterRowCount(erpGoodsGrid, '<spring:message code="grid.allRowCount" />');
   		
   		erpGridDataGoodsProcessor = new dataProcessor();
   		erpGridDataGoodsProcessor.init(erpGoodsGrid);
   		erpGridDataGoodsProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
   		$erp.initGridDataColumns(erpGoodsGrid);
   		$erp.attachDhtmlXGridFooterPaging(erpGoodsGrid, 100);
   		
   		erpSubGrid["div_erp_goods_grid"] = erpGoodsGrid;
   		
   		document.getElementById("div_erp_goods_grid").style.display = "block";
   		
   		var grid_All_Columns_goods = [
			{id : "gubun", label:["No", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}              
 			  , {id : "GOODS_NM", label:["상품명", "#rspan"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "SALE_CNT", label:["매출량", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "SALE_AMT", label:["매출액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "SALE_FEE_AMT", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "SALE_CARD_AMT", label:["카드금액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "CASH_RECP_AMT", label:["현금영수증", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "POINT_SAVE_AMT", label:["포인트적립", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "CABG_SAVE_AMT", label:["캐쉬백적립", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "goods_bcode", label:["수수료합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 			  , {id : "goods_bcode", label:["지급액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpAllGoodsGrid = new dhtmlXGridObject({
			parent: "div_erp_all_goods_grid"
   			, skin : ERP_GRID_CURRENT_SKINS
   			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
   			, columns : grid_All_Columns_goods
		});
		
		erpAllGoodsGrid.enableDistributedParsing(true, 100, 50);
   		$erp.initGridCustomCell(erpAllGoodsGrid);
   		$erp.initGridComboCell(erpAllGoodsGrid);				
   		$erp.attachDhtmlXGridFooterRowCount(erpAllGoodsGrid, '<spring:message code="grid.allRowCount" />');
   		
   		erpGridDataGoodsProcessor = new dataProcessor();
   		erpGridDataGoodsProcessor.init(erpAllGoodsGrid);
   		erpGridDataGoodsProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
   		$erp.initGridDataColumns(erpAllGoodsGrid);
   		$erp.attachDhtmlXGridFooterPaging(erpAllGoodsGrid, 100);
   		
   		erpSubGrid["div_erp_all_goods_grid"] = erpAllGoodsGrid;
   		
		
   		var grid_Columns_date = [
   			  {id : "gubun", label:["No", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}              
			  , {id : "OBJT_DATE", label:["일자", "#rspan"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "SALE_CNT", label:["품목수", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "SALE_CNT", label:["매출량", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "SALE_AMT", label:["매출액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "SALE_CARD_AMT", label:["카드금액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "POINT_SAVE_AMT", label:["포인트적립", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["수수료합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["지급액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   		];
   		
   		erpDateGrid = new dhtmlXGridObject({
   			parent: "div_erp_date_grid"			
   			, skin : ERP_GRID_CURRENT_SKINS
   			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
   			, columns : grid_Columns_date
   		});		
   		erpDateGrid.enableDistributedParsing(true, 100, 50);
   		$erp.initGridCustomCell(erpDateGrid);
   		$erp.initGridComboCell(erpDateGrid);				
   		$erp.attachDhtmlXGridFooterRowCount(erpDateGrid, '<spring:message code="grid.allRowCount" />');
   		
   		erpGridDataDateProcessor = new dataProcessor();
   		erpGridDataDateProcessor.init(erpDateGrid);
   		erpGridDataDateProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
   		$erp.initGridDataColumns(erpDateGrid);
   		$erp.attachDhtmlXGridFooterPaging(erpDateGrid, 100);
   		
   		erpSubGrid["div_erp_date_grid"] = erpDateGrid;
   		
   		
   		var grid_All_Columns_date = [
 			  {id : "gubun", label:["No", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}              
			  , {id : "OBJT_DATE", label:["일자", "#rspan"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "SALE_CNT", label:["품목수", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "SALE_CNT", label:["매출량", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "SALE_AMT", label:["매출액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "SALE_FEE_AMT", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "SALE_CARD_AMT", label:["카드금액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "SALE_CARD_FEE_AMT", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "CASH_RECP_AMT", label:["현금영수증", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "CASH_RECP_FEE_AMT", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "POINT_SAVE_AMT", label:["포인트적립", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "POINT_SAVE_FEE_AMT", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "CABG_SAVE_AMT", label:["캐시백적립", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "CABG_SAVE_FEE_AMT", label:["수수료", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["수수료합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "goods_bcode", label:["지급액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
 		];
 		
 		erpAllDateGrid = new dhtmlXGridObject({
 			parent: "div_erp_all_date_grid"			
 			, skin : ERP_GRID_CURRENT_SKINS
 			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
 			, columns : grid_All_Columns_date
 		});		
 		erpAllDateGrid.enableDistributedParsing(true, 100, 50);
 		$erp.initGridCustomCell(erpAllDateGrid);
 		$erp.initGridComboCell(erpAllDateGrid);				
 		$erp.attachDhtmlXGridFooterRowCount(erpAllDateGrid, '<spring:message code="grid.allRowCount" />');
 		
 		erpGridDataDateProcessor = new dataProcessor();
 		erpGridDataDateProcessor.init(erpAllDateGrid);
 		erpGridDataDateProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
 		$erp.initGridDataColumns(erpAllDateGrid);
 		$erp.attachDhtmlXGridFooterPaging(erpAllDateGrid, 100);
 		
 		erpSubGrid["div_erp_all_date_grid"] = erpAllDateGrid;
	}
	
	
	function SubGoodsGridContextMenu(SelectedErpGrid){
		var items = [
			{id: "Sub_All_Columns", 					text: "펼쳐보기"},
			{id: "Sub_Part_Columns", 					text: "줄여보기"},
		];
		
		var onGoodsRightClick = function(id, zoneId, cas){
			console.log("Sub_ onRightClick");
			var selectedRowsData;
			
			var prefixId = id.split("_____")[0];
			var value = id.split("_____")[1];
			
			/* console.log("sub_id : " + id);
			console.log("sub_prefixId : " + prefixId);
			console.log("sub_value : " + value); */
			
			if(prefixId == "Sub_All_Columns"){
					document.getElementById("div_erp_all_goods_grid").style.display = "block";
					document.getElementById("div_erp_goods_grid").style.display = "none";
					SubGoodsGridContextMenu(erpAllGoodsGrid);
			}else if(prefixId == "Sub_Part_Columns"){
					document.getElementById("div_erp_all_goods_grid").style.display = "none";
					document.getElementById("div_erp_goods_grid").style.display = "block";
					SubGoodsGridContextMenu(erpGoodsGrid);
			}else {
				$erp.alertMessage({
					"alertMessage" : "아직 구현되지 않았습니다. " + id,
					"alertType" : "alert",
					"isAjax" : false
				});
			}
		}
		
		$cm.useGridRightClick(SelectedErpGrid, items , onGoodsRightClick);
	}
	
	
	
	function SubDateGridContextMenu(SelectedErpGrid){
		var items = [
			{id: "Sub_All_Columns", 					text: "펼쳐보기"},
			{id: "Sub_Part_Columns", 					text: "줄여보기"},
		];
		
		var onDateRightClick = function(id, zoneId, cas){
			console.log("Sub_ onRightClick");
			var selectedRowsData;
			
			var prefixId = id.split("_____")[0];
			var value = id.split("_____")[1];
			
			/* console.log("sub_id : " + id);
			console.log("sub_prefixId : " + prefixId);
			console.log("sub_value : " + value); */
			
			if(prefixId == "Sub_All_Columns"){
					document.getElementById("div_erp_date_grid").style.display = "none";
					document.getElementById("div_erp_all_date_grid").style.display = "block";
					SubDateGridContextMenu(erpAllDateGrid);
			}else if(prefixId == "Sub_Part_Columns"){
					document.getElementById("div_erp_date_grid").style.display = "block";
					document.getElementById("div_erp_all_date_grid").style.display = "none";
					SubDateGridContextMenu(erpDateGrid);
			}else {
				$erp.alertMessage({
					"alertMessage" : "아직 구현되지 않았습니다. " + id,
					"alertType" : "alert",
					"isAjax" : false
				});
			}
		}
		
		$cm.useGridRightClick(SelectedErpGrid, items , onDateRightClick);
	}
	
	<%-- ■ erpGrid 관련 Function 끝--%>
	
	function isMainSearchValidate() {
		
		$("#div_erp_grid").children().each(function(index, obj){
			var display = obj.style.display;
			if(display == "block"){
				var id = obj.id;
				var grid_ID = obj.getAttribute("id");
				
				if(grid_ID == "div_erp_part_grid"){
					console.log("메인조회영역 줄여보기 영역");
					searchErpMainGrid(erpPartGrid);
				} else if (grid_ID == "div_erp_all_grid"){
					console.log("메인조회영역 펼쳐보기 영역");
					searchErpMainGrid(erpAllGrid);
				} else {
					console.log("나머지 조회 영역");
				}
				return false;
			}
		});
	}
	
	
	function searchErpMainGrid(grid_data){
		var FROM_DATE = document.getElementById("searchDateFrom").value;
		var TO_DATE = document.getElementById("searchDateTo").value;
		/* 공통코드사용시 공통사세코드명 불러오는 예시 시작*/
		var selected_pur_type = cmbPUR_TYPE.getSelectedValue();
		var PUR_CD_NM = cmbPUR_TYPE.getOption(selected_pur_type)["CMMN_DETAIL_CD_NM"];
		/* 공통코드사용시 공통사세코드명 불러오는 예시 끝*/
		var ORGN_DIV_CD = cmbORGN_DIV_CD.getSelectedValue();
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		
		$.ajax({
			url: "/sis/report/dayByReport/dayByCustmrFeeList.do"
			, data : {
				"PUR_CD_NM" : PUR_CD_NM
				, "FROM_DATE" : FROM_DATE
				, "TO_DATE" : TO_DATE
				, "ORGN_DIV_CD" : ORGN_DIV_CD
				, "ORGN_CD" : ORGN_CD
			}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpLayout.progressOn();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(grid_data);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							grid_data
							,  '<spring:message code="grid.noSearchData" />'
						);
					}else {
						grid_data.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(grid_data);
				erpLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	
	function isSubSearchValidate(surp_cd, custmr_nm) {
		
		$("#div_erp_sub_grid").children().each(function(index, obj){
			var display = obj.style.display;
			if(display == "block"){
				var id = obj.id;
				var grid_ID = obj.getAttribute("id");
				
				if(grid_ID == "div_erp_goods_grid"){
					console.log("서브조회 상품별 줄여보기 영역");
					searchErpSubGrid(erpGoodsGrid, surp_cd, custmr_nm);
				} else if (grid_ID == "div_erp_all_goods_grid"){
					console.log("서브조회 상품별 펼쳐보기 영역");
					searchErpSubGrid(erpAllGoodsGrid, surp_cd, custmr_nm);
				} else if (grid_ID == "div_erp_date_grid"){
					console.log("서브조회 일자별 줄여보기 영역");
					searchErpSubGrid(erpDateGrid, surp_cd, custmr_nm);
				} else if (grid_ID == "div_erp_all_date_grid"){
					console.log("서브조회 일자별 펼쳐보기 영역");
					searchErpSubGrid(erpAllDateGrid, surp_cd, custmr_nm);
				} else {
					console.log("나머지 조회 영역");
				}
				return false;
			}
		});
	}
	
	
	function searchErpSubGrid(grid_data, surp_cd, custmr_nm){
		var FROM_DATE = document.getElementById("searchDateFrom").value;
		var TO_DATE = document.getElementById("searchDateTo").value;
		var selected_pur_type = cmbPUR_TYPE.getSelectedValue();
		var PUR_CD_NM = cmbPUR_TYPE.getOption(selected_pur_type)["CMMN_DETAIL_CD_NM"];
		var ORGN_DIV_CD = cmbORGN_DIV_CD.getSelectedValue();
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		
		$.ajax({
			url: "/sis/report/dayByReport/getDayByCustmrFeeSubList.do"
			, data : {
				"FROM_DATE" : FROM_DATE
				,"TO_DATE" : TO_DATE
				, "PUR_CD_NM" : PUR_CD_NM
				, "ORGN_DIV_CD" : ORGN_DIV_CD
				, "ORGN_CD" : ORGN_CD
				, "SURP_CD" : surp_cd
			}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpLayout.progressOn();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(grid_data);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							grid_data
							,  '<spring:message code="grid.noSearchData" />'
						);
					}else {
						grid_data.parse(gridDataList, 'js');
						document.getElementById("selected_custmr").innerHTML = custmr_nm;
					}
				}
				$erp.setDhtmlXGridFooterRowCount(grid_data);
				erpLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	
	function gubunType(){
		var condition_Check = document.getElementsByName("condition");
		
		console.log("condition_Check" + condition_Check);
		
		for(var i = 0 ; i < condition_Check.length ; i++){
			if(condition_Check[i].checked == true){
				if(condition_Check[i].value == "rdo_goods"){
					document.getElementById("div_erp_date_grid").style.display = "none";
					document.getElementById("div_erp_all_date_grid").style.display = "none";
					document.getElementById("div_erp_all_goods_grid").style.display = "none";
					document.getElementById("div_erp_goods_grid").style.display = "block";
					SubGoodsGridContextMenu(erpGoodsGrid);
				} else {
					document.getElementById("div_erp_date_grid").style.display = "block";
					document.getElementById("div_erp_all_date_grid").style.display = "none";
					document.getElementById("div_erp_all_goods_grid").style.display = "none";
					document.getElementById("div_erp_goods_grid").style.display = "none";
					SubDateGridContextMenu(erpDateGrid);
 				}
			}
		}
	}
	
	function initDhtmlXCombo() {
		cmbPUR_TYPE = $erp.getDhtmlXComboCommonCode("PUR_TYPE", "PUR_TYPE", ["PUR_TYPE", "FEE"], 100, false, false, "2");
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, true, null, function(){
	         cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, null);
	         cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
	            cmbORGN_CD.unSelectOption();
	            cmbORGN_CD.clearAll();
	            $erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
	         }); 
	      });
	}
	
</script>
</head>
<body>
	<div id="div_erp_main_layout" class="div_layout_full_size div_sub_layout" style="display:none;"></div>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_data" class="table_search">
			<colgroup>
				<col width="70px">
				<col width="250px">
				<col width="70px">
				<col width="*">
			</colgroup>
			<tr>
				<th> 기    간 </th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_calendar default_date">
					 ~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_calendar default_date">
				</td>
				<th> 판매유형 </th>
				<td>
					<span id="PUR_TYPE"></span>
				</td>
				<td>
					<div id="cmbORGN_DIV_CD"></div>
				</td>
				<td>
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none">
		<div id="div_erp_part_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_all_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	
	<div id="div_erp_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none;"></div>
	<div id="div_erp_search_condition" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="40px">
				<col width="150px">
				<col width="60px">
				<col width="*">
			</colgroup>
			<tr>
				<th> 구  분</th>
				<td>
					<input type="radio" id="condition" name="condition" value="rdo_goods" onchange="gubunType()" checked>단품별
					<input type="radio" id="condition" name="condition" value="rdo_date" onchange="gubunType()">일자별
				</td>
				<th> 협력사 : </th>
				<td><span id="selected_custmr"></span></td> <!-- 조회에서 선택된 공급사명이 들어가도록  처리 -->
			</tr>	
		</table>
	</div>
	<div id="div_erp_sub_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_sub_grid" class="div_grid_full_size" style="display:none">
		<div id="div_erp_goods_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_all_goods_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_date_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_all_date_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>