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
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openNewOrderPopup");
	var Mem_Info = JSON.parse('${param.memberInfo}');
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;
	var erpGridDataProcessor;
	var cmbMEM_TYPE;
	var All_checkList = "";
	var Code_List = "";
	var popOnCloseAndSearch;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("새주문서작성");
		}
		
		initErpPopupLayout();
		initErpPopupRibbon();
		initErpPopupGrid();
		initDhtmlXCombo();
		initMemInfo();
	});
	
	<%-- ■ erpPopupLayout 초기화 시작 --%>
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "회원정보", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "그리드영역", header:false}
			]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_member_info");
		erpPopupLayout.cells("a").setHeight(116);
		erpPopupLayout.cells("b").attachObject("div_erp_order_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_popup_grid");
		
		
		erpPopupLayout.setSeparatorSize(0, 2);
		erpPopupLayout.setSeparatorSize(1, 2);
	}
	<%-- ■ erpPopupLayout 초기화 끝 --%>

	<%-- ■ erpPopupRibbon 관련 Function 시작 --%>
	<%-- erpPopupRibbon 초기화 Function --%>
	function initErpPopupRibbon(){
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_order_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{type : "block", mode : 'rows', list : [
						{id : "save_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
						, {id : "delete_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						, {id : "search_trade_list", type : "button", text:'지난거래내역 불러오기', isbig : false, img : "menu/open.gif", imgdis : "menu/open_dis.gif", disable : true}
						, {id : "search_goods", type : "button", text:'상품검색', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					]}
				]	
			});
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "save_erpPopupGrid"){
				saveErpGrid();
			} else if(itemId == "delete_erpPopupGrid"){
				deleteErpPopupGrid();
			} else if(itemId == "search_trade_list"){
				openTradeStatementGridPopup();
			} else if(itemId == "search_goods"){
				openSearchGoodsGridPopup();
			}
		});
	}
	<%-- ■ erpPopupRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpPopupGrid 관련 Function 시작 --%>
	function initErpPopupGrid(){
		erpPopupGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_QTY", label:["수량", "#rspan"], type: "edn", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false, isSelectAll : true, maxLength : 5}
			, {id : "SALE_PRICE", label:["단가", "#rspan"], type: "ron", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "PAY_SUM_AMT", label:["금액", "#rspan"], type: "edn[=c3*c4]", width: "150", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "BCD_CD", label:["바코드코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "GOODS_FEE_RATE", label:["부가세율(%)", "#rspan"], type: "ro", width: "150", sort : "int", align : "right", isHidden : true, isEssential : false}
			, {id : "SALE_VAT_TOT_AMT", label:["부가세액", "#rspan"], type: "edn[=c3*c4*(c8/100)]", width: "150", sort : "int", align : "right", isHidden : true, isEssential : false}
			];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupGridColumns
		});
		erpPopupGrid.enableDistributedParsing(true, 100, 50);
		erpPopupGrid.attachEvent("onEditCell",calculateFooterValues);
		erpPopupGrid.attachFooter('합계,#cspan,#cspan,#cspan,#cspan,<div id="totalAmt" style="text-align:right; font-weight:bold; font-style:normal;">0</div>',["text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;"]);
		$erp.initGridCustomCell(erpPopupGrid);
		$erp.initGridComboCell(erpPopupGrid);
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid, 20);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpPopupGrid);
		erpGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpPopupGrid);
		
		erpPopupGrid.enableAccessKeyMap(true);
	}
	
	function calculateFooterValues(stage){
	 	if(stage && stage !=2){
			return true;
	 	}
		document.getElementById("totalAmt").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("PAY_SUM_AMT")));
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
	
	function initMemInfo(){
		document.getElementById("txtMem_Name").value = Mem_Info.Mem_Name;
		document.getElementById("txtMem_No").value = Mem_Info.Mem_No;
		document.getElementById("txtMem_Tel").value = Mem_Info.Mem_Tel;
		document.getElementById("txtMem_Trust_Cnt").value = Mem_Info.Mem_Trust_Cnt;
		document.getElementById("txtMem_Zip_No").value = Mem_Info.Mem_Zip_No;
		document.getElementById("txtMem_Addr").value = Mem_Info.Mem_Addr;
	}

	<%-- ■ erpPopupGrid 관련 Function 끝 --%>
	
	<%-- erpPopupGrid 삭제 Function --%>
	function deleteErpPopupGrid(){
		var gridRowCount = erpPopupGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		
		var deleteRowIdArray = [];
		var check = "";
		
		if(RowCountArray[0] != ""){
			for(var i = 0 ; i < RowCountArray.length ; i++){
				check = erpPopupGrid.cells(RowCountArray[i], erpPopupGrid.getColIndexById("CHECK")).getValue();
				if(check == "1"){
					deleteRowIdArray.push(RowCountArray[i]);
				}
			}
		}
		
		if(deleteRowIdArray.length == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}else {
			$erp.confirmMessage({
				"alertMessage" : "선택하신 상품을 정말 삭제하시겠습니까?"
				, "alertCode" : ""
				, "alertType" : alert
				, "alertCallbackFn" : function deleteConfirm(){
					if(deleteRowIdArray.length != 0){
						for(var j = 0; j < deleteRowIdArray.length; j++){
							erpPopupGrid.deleteRow(deleteRowIdArray[j]);
						}
						$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
					}
				}
			});
		}
	}
	
	function saveErpGrid(){
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
		
		var Row_Cnt = erpPopupGrid.getRowsNum();
		
		if(Row_Cnt == 0){
			$erp.alertMessage({
				"alertMessage" : "상품을 1개 이상 추가하여야 <br> 주문서작성이 가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		} else {
			erpPopupLayout.progressOn();
			
			var paramData = $erp.serializeDhtmlXGridData(erpPopupGrid);
			paramData["MEM_NO"] = Mem_Info.Mem_No;
			paramData["ORD_MEMO"] = document.getElementById("txtORD_MEMO").value;
			
			$.ajax({
				url : "/sis/market/sales/saveNewOrderPopupList.do"  
				,data : paramData
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					erpPopupLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						var alertMessage = "총 " + data.DetailResultRow + "건의 상품으로 주문서 작성이 완료되었습니다.";
						$erp.alertMessage({
							"alertMessage" : alertMessage,
							"alertCode" : null,
							"alertType" : "alert",
							"isAjax" : false,
							"alertCallbackFn" : function CloseNewOrderPopup(){
								popOnCloseAndSearch();
								$erp.closePopup2("openNewOrderPopup");
							}
						});
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
			erpPopupLayout.progressOff();
		}
	}
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(){
		var onClickAddData = function(erpGoodsGrid) {
		    var isValidated = true;
			var alertMessage = "";
			var alertCode = "";
			var alertType = "error";
			
			var check = erpGoodsGrid.getCheckedRows(erpGoodsGrid.getColIndexById("CHECK")); // 조회된 그리드내역 중 선택한 row 번호 문자열로 넘어옴 ex) 1,5,7,10
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					, "alertCode" : alertCode
					, "alertType" : alertType
				});
			}else{
				var checkList = check.split(',');
				var last_list_num = checkList.length - 1;
			
				for(var i = 0 ; i < checkList.length ; i ++) {
					if(i != checkList.length - 1) {
						All_checkList += erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("BCD_NM")).getValue() + ",";
						Code_List += erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("GOODS_NO")).getValue() + ",";
					} else {
						All_checkList += erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("BCD_NM")).getValue();
						Code_List += erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("GOODS_NO")).getValue();
					}
					
					$.ajax({
						url : "/sis/market/sales/getNewOrderListInfo.do"
						,data : {
							"BCD_CD" : erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("BCD_CD")).getValue()
							, "GOODS_NO" : erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("GOODS_NO")).getValue()
						}
						,method : "POST"
						,dataType : "JSON"
						,success : function(data){
							erpPopupLayout.progressOff();
							if(data.isError){
								$erp.ajaxErrorMessage(data);
							} else {
								var gridDataList = data.gridDataList;
								if($erp.isEmpty(gridDataList)){
									$erp.addDhtmlXGridNoDataPrintRow(
											erpPopupGrid
										,  '<spring:message code="grid.noSearchData" />'
									);
								} else {
									var uid = erpPopupGrid.uid();
									erpPopupGrid.addRow(uid);
								
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("GOODS_NO")).setValue(gridDataList[0].GOODS_NO);
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("BCD_NM")).setValue(gridDataList[0].BCD_NM);
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("BCD_CD")).setValue(gridDataList[0].BCD_CD);
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("SALE_QTY")).setValue("1");
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("SALE_PRICE")).setValue(gridDataList[0].SALE_PRICE);
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("GOODS_FEE_RATE")).setValue(gridDataList[0].GOODS_FEE_RATE);
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("PAY_SUM_AMT")).setValue(gridDataList[0].SALE_PRICE); 
									$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
								}
							}
						}, error : function(jqXHR, textStatus, errorThrown){
							$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
						}
					});
				}
				$erp.closePopup2("openSearchGoodsGridPopup");
			}
		}
		$erp.openSearchGoodsPopup(null,onClickAddData, {"ORGN_DIV_CD" : Mem_Info.ORGN_DIV_CD, "ORGN_CD" : Mem_Info.ORGN_CD});
	}
	
	function initDhtmlXCombo(){
		var Mem_Type = Mem_Info.Mem_Type;
		cmbMEM_TYPE = $erp.getDhtmlXCombo("cmbMem_Type", "Mem_Type", "Mem_Type" , 100, null, Mem_Type);
		cmbMEM_TYPE.disable();
	}
	
	function openTradeStatementGridPopup() {
		var onRowDblClicked = function(id){
			var TEL_ORD_CD = "";
			TEL_ORD_CD = this.cells(id, this.getColIndexById("TEL_ORD_CD")).getValue();
			
			if(TEL_ORD_CD == "" || $erp.isEmpty(TEL_ORD_CD)){
				$erp.alertMessage({
					"alertMessage" : "선택된 거래내역이 없습니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false
				});
			} else {
				$.ajax({
					url : "/sis/market/sales/getMemOrderDetailList.do"
					,data : {
						"TEL_ORD_CD" : TEL_ORD_CD
						, "ORGN_CD" : Mem_Info.ORGN_CD
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
									,  '<spring:message code="grid.noSearchData" />'
								);
							} else {
								var uid = "";
								for(var i = 0 ; i < gridDataList.length ; i++){
									uid = erpPopupGrid.uid();
									erpPopupGrid.addRow(uid);
								
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("BCD_NM")).setValue(gridDataList[i].BCD_NM);
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("SALE_QTY")).setValue(gridDataList[i].SALE_QTY);
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("SALE_PRICE")).setValue(gridDataList[i].SALE_PRICE);
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("PAY_SUM_AMT")).setValue(gridDataList[i].SALE_TOT_AMT);
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("BCD_CD")).setValue(gridDataList[i].BCD_CD); 
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("GOODS_NO")).setValue(gridDataList[i].GOODS_NO); 
									erpPopupGrid.cells(uid, erpPopupGrid.getColIndexById("GOODS_FEE_RATE")).setValue(gridDataList[i].GOODS_FEE_RATE);
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
			$erp.closePopup2("openTradeStatementGridPopup");
		}
		
		var params = {
			"Mem_Info" : '${param.memberInfo}'
		}
		var url = "/sis/market/sales/openTradeStatementGridPopup.sis";
		var option = {
				"width" : 600
				,"height" :400
				,"resize" : false
				,"win_id" : "openTradeStatementGridPopup"
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
	
</script>
</head>
<body>
	<div id="div_erp_order_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_member_info" class="samyang_div" style="diplay:none;">
			<table id="table_mem_info" class="table" >
				<colgroup>
					<col width="60px">
					<col width="120px">
					<col width="60px">
					<col width="210px">
					<col width="60px">
					<col width="120px">
					<col width="60px">
					<col width="*">
				</colgroup>
				<tr>
					<th colspan="8" style="text-align: center;">회원정보</th>
				</tr>
				<tr>
					<th>회원명</th>
					<td>
						<input type="hidden" id="txtORGN_CD" name="ORGN_CD" class="input_common input_readonly" readonly="readonly">
						<input type="hidden" id="txtMem_No" name="Mem_No" class="input_common input_readonly" readonly="readonly">
						<input type="text" id="txtMem_Name" name="Mem_Name" class="input_common input_readonly" readonly="readonly" style="width: 100px;">
					</td>
					<th>전화번호</th>
					<td>
						<input type="text" id="txtMem_Tel" name="Mem_Tel" class="input_common input_readonly" readonly="readonly" style="width: 190px;">
					</td>
					<th>회원유형</th>
					<td>
						<div id="cmbMem_Type" ></div>
					</td>
					<th>외상건수</th>
					<td style="font-weight:bold;">
						<input type="text" id="txtMem_Trust_Cnt" name="Mem_Trust_Cnt" class="input_common input_readonly" readonly="readonly" style="width: 100px; text-align: right;">건
					</td>
				</tr>
				<tr>
					<th>우편번호</th>
					<td>
						<input type="text" id="txtMem_Zip_No" name="Mem_Zip_No" class="input_common input_readonly" readonly="readonly" style="width: 100px;">
					</td>
					<th>주소</th>
					<td colspan="5">
						<input type="text" id="txtMem_Addr" name="Mem_Addr" class="input_common input_readonly" readonly="readonly" style="width: 350px;">
					</td>
				</tr>
				<tr>
					<th>배송메모</th>
					<td colspan="5">
						<input type="text" id="txtORD_MEMO" name="txtORD_MEMO" class="input_common" style="width: 350px;" maxlength="100">
					</td>
				</tr>
			</table>
		</div>
	<div id="div_erp_popup_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>