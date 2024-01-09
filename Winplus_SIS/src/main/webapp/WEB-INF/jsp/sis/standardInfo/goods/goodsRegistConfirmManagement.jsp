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
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_orgn_type = "PS,CS";
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	
	var cmbORGN_CD;
	var cmbPROC_STATE;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
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
					,{id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.apply" />', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : true}
					,{id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.reject" />', isbig : false, img : "menu/close.gif", imgdis : "menu/close_dis.gif", disable : true}
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
				applyErpGrid();
			} else if (itemId == "delete_erpGrid"){
				rejectErpGrid();
		    } else if (itemId == "save_erpGrid"){
		    	saveErpGrid();
		    } else if (itemId == "excel_erpGrid"){
		    	$erp.exportGridToExcel({
		    		"grid" : erpGrid
					, "fileName" : "상품등록승인관리"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
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
			,{id : "CHECK", label : ["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			,{id : "REG_DATE", label:["등록일자", "#rspan"], type: "ro", width: "74", sort : "str", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			,{id : "CDATE", label:["등록일자", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : true}
			,{id : "PROC_STATE", label:["처리상태", "#rspan"], type: "combo", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false, commonCode : "PROC_STATE", isDisabled : true}
			,{id : "ORGN_CD", label : ["입점매장", "#rspan"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : ["ORGN_CD",null,null,null,null,"MK"]}
			,{id : "SEQ", label:["순번", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : true}
			,{id : "BCD_CD", label:["(자)바코드", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "BCD_M_CD", label:["(모)바코드", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "GOODS_NO", label:["상품코드(히든)", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : false}
			,{id : "BCD_NM", label:["상품명(바코드)", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "GOODS_NM", label:["상품명(대표)", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			
			//추가 시작
			,{id : "GOODS_STATE", label:["상품상태", "#rspan"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : ["USE_CD", "YN"]}
			//추가 끝
			
			,{id : "GRUP_CD", label:["분류코드(히든)", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : false}
			,{id : "GRUP_BOT_NM", label:["소분류", "#rspan"], type: "ed", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "DIMEN_NM", label:["상품규격", "#rspan"], type: "ed", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "CUSTMR_CD", label:["거래처코드(히든)", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : false}
			,{id : "CUSTMR_NM", label:["거래처명", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "PUR_PRICE", label:["매입가", "#rspan"], type: "edn", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, isDataColumn : true, numberFormat : "0,000"}
			,{id : "SALE_PRICE", label:["판매가", "#rspan"], type: "edn", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, isDataColumn : true, numberFormat : "0,000"}
			,{id : "RESN", label:["입점사유", "#rspan"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : true}
			
			//추가 시작
			,{id : "GOODS_EXP_TYPE", label:["유통기한유형", "#rspan"], type: "combo", width: "80", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true, commonCode : "VALID_APPLY_TYPE"}
			//추가 끝
			
			,{id : "GOODS_EXP_CD", label:["유통기한", "#rspan"], type: "ed", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "MAT_TEMPER_INFO", label:["품온정보", "#rspan"], type: "combo", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : "MAT_TEMPER_INFO"}
			,{id : "TAX_TYPE", label:["과세구분", "#rspan"], type: "combo", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : "GOODS_TAX_YN"}
			
			//추가 시작
			,{id : "GOODS_PUR_CD", label:["상품유형", "#rspan"], type: "combo", width: "60", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true, commonCode : ["PUR_TYPE", "", "", "INFO"]}
			,{id : "GOODS_SALE_TYPE", label:["판매유형", "#rspan"], type: "combo", width: "60", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true, commonCode : "GOODS_MNG_TYPE"}
			,{id : "ITEM_TYPE", label:["품목구분", "#rspan"], type: "combo", width: "60", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true, commonCode : ["ITEM_TYPE", "M"]}
			,{id : "POINT_SAVE_RATE", label:["포인트적립율", "#rspan"], type: "ed", width: "80", sort : "int", align : "right", isHidden : false, isEssential : true, isDataColumn : true, commonCode : "GOODS_TAX_YN"}
			,{id : "MIN_PUR_QTY", label:["CS최소주문수량", "#rspan"], type: "ed", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "MIN_PUR_UNIT", label:["CS최소주문단위", "#rspan"], type: "ed", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "MIN_ORD_UNIT", label:["최소구매단위", "#rspan"], type: "ed", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "MIN_ORD_QTY", label:["수주제한수량", "#rspan"], type: "ed", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "MIN_UNIT_QTY", label:["최소단위수량", "#rspan"], type: "ed", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "RESP_USER", label:["담당부서", "#rspan"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : "GOODS_RESP_ORGN"}
			,{id : "PUR_DSCD_TYPE", label:["반품가능여부(매입)", "#rspan"], type: "combo", width: "120", sort : "str", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : "DSCD_TYPE"}
			,{id : "SALE_DSCD_TYPE", label:["반품가능여부(매출)", "#rspan"], type: "combo", width: "120", sort : "str", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : "DSCD_TYPE"}
			,{id : "DELI_DD_YN", label:["일배상품여부", "#rspan"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : ["YN_CD", "YN"]}
			,{id : "GOODS_TC_TYPE", label:["TC상품유형", "#rspan"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : "TC_TYPE"}
			,{id : "DELI_AREA_YN", label:["착지변경상품여부", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true, isDataColumn : true, commonCode : ["YN_CD", "YN"]}
			//추가 끝
			,{id : "VALID_MSG", label:["자료확인결과", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}

		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		erpGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 1000);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
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
			url : "/sis/standardInfo/goods/getGoodsRegistConfirmList.do"
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
						
						var allRowIds = erpGrid.getAllRowIds();
						var allRowArray = allRowIds.split(",");
						var rowProcState = "";
						for(var i=0; i<allRowArray.length; i++){
							rowProcState = erpGrid.cells(allRowArray[i],erpGrid.getColIndexById("PROC_STATE")).getValue();
							if(rowProcState == "8"){
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("BCD_CD"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("BCD_M_CD"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("BCD_NM"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("GOODS_NM"),"ro");
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("GOODS_STATE")).setDisabled(true);
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("GRUP_BOT_NM"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("DIMEN_NM"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("CUSTMR_NM"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("PUR_PRICE"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("SALE_PRICE"),"ro");
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("ORGN_CD")).setDisabled(true);
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("RESN"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("GOODS_EXP_CD"),"ro");
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("GOODS_EXP_TYPE")).setDisabled(true);
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("MAT_TEMPER_INFO")).setDisabled(true);
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("TAX_TYPE")).setDisabled(true);
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("GOODS_PUR_CD")).setDisabled(true);
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("GOODS_SALE_TYPE")).setDisabled(true);
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("ITEM_TYPE")).setDisabled(true);
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("POINT_SAVE_RATE"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("MIN_PUR_QTY"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("MIN_PUR_UNIT"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("MIN_ORD_UNIT"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("MIN_ORD_QTY"),"ro");
								erpGrid.setCellExcellType(allRowArray[i],erpGrid.getColIndexById("MIN_UNIT_QTY"),"ro");
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("RESP_USER")).setDisabled(true);
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("PUR_DSCD_TYPE")).setDisabled(true);
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("SALE_DSCD_TYPE")).setDisabled(true);
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("DELI_DD_YN")).setDisabled(true);
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("GOODS_TC_TYPE")).setDisabled(true);
								erpGrid.cellById(allRowArray[i],erpGrid.getColIndexById("DELI_AREA_YN")).setDisabled(true);
							}
						}
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpGrid 승인 Function --%>
	function applyErpGrid(){
		var selectedIds = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
		var selectedId = selectedIds.split(",");//선택한것만 뽑아서
		
		if(selectedIds==""){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedData"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}else{
			var allIds = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
			
			var allId = allIds.split(",");
		
			var tempString = "";
		
			for(var i=0; i<allId.length; i++){
				tempString += "," + erpGrid.cells(allId[i], erpGrid.getColIndexById("REG_DATE")).getValue()+"_"+erpGrid.cells(allId[i], erpGrid.getColIndexById("SEQ")).getValue();
			}
		
			tempString = tempString.substring(1);
			
			var alertMessage = '<spring:message code="alert.common.applyData" />';
			var alertCode = "";
			var alertType = "alert";
			var callbackFunction = function(){
				applyData(tempString);
			}
			
			$erp.confirmMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
				, "alertCallbackFn" : callbackFunction
			});
		}
	}
	
	function applyData(checkedArray){
		erpLayout.progressOn();
		
		$.ajax({
			url : "/sis/standardInfo/goods/updateGoodsConfirmApply.do"
			,data : {
				"CRUD" : "C"				//권한체크를 위해 일부러 전달함
				,"uniqueids" : checkedArray
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var resultMsg = data.RESULT_MSG;
					if(resultMsg == "SAVE_SUCCESS"){
						$erp.alertSuccessMesage(onAfterSaveErpGrid);
					} else {
						if(resultMsg == "DATA_APPLY"){
							resultMsg = "데이터 유효성검사가 완료 된 상품만<br>승인처리 할 수 있습니다.";
						} else if(resultMsg == "COMPLETE_APPLY") {
							resultMsg = "이미반영된 상품입니다.";
						} else if(resultMsg == "DATA_ERROR") {
							resultMsg = "데이터등록중 발생한 오류 정상처리 된 상품만<br> 승인처리 할 수 있습니다.";
						}
						
						$erp.alertMessage({
							"alertMessage" : resultMsg,
							"alertCode" : null,
							"alertType" : "alert",
							"isAjax" : false
						});
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpGrid 반려 Function --%>
	function rejectErpGrid(){
		var selectedIds = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
		var selectedId = selectedIds.split(",");//선택한것만 뽑아서
		
		if(selectedIds==""){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedData"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}else{
			var allIds = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
			
			var allId = allIds.split(",");
		
			var tempString = "";
		
			for(var i=0; i<allId.length; i++){
				tempString += "," + erpGrid.cells(allId[i], erpGrid.getColIndexById("REG_DATE")).getValue()+"_"+erpGrid.cells(allId[i], erpGrid.getColIndexById("SEQ")).getValue();
			}
		
			tempString = tempString.substring(1);
			
			var alertMessage = '<spring:message code="alert.common.rejectData" />';
			var alertCode = "";
			var alertType = "alert";
			var callbackFunction = function(){
				rejectData(tempString);
			}
			
			$erp.confirmMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
				, "alertCallbackFn" : callbackFunction
			});
		}
	}
	
	function rejectData(checkedArray){
		erpLayout.progressOn();
		
		$.ajax({
			url : "/sis/standardInfo/goods/updateGoodsConfirmReject.do"
			,data : {
				"CRUD" : "D"				//권한체크를 위해 일부러 전달함
				,"uniqueids" : checkedArray
			}
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
	
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		var searchable = 1;
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",")
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
			searchable = 2;
			}
		}
		
		if(searchable == 1 ){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 110, null, false, LUI.LUI_orgn_cd);
		}else if(searchable == 2){
			cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","","","","","MK"], 110, "모두조회", false, LUI.LUI_orgn_cd, null, "Y");
		}
		
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
				<col width="75px">
				<col width="130px">
				<col width="60px">
				<col width="*">
			</colgroup>
			<tr>
				<th>날짜From</th>
				<td><input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar default_date input_essential" data-position="(1)" maxlength="505"></td>
				<th>날짜To</th>
				<td><input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar default_date input_essential" data-position="" maxlength="505"></td>
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