<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<script type="text/javascript">
	$(document).ready(function(){
		$erp.alertMessage({
			"alertMessage" : "error.common.system.authority.noSession"
			, "alertCode" : "noSession"
			, "alertType" : "error"
			, "alertCallbackFn" : function(){
				if(parent.isIndex){
					//parent.location.href="/";
					location.href="/";
				} else {
					location.href="/";
				}
			}
		});
	});
	location.href="/";
</script>