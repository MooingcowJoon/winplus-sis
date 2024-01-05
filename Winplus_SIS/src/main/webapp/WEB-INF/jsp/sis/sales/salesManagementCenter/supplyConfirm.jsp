<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js?ver=23"></script>
<script type="text/javascript">


	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,5,6";		//searchable 권한 뺄 공통코드 
	LUI.exclude_orgn_type = "OT,MK,PS,CS";	//div1 뺄 data

	var search_arr = LUI.LUI_searchable_auth_cd.split(",");
	var exclude_arr = LUI.exclude_auth_cd.split(",");
	for(var i=0;i<search_arr.length;i++){
		for(var j=0;j<exclude_arr.length;j++){
			if(search_arr[i] == exclude_arr[j]){
				search_arr.splice(i,1)
			}
		}
	}
	LUI.LUI_searchable_auth_cd = search_arr.join(",");
	
	var erpLayout;
	var erpRibbon;
	var erpDetailRibbon;
	var erpGridDataProcessor;
	var erpHeaderGridColumns
	var erpDetailGridColumns;
	var erpHeaderGrid;
	var erpDetailGrid;
	var cmbORGN_CD;
	var cmbSALES_OR_RETURNS;
	var ord_dateList="";
	
	$(document).ready(function(){
		initErpLayout();
		initDhtmlXCombo();
		initErpRibbon();
		initErpHeadrGrid();
		initErpDetailRibbon();
		initErpDetailGrid();
		
		$erp.asyncObjAllOnCreated(function(){
			cmbORGN_DIV_CD.deleteOption("C04");
		});
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
		erpLayout.cells("a").setHeight(64);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_header_grid");
		erpLayout.cells("c").setHeight(205);
		erpLayout.cells("d").attachObject("div_erp_detail_ribbon");
		erpLayout.cells("d").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("e").attachObject("div_erp_detail_grid");
		
		erpLayout.setSeparatorSize(1, 1);
		erpLayout.setSeparatorSize(2, 1);
		erpLayout.setSeparatorSize(3, 2);
		
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
					,{id : "apply_erpHeaderGrid", type : "button", text:'승인', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : true}
					,{id : "delete_erpHeaderGrid", type : "button", text:'취소', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					,{id : "excel_erpHeaderGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					,{id : "print_erpDetailGrid",  type : "button", text:'판매현황 출력', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif",   disable : true}		
					,{id : "print_Custmr_Management",  type : "button", text:'마감장 출력', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif",   disable : true}		
					,{id : "print_trade_statement",  type : "button", text:'거래명세서 출력', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif",   disable : true}		
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpHeaderGrid"){
				isSearchValidate();
			} else if(itemId == "apply_erpHeaderGrid") {
				isValidateHeaderUpdate("approval");
			} else if (itemId == "delete_erpHeaderGrid"){
				isValidateHeaderUpdate("cancle");
			} else if (itemId == "excel_erpHeaderGrid"){
				$erp.exportGridToExcel({
					"grid" : erpHeaderGrid
					, "fileName" : "판매확정"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			} else if (itemId == "print_erpDetailGrid"){
				if(document.getElementById("hidCustmr_CD").value == ""){
					$erp.alertMessage({
						"alertMessage" : "고객사 선택 후 출력 가능합니다."
						, "alertCode" : null
						, "alertType" : "alert"
						, "isAjax" : false
					});
				}else{
					printDetailGrid();
				}
			} else if (itemId == "print_Custmr_Management"){
				var gridData = erpHeaderGrid.getAllRowIds();
				if(gridData == ""){
					$erp.alertMessage({
						"alertMessage" : "조회 후 출력이 가능합니다.",
						"alertType" : "alert",
						"isAjax" : false
					});
				}else if(gridData == "NoDataPrintRow"){
					$erp.alertMessage({
						"alertMessage" : "판매 정보가 없습니다.",
						"alertType" : "alert",
						"isAjax" : false
					});
				}else{
					if(document.getElementById("hidCustmr_CD").value == ""){
						$erp.alertMessage({
							"alertMessage" : "고객사 선택 후 출력 가능합니다.",
							"alertType" : "alert",
							"isAjax" : false
						});
					}else{
						var searchDateFrom = $("#searchDateFrom").val();
						var searchDateTo = $("#searchDateTo").val();
						var year = searchDateFrom.substring(0,4)
						var month = searchDateFrom.substring(5,7)
						var last = new Date(year, month);
							last = new Date(last - 1); 
						var lastD = last.getDate();
						var Fromdate = year.concat("-",month,"-","01")
						var Todate = year.concat("-",month,"-",lastD)
						if(searchDateFrom == Fromdate && searchDateTo == Todate){
							printCM();
						} else{
							$erp.alertMessage({
								"alertMessage" : "해당 월의 첫 날과 마지막 날을 선택하세요",
								"alertType" : "alert",
								"isAjax" : false
							});
						}
					}
				}
			} else if(itemId == "print_trade_statement"){
				var check_row_len = erpHeaderGrid.getCheckedRows(erpHeaderGrid.getColIndexById("CHECK")).split(",")[0];
				if(check_row_len == ""){
					$erp.alertMessage({
						"alertMessage" : "1개이상의 거래건을 선택 후 이용가능합니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
				}else {
					printTradeStatement();
				}
			}
		});
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
	
	function initErpHeadrGrid(){
		erpHeadrGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "ORGN_DIV_CD", label:["법인구분", "#rspan"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_DIV_CD"]}
			, {id : "ORGN_CD", label:["조직명", "#rspan"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD","CT,PM"]}
			, {id : "CUSTMR_NM", label:["고객사", "#rspan"], type: "ro", width: "170", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ORD_DATE", label:["일자", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "TOT_GOODS_NM", label:["상품명", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "CONF_TYPE", label:["처리상태", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "SEND_TYPE", label:["ERP전송여부", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "PAY_SUM_AMT", label:["금액", "#rspan"], type: "ron", width: "120", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat: "0,000"}
			, {id : "CONF_AMT", label:["확정금액", "#rspan"], type: "ron", width: "120", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat: "0,000"}
			, {id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "ORD_CD", label:["거래코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "CUSTMR_CD", label:["고객사코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "center", isHidden : true, isEssential : false}
		];
		
		erpHeaderGrid = new dhtmlXGridObject({
			parent: "div_erp_header_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpHeadrGridColumns
		});
		
		$erp.attachDhtmlXGridFooterSummary(erpHeaderGrid
				,["PAY_SUM_AMT","CONF_AMT"]
				,1
				,"합계");
		erpHeaderGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpHeaderGrid);
		$erp.initGridComboCell(erpHeaderGrid);
		$erp.attachDhtmlXGridFooterPaging(erpHeaderGrid, 5);
		$erp.attachDhtmlXGridFooterRowCount(erpHeaderGrid, '<spring:message code="grid.allRowCount" />');
		
		erpHeaderGrid.attachEvent("onRowDblClicked", function(rId){
			var paramGridData = {};
			paramGridData["CUSTMR_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("CUSTMR_CD")).getValue();
			paramGridData["searchDate"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORD_DATE")).getValue();
			paramGridData["ORGN_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORGN_CD")).getValue();
			searchErpDetailGrid(paramGridData);
		});
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpHeaderGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpHeaderGrid);
	}
	
	function initErpDetailGrid(){
		erpDetailGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "REG_TYPE", label:["판매유형", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false,  isDisabled : true, commonCode : ["SALES_OR_RETURNS"]}
			, {id : "SALE_QTY", label:["수량", "#rspan"], type: "ro", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "SALE_TOT_AMT", label:["금액", "#rspan"], type: "ron", width: "120", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat: "0,000"}
			, {id : "CONF_DETL_AMT", label:["확정금액", "#rspan"], type: "edn", width: "120", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat: "0,000", isSelectAll: true, maxLength : 11}
			, {id : "ORD_CD", label:["거래코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : true, isEssential : false}
		];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpDetailGridColumns
		});
		
		$erp.attachDhtmlXGridFooterSummary(erpDetailGrid
				,["SALE_QTY","SALE_TOT_AMT","CONF_DETL_AMT"]
				,1
				,"합계");
		erpDetailGrid.enableDistributedParsing(true, 100, 50);
		erpDetailGrid.enableAccessKeyMap(true);
		erpDetailGrid.enableColumnMove(true);
		$erp.initGridCustomCell(erpDetailGrid);
		$erp.initGridComboCell(erpDetailGrid);
		$erp.attachDhtmlXGridFooterPaging(erpDetailGrid, 30);
		$erp.attachDhtmlXGridFooterRowCount(erpDetailGrid, '<spring:message code="grid.allRowCount" />');
		
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

	function isSearchValidate(){
		var isValidated = true;
		
		var searchDateFrom = $("#searchDateFrom").val();
		var searchDateTo = $("#searchDateTo").val();
		var searchCustmr = $("#hidCustmr_CD").val();
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
	
	function searchHeaderGrid(){
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
		paramData["REG_TYPE"] = cmbSALES_OR_RETURNS.getSelectedValue();
		paramData["CUSTMR_CD"] = CUSTMR_CD
		
		var search_date_from = document.getElementById("searchDateFrom").value;
		var search_date_to = document.getElementById("searchDateTo").value;
		var date_from = search_date_from.replace(/\-/g,'');
		var date_to = search_date_to.replace(/\-/g,'');
		
		if(date_from <= date_to){
			erpLayout.progressOn();
			$.ajax({
				url: "/sis/sales/salesManagementCenter/getSuprBySupplyConfirmHeaderList.do"
				, data : paramData
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpHeaderGrid);
						initErpDetailGrid();
						var gridDataList = data.dataMap;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpHeaderGrid
								,  '<spring:message code="grid.noSearchData" />'
							);
						}else {
								erpHeaderGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpHeaderGrid);
					$erp.setDhtmlXGridFooterSummary(erpHeaderGrid
													,["PAY_SUM_AMT","CONF_AMT"]
													,1
													,"합계")
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		} else{
			$erp.alertMessage({
				"alertMessage" : "날짜를 다시 지정해주세요."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
		}
	}
	
	function searchErpDetailGrid(paramGridData){
		erpLayout.progressOn();
		$.ajax({
			url: "/sis/sales/salesManagementCenter/getSuprBySupplyConfirmDetailList.do"
			, data : paramGridData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.dataMap;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpDetailGrid
							,  '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpDetailGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
				$erp.setDhtmlXGridFooterSummary(erpDetailGrid
												,["SALE_QTY","SALE_TOT_AMT","CONF_DETL_AMT"]
												,1
												,"합계")
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function isValidateHeaderUpdate(apply_type) {
		// 이미승인된건을 승인하려할때, 이미 취소된건을 취소하려할때 alert 부분 추가하기!
		var uncheck_cnt = 0;
		var confirm_conf_type = "";
		var rowIds = [];
		var checkedIndex = erpHeaderGrid.getCheckedRows(erpHeaderGrid.getColIndexById("CHECK"));
		console.log(checkedIndex);
		var checkedList = checkedIndex.split(",");
		
		
		if(checkedList[0] != "") {
			for(var i = 0 ; i < checkedList.length ; i++){
				rowIds[i] = erpHeaderGrid.getRowId(checkedList[i]-1);
				if(apply_type == "approval"){
					confirm_conf_type = "Y";
				} else { // apply_type == "cancle"
					confirm_conf_type = "N";
				}
				
				if(erpHeaderGrid.cells(rowIds[i], erpHeaderGrid.getColIndexById("CONF_TYPE")).getValue() == confirm_conf_type && 
						erpHeaderGrid.cells(rowIds[i], erpHeaderGrid.getColIndexById("SEND_TYPE")).getValue() != "ERP"){
					erpHeaderGrid.cells(rowIds[i], erpHeaderGrid.getColIndexById("CHECK")).setValue(0);
					uncheck_cnt = uncheck_cnt + 1;
				}
			}
		} else {
			$erp.alertMessage({
				"alertMessage" : "1건 이상의 납품내역을 선택 후 이용가능합니다."
				//, "alertCode" : "-1"
				, "alertType" : "error"
				, "isAjax" : false
			});
			return false;
		}
		
		var uncheck_msg = "";
		if(apply_type == "approval"){
			uncheck_msg = "처리상태가 'Y'거나 ERP 전송 완료 상태인 판매건은</br> 변경하실 수 없습니다.</br>[무효 : " + uncheck_cnt +" 건]";
		}else if(apply_type == "cancle"){
			uncheck_msg = "처리상태가 'N'이거나 ERP 전송 완료 상태인 판매건은</br> 변경하실 수 없습니다.</br>[무효 : " + uncheck_cnt +" 건]";
		}
		
		if(uncheck_cnt > 0) {
			$erp.alertMessage({
				"alertMessage" : uncheck_msg
				,"alertType" : "alert"
				,"isAjax" : false
				,"alertCallbackFn" : function(){
					if(apply_type == "approval"){
						approvalPurchase(checkedList);
					} else if(apply_type == "cancle"){
						canclePurchase(checkedList);
					}
				}
			});
		}else{
			if(apply_type == "approval"){
				approvalPurchase(checkedList)
			} else if(apply_type == "cancle"){
				canclePurchase(checkedList);
			}
		}
	}
	
	function approvalPurchase(checkedList){
		var alertMSG = null;
		var conf_state;
		var Y_count = 0;
		for(var i in checkedList){
			conf_state = erpHeaderGrid.cells(checkedList[i], erpHeaderGrid.getColIndexById("CONF_TYPE")).getValue();
			if(conf_state == "Y"){
				Y_count += 1;
			}
		}
		
		if(Y_count == 0){
			alertMSG = "승인 처리하시겠습니까? ";
		}else {
			alertMSG = "처리상태가 'Y'인 건을 제외한 나머지 항목들을<br> 승인처리하시겠습니까?"
		}
		
		$erp.confirmMessage({
			"alertMessage" : alertMSG,
			"alertType" : "info",
			"isAjax" : false,
			"alertCallbackFn" : function confirmApprovalAgain(){
				var paramGrid = $erp.serializeDhtmlXGridData(erpHeaderGrid, false, true);
				console.log(paramGrid);
				erpLayout.progressOn();
				$.ajax({
					url: "/sis/sales/salesManagementCenter/approvalSuprBySupplyConfirm.do"
					, data : paramGrid
					, method : "POST"
					, dataType : "JSON"
					, success : function(data){
						erpLayout.progressOff();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else {
							var resultMessage = data.resultMessage;
							$erp.alertMessage({
								"alertMessage" : resultMessage
								,"alertType" : "alert"
								,"isAjax" : false
								,"alertCallbackFn" : function(){searchHeaderGrid(); }
							});
						}
					}, error : function(jqXHR, textStatus, errorThrown){
						erpLayout.progressOff();
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
			}
		});
	}
	
	function canclePurchase(checkedList){
		var alertMSG = null;
		var conf_state;
		var N_count = 0;
		for(var i in checkedList){
			conf_state = erpHeaderGrid.cells(checkedList[i], erpHeaderGrid.getColIndexById("CONF_TYPE")).getValue();
			if(conf_state == "N" || conf_state == "ERP"){
				N_count += 1;
			}
		}
		
		if(N_count == 0){
			alertMSG = "취소처리 하시겠습니까?";
		}else {
			alertMSG = "처리상태가 'N'인 건을 제외한 나머지 항목들을<br> 취소처리 하시겠습니까?";
		}
		
		$erp.confirmMessage({
			"alertMessage" : alertMSG,
			"alertType" : "alert",
			"isAjax" : false,
			"alertCallbackFn" : function confirmApprovalAgain(){
				var paramGrid = $erp.serializeDhtmlXGridData(erpHeaderGrid, false, true);
				erpLayout.progressOn();
				$.ajax({
					url: "/sis/sales/salesManagementCenter/cancleSuprBySupplyConfirm.do"
					, data : paramGrid
					, method : "POST"
					, dataType : "JSON"
					, success : function(data){
						erpLayout.progressOff();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else {
							var resultMessage = data.resultMessage;
							console.log(resultMessage);
							$erp.alertMessage({
								"alertMessage" : resultMessage
								,"alertType" : "alert"
								,"isAjax" : false
								,"alertCallbackFn" : function(){searchHeaderGrid(); }
							});
							searchHeaderGrid();
						}
					}, error : function(jqXHR, textStatus, errorThrown){
						erpLayout.progressOff();
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
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
		cmbSALES_OR_RETURNS = $erp.getDhtmlXComboCommonCode("cmbSALES_OR_RETURNS","SALES_OR_RETURNS", ["SALES_OR_RETURNS"],100,"모두조회", false);
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
	
	<%-- saveErpDetailGrid 저장 Function --%>
	function saveGridData(paramGridData) {
		var paramGridData = {};
		var rId = erpHeaderGrid.getSelectedRowId();
		paramGridData["CUSTMR_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("CUSTMR_CD")).getValue();
		paramGridData["searchDate"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORD_DATE")).getValue();
		paramGridData["ORGN_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORGN_CD")).getValue();
		
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
		console.log(paramData); 
		$.ajax({
			url : "/sis/sales/salesManagementCenter/saveSupplyConfirm.do" 
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
						"alertCallbackFn" : searchErpDetailGrid(paramGridData)
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function printDetailGrid(){
		var search_date_from = document.getElementById("searchDateFrom").value;
		var search_date_to = document.getElementById("searchDateTo").value;
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		
		var check = erpHeaderGrid.getCheckedRows(erpHeaderGrid.getColIndexById("CHECK"));
		var checkList = check.split(',');
		
		if(check ==""){
			$erp.alertMessage({
				"alertMessage" : "1개이상의 거래건을 선택 후 이용가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else if(ORGN_CD == ""){
			$erp.alertMessage({
				"alertMessage" : "조직명을 선택 후 이용가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else{
			for(var i = 0 ; i < checkList.length ; i ++) {
				if(i != checkList.length - 1) {
					ord_dateList += erpHeaderGrid.cells(checkList[i], erpHeaderGrid.getColIndexById("ORD_DATE")).getValue() + ",";
				} else {
					ord_dateList += erpHeaderGrid.cells(checkList[i], erpHeaderGrid.getColIndexById("ORD_DATE")).getValue();
				}
			}			
			var paramInfo = {
					"ORD_DATE" : ord_dateList
					, "mrdPath" : "supply_upload"
					, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
					, "CUSTMR_CD" : document.getElementById("hidCustmr_CD").value
					, "SEARCH_DATE_FROM" : search_date_from
					, "SEARCH_DATE_TO" : search_date_to
			};
			
			var approvalURL = $CROWNIX_REPORT.openSupplyConfirmSheet("", paramInfo, "판매현황", "");
			var popObj = window.open(approvalURL, "supplyConfirm_popup", "width=750,height=950");
		}
		ord_dateList = "";
		
	}
	
	function printCM() {
		var searchDateFrom = $("#searchDateFrom").val();
		var searchDateTo = $("#searchDateTo").val();
		var CUSTMR_CD = $("#hidCustmr_CD").val();
		var mrdFileName = "Custmr_CreditLoan.mrd";
		var emp_nm = "${empSessionDto.emp_nm}";
		var orgn_div_nm = "${empSessionDto.orgn_div_nm}";

		var paramInfo = {
				"mrdPath" : "mrd_print"
				, "mrdFileName" : mrdFileName
				, "CUSTMR_CD" : CUSTMR_CD
				, "searchDateFrom" : searchDateFrom
				, "searchDateTo" : searchDateTo
				, "emp_nm" : emp_nm
				, "orgn_div_nm" : orgn_div_nm
		};
		console.log(paramInfo)
		var approvalURL = $CROWNIX_REPORT.PrintCustmrEnd("", paramInfo, "고객사관리대장", "");
		var popObj = window.open(approvalURL, "Custmr_CreditLoan", "width=700,height=700");
		
		var frm = document.printform;
		frm.action = approvalURL;
		frm.target = "Custmr_CreditLoan";
		frm.submit();
	}
	
	function printTradeStatement(){
		var order_cd_list = "";
		var selected_custmr_cd = "";
		var selected_orgn_cd = "";
		var selected_search_date_from = $("#searchDateFrom").val();
		var selected_search_date_to = $("#searchDateTo").val();
		var check_rows = erpHeaderGrid.getCheckedRows(erpHeaderGrid.getColIndexById("CHECK"));
		var check_list = check_rows.split(",");
		
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
</script>
</head>
<body>
	<form name="testform" action="" method="post"></form>
	<form name="printform" action="" method="post"></form>	
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
					<div id="cmbSALES_OR_RETURNS"></div>
				</td>
			</tr>
			<tr>
				<th>기 간</th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_calendar default_date input_essential" data-position="(1)">
					~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_calendar default_date input_essential" data-position="">
				</td>
				<th><input type="checkbox" id="ck_Custmr" name="ck_Custmr" onclick="checkboxYN('custmr');" style="float: center;"/>고객사 </th>
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
	<div id="div_erp_detail_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_detail_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>