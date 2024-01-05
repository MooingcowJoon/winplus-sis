<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="shortcut icon" href="/resources/common/img/default/winplus_favicon.ico" />
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp" />
<jsp:include page="/WEB-INF/jsp/common/include/default_index_script_header.jsp" />
<title>윈플러스 통합영업관리시스템</title>
<script type="text/javascript">

	$(document).ready(function(){		
	
		var message = "${empSessionDto.message}";
		
		if(message){
			$erp.alertMessage({
				"alertMessage" : message,
				"alertType" : "alert",
				"isAjax" : false
			});
		}
	});
	
	<%-- 새로고침 뒤로가기 방지 --%>
	$(document).keydown(function (e) {
	    if (e.keyCode === 8) {
	    	key_event_backspace();
	        //return false;
	    }
	    
	    if (e.keyCode === 116) {
	    	key_event_noRenew();
	        //return false;
	    }
	    
	});
	
	function key_event_backspace(){
	    $('body').pgpopup({
	        type:'slide', // 팝업형태 (toast, layer, slide)
	        msg:'뒤로가기를 하실 수 없습니다.',// 메시지
	    	padding:'10px',              // 여백
	        width:'50%',                // 토스트폭, %로 지정
	        color:'#ffffff',               // 내용 글자색
	        bgcolor:'#111111',        // 레이어 배경색, #111111 와 같이 헥사코드 이용
	        transparency:'0.8',         // 투명도, 0.8 과 같이 값을 입력, 최대 1
	        delay:'2000',                // 얼마의 시간이 지난뒤 사라지게 할것인지 , 1000 = 1초, toast와 slide에만 적용됨
	        time:'500',                 // 서서히 보여지는 시간, 1000 = 1초
	        direction:'up',               // slide 팝업의 경우 어느방향에서 나타나게 할지의 여부(up,down)
			font_size : '15'		//폰트사이즈
	    });
	}
	
	function clipboard_event(){
		$('body').pgpopup({
			type:'toast2', // 팝업형태 (toast, layer, slide)
	        msg: '클립보드에 복사되었습니다.',// 메시지
	    	padding:'10px',              // 여백
	        width:'50%',                // 토스트폭, %로 지정
	        color:'#ffffff',               // 내용 글자색
	        bgcolor:'#111111',        // 레이어 배경색, #111111 와 같이 헥사코드 이용
	        transparency:'0.8',         // 투명도, 0.8 과 같이 값을 입력, 최대 1
	        delay:'500',                // 얼마의 시간이 지난뒤 사라지게 할것인지 , 1000 = 1초, toast와 slide에만 적용됨
	        time:'100',                 // 서서히 보여지는 시간, 1000 = 1초
	        direction:'up',               // slide 팝업의 경우 어느방향에서 나타나게 할지의 여부(up,down)
			font_size : '12'		//폰트사이즈
				
	    });
	}
	
	function clipboard_event_paste(){
		$('body').pgpopup({
			type:'toast2', // 팝업형태 (toast, layer, slide)
	        msg: '붙여넣기가 완료되었습니다.',// 메시지
	    	padding:'10px',              // 여백
	        width:'50%',                // 토스트폭, %로 지정
	        color:'#ffffff',               // 내용 글자색
	        bgcolor:'#111111',        // 레이어 배경색, #111111 와 같이 헥사코드 이용
	        transparency:'0.8',         // 투명도, 0.8 과 같이 값을 입력, 최대 1
	        delay:'500',                // 얼마의 시간이 지난뒤 사라지게 할것인지 , 1000 = 1초, toast와 slide에만 적용됨
	        time:'100',                 // 서서히 보여지는 시간, 1000 = 1초
	        direction:'up',               // slide 팝업의 경우 어느방향에서 나타나게 할지의 여부(up,down)
			font_size : '12'		//폰트사이즈
				
	    });
	}
	
	function cti_event_error(){
	    $('body').pgpopup({
	        type:'layer', // 팝업형태 (toast, layer, slide)
	        msg:'통합영업관리 시스템 오류가 발생하였습니다.<br/>시스템 관리자에게 문의 바랍니다.',// 메시지
	    	padding:'10px',              // 여백
	        width:'50%',                // 토스트폭, %로 지정
	        color:'#ffffff',               // 내용 글자색
	        bgcolor:'#111111',        // 레이어 배경색, #111111 와 같이 헥사코드 이용
	        transparency:'0.8',         // 투명도, 0.8 과 같이 값을 입력, 최대 1
	        delay:'2000',                // 얼마의 시간이 지난뒤 사라지게 할것인지 , 1000 = 1초, toast와 slide에만 적용됨
	        time:'500',                 // 서서히 보여지는 시간, 1000 = 1초
	        direction:'up',               // slide 팝업의 경우 어느방향에서 나타나게 할지의 여부(up,down)
			font_size : '15'		//폰트사이즈
	    });
	}
	
	function key_event_noRenew(){
		$('body').pgpopup({
	        type:'toast', // 팝업형태 (toast, layer, slide)
	        msg:'새로고침을 하실 수 없습니다.',// 메시지
	    	padding:'10px',              // 여백
	        width:'50%',                // 토스트폭, %로 지정
	        color:'#ffffff',               // 내용 글자색
	        bgcolor:'#111111',        // 레이어 배경색, #111111 와 같이 헥사코드 이용
	        transparency:'0.8',         // 투명도, 0.8 과 같이 값을 입력, 최대 1
	        delay:'2000',                // 얼마의 시간이 지난뒤 사라지게 할것인지 , 1000 = 1초, toast와 slide에만 적용됨
	        time:'500',                 // 서서히 보여지는 시간, 1000 = 1초
	        direction:'up',               // slide 팝업의 경우 어느방향에서 나타나게 할지의 여부(up,down)
			font_size : '15'		//폰트사이즈
	
	    });
	}

