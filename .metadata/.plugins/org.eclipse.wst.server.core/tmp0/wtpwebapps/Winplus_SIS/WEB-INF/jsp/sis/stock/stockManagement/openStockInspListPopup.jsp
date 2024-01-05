<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openStockInspListPopup");
	var erpLayout;
	var erpGrid;
	var erpGridColumns;
	var ORGN_CD = "${param.ORGN_CD}";
	var SEARCH_FROM_DATE = "${param.SEARCH_FROM_DATE}";
	var STORE_AREA = "${param.STORE_AREA}";
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("상세목록 보기");
		}
		
		initErpLayout();
		initErpGrid();
		searchErpGrid();
		initInspInfo();
		
	});
	
	<%-- ■ erpLayout 초기화 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "기본정보", header:false, fix_size : [true, true]}
				,{id: "b", text: "그리드정보", header:false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
	}
	<%-- ■ erpLayout 초기화 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "ORGN_CD", label:["직영점", "#rspan"], type: "combo", width: "75", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			, {id : "STORE_AREA", label:["실사구역", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "CUSER", label:["담당자", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "285", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_QTY", label:["수량", "#rspan"], type: "ro", width: "70", sort : "str", align : "center", isHidden : false, isEssential : false}
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
		erpGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
	}
	
	<%-- erpPopupGrid 조회 Function --%>
	function searchErpGrid(){
		var paramData = {};
		paramData["ORGN_CD"] = "${param.ORGN_CD}";
		paramData["SEARCH_FROM_DATE"] = "${param.SEARCH_FROM_DATE}";
		paramData["STORE_AREA"] = "${param.STORE_AREA}";
	
		$.ajax({
			url : "/common/popup/getStockInspListPopup.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOn();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
				erpLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
			
		});
	}
	
	function initInspInfo(){
		document.getElementById("txtSTORE_AREA").value = "${param.STORE_AREA}";
	}
	
	<%-- ■ erpPopupGrid 조회 Function 끝--%>
</script>
</head>
<body>
	<div id="div_erp_table" class="samyang_div" style="display:none">
	<table id="tb_erp_data" class="table_search">
		<colgroup>
			<col width="70px;">
			<col width="*px;">
		</colgroup>
		<tr>
			<th>실사구역</th>
			<td>
				<input type="text" id="txtSTORE_AREA" name="txtSTORE_AREA" class="input_common" readonly="readonly" style="width: 140px;">
			<td>
		</tr>
	</table>
	</div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>