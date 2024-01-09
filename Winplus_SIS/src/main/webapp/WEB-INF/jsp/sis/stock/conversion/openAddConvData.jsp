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
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openAddConvData");
	var convInfo = JSON.parse('${convInfo}');
	var erpPopupLayout;
	var erpPopupLeftLayout;
	var erpPopupRightLayout;
	var erpPopupRibbon;
	var erpPopupLeftRibbon;
	var erpPopupRightRibbon;
	var erpPopupLeftGrid;
	var erpPopupLeftGridColumns;
	var erpPopupLeftGridDataProcessor;
	var erpPopupRightGrid;
	var erpPopupRightGridColumns;
	var erpPopupRightGridDataProcessor;
	var popOnSaveAfterSearch;
	
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("대출입");
		}
		
		initErpPopupLayout();
		initErpPopupRibbon();
		
		initErpPopupLeftLayout();
		initErpPopupLeftRibbon();
		initErpPopupLeftGrid();
		
		initErpPopupRightLayout();
		initErpPopupRightRibbon();
		initErpPopupRightGrid();
		initDhtmlXCombo();
		initConvInfo();
	});
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "4E"
			, cells : [
				{id: "a", text: "대출입정보헤더영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "그리드영역(원물)", header:false, fix_size : [true, true]}
				,{id: "d", text: "그리드영역(대물)", header:false, fix_size : [true, true]}
			]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_table");
		erpPopupLayout.cells("a").setHeight($erp.getTableHeight(1));
		erpPopupLayout.cells("b").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_popup_left_layout");
		erpPopupLayout.cells("c").setHeight(200);
		erpPopupLayout.cells("d").attachObject("div_erp_popup_right_layout");
	}
	<%-- ■ erpPopupLayout 관련 Function 끝 --%>

	<%-- ■ erpPopupRibbon 관련 Function 시작 --%>
	function initErpPopupRibbon(){
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{type : "block", mode : 'rows', list : [
						//{id : "search_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
						{id : "save_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					]}
				]	
			});
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpPopupGrid"){
				searchErpPopupGrid();
			} else if (itemId == "save_erpPopupGrid"){
				saveErpPopupGrid();
			}
		});
	}
	
	function searchErpPopupGrid(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var orgnDivCd = convInfo.ORGN_DIV_CD;
		var orgnCd = convInfo.ORGN_CD;
		var convCd = convInfo.CONV_CD;
		
		erpPopupLayout.progressOn();
		$.ajax({
			url: "/sis/stock/conversion/getStockConvDetailList.do" //대출입내역 자료 조회
			, data : {
				"ORGN_DIV_CD" : orgnDivCd
				,"ORGN_CD" : orgnCd
				,"CONV_CD" : convCd
			}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpPopupLeftGrid);
					$erp.clearDhtmlXGrid(erpPopupRightGrid);
					var oriGridDataList = data.oriDataMapList;
					var replcGridDataList = data.replcDataMapList;
					if($erp.isEmpty(oriGridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupLeftGrid
							,'<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpPopupLeftGrid.parse(oriGridDataList, 'js');
						//하단 합계 적용
						calculateFooterValuesLeftGrid();
					}
					if($erp.isEmpty(replcGridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupRightGrid
							,'<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpPopupRightGrid.parse(replcGridDataList, 'js');
						//하단 합계 적용
						calculateFooterValuesRightGrid();
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupLeftGrid);
				$erp.setDhtmlXGridFooterRowCount(erpPopupRightGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function saveErpPopupGrid() {
		var erpPopLeftAllRowIds = erpPopupLeftGrid.getAllRowIds();
		var erpPopRightAllRowIds = erpPopupRightGrid.getAllRowIds();
		
		if(erpPopLeftAllRowIds == "" || erpPopLeftAllRowIds == "NoDataPrintRow"){
			$erp.alertMessage({
				"alertMessage" : "info.common.noData"
				, "alertType" : "notice"
			});
			return;
		}else if(erpPopRightAllRowIds == "" || erpPopRightAllRowIds == "NoDataPrintRow"){
			$erp.alertMessage({
				"alertMessage" : "info.common.noData"
				, "alertType" : "notice"
			});
			return;
		}else{
			var isValidated = true;
			var alertMessage = "";
			var alertType = "error";
			var alertCode = "";
			
			var convDate = document.getElementById("popConvDate").value.replace(/\-/g,'');
			var orgnCd = cmbORGN_CD.getSelectedValue();
			var orgnDivCd = cmbORGN_DIV_CD;
			var convCd = document.getElementById("hidConvCd").value;
			var convState = document.getElementById("hidConvState").value;
			if(convState == ""){
				convState = "1";
			}
			var oriSendType = document.getElementById("hidOriSendType").value;
			var replcSendType = document.getElementById("hidReplcSendType").value;
			
			if(convDate == null || convDate == undefined || convDate == "" || convDate == "null" || convDate == "undefined"){
				isValidated = false;
				alertMessage = "대출입일자를 지정해야 합니다.";
			} else if(orgnCd == null || orgnCd == undefined || orgnCd == "" || orgnCd == "null" || orgnCd == "undefined"){
				isValidated = false;
				alertMessage = "선택된 직영점이 없습니다.";
			} else if(oriSendType == "Y" || replcSendType == "Y"){
				isValidated = false;
				alertMessage = "확정한 자료를 수정 할 수 없습니다.";
			} else if(convState != "1"){
				isValidated = false;
				alertMessage = "자료입력 상태의 자료만 수정 할 수 있습니다.";
			}
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					,"alertType" : alertType
					,"isAjax" : false
					,"alertCallbackFn" : function(){
					}
				});
			}else{
				var validLeftResultMap = $erp.validDhtmlXGridEssentialData(erpPopupLeftGrid);
				var validRightResultMap = $erp.validDhtmlXGridEssentialData(erpPopupRightGrid);
				if(validLeftResultMap.isError) {
					$erp.alertMessage({
						"alertMessage" : validLeftResultMap.errMessage
						, "alertCode" : validLeftResultMap.errCode
						, "alertType" : "error"
						, "alertMessageParam" : validLeftResultMap.errMessageParam
					});
					return false;
				}
				if(validRightResultMap.isError) {
					$erp.alertMessage({
						"alertMessage" : validRightResultMap.errMessage
						, "alertCode" : validRightResultMap.errCode
						, "alertType" : "error"
						, "alertMessageParam" : validRightResultMap.errMessageParam
					});
					return false;
				}
				
				var leftTotAmtSum = sumColumnLeftGrid(erpPopupLeftGrid.getColIndexById("ORI_TOT_AMT"));
				var rightTotAmtSum = sumColumnRightGrid(erpPopupRightGrid.getColIndexById("CONV_TOT_AMT"));
				
				if(Math.abs(leftTotAmtSum - rightTotAmtSum) > 10){
					isValidated = false;
					alertMessage = "error.sis.conversion.tot_amt.diffAmtOver";
				}else if((leftTotAmtSum) < (rightTotAmtSum)){
					isValidated = false;
					alertMessage = "error.sis.conversion.tot_amt.notGreaterConv";
				}
				
				if(!isValidated){
					$erp.alertMessage({
						"alertMessage" : alertMessage
						,"alertType" : alertType
						,"isAjax" : true
						,"alertCallbackFn" : function(){
						}
					});
				}else{
					erpPopupLayout.progressOn();
					$erp.confirmMessage({
						"alertMessage" : '<spring:message code="alert.common.saveData" />'
						,"alertType" : "alert"
						,"isAjax" : false
						,"alertCallbackFn" : function(){
							var paramData = {};
							var leftGridData = $erp.serializeDhtmlXGridData(erpPopupLeftGrid, true);
							var rightGridData = $erp.serializeDhtmlXGridData(erpPopupRightGrid, true);
							if(leftGridData == null){
								leftGridData = {};
							}
							if(rightGridData == null){
								rightGridData = {};
							}
							paramData["CONV_DATE"] = convDate;
							paramData["ORGN_DIV_CD"] = orgnDivCd;
							paramData["ORGN_CD"] = orgnCd;
							paramData["CONV_CD"] = convCd;
							paramData["LEFT_GRID_DATA"] = leftGridData;
							paramData["RIGHT_GRID_DATA"] = rightGridData;
							
							$.ajax({
								url : "/sis/stock/conversion/updateConversionManagementList.do" //대출입 저장
								,data : {
									"paramData" : JSON.stringify(paramData)
								}
								,method : "POST"
								,dataType : "JSON"
								,success : function(data) {
									erpPopupLayout.progressOff();
									if(data.isError){
										$erp.ajaxErrorMessage(data);
									}else {
										$erp.alertMessage({
											"alertMessage" : '<spring:message code="info.common.saveSuccess" />'
											,"alertType" : "notice"
											,"isAjax" : false
											,"alertCallbackFn" : function(){
												popOnSaveAfterSearch();
											}
										});
									}
								}, error : function(jqXHR, textStatus, errorThrown){
									erpPopupLayout.progressOff();
									$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
								}
							});
						}
					});
				}
			}
		}
	}
	<%-- ■ erpPopupRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpPopupLeftLayout 관련 Function 시작 --%>
	function initErpPopupLeftLayout(){
		erpPopupLeftLayout = new dhtmlXLayoutObject({
			parent: "div_erp_popup_left_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "리본영역", header:false , fix_size:[true, true]}
				, {id: "b", text: "그리드영역", header:false , fix_size:[true, true]}
			]		
		});
		erpPopupLeftLayout.cells("a").attachObject("div_erp_popup_left_ribbon");
		erpPopupLeftLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLeftLayout.cells("b").attachObject("div_erp_popup_left_grid");
	}	
	<%-- ■ erpPopupLeftLayout 관련 Function 끝 --%>
	
	<%-- ■ erpPopupLeftRibbon 관련 Function 시작 --%>
	function initErpPopupLeftRibbon() {
		erpPopupLeftRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_left_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					//{id : "search_erpPopupLeftGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					{id : "add_erpPopupLeftGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					,{id : "delete_erpPopupLeftGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					,{id : "search_goods_leftGrid", type : "button", text:'원물상품검색', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
				]}
			]
		});	
		
		erpPopupLeftRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "add_erpPopupLeftGrid") {
				addErpPopupLeftGrid();
			} else if (itemId == "delete_erpPopupLeftGrid"){
				deleteErpPopupLeftGrid();
			} else if (itemId == "search_goods_leftGrid"){
				openSearchGoodsGridPopupLeftGrid();
			}
		});
	}
	<%-- ■ erpPopupLeftRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpPopupLeftGrid 관련 Function 시작 --%>
	function initErpPopupLeftGrid(){
		erpPopupLeftGridColumns = [
			//{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false, isEssential : false}
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "HID_BCD_CD", label:["바코드_히든", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "BCD_CD", label:["바코드", "#rspan"], type: "edn", width: "105", sort : "str", align : "left", isHidden : false, isEssential : true, isSelectAll : true, maxLength : 20}
			,{id : "BCD_NM", label:["품목명", "#rspan"], type: "ed", width: "260", sort : "str", align : "left", isHidden : false, isEssential : false, isSelectAll : true, maxLength : 100}
			,{id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "70", sort : "str", align : "center", isHidden : false, isEssential : false}
			,{id : "STD_PRICE", label:["기준단가(VAT제외)", "#rspan"], type: "ron", width: "112", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 20}
			,{id : "CONV_QTY", label:["수량", "#rspan"], type: "edn", width: "50", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 20}
			,{id : "ORI_TOT_AMT", label:["금액(VAT제외)", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 20}
			,{id : "TAX_YN", label : ["부가세여부", "#rspan"], type : "combo", width : "70", sort : "str", align : "center", isHidden : true, isEssential : false, isDisabled : true, commonCode : ["TAX_TYPE"]}
		];
		
		erpPopupLeftGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_left_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupLeftGridColumns
		});
		
		erpPopupLeftGrid.attachEvent("onKeyPress",onKeyPressedLeftGrid);
		erpPopupLeftGrid.enableBlockSelection();
		erpPopupLeftGrid.enableAccessKeyMap(true);
		erpPopupLeftGrid.enableDistributedParsing(true, 100, 50);
		var text_style = "text-align:right; font-weight:bold; font-style:normal";
		var tot_style = "text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;";
		erpPopupLeftGrid.attachFooter('합계,#cspan,#cspan,#cspan,#cspan,#cspan,<div id="oriTotalAmt" style="text-align:right;">0</div>,',[tot_style,"","","","","",text_style]);
		$erp.initGridCustomCell(erpPopupLeftGrid);
		$erp.initGridComboCell(erpPopupLeftGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupLeftGrid, '<spring:message code="grid.allRowCount" />');
		
		erpPopupLeftGrid.attachEvent("onEditCell",function(stage,rId,cInd){
			var tmpStdPrice = 0;
			var tmpConvQty = 0;
			var tmpHidBcdCd = "";
			var tmpBcdCd = "";
			
			if(stage == 2){
				//바코드 내용 변경 체크 후 조회
				tmpHidBcdCd = this.cells(rId,this.getColIndexById("HID_BCD_CD")).getValue();
				tmpBcdCd = this.cells(rId,this.getColIndexById("BCD_CD")).getValue();
				if(tmpHidBcdCd != tmpBcdCd){
					getGoodsInformationLeftGrid(rId);
				}
				
				//총액 재계산
				tmpStdPrice = this.cells(rId,this.getColIndexById("STD_PRICE")).getValue();
				tmpConvQty = this.cells(rId,this.getColIndexById("CONV_QTY")).getValue();
				this.cells(rId,this.getColIndexById("ORI_TOT_AMT")).setValue(tmpStdPrice*tmpConvQty);
				//하단 합계 적용
				calculateFooterValuesLeftGrid();
			}
		});
		erpPopupLeftGrid.attachEvent("onTab", function(mode){
			if(mode){
				if(this.getSelectedCellIndex() == this.getColIndexById("BCD_NM")){
					var searchText = this.cells(this.getSelectedRowId(),this.getColIndexById("BCD_NM")).getValue();
					if(searchText.length >= 2){
						openSearchGoodsGridPopupLeftGrid(searchText,this.getSelectedRowId());
					}
				}
				if(this.getSelectedCellIndex() == this.getColIndexById("BCD_CD")){
					this.setCellExcellType(this.getSelectedRowId(),this.getColIndexById("BCD_NM"),"ro");
				}
			}
			return true;
		});
		erpPopupLeftGrid.attachEvent("onRowPaste", function(rId){			//엑셀붙여넣기시 자동으로 행추가
			if(this.getRowIndex(((rId*1)+1)) == -1 ){
				addErpPopupLeftGrid();
			}
			
			//처음 입력한 바코드와 다를 경우 정보 가져오기(최초 붙여넣기 시, 붙여넣은 내용 변경 붙여넣기 시)
			if(
				(this.cells(rId,this.getColIndexById("BCD_CD")).getValue() != this.cells(rId,this.getColIndexById("HID_BCD_CD")).getValue())
			){
				getGoodsInformationLeftGrid(rId);
			}
		});
		
		erpPopupLeftGridDataProcessor = new dataProcessor();
		erpPopupLeftGridDataProcessor.init(erpPopupLeftGrid);
		erpPopupLeftGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpPopupLeftGrid);
	}
	
	function onKeyPressedLeftGrid(code,ctrl,shift){
		if(code==67&&ctrl){
			erpPopupLeftGrid.setCSVDelimiter("\t");
			erpPopupLeftGrid.copyBlockToClipboard();
		}
		if(code==86&&ctrl){
			erpPopupLeftGrid.setCSVDelimiter("\t");
			erpPopupLeftGrid.pasteBlockFromClipboard();
		}
		return true;
	}
	
	function calculateFooterValuesLeftGrid(stage){
		document.getElementById("oriTotalAmt").innerHTML = moneyType(sumColumnLeftGrid(erpPopupLeftGrid.getColIndexById("ORI_TOT_AMT")));
	}
	
	function moneyType(amt){
		return amt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function sumColumnLeftGrid(ind){
		var allRowIds = erpPopupLeftGrid.getAllRowIds();
		var allRowArray = [];
		var out = 0;
		var tmpLeftDpState = "";
		
		if(allRowIds != ""){
			allRowArray = allRowIds.split(",");
			for(var i=0; i<allRowArray.length; i++){
				tmpLeftDpState = erpPopupLeftGridDataProcessor.getState(allRowArray[i]);
				if(tmpLeftDpState == "deleted"){
					continue;
				}else{
					out+= erpPopupLeftGrid.cells(allRowArray[i],ind).getValue()*1;
				}
			}
		}
		return out;
	}
	
	function addErpPopupLeftGrid(){
		var uid = erpPopupLeftGrid.uid();
		erpPopupLeftGrid.addRow(uid);
		erpPopupLeftGrid.selectRow(erpPopupLeftGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpPopupLeftGrid);
		return uid;
	}
	
	function deleteErpPopupLeftGrid(){
		var popCheckRows = erpPopupLeftGrid.getCheckedRows(erpPopupLeftGrid.getColIndexById("CHECK"));
		var popCheckArray = popCheckRows.split(",");
		if(popCheckRows == "" || popCheckRows == "NoDataPrintRow"){
			$erp.alertMessage({
				"alertMessage" : "error.common.noCheckedData"
				, "alertCode" : null
				, "alertType" : "notice"
			});
		}else{
			if(popCheckArray.length == 0){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
				return;
			}
			
			for(var j = 0; j < popCheckArray.length; j++){
				erpPopupLeftGrid.deleteRow(popCheckArray[j]);
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpPopupLeftGrid);
			//하단 합계 적용
			calculateFooterValuesLeftGrid();
		}
	}
	
	function getGoodsInformationLeftGrid(rId) {
		var bcd_cd = erpPopupLeftGrid.cells(rId, erpPopupLeftGrid.getColIndexById("BCD_CD")).getValue();
		var tmpStdPrice = 0.0;
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/standardInfo/goods/getGoodsInformationFromBarcode.do"
			,data : {
				"BCD_CD" : bcd_cd
				,"ORGN_CD" : cmbORGN_CD.getSelectedValue()
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					erpPopupLeftGrid.cells(rId, erpPopupLeftGrid.getColIndexById("BCD_NM")).setValue(data.BCD_NM);
					erpPopupLeftGrid.cells(rId, erpPopupLeftGrid.getColIndexById("DIMEN_NM")).setValue(data.DIMEN_NM);
					if(data.TAX_TYPE == "Y"){
						erpPopupLeftGrid.cells(rId, erpPopupLeftGrid.getColIndexById("TAX_YN")).setValue(data.TAX_TYPE);
					}else{
						erpPopupLeftGrid.cells(rId, erpPopupLeftGrid.getColIndexById("TAX_YN")).setValue("");
					}
					if(data.TAX_TYPE == "Y"){
						tmpStdPrice = data.PUR_PRICE;
						tmpStdPrice = (tmpStdPrice/1.1);
						tmpStdPrice = Math.ceil(tmpStdPrice);
						tmpStdPrice = (data.PUR_PRICE - (data.PUR_PRICE - tmpStdPrice));
						erpPopupLeftGrid.cells(rId, erpPopupLeftGrid.getColIndexById("STD_PRICE")).setValue(tmpStdPrice);
					}else{
						erpPopupLeftGrid.cells(rId, erpPopupLeftGrid.getColIndexById("STD_PRICE")).setValue(data.PUR_PRICE);
					}
					
					erpPopupLeftGrid.cells(rId, erpPopupLeftGrid.getColIndexById("BCD_CD")).setValue(data.BCD_CD);
					erpPopupLeftGrid.cells(rId, erpPopupLeftGrid.getColIndexById("HID_BCD_CD")).setValue(data.BCD_CD);
					
					erpPopupLeftGrid.setCellExcellType(rId,erpPopupLeftGrid.getColIndexById("BCD_NM"),"ed");
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function openSearchGoodsGridPopupLeftGrid(searchText, rowId){
		var onClickAddData = function(erpGoodsPopup) {
			var isValidated = true;
			var alertMessage = "";
			var alertCode = "";
			var alertType = "error";
			
			var check = erpGoodsPopup.getCheckedRows(erpGoodsPopup.getColIndexById("CHECK")); // 조회된 그리드내역 중 선택한 row 번호 문자열로 넘어옴 ex) 1,5,7,10
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					, "alertCode" : alertCode
					, "alertType" : alertType
				});
			}else{
				var checkList = check.split(',');
				
				var erpPopupGridUid;
				
				for(var i = 0 ; i < checkList.length ; i ++) {
					if(i == 0 && rowId != undefined){
						erpPopupGridUid = rowId;
					}else{
						if(erpPopupLeftGrid.getRowIndex(((erpPopupGridUid*1)+1)) == -1 ){
							erpPopupGridUid = addErpPopupLeftGrid();
						}else{
							erpPopupGridUid = ((erpPopupGridUid*1)+1);
						}
					}
					erpPopupLeftGrid.cells(erpPopupGridUid,erpPopupLeftGrid.getColIndexById("BCD_CD")).setValue(erpGoodsPopup.cells(checkList[i], erpGoodsPopup.getColIndexById("BCD_CD")).getValue());
					getGoodsInformationLeftGrid(erpPopupGridUid);
				}
				$erp.closePopup2("autoBindSearchGoodsPopup");
			}
		}
		
		var onRowDblClicked = function(popupRId,popupCInd){
			var isValidated = true;
			var alertMessage = "";
			var alertCode = "";
			var alertType = "error";
			
			var selectedRowId = this.getSelectedRowId(); // 조회된 그리드 선택내역
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					, "alertCode" : alertCode
					, "alertType" : alertType
				});
			}else{
				var erpPopupGridUid;
				if(rowId != undefined){
					erpPopupGridUid = rowId;
				}else{
					if(erpPopupLeftGrid.getRowIndex(((erpPopupGridUid*1)+1)) == -1 ){
						erpPopupGridUid = addErpPopupLeftGrid();
					}else{
						erpPopupGridUid = ((erpPopupGridUid*1)+1);
					}
				}
				
				erpPopupLeftGrid.cells(erpPopupGridUid,erpPopupLeftGrid.getColIndexById("BCD_CD")).setValue(this.cells(selectedRowId, this.getColIndexById("BCD_CD")).getValue());
				getGoodsInformationLeftGrid(erpPopupGridUid);
				
				$erp.closePopup2("autoBindSearchGoodsPopup");
			}
		}
		
		var searchParams = {};
		searchParams.SEARCH_URL = "/common/popup/getGoodsList.do";
		searchParams.SEARCH_AUTO = "Y";
		searchParams.KEY_WORD = searchText;
		searchParams.SECH_TYPE = "WORD";
		searchParams.BCD_MS_TYPE = "M";
		searchParams.ORGN_DIV_CD = cmbORGN_DIV_CD;
		searchParams.ORGN_CD = cmbORGN_CD.getSelectedValue();
		
		var fnParamMap = new Map();
		fnParamMap.set("erpPopupGoodsCheckList",onClickAddData);
		fnParamMap.set("erpPopupGoodsOnRowDblClicked",onRowDblClicked);
		
		if(searchParams.KEY_WORD == undefined){
			searchParams.SEARCH_AUTO = "N";
			searchParams.BCD_MS_TYPE = "M";
			$erp.autoBindSearchGoodsPopup(searchParams, fnParamMap);
		}else{
			erpPopupLayout.progressOn();
			$.ajax({
				url : searchParams.SEARCH_URL
				,data : searchParams
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpPopupLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						var GoodsList = data.GoodsList;
						if(GoodsList.length == 1){
							erpPopupLeftGrid.cells(rowId, erpPopupLeftGrid.getColIndexById("BCD_CD")).setValue(GoodsList[0].BCD_CD);
							getGoodsInformationLeftGrid(rowId);
						}else{
							$erp.autoBindSearchGoodsPopup(searchParams, fnParamMap);
						}
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	<%-- ■ erpPopupLeftGrid 관련 Function 끝 --%>
	
	<%-- ■ erpPopupRightLayout 관련 Function 시작 --%>
	function initErpPopupRightLayout(){
		erpPopupRightLayout = new dhtmlXLayoutObject({
			parent: "div_erp_popup_right_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "리본영역", header:false , fix_size:[true, true]}
				, {id: "b", text: "그리드영역", header:false , fix_size:[true, true]}
			]		
		});
		erpPopupRightLayout.cells("a").attachObject("div_erp_popup_right_ribbon");
		erpPopupRightLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupRightLayout.cells("b").attachObject("div_erp_popup_right_grid");
	}	
	<%-- ■ erpPopupRightLayout 관련 Function 끝 --%>
	
	<%-- ■ erpPopupRightRibbon 관련 Function 시작 --%>
	function initErpPopupRightRibbon() {
		erpPopupRightRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_right_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					//{id : "search_erpPopupLeftGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					{id : "add_erpPopupRightGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					,{id : "delete_erpPopupRightGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					,{id : "search_goods_rightGrid", type : "button", text:'대물상품검색', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					,{id : "search_calc_rightGrid", type : "button", text:'단가자동계산', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : false}
				]}
			]
		});	
		
		erpPopupRightRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "add_erpPopupRightGrid") {
				addErpPopupRightGrid();
			} else if (itemId == "delete_erpPopupRightGrid"){
				deleteErpPopupRightGrid();
			} else if (itemId == "search_goods_rightGrid"){
				openSearchGoodsGridPopupRightGrid();
			} else if (itemId == "search_calc_rightGrid"){
				calcConvPriceRightGrid();
			}
		});
	}
	<%-- ■ erpPopupRightRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpPopupRightGrid 관련 Function 시작 --%>
	function initErpPopupRightGrid(){
		erpPopupRightGridColumns = [
			//{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false, isEssential : false}
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "HID_BCD_CD", label:["바코드_히든", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "BCD_CD", label:["바코드", "#rspan"], type: "edn", width: "105", sort : "str", align : "left", isHidden : false, isEssential : true, isSelectAll : true, maxLength : 20}
			,{id : "BCD_NM", label:["품목명", "#rspan"], type: "ed", width: "260", sort : "str", align : "left", isHidden : false, isEssential : false, isSelectAll : true, maxLength : 100}
			,{id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "70", sort : "str", align : "center", isHidden : false, isEssential : false}
			,{id : "STD_PRICE", label:["기준단가(VAT제외)", "#rspan"], type: "ron", width: "112", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 20}
			,{id : "CONV_PRICE", label:["단가(VAT제외)", "#rspan"], type: "edn", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000.00", isSelectAll : true, maxLength : 20}
			,{id : "CONV_QTY", label:["수량", "#rspan"], type: "edn", width: "50", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 20}
			,{id : "CONV_TOT_AMT", label:["금액(VAT제외)", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 20}
			,{id : "TAX_YN", label : ["부가세여부", "#rspan"], type : "combo", width : "70", sort : "str", align : "center", isHidden : true, isEssential : false, isDisabled : true, commonCode : ["TAX_TYPE"]}
		];
		
		erpPopupRightGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_right_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupRightGridColumns
		});
		
		erpPopupRightGrid.attachEvent("onKeyPress",onKeyPressedRightGrid);
		erpPopupRightGrid.enableBlockSelection();
		erpPopupRightGrid.enableAccessKeyMap(true);
		erpPopupRightGrid.enableDistributedParsing(true, 100, 50);
		var text_style = "text-align:right; font-weight:bold; font-style:normal";
		var tot_style = "text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;";
		erpPopupRightGrid.attachFooter('합계,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,<div id="replcTotalAmt" style="text-align:right;">0</div>,',[tot_style,"","","","","",text_style]);
		$erp.initGridCustomCell(erpPopupRightGrid);
		$erp.initGridComboCell(erpPopupRightGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupRightGrid, '<spring:message code="grid.allRowCount" />');
		
		erpPopupRightGrid.attachEvent("onEditCell",function(stage,rId,cInd){
			var tmpConvPrice = 0;
			var tmpConvQty = 0;
			var tmpHidBcdCd = "";
			var tmpBcdCd = "";
			
			if(stage == 2){
				//바코드 내용 변경 체크 후 조회
				tmpHidBcdCd = this.cells(rId,this.getColIndexById("HID_BCD_CD")).getValue();
				tmpBcdCd = this.cells(rId,this.getColIndexById("BCD_CD")).getValue();
				if(tmpHidBcdCd != tmpBcdCd){
					getGoodsInformationRightGrid(rId);
				}
				
				//총액 재계산
				tmpConvPrice = this.cells(rId,this.getColIndexById("CONV_PRICE")).getValue();
				tmpConvQty = this.cells(rId,this.getColIndexById("CONV_QTY")).getValue();
				this.cells(rId,this.getColIndexById("CONV_TOT_AMT")).setValue(tmpConvPrice*tmpConvQty);
				//하단 합계 적용
				calculateFooterValuesRightGrid();
			}
		});
		erpPopupRightGrid.attachEvent("onTab", function(mode){
			if(mode){
				if(this.getSelectedCellIndex() == this.getColIndexById("BCD_NM")){
					var searchText = this.cells(this.getSelectedRowId(),this.getColIndexById("BCD_NM")).getValue();
					if(searchText.length >= 2){
						openSearchGoodsGridPopupRightGrid(searchText,this.getSelectedRowId());
					}
				}
				if(this.getSelectedCellIndex() == this.getColIndexById("BCD_CD")){
					this.setCellExcellType(this.getSelectedRowId(),this.getColIndexById("BCD_NM"),"ro");
				}
			}
			return true;
		});
		erpPopupRightGrid.attachEvent("onRowPaste", function(rId){			//엑셀붙여넣기시 자동으로 행추가
			if(this.getRowIndex(((rId*1)+1)) == -1 ){
				addErpPopupRightGrid();
			}
			
			//처음 입력한 바코드와 다를 경우 정보 가져오기(최초 붙여넣기 시, 붙여넣은 내용 변경 붙여넣기 시)
			if(
				(this.cells(rId,this.getColIndexById("BCD_CD")).getValue() != this.cells(rId,this.getColIndexById("HID_BCD_CD")).getValue())
			){
				getGoodsInformationRightGrid(rId);
			}
		});
		
		erpPopupRightGridDataProcessor = new dataProcessor();
		erpPopupRightGridDataProcessor.init(erpPopupRightGrid);
		erpPopupRightGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpPopupRightGrid);
	}
	
	function onKeyPressedRightGrid(code,ctrl,shift){
		if(code==67&&ctrl){
			erpPopupRightGrid.setCSVDelimiter("\t");
			erpPopupRightGrid.copyBlockToClipboard();
		}
		if(code==86&&ctrl){
			erpPopupRightGrid.setCSVDelimiter("\t");
			erpPopupRightGrid.pasteBlockFromClipboard();
		}
		return true;
	}
	
	function calculateFooterValuesRightGrid(stage){
		document.getElementById("replcTotalAmt").innerHTML = moneyType(sumColumnRightGrid(erpPopupRightGrid.getColIndexById("CONV_TOT_AMT")));
	}
	
	function moneyType(amt){
		return amt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function sumColumnRightGrid(ind){
		var allRowIds = erpPopupRightGrid.getAllRowIds();
		var allRowArray = [];
		var out = 0;
		var tmpRightDpState = "";
		
		if(allRowIds != ""){
			allRowArray = allRowIds.split(",");
			for(var i=0; i<allRowArray.length; i++){
				tmpRightDpState = erpPopupRightGridDataProcessor.getState(allRowArray[i]);
				if(tmpRightDpState == "deleted"){
					continue;
				}else{
					out+= erpPopupRightGrid.cells(allRowArray[i],ind).getValue()*1;
				}
			}
		}
		return out;
	}
	
	function addErpPopupRightGrid(){
		var uid = erpPopupRightGrid.uid();
		erpPopupRightGrid.addRow(uid);
		erpPopupRightGrid.selectRow(erpPopupRightGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpPopupRightGrid);
		return uid;
	}
	
	function deleteErpPopupRightGrid(){
		var popCheckRows = erpPopupRightGrid.getCheckedRows(erpPopupRightGrid.getColIndexById("CHECK"));
		var popCheckArray = popCheckRows.split(",");
		if(popCheckRows == "" || popCheckRows == "NoDataPrintRow"){
			$erp.alertMessage({
				"alertMessage" : "error.common.noCheckedData"
				, "alertCode" : null
				, "alertType" : "notice"
			});
		}else{
			if(popCheckArray.length == 0){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
				return;
			}
			
			for(var j = 0; j < popCheckArray.length; j++){
				erpPopupRightGrid.deleteRow(popCheckArray[j]);
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpPopupRightGrid);
			//하단 합계 적용
			calculateFooterValuesRightGrid();
		}
	}
	
	function getGoodsInformationRightGrid(rId) {
		var bcd_cd = erpPopupRightGrid.cells(rId, erpPopupRightGrid.getColIndexById("BCD_CD")).getValue();
		var tmpStdPrice = 0.0;
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/standardInfo/goods/getGoodsInformationFromBarcode.do"
			,data : {
				"BCD_CD" : bcd_cd
				,"ORGN_CD" : cmbORGN_CD.getSelectedValue()
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					erpPopupRightGrid.cells(rId, erpPopupRightGrid.getColIndexById("BCD_NM")).setValue(data.BCD_NM);
					erpPopupRightGrid.cells(rId, erpPopupRightGrid.getColIndexById("DIMEN_NM")).setValue(data.DIMEN_NM);
					if(data.TAX_TYPE == "Y"){
						erpPopupRightGrid.cells(rId, erpPopupRightGrid.getColIndexById("TAX_YN")).setValue(data.TAX_TYPE);
					}else{
						erpPopupRightGrid.cells(rId, erpPopupRightGrid.getColIndexById("TAX_YN")).setValue("");
					}
					if(data.TAX_TYPE == "Y"){
						tmpStdPrice = data.PUR_PRICE;
						tmpStdPrice = (tmpStdPrice/1.1);
						tmpStdPrice = Math.ceil(tmpStdPrice);
						tmpStdPrice = (data.PUR_PRICE - (data.PUR_PRICE - tmpStdPrice));
						erpPopupRightGrid.cells(rId, erpPopupRightGrid.getColIndexById("STD_PRICE")).setValue(tmpStdPrice);
						erpPopupRightGrid.cells(rId, erpPopupRightGrid.getColIndexById("CONV_PRICE")).setValue(tmpStdPrice);
					}else{
						erpPopupRightGrid.cells(rId, erpPopupRightGrid.getColIndexById("STD_PRICE")).setValue(data.PUR_PRICE);
						erpPopupRightGrid.cells(rId, erpPopupRightGrid.getColIndexById("CONV_PRICE")).setValue(data.PUR_PRICE);
					}
					
					erpPopupRightGrid.cells(rId, erpPopupRightGrid.getColIndexById("BCD_CD")).setValue(data.BCD_CD);
					erpPopupRightGrid.cells(rId, erpPopupRightGrid.getColIndexById("HID_BCD_CD")).setValue(data.BCD_CD);
					
					erpPopupRightGrid.setCellExcellType(rId,erpPopupRightGrid.getColIndexById("BCD_NM"),"ed");
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function openSearchGoodsGridPopupRightGrid(searchText, rowId){
		var onClickAddData = function(erpGoodsPopup) {
			var isValidated = true;
			var alertMessage = "";
			var alertCode = "";
			var alertType = "error";
			
			var check = erpGoodsPopup.getCheckedRows(erpGoodsPopup.getColIndexById("CHECK")); // 조회된 그리드내역 중 선택한 row 번호 문자열로 넘어옴 ex) 1,5,7,10
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					, "alertCode" : alertCode
					, "alertType" : alertType
				});
			}else{
				var checkList = check.split(',');
				
				var erpPopupGridUid;
				
				for(var i = 0 ; i < checkList.length ; i ++) {
					if(i == 0 && rowId != undefined){
						erpPopupGridUid = rowId;
					}else{
						if(erpPopupRightGrid.getRowIndex(((erpPopupGridUid*1)+1)) == -1 ){
							erpPopupGridUid = addErpPopupRightGrid();
						}else{
							erpPopupGridUid = ((erpPopupGridUid*1)+1);
						}
					}
					erpPopupRightGrid.cells(erpPopupGridUid,erpPopupRightGrid.getColIndexById("BCD_CD")).setValue(erpGoodsPopup.cells(checkList[i], erpGoodsPopup.getColIndexById("BCD_CD")).getValue());
					getGoodsInformationRightGrid(erpPopupGridUid);
				}
				$erp.closePopup2("autoBindSearchGoodsPopup");
			}
		}
		
		var onRowDblClicked = function(popupRId,popupCInd){
			var isValidated = true;
			var alertMessage = "";
			var alertCode = "";
			var alertType = "error";
			
			var selectedRowId = this.getSelectedRowId(); // 조회된 그리드 선택내역
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					, "alertCode" : alertCode
					, "alertType" : alertType
				});
			}else{
				var erpPopupGridUid;
				if(rowId != undefined){
					erpPopupGridUid = rowId;
				}else{
					if(erpPopupRightGrid.getRowIndex(((erpPopupGridUid*1)+1)) == -1 ){
						erpPopupGridUid = addErpPopupRightGrid();
					}else{
						erpPopupGridUid = ((erpPopupGridUid*1)+1);
					}
				}
				
				erpPopupRightGrid.cells(erpPopupGridUid,erpPopupRightGrid.getColIndexById("BCD_CD")).setValue(this.cells(selectedRowId, this.getColIndexById("BCD_CD")).getValue());
				getGoodsInformationRightGrid(erpPopupGridUid);
				
				$erp.closePopup2("autoBindSearchGoodsPopup");
			}
		}
		
		var searchParams = {};
		searchParams.SEARCH_URL = "/common/popup/getGoodsList.do";
		searchParams.SEARCH_AUTO = "Y";
		searchParams.KEY_WORD = searchText;
		searchParams.SECH_TYPE = "WORD";
		searchParams.BCD_MS_TYPE = "M";
		searchParams.ORGN_DIV_CD = cmbORGN_DIV_CD;
		searchParams.ORGN_CD = cmbORGN_CD.getSelectedValue();
		
		var fnParamMap = new Map();
		fnParamMap.set("erpPopupGoodsCheckList",onClickAddData);
		fnParamMap.set("erpPopupGoodsOnRowDblClicked",onRowDblClicked);
		
		if(searchParams.KEY_WORD == undefined){
			searchParams.SEARCH_AUTO = "N";
			searchParams.BCD_MS_TYPE = "M";
			$erp.autoBindSearchGoodsPopup(searchParams, fnParamMap);
		}else{
			erpPopupLayout.progressOn();
			$.ajax({
				url : searchParams.SEARCH_URL
				,data : searchParams
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpPopupLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						var GoodsList = data.GoodsList;
						if(GoodsList.length == 1){
							erpPopupRightGrid.cells(rowId, erpPopupRightGrid.getColIndexById("BCD_CD")).setValue(GoodsList[0].BCD_CD);
							getGoodsInformationRightGrid(rowId);
						}else{
							$erp.autoBindSearchGoodsPopup(searchParams, fnParamMap);
						}
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	function calcConvPriceRightGrid(){
		var tmpOriTotAmt = sumColumnLeftGrid(erpPopupLeftGrid.getColIndexById("ORI_TOT_AMT"));
		
		var allRowIds = erpPopupRightGrid.getAllRowIds();
		var allRowArray = [];
		
		var tmpConvTotAmt = 0;
		var tmpStdPrice = "";
		var tmpConvQty = "";
		var tmpConvPrice = "";
		var tmpMultiplier = 0.0;
		
		var tmpRightDpState = "";
		
		if(allRowIds != ""){
			allRowArray = allRowIds.split(",");
			for(var i=0; i<allRowArray.length; i++){
				tmpStdPrice = erpPopupRightGrid.cells(allRowArray[i],erpPopupRightGrid.getColIndexById("STD_PRICE")).getValue();
				tmpRightDpState = erpPopupRightGridDataProcessor.getState(allRowArray[i]);
				if(tmpStdPrice == "" || tmpStdPrice == "0" || tmpRightDpState == "deleted"){
					continue;
				}else{
					tmpConvQty = erpPopupRightGrid.cells(allRowArray[i],erpPopupRightGrid.getColIndexById("CONV_QTY")).getValue();
					if(tmpConvQty == "" || tmpConvQty == "0"){
						tmpConvQty = "1";
						erpPopupRightGrid.cells(allRowArray[i],erpPopupRightGrid.getColIndexById("CONV_QTY")).setValue("1");
					}
					tmpConvTotAmt += (tmpStdPrice*1)*(tmpConvQty*1);
				}
			}
			
			//배수 계산
			tmpMultiplier = tmpOriTotAmt/tmpConvTotAmt;
			
			//단가에 배수 적용
			for(var i=0; i<allRowArray.length; i++){
				tmpStdPrice = erpPopupRightGrid.cells(allRowArray[i],erpPopupRightGrid.getColIndexById("STD_PRICE")).getValue();
				if(tmpStdPrice == "" || tmpStdPrice == "0"){
					continue;
				}else{
					tmpConvQty = erpPopupRightGrid.cells(allRowArray[i],erpPopupRightGrid.getColIndexById("CONV_QTY")).getValue();
					tmpConvPrice = (tmpStdPrice*1)*tmpMultiplier*1000000;
					tmpConvPrice = Math.floor(tmpConvPrice);
					tmpConvPrice = tmpConvPrice/1000000.0;
					erpPopupRightGrid.cells(allRowArray[i],erpPopupRightGrid.getColIndexById("CONV_PRICE")).setValue(tmpConvPrice+"");
					erpPopupRightGrid.cells(allRowArray[i],erpPopupRightGrid.getColIndexById("CONV_TOT_AMT")).setValue((tmpConvPrice)*(tmpConvQty*1)+"");
				}
			}
			//하단 합계 적용
			calculateFooterValuesRightGrid();
		}
	}
	<%-- ■ erpPopupRightGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	function initDhtmlXCombo(){
		var convOrgnCd = convInfo.ORGN_CD;
		var convOrgnDivCd = convInfo.ORGN_DIV_CD;
		cmbORGN_DIV_CD = convOrgnDivCd;
		cmbORGN_CD = $erp.getDhtmlXCombo("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK",null,null,null,"MK"] , 100, null, convOrgnCd);
		cmbORGN_CD.disable();
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ 기타 Function 시작 --%>
	function initConvInfo(){
		var convDate = convInfo.CONV_DATE;
		var convYear = convDate.substring(0,4);
		var convMonth = convDate.substring(4,6);
		var convDay = convDate.substring(6,8);
		convDate = convYear + "-" + convMonth + "-" + convDay;
		
		document.getElementById("popConvDate").value = convDate;
		
		if(convInfo.CONV_CD == ""){
			document.getElementById("hidConvCd").value = "";
			document.getElementById("hidConvState").value = "";
			document.getElementById("hidOriSendType").value = "";
			document.getElementById("hidReplcSendType").value = "";
		}else{
			document.getElementById("hidConvCd").value = convInfo.CONV_CD;
			document.getElementById("hidConvState").value = convInfo.CONV_STATE;
			document.getElementById("hidOriSendType").value = convInfo.ORI_SEND_TYPE;
			document.getElementById("hidReplcSendType").value = convInfo.REPLC_SEND_TYPE;
			
			searchErpPopupGrid();
		}
	}
	<%-- ■ 기타 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_popup_table" class="samyang_div" style="diplay:none;">
		<table id = "tb_search_01" class = "table">
			<colgroup>
				<col width="80px"/>
				<col width="120px"/>
				<col width="80px"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<th>대출입일자</th>
				<td>
					<input type="text" id="popConvDate" name="popConvDate" class="input_common" readonly="readonly" disabled="disabled" style="width: 65px;">
				</td>
				<th>직영점</th>
				<td>
					<div id="cmbORGN_CD"></div>
					<input type="hidden" id="hidConvCd" value="">
					<input type="hidden" id="hidConvState" value="">
					<input type="hidden" id="hidOriSendType" value="">
					<input type="hidden" id="hidReplcSendType" value="">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_popup_left_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_popup_left_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_popup_left_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	<div id="div_erp_popup_right_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_popup_right_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_popup_right_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>