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
		LUI.exclude_auth_cd = "ALL,1,2,3,4";
		LUI.exclude_orgn_type = "OT";
	
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
		■ searchDateFrom : String / 기간(갑) 시작일
		■ searchDateTo : String / 기간(갑) 마지막일
		■ PUR_RYPE : Object / 검색조건(코너) DhtmlXCombo
	--%>
	
	var erpLayout;
	var erpRibbon;
	var erpDetailGrid;
	var erpGrid;
	var erpAllGrid;
	var erpPartGrid;
	var erpPayInfoGrid;
	var erpGridCheck = "erpAllGrid";
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmbPUR_TYPE;
	var cmbPAY_STD;
	var cmbPAY_DATE_TYPE;
	
	$(document).ready(function(){
		initErpMainLayout();
		initErpLayout();
		initErpSubLayout();
		initErpRibbon();
		initErpDetailGrid();
		initErpGrid();
		initDhtmlXCombo();
		
		GridContextMenu(erpAllGrid);
	});
	
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpMainLayout(){
		erpMainLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "", header:false}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
			]		
		});
		erpMainLayout.cells("a").attachObject("div_erp_main_layout");
		erpMainLayout.cells("a").setHeight(500);
		erpMainLayout.cells("b").attachObject("div_erp_sub_layout");
		
		erpMainLayout.setSeparatorSize(1, 0);
	}
	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: "div_erp_main_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(90);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
			erpAllGrid.setSizes();
			erpPartGrid.setSizes();
			erpPayInfoGrid.setSizes();
			erpDetailGrid.setSeizes();
		});
	}
	
	function initErpSubLayout(){
		erpSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "", header:false}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
			]		
		});
		erpSubLayout.cells("a").attachObject("div_erp_sub_content");
		erpSubLayout.cells("a").setHeight(40);
		erpSubLayout.cells("b").attachObject("div_erp_detail_grid");
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					//, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : false}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	isSearchValidate();
		    } else if(itemId == "excel_erpGrid"){
		    	var selected_grid;
		    	if(erpGridCheck == "erpAllGrid"){
		    		selected_grid = erpAllGrid;
		    	}else if(erpGridCheck == "erpPartGrid"){
		    		selected_grid = erpPartGrid;
		    	}else if(erpGridCheck == "erpPayInfoGrid"){
		    		selected_grid = erpPayInfoGrid;
		    	}
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : selected_grid
		    		, "fileName" : "일레포트-공급사별"		
		    		, "isForm" : false
		    	});
		    } else if (itemId == "print_erpGrid"){
		    	$erp.alertMessage({
					"alertMessage" : "준비중입니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false
				});
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 시작 --%>
	function initErpGrid() {
		erpGrid = {};
		
		// ======================================= 펼쳐보기 ===================================================================================================
		erpAllGridColumns = [ //id값 변경필수!
			{id : "index", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "ORGN_DIV_CD", label:["법인코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "ORGN_CD", label:["조직코드", "#rspan"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : "ORGN_CD"}
			, {id : "CUSTMR_CD", label:["협력사코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CUSTMR_NM", label:["협력사명", "#rspan"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_QTY", label:["판매수량", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_APPR_AMT", label:["판매금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_VAT", label:["판매VAT", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_TOT_AMT", label:["판매총액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_QTY", label:["구매수량", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_APPR_AMT", label:["구매금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_VAT", label:["구매VAT", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_TOT_AMT", label:["구매총액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "TOT_DC_AMT", label:["할인금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "TOT_EVENT_DC_AMT", label:["특매할인금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "STOCK_QTY", label:["기초재고량", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "NEXT_STOCK_QTY", label:["기말재고량", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
	    ];
		
		erpAllGrid = new dhtmlXGridObject({
			parent: "div_erp_all_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpAllGridColumns
		});
		
		erpAllGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpAllGrid);
		$erp.initGridComboCell(erpAllGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpAllGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpAllGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpAllGrid);
		$erp.attachDhtmlXGridFooterPaging(erpAllGrid, 100);
		
		erpAllGrid.attachEvent("onRowDblClicked", function(rId){
			var custmr_cd = erpAllGrid.cells(rId, erpAllGrid.getColIndexById("CUSTMR_CD")).getValue();
			var orgn_div_cd = erpAllGrid.cells(rId, erpAllGrid.getColIndexById("ORGN_DIV_CD")).getValue();
			var orgn_cd = erpAllGrid.cells(rId, erpAllGrid.getColIndexById("ORGN_CD")).getValue();
			searchDetailGrid(custmr_cd, orgn_div_cd, orgn_cd);
			document.getElementById("Selected_Custmr_NM").innerHTML = erpAllGrid.cells(rId, erpAllGrid.getColIndexById("CUSTMR_NM")).getValue();
		}); 
		
		erpGrid["div_erp_all_grid"] = erpAllGrid;
		
		document.getElementById("div_erp_all_grid").style.display = "block";
		
		// ======================================= 줄여보기 ===================================================================================================
			
		erpPartGridColumns = [ //id값 변경필수!
			{id : "index", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "ORGN_DIV_CD", label:["법인코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "ORGN_CD", label:["조직코드", "#rspan"], type: "combo", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : "ORGN_CD"}
			, {id : "CUSTMR_CD", label:["협력사코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CUSTMR_NM", label:["협력사명", "#rspan"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_QTY", label:["판매수량", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_APPR_AMT", label:["판매금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_VAT", label:["판매VAT", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_TOT_AMT", label:["판매총액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_QTY", label:["구매수량", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_APPR_AMT", label:["구매금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_VAT", label:["구매VAT", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_TOT_AMT", label:["구매총액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "TOT_DC_AMT", label:["할인금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "TOT_EVENT_DC_AMT", label:["특매할인금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "STOCK_QTY", label:["기초재고량", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "NEXT_STOCK_QTY", label:["기말재고량", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
	    ];
		
		erpPartGrid = new dhtmlXGridObject({
			parent: "div_erp_part_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpPartGridColumns
		});
		
		erpPartGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPartGrid);
		$erp.initGridComboCell(erpPartGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpPartGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpPartGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpPartGrid);
		$erp.attachDhtmlXGridFooterPaging(erpPartGrid, 100);
		
		erpPartGrid.attachEvent("onRowDblClicked", function(rId){
			var custmr_cd = erpPartGrid.cells(rId, erpPartGrid.getColIndexById("CUSTMR_CD")).getValue();
			var orgn_div_cd = erpPartGrid.cells(rId, erpPartGrid.getColIndexById("ORGN_DIV_CD")).getValue();
			var orgn_cd = erpPartGrid.cells(rId, erpPartGrid.getColIndexById("ORGN_CD")).getValue();
			searchDetailGrid(custmr_cd, orgn_div_cd, orgn_cd);
			$("#Selected_Custmr_NM").innerHTML = erpAllGrid.cells(rId, erpAllGrid.getColIndexById("CUSTMR_NM")).getValue();
		}); 
		
		erpGrid["div_erp_part_grid"] = erpPartGrid;
		
		// ======================================= 지불정보보기 ===================================================================================================
		
		erpPayInfoGridColumns = [ //id값 변경필수!
			{id : "index", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "ORGN_DIV_CD", label:["법인코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "ORGN_CD", label:["조직코드", "#rspan"], type: "combo", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : "ORGN_CD"}
			, {id : "CUSTMR_CD", label:["협력사코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CUSTMR_NM", label:["협력사명", "#rspan"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_QTY", label:["판매수량", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_APPR_AMT", label:["판매금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_VAT", label:["판매VAT", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_TOT_AMT", label:["판매총액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_QTY", label:["구매수량", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_APPR_AMT", label:["구매금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_VAT", label:["구매VAT", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_TOT_AMT", label:["구매총액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "TOT_DC_AMT", label:["할인금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "TOT_EVENT_DC_AMT", label:["특매할인금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "STOCK_QTY", label:["기초재고량", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "NEXT_STOCK_QTY", label:["기말재고량", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
	    ];
		
		erpPayInfoGrid = new dhtmlXGridObject({
			parent: "div_erp_pay_info_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpPayInfoGridColumns
		});
		
		erpPayInfoGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPayInfoGrid);
		$erp.initGridComboCell(erpPayInfoGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpPayInfoGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpPayInfoGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpPayInfoGrid);
		$erp.attachDhtmlXGridFooterPaging(erpPayInfoGrid, 100);
		
		erpPayInfoGrid.attachEvent("onRowDblClicked", function(rId){
			var custmr_cd = erpPayInfoGrid.cells(rId, erpPayInfoGrid.getColIndexById("CUSTMR_CD")).getValue();
			var orgn_div_cd = erpPayInfoGrid.cells(rId, erpPayInfoGrid.getColIndexById("ORGN_DIV_CD")).getValue();
			var orgn_cd = erpPayInfoGrid.cells(rId, erpPayInfoGrid.getColIndexById("ORGN_CD")).getValue();
			searchDetailGrid(custmr_cd, orgn_div_cd, orgn_cd);
			$("#Selected_Custmr_NM").innerHTML = erpAllGrid.cells(rId, erpAllGrid.getColIndexById("CUSTMR_NM")).getValue();
		}); 
		
		erpGrid["div_erp_pay_info_grid"] = erpPayInfoGrid;
		
	}
	
	function initErpDetailGrid() {
		erpGridDetailColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_DIV_CD", label:["법인구분", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "CUSTMR_CD", label:["협력사코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "STD_DATE", label:["날짜", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SLIP_APPR_AMT", label:["매입금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_APPR_AMT", label:["매출금액", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_SLIP_DIF", label:["매출입차", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
		];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridDetailColumns			
		});
		
		erpDetailGrid.enableDistributedParsing(true, 100, 50);
		erpDetailGrid.enableBlockSelection(true);
		$erp.initGridCustomCell(erpDetailGrid);
		$erp.initGridComboCell(erpDetailGrid);
		$erp.attachDhtmlXGridFooterPaging(erpDetailGrid, 100);
		$erp.attachDhtmlXGridFooterRowCount(erpDetailGrid, '<spring:message code="grid.allRowCount" />');
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	
	<%-- ■ Context_Menu 관련 Function 시작 --%>
	function GridContextMenu(SelectedErpGrid){
		var items = [
			{id: "All_Columns", 					text: "펼쳐보기"},
			{id: "Part_Columns", 					text: "줄여보기"},
			{id: "Pay_info_Columns", 				text: "지불정보보기"}
		];
		
		var onRightClick = function(id, zoneId, cas){
			var selectedRowsData;
			
			var prefixId = id.split("_____")[0];
			var value = id.split("_____")[1];
			
			/* console.log("sub_id : " + id);
			console.log("sub_prefixId : " + prefixId);
			console.log("sub_value : " + value); */
			
			if(prefixId == "All_Columns"){
				document.getElementById("div_erp_all_grid").style.display = "block";
				document.getElementById("div_erp_part_grid").style.display = "none";
				document.getElementById("div_erp_pay_info_grid").style.display = "none";
				erpGridCheck = "erpAllGrid";
				GridContextMenu(erpAllGrid);
			}else if(prefixId == "Part_Columns"){
				document.getElementById("div_erp_all_grid").style.display = "none";
				document.getElementById("div_erp_part_grid").style.display = "block";
				document.getElementById("div_erp_pay_info_grid").style.display = "none";
				erpGridCheck = "erpPartGrid";
				GridContextMenu(erpPartGrid);
			}else if(prefixId == "Pay_info_Columns"){
				document.getElementById("div_erp_all_grid").style.display = "none";
				document.getElementById("div_erp_part_grid").style.display = "none";
				document.getElementById("div_erp_pay_info_grid").style.display = "block";
				erpGridCheck = "erpPayInfoGrid";
				GridContextMenu(erpPayInfoGrid);
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
	<%-- ■ Context_Menu 관련 Function 끝 --%>
	
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbPUR_TYPE = $erp.getDhtmlXComboCommonCode("cmbPUR_TYPE", "PUR_TYPE", ["PUR_TYPE"], 100, "전체", false, "Y");
		cmbPAY_STD = $erp.getDhtmlXComboCommonCode('cmbPAY_STD','PAY_STD','PAY_STD',146, "선택", false, cmbPAY_STD);
		cmbPAY_DATE_TYPE= $erp.getDhtmlXComboCommonCode('cmbPAY_DATE_TYPE','PAY_DATE_TYPE','PAY_DATE_TYPE',146,"선택", false, cmbPAY_DATE_TYPE);

		console.log(LUI.LUI_orgn_div_cd);
		console.log(LUI.LUI_orgn_delegate_cd);
		
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, "AllOrOne", false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, LUI.LUI_orgn_cd, function(){
				if(cmbORGN_DIV_CD.getSelectedValue() == ""){
					cmbORGN_CD.unSelectOption();
					cmbORGN_CD.clearAll();
				}
			});
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				if(value != ""){
					$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
				}
			}); 
		});
	} 
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	function isSearchValidate(){
		var url_data = "";
		var param_data = {};
		
		$("#div_erp_grid").children().each(function(index, obj){
			var display = obj.style.display;
			if(display == "block"){
				var id = obj.id;
				var grid_ID = obj.getAttribute("id");
				
				if(grid_ID == "div_erp_all_grid"){
					$erp.clearDhtmlXGrid(erpDetailGrid);
					SearchErpGrid(erpAllGrid);
				} else if(grid_ID == "div_erp_part_grid"){
					$erp.clearDhtmlXGrid(erpDetailGrid);
					SearchErpGrid(erpPartGrid);
				} else if(grid_ID == "div_erp_pay_info_grid"){
					$erp.clearDhtmlXGrid(erpDetailGrid);
					SearchErpGrid(erpPayInfoGrid);
				} else {
					$erp.alertMessage({
						"alertMessage" : "조회결과 보기방식이 정해지지 않았습니다.",
						"alertType" : "alert",
						"isAjax" : false
					});
				}
			}
		});
	}
	
	<%-- SearchErpGrid 검색 Function --%>
	function SearchErpGrid(grid) {
		if(Number(($("#txtsearchDateFrom").val()).replace(/-/g,'')) > Number(($("#txtsearchDateTo").val()).replace(/-/g,''))) {
			$erp.alertMessage({
				"alertMessage" : "조회기간은 시작일이 종료일 이후일 수 없습니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		} else {
			var paramMap = $erp.dataSerialize("tb_erp_data");
			paramMap["DELIGATE_ORGN_DIV_CD"] = 'C';
			
			erpLayout.progressOn();
			$.ajax({
				url : "/sis/report/MonByReport/getMonByCustmrList.do"
				,data : paramMap
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					erpLayout.progressOff();
					var gridDataList = data.gridDataList;
					$erp.clearDhtmlXGrid(grid);
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								grid
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							//grid.parse(gridDataList, 'js');
							erpAllGrid.parse(gridDataList, 'js');
							erpPartGrid.parse(gridDataList, 'js');
							erpPayInfoGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(grid);
				}, error : function(jqXHR, textStatus, errorThrown){
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	function searchDetailGrid(custmr_cd, orgn_div_cd, orgn_cd){
		var DetailParamMap = {
			"searchDateFrom" : ($("#txtsearchDateFrom").val()).replace(/-/g,'')
			,"searchDateTo" : ($("#txtsearchDateTo").val()).replace(/-/g,'')
			, "CUSTMR_CD" : custmr_cd
			, "ORGN_DIV_CD" : orgn_div_cd
			, "ORGN_CD" : orgn_cd
		};
		
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/report/MonByReport/getMonByCustmrDetailList.do"
			,data : DetailParamMap
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				var gridDataList = data.gridDataList;
				$erp.clearDhtmlXGrid(erpDetailGrid);
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
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
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
	function openGoodsCategoryTreePopup() {
		var onClick = function(id) {
			document.getElementById("txtGRUP_CD").value = id;
			document.getElementById("txtGRUP_NM").value = this.getItemText(id);
			
			$erp.closePopup2("openGoodsCategoryTreePopup");
		}
		$erp.openGoodsCategoryTreePopup(onClick);
	}
	
</script>
</head>
<body>
	<div id="div_erp_main_layout" class="div_layout_full_size" style="display:none">
		<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
			<table id="tb_erp_data" class="table_search">
				<colgroup>
					<col width="70px;">
					<col width="230px;">
					<col width="70px;">
					<col width="120px;">
					<col width="70px;">
					<col width="100px;">
					<col width="70px;">
					<col width="150px;">
					<col width="*">
				</colgroup>
				<tr>
					<th>법인구분</th>
					<td>
						<div id="cmbORGN_DIV_CD"></div>
					</td>
					<th>조직명</th>
					<td colspan="5">
						<div id="cmbORGN_CD"></div>
					</td>
				</tr>
				<tr>
					<th>상품분류</th>
					<td colspan="8">
						<input type="hidden" id="txtGRUP_CD" value="ALL">
						<input type="text" id="txtGRUP_NM" name="GoodsGroup_Name" readonly="readonly" disabled="disabled" value="전체분류"/>
						<input type="button" id="GoodsGroup_Search" value="검 색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
					</td>
				</tr>
				<tr>
					<th>기      간</th>
					<td>
						<input type="text" id="txtsearchDateFrom" name="searchDateFrom" class="input_common input_calendar_ym default_date" data-position="-1">
						 ~ <input type="text" id="txtsearchDateTo" name="searchDateTo" class="input_common input_calendar_ym default_date" data-position="">
					</td>
					<th>매입유형</th>
					<td>
						<div id="cmbPUR_TYPE"></div>
					</td>
					<th>결제기준 </th>
					<td colspan="5">
						<div id="cmbPAY_STD" style="float: left;margin-right : 5px;"></div>
						<div id="cmbPAY_DATE_TYPE"></div>
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_grid" class="div_grid_full_size" style="display:none">
			<div id="div_erp_all_grid" class="div_grid_full_size" style="display:none"></div>
			<div id="div_erp_part_grid" class="div_grid_full_size" style="display:none"></div>
			<div id="div_erp_pay_info_grid" class="div_grid_full_size" style="display:none"></div>
		</div>
	</div>
	<div id="div_erp_sub_layout"  class="div_layout_full_size" style="display:none">
		<div id="div_erp_sub_content" class="div_common_contents_full_size" style="display:none">
			<table id="tb_erp_custmr_info" class="table_search">
				<colgroup>
					<col width="70px;">
					<col width="*">
				</colgroup>
				<tr>
					<th>협력사명 : </th>
					<td>
						<span id="Selected_Custmr_NM" style="color: blue; font-weight: bold;"></span>
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_detail_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>