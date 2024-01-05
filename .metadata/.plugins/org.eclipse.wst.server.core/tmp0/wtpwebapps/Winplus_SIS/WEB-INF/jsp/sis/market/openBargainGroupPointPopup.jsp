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
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openBargainGroupPointPopup");
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpPopupGroupOnRowSelect;
	var cmbORGN_CD;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var todayDate = thisYear + "-" + thisMonth 

	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("특매그룹조회");
		}
		
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		document.getElementById("SEARCH_FROM_DATE").value=todayDate;
		
		$erp.asyncObjAllOnCreated(function(){
			var searchable = 1;
			var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",")
			for(var i in search_cd_Arr){
				if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
					searchable = 2;
				}
			}
			if(searchable == 1 ){ //직영점단일
				cmbORGN_CD.disable();
				searchErpGrid();
			}
			searchErpGrid();
		});
	});
	
	<%-- ■ erpLayout 초기화 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "조건정보", header:false}
				,{id: "b", text: "리본정보", header:false, fix_size : [true, true]}
				,{id: "c", text: "그리드정보", header:false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
	}
	<%-- ■ erpLayout 초기화 끝 --%>
	
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
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchErpGrid();
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	<%-- erpGrid 초기화 Function --%>
	function initErpGrid(){
		erpGridColumns = [
			{id : "ORGN_CD", label:["직영점", "#rspan"], type: "combo", width: "90", sort : "str", align : "left", isHidden : false, isEssential : false, commonCode : ["ORGN_CD", "MK"]}
			, {id : "EVENT_NM", label:["타이틀", "#rspan"], type: "ro", width: "185", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "EVENT_STRT_DATE", label:["시작일", "#rspan"], type: "ro", width: "85", sort : "date", align : "center", isHidden : false, isEssential : true}
			, {id : "EVENT_END_DATE", label:["종료일", "#rspan"], type: "ro", width: "85", sort : "date", align : "center", isHidden : false, isEssential : true}
			, {id : "EVENT_TYPE", label:["특매구분", "#rspan"], type: "combo", width: "85", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["PRIORITY_EVENT_YN"]}
			, {id : "EVENT_CD", label:["특매코드", "#rspan"], type: "ro", width: "90", sort : "str", align : "center", isHidden : true, isEssential : false}
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
				
		if(!$erp.isEmpty(erpPopupGroupOnRowSelect) && typeof erpPopupGroupOnRowSelect === 'function'){
			erpGrid.attachEvent("onRowDblClicked", erpPopupGroupOnRowSelect);
		}
	}
	
	<%-- erpPopupGrid 조회 Function --%>
	function searchErpGrid(){
		erpLayout.progressOn();
		var SEARCH_FROM_DATE = document.getElementById("SEARCH_FROM_DATE").value;
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
	
		$.ajax({
			url : "/common/popup/getOpenBargainGroupPointList.do"
			,data : {
				"SEARCH_FROM_DATE" : SEARCH_FROM_DATE
				,"ORGN_CD" : ORGN_CD
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
							, '<spring:message code="grid.noSearchData"/>'
						);
					} else {
						erpGrid.parse(gridDataList, 'js');	
						
						if(!$erp.isEmpty(erpPopupGroupOnRowSelect) && typeof erpPopupGroupOnRowSelect === 'function'){
							erpGrid.attachEvent("onRowDblClicked", erpPopupGroupOnRowSelect);
						}
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
			
		});
	}
	<%-- ■ erpPopupGrid 조회 Function 끝--%>
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",");
		var searchable = 1;
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
				searchable = 2;
			}
		}
		
		 if(searchable == 2 ){
			 cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK","","","","MK"], 100, "모두조회", false, LUI.LUI_orgn_cd);
		} else {
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 100, null, false, LUI.LUI_orgn_cd);
		}
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>
<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="50px">
				<col width="110px">
				<col width="50px">
				<col width="*">
			</colgroup>
			<tr>
				<th>조직명</th>
				<td>
					<div id = "cmbORGN_CD"></div>
				</td>
				<th>날짜</th>
				<td>
					<input type="text" id="SEARCH_FROM_DATE" name="SEARCH_FROM_DATE" class="input_calendar_ym default_date" style="margin-left: 10px;">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>