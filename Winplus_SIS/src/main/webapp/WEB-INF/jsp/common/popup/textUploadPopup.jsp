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
		■ erpPopupRibbon : Object / 리본형 버튼 목록 DhtmlxRibbon
		■ erpPopupGrid : Object / 표준분류코드 조회 DhtmlxGrid
		■ erpPopupGridColumns : Array / 표준분류코드 DhtmlxGrid Header		
	--%>
	var erpPopupWindowsCell = parent.erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
	
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;	
	
	
	var erpPopupVault;
	var erpPopupVaultFnOnUploadFile;
	var erpPopupVaultFnOnUploadComplete;
	var erpPopupVaultFnOnFileAdd;
	var erpPopupVaultFnOnBeforeClear;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("${screenDto.scrin_nm}");	
		}
		initBindParameter();
		//initErpPopupLayout(); 
		initVault();
	});
	
	<%-- Prameter 바인딩 Function --%>	
	function initBindParameter(){
		//document.getElementById("txtGOODS_NO_NM").value = paramEmp_nm;
	}
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>	
	<%-- erpPopupLayout 초기화 Function --%>	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "${screenDto.scrin_nm}", header:true, height:80	, fix_size : [true, true]}
				, {id: "b", text: "", header:false, fix_size : [true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		
		erpPopupLayout.conf.ofs = {b : 4, l : 4, r : 4, t : 4};		
		
		erpPopupLayout.cells("a").attachObject("div_erp_contents_search");
		erpPopupLayout.cells("a").hideArrow();
		erpPopupLayout.cells("b").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_popup_grid");
		
		erpPopupLayout.setSeparatorSize(1, 0);
		erpPopupLayout.setSizes();
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupGrid.setSizes();
		});
	}
	<%-- ■ erpPopupLayout 관련 Function 끝 --%>	
	
	function initVault(){
		erpPopupVault=$erp.getDhtmlXVault('vaultObj','/receive/CMS11TelegramParsing.erp',1);
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
<!-- <div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
	<table class="table_search">
		<colgroup>
			<col width="120px">
			<col width="*">
		</colgroup>
		<tr>
			<th>상품코드/상품명</th>
			<td><input type="text" id="txtGOODS_NM" name="GOODS_NM" class="input_common" maxlength="20"></td>
		</tr>
	</table>
</div> -->
<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
<div id="div_erp_popup_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>