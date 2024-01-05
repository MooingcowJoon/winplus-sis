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
		■ erpPopupGridOnRowDblClicked : Object (Function) / erpPopupGrid 더블 클릭시 실행될 Function
	--%>
	var erpPopupWindowsCell = parent.erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
	
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;	
	//var stplat_cd = '${STPLAT_CD}';
	//var stplat_nm = '${STPLAT_NM}';
	
	
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
		//initErpPopupLayout();
		//initErpPopupRibbon();
		
		//initVault();
	});
	
	<%-- Page Loaded Event Function --%>	
	function onLoad(){
		initVault();		
	}

	<%-- ■ erpPopupLayout 관련 Function 시작 --%>	
	<%-- erpPopupLayout 초기화 Function --%>	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "${screenDto.scrin_nm}", header:true, fix_size : [false, true]}
				, {id: "b", text: "", header:false, fix_size : [false, true]}
			]		
		});
		
		erpPopupLayout.conf.ofs = {b : 4, l : 4, r : 4, t : 4};		
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT+30);
		erpPopupLayout.cells("b").attachObject("div_erp_event");
		
		erpPopupLayout.setSeparatorSize(1, 0);
		erpPopupLayout.setSizes();
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupGrid.setSizes();
		});
	}
	<%-- ■ erpPopupLayout 관련 Function 끝 --%>	
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>	
	<%-- erpPopupLayout 초기화 Function --%>	
	function initErpPopupRibbon(){
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						{id : "search_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}									
				]}							
			]
		});
		
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpPopupGrid"){
		    	saveErpPopupGrid();
		    }
		});
	}

	function initVault(){
		//var params = $erp.serializeDhtmlXGridHeader(dhtmlXGridColumnsMapArray);
		var params = '';
		var vaultUrl = "/common/system/file/uploadTool.do";
		/* if(erpPopupVaultUploadUrl){
			vaultUrl = erpPopupVaultUploadUrl;
		} */


		erpPopupVault=$erp.getDhtmlXVault('erpPopupVault', vaultUrl, null, params,'');
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
	<%-- ■ erpPopupGrid 관련 Function 끝 --%>		
</script>
</head>
<body>
<div id="erpPopupVault" style="width:499px;height: 459px;" class='vault_essential'></div>


<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>

</body>
</html>