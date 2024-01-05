<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpPopupWindowsCell : Object / 시스템 팝업 윈도우 Cell DhtmlxWindowsCell; 
		■ erpPopupOnComplete : Object (Function) / 주소 선택 시 실행될 Function
	--%>
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("ERP_POST_WIN_ID");
	var erpPopupOnComplete;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("주소찾기");	
		}
		initDaumPostAddressForm();
	});
	
	function initDaumPostAddressForm() {
		daumPostAddrForm = document.getElementById("div_daum_post_addr_form");
		
        // 현재 scroll 위치를 저장해놓는다.
        var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
        new daum.Postcode({
            oncomplete: function(data){
            	if(erpPopupOnComplete != undefined && erpPopupOnComplete != null && typeof erpPopupOnComplete === 'function'){
            		erpPopupOnComplete(data);
            	}
            },
            // 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
            onresize : function(size) {
                daumPostAddrForm.style.height = size.height+'px';
            },
            width : '100%',
            height : '100%'
        }).embed(daumPostAddrForm);

        // iframe을 넣은 element를 보이게 한다.
        daumPostAddrForm.style.display = 'block';
    }
</script>
</head>
<body>
<div id="div_daum_post_addr_form" class="div_daum_post_addr_form" style="display:none"></div>
</body>
</html>