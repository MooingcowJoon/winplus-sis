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
<script type="text/javascript">
	
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openTradeStatementGridPopup");
	var param_ORGN_CD = '${param.ORGN_CD}';
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;
	var popOnRowDblClicked;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	var firstDay = thisYear + "-" + thisMonth + "-01";
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("PDA입고내역리스트");
		}
		initErpPopupLayout();
		initErpPopupRibbon();
		initErpPopupGrid();
		
		document.getElementById("searchDateFrom").value = firstDay;
		document.getElementById("searchDateTo").value = today;
	});
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
				, cells : [
					{id: "a", text: "조회일자선택영역", header:false, fix_size : [false, false]}
					,{id: "b", text: "리본영역", header:false, fix_size : [false, false]}
					,{id: "c", text: "그리드영역", header:false, fix_size : [false, false]}
				]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_table");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_popup_grid");
	}
	<%-- ■ erpPopupLayout 관련 Function 끝 --%>
	
	<%-- ■ erpPopupRibbon 관련 Function 시작 --%>
	function initErpPopupRibbon() {
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon",
			skin : ERP_RIBBON_CURRENT_SKINS,
			icons_path : ERP_RIBBON_CURRENT_ICON_PATH,
			items : [{
				type : "block",
				mode : 'rows',
				list : [ 
						{id : "search_popup_ribbon", type : "button", text : '조회', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					]
			}]
		});

		erpPopupRibbon.attachEvent("onClick", function(itemId, bId) {
			if (itemId == "search_popup_ribbon") {
				searchErpPopupGrid();
			}
		});
	}
	<%-- ■ erpPopupRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpPopupGrid 관련 Function 시작 --%>
	function initErpPopupGrid(){
		erpPopupGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false, isEssential : false}
			,{id : "ORGN_CD", label : ["직영점", "#rspan"], type : "combo", width : "75", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			,{id : "ORGN_DIV_CD", label : ["조직구분코드", "#rspan"], type : "ro", width : "75", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "STORE_AREA", label:["재고구역", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "RESP_USER", label:["담당자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			,{id : "TOT_GOODS_NM", label:["품목명", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "TOT_CNT", label:["수량", "#rspan"], type: "ron", width: "85", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "CDATE", label:["CDATE", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "DATA_TYPE", label : ["PDA타입", "#rspan"], type : "combo", width : "75", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : "PDA_DATA_TYPE"}
			,{id : "UNI_KEY", label:["UNI_KEY", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
		];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupGridColumns
		});
		
		erpPopupGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPopupGrid);
		$erp.initGridComboCell(erpPopupGrid);
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid, 10);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid, '<spring:message code="grid.allRowCount" />');
	}
	
	function searchErpPopupGrid(){
		if(!$erp.isEmpty(popOnRowDblClicked) && typeof popOnRowDblClicked === 'function'){
			erpPopupGrid.attachEvent("onRowDblClicked", popOnRowDblClicked);
		}
		
		var searchDateFrom = document.getElementById("searchDateFrom").value;
		var searchDateTo = document.getElementById("searchDateTo").value;
		
		var paramMap = {
			"searchDateFrom" : searchDateFrom
			, "searchDateTo" : searchDateTo
			, "dataType" : "3"
			, "orgnCd" : param_ORGN_CD
		};
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/market/purchase/getInspPdaDataHeaderList.do"
			,data : paramMap
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpPopupGrid);
					var gridDataList = data.dataMap;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
								erpPopupGrid
								,  '<spring:message code="grid.noSearchData" />'
						);
						return false;
					}else {
						erpPopupGrid.parse(gridDataList, 'js');
					}
					
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpPopupGrid 관련 Function 끝 --%>
	
	<%-- ■ 기타 Function 시작 --%>
	function enterSearchToGrid(kcode){
		if(kcode == 13){
			document.getElementById("searchDateFrom").blur();
			document.getElementById("searchDateTo").blur();
			searchErpPopupGrid();
		}
	}
	<%-- ■ 기타 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_popup_table" class="samyang_div" style="diplay:none;">
		<table id = "tb_search_01" class = "table">
			<colgroup>
				<col width="60px">
				<col width="*">
			</colgroup>
			<tr>
				<th>일 자</th>
				<td style="width: 250px;">
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar" onkeydown="enterSearchToGrid(event.keyCode);">
					<span style="float: left;">~</span>
					<input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar" onkeydown="enterSearchToGrid(event.keyCode);">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_popup_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>