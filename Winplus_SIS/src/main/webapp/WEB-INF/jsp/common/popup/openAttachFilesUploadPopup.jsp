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

	var erpPopupWindowsCell = parent.erpPopupWindows.window("openAttachFilesUploadPopup");	
	
	var erpPopupVault;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("${screenDto.scrin_nm}");	
		}
		
	});

	function onLoad(){
		initVault();
	}
	
	
	function initVault(){
		
		var vaultUrl = "/common/system/file/uploadAttachFile.do";
		
		erpPopupVault = $erp.getDhtmlXVault('vaultObj', vaultUrl, uploadFileLimitCount, paramMap);
		
		if(onUploadFileDefault && typeof onUploadFileDefault === 'function'){
			erpPopupVault.attachEvent("onUploadFile", onUploadFileDefault);
		}
		
		if(onUploadCompleteDefault && typeof onUploadCompleteDefault === 'function'){
			erpPopupVault.attachEvent("onUploadComplete", onUploadCompleteDefault);
		}
		
		if(onBeforeFileAddDefault && typeof onBeforeFileAddDefault === 'function'){
			erpPopupVault.attachEvent("onBeforeFileAdd", onBeforeFileAddDefault);
		}
		
		if(onBeforeClearDefault && typeof onBeforeClearDefault === 'function'){
			erpPopupVault.attachEvent("onBeforeClear", onBeforeClearDefault);
		}
		
	} 
	
	function alertMessage(param){
		$erp.alertMessage(param);
	}
</script>
</head>
<body>

	<div id="vaultObj" style="width:499px;height: 459px;"></div>

</body>
</html>