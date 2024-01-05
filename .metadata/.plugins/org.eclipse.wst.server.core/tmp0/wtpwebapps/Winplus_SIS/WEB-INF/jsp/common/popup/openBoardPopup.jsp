<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp" />
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp" />
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">
	
	<%--
	※ 전역 변수 선언부 
	□ 변수명 : Type / Description
	■ thisPopupWindow : 현재 팝업 윈도우
	■ total_layout : 전체 페이지 레이아웃 
	
	--%>
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	
	var isManager = LUI.LUI_is_manager;
	var loginUser = "${empSessionDto.emp_no}";
	
	var thisPopupWindow = parent.erpPopupWindows.window('openBoardPopup');
	
	var total_layout;
	
	var boardInfo = '${boardInfo}'; 	//게시물 데이터
	var extra = '${extra}';				//게시물 첨부파일 리스트
	
	var uploadFileLimitCount = 5; //파일 업로드 개수 제한
	
	var multiCheckReadonlyMessage = "이미 게시된 글은 수정 할 수 없습니다.";
	
	$(document).ready(function(){
		
		if(thisPopupWindow){
			thisPopupWindow.setText('게시글');
			thisPopupWindow.denyResize();
			thisPopupWindow.denyMove();
		}
		
		init_total_layout();
		init_top_layout();
		init_bot_layout();
		
		if(boardInfo){
			boardInfo = JSON.parse(boardInfo);
		}
		
		if(extra != "" && extra != "[]"){
// 			extra = JSON.parse(extra);
			extra = extra.replace(/\\\\/g,"//");
			extra = extra.replace(/\\/g,"/");
			extra = extra.replace(/\/\//g,"/");
			extra = eval(extra);
		}
		
		//모든 레이아웃 초기화 함수 호출후 등록해주세요.
		$erp.asyncObjAllOnCreated(function(){
			if("${empSessionDto.board_publish_scope_part}" == "MK"){
				$erp.objReadonly(["cmbBOARD_PUBLISH_SCOPE_MK"]);
			}else if("${empSessionDto.board_publish_scope_part}" == "P"){
				$erp.objReadonly(["cmbBOARD_PUBLISH_SCOPE_P"]);
			}else if("${empSessionDto.board_publish_scope_part}" == "S"){
				$erp.objReadonly(["cmbBOARD_PUBLISH_SCOPE_S"]);
			}
			
			if(boardInfo){
				$erp.dataAutoBind("bot_table", boardInfo);
				
				if("${empSessionDto.board_publish_scope_part}" == "WINPLUS"){
					cmbBOARD_PUBLISH_SCOPE_WINPLUS.multiCheckReadonly(multiCheckReadonlyMessage);
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_WINPLUS, boardInfo.BOARD_PUBLISH_SCOPE);
					cmbBOARD_PUBLISH_SCOPE_MK.multiCheckReadonly(multiCheckReadonlyMessage);
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_MK, boardInfo.BOARD_PUBLISH_SCOPE);
					cmbBOARD_PUBLISH_SCOPE_P.multiCheckReadonly(multiCheckReadonlyMessage);
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_P, boardInfo.BOARD_PUBLISH_SCOPE);
					cmbBOARD_PUBLISH_SCOPE_S.multiCheckReadonly(multiCheckReadonlyMessage);
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_S, boardInfo.BOARD_PUBLISH_SCOPE);
				}else if("${empSessionDto.board_publish_scope_part}" == "MK"){
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_MK, "${empSessionDto.board_publish_scope_cd}");
				}else if("${empSessionDto.board_publish_scope_part}" == "P"){
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_P, "${empSessionDto.board_publish_scope_cd}");
				}else if("${empSessionDto.board_publish_scope_part}" == "S"){
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_S, "${empSessionDto.board_publish_scope_cd}");
				}
				
			}else{
				
				if("${empSessionDto.board_publish_scope_part}" == "WINPLUS"){
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_WINPLUS, "${BOARD_PUBLISH_SCOPE_WINPLUS}" == ""? [] : "${BOARD_PUBLISH_SCOPE_WINPLUS}".split(","));
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_MK, "${BOARD_PUBLISH_SCOPE_MK}" == ""? [] : "${BOARD_PUBLISH_SCOPE_MK}".split(","));
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_P, "${BOARD_PUBLISH_SCOPE_P}" == ""? [] : "${BOARD_PUBLISH_SCOPE_P}".split(","));
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_S, "${BOARD_PUBLISH_SCOPE_S}" == ""? [] : "${BOARD_PUBLISH_SCOPE_S}".split(","));
				}else if("${empSessionDto.board_publish_scope_part}" == "MK"){
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_MK, "${BOARD_PUBLISH_SCOPE_MK}" == ""? [] : "${BOARD_PUBLISH_SCOPE_MK}".split(","));
				}else if("${empSessionDto.board_publish_scope_part}" == "P"){
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_P, "${BOARD_PUBLISH_SCOPE_P}" == ""? [] : "${BOARD_PUBLISH_SCOPE_P}".split(","));
				}else if("${empSessionDto.board_publish_scope_part}" == "S"){
					$erp.setMultiCheckComboValue(cmbBOARD_PUBLISH_SCOPE_S, "${BOARD_PUBLISH_SCOPE_S}" == ""? [] : "${BOARD_PUBLISH_SCOPE_S}".split(","));
				}
				
			}
			
			if((!isManager && document.getElementById("txtCUSER").value != loginUser) || currentMenu_cd == ""){
				if(!(cmbCRUD.getSelectedValue() == "C")){
					$erp.tableReadonly("bot_table");
					top_ribbon.disable("delete_data");
					top_ribbon.disable("save_data");
				}
			}
			
			
			if(typeof extra != "string"){
				createAttachFileDom(extra);
			}
			
			if((!isManager && document.getElementById("txtCUSER").value != loginUser) || currentMenu_cd == ""){
				if(!(cmbCRUD.getSelectedValue() == "C")){
					$('input[type="button"]').attr('disabled', true);
				}
			}
		});
		
	});
	
	<%-- ■ total_layout 초기화 시작 --%>
	function init_total_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
				, cells: [
					{id: "a", text: "", header:false, fix_size : [true, true]}
					, {id: "b", text: "", header:false, fix_size : [true, true]}
				]
		});
		
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight(36);
		total_layout.cells("b").attachObject("div_bot_layout");
		
		total_layout.setSeparatorSize(0, 1);
		
		
	}
	<%-- ■ total_layout 초기화 끝 --%>
	
	<%-- ■ top_layout 초기화 시작 --%>
	function init_top_layout(){
		
		top_ribbon = new dhtmlXRibbon({
			parent : "div_top_layout"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{
						type : "block"
						, mode : 'rows'
						, list : [
							  {id : "delete_data", 	type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
							, {id : "save_data", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
						]
					}							
				]
		});
		
		top_ribbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "delete_data"){
				
				if(!updateAuthCheck()){
					return;
				}
				
				$erp.confirmMessage({
					"alertMessage" : "삭제하시겠습니까?",
					"alertType" : "alert",
					"isAjax" : false,
					"alertCallbackFn" : function(){
						cmbCRUD.setComboValue("D");
						saveBoard();
					},
					"alertCallbackFnFalse" : function(){
						
					}
				});
				
			} else if (itemId == "save_data"){
				saveBoard();
			}
		});
		
	}
	
	<%-- 수정 유효성 검사 --%>
	function isSearchValidate(){
		var isValidated = true;		
		var alertMessage = "";
		var alertType = "error";
		var SUBJECT = document.getElementById("txtSUBJECT").value;
		var CONTENT = document.getElementById("txtCONTENT").value;
		
		if(SUBJECT.trim()==""||CONTENT.trim()==""){
			isValidated = false;
			alertMessage = "제목과 상세내용을 입력해주세요.";
		} 	
		if($erp.isByteSizeOver(CONTENT, 4000)||$erp.isByteSizeOver(SUBJECT, 200)){
			isValidated = false;
			alertMessage = "제목:100자 또는 상세내용:2000자를<br/>초과 하였습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertType" : alertType
				, "isAjax" : false
			});
		}
		
		return isValidated;
	}
		
	<%-- 저장 --%>
	function saveBoard(){

		if(!isSearchValidate()){
			return;
		}
		
		if(!updateAuthCheck()){
			return;
		}
		
		var paramMap = $erp.dataSerialize("bot_table", "Q");
		paramMap.SUBJECT = paramMap.SUBJECT.replace(/\"/g, "''");
		
		paramMap["BOARD_PUBLISH_SCOPE"] = [];
		if(paramMap["BOARD_PUBLISH_SCOPE_WINPLUS"] instanceof Array){
			paramMap["BOARD_PUBLISH_SCOPE"] = paramMap["BOARD_PUBLISH_SCOPE"].concat(paramMap["BOARD_PUBLISH_SCOPE_WINPLUS"]);
		}
		if(paramMap["BOARD_PUBLISH_SCOPE_MK"] instanceof Array){
			paramMap["BOARD_PUBLISH_SCOPE"] = paramMap["BOARD_PUBLISH_SCOPE"].concat(paramMap["BOARD_PUBLISH_SCOPE_MK"]);
		}
		if(paramMap["BOARD_PUBLISH_SCOPE_P"] instanceof Array){
			paramMap["BOARD_PUBLISH_SCOPE"] = paramMap["BOARD_PUBLISH_SCOPE"].concat(paramMap["BOARD_PUBLISH_SCOPE_P"]);
		}
		if(paramMap["BOARD_PUBLISH_SCOPE_S"] instanceof Array){
			paramMap["BOARD_PUBLISH_SCOPE"] = paramMap["BOARD_PUBLISH_SCOPE"].concat(paramMap["BOARD_PUBLISH_SCOPE_S"]);
		}
		
		var url = "/common/board/insertBoardPopup.do";
		var send_data = paramMap;
		var if_success = function(data){
			if(data.dataMap && data.dataMap.BOARD_NO){
				$erp.dataAutoBind("bot_table", data.dataMap);
			}
			
			onBoardSaved();
			
			$erp.alertMessage({
				"alertMessage" : "저장성공",
				"alertType" : "alert",
				"isAjax" : false
//					"alertCallbackFn" : function(){
//						thisPopupWindow.close();
//					}
			});
			
		}
		
		var if_error = function(XHR, status, error){}
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
	
	<%-- ■ top_layout 초기화 끝 --%>
	
	<%-- ■ bot_layout 초기화 시작 --%>
	function init_bot_layout(){
		
		if("${empSessionDto.board_publish_scope_part}" == "WINPLUS"){
			cmbBOARD_PUBLISH_SCOPE_WINPLUS = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_WINPLUS", 	"BOARD_PUBLISH_SCOPE_WINPLUS", 	"/sis/code/getBoardPublishScope.do", {"PART" : "WINPLUS"}, 150, "본사", false, null);
			cmbBOARD_PUBLISH_SCOPE_MK = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_MK", 			"BOARD_PUBLISH_SCOPE_MK", 		"/sis/code/getBoardPublishScope.do", {"PART" : "MK"}, 150, "직영점", false, null);
			cmbBOARD_PUBLISH_SCOPE_P = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_P", 				"BOARD_PUBLISH_SCOPE_P", 		"/sis/code/getBoardPublishScope.do", {"PART" : "P"}, 150, "협력사", false, null);
			cmbBOARD_PUBLISH_SCOPE_S = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_S", 				"BOARD_PUBLISH_SCOPE_S", 		"/sis/code/getBoardPublishScope.do", {"PART" : "S"}, 150, "고객사", false, null);
		}else if("${empSessionDto.board_publish_scope_part}" == "MK"){
			cmbBOARD_PUBLISH_SCOPE_MK = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_MK", 			"BOARD_PUBLISH_SCOPE_MK", 		"/sis/code/getBoardPublishScope.do", {"PART" : "MK"}, 150, "직영점", false, null, multiCheckReadonlyMessage);
		}else if("${empSessionDto.board_publish_scope_part}" == "P"){
			cmbBOARD_PUBLISH_SCOPE_P = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_P", 				"BOARD_PUBLISH_SCOPE_P", 		"/sis/code/getBoardPublishScope.do", {"PART" : "P"}, 150, "협력사", false, null, multiCheckReadonlyMessage);
		}else if("${empSessionDto.board_publish_scope_part}" == "S"){
			cmbBOARD_PUBLISH_SCOPE_S = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_S", 				"BOARD_PUBLISH_SCOPE_S", 		"/sis/code/getBoardPublishScope.do", {"PART" : "S"}, 150, "고객사", false, null, multiCheckReadonlyMessage);
		}
		
		cmbCRUD = $erp.getDhtmlXComboCommonCode("cmbCRUD", "CRUD", "CRUD_STATE", 70, null, false, null);
		$erp.objReadonly("cmbCRUD");
		cmbBOARD_KIND_CD = $erp.getDhtmlXComboCommonCode("cmbBOARD_KIND_CD", "BOARD_KIND_CD", "BOARD_KIND_CD", 150, null, false, null);
		
		chkMAIN_DISPLAY_YN = $erp.getDhtmlXCheckBox('chkMAIN_DISPLAY_YN', '메인화면 표시', '1', false, 'label-right');
		
	}
	<%-- ■ bot_layout 초기화 끝 --%>
	
	//파일 첨부 팝업 띄우기
	function openFileAttachPopup(){
		
		if(!updateAuthCheck()){
			return;
		}
		
		var ATTACH_FILES = document.getElementById("ATTACH_FILES");
		var existAttachFileCount = 0;
		
		for(var index in ATTACH_FILES.children){
			if(ATTACH_FILES.children[index].innerHTML && ATTACH_FILES.children[index].innerHTML != ""){
				existAttachFileCount++;
			}
		}
		
		if(existAttachFileCount == 5){
			$erp.alertMessage({
				"alertMessage" : "더이상 업로드 파일을 추가 할 수 없습니다.",
				"alertCode" : "업로드 파일 개수 제한 : " + uploadFileLimitCount + "개",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}
		
		var onUploadFile = function(files, serverReturnData){ //업로드 파일 수만큼 발생
		
		};
		var onUploadComplete = function(uploadedFileInfoList, lastServerReturnData){ //전체 파일 업로드 후 발생
			createAttachFileDom(lastServerReturnData);
		};
		var onBeforeFileAdd = function(file){}; //선택한 업로드 파일이 팝업창에 하나씩 추가될때 발생
		var onBeforeClear = function(){};
		
		var FILE_GRUP_NO = document.getElementById("txtFILE_GRUP_NO").value;
		
		if(FILE_GRUP_NO != undefined && FILE_GRUP_NO != null && FILE_GRUP_NO != ""){
	 		$erp.openAttachFilesUploadPopup({"DIRECTORY_KEY" : "board", "FILE_GRUP_NO" : FILE_GRUP_NO, "FILE_REG_TYPE" : "board"}, uploadFileLimitCount, existAttachFileCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
		}else{
			var url = "/common/system/file/getFileGrupNo.do";
			var send_data = {};
			var if_success = function(data){
				document.getElementById("txtFILE_GRUP_NO").value = data.FILE_GRUP_NO;
		 		$erp.openAttachFilesUploadPopup({"DIRECTORY_KEY" : "board", "FILE_GRUP_NO" : data.FILE_GRUP_NO, "FILE_REG_TYPE" : "board"}, uploadFileLimitCount, existAttachFileCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			}
			
			var if_error = function(XHR, status, error){}
			
			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
		}
 		
	}
	
	function createAttachFileDom(attachFileInfoList){
		var ATTACH_FILES = document.getElementById("ATTACH_FILES");
		var divDom;
		var aDom;
		var buttonDom;
		
		for(var i=0; i<uploadFileLimitCount; i++){
			ATTACH_FILES.children[i].innerHTML = "";
		}
		
		for(let index in attachFileInfoList){
			ATTACH_FILES.children[index].innerHTML = "";
			divDom = document.createElement("div");
			divDom.style = "height : 20px;"
			aDom = document.createElement("a");
			aDom.innerHTML = attachFileInfoList[index].FILE_ORG_NM;
			aDom.href = "#";
			aDom.onclick = function(){
				$erp.requestFileDownload({"FILE_GRUP_NO" : attachFileInfoList[index].FILE_GRUP_NO, "FILE_SEQ" : attachFileInfoList[index].FILE_SEQ});
				return false;
			}
			buttonDom = document.createElement("input");
			buttonDom.type = "button";
			buttonDom.value = "X";
			buttonDom.className = "input_common_button"; 
			buttonDom.style = "margin-left : 10px; width : 26px; height: 18px;";
			buttonDom.onclick = function(){
				if(!updateAuthCheck()){
					return;
				}
				
				var params = {
					"FILE_GRUP_NO" : attachFileInfoList[index].FILE_GRUP_NO	//필수
					, "FILE_SEQ" : attachFileInfoList[index].FILE_SEQ					//필수
				}
				
				var url = "/common/system/file/deleteAttachFile.do";
				var send_data = params;
				var if_success = function(data){
					if(data.extra){
						createAttachFileDom(data.extra);
					}
				}
				
				var if_error = function(XHR, status, error){
				}
				
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
				
			}
			ATTACH_FILES.children[index].appendChild(aDom);
			ATTACH_FILES.children[index].appendChild(buttonDom);
		}
	}
	
	//수정권한 체크 : 등록자, 관리자인지
	function updateAuthCheck(){
		var CUSER = document.getElementById("txtCUSER").value;
		if(!(cmbCRUD.getSelectedValue() == "C") && (!isManager && CUSER != loginUser)){
			$erp.alertMessage({
				"alertMessage" : "해당 게시물의 등록자, 관리자만 변경 가능합니다.",
				"alertType" : "error",
				"isAjax" : false
			});
			return false;
		}else{
			return true;
		}
	}
	
	
</script>
</head>
<body>


	<div id="div_top_layout" class="div_ribbon_full_size" style="display:none;"></div>

	<div id="div_bot_layout" class="samyang_div" style="display:none">
		<div id="div_bot_layout_table" class="samyang_div">
			<table id="bot_table" class="table">
				<colgroup>
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="*">
				</colgroup>
				<tr>
					<th colspan="1">게시범위</th>
					
					<c:choose>
						<c:when test="${empSessionDto.board_publish_scope_part == 'WINPLUS'}">
							<td colspan="2"><div id="cmbBOARD_PUBLISH_SCOPE_WINPLUS"></div></td>
							<td colspan="2"><div id="cmbBOARD_PUBLISH_SCOPE_MK"></div></td>
							<td colspan="2"><div id="cmbBOARD_PUBLISH_SCOPE_P"></div></td>
							<td colspan="6"><div id="cmbBOARD_PUBLISH_SCOPE_S"></div></td>
						</c:when>
						<c:when test="${empSessionDto.board_publish_scope_part == 'MK'}">
							<td colspan="12"><div id="cmbBOARD_PUBLISH_SCOPE_MK"></div></td>
						</c:when>
						<c:when test="${empSessionDto.board_publish_scope_part == 'P'}">
							<td colspan="12"><div id="cmbBOARD_PUBLISH_SCOPE_P"></div></td>
						</c:when>
						<c:when test="${empSessionDto.board_publish_scope_part == 'S'}">
							<td colspan="12"><div id="cmbBOARD_PUBLISH_SCOPE_S"></div></td>
						</c:when>
					</c:choose>
				</tr>
				
				<tr>
					<th colspan="1">글번호</th>
					<td colspan="1">
						<input type="text" id="txtBOARD_NO" class="input_text input_readonly" value="" readonly disabled/>
						<input type="hidden" id="txtFILE_GRUP_NO" class="input_text"/>
					</td>
					<th colspan="1">조회수</th>
					<td colspan="1"><input type="text" id="txtRDCNT" class="input_text input_readonly" value="" readonly disabled/></td>
					<th colspan="1">게시타입</th>
					<td colspan="2"><div id="cmbBOARD_KIND_CD"></div></td>
					<th colspan="1">게시물상태</th>
					<td colspan="5"><div id="cmbCRUD"></div></td>
				</tr>
				
				<tr>
					<th><span class='span_essential'>*</span>제목</th>
					<td colspan="5">
						<input type="text" id="txtSUBJECT" name="SUBJECT" value="${boardSubject}" size="50" maxlength="100"/>
					</td>
					<td colspan="7">
						<div id="chkMAIN_DISPLAY_YN"></div>
					</td>
				</tr>
				
				<tr>
					<th><span class='span_essential'>*</span>상세내용</th>
					<td colspan="12"><textarea rows="28" id="txtCONTENT" name="CONTENT" class="input_common" style="width:100%; height:365px; box-sizing: border-box; white-space:pre-wrap; ">${boardContent}</textarea></td>
				</tr>
				
				<tr>
					<th colspan="1"><input type="button" id="btnFILE_ATTACH" class="input_common_button" value="첨부파일" onClick="openFileAttachPopup()"/></th>
					<td colspan="12" id="ATTACH_FILES" style="height: 100px;">
						<div style="height:20px;"></div>
						<div style="height:20px;"></div>
						<div style="height:20px;"></div>
						<div style="height:20px;"></div>
						<div style="height:20px;"></div>
					</td>
				</tr>
				
				<tr>
					<th>등록자</th>
					<td colspan="2"><input type="text" id="txtCUSER" class="input_text input_readonly" value="" readonly disabled/></td>
					
					<th>등록일</th>
					<td colspan="2"><input type="text" id="txtCDATE" class="input_text input_readonly" value="" readonly disabled/></td>
					
					<th>수정자</th>
					<td colspan="2"><input type="text" id="txtMUSER" class="input_text input_readonly" value="" readonly disabled/></td>
					
					<th>수정일</th>
					<td colspan="2"><input type="text" id="txtMDATE" class="input_text input_readonly" value="" readonly disabled/></td>
					
					<td></td>
				</tr>

			</table>
		</div>
	</div>
</body>
</html>