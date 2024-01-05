<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp" />
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp" />
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">
	var thisPopupWindow = parent.erpPopupWindows.window('openOnlineOrderDetail');
	
	var total_layout;
	var mid_layout;
	var grid_Columns;
	var bot_layout_grid;
	
	$(document).ready(function(){
		if(thisPopupWindow){
			thisPopupWindow.setText('주문서(온라인) 상세');
			thisPopupWindow.denyResize();	//창 크기 조절 ㄴㄴ
			thisPopupWindow.denyMove();		//창 움직이지마!
		}
		ORD_CD = "${param.SELECTED_ORD_CD}"
		init_total_layout();
		/* init_top_layout(); */
		init_mid_layout();
		init_bot_layout();
		
		searchPopup();
	});
	
	function init_total_layout() {
		total_layout = new dhtmlXLayoutObject({
		parent: document.body
		, skin : ERP_LAYOUT_CURRENT_SKINS
		, pattern: "2E"
			, cells: [
				{id: "a", text: "", header:false, fix_size : [true, true]}
				, {id: "b", text: "", header:false, fix_size : [true, true]}
			]
		});
		total_layout.cells("a").attachObject("div_mid_layout");
		total_layout.cells("a").setHeight(36);
		total_layout.cells("b").attachObject("div_bot_layout");
		
		total_layout.setSeparatorSize(0, 1);
	}
	<%-- ■ total_layout 초기화 끝 --%>
	function init_mid_layout(){
		mid_layout = new dhtmlXRibbon({
			parent : "div_mid_layout"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{type : "block", mode : 'rows', list : [
//			        		             {id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 			        		             , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
// 			        		             , {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
// 			        		             , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
//			        		             {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
//			        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
			        		             ]
				           }
				]
		});
		
		mid_layout.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				
			} else if (itemId == "add_grid"){
					
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				$erp.exportDhtmlXGridExcel({
				     "grid" : bot_layout_grid
				   , "fileName" : "주문서(온라인)상세"
				   , "isForm" : false
				   , "isHiddenPrint" : "Y"
				});
			} else if (itemId == "print_grid"){
				$erp.alertMessage({
	            	"alertMessage" : "준비중입니다.",
					"alertType" : "alert",
					"isAjax" : false
	            });
			}
		});
	}
	
	function init_bot_layout() {
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		grid_Columns = [
							{id : "NO", label:["순번"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
	//						, {id : "CHECK", label:["#master_checkbox"], type : "ch", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
							, {id : "ORD_CD", label:["주문번호"], type : "ro", width : "150", sort : "str", align : "left", isHidden : true, isEssential : false}
		                    , {id : "BCD_CD", label:["바코드"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
		                    , {id : "GOODS_NM", label:["상품명"], type : "ro", width : "300", sort : "str", align : "LEFT", isHidden : false, isEssential : true}
		                    , {id : "SALE_UNITQTY", label:["단위량"], type : "ro", width : "80", sort : "str", align : "right", isHidden : false, isEssential : true}
		                    , {id : "INSP_QTY", label:["단위수량"], type : "ron", width : "80", sort : "str", align : "right", isHidden : false, isEssential : true}
		                    , {id : "SALE_QTY", label:["수량"], type : "ro", width : "80", sort : "str", align : "right", isHidden : false, isEssential : true}
		                    , {id : "PUR_AMT", label:["매출원가"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "SALE_AMT", label:["공급가액"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "SALE_VAT_AMT", label:["부가세액"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "SALE_TOT_AMT", label:["합계금액"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "", label:["적요"], type : "ro", width : "200", sort : "str", align : "center", isHidden : false, isEssential : true}
		                     ];
		bot_layout_grid = new dhtmlXGridObject({
			parent : "div_bot_layout"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : grid_Columns
		});
		bot_layout_grid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(bot_layout_grid);
		$erp.initGridComboCell(bot_layout_grid);
		$erp.attachDhtmlXGridFooterRowCount(bot_layout_grid, '<spring:message code="grid.allRowCount" />');
	
	}
	function searchPopup() {
		total_layout.progressOn();
		console.log("제발!!!" + ORD_CD);
		
		$.ajax({
			url : "/sis/sales/onlinesales/getopenOnlineOrderDetail.do"
			,data : {
				"ORD_CD" : ORD_CD
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				total_layout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
								bot_layout_grid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						bot_layout_grid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(bot_layout_grid);
			}, error : function(jqXHR, textStatus, errorThrown){
				total_layout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
</script>
<body>
	<!-- <div id="div_top_layout" class="samyang_div" style="display:none"></div> -->
	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bot_layout" class="div_grid_full_size" style="display:none"></div>

</body>
</html>