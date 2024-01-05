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

	var erpLayout;
	var erpLeftLayout;
	var erpLeftTopRibbon;
	var erpLeftTopGrid;
	var erpLeftTopGridColumns;
	var erpLeftBotGrid;
	var erpLeftBotGridColumns;
	var erpRightLayout;
	var erpRightTopRibbon;
	var erpRightTopGrid;
	var erpRightTopGridColumns;
	var erpRightBotRibbon;
	var erpRightBotGrid;
	var erpRightBotGridColumns;
	var erpRightBotGridDataProcessor;
	
	var cmbOUT_ORGN_CD;
	var cmbIN_ORGN_CD;
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		
		initErpLayout();
		
		initErpLeftLayout();
		initErpLeftTopRibbon();
		initErpLeftTopGrid();
		initErpLeftBotGrid();
		
		initErpRightLayout();
		initErpRightTopRibbon();
		initErpRightTopGrid();
		initErpRightBotRibbon();
		initErpRightBotGrid();
		
		initDhtmlXCombo();
		document.getElementById("searchPdaDate").value = today;
		document.getElementById("searchTransDate").value = today;
		
		$erp.asyncObjAllOnCreated(function(){
			var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",");
			var searchable = 1;
			console.log(search_cd_Arr);
			for(var i in search_cd_Arr){
				if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
					searchable = 2;
				}
			}
			
			 if(searchable != 2 ){
				 cmbOUT_ORGN_CD.disable();
			 }
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2U"
			, cells : [
				{id: "a", text: "PDA그리드영역", header: false , fix_size:[true, true]}
				, {id : "b", text: "재고이동그리드영역", header: false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_left_layout");
		erpLayout.cells("a").setWidth(741);
		erpLayout.cells("b").attachObject("div_erp_right_layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpLeftLayout.setSizes();
			erpRightLayout.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpLeftLayout 관련 Function 시작 --%>
	function initErpLeftLayout(){
		erpLeftLayout = new dhtmlXLayoutObject({
			parent: "div_erp_left_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false , fix_size:[true, true]}
				, {id: "b", text: "상단리본영역", header:false , fix_size:[true, true]}
				, {id: "c", text: "상단그리드영역", header:false , fix_size:[true, true]}
				, {id: "d", text: "하단그리드영역", header:false , fix_size:[true, true]}
			]		
		});
		erpLeftLayout.cells("a").attachObject("div_erp_left_table");
		erpLeftLayout.cells("a").setHeight($erp.getTableHeight(1));
		erpLeftLayout.cells("b").attachObject("div_erp_left_top_ribbon");
		erpLeftLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftLayout.cells("c").attachObject("div_erp_left_top_grid");
		erpLeftLayout.cells("c").setHeight(300);
		erpLeftLayout.cells("d").attachObject("div_erp_left_bot_grid");
	}	
	<%-- ■ erpLeftLayout 관련 Function 끝 --%>
	
	<%-- ■ erpLeftTopRibbon 관련 Function 시작 --%>
	function initErpLeftTopRibbon() {
		erpLeftTopRibbon = new dhtmlXRibbon({
			parent : "div_erp_left_top_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpLeftTopGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "delete_erpLeftTopGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
				]}
			]
		});	
		
		erpLeftTopRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpLeftTopGrid") {
				searchErpLeftTopGrid();
				searchErpRightTopGrid();
			} else if (itemId == "delete_erpLeftTopGrid"){
				deleteErpLeftTopGrid();
			}
		});
	}
	<%-- ■ erpLeftTopRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpLeftTopGrid 관련 Function 시작 --%>
	function initErpLeftTopGrid(){
		erpLeftTopGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			,{id : "ORGN_CD", label : ["직영점", "#rspan"], type : "combo", width : "75", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			,{id : "ORGN_DIV_CD", label : ["조직구분코드", "#rspan"], type : "ro", width : "75", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "STORE_AREA", label:["재고구역", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "RESP_USER", label:["담당자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			,{id : "TOT_GOODS_NM", label:["품목명", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "TOT_CNT", label:["수량", "#rspan"], type: "ron", width: "85", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "CDATE", label:["CDATE", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "UNI_KEY", label:["UNI_KEY", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
		];
		
		erpLeftTopGrid = new dhtmlXGridObject({
			parent: "div_erp_left_top_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpLeftTopGridColumns
		});	
		
		$erp.initGridCustomCell(erpLeftTopGrid);
		$erp.initGridComboCell(erpLeftTopGrid);
		$erp.attachDhtmlXGridFooterPaging(erpLeftTopGrid, 5);
		$erp.attachDhtmlXGridFooterRowCount(erpLeftTopGrid, '<spring:message code="grid.allRowCount" />');
		
		erpLeftTopGrid.attachEvent("onRowDblClicked",function(rId,cInd){
			var ORGN_CD = erpLeftTopGrid.cells(rId, erpLeftTopGrid.getColIndexById("ORGN_CD")).getValue();
			var STORE_AREA = erpLeftTopGrid.cells(rId, erpLeftTopGrid.getColIndexById("STORE_AREA")).getValue();
			var CDATE = erpLeftTopGrid.cells(rId, erpLeftTopGrid.getColIndexById("CDATE")).getValue();
			searchErpLeftBotGrid(ORGN_CD, STORE_AREA, CDATE);
		});
	}
	
	function searchErpLeftTopGrid(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var pdaDate = document.getElementById("searchPdaDate").value.replace(/\-/g,'');
		var outOrgnCd = cmbOUT_ORGN_CD.getSelectedValue();
		
		if(pdaDate == null || pdaDate == ""){
			isValidated = false;
			alertMessage = "조회일자를 지정해야 합니다.";
			alertCode = "1";
			document.getElementById("searchPdaDate").focus();
		} else if(outOrgnCd == null || outOrgnCd == ""){
			isValidated = false;
			alertMessage = "선택된 출고직영점이 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : alertType
				,"isAjax" : false
				,"alertCallbackFn" : function(){
					if(alertCode == "1"){
						document.getElementById("searchPdaDate").focus();
					}
				}
			});
		}else{
			erpLeftLayout.progressOn();
			$.ajax({
				url: "/sis/stock/transInOut/getPdaTransSummaryList.do" //PDA재고이동 Summary 자료 조회
				, data : {
					 "PDA_DATE" : pdaDate
					 , "OUT_ORGN_CD" : outOrgnCd
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLeftLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpLeftTopGrid);
						$erp.clearDhtmlXGrid(erpLeftBotGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpLeftTopGrid
								,'<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpLeftTopGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpLeftTopGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLeftLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	function deleteErpLeftTopGrid(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var pdaDate = document.getElementById("searchPdaDate").value.replace(/\-/g,'');
		var outOrgnCd = cmbOUT_ORGN_CD.getSelectedValue();
		
		if(pdaDate == null || pdaDate == ""){
			isValidated = false;
			alertMessage = "조회일자를 지정해야 합니다.";
			alertCode = "1";
		} else if(outOrgnCd == null || outOrgnCd == ""){
			isValidated = false;
			alertMessage = "선택된 출고직영점이 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : alertType
				,"isAjax" : false
				,"alertCallbackFn" : function(){
					if(alertCode == "1"){
						document.getElementById("searchPdaDate").focus();
					}
				}
			});
		}else{
			var leftTopGridCheckedRowIds = erpLeftTopGrid.getCheckedRows(erpLeftTopGrid.getColIndexById("CHECK"));
			if(leftTopGridCheckedRowIds == ""){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
			}else{
				var leftTopGridCheckedRowArray = leftTopGridCheckedRowIds.split(",");
				
				if(leftTopGridCheckedRowArray == "NoDataPrintRow" || leftTopGridCheckedRowArray.length == 0){
					$erp.alertMessage({
						"alertMessage" : "error.common.noCheckedData"
						, "alertCode" : null
						, "alertType" : "notice"
					});
					return;
				}else{
					$erp.confirmMessage({
						"alertMessage" : "PDA자료를 삭제하시겠습니까?",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							
							var leftTopGridUnikeys = "";
							
							for(var i=0; i<leftTopGridCheckedRowArray.length; i++) {
								if(i != leftTopGridCheckedRowArray.length-1){
									leftTopGridUnikeys += erpLeftTopGrid.cells(leftTopGridCheckedRowArray[i], erpLeftTopGrid.getColIndexById("UNI_KEY")).getValue() + ",";
								} else {
									leftTopGridUnikeys += erpLeftTopGrid.cells(leftTopGridCheckedRowArray[i], erpLeftTopGrid.getColIndexById("UNI_KEY")).getValue();
								}
							}
							
							erpLayout.progressOn();
							$.ajax({
								url : "/sis/stock/transInOut/deletePdaData.do" //PDA자료 삭제
								, data : {
									"PDA_DATE" : pdaDate
									,"OUT_ORGN_CD" : outOrgnCd
									,"UNI_KEYS" : leftTopGridUnikeys
									,"PDA_DATA_TYPE" : "6"			// 재고이동
								}
								, method : "POST"
								, dataType : "JSON"
								, success : function(data) {
									erpLayout.progressOff();
									if(data.isError){
										$erp.ajaxErrorMessage(data);
									}else {
										if(data.resultMsg == "SUCCESS"){
											$erp.clearDhtmlXGrid(erpLeftTopGrid);
											$erp.clearDhtmlXGrid(erpLeftBotGrid);
											$erp.alertMessage({
												"alertMessage" : "삭제가 완료 되었습니다.",
												"alertType" : "alert",
												"isAjax" : false,
												"alertCallbackFn" : function(){
													searchErpLeftTopGrid();
												}
											});
										}else{
											$erp.alertMessage({
												"alertMessage" : "삭제 실패 하였습니다.",
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
					});
				}
			}
		}
	}
	<%-- ■ erpLeftTopGrid 관련 Function 끝 --%>
	
	<%-- ■ erpLeftBotGrid 관련 Function 시작 --%>
	function initErpLeftBotGrid(){
		erpLeftBotGridColumns = [
			{id:"NO", label:["NO", "#rspan"], type: "cntr", width: "35", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "ORGN_CD", label : ["직영점", "#rspan"], type : "combo", width : "75", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			,{id : "BCD_NM", label:["품목명", "#rspan"], type: "ro", width: "520", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "GOODS_QTY", label:["수량", "#rspan"], type: "ron", width: "90", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			,{id : "CDATE", label:["CDATE", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
		];
		
		erpLeftBotGrid = new dhtmlXGridObject({
			parent: "div_erp_left_bot_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpLeftBotGridColumns
		});	
		
		$erp.initGridCustomCell(erpLeftBotGrid);
		$erp.initGridComboCell(erpLeftBotGrid);
		$erp.attachDhtmlXGridFooterPaging(erpLeftBotGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpLeftBotGrid, '<spring:message code="grid.allRowCount" />');
	}
	
	function searchErpLeftBotGrid(ORGN_CD,STORE_AREA,CDATE){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		
		if(ORGN_CD == null || ORGN_CD == ""){
			isValidated = false;
			alertMessage = "선택된 직영점이 없습니다.";
		} else if(STORE_AREA == null || STORE_AREA == ""){
			isValidated = false;
			alertMessage = "선택된 재고구역이 없습니다.";
		} else if(CDATE == null || CDATE == ""){
			isValidated = false;
			alertMessage = "선택된 조회일자가 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : alertType
				,"isAjax" : false
			});
		}else{
			erpLeftLayout.progressOn();
			$.ajax({
				url: "/sis/stock/transInOut/getPdaTransItemList.do" //PDA재고이동 Item 자료 조회
				, data : {
					 "STORE_AREA" : STORE_AREA
					 , "ORGN_CD" : ORGN_CD
					 , "CDATE" : CDATE
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLeftLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpLeftBotGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpLeftBotGrid
								,'<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpLeftBotGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpLeftBotGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLeftLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	<%-- ■ erpLeftBotGrid 관련 Function 끝 --%>
	
	<%-- ■ erpRightLayout 관련 Function 시작 --%>
	function initErpRightLayout(){
		erpRightLayout = new dhtmlXLayoutObject({
			parent: "div_erp_right_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "5E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false , fix_size:[true, true]}
				, {id: "b", text: "상단리본영역", header:false , fix_size:[true, true]}
				, {id: "c", text: "상단그리드영역", header:false , fix_size:[true, true]}
				, {id: "d", text: "하단리본영역", header:false , fix_size:[true, true]}
				, {id: "e", text: "하단그리드영역", header:false , fix_size:[true, true]}
			]		
		});
		erpRightLayout.cells("a").attachObject("div_erp_right_table");
		erpRightLayout.cells("a").setHeight($erp.getTableHeight(1));
		erpRightLayout.cells("b").attachObject("div_erp_right_top_ribbon");
		erpRightLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightLayout.cells("c").attachObject("div_erp_right_top_grid");
		erpRightLayout.cells("c").setHeight(300);
		erpRightLayout.cells("d").attachObject("div_erp_right_bot_ribbon");
		erpRightLayout.cells("d").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightLayout.cells("e").attachObject("div_erp_right_bot_grid");
	}	
	<%-- ■ erpRightLayout 관련 Function 끝 --%>

	<%-- ■ erpRightTopRibbon 관련 Function 시작 --%>
	function initErpRightTopRibbon() {
		erpRightTopRibbon = new dhtmlXRibbon({
			parent : "div_erp_right_top_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpRightTopGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "delete_data_erpRightTopGrid", type : "button", text:'재고이동자료삭제', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					, {id : "save_erpRightTopGrid", type : "button", text:'이동요청', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : false}
					, {id : "delete_erpRightTopGrid", type : "button", text:'요청취소', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
				]}
			]
		});	
		
		erpRightTopRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpRightTopGrid"){
				searchErpRightTopGrid();
			} else if (itemId == "delete_data_erpRightTopGrid"){
				deleteErpRightTopGrid();
			} else if (itemId == "save_erpRightTopGrid"){
				requestTransData();
			} else if (itemId == "delete_erpRightTopGrid"){
				requestCancelTransData();
			}
		});
	}
	
	//재고이동 요청
	function requestTransData(){
		var rightTopGridCheckedRowIds = erpRightTopGrid.getCheckedRows(erpRightTopGrid.getColIndexById("CHECK"));
		if(rightTopGridCheckedRowIds == ""){
			$erp.alertMessage({
				"alertMessage" : "error.common.noCheckedData"
				, "alertCode" : null
				, "alertType" : "notice"
			});
		}else{
			var rightTopGridCheckedRowArray = rightTopGridCheckedRowIds.split(",");
			
			if(rightTopGridCheckedRowArray == "NoDataPrintRow" || rightTopGridCheckedRowArray.length == 0){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
				return;
			}else{
				var rightTopGridCheckKeyArray = [];
				
				var validTF = true;
				
				for(var i=0; i<rightTopGridCheckedRowArray.length; i++){
					rightTopGridCheckKeyArray[i] = erpRightTopGrid.cells(rightTopGridCheckedRowArray[i], erpRightTopGrid.getColIndexById("UNI_KEY")).getValue();
					if("1" != erpRightTopGrid.cells(rightTopGridCheckedRowArray[i], erpRightTopGrid.getColIndexById("TRANS_STATE")).getValue()){
						validTF = false;
						break;
					}
				}
				
				if(!validTF){
					$erp.alertMessage({
						"alertMessage" : "자료입력 상태의 데이터만 이동요청이 가능합니다.",
						"alertType" : "alert",
						"isAjax" : false
					});
					return false;
				}else{
					$erp.confirmMessage({
						"alertMessage" : "체크된 자료를 이동요청 하시겠습니까?",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							erpLayout.progressOn();
							$.ajax({
								url : "/sis/stock/transInOut/requestTransData.do" //재고이동 요청
								,data : {
									"paramList" : rightTopGridCheckKeyArray
								}
								,method : "POST"
								,dataType : "JSON"
								,success : function(data) {
									erpLayout.progressOff();
									if(data.isError){
										$erp.ajaxErrorMessage(data);
									}else {
										if(data.resultMsg == "SUCCESS"){
											$erp.clearDhtmlXGrid(erpRightTopGrid);
											$erp.clearDhtmlXGrid(erpRightBotGrid);
											$erp.alertMessage({
												"alertMessage" : "이동요청이 처리 되었습니다.",
												"alertType" : "alert",
												"isAjax" : false,
												"alertCallbackFn" : function(){
													searchErpRightTopGrid();
												}
											});
										}else{
											$erp.alertMessage({
												"alertMessage" : "이동요청이 실패 하였습니다.",
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
					});
				}
			}
		}
	}
	
	//재고이동 요청취소
	function requestCancelTransData(){
		var rightTopGridCheckedRowIds = erpRightTopGrid.getCheckedRows(erpRightTopGrid.getColIndexById("CHECK"));
		if(rightTopGridCheckedRowIds == ""){
			$erp.alertMessage({
				"alertMessage" : "error.common.noCheckedData"
				, "alertCode" : null
				, "alertType" : "notice"
			});
		}else{
			var rightTopGridCheckedRowArray = rightTopGridCheckedRowIds.split(",");
			
			if(rightTopGridCheckedRowArray == "NoDataPrintRow" || rightTopGridCheckedRowArray.length == 0){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
				return;
			}else{
				var rightTopGridCheckKeyArray = [];
				
				var validTF = true;
				
				for(var i=0; i<rightTopGridCheckedRowArray.length; i++){
					rightTopGridCheckKeyArray[i] = erpRightTopGrid.cells(rightTopGridCheckedRowArray[i], erpRightTopGrid.getColIndexById("UNI_KEY")).getValue();
					if("2" != erpRightTopGrid.cells(rightTopGridCheckedRowArray[i], erpRightTopGrid.getColIndexById("TRANS_STATE")).getValue()){
						validTF = false;
						break;
					}
				}
				
				if(!validTF){
					$erp.alertMessage({
						"alertMessage" : "이동요청 상태의 데이터만 요청취소가 가능합니다.",
						"alertType" : "alert",
						"isAjax" : false
					});
					return false;
				}else{
					$erp.confirmMessage({
						"alertMessage" : "체크된 자료를 이동요청취소 하시겠습니까?",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							erpLayout.progressOn();
							$.ajax({
								url : "/sis/stock/transInOut/requestCancelTransData.do" //재고이동 요청취소
								,data : {
									"paramList" : rightTopGridCheckKeyArray
								}
								,method : "POST"
								,dataType : "JSON"
								,success : function(data) {
									erpLayout.progressOff();
									if(data.isError){
										$erp.ajaxErrorMessage(data);
									}else {
										if(data.resultMsg == "SUCCESS"){
											$erp.clearDhtmlXGrid(erpRightTopGrid);
											$erp.clearDhtmlXGrid(erpRightBotGrid);
											$erp.alertMessage({
												"alertMessage" : "이동요청취소가 처리 되었습니다.",
												"alertType" : "alert",
												"isAjax" : false,
												"alertCallbackFn" : function(){
													searchErpRightTopGrid();
												}
											});
										}else{
											$erp.alertMessage({
												"alertMessage" : "이동요청취소가 실패 하였습니다.",
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
					});
				}
			}
		}
	}
	<%-- ■ erpRightTopRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpRightTopGrid 관련 Function 시작 --%>	
	function initErpRightTopGrid(){
		erpRightTopGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			,{id : "TRANS_DATE", label:["이동일자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "TRANS_YYYYMMDD", label:["이동일자", "#rspan"], type: "ro", width: "75", sort : "str", align : "center", isHidden : false, isEssential : true}
			,{id : "TRANS_NO", label:["이동번호", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false }
			,{id : "OUT_ORGN_CD", label : ["출고직영점", "#rspan"], type : "combo", width : "75", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			,{id : "IN_ORGN_CD", label : ["입고직영점", "#rspan"], type : "combo", width : "75", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			,{id : "TOT_GOODS_NM", label:["품목명", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false }
			,{id : "TOT_QTY", label:["수량", "#rspan"], type: "ron", width: "85", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "TRANS_STATE", label : ["처리상태", "#rspan"], type : "combo", width : "135", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["TRANS_STATE"]}
			,{id : "RESP_USER", label:["담당자", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : false, isEssential : false }
			,{id : "UNI_KEY", label:["UNI_KEY", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
		];
		
		erpRightTopGrid = new dhtmlXGridObject({
			parent: "div_erp_right_top_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpRightTopGridColumns
		});
		
		$erp.initGridCustomCell(erpRightTopGrid);
		$erp.initGridComboCell(erpRightTopGrid);
		$erp.attachDhtmlXGridFooterPaging(erpRightTopGrid, 5);
		$erp.attachDhtmlXGridFooterRowCount(erpRightTopGrid, '<spring:message code="grid.allRowCount" />');
		
		erpRightTopGrid.attachEvent("onRowDblClicked",function(rId,cInd){
			var TRANS_DATE = erpRightTopGrid.cells(rId, erpRightTopGrid.getColIndexById("TRANS_DATE")).getValue();
			var TRANS_NO = erpRightTopGrid.cells(rId, erpRightTopGrid.getColIndexById("TRANS_NO")).getValue();
			searchErpRightBotGrid(TRANS_DATE, TRANS_NO);
		});
	}
	
	function searchErpRightTopGrid(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var transDate = document.getElementById("searchTransDate").value.replace(/\-/g,'');
		var outOrgnCd = cmbOUT_ORGN_CD.getSelectedValue();
		
		if(transDate == null || transDate == ""){
			isValidated = false;
			alertMessage = "이동일자를 지정해야 합니다.";
			alertCode = "1";
		} else if(outOrgnCd == null || outOrgnCd == ""){
			isValidated = false;
			alertMessage = "선택된 출고직영점이 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : alertType
				,"isAjax" : false
				,"alertCallbackFn" : function(){
					if(alertCode == "1"){
						document.getElementById("searchTransDate").focus();
					}
				}
			});
		}else{
			erpRightLayout.progressOn();
			$.ajax({
				url: "/sis/stock/transInOut/getStockTransMastList.do" //재고이동 마스터 자료 조회
				, data : {
					 "TRANS_DATE" : transDate
					 , "OUT_ORGN_CD" : outOrgnCd
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpRightLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpRightTopGrid);
						$erp.clearDhtmlXGrid(erpRightBotGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpRightTopGrid
								,'<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpRightTopGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpRightTopGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpRightLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	function deleteErpRightTopGrid(){
		var rightTopGridCheckedRowIds = erpRightTopGrid.getCheckedRows(erpRightTopGrid.getColIndexById("CHECK"));
		if(rightTopGridCheckedRowIds == ""){
			$erp.alertMessage({
				"alertMessage" : "error.common.noCheckedData"
				, "alertCode" : null
				, "alertType" : "notice"
			});
		}else{
			var rightTopGridCheckedRowArray = rightTopGridCheckedRowIds.split(",");
			
			if(rightTopGridCheckedRowArray == "NoDataPrintRow" || rightTopGridCheckedRowArray.length == 0){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
				return;
			}else{
				var rightTopGridCheckKeyArray = [];
				
				var validTF = true;
				
				for(var i=0; i<rightTopGridCheckedRowArray.length; i++){
					rightTopGridCheckKeyArray[i] = erpRightTopGrid.cells(rightTopGridCheckedRowArray[i], erpRightTopGrid.getColIndexById("UNI_KEY")).getValue();
					if("1" != erpRightTopGrid.cells(rightTopGridCheckedRowArray[i], erpRightTopGrid.getColIndexById("TRANS_STATE")).getValue()){
						validTF = false;
						break;
					}
				}
				
				if(!validTF){
					$erp.alertMessage({
						"alertMessage" : "자료입력 상태의 데이터만 삭제가 가능합니다.",
						"alertType" : "alert",
						"isAjax" : false
					});
					return false;
				}else{
					$erp.confirmMessage({
						"alertMessage" : "체크된 자료를 삭제 하시겠습니까?",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							erpLayout.progressOn();
							$.ajax({
								url : "/sis/stock/transInOut/deleteTransData.do" //재고이동 자료삭제
								,data : {
									"paramList" : rightTopGridCheckKeyArray
								}
								,method : "POST"
								,dataType : "JSON"
								,success : function(data) {
									erpLayout.progressOff();
									if(data.isError){
										$erp.ajaxErrorMessage(data);
									}else {
										if(data.resultMsg == "SUCCESS"){
											$erp.clearDhtmlXGrid(erpRightTopGrid);
											$erp.clearDhtmlXGrid(erpRightBotGrid);
											$erp.alertMessage({
												"alertMessage" : "자료삭제가 완료 되었습니다.",
												"alertType" : "alert",
												"isAjax" : false,
												"alertCallbackFn" : function(){
													searchErpRightTopGrid();
												}
											});
										}else{
											$erp.alertMessage({
												"alertMessage" : "자료삭제가 실패 하였습니다.",
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
					});
				}
			}
		}
	}
	<%-- ■ erpRightTopGrid 관련 Function 끝 --%>
	
	<%-- ■ erpRightBotRibbon 관련 Function 시작 --%>
	function initErpRightBotRibbon() {
		erpRightBotRibbon = new dhtmlXRibbon({
			parent : "div_erp_right_bot_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					//{id : "search_erpRightBotGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					{id : "add_erpRightBotGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
					,{id : "delete_erpRightBotGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					,{id : "save_erpRightBotGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false}
				]}
			]
		});	
		
		erpRightBotRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_erpRightBotGrid"){
				var erpRightBotAllRowIds = erpRightBotGrid.getAllRowIds();
				
				if(erpRightBotAllRowIds == "" || erpRightBotAllRowIds == "NoDataPrintRow"){
					$erp.alertMessage({
						"alertMessage" : "info.common.noData"
						, "alertType" : "notice"
					});
					return;
				}else{
					var transDate = erpRightBotGrid.cells(erpRightBotAllRowIds.split(",")[0],erpRightBotGrid.getColIndexById("TRANS_DATE")).getValue();
					var transNo = erpRightBotGrid.cells(erpRightBotAllRowIds.split(",")[0],erpRightBotGrid.getColIndexById("TRANS_NO")).getValue();
					var transState = erpRightBotGrid.cells(erpRightBotAllRowIds.split(",")[0],erpRightBotGrid.getColIndexById("TRANS_STATE")).getValue();
					if(transState != "1"){
						$erp.alertMessage({
							"alertMessage" : "자료입력 상태의 데이터만 변경이 가능합니다.",
							"alertType" : "alert",
							"isAjax" : false
						});
					}else{
						openSearchGoodsGridPopup(transDate,transNo);
					}
				}
			}else if (itemId == "delete_erpRightBotGrid"){
				deleteErpRightBotGrid();
			} else if (itemId == "save_erpRightBotGrid"){
				saveErpRightBotGrid();
			}
		});
	}
	<%-- ■ erpRightBotRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpRightBotGrid 관련 Function 시작 --%>	
	function initErpRightBotGrid(){
		erpRightBotGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			,{id : "TRANS_DATE", label:["이동일자", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : true, isDataColumn : true}
			,{id : "TRANS_NO", label:["이동번호", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : true, isDataColumn : true}
			,{id : "GOODS_BCD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "BCD_NM", label:["품목명", "#rspan"], type: "ro", width: "325", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "TRANS_QTY", label:["수량", "#rspan"], type: "edn", width: "85", sort : "int", align : "right", isHidden : false, isEssential : true, isDataColumn : true, numberFormat : "0,000", isSelectAll: true, maxLength: 7}
			,{id : "TRANS_STATE", label:["처리상태", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : true}
		];
		
		erpRightBotGrid = new dhtmlXGridObject({
			parent: "div_erp_right_bot_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpRightBotGridColumns
		});
		
		$erp.initGridCustomCell(erpRightBotGrid);
		$erp.initGridComboCell(erpRightBotGrid);
		$erp.attachDhtmlXGridFooterPaging(erpRightBotGrid, 20);
		$erp.attachDhtmlXGridFooterRowCount(erpRightBotGrid, '<spring:message code="grid.allRowCount" />');
		$erp.initGridDataColumns(erpRightBotGrid);
		
		erpRightBotGridDataProcessor = new dataProcessor();
		erpRightBotGridDataProcessor.init(erpRightBotGrid);
		erpRightBotGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpRightBotGrid);
	}
	
	function searchErpRightBotGrid(TRANS_DATE,TRANS_NO){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		
		if(TRANS_DATE == null || TRANS_DATE == ""){
			isValidated = false;
			alertMessage = "선택된 이동일자가 없습니다.";
		} else if(TRANS_NO == null || TRANS_NO == ""){
			isValidated = false;
			alertMessage = "선택된 이동번호가 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertType" : alertType
				, "isAjax" : false
			});
		}else{
			erpRightLayout.progressOn();
			$.ajax({
				url: "/sis/stock/transInOut/getStockTransDetlList.do" //재고이동 디테일 자료 조회
				, data : {
					 "TRANS_DATE" : TRANS_DATE
					 , "TRANS_NO" : TRANS_NO
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpRightLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpRightBotGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpRightBotGrid
								,'<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpRightBotGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpRightBotGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpRightLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(TRANS_DATE, TRANS_NO){
		var onClickAddData = function(erpGoodsGrid) {
			var isValidated = true;
			var alertMessage = "";
			var alertCode = "";
			var alertType = "error";
			
			var erpGoodsCheckRows = erpGoodsGrid.getCheckedRows(erpGoodsGrid.getColIndexById("CHECK")); // 조회된 그리드내역 중 선택한 row 번호 문자열로 넘어옴 ex) 1,5,7,10
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					, "alertCode" : alertCode
					, "alertType" : alertType
				});
			}else{
				var erpGoodsCheckArray = erpGoodsCheckRows.split(',');
			
				var goodsUid = null;
				for(var i = 0 ; i < erpGoodsCheckArray.length ; i ++) {
					goodsUid = erpRightBotGrid.uid();
					erpRightBotGrid.addRow(goodsUid);
				
					erpRightBotGrid.cells(goodsUid, erpRightBotGrid.getColIndexById("TRANS_DATE")).setValue(TRANS_DATE);
					erpRightBotGrid.cells(goodsUid, erpRightBotGrid.getColIndexById("TRANS_NO")).setValue(TRANS_NO);
					erpRightBotGrid.cells(goodsUid, erpRightBotGrid.getColIndexById("GOODS_BCD")).setValue(erpGoodsGrid.cells(erpGoodsCheckArray[i],erpGoodsGrid.getColIndexById("BCD_CD")).getValue());
					erpRightBotGrid.cells(goodsUid, erpRightBotGrid.getColIndexById("BCD_NM")).setValue(erpGoodsGrid.cells(erpGoodsCheckArray[i],erpGoodsGrid.getColIndexById("BCD_NM")).getValue());
					erpRightBotGrid.cells(goodsUid, erpRightBotGrid.getColIndexById("TRANS_QTY")).setValue("0");
					$erp.setDhtmlXGridFooterRowCount(erpRightBotGrid);
					erpRightBotGrid.selectRowById(goodsUid,false,true,false);
				}
				$erp.closePopup2("openSearchGoodsGridPopup"); 
			}
		}
		$erp.openSearchGoodsPopup(null,onClickAddData);
	}
	
	function deleteErpRightBotGrid(){
		var rightBotCheckRows = erpRightBotGrid.getCheckedRows(erpRightBotGrid.getColIndexById("CHECK"));
		var rightBotCheckArray = rightBotCheckRows.split(",");
		if(rightBotCheckRows == "" || rightBotCheckRows == "NoDataPrintRow"){
			$erp.alertMessage({
				"alertMessage" : "error.common.noCheckedData"
				, "alertCode" : null
				, "alertType" : "notice"
			});
		}else{
			if(rightBotCheckArray.length == 0){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
				return;
			}
			
			for(var j = 0; j < rightBotCheckArray.length; j++){
				erpRightBotGrid.deleteRow(rightBotCheckArray[j]);
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpRightBotGrid);
		}
	}
	
	function saveErpRightBotGrid() {
		if(erpRightBotGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var erpRightBotAllRowIds = erpRightBotGrid.getAllRowIds();
		
		if(erpRightBotAllRowIds == "" || erpRightBotAllRowIds == "NoDataPrintRow"){
			$erp.alertMessage({
				"alertMessage" : "info.common.noData"
				, "alertType" : "notice"
			});
			return;
		}else{
			var transDate = erpRightBotGrid.cells(erpRightBotAllRowIds.split(",")[0],erpRightBotGrid.getColIndexById("TRANS_DATE")).getValue();
			var transNo = erpRightBotGrid.cells(erpRightBotAllRowIds.split(",")[0],erpRightBotGrid.getColIndexById("TRANS_NO")).getValue();
			var transState = erpRightBotGrid.cells(erpRightBotAllRowIds.split(",")[0],erpRightBotGrid.getColIndexById("TRANS_STATE")).getValue();
			if(transState != "1"){
				$erp.alertMessage({
					"alertMessage" : "자료입력 상태의 데이터만 변경이 가능합니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			}else{
				$erp.confirmMessage({
					"alertMessage" : '<spring:message code="alert.common.saveData" />'
					,"alertType" : "alert"
					,"isAjax" : false
					,"alertCallbackFn" : function(){
						var paramData = $erp.serializeDhtmlXGridData(erpRightBotGrid);
						
						erpLayout.progressOn();
						$.ajax({
							url : "/sis/stock/transInOut/saveTransData.do" //재고이동 품목저장
							,data : paramData
							,method : "POST"
							,dataType : "JSON"
							,success : function(data) {
								erpLayout.progressOff();
								if(data.isError){
									$erp.ajaxErrorMessage(data);
								}else {
									$erp.alertMessage({
										"alertMessage" : '<spring:message code="info.common.saveSuccess" />'
										,"alertType" : "notice"
										,"isAjax" : false
										,"alertCallbackFn" : function(){
											searchErpRightTopGrid();
										}
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
		}
	}
	<%-- ■ erpRightBotGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	function initDhtmlXCombo(){
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",");
		var searchable = 1;
		console.log(search_cd_Arr);
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
				searchable = 2;
			}
		}
		
		 if(searchable == 2 ){
			 cmbOUT_ORGN_CD = $erp.getDhtmlXComboCommonCode("cmbOUT_ORGN_CD", "OUT_ORGN_CD", ["ORGN_CD","MK",null,null,null,"MK"], 100, null, false, LUI.LUI_orgn_cd);
		} else {
			cmbOUT_ORGN_CD = $erp.getDhtmlXComboTableCode("cmbOUT_ORGN_CD", "OUT_ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 100, null, false, LUI.LUI_orgn_cd);
		}
		
		cmbIN_ORGN_CD = $erp.getDhtmlXComboCommonCode("cmbIN_ORGN_CD", "IN_ORGN_CD", ["ORGN_CD","MK",null,null,null,"MK"], 100, null, false, null);
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ 기타 Function 시작 --%>
	function enterSearchToLeftGrid(kcode){
		if(kcode == 13){
			document.getElementById("searchPdaDate").blur();
			searchErpLeftTopGrid();
			searchErpRightTopGrid();
		}
	}
	
	function enterSearchToRightGrid(kcode){
		if(kcode == 13){
			document.getElementById("searchTransDate").blur();
			searchErpRightTopGrid();
		}
	}
	
	//재고이동자료생성
	function createTransData(){
		var leftTopGridCheckedRowIds = erpLeftTopGrid.getCheckedRows(erpLeftTopGrid.getColIndexById("CHECK"));
		if(leftTopGridCheckedRowIds == ""){
			$erp.alertMessage({
				"alertMessage" : "error.common.noCheckedData"
				, "alertCode" : null
				, "alertType" : "notice"
			});
		}else{
			var isValidated = true;
			var alertMessage = "";
			var alertType = "error";
			var alertCode = "";
			
			var pdaDate = document.getElementById("searchPdaDate").value.replace(/\-/g,'');
			var outOrgnCd = cmbOUT_ORGN_CD.getSelectedValue();
			var inOrgnCd = cmbIN_ORGN_CD.getSelectedValue();
			
			if(pdaDate == null || pdaDate == ""){
				isValidated = false;
				alertMessage = "조회일자를 지정해야 합니다.";
				alertCode = "1";
			} else if(outOrgnCd == null || outOrgnCd == ""){
				isValidated = false;
				alertMessage = "선택된 출고직영점이 없습니다.";
			} else if(inOrgnCd == null || inOrgnCd == ""){
				isValidated = false;
				alertMessage = "선택된 입고직영점이 없습니다.";
			} else if(outOrgnCd == inOrgnCd){
				isValidated = false;
				alertMessage = "출고직영점과 입고직영점이 같을 수 없습니다.";
			}
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					,"alertType" : alertType
					,"isAjax" : false
					,"alertCallbackFn" : function(){
						if(alertCode == "1"){
							document.getElementById("searchPdaDate").focus();
						}
					}
				});
			}else{
				var leftTopGridCheckedRowArray = leftTopGridCheckedRowIds.split(",");
				
				if(leftTopGridCheckedRowArray == "NoDataPrintRow" || leftTopGridCheckedRowArray.length == 0){
					$erp.alertMessage({
						"alertMessage" : "error.common.noCheckedData"
						, "alertCode" : null
						, "alertType" : "notice"
					});
					return;
				}else{
					$erp.confirmMessage({
						"alertMessage" : "재고이동 자료를 생성하시겠습니까?",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							
							var leftTopGridUnikeys = "";
							
							for(var i=0; i<leftTopGridCheckedRowArray.length; i++) {
								if(i != leftTopGridCheckedRowArray.length-1){
									leftTopGridUnikeys += erpLeftTopGrid.cells(leftTopGridCheckedRowArray[i], erpLeftTopGrid.getColIndexById("UNI_KEY")).getValue() + ",";
								} else {
									leftTopGridUnikeys += erpLeftTopGrid.cells(leftTopGridCheckedRowArray[i], erpLeftTopGrid.getColIndexById("UNI_KEY")).getValue();
								}
							}
							
							erpLayout.progressOn();
							$.ajax({
								url : "/sis/stock/transInOut/createTransData.do" //재고이동 자료 생성
								, data : {
									"PDA_DATE" : pdaDate
									,"OUT_ORGN_CD" : outOrgnCd
									,"IN_ORGN_CD" : inOrgnCd
									,"UNI_KEYS" : leftTopGridUnikeys
								}
								, method : "POST"
								, dataType : "JSON"
								, success : function(data) {
									erpLayout.progressOff();
									if(data.isError){
										$erp.ajaxErrorMessage(data);
									}else {
										if(data.resultMsg == "SUCCESS"){
											$erp.clearDhtmlXGrid(erpRightTopGrid);
											$erp.clearDhtmlXGrid(erpRightBotGrid);
											$erp.alertMessage({
												"alertMessage" : "생성이 완료 되었습니다.",
												"alertType" : "alert",
												"isAjax" : false,
												"alertCallbackFn" : function(){
													document.getElementById("searchTransDate").value = today;
													searchErpRightTopGrid();
												}
											});
										}else{
											$erp.alertMessage({
												"alertMessage" : "생성에 실패 하였습니다.",
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
					});
				}
			}
		}
	}
	<%-- ■ 기타 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_left_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_left_table" class="samyang_div" style="display:none">
			<table id = "tb_search_01" class = "table">
				<colgroup>
					<col width="80px"/>
					<col width="120px"/>
					<col width="80px"/>
					<col width="120px"/>
					<col width="80px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th>조회일자</th>
					<td>
						<input type="text" id="searchPdaDate" name="searchPdaDate" class="input_common input_calendar" style="margin-left:10px;" onkeydown="enterSearchToLeftGrid(event.keyCode);">
					</td>
					<th>출고직영점</th>
					<td>
						<div id="cmbOUT_ORGN_CD" style="margin-left:10px;"></div>
					</td>
					<th>입고직영점</th>
					<td style="border-right: 0px;">
						<div id="cmbIN_ORGN_CD" style="margin-left:10px;"></div>
					</td>
					<td>
						<input type="button" id="createTransData" value="재고이동 자료생성" class="input_common_button" onclick="createTransData()">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_left_top_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_left_top_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_left_bot_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	<div id="div_erp_right_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_right_table" class="samyang_div" style="display:none">
			<table id = "tb_search_01" class = "table">
				<colgroup>
					<col width="80px"/>
					<col width="*px"/>
				</colgroup>
				<tr>
					<th>이동일자</th>
					<td>
						<input type="text" id="searchTransDate" name="searchTransDate" class="input_common input_calendar" style="margin-left:10px;" onkeydown="enterSearchToRightGrid(event.keyCode);">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_right_top_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_right_top_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_right_bot_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_right_bot_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>