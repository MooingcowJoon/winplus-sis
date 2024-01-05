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

	var erpPopupWindowsCell = parent.erpPopupWindows.window("openNewBundleGroupPopup");
	var erpLayout;
	var erpRibbon;
	var cmbBUDL_DC_TYPE;
	var cmbPOINT_SAVE_EX_YN;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-" + thisDay;
	
	var erpPopupGrupCheckList;

	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("이종상품 특매 등록 정보");
		}
		
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		
		document.getElementById("txtBUDL_STRT_DATE").value=todayDate;
		document.getElementById("txtBUDL_END_DATE").value=todayDate;
		
		$("#txtBUDL_APPLY_VALUE").keyup(function(e) {
			if (!(e.keyCode >=37 && e.keyCode<=40)) {
				var v = $(this).val();
				$(this).val(v.replace(/[^a-z0-9]/gi,''));
				}
			});
		
		$("#txtBUDL_APPLY_UNIT").keyup(function(e) {
			if (!(e.keyCode >=37 && e.keyCode<=40)) {
				var v = $(this).val();
				$(this).val(v.replace(/[^a-z0-9]/gi,''));
				}
			});
		
		$erp.asyncObjAllOnCreated(function(){
			var searchable = 1;
			var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",")
			for(var i in search_cd_Arr){
				if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
					searchable = 2;
				}
			}
			
			if(searchable == 1 ){ //직영점단일
				cmbORGN_CD.disable();
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
						{id : "add_erpGrid", type : "button", text:'등록', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : true}
					]}
				]	
			});
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_erpGrid"){
				addErpGrid();
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- addErpGrid 추가 Function --%>
	function addErpGrid(){
		var date_from = document.getElementById("txtBUDL_STRT_DATE").value;
		var BUDL_STRT_DATE = date_from.replace(/\-/g,'');
		
		var date_to = document.getElementById("txtBUDL_END_DATE").value;
		var BUDL_END_DATE = date_to.replace(/\-/g,'');
		
		var BUDL_NM = document.getElementById("txtBUDL_NM").value;
		var MEMO = document.getElementById("txtMEMO").value;
		var BUDL_APPLY_UNIT = document.getElementById("txtBUDL_APPLY_UNIT").value;
		var BUDL_APPLY_VALUE = document.getElementById("txtBUDL_APPLY_VALUE").value;
		var POINT_SAVE_EX_YN = cmbPOINT_SAVE_EX_YN.getSelectedValue();
		var BUDL_DC_TYPE = cmbBUDL_DC_TYPE.getSelectedValue();
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		var BUDL_STATE = cmbBUDL_STATE.getSelectedValue();

		if(BUDL_NM == ""){
			$erp.alertMessage({
				"alertMessage" : "이종상품그룹명을 입력해 주세요.",
				"alertType" : "alert",
				"isAjax" : false
			});
		}else if(BUDL_APPLY_UNIT == ""){
			$erp.alertMessage({
				"alertMessage" : "단위를 입력해 주세요.",
				"alertType" : "alert",
				"isAjax" : false
			});
		}else if(BUDL_APPLY_VALUE == ""){
			$erp.alertMessage({
				"alertMessage" : "금액을 입력해 주세요.",
				"alertType" : "alert",
				"isAjax" : false
			});
		}else if(BUDL_STRT_DATE > BUDL_END_DATE){
			$erp.alertMessage({
				"alertMessage" : "날짜를 확인해 주세요.",
				"alertType" : "alert",
				"isAjax" : false
			});
		}else{
			if(!$erp.isEmpty(erpPopupGrupCheckList) && typeof erpPopupGrupCheckList === 'function'){
				erpPopupGrupCheckList(BUDL_STRT_DATE, BUDL_END_DATE, BUDL_NM, MEMO, BUDL_APPLY_UNIT, BUDL_APPLY_VALUE, POINT_SAVE_EX_YN,BUDL_DC_TYPE,ORGN_CD,BUDL_STATE,BUDL_APPLY_VALUE,BUDL_APPLY_UNIT);
			}
		}
		
	}
		
	<%-- dhtmlXCombo 초기화 Function --%> 
	function initDhtmlXCombo(){
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",");
		var searchable = 1;
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
				searchable = 2;
			}
		}
		
		 if(searchable == 2 ){
			 cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK","","","","MK"], 100, null, false, LUI.LUI_orgn_cd);
		} else {
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 100, null, false, LUI.LUI_orgn_cd);
		}
		
		cmbBUDL_STATE = $erp.getDhtmlXComboCommonCode('cmbBUDL_STATE', "USE_CD", ["USE_CD" ,"YN"], 80, null,false);
		
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
	
	<%-- 영문입력 방지  Function 시작--%>
	function fn_press(event,type){
		if(type == "numbers"){
			if(event.keyCode < 48 || event.keyCode > 57)
				return false;
		}
	}
	
</script>
</head>
<body>
	<div id="div_erp_table" class="samyang_div" style="diplay:none;">
		<table id="add_table01" class="table">
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