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
	
	/* 일_일별종합 */
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2";
	<%--
	※ 전역 변수 선언부 
	□ 변수명 : Type / Description
	■ erpLayout : Object / 페이지 Layout DhtmlXLayout
	■ erpSubLayout : Object / 페이지 Layout DhtmlXLayout
	■ erpChartLayout : Object / 페이지 Layout DhtmlXLayout
	■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
	■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
	■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
	■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
	■ searchDateFrom : String / 기간 시작일
	■ searchDateTo : String / 기간 마지막일
	--%>
	
	var erpLayout;
	var erpSubLayout;
	var erpChartLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	$(document).ready(function(){	
		initErpLayout();
		initDhtmlXCombo();
		initErpSubLayout();
		initErpRibbon();
		initErpGrid();
		initErpChartLayout();
		
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "", header:false, width: 600, fix_size : [true, true]}
				, {id: "b", text: "일별종합통계", header: true}
			]
		});
		erpLayout.cells("a").attachObject("div_erp_sub_layout");
		erpLayout.cells("a").setHeight(830);
		erpLayout.cells("b").attachObject("div_erp_chart_layout");
		
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpSubLayout.setSizes();
			erpChartLayout.setSizes();
			erpGrid.setSizes();
		});
	}
	
	<%-- erpSubLayout 초기화 Function --%>
	function initErpSubLayout() {
		erpSubLayout = new dhtmlXLayoutObject({
			parent : "div_erp_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells: [
				{id: "a", text: "일별종합조회조건영역", header:false}
				, {id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드영역", header:false}]	
		});
		erpSubLayout.cells("a").attachObject("div_erp_contents_search");
		erpSubLayout.cells("a").setHeight(65);
		erpSubLayout.cells("b").attachObject("div_erp_ribbon");
		erpSubLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpSubLayout.cells("c").attachObject("div_erp_grid");
		
		erpSubLayout.setSeparatorSize(1, 0);
		
	}
	
	<%-- erpChartLayout 초기화 Function --%>
	function initErpChartLayout() {
		erpChartLayout = new dhtmlXLayoutObject({
			parent: "div_erp_chart_layout"
			, skin: ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3W"
			, cells: [
				{id: "a", text: "", header:false, fix_size : [true, true]}
				, {id: "b", text: "", header:false, fix_size : [true, true]}
				, {id: "c", text: "", header:false, fix_size : [true, true]}
			]
			, fullScreen: true
		});
		erpChartLayout.cells("a").attachObject("div_erp_line_chart");
		erpChartLayout.cells("a").setWidth(2500);
		erpChartLayout.cells("b").attachObject("div_erp_pie_chart");
		erpChartLayout.cells("b").setWidth(330);
		erpChartLayout.cells("c").attachObject("div_erp_sub_pie_chart");
		
		erpChartLayout.setSeparatorSize(1, 6);
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
		    		, "fileName" : "일레포트-일별종합"		
		    		, "isForm" : false
		    	});
		    } else if (itemId == "print_erpGrid"){

		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>	
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	function initErpGrid(){
		erpGridColumns = [
			  {id : "No", label:["No."], type: "cntr", width: "50", sort : "int", align : "center", isHidden : false}              
			  , {id : "거래일자", label:["일자"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false}
			  , {id : "ORGN_DIV_CD", label:["법인코드"], type: "ro", width: "150", sort : "str", align : "left", isHidden : true}
			  , {id : "ORGN_CD", label:["조직코드"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isDisabled : true , commonCode : "ORGN_CD"}
			  , {id : "총상품수", label:["총등록상품수"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "신규상품수", label:["신규등록상품수"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "총회원수", label:["총회원수"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "신규회원수", label:["신규회원수"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "방문회원수", label:["방문회원수"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "방문객수", label:["방문객수"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "매입총액", label:["매입총액"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "매출총액", label:["매출총액"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "전화주문건수", label:["전화주문건수"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "전화주문총금액", label:["전화주문총금액"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "포인트총액", label:["포인트총액(적립)"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "배달건수", label:["배달건수"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "배달총액", label:["배달총액"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			  , {id : "외상총액", label:["외상총금액"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
			, splitAt : 1
		});
		
		erpGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		
		var text_style = "text-align:right; font-weight:bold; font-style:normal";
		var tot_style = "text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;";
		erpGrid.attachFooter("합계,#cspan,#cspan,#cspan,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total"
				,[tot_style,"","","",text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style]);
		erpGrid.attachFooter("평균,#cspan,#cspan,#cspan,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average"
				,[tot_style,"","","",text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style,text_style]);
		
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
		
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	function initErpChart(gridData) {
		var erpLineChart =  new dhtmlXChart({
			view:"line",
			container:"div_erp_line_chart",
			value:"#매출총액#",
			item:{
				borderColor: "#1293f8",
				color: "#ffffff"
			},
			line:{
				color:"#1293f8",
				width:3
			},
			tooltip:{
				template:"#매출총액#"
			},
			offset:0,
			xAxis:{
				template:"#거래일자#"
			},
			yAxis:{
				start:0,
				step:5000,
				end:20000,
				template:function(value){
					return value%5?"":value
				}
			},
			padding:{
				left:35,
				bottom: 50
			},
			origin:0,
			legend:{
				layout:"x",
				width: 75,
				align:"center",
				valign:"bottom",
				values:[
					{text:"매출총액",color:"#3399ff"},
					{text:"방문객수",color:"#66cc00"}
				],
				margin: 10
			}
		});
		
		erpLineChart.addSeries({
			value:"#방문객수#",
			item:{
				borderColor: "#66cc00",
				color: "#ffffff"
			},
			line:{
				color:"#66cc00",
				width:3
			},
			tooltip:{
				template:"#방문객수#"
			}
		});
		
		erpLineChart.parse(gridData,"json");
	}
	
	function SearchErpGrid() {
		var paramMap = {
			"searchDateFrom" : 	$("#searchDateFrom").val()
			, "searchDateTo" : 	$("#searchDateTo").val()
			, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
			, "ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
		};
		console.log(paramMap);
		
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/report/dayByReport/getDayByTotalList.do"
			,data : paramMap
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				$erp.clearDhtmlXGrid(erpGrid);
				erpLayout.progressOff();
				var gridDataList = data.gridDataList;
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpGrid.parse(gridDataList, 'js');
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function initDhtmlXCombo(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, null, false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), null, false, null);
			}); 
		});
	}
</script>
</head>
<body>
	<div id="div_erp_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none;"></div>
	<div id="div_erp_contents_search" class="div_layout_full_size div_erp_contents_search" style="display:none">
		<table class="tb_erp_common">
			<colgroup>
				<col width="80px">
				<col width="210px">
				<col width="80px">
				<col width="*">
			</colgroup>
			<tr>
				<th>법인구분</th>
				<td>
					<div id="cmbORGN_DIV_CD"></div>
				</td>
				<th>조직구분</th>
				<td>
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
			<tr>
				<th> 기    간 </th>
				<td colspan="3">
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar default_date" data-position="-1">
					 ~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar default_date" data-position="">
				</td>
			</tr>		
		</table>
	</div>
	<div id="div_erp_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
	
	<div id="div_erp_chart_layout" class="div_layout_full_size div_sub_layout" style="display:none;"></div>
	<div id="div_erp_line_chart"></div>
	<div id="div_erp_pie_chart"></div>
	<div id="div_erp_sub_pie_chart"></div>
</body>
</html>