</script>

</head>
<body class="body_erp_default"  oncontextmenu="return false" onbeforeunload="closeWindowEvent();">
	<div id="div_erp_top_wrapper" style="display: none;min-width: 0px;height:85px;">
		<div id="div_erp_sub_top">
			<div id="div_erp_sub_top_contents" style="width:270px;position:relative;padding-left:0px;border-bottom-left-radius: 0px;">
				<span id="span_sub_top_title"><img style=" width: 200px; margin-left: 10px; margin-top: 15px;" src="/resources/common/img/default/winplus_login_title.png" id="img_index_logo"></span> 
			</div>
		</div>

	</div>
	<div id="div_sub_top_button" style="width:270px;position:relative;padding-left:0px;border-bottom-left-radius: 0px;">
		<table id="tb_sub_top_button">
			<c:if test="${empSessionDto.site_div_cd == 'SIS'}">
				<tr>
					<td colspan = "2">
						${empSessionDto.emp_nm_oriz} 님
						<c:if test="${empSessionDto.emp_no != empSessionDto.emp_no_oriz }">
						 ( ${empSessionDto.emp_no} )
						</c:if>
					</td>
					<td>
						<c:choose>
							<c:when test="${empSessionDto.orgn_delegate_nm != empSessionDto.orgn_nm}">
								${empSessionDto.orgn_delegate_nm} (${empSessionDto.orgn_nm})
							</c:when>
							<c:otherwise>
								${empSessionDto.orgn_nm}
							</c:otherwise>
						</c:choose>
						
					</td>
				</tr>
				<tr>
					<!-- <td><span onclick="$erp.openIndividualSettingPopup();" class="span_sub_top_button">개인설정</span></td> -->
					<td <c:if test="${empSessionDto.emp_no == empSessionDto.emp_no_oriz }">colspan = "2"</c:if>>
						<span onclick="openSearchEmpLoginAddListPopup();" class="span_sub_top_button">세션변경</span></td>
					
					<c:if test="${empSessionDto.emp_no != empSessionDto.emp_no_oriz }">
					<td><span onclick="sessionOut();" class="span_sub_top_button">세션아웃</span></td>
					</c:if>
					
	
					<td><span onclick="logout();" class="span_sub_top_button">로그아웃</span></td>
				</tr>
			</c:if>
			
			<c:if test="${empSessionDto.site_div_cd == 'CS' || empSessionDto.site_div_cd == 'PS'}">
				<tr>
					<td colspan = "3">
						${empSessionDto.custmr_nm} 님
					</td>
				</tr>
				<tr>
					<td colspan = "3"><span onclick="logout();" class="span_sub_top_button">로그아웃</span></td>
				</tr>
			</c:if>
			
			<tr>
				<td colspan = "3">${svrStr}</td>
			</tr>
		</table>
		<!-- <img id="img_erp_logout_button" src="/resources/common/img/default/erp_logout.png"	onclick="logout();"> -->
	</div>

	<div id="div_erp_left_wrapper" class="div_sub_layout" style="display: none"></div>
	<div id="div_erp_contents_tabbar_wrapper" style="display: none"></div>	
	<div id="div_erp_toolbar_wrapper" class="div_toolbar_full_size" style="display:none"></div>
	<div id="div_erp_tree_wrapper" class="div_tree_full_size" style="display:none"></div>
	
	<!-- CTI 새창 관련 시작 -->
	<form id="ctiWinForm" method="post" action="" target="">
		<input type="hidden" id="ctiWin_currentMenu_cd" name="currentMenu_cd" value="">
		<input type="hidden" id="ctiWin_MAIN_YN" name="MAIN_YN" value="">
	</form>
	<!-- CTI 새창 관련 끝 -->
</body>
</html>