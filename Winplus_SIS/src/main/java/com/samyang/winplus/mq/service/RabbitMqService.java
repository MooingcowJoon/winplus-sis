package com.samyang.winplus.mq.service;

import java.util.Map;

import org.springframework.stereotype.Service;



/** 
 * rabbitmq service
 * @since 2018.06.30
 * @author 조승현
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2018.06.30 / 조승현 / 신규 생성
 *********************************************
 */  
@Service("rabbitMqService")
public interface RabbitMqService{

	
	/**
	  * sendMessageToQueueService - 큐에 메세지 삽입
	  * @author 조승현
	  * @param senddata
	  * @return String
	  * @exception Exception
	  */
	public String sendMessageToQueueService(Map<String,Object> senddata)throws Exception ;
}

