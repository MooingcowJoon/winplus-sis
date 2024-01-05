// CTI 상태정보를 저장할 변수
var statusCode;//CTI 상태정보 코드
var statusName;//CTI 상태정보 명칭

var groupCode1;
var groupCode2;
var groupCode3;
var groupCode4;
var groupCode5;

var checkGroupInterval;
//var var_normalize = /[^0-9]/gi; //숫자정규식
var var_normalize =/^(?=.*[*])|(?=.*[0-9])}/;

//웹소켓접속
function webSocketGo(){
	var strServerIp = document.getElementById("cti_server_ip").value;
	var strServerSocketIp = document.getElementById("cti_server_socket_ip").value;
	var strServerPort = document.getElementById("cti_server_port").value;
	goWebSocket(strServerIp, strServerSocketIp, strServerPort);
}

//로그인
function loginGo(){
	var strCtiLoginId = document.getElementById("cti_login_id").value;
	var strCtiLoginPwd = document.getElementById("cti_login_pwd").value;
	var strCtiLoginExt = document.getElementById("cti_login_ext").value;
	func_login(strCtiLoginId, strCtiLoginPwd, strCtiLoginExt);
}

//강제로그인
function forceLoginGo(){
	var strCtiLoginId = document.getElementById("cti_login_id").value;
	var strCtiLoginPwd = document.getElementById("cti_login_pwd").value;
	var strCtiLoginExt = document.getElementById("cti_login_ext").value;
	func_forceLogin(strCtiLoginId, strCtiLoginPwd, strCtiLoginExt);
}

//did번호체크
function didCheck(){
	var did = document.getElementById("did");//did체크박스
	var callGroup = document.getElementById("callGroup");//소속그룹
	var outCallNum = document.getElementById("outCallNum");//발신표시번호
	var strAgtExt = document.getElementById("cti_login_ext");//내선번호
	if(did.checked){
		//callGroup.disabled = true;
		outCallNum.innerHTML = strAgtExt.value;
	}else{
		//callGroup.disabled = false;
		chagePhoneNumber();
		//outCallNum.innerHTML = "";
	}
}

//makeCall - did체크
function didCheckMakeCall(){
	var did = document.getElementById("did");//did체크박스
	var outCallNum = document.getElementById("outCallNum").innerHTML;//발신표시번호
	var makeCallNum = document.getElementById("makeCallNum").value;//발신자번호

	if(did.checked){//did체크시 - did번호
		func_makeCall(outCallNum, makeCallNum, '');
	}else{//did해제시 - 그룹대표번호
		func_makeCall('', makeCallNum, '');
	}
}

//소속그룹변경
function changeGroup(){
	var callGroup = document.getElementById("callGroup");//소속그룹
	var outCallNum = document.getElementById("outCallNum");//발신표시번호
	//outCallNum.innerHTML = callGroup.value;
	var sIdx = callGroup.selectedIndex;
	var gCode = groupCode[sIdx].split("-");

	func_changeGroup(gCode[0], gCode[1], gCode[2]);
}

//발신표시번호 변경
function chagePhoneNumber(){
	var callGroup = document.getElementById("callGroup");//소속그룹
	var outCallNum = document.getElementById("outCallNum");//발신표시번호
	//outCallNum.innerHTML = callGroup.value;

	var did = document.getElementById("did");//did체크박스
	var strAgtExt = document.getElementById("cti_login_ext");//내선번호

	if(did.checked){//did체크시 - did번호
		outCallNum.innerHTML = strAgtExt.value;
	}else{//did해제시 - 그룹대표번호
		outCallNum.innerHTML = callGroup.value;

	}
}

//소속그룹선택
function callGroupSelect(sGroupCode1, sGroupCode2, sGroupCode3){
	groupCodeLength = groupCode1.length;//소속그룹갯수
    groupCode = new Array( groupCodeLength );//그룹배열
    sGroupCode = sGroupCode1+"-"+sGroupCode2+"-"+sGroupCode3;//소속그룹(아웃바운드)
	var callGroup = document.getElementById("callGroup");//소속그룹
	var outCallNum = document.getElementById("outCallNum");//발신표시번호

	for(var i=0; i<groupCodeLength; i++){
		groupCode[i] = groupCode1[i]+"-"+groupCode2[i]+"-"+groupCode3[i];
		if( sGroupCode == groupCode[i]){
			callGroup.options[i].selected = true;
			outCallNum.innerHTML = callGroup.options[i].value;
		}
	}
	document.getElementById("checkGroupValue2").value = "Y";
}


