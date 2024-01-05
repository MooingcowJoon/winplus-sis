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
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openSearchCustmrGridPopup");
	var erpLayout;
	var erpRibbon;
	var erpPopupGridColumns;
	var erpPopupGridDataProcessor;
	var erpPopupGrid;
	var erpPopupCustmrOnRowSelect;
	var cmbUSE_YN;
	
	var PUR_SALE_TYPE = "${param.PUR_SALE_TYPE}";
	
	$(document).ready(function(){
		console.log("PUR_SALE_TYPE >> " + PUR_SALE_TYPE);
		
		if(PUR_SALE_TYPE == "1"){
			erpPopupWindowsCell.setText("협력사조회");
		}else if(PUR_SALE_TYPE == "2") {
			erpPopupWindowsCell.setText("고객사조회");
		}else {
			erpPopupWindowsCell.setText("거래처조회");
		}
		
		initErpLayout();
		initErpRibbon();
		initerpPopupGrid();
		initDhtmlXCombo();
		
		
		$erp.asyncObjAllOnCreated(function(){
			grupNameHidden();
		});
		
	});
	
	
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, height:12}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(55);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpPopupGrid.setSizes();
		});
		
		if(PUR_SALE_TYPE == "1"){
			document.getElementById("CUSTMR_TYPE").innerHTML = '<input type="radio" id="Search_Condition" name="Search_Condition" value="custmr" checked="true" onChange="grupNameHidden()">협력사조회 <input type="radio" id="Search_Condition" name="Search_Condition" value="group" onChange="grupNameHidden()">협력사그룹조회 <input type="radio" id="Search_Condition" name="Search_Condition" value="user" onChange="grupNameHidden()">협력사즐겨찾기조회';
		} else if(PUR_SALE_TYPE == "2") {
			document.getElementById("CUSTMR_TYPE").innerHTML = '<input type="radio" id="Search_Condition" name="Search_Condition" value="custmr" checked="true" onChange="grupNameHidden()">고객사조회 <input type="radio" id="Search_Condition" name="Search_Condition" value="group" onChange="grupNameHidden()">고객사그룹조회 <input type="radio" id="Search_Condition" name="Search_Condition" value="user" onChange="grupNameHidden()">고객사즐겨찾기조회';
		} else {
			document.getElementById("CUSTMR_TYPE").innerHTML = '<input type="radio" id="Search_Condition" name="Search_Condition" value="custmr" checked="true" onChange="grupNameHidden()">거래처조회 <input type="radio" id="Search_Condition" name="Search_Condition" value="group" onChange="grupNameHidden()">거래처그룹조회 <input type="radio" id="Search_Condition" name="Search_Condition" value="user" onChange="grupNameHidden()">거래처즐겨찾기조회';
		}
		
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>
	function initErpRibbon(){
		var use_items = [];
		
		var items_01 = [
			{type : "block", mode : 'rows', list : [
				{id : "search_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif"}
				,{id : "add_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif"}
			]}
		];
		
		var items_02 = [
			{type : "block", mode : 'rows', list : [
				{id : "search_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif"}
			]}
		];
		
		//erpPopupCustmrCheckList가 없으면 거래처 여러개 추가버튼 hide
		if($erp.isEmpty(window["erpPopupCustmrCheckList"])){
			use_items = items_02;
		} else {
			use_items = items_01;
		}
		
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : use_items
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpPopupGrid"){
				searchErpPopupCustmr();
		    } else if(itemId == "add_erpPopupGrid"){
		    	adderpPopupGridData();
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpPopupGrid 관련 Function 시작 --%>	
	<%-- erpPopupGrid 초기화 Function --%>	
	function initerpPopupGrid(){
		erpPopupGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "GRUP_NM", label:["거래처그룹명", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CUSTMR_NM", label:["거래처명", "#text_filter"], type: "ro", width: "240", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "PUR_SALE_TYPE", label:["거래유형", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "PUR_SALE_NM", label:["거래유형명", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "USE_YN", label:["사용유무", "#select_filter"], type: "ro", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode: ["YN_CD","YN"]}
			, {id : "GRUP_CD", label:["거래처그룹코드", "#rspan"], type: "ro", width: "90", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CUSTMR_CD", label:["거래처코드", "#rspan"], type: "ro", width: "90", sort : "str", align : "center", isHidden : false, isEssential : false}              
			, {id : "CORP_NO", label:["사업자번호", "#rspan"], type: "ro", width: "90", sort : "str", align : "center", isHidden : true, isEssential : false}
		];
		
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpPopupGridColumns
		});	
		
		//erpPopupCustmrCheckList가 없을때, CHECK 박스 컬럼 hide시키기
		if($erp.isEmpty(window["erpPopupCustmrCheckList"])){
			console.log("체크박스 숨기기");
			erpPopupGrid.setColumnHidden(erpPopupGrid.getColIndexById("CHECK"), true);
		}
		
		erpPopupGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPopupGrid);
		$erp.initGridComboCell(erpPopupGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid, '<spring:message code="grid.allRowCount" />');
		
		erpPopupGridDataProcessor = new dataProcessor();
		erpPopupGridDataProcessor.init(erpPopupGrid);
		erpPopupGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpPopupGrid);
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid, 100);
		
	}
	
	function searchErpPopupCustmr(){
		
		var search_type = $('input[name=Search_Condition]:checked').val();
		erpLayout.progressOn();
		$.ajax({
			url : "/common/popup/getCustmrList.do"
			,data : {
				"KEY_WORD" : $("#txtSearch1").val()
				, "PUR_SALE_TYPE" : PUR_SALE_TYPE
				, "SEARCH_TYPE" : search_type
				, "USE_YN" : cmbUSE_YN.getSelectedValue()
			}
			,method : "POST"
			,dataType : "JSON"
				,success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						$erp.clearDhtmlXGrid(erpPopupGrid);
						var CustmrList = data.CustmrList;
						if($erp.isEmpty(CustmrList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpPopupGrid
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpPopupGrid.parse(CustmrList, 'js');
							
							if(!$erp.isEmpty(erpPopupCustmrOnRowSelect) && typeof erpPopupCustmrOnRowSelect === 'function'){
								erpPopupGrid.attachEvent("onRowDblClicked", erpPopupCustmrOnRowSelect);
							}
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	
	function adderpPopupGridData() {
		if(!$erp.isEmpty(window["erpPopupCustmrCheckList"]) && typeof window["erpPopupCustmrCheckList"] === 'function'){
			erpPopupCustmrCheckList(erpPopupGrid);
		}
	}
	
	function grupNameHidden(){
		var check_value =  $(":input:radio[name=Search_Condition]:checked").val();
		$erp.clearDhtmlXGrid(erpPopupGrid);
		if(check_value == "custmr"){
			erpPopupGrid.setColumnHidden(erpPopupGrid.getColIndexById("GRUP_NM"), true);
		}else {
			erpPopupGrid.setColumnHidden(erpPopupGrid.getColIndexById("GRUP_NM"), false);
		}
	}
	
	function initDhtmlXCombo(){
		cmbUSE_YN = $erp.getDhtmlXComboCommonCode('cmbUSE_YN', 'USE_YN',['USE_CD', 'YN'], 100, "모두조회", false, "Y");
	}
	
	function alertMessage(param){
		$erp.alertMessage(param);
	}
	
	function confirmMessage(param){
		$erp.confirmMessage(param);
	}
	
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="80px">
				<col width="210px">
				<col width="60px">
				<col width="*">
			</colgroup>
			<tr>
				<th></th>
				<td colspan="3">
					<div id="CUSTMR_TYPE"></div>
				</td>
			</tr>
			<tr>
				<th>검색어</th>
				<td>
					<input type="text" id="txtSearch1" size="25" maxlength="50" onkeyup="if(event.keyCode==13) searchErpPopupCustmr()">
				</td>
				<th>사용여부</th>
				<td>
					<div id="cmbUSE_YN"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>