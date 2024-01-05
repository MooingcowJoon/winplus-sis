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
	
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
		■ cmbSearch01 : Object / 고객 검색 조건(코너) DhtmlXCombo
		■ searchDateFrom01 : String / 기간(갑) 시작일
		■ searchDateTo01 : String / 기간(갑) 마지막일
		■ searchDateFrom02 : String / 기간(을) 시작일
		■ searchDateTo02 : String / 기간(을) 마지막일
	 --%>
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmbSearch01;
	var erpChart;
	var searchDateFrom01;
	var searchDateTo01;
	var searchDateFrom02;
	var searchDateTo02;

	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var preMonth = thisMonth-1;
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		
		document.getElementById("searchDateFrom02").value = todayDate;
		document.getElementById("searchDateTo02").value = today;
		document.getElementById("searchDateFrom01").value = todayDate;
		document.getElementById("searchDateTo01").value = today;
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin: ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4E"
			, cells: [
				{id: "a", text: "", header:false, height: 70}          
				, {id: "b", text: "", header:false, fix_size:[true, true]}          
				, {id: "c", text: "", header:false}          
				, {id: "d", text: "", header:false}          
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		erpLayout.cells("d").attachObject("div_erp_chart");
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
			if(itemId == "search_erpGrid"){
				
			} else if (itemId == "excel_erpGrid"){
				$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "일레포트-분류별비교"		
		    		, "isForm" : false
		    	});
			} else if (itemId == "print_erpGrid"){
				
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid() {
		erpGridColumns = [
			{id : "index", label:["분류명", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "index", label:["기간[갑]", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "index", label:["기간[을]", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "index", label:["증감", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "index", label:["증감율(%)", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "index", label:["일평균[갑]", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "index", label:["일평균[을]", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "index", label:["증감", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "index", label:["증감율(%)", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
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
		
		
		erpGrid.attachEvent("onRowSelect", function(rId){
			
		});
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	
	<%-- ■ erpChart 관련 Function 시작 --%>
	function initErpChart(){
		erpChart = new dhtmlXChart({
			view : "bar"
			, container : "div_erp_chart"
			, value : "#sales#"  //grid 조회 항목 중 chart로 표시할 컬럼 id로 변경필요!
			, color : "" //색을 지정하지 않으면 디폴트색(다양한 색)으로 표현됨
			, label : "#sales#" //chart 주위에 데이타를 표시할 경우 사용
			, barWidth : 35
			, border : true
			, xAxis : { //x축 설정
				template : "#분류명id"
			}
			, yAxis : { //y축 설정
				start: 0
				, end : 200000000
				, step : 4
				, template : function(obj) {
					return (obj%50,000,000?"":obj)
				}
			}
		});
		erpChart.parse(gridDataList,"js"); // searchErpGrid로 값 가져올때 gridDataList를 전역변수로 놓고 연결해줘야할듯!
	}
	
	<%-- ■ erpChart 관련 Function 끝 --%>
	
	
	
	<%-- ■ dhtmlXCombo 초기화 Function --%>
	function initDhtmlXCombo(){
		cmbSearch01 = $erp.getDhtmlXComboFromSelect("cmbSearch01", "Search01", 120);
	}
	<%-- ■ dhtmlXCombo 초기화 Function 끝 --%>
	
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
		<table  id="tb_erp_data" class="table_search">
			<colgroup>
				<col width="70px;">
			    <col width="330px;">
			    <col width="100px">
			    <col width="*">
			</colgroup>
			<tr>
				<th>상품분류</th>
				<td> 
					<input type="hidden" id="hidGOODS_CATEG_CD">
					<input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" disabled="disabled"/>
					<input type="button" id="GoodsGroup_Search" value="검 색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
					<input type="checkbox" id="Select_Goods" name="Select_Goods"/>
					<label for="Select_Goods">하위분류표시</label>
				</td>
			</tr>
		</table>
		<table id="tb_erp_data2" class="table_search">
			<colgroup>
		    	<col width="70px">
		        <col width="270px">
		        <col width="70px">
		        <col width="270px">
		        <col width="70px">
		        <col width="*">
		    </colgroup>
			<tr>
				<th> 기    간(갑)</th>
				<td>
					<input type="text" id="searchDateFrom01" name="searchDateFrom01" class="input_common input_calendar">
					 ~ <input type="text" id="searchDateTo01" name="searchDateTo01" class="input_common input_calendar">
				</td>
				<th>기    간 (을)</th>
				<td>
					<input type="text" id="searchDateFrom02" name="searchDateFrom02" class="input_common input_calendar">
					 ~ <input type="text" id="searchDateTo02" name="searchDateTo02" class="input_common input_calendar">
				</td>
				<th> 매출유형</th>
				<td>
					<select id="cmbSearch01">
						<option value="00001" selected="selected">전 체</option>
						<option value="00002" selected="selected">직영매출</option>
						<option value="00003" selected="selected">수수료매출</option>
						<option value="00004" selected="selected">임대매출</option>
						<option value="00005" selected="selected">임대제외매출</option>
						<option value="00006" selected="selected">이익액</option>
						<option value="00007" selected="selected">기초재고</option>
						<option value="00008" selected="selected">기초재고판매가액</option>
						<option value="00009" selected="selected">매입액</option>
						<option value="00010" selected="selected">매입판매가액</option>
						<option value="00011" selected="selected">기말재고</option>
						<option value="00012" selected="selected">기말재고판매가액</option>
						<option value="00013" selected="selected">장부상재고</option>
						<option value="00014" selected="selected">장부상재고판매가액</option>
						<option value="00015" selected="selected">재고로스</option>
						<option value="00016" selected="selected">재고로스판매가액</option>
						<option value="00017" selected="selected">재고평가차액</option>
						<option value="00018" selected="selected">사내소비</option>
						<option value="00019" selected="selected">사은품금액</option>
						<option value="00020" selected="selected">쿠폰할인</option>
						<option value="00021" selected="selected">특매할인</option>
						<option value="00022" selected="selected">단품별포인트발생</option>
						<option value="00023" selected="selected">사은품지급포인트</option>
						<option value="00024" selected="selected">현금지불</option>
						<option value="00025" selected="selected">카드지불</option>
						<option value="00026" selected="selected">포인트지불</option>
						<option value="00027" selected="selected">상품권지불</option>
					</select>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
	<div id="div_erp_chart"></div>
</body>
</html>