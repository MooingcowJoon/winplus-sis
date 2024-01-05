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
	LUI.exclude_auth_cd = "ALL,1,2,3";
	var AUTHOR_CD = "${screenDto.author_cd}";

	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		
		initDhtmlXCombo();
		document.getElementById("searchConvDate").value = today;
		
		$erp.asyncObjAllOnCreated(function(){
			if(AUTHOR_CD != "99999"){
				cmbORGN_CD.disable();
			}
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false , fix_size:[true, true]}
				, {id: "b", text: "리본영역", header:false , fix_size:[true, true]}
				, {id: "c", text: "그리드영역", header:false , fix_size:[true, true]}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight($erp.getTableHeight(2));
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
	}	
	<%-- ■ erpLayout 관련 Function 끝 --%>

	<%-- ■ erpRibbon 관련 Function 시작 --%>
	function initErpRibbon() {
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					,{id : "add_erpGrid", type : "button", text:'대출입등록', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					,{id : "delete_erpGrid", type : "button", text:'대출입삭제', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					,{id : "save_reqConfirm", type : "button", text:'대출입요청등록', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : false}
					,{id : "delete_reqConfirmCancel", type : "button", text:'대출입요청취소', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					//,{id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpGrid"){
				searchErpGrid();
			} else if (itemId == "add_erpGrid"){
				openAddConvData();
			} else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
			} else if (itemId == "save_reqConfirm"){
				reqConfirmConv();
			} else if (itemId == "delete_reqConfirmCancel"){
				reqConfirmCancelConv();
			} else if (itemId == "excel_erpGrid"){
				/*
				$erp.exportDhtmlXGridExcel({
					"grid" : erpGrid
					, "fileName" : "대출입내역"
					, "isForm" : false
				});
				*/
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			//{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "CONV_DATE", label:["대출입일자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "CONV_YYYYMMDD", label:["대출입일자", "#rspan"], type: "ro", width: "75", sort : "str", align : "center", isHidden : false, isEssential : true}
			,{id : "CONV_CD", label:["대출입번호", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false }
			,{id : "ORI_TOT_AMT", label:["원물금액(VAT제외)", "#rspan"], type: "ron", width: "115", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			,{id : "REPLC_TOT_AMT", label:["대물금액(VAT제외)", "#rspan"], type: "ron", width: "115", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			,{id : "MDATE_YYYYMMDD", label:["수정일시", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false }
			,{id : "CONV_STATE", label:["처리상태", "#rspan"], type: "combo", width: "180", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["CONV_STATE"]}
			,{id : "CONV_CD", label:["CONV_CD", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "ORI_SEND_TYPE", label:["ORI_SEND_TYPE", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "REPLC_SEND_TYPE", label:["REPLC_SEND_TYPE", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGrid.attachEvent("onRowDblClicked",function(rId,cInd){
			var convCd = erpGrid.cells(rId,erpGrid.getColIndexById("CONV_CD")).getValue();
			openAddConvData(convCd);
		});
	}
	
	function searchErpGrid(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var convDate = document.getElementById("searchConvDate").value.replace(/\-/g,'');
		var orgnCd = cmbORGN_CD.getSelectedValue();
		
		if(convDate == null || convDate == ""){
			isValidated = false;
			alertMessage = "대출입일자를 지정해야 합니다.";
			alertCode = "1";
		} else if(orgnCd == null || orgnCd == ""){
			isValidated = false;
			alertMessage = "선택된 직영점이 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : alertType
				,"isAjax" : false
				,"alertCallbackFn" : function(){
					if(alertCode == "1"){
						document.getElementById("searchConvDate").focus();
					}
				}
			});
		}else{
			erpLayout.progressOn();
			$.ajax({
				url: "/sis/stock/conversion/getStockConvHeaderList.do" //대출입 자료 조회
				, data : {
					 "CONV_DATE" : convDate
					 , "ORGN_CD" : orgnCd
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpGrid);
						var gridDataList = data.dataMapList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpGrid
								,'<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	function deleteErpGrid(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var orgnDivCd = cmbORGN_DIV_CD.getSelectedValue();
		var orgnCd = cmbORGN_CD.getSelectedValue();
		var convDate = document.getElementById("searchConvDate").value.replace(/\-/g,'');
		
		if(convDate == null || convDate == ""){
			isValidated = false;
			alertMessage = "대출입일자를 지정해야 합니다.";
			alertCode = "1";
		} else if(orgnCd == null || orgnCd == ""){
			isValidated = false;
			alertMessage = "선택된 직영점이 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : alertType
				,"isAjax" : false
				,"alertCallbackFn" : function(){
					if(alertCode == "1"){
						document.getElementById("searchConvDate").focus();
					}
				}
			});
		}else{
			var gridCheckedRowIds = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
			if(gridCheckedRowIds == ""){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
			}else{
				var gridCheckedRowArray = gridCheckedRowIds.split(",");
				
				if(gridCheckedRowArray == "NoDataPrintRow" || gridCheckedRowArray.length == 0){
					$erp.alertMessage({
						"alertMessage" : "error.common.noCheckedData"
						, "alertCode" : null
						, "alertType" : "notice"
					});
					return;
				}else{
					var gridUnikeys = "";
					
					for(var i=0; i<gridCheckedRowArray.length; i++){
						if(i != gridCheckedRowArray.length-1){
							gridUnikeys += erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("CONV_CD")).getValue() + ",";
						} else {
							gridUnikeys += erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("CONV_CD")).getValue();
						}
						
						if("Y" == erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("ORI_SEND_TYPE")).getValue()){
							isValidated = false;
							alertMessage = "전송처리가 되지 않은 대출입자료만 삭제가 가능합니다.";
							break;
						}else if("Y" == erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("REPLC_SEND_TYPE")).getValue()){
							isValidated = false;
							alertMessage = "전송처리가 되지 않은 대출입자료만 삭제가 가능합니다.";
							break;
						}else if("1" != erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("CONV_STATE")).getValue()){
							isValidated = false;
							alertMessage = "자료입력 상태의 자료만 삭제가 가능합니다.";
							break;
						}
					}
					
					if(!isValidated){
						$erp.alertMessage({
							"alertMessage" : alertMessage,
							"alertType" : "alert",
							"isAjax" : false
						});
						return false;
					}else{
						$erp.confirmMessage({
							"alertMessage" : "체크된 대출입자료를 삭제하시겠습니까?",
							"alertType" : "alert",
							"isAjax" : false,
							"alertCallbackFn" : function(){
								erpLayout.progressOn();
								$.ajax({
									url : "/sis/stock/conversion/deleteConversionManagementList.do"
									, data : {
										"ORGN_DIV_CD" : orgnDivCd
										,"ORGN_CD" : orgnCd
										,"CONV_DATE" : convDate
										,"UNI_KEYS" : gridUnikeys
									}
									,method : "POST"
									,dataType : "JSON"
									,success : function(data) {
										erpLayout.progressOff();
										if(data.isError){
											$erp.ajaxErrorMessage(data);
										}else {
											if(data.resultMsg == "SUCCESS"){
												$erp.clearDhtmlXGrid(erpGrid);
												$erp.alertMessage({
													"alertMessage" : "삭제가 완료 되었습니다.",
													"alertType" : "alert",
													"isAjax" : false,
													"alertCallbackFn" : function(){
														searchErpGrid();
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
	}
	
	//대출입 요청
	function reqConfirmConv(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var orgnDivCd = cmbORGN_DIV_CD.getSelectedValue();
		var orgnCd = cmbORGN_CD.getSelectedValue();
		var convDate = document.getElementById("searchConvDate").value.replace(/\-/g,'');
		
		if(convDate == null || convDate == ""){
			isValidated = false;
			alertMessage = "대출입일자를 지정해야 합니다.";
			alertCode = "1";
		} else if(orgnCd == null || orgnCd == ""){
			isValidated = false;
			alertMessage = "선택된 직영점이 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : alertType
				,"isAjax" : false
				,"alertCallbackFn" : function(){
					if(alertCode == "1"){
						document.getElementById("searchConvDate").focus();
					}
				}
			});
		}else{
			var gridCheckedRowIds = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
			if(gridCheckedRowIds == ""){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
			}else{
				var gridCheckedRowArray = gridCheckedRowIds.split(",");
				
				if(gridCheckedRowArray == "NoDataPrintRow" || gridCheckedRowArray.length == 0){
					$erp.alertMessage({
						"alertMessage" : "error.common.noCheckedData"
						, "alertCode" : null
						, "alertType" : "notice"
					});
					return;
				}else{
					var gridUnikeys = "";
					
					for(var i=0; i<gridCheckedRowArray.length; i++){
						if(i != gridCheckedRowArray.length-1){
							gridUnikeys += erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("CONV_CD")).getValue() + ",";
						} else {
							gridUnikeys += erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("CONV_CD")).getValue();
						}
						
						if("Y" == erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("ORI_SEND_TYPE")).getValue()){
							isValidated = false;
							alertMessage = "전송처리가 되지 않은 대출입자료만 대출입요청이 가능합니다.";
							break;
						}else if("Y" == erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("REPLC_SEND_TYPE")).getValue()){
							isValidated = false;
							alertMessage = "전송처리가 되지 않은 대출입자료만 대출입요청이 가능합니다.";
							break;
						}else if("1" != erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("CONV_STATE")).getValue()){
							isValidated = false;
							alertMessage = "자료입력 상태의 자료만 대출입요청이 가능합니다.";
							break;
						}
					}
					
					if(!isValidated){
						$erp.alertMessage({
							"alertMessage" : alertMessage,
							"alertType" : "alert",
							"isAjax" : false
						});
						return false;
					}else{
						$erp.confirmMessage({
							"alertMessage" : "체크된 자료를 대출입요청하시겠습니까?",
							"alertType" : "alert",
							"isAjax" : false,
							"alertCallbackFn" : function(){
								erpLayout.progressOn();
								$.ajax({
									url : "/sis/stock/conversion/reqConfirmConv.do" //대출입 요청
									, data : {
										"ORGN_DIV_CD" : orgnDivCd
										,"ORGN_CD" : orgnCd
										,"CONV_DATE" : convDate
										,"UNI_KEYS" : gridUnikeys
									}
									,method : "POST"
									,dataType : "JSON"
									,success : function(data) {
										erpLayout.progressOff();
										if(data.isError){
											$erp.ajaxErrorMessage(data);
										}else {
											if(data.resultMsg == "SUCCESS"){
												$erp.clearDhtmlXGrid(erpGrid);
												$erp.alertMessage({
													"alertMessage" : "대출입요청이 완료 되었습니다.",
													"alertType" : "alert",
													"isAjax" : false,
													"alertCallbackFn" : function(){
														searchErpGrid();
													}
												});
											}else{
												$erp.alertMessage({
													"alertMessage" : "대출입요청이 실패 하였습니다.",
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
	}
	
	//대출입 요청취소
	function reqConfirmCancelConv(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var orgnDivCd = cmbORGN_DIV_CD.getSelectedValue();
		var orgnCd = cmbORGN_CD.getSelectedValue();
		var convDate = document.getElementById("searchConvDate").value.replace(/\-/g,'');
		
		if(convDate == null || convDate == ""){
			isValidated = false;
			alertMessage = "대출입일자를 지정해야 합니다.";
			alertCode = "1";
		} else if(orgnCd == null || orgnCd == ""){
			isValidated = false;
			alertMessage = "선택된 직영점이 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : alertType
				,"isAjax" : false
				,"alertCallbackFn" : function(){
					if(alertCode == "1"){
						document.getElementById("searchConvDate").focus();
					}
				}
			});
		}else{
			var gridCheckedRowIds = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
			if(gridCheckedRowIds == ""){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
			}else{
				var gridCheckedRowArray = gridCheckedRowIds.split(",");
				
				if(gridCheckedRowArray == "NoDataPrintRow" || gridCheckedRowArray.length == 0){
					$erp.alertMessage({
						"alertMessage" : "error.common.noCheckedData"
						, "alertCode" : null
						, "alertType" : "notice"
					});
					return;
				}else{
					var gridUnikeys = "";
					
					for(var i=0; i<gridCheckedRowArray.length; i++){
						if(i != gridCheckedRowArray.length-1){
							gridUnikeys += erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("CONV_CD")).getValue() + ",";
						} else {
							gridUnikeys += erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("CONV_CD")).getValue();
						}
						
						if("Y" == erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("ORI_SEND_TYPE")).getValue()){
							isValidated = false;
							alertMessage = "전송처리가 되지 않은 대출입자료만 요청취소가 가능합니다.";
							break;
						}else if("Y" == erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("REPLC_SEND_TYPE")).getValue()){
							isValidated = false;
							alertMessage = "전송처리가 되지 않은 대출입자료만 요청취소가 가능합니다.";
							break;
						}else if("2" != erpGrid.cells(gridCheckedRowArray[i], erpGrid.getColIndexById("CONV_STATE")).getValue()){
							isValidated = false;
							alertMessage = "대출입요청 상태의 자료만 요청취소가 가능합니다.";
							break;
						}
					}
					
					if(!isValidated){
						$erp.alertMessage({
							"alertMessage" : alertMessage,
							"alertType" : "alert",
							"isAjax" : false
						});
						return false;
					}else{
						$erp.confirmMessage({
							"alertMessage" : "체크된 자료를 요청취소하시겠습니까?",
							"alertType" : "alert",
							"isAjax" : false,
							"alertCallbackFn" : function(){
								erpLayout.progressOn();
								$.ajax({
									url : "/sis/stock/conversion/reqConfirmCancelConv.do" //대출입 요청취소
									, data : {
										"ORGN_DIV_CD" : orgnDivCd
										,"ORGN_CD" : orgnCd
										,"CONV_DATE" : convDate
										,"UNI_KEYS" : gridUnikeys
									}
									,method : "POST"
									,dataType : "JSON"
									,success : function(data) {
										erpLayout.progressOff();
										if(data.isError){
											$erp.ajaxErrorMessage(data);
										}else {
											if(data.resultMsg == "SUCCESS"){
												$erp.clearDhtmlXGrid(erpGrid);
												$erp.alertMessage({
													"alertMessage" : "대출입요청취소가 완료 되었습니다.",
													"alertType" : "alert",
													"isAjax" : false,
													"alertCallbackFn" : function(){
														searchErpGrid();
													}
												});
											}else{
												$erp.alertMessage({
													"alertMessage" : "대출입요청취소가 실패 하였습니다.",
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
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	function initDhtmlXCombo(){
		//cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK",null,null,null,"MK"], 100, null, false, LUI.LUI_orgn_cd);
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, true, null, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, null, false, null);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), null, false, null);
			}); 
		});
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ 기타 Function 시작 --%>
	function enterSearchToGrid(kcode){
		if(kcode == 13){
			document.getElementById("searchConvDate").blur();
			searchErpGrid();
		}
	}
	
	function openAddConvData(convCd){
		
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var convDate = document.getElementById("searchConvDate").value.replace(/\-/g,'');
		var orgnDivCd = cmbORGN_DIV_CD.getSelectedValue();
		var orgnCd = cmbORGN_CD.getSelectedValue();
		
		if(convDate == null || convDate == ""){
			isValidated = false;
			alertMessage = "대출입일자를 지정해야 합니다.";
			alertCode = "1";
		} else if(orgnCd == null || orgnCd == ""){
			isValidated = false;
			alertMessage = "선택된 직영점이 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : alertType
				,"isAjax" : false
				,"alertCallbackFn" : function(){
					if(alertCode == "1"){
						document.getElementById("searchConvDate").focus();
					}
				}
			});
		}else{
			var paramMap = new Object();
			paramMap.CONV_DATE = convDate;
			paramMap.ORGN_DIV_CD = orgnDivCd;
			paramMap.ORGN_CD = orgnCd;
			if(convCd == null || convCd == undefined || convCd == ""){
				paramMap.CONV_CD = "";
			}else{
				paramMap.CONV_CD = convCd;
			}
			
			var onSaveAfterSearch = function(){
				this.searchErpGrid();
				$erp.closePopup2("openAddConvData");
			}
			
			var url = "/sis/stock/conversion/openAddConvData.sis";
			var option = {
					"width" : 920
					,"height" :766
					,"resize" : false
					,"win_id" : "openAddConvData"
			}
			
			var onContentLoaded = function(){
				var popWin = this.getAttachedObject().contentWindow;
				
				if(onSaveAfterSearch && typeof onSaveAfterSearch === 'function'){
					while(popWin.popOnSaveAfterSearch == undefined){
						popWin.popOnSaveAfterSearch = onSaveAfterSearch;
					}
				}
				
				this.progressOff();
			}
			
			$erp.openPopup(url, {"convInfo" : JSON.stringify(paramMap)}, onContentLoaded, option);
		}
	}
	<%-- ■ 기타 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_table" class="samyang_div" style="display:none">
		<table id = "tb_search_01" class = "table">
			<colgroup>
				<col width="80px">
				<col width="230px">
				<col width="80px">
				<col width="*">
			</colgroup>
			<tr>
				<th>법인구분</th>
				<td>
					<div id="cmbORGN_DIV_CD"></div>
				</td>
				<th>조직명</th>
				<td>
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
			<tr>
				<th>대출입일자</th>
				<td colspan="3">
					<input type="text" id="searchConvDate" name="searchConvDate" class="input_common input_calendar" onkeydown="enterSearchToGrid(event.keyCode);">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>