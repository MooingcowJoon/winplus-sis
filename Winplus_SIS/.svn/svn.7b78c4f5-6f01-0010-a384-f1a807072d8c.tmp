/** 
 * Description 
 * @Resource ERP Common Script
 * @since 2016.10.24
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.10.24 / 김종훈 / 신규 생성
 *********************************************
 */

/* Source 하단에서 ERP Common Script 사용을 위한 전역 변수에 Object 할당 */
var ERPCommonScriptFunction = function(){
  
  /** 
   * Description 
   * @function onEnterKeyDown
   * @function_Description Enter Key 입력 시 Function 실행
   * @param event (Object) / Event Object
   * @param fn (function) / CallBack Function
   * @param fnParam (Array) / CallBack Function Parameter
   * @author 김종훈
   */
  this.onEnterKeyDown = function(event, fn, fnParam){
    var keyCode = (window.event) ? event.which : event.keyCode;
      if (keyCode == 13) {
        if(event.target && event.target.blur){
          event.target && event.target.blur();
        }
        if(fn && typeof fn === 'function'){
          fn.apply(this, fnParam);
        }
        return false;
      }
      return true;
  }
  
  /** 
   * Description 
   * @function ajaxErrorMessage
   * @function_Description Ajax를 통한 메시지 출력
   * @param data (Object) / $erp.makeMessageParam Function 참조
   * @author 김종훈
   */
  this.ajaxErrorMessage = function(data){
    var errMessage = data.errMessage;
    var errCode = data.errCode;
    var errMessageParam = data.errMessageParam;
    var errMessageType = data.errMessageType;
    var errMessageOk = data.errMessageOk;
    var errMessageCancel = data.errMessageCancel;
    var nonAjaxParam = {"alertMessageType" : errMessageType, "alertMessageOk" : errMessageOk, "alertMessageCancel" : errMessageCancel};

    var callbackFn = null;
    var callbackFnParam = null;
    
    if(true){ //에러코드 사용안함
    	nonAjaxParam["alertMessageType"] = "알림";
    	errCode = null;
    }
    var param = $erp.makeMessageParam(errMessage, errCode, "error", false, errMessageParam, callbackFn, callbackFnParam, nonAjaxParam);
    
    $erp.alertMessage(param);
  }

  /** 
   * Description 
   * @function ajaxErrorHandler
   * @function_Description Ajax Error 호출 시 처리
   * @param jqXHR (Object) / JQuery Ajax API 참조
   * @param textStatus (Object) / JQuery Ajax API 참조
   * @param errorThrown (Object) / JQueryAjax API 참조
   * @author 김종훈
   */
  this.ajaxErrorHandler = function(jqXHR, textStatus, errorThrown){
    var status = jqXHR.status;
    var data = jqXHR.responseJSON;
    if(data != undefined && data != null && data.isError){
      var errMessage = data.errMessage;
      var errCode = data.errCode;
      var errMessageParam = null;
      var callbackFnParam = null; 
      var callbackFn = null;
      var errMessageType = data.errMessageType;
      var errMessageOk = data.errMessageOk;
      var errMessageCancel = data.errMessageCancel;
      var nonAjaxParam = {"alertMessageType" : errMessageType, "alertMessageOk" : errMessageOk, "alertMessageCancel" : errMessageCancel};
      
      if(errCode =='noSession'){
        callbackFnParam = new Array();    
        callbackFnParam[0] = data.pageName;
        callbackFn = function(param){
          if(param[0]){
            if(parent.isIndex){
              parent.location.href=param[0];
            } else {
              location.href=param[0];
            }
          }       
        } 
      }       
      var param = $erp.makeMessageParam(errMessage, errCode, "error", false, errMessageParam, callbackFn, callbackFnParam, nonAjaxParam);
      $erp.alertMessage(param);
    } else {
      var errMessage = textStatus;
      if(jqXHR && jqXHR.status){
        errMessage = errMessage + "(" + jqXHR.status + ")";
      }   
      $erp.alertMessage(errMessage);
    }
  }

  /** 
   * Description 
   * @function makeMessageParam
   * @function_Description Message Parameter 생성
   * @param message (String) / 일반메시지 or MessageSource 호출에 필요한 Code
   * @param code (String) / 메시지코드
   * @param type (String) / 메시지타입 (error, info , notice, alert)
   * @param isAjax (boolean) / 메시지 서버 참조 여부
   * @param messageParam (Array) / 메시지 출력에 사용할 Parameter
   * @param callbackFn (Function) / 메시지 확인 후 실행할 Function 
   * @param callbackFnParam (Object) / 메시지 확인 후 실행할 Function의 Parameter [{Key : Value}] 사용 요망
   * @param nonAjaxParam (Object) / Ajax 모드가 아닐 때 사용할 Parameter
   * @author 김종훈
   */
  this.makeMessageParam = function(message, code, type, isAjax, messageParam, callbackFn, callbackFnParam, nonAjaxParam){
	if(message == undefined || message == null || message == ""){
      //message = "";
      message = "일시적으로 오류가 발생하였습니다.<br>다시 실행해 주시기 바랍니다.";
    }else{
    	message = message.substring(0,1000);
    }
    if(code == undefined){
      code = null;
    }
    if(type == undefined){
      type = "error";
    }
    if(callbackFn == undefined){
      callbackFn = null;
    }
    if(callbackFnParam == undefined){
      callbackFnParam = null;
    } 
    if(isAjax != true){
      isAjax = false;
    }
    if(nonAjaxParam == undefined){
      nonAjaxParam == null;
    }
    var messageParamArray = [];
    if(messageParam == undefined){
      messageParam == null;
    } else if(typeof messageParam === 'string'){
      messageParamArray.push(messageParam);
    } else if(typeof messageParam === 'object'){
      if($erp.isArray(messageParam)){
        messageParamArray=messageParam;
      } else {
        for(var i in messageParam){
          messageParamArray.push(messageParam[i]);
        }
      }
    }
    var param = {
        'alertMessage' : message
        , 'alertCode' : code
        , 'alertType' : type        
        , 'isAjax' : isAjax
        , 'alertMessageParam' : messageParamArray
        , 'alertCallbackFn' : callbackFn    
        , 'alertCallbackFnParam' : callbackFnParam
        , 'alertNonAjaxParam' : nonAjaxParam
    };
    return param;
  }

  /** 
   * Description 
   * @function alertMessage
   * @function_Description 메시지 팝업 출력
   * @param param (Object) / 메시지 출력에 사용할 Parameter, $erp.makeMessageParam Function 참조
   * @author 김종훈
   */
  this.alertMessage = function(param){
    var alertTypeObject = ["error", "notice", "alert", "info"];
    var alertMessage=null;
    var alertCode=null;
    var alertMessageParam=null;
    var alertType=null;
    var alertCallbackFn=null;
    var alertCallbackFnParam=null;
    var isAjax = false;
    var  alertNonAjaxParam=null;
        
    if(typeof param == 'object' && !$erp.isArray(param)){
      alertMessage = param['alertMessage'];
      alertCode = param['alertCode'];
      alertType = param['alertType'];   
      isAjax = param['isAjax'];
      alertMessageParam = param['alertMessageParam'];
      alertCallbackFn = param['alertCallbackFn'];
      alertCallbackFnParam = param['alertCallbackFnParam'];
      alertNonAjaxParam = param['alertNonAjaxParam'];
    } else if(typeof param == 'object' && $erp.isArray(param)){
      alertMessage = param[0];
      alertCode = param[1];
      alertType = param[2];   
      isAjax = param[3];
      alertMessageParam = param[4];
      alertCallbackFn = param[5];
      alertCallbackFnParam = param[6];
      alertNonAjaxParam = param[7];
    } else if(typeof param == 'string'){
      alertMessage = param;
    } else {
      alert(param);
      return;
    }
    
    var isRightAlertType = false; 
    for(var i in alertTypeObject){
      if(alertType == null){
        continue;
      }
      if(alertType.toLowerCase() == alertTypeObject[i]){
        isRightAlertType = true;
        alertType = alertTypeObject[i];
      }
    }
    if(!isRightAlertType){
      alertType = "error";
    }
    if(!(isAjax == false)){
      $.ajax({
        url : "/common/system/message/getCommonMessage.do"
        ,data : {
          'alertMessage' : alertMessage
          ,'alertCode' : alertCode
          ,'alertType' : alertType
          ,'alertMessageParam' : alertMessageParam
        }
        ,method : "POST"
        ,dataType : "JSON"
        ,success : function(data){
          if(data.isError){
            $erp.ajaxErrorMessage(data);
          } else {
            var alertFinalMessage = data.resultMessage;
            var alertFinalMessageType = data.resultMessageType;
            var alertFinalMessageOk = data.resultMessageOk;
            var alertFinalMessageCancel = data.resultMessageCancel;
            
            if(alertCallbackFn != undefined && alertCallbackFn != null
                && typeof alertCallbackFn == 'function'){ 
              dhtmlx.message({
                title: alertFinalMessageType,
                type: "alert",
                text: alertFinalMessage,
                ok: alertFinalMessageOk,
                cancel: alertFinalMessageCancel,
                callback: (function(alertCallbackFnParam) {
                  return function() {
                    if(alertCallbackFnParam != null){
                      alertCallbackFn(alertCallbackFnParam);
                    } else {
                      alertCallbackFn();
                    }
                    };
                  })(alertCallbackFnParam)
              });
            } else {
              dhtmlx.message({
                title: alertFinalMessageType,
                  type: "alert",
                  text: alertFinalMessage              
              });
            }
          }
        }, error : function(jqXHR, textStatus, errorThrown){
          $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
        }
      });
    } else if(isAjax == false) {
      var alertFinalMessage = alertMessage;
      var alertFinalMessageType = undefined;
        var alertFinalMessageOk= undefined;
        var alertFinalMessageCancel =undefined;
        
        if(alertNonAjaxParam != undefined && alertNonAjaxParam != null){
        if(typeof param == 'object' && !$erp.isArray(alertNonAjaxParam)){
          alertFinalMessageType=alertNonAjaxParam['alertMessageType'];
          alertFinalMessageOk=alertNonAjaxParam['alertMessageOk'];
          alertFinalMessageCancel=alertNonAjaxParam['alertMessageCancel'];
        } else if(typeof param == 'object' && $erp.isArray(alertNonAjaxParam)){
          alertFinalMessageType=alertNonAjaxParam[0];
          alertFinalMessageOk=alertNonAjaxParam[1];
          alertFinalMessageCancel=alertNonAjaxParam[2];
        } else if(typeof param == 'string'){
          alertFinalMessageType=alertNonAjaxParam;
        }
        }
      
      if(alertMessageParam != null){
        if(typeof alertMessageParam == 'object' && !$erp.isArray(alertMessageParam)){
          for(var i in alertMessageParam){
            alertFinalMessage=alertFinalMessage.replace("{" + i + "}", alertMessageParam[i]);
          }
        } else if(typeof alertMessageParam == 'object' && $erp.isArray(alertMessageParam)){
          var i = 0;
          for(var key in alertMessageParam){          
            alertFinalMessage=alertFinalMessage.replace("{" + i + "}", alertMessageParam[key]);
            i++;
          }
        } else if(typeof alertMessageParam == 'string'){
          alertFinalMessage=alertFinalMessage.replace("{0}", alertMessageParam);
        }
      }   
      
      if(alertCode != null){
        alertFinalMessage += "<br/>"; 
        alertFinalMessage += "[" + alertCode + "]";   
      }
      
      if(alertCallbackFn != undefined && alertCallbackFn != null
          && typeof alertCallbackFn == 'function'){ 
        dhtmlx.message({
        title: alertFinalMessageType,
          type: "alert",
          text: alertFinalMessage,
          ok: alertFinalMessageOk,
          cancel: alertFinalMessageCancel,        
          callback: (function(alertCallbackFnParam) {
            return function() {
              if(alertCallbackFnParam != null){
                alertCallbackFn(alertCallbackFnParam);
              } else {
                alertCallbackFn();
              }
              };
            })(alertCallbackFnParam)
        });
      } else {
        dhtmlx.message({
          title: alertFinalMessageType,
            type: "alert",
            text: alertFinalMessage,
            ok: alertFinalMessageOk,
            cancel: alertFinalMessageCancel     
        });
      }
    }
  }

	/** 
	* Description 
	* @function confirmMessage
	* @function_Description 예/아니오 메시지 팝업 출력
	* @param param (Object) / 메시지 출력에 사용할 Parameter, $erp.makeMessageParam Function 참조
	* @author 김종훈
	*/
	this.confirmMessage = function(param){
		var alertMessage=null;
		var alertCode=null;
		var alertMessageParam=null;
		var alertType=null;
		var alertCallbackFn=null;
		var alertCallbackFnParam=null;
		var alertCallbackFnFalse=null;
		var alertCallbackFnParamFalse=null;
		    
		var alertTypeAlert = '경고';      //경고
		var alertTypeNotice = '알림';     //알림
		var alertTypeInfo = '정보';       //정보
		var alertTypeError = '오류';      //오류
		var alertFinalMessageOk = '확인';   //확인
		var alertFinalMessageCancel = '취소'; //취소
		var alertTypeClose = '닫기';      //닫기
		
		if(typeof param === 'object' && !$erp.isArray(param)){
			alertMessage = param['alertMessage'];
			alertCode = param['alertCode'];
			alertMessageParam = param['alertMessageParam'];
			alertCallbackFn = param['alertCallbackFn'];
			alertCallbackFnParam = param['alertCallbackFnParam'];
			alertCallbackFnFalse = param['alertCallbackFnFalse'];
			alertCallbackFnParamFalse = param['alertCallbackFnParamFalse'];
		} 
		
		if(param['alertType'] == "error"){
			alertType = alertTypeError;
		}
		if(param['alertType'] == "notice"){
			alertType = alertTypeNotice;
		}
		if(param['alertType'] == "alert"){
			alertType = alertTypeAlert;
		}
		if(param['alertType'] == "info"){
			alertType = alertTypeInfo;
		}
		
		dhtmlx.message({
			title: alertType,
			type: "confirm",
			text: alertMessage,
			ok: alertFinalMessageOk,
			cancel: alertFinalMessageCancel,
			callback: (function(alertCallbackFnParam) {
				return function(result) {
					if(result == true){
						if(alertCallbackFn != undefined && alertCallbackFn != null && typeof alertCallbackFn === 'function'){
							if(alertCallbackFnParam != null){
								alertCallbackFn(alertCallbackFnParam);
							} else {
								alertCallbackFn();
							}
						}
					}else{
						if(alertCallbackFnFalse != undefined && alertCallbackFnFalse != null && typeof alertCallbackFnFalse === 'function'){
							if(alertCallbackFnParamFalse != null){
								alertCallbackFnFalse(alertCallbackFnParamFalse);
							} else {
								alertCallbackFnFalse();
							}
						}
					}
				};
			})(alertCallbackFnParam)
		});
	}
  
  /*this.confirmMessage = function(param){
    var alertTypeObject = ["error", "notice", "alert", "info"];
    var alertMessage=null;
    var alertCode=null;
    var alertMessageParam=null;
    var alertType=null;
    var alertCallbackFn=null;
    var alertCallbackFnParam=null;
    var isAjax = null;
    var  alertNonAjaxParam=null;
    
    if(typeof param === 'object' && !$erp.isArray(param)){
      alertMessage = param['alertMessage'];
      alertCode = param['alertCode'];
      alertType = param['alertType'];   
      isAjax = param['isAjax'];
      alertMessageParam = param['alertMessageParam'];
      alertCallbackFn = param['alertCallbackFn'];
      alertCallbackFnParam = param['alertCallbackFnParam'];
      alertNonAjaxParam = param['alertNonAjaxParam'];
    } else if(typeof param === 'object' && $erp.isArray(param)){
      alertMessage = param[0];
      alertCode = param[1];
      alertType = param[2];   
      isAjax = param[3];
      alertMessageParam = param[4];
      alertCallbackFn = param[5];
      alertCallbackFnParam = param[6];
      alertNonAjaxParam = param[7];
    } else if(typeof param === 'string'){
      alertMessage = param;
    } else {
      alert(param);
      return;
    }
    var isRightAlertType = false; 
    for(var i in alertTypeObject){
      if(alertType == null){
        continue;
      }
      if(alertType.toLowerCase() == alertTypeObject[i]){
        isRightAlertType = true;
        alertType = alertTypeObject[i];
      }
    }
    if(!isRightAlertType){
      alertType = "error";
    }
    if(!(isAjax === false)){
      $.ajax({
        url : "/common/system/message/getCommonMessage.do"
        ,data : {
          'alertMessage' : alertMessage
          ,'alertCode' : alertCode
          ,'alertType' : alertType
          ,'alertMessageParam' : alertMessageParam
        }
        ,method : "POST"
        ,dataType : "JSON"
        ,success : function(data){
          if(data.isError){
            $erp.ajaxErrorMessage(data);
          } else {
            var alertFinalMessage = data.resultMessage;
            var alertFinalMessageType = data.resultMessageType;
            var alertFinalMessageOk = data.resultMessageOk;
            var alertFinalMessageCancel = data.resultMessageCancel;
            
            if(alertCallbackFn != undefined && alertCallbackFn != null
                && typeof alertCallbackFn === 'function'){  
              dhtmlx.message({
                title: alertFinalMessageType,
                type: "confirm",
                text: alertFinalMessage,
                ok: alertFinalMessageOk,
                cancel: alertFinalMessageCancel,
                callback: (function(alertCallbackFnParam) {
                  return function(result) {
                      if(result == true){
                        if(alertCallbackFnParam != null){
                          alertCallbackFn(alertCallbackFnParam);
                        } else {
                          alertCallbackFn();
                        }
                      }
                    };
                  })(alertCallbackFnParam)
              });
            } else {
              dhtmlx.message({
                title: alertFinalMessageType,
                  type: "alert",
                  text: alertFinalMessage              
              });
            }
          }
        }, error : function(jqXHR, textStatus, errorThrown){
          $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
        }
      });
    } else if (!(isAjax === false)) {
      var alertFinalMessage = alertMessage;
      var alertFinalMessageType = undefined;
        var alertFinalMessageOk= undefined;
        var alertFinalMessageCancel =undefined;
        
        if(alertNonAjaxParam != undefined && alertNonAjaxParam != null){
      if(typeof param === 'object' && !$erp.isArray(alertNonAjaxParam)){
        alertFinalMessageType=alertNonAjaxParam['alertMessageType'];
        alertFinalMessageOk=alertNonAjaxParam['alertMessageOk'];
        alertFinalMessageCancel=alertNonAjaxParam['alertMessageCancel'];
      } else if(typeof param === 'object' && $erp.isArray(alertNonAjaxParam)){
        alertFinalMessageType=alertNonAjaxParam[0];
        alertFinalMessageOk=alertNonAjaxParam[1];
        alertFinalMessageCancel=alertNonAjaxParam[2];
      } else if(typeof param === 'string'){
        alertFinalMessageType=alertNonAjaxParam;
      }
        }
      
      if(alertMessageParam != null){
        if(typeof alertMessageParam === 'object' && !$erp.isArray(alertMessageParam)){
          for(var i in alertMessageParam){
            alertFinalMessage=alertFinalMessage.replace("{" + i + "}", alertMessageParam[i]);
          }
        } else if(typeof alertMessageParam === 'object' && $erp.isArray(alertMessageParam)){
          var i = 0;
          for(var key in alertMessageParam){          
            alertFinalMessage=alertFinalMessage.replace("{" + i + "}", alertMessageParam[key]);
            i++;
          }
        } else if(typeof alertMessageParam === 'string'){
          alertFinalMessage=alertFinalMessage.replace("{0}", alertMessageParam);
        }
      }   
      if(alertCode != null){
        alertFinalMessage += "<br/>"; 
        alertFinalMessage += "[" + alertCode + "]";   
      }
      
      if(alertCallbackFn != undefined && alertCallbackFn != null
          && typeof alertCallbackFn === 'function'){  
        dhtmlx.message({
        title: alertFinalMessageType,
          type: "confirm",
          text: alertFinalMessage,
          ok: alertFinalMessageOk,
          cancel: alertFinalMessageCancel,  
          callback: (function(alertCallbackFnParam) {
            return function(result) {
                if(result == true){
                  if(alertCallbackFnParam != null){
                    alertCallbackFn(alertCallbackFnParam);
                  } else {
                    alertCallbackFn();
                  }
                }
              };
            })(alertCallbackFnParam)
        });
      } else {
        dhtmlx.message({
          title: alertFinalMessageType,
            type: "alert",
            text: alertFinalMessage,
            ok: alertFinalMessageOk,
            cancel: alertFinalMessageCancel     
        });
      }
    }
  }*/
  
  /** 
   * Description 
   * @function confirmCancelMessage
   * @function_Description 예/아니오 메시지 팝업 출력 예 또는 아니오 선택시 둘다 fn이동
   * @param param (Object) / 메시지 출력에 사용할 Parameter, $erp.makeMessageParam Function 참조
   * @author 김종훈
   */
  this.confirmCancelMessage = function(param){
    var alertMessage=null;
    var alertCode=null;
    var alertMessageParam=null;
    var alertType=null;
    var alertCallbackFn=null;
    var alertCallbackFnParam=null;
    var alertCancelbackFn=null;//취소시
    
    var alertTypeAlert = '경고';      //경고
    var alertTypeNotice = '알림';     //알림
    var alertTypeInfo = '정보';       //정보
    var alertTypeError = '오류';      //오류
    var alertFinalMessageOk = '확인';   //확인
    var alertFinalMessageCancel = '취소'; //취소
    var alertTypeClose = '닫기';      //닫기

    if(typeof param === 'object' && !$erp.isArray(param)){
      alertMessage = param['alertMessage'];
      alertCode = param['alertCode'];
      alertMessageParam = param['alertMessageParam'];
      alertCallbackFn = param['alertCallbackFn'];
      alertCallbackFnParam = param['alertCallbackFnParam'];
      alertCancelbackFn = param['alertCancelbackFn'];
    } 
    
    if(param['alertType'] == "error"){
      alertType = alertTypeError;
    }
    if(param['alertType'] == "notice"){
      alertType = alertTypeNotice;
    }
    if(param['alertType'] == "alert"){
      alertType = alertTypeAlert;
    }
    if(param['alertType'] == "info"){
      alertType = alertTypeInfo;
    }
    
    dhtmlx.message({
      title: alertType,
        type: "confirm",
        text: alertMessage,
        ok: alertFinalMessageOk,
        cancel: alertFinalMessageCancel,  
        callback: (function(alertCallbackFnParam) {
          return function(result) {
              if(result == true){
                if(alertCallbackFnParam != null){
                  alertCallbackFn(alertCallbackFnParam);
                } else {
                  alertCallbackFn();
                }
              }else{
            	  if(alertCancelbackFn != null){
            		  alertCancelbackFn(alertCallbackFnParam);
                    } else {
                    	alertCancelbackFn();
                    } 
              }
            };
          })(alertCallbackFnParam)
      });
  }
  

  /** 
   * Description 
   * @function isLengthOver
   * @function_Description String Length 초과 여부 확인
   * @param str (String) / 확인에 사용할 String 값
   * @param limitLength (Number) / 초과 기준이 되는 값
   * @author 김종훈
   */
  this.isLengthOver = function(str, limitLength){
    if(str == undefined || str == null){
      str = "";
    }
    if(str.length){
      var length = str.length;
      if(length > limitLength){
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /** 
   * Description 
   * @function isLengthOver
   * @function_Description String Byte Size 초과 여부 확인
   * @param str (String) / 확인에 사용할 String 값
   * @param limitByteSize (Number) / 초과 기준이 되는 값
   * @author 김종훈
   */
  this.isByteSizeOver = function(str, limitByteSize){
    if(str == undefined || str == null){
      str = "";
    }
    var byteSize = $erp.getByteLength(str);
    if(byteSize > limitByteSize){
      return true;
    } else {
      return false;
    }
  }

  /** 
   * Description 
   * @function getByteLength
   * @function_Description String Byte Size 확인
   * @param s (String) / 확인할 String 값
   * @param b / 미사용, 내부 계산용 변수
   * @param i / 미사용, 내부 계산용 변수
   * @param c / 미사용, 내부 계산용 변수
   * @author 김종훈, Google 인용
   */
  this.getByteLength = function(s,b,i,c){
      /* for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1); */
    /* UTF-8의 경우 한글 3byte지만 DB가 한글 2byte이므로 강제 2byte로 계산되게 처리 */
    for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?2:c>>7?2:1);
      return b;
  }


  /** 
   * Description 
   * @function getDhtmlXComboFromSelect
   * @function_Description DhtmlXCombo 생성을 Select Dom 객체에서 -> Ajax 미사용
   * @param domElementId (String) / Dom Element Object ID
   * @param paramName (String) / Form Parameter 전송 시 사용할 Name
   * @param paramWidth (Number) / Object 가로 넓이
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @author 김종훈
   */
  this.getDhtmlXComboFromSelect = function(domElementId, paramName, paramWidth, defaultOption){
    var defaultWidth = 200;
    var width = defaultWidth;
    if(paramWidth && !isNaN(paramWidth)){
      width = paramWidth;
    }
    if(defaultOption == null || defaultOption == ''){
      defaultOption = undefined
    }
    var dhtmlXComboObject = null;
    
    var domElementObj = document.getElementById(domElementId);
    if(!$erp.isEmpty(domElementObj)){
      domElementObj.setAttribute("name", paramName);
      dhtmlXComboObject = dhtmlXComboFromSelect(domElementId, width);
      dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
      dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
      
      if($erp.isEmpty(defaultOption)){
        dhtmlXComboObject.selectOption(0);
      } else {
        dhtmlXComboObject.setComboValue(defaultOption);
      }
      
      dhtmlXComboObject.readonly(true);
      dhtmlXComboObject.base.setAttribute("id", domElementId);
      dhtmlXComboObject.base.setAttribute("name", paramName);
    }
    return dhtmlXComboObject;
  }

  /** 
   * Description 
   * @function getDhtmlXComboMulti
   * @function_Description getDhtmlXComboMulti 생성
   * @param domElementId (String) / Dom Element Object ID
   * @param paramName (String) / Form Parameter 전송 시 사용할 Name
   * @param cmmn_cd (Object, Array, String) / System 공통코드
   * @param paramWidth (Number) / Object 가로 넓이
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @author 김종훈
   */
  this.getDhtmlXComboMulti = function(domElementId, paramName, cmmn_cd, paramWidth, blankText, defaultOption, callbackFunction){
    var tmpObj= tmpObj=$erp.getDhtmlXCombo(domElementId, paramName, cmmn_cd, paramWidth, blankText, defaultOption, callbackFunction, "checkbox");
    //전체가 잇는경우
    if(blankText){
      //체크클릭
      tmpObj.attachEvent("onCheck", function(value, state){
          //console.log("onCheck = "+value+"/"+state);
        if(value=='' && this.getOptionsCount()>1){
          for(var i=1;i<this.getOptionsCount();i++){
            this.setChecked(i,state);
          }
        }
        else if(value!=''){
          state = this.getOptionsCount()-1==(this.getChecked().length - (this.isChecked(0) ? 1 : 0)) 
          this.setChecked(0, state);
        }
        
      });
      //ComboText 명명
      tmpObj.attachEvent("onClose", function(){
        var obj_arr = tmpObj.getChecked();
        var title='';
        for(var i=0;i<obj_arr.length;i++){
          title+=tmpObj.getOption(obj_arr[i]).text+"|";
        }
        title=title.substr(0,title.length-1);
        //전체가 선택된경우
        if(tmpObj.isChecked(0)){
          tmpObj.setComboText("전체");
        }
        else{
          //console.log(tmpObj.getChecked());
          tmpObj.setComboText("선택("+obj_arr.length+")");
          
        }
       });
    }
    //전체가 없는경우
    else{
      
    }

    //콤보박스 css 처리
    $('.dhxcombo_input').css('margin-left','0px');
    return tmpObj;
  }
  
  /** 
   * Description 
   * @function getDhtmlXComboByUpperCode
   * @function_Description 상위공통코드를 통한 DhtmlXCombo 생성
   * @param domElementId (String) / Dom Element Object ID
   * @param paramName (String) / Form Parameter 전송 시 사용할 Name
   * @param upper_cmmn_cd (Object, Array, String) / System 공통코드
   * @param upper_cmmn_detail_cd (String) / System 공통코드
   * @param paramWidth (Number) / Object 가로 넓이
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param optionType (String) / Combo Option Type
   * @author 김종훈
   */
  this.getDhtmlXComboByUpperCode = function(domElementId, paramName, upper_cmmn_cd, upper_cmmn_detail_cd, paramWidth, blankText, defaultOption, callbackFunction, optionType){
    var defaultWidth = 200;
    var width = defaultWidth;
    if(paramWidth && !isNaN(paramWidth)){
      width = paramWidth;
    }
    if(blankText == null){
      blankText = undefined;
    }
    if(defaultOption == null || defaultOption == ''){
      defaultOption = undefined;
    } 

    var divParamMap = {};     
    if(!$erp.isEmpty(upper_cmmn_cd)){
      if(typeof upper_cmmn_cd === 'object' && $erp.isArray(upper_cmmn_cd)){
        divParamMap.div1 = upper_cmmn_cd[1];
        divParamMap.div2 = upper_cmmn_cd[2];
        divParamMap.div3 = upper_cmmn_cd[3];
        divParamMap.div4 = upper_cmmn_cd[4];
        divParamMap.div5 = upper_cmmn_cd[5];
        upper_cmmn_cd = upper_cmmn_cd[0];
      } else if(typeof upper_cmmn_cd === 'object' && !$erp.isArray(upper_cmmn_cd)){
        divParamMap.div1 = upper_cmmn_cd['div1'];
        divParamMap.div2 = upper_cmmn_cd['div2'];
        divParamMap.div3 = upper_cmmn_cd['div3'];
        divParamMap.div4 = upper_cmmn_cd['div4'];
        divParamMap.div5 = upper_cmmn_cd['div5'];
        upper_cmmn_cd = upper_cmmn_cd['commonCode'];
      }       
    } else {
      return;
    }

    var dhtmlXComboObject = null;
    if(domElementId != undefined && upper_cmmn_cd != undefined){
      /* new dhtmlXCombo(id, name, width); */       
      dhtmlXComboObject = new dhtmlXCombo(domElementId, paramName, width, optionType);
      dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
      dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.readonly(true);   
      document.getElementById(domElementId).setAttribute("name", paramName);
      $erp.setDhtmlXComboByUpperCode(dhtmlXComboObject, upper_cmmn_cd, upper_cmmn_detail_cd, blankText, defaultOption, callbackFunction, divParamMap);
    }
    return dhtmlXComboObject;
  }
  
  /** 
   * Description 
   * @function setDhtmlXComboByUpperCode
   * @function_Description 상위코드를 통한 Combo 설정
   * @param dhtmlXComboObject (Object) / DhtmlXComboObject
   * @param upper_cmmn_cd (String, Object, Array) / System 상위공통코드, Object, Array 사용시 구분(Div) 필터링 가능
   * @param upper_cmmn_detail_cd (String) / System 상위공통상세코드
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param divParamMap (Object) / 구분 조건 Map
   * @author 김종훈
   */
  this.setDhtmlXComboByUpperCode = function(dhtmlXComboObject, upper_cmmn_cd, upper_cmmn_detail_cd, blankText, defaultOption, callbackFunction, divParamMap){ 
    var div1;
    var div2;
    var div3;
    var div4;
    var div5;

    if(!$erp.isEmpty(divParamMap)){
      div1 = divParamMap['div1'];
      div2 = divParamMap['div2'];
      div3 = divParamMap['div3'];
      div4 = divParamMap['div4'];
      div5 = divParamMap['div5'];
    }
    
    $.ajax({
      url : "/common/system/code/getCommonCodeList.do"
      ,data : {
        'UPPER_CMMN_CD' : upper_cmmn_cd
        , 'UPPER_CMMN_DETAIL_CD' : upper_cmmn_detail_cd
        , 'DIV1' : div1
        , 'DIV2' : div2
        , 'DIV3' : div3
        , 'DIV4' : div4
        , 'DIV5' : div5
        , 'TYPE' : 'UPPER'
      }
      ,method : "POST"
      ,dataType : "JSON"
      ,success : function(data){
        if(data.isError){
          $erp.ajaxErrorMessage(data);
        } else {              
          var commonCodeList = data.commonCodeList;
          var optionArray = [];   
          if(blankText != undefined && blankText != null && blankText !== false){
            /* blankText가 true인 경우 전체로 Text 변경 */
            if(blankText === true){
              blankText = "전체";
            }
            optionArray.push({ value : "", text : blankText});
          }       
          for(var i in commonCodeList){
            var commonCodeObj = commonCodeList[i];            
            var option = { value : null, text : null};
            for(var key in commonCodeObj){
              var value =  commonCodeObj[key];
              if(key == 'CMMN_DETAIL_CD'){  /* CMMN_DETAIL_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.value = value;
              } else if(key == 'CMMN_DETAIL_CD_NM'){ /* CMMN_DETAIL_CD_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.text = value;
              } else {
                option[key] = value;
              }
            }   
            optionArray.push(option);           
          }
          dhtmlXComboObject.clearAll();
          dhtmlXComboObject.addOption(optionArray);
          if(typeof dhtmlXComboObject.getParent() === 'string'){
            if(dhtmlXComboObject.getOptionsCount() > 0){
              dhtmlXComboObject.selectOption(0);
            }
            if(defaultOption != undefined && defaultOption != null){
              dhtmlXComboObject.setComboValue(defaultOption);
            }
          }
          
          //checkbox 모두 선택
          if(typeof optionType === 'string'){
            for(var x=0;x<dhtmlXComboObject.getOptionsCount();x++){
              dhtmlXComboObject.setChecked(x,true);
            }
          }
          
          if(callbackFunction && typeof callbackFunction === 'function'){
            callbackFunction.apply(dhtmlXComboObject, []);
          }
        }
      }, error : function(jqXHR, textStatus, errorThrown){
        $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
      }
    });
  }
  
  
  /** 
   * Description 
   * @function getDeptDhtmlXCombo
   * @function_Description 부서 DhtmlXCombo 생성
   * @param domElementId (String, Array) / Dom Element Object ID
   * @param paramName (String, Array) / Form Parameter 전송 시 사용할 Name
   * @param paramWidth (Number) / Object 가로 넓이
   * @param blankText (String, Array) / 빈 칸 텍스트 이름
   * @author 김종훈
   */
  this.getDeptDhtmlXCombo = function(domElementId, paramName, paramWidth, blankText){
    if($erp.isEmpty(domElementId)) { return false; }

    var defaultWidth = 200;
    var width = defaultWidth;
    if(paramWidth && !isNaN(paramWidth)){
      width = paramWidth;
    }
    
    var domElementIdArray = [];   
    if($erp.isArray(domElementId)){
      domElementIdArray = domElementId;
    } else if (typeof domElementId === 'object'){
      domElementIdArray[0] = domElementId.service;
      domElementIdArray[1] = domElementId.branch;
      domElementIdArray[2] = domElementId.sales;
    } else if (typeof domElementId === 'string'){
      domElementIdArray[0] = domElementId;
    } else {
      return false;
    }
    
    var domElementNameArray = [];
    if($erp.isArray(paramName)){
      domElementNameArray = paramName;
    } else if (typeof domElementId === 'object'){
      domElementNameArray[0] = paramName.service;
      domElementNameArray[1] = paramName.branch;
      domElementNameArray[2] = paramName.sales;
    } else if (typeof domElementId === 'string'){
      domElementNameArray[0] = paramName;
    }
    
    for (var i in domElementNameArray){
      if($erp.isEmpty(domElementNameArray[i])){
        domElementNameArray[i] = domElementIdArray[i];
      }
    }
    
    var blankTextArray = [];
    if($erp.isArray(blankText)){
      blankTextArray = blankText;
    } else if (typeof blankText === 'object'){
      blankTextArray[0] = blankText.service;
      blankTextArray[1] = blankText.branch;
      blankTextArray[2] = blankText.sales;
    } else if (typeof blankText === 'string'){
      blankTextArray[0] = blankText;
    }

    var dhtmlXComboObjectMap = {
        service : null
        , branch : null
        , sales : null
      };
    for(var i in domElementIdArray){
      var id = domElementIdArray[i];
      var name = domElementNameArray[i];
      if(!$erp.isEmpty(id)){
        /* new dhtmlXCombo(id, name, width); */       
        dhtmlXComboObject = new dhtmlXCombo(id, name, width);
        dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
        dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
        dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
        dhtmlXComboObject.readonly(true);   
        document.getElementById(id).setAttribute("name", name);
        var blankTextStr = "전체";
        if(blankTextArray && !$erp.isEmpty(blankTextArray[i])){
          blankTextStr = blankTextArray[i];
        }
        if(i == 0){
          $erp.getDeptDhtmlXComboDataAjax(dhtmlXComboObject, null, blankTextStr);
          dhtmlXComboObjectMap.service = dhtmlXComboObject;         
        } else if (i > 0){
          var optionArray = [];           
          if(blankTextStr !== false){
            optionArray.push({ value : "", text : blankTextStr});
          }
          dhtmlXComboObject.addOption(optionArray);
          dhtmlXComboObject.selectOption(0);
          var upperAttraibuteName = "";
          if(i == 1){
            upperAttraibuteName = "service";
            dhtmlXComboObjectMap.branch = dhtmlXComboObject;
          } else if (i == 2){
            upperAttraibuteName = "branch";
            dhtmlXComboObjectMap.sales = dhtmlXComboObject;
          } 
          if(dhtmlXComboObjectMap && dhtmlXComboObjectMap[upperAttraibuteName]){
            var upperDhtmlXComboObject = dhtmlXComboObjectMap[upperAttraibuteName];
            upperDhtmlXComboObject.subComboObject = dhtmlXComboObject;
            upperDhtmlXComboObject.subComboBlankTextStr = blankTextStr;
            upperDhtmlXComboObject.attachEvent("onChange", function(value, text){     
              if(value == ""){
                this.subComboObject.clearAll();
                var optionArray = [];   
                if(blankTextStr !== false){
                  optionArray.push({ value : "", text : blankTextStr});
                }
                this.subComboObject.addOption(optionArray);
                this.subComboObject.selectOption(0);
              } else {
                $erp.getDeptDhtmlXComboDataAjax(this.subComboObject, value, blankTextStr);
              }
            });
          }
        }
      }
    }
    
    return dhtmlXComboObjectMap;
  }

  /** 
   * Description 
   * @function getDeptDhtmlXComboDataAjax
   * @function_Description 부서 DhtmlXCombo 데이터 비동기 조회
   * @param dhtmlXComboObject (Object) / 대상 DhtmlXCombo Object
   * @param upper_dept_cd (String) / 상위부서코드
   * @param blankText (String) / 빈 칸 텍스트 이름
   * @author 김종훈
   */
  this.getDeptDhtmlXComboDataAjax = function(dhtmlXComboObject, upper_dept_cd, blankText){
    $.ajax({
      url : "/common/system/code/getCommonCodeList.do"
      ,data : {
        'CMMN_CD' : "DEPT"
        ,'DIV1' : upper_dept_cd
      }
      ,method : "POST"
      ,dataType : "JSON"
      ,success : function(data){
        if(data.isError){
          $erp.ajaxErrorMessage(data);
        } else {
          //console.log(data);
          var commonDeptStatus = data.commonDeptStatus;
          var commonCodeList = data.commonCodeList;
          dhtmlXComboObject.clearAll();         
          var optionArray = [];   
          //console.log(commonCodeList[0].DEPT_DP);
          if(blankText !== false && !commonDeptStatus.isBlank){
            if((commonCodeList[0].DEPT_DP=='0' && commonDeptStatus.SAUPKUK_CD=='T')||(commonCodeList[0].DEPT_DP=='1' && commonDeptStatus.BHF_CD=='T')||(commonCodeList[0].DEPT_DP=='2' && commonDeptStatus.BUZPLC_CD=='T'))
            {
              //console.log(commonCodeList[0].DEPT_DP);
              //console.log(commonDeptStatus.SAUPKUK_CD);
              optionArray.push({ value : "", text : blankText});  
            }
            
          }
          for(var i in commonCodeList){
            var commonCodeObj = commonCodeList[i];            
            var option = { value : null, text : null};
            for(var key in commonCodeObj){
              var value =  commonCodeObj[key];
              if(key == 'DEPT_CD'){ /* DEPT_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.value = value;
              } else if(key == 'DEPT_NM'){ /* DEPT_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.text = value;
              } else {
                option[key] = value;
              }
            }   
            optionArray.push(option);           
          }
          dhtmlXComboObject.addOption(optionArray);
          dhtmlXComboObject.selectOption(0);
        }
      }, error : function(jqXHR, textStatus, errorThrown){
        $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
      }
    });
  }
  
  /** 
   * Description 
   * @function initGridComboCell
   * @function_Description DhtmlXGrid Combo Column 데이터 생성
   * @param dhtmlXGridObj (Object) / DhtmlXGrid Object
   * @author 김종훈
   */
  this.initGridComboCell = function(dhtmlXGridObj){
    var dhtmlXGridColumnArray = dhtmlXGridObj.columnsMapArray;
    if(dhtmlXGridColumnArray == undefined || dhtmlXGridColumnArray == null || dhtmlXGridColumnArray.length == 0){
      return false;
    } 
    for(var i in dhtmlXGridColumnArray){
      var dhtmlXGridColumn = dhtmlXGridColumnArray[i];
      var type = dhtmlXGridColumn.type;
      
      var cmmn_cd = null;
      var divParamMap = {};     
      if(!$erp.isEmpty(dhtmlXGridColumn.commonCode)){
        cmmn_cd = dhtmlXGridColumn.commonCode;
        if(typeof cmmn_cd === 'object' && $erp.isArray(cmmn_cd)){
          divParamMap.div1 = cmmn_cd[1];
          divParamMap.div2 = cmmn_cd[2];
          divParamMap.div3 = cmmn_cd[3];
          divParamMap.div4 = cmmn_cd[4];
          divParamMap.div5 = cmmn_cd[5];
          cmmn_cd = cmmn_cd[0];
        } else if(typeof cmmn_cd === 'object' && !$erp.isArray(cmmn_cd)){
          divParamMap.div1 = cmmn_cd['div1'];
          divParamMap.div2 = cmmn_cd['div2'];
          divParamMap.div3 = cmmn_cd['div3'];
          divParamMap.div4 = cmmn_cd['div4'];
          divParamMap.div5 = cmmn_cd['div5'];
          cmmn_cd = cmmn_cd['commonCode'];
        }       
      }
      var isDisabled = dhtmlXGridColumn.isDisabled;
      if(type == "combo" && (cmmn_cd != undefined && cmmn_cd != null && cmmn_cd.length > 0)){
        var dhtmlXComboObject = dhtmlXGridObj.getColumnCombo(i);
        dhtmlXComboObject.readonly(true);
        
        var gridComboId = dhtmlXGridObj.divId + "_" + cmmn_cd;
        $erp.asyncObjAddStart(gridComboId);
        dhtmlXComboObject["gridComboId"] = gridComboId;
        $erp.setDhtmlXComboDataAjax(dhtmlXComboObject, cmmn_cd, null, null, null, divParamMap);	
        
        if(isDisabled != undefined && isDisabled != null && isDisabled == true){
          dhtmlXComboObject.disable(true);
        }
      }
    }
  }

  /** 
   * Description 
   * @function initGridCustomCell
   * @function_Description DhtmlXGrid 임의로 생성된 Column 데이터 생성 (isHidden : 숨김, isEssential : 필수 컬럼 강조, type : dhxCalendar, dhxCalendarA가 있을 경우 포맷 설정)
   * @param dhtmlXGridObj (Object) / DhtmlXGrid Object
   * @author 김종훈
   */
this.initGridCustomCell = function(dhtmlXGridObj){
	var isDhxCalendar = false;
	var dhtmlXGridCoulmnColorArray = [];  
	var dhtmlXGridColumnArray = dhtmlXGridObj.columnsMapArray;
	if(dhtmlXGridColumnArray == undefined || dhtmlXGridColumnArray == null || dhtmlXGridColumnArray.length == 0){
		return false;
	}
	var maxLengthApplyMap = new Map();		// maxLength 적용대상 변수
	var selectAllApplyMap = new Map();		// isSelectAll 적용대상 변수
	for(var i in dhtmlXGridColumnArray){
		var dhtmlXGridColumn = dhtmlXGridColumnArray[i];
		var isHidden = dhtmlXGridColumn.isHidden;
		if(isHidden != undefined && isHidden != null && isHidden == true){
			dhtmlXGridObj.setColumnHidden(i, true);
		}
		var isEssenital = dhtmlXGridColumn.isEssential;
		if(isEssenital != undefined && isEssenital != null && isEssenital == true){
//			dhtmlXGridCoulmnColorArray.push("WhiteSmoke");
			dhtmlXGridCoulmnColorArray.push("#FFFFE4");
		} else {
			dhtmlXGridCoulmnColorArray.push("");
		}
		var type = dhtmlXGridColumn.type;
		if(type != undefined && type != null){
			if(isDhxCalendar === false && (type == "dhxCalendar" || type == "dhxCalendarA")){
				dhtmlXGridObj.setDateFormat("%Y-%m-%d", "%Y%m%d"); 
				dhtmlXGridObj.attachEvent("onDhxCalendarCreated", function (calObject) {
					calObject.setSensitiveRange("1900-01-01", "2999-12-31");
					calObject.hideTime();
				});
				isDhxCalendar = true;
			}
		}
		var maxLength = dhtmlXGridColumn.maxLength;
		if(maxLength != undefined && maxLength != null && maxLength > 0){
			maxLengthApplyMap.set(i,maxLength);
		}
		var isSelectAll = dhtmlXGridColumn.isSelectAll;
		if(isSelectAll != undefined && isSelectAll != null && isSelectAll == true){
			selectAllApplyMap.set(i,isSelectAll);
		}
	}
	if(maxLengthApplyMap.size > 0){
		dhtmlXGridObj.attachEvent("onEditCell",function(stage,rowId,cellIndex){
			var mapKey = cellIndex+""; // int to String
			
			if(stage==1){
				if(maxLengthApplyMap.has(mapKey)){
					dhtmlXGridObj.editor.obj.onkeypress = function(){
						return dhtmlXGridObj.editor.obj.value.length < maxLengthApplyMap.get(mapKey);
					};
				}
			}
			return true;
		});
	}
	if(selectAllApplyMap.size > 0){
		dhtmlXGridObj.attachEvent("onEditCell",function(stage,rowId,cellIndex){
			var mapKey = cellIndex+""; // int to String
			
			if(stage==1){
				if(selectAllApplyMap.has(mapKey)){
					dhtmlXGridObj.editor.obj.select();
				}
			}
			return true;
		});
	}
	if(dhtmlXGridCoulmnColorArray.length > 0){
		var strDhtmlXGridCoulmnColor = dhtmlXGridCoulmnColorArray.join(",");
		//console.log(strDhtmlXGridCoulmnColor);
		dhtmlXGridObj.setColumnColor(strDhtmlXGridCoulmnColor);
	}

	var onKeyPressed = function(code,ctrl,shift){
		if(code==67&&ctrl){
			if (!this._selectionArea) {
				return;
			}
			this.setCSVDelimiter("\t");
			this.copyBlockToClipboard()
		}
		/* 붙여넣기 기능 - Risk로 인하여 Disable 처리 */
		/*if(code==86&&ctrl){
			this.setCSVDelimiter("\t");
			this.pasteBlockFromClipboard();
		}*/
		return true;
	}

	dhtmlXGridObj.enableBlockSelection();   
	dhtmlXGridObj.attachEvent("onKeyPress",onKeyPressed);
	if(dhtmlXGridObj._fake){
		dhtmlXGridObj._fake.enableBlockSelection();
		dhtmlXGridObj._fake.attachEvent("onKeyPress",onKeyPressed);
	}
}

  /** 
   * Description 
   * @function initGridDataColumns
   * @function_Description DhtmlXDataProcessor CUD에 사용할 Column 세팅, Column 세팅에서 isDataColumn가 false인 경우 변경되어도 Updated 처리가 안됨
   * @param dhtmlXGridObj (Object) / DhtmlXGrid Object
   * @author 김종훈
   */
  this.initGridDataColumns = function(dhtmlXGridObj){
    var dhtmlXGridColumnArray = dhtmlXGridObj.columnsMapArray;
    if(dhtmlXGridColumnArray == undefined || dhtmlXGridColumnArray == null || dhtmlXGridColumnArray.length == 0){
      return false;
    }
    var dhtmlXDataProcessor = dhtmlXGridObj.getDataProcessor();
    if(dhtmlXDataProcessor == undefined || dhtmlXDataProcessor == null){
      return false;
    }
    var dataColumnsArray = [];
    for(var i in dhtmlXGridColumnArray){
      var dhtmlXGridColumn = dhtmlXGridColumnArray[i];
      var isDataColumn = dhtmlXGridColumn.isDataColumn;   
      if(isDataColumn != undefined && isDataColumn != null && isDataColumn == false){
        dataColumnsArray.push(false);
      } else {
        dataColumnsArray.push(true);
      }
    }
    dhtmlXDataProcessor.setDataColumns(dataColumnsArray);
  }

  /** 
   * Description 
   * @function serializeDhtmlXGridData
   * @function_Description CUD에 사용할 데이터를 [{Key:Value}, {Key:Value}] 형태로 직렬화, CRUD에 따라 STATUS 세팅
   * @param dhtmlXGridObj (Object) / DhtmlXGrid Object
   * @param isSendAllData (boolean) / CUD 상태에 상관 없이 모든 데이터를 Parameter에 직렬화 여부 
   * @author 김종훈
   */
  this.serializeDhtmlXGridData = function(dhtmlXGridObj, isSendAllData, checkSendData){
    if(dhtmlXGridObj == undefined || dhtmlXGridObj == null){
      return null;
    }
    var dhtmlXDataProcessor = dhtmlXGridObj.getDataProcessor();
    if(dhtmlXDataProcessor == undefined || dhtmlXDataProcessor == null){
      return null;
    }
    var updatedRows = dhtmlXDataProcessor.updatedRows;
    
    if(isSendAllData){
      updatedRows = [];
      var rowCnt = dhtmlXGridObj.getRowsNum();
      for(var i = 0; i < rowCnt; i++){
        var rId = dhtmlXGridObj.getRowId(i);
        updatedRows.push(rId);
      }
    }else if(checkSendData){
      updatedRows = [];
      var checked = dhtmlXGridObj.getCheckedRows(1);

      updatedRows = checked.split(",");
    }else{
      if(updatedRows.length <= 0){
        return null;
      }
    }
    
    var serializedData = {};
    var statusArray=[];
    for(var i = 0; i < updatedRows.length ; i++){
      var rId = updatedRows[i];
      var tempStatus = dhtmlXDataProcessor.getState(rId);
      var status = "R";
      if(tempStatus == "inserted"){
        status = "C";
      } else if (tempStatus == "updated"){
        status = "U";
      } else if (tempStatus == "deleted") {
        status = "D";
      } 
      statusArray.push(status);
    }
    serializedData["CRUD"] = statusArray; 
    var gridColumnCount = dhtmlXGridObj.getColumnsNum();
    for(var i = 0; i < gridColumnCount; i++){
      var cId = dhtmlXGridObj.getColumnId(i);
      /* 데이터 컬럼이 아닌 경우 CUD에 사용하지 않음 */
      var isDataColumn = dhtmlXGridObj.columnsMapArray[i].isDataColumn;
      if(isDataColumn === false){
        continue;
      }
      
      var columnData = [];
      for(var j = 0; j < updatedRows.length; j++){
        var rId = updatedRows[j];
        var cellValue = dhtmlXGridObj.cells(rId, i).getValue();
        if(cellValue == undefined || cellValue == null){
          cellValue="";
        }
        columnData.push(cellValue);
      }
      serializedData[cId]=columnData;
    }
    return serializedData;
  }

  /** 
   * Description 
   * @function serializeDhtmlXGridHeader
   * @function_Description 
   * @param dhtmlXGridHeaderMapArray (Array) / DhtmlXGrid Object
   * @param gubn = 'ro' 면 ro 포함
   * @author 신기환
   */
  this.serializeDhtmlXGridHeader = function(dhtmlXGridHeaderMapArray,gubn){
    var serializedData = {};
    var cnt = dhtmlXGridHeaderMapArray.length;
    var arrId=[];
    var arrIsHidden=[];
    var arrType=[];
    var arrIsEssential=[];
    var arrLabel=[];

    for(var i = 0; i < cnt; i++){
      var id = dhtmlXGridHeaderMapArray[i].id;
      var isHidden = dhtmlXGridHeaderMapArray[i].isHidden === true ? true : false;
      var type =  dhtmlXGridHeaderMapArray[i].type;
      var label = dhtmlXGridHeaderMapArray[i].label;
      var text="";
            
      /* label 가공 */
      for(var j=0;j<label.length;j++){
        if(label[j].indexOf("#")>-1){continue;}
        else{ text=label[j];} 
      }
      type = type.toLowerCase();
      if(id!='' && isHidden==false 
        && (type.indexOf('ed') > -1
          || type.indexOf('edn') > -1
          || type.indexOf('combo') > -1
          || type.indexOf('dhxcalendara') > -1
          || (gubn && gubn == "ro" && (type == "ro" || type.indexOf("ron") > -1))
      ) && text!=''){
        arrId.push(id);
        arrIsHidden.push(isHidden);
        arrType.push(type);
        arrLabel.push(text);
      }
      else{continue;}
    }
    serializedData.id=arrId;
    serializedData.isHidden=arrIsHidden;
    serializedData.type=arrType;
    serializedData.label=arrLabel;
    return serializedData;
  }
  
  /** 
   * Description 
   * @function validDhtmlXGridEssentialData
   * @function_Description DhtmlXGrid 내 Essential(필수) Column 데이터 입력 여부 및 길이 유효성 검증
   * @param dhtmlXGridObj (Object) / DhtmlXGrid Object
   * @author 김종훈
   */
  this.validDhtmlXGridEssentialData = function(dhtmlXGridObj){
    var resultMap = { isError : false, errRowIdx : null, errColumnName : null, errMessage : null, errCode : null, errMessageParam : null};
    if(dhtmlXGridObj == undefined || dhtmlXGridObj == null){
      resultMap.isError = true;
      resultMap.errMessage = "error.common.unknownGridObject";
      resultMap.errCode = "-2001";
      return resultMap;
    }
    var columnsMapArray = dhtmlXGridObj.columnsMapArray;
    if(columnsMapArray == undefined || columnsMapArray == null){
      resultMap.isError = true;
      resultMap.errMessage = "error.common.unknownGridColumn";
      resultMap.errCode = "-2002";
      return resultMap;
    } 
    var dhtmlXDataProcessor = dhtmlXGridObj.getDataProcessor();
    if(dhtmlXDataProcessor == undefined || dhtmlXDataProcessor == null){
      resultMap.isError = true;
      resultMap.errMessage = "error.common.unknownGridDataProcessor";
      resultMap.errCode = "-2003";
      return resultMap;
    }
    var updatedRows = dhtmlXDataProcessor.updatedRows;  
    var colCount = columnsMapArray.length;
    var i = 0;
    var j = 0;    
    
    var isEssentialBeginDate = false;
    var isEssentialEndDate = false;
    
    for(i = 0; i < updatedRows.length; i++){    
      var rId = updatedRows[i];
      var status = dhtmlXDataProcessor.getState(rId);
      if(status == "deleted"){
        continue;
      }
      for(j = 0; j < colCount; j++){
        var isEssential = columnsMapArray[j].isEssential;
        var maxLength = columnsMapArray[j].maxLength;
        var alertMessage = "";
        var alertCode = "";
        if(isEssential != undefined && isEssential != null && isEssential == true){
          var id = columnsMapArray[j].id;
          if(id == "BEGIN_DATE"){
            isEssentialBeginDate = true;
          } else if(id == "END_DATE"){
            isEssentialEndDate = true;
          }
          
          var value = dhtmlXGridObj.cells(rId, j).getValue();       
          if(value == undefined || value == null || value == ""){
            alertMessage = "error.common.noEssentialGridData";
            alertCode = "-2004";
          }
        }
        
        if(maxLength != undefined && maxLength != null && !isNaN(maxLength)){
          maxLength = maxLength - 0;
          if(maxLength < 0){
            maxLength = 0;
          }
          var value = dhtmlXGridObj.cells(rId, j).getValue();
          if(value != undefined && value != null && value != "" && value.length > maxLength){
            alertMessage = "error.common.overMaxLengthGridData";
            alertCode = "-2005";
          }
        }
        
        if(alertMessage != ""){
          var rowIdx = dhtmlXGridObj.getRowIndex(rId);
          
          resultMap.isError = true;
          resultMap.errMessage = alertMessage;
          
          var columnName = null;          
          var columnLabel = columnsMapArray[j].label;
          if(typeof columnLabel === 'object' && $erp.isArray(columnLabel)){
            if(columnLabel.length > 1){
              columnName = columnLabel[1];
              if(columnName.indexOf("#") > -1){
                columnName = columnLabel[0];
              }           
            } else {
              columnName = columnLabel[0];
            }
          } else if(typeof columnLabel === 'string'){
            columnName=columnLabel;
          }
          
          resultMap.errCode = alertCode;
          if(alertCode == "-2004"){
            resultMap.errMessageParam = [(rowIdx+1), columnName];
          } else if (alertCode == "-2005"){
            resultMap.errMessageParam = [(rowIdx+1), columnName, maxLength];
          }
          resultMap.errRowIdx = (rowIdx + 1);
          resultMap.errColumnName = columnName;
          return resultMap;
        }
      }
      
      if(isEssentialBeginDate === true && isEssentialEndDate === true){
        var begin_date = dhtmlXGridObj.cells(rId, dhtmlXGridObj.getColIndexById("BEGIN_DATE")).getValue();
        var end_date = dhtmlXGridObj.cells(rId, dhtmlXGridObj.getColIndexById("END_DATE")).getValue();
        
        if(begin_date > end_date){
          var rowIdx = dhtmlXGridObj.getRowIndex(rId);
          
          resultMap.isError = true;
          resultMap.errMessage = "error.common.invalidBeginEndDateInGrid";
          resultMap.errCode = "-2006";
          resultMap.errRowIdx = (rowIdx + 1);
          resultMap.errMessageParam = [(rowIdx+1)];
          return resultMap;
        }
      }
      
    }
    
    return resultMap;
  }

  /** 
   * Description 
   * @function isArray
   * @function_Description Object의 Array 타입 여부 확인
   * @param obj (Object)
   * @author 김종훈
   */
  this.isArray = function(obj){
    return !!obj && Array === obj.constructor;
  }

  /** 
   * Description 
   * @function alertSuccessMesage
   * @function_Description 저장 완료 메시지 출력
   * @param callbackFn (Function) / 메시지 출력 후 실행할 Function
   * @param callbackFnParam (Object) / 메시지 출력 후 실행할 Function의 Parameter [{Key:Value}] 형태 사용
   * @author 김종훈
   */
  this.alertSuccessMesage = function(callbackFn, callbackFnParam){
    var param = null;
    if(callbackFn && callbackFnParam){
      param = $erp.makeMessageParam("info.common.saveSuccess", null, "info", true, null, callbackFn, callbackFnParam);
    } else if(callbackFn){
      param = $erp.makeMessageParam("info.common.saveSuccess", null, "info", true, null, callbackFn);
    } else {
      param = $erp.makeMessageParam("info.common.saveSuccess", null, "info", true);
    } 
    $erp.alertMessage(param);
  }


  /** 
   * Description 
   * @function alertDeleteMesage
   * @function_Description 삭제 완료 메시지 출력
   * @param callbackFn (Function) / 메시지 출력 후 실행할 Function
   * @param callbackFnParam (Object) / 메시지 출력 후 실행할 Function의 Parameter [{Key:Value}] 형태 사용
   * @author 박성호
   */
  this.alertDeleteMesage = function(callbackFn, callbackFnParam){
    var param = null;
    if(callbackFn && callbackFnParam){
      param = $erp.makeMessageParam("info.common.deleteSuccess", null, "info", true, null, callbackFn, callbackFnParam);
    } else if(callbackFn){
      param = $erp.makeMessageParam("info.common.deleteSuccess", null, "info", true, null, callbackFn);
    } else {
      param = $erp.makeMessageParam("info.common.deleteSuccess", null, "info", true);
    } 
    $erp.alertMessage(param);
  }

  /** 
   * Description 
   * @function getIdMapInElement
   * @function_Description 특정 Dom 하위 노드 ID 목록 가져오기
   * @param domObj (object) 
   * @param isOnlyFirstChildNode (boolean) / 바로 하위 노드까지만 확인 여부
   * @param idMap / 반환 및 재귀 함수를 위한 Id Map
   * @author 김종훈
   */
  this.getIdMapInElement = function(domObj, isOnlyFirstChildNode, idMap){
    if($erp.isEmpty(idMap)){
      idMap = {};
    } 
    if(domObj && domObj.childNodes){
      for(var i in domObj.childNodes){
        var child = domObj.childNodes[i];
        if(child.attributes && child.attributes.id && child.attributes.id.value){
          var id = child.attributes.id.value;
          idMap[id] = document.getElementById(id);      
        }
        if(child.childNodes && !(isOnlyFirstChildNode === true)){
          $erp.getIdMapInElement(child, isOnlyFirstChildNode, idMap);
        }
      }
    }
    
    return idMap;
  }

  /** 
   * Description 
   * @function bindDataValue
   * @function_Description 데이터 Map을 Dom에 데이터 바인딩
   * @param dataObject (object) / 
   * @param parentObj (object) / parentObj 하위 노드에 있는 것만 바인딩
   * @author 김종훈
   */
  this.bindDataValue = function(dataObject, parentObj){
    var idMap = null;
    if(!$erp.isEmpty(parentObj)){
      if(typeof parentObj === 'string'){
        parentObj = document.getElementById(parentObj);
      }     
      if(!$erp.isEmpty(parentObj)){
        idMap = $erp.getIdMapInElement(parentObj);
      }
    
      if(typeof dataObject === 'object' && !$erp.isArray(dataObject)){
        for(var i in dataObject){   
          var value = dataObject[i] == null ? "" : dataObject[i];
          var domId = 'txt' + i;          
          var obj = document.getElementById(domId);
        
          if(obj){
            var value = dataObject[i] == null ? "" : dataObject[i];
            if(obj.className && obj.className.indexOf("input_money") > -1){
              value = $erp.getMoneyFormat(value);
            }
            
            if(!$erp.isEmpty(idMap)){
              if(!$erp.isEmpty(idMap[domId])){
                obj.value = value;
              }
            } else {
              obj.value = value;
            }
            continue;
          }
          
          domId = 'lbl' + i;
          obj = document.getElementById(domId);
          if(obj){
            value = dataObject[i] == "" ? "\u00a0" : dataObject[i];
            if(!$erp.isEmpty(idMap)){
              if(!$erp.isEmpty(idMap[domId])){
                obj.textContent = value;
              }
            } else {
              obj.textContent = value;
            }
            continue;
          }
          
          domId = 'cmb' + i;          
          obj = $erp.getObjectFromId(domId);
          if(obj && obj.setComboValue){
            var isTarget = false;
            if(!$erp.isEmpty(idMap)){
              if(!$erp.isEmpty(idMap[domId])){
                isTarget = true;
              }
            } else {
              isTarget = true;
            }
            
            if(isTarget === true){
              if(dataObject[i]){
                obj.setComboValue(dataObject[i]);
              } else {
                obj.selectOption(0);
              }
            }
            continue;
          }
        }
      }
    }
    
    /*$erp.bindTextValue(dataObject, parentObj);
    $erp.bindCmbValue(dataObject, parentObj);*/
  }

  /** 
   * Description 
   * @function bindTextValue
   * @function_Description txt 이나 lbl 로 시작하는 Dom에 데이터 바인딩
   * @param dataObject (object) / 
   * @param parentObj (object) / parentObj 하위 노드에 있는 것만 바인딩
   * @author 김종훈
   */
  this.bindTextValue = function(dataObject, parentObj){
    var idMap = null;
    if(!$erp.isEmpty(parentObj)){
      if(typeof parentObj === 'string'){
        parentObj = document.getElementById(parentObj);
      }     
      if(!$erp.isEmpty(parentObj)){
        idMap = $erp.getIdMapInElement(parentObj);
      }
    
      if(typeof dataObject === 'object' && !$erp.isArray(dataObject)){
        for(var i in dataObject){     
          var value = dataObject[i] == null ? "" : dataObject[i];
          var domId = 'txt' + i;      
          var obj = document.getElementById(domId);
          if(obj){
            if(!$erp.isEmpty(idMap)){
              if(!$erp.isEmpty(idMap[domId])){
                obj.value = value;
              }
            } else {
              obj.value = value;
            }
          }
          
        }
      }
    }
  }

  /** 
   * Description 
   * @function bindCmbValue
   * @function_Description cmd로 시작하는 DhtmlXCombo에 데이터 바인딩
   * @param dataObject (object)
   * @param parentObj (object) / parentObj 하위 노드에 있는 것만 바인딩
   * @author 김종훈
   */
  this.bindCmbValue = function(dataObject, parentObj){
    var idMap = null;
    if(!$erp.isEmpty(parentObj)){
      if(typeof parentObj === 'string'){
        parentObj = document.getElementById(parentObj);
      }     
      if(!$erp.isEmpty(parentObj)){
        idMap = $erp.getIdMapInElement(parentObj);
      }   
    
      if(typeof dataObject === 'object' && !$erp.isArray(dataObject)){
        for(var i in dataObject){    
        	//alert(i);
          var domId = 'cmb' + i;      
          var obj = $erp.getObjectFromId(domId);
          if(obj && obj.setComboValue){
            var isTarget = false;
            if(!$erp.isEmpty(idMap)){
              if(!$erp.isEmpty(idMap[domId])){
                isTarget = true;
              }
            } else {
              isTarget = true;
            }
            
            if(isTarget === true){
              if(dataObject[i]){
                obj.setComboValue(dataObject[i]);
              } else {
                obj.selectOption(0);
              }
            }
          }
        }
      }
    }
  }

  /** 
   * Description 
   * @function clearDhtmlXCombo
   * @function_Description cmd로 시작하는 DhtmlXCombo값 초기화
   * @param dataObject (object)
   * @author 김종훈
   */
  this.clearDhtmlXCombo = function(dataObject){
    if(typeof dataObject === 'object' && !$erp.isArray(dataObject)){
      for(var i in dataObject){     
        var domId = 'cmb' + i;      
        var obj = $erp.getObjectFromId(domId);
        if(obj && obj.setComboValue){
          obj.selectOption(0);
        }
      }
    }
  }

  /** 
   * Description 
   * @function getObjectFromId
   * @function_Description 변수 이름을 통한 해당 Object 반환
   * @param domId (String)
   * @author 김종훈
   */
  this.getObjectFromId = function(varId){
    for(var prop in window){      
      if(prop == varId){
        return window[prop];
      }
    }
    return undefined;
  }

  /** 
   * Description 
   * @function clearInputInElement
   * @function_Description Dom Object 하위 노드 내 Input 및 TextArea 초기화
   * @param domObj (Object)
   * @param isOnlyFirstChildNode (boolean) / true인 경우 첫번째 하위 노드만 초기화
   * @author 김종훈
   */
  this.clearInputInElement = function(domObj, isOnlyFirstChildNode){
    if(domObj){
      if(typeof domObj === 'string'){
        domObj = document.getElementById(domObj);
      }
      
      if(domObj && domObj.childNodes){
        for(var i in domObj.childNodes){
          var child = domObj.childNodes[i];
          if(child){
            if(child.getAttribute){
              var id = child.getAttribute("id");
              if(!this.isEmpty(id)){
                var prefix = id.length >= 3 ? id.substring(0, 3) : id;                
                if(prefix == "txt"){
                  child.value = "";
                } else if(prefix == "cmb"){
                  var obj = this.getObjectFromId(id);
                  if(obj && obj.selectOption){
                    obj.selectOption(0);
                  }
                } else if(prefix == "chk"){
                  child.checked = false;
                } else if(prefix == "lbl"){
                  if(child.textContent){
                    child.textContent = "\u00a0";
                  }
                }
              }
              if(child.childNodes && !(isOnlyFirstChildNode===true)){
                $erp.clearInputInElement(child);
              }
            }
          }
        }
      }
    }
  }

  /** 
   * Description 
   * @function getElementEssentialEmpty
   * @function_Description Dom Object 하위 노드 내 Input 및 TextArea 중 input_essential 클래스 가진 Element에 값이 없으면 해당 Object Return
   * @param domObj (Object)
   * @author 김종훈
   */
  this.getElementEssentialEmpty = function(domObj){
    if(domObj){
      if(typeof domObj === 'string'){
        domObj = document.getElementById(domObj);
      }
    }
    
    if(domObj.childNodes){
      for(var i in domObj.childNodes){
        var child = domObj.childNodes[i];
        if(child){
          /*if(child.style && child.style.display && child.style.display === 'none'){
            continue;
          }*/
          if(child.tagName && (child.tagName.toLowerCase() == "input" || child.tagName.toLowerCase() == "textarea")){
            if(child.className && child.className.indexOf && child.className.indexOf("input_essential") > -1){
              if(!(child.value && child.value != null && child.value.length > 0)){
                return child;
              }
            }
          }
          if(child.tagName && (child.tagName.toLowerCase() == "div")){
            if(child.className && child.className.indexOf && child.className.indexOf("combo_essential") > -1){
              if(child.attributes && child.attributes.id && child.attributes.id && child.attributes.id.value){
                var id = child.attributes.id.value;
                var cmbObj = $erp.getObjectFromId(id);
                var value = cmbObj.getSelectedValue();
                if($erp.isEmpty(value)){
                  if(child && child.childNodes && child.childNodes[0].childNodes){
                    return child.childNodes[0].childNodes[0];
                  } else {
                    return child;
                  }
                }
              }
            }
            //vault
            else if(child.className && child.className.indexOf && child.className.indexOf("vault_essential") > -1){
              if(child.attributes && child.attributes.id && child.attributes.id && child.attributes.id.value){
                var id = child.attributes.id.value;
                var valObj = $erp.getObjectFromId(id);
                var value = valObj.list.n;
  
                if(Object.keys(value).length==0){
                  if(child && child.childNodes && child.childNodes[0].childNodes && child.childNodes[0].childNodes[0].childNodes){
                    return child.childNodes[0].childNodes[0].childNodes[0];
                  } else {
                    return child;
                  }
                }
              }
            }
          }         
          if(child.childNodes){
            var obj = $erp.getElementEssentialEmpty(child);
            if(obj != undefined){
              return obj;
            }
          }
        }
      }
    }
    return undefined;
  }

  /** 
   * Description 
   * @function isNumber
   * @function_Description 숫자 유효성 검사
   * @param value (String) 
   * @author 김종훈
   */
  this.isNumber = function(value){
    var regex = /^[0-9]$/g;
    if(regex.test(value)){
      value = value.replace(/,/g, "");
      return isNaN(value) ? false : true;
    } else { 
      return false; 
    }
  }

  /** 
   * Description 
   * @function isKeyOnlyNumber
   * @function_Description 키입력 숫자 유효성 검사
   * @param event (Object) / event Object 
   * @param type (String) / decimal 소수, date 날짜
   * @author 김종훈
   */
  this.isKeyOnlyNumber = function(e, type){
    var isValid = true;
    e = e || window.event;
    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13]) !== -1 ||
        // Allow: Ctrl+A, Command+A
       ((e.keyCode === 65 || e.keyCode === 97) && (e.ctrlKey === true || e.metaKey === true)) ||
       // Allow: Ctrl+C, Command+C
       ((e.keyCode === 67 || e.keyCode === 99) && (e.ctrlKey === true || e.metaKey === true)) || 
       // Allow: Ctrl+V, Command+V
       ((e.keyCode === 86 || e.keyCode === 11) && (e.ctrlKey === true || e.metaKey === true)) || 
        // Allow: home, end, left, right, down, up
       (e.keyCode >= 35 && e.keyCode <= 40) ||
       // NumberPad 0~9
       (e.keyCode >= 96 && e.keyCode <= 105) ||
       
       (type && type.toLowerCase() == 'decimal' && (e.keyCode === 110 || e.keyCode === 190)) ||
       
       (type && type.toLowerCase() == 'input_money_m' && (e.keyCode === 109)) ||
       
       (type && type.toLowerCase() == 'date' && (e.keyCode === 109 || e.keyCode === 189))
      ) {
      // var it happen, don't do anything
         isValid = true;
       } 
    else if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57))) { // Ensure that it is a number and stop the keypress
      isValid = false;
    }
    if(isValid == false){
      if (typeof (e.preventDefault) == 'function') e.preventDefault();
        if (typeof (e.stopPropagation) == 'function') e.stopPropagation();
        if (typeof (e.stopImmediatePropagation) == 'function') e.stopImmediatePropagation();
        e.cancelBubble = true;
        return false;
    }
  }

  /** 
   * Description 
   * @function onAllProgressDhtmlXLayout
   * @function_Description 대상 DhtmlXLayout 내 하위 Cell Loading 처리
   * @param dhtmlXLayout (Object) / DhtmlXLayoutObject
   * @author 김종훈
   */
  this.onAllProgressDhtmlXLayout = function(dhtmlXLayout){
    dhtmlXLayout.forEachItem(function(cell){
        cell.progressOn();
    });
  }

  /** 
   * Description 
   * @function offAllProgressDhtmlXLayout
   * @function_Description 대상 DhtmlXLayout 내 하위 Cell Loading 종료 처리
   * @param dhtmlXLayout (Object) / DhtmlXLayoutObject
   * @author 김종훈
   */
  this.offAllProgressDhtmlXLayout = function(dhtmlXLayout){
    dhtmlXLayout.forEachItem(function(cell){
        cell.progressOff();
    });
  }

  /** 
   * Description 
   * @function setEventResizeDhtmlXLayout
   * @function_Description DhtmlXLayout 모든 Cell Size 변경 시 이벤트 바인딩
   * @param dhtmlXLayout (Object) / DhtmlXLayoutObject
   * @param callback (Function) / CallBack Function
   * @author 김종훈
   */
  this.setEventResizeDhtmlXLayout = function(dhtmlXLayout, callback){
    dhtmlXLayout.attachEvent("onPanelResizeFinish", callback);
    dhtmlXLayout.attachEvent("onCollapse", callback);
    dhtmlXLayout.attachEvent("onExpand", callback); 
    dhtmlXLayout.attachEvent("onResizeFinish", callback);
  }

  /** 
   * Description 
   * @function getToday
   * @function_Description 현재 년월일 String으로 반환
   * @param separateText (String) / 년월일 구분자 예) "-" 일경우 2017-01-01, "." 일경우 2017.01.01, 없을 경우 20170101
   * @author 김종훈
   */
  this.getToday = function(separateText) {
      return $erp.getDateYMDFormat(new Date(), separateText);
  }
  
  /** 
   * Description 
   * @function getToday
   * @function_Description 현재 년월일 String으로 반환
   * @param separateText (String) / 년월일 구분자 예) "-" 일경우 2017-01-01, "." 일경우 2017.01.01, 없을 경우 20170101
   * @param cnt cnt 일 수 만큼 과거 일자를 가져온다.
   * @author 김종훈
   */
  this.getToday = function(separateText, cnt) {
    var rtnVal = '';
    if(cnt == undefined || cnt == null || cnt == '' || cnt == 0) {
      rtnVal = $erp.getDateYMDFormat(new Date(), separateText);   
    } else {
      var now = new Date();
      now.setDate(now.getDate() + cnt);
      rtnVal = $erp.getDateYMDFormat(now, separateText);
    }
    return rtnVal;
  }
  
  /** 
   * Description 
   * @function getDateYMDFormat
   * @function_Description Date를 년월일 형태 String으로 
   * @param date (Object, Date) / 일시
   * @param separateText (String) / 년월일 구분자 예) "-" 일경우 2017-01-01, "." 일경우 2017.01.01, 없을 경우 20170101
   * @author 김종훈
   */
  this.getDateYMDFormat = function(date, separateText) {
    if(separateText == undefined || separateText == null){
      separateText = "";
    }
      var oDateNow = date;
      var year = oDateNow.getFullYear();
      var month = oDateNow.getMonth() + 1;
      var day = oDateNow.getDate();

      if (month < 10) month = '0' + month;
      if (day < 10) day = '0' + day;
      var today = String(year) + separateText + String(month) + separateText + String(day);

      return today;
  }

  /** 
   * Description 
   * @function clearDhtmlXGrid
   * @function_Description DhtmlXGrid 초기화, 연결된 DhtmlXDataProcessor가 있을 경우 같이 초기화
   * @param dhtmlXGridObj (Object) / DhtmlXGridObject
   * @author 김종훈
   */
  this.clearDhtmlXGrid = function(dhtmlXGridObj){
    dhtmlXGridObj.clearAll(); 
    if(dhtmlXGridObj._HideSelection){
      dhtmlXGridObj._HideSelection();
    }
    var dhtmlXDataProcessor = dhtmlXGridObj.getDataProcessor();
    if(dhtmlXDataProcessor){
      $erp.clearDhtmlXDataProcessor(dhtmlXDataProcessor);
    }
    $erp.setDhtmlXGridFooterRowCount(dhtmlXGridObj);
  }

  /** 
   * Description 
   * @function clearDhtmlXDataProcessor
   * @function_Description DhtmlXProcessor 초기화
   * @param dhtmlXDataProcessorObj (Object) / DhtmlXDataProcessorObject
   * @author 김종훈
   */
  this.clearDhtmlXDataProcessor = function(dhtmlXDataProcessorObj){
    if(dhtmlXDataProcessorObj && dhtmlXDataProcessorObj.updatedRows){
      dhtmlXDataProcessorObj.updatedRows = [];
    }
  }

  /** 
   * Description 
   * @function setDhtmlXGridPopupCellValue
   * @function_Description DhtmlXGrid Popup 타입 Cell Text 및 Value 설정
   * @param dhtmlXGridPopupCell (Object) / DhtmlXGridCellObject
   * @author 김종훈
   */
  this.setDhtmlXGridPopupCellValue = function(dhtmlXGridPopupCell, text, value){
    if(dhtmlXGridPopupCell){
      dhtmlXGridPopupCell.setValue({"text" : text, "value" : value});
      var dhtmlXDataProcessor = dhtmlXGridPopupCell.grid.getDataProcessor();
      if(dhtmlXDataProcessor != undefined && dhtmlXDataProcessor != null){
        var rId = dhtmlXGridPopupCell.cell.parentNode.idd;
        dhtmlXDataProcessor.setUpdated(rId, true, "updated");
      }
    }
  }

  /** 
   * Description 
   * @function initDhtmlXPopupDom
   * @function_Description DOM Object에 연결시킨 DhtmlXGridPopup 초기화
   * @param dom (object, String) / DOM Object
   * @param infoText (String) / 팝업에 표시할 문구
   * @author 김종훈
   */
  this.initDhtmlXPopupDom = function(dom, infoText){
    var obj = dom;
    if(typeof dom === 'string'){
      obj = document.getElementById(dom);
    }
    if(infoText && infoText.length > 0){
      if(obj.focus){
        obj.focus();
      }
      if(obj.popObject && obj.popObject.hide){
        obj.popObject.hide();
      }
      obj.popObject = new dhtmlXPopup();
      obj.popObject.setSkin(ERP_POPUP_CURRENT_SKINS);
      obj.popObject.attachHTML(infoText);
      
      var x = window.dhx.absLeft(obj);
      var y = window.dhx.absTop(obj);
      var width = obj.offsetWidth;
      var height = obj.offsetHeight;      
      
      obj.popObject.show(x, y, width, height);      
      obj.popObject.attachEvent("onHide", function(){
        var fn = (function(obj){        
          return function(){    
            if(obj && obj.unload){
              obj.unload();
            }
          }
        })(this);
        setTimeout(fn, 100);
        return true;
      });
    }
  }

  /** 
   * Description 
   * @function isEmpty
   * @function_Description Object, String, Array가 현재 undefined or null or length가 0인 경우 true Return
   * @param obj (Object, String, Array...)
   * @author 김종훈
   */
  this.isEmpty = function(obj){
    if(obj == undefined || obj == null){
      return true;
    } else if(obj.length != undefined && obj.length != null){
      if(obj.length <= 0){
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  /** 
   * Description 
   * @function getDateFormat
   * @function_Description Date Format (yyyy-MM-dd) 에 맞추어 String 생성
   * @param d (String)
   * @author 김종훈
   */
  this.getDateFormat = function(d){
    //숫자만 입력되는 경우도 고려하여 재구성
    if(d && d.split){
      d = d.split('-').join('');
      // 8자 
      if(d.length == 8){
        return d.substring(0, 4) + '-' + d.substring(4, 6) + '-' + d.substring(6, 8);
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  /** 
   * Description 
   * @function isDateFormat
   * @function_Description Date Format (yyyy-MM-dd) 정규식 체크
   * @param d (String)
   * @author 김종훈
   */
  this.isDateFormat = function(d) {
    var df = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;
      return d.match(df);
  }

  /** 
   * Description 
   * @function isLeaf
   * @function_Description 년도로 윤년검사
   * @param year (Number)
   * @author 김종훈
   */
  this.isLeaf = function(year) {
      var leaf = false;

      if(year % 4 == 0) {
    leaf = true;
    if(year % 100 == 0) {
        leaf = false;
    }
    if(year % 400 == 0) {
        leaf = true;
    }
      }
      return leaf;
  }

  /** 
   * Description 
   * @function isDateValidate
   * @function_Description 사용 가능한 날짜인지 확인 (2016-12-33 처럼 사용 불가 날짜 검출) 
   * @param d (String) / 날짜 형태 (20000101, 2000-01-01 모두 확인 가능)
   * @author 김종훈
   */
  this.isDateValidate = function(d) {
    d = $erp.getDateFormat(d);
      // 포맷에 안맞으면 false리턴
      if(!$erp.isDateFormat(d)) {
        return false;
      }
      var month_day = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

      var dateToken = d.split('-');
      var year = Number(dateToken[0]);
      var month = Number(dateToken[1]);
      var day = Number(dateToken[2]);
      
      // 년도가 1900 미만이나 3000 이상이면 False
      if(year < 1900 || year >= 3000){
        return false;
      }
    
      // 날짜가 0이면 false
      if(day == 0) {
        return false;
      }

      var isValid = false;

      // 윤년일때
      if($erp.isLeaf(year)) {
    if(month == 2) {
        if(day <= month_day[month-1] + 1) {
      isValid = true;
        }
    } else {
        if(day <= month_day[month-1]) {
      isValid = true;
        }
    }
      } else {
    if(day <= month_day[month-1]) {
        isValid = true;
    }
      }

      return isValid;
  }

  /** 
   * Description 
   * @function serializeDom
   * @function_Description 특정 DOM 하위 노드를 검색하여 하위 노드 DOM들을 { key : value } 형태로 직렬화 (KEY는 NAME 기반이며 NAME이 여러개 인 경우 Value를 Array로 가지게 됨)
   * @param domObj (Object) / DOM Object;
   * @param isOnlyId (boolean) / name 사용안하고 무조건 id로
   * @param serializedData (Object) / 재귀 함수용
   * @author 김종훈
   */
  this.serializeDom = function(domObj, isOnlyId, serializedData){ 
    if($erp.isEmpty(serializedData)){
      serializedData = {};
    }
    
    if(!$erp.isEmpty(domObj)){
      if(typeof domObj === 'string'){
        domObj = document.getElementById(domObj);
      }     
    }
    
    if(domObj && domObj.childNodes){
      for(var i in domObj.childNodes){
        var child = domObj.childNodes[i];
        if(child){
          if(child.attributes && child.attributes.id && child.attributes.id && child.attributes.id.value){
            var isTarget = true;
            var id = child.attributes.id.value;
            var name = child.attributes.name;
            if(isOnlyId !== true && name && name.value && !$erp.isEmpty(name.value)){
              name = name.value;
            } else {
              name = id;
            }
            var value = "";
            // 공통 Element가 추가 되는 경우 여기도 추가
            // 일반 input text 혹은 textarea          
            var prefix = id.length >= 3 ? id.substring(0, 3) : id;
            if(prefix == "txt"){
              if(document.getElementById(id).value){              
                value = document.getElementById(id).value;
              }
            } else if(prefix == "cmb"){
              var cmbObj = $erp.getObjectFromId(id);
              value = cmbObj.getSelectedValue();
            } else if(prefix == "chk"){
              value = document.getElementById(id).checked;
            } else {
              isTarget = false;
            }
            if(isTarget === true){
              if($erp.isEmpty(value)){
                value = "";
              }
              /* Money 형 쉼표 제거 */
              if(child.className & child.className.indexOf("input_money") > - 1){
                value = value.replace(/,/g, "");
              }             
              if(serializedData[name] != undefined && serializedData[name] != null){
                var tmpValue = serializedData[name];
                if($erp.isArray(tmpValue)){
                  tmpValue.push(value);
                } else {
                  var tmpArray = [];
                  tmpArray.push(tmpValue);
                  tmpArray.push(value);
                  serializedData[name] = tmpArray;
                }
              } else {
                serializedData[name] = value;
              }
            }
          }
          if(child.childNodes){
            $erp.serializeDom(child, isOnlyId, serializedData);
          }
        }
      }
    }
    
    return serializedData;
  }

  /** 
   * Description 
   * @function attachDhtmlXGridFooterPaging
   * @function_Description DhtmlXGrid의 Footer에 Paging 기능 연결
   * @param dhtmlXGridObj (Object) / dhtmlXGridObject
   * @param pagingSize (Number) / Page 당 Row Count
   * @author 김종훈
   */
  this.attachDhtmlXGridFooterPaging = function(dhtmlXGridObj, pagingSize){
    if(pagingSize && !isNaN(pagingSize)){
      /* Number 화 */
      pagingSize = pagingSize-0;
    } else {
      pagingSize = 50;
    }
    
    if(dhtmlXGridObj){
      var dhtmlXGridObjBox = dhtmlXGridObj.globalBox;
      if($erp.isEmpty(dhtmlXGridObjBox)){
        dhtmlXGridObjBox = dhtmlXGridObj.entBox;
      }
      var dhtmlXGridObjId = dhtmlXGridObjBox.id;
      if(!$erp.isEmpty(dhtmlXGridObjId)){
        var divFooterWrapperId = dhtmlXGridObjId + "_footer_paging_wrapper";
        var spanFooterId = dhtmlXGridObjId.replace("div", "span") + "_footer_paging_box";     
        var footerTag = "<div id='" + divFooterWrapperId + "' class='div_grid_footer_paging_wrapper'><span id='" + spanFooterId + "' >&nbsp;</span></div>";
        var colCount = dhtmlXGridObj.getColumnsNum();
        if(colCount > 1){
          for(var i = 0 ; i < colCount-1; i++){
            footerTag += ",#cspan";
          } 
        }
        dhtmlXGridObj.attachFooter(footerTag, ["text-align:left"]);
        dhtmlXGridObj.enablePaging(true, pagingSize, 5, spanFooterId, true);
        dhtmlXGridObj.setPagingSkin("system");
      }
      dhtmlXGridObj.setSizes();
    }
  }
  
  /** 
   * Description 
   * @function attachDhtmlXGridFooterRowCount
   * @function_Description DhtmlXGrid의 Footer에 Row Count 표기용 Table 연결
   * @param dhtmlXGridObj (Object) / dhtmlXGridObject
   * @param text (String) / 좌측 행 갯수 안내 문구
   * @author 김종훈
   */
  this.attachDhtmlXGridFooterRowCount = function(dhtmlXGridObj, text){
    if(dhtmlXGridObj){
      var dhtmlXGridObjBox = dhtmlXGridObj.globalBox;
      if($erp.isEmpty(dhtmlXGridObjBox)){
        dhtmlXGridObjBox = dhtmlXGridObj.entBox;
      }
      var dhtmlXGridObjId = dhtmlXGridObjBox.id;
      if(!$erp.isEmpty(dhtmlXGridObjId)){
        var divFooterWrapperId = dhtmlXGridObjId + "_footer_wrapper";
        var spanFooterId = dhtmlXGridObjId.replace("div", "span") + "_footer_row_count";      
        var footerTag = "<div id='" + divFooterWrapperId + "' class='div_grid_footer_wrapper'>" + text + "<span id='" + spanFooterId + "' class='span_grid_footer_row_count'>0</span></div>";
              
        var colCount = dhtmlXGridObj.getColumnsNum();
        if(colCount > 1){
          for(var i = 0 ; i < colCount-1; i++){
            footerTag += ",#cspan";
          } 
        }
        dhtmlXGridObj.attachFooter(footerTag, ["text-align:left"]);
      }
      dhtmlXGridObj.setSizes();
    }
  }

  /** 
   * Description 
   * @function setDhtmlXGridFooterRowCount
   * @function_Description DhtmlXGrid의 Footer에 Row Count 표기
   * @param dhtmlXGridObj (Object) / dhtmlXGridObject
   * @author 김종훈
   */
  this.setDhtmlXGridFooterRowCount = function(dhtmlXGridObj){
    if(dhtmlXGridObj){
      var dhtmlXGridBox = dhtmlXGridObj.globalBox;
      if($erp.isEmpty(dhtmlXGridBox)){
        dhtmlXGridBox = dhtmlXGridObj.entBox;
      }
      var dhtmlXGridId = dhtmlXGridBox.id;
      if(!$erp.isEmpty(dhtmlXGridId)){
        var spanFooterId = dhtmlXGridId.replace("div", "span") + "_footer_row_count";   
        var spanFooterRowCountObject = document.getElementById(spanFooterId);
        if(!$erp.isEmpty(spanFooterRowCountObject)){
          var rowCount = 0;
          if(dhtmlXGridObj.getRowIndex("NoDataPrintRow")){
            rowCount = dhtmlXGridObj.getRowsNum();
          }
          spanFooterRowCountObject.innerHTML = rowCount
        }
      }
    }
  }
  
  /** 
   * Description 
   * @function addDhtmlXGridNoDataPrintRow
   * @function_Description 조회된 내역 없다는 메시지 표시
   * @param dhtmlXGridObj (Object) / dhtmlXGridObject
   * @author 김종훈
   */
  this.addDhtmlXGridNoDataPrintRow = function(dhtmlXGridObj, message){
    if(dhtmlXGridObj){
      dhtmlXGridObj.enableColSpan(true);
      var NoDataPrintRowId = "NoDataPrintRow";
      dhtmlXGridObj.addRow(NoDataPrintRowId, []);
      
      if(dhtmlXGridObj._fake){
        dhtmlXGridObj._fake.enableColSpan(true);
        message = "<div class='div_grid_no_data_message_split'>" + message + "</div>"
        
        var splitIndex = dhtmlXGridObj._fake.getColumnCount();
        
        var firstIndex = -1;
        for(var i = 0; i < splitIndex; i++ ){
          if(dhtmlXGridObj.isColumnHidden(i) === true){
            continue;
          } else {
            firstIndex = i;           
            break;
          }
        }
        
        if(firstIndex > -1){
          dhtmlXGridObj.setCellExcellType(NoDataPrintRowId, firstIndex, "ro");
          dhtmlXGridObj._fake.setColspan(NoDataPrintRowId, firstIndex, splitIndex);
        }
        
        firstIndex = -1;
        for(var i = splitIndex; i < dhtmlXGridObj.getColumnCount(); i++ ){
          if(dhtmlXGridObj.isColumnHidden(i) === true){
            continue;
          } else {
            firstIndex = i;         
            break;
          }
        }
        if(firstIndex > -1){
          dhtmlXGridObj.setCellExcellType(NoDataPrintRowId, firstIndex, "ro");
          dhtmlXGridObj.setColspan(NoDataPrintRowId, firstIndex, dhtmlXGridObj.getColumnsNum()-splitIndex);
          dhtmlXGridObj.cells(NoDataPrintRowId, firstIndex).cell.innerHTML = message;
        }
      } else {
        var paddingLeft = 120;
        var objBoxWidth = null;
        var hdrWidth = null;
        
        if(dhtmlXGridObj.objBox && dhtmlXGridObj.objBox.clientWidth && !isNaN(dhtmlXGridObj.objBox.clientWidth)){
          objBoxWidth = dhtmlXGridObj.objBox.clientWidth;
        }   
        if(dhtmlXGridObj.hdr && dhtmlXGridObj.hdr.clientWidth && !isNaN(dhtmlXGridObj.hdr.clientWidth)){
          hdrWidth = dhtmlXGridObj.hdr.clientWidth;
        } 
        if(objBoxWidth && hdrWidth){
          if(hdrWidth < objBoxWidth){
            paddingLeft = hdrWidth;
          } else {
            paddingLeft = objBoxWidth;
          }
        } else if(objBoxWidth){
          paddingLeft = objBoxWidth;
        } else if(hdrWidth){
          paddingLeft = hdrWidth;
        }
                
        paddingLeft = Math.floor(paddingLeft*0.4);
        
        message = "<div class='div_grid_no_data_message_no_split' style='padding-left: "+ paddingLeft + "px'>" + message + "</div>"
        
        var firstIndex = -1;
        for(var i = 0; i < dhtmlXGridObj.getColumnsNum(); i++ ){
          if(dhtmlXGridObj.isColumnHidden(i) === true){
            continue;
          } else {
            firstIndex = i;
            break;
          }
        }
        if(firstIndex > -1){
          dhtmlXGridObj.setCellExcellType(NoDataPrintRowId, firstIndex, "ro");
          dhtmlXGridObj.setColspan(NoDataPrintRowId, firstIndex, dhtmlXGridObj.getColumnsNum()-firstIndex);   
          dhtmlXGridObj.cells(NoDataPrintRowId, firstIndex).cell.innerHTML = message;
        }       
      }     
      if(dhtmlXGridObj.getDataProcessor()){
        var dhtmlXDataProcessor = dhtmlXGridObj.getDataProcessor();
        dhtmlXDataProcessor.updatedRows = [];       
      }     
      dhtmlXGridObj.selectRow(dhtmlXGridObj.getRowIndex(NoDataPrintRowId));
    }
  }
  
  /** 
   * Description 
   * @function getMoneyFormat
   * @function_Description Number 타입을 Money Format String 으로 변환
   * @param value (Number)
   * @author 김종훈
   */
  this.getMoneyFormat = function(value){
    var x, n;
    if(value && !isNaN(value)){
      value = Math.floor(value-0);      
      var re = '\\d(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\.' : '$') + ')';
        return value.toFixed(Math.max(0, ~~n)).replace(new RegExp(re, 'g'), '$&,');
    } else {
      return value;
    }
  }
  
  /** 
   * Description 
   * @function getDhtmlXVault
   * @function_Description DhtmlXVault 객체 생성함수
   * @param id (String)
   * @param url (String) / 호출 URL 
   * @author 신기환
   */
  this.getDhtmlXVault = function(id,url,num,params,gubn){
    var tmpObj=null;
    if(gubn!== undefined && gubn === 'upload'){
      tmpObj=new dhtmlXVaultObject({
        container :  id
        , uploadUrl : url
        , swfPath: ERP_VAULT_CURRENT_PATH + "/dhxvault.swf"
        , swfUrl : url
        , slXap : ERP_VAULT_CURRENT_PATH + "/dhxvault.xap"
        , slUrl:  url
        , "buttonUpload":false // html container for vault
        , "buttonClear":true
        , "uploadParam" : params
      });
    }
    else{
      tmpObj=new dhtmlXVaultObject({
        container :  id
        , uploadUrl : url
        , swfPath: ERP_VAULT_CURRENT_PATH + "/dhxvault.swf"
        , swfUrl : url
        , slXap : ERP_VAULT_CURRENT_PATH + "/dhxvault.xap"
        , slUrl:  url
        , "buttonUpload":true // html container for vault
        , "buttonClear":true
        , "uploadParam" : params
      });
    }
    
    
    tmpObj.setStrings({
      done : "전송완료"
      , error : "전송실패"
      , btnAdd : "파일찾기"
      , btnUpload : "업로드"
      , btnClean : "초기화"
      , btnCancel : "전송취소"
    });
    
    
    //myVault.btnUpload = true;
    tmpObj.setAutoStart(false);
    if(num != undefined && num !=null && num !='') tmpObj.setFilesLimit(num);

    return tmpObj;
  }
  
  /** 
   * Description 
   * @function isBizrNoValidate
   * @function_Description 사업자등록번호 유효성 검사
   * @param bizID (String) / 사업자등록번호
   * @author 김종훈
   */
  this.isBizrNoValidate = function(bizID){
    // bizID는 숫자만 10자리로 해서 문자열로 넘긴다. 
    var checkID = new Array(1, 3, 7, 1, 3, 7, 1, 3, 5, 1); 
    var tmpBizID, i, chkSum=0, c2, remander; 
    bizID = bizID.replace(/-/gi,''); 
    for (i=0; i<=7; i++) {
      chkSum += checkID[i] * bizID.charAt(i); 
    }
    c2 = "0" + (checkID[8] * bizID.charAt(8)); 
    c2 = c2.substring(c2.length - 2, c2.length); 
    chkSum += Math.floor(c2.charAt(0)) + Math.floor(c2.charAt(1)); 
    remander = (10 - (chkSum % 10)) % 10 ; 
    if (Math.floor(bizID.charAt(9)) == remander) {
      return true ; // OK! 
    } else {
      return false;
    }
  }
  
  /** 
   * Description 
   * @function getPostAddrMap
   * @function_Description 다음 우편번호, 주소 데이터를 가공하여 Map(Key : Value) 형태로 반환
   * @param daumPostAddrData (Object) / 다음 우편번호, 주소 데이터
   * @author 김종훈
   */
  this.getPostAddrMap = function(daumPostAddrData){
    var resultMap = {};
    // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

        // 각 주소의 노출 규칙에 따라 주소를 조합한다.
        // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
    var roadAddress = daumPostAddrData.roadAddress;
      var autoRoadAddress = daumPostAddrData.autoRoadAddress;
      var address = daumPostAddrData.address;
        var fullAddr = ''; // 최종 주소 변수
        if(!$erp.isEmpty(roadAddress)){
          fullAddr = roadAddress;
        }else if(!$erp.isEmpty(autoRoadAddress)){
          fullAddr = autoRoadAddress;
        }else if(!$erp.isEmpty(address)){
          fullAddr = address;
        }
        
        var extraAddr = ''; // 조합형 주소 변수

        //법정동명이 있을 경우 추가한다.
        if(daumPostAddrData.bname !== ''){
            extraAddr += daumPostAddrData.bname;
        }
        // 건물명이 있을 경우 추가한다.
        if(daumPostAddrData.buildingName !== ''){
            extraAddr += (extraAddr !== '' ? ', ' + daumPostAddrData.buildingName : daumPostAddrData.buildingName);
        }
        // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
        fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
        
        resultMap.old_zip = daumPostAddrData.postcode1 + '' + daumPostAddrData.postcode2;
        resultMap.old_addr = daumPostAddrData.jibunAddress;
        resultMap.new_zip = daumPostAddrData.zonecode;
        resultMap.new_addr = fullAddr;
        
        return resultMap;
  }
  
  /** 
   * Description 
   * @function setEssentialDom
   * @function_Description Dom Object에 Essential Class 부여 및 회수
   * @param domObj (Object) / Dom Object
   * @param isEssential (boolean) / Essential Class 부여 여부 (true 부여, false 회수)
   * @author 김종훈
   */
  this.setEssentialDom = function(domObj, isEssential){
    if(domObj){     
      if(typeof domObj === 'string'){
        domObj = document.getElementById(domObj);
      } 
      if($erp.isEmpty(isEssential)){
        isEssential = true;
      }
      
      if(domObj){
        if(domObj.attributes && domObj.attributes.id && domObj.attributes.id.value){
          var id = domObj.attributes.id.value;
          var prefix = id.length >= 3 ? id.substring(0, 3) : id;
          if(prefix == "txt"){
            if(domObj.tagName && (domObj.tagName.toLowerCase() == 'input' || domObj.tagName.toLowerCase() == 'textarea')){
              if(domObj.tagName.toLowerCase() == 'input'){
                if(domObj.attributes.type && domObj.attributes.type.value){
                  var type = domObj.attributes.type.value.toLowerCase();
                  if(type == 'text'){
                    if(isEssential){
                      if($erp.isEmpty(domObj.className) || domObj.className.indexOf("input_essential") < 0){
                        if(domObj.className.length > 0){
                          domObj.className += " input_essential";
                        } else {
                          domObj.className = "input_essential";
                        }
                      }
                    } else {
                      var className = domObj.className;
                      if(!$erp.isEmpty(className)){
                        className = className.replace(/ input_essential/g, '');
                        className = className.replace(/input_essential/g, '');
                        domObj.className = className;
                      }
                    }
                  }
                }
              } else if(domObj.tagName.toLowerCase() == 'textarea'){
                if(isEssential){
                  if($erp.isEmpty(domObj.className) || domObj.className.indexOf("input_essential") < 0){
                    if(domObj.className.length > 0){
                      domObj.className += " input_essential";
                    } else {
                      domObj.className = "input_essential";
                    }
                  }
                } else {
                  var className = domObj.className;
                  if(!$erp.isEmpty(className)){
                    className = className.replace(/ input_essential/g, '');
                    className = className.replace(/input_essential/g, '');
                    domObj.className = className;
                  }
                }
              }
            }
          } else if(prefix == "cmb"){
            if(domObj.tagName && (domObj.tagName.toLowerCase() == 'div')){
              if(isEssential){
                if($erp.isEmpty(domObj.className) || domObj.className.indexOf("combo_essential") < 0){
                  if(domObj.className.length > 0){
                    domObj.className += " combo_essential";
                  } else {
                    domObj.className = "combo_essential";
                  }
                }
              } else {
                var className = domObj.className;
                if(!$erp.isEmpty(className)){
                  className = className.replace(/ combo_essential/g, '');
                  className = className.replace(/combo_essential/g, '');
                  domObj.className = className;
                }
              }
            }
          }
        }
      }
    }
  }
  
  /** 
   * Description 
   * @function setReadOnlyDom
   * @function_Description Dom Object에 ReadOnly Class 부여 및 회수
   * @param domObj (Object) / Dom Object
   * @param isReadOnly (boolean) / ReadOnly Class 부여 여부 (true 부여, false 회수)
   * @author 김종훈
   */
  this.setReadOnlyDom = function(domObj, isReadOnly){
    if(domObj){     
      if(typeof domObj === 'string'){
        domObj = document.getElementById(domObj);
      } 
      if($erp.isEmpty(isReadOnly)){
        isReadOnly = true;
      }
      
      if(domObj){
        if(domObj.attributes && domObj.attributes.id && domObj.attributes.id.value){
          var id = domObj.attributes.id.value;
          var prefix = id.length >= 3 ? id.substring(0, 3) : id;
          if(prefix == "txt"){
            if(domObj.tagName && (domObj.tagName.toLowerCase() == 'input' || domObj.tagName.toLowerCase() == 'textarea')){
              if(domObj.tagName.toLowerCase() == 'input'){
                if(domObj.attributes.type && domObj.attributes.type.value){
                  var type = domObj.attributes.type.value.toLowerCase();
                  if(type == 'text'){
                    if(isReadOnly){
                      if($erp.isEmpty(domObj.className) || domObj.className.indexOf("input_readonly") < 0){
                        if(domObj.className.length > 0){
                          domObj.className += " input_readonly";
                        } else {
                          domObj.className = "input_readonly";
                        }
                      }
                      domObj.setAttribute("readonly", "readonly");
                      if(!$erp.isEmpty(domObj.className) && domObj.className.indexOf("input_calendar") > -1){
                        if(domObj.dhtmlXCalendar && domObj.dhtmlXCalendarImage){
                          domObj.dhtmlXCalendarImage.style.display = "none";
                        }
                      }
                    } else {
                      var className = domObj.className;
                      if(!$erp.isEmpty(className)){
                        className = className.replace(/ input_readonly/g, '');
                        className = className.replace(/input_readonly/g, '');
                        domObj.className = className;
                      }
                      domObj.removeAttribute("readonly");
                      if(!$erp.isEmpty(domObj.className) && domObj.className.indexOf("input_calendar") > -1){
                        if(domObj.dhtmlXCalendar && domObj.dhtmlXCalendarImage){
                          domObj.dhtmlXCalendarImage.style.display = "";
                        }
                      }
                    }
                  }
                }
              } else if(domObj.tagName.toLowerCase() == 'textarea'){
                if(isReadOnly){
                  if($erp.isEmpty(domObj.className) || domObj.className.indexOf("input_readonly") < 0){
                    if(domObj.className.length > 0){
                      domObj.className += " input_readonly";
                    } else {
                      domObj.className = "input_readonly";
                    }
                  }
                  domObj.setAttribute("readonly", "readonly");
                } else {
                  var className = domObj.className;
                  if(!$erp.isEmpty(className)){
                    className = className.replace(/ input_readonly/g, '');
                    className = className.replace(/input_readonly/g, '');
                    domObj.className = className;
                  }
                  domObj.removeAttribute("readonly");
                }
              }
            }
          } else if(prefix == "cmb"){           
            if(domObj.attributes && domObj.attributes.id && domObj.attributes.id.value){
              var domId = domObj.attributes.id.value;
              var obj = $erp.getObjectFromId(domId);
              if(obj){
                if(isReadOnly){
                  obj.disable();
                } else {
                  obj.enable();
                }
              }
            }
          }
        }
      }
    }
  }
  
  /** 
   * Description 
   * @function getErpPopupWindow
   * @function_Description 현재 사용 중인 ErpPopupWindow의 ContentWindow 가져오기
   * @author 김종훈
   */
  this.getErpPopupWindow = function(){
    if(erpPopupWindows 
        && ERP_WINDOWS_DEFAULT_ID 
        && erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID)){
      return erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID).getAttachedObject().contentWindow;
    }
  }
  
  /** 
   * Description 
   * @function loadScreen
   * @function_Description 유저가 해당 화면을 사용가능한지 Menu Tree에서 확인하고 사용가능하면 Load
   * @param menu_cd (String)
   * @param param (Object) / 추가 파라미터
   * @param isReload (boolean) / 이미 열린 화면에 대한 새로고침 여부
   * @author 김종훈
   */
  this.loadScreen = function(menu_cd, param, isReload){
    var isUsable = false;
    if(!$erp.isEmpty(menu_cd)){
      var menuTree;
      var parentWindow = parent;
      var tryCount = 0;
      while((menuTree == undefined || menuTree == null) && parentWindow && tryCount < 10){
        menuTree = parentWindow.erpMenuTree;
        if(menuTree == undefined || menuTree == null){
          parentWindow = parentWindow.parent;
        }
        tryCount++;
      }
      if(menuTree){
        isUsable = menuTree.getIndexById(menu_cd) == null ? false : true;
        if(isUsable === true){
          if($erp.isEmpty(isReload)){
            isReload = true;
          }
          parentWindow.loadScreen(menu_cd, param, isReload);
        }
      }
    }
    return isUsable;
  }

  /** 
   * Description 
   * @function getDhtmlXLayoutSeparator
   * @function_Description DhtmlXLayout 분할선 Object 가져오기
   * @param dhtmlXLayoutObject (Object) / DhtmlXLayoutObject
   * @param index (Number) / 분할선 Index
   * @author 김종훈
   */
  this.getDhtmlXLayoutSeparator = function(dhtmlXLayoutObject, index){  
    if(dhtmlXLayoutObject && dhtmlXLayoutObject.setSeparatorSize){
      var obj = dhtmlXLayoutObject;
      if (typeof(index) == "number") {
        var s = $erp.getDhtmlXLayoutSeparator(obj, {index: index, current: -1});
        if (s.sep != null) return s.sep;
        return;
      }
      // seq: a->sep->b
      for (var a in obj.cdata) {
        if (obj.cdata[a].dataType == "layout" && obj.cdata[a].dataNested == true && obj.cdata[a].dataObj != null) {
          index = $erp.getDhtmlXLayoutSeparator(obj.cdata[a].dataObj, index);
          if (index.sep != null) return index;
        }
        if (a == "a" && obj.sep != null) {
          index.current++;
          if (index.index == index.current) return {sep: obj.sep};
        }
      }
      return index;
    }
  }
  
  /** 
   * Description 
   * @function isPhoneNumber
   * @function_Description 전화번호 규칙 검증
   * @param phoneNumber (String) / phoneNumber
   * @author 김종훈
   */
  this.isPhoneNumber = function(phoneNumber){
    phoneNumber = phoneNumber.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
    var pattern = /^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$/;
    var pattern2 = /^[1][5][0-9]{2}-[0-9]{4}$/; 
    if(!pattern.test(phoneNumber) && !pattern2.test(phoneNumber)) { 
      return false;
    }
    return true;
  }
  
  /** 
   * Description 
   * @function getPhoneNumberHyphen
   * @function_Description 전화번호 규칙에 따른 Hyphen 처리
   * @param phoneNumber (String) / phoneNumber
   * @author 김종훈
   */
  this.getPhoneNumberHyphen = function(phoneNumber){  
    if(!$erp.isEmpty(phoneNumber)){
      var returnValue = phoneNumber.replace(/-/gi, "");
      var num1 = returnValue.substr(0, 3);
      if(num1.substr(0, 2) == "01"
        || num1 == "051" || num1 == "053" || num1 == "032"
        || num1 == "062" || num1 == "042" || num1 == "052"
        || num1 == "044" || num1 == "031" || num1 == "033"
        || num1 == "043" || num1 == "041"   || num1 == "063"
        || num1 == "061" || num1 == "054"   || num1 == "055"
        || num1 == "064" || num1 == "070"){
        if(returnValue.length == 11){
          returnValue = returnValue.substr(0, 3) + '-' + returnValue.substr(3, 4) + '-' + returnValue.substr(7, 4);
        } else if (returnValue.length == 10){
          returnValue = returnValue.substr(0, 3) + '-' + returnValue.substr(3, 3) + '-' + returnValue.substr(6, 4);
        }
      } else if (num1.substr(0, 2) == "02"){
        if(returnValue.length == 10){
          returnValue = returnValue.substr(0, 2) + '-' + returnValue.substr(2, 4) + '-' + returnValue.substr(6, 4);
        } else if (returnValue.length == 9){
          returnValue = returnValue.substr(0, 2) + '-' + returnValue.substr(2, 3) + '-' + returnValue.substr(5, 4);
        }
      } else {
        if(returnValue.length == 8){
          returnValue = returnValue.substr(0, 4) + '-' + returnValue.substr(4, 4);
        } else {
          returnValue = phoneNumber;
        }
      }
      return returnValue;
    } else {
      return "";
    }
  }
  
  /** 
   * Description 
   * @function getActiveTabObject
   * @function_Description 현재 활성화 된 Index Tab (contentsTabBar) 의 Object 반환
   * @author 김종훈
   */
  this.getActiveIndexTabObject = function(){
    var indexTabBar;
    var parentWindow = parent;
    var tryCount = 0;
    while((indexTabBar == undefined || indexTabBar == null) && parentWindow && tryCount < 10){
      indexTabBar = parentWindow.contentsTabBar;
      if(indexTabBar == undefined || indexTabBar == null){
        parentWindow = parentWindow.parent;
      }
      tryCount++;
    }   
    if(indexTabBar && indexTabBar.getActiveTab && indexTabBar.getActiveTab()){
      return indexTabBar.tabs(indexTabBar.getActiveTab());
    }
  }
  
  /** 
   * Description 
   * @function getActiveTabObject
   * @function_Description 현재 활성화 된 Index Tab (contentsTabBar) 의 tabId 반환
   * @author 유가영
   */
  this.getActiveIndexTabId = function(){
    var indexTabBar;
    var parentWindow = parent;
    var tryCount = 0;
    while((indexTabBar == undefined || indexTabBar == null) && parentWindow && tryCount < 10){
      indexTabBar = parentWindow.contentsTabBar;
      if(indexTabBar == undefined || indexTabBar == null){
        parentWindow = parentWindow.parent;
      }
      tryCount++;
    }   
    if(indexTabBar && indexTabBar.getActiveTab && indexTabBar.getActiveTab()){
      return indexTabBar.getActiveTab();
    }
  }
  
  /** 
   * Description 
   * @function getWindowFromDom
   * @function_Description Dom Object의 Window 객체 반환
   * @param domObject (Object) : Document Object
   * @author 김종훈
   */
  this.getWindowFromDom = function(domObject){
    var doc = domObject.ownerDocument
    var win = doc.defaultView || doc.parentWindow;
    return win;
  }

  /** Description
   * @function modifyTheEndDate
   * @function_Description 주간별 기준일자에 맞는 마지막일자 수정해주는 함수 
   * @param [id1 시작날짜 id][id2 종료날짜 id][gubn - 기준요일 월1 화2 수3 목4 금5 토6 일0][type - true 기준일로부터 딱 일주일 셋팅  false - 범위 무제한]
   * @return 수정된날짜 YYYYMMDD
   * @author 신기환
   */
  this.modifyTheEndDate=function(id1,id2,gubn,type){
    var result='';
    var day=2;
    var firstDay='';
    var secondDay='';
    var startArr=[];
    var endArr=[];
    var nextDay='';
    var tmp='';
    //1. 첫번째 날짜 기준요일에 맞게 보정
    startArr=$erp.findNextnFirstDay($('#'+id1).val(),Number(gubn));
    firstDay=(startArr[0]+"-"+startArr[1]+"-"+startArr[2]);
    day=$erp.checkPeriod2(firstDay,$('#'+id2).val());

    //기준일로부터 범위 무제한
    if(!type){
      //일수차이가 일주일보다 작다면
      if(day.replace(/day/gi,"")<6){
        nextDay=new Date(startArr[0],startArr[1]-1,startArr[2]);
        nextDay.setDate((nextDay.getDate()+6));
        //alert(day+"/"+firstDay+"/"+nextDay);
        result=$erp.formatDate(nextDay);
      }
      else{
        if(day.replace(/day/gi,"")%7==6){
          result=$('#endDt').val().replace(/-/gi,"");
        }
        else{
          if(Number(gubn)==0){ endArr=$erp.findNextnFirstDay($('#'+id2).val(),Number(6)); }
          else{ endArr=$erp.findNextnFirstDay($('#'+id2).val(),Number(gubn)-1); }
          
          result=(endArr[0]+""+endArr[1]+""+endArr[2]);
          //console.log(firstDay+"~"+result);
        }
      }
    }
    //기준일로부터 딱 일주일 셋팅
    else{
      nextDay=new Date(startArr[0],startArr[1]-1,startArr[2]);
      $('#'+id1).val($erp.formatDate(nextDay));
      nextDay.setDate((nextDay.getDate()+4));
      //alert(day+"/"+firstDay+"/"+nextDay);
      result=$erp.formatDate(nextDay);
      
      $('#'+id2).val(result);
    }
    return result;
  }
  
  /** Description
   * @function makeDynamicHeaderGubn
   * @function_Description 날짜 동적그리드 헤더 배열 생성함수
   * @param Id1 [시작날짜 Id]
       * Id2 [종료날짜 Id]
       * gubn 구분값 [day 일자별] [week 주간별] [hours 시간대별] [period 기간별] [pay 결제구분별]
       * day 주단위 선택시 주간 기준 요일 Number [0 sun] [1 mon] [2 tue] [3 wed] [4 thu] [5 fri] [6 sat]
       *     시간단위선택시 시간기준 [h - 시간] [30m - 30분단위] [15m - 15분단위]
       * type [true,false]기준일자 기준으로 한주만 셋팅 여부
   * @return [배열]
   * @author 신기환
   */
  this.makeDynamicHeaderGubn=function(Id1,Id2,gubn,day,type){
    var result=[];
    var startDate=''; 
    var endDate='';

    startDate=($('#'+Id1).val()!=undefined && $('#'+Id1).val()!=null && $('#'+Id1).val()!='')?$('#'+Id1).val():'';
    endDate=($('#'+Id2).val()!=undefined && $('#'+Id2).val()!=null && $('#'+Id2).val()!='')?$('#'+Id2).val():'';
    if(startDate!='' && endDate!=''){
      var lastDay='';

      //일별, 주별 처리
      if(gubn=='day'){
        //1. 일수차 구하기
        var diffDay = $erp.checkPeriod(Id1,Id2);
        //alert(diffDay);
        if(diffDay!=2){
          try{ diffDay=Number(diffDay.replace('day',''));}
          catch(err){diffDay='';}

        }
        else{diffDay='';}
        //2. 일수차 정상 처리
        if(diffDay!=''){ result=$erp.dateHeader(startDate,endDate,diffDay,gubn,day);}
        //예외처리
        else{ return result;} 
      }
      
      else if (gubn=='week'){
        var startAr=[];
        startAr=$erp.findNextnFirstDay(startDate,day);
        startDate=startAr[0]+"-"+startAr[1]+"-"+startAr[2];
        //alert(startDate);
        endDate=$erp.modifyTheEndDate(Id1,Id2,day,type);
        //alert(endDate);
        //1. 일수차 구하기
        var diffDay = $erp.checkPeriod2(startDate,endDate);
        //alert(diffDay+"/"+gubn+"/"+day);
        if(diffDay!=2){
          try{ diffDay=Number(diffDay.replace('day',''));}
          catch(err){diffDay='';}
        }
        else{diffDay='';}
        //2. 일수차 정상 처리
        if(diffDay!=''){ result=$erp.dateHeader(startDate,endDate,diffDay,gubn,day,type);}
        //예외처리
        else{ return result;} 
      }
      
      //시간대별 처리
      else if(gubn=='hours'){
        if(day=='h') result=$erp.timeHeader('08','27','h');
        else if(day.indexOf('m')>-1) result=$erp.timeHeader('10','24','30m');
        //예외처리
        else{ return result;} 
        }
      //기간대별 처리
      else if(gubn=='period'){}
      //결제구분별 처리
      else if(gubn=='pay'){
        result=$erp.payHeader(gubn);
      }
    }
    //예외처리
    else{
      if(gubn=='pay'){
        result=$erp.payHeader(gubn);
      }
    }
    return result;
  }

  /** Description
   * @function findNextnFirstDay
   * @function_Description 입력날짜 이후 오는 첫번째 요일의 날짜 리턴
   * @param start 시작날짜 ['yyyy-mm-dd']
   *      day 주단위 선택시 주간 기준 요일 Number[0 sun] [1 mon] [2 tue] [3 wed] [4 thu] [5 fri] [6 sat]
   * @return [배열]
   * @author 신기환
   */
  this.findNextnFirstDay=function(start,day){
    var resultArr=[];
    var today='';

    resultArr=start.split('-');
    today = new Date(resultArr[0],resultArr[1]-1,resultArr[2]);
    
    //시작날짜와 기준요일간 차이  
    var diff= Number(day)-today.getDay();

    //같은주에 존재시
    if(diff>=0) today.setDate(today.getDate()+diff);
    //다음주로 넘어가야할때
    else today.setDate(today.getDate()+diff+7);
    
    resultArr[0]=today.getFullYear();
    resultArr[1]=$erp.addZero(today.getMonth()+1);
    resultArr[2]=$erp.addZero(today.getDate());
    
    return resultArr;
  }


  /** Description
   * @function dateHeader
   * @function_Description 두 날짜 차이 만큼 실제 날짜들 추출 하는 함수
   * @param start 시작날짜 ['yyyy-mm-dd']
   *      end 종료날짜 ['yyyy-mm-dd']
   *      diffDay 일수차 [number dd]
   *       gubn 구분 [day. 일단위][week. 주단위]
   *      day 주단위 선택시 주간 기준 요일 Number[0 sun] [1 mon] [2 tue] [3 wed] [4 thu] [5 fri] [6 sat]
   *      type [true,false]기준일자 기준으로 한주만 셋팅 여부
   * @return [배열][yyyy/mm/dd] 
   * @author 신기환
   */
  this.dateHeader=function(start,end,diffDay,gubn,day,type){
    var resultArr=[];
    var startArr=[];
    var endArr=[];
    
    //alert(start+"/"+end+"/"+diffDay+"/"+gubn);
    startArr=start.split('-');
    endArr=end.split('-');
    
    //yyyy-mm-dd or yyyy-mm 건만 처리
    if(startArr.length==2||startArr.length==3){
      //yyyy-mm 처리
      if(startArr.length==2) startArr.push('01');
      
      //일단위 처리
      if(gubn=='day'){
        var today= new Date(startArr[0],startArr[1]-1,startArr[2]);
        for(var i=0;i<=diffDay;i++){
          resultArr.push((today.getFullYear())+"/"+$erp.addZero((today.getMonth()+1))+"/"+$erp.addZero(today.getDate()));
          today.setDate(today.getDate()+1);
        }
      }
      //주간별 처리
      else if(gubn=='week'){
        var today='';
        var nextWeek='';
        var num=0;

        //기준요일 있는경우
        if(day!=undefined && day!=null && day!=''){
          startArr=$erp.findNextnFirstDay(start,day);
        }

        //기준요일 없는경우 예외처리
        else{}
        
        

        //console.log("=="+diffDay+"="+Math.floor(diffDay/7));
        if(!type){
          today= new Date(startArr[0],startArr[1]-1,startArr[2]);
          nextWeek= new Date(startArr[0],startArr[1]-1,startArr[2]);
          nextWeek.setDate(nextWeek.getDate()+4); // 주간단위로 설정
          //nextWeek.setDate(nextWeek.getDate()+6); //1주단위로 설정
          
          for(var i=0;i<Math.floor((diffDay+1)/7);i++){
            //console.log("next="+nextWeek.getFullYear()+"-"+addZero(nextWeek.getMonth()+1)+"-"+addZero(nextWeek.getDate())+"=end="+endArr[0]+"-"+endArr[1]+"-"+endArr[2]);
            num=$erp.checkPeriod2(nextWeek.getFullYear()+"-"+$erp.addZero(nextWeek.getMonth()+1)+"-"+$erp.addZero(nextWeek.getDate()),endArr[0]+"-"+endArr[1]+"-"+endArr[2]);
            //console.log("nextWeek="+nextWeek.getFullYear()+"-"+addZero(nextWeek.getMonth()+1)+"-"+addZero(nextWeek.getDate())+"//"+Number(num.replace(/day/gi,'')));
            if(num.indexOf('day')<=-1||Number(num.replace(/day/gi,''))<0) break;
            resultArr.push(today.getFullYear()+"."+$erp.addZero((today.getMonth()+1))+"."+$erp.addZero(today.getDate())+" ~ "+nextWeek.getFullYear()+"."+$erp.addZero(nextWeek.getMonth()+1)+"."+$erp.addZero(nextWeek.getDate())+"["+(i+1)+"주]");
            today.setDate(today.getDate()+7);
            nextWeek.setDate(nextWeek.getDate()+7);
          }
        }
        else{
          today= new Date(startArr[0],startArr[1]-1,startArr[2]-7);
          nextWeek= new Date(startArr[0],startArr[1]-1,startArr[2]-7);
          nextWeek.setDate(nextWeek.getDate()+4); // 주간단위로 설정
          //nextWeek.setDate(nextWeek.getDate()+6); //1주단위로 설정
          
          for(var i=0;i<2;i++){
            //console.log(Math.floor((diffDay+1)/4)+"/"+today);
            //console.log("next="+nextWeek.getFullYear()+"-"+addZero(nextWeek.getMonth()+1)+"-"+addZero(nextWeek.getDate())+"=end="+endArr[0]+"-"+endArr[1]+"-"+endArr[2]);
            num=$erp.checkPeriod2(today.getFullYear()+"-"+$erp.addZero(today.getMonth()+1)+"-"+$erp.addZero(today.getDate()),endArr[0]+"-"+endArr[1]+"-"+endArr[2]);
            //console.log("nextWeek="+nextWeek.getFullYear()+"-"+addZero(nextWeek.getMonth()+1)+"-"+addZero(nextWeek.getDate())+"//"+Number(num.replace(/day/gi,'')));
            if(num.indexOf('day')<=-1||Number(num.replace(/day/gi,''))<0) break;
            resultArr.push(today.getFullYear()+"."+$erp.addZero((today.getMonth()+1))+"."+$erp.addZero(today.getDate())+" ~ "+nextWeek.getFullYear()+"."+$erp.addZero(nextWeek.getMonth()+1)+"."+$erp.addZero(nextWeek.getDate())+"["+(i+1)+"주]");
            today.setDate(today.getDate()+7);
            nextWeek.setDate(nextWeek.getDate()+7);
          }
        }
      }
    }
    //예외처리
    else {  return resultArr;}
    return resultArr;
  }

  /** Description
   * @function dateHeader
   * @function_Description 날짜 포맷 변경 함수
   * @param date [날짜] 
   * @return [string][yyyy-mm-dd] 
   * @author 신기환
   */
  this.formatDate=function(date) {
      var mymonth = date.getMonth() + 1;
      var myweekday = date.getDate();
      return (date.getFullYear() + "-" + ((mymonth < 10) ? "0" : "") + mymonth + "-" + ((myweekday < 10) ? "0" : "") + myweekday);
  }
  
  /** Description
   * @function checkPeriod2
   * @function_Description 두 날짜간 일 시분초 차이 계싼 (일단위로 환산)
   * @param start: 시작날짜[string 'yyyy-mm-dd']
   *      end: 종료날짜[string 'yyyy-mm-dd']
   * @return [기타 스트링 = 실제 차이값] [number 2= 기타오류]
   * @author 신기환
   */
  this.checkPeriod2 =function(start,end){
    var result=0;
    var startTime = '';   
    var endTime  = '';    
    var tmpTime='';
    try{
      startTime=Number(start.replace(/-/gi,""))+"";
      endTime=Number(end.replace(/-/gi,""))+"";
      
      if(startTime.length==6){
        tmpTime='01000000';
      }
      else tmpTime='000000';

      startTime+=tmpTime;
      endTime+=tmpTime;
    }
    catch(err){
      result=2;
    }
    
    if(result!=2){
      //alert(startTime);
      // 시작일시 
       var startDate = new Date(parseInt(startTime.substring(0,4), 10),
                 parseInt(startTime.substring(4,6), 10)-1,
                 parseInt(startTime.substring(6,8), 10),
                 parseInt(startTime.substring(8,10), 10),
                 parseInt(startTime.substring(10,12), 10),
                 parseInt(startTime.substring(12,14), 10)
                );
                
       // 종료일시 
       var endDate   = new Date(parseInt(endTime.substring(0,4), 10),
                 parseInt(endTime.substring(4,6), 10)-1,
                 parseInt(endTime.substring(6,8), 10),
                 parseInt(endTime.substring(8,10), 10),
                 parseInt(endTime.substring(10,12), 10),
                 parseInt(endTime.substring(12,14), 10)
                );

       // 두 일자(startTime, endTime) 사이의 차이를 구한다.
       var dateGap = endDate.getTime() - startDate.getTime();
       var timeGap = new Date(0, 0, 0, 0, 0, 0, endDate - startDate); 
       
       // 두 일자(startTime, endTime) 사이의 간격을 "일-시간-분"으로 표시한다.
       var diffDay  = Math.floor(dateGap/(1000*60*60*24));    
       var diffHour = timeGap.getHours();       // 시간 
       var diffMin  = timeGap.getMinutes();      // 분
       var diffSec  = timeGap.getSeconds();      // 초
       var diffYear = Math.floor(diffDay/365);
       var diffMonth = Math.floor((diffDay-365*diffYear)/30);
       var stdDay = diffDay;
       diffDay = diffDay-365*diffYear-30*diffMonth;
       
       // 출력 : 샘플데이타의 경우 "273일 4시간 50분 10초"가 출력된다.
       //result=diffYear+" 년 "+diffMonth+" 개월 "+diffDay + "일 " + diffHour + "시간 " + diffMin + "분 "  + diffSec + "초 ";
       //console.log(result+"/timegap="+timeGap+"/dateGap="+dateGap+"/stdDay="+stdDay);
       result=stdDay+'day';
    }   
    return result;
  }

  this.converDateString =function (dt){ 
    return dt.getFullYear() + "-" + $erp.addZero(eval(dt.getMonth()+1)) + "-" + $erp.addZero(dt.getDate()); 
  } 

  this.converBeforeDateString =function (dt){ 
    return dt.getFullYear() + "-" + $erp.addZero(eval(dt.getMonth())) + "-" + $erp.addZero(dt.getDate()); 
  } 

  this.addZero=function (i){ 
    var rtn = i + 100; 
    return rtn.toString().substring(1,3); 
  }

  /** Description
   * @function makePeriodArr
   * @function_Description 날짜 동적그리드 헤더 배열 생성함수
   * @param start: 시작날짜[string 'yyyy-mm-dd']
    *     end: 종료날짜[string 'yyyy-mm-dd']
    *     gubn 구분값 [day 일자별] [week 주간별] [hours 시간대별][month 월별] [period 기간별] [pay 결제구분별]
    *     day 주단위 선택시 주간 기준 요일 Number [0 sun] [1 mon] [2 tue] [3 wed] [4 thu] [5 fri] [6 sat]
    *         시간단위선택시 시간기준 [h - 시간] [30m - 30분단위] [15m - 15분단위]
   * @return return [배열]
   * @author 신기환
   */
  this.makePeriodArr=function (start,end,gubn){   
    var resultArr=[];
    
    if(gubn=='month'||gubn=='monthInclude'){
      //1.일수차 계산
      var diffday = $erp.checkPeriod2(start,end);
    
      var realdiff =0;
      var lastDay='';
      //정상일수차 계산건
      if(diffday.indexOf('day')>-1){
        realdiff=Number(diffday.replace('day',""));

        if(gubn='monthInclude'){
          for(var i=0;i<=realdiff/30;i++){
            //1. 말일계산
            var newDt = new Date(start); 
            newDt.setMonth(newDt.getMonth() + 1); 
            newDt.setDate(0);
            lastDay=$erp.converDateString(newDt);
            
            //2. 현재말일과 비교
            if(Number($erp.checkPeriod2(lastDay,end).replace('day',''))>0){
              resultArr.push("["+start+"~"+lastDay+"]");
            }
            else{
              resultArr.push("["+start+"~"+end+"]");
            }
            
            var newDtt = new Date(start); 
            newDtt.setMonth(newDt.getMonth() + 1); 
            newDtt.setDate( 1); 
            start= $erp.converDateString(newDtt);
          }
        }
        else{
          for(var i=0;i<realdiff/30;i++){
            //1. 말일계산
            var newDt = new Date(start); 
            newDt.setMonth(newDt.getMonth() + 1); 
            newDt.setDate(0);
            lastDay=$erp.converDateString(newDt);
            
            //2. 현재말일과 비교
            if(Number($erp.checkPeriod2(lastDay,end).replace('day',''))>0){
              resultArr.push("["+start+"~"+lastDay+"]");
            }
            else{
              resultArr.push("["+start+"~"+end+"]");
            }
            
            var newDtt = new Date(start); 
            newDtt.setMonth(newDt.getMonth() + 1); 
            newDtt.setDate( 1); 
            start= $erp.converDateString(newDtt);
          }
        }
      }
      else{}    
    }
    return resultArr;
  }
  
  /** Description
   * @function closeAllMessage
   * @function_Description 모든 DhtmlXMessage 닫기
   * @author 김종훈
   */
  this.closeAllMessage = function(){
    $(".dhx_modal_cover").hide();
    $(".dhtmlx_modal_box").remove();
  }
  
  /** Description
   * @function uploadTool
   * @function_Description 파일업로드툴
   * @param vaultObj vault객체      
   * @author 신기환
   */
  this.uploadTool=function (vaultObj){  

    var maxSize  = 100 * 1024 * 1024 ; //100MB
    //1. ext 가져오기
    var optionArray = [];
    $.ajax({
      url : "/common/system/code/getCommonCodeList.do"
      ,data : {'CMMN_CD' : "FILE_EXT_CD"}
      ,method : "POST"
      ,dataType : "JSON"
      ,success : function(data){
        if(data.isError){
          $erp.ajaxErrorMessage(data);
        } else {              
          var commonCodeList = data.commonCodeList;
                    
          for(var i in commonCodeList){
            var commonCodeObj = commonCodeList[i];            
            var option = { text : null, value : null};
            for(var key in commonCodeObj){
              var value =  commonCodeObj[key];
              if(key == 'CMMN_DETAIL_CD'){  
                option.value = value;
              } else {
                option[key] = value;
              }
            }   
            optionArray.push(option);           
          } 
        }
      }, error : function(jqXHR, textStatus, errorThrown){
        $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
      }, complete : function(){
        //2. ext 및 파일 크기 검증
        var result=$erp.validateUploadFiles(vaultObj.list.n,optionArray,maxSize);
        //console.log(result);
        /* #Customized (신기환) : atOnce 구분 파라미터 추가 */
        //3. 성공시 파일업로드
        if(result=='0'){
          vaultObj.upload();
          //console.log(tmp);
        }
      }
    });
  }
  
  /** Description
   * @function validateUploadFiles
   * @function_Description 파일업로드 확장자, 크기 검증
   * @param vaultList 업로드 리스트
   * @param optionArray 확장지 리스트
   * @param maxSize 최대크기    
   * return [0]-둘다정상 [1]-확장자 오류 [2]-크기오류 [3]-둘다오류   
   * @author 신기환
   */
  this.validateUploadFiles=function(vaultList,optionArray,maxSize){
    var tmpExt='';
    var sizeErr=false;
    var extErr=false;
    var result=0;
    //업로드파일갯수만큼
    for(var key in vaultList){
      var value =  vaultList[key];
      tmpExt=value.name.split('.');
      //크기 확장자 검증
      //console.log(optionArray.length);
      for(var j=0;j<optionArray.length;j++){
        //console.log(optionArray[j].value+"/"+tmpExt[1]);
        if(optionArray[j].value.toLowerCase()==tmpExt[1]){
          extErr=true;
          if(maxSize>=value.size){sizeErr=true;break;}
          else{sizeErr=false;continue;}
        }
        else{
          extErr=false;
          if(maxSize>=value.size){sizeErr=true;}
          else{sizeErr=false;}
        }
      }
    }
    //console.log(extErr +"/"+sizeErr);
    if(extErr && sizeErr){result=0;}
    else if(!extErr && sizeErr){result=1;}
    else if(extErr && !sizeErr){result=2;}
    else{result=3;}
    
    return result;
  }
  
  this.downloadTool = function(url, data){
    var isValidated = true;
    if($erp.isEmpty(data)){
      isValidated = false;
    } else {
      var tmpData = data.FILE_NAME; 
      try{
        if(tmpData){
          //tmpData = tmpData.replace(/,/gi, '');
        }
        if($erp.isEmpty(tmpData)){
          isValidated = false;
        }
      }
      catch(err){}
    }
    
    if(!isValidated){
      $erp.alertMessage({
        "alertMessage" : "error.common.noDownloadFile"
        , "alertCode" : null
        , "alertType" : "error"
      });
    } else {
      var method = 'post';
        // url과 data를 입력받음
        if( url && data ){ 
            // data 는  string 또는 array/object 를 파라미터로 받는다.
            data = typeof data == 'string' ? data : $.param(data);
            // 파라미터를 form의  input으로 만든다.
            var inputs = '';
            $.each(data.split('&'), function(){ 
                var pair = this.split('=');
                inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
            });
            console.log(inputs);
            // request를 보낸다.
            $('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
            .appendTo('body').submit().remove();
        };
    }
  }

  
  this.getIndexWindow = function(){
    
  }
  
  /** Description
   * @function validateCardInfo
   * @function_Description DhtmlXGrid Excel 출력
   * @param param (Object) / grid : Grid Object, fileName : 파일명, isForm : 양식다운로드 여부, excludeColumn : 제외 컬럼 (Array), emptyDown : 빈양식다운로드 여부
   * @author 김종훈
   */
  this.exportDhtmlXGridExcel = function(param){
    var grid = param.grid;
    var fileName = param.fileName;
    var isForm = param.isForm;
    var excludeColumn = param.excludeColumn;
    var isHiddenPrint = param.isHiddenPrint;
    var emptyDown = param.emptyDown;
    
    var excludeColumnObj = null;
    if(excludeColumn && typeof excludeColumn === 'object'){
      excludeColumnObj = {};
      for(var i in excludeColumn){
        if(!isNaN(i)){
          excludeColumnObj[excludeColumn[i]] = true;
        } else {
          excludeColumnObj[i] = true;
        }
      }
    }
    
    if($erp.isEmpty(fileName)){
      fileName = "rdct_excel";
    }
    
    var gridRowCount = 0;
    if(isForm !== true){
      if(emptyDown !== true ){
        gridRowCount = grid.getRowsNum();
        var noDataPringRowId = grid.getRowIndex("NoDataPrintRow");
        if(gridRowCount == 0 || (noDataPringRowId != undefined && noDataPringRowId != null && noDataPringRowId >= 0)){
          $erp.alertMessage({
            "alertMessage" : "info.common.noDataPrint"
            , "alertCode" : ""
            , "alertType" : "error"
          });
          return;
        }
      }
    }
    var columnsMapArray = grid.columnsMapArray;
    var headerDepth = 1;    
    var headerObject = [];
    for(var i in columnsMapArray){
      var columnMap = columnsMapArray[i];
      if(excludeColumnObj){
        var id = columnMap.id;
        if(excludeColumnObj[id] === true){
          continue;
        }
      }
      var isHidden = columnMap.isHidden
      if((isHiddenPrint == "N" || isHiddenPrint == "undefined")&& isHidden && isHidden === true){
        continue;
      }
      var label = columnMap.label;
      if(label){
        if($erp.isArray(label)){
          if(label.length > headerDepth){
            headerDepth = label.length;
          }
        }
      }
      var type = columnMap.type;
      var width = grid.getColWidth(i);
      if(isForm === true && (type == "ro" || type.indexOf("ron") > -1 || type == "cntr")){
        continue;
      }
      if (/*type == "ch" ||*/ type == "ra"){
        continue;
      }
      columnMap.width = width;
      headerObject.push(columnMap);
    }
    
    var contentsObject = [];
    if(isForm !== true){    
      var gridColCount = headerObject.length;
      for(var i = 0; i < gridRowCount; i++){
        var rowMap = {};
        var rId = grid.getRowId(i);
        for(var j = 0; j < gridColCount; j++){
          var headerObjectCol = headerObject[j];
          var cId = headerObjectCol.id;
          var cell = grid.cells(rId, grid.getColIndexById(cId));
          var text = cell.getContent?cell.getContent():cell.getTitle();
          if (headerObjectCol.type == "chn" || type == "ch"){
        	  text = cell.getValue()==1?"Y":"N";
          }
          //console.log("headerObjectCol.type : " + headerObjectCol.type + "  / text : "+text);
          rowMap[cId] = text;
        }
        contentsObject.push(rowMap);
      }
    }
    
    var requestForm = document.createElement("FORM");
    requestForm.setAttribute("method", "post");
    requestForm.setAttribute("action", "/common/system/file/downloadGridExcel.do");
    requestForm.setAttribute("accept-charset", "utf-8");
    requestForm.setAttribute("enctype", "application/x-www-form-urlencoded");
    /*requestForm.setAttribute("target", "_blank");*/
    
    var headerInputElement = document.createElement("INPUT");
    headerInputElement.setAttribute("type", "hidden");
    headerInputElement.setAttribute("name", "header");
    headerInputElement.value = JSON.stringify(headerObject);
    requestForm.appendChild(headerInputElement);
    
    if(isForm !== true){
      var contentsInputElement = document.createElement("INPUT");
      contentsInputElement.setAttribute("type", "hidden");
      contentsInputElement.setAttribute("name", "contents");
      contentsInputElement.value = JSON.stringify(contentsObject);
      requestForm.appendChild(contentsInputElement);
    } else {
      var formYnInputElement = document.createElement("INPUT");
      formYnInputElement.setAttribute("type", "hidden");
      formYnInputElement.setAttribute("name", "form_yn");
      formYnInputElement.value = "Y";
      requestForm.appendChild(formYnInputElement);
    }
    
    var fileNameInputElement = document.createElement("INPUT");
    fileNameInputElement.setAttribute("type", "hidden");
    fileNameInputElement.setAttribute("name", "fileName");
    fileNameInputElement.value = fileName;
    requestForm.appendChild(fileNameInputElement);
    
    var headerDepthInputElement = document.createElement("INPUT");
    headerDepthInputElement.setAttribute("type", "hidden");
    headerDepthInputElement.setAttribute("name", "headerDepth");
    headerDepthInputElement.value = headerDepth;
    requestForm.appendChild(headerDepthInputElement);
    
    indexWindow.document.body.appendChild(requestForm);
    requestForm.submit();
    indexWindow.document.body.removeChild(requestForm);   
  }

  
  /** RDCT 프로젝트 추가  */
  
  /** 
   * Description 
   * @function getDhtmlXPrdcCtgrCombo
   * @function_Description getDhtmlXPrdcCtgrCombo 생성
   * @param domElementId (String) / Dom Element Object ID
   * @param paramName (String) / Form Parameter 전송 시 사용할 Name
   * @param cmmn_cd (Object, Array, String) / System 공통코드
   * @param paramWidth (Number) / Object 가로 넓이
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param optionType (String) / Combo Option Type
   * @author 주병훈
   */
  this.getDhtmlXPrdcCtgrCombo = function(domElementId, paramName, cmmn_cd, paramWidth, blankText, defaultOption, callbackFunction, optionType){

    var defaultWidth = 200;
    var width = defaultWidth;
    if(paramWidth && !isNaN(paramWidth)){
      width = paramWidth;
    }
    if(blankText == null){
      blankText = undefined;
    }
    if(defaultOption == null || defaultOption == ''){
      defaultOption = undefined;
    }

    var divParamMap = {};     
    if(!$erp.isEmpty(cmmn_cd)){
      if(typeof cmmn_cd === 'object' && $erp.isArray(cmmn_cd)){
        divParamMap.div1 = cmmn_cd[1];
        divParamMap.div2 = cmmn_cd[2];
        divParamMap.div3 = cmmn_cd[3];
        divParamMap.div4 = cmmn_cd[4];
        divParamMap.div5 = cmmn_cd[5];
        cmmn_cd = cmmn_cd[0];
      } else if(typeof cmmn_cd === 'object' && !$erp.isArray(cmmn_cd)){
        divParamMap.div1 = cmmn_cd['div1'];
        divParamMap.div2 = cmmn_cd['div2'];
        divParamMap.div3 = cmmn_cd['div3'];
        divParamMap.div4 = cmmn_cd['div4'];
        divParamMap.div5 = cmmn_cd['div5'];
        cmmn_cd = cmmn_cd['commonCode'];
      }       
    } else {
      return;
    }

    var dhtmlXComboObject = null;
    if(domElementId != undefined && cmmn_cd != undefined){
      /* new dhtmlXCombo(id, name, width); */       
      dhtmlXComboObject = new dhtmlXCombo(domElementId, paramName, width, optionType);
      dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
      dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.readonly(true);   
      document.getElementById(domElementId).setAttribute("name", paramName);
      $erp.setDhtmlXPrdcCtgrComboDataAjax(dhtmlXComboObject, cmmn_cd, blankText, defaultOption, callbackFunction, divParamMap,optionType);
    }
    return dhtmlXComboObject;
  }
  
  /** 
   * Description 
   * @function setDhtmlXPrdcCtgrComboDataAjax
   * @function_Description Ajax를 통한 DhtmlXCombo Data 생성
   * @param dhtmlXComboObject (Object) / 생성한 DhtmlXComboObject $erp.getDhtmlXCombo Function 활용
   * @param cmmn_cd (String) / System 공통코드
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param divParamMap (Object) / 구분 조건 Map
   * @author 주병훈
   */
  this.setDhtmlXPrdcCtgrComboDataAjax = function(dhtmlXComboObject, cmmn_cd, blankText, defaultOption, callbackFunction, divParamMap,optionType,useYn){ 
    var div1;
    var div2;
    var div3;
    var div4;
    var div5;
    
    if(!$erp.isEmpty(divParamMap)){
      div1 = divParamMap['div1'];
      div2 = divParamMap['div2'];
      div3 = divParamMap['div3'];
      div4 = divParamMap['div4'];
      div5 = divParamMap['div5'];
    }

    $.ajax({
      url : "/master/category/standardCategory/getPrdcCtgrCodeList.do"
      ,data : {
        'CMMN_CD' : cmmn_cd
        ,'DIV1' : div1
        ,'DIV2' : div2
        ,'DIV3' : div3
        ,'DIV4' : div4
        ,'DIV5' : div5
        ,'USE_YN' : useYn
      }
      ,method : "POST"
      ,dataType : "JSON"
      ,success : function(data){
        if(data.isError){
          $erp.ajaxErrorMessage(data);
        } else {              
          var commonCodeList = data.commonCodeList;
          var optionArray = [];   
          if(blankText != undefined && blankText != null && blankText !== false){
            /* blankText가 true인 경우 전체로 Text 변경 */
            if(blankText === true){
              blankText = "전체";
            }
            optionArray.push({ value : "", text : blankText});
          }
          for(var i in commonCodeList){
            var commonCodeObj = commonCodeList[i];            
            var option = { value : null, text : null};
            for(var key in commonCodeObj){
              var value =  commonCodeObj[key];
              if(key == 'CMMN_DETAIL_CD'){  /* CMMN_DETAIL_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.value = value;
              } else if(key == 'CMMN_DETAIL_CD_NM'){ /* CMMN_DETAIL_CD_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.text = value;
              } else {
                option[key] = value;
              }
            }   
            optionArray.push(option);           
          }
          dhtmlXComboObject.addOption(optionArray);
          if(typeof dhtmlXComboObject.getParent() === 'string'){
            if(dhtmlXComboObject.getOptionsCount() > 0){
              dhtmlXComboObject.selectOption(0);
            }
            if(defaultOption != undefined && defaultOption != null){
              dhtmlXComboObject.setComboValue(defaultOption);
            }
          }
          
          //checkbox 모두 선택
          if(typeof optionType === 'string'){
            for(var x=0;x<dhtmlXComboObject.getOptionsCount();x++){
              dhtmlXComboObject.setChecked(x,true);
            }
          }
          
          if(callbackFunction && typeof callbackFunction === 'function'){
            callbackFunction.apply(dhtmlXComboObject, []);
          }
        }
      }, error : function(jqXHR, textStatus, errorThrown){
        $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
      }
    });
  }
  
  /** 
   * Description 
   * @function getDhtmlXDtlCtgrCombo
   * @function_Description getDhtmlXDtlCtgrCombo 생성
   * @param domElementId (String) / Dom Element Object ID
   * @param paramName (String) / Form Parameter 전송 시 사용할 Name
   * @param cmmn_cd (Object, Array, String) / System 공통코드
   * @param paramWidth (Number) / Object 가로 넓이
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param optionType (String) / Combo Option Type
   * @author 주병훈
   */
  this.getDhtmlXDtlCtgrCombo = function(domElementId, paramName, cmmnCd, upperCd, paramWidth, blankText, defaultOption, callbackFunction, optionType){

    var defaultWidth = 200;
    var width = defaultWidth;
    if(paramWidth && !isNaN(paramWidth)){
      width = paramWidth;
    }
    if(blankText == null){
      blankText = undefined;
    }
    if(defaultOption == null || defaultOption == ''){
      defaultOption = undefined;
    }

    var divParamMap = {};     
    if(!$erp.isEmpty(cmmnCd)){
      if(typeof cmmnCd === 'object' && $erp.isArray(cmmnCd)){
        divParamMap.div1 = cmmnCd[1];
        divParamMap.div2 = cmmnCd[2];
        divParamMap.div3 = cmmnCd[3];
        divParamMap.div4 = cmmnCd[4];
        divParamMap.div5 = cmmnCd[5];
        cmmnCd = cmmnCd[0];
      } else if(typeof cmmnCd === 'object' && !$erp.isArray(cmmnCd)){
        divParamMap.div1 = cmmnCd['div1'];
        divParamMap.div2 = cmmnCd['div2'];
        divParamMap.div3 = cmmnCd['div3'];
        divParamMap.div4 = cmmnCd['div4'];
        divParamMap.div5 = cmmnCd['div5'];
        cmmnCd = cmmnCd['commonCode'];
      }       
    } else {
      return;
    }

    var dhtmlXComboObject = null;
    if(domElementId != undefined && cmmnCd != undefined){
      /* new dhtmlXCombo(id, name, width); */       
      dhtmlXComboObject = new dhtmlXCombo(domElementId, paramName, width, optionType);
      dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
      dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.readonly(true);   
      document.getElementById(domElementId).setAttribute("name", paramName);
      $erp.setDhtmlXDtlCtgrComboDataAjax(dhtmlXComboObject, cmmnCd, upperCd, blankText, defaultOption, callbackFunction, divParamMap,optionType);
    }
    return dhtmlXComboObject;
  }
  
  /** 
   * Description 
   * @function setDhtmlXPrdcCtgrComboDataAjax
   * @function_Description Ajax를 통한 DhtmlXCombo Data 생성
   * @param dhtmlXComboObject (Object) / 생성한 DhtmlXComboObject $erp.getDhtmlXCombo Function 활용
   * @param cmmnCd (String) / System 공통코드
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param divParamMap (Object) / 구분 조건 Map
   * @author 주병훈
   */
  this.setDhtmlXDtlCtgrComboDataAjax = function(dhtmlXComboObject, cmmnCd, upperCd, blankText, defaultOption, callbackFunction, divParamMap,optionType){  
    var div1;
    var div2;
    var div3;
    var div4;
    var div5;
    
    if(!$erp.isEmpty(divParamMap)){
      div1 = divParamMap['div1'];
      div2 = divParamMap['div2'];
      div3 = divParamMap['div3'];
      div4 = divParamMap['div4'];
      div5 = divParamMap['div5'];
    }

    $.ajax({
      url : "/master/category/detailCategory/getDtlCtgrCodeList.do"
      ,data : {
        'CMMN_CD' : cmmnCd
        ,'UPPER_CD' : upperCd
        ,'DIV1' : div1
        ,'DIV2' : div2
        ,'DIV3' : div3
        ,'DIV4' : div4
        ,'DIV5' : div5
      }
      ,method : "POST"
      ,dataType : "JSON"
      ,success : function(data){
        if(data.isError){
          $erp.ajaxErrorMessage(data);
        } else {              
          var commonCodeList = data.commonCodeList;
          var optionArray = [];   
          if(blankText != undefined && blankText != null && blankText !== false){
            /* blankText가 true인 경우 전체로 Text 변경 */
            if(blankText === true){
              blankText = "전체";
            }
            optionArray.push({ value : "", text : blankText});
          }
          for(var i in commonCodeList){
            var commonCodeObj = commonCodeList[i];            
            var option = { value : null, text : null};
            for(var key in commonCodeObj){
              var value =  commonCodeObj[key];
              if(key == 'CMMN_DETAIL_CD'){  /* CMMN_DETAIL_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.value = value;
              } else if(key == 'CMMN_DETAIL_CD_NM'){ /* CMMN_DETAIL_CD_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.text = value;
              } else {
                option[key] = value;
              }
            }   
            optionArray.push(option);           
          }
          dhtmlXComboObject.addOption(optionArray);
          if(typeof dhtmlXComboObject.getParent() === 'string'){
            if(dhtmlXComboObject.getOptionsCount() > 0){
              dhtmlXComboObject.selectOption(0);
            }
            if(defaultOption != undefined && defaultOption != null){
              dhtmlXComboObject.setComboValue(defaultOption);
            }
          }
          
          //checkbox 모두 선택
          if(typeof optionType === 'string'){
            for(var x=0;x<dhtmlXComboObject.getOptionsCount();x++){
              dhtmlXComboObject.setChecked(x,true);
            }
          }
          
          if(callbackFunction && typeof callbackFunction === 'function'){
            callbackFunction.apply(dhtmlXComboObject, []);
          }
        }
      }, error : function(jqXHR, textStatus, errorThrown){
        $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
      }
    });
  }
  
  /** 
   * Description 
   * @function getDhtmlXOrgnListCombo
   * @function_Description getDhtmlXDtlCtgrCombo 생성
   * @param domElementId (String) / Dom Element Object ID
   * @param paramName (String) / Form Parameter 전송 시 사용할 Name
   * @param cmmn_cd (Object, Array, String) / System 공통코드
   * @param paramWidth (Number) / Object 가로 넓이
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param optionType (String) / Combo Option Type
   * @author 주병훈
   */
  this.getDhtmlXOrgnListCombo = function(domElementId, paramName, divCd, paramWidth, blankText, defaultOption, callbackFunction, optionType){

    var defaultWidth = 200;
    var width = defaultWidth;
    if(paramWidth && !isNaN(paramWidth)){
      width = paramWidth;
    }
    if(blankText == null){
      blankText = undefined;
    }
    if(defaultOption == null || defaultOption == ''){
      defaultOption = undefined;
    }

    var dhtmlXComboObject = null;
    if(domElementId != undefined){
      /* new dhtmlXCombo(id, name, width); */       
      dhtmlXComboObject = new dhtmlXCombo(domElementId, paramName, width, optionType);
      dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
      dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.readonly(true);   
      document.getElementById(domElementId).setAttribute("name", paramName);
      $erp.setDhtmlXOrgnListComboDataAjax(dhtmlXComboObject, divCd, blankText, defaultOption, callbackFunction, optionType);
    }
    
    return dhtmlXComboObject;
  }
  
  /** 
   * Description 
   * @function setDhtmlXOrgnListComboDataAjax
   * @function_Description Ajax를 통한 DhtmlXCombo Data 생성
   * @param dhtmlXComboObject (Object) / 생성한 DhtmlXComboObject $erp.getDhtmlXCombo Function 활용
   * @param cmmnCd (String) / System 공통코드
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param divParamMap (Object) / 구분 조건 Map
   * @author 주병훈
   */
  this.setDhtmlXOrgnListComboDataAjax = function(dhtmlXComboObject, divCd, blankText, defaultOption, callbackFunction, optionType){ 

    $.ajax({
      url : "/common/organ/getOrgnListSession.do"
      ,data : {'ORGN_DIV_CD' : divCd}
      ,method : "POST"
      ,dataType : "JSON"
      ,success : function(data){
        if(data.isError){
          $erp.ajaxErrorMessage(data);
        } else {              
          var commonCodeList = data.commonCodeList;
          var optionArray = [];   
          if(blankText != undefined && blankText != null && blankText !== false){
            /* blankText가 true인 경우 전체로 Text 변경 */
            if(blankText === true){
              blankText = "전체";
            }
            optionArray.push({ value : "", text : blankText});
          }
          for(var i in commonCodeList){
            var commonCodeObj = commonCodeList[i];            
            var option = { value : null, text : null};
            for(var key in commonCodeObj){
              var value =  commonCodeObj[key];
              if(key == 'CMMN_DETAIL_CD'){  /* CMMN_DETAIL_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.value = value;
              } else if(key == 'CMMN_DETAIL_CD_NM'){ /* CMMN_DETAIL_CD_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.text = value;
              } else {
                option[key] = value;
              }
            }   
            optionArray.push(option);           
          }
          dhtmlXComboObject.addOption(optionArray);
          if(typeof dhtmlXComboObject.getParent() === 'string'){
            if(dhtmlXComboObject.getOptionsCount() > 0){
              dhtmlXComboObject.selectOption(0);
            }
            if(defaultOption != undefined && defaultOption != null){
              dhtmlXComboObject.setComboValue(defaultOption);
            }
          }
          
          //checkbox 모두 선택
          if(typeof optionType === 'string'){
            for(var x=0;x<dhtmlXComboObject.getOptionsCount();x++){
              dhtmlXComboObject.setChecked(x,true);
            }
          }
          
          if(callbackFunction && typeof callbackFunction === 'function'){
            callbackFunction.apply(dhtmlXComboObject, []);
          }
        }
      }, error : function(jqXHR, textStatus, errorThrown){
        $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
      }
    });
  }
  
  /** 
   * Description 
   * @function getDhtmlXNotOrgnListCombo
   * @function_Description getDhtmlXDtlCtgrCombo 생성
   * @param domElementId (String) / Dom Element Object ID
   * @param paramName (String) / Form Parameter 전송 시 사용할 Name
   * @param cmmn_cd (Object, Array, String) / System 공통코드
   * @param paramWidth (Number) / Object 가로 넓이
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param optionType (String) / Combo Option Type
   * @author 주병훈
   */
  this.getDhtmlXNotOrgnListCombo = function(domElementId, paramName, divCd, paramWidth, blankText, defaultOption, callbackFunction, optionType){

    var defaultWidth = 200;
    var width = defaultWidth;
    if(paramWidth && !isNaN(paramWidth)){
      width = paramWidth;
    }
    if(blankText == null){
      blankText = undefined;
    }
    if(defaultOption == null || defaultOption == ''){
      defaultOption = undefined;
    }

    var dhtmlXComboObject = null;
    if(domElementId != undefined){
      /* new dhtmlXCombo(id, name, width); */       
      dhtmlXComboObject = new dhtmlXCombo(domElementId, paramName, width, optionType);
      dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
      dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.readonly(true);   
      document.getElementById(domElementId).setAttribute("name", paramName);
      $erp.setDhtmlXNotOrgnListComboDataAjax(dhtmlXComboObject, divCd, blankText, defaultOption, callbackFunction, optionType);
    }
    
    return dhtmlXComboObject;
  }
  
  /** 
   * Description 
   * @function setDhtmlXNotOrgnListComboDataAjax
   * @function_Description Ajax를 통한 DhtmlXCombo Data 생성
   * @param dhtmlXComboObject (Object) / 생성한 DhtmlXComboObject $erp.getDhtmlXCombo Function 활용
   * @param cmmnCd (String) / System 공통코드
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param divParamMap (Object) / 구분 조건 Map
   * @author 주병훈
   */
  this.setDhtmlXNotOrgnListComboDataAjax = function(dhtmlXComboObject, divCd, blankText, defaultOption, callbackFunction, optionType){  

    $.ajax({
      url : "/common/organ/getNotOrgnListSession.do"
      ,data : {'ORGN_DIV_CD' : divCd}
      ,method : "POST"
      ,dataType : "JSON"
      ,success : function(data){
        if(data.isError){
          $erp.ajaxErrorMessage(data);
        } else {              
          var commonCodeList = data.commonCodeList;
          var optionArray = [];   
          if(blankText != undefined && blankText != null && blankText !== false){
            /* blankText가 true인 경우 전체로 Text 변경 */
            if(blankText === true){
              blankText = "전체";
            }
            optionArray.push({ value : "", text : blankText});
          }
          for(var i in commonCodeList){
            var commonCodeObj = commonCodeList[i];            
            var option = { value : null, text : null};
            for(var key in commonCodeObj){
              var value =  commonCodeObj[key];
              if(key == 'CMMN_DETAIL_CD'){  /* CMMN_DETAIL_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.value = value;
              } else if(key == 'CMMN_DETAIL_CD_NM'){ /* CMMN_DETAIL_CD_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.text = value;
              } else {
                option[key] = value;
              }
            }   
            optionArray.push(option);           
          }
          dhtmlXComboObject.addOption(optionArray);
          if(typeof dhtmlXComboObject.getParent() === 'string'){
            if(dhtmlXComboObject.getOptionsCount() > 0){
              dhtmlXComboObject.selectOption(0);
            }
            if(defaultOption != undefined && defaultOption != null){
              dhtmlXComboObject.setComboValue(defaultOption);
            }
          }
          
          //checkbox 모두 선택
          if(typeof optionType === 'string'){
            for(var x=0;x<dhtmlXComboObject.getOptionsCount();x++){
              dhtmlXComboObject.setChecked(x,true);
            }
          }
          
          if(callbackFunction && typeof callbackFunction === 'function'){
            callbackFunction.apply(dhtmlXComboObject, []);
          }
        }
      }, error : function(jqXHR, textStatus, errorThrown){
        $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
      }
    });
  }

  /** 
   * Description 
   * @function getDhtmlXCombo
   * @function_Description DhtmlXCombo 생성
   * @param domElementId (String) / Dom Element Object ID
   * @param paramName (String) / Form Parameter 전송 시 사용할 Name
   * @param cmmn_cd (Object, Array, String) / System 공통코드
   * @param paramWidth (Number) / Object 가로 넓이
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param optionType (String) / Combo Option Type
   * @author 김종훈
   */
  this.getDhtmlXCombo = function(domElementId, paramName, cmmn_cd, paramWidth, blankText, defaultOption, callbackFunction, optionType){
    var defaultWidth = 200;
    var width = defaultWidth;
    if(paramWidth && !isNaN(paramWidth)){
      width = paramWidth;
    }
    if(blankText == null){
      blankText = undefined;
    }
    if(defaultOption == null || defaultOption == ''){
      defaultOption = undefined;
    }

    var divParamMap = {};     
    if(!$erp.isEmpty(cmmn_cd)){
      if(typeof cmmn_cd === 'object' && $erp.isArray(cmmn_cd)){
        divParamMap.div1 = cmmn_cd[1];
        divParamMap.div2 = cmmn_cd[2];
        divParamMap.div3 = cmmn_cd[3];
        divParamMap.div4 = cmmn_cd[4];
        divParamMap.div5 = cmmn_cd[5];
        cmmn_cd = cmmn_cd[0];
      } else if(typeof cmmn_cd === 'object' && !$erp.isArray(cmmn_cd)){
        divParamMap.div1 = cmmn_cd['div1'];
        divParamMap.div2 = cmmn_cd['div2'];
        divParamMap.div3 = cmmn_cd['div3'];
        divParamMap.div4 = cmmn_cd['div4'];
        divParamMap.div5 = cmmn_cd['div5'];
        cmmn_cd = cmmn_cd['commonCode'];
      }       
    } else {
      return;
    }

    var dhtmlXComboObject = null;
    if(domElementId != undefined && cmmn_cd != undefined){
      /* new dhtmlXCombo(id, name, width); */       
      dhtmlXComboObject = new dhtmlXCombo(domElementId, paramName, width, optionType);
      dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
      dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.readonly(true);   
      document.getElementById(domElementId).setAttribute("name", paramName);
      $erp.asyncObjAddStart(domElementId);
      $erp.setDhtmlXComboDataAjax(dhtmlXComboObject, cmmn_cd, blankText, defaultOption, callbackFunction, divParamMap,optionType);
    }
    return dhtmlXComboObject;
  }
  
  /** 
   * Description 
   * @function getDhtmlXCombo
   * @function_Description DhtmlXCombo 생성
   * @param domElementId (String) / Dom Element Object ID
   * @param paramName (String) / Form Parameter 전송 시 사용할 Name
   * @param cmmn_cd (Object, Array, String) / System 공통코드
   * @param paramWidth (Number) / Object 가로 넓이
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param optionType (String) / Combo Option Type
   * @author 김종훈
   */
  this.getDhtmlXComboFilter = function(domElementId, paramName, cmmn_cd, paramWidth, blankText, defaultOption, callbackFunction, optionType){
    var defaultWidth = 200;
    var width = defaultWidth;
    if(paramWidth && !isNaN(paramWidth)){
      width = paramWidth;
    }
    if(blankText == null){
      blankText = undefined;
    }
    if(defaultOption == null || defaultOption == ''){
      defaultOption = undefined;
    }

    var divParamMap = {};     
    if(!$erp.isEmpty(cmmn_cd)){
      if(typeof cmmn_cd === 'object' && $erp.isArray(cmmn_cd)){
        divParamMap.div1 = cmmn_cd[1];
        divParamMap.div2 = cmmn_cd[2];
        divParamMap.div3 = cmmn_cd[3];
        divParamMap.div4 = cmmn_cd[4];
        divParamMap.div5 = cmmn_cd[5];
        cmmn_cd = cmmn_cd[0];
      } else if(typeof cmmn_cd === 'object' && !$erp.isArray(cmmn_cd)){
        divParamMap.div1 = cmmn_cd['div1'];
        divParamMap.div2 = cmmn_cd['div2'];
        divParamMap.div3 = cmmn_cd['div3'];
        divParamMap.div4 = cmmn_cd['div4'];
        divParamMap.div5 = cmmn_cd['div5'];
        cmmn_cd = cmmn_cd['commonCode'];
      }       
    } else {
      return;
    }

    var dhtmlXComboObject = null;
    if(domElementId != undefined && cmmn_cd != undefined){
      /* new dhtmlXCombo(id, name, width); */       
      dhtmlXComboObject = new dhtmlXCombo(domElementId, paramName, width, optionType);
      dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
      dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
      dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
      //dhtmlXComboObject.readonly(true);
      dhtmlXComboObject.enableFilteringMode("between");
      document.getElementById(domElementId).setAttribute("name", paramName);
      $erp.asyncObjAddStart(domElementId);
      $erp.setDhtmlXComboDataAjax(dhtmlXComboObject, cmmn_cd, blankText, defaultOption, callbackFunction, divParamMap,optionType);
    }
    return dhtmlXComboObject;
  }

  /** 
   * Description 
   * @function setDhtmlXComboDataAjax
   * @function_Description Ajax를 통한 DhtmlXCombo Data 생성
   * @param dhtmlXComboObject (Object) / 생성한 DhtmlXComboObject $erp.getDhtmlXCombo Function 활용
   * @param cmmn_cd (String) / System 공통코드
   * @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
   * @param defaultOption (String) / 초기화 될 기본 값 (Value) 기준
   * @param callbackFunction (function) / 작업 끝난 후 Callback Function
   * @param divParamMap (Object) / 구분 조건 Map
   * @author 김종훈  ------- useYn 추가 
   */
  this.setDhtmlXComboDataAjax = function(dhtmlXComboObject, cmmn_cd, blankText, defaultOption, callbackFunction, divParamMap,optionType,useYn){  
    var div1;
    var div2;
    var div3;
    var div4;
    var div5;

    if(!$erp.isEmpty(divParamMap)){
      div1 = divParamMap['div1'];
      div2 = divParamMap['div2'];
      div3 = divParamMap['div3'];
      div4 = divParamMap['div4'];
      div5 = divParamMap['div5'];
    }
    
    $.ajax({
      url : "/common/system/code/getCommonCodeList.do"
      ,data : {
        'CMMN_CD' : cmmn_cd
        ,'DIV1' : div1
        ,'DIV2' : div2
        ,'DIV3' : div3
        ,'DIV4' : div4
        ,'DIV5' : div5
        ,'USE_YN' : useYn  // 추가 
      }
      ,method : "POST"
      ,dataType : "JSON"
      ,success : function(data){
        if(data.isError){
          $erp.ajaxErrorMessage(data);
        } else {              
          var commonCodeList = data.commonCodeList;
          var optionArray = [];   
          if(blankText != undefined && blankText != null && blankText !== false){
            /* blankText가 true인 경우 전체로 Text 변경 */
            if(blankText === true){
              blankText = "모두조회";
            }
            optionArray.push({ value : "", text : blankText});
          }
          for(var i in commonCodeList){
            var commonCodeObj = commonCodeList[i];            
            var option = { value : null, text : null};
            for(var key in commonCodeObj){
              var value =  commonCodeObj[key];
              if(key == 'CMMN_DETAIL_CD'){  /* CMMN_DETAIL_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.value = value;
              } else if(key == 'CMMN_DETAIL_CD_NM'){ /* CMMN_DETAIL_CD_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
                option.text = value;
              } else {
                option[key] = value;
              }
            }   
            optionArray.push(option);           
          }
          dhtmlXComboObject.addOption(optionArray);
          if(typeof dhtmlXComboObject.getParent() === 'string'){
            if(dhtmlXComboObject.getOptionsCount() > 0){
              dhtmlXComboObject.selectOption(0);
            }
            if(defaultOption != undefined && defaultOption != null){
              dhtmlXComboObject.setComboValue(defaultOption);
            }
          }
          
          //checkbox 모두 선택
          if(typeof optionType === 'string'){
            for(var x=0;x<dhtmlXComboObject.getOptionsCount();x++){
              dhtmlXComboObject.setChecked(x,true);
            }
          }
          
          if(callbackFunction && typeof callbackFunction === 'function'){
            callbackFunction.apply(dhtmlXComboObject, []);
          }
          
          if(typeof dhtmlXComboObject.DOMParent == "string"){ // 일반콤보
        	  $erp.asyncObjAddEnd(dhtmlXComboObject.DOMParent);
          }else{ // 그리드 내 콤보
        	  $erp.asyncObjAddEnd(dhtmlXComboObject.gridComboId);
          }
        }
      }, error : function(jqXHR, textStatus, errorThrown){
        $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
      }
    });
  }
  
  /** 
   * Description 
   * @function getDhtmlXCheckBox
   * @function_Description DhtmlXCheckBox 생성
   * @param formName (String) / 체크박스가 들어갈 div태그의 id
   * @param labelName (String) / 체크박스 내용
   * @param checkValue (String) / 체크박스의 value
   * @param checked (Boolean) / 체크박스 체크 유무
   * @param labelPosition (String) / 체크박스 내용의 위치(label-left,label-right,label-top,label-bottom,absolute)
   * @param disabled (Boolean) / disable 유무
   * @author 유가영
   */
  this.getDhtmlXCheckBox = function(formName, labelName, checkValue, checked, labelPosition, disabled){
    var checkForm;
    if($erp.isEmpty(checked)){
      checked = false;
    }
    if(formName == null || formName ==''){
      formName = undefined;
    }
    if(labelPosition == null || labelPosition =='' || labelPosition == undefined){
      labelPosition = "label-right";
    }
    if(disabled == null || disabled == '' || disabled == undefined){
    	disabled = false;
    }
    var dhtmlXCheckBoxObject = null;

    if(labelName != undefined || formName != undefined){
      checkForm = [{type: "settings", position: labelPosition},{type: 'checkbox', name : formName, value : checkValue, label: labelName, checked: checked, disabled: disabled}];
      dhtmlXCheckBoxObject = new dhtmlXForm(formName, checkForm);
    }
    
    return dhtmlXCheckBoxObject;
  }

  /** 
   * Description 
   * @function getDhtmlXMultiCheckBox
   * @function_Description getDhtmlXMultiCheckBox 생성
   * @param formName (String) / 체크박스가 들어갈 div태그의 id
   * @param labelName (String / Array) / 체크박스 내용
   * @param checkValue (String / Array) / 체크박스의 value
   * @param checked (Boolean / Array) / 체크박스 체크 유무
   * @param labelPosition (String) / 체크박스 내용의 위치(label-left,label-right,label-top,label-bottom,absolute)
   * @param shape (string) / 라디오 버튼들의 수직, 수평을 지정(vertical, horizon)
   * @author 이병주
   */
  this.getDhtmlXMultiCheckBox = function(formName, labelName, checkName, checkValue, checked, labelPosition, shape){
    var checkForm;
    var checkNameNew;
    var checkedNew;
    if($erp.isEmpty(checked)){
      checked = false;
    }
    if(labelPosition == null || labelPosition =='' || labelPosition == undefined){
      labelPosition = "label-right";
    }
    if(shape == null || shape == '' || shape == undefined){
      shape = "vertical";
    }
    
    var dhtmlXCheckBoxObject = null;

    if(labelName != undefined){     
      checkForm = "[";        
      for(i=0; i<checkValue.length; i++){
        
        if(typeof(checkName) == 'string'){	//checkName 이 string
          checkNameNew = checkName;
          checkedNew = ",checked:false";
          if(checked) checkedNew = ",checked:true";
        }else{  //checkName 이 array 인 경우
          checkNameNew = checkName[i];
          checkedNew = ",checked:false";
          if(checked[i]) checkedNew = ",checked:true";
        }
        
        i == 0 ? checkForm += "" : checkForm += ",";        
        
        checkForm += "{type: 'settings', position: '"+labelPosition+"'}";
        checkForm += ",{type: 'checkbox', name: '"+checkNameNew+"', value: '"+checkValue[i]+"', label: '"+labelName[i]+"' ";
        checkForm += checkedNew;
        checkForm += "}";

        shape == "horizon" ? checkForm += ", {type: 'newcolumn', offset:20}" : checkForm += ", {type: 'newcolumn', offset:0}";
      }
      checkForm += "]";
      
      var json = eval(checkForm);
      dhtmlXCheckBoxObject = new dhtmlXForm(formName, json);
    }
    
    return dhtmlXCheckBoxObject;
  }
  
  /** 
   * Description 
   * @function getDhtmlXRadio
   * @function_Description DhtmlXRadio 생성
   * @param formName (String) / 라디오 버튼이 들어갈 div태그의 id
   * @param radioName (String) / 라디오 태그의 id
   * @param radioValue (Array[String]) / 라디오 버튼 각각의 value
   * @param checkPosition (int) / 라디오 버튼이 클릭되어있을 위치
   * @param labelName (String) / 각각의 라디오 버튼의 라벨
   * @param labelPosition (String) / 라디오 버튼의 라벨의 위치(label-left,label-right,label-top,label-bottom,absolute)
   * @param shape (string) / 라디오 버튼들의 수직, 수평을 지정(vertical, horizon)
   * @author 유가영
   */
  this.getDhtmlXRadio = function(formName, radioName, radioValue, checkPosition, labelName, labelPosition, shape){
    var radioForm;
    if(formName == null || formName ==''){
      formName = undefined;
    }
    if(checkPosition == null || checkPosition == '' || checkPosition < 0 || checkPosition >= radioValue.length){
      checkPosition = 0;
    }
    if(radioName == null || radioName ==''){
      radioName = undefined;
    }
    if(labelPosition == null || labelPosition =='' || labelPosition == undefined){
      labelPosition = "label-right";
    }
    if(shape == null || shape == '' || shape == undefined){
      shape = "vertical";
    }

    var dhtmlXRadioObject = null;
    
    if(formName != undefined || radioName != undefined || radioValue.length == labelName){
      radioForm = "[{type: 'settings', position: '"+labelPosition+"'}";
      for(i=0; i<radioValue.length; i++){
        if(checkPosition == i){
          radioForm += ",{type: 'radio', name: '"+radioName+"', value: '"+radioValue[i]+"', label: '"+labelName[i]+"', checked: true}";
        }else{
          radioForm += ",{type: 'radio', name: '"+radioName+"', value: '"+radioValue[i]+"', label: '"+labelName[i]+"'}";
        }
        if(shape == "horizon" || i<radioValue.length-1){
          radioForm += ", {type: 'newcolumn', offset:20}";
        }
        if(i==radioValue.length-1){
          radioForm += "]";
        }
      }
      var json = eval(radioForm);
      dhtmlXRadioObject = new dhtmlXForm(formName, json);
    }
    return dhtmlXRadioObject;
  }
  
  
  this.getDhtmlXRadio = function(domElementId, paramName, cmmn_cd, checkPosition, labelPosition, shape,callbackFunction){
	    var divParamMap = {};     
	    if(!$erp.isEmpty(cmmn_cd)){
	      if(typeof cmmn_cd === 'object' && $erp.isArray(cmmn_cd)){
	        divParamMap.div1 = cmmn_cd[1];
	        divParamMap.div2 = cmmn_cd[2];
	        divParamMap.div3 = cmmn_cd[3];
	        divParamMap.div4 = cmmn_cd[4];
	        divParamMap.div5 = cmmn_cd[5];
	        cmmn_cd = cmmn_cd[0];
	      } else if(typeof cmmn_cd === 'object' && !$erp.isArray(cmmn_cd)){
	        divParamMap.div1 = cmmn_cd['div1'];
	        divParamMap.div2 = cmmn_cd['div2'];
	        divParamMap.div3 = cmmn_cd['div3'];
	        divParamMap.div4 = cmmn_cd['div4'];
	        divParamMap.div5 = cmmn_cd['div5'];
	        cmmn_cd = cmmn_cd['commonCode'];
	      }       
	    } else {
	      return;
	    }

	    var dhtmlXRadioObject = null;
	    if(domElementId != undefined && cmmn_cd != undefined){
	   	  // $erp.setDhtmlXRadioDataAjax(dhtmlXComboObject, domElementId, paramName, cmmn_cd, checkPosition, labelPosition, shape);
	      $erp.setDhtmlXRadioDataAjax(dhtmlXRadioObject, domElementId, paramName, cmmn_cd, divParamMap, checkPosition, labelPosition, shape, callbackFunction);
	      
	      //  $erp.setDhtmlXComboDataAjax(dhtmlXComboObject, cmmn_cd, blankText, defaultOption, callbackFunction, divParamMap,optionType);
	    }
	    return dhtmlXRadioObject;  
	}

	this.setDhtmlXRadioDataAjax = function(dhtmlXRadioObject, domElementId, paramName, cmmn_cd, divParamMap, checkPosition, labelPosition, shape, callbackFunction){  
		var div1;
	    var div2;
	    var div3;
	    var div4;
	    var div5;
        var useYn ='Y';
	    if(!$erp.isEmpty(divParamMap)){
	      div1 = divParamMap['div1'];
	      div2 = divParamMap['div2'];
	      div3 = divParamMap['div3'];
	      div4 = divParamMap['div4'];
	      div5 = divParamMap['div5'];
	    }
	    $.ajax({
	      url : "/common/system/code/getCommonCodeList.do"
	      ,data : {
	        'CMMN_CD' : cmmn_cd
	        ,'DIV1' : div1
	        ,'DIV2' : div2
	        ,'DIV3' : div3
	        ,'DIV4' : div4
	        ,'DIV5' : div5
	        ,'USE_YN' : useYn  // 추가 
	      }
	      ,method : "POST"
	      ,dataType : "JSON"
	      ,success : function(data){
	        if(data.isError){
	          $erp.ajaxErrorMessage(data);
	        } else {      
	          var commonCodeList = data.commonCodeList;
	          var optionArray1 = [];   
	          var optionArray2 = [];  
	        
	          for(var i in commonCodeList){
	            var commonCodeObj = commonCodeList[i];            
	            var optionValue = { };
	            var optionText = {};
	            for(var key in commonCodeObj){
	              var value =  commonCodeObj[key];
	              if(key == 'CMMN_DETAIL_CD'){  /* CMMN_DETAIL_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
	            	  //optionValue.value = value;
	            	  optionArray1.push(value);
	              } else if(key == 'CMMN_DETAIL_CD_NM'){ /* CMMN_DETAIL_CD_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
	            	 // optionText.text = value;
	            	  optionArray2.push(value); 
	              } 
	            }
	          }
	          //alert('kkk');
	          dhtmlXRadioObject = $erp.getDhtmlXRadio(domElementId,paramName,optionArray1,checkPosition,optionArray2,labelPosition,shape);
	          dhtmlXRadioObject.attachEvent("onChange", function(name, value){
	        	  callbackFunction(value);
	      	  });
	          
	          
	        }
	      }, error : function(jqXHR, textStatus, errorThrown){
	        $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
	      }
	   });
	}
	
	/** 
	* Description 
	* @function dataSerializeOfGridRow
	* @function_Description 해당 행의 모든 컬럼명과 컬럼의 값을 {key : value}로 직렬화함 
	* @param dhtmlXGridObj (Object) / DhtmlX grid 객체
	* @param rowId / (- 행) 번호
	* @param isUseLUI / (boolean) 그리드 직렬화시 lui 정보 삽입 여부
	* @param addData / (Object) 그리드 직렬화시 추가할 데이터
	* @author 조승현
	*/
	this.dataSerializeOfGridRow = function(dhtmlXGridObj,rowId,isUseLUI,addData){ 
		
		if(dhtmlXGridObj == undefined || dhtmlXGridObj == null){
			$erp.alertMessage({
				"alertMessage" : "그리드 객체가 필요합니다.",
				"alertCode" : "1번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}
		var dhtmlXDataProcessor = dhtmlXGridObj.getDataProcessor();

		var column_count = dhtmlXGridObj.getColumnsNum();
		var send_data = {};
		
		send_data["rowId"] = rowId;
		
		if(dhtmlXDataProcessor){
			var state = dhtmlXDataProcessor.getState(rowId);
			var send_CRUD = "R";
			if(state == "inserted"){
				send_CRUD = "C";
			} else if (state == "updated"){
				send_CRUD = "U";
			} else if (state == "deleted") {
				send_CRUD = "D";
			} 
			send_data["CRUD"] = send_CRUD;
		}
		
		//console.log("↓↓↓dataSerializeOfGridRow↓↓↓");
		for (var idx = 0; idx < column_count; idx++){
			var column_name = dhtmlXGridObj.getColumnId(idx);
			var column_value = dhtmlXGridObj.cells(rowId, idx).getValue();
			send_data[column_name] = column_value;
		}
		
		if(isUseLUI == true && window.LUI){
			send_data = $erp.unionObjArray([send_data,window.LUI]);
		}
		
		if(addData){
			if(addData.constructor == Object){
				send_data = $erp.unionObjArray([send_data,addData]);
			}else{
				throw new Error("객체 타입이 아닙니다.");
			}
		}
		
		//console.log(send_data);
		//console.log("↑↑↑dataSerializeOfGridRow↑↑↑");
		return send_data;
	}
	
	/** 
	* Description 
	* @function dataSerializeOfGrid
	* @function_Description 해당 그리드의 모든 행의 모든 컬럼명과 컬럼의 값을 {key : value}로 직렬화함 
	* @param dhtmlXGridObj (Object) / DhtmlX grid 객체
	* @param isUseLUI / (boolean) 그리드 직렬화시 lui 정보 삽입 여부
	* @param addData / (Object) 그리드 직렬화시 추가할 데이터
	* @author 조승현
	*/
	this.dataSerializeOfGrid = function(dhtmlXGridObj,isUseLUI,addData){
		
		if(dhtmlXGridObj == undefined || dhtmlXGridObj == null){
			$erp.alertMessage({
				"alertMessage" : "그리드 객체가 필요합니다.",
				"alertCode" : "1번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}
		var dhtmlXDataProcessor = dhtmlXGridObj.getDataProcessor();

		var row_count = dhtmlXGridObj.getRowsNum();
		var column_count = dhtmlXGridObj.getColumnsNum();
		var send_data = [];
		
		//console.log("↓↓↓dataSerializeOfGrid↓↓↓");
		var rId;
		var state;
		var send_CRUD;
		var column_name;
		var column_value;
		for(var row_idx = 0; row_idx < row_count; row_idx ++){
			send_data.push({});
			rId = dhtmlXGridObj.getRowId(row_idx);
			if(rId == "NoDataPrintRow"){
				return [];
			}
			send_data[row_idx]["rowId"] = rId;
			
			if(dhtmlXDataProcessor){
				state = dhtmlXDataProcessor.getState(rId);
				send_CRUD = "R";
				if(state == "inserted"){
					send_CRUD = "C";
				} else if (state == "updated"){
					send_CRUD = "U";
				} else if (state == "deleted") {
					send_CRUD = "D";
				} 
				send_data[row_idx]["CRUD"] = send_CRUD;
			}
			
			for (var col_idx = 0; col_idx < column_count; col_idx++){
				column_name = dhtmlXGridObj.getColumnId(col_idx);
				column_value = dhtmlXGridObj.cells(rId, col_idx).getValue();
				/*console.log(column_name);
				console.log(column_value);
				console.log(row_idx);
				console.log(col_idx);*/
				send_data[row_idx][column_name] = column_value;
			}
			
			if(isUseLUI == true && window.LUI){
				send_data[row_idx] = $erp.unionObjArray([send_data[row_idx],window.LUI]);
			}
			
			if(addData){
				if(addData.constructor == Object){
					send_data[row_idx] = $erp.unionObjArray([send_data[row_idx],addData]);
				}else{
					throw new Error("객체 타입이 아닙니다.");
				}
			}
		}
		//console.log(send_data);
		//console.log("↑↑↑dataSerializeOfGrid↑↑↑");
		return send_data;
	}
	
	/** 
	* Description 
	* @function dataSerializeOfGridByMode
	* @function_Description 모드에 따라 그리드에서 행의 컬럼명과 컬럼의 값을 {key : value}로 직렬화하고 CRUD 를 구분함
	* @param dhtmlXGridObj (Object) / DhtmlX grid 객체
	* @param mode (String) / all, checked, selected, updated, stateExcludeValue
	* @param isUseLUI / (boolean) 그리드 직렬화시 lui 정보 삽입 여부
	* @param addData / (Object) 그리드 직렬화시 추가할 데이터
	* @author 조승현
	*/
	this.dataSerializeOfGridByMode = function(dhtmlXGridObj,mode,isUseLUI,addData,excludeValuesOfColumns){ 
//		console.log("↓↓↓dataSerializeOfGridByMode↓↓↓");
		if(dhtmlXGridObj == undefined || dhtmlXGridObj == null){
			$erp.alertMessage({
				"alertMessage" : "그리드 객체가 필요합니다.",
				"alertCode" : "1번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}
		var dhtmlXDataProcessor = dhtmlXGridObj.getDataProcessor();
		
		var updatedRows = [];
		
		if(mode != undefined && mode != null){
			if(mode == "all"){ // 모두
				var row_count = dhtmlXGridObj.getRowsNum();
				for(var i = 0; i < row_count; i++){
					var rId = dhtmlXGridObj.getRowId(i);
					updatedRows.push(rId);
				}
				
			}else if(mode == "checked"){//그리드 컬럼의 아이디가 CHECK인 로우들에서 체크된 것만
				var checked = dhtmlXGridObj.getCheckedRows(dhtmlXGridObj.getColIndexById("CHECK"));
				if(checked != ""){
					updatedRows = checked.split(",");
				}
			}else if(mode == "selected"){
//				var selectedRow = dhtmlXGridObj.getSelectedCellIndex(); //셀렉된 로우가 있을때는 0 아닐때는 -1
//				if(selectedRow != -1){
//					updatedRows = [dhtmlXGridObj.selectedRows[0].idd]; //선택된 로우 인덱스
//				}
				var selectedRows = dhtmlXGridObj.getSelectedRowId();
				if(selectedRows){
					updatedRows = selectedRows.split(",");
				}
			}else if(mode == "updated"){//dataProcessor가 자체적으로 가지고있는 update state 상태의 rows 들
				updatedRows = dhtmlXDataProcessor.updatedRows; 
			}else if(mode == "stateExcludeValue"){//해당 컬럼들이 가진 값이 업데이트를 하면 안되는 값인지 체크 하여 데이터 추출에서 제외
				if(excludeValuesOfColumns == undefined || excludeValuesOfColumns == null){
					$erp.alertMessage({
						"alertMessage" : "업데이트 제외 로우 체크용 <br>컬럼:값 객체가 없습니다."
						, "alertCode" : "객체 매개변수 필요"
						, "alertType" : "error"
						, "isAjax" : false
					});
					return;
				}
				updatedRows = dhtmlXDataProcessor.updatedRows;
				updatedRowsFilterOut = [];
				var rowId;
				var validate_check;
				var columnIndex;
				var gridRowAndColumnValue;
				var excludeValues;
				for(i in updatedRows){
					rowId = updatedRows[i];
					validate_check = true;
					for(columnId in excludeValuesOfColumns){ // 한 로우에서 대상 컬럼들의 값들을 체크해 업데이트 로우리스트에 추가해야하는지 결정
						columnIndex = dhtmlXGridObj.getColIndexById(columnId);
						gridRowAndColumnValue = dhtmlXGridObj.cells(rowId,columnIndex).getValue();
						excludeValues = excludeValuesOfColumns[columnId]
						
						if($erp.isArray(excludeValues)){ 
							for(i in excludeValues){// 업데이트 제외 대상 값 배열안에 있는 것중 하나라도 있다면 제외
								if(gridRowAndColumnValue == excludeValues[i]){
									//console.log("gridRowAndColumnValue : " + gridRowAndColumnValue);
									//console.log("excludeValues[i] : " + excludeValues[i]);
									validate_check = false;
								}
							}
						}else{
							if(gridRowAndColumnValue == excludeValues){//업데이트 제외 대상 값이면 제외
								validate_check = false;
							}
						}
					}
					if(validate_check == true){ // 업데이트 대상이라면
						updatedRowsFilterOut.push(rowId);
					}
				}
				updatedRows = updatedRowsFilterOut;
				//console.log("업데이트 로우 확인 : " + updatedRowsFilterOut);
			}
		}
		
		if(updatedRows.length <= 0){
//			console.log("↑↑↑조건에 해당하는 추출할 로우 없음↑↑↑");
//			console.log("↑↑↑dataSerializeOfGridByMode↑↑↑");
			return [];
		}
		
		var send_data = [];
		var column_count = dhtmlXGridObj.getColumnsNum();
		var rId;
		var state;
		var send_CRUD;
		var isDataColumn;
		var column_name;
		var column_value;
		for(var i = 0; i < updatedRows.length ; i++){
			send_data.push({});
			rId = updatedRows[i];
			if(rId == "NoDataPrintRow"){
				return [];
			}
			send_data[i]["rowId"] = rId;
			
			if(dhtmlXDataProcessor){
				state = dhtmlXDataProcessor.getState(rId);
				send_CRUD = "R";
				if(state == "inserted"){
					send_CRUD = "C";
				} else if (state == "updated"){
					send_CRUD = "U";
				} else if (state == "deleted") {
					send_CRUD = "D";
				} 
				send_data[i]["CRUD"] = send_CRUD;
			}
			
			for(var col_idx = 0; col_idx < column_count; col_idx++){
				isDataColumn = dhtmlXGridObj.columnsMapArray[col_idx].isDataColumn;
				if(isDataColumn === false){
					continue;
				}
				column_name = dhtmlXGridObj.getColumnId(col_idx);
				column_value = dhtmlXGridObj.cells(rId, col_idx).getValue();
				/*console.log(column_name);
				console.log(column_value);
				console.log(row_idx);
				console.log(col_idx);*/
				send_data[i][column_name] = column_value;
			}
			
			if(isUseLUI == true && window.LUI){
				send_data[i] = $erp.unionObjArray([send_data[i],window.LUI]);
			}
			
			if(addData){
				if(addData.constructor == Object){
					send_data[i] = $erp.unionObjArray([send_data[i],addData]);
				}else{
					throw new Error("객체 타입이 아닙니다.");
				}
			}
		}
//		console.log(send_data);
//		console.log("↑↑↑dataSerializeOfGridByMode↑↑↑");
		return send_data;
	}
		
	
	
	/** 
	* Description 
	* @function dataGetOnGridEvent
	* @function_Description 그리드에서 이벤트 발생시 일반 함수, DB 사용 함수 실행
	* @param dhtmlXGridObj (Object) / DhtmlX grid 객체
	* @param event (Object) / 그리드에서 발생한 이벤트
	* @param rowId / (- 행) 번호
	* @param columnIdx / (| 열) 번호
	* @author 조승현
	*/
	this.dataGetOnGridEvent = function(dhtmlXGridObj,event,rowId,columnIdx,layout,value){ //value:이벤트 마다 있을수도 없을수도 있는 Unique value
		
		if(event.func != undefined && event.func != null && typeof event.func === "function" ){ // 일반 함수 실행
			event.func(dhtmlXGridObj,rowId,columnIdx,value);
		}
		if(event.db_func != undefined && event.db_func != null && typeof event.db_func === "object" ){ // DB 사용 함수 실행
			
			var check_use_url = (event.db_func.use_url != undefined && event.db_func.use_url != null && typeof event.db_func.use_url === "string") ? true : "use_url 선언이 잘못 되었습니다." ;
			var check_send_data = (event.db_func.send_data != undefined && event.db_func.send_data != null && typeof event.db_func.send_data === "function") ? true : "send_data 선언이 잘못 되었습니다." ;
			var check_if_success = (event.db_func.if_success != undefined && event.db_func.if_success != null && typeof event.db_func.if_success === "function") ? true : "if_success 선언이 잘못 되었습니다." ;
			var check_if_error = (event.db_func.if_error != undefined && event.db_func.if_error != null && typeof event.db_func.if_error === "function") ? true : "if_error 선언이 잘못 되었습니다." ;
			
			if(check_send_data == true && check_use_url == true && check_if_success == true && check_if_error == true){
				layout.progressOn();
			    $.ajax({
				    url : event.db_func.use_url
				    ,data : event.db_func.send_data(dhtmlXGridObj,rowId,columnIdx)
				    ,method : "POST"
				    ,dataType : "JSON"
				    ,success : function(data){
				    	layout.progressOff();
		    		    if(data.isError){
		    		    	$erp.ajaxErrorMessage(data);
		    		    }else{
			    		    if($erp.isEmpty(data.dataMap)){
			    		    	//검색 결과 없음
			    		    	console.log("검색 결과 없음");
			    		    }else{
			    		    	event.db_func.if_success(dhtmlXGridObj,rowId,columnIdx,data);
			    		    }
		    		    }
				    }, error : function(jqXHR, textStatus, errorThrown){
				    	layout.progressOff();
				    	event.db_func.if_error(dhtmlXGridObj,rowId,columnIdx);
		    		    $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				    }
			    });
			}else{
				var alert_message_list = [check_use_url, check_send_data, check_if_success, check_if_error];
				var alert_message = item_list[i]["text"] + " 그리드 이벤트의 db_func 객체 내부 : \n";
				for(i in alert_message_list){
					if(alert_message_list[i] != true){
						alert_message += alert_message_list[i] +"\n";
					}
				}
				alert(alert_message);
			}
			
			
		}
	}
	
	
	/** 
	* Description 
	* @function initGrid
	* @function_Description DhtmlXGrid 임의로 생성된 Column 데이터 생성 (isHidden : 숨김, isEssential : 필수 컬럼 강조, type : dhxCalendar, dhxCalendarA가 있을 경우 포맷 설정)
	* @param dhtmlXGridObj (Object) / DhtmlXGrid Object
	* @param option (Object) / 추가 옵션 선언 (
	* 											rowSize : 페이징 사이즈 (int)
	* 											, multiSelect : 그리드 멀티셀렉 사용 여부 (true/false)
	* 											, disableProcessor : 그리드 데이타프로세서 사용 여부 (true/false)
	* 											, useAutoAddRowPaste : 그리드 붙여넣기시 로우 자동 증가 사용 여부 (true/false)
	* 											, standardColumnId : (string) 중복 검사 기준으로 사용할 컬럼 Id
	* 											, isParseDataDuplicateCheck : (boolean) 그리드 조회시 중복데이터 검사 사용 여부
	* 											, setDuplicationAlertMessageFunction : (function) 중복 데이터 알림 메세지 세팅 함수 (*****리턴값을 메세지로 사용한다*****) => 함수 정의시 파라미터로 1:중복검사열 이름, 2:중복발생값을 전달 받을 수 있음
	* 											, deleteDuplication : (boolean) 중복 제거 여부
	* 											, overrideDuplication : (boolean) 중복 로우 오버라이드 여부
	* 											, editableColumnIdListOfInsertedRows (Array) / inserted 상태 로우의 수정 가능한 컬럼 Id 리스트
	* 											, notEditableColumnIdListOfInsertedRows (Array) / inserted 상태 로우의 수정 불가능한 컬럼 Id 리스트
	* 										  )
	* @author 조승현
	*/
	this.initGrid = function(dhtmlXGridObj, option){
		var isDhxCalendar = false;
		  
		//그리드 컬럼 색깔 배열
		var dhtmlXGridCoulmnColorArray = [];  
		//그리드 객체 컬럼 배열
		var dhtmlXGridColumnArray = dhtmlXGridObj.columnsMapArray;
		   
		//그리드 객체 컬럼 배열이 없으면 리턴
		if(dhtmlXGridColumnArray == undefined || dhtmlXGridColumnArray == null || dhtmlXGridColumnArray.length == 0){
			return false;
		} 
		
		//분할 파싱
		dhtmlXGridObj.enableDistributedParsing(true, 100, 50);
			    
		//그리드 컬럼 배열 순회
		//히든여부, 색깔, 캘린더
		for(var i in dhtmlXGridColumnArray){
			var dhtmlXGridColumn = dhtmlXGridColumnArray[i];
			var isHidden = dhtmlXGridColumn.isHidden;
			if(isHidden != undefined && isHidden != null && isHidden == true){
				dhtmlXGridObj.setColumnHidden(i, true);
			}
			
			var isEssential = dhtmlXGridColumn.isEssential;
			if(isEssential != undefined && isEssential != null && isEssential == true){
//				dhtmlXGridCoulmnColorArray.push("WhiteSmoke");
				dhtmlXGridCoulmnColorArray.push("#FFFFE4");
			}else{
				dhtmlXGridCoulmnColorArray.push("");
			}
			    
			var type = dhtmlXGridColumn.type;
			//타입 존재
			if(type != undefined && type != null){
				//타입 캘린더
				if(isDhxCalendar === false && (type == "dhxCalendar" || type == "dhxCalendarA")){
					dhtmlXGridObj.setDateFormat("%Y-%m-%d", "%Y%m%d"); 
					dhtmlXGridObj.attachEvent("onDhxCalendarCreated", function (calObject) {
					calObject.setSensitiveRange("1900-01-01", "2999-12-31");
					calObject.hideTime();         
				});
				isDhxCalendar = true;
				}
			}
		}
	    
	    //그리드 컬럼 컬러 배열 존재시
	    if(dhtmlXGridCoulmnColorArray.length > 0){
	    	var strDhtmlXGridCoulmnColor = dhtmlXGridCoulmnColorArray.join(",");
	    	//console.log(strDhtmlXGridCoulmnColor);
	    	dhtmlXGridObj.setColumnColor(strDhtmlXGridCoulmnColor);
	    }
	    
		if(option && option.standardColumnId && typeof option.standardColumnId == "string"){
			dhtmlXGridObj.standardColumnId = option.standardColumnId;
		}
		
		if(option && typeof option.isParseDataDuplicateCheck == "boolean"){
			dhtmlXGridObj.isParseDataDuplicateCheck = option.isParseDataDuplicateCheck;
		}
		
		if(option && option.setDuplicationAlertMessageFunction && typeof option.setDuplicationAlertMessageFunction == "function"){
			dhtmlXGridObj.setDuplicationAlertMessageFunction = option.setDuplicationAlertMessageFunction;
		}
	    
	    //그리드 선택후 키보드 프레스시
	    var onKeyPressed;
	    if(option && option.usePaste && option.usePaste == true){
	    	onKeyPressed = function(code,ctrl,shift){
			    //컨트롤 + c
			    if(code==67&&ctrl){
				    if (!this._selectionArea) {
				    	return;
				    }
				    this.setCSVDelimiter("\t");
				    this.copyBlockToClipboard();
			    }
			    if(code==86&&ctrl){
				    this.setCSVDelimiter("\t");
				    this.pasteBlockFromClipboard();
			    }
			    return true;
		    }
	    }else if(option && option.useAutoAddRowPaste && option.useAutoAddRowPaste == true){
	    	onKeyPressed = function(code,ctrl,shift){
			    //컨트롤 + c
			    if(code==67&&ctrl){
				    if (!this._selectionArea) {
				    	return;
				    }
				    this.setCSVDelimiter("\t");
				    this.copyBlockToClipboard();
			    }
			    if(code==86&&ctrl){
				    this.setCSVDelimiter("\t");
//				    if(option && option.standardColumnId && typeof option.standardColumnId == "string"){
//				    	//디폴트 중복 제거 사용 안함
//				    	if(option && option.deleteDuplication && option.deleteDuplication == true){
				    this.autoAddRowPasteBlockFromClipboard(option.standardColumnId, option.deleteDuplication, option.overrideDuplication, option.editableColumnIdListOfInsertedRows, option.notEditableColumnIdListOfInsertedRows);
//				    	}else{
//				    		this.autoAddRowPasteBlockFromClipboard(option.standardColumnId, false);
//				    	}
//				    }else{
//				    	this.autoAddRowPasteBlockFromClipboard();
//				    }
				    
			    }
			    return true;
		    }
	    }else{
	    	onKeyPressed = function(code,ctrl,shift){
			    //컨트롤 + c
			    if(code==67&&ctrl){
				    if (!this._selectionArea) {
				    	return;
				    }
				    this.setCSVDelimiter("\t");
				    this.copyBlockToClipboard();
			    }
			    return true;
		    }
	    }
	    
	    //그리드 블록 선택 사용
	    dhtmlXGridObj.enableBlockSelection();   
	    dhtmlXGridObj.attachEvent("onKeyPress",onKeyPressed);
	    if(dhtmlXGridObj._fake){
	    	dhtmlXGridObj._fake.enableBlockSelection();
	    	dhtmlXGridObj._fake.attachEvent("onKeyPress",onKeyPressed);
	    }
	    
	    //그리드 컬럼 배열 순회
	    //공통코드 콤보
	    $erp.initGridComboCell(dhtmlXGridObj);
	    
	    dhtmlXGridObj.enableAccessKeyMap(); // 키보드로 단축키로 할수 있는 행위들을 사용하겠다
	    
	    if(option && option.rowSize){
    		$erp.attachDhtmlXGridFooterPaging(dhtmlXGridObj, option.rowSize);
	    }else{
	    	$erp.attachDhtmlXGridFooterPaging(dhtmlXGridObj, 100); //기본 로우 100 세팅
	    }
	    
	    if(option && option.multiSelect){
	    	dhtmlXGridObj.enableMultiselect(option.multiSelect);
	    }
	    
	    if(option && option.disableProcessor && option.disableProcessor == true){
	    	return null;
	    }else{
	    	var gridDataProcessor = new dataProcessor();
		    gridDataProcessor.init(dhtmlXGridObj); //데이터 프로세스를 사용할 컴포넌트 지정
		    gridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다
			$erp.setGridColumnsUpdateConfig(dhtmlXGridObj);
			$erp.attachDhtmlXGridFooterRowCount(dhtmlXGridObj, "전체 행 수");

		    return gridDataProcessor;
	    }
	}
	
	
	
	/** 
	* Description 
	* @function getPrefixAndNameMap
	* @function_Description 특정 Dom 하위 노드 id에 해당되는 prefix가 존재할 시 name, type 추출
	* @param domObj (object) 하위 노드를 검색할 대상 돔 객체
	* @param map / 반환 및 재귀 함수를 위한 map
	* @author 조승현
	*/
	this.getPrefixAndNameMap = function(domObj, map){
		if($erp.isEmpty(map)){
			map = {};
		} 
		if(domObj && domObj.childNodes){
			for(var i in domObj.childNodes){
				var child = domObj.childNodes[i];
				if(child.attributes && child.attributes.id && child.attributes.id.value){
					var id = child.attributes.id.value;
					var prefix = id.length >= 3 ? id.substring(0, 3) : id;
					if(prefix == "cmb" || prefix == "rdo" || prefix == "chk" || prefix == "txt"){
						var name = id.substring(3,id.length);
						if(name != ""){
							map[prefix+name] = {"prefix":prefix, "name":name};
							//console.log("prefix : " + prefix);
							//console.log("name : " + name);
						}else{
							//console.log("name 없음");
						}
					}else{
						//console.log("유효한 prefix 없음 : " + prefix);
					}
				}
				if(child.childNodes){
					$erp.getPrefixAndNameMap(child, map);
				}
			}
		}
		
		return map;
	}
	
	
	/** 
	* Description 
	* @function dataAutoBind
	* @function_Description 데이터 Map을 Dom 객체에 바인딩, 바인딩할 객체를 찾을 시에는 id 를 사용함
	* @param domObj (object) / 하위 노드에 데이터를 바인딩할 대상 돔 객체
	* @param dataMap (object) / ajax 를 이용한후 response 된 데이터
	* @param isOnlyExistKey (boolean) / 서버에서 전송되지 않은 데이터들은 기본 값으로 초기화 조차 하지 않음
	* @author 조승현
	*/
	this.dataAutoBind = function(domObj, dataMap){
		var map = null;
		
		//console.log("↓↓↓dataAutoBind↓↓↓");
		if(!$erp.isEmpty(domObj)){
			if(typeof domObj === 'string'){
				domObj = document.getElementById(domObj);
			}     
			if(!$erp.isEmpty(domObj)){
				map = $erp.getPrefixAndNameMap(domObj);
			}
			
			if(typeof dataMap === 'object' && !$erp.isArray(dataMap)){
				for(var id in map){
					var value = dataMap[map[id].name];
					if(value === undefined){ //서버에서 리턴받은 데이터에 해당 키가 존재조차 하지 않는다면 continue
						continue;
					}
					value = dataMap[map[id].name] == null ? "" : dataMap[map[id].name];
					//console.log(map[id].name + " : " + value);
					var one_in_map = map[id];
					if(one_in_map != undefined && one_in_map != null){
						var prefix = one_in_map.prefix;
						var name = one_in_map.name;
						
						//console.log("prefix : " + prefix);
						//console.log("name : " + name)
						var obj;
						
						if(prefix == "cmb"){
							obj = $erp.getObjectFromId(prefix+name);
							if(obj != undefined && obj != null){
								if(obj.conf.opts_type === "checkbox"){
									$erp.setMultiCheckComboValue(obj, value);
								}else{
									obj.setComboValue(value);
									obj['event_end_hidden_value'] = value; //지역 => 팀명 처럼 연계 사용시 이용
								}
							}
						}else if(prefix == "rdo"){
							obj = $erp.getObjectFromId(prefix+name);
							if(obj != undefined && obj != null){
								obj.checkItem(name,value); //radio 는 name 이용
								
								if(obj.dhxevs.data.onchange){
									for(var key in obj.dhxevs.data.onchange){
										var func = obj.dhxevs.data.onchange[key];
										if(typeof func ==="function"){
											func(name, value, "callEvent");
										}
									}
								}
							}
						}else if(prefix == "chk"){
							obj = $erp.getObjectFromId(prefix+name);
							if(obj != undefined && obj != null){
								if(value == 'Y' || value == '1'){
									obj.checkItem(prefix+name);
									
									if(obj.dhxevs.data.onchange){
										for(var key in obj.dhxevs.data.onchange){
											var func = obj.dhxevs.data.onchange[key];
											if(typeof func ==="function"){
												func(prefix+name, value, "callEvent");
											}
										}
									}
								}else if(value == 'N' || value == '0'){
									obj.uncheckItem(prefix+name);
									
									if(obj.dhxevs.data.onchange){
										for(var key in obj.dhxevs.data.onchange){
											var func = obj.dhxevs.data.onchange[key];
											if(typeof func ==="function"){
												func(prefix+name, value, "callEvent");
											}
										}
									}
								}
							}
						}else if(prefix == "txt"){
							obj = document.getElementById(prefix+name);
							if(obj != undefined && obj != null){
								if(obj.className && obj.className.indexOf("input_money") > -1){
									obj.value = $erp.convertToMoney(value);
						        }else if(obj.className && obj.className.indexOf("input_phone") > -1){
						        	obj.value = $erp.getPhoneNumberHyphen(value);
						        }else{
						        	obj.value = value;
						        }
								
								var dataType = obj.getAttribute("data-type");
								if(dataType){
									if(dataType == "businessNum"){
										obj.value = $erp.getBusinessNum(value);
									}
								}
							}
						}
					}
				}
			}
		}
		//console.log("↑↑↑dataAutoBind↑↑↑");
	}
	
	/** 
	* Description 
	* @function dataSerialize
	* @function_Description 특정 DOM 하위 노드를 검색하여 하위 노드 현재 값들을 { key : value } 형태로 직렬화 
	* 						값을 가져올때는 id 를 이용하지만 key 는 name 으로 사용
	* @param domObj (Object) / DOM Object;
	* @param checkDefaultValueType / 체크박스 디폴트 값 타입
	* @param useNullValue / "" 값을 null 값으로 리턴 사용 여부 true:false
	* @param dataObject (Object) / 재귀 함수용
	* @author 조승현
	*/
	this.dataSerialize = function(domObj, checkDefaultValueType, useNullValue, dataObject){
		if($erp.isEmpty(dataObject)){
			dataObject = {};
		}
		    
		if(!$erp.isEmpty(domObj)){
			if(typeof domObj === 'string'){
				domObj = document.getElementById(domObj);
			}     
		}
		
		if(domObj && domObj.childNodes){
			var child;
			var id;
			var value;
			var prefix;
			var name;
			var obj;
			for(var i in domObj.childNodes){
				child = domObj.childNodes[i];
				if(child){
					if(child.attributes && child.attributes.id && child.attributes.id.value){
						id = child.attributes.id.value;
						value = "";       
						prefix = id.length >= 3 ? id.substring(0, 3) : id;
						name = id.substring(3,id.length);
						if(prefix == "cmb" || prefix == "rdo" || prefix == "chk" || prefix == "txt"){
							if(name != ""){
								if(prefix == "cmb"){
									obj = $erp.getObjectFromId(prefix+name);
									if(obj != undefined && obj != null){
										if(obj.conf.opts_type === "checkbox"){
											value = $erp.getMultiCheckComboValue(obj);
										}else{
											value = obj.getSelectedValue();
										}
									}
									if(useNullValue == true){
										if(value == ""){
											value = null;
										}
									}
								} else if(prefix == "rdo"){
									obj = $erp.getObjectFromId(prefix+name);
									if(obj != undefined && obj != null){
										value = obj.getCheckedValue(name);
									}
									if(useNullValue == true){
										if(value == ""){
											value = null;
										}
									}
								} else if(prefix == "chk"){
									obj = $erp.getObjectFromId(prefix+name);
									if(obj != undefined && obj != null){
										if(checkDefaultValueType == "Q" || checkDefaultValueType == undefined || checkDefaultValueType == null){
											value = obj.isItemChecked(prefix+name)? 'Y' : 'N';
										}else if(checkDefaultValueType == "bit"){
											value = obj.isItemChecked(prefix+name)? '1' : '0';
										}else if(checkDefaultValueType == "boolean"){
											value = obj.isItemChecked(prefix+name)? true : false;
										}
									}
									if(useNullValue == true){
										if(value == ""){
											value = null;
										}
									}
								} else if(prefix == "txt"){
									obj = document.getElementById(id)
									if(obj != undefined && obj != null){
										value = obj.value
										if(obj.className && obj.className.indexOf("input_money") > - 1){
											value = value.replace(/,/g, "");
										}else if(obj.className && obj.className.indexOf("input_phone") > - 1){
											value = value.replace(/-/g, "");
										}
										
										var dataType = obj.getAttribute("data-type");
										if(dataType){
											if(dataType == "businessNum"){
												value = $erp.getBackBusinessNum(value);
											}
										}
										
										if(useNullValue == true){
											if(value == ""){
												value = null;
											}
										}
									}
								}
								dataObject[name] = value;
								//console.log(name + " : " + value);
							}
						}
					}
					if(child.childNodes){
						$erp.dataSerialize(child, checkDefaultValueType, useNullValue, dataObject);
					}
				}
			}
		}
		return dataObject;
	}


	/** 
	* Description 
	* @function dataClear
	* @function_Description Dom Object 하위 노드 모두 리셋
	* @param domObj (Object) domObj 하위 노드에 있는 것 모두 리셋
	* @author 조승현
	*/
	this.dataClear = function(domObj){
		var map = null;
		if(!$erp.isEmpty(domObj)){
			if(typeof domObj === 'string'){
				domObj = document.getElementById(domObj);
			}     
			if(!$erp.isEmpty(domObj)){
				map = $erp.getPrefixAndNameMap(domObj);
			}
			
			for(id in map){
				var prefix = map[id].prefix;
				var name = map[id].name;
				if(prefix == "cmb"){
					obj = $erp.getObjectFromId(prefix+name);
					if(obj != undefined && obj != null){
						//old
						//obj.setComboValue("");
						
						//new
						var combo_first_text = obj.getList().childNodes[0].firstChild.innerHTML; // 콤보 리스트의 첫번째 텍스트
						combo_first_text = combo_first_text.replace("&nbsp;"," ");
						obj.setComboText(combo_first_text); // 첫번째 텍스트로 선택
						obj['event_end_hidden_value'] = ""; //지역 => 팀명 처럼 연계 사용시 이용
					}
				}else if(prefix == "rdo"){
					obj = $erp.getObjectFromId(prefix+name);
					if(obj != undefined && obj != null){
						obj.checkItem(name,"0"); //radio 는 name 이용
					}
				}else if(prefix == "chk"){
					obj = $erp.getObjectFromId(prefix+name);
					if(obj != undefined && obj != null){
						obj.uncheckItem(prefix+name);
					}
				}else if(prefix == "txt"){
					obj = document.getElementById(prefix+name);
					if(obj != undefined && obj != null){
						obj.value = "";
					}
				}
			}
		}
	}
	
	
	/** 
	* Description 
	* @function tableReadonly
	* @function_Description Dom Object 하위 노드 모두 readonly 처리
	* @param domObj (Object) 테이블 객체
	* @author 조승현
	*/
	this.tableReadonly = function(domObj){
		var map = null;
		if(!$erp.isEmpty(domObj)){
			if(typeof domObj === 'string'){
				domObj = document.getElementById(domObj);
			}     
			if(!$erp.isEmpty(domObj)){
				map = $erp.getPrefixAndNameMap(domObj);
			}
			
			for(id in map){
				var prefix = map[id].prefix;
				var name = map[id].name;
				if(prefix == "cmb"){
					obj = $erp.getObjectFromId(prefix+name);
					if(obj != undefined && obj != null){
						obj.disable();
					}
				}else if(prefix == "rdo"){
					obj = $erp.getObjectFromId(prefix+name);
					if(obj != undefined && obj != null){
						var text_array = [];
						var value_array = [];
						for(var i = 0; i<obj.base.length; i++){
							if(i != obj.base.length -1){
								text_array.push(obj.base[i].childNodes[0].innerText);
								value_array.push(obj.base[i].childNodes[0]._value);
							}
						}
						for(i in value_array){
							obj.disableItem(name,value_array[i]);
						}
					}
				}else if(prefix == "chk"){
					obj = $erp.getObjectFromId(prefix+name);
					if(obj != undefined && obj != null){
						obj.disableItem(prefix+name);
					}
				}else if(prefix == "txt"){
					obj = document.getElementById(prefix+name);
					if(obj != undefined && obj != null){
						obj.readOnly=true;
						obj.disabled=true;
						obj.classList.add("input_readonly");
						//obj.setAttribute("class", "input_readonly");
					}
				}
			}
		}
	}
	
	/** 
	* Description 
	* @function tableNotReadonly
	* @function_Description Dom Object 하위 노드 모두 readonly 처리 삭제
	* @param domObj (Object) 테이블 객체
	* @author 조승현
	*/
	this.tableNotReadonly = function(domObj){
		var map = null;
		if(!$erp.isEmpty(domObj)){
			if(typeof domObj === 'string'){
				domObj = document.getElementById(domObj);
			}     
			if(!$erp.isEmpty(domObj)){
				map = $erp.getPrefixAndNameMap(domObj);
			}
			
			for(id in map){
				var prefix = map[id].prefix;
				var name = map[id].name;
				if(prefix == "cmb"){
					obj = $erp.getObjectFromId(prefix+name);
					if(obj != undefined && obj != null){
						obj.enable();
					}
				}else if(prefix == "rdo"){
					obj = $erp.getObjectFromId(prefix+name);
					if(obj != undefined && obj != null){
						var text_array = [];
						var value_array = [];
						for(var i = 0; i<obj.base.length; i++){
							if(i != obj.base.length -1){
								text_array.push(obj.base[i].childNodes[0].innerText);
								value_array.push(obj.base[i].childNodes[0]._value);
							}
						}
						for(i in value_array){
							obj.enableItem(name,value_array[i]);
						}
					}
				}else if(prefix == "chk"){
					obj = $erp.getObjectFromId(prefix+name);
					if(obj != undefined && obj != null){
						obj.enableItem(prefix+name);
					}
				}else if(prefix == "txt"){
					obj = document.getElementById(prefix+name);
					if(obj != undefined && obj != null){
						obj.readOnly=false;
						obj.disabled=false;
						//obj.removeAttribute("class", "input_readonly");
					}
				}
			}
		}
	}
	
	/** 
	* Description 
	* @function inputControl
	* @function_Description Input 태그 객체 입력 제어
	* @param domObj (Object) Input 태그 객체
	* @param type (String) 입력 type
	* @param maxlength (String) 입력 최대길이
	* @author 조승현
	*/
	this.inputControl = function(domObj, maxLength, type){
		
		if(!$erp.isEmpty(domObj)){
			if(typeof domObj === 'string'){
				domObj = document.getElementById(domObj);
			}
			
			if(maxLength != undefined && maxLength != null){
				domObj.maxLength = maxLength;
			}
			
			var functionkey = [8,  //backspace
								 9,  //tab
								 12, //num lock 누르기전 키보드 오른쪽 숫자 5
								 13, //enter
								 16, //shift
								 17, //ctrl
								 18, //alt
								 19, //pause,break
								 20, //capslock
								 21, //한영
								 25, //한자
								 27, //esc
								 32, //space
								 33, //pageup
								 34, //pagedown
								 35, //end
								 36, //home
								 37, //<-
								 38, //↑
								 39, //->
								 40, //↓
								 45, //insert
								 46, //delete
								 91, //window 왼쪽
								 92, //window 오른쪽
								 93, //메뉴
								 96, //키보드 오른쪽 0
								 97, //키보드 오른쪽 1
								 98, //키보드 오른쪽 2
								 99, //키보드 오른쪽 3
								 100, //키보드 오른쪽 4
								 101, //키보드 오른쪽 5
								 102, //키보드 오른쪽 6
								 103, //키보드 오른쪽 7
								 104, //키보드 오른쪽 8
								 105, //키보드 오른쪽 9
								 //107, //키보드 오른쪽 +
								 //110, //키보드 오른쪽 .
								 144, //numlock
								 145];
			
			var isFunctionKey = false;
		
			var blur_fn = function(){ //포커싱 잃을때 팝업창을 숨기기위한 함수
				if(domObj.popObject != undefined && domObj.popObject != null){
					domObj.popObject.callEvent("onHide"); //포커싱을 잃을때 강제로 hide 이벤트 호출
					domObj.popObject = null;
				}
			}
			
			//숫자만 입력 받도록 컨트롤
			var only_number = function(add_fn){
				var only_number_check = function(){ //이벤트 키코드 값이 들어옴  한글용 : 정규식 /[\ㄱ-ㅎㅏ-ㅣ가-힣]/g
					event.target.value = event.target.value.replace(/[^0-9]/gi, '');
					for(i in functionkey){
						if(functionkey[i] == event.keyCode){
							isFunctionKey = true;
							break;
						}else{
							isFunctionKey = false;
						}
					}
					
					//비정상 입력시 표시
					if (((event.keyCode < 48) || (event.keyCode > 57)) && isFunctionKey == false){
						if(event.type == 'keyup'){
							$erp.initDhtmlXPopupDom(event.target, "숫자만 기입 할 수 있습니다."); // + event.keyCode
						}
						
					//정상 입력시 숨김
					}else{
						if(event.target.popObject != undefined && event.target.popObject != null){ 
							blur_fn();
						}
					}
					
					//숫자입력 컨트롤 + 추가 컨트롤
					if(add_fn != undefined && add_fn != null){
						add_fn();
					}
				}
				//키 누르자마자
				domObj.onkeydown = only_number_check;
				
				//입력이 될때 alert창이 발생하면 그후에 입력됐던 것들이 남아있다가 onchange가 발생하면서 입력되는 현상때문에 필요
				domObj.onchange = only_number_check;
				
				//키에서 손땔때
				domObj.onkeyup = only_number_check;
				
				//포커스를 잃을때
				domObj.onblur = blur_fn;
				
			}
			
			if(type == undefined || type == null){
				
			}else if(type == "number"){
				only_number();
				
				
			}else if(type == "phone"){
				
				phone_number_check = function(){
					if(event.type == 'keyup'){
						var value = domObj.value;
						if (value.length >= 11){
							
							value = $erp.getPhoneNumberHyphen(value);
							if(value != ""){
								if(!$erp.isPhoneNumber(value)){
									value = "";
								}
	
								if(value == ""){
									$erp.initDhtmlXPopupDom(event.target, "올바르지 않은 전화번호 형식 입니다.");
								}else{
									$erp.initDhtmlXPopupDom(event.target, "올바른 전화번호 형식 입니다.");
								}
							}
						}	
					}
				}
				
				only_number(phone_number_check);
				
			}else if(type == "money"){
				
				/*domObj.onpropertychange = function() {
					var value = domObj.value;
					var regexp = /\B(?=(\d{3})+(?!\d))/g;
					domObj.value = "123123";
					domObj.value = value.replace(regexp, ',');
						alert("실행");
				};*/
				
			}
		}
	}
	/** 
	* Description 
	* @function getDhtmlXComboCommonCode
	* @function_Description 공통코드 가져와서 콤보로 만들기
	* @param domElementId (String) / Dom Element Object ID
	* @param paramName (String) / Form Parameter 전송 시 사용할 Name
	* @param cmmn_cd (Object, Array, String) / System 공통코드
	* @param paramWidth (Number) / dom 가로 길이
	* @param blankText (String) / 텍스트 , 비어있는 value 사용시 설정
	* @param showCode (String) / 텍스트 표시할때 코드 value 값도 보여줄 것인지 아니면 일반 텍스트만 보여줄것인지 여부
	* @param defaultOption (String) / 초기화시 갖게될 기본 선택 값
	* @param callbackFunction (function) / 콜백 함수
	* @param useYN (String) / 공통코드 조회시 사용여부 값
	* @author 조승현
	*/
	this.getDhtmlXComboCommonCode = function(domElementId, paramName, cmmn_cd, paramWidth, blankText, showCode, defaultValue, callbackFunction, useYN){
		var defaultWidth = 200;
		var width = defaultWidth;
		if(paramWidth && !isNaN(paramWidth)){
			width = paramWidth;
		}
		if(blankText == null){
			blankText = undefined;
		}
		if(defaultValue == null || defaultValue == ''){
			defaultValue = undefined;
		}
		
		var divParamMap = {};     
		if(!$erp.isEmpty(cmmn_cd)){
			if(typeof cmmn_cd === 'object' && $erp.isArray(cmmn_cd)){
				divParamMap.div1 = cmmn_cd[1];
				divParamMap.div2 = cmmn_cd[2];
				divParamMap.div3 = cmmn_cd[3];
				divParamMap.div4 = cmmn_cd[4];
				divParamMap.div5 = cmmn_cd[5];
				cmmn_cd = cmmn_cd[0];
			} else if(typeof cmmn_cd === 'object' && !$erp.isArray(cmmn_cd)){
				divParamMap.div1 = cmmn_cd['div1'];
				divParamMap.div2 = cmmn_cd['div2'];
				divParamMap.div3 = cmmn_cd['div3'];
				divParamMap.div4 = cmmn_cd['div4'];
				divParamMap.div5 = cmmn_cd['div5'];
				cmmn_cd = cmmn_cd['commonCode'];
			}       
		} else {
			return;
		}
		
		var dhtmlXComboObject = null;
		if(domElementId != undefined && cmmn_cd != undefined){
			/* new dhtmlXCombo(id, name, width); */       
			dhtmlXComboObject = new dhtmlXCombo(domElementId, paramName, width);
			dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
			dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
			dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
			dhtmlXComboObject.readonly(true);   
			document.getElementById(domElementId).setAttribute("name", paramName);

			$erp.asyncObjAddStart(domElementId);
			
			$erp.setDhtmlXComboCommonCodeUseAjax(dhtmlXComboObject, cmmn_cd, divParamMap, blankText, showCode, defaultValue, callbackFunction, useYN);
		}
		return dhtmlXComboObject;
	}
	
	
	/** 
	* Description 
	* @function setDhtmlXComboCommonCodeUseAjax
	* @function_Description Ajax를 통한 DhtmlXCombo Data 생성
	* @param dhtmlXComboObject (Object) / 생성한 DhtmlXComboObject $erp.getDhtmlXCombo Function 활용
	* @param cmmn_cd (String) / System 공통코드
	* @param divParamMap (Object) / 구분 조건 Map
	* @param blankText (String) / 텍스트 , 비어있는 value 사용시 설정
	* @param showCode (String) / 텍스트 표시할때 코드 value 값도 보여줄 것인지 아니면 일반 텍스트만 보여줄것인지 여부
	* @param defaultValue (String) / 초기화시 갖게될 기본 선택 값
	* @param callbackFunction (function) / 콜백 함수
	* @param useYN (String) / 공통코드 조회시 사용여부 값
	* @author 조승현
	*/
	this.setDhtmlXComboCommonCodeUseAjax = function(dhtmlXComboObject, cmmn_cd, divParamMap, blankText, showCode, defaultValue, callbackFunction, useYN){  
		var div1;
		var div2;
		var div3;
		var div4;
		var div5;
		
		if(useYN == undefined || useYN == null){
			useYN = "";
		}
		
		if(!$erp.isEmpty(divParamMap)){
			div1 = divParamMap['div1'];
			div2 = divParamMap['div2'];
			div3 = divParamMap['div3'];
			div4 = divParamMap['div4'];
			div5 = divParamMap['div5'];
		}
		
		$.ajax({
			url : "/common/system/code/getDetailCommonCodeList.do"
			,data : {
				'CMMN_CD' : cmmn_cd
				,'DIV1' : div1
				,'DIV2' : div2
				,'DIV3' : div3
				,'DIV4' : div4
				,'DIV5' : div5
				,'USE_YN' : useYN
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {            
					var detailCommonCodeList = data.detailCommonCodeList;
					var optionArray = [];   
					if(blankText != undefined && blankText != null && blankText !== false){
						/* blankText가 true인 경우 전체로 Text 변경 */
						if(blankText === true){
							blankText = "모두조회";
						}
						optionArray.push({ value : "", text : blankText});
					}
					for(var i in detailCommonCodeList){
						var detailCommonCodeObj = detailCommonCodeList[i];            
						var option = { value : null, text : null};
						for(var key in detailCommonCodeObj){
							var value =  detailCommonCodeObj[key];
							if(showCode == undefined || showCode == null || showCode == true){
								if(key == 'CMMN_DETAIL_CD'){  /* CMMN_DETAIL_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
									option.value = value;
								} else if(key == 'CMMN_DETAIL_CD_NM'){ /* CMMN_DETAIL_CD_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
									option.text = value;
								} else {
									option[key] = value;
								}
							}else{
								if(key == 'CMMN_DETAIL_CD'){  /* CMMN_DETAIL_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
									option.value = value;
								} else if(key == 'CMMN_DETAIL_NM'){ /* CMMN_DETAIL_CD_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
									option.text = value;
								} else {
									option[key] = value;
								}
							}
						}   
						optionArray.push(option);           
					}
					dhtmlXComboObject.addOption(optionArray);
					if(typeof dhtmlXComboObject.getParent() === 'string'){
						if(dhtmlXComboObject.getOptionsCount() > 0){
							dhtmlXComboObject.selectOption(0);
						}
						if(defaultValue != undefined && defaultValue != null){
							if(dhtmlXComboObject.getOption(defaultValue) != null){
								dhtmlXComboObject.setComboValue(defaultValue);
							}
						}
					}
					  
					if(callbackFunction && typeof callbackFunction === 'function'){
						callbackFunction.apply(dhtmlXComboObject, []);
					}
					
					$erp.asyncObjAddEnd(dhtmlXComboObject.DOMParent);
					
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	

	/** 
	* Description 
	* @function convertToMoney
	* @function_Description Number 를 Money 타입으로 변환
	* @param value (Number)
	* @author 조승현
	*/
	this.convertToMoney = function(value){
	    var x, n;
	    if(value && !isNaN(value)){
	      value = Math.floor(value-0);      
	      var re = '\\d(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\.' : '$') + ')';
	        return value.toFixed(Math.max(0, ~~n)).replace(new RegExp(re, 'g'), '$&,');
	    } else {
	      return value;
	    }
	}
	
	/** 
	* Description 
	* @function UseAjaxRequestInBody
	* @function_Description Request 를 body 를 이용하여 전송 (data 를 json 구조로 만들어 컨트롤러에서 다중 Map 구조로 받기위함)
	* @param url (String) : url 주소
	* @param send_data (function) : 보낼 데이터
	* @param if_success (function) : 성공시
	* @param if_error (function) : 실패시
	* @author 조승현
	*/
	this.UseAjaxRequestInBody = function(url, send_data, if_success, if_error, progress_layaout){
		var show_alert = function(msg){
			$erp.alertMessage({
				"alertMessage" : msg
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
		}
		if(!(url != undefined && url != null && typeof url === "string")){
			return show_alert("사용할 url이 지정 되지 않았습니다.");
		}
		if(!(send_data != undefined && send_data != null && typeof send_data === "object")){
			return show_alert("DB 사용을 위한 객체 형태의 데이터가 필요합니다.");
		}
		
		if(progress_layaout != undefined && progress_layaout != null){
			progress_layaout.progressOn();
		}
		$.ajax({
			url : url,
			type : "post",
			contentType : "application/json",
			data : JSON.stringify(send_data),
			dataType : "json",
			success : function(data){
				if(progress_layaout != undefined && progress_layaout != null){
					progress_layaout.progressOff();
				}
				if(data.isError){
		            $erp.ajaxErrorMessage(data);
		        }else{
		        	if(if_success != undefined && if_success != null && typeof if_success === "function"){
		        		if_success(data);
					}
		        }
			},
			error : function(XHR, status, error) {
				if(progress_layaout != undefined && progress_layaout != null){
					progress_layaout.progressOff();
				}
				if(if_error != undefined && if_error != null && typeof if_error === "function"){
					if_error(XHR, status, error);
				}
				$erp.ajaxErrorHandler(XHR, status, error);
			}
		});
	}
	
	/** 
	* Description 
	* @function setGridColumnsUpdateConfig
	* @function_Description DhtmlXDataProcessor 를 이용하여 데이터를 추출할때 그리드의 컬럼이 업데이트할 데이터인지 아닌지 제외 설정
	* @param dhtmlXGridObj (Object) / DhtmlXGrid Object
	* @author 조승현
	*/
	this.setGridColumnsUpdateConfig = function(dhtmlXGridObj){
		var dhtmlXGridColumnArray = dhtmlXGridObj.columnsMapArray;
		if(dhtmlXGridColumnArray == undefined || dhtmlXGridColumnArray == null || dhtmlXGridColumnArray.length == 0){
			return false;
		}
		var dhtmlXDataProcessor = dhtmlXGridObj.getDataProcessor();
		if(dhtmlXDataProcessor == undefined || dhtmlXDataProcessor == null){
			return false;
		}
		var dataColumnsArray = [];
		for(var i in dhtmlXGridColumnArray){
			var dhtmlXGridColumn = dhtmlXGridColumnArray[i];
			var isDataColumn = dhtmlXGridColumn.isDataColumn;   
			if(isDataColumn != undefined && isDataColumn != null && isDataColumn == false){
				dataColumnsArray.push(false);
			} else {
				dataColumnsArray.push(true);
			}
		}
		dhtmlXDataProcessor.setDataColumns(dataColumnsArray);
	}
	
	/** 
	* Description 
	* @function dataDeleteOfCheckedGridRow
	* @function_Description 그리드 체크된 로우 삭제 줄긋기 또는 아직 저장 되지않은 로우는 즉시삭제후 로우 재정렬 및 행수계산
	* @param dhtmlXGridObj (Object) / DhtmlXGrid Object
	* @author 조승현
	*/
	this.dataDeleteOfCheckedGridRow = function(dhtmlXGridObj){
		var checked = dhtmlXGridObj.getCheckedRows(dhtmlXGridObj.getColIndexById("CHECK"));
		var checkedRows = checked.split(",");
		for(i in checkedRows){
			dhtmlXGridObj.deleteRow(checkedRows[i]);
		}
		var rowNum=1;
		var noColIndex = dhtmlXGridObj.getColIndexById("NO");
		if(noColIndex){
			for(var j=0; j<dhtmlXGridObj.getRowsNum(); j++){ //로우 삭제후 자릿수 재매김
				var rId = dhtmlXGridObj.getRowId(j);
				dhtmlXGridObj.cells(rId, noColIndex).setValue(rowNum);
				rowNum++;
			} 
		}
		$erp.setDhtmlXGridFooterRowCount(dhtmlXGridObj); //행수 재계산
	}
	
	/** 
	* Description 
	* @function isExistCheckedRows
	* @function_Description 그리드에서 체크를 사용하여 선택한 로우가 있는지 검사
	* @param dhtmlXGridObj (Object) / DhtmlXGrid Object
	* @param messsage (String) / alertmessage
	* @author 조승현
	*/
	this.isExistCheckedRows = function(dhtmlXGridObj, message){
		var checked = dhtmlXGridObj.getCheckedRows(dhtmlXGridObj.getColIndexById("CHECK"));
		var checkedRows = [];
		if(checked != ""){
			checkedRows = checked.split(",");
		}
		if(checkedRows.length > 0){
			return true;
		}else{
			if(message == undefined || message == null){
				$erp.alertMessage({
					"alertMessage" : "체크된 항목이 없습니다."
					, "alertCode" : null
					, "alertType" : "error"
					, "isAjax" : false
				});
			}else{
				$erp.alertMessage({
					"alertMessage" : message
					, "alertCode" : null
					, "alertType" : "error"
					, "isAjax" : false
				});
			}
			return false;
		}
	}
	
	/** 
	* Description 
	* @function isExistSelectRow
	* @function_Description 그리드를 클릭하여 선택한 로우가 있는지 검사
	* @param dhtmlXGridObj (Object) / DhtmlXGrid Object
	* @author 조승현
	*/
	this.isExistSelectedRow = function(dhtmlXGridObj, message){
		//console.log(dhtmlXGridObj.selectedRows[0].idd); 선택된 로우 인덱스
		var selectedRow = dhtmlXGridObj.getSelectedCellIndex();
		var selectedRowId = dhtmlXGridObj.getSelectedRowId();
		
		if(selectedRow == -1 || selectedRowId.indexOf("NoDataPrintRow") > -1){
			if(message == undefined || message == null){
				$erp.alertMessage({
					"alertMessage" : "error.common.noSelectedRow"
					, "alertCode" : null
					, "alertType" : "error"
				});
			}else{
				$erp.alertMessage({
					"alertMessage" : message
					, "alertCode" : null
					, "alertType" : "error"
					, "isAjax" : false
				});
			}
			return false;
		}else{
			return true;
		}
	}
	
	/** 
	* Description 
	* @function unionObjArray
	* @function_Description 여러개의 객체를 하나로 합치기 (중복되는 속성을 가지고 있는 객체에는 사용하면 안됨)
	* @param objs (Object []) / 자바스크립트 객체 배열
	* @author 조승현
	*/
	this.unionObjArray = function(objs){
		var union_obj = {};
		var before;
		var after;
		if(Array.isArray(objs)){
			for(i in objs){
				if(typeof objs[i] === "object"){
					for(key in objs[i]){
						if(!union_obj[key]){
							union_obj[key] = objs[i][key];
						}else{
							before = union_obj[key]
							after = objs[i][key]
							union_obj[key] = objs[i][key];
							if(before != after){
								$erp.alertMessage({
									"alertMessage" : "결합중 발생한 중복된 키에 상이한 값이 존재합니다. 확인해주세요.",
									"alertCode" : "객체 유니온 에러",
									"alertType" : "error",
									"isAjax" : false
								});
							
								console.log("key : " + key);
								console.log("value before : " + before);
								console.log("value after : " + after);
								
								throw new Error("유니온 에러");
								break;
							}
						}
					}
				}else{
					$erp.alertMessage({
						"alertMessage" : "객체가 아닌 변수가 섞여있습니다. 확인해주세요.",
						"alertCode" : "객체 유니온 에러",
						"alertType" : "error",
						"isAjax" : false
					});
					
					throw new Error("유니온 에러");
					break;
				}
			}
		}else{
			$erp.alertMessage({
				"alertMessage" : "객체 배열을 합칠 때 사용하는 함수입니다. 매개변수로 객체 배열을 넣어주세요.",
				"alertCode" : "객체 유니온 에러",
				"alertType" : "error",
				"isAjax" : false
			});
			
			throw new Error("유니온 에러");
		}
		
		return union_obj;
	}
	
	/** 
	 * Description 합계 요약 풋터 생성
	 * @function attachDhtmlXGridFooterSummary
	 * @function_Description DhtmlXGrid Footer Summary 
	 * @param dhtmlXGridObj (Object) / dhtmlXGridObject
	 * @param sumColumns (Array) / Sum ColumnId
	 * @param id_suffix (string) / 아이디 접미사
	 * @param summaryTitle (Array) / 요약 타이틀
	 * @author 조승현
	 */
	this.attachDhtmlXGridFooterSummary = function(dhtmlXGridObj, sumColumns, id_suffix, summaryTitle){
		if(!summaryTitle){
			summaryTitle = "합계";
		}
		
		var SumCount = sumColumns.length;
		var colCount = dhtmlXGridObj.getColumnsNum();
		var isSumColumnExist = false;
		
		if(dhtmlXGridObj && SumCount > 0){
			var footerTag = new Array();
			var textAlign = new Array();
			var style_empty =  " background-color:#FAE0D4; font-weight:bold; font-style:normal; border-right:0px;";	//빈셀
			var style_hidden = "display:none;"
			var style_description =  " background-color:#FAE0D4; font-weight:bold; font-style:normal;";				//합계 셀
			var style_value =  " background-color:#dfe8f6; font-weight:bold; font-style:normal;";					//값 입력 셀
			var style_block =  " background-color:#dfe8f6; font-weight:bold; font-style:normal;";					//미사용 셀
			var chkCnt;
			for(var i = 0; i < colCount; i++){
				var columnId = dhtmlXGridObj.getColumnId(i);
				if(dhtmlXGridObj.columnsMapArray[i].isHidden){
					footerTag.push("");
					textAlign.push(style_hidden);
					continue;
				}
				chkCnt = 0;
				for(var j = 0; j < SumCount; j++){
					var sumColumn = sumColumns[j];
					if(columnId == sumColumn){
						if(!isSumColumnExist){
							isSumColumnExist = true;
							if(textAlign[textAlign.length-1] == style_hidden){
								footerTag[textAlign.length-2] = "<span style='float: right; margin-right: 5px;'>" + summaryTitle + "</span>";
								textAlign[textAlign.length-2] = style_description;
							}else{
								footerTag[textAlign.length-1] = "<span style='float: right; margin-right: 5px;'>" + summaryTitle + "</span>";
								textAlign[textAlign.length-1] = style_description;
							}
						}
						if(id_suffix){
							footerTag.push("<span id='SUMMARY_" + columnId + "_" + id_suffix + "'>0</span>");
						}else{
							footerTag.push("<span id='SUMMARY_" + columnId + "'>0</span>");
						}
						textAlign.push("text-align:right;" + style_value);
						chkCnt++;
					}
				}
				//alert("chkCnt : " + chkCnt + " : gridColunmId : " + gridColunmId + " : " + firstFlag);
				if(chkCnt == 0){
					footerTag.push("");
					if(!isSumColumnExist){
						textAlign.push(style_empty);
					}else{
						textAlign.push(style_block);
					}
				}
			}
			dhtmlXGridObj.attachFooter(footerTag,textAlign);
		}
	}
	
	/** 
	 * Description 합계 요약 풋터 값 세팅
	 * @function setDhtmlXGridFooterSummary
	 * @function_Description DhtmlXGrid Footer Summary
	 * @param dhtmlXGridObj (Object) / dhtmlXGridObject
	 * @param sumColumns (Array) / Sum ColumnId
	 * @param id_suffix (String) / 아이디 접미사
	 * @param formulaType (String) / 사용할 계산식 타입
	 * @author 조승현
	 */
	this.setDhtmlXGridFooterSummary = function(dhtmlXGridObj, sumColumns, id_suffix, formulaType){
		
		if(dhtmlXGridObj){
			var spanFooterRowCountObject;
			var sumColumn;
			var columnTotal;
			var divide_count;
			var prefix;
			var rowsNum = dhtmlXGridObj.getRowsNum();
			var v;
			var sumColumnRowList = [];
			for(var i = 0; i < sumColumns.length; i++){
				sumColumn = sumColumns[i];
				columnTotal = 0;
				
				divide_count = 0; //나누기 수
				prefix = sumColumn.length >= 4 ? sumColumn.substring(0, 4) : sumColumn;
				
				for(var j = 0; j < rowsNum; j++){
					sumColumnRowList[j] = {};
					for(var k = 0; k < dhtmlXGridObj.getColumnsNum(); k++){
						var columnId = dhtmlXGridObj.getColumnId(k);
						if (columnId == sumColumn){
							//console.log(columnId);
							
							if(prefix == "avg0"){ //0,-값 모두 포함
								columnTotal += Number(dhtmlXGridObj.cells(dhtmlXGridObj.getRowId(j), dhtmlXGridObj.getColIndexById(sumColumn)).getValue());
								divide_count++;
							}else if(prefix == "avg1"){ //0만 포함
								var chk_value = Number(dhtmlXGridObj.cells(dhtmlXGridObj.getRowId(j), dhtmlXGridObj.getColIndexById(sumColumn)).getValue());
								if(chk_value >= 0){
									columnTotal += chk_value;
									divide_count++;
								}
							}else if(prefix == "avg2"){ //0,-값 모두 포함 안함
								var chk_value = Number(dhtmlXGridObj.cells(dhtmlXGridObj.getRowId(j), dhtmlXGridObj.getColIndexById(sumColumn)).getValue());
								if(chk_value > 0){
									columnTotal += chk_value;
									divide_count++;
								}
							}else{
								v = Number(dhtmlXGridObj.cells(dhtmlXGridObj.getRowId(j), dhtmlXGridObj.getColIndexById(sumColumn)).getValue());
								sumColumnRowList[j][columnId]=v;
								columnTotal += v;
							}
						}
					}
				}
				
				if(divide_count == 0){ //0으로 나눌수 없기 때문에 1로 만들어줌
					divide_count = 1;
				}
				
				if(prefix == "avg0" || prefix == "avg1" || prefix == "avg2"){
					//console.log(gridSumColumn + " 컬럼의 나누기 제수 : " + divide_count);
				}
				if(id_suffix){
					spanFooterRowCountObject = document.getElementById("SUMMARY_" + sumColumn + "_" + id_suffix);
				}else{
					spanFooterRowCountObject = document.getElementById("SUMMARY_" + sumColumn);
				}
				if(divide_count > 0){ //테이블 컬럼 아이디 prefix : avg0, avg1, avg2 사용시
					spanFooterRowCountObject.innerHTML = new Intl.NumberFormat("en-US").format(Math.round(columnTotal/divide_count));
				}else{ //테이블 컬럼 아이디 prefix 미사용시
					if(formulaType){
						if(formulaType == "평균"){
							spanFooterRowCountObject.innerHTML = new Intl.NumberFormat("en-US").format(Math.round(columnTotal/rowsNum));
						}else if(formulaType == "표준편차"){
							var sumColumnValue;	//합계컬럼의 값
							var sumColumnTotalAvg = columnTotal/rowsNum; //합계컬럼 총합의 평균
							var sumColumnDeviationList = []; //합계컬럼의 로우별 편차리스트
							for(var rowIndex in sumColumnRowList){ //합계컬럼 로우별 편차 계산
								sumColumnValue = sumColumnRowList[rowIndex][sumColumn];
								sumColumnDeviation.push(sumColumnValue - sumColumnTotalAvg);
							}
							
							var deviationSquaredTotal; //편차의 제곱값 합
							for(var rowIndex in sumColumnDeviationList){
								deviationSquaredTotal += sumColumnDeviationList[rowIndex]*sumColumnDeviationList[rowIndex];
							}
							
							var sumColumnStandardDeviation = Math.round(Math.sqrt(deviationSquaredTotal/sumColumnDeviationList.length)) ; //표준편차
							
							spanFooterRowCountObject.innerHTML = new Intl.NumberFormat("en-US").format(sumColumnStandardDeviation);
						}else if("합계"){
							spanFooterRowCountObject.innerHTML = new Intl.NumberFormat("en-US").format(columnTotal);
						}
					}else{ //default 합
						spanFooterRowCountObject.innerHTML = new Intl.NumberFormat("en-US").format(columnTotal);
					}
				}
			}
		}
	}
	
	
	 /** 
	* Description 
	* @function getDhtmlXEmptyCombo
	* @function_Description DhtmlXCombo 기본 값만 가진 빈 콤박스 만들기
	* @param domElementId (String) / Dom Element Object ID
	* @param paramName (String) / Form Parameter 전송 시 사용할 Name
	* @param paramWidth (Number) / Object 가로 넓이
	* @param blankText (String) / 값=빈칸, 텍스트=blankText 사용여부 (기본 = 전체)
	* @param callbackFunction (function) / 작업 끝난 후 Callback Function
	* @param optionType (String) / Combo Option Type
	* @author 조승현
	*/
	this.getDhtmlXEmptyCombo = function(domElementId, paramName, paramWidth, blankText, callbackFunction){
	    var defaultWidth = 200;
	    var width = defaultWidth;
	    if(paramWidth && !isNaN(paramWidth)){
	    	width = paramWidth;
	    }
	    if(blankText == null){
	    	blankText = undefined;
	    }

	    var dhtmlXComboObject = null;
	    if(domElementId != undefined){
    		/* new dhtmlXCombo(id, name, width); */       
			dhtmlXComboObject = new dhtmlXCombo(domElementId, paramName, width);
			dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
			dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
			dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
			dhtmlXComboObject.readonly(true);   
			document.getElementById(domElementId).setAttribute("name", paramName);
	    }
	   
		if(blankText != undefined && blankText != null && blankText !== false){
		    /* blankText가 true인 경우 전체로 Text 변경 */
			if(blankText === true){
				blankText = "전체";
			}
			dhtmlXComboObject.addOption([{ value : "", text : blankText}]);
			dhtmlXComboObject.selectOption(0);
		}
		
		var setCombo = function(objList){
			var optionArray = [];
			if(blankText != undefined && blankText != null && blankText !== false){
			    /* blankText가 true인 경우 전체로 Text 변경 */
				if(blankText === true){
					blankText = "전체";
				}
				optionArray.push({ value : "", text : blankText});
			}
			for(var i in objList){
				var obj = objList[i];            
				var option = { value : null, text : null};
				for(var key in obj){
					var value =  obj[key];
					if(key == 'value'){  /* CMMN_DETAIL_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
						option.value = value;
					} else if(key == 'text'){ /* CMMN_DETAIL_CD_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
						option.text = value;
					} else {
						option[key] = value;
					}
				}   
				optionArray.push(option);
			}
			dhtmlXComboObject.unSelectOption();
			dhtmlXComboObject.clearAll();
			dhtmlXComboObject.addOption(optionArray);
			dhtmlXComboObject.selectOption(0);
			
			dhtmlXComboObject["data"] = objList;
		}
		dhtmlXComboObject["setCombo"] = setCombo;
		dhtmlXComboObject["data"] = {};
		
		if(callbackFunction != undefined && callbackFunction != null && typeof callbackFunction === 'function'){
			callbackFunction.apply(dhtmlXComboObject,[]);
		}
	    return dhtmlXComboObject;
	}
	
	
	/** 
	* Description 
	* @function getDhtmlXRadioCommonCode
	* @function_Description 공통코드 가져와서 라디오로 만들기
	* @param domElementId (String) / Dom Element Object ID
	* @param paramName (String) / Form Parameter 전송 시 사용할 Name
	* @param cmmn_cd (Object, Array, String) / System 공통코드
	* @param paramWidth (Number) / dom 가로 길이
	* @param blankText (String) / 텍스트 , 비어있는 value 사용시 설정
	* @param showCode (String) / 텍스트 표시할때 코드 value 값도 보여줄 것인지 아니면 일반 텍스트만 보여줄것인지 여부
	* @param useYN (String) / 가져올 사용여부 조건 값
	* @param callbackFunction (function) / 콜백 함수
	* @param labelPosition (String) / 라벨 위치
	* @param direction (String) / 가로세로 방향
	* @author 조승현
	*/
	this.getDhtmlXRadioCommonCode = function(domElementId, radioName, cmmn_cd, checkPosition, showCode, useYN, callbackFunction, labelPosition, direction){
		var default_direction = "horizon";
		var default_labelPosition = "label-right";
		
		var divParamMap = {};     
		if(!$erp.isEmpty(cmmn_cd)){
			if(typeof cmmn_cd === 'object' && $erp.isArray(cmmn_cd)){
				divParamMap.div1 = cmmn_cd[1];
				divParamMap.div2 = cmmn_cd[2];
				divParamMap.div3 = cmmn_cd[3];
				divParamMap.div4 = cmmn_cd[4];
				divParamMap.div5 = cmmn_cd[5];
				cmmn_cd = cmmn_cd[0];
			} else if(typeof cmmn_cd === 'object' && !$erp.isArray(cmmn_cd)){
				divParamMap.div1 = cmmn_cd['div1'];
				divParamMap.div2 = cmmn_cd['div2'];
				divParamMap.div3 = cmmn_cd['div3'];
				divParamMap.div4 = cmmn_cd['div4'];
				divParamMap.div5 = cmmn_cd['div5'];
				cmmn_cd = cmmn_cd['commonCode'];
			}       
		} else {
			return;
		}
		
		$erp.asyncObjAddStart(domElementId);
		
		var div1;
		var div2;
		var div3;
		var div4;
		var div5;
		
		if(useYN == undefined || useYN == null){
			useYN = "";
		}else if(useYN == "1" || useYN == "Y"){
			useYN = "Y";
		}else if(useYN == "0" || useYN == "N"){
			useYN = "N";
		}else{
			useYN = "";
		}
		
		if(!$erp.isEmpty(divParamMap)){
			div1 = divParamMap['div1'];
			div2 = divParamMap['div2'];
			div3 = divParamMap['div3'];
			div4 = divParamMap['div4'];
			div5 = divParamMap['div5'];
		}
		
		
		$.ajax({
			url : "/common/system/code/getDetailCommonCodeList.do"
			,data : {
				'CMMN_CD' : cmmn_cd
				,'DIV1' : div1
				,'DIV2' : div2
				,'DIV3' : div3
				,'DIV4' : div4
				,'DIV5' : div5
				,'USE_YN' : useYN
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else { 
					var detailCommonCodeList = data.detailCommonCodeList;
					var radio_labels = [];
					var radio_values = [];
					var detailCommonCodeObj;
					var value;
					for(var i in detailCommonCodeList){
						detailCommonCodeObj = detailCommonCodeList[i];            
						for(var key in detailCommonCodeObj){
							value = detailCommonCodeObj[key];
							if(showCode == undefined || showCode == null || showCode == true){
								if(key == 'CMMN_DETAIL_CD'){  /* CMMN_DETAIL_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
									radio_values.push(value);
								} else if(key == 'CMMN_DETAIL_CD_NM'){ /* CMMN_DETAIL_CD_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
									radio_labels.push(value)
								}
							}else{
								if(key == 'CMMN_DETAIL_CD'){  /* CMMN_DETAIL_CD로 올 경우 value로 변경 - dhtmlXCombo 규칙 때문에 필요 */
									radio_values.push(value);
								} else if(key == 'CMMN_DETAIL_NM'){ /* CMMN_DETAIL_CD_NM로 올 경우 text로 변경 - dhtmlXCombo 규칙 때문에 필요 */
									radio_labels.push(value)
								}
							}
						}   
					}
					
					var radioButtonArray; //라디오 버튼 배열
					
					if(domElementId == null || domElementId ==''){
						domElementId = undefined;
					}
					if(checkPosition == null || checkPosition == '' || checkPosition < 0 || checkPosition >= radio_values.length){
						checkPosition = 0;
					}
					if(radioName == null || radioName ==''){
						radioName = undefined;
					}
					if(labelPosition == null || labelPosition =='' || labelPosition == undefined){
						labelPosition = "label-right";
					}
					if(direction == null || direction == '' || direction == undefined || direction != 'vertical'){
						direction = default_direction;
					}
				    
				    if(domElementId != undefined && cmmn_cd != undefined && radioName != undefined){ //라벨네임은 공통코드 상세명 , 라디오 벨류 공통상세코드
				    	if(radio_values.length == radio_labels.length){
				    		radioButtonArray = "[{type: 'settings', position: '"+labelPosition+"'}";
				    		for(i=0; i<radio_values.length; i++){
				    			if(checkPosition == i){
				    				radioButtonArray += ",{type: 'radio', name: '"+radioName+"', value: '"+radio_values[i]+"', label: '"+radio_labels[i]+"', checked: true}";
				    			}else{
				    				radioButtonArray += ",{type: 'radio', name: '"+radioName+"', value: '"+radio_values[i]+"', label: '"+radio_labels[i]+"'}";
				    			}
				    			if(direction == "horizon" || i<radio_values.length-1){
				    				radioButtonArray += ", {type: 'newcolumn', offset:20}";
				    			}
				    			if(i==radio_values.length-1){
				    				radioButtonArray += "]";
				    			}
				    		}
				    		var json = eval(radioButtonArray);
				    		dhtmlXRadioObj = new dhtmlXForm(domElementId, json);
				    		
				    		if(callbackFunction && typeof callbackFunction === 'function'){
								callbackFunction.apply(dhtmlXRadioObj, []);
							}
				    		
				    		$erp.asyncObjAddEnd(domElementId);
				    	}
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		
	}
	
	
	/** 
	* Description 
	* @function asyncObjAddStart
	* @function_Description 콤보,체크 박스 객체만 생성된 상태 아이템이 추가되지 않은 상태의 객체들 등록
	* @param domElementId (string) / 돔 아이디
	* @author 조승현
	*/
	this.asyncObjAddStart = function(domElementId){
		if(!window["asyncObjAllIsCreated"]){
			window["asyncObjAllIsCreated"] = {};
		}
		window["asyncObjAllIsCreated"][domElementId] = false;
	}
	
	
	/** 
	* Description 
	* @function asyncObjAddEnd
	* @function_Description 공통코드 조회하여 콤보,체크 박스에 아이템 추가 완료후 관찰자 호출
	* @param domElementId (string) / 돔 아이디
	* @author 조승현
	*/
	this.asyncObjAddEnd = function(domElementId){
		window["asyncObjAllIsCreated"][domElementId] = true;
		$erp.asyncObjObserver();
	}
	
	
	/** 
	* Description 
	* @function asyncObjObserver
	* @function_Description 공통코드를 사용해서 만들어지는 콤보박스, 라디오 박스가 모두 생성 되었는지 확인하는 관찰자
	* @param callback (function) / 콜백함수
	* @author 조승현
	*/
	this.asyncObjObserver = function(){
		if(window["asyncObjAllOnCreated"]){
			var asyncObjIsCreated;
			for(var key in window["asyncObjAllIsCreated"]){
				asyncObjIsCreated = window["asyncObjAllIsCreated"][key];
				
				if(!asyncObjIsCreated){
					
					if(window["asyncObjAllOnCreated_completed"]){
						$erp.alertMessage({
							"alertMessage" : "$erp.asyncObjAllOnCreated(callback); 함수는 모든 레이아웃 초기화 함수 호출후 제일 마지막에 사용해주세요.",
							"alertCode" : null,
							"alertType" : "alert",
							"isAjax" : false,
						});
						this.asyncObjObserver = null;
					}
					
					return;
				}
			}
			
			if(!window["asyncObjAllOnCreated_completed"]){
				window["asyncObjAllOnCreated"]();
				window["asyncObjAllOnCreated_completed"] = true;
			}
			
		}
	}
	
	
	/** 
	* Description 
	* @function asyncObjAllOnCreated
	* @function_Description 공통코드를 사용해서 만들어지는 콤보박스, 라디오 박스가 모두 생성 되었을때 호출할 콜백 함수 등록
	* @param callback (function) / 콜백함수
	* @author 조승현
	*/
	this.asyncObjAllOnCreated = function(callback){
		window["asyncObjAllOnCreated"] = callback;
		if(window["asyncObjAllIsCreated"]){
			var asyncObjIsCreated;
			for(var key in window["asyncObjAllIsCreated"]){
				asyncObjIsCreated = window["asyncObjAllIsCreated"][key];
				
				if(!asyncObjIsCreated){
					return;
				}
			}
			
			if(!window["asyncObjAllOnCreated_completed"]){
				window["asyncObjAllOnCreated"]();
				window["asyncObjAllOnCreated_completed"] = true;
			}
			
		}else{
			if(!window["asyncObjAllOnCreated_completed"]){
				window["asyncObjAllOnCreated"]();
				window["asyncObjAllOnCreated_completed"] = true;
			}
		}
	}
	
	
	/** 
	 * Description 특정 row 의 합만 계산
	 * @function setDhtmlXGridFooterSelectSummary
	 * @function_Description DhtmlXGrid Footer Summary
	 * @param dhtmlXGridObj (Object) / dhtmlXGridObject
	 * @param erpGridSumColumns (Array) / Sum ColumnId
	 * @author 
	 */
	this.setDhtmlXGridFooterSelectSummary = function(dhtmlXGridObj, erpGridSumColumns, erpGridSumRows){
		if(dhtmlXGridObj){
			var spanFooterRowCountObject;
			for(var i = 0; i < erpGridSumColumns.length; i++){
				var gridSumColumn = erpGridSumColumns[i];
				var ColumnTotal = 0;
				for(var j = 0; j < dhtmlXGridObj.getRowsNum(); j++){
					for(var k = 0; k < dhtmlXGridObj.getColumnsNum(); k++){
						var GrdColunmId = dhtmlXGridObj.getColumnId(k);
						if (GrdColunmId == gridSumColumn && erpGridSumRows.includes(j+1)){
							ColumnTotal += Number(dhtmlXGridObj.cells(dhtmlXGridObj.getRowId(j), dhtmlXGridObj.getColIndexById(gridSumColumn)).getValue());
						}
					}
				}
				spanFooterRowCountObject = document.getElementById(gridSumColumn);
				spanFooterRowCountObject.innerHTML = new Intl.NumberFormat("en-US").format(ColumnTotal)
			}
		}
	}
	

	/** 
	 * Description 그리드의 특정 컬럼들을 블럭 선택시 값을 더하거나 빼기
	 * 1.버튼 생성
	 * 2.URL 을 이용한 변경값 DB 저장 또는 그리드 값만 변경
	 * 3. -,+ 2개의 버튼을 갖고있는 DIV BOX 리턴
	 * @function columnMinusPlusBox
	 * @param targetGrid / 타겟 그리드
	 * @param targetColId / 타겟 컬럼 아이디
	 * @param isUseDB  / db 저장 사용 여부
	 * @param minusURL / db 저장 사용시 필요한 값을 minus 요청할 url
	 * @param plusURL  / db 저장 사용시 필요한 값을 plus 요청할 url
	 * @author 조승현
	 */
	this.columnMinusPlusBox = function(targetGrid, targetColId, isUseDB, minusURL, plusURL){
		var boxElement = document.createElement("div");
		boxElement.setAttribute("style","width:52px; height:25px; background : white; z-index:99999; position:absolute; left:0px; top:0px; display:none;");

		var selectedArea;
		var startRowIndex;
		var startRowId;
		var endRowIndex;
		var endRowId;
		var targetColIndex = targetGrid.getColIndexById(targetColId);
		
		var isNotNumAlert = function(){
			$erp.alertMessage({
				"alertMessage" : "선택된 컬럼 값들 중에<br> 숫자가 아닌 값이 포함되어 있습니다"
				, "alertType" : "error"
				, "isAjax" : false
			});
		}
		
		var getSelectedRowsDataList = function(){
			selectedArea = targetGrid.getSelectedBlock();
			startRowIndex = selectedArea.LeftTopRow;
			endRowIndex = selectedArea.RightBottomRow;
			var selectedRowsDataList = [];
			var targetRowId;
			var selectedRowsData;
			for(var i=startRowIndex; i<=endRowIndex; i++){
				targetRowId = targetGrid.getRowId(i);
				selectedRowsData = $erp.dataSerializeOfGridRow(targetGrid, targetRowId);
				selectedRowsDataList.push(selectedRowsData);
			}
			return selectedRowsDataList;
		};
		
		var minusButtonElement = document.createElement("div");
		minusButtonElement.setAttribute("class","input_common_button");
		minusButtonElement.setAttribute("style","width:25px; height:25px; float : left; margin-right:1px; padding:0px; text-align: center;");
		minusButtonElement.innerHTML = "-";
		minusButtonElement.onclick = function(){
			
			var selectedRowsDataList = getSelectedRowsDataList();
			if(isUseDB){				
				var url = minusURL;
				var if_success = function(data){
					if(data == selectedRowsDataList.length){
						var targetRowId;
						var targetCellValue;
						var isNotNum;
						for(var i=startRowIndex; i<=endRowIndex; i++){
							targetRowId = targetGrid.getRowId(i);
							targetCellValue = targetGrid.cells(targetRowId,targetColIndex).getValue();
							isNotNum = isNaN(targetCellValue);
							if(isNotNum){
								isNotNumAlert();
								return;
							}
							targetGrid.cells(targetRowId,targetColIndex).setValue(parseInt(targetCellValue) - 1);
						}
					}
				};
				
				var if_error = function(){
					$erp.alertMessage({
						"alertMessage" : "순서 변경 실패"
						, "alertType" : "error"
						, "isAjax" : false
					});
				};
				$erp.UseAjaxRequestInBody(url, selectedRowsDataList, if_success, if_error, erpLayout);
			}else{
				var targetRowId;
				var targetCellValue;
				var isNotNum;
				for(var i=startRowIndex; i<=endRowIndex; i++){
					targetRowId = targetGrid.getRowId(i);
					targetCellValue = targetGrid.cells(targetRowId,targetColIndex).getValue();
					isNotNum = isNaN(targetCellValue);
					if(isNotNum){
						isNotNumAlert();
						return;
					}
					targetGrid.cells(targetRowId,targetColIndex).setValue(parseInt(targetCellValue) - 1);
				}
			}
			
		};
		
		var plusButtonElement = document.createElement("div");
		plusButtonElement.setAttribute("class","input_common_button");
		plusButtonElement.setAttribute("style","width:25px; height:25px; float:left; margin-left:1px; padding:0px; text-align:center;");
		plusButtonElement.innerHTML = "+";
		plusButtonElement.onclick = function(){
			
			var selectedRowsDataList = getSelectedRowsDataList();
			if(isUseDB){				
				var url = plusURL;
				var if_success = function(data){
					if(data == selectedRowsDataList.length){
						var targetRowId;
						var targetCellValue;
						var isNotNum;
						for(var i=startRowIndex; i<=endRowIndex; i++){
							targetRowId = targetGrid.getRowId(i);
							targetCellValue = targetGrid.cells(targetRowId,targetColIndex).getValue();
							isNotNum = isNaN(targetCellValue);
							if(isNotNum){
								isNotNumAlert();
								return;
							}
							targetGrid.cells(targetRowId,targetColIndex).setValue(parseInt(targetCellValue )+ 1);
						}
					}
				};
				
				var if_error = function(){
					$erp.alertMessage({
						"alertMessage" : "순서 변경 실패"
						, "alertType" : "error"
						, "isAjax" : false
					});
				};
				$erp.UseAjaxRequestInBody(url, selectedRowsDataList, if_success, if_error, erpLayout);
			}else{
				var targetRowId;
				var targetCellValue;
				var isNotNum;
				for(var i=startRowIndex; i<=endRowIndex; i++){
					targetRowId = targetGrid.getRowId(i);
					targetCellValue = targetGrid.cells(targetRowId,targetColIndex).getValue();
					isNotNum = isNaN(targetCellValue);
					if(isNotNum){
						isNotNumAlert();
						return;
					}
					targetGrid.cells(targetRowId,targetColIndex).setValue(parseInt(targetCellValue )+ 1);
				}
			}
			
		};
		
		boxElement.appendChild(minusButtonElement);
		boxElement.appendChild(plusButtonElement);
		
		document.getElementById("div_erp_contents").appendChild(boxElement);
		
		targetGrid.attachEvent("onBlockSelected", function(){
			boxElement.style.display = "none";
			
			var selectedArea = targetGrid.getSelectedBlock();
			//console.log(selectedArea);
			if(selectedArea.LeftTopCol == selectedArea.RightBottomCol){
				var colIndex = selectedArea.LeftTopCol;
				var colId = targetGrid.getColumnId(colIndex);
				if(colId == targetColId){
					var lastRowIndex = selectedArea.RightBottomRow;
					var lastRowId = targetGrid.getRowId(lastRowIndex);
					
					var lastCell = targetGrid.cells(lastRowId,colIndex);
					//var parentTable = lastCell.cell.parentElement.parentElement.parentElement.parentElement.parentElement;
					var scrollDiv = lastCell.cell.parentElement.parentElement.parentElement.parentElement;
					
					var lastCellOffsetLeft = lastCell.cell.offsetLeft;
					var lastCellWidth = lastCell.getWidth();
					var boxOffsetLeft = lastCellOffsetLeft + lastCellWidth - scrollDiv.scrollLeft;
					var columnNameCellHeight = 25;
					var boxOffsetTop = lastCell.cell.offsetTop + columnNameCellHeight - scrollDiv.scrollTop;
					
					boxElement.style.left = boxOffsetLeft + "px";
					boxElement.style.top = boxOffsetTop + "px";
					boxElement.style.display = "block";
					
					//버튼 박스 상하좌우
					var validLeft = boxOffsetLeft;
					var validRight = boxOffsetLeft + boxElement.offsetWidth;
					var validTop = boxOffsetTop - 1; //border 값 1 제거
					var validBottom = boxOffsetTop - 1 + boxElement.offsetHeight; //border 값 1 제거
					var isValid = true;
					
					//그리드를 벗어날때
					scrollDiv.onmouseleave = function(e){
						if((e.layerX >= validLeft) && (e.layerX <= validRight) && ((e.layerY + columnNameCellHeight) >= validTop) && ((e.layerY + columnNameCellHeight) <= validBottom)){
							//그리드를 벗어났지만 버튼 박스 안에 커서가 있기 때문에 버튼 박스를 숨기지 않음
						}else{								
							boxElement.style.display = "none";
							scrollDiv.onmouseleave = null;
							targetGrid._HideSelection(); //공식 지원 메소드가 아님 선택된 블록 선택 해제
						}
					};
					
					
					targetGrid.attachEvent("onScroll",function(){
						boxElement.style.display = "none";
						scrollDiv.onmouseleave = null;
						targetGrid._HideSelection(); //공식 지원 메소드가 아님 선택된 블록 선택 해제
					});
					
					targetGrid.attachEvent("onRowSelect", function(){
						boxElement.style.display = "none";
						scrollDiv.onmouseleave = null;
					});
					
					targetGrid.attachEvent("onClearAll", function(){
						boxElement.style.display = "none";
						scrollDiv.onmouseleave = null;
					});
				}
			}
		});
		
		return boxElement;
	}
	
	
	/** 
	 * Description 
	 * @function getTableHeight
	 * @function_Description tr 개수로 테이블 높이 가져오기
	 * @param tr 개수
	 * @author 
	 */
	this.getTableHeight = function(tr_count){
		//tr개수 * 높이(28) + 테두리(4)
		return (tr_count * 28)+4;
	}
	
	
	/** 
	* Description 
	* @function objReadonly
	* @function_Description 단일 객체 readonly 처리
	* @param dhtmlxObjId (string) dhtmlx 객체 아이디
	* @author 조승현
	*/
	this.objReadonly = function(dhtmlxObjId){

		var prefix;
		var name;
		var obj;
		
		var exec = function(dhtmlxObjId){
			prefix = dhtmlxObjId.substring(0, 3);
			name = dhtmlxObjId.substring(3,dhtmlxObjId.length);
			
			if(prefix == "cmb"){
				obj = $erp.getObjectFromId(prefix+name);
				if(obj != undefined && obj != null){
					obj.disable();
				}
			}else if(prefix == "rdo"){
				obj = $erp.getObjectFromId(prefix+name);
				if(obj != undefined && obj != null){
					var text_array = [];
					var value_array = [];
					for(var i = 0; i<obj.base.length; i++){
						if(i != obj.base.length -1){
							text_array.push(obj.base[i].childNodes[0].innerText);
							value_array.push(obj.base[i].childNodes[0]._value);
						}
					}
					for(i in value_array){
						obj.disableItem(name,value_array[i]);
					}
				}
			}else if(prefix == "chk"){
				obj = $erp.getObjectFromId(prefix+name);
				if(obj != undefined && obj != null){
					obj.disableItem(prefix+name);
				}
			}else if(prefix == "txt"){
				obj = document.getElementById(prefix+name);
				if(obj != undefined && obj != null){
					obj.readOnly=true;
					obj.disabled=true;
					//obj.setAttribute("class", "input_readonly");
				}
			}
		}
		
		if($erp.isArray(dhtmlxObjId)){
			for(var id in dhtmlxObjId){
				exec(dhtmlxObjId[id]);
			}
		}else{
			exec(dhtmlxObjId);
		}
	}
	
	
	/** 
	* Description 
	* @function objNotReadonly
	* @function_Description 단일 객체 readonly 해제
	* @param dhtmlxObjId (string) dhtmlx 객체 아이디
	* @author 조승현
	*/
	this.objNotReadonly = function(dhtmlxObjId){

		var prefix;
		var name;
		var obj;
		
		var exec = function(dhtmlxObjId){
			prefix = dhtmlxObjId.substring(0, 3);
			name = dhtmlxObjId.substring(3,dhtmlxObjId.length);
			
			if(prefix == "cmb"){
				obj = $erp.getObjectFromId(prefix+name);
				if(obj != undefined && obj != null){
					obj.enable();
				}
			}else if(prefix == "rdo"){
				obj = $erp.getObjectFromId(prefix+name);
				if(obj != undefined && obj != null){
					var text_array = [];
					var value_array = [];
					for(var i = 0; i<obj.base.length; i++){
						if(i != obj.base.length -1){
							text_array.push(obj.base[i].childNodes[0].innerText);
							value_array.push(obj.base[i].childNodes[0]._value);
						}
					}
					for(i in value_array){
						obj.enableItem(name,value_array[i]);
					}
				}
			}else if(prefix == "chk"){
				obj = $erp.getObjectFromId(prefix+name);
				if(obj != undefined && obj != null){
					obj.enableItem(prefix+name);
				}
			}else if(prefix == "txt"){
				obj = document.getElementById(prefix+name);
				if(obj != undefined && obj != null){
					obj.readOnly=false;
					obj.disabled=false;
					//obj.removeAttribute("class", "input_readonly");
				}
			}
		}
		
		if($erp.isArray(dhtmlxObjId)){
			for(var id in dhtmlxObjId){
				exec(dhtmlxObjId[id]);
			}
		}else{
			exec(dhtmlxObjId);
		}
	}
	
	/** 
	* Description 
	* @function getAddressMap
	* @function_Description 우편번호, 주소 리턴 객체
	* @param daumData (object) 다음 리턴값
	* @author 조승현
	*/
	this.getAddressMap = function(daumData){
		resultMap = {};
		
//		console.log(daumData);
		
		//R:도로명, J:지번
		var selectType = daumData.userSelectedType;
		
		var roadAddress;
		if(daumData.roadAddress != ""){
			roadAddress = daumData.roadAddress;
		}else{
			roadAddress = daumData.autoRoadAddress;
		}
		
		var jibunAddress;
		if(daumData.jibunAddress != ""){
			jibunAddress = daumData.jibunAddress;
		}else{
			jibunAddress = daumData.autoJibunAddress;
		}
		
		var subAddressList = [];
		if(daumData.bname != ""){
			subAddressList.push(daumData.bname);
		}
		
		if(daumData.buildingName != ""){
			subAddressList.push(daumData.buildingName);
		}
		
		var sumSubAddress = "";
		if(subAddressList.length>0){
			for(var index in subAddressList){
				sumSubAddress = sumSubAddress + subAddressList[index] + ", "
			}
			
			//마지막 콤마 제거
			sumSubAddress = sumSubAddress.substr(0, sumSubAddress.length - 2);
			
			sumSubAddress = "(" + sumSubAddress + ")";
		}
		
		roadAddress = roadAddress + sumSubAddress;
		jibunAddress = jibunAddress + sumSubAddress;
		
		resultMap.roadZipNo = daumData.zonecode;
		resultMap.roadAddress = roadAddress;
		
		resultMap.jibunZipNo = daumData.postcode1 + '' + daumData.postcode2;
		resultMap.jibunAddress = jibunAddress;
		
		resultMap.selectZipNo = selectType == "R"? resultMap.roadZipNo : resultMap.jibunZipNo;
		resultMap.selectAddress = selectType == "R"? roadAddress : jibunAddress;
		
		return resultMap;
	}
	
	/** 
	* Description 
	* @function getBusinessNum
	* @function_Description 10자리 문자열이면서 숫자라면 사업자 등록번호로 변경후 리턴
	* @param value (string) 문자열
	* @author 조승현
	*/
	this.getBusinessNum = function(value){
		if(!value){
			//로직 없음
		}else if(value.length == 10 && $.isNumeric(value)){
			value = value.replace(/(.{5})/,"$1-").replace(/(.{3})/,"$1-");
		}else{
			value = "사업자등록번호 아님";
		}
		return value;
	}
	
	/** 
	* Description 
	* @function getBackBusinessNum
	* @function_Description 사업자등록번호를 숫자로 변경
	* @param value (string) 문자열
	* @author 조승현
	*/
	this.getBackBusinessNum = function(value){
		return value.replace(/-/g,"");
	}
	
	/** 
	* Description 
	* @function putKeyAndValueToListMap
	* @function_Description 리스트맵 구조의 전체 맵에 특정 키:값 추가
	* @param listMap (object) 리스트맵 구조 파라미터
	* @param key (string) 추가할 키
	* @param value (string) 추가할 값
	* @author 조승현
	*/
	this.putKeyAndValueToListMap = function(listMap, key, value){
		
		for(var i in listMap){
			listMap[i][key] = value;
		}
		
		return listMap;
	}
	
	
	/** 
	* Description 
	* @function dataSerializeOfGridByCRUD
	* @function_Description 해당 그리드의 모든 행의 모든 컬럼명과 컬럼의 값을 {key : value}로 직렬화하되 CRUD 별로 구분하여 리스트 생성
	* @param dhtmlXGridObj (Object) / DhtmlX grid 객체
	* @param isUseLUI / (boolean) 그리드 직렬화시 lui 정보 삽입 여부
	* @param addData / (Object) 그리드 직렬화시 추가할 데이터
	* @author 조승현
	*/
	this.dataSerializeOfGridByCRUD = function(dhtmlXGridObj,isUseLUI,addData){
		
		if(dhtmlXGridObj == undefined || dhtmlXGridObj == null){
			$erp.alertMessage({
				"alertMessage" : "그리드 객체가 필요합니다.",
				"alertCode" : "1번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}
		var dhtmlXDataProcessor = dhtmlXGridObj.getDataProcessor();
		if(!dhtmlXDataProcessor){
			$erp.alertMessage({
				"alertMessage" : "파라미터로 사용된 그리드에<br/>데이타프로세서 초기화가 필요합니다.",
				"alertCode" : null,
				"alertType" : "error",
				"isAjax" : false,
			});
		}

		var row_count = dhtmlXGridObj.getRowsNum();
		var column_count = dhtmlXGridObj.getColumnsNum();
		
		var send_data = {C:[], R:[], U:[], D:[]};
		
		//console.log("↓↓↓dataSerializeOfGridByCRUD↓↓↓");
		var rId;
		var state;
		var send_CRUD;
		var column_name;
		var column_value;
		for(var row_idx = 0; row_idx < row_count; row_idx ++){
			rId = dhtmlXGridObj.getRowId(row_idx);
			if(rId == "NoDataPrintRow"){
				return [];
			}
			state = dhtmlXDataProcessor.getState(rId);
			send_CRUD = "R";
			if(state == "inserted"){
				send_CRUD = "C";
			} else if (state == "updated"){
				send_CRUD = "U";
			} else if (state == "deleted") {
				send_CRUD = "D";
			}
			
			send_data[send_CRUD].push({});
			send_data[send_CRUD][send_data[send_CRUD].length-1]["rowId"] = rId;
			send_data[send_CRUD][send_data[send_CRUD].length-1]["CRUD"] = send_CRUD;
			
			for (var col_idx = 0; col_idx < column_count; col_idx++){
				column_name = dhtmlXGridObj.getColumnId(col_idx);
				column_value = dhtmlXGridObj.cells(rId, col_idx).getValue();
				/*console.log(column_name);
				console.log(column_value);
				console.log(row_idx);
				console.log(col_idx);*/
				send_data[send_CRUD][send_data[send_CRUD].length-1][column_name] = column_value;
			}
			
			if(isUseLUI == true && window.LUI){
				send_data[send_CRUD][send_data[send_CRUD].length-1] = $erp.unionObjArray([send_data[send_CRUD][send_data[send_CRUD].length-1],window.LUI]);
			}
			
			if(addData){
				if(addData.constructor == Object){
					send_data[send_CRUD][send_data[send_CRUD].length-1] = $erp.unionObjArray([send_data[send_CRUD][send_data[send_CRUD].length-1],addData]);
				}else{
					throw new Error("객체 타입이 아닙니다.");
				}
			}
		}
		//console.log(send_data);
		//console.log("↑↑↑dataSerializeOfGridByCRUD↑↑↑");
		return send_data;
	}
	
	
	/** 
	* Description 
	* @function getDhtmlXComboTableCode
	* @function_Description 특정테이블 레코드로 콤보 박스만들기
	* @param domElementId (String) / Dom Element Object ID
	* @param paramName (String) / Form Parameter 전송 시 사용할 Name
	* @param url (String) / 콤보박스를 만들기위한 데이터를 받을 url
	* @param paramMap (Object) / 파라미터로 보낼 맵형태의 객체
	* @param paramWidth (Number) / dom 가로 길이
	* @param blankText (String) / 텍스트 , 비어있는 value 사용시 설정
	* @param showCode (String) / 텍스트 표시할때 코드 value 값도 보여줄 것인지 아니면 일반 텍스트만 보여줄것인지 여부
	* @param defaultOption (String) / 초기화시 갖게될 기본 선택 값
	* @param callbackFunction (function) / 콜백 함수
	* @author 조승현
	*/
	this.getDhtmlXComboTableCode = function(domElementId, paramName, url, paramMap, paramWidth, blankText, showCode, defaultValue, callbackFunction){
		var defaultWidth = 200;
		var width = defaultWidth;
		if(paramWidth && !isNaN(paramWidth)){
			width = paramWidth;
		}
		if(blankText == null){
			blankText = undefined;
		}
		if(defaultValue == null || defaultValue == ''){
			defaultValue = undefined;
		}
		
		if(!url){
			$erp.alertMessage({
				"alertMessage" : "url이 지정되지 않았습니다.",
				"alertType" : "alert",
				"isAjax" : false,
			});
			return;
		}
		
		var dhtmlXComboObject = null;
		if(domElementId != undefined){
			/* new dhtmlXCombo(id, name, width); */       
			dhtmlXComboObject = new dhtmlXCombo(domElementId, paramName, width);
			dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
			dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
			dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
			dhtmlXComboObject.readonly(true);   
			document.getElementById(domElementId).setAttribute("name", paramName);

			$erp.asyncObjAddStart(domElementId);
			
			$erp.setDhtmlXComboTableCodeUseAjax(dhtmlXComboObject, url, paramMap, blankText, showCode, defaultValue, callbackFunction);
		}
		return dhtmlXComboObject;
	}
	
	
	/** 
	* Description 
	* @function setDhtmlXComboTableCodeUseAjax
	* @function_Description Ajax를 통한 DhtmlXCombo Data 생성
	* @param dhtmlXComboObject (Object) / 생성한 DhtmlXComboObject $erp.getDhtmlXCombo Function 활용
	* @param url (String) / 콤보박스를 만들기위한 데이터를 받을 url
	* @param paramMap (Object) / 파라미터로 보낼 맵형태의 객체
	* @param blankText (String) / 텍스트 , 비어있는 value 사용시 설정
	* @param showCode (String) / 텍스트 표시할때 코드 value 값도 보여줄 것인지 아니면 일반 텍스트만 보여줄것인지 여부
	* @param defaultValue (String) / 초기화시 갖게될 기본 선택 값
	* @param callbackFunction (function) / 콜백 함수
	* @author 조승현
	*/
	this.setDhtmlXComboTableCodeUseAjax = function(dhtmlXComboObject, url, paramMap, blankText, showCode, defaultValue, callbackFunction){
		
		$.ajax({
			url : url
			,data : paramMap
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {            
					var detailCodeList = data.detailCodeList;
					var optionArray = [];   
					if(blankText != undefined && blankText != null && blankText !== false){
						/* blankText가 true인 경우 전체로 Text 변경 */
						if(blankText === true){
							blankText = "모두조회";
							optionArray.push({ value : "", text : blankText});
						}else if(blankText == "AllOrOne"){
							if(detailCodeList.length>1){
								blankText = "모두조회";
								optionArray.push({ value : "", text : blankText});
							}
						}else if(typeof blankText == "string" && blankText != ""){
							optionArray.push({ value : "", text : blankText});
						}
					}
					var detailCodeObj;
					var option;
					var value;
					for(var i in detailCodeList){
						detailCodeObj = detailCodeList[i];            
						option = { value : null, text : null};
						for(var key in detailCodeObj){
							value =  detailCodeObj[key];
							if(showCode == undefined || showCode == null || showCode == true){
								if(key == 'DETAIL_CD'){
									option.value = value;
								} else if(key == 'DETAIL_CD_NM'){
									option.text = value;
								} else {
									option[key] = value;
								}
							}else{
								if(key == 'DETAIL_CD'){
									option.value = value;
								} else if(key == 'DETAIL_NM'){
									option.text = value;
								} else {
									option[key] = value;
								}
							}
						}   
						optionArray.push(option);           
					}
					dhtmlXComboObject.addOption(optionArray);
					if(typeof dhtmlXComboObject.getParent() === 'string'){
						if(dhtmlXComboObject.getOptionsCount() > 0){
							dhtmlXComboObject.selectOption(0);
						}
						if(defaultValue != undefined && defaultValue != null){
							if(dhtmlXComboObject.getOption(defaultValue) != null){
								dhtmlXComboObject.setComboValue(defaultValue);
							}
						}
					}
					  
					if(callbackFunction && typeof callbackFunction === 'function'){
						callbackFunction.apply(dhtmlXComboObject, []);
					}
					
					$erp.asyncObjAddEnd(dhtmlXComboObject.DOMParent);
					
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	/** 
	* Description 엔터키 입력시 리본의 특정 버튼 클릭 이벤트 강제 호출
	* @function useRibbonOnEnterKey
	* @function_Description Ajax를 통한 DhtmlXCombo Data 생성
	* @param url (String) / 이벤트
	* @param ribbonObj (Object) / dhtxml 리본 객체
	* @param id (String) / 리본 클릭 호출할 id
	* @author 조승현
	*/
	this.useRibbonOnEnterKey = function(event, ribbonObj, id){
		var keyCode = (window.event) ? event.which : event.keyCode;
		if (keyCode == 13) {
			if(event.target && event.target.blur){
				event.target && event.target.blur();
			}
			ribbonObj.callEvent("onClick",[id]);
			return false;
		}
		return true;
	}
	
	/** 
	* @function copyRowsGridToGrid
	* @function_Description from 그리드에서 to 그리드로 선택된 로우 복제
	* @param fromGrid (dhltmlxGridObj) / 그리드 객체
	* @param toGrid (dhltmlxGridObj) / 그리드 객체
	* @param fromGridColumnIdList (Array) / fromGrid 에서 복사해갈 컬럼 아이디 리스트
	* @param toGridColumnIdList (Array) / fromGrid 에서 복사된 컬럼아이디 에 매칭될 toGrid 의 컬럼아이디 리스트
	* @param dataType (string) / "checked" 또는 "selected" 또는 "updated" : 해당하는 상태의 데이터만 추출하여 toGrid 에 복사
	* @param copyType (string) / "add" 또는 "new" : add 사용시 toGrid가 한번도 조회되지않은 상태일시 메세지 발생
	* @param editableColumnIdListOfInsertedRows (Array) / inserted 상태 로우의 수정 가능한 컬럼 Id 리스트
	* @param notEditableColumnIdListOfInsertedRows (Array) / inserted 상태 로우의 수정 불가능한 컬럼 Id 리스트
	* @param duplicationTargetKeyAndInitValueObj (Object) / fromGrid 와 toGrid 가 중복될때 기존 toGrid 의 값 중에 임의의 초기값으로 변경이 필요할시에 사용하는 객체
	* 														[key(그리드 id), value(초기화값)] value 는 초기화 값 필요시에만 사용 나머지는 "" 또는 null 이용                             
	*
	* @param copyTargetKeyAndInitValueObj (Object) / fromGrid에서 복사되는 값 중에 임의의 초기값이 필요할시에 사용하는 객체
	*                                         		 [key(그리드 id), value(초기화값)] value 는 초기화 값 필요시에만 사용 나머지는 "" 또는 null 이용
	* @param callback (function)
	* @param isShowDefaultMessage boolean / 그리드간 데이터 복사후 기본메시지 출력 여부
	* @author 조승현
	*/
	this.copyRowsGridToGrid = function(fromGrid, toGrid, fromGridColumnIdList, toGridColumnIdList, dataState, copyType, editableColumnIdListOfInsertedRows, notEditableColumnIdListOfInsertedRows, duplicationTargetKeyAndInitValueObj, copyTargetKeyAndInitValueObj, callback, isShowDefaultMessage){
		
		var existCheckObj = {}; //중복체크용 그리드데이터를 uniqueId를 이용한 객체형으로 변환
		var baseCount; //기존 개수
		var duplicationCount_in_choiceDataList = 0; //fromGrid 리스트 내에서 발생 할 수 있는 중복 개수 카운트
		var duplicationRowIndexList_in_toGrid = []; //fromGrid 에서 toGrid 로 복사중 발생한 중복 로우 인덱스 리스트
		var duplicationRowIndex_in_toGrid; //중복 로우 인덱스
		var changeIndexObj = {}; //중복된 데이터중에 변경된 로우의 인덱스 집합
		var changeIndex; //중복된 데이터중에 변경된 로우
		var addCount = 0; //추가된 개수
		
		var fromGridUniqueId;
		if(fromGridColumnIdList && (fromGridColumnIdList.constructor != Array || fromGridColumnIdList.length < 1)){
			$erp.alertMessage({
				"alertMessage" : "copyRowsGridToGrid<br/>배열 타입의 파라미터여야 하며<br/>1개이상의 컬럼아이디가 필요합니다.(필수)",
				"alertCode" : "3번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}else{
			
			fromGridUniqueId = fromGridColumnIdList[0];
			
			var isExist = false;
			for(var i = 0; i<fromGrid.getColumnsNum(); i++){
				if(fromGrid.getColumnId(i) == fromGridUniqueId){
					isExist = true;
				}
			}
			
			if(!isExist){
				$erp.alertMessage({
					"alertMessage" : "copyRowsGridToGrid<br/>중복검사를 위해 사용 될 fromGrid의 유니크 컬럼아이디가<br/>배열 인덱스[0]에 필요합니다.(필수)",
					"alertCode" : "3번째 파라미터",
					"alertType" : "error",
					"isAjax" : false
				});
				return;
			}
		}
			
		var toGridUniqueId;
		if(toGridColumnIdList && (toGridColumnIdList.constructor != Array || toGridColumnIdList.length < 1)){
			$erp.alertMessage({
				"alertMessage" : "copyRowsGridToGrid<br/>배열 타입의 파라미터여야 하며<br/>1개이상의 컬럼아이디가 필요합니다.(필수)",
				"alertCode" : "4번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}else{
			
			toGridUniqueId = toGridColumnIdList[0];
			
			var isExist = false;
			for(var i = 0; i<toGrid.getColumnsNum(); i++){
				if(toGrid.getColumnId(i) == toGridUniqueId){
					isExist = true;
				}
			}
			
			if(!isExist){
				$erp.alertMessage({
					"alertMessage" : "copyRowsGridToGrid<br/>3번째 파라미터인 fromGrid의 유니크 컬럼아이디와 매칭되는<br/> toGrid의 컬럼아이디가 배열 인덱스[0]에 필요합니다.(필수)",
					"alertCode" : "4번째 파라미터",
					"alertType" : "error",
					"isAjax" : false
				});
				return;
			}
		}
		
		
		if(fromGridColumnIdList.length != toGridColumnIdList.length){
			$erp.alertMessage({
				"alertMessage" : "copyRowsGridToGrid<br/>배열의 길이가 같아야합니다.",
				"alertCode" : "3,4번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}
		
		if(typeof dataState == "string"){
			if(dataState == "checked" || dataState == "selected"){
				
			}else{
				$erp.alertMessage({
					"alertMessage" : "copyRowsGridToGrid<br/>올바른 데이터 상태가 아닙니다<br/>checked 또는 selected",
					"alertCode" : "5번째 파라미터",
					"alertType" : "error",
					"isAjax" : false
				});
				return;
			}
		}else{
			$erp.alertMessage({
				"alertMessage" : "copyRowsGridToGrid<br/>스트링 타입이여야합니다.(필수)",
				"alertCode" : "5번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}
		
		if(typeof copyType == "string"){
			if(copyType == "add" || copyType == "new"){
				
			}else{
				$erp.alertMessage({
					"alertMessage" : "copyRowsGridToGrid<br/>올바른 복사 타입이 아닙니다<br/>add 또는 new",
					"alertCode" : "6번째 파라미터",
					"alertType" : "error",
					"isAjax" : false
				});
				return;
			}
		}else{
			$erp.alertMessage({
				"alertMessage" : "copyRowsGridToGrid<br/>스트링 타입이여야합니다.(필수)",
				"alertCode" : "6번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}
		
		if(editableColumnIdListOfInsertedRows && editableColumnIdListOfInsertedRows.constructor != Array){
			$erp.alertMessage({
				"alertMessage" : "copyRowsGridToGrid<br/>배열 타입이여야합니다.",
				"alertCode" : "7번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}
		
		if(notEditableColumnIdListOfInsertedRows && notEditableColumnIdListOfInsertedRows.constructor != Array){
			$erp.alertMessage({
				"alertMessage" : "copyRowsGridToGrid<br/>배열 타입이여야합니다.",
				"alertCode" : "8번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}
		
		if(duplicationTargetKeyAndInitValueObj && duplicationTargetKeyAndInitValueObj.constructor != Object){
			$erp.alertMessage({
				"alertMessage" : "copyRowsGridToGrid<br/>객체 타입이여야합니다.",
				"alertCode" : "9번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}
		
		if(copyTargetKeyAndInitValueObj && copyTargetKeyAndInitValueObj.constructor != Object){
			$erp.alertMessage({
				"alertMessage" : "copyRowsGridToGrid<br/>객체 타입이여야합니다.",
				"alertCode" : "10번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}
		
		if(window["static_total_layout"] && window["static_total_layout"] instanceof dhtmlXLayoutObject){
	    	window["static_total_layout"].progressOff();
	    	window["static_total_layout"].progressOn();
	    }
		
		setTimeout(function(){
			
			var original_toGridData_variableName = "copy" + "_to_" + toGrid.divId; //임의로 윈도우 전역변수로 사용하기위한 변수명 생성
			if(window[original_toGridData_variableName] == undefined){
				window[original_toGridData_variableName] = {};
				
				window[original_toGridData_variableName]["toGrid_onClearAll_id"] = null;
				window[original_toGridData_variableName]["toGrid_onClearAll"] = function(){
					window[original_toGridData_variableName]["toGrid_data"] = null;
				}
				
				window[original_toGridData_variableName]["toGrid_data"] = null;
			}
			
			var fromGridData = $erp.dataSerializeOfGridByMode(fromGrid, dataState);
			
			var newAddRowDataList = []; //신규 추가된 로우 데이타 리스트
			var isJump = false;
			if(fromGridData.length > 0){
//			if(window[original_toGridData_variableName]["toGrid_data"].length == 0 && toGrid.getRowsNum() == 0){
				if(copyType == "add"){
					if(toGrid.getRowsNum() == 0){
						$erp.alertMessage({
							"alertMessage" : "한번도 조회되지 않았거나 재조회가 필요합니다.",
							"alertCode" : "추가 대상 그리드",
							"alertType" : "error",
							"isAjax" : false
						});
						isJump = true;
					}
				}
				
				if(!isJump){
					if(window[original_toGridData_variableName]["toGrid_onClearAll_id"]){
						toGrid.detachEvent(window[original_toGridData_variableName]["toGrid_onClearAll_id"]);
						window[original_toGridData_variableName]["toGrid_onClearAll_id"] = null;
					}
					
					for(var index in fromGridData){
						fromGridData[index]["CHECK"] = "0";
						for(var key in copyTargetKeyAndInitValueObj){ // 임의의 초기값이 있다면 설정
							if(copyTargetKeyAndInitValueObj[key] != undefined && copyTargetKeyAndInitValueObj[key] != null){
								fromGridData[index][key] = copyTargetKeyAndInitValueObj[key];
							}
						}
						if(existCheckObj[fromGridData[index][fromGridUniqueId]] == undefined){
							existCheckObj[fromGridData[index][fromGridUniqueId]] = fromGridData[index];
						}else{
							existCheckObj[fromGridData[index][fromGridUniqueId]] = fromGridData[index];
							duplicationCount_in_choiceDataList++;
						}
					}
					
					window[original_toGridData_variableName]["toGrid_data"] = $erp.dataSerializeOfGrid(toGrid);
					
					var original_toGridData = $.extend(true, [], window[original_toGridData_variableName]["toGrid_data"]);
					baseCount = original_toGridData.length;
					
					for(var index in original_toGridData){
						if(existCheckObj[original_toGridData[index][toGridUniqueId]] == undefined || existCheckObj[original_toGridData[index][toGridUniqueId]] == null){
							//로직없음
						}else{//이미 있는 것 null 처리
							existCheckObj[original_toGridData[index][toGridUniqueId]] = null;
							duplicationRowIndexList_in_toGrid.push(index);
						}
					}
					
					for(var i in duplicationRowIndexList_in_toGrid){
						duplicationRowIndex_in_toGrid = duplicationRowIndexList_in_toGrid[i];
						for(var key in duplicationTargetKeyAndInitValueObj){
							if(duplicationTargetKeyAndInitValueObj[key] != undefined && duplicationTargetKeyAndInitValueObj[key] != null){
								original_toGridData[duplicationRowIndex_in_toGrid][key] = duplicationTargetKeyAndInitValueObj[key];
								changeIndexObj[duplicationRowIndex_in_toGrid] = duplicationRowIndex_in_toGrid;
							}
						}
					}
					
					var addRowData;
					for(var key in existCheckObj){
						addRowData = existCheckObj[key];
						if(addRowData != undefined && addRowData != null){
							for(var iii in fromGridColumnIdList){
								addRowData[toGridColumnIdList[iii]] = addRowData[fromGridColumnIdList[iii]];
							}
							original_toGridData.push(addRowData);
							newAddRowDataList.push(addRowData);
							addCount++;
						}
					}
					
					$erp.clearDhtmlXGrid(toGrid); //기존데이터 삭제
					
					toGrid.parse(original_toGridData,"js"); //속도이슈때문에 addRow 를 사용하지않음
					
					var toGrid_processor = toGrid.getDataProcessor();
					var gd = window[original_toGridData_variableName]["toGrid_data"];
					
					var insertedRowIndexList = [];
					//fromGrid를 통해서 추가,업데이트 되기전 toGrid의 가장 최신 데이터 로우 상태 세팅
					var state;
					for(var index in gd){
						state = gd[index]["CRUD"];
						if(state == "C"){
							toGrid_processor.setUpdated(toGrid.getRowId(index), true, "inserted");
							insertedRowIndexList.push(index);
						}else if(state == "U"){
							toGrid_processor.setUpdated(toGrid.getRowId(index), true, "updated");
						}else if(state == "D"){
							toGrid_processor.setUpdated(toGrid.getRowId(index), true, "deleted");
						}
					}
					
					//fromGrid를 통해서 업데이트된 로우 상태 세팅
					for(var key in changeIndexObj){
						changeIndex = changeIndexObj[key];
						toGrid_processor.setUpdated(toGrid.getRowId(changeIndex), true, "updated");
					}
					
					//fromGrid를 통해서 새로 추가된 로우 상태 세팅
					for(var index = baseCount; index<original_toGridData.length; index++){
						toGrid_processor.setUpdated(toGrid.getRowId(index), true, "inserted");
						insertedRowIndexList.push(index);
					}
					
					if(editableColumnIdListOfInsertedRows && editableColumnIdListOfInsertedRows instanceof Array){
						$erp.rowsEditableManagement(toGrid, insertedRowIndexList, editableColumnIdListOfInsertedRows);
					}
					if(notEditableColumnIdListOfInsertedRows && notEditableColumnIdListOfInsertedRows instanceof Array){
						$erp.rowsNotEditableManagement(toGrid, insertedRowIndexList, notEditableColumnIdListOfInsertedRows);
					}
				}
			}
			
			var result = {};
			var standardColumnValue_indexAndRowId_obj = {};
			if(!isJump){
				if(isShowDefaultMessage === false){
					
				}else{
					if(duplicationRowIndexList_in_toGrid.length > 0 || duplicationCount_in_choiceDataList > 0){
						$erp.alertMessage({
//						"alertMessage" : "[선택한 데이터내에 중복 : " + duplicationCount_in_choiceDataList + "개]<br/>[선택한 데이터 추가중 발생 중복 : " + duplicationRowIndexList_in_toGrid.length + "개]<br/>[발생된 중복 데이터중 값 변경 : " + Object.keys(changeIndexObj).length + "개]<br/>[신규 : " + addCount + "개]<br/><br/>추가완료",
							"alertMessage" : "[중복 : " + duplicationRowIndexList_in_toGrid.length + "개]<br/>[신규 : " + addCount + "개]",
							"alertType" : "error",
							"isAjax" : false
						});
					}else{
						$erp.alertMessage({
							"alertMessage" : "[신규 : " + addCount + "개]",
							"alertType" : "error",
							"isAjax" : false
						});
					}
					
				}
				$erp.setDhtmlXGridFooterRowCount(toGrid); // 현재 행수 계산
				
				var rowId;
				for(var index=0; index<toGrid.getRowsNum(); index++){
					rowId = toGrid.getRowId(index);
					standardColumnValue_indexAndRowId_obj[original_toGridData[index][toGridUniqueId]] = [index, rowId];
				}
			}
			
			result["requestAddRowCount"] = fromGridData.length;											//아무런 처리없이 추가 요청한 데이터 초기 로우수
			result["newAddRowDataList"] = newAddRowDataList;											//새로 추가된 로우 데이타 리스트
			result["standardColumnValue_indexAndRowId_obj"] = standardColumnValue_indexAndRowId_obj;	//기준 컬럼의 값을 key, [인덱스,로우아이디]를 value 로 가진 객체
			result["insertedRowIndexList"] = insertedRowIndexList;										//로우 상태가 inserted 인 로우인덱스 리스트
			result["editableColumnIdListOfInsertedRows"] = editableColumnIdListOfInsertedRows;			//로우 상태가 inserted 인 로우의 수정가능한 컬럼 Id 리스트
			result["notEditableColumnIdListOfInsertedRows"] = notEditableColumnIdListOfInsertedRows;	//로우 상태가 inserted 인 로우의 수정불가능한 컬럼 Id 리스트
			result["duplicationCount_in_toGridDataList"] = duplicationRowIndexList_in_toGrid.length;	//toGrid 에 추가중 발생한 중복 데이터 개수
			
			if(window[original_toGridData_variableName]["toGrid_onClearAll_id"] == null){
				window[original_toGridData_variableName]["toGrid_onClearAll_id"] = toGrid.attachEvent("onClearAll", window[original_toGridData_variableName]["toGrid_onClearAll"]);
			}
			
			if(window["static_total_layout"] && window["static_total_layout"] instanceof dhtmlXLayoutObject){
				window["static_total_layout"].progressOff();
			}
			
			if(callback && typeof callback == "function"){
				callback(result);
			}
		},10);

	}
	
	/** 
	* Description 
	* @function deleteGridCheckedRows
	* @function_Description 그리드 체크된 로우 삭제 줄긋기 또는 아직 저장 되지않은 로우는 즉시삭제후 로우 재정렬 및 행수계산
	* @param dhtmlXGridObj (Object) / DhtmlXGrid Object
	* @param editableColumnIdListOfInsertedRows (Array) / inserted 상태 로우의 수정 가능한 컬럼 Id 리스트
	* @param notEditableColumnIdListOfInsertedRows (Array) / inserted 상태 로우의 수정 불가능한 컬럼 Id 리스트
	* @author 조승현
	*/
	this.deleteGridCheckedRows = function(dhtmlXGridObj, editableColumnIdListOfInsertedRows, notEditableColumnIdListOfInsertedRows){
		
		var checkedColumnIndex = dhtmlXGridObj.getColIndexById("CHECK");
		
		var checkedRowIdList = dhtmlXGridObj.getCheckedRows(dhtmlXGridObj.getColIndexById("CHECK")).split(",");
		
		var rowId;
		var rowIndex;
		var checkedRowIndexList = [];
		var checkedRowIndex;
		for(var i in checkedRowIdList){
			rowId = checkedRowIdList[i];
			rowIndex = dhtmlXGridObj.getRowIndex(rowId);
			checkedRowIndexList[rowIndex] = rowIndex;
		}
		
		var dp = dhtmlXGridObj.getDataProcessor();
		
		var gridDataList = $erp.dataSerializeOfGrid(dhtmlXGridObj);
		
		var newGridData = [];
		
		if(dp){
			var state;
			for(var i=0; i< gridDataList.length; i++){
				state = dp.getState(dhtmlXGridObj.getRowId(i));
				gridDataList[i]["CATCH_STATE"] = state;
				
				if(checkedRowIndexList[i] != undefined && checkedRowIndexList[i] != null){
					if(state == "inserted"){
						// 인서트 상태를 가진 로우가 삭제되어야한다면 바로삭제를 위해서 푸쉬안함
					}else{
						gridDataList[i]["CATCH_STATE"] = "deleted";
						newGridData.push(gridDataList[i]);
					}
				}else{
					newGridData.push(gridDataList[i]);
				}
				
			}
			
			$erp.clearDhtmlXGrid(dhtmlXGridObj);
			
			dhtmlXGridObj.parse(newGridData,"js");
			
			var insertedRowIndexList = [];
			for(var index in newGridData){
				state = newGridData[index]["CATCH_STATE"];
				if(state == "inserted" || state == "updated" || state == "deleted"){
					dp.setUpdated(dhtmlXGridObj.getRowId(index), true, state); //inserted, updated, deleted
					if(state == "inserted"){
						insertedRowIndexList.push(index);
					}
				}
			}
			
			if(editableColumnIdListOfInsertedRows && editableColumnIdListOfInsertedRows instanceof Array){
				$erp.rowsEditableManagement(dhtmlXGridObj, insertedRowIndexList, editableColumnIdListOfInsertedRows);
			}
			if(notEditableColumnIdListOfInsertedRows && notEditableColumnIdListOfInsertedRows instanceof Array){
				$erp.rowsNotEditableManagement(dhtmlXGridObj, insertedRowIndexList, notEditableColumnIdListOfInsertedRows);
			}
			
		}else{
			
			for(var i in checkedRowIndexList){
				checkedRowIndex = checkedRowIndexList[i];
				gridDataList[checkedRowIndex] = null;
			}
			
			for(var i in gridDataList){
				if(gridDataList[i]){
					newGridData.push(gridDataList[i]);
				}
			}
			
			$erp.clearDhtmlXGrid(dhtmlXGridObj);
			
			dhtmlXGridObj.parse(newGridData,"js");
		}
		
		$erp.setDhtmlXGridFooterRowCount(dhtmlXGridObj); //행수 재계산
	}
	
	/** 
	* Description 
	* @function deleteGridRows
	* @function_Description 그리드의 로우 인덱스 리스트를 이용한 로우삭제
	* @param dhtmlXGridObj (Object) / DhtmlXGrid Object
	* @param deleteRowIndexList (Array) / 삭제할 그리드 로우 인덱스 리스트
	* @param editableColumnIdListOfInsertedRows (Array) / inserted 상태 로우의 수정 가능한 컬럼 Id 리스트
	* @param notEditableColumnIdListOfInsertedRows (Array) / inserted 상태 로우의 수정 불가능한 컬럼 Id 리스트
	* @author 조승현
	*/
	this.deleteGridRows = function(dhtmlXGridObj, deleteRowIndexList, editableColumnIdListOfInsertedRows, notEditableColumnIdListOfInsertedRows){
		
		var rowIndex;
		var finalDeleteRowIndexList = [];
		var finalDeleteRowIndex;
		for(var i in deleteRowIndexList){
			rowIndex = deleteRowIndexList[i];
			finalDeleteRowIndexList[rowIndex] = rowIndex;
		}
		
		if(deleteRowIndexList == undefined || deleteRowIndexList == null || deleteRowIndexList.length < 1){
			return;
		}
		
		var dp = dhtmlXGridObj.getDataProcessor();
		
		var gridDataList = $erp.dataSerializeOfGrid(dhtmlXGridObj);
		
		var newGridData = [];
		
		if(dp){
			var state;
			for(var i=0; i< gridDataList.length; i++){
				state = dp.getState(dhtmlXGridObj.getRowId(i));
				gridDataList[i]["CATCH_STATE"] = state;
				
				if(finalDeleteRowIndexList[i] != undefined && finalDeleteRowIndexList[i] != null){
					if(state == "inserted"){
						// 인서트 상태를 가진 로우가 삭제되어야한다면 바로삭제를 위해서 푸쉬안함
					}else{
						gridDataList[i]["CATCH_STATE"] = "deleted";
						newGridData.push(gridDataList[i]);
					}
				}else{
					newGridData.push(gridDataList[i]);
				}
				
			}
			
			$erp.clearDhtmlXGrid(dhtmlXGridObj);
			
			dhtmlXGridObj.parse(newGridData,"js");
			
			var insertedRowIndexList = [];
			for(var index in newGridData){
				state = newGridData[index]["CATCH_STATE"];
				if(state == "inserted" || state == "updated" || state == "deleted"){
					dp.setUpdated(dhtmlXGridObj.getRowId(index), true, state); //inserted, updated, deleted
					if(state == "inserted"){
						insertedRowIndexList.push(index);
					}
				}
			}
			
			if(editableColumnIdListOfInsertedRows && editableColumnIdListOfInsertedRows instanceof Array){
				$erp.rowsEditableManagement(dhtmlXGridObj, insertedRowIndexList, editableColumnIdListOfInsertedRows);
			}
			if(notEditableColumnIdListOfInsertedRows && notEditableColumnIdListOfInsertedRows instanceof Array){
				$erp.rowsNotEditableManagement(dhtmlXGridObj, insertedRowIndexList, notEditableColumnIdListOfInsertedRows);
			}
			
		}else{
			
			for(var i in finalDeleteRowIndexList){
				finalDeleteRowIndex = finalDeleteRowIndexList[i];
				gridDataList[finalDeleteRowIndex] = null;
			}
			
			for(var i in gridDataList){
				if(gridDataList[i]){
					newGridData.push(gridDataList[i]);
				}
			}
			
			$erp.clearDhtmlXGrid(dhtmlXGridObj);
			
			dhtmlXGridObj.parse(newGridData,"js");
		}
		
		$erp.setDhtmlXGridFooterRowCount(dhtmlXGridObj); //행수 재계산
	}
	
	/** 
	* Description 
	* @function rowsEditableManagement
	* @function_Description 로우인덱스리스트에 있는 로우들의 컬럼마다 수정 가능 여부 세팅
	* @param dhtmlXGridObj (Object) / DhtmlXGrid Object
	* @param rowIndexList (Array) / 로우인덱스 리스트
	* @param editableColumnIdList (Array) / 수정 가능한 컬럼 Id 리스트
	* @author 조승현
	*/
	this.rowsEditableManagement = function(dhtmlXGridObj, rowIndexList, editableColumnIdList){
		var columnTypeObj = {};
		for(var index=0; index<dhtmlXGridObj.cellType.length; index++){
			columnTypeObj[index] = dhtmlXGridObj.cellType[index];
		}
		
		if(rowIndexList && !(rowIndexList instanceof Array)){
			$erp.alertMessage({
				"alertMessage" : "배열 객체가 아닙니다.",
				"alertCode" : "2번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
		}
		
		if(editableColumnIdList && !(editableColumnIdList instanceof Array)){
			$erp.alertMessage({
				"alertMessage" : "배열 객체가 아닙니다.",
				"alertCode" : "3번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
		}
		
		if(rowIndexList == undefined || rowIndexList == null){
			rowIndexList = [];
			for(var index=0; index<dhtmlXGridObj.getRowsNum(); index++){
				rowIndexList.push(index);
			}
		}
		
		if(editableColumnIdList == undefined || editableColumnIdList == null){
			editableColumnIdList = [];
		}
		
		
		var rowIndex;
		var rowId;
		var columnId;
		var columnIndexList = [];
		for(var index in editableColumnIdList){
			columnId = editableColumnIdList[index];
			columnIndexList.push(dhtmlXGridObj.getColIndexById(columnId));
		}
		
		if(columnIndexList.length == 0){
			return;
		}
		
		var columnIndex;
		var columnType;
		var cellInstance;
		for(var ii in rowIndexList){
			rowIndex = rowIndexList[ii];
			rowId = dhtmlXGridObj.getRowId(rowIndex);
			
			for(var i in columnIndexList){
				columnIndex = columnIndexList[i];
				columnType = columnTypeObj[columnIndex];
			
				if(columnType == "ra" || columnType == "combo" || columnType == "dhxCalendarA" || columnType == "ch"){
					dhtmlXGridObj.cells(rowId, columnIndex).setDisabled(false);
				}else{
					cellInstance = dhtmlXGridObj.cells(rowId, columnIndex);
					if(cellInstance instanceof eXcell_ron){
						dhtmlXGridObj.setCellExcellType(rowId, columnIndex,"edn");
					}else if(cellInstance instanceof eXcell_ro){
						dhtmlXGridObj.setCellExcellType(rowId, columnIndex,"ed");
					}
				}
			}
		}
	}
	
	/** 
	* Description 
	* @function rowsNotEditableManagement
	* @function_Description 로우인덱스리스트에 있는 로우들의 컬럼마다 수정 가능 여부 세팅
	* @param dhtmlXGridObj (Object) / DhtmlXGrid Object
	* @param rowIndexList (Array) / 로우인덱스 리스트
	* @param notEditableColumnIdList (Array) / 수정 불가능한 컬럼 Id 리스트
	* @author 조승현
	*/
	this.rowsNotEditableManagement = function(dhtmlXGridObj, rowIndexList, notEditableColumnIdList){
		var columnTypeObj = {};
		for(var index=0; index<dhtmlXGridObj.cellType.length; index++){
			columnTypeObj[index] = dhtmlXGridObj.cellType[index];
		}
		
		if(rowIndexList && !(rowIndexList instanceof Array)){
			$erp.alertMessage({
				"alertMessage" : "배열 객체가 아닙니다.",
				"alertCode" : "2번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
		}
		
		if(notEditableColumnIdList && !(notEditableColumnIdList instanceof Array)){
			$erp.alertMessage({
				"alertMessage" : "배열 객체가 아닙니다.",
				"alertCode" : "3번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
		}
		
		if(rowIndexList == undefined || rowIndexList == null){
			rowIndexList = [];
			for(var index=0; index<dhtmlXGridObj.getRowsNum(); index++){
				rowIndexList.push(index);
			}
		}
		
		if(notEditableColumnIdList == undefined || notEditableColumnIdList == null){
			notEditableColumnIdList = [];
		}
		
		
		var rowIndex;
		var rowId;
		var columnId;
		var columnIndexList = [];
		for(var index in notEditableColumnIdList){
			columnId = notEditableColumnIdList[index];
			columnIndexList.push(dhtmlXGridObj.getColIndexById(columnId));
		}
		
		if(columnIndexList.length == 0){
			return;
		}
		
		var columnIndex;
		var columnType;
		var cellInstance;
		for(var ii in rowIndexList){
			rowIndex = rowIndexList[ii];
			rowId = dhtmlXGridObj.getRowId(rowIndex);
			
			for(var i in columnIndexList){
				columnIndex = columnIndexList[i];
				columnType = columnTypeObj[columnIndex];
			
				if(columnType == "ra" || columnType == "combo" || columnType == "dhxCalendarA" || columnType == "ch"){
					dhtmlXGridObj.cells(rowId, columnIndex).setDisabled(true);
				}else{
					cellInstance = dhtmlXGridObj.cells(rowId, columnIndex);
					if(cellInstance instanceof eXcell_edn){
						dhtmlXGridObj.setCellExcellType(rowId, columnIndex,"ron");
					}else if(cellInstance instanceof eXcell_ed){
						dhtmlXGridObj.setCellExcellType(rowId, columnIndex,"ro");
					}
				}
			}
		}
	}
	
	
	/** 
	 * Description 
	 * @function gridValidationCheck
	 * @function_Description DhtmlXGrid 내 Essential(필수) Column 데이터 입력 여부 및 길이 유효성 검증
	 * @param dhtmlXGridObj (Object) / DhtmlXGrid Object
	 * @param callback (function) 그리드 데이터가 모두 유효 할 시 실행할 콜백
	 * @author 조승현
	 */
	this.gridValidationCheck = function(dhtmlXGridObj, callback) {
		var resultMap = {
			isError: false,
			errRowIdx: null,
			errColumnName: null,
			errMessage: null,
			errCode: null,
			errMessageParam: null
		};
		if(dhtmlXGridObj == undefined || dhtmlXGridObj == null) {
			resultMap.isError = true;
			resultMap.errMessage = "error.common.unknownGridObject";
			resultMap.errCode = "-2001";
			return resultMap;
		}
		var columnsMapArray = dhtmlXGridObj.columnsMapArray;
		if(columnsMapArray == undefined || columnsMapArray == null) {
			resultMap.isError = true;
			resultMap.errMessage = "error.common.unknownGridColumn";
			resultMap.errCode = "-2002";
			return resultMap;
		}
		var dhtmlXDataProcessor = dhtmlXGridObj.getDataProcessor();
		if(dhtmlXDataProcessor == undefined || dhtmlXDataProcessor == null) {
			resultMap.isError = true;
			resultMap.errMessage = "error.common.unknownGridDataProcessor";
			resultMap.errCode = "-2003";
			return resultMap;
		}
		
		if(dhtmlXDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}
		
		var updatedRows = dhtmlXDataProcessor.updatedRows;
		var colCount = columnsMapArray.length;
		var i = 0;
		var j = 0;

		var isEssentialBeginDate = false;
		var beginDateColumn = "";
		var isEssentialEndDate = false;
		var endDateColumn = "";
		
		var showErrorMessage = function(errorMap){
			$erp.alertMessage({
				"alertMessage" : errorMap.errMessage
				, "alertCode" : errorMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : errorMap.errMessageParam
			});
		}

		for(i = 0; i < updatedRows.length; i++) {
			var rId = updatedRows[i];
			var status = dhtmlXDataProcessor.getState(rId);
			if(status == "deleted") {
				continue;
			}
			
			for(j = 0; j < colCount; j++) {
				var isEssential = columnsMapArray[j].isEssential;
				var maxLength = columnsMapArray[j].maxLength;
				var alertMessage = "";
				var alertCode = "";
				if(isEssential != undefined && isEssential != null && isEssential == true) {
					var id = columnsMapArray[j].id;
					if(id.indexOf("BEGIN_DATE") > -1) {
						isEssentialBeginDate = true;
						beginDateColumn = id;
					} else if(id.indexOf("END_DATE") > -1) {
						isEssentialEndDate = true;
						endDateColumn = id;
					}

					var value = dhtmlXGridObj.cells(rId, j).getValue();
					if(value == undefined || value == null || value == "") {
						alertMessage = "error.common.noEssentialGridData";
						alertCode = "-2004";
					}
				}

				if(maxLength != undefined && maxLength != null && !isNaN(maxLength)) {
					maxLength = maxLength - 0;
					if(maxLength < 0) {
						maxLength = 0;
					}
					var value = dhtmlXGridObj.cells(rId, j).getValue();
					if(value != undefined && value != null && value != "" && value.length > maxLength) {
						alertMessage = "error.common.overMaxLengthGridData";
						alertCode = "-2005";
					}
				}

				if(alertMessage != "") {
					var rowIdx = dhtmlXGridObj.getRowIndex(rId);

					resultMap.isError = true;
					resultMap.errMessage = alertMessage;

					var columnName = null;
					var columnLabel = columnsMapArray[j].label;
					if(typeof columnLabel === 'object' && $erp.isArray(columnLabel)) {
						if(columnLabel.length > 1) {
							columnName = columnLabel[1];
							if(columnName.indexOf("#") > -1) {
								columnName = columnLabel[0];
							}
						} else {
							columnName = columnLabel[0];
						}
					} else if(typeof columnLabel === 'string') {
						columnName = columnLabel;
					}

					resultMap.errCode = alertCode;
					if(alertCode == "-2004") {
						resultMap.errMessageParam = [(rowIdx + 1), columnName];
					} else if(alertCode == "-2005") {
						resultMap.errMessageParam = [(rowIdx + 1), columnName, maxLength];
					}
					resultMap.errRowIdx = (rowIdx + 1);
					resultMap.errColumnName = columnName;
					
					if(resultMap.isError){
						showErrorMessage(resultMap);
						return;
					}
				}
			}

			if(isEssentialBeginDate === true && isEssentialEndDate === true) {
				var begin_date = dhtmlXGridObj.cells(rId, dhtmlXGridObj.getColIndexById(beginDateColumn)).getValue();
				var end_date = dhtmlXGridObj.cells(rId, dhtmlXGridObj.getColIndexById(endDateColumn)).getValue();

				if(begin_date > end_date) {
					var rowIdx = dhtmlXGridObj.getRowIndex(rId);

					resultMap.isError = true;
					resultMap.errMessage = "error.common.invalidBeginEndDateInGrid";
					resultMap.errCode = "-2006";
					resultMap.errRowIdx = (rowIdx + 1);
					resultMap.errMessageParam = [(rowIdx + 1)];
					
					if(resultMap.isError){
						showErrorMessage(resultMap);
						return;
					}
				}
			}

		}
		
		if(callback && typeof callback == "function"){
			callback();
		}
	}
	
	
	/** Description
	 * @function validateCardInfo
	 * @function_Description DhtmlXGrid Excel 출력
	 * @param param (Object) / grid : Grid Object
								, fileName : 파일명
								, isOnlyEssentialColumn : 필수 컬럼들만 다운로드
								, excludeColumnIdList : 제외 컬럼 아이디 리스트 (Array)
								, isIncludeHidden : 히든 컬럼 포함 여부 (bool)
								, isExcludeGridData : 그리드에 있는 데이터를 양식에 포함하지 않음 (bool)
	 * @author 조승현
	 */
	this.exportGridToExcel = function(param) {
		var grid = param.grid;
		var fileName = param.fileName;
		var isOnlyEssentialColumn = param.isOnlyEssentialColumn;
		var excludeColumnIdList = param.excludeColumnIdList;
		var isIncludeHidden = param.isIncludeHidden;
		var isExcludeGridData = param.isExcludeGridData;

		var excludeColumnIdsObj = null; //제외컬럼아이디를 모아둘 객체
		if (excludeColumnIdList && excludeColumnIdList.constructor == Array) {
			excludeColumnIdsObj = {};
			
			var columnId;
			for (var index in excludeColumnIdList) {
				columnId = excludeColumnIdList[index];
				excludeColumnIdsObj[columnId] = true;
			}
		}

		if(!fileName || typeof fileName != "string"){
			fileName = "엑셀 다운로드";
		}
		
		var gridRowCount;
		
		gridRowCount = grid.getRowsNum();
		if(gridRowCount > 0){
			if( grid.getRowId(0) == "NoDataPrintRow"){
				gridRowCount = 0;
			}
		}
		
		if (isExcludeGridData && isExcludeGridData === true) { //그리드 데이터 제외시
			gridRowCount = 0;
		}
		
		var columnsMapArray = grid.columnsMapArray;
		var headerDepth = 1;
		var finalColumnMapList = [];
		var columnMap;
		var isHidden;
		var label;
		var type;
		var width;
		var isEssential;
		for (var i in columnsMapArray) {
			columnMap = columnsMapArray[i];
			if (excludeColumnIdsObj) {
				var id = columnMap.id;
				if (excludeColumnIdsObj[id] === true) {
					continue;
				}
			}
			
			width = grid.getColWidth(i);

			isHidden = columnMap.isHidden;
			if(isHidden && isHidden == true){
	            if ((!isIncludeHidden || (isIncludeHidden && isIncludeHidden == false))) {
	               continue;
	            }else{
	            	columnMap.isHidden = false;
	            	width = 100;
	            }
	        }
			
			
			
			label = columnMap.label;
			if (label) {
				if ($erp.isArray(label)) {
//					if (label.length > headerDepth) {
//						headerDepth = label.length;
//					}
					if(label[0] == "#master_checkbox"){
						columnMap.label = ["CHECK"];
						width = 50;
					}else{
						columnMap.label = [label[0]];
					}
				}else{
					if(label == "#master_checkbox"){
						columnMap.label = "CHECK";
						width = 50;
					}
				}
			}
			type = columnMap.type;
			isEssential = columnMap.isEssential;
			if (isOnlyEssentialColumn && isOnlyEssentialColumn == true) {
				if(!isEssential || (isEssential && isEssential == false)){
					continue;
				}
			}
			
			if (type == "ra") {
				continue;
			}else if(type == "combo"){
				columnMap.comboOption = {};
				var dhtmlXComboObject = grid.getColumnCombo(i);
				dhtmlXComboObject.forEachOption(function(option){
					columnMap.comboOption[option.text] = option.value;
				});
				
			}
			if(columnMap.label[0].split("</br>").length > 1){//줄 바꿈 문자열 공백으로 치환
				columnMap.label[0] = columnMap.label[0].split("</br>").join(" ");
			}
			columnMap.width = width;
			finalColumnMapList.push(columnMap);
		}

		var contentsObject = [];
		var gridColCount = finalColumnMapList.length;
		var rowMap;
		var rId;
		var finalColumnMap;
		var cId;
		var cell;
		var text;
		
		for (var i = 0; i < gridRowCount; i++) {
			rowMap = {};
			rId = grid.getRowId(i);
			for (var j = 0; j < gridColCount; j++) {
				finalColumnMap = finalColumnMapList[j];
				cId = finalColumnMap.id;
				cell = grid.cells(rId, grid.getColIndexById(cId));
				text = cell.getContent ? cell.getContent() : cell.getTitle();
				if (finalColumnMap.type == "chn" || finalColumnMap.type == "ch") {
					text = cell.getValue() == 1 ? "Y" : "N";
				}else if(finalColumnMap.type == "combo"){
					text = cell.getValue();
				}
				
				//console.log("finalColumnMap.type : " + finalColumnMap.type + "  / text : "+text);
				rowMap[cId] = text;
			}
			contentsObject.push(rowMap);
		}
		
		var requestForm = document.createElement("FORM");
		requestForm.setAttribute("method", "post");
		requestForm.setAttribute("action", "/common/system/file/downloadGridExcel.do");
		requestForm.setAttribute("accept-charset", "utf-8");
		requestForm.setAttribute("enctype", "application/x-www-form-urlencoded");
		/*requestForm.setAttribute("target", "_blank");*/

		var headerInputElement = document.createElement("INPUT");
		headerInputElement.setAttribute("type", "hidden");
		headerInputElement.setAttribute("name", "header");
		headerInputElement.value = JSON.stringify(finalColumnMapList);
		requestForm.appendChild(headerInputElement);

		var contentsInputElement = document.createElement("INPUT");
		contentsInputElement.setAttribute("type", "hidden");
		contentsInputElement.setAttribute("name", "contents");
		contentsInputElement.value = JSON.stringify(contentsObject);
		requestForm.appendChild(contentsInputElement);
		
		if(gridRowCount == 0){
			var formYnInputElement = document.createElement("INPUT");
			formYnInputElement.setAttribute("type", "hidden");
			formYnInputElement.setAttribute("name", "form_yn"); 
			formYnInputElement.value = "Y"; // 레코드 로직 수행안하도록
			requestForm.appendChild(formYnInputElement);
		}

		var fileNameInputElement = document.createElement("INPUT");
		fileNameInputElement.setAttribute("type", "hidden");
		fileNameInputElement.setAttribute("name", "fileName");
		fileNameInputElement.value = fileName;
		requestForm.appendChild(fileNameInputElement);

		var headerDepthInputElement = document.createElement("INPUT");
		headerDepthInputElement.setAttribute("type", "hidden");
		headerDepthInputElement.setAttribute("name", "headerDepth");
		headerDepthInputElement.value = headerDepth;
		requestForm.appendChild(headerDepthInputElement);

		indexWindow.document.body.appendChild(requestForm);
		requestForm.submit();
		indexWindow.document.body.removeChild(requestForm);
	}
	
	/** 
	 * Description 
	 * @function headerSerializeOfGrid
	 * @function_Description 그리드 헤더 직렬화
	 * @param dhtmlXGridHeaderMapArray (Array) / DhtmlXGrid Object
	 * @author 조승현
	 */
	this.headerSerializeOfGrid = function(dhtmlXGridObject) {
		var dhtmlXGridHeaderMapArray = dhtmlXGridObject.columnsMapArray;
		var serializedData = {};
		var cnt = dhtmlXGridHeaderMapArray.length;
		var arrId = [];
		var arrIsHidden = [];
		var arrType = [];
		var arrIsEssential = [];
		var arrLabel = [];

		for(var i = 0; i < cnt; i++) {
			var id = dhtmlXGridHeaderMapArray[i].id;
			var isHidden = dhtmlXGridHeaderMapArray[i].isHidden === true ? true : false;
			var type = dhtmlXGridHeaderMapArray[i].type;
			var label = dhtmlXGridHeaderMapArray[i].label;
			label = label[0];
			if(label == "#master_checkbox"){
				label = "CHECK";
			}
			
			if(id != '' && 
							(
								type == 'ed'			||
								type == 'edn'			||
								type == 'combo'			||
								type == 'dhxCalendarA'	||
								type == 'ro'			||
								type == 'ron'			||
								type == 'ch'
							)){
				arrId.push(id);
				arrIsHidden.push(isHidden);
				arrType.push(type);
				arrLabel.push(label);
			}
		}
		
		serializedData.id = arrId;
		serializedData.isHidden = arrIsHidden;
		serializedData.type = arrType;
		serializedData.label = arrLabel;
		return serializedData;
	}
	
	/** 
	 * Description 
	 * @function uploadDataParse
	 * @function_Description 업로드된 데이터를 대상 그리드에 파싱
	 * @param vaultObject (dhtmlxVaultObject)
	 * @param files (Object) / 파일정보
	 * @param uploadDataList (Array) / 서버에서 전달되는 리스트맵 형태의 자료 구조 데이터
	 * @param toGrid (dhltmlxGridObj) / 그리드 객체
	 * @param standardColumnId (String) / 업로드 추가시 중복 검사용 기준 컬럼아이디
	 * @param copyType (string) / "add" 또는 "new" : add 사용시 toGrid가 한번도 조회되지않은 상태일시 메세지 발생
	 * @param editableColumnIdListOfInsertedRows (Array) / inserted 상태 로우의 수정 가능한 컬럼 Id 리스트
	 * @param notEditableColumnIdListOfInsertedRows (Array) / inserted 상태 로우의 수정 불가능한 컬럼 Id 리스트
	 * @author 조승현
	 */
	this.uploadDataParse = function(vaultObject, files, uploadDataList, toGrid, standardColumnId, copyType, editableColumnIdListOfInsertedRows, notEditableColumnIdListOfInsertedRows, returnObj){
		var existCheckObj = {}; //중복체크용 그리드데이터를 uniqueId를 이용한 객체형으로 변환
		var baseCount; //기존 개수
		var duplicationCount_in_addDataList = 0; //upload 리스트 내에서 발생 할 수 있는 중복 개수 카운트
		var duplicationRowIndexList_in_toGrid = []; //upload 에서 toGrid 로 복사중 발생한 중복 로우 인덱스 리스트
		var duplicationRowIndex_in_toGrid; //중복 로우 인덱스
		var changeIndexObj = {}; //중복된 데이터중에 변경된 로우의 인덱스 집합
		var changeIndex; //중복된 데이터중에 변경된 로우
		var addCount = 0; //추가된 개수

			
		if(!(standardColumnId && typeof standardColumnId == "string")){
			$erp.alertMessage({
				"alertMessage" : "uploadDataParse<br/>업로드 추가시 중복 검사용 기준 컬럼아이디가 필요합니다.(필수)",
				"alertCode" : "5번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}

		if(typeof copyType == "string"){
			if(copyType == "add" || copyType == "new"){
				
			}else{
				$erp.alertMessage({
					"alertMessage" : "uploadDataParse<br/>올바른 복사타입이 아닙니다<br/>add 또는 new",
					"alertCode" : "6번째 파라미터",
					"alertType" : "error",
					"isAjax" : false
				});
				return;
			}
		}else{
			$erp.alertMessage({
				"alertMessage" : "uploadDataParse<br/>복사타입(스트링)이 필요합니다.(필수)",
				"alertCode" : "6번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}

		if(editableColumnIdListOfInsertedRows && editableColumnIdListOfInsertedRows.constructor != Array){
			$erp.alertMessage({
				"alertMessage" : "uploadDataParse<br/>배열 타입이여야합니다.",
				"alertCode" : "7번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}

		if(notEditableColumnIdListOfInsertedRows && notEditableColumnIdListOfInsertedRows.constructor != Array){
			$erp.alertMessage({
				"alertMessage" : "uploadDataParse<br/>배열 타입이여야합니다.",
				"alertCode" : "8번째 파라미터",
				"alertType" : "error",
				"isAjax" : false
			});
			return;
		}

		if(window["static_total_layout"] && window["static_total_layout"] instanceof dhtmlXLayoutObject){
			window["static_total_layout"].progressOff();
			window["static_total_layout"].progressOn();
		}

		setTimeout(function(){
			
			var original_toGridData_variableName = "copy" + "_to_" + toGrid.divId; //임의로 윈도우 전역변수로 사용하기위한 변수명 생성
			if(window[original_toGridData_variableName] == undefined){
				window[original_toGridData_variableName] = {};
				
				window[original_toGridData_variableName]["toGrid_onClearAll_id"] = null;
				window[original_toGridData_variableName]["toGrid_onClearAll"] = function(){
					window[original_toGridData_variableName]["toGrid_data"] = null;
				}
				
				window[original_toGridData_variableName]["toGrid_data"] = null;
			}

			var isJump = false;
			if(uploadDataList.length > 0){
		//			if(window[original_toGridData_variableName]["toGrid_data"].length == 0 && toGrid.getRowsNum() == 0){
				if(copyType == "add"){
					if(toGrid.getRowsNum() == 0){
						$erp.alertMessage({
							"alertMessage" : "한번도 조회되지 않았거나 재조회가 필요합니다.",
							"alertCode" : "추가 대상 그리드",
							"alertType" : "error",
							"isAjax" : false
						});
						isJump = true;
					}
				}
				
				if(!isJump){
					if(window[original_toGridData_variableName]["toGrid_onClearAll_id"]){
						toGrid.detachEvent(window[original_toGridData_variableName]["toGrid_onClearAll_id"]);
						window[original_toGridData_variableName]["toGrid_onClearAll_id"] = null;
					}
					
					var columnsMapArray = toGrid.columnsMapArray;
					var columnType;
					for(var index in uploadDataList){
						if(uploadDataList[index]["CHECK"] == "Y"){
							uploadDataList[index]["CHECK"] = "1";
						}else{
							uploadDataList[index]["CHECK"] = "0";
						}
						
						for(var index2 in columnsMapArray){
							columnType = columnsMapArray[index2]["type"];
							if(columnType == "dhxCalendarA"){//켈린더 타입 데이터는 "-" 제거
								uploadDataList[index][columnsMapArray[index2]["id"]] = uploadDataList[index][columnsMapArray[index2]["id"]].replace(/-/g,"");
							}
						}
						
						if(existCheckObj[uploadDataList[index][standardColumnId]] == undefined){
							existCheckObj[uploadDataList[index][standardColumnId]] = uploadDataList[index];
						}else{
							existCheckObj[uploadDataList[index][standardColumnId]] = uploadDataList[index];
							duplicationCount_in_addDataList++;
						}
					}
					
					window[original_toGridData_variableName]["toGrid_data"] = $erp.dataSerializeOfGrid(toGrid);
					
					var original_toGridData = $.extend(true, [], window[original_toGridData_variableName]["toGrid_data"]);
					baseCount = original_toGridData.length;
					
					var original_toGridData_row;
					
					for(var index in original_toGridData){
						if(existCheckObj[original_toGridData[index][standardColumnId]] == undefined || existCheckObj[original_toGridData[index][standardColumnId]] == null){
							//로직없음
						}else{
							original_toGridData_row = original_toGridData[index];
							for(var index2 in columnsMapArray){
								columnType = columnsMapArray[index2]["type"];
								if(columnType == "ro" || columnType == "ron"){
									continue;
								}
								
								//수정 가능타입 컬럼일때만 기존데이터를 업로드데이터로 변경
								original_toGridData[index][columnsMapArray[index2]["id"]] = existCheckObj[original_toGridData[index][standardColumnId]][columnsMapArray[index2]["id"]]; 
							}
							
							existCheckObj[original_toGridData[index][standardColumnId]] = null; //이미 있는 것 null 처리
							duplicationRowIndexList_in_toGrid.push(index);
						}
					}
					
					for(var i in duplicationRowIndexList_in_toGrid){
						duplicationRowIndex_in_toGrid = duplicationRowIndexList_in_toGrid[i];
						changeIndexObj[duplicationRowIndex_in_toGrid] = duplicationRowIndex_in_toGrid;
					}
					
					var addRowData;
					var newAddRowDataList = [];
					for(var key in existCheckObj){
						addRowData = existCheckObj[key];
						if(addRowData != undefined && addRowData != null){
							newAddRowDataList.push(addRowData);
							original_toGridData.push(addRowData);
							addCount++;
						}
					}
					
					$erp.clearDhtmlXGrid(toGrid); //기존데이터 삭제
					toGrid.parse(original_toGridData,"js"); //속도이슈때문에 addRow 를 사용하지않음
					
					var toGrid_processor = toGrid.getDataProcessor();
					var gd = window[original_toGridData_variableName]["toGrid_data"];
					
					var insertedRowIndexList = [];
					//upload를 통해서 추가,업데이트 되기전 toGrid의 가장 최신 데이터 로우 상태 세팅
					var state;
					for(var index in gd){
						state = gd[index]["CRUD"];
						if(state == "C"){
							toGrid_processor.setUpdated(toGrid.getRowId(index), true, "inserted");
							insertedRowIndexList.push(index);
						}else if(state == "U"){
							toGrid_processor.setUpdated(toGrid.getRowId(index), true, "updated");
						}else if(state == "D"){
							toGrid_processor.setUpdated(toGrid.getRowId(index), true, "deleted");
						}
					}
					
					//upload를 통해서 업데이트된 로우 상태 세팅
					for(var key in changeIndexObj){
						changeIndex = changeIndexObj[key];
						toGrid_processor.setUpdated(toGrid.getRowId(changeIndex), true, "updated");
					}
					
					//upload를 통해서 새로 추가된 로우 상태 세팅
					for(var index = baseCount; index<original_toGridData.length; index++){
						toGrid_processor.setUpdated(toGrid.getRowId(index), true, "inserted");
						insertedRowIndexList.push(index);
					}
					
					if(editableColumnIdListOfInsertedRows && editableColumnIdListOfInsertedRows instanceof Array){
						$erp.rowsEditableManagement(toGrid, insertedRowIndexList, editableColumnIdListOfInsertedRows);
					}
					if(notEditableColumnIdListOfInsertedRows && notEditableColumnIdListOfInsertedRows instanceof Array){
						$erp.rowsNotEditableManagement(toGrid, insertedRowIndexList, notEditableColumnIdListOfInsertedRows);
					}
				}
			}
			
//			if(!isJump){
//				if(duplicationRowIndexList_in_toGrid.length > 0 || duplicationCount_in_addDataList > 0){
//					$erp.alertMessage({
//						"alertMessage" : "[엑셀 데이터내에 중복 : " + duplicationCount_in_addDataList + "개]<br/>[엑셀 데이터 업로드중 발생 중복 : " + duplicationRowIndexList_in_toGrid.length + "개]<br/>[발생된 중복 데이터중 값 변경 : " + Object.keys(changeIndexObj).length + "개]<br/>[신규 : " + addCount + "개]<br/><br/>추가완료",
//						"alertType" : "error",
//						"isAjax" : false
//					});
//				}else{
//					$erp.alertMessage({
//						"alertMessage" : "[신규 : " + addCount + "개]<br/>추가완료",
//						"alertType" : "error",
//						"isAjax" : false
//					});
//				}
				
				$erp.setDhtmlXGridFooterRowCount(toGrid); // 현재 행수 계산
//			}
			
			
			if(window[original_toGridData_variableName]["toGrid_onClearAll_id"] == null){
				window[original_toGridData_variableName]["toGrid_onClearAll_id"] = toGrid.attachEvent("onClearAll", window[original_toGridData_variableName]["toGrid_onClearAll"]);
			}
			
			if(window["static_total_layout"] && window["static_total_layout"] instanceof dhtmlXLayoutObject){
				window["static_total_layout"].progressOff();
			}
			
			var result = {};
			var standardColumnValue_indexAndRowId_obj = {};
			var rowId;
			for(var index=0; index<toGrid.getRowsNum(); index++){
				rowId = toGrid.getRowId(index);
				standardColumnValue_indexAndRowId_obj[original_toGridData[index][standardColumnId]] = [index, rowId];
			}
			result["requestAddRowCount"] = uploadDataList.length;										//아무런 처리없이 추가 요청한 데이터 초기 로우수
			result["newAddRowDataList"] = newAddRowDataList;											//새로 추가된 로우 데이타 리스트
			result["standardColumnValue_indexAndRowId_obj"] = standardColumnValue_indexAndRowId_obj;	//기준 컬럼의 값을 key, [인덱스,로우아이디]를 value 로 가진 객체
			result["insertedRowIndexList"] = insertedRowIndexList;										//로우 상태가 inserted 인 로우인덱스 리스트
			result["editableColumnIdListOfInsertedRows"] = editableColumnIdListOfInsertedRows;			//로우 상태가 inserted 인 로우의 수정가능한 컬럼 Id 리스트
			result["notEditableColumnIdListOfInsertedRows"] = notEditableColumnIdListOfInsertedRows;	//로우 상태가 inserted 인 로우의 수정불가능한 컬럼 Id 리스트
			result["duplicationCount_in_toGridDataList"] = duplicationRowIndexList_in_toGrid.length;	//toGrid 에 추가중 발생한 중복 데이터 개수
//			result["duplicationCount_in_addDataList"] = duplicationCount_in_addDataList;				//업로드 데이터내에 중복데이터 개수

			vaultObject.callEvent("onUploadComplete", [null,result]);
			
		},10);
	}
	
	
	/** 
	 * Description 
	 * @function requestFileDownload
	 * @function_Description 첨부파일 다운로드 요청
	 * @param downloadFileInfo (object) 다운로드할 파일 정보
	 * @author 조승현
	 */
	this.requestFileDownload = function(downloadFileInfo) {

		var actionUrl = "/common/system/file/requestFileDownload.do";
		
		if(downloadFileInfo && downloadFileInfo.constructor === Object){
			var inputDomListString = "";
			for(var key in downloadFileInfo){
				inputDomListString += '<input type="hidden" name="' + key + '" value="' + downloadFileInfo[key] + '" />';
			}
			$('<form action="' + actionUrl + '" method="post">' + inputDomListString + '</form>').appendTo('body').submit().remove();
		}else{
			$erp.alertMessage({
				"alertMessage" : "객체 형태의 다운로드 파일정보가 필요합니다.",
				"alertType" : "error",
				"isAjax" : false
			});
		}
	}
	
	/** 
	 * Description 
	 * @function getOrgnDivCdByOrgnCd
	 * @function_Description 조직코드로 조직구분코드 불러오기
	 * @param params (String) 조직코드
	 * @author 정혜원
	 */
	this.getOrgnDivCdByOrgnCd = function(ORGN_CD) {
		var ORGN_DIV_CD;
		$.ajax({
			url : "/common/organ/getOrgnDivCdByOrgnCd.do"
			,data : {
				"ORGN_CD" : ORGN_CD
			}
			,method : "POST"
			,async : false
			,dataType : "JSON"
			,success : function(data) {
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					ORGN_DIV_CD = data.ORGN_DIV_CD;
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		
		return ORGN_DIV_CD;
	}
	
	/** 
	 * Description 
	 * @function tableValidationCheck
	 * @function_Description 테이블 필수값 입력 유효성 체크 후 이상없으면 객체 return 이상있으면 false return
	 * @param domObj (object) 돔객체
	 * @param checkValueType (string) 체크박스 벨류값 리턴 타입 ("Q", "bit", "boolean") default "Q"
	 * @author 조승현
	 */
	this.tableValidationCheck = function(getDomObj, checkValueType){
		$(':focus').blur(); //정상적인 입출력 값을 받아오려고 blur 이벤트 호출 후 유효성 검사 하기 위해서(크롬에서는 input_number 클래스를 사용하여도 키코드 이벤트가 달라서 정상 작동하지 않기 때문에)
		
		var getNotValidDomObjList = function(domObj, checkDefaultValueType, dataObject, isNotValidDomObjList){
			if($erp.isEmpty(dataObject)){
				dataObject = {};
			}
			
			if(!isNotValidDomObjList){
				isNotValidDomObjList = [];
			}
			
			if(!$erp.isEmpty(domObj)){
				if(typeof domObj === 'string'){
					domObj = document.getElementById(domObj);
				}     
			}
			
			if(domObj && domObj.childNodes){
				var child;
				var id;
				var value;
				var prefix;
				var name;
				var obj;
				var dataType;
				for(var i in domObj.childNodes){
					child = domObj.childNodes[i];
					if(child){
						if(child.attributes && child.attributes.id && child.attributes.id.value){
							id = child.attributes.id.value;
							value = "";       
							prefix = id.length >= 3 ? id.substring(0, 3) : id;
							name = id.substring(3,id.length);
							if(prefix == "cmb" || prefix == "chk" || prefix == "txt"){
								if(name != ""){
									if(prefix == "cmb"){
										obj = $erp.getObjectFromId(prefix+name);
										if(obj != undefined && obj != null){
											value = obj.getSelectedValue();
										}
									} else if(prefix == "chk"){
										obj = $erp.getObjectFromId(prefix+name);
										if(obj != undefined && obj != null){
											if(checkDefaultValueType == "Q" || checkDefaultValueType == undefined || checkDefaultValueType == null){
												value = obj.isItemChecked(prefix+name)? 'Y' : 'N';
											}else if(checkDefaultValueType == "bit"){
												value = obj.isItemChecked(prefix+name)? '1' : '0';
											}else if(checkDefaultValueType == "boolean"){
												value = obj.isItemChecked(prefix+name)? true : false;
											}
										}
									} else if(prefix == "txt"){
										obj = document.getElementById(id);
										if(obj != undefined && obj != null){
											value = obj.value;
										}
										
										if(obj.className && obj.className.indexOf("input_money") > - 1){
											value = value.replace(/,/g, "");
										}else if(obj.className && obj.className.indexOf("input_phone") > - 1){
											value = value.replace(/-/g, "");
										}
										
										dataType = obj.getAttribute("data-type");
										if(dataType){
											if(dataType == "businessNum"){
												value = $erp.getBackBusinessNum(value);//정상 값
											}
										}
									}
									
									var finalDomObject;
									if(prefix == "cmb"){
										finalDomObject = obj.cont;
									}else if(prefix == "chk"){
										finalDomObject = obj.cont;
									}else if(prefix == "txt"){
										finalDomObject = obj;
									}
									var isEssential = finalDomObject.getAttribute("data-isEssential");
									
									if(value == undefined || value == null || value == ""){
										if(isEssential != undefined && isEssential != null && isEssential === "true"){
											if(prefix == "cmb"){
												isNotValidDomObjList.push([finalDomObject.children[0], "필수 선택 옵션 입니다."]);
											} else if(prefix == "txt"){
												isNotValidDomObjList.push([finalDomObject, "필수 입력란 입니다."]);
											}
										}
									}else{
										if(isEssential != undefined && isEssential != null && isEssential === "true"){
											if(prefix == "chk"){
												var isNotValidCheckValue = false;
												if(checkDefaultValueType == "Q" || checkDefaultValueType == undefined || checkDefaultValueType == null){
													if(value == "N"){
														isNotValidCheckValue = true;
													}
												}else if(checkDefaultValueType == "bit"){
													if(value == "0"){
														isNotValidCheckValue = true;
													}
												}else if(checkDefaultValueType == "boolean"){
													if(value == false){
														isNotValidCheckValue = true;
													}
												}
												if(isNotValidCheckValue){
													isNotValidDomObjList.push([finalDomObject.querySelector('.dhxform_img.chbx0'), "필수 체크 항목입니다."]);
												}
											}else if(prefix == "txt"){
												if(dataType && dataType == "email"){
													var isValidEmail = value.toString().match(/(^[a-z0-9]([0-9a-z\-_\.]*)@([0-9a-z_\-\.]*)([.][a-z]{3})$)|(^[a-z]([0-9a-z_\.\-]*)@([0-9a-z_\-\.]*)(\.[a-z]{2,5})$)/i);
													if(!isValidEmail){
														isNotValidDomObjList.push([finalDomObject, "잘못된 형식의 이메일 입니다."]);
													}
												}
											}
										}
									}
								
									dataObject[name] = value;
								}
							}
						}
						if(child.childNodes){
							getNotValidDomObjList(child, checkDefaultValueType, dataObject, isNotValidDomObjList);
						}
					}
				}
			}
			
			if(isNotValidDomObjList.length > 0){
				return isNotValidDomObjList;
			}else{
				return dataObject;
			}
		}
		
		var result = getNotValidDomObjList(getDomObj, checkValueType);
		if(result.constructor == Array){
			$erp.initDhtmlXPopupDom(result[0][0],result[0][1]);
			return false;
		}else{
			return result;
		}
		
	}
	
	
	/** 
	* Description 
	* @function getDhtmlXMultiCheckComboTableCode
	* @function_Description 특정테이블 레코드로 멀티체크 콤보 박스만들기
	* @param domElementId (String) / Dom Element Object ID
	* @param paramName (String) / Form Parameter 전송 시 사용할 Name
	* @param url (String) / 콤보박스를 만들기위한 데이터를 받을 url
	* @param paramMap (Object) / 파라미터로 보낼 맵형태의 객체
	* @param paramWidth (Number) / dom 가로 길이
	* @param comboText (String) / 텍스트 , 비어있는 value 사용시 설정
	* @param showCode (String) / 텍스트 표시할때 코드 value 값도 보여줄 것인지 아니면 일반 텍스트만 보여줄것인지 여부
	* @param defaultOption (String) / 초기화시 갖게될 기본 선택 값
	* @param isReadonly (boolean) / 멀티체크 콤보객체 readonly 여부
	* @param callbackFunction (function) / 콜백 함수
	* @author 조승현
	*/
	this.getDhtmlXMultiCheckComboTableCode = function(domElementId, paramName, url, paramMap, paramWidth, comboText, showCode, defaultValue, isReadonly, callbackFunction){
		var defaultWidth = 200;
		var width = defaultWidth;
		if(paramWidth && !isNaN(paramWidth)){
			width = paramWidth;
		}
		
		if(!url){
			$erp.alertMessage({
				"alertMessage" : "url이 지정되지 않았습니다.",
				"alertType" : "alert",
				"isAjax" : false,
			});
			return;
		}
		
		var dhtmlXComboObject = null;
		if(domElementId != undefined){
			/* new dhtmlXCombo(id, name, width); */       
			dhtmlXComboObject = new dhtmlXCombo(domElementId, paramName, width, "checkbox");
			dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
			dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
			dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
			dhtmlXComboObject.readonly(true);   
			document.getElementById(domElementId).setAttribute("name", paramName);
			
			dhtmlXComboObject.multiCheckReadonly(isReadonly);
			
			//체크클릭
			dhtmlXComboObject.attachEvent("onCheck", function(value, state) {
//				console.log("onCheck = "+value+"/"+state);
				
				if(!this.isMultiCheckReadonly){
					if (value == '' && this.getOptionsCount() > 1) {
						for (var i = 1; i < this.getOptionsCount(); i++) {
							this.setChecked(i, state);
						}
					} else if (value != '') {
						if(this.getOptionsCount() > 1){
							state = this.getOptionsCount() - 1 == (this.getChecked().length - (this.isChecked(0) ? 1 : 0))
							this.setChecked(0, state);
						}
					}
				}
			});
				
			
			dhtmlXComboObject.attachEvent("onClose", function() {
				var checkedArray = dhtmlXComboObject.getChecked();
				var title = '';
				for (var i = 0; i < checkedArray.length; i++) {
					title += dhtmlXComboObject.getOption(checkedArray[i]).text + "|";
				}
				title = title.substr(0, title.length - 1);
				
				//ComboText 명명
				var finalComboText = "";
				if (dhtmlXComboObject.isChecked(0)) {
					if (comboText != undefined && comboText != null && typeof comboText === "string" && comboText != "") {
						if($erp.getMultiCheckComboValue(dhtmlXComboObject).length == 1){
							$erp.getMultiCheckComboValue(dhtmlXComboObject).forEach(function(value){
								finalComboText = comboText + " (" + dhtmlXComboObject.getOption(value)["text"] + ")";
							});
						}else{
							finalComboText = comboText + " 전체(" + (this.getOptionsCount() > 1 ? this.getOptionsCount() - 1 : this.getOptionsCount()) + "/" + (this.getOptionsCount() > 1 ? this.getOptionsCount() - 1 : this.getOptionsCount()) + ")";
						}
					}else{
						if($erp.getMultiCheckComboValue(dhtmlXComboObject).length == 1){
							$erp.getMultiCheckComboValue(dhtmlXComboObject).forEach(function(value){
								finalComboText = dhtmlXComboObject.getOption(value)["text"];
							});
						}else{
							finalComboText = "전체(" + (this.getOptionsCount() > 1 ? this.getOptionsCount() - 1 : this.getOptionsCount()) + "/" + (this.getOptionsCount() > 1 ? this.getOptionsCount() - 1 : this.getOptionsCount()) + ")";
						}
					}
				} else {
					if (comboText != undefined && comboText != null && typeof comboText === "string" && comboText != "") {
						if($erp.getMultiCheckComboValue(dhtmlXComboObject).length == 1){
							$erp.getMultiCheckComboValue(dhtmlXComboObject).forEach(function(value){
								if(!dhtmlXComboObject.isEnabled()){
									finalComboText = comboText + " (" + dhtmlXComboObject.getOption(value)["text"] + ")";
								}else{
									finalComboText = comboText + " 선택(" + dhtmlXComboObject.getOption(value)["text"] + ")";
								}
							});
						}else{
							finalComboText = comboText + " 선택(" + checkedArray.length + "/" + (this.getOptionsCount() > 1 ? this.getOptionsCount() - 1 : this.getOptionsCount()) + ")";
						}
					}else{
						if($erp.getMultiCheckComboValue(dhtmlXComboObject).length == 1){
							$erp.getMultiCheckComboValue(dhtmlXComboObject).forEach(function(value){
								if(!dhtmlXComboObject.isEnabled()){
									finalComboText = "(" + dhtmlXComboObject.getOption(value)["text"] + ")";
								}else{
									finalComboText = "선택(" + dhtmlXComboObject.getOption(value)["text"] + ")";
								}
							});
						}else{
							finalComboText = "선택(" + checkedArray.length + "/" + (this.getOptionsCount() > 1 ? this.getOptionsCount() - 1 : this.getOptionsCount()) + ")";
						}
					}
				}
				dhtmlXComboObject.setComboText(finalComboText);
				//console.log(dhtmlXComboObject.getChecked());
			});

			//콤보박스 css 처리
			$('.dhxcombo_input').css('margin-left', '0px');
			$('.dhxcombo_input').css('width', '100%');

			$erp.asyncObjAddStart(domElementId);
			
			$erp.setDhtmlXMultiCheckComboTableCodeUseAjax(dhtmlXComboObject, url, paramMap, showCode, defaultValue, callbackFunction);
		}
		return dhtmlXComboObject;
	}
	
	/** 
	* Description 
	* @function setDhtmlXMultiCheckComboTableCodeUseAjax
	* @function_Description Ajax를 통한 DhtmlXCombo Data 생성
	* @param dhtmlXComboObject (Object) / 생성한 DhtmlXComboObject $erp.getDhtmlXCombo Function 활용
	* @param url (String) / 콤보박스를 만들기위한 데이터를 받을 url
	* @param paramMap (Object) / 파라미터로 보낼 맵형태의 객체
	* @param showCode (String) / 텍스트 표시할때 코드 value 값도 보여줄 것인지 아니면 일반 텍스트만 보여줄것인지 여부
	* @param defaultValue (String) / 초기화시 갖게될 기본 선택 값
	* @param callbackFunction (function) / 콜백 함수
	* @author 조승현
	*/
	this.setDhtmlXMultiCheckComboTableCodeUseAjax = function(dhtmlXComboObject, url, paramMap, showCode, defaultValue, callbackFunction){
		
		$.ajax({
			url : url
			,data : paramMap
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					var detailCodeList = data.detailCodeList;
					var optionArray = [];   
					if(detailCodeList != undefined && detailCodeList != null && detailCodeList.length > 1){
						optionArray.push({ value : "", text : "전체선택"});
					}
					var detailCodeObj;
					var option;
					var value;
					for(var i in detailCodeList){
						detailCodeObj = detailCodeList[i];
						option = { value : null, text : null};
						for(var key in detailCodeObj){
							value =  detailCodeObj[key];
							if(showCode == undefined || showCode == null || showCode == true){
								if(key == 'DETAIL_CD'){
									option.value = value;
								} else if(key == 'DETAIL_CD_NM'){
									option.text = value;
								} else {
									option[key] = value;
								}
							}else{
								if(key == 'DETAIL_CD'){
									option.value = value;
								} else if(key == 'DETAIL_NM'){
									option.text = value;
								} else {
									option[key] = value;
								}
							}
						}   
						optionArray.push(option);
					}
					dhtmlXComboObject.addOption(optionArray);
					
					if(optionArray.length > 1){
						$erp.setMultiCheckComboValue(dhtmlXComboObject, defaultValue);
					}else if(optionArray.length == 1){
						if(defaultValue != undefined && defaultValue != null && (defaultValue == "" || defaultValue == dhtmlXComboObject.getOptionByIndex(0).value || defaultValue === true)){
							dhtmlXComboObject.setChecked(0,true);
						}else{
							dhtmlXComboObject.setChecked(0,false);
						}
						dhtmlXComboObject.callEvent("onClose",[]);
					}
					
					if(callbackFunction && typeof callbackFunction === 'function'){
						callbackFunction.apply(dhtmlXComboObject, []);
					}
					
					$erp.asyncObjAddEnd(dhtmlXComboObject.DOMParent);
					
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	/** 
	* Description 
	* @function setMultiCheckComboValue
	* @function_Description 문자열, 또는 배열로 존재하는값으로 멀티 체크 콤보 박스에 checked 세팅
	* @param dhtmlXComboObject (Object)
	* @param value (String or Array) / 문자열 또는 배열
	* @author 조승현
	*/
	this.setMultiCheckComboValue = function(dhtmlXComboObject, value){
		dhtmlXComboObject.forEachOption(function(option){
			dhtmlXComboObject.setChecked(option.index,false);
		});

		if(value == undefined || value == null){
			value = [];
		}

		var value_list = null;
		if(value instanceof Array){
			value_list = value;
		}else if(typeof value === "string"){
			value_list = value.split(",");
		}
		
		var dhtmlXComboObjectId = dhtmlXComboObject.DOMParent;
		var columnName = dhtmlXComboObjectId.substring(3,dhtmlXComboObjectId.length);

		if(value_list != null){
			dhtmlXComboObject.forEachOption(function(option){
				for(var i in value_list){
					if(typeof value_list[i] == "object"){
						if(option.value == value_list[i][columnName]){
							dhtmlXComboObject.setChecked(option.index,true);
							dhtmlXComboObject.callEvent("onCheck", [option.value, true, true]);
						}
					}else if(typeof value_list[i] == "string"){
						if(option.value == value_list[i]){
							dhtmlXComboObject.setChecked(option.index,true);
							dhtmlXComboObject.callEvent("onCheck", [option.value, true, true]);
						}
					}
				}
			});
		}

		dhtmlXComboObject.callEvent("onClose",[]);
	}
	
	/** 
	* Description 
	* @function getMultiCheckComboValue
	* @function_Description 멀티 체크 콤보 박스 checked 값 얻기
	* @param dhtmlXComboObject (Object)
	* @author 조승현
	*/
	this.getMultiCheckComboValue = function(dhtmlXComboObject){
		return $.grep(dhtmlXComboObject.getChecked(), function(val){ return val != '';}); //전체선택 value 제거용
	}
	
	/** 
	* Description 
	* @function getDhtmlXMultiCheckComboCommonCode
	* @function_Description 공통코드로 멀티체크 콤보 박스만들기
	* @param domElementId (String) / Dom Element Object ID
	* @param paramName (String) / Form Parameter 전송 시 사용할 Name
	* @param cmmn_cd (Object, Array, String) / System 공통코드
	* @param paramWidth (Number) / dom 가로 길이
	* @param comboText (String) / 텍스트 , 비어있는 value 사용시 설정
	* @param showCode (String) / 텍스트 표시할때 코드 value 값도 보여줄 것인지 아니면 일반 텍스트만 보여줄것인지 여부
	* @param defaultOption (String) / 초기화시 갖게될 기본 선택 값
	* @param isReadonly (boolean) / 멀티체크 콤보객체 readonly 여부
	* @param callbackFunction (function) / 콜백 함수
	* @param useYN (String) / 공통코드 조회시 사용여부 값
	* @author 조승현
	*/
	this.getDhtmlXMultiCheckComboCommonCode = function(domElementId, paramName, cmmn_cd, paramWidth, comboText, showCode, defaultValue, isReadonly, callbackFunction, useYN){
		var defaultWidth = 200;
		var width = defaultWidth;
		if(paramWidth && !isNaN(paramWidth)){
			width = paramWidth;
		}
	
		var divParamMap = {};     
		if(!$erp.isEmpty(cmmn_cd)){
			if(typeof cmmn_cd === 'object' && $erp.isArray(cmmn_cd)){
				divParamMap.div1 = cmmn_cd[1];
				divParamMap.div2 = cmmn_cd[2];
				divParamMap.div3 = cmmn_cd[3];
				divParamMap.div4 = cmmn_cd[4];
				divParamMap.div5 = cmmn_cd[5];
				cmmn_cd = cmmn_cd[0];
			} else if(typeof cmmn_cd === 'object' && !$erp.isArray(cmmn_cd)){
				divParamMap.div1 = cmmn_cd['div1'];
				divParamMap.div2 = cmmn_cd['div2'];
				divParamMap.div3 = cmmn_cd['div3'];
				divParamMap.div4 = cmmn_cd['div4'];
				divParamMap.div5 = cmmn_cd['div5'];
				cmmn_cd = cmmn_cd['commonCode'];
			}       
		} else {
			return null;
		}
		
		var dhtmlXComboObject = null;
		if(domElementId != undefined){
			/* new dhtmlXCombo(id, name, width); */       
			dhtmlXComboObject = new dhtmlXCombo(domElementId, paramName, width, "checkbox");
			dhtmlXComboObject.setSkin(ERP_COMBO_CURRENT_SKINS);
			dhtmlXComboObject.setImagePath(ERP_COMBO_CURRENT_IMAGE_PATH);
			dhtmlXComboObject.setDefaultImage(ERP_COMBO_CURRENT_IMAGE_PATH);
			dhtmlXComboObject.readonly(true);   
			document.getElementById(domElementId).setAttribute("name", paramName);
			
			dhtmlXComboObject.multiCheckReadonly(isReadonly);
			
			//체크클릭
			dhtmlXComboObject.attachEvent("onCheck", function(value, state) {
//				console.log("onCheck = "+value+"/"+state);
				
				if(!this.isMultiCheckReadonly){
					if (value == '' && this.getOptionsCount() > 1) {
						for (var i = 1; i < this.getOptionsCount(); i++) {
							this.setChecked(i, state);
						}
					} else if (value != '') {
						if(this.getOptionsCount() > 1){
							state = this.getOptionsCount() - 1 == (this.getChecked().length - (this.isChecked(0) ? 1 : 0))
							this.setChecked(0, state);
						}
					}
				}
			});
				
			
			dhtmlXComboObject.attachEvent("onClose", function() {
				var checkedArray = dhtmlXComboObject.getChecked();
				var title = '';
				for (var i = 0; i < checkedArray.length; i++) {
					title += dhtmlXComboObject.getOption(checkedArray[i]).text + "|";
				}
				title = title.substr(0, title.length - 1);
				
				//ComboText 명명
				var finalComboText = "";
				if (dhtmlXComboObject.isChecked(0)) {
					if (comboText != undefined && comboText != null && typeof comboText === "string" && comboText != "") {
						if($erp.getMultiCheckComboValue(dhtmlXComboObject).length == 1){
							$erp.getMultiCheckComboValue(dhtmlXComboObject).forEach(function(value){
								finalComboText = comboText + " (" + dhtmlXComboObject.getOption(value)["text"] + ")";
							});
						}else{
							finalComboText = comboText + " 전체(" + (this.getOptionsCount() > 1 ? this.getOptionsCount() - 1 : this.getOptionsCount()) + "/" + (this.getOptionsCount() > 1 ? this.getOptionsCount() - 1 : this.getOptionsCount()) + ")";
						}
					}else{
						if($erp.getMultiCheckComboValue(dhtmlXComboObject).length == 1){
							$erp.getMultiCheckComboValue(dhtmlXComboObject).forEach(function(value){
								finalComboText = dhtmlXComboObject.getOption(value)["text"];
							});
						}else{
							finalComboText = "전체(" + (this.getOptionsCount() > 1 ? this.getOptionsCount() - 1 : this.getOptionsCount()) + "/" + (this.getOptionsCount() > 1 ? this.getOptionsCount() - 1 : this.getOptionsCount()) + ")";
						}
					}
				} else {
					if (comboText != undefined && comboText != null && typeof comboText === "string" && comboText != "") {
						if($erp.getMultiCheckComboValue(dhtmlXComboObject).length == 1){
							$erp.getMultiCheckComboValue(dhtmlXComboObject).forEach(function(value){
								if(!dhtmlXComboObject.isEnabled()){
									finalComboText = comboText + " (" + dhtmlXComboObject.getOption(value)["text"] + ")";
								}else{
									finalComboText = comboText + " 선택(" + dhtmlXComboObject.getOption(value)["text"] + ")";
								}
							});
						}else{
							finalComboText = comboText + " 선택(" + checkedArray.length + "/" + (this.getOptionsCount() > 1 ? this.getOptionsCount() - 1 : this.getOptionsCount()) + ")";
						}
					}else{
						if($erp.getMultiCheckComboValue(dhtmlXComboObject).length == 1){
							$erp.getMultiCheckComboValue(dhtmlXComboObject).forEach(function(value){
								if(!dhtmlXComboObject.isEnabled()){
									finalComboText = "(" + dhtmlXComboObject.getOption(value)["text"] + ")";
								}else{
									finalComboText = "선택(" + dhtmlXComboObject.getOption(value)["text"] + ")";
								}
							});
						}else{
							finalComboText = "선택(" + checkedArray.length + "/" + (this.getOptionsCount() > 1 ? this.getOptionsCount() - 1 : this.getOptionsCount()) + ")";
						}
					}
				}
				dhtmlXComboObject.setComboText(finalComboText);
				//console.log(dhtmlXComboObject.getChecked());
			});

			//콤보박스 css 처리
			$('.dhxcombo_input').css('margin-left', '0px');
			$('.dhxcombo_input').css('width', '100%');

			$erp.asyncObjAddStart(domElementId);
			
			$erp.setDhtmlXMultiCheckComboCommonCodeUseAjax(dhtmlXComboObject, cmmn_cd, divParamMap, showCode, defaultValue, callbackFunction, useYN);
		}
		return dhtmlXComboObject;
	}
	
	/** 
	* Description 
	* @function setDhtmlXMultiCheckComboCommonCodeUseAjax
	* @function_Description Ajax를 통한 DhtmlXCombo Data 생성
	* @param dhtmlXComboObject (Object) / 생성한 DhtmlXComboObject $erp.getDhtmlXCombo Function 활용
	* @param cmmn_cd (String) / System 공통코드
	* @param divParamMap (Object) / 구분 조건 Map
	* @param showCode (String) / 텍스트 표시할때 코드 value 값도 보여줄 것인지 아니면 일반 텍스트만 보여줄것인지 여부
	* @param defaultValue (String) / 초기화시 갖게될 기본 선택 값
	* @param callbackFunction (function) / 콜백 함수
	* @param useYN (String) / 공통코드 조회시 사용여부 값
	* @author 조승현
	*/
	this.setDhtmlXMultiCheckComboCommonCodeUseAjax = function(dhtmlXComboObject, cmmn_cd, divParamMap, showCode, defaultValue, callbackFunction, useYN){
		var div1;
		var div2;
		var div3;
		var div4;
		var div5;
		
		if(useYN == undefined || useYN == null){
			useYN = "";
		}
		
		if(!$erp.isEmpty(divParamMap)){
			div1 = divParamMap['div1'];
			div2 = divParamMap['div2'];
			div3 = divParamMap['div3'];
			div4 = divParamMap['div4'];
			div5 = divParamMap['div5'];
		}
		
		$.ajax({
			url : "/common/system/code/getDetailCommonCodeList.do"
			,data : {
				'CMMN_CD' : cmmn_cd
				,'DIV1' : div1
				,'DIV2' : div2
				,'DIV3' : div3
				,'DIV4' : div4
				,'DIV5' : div5
				,'USE_YN' : useYN
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					var detailCommonCodeList = data.detailCommonCodeList;
					var optionArray = [];   
					if(detailCommonCodeList != undefined && detailCommonCodeList != null && detailCommonCodeList.length > 1){
						optionArray.push({ value : "", text : "전체선택"});
					}
					var detailCommonCodeObj;
					var option;
					var value;
					for(var i in detailCommonCodeList){
						detailCommonCodeObj = detailCommonCodeList[i];
						option = { value : null, text : null};
						for(var key in detailCommonCodeObj){
							value =  detailCommonCodeObj[key];
							if(showCode == undefined || showCode == null || showCode == true){
								if(key == 'CMMN_DETAIL_CD'){
									option.value = value;
								} else if(key == 'CMMN_DETAIL_CD_NM'){
									option.text = value;
								} else {
									option[key] = value;
								}
							}else{
								if(key == 'CMMN_DETAIL_CD'){
									option.value = value;
								} else if(key == 'CMMN_DETAIL_NM'){
									option.text = value;
								} else {
									option[key] = value;
								}
							}
						}   
						optionArray.push(option);
					}
					dhtmlXComboObject.addOption(optionArray);
					
					if(optionArray.length > 1){
						$erp.setMultiCheckComboValue(dhtmlXComboObject, defaultValue);
					}else if(optionArray.length == 1){
						if(defaultValue == undefined || defaultValue == null || defaultValue === false){
							dhtmlXComboObject.setChecked(0,false);
						}else{
							dhtmlXComboObject.setChecked(0,true);
						}
						dhtmlXComboObject.callEvent("onClose",[]);
					}
					
					if(callbackFunction && typeof callbackFunction === 'function'){
						callbackFunction.apply(dhtmlXComboObject, []);
					}
					
					$erp.asyncObjAddEnd(dhtmlXComboObject.DOMParent);
					
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
}

/* ERP Common Script 사용을 위한 전역 변수에 Object 할당 */
var $erp = new ERPCommonScriptFunction();

    


