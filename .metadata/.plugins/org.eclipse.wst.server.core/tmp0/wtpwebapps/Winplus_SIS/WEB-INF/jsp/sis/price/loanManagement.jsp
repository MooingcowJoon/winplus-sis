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
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	
	var erpLayout;
	var erpRibbon;
	var erpGridColumns;
	var erpGrid;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var select_radio_val = "MEM";
	var AUTHOR_CD = "${screenDto.author_cd}";
	var erpGridDataProcessor;
	var upload_rId;
	var select_loan_cd;
	var select_loan_seq;
	var select_loan_obj;
	var use_loan_cd;
	var show_condition;
	var new_loan_cnt = 0;
	var orgn_div_cd = "";
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		radio_check();
		initErpGrid();
		
		if("${menuDto.menu_cd}" == "00548"){
			LUI.exclude_auth_cd = "All,1,2,5,6";
			LUI.exclude_orgn_type = "MK";
			isValidPage = true;
			initDhtmlXCombo();
		}else if("${menuDto.menu_cd}" == "00720"){
			LUI.exclude_auth_cd = "All,1,2,3,4";
			LUI.exclude_orgn_type = "OT";
			isValidPage = true;
			initDhtmlXCombo();
		}else{
			isValidPage = false;
			initDhtmlXCombo();
		}
		
		if(!isValidPage){
			$erp.alertMessage({
				"alertMessage" : "메뉴명이 변경되어 페이지가 제대로 작동하지 않을 수 있습니다. 소스코드를 확인해주세요.",
				"alertCode" : null,
				"alertType" : "error",
				"isAjax" : false
			});
		}
		
		$erp.asyncObjAllOnCreated(function(){
			if(cmbORGN_DIV_CD.getSelectedValue() == 'B01'){
				cmbORGN_CD.disable();
				$("#custmr_type").css("display", "block");
				$("#mem_type").css("display", "none");
				$('#SEARCH_MEM').prop('checked', false);
				$('#SEARCH_CUSTMR').prop('checked', true);
				radio_check();
			} else {
				//cmbORGN_CD.enable();
				if(cmbORGN_CD.getSelectedValue() == '100024'){
					$("#custmr_type").css("display", "block");
					$("#mem_type").css("display", "none");
					$('#SEARCH_MEM').prop('checked', false);
					$('#SEARCH_CUSTMR').prop('checked', true);
				} else {
					$("#custmr_type").css("display", "none");
					$("#mem_type").css("display", "block");
					$('#SEARCH_MEM').prop('checked', true);
					$('#SEARCH_CUSTMR').prop('checked', false);
				}
				radio_check();
			}
			
			numberWithCommas($("#LOAN_START").val(),"start");
			numberWithCommas($("#LOAN_END").val(),"end");
			
			btn_show_hide();
		});
	});
	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false, fix_size:[true, true]}
				, {id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드영역", header:false, fix_size:[true, true]}
			]	
		});
		
		erpLayout.cells("a").attachObject("div_erp_search");
		erpLayout.cells("a").setHeight(120);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
		});
	}
	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					 {id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					, {id : "add_custmr_erpGrid", type : "button", text:'신규여신(고객사)추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true, disable : true}
					, {id : "add_mem_erpGrid", type : "button", text:'신규여신(회원)추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true, disable : true}
					, {id : "add_reuse_erpGrid", type : "button", text:'기존여신고객추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true, disable : true}
					, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					//, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}							
			]
		});
	
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchValidationCheck();
			}else if (itemId == "save_erpGrid"){
				saveErpGrid();
			}else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
			}else if (itemId == "add_custmr_erpGrid"){
				$erp.openAddNewLoanPopup({"popupType" : "add", "loanType" : "C"});
			}else if (itemId == "add_mem_erpGrid"){
				$erp.openAddNewLoanPopup({"popupType" : "add", "loanType" : "M", "ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue(), "ORGN_CD" : cmbORGN_CD.getSelectedValue()});
			}else if (itemId == "add_reuse_erpGrid"){
				var checked_row = erpGrid.getCheckedRows(erpGrid.getColIndexById("SELECT"));
				console.log(checked_row);
				if(checked_row == "") {
					$erp.alertMessage({
						"alertMessage" : "추가 할 여신을 선택 후 이용가능합니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
				} else {
					addReUseLoan(erpGrid.cells(checked_row, erpGrid.getColIndexById("LOAN_CD")).getValue());
				}
				
			}
		});
	 }
	
	function initErpGrid(){
		erpGridColumns = [
			    {id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}
			  ,{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false} 	
			  , {id : "SELECT", label : ["선택", "#rspan"], type : "ra", width : "35", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			  , {id : "LOAN_GROUP", label:["여신구분", "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}              
			  , {id : "LOAN_CD", label:["여신코드", "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}              
			  , {id : "LOAN_SEQ", label:["순번", "#rspan"], type: "ro", width: "40", sort : "str", align : "center", isHidden : false, isEssential : false}              
			  , {id : "OBJ_NM", label:["고객명", "#text_filter"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : true}              
			  , {id : "OBJ_CD", label:["고객코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : true}              
			  , {id : "INDE_AMT", label:["증감금액", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}              
			  , {id : "BAL_AMT", label:["잔액", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}              
			  , {id : "LOAN_AMT", label:["여신한도", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}   
			  , {id : "TRUST_CNT", label:["외상횟수", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}              
			  , {id : "TRUST_LIMIT", label:["외상회수제한", "#rspan"], type: "ro", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}              
			  , {id : "CREDIT_AMT", label:["신용보증", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}              
			  , {id : "CASH_AMT", label:["현금보증", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}              
			  , {id : "GRNT_AMT", label:["보증증권", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}              
			  , {id : "IO_TYPE", label:["입출납유형", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "IO_TYPE"}              
			  , {id : "LOAN_APPLY_TYPE", label:["적용대상", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : "LOAN_APPLY_TYPE"}              
			  , {id : "EVI_FILE_NM", label:["증빙자료명", "#rspan"], type: "ro", width: "150", sort : "str", align : "center", isHidden : true, isEssential : false}              
// 			  , {id : "EVI_FILE_PATH", label:["증빙파일경로", "#rspan"], type: "ro", width: "150", sort : "str", align : "center", isHidden : false, isEssential : false}        
			  , {id : "USE_YN", label:["사용여부", "#rspan"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isDisable : true, isEssential : false, commonCode : ["USE_CD", "YN"]}          
			  , {id : "LOCK_FLAG", label:["수정가능여부", "#rspan"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isDisable : true, isEssential : false, commonCode : ["USE_CD", "YN"]}          
			  , {id : "CUSER", label:["생성자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}              
			  , {id : "CDATE", label:["생성일시", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}              
			  , {id : "MUSER", label:["수정자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}              
			  , {id : "MDATE", label:["수정일시", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}              
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH	
			, columns : erpGridColumns
		});
		
		erpGridDataProcessor = $erp.initGrid(erpGrid, {useAutoAddRowPaste : true, deleteDuplication : false, editableColumnIdListOfInsertedRows : ["OBJ_CD"], notEditableColumnIdListOfInsertedRows : []})
		
		erpGrid.attachEvent("onEndPaste", function(result){   //엑셀붙여넣기시 자동으로 행추가
			var search_type = erpGrid.cells(erpGrid.getSelectedRowId(), erpGrid.getColIndexById("LOAN_APPLY_TYPE")).getValue();
			if(search_type == 'C'){
				var custmr_list = [];
				var rId_list = [];
				for(var custmr_cd in result.standardColumnValue_indexAndRowId_obj){
					custmr_list.push(custmr_cd);
					rId_list.push(result.standardColumnValue_indexAndRowId_obj[custmr_cd][1]);
				}
				getCustmrNmList(custmr_list, rId_list);
			} else if(search_type == 'M'){
				var mem_list = [];
				var mem_rId_list = [];
				for(var mem_no in result.standardColumnValue_indexAndRowId_obj){
					mem_list.push(mem_no);
					mem_rId_list.push(result.standardColumnValue_indexAndRowId_obj[mem_no][1]);
				}
				getMemberNmList(mem_list, mem_rId_list);
			}
	    });
		
		erpGrid.attachEvent("onRowSelect", function(rId, Ind){
			erpGrid.cells(rId, erpGrid.getColIndexById("SELECT")).setValue("1");
			var col_ID = erpGrid.getColumnId(Ind);
			if(col_ID == "EVI_FILE_NM") {
				upload_rId = rId;
				uploadEviFile();
			}
		});
		
		erpGrid.attachEvent("onRowDblClicked", function(rId, Ind){
			erpGrid.cells(rId, erpGrid.getColIndexById("SELECT")).setValue("1");
			if($("input[name='Show_Condition']:checked").val() == "NEW"){
				updateLoanInfo();
			} else {
				$erp.alertMessage({
					"alertMessage" : "상세정보수정은 최근정보 보기에서 가능합니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false
				});
			}
		});
		
		erpGrid.attachEvent("onCheckbox", function(rId, cInd, state){
			erpGrid.selectRowById(rId);
		});
		
		//groupBy
		erpGrid.attachEvent("onPageChangeCompleted", function(){
			if($("input[name='Show_Condition']:checked").val() == "ALL"){
				erpLayout.progressOn();
				setTimeout(function(){
					gridGroupBy();
					erpLayout.progressOff();
				}, 10);
			}
		});
	 }
	
	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpGrid.setCSVDelimiter("\t");
			erpGrid.copyBlockToClipboard()
		}
		if(code==86&&ctrl){
			erpGrid.setCSVDelimiter("\t");
			erpGrid.pasteBlockFromClipboard()
		}
		return true;
	}
	
	function getCustmrNmList(custmr_cd_list, rId_list){
		erpLayout.progressOn();
		jQuery.ajaxSettings.traditional = true;
		$.ajax({
			url : "/sis/price/getCustmrNmList.do"
			,data : {
				"CUSTMR_CD_LIST" : custmr_cd_list
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var gridDataList = data.gridDataList;
					for(var j = 0 ; j < gridDataList.length ; j++) {
	 					erpGrid.cells(rId_list[j], erpGrid.getColIndexById("OBJ_NM")).setValue(gridDataList[j].CUSTMR_NM);
	 					erpGrid.cells(rId_list[j], erpGrid.getColIndexById("OBJ_CD")).setValue(gridDataList[j].CUSTMR_CD);
	 					erpGrid.cells(rId_list[j], erpGrid.getColIndexById("LOAN_APPLY_TYPE")).setValue("C");
	 					erpGrid.cells(rId_list[j], erpGrid.getColIndexById("LOAN_CD")).setValue(use_loan_cd);
	 					if(gridDataList[j].CUSTMR_CD == "사용불가"){
	 						erpGrid.cells(rId_list[j], erpGrid.getColIndexById("OBJ_CD")).setBgColor('pink');
	 					} else {
	 						erpGrid.cells(rId_list[j], erpGrid.getColIndexById("OBJ_CD")).setBgColor('#fdfdfd');
	 					}
	 					
					}
					erpGrid.selectRow(erpGrid.getRowIndex(rId_list[gridDataList.length-1]));
				}
				erpLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function getMemberNmList(mem_cd_list, mem_rId_list){
		jQuery.ajaxSettings.traditional = true;
		$.ajax({
			url : "/sis/price/getMemberNmList.do"
			,data : {
				"MEMBER_NO_LIST" : mem_cd_list
				, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var gridDataList = data.gridDataList;
					for(var j = 0 ; j < gridDataList.length ; j++) {
	 					erpGrid.cells(mem_rId_list[j], erpGrid.getColIndexById("OBJ_NM")).setValue(gridDataList[j].MEM_NM);
	 					erpGrid.cells(mem_rId_list[j], erpGrid.getColIndexById("OBJ_CD")).setValue(gridDataList[j].OBJ_CD);
	 					erpGrid.cells(mem_rId_list[j], erpGrid.getColIndexById("LOAN_APPLY_TYPE")).setValue("M");
	 					erpGrid.cells(mem_rId_list[j], erpGrid.getColIndexById("LOAN_CD")).setValue(use_loan_cd);
	 					
	 					if(gridDataList[j].OBJ_CD == "사용불가"){
	 						erpGrid.cells(mem_rId_list[j], erpGrid.getColIndexById("OBJ_NM")).setBgColor('pink');
	 						erpGrid.cells(mem_rId_list[j], erpGrid.getColIndexById("OBJ_CD")).setBgColor('pink');
	 					} else {
	 						erpGrid.cells(mem_rId_list[j], erpGrid.getColIndexById("OBJ_NM")).setBgColor('#fdfdfd');
	 						erpGrid.cells(mem_rId_list[j], erpGrid.getColIndexById("OBJ_CD")).setBgColor('#fdfdfd');
	 					}
	 					
	 					if(gridDataList[j].MEM_NM == "미등록회원"){
	 						erpGrid.cells(mem_rId_list[j], erpGrid.getColIndexById("OBJ_NM")).setBgColor('pink');
	 						erpGrid.cells(mem_rId_list[j], erpGrid.getColIndexById("OBJ_CD")).setBgColor('pink');
	 					} else {
	 						erpGrid.cells(mem_rId_list[j], erpGrid.getColIndexById("OBJ_NM")).setBgColor('#fdfdfd');
	 						erpGrid.cells(mem_rId_list[j], erpGrid.getColIndexById("OBJ_CD")).setBgColor('#fdfdfd');
	 					}
					}
					erpGrid.selectRow(erpGrid.getRowIndex(mem_rId_list[gridDataList.length-1]));
				}
				erpLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function searchValidationCheck(){
		var show_condition = $(":input:radio[name=Show_Condition]:checked").val();
		var paramData = {
			"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
			, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
			, "SHOW_CONDITION" : show_condition
			, "SearchDateFrom" : $("#searchDateFrom").val()
			, "SearchDateTo" : $("#searchDateTo").val()
			, "LOAN_START" : $("#LOAN_START").val()
			, "LOAN_END" : $("#LOAN_END").val()
			, "SEARCH_CODITION" : false
			, "SEARCH_TYPE" : select_radio_val
			, "SEARCH_CUSTMR" : $("#txtCUSTMR_NAME").val()
			, "SEARCH_CUSTMR_CD" : $("#txtCUSTMR_CD").val()
			, "MEM_ORGN_CD" : $("#txtMEM_ORGN_CD").val()
			, "SEARCH_MEM" : $("#txtMEM_NAME").val()
			, "SEARCH_MEM_NO" : $("#txtMEM_NO").val()
		}
		console.log(paramData);
		searchErpGrid(paramData);
	}
	
	function searchErpGrid(param){
		console.log(param);
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/price/getMemberLoanList.do"
			,data : param
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				$erp.clearDhtmlXGrid(erpGrid);
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							,  '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpGrid.parse(gridDataList, 'js');
						if($("input[name='Show_Condition']:checked").val() == "ALL"){
							gridGroupBy();
						}
					}
					erpLayout.progressOff();
					$erp.setDhtmlXGridFooterRowCount(erpGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function gridGroupBy(){
		erpGrid.groupBy(erpGrid.getColIndexById("LOAN_CD"),["#title","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan"]);
	}
	
	function deleteErpGrid(){
		$erp.confirmMessage({
			"alertMessage" : "선택한 여신정보를 정말 삭제하시겠습니까?",
			"alertCode" : null,
			"alertType" : "alert",
			"alertCallbackFn" : function() {
				var delete_check_rIds = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
				var delete_check_list = delete_check_rIds.split(",");
				
				if(delete_check_list.length == 0){
					$erp.alertMessage({
						"alertMessage" : "error.common.noSelectedRow"
						, "alertCode" : null
						, "alertType" : "error"
					});
					return;
				}
				
				for(var i = 0; i < delete_check_list.length; i++){
					erpGrid.deleteRow(delete_check_list[i]);
				}
				
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
				saveErpGrid();
			},
			"isAjax" : false
		});
	}
	
	function leadingZeros(n, digits) {
		var zero = '';
		n = n.toString();
		
		if (n.length < digits) {
		  for (var i = 0; i < digits - n.length; i++)
		    zero += '0';
		}
		return zero + n;
	}
	
	function updateLoanInfo(){
		var selected_rId = erpGrid.getCheckedRows(erpGrid.getColIndexById("SELECT"));
		use_loan_cd = erpGrid.cells(selected_rId, erpGrid.getColIndexById("LOAN_CD")).getValue();
		use_loan_seq = erpGrid.cells(selected_rId, erpGrid.getColIndexById("LOAN_SEQ")).getValue();
		
		var loan_apply_type = erpGrid.cells(selected_rId, erpGrid.getColIndexById("LOAN_APPLY_TYPE")).getValue();
		var open_param_map = {
								"popupType" : "update"
								, "loanType" : loan_apply_type
								, "LOAN_CD" : use_loan_cd
								, "LOAN_SEQ" : use_loan_seq
								, "screen" : "${screenDto.scrin_nm}"
							  }
		
		if(loan_apply_type == "C"){
			open_param_map["CUSTMR_CD"] = erpGrid.cells(selected_rId, erpGrid.getColIndexById("OBJ_CD")).getValue();
			open_param_map["CUSTMR_NM"] = erpGrid.cells(selected_rId, erpGrid.getColIndexById("OBJ_NM")).getValue();
		} else {
			var m_obj_nm = erpGrid.cells(selected_rId, erpGrid.getColIndexById("OBJ_CD")).getValue();
			m_obj_nm = m_obj_nm.split("_")[1];
			console.log(m_obj_nm);
			open_param_map["MEM_NO"] = m_obj_nm;
			open_param_map["MEM_NM"] = erpGrid.cells(selected_rId, erpGrid.getColIndexById("OBJ_NM")).getValue();
		}
		
		if(cmbORGN_DIV_CD.getSelectedValue() != "B01"){
			open_param_map["ORGN_DIV_CD"] = cmbORGN_DIV_CD.getSelectedValue();
			open_param_map["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		}
		
		var popupClose = function() {
			searchValidationCheck();
			$erp.closePopup2("openAddNewLoanPopup");
		}
		
		$erp.openAddNewLoanPopup(open_param_map, popupClose);
		
	}
	
	function addReUseLoan(selected_loan_cd){
		var add_type = selected_loan_cd.substr(0,1);
		
		if(add_type == "C"){
			var pur_sale_type = "2"; //협력사(매입처) == "1" 고객사(매출처) == "2"
					
			var onClickRibbonAddData = function(popupGrid){
				var checked_list = popupGrid.getCheckedRows(popupGrid.getColIndexById("CHECK")).split(',');
				var custmr_cd_list = [];
				
				for(var i = 0 ; i < checked_list.length ; i++){
					custmr_cd_list.push(popupGrid.cells(checked_list[i], popupGrid.getColIndexById("CUSTMR_CD")).getValue());
				}
				
				var win = erpPopupWindows.window("openSearchCustmrGridPopup");
				var popWin = win.getAttachedObject().contentWindow;
				validationCheckForAdd(custmr_cd_list, "C", selected_loan_cd, function(message, type, cd_list, loan_list){
					if(type == 1){
						popWin.alertMessage({
							"alertMessage" : message,
							"alertCode" : null,
							"alertType" : "alert",
							"isAjax" : false
						});
					}else if(type == 2){
						popWin.confirmMessage({
							"alertMessage" : message,
							"alertCode" : null,
							"alertType" : "alert",
							"alertCallbackFn" : function() {
								addLoanObj(cd_list, loan_list,"C");
							},
							"isAjax" : false
						});
					}
				}); 
	    	}
			
			$erp.searchCustmrPopup(null, pur_sale_type, onClickRibbonAddData);
		} else if(add_type == "M"){
			var addClickCheckList = function(popupGrid){
				var checked_list = popupGrid.getCheckedRows(popupGrid.getColIndexById("CHECK")).split(',');
				var mem_no_list = [];
				
				for(var i = 0 ; i < checked_list.length ; i++){
					mem_no_list.push(popupGrid.cells(checked_list[i], popupGrid.getColIndexById("OBJ_CD")).getValue());
				}
				
				
				var win = erpPopupWindows.window("openSearchMemberGridPopup");
				var popWin = win.getAttachedObject().contentWindow;
				validationCheckForAdd(mem_no_list, "M", selected_loan_cd, function(message, type, cd_list, loan_list){
					if(type == 1){
						popWin.alertMessage({
							"alertMessage" : message,
							"alertCode" : null,
							"alertType" : "alert",
							"isAjax" : false
						});
					}else if(type == 2){
						popWin.confirmMessage({
							"alertMessage" : message,
							"alertCode" : null,
							"alertType" : "alert",
							"alertCallbackFn" : function() {
								addLoanObj(cd_list, loan_list, "M");
							},
							"isAjax" : false
						});
					}
				}); 
			}
			
			$erp.openSearchMemberGridPopup(null, addClickCheckList, {"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue(), "ORGN_CD" : cmbORGN_CD.getSelectedValue()})
		}
	}
	
	function addLoanObj(cd_list, loan_list,type){
		console.log(cd_list);
		jQuery.ajaxSettings.traditional = true;
		$.ajax({
			url : "/sis/price/addLoanDetailObj.do"
			,data : {
				"cd_list" : cd_list
				, "loan_list" : loan_list
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				if(type == "C"){
					$erp.closePopup2("openSearchCustmrGridPopup");
				}else {
					$erp.closePopup2("openSearchMemberGridPopup");
				}
				
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					searchValidationCheck();
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function saveErpGrid(){
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);
		$.ajax({
			url : "/sis/price/saveLoanInfoList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertMessage({
						"alertMessage" : "성공적으로 저장되었습니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"alertCallbackFn" : searchValidationCheck(),
						"isAjax" : false
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function uploadEviFile(){
		select_loan_cd = erpGrid.cells(upload_rId, erpGrid.getColIndexById("LOAN_CD")).getValue();
		select_loan_seq = erpGrid.cells(upload_rId, erpGrid.getColIndexById("LOAN_SEQ")).getValue();
		select_loan_obj = erpGrid.cells(upload_rId, erpGrid.getColIndexById("OBJ_CD")).getValue();
		$("#EVI_FILE_UPLOAD").trigger("click");
	}
	
	function fileCheck(){
		var evi_file = event.target.files[0];
		
		var evi_file_path = $("#EVI_FILE_UPLOAD").val();
		var evi_file_name = evi_file_path.split("\\");
		evi_file_name = evi_file_name[evi_file_name.length - 1];
		
		if(evi_file_name != ""){
			$erp.confirmMessage({
				"alertMessage" : "선택하신 파일로 증빙자료를 등록하시겠습니까?",
				"alertCode" : null,
				"alertType" : "alert",
				"alertCallbackFn" : function() {
					erpGrid.cells(upload_rId, erpGrid.getColIndexById("EVI_FILE_NM")).setValue(evi_file_name);
					erpGrid.cells(upload_rId, erpGrid.getColIndexById("EVI_FILE_PATH")).setValue(evi_file_path);
					eviFIleUpload(evi_file);
				},
				"isAjax" : false
			});
		}
	}
	
	function eviFIleUpload(file){
		
		var fileValue = $("#EVI_FILE_UPLOAD").val().split("\\");
		var file_name = fileValue[fileValue.length-1];

		
		var formData = new FormData();
		formData.append("EviFile", file);
		formData.append("EviFileName", file_name);
		formData.append("LOAN_CD", select_loan_cd);
		formData.append("LOAN_SEQ", select_loan_seq);
		formData.append("DIRECTORY_KEY", "loan");
		
		if(file_name == "" || file_name == null || file_name == undefined || file_name == "undefined") {
			$erp.alertMessage({
				"alertMessage" : "파일이 선택되지 않았습니다.<br> 선택 후 다시 이용해주세요!",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		} else {
			erpLayout.progressOn();
			$.ajax({
				url : "/sis/price/uploadLoanEvidence.do"
				, method : "POST"
				, dataType : "JSON"
				, data : formData
				, processData: false
			    , contentType: false
				, success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						var SearchParam = {
							"ORGN_DIV_CD" : orgn_div_cd
							, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
							, "SHOW_CONDITION" : show_condition
							, "SearchDateFrom" : $("#searchDateFrom").val()
							, "SearchDateTo" : $("#searchDateTo").val()
							, "LOAN_START" : $("#LOAN_START").val()
							, "LOAN_END" : $("#LOAN_END").val()
							, "SEARCH_CODITION" : false
							, "SEARCH_TYPE" : select_radio_val
							, "SEARCH_CUSTMR" : $("#txtCUSTMR_NAME").val()
							, "SEARCH_CUSTMR_CD" : $("#txtCUSTMR_CD").val()
							, "MEM_ORGN_CD" : $("#txtMEM_ORGN_CD").val()
							, "SEARCH_MEM" : $("#txtMEM_NAME").val()
							, "SEARCH_MEM_NO" : $("#txtMEM_NO").val()
						}
						
						if(data.ResultNum == 1) {
							$erp.alertMessage({
								"alertMessage" : "여신증빙자료가 성공적으로 등록되었습니다.",
								"alertCode" : null,
								"alertType" : "alert",
								"alertCallbackFn" : searchErpGrid(SearchParam),
								"isAjax" : false
							});
						}
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
				
			});
		}
	}
	
	function initDhtmlXCombo(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
			if(cmbORGN_DIV_CD.getSelectedValue() == "B01"){ //센터일때만 모두조회 표시
	        	cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, LUI.LUI_orgn_cd);
		        cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
		            cmbORGN_CD.unSelectOption();
		            cmbORGN_CD.clearAll();
		            if(value == "B01"){ //센터일때만 모두조회 표시
		            	orgn_div_cd = value;
		            	$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
		            	$("#custmr_type").css("display", "block");
						$("#mem_type").css("display", "none");
						$('#SEARCH_MEM').prop('checked', false);
						$('#SEARCH_CUSTMR').prop('checked', true);
						radio_check();
		            	cmbORGN_CD.disable();
		            	var show_condition = $("input[name='Show_Condition']:checked").val();
		            	if(show_condition == "NEW"){
			            	erpRibbon.hide("add_mem_erpGrid");
			            	erpRibbon.show("add_custmr_erpGrid");
		            	}
		            } else {
		            	$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), null, false, null);
		            	cmbORGN_CD.attachEvent("onChange", function(value, text){
		            		if(cmbORGN_DIV_CD.getSelectedValue() != "B01"){
								if(value == "100024"){
									$("#custmr_type").css("display", "block");
									$("#mem_type").css("display", "none");
									$('#SEARCH_MEM').prop('checked', false);
									$('#SEARCH_CUSTMR').prop('checked', true);
					            	console.log($(":input:radio[name=SEARCH_RADIO]:checked").val());
									radio_check();
								}else {
									$("#custmr_type").css("display", "none");
									$("#mem_type").css("display", "block");
									$('#SEARCH_MEM').prop('checked', true);
									$('#SEARCH_CUSTMR').prop('checked', false);
					            	console.log($(":input:radio[name=SEARCH_RADIO]:checked").val());
									radio_check();
								}
		            		}
		            	});
		            	orgn_div_cd = value;
		            	cmbORGN_CD.enable();
		            	var show_condition = $("input[name='Show_Condition']:checked").val();
		            	if(show_condition == "NEW"){
			            	erpRibbon.hide("add_custmr_erpGrid");
			            	erpRibbon.show("add_mem_erpGrid");
		            	}
		            }
		         });
	        } else {
				cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, null, false, null);
		        cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
		            cmbORGN_CD.unSelectOption();
		            cmbORGN_CD.clearAll();
					radio_check();
		            $erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), null, false, null);
		        });
		        
	        }
	     });
	}
	
	function openSearchCustmrGridPopup(){
		var pur_sale_type = "2"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		
		var onRowSelect = function(id, ind) {
			$("#txtCUSTMR_CD").val(this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue());
			$("#txtCUSTMR_NAME").val(this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue());
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type, null);
	}
	
	function openSearchMemberGridPopup(){
		var paramMap = {
				"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
				, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
		}
		
		var onRowDblClicked = function(id) {
			$("#txtMEM_NAME").val(this.cells(id, this.getColIndexById("MEM_NM")).getValue());
			$("#txtMEM_NO").val(this.cells(id, this.getColIndexById("OBJ_CD")).getValue());
			$("#txtMEM_ORGN_CD").val(this.cells(id, this.getColIndexById("ORGN_CD")).getValue());
			$erp.closePopup2("openSearchMemberGridPopup");
		}
		
		$erp.openSearchMemberGridPopup(onRowDblClicked, null, paramMap);
	}
	
	function validationCheckForAdd(CD_LIST, search_type, selected_loan_cd, callback){
		jQuery.ajaxSettings.traditional = true;
		$.ajax({
			url : "/sis/price/CdValidationCheck.do"
			,data : {
				"CD_LIST" : CD_LIST
				,"SEARCH_TYPE" : search_type
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var gridDataList = data.gridDataList;
					console.log(gridDataList);
					var no_apply_cnt = 0;
					var no_apply_cd_list = [];
					var apply_cd_list = [];
					var loan_cd_list = [];
					for(var i = 0 ; i < gridDataList.length ; i++){
						if(gridDataList[i]["resultMessage"] == "사용불가"){
							no_apply_cnt += 1;
							no_apply_cd_list.push(gridDataList[i]["OBJ_CD"]);
						} else {
							apply_cd_list.push(gridDataList[i]["OBJ_CD"]);
							loan_cd_list.push(selected_loan_cd);
						}
					}
					
					var paramMapInfo = {"no_apply_cd_list" : no_apply_cd_list , "apply_cd_list" : apply_cd_list};
					
					if(no_apply_cnt == gridDataList.length){
						callback("이미 여신등록된 고객으로 등록할 수 없습니다.",1);
					}else {
						callback("총 " + gridDataList.length + "건 중 " + (gridDataList.length - no_apply_cnt) + "건만 등록가능합니다. <br> 진행하시겠습니까?" ,2,apply_cd_list, loan_cd_list);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function radio_check(){
		select_radio_val = $(":input:radio[name=SEARCH_RADIO]:checked").val();
		if(select_radio_val == "MEM"){
			$("#SEARCH_MEM_BTN").attr("disabled", false);
			$("#SEARCH_CUSTMR_BTN").attr("disabled", true);
		} else {
			$("#SEARCH_MEM_BTN").attr("disabled", true);
			$("#SEARCH_CUSTMR_BTN").attr("disabled", false);
		}
	}
	
	function numberWithCommas(x, type) {
		x = x.replace(/[^0-9]/g,'');   // 입력값이 숫자가 아니면 공백
		x = x.replace(/,/g,'');          // ,값 공백처리
		if(type == "start"){
			$("#LOAN_START").val(x.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); // 정규식을 이용해서 3자리 마다 , 추가
		} else {
			$("#LOAN_END").val(x.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); // 정규식을 이용해서 3자리 마다 , 추가
		}
	}
	
	function btn_show_hide(){
		var show_condition = $("input[name='Show_Condition']:checked").val();
		console.log(show_condition);
		if(show_condition == "ALL"){
			$erp.clearDhtmlXGrid(erpGrid);
			erpGrid.setColumnHidden(erpGrid.getColIndexById("CHECK"), true);
			erpRibbon.hide("add_custmr_erpGrid");
			erpRibbon.hide("add_mem_erpGrid");
			erpRibbon.hide("add_reuse_erpGrid");
			erpRibbon.hide("delete_erpGrid");
			//erpRibbon.hide("save_erpGrid");
		}else if(show_condition == "NEW"){
			$erp.clearDhtmlXGrid(erpGrid);
			erpGrid.setColumnHidden(erpGrid.getColIndexById("CHECK"), false);
			erpRibbon.show("add_reuse_erpGrid");
			erpRibbon.show("delete_erpGrid");
			//erpRibbon.show("save_erpGrid");
			console.log(cmbORGN_DIV_CD.getSelectedValue());
			if(cmbORGN_DIV_CD.getSelectedValue() != "B01"){
				if(cmbORGN_CD.getSelectedValue() == '100024'){
					erpRibbon.show("add_custmr_erpGrid");
				}else {
					erpRibbon.show("add_mem_erpGrid");
				}
			}else {
				erpRibbon.show("add_custmr_erpGrid");
			}
		}
	}
	
	function clearSearchCondition(type){
		if(type == 'MEM'){
			$("#txtMEM_ORGN_CD").val("");
			$("#txtMEM_NO").val("");
			$("#txtMEM_NAME").val("");
		} else if(type == 'CUSTMR') {
			$("#txtCUSTMR_CD").val("");
			$("#txtCUSTMR_NAME").val("");
		}
	}
	
</script>
</head>
<body>
	<div id="div_erp_search" class="div_layout_full_size div_erp_contents_search" style="display:none;">
		<input type="radio" id="Show_All" name="Show_Condition" checked="checked" value="ALL" onchange="btn_show_hide()">
		<label for="Show_All">전체내역보기</label>
		<input type="radio" id="Show_New" name="Show_Condition" value="NEW" onchange="btn_show_hide()">
		<label for="Show_New">최근정보보기</label>
		<input type="file" id="EVI_FILE_UPLOAD" style="display:none;" onchange="fileCheck()">
		<table id="tb_erp_table" class="tb_erp_common">
			<colgroup>
				<col width="120px"/>
				<col width="150px"/>
				<col width="120px"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<td colspan="4"></td>
			</tr>
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
				<th>기준일자</th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar" value="">
					~
					<input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar" value="">
				</td>
				<th rowspan="2">조회기준</th>
				<td rowspan="2">
					<div id="mem_type">
						<input type="hidden" id="txtMEM_ORGN_CD">
						<input type="hidden" id="txtMEM_NO">
						<input type="radio" id="SEARCH_MEM" name="SEARCH_RADIO" value="MEM" onchange="radio_check()" checked><label for="SEARCH_MEM">일반회원&nbsp;</label>
						<input type="text" class="input_common" id="txtMEM_NAME" style="margin-bottom: 5px;" readonly="readonly" onfocus="clearSearchCondition('MEM')">
						<input type="button" id="SEARCH_MEM_BTN" name="SEARCH_MEM_BTN" class="input_common_button" value="검 색" style="margin-bottom: 3px;" onclick="openSearchMemberGridPopup()">
					</div>
					<div id="custmr_type">	
						<input type="hidden" id="txtCUSTMR_CD">
						<input type="radio" id="SEARCH_CUSTMR" name="SEARCH_RADIO" value="CUSTMR" onchange="radio_check()"><label for="SEARCH_CUSTMR">고객사&nbsp;&nbsp;&nbsp;&nbsp;</label>
						<input type="text" id="txtCUSTMR_NAME" style="width: 130px;" readonly="readonly" onfocus="clearSearchCondition('CUSTMR')">
						<input type="button" id="SEARCH_CUSTMR_BTN" name="SEARCH_CUSTMR_BTN" class="input_common_button" value="검 색" style="margin-bottom: 3px;" onclick="openSearchCustmrGridPopup()">
					</div>	
				</td>
			</tr>
			<tr>
				<th>여신잔액<br>(1000단위입력)</th>
				<td>
					<input type=text id="LOAN_START" name="LOAN_START" class="input_money"  style="width: 90px;">
					~
					<input type="text" id="LOAN_END" name="LOAN_END" class="input_number input_money" style="width: 90px;" value="10000000">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>