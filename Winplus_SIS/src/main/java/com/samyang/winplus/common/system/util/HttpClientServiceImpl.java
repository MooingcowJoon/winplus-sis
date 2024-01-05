package com.samyang.winplus.common.system.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpHeaders;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.springframework.stereotype.Service;

/** 
 * HttpClientService 구현체
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
public class HttpClientServiceImpl implements HttpClientService {

	/**
	  * requestHttp - HTTP 요청
	  * @author 김종훈
	  * @param uri
	  * @param method
	  * @param paramMap
	  * @return String
	  * @exception Exception
	  */
	@Override
	public String requestHttp(String uri, String method, Map<String, Object> paramMap) throws Exception {
		return requestHttp(uri, method, "UTF-8", paramMap);
	}
	
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
	@Override
	public String requestHttp(String uri, String method, String charset, Map<String, Object> paramMap) throws Exception {
		String responseString = null;
		String uriStr = uri;
		CloseableHttpClient httpclient = HttpClients.createDefault();
		try{
			HttpUriRequest httpUriRequest = null;
			List<NameValuePair> params = new ArrayList<NameValuePair>();
			if(paramMap != null){
				for(String key : paramMap.keySet()){
					Object value = paramMap.get(key);
					if(value instanceof Map){
						continue;
					} else if(value instanceof Object[]) {
						for(Object val : (Object[])value){
							params.add(getNewBasicNameValuePair(key + "[]", val.toString()));
						}
					} else {
						params.add(getNewBasicNameValuePair(key, value.toString()));
					}
				}
			}
			if(method != null && method.equalsIgnoreCase("POST")){
				httpUriRequest = new HttpPost(uri);
				((HttpPost)httpUriRequest).setEntity(new UrlEncodedFormEntity(params));
			} else {
				if(!params.isEmpty()){
					uriStr = uri + "?" + URLEncodedUtils.format(params, charset);
//					uri = uri + "?" + URLEncodedUtils.format(params, charset);
				}
				httpUriRequest = new HttpGet(uriStr);
			}
			httpUriRequest.setHeader(HttpHeaders.CONTENT_TYPE, "text/plain;charset=" + charset);
		    CloseableHttpResponse response = httpclient.execute(httpUriRequest);
		    try{
		    	responseString = EntityUtils.toString(response.getEntity(), charset);
		    }  catch(Exception ex){
		    	throw ex;
		    } finally{		    
		    	response.close();
		    }
		} catch(Exception ex){
			throw ex;
		} finally{
			httpclient.close();
		}
	    
		return responseString;
	}
	
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
	@Override
	public String requestHttpJson(String uri, String method, String charset, String param) throws Exception {
		String responseString = null;
		String uriStr = uri;
		
		CloseableHttpClient httpclient = HttpClients.createDefault();
		try{
			HttpUriRequest httpUriRequest = null;
			
			StringEntity input = new StringEntity(param);
	        input.setContentType("application/json;charset=UTF-8");

			if(method != null && method.equalsIgnoreCase("POST")){
				httpUriRequest = new HttpPost(uriStr);
				((HttpPost)httpUriRequest).setEntity(input);
			}
			//httpUriRequest.setHeader(HttpHeaders.CONTENT_TYPE, "text/plain;charset=" + charset);
		    CloseableHttpResponse response = httpclient.execute(httpUriRequest);
		    try{
		    	responseString = EntityUtils.toString(response.getEntity(), charset);
		    }  catch(Exception ex){
		    	throw ex;
		    } finally{		    
		    	response.close();
		    }
		} catch(Exception ex){
			throw ex;
		} finally{
			httpclient.close();
		}
	    
		return responseString;
	}
	
	
	
	
	public BasicNameValuePair getNewBasicNameValuePair(String key, String valueStr){
		return new BasicNameValuePair(key, valueStr);
	}

		
}
