package com.samyang.winplus.common.system.property;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import com.samyang.winplus.common.system.security.util.KisaSeedCBCHandler;

/** 
 * Property 서비스 (구현체)
 * @since 2016.11.07
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.11.07 / 김종훈 / 신규 생성
 *********************************************
 */
public class PropertyManagementImpl implements PropertyManagement{
		
	private Map<String, String> properties;
	
	@Autowired
	public KisaSeedCBCHandler kisaSeedCBCHandler;
	
	/**
	  * Property 저장
	  * @author 김종훈
	  * @param properties
	  * @return void
	  */
	@Override
	public void setProperties(Map<String, String> properties){
		this.properties = properties;
		//Decode
		for(String key : this.properties.keySet()){
			if(this.getProperty(key).indexOf("ENC[") > -1){
				String value = this.getProperty(key);
				int start = value.indexOf("[");
				int end = value.indexOf("]");
				value = value.substring(start, end);
				String decValue = kisaSeedCBCHandler.decrypt(value);
				this.properties.put(key, decValue);
			}
		}
	}
	
	/**
	  * Property 조회
	  * @author 김종훈
	  * @param key
	  * @return String
	  */
	@Override
	public String getProperty(String key){
		return this.properties.get(key);
	}
	
}
