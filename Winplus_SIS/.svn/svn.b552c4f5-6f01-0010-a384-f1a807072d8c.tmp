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
	
	var total_layout;
	
	var top_layout;
	
	var mid_layout;
	var mid_layout_ribbon;
	
	var bot_header_layout;
	var erpHeaderGrid;
	
	var bot_detail_layout;
	var erpDetailGrid;
	var cmbORGN_CD;
	
	$(document).ready(function(){
		init_total_layout();
		init_top_layout();
		init_mid_layout();
		init_header_layout();
		init_detail_layout();
	});
	
	function init_total_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4E"
			, cells: [
				{id: "a", text: "조회조건", header:false, fix_size:[true, true]}
				, {id: "b", text: "리본", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드", header:false}
				, {id: "d", text: "그리드", header:false}
			]
		});
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight($erp.getTableHeight(2));
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(36);
		total_layout.cells("c").attachObject("div_bot_header_layout");
		total_layout.cells("c").setHeight(450);
		total_layout.cells("d").attachObject("div_bot_detail_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
		
	}
	
	function init_top_layout(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 220, "AllOrOne", false, null, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 110, "AllOrOne", false, null);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null, null);
			});
			cmbORGN_CD.attachEvent("onChange", function(value, text){

			});
		});
		
		cmbTYPE = new dhtmlXCombo("cmbTYPE","TYPE",110)
		cmbTYPE.readonly(true);
		cmbTYPE.addOption([
			{value: "ALL", text: "전체보기", selected: true}
			,{value: "PUR", text: "회수"}
			,{value: "SALE", text: "반납"}
		]);
	}
	
	function init_mid_layout(){
		ribbon = new dhtmlXRibbon({
			parent : "div_mid_layout"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
							{
								type : "block"
								, mode : 'rows'
								, list : [
								{id : "search_grid", type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 								, {id : "add_grid", type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
// 								, {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
// 								, {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
								, {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
// 								, {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true, unused : true}
								]
							}
							]
		});
		
		ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				isSearchValidate();
			} else if (itemId == "add_grid"){
					
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				$erp.exportDhtmlXGridExcel({
				     "grid" : erpHeaderGrid
				   , "fileName" : "공병 회수 및 반납 내역"
				   , "isForm" : false
				   , "isHiddenPrint" : "Y"
				   , "excludeColumn" : ["NO"]
				});
			} else if (itemId == "print_grid"){
				
			}
		});
	}

	function init_header_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
							{id : "NO", label:["순번", "#rspan"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
							, {id : "ORGN_DIV_CD", label:["법인구분", "#rspan"], type : "combo", width : "150", sort : "str", align : "center", isHidden : false, isEssential : false,commonCode : ["ORGN_DIV_CD"],isDisabled : true}
							, {id : "ORGN_CD", label:["조직명", "#rspan"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false,commonCode : ["ORGN_CD","MK"],isDisabled : true}
							, {id : "DATE", label:["일자", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "SUM_SALE_QTY", label:["공병 회수 수량", "#rspan"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true}
							, {id : "SUM_PUR_QTY", label:["공병 반납 수량", "#rspan"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true}
							, {id : "SUPR_CD", label:["!@#협력사코드", "#rspan"], type : "ro", width : "150", sort : "str", align : "left", isHidden : true, isEssential : true}
							, {id : "CUSTMR_NM", label:["반납 업체", "#rspan"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "SUM_SALE_AMT", label:["공병 회수 금액", "#rspan"], type : "ron", width : "150", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "SUM_PUR_AMT", label:["공병 반납 금액", "#rspan"], type : "ron", width : "150", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "SEQ", label:["시퀀스", "#rspan"], type : "ro", width : "200", sort : "str", align : "left", isHidden : true, isEssential : true}
							];

		erpHeaderGrid = new dhtmlXGridObject({
			parent: "div_bot_header_layout"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : grid_Columns
		});
		$erp.attachDhtmlXGridFooterSummary(erpHeaderGrid
											, [ "SUM_PUR_QTY"
												,"SUM_SALE_QTY"
												,"SUM_PUR_AMT"
												,"SUM_SALE_AMT"]
											,1
											,"합계");
		
		$erp.initGrid(erpHeaderGrid,{multiSelect : true});
		
		erpHeaderGrid.attachEvent("onRowDblClicked", function (rId,columnIdx){
			var paramGridData = {};
			pur_date = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("DATE")).getValue();
			paramGridData["DATE"] = pur_date;
			paramGridData["ORGN_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORGN_CD")).getValue();
			paramGridData["SUPR_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("SUPR_CD")).getValue();
			paramGridData["SEQ"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("SEQ")).getValue();
			console.log(paramGridData)
			searchErpDetailGrid(paramGridData);
		});
	}
	
	function init_detail_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
							{id : "NO", label:["순번", "#rspan"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false,numberFormat : "0,000"}
							, {id : "BCD_NM", label:["공병유형", "#rspan"], type : "ro", width : "350", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "SALE_QTY", label:["공병 회수 수량", "#rspan"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true}
							, {id : "PUR_QTY", label:["공병 반납 수량", "#rspan"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true}
							, {id : "CUSTMR_NM", label:["반납업체", "#rspan"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "SALE_TOT_AMT", label:["공병 회수 금액", "#rspan"], type : "ron", width : "150", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "PAY_SUM_AMT", label:["공병 반납 금액", "#rspan"], type : "ron", width : "150", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "SEQ", label:["시퀀스", "#rspan"], type : "ro", width : "200", sort : "str", align : "left", isHidden : true, isEssential : true}
							];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_bot_detail_layout"
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : grid_Columns
		});
		$erp.attachDhtmlXGridFooterSummary(erpDetailGrid
											, [ "PUR_QTY"
												,"SALE_QTY"
												,"PAY_SUM_AMT"
												,"SALE_TOT_AMT"]
											,1
											,"합계");
		
		$erp.initGrid(erpDetailGrid,{multiSelect : true});
	}
	
	function isSearchValidate(){
		var isValidated = true;
		
		var searchDateFrom = $("#txtDATE_FR").val();
		var searchDateTo = $("#txtDATE_TO").val();
		var alertMessage = "";
		var alertType = "error";
		
		if($erp.isEmpty(searchDateFrom) || $erp.isEmpty(searchDateTo)){
			isValidated = false;
			alertMessage = "error.common.date.empty3";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : null
				, "alertType" : alertType
			});
		} else {
			searchHeaderGrid();
		}
	}
	
	function searchHeaderGrid(){
		var paramData = {};
		var date_from = document.getElementById("txtDATE_FR").value;
		var date_to = document.getElementById("txtDATE_TO").value;
		paramData["DATE_FR"] = date_from;
		paramData["DATE_TO"] = date_to;
		paramData["TYPE"] = cmbTYPE.getSelectedValue();
		paramData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		paramData["ORGN_DIV_CD"] = cmbORGN_DIV_CD.getSelectedValue();
			
		if(date_from <= date_to){
			total_layout.progressOn();
			$.ajax({
				url: "/sis/market/emptybottle/getEBRHList.do"
				, data : paramData
				,method : "POST"
					,dataType : "JSON"
					,success : function(data){
						$erp.clearDhtmlXGrid(erpHeaderGrid); //기존데이터 삭제
						init_detail_layout();
						total_layout.progressOff();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						} else {
							var gridDataList = data.gridDataList;
							if($erp.isEmpty(gridDataList)){
								$erp.addDhtmlXGridNoDataPrintRow(
										erpHeaderGrid
									, '<spring:message code="grid.noSearchData" />'
								);
							} else {
								erpHeaderGrid.parse(gridDataList, 'js');
							}
						}
						$erp.setDhtmlXGridFooterRowCount(erpHeaderGrid);
						$erp.setDhtmlXGridFooterSummary(erpHeaderGrid
														, [ "SUM_PUR_QTY"
															,"SUM_SALE_QTY"
															,"SUM_PUR_AMT"
															,"SUM_SALE_AMT"]
														,1
														,"합계");
					}, error : function(jqXHR, textStatus, errorThrown){
						total_layout.progressOff();
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
		} else{
			$erp.alertMessage({
				"alertMessage" : "기간이 올바르지 않습니다."
				,"alertCode" : null
				,"alertType" : "alert"
				,"isAjax" : false
				,"alertCallbackFn" : function() {
					document.getElementById("txtDATE_FR").value = $erp.getToday("-");
					document.getElementById("txtDATE_TO").value = $erp.getToday("-");
				}
			});
		}
	}
	function searchErpDetailGrid(paramGridData){
		total_layout.progressOn();
		$.ajax({
			url: "/sis/market/emptybottle/getEBRDList.do"
			, data : paramGridData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpDetailGrid, '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpDetailGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
				$erp.setDhtmlXGridFooterSummary(erpDetailGrid
												, [ "PUR_QTY"
												,"SALE_QTY"
												,"PAY_SUM_AMT"
												,"SALE_TOT_AMT"]
												,1
												,"합계");
				
				total_layout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				total_layout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
</script>
</head>
<body>		

	<div id="div_top_layout" class="samyang_div" style="display:none">
		<div id="div_top_layout_search" class="samyang_div">
			<table id="tb_search" class="table">
				<colgroup>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th colspan="1">법인구분</th>
					<td colspan="2">
						<div id="cmbORGN_DIV_CD"></div>
					</td>
					<th colspan="1">조직명</th>
					<td colspan="6">
						<div id="cmbORGN_CD"></div>
					</td>
				</tr>
				<tr>
					<th colspan="1">기간</th>
					<td colspan="2">
						<input type="text" id="txtDATE_FR" class="input_calendar default_date" data-position="(1)" value="">
						<span style="float: left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO" class="input_calendar default_date" data-position="" value="" style="float: left; margin-left: 6px;">
					</td>
					<th colspan="1">회수/반납</th>
					<td colspan="6"><div id="cmbTYPE"></div></td>
				</tr>
			</table>
		</div>
	</div>

	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bot_header_layout" class="div_grid_full_size" style="display:none"></div>
	<div id="div_bot_detail_layout" class="div_grid_full_size" style="display:none"></div>
</body>
</html>