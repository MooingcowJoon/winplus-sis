package com.samyang.winplus.mq.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeoutException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.samyang.winplus.mq.dao.RabbitMqDao;


/** 
 * rabbitmq service 구현체
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
public class RabbitMqServiceImpl implements RabbitMqService {
	
	private static final String EXCHANGE_NAME = "CHUNHO";
	private static final int SECOND_UNIT = 1000;
	private static final int SECOND = 60;
	private static final int MINUTE = 60;
	private static final int HOUR = 12;
	private static final int X_EXPIRES_TIME = SECOND_UNIT*SECOND*MINUTE*HOUR;
	private static final Logger logger = LoggerFactory.getLogger(RabbitMqService.class);
	
	@Autowired
	private RabbitMqDao rabbitMqDao;
	
	private ConnectionFactory factory;
	
	public RabbitMqServiceImpl(){
		check_keys = new HashMap<String,Object>();
		//메세지 타입의 어떤 파라미터가 비어있는지 확인 용도
		String [] queue_check = {"emp_ph_num"}; // 2
		String [] login = {"emp_id","emp_ph_num"}; // 2
		String [] state = {"call_state","emp_ph_num"}; // 2
		String [] call_send = {"emp_id","emp_ph_num","cus_id","cus_ph_num","cus_name","client_seq"}; // 6
		String [] call_end = {"emp_id","emp_ph_num","cus_id","cus_ph_num","cus_name","call_type","start_time","end_time","duration","file_name","client_seq"}; // 11
		String [] sms = {"emp_id","emp_ph_num","cus_id","number_count","send_to","msg_length","msg"}; // 7
		check_keys.put("queue_check", queue_check);
		check_keys.put("login", login);
		check_keys.put("state", state);
		check_keys.put("call_send", call_send);
		check_keys.put("call_end", call_end);
		check_keys.put("sms", sms);
		
		//default port : 5672
		factory = new ConnectionFactory();
		factory.setUsername("chunhoMQ");
		factory.setPassword("qwer1234!@#$");
		factory.setHost("210.223.33.37");
		factory.setVirtualHost("/");
	}

	@Override
	public String sendMessageToQueueService(Map<String,Object> send_data) throws SQLException, Exception{
		
		Connection connection = null;
		Channel channel = null;
		try {
			final String messageType = (String) send_data.get("messageType");
			
			if(messageType == null){
				return "messageType null or invalid";
			}

			String paramCheckMessage = "";
			paramCheckMessage = paramsNullCheck(send_data, messageType);
			if(!paramCheckMessage.equals("")){
				return paramCheckMessage;
			}
			
			final String QUEUE_NAME = (String) send_data.get("emp_ph_num");
			
			String message = "";
			int db_use_result = 0;
			
			
			if(messageType.equals("queue_check")){
					
					
			}else if(messageType.equals("login")){
				
				
			}else if(messageType.equals("state")){
				message = (String) send_data.get("call_state");
				
			}else if(messageType.equals("call_send")){

				
			}else if(messageType.equals("call_end")){
				db_use_result = rabbitMqDao.updateCallInf(send_data);
				message = db_use_result == 1 ? "success" : "fail";
			}else if(messageType.equals("sms")){
				
				
			}else{
				message = "messageType error";
			}
			
			if(!messageType.equals("queue_check") && db_use_result == 1){
				return message;
			}

			
			if(QUEUE_NAME == null || QUEUE_NAME.equals("")){
				return "emp_ph_num not exist or value : '' ";
			}
			
			//logger.debug("QUEUE_NAME : " + QUEUE_NAME +" MESSAGE : " + message);
			
			connection = factory.newConnection();
			channel = connection.createChannel();
			
			Map<String, Object> args = new HashMap<String, Object>();
			args.put("x-expires", X_EXPIRES_TIME);
			
			channel.queueDeclare(QUEUE_NAME, true, false, true, args);
			
			channel.exchangeDeclare(EXCHANGE_NAME, "direct", true);
			
			channel.queueBind(QUEUE_NAME, EXCHANGE_NAME, QUEUE_NAME);
			
			
			if(!messageType.equals("queue_check")){
				channel.basicPublish(EXCHANGE_NAME, QUEUE_NAME, null, message.getBytes("UTF-8"));
				message = "send message success";
			}else {
				message = "create success";
			}
			//channel.close();
			connection.close();
			return message;

		} catch (IOException | TimeoutException e) {
			logger.error("rabbitmq service 예외 발생 : " + e.toString());
		} catch (SQLException e){
			logger.error("모바일 녹취 업데이트 쿼리 실행 실패  : " + e.toString());
		}
		
		return "fail";
	}
	
	
	static private Map<String,Object> check_keys;
	
	private String paramsNullCheck(Map<String,Object> senddata, String messageType){
		String keys [] = (String []) check_keys.get(messageType);	
		//logger.debug("messageType : " + messageType);
		String paramCheckMessage = "";
		boolean valid = true;
		for (String key : keys){
			String value = (String) senddata.get(key);
			if(value == null){
				paramCheckMessage += key + " : null \n";
				valid = false;
			}else{
				paramCheckMessage += key + " : " + value + "\n";
			}
		}
		senddata.put("q", "?"); // 마이바티스에서 물음표를 스트링으로 사용하기위해서
		if(valid == true){
			logger.info("CALL_END_KLCNS_RETURN_PARAM_VALID : \n" + paramCheckMessage);
			return "";
		}else{
			logger.error("CALL_END_KLCNS_RETURN_PARAM_INVALID : \n" + paramCheckMessage);
			return paramCheckMessage;
		}
	}
	
}
