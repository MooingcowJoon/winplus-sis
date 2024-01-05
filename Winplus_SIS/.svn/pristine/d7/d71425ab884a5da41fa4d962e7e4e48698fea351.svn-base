<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf"%>
<!DOCTYPE html>
<html>
<head>
<title>윈플러스 모바일 전화걸기 예제</title>
<meta name="Generator" content="alvatros">
<meta name="Author" content="">
<meta charset="utf-8">
<meta name="Keywords" content="">
<meta name="Description" content="">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="/resources/common/js/stomp.js"></script>

</head>

<body>


	직원코드&nbsp;&nbsp;
	<input type="text" id="Com_AId" value="0000002219">
	<br> 모바일 콜용 핸드폰번호&nbsp;&nbsp;
	<input type="text" id="pnumber" value="01034078506">
	<br> 발신번호&nbsp;&nbsp;
	<input type="text" id="cid" value="01026197549">
	<br> 고객코드 &nbsp;&nbsp;
	<input type="text" id="mid" value="45435088">
	<br> 고객명&nbsp;&nbsp;
	<input type="text" id="mname" value="박준호">
	<br>
	큐 메세지 &nbsp;&nbsp; <input type="text" id="queuemessage" value="메시지">
	
	<button id="queuesendPost">POST 방식 메시지 전송</button>
	<button id="receiveAlarm">알람받기</button>
	<br>
	<button id="callphone">전화 걸기</button>
	<button id="endphone">전화 끊기</button>
	<button id="sendsmsdisplay" onclick='$("#alvatros").toggle();'>문자보내기</button>
	<div id="alvatros" style="display: none">
		핸드폰번호&nbsp;&nbsp; <input type="text" id="spnumber" value="01026197549"><br>
		보낼 문자&nbsp;&nbsp;
		<textarea id="snd_text" cols="50" rows="10" >테스트입니다.</textarea>
		<button id="sendsms">전송</button>

	</div>
	<script type="text/javascript">

	
		var queue_conncected = false;
		rabbitmq_alarm = function(){	
			var senddata = {
					messageType : "state",
					emp_id : "chunho",
					emp_ph_num : "01032968506",
					cus_ph_num : "01044444444",
					cus_id : "hong",
					cus_name : "홍길동",
					client_seq : "1",
					call_state : "3"
				};
			$.ajax({
				url : 'https://tbs.chunhoncare.com/common/sendMessage.erp',
				contentType : "application/json; charset=utf-8",
				type : "POST",
				dataType : "html",
				traditional: true,
				mode : 'no-cors',
				cache:false,

				error : function(xhr,textStatus,errorThrown) {
					console.log("큐생성 실패 : 알람 받기 실패");
				},

				success : function(data) {
					console.log("큐 확인 성공");
					
					if(queue_conncected == false){
						var ws = new WebSocket("wss://MQ.CHUNHONCARE.COM:15671/ws");
						var client = Stomp.over(ws);
		
						var on_connect = function() {
							console.log("큐 연결됨");
							id = client.subscribe("/amq/queue/" + senddata.emp_ph_num , function(message) {
								if (message.body == "connected") {
									alert("고객과 통화 시작");
								} else if (message.body == "disconnected") {
									alert("고객과 통화 종료");
								} else {
									alert(message.body);
								}
							});
							
							queue_conncected = true;
						};
		
						var on_error = function() {
							console.log('큐 연결끊김');
							
							queue_conncected = false;
						};
						client.connect('chunhoMQ', 'qwer1234!@#$', on_connect, on_error, '/');
					}else{
						console.log("기존 커넥션 사용");
					}
				},
				data : JSON.stringify(senddata)
			});
		}


		function shuffleRandom(n) {
			var ar = new Array();
			var temp;
			var rnum;

			for (var i = 1; i <= n; i++) {
				ar.push(i);
			}

			for (var i = 0; i < ar.length; i++) {
				rnum = Math.floor(Math.random() * n);
				temp = ar[i];
				ar[i] = ar[rnum];
				ar[rnum] = temp;
			}

			return ar;
		}

		$("#sendsms").click(function() {
			//var seq_num = Math.floor(Math.random() * 10) + 1;
			//alert(seq_num);

			var chunho = {
				USERID : $("#Com_AId").val(),
				TELNO : $("#pnumber").val(),
				SENDTO : $("#spnumber").val(),
				MSG : $("textarea#snd_text").val(),

			}

			//  $('#target').html('전송 중 ....');

			$.ajax({
				url : 'https://mcti.chunhoncare.com:443/cmn/sendSms.do',
				type : "PUT",
				headers : {
					"X-HTTP-Method-Override" : "PUT"
				},
				dataType : "text",
				error : function(xhr, status, err) {
					alert('에러   :    ' + status);

				},

				success : function(data) {
					alert('성공:' + data);
					//$('#target').html(data.msg);

					//리컨결과 code: 0 성공, 1: 실패.. 개발팀에게 연락, 5: 통화중.. 6. 모바일 어플 실행 안됨..

					var return_json = jQuery.parseJSON(data);

					switch (return_json.code) {
					case 0:
						alert('성공');
						break;
					case 1:
						alert('실패');
						break;
					case 5:
						alert('통화중');
						break;
					case 9:
						alert('모바일 어플 실행안됨');
						break;
					}
				},
				data : chunho
			// data: JSON.stringify(person)
			});
		})

		$("#callphone").click(function() {
			rabbitmq_alarm();
			
			var seq_num = Math.floor(Math.random() * 10) + 1;
			//alert(seq_num);
			var chunho = {
				id : $("#Com_AId").val(),
				phone : $("#pnumber").val(),
				cid : $("#cid").val(),
				mid : $("#mid").val(),
				mname : $("#mname").val(),
				seq : '1720227',
			}

			//$('#target').html('전송 중 ....');

			$.ajax({
				url : 'https://mcti.chunhoncare.com:443/call/send',
				type : "POST",
				contentType : "Application/x-www-form-urlencoded",
				dataType : "html",
				error : function(xhr, status, err) {
					//alert('에러   :    '+err);
				},

				success : function(data) {
					//alert('성공:' +data);
					//$('#target').html(data.msg);

					//리컨결과 code: 0 성공, 1: 실패.. 개발팀에게 연락, 5: 통화중.. 6. 모바일 어플 실행 안됨..

					var return_json = jQuery.parseJSON(data);

					switch (return_json.code) {
					case 0:
						console.log('전화걸기 성공');
						break;
					case 1:
						console.log('실패');
						break;
					case 5:
						console.log('통화중');
						break;
					case 9:
						console.log('모바일 어플 실행안됨');
						break;
					}
				},

				data : chunho
			// data: JSON.stringify(person)
			});
		});
		
		$("#receiveAlarm").click(function(){
			rabbitmq_alarm();
		});

		$("#endphone").click(function() {
			var chunho = {
				id : $("#Com_AId").val(),
				phone : $("#pnumber").val(),
			}

			//  $('#target').html('전송 중 ....');

			$.ajax({
				url : 'https://mcti.chunhoncare.com:443/call/end',
				type : "POST",
				contentType : "Application/x-www-form-urlencoded",
				dataType : "html",
				error : function(data) {
					console.log('에러   :    ' + data);
				},

				success : function(data) {
					alert('성공:' + data);
					//$('#target').html(data.msg);

					//리컨결과 code: 0 성공, 1: 실패.. 개발팀에게 연락, 5: 통화중.. 6. 모바일 어플 실행 안됨..

					var return_json = jQuery.parseJSON(data);

					switch (return_json.code) {
					case 0:
						alert('성공');
						break;
					case 1:
						alert('실패');
						break;
					case 5:
						alert('통화중');
						break;
					case 9:
						alert('모바일 어플 실행안됨');
						break;
					}
				},
				data : chunho
			// data: JSON.stringify(person)
			});
		})
		
		
		$("#queuesendPost").click(function() {
			
			var senddata = {
					messageType : "call_send",
					emp_id : "chunho",
					emp_ph_num : "01033335555",
					cus_ph_num : "01044444444",
					cus_id : "hong",
					cus_name : "홍길동",
					client_seq : "1" 
				};
			$.ajax({
				url : 'https://tbs.chunhoncare.com/common/sendMessage.erp',
				contentType : "application/json; charset=utf-8",
				type : "POST",
				dataType : "html",
				traditional: true,
				mode : 'no-cors',
				cache:false,

				error : function(xhr,textStatus,errorThrown) {
					var messageTxt = ( errorThrown ? errorThrown : xhr.status );
					alert("result : " + messageTxt);
				},

				success : function(data) {
					alert("result : " + data);
				},
				data : JSON.stringify(senddata)
			});
		});
		
		
		
	</script>
</body>
</html>
