<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>

<script type="text/javascript">
	<%@ include file="/WEB-INF/jsp/common/include/default_common_header.jsp" %>
	<%-- 레이아웃 생성 %-->
	<%-- DOM Ready 완료 시 호출 Function --%>
	<%-- erp_header.js도 같이 참조 --%>
	$(document).ready(function(){
		var topDomObjId="div_erp_top_wrapper"; <%-- Layout Top Object ID --%>
		var leftDomObjId="div_erp_left_wrapper";	 <%-- Layout Left Object ID --%>
		var leftTop1DomObjId = "div_erp_top_wrapper";
		var leftTop2DomObjId = "div_sub_top_button";
		var leftToolbarDomObjId="div_erp_toolbar_wrapper";	<%-- Layout Left Menu Toolbar Object ID --%>
		var leftTreeDomObjId="div_erp_tree_wrapper";			<%-- Layout Left Menu Tree Object ID --%>
		var contentsDomObjId="div_erp_contents_tabbar_wrapper";	<%-- Layout Contents(Right) Object ID --%>
		
		<%-- 화면 Layout을 위한 DhtmlxLayout 초기화, Parameter Left 부분 Header 이름 --%>
		initErpLayout(
					'<spring:message code="word.common.menuList" />'
					, topDomObjId
					, leftDomObjId	
					, contentsDomObjId
				);

		<%-- Left Menu에서 Toolbar 사용을 위하여 SubLayout 생성 --%>
		initErpSubLayout(
					leftDomObjId
					, leftTop1DomObjId
					, leftTop2DomObjId
					, leftToolbarDomObjId
					, leftTreeDomObjId
		);
		<%-- Menu DhtmlxTree 초기화, 기존 HRIS 폼 메뉴 사용 시 주석 필요 --%>
		initErpMenuTree(leftTreeDomObjId);
		<%-- Menu DhtmlxToolbar 초기화, 기존 HRIS 폼 메뉴 사용 시 주석 필요 --%>
		initErpMenuToolbar(leftToolbarDomObjId
				, "<spring:message code='word.common.expands' />"	<%-- 펼침 Text --%>
				, "<spring:message code='word.common.collapse' />"	<%-- 접기 Text --%>
				, "<spring:message code='word.common.closeAllTabs' />" <%-- 모든 탭 닫기 Text --%>
				);
		<%-- Contents DhtmlxTabBar 초기화 --%>
		initErpContentsTabBar(contentsDomObjId);
		<%-- DhtmlxWindows 초기화 --%>
		initErpPopupWindows();
		
		attachOnConsultTabClose();
	});
</script>