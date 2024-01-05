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
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openAddNewLoanPopup");
	var erpPopupType = '${paramMap.popupType}'; // "add" : 이미등록된 회원/거래처 등록 , "new" : 신규회원/거래처 등록, "update" : 이미등록된 여신정보 보기
	var loan_apply_type = '${paramMap.loanType}'
	var erpPopupLayout;
	var erpPopupRibbon;
	var cmbIO_TYPE;
	var cmbUSE_YN;
	var cmbLOCK_FLAG;
	var loan_evidence_File;
	var loanEviFileName;
	var erpPopupGridDataProcessor;
	var org_loan_amt;
	
	console.log(erpPopupType);
	console.log('${paramMap.screen}');
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			if(loan_apply_type == 'C' && erpPopupType != "update"){
				erpPopupWindowsCell.setText("신규여신(거래처)추가");
			} else if(loan_apply_type == 'M' && erpPopupType != "update") {
				erpPopupWindowsCell.setText("신규여신(회원)추가");
			} else if(loan_apply_type == 'C' && erpPopupType == "update"){
				erpPopupWindowsCell.setText("기존여신(거래처) 정보수정");
			} else if(loan_apply_type == 'M' && erpPopupType == "update"){
				erpPopupWindowsCell.setText("기존여신(회원) 정보수정");
			}
		}
		
		initErpPopupLayout();
		initErpRibbon();
		initErpUploadRibbon();
		initDhtmlXCombo();
		initErpPopupGrid();
		
		$erp.asyncObjAllOnCreated(function(){
			indeCheck();
			$("#txtORGN_CD").val('${paramMap.ORGN_CD}');
			
			if(erpPopupType == "update"){
				if('${paramMap.screen}' != "여신관리") {
					erpPopupRibbon.disable("save_ribbon");
					erpPopupUploadRibbon.disable("add_ribbon");
					erpPopupUploadRibbon.disable("delete_ribbon");
				} 
				var selected_loan_seq = '${paramMap.LOAN_SEQ}';
				getLoanInfo(selected_loan_seq);
			} else if(erpPopupType == "new" && "${paramMap.LOAN_CD}" != ""){
					numberWithCommas('${paramMap.CREDIT_AMT}', 'credit');
					numberWithCommas('${paramMap.CASH_AMT}', 'cash');
					numberWithCommas('${paramMap.GRNT_AMT}', 'grnt');
					cmbIO_TYPE.setComboValue('${paramMap.IO_TYPE}');
					cmbUSE_YN.setComboValue('${paramMap.USE_YN}');
					cmbLOCK_FLAG.setComboValue('${paramMap.LOCK_FLAG}');
					searchLoanEviFileList('${paramMap.FILE_GRUP_NO}');
			} 
		});
	});
	
	function getLoanInfo(seq){
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/price/getLoanInfo.do"
			,data : {
				"LOAN_CD" : '${paramMap.LOAN_CD}'
				, "LOAN_SEQ" : seq
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				console.log("success");
				var dataMap = data.dataMap;
				console.log(dataMap);
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					if($erp.isEmpty(dataMap)){
						$erp.alertMessage({
							"alertMessage" : "grid.noSearchData"
							, "alertCode" : ""
							, "alertType" : "info"
						});
					} else {
						$erp.dataAutoBind("tb_erp_table", dataMap);
						$("#txtINDE_AMT").val("0");
						org_loan_amt = dataMap.LOAN_AMT;
						searchLoanEviFileList(dataMap.EVI_FILE_NM);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "4E"
			, cells : [
				{id: "a", text: "리본영역", header:false, fix_size:[true, true]}
				,{id: "b", text: "저장정보영역", header:false, fix_size:[true, true]}
				,{id: "c", text: "업로드리본영역", header:false, fix_size:[true, true]}
				,{id: "d", text: "그리드영역", header:false, fix_size:[true, true]}
			]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_info");
		erpPopupLayout.cells("c").attachObject("div_erp_popup_upload_ribbon");
		erpPopupLayout.cells("d").attachObject("div_erp_popup_upload_grid");
		
		erpPopupLayout.setSeparatorSize(1, 0);
		
		if(erpPopupType == 'new'){
			erpPopupLayout.cells("b").setHeight(75);
			erpPopupLayout.cells("c").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
			$("#txtCUSTMR_NM").attr('class', 'input_common');
			$("#txtMEM_NM").attr('class', 'input_common');
			$('#tb_erp_table tr:nth-child(2)').hide();
			$('#tb_erp_table tr:nth-child(3)').hide();
			$('#tb_erp_table tr:nth-child(5)').hide();
			var dom_lock_flag = $("#cmbLOCK_FLAG").parents().get(1);
			dom_lock_flag.removeChild(dom_lock_flag.children[4]);
			dom_lock_flag.removeChild(dom_lock_flag.children[4]); // 지우지마세요.
		}else if(erpPopupType == 'add'){
			erpPopupLayout.cells("b").setHeight(115);
			erpPopupLayout.cells("c").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
			$('#tb_erp_table tr:nth-child(2)').hide();
			$('#tb_erp_table tr:nth-child(5)').hide();
			var dom = $("#txtCUSTMR_CD").parents().get(1);
			if(loan_apply_type == "C"){
				dom.removeChild(dom.children[1]);
				$("input").remove("#txtMEM_NM, #btnSEARCH_MEMBER");
				if('${paramMap.CUSTMR_CD}' != ''){
					$('#btnSEARCH_CUSTMR').hide();
					$('#txtCUSTMR_CD').val('${paramMap.CUSTMR_CD}');
					$('#txtCUSTMR_NM').val('${paramMap.CUSTMR_NM}');
				}
			} else if(loan_apply_type == "M"){
				dom.removeChild(dom.children[0]);
				$("input").remove("#txtCUSTMR_NM, #btnSEARCH_CUSTMR");
				if('${paramMap.MEM_NO}' != ''){
					$('#btnSEARCH_MEMBER').hide();
					$('#txtMEM_NO').val('${paramMap.MEM_NO}');
					$('#txtMEM_NM').val('${paramMap.MEM_NM}');
				}
			}
		}else if(erpPopupType == 'update'){
			erpPopupLayout.cells("b").setHeight(115);
			erpPopupLayout.cells("c").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
			$('#tb_erp_table tr:nth-child(3)').hide();
			var dom = $("#txtCUSTMR_CD").parents().get(1);
			if(loan_apply_type == "C"){
				$("#txtCUSTMR_CD").val('${paramMap.CUSTMR_CD}');
				$("#txtCUSTMR_NM").val('${paramMap.CUSTMR_NM}');
				dom.removeChild(dom.children[1]);
				$("input").remove("#txtMEM_NM, #btnSEARCH_MEMBER");	
			} else if(loan_apply_type == "M"){
				$('#txtMEM_NO').val('${paramMap.MEM_NO}');
				$("#txtMEM_NM").val('${paramMap.MEM_NM}');
				dom.removeChild(dom.children[0]);
				$("input").remove("#txtCUSTMR_NM, #btnSEARCH_CUSTMR");
			}
		}
	}
	
	function initErpRibbon() {
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon",
			skin : ERP_RIBBON_CURRENT_SKINS,
			icons_path : ERP_RIBBON_CURRENT_ICON_PATH,
			items : [{
				type : "block",
				mode : 'rows',
				list : [ 
					{id : "save_ribbon", type : "button", text : '<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]
			}]
		});
		
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId) {
			if (itemId == "save_ribbon") {
				if(erpPopupType == "add"){
					saveAddLoan();
				} else if(erpPopupType == "new"){
					saveNewLoan();
				} else if(erpPopupType == "update"){
					updateLoanInfo();
				}
			}
		});
	}
	
	function initErpUploadRibbon() {
		erpPopupUploadRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_upload_ribbon",
			skin : ERP_RIBBON_CURRENT_SKINS,
			icons_path : ERP_RIBBON_CURRENT_ICON_PATH,
			items : [{
				type : "block",
				mode : 'rows',
				list : [ 
					{id : "add_ribbon", type : "button", text : '<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_ribbon", type : "button", text : '<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
				]
			}]
		});
		
		erpPopupUploadRibbon.attachEvent("onClick", function(itemId, bId) {
			if (itemId == "add_ribbon") {
				openFileUploadPopup();
			} else if(itemId == "delete_ribbon") {
				$erp.deleteGridCheckedRows(erpPopupGrid, [], []);
				var url = "/common/system/file/deleteAttachFileList.do";
				var send_data = $erp.dataSerializeOfGridByCRUD(erpPopupGrid, true, {"DIRECTORY_KEY" : "loan"})["D"];
				var if_success = function(data){
					$erp.clearDhtmlXGrid(erpPopupGrid); //기존데이터 삭제
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(erpPopupGrid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						parseAttachFileList(data.gridDataList);
					}
					$erp.setDhtmlXGridFooterRowCount(erpPopupGrid); // 현재 행수 계산
				}
				var if_error = function(XHR, status, error){
				}
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpPopupLayout);
			}
		});
	}
	
	function initErpPopupGrid(){
		erpPopupGridColumns = [
			    {id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}
			  ,{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false} 	
			  , {id : "FILE_GRUP_NO", label:["파일그룹번호", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}              
			  , {id : "FILE_SEQ", label:["순번", "#rspan"], type: "ro", width: "40", sort : "str", align : "center", isHidden : true, isEssential : false}              
			  , {id : "FILE_ORG_NM", label:["증빙자료명", "#rspan"], type: "ro", width: "230", sort : "str", align : "center", isHidden : false, isEssential : false}              
			  , {id : "DOWNLOAD_BUTTON", label:["다운로드", "#rspan"], type: "button", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}              
		];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_upload_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH	
			, columns : erpPopupGridColumns
		});
		
		erpPopupGrid.attachEvent("onRowSelect", function (rowId,columnIdx){
			if(erpPopupGrid.getColumnId(columnIdx) == "DOWNLOAD_BUTTON"){
				var FILE_SEQ = erpPopupGrid.cells(rowId, erpPopupGrid.getColIndexById("FILE_SEQ")).getValue();
				var FILE_GRUP_NO = erpPopupGrid.cells(rowId, erpPopupGrid.getColIndexById("FILE_GRUP_NO")).getValue();
				$erp.requestFileDownload({"FILE_GRUP_NO" : FILE_GRUP_NO, "FILE_SEQ" : FILE_SEQ});
			}
		});
		
		erpPopupGridDataProcessor = $erp.initGrid(erpPopupGrid, {useAutoAddRowPaste : true, deleteDuplication : false, editableColumnIdListOfInsertedRows : ["OBJ_CD"], notEditableColumnIdListOfInsertedRows : []});
	}
	
	function searchLoanEviFileList(file_grup_no){
		var url = "/common/system/file/getAttachFileList.do";
		if(file_grup_no != undefined && file_grup_no != null && file_grup_no != ""){
			var send_data = {"FILE_GRUP_NO" : file_grup_no};
			var if_success = function(data){
				$erp.clearDhtmlXGrid(erpPopupGrid); //기존데이터 삭제
				if($erp.isEmpty(data.gridDataList)){
					//검색 결과 없음
					$erp.addDhtmlXGridNoDataPrintRow(erpPopupGrid, '<spring:message code="info.common.noDataSearch" />');
				}else{
					parseAttachFileList(data.gridDataList);
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupGrid); // 현재 행수 계산
			}
			var if_error = function(XHR, status, error){}
			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpPopupLayout);
		}else{
			$erp.addDhtmlXGridNoDataPrintRow(erpPopupGrid, '<spring:message code="info.common.noDataSearch" />');
		}
	}
	
	function openFileUploadPopup(file_grup_no){
		var uploadFileLimitCount = 10;
		var existAttachFileCount = 0;
		existAttachFileCount = erpPopupGrid.getRowsNum();
		console.log(existAttachFileCount);
		
		var onUploadFile = function(files, serverReturnData){ //업로드 파일 수만큼 발생
		};
		var onUploadComplete = function(uploadedFileInfoList, lastServerReturnData){ //전체 파일 업로드 후 발생
			parseAttachFileList(lastServerReturnData);
		};
		var onBeforeFileAdd = function(file){}; //선택한 업로드 파일이 팝업창에 하나씩 추가될때 발생
		var onBeforeClear = function(){};
		
		var FILE_GRUP_NO = document.getElementById("txtFILE_GRUP_NO").value;
		if(FILE_GRUP_NO == undefined || FILE_GRUP_NO == null || FILE_GRUP_NO == ""){
			var url = "/common/system/file/getFileGrupNo.do";
			var send_data = {};
			var if_success = function(data){
				console.log(data.FILE_GRUP_NO);
				document.getElementById("txtFILE_GRUP_NO").value = data.FILE_GRUP_NO;
		 		$erp.openAttachFilesUploadPopup({"DIRECTORY_KEY" : "loan", "FILE_GRUP_NO" : data.FILE_GRUP_NO, "FILE_REG_TYPE" : "loan"}, uploadFileLimitCount, existAttachFileCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			}
			
			var if_error = function(XHR, status, error){}
			
			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpPopupLayout);
			
		}else{
			console.log(FILE_GRUP_NO);
	 		$erp.openAttachFilesUploadPopup({"DIRECTORY_KEY" : "loan", "FILE_GRUP_NO" : FILE_GRUP_NO, "FILE_REG_TYPE" : "loan"}, uploadFileLimitCount, existAttachFileCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
		}
	}
	
	function parseAttachFileList(gridDataList){
		console.log(gridDataList);
		$erp.clearDhtmlXGrid(erpPopupGrid); //기존데이터 삭제
		erpPopupGrid.parse(gridDataList,'js');
		$erp.setDhtmlXGridFooterRowCount(erpPopupGrid); // 현재 행수 계산
	}
	
	function saveNewLoan(){
		var isValidated = true;
		var alertType = "error";
		var resultObj = $erp.getElementEssentialEmpty("tb_erp_table");
		var infoMessage = '<spring:message code="info.common.essentialItem" />';
		
		if(resultObj){
			alertCallbackFnParam = {"obj" : resultObj, "message" : infoMessage};
			alertCallbackFn = function(param){
				$erp.initDhtmlXPopupDom(param.obj, param.message);
			}				
			isValidated = false;
			alertMessage = "error.common.noEssentialData";				
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertType" : alertType
				, "alertCallbackFn" : alertCallbackFn 
				, "alertCallbackFnParam" : alertCallbackFnParam
			});
		} else {
			var CREDIT_AMT = $("#txtCREDIT_AMT").val();
			var CASH_AMT = $("#txtCASH_AMT").val();
			var GRNT_AMT = $("#txtGRNT_AMT").val();
			
			if(CREDIT_AMT != '0' || CASH_AMT != '0' || GRNT_AMT != '0'){
				if(erpPopupGrid.getRowsNum() == 0){
					$erp.alertMessage({
						"alertMessage" : "보증금액이 입력된 란이 있을경우<br>반드시 증빙자료를 첨부해야 합니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
				}
			}else {
				var paramMap = {
						 "CREDIT_AMT" : $("#txtCREDIT_AMT").val().replaceAll(",","")
						, "CASH_AMT" : $("#txtCASH_AMT").val().replaceAll(",","")
						, "GRNT_AMT" : $("#txtGRNT_AMT").val().replaceAll(",","")
						, "IO_TYPE" : cmbIO_TYPE.getSelectedValue()
						, "USE_YN" : cmbUSE_YN.getSelectedValue()
						, "LOCK_FLAG" : "N"
						, "LOAN_APPLY_TYPE" : loan_apply_type
						, "POPUP_TYPE" : erpPopupType
						, "LOAN_SEQ" : 1
						, "ORGN_CD" : $("#txtORGN_CD").val()
				}
				
				if("${paramMap.LOAN_CD}" == ""){
					paramMap["FILE_GRUP_NO"] = $("#txtFILE_GRUP_NO").val();
				} else {
					paramMap["FILE_GRUP_NO"] = '${paramMap.FILE_GRUP_NO}';
				}
				
				console.log(paramMap);
			}
		}
	}
	
	function saveAddLoan() {
		var isValidated = true;
		var alertType = "error";
		var resultObj = $erp.getElementEssentialEmpty("tb_erp_table");
		var infoMessage = '<spring:message code="info.common.essentialItem" />';
		if(resultObj){
			alertCallbackFnParam = {"obj" : resultObj, "message" : infoMessage};
			alertCallbackFn = function(param){
				$erp.initDhtmlXPopupDom(param.obj, param.message);
			}				
			isValidated = false;
			alertMessage = "error.common.noEssentialData";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertType" : alertType
				, "alertCallbackFn" : alertCallbackFn 
				, "alertCallbackFnParam" : alertCallbackFnParam
			});
		} else {
			var apply_obj_cd = "";
			if(loan_apply_type == "C") {
				apply_obj_cd = $("#txtCUSTMR_CD").val();
			} else {
				apply_obj_cd = $("#txtMEM_NO").val();
			}
			
			var CREDIT_AMT = $("#txtCREDIT_AMT").val();
			var CASH_AMT = $("#txtCASH_AMT").val();
			var GRNT_AMT = $("#txtGRNT_AMT").val();
			
			if(CREDIT_AMT != '0' || CASH_AMT != '0' || GRNT_AMT != '0'){
				if(erpPopupGrid.getRowsNum() == 0){
					$erp.alertMessage({
						"alertMessage" : "보증금액이 입력된 란이 있을경우<br>반드시 증빙자료를 첨부해야 합니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
				} else {
					saveLoanInfo(apply_obj_cd);
				}
			} else {
				saveLoanInfo(apply_obj_cd);
			}
			
		}
	}
	
	function saveLoanInfo(apply_obj_cd){
		var CREDIT_AMT = $("#txtCREDIT_AMT").val();
		var CASH_AMT = $("#txtCASH_AMT").val();
		var GRNT_AMT = $("#txtGRNT_AMT").val();
		var LOAN_AMT = $("#txtLOAN_AMT").val();
		var BAL_AMT = $("#txtBAL_AMT").val();
		var INDE_AMT = $("#txtINDE_AMT").val();
		var paramData = {};
		paramData["FILE_GRUP_NO"] = $("#txtFILE_GRUP_NO").val();
		paramData["OBJ_CD"] = apply_obj_cd;
		paramData["POPUP_TYPE"] = erpPopupType;
		paramData["LOAN_SEQ"] = 1;
		paramData["CREDIT_AMT"] = CREDIT_AMT.replaceAll(",","");
		paramData["CASH_AMT"] = CASH_AMT.replaceAll(",","");
		paramData["GRNT_AMT"] = GRNT_AMT.replaceAll(",","");
		paramData["LOAN_AMT"] = LOAN_AMT.replaceAll(",","");
		paramData["BAL_AMT"] = BAL_AMT.replaceAll(",","");
		paramData["INDE_AMT"] = INDE_AMT.replaceAll(",","");
		paramData["IO_TYPE"] = cmbIO_TYPE.getSelectedValue();
		paramData["USE_YN"] = cmbUSE_YN.getSelectedValue();
		paramData["LOCK_FLAG"] = cmbLOCK_FLAG.getSelectedValue();
		paramData["LOAN_APPLY_TYPE"] = loan_apply_type;
		paramData["ORGN_CD"] = '${paramMap.ORGN_CD}';
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/price/saveLoanFromPopup.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var resultCnt = data.ResultCnt;
					if(resultCnt > 0){
						$erp.alertMessage({
							"alertMessage" : "성공적으로 저장되었습니다.",
							"alertType" : "alert",
							"alertCallbackFn" : function() {
// 								var openPopupWindow = parent.erpPopupWindows.window("openAddNewLoanPopup");
// 								openPopupWindow.close();
								console.log("#####");
								if(!$erp.isEmpty(window["erpPopupNewSaveLoanData"]) && typeof window["erpPopupNewSaveLoanData"] === 'function'){
									erpPopupNewSaveLoanData();
								}
							},
							"isAjax" : false
						});
					}else {
						$erp.alertMessage({
							"alertMessage" : "저장에 실패했습니다.<br>다시 시도해주세요.",
							"alertType" : "alert",
							"isAjax" : false
						});
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function updateLoanInfo(){
		var isValidated = true;
		var alertType = "error";
		var resultObj = $erp.getElementEssentialEmpty("tb_erp_table");
		
		var infoMessage = '<spring:message code="info.common.essentialItem" />';
		if(resultObj){
			alertCallbackFnParam = {"obj" : resultObj, "message" : infoMessage};
			alertCallbackFn = function(param){
				$erp.initDhtmlXPopupDom(param.obj, param.message);
			}				
			isValidated = false;
			alertMessage = "error.common.noEssentialData";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertType" : alertType
				, "alertCallbackFn" : alertCallbackFn 
				, "alertCallbackFnParam" : alertCallbackFnParam
			});
		} else {
			var CREDIT_AMT = $("#txtCREDIT_AMT").val();
			var CASH_AMT = $("#txtCASH_AMT").val();
			var GRNT_AMT = $("#txtGRNT_AMT").val();
			
			if(CREDIT_AMT != '0' || CASH_AMT != '0' || GRNT_AMT != '0'){
				if(erpPopupGrid.getRowsNum() == 0){
					$erp.alertMessage({
						"alertMessage" : "보증금액이 입력된 란이 있을경우<br>반드시 증빙자료를 첨부해야 합니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
				} else {
					saveUpdateLoanInfo();
				}
			} else {
				saveUpdateLoanInfo();
			}
			
		}
	}
	
	function saveUpdateLoanInfo(){
		var tableMap = $erp.dataSerialize("tb_erp_table");
		tableMap["CRUD"] = "U";
		tableMap["LOAN_APPLY_TYPE"] = loan_apply_type;
		console.log(tableMap);
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/price/saveLoanInfoList.do"
			,data : tableMap
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertMessage({
						"alertMessage" : "성공적으로 저장되었습니다.",
						"alertCode" : null,
						"alertType" : "alert",
// 						"alertCallbackFn" : ,
						"isAjax" : false
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	String.prototype.replaceAll = function(value, separator){
		return this.split(value).join(separator);
	}
	
	function openSearchCustmrGridPopup(){
		var custmr_list = [];
		var pur_sale_type = "2"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		
		var onRowSelect = function(id, ind) {
			$("#txtCUSTMR_CD").val(this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue());
			$("#txtCUSTMR_NM").val(this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue());
			
			custmr_list.push($("#txtCUSTMR_CD").val());
			
			jQuery.ajaxSettings.traditional = true;
			$.ajax({
				url : "/sis/price/CdValidationCheck.do"
				,data : {
					"CD_LIST" : custmr_list
					, "SEARCH_TYPE" : loan_apply_type
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						var gridDataList = data.gridDataList;
						if(gridDataList[0]["resultMessage"] == "사용불가"){
							$erp.alertMessage({
								"alertMessage" : "다른여신에 이미 등록된 거래처입니다.",
								"alertType" : "alert",
								"alertCallbackFn" : function(){
									$("#txtCUSTMR_CD").val("");
									$("#txtCUSTMR_NM").val("");
								},
								"isAjax" : false
							});
						}
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
			
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type, null);
	}
	
	function openSearchMemberGridPopup(){
		var member_list = [];
		var paramMap = {
				"ORGN_DIV_CD" : '${paramMap.ORGN_DIV_CD}'
				, "ORGN_CD" : '${paramMap.ORGN_CD}'
		}
		var onRowDblClicked = function(id) {
			
			$("#txtMEM_NM").val(this.cells(id, this.getColIndexById("MEM_NM")).getValue());
			$("#txtMEM_NO").val(this.cells(id, this.getColIndexById("MEM_NO")).getValue());
			$("#txtORGN_CD").val(this.cells(id, this.getColIndexById("ORGN_CD")).getValue());
			
			member_list.push($("#txtORGN_CD").val() + '_' + $("#txtMEM_NO").val());
			
			jQuery.ajaxSettings.traditional = true;
			$.ajax({
				url : "/sis/price/CdValidationCheck.do"
				,data : {
					"CD_LIST" : member_list
					, "SEARCH_TYPE" : loan_apply_type
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						var gridDataList = data.gridDataList;
						if(gridDataList[0]["resultMessage"] == "사용불가"){
							$erp.alertMessage({
								"alertMessage" : "다른여신에 이미 등록된 회원입니다.",
								"alertType" : "alert",
								"alertCallbackFn" : function(){
									$("#txtMEM_NO").val("");
									$("#txtMEM_NM").val("");
									$("#txtORGN_CD").val("");
								},
								"isAjax" : false
							});
						}
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
			
			$erp.closePopup2("openSearchMemberGridPopup");
		}
		
		$erp.openSearchMemberGridPopup(onRowDblClicked, null, paramMap);
	}
	
	
	
	function initDhtmlXCombo(){
		cmbIO_TYPE = $erp.getDhtmlXComboCommonCode('cmbIO_TYPE', 'IO_TYPE','IO_TYPE', 120, "--선택--", false, "I03", function(){
			cmbIO_TYPE.attachEvent("onChange", function(value, text){
				if(cmbIO_TYPE.getSelectedValue() == "I03" || cmbIO_TYPE.getSelectedValue() == "D02"){
					$("#txtINDE_AMT").prop("disabled", true);
					$("#txtINDE_AMT").val("0");
					$("#txtINDE_AMT").attr('class', 'input_common');
					$("#txtCREDIT_AMT").attr('class', 'input_number input_money input_essential');
					$("#txtCREDIT_AMT").prop("disabled", false);
					$("#txtCASH_AMT").attr('class', 'input_number input_money input_essential');
					$("#txtCASH_AMT").prop("disabled", false);
					$("#txtGRNT_AMT").attr('class', 'input_number input_money input_essential');
					$("#txtGRNT_AMT").prop("disabled", false);
				}else {
					$("#txtINDE_AMT").prop("disabled", false);
					$("#txtINDE_AMT").attr('class', 'input_essential');
					$("#txtCREDIT_AMT").attr('class', 'input_number input_money');
					$("#txtCREDIT_AMT").prop("disabled", true);
					$("#txtCASH_AMT").attr('class', 'input_number input_money');
					$("#txtCASH_AMT").prop("disabled", true);
					$("#txtGRNT_AMT").attr('class', 'input_number input_money');
					$("#txtGRNT_AMT").prop("disabled", true);
				}
			});
		});
		cmbUSE_YN = $erp.getDhtmlXComboCommonCode('cmbUSE_YN', 'USE_YN',['USE_CD', 'YN'], 120, "--선택--", false, "Y");
		
		if(erpPopupType != 'new'){
			cmbLOCK_FLAG = $erp.getDhtmlXComboCommonCode('cmbLOCK_FLAG', 'LOCK_FLAG',['USE_CD', 'YN'], 120, "--선택--", false, "N");
		}
	}
	
	function indeCheck() {
		if(cmbIO_TYPE.getSelectedValue() == "I03" || cmbIO_TYPE.getSelectedValue() == "D02"){
			$("#txtINDE_AMT").prop("disabled", true);
			$("#txtINDE_AMT").val("0");
			$("#txtINDE_AMT").attr('class', 'input_common');
			$("#txtCREDIT_AMT").attr('class', 'input_number input_money input_essential');
			$("#txtCREDIT_AMT").prop("disabled", false);
			$("#txtCASH_AMT").attr('class', 'input_number input_money input_essential');
			$("#txtCASH_AMT").prop("disabled", false);
			$("#txtGRNT_AMT").attr('class', 'input_number input_money input_essential');
			$("#txtGRNT_AMT").prop("disabled", false);
		}else {
			$("#txtINDE_AMT").prop("disabled", false);
			$("#txtINDE_AMT").attr('class', 'input_essential');
			$("#txtCREDIT_AMT").attr('class', 'input_number input_money');
			$("#txtCREDIT_AMT").prop("disabled", true);
			$("#txtCASH_AMT").attr('class', 'input_number input_money');
			$("#txtCASH_AMT").prop("disabled", true);
			$("#txtGRNT_AMT").attr('class', 'input_number input_money');
			$("#txtGRNT_AMT").prop("disabled", true);
		}		
	}
	
	function numberWithCommas(x, type) {
		x = x.replace(/[^0-9]/g,'');   // 입력값이 숫자가 아니면 공백
		x = x.replace(/,/g,'');          // ,값 공백처리
		if(type == "credit"){
			$("#txtCREDIT_AMT").val(x.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); 
		} else if(type == "cash"){
			$("#txtCASH_AMT").val(x.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); 
		} else if(type == "grnt") {
			$("#txtGRNT_AMT").val(x.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); 
		}
		
		var change_loan_check = Number(($("#txtCREDIT_AMT").val()).replace(/,/g,'')) + Number(($("#txtCASH_AMT").val()).replace(/,/g,'')) + Number(($("#txtGRNT_AMT").val()).replace(/,/g,''));
		console.log(erpPopupType);
		if(erpPopupType != "add"){
			if(change_loan_check >= org_loan_amt){
				cmbIO_TYPE.setComboValue("I03");
			}else {
				cmbIO_TYPE.setComboValue("D02");
			}
		}
	}
	
	function numberTypeCheck(y){
		var selected_cmbIO_TYPE = cmbIO_TYPE.getSelectedValue();
		console.log(selected_cmbIO_TYPE);
		if(y<0){
			if(selected_cmbIO_TYPE == "I04"){
				cmbIO_TYPE.setComboValue("D03");
			}else if(selected_cmbIO_TYPE == "I03") {
				cmbIO_TYPE.setComboValue("D02");
			}else if(selected_cmbIO_TYPE == "I05") {
				cmbIO_TYPE.setComboValue("D01");
			}else if(selected_cmbIO_TYPE == "I01"){
				cmbIO_TYPE.setComboValue("D03");
			}else if(selected_cmbIO_TYPE == "I02"){
				cmbIO_TYPE.setComboValue("D03");
			}
		} else {
			if(selected_cmbIO_TYPE == "D01"){
				cmbIO_TYPE.setComboValue("I05");
			}else if(selected_cmbIO_TYPE == "D02") {
				cmbIO_TYPE.setComboValue("I03");
			}else if(selected_cmbIO_TYPE == "D03") {
				cmbIO_TYPE.setComboValue("I04");
			}
		}
	}
	
</script>
</head>
<body>
	<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_popup_info" class="samyang_div" style="display:none">
		<table id="tb_erp_table" class="tb_erp_common">
			<colgroup>
				<col width="120px"/>
				<col width="120px"/>
				<col width="120px"/>
				<col width="120px"/>
				<col width="120px"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<td colspan ="6"></td>
			</tr>
			<tr>
				<th>여신코드</th>
				<td colspan="5">
					<input type="text" id="txtLOAN_CD" disabled="disabled" class="input_common" style="width : 150px;">
					<input type="hidden" id="txtFILE_GRUP_NO">
					<input type="hidden" id="txtLOAN_SEQ">
				</td>
			</tr>
			<tr>
				<th>거래처</th>
				<th>회  원</th>
				<td colspan="3">
					<input type="hidden" id="txtCUSTMR_CD">
					<input type="text" id="txtCUSTMR_NM" class="input_essential" readonly="readonly" style="width: 230px;">
					<input type="button" id="btnSEARCH_CUSTMR" class="input_common_button" value="검색" onclick="openSearchCustmrGridPopup()">
					<input type="hidden" id="txtMEM_NO">
					<input type="hidden" id="txtORGN_CD">
					<input type="text" id="txtMEM_NM" class="input_essential" readonly="readonly" style="width: 230px;">
					<input type="button" id="btnSEARCH_MEMBER" class="input_common_button" value="검색" onclick="openSearchMemberGridPopup()">
				</td>
			</tr>
			<tr>
				<td colspan ="6"></td>
			</tr>
			<tr>
				<th>임의조정금액</th>
				<td><input type="number" id="txtINDE_AMT" class="input_common" style="width: 100px;" value="0" onkeyup="numberTypeCheck(this.value)"></td>
				<th>잔액</th>
				<td>
					<input type="text"  id="txtBAL_AMT" class="input_number input_money" style="width: 100px;"  value="0" disabled>
				</td>
				<th>여신한도</th>
				<td>
					<input type="text" id="txtLOAN_AMT" class="input_number input_money" style="width: 100px;"   value="0" disabled>
				</td>
			</tr>
			<tr>
				<th>신용보증</th>
				<td>
					<input type="text" id="txtCREDIT_AMT" class="input_number input_money input_essential" onkeyup="numberWithCommas(this.value, 'credit')" style="width: 100px;" value="0">
				</td>
				<th>현금보증</th>
				<td>
					<input type="text" id="txtCASH_AMT" class="input_number input_money input_essential" onkeyup="numberWithCommas(this.value, 'cash')" style="width: 100px;" value="0">
				</td>
				<th>보증증권</th>
				<td>
					<input type="text" id="txtGRNT_AMT" class="input_number input_money input_essential" onkeyup="numberWithCommas(this.value, 'grnt')"style="width: 100px;" value="0">
				</td>
			</tr>
			<tr>
				<th>입출납유형</th>
				<td>
					<div id="cmbIO_TYPE" class="combo_essential"></div>
				</td>
				<th>사용여부</th>
				<td>
					<div id="cmbUSE_YN" class="combo_essential"></div>
				</td>
				<th>수정가능여부</th>
				<td>
					<div id="cmbLOCK_FLAG" class="combo_essential"></div>
				</td>
			</tr>
			<tr>
				<td colspan ="6"></td>
			</tr>
		</table>
	</div>
	<div id="div_erp_popup_upload_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_popup_upload_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>