//전화번호입력
function phoneSend(phoneNum){
    document.getElementById("makeCallNum").value = phoneNum.replace(var_normalize,"");//숫자만등록
}

//숫자만 입력
function CheckNumeric(e){

	if(window.event){
		//엔터입력시 걸기버튼 활성화시 전화걸기
	     if(event.keyCode == 13){
	         if( document.getElementById("search_call_o").style.display == "inline" ){
	             //func_makeCall(document.getElementById("outCallNum").innerHTML, document.form1.makeCallNum.value, '');
	             didCheckMakeCall();
	         }
	    }

		if( event.keyCode != 42 &&  (event.keyCode < 48 || event.keyCode > 57 ) ){
			return false;
		}
		
	}else if(e){
		//엔터입력시 걸기버튼 활성화시 전화걸기
	     if(e.which == 13){
	         if( document.getElementById("search_call_o").style.display == "inline" ){
	             //func_makeCall(document.getElementById("outCallNum").innerHTML, document.form1.makeCallNum.value, '');
	             didCheckMakeCall();
	         }
	    }

		if( e.which != 42 &&  (e.which < 48 || e.which > 57 ) ){
			return false;
		}
		
	}
	return true;
}

//붙여넣기 금지
function fnPaste(){
	var regex = /\D/ig;
	if(regex.test(window.clipboardData.getData("Text"))){
		setTimeout('phoneSend(document.getElementById("makeCallNum").value)', 100);
		//return false;
	}else{
		return true;
	}
}

//로그인후 그룹정보정보체크
function checkGroupTimeOut(val1, val2, val3){
    if(document.getElementById("checkGroupValue").value == "Y"){
        callGroupSelect(val1, val2, val3);
        func_getAllTellerStatus();
        clearInterval(checkGroupInterval);
    }
}

// 사용안함
function checkGroupTimeOut2(){
    if(document.getElementById("checkGroupValue2").value == "Y"){
        func_getAllTellerStatus();
	}
}

//이미지버튼 나타내기
function showImgPhone(obj){
    document.getElementById(obj).style.display = "inline";
}

//이미지버튼 숨기기
function hiddenImgPhone(obj){
    document.getElementById(obj).style.display = "none";
}

