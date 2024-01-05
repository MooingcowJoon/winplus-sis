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
	var cmbGOODS_MODI_LOG_TYPE;
	var cmbPRIORITY_EVENT_YN;
	var cmbGOODS_STATE;
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
				{id: "a", text: "검색조건", header: false, fix_size:[false, true]}
				, {id : "b", text: "리본내역", header: false, fix_size:[false, true]}
				, {id : "c", text: "그리드내역", header: false, fix_size:[false, true]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight(135);
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
					, "fileName" : "점포업무관리 - 특매변경이력"
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
			{id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "MODI_TYPE", label:["변경내용", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "MODI_BEFR_VALUE", label:["변경전", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "MODI_AFTR_VALUE", label:["변경후", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "MODI_DATE", label:["변경일시", "#rspan"], type: "ro", width: "180", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "RESP_USER", label:["변경인", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "EVENT_TYPE", label:["특매그룹 속성", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["PRIORITY_EVENT_YN"]}
			, {id : "EVENT_NM", label:["특매그룹", "#rspan"], type: "ro", width: "220", sort : "str", align : "left", isHidden : false, isEssential : true}
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
		
	}
	<%-- ■ erpDetailGrid 관련 Function 끝 --%>
	
	<%-- erpGrid 조회 확인 Function --%>
	function searchCheck(){
		var alertMessage = '<spring:message code="alert.sis.goods.searchCheck" />';
		var alertType = "alert";
		var callbackFunction = function(){
			searchErpGrid();
		}
		
		var BCD_CD = $("#txtBCD_CD").val();
		var key_word = $("#txtKEY_WORD").val();
		var GRUP_CD = document.getElementById("hidGOODS_CATEG_CD").value;
		
		if(key_word == "" && GRUP_CD == "ALL" && BCD_CD == ""){
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
		} else {
			EVENT_NM = "";
		}
		
		var paramData = {};
		paramData["SEARCH_DATE_FROM"] = document.getElementById("searchDateFrom").value;
		paramData["SEARCH_DATE_TO"] = document.getElementById("searchDateTo").value;
		paramData["CUSTMR_CD"] = CUSTMR_CD;
		paramData["GRUP_CD"] = document.getElementById("hidGOODS_CATEG_CD").value;
		paramData["KEY_WORD"] = $("#txtKEY_WORD").val();
		paramData["BCD_CD"] = $("#txtBCD_CD").val();
		paramData["EVENT_TYPE"] = cmbPRIORITY_EVENT_YN.getSelectedValue();
		paramData["MODI_TYPE"] = cmbGOODS_MODI_LOG_TYPE.getSelectedValue();
		paramData["GOODS_STATE"] = cmbGOODS_STATE.getSelectedValue();
		paramData["EVENT_NM"] = EVENT_NM;
		paramData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		
		$.ajax({
			url: "/sis/market/getBargainChangeHistory.do"
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
							, '<spring:message code="grid.noSearchData" />'
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
	
	<%-- openBargainGroupPointPopup 특매그룹선택 팝업 열림 Function --%>
	function openBargainGroupPointPopup(){
		var onRowDblClicked = function(id, ind) {
			document.getElementById("Set_Goods").value = this.cells(id, this.getColIndexById("EVENT_CD")).getValue();
			document.getElementById("Set_GoodsNM").value = this.cells(id, this.getColIndexById("EVENT_NM")).getValue();
				
			$erp.closePopup2("openBargainGroupPointPopup");
		}
		$erp.openBargainGroupPointPopup(onRowDblClicked);
	}
	
	<%-- dhtmlXCombo 초기화 Function --%>
	function initDhtmlXCombo(){
		$('#Custmr_Search').attr("disabled", true);
		$('#Set_GoodsNM').attr("disabled", true);
		
		cmbPRIORITY_EVENT_YN = $erp.getDhtmlXCombo("cmbPRIORITY_EVENT_YN", "PRIORITY_EVENT_YN", "PRIORITY_EVENT_YN" , 160, "특매그룹 속성");
		cmbGOODS_MODI_LOG_TYPE = $erp.getDhtmlXCombo("cmbGOODS_MODI_LOG_TYPE", "GOODS_MODI_LOG_TYPE", "GOODS_MODI_LOG_TYPE", 160, "전체");
		
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
		
		cmbGOODS_STATE = new dhtmlXCombo("cmbGOODS_STATE");
		cmbGOODS_STATE.setSize(120);
		cmbGOODS_STATE.readonly(true);
		cmbGOODS_STATE.addOption([
				{value: "00", text: "전체상품" ,selected: true}
				,{value: "01", text: "과세상품"}
				,{value: "02", text: "면세상품"}
				,{value: "03", text: "수량상품"}
				,{value: "04", text: "중량상품"}
				,{value: "05", text: "직영상품"}
				,{value: "06", text: "수수료상품"}
				,{value: "07", text: "임대상품"}
			]);
		}
		<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
		
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
	<table id="tb_erp_data" class="table_search">
		<colgroup>
			<col width="85px;">
			<col width="250px;">
			<col width="80px">
			<col width="230px">
			<col width="50px">
			<col width="*">
		</colgroup>
		<tr>
			<th>조직명</th>
			<td>
				<div id = cmbORGN_CD></div>
			</td>
		</tr>
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
				<input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled" style="width:150px;"/>
				<input type="button" id="Custmr_Search" value="검색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/>
			</td>
			<th>검색어</th>
			<td>
				<input type="text" id="txtKEY_WORD" name="txtKEY_WORD" class="input_common" maxlength="10" onkeydown="$erp.onEnterKeyDown(event, searchCheck);"/>
			</td>
		</tr>
		</table>
	<table id="tb_erp_data2" class="table_search">  
		<colgroup>
			<col width="80px;">
			<col width="100px;">
			<col width="15px">
			<col width="145px">
			<col width="70px">
			<col width="215px;">
			<col width="70px;">
			<col width="*px">
		</colgroup>
		<tr>
			<th>변경일</th>
			<td>
				<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
			</td>
			<td>~</td>
			<td>
				<input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
			</td>
			<th>변경유형</th>
			<td>
				<div id="cmbGOODS_MODI_LOG_TYPE"></div>
			</td>
			<th>바코드</th>
			<td>
				<input type="text" id="txtBCD_CD" name="txtBCD_CD" class="input_common" maxlength="10" onkeydown="$erp.onEnterKeyDown(event, searchCheck);"/>
			</td>
		</tr>
	</table>
	<table id="tb_erp_data3" class="table_search">
		<colgroup>
			<col width="80px;">
			<col width="260px;">
			<col width="70px;">
			<col width="225px">
			<col width="70px;">
			<col width="145px">
			<col width="*px">
		</colgroup>
		<tr>
			<th><input type="checkbox" id="Set_Goods" name="Set_Goods" onclick="checkboxBargainYN('group');"/>특매그룹</th>
			<td>
				<input type="text" id="Set_GoodsNM" name="Set_Goods" disabled="disabled" style="width:200px;"/>
			</td>
			<th>속성</th>
			<td>
				<div id="cmbPRIORITY_EVENT_YN"></div>
			</td>
			<th>상품유형</th>
			<td>
				<div id="cmbGOODS_STATE"></div>
			</td>
		</tr>
	</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>