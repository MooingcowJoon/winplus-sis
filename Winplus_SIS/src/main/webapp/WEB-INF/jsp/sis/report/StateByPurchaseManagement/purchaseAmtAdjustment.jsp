<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	LUI.exclude_auth_cd = "ALL,1";
// 	LUI.exclude_orgn_type = "PS,CS";
	
	var erpLayout;
	var erpRibbon;
	var erpDetailRibbon;
	var erpHeaderGridDataProcessor;
	var erpDetailGridDataProcessor;
	var erpHeaderGridColumns
	var erpDetailGridColumns;
	var erpHeaderGrid;
	var erpDetailGrid;
	var cmbORGN_CD;
	var cmbSLIP_TYPE;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpDetailRibbon();
		initErpHeadrGrid();
		initErpDetailGrid();
		
		initDhtmlXCombo();
		
		document.getElementById("searchDateFrom").value=today;
		document.getElementById("searchDateTo").value=today;
	});
	
	
	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "5E"
			, cells : [
				{id: "a", text: "검색조건영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "Header리본영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "Header그리드영역", header:false, fix_size : [true, true]}
				,{id: "d", text: "Detail리본영역", header:false, fix_size : [true, true]}
				,{id: "e", text: "Detail그리드영역", header:false, fix_size : [true, true]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_search");
		erpLayout.cells("a").setHeight($erp.getTableHeight(2));
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_header_grid");
		erpLayout.cells("c").setHeight(280);
		erpLayout.cells("d").attachObject("div_erp_detail_ribbon");
		erpLayout.cells("d").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("e").attachObject("div_erp_detail_grid");
		
		erpLayout.setSeparatorSize(0, 0);
		erpLayout.setSeparatorSize(1, 1);
		erpLayout.setSeparatorSize(2, 1);
		erpLayout.setSeparatorSize(3, 2);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpHeaderGrid.setSizes();
			erpDetailGrid.setSizes();
		});
	}
	
	<%-- erpRibbon 초기화 Function --%>	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpHeaderGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpHeaderGrid"){
				isHeaderValidationCheck();
			}
		});
	}
	
	
	function initErpHeadrGrid(){
		erpHeadrGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_CD", label:["조직명", "#rspan"], type: "combo", width: "90", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : "ORGN_CD"}
			, {id : "CUSTMR_NM", label:["협력사", "#rspan"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "DATE", label:["일자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "TOT_GOODS_NM", label:["상품명", "#rspan"], type: "ro", width: "350", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "TOT_AMT", label:["금액", "#rspan"], type: "ron", width: "120", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat: "0,000"}
			, {id : "CONF_AMT", label:["확정금액", "#rspan"], type: "ron", width: "120", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat: "0,000"}
			, {id : "PUR_SLIP_CD", label:["거래코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "ORGN_DIV_CD", label:["조직구분코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "center", isHidden : true, isEssential : false}
		];
		
		erpHeaderGrid = new dhtmlXGridObject({
			parent: "div_erp_header_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpHeadrGridColumns
		});
		$erp.attachDhtmlXGridFooterSummary(erpHeaderGrid
				, ["TOT_AMT"
				,"CONF_AMT"]
				,1
				,"합계");
		erpHeaderGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpHeaderGrid);
		$erp.initGridComboCell(erpHeaderGrid);
		$erp.attachDhtmlXGridFooterPaging(erpHeaderGrid, 10);
		$erp.attachDhtmlXGridFooterRowCount(erpHeaderGrid, '<spring:message code="grid.allRowCount" />');
		
		erpHeaderGrid.attachEvent("onRowDblClicked", function(rId){
			var paramGridData = {};
			paramGridData["PUR_SLIP_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("PUR_SLIP_CD")).getValue();
			paramGridData["ORGN_DIV_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORGN_DIV_CD")).getValue();
			paramGridData["ORGN_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORGN_CD")).getValue();
			searchErpDetailGrid(paramGridData);
		});
		
		erpHeaderGridDataProcessor = new dataProcessor();
		erpHeaderGridDataProcessor.init(erpHeaderGrid);
		erpHeaderGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpHeaderGrid);
	}
	
	function initErpDetailRibbon(){
		erpDetailRibbon = new dhtmlXRibbon({
			parent : "div_erp_detail_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}
			]
		});
		
		erpDetailRibbon.attachEvent("onClick", function(itemId, bId){
			 if(itemId == "save_erpGrid") {
					saveGridData();
				}
		});
	}
	
	function initErpDetailGrid(){
		erpDetailGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "PUR_TYPE", label:["상품유형", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["SLIP_TYPE"]}
			, {id : "PUR_QTY", label:["수량", "#rspan"], type: "ro", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "PAY_SUM_AMT", label:["금액", "#rspan"], type: "ron", width: "120", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat: "0,000"}
			, {id : "CONF_AMT_DETL", label:["확정금액", "#rspan"], type: "edn", width: "120", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat: "0,000", isSelectAll: true}
			, {id : "PUR_SLIP_CD", label:["매입코드", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "ORGN_DIV_CD", label:["조직구분코드", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : true, isEssential : false}
			];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpDetailGridColumns
		});
		
		$erp.attachDhtmlXGridFooterSummary(erpDetailGrid
				, ["PUR_QTY"
				,"PAY_SUM_AMT"
				,"CONF_AMT_DETL"]
				,1
				,"합계");
		erpDetailGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpDetailGrid);
		$erp.initGridComboCell(erpDetailGrid);
		$erp.attachDhtmlXGridFooterPaging(erpDetailGrid, 30);
		$erp.attachDhtmlXGridFooterRowCount(erpDetailGrid, '<spring:message code="grid.allRowCount" />');
		
		erpDetailGrid.enableAccessKeyMap(true);
		erpDetailGrid.enableColumnMove(true);
		erpDetailGridDataProcessor = new dataProcessor();
		erpDetailGridDataProcessor.init(erpDetailGrid);
		erpDetailGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpDetailGrid);
		
		erpDetailGrid.attachEvent("onEnter", function(rId, Ind){
			var tmpRowIndex = this.getRowIndex(rId);
			if(!(this.getRowId((tmpRowIndex+1)) == null || this.getRowId((tmpRowIndex+1)) == "null" || this.getRowId((tmpRowIndex+1)) == undefined || this.getRowId((tmpRowIndex+1)) == "undefined" )){
				this.selectCell(tmpRowIndex+1,Ind,false,true,true);
			}
		});
	}
	
	function isHeaderValidationCheck(){
		var from = $("#searchDateFrom").val();
		var to = $("#searchDateTo").val();
		var a = from.replace(/-/gi,'')
		var b = to.replace(/-/gi,'')
		var fromToDate = b - a
		
		if (fromToDate < 0) {
			$erp.alertMessage({
				"alertMessage" : "날짜를 다시 지정해주세요.",
				"alertType" : "alert",
				"isAjax" : false
			});
		}else{
			searchHeaderGrid();
				}
	}
	
	function searchHeaderGrid() {
		erpLayout.progressOn();
		
		if($('#ck_Custmr').is(":checked") == true){
			CUSTMR_CD = document.getElementById("hidCustmr_CD").value;
		} else {
			CUSTMR_CD = "";
		}
		
		var searchDateFrom = document.getElementById("searchDateFrom").value;
		var searchDateTo = document.getElementById("searchDateTo").value;
		var orgn_cd = cmbORGN_CD.getSelectedValue();
		var from =  searchDateFrom.replace(/-/gi,'');
		var to =  searchDateTo.replace(/-/gi,'');
		var CUSTMR_CD = CUSTMR_CD;
		var SLIP_TYPE = cmbSLIP_TYPE.getSelectedValue();
		
		$.ajax({
			url : "/sis/report/PurchaseManagement/getPurchaseAmtAdjustment.do"
			,data : {
				"searchDateFrom" : from
				,"searchDateTo" : to
				,"orgnCd" : orgn_cd
				,"CUSTMR_CD" : CUSTMR_CD
				,"SLIP_TYPE" : SLIP_TYPE
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				if(data.isError){
					erpLayout.progressOff();
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpHeaderGrid);
					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						erpLayout.progressOff();
						$erp.addDhtmlXGridNoDataPrintRow(
								erpHeaderGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpLayout.progressOff();
						erpHeaderGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpHeaderGrid);
				$erp.setDhtmlXGridFooterSummary(erpHeaderGrid
						, ["TOT_AMT"
						,"CONF_AMT"]
						,1
						,"합계");
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function searchErpDetailGrid(paramGridData){
		erpLayout.progressOn();
		$.ajax({
			url: "/sis/report/PurchaseManagement/getPurchaseAmtDetailAdjustment.do"
			, data : paramGridData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpLayout.progressOn();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpDetailGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpDetailGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
				$erp.setDhtmlXGridFooterSummary(erpDetailGrid
						, ["PUR_QTY"
						,"PAY_SUM_AMT"
						,"CONF_AMT_DETL"]
						,1
						,"합계");
				erpLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
		cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, LUI.LUI_orgn_cd);
				cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
					cmbORGN_CD.unSelectOption();
					cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			});
		});
		
		$('#Custmr_Search').attr("disabled", true);
		cmbSLIP_TYPE = $erp.getDhtmlXComboCommonCode("cmbSLIP_TYPE", "SLIP_TYPE", "SLIP_TYPE", 100, "모두조회", false);
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	function openSearchCustmrGridPopup() {
		var pur_sale_type = "1"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		var onRowSelect = function(id, ind) {			
			custmr_cd = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("hidCustmr_CD").value = custmr_cd;
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			$erp.closePopup2("openSearchCustmrGridPopup");
		};
		
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	function saveGridData(){
		var gridData = {};
		var rId = erpHeaderGrid.getSelectedRowId();
		if(rId == null){
			$erp.alertMessage({
				"alertMessage" : "상단의 구매내역을 선택 해 주세요.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false,
			});
		}
		gridData["PUR_SLIP_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("PUR_SLIP_CD")).getValue();
		gridData["ORGN_DIV_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORGN_DIV_CD")).getValue();
		gridData["ORGN_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORGN_CD")).getValue();
		
		if(erpDetailGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpDetailGrid);
		$.ajax({
			url : "/sis/report/PurchaseManagement/savePurchaseAmtAdjustment.do" 
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var alertMessage = "저장이 완료되었습니다.";
					$erp.alertMessage({
						"alertMessage" : alertMessage,
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : searchErpDetailGrid(gridData)
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function checkboxYN(checkedNM) {
		if(checkedNM == 'custmr') {
			if($('#ck_Custmr').is(":checked") == true) {
				$('#Custmr_Search').attr("disabled", false);
			} else {
				$('#Custmr_Search').attr("disabled", true);
			}
		}
	}
</script>
</head>
<body>
	<div id="div_erp_search" class="samyang_div" style="display:none">
		<div id="div_erp_table" class="samyang_div">
			<table class="table">
				<colgroup>
					<col width="80px">
					<col width="230px">
					<col width="80px">
					<col width="230px">
					<col width="80px">
					<col width="*">
				</colgroup>
				<tr>
					<th>법인구분</th>
					<td>
						<div id="cmbORGN_DIV_CD"></div>
					</td>
					<th>조직명</th>
					<td colspan="3">
						<div id="cmbORGN_CD"></div>
					</td>
				</tr>
				<tr>
					<th>기 간</th>
					<td>
						<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_calendar default_date input_essential">
						<span style="float: left;">&nbsp;~&nbsp;</span> <input type="text" id="searchDateTo" name="searchDateTo" class="input_calendar default_date input_essential">
					</td>
					<th><input type="checkbox" id="ck_Custmr" name="ck_Custmr" onclick="checkboxYN('custmr');" style="float: center;"/><label for="ck_Custmr">협력사</label></th>
					<td>
						<input type="hidden" id="hidCustmr_CD">
						<input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled"/>
						<input type="button" id="Custmr_Search" value="검 색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/>
					</td>
					<th>상품유형</th>
					<td>
						<div id="cmbSLIP_TYPE"></div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_header_grid" class="div_grid_full_size" style="display:none"></div>
	<div id="div_erp_detail_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_detail_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>