//전화기상태이미지
function changePhoneState(state, stateStr){
    var ts = document.getElementById("tellerStatus");
    var stateCheckCount = 0;
    var stateCheckIdx = 0;
    for(var i=0; i<ts.length; i++){
        if( ts.options[i].value == state){
            stateCheckCount += stateCheckCount + 1;
            stateCheckIdx = i;
        }
    }

    if( stateCheckCount > 0 ){
        ts.options[stateCheckIdx].selected = true;
    }

    if(state=="0300"){//전화대기 - 걸기, 당겨받기
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");showImgPhone("search_pickup_o");
          hiddenImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0310"){//In 전화중 - 받기, 끊기
          hiddenImgPhone("search_call_o");showImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0311"){//In 연결 - 걸기, 끊기, 보류, 블라인드 호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0312"){//In 실패
          changePhoneStateNone();
    }else if(state=="0315"){//In 재연결 - 걸기, 끓기, 보류, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0320"){//호분배 시도 - 받기, 끊기
          hiddenImgPhone("search_call_o");showImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0321"){//호분배 연결 - 걸기, 끊기, 보류, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0322"){//호분배 실패 - X
          changePhoneStateNone();
    }else if(state=="0325"){//호분배재연결 - 걸기, 끊기, 보류, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0330"){//Out 시도 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0331"){//Out 연결 - 걸기, 끊기, 보류, 블라인드 호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0332"){//Out 실패
          changePhoneStateNone();
    }else if(state=="0335"){//Out 재연결 - 걸기, 끊기,보류, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0336"){//CTD 시도
          changePhoneStateNone();
    }else if(state=="0337"){//CTD 성공 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0338"){//CTD 실패
          changePhoneStateNone();
    }else if(state=="0342"){//B-TRNS 시도
          changePhoneStateNone();
    }else if(state=="0343"){//B-TRNS 실패
          changePhoneStateNone();
    }else if(state=="0345"){//B-TRNS 성공
          changePhoneStateNone();
    }else if(state=="0350"){//3자통화시도 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0351"){//3자통화성공
          changePhoneStateNone();
    }else if(state=="0352"){//3자IN통화중 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0353"){//3자OUT통화중 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0354"){//3자통화실패
          changePhoneStateNone();
    }else if(state=="0360"){//픽업시도 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0361"){//픽업대상
          changePhoneStateNone();
    }else if(state=="0362"){//픽업호분배
          changePhoneStateNone();
    }else if(state=="0363"){//픽업In
          changePhoneStateNone();
    }else if(state=="0365"){//픽업실패 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0371"){//HOLD In - 걸기, 끓기, 보류해제, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0372"){//HOLD Div - 걸기, 끊기, 보류해제, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0373"){//HOLD Out - 걸기, 끊기, 보류해제, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0374"){//HOLD 종료
          changePhoneStateNone();
    }else if(state=="0375"){//HOLD 복귀
          changePhoneStateNone();
    }else if(state=="0376"){//HELD In - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0377"){//HELD Div
          changePhoneStateNone();
    }else if(state=="0378"){//HELD Out - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0380"){//HOut 시도 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0381"){//HOut 연결 - 끊기, 보류, 보류해제, 모니터호전환, 3자통화
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          showImgPhone("search_mo_o");hiddenImgPhone("search_return_o");showImgPhone("search_3_o");
    }else if(state=="0382"){//HOut 실패
          changePhoneStateNone();
    }else if(state=="0383"){//H자동걸기
          changePhoneStateNone();
    }else if(state=="0386"){//H-CTD 시도
          changePhoneStateNone();
    }else if(state=="0387"){//H-CTD 성공
          changePhoneStateNone();
    }else if(state=="0388"){//H-CTD 실패
          changePhoneStateNone();
    }else if(state=="0391"){//호전환 시도
          changePhoneStateNone();
    }else if(state=="0392"){//호전환 성공
          changePhoneStateNone();
    }else if(state=="0393"){//호전환 실패
          changePhoneStateNone();
    }else if(state=="0401"){//보류 OUT 재연결
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          showImgPhone("search_mo_o");hiddenImgPhone("search_return_o");showImgPhone("search_3_o");
    }else if(state=="0402"){//보류 IN 재연결
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          showImgPhone("search_mo_o");hiddenImgPhone("search_return_o");showImgPhone("search_3_o");
    }else if(state=="0403"){//보류 호분배 재연결
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          showImgPhone("search_mo_o");hiddenImgPhone("search_return_o");showImgPhone("search_3_o");
    }else{//연결안됨, 상담원 등록코드
          //changePhoneStateNone();
          //20101126 수정
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");showImgPhone("search_pickup_o");
          hiddenImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
          //20101126 수정
    }
}

//전화기상태이미지 안나타내기
function changePhoneStateNone(){
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          hiddenImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
}


/////////////////////////////////////////////////////////////////////모듈 함수 호출/////////////////////////////////////////////////////////////////////

// WebSocket Loading Check
function func_loadingCheck(){
	var rtn;
	rtn = false;
	try{
		/*
		readyState 
		0 - CONNECTING(접속 처리 중)
		1 - OPEN(접속 중)
		2 - CLOSING(연결 종료 중)
		3 - CLOSED(연결 종료 또는 연결 실패)
		*/		
		if(webSocket.readyState == "1"){
			rtn = true;
		}else{
			alert("CTI서버와 접속되지 않았습니다. \n접속 후 사용하세요.");
			rtn = false;			
		}
	}catch(exception){
		alert("CTI서버와 접속되지 않았습니다. \n접속 후 사용하세요.");
		rtn = false;
	}
}

//로그인
function func_login(id, password, extension) { 
	if(func_loadingCheck() == false){
		setTimeout ('loginGo()', 3000);
		return;
	}
	if(id == ""){
		alert("아이디를 입력하세요.");
		return;
	}
	if(password == ""){
		alert("비밀번호를 입력하세요.");
		return;
	}
	if(extension == ""){
		alert("내선번호를 입력하세요.");
		return;
	}
	goWebSocketSendMsg("on^login^"+ id + "^" + password + "^" + extension);
}

