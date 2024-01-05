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
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openSearchOrgnTreePopup");
	
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpTree;
	var currentErpTreeId;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("조직조회 트리팝업");	
		}

		initErpPopupLayout();
		initErpRibbon();
		initErpTree();
		searchErpTree();
	});
	
	
	
	<%-- ■ erpTree 관련 Function 시작 --%>
	<%-- erpTree 초기화 Function --%>
	function initErpTree(){
		erpTree = new dhtmlXTreeObject({
			parent : "div_erp_tree"
			, skin : ERP_TREE_CURRENT_SKINS			
			, image_path : ERP_TREE_CURRENT_IMAGE_PATH
		});
		erpTree.attachEvent("onClick", function(id, nm){
			if(!$erp.isEmpty(id)){
				<%-- 최상위 일 경우 완전 초기화 --%>
				if(id == "#root"){
					currentErpTreeId = null;
					$erp.clearInputInElement("tb_erp_data");
				} else {
					crud = null;
					currentErpTreeId = id;
					erpPopupOnConfirm(id, erpTree.getItemText(id));
					erpPopupOnComplete();
				}
			}
		});
	}
	
	<%-- erpTree 조회 Function --%>
	function searchErpTree(){
	
		erpPopupLayout.progressOn();

		$.ajax({
			url : "/common/organ/getOrgnList.do"
			,data : {}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					var menuTreeMap = data.menuTreeMap;
					var menuTreeDataList = menuTreeMap.item;
					if($erp.isEmpty(menuTreeDataList)){
						$erp.alertMessage({
							"alertMessage" : "grid.noSearchData"
							, "alertCode" : null
							, "alertType" : "info"
						});
					} else {
						erpTree.deleteChildItems(0);
						erpTree.parse(menuTreeMap, 'json');
						currentErpTreeId = null;
						$erp.clearInputInElement("tb_erp_data");
						erpTree.openAllItems("0");
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>	
	<%-- erpPopupLayout 초기화 Function --%>	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false}
				, {id: "b", text: "", header:false, fix_size : [true, true]}
				, {id: "c", text: "${screenDto.scrin_nm}", header:false}
			]		
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_contents_search");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_tree");
		erpPopupLayout.setSizes();
		
		<%-- erpPopupLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			//erpPopupGrid.setSizes();			
		});
	}
	
	function initErpRibbon(){
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
				]}							
			]
		});
		
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpPopupTree();
		    }
		});
	}
	
	function searchErpPopupTree() {
		erpTree.findItem(document.getElementById('txt_POPUP_ORGN_NM').value,0,1);
	}
		
		

</script>
</head>
<body>
<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
	<table class="table_search">
		<colgroup>
			<col width="120px">
			<col width="*">
		</colgroup>
		<tr>
			<th>조직코드/조직명</th>
			<td><input type="text" id="txt_POPUP_ORGN_NM" name="ORGN_NM" class="input_common" maxlength="20" value="${ORGN_NM}" onkeydown="$erp.onEnterKeyDown(event, searchErpPopupTree);"></td>

		</tr>
	</table>
</div>
<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>

<div id="div_erp_tree" class="div_tree_full_size"></div>	
</body>
</html>