<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js?ver=27"></script>
<script type="text/javascript">
	<%--
	
		■ supplyCheck.jsp					유통사업 업무 - 판매 - 매출 - 거래내역(고객사)_조회
		
		■ supplyCheckByCenter.jsp			센터/구매 업무 - 판매 - 판매내역(센터)_조회
		
		■ 조회시 같은 메소드로 매핑되므로 수정 시 유의
	
	--%>
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,5,6";		//searchable 권한 뺄 공통코드 
	LUI.exclude_orgn_type = "OT,MK,PS,CS";	//div1 뺄 data

	var erpLayout;
	var erpRibbon;
	var erpHeaderGrid;
	var erpHeaderGridColumns;
	var erpGridDataProcessor;
	var erpDetailGridDataProcessor;
	var erpDetailGrid;
	var erpDetailGridColumns;
	var cmbORGN_CD;
	var cmbREG_TYPE;
	
	$(document).ready(function(){
		initErpLayout();
		initDhtmlXCombo();
		initErpRibbon();
		initErpHeaderGrid();
		initErpDetailGrid();
		
		$erp.asyncObjAllOnCreated(function(){
			cmbORGN_DIV_CD.deleteOption("C04");
		});
	});
	
	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "4E"
			, cells : [
				{id: "a", text: "검색조건영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "Header리본영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "Header그리드영역", header:false, fix_size : [true, true]}
				,{id: "d", text: "Detail그리드영역", header:false, fix_size : [true, true]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_search");
		erpLayout.cells("a").setHeight(65);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_header_grid");
		erpLayout.cells("c").setHeight(205);
		erpLayout.cells("d").attachObject("div_erp_detail_grid");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpHeaderGrid.setSizes();
			erpDetailGrid.setSizes();
		});
	}
	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpHeaderGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 					,{id : "save_erpHeaderGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					,{id : "excel_erpHeaderGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					,{id : "print_erpHeaderGrid", type : "button", text:'거래명세서출력', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpHeaderGrid"){
				isSearchVlidate();
			} else if(itemId == "save_erpHeaderGrid") {
				saveGridData();
			}else if (itemId == "excel_erpHeaderGrid"){
				$erp.exportGridToExcel({
					"grid" : erpDetailGrid
					, "fileName" : "판매입력"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			}else if (itemId == "print_erpHeaderGrid"){
				printTradeStatement();
			}
		});
	}
	
	function initErpHeaderGrid(){
		erpHeaderGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox"  , "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false,isDataColumn : false}
			, {id : "ORGN_DIV_CD", label:["법인구분", "#rspan"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_DIV_CD"]}
			, {id : "ORGN_CD", label:["조직명", "#rspan"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD","CT,PM"]}
			, {id : "CUSTMR_NM", label:["고객사", "#rspan"], type: "ro", width: "110", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ORD_DATE", label:["일자", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "CUSTMR_CD", label:["고객사코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "ORD_CD", label:["납품코드", "#rspan"], type: "ro", width: "160", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "TOT_GOODS_NM", label:["납품상품", "#rspan"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "SALE_AMT", label:["판매금액(공급가액)", "#rspan"], type: "edn", width: "120", sort : "int", align : "right", isHidden : false, isEssential : true, isDisabled : true, numberFormat: "0,000"}
			, {id : "SALE_VAT_AMT", label:["부가세액", "#rspan"], type: "edn", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true, isDisabled : true, numberFormat: "0,000"}
			, {id : "SALE_TOT_AMT", label:["합계금액", "#rspan"], type: "edn", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true, isDisabled : true, numberFormat: "0,000"}
		];
		
		erpHeaderGrid = new dhtmlXGridObject({
			parent: "div_erp_header_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpHeaderGridColumns
		});
		
		erpHeaderGrid.enableDistributedParsing(true, 100, 50);
		var text_style = "text-align:right; font-weight:bold; font-style:normal";
		var tot_style = "text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;";
		erpHeaderGrid.attachFooter("합계,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,<div id='Sum_Sale_Amt'>0</div>,<div id='Sum_Vat_Amt'>0</div>,<div id='Sum_Tot_Amt'>0</div>",[tot_style,"","","","","","","",text_style,text_style,text_style]);
		$erp.initGridCustomCell(erpHeaderGrid);
		$erp.initGridComboCell(erpHeaderGrid);
		$erp.attachDhtmlXGridFooterPaging(erpHeaderGrid, 5);
		$erp.attachDhtmlXGridFooterRowCount(erpHeaderGrid, '<spring:message code="grid.allRowCount" />');
		
		erpHeaderGrid.attachEvent("onRowDblClicked", function(rId){
			var paramData = {};
			paramData["CUSTMR_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("CUSTMR_CD")).getValue();
			paramData["searchDate"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORD_DATE")).getValue();
			paramData["ORGN_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORGN_CD")).getValue();
			paramData["ORD_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORD_CD")).getValue();
			searchErpDetailGrid(paramData);
		});
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpHeaderGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpHeaderGrid);
	}
	
	function initErpDetailGrid(){
		erpDetailGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "CUSTMR_CD", label:["거래처코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "ORD_CD", label:["거래코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "SALE_QTY", label:["수량", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true}
			, {id : "REG_TYPE", label:["판매유형", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false,  isDisabled : true, commonCode : ["SALES_OR_RETURNS"]}
			, {id : "SALE_AMT", label:["판매금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat:"0,000"}
			, {id : "SALE_VAT_AMT", label:["부가세액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat:"0,000"}
			, {id : "SALE_TOT_AMT", label:["합계금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat:"0,000"}
		];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpDetailGridColumns
		});
		erpDetailGrid.enableDistributedParsing(true, 100, 50);
		var text_style = "text-align:right; font-weight:bold; font-style:normal";
		var tot_style = "text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;";
		erpDetailGrid.attachFooter("합계,#cspan,#cspan,#cspan,#cspan,#cspan,<div id='Sum_Detail_Sale_Amt'>0</div>,<div id='Sum_Detail_Vat_Amt'>0</div>,<div id='Sum_Detail_Tot_Amt'>0</div>",[tot_style,"","","","","",text_style,text_style,text_style]);
		$erp.initGridCustomCell(erpDetailGrid);
		$erp.initGridComboCell(erpDetailGrid);
		$erp.attachDhtmlXGridFooterPaging(erpDetailGrid, 30);
		$erp.attachDhtmlXGridFooterRowCount(erpDetailGrid, '<spring:message code="grid.allRowCount" />');
		
		erpDetailGridDataProcessor = new dataProcessor();
		erpDetailGridDataProcessor.init(erpDetailGrid);
		erpDetailGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpDetailGrid);
	}
	
	function initDhtmlXCombo() {
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, LUI.LUI_orgn_cd);
				cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
					cmbORGN_CD.unSelectOption();
					cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			});
		});
		$('#Custmr_Search').attr("disabled", true);
		cmbREG_TYPE = $erp.getDhtmlXComboCommonCode("REG_TYPE","cmbREG_TYPE", ["SALES_OR_RETURNS"],120,"모두조회", false);
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
	function openSearchCustmrGridPopup() {
		var pur_sale_type = "2"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		var onRowSelect = function(id, ind) {
			custmr_cd = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("hidCustmr_CD").value = custmr_cd;
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	function calculateFooterValues(gridDataCount){
		var nrQ = document.getElementById("Sum_Sale_Amt");
		var srQ = document.getElementById("Sum_Vat_Amt");
		var nrS = document.getElementById("Sum_Tot_Amt");
		if(gridDataCount == 0){
			nrQ.innerHTML = moneyType("0");
			srQ.innerHTML = moneyType("0");
			nrS.innerHTML = moneyType("0");
		} else {
			nrQ.innerHTML = moneyType(sumColumn(erpHeaderGrid.getColIndexById("SALE_AMT")));
			srQ.innerHTML = moneyType(sumColumn(erpHeaderGrid.getColIndexById("SALE_VAT_AMT")));
			nrS.innerHTML = moneyType(sumColumn(erpHeaderGrid.getColIndexById("SALE_TOT_AMT")));
		}
	}
	
	function calculateDetailFooterValues(gridDataCount){
		var nrQ = document.getElementById("Sum_Detail_Sale_Amt");
		var srQ = document.getElementById("Sum_Detail_Vat_Amt");
		var nrS = document.getElementById("Sum_Detail_Tot_Amt");
		if(gridDataCount == undefined || gridDataCount == null || gridDataCount == 0){
			nrQ.innerHTML = moneyType("0");
			srQ.innerHTML = moneyType("0");
			nrS.innerHTML = moneyType("0");
		} else {
			nrQ.innerHTML = moneyType(sumDetailColumn(erpDetailGrid.getColIndexById("SALE_AMT")));
			srQ.innerHTML = moneyType(sumDetailColumn(erpDetailGrid.getColIndexById("SALE_VAT_AMT")));
			nrS.innerHTML = moneyType(sumDetailColumn(erpDetailGrid.getColIndexById("SALE_TOT_AMT")));
		}
	}
	
	function moneyType(amt){
		return amt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function sumColumn(ind){
		var RowIds = "";
		RowIds = erpHeaderGrid.getAllRowIds();
		var arrayRowIds = [];
		arrayRowIds = RowIds.split(",");
		var out = 0;
		for(var i = 0 ;i < arrayRowIds.length ; i++){
			if(erpHeaderGrid.cells(arrayRowIds[i],ind).getValue() == ""){
				erpHeaderGrid.cells(arrayRowIds[i],ind).setValue("0");
			}
			out+= parseFloat(erpHeaderGrid.cells(arrayRowIds[i],ind).getValue());
		}
		return out;
	}
	
	function sumDetailColumn(ind){
		var RowIds = "";
		RowIds = erpDetailGrid.getAllRowIds();
		var arrayRowIds = [];
		arrayRowIds = RowIds.split(",");
		var out = 0;
		for(var i = 0 ;i < arrayRowIds.length ; i++){
			out+= parseFloat(erpDetailGrid.cells(arrayRowIds[i],ind).getValue());
		}
		return out;
	}
	
	function isSearchVlidate(){
		var searchDateFrom = $("#searchDateFrom").val();
		var searchDateTo = $("#searchDateTo").val();
		var searchCustmr = $("#hidCustmr_CD").val();
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(searchDateFrom) || $erp.isEmpty(searchDateTo)){
			isValidated = false;
			alertMessage = "error.common.date.empty3";
			alertCode = "-1";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		} else {
			searchHeaderGrid();
		}
	}
	
	function searchHeaderGrid() {
		if($('#ck_Custmr').is(":checked") == true){
			CUSTMR_CD = document.getElementById("hidCustmr_CD").value;
		} else {
			CUSTMR_CD = "";
		}
		var paramData = {};
		paramData["searchDateFrom"] = document.getElementById("searchDateFrom").value;
		paramData["searchDateTo"] = document.getElementById("searchDateTo").value;
		paramData["ORGN_DIV_CD"] = cmbORGN_DIV_CD.getSelectedValue();
		paramData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		paramData["REG_TYPE"] = cmbREG_TYPE.getSelectedValue();
		paramData["CUSTMR_CD"] = CUSTMR_CD;
		
		var search_date_from = document.getElementById("searchDateFrom").value;
		var search_date_to = document.getElementById("searchDateTo").value;
		var date_from = search_date_from.replace(/\-/g,'');
		var date_to = search_date_to.replace(/\-/g,'');
		
		if(date_from <= date_to){
			erpLayout.progressOn();
			$.ajax({
				url: "/sis/sales/salesManagementCenter/getSuprBySupplyHeaderList.do"
				, data : paramData
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						erpLayout.progressOff();
						$erp.clearDhtmlXGrid(erpHeaderGrid);
						$erp.clearDhtmlXGrid(erpDetailGrid);
						calculateDetailFooterValues();
						var gridDataList = data.dataMap;
						var gridDataCount = gridDataList.length
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpHeaderGrid
								,  '<spring:message code="grid.noSearchData" />'
							);
							calculateFooterValues(gridDataCount);
						}else {
							erpHeaderGrid.parse(gridDataList, 'js');
							calculateFooterValues(gridDataCount);
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpHeaderGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}else{
			$erp.alertMessage({
				"alertMessage" : "날짜를 다시 지정해주세요."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
		}
	}
	
	function searchErpDetailGrid(paramData){
		erpLayout.progressOn();
		$.ajax({
			url: "/sis/sales/salesManagementCenter/getSuprBySupplyDetailList.do"
			, data : paramData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					erpLayout.progressOff();
					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.dataMap;
					var gridDataCount = gridDataList.length
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpDetailGrid
							,  '<spring:message code="grid.noSearchData" />'
						);
						calculateDetailFooterValues(gridDataCount);
					}else {
						erpDetailGrid.parse(gridDataList, 'js');
						calculateDetailFooterValues(gridDataCount);
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function saveGridData() {
		if(erpDetailGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpDetailGrid);
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		var paramGrid = $erp.serializeDhtmlXGridData(erpDetailGrid);
		erpLayout.progressOn();
		$.ajax({
			url: "/sis/sales/salesManagementCenter/saveSuprBySupplyDetailInfo.do"
			, data : paramGrid
			, method : "POST"
			, dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					isSearchVlidate();
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function printTradeStatement(){
		var order_cd_list = "";
		var selected_custmr_cd = "";
		var selected_orgn_cd = "";
		var selected_search_date_from = $("#searchDateFrom").val();
		var selected_search_date_to = $("#searchDateTo").val();
		var check_rows = erpHeaderGrid.getCheckedRows(erpHeaderGrid.getColIndexById("CHECK"));
		var check_list = check_rows.split(",");
		
		if(check_rows == ""){
			$erp.alertMessage({
				"alertMessage" : "1건이상의 발주서를 선택 후 이용가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		} else {
		
			for(var i = 0 ; i < check_list.length ; i++){
				if(i == 0){
					order_cd_list += erpHeaderGrid.cells(check_list[i], erpHeaderGrid.getColIndexById("ORD_CD")).getValue();
					selected_custmr_cd += erpHeaderGrid.cells(check_list[i], erpHeaderGrid.getColIndexById("CUSTMR_CD")).getValue();
					selected_orgn_cd += erpHeaderGrid.cells(check_list[i], erpHeaderGrid.getColIndexById("ORGN_CD")).getValue();
				} else {
					order_cd_list += "," + erpHeaderGrid.cells(check_list[i], erpHeaderGrid.getColIndexById("ORD_CD")).getValue();
					selected_custmr_cd += "," + erpHeaderGrid.cells(check_list[i], erpHeaderGrid.getColIndexById("CUSTMR_CD")).getValue();
					selected_orgn_cd += "," + erpHeaderGrid.cells(check_list[i], erpHeaderGrid.getColIndexById("ORGN_CD")).getValue();
				}
			}
			
			var paramInfo = {
					"ORD_CD_LIST" : order_cd_list
					, "mrdPath" : "trade_statement_mrd"
					, "mrdFileName" : "trade_statement.mrd"
					, "CUSTMR_CD" : selected_custmr_cd
					, "ORGN_CD" : selected_orgn_cd
					, "SEARCH_DATE_FROM" : selected_search_date_from
					, "SEARCH_DATE_TO" : selected_search_date_to
			};
			
			var approvalURL = $CROWNIX_REPORT.openTradeStatement("", paramInfo, "거래명세서출력", "");
			var popObj = window.open(approvalURL, "trade_statement_popup", "width=900,height=1000");
			
			var frm = document.PrintTradeform;
			frm.action = approvalURL;
			frm.target = "trade_statement_popup";
			frm.submit();
		}
	}
	
</script>
</head>
<body>
	<form name="PrintTradeform" action="" method="post"></form>	
	<div id="div_erp_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="100px">
				<col width="220px">
				<col width="100px">
				<col width="220px">
				<col width="100px">
				<col width="220px">
				<col width="*px">
			</colgroup>
			<tr>
				<th>법인구분</th>
				<td><div id="cmbORGN_DIV_CD"></div></td>
				<th>조직명</th>
				<td><div id=cmbORGN_CD></div></td>
				<th>판매유형</th>
				<td>
					<div id="REG_TYPE"></div>
				</td>
			</tr>
			<tr>
				<th>기 간</th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_calendar default_date input_essential" data-position="(1)">
					~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_calendar default_date input_essential" data-position="">
				</td>
				<th><input type="checkbox" id="ck_Custmr" name="ck_Custmr" onclick="checkboxYN('custmr');" style="float: center;"/>고객사</th>
				<td>
					<input type="hidden" id="hidCustmr_CD">
					<input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Custmr_Search" value="검 색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_header_grid" class="div_grid_full_size" style="display:none"></div>
	<div id="div_erp_detail_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>