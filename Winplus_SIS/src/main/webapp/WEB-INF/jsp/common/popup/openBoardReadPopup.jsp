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
	var erpPopupGrid;
	var erpPopupVault;
	var erpPopupVaultUploadUrl;
	var erpPopupVaultFnOnUploadFile;
	var erpPopupVaultFnOnUploadComplete;
	var erpPopupVaultFnOnFileAdd;
	var erpPopupVaultFnOnBeforeClear;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("상세내용");
		}
		
		initErpPopupLayout();
		if(true){
			$erp.setReadOnlyDom("txtSJ", true);
			$erp.setReadOnlyDom("txtCN", true);
		}
	});
	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "", header:false, fix_size : [false, false]}
			]		
		});
		erpPopupLayout.cells("a").attachObject("div_erp_event");
		erpPopupLayout.setSeparatorSize(1, 0);
	}	

</script>
</head>
<body style="background-color: #dfe8f6">
	<div id="div_erp_event" class="div_common_contents_full_size">
	<input type="hidden" id="txtCRUD"  name="CRUD" value="${bbsContent.CRUD}">
		<table id="tb_erp_data" class="tb_erp_common" style="margin-top: 0px;">
			<colgroup>
				<col width="80px">
				<col width="100px">
				<col width="80px">
				<col width="120px">
				<col width="80px">
				<col width="*">
			</colgroup>
				<tr>
					<th>등록자<input type="hidden" id="txtCRUD"  name="CRUD" value="${bbsContent.CRUD}"></th>
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
					<td>${bbsContent.BBS_DIV_NM}</td>
				</tr>
				<tr>
					<th><span class='span_essential'>*</span>상세내용</th>
					<td colspan="5"><textarea rows="22" id="txtCN" name="CN" class="input_common" readonly="readonly">${bbsContent.CN}</textarea></td>
				</tr>
				<tr>
					<th>수정자</th>
					<td><input type="hidden" id="txtMOD_ID" name="MOD_ID" class="input_common"  value="${empSessionDto.emp_no}">${bbsContent.MOD_NM}</td>
					<th>수정일</th>
					<td>${bbsContent.MOD_DT}</td>
					<th>글번호</th>
					<td>
					<input type="hidden" id="txtBBS_NO"  name="BBS_NO" value="${bbsContent.BBS_NO}">${bbsContent.BBS_NO}</td>
				</tr>
		</table>
	</div>
</body>
</html>