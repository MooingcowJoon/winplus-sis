<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp" />
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp" />
<script type="text/javascript">
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpPopupWindowsCell : Object / 시스템 팝업 윈도우 Cell DhtmlxWindowsCell; 
		■ erpPopupLayout : Object / 페이지 Layout DhtmlxLayout
		■ erpPopupRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpPopupTree : Object / 상품분류 목록 DhtmlXTree
		■ erpPopupTreeOnClick : Object (Function) / 상품분류 선택 시 실행될 Function
	--%>
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openGoodsCategoryTreePopup");
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupTree;
	
	var erpPopupTreeOnClick;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("상품분류");
		}
		
		initErpPopupLayout();
		initErpPopupRibbon();
		initErpPopupTree();
	});
	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "검색어영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "트리영역", header:false, fix_size : [true, true]}
			]		
		});
		erpPopupLayout.cells("a").attachObject("div_erp_popup_keyword_contents");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_popup_tree");
	}
	
	<%--
	**********************************************************************
	* ※ Master 영역
	**********************************************************************
	--%>	
	
	<%-- ■ erpPopupRibbon 관련 Function 시작 --%>
	<%-- erpPopupRibbon 초기화 Function --%>
	function initErpPopupRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					 {id : "search_erpTree", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					//  {id : "add_erpTree", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					//, {id : "delete_erpTree", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					//, {id : "save_erpTree", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					//, {id : "excel_erpTree", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					//, {id : "print_erpTree", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}	
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpTree"){
				searchErpPopupTree();
			} else if (itemId == "add_erpTree"){
			} else if (itemId == "delete_erpTree"){
		    } else if (itemId == "save_erpTree"){
		    } else if (itemId == "excel_erpTree"){
		    } else if (itemId == "print_erpTree"){
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpPopupTree 관련 Function 시작 --%>
	<%-- erpPopupTree 초기화 Function --%>
	function initErpPopupTree(){
		erpPopupTree = new dhtmlXTreeObject({
			parent : "div_erp_popup_tree"
			, skin : ERP_TREE_CURRENT_SKINS			
			, image_path : ERP_TREE_CURRENT_IMAGE_PATH
		});
		
		searchErpPopupTree();
	}
	
	<%-- erpPopupTree 조회 Function --%>
	function searchErpPopupTree(){
		erpPopupLayout.progressOn();
		
		$.ajax({
			url : "/common/popup/getGoodsCategoryTreeList.do"
			,data : {
				"KEY_WORD" : $("#txtKEY_WORD").val()
				,"GRUP_STATE" : "Y"
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					var categoryTreeMap = data.categoryTreeMap;
					var categoryTreeDataList = categoryTreeMap.item;
					if($erp.isEmpty(categoryTreeDataList)){
						$erp.alertMessage({
							"alertMessage" : "grid.noSearchData"
							, "alertCode" : null
							, "alertType" : "info"
						});
					} else {
						erpPopupTree.deleteChildItems(0);
						erpPopupTree.parse(categoryTreeMap, 'json');
						erpPopupTree.openAllItems("0");
						
						<%-- erpPopupTree Row 클릭 시 사용될 Function 상위 Window or Frame 에서 만들어 전달해줌 erp_popup.js도 참조--%>
						if(!$erp.isEmpty(erpPopupTreeOnClick) && typeof erpPopupTreeOnClick === 'function'){
							erpPopupTree.attachEvent("onClick", erpPopupTreeOnClick);
						}
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpPopupTree 관련 Function 끝 --%>

</script>
</head>
<body style="background-color: #dfe8f6">
	<div id="div_erp_popup_keyword_contents" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="150px">
				<col width="*">
			</colgroup>
			<tr>
				<th>검색어</th>
				<td>
					<input type="text" id="txtKEY_WORD" name="KEY_WORD" class="input_common" maxlength="10" onkeydown="$erp.onEnterKeyDown(event, searchErpPopupTree);">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_popup_tree" class="div_tree_full_size"></div>
</body>
</html>