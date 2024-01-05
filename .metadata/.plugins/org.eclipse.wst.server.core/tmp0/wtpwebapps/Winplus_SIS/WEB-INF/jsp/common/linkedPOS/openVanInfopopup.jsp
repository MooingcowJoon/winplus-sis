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

	var erpPopupWindowsCell = parent.erpPopupWindows.window("openVanInfopopup");
	var erpLayout;
	var erpRibbon;
	var cmbPRIORITY_EVENT_YN;
	var cmbORGN_CD;
	var cmbUSE_YN;
	var cmbTITLE_TYPE;
	var erpPopupGrupCheckList;
	var AUTHOR_CD = "${screenDto.author_cd}";
	var orgnCheck = LUI.LUI_orgn_delegate_cd;
	var title = "";
	var crud;
	
	erpPopupWindowsCell.attachEvent("onClose", function(){
		if(crud == "U"){
			closeAfterHeaderSearch();
		}
		return true;
	});
	
	$(document).ready(function(){
		crud = '${CRUD}';
		if(erpPopupWindowsCell){
			if(crud == "C"){
				title = "신규 정보 등록 중";
			}else if(crud == "U"){
				title = "상세 정보 수정 중";
			}else if(crud == "R"){
				title = "상세 정보 조회 중";
			}
			erpPopupWindowsCell.setText("밴사정보 신규등록/수정");
		}
		document.getElementById("title").textContent = title;
		if(crud == "U" && '${tableData}' == ""){
			$erp.alertMessage({
				"alertMessage" : "상세 정보를 조회할 수 없습니다.",
				"alertType" : "alert",
				"isAjax" : false
			});
		}
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
	});
	
	<%-- ■ erpLayout 초기화 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "밴사정보", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight(210);
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
						{id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					]}
				]	
		});
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "save_erpGrid"){
				if(crud == "R"){
					crud = "U";
				}
				saveErpGrid();
			}
		});
	}

	function saveErpGrid(){
		var data1 = {};
		data1["CRUD"] = crud;
		data1["USER"] = LUI.LUI_emp_no;
		var dataObj = $erp.dataSerialize("info_table");//cmb txt chk 이런거 자르고 보냄  
		var paramData = $erp.unionObjArray([data1,dataObj]);
		
		result = $erp.tableValidationCheck("info_table");
		if(result === false){
			$erp.alertMessage({
				"alertMessage" : "필수 입력 항목이 남아있습니다.",
				"alertType" : "alert",
				"isAjax" : false
			});
			return;
		}

		erpLayout.progressOn();
		$.ajax({
				url: "/common/pos/VanInfoManagement/crudVanInfo.do"
				, data : paramData
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					var result = data.isValidated;
					var tableDataMap = data.tableDataMap;
					if($erp.isEmpty(tableDataMap) && $erp.isEmpty(result)){
						$erp.alertMessage({
							"alertMessage" : 'info.common.errorsaveSuccess',
							"alertType" : "alert",
							"isAjax" : true,
							"alertCallbackFn" : function(){	}
						});
					} else if(result == false){
						$erp.alertMessage({
							"alertMessage" : "아이피 주소와 포트 번호를 확인하세요",
							"alertType" : "alert",
							"isAjax" : false,
							"alertCallbackFn" : function(){ }
						});
					}else {
						var alertMsg = "";
						var isValidated = false;
						if(tableDataMap.CRUD == "C"){
							isValidated = true;
							alertMsg = "신규 등록이 완료되었습니다.";
						}else if(tableDataMap.CRUD == "U"){
							isValidated = true;
							alertMsg = "수정되었습니다.";
						}
						if(isValidated){
							$erp.alertMessage({
								"alertMessage" : alertMsg,
								"alertType" : "alert",
								"isAjax" : false,
								"alertCallbackFn" : function(){
									var info_table = document.getElementById("info_table");
									$erp.clearInputInElement(info_table);
									document.getElementById("title").textContent = "상세 정보 수정 중";
									$erp.bindTextValue(tableDataMap, info_table);
									$erp.bindCmbValue(tableDataMap, info_table);
									crud = "U"
									cmbVAN_CD.disable();
								}
							});
						} else {
							$erp.alertMessage({
								"alertMessage" : 'info.common.errorsaveSuccess',
								"alertType" : "alert",
								"isAjax" : true,
								"alertCallbackFn" : function(){	}
							});
						}
					}
					erpLayout.progressOff();
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- dhtmlXCombo 초기화 Function --%> 
	function initDhtmlXCombo(){
		cmbVAN_CD = $erp.getDhtmlXComboCommonCode("cmbVAN_CD", "VAN_CD", ["VAN_CD"], 180, false, true, '${tableData.VAN_CD}');
		cmbVAN_CD.attachEvent("onChange", function(value, text){
			searchCheck = false;
			text = text.split(" ");
			$('#txtVAN_CD').val(text[0]);
			$('#txtVAN_NM').val(text[1]);
		});
		cmbUSE_YN  = $erp.getDhtmlXComboCommonCode('cmbUSE_YN', 'USE_YN', ['USE_CD','YN'], 120, false, false, '${tableData.USE_YN}');
		if(crud == "U" || crud == "R"){
			cmbVAN_CD.disable();
		}
	}
	function numcheck(){
		$("input:text[numberOnly]").on("keyup", function() {
		    $(this).val($(this).val().replace(/[^0-9]/g,""));
		});
	}
</script>
</head>
<body>
	<div id="div_erp_table" class="samyang_div" style="diplay:none;">
			<table id="info_table" class="table" >
				<tr height="40">
					<th colspan="5" id="title" style="text-align: center; font-size: 13px;">밴사 정보 등록/수정</th>
				</tr>
				<tr height="30">
					<th colspan="2" style="text-align: left;"><span class="span_essential">*</span> 밴사 코드</th>
					<td colspan="3">
						<div id = "cmbVAN_CD"></div>
					</td>
				</tr>
				<tr height="30">
					<th colspan="2" style="text-align: left;"><span class="span_essential">*</span> 밴사 이름</th>
					<td colspan="3">
						<input type="hidden" id="txtVAN_CD" name="VAN_CD" value = "${tableData.VAN_CD}">
						<input type="hidden" id="txtVAN_SEQ" name="VAN_SEQ" value = "${tableData.VAN_SEQ}">
						<input type="text" id="txtVAN_NM" name="VAN_NM" class="input_common" value = "${tableData.VAN_NM}"  data-isEssential="true" maxlength="100" style="width: 174px;" readOnly>
					</td>
				</tr>
				<tr height="30">
					<th colspan="2" style="text-align: left;"><span class="span_essential">*</span> 아이피</th>
					<td colspan="3">
						<input type="text" id="txtIP1" name="ip1" class="input_number input_common" maxlength="3" value = "${tableData.IP1}" autocomplete="off" data-isEssential="true" style="width: 30px;">
						<strong> .</strong>
						<input type="text" id="txtIP2" name="ip2" class="input_number input_common" maxlength="3" value = "${tableData.IP2}" autocomplete="off" data-isEssential="true" style="width: 30px;">
						<strong> .</strong>
						<input type="text" id="txtIP3" name="IP3" class="input_number input_common" maxlength="3" value = "${tableData.IP3}" autocomplete="off" data-isEssential="true" style="width: 30px;">
						<strong> .</strong>
						<input type="text" id="txtIP4" name="IP4" class="input_number input_common" maxlength="3" value = "${tableData.IP4}" autocomplete="off" data-isEssential="true" style="width: 30px;">
					</td>
				</tr>
				<tr height="30">
					<th colspan="2" style="text-align: left;"><span class="span_essential">*</span> 포트 번호</th>
					<td colspan="3">
						<input type="text" id="txtPORT" name="port" class="input_number input_common" maxlength="5" value = "${tableData.VAN_PORT}"  autocomplete="off" data-isEssential="true" style="width: 174px;">
					</td>
				</tr>
				<tr height="30">
					<th colspan="2" style="text-align: left;"><span class="span_essential">*</span> 사용 여부</th>
					<td colspan="3">
						<div id="cmbUSE_YN"></div>
					</td>
				</tr>
				<tr height="70">
					<th colspan="5" style="text-align: justify; font-weight: initial;">
						아이피 번호 : 0 ~ 255<br><br>
						포트 번호 : 0 ~ 65535	
					</th>
				</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
</body>
</html>