//강제로그인
function func_forceLogin(id, password, extension){ 
	if(func_loadingCheck() == false){
		return;
	}
	if(id == ""){
		alert("아이디를 입력하세요.");
		return;
	}
	if(password == ""){
		alert("비밀번호를 입력하세요.");
		return;
	}
	if(extension == ""){
		alert("내선번호를 입력하세요.");
		return;
	}
	goWebSocketSendMsg("on^forceLogin^"+ id + "^" + password + "^" + extension);
}

//로그아웃
function func_logout(){ 
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^logout");	
	alert("로그아웃 되었습니다.");
}

//전화받기
function func_answer(){ 
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^answer");
}

//전화끊기
function func_hangup(){
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^hangup");
}

//비밀번호변경
function func_changePassword(newPassword) {
	if(func_loadingCheck() == false){
		return;
	}
	if(newPassword == ""){
		alert("비밀번호를 입력하세요.");
		return;
	}
	goWebSocketSendMsg("on^changePassword^"+newPassword);
}

//전화걸기
function func_makeCall(cid, callNum, userData){
	if(func_loadingCheck() == false){
		return;
	}
	if(callNum == ""){
		alert("전화번호를 입력하세요.");
		return;
	}
	goWebSocketSendMsg("on^makeCall^" + cid + "^" + callNum + "^" + userData);
}

//당겨받기
function func_pickup(){
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^pickup");	
}

//보류
function func_hold(){
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^hold");	
}

//보류해제
function func_unhold(){
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^unhold");	
}

//블라인드 호전환
function func_blindTransfer(callNum, userData){
	if(func_loadingCheck() == false){
		return;
	}
	if(callNum == ""){
		alert("전화번호를 입력하세요.");
		return;
	}
	goWebSocketSendMsg("on^blindTransfer^" + callNum + "^" + userData);	
}

//모니터 호전환
function func_monitorTransfer(){
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^monitorTransfer");
}

//3자통화
function func_threeWayCall(){
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^threeWayCall"); 
}

//모든 상담원의 상태 요구
function func_getAllTellerStatus(){	
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^getAllTellerStatus");
}

//상담모드변경
function func_changeTellerMode(tellerMode){
	if(func_loadingCheck() == false){
		return;
	}
	if(tellerMode == ""){
		alert("상담모드를 선택하세요.");
		return;
	}
	goWebSocketSendMsg("on^changeTellerMode^" + tellerMode);	// 0 - 인바운드, 1 - 아웃바운드
}

//상담원상태변경
function func_changeTellerStatus(tellerStatus){
	if(func_loadingCheck() == false){
		return;
	}
	if(tellerStatus == ""){
		alert("상담원상태를 선택하세요.");
		return;
	}
	goWebSocketSendMsg("on^changeTellerStatus^" + tellerStatus);	// 0 - 인바운드, 1 - 아웃바운드
}

//소속그룹변경
function func_changeGroup(cGroup1, cGroup2, cGroup3){
    if(func_loadingCheck() == false){
	    return;
	}
    goWebSocketSendMsg("on^changeGroup^" + cGroup1 +"^" + cGroup2 + "^" + cGroup3 );
}

