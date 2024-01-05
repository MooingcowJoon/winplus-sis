package com.samyang.winplus.mq.controller;

import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.mq.service.RabbitMqService;;


/** 
 * rabbitmq controller
 * @since 2018.06.30
 * @author 조승현
 * 
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2018.06.30 / 조승현 / 신규 생성
 * 
 *********************************************
 */

@RestController
@RequestMapping("/mq") 
public class RabbitMqController {
	
	private static final Logger logger = LoggerFactory.getLogger(RabbitMqController.class);
	
	@Autowired
	RabbitMqService rabbitMqService;
	
	//샘플 전화 페이지
	@RequestMapping(value="testRabbitCall.sis", method=RequestMethod.POST )
	public ModelAndView testRabbitCall(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		//logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> testRabbitCall.jsp 호출");
		mav.setViewName("common/popup/testRabbitCall");
		return mav;
	}

	//큐에 메시지 보내기 post
	@RequestMapping(value = "sendMessage.do", method=RequestMethod.POST)
	@ResponseBody
	public String sendMessageToQueue(Locale locale, @RequestBody Map<String,Object> senddata) throws Exception {
		//logger.debug("rabbitmq message 전송 시작 POST");
		return rabbitMqService.sendMessageToQueueService(senddata);
	}
	
}
