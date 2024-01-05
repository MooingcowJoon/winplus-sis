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
	var erpRibbon;
	var erpGridColumns;
	var erpGrid;
	var erpPopupCustmrOnRowSelect;
	
	$(document).ready(function(){
		erpPopupWindowsCell.setText("바코드마스터조회");
		initErpLayout();
		initErpRibbon();
		initErpGrid();
	});
	
	
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, height:10}
				, {id: "b", text: "", header:false}
				, {id: "c", text: "", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
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
					  {id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false},
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpGrid"){
				searchMastBcodeGridPopup();
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	/*********************************************************/
	/* 바코드기준 전체상품목록 조회 
	/*********************************************************/
	function initErpGrid(){
		erpGridColumns = [
				  {id : "GOODS_NO"           , label:["상품코드"            , "#text_filter"], type: "ro",   width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "BCD_CD"             , label:["자바코드"            , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "BCD_NM"             , label:["상품명"              , "#text_filter"], type: "ro",   width: "200", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "DIMEN_NM"           , label:["규격"                , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "UNIT_CD"            , label:["단위"                , "#text_filter"], type: "ro",   width:  "50", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "DIMEN_WGT"          , label:["중량"                , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "PUR_PRICE"          , label:["구매단가"            , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : true,  isEssential : true,  numberFormat : "0,000"}
				, {id : "CUSTMR_NM"          , label:["협력사명"            , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "center", isHidden : true,  isEssential : true}
				, {id : "BCD_M_CD"           , label:["모바코드"            , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : true,  isEssential : true}
				, {id : "DIMEN_QTY"          , label:["규격중량"            , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : true,  isEssential : true}
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
		
		if(!$erp.isEmpty(erpPopupCustmrOnRowSelect) && typeof erpPopupCustmrOnRowSelect === 'function'){
			erpGrid.attachEvent("onRowSelect", erpPopupCustmrOnRowSelect); 
		}
		
	}
	
	function searchMastBcodeGridPopup(){
		erpLayout.progressOn();
		
		$.ajax({
			url : "/common/popup/getSearchMasterBarcode.do"
			,data : {
				"KEY_WORD" : $("#txtSearch1").val()
			}
			,method : "POST"
			,dataType : "JSON"
				,success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
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
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}	
	
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="80px">
			</colgroup>
			<tr>
				<td>상품명<input type="text" id="txtSearch1" size="20" maxlength="50" onkeyup="if(event.keyCode==13) searchMastBcodeGridPopup()"></td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>