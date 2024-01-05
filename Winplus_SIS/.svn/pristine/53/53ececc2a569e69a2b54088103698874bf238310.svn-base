<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js?ver=33"></script>
<script type="text/javascript">

	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');

	var erpLayout;
	var erpMemLayout;
	var erpMainLayout;
	var erpSubLayout;
	var erpMemRibbon;
	var erpRibbon;
	var erpMemGrid;
	var erpGrid;
	var erpSubGrid;
	var erpMemGridColumns;
	var erpGridColumns;
	var erpSubGridColumns;
	var paramGridData = {};
	var paramData = {};
	
	var cmbORGN_CD;
	var cmbDEAL_TYPE;
	var ord_dateList="";
	var ord_cdList="";
	var loginUser = "${empSessionDto.emp_no}"
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		
		initErpLayout();
		
		initErpMemLayout();
		initErpMainLayout();
		initErpSubLayout();
		
		initErpMemRibbon();
		initErpRibbon();
		
		initErpMemGrid();
		initErpGrid();
		initErpSubGrid();
		
		initDhtmlXCombo();
		
		document.getElementById("SEARCH_FROM_DATE").value=todayDate;
		document.getElementById("SEARCH_TO_DATE").value=today;
	});

	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3L"
			, cells : [
				{id: "a", text: "회원조회", header: false, width: 300}
				, {id : "b", text: "판매내역", header: false}
				, {id : "c", text: "판매내역(디테일)", header: false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_mem_layout");
		erpLayout.cells("b").attachObject("div_erp_main_layout");
		erpLayout.cells("b").setHeight(430);
		erpLayout.cells("c").attachObject("div_erp_sub_layout");
		
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpMainLayout.setSizes();
			erpMemGrid.setSizes();
			erpGrid.setSizes();
			erpSubLayout.setSizes();
			erpSubGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpMemLayout 관련 Function 시작 --%>
	<%-- erpMemLayout 초기화 Function --%>
	function initErpMemLayout(){
		erpMemLayout = new dhtmlXLayoutObject({
			parent: "div_erp_mem_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건", header:false , fix_size:[true, true]}
				, {id: "b", text: "리본", header:false , fix_size:[true, true]}
				, {id: "c", text: "그리드", header:false , fix_size:[true, true]}
			]
		});
		erpMemLayout.cells("a").attachObject("div_erp_mem_table");
		erpMemLayout.cells("a").setHeight(75);
		erpMemLayout.cells("b").attachObject("div_erp_mem_ribbon");
		erpMemLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpMemLayout.cells("c").attachObject("div_erp_mem_grid");
	}
	<%-- ■ erpMemLayout 관련 Function 끝 --%>
	
	<%-- ■ erpMemRibbon 관련 Function 시작 --%>
	function initErpMemRibbon() {
		erpMemRibbon = new dhtmlXRibbon({
			parent : "div_erp_mem_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
				]}
			]
		});
		
		erpMemRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid") {
				searchErpMemGrid();
			} 
		});
	}
	<%-- ■ erpMemRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpMemGrid 관련 Function 시작 --%>
	function initErpMemGrid(){
		erpMemGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "35", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "UNIQUE_MEM_NM", label : ["상호명[회원명]", "#rspan"], type : "ro", width : "170", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "MEM_NO", label : ["회원번호", "#rspan"], type : "ro", width : "180", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : false}
			, {id : "ORGN_CD", label : ["직영점", "#rspan"], type : "combo", width : "73", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false, commonCode : ["ORGN_CD"]}
			, {id : "LOAN_CD", label:["구분", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : true}
		];
		
		erpMemGrid = new dhtmlXGridObject({
			parent: "div_erp_mem_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpMemGridColumns
		});
		
		erpMemGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpMemGrid);
		$erp.initGridComboCell(erpMemGrid);
		$erp.attachDhtmlXGridFooterPaging(erpMemGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpMemGrid, '<spring:message code="grid.allRowCount" />');
		
		erpMemGridDataProcessor = new dataProcessor();
		erpMemGridDataProcessor.init(erpMemGrid);
		erpMemGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpMemGrid);
		
		erpMemGrid.attachEvent("onRowDblClicked", function(rId){
			
			paramGridData["MEM_NO"] = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("MEM_NO")).getValue();
			paramGridData["UNIQUE_MEM_NM"] = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("UNIQUE_MEM_NM")).getValue();
			paramGridData["ORGN_CD"] = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("ORGN_CD")).getValue();
			paramGridData["LOAN_CD"] = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("LOAN_CD")).getValue();
			
			searchErpGrid(paramGridData);
		});
		
		
	}
	<%-- ■ erpMemGrid 관련 Function 끝 --%>
	
	<%-- ■ erpMemGrid 조회 Function --%>
	function searchErpMemGrid(){
		var MEM_NM = $("#txtMEM_NM").val();
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		var MEM_STATE = $('input[name=txtMEM_STATE]:checked').length;
		
		paramData["MEM_NM"] = $("#txtMEM_NM").val();
		paramData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		paramData["MEM_STATE"] = $('input[name=txtMEM_STATE]:checked').length;
		
		erpMemLayout.progressOn();
		$.ajax({
			url : "/common/popup/getSearchMember.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpMemLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpMemGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpMemGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpMemGrid.parse(gridDataList, 'js');	
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpMemGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpMemLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpMemGrid 조회 Function 끝--%>
	
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
		erpMainLayout.cells("a").setHeight(75);
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
					, {id : "add_erpGrid", type : "button", text:'결제 입력', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
					,{id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					,{id : "print_erpGrid",  type : "button", text:'판매내역 출력', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid") {
				searchErpGrid(paramGridData);
			}else if (itemId == "add_erpGrid"){
				var check_row_len = document.getElementById("txtUNIQUE_MEM_NM").value;
				if(check_row_len == ""){
					$erp.alertMessage({
						"alertMessage" : "회원 선택 후 이용가능합니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
				}else{
					openTrustSalesPopup();
				}
			}else if (itemId == "excel_erpGrid"){
				$erp.exportGridToExcel({
					"grid" : erpGrid
					, "fileName" : "판매내역조회(회원)"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			} else if (itemId == "print_erpGrid"){
				var check = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
				if(check ==""){
					$erp.alertMessage({
						"alertMessage" : "1개 이상의 거래건을 선택 후 이용가능합니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
				}else{
					printGrid();
				}
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>

	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid(){
		erpGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ro", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "ORD_CD", label:["주문번호", "#rspan"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "REG_TYPE", label:["전표상태", "#rspan"], type: "combo", width: "80", sort : "str", align : "left", isHidden : false, isEssential : true, isDisabled : true, commonCode : ["SALE_REG_TYPE"]}
			, {id : "ORD_DATE", label:["거래일자", "#rspan"], type: "ro", width: "120", sort : "date", align : "left", isHidden : false, isEssential : true}
			, {id : "PAY_TRUST", label:["외상매출", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "SUM_AMT", label:["결제금액", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "DISC_AMT", label:["할인금액", "#rspan" ], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "LOSS_AMT", label:["손실금액", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "OUT_AMT", label:["미수잔액", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "MEMO", label:["비고", "#rspan"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ORGN_CD", label:["직영점", "#rspan"], type: "ro", width: "180", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "CASH_AMT", label:["현금금액", "#rspan" ], type: "ron", width: "80", sort : "int", align : "right", isHidden : true, isEssential : true, numberFormat : "0,000"}
			, {id : "CARD_AMT", label:["카드금액", "#rspan" ], type: "ron", width: "80", sort : "int", align : "right", isHidden : true, isEssential : true, numberFormat : "0,000"}
			, {id : "ACNT_AMT", label:["계좌금액", "#rspan" ], type: "ron", width: "80", sort : "int", align : "right", isHidden : true, isEssential : true, numberFormat : "0,000"}
			, {id : "PAY_DATE", label:["날짜", "#rspan" ], type: "ro", width: "80", sort : "str", align : "right", isHidden : true, isEssential : true}
			, {id : "PAY_HOUR", label:["시", "#rspan" ], type: "ro", width: "80", sort : "str", align : "right", isHidden : true, isEssential : true}
			, {id : "PAY_MINUTE", label:["분", "#rspan" ], type: "ro", width: "80", sort : "str", align : "right", isHidden : true, isEssential : true}
			, {id : "TRUST_SEQ", label:["순서", "#rspan" ], type: "ro", width: "80", sort : "str", align : "right", isHidden : true, isEssential : true}
			, {id : "LOAN_SEQ", label:["순서", "#rspan" ], type: "ro", width: "80", sort : "str", align : "right", isHidden : true, isEssential : true}
			];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_main_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		
		erpGrid.attachEvent("onKeyPress",onKeyPressed);
		var text_style = "text-align:right; font-weight:bold; font-style:normal";
		var tot_style = "text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;";
		erpGrid.attachFooter("합계,#cspan,#cspan,#cspan,<div id='HEAD_PAY_TRUST'>0</div>,<div id='HEAD_SUM_AMT'>0</div>,<div id='HEAD_DISC_AMT'>0</div>,<div id='HEAD_LOSS_AMT'>0</div>,<div id='HEAD_OUT_AMT'>0</div>",[tot_style,"","","",text_style,text_style,text_style,text_style,text_style]);
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
		
		erpGrid.attachEvent("onRowDblClicked", function(rId){
			var REG_TYPE = erpGrid.cells(rId, erpGrid.getColIndexById("REG_TYPE")).getValue();
			if(REG_TYPE != "외상결제"){
				paramGridData["ORD_CD"] = erpGrid.cells(rId, erpGrid.getColIndexById("ORD_CD")).getValue();
				searchErpSubGrid(paramGridData);
			}else{
				openAddTrustSalesPopup();
			}
			
		});
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	function calculateHeaderFooterValues(stage){
		if(stage && stage!=2)
			return true;
		var nrQ = document.getElementById("HEAD_PAY_TRUST");
			nrQ.innerHTML = moneyType(sumHeaderColumn(erpGrid.getColIndexById("PAY_TRUST")));
		var nrS = document.getElementById("HEAD_SUM_AMT");
			nrS.innerHTML = moneyType(sumHeaderColumn(erpGrid.getColIndexById("SUM_AMT")));
		var nrW = document.getElementById("HEAD_DISC_AMT");
			nrW.innerHTML = moneyType(sumHeaderColumn(erpGrid.getColIndexById("DISC_AMT")));
		var nrR = document.getElementById("HEAD_LOSS_AMT");
			nrR.innerHTML = moneyType(sumHeaderColumn(erpGrid.getColIndexById("LOSS_AMT")));
		var nrT = document.getElementById("HEAD_OUT_AMT");
			nrT.innerHTML = moneyType(sumHeaderColumn(erpGrid.getColIndexById("OUT_AMT")));	
			
			return true;
	}
	
	function sumHeaderColumn(ind){
		var RowIds = "";
		RowIds = erpGrid.getAllRowIds();
		var arrayRowIds = [];
		arrayRowIds = RowIds.split(",");
		var out = 0;
		for(var i = 0 ;i < arrayRowIds.length ; i++){
			out+= parseFloat(erpGrid.cells(arrayRowIds[i],ind).getValue());
		}
		return out;
	}
	
	function headerColumn(ind){
		var RowIds = "";
		RowIds = erpGrid.getAllRowIds();
		var arrayRowIds = [];
		arrayRowIds = RowIds.split(",");
		var rowNum = arrayRowIds[arrayRowIds.length -1];
		var out = 0;
		
		out = parseFloat(erpGrid.cells(rowNum,ind).getValue());
		return out
	}
	
	<%-- ■ erpGrid 조회 Function --%>
	function searchErpGrid(paramGridData){
		var UNIQUE_MEM_NM = paramGridData["UNIQUE_MEM_NM"];
		document.getElementById("txtUNIQUE_MEM_NM").value = UNIQUE_MEM_NM;

		paramGridData["SEARCH_FROM_DATE"] = document.getElementById("SEARCH_FROM_DATE").value;
		paramGridData["SEARCH_TO_DATE"] = document.getElementById("SEARCH_TO_DATE").value;
		paramGridData["VIEW_TYPE"] = $('input[name="txtVIEW_TYPE"]:checked').val();
		paramGridData["DEAL_TYPE"] = cmbDEAL_TYPE.getSelectedValue();

		erpMainLayout.progressOn();
		$.ajax({
				url: "/sis/sales/getSalesByMemList.do"
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
							
							var allRowIds = erpGrid.getAllRowIds();
							var allRowArray = allRowIds.split(",");
							for(var i in gridDataList){
								if(gridDataList[i].REG_TYPE != "외상결제"){
									erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("CHECK"),"ch");
								}
							}
							calculateHeaderFooterValues();
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
	<%-- ■ erpGrid 조회 Function 끝--%>
	
	<%-- ■ erpSubLayout 관련 Function 시작 --%>
	<%-- erpSubLayout 초기화 Function --%>
	function initErpSubLayout() {
		erpSubLayout = new dhtmlXLayoutObject({
			parent : "div_erp_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "거래내역", header: false , fix_size:[true, true]}
				, {id: "b", text: "그리드", header: false , fix_size:[true, true]}
			]
		});
		erpSubLayout.cells("a").attachObject("div_erp_sub_table");
		erpSubLayout.cells("a").setHeight(38);
		erpSubLayout.cells("b").attachObject("div_erp_sub_grid");
	}
	<%-- ■ erpSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpSubGrid 관련 Function 시작 --%>	
	<%-- erpSubGrid 초기화 Function --%>	
	function initErpSubGrid(){
		erpSubGridColumns = [
			{id : "NO", label:["순번", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "360", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "130", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "SALE_PRICE", label:["단가", "#rspan"], type: "ron", width: "90", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "SALE_QTY", label:["수량", "#rspan"], type: "ro", width: "90", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "DC_AMT", label:["할인", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "SALE_SUM_PRICE", label:["금액", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "POS_NO", label:["계산대", "#rspan"], type: "ro", width: "90", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "RESP_USER", label:["계산원", "#rspan"], type: "ro", width: "90", sort : "str", align : "left", isHidden : false, isEssential : true}
			
		];
		
		erpSubGrid = new dhtmlXGridObject({
			parent: "div_erp_sub_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpSubGridColumns
		});
	
		erpSubGrid.attachEvent("onKeyPress",onDetailKeyPressed);
		var text_style = "text-align:right; font-weight:bold; font-style:normal";
		var tot_style = "text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;";
		erpSubGrid.attachFooter("합계,#cspan,#cspan,#cspan,<div id='SUB_SALE_QTY'>0</div>,<div id='SUB_DC_AMT'>0</div>,<div id='SUB_SALE_SUM_PRICE'>0</div>",[tot_style,"","","",text_style,text_style,text_style]);
		erpSubGrid.enableBlockSelection();
		erpSubGrid.enableDistributedParsing(true, 100, 50);
		erpSubGrid.enableAccessKeyMap(true);
		erpSubGrid.enableColumnMove(true);
		$erp.initGridCustomCell(erpSubGrid);
		$erp.initGridComboCell(erpSubGrid);
		$erp.attachDhtmlXGridFooterPaging(erpSubGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpSubGrid, '<spring:message code="grid.allRowCount" />');
		
		erpSubGridDataProcessor = new dataProcessor();
		erpSubGridDataProcessor.init(erpSubGrid);
		erpSubGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpSubGrid);
		
	}
	<%-- ■ erpSubGrid 관련 Function 끝 --%>
	
	function calculateFooterValues(stage){
		if(stage && stage!=2)
			return true;
		var nrQ = document.getElementById("SUB_SALE_QTY");
			nrQ.innerHTML = moneyType(sumColumn(erpSubGrid.getColIndexById("SALE_QTY")));
		var nrS = document.getElementById("SUB_DC_AMT");
			nrS.innerHTML = moneyType(sumColumn(erpSubGrid.getColIndexById("DC_AMT")));
		var nrW = document.getElementById("SUB_SALE_SUM_PRICE");
			nrW.innerHTML = moneyType(sumColumn(erpSubGrid.getColIndexById("SALE_SUM_PRICE")));
			return true;
	}
	
	function moneyType(amt){
		return amt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function sumColumn(ind){
		var RowIds = "";
		RowIds = erpSubGrid.getAllRowIds();
		var arrayRowIds = [];
		arrayRowIds = RowIds.split(",");
		var out = 0;
		for(var i = 0 ;i < arrayRowIds.length ; i++){
			out+= parseFloat(erpSubGrid.cells(arrayRowIds[i],ind).getValue());
		}
		return out;
	}
	
	<%-- ■ erpSubGrid 조회 Function 시작 --%>
	function searchErpSubGrid(paramGridData){
		var ORD_CD = paramGridData["ORD_CD"];
		document.getElementById("txtORD_CD").value = ORD_CD;
		
		erpSubLayout.progressOn();
		$.ajax({
			url : "/sis/sales/getSalesByMemSubList.do"
			,data : paramGridData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
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
						calculateFooterValues();
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpSubGrid);
				erpSubLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpSubLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		
	}
	<%-- ■ erpSubGrid 조회 Function 끝 --%>
	
	<%-- dhtmlxCombo 초기화 Function 시작--%>
	function initDhtmlXCombo(){
		var searchable = 1;
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",")
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
			searchable = 2;
			}
		}
		if(searchable == 1 ){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 110, false, LUI.LUI_orgn_cd);
		}else if(searchable == 2){
			cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK"], 90, null, false, LUI.LUI_orgn_cd);
		}
		
		cmbDEAL_TYPE = new dhtmlXCombo("cmbDEAL_TYPE");
		cmbDEAL_TYPE.setSize(80);
		cmbDEAL_TYPE.readonly(true);
		cmbDEAL_TYPE.addOption([
			{value: "0", text: "전체거래" ,selected: true}
			,{value: "1", text: "외상거래"}
		]);
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
	
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
	
	<%-- ■ onDetailKeyPressed 이종상품그룹 상품 목록Grid_Keypressed Function 시작 --%>
	function onDetailKeyPressed(code,ctrl,shift){
			if(code==67&&ctrl){
				erpSubGrid.setCSVDelimiter("\t");
				erpSubGrid.copyBlockToClipboard();
			}
			if(code==86&&ctrl){
				erpSubGrid.setCSVDelimiter("\t");
				erpSubGrid.pasteBlockFromClipboard();
			}
		return true;
	}
	<%-- ■ onDetailKeyPressed 이종상품그룹 상품 목록Grid_Keypressed Function 끝--%>
	
	<%-- openTrustSalesPopup 외상매출 결제 팝업 열림 Function --%>
	function openTrustSalesPopup(){
		var rId = erpMemGrid.getSelectedRowId();
		var UNIQUE_MEM_NM = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("UNIQUE_MEM_NM")).getValue();
		var MEM_NO = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("MEM_NO")).getValue();
		var ORGN_CD = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("ORGN_CD")).getValue();
		var LOAN_CD = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("LOAN_CD")).getValue();
		var OBJ_CD = ORGN_CD + "_" + MEM_NO;
		
		var onClickAddData = function(SUM_AMT, LOSS_AMT, MEMO, PAY_DATE, PAY_HOUR, PAY_MINUTE, CASH_AMT, CARD_AMT, ACNT_AMT, OBJ_CD, LOAN_CD){
			paramData={};
			paramData["SUM_AMT"] = SUM_AMT;
			paramData["LOSS_AMT"] = LOSS_AMT;
			paramData["MEMO"] = MEMO;
			paramData["PAY_DATE"] = PAY_DATE;
			paramData["PAY_HOUR"] = PAY_HOUR;
			paramData["PAY_MINUTE"] = PAY_MINUTE;
			paramData["OBJ_CD"] = OBJ_CD;
			paramData["CASH_AMT"] = CASH_AMT;
			paramData["CARD_AMT"] = CARD_AMT;
			paramData["ACNT_AMT"] = ACNT_AMT;
			paramData["LOAN_CD"] = LOAN_CD;
			console.log(paramData);
			$erp.confirmMessage({
				"alertMessage" : "외상결제 입력이 저장됩니다.<br>진행하시겠습니까?",
				"alertType" : "alert",
				"isAjax" : false,
				"alertCallbackFn" : function confirmAgain(){
					var url = "/sis/sales/saveTrustSales.do";
					var send_data = paramData;
					var if_success = function(data){
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else{
							$erp.alertMessage({
								"alertMessage" : "저장이 완료되었습니다.",
								"alertCode" : null,
								"alertType" : "alert",
								"isAjax" : false
							});
							var rId = erpMemGrid.getSelectedRowId();
							paramGridData["MEM_NO"] = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("MEM_NO")).getValue();
							paramGridData["ORGN_CD"] = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("ORGN_CD")).getValue();
							
							var ORD_DATE = PAY_DATE + " "+ PAY_HOUR + ":" + PAY_MINUTE;
							var uid = 0;
							var uid = erpGrid.uid();
							erpGrid.addRow(uid);
							
							erpGrid.cells(uid, erpGrid.getColIndexById("ORD_CD")).setValue("외상결제");
							erpGrid.cells(uid, erpGrid.getColIndexById("REG_TYPE")).setValue("외상결제");
							erpGrid.cells(uid, erpGrid.getColIndexById("PAY_TRUST")).setValue("0");
							erpGrid.cells(uid, erpGrid.getColIndexById("DISC_AMT")).setValue("0");
							erpGrid.cells(uid, erpGrid.getColIndexById("LOSS_AMT")).setValue(LOSS_AMT);
							erpGrid.cells(uid, erpGrid.getColIndexById("MEMO")).setValue(MEMO + ORD_DATE + " 결제");
							
							$erp.setDhtmlXGridFooterRowCount(erpGrid);
							searchErpGrid(paramGridData);
						}
					}
					var if_error = function(){}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
				}
			});
			$erp.closePopup2("openTrustSalesPopup");
		}
		$erp.openTrustSalesPopup(onClickAddData, UNIQUE_MEM_NM, OBJ_CD, LOAN_CD);
	}
	
	<%-- openTrustSalesPopup 판매내역 출력 Function --%>
	function printGrid(){
		var SEARCH_FROM_DATE = document.getElementById("SEARCH_FROM_DATE").value;
		var SEARCH_TO_DATE = document.getElementById("SEARCH_TO_DATE").value;
		
		var rId = erpMemGrid.getSelectedRowId();
		var MEM_NO = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("MEM_NO")).getValue();
		var ORGN_CD = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("ORGN_CD")).getValue();
		var UNIQUE_MEM_NM = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("UNIQUE_MEM_NM")).getValue();
		
		var check = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
		var checkList = check.split(',');
		
		for(var i = 0 ; i < checkList.length ; i ++) {
			if(i != checkList.length - 1) {
				ord_dateList += erpGrid.cells(checkList[i], erpGrid.getColIndexById("ORD_DATE")).getValue() + ",";
				ord_cdList += erpGrid.cells(checkList[i], erpGrid.getColIndexById("ORD_CD")).getValue() + ",";
			} else {
				ord_dateList += erpGrid.cells(checkList[i], erpGrid.getColIndexById("ORD_DATE")).getValue();
				ord_cdList += erpGrid.cells(checkList[i], erpGrid.getColIndexById("ORD_CD")).getValue();
			}
		}
		
		var paramInfo = {
				"ORD_DATE" : ord_dateList
				, "ORD_CD" : ord_cdList
				, "mrdPath" : "supply_upload"
				, "ORGN_CD" : ORGN_CD
				, "MEM_NO" : MEM_NO
				, "UNIQUE_MEM_NM" : UNIQUE_MEM_NM
				, "SEARCH_FROM_DATE" : SEARCH_FROM_DATE
				, "SEARCH_TO_DATE" : SEARCH_TO_DATE
		};
		
		console.log(paramInfo);
		var approvalURL = $CROWNIX_REPORT.openSalesByMemberSheet("", paramInfo, "판매내역(회원)", "");
		var popObj = window.open(approvalURL, "salesByMember_popup", "width=750,height=950");
		
		ord_dateList = "";
		ord_cdList = "";
	}
	
	function openAddTrustSalesPopup(){
		var rId = erpMemGrid.getSelectedRowId();
		var rowId = erpGrid.getSelectedRowId();
		
		var ORGN_CD = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("ORGN_CD")).getValue();
		var MEM_NO = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("MEM_NO")).getValue();
		var OBJ_CD = ORGN_CD + "_" + MEM_NO;
		var memo = erpGrid.cells(rowId, erpGrid.getColIndexById("MEMO")).getValue();
		var MEMO = memo.slice(0,memo.length-22);
		
		var paramMap = new Object();
		paramMap.UNIQUE_MEM_NM = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("UNIQUE_MEM_NM")).getValue();
		paramMap.LOAN_CD = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("LOAN_CD")).getValue();
		paramMap.OBJ_CD = OBJ_CD;
		paramMap.SUM_AMT = erpGrid.cells(rowId, erpGrid.getColIndexById("SUM_AMT")).getValue();
		paramMap.LOSS_AMT = erpGrid.cells(rowId, erpGrid.getColIndexById("LOSS_AMT")).getValue();
		paramMap.MEMO = MEMO;
		paramMap.PAY_DATE = erpGrid.cells(rowId, erpGrid.getColIndexById("PAY_DATE")).getValue();
		paramMap.PAY_HOUR = erpGrid.cells(rowId, erpGrid.getColIndexById("PAY_HOUR")).getValue();
		paramMap.PAY_MINUTE = erpGrid.cells(rowId, erpGrid.getColIndexById("PAY_MINUTE")).getValue();
		paramMap.CASH_AMT = erpGrid.cells(rowId, erpGrid.getColIndexById("CASH_AMT")).getValue();
		paramMap.CARD_AMT = erpGrid.cells(rowId, erpGrid.getColIndexById("CARD_AMT")).getValue();
		paramMap.ACNT_AMT = erpGrid.cells(rowId, erpGrid.getColIndexById("ACNT_AMT")).getValue();
		paramMap.TRUST_SEQ = erpGrid.cells(rowId, erpGrid.getColIndexById("TRUST_SEQ")).getValue();
		paramMap.LOAN_SEQ = erpGrid.cells(rowId, erpGrid.getColIndexById("LOAN_SEQ")).getValue();
		paramMap.RESP_USER = loginUser;
		
		
		var onClickAddData = function(SUM_AMT, LOSS_AMT, MEMO, PAY_DATE, PAY_HOUR, PAY_MINUTE, CASH_AMT, CARD_AMT, ACNT_AMT, OBJ_CD, LOAN_CD, TRUST_SEQ, LOAN_SEQ){
			paramData={};
			paramData["SUM_AMT"] = SUM_AMT;
			paramData["LOSS_AMT"] = LOSS_AMT;
			paramData["MEMO"] = MEMO;
			paramData["PAY_DATE"] = PAY_DATE;
			paramData["PAY_HOUR"] = PAY_HOUR;
			paramData["PAY_MINUTE"] = PAY_MINUTE;
			paramData["OBJ_CD"] = OBJ_CD;
			paramData["CASH_AMT"] = CASH_AMT;
			paramData["CARD_AMT"] = CARD_AMT;
			paramData["ACNT_AMT"] = ACNT_AMT;
			paramData["LOAN_CD"] = LOAN_CD;
			paramData["TRUST_SEQ"] = TRUST_SEQ;
			paramData["LOAN_SEQ"] = LOAN_SEQ;
			
			var url = "/sis/sales/saveUpdateTrustSales.do";
			var send_data = paramData;
			var if_success = function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else{
					$erp.alertMessage({
						"alertMessage" : "수정이 완료되었습니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
					var rId = erpMemGrid.getSelectedRowId();
					paramGridData["MEM_NO"] = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("MEM_NO")).getValue();
					paramGridData["ORGN_CD"] = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("ORGN_CD")).getValue();
				
					$erp.setDhtmlXGridFooterRowCount(erpGrid);
					searchErpGrid(paramGridData);
				}
			}
			var if_error = function(){}
					
			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
			$erp.closePopup2("openAddTrustSalesPopup");
		}
		
		var onClickDelData = function(OBJ_CD, LOAN_CD, TRUST_SEQ, LOAN_SEQ){
			paramData={};
			paramData["OBJ_CD"] = OBJ_CD;
			paramData["LOAN_CD"] = LOAN_CD;
			paramData["TRUST_SEQ"] = TRUST_SEQ;
			paramData["LOAN_SEQ"] = LOAN_SEQ;
			
			var url = "/sis/sales/saveDeleteTrustSales.do";
			var send_data = paramData;
			var if_success = function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else{
					$erp.alertMessage({
						"alertMessage" : "삭제가 완료되었습니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
					var rId = erpMemGrid.getSelectedRowId();
					paramGridData["MEM_NO"] = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("MEM_NO")).getValue();
					paramGridData["ORGN_CD"] = erpMemGrid.cells(rId, erpMemGrid.getColIndexById("ORGN_CD")).getValue();
				
					$erp.setDhtmlXGridFooterRowCount(erpGrid);
					searchErpGrid(paramGridData);
				}
			}
			var if_error = function(){}
					
			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
			$erp.closePopup2("openAddTrustSalesPopup");
		}
		$erp.openAddTrustSalesPopup(onClickAddData, onClickDelData, {"trustInfo" : JSON.stringify(paramMap)});
	}
</script>
</head>
<body>
	<div id="div_erp_mem_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_mem_table" class="samyang_div" style="display:none;">
			<table id = "tb_search_01" class = "table_search">
				<colgroup>
					<col width="55px"/>
					<col width="85px"/>
					<col width="75px"/>
				</colgroup>
				<tr>
					<th style="padding-top: 10px; padding-right: 10px;">조직명</th>
					<td>
						<div id = cmbORGN_CD></div>
					</td>
				</tr>
				<tr>
					<th style="padding-right: 10px;">검색어</th>
					<td>
						<input type ="text" id ="txtMEM_NM" name="txtMEM_NM" class="input_common" maxlength="10" style= "width:80px;" autoComplete="off" onkeydown="$erp.onEnterKeyDown(event, searchErpMemGrid);">
					</td>
					<td>
						<input type ="checkbox" id="txtMEM_STATE" name="txtMEM_STATE">무효포함
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_mem_ribbon" class="samyang_div" style="display:none;"></div>
		<div id="div_erp_mem_grid" class="samyang_div" style="display:none;"></div>
	</div>
	<div id="div_erp_main_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_main_table" class="samyang_div" style="display:none">
			<table id = "tb_search_02" class = "table_search">
			<colgroup>
				<col width="70px;">
				<col width="100px;">
				<col width="15px">
				<col width="150px">
				<col width="150px">
				<col width="*px">
			</colgroup>
				<tr>
					<th style="padding-top: 7px;">기간</th>
					<td>
						<input type="text" id="SEARCH_FROM_DATE" name="SEARCH_FROM_DATE" class="input_common input_calendar">
					</td>
					<td>~</td>
					<td>
						<input type="text" id="SEARCH_TO_DATE" name="SEARCH_TO_DATE" class="input_common input_calendar">
					</td>
					<td>
<!-- 						<input type="radio" id="CHIT" name="txtVIEW_TYPE" onchange="" value="CHIT" checked/> -->
<!-- 						<label for="txtVIEW_TYPE" style="padding-right:5px;">전표별</label> -->
<!-- 						<input type="radio" id="DATE" name="txtVIEW_TYPE" onchange="" value="DATE"/> -->
<!-- 						<label for="txtVIEW_TYPE">날짜별</label> -->
					</td>
				</tr>
			</table>
			<table id = "tb_search_03" class = "table_search">
			<colgroup>
				<col width="70px;">
				<col width="210px;">
				<col width="112px">
				<col width="150px">
				<col width="30px">
				<col width="*px">
			</colgroup>
				<tr>
					<th>회원 :</th>
					<td>
						<input type="text" id="txtUNIQUE_MEM_NM" name="txtUNIQUE_MEM_NM" class="input_common" readonly="readonly" style= "background-color: #F2F2F2; width:200px;"/>
					</td>
					<th>거래유형</th>
					<td>
						<div id = "cmbDEAL_TYPE"></div>
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_main_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_main_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	<div id="div_erp_sub_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_sub_table" class="samyang_div" style="display:none">
			<table id = "tb_search_04" class = "table_search">
				<colgroup>
					<col width="90px;">
					<col width="210px;">
					<col width="*px;">
				</colgroup>
				<tr>
					<th>주문번호 : </th>
					<td>
						<input type="text" id="txtORD_CD" name="txtORD_CD" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 200px;">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_sub_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_sub_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>