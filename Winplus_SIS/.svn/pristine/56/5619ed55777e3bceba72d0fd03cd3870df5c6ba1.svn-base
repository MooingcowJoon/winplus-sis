<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<%-- <jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/> --%><!-- 기존 -->
<jsp:include page="/WEB-INF/jsp/common/include/default_new_window_script_header.jsp"/><!-- 대체 -->
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">
	LUI = JSON.parse('${empSessionDto.lui}');
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openPastOrderGridPopup");
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupLeftGrid;
	var erpPopupLeftGridColumns;
	var erpPopupRightGrid;
	var erpPopupRightGridColumns;
	
	//사용자정의함수는 보내는 키 문자열 값과 동일해야 합니다.
	var erpOnCloseAndSearch;
	var erpOnClickAddData;
	var erpOnRowDblClicked;
	var erpOnKeyDownEsc;
	
	var param_ORGN_DIV_CD = "${param.ORGN_DIV_CD}";
	var param_ORGN_CD = "${param.ORGN_CD}";
	var param_MEM_NO = "${param.MEM_NO}";
	
	var stdToday = new Date();
	var stdToDate = $erp.getDateYMDFormat(stdToday, "-");
	stdToday.setDate(stdToday.getDate()-30);
	var stdFromDate = $erp.getDateYMDFormat(stdToday, "-");
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("지난거래내역");
		}
		
		initErpPopupLayout();
		initErpPopupRibbon();
		initErpPopupLeftGrid();
		initErpPopupRightGrid();
		
		$erp.asyncObjAllOnCreated(function(){
			document.getElementById("searchFromDate").value = stdFromDate;
			document.getElementById("searchToDate").value = stdToDate;
			
			document.getElementById("searchFromDate").focus();
			document.getElementById("searchFromDate").blur();
			searchErpPopupLeftGrid();
		});
	});
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4J"
			, cells: [
				{id: "a", text: "조회조건영역", header:false , fix_size:[true, true]}
				,{id: "b", text: "리본영역", header:false , fix_size:[true, true]}
				,{id: "c", text: "왼쪽그리드영역", header:false , fix_size:[true, true]}
				,{id: "d", text: "오른쪽그리드영역", header:false , fix_size:[true, true]}
			]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_search_table");
		erpPopupLayout.cells("a").setHeight($erp.getTableHeight(1));
		erpPopupLayout.cells("b").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_popup_left_grid");
		erpPopupLayout.cells("c").setWidth(299);
		erpPopupLayout.cells("d").attachObject("div_erp_popup_right_grid");
	}
	<%-- ■ erpPopupLayout 초기화 끝 --%>

	<%-- erpPopupRibbon 초기화 Function --%>
	function initErpPopupRibbon(){
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{type : "block", mode : 'rows', list : [
						{id : "search_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
						,{id : "add_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					]}
				]	
			});
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpPopupGrid"){
				searchErpPopupLeftGrid();
			} else if(itemId == "add_erpPopupGrid"){
				addErpGridData();
			}
		});
	}
	<%-- ■ erpPopupRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpPopupLeftGrid 관련 Function 시작 --%>
	function initErpPopupLeftGrid(){
		erpPopupLeftGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false, isEssential : false}
			//{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "ORD_DATE", label:["거래일시", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "SALE_TOT_AMT", label:["거래금액", "#rspan"], type: "ron", width: "78", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "CNT", label:["상품수", "#rspan"], type: "ron", width: "50", sort : "int", align : "right", isHidden : false, isEssential : false, isSelectAll : true, maxLength : 5}
			,{id : "ORGN_DIV_CD", label:["법인구분", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "TEL_ORD_CD", label:["전화주문코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
		];
		
		erpPopupLeftGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_left_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupLeftGridColumns
		});
		
		$erp.initGridCustomCell(erpPopupLeftGrid);
		$erp.initGridComboCell(erpPopupLeftGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupLeftGrid, '<spring:message code="grid.allRowCount" />');
		
		erpPopupLeftGrid.enableAccessKeyMap(true);
		
		erpPopupLeftGrid.attachEvent("onSelectStateChanged", function(id){
			searchErpPopupRightGrid();
		});
		erpPopupLeftGrid.attachEvent("onTab", function(mode){
			if(mode){
				searchErpPopupRightGrid(erpPopupLeftGrid.getSelectedRowId());
			}
			return false;
		});
	}
	
	function searchErpPopupLeftGrid(){
		
		var searchParams = {};
		searchParams.SEARCH_URL = "/sis/market/sales/getMemOrderHeaderList.do" //전화주문 목록 자료 조회
		searchParams.ORGN_CD = param_ORGN_CD;
		searchParams.SEARCH_TYPE = "ORD_DATE";
		searchParams.SEARCH_TEXT = "";
		searchParams.SEARCH_FROM_DATE = document.getElementById("searchFromDate").value.replace(/\-/g,'');
		searchParams.SEARCH_TO_DATE = document.getElementById("searchToDate").value.replace(/\-/g,'');
		searchParams.MEM_NO = param_MEM_NO;
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : searchParams.SEARCH_URL
			,data : searchParams
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpPopupLeftGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupLeftGrid
							,'<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpPopupLeftGrid.parse(gridDataList, 'js');
						window.setTimeout(function(){
							erpPopupLeftGrid.selectCell(0,erpPopupLeftGrid.getColIndexById("ORD_DATE"),false,false,true);
						},1);
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupLeftGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpPopupLeftGrid 관련 Function 끝 --%>
	
	<%-- ■ erpPopupRightGrid 관련 Function 시작 --%>
	function initErpPopupRightGrid(){
		erpPopupRightGridColumns = [
			//{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false, isEssential : false}
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false, isSelectAll : true}
			,{id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isSelectAll : true, maxLength : 15}
			,{id : "SALE_PRICE", label:["판매단가", "#rspan"], type: "ron", width: "70", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "SALE_QTY", label:["수량", "#rspan"], type: "ron", width: "50", sort : "int", align : "right", isHidden : false, isEssential : false, isSelectAll : true, maxLength : 5}
			//,{id : "", label:["특매할인", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "SALE_TOT_AMT", label:["판매가액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
		];
		
		erpPopupRightGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_right_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupRightGridColumns
		});
		
		$erp.initGridCustomCell(erpPopupRightGrid);
		$erp.initGridComboCell(erpPopupRightGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupRightGrid, '<spring:message code="grid.allRowCount" />');
		
		//erpPopupRightGrid.enableAccessKeyMap(true);
		
		erpPopupRightGrid.attachEvent("onTab", function(mode){
			if(!mode){
				erpPopupRightGrid.setRowTextStyle(erpPopupRightGrid.getSelectedRowId(),"background-color:#FDFDFD");
				window.setTimeout(function(){
					erpPopupLeftGrid.selectCell(erpPopupLeftGrid.getRowIndex(erpPopupLeftGrid.getSelectedRowId()),erpPopupLeftGrid.getColIndexById("ORD_DATE"),false,false,true);
				},1);
			}
			return false;
		});
		
		erpPopupRightGrid.attachEvent("onEnter", function(id,ind){
			addErpGridData();
		});
	}
	
	function searchErpPopupRightGrid(selectedRowId){
		
		if(!$erp.isEmpty(erpOnRowDblClicked) && typeof erpOnRowDblClicked === 'function'){
			erpPopupRightGrid.attachEvent("onRowDblClicked", erpOnRowDblClicked);
		}
		
		if(!$erp.isEmpty(erpOnKeyDownEsc) && typeof erpOnKeyDownEsc === 'function'){
			erpPopupLeftGrid.attachEvent("onKeyPress", erpOnKeyDownEsc);
			erpPopupRightGrid.attachEvent("onKeyPress", erpOnKeyDownEsc);
		}
		
		var paramData = {};
		paramData["ORGN_DIV_CD"] = erpPopupLeftGrid.cells(erpPopupLeftGrid.getSelectedRowId(),erpPopupLeftGrid.getColIndexById("ORGN_DIV_CD")).getValue();
		paramData["ORGN_CD"] = erpPopupLeftGrid.cells(erpPopupLeftGrid.getSelectedRowId(),erpPopupLeftGrid.getColIndexById("ORGN_CD")).getValue();
		paramData["DELI_ORD_CD"] = erpPopupLeftGrid.cells(erpPopupLeftGrid.getSelectedRowId(),erpPopupLeftGrid.getColIndexById("TEL_ORD_CD")).getValue();
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/market/sales/getDeliOrderInfo.do"		// 전화주문 정보 조회
			,data : {
				"paramData" : JSON.stringify(paramData)
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpPopupRightGrid);
					var gridDataList = data.dataMapDetail;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupRightGrid
							,'<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpPopupRightGrid.parse(gridDataList, 'js');
						if(selectedRowId != null && selectedRowId != undefined){
							window.setTimeout(function(){
								erpPopupRightGrid.selectCell(0,erpPopupRightGrid.getColIndexById("CHECK"),false,false,true);
							},1);
						}
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupRightGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpPopupRightGrid 관련 Function 끝 --%>
	
	<%-- ■ 기타 Function 시작 --%>
	function addErpGridData() {
		var check_YN = erpPopupRightGrid.getCheckedRows(erpPopupRightGrid.getColIndexById("CHECK"));
		if(check_YN != ""){
			if(!$erp.isEmpty(erpOnClickAddData) && typeof erpOnClickAddData === 'function'){
				erpOnClickAddData(erpPopupRightGrid);
	 		}
		} else {
			$erp.alertMessage({
				"alertMessage" : "체크된 상품항목이 없습니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}
	}
	
	function enterSearchToPopupGrid(kcode){
		if(kcode == 13){
			document.getElementById("searchFromDate").blur();
			document.getElementById("searchToDate").blur();
			searchErpPopupLeftGrid();
		}
	}
	<%-- ■ 기타 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_popup_search_table" class="samyang_div" style="display:none">
		<table class = "table">
			<colgroup>
				<col width="80px"/>
				<col width="120px"/>
				<col width="80px"/>
				<col width="120px"/>
				<col width="80px"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<th>조회일자</th>
				<td colspan="5">
					<input type="text" id="searchFromDate" name="searchFromDate" class="input_common input_calendar" style="margin-left:10px;" onkeydown="enterSearchToPopupGrid(event.keyCode);">
					<span style="position: fixed;">~</span>
					<input type="text" id="searchToDate" name="searchToDate" class="input_common input_calendar" style="margin-left:10px;" onkeydown="enterSearchToPopupGrid(event.keyCode);">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_popup_left_grid" class="div_grid_full_size" style="display:none"></div>
	<div id="div_erp_popup_right_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>