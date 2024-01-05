<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js?ver=36"></script>
<script type="text/javascript">

	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');

	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		
		■ erpLeftSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpLeftRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpLeftGrid : Object / 화면 조회 DhtmlXGrid
		■ erpLeftGridColumns : Array / erpLeftGrid DhtmlXGrid Header
		■ erpLeftGridDataProcessor : Object/ erpLeftGridDataProcessor DhtmlXDataProcessor
		
		■ erpRightSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 화면 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / erpRightGrid DhtmlXGrid Header
		■ erpRightGridDataProcessor : Object/ erpRightGridDataProcessor DhtmlXDataProcessor
		
		■ cmbORGN_CD : Object / 직영점선택구분 DhtmlXComboMulti (CODE : ORGN_CD / MK)
	--%>
	var erpLayout;
	var AUTHOR_CD = '${screenDto.author_cd}';
	var erpLeftSubLayout;
	var erpLeftRibbon;
	var erpLeftGrid;
	var erpLeftGridColumns;
	var erpLeftGridDataProcessor;
	
	var erpRightSubLayout;
	var erpRightRibbon;
	var erpRightGrid;
	var erpRightGridColumns;
	var erpRightGridDataProcessor;
	
	var cmbORGN_CD;
	var orgnCheck = LUI.LUI_orgn_delegate_cd;
	var today = $erp.getToday("");
	var thisYear = today.substring(0, 4);
	var thisMonth = today.substring(4, 6);
	var thisDay = today.substring(6, 8);
	var firstDate = thisYear + "-" + thisMonth + "-01";
	//today = thisYear + "-" + thisMonth + "-" + thisDay;
	var lastday = new Date(thisYear,thisMonth,0);
	var lastDate = $erp.getDateYMDFormat(lastday, "-");
	
	$(document).ready(function(){
		initErpLayout();
		
		initErpLeftSubLayout();
		initErpLeftRibbon();
		initErpLeftGrid();
		
		initErpRightSubLayout();
		initErpRightRibbon();
		initErpRightGrid();
		initDhtmlXCombo();		
		
		document.getElementById("searchDateFrom").value=firstDate;
		document.getElementById("searchDateTo").value=lastDate;
		
		$erp.asyncObjAllOnCreated(function(){
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "헤더그리드레이아웃영역", header:false, height:300, fix_size : [true, true]}
				, {id: "b", text: "디테일그리드레이아웃영역", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_left_sub_layout");
		erpLayout.cells("a").setHeight(370);
		erpLayout.cells("b").attachObject("div_erp_right_sub_layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpLeftSubLayout.setSizes();
			erpLeftGrid.setSizes();
			erpRightSubLayout.setSizes();
			erpRightGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%--
	**********************************************************************
	* ※ Left 영역
	**********************************************************************
	--%>
	<%-- ■ erpLeftSubLayout 관련 Function 시작 --%>
	<%-- erpLeftSubLayout 초기화 Function --%>
	function initErpLeftSubLayout(){
		erpLeftSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_left_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "검색어영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "그리드영역", header:false, fix_size : [true, true]}
			]
		});
		erpLeftSubLayout.cells("a").attachObject("div_erp_left_contents_search");
		erpLeftSubLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftSubLayout.cells("b").attachObject("div_erp_left_ribbon");
		erpLeftSubLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftSubLayout.cells("c").attachObject("div_erp_left_grid");
	}	
	<%-- ■ erpLeftSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpLeftRibbon 관련 Function 시작 --%>
	<%-- erpLeftRibbon 초기화 Function --%>
	function initErpLeftRibbon(){
		erpLeftRibbon = new dhtmlXRibbon({
			parent : "div_erp_left_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : "rows", list : [
					 {id : "search_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					,{id : "add_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					,{id : "delete_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					,{id : "save_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					,{id : "excel_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					//,{id : "print_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}	
				]}							
			]
		});
		
		erpLeftRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpLeftGrid"){
				searchErpLeftGrid();
		    } else if (itemId == "add_erpLeftGrid"){
		    	addErpLeftGrid();
		    } else if (itemId == "delete_erpLeftGrid"){
		    	deleteErpLeftGrid();
		    } else if (itemId == "save_erpLeftGrid"){
		    	saveErpLeftGrid();
		    } else if (itemId == "excel_erpLeftGrid"){
		    	$erp.exportGridToExcel({
		    		"grid" : erpLeftGrid
					, "fileName" : "가격변경예약_직영점"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
		    } else if (itemId == "print_erpLeftGrid"){
		    }
		});
	}
	<%-- ■ erpLeftRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpLeftGrid 관련 Function 시작 --%>	
	<%-- erpLeftGrid 초기화 Function --%>	
	function initErpLeftGrid(){
		erpLeftGridColumns = [
			{id : "NO", label : ["순번", "#rspan"], type : "cntr", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "SELECT", label : ["선택", "#rspan"], type : "ra", width : "40", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			,{id : "CHG_SEQ", label : ["CHG_SEQ", "#rspan"], type : "ron", width : "30", sort : "int", align : "center", isHidden : true, isEssential : false}
			,{id : "ORGN_DIV_CD", label : ["조직구분코드", "#rspan"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "ORGN_CD", label : ["직영점", "#rspan"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true, isDisabled:true, commonCode : ["ORGN_CD","CT,MK"]}
			,{id : "CHG_TITLE", label : ["가격변경제목", "#text_filter"], type : "ed", width : "110", sort : "str", align : "center", isHidden : false, isEssential : true, isSelectAll: true}
			,{id : "STRT_DATE", label : ["적용시작일자", "#text_filter"], type : "dhxCalendarA", width : "110", sort : "str", align : "center", isHidden : false, isEssential : true, isSelectAll: true}
			,{id : "STRT_TIME_HH", label : ["적용시작시간(시)", "#select_filter"], type : "combo", width : "110", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "HOUR", isSelectAll: true}
			,{id : "STRT_TIME_MM", label : ["적용시작시간(분)", "#select_filter"], type : "combo", width : "110", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "MINUTE", isSelectAll: true}
			,{id : "CHG_REMK", label : ["변경사유", "#text_filter"], type : "ed", width : "300", sort : "str", align : "left", isHidden : false, isEssential : true, isSelectAll: true}
		];
		
		erpLeftGrid = new dhtmlXGridObject({
			parent: "div_erp_left_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpLeftGridColumns
		});
		
		erpLeftGrid.attachEvent("onKeyPress",onDetailKeyPressed);
		erpLeftGrid.enableDistributedParsing(true, 100, 50);
		erpLeftGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpLeftGrid);
		$erp.initGridComboCell(erpLeftGrid);
		$erp.attachDhtmlXGridFooterPaging(erpLeftGrid, 100);
		$erp.attachDhtmlXGridFooterRowCount(erpLeftGrid, '<spring:message code="grid.allRowCount" />');
		
		erpLeftGridDataProcessor = new dataProcessor();
		erpLeftGridDataProcessor.init(erpLeftGrid);
		erpLeftGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpLeftGrid);
		
		erpLeftGrid.attachEvent("onCheck", function(rId,cInd){
			if(cInd == this.getColIndexById("SELECT")){
				searchErpRightGrid();
			}
		});
	}
	
	<%-- erpLeftGrid 조회 유효성 검사 Function --%>
	function isSearchErpLeftGridValidate(){
		var isValidated = true;
		
		var searchDateFrom = $("#searchDateFrom").val();
		var searchDateTo = $("#searchDateTo").val();
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(searchDateFrom)||$erp.isEmpty(searchDateTo)){
			isValidated = false;
			alertMessage = "error.common.date.empty3";
			alertCode = "-1";
			$("#searchDateFrom").focus();
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
	
	<%-- erpLeftGrid 조회 Function --%>
	function searchErpLeftGrid(){
		if(!isSearchErpLeftGridValidate()){
			return;
		}
		
// 		var resultData = $erp.tableValidationCheck("table_1");
// 		if(resultData === false){ //false 가 아닐시 정상(직렬화된 데이터)
// 			$erp.alertMessage({
// 				"alertMessage" : "검색 조건이 선택 되어있지 않습니다.",
// 				"alertType" : "alert",
// 				"isAjax" : false
// 			});
// 			return;
// 		}
		
		erpLeftSubLayout.progressOn();
		
		var searchDateFrom = $("#searchDateFrom").val();
		var searchDateTo = $("#searchDateTo").val();
		var orgn_cd = cmbORGN_CD.getChecked();
		var orgn_cd_text = cmbORGN_CD.getComboText();
		if(orgn_cd_text == "전체"){
			orgn_cd_text = "ALL";
		}else{
			orgn_cd_text = orgn_cd.join(",");
		}
		
		if(orgn_cd_text == ""){
			$erp.alertMessage({
				"alertMessage" : "조직명을 선택해 주세요.",
				"alertType" : "alert",
				"isAjax" : false
			});
			erpLeftSubLayout.progressOff();
		}else{
			$.ajax({
				url : "/sis/price/getPriceReservationHeaderList.do"
				,data : {
					"searchDateFrom" : searchDateFrom
					,"searchDateTo" : searchDateTo
					,"orgNcds" : orgn_cd_text
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpLeftSubLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						$erp.clearDhtmlXGrid(erpLeftGrid);
						$erp.clearDhtmlXGrid(erpRightGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpLeftGrid
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpLeftGrid.parse(gridDataList, 'js');
							//추후 상태값에 따른 색변경 설정 가능
							/* 
							var allRowIds = erpLeftGrid.getAllRowIds();
							var allRowArray = allRowIds.split(",");
							for(var i=0; i<allRowArray.length; i++){
								if(erpLeftGrid.cells(allRowArray[i],erpLeftGrid.getColIndexById("GOODS_STATE")).getValue() == "N"){
									erpLeftGrid.setRowTextStyle(allRowArray[i],"opacity:0.3;");
								}
							}
							 */
							for(var i = 0 ; i < erpLeftGrid.getRowsNum() ; i++){
								erpLeftGrid.cells(erpLeftGrid.getRowId(i), erpLeftGrid.getColIndexById("ORGN_CD")).setDisabled(true);
							}
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpLeftGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	<%-- erpLeftGrid 추가 Function --%>
	function addErpLeftGrid(){
		var ORGN_CD = cmbORGN_CD.getChecked();
		
		if(ORGN_CD == ""){
			$erp.alertMessage({
				"alertMessage" : "조직명을 선택해 주세요."
				, "alertType" : "alert"
				, "isAjax" : false
			});
		}else{
			var ORGN_NM =[];
			for (var i=0 ; i < ORGN_CD.length ; i++){
				ORGN_NM[i] = cmbORGN_CD.getOption(ORGN_CD[i]).text;
			}
			var check;
			if(ORGN_CD[0] != ""){
				check = 0;
			}else if(ORGN_CD[0] == ""){
				check = 1;
			}
			
			if (ORGN_NM.length != 0){
				for(var i = check; i < ORGN_NM.length; i++){
					var uid = erpLeftGrid.uid();
					erpLeftGrid.addRow(uid);
					erpLeftGrid.cells(uid, erpLeftGrid.getColIndexById("ORGN_CD")).setValue(ORGN_NM[i]);
				}
				erpLeftGrid.selectRow(erpLeftGrid.getRowIndex(uid));
				$erp.setDhtmlXGridFooterRowCount(erpLeftGrid);
			}
		}
		
	}
	
	<%-- erpLeftGrid 삭제 Function --%>
	function deleteErpLeftGrid(){
		var selectCellId = erpLeftGrid.findCell("1",erpLeftGrid.getColIndexById("SELECT"),false,true);
		var selectRowId = null;
		if(selectCellId.length > 0){
			selectRowId = selectCellId[0][0];
		} else {
			selectRowId = erpLeftGrid.getSelectedRowId();
		}
		
		if(erpLeftGrid.cells(selectRowId,erpLeftGrid.getColIndexById("CHG_SEQ")).getValue() == ""){
			erpLeftGrid.deleteRow(selectRowId);
		}else{
			if(selectRowId != null){
				var alertMessage = '<spring:message code="alert.sis.reservation.deleteCheck" />';
				var alertCode = "";
				var alertType = "alert";
				var callbackFunction = function(){
					erpLeftGrid.deleteRow(selectRowId);
					saveDelErpLeftGrid();
				}
				
				$erp.confirmMessage({
					"alertMessage" : alertMessage
					, "alertCode" : alertCode
					, "alertType" : alertType
					, "alertCallbackFn" : callbackFunction
				});
			}
		}
	}
	
	<%-- erpLeftGrid 저장 Function --%>
	function saveErpLeftGrid() {
		if(erpLeftGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpLeftGrid);
		
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		erpLeftSubLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpLeftGrid);
		var today = $erp.getToday("");
		var selectedRowId = erpLeftGrid.getSelectedRowId();
		var strt_date = erpLeftGrid.cells(selectedRowId, erpLeftGrid.getColIndexById("STRT_DATE")).getValue();
		var strtHH = erpLeftGrid.cells(selectedRowId, erpLeftGrid.getColIndexById("STRT_TIME_HH")).getValue();
		var strtMM = erpLeftGrid.cells(selectedRowId, erpLeftGrid.getColIndexById("STRT_TIME_MM")).getValue();
		var strtHM = strtHH + strtMM;
		
		var currentDate = new Date();
		var strt_hour = currentDate.getHours();
		var strt_min =currentDate.getMinutes();
		var strthm = strt_hour.toString() + strt_min.toString(); 
		var strthmN = parseInt(strthm);
		
		if (today <= strt_date){
			if(today == strt_date){
				if(strthmN <= strtHM){
					$.ajax({
						url : "/sis/price/updatePriceReservationHeaderList.do"
						,data : paramData
						,method : "POST"
						,dataType : "JSON"
						,success : function(data) {
							erpLeftSubLayout.progressOff();
							if(data.isError){
								$erp.ajaxErrorMessage(data);
							} else {
								$erp.alertSuccessMesage(onAfterSaveErpLeftGrid);
							}
						}, error : function(jqXHR, textStatus, errorThrown){
							erpLeftSubLayout.progressOff();
							$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
						}
					});
				} else {
					$erp.alertMessage({
						"alertMessage" : "지난시간은 예약할 수 없습니다."
							, "alertCode" : null
							, "alertType" : "alert"
							, "isAjax" : false
						});
				}
			} else {
				$.ajax({
					url : "/sis/price/updatePriceReservationHeaderList.do"
					,data : paramData
					,method : "POST"
					,dataType : "JSON"
					,success : function(data) {
						erpLeftSubLayout.progressOff();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						} else {
							$erp.alertSuccessMesage(onAfterSaveErpLeftGrid);
						}
					}, error : function(jqXHR, textStatus, errorThrown){
						erpLeftSubLayout.progressOff();
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});				
			}
		}else{
			$erp.alertMessage({
			"alertMessage" : "지난날짜는 예약할 수 없습니다."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
		}
		erpLeftSubLayout.progressOff();
		
	}
	
	<%-- erpLeftGrid 저장 후 Function --%>
	function onAfterSaveErpLeftGrid(){
		searchErpLeftGrid();
	}
	
	<%-- erpLeftGrid 저장 Function --%>
	function saveDelErpLeftGrid() {
		if(erpLeftGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpLeftGrid);
		
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		erpLeftSubLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpLeftGrid);
			$.ajax({
				url : "/sis/price/updatePriceReservationHeaderList.do"
				,data : paramData
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					erpLeftSubLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						$erp.alertSuccessMesage(onAfterSaveErpLeftGrid);
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLeftSubLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		erpLeftSubLayout.progressOff();
	}
	
	<%-- ■ erpLeftGrid 관련 Function 끝 --%>
	
	<%--
	**********************************************************************
	* ※ Right 영역
	**********************************************************************
	--%>
	<%-- ■ erpRightSubLayout 관련 Function 시작 --%>
	<%-- erpRightSubLayout 초기화 Function --%>
	function initErpRightSubLayout(){
		erpRightSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_right_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "그리드영역", header:false, fix_size : [true, true]}
			]
		});
		erpRightSubLayout.cells("a").attachObject("div_erp_right_ribbon");
		erpRightSubLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightSubLayout.cells("b").attachObject("div_erp_right_grid");
	}
	<%-- ■ erpRightSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRightRibbon 관련 Function 시작 --%>
	<%-- erpRightRibbon 초기화 Function --%>
	function initErpRightRibbon(){
		erpRightRibbon = new dhtmlXRibbon({
			parent : "div_erp_right_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpRightGrid", type : "button", text:'상품추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add.gif", disable : false}
					,{id : "add_erpRightGrid", type : "button", text:'행추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					,{id : "delete_erpRightGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					,{id : "save_erpRightGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					,{id : "excel_erpRightGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					, {id : "print_erpRightGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}	
				]}
			]
		});
		
		erpRightRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpRightGrid"){
				var selectCellId = erpLeftGrid.findCell("1",erpLeftGrid.getColIndexById("SELECT"),false,true);
				if($erp.isEmpty(selectCellId)){
					$erp.alertMessage({
						"alertMessage" : "선택된 기준단가변경그룹이 없습니다."
						, "alertCode" : null
						, "alertType" : "error"
						,"isAjax" : false
					});
				}else {
					openSearchGoodsGridPopup();
				}
		    } else if (itemId == "add_erpRightGrid"){
		    	var selectCellId = erpLeftGrid.findCell("1",erpLeftGrid.getColIndexById("SELECT"),false,true);
				if($erp.isEmpty(selectCellId)){
					$erp.alertMessage({
						"alertMessage" : "선택된 기준단가변경그룹이 없습니다."
						, "alertCode" : null
						, "alertType" : "error"
						,"isAjax" : false
					});
				}else {
		    		addErpRightGrid();
				}
		    } else if (itemId == "delete_erpRightGrid"){
		    	var selectCellId = erpLeftGrid.findCell("1",erpLeftGrid.getColIndexById("SELECT"),false,true);
				if($erp.isEmpty(selectCellId)){
					$erp.alertMessage({
						"alertMessage" : "선택된 기준단가변경그룹이 없습니다."
						, "alertCode" : null
						, "alertType" : "error"
						,"isAjax" : false
					});
				}else {
		    		deleteErpRightGrid();
				}
		    } else if (itemId == "save_erpRightGrid"){
		    	var selectCellId = erpLeftGrid.findCell("1",erpLeftGrid.getColIndexById("SELECT"),false,true);
				if($erp.isEmpty(selectCellId)){
					$erp.alertMessage({
						"alertMessage" : "선택된 기준단가변경그룹이 없습니다."
						, "alertCode" : null
						, "alertType" : "error"
						,"isAjax" : false
					});
				}else {
		    		saveErpRightGrid();
				}
		    } else if (itemId == "excel_erpRightGrid"){
		    	var selectCellId = erpLeftGrid.findCell("1",erpLeftGrid.getColIndexById("SELECT"),false,true);
				if($erp.isEmpty(selectCellId)){
					$erp.alertMessage({
						"alertMessage" : "선택된 기준단가변경그룹이 없습니다."
						, "alertCode" : null
						, "alertType" : "error"
						,"isAjax" : false
					});
				}else {
			    	$erp.exportGridToExcel({
			    		"grid" : erpRightGrid
						, "fileName" : "변경예정상품목록"
						, "isOnlyEssentialColumn" : false
						, "excludeColumnIdList" : []
						, "isIncludeHidden" : false
						, "isExcludeGridData" : false
					});
				}
		    } else if (itemId == "print_erpRightGrid"){
		    	var selectCellId = erpLeftGrid.findCell("1",erpLeftGrid.getColIndexById("SELECT"),false,true);
				if($erp.isEmpty(selectCellId)){
					$erp.alertMessage({
						"alertMessage" : "선택된 기준단가변경그룹이 없습니다."
						, "alertCode" : null
						, "alertType" : "error"
						,"isAjax" : false
					});
				}else {
		    		printDetailGrid();
				}
		    }
		});
	}
	<%-- ■ erpRightRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpRightGrid 관련 Function 시작 --%>	
	<%-- erpRightGrid 초기화 Function --%>	
	function initErpRightGrid(){
		erpRightGridColumns = [
			{id : "No", label : ["No", "#rspan"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "CHECK", label : ["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "ORGN_DIV_CD", label : ["ORGN_DIV_CD", "#rspan"], type : "ron", width : "30", sort : "int", align : "center", isHidden : true, isEssential : false}
			,{id : "ORGN_CD", label : ["ORGN_CD", "#rspan"], type : "ron", width : "30", sort : "int", align : "center", isHidden : true, isEssential : false}
			,{id : "CHG_SEQ", label : ["CHG_SEQ", "#rspan"], type : "ron", width : "30", sort : "int", align : "center", isHidden : true, isEssential : false}
			,{id : "DETL_SEQ", label : ["DETL_SEQ", "#rspan"], type : "ron", width : "30", sort : "int", align : "center", isHidden : true, isEssential : false}
			,{id : "HID_BCD_CD", label:["(자)바코드(히든)", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : false}
			,{id : "BCD_CD", label:["(자)바코드", "#rspan"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true, isSelectAll: true}
			,{id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			,{id : "BCD_NM", label:["상품명(바코드)", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "DIMEN_NM", label:["상품규격", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : true}
			,{id : "TAX_TYPE", label:["과세여부", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : true, isDisabled : true, commonCode : "GOODS_TAX_YN"}
			,{id : "CUSTMR_CD", label:["거래처코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "HID_CUSTMR_NM", label:["거래처명(히든)", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false, isDataColumn : false}
			,{id : "CUSTMR_NM", label:["거래처명", "#rspan"], type: "ed", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true, isDataColumn : true, isSelectAll: true}
			,{id : "B_PUR_PRICE", label:["기존", "매입가"], type: "edn", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false, isDataColumn : false, numberFormat : "0,000"}
			,{id : "B_SALE_PRICE", label:["#cspan", "판매가"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false, isDataColumn : false, numberFormat : "0,000"}
			,{id : "A_PUR_PRICE", label:["변경", "매입가"], type: "edn", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, isDataColumn : true, numberFormat : "0,000", isSelectAll: true}
			,{id : "A_SALE_PRICE", label:["#cspan", "판매가"], type: "edn", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, isDataColumn : true, numberFormat : "0,000", isSelectAll: true}
			,{id : "C_PUR_PRICE", label:["인상액", "매입가"], type: "edn[=c17-c15]", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false, isDataColumn : true, numberFormat : "0,000"}
			,{id : "C_SALE_PRICE", label:["#cspan", "판매가"], type: "edn[=c18-c16]", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false, isDataColumn : true, numberFormat : "0,000"}
			,{id : "C_PUR_PRICE", label:["인상율", "매입가"], type: "edn[=(c17-c15)/c15]", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false, isDataColumn : true, numberFormat : "00.00%"}
			,{id : "C_SALE_PRICE", label:["#cspan", "판매가"], type: "edn[=(c18-c16)/c16]", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false, isDataColumn : true, numberFormat : "00.00%"}
		];
		
		erpRightGrid = new dhtmlXGridObject({
			parent: "div_erp_right_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpRightGridColumns
		});
		
		erpRightGrid.attachEvent("onKeyPress",onKeyPressed);
		erpRightGrid.enableDistributedParsing(true, 100, 50);
		erpRightGrid.enableAccessKeyMap(true); 
		$erp.initGridCustomCell(erpRightGrid);
		$erp.initGridComboCell(erpRightGrid);
		$erp.attachDhtmlXGridFooterPaging(erpRightGrid, 100);
		$erp.attachDhtmlXGridFooterRowCount(erpRightGrid, '<spring:message code="grid.allRowCount" />');
		
		erpRightGrid.attachEvent("onRowPaste", function(rId){   //엑셀붙여넣기시 자동으로 행추가
			var tmpRowIndex = erpRightGrid.getRowIndex(rId);
			if(erpRightGrid.getRowId((tmpRowIndex+1)) == null || erpRightGrid.getRowId((tmpRowIndex+1)) == "null" || erpRightGrid.getRowId((tmpRowIndex+1)) == undefined || erpRightGrid.getRowId((tmpRowIndex+1)) == "undefined" ){
				addErpRightGrid();
			}
			
			//처음 입력한 바코드와 다를 경우 정보 가져오기(최초 붙여넣기 시, 붙여넣은 내용 변경 붙여넣기 시)
			if(
				(erpRightGrid.cells(rId,erpRightGrid.getColIndexById("BCD_CD")).getValue() != erpRightGrid.cells(rId,erpRightGrid.getColIndexById("HID_BCD_CD")).getValue())
			){
				getGoodsInformation(rId);
			}
			
			//처음 입력한 거래처명과 다를 경우 정보 가져오기(최초 붙여넣기 시, 붙여넣은 내용 변경 붙여넣기 시)
			if(
				(erpRightGrid.cells(rId,erpRightGrid.getColIndexById("CUSTMR_NM")).getValue() != erpRightGrid.cells(rId,erpRightGrid.getColIndexById("HID_CUSTMR_NM")).getValue())
			){
				getCorpInformation(rId);
			}
		});
		
		erpRightGrid.attachEvent("onEnter", function(rId, Ind){
			console.log("onEnter");
				if(
					(erpRightGrid.cells(erpRightGrid.getSelectedRowId(),erpRightGrid.getColIndexById("BCD_CD")).getValue() != erpRightGrid.cells(erpRightGrid.getSelectedRowId(),erpRightGrid.getColIndexById("HID_BCD_CD")).getValue())
				){
					getGoodsInformation(erpRightGrid.getSelectedRowId());
				}
				
				//처음 입력한 거래처명과 다를 경우 정보 가져오기(최초 붙여넣기 시, 붙여넣은 내용 변경 붙여넣기 시)
				if(
					(erpRightGrid.cells(erpRightGrid.getSelectedRowId(),erpRightGrid.getColIndexById("CUSTMR_NM")).getValue() != erpRightGrid.cells(erpRightGrid.getSelectedRowId(),erpRightGrid.getColIndexById("HID_CUSTMR_NM")).getValue())
				){
					getCorpInformation(erpRightGrid.getSelectedRowId());
				}
		});
		
		erpRightGridDataProcessor = new dataProcessor();
		erpRightGridDataProcessor.init(erpRightGrid);
		erpRightGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpRightGrid);
	}
	
	<%-- onKeyPressed erpLeftGrid Function --%>
	function onDetailKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpLeftGrid.setCSVDelimiter("\t");
			erpLeftGrid.copyBlockToClipboard()
		}
		if(code==86&&ctrl){
			erpLeftGrid.setCSVDelimiter("\t");
			erpLeftGrid.pasteBlockFromClipboard()
		}
		return true;
	}
	
	<%-- onKeyPressed erpRightGrid Function --%>
	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpRightGrid.setCSVDelimiter("\t");
			erpRightGrid.copyBlockToClipboard();
		}
		if(code==86&&ctrl){
			erpRightGrid.setCSVDelimiter("\t");
			erpRightGrid.pasteBlockFromClipboard();
		}
		
		if(code==13){
			if(
				(erpRightGrid.cells(erpRightGrid.getSelectedRowId(),erpRightGrid.getColIndexById("BCD_CD")).getValue() != erpRightGrid.cells(erpRightGrid.getSelectedRowId(),erpRightGrid.getColIndexById("HID_BCD_CD")).getValue())
			){
				getGoodsInformation(erpRightGrid.getSelectedRowId());
			}
			
			//처음 입력한 거래처명과 다를 경우 정보 가져오기(최초 붙여넣기 시, 붙여넣은 내용 변경 붙여넣기 시)
			if(
				(erpRightGrid.cells(erpRightGrid.getSelectedRowId(),erpRightGrid.getColIndexById("CUSTMR_NM")).getValue() != erpRightGrid.cells(erpRightGrid.getSelectedRowId(),erpRightGrid.getColIndexById("HID_CUSTMR_NM")).getValue())
			){
				getCorpInformation(erpRightGrid.getSelectedRowId());
			}
		}
		
		return true;
	}
	
	<%-- getGoodsInformation 상품정보 가져오기 Function --%>
	function getGoodsInformation(rId) {
		var bcd_cd = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("BCD_CD")).getValue();
		var orgn_cd = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("ORGN_CD")).getValue();
		erpRightGrid.cells(rId, erpRightGrid.getColIndexById("HID_BCD_CD")).setValue(bcd_cd);
		
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/standardInfo/goods/getGoodsInformationFromBarcode.do"
			,data : {
				"BCD_CD" : bcd_cd
				, "ORGN_CD" : orgn_cd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					if(data.GOODS_NO == "조회정보없음"){
						erpRightGrid.cells(rId,erpRightGrid.getColIndexById("GOODS_NO")).setTextColor("red");
						erpRightGrid.cells(rId,erpRightGrid.getColIndexById("BCD_NM")).setTextColor("red");
					}else{
						erpRightGrid.cells(rId,erpRightGrid.getColIndexById("GOODS_NO")).setTextColor("black");
						erpRightGrid.cells(rId,erpRightGrid.getColIndexById("BCD_NM")).setTextColor("black");
					}
					erpRightGrid.cells(rId, erpRightGrid.getColIndexById("BCD_NM")).setValue(data.BCD_NM);
					erpRightGrid.cells(rId, erpRightGrid.getColIndexById("CUSTMR_CD")).setValue(data.CUSTMR_CD);
					erpRightGrid.cells(rId, erpRightGrid.getColIndexById("CUSTMR_NM")).setValue(data.CUSTMR_NM);
					erpRightGrid.cells(rId, erpRightGrid.getColIndexById("TAX_TYPE")).setValue(data.TAX_TYPE);
					erpRightGrid.cells(rId, erpRightGrid.getColIndexById("DIMEN_NM")).setValue(data.DIMEN_NM);
					erpRightGrid.cells(rId, erpRightGrid.getColIndexById("GOODS_NO")).setValue(data.GOODS_NO);
					
					getPriceInformation(rId);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- getCorpInformation 거래처정보 가져오기 Function --%>
	function getCorpInformation(rId) {
		var custmr_nm = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("CUSTMR_NM")).getValue();
		erpRightGrid.cells(rId, erpRightGrid.getColIndexById("HID_CUSTMR_NM")).setValue(custmr_nm);
		
		$.ajax({
			url : "/sis/standardInfo/corp/getCorpInformationFromKeyword.do"
			,data : {
				"KEY_WORD" : "CUSTMR_NM"
				,"CUSTMR_NM" : custmr_nm
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					if(data.CUSTMR_CD == "조회정보없음"){
						erpRightGrid.cells(rId,erpRightGrid.getColIndexById("CUSTMR_CD")).setTextColor("red");
					}else{
						erpRightGrid.cells(rId,erpRightGrid.getColIndexById("CUSTMR_CD")).setTextColor("black");
					}
					erpRightGrid.cells(rId, erpRightGrid.getColIndexById("CUSTMR_CD")).setValue(data.CUSTMR_CD);
					
					getPriceInformation(rId);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- getPriceInformation 가격정보 가져오기 Function --%>
	function getPriceInformation(rId) {
		var selectCellId = erpLeftGrid.findCell("1",erpLeftGrid.getColIndexById("SELECT"),false,true);
		var selectRowId = null;
		if(selectCellId.length > 0){
			selectRowId = selectCellId[0][0];
		}
		var orgn_div_cd = erpLeftGrid.cells(selectRowId,erpLeftGrid.getColIndexById("ORGN_DIV_CD")).getValue();
		var orgn_cd = erpLeftGrid.cells(selectRowId,erpLeftGrid.getColIndexById("ORGN_CD")).getValue();
		
		var bcd_cd = erpRightGrid.cells(rId,erpRightGrid.getColIndexById("BCD_CD")).getValue();
		var custmr_cd = erpRightGrid.cells(rId,erpRightGrid.getColIndexById("CUSTMR_CD")).getValue();
		
		if(
			(bcd_cd != "" && bcd_cd != "조회정보없음")
			&& (custmr_cd != "" && custmr_cd != "조회정보없음")
		){
			$.ajax({
				url : "/sis/price/getPriceInformation.do"
				,data : {
					"BCD_CD" : bcd_cd
					,"CUSTMR_CD" : custmr_cd
					,"ORGN_DIV_CD" : orgn_div_cd
					,"ORGN_CD" : orgn_cd
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						erpRightGrid.cells(rId, erpRightGrid.getColIndexById("B_PUR_PRICE")).setValue(data.PUR_PRICE);
						erpRightGrid.cells(rId, erpRightGrid.getColIndexById("B_SALE_PRICE")).setValue(data.SALE_PRICE);
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	<%-- erpRightGrid 조회 유효성 검사 Function --%>
	function isSearchErpRightGridValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var selectCellId = erpLeftGrid.findCell("1",erpLeftGrid.getColIndexById("SELECT"),false,true);
		var selectRowId = null;
		if(selectCellId.length > 0){
			selectRowId = selectCellId[0][0];
		}
		
		var selectSeq = erpLeftGrid.cells(selectRowId,erpLeftGrid.getColIndexById("CHG_SEQ")).getValue();
		
		if($erp.isEmpty(selectSeq) || selectSeq == ""){
			isValidated = false;
			alertMessage = "error.common.noSelectedData";
			alertCode = "-1";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
				, "alertCallbackFn" : function () {
					erpLeftGrid.cells(selectRowId,erpLeftGrid.getColIndexById("SELECT")).setValue(0);
					$erp.clearDhtmlXGrid(erpRightGrid);
				}
			});
		}
		
		return isValidated;
	}
	
	<%-- erpRightGrid 조회 Function --%>
	function searchErpRightGrid(){
		if(!isSearchErpRightGridValidate()){
			return;
		}
		
		erpRightSubLayout.progressOn();
		var selectedRowId = erpLeftGrid.getCheckedRows(erpLeftGrid.getColIndexById("SELECT"));
		var selectSeq = erpLeftGrid.cells(selectedRowId,erpLeftGrid.getColIndexById("CHG_SEQ")).getValue();
		var selectOrgnCd = erpLeftGrid.cells(selectedRowId,erpLeftGrid.getColIndexById("ORGN_CD")).getValue();
		
		$.ajax({
			url : "/sis/price/getPriceReservationDetailList.do"
			,data : {
				"CHG_SEQ" : selectSeq
				, "ORGN_CD" : selectOrgnCd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightSubLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpRightGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpRightGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpRightGrid.parse(gridDataList, 'js');
						var allRowIds = erpRightGrid.getAllRowIds();
						var allRowArray = allRowIds.split(",");
						for(var i=0; i<allRowArray.length; i++){
							//추가바인딩
							erpRightGrid.cells(allRowArray[i],erpRightGrid.getColIndexById("HID_BCD_CD")).setValue(erpRightGrid.cells(allRowArray[i],erpRightGrid.getColIndexById("BCD_CD")).getValue());
							erpRightGrid.cells(allRowArray[i],erpRightGrid.getColIndexById("HID_CUSTMR_NM")).setValue(erpRightGrid.cells(allRowArray[i],erpRightGrid.getColIndexById("CUSTMR_NM")).getValue());
							/* if(erpRightGrid.cells(allRowArray[i],erpRightGrid.getColIndexById("GOODS_STATE")).getValue() == "N"){
								erpRightGrid.setRowTextStyle(allRowArray[i],"opacity:0.3;");
							} */
						}
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpRightGrid 추가 Function --%>
	function addErpRightGrid(){
		var uid = erpRightGrid.uid();
		erpRightGrid.addRow(uid);
		erpRightGrid.selectRow(erpRightGrid.getRowIndex(uid));
		erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORGN_CD")).setValue(erpLeftGrid.cells(erpLeftGrid.getCheckedRows(erpLeftGrid.getColIndexById("SELECT")), erpLeftGrid.getColIndexById("ORGN_CD")).getValue());
		$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
	}
	
	<%-- erpRightGrid 삭제 Function --%>
	function deleteErpRightGrid(){
		var selectRowIds = erpRightGrid.getCheckedRows(erpRightGrid.getColIndexById("CHECK"));
		var selectRowIdsArray = selectRowIds.split(",");
		var deleteRowIdsArray = [];
		var seqChkNum = 0;
		
		if(selectRowIdsArray[0] != ""){
			for(var i = 0 ; i < selectRowIdsArray.length ; i++){
				if(erpRightGrid.cells(selectRowIdsArray[i],erpRightGrid.getColIndexById("CHG_SEQ")).getValue() == ""){
					seqChkNum += 1;
					erpRightGrid.deleteRow(selectRowIdsArray[i]);
				}else {
					deleteRowIdsArray.push(selectRowIdsArray[i]);
				}
			}
			if(deleteRowIdsArray.length == 0 && seqChkNum != 0){
				return false;
			}
			
			if(deleteRowIdsArray.length == 0 && seqChkNum == 0){
				$erp.alertMessage({
					"alertMessage" : "error.common.noSelectedRow"
					, "alertCode" : null
					, "alertType" : "error"
				});
				return false;
			} else {
				var alertMessage = '<spring:message code="alert.common.deleteData" />';
				var alertType = "alert";
				var callbackFunction = function(){
					for(var j = 0 ; j < deleteRowIdsArray.length ; j++){
						erpRightGrid.deleteRow(deleteRowIdsArray[j]);
					}
				}
				
				$erp.confirmMessage({
					"alertMessage" : alertMessage
					, "alertType" : alertType
					, "alertCallbackFn" : callbackFunction
				});
			}
		} else {
			$erp.alertMessage({
				"alertMessage" : "상품이 1개이상 선택되어야 삭제가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}
	}
	
	<%-- erpRightGrid 저장 Function --%>
	function saveErpRightGrid(){
		var allIds = erpRightGrid.getAllRowIds(",");
		var allIdArray = allIds.split(",");
		if(allIds != ""){
			var lastRowId = allIdArray[allIdArray.length-1];
			var lastRowCheck = erpRightGrid.cells(lastRowId, erpRightGrid.getColIndexById("BCD_CD")).getValue();
			if(lastRowCheck == null || lastRowCheck == "null" || lastRowCheck == undefined || lastRowCheck == "undefined" || lastRowCheck == "") {
				erpRightGrid.deleteRow(lastRowId);//grid row에서 삭제
				allIdArray.splice(allIdArray.length-1);//array 에서 삭제
			}
		}
		
		if(erpRightGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpRightGrid);
		
		var tmpDataRows = erpRightGridDataProcessor.updatedRows;
		var tmpValidTF = true;
		var tmpValidRow;
		for(var i=0; i<tmpDataRows.length; i++){
			if(erpRightGrid.cells(tmpDataRows[i],erpRightGrid.getColIndexById("GOODS_NO")).getValue() == "조회정보없음"){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1001";
				tmpValidRow = erpRightGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
		}
		for(var i=0; i<tmpDataRows.length; i++){
			if(erpRightGrid.cells(tmpDataRows[i],erpRightGrid.getColIndexById("CUSTMR_CD")).getValue() == "조회정보없음"){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1001";
				tmpValidRow = erpRightGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
		}
		
		if(!tmpValidTF){
			if(validResultMap.errCode == "-1001"){
				validResultMap.errMessage = "error.sis.reservation.no_info_not_save";
			}
			validResultMap.errRowIdx = [(tmpValidRow+1)];
			validResultMap.errMessageParam = [(tmpValidRow+1)];
		}
		
		if(validResultMap.isError){
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		erpRightSubLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpRightGrid);
		
		var selectCellId = erpLeftGrid.findCell("1",erpLeftGrid.getColIndexById("SELECT"),false,true);
		var selectRowId = null;
		if(selectCellId.length > 0){
			selectRowId = selectCellId[0][0];
		}
		var selectSeq = erpLeftGrid.cells(selectRowId,erpLeftGrid.getColIndexById("CHG_SEQ")).getValue();
		var orgnDivCd = erpLeftGrid.cells(selectRowId,erpLeftGrid.getColIndexById("ORGN_DIV_CD")).getValue();
		var orgnCd = erpLeftGrid.cells(selectRowId,erpLeftGrid.getColIndexById("ORGN_CD")).getValue();
		
		paramData["H_CHG_SEQ"] = selectSeq;
		paramData["H_ORGN_DIV_CD"] = orgnDivCd;
		paramData["H_ORGN_CD"] = orgnCd;
		
		$.ajax({
			url : "/sis/price/updatePriceReservationDetailList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightSubLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.alertSuccessMesage(onAfterSaveErpRightGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpRightSubLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function openSearchGoodsGridPopup(){
		var onClickAddData = function(erpGoodsGrid) {
			var check = erpGoodsGrid.getCheckedRows(erpGoodsGrid.getColIndexById("CHECK")); // 조회된 그리드내역 중 선택한 row 번호 문자열로 넘어옴 ex) 1,5,7,10
			if(check == ""){
				$erp.alertMessage({
					"alertMessage" : "선택된 상품이 없습니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false
				});
			}else{
				var checkList = check.split(',');
				var uid = "";
				for(var i = 0 ; i < checkList.length ; i ++) {
					uid = erpRightGrid.uid();
					erpRightGrid.addRow(uid);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("BCD_CD")).setValue(erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("BCD_CD")).getValue());				
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("GOODS_NO")).setValue(erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("GOODS_NO")).getValue());				
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("BCD_NM")).setValue(erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("BCD_NM")).getValue());			
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("DIMEN_NM")).setValue(erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("DIMEN_NM")).getValue());
					getGoodsInformation(uid);
				}
				$erp.closePopup2("openSearchGoodsGridPopup");
			}
		}
		var selected_orgn_cd = erpLeftGrid.cells(erpLeftGrid.getCheckedRows(erpLeftGrid.getColIndexById("SELECT")), erpLeftGrid.getColIndexById("ORGN_CD")).getValue();
		$erp.openSearchGoodsPopup(null,onClickAddData, {"ORGN_CD" : selected_orgn_cd , "DISABLE" : true} );
	}
	
	function printDetailGrid(){
		var checked_bcd_list = erpRightGrid.getCheckedRows(erpRightGrid.getColIndexById("CHECK")).split(',');
		if(checked_bcd_list[0] == ''){
			$erp.alertMessage({
				"alertMessage" : "출력할 상품을 1개이상 선택해주세요.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else {
			var bcd_cd_list = "";
			var goods_nm_list = "";
			var sale_price_list = "";
			for(var i = 0 ; i < checked_bcd_list.length ; i++){
				if(i == 0){
					bcd_cd_list += erpRightGrid.cells(checked_bcd_list[i], erpRightGrid.getColIndexById("BCD_CD")).getValue();
					goods_nm_list += erpRightGrid.cells(checked_bcd_list[i], erpRightGrid.getColIndexById("BCD_NM")).getValue();
					sale_price_list += erpRightGrid.cells(checked_bcd_list[i], erpRightGrid.getColIndexById("A_SALE_PRICE")).getValue();
				} else {
					bcd_cd_list += "," + erpRightGrid.cells(checked_bcd_list[i], erpRightGrid.getColIndexById("BCD_CD")).getValue();
					goods_nm_list += "," + erpRightGrid.cells(checked_bcd_list[i], erpRightGrid.getColIndexById("BCD_NM")).getValue();
					sale_price_list += "," + erpRightGrid.cells(checked_bcd_list[i], erpRightGrid.getColIndexById("A_SALE_PRICE")).getValue();
				}
			}
			var paramInfo = {
					 "bcd_cd_list" : bcd_cd_list
					, "goods_nm_list" : goods_nm_list
					, "sale_price_list" : sale_price_list
			};
			
			var approvalURL = $CROWNIX_REPORT.openPriceLablePrint("", paramInfo, "라벨출력", "");
			var popObj = window.open(approvalURL, "barcode_popup", "width=900,height=800");
			
			var frm = document.labelform;
			frm.action = approvalURL;
			frm.target = "barcode_popup";
			frm.submit();
		}
	}
	
	<%-- erpRightGrid 저장 후 Function --%>
	function onAfterSaveErpRightGrid(){
		searchErpRightGrid();
	}
	
	<%-- ■ erpRightGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		var searchable = 1;
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",")
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "ALL"){
				searchable = 2;
				break;
			}else if (search_cd_Arr[i] == "3"){
				searchable = 3;
			}else if (search_cd_Arr[i] == "5"){
				searchable = 5;
			}
		}
		
		if(searchable == 1){ //직영점,센터단일
			cmbORGN_CD = $erp.getDhtmlXMultiCheckComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 120, null, false, LUI.LUI_orgn_delegate_cd, "권한이 없습니다.");
		}else if(searchable == 3 || searchable == 5){ //센터전체, 직영점전체
			cmbORGN_CD = $erp.getDhtmlXMultiCheckComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 120, null, false, "");
		}else{
			cmbORGN_CD = $erp.getDhtmlXMultiCheckComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","","","","","MK"], 120, null, false, "");
		}
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>
	<form name="labelform" action="" method="post"></form>
	<div id="div_erp_left_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_left_contents_search" class="div_erp_contents_search" style="display:none">
		<table id = "table_1" class="table_search">
			<colgroup>
				<col width="60px">
				<col width="100px">
				<col width="60px">
				<col width="120px">
				<col width="75px">
				<col width="*">
			</colgroup>
			<tr>
				<th>날짜From</th>
				<td><input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar input_essential" maxlength="505"></td>
				<th>날짜To</th>
				<td><input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar input_essential" maxlength="505"></td>
				<th>조직명</th>
 				<td><div id="cmbORGN_CD"></div></td><!--data-isEssential="true" -->
			</tr>
		</table>
	</div>
	<div id="div_erp_left_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_left_grid" class="div_grid_full_size" style="display:none"></div>
	
	<div id="div_erp_right_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_right_ribbon" class="div_ribbon_full_size" style="display:none"></div>	
	<div id="div_erp_right_grid" class="div_grid_full_size" style="display:none"></div>	
</body>
</html>