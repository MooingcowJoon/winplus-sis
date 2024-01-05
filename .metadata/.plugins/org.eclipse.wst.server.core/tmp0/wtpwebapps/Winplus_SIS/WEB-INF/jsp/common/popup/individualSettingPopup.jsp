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
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpPopupWindowsCell : Object / 시스템 팝업 윈도우 Cell DhtmlxWindowsCell; 
		■ erpPopupLayout : Object / 페이지 Layout DhtmlxLayout
		
		■ erpPopupSubLayout : Object / 페이지 Layout DhtmlxLayout
		■ erpPopupRibbon : Object / 리본형 버튼 목록 DhtmlxRibbon
	--%>
	var erpPopupWindowsCell = parent.erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
	
	var erpPopupLayout;
	var erpPopupRibbon;
	
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("${screenDto.scrin_nm}");	
		}
		initErpPopupLayout();
		initErpPopupRibbon();
		initDhtmlXCombo();
	});
	
	<%--
	**********************************************************************
	* ※ Master 영역
	**********************************************************************
	--%>	
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>	
	<%-- erpPopupLayout 초기화 Function --%>	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "비밀번호 변경", header:true, fix_size : [true, true]}
				, {id: "b", text: "", header:false, fix_size : [true, true]}
			]		
		});
		
		erpPopupLayout.conf.ofs = {b : 4, l : 4, r : 4, t : 4};
		erpPopupLayout.setAutoSize("a;b;c;d", "c");
		erpPopupLayout.cells("a").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("a").hideArrow();
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_WITH_HEADER_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_contents");
		
		erpPopupLayout.setSeparatorSize(0, 0);
		erpPopupLayout.setSizes();
		
		<%-- erpPopupLayout 사이즈 변경 시 Event --%>
		/* $erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
		}); */

	}
	<%-- ■ erpPopupLayout 관련 Function 끝 --%>	
	
	<%-- ■ erpPopupRibbon 관련 Function 시작 --%>	
	<%-- erpPopupRibbon 초기화 Function --%>	
	function initErpPopupRibbon(){
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "apply_erpPopupData", type : "button", text:'<spring:message code="ribbon.apply" />', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif"}
				]}							
			]
		});
		
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
		   if(itemId == "apply_erpPopupData"){
		    	applyErpPopupData();
		    }
		});
	}
	<%-- ■ erpPopupRibbon 관련 Function 끝 --%>	
	
	
	<%-- ■ erpPopupData 관련 Function 시작 --%>		
	<%-- erpPopupData 승인 유효성 Function --%>		
	function isApplyPopupValidate(){
		var isValidated = true;
		var infoMessage = '<spring:message code="info.common.essentialItem" />';
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		var alertCallbackFn;
		var alertCallbackFnParam;
		
		var resultObj = $erp.getElementEssentialEmpty("tb_contents");
		if(resultObj){
			alertCallbackFnParam = {"obj" : resultObj, "message" : infoMessage};
			alertCallbackFn = function(param){
				$erp.initDhtmlXPopupDom(param.obj, param.message);
			}				
			isValidated = false;
			alertMessage = "error.common.noEssentialData";
			alertCode = "-1";					
		}
		
		<%-- 보안을 위해 나머지 로직은 모두 서버에서 처리 --%>		
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
				, "alertCallbackFn" : alertCallbackFn 
				, "alertCallbackFnParam" : alertCallbackFnParam
			});
		}
		
		return isValidated;
	}
	
	<%-- erpPopupData 승인 Function --%>		
	function applyErpPopupData(){
		if(!isApplyPopupValidate()) { return false }
		
		erpPopupLayout.progressOn();
		
		var now_password = document.getElementById("NOW_PASSWORD").value;
		var change_password = document.getElementById("CHANGE_PASSWORD").value;
		var change_password_recnfrm = document.getElementById("CHANGE_PASSWORD_RECNFRM").value;
		
		var param = {
			"NOW_PASSWORD" : now_password
			, "CHANGE_PASSWORD" : change_password
			, "CHANGE_PASSWORD_RECNFRM" : change_password_recnfrm
		}
		
		$.ajax({
			url : "/common/popup/individualSettingPopupU1.do"
			,data : param
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.alertSuccessMesage(function(){
						$erp.closePopup();
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpPopupData 관련 Function 끝 --%>		
	
	<%-- ■ DhtmlxCombo 관련 Function 시작 --%>	
	<%-- DhtmlxCombo 조회 Function --%>
	function initDhtmlXCombo(){
		
	}
	<%-- ■ DhtmlxCombo 관련 Function 끝 --%>	
</script>
</head>
<body>
<div id="div_erp_contents" class="div_common_contents_full_size" style="display:none">
	<table id="tb_contents" class="tb_erp_common" style="margin-top:0px">
		<colgroup>
			<col width="130px" />
			<col width="*" />
		</colgroup>
		<tr>
			<th>현재 비밀번호</th>
			<td>
				<input type="password" id="NOW_PASSWORD" name="NOW_PASSWORD" class="input_common input_essential" maxlength="20" />
			</td>
		</tr>
		<tr>
			<th>변경 비밀번호</th>
			<td>
				<input type="password" id="CHANGE_PASSWORD" name="CHANGE_PASSWORD" class="input_common input_essential" maxlength="20"  />
			</td>
		</tr>
		<tr>
			<th>변경 비밀번호 재확인</th>
			<td>
				<input type="password" id="CHANGE_PASSWORD_RECNFRM" name="CHANGE_PASSWORD_RECNFRM" class="input_common input_essential" maxlength="20"  />
			</td>
		</tr>
		<tr>
			<td colspan="2" class="td_subject"><div class='div_subject'>▣ 비밀번호 작성 규칙</div></td>			
		</tr>
	</table>
		<ul>
			<li>비밀번호 길이 : 9 ~ 20자</li>
			<li>비밀번호 형식 : 비밀번호에 영문자(A-Z a-z), 숫자(0-9), 특수문자 1개 이상 반드시 사용</li>
			<li>입력가능 특수문자 : ! @ # $ % ^ &amp; * ( ) - + =</li>
			<li>비밀번호 변경주기 : 6개월</li>
			<li>※ 2개의 동일 비밀번호를 교대로 사용하지 않습니다.</li>
			<li>※ 비밀번호 5회 연속 로그인 실패 시 비밀번호를 변경합니다.</li>		
		</ul>
</div>
<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
</body>
</html>