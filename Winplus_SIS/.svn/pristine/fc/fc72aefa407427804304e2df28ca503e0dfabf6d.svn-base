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
	/* 월_분류별월별  */
	
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
		■ cmenu : Object / 우클릭메뉴
		■ searchDateFrom : String / 기간 시작일
		■ searchDateTo : String / 기간 마지막일
		■ cmbSearch01 : Object / 검색조건(코너) DhtmlXCombo
		■ cmbSearch02 : Object / 검색조건(상품) DhtmlXCombo	
	 --%>
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var searchDateFrom;
	var searchDateTo;
	var cmbSearch01; 
	var cmbSearch02; 
	
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
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, height:65}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
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
		    	SearchErpGrid();
		    } else if(itemId == "excel_erpGrid"){
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "월레포트-분류별월별"		
		    		, "isForm" : false
		    	});
		    } else if (itemId == "print_erpGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid() {
		erpGridColumns = [ //id값 변경필수!
			{id : "index", label:["분류명", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "date", label:["월", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "date", label:["합계", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "date", label:["평균", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "date", label:["표준편차", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
        ];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
		});
		
		erpGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
		
		erpGrid.attachEvent("onRowSelect", function(rId){
			
		}); 
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	
	<%-- dhtmlXCombo 초기화 Function --%>
	function initDhtmlXCombo(){
		cmbSearch01 = $erp.getDhtmlXComboFromSelect("cmbSearch01", "Search01", 120);
	} 
	
	
	function SearchErpGrid() {
		searchDateFrom = $("#searchDateFrom").val();
		searchDateTo = $("#searchDateTo").val();
	}
	
	<%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
	function openGoodsCategoryTreePopup() {
		var onClick = function(id) {
			document.getElementById("hidGOODS_CATEG_CD").value = id;
			document.getElementById("GoodsGroup_Name").value = this.getItemText(id);
			
			$erp.closePopup();
		}
		$erp.openGoodsCategoryTreePopup(onClick);
	}
	
	
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="70px;">
			    <col width="330px;">
			    <col width="*">
			</colgroup>
			<tr>
				<th>상품분류</th>
				<td>   
					<input type="hidden" id="hidGOODS_CATEG_CD">
					<input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" disabled="disabled"/>
					<input type="button" id="GoodsGroup_Search" value="검 색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
				</td>
			</tr>
		</table>
		<table class="table_search">
			<colgroup>
		    	<col width="70px">
		        <col width="240px">
		        <col width="70px">
		        <col width="120px">
		        <col width="*">
		    </colgroup>
			<tr>
				<th> 기    간 </th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
					 ~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
				</td>
				<th>매출유형</th>
				<td>
					<select id="cmbSearch01">
						<option value="00001" selected="selected">전체</option>
						<option value="00002">직영매출</option>
						<option value="00003">수수료매출</option>
						<option value="00004">임대매출</option>
						<option value="00005">임대제외매출</option>
						<option value="00006">이익액</option>
						<option value="00007">기초재고</option>
						<option value="00008">기초재고판매가액</option>
						<option value="00009">매입액</option>
						<option value="00010">매입판매가액</option>
						<option value="00011">기말재고</option>
						<option value="00012">기말재고판매가액</option>
						<option value="00013">장부상재고</option>
						<option value="00014">장부상재고판매가액</option>
						<option value="00015">재고로스</option>
						<option value="00016">재고로스판매가액</option>
						<option value="00017">재고평가차액</option>
						<option value="00018">사내소비</option>
						<option value="00019">사은품금액</option>
						<option value="00020">쿠폰할인</option>
						<option value="00021">특매할인</option>
						<option value="00022">단품별포인트발생</option>
						<option value="00023">사은품지급포인트</option>
					</select>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>