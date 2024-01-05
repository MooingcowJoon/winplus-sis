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
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openPosVersionFileUploadPopup");
	
	var erpPopupLayout;
	
	var VerFile;
	var VerFileName;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("버전 관리 파일 업로드");
		}
		initErpPopupLayout();
		initErpPopupRibbon();
	});
	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "리본영역", header: false, fix_size : [true, true]}
				,{id: "b", text: "업로드영역", header: false, fix_size : [true, true]}
			 ]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_poup_ribbon");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_upload");
	}
	
	function initErpPopupRibbon() {
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_poup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "save_erpPopupGrid", type : "button", text:'업로드', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false}
				]}							
			]
		});
		
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "save_erpPopupGrid") {
				uploadVerFile();
			}
		});
	}
	
	function FileCheck(obj){
		console.log("FileCheck 들어왔습니다.");
		VerFile = event.target.files[0];
		var url = $("#ver_file").val();
		console.log("url >> " + url);
		var SplitUrl = url.split("\\");
		VerFileName = SplitUrl[SplitUrl.length-1];
		console.log("VerFileName >> " + VerFileName);
		
		var file_kind = obj.value.lastIndexOf('.');
		var file_name = obj.value.substring(file_kind+1,obj.length);
		var file_type = file_name.toLowerCase();
		
		console.log("file_kind >> " + file_kind);
		console.log("file_name >> " + file_name);
		
		if(file_type != "zip"){
			$erp.alertMessage({
				"alertMessage" : "zip파일만 업로드가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"alertCallbackFn" : function clearFileName(){
					$("#ver_file").val("");
				} ,
				"isAjax" : false
			});
		}
		
	}
	
	function uploadVerFile() {
		console.log("ver_file_name >>> " + document.getElementById("ver_file").value);
		
		if($("#ver_file").val() == ""){
			$erp.alertMessage({
				"alertMessage" : "업로드할 파일을 먼저 선택해 주세요.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		} else {
		
			var formData = new FormData();
			formData.append("VerFile", VerFile);
			
			$.ajax({
				url: "/common/pos/PosVersionManagement/uploadPosVersionFile.do"
				, data : formData
				, method : "POST"
				, dataType : "JSON"
				, processData: false
			    , contentType: false
				, success : function(data){
					erpPopupLayout.progressOn();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						var upload_result = data.result;
						
						if(upload_result == "upload Success") {
							$erp.alertMessage({
								"alertMessage" : "성공적으로 파일이 업로드되었습니다.",
								"alertCode" : null,
								"alertType" : "alert",
								"alertCallbackFn" : function closeUploadPopup(){
									UploadPopupClose();
								},
								"isAjax" : false
							});
						} else if(upload_result == "upload Fail") {
							$erp.alertMessage({
								"alertMessage" : "파일업로드 실패.<br> 다시 시도해주세요.",
								"alertCode" : null,
								"alertType" : "alert",
								"isAjax" : false
							});
						}
					}
					erpPopupLayout.progressOff();
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
</script>
</head>
<body>
	<div id="div_erp_poup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_popup_upload" class="samyang_div" style="diplay:none;">
		<table id="table_upload_search" class="table">
				<colgroup>
					<col width="100px">
					<col width="*">
				</colgroup>
				<tr>
					<th>파일명</th>
					<td>
						<input type="file" accept=".zip" id="ver_file" name="ver_file" onchange="FileCheck(this)">
					</td>
				</tr>
			</table>
	</div>
</body>
</html>