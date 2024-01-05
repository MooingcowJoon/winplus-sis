<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>수불/원가 관리시스템</title>
<link rel="shortcut icon" href="/resources/common/img/default/winplus_favicon.ico" />
<link rel="stylesheet" href="/resources/common/css/login/default.css" />
<%-- DhtmlxMessage StyleSheet --%>
<link rel="stylesheet" href="/resources/framework/theme/original/dhtmlxmessage_dhx_skyblue.css" />
<script type="text/javascript" src="/resources/common/js/jquery/jquery-3.1.1.min.js"></script>
<%-- DhtmlxMessage --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxMessage/codebase/dhtmlxmessage.js"></script>
<script type="text/javascript" src="/resources/common/js/erp_common.js"></script>
<script type="text/javascript">
<!--
	var loginStatus = function(){}; 
	loginStatus.isTryLogin = false;
	
	$(document).ready(function(){
		<%-- iframe 접근 방지 --%>
		if(parent.isIndex){
			parent.location.href=location.href;
		} else {
			document.getElementById("div_block").style.display="none";
		}
		getCookie();
	});
	
	function onLoginIdKeyDown(e){
		var keyCode = (window.event) ? e.which : e.keyCode;
	   	if (keyCode == 13) {
	      document.getElementById("pwPASSWORD").focus();
	      return false;
	   	}
	   	return true;
	}
	
	function onPasswordKeyDown(e){
		var keyCode = (window.event) ? e.which : e.keyCode;
	   	if (keyCode == 13) {
	      login();
	      if(e.target && e.target.blur){
	    	  e.target.blur();
	      }
	      return false;
	   	}
	   	return true;
	}
	
	function fnBsoh(s){
		var sid = "";
		var spw = "";
		
		if(s=='fac1'){
			sid = "fac1@test.com";
			spw = "fac1@test.com";
			
		} else if(s=='fac2'){
			sid = "fac2@test.com";
			spw = "fac2@test.com";
			
		} else if(s=='sup1'){
			sid = "dlv1@test.com";
			spw = "dlv1@test.com";
			
		} else if(s=='sup2'){
			sid = "dlv2@test.com";
			spw = "dlv2@test.com";
			
		} else if(s=='sup3'){
			sid = "dlv3@test.com";
			spw = "dlv3@test.com";
			//
		}else if(s=='sup4'){
			sid = "dlv4@test.com";
			spw = "dlv4@test.com";
		} else {
			sid = "syds";
			spw = "syds";
		}
		
		$("#txtLOGIN_ID").val(sid);
		$("#pwPASSWORD").val(spw);
		
		login();
		
	}
		
	function login(){		
		var txtLOGIN_ID = document.getElementById("txtLOGIN_ID");
		var pwPASSWORD = document.getElementById("pwPASSWORD");	
		
		
		
		var login_id = txtLOGIN_ID.value;
		var password = pwPASSWORD.value;
					
		if(loginStatus.isTryLogin){			
			$erp.alertMessage({
				"alertMessage" : "error.common.system.login.waitLogin"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}		
		loginStatus.isTryLogin = true;
		<%-- 유효성 검사 시작 --%>
		var alertMessage = '';
		var alertCode = null;	
		var alertType = "error";
		var alertCallbackFnParam = new Array();
		alertCallbackFnParam[0] = loginStatus;
		var alertCallbackFn = function(param){
			param[0].isTryLogin = false;
			param[1].focus();
		}
		if(login_id == null || login_id.length == 0){
			alertMessage = 'error.common.system.login.idNotEnough';
			alertCode = "-1";
			alertCallbackFnParam[1] = txtLOGIN_ID;
		} else if(login_id.length > 20){
			alertMessage = 'error.common.system.login.idLengthOver';
			alertCode = "-2";			
			alertCallbackFnParam[1] = txtLOGIN_ID;
		} else if(password == null || password.length == 0){
			alertMessage = 'error.common.system.login.pwNotEnough';
			alertCode = "-3";	
			alertCallbackFnParam[1] = pwPASSWORD;
		} else if(password.length > 30){
			alertMessage = 'error.common.system.login.pwLengthOver';
			alertCode = "-4";			
			alertCallbackFnParam[1] = pwPASSWORD;
		}
		if(alertCode != null){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
				, "alertCallbackFn" : alertCallbackFn
				, "alertCallbackFnParam" : alertCallbackFnParam
			});
			return;
		}
		
		
		<%-- 유효성 검사 종료 --%>
		$.ajax({
			url : "/login.do"
			,data : {
				'login_id' : login_id
				,'password' : password
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				loginStatus.isTryLogin = false;
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					var isSaveId = document.getElementById("chk_saveId").checked;
					setCookie(isSaveId);
					var defaultPage = data.defaultPage;					
					if(defaultPage != null && defaultPage.length > 0){
						location.href = defaultPage;	
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				loginStatus.isTryLogin = false;
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function setSaveId(isSave){
		if(isSave == undefined){
			isSave = !document.getElementById("chk_saveId").checked;
		}		
		document.getElementById("chk_saveId").checked = false;
		if(isSave){
			$erp.confirmMessage({
				"alertMessage" : '<spring:message code="alert.common.system.login.saveId" />'
				, "alertCode" : null
				, "alertType" : "alert"
				, "alertCallbackFn" : function(){
					document.getElementById("chk_saveId").checked = true;
				}
			});
		}
	}
	
	function setCookie(isSave){
		var key = "txtLOGIN_ID";
		var value = document.getElementById(key).value;
		var date = new Date();
		if(isSave){
			<%-- 저장 --%>
			date.setDate(date.getDate()+1000);	
		} else {
			<%-- 삭제 --%>
			date.setDate(date.getDate()-1);			
		}
		document.cookie = key + '=' + escape(value) + ';expires=' + date.toGMTString();
	}
	
	function getCookie(){
		var allCookies = document.cookie;
		allCookies = allCookies.split("; ");
		var key = "txtLOGIN_ID";
		if(allCookies){
			for(var i in allCookies){
				var cookie = allCookies[i].split("=");
				var tmpKey = cookie[0];
				if(tmpKey == key){
					var value = unescape(cookie[1]);
					document.getElementById(key).value = value;
					document.getElementById("chk_saveId").checked = true;
					break;
				}
			}
		}
	}
	//>
</script>
</head>
<body>
<div id="div_block" style="width:100%;height:100%;background-color: #fff;z-index:999;position: absolute;left: 0;top :0"></div>
<form>
	<div id="wrap">
            <div class="content">
                <h1><img src="/resources/common/img/login/logo_b.png" alt=""/></h1>
                <div class="login_box">
                    <h2>
                    	<img src="/resources/common/img/login/winplus_login_title.png" alt="login"/>
                    </h2>
                     <p>
                        <input type="text" id="txtLOGIN_ID" value="" maxlength="50" placeholder="아이디" onkeydown="onLoginIdKeyDown(event);"/>
                    </p>
                    <p>
            	        <input type="password" id="pwPASSWORD" maxlength="50" placeholder="비밀번호"  onkeydown="onPasswordKeyDown(event);"/>
                    </p>
                    <p class="btn" id="btnLogin" onclick="login()"><img src="/resources/common/img/login/btn_login.gif" alt="로그인" /></p>
                    <div>
                        <p>
                            <input type="checkbox" name="chk_saveId" id="chk_saveId" value="true" onchange="setSaveId(this.checked);" /> <label for="checkbox">아이디저장<!-- 아이디저장 --></label>
                        </p>
                    </div>
                    <div>
                    	<input type="button" value="1공장" onclick="fnBsoh('fac1')"></input>
                    	<input type="button" value="2공장" onclick="fnBsoh('fac2')"></input><br/><br/>
                    	
                    	<input type="button" value="아워홈" onclick="fnBsoh('sup1')"></input>
                    	<input type="button" value="삼성웰" onclick="fnBsoh('sup2')"></input>
                    	<input type="button" value="경인상회" onclick="fnBsoh('sup3')"></input><input type="button" value="하나로축산" onclick="fnBsoh('sup4')"></input><br/><br/>
                    	
                    	
                    	<input type="button" value="syds" onclick="fnBsoh('')"></input>
                    	
                    </div>
                    <p class="foot">Copyright(C) 2017 chunho COM.,Ltd. All Right Reserved.</p>
                </div>
            </div>
        </div>
</form>
</body>
</html>