package com.samyang.winplus.common.system.property;

import java.util.Map;

/** 
 * Property 서비스
 * @since 2016.11.07
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.11.07 / 김종훈 / 신규 생성
 *********************************************
 */
public interface PropertyManagement {	
	
	void setProperties(Map<String, String> properties);
	String getProperty(String key);
}
