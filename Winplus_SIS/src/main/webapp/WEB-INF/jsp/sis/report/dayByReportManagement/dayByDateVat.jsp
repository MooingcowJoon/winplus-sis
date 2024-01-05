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
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
		■ cmenu : Object / context-menu 우클릭메뉴 dhtmlXMenuObject
		■ searchDateFrom : String / 기간(갑) 시작일
		■ searchDateTo : String / 기간(갑) 마지막일
		■ cmbSearch : Object / 검색조건(코너) DhtmlXCombo
	--%>

	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpAllGrid;
	var erpPartGrid;
	var erpTaxFreeGrid;
	var erpTaxGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmenu;
	var searchDateFrom;
	var searchDateTo;
	var cmbSearch;
	var cmbPUR_TYPE;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var grup_cd;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		
		document.getElementById("searchDateFrom").value=todayDate;
		document.getElementById("searchDateTo").value=today;
		GridContextMenu(erpAllGrid);
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false}
				, {id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드영역", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(65);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpAllGrid.setSizes();
			erpPartGrid.setSizes();
			erpTaxFreeGrid.setSizes();
			erpTaxGrid.setSizes();
		});
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
					, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : false}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	if(document.getElementById("hidGOODS_CATEG_CD").value == ""){
	        		  $erp.alertMessage({
	        	            "alertMessage" : "error.sis.goods.search.grup_nm.empty"
	        	            , "alertCode" : "-1"
	        	            , "alertType" : "error"
	        	         });   
	        	  }
	        	  else{
	        		  isSearchValidate(document.getElementById("hidGOODS_CATEG_CD").value);
	        	  }
		    } else if(itemId == "excel_erpGrid"){
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "일레포트-일자별과면세"		
		    		, "isForm" : false
		    	});
		    } else if (itemId == "print_erpGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid() {
		
		erpGrid = {};
		
		//======================= 펼쳐보기 ====================================================
		erpAllGridColumns = [ //id값 변경필수!
			
			{id : "index", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "OBJT_DATE", label:["구분", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GRUP_CD", label:["분류코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "FEE_SALE_AMT", label:["매출액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "TOP_CATEG", label:["대분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
	        , {id : "MID_CATEG", label:["중분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
	        , {id : "BOT_CATEG", label:["소분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "SALE_FREE_GOODS_CASH_AMT", label:["현금면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_CASH_AMT", label:["현금과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_GOODS_CASH_AMT", label:["현급합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CASH_AMT_RATIO", label:["비율", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_CARD_AMT", label:["카드면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_CARD_AMT", label:["카드과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_GOODS_CARD_AMT", label:["카드합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CARD_AMT_RATIO", label:["비율", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_POINT_AMT", label:["포인트면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_POINT_AMT", label:["포인트과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_GIFT_AMT", label:["상품권면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_GIFT_AMT", label:["상품권과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_ETC_AMT", label:["기타면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_ETC_AMT", label:["기타과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_GOODS_ETC_AMT", label:["기타합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_AMT_TOT", label:["면세합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_AMT_TOT", label:["과세합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CASH_RECP_FREE_GOODS_AMT", label:["현영면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CASH_RECP_TAXA_GOODS_AMT", label:["현영과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CASH_RECP_GOODS_AMT", label:["현영합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
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
		
		
		erpGrid["div_erp_all_grid"] = erpAllGrid;
		
		document.getElementById("div_erp_all_grid").style.display = "block";
		
		//======================= 줄여보기 ====================================================
		erpPartGridColumns = [ //id값 변경필수!
			{id : "index", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "OBJT_DATE", label:["구분", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GRUP_CD", label:["분류코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "TOP_CATEG", label:["대분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
	        , {id : "MID_CATEG", label:["중분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
	        , {id : "BOT_CATEG", label:["소분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "FEE_SALE_AMT", label:["매출액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_CASH_AMT", label:["현금면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_CASH_AMT", label:["현금과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_CARD_AMT", label:["카드면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_CARD_AMT", label:["카드과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_ETC_AMT", label:["기타면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_ETC_AMT", label:["기타과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_AMT_TOT", label:["면세합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_AMT_TOT", label:["과세합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CASH_RECP_FREE_GOODS_AMT", label:["현영면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CASH_RECP_TAXA_GOODS_AMT", label:["현영과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
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
		
		
		erpGrid["div_erp_part_grid"] = erpPartGrid;
		
		//======================= 면세보기 ====================================================
		
		erpTaxFreeGridColumns = [ //id값 변경필수!
			 {id : "index", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "GRUP_CD", label:["분류코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
		    , {id : "OBJT_DATE", label:["구분", "#rspan"], type:"ro", width:"120", sort : "str", align : "left" , isHidden : false, isEssentioal : false}
			, {id : "FEE_SALE_AMT", label:["매출액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "TOP_CATEG", label:["대분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
	        , {id : "MID_CATEG", label:["중분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
	        , {id : "BOT_CATEG", label:["소분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "SALE_FREE_GOODS_CASH_AMT", label:["현금면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_CARD_AMT", label:["카드면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_POINT_AMT", label:["포인트면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_GIFT_AMT", label:["상품권면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_AMT_TOT", label:["기타면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_FREE_GOODS_AMT_TOT", label:["면세합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CASH_RECP_FREE_GOODS_AMT", label:["현영면세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
	    ];
		
		erpTaxFreeGrid = new dhtmlXGridObject({
			parent: "div_erp_tax_free_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpTaxFreeGridColumns
		});
		
		erpTaxFreeGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpTaxFreeGrid);
		$erp.initGridComboCell(erpTaxFreeGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpTaxFreeGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpTaxFreeGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpTaxFreeGrid);
		$erp.attachDhtmlXGridFooterPaging(erpTaxFreeGrid, 100);
		
		
		erpGrid["div_erp_tax_free_grid"] = erpTaxFreeGrid;
			
		//======================= 과세보기 ====================================================
		erpTaxGridColumns = [ //id값 변경필수!
			 {id : "index", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GRUP_CD", label:["분류코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "OBJT_DATE", label:["구분", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "FEE_SALE_AMT", label:["매출액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "TOP_CATEG", label:["대분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
	        , {id : "MID_CATEG", label:["중분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
	        , {id : "BOT_CATEG", label:["소분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "SALE_TAXA_GOODS_CASH_AMT", label:["현금과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_CARD_AMT", label:["카드과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_POINT_AMT", label:["포인트과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_GIFT_AMT", label:["상품권과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_ETC_AMT", label:["기타과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_TAXA_GOODS_AMT_TOT", label:["과세합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CASH_RECP_TAXA_GOODS_AMT", label:["현영과세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
	    ];
		
		erpTaxGrid = new dhtmlXGridObject({
			parent: "div_erp_tax_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpTaxGridColumns
		});
		
		erpTaxGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpTaxGrid);
		$erp.initGridComboCell(erpTaxGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpTaxGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpTaxGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpTaxGrid);
		$erp.attachDhtmlXGridFooterPaging(erpTaxGrid, 100);
		
		
		erpGrid["div_erp_tax_grid"] = erpTaxGrid;
			
			
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	
	<%-- ■ Context_Menu 관련 Function 시작 --%>
	function GridContextMenu(SelectedErpGrid){
		var items = [
			{id: "All_Columns", 					text: "펼쳐보기"},
			{id: "Part_Columns", 					text: "줄여보기"},
			{id: "Tax_Free_Columns", 				text: "면세보기"},
			{id: "Tax_Columns", 					text: "과세보기"},
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
				document.getElementById("div_erp_tax_free_grid").style.display = "none";
				document.getElementById("div_erp_tax_grid").style.display = "none";
				GridContextMenu(erpAllGrid);
			}else if(prefixId == "Part_Columns"){
				document.getElementById("div_erp_part_grid").style.display = "block";
				document.getElementById("div_erp_all_grid").style.display = "none";
				document.getElementById("div_erp_tax_free_grid").style.display = "none";
				document.getElementById("div_erp_tax_grid").style.display = "none";
				GridContextMenu(erpPartGrid);
			}else if(prefixId == "Tax_Free_Columns"){
				document.getElementById("div_erp_tax_free_grid").style.display = "block";
				document.getElementById("div_erp_all_grid").style.display = "none";
				document.getElementById("div_erp_part_grid").style.display = "none";
				document.getElementById("div_erp_tax_grid").style.display = "none";
				GridContextMenu(erpTaxFreeGrid);
			}else if(prefixId == "Tax_Columns"){
				document.getElementById("div_erp_tax_grid").style.display = "block";
				document.getElementById("div_erp_tax_free_grid").style.display = "none";
				document.getElementById("div_erp_all_grid").style.display = "none";
				document.getElementById("div_erp_part_grid").style.display = "none";
				GridContextMenu(erpTaxGrid);
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
		cmbSearch = $erp.getDhtmlXComboFromSelect("cmbSearch", "Search", 120);
		cmbPUR_TYPE = $erp.getDhtmlXComboCommonCode("PUR_TYPE", "PUR_TYPE", ["PUR_TYPE", "", "CATG"], 100, "--전체--" , false, false, "1");
		 cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, true, null, function(){
	         cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, null);
	         cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
	            cmbORGN_CD.unSelectOption();
	            cmbORGN_CD.clearAll();
	            $erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
	         }); 
	      });
	} 
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ SearchErpGrid 관련 Function 시작 --%>
	
	 function isSearchValidate(grup_cd) {
		   
			$("#div_erp_grid").children().each(function(index, obj){
				var display = obj.style.display;
				if(display == "block"){
					var id = obj.id;
					var grid_ID = obj.getAttribute("id");
					
					if(grid_ID == "div_erp_part_grid"){
						console.log("조회영역 줄여보기");
						SearchErpGrid(erpPartGrid, grup_cd);
					} else if (grid_ID == "div_erp_all_grid"){
						console.log("조회영역 펼쳐보기");
						SearchErpGrid(erpAllGrid, grup_cd);
					} else if (grid_ID == "div_erp_tax_free_grid"){
						console.log("조회영역 면세보기")
						SearchErpGrid(erpTaxFreeGrid, grup_cd);
					} else if (grid_ID == "div_erp_tax_grid"){
						console.log("조회영역 과세보기")
						SearchErpGrid(erpTaxGrid, grup_cd);
					} else {
							console.log("나머지 조회 영역");
						}
					return false;
				}
			});
		}
	   
	function SearchErpGrid(grid_data, grup_cd) {
		var SEARCH_FROM_DATE = document.getElementById("searchDateFrom").value;
		var SEARCH_TO_DATE = document.getElementById("searchDateTo").value;
		var selected_pur_type = cmbPUR_TYPE.getSelectedValue();
		var PUR_CD_NM = cmbPUR_TYPE.getOption(selected_pur_type)["CMMN_DETAIL_CD_NM"];
		var ORGN_DIV_CD = cmbORGN_DIV_CD.getSelectedValue();
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		var GRUP_CD = grup_cd;
		
		
		 $.ajax({
				url: "/sis/report/dayByReport/dayByDateVatList.do"
				, data : {
					"SEARCH_FROM_DATE" : SEARCH_FROM_DATE
					, "SEARCH_TO_DATE" :SEARCH_TO_DATE
					, "ORGN_DIV_CD" : ORGN_DIV_CD
					, "ORGN_CD" : ORGN_CD
					, "PUR_CD_NM" : PUR_CD_NM
					, "GRUP_CD" : GRUP_CD
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOn();
					if(data.isEroor) {
						$erp.ajaxErrorMessage(data);
					}else{
						$erp.clearDhtmlXGrid(grid_data);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
									grid_data
									, '<spring:message code="grid.noSearchData" />'
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
		
		
	<%-- ■ SearchErpGrid 관련 Function 끝 --%>
	
	
	<%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
	function openGoodsCategoryTreePopup() {
		var onClick = function(id) {
			document.getElementById("hidGOODS_CATEG_CD").value = id;
			document.getElementById("GoodsGroup_Name").value = this.getItemText(id);
			
			$erp.closePopup2("openGoodsCategoryTreePopup");
		}
		$erp.openGoodsCategoryTreePopup(onClick);
	}
	
	
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_data" class="table_search">
			<colgroup>
				<col width="70px;">
				<col width="430px;">
				<col width="150px;">
				<col width="220px;">
				<col width="70px">
			</colgroup>
			<tr>
				<th>상품분류</th>
				<td>
					<input type="hidden" id="hidGOODS_CATEG_CD">
					<input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" disabled="disabled"/>
					<input type="button" id="GoodsGroup_Search" value="검 색" class="input_common_button" onclick="openGoodsCategoryTreePopup()"/>
				</td>
				<th> 법인구분</th>
				<td>
					<div id="cmbORGN_DIV_CD"></div>
				</td>
				<th>조직명</th>
				<td>
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
		</table>
		<table id="tb_erp_data2" class="table_search">
			<colgroup>
				<col width="70px;">
				<col width="250px;">
				<col width="70px;">
				<col width="*">
			</colgroup>
			<tr>
				<th> 기    간 </th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
					 ~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
				</td>
				<th> 판매유형 </th>
				<td>
					<span id="PUR_TYPE"></span>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none">
		<div id="div_erp_all_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_part_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_tax_free_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_tax_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>