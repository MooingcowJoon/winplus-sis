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
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
		
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openAddTrustSalesPopup");
	var erpLayout;
	var erpRibbon;
	var crud;
	
	var cmbPAY_HOUR;
	var cmbPAY_MINUTE;
	var cmbACNT_TYPE;
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	var trustInfo = JSON.parse('${param.trustInfo}');
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("외상매출 결제 수정");
		}
		
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		console.log(trustInfo);
		
		$erp.asyncObjAllOnCreated(function(){
			initTrustInfo();
		});
	});
	
	<%-- ■ erpLayout 초기화 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "외상매출 결제", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight(500);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		
		erpLayout.setSeparatorSize(0, 1);
		erpLayout.setSeparatorSize(1, 1);
	}
	<%-- ■ erpLayout 초기화 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{type : "block", mode : 'rows', list : [
						{id : "add_erpGrid", type : "button", text:'등록', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : true}
						, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
						]}
				]	
			});
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_erpGrid"){
				addErpGrid();
			} else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
			} 
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- addErpGrid 추가 Function --%>
	function addErpGrid(){
		var OBJ_CD= trustInfo.OBJ_CD;
		var LOAN_CD= trustInfo.LOAN_CD;
		var SUM_AMT = document.getElementById("txtSUM_AMT").value;	//결제내역소계 > 결제금액
		var LOSS_AMT = document.getElementById("txtLOSS_AMT").value; //손실처리 > 손실금액
		var MEMO = document.getElementById("txtMEMO").value; //결제처리메모 > 비고
		var pay_date = document.getElementById("txtPAY_DATE").value; //결제일 > 거래일자
		var PAY_DATE = pay_date.replace(/\-/g,'');
		var PAY_HOUR = cmbPAY_HOUR.getSelectedValue(); //시간 > 거래일자
		var PAY_MINUTE = cmbPAY_MINUTE.getSelectedValue();
		var ACNT_TYPE = cmbACNT_TYPE.getSelectedValue();
		var CASH_AMT = document.getElementById("txtCASH_AMT").value;
		var CARD_AMT = document.getElementById("txtCARD_AMT").value; //카드
		var ACNT_AMT = document.getElementById("txtACNT_AMT").value;
		var TRUST_SEQ = document.getElementById("txtTRUST_SEQ").value;
		var LOAN_SEQ = document.getElementById("txtLOAN_SEQ").value;
		
		if(!$erp.isEmpty(erpPopupGrupCheckList) && typeof erpPopupGrupCheckList === 'function'){
			erpPopupGrupCheckList(SUM_AMT, LOSS_AMT, MEMO, PAY_DATE, PAY_HOUR, PAY_MINUTE, CASH_AMT, CARD_AMT, ACNT_AMT, OBJ_CD, LOAN_CD, TRUST_SEQ, LOAN_SEQ);
		}
	}
	
	function initTrustInfo(){
		var addData1 = document.getElementById("add_table01");
		var addData2 = document.getElementById("add_table02");
		$erp.clearInputInElement(addData1);
		$erp.clearInputInElement(addData2);
		$erp.dataAutoBind(addData1, trustInfo);
		$erp.dataAutoBind(addData2, trustInfo);
	}
	
	function deleteErpGrid(){
		var OBJ_CD= trustInfo.OBJ_CD;
		var LOAN_CD= trustInfo.LOAN_CD;
		var SUM_AMT = document.getElementById("txtSUM_AMT").value;	//결제내역소계 > 결제금액
		var LOSS_AMT = document.getElementById("txtLOSS_AMT").value; //손실처리 > 손실금액
		var MEMO = document.getElementById("txtMEMO").value; //결제처리메모 > 비고
		var pay_date = document.getElementById("txtPAY_DATE").value; //결제일 > 거래일자
		var PAY_DATE = pay_date.replace(/\-/g,'');
		var PAY_HOUR = cmbPAY_HOUR.getSelectedValue(); //시간 > 거래일자
		var PAY_MINUTE = cmbPAY_MINUTE.getSelectedValue();
		var ACNT_TYPE = cmbACNT_TYPE.getSelectedValue();
		var CASH_AMT = document.getElementById("txtCASH_AMT").value;
		var CARD_AMT = document.getElementById("txtCARD_AMT").value; //카드
		var ACNT_AMT = document.getElementById("txtACNT_AMT").value;
		var TRUST_SEQ = document.getElementById("txtTRUST_SEQ").value;//계좌이체
		var LOAN_SEQ = document.getElementById("txtLOAN_SEQ").value;
		
		if(!$erp.isEmpty(erpPopupGrupList) && typeof erpPopupGrupList === 'function'){
			erpPopupGrupList(OBJ_CD, LOAN_CD, TRUST_SEQ, LOAN_SEQ);
		}
	}
	
	function money(){
		var addData = document.getElementById("txtSUM_AMT");
		$erp.clearInputInElement(addData);
		var cashAmt = parseInt($("#txtCASH_AMT").val() || 0);
		var cardAmt = parseInt($("#txtCARD_AMT").val() || 0);
		var bankAmt =  parseInt($("#txtACNT_AMT").val() || 0);
		
		var sumAmt = cashAmt + cardAmt + bankAmt;
		
		$("#txtSUM_AMT").val(sumAmt);
	}
	
	function initDhtmlXCombo(){
		cmbPAY_HOUR = $erp.getDhtmlXComboCommonCode("cmbPAY_HOUR", "HOUR", "HOUR", 100, null, false);
		cmbPAY_MINUTE = $erp.getDhtmlXComboCommonCode("cmbPAY_MINUTE", "MINUTE2", "MINUTE2", 70, null, false);
	
		cmbACNT_TYPE = new dhtmlXCombo("cmbACNT_TYPE");
		cmbACNT_TYPE.setSize(150);
		cmbACNT_TYPE.readonly(true);
		cmbACNT_TYPE.addOption([
			{value: "0", text: "------입출금계좌-------" ,selected: true}
			,{value: "1", text: "기본계좌"}
		]);
	}
	
