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
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object/ 그리드변경사항 객체 DhtmlXDataProcessor
		
		■ cmbORGN_CD : Object / 직영점선택구분 DhtmlXCombo (CODE : ORGN_CD / MK)
		■ cmbPROC_STATE : Object / 처리상태 구분 DhtmlXCombo (CODE : PROC_STATE)
	--%>
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	
	var cmbORGN_CD;
	var cmbPROC_STATE;
	
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
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		
		document.getElementById("searchDateFrom").value=firstDate;
		document.getElementById("searchDateTo").value=lastDate;
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "검색어영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "그리드영역", header:false, fix_size : [true, true]}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					,{id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					,{id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					,{id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					,{id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					//,{id : "excelForm_erpGrid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					//, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpGrid"){
				searchErpGrid();
			} else if (itemId == "add_erpGrid"){
				addErpGrid();
			} else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
		    } else if (itemId == "save_erpGrid"){
		    	saveErpGrid();
		    } else if (itemId == "excel_erpGrid"){
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "상품등록요청(직영점)"
		    		, "isForm" : false
		    	});
		    } else if (itemId == "excelForm_erpGrid"){
		    } else if (itemId == "print_erpGrid"){
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "REG_DATE", label:["등록일자", "#rspan"], type: "ro", width: "74", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : true}
			,{id : "SEQ", label:["순번", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : true}
			,{id : "BCD_CD", label:["(자)바코드", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "BCD_M_CD", label:["(모)바코드", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "GOODS_NO", label:["상품코드(히든)", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : false}
			,{id : "BCD_NM", label:["상품명(바코드)", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "GOODS_NM", label:["상품명(대표)", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "GRUP_CD", label:["분류코드(히든)", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : false}
			,{id : "GRUP_BOT_NM", label:["소분류", "#rspan"], type: "ed", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "DIMEN_NM", label:["상품규격", "#rspan"], type: "ed", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "GOODS_EXP_CD", label:["유통기한", "#rspan"], type: "ed", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "MAT_TEMPER_INFO", label:["품온정보", "#rspan"], type: "combo", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : "MAT_TEMPER_INFO"}
			,{id : "TAX_TYPE", label:["과세구분", "#rspan"], type: "combo", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : "GOODS_TAX_YN"}
			,{id : "CUSTMR_CD", label:["거래처코드(히든)", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : false}
			,{id : "CUSTMR_NM", label:["거래처명", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "PUR_PRICE", label:["매입가", "#rspan"], type: "edn", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, isDataColumn : true, numberFormat : "0,000"}
			,{id : "SALE_PRICE", label:["판매가", "#rspan"], type: "edn", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, isDataColumn : true, numberFormat : "0,000"}
			,{id : "ORGN_CD", label : ["입점매장", "#rspan"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : ["ORGN_CD",null,null,null,null,"MK"]}
			,{id : "RESN", label:["입점사유", "#rspan"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : true}
			,{id : "VALID_MSG", label:["자료확인결과", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
			,{id : "PROC_STATE", label:["처리상태", "#rspan"], type: "combo", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false, commonCode : "PROC_STATE", isDisabled : true}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		erpGrid.attachEvent("onKeyPress",onKeyPressed);
		erpGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 1000);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGrid.attachEvent("onRowPaste", function(rId){   //엑셀붙여넣기시 자동으로 행추가
			var tmpRowIndex = erpGrid.getRowIndex(rId);
			if(erpGrid.getRowId((tmpRowIndex+1)) == null || erpGrid.getRowId((tmpRowIndex+1)) == "null" || erpGrid.getRowId((tmpRowIndex+1)) == undefined || erpGrid.getRowId((tmpRowIndex+1)) == "undefined" ){
				addErpGrid();
			}
		});
		erpGrid.attachEvent("onCellChanged", function(rId,cInd,nValue){
			console.log(rId+"_"+cInd+"_"+nValue);
		});
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
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
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		if(!isSearchValidate()){
			return;
		}
		
		erpLayout.progressOn();
		
		var searchDateFrom = $("#searchDateFrom").val();
		var searchDateTo = $("#searchDateTo").val();
		var orgn_cd = cmbORGN_CD.getSelectedValue();
		var proc_state = cmbPROC_STATE.getSelectedValue();
		
		$.ajax({
			url : "/sis/standardInfo/goods/getGoodsRegistInformationList.do"
			,data : {
				"searchDateFrom" : searchDateFrom
				,"searchDateTo" : searchDateTo
				,"orgn_cd" : orgn_cd
				,"proc_state" : proc_state
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpGrid.parse(gridDataList, 'js');
						/* 
						var allRowIds = erpGrid.getAllRowIds();
						var allRowArray = allRowIds.split(",");
						for(var i=0; i<allRowArray.length; i++){
							if(erpGrid.cells(allRowArray[i],erpGrid.getColIndexById("GOODS_STATE")).getValue() == "N"){
								erpGrid.setRowTextStyle(allRowArray[i],"opacity:0.3;");
							}
						} */
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpGrid 추가 Function --%>
	function addErpGrid(){
		var uid = erpGrid.uid();
		erpGrid.addRow(uid);
		erpGrid.selectRow(erpGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	<%-- erpGrid 삭제 Function --%>
	function deleteErpGrid(){
		var rId = erpGrid.getSelectedRowId();
		if(rId != null){
			if(erpGrid.cells(rId,erpGrid.getColIndexById("REG_DATE")).getValue() == ""){
				erpGrid.deleteRow(rId);
			}else{
				var alertMessage = '<spring:message code="alert.common.deleteData" />';
				var alertCode = "";
				var alertType = "alert";
				var callbackFunction = function(){
					erpGrid.deleteRow(rId);
					saveErpGrid();
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
	
	<%-- erpGrid 저장 Function --%>
	function saveErpGrid() {
		var allIds = erpGrid.getAllRowIds(",");
		var allIdArray = allIds.split(",");
		if(allIds != ""){
			var lastRowId = allIdArray[allIdArray.length-1];
			var lastRowCheck = erpGrid.cells(lastRowId, erpGrid.getColIndexById("BCD_CD")).getValue();
			if(lastRowCheck == null || lastRowCheck == "null" || lastRowCheck == undefined || lastRowCheck == "undefined" || lastRowCheck == "") {
				erpGrid.deleteRow(lastRowId);//grid row에서 삭제
				allIdArray.splice(allIdArray.length-1);//array 에서 삭제
			}
		}
		
		if(erpGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpGrid);
		
		var tmpDataRows = erpGridDataProcessor.updatedRows;
		var tmpValidTF = true;
		var tmpValidRow;
		for(var i=0; i<tmpDataRows.length; i++){
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("BCD_NM")).getValue().length > 50
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1010";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("GOODS_NM")).getValue().length > 50
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1020";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("GRUP_BOT_NM")).getValue().length == 0
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1030";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("GRUP_BOT_NM")).getValue().length > 30
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1031";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("DIMEN_NM")).getValue().length == 0
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1040";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("DIMEN_NM")).getValue().length > 200
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1041";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("GOODS_EXP_CD")).getValue().length == 0
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1050";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("GOODS_EXP_CD")).getValue().length > 5
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1051";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("MAT_TEMPER_INFO")).getValue().length == 0
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1060";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("MAT_TEMPER_INFO")).getValue().length > 5
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1061";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("TAX_TYPE")).getValue().length == 0
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1070";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("TAX_TYPE")).getValue().length > 1
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1071";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("CUSTMR_NM")).getValue().length > 50
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1080";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
				erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("RESN")).getValue().length > 50
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1090";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
		}
		
		if(!tmpValidTF){
			if(validResultMap.errCode == "-1010"){
				validResultMap.errMessage = "error.sis.goods.b_code_nm.length50Over";
			}else if(validResultMap.errCode == "-1020"){
				validResultMap.errMessage = "error.sis.goods.goods_nm.length50Over";
			}else if(validResultMap.errCode == "-1030"){
				validResultMap.errMessage = "error.sis.category.grup_bot_cd.empty";
			}else if(validResultMap.errCode == "-1031"){
				validResultMap.errMessage = "error.sis.goods.grup_bot_nm.length30Over";
			}else if(validResultMap.errCode == "-1040"){
				validResultMap.errMessage = "error.sis.goods.dimen_nm.empty";
			}else if(validResultMap.errCode == "-1041"){
				validResultMap.errMessage = "error.sis.goods.dimen_nm.length200Over";
			}else if(validResultMap.errCode == "-1050"){
				validResultMap.errMessage = "error.sis.goods.goods_exp_cd.empty";
			}else if(validResultMap.errCode == "-1051"){
				validResultMap.errMessage = "error.sis.goods.goods_exp_cd.length5Over";
			}else if(validResultMap.errCode == "-1060"){
				validResultMap.errMessage = "error.sis.goods.mat_temper_info.empty";
			}else if(validResultMap.errCode == "-1061"){
				validResultMap.errMessage = "error.sis.goods.mat_temper_info.length5Over";
			}else if(validResultMap.errCode == "-1070"){
				validResultMap.errMessage = "error.sis.goods.tax_type.empty";
			}else if(validResultMap.errCode == "-1071"){
				validResultMap.errMessage = "error.sis.goods.tax_type.length1Over";
			}else if(validResultMap.errCode == "-1080"){
				validResultMap.errMessage = "error.sis.goods.custmr_nm.length50Over";
			}else if(validResultMap.errCode == "-1090"){
				validResultMap.errMessage = "error.sis.goods.resn.length50Over";
			}
			validResultMap.errRowIdx = [(tmpValidRow+1)];
			validResultMap.errMessageParam = [(tmpValidRow+1)];
		}
		
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		var deleteRowIdArray = [];
		var t_goods_nm = "";
		for(var i=0; i<allIdArray.length; i++) {
			t_goods_nm = erpGrid.cells(allIdArray[i], erpGrid.getColIndexById("GOODS_NM")).getValue();
			if(t_goods_nm == "조회정보없음"){
				deleteRowIdArray.push(allIdArray[i]);
			}
		}
		
		for(var j=0; j<deleteRowIdArray.length; j++){
			erpGrid.deleteRow(deleteRowIdArray[j]);
		}
		
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);
		
		$.ajax({
			url : "/sis/standardInfo/goods/updateGoodsRegistInformation.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertSuccessMesage(onAfterSaveErpGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpGrid 저장 후 Function --%>
	function onAfterSaveErpGrid(){
		searchErpGrid();
	}
	
	<%-- onKeyPressed erpGrid Function --%>
	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpGrid.setCSVDelimiter("\t");
			erpGrid.copyBlockToClipboard();
		}
		if(code==86&&ctrl){
			erpGrid.setCSVDelimiter("\t");
			erpGrid.pasteBlockFromClipboard();
		}
		return true;
	}
	
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbORGN_CD = $erp.getDhtmlXCombo("cmbORGN_CD", "ORGN_CD", {commonCode : "ORGN_CD",div5 : "MK"}, 120, "모두조회");
		cmbPROC_STATE = $erp.getDhtmlXCombo("cmbPROC_STATE", "PROC_STATE", {commonCode : "PROC_STATE"}, 120, "전체");
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="60px">
				<col width="100px">
				<col width="60px">
				<col width="120px">
				<col width="60px">
				<col width="120px">
				<col width="60px">
				<col width="*">
			</colgroup>
			<tr>
				<th>날짜From</th>
				<td><input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar input_essential" maxlength="505"></td>
				<th>날짜To</th>
				<td><input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar input_essential" maxlength="505"></td>
				<th>조직명</th>
				<td><div id="cmbORGN_CD"></div></td>
				<th>처리상태</th>
				<td><div id="cmbPROC_STATE"></div></td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>