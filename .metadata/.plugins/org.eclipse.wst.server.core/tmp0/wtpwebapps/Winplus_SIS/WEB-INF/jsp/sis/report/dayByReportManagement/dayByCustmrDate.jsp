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
		■ cmenu : Object / context-menu 우클릭메뉴 dhtmlXMenuObject
		■ searchDateFrom : String / 기간(갑) 시작일
		■ searchDateTo : String / 기간(갑) 마지막일
		■ cmbSearch01 : Object / 검색조건(코너) DhtmlXCombo
		■ cmbSearch02 : Object / 검색조건(그룹유형) DhtmlXCombo
		■ cmbSearch03 : Object / 검색조건(그룹) DhtmlXCombo
	--%>
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmenu;
	var searchDateFrom;
	var searchDateTo;
	var cmbSearch01;
	var cmbSearch02;
	var cmbSearch03;
	var SelectedType;
	var PUR_TYPE;
	
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
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, height:72}
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
		    		, "fileName" : "일레포트-공급사별일자별"		
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
			{id : "index", label:["공급사코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "date", label:["공급사명", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_code", label:["일자(변동값)", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_spec", label:["합계", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["평균", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["표준", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
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
			//현재선택된 그룹의 depth확인 후 대분류이면 더블클릭시, 해당 대분류내 중분류 조회내역, 중분류였으면 더블클릭시, 해당 중분류내 소분류 조회내역 보여짐처리
		}); 
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	
	<%-- ■ Context_Menu 관련 Function 시작 --%>
	function initCMenu(){ //우클릭메뉴 설정
		cmenu = new dhtmlXMenuObject();
		cmenu.renderAsContextMenu();
		cmenu.loadStruct({items:[{id:"all_columns", text:"펼쳐보기"},{id:"summary_columns", text:"줄여보기"},{id:"pay_info", text:"지불정보보기"}]});
		cmenu
		cmenu.attachEvent("onClick", onButtonClick);
		
	}
	
	function onButtonClick(menuitemId) { //우클릭 메뉴 클릭시, 기능설정
		switch(menuitemId) {
			case "all_columns":
				alert("펼쳐보기 클릭!");
				break;
			case "summary_columns" :
				alert("줄여보기 클릭!");
				break;
			case "pay_info" :
				alert("지불정보보기 클릭!");
				break;
		}
	}
	<%-- ■ Context_Menu 관련 Function 끝 --%>
	
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbSearch01 = $erp.getDhtmlXComboFromSelect("cmbSearch01", "Search", 120);
		PUR_TYPE = $erp.getDhtmlXComboCommonCode("PUR_TYPE", "PUR_TYPE", ["PUR_TYPE", "FEE"], 100, "전체", false, "Y");
		//cmbSearch02 = $erp.getDhtmlXComboFromSelect("cmbSearch02", "Search02", 120);
		//cmbSearch03 = $erp.getDhtmlXComboFromSelect("cmbSearch03", "Search03", 120);
	} 
	
	function changeGroupSelect() {
		
		var Group_basic = ["전체"];
		var Group_A = ["전체","월3회마감(농산)","착불/선불","주마감","마감일지정결제"];
		var Group_B = ["전체","말일","1일","5일","10일","15일","20일","25일"];
		var Group_C = ["전체","기본계좌"];
		var SubGroup = [];
		var target = document.getElementById("cmbSearch03");
		
		var SelectedValue = document.getElementById("cmbSearch02").value;
		if(SelectedValue != "00001") {
			document.getElementById("cmbSearch03").removeAttribute("disabled");
		} else {
			document.getElementById("cmbSearch03").disabled = "disabled";
		}
		
		if(SelectedValue == "00001") {
			SubGroup = Group_basic;
		} else if(SelectedValue == "00002"){
			SubGroup = Group_A;
		} else if(SelectedValue == "00003") {
			SubGroup = Group_B;
		} else if(SelectedValue == "00004") {
			SubGroup = Group_C;
		}
		
		target.options.length = 0;
		
		for( GroupName in SubGroup){
			var opt = document.createElement("option");
			opt.value = SubGroup[GroupName];
			opt.innerHTML = SubGroup[GroupName];
			target.appendChild(opt);
		}
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- SearchErpGrid  관련 Function --%>	
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
		<table id="tb_erp_data" class="table_search">
			<colgroup>
				<col width="70px;">
				<col width="270px;">
				<col width="70px;">
				<col width="270px;">
				<col width="*">
			</colgroup>
			<tr>
				<th>상품분류</th>
				<td>
					<input type="hidden" id="hidGOODS_CATEG_CD">
					<input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" disabled="disabled"/>
					<input type="button" id="GoodsGroup_Search" value="검 색" class="input_common_button" onclick="openGoodsCategoryTreePopup()"/>
				</td>
				<th> 기    간 </th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
					 ~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
				</td>
			</tr>
		</table>
		<table  id="tb_erp_data2" class="table_search">
			<colgroup>
				<col width="150px;">
				<col width="70px;">
				<col width="130px;">
				<col width="70px;">
				<col width="110px;">
				<col width="70px;">
				<col width="250px;">
				<col width="*">
			</colgroup>
			<tr>
				<td style="padding-left: 15px;">
					<select id="cmbSearch01">
						<option value="01" selected="selected">총매출액</option>
						<option value="02" selected="selected">직영매출</option>
						<option value="03" selected="selected">수수료매출</option>
						<option value="04" selected="selected">임대매출</option>
						<option value="05" selected="selected">임대제외매출</option>
						<option value="06" selected="selected">이익액</option>
						<option value="07" selected="selected">기초재고</option>
						<option value="08" selected="selected">기초재고판매가액</option>
						<option value="09" selected="selected">매입액</option>
						<option value="10" selected="selected">매입판매가액</option>
						<option value="11" selected="selected">기말재고</option>
						<option value="12" selected="selected">기말재고판매가액</option>
						<option value="13" selected="selected">장부상재고</option>
						<option value="14" selected="selected">장부상재고판매가액</option>
						<option value="15" selected="selected">재고로스</option>
						<option value="16" selected="selected">재고로스판매가액</option>
						<option value="17" selected="selected">재고평가차액</option>
						<option value="18" selected="selected">사내소비</option>
						<option value="19" selected="selected">사은품금액</option>
						<option value="20" selected="selected">쿠폰할인</option>
						<option value="21" selected="selected">특매할인</option>
						<option value="22" selected="selected">단품별포인트발생</option>
						<option value="23" selected="selected">사은품지급포인트</option>
						<option value="24" selected="selected">현금지불</option>
						<option value="25" selected="selected">카드지불</option>
						<option value="26" selected="selected">포인트지불</option>
						<option value="27" selected="selected">상품권지불</option>
					</select>
				</td>
				<th>매입유형</th>
				<td>
					<div id="PUR_TYPE"></div>
				</td>
				<th>그룹유형</th>
				<td>
					<select id="cmbSearch02" onchange="changeGroupSelect();">
						<option value="00001" selected="selected">전체</option>
						<option value="00002">결제유형</option>
						<option value="00003">결제일</option>
						<option value="00004">입출금계좌</option>
					</select>
				</td>
				<th>그     룹</th>
				<td>
					<select id="cmbSearch03" disabled="disabled">
						<option id="all_opt">전체</option>
					</select>
					<input type="checkbox" id="Select_Goods" name="Select_Goods"/>
					<label for="Select_Goods">제외</label>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>