<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">

	var erpPopupWindowsCell = parent.erpPopupWindows.window("openPosManagerInfoPopup");
	var param_CLSE_INFO = JSON.parse('${param.CLSE_INFO}');
	console.log(param_CLSE_INFO);
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var erpPopupClose;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("마감정보");
		}
		
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initErpSubLayout1();
		initErpSubLayout2();
		initErpSubLayout3();
		initClseInfo();
		searchErpGrid();
		
	});
	

	<%-- ■ erpLayout 초기화 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "5E"
			, cells : [
				{id: "a", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "담당자정보", header:false, fix_size : [true, true]}
				,{id: "c", text: "마감정보1", header:false, fix_size : [true, true]}
				,{id: "d", text: "마감정보2", header:false, fix_size : [true, true]}
				,{id: "e", text: "알림정보", header:false, fix_size : [true, true]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_ribbon");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_table_1");
		erpLayout.cells("b").setHeight(60);
		erpLayout.cells("c").attachObject("div_erp_table_2");
		erpLayout.cells("c").setHeight(255);
		erpLayout.cells("d").attachObject("div_erp_table_3");
		erpLayout.cells("d").setHeight(310);
		erpLayout.cells("e").attachObject("div_erp_table_4");
		erpLayout.cells("e").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
	}
	<%-- ■ erpLayout 초기화 끝 --%>
	
	<%-- ■ erpSubLayout1 관련 Function 시작 --%>
	<%-- erpSubLayout1 초기화 Function --%>
	function initErpSubLayout1(){
		erpSubLayout1 = new dhtmlXLayoutObject({
			parent: "div_erp_table_2"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3W"
			, cells: [
				{id: "a", text: "판매내역", header:true, fix_size : [true, true]}
				, {id: "b", text: "반품내역", header:true, fix_size : [true, true]}
				, {id: "c", text: "매출합계", header:true, fix_size : [true, true]}
			]		
		});
		erpSubLayout1.cells("a").attachObject("div_erp_table_2_1");
		erpSubLayout1.cells("a").setHeight(230);
		erpSubLayout1.cells("b").attachObject("div_erp_table_2_2");
		erpSubLayout1.cells("b").setHeight(230);
		erpSubLayout1.cells("c").attachObject("div_erp_table_2_3");
		erpSubLayout1.cells("c").setHeight(230);
		
	}	
	<%-- ■ erpSubLayout1 관련 Function 끝 --%>
	
	<%-- ■ erpSubLayout2 관련 Function 시작 --%>
	<%-- erpSubLayout2 초기화 Function --%>
	function initErpSubLayout2(){
		erpSubLayout2 = new dhtmlXLayoutObject({
			parent: "div_erp_table_3"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3W"
			, cells: [
				{id: "a", text: "기타정보", header:true, fix_size : [true, true]}
				, {id: "b", text: "상품권", header:true, fix_size : [true, true]}
				, {id: "c", text: "현금", header:true, fix_size : [true, true]}
			]		
		});
		erpSubLayout2.cells("a").attachObject("div_erp_table_3_1");
		erpSubLayout2.cells("a").setHeight(300);
		erpSubLayout2.cells("b").attachObject("div_erp_table_3_2");
		erpSubLayout2.cells("b").setHeight(300);
		erpSubLayout2.cells("c").attachObject("div_erp_table_3_3");
		erpSubLayout2.cells("c").setHeight(300);
		
	}	
	<%-- ■ erpSubLayout2 관련 Function 끝 --%>
	
	<%-- ■ erpSubLayout3 관련 Function 시작 --%>
	<%-- erpSubLayout3 초기화 Function --%>
	function initErpSubLayout3(){
		erpSubLayout3 = new dhtmlXLayoutObject({
			parent: "div_erp_table_3_2"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "상품권정보", header:false, fix_size : [true, true]}
				, {id: "b", text: "상품권그리드", header:false, fix_size : [true, true]}
			]		
		});
		erpSubLayout3.cells("a").attachObject("div_erp_table_3_2_1");
		erpSubLayout3.cells("a").setHeight(140);
		erpSubLayout3.cells("b").attachObject("div_erp_table_3_2_2");
		erpSubLayout3.cells("b").setHeight(160);
		
	}	
	<%-- ■ erpSubLayout3 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "BCD_CD", label:["상품권명", "#rspan"], type: "ro", width: "110", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "CUSTMR_NM", label:["액면가", "#rspan"], type: "ro", width: "90", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "BCD_NM", label:["매수", "#rspan"], type: "ro", width: "50", sort : "str", align : "center", isHidden : false, isEssential : true}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_table_3_2_2"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		
		erpGrid.enableDistributedParsing(true, 100, 50);
		erpGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
	
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- erpLayout 내용 조회 Function --%>
	function searchErpGrid(){
		
		var paramData ={};
		paramData["CLSE_CD"] = $("#txtCLSE_CD").val();
		
		$.ajax({
			url: "/common/popup/getGiftCardList.do"
			, data : paramData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpGrid);
					var gridDataList = data.gridDataList;
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
				erpLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	function initErpRibbon() {
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false}
					, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : false}	
					]}
			]
		});	
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "save_erpGrid"){
				saveErp();
			}else if (itemId == "print_erpGrid"){
				$erp.alertMessage({
					"alertMessage" : "준비중입니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false,
				});
			}
		});
	}

	<%-- erpLayout 저장 Function --%>
	function saveErp(){
		
		erpLayout.progressOn();
		
		var send_data = $erp.dataSerialize("table_3_3");
		console.log(send_data);
		
		$.ajax({
			url : "/common/popup/savePosManagementInfo.do"  
			,data : send_data
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var alertMessage = "저장이 완료되었습니다.";
					$erp.alertMessage({
						"alertMessage" : alertMessage,
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
			
		});
	}
		
	<%-- 부모창에서 받아온 paramMap 내용 조회 Function --%>
	function initClseInfo(){
		$erp.dataAutoBind("table_1", param_CLSE_INFO);
		$erp.dataAutoBind("table_2_1", param_CLSE_INFO);
		$erp.dataAutoBind("table_2_2", param_CLSE_INFO);
		$erp.dataAutoBind("table_2_3", param_CLSE_INFO);
		$erp.dataAutoBind("table_3_1", param_CLSE_INFO);
		$erp.dataAutoBind("table_3_2_1", param_CLSE_INFO);
		$erp.dataAutoBind("table_3_3", param_CLSE_INFO);
	}
	
	<%-- 현금 과부족 계산 Function --%>
	function call(){
		var cash_face_price= parseInt($("#txtCASH_FACE_PRICE").val() || 0); 
		var sale_cash_tot_amt = parseInt($("#txtSALE_CASH_TOT_AMT").val() || 0); 
		var in_cash_loss_amt = sale_cash_tot_amt - cash_face_price; 
		
		$("#txtIN_CASH_LOSS_AMT").val(in_cash_loss_amt);
	}
	
	<%-- openAddDepositCashPopup 현금입금액 입력 팝업 열림 Function --%>
	function openAddDepositCashPopup(){
		var CLSE_CD = document.getElementById("txtCLSE_CD").value;
		var ORGN_CD = document.getElementById("txtORGN_CD").value;
		
		var onClickAddData = function(SALE_CASH_TOT_AMT) {
			$("#txtSALE_CASH_TOT_AMT").val(SALE_CASH_TOT_AMT);
			$erp.closePopup2("openAddDepositCashPopup");
		}
		$erp.openAddDepositCashPopup(onClickAddData, CLSE_CD, ORGN_CD);
	}
	
</script>
</head>
<body>
	<div id="div_erp_ribbon" class="samyang_div" style="display: none;"></div>
	<div id="div_erp_table_1" class="samyang_div" style="display: none;">
		<table id="table_1" class="table">
			<tr>
				<th colspan ="1" style="text-align:left;">단말번호 : </th>
				<td colspan ="1">
					<input type="text" id="txtTRML_CD" name="txtTRML_CD" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 95px;">
				</td>
				<th colspan ="1" style="text-align:left;">담당자 : </th>
				<td colspan ="1">
					<input type="text" id="txtEMP_NM" name="txtEMP_NM" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 95px;">
				</td>
				<th colspan ="1" style="text-align:left;">마감일시 : </th>
				<td colspan ="2">
					<input type="text" id="txtCLSE_REG_DATE" name="txtCLSE_REG_DATE" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 210px;">
				</td>
			</tr>
			<tr>
				<th colspan ="1" style="text-align:left;">개설일시 : </th>
				<td colspan ="1">
					<input type="text" id="txtOPEN_DATE_TIME" name="txtOPEN_DATE_TIME" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 95px;">
				</td>
				<th colspan ="1" style="text-align:left;">정산일시 : </th>
				<td colspan ="4">
					<input type="text" id="txtCLSE_DATE_TIME" name="txtCLSE_DATE_TIME" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 95px;">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_table_2" class="samyang_div" style="display: none;">
		<div id="div_erp_table_2_1" class="samyang_div" style="display: none;">
			<table id="table_2_1" class="table">
				<colgroup>
					<col width="100px">
					<col width="*px">
				</colgroup>
				<tr>
					<th style="text-align:left;">현금 : </th>
					<td>
						<input type="text" id="txtSALE_CASH_AMT" name="txtSALE_CASH_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
				<tr>
					<th style="text-align:left;">카드 : </th>
					<td>
						<input type="text" id="txtSALE_CARD_AMT" name="txtSALE_CARD_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">상품권 : </th>
					<td>
						<input type="text" id="txtSALE_GIFT_AMT" name="txtSALE_GIFT_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">포인트 : </th>
					<td>
						<input type="text" id="txtSALE_POINT_AMT" name="txtSALE_POINT_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">외상 : </th>
					<td>
						<input type="text" id="txtTRUST_SALE_AMT" name="txtTRUST_SALE_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
					<tr>
					<th style="text-align:left;">임의등록카드 : </th>
					<td>
						<input type="text" id="txtSALE_CARD_TMP_AMT" name="txtSALE_CARD_TMP_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">판매액합계 : </th>
					<td>
						<input type="text" id="txtTOT_SALE_AMT" name="txtSALE_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">판매건수 : </th>
					<td>
						<input type="text" id="txtTOT_SALE_CNT" name="txtSALE_CNT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>	
			</table>
		</div>
		<div id="div_erp_table_2_2" class="samyang_div" style="display: none;">
			<table id="table_2_2" class="table">
			<colgroup>
					<col width="100px">
					<col width="*px">
				</colgroup>
				<tr>
					<th style="text-align:left;">현금 : </th>
					<td>
						<input type="text" id="txtRETN_CASH_AMT" name="txtRETN_CASH_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
				<tr>
					<th style="text-align:left;">카드 : </th>
					<td>
						<input type="text" id="txtRETN_CARD_AMT" name="txtRETN_CARD_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">상품권 : </th>
					<td>
						<input type="text" id="txtRETN_GIFT_AMT" name="txtRETN_GIFT_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">포인트 : </th>
					<td>
						<input type="text" id="txtRETN_POINT_AMT" name="txtRETN_POINT_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">외상 : </th>
					<td>
						<input type="text" id="txtTRUST_RETN_AMT" name="txtTRUST_RETN_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
					<tr>
					<th style="text-align:left;">임의등록반품 : </th>
					<td>
						<input type="text" id="txtRETN_TMP_CARD_AMT" name="txtRETN_TMP_CARD_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">반품액합계 : </th>
					<td>
						<input type="text" id="txtTOT_RETN_AMT" name="txtRETN_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">반품건수 : </th>
					<td>
						<input type="text" id="txtTOT_RETN_CNT" name="txtRETN_CNT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>	
			</table>
		</div>
		<div id="div_erp_table_2_3" class="samyang_div" style="display: none;">
			<table id="table_2_3" class="table">
			<colgroup>
					<col width="100px">
					<col width="*px">
				</colgroup>
				<tr>
					<th style="text-align:left;">현금 : </th>
					<td>
						<input type="text" id="txtCASH_AMT" name="txtCASH_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
				<tr>
					<th style="text-align:left;">카드 : </th>
					<td>
						<input type="text" id="txtCARD_AMT" name="txtCARD_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">상품권 : </th>
					<td>
						<input type="text" id="txtGIFT_AMT" name="txtGIFT_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">포인트 : </th>
					<td>
						<input type="text" id="txtPOINT_AMT" name="txtPOINT_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">외상 : </th>
					<td>
						<input type="text" id="txtTRUST_AMT" name="txtTRUST_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">매출액합계 : </th>
					<td>
						<input type="text" id="txtTOT_AMT" name="txtSALES_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="div_erp_table_3" class="samyang_div" style="display: none;">
		<div id="div_erp_table_3_1" class="samyang_div" style="display: none;">
			<table id="table_3_1" class="table">
			<colgroup>
					<col width="100px">
					<col width="*px">
				</colgroup>
				<tr>
					<th style="text-align:left;">사내소비건수 : </th>
					<td>
						<input type="text" id="txtCOMP_CONSM_CNT" name="txtCOMP_CONSM_CNT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
				<tr>
					<th style="text-align:left;">사내소비금액 : </th>
					<td>
						<input type="text" id="txtCOMP_CONSM_AMT" name="txtCOMP_CONSM_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">포인트적립 : </th>
					<td>
						<input type="text" id="txtPOINT_SAVE" name="txtPOINT_SAVE" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">절사액합계 : </th>
					<td>
						<input type="text" id="txtCUTO_AMT" name="txtCUTO_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">쿠폰할인수 : </th>
					<td>
						<input type="text" id="txtCOUP_DC_CNT" name="txtCOUP_DC_CNT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">쿠폰할인액 : </th>
					<td>
						<input type="text" id="txtCOUP_DC_AMT" name="txtCOUP_DC_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">공병수거건수 : </th>
					<td>
						<input type="text" id="txtEMPTY_BOTTILE_CNT" name="txtEMPTY_BOTTILE_CNT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">공병수거금액 : </th>
					<td>
						<input type="text" id="txtEMPTY_BOTTLE_AMT" name="txtEMPTY_BOTTLE_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_table_3_2" class="samyang_div" style="display: none;">
		<div id="div_erp_table_3_2_1" class="samyang_div" style="display: none;">
			<table id="table_3_2_1" class="table">
			<colgroup>
					<col width="100px">
					<col width="*px">
				</colgroup>
				<tr>
					<th style="text-align:left;">상품권1 : </th>
					<td>
						<input type="text" id="txtIN_GIFT_AMT" name="txtCOUP_FACE_PRICE" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
				<tr>
					<th style="text-align:left;">상품권2 : </th>
					<td>
						<input type="text" id="txtIN_GIFT_RECV_AMT" name="txtDEPO_GIFT" class="input_common" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">상품권과부족 : </th>
					<td>
						<input type="text" id="txtIN_GIFT_LOSS_AMT" name="txtGIFT_SHORT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_table_3_2_2" class="samyang_div" style="display: none;"></div>
		</div>
		<div id="div_erp_table_3_3" class="samyang_div" style="display: none;">
			<table id="table_3_3" class="table">
			<colgroup>
					<col width="100px">
					<col width="*px">
				</colgroup>
				<tr>
					<th style="text-align:left;">준비금 : </th>
					<td>
						<input type="text" id="txtRESV_AMT" name="txtRESV_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">현금매출 : </th>
					<td>
						<input type="text" id="txtCASH_AMT2" name="txtCASH_AMT2" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">중간출금 : </th>
					<td>
						<input type="text" id="txtMID_OUT_AMT" name="txtMID_WIDW_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">상품권거스름 : </th>
					<td>
						<input type="text" id="txtGIFT_CHNG" name="txtGIFT_CHNG" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">거스름적립 : </th>
					<td>
						<input type="text" id="txtCHNG_POINT" name="txtCHNG_POINT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">외상입금(현금) : </th>
					<td>
						<input type="text" id="txtTRUST_CASH_AMT" name="txtTRUST_CASH_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
					<tr>
					<th style="text-align:left;">입금할 현금 : </th>
					<td>
						<input type="text" id="txtCASH_FACE_PRICE" name="txtCASH_FACE_PRICE" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
						
					</td>
				</tr>
					<tr>
					<th style="text-align:left;">입금한 현금 : </th>
					<td>
						<input type="text" id="txtSALE_CASH_TOT_AMT" name="txtSALE_CASH_TOT_AMT" class="input_common" onkeyup="call();" style="width: 93px;">
						<input type = "button" id="" class="input_common_button" onclick="openAddDepositCashPopup();"  value="입력" style="width: 40px;"/>
					</td>
				</tr>
					<tr>
					<th style="text-align:left;">현금 과부족 : </th>
					<td>
						<input type="text" id="txtIN_CASH_LOSS_AMT" name="txtIN_CASH_LOSS_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 140px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">마감코드 : </th>
					<td>
						<input type="text" id="txtCLSE_CD" name="txtCLSE_CD" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 210px;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">조직명 : </th>
					<td>
						<input type="text" id="txtORGN_CD" name="txtORGN_CD" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 210px;">
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="div_erp_table_4" class="samyang_div" style="display: none;">
	<table id="table_4" class="table">
		<colgroup>
			<col width="*px">
		</colgroup>
		<tr>
			<th style="text-align:right; width: 140px;"> ※ "현금입금액" 항목은 준비금을 포함한 금액입니다.</th>
		</tr>
	</table>
	</div>
</body>
</html>