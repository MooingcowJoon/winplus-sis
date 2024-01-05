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

	var erpPopupWindowsCell = parent.erpPopupWindows.window("openRetouchBundlePopup");
	var double_Info = JSON.parse('${param.doubleInfo}');
	var erpLayout;
	var erpRibbon;
	var cmbBUDL_DC_TYPE;
	var cmbPOINT_SAVE_EX_YN;
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("이종상품 특매 등록 수정");
		}
		
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		
		document.getElementById("txtBUDL_STRT_DATE").value=todayDate;
		document.getElementById("txtBUDL_END_DATE").value=todayDate;
		
		$erp.asyncObjAllOnCreated(function(){
			initDoubleInfo();
			cmbORGN_CD.disable();
		});
		
		$("#txtBUDL_APPLY_VALUE").keyup(function(e){
			if (!(e.keyCode >=37 && e.keyCode<=40)){
				var v = $(this).val();
				$(this).val(v.replace(/[^a-z0-9]/gi,''));
				}
			});
		
		$("#txtBUDL_APPLY_UNIT").keyup(function(e){
			if (!(e.keyCode >=37 && e.keyCode<=40)){
				var v = $(this).val();
				$(this).val(v.replace(/[^a-z0-9]/gi,''));
				}
			});
	});
	
	<%-- ■ erpLayout 초기화 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "이종상품 정보", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight(310);
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
						{id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false}
					]}
				]	
			});
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "save_erpGrid"){
				saveErpGrid();
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- erpLayout 저장 Function --%>
	function saveErpGrid(){
		erpLayout.progressOn();
		var send_data = $erp.dataSerialize("add_table01");
		
		var search_date_from = document.getElementById("txtBUDL_STRT_DATE").value;
		var search_date_to = document.getElementById("txtBUDL_END_DATE").value;
		var date_from = search_date_from.replace(/\-/g,'');
		var date_to = search_date_to.replace(/\-/g,'');
		
		var nm = document.getElementById("txtBUDL_NM").value;
		var unit = document.getElementById("txtBUDL_APPLY_UNIT").value;
		var value = document.getElementById("txtBUDL_APPLY_VALUE").value;
		
		if(nm == ""){
			$erp.alertMessage({
				"alertMessage" : "이종상품그룹명을 입력해 주세요."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
			erpLayout.progressOff();
		}else if(unit == ""){
			$erp.alertMessage({
				"alertMessage" : "단위를 입력해 주세요."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
			erpLayout.progressOff();
		}else if(value == ""){
			$erp.alertMessage({
				"alertMessage" : "금액을 입력해 주세요."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
			erpLayout.progressOff();
		}else if(date_from <= date_to){
			$.ajax({
				url : "/common/popup/saveBundleGroupInfo.do"  
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
							"isAjax" : false,
							"alertCallbackFn" : function confirmAgain(){
								$erp.alertMessage({
									"alertMessage" : "데이터를 다시 조회 해주세요."
									, "alertCode" : null
									, "alertType" : "alert"
									, "isAjax" : false
								});
							}
						});
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}else{
			$erp.alertMessage({
				"alertMessage" : "날짜를 확인해 주세요."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
			erpLayout.progressOff();
		}
	}
	
	<%-- dhtmlXCombo 초기화 Function --%> 
	function initDhtmlXCombo(){
		cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK","","","","MK"], 100, null, false);
		cmbBUDL_STATE = $erp.getDhtmlXComboCommonCode('cmbBUDL_STATE', "USE_CD", ["USE_CD" ,"BIT"], 80, null,false);
	
		cmbBUDL_DC_TYPE = new dhtmlXCombo("cmbBUDL_DC_TYPE");
		cmbBUDL_DC_TYPE.setSize(183);
		cmbBUDL_DC_TYPE.readonly(true);
		cmbBUDL_DC_TYPE.addOption([
			{value: "0", text: "1개당할인판매가(원)" ,selected: true}
			,{value: "1", text: "1개당할인금액(원)"}
			,{value: "2", text: "1개당할인율(%)"}
		]);
		
		cmbPOINT_SAVE_EX_YN = $erp.getDhtmlXComboCommonCode('cmbPOINT_SAVE_EX_YN', "POINT_SAVE_EX_YN", ["POINT_SAVE_EX_YN"], 80, null,false);
	}
	
	<%-- 부모창에서 받아온 paramMap 내용 조회 Function --%>
	function initDoubleInfo(){
		crud = "U";
		var addData = document.getElementById("add_table01");
		$erp.clearInputInElement(addData);
		$erp.dataAutoBind(addData, double_Info);
	}
	
	<%-- 영문입력 방지  Function 시작--%>
	function fn_press(event,type){
		if(type == "numbers"){
			if(event.keyCode < 48 || event.keyCode > 57 ) 
				return false;
		}
	}
</script>
</head>
<body>
	<div id="div_erp_table" class="samyang_div" style="diplay:none;">
		<table id="add_table01" class="table" >
			<tr>
				<th colspan="5" style="text-align: center;">묶음할인</th>
			</tr>
			<tr>
				<th colspan="5" style="text-align: left; color:#FF0000;">&nbsp※"묶음 할인"이란?  그룹내 포함된 상품중 여러개를 묶어 할인 판매하는 방식입니다.</th>
			</tr>
			<tr>
				<th colspan="1" style="text-align: left;">&nbsp● 기   간 : </th>
				<td colspan="4">
					<input type="text" id="txtBUDL_STRT_DATE" name="txtBUDL_STRT_DATE" class="input_common input_calendar">
					<span style="float: left; margin-right: 5px;">~</span>
					<input type="text" id="txtBUDL_END_DATE" name="txtBUDL_END_DATE" class="input_common input_calendar">
				</td>
			</tr>
			<tr>
				<th colspan="1" style="text-align: left;">&nbsp● 그룹명 : </th>
				<td colspan="4">
					<input type="text" id="txtBUDL_NM" name="txtBUDL_NM" maxlength="100" style="width: 365px;">
				</td>
			</tr>
			<tr>
				<th colspan="1" style="text-align: left;">&nbsp● 조직명 : </th>
				<td colspan="2">
					<div id="cmbORGN_CD"></div>
				</td>
				<th colspan="1" style="text-align: left;">&nbsp● 사용구분 : </th>
				<td colspan="1">
					<div id=cmbBUDL_STATE></div>
				</td>
			</tr>
			<tr>
				<th colspan="5" style="text-align: center;">&nbsp할인설정</th>
			</tr>
			<tr>
				<th colspan="2">
					<input type="text" id="txtBUDL_APPLY_UNIT" name="txtBUDL_APPLY_UNIT" maxlength="10" onkeypress="return fn_press(event,'numbers');" style="width: 50px;">&nbsp&nbsp개 마다 판매시&nbsp&nbsp
				</th>
				<td colspan="2">
					<div id="cmbBUDL_DC_TYPE"></div>
				</td>
				<td colspan="1">
					<input type="text" id="txtBUDL_APPLY_VALUE" name="txtBUDL_APPLY_VALUE" maxlength="15" onkeypress="return fn_press(event,'numbers');" style="width: 80px;">
				</td>
			</tr>
			<tr>
				<th colspan="1" style="text-align: left;">&nbsp● 포인트적립 : </th>
				<td colspan="4">
					<div id="cmbPOINT_SAVE_EX_YN"></div>
				</td>
			</tr>
			<tr>
				<th colspan="1" style="text-align: left;">&nbsp메모</th>
				<td colspan="4">
					<input type="text" id="txtMEMO" name="txtMEMO" maxlength="200" style="width: 365px;">
				</td>
			</tr>
			<tr>
				<th colspan="1" style="text-align: left;">번들코드</th>
				<td colspan="4">
					<input type="text" id="txtBUDL_CD" name="txtBUDL_CD" maxlength="200" style="width: 215px;">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
</body>
</html>