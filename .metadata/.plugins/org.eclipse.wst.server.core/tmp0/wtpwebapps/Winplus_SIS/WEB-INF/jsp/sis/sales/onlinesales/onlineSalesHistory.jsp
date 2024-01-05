<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">
	
	var total_layout;
	var top_layout;
	var mid_layout;
	var ribbon;
	var ORDER_TYPE;

	var ORD_CD_LIST_STRING ="";
	var ORD_NO_LIST_STRING ="";
	var SALE_DATE_LIST_STRING ="";
	var RESV_DATE_LIST_STRING ="";
	var PUR_CONF_STATE_LIST_STRING ="";
	
	var UNIQUE_INDEX_LIST_STRING ="";
	
	
	$(document).ready(function() {
		init_total_layout();
		init_top_layout();
		init_mid_layout();
		init_bot_layout();
	});
	
	function init_total_layout() {
		total_layout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "검색 조건", header: false, fix_size : [true, true]}
				,{id: "b", text: "버튼 목록", header: false, fix_size:[true,true]}
				,{id: "c", text: "예비 바코드 그리드", header: false, fix_size:[true,true]}
			]
		});
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight(70);
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(40);
		total_layout.cells("c").attachObject("div_bot_layout_grid");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
	}
	
	function init_top_layout(){
		cmbTERM = new dhtmlXCombo("cmbTERM")
		cmbTERM.readonly(true);
		cmbTERM.addOption([
			{value: "", text: "전체보기", selected: true}
			,{value: "DATE", text: "일자별"}
			,{value: "MONTH", text: "월별"}
		]);
		
		cmbGROUPBY = new dhtmlXCombo("cmbGROUPBY")
		cmbGROUPBY.readonly(true);
		cmbGROUPBY.addOption([
			{value: "", text: "전체보기", selected: true}
			,{value: "GOODS", text: "상품별"}
			,{value: "CUSTMR", text: "주문처별"}
		]);
		
		cmbPUR_CONF_STATE = $erp.getDhtmlXComboCommonCode("cmbPUR_CONF_STATE","cmbPUR_CONF_STATE", ["PUR_CONF_STATE"],230, "모두조회", false);
		
		document.getElementById("MONTH").innerHTML = '<input type="text" id="txtMONTH_FR" class="input_calendar_ym default_date" data-position="" value="" style="float:left;"><span style="float:left; margin-left: 4px;">~</span><input type="text" id="txtMONTH_TO" class="input_calendar_ym default_date" data-position="" value="" style="float:left; margin-left: 6px;">';
		document.getElementById("DATE").innerHTML = '<input type="text" id="txtDATE_FR" class="input_calendar default_date" data-position="" value="" style="float:left;"><span style="float:left; margin-left: 4px;">~</span><input type="text" id="txtDATE_TO" class="input_calendar default_date" data-position="" value="" style="float:left; margin-left: 6px;">';
		
		$('#MONTH').hide();
		$('#DATE').show();
		cmbTERM.attachEvent("onChange",function(name, value){
			if(name=="DATE"){
				$('#MONTH').hide();
				$('#DATE').show();
				initdate();
			}else if(name=="MONTH"){
				$('#MONTH').show();
				$('#DATE').hide();
				initdate();
			}else if(name==""){
				$('#MONTH').hide();
				$('#DATE').show();
				initdate();
			}
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
			        		            {id : "search_grid",	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 			        		            , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
// 			        		            , {id : "delete_grid",	type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
			        		            , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
			        		            , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true, unused : false}
//			        		            , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
			        		            , {id : "excelForm_grid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : false}
			        		            , {id : "excel_grid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : false}
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
				var dhtmlXGridObj = bot_layout_grid;
				$erp.gridValidationCheck(bot_layout_grid, function(){
					saveErpGrid(dhtmlXGridObj)
				});
			} else if (itemId == "excel_grid"){
				$erp.exportGridToExcel({
					"grid" : bot_layout_grid
					, "fileName" : "판매내역(온라인)"
					, "isOnlyEssentialColumn" : false
					, "excludeColumnIdList" : ['NO','BCD_CD','CUSTMR_CD','UNIQUE_INDEX','GOODS_NO','UNIQUE_INDEX','GRUP_INDEX','WMS_STATE','ORDER_TYPE']
					, "isIncludeHidden" : true
					, "isExcludeGridData" : false
				});
			} else if (itemId == "excelForm_grid"){
				$erp.exportGridToExcel({
					"grid" : bot_layout_grid
					, "fileName" : "판매내역(온라인) - 업로드"
					, "isOnlyEssentialColumn" : false
					, "excludeColumnIdList" : ['NO','OUT_WARE_CD','DELI_YN','ORDER_TYPE','CUSTMR_CD','CUSTMR_NM','BCD_CD','BCD_NM','GOODS_NO','ORD_QTY','SALE_PRICE','SALE_VAT','SALE_TOT_PRICE','WMS_STATE','UNIQUE_INDEX','GRUP_INDEX']
					, "isIncludeHidden" : true
					, "isExcludeGridData" : true
				});
			} else if (itemId == "excel_grid_upload"){
				var convertModuleUrl = ""; //엑셀로 컨버트 하는 모듈을 다른것을 사용하고자 할때만 사용
		    	var uploadFileLimitCount = 1; //파일 업로드 개수 제한
		    		
		    	var onUploadFile = function(files, uploadData, toGrid){
					for(var index in uploadData){
						uploadData[index]["UNIQUE_INDEX"] = uploadData[index].ORD_CD + "_" + uploadData[index].ORD_NO + "_" + uploadData[index].SALE_DATE+ "_" + uploadData[index].RESV_DATE
					}
					$erp.uploadDataParse(this, files, uploadData, toGrid, "UNIQUE_INDEX", "add", [], ["UNIQUE_INDEX"]);
				}
		    	var onUploadComplete = function(uploadedFileInfoList, toGrid, result){
		    		console.log("result")
		    		console.log(result)
		    		//toGrid.selectRowById(toGrid.getRowId(result.insertedRowIndexList[0]),false,true,false);//업로드한 정보로 포커싱
		    		
		    		PurState_upload(result,toGrid);
		    	}
		    	var onBeforeFileAdd = function(file){};
		    	var onBeforeClear = function(){};
		 		$erp.excelUploadPopup(bot_layout_grid, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);			
			} else if (itemId == "print_grid"){
				
			}
		});
	}
	function isSearchValidate(){
		var isValidated = true;
		
		var searchDateFrom = $("#txtDATE_FR").val();
		var searchDateTo = $("#txtDATE_TO").val();
		var searchMonthFrom = document.getElementById("txtMONTH_FR").value;
		var searchMonthTo = document.getElementById("txtMONTH_TO").value;
		
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(searchDateFrom) || $erp.isEmpty(searchDateTo)){
			isValidated = false;
			alertMessage = "error.common.date.empty3";
			alertCode = "-1";
		}
		if($erp.isEmpty(searchMonthFrom) || $erp.isEmpty(searchMonthTo)){
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
			searchErpGrid(bot_layout_grid,searchDateFrom,searchDateTo,searchMonthFrom,searchMonthTo);
		}
	}
	function searchErpGrid(dhtmlXGridObj,searchDateFrom,searchDateTo,searchMonthFrom,searchMonthTo) {		
		var term_value = cmbTERM.getSelectedValue();
		var group_value = cmbGROUPBY.getSelectedValue();
		var groupbyId = term_value + group_value;
		
		var dataObj = $erp.dataSerialize("tb_search");
		var url = "/sis/sales/onlinesales/getOSHistoryList.do";
		var send_data = $erp.unionObjArray([dataObj]);
		if(Number(searchDateFrom.split("-").join("")) <= Number(searchDateTo.split("-").join("")) && Number(searchMonthFrom.split("-").join("")) <= Number(searchMonthTo.split("-").join(""))) {
			var if_success = function(data){
				$erp.clearDhtmlXGrid(dhtmlXGridObj); //기존데이터 삭제
				if($erp.isEmpty(data.gridDataList)){
					//검색 결과 없음
					$erp.addDhtmlXGridNoDataPrintRow(dhtmlXGridObj, '<spring:message code="info.common.noDataSearch" />');
				}else{
					dhtmlXGridObj.parse(data.gridDataList,'js');
					$erp.setDhtmlXGridFooterRowCount(dhtmlXGridObj);
					$erp.setDhtmlXGridFooterSummary(dhtmlXGridObj
							, [
								"ORD_QTY"
								,"SALE_PRICE"
								,"SALE_VAT"
								,"SALE_TOT_PRICE"]
								,1
								,"합계");
// 					gridGroupBy(dhtmlXGridObj); // 그룹 조건 없을 때 포함
					if(groupbyId != ""){gridGroupBy(dhtmlXGridObj);}
				}
			}	
			var if_error = function(){
				
			}
			$erp.setDhtmlXGridFooterRowCount(dhtmlXGridObj);
			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			
		} else
			$erp.alertMessage({
				"alertMessage" : "기간이 올바르지 않습니다."
				,"alertCode" : null
				,"alertType" : "alert"
				,"isAjax" : false
				,"alertCallbackFn" : function() {
					initdate();
				}
			});
	}
	
	function saveErpGrid(dhtmlXGridObj) {
		//map 형태    key(PUR_CONF_STATE_LIST_STRING) : value('구매확정,구매확정,구매확정,주문취소,주문취소,반품주문,')
		
		var dhtmlXDataProcessor = dhtmlXGridObj.getDataProcessor();
		var row_count = dhtmlXGridObj.getRowsNum();
		var rId;
		var state;
		
		for(var row_idx = 0; row_idx < row_count; row_idx ++){
			rId = dhtmlXGridObj.getRowId(row_idx);
			if(dhtmlXDataProcessor){
				state = dhtmlXDataProcessor.getState(rId);
				if (state == "updated"){
					ORD_CD_LIST_STRING += dhtmlXGridObj.cells(rId, dhtmlXGridObj.getColIndexById("ORD_CD")).getValue() + ",";
					ORD_NO_LIST_STRING += dhtmlXGridObj.cells(rId, dhtmlXGridObj.getColIndexById("ORD_NO")).getValue() + ",";
					SALE_DATE_LIST_STRING += dhtmlXGridObj.cells(rId, dhtmlXGridObj.getColIndexById("SALE_DATE")).getValue() + ",";
					RESV_DATE_LIST_STRING += dhtmlXGridObj.cells(rId, dhtmlXGridObj.getColIndexById("RESV_DATE")).getValue() + ",";
					PUR_CONF_STATE_LIST_STRING += dhtmlXGridObj.cells(rId, dhtmlXGridObj.getColIndexById("PUR_CONF_STATE")).getValue() + ",";
				}
			}
		}
		
		SALE_DATE_LIST_STRING = SALE_DATE_LIST_STRING.replace(/\-/g,'');
		RESV_DATE_LIST_STRING = RESV_DATE_LIST_STRING.replace(/\-/g,'');
		
		var paramData = {
			"ORD_CD_LIST_STRING" : ORD_CD_LIST_STRING
			,"ORD_NO_LIST_STRING" : ORD_NO_LIST_STRING
			,"SALE_DATE_LIST_STRING" : SALE_DATE_LIST_STRING
			,"RESV_DATE_LIST_STRING" : RESV_DATE_LIST_STRING
			,"PUR_CONF_STATE_LIST_STRING" : PUR_CONF_STATE_LIST_STRING
			};
		
		console.log(paramData)
		total_layout.progressOn();
		$.ajax({
			url : "/sis/sales/onlinesales/saveOnlineHistoryList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				total_layout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.alertSuccessMesage(function(){
						ribbon.callEvent("onClick", ["search_grid"]);
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				total_layout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		
		ORD_CD_LIST_STRING ="";
		ORD_NO_LIST_STRING ="";
		SALE_DATE_LIST_STRING ="";
		RESV_DATE_LIST_STRING ="";
		PUR_CONF_STATE_LIST_STRING ="";
		
		UNIQUE_INDEX_LIST_STRING ="";
	}
	
	function init_bot_layout() {
		erpGrid = {};
		//,"#text_filter" ,"#rspan"
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		grid_Columns = [
						{id : "NO", label:["순번"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
						, {id : "SALE_DATE", label:["일자"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
						, {id : "RESV_DATE", label:["납기예정일자"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
						, {id : "PUR_CONF_STATE", label:["구매상태"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true , commonCode : ["PUR_CONF_STATE"]}
						, {id : "ORD_CD", label:["주문고유코드"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
						, {id : "ORD_NO", label:["주문번호"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
						, {id : "OUT_WARE_CD", label:["출하창고"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD"]}
						
						
						, {id : "CUSTMR_NM", label:["주문처명"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}							
						, {id : "BCD_CD", label:["바코드"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}
						
						, {id : "BCD_NM", label:["상품명"], type : "ro", width : "300", sort : "str", align : "left", isHidden : false, isEssential : true}
						, {id : "ORD_QTY", label:["주문수량"], type : "ro", width : "70", sort : "str", align : "right", isHidden : false, isEssential : true}
						, {id : "SALE_PRICE", label:["판매가(단가)"], type : "ron", width : "70", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
						, {id : "SALE_VAT", label:["부가세"], type : "ron", width : "70", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
						, {id : "SALE_TOT_PRICE", label:["판매가총액"], type : "ron", width : "70", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
						, {id : "DELI_YN", label:["택배여부"], type : "combo", width : "70", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["DELI_YN"], isDisabled : true}
						, {id : "WMS_STATE", label:["WMS전송상태"], type : "combo", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false, commonCode : ["WMS_STATE"], isDisabled : true}
						, {id : "ORDER_TYPE", label:["주문유형"], type : "ro", width : "50", sort : "str", align : "center", isHidden : true, isEssential : true, commonCode : ["ORDER_TYPE"], isDisabled : true}
						, {id : "CUSTMR_CD", label:["주문처코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
						, {id : "GOODS_NO", label:["상품번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
						, {id : "UNIQUE_INDEX", label:["유닠"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
						, {id : "GRUP_INDEX", label:["그룹조건"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
						
						];
		bot_layout_grid = new dhtmlXGridObject({
			parent: "div_bot_layout_grid"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		$erp.attachDhtmlXGridFooterSummary(bot_layout_grid, [
				"ORD_QTY"
				,"SALE_PRICE"
				,"SALE_VAT"
				,"SALE_TOT_PRICE"]
				,1
				,"합계");
		$erp.initGrid(bot_layout_grid,{multiSelect : true});
		
		//groupBy
		bot_layout_grid.attachEvent("onPageChangeCompleted", function(){
			bot_layout_grid.progressOn();
			setTimeout(function(){
				gridGroupBy(bot_layout_grid);
				bot_layout_grid.progressOff();
			}, 10);
		});
	}
	
	function gridGroupBy(dhtmlXGridObj){
		var cId = dhtmlXGridObj.getColIndexById("GRUP_INDEX")
		var row_count = dhtmlXGridObj.getRowsNum();
		var rId;
		var LIST_STRING = "";
		
		for(var row_idx = 0; row_idx < row_count; row_idx ++){
			rId = dhtmlXGridObj.getRowId(row_idx);
			LIST_STRING += dhtmlXGridObj.cells(rId, cId).getValue() + ",";
		};
		console.log(LIST_STRING)
// 		<a href="javascript:void(0)" onclick="myGrid.collapseAllGroups()"> colapse</a>
		
		dhtmlXGridObj.groupBy(dhtmlXGridObj.getColIndexById("GRUP_INDEX"),["#title","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#stat_total","#stat_total","#stat_total","#stat_total","","",""]);
		dhtmlXGridObj.collapseAllGroups();//접힌 채 그리드
	}
	
	function PurState_upload(result){
		var data;
		
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];
			ORD_CD_LIST_STRING += data["ORD_CD"] + ","
			ORD_NO_LIST_STRING += data["ORD_NO"] + ","
			SALE_DATE_LIST_STRING += data["SALE_DATE"] + ","
			RESV_DATE_LIST_STRING += data["RESV_DATE"] + ","
			UNIQUE_INDEX_LIST_STRING += data["UNIQUE_INDEX"] + ","
		}
		
		var url = "/sis/sales/onlinesales/getPurFixInfo.do";
		var send_data = {"ORD_CD_LIST_STRING" : ORD_CD_LIST_STRING
						,"ORD_NO_LIST_STRING": ORD_NO_LIST_STRING
						,"SALE_DATE_LIST_STRING": SALE_DATE_LIST_STRING
						,"RESV_DATE_LIST_STRING": RESV_DATE_LIST_STRING
						,"UNIQUE_INDEX_LIST_STRING": UNIQUE_INDEX_LIST_STRING
						};
		console.log("send_data")
		console.log(send_data)
		var if_success = function(data){		
			var gridDataList = data.gridDataList;
			console.log("gridDataList")
			console.log(gridDataList)
			for(var index in gridDataList){
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("SALE_DATE")).setValue(gridDataList[index]["SALE_DATE"]);
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("RESV_DATE")).setValue(gridDataList[index]["RESV_DATE"]);
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("OUT_WARE_CD")).setValue(gridDataList[index]["OUT_WARE_CD"]);
// 				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("ORDER_TYPE")).setValue(gridDataList[index]["ORDER_TYPE"]);
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("CUSTMR_NM")).setValue(gridDataList[index]["CUSTMR_NM"]);
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("BCD_CD")).setValue(gridDataList[index]["BCD_CD"]);
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("BCD_NM")).setValue(gridDataList[index]["BCD_NM"]);
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("ORD_QTY")).setValue(gridDataList[index]["ORD_QTY"]);
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("SALE_PRICE")).setValue(gridDataList[index]["SALE_PRICE"]);
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("SALE_VAT")).setValue(gridDataList[index]["SALE_VAT"]);
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("SALE_TOT_PRICE")).setValue(gridDataList[index]["SALE_TOT_PRICE"]);
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("DELI_YN")).setValue(gridDataList[index]["DELI_YN"]);
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], bot_layout_grid.getColIndexById("WMS_STATE")).setValue(gridDataList[index]["WMS_STATE"]);
				result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]].push("로드완료");
			} 
			
			var notExistList = [];
			var value;
			var state;
			var dp = bot_layout_grid.getDataProcessor();
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["UNIQUE_INDEX"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			
			$erp.deleteGridRows(bot_layout_grid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>[무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			if(bot_layout_grid.getRowsNum() == 0){
				ribbon.callEvent("onClick",["search_grid"]);
				return;
			}
			
			$erp.setDhtmlXGridFooterRowCount(bot_layout_grid); // 현재 행수 계산
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
	function initdate(){
		document.getElementById("txtDATE_FR").value = $erp.getToday("-");
		document.getElementById("txtDATE_TO").value = $erp.getToday("-");
		document.getElementById("txtMONTH_FR").value = $erp.getToday("-");
		document.getElementById("txtMONTH_TO").value = $erp.getToday("-");
	}
	
</script>
</head>
<body>
	<div id="div_top_layout" class="samyang_div" style="display:none">
		<div id="div_top_layout_search" class="samyang_div">
			<table id="tb_search" class="table_search">
				<colgroup>
					<col width="160px"/>
					<col width="120px"/>
					<col width="140px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th colspan="1">기 간</th>
					<td colspan="2">
						<div id="DATE"></div>
						<div id="MONTH"></div>
					</td>
					<th colspan="1">일자별/월별</th>
					<td colspan="1"><div id="cmbTERM"></div></td>
				</tr>
				<tr>
					<th colspan="1">온라인 주문 판매 상태</th>
					<td colspan="2"><div id="cmbPUR_CONF_STATE"></div></td>
					<th colspan="1">상품별/거래처별</th>
					<td colspan="1"><div id="cmbGROUPBY"></div></td>
				</tr>
			</table>
		</div>
	</div>
	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_bot_layout_grid" class="div_grid_full_size" style="display:none"></div>
	
</body>
</html>