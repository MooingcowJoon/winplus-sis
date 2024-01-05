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

	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var crud;
	var cmbORGN_CD;
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	

	$(document).ready(function(){
		
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		
		document.getElementById("searchDateFrom").value=todayDate;
		document.getElementById("searchDateTo").value=today;
		
		$erp.asyncObjAllOnCreated(function(){
			
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "검색조건", header: false}
				, {id : "b", text: "리본내역", header: false}
				, {id : "c", text: "그리드내역", header: false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight(100);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		erpLayout.setSeparatorSize(1, 1);
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	function initErpRibbon() {
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
			if(itemId == "search_erpGrid") {
				if(document.getElementById("hidGOODS_CATEG_CD").value == ""){
					$erp.alertMessage({
						"alertMessage" : "error.sis.goods.search.grup_nm.empty"
						, "alertType" : "error"
					});
				}
				else{
					searchCheck();
				}
			}else if(itemId == "excel_erpGrid") {
				$erp.exportGridToExcel({
					"grid" : erpGrid
					, "fileName" : "점포업무관리 - 특매판매내역"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["순번", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "CUSTMR_NM", label:["협력사", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "220", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "NORM_PROF_AMT", label:["정상이익액", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "NORM_PROF_RATE", label:["정상이익율", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false , numberFormat : "00.00%"}
			, {id : "EVENT_PUR_PRICE", label:["특매매입액", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "EVENT_GOODS_PRICE", label:["특매판매액", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "EVENT_PROF_AMT", label:["특매이익액", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "EVENT_PROF_RATE", label:["특매이익율", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false , numberFormat : "00.00%"}
			, {id : "EVENT_GOODS_SALE_QTY", label:["할인수", "#rspan"], type: "ro", width: "60", sort : "int", align : "right", isHidden : false, isEssential : true }
			, {id : "DC_AMT", label:["할인액", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "EVENT_TYPE", label:["특매그룹 속성", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["PRIORITY_EVENT_YN"]}
			,	{id : "EVENT_NM", label:["특매그룹명", "#rspan"], type: "ro", width: "220", sort : "str", align : "left", isHidden : false, isEssential : true} 
			, {id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "right", isHidden : true, isEssential : false }
			, {id : "EVENT_CD", label:["특매코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "right", isHidden : true, isEssential : false }
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		
		erpGrid.enableDistributedParsing(true, 100, 50);
		erpGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		
		erpGrid.attachEvent("onRowDblClicked",function(rId,cInd){
			crud = "U";
			openGoodsInformationPopup();
		});
		
		crud = "R";
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- erpGrid 조회 확인 Function --%>
	function searchCheck(){
		var alertMessage = '<spring:message code="alert.sis.goods.searchCheck" />';
		var alertType = "alert";
		var callbackFunction = function(){
			searchErpGrid();
		}
		
		var GRUP_CD = document.getElementById("hidGOODS_CATEG_CD").value;
		
		if(GRUP_CD == "ALL"){
			$erp.confirmMessage({
				"alertMessage" : alertMessage
				, "alertType" : alertType
				, "alertCallbackFn" : callbackFunction
			});
		}else{
			searchErpGrid();
		}
		
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		
		var alertMessage = "";
		var alertType = "error";
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
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
		
		if($('#ck_Custmr').is(":checked") == true){
			CUSTMR_CD = document.getElementById("hidCustmr_CD").value;
		} else {
			CUSTMR_CD = "";
		}
		
		if($('#Set_Goods').is(":checked") == true){
			EVENT_NM = document.getElementById("Set_GoodsNM").value;
			EVENT_CD = document.getElementById("Set_GoodsCD").value;
		} else {
			EVENT_NM = "";
			EVENT_CD = "";
		}
		
		var paramData = {};
		paramData["SEARCH_DATE_FROM"] = document.getElementById("searchDateFrom").value;
		paramData["SEARCH_DATE_TO"] = document.getElementById("searchDateTo").value;
		paramData["CUSTMR_CD"] = CUSTMR_CD;
		paramData["GRUP_CD"] = document.getElementById("hidGOODS_CATEG_CD").value;
		paramData["EVENT_NM"] = EVENT_NM;
		paramData["EVENT_CD"] = EVENT_CD;
		paramData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		
		$.ajax({
			url: "/sis/market/getBargainSalesHistory.do"
			, data : paramData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							,'<spring:message code="grid.noSearchData" />'
						);
					}else {
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
	<%-- erpGrid 조회 Function 끝--%>
	
	<%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
	function openGoodsCategoryTreePopup() {
		var onClick = function(id) {
			document.getElementById("hidGOODS_CATEG_CD").value = id;
			document.getElementById("GoodsGroup_Name").value = this.getItemText(id);
	
			$erp.closePopup2("openGoodsCategoryTreePopup");
		}
		$erp.openGoodsCategoryTreePopup(onClick);
	}
	
	<%-- openSearchCustmrGridPopup 공급사 조회 팝업 열림 Function --%>
	function openSearchCustmrGridPopup(){
				var pur_sale_type = "1";
				var onRowSelect = function(id, ind) {
					document.getElementById("hidCustmr_CD").value = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
					document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
					
					$erp.closePopup2("openSearchCustmrGridPopup");
				}
				$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
		}
	
	<%-- openGoodsInformationPopup 상품정보 팝업 열림 Function --%>
		function openGoodsInformationPopup() {
			var selectedRow = erpGrid.getSelectedRowId();
			var goods_no = null;
			if(selectedRow != null){
				goods_no = erpGrid.cells(selectedRow,erpGrid.getColIndexById("GOODS_NO")).getValue();
			}
			$erp.openGoodsInformationPopup({"GOODS_NO" : goods_no, "CRUD" : crud});
		}
		
	<%-- openBargainGroupPointPopup 특매그룹선택 팝업 열림 Function --%>
		function openBargainGroupPointPopup(){
			var onRowDblClicked = function(id, ind) {
				document.getElementById("Set_GoodsCD").value = this.cells(id, this.getColIndexById("EVENT_CD")).getValue();
				document.getElementById("Set_GoodsNM").value = this.cells(id, this.getColIndexById("EVENT_NM")).getValue();
				
				$erp.closePopup2("openBargainGroupPointPopup");
			}
			$erp.openBargainGroupPointPopup(onRowDblClicked);
		}
		
	<%-- dhtmlxCombo 초기화 Function 시작--%>
	function initDhtmlXCombo(){
		$('#Custmr_Search').attr("disabled", true);
		$('#Set_GoodsNM').attr("disabled", true);
		
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",");
		var searchable = 1;
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
				searchable = 2;
			}
		}
		
		 if(searchable == 2 ){
			 cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK"], 100, "모두조회", false, LUI.LUI_orgn_cd);
		} else {
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 90, null, false, LUI.LUI_orgn_cd);
		}
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
	
	function checkboxYN(checkedNM) {
		if(checkedNM == 'custmr') {
			if($('#ck_Custmr').is(":checked") == true) {
				$('#Custmr_Search').attr("disabled", false);
			} else {
				$('#Custmr_Search').attr("disabled", true);
			}
		}
	}
	
	function checkboxBargainYN(checkedNM){
		if(checkedNM == 'group') {
			if($('#Set_Goods').is(":checked") == true) {
				$('#Set_GoodsNM').attr("disabled", true);
				openBargainGroupPointPopup();
			} 
		}
	}
</script>
</head>
<body>
<div id="div_erp_table" class="samyang_div" style="display:none">
	<table id="tb_data" class="table_search">
		<colgroup>
			<col width="70px;">
			<col width="270px;">
			<col width="*">
		</colgroup>
			<tr>
				<th>조직명</th>
				<td>
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
	</table>
	<table id="tb_erp_data" class="table_search">
	<colgroup>
		<col width="70px;">
			<col width="270px;">
			<col width="70px">
			<col width="270px">
			<col width="*">
		</colgroup>
		<tr>
			<th>상품분류</th>
			<td>
				<input type="hidden" id="hidGOODS_CATEG_CD" value="ALL">
				<input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" disabled="disabled" value="전체분류"/>
				<input type="button" id="GoodsGroup_Search" value="검색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
			</td>
			<th><input type="checkbox" id="ck_Custmr" name="ck_Custmr" onclick="checkboxYN('custmr');" style="float: center;"/>협력사</th>
			<td>
				<input type="hidden" id="hidCustmr_CD">
				<input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled"/>
				<input type="button" id="Custmr_Search" value="검색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/>
			</td>
		</tr>
	</table>
	<table id="tb_erp_data2" class="table_search">  
		<colgroup>
			<col width="70px;">
			<col width="100px;">
			<col width="15px">
			<col width="133px">
			<col width="30px">
			<col width="*px">
		</colgroup>
		<tr>
			<th>기간</th>
			<td>
				<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
			</td>
			<td>~</td>
			<td> 
				<input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
			</td>
			<th></th>
			<td>
				<input type="hidden" id="Set_GoodsCD">
				<input type="checkbox" id="Set_Goods" name="Set_Goods" onclick="checkboxBargainYN('group');"/>
				<label for="Set_Goods">특매그룹지정</label>
				<input type="text" id="Set_GoodsNM" name="Set_Goods" disabled="disabled" />
			</td>
		</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>