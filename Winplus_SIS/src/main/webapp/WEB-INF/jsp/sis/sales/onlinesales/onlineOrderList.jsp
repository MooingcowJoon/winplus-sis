<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">
LUI = JSON.parse('${empSessionDto.lui}');
	var total_layout;
	var top_layout;
	var mid_layout;
	var ribbon;
	var erp_Grid;
	var ORDER_TYPE
	var currentGrid;
	var bot_layout_grid_B2B;
	var bot_layout_grid_B2C;
	var erpGridDataProcessor;
	var warning_unique_rowId_obj = {};
	var CUSTMR_NM_LIST_STRING = "";
	var GOODS_NO_LIST_STRING = "";
	var BCD_CD_LIST_STRING = "";
	var ORD_CD_LIST_STRING = "";
	var UNIQUE_INDEX_LIST_STRING = "";
	
	
	
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
		total_layout.cells("c").attachObject("div_bot_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
	}
	
	function init_top_layout(){
		cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","CT"], 220, "모두조회", false, false, null, null);
		cmbDATE = $erp.getDhtmlXComboCommonCode("cmbDATE", "DATE_TYPE", "DATE_TYPE", 220, false, false, false, false);
		
		
		cmbORDER_TYPE = $erp.getDhtmlXComboCommonCode("cmbORDER_TYPE","cmbORDER_TYPE", ["ORDER_TYPE"],220, false, false);
		cmbORDER_TYPE.attachEvent("onChange", function(value, text){
			if(value != "B2B"){
				document.getElementById("div_bot_layout_B2C").style.display = "block";
				document.getElementById("div_bot_layout_B2B").style.display = "none";
			} else {
				document.getElementById("div_bot_layout_B2C").style.display = "none";
				document.getElementById("div_bot_layout_B2B").style.display = "block";
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
// 								, {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
								, {id : "delete_grid",	type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
								, {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
								, {id : "apply_grid",	type : "button", text:'WMS전송',										isbig : false, img : "menu/apply.gif",	imgdis : "menu/apply_dis.gif",	disable : true}
								, {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true, unused : false}
// 								, {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
								, {id : "excelForm_grid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : false}
								, {id : "excel_grid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : false}
								]
							}
							]
		});
		ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				CG_Check();
				var isValidated = true;
				
				var search_date_from = document.getElementById("txtDATE_FR").value;
				var search_date_to = document.getElementById("txtDATE_TO").value;
				var alertMessage = "";
				var alertCode = "";
				var alertType = "error";
				
				if($erp.isEmpty(search_date_from) || $erp.isEmpty(search_date_to)){
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
					var date_from = search_date_from.replace(/\-/g,'');
					var date_to = search_date_to.replace(/\-/g,'');
								
					if(date_from <= date_to) {
						var dataObj = $erp.dataSerialize("tb_search");
						var url = "/sis/sales/onlinesales/getOnlineOrderList.do";
						var send_data = $erp.unionObjArray([null,dataObj]);
						var if_success = function(data){
							$erp.clearDhtmlXGrid(currentGrid); //기존데이터 삭제
							if($erp.isEmpty(data.gridDataList)){
								//검색 결과 없음
								$erp.addDhtmlXGridNoDataPrintRow(currentGrid, '<spring:message code="info.common.noDataSearch" />');
							}else{
								currentGrid.parse(data.gridDataList,'js');
							}
							$erp.setDhtmlXGridFooterRowCount(currentGrid);
						}
						var if_error = function(){
						
						}
						$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
					} else {
						$erp.alertMessage({
							"alertMessage" : "기간이 올바르지 않습니다."
							, "alertCode" : null
							, "alertType" : "alert"
							, "isAjax" : false
						});
					}
				}
			} else if (itemId == "add_grid"){
					
			} else if (itemId == "delete_grid"){
				CG_Check();
				//WMS상태유형 : 수신완료 빼고
				var check = 0;
				var checkedRowIdList = currentGrid.getCheckedRows(currentGrid.getColIndexById("CHECK")).split(",");
				for(var i in checkedRowIdList){
					var WMS_STATE = currentGrid.cells(checkedRowIdList[i], currentGrid.getColIndexById("WMS_STATE")).getValue()
					var check = currentGrid.cells(checkedRowIdList[i], currentGrid.getColIndexById("CHECK")).getValue()
					if(WMS_STATE != 01 && WMS_STATE != 02) {
						currentGrid.cells(checkedRowIdList[i], currentGrid.getColIndexById("CHECK")).setValue("0")
						check = -1;
					}
				}
				if(check == -1) {
					$erp.alertMessage({
						"alertMessage" : "WMS 전송 전 (처리전,송신실패) 만</br>삭제 할 수 있습니다. ",
						"alertType" : "alert",
						"isAjax" : false
					});
				}
 				$erp.deleteGridCheckedRows(currentGrid);
			} else if (itemId == "save_grid"){
				CG_Check();
				$erp.gridValidationCheck(currentGrid, function(){
					var data1 = {};
					data1["CUSER"] = "${empSessionDto.emp_no}";
					data1["CPROGRM"] = "OnlineManagementController"
					var data = $erp.dataSerializeOfGrid(currentGrid,false,data1);

					var url = "/sis/sales/onlinesales/saveOnlineOrderList.do";
					var send_data = {"listMap" : data};
					var if_success = function(data){
						var typeAndcnt = data.typeAndcnt
						if(typeAndcnt.resultType == 1){
							$erp.alertSuccessMesage(function(){
								ribbon.callEvent("onClick", ["search_grid"]);
							});
						}else if(typeAndcnt.resultType == -1){
							$erp.alertMessage({
								"alertMessage" : "[저장 실패]</br>중복된 정보가 존재합니다."
								,"alertType" : "alert"
								,"isAjax" : false
								,"alertCallbackFn" : function(){
									ribbon.callEvent("onClick", ["search_grid"]);
								}
							});
						} else {
							$erp.alertMessage({
								"alertMessage" : "예외 발생"
								,"alertType" : "alert"
								,"isAjax" : false
								,"alertCallbackFn" : function(){
									ribbon.callEvent("onClick", ["search_grid"]);
								}
							});
						}
					}
					var if_error = function(XHR, status, error){
						
					}
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
				});
			} else if (itemId == "apply_grid"){
				CG_Check();
				var check = currentGrid.getCheckedRows(currentGrid.getColIndexById("CHECK"));
				if(check != ""){
					var checkedRowIdList = check.split(",");
					for(var i in checkedRowIdList){
						var WMS_STATE = currentGrid.cells(checkedRowIdList[i], currentGrid.getColIndexById("WMS_STATE")).getValue()
						if(WMS_STATE != 01 && WMS_STATE != 02) {
							currentGrid.cells(checkedRowIdList[i], currentGrid.getColIndexById("CHECK")).setValue("0")
							check = -1;
						}
					}
					if(check != -1){
						transWMS_STATE(currentGrid);	
					} else{
						$erp.alertMessage({
							"alertMessage" : "WMS 상태(처리전,송신실패)만 전송할 수 있습니다.",
							"alertType" : "alert",
							"isAjax" : false
						});
					}
				} else {
					$erp.alertMessage({
						"alertMessage" : "선택된 행이 없습니다. ",
						"alertType" : "alert",
						"isAjax" : false
					});
				}
			} else if (itemId == "excel_grid"){
				CG_Check();
				ORDER_TYPE = cmbORDER_TYPE.getSelectedValue();
				if(ORDER_TYPE != "B2B"){
					$erp.exportGridToExcel({
						"grid" : bot_layout_grid_B2C
						, "fileName" : "B2C_온라인주문"
						, "isOnlyEssentialColumn" : false
						, "excludeColumnIdList" : ['NO','CHECK','TRAN_YN','INSP_YN','GOODS_YN','UNIQUE_INDEX','UNIQUE_KEY','ORDER_TYPE','OUT_WARE_CD','CUSTMR_CD','ORD_CENT_CD','SEND_YN','SALE_VAT','PRINT_YN','PUR_CONF_YN','UNIQUE']
						, "isIncludeHidden" : true
						, "isExcludeGridData" : false
					});
				} else
					$erp.exportGridToExcel({
						"grid" : bot_layout_grid_B2B
						, "fileName" : "B2B_온라인주문"
						, "isOnlyEssentialColumn" : false
						, "excludeColumnIdList" : ['NO','CHECK','TRAN_YN','INSP_YN','GOODS_YN','UNIQUE_INDEX','UNIQUE_KEY','ORDER_TYPE','OUT_WARE_CD','CUSTMR_CD','ORD_CD','ORD_NO','GOODS_NO','GOODS_NM'
													,'DELI_NO','DELI_MEMO','ORD_CENT_CD','SEND_YN','PRINT_YN','PUR_CONF_YN','UNIQUE']
						, "isIncludeHidden" : true
						, "isExcludeGridData" : false
					});
			} else if (itemId == "excelForm_grid"){
				ORDER_TYPE = cmbORDER_TYPE.getSelectedValue();
				if(ORDER_TYPE != "B2B"){
					$erp.exportGridToExcel({
						"grid" : bot_layout_grid_B2C
						, "fileName" : "B2C_온라인주문 업로드용"
						, "isOnlyEssentialColumn" : false
						, "excludeColumnIdList" : ['NO','CHECK','ORDER_TYPE','CUSTMR_CD','BCD_CD','ORD_CENT_CD','SEND_YN','SALE_VAT','PRINT_YN','PUR_CONF_YN','SC_S_QTY','SC_M_QTY','SC_L_QTY'
													,'ORD_ONLINE_CD','ORD_SEQ','WMS_STATE','PUR_CONF_STATE','CPROGRM','CUSER','CDATE','UNIQUE','MUSER','MDATE'
													,'UNIQUE_INDEX','UNIQUE_KEY']
						, "isIncludeHidden" : false
						, "isExcludeGridData" : true
					});
				} else
					$erp.exportGridToExcel({
						"grid" : bot_layout_grid_B2B
						, "fileName" : "B2B_온라인주문 업로드용"
						, "isOnlyEssentialColumn" : false
						, "excludeColumnIdList" : ['NO','CHECK','ORDER_TYPE','GOODS_NO','GOODS_NM','DELI_NO','DELI_MEMO','UNIQUE','BCD_NM'
													,'CUSTMR_CD','ORD_CENT_CD','PRINT_YN','PUR_CONF_YN','ORD_ONLINE_CD','SEND_YN'
													,'WMS_STATE','PUR_CONF_STATE','CPROGRM','CUSER','CDATE','MPROGRM','MUSER','MDATE','UNIQUE_INDEX','UNIQUE_KEY']
						, "isIncludeHidden" : false
						, "isExcludeGridData" : true
					});
			} else if (itemId == "excel_grid_upload"){
				ORDER_TYPE = cmbORDER_TYPE.getSelectedValue();
				CG_Check();
				var win_id = "excelUploadPopup";
				var convertModuleUrl = ""; //엑셀로 컨버트 하는 모듈을 다른것을 사용하고자 할때만 사용
				var uploadFileLimitCount = 1; //파일 업로드 개수 제한
				var onUploadFile = function(files, uploadData, toGrid){
					var excelname = files['name']
					var name_array = excelname.split('_')
					if(ORDER_TYPE != name_array[0]){
						$erp.closePopup2(win_id)
						$erp.alertMessage({
							"alertMessage" : "주문처(B2B,B2C)를 확인하고 다시 업로드하세요.",
							"alertType" : "alert",
							"isAjax" : false,
							"alertCallbackFn" : function(){
								$erp.clearDhtmlXGrid(currentGrid);
							}
						});
					} else {
						var CUSTMR_NM_LIST_STRING = "";
						var GOODS_NO_LIST_STRING = "";
						var BCD_CD_LIST_STRING = "";
						var ORD_CD_LIST_STRING = "";
						var UNIQUE_INDEX_LIST_STRING = "";//초기화
						
						for(var index in uploadData){
							uploadData[index]["UNIQUE_INDEX"] = uploadData[index].ORD_CD + "_" + uploadData[index].ORD_NO+ "_" + uploadData[index].RESV_DATE + "_" + uploadData[index].SALE_DATE;
						}
						$erp.clearDhtmlXGrid(currentGrid);
						$erp.uploadDataParse(this, files, uploadData, toGrid, "UNIQUE_INDEX", "new", [], ["UNIQUE_INDEX"]);
					}
				}
				var onUploadComplete = function(uploadedFileInfoList, toGrid, result){
					if(ORDER_TYPE  == "B2B"){
						loadB2BSales(result,toGrid,currentGrid);
					} else if(ORDER_TYPE == "B2C"){
						loadB2CSales(result,toGrid,currentGrid);
					}
				}
				var onBeforeFileAdd = function(file){};
				var onBeforeClear = function(){};
				$erp.excelUploadPopup(currentGrid, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			} else if (itemId == "print_grid"){
				
			}
		});
	}
	
	function init_bot_layout() {
		erpGrid = {};
		//,"#text_filter" ,"#rspan"
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		grid_Columns_B2C = [
							{id : "NO", label:["순번"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
							, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "35", sort : "int", align : "center", isHidden : false, isDataColumn : false}
							
							, {id : "TRAN_YN", label:["전송유무"], type : "ro", width : "80", sort : "str", align : "center", isHidden : true, isEssential : false}
							, {id : "INSP_YN", label:["재전송유무"], type : "ro", width : "80", sort : "str", align : "center", isHidden : true, isEssential : false}
							, {id : "GOODS_YN", label:["주문 가능 상품 유무"], type : "ro", width : "150", sort : "str", align : "center", isHidden : true, isEssential : false}
							
							, {id : "SALE_DATE", label:["일자"], type : "ro", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "RESV_DATE", label:["납기일자"], type : "ro", width : "80", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "OUT_WARE_CD", label:["출하창고"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD","CT"]}
							, {id : "ORDER_TYPE", label:["주문유형"], type : "combo", width : "70", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORDER_TYPE"]}
							
					, {id : "WMS_STATE", label:["WMS상태유형"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["WMS_STATE","",""], isDisabled : true}
							
							, {id : "SHIPPER_NM", label:["수령자"], type : "ro", width : "70", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "SHIPPER_ZIP_NO", label:["수령자우편번호"], type : "ro", width : "70", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "SHIPPER_ADDR", label:["수령자주소"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "SHIPPER_TEL", label:["수령자전화번호"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "SHIPPER_PHONE", label:["수령자휴대폰번호"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "BCD_NM", label:["상품명"], type : "ro", width : "200", sort : "str", align : "left", isHidden : false, isEssential : false}
							, {id : "ORD_QTY", label:["주문수량"], type : "ro", width : "50", sort : "str", align : "right", isHidden : false, isEssential : true}
							, {id : "SC_S_QTY", label:["운임_소"], type : "ro", width : "50", sort : "str", align : "right", isHidden : false, isEssential : false}
							, {id : "SC_M_QTY", label:["운임_중"], type : "ro", width : "50", sort : "str", align : "right", isHidden : false, isEssential : false}
							, {id : "SC_L_QTY", label:["운임_대"], type : "ro", width : "50", sort : "str", align : "right", isHidden : false, isEssential : false}
							, {id : "DELI_PAY_TYPE", label:["선착불유형"], type : "ro", width : "50", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "DELI_MEMO", label:["배송요청메모"], type : "ro", width : "200", sort : "str", align : "center", isHidden : false, isEssential : false}
							, {id : "DELI_NO", label:["배송번호"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "ORD_CD", label:["주문고유코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "ORD_SEQ", label:["주문순번"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
							
							
					, {id : "CUSTMR_CD", label:["주문처코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
							, {id : "CUSTMR_NM", label:["주문처명"], type : "ro", width : "120", sort : "str", align : "left", isHidden : false, isEssential : false}
					, {id : "GOODS_NO", label:["상품번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
							, {id : "BCD_CD", label:["바코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
							, {id : "SALE_PRICE", label:["판매가(단가)"], type : "ron", width : "100", sort : "int", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000"}
							, {id : "SALE_VAT", label:["부가세"], type : "ron", width : "100", sort : "int", align : "center", isHidden : true, isEssential : false, numberFormat : "0,000"}
							, {id : "SALE_TOT_PRICE", label:["판매가총액"], type : "ron", width : "100", sort : "int", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "DELI_PRICE", label:["배송비"], type : "ron", width : "100", sort : "int", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "DELI_PRICE_TYPE", label:["배송구분"], type : "ro", width : "70", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "ORD_NO", label:["주문번호"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "BUY_NM", label:["구매자"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "BUY_TEL", label:["구매자전화번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "BUY_PHONE", label:["구매자휴대폰번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "PAY_DATE", label:["결제일시"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : false}
												
							, {id : "CUSER", label:["생성자"], type : "ro", width : "100", sort : "str", align : "center"}
							, {id : "CDATE"	, label:["생성일"], type : "ro", width : "100", sort : "str", align : "center"}
							, {id : "MUSER", label:["수정자"], type : "ro", width : "100", sort : "str", align : "center"}
							, {id : "MDATE", label:["수정일"], type : "ro", width : "100", sort : "str", align : "center"}
							, {id : "UNIQUE_INDEX", label:["유니크(엑셀업로드용)"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
							, {id : "UNIQUE_KEY", label:["유닠(wms전송용)"], type : "ro", width : "200", sort : "str", align : "center", isHidden : true}
							];
		
		bot_layout_grid_B2C = new dhtmlXGridObject({
			parent: "div_bot_layout_B2C"
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : grid_Columns_B2C
		});
		
		$erp.initGrid(bot_layout_grid_B2C,{multiSelect : true});
		
		bot_layout_grid_B2C.attachEvent("onCellChanged", function (rowId,columnIdx,newValue){
			if(bot_layout_grid_B2C.getColumnId(columnIdx) == "TRAN_YN"){
				if(bot_layout_grid_B2C.cells(rowId, columnIdx).getValue() == 'Y') {
					bot_layout_grid_B2C.setRowTextStyle(rowId,"background-color:#BAFAE6");
				}else if(bot_layout_grid_B2C.cells(rowId, columnIdx).getValue() == 'N') {
					bot_layout_grid_B2C.setRowTextStyle(rowId,"background-color:red");
				}
			}
			if(bot_layout_grid_B2C.getColumnId(columnIdx) == "INSP_YN"){
				if(bot_layout_grid_B2C.cells(rowId, columnIdx).getValue() == 'Y') {
					bot_layout_grid_B2C.setRowTextStyle(rowId,"background-color:#FAF9BA");
				}
			}
			if(bot_layout_grid_B2C.getColumnId(columnIdx) == "GOODS_YN"){
				if(bot_layout_grid_B2C.cells(rowId, columnIdx).getValue() == 'N') {
					bot_layout_grid_B2C.setRowTextStyle(rowId,"background-color:#FABAF3");
				}
			}
		});
		
		erpGrid["div_bot_layout_B2C"] = bot_layout_grid_B2C;
		document.getElementById("div_bot_layout_B2C").style.display = "block";

		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		//쿠팡팡 판매내역 Grid
		grid_Columns_B2B = [
							{id : "NO", label:["순번"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
							, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
							
							, {id : "TRAN_YN", label:["전송유무"], type : "ro", width : "80", sort : "str", align : "center", isHidden : true}
							, {id : "INSP_YN", label:["재전송유무"], type : "ro", width : "80", sort : "str", align : "center", isHidden : true}
							, {id : "GOODS_YN", label:["주문 가능 상품 유무"], type : "ro", width : "150", sort : "str", align : "center", isHidden : true}
							
							, {id : "SALE_DATE", label:["일자"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "RESV_DATE", label:["납기일자"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "OUT_WARE_CD", label:["출하창고"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD","CT"]}
							, {id : "ORDER_TYPE", label:["주문유형"], type : "combo", width : "70", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORDER_TYPE"]}
							
					, {id : "WMS_STATE", label:["WMS상태유형"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["WMS_STATE",""]}
							
							, {id : "CUSTMR_CD", label:["주문처코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : true}
							, {id : "CUSTMR_NM", label:["주문처명"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "BCD_CD", label:["바코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							
					, {id : "GOODS_NO", label:["상품번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
							, {id : "BCD_NM", label:["상품명"], type : "ro", width : "200", sort : "str", align : "left", isHidden : false, isEssential : false}
							, {id : "SHIPPER_ADDR", label:["수령지"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "DELI_YN", label:["택배구분"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["DELI_YN","",""]}
							, {id : "SHIPPER_NM", label:["수령자"], type : "ro", width : "80", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "SHIPPER_ZIP_NO", label:["수령자우편번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
							, {id : "SHIPPER_TEL", label:["수령자전화번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
							, {id : "SHIPPER_PHONE", label:["수령자휴대폰번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
							, {id : "SALE_PRICE", label:["판매가(단가)"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "SALE_VAT", label:["부가세"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "ORD_QTY", label:["발주수량"], type : "ron", width : "50", sort : "str", align : "center", isHidden : false, isEssential : true}
							
							, {id : "SALE_TOT_PRICE", label:["판매가총액"], type : "ron", width : "100", sort : "int", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "ORD_CD", label:["발주번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "ORD_NO", label:["주문번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
							, {id : "ORD_SEQ", label:["주문순번"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
							
//							, {id : "DELI_NO", label:["배송번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
//							, {id : "DELI_MEMO", label:["배송요청메모"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "CUSER", label:["생성자"], type : "ro", width : "100", sort : "str", align : "center"}
							, {id : "CDATE"	, label:["생성일"], type : "ro", width : "100", sort : "str", align : "center"}
							, {id : "MUSER", label:["수정자"], type : "ro", width : "100", sort : "str", align : "center"}
							, {id : "MDATE", label:["수정일"], type : "ro", width : "100", sort : "str", align : "center"}
							
							, {id : "UNIQUE_INDEX", label:["유니크(엑셀업로드용)"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
							, {id : "UNIQUE_KEY", label:["유닠(wms전송용)"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true}
							];
		
		bot_layout_grid_B2B = new dhtmlXGridObject({
			parent: "div_bot_layout_B2B"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : grid_Columns_B2B
		});

		$erp.initGrid(bot_layout_grid_B2B,{multiSelect : true});
		
		bot_layout_grid_B2B.attachEvent("onCellChanged", function (rowId,columnIdx,newValue){
			if(bot_layout_grid_B2B.getColumnId(columnIdx) == "TRAN_YN"){
				if(bot_layout_grid_B2B.cells(rowId, columnIdx).getValue() == 'Y') {
					bot_layout_grid_B2B.setRowTextStyle(rowId,"background-color:#BAFAE6");
				}else if(bot_layout_grid_B2B.cells(rowId, columnIdx).getValue() == 'N') {
					bot_layout_grid_B2B.setRowTextStyle(rowId,"background-color:red");
				}
			}
			if(bot_layout_grid_B2B.getColumnId(columnIdx) == "INSP_YN"){
				if(bot_layout_grid_B2B.cells(rowId, columnIdx).getValue() == 'Y') {
					bot_layout_grid_B2B.setRowTextStyle(rowId,"background-color:#FAF9BA");
				}
			}
			if(bot_layout_grid_B2B.getColumnId(columnIdx) == "GOODS_YN"){
				if(bot_layout_grid_B2B.cells(rowId, columnIdx).getValue() == 'N') {
					bot_layout_grid_B2B.setRowTextStyle(rowId,"background-color:#FABAF3");
				}
			}
		});
		
		erpGrid["div_bot_layout_B2B"] = bot_layout_grid_B2B;
	}
	
	function loadB2CSales(result,currentGrid){
		var CUSTMR_NM_LIST_STRING = "";
		var GOODS_NO_LIST_STRING = "";
		var UNIQUE_INDEX_LIST_STRING = "";
		
		var data;
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];
			CUSTMR_NM_LIST_STRING += data["CUSTMR_NM"] + ","
			GOODS_NO_LIST_STRING += data["GOODS_NO"] + ","
			UNIQUE_INDEX_LIST_STRING += data["UNIQUE_INDEX"] + ","
		}
		
		
		var url = "/sis/sales/onlinesales/getOnlineSalesB2CInfo.do";
		var send_data = {"GOODS_NO_LIST_STRING" : GOODS_NO_LIST_STRING
						,"CUSTMR_NM_LIST_STRING": CUSTMR_NM_LIST_STRING
						,"UNIQUE_INDEX_LIST_STRING": UNIQUE_INDEX_LIST_STRING
						};
		var if_success = function(data){
			var gridDataList = data.gridDataList;
			for(var index in gridDataList){
				currentGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], currentGrid.getColIndexById("CUSTMR_CD")).setValue(gridDataList[index]["CUSTMR_CD"]);
				currentGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], currentGrid.getColIndexById("BCD_CD")).setValue(gridDataList[index]["BCD_CD"]);
				currentGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], currentGrid.getColIndexById("ORDER_TYPE")).setValue("B2C");
				currentGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], currentGrid.getColIndexById("WMS_STATE")).setValue("01");
				result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]].push("로드완료");
			} 
			
			var notExistList = [];
			var value;
			var state;
			var dp = currentGrid.getDataProcessor();
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["UNIQUE_INDEX"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			
			$erp.deleteGridRows(currentGrid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>[무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			if(currentGrid.getRowsNum() == 0){
				ribbon.callEvent("onClick",["search_grid"]);
				return;
			}
			
			$erp.setDhtmlXGridFooterRowCount(currentGrid); // 현재 행수 계산
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
	function loadB2BSales(result,currentGrid){
		var CUSTMR_NM_LIST_STRING = "";
		var BCD_CD_LIST_STRING = "";
		var UNIQUE_INDEX_LIST_STRING = "";
		
		var data;
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];
			CUSTMR_NM_LIST_STRING += data["CUSTMR_NM"] + ","
			BCD_CD_LIST_STRING += data["BCD_CD"] + ","
			UNIQUE_INDEX_LIST_STRING += data["UNIQUE_INDEX"] + ","
		}
		
		var url = "/sis/sales/onlinesales/getOnlineSalesB2BInfo.do";
		var send_data = {"BCD_CD_LIST_STRING" : BCD_CD_LIST_STRING
						,"CUSTMR_NM_LIST_STRING": CUSTMR_NM_LIST_STRING
						,"UNIQUE_INDEX_LIST_STRING": UNIQUE_INDEX_LIST_STRING
						};
		var if_success = function(data){		
			var gridDataList = data.gridDataList;
			for(var index in gridDataList){
				currentGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], currentGrid.getColIndexById("CUSTMR_CD")).setValue(gridDataList[index]["CUSTMR_CD"]);
				currentGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], currentGrid.getColIndexById("BCD_NM")).setValue(gridDataList[index]["BCD_NM"]);
				currentGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], currentGrid.getColIndexById("ORDER_TYPE")).setValue("B2B");
				currentGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]][1], currentGrid.getColIndexById("WMS_STATE")).setValue("01");
				result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["UNIQUE_INDEX"]].push("로드완료");
			}
			
			var notExistList = [];
			var value;
			var state;
			var dp = currentGrid.getDataProcessor();
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["UNIQUE_INDEX"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			
			$erp.deleteGridRows(currentGrid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>[무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			$erp.setDhtmlXGridFooterRowCount(currentGrid); // 현재 행수 계산
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
	function CG_Check() {//current grid check
		ORDER_TYPE = cmbORDER_TYPE.getSelectedValue();
		if(ORDER_TYPE != "B2B"){
			currentGrid = bot_layout_grid_B2C
		} else if(ORDER_TYPE == "B2B"){
			currentGrid = bot_layout_grid_B2B
		}
		currentGrid.setColumnHidden(currentGrid.getColIndexById("TRAN_YN"),true);
		currentGrid.setColumnHidden(currentGrid.getColIndexById("INSP_YN"),true);
		currentGrid.setColumnHidden(currentGrid.getColIndexById("GOODS_YN"),true);
	}
	
	function transWMS_STATE(grid) {
		var checkedRowIdList = grid.getCheckedRows(grid.getColIndexById("CHECK")).split(",");
		var ORD_CD_LIST = "";
		var ORD_NO_LIST = "";
		var SALE_DATE_LIST = "";
		var RESV_DATE_LIST = "";
		
		$erp.confirmMessage({
			"alertMessage" : "WMS로 전송하시겠습니까? ",
			"alertType" : "info",
			"isAjax" : false,
			"alertCallbackFn" : function (){
				total_layout.progressOn();
				var SALE_hyphen;
				var RESV_hyphen;
				var ORD_CD;
				var ORD_NO;
				var SALE_DATE;
				var RESV_DATE;
				
			for(var i in checkedRowIdList){
				ORD_CD = grid.cells(checkedRowIdList[i], grid.getColIndexById("ORD_CD")).getValue();
				ORD_NO = grid.cells(checkedRowIdList[i], grid.getColIndexById("ORD_NO")).getValue();
				SALE_hyphen = grid.cells(checkedRowIdList[i], grid.getColIndexById("SALE_DATE")).getValue();
				RESV_hyphen = grid.cells(checkedRowIdList[i], grid.getColIndexById("RESV_DATE")).getValue();
				
				var SALE_DATE = SALE_hyphen.replace(/\-/g,'');
				var RESV_DATE = RESV_hyphen.replace(/\-/g,'');
				
				ORD_CD_LIST += ORD_CD + ",";
				ORD_NO_LIST += ORD_NO + ",";
				SALE_DATE_LIST += SALE_DATE + ",";
				RESV_DATE_LIST += RESV_DATE + ",";
			}
			var data = {
					"ORD_NO_LIST" : ORD_NO_LIST
					,"ORD_CD_LIST" : ORD_CD_LIST
					,"SALE_DATE_LIST" : SALE_DATE_LIST
					,"RESV_DATE_LIST" : RESV_DATE_LIST
				};
			
			var data1 = {};
			data1["STD_DATE_TYPE"] = cmbDATE.getSelectedValue()
			var search_date_from = document.getElementById("txtDATE_FR").value;
			var search_date_to = document.getElementById("txtDATE_TO").value;
			var date_from = search_date_from.replace(/\-/g,'');
			var date_to = search_date_to.replace(/\-/g,'');
			data1["DATE_FR"] = date_from;
			data1["DATE_TO"] = date_to;

			var send_data = $erp.unionObjArray([data,data1]);
			$.ajax({
					url : "/sis/sales/onlinesales/TransmissionToWMS.do"
					,data : send_data
					,method : "POST"
					,dataType : "JSON"
					,success : function(data){
						total_layout.progressOff();
						//리턴 받은 데이터
						var gridDataList = data.gridDataList;
						
						var tran_Y	= 0;
						var tran_N	= 0;
						var insp	= 0;
						var goods	= 0;
						
						var findItem;
						for(var i=0; i<gridDataList.length; i++){
							findItem = grid.findCell(gridDataList[i].UNIQUE_KEY,grid.getColIndexById("UNIQUE_KEY"),true,true);
							grid.cells(findItem[0][0],grid.getColIndexById("TRAN_YN")).setValue(gridDataList[i].TRAN_YN);
							grid.cells(findItem[0][0],grid.getColIndexById("INSP_YN")).setValue(gridDataList[i].INSP_YN);
							grid.cells(findItem[0][0],grid.getColIndexById("GOODS_YN")).setValue(gridDataList[i].GOODS_YN);
							
								
							if(gridDataList[i].TRAN_YN == 'Y'){
								tran_Y += 1
							}else if(gridDataList[i].TRAN_YN == 'N'){
								tran_N += 1
							}
							if(gridDataList[i].INSP_YN == 'Y'){
								insp += 1 
							} 
							if(gridDataList[i].GOODS_YN == 'N'){
								goods += 1 
							}
						}
						 if(data.isError){
							$erp.ajaxErrorMessage(data);
						} else {
							if(tran_Y == 0 && tran_N == 0){
								$erp.alertMessage({
									"alertMessage" : "[무효]"
									,"alertType" : "alert"
									,"isAjax" : false
								});
							} else {
								$erp.alertMessage({
									"alertMessage" : "[전송 성공 : " + tran_Y + "건]<br/>[전송 오류 : " + tran_N + 
										"건]<br/>[전송실패](빨간색) / [재전송](노란색)<br/>[주문 불가 상품](분홍색)"
									,"alertType" : "alert"
									,"isAjax" : false
								});
							}
						}
						var gridRowCount = grid.getAllRowIds(",");
						var RowCountArray = gridRowCount.split(",");
						for(var i = 0 ; i < RowCountArray.length ; i++){
							grid.cells(RowCountArray[i], grid.getColIndexById("CHECK")).setValue(0);
						}
					}, error : function(jqXHR, textStatus, errorThrown){
						total_layout.progressOff();
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
			}
		});
	}
	
</script>
</head>
<body>
	<div id="div_top_layout" class="samyang_div" style="display:none">
		<div id="div_top_layout_search" class="samyang_div">
			<table id="tb_search" class="table_search">
				<colgroup>
					<col width="80px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="140px"/>
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
						<input type="text" id="txtDATE_FR" class="input_calendar default_date" data-position="" value="">
						<span style="float: left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO" class="input_calendar default_date" data-position="" value="" style="float: left; margin-left: 6px;">
					</td>
					<th colspan="1">일자 구분</th>
					<td colspan="2"><div id="cmbDATE"></div></td>
				</tr>
				<tr>
					<th colspan="1">센터</th>
					<td colspan="2"><div id="cmbORGN_CD" disabled></div></td>
					<th colspan="1">주문처</th>
					<td colspan="2"><div id="cmbORDER_TYPE"></div></td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bot_layout" class="div_grid_full_size" style="display:none">
		<div id="div_bot_layout_B2C" class="div_grid_full_size" style="display:none"></div>
		<div id="div_bot_layout_B2B" class="div_grid_full_size" style="display:none"></div>	
	</div>
	
</body>
</html>