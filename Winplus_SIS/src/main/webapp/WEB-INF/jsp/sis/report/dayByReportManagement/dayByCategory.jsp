<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js"></script>
<script type="text/javascript">
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2,3,4";
	LUI.exclude_orgn_type = "OT";
	console.log(LUI);
	
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
		■ searchDateFrom : String / 기간 시작일
		■ searchDateTo : String / 기간 마지막일
	 --%>
	
	var erpGrid;
	var erpLayout;
	var erpRibbon;
	var erpAllGrid;
	var erpPartGrid;
	var erpPayInfoGrid;
	var erpAllGridDataProcessor;
	var erpPartGridDataProcessor;
	var erpPayInfoGridDataProcessor;
	var searchDateFrom;
	var searchDateTo;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		initErpGrid();
		//GridContextMenu(erpAllGrid);
		
		$erp.asyncObjAllOnCreated(function(){
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "일_분류별 조회", header:false}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(95);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpAllGrid.setSizes();
			erpPartGrid.setSizes();
			erpPayInfoGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	function initErpGrid(){
		erpGrid = {};
		
		//==================================펼쳐보기===============================================
		var grid_Columns_1 = [ 
			{id : "No", label:["순서", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false}              
			, {id : "GRUP_NM", label:["구분", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false}
			, {id : "GRUP_CD", label:["그룹코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true}
			, {id : "TOT_DC_AMT", label:["할인금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "TOT_EVENT_DC_AMT", label:["특매할인금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_QTY", label:["판매수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_APPR_AMT", label:["판매금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_VAT", label:["판매VAT", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_TOT_AMT", label:["판매총액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_QTY", label:["구매수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_APPR_AMT", label:["구매금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_VAT", label:["구매VAT", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_TOT_AMT", label:["구매총액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
        ];
		
		erpAllGrid = new dhtmlXGridObject({
			parent: "div_erp_all_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : grid_Columns_1
		});
		
		$erp.attachDhtmlXGridFooterSummary(erpAllGrid,["TOT_DC_AMT","TOT_EVENT_DC_AMT","SALE_QTY","SALE_APPR_AMT","SALE_VAT","SALE_TOT_AMT","SLIP_QTY","SLIP_APPR_AMT","SLIP_VAT","SLIP_TOT_AMT"], 1, "합계");
		erpAllGridDataProcessor = $erp.initGrid(erpAllGrid);

		erpAllGrid.attachEvent("onRowDblClicked",function(rId, cInd){
			$("#GoodsGroup_Name").val(erpAllGrid.cells(rId, erpAllGrid.getColIndexById("GRUP_NM")).getValue());
			$("#hidGOODS_CATEG_CD").val(erpAllGrid.cells(rId, erpAllGrid.getColIndexById("GRUP_CD")).getValue());
			isSearchValidate();
		});
		
		erpGrid["div_erp_all_grid"] = erpAllGrid;
		
		document.getElementById("div_erp_all_grid").style.display = "block";
		
		
		//==================================줄여보기===============================================
		var grid_Columns_2 = [
			{id : "No", label:["순서", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false}              
			, {id : "GRUP_NM", label:["구분", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false}
			, {id : "GRUP_CD", label:["그룹코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true}
			, {id : "TOT_DC_AMT", label:["할인금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "TOT_EVENT_DC_AMT", label:["특매할인금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_QTY", label:["판매수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_APPR_AMT", label:["판매금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_VAT", label:["판매VAT", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_TOT_AMT", label:["판매총액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_QTY", label:["구매수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_APPR_AMT", label:["구매금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_VAT", label:["구매VAT", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_TOT_AMT", label:["구매총액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
		];
		
		erpPartGrid = new dhtmlXGridObject({
			parent: "div_erp_part_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : grid_Columns_2
		});
		
		$erp.attachDhtmlXGridFooterSummary(erpPartGrid,["TOT_DC_AMT","TOT_EVENT_DC_AMT","SALE_QTY","SALE_APPR_AMT","SALE_VAT","SALE_TOT_AMT","SLIP_QTY","SLIP_APPR_AMT","SLIP_VAT","SLIP_TOT_AMT"], 1, "합계");
		erpPartGridDataProcessor = $erp.initGrid(erpPartGrid);
		
		erpPartGrid.attachEvent("onRowDblClicked",function(rId, cInd){
			$("#GoodsGroup_Name").val(erpPartGrid.cells(rId, erpPartGrid.getColIndexById("GRUP_NM")).getValue());
			$("#hidGOODS_CATEG_CD").val(erpPartGrid.cells(rId, erpPartGrid.getColIndexById("GRUP_CD")).getValue());
			isSearchValidate();
		});
		
		erpGrid["div_erp_part_grid"] = erpPartGrid;
		
		
		//==================================지불정보===============================================
		var grid_Columns_3 = [
			{id : "No", label:["순서", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false}              
			, {id : "GRUP_NM", label:["구분", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false}
			, {id : "GRUP_CD", label:["그룹코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true}
			, {id : "TOT_DC_AMT", label:["할인금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "TOT_EVENT_DC_AMT", label:["특매할인금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_QTY", label:["판매수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_APPR_AMT", label:["판매금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_VAT", label:["판매VAT", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_TOT_AMT", label:["판매총액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_QTY", label:["구매수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_APPR_AMT", label:["구매금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_VAT", label:["구매VAT", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_TOT_AMT", label:["구매총액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
		];
		erpPayInfoGrid = new dhtmlXGridObject({
			parent: "div_erp_pay_info_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : grid_Columns_3
		});
		
		$erp.attachDhtmlXGridFooterSummary(erpPayInfoGrid,["TOT_DC_AMT","TOT_EVENT_DC_AMT","SALE_QTY","SALE_APPR_AMT","SALE_VAT","SALE_TOT_AMT","SLIP_QTY","SLIP_APPR_AMT","SLIP_VAT","SLIP_TOT_AMT"], 1, "합계");
		erpPayInfoGridDataProcessor = $erp.initGrid(erpPayInfoGrid);
		
		erpPayInfoGrid.attachEvent("onRowDblClicked",function(rId, cInd){
			$("#GoodsGroup_Name").val(erpPayInfoGrid.cells(rId, erpPayInfoGrid.getColIndexById("GRUP_NM")).getValue());
			$("#hidGOODS_CATEG_CD").val(erpPayInfoGrid.cells(rId, erpPayInfoGrid.getColIndexById("GRUP_CD")).getValue());
			isSearchValidate();
		});
		
		erpGrid["div_erp_pay_info_grid"] = erpPayInfoGrid;
		
	}
	
	function GridContextMenu(SelectedErpGrid){
		var items = [
			{id: "All_Columns", 					text: "펼쳐보기"},
			{id: "Part_Columns", 					text: "줄여보기"},
			{id: "Pay_Info", 						text: "지불정보보기"}
		];
		
		var onRightClick = function(id, zoneId, cas){
			var selectedRowsData;
			
			var prefixId = id.split("_____")[0];
			var value = id.split("_____")[1];
			
			if(prefixId == "All_Columns"){
				document.getElementById("div_erp_all_grid").style.display = "block";
				document.getElementById("div_erp_part_grid").style.display = "none";
				document.getElementById("div_erp_pay_info_grid").style.display = "none";
				GridContextMenu(erpAllGrid);
				SearchErpGrid(erpAllGrid);
			}else if(prefixId == "Part_Columns"){
				document.getElementById("div_erp_all_grid").style.display = "none";
				document.getElementById("div_erp_part_grid").style.display = "block";
				document.getElementById("div_erp_pay_info_grid").style.display = "none";
				GridContextMenu(erpPartGrid);
				SearchErpGrid(erpPartGrid);
			}else if(prefixId == "Pay_Info"){
				document.getElementById("div_erp_all_grid").style.display = "none";
				document.getElementById("div_erp_part_grid").style.display = "none";
				document.getElementById("div_erp_pay_info_grid").style.display = "block";
				GridContextMenu(erpPayInfoGrid);
				SearchErpGrid(erpPayInfoGrid);
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
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : erpAllGrid
		    		, "fileName" : "일레포트-분류별"
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
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbPUR_TYPE = $erp.getDhtmlXComboCommonCode("cmbPUR_TYPE", "PUR_TYPE", "PUR_TYPE", 150, "모두조회", false);
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
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
	
	<%-- 조회 관련 function --%>
	
	function isSearchValidate(){
		var url_data = "";
		var param_data = {};
		
		$("#div_erp_grid").children().each(function(index, obj){
			var display = obj.style.display;
			if(display == "block"){
				var id = obj.id;
				var grid_ID = obj.getAttribute("id");
				
				if(grid_ID == "div_erp_all_grid"){
					SearchErpGrid(erpAllGrid);
				} else if(grid_ID == "div_erp_part_grid"){
					SearchErpGrid(erpPartGrid);
				} else if(grid_ID == "div_erp_pay_info_grid"){
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
	
	function SearchErpGrid(selectedGrid) {
		searchDateFrom = $("#searchDateFrom").val();
		searchDateTo = $("#searchDateTo").val();
		var paramMap = {
			"searchDateFrom" : searchDateFrom
			, "searchDateTo" : searchDateTo
			, "GRUP_CD" : $("#hidGOODS_CATEG_CD").val()
			, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
			, "ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
			, "DELIGATE_ORGN_DIV_CD" : "C"
			, "PUR_TYPE" : cmbPUR_TYPE.getSelectedValue()
		}
		
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/report/dayByReport/getDayByCategoryList.do"
			,data : paramMap
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				$erp.clearDhtmlXGrid(selectedGrid);
				erpLayout.progressOff();
				var gridDataList = data.gridDataList;
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							selectedGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						selectedGrid.parse(gridDataList, 'js');
					}
					$erp.setDhtmlXGridFooterSummary(selectedGrid,["TOT_DC_AMT","TOT_EVENT_DC_AMT","SALE_QTY","SALE_APPR_AMT","SALE_VAT","SALE_TOT_AMT","SLIP_QTY","SLIP_APPR_AMT","SLIP_VAT","SLIP_TOT_AMT"], 1, "합계");
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	
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
			    <col width="230px;">
			    <col width="70px">
			    <col width="*">
			</colgroup>
			<tr>
				<th>법인구분</th>
				<td>
					<div id="cmbORGN_DIV_CD"></div>
				</td>
				<th>조직명</th>
				<td>
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
			<tr>
				<th>상품분류</th>
				<td>
					<input type="hidden" id="hidGOODS_CATEG_CD" value="ALL">
					<input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" disabled="disabled" value="전체분류"/>
					<input type="button" id="GoodsGroup_Search" value="검 색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
<!-- 					<input type="checkbox" id="Select_Goods" name="Select_Goods"/> -->
<!-- 					<label for="Select_Goods">하위분류표시</label> -->
				</td>
			</tr>
		</table>
		<table id="tb_erp_data2" class="table_search">
			<colgroup>
		    	<col width="70px">
		        <col width="230px">
		        <col width="70px">
		        <col width="*">
		    </colgroup>
			<tr>
				<th>기 간</th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_calendar default_date" data-position="-1">
					<span style="float: left;">~</span> <input type="text" id="searchDateTo" name="searchDateTo" class="input_calendar default_date" data-position="">
				</td>
				<th>상품유형</th>
				<td>
					<div id="cmbPUR_TYPE"></div>
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
</body>
</html>