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
	var Mem_Info = JSON.parse('${param.Mem_Info}');
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;
	var erpGridDataProcessor;
	var popOnRowDblClicked;
	
	
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("거래내역리스트");
		}
		initErpLayout();
		initErpRibbon();
		initErpGrid();
	});
	
	
	
	function initErpLayout(){
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
		
		erpPopupLayout.cells("a").attachObject("div_erp_trade_date");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_trade_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_trade_grid");
		
		erpPopupLayout.setSeparatorSize(0, 1);
		
		<%-- erpPopupLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupGrid.setSizes();
		});
	}
	
	function initErpRibbon() {
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_trade_ribbon",
			skin : ERP_RIBBON_CURRENT_SKINS,
			icons_path : ERP_RIBBON_CURRENT_ICON_PATH,
			items : [{
				type : "block",
				mode : 'rows',
				list : [ 
						{id : "search_popup_ribbon", type : "button", text : '조회', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
						 //, {id : "add_popup_ribbon",type : "button",text : '적용',isbig : false,img : "menu/add.gif",imgdis : "menu/add_dis.gif",disable : true} 
					   ]
			}]
		});

		erpPopupRibbon.attachEvent("onClick", function(itemId, bId) {
			if (itemId == "search_popup_ribbon") {
				searchErpGrid();
			}/*  else if (itemId == "add_popup_ribbon") {

			} */
		});
	}
	
	function initErpGrid(){
		erpPopupGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "ORGN_DIV_CD", label:["조직구분코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "TEL_ORD_CD", label:["전화주문코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "ORD_DATE", label:["주문일자", "#rspan"], type: "ro", width: "134", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "TOT_GOODS_NM", label:["전화주문명", "#rspan"], type: "ro", width: "290", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "SALE_TOT_AMT", label:["주문금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
		];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_trade_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupGridColumns
		});
		
		erpPopupGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPopupGrid);
		//$erp.initGridComboCell(erpPopupGrid);
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid, 10);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpPopupGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpPopupGrid);
	}
	
	function searchErpGrid(){
		if(!$erp.isEmpty(popOnRowDblClicked) && typeof popOnRowDblClicked === 'function'){
			erpPopupGrid.attachEvent("onRowDblClicked", popOnRowDblClicked);
		}
		
		var searchDateFrom = document.getElementById("searchDateFrom").value;
		var searchDateTo = document.getElementById("searchDateTo").value;
		
		var paramMap = {
			"searchDateFrom" : searchDateFrom
			, "searchDateTo" : searchDateTo
			, "MEM_NO" : Mem_Info.Mem_No
			, "ORGN_CD" : Mem_Info.ORGN_CD
		};
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/market/sales/getMemOrderHeaderList.do"
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
	
</script>
</head>
<body>
	<div id="div_erp_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_trade_date" class="samyang_div" style="diplay:none;">
			<table id="table_trade_search_date" class="table">
				<colgroup>
					<col width="60px">
					<col width="*">
				</colgroup>
				<tr>
					<th>일 자</th>
					<td style="width: 250px;">
						<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_calendar default_date" data-position="(start)">
						<span style="float : left;">~&nbsp;</span>
						<input type="text" id="searchDateTo" name="searchDateTo" class="input_calendar default_date" data-position="">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_trade_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_trade_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	
</body>
</html>