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
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("${screenDto.scrin_nm}");
			
		}
		initErpPopupLayout();
		initErpPopupRibbon();
		initVault();
		if(false){
			$erp.setReadOnlyDom("txtSJ", false);
			$erp.setReadOnlyDom("txtCN", false);
		}
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
						{id : "save_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}									
						, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					]}							
				]
			});
			
			erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
			    if(itemId == "save_erpPopupGrid"){
			    	
			    	saveErpPopupGrid();
			    }else if (itemId == "delete_erpGrid"){
			    	deleteErpPopupGrid();
			    }
			});
		}
		<%-- erpPopupGrid 수정 유효성 검사 Function --%>
		function isSearchValidate(){
			var isValidated = true;		
			var alertMessage = "";
			var alertCode = "";
			var alertType = "error";
			var SJ = document.getElementById("txtSJ").value;
			var CN = document.getElementById("txtCN").value;
			var UPD_ID = document.getElementById("txtUPD_ID").value;
			
			if(SJ.trim()==""||CN.trim()==""||UPD_ID.trim()==""){
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
			
			var paramData = $erp.serializeDom("tb_erp_data");
			
			erpPopupLayout.progressOn();
			//var paramData = $erp.serializeDhtmlXGridData(erpGrid);		
			$.ajax({
				url : "/common/popup/updateBoardPopup.do"
				,data : paramData
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
		<%-- erpPopupGrid 삭제 Function --%>
		function deleteErpPopupGrid(){
			
			var callbackFunction = function(){
			var paramData = $erp.serializeDom("tb_erp_data");
			$.ajax({
				url : "/common/popup/deleteBoardPopup.do"
				,data : paramData
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
			$erp.confirmMessage({
				"alertMessage" : '<spring:message code="alert.common.saveData" />'
				, "alertType" : "alert"
				, "alertCallbackFn" : callbackFunction
			});
		}
		function initVault(){
			var params = '';
			var vaultUrl = "/common/system/file/uploadTool.do";
			var erpPopupVaultFnOnUploadComplete=function(files){
				var paramData = $erp.serializeDom("tb_erp_data");
				var addData=[];
				try{
					for(var j=0;j<files.length;j++){
						addData.push(files[j].serverName[0].ATCHMNFL_NO);
					}
				}
				catch(e){addData=[];}
				paramData.ATCHMNFL_NO_ARR=addData;
			}
			if(erpPopupVaultUploadUrl){
				vaultUrl = erpPopupVaultUploadUrl;
			}
			erpPopupVault=$erp.getDhtmlXVault('erpPopupVault', vaultUrl, 1, params,'upload');
			//업로드 성공 이벤트
			if(erpPopupVaultFnOnUploadFile && typeof erpPopupVaultFnOnUploadFile === 'function'){
				erpPopupVault.attachEvent("onUploadFile", erpPopupVaultFnOnUploadFile);
			}
			
			if(erpPopupVaultFnOnUploadComplete && typeof erpPopupVaultFnOnUploadComplete === 'function'){
				erpPopupVault.attachEvent("onUploadComplete", erpPopupVaultFnOnUploadComplete);
			}
			
			if(erpPopupVaultFnOnFileAdd && typeof erpPopupVaultFnOnFileAdd === 'function'){
				erpPopupVault.attachEvent("onBeforeFileAdd", erpPopupVaultFnOnFileAdd);
			}
			
			if(erpPopupVaultFnOnBeforeClear && typeof erpPopupVaultFnOnBeforeClear === 'function'){
				erpPopupVault.attachEvent("onBeforeClear", erpPopupVaultFnOnBeforeClear);
			}	
		}
</script>
</head>
<body style="background-color: #dfe8f6">
	<div id="div_erp_popup_ribbon" class="div_ribbon_full_size"	style="display: none"></div>
	<div id="div_erp_event" class="div_common_contents_full_size">
		<table id="tb_erp_data" class="tb_erp_common" style="margin-top: 0px;">
			<colgroup>
				<col width="95px" />
				<col width="200px" />
				<col width="90px" />
				<col width="175px" />
				<col width="90px" />
				<col width="175px" />
			</colgroup>
				<tr>
					<th>등록자</th>
					<td>${bbsContent.EMP_NM}</td>
					<th>등록일</th>
					<td>${bbsContent.REG_DT}</td>
					<th>조회수</th>
					<td>${bbsContent.RDCNT}</td>
				</tr>
				<tr>
					<th><span class='span_essential'>*</span>제목</th>
					<td colspan="3">
					<input type="hidden" id="txtBBS_DIV_CD" name="BBS_DIV_CD" value="${bbsContent.BBS_DIV_CD}" readonly="readonly">
					<input type="text" id="txtSJ" name="SJ" value="${bbsContent.SJ}" size="50"  readonly="readonly"></td>
					<th>구분</th>
					<td>${bbsContent.SYS_DIV_NM}</td>
				</tr>
				<tr>
					<th><span class='span_essential'>*</span>상세내용</th>
					<td colspan="5"><textarea rows="18" id="txtCN" name="CN" class="input_common" readonly="readonly">${bbsContent.CN}</textarea></td>
				</tr>
				<tr>
					<th>수정자</th>
					<td><input type="hidden" id="txtUPD_ID" name="UPD_ID" class="input_common"  value="${empSessionDto.emp_no}">${bbsContent.UDP_ID}</td>
					<th>수정일</th>
					<td>${bbsContent.UPD_DT}</td>
					<th>글번호</th>
					<td><input type="hidden" id="txtBBS_DIV_CD" name="BBS_DIV_CD" value="${notice.BBS_DIV_CD}">
					<input type="hidden" id="txtBBS_NO"  name="BBS_NO" value="${bbsContent.BBS_NO}">${bbsContent.BBS_NO}</td>
				</tr>
				<tr>
					<th>파일</th>
					<td colspan="5">
					<div id="erpPopupVault" style="width:880px;height: 100px;" class='vault_essential'></div>
					</td>
				</tr>
		</table>
	</div>

</body>
</html>