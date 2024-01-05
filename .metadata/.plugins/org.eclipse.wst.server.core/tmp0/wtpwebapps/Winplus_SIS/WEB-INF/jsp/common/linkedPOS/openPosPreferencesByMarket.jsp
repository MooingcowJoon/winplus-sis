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
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openPosPreferencesByMarket");
	var erpPopupLayout;
	var erpPopupSubLayout;
	var erpPopupRibbon;
	var ORGN_CD = "${ORGN_CD}";
	var AUTHOR_CD = "${screenDto.author_cd}";
	var cmbVAT_TYPE;
	var cmbROUND_POSITION_TYPE;
	var cmbROUND_TYPE;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("매장별 POS 환경정보상세");	
		}
		initErpPopupLayout();
		initErpPopupSubLayout();
		initPopupRibbon();
		initDhtmlXCombo();
		
		
		$erp.asyncObjAllOnCreated(function(){
			searchPOSPreferencesInfo();
			if(AUTHOR_CD != "99999"){
				document.getElementById("txtPOINT_SAVE_CASH").readOnly = true;
				document.getElementById("txtPOINT_SAVE_CARD").readOnly = true;
				document.getElementById("txtPOINT_SAVE_GIFT").readOnly = true;
				document.getElementById("txtPOINT_SAVE_TRUST").readOnly = true;
			}
		});
	});
	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "리본영역", header: false, fix_size:[true, true]}
				, {id: "b", text: "데이터영역", header: false, fix_size:[true, true]}
			]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_data");
	}
	
	function initPopupRibbon(){
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "save_erpData", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}
			]
		});
		
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "save_erpData"){
				saveErpPopupData();
			}
		});
	}
	
	function initErpPopupSubLayout() {
		erpPopupSubLayout = new dhtmlXLayoutObject({
			parent : "div_erp_popup_data"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "4F"
			, cells : [
				{id: "a", text: "사업자정보", header: false, fix_size:[true, true]}
				, {id: "b", text: "기본포인트정보", header: false, fix_size:[true, true]}
				, {id: "c", text: "기준정보", header: false, fix_size:[true, true]}
				, {id: "d", text: "영수증메세지관리", header: false, fix_size:[true, true]}
			]
		});
		
		erpPopupSubLayout.cells("a").attachObject("div_erp_base_info");
		erpPopupSubLayout.cells("a").setWidth(420);
		erpPopupSubLayout.cells("a").setHeight(150);
		erpPopupSubLayout.cells("b").attachObject("div_erp_base_point");
		erpPopupSubLayout.cells("b").setHeight(150);
		erpPopupSubLayout.cells("c").attachObject("div_erp_standard_info");
		erpPopupSubLayout.cells("c").setHeight(120);
		erpPopupSubLayout.cells("d").attachObject("div_erp_message_info");
	}
	
	function searchPOSPreferencesInfo() {
		$.ajax({
			url: "/common/pos/PosChangeManagement/getPosPreferencesInfo.do"
			, data : {
				"ORGN_CD" : ORGN_CD
			}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpPopupLayout.progressOn();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					if($erp.isEmpty(data)){
						$erp.alertMessage({
							"alertMessage" : "정보조회 중 오류가 발생했습니다.",
							"alertCode" : -1,
							"alertType" : "alert",
							"isAjax" : false
						});
					}else {
						console.log(data);
						var table_pos_preferences_01 = document.getElementById("tb_erp_data_01");
						var table_pos_preferences_02 = document.getElementById("tb_erp_data_02");
						var table_pos_preferences_03 = document.getElementById("tb_erp_data_03");
						var table_pos_preferences_04 = document.getElementById("tb_erp_data_04");
						$erp.dataClear(table_pos_preferences_01);
						$erp.dataClear(table_pos_preferences_02);
						$erp.dataClear(table_pos_preferences_03);
						$erp.dataClear(table_pos_preferences_04);
						$erp.dataAutoBind(table_pos_preferences_01, data);
						$erp.dataAutoBind(table_pos_preferences_02, data);
						$erp.dataAutoBind(table_pos_preferences_03, data);
						$erp.dataAutoBind(table_pos_preferences_04, data);
					}
				}
				erpPopupLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function saveErpPopupData() {
		var data_01 = $erp.dataSerialize("tb_erp_data_01");
		var data_02 = $erp.dataSerialize("tb_erp_data_02");
		var data_03 = $erp.dataSerialize("tb_erp_data_03");
		var data_04 = $erp.dataSerialize("tb_erp_data_04");
		
		for(var i = 0 ; i < Object.keys(data_02).length ; i++){
			data_01[Object.keys(data_02)[i]] = Object.values(data_02)[i];
		}
		
		for(var i = 0 ; i < Object.keys(data_03).length ; i++){
			data_01[Object.keys(data_03)[i]] = Object.values(data_03)[i];
		}
		
		for(var i = 0 ; i < Object.keys(data_04).length ; i++){
			data_01[Object.keys(data_04)[i]] = Object.values(data_04)[i];
		}
		
		console.log(data_01);
		
		$.ajax({
			url: "/common/pos/PosChangeManagement/savePosPreferencesInfo.do"
			, data : data_01
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpPopupLayout.progressOn();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					if($erp.isEmpty(data)){
						$erp.alertMessage({
							"alertMessage" : "데이터 저장 중 오류가 발생했습니다.",
							"alertCode" : "-2",
							"alertType" : "alert",
							"isAjax" : false
						});
					}else {
						if(data.resultValue != 0){
							$erp.alertMessage({
								"alertMessage" : "수정사항이 성공적으로<br>업데이트 되었습니다.",
								"alertCode" : null,
								"alertType" : "alert",
								"alertCallbackFn" : function() {
									searchPOSPreferencesInfo();
								},
								"isAjax" : false
							});
						} else {
							$erp.alertMessage({
								"alertMessage" : "수정사항 업데이트 실패<br>다시 시도해주세요.",
								"alertCode" : null,
								"alertType" : "alert",
								"isAjax" : false
							});
						}
					}
				}
				erpPopupLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function initDhtmlXCombo(){
		cmbVAT_TYPE = $erp.getDhtmlXCombo('cmbVAT_TYPE', 'VAT_TYPE', 'POS_VAT_TYPE', 100, false);
		cmbROUND_POSITION_TYPE = $erp.getDhtmlXCombo('cmbROUND_POSITION_TYPE', 'ROUND_POSITION_TYPE', 'ROUND_POSITION_TYPE', 100, false);
		cmbROUND_TYPE = $erp.getDhtmlXCombo('cmbROUND_TYPE', 'ROUND_TYPE', 'ROUND_TYPE', 100, false);
	}
	
</script>
</head>
<body>
	<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_popup_data" class="div_layout_full_size" style="display:none">
		<div id="div_erp_base_info" class="div_common_contents_full_size" style="display:none">
			<table id="tb_erp_data_01" class="tb_erp_common">
				<colgroup>
					<col width="150px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<td colspan="4" style="text-align: left;"><b>* 사업자 등록정보</b></td>
				</tr>
				<tr>
					<th>상호(영수증)명</th>
					<td colspan="3">
						<input type="hidden" id="txtORGN_CD" name="ORGN_CD">
						<input type="text" id="txtCORP_NM" name="CORP_NM" class="input_common input_readonly" style="width: 300px">
					</td>
				</tr>
				<tr>
					<th>사업자번호</th>
					<td colspan="3">
						<input type="text" id="txtCORP_NO" name="CORP_NO" class="input_common input_readonly" style="width: 200px">
					</td>
				</tr>
				<tr>
					<th>대표자명</th>
					<td>
						<input type="text" id="txtCEO_NM" name="CEO_NM" class="input_common input_readonly" style="width: 100px">
					</td>
					<th>전화번호</th>
					<td>
						<input type="text" id="txtTEL_NO" name="TEL_NO" class="input_common input_readonly" style="width: 100px">
					</td>
				</tr>
				<tr>
					<th rowspan="2">주소</th>
					<td rowspan="2" colspan="3">
						<input type="text" id="txtADDR" name="ADDR" class="input_common input_readonly" style="width: 300px">
						<input type="text" id="txtADDR_DETL" name="ADDR_DETL" class="input_common input_readonly" style="width: 300px">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_base_point" class="div_common_contents_full_size" style="display:none">
			<table id="tb_erp_data_02" class="tb_erp_common">
				<colgroup>
					<col width="70px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<td colspan="2" style="text-align: left;"><b>* 기본 포인트</b></td>
				</tr>
				<tr>
					<th>현금</th>
					<td>
						<input type="text" id="txtPOINT_SAVE_CASH" name="POINT_SAVE_CASH" class="input_common" style="width: 50px"><b>%</b>
					</td>
				</tr>
				<tr>
					<th>카드</th>
					<td>
						<input type="text" id="txtPOINT_SAVE_CARD" name="POINT_SAVE_CARD" class="input_common" style="width: 50px"><b>%</b>
					</td>
				</tr>
				<tr>
					<th>상품권</th>
					<td>
						<input type="text" id="txtPOINT_SAVE_GIFT" name="POINT_SAVE_GIFT" class="input_common" style="width: 50px"><b>%</b>
					</td>
				</tr>
				<tr>
					<th>외상</th>
					<td>
						<input type="text" id="txtPOINT_SAVE_TRUST" name="POINT_SAVE_TRUST" class="input_common" style="width: 50px"><b>%</b>
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_standard_info" class="div_common_contents_full_size" style="display:none">
			<table id="tb_erp_data_03" class="tb_erp_common">
				<colgroup>
					<col width="150px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<td colspan="4" style="text-align: left;"><b>* POS 기준정보</b></td>
				</tr>
				<tr>
					<th>부가세구분</th>
					<td colspan="3">
						<div id="cmbVAT_TYPE"></div>
					</td>
				</tr>
				<tr>
					<th>매출금액절사기준</th>
					<td colspan="3">
						<div id="cmbROUND_POSITION_TYPE"></div>
					</td>
				</tr>
				<tr>
					<th>매출금액끝전처리</th>
					<td colspan="3">
						<div id="cmbROUND_TYPE"></div>
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_message_info" class="div_common_contents_full_size" style="display:none">
			<table id="tb_erp_data_04" class="tb_erp_common">
				<colgroup>
					<col width="150px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<td colspan="4" style="text-align: left;"><b>* 영수증 메세지</b></td>
				</tr>
				<tr>
					<th>머리말</th>
					<td colspan="3">
						<input type="text" id="txtMSG_HEAD" name="MSG_HEAD" class="input_common input_readonly" style="width: 300px">
					</td>
				</tr>
				<tr>
					<th>꼬리말</th>
					<td colspan="3">
						<input type="text" id="txtMSG_FOOTER" name="MSG_FOOTER" class="input_common input_readonly" style="width: 300px">
					</td>
				</tr>
				<tr>
					<th>고객전달 메세지</th>
					<td colspan="3">
						<input type="text" id="txtMSG_CUSTMR" name="MSG_CUSTMR" class="input_common input_readonly" style="width: 300px">
					</td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>