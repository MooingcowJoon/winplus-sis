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

	var erpPopupWindowsCell = parent.erpPopupWindows.window("openAddDepositCashPopup");
	var erpLayout;
	var erpRibbon;
	var erpPopupCheckList;
	var CLSE_CD = "${param.CLSE_CD}";
	var ORGN_CD = "${param.ORGN_CD}";
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("현금 입금액 입력");
		}
		
		initErpLayout();
		initErpRibbon();
		searchErp();
		
	});
	
	<%-- ■ erpLayout 초기화 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "제목영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "현금입금액정보", header:false, fix_size : [true, true]}
				,{id: "c", text: "리본영역", header:false, fix_size : [true, true]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_table_1");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_table_2");
		erpLayout.cells("b").setHeight(295);
		erpLayout.cells("c").attachObject("div_erp_ribbon");
		erpLayout.cells("c").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
	}
	<%-- ■ erpLayout 초기화 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	function initErpRibbon() {
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					 {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false}
				]}
			]
		});	
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "save_erpGrid"){
				saveErp();
			}
		});
	}
	
	<%-- erpLayout 저장 Function --%>
	function saveErp(){
		var SALE_CASH_TOT_AMT = $("#txtSALE_CASH_TOT_AMT").val();
		var paramData={};
		paramData["CASH_CNT_01"] = $("#txtCASH_CNT_01").val();
		paramData["CASH_CNT_02"] = $("#txtCASH_CNT_02").val();
		paramData["CASH_CNT_03"] = $("#txtCASH_CNT_03").val();
		paramData["CASH_CNT_04"] = $("#txtCASH_CNT_04").val();
		paramData["CASH_CNT_05"] = $("#txtCASH_CNT_05").val();
		paramData["CASH_CNT_06"] = $("#txtCASH_CNT_06").val();
		paramData["CASH_CNT_07"] = $("#txtCASH_CNT_07").val();
		paramData["CASH_CNT_08"] = $("#txtCASH_CNT_08").val();
		paramData["CASH_CNT_09"] = $("#txtCASH_CNT_09").val();
		paramData["CASH_CNT_10"] = $("#txtCASH_CNT_10").val();
		paramData["SALE_CASH_TOT_AMT"] = $("#txtSALE_CASH_TOT_AMT").val();
		paramData["CLSE_CD"] = "${param.CLSE_CD}";
		paramData["ORGN_CD"] = "${param.ORGN_CD}";
		
		erpLayout.progressOn();
		$.ajax({
			url : "/common/popup/saveDepositCash.do"  
			,data : paramData
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
						"isAjax" : false,
						"alertCallbackFn" : erpPopupCheckList(SALE_CASH_TOT_AMT)
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
			
		});
	}
	
	<%-- erpLayout 내용 조회 Function --%>
	function searchErp(){
		
		var CLSE_CD =  "${param.CLSE_CD}";
		var ORGN_CD = "${param.ORGN_CD}";
		
		$.ajax({
			url: "/common/popup/getCashCntList.do"
			, data : {
				"CLSE_CD" : CLSE_CD
				,"ORGN_CD" : ORGN_CD
				}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var dataList = data.dataList;
					console.log(dataList);
					$("#txtCASH_CNT_01").val(dataList.CASH_CNT_01);
					$("#txtCASH_CNT_02").val(dataList.CASH_CNT_02);
					$("#txtCASH_CNT_03").val(dataList.CASH_CNT_03);
					$("#txtCASH_CNT_04").val(dataList.CASH_CNT_04);
					$("#txtCASH_CNT_05").val(dataList.CASH_CNT_05);
					$("#txtCASH_CNT_06").val(dataList.CASH_CNT_06);
					$("#txtCASH_CNT_07").val(dataList.CASH_CNT_07);
					$("#txtCASH_CNT_08").val(dataList.CASH_CNT_08);
					$("#txtCASH_CNT_09").val(dataList.CASH_CNT_09);
					$("#txtCASH_CNT_10").val(dataList.CASH_CNT_10);
					
					$("#txtMONEY_ONE").val(dataList.MONEY_ONE);
					$("#txtMONEY_TWO").val(dataList.MONEY_TWO);
					$("#txtMONEY_THREE").val(dataList.MONEY_THREE);
					$("#txtMONEY_FOUR").val(dataList.MONEY_FOUR);
					$("#txtMONEY_FIVE").val(dataList.MONEY_FIVE);
					$("#txtMONEY_SIX").val(dataList.MONEY_SIX);
					$("#txtMONEY_SEVEN").val(dataList.MONEY_SEVEN);
					$("#txtMONEY_EIGHT").val(dataList.MONEY_EIGHT);
					$("#txtMONEY_NINE").val(dataList.MONEY_NINE);
					$("#txtMONEY_TEN").val(dataList.MONEY_TEN);
					$("#txtSALE_CASH_TOT_AMT").val(dataList.SALE_CASH_TOT_AMT);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
				
	}
	
	<%-- 현금 입급액 계산 Function --%>
	function money(){
		var money_one = parseInt($("#txtCASH_CNT_01").val() || 0);
		var money_two = parseInt($("#txtCASH_CNT_02").val() || 0);
		var money_three = parseInt($("#txtCASH_CNT_03").val() || 0);
		var money_four = parseInt($("#txtCASH_CNT_04").val() || 0);
		var money_five = parseInt($("#txtCASH_CNT_05").val() || 0);
		var money_six = parseInt($("#txtCASH_CNT_06").val() || 0);
		var money_seven = parseInt($("#txtCASH_CNT_07").val() || 0);
		var money_eight = parseInt($("#txtCASH_CNT_08").val() || 0);
		var money_nine = parseInt($("#txtCASH_CNT_09").val() || 0);
		var money_ten = parseInt($("#txtCASH_CNT_10").val() || 0);
		
		var moneyone = money_one * 50000;
		var moneytwo = money_two * 10000;
		var moneythree = money_three * 5000;
		var moneyfour = money_four * 1000;
		var moneyfive = money_five * 500;
		var moneysix = money_six * 100;
		var moneyseven = money_seven * 50;
		var moneyeight = money_eight * 10;
		var moneynine = money_nine * 100000;
		var sum = money_one * 50000 + money_two * 10000 + money_three * 5000 + money_four * 1000 +  money_five * 500 + money_six * 100 + money_seven * 50 + money_eight * 10 + money_nine * 100000 + money_ten;
		
		$("#txtMONEY_ONE").val(moneyone);
		$("#txtMONEY_TWO").val(moneytwo);
		$("#txtMONEY_THREE").val(moneythree);
		$("#txtMONEY_FOUR").val(moneyfour);
		$("#txtMONEY_FIVE").val(moneyfive);
		$("#txtMONEY_SIX").val(moneysix);
		$("#txtMONEY_SEVEN").val(moneyseven);
		$("#txtMONEY_EIGHT").val(moneyeight);
		$("#txtMONEY_NINE").val(moneynine);
		$("#txtSALE_CASH_TOT_AMT").val(sum);
	}

</script>
</head>
<body>
	<div id="div_erp_table_1" class="samyang_div" style="display: none;">
			<table id="table_1" class="table">
				<colgroup>
					<col width="*px">
				</colgroup>
				<tr>
					<th style="text-align:left;">현금 입금액 입력</th>
				</tr>
			</table>
	</div>
	<div id="div_erp_table_2" class="samyang_div" style="display: none;">
			<table id="table_2" class="table">
				<colgroup>
					<col width="100px">
					<col width="*px">
				</colgroup>
						<tr>
					<th style="text-align:right;">기타수표 : </th>
					<td>
						<input type="text" id="txtCASH_CNT_10" name="txtmoney_check" class="input_common" onkeyup="money();" style="width: 120px;" value="0">
					</td>
				</tr>
				<tr>
					<th style="text-align:right;">100,000권 수표 : </th>
					<td>
						<input type="text" id="txtCASH_CNT_09" name="" class="input_common" onkeyup="money();" style="width: 50px;" value="0">
					<input type="text" id="txtMONEY_NINE" name="txtMONEY_NINE" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 120px;" value="0">
					</td>
				</tr>
				<tr>
					<th style="text-align:right;">50,000원권 : </th>
					<td>
						<input type="text" id="txtCASH_CNT_01" name="" class="input_common" onkeyup="money();" style="width: 50px;" value="0">
						<input type="text" id="txtMONEY_ONE" name="txtMONEY_ONE" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 120px;" value="0">
					</td>
				</tr>
				<tr>
					<th style="text-align:right;">10,000원권 : </th>
					<td>
						<input type="text" id="txtCASH_CNT_02" name="" class="input_common" onkeyup="money();" style="width: 50px;" value="0">
						<input type="text" id="txtMONEY_TWO" name="txtMONEY_TWO" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 120px;" value="0">
					</td>
				</tr>
				<tr>
					<th style="text-align:right;">5,000원권 : </th>
					<td>
						<input type="text" id="txtCASH_CNT_03" name="" class="input_common" onkeyup="money();" style="width: 50px;" value="0">
						<input type="text" id="txtMONEY_THREE" name="txtMONEY_THREE" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 120px;" value="0">
					</td>
				</tr>
				<tr>
					<th style="text-align:right;">1,000원권 : </th>
					<td>
						<input type="text" id="txtCASH_CNT_04" name="" class="input_common" onkeyup="money();" style="width: 50px;" value="0">
						<input type="text" id="txtMONEY_FOUR" name="txtMONEY_FOUR" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 120px;" value="0">
					</td>
				</tr>
				<tr>
					<th style="text-align:right;">500원권 : </th>
					<td>
						<input type="text" id="txtCASH_CNT_05" name="" class="input_common" onkeyup="money();" style="width: 50px;" value="0">
						<input type="text" id="txtMONEY_FIVE" name="txtMONEY_FIVE" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 120px;" value="0">
					</td>
				</tr>
				<tr>
					<th style="text-align:right;">100원권 : </th>
					<td>
						<input type="text" id="txtCASH_CNT_06" name="" class="input_common" onkeyup="money();" style="width: 50px;" value="0">
						<input type="text" id="txtMONEY_SIX" name="txtMONEY_SIX" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 120px;" value="0">
					</td>
				</tr>
				<tr>
					<th style="text-align:right;">50원권 : </th>
					<td>
						<input type="text" id="txtCASH_CNT_07" name="" class="input_common" onkeyup="money();" style="width: 50px;" value="0">
						<input type="text" id="txtMONEY_SEVEN" name="txtMONEY_SEVEN" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 120px;" value="0">
					</td>
				</tr>
				<tr>
					<th style="text-align:right;">10원권 : </th>
					<td>
						<input type="text" id="txtCASH_CNT_08" name="" class="input_common" onkeyup="money();" style="width: 50px;" value="0">
						<input type="text" id="txtMONEY_EIGHT" name="txtMONEY_EIGHT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 120px;" value="0">
					</td>
				</tr>
				<tr>
					<th style="text-align:right;">합계 : </th>
					<td>
						<input type="text" id="txtSALE_CASH_TOT_AMT" name="txtSALE_CASH_TOT_AMT" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 120px;" value="0">
					</td>
				</tr>
					<tr>
				<th style="text-align:right;">마감코드 : </th>
					<td>
						<input type="text" id="txtCLSE_CD" name="txtCLSE_CD" class="input_common" readonly="readonly" style="background-color: #F2F2F2; width: 120px;" value="0">
					</td>
				</tr>
		 </table>
	</div>
	<div id="div_erp_ribbon" class="samyang_div" style="display: none;"></div>
</body>
</html>