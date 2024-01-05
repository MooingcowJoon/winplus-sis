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
	/* 월_분류내월별  */
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
		■ cmenu : Object / 우클릭메뉴
		■ cmbSearch01 : Object / 검색조건(코너) DhtmlXCombo
		■ searchDateFrom : String / 기간 시작일
		■ searchDateTo : String / 기간 마지막일
	 --%>
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmenu;
	var cmbSearch01;
	var searchDateFrom;
	var searchDateTo;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initCMenu();
		initErpGrid();
		initDhtmlXCombo();
		
		document.getElementById("searchDateFrom").value=todayDate;
		document.getElementById("searchDateTo").value=today;
	});
	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "월_분류내월별 조회", header:true, height: 98}
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
		    	SearchErpGrid();
		    } else if(itemId == "excel_erpGrid"){
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "월레포트-분류내월별"		
		    		, "isForm" : false
		    	});
		    } else if (itemId == "print_erpGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	function initErpGrid() {
		erpGridColumns = [ //id값 변경필수!
	            {id : "index", label:["구분", "#rspan"], type: "ro", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}              
				, {id : "date", label:["기초재고액", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
				, {id : "goods_code", label:["기초판매가액", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_spec", label:["매입액", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
				, {id : "goods_bcode", label:["매입판매가액", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_bcode", label:["총매출", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
				, {id : "goods_bcode", label:["직영", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_bcode", label:["수수료", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_bcode", label:["임대", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_bcode", label:["임대제외", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_bcode", label:["기말재고액", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
				, {id : "goods_bcode", label:["기말판매가액", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_bcode", label:["매출원가", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
				, {id : "goods_bcode", label:["이익액", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
				, {id : "goods_bcode", label:["이익율", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
				, {id : "goods_bcode", label:["장부재고액", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
				, {id : "goods_bcode", label:["재고로스액", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
				, {id : "goods_bcode", label:["로스판매가액", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_bcode", label:["재고평가차액", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
				, {id : "goods_bcode", label:["사내소비", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_bcode", label:["사은품", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_bcode", label:["쿠폰", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_bcode", label:["특매", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_bcode", label:["사은품지급포인트", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "goods_bcode", label:["상품별포인트", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : true, isEssential : false}
	    ];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
		});
		
		erpGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
		
		erpGrid.enableContextMenu(cmenu); // erpGrid에 우클릭메뉴 연결(조회결과가 있을때만 우클릭메뉴 사용됨)
		erpGrid.attachEvent("onRowSelect", function(rId){
			
		}); 
	}
	
	function initCMenu(){ //우클릭메뉴 설정
		cmenu = new dhtmlXMenuObject();
		cmenu.renderAsContextMenu();
		cmenu.loadStruct({items:[{id:"Goods_count", text:"수량별 보기"},{id:"Input_Ouput", text:"매입/매출별 보기"},{id:"Pay_Type", text:"결제유형별 보기"}]});
		cmenu
		cmenu.attachEvent("onClick", onButtonClick);
		
	}
	
	function onButtonClick(menuitemId) { //우클릭 메뉴 클릭시, 기능설정
		switch(menuitemId) {
			case "Goods_count":
				alert("수량별보기 클릭!");
				break;
			case "Input_Ouput" :
				alert("매입/매출 클릭!");
				break;
			case "Pay_Type" :
				alert("결제유형별보기 클릭!");
				break;
		}
	}
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbSearch01 = $erp.getDhtmlXComboFromSelect("cmbSearch01", "Search01", 80);
	} 
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
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
		        <col width="250px">
		        <col width="70px">
		        <col width="150px">
		        <col width="*">
		    </colgroup>
			<tr>
				<th>기         간</th>
				<td> 
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
					 ~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
				</td>
				<th>코          너</th>
				<td>
					<select id="cmbSearch01">
						<option value="00001" selected="selected">전체</option>
						<option value="00002">직영</option>
						<option value="00003">수수료</option>
						<option value="00004">임대</option>
						<option value="00005">직영+수수료</option>
					</select>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>