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

	var erpPopupWindowsCell = parent.erpPopupWindows.window("excelUploadPopup");	
	
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
		
		var vaultUrl = "/common/system/file/xlsUploadParsing.do";
		if(erpPopupVaultUploadUrl && typeof erpPopupVaultUploadUrl == "string"){
			vaultUrl = erpPopupVaultUploadUrl;
		}
		var serializedGridHeader = $erp.headerSerializeOfGrid(uploadTargetGrid);
		var params = serializedGridHeader;
		
		erpPopupVault = $erp.getDhtmlXVault('vaultObj', vaultUrl, uploadFileLimitCount, params);
		
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
	
	function alertMessage(param){
		$erp.alertMessage(param);
	}
</script>
</head>
<body>

	<div id="vaultObj" style="width:499px;height: 459px;"></div>

</body>
</html>