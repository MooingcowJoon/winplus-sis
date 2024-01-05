<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>통합영업관리시스템</title>
<link rel="shortcut icon" href="/resources/common/img/default/winplus_favicon.ico" />
<link rel="stylesheet" href="/resources/common/css/login/default.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/common.css" />
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
	
	var loginFinalFlag = false;
	var session_check = '${param.message}';
	$(document).ready(function(){
		<%-- iframe 접근 방지 --%>
		if(parent.isIndex){
			parent.location.href=location.href;
		} else {
			document.getElementById("div_block").style.display="none";
		}
		getCookie();
		
		if(session_check == 'nosession'){
			$erp.alertMessage({
				"alertMessage" : "로그인 세션이 존재하지 않습니다."
				, "alertCode" : null
				, "alertType" : "error"
				, "isAjax" : false
			});
		}
	});
	
	function finalLoginTagReset(){
		loginFinalFlag = false;
		var inPhone = document.getElementById("inPhone");
		inPhone.value="";
		inPhone.style.display="none";
		document.getElementById("finalLogin").style.display="none";
	}
	
	function onLoginIdKeyDown(e){
		
		var keyCode = (window.event) ? e.which : e.keyCode;
	   	if (keyCode == 13) {
			document.getElementById("pwPASSWORD").focus();
			return false;
	   	}else{
	   		finalLoginTagReset();
	   	}
	   	return true;
	}
	
	function onPasswordKeyDown(e){

		var keyCode = (window.event) ? e.which : e.keyCode;
	   	if (keyCode == 13) {
			login(e.target);
			if(e.target && e.target.blur){
			 e.target.blur();
			}
			return false;
	   	}else{
	   		if(e.target.id != "inPhone"){
	   			finalLoginTagReset();
	   		}
	    }
	   	return true;
	}
	
	function onInPhoneKeyDown(e){
		onPasswordKeyDown(e);
	}
		
	function login(obj){		
		var txtLOGIN_ID = document.getElementById("txtLOGIN_ID");
		var pwPASSWORD = document.getElementById("pwPASSWORD");	
		
		
		var login_id = txtLOGIN_ID.value;
		var password = pwPASSWORD.value;
		
		var inPhone = document.getElementById("inPhone").value;
					
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
		
		if(loginFinalFlag == true){
			if(inPhone.length != 4){
				alertMessage = 'error.common.system.login.inPhoneLengthOver';
				alertCode = "-5";			
				alertCallbackFnParam[1] = inPhone;
			} else if(isNaN(inPhone)){
				alertMessage = 'error.common.system.login.inPhoneNaN';
				alertCode = "-6";			
				alertCallbackFnParam[1] = inPhone;
			}
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
		
		if(obj.id != 'inPhone' && obj.id != 'finalLogin'){
			loginFinalFlag = false;
		}
		
		<%-- 유효성 검사 종료 --%>
		$.ajax({
			url : "/login.do"
			,data : {
				'login_id' : login_id
				,'password' : password
				,'site_div_cd' : "SIS"
				,'loginFinalFlag' : loginFinalFlag
				,'inPhone' : inPhone
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				loginStatus.isTryLogin = false;
				if(data.isError){ //로그인 실패
					$erp.ajaxErrorMessage(data);
				} else { //로그인 성공
					
					var defaultPage = data.defaultPage;
					if(loginFinalFlag == true || (defaultPage != null && defaultPage.length > 0)){
						var isSaveId = document.getElementById("chk_saveId").checked;
						setCookie(isSaveId);
						
						if(defaultPage != null && defaultPage.length > 0){
							location.href = defaultPage;	
						}
					}else{
						var inphone = document.getElementById("inPhone");
						if(data.member_InPhone){
							inphone.value = data.member_InPhone;
						}
					
						inphone.style.display="inline-block";
						document.getElementById("finalLogin").style.display="block";

						loginFinalFlag = true;
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){ 
				loginStatus.isTryLogin = false;
				finalLoginTagReset();
				
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
	
	function PDA_apk_download(){
		$erp.alertMessage({
			"alertMessage" : "준비중 입니다"
			, "alertType" : "alert"
			, "isAjax" : false
		});
		
		//location.href = "/resources/common/apk/Chunho_CTI.apk";
	}
	//>
</script>
</head>
<body>
<div id="div_block" style="width:100%;height:100%;background-color: #fff;z-index:999;position: absolute;left: 0;top :0"></div>

<form>
	<div id="wrap">
            <div class="content">
                <h1><img src="/resources/common/img/login/logo_b.png" alt="" style="width: 300px"/></h1>
                <div class="login_box">
                    <h2>
                    	<img src="/resources/common/img/login/winplus_login_title.png" alt="login" style="width: 200px"/>
                    </h2>
                     <p>
                        <input type="text" id="txtLOGIN_ID" value="" maxlength="50" placeholder="아이디" onkeydown="onLoginIdKeyDown(event);"/>
                    </p>
                    <p>
            	        <input type="password" id="pwPASSWORD" maxlength="50" placeholder="비밀번호"  onkeydown="onPasswordKeyDown(event);"/>
                    </p>
                    <p class="btn" id="btnLogin" onclick="login(this)"><img src="/resources/common/img/login/btn_login.gif" alt="로그인" /></p>
                    
                    <div>
                        <p>
                            <input type="checkbox" name="chk_saveId" id="chk_saveId" value="true" onchange="setSaveId(this.checked);" /> <label for="checkbox">아이디저장<!-- 아이디저장 --></label>
                        </p>
                    </div>
                    

                   	<p>
           	        	<input type="text" id="inPhone" name="inPhone" maxlength="4" placeholder="내선번호" onkeydown="onInPhoneKeyDown(event);" style="display: none"/>
                  	</p> 
                    
                    <p class="btn2" id="finalLogin" onclick="login(this)" style="display: none"><img src="/resources/common/img/login/btn_login.gif" alt="최종 로그인" /></p>
                    <input type="button" class="input_common_button" onclick="PDA_apk_download();" value="PDA 앱다운">
                    
                    <p class="foot">Copyright(C) 2020 winplus COM.,Ltd. All Right Reserved.</p>
                </div>
            </div>
        </div>
</form>
</body>
</html>