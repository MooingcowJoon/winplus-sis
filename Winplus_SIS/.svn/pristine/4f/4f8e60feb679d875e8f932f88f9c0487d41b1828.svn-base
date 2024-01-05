package com.samyang.winplus.common.system.message.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.NoSuchMessageException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.samyang.winplus.common.system.base.controller.BaseController;


/** 
 * 공통 컨트롤러  
 * @since 2016.10.24
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.10.24	/ 김종훈 / 신규 생성
 *********************************************
 */
@RestController
@RequestMapping("/common/system/message")
public class MessageController extends BaseController {
	static Logger logger = LoggerFactory.getLogger(MessageController.class);
	
	/**
	  * getCommonMessage - 공통 메시지 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="/getCommonMessage.do", method=RequestMethod.POST)
	public Map<String, Object> getCommonMessage(HttpServletRequest request) throws SQLException, Exception{
		//logger.debug("BaseController getCommonMessage.erp start...");
		Map <String, Object> resultMap = new HashMap<String, Object>();
		String messageCode = request.getParameter("alertCode");
		String messageType = request.getParameter("alertType");
		String message = request.getParameter("alertMessage");
		String[] messageParam = request.getParameterValues("alertMessageParam");

		String resultMessage = "";
		
		String errMessage = "";
		String errCode = "";
		
		if(messageType == null || messageType.length() == 0){
			messageType = "error";
		}
		String resultMessageType = "";
		try {
			resultMessageType = messageSource.getMessage("word.common." + messageType, new Object[1], commonUtil.getDefaultLocale());
		} catch (NoSuchMessageException ne){
			resultMessageType = "error";
		}
		String resultMessageCode = messageCode;
					
		String resultMessageOk = "OK";
		try {
			resultMessageOk = messageSource.getMessage("word.common.ok", new Object[1], commonUtil.getDefaultLocale());
		} catch (NoSuchMessageException ne){
			resultMessageOk = "OK";
		}			
		String resultMessageCancel = "Cancel";
		try {
			resultMessageCancel = messageSource.getMessage("word.common.cancel", new Object[1], commonUtil.getDefaultLocale());
		} catch (NoSuchMessageException ne){
			resultMessageCancel = "Cancel";
		}
		
		if(message != null && message.length() > 0){
			resultMessage = "";
			try {
				if(messageParam == null){
					messageParam = new String[0];
				}
				resultMessage = messageSource.getMessage(message, messageParam, commonUtil.getDefaultLocale());
			} catch (NoSuchMessageException ne){
				resultMessage = message;
			}
//			if(messageCode != null && messageCode.length() > 0){
//				String resultMessageAdd = resultMessage + "<br/>[ 오류코드 : " + messageCode + " ]";
//				resultMessage = resultMessageAdd;
//			}
			resultMap.put("resultMessage", resultMessage);
			resultMap.put("resultMessageType", resultMessageType);
			resultMap.put("resultMessageCode", resultMessageCode);
			resultMap.put("resultMessageOk", resultMessageOk);
			resultMap.put("resultMessageCancel", resultMessageCancel);
		} else {
			errMessage = "";
			errCode = "noMessage";				
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		}
		//logger.debug("resultMessage : " + resultMessage);
		//logger.debug("resultMessageType : " + resultMessageType);
		//logger.debug("resultMessageCode : " + resultMessageCode);
		//logger.debug("resultMessageCancel : " + resultMessageCancel);
		//logger.debug("BaseController getCommonMessage.erp end...");
		
		return resultMap;
	}
	
}
