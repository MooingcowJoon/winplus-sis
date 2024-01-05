package com.samyang.winplus.common.system.util;

import java.util.Map;

import org.springframework.stereotype.Service;

/** 
 * HttpClientService
 * @since 2017.06.20
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2017.06.20	/ 김종훈 / 신규 생성
 *********************************************
 */
@Service("httpClientService")
public interface HttpClientService {

	/**
	  * requestHttp - HTTP 요청
	  * @author 김종훈
	  * @param uri
	  * @param method
	  * @param paramMap
	  * @return String
	  * @exception Exception
	  */
	public String requestHttp(String uri, String method, Map<String, Object> paramMap) throws Exception;
	
	/**
	  * requestHttp - HTTP 요청
	  * @author 김종훈
	  * @param uri
	  * @param method
	  * @param charset
	  * @param paramMap
	  * @return String
	  * @exception Exception
	  */
	public String requestHttp(String uri, String method, String charset, Map<String, Object> paramMap) throws Exception;
	
	/**
	  * requestHttp - HTTP 요청
	  * @author 김종훈
	  * @param uri
	  * @param method
	  * @param charset
	  * @param paramMap
	  * @return String
	  * @exception Exception
	  */
	public String requestHttpJson(String uri, String method, String charset, String param) throws Exception;
}
