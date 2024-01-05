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
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ total_layout : Object / 페이지 layout DhtmlXLayout
		■ ribbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ grid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbUSE_YN : Object / 사용여부 DhtmlXCombo  (CODE : 'YN_CD' / 빈 칸 : 전체)
		■ cmbCMMN_YN : Object / 공통여부 DhtmlXCombo  (CODE : 'YN_CD' / 빈 칸 : 전체) 		 
	--%>
	var total_layout;	
	var layout;
	
	var ribbon;
	
	$(document).ready(function(){		

		inittotal_layout();
		initLayout();
	});
	
	
	<%-- total_layout 초기화 Function --%>	
	function inittotal_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "내 정보", header:true, width:500, fix_size:[true, true]}
			]		
		});
		
		total_layout.cells("a").attachObject("div_layout");
		
	}
	

	function initLayout(){
		layout = new dhtmlXLayoutObject({
			parent: "div_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "", header:false, fix_size:[true, true]}
// 				, {id: "b", text: "", header:false, fix_size:[true, true]}
			]			
		});
		
// 		layout.cells("a").attachObject("div_ribbon");
// 		layout.cells("a").setHeight(36);

		layout.cells("a").attachObject("div_table");

		layout.setSeparatorSize(0, 1); //테이블 리본 사이간격

		layout.captureEventOnParentResize(total_layout); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.
		
		
// 		ribbon = new dhtmlXRibbon({
// 			parent : "div_ribbon"
// 			, skin : ERP_RIBBON_CURRENT_SKINS
// 			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
// 			, items : [
// 				{type : "block", mode : 'rows', list : [
// 					{id : "save_data", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
// 				]}
// 			]
// 		});
		
// 		ribbon.attachEvent("onClick", function(itemId, bId){
// 			if (itemId == "save_data"){
// 		    	saveData();
// 		    }
// 		});
		
	}
	
	function passwordChange(){
		
		var resultData;
		resultData = $erp.tableValidationCheck("myAccount");
		if(resultData === false){ //false 가 아닐시 정상(직렬화된 데이터)
				$erp.alertMessage({
					"alertMessage" : "필수 입력 항목이 남아있습니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			return;
		}
		
		if(resultData.NOW_PW == resultData.AFTER_PW1){
			$erp.alertMessage({
				"alertMessage" : "현재 비밀번호와 변경할 비밀번호가 동일합니다.",
				"alertType" : "alert",
				"isAjax" : false
			});
			return;
		}else if(resultData.AFTER_PW1 != resultData.AFTER_PW2){
			$erp.alertMessage({
				"alertMessage" : "변경할 비밀번호와 확인 비밀번호가 일치 하지 않습니다.",
				"alertType" : "alert",
				"isAjax" : false
			});
			return;
		}
		
		var url = "/common/myAccount/passwordChange.do";
		var send_data = resultData;
		var if_success = function(data){
			$erp.alertMessage({
				"alertMessage" : data.result,
				"alertType" : "alert",
				"isAjax" : false
			});
		}
		var if_error = function(XHR, status, error){}
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
</script>
</head>
<body>		

	<div id="div_layout" class="samyang_div" style="display:none">
		<div id="div_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
		<div id="div_table" class="samyang_div" style="display:none">
			<table id="myAccount" class="table">
				<colgroup>
					<col width="120px"/>
					<col width="200x"/>
					<col width="70px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th>사용자명</th>
					<td colspan="1">
						<input type="text" id="txtNAME" class="input_text input_readonly" value="${NAME}" readonly disabled/>
					</td>
					<td colspan="2"></td>
				</tr>
				<tr>
					<th>아이디</th>
					<td colspan="1">
						<input type="text" id="txtID" class="input_text input_readonly" value="${ID}" readonly disabled/>
					</td>
					<td colspan="2"></td>
				</tr>
				<tr>
					<th>연락처</th>
					<td colspan="1">
						<input type="text" id="txtMBTLNUM" class="input_text input_readonly" value="${MBTLNUM}" readonly disabled/>
					</td>
					<td colspan="2"></td>
				</tr>
				<tr>
					<th>이메일</th>
					<td colspan="1">
						<input type="text" id="txtEMAIL" class="input_text input_readonly" value="${EMAIL}" readonly disabled/>
					</td>
					<td colspan="2"></td>
				</tr>
				<tr>
					<td colspan="4"></td>
				</tr>
				<tr>
					<th colspan="2" style="text-align: center;">비밀번호변경</th>
					<td colspan="2"></td>
				</tr>
				<tr>
					<th>현재비밀번호</th>
					<td colspan="1">
						<input type="password" id="txtNOW_PW" class="input_text" value="" data-isEssential="true"/>
					</td>	
					<td colspan="1" rowspan="3"><input type="button" id="btnPW_CHANGE" class="input_common_button" value="변경" onClick="passwordChange()" style="width: 100%; height: 100%"/></td>
					<td colspan="1"></td>
				</tr>
				<tr>
					<th>변경비밀번호</th>
					<td colspan="1">
						<input type="password" id="txtAFTER_PW1" class="input_text" value="" data-isEssential="true"/>
					</td>	
					<td colspan="1"></td>
				</tr>
				<tr>
					<th>변경비밀번호확인</th>
					<td colspan="1">
						<input type="password" id="txtAFTER_PW2" class="input_text" value="" data-isEssential="true"/>
					</td>	
					<td colspan="1"></td>
				</tr>
			</table>
		</div>
	</div>
	
</body>
</html>