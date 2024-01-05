package com.samyang.winplus.common.system.base.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.ExceptionHandler;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.samyang.winplus.common.system.config.EnvironmentInitializer;
import com.samyang.winplus.common.system.property.PropertyManagement;
import com.samyang.winplus.common.system.util.CommonUtil;
import com.samyang.winplus.common.system.util.LoofUtilObjectException;

/** 
 * 표준 기본 컨트롤러  
 * @since 2016.10.24
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.10.24	/ 김종훈 / 신규 생성
 *********************************************
 */  
public class BaseController {
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	protected CommonUtil commonUtil;	
	
	@Autowired
	protected MessageSource messageSource;
	
	@Autowired
	protected ServletContext servletContext;
	
	@Autowired
	protected PropertyManagement propertyManagement;
	
	private final ObjectMapper mapper = new ObjectMapper();
	
	@ExceptionHandler(Exception.class)
	public Object handleControllerException(HttpServletRequest request, Exception ex) throws SQLException, Exception{	
		logger.error("handleControllerException in...");
		String currentUri = request.getRequestURI();
        int lastDotIndex = currentUri.lastIndexOf(".");
        String uriExt = "";
        String xmlHttpRequest = "";
        if (lastDotIndex > 0){
        	uriExt = currentUri.substring(lastDotIndex);
        }
    	xmlHttpRequest = request.getHeader("x-requested-with");
    	
    	boolean isAjax = false;
        if(".do".equals(uriExt) || (xmlHttpRequest != null && xmlHttpRequest.equals("XMLHttpRequest"))){
        	isAjax = true;
        }
        
        //로컬 개발시에만 예외 발생 지역 포인트를 좀더 정확하기 알기위해서
        if(EnvironmentInitializer.getServerType().equals("LOCAL")) { 
        	ex.printStackTrace();
        }
        
        logger.error(ex.toString());
        commonUtil.insertErrorLog(request, ex.toString());
		if(isAjax){
			return commonUtil.getErrorMap(ex);
		} else {
			throw ex;
		}
		
	}
	
	
	/**
	 * @author 조승현
	 * @param c
	 * @return
	 * @description 패키지 명으로 디폴트 패스생성 리턴
	 * 				##### java 소스와 web 소스 트리 구조가 같아야함 #####
	 */
	public String getDefaultPath(Class c){
		String classPackageName = c.getPackage().getName();
		String rootPackageName = "com.samyang.winplus.";
		
		String result = "";
		result = classPackageName.replace(rootPackageName, "");
		result = result.replace("controller", "");
		result = result.replace(".", "/");
		
		return result;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param ex
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description loofUtilObject를 사용하여 DB 저장중 예외 발생했을경우에만 작동함
	 */
	@ExceptionHandler(LoofUtilObjectException.class)
	public Object LoofUtilObjectExceptionHandler(HttpServletRequest request, Exception ex) throws SQLException, Exception{	
		logger.error("LoofUtilObjectExceptionHandler in...");
		String currentUri = request.getRequestURI();
        int lastDotIndex = currentUri.lastIndexOf(".");
        String uriExt = "";
        String xmlHttpRequest = "";
        if (lastDotIndex > 0){
        	uriExt = currentUri.substring(lastDotIndex);
        }
    	xmlHttpRequest = request.getHeader("x-requested-with");
    	
    	boolean isAjax = false;
        if(".do".equals(uriExt) || (xmlHttpRequest != null && xmlHttpRequest.equals("XMLHttpRequest"))){
        	isAjax = true;
        }
        
        //로컬 개발시에만 예외 발생 지역 포인트를 좀더 정확하기 알기위해서
        if(EnvironmentInitializer.getServerType().equals("LOCAL")) { 
        	ex.printStackTrace();
        }
        
        logger.error(ex.toString());
        commonUtil.insertErrorLog(request, ex.toString());
        
        Map<String,Object> errorMap = new HashMap<String,Object>();
        errorMap.put("isErrorExist", 1);
        String message = ex.getMessage();
        if(message.length() > 2000) {
        	message = message.substring(0,2000) + "...";
        }
        errorMap.put("errorMessage", message);
		return errorMap;
	}
	
	public String writeValueAsString(Map<String,Object> map) {
		String result = "";
		try {
			result = mapper.writeValueAsString(map);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		return result;
	}
}
