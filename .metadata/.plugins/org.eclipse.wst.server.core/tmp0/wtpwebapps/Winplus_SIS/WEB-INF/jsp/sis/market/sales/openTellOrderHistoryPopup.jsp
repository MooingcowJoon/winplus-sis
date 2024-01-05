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
	
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openTellOrderHistoryPopup");
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;
	var erpGridDataProcessor;
	var popOnRowDblClicked;
	var tellInfo = JSON.parse('${tellInfo}');
	var MEM_NO = tellInfo.MEM_NO;
	var ORGN_CD = tellInfo.ORGN_CD;
	var ORGN_DIV_CD = tellInfo.ORGN_DIV_CD;
	var TEL_ORD_CD = tellInfo.TEL_ORD_CD;
	var oldVal;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("전화주문");
		}
		init_total_layout();
		init_top_layout();
		init_mid_layout();
		init_bot_layout();
		init_searchPopup();
	});
	
	function init_total_layout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "4E"
				, cells : [
					{id: "a", text: "조회일자선택영역", header:false, fix_size : [false, false]}
					,{id: "b", text: "리본영역", header:false, fix_size : [false, false]}
					,{id: "c", text: "그리드영역", header:false, fix_size : [false, false]}
					,{id: "d", text: "ddd영역", header:false, fix_size : [false, false]}
					]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_mem_table");
		erpPopupLayout.cells("a").setHeight(60);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_order_grid");
		erpPopupLayout.cells("d").attachObject("div_erp_sale_table");
		erpPopupLayout.cells("d").setHeight(84);
		erpPopupLayout.setSeparatorSize(0, 1);
		
		<%-- erpPopupLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupGrid.setSizes();
		});
	}
	function init_top_layout() {
		cmbORD_STATE = $erp.getDhtmlXComboCommonCode("cmbORD_STATE","ORD_STATE", ["DELI_ORD_STATE"],155, false, false, false,null,"Y");
		$erp.objReadonly(["cmbORD_STATE"]);
		
		$("#txtOUT_WARE_DATE").on("propertychange paste", function() {
		    var currentVal = $(this).val();
		    if(currentVal == oldVal) {
		        return;
		    }
		    oldVal = currentVal;
		    saveOutWareDate();
		});
	}
	function init_mid_layout() {
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon",
			skin : ERP_RIBBON_CURRENT_SKINS,
			icons_path : ERP_RIBBON_CURRENT_ICON_PATH,
			items : [{
				type : "block",
				mode : 'rows',
				list : [ 
						{id : "search_grid", type : "button", text : '조회', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
						, {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
						, {id : "delete_grid",	type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						, {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
						]
			}]
		});
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId) {
			if (itemId == "search_grid") {
				init_searchPopup();
			} else if (itemId == "add_grid"){
				if(!validation_check()){
					return;
				}
				addErpGrid();
			} else if (itemId == "delete_grid"){
				if(!validation_check()){
					return;
				}
				
				$erp.dataDeleteOfCheckedGridRow(erpPopupGrid);
			} else if (itemId == "save_grid"){
				if(!validation_check()){
					return;
				}
				var OUT_WARE_DATE = $("#txtOUT_WARE_DATE").val();
				saveErpGrid(OUT_WARE_DATE);
			}
		});
	}
	
	function validation_check() {
		var isValidated = true;
		var ORD_STATE = cmbORD_STATE.getSelectedValue();
		var alertMessage = "";
		
		if(ORD_STATE == 'D10'){
			isValidated = false;
			alertMessage = "배송이 완료된 주문입니다<br/>수정하실 수 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : "alert"
				,"isAjax" : false
// 				,"alertCallbackFn" : function(){ searchErpGrid()}
			});
		} 
		return isValidated;
	}
	
	function init_bot_layout(){
		erpPopupGridColumns = [
			{id : "NO", label:["순번", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			
			,{id : "TEL_ORD_CD", label:["전화주문코드(히든)", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "ORGN_DIV_CD", label:["법인구분(히든)", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "ORGN_CD", label:["조직명(히든)", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "MEM_NO", label:["회원번호(히든)", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "HID_BCD_CD", label:["(자)바코드(히든)", "#rspan"], type: "ro", width: "140", sort : "str", align : "center", isHidden : true, isEssential : false, isDataColumn : false}
			,{id : "ORD_SEQ", label:["주문순번(히든)", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			
			,{id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "TEL_SALE_PRICE", label:["판매단가", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			,{id : "SALE_QTY", label:["수량", "#rspan"], type: "edn", width: "50", sort : "int", align : "right", isHidden : false, isEssential : true}
			,{id : "TEL_SALE_TOT_AMT", label:["판매총액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
// 			,{id : "", label:["특매할인", "#rspan"], type: "edn", width: "50", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
// 			,{id : "MAST_SALE_PRICE", label:["POS 판매단가", "#rspan"], type: "edn", width: "50", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "", label:["계산유형", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "GRUP_NM", label:["분류", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "ORD_MEMO", label:["메모", "#rspan"], type: "ed", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_order_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupGridColumns
		});
		
		erpPopupGrid.attachEvent("onKeyPress",onKeyPressed);
		erpPopupGrid.enableAccessKeyMap(true);
		erpPopupGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPopupGrid);
		//$erp.initGridComboCell(erpPopupGrid);
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid, 20);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpPopupGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpPopupGrid);
		
		erpPopupGrid.attachEvent("onRowPaste", function(rId){	//엑셀붙여넣기시 자동으로 행추가
			var tmpRowIndex = erpPopupGrid.getRowIndex(rId);
			if(erpPopupGrid.getRowId((tmpRowIndex+1)) == undefined || erpPopupGrid.getRowId((tmpRowIndex+1)) == "undefined" || erpPopupGrid.getRowId((tmpRowIndex+1)) == null || erpPopupGrid.getRowId((tmpRowIndex+1)) == "null"){
				addErpGrid();
			}
			//처음 입력한 바코드와 다를 경우 정보 가져오기(최초 붙여넣기 시, 붙여넣은 내용 변경 붙여넣기 시)
			if(
				(erpPopupGrid.cells(rId,erpPopupGrid.getColIndexById("BCD_CD")).getValue() != erpPopupGrid.cells(rId,erpPopupGrid.getColIndexById("HID_BCD_CD")).getValue())
			){
				getGoodsInformation(rId);
			}
		});
		
		erpPopupGrid.attachEvent("onEnter", function(rId, Ind){
			if(
				(erpPopupGrid.cells(erpPopupGrid.getSelectedRowId(),erpPopupGrid.getColIndexById("BCD_CD")).getValue() != erpPopupGrid.cells(erpPopupGrid.getSelectedRowId(),erpPopupGrid.getColIndexById("HID_BCD_CD")).getValue())
			){
				getGoodsInformation(erpPopupGrid.getSelectedRowId());
			}
		});
// 		erpGridDataProcessor = 
// 			$erp.initGrid(erpPopupGrid, {rowSize : 20, useAutoAddRowPaste : true, standardColumnId : "BCD_CD", deleteDuplication : true, overrideDuplication : true, editableColumnIdListOfInsertedRows : [], notEditableColumnIdListOfInsertedRows : []});
	}
	
	<%-- popup open했을 때 필요 데이터 --%>
	function init_searchPopup() {
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/market/sales/getTellOrderinitdata.do"
			,data : {
				"ORGN_DIV_CD" : ORGN_DIV_CD
				,"ORGN_CD" : ORGN_CD
				,"MEM_NO" : MEM_NO
				,"TEL_ORD_CD" : TEL_ORD_CD
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					var mem_table_data = document.getElementById("mem_table_data");
					var price_table_data = document.getElementById("price_table_data");
					$erp.clearInputInElement(mem_table_data);
					$erp.clearInputInElement(price_table_data);
					$erp.clearDhtmlXGrid(erpPopupGrid);
					
					var dataMap = data.dataMap;
					if($erp.isEmpty(dataMap)){//검색 결과 없음
						$erp.alertMessage({
							"alertMessage" : "info.common.noDataSearch"
							, "alertCode" : null
							, "alertType" : "info"
						});
					}else{
						if(dataMap.LOAN_CD == null){
// 							$erp.alertMessage({
// 								"alertMessage" : "여신 정보를 조회할 수 없습니다." 
// 								, "alertCode" : null
// 								, "alertType" : "info"
// 								, "isAjax" : false
// 							});
						}
						$erp.bindTextValue(dataMap, mem_table_data);
						$erp.bindCmbValue(dataMap, mem_table_data);
					}
					
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpPopupGrid.parse(gridDataList, 'js');
						$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- 조회버튼 --%>
	function searchErpGrid(){
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/market/sales/getMemOrderBodydata.do"
			,data : {
					"ORGN_DIV_CD" : ORGN_DIV_CD
					,"ORGN_CD" : ORGN_CD
					,"MEM_NO" : MEM_NO
					,"TEL_ORD_CD" : TEL_ORD_CD
					}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpPopupGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
								erpPopupGrid
								,  '<spring:message code="grid.noSearchData" />'
						);
						return false;
					}else {
						erpPopupGrid.parse(gridDataList, 'js');
						$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function saveErpGrid(OUT_WARE_DATE){
		if(erpGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpPopupGrid);
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		var gridData = $erp.dataSerializeOfGridByCRUD(erpPopupGrid,true);
		
		var data1 = {};
		data1["OUT_WARE_DATE"] = OUT_WARE_DATE;
		data1["ORGN_DIV_CD"] = ORGN_DIV_CD;
		data1["ORGN_CD"] = ORGN_CD;
		data1["TEL_ORD_CD"] = TEL_ORD_CD;
		
		var url = "/sis/market/sales/saveTellOrderDetailPopup.do";
		var send_data = $erp.unionObjArray([gridData,data1]);
		
		var if_success = function(data){
			$erp.clearDhtmlXGrid(erpPopupGrid); //기존데이터 삭제
			
			$erp.alertMessage({
				"alertMessage" : "저장이 완료되었습니다.",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			erpPopupRibbon.callEvent("onClick",["search_grid"]);
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpPopupLayout);
	}
	function saveOutWareDate(){
		var OUT_WARE_DATE = document.getElementById("txtOUT_WARE_DATE").value;
		var ORD_DATE = document.getElementById("txtORD_DATE").value;
		ORD_DATE = ORD_DATE.substring(0,10)
		
		if(OUT_WARE_DATE < ORD_DATE){
			$erp.alertMessage({
				"alertMessage" : "주문일자보다 배송일자가 빠를 수 없습니다.",
				"alertType" : "alert",
				"isAjax" : false
			});
		}else{
			$erp.confirmMessage({
				"alertMessage" : "배송일을 변경하시겠습니까?",
				"alertType" : "info",
				"isAjax" : false,
				"alertCallbackFn" : function(){
					var data = {};
					data["OUT_WARE_DATE"] = OUT_WARE_DATE;
					data["ORGN_DIV_CD"] = ORGN_DIV_CD;
					data["ORGN_CD"] = ORGN_CD;
					data["TEL_ORD_CD"] = TEL_ORD_CD;
					console.log(data)
					erpPopupLayout.progressOn();
					$.ajax({
						url : "/sis/market/sales/updateTellOrderOutWareDate.do"
						,data : data
						,method : "POST"
						,dataType : "JSON"
						,success : function(data) {
							var result = data.result
							console.log(result)
							erpPopupLayout.progressOff();
							var mem_table_data = document.getElementById("mem_table_data");
							if(data.isError){
								$erp.ajaxErrorMessage(data);
							}else {
								if(result.RESULT == "SUCCESS"){
									$erp.clearInputInElement(mem_table_data);
									$erp.alertMessage({
										"alertMessage" : result.RESULT_MSG,
										"alertType" : "alert",
										"isAjax" : false
									});
									erpPopupRibbon.callEvent("onClick",["search_grid"]);
								} else if(result.RESULT == "FAIL"){
									$erp.alertMessage({
										"alertMessage" : result.RESULT_MSG,
										"alertType" : "alert",
										"isAjax" : false
									});
								}
							}
						}, error : function(jqXHR, textStatus, errorThrown){
							erpPopupLayout.progressOff();
							$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
						}
					});
				}
			});
		}
	}
	
	function addErpGrid(){
		var TEL_ORD_CD = document.getElementById("txtTEL_ORD_CD").value;
		var ORGN_DIV_CD = document.getElementById("txtORGN_DIV_CD").value;
		var ORGN_CD = document.getElementById("txtORGN_CD").value;
		var MEM_NO = document.getElementById("txtMEM_NO").value;
		var uid = erpPopupGrid.uid();
		erpPopupGrid.addRow(uid);
		
		erpPopupGrid.selectRow(erpPopupGrid.getRowIndex(uid));
		erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("TEL_ORD_CD")).setValue(TEL_ORD_CD);
		erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("ORGN_DIV_CD")).setValue(ORGN_DIV_CD);
		erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("ORGN_CD")).setValue(ORGN_CD);
		erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("MEM_NO")).setValue(MEM_NO);
		erpPopupGrid.setCellExcellType(uid, erpPopupGrid.getColIndexById("BCD_CD"),"edn");//addrow에만 작성가능
		
		$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
	}
	
	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			if (!erpPopupGrid._selectionArea) return alert("선택된 구역이 없습니다.");
			erpPopupGrid.setCSVDelimiter("\t");
			erpPopupGrid.copyBlockToClipboard()
		}
		if(code==86&&ctrl){
			erpPopupGrid.setCSVDelimiter("\t");
			erpPopupGrid.pasteBlockFromClipboard()
		}
		if(code==13){
			if(
				(erpPopupGrid.cells(erpPopupGrid.getSelectedRowId(),erpPopupGrid.getColIndexById("BCD_CD")).getValue() != erpPopupGrid.cells(erpPopupGrid.getSelectedRowId(),erpPopupGrid.getColIndexById("HID_BCD_CD")).getValue())
			){
				getGoodsInformation(erpPopupGrid.getSelectedRowId());
			}
		}
		return true;
	}
	
	<%-- getGoodsInformation 상품정보 가져오기 Function --%>
	function getGoodsInformation(rId) {
		var bcd_cd = erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("BCD_CD")).getValue();
		var orgn_cd = erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("ORGN_CD")).getValue();
		erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("HID_BCD_CD")).setValue(bcd_cd);
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/standardInfo/goods/getGoodsInformationFromBarcode.do"
			,data : {
				"BCD_CD" : bcd_cd
				, "ORGN_CD" : orgn_cd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				console.log(data)
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					if(data.GOODS_NO == "조회정보없음"){
						erpPopupGrid.cells(rId,erpPopupGrid.getColIndexById("BCD_NM")).setTextColor("red");
					}else{
						erpPopupGrid.cells(rId,erpPopupGrid.getColIndexById("BCD_NM")).setTextColor("black");
					}
					erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("BCD_NM")).setValue(data.BCD_NM);
					erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("DIMEN_NM")).setValue(data.DIMEN_NM);
					
					getPriceInformation(rId);//가격정보가져오기
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- getPriceInformation 가격정보 가져오기 Function --%>
	function getPriceInformation(rId) {
		var ORGN_DIV_CD = erpPopupGrid.cells(rId,erpPopupGrid.getColIndexById("ORGN_DIV_CD")).getValue();
		var ORGN_CD = erpPopupGrid.cells(rId,erpPopupGrid.getColIndexById("ORGN_CD")).getValue();
		var BCD_CD = erpPopupGrid.cells(rId,erpPopupGrid.getColIndexById("BCD_CD")).getValue();
		
		if(BCD_CD != "" && BCD_CD != "조회정보없음"){
			$.ajax({
				url : "/sis/price/getPriceInformation.do"
				,data : {
					"BCD_CD" : BCD_CD
					,"ORGN_DIV_CD" : ORGN_DIV_CD
					,"ORGN_CD" : ORGN_CD
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("TEL_SALE_PRICE")).setValue(data.SALE_PRICE);
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
</script>
</head>
<body>
	<div id="div_erp_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_mem_table" class="samyang_div" style="diplay:none;">
			<table id="mem_table_data" class="table">
				<colgroup>
					<col width="90px"/>
					<col width="130px"/>
					<col width="90px"/>
					<col width="140px"/>
					<col width="90px"/>
					<col width="130px"/>
					<col width="90px"/>
					<col width="160px"/>
					<col width="90px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th colspan="1">주문일시</th>
					<td colspan="1"><input type="text" id="txtORD_DATE" name="KEY_WORD" class="input_common" readonly="readonly" style="width:115px;"></td>
					<th colspan="1">배송일</th>
					<td colspan="1">
									<input type="text" id="txtOUT_WARE_DATE" name="OUT_WARE_DATE" class="input_calendar default_date" style="width:115px;" onkeydown="$erp.onEnterKeyDown(event, saveOutWareDate);">
									<input type="button" id="date_SAVE" value="저장" class="input_common_button" onclick="saveOutWareDate();"/>
					</td>
					<th colspan="1">접수자</th>
					<td colspan="1"><input type="text" id="txtORD_RESP_USER" name="KEY_WORD" class="input_common" readonly="readonly" style="width:115px;"></td>
					<th colspan="1">배달 주문 상태</th>
					<td colspan="1"><div id="cmbORD_STATE"></div></td>
					<th colspan="1">외상건수</th>
					<td colspan="1"><input type="text" id="txtTRUST_CNT" name="TRUST_CNT" class="input_common" readonly="readonly" style="text-align:right;width:115px;"></td>
					
				</tr>
				<tr>
					<th colspan="1">회원번호</th>
					<td colspan="1">
						<input type="hidden" id="txtTEL_ORD_CD" name="TEL_ORD_CD">
						<input type="hidden" id="txtORGN_DIV_CD" name="ORGN_DIV_CD">
						<input type="hidden" id="txtORGN_CD" name="ORGN_CD">
						<input type="text" id="txtMEM_NO" name="MEM_NO" class="input_common" readonly="readonly" style="width: 115px;">
					</td>
					<th colspan="1">회원명</th>
					<td colspan="1"><input type="text" id="txtMEM_NM" name="MEM_NM" class="input_common" readonly="readonly" style="width: 115px;"></td>
					<th colspan="1">휴대폰 번호</th>
					<td colspan="1"><input type="text" id="txtPHON_NO" name="PHON_NO" class="input_common" readonly="readonly" style="width:115px;"></td>
					<th colspan="1">주소</th>
					<td colspan="1"><input type="text" id="txtDELI_ADDR" name="DELI_ADDR" class="input_common" readonly="readonly" style="width:145px;"></td>
					<th colspan="1">여신잔액</th>
					<td colspan="1"><input type="text" id="txtBAL_AMT" name="BAL_AMT" class="input_common" readonly="readonly" style="text-align:right;width:115px;"></td>					
				</tr>
			</table>
		</div>
		<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_order_grid" class="div_grid_full_size" style="display:none"></div>
		
			<div id="div_erp_sale_table" class="samyang_div" style="diplay:none;">
				<table id="price_table_data" class="table" >
					<colgroup>
						<col width="">
					</colgroup>
					<tr>
						<th style="text-align:left;">과세물품공급가</th>
						<td colspan="1">
							<input type="text" id="SALE_QTY" name="SALE_QTY" class="input_common input_readonly" readonly="readonly" value = "0" style="width: 140px; text-align:right;">
						</td>
						<th style="text-align:left;">과세보증금</th>
						<td colspan="1">
							<input type="text" id="SALE_AMT" name="SALE_AMT" class="input_common input_readonly" readonly="readonly"  value = "0" style="width: 140px; text-align:right;">
						</td>
						<th style="text-align:left;">과세판매</th>
						<td colspan="1">
							<input type="text" id="COUP_AMT" name="COUP_AMT" class="input_common input_readonly" readonly="readonly"  value = "0" style="width: 140px; text-align:right;">
						</td>
					</tr>
					<tr>
						<th style="text-align:left;">면세물품공급가</th>
						<td colspan="1">
							<input type="text" id="RETURN_QTY" name="RETURN_QTY" class="input_common input_readonly" readonly="readonly" value = "0" style="width: 140px; text-align:right;">
						</td>
						<th style="text-align:left;">면세보증금</th>
						<td colspan="1">
							<input type="text" id="RETN_AMT" name="RETN_AMT" class="input_common input_readonly" readonly="readonly" value = "0" style="width: 140px; text-align:right;">
						</td>
						<th style="text-align:left;">면세판매</th>
						<td colspan="1">
							<input type="text" id="BARG_AMT" name="BARG_AMT" class="input_common input_readonly" readonly="readonly" value = "0" style="width: 140px; text-align:right;">
						</td>
					</tr>
					<tr>
						<th style="text-align:left;">물품공급가합계</th>
						<td colspan="1">
							<input type="text" id="RETURN_QTY" name="RETURN_QTY" class="input_common input_readonly" readonly="readonly" value = "0" style="width: 140px; text-align:right;">
						</td>
						<th style="text-align:left;">보증금합계</th>
						<td colspan="1">
							<input type="text" id="RETN_AMT" name="RETN_AMT" class="input_common input_readonly" readonly="readonly" value = "0" style="width: 140px; text-align:right;">
						</td>
						<th style="text-align:left;">부가세</th>
						<td colspan="1">
							<input type="text" id="BARG_AMT" name="BARG_AMT" class="input_common input_readonly" readonly="readonly" value = "0" style="width: 140px; text-align:right;">
						</td>
					</tr>
				</table>
			</div>
	</div>
	
</body>
</html>