</script>
</head>
<body>
<div id="div_erp_table" class="samyang_div" style="diplay:none;">
	<table id="add_table01" class="table">
		<tr>
			<th colspan="6" style="text-align: center;">담당,거래처,처리일자</th>
		</tr>
		<tr>
			<th colspan="1" style="text-align: left;">거래처</th>
			<td colspan="2" >
				<input type="text" id="txtUNIQUE_MEM_NM" name="txtUNIQUE_MEM_NM" readonly="readonly" maxlength="100" style="width: 144px; background-color: #F2F2F2;"">
			</td>
			<th colspan="1" style="text-align: left;">담당자</th>
			<td colspan="2">
				<input type="text" id="txtRESP_USER" name="txtRESP_USER" readonly="readonly" maxlength="100" style="width: 144px; background-color: #F2F2F2;"">
			</td>
		</tr>
		<tr>
			<th colspan="1" style="text-align: left;">결제일</th>
			<td colspan="5" >
				<input type="text" id="txtPAY_DATE" name="txtPAY_DATE" class="input_common input_calendar" style="display: inline-flex;">&nbsp;
				<div id = "cmbPAY_HOUR" style="display: inline-flex; margin-right: 10px;" ></div>
				<div id = "cmbPAY_MINUTE" style="display: inline-flex;"></div>
			</td>
		</tr>
	</table>
	<table id="add_table02" class="table">
		<tr>
			<th colspan="6" style="text-align: center;">결제내용</th>
		</tr>
		<tr>
			<th colspan="1" style="text-align: left;">현금</th>
			<td colspan="2">
				<input type="text" id="txtCASH_AMT" name="txtCASH_AMT" maxlength="100" onkeyup="money();" style="width: 144px;">
			</td>
			<th colspan="1" style="text-align: left;">카드결제</th>
			<td colspan="2"> 
				<input type="text" id="txtCARD_AMT" name="txtCARD_AMT" maxlength="100" onkeyup="money();" style="width: 144px;">
			</td>
		</tr>
		<tr>
			<th colspan="1" style="text-align: left;">계좌이체</th>
			<td colspan="2">
				<input type="text" id="txtACNT_AMT" name="txtACNT_AMT" maxlength="100" onkeyup="money();" style="width: 144px;">
			</td>
			<th colspan="1" style="text-align: left;">입금계좌</th>
			<td colspan="2">
				<div id = "cmbACNT_TYPE"></div>
			</td>
		</tr>
		<tr>
			<th colspan="1" style="text-align: left;">손실처리</th>
			<td colspan="5">
				<input type="text" id="txtLOSS_AMT" name="txtLOSS_AMT" maxlength="100" style="width: 144px;">
			</td>
		</tr>
		<tr>
			<th colspan="1" style="text-align: left;">결제내역소계</th>
			<td colspan="5">
				<input type="text" id="txtSUM_AMT" readonly="readonly" name="txtSUM_AMT" maxlength="100" style="width: 380px; background-color: #F2F2F2;">
			</td>
		</tr>
		<tr>
			<th colspan="6" style="text-align: left;">결제처리메모[한글최대 50자 입력가능]</th>
		</tr>
		<tr>
			<td colspan="6">
				<input type="text" id="txtMEMO" name="txtMEMO" maxlength="50" style="width: 460px;">
			</td>
		</tr>
		<tr>
			<td colspan="6">
				<input type="text" id="txtTRUST_SEQ" name="txtTRUST_SEQ" maxlength="50" style="width: 460px;">
			</td>
		</tr>
		<tr>
			<td colspan="6">
				<input type="text" id="txtLOAN_SEQ" name="txtLOAN_SEQ" maxlength="50" style="width: 460px;">
			</td>
		</tr>
	</table>
	</div>
	<div id="div_erp_ribbon" class="samyang_div" style="diplay:none;"></div>
</body>
</html>