<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<%-- <jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/> --%><!-- 기존 -->
<jsp:include page="/WEB-INF/jsp/common/include/default_new_window_script_header.jsp"/><!-- 대체 -->
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">
	LUI = JSON.parse('${empSessionDto.lui}');
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openTellOrderCTIPopup");
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;
	var erpPopupGridDataProcessor;
	
	var cmbMEM_TYPE;
	var cmbDELI_ORD_STATE;
	
	//사용자정의함수는 보내는 키 문자열 값과 동일해야 합니다.
	var erpOnCloseAndSearch;
	
	var param_ORGN_DIV_CD = "${param.ORGN_DIV_CD}";
	var param_ORGN_CD = "${param.ORGN_CD}";
	var param_TEL_ORD_CD = "${param.TEL_ORD_CD}";
	var param_MEM_NO = "${param.MEM_NO}";
	
	var today = $erp.getToday("-");
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("새주문서작성");
		}
		
		initErpPopupLayout();
		initErpPopupRibbon();
		initErpPopupGrid();
		
		initDhtmlXCombo();
		
		$erp.asyncObjAllOnCreated(function(){
			if(param_TEL_ORD_CD == ""){
				document.getElementById("CID_Phone_Num").focus();
			}else{
				var memListOptionArray = [];
				memListOptionArray.push({value:param_MEM_NO,text:'' ,selected: true});
				cmbMEM_NO.clearAll();
				cmbMEM_NO.addOption(memListOptionArray);
				searchMemInfo();
			}
		});
	});
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>
	function initErpPopupLayout(){
		if(param_TEL_ORD_CD == ""){
			erpPopupLayout = new dhtmlXLayoutObject({
				parent: document.body
				, skin : ERP_LAYOUT_CURRENT_SKINS
				, pattern: "5E"
				, cells: [
					{id: "a", text: "회원조회영역", header:false , fix_size:[true, true]}
					,{id: "b", text: "회원정보영역", header:false , fix_size:[true, true]}
					,{id: "c", text: "주문서정보영역", header:false , fix_size:[true, true]}
					,{id: "d", text: "리본영역", header:false , fix_size:[true, true]}
					,{id: "e", text: "그리드영역", header:false , fix_size:[true, true]}
				]
			});
			
			erpPopupLayout.cells("a").attachObject("div_erp_popup_search_table");
			erpPopupLayout.cells("a").setHeight($erp.getTableHeight(1));
			erpPopupLayout.cells("b").attachObject("div_erp_popup_memInfo_table");
			erpPopupLayout.cells("b").setHeight($erp.getTableHeight(6));
			erpPopupLayout.cells("c").attachObject("div_erp_popup_ordInfo_table");
			erpPopupLayout.cells("c").setHeight($erp.getTableHeight(3));
			erpPopupLayout.cells("d").attachObject("div_erp_popup_ribbon");
			erpPopupLayout.cells("d").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
			erpPopupLayout.cells("e").attachObject("div_erp_popup_grid");
		}else{
			erpPopupLayout = new dhtmlXLayoutObject({
				parent: document.body
				, skin : ERP_LAYOUT_CURRENT_SKINS
				, pattern: "4E"
				, cells: [
					//{id: "a", text: "회원조회영역", header:false , fix_size:[true, true]}
					{id: "a", text: "회원정보영역", header:false , fix_size:[true, true]}
					,{id: "b", text: "주문서정보영역", header:false , fix_size:[true, true]}
					,{id: "c", text: "리본영역", header:false , fix_size:[true, true]}
					,{id: "d", text: "그리드영역", header:false , fix_size:[true, true]}
				]
			});
			
			//erpPopupLayout.cells("a").attachObject("div_erp_popup_search_table");
			//erpPopupLayout.cells("a").setHeight($erp.getTableHeight(1));
			erpPopupLayout.cells("a").attachObject("div_erp_popup_memInfo_table");
			erpPopupLayout.cells("a").setHeight($erp.getTableHeight(6));
			erpPopupLayout.cells("b").attachObject("div_erp_popup_ordInfo_table");
			erpPopupLayout.cells("b").setHeight($erp.getTableHeight(3));
			erpPopupLayout.cells("c").attachObject("div_erp_popup_ribbon");
			erpPopupLayout.cells("c").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
			erpPopupLayout.cells("d").attachObject("div_erp_popup_grid");
		}
	}
	<%-- ■ erpPopupLayout 초기화 끝 --%>

	<%-- erpPopupRibbon 초기화 Function --%>
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
						,{id : "search_trade_list", type : "button", text:'지난거래내역 불러오기(F7)', isbig : false, img : "menu/open.gif", imgdis : "menu/open_dis.gif", disable : true}
						,{id : "search_goods", type : "button", text:'상품검색(F8)', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					]}
				]	
			});
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "save_erpPopupGrid"){
				saveErpPopupGrid();
			} else if(itemId == "add_erpPopupGrid"){
				addErpPopupGrid("Y");
			} else if(itemId == "delete_erpPopupGrid"){
				deleteErpPopupGrid();
			} else if(itemId == "search_trade_list"){
				openPastOrderGridPopup();
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
			,{id : "BCD_NM", label:["상품명", "#rspan"], type: "ed", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false, isSelectAll : true}
			,{id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "BCD_CD", label:["바코드", "#rspan"], type: "ed", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isSelectAll : true, maxLength : 15}
			,{id : "SALE_PRICE", label:["판매단가", "#rspan"], type: "ron", width: "70", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "SALE_QTY", label:["수량", "#rspan"], type: "edn", width: "50", sort : "int", align : "right", isHidden : false, isEssential : false, isSelectAll : true, maxLength : 5}
			//,{id : "", label:["특매할인", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "SALE_TOT_AMT", label:["판매가액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			//,{id : "", label:["계산유형", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
			//,{id : "", label:["분류", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "ORD_MEMO", label:["메모", "#rspan"], type: "ed", width: "190", sort : "str", align : "left", isHidden : false, isEssential : false, isSelectAll : true}
			,{id : "ORGN_DIV_CD", label:["법인구분", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "TEL_ORD_CD", label:["전화주문코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "ORD_STATE", label:["주문상태", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "HID_BCD_CD", label:["바코드(히든)", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
		];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupGridColumns
		});
		
		$erp.initGridCustomCell(erpPopupGrid);
		$erp.initGridComboCell(erpPopupGrid);
		erpPopupGrid.attachFooter('합계,#cspan,#cspan,#cspan,#cspan,#cspan,<div id="totalAmt" style="text-align:right; font-weight:bold; font-style:normal;">0</div>,,',["text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;"]);
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid, '<spring:message code="grid.allRowCount" />');
		
		erpPopupGridDataProcessor = new dataProcessor();
		erpPopupGridDataProcessor.init(erpPopupGrid);
		erpPopupGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpPopupGrid);
		
		erpPopupGrid.enableAccessKeyMap(true);
		
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
				this.cells(rId,this.getColIndexById("SALE_TOT_AMT")).setValue(tmpSalePrice*tmpSaleQty);
				//하단 합계 적용
				calculateFooterValues();
			}
			return true;
		});
		erpPopupGrid.attachEvent("onTab", function(mode){
			if(mode){
				if(this.getSelectedCellIndex() == this.getColIndexById("BCD_NM")){
					var searchText = this.cells(this.getSelectedRowId(),this.getColIndexById("BCD_NM")).getValue();
					if(searchText.length >= 2){
						openSearchGoodsGridPopup(searchText,this.getSelectedRowId());
					}
				}
				if(this.getSelectedCellIndex() == this.getColIndexById("ORD_MEMO")){
					addErpPopupGrid("Y");
				}
			}
			return true;
		});
	}
	
	function calculateFooterValues(stage){
	 	if(stage && stage !=2){
			return true;
	 	}
		document.getElementById("totalAmt").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("SALE_TOT_AMT")));
		return true;
	}
	
	function moneyType(amt){
		return amt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function sumColumn(ind){
		var RowIds = "";
		RowIds = erpPopupGrid.getAllRowIds();
		var arrayRowIds = [];
		arrayRowIds = RowIds.split(",");
		var out = 0;
		for(var i = 0 ;i < arrayRowIds.length ; i++){
			out+= parseFloat(erpPopupGrid.cells(arrayRowIds[i],ind).getValue());
		}
		return out;
	}
	
	function saveErpPopupGrid(dummyParam){
		var erpPopAllRowIds = erpPopupGrid.getAllRowIds();
		var erpPopAllRowArray = [];
		
		//공백 라인 삭제
		var tmpBcdCd = "";
		var tmpHidBcdCd = "";
		
		if(erpPopAllRowIds != ""){
			erpPopAllRowArray = erpPopAllRowIds.split(",");
			for(var i=0; i<erpPopAllRowArray.length; i++){
				tmpBcdCd = erpPopupGrid.cells(erpPopAllRowArray[i],erpPopupGrid.getColIndexById("BCD_CD")).getValue();
				tmpHidBcdCd = erpPopupGrid.cells(erpPopAllRowArray[i],erpPopupGrid.getColIndexById("HID_BCD_CD")).getValue();
				
				if(tmpBcdCd == "" && tmpHidBcdCd == ""){
					erpPopupGrid.deleteRow(erpPopAllRowArray[i]);
				}
			}
		}
		
		//공백 라인 삭제 후 다시 대입
		erpPopAllRowIds = erpPopupGrid.getAllRowIds();
		
		if(erpPopAllRowIds == "" || erpPopAllRowIds == "NoDataPrintRow"){
			$erp.alertMessage({
				"alertMessage" : "상품을 1개 이상 추가하여야 <br> 주문서작성이 가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
			return;
		}else{
			var isValidated = true;
			var alertMessage = "";
			var alertType = "error";
			var alertCode = "";
			
			var deliOrdState = cmbDELI_ORD_STATE.getSelectedValue();
			var deliOutDate = document.getElementById("txtDELI_OUT_DATE").value.replace(/\-/g,'');
			var memNo = cmbMEM_NO.getSelectedValue();
			var ordMemo = document.getElementById("txtORD_MEMO").value;
			
			if($erp.isEmpty(deliOutDate)){
				isValidated = false;
				alertMessage = "배송일를 지정해야 합니다.";
				alertCode = "1";
			} else if(deliOutDate < today){
				isValidated = false;
				alertMessage = "배송일은 오늘 이후여야 합니다.";
			} else if($erp.isEmpty(memNo)){
				isValidated = false;
				alertMessage = "회원지정이 필요합니다.";
			} else if(deliOrdState != "O1"){
				isValidated = false;
				alertMessage = "최초주문접수 상태의 자료만 수정 할 수 있습니다.";
			}
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					,"alertType" : alertType
					,"isAjax" : false
					,"alertCallbackFn" : function(){
						if(alertCode == "1"){
							document.getElementById("txtDELI_OUT_DATE").focus();
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
				
				//바코드 중복 검사
				var findResultArray = [];
				if(erpPopAllRowIds != ""){
					erpPopAllRowArray = erpPopAllRowIds.split(",");
					for(var i=0; i<erpPopAllRowArray.length; i++){
						tmpBcdCd = erpPopupGrid.cells(erpPopAllRowArray[i],erpPopupGrid.getColIndexById("BCD_CD")).getValue();
						findResultArray = erpPopupGrid.findCell(tmpBcdCd,erpPopupGrid.getColIndexById("BCD_CD"),false,true);
						if(findResultArray.length > 1){
							for(var j=0; j<findResultArray.length; j++){
								if(j == 0){
									continue;//첫번째 나온 값은 제외
								}
								erpPopupGrid.setCellTextStyle(findResultArray[j][0],erpPopupGrid.getColIndexById("BCD_CD"),"background-color:pink;");
							}
							alertMessage = "중복된 상품이 있습니다.";
							isValidated = false;
						}
					}
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
					$erp.confirmMessage({
						"alertMessage" : '<spring:message code="alert.common.saveData" />'
						,"alertType" : "alert"
						,"isAjax" : false
						,"alertCallbackFn" : function(){
							var paramData = {};
							var popupGridData = $erp.serializeDhtmlXGridData(erpPopupGrid, true);
							if(popupGridData == null){
								popupGridData = {};
							}
							paramData["DELI_ORD_STATE"] = deliOrdState;
							paramData["DELI_OUT_DATE"] = deliOutDate;
							paramData["MEM_NO"] = memNo;
							paramData["ORD_MEMO"] = ordMemo;
							paramData["ORGN_DIV_CD"] = LUI.LUI_orgn_div_cd;
							paramData["ORGN_CD"] = LUI.LUI_orgn_delegate_cd;
							paramData["DELI_ORD_CD"] = param_TEL_ORD_CD;//param_TEL_ORD_CD가 공백인 경우 신규주문서
							paramData["POPUP_GRID_DATA"] = popupGridData;
							
							erpPopupLayout.progressOn();
							$.ajax({
								url : "/sis/market/sales/saveOpenNewOrderPopupList.do"		// 전화주문 저장
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
										if(param_TEL_ORD_CD == ""){
											var alertMessage = "총 " + data.resultRowCnt + "건의 상품으로 주문서 작성이 완료되었습니다.";
											$erp.alertMessage({
												"alertMessage" : alertMessage
												,"alertType" : "notice"
												,"isAjax" : false
												,"alertCallbackFn" : function(){
													erpOnCloseAndSearch();
												}
											});
										}else{
											$erp.alertMessage({
												"alertMessage" : '<spring:message code="info.common.saveSuccess" />'
												,"alertType" : "notice"
												,"isAjax" : false
												,"alertCallbackFn" : function(){
													erpOnCloseAndSearch();
												}
											});
										}
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
	
	function addErpPopupGrid(useFocusTF){
		var uid = erpPopupGrid.uid();
		erpPopupGrid.addRow(uid);
		if(useFocusTF != null && useFocusTF != undefined && useFocusTF == "Y"){
			window.setTimeout(function(){
				erpPopupGrid.selectCell(erpPopupGrid.getRowIndex(uid),erpPopupGrid.getColIndexById("BCD_NM"),false,false,true);
			},1);
		}
		$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
		return uid;
	}
	
	function deleteErpPopupGrid(){
		var popupCheckRows = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK"));
		var popupCheckArray = popupCheckRows.split(",");
		if(popupCheckRows == "" || popupCheckRows == "NoDataPrintRow"){
			$erp.alertMessage({
				"alertMessage" : "error.common.noCheckedData"
				, "alertCode" : null
				, "alertType" : "notice"
			});
		}else{
			if(popupCheckArray.length == 0){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
				return;
			}
			
			for(var j = 0; j < popupCheckArray.length; j++){
				erpPopupGrid.deleteRow(popupCheckArray[j]);
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
		}
	}
	
	function searchErpPopupGrid(){
		var paramData = {};
		paramData["ORGN_DIV_CD"] = param_ORGN_DIV_CD;
		paramData["ORGN_CD"] = param_ORGN_CD;
		paramData["DELI_ORD_CD"] = param_TEL_ORD_CD;
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/market/sales/getDeliOrderInfo.do"		// 전화주문 정보 조회
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
					var ordInfo = data.dataMapHeader;
					var tbOrdData = document.getElementById("table_ord_info");
					$erp.clearDhtmlXGrid(erpPopupGrid);
					var gridDataList = data.dataMapDetail;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupGrid
							,'<spring:message code="grid.noSearchData" />'
						);
					} else {
						$erp.dataAutoBind(tbOrdData, ordInfo);
						erpPopupGrid.parse(gridDataList, 'js');
						if(ordInfo.DELI_ORD_STATE == "O1"){
							addErpPopupGrid("Y");
						}
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpPopupGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	function initDhtmlXCombo(){
		cmbMEM_TYPE = $erp.getDhtmlXCombo("cmbMEM_TYPE", "MEM_TYPE", "MEM_TYPE" , 120);
		cmbMEM_TYPE.disable();
		cmbDELI_ORD_STATE = $erp.getDhtmlXCombo("cmbDELI_ORD_STATE", "DELI_ORD_STATE", "DELI_ORD_STATE" , 120);
		cmbDELI_ORD_STATE.disable();
		cmbMEM_NO = new dhtmlXCombo("comboMemNoSpan");
		cmbMEM_NO.setSize(300);
		cmbMEM_NO.readonly(true);
		cmbMEM_NO.attachEvent("onChange",function(value,text){
			searchMemInfo();
		});
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ 기타 Function 시작 --%>
	function cidValidCheck(kcode){
		document.getElementById("cidValidMsgSpan").innerHTML = "";
		document.getElementById("hidMemNoSpan").style.display = "none";
		if(kcode == 13){
			searchMemList();
		}
	}
	
	function searchMemList() {
		
		var cidPhoneNum = document.getElementById("CID_Phone_Num").value;
		
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(cidPhoneNum) || cidPhoneNum.length < 4) {
			isValidated = false;
			alertMessage = "전화번호를 4자 이상 입력해주세요.";
		}
		
		if($erp.isLengthOver(cidPhoneNum, 50)){
			isValidated = false;
			alertMessage = "전화번호를 50자 이상 입력 할 수 없습니다.";
		} 		
		
		if(!isValidated){
			document.getElementById("cidValidMsgSpan").innerHTML = alertMessage;
		}else{
			document.getElementById("cidValidMsgSpan").innerHTML = "";
			
			erpPopupLayout.progressOn();
			$.ajax({
				url : "/sis/market/sales/getCIDMemberList.do"
				,data : {
					"TEL_NO" : cidPhoneNum
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					erpPopupLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						var memberList = data.dataList;
						if($erp.isEmpty(memberList)){
							document.getElementById("cidValidMsgSpan").innerHTML = "회원정보를 찾을 수 없습니다.";
							var tbMemData = document.getElementById("table_mem_info");
							$erp.dataClear(tbMemData);
							var tbOrdData = document.getElementById("table_ord_info");
							$erp.dataClear(tbOrdData);
							$erp.clearDhtmlXGrid(erpPopupGrid);
						}else {
							if(memberList.length == 1){
								var memListOptionArray = [];
								memListOptionArray.push({value:memberList[0].MEM_NO,text:memberList[0].MEM_NO + ' - ' + memberList[0].MEM_NM + ' - ' + memberList[0].CORP_NM ,selected: true});
								cmbMEM_NO.clearAll();
								cmbMEM_NO.addOption(memListOptionArray);
								searchMemInfo();
							}else{
								var memListOptionArray = [];
								memListOptionArray.push({value: "", text: "선택" ,selected: true});
								for (var i = 0; i<memberList.length; i++){
									memListOptionArray.push({value:memberList[i].MEM_NO,text:memberList[i].MEM_NO + ' - ' + memberList[i].MEM_NM + ' - ' + memberList[i].CORP_NM});
								}
								cmbMEM_NO.clearAll();
								cmbMEM_NO.addOption(memListOptionArray);
								document.getElementById("hidMemNoSpan").style.display = "inline-flex";
								cmbMEM_NO.setFocus();
							}
						}
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	function searchMemInfo(){
		var memNo = cmbMEM_NO.getSelectedValue();
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/market/sales/getCIDMemberInfo.do"
			,data : {
				"MEM_NO" : memNo
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var memberInfo = data.dataMap;
					var tbMemData = document.getElementById("table_mem_info");
					$erp.dataClear(tbMemData);
					var tbOrdData = document.getElementById("table_ord_info");
					$erp.dataClear(tbOrdData);
					$erp.clearDhtmlXGrid(erpPopupGrid);
					if($erp.isEmpty(memberInfo)){
						document.getElementById("cidValidMsgSpan").innerHTML = "회원정보를 찾을 수 없습니다.";
					}else {
						$erp.dataAutoBind(tbMemData, memberInfo);
						if(param_TEL_ORD_CD == ""){
							document.getElementById("txtDELI_ORD_DATE").value = today;
							document.getElementById("txtDELI_OUT_DATE").value = today;
							addErpPopupGrid("Y");
						}else{
							searchErpPopupGrid();
						}
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
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
		
		var onKeyDownEsc = function(kcode){
			if(kcode == 27){//esc
				window.setTimeout(function(){
					erpPopupGrid.selectCell(erpPopupGrid.getRowIndex(erpPopupGrid.getSelectedRowId()),erpPopupGrid.getColIndexById("BCD_CD"),false,false,true);
				},1);
				$erp.closePopup2("autoBindSearchGoodsPopup");
			}
			return true;
		}
		
		var searchParams = {};
		searchParams.SEARCH_URL = "/common/popup/getGoodsList.do";
		searchParams.SEARCH_AUTO = "Y";
		searchParams.KEY_WORD = searchText;
		searchParams.SECH_TYPE = "WORD";
		searchParams.ORGN_DIV_CD = LUI.LUI_orgn_div_cd;
		searchParams.ORGN_CD = LUI.LUI_orgn_delegate_cd;
		
		var fnParamMap = new Map();
		fnParamMap.set("erpPopupGoodsCheckList",onClickAddData);
		fnParamMap.set("erpPopupGoodsOnRowDblClicked",onRowDblClicked);
		fnParamMap.set("erpPopupGoodsOnKeyDownEsc",onKeyDownEsc);
		
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
	
	function getGoodsInformation(rId) {
		var bcd_cd = erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("BCD_CD")).getValue();
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/standardInfo/goods/getGoodsInformationFromBarcode.do"
			,data : {
				"BCD_CD" : bcd_cd
				,"ORGN_CD" : LUI.LUI_orgn_delegate_cd
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
					
					erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("BCD_CD")).setValue(data.BCD_CD);
					erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("HID_BCD_CD")).setValue(data.BCD_CD);
					
					erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("SALE_PRICE")).setValue(data.SALE_PRICE);
					window.setTimeout(function(){
						erpPopupGrid.selectCell(erpPopupGrid.getRowIndex(rId),erpPopupGrid.getColIndexById("SALE_QTY"),false,false,true);
					},1);
					
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function openPastOrderGridPopup(rowId) {
		
		var memNo = cmbMEM_NO.getSelectedValue();
		
		//회원지정이 되었을 경우에만 실행
		if($erp.isEmpty(memNo)){
			$erp.alertMessage({
				"alertMessage" : "회원 선택 후 검색이 가능합니다."
				,"alertCode" : null
				,"alertType" : "alert"
				,"isAjax" : false
			});
			return;
		}else{
			
			var onCloseAndSearch = function(){
				//searchErpMainGrid();
				$erp.closePopup2("openPastOrderGridPopup");
			}
			
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
					$erp.closePopup2("openPastOrderGridPopup");
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
					
					$erp.closePopup2("openPastOrderGridPopup");
				}
			}
			
			var onKeyDownEsc = function(kcode){
				if(kcode == 27){//esc
					window.setTimeout(function(){
						erpPopupGrid.selectCell(erpPopupGrid.getRowIndex(erpPopupGrid.getSelectedRowId()),erpPopupGrid.getColIndexById("BCD_CD"),false,false,true);
					},1);
					$erp.closePopup2("openPastOrderGridPopup");
				}
				return true;
			}
			
			var searchParams = {};
			searchParams["MEM_NO"] = memNo;
			searchParams["ORGN_DIV_CD"] = LUI.LUI_orgn_div_cd;
			searchParams["ORGN_CD"] = LUI.LUI_orgn_delegate_cd;
			
			var fnParamMap = new Map();
			fnParamMap.set("erpOnCloseAndSearch",onCloseAndSearch);
			fnParamMap.set("erpOnClickAddData",onClickAddData);
			fnParamMap.set("erpOnRowDblClicked",onRowDblClicked);
			fnParamMap.set("erpOnKeyDownEsc",onKeyDownEsc);
			
			openPastOrderGridPopupCall(searchParams, fnParamMap);
		}
	}
	
	openPastOrderGridPopupCall = function(searchParams, fnParamMap) {
		var url = "/sis/market/sales/openPastOrderGridPopup.sis";
		var option = {
				"width" : 966
				,"height" :400
				,"win_id" : "openPastOrderGridPopup"
		}
		
		var onContentLoaded = function(){
			var popWin = this.getAttachedObject().contentWindow;
			var fnParamKeys = fnParamMap.keys();
			var userDefinedFnKey;
			var userDefinedFnValue;
			do{
				userDefinedFnKey = fnParamKeys.next();
				userDefinedFnValue = fnParamMap.get(userDefinedFnKey.value);
				if(userDefinedFnValue && typeof userDefinedFnValue === 'function'){
					while(popWin[userDefinedFnKey.value] == undefined){
						popWin[userDefinedFnKey.value] = userDefinedFnValue;
					}
				}
			}while(!userDefinedFnKey.done);
			
			this.progressOff();
		}
		
		$erp.openPopup(url, searchParams, onContentLoaded, option);
	}
	<%-- ■ 기타 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_popup_search_table" class="samyang_div" style="display:none">
		<table class = "table">
			<colgroup>
				<col width="100px"/>
				<col width="140px"/>
				<col width="80px"/>
				<col width="140px"/>
				<col width="80px"/>
				<col width="*px"/>
			</colgroup>
			<tr>
				<th>주문자전화번호</th>
				<td colspan="5">
					<input type="text" id="CID_Phone_Num" name="CID_Phone_Num" class="input_common" style="width: 120px;" placeholder="입력하세요" onkeydown="cidValidCheck(event.keyCode);">
					<input type="button" id="input_phone_num" name="input_phone_num" value="회원검색" class="input_common_button" onclick="searchMemList()">
					<span id="hidMemNoSpan" style="display: none;"><span id="comboMemNoSpan"></span></span>
					<span id="cidValidMsgSpan"></span>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_popup_memInfo_table" class="samyang_div" style="display:none">
		<table id = "table_mem_info" class = "table">
			<colgroup>
				<col width="100px"/>
				<col width="140px"/>
				<col width="80px"/>
				<col width="140px"/>
				<col width="80px"/>
				<col width="*px"/>
			</colgroup>
			<tr>
				<th colspan="6" style="text-align: center;">회원정보</th>
			</tr>
			<tr>
				<th>회원명</th>
				<td>
					<input type="hidden" id="txtORGN_CD" name="ORGN_CD" class="input_common input_readonly"readonly="readonly" >
					<input type="hidden" id="txtMEM_NO" name="MEM_NO" class="input_common input_readonly" readonly="readonly" >
					<input type="text" id="txtMEM_NM" name="MEM_NM" class="input_common input_readonly" readonly="readonly" style="width: 120px;">
				</td>
				<th>상호명</th>
				<td>
					<input type="text" id="txtCORP_NM" name="CORP_NM" class="input_common input_readonly" readonly="readonly" style="width: 120px;">
				</td>
				<th>회원유형</th>
				<td>
					<div id="cmbMEM_TYPE"></div>
				</td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td colspan="3">
					<input type="text" id="txtTEL_NO" name="TEL_NO" class="input_common input_readonly" readonly="readonly" style="width: 340px;">
				</td>
				<th>외상건수</th>
				<td>
					<input type="text" id="txtTRUST_CNT" name="TRUST_CNT" class="input_common input_readonly" readonly="readonly" style="width: 120px;">&nbsp;건
				</td>
			</tr>
			<tr>
				<th>우편번호</th>
				<td colspan="5">
					<input type="text" id="txtDELI_ZIP_NO" name="DELI_ZIP_NO" class="input_common input_readonly" readonly="readonly" style="width: 120px;">
				</td>
			</tr>
			<tr>
				<th>배송지주소</th>
				<td colspan="5">
					<input type="text" id="txtADDR" name="ADDR" class="input_common input_readonly" readonly="readonly" style="width: 500px;">
				</td>
			</tr>
			<tr>
				<th>배송설명</th>
				<td colspan="5">
					<input type="text" id="txtDELI_MEMO" name="DELI_MEMO" class="input_common input_readonly" readonly="readonly" style="width: 500px;">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_popup_ordInfo_table" class="samyang_div" style="display:none">
		<table id = "table_ord_info" class = "table">
			<colgroup>
				<col width="100px"/>
				<col width="140px"/>
				<col width="80px"/>
				<col width="140px"/>
				<col width="80px"/>
				<col width="*px"/>
			</colgroup>
			<tr>
				<th colspan="6" style="text-align: center;">주문서정보</th>
			</tr>
			<tr>
				<th>주문상태</th>
				<td>
					<div id="cmbDELI_ORD_STATE"></div>
				</td>
				<th>주문일시</th>
				<td>
					<input type="text" id="txtDELI_ORD_DATE" name="DELI_ORD_DATE" class="input_common" readonly="readonly" disabled="disabled" style="width: 65px;">
				</td>
				<th>배송일</th>
				<td>
					<input type="text" id="txtDELI_OUT_DATE" name="DELI_OUT_DATE" class="input_common input_calendar" style="margin-left:10px;">
				</td>
			</tr>
			<tr>
				<th>주문서메모</th>
				<td colspan="5">
					<input type="text" id="txtORD_MEMO" name="ORD_MEMO" class="input_common" style="width: 500px;">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_popup_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>