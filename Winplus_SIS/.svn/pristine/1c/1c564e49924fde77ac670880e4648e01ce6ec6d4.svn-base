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
	
	var erpLayout;
	var erpSearchLayout;
	var erpRibbon;
	var erpGridColumns;
	var erpGridDataProcessor;
	var erpGrid;
	var searchDateFrom;
	var searchDateTo;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	
	$(document).ready(function(){
		initErpLayout();
		initErpSearchLayout();
		initErpRibbon();
		initErpGrid();
		
		document.getElementById("searchDateFrom").value=todayDate;
		document.getElementById("searchDateTo").value=today;
	});
	
	
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a" , text: "조회조건영역" , header: false, height: 175, fix_size:[true, true]}
				, {id: "b", text: "그리드영역", header: false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_search_part");
		erpLayout.cells("a").setHeight(150);
		erpLayout.cells("b").attachObject("div_erp_grid");

		/* $erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpSearchLayout.setSizes();
			erpGrid.setSizes();
		}); */
	}
	
	
	function initErpSearchLayout() {
		erpSearchLayout = new dhtmlXLayoutObject({
			parent : "div_erp_search_part"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id:"a" , text: "조회조건영역", header: false, fix_size:[true, true]}
				, {id:"b", text: "리본영역", header: false}
			]
		});
		erpSearchLayout.cells("a").attachObject("div_erp_contents_search");
		erpSearchLayout.cells("b").attachObject("div_erp_ribbon");
		erpSearchLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		
		erpSearchLayout.setSeparatorSize(1, 0);
	}
	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				$erp.alertMessage({
					"alertMessage" : "준비 중 입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			} else if(itemId == "excel_erpGrid"){
				$erp.exportGridToExcel({
		    		"grid" : erpGrid
					, "fileName" : "집계표"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			}
		});
	}
	
	function initErpGrid() {
		erpGridColumns = [
              {id : "sup_code", label:["거래처코드", "#rspan"], type: "ro", width: "100", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}            
  			, {id : "sup_name", label:["거래처명", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
  			, {id : "price", label:["청구금액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
  			, {id : "non_price", label:["미청구금액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
  			, {id : "total", label:["합계", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}          
		];
		
		erpGrid = new dhtmlXGridObject({
			parent : "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path: ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		
		erpGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
		
		erpGrid.attachEvent("onRowSelect", function(rId){
			
		});
		
		
	}
	
	<%-- openSearchCustmrGridPopup 공급사검색 팝업 열림 Function --%>
	function openSearchCustmrGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "1"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		var onRowSelect = function(id, ind) {
			document.getElementById("hidCustmr_CD").value = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	
</script>
</head>
<body>
	<div id="div_erp_search_part" class="div_layout_full_size div_sub_layout" style="display:none;"></div>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_data" class="tb_erp_common">
			<colgroup>
				<col width="100px" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>기준일자</th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
					 ~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
				</td>
				<th>회계No</th>
				<td>
					<input type="text" id="account_NO" name="account_NO" >
				</td>
			</tr>
			<tr>
				<th>부서</th>
				<td>
					<input type="hidden" id="hid_dept_CD"/>
					<input type="text" id="dept_NAME" name="dept_NAME" readonly="readonly" disabled="disabled"/>
					<input type="button" id="dept_SEARCH" value="검색" class="input_common_button" onclick=""/>
				</td>
				<th>프로젝트</th>
				<td>
					<input type="hidden" id="hid_project_CD"/>
					<input type="text" id="project_NAME" name="project_NAME" readonly="readonly" disabled="disabled"/>
					<input type="button" id="project_SEARCH" value="검색" class="input_common_button" onclick=""/>
				</td>
			</tr>
			<tr>
				<th>거래처</th>
				<td>
					<input type="hidden" id="hidCustmr_CD"/>
					<input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled"/>
					<input type="button" id="custmr_SEARCH" value="검색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/>
				</td>
				<th>부가세유형</th>
				<td>
					<input type="hidden" id="hid_vat_CD"/>
					<input type="text" id="vat_NAME" name="vat_NAME" readonly="readonly" disabled="disabled"/>
					<input type="button" id="vat_SEARCH" value="검색" class="input_common_button" onclick=""/>
				</td>
			</tr>
			<tr>
				<th>상태</th>
				<td>
					<input type="radio" id="condition" name="condition" value="rdo_all"> 전체
					<input type="radio" id="condition" name="condition" value="rdo_non_ok"> 미확인
					<input type="radio" id="condition" name="condition" value="rdo_ok" checked> 확인
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid"  class="div_grid_full_size" style="display:none"></div>
</body>
</html>