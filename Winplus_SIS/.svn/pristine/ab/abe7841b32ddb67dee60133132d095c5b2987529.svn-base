<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include
	page="/WEB-INF/jsp/common/include/default_resources_header.jsp" />
<jsp:include
	page="/WEB-INF/jsp/common/include/default_page_script_header.jsp" />
<script type="text/javascript">
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpPopupWindowsCell : Object / 시스템 팝업 윈도우 Cell DhtmlxWindowsCell; 
		■ erpPopupLayout : Object / 페이지 Layout DhtmlxLayout
		■ erpPopupRibbon : Object / 리본형 버튼 목록 DhtmlxRibbon
		■ erpPopupGrid : Object / 표준분류코드 조회 DhtmlxGrid
	--%>
	var erpPopupWindowsCell = parent.erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupVault;
	var erpPopupVaultUploadUrl;
	var erpPopupVaultFnOnUploadFile;
	var erpPopupVaultFnOnUploadComplete;
	var erpPopupVaultFnOnFileAdd;
	var erpPopupVaultFnOnBeforeClear;
	
	var BBS_KIND = "${bbsContent.BBS_KIND}";
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			if(BBS_KIND == "NOTICE"){
				erpPopupWindowsCell.setText("공지사항 게시글 작성");
			}else{
				erpPopupWindowsCell.setText("사원마당 게시글 작성");
			}
		}
		initErpPopupLayout();
		initErpPopupRibbon();
		
		if(true){
			$erp.setReadOnlyDom("txtSJ", false);
			$erp.setReadOnlyDom("txtCN", false);
		}
		initCombo();
	});
	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "", header:false, fix_size : [false, false]}
				, {id: "b", text: "", header:false, fix_size : [false, false]}
				
			]		
		});
		erpPopupLayout.cells("a").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_event");
		erpPopupLayout.setSeparatorSize(1, 0);
		erpPopupLayout.setSizes();
		<%-- erpPopupLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupLayout.setSizes();
		});
	}	
	
	<%-- erpPopupLayout 초기화 Function --%>	
	function initErpPopupRibbon(){
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "save_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false}									
				]}							
			]
		});
		
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "save_erpPopupGrid"){
		    	saveErpPopupGrid();
		    }
		});
	}
	
	function initCombo(){
		cmdBBS_DIV_CD = new dhtmlXCombo("cmdBBS_DIV_CD");
		cmdBBS_DIV_CD.setSize(110);
		if(BBS_KIND == "NOTICE"){
			cmdBBS_DIV_CD.addOption([ 
				{value: "1", text: "공지",selected: true},
				{value: "2", text: "부재자"},
				{value: "3", text: "패치사항"},
				{value: "4", text: "문자발송"},
				{value: "5", text: "온라인행사"},
				{value: "6", text: "제품"}
			]);
		}else{
			cmdBBS_DIV_CD.addOption([{value: "0", text: "기타",selected: true}]);
		}
	}
	
	<%-- erpPopupGrid 수정 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;		
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		var SJ = document.getElementById("txtSJ").value;
		var CN = document.getElementById("txtCN").value;
		
		if(SJ.trim()==""||CN.trim()==""){
			isValidated = false;
			alertMessage = "error.common.noEssentialData";
			alertCode = "-1";
		} 	
		if($erp.isByteSizeOver(CN, 4000)||$erp.isByteSizeOver(SJ, 1000)){
			isValidated = false;
			alertMessage = "error.common.noEssentialData";
			alertCode = "-1";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
		
	<%-- erpGrid 저장 Function --%>
	function saveErpPopupGrid(){

		if(!isSearchValidate()){
			return;
		}

		var CRUD = "C";
		var SJ = document.getElementById("txtSJ").value;
		var CN = document.getElementById("txtCN").value;
		var BBS_DIV_CD = cmdBBS_DIV_CD.getSelectedValue();
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/common/board/insertBoardPopup.do"
			,data : {
				"CRUD" : CRUD
				,"SJ" : SJ
				,"CN" : CN
				,"BBS_DIV_CD" : BBS_DIV_CD
				,"BBS_KIND" : BBS_KIND
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			},complete:function(){
				//1. 조회하기
				erpPopupParentWindow.searchErpGrid();
				$erp.closePopup();
			}
		});
	}

</script>
</head>
<body style="background-color: #dfe8f6">
	<div id="div_erp_popup_ribbon" class="div_ribbon_full_size"	style="display: none"></div>
	<div id="div_erp_event" class="div_common_contents_full_size">
		<table id="tb_erp_data" class="tb_erp_common" style="margin-top: 0px;">
			<colgroup>
				<col width="95px" />
				<col width="170px" />
				<col width="90px" />
				<col width="175px" />
				<col width="90px" />
				<col width="175px" />
			</colgroup>
				<tr>
					<th><span class='span_essential'>*</span>제목</th>
					<td colspan="3">
					<input type="text" id="txtSJ" name="SJ" value="" size="70"  readonly="readonly"></td>
					<th>중요도</th>
					<td><div id="cmdBBS_DIV_CD"></div></td>
				</tr>
				<tr>
					<th><span class='span_essential'>*</span>상세내용</th>
					<td colspan="5"><textarea rows="28" id="txtCN" name="CN" class="input_common" readonly="readonly"></textarea></td>
				</tr>
		</table>
	</div>

</body>
</html>