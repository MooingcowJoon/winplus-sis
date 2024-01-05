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
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openAddInspData");
	var inspInfo = JSON.parse('${inspInfo}');
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;
	var erpPopupGridDataProcessor;
	
	//사용자정의함수는 보내는 키 문자열 값과 동일해야 합니다.
	var popOnSaveAfterSearch;
	
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var cmbPUR_TYPE;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("거래명세서");
		}
		
		initErpPopupLayout();
		initErpPopupRibbon();
		initErpPopupGrid();
		initDhtmlXCombo();
		initInspInfo();
	});
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "입고정보헤더영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "그리드영역(입고정보디테일)", header:false}
			]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_table");
		erpPopupLayout.cells("a").setHeight(88);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_popup_grid");
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
						{id : "save_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
						,{id : "add_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
						,{id : "delete_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						,{id : "search_inspPdaList", type : "button", text:'PDA내역 불러오기', isbig : false, img : "menu/open.gif", imgdis : "menu/open_dis.gif", disable : true}
						,{id : "search_goods", type : "button", text:'상품검색', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					]}
				]	
			});
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "save_erpPopupGrid"){
				saveErpPopupGrid();
			} else if(itemId == "add_erpPopupGrid"){
				addErpPopupGrid();
			} else if(itemId == "delete_erpPopupGrid"){
				deleteErpPopupGrid();
			} else if(itemId == "search_inspPdaList"){
				openInspPdaDataPopup();
			} else if(itemId == "search_goods"){
				openSearchGoodsGridPopup();
			}
		});
	}
	<%-- ■ erpPopupRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpPopupGrid 관련 Function 시작 --%>
	function initErpPopupGrid(){
		erpPopupGridColumns = [
			//{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false, isEssential : false}
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "HID_BCD_CD", label:["바코드_히든", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "BCD_CD", label:["바코드", "#rspan"], type: "edn", width: "105", sort : "str", align : "left", isHidden : false, isEssential : true, isSelectAll : true, maxLength : 20}
			,{id : "BCD_NM", label:["품목명", "#rspan"], type: "ed", width: "260", sort : "str", align : "left", isHidden : false, isEssential : false, isSelectAll : true, maxLength : 100}
			,{id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "70", sort : "str", align : "center", isHidden : false, isEssential : false}
			,{id : "SALE_PRICE", label:["단가", "#rspan"], type: "edn", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "SALE_QTY", label:["수량", "#rspan"], type: "edn", width: "50", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "PAY_SUM_AMT", label:["금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "TAX_YN", label : ["부가세여부", "#rspan"], type : "combo", width : "70", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["TAX_TYPE"]}
			,{id : "PUR_SLIP_SEQ", label:["순번", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false}
		];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupGridColumns
		});
		
		erpPopupGrid.attachEvent("onKeyPress",onKeyPressed);
		erpPopupGrid.enableBlockSelection();
		erpPopupGrid.enableAccessKeyMap(true);
		erpPopupGrid.enableDistributedParsing(true, 100, 50);
		erpPopupGrid.attachFooter('합계,#cspan,#cspan,#cspan,#cspan,<div id="totalAmt" style="text-align:right; font-weight:bold; font-style:normal;">0</div>,#cspan,#cspan',["text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;"]);
		$erp.initGridCustomCell(erpPopupGrid);
		$erp.initGridComboCell(erpPopupGrid);
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid, 30);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid, '<spring:message code="grid.allRowCount" />');
		
		erpPopupGrid.attachEvent("onEditCell",function(stage,rId,cInd){
			var tmpSalePrice = 0;
			var tmpSaleQty = 0;
			var tmpHidBcdCd = "";
			var tmpBcdCd = "";
			
			if(stage == 2){
				//바코드 내용 변경 체크 후 조회
				tmpHidBcdCd = this.cells(rId,this.getColIndexById("HID_BCD_CD")).getValue();
				tmpBcdCd = this.cells(rId,this.getColIndexById("BCD_CD")).getValue();
				if(tmpHidBcdCd != tmpBcdCd){
					getGoodsInformation(rId);
				}
				
				//총액 재계산
				tmpSalePrice = this.cells(rId,this.getColIndexById("SALE_PRICE")).getValue();
				tmpSaleQty = this.cells(rId,this.getColIndexById("SALE_QTY")).getValue();
				this.cells(rId,this.getColIndexById("PAY_SUM_AMT")).setValue(tmpSalePrice*tmpSaleQty);
				//하단 합계 적용
				calculateFooterValues();
			}
		});
		erpPopupGrid.attachEvent("onTab", function(mode){
			if(mode){
				if(this.getSelectedCellIndex() == this.getColIndexById("BCD_NM")){
					var searchText = this.cells(this.getSelectedRowId(),this.getColIndexById("BCD_NM")).getValue();
					if(searchText.length >= 2){
						openSearchGoodsGridPopup(searchText,this.getSelectedRowId());
					}
				}
			}
			return true;
		});
		erpPopupGrid.attachEvent("onRowPaste", function(rId){			//엑셀붙여넣기시 자동으로 행추가
			if(this.getRowIndex(((rId*1)+1)) == -1 ){
				addErpPopupGrid();
			}
			
			//처음 입력한 바코드와 다를 경우 정보 가져오기(최초 붙여넣기 시, 붙여넣은 내용 변경 붙여넣기 시)
			if(
				(this.cells(rId,this.getColIndexById("BCD_CD")).getValue() != this.cells(rId,this.getColIndexById("HID_BCD_CD")).getValue())
			){
				getGoodsInformation(rId);
			}
		});
		
		erpPopupGridDataProcessor = new dataProcessor();
		erpPopupGridDataProcessor.init(erpPopupGrid);
		erpPopupGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpPopupGrid);
	}
	
	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpPopupGrid.setCSVDelimiter("\t");
			erpPopupGrid.copyBlockToClipboard();
		}
		if(code==86&&ctrl){
			erpPopupGrid.setCSVDelimiter("\t");
			erpPopupGrid.pasteBlockFromClipboard();
		}
		return true;
	}
	
	function calculateFooterValues(stage){
		document.getElementById("totalAmt").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("PAY_SUM_AMT")));
	}
	
	function moneyType(amt){
		return amt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function sumColumn(ind){
		var allRowIds = erpPopupGrid.getAllRowIds();
		var allRowArray = [];
		var out = 0;
		if(allRowIds != ""){
			allRowArray = allRowIds.split(",");
			for(var i=0; i<allRowArray.length; i++){
				out+= erpPopupGrid.cells(allRowArray[i],ind).getValue()*1;
			}
		}
		return out;
	}
	
	function searchErpPopupGrid(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var purSlipCd = inspInfo.PUR_SLIP_CD;
		var orgnCd = inspInfo.ORGN_CD;
		
		$.ajax({
			url: "/sis/market/purchase/getGoodsInspectionRegistDetailList.do" //입고내역 자료 조회
			, data : {
				 "PUR_SLIP_CD" : purSlipCd
				 ,"ORGN_CD" : orgnCd
			}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpPopupLayout.progressOn();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpPopupGrid);
					var gridDataList = data.dataMap;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupGrid
							,'<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpPopupGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
				erpPopupLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function saveErpPopupGrid() {
		var erpPopAllRowIds = erpPopupGrid.getAllRowIds();
		
		if(erpPopAllRowIds == "" || erpPopAllRowIds == "NoDataPrintRow"){
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
			
			var inspDate = document.getElementById("popInspDate").value.replace(/\-/g,'');
			var orgnCd = cmbORGN_CD.getSelectedValue();
			var suprCd = document.getElementById("hidCustmr_CD").value;
			var purSlipCd = document.getElementById("hidPurSlipCd").value;
			var confType = document.getElementById("hidConfType").value;
			var sendType = document.getElementById("hidSendType").value;
			var purType = cmbPUR_TYPE.getSelectedValue();
			var memo = document.getElementById("txtMemo").value;
			
			if(inspDate == null || inspDate == undefined || inspDate == "" || inspDate == "null" || inspDate == "undefined"){
				isValidated = false;
				alertMessage = "입고일자를 지정해야 합니다.";
				alertCode = "1";
			} else if(orgnCd == null || orgnCd == undefined || orgnCd == "" || orgnCd == "null" || orgnCd == "undefined"){
				isValidated = false;
				alertMessage = "선택된 직영점이 없습니다.";
			} else if(suprCd == null || suprCd == undefined || suprCd == "" || suprCd == "null" || suprCd == "undefined"){
				isValidated = false;
				alertMessage = "선택된 협력사가 없습니다.";
				alertCode = "2";
			} else if(confType == "Y" || sendType == "Y"){
				isValidated = false;
				alertMessage = "확정한 자료를 수정 할 수 없습니다.";
			}
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					,"alertType" : alertType
					,"isAjax" : false
					,"alertCallbackFn" : function(){
						if(alertCode == "1"){
							document.getElementById("popInspDate").focus();
						}else if(alertCode == "2"){
							document.getElementById("Custmr_Name").focus();
						}
					}
				});
			}else{
				var validResultMap = $erp.validDhtmlXGridEssentialData(erpPopupGrid);
				if(validResultMap.isError) {
					$erp.alertMessage({
						"alertMessage" : validResultMap.errMessage
						, "alertCode" : validResultMap.errCode
						, "alertType" : "error"
						, "alertMessageParam" : validResultMap.errMessageParam
					});
					return false;
				}
				$erp.confirmMessage({
					"alertMessage" : '<spring:message code="alert.common.saveData" />'
					,"alertType" : "alert"
					,"isAjax" : false
					,"alertCallbackFn" : function(){
						erpPopupLayout.progressOn();
						var paramData = $erp.serializeDhtmlXGridData(erpPopupGrid);
						if(paramData == null){
							paramData = {};
						}
						paramData["INSP_DATE"] = inspDate;
						paramData["ORGN_CD"] = orgnCd;
						paramData["SUPR_CD"] = suprCd;
						paramData["PUR_SLIP_CD"] = purSlipCd;
						paramData["PUR_TYPE"] = purType;
						paramData["MEMO"] = memo;
						
						$.ajax({
							url : "/sis/market/purchase/updateGoodsInspectionRegistList.do" //입고검수 저장
							,data : paramData
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
	
	function deleteErpPopupGrid(){
		var popCheckRows = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK"));
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
				erpPopupGrid.deleteRow(popCheckArray[j]);
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
		}
	}
	<%-- ■ erpPopupGrid 관련 Function 끝 --%>

	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	function initDhtmlXCombo(){
		var inspOrgnCd = inspInfo.ORGN_CD;
		var inspOrgnDivCd = inspInfo.ORGN_DIV_CD;
		cmbORGN_DIV_CD = inspOrgnDivCd;
		cmbORGN_CD = $erp.getDhtmlXCombo("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK",null,null,null,"MK"] , 100, null, inspOrgnCd);
		cmbORGN_CD.disable();
		
		var inspPurType = inspInfo.PUR_TYPE;
		if(inspPurType == null || inspPurType == undefined){
			cmbPUR_TYPE = $erp.getDhtmlXCombo("cmbPUR_TYPE", "PUR_TYPE", "SLIP_TYPE", 100, null);
		}else{
			cmbPUR_TYPE = $erp.getDhtmlXCombo("cmbPUR_TYPE", "PUR_TYPE", "SLIP_TYPE", 100, null, inspPurType);
			cmbPUR_TYPE.disable();
		}
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ 기타 Function 시작 --%>
	function initInspInfo(){
		var inspDate = inspInfo.INSP_DATE;
		var inspYear = inspDate.substring(0,4);
		var inspMonth = inspDate.substring(4,6);
		var inspDay = inspDate.substring(6,8);
		inspDate = inspYear + "-" + inspMonth + "-" + inspDay;
		
		document.getElementById("popInspDate").value = inspDate;
		
		if(inspInfo.PUR_SLIP_CD == ""){
			document.getElementById("hidPurSlipCd").value = "";
			document.getElementById("hidConfType").value = "";
			document.getElementById("hidSendType").value = "";
			document.getElementById("Custmr_Name").readOnly = false;
			document.getElementById("Custmr_Name").className = "input_common";
			
			document.getElementById("Custmr_Search").style.display = "inline-block";
		}else{
			document.getElementById("hidPurSlipCd").value = inspInfo.PUR_SLIP_CD;
			document.getElementById("hidConfType").value = inspInfo.CONF_TYPE;
			document.getElementById("hidSendType").value = inspInfo.SEND_TYPE;
			document.getElementById("hidCustmr_CD").value = inspInfo.CUSTMR_CD;
			document.getElementById("Custmr_Name").value = inspInfo.CUSTMR_NM;
			document.getElementById("txtMemo").value = inspInfo.MEMO;
			
			document.getElementById("Custmr_Search").style.display = "none";
			
			searchErpPopupGrid();
		}
	}
	
	function openSearchCustmrGridPopup(searchText) {
		var pur_sale_type = "1"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		var onRowSelect = function(id, ind) {
			custmr_cd = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("hidCustmr_CD").value = custmr_cd;
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			$erp.closePopup2("autoBindSearchCustmrPopup");
		}
		
		var searchParams = {};
		searchParams.SEARCH_URL = "/common/popup/getCustmrList.do";
		searchParams.SEARCH_AUTO = "Y";
		searchParams.KEY_WORD = searchText;
		searchParams.PUR_SALE_TYPE = pur_sale_type;
		searchParams.SEARCH_TYPE = "custmr";
		searchParams.USE_YN = "Y";
		
		var fnParamMap = new Map();
		fnParamMap.set("erpPopupCustmrOnRowSelect",onRowSelect);
		
		if(searchParams.KEY_WORD == undefined){
			searchParams.SEARCH_AUTO = "N";
			$erp.autoBindSearchCustmrPopup(searchParams, fnParamMap);
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
						var CustmrList = data.CustmrList;
						if(CustmrList.length == 1){
							document.getElementById("hidCustmr_CD").value = CustmrList[0].CUSTMR_CD;
							document.getElementById("Custmr_Name").value = CustmrList[0].CUSTMR_NM;
						}else{
							$erp.autoBindSearchCustmrPopup(searchParams, fnParamMap);
						}
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	function openInspPdaDataPopup() {
		var onRowDblClicked = function(id){
			var DATA_TYPE = this.cells(id, this.getColIndexById("DATA_TYPE")).getValue();
			var STORE_AREA = this.cells(id, this.getColIndexById("STORE_AREA")).getValue();
			var ORGN_CD = this.cells(id, this.getColIndexById("ORGN_CD")).getValue();
			var CDATE = this.cells(id, this.getColIndexById("CDATE")).getValue();
			
			if(ORGN_CD == "" || $erp.isEmpty(ORGN_CD)){
				$erp.alertMessage({
					"alertMessage" : "선택된 자료가 없습니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false
				});
			} else {
				$.ajax({
					url : "/sis/market/purchase/getInspPdaDataDetailList.do"
					,data : {
						"DATA_TYPE" : DATA_TYPE
						,"STORE_AREA" : STORE_AREA
						,"ORGN_CD" : ORGN_CD
						,"CDATE" : CDATE
					}
					,method : "POST"
					,dataType : "JSON"
					,success : function(data){
						erpPopupLayout.progressOff();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						} else {
							var gridDataList = data.dataMap;
							if($erp.isEmpty(gridDataList)){
								$erp.addDhtmlXGridNoDataPrintRow(
									erpPopupGrid
									,'<spring:message code="grid.noSearchData" />'
								);
							} else {
								var uid = "";
								for(var i = 0 ; i < gridDataList.length ; i++){
									uid = erpPopupGrid.uid();
									erpPopupGrid.addRow(uid);
								
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("BCD_CD")).setValue(gridDataList[i].BCD_CD);
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("SALE_QTY")).setValue(gridDataList[i].GOODS_QTY);
									
									getGoodsInformation(uid);
								}
								$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
								calculateFooterValues();
							}
						}
					}, error : function(jqXHR, textStatus, errorThrown){
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
			}
			$erp.closePopup2("openInspPdaDataPopup");
		}
		
		var params = {
			"ORGN_CD" : inspInfo.ORGN_CD
		}
		var url = "/sis/market/purchase/openInspPdaDataPopup.sis"
		var option = {
				"width" : 600
				,"height" :400
				,"resize" : false
				,"win_id" : "openInspPdaDataPopup"
		}
		
		var onContentLoaded = function(){
			var popWin = this.getAttachedObject().contentWindow;
			
			if(onRowDblClicked && typeof onRowDblClicked === 'function'){
				while(popWin.popOnRowDblClicked == undefined){
					popWin.popOnRowDblClicked = onRowDblClicked;
				}
			}
			
			this.progressOff();
		}
		
		$erp.openPopup(url, params, onContentLoaded, option);
	}
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(searchText, rowId){
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
						if(erpPopupGrid.getRowIndex(((erpPopupGridUid*1)+1)) == -1 ){
							erpPopupGridUid = addErpPopupGrid();
						}else{
							erpPopupGridUid = ((erpPopupGridUid*1)+1);
						}
					}
					erpPopupGrid.cells(erpPopupGridUid,erpPopupGrid.getColIndexById("BCD_CD")).setValue(erpGoodsPopup.cells(checkList[i], erpGoodsPopup.getColIndexById("BCD_CD")).getValue());
					getGoodsInformation(erpPopupGridUid);
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
					if(erpPopupGrid.getRowIndex(((erpPopupGridUid*1)+1)) == -1 ){
						erpPopupGridUid = addErpPopupGrid();
					}else{
						erpPopupGridUid = ((erpPopupGridUid*1)+1);
					}
				}
				
				erpPopupGrid.cells(erpPopupGridUid,erpPopupGrid.getColIndexById("BCD_CD")).setValue(this.cells(selectedRowId, this.getColIndexById("BCD_CD")).getValue());
				getGoodsInformation(erpPopupGridUid);
				
				$erp.closePopup2("autoBindSearchGoodsPopup");
			}
		}
		
		var searchParams = {};
		searchParams.SEARCH_URL = "/common/popup/getGoodsList.do";
		searchParams.SEARCH_AUTO = "Y";
		searchParams.KEY_WORD = searchText;
		searchParams.SECH_TYPE = "WORD";
		searchParams.ORGN_DIV_CD = cmbORGN_DIV_CD;
		searchParams.ORGN_CD = cmbORGN_CD.getSelectedValue();
		
		var fnParamMap = new Map();
		fnParamMap.set("erpPopupGoodsCheckList",onClickAddData);
		fnParamMap.set("erpPopupGoodsOnRowDblClicked",onRowDblClicked);
		
		if(searchParams.KEY_WORD == undefined){
			searchParams.SEARCH_AUTO = "N";
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
							erpPopupGrid.cells(rowId, erpPopupGrid.getColIndexById("BCD_CD")).setValue(GoodsList[0].BCD_CD);
							getGoodsInformation(rowId);
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
	
	function addErpPopupGrid(){
		var uid = erpPopupGrid.uid();
		erpPopupGrid.addRow(uid);
		erpPopupGrid.selectRow(erpPopupGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
		return uid;
	}
	
	function getGoodsInformation(rId) {
		var bcd_cd = erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("BCD_CD")).getValue();
		
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
					erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("BCD_NM")).setValue(data.BCD_NM);
					erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("DIMEN_NM")).setValue(data.DIMEN_NM);
					if(data.TAX_TYPE == "Y"){
						erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("TAX_YN")).setValue(data.TAX_TYPE);
					}else{
						erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("TAX_YN")).setValue("");
					}
					
					erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("BCD_CD")).setValue(data.BCD_CD);
					erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("HID_BCD_CD")).setValue(data.BCD_CD);
					
					erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("SALE_PRICE")).setValue(data.PUR_PRICE);
					
					erpPopupGrid.selectCell(rId,erpPopupGrid.getColIndexById("SALE_QTY"),false,true,true);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function enterSearchToCustmr(kcode){
		if(!document.getElementById("Custmr_Name").readOnly){
			if(kcode == 13){
				var searchText = document.getElementById("Custmr_Name").value;
				openSearchCustmrGridPopup(searchText);
			}else{
				document.getElementById("hidCustmr_CD").value = "";
			}
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
				<th>입고일자</th>
				<td>
					<input type="text" id="popInspDate" name="popInspDate" class="input_common" readonly="readonly" disabled="disabled" style="width: 65px;">
				</td>
				<th>조직명</th>
				<td>
					<div id="cmbORGN_CD"></div>
					<input type="hidden" id="hidPurSlipCd" value="">
					<input type="hidden" id="hidConfType" value="">
					<input type="hidden" id="hidSendType" value="">
				</td>
			</tr>
			<tr>
				<th>매입구분</th>
				<td>
					<div id="cmbPUR_TYPE"></div>
				</td>
				<th>협력사</th>
				<td>
					<input type="text" id="hidCustmr_CD" style="width: 80px;" class="input_common input_readonly" readonly="readonly">
					<input type="text" id="Custmr_Name" name="Custmr_Name" class="input_common input_readonly" readonly="readonly" onkeydown="enterSearchToCustmr(event.keyCode);">
					<input type="button" id="Custmr_Search" value="검 색" class="input_common_button" onclick="openSearchCustmrGridPopup();" style="display: none;">
				</td>
			</tr>
			<tr>
				<th>메모</th>
				<td colspan="3">
					<input type="text" id="txtMemo" name="txtMemo" class="input_common" style="width: 700px;" maxlength="100">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_popup_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>