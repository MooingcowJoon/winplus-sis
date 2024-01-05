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
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ cmbLOG_TYPE : Object / 로그유형 DhtmlXCombo (CODE : ACCESS_LOG_CD)		 
	--%>
	var erpLayout;
	var erpRibbon;	
	var erpGrid;
	var erpGridColumns;
	var cmbLOG_TYPE;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0, 4);
	var thisMonth = today.substring(4, 6);
	var thisDay = today.substring(6, 8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		initErpGrid();
		
		document.getElementById("searchDateFrom").value=todayDate;
		document.getElementById("searchDateTo").value=today;
	});
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbLOG_TYPE = $erp.getDhtmlXCombo('cmbLOG_TYPE', 'LOG_TYPE', 'ACCESS_LOG_CD', 120, true);
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false, fix_size : [true, true]}
				, {id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				, {id: "c", text: "그리드영역", header:false, fix_size : [true, true]}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
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
						 {id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
						//  {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
						//, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						//, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
						, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
						//, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpGrid"){
				searchErpGrid();
			} else if (itemId == "add_erpGrid"){
			} else if (itemId == "delete_erpGrid"){
		    } else if (itemId == "save_erpGrid"){
		    } else if (itemId == "excel_erpGrid"){
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "직원접속로그"
		    		, "isForm" : false
		    	});
		    } else if (itemId == "print_erpGrid"){
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "EMP_NO", label:["사원번호", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "EMP_NM", label:["직원명", "#text_filter"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["부서", "#text_filter"], type: "ed", width: "220", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["직함", "#text_filter"], type: "ed", width: "220", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["작업", "#text_filter"], type: "ed", width: "220", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["작업내용", "#text_filter"], type: "ed", width: "220", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["비고", "#text_filter"], type: "ed", width: "220", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["접속IP", "#text_filter"], type: "ed", width: "220", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["작업일시", "#text_filter"], type: "ed", width: "220", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "REG_PROGRM", label:["등록프로그램", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "REG_ID", label:["등록자", "#rspan"], type: "ro", width: "112", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "REG_DT", label:["등록일시", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "UPD_PROGRM", label:["수정프로그램", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "UPD_ID", label:["수정자", "#rspan"], type: "ro", width: "112", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "UPD_DT", label:["수정일시", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
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
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		
		var searchDateFrom = $("#searchDateFrom").val();
		var searchDateTo = $("#searchDateTo").val();
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(searchDateFrom)||$erp.isEmpty(searchDateTo)){
			isValidated = false;
			alertMessage = "error.common.date.empty3";
			alertCode = "-1";
			$("#searchDateFrom").focus();
		} 		
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		if(!isSearchValidate()){
			return;
		}
		
		erpLayout.progressOn();
		
		var searchDateFrom = $("#searchDateFrom").val();
		var searchDateTo = $("#searchDateTo").val();
		var log_type = cmbLOG_TYPE.getSelectedValue();
		
		$.ajax({
			url : "/common/system/authority/getEmpAccessLogList.do"
			,data : {
				"searchDateFrom" : searchDateFrom
				,"searchDateTo" : searchDateTo
				,"LOG_TYPE" : log_type
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
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
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- ■ erpGrid 관련 Function 끝 --%>
</script>
</head>
<body>				
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width='60px'>
				<col width='150px'>
				<col width='60px'>
				<col width='150px'>
				<col width='60px'>
				<col width='*'>
			</colgroup>
			<tr>
				<th>날짜From</th>
				<td><input type='text' id='searchDateFrom' name='searchDateFrom'  class='input_common input_calendar input_essential' maxlength='505'></td>
				<th>날짜To</th>
				<td><input type='text' id='searchDateTo' name='searchDateTo'  class='input_common input_calendar input_essential' maxlength='505'></td>
				<th>로그유형</th>
				<td><div id="cmbLOG_TYPE"></div></td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>