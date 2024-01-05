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
	var erpPopupGridOnRowSelect;
	var erpPopupKeyword;
	
	$(document).ready(function(){
		erpPopupWindowsCell.setText("거래처조회");
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		
		<%-- erpPopupTree Row 클릭 시 사용될 Function 상위 Window or Frame 에서 만들어 전달해줌 erp_popup.js도 참조--%>
		if(!$erp.isEmpty(erpPopupKeyword) && typeof erpPopupKeyword === 'string'){
			document.getElementById("txtSearch1").value = erpPopupKeyword;
		}
		
		searchErpPopupCustmr();
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
					  {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpGrid"){
				searchErpPopupCustmr();
		    } else if (itemId == "add_erpGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			  {id : "sup_code", label:["거래처코드", "#rspan"], type: "ro", width: "190", sort : "str", align : "left", isHidden : false, isEssential : false}              
			  , {id : "sup_bzname", label:["거래처명", "#rspan"], type: "ro", width: "190", sort : "str", align : "left", isHidden : false, isEssential : false}
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
		
		<%-- erpGrid Row 클릭 시 사용될 Function 상위 Window or Frame 에서 만들어 전달해줌 erp_popup.js도 참조--%>
		if(!$erp.isEmpty(erpPopupGridOnRowSelect) && typeof erpPopupGridOnRowSelect === 'function'){
			erpGrid.attachEvent("onRowSelect", erpPopupGridOnRowSelect); 
		}
	}
	
	function searchErpPopupCustmr(){
		erpLayout.progressOn();
		
		$.ajax({
			url : "/common/popup/getCustmrList.do"
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
						var CustmrList = data.CustmrList;
						if($erp.isEmpty(CustmrList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpGrid
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpGrid.parse(CustmrList, 'js');	
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
				<td>거래처명  <input type="text" id="txtSearch1" size="20" maxlength="50" onkeyup="if(event.keyCode==13) searchErpPopupCustmr()"></td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>