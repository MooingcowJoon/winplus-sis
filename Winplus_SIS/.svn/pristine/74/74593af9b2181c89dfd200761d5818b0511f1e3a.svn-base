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
	LUI.exclude_auth_cd = "ALL,1,2,3,4";//직영점전체,직영점단일만 가능
	LUI.exclude_orgn_type = "CT,OT,PM,PS,CS";
	var total_layout;
	
	var top_layout;
	
	var mid_layout;
	var mid_layout_ribbon;
	
	var bot_header_layout;
	var erpHeaderGrid;
	
	var bot_detail_layout;
	var erpDetailGrid;
	var cmbORGN_CD;
	var Dbcheck = 0;
	
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
				, {id: "c", text: "그리드", header:false, fix_size:[true, true]}
				, {id: "d", text: "그리드", header:false}
			]
		});
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight(60);
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(36);
		total_layout.cells("c").attachObject("div_bot_header_layout");
		total_layout.cells("c").setHeight(300);
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
		//판매경로
		cmbORD_TYPE = $erp.getDhtmlXComboCommonCode("cmbORD_TYPE","ORD_TYPE", ["POS_SALE_PATH"],110,"모두조회", false, false, null,'Y');
		//판매유형
		cmbSALE_TYPE = $erp.getDhtmlXComboCommonCode("cmbSALE_TYPE","SALE_TYPE", ["POS_SALE_KIND"],110,true, false, false, function(){
			//상세유형
			cmbREG_TYPE = $erp.getDhtmlXComboCommonCode("cmbREG_TYPE","TEST", ["SALE_REG_TYPE"],110,"모두조회", false, false, null,'Y');
			if(cmbSALE_TYPE.getSelectedValue() == ""){
				cmbREG_TYPE.disable();
			}
		},'Y');
		
		cmbSALE_TYPE.attachEvent("onChange", function(value, text){
			cmbREG_TYPE.unSelectOption();
			cmbREG_TYPE.clearAll();
			$.ajax({
				url : "/sis/code/getSaleRegTypeList.do"
				,data : {
					"SALE_TYPE" : value
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						var dataList = data.detailCodeList;
						if($erp.isEmpty(dataList)){
							//텅텅
						}else {
							if(value == ""){
								cmbREG_TYPE.disable();
							}else{
								cmbREG_TYPE.enable();
							}
							if(dataList.length == 1){
								var regTypeArray = [];
								regTypeArray.push({value:dataList[0].DETAIL_CD,text:dataList[0].DETAIL_NM,selected: true});
								cmbREG_TYPE.addOption(regTypeArray);
							}else{
								var regTypeArray = [];
								regTypeArray.push({value: "", text: "모두조회" ,selected: true});
								for (var i = 0; i<dataList.length; i++){
									regTypeArray.push({value : dataList[i].DETAIL_CD, text : dataList[i].DETAIL_NM});
								}
								cmbREG_TYPE.addOption(regTypeArray);
							}
						}
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		});
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
//								, {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
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
				if(Dbcheck != 0){
					$erp.exportGridToExcel({
						"grid" : erpDetailGrid
						, "fileName" : "날짜별_직영점_판매현황"
						, "isOnlyEssentialColumn" : false
						, "excludeColumnIdList" : ['NO','ORD_CD']
						, "isIncludeHidden" : true
						, "isExcludeGridData" : false
					});
				} else{
					$erp.alertMessage({
						"alertMessage" : "상세 화면 조회 후 이용 가능합니다.",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							$erp.clearDhtmlXGrid(erpDetailGrid);
						}
					});
				}
			} else if (itemId == "print_grid"){
				
			}
		});
	}

	function init_header_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
							{id : "NO", label:["순번", "#rspan"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
							, {id : "ORGN_DIV_CD", label:["법인구분", "#rspan"], type : "combo", width : "140", sort : "str", align : "center", isHidden : false, isEssential : false,isDisabled : true, commonCode : ["ORGN_DIV_CD"]}
							, {id : "ORGN_CD", label:["조직명", "#rspan"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false,commonCode : ["ORGN_CD","MK"],isDisabled : true}
							, {id : "ORD_DATE", label:["일자", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "TOT_BCD_NM", label:["상품명", "#rspan"], type : "ro", width : "300", sort : "str", align : "left", isHidden : false, isEssential : true}
// 							, {id : "SUM_SALE_TOT_AMT", label:["총 판매금액", "#rspan"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "SUM_SALE_AMT", label:["매출금액", "#rspan"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "SUM_PAY_CASH", label:["지불(현금)", "#rspan"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "SUM_PAY_CARD", label:["지불(카드)", "#rspan"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "SUM_PAY_GIFT", label:["지불(상품권)", "#rspan"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "SUM_PAY_POINT", label:["지불(포인트)", "#rspan"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "SUM_PAY_TRUST", label:["지불(외상)", "#rspan"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "SUM_DISC_AMT", label:["금액(할인)", "#rspan"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "ORD_TYPE", label:["판매경로", "#rspan"], type : "ro", width : "50", sort : "str", align : "left", isHidden : true, isEssential : true}
							, {id : "SALE_TYPE", label:["판매유형", "#rspan"], type : "ro", width : "50", sort : "str", align : "left", isHidden : true, isEssential : true}
							, {id : "REG_TYPE", label:["상세유형", "#rspan"], type : "ro", width : "50", sort : "str", align : "left", isHidden : true, isEssential : true}
							];

		erpHeaderGrid = new dhtmlXGridObject({
			parent: "div_bot_header_layout"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : grid_Columns
		});
		$erp.attachDhtmlXGridFooterSummary(erpHeaderGrid
											, [ 
												"SUM_SALE_AMT"
												,"SUM_PAY_CASH"
												,"SUM_PAY_CARD"
												,"SUM_PAY_GIFT"
												,"SUM_PAY_POINT"
												,"SUM_PAY_TRUST"
												,"SUM_DISC_AMT"]
											,"H"
											,"합계");
		
		$erp.initGrid(erpHeaderGrid,{multiSelect : true});
		
		erpHeaderGrid.attachEvent("onRowSelect", function (rId,columnIdx){
			var paramGridData = {};
			ORD_DATE = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORD_DATE")).getValue();
			paramGridData["ORD_DATE"] = ORD_DATE;
			paramGridData["ORGN_DIV_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORGN_DIV_CD")).getValue();
			paramGridData["ORGN_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORGN_CD")).getValue();
			paramGridData["REG_TYPE"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("REG_TYPE")).getValue();
			paramGridData["SALE_TYPE"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("SALE_TYPE")).getValue();
			paramGridData["ORD_TYPE"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORD_TYPE")).getValue();
			
			searchErpDetailGrid(paramGridData);
		});
	}
	
	function init_detail_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
							{id : "NO", label:["순번", "#rspan"], type : "cntr", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false,numberFormat : "0,000"}
							, {id : "ORGN_CD", label:["조직명", "#rspan"], type : "combo", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false,commonCode : ["ORGN_CD","MK"],isDisabled : true}
							, {id : "ORD_DATE", label:["일자", "#rspan"], type : "ed", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
							, {id : "ORD_CD", label:["!주문코드!", "#rspan"], type : "ed", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
							, {id : "BILL_NO", label:["영수증번호", "#text_filter"], type : "ed", width : "80", sort : "str", align : "center", isHidden : false, isEssential : false}
							, {id : "ORD_TYPE", label:["판매경로", "#select_filter"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : false,commonCode:["POS_SALE_PATH"],isDisabled : true}
							, {id : "SALE_TYPE", label:["판매유형", "#select_filter"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : false,commonCode:["POS_SALE_KIND"],isDisabled : true}
							, {id : "REG_TYPE", label:["상세유형", "#select_filter"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : false,commonCode:["SALE_REG_TYPE"],isDisabled : true}
							, {id : "POS_NO", label:["포스번호", "#text_filter"], type : "ed", width : "80", sort : "str", align : "center", isHidden : false, isEssential : false}
							, {id : "BCD_NM", label:["상품명", "#rspan"], type : "ed", width : "300", sort : "str", align : "left", isHidden : false, isEssential : false}
							, {id : "SALE_PRICE", label:["판매단가", "#rspan"], type : "edn", width : "85", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
							, {id : "SALE_QTY", label:["판매수량", "#rspan"], type : "edn", width : "85", sort : "int", align : "right", isHidden : false, isEssential : false}
							, {id : "SALE_AMT", label:["매출금액", "#rspan"], type : "edn", width : "85", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
							, {id : "SALE_VAT_AMT", label:["부가세액", "#rspan"], type : "edn", width : "85", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
// 							, {id : "SALE_TOT_AMT", label:["총 판매금액", "#rspan"], type : "edn", width : "85", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000",isDisabled : true}
							, {id : "DC_AMT", label:["할인", "#rspan"], type: "edn", width: "85", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
							];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_bot_detail_layout"
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : grid_Columns
		});
		$erp.attachDhtmlXGridFooterSummary(erpDetailGrid
											, ["SALE_QTY","SALE_AMT","SALE_VAT_AMT","DC_AMT"]
											,"D"
											,"합계");
		
		$erp.initGrid(erpDetailGrid,{multiSelect : true});
		
		erpDetailGrid.attachEvent("onCellChanged", function (rowId,columnIdx,newValue){
			if(erpDetailGrid.getColumnId(columnIdx) == "SALE_TYPE"){
				if(erpDetailGrid.cells(rowId, columnIdx).getValue() == "1"){//사내소비 보라
					erpDetailGrid.setRowColor(rowId,"#DFC0E4");
					//erpDetailGrid.setRowTextStyle(rowId,"background-color:#FAF9BA");
				}else if(erpDetailGrid.cells(rowId, columnIdx).getValue() == "2"){//비매출 회색 합산x 0원처리
					erpDetailGrid.setRowColor(rowId,"#CCCCCC");
				}
			}
			if(erpDetailGrid.getColumnId(columnIdx) == "REG_TYPE"){
				if(erpDetailGrid.cells(rowId, columnIdx).getValue() == "S02"){//반품 빨강
					//erpDetailGrid.setRowColor(rowId,"#FAE0D4");
					erpDetailGrid.setRowColor(rowId,"#FAE0D4");
				}
			}
			if(erpDetailGrid.getColumnId(columnIdx) == "SALE_VAT_AMT"){
				if(erpDetailGrid.cells(rowId, columnIdx).getValue() == 0){
					
				}
			}
		});
		erpDetailGrid.attachEvent("onRowDblClicked", function (rId,columnIdx){
			columnIdx = erpDetailGrid.getColIndexById("NO");//수정 안되도록
		});
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
		var dataObj = $erp.dataSerialize("tb_search");
		var data = $erp.unionObjArray([dataObj,LUI]);
		var DATE_FR = document.getElementById("txtDATE_FR").value;
		var DATE_TO = document.getElementById("txtDATE_TO").value;
		
		if(Number(DATE_FR.split("-").join("")) <= Number(DATE_TO.split("-").join(""))) {
			total_layout.progressOn();
			$.ajax({
				url: "/sis/sales/getsalesByStoreHeaderList.do"
				, data : data
				,method : "POST"
					,dataType : "JSON"
					,success : function(data){
						Dbcheck = 0;
						$erp.clearDhtmlXGrid(erpHeaderGrid);
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
														, [ "SUM_SALE_AMT"
															,"SUM_PAY_CASH"
															,"SUM_PAY_CARD"
															,"SUM_PAY_GIFT"
															,"SUM_PAY_POINT"
															,"SUM_PAY_TRUST"
															,"SUM_DISC_AMT"]
														,"H"
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
		console.log(paramGridData)
		total_layout.progressOn();
		$.ajax({
			url: "/sis/sales/getsalesByStoreDetailList.do"
			, data : paramGridData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				Dbcheck = 1;
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					total_layout.progressOff();
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
												, ["SALE_QTY","SALE_AMT","SALE_VAT_AMT","DC_AMT"]
												,"D"
												,"합계");
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
					<td colspan="1">
						<div id="cmbORGN_CD"></div>
					</td>
					<th colspan="1">판매경로</th>
					<td colspan="1"><div id="cmbORD_TYPE"></div></td>
					<td colspan="3"></td>
				</tr>
				<tr>
					<th colspan="1">기간</th>
					<td colspan="2">
						<input type="text" id="txtDATE_FR" class="input_calendar default_date" data-position="" value="">
						<span style="float: left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO" class="input_calendar default_date" data-position="" value="" style="float: left; margin-left: 6px;">
					</td>
					<th colspan="1">판매유형</th>
					<td colspan="1"><div id="cmbSALE_TYPE"></div></td>
					<th colspan="1">상세유형</th>
					<td colspan="1"><div id="cmbREG_TYPE"></div></td>
					<td colspan="3"></td>
				</tr>
			</table>
		</div>
	</div>

	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bot_header_layout" class="div_grid_full_size" style="display:none"></div>
	<div id="div_bot_detail_layout" class="div_grid_full_size" style="display:none"></div>
</body>
</html>