/////////////////////////////////////////////////////////////////////모듈 함수 호출/////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////웹소켓응답 에서 함수 호출/////////////////////////////////////////////////////////////////////
// 웹소켓응답메세지에서 호출시켜주는 메소드(함수명을 변경하지 마세요), msg 정의는 별첨(CTI Event.ppt) 파일을 참고하세요.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ctiEvent(msg){
    // 예) msg: 86^데이터1^데이터2^데이터3^데이터4^시간     <--- "86": 스크린팝업, "^": 파라미터 구분자
	var tmpData = msg.split("^");
	
	if(tmpData[0] == "00"){// 로그인 응답
		if(tmpData[4] == "1"){
			alert("로그인되었습니다.");
	        //callGroupSelect(tmpData[6], tmpData[7], tmpData[8]);//소속그룹선택
            checkGroupInterval = setInterval("checkGroupTimeOut('"+tmpData[6]+"', '"+tmpData[7]+"', '"+tmpData[8]+"')", 1000);
		}else if(tmpData[4] == "2"){
			alert("아이디가 존재하지 않습니다.");
		}else if(tmpData[4] == "3"){
			alert("비밀번호가 일치하지 않습니다.");
		}else if(tmpData[4] == "4"){
			alert("로그온이 중복되었습니다.");
			forceLoginGo();
		}else if(tmpData[4] == "5"){
			alert("내선번호가 중복되었습니다.");
		}else if(tmpData[4] == "6"){
			alert("등록이 안된 번호입니다.");
		}else if(tmpData[4] == "7") {
			alert("상담원기본그룹 오류입니다.");
		}
    }else if(tmpData[0] == "01"){// 강제로그아웃(타 모듈에서 강제로그인 하면 기존의 모듈은 로그아웃 됨으로 기존 모듈에게 로그아웃 메시지 알림.)
    	alert("강제로그아웃 되었습니다.");

		document.getElementById("status").innerHTML = "연결안됨";
		document.getElementById("transferTryCnt").innerHTML = "0";
		document.getElementById("transferConnectCnt").innerHTML = "0";
		document.getElementById("ibTryCnt").innerHTML = "0";
		document.getElementById("ibConnectCnt").innerHTML = "0";
		document.getElementById("obTryCnt").innerHTML = "0";
		document.getElementById("obConnectCnt").innerHTML = "0";
		document.getElementById("cti_waitting_cnt").innerHTML = "0";
	}else if(tmpData[0] == "02"){// 비밀번호변경 응답
		if(tmpData[4] == "1"){
			alert("비밀번호가 변경되었습니다.");
		}else if(tmpData[4] == "2") {
			alert("잘못된 아이디입니다.");
		}else if(tmpData[4] == "3") {
			alert("잘못된 비밀번호입니다.");
		} 
    }else if(tmpData[0] == "24"){// 소속그룹변경
        if(tmpData[2] == 1){
            alert("소속그룹이 변경되었습니다.");
            chagePhoneNumber();
        }else if(tmpData[2] == 2){
            alert("실패");
        }
	}else if(tmpData[0] == "85"){// 상담원 모드 응답
		if(tmpData[1] == document.getElementById("cti_login_id").value){				// 받은 데이터가 로그인한 상담원의 아이디와 같은 경우
			if(tmpData[2] == "0"){
				//document.getElementById("responseMode").value = "인바운드";
			}else if(tmpData[2] == "1"){
				//document.getElementById("responseMode").value = "아웃바운드";
			}
		}
	}else if(tmpData[0] == "86"){// 스크린 팝업
		/*
				팝업타입
		 "01" : 호분배
		 "02" : 인바운드
		 "03" : 인바운드(돌려주기)
		 "04" : 아웃바운드
		 "05" : 오토콜
		 "06" : 당겨받기
		 "07" : 돌려받기
		 "08" : 3자통화


				팝업시점
		 "1" : Ring (팝업타입 "06", "07" 제외)
		 "2" : Answer
		*/
		
		/*
		alert("[스크린팝업정보]\n팝업타입:" + tmpData[1] +  "\n팝업시점:" + tmpData[2] +  "\nA-1 대표번호:" + tmpData[3] + 
		      "\nA-2 발신자번호:"+ tmpData[4] + "\nA-3 IVR 연동데이터:"+ tmpData[5] + "\nA-4 CALL_ID:"+ tmpData[6] + 
		      "\nA-5 IVR메뉴번호:"+ tmpData[7] + "\nA-6 사용자데이터:"+ tmpData[8] + "\nA-7 녹취파일명:"+ tmpData[9] + 
		      "\nA-8 녹취폴더(녹취일):" + tmpData[10] + "\nB-1 대표번호:" + tmpData[11] + "\nB-2 발신자번호:" + tmpData[12] +
		      "\nB-3 IVR 연동데이터:" + tmpData[13] + "\nB-4 콜아이디:" + tmpData[14] + "\nB-5 IVR메뉴번호:" + tmpData[15] +
		      "\nB-6 사용자데이터:" + tmpData[16]);
*/
		top.MainView.document.getElementById("cti_screen_popup_01").innerHTML = tmpData[1];
		top.MainView.document.getElementById("cti_screen_popup_02").innerHTML = tmpData[2];
		top.MainView.document.getElementById("cti_screen_popup_03").innerHTML = tmpData[3];
		top.MainView.document.getElementById("cti_screen_popup_04").innerHTML = tmpData[4];
		top.MainView.document.getElementById("cti_screen_popup_05").innerHTML = tmpData[5];
		top.MainView.document.getElementById("cti_screen_popup_06").innerHTML = tmpData[6];
		top.MainView.document.getElementById("cti_screen_popup_07").innerHTML = tmpData[7];
		top.MainView.document.getElementById("cti_screen_popup_08").innerHTML = tmpData[8];
		top.MainView.document.getElementById("cti_screen_popup_09").innerHTML = tmpData[9];
		top.MainView.document.getElementById("cti_screen_popup_10").innerHTML = tmpData[10];
		top.MainView.document.getElementById("cti_screen_popup_11").innerHTML = tmpData[11];
		top.MainView.document.getElementById("cti_screen_popup_12").innerHTML = tmpData[12];
		top.MainView.document.getElementById("cti_screen_popup_13").innerHTML = tmpData[13];
		top.MainView.document.getElementById("cti_screen_popup_14").innerHTML = tmpData[14];
		top.MainView.document.getElementById("cti_screen_popup_15").innerHTML = tmpData[15];
		top.MainView.document.getElementById("cti_screen_popup_16").innerHTML = tmpData[16];

		//top.TopView.location.href = "./topFrame.html";
		
	}else if(tmpData[0] == "89"){// 상담원이 변경할 수 있는 상태정보 응답
		document.getElementById("tellerStatus").options.length = 0;
		for(var i=1; i < tmpData.length-1; i+=2) {
			var op = document.getElementById("tellerStatus");
			var addedOpt=document.createElement('OPTION');
			op.add(addedOpt);
			addedOpt.value = tmpData[i];
			addedOpt.text = tmpData[i+1];
		}
	}else if(tmpData[0] == "90"){// CTI 상태정보 응답
		var j = 0;
		statusCode = new Array((tmpData.length-2)/2);
		statusName = new Array((tmpData.length-2)/2);
		for(var i=1; i < tmpData.length-1; i+=2) {
			statusCode[j] = tmpData[i];
			statusName[j] = tmpData[i+1];
			j++;
		}
	}else if(tmpData[0] == "91"){// CTI에 등록된 그룹정보에 대한 응답
        //셀렉트박스 초기화
        var callGroup = document.getElementById("callGroup");
        var callGroupLength = document.getElementById("callGroup").options.length;
        var opts = callGroup.getElementsByTagName("option");

        if( callGroupLength > 0 ){// 그룹이 이미있으면 초기화
            //for(var k=0; k<= callGroupLength ; k++){
                //callGroup.options[k]= null;
            //}
            callGroup.innerHTML = "";
        }

		var j = 0;
        groupCode = new Array( tmpData.length-1 );//그룹배열
		groupCode1 = new Array((tmpData.length-2)/5);//대그룹코드
		groupCode2 = new Array((tmpData.length-2)/5);//중그룹코드
		groupCode3 = new Array((tmpData.length-2)/5);//소그룹코드
		groupCode4 = new Array((tmpData.length-2)/5);//그룹명
		groupCode5 = new Array((tmpData.length-2)/5);//대표번호
		for(var i=1; i < tmpData.length-1; i+=5) {
			groupCode[j] = tmpData[i] + "-" + tmpData[i+1] + "-" + tmpData[i+2];
			groupCode1[j] = tmpData[i];
			groupCode2[j] = tmpData[i+1];
			groupCode3[j] = tmpData[i+2];
			groupCode4[j] = tmpData[i+3];
			groupCode5[j] = tmpData[i+4];
			var op1 = document.getElementById("callGroup");
			var addedOpt1 = document.createElement('OPTION');
			op1.add(addedOpt1);
			addedOpt1.value = groupCode5[j];
			//addedOpt1.text = tmpData[i+3];
            var splitText = tmpData[i+3].split("-");
			addedOpt1.text = splitText[2];//소그룹
			j++;
		}

		document.getElementById("checkGroupValue").value = "Y";//CTI에 등록된 그룹정보체크

	}else if(tmpData[0] == "93") {			/// 모든상담원상태 요구에 대한 응답
	}else if(tmpData[0] == "94"){// 상담원 상태 변경 
		if(tmpData[1] == document.getElementById("cti_login_id").value) {				// 받은 데이터가 로그인한 상담원의 아이디와 같은 경우
            if(document.getElementById("checkGroupValue2").value == "Y"){
				var callGroup = document.getElementById("callGroup");//소속그룹
				var outCallNum = document.getElementById("outCallNum");//발신표시번호
				var sIdx = callGroup.selectedIndex;
				var gCode = groupCode[sIdx].split("-");

				if(tmpData[8] != gCode[2]){
					for(var i=0; i< groupCode.length; i++){
						gCode2 = groupCode[i].split("-");
						if(tmpData[8] == gCode2[2]){
							callGroup.options[i].selected = true;
							chagePhoneNumber();
							break;
						}
					}
				}
			}

			for(var i=0; i < statusCode.length; i++) {
				if(statusCode[i] == tmpData[5]){
                    document.getElementById("status").innerHTML = statusName[i];
                    changePhoneState(tmpData[5], statusName[i]);//버튼이미지바꾸기
					break;
				}
			}

			document.getElementById("transferTryCnt").innerHTML =  tmpData[9];
			document.getElementById("transferConnectCnt").innerHTML =  tmpData[10];
			document.getElementById("ibTryCnt").innerHTML =  tmpData[11];
			document.getElementById("ibConnectCnt").innerHTML =  tmpData[12];
			document.getElementById("obTryCnt").innerHTML =  tmpData[13];
			document.getElementById("obConnectCnt").innerHTML =  tmpData[14];
		}
	}else if(tmpData[0] == "95"){// 고객대기자수 
		document.getElementById("cti_waitting_cnt").innerText =  tmpData[1];
    }else if(tmpData[0] == "96"){// 상담원 단말 상태 알림 전송
        if(tmpData[4] == "1"){//단말이 교환기에 등록 된 상태
            alert("전화기가 등록이 되었습니다.\n 상태를 변경해주세요.");
            func_changeTellerStatus("R001");
        }else if(tmpData[4] == "2"){// 단말이 교환기에 미 등록된 상태
            alert("전화기가 등록되지 않았습니다.");
        }
    } 
}
/////////////////////////////////////////////////////////////////////웹소켓응답 에서 함수 호출/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////웹소켓/////////////////////////////////////////////////////////////////////
//var webSocket;//웹소켓
var webSocket; 
function goWebSocket(serverIp, serverSocketIp, serverPort){
	webSocket = new WebSocket("ws://" + serverSocketIp + ":" + serverPort + "/websocket");//웹소켓생성	

	//웹소켓에 연결될때
	webSocket.onopen = function(event) {
		webSocket.send("on^init^"+ serverIp);
		onOpen(event)
	};

	//메세지가 왔을때 호출되는 메소드지정
	webSocket.onmessage = function(event) {
		onMessage(event)
	};
	
	//웹소켓에 오류날때
	webSocket.onerror = function(event) {
		onError(event)
	};
	
	//웹소켓연결이 끊겼을때
	webSocket.onclose = function(event){
		onClose(event)
	};  		
}

/* 웹소켓 함수 */
function onOpen(event) {
	document.getElementById('messages').value += "웹소켓 접속 연결\n";
}

function onMessage(event) {
	document.getElementById('messages').value += event.data + "\n";
	ctiEvent(event.data);
}

function onError(event) {
	document.getElementById('messages').value += '오류 : ' + event.data + "\n";	
}

function onClose(event){
	document.getElementById('messages').value += "웹소켓 접속 끊김\n";
}

//웹소켓에 메시지 보내기
function goWebSocketSendMsg(strMsg){
	webSocket.send(strMsg);	
}

//웹소켓 접속끊기
function goWebSocketDisconnect(){
	webSocket.close();
}

//자바스크립트오류메시지
window.onerror = function(msg, url, line){
	//alert("Message : " + msg + "\n URL : " + url + "Line number : " + line);
}
/////////////////////////////////////////////////////////////////////웹소켓/////////////////////////////////////////////////////////////////////