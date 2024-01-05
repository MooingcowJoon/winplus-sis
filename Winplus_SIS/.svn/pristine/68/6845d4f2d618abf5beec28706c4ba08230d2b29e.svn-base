<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript">
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
	var erpLayout;
	var erpGridColumns;
	var erpGrid;
	var erpGridDataProcessor;
	
	var Slip_CD = "${param.Slip_CD}";
	
	$(document).ready(function(){
		erpPopupWindowsCell.setText("전표이력조회상세");
		initErpLayout();
		initErpGrid();
	});
	
	
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "조회결과영역", header:false}
			]	
		});
		
		erpLayout.cells("a").attachObject("div_erp_grid");
		erpLayout.setSeparatorSize(1, 0);
	}
	
	function initErpGrid() {
		erpGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}            
			, {id : "erp_id", label:["작업자ID", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "date", label:["작업일시", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "status", label:["상태", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}                  
		];
		
		erpGrid = new dhtmlXGridObject({
			parent : "div_erp_grid"
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
		
	}
	
	
	
</script>
</head>
<body>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>