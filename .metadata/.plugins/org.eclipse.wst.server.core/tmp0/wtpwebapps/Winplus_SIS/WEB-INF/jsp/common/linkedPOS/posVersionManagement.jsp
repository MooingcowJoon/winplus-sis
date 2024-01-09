<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript"> 
	
	var erpLayout;
	var erpVersionLayout;
	var erpMarketLayout;
	var erpUploadLayout;
	var erpVerRibbon;
	var erpMarketRibbon;
	var erpUploadRibbon;
	var erpVerGridColumns;
	var erpVerMarketColumns;
	var erpVerUploadColumns;
	var erpVerGrid;
	var erpMarketGrid;
	var erpUploadGrid;
	var cmbMarketCD;
	var cmbVerMarketCD;
	var erpVersionGridDataProcessor;
	var erpMarketGridDataProcessor;
	var erpUploadGridDataProcessor;
	
	$(document).ready(function() {
		initErpLayout();
		initVerLayout();
		initVerRibbon();
		initVerGrid();
		initMarketLayout();
		initMarketRibbon();
		initMarketGrid();
		initUploadLayout();
		initUploadRibbon();
		initUploadGrid();
		
		initDhtmlXCombo();
	});
	
	<%-- ■ erpLayout 시작 --%>
	function initErpLayout() {
		erpLayout =new dhtmlXLayoutObject({
			parent: document.body
			, skin: ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3J"
			, cells : [
				{id: "a", text: "버전관리", header: true, fix_size : [false, true]}
				,{id: "b", text: "버전 업로드관리", header: true, fix_size : [false, true]}
				,{id: "c", text: "매장-포스 관리", header: true, fix_size : [false, true]}
			 ]
		});
		
		erpLayout.cells("a").attachObject("div_erp_version");
		erpLayout.cells("b").attachObject("div_erp_upload");
		erpLayout.cells("c").attachObject("div_erp_market_pos");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpVerLayout.setSizes();
			erpVerGrid.setSizes();
			erpMarketLayout.setSizes();
			erpMarketGrid.setSizes();
			erpUploadLayout.setSizes();
			erpUploadGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 끝 --%>
	
	<%-- ■ erpVerLayout 관련 Function 시작 --%>
	function initVerLayout() {
		erpVerLayout =new dhtmlXLayoutObject({
			parent: "div_erp_version"
			, skin: ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "조회조건영역", header: false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header: false, fix_size : [true, true]}
				,{id: "c", text: "그리드영역", header: false, fix_size : [true, true]}
			]
		});
		
		erpVerLayout.cells("a").attachObject("div_erp_ver_search");
		erpVerLayout.cells("a").setHeight(45);
		erpVerLayout.cells("b").attachObject("div_erp_ver_ribbon");
		erpVerLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpVerLayout.cells("c").attachObject("div_erp_ver_grid");
		
	}
	
	function initVerRibbon() {
		erpVerRibbon = new dhtmlXRibbon({
			parent : "div_erp_ver_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpVerGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "add_erpVerGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_erpVerGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "search_unUse_erpVerGrid", type : "button", text:'미사용', isbig : false, img : "menu/undo.gif", imgdis : "menu/undo_dis.gif", disable : true}
				]}
			]
		});
		
		erpVerRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpVerGrid"){
				SearchErpVerGrid();
			} else if(itemId == "add_erpVerGrid"){
				openPosVersionFileUploadPopup();
			} else if(itemId == "delete_erpVerGrid"){
				DeleteOrUndoVersionFile("delete");
			} else if(itemId == "search_unUse_erpVerGrid"){
				DeleteOrUndoVersionFile("undo");
			}
		});
	}
	
	function initVerGrid() {
		erpVerGridColumns = [
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "30", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "VER_SEQ", label:["버전SEQ"], type: "ro", width: "80", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "VER_NM", label:["버전명"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "ORG_FILE_NM", label:["파일명+확장자"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "FILE_NM", label:["파일명"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "FILE_SIZE", label:["파일사이즈"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "VER_DATE", label:["등록일"], type: "dhxCalendar", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, dateFormat : "%Y-%m-%d", isDisabled : true}
			, {id : "DELETE_FG", label:["사용가능여부"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["USE_CD", "BIT"]}
		];
		
		erpVerGrid = new dhtmlXGridObject({
			parent: "div_erp_ver_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpVerGridColumns
		});
		
		erpVerGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpVerGrid);
		$erp.initGridComboCell(erpVerGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpVerGrid, '<spring:message code="grid.allRowCount" />');
		
		erpVersionGridDataProcessor = new dataProcessor();
		erpVersionGridDataProcessor.init(erpVerGrid);
		erpVersionGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpVerGrid);
		$erp.attachDhtmlXGridFooterPaging(erpVerGrid, 100);
	}
	
	function UploadPopupClose(){
		$erp.closePopup2("openPosVersionFileUploadPopup");
	}
	
	function openPosVersionFileUploadPopup(){
		
		var params = {};
		var url = "/common/pos/PosVersionManagement/openPosVersionFileUploadPopup.sis";
		var option = {
				"width" : 500
				, "height" :180
				//, "resize" : false
				, "win_id" : "openPosVersionFileUploadPopup"
		}
		
		var onContentLoaded = function(){
			var popWin = this.getAttachedObject().contentWindow;
			if(UploadPopupClose && typeof UploadPopupClose === 'function'){
				while(popWin.UploadPopupClose == undefined){
					popWin.UploadPopupClose = UploadPopupClose;
				}
			}
			this.progressOff();
		}
		
		$erp.openPopup(url, params, onContentLoaded, option);
	}
	
	function SearchErpVerGrid() {
		var SEARCH_NM = document.getElementById("txtSearch_NM").value;
		
		var VersionDateFrom = document.getElementById("VersionDateFrom").value;
		var VersionDateTo = document.getElementById("VersionDateTo").value;
		if(VersionDateFrom <= VersionDateTo){
			erpLayout.progressOn();
			$.ajax({
				url: "/common/pos/PosVersionManagement/getPosVersionList.do"
				, data : {
					"SEARCH_NM" : SEARCH_NM
					, "VersionDateFrom" : VersionDateFrom
					, "VersionDateTo" : VersionDateTo
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpVerGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
									erpVerGrid
								,'<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpVerGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpVerGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}else{
			$erp.alertMessage({
				"alertMessage" : "기간이 올바르지 않습니다."
				,"alertCode" : null
				,"alertType" : "alert"
				,"isAjax" : false
				,"alertCallbackFn" : function() {
					document.getElementById("VersionDateFrom").value = $erp.getToday("-");
					document.getElementById("VersionDateTo").value = $erp.getToday("-");
				}
			});
		}
	}
	
	function DeleteOrUndoVersionFile(state){
		var VergridRowCount = erpVerGrid.getAllRowIds(",");
		var VerRowCountArray = VergridRowCount.split(",");
		
		var VerdeleteRowIdArray = [];
		var check = "";
		
		for(var i = 0 ; i < VerRowCountArray.length ; i++){
			check = erpVerGrid.cells(VerRowCountArray[i], erpVerGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				VerdeleteRowIdArray.push(VerRowCountArray[i]);
			}
		}
		
		if(VerdeleteRowIdArray.length == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		for(var j = 0; j < VerdeleteRowIdArray.length; j++){
			erpVerGrid.deleteRow(VerdeleteRowIdArray[j]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpVerGrid);
		var paramData = $erp.serializeDhtmlXGridData(erpVerGrid);
		paramData["STATE"] = state;
		paramData["SEARCH_NM"] = document.getElementById("txtSearch_NM").value;
		paramData["DateFrom"] = document.getElementById("VersionDateFrom").value;
		paramData["DateTo"] = document.getElementById("VersionDateTo").value;
		erpLayout.progressOn();
		$.ajax({
			url: "/common/pos/PosVersionManagement/saveVersionFileState.do"
			, data : paramData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpVerGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpVerGrid
							,  '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpVerGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpVerGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpVerLayout 관련 Function 끝 --%>
	
	<%-- ■ erpMarketLayout 관련 Function 시작 --%>
	function initMarketLayout(){
		erpMarketLayout =new dhtmlXLayoutObject({
			parent: "div_erp_market_pos"
			, skin: ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "조회조건영역", header: false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header: false, fix_size : [true, true]}
				,{id: "c", text: "그리드영역", header: false, fix_size : [true, true]}
			]
		});
		
		erpMarketLayout.cells("a").attachObject("div_erp_market_search");
		erpMarketLayout.cells("a").setHeight(20);
		erpMarketLayout.cells("b").attachObject("div_erp_market_ribbon");
		erpMarketLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpMarketLayout.cells("c").attachObject("div_erp_market_grid");
	}
	
	function initMarketRibbon() {
		erpMarketRibbon = new dhtmlXRibbon({
			parent : "div_erp_market_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpmarketGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					,{id : "add_erpmarketGrid", type : "button", text:'선택한매장으로 선택한 버전 적용', isbig : false, img : "menu/apply.gif", imgdis : "menu/app;y_dis.gif", disable : false}
				]}
			]
		});
		
		erpMarketRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpmarketGrid"){
				SearchMarketGrid();
			} else if(itemId == "add_erpmarketGrid"){
				var MarketCD = cmbMarketCD.getSelectedValue();
				cmbVerMarketCD.setComboValue(MarketCD);
				
				versionUploadSearch();
				setTimeout(function(){
					ApplyPosVersionFile();
				}, 500);
			}
		});
	}
	
	function initMarketGrid() {
		erpMarketGridColumns = [ 
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "30", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "ORGN_CD", label:["매장명"], type: "combo", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD", "MK"]}
			, {id : "TRML_NO", label:["POS NO"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "LAST_DTIME", label:["최종작업일"], type: "ed", width: "120", sort : "str", align : "center", isHidden : false, isEssential : true, dateFormat : "%Y-%m-%d", isDisabled : true}
		];
		
		erpMarketGrid = new dhtmlXGridObject({
			parent: "div_erp_market_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpMarketGridColumns
		});
		
		erpMarketGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpMarketGrid);
		$erp.initGridComboCell(erpMarketGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpMarketGrid, '<spring:message code="grid.allRowCount" />');
		
		erpMarketGridDataProcessor = new dataProcessor();
		erpMarketGridDataProcessor.init(erpMarketGrid);
		erpMarketGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpMarketGrid);
		$erp.attachDhtmlXGridFooterPaging(erpMarketGrid, 100);
	}
	
	function SearchMarketGrid(){
		var selected_market = cmbMarketCD.getSelectedValue();
		console.log(selected_market)
		erpLayout.progressOn();
		$.ajax({
			url: "/common/pos/PosVersionManagement/getVersionByMarketList.do"
			, data : {
				"SEARCH_MARKET" : selected_market
			}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpMarketGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpMarketGrid
							,  '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpMarketGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpMarketGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function ApplyPosVersionFile(){		
		var VerGridRowCount = erpVerGrid.getRowsNum();
		var VerCheckCnt = 0;
		var VerRId = "";
		var VerCheck = "";
		var selected_ver_rId = "";
		
		for(var i = 0; i < VerGridRowCount; i++){
			VerRId = erpVerGrid.getRowId(i);
			VerCheck = erpVerGrid.cells(VerRId, erpVerGrid.getColIndexById("CHECK")).getValue();
			if(VerCheck == "1") {
				if(VerCheckCnt == 0){
					selected_ver_rId = VerRId;
				}
				VerCheckCnt += 1;
			}
		}
		
		var MkGridRowCount = erpMarketGrid.getRowsNum();
		var MkCheckCnt = 0;
		var MkRId = "";
		var MkCheck = "";
		var selected_mk_rId = [];
		
		for(var i = 0; i < MkGridRowCount; i++){
			MkRId = erpMarketGrid.getRowId(i);
			MkCheck = erpMarketGrid.cells(MkRId, erpMarketGrid.getColIndexById("CHECK")).getValue();
			if(MkCheck == "1") {
				selected_mk_rId[MkCheckCnt] = MkRId;
				MkCheckCnt += 1;
			}
		}
		//중복 체크
		var check1 = "";
		var check2 = "";
		var gridRowCount = erpUploadGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		for(var i = 0 ; i < RowCountArray.length ; i++){
			check1 += erpUploadGrid.cells(RowCountArray[i], erpUploadGrid.getColIndexById("UNIQUE_KEY")).getValue() + ",";
		}
		
		var total_count = 0;
		if(VerCheckCnt == 1 && MkCheckCnt != 0){
			var delete_fg = erpVerGrid.cells(selected_ver_rId, erpVerGrid.getColIndexById("DELETE_FG")).getValue();
			if(delete_fg == '1'){
				var uid = "";
				
				for(var j = 0 ; j < selected_mk_rId.length ; j++){
					uid = erpUploadGrid.uid();
					erpUploadGrid.addRow(uid);
					
					erpUploadGrid.cells(uid, erpUploadGrid.getColIndexById("MS_NO")).setValue(erpMarketGrid.cells(selected_mk_rId[j], erpMarketGrid.getColIndexById("ORGN_CD")).getValue());
					erpUploadGrid.cells(uid, erpUploadGrid.getColIndexById("VER_ID")).setValue(erpVerGrid.cells(selected_ver_rId, erpVerGrid.getColIndexById("FILE_NM")).getValue());
					erpUploadGrid.cells(uid, erpUploadGrid.getColIndexById("POS_NO")).setValue(erpMarketGrid.cells(selected_mk_rId[j], erpMarketGrid.getColIndexById("TRML_NO")).getValue());
					erpUploadGrid.cells(uid, erpUploadGrid.getColIndexById("FILE_NM")).setValue(erpVerGrid.cells(selected_ver_rId, erpVerGrid.getColIndexById("FILE_NM")).getValue());
					erpUploadGrid.cells(uid, erpUploadGrid.getColIndexById("FILE_SZ")).setValue(erpVerGrid.cells(selected_ver_rId, erpVerGrid.getColIndexById("FILE_SIZE")).getValue());
					erpUploadGrid.cells(uid, erpUploadGrid.getColIndexById("VER_SEQ")).setValue(erpVerGrid.cells(selected_ver_rId, erpVerGrid.getColIndexById("VER_SEQ")).getValue());
					erpUploadGrid.cells(uid, erpUploadGrid.getColIndexById("UNIQUE_KEY")).setValue(erpVerGrid.cells(selected_ver_rId, erpVerGrid.getColIndexById("VER_SEQ")).getValue() + '_' + erpMarketGrid.cells(selected_mk_rId[j], erpMarketGrid.getColIndexById("ORGN_CD")).getValue() + '_' + erpMarketGrid.cells(selected_mk_rId[j], erpMarketGrid.getColIndexById("TRML_NO")).getValue() + '_' + erpVerGrid.cells(selected_ver_rId, erpVerGrid.getColIndexById("FILE_NM")).getValue());
					erpUploadGrid.cells(uid, erpUploadGrid.getColIndexById("CONFIRM_FG")).setValue('0');
					total_count += 1
					
					check2 += erpUploadGrid.cells(uid, erpUploadGrid.getColIndexById("UNIQUE_KEY")).getValue() + ",";
				}
				
				check1_arr = check1.split(",")
				check2_arr = check2.split(",")
				var value1;
				var value2;
				var dupli_count = 0;
				for(var i in check1_arr){
					for(var j in check2_arr){
						value1 = check1_arr[i]
						value2 = check2_arr[j]
						if(value1 == value2 && value1 != "" && value1 != null){
							dupli_count += 1
						}
					}
				}
				if(dupli_count != 0){
					$erp.alertMessage({
						"alertMessage" : "중복된 데이터가 있습니다.</br> [중복: " + dupli_count + "건]",
						"alertCode" : null,
						"alertType" : "alert",
						"alertCallbackFn" : function(){ versionUploadSearch(); },
						"isAjax" : false
					});
				} else if(dupli_count == 0){
					$erp.confirmMessage({
						"alertMessage" : "적용 사항을 저장하시겠습니까? </br> [적용 사항: " + total_count + "건]",
						//"alertType" : "info",
						"isAjax" : false,
						"alertCallbackFn" : function(){ versionUploadSave(); },
						"alertCallbackFnFalse" : function(){ versionUploadSearch(); }
					});
				}
			} else {
				$erp.alertMessage({
					"alertMessage" : "사용 상태인 버전 파일만 적용가능합니다.<br> 확인 후 다시 시도해주세요.",
					"alertCode" : null,
					"alertType" : "alert",
					"alertCallbackFn" : function applyCheck(){
						return false;
					},
					"isAjax" : false
				});
			}
		} else {
				$erp.alertMessage({
					"alertMessage" : "업로드할 버전파일 1개와 <br>적용할 매장별 포스를 1개이상 지정해주세요.",
					"alertCode" : null,
					"alertType" : "alert",
					"alertCallbackFn" : function applyCheck(){
						return false;
					},
					"isAjax" : false
				});
		}	
			
		
	}
	<%-- ■ erpMarketLayout 관련 Function 끝 --%>
	
	<%-- ■ erpUploadLayout 관련 Function 시작 --%>
	function initUploadLayout(){
		erpUploadLayout =new dhtmlXLayoutObject({
			parent: "div_erp_upload"
			, skin: ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "조회조건영역", header: false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header: false, fix_size : [true, true]}
				,{id: "c", text: "그리드영역", header: false, fix_size : [true, true]}
			 ]
		});
		
		erpUploadLayout.cells("a").attachObject("div_erp_upload_search");
		erpUploadLayout.cells("a").setHeight(20);
		erpUploadLayout.cells("b").attachObject("div_erp_upload_ribbon");
		erpUploadLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpUploadLayout.cells("c").attachObject("div_erp_upload_grid");
	}
	
	function initUploadRibbon() {
		erpUploadRibbon = new dhtmlXRibbon({
			parent : "div_erp_upload_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					 {id : "search_erpUploadGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 					, {id : "save_erpUploadGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
// 					, {id : "add_erpConfirmGrid", type : "button", text:'확정', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : true}
					, {id : "add_erpDownLoadGrid", type : "button", text:'다운로드', isbig : false, img : "menu/download.png", imgdis : "menu/download_dis.png", disable : true}
					, {id : "delete_erpUploadGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
				]}
			]
		});
		
		erpUploadRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpUploadGrid") {
				versionUploadSearch();
			} else if(itemId == "save_erpUploadGrid"){
				versionUploadSave();
			} else if(itemId == "add_erpConfirmGrid"){
				versionUploadConfirm();
			} else if(itemId == "add_erpDownLoadGrid"){
				downLink();
			} else if(itemId == "delete_erpUploadGrid"){
				versionUploadDelete();
			}
		});
	}
	
	function initUploadGrid() {
		erpUploadGridColumns = [
			  {id : "NO", label:["NO"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "30", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
// 			, {id : "SELECT", label : ["선택"], type : "ra", width : "35", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "SEQ", label:["SEQ"], type: "ro", width: " 80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "VER_SEQ", label:["버전SEQ"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MS_NO", label:["매장명"], type: "combo", width: "70", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD", "MK"]}
			, {id : "POS_NO", label:["POS"], type: "ro", width: "70", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "VER_ID", label:["버전ID"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : true}
			, {id : "FILE_NM", label:["파일명"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "CONFIRM_FG", label:["확정상태"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : "POS_VER_CONFIRM_FG"}
			, {id : "FILE_SZ", label:["파일사이즈"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "UNIQUE_KEY", label:["유니크"], type: "ro", width: "300", sort : "str", align : "left", isHidden : true, isEssential : true}
		];
		
		erpUploadGrid = new dhtmlXGridObject({
			parent: "div_erp_upload_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpUploadGridColumns
		});
		
		erpUploadGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpUploadGrid);
		$erp.initGridComboCell(erpUploadGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpUploadGrid, '<spring:message code="grid.allRowCount" />');
		
		erpUploadGridDataProcessor = new dataProcessor();
		erpUploadGridDataProcessor.init(erpUploadGrid);
		erpUploadGridDataProcessor.setUpdateMode("off");//변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpUploadGrid);
		$erp.attachDhtmlXGridFooterPaging(erpUploadGrid, 100);
	}
	
	function versionUploadConfirm() {
		var data = $erp.dataSerializeOfGrid(erpUploadGrid);
		console.log(data)
		var url = "/common/pos/PosVersionManagement/ConfirmPosVersion.do";
		var send_data = {"listMap" : data};
		var if_success = function(data){
			$erp.alertSuccessMesage(function(){
				versionUploadSearch();
			});
		}
		var if_error = function(XHR, status, error){
			
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
	}
	
	function versionUploadSearch(){
		var MS_NO = cmbVerMarketCD.getSelectedValue();//LEFT BOT
		erpLayout.progressOn();
		$.ajax({
			url: "/common/pos/PosVersionManagement/getPosVersionConfirmList.do"
			, data : {
				"MS_NO" : MS_NO
//				, "SearchDateFrom" : document.getElementById("SearchDateFrom").value
//				, "SearchDateTo" : document.getElementById("SearchDateTo").value
			}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpUploadGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpUploadGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpUploadGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpUploadGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function versionUploadDelete(){
		var gridRowCount = erpUploadGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		
		var deleteRowIdArray = [];
		var check = "";
		var count = 0;
		
		for(var i = 0 ; i < RowCountArray.length ; i++){
			console.log(i)
			check = erpUploadGrid.cells(RowCountArray[i], erpUploadGrid.getColIndexById("CHECK")).getValue();
			
			if(check == "1"){
				deleteRowIdArray.push(RowCountArray[i]);
				count += 1
			}
		}
		
		if(deleteRowIdArray.length == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		console.log(deleteRowIdArray)
		var confirm_fg;
		for(var j = 0; j < deleteRowIdArray.length; j++){
			erpUploadGrid.deleteRow(deleteRowIdArray[j]);
			confirm_fg = erpUploadGrid.cells(deleteRowIdArray[j], erpUploadGrid.getColIndexById("CONFIRM_FG")).getValue();
			console.log(confirm_fg)
			if(confirm_fg == "1"){
				$erp.alertMessage({
					"alertMessage" : "확정 상태인 데이터는 삭제할 수 없습니다.",
					"alertCode" : null,
					"alertType" : "info",
					"isAjax" : false,
					"alertCallbackFn" : function(){ versionUploadSearch(); }
				});
				return false;
			}
		}
		
		$erp.confirmMessage({
			"alertMessage" : "정말 삭제하시겠습니까? </br> [적용 대상: " + count + "건]",
			//"alertType" : "info",
			"isAjax" : false,
			"alertCallbackFn" : function(){ versionUploadDelete2(deleteRowIdArray); },
			"alertCallbackFnFalse" : function(){ versionUploadSearch(); }
		});
	}
	
	function versionUploadDelete2(deleteRowIdArray) {
		
		var seq_string="";
		for(var rId in deleteRowIdArray){
			seq_string += erpUploadGrid.cells(deleteRowIdArray[rId], erpUploadGrid.getColIndexById("SEQ")).getValue() + ",";
		}
		seq_string = seq_string.substr(0,seq_string.length-1);//마지막 콤마 삭제
		
		var paramData = {};
		paramData["SEQ_STRING"] = seq_string;
		
		console.log(paramData)
		erpLayout.progressOn();
		$.ajax({
			url: "/common/pos/PosVersionManagement/VersionUploadDelete.do"
			, data : paramData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				console.log(data.result)
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertSuccessMesage(function(){
						erpUploadRibbon.callEvent("onClick", ["search_erpUploadGrid"]);
					});
				}
				$erp.setDhtmlXGridFooterRowCount(erpUploadGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function versionUploadSave() {
		if(erpUploadGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var paramData = $erp.serializeDhtmlXGridData(erpUploadGrid);
		paramData["Search_Market"] = cmbVerMarketCD.getSelectedValue();
// 		paramData["SearchDateFrom"] = document.getElementById("SearchDateFrom").value;
// 		paramData["SearchDateTo"] = document.getElementById("SearchDateTo").value;
		
		console.log(paramData)
		erpLayout.progressOn();
		$.ajax({
			url: "/common/pos/PosVersionManagement/VersionUploadSave.do"
			, data : paramData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpUploadGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpUploadGrid
							,  '<spring:message code="grid.noSearchData" />'
						);
					}else {
						$erp.alertMessage({
							"alertMessage" : "저장되었습니다.",
							"alertCode" : null,
							"alertType" : "alert",
							"isAjax" : false
						});
						erpUploadGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpUploadGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function downLink() {
		var CHECK = erpUploadGrid.getCheckedRows(erpUploadGrid.getColIndexById("CHECK"));
		var check_arr = CHECK.split(",");
		var isvalidated = true;
		var alertMessage = "";
		for(var i=0;i<check_arr.length;i++){
			if(erpUploadGrid.cells(check_arr[i], erpUploadGrid.getColIndexById("CONFIRM_FG")).getValue() != "1"){
				isvalidated = false;
			}
		}
		if(!isvalidated){
			alertMessage = "다운로드받은 후 자동 확정처리됩니다.<br> 다운로드 받으시겠습니까?";
		} else {
			alertMessage = "다운로드 받으시겠습니까?";
		}
		if(CHECK == null || CHECK == ""){
			$erp.alertMessage({
				"alertMessage" : "다운로드 받을 항목을 선택해주세요.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		} else {//confirm으로
			$erp.confirmMessage({
				"alertMessage" : alertMessage,
				"alertCode" : null,
				"alertType" : "info",
				"alertCallbackFn" : function() {
					var FILE_NAME;
					var paramData;
					
					var i = -1;
					var it = setInterval(function(){
						erpLayout.progressOn();
						if(++i < check_arr.length){
							FILE_NAME = erpUploadGrid.cells(check_arr[i], erpUploadGrid.getColIndexById("FILE_NM")).getValue();
							paramData = {
 								"FILE_NAME" : FILE_NAME
 							}
 							$erp.downloadTool("/common/pos/PosVersionManagement/downloadVersionFile.do", paramData);
						}else{
							clearInterval(it);
							erpLayout.progressOff();
							if(isvalidated){
								versionUploadConfirm();//확정데이터 저장
							}
						}
					}, 2000);
					erpLayout.progressOff();
					//window.open("/common/pos/PosVersionManagement/downloadVersionFile.do?FILE_NAME="+FILE_NAME, "filedownloadifrm", "");
				}
				,"isAjax" : false
			});
		}
	}
	<%-- ■ erpUploadLayout 관련 Function 끝 --%>
	
	function initDhtmlXCombo(){
		cmbMarketCD = $erp.getDhtmlXComboCommonCode("cmbMarketCD", "cmbMarketCD", ["ORGN_CD", "MK"], 100, "모두조회", false, "");
		
		cmbVerMarketCD = $erp.getDhtmlXComboCommonCode("cmbVerMarketCD", "cmbVerMarketCD", ["ORGN_CD", "MK"], 100, "모두조회", false, "");
	
		cmbMarketCD.attachEvent("onChange", function(value, text){//leftbot
			$erp.clearDhtmlXGrid(erpMarketGrid);
		});
	}
	
</script>
</head>
<body>
	<div id="div_erp_version" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_ver_search" class="div_erp_contents_search" style="display:none">
			<table id="table_ver_search" class="table">
				<colgroup>
					<col width="80px">
					<col width="*">
				</colgroup>
				<tr>
					<th>일 자</th>
					<td>
						<input type="text" id="VersionDateFrom" name="VersionDateFrom" class="input_calendar">
					~ <input type="text" id="VersionDateTo" name="VersionDateTo" class="input_calendar">
					</td>
				</tr>
				<tr>
					<th>버전명</th>
					<td>
						<input type="text" id="txtSearch_NM" name="txtSearch_NM"  maxlength="20" class="input_common input_readonly" onkeydown="$erp.onEnterKeyDown(event, SearchErpVerGrid);">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_ver_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_ver_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	<div id="div_erp_market_pos" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_market_search"  class="div_erp_contents_search" style="display:none">
			<table id="table_market_search" class="table">
				<colgroup>
					<col width="80px">
					<col width="100px">
					<col width="*">
				</colgroup>
				<tr>
					<th>조직명</th>
					<td>
						<div id="cmbMarketCD"></div>
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_market_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_market_grid"  class="div_grid_full_size" style="display:none"></div>
	</div>
	<div id="div_erp_upload" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_upload_search" class="div_erp_contents_search" style="display:none">
			<table id="table_upload_search" class="table">
				<colgroup>
					<col width="120px">
					<col width="260px">
					<col width="*">
				</colgroup>
				<tr>
					<th>조직명</th>
					<td>
						<div id="cmbVerMarketCD"></div>
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_upload_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_upload_grid"  class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
<iframe id="filedownloadifrm" name="filedownloadifrm" style="display: none;"></iframe>
</html>