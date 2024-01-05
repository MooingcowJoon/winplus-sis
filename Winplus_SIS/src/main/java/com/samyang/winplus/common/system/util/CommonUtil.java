package com.samyang.winplus.common.system.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.NoSuchMessageException;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

import com.samyang.winplus.common.system.error.service.ErrorService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.property.PropertyManagement;
import com.samyang.winplus.common.system.security.util.KisaSeedCBCHandler;

@Repository("commonUtil")
public class CommonUtil {
	//private final String DEFAULT_ERR_MESSAGE="시스템 처리 중 오류가 발생 하였습니다.\n시스템 관리자에게 문의 바랍니다.\n";
	//private final String DEFAULT_ERR_LINE="=============================\n";
	static Logger logger = LoggerFactory.getLogger(CommonUtil.class);
	
	private final static String DEFAULT_ERR_MESSAGE="<span class='span_exception_header'>시스템 처리 중 오류가 발생 하였습니다.<br/>시스템 관리자에게 문의 바랍니다.<br/></span>";
	private final static String DEFAULT_ERR_LINE="<hr class='hr_common_message' />";
	
	private final static Locale DEFAULT_LOCALE = Locale.KOREA;
	private final static int DEFAULT_MSSQL_DEBUG_ERROR_STRING_LENGTH_LIMIT = 250;

	/**
	 * @author bsoh
	 */
	private static final String NULL_STRING = "";
	private static final String EMPTY_STRING = "";
	private static final String ARRAY_START = "{";
	private static final String ARRAY_END = "}";
	private static final String EMPTY_ARRAY = ARRAY_START + ARRAY_END;
	private static final String ARRAY_ELEMENT_SEPARATOR = ", ";
	  
	@Autowired
	PropertyManagement propertyManagement;	
	
	@Autowired
	MessageSource messageSource;
	
	@Autowired
	ErrorService errorService;
	
	@Autowired
	KisaSeedCBCHandler kisaSeedCBCHandler;
	
	/**
	  * EmpSessionDto 조회
	  * @author 김종훈
	  * @param request
	  * @return EmpSessionDto
	  */
	public EmpSessionDto getEmpSessionDto(HttpServletRequest request){
		Object obj = request.getSession().getAttribute("empSessionDto");
		if(obj == null) { 
			return null; 
		} else {
			return (EmpSessionDto) obj;
		}
	}
	
	/**
	  * EmpSessionDto 조회
	  * @author 김종훈
	  * @param session
	  * @return EmpSessionDto
	  */
	public EmpSessionDto getEmpSessionDto(HttpSession session){
		Object obj = session.getAttribute("empSessionDto");
		if(obj == null) { 
			return null; 
		} else {
			try{
				return (EmpSessionDto) obj;
			} catch (Throwable e){
				return null;
			}
		}
	}	

	/**
	  * ErrorMap 생성 및 조회
	  * @author 김종훈
	  * @param errMessage
	  * @param errCode
	  * @return Map<String, Object>
	  */
	public Map<String, Object> getErrorMap(String errMessage, String errCode){		
		String errMessageType = "error";
		String errMessageOk = "OK";
		String errMessageCancel = "Cancel";
		try {
			errMessageType = messageSource.getMessage("word.common.error", new Object[1], DEFAULT_LOCALE);
		} catch (NoSuchMessageException ne){
			errMessageType = "error";
		}
		try {
			errMessageOk = messageSource.getMessage("word.common.ok", new Object[1], DEFAULT_LOCALE);
		} catch (NoSuchMessageException ne){
			errMessageOk = "OK";
		}			
		try {
			errMessageCancel = messageSource.getMessage("word.common.cancel", new Object[1], DEFAULT_LOCALE);
		} catch (NoSuchMessageException ne){
			errMessageCancel = "Cancel";
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("isError", true);
		resultMap.put("errorYN", "Y");
		
		StringBuilder errMessageBuilder = new StringBuilder();
		
//		if(errCode != null && !errCode.equals("000000")) { // 코드 000000 사용시 오류로 처리 하지않음
//			errMessageBuilder.append(DEFAULT_ERR_MESSAGE);		
//			if(errMessage != null && errMessage.length() > 0){
//				errMessageBuilder.append(DEFAULT_ERR_LINE);
//				errMessageBuilder.append(errMessage);
//			}
//		}else {
			if(errMessage != null && errMessage.length() > 0){
				errMessageBuilder.append(errMessage);
			}
//		}
		/*if(errCode != null &&errMessage.length() > 0){
			errMessageBuilder.append("\n");
			errMessageBuilder.append("[ 오류 코드 : " + errCode + " ]");
		}*/
		String newErrMessage = errMessageBuilder.toString();
		
		resultMap.put("errMessageOk", errMessageOk);
		resultMap.put("errMessageCancel", errMessageCancel);
		resultMap.put("errMessageType", errMessageType);
		resultMap.put("errMessage", newErrMessage);
		resultMap.put("errCode", errCode);
		
		return resultMap;
	}
	
	/**
	  * ErrorMap 생성 및 조회
	  * @author 김종훈
	  * @param throwable
	  * @return Map<String, Object>
	  */
	public Map<String, Object> getErrorMap(Throwable throwable){	
		/* MSSQL Debug Mode 가 Y, True인 경우만 SQL Exception Message를 자세하게 출력 */
		boolean isMssqlDebugMode = false;
		String mssqlDebugMode = propertyManagement.getProperty("system.debug.mssql");
		String mssqlDebugStringLengthProperty = propertyManagement.getProperty("system.debug.mssql.length");	
		int mssqlDebugStringLength = DEFAULT_MSSQL_DEBUG_ERROR_STRING_LENGTH_LIMIT;

		if(mssqlDebugMode != null && 
				(mssqlDebugMode.toUpperCase().equals("Y") || mssqlDebugMode.toUpperCase().equals("TRUE"))){
			isMssqlDebugMode = true;			
			if(isInteger(mssqlDebugStringLengthProperty)){
				try {
					mssqlDebugStringLength = Integer.parseInt(mssqlDebugStringLengthProperty);
				} catch (NumberFormatException nfe){
					mssqlDebugStringLength = DEFAULT_MSSQL_DEBUG_ERROR_STRING_LENGTH_LIMIT;
				}
			}
		}
		
		String errMessage = "";		
		if(throwable instanceof RuntimeException){
			String errFullMessage = ((RuntimeException)throwable).getMessage();
			/* org.apache.ibatis.executor.ErrorContext Class 참조 */
			
			/* Mybatis에서 MSSQL Error 발생 시 Cause: com.microsoft.sqlserver.jdbc.SQLServerException 문구가 기본 */		
			if(errFullMessage != null && errFullMessage.indexOf("Cause: com.mysql.jdbc.exceptions") > -1){
				String myBatisLineSeparator = "###";
				String[] errMessageArray = errFullMessage.split(myBatisLineSeparator);
				if(errMessageArray.length > 2){
					errMessage=errMessageArray[1];
				}		
				/* MssqlDebugMode 일경우 */
				if(isMssqlDebugMode){						
					if(errFullMessage.indexOf("Cause: com.microsoft.sqlserver.jdbc.SQLServerException") > -1){
						String errMessageAdd = errMessage + "\n\nMSSQL DEBUG FULL ERROR MESSAGE: \n";
						errMessage = errMessageAdd;
						/* 에러 메시지가 너무 길 경우 화면에서 보이지 않아 자름 */
						if(errFullMessage.length() > mssqlDebugStringLength){
							errFullMessage = errFullMessage.substring(0, mssqlDebugStringLength);
						}
						errMessageAdd = errMessage + errFullMessage;
						errMessage = errMessageAdd;
					}
					
				}				
			} else {
				errMessage = errFullMessage;
			}
		} else if(throwable instanceof CommonException){
			errMessage = ((CommonException)throwable).getMessage();
			Object[] errMessageArg = ((CommonException)throwable).getMessageArgs();
			if(errMessageArg == null){
				errMessageArg = new Object[1];
			}
			try {
				errMessage = messageSource.getMessage(errMessage, errMessageArg, this.getDefaultLocale());
			} catch (NoSuchMessageException ne){
				errMessage = ((CommonException)throwable).getMessage();
			}
		} else if(throwable instanceof Exception){
			errMessage = ((Exception)throwable).getMessage();
		} else if (throwable instanceof Error){
			errMessage = ((Error)throwable).getMessage();
		} else {
			errMessage = throwable.getMessage();
		}
		
		if(errMessage == null || errMessage.length() == 0){
			errMessage = throwable.toString();
		}
		logger.error("errMessage : "+errMessage);
		return this.getErrorMap(errMessage, null);
	}
	
	/**
	  * Session 만료 처리
	  * @author 김종훈
	  * @param request
	  * @return boolean
	  */
	public boolean execSessionInvalidate(HttpServletRequest request){
		boolean result = true;
		try {
			HttpSession session = request.getSession();
			session.invalidate();
		} catch (Exception ex){
			result = false;
		}
		return result;
	}
	
	/**
	  * File을 Binary(Byte Array)로 변환
	  * @author 김종훈
	  * @param file
	  * @return byte[]
	  */
	public byte[] getFileToByte(File file){
		byte[] returnByte = null;
		FileInputStream fis = null;
		try{
			fis = new FileInputStream(file);
			returnByte = IOUtils.toByteArray(fis);
		} catch (IOException e){
			//logger.debug(e.toString());
//			returnByte = null;
		}		
		return returnByte;
	}
	
	/**
	  * String이 Null인 경우 빈 칸, 아닌 경우 원래 값 반환
	  * @author 김종훈
	  * @param str
	  * @return String
	  */
	public String getEmptyStringFromNull(String str){
		if(str == null){
			return "";
		} else {
			return str;
		}
	}		

	/**
	  * Request Parameter를 List<Map> 형태로 반환
	  * @author 김종훈
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	public List<Map<String, Object>> getParamMapList(HttpServletRequest request) {
		List<Map<String, Object>> paramMapList = new ArrayList<Map<String,Object>>();
		List<String> paramNameList = new ArrayList<String>(); 		
		
		int paramIndexMaxSize = 0;
		Enumeration<String> paramNames = request.getParameterNames();
		while(paramNames.hasMoreElements()){
			String paramName = paramNames.nextElement();
			paramNameList.add(paramName);	
			String[] paramValues = request.getParameterValues(paramName);
			paramIndexMaxSize = paramValues.length > paramIndexMaxSize ? paramValues.length : paramIndexMaxSize;			
		}
		
		for(int i = 0; i < paramIndexMaxSize; i++){
			Map<String, Object> paramMap = getNewMap();				
			for(int j = 0; j < paramNameList.size(); j++){
				String paramKey = paramNameList.get(j);
				String[] paramValues = request.getParameterValues(paramKey);
				String paramValue = null;
				if(paramValues != null && paramValues.length > 0){
					if(paramValues.length == 1){						
						paramValue = paramValues[0];
					} else if(i < paramValues.length){
						paramValue = paramValues[i];
					}
					
					if(paramValue != null){
						paramMap.put(paramKey, paramValue);
					}
				}
			}
			paramMapList.add(paramMap);
		}		
		
		return paramMapList;
	}
	
	public Map<String, Object> getNewMap(){
		return new HashMap<String, Object>();
	}
	
	public List<String> getNewList(){
		return new ArrayList<String>();
	}
	
	/**
	  * Request Parameter를 Map<String, Object> 형태로 반환
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	public Map<String, Object> getParamValueMap(HttpServletRequest request) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Enumeration<String> paramNames = request.getParameterNames();
		while(paramNames.hasMoreElements()){
			String paramName = paramNames.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);
			//logger.debug("paramName : "+paramName+"            paramValue : "+paramValue);
		}
		return paramMap;
	}
	
	/**
	  * Request Parameter를 Map<String, Object> 형태로 반환
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	public Map<String, Object> getParamValuesMap(HttpServletRequest request) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Enumeration<String> paramNames = request.getParameterNames();
		while(paramNames.hasMoreElements()){
			String paramName = paramNames.nextElement();
			String[] paramValues = request.getParameterValues(paramName);
			if(paramValues != null && paramValues.length > 1){
				paramMap.put(paramName, paramValues);
				//logger.debug("paramName : "+paramName+"            paramValues : "+paramValues);
			} else {
				String paramValue = request.getParameter(paramName);
				paramMap.put(paramName, paramValue);
				//logger.debug("paramName : "+paramName+"            paramValue : "+paramValue);
			}
			
		}
		return paramMap;
	}
	
	/**
	  * Request Parameter를 Map<String, Object> 형태로 반환
	  * @author 주병훈
	  * @param request
	  * @return Map<String, Object>
	  */
	public Map<String, Object> getParamValuesMapNvl(HttpServletRequest request) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Enumeration<String> paramNames = request.getParameterNames();
		while(paramNames.hasMoreElements()){
			String paramName = paramNames.nextElement();
			String[] paramValues = request.getParameterValues(paramName);
			if(paramValues != null && paramValues.length > 1){
				paramMap.put(paramName, paramValues);
				//logger.debug("paramName : "+paramName+"            paramValues : "+paramValues);
			} else {
				String paramValue = nvl(request.getParameter(paramName));
				paramMap.put(paramName, paramValue);
				//logger.debug("paramName : "+paramName+"            paramValue : "+paramValue);
			}
		}
		return paramMap;
	}
	
	/**
	  * DhtmlX Request Parameter를 List<Map> 형태로 반환
	  * @author 김종훈
	  * @param request
	  * @return  List<Map<String, Object>>
	  */
	public List<Map<String, Object>> getDhtmlXParamMapList(HttpServletRequest request) {
		List<Map<String, Object>> paramMapList = new ArrayList<Map<String,Object>>();
		List<String> paramNameList = new ArrayList<String>(); 		
		
		Enumeration<String> paramNames = request.getParameterNames();
		while(paramNames.hasMoreElements()){
			String paramName = paramNames.nextElement();
			paramNameList.add(paramName);			
		}
		
		if(paramNameList.contains("CRUD")){
			String[] crud = request.getParameterValues("CRUD");
			for(int i = 0; i < crud.length; i++){
				Map<String, Object> paramMap = getNewMap();				
				for(int j = 0; j < paramNameList.size(); j++){
					String paramKey = paramNameList.get(j);
					String[] paramValues = request.getParameterValues(paramKey);
					String paramValue = null;
					if(paramValues != null && paramValues.length > 0){
						if(paramValues.length == 1){
							paramValue = paramValues[0];
						} else if(i < paramValues.length){
							paramValue = paramValues[i];
						}
						
						if(paramValue != null){
							paramMap.put(paramKey, paramValue);
						}
					}
				}
				paramMapList.add(paramMap);
			}
		}
		
		return paramMapList;
	}
	/**
	  * DhtmlX Request Parameter를 List<Map> 형태로 반환
	  * @author 신기환
	  * @param request
	  * @return  List<Map<String, Object>>
	 * @throws IOException 
	 * @throws JSONException 
	 * jsp paramData 생성 : var paramData = {"erpGrid":JSON.stringify($erp.serializeDhtmlXGridData(erpGrid)),"erpDetailGrid":JSON.stringify($erp.serializeDhtmlXGridData(erpDetailGrid))};
	 * Controller에서 분기 기준 컬럼 : GRID_GUBN
	  */
	public List<Map<String, Object>> getDhtmlXParamMapListMulti(HttpServletRequest request) throws IOException, JSONException {
		List<Map<String, Object>> paramMapList = new ArrayList<Map<String,Object>>();	
		int gubnNum=0;
		//0. 리퀘스트 파라미터 네임 추출
		Enumeration<String> paramNames = request.getParameterNames();
		while(paramNames.hasMoreElements()){
			String paramName = paramNames.nextElement();

			if(paramName!=null && !paramName.equals("")){
				try{
					JSONObject jObj = getNewJSONObject(request.getParameter(paramName));

					//JSONObject jObj = new JSONObject(paramName); 
					Iterator<String> it = jObj.keys(); //gets all the keys
					List<String> keylist = getNewList();
					int len=0;
					String value="";
					
					//1. key array 생성 & 배열갯수 파악
					while(it.hasNext()){
						String key = (String) it.next(); // get key
						 Object o = jObj.get(key); // get value
						 JSONArray jsonArray = (JSONArray)o; 
						 len = jsonArray.length();
						keylist.add(key);
					} 

					//2. 배열갯수만큼 맵생성
					for(int w=0;w<len;w++){
						Map<String, Object> paramMap = getNewMap();
						
						//2-1. 키 갯수만큼 맵에 인서트 및 value 셋팅
						for(int x=0;x<keylist.size();x++){
							value="";
							 Object o = jObj.get(keylist.get(x)); // get value
							 JSONArray jsonArray = (JSONArray)o;
							 value=jsonArray.get(w).toString();
							paramMap.put(keylist.get(x), value);	
						}
						
						//2-2. 그리드 구분키 인서트
						paramMap.put("GRID_GUBN", gubnNum);

						paramMapList.add(paramMap);
					}
					gubnNum++;
				}//try
				catch(Exception e){
					//logger.debug("[오류] "+e);}
				}
				
			}//if paramname
			
		}//while
		return paramMapList;
	}
	
	
	public List<Map<String, Object>> getDhtmlXParamMapListMultiList(HttpServletRequest request) throws IOException, JSONException {
		List<Map<String, Object>> paramMapList = new ArrayList<Map<String,Object>>();	
		int gubnNum=0;
		//0. 리퀘스트 파라미터 네임 추출
		Enumeration<String> paramNames = request.getParameterNames();
		while(paramNames.hasMoreElements()){
			String paramName = paramNames.nextElement();

			if(paramName!=null && !paramName.equals("")){
				try{
					JSONObject jObj = getNewJSONObject(request.getParameter(paramName));

					//JSONObject jObj = new JSONObject(paramName); 
					Iterator<String> it = jObj.keys(); //gets all the keys
					List<String> keylist = getNewList();
					int len=0;
					String value="";
					
					//1. key array 생성 & 배열갯수 파악
					while(it.hasNext()){
						String key = (String) it.next(); // get key
						 Object o = jObj.get(key); // get value
						 JSONArray jsonArray = (JSONArray)o; 
						 len = jsonArray.length();
						keylist.add(key);
					} 

					//2. 배열갯수만큼 맵생성
					for(int w=0;w<len;w++){
						Map<String, Object> paramMap = getNewMap();
						
						//2-1. 키 갯수만큼 맵에 인서트 및 value 셋팅
						for(int x=0;x<keylist.size();x++){
							value="";
							 Object o = jObj.get(keylist.get(x)); // get value
							 JSONArray jsonArray = (JSONArray)o;
							 value=jsonArray.get(w).toString();
							paramMap.put(keylist.get(x), value);	
						}
						
						//2-2. 그리드 구분키 인서트
						paramMap.put("GRID_GUBN", gubnNum);

						paramMapList.add(paramMap);
					}
					gubnNum++;
				}//try
				catch(Exception e){
					
				}
				
			}//if paramname
			
		}//while
		return paramMapList;
	}
	
	public JSONObject getNewJSONObject(String paramStr){
		return new JSONObject(paramStr);
	}
	
	/**
	  * String 값을 Integer로 변환 가능 여부
	  * @author 김종훈
	  * @param value
	  * @return boolean
	  */
	public boolean isInteger(String value){
		boolean result = true;
		try {
			if(value == null || value.length() == 0){
				result = false;
			} else {
				Integer.parseInt(value);
			}
		} catch (NumberFormatException ex) {
			result = false;
		} catch (Exception ex){
			result = false;
		}
		return result;
	}
	
	/**
	  * String 값을 Double로 변환 가능 여부
	  * @author 김종훈
	  * @param value
	  * @return boolean
	  */
	public boolean isDouble(String value){
		boolean result = true;
		try {
			if(value == null || value.length() == 0){
				result = false;
			} else {
				Double.parseDouble(value);
			}
		} catch (NumberFormatException ex) {
			result = false;
		} catch (Exception ex){
			result = false;
		}
		return result;
	}
	
	/**
	  *  baseStr String이 compareStrArray에 존재 여부
	  * @author 김종훈
	  * @param baseStr
	  * @param compareStrArray
	  * @return boolean
	  */
	public boolean isStringContains(String baseStr, String ... compareStrArray){
		boolean result = false;
		
		if(baseStr != null && compareStrArray != null && compareStrArray.length > 0){
			for(String str : compareStrArray){
				if(str.equals(baseStr)){
					result = true;
					break;
				}
			}
		}
		
		return result;
	}
	
	/**
	  *  날짜를 String 으로 가져오기
	  * @author 김종훈
	  * @param separateText
	  * @return String
	  */
	public String getNowDateString(String separateText){
		return getNowDateString(separateText, new Date());
	}
	
	/**
	  *  날짜를 String 으로 가져오기
	  * @author 김종훈
	  * @param separateText
	  * @param date
	  * @return String
	  */
	public String getNowDateString(String separateText, Date date){
		String localSeparateText = "";
		if(separateText != null){
			localSeparateText = separateText;
		}
		
		Date localDate = null;
		if(date != null){
			localDate = date;
		} else {
			localDate = new Date();
		}
		
		String resultStr = "";
		String format = "yyyy" + localSeparateText + "MM" + localSeparateText + "dd";
		resultStr = new SimpleDateFormat(format,Locale.KOREA).format(localDate);
		
		return resultStr;
	}
	
	/**
	  * 기본 언어 Locale로 반환
	  * @author 김종훈
	  * @return Locale
	  */
	public Locale getDefaultLocale(){
		return DEFAULT_LOCALE;
	}
	
	/**
	 * Request Parameter Values 를 통해 배열 값을 가져올 때 NullPointerException 방지 
	  * @author 김종훈
	  * @param request
	  * @param key
	  * @param index
	  * @return String
	  */
	public String getParameterValues(HttpServletRequest request, String key, int index){
		String resultString = null;
		try {
			String[] parameterValues = request.getParameterValues(key);		
			resultString = parameterValues[index];
		} catch (Exception ex){
			logger.error(ex.toString());
//			resultString = null;
		}	
		return resultString;
	}

	/**
	  * convert - MultipartFile to file
	  * @author 신기환
	  * @param MultipartFile file
	  * @param [temp] - 임시파일 // [upload] - 저장파일
	  * @throws IOException 
	  * @return File 
	  */
	public File convertFile(MultipartFile file, String gubn) throws IOException{    
		String fileName="";
		String root = propertyManagement.getProperty("system.storage.file.rootpath");
		String rootPath=root.substring(0,root.length()-1)+propertyManagement.getProperty("system.upload.uploadPath");
		String finalPath="";
		
		//1. 파일명 생성
		fileName=makeHexFileNm();
		
		
		//2. 년월일폴더 체크 및 생성
		if("temp".equals(gubn)){finalPath=gubn;}
		else{
			SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyyMMdd",Locale.KOREA);
			String stDate = formatter1.format(new Date());
			finalPath=rootPath+stDate.substring(0,4)+"/"+stDate.substring(4,6)+"/"+stDate.substring(6,8);
		}
		
//		//logger.debug(finalPath);
		File filee = new File(finalPath);
		//디렉토리가 없다면
		if(!filee.exists()){filee.mkdirs();}
//		//logger.debug(System.getProperty("user.dir"));
//		//logger.debug(filee.getAbsolutePath()+"/"+fileName);
		//3. 파일객체 생성
		//File convFile = new File(file.getOriginalFilename());
//		//logger.debug(filee.getAbsolutePath());
		File convFile = new File(filee.getAbsolutePath()+"/"+fileName);
		convFile.createNewFile(); 
	    FileOutputStream fos = new FileOutputStream(convFile); 
	    fos.write(file.getBytes());
	    fos.close();
	    return convFile;
	}
	
	/**
	  * DhtmlX Request Parameter를 List<Map> 형태로 반환
	  * @author 신기환
	  * @param request
	  * @return  List<Map<String, Object>>
	  */
	public List<Map<String, Object>> getDhtmlXParamMapListHeader(HttpServletRequest request) {
		List<Map<String, Object>> paramMapList = new ArrayList<Map<String,Object>>();
		List<String> paramNameList = new ArrayList<String>(); 		
		
		Enumeration<String> paramNames = request.getParameterNames();
		while(paramNames.hasMoreElements()){
			String paramName = paramNames.nextElement();
			paramNameList.add(paramName);		
			////logger.debug("====================++"+paramName);
			////logger.debug("====================++"+request.getParameterValues(paramName));
			
			Map<String, Object> paramMap = getNewMap();	
			if("ID".equals(paramName)||"HIDDEN".equals(paramName)||"TYPE".equals(paramName)||"ESSEN".equals(paramName)||"LABEL".equals(paramName)){
				String[] tmpArr =  request.getParameterValues(paramName);
				for(int i=0;i<tmpArr.length;i++){
					paramMap.put(paramName, tmpArr[i].equals("")||tmpArr[i]==null?"":tmpArr[i]);
				}
				paramMapList.add(paramMap);
			}
		}
		return paramMapList;
	}
	
	/**
	  * getListMapfromString를 List<Map> 형태로 반환
	  * @author 신기환
	  * @param request
	  * @return  List<Map<String, Object>>
	  */
	public List<Map<String, Object>> getListMapfromString(String str) {
		List<Map<String, Object>> paramMapList = new ArrayList<Map<String,Object>>(); 		
		Map<String, Object> paramMap = new HashMap<String, Object>();	
		
		String temp=str;
		String[] tmpArr=temp.split("\\{");
		String[] arrId=tmpArr[1].substring(0, tmpArr[1].length()-3).split(",");
		String[] arrHidden=tmpArr[2].substring(0, tmpArr[2].length()-3).split(",");
		String[] arrType=tmpArr[3].substring(0, tmpArr[3].length()-3).split(",");
		String[] arrEssen=tmpArr[4].substring(0, tmpArr[4].length()-3).split(",");
		String[] arrLabel=tmpArr[5].substring(0, tmpArr[5].length()-3).split(",");

		paramMap.put("ID", arrId);
		paramMap.put("HIDDEN", arrHidden);
		paramMap.put("TYPE", arrType);
		paramMap.put("ESSEN", arrEssen);
		paramMap.put("LABEL", arrLabel);
			
		paramMapList.add(paramMap);
		return paramMapList;
	} 
	

	/**
	  * deleteDirectory
	  * @author 신기환
	  * @param path
	  * @return  boolean
	  */
	public boolean deleteDirectory(File path) {
		if(!path.exists()) { return false; } 
		File[] files = path.listFiles(); 
		for (File file : files) { 
			if (file.isDirectory()) { 
				deleteDirectory(file); 
			} 
			else { 
				file.delete(); 
			} 
		} 
		return path.delete(); 
	}

	/**
	  * makeFile - 일반 파일생성 및 저장
	  * @author 신기환
	  * @param [bodyTxt] - 전문 원본 // [gubn] - CMS - CMS파일생성  / - ACUONE - 애큐온파일생성 /	
	  * @throws IOException 
	  * @return File 
	  */
	public File makeFile(String bodyTxt, String gubn) throws IOException{    
		String fileName="";
		String rootPath="";
		String finalPath="";
		String root =propertyManagement.getProperty("system.storage.file.rootpath");
		if("CMS".equals(gubn)){
			rootPath=root.substring(0,root.length()-1)+propertyManagement.getProperty("system.cms.file.rootpath");
		}
		else{
			rootPath=root.substring(0,root.length()-1)+propertyManagement.getProperty("system.maipList.file.rootpath");
		}

		
		//1. 파일명 생성
		fileName=makeHexFileNm();

		//2. 년월일폴더 체크 및 생성
		SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyyMMdd",Locale.KOREA);
		String stDate = formatter1.format(new Date());
		finalPath=rootPath+stDate.substring(0,4)+"/"+stDate.substring(4,6)+"/"+stDate.substring(6,8);
		
		File filee = new File(finalPath);
		//디렉토리가 없다면
		if(!filee.exists()){filee.mkdirs();}
		
		//3. 파일객체 생성
		//File convFile = new File(file.getOriginalFilename());
		File convFile = new File(filee.getAbsolutePath()+"/"+fileName);
		convFile.createNewFile(); 
	    FileOutputStream fos = new FileOutputStream(convFile); 
	    fos.write(bodyTxt.getBytes());
	    fos.close();

	    return convFile;
	}
	
	/**
	  * makeFile - 일반 파일생성 및 저장
	  * @author 신기환
	  * @param [bodyTxt] - 전문 원본 // [gubn] - CMS - CMS파일생성  / - ACUONE - 애큐온파일생성 /	
	  * @throws IOException 
	  * @return File 
	  */
	public File makeFile(byte[] bodyTxt, String gubn) throws IOException{    
		String fileName="";
		String rootPath="";
		String finalPath="";
		String root =propertyManagement.getProperty("system.storage.file.rootpath");
		if("CMS".equals(gubn)){
			rootPath=root.substring(0,root.length()-1)+propertyManagement.getProperty("system.cms.file.rootpath");
		}
		else{
			rootPath=root.substring(0,root.length()-1)+propertyManagement.getProperty("system.maipList.file.rootpath");
		}

		
		//1. 파일명 생성
		fileName=makeHexFileNm();

		//2. 년월일폴더 체크 및 생성
		SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyyMMdd",Locale.KOREA);
		String stDate = formatter1.format(new Date());
		finalPath=rootPath+stDate.substring(0,4)+"/"+stDate.substring(4,6)+"/"+stDate.substring(6,8);
		
		File filee = new File(finalPath);
		//디렉토리가 없다면
		if(!filee.exists()){filee.mkdirs();}
		
		//3. 파일객체 생성
		//File convFile = new File(file.getOriginalFilename());
		File convFile = new File(filee.getAbsolutePath()+"/"+fileName);
		convFile.createNewFile(); 
	    FileOutputStream fos = new FileOutputStream(convFile); 
	    fos.write(bodyTxt);
	    fos.close();

	    return convFile;
	}
	
	/**
	  * makeHexFileNm - 헥스파일명 생성
	  * @author 신기환
	  * @throws IOException 
	  * @return String  헥스파일명
	  */
	public String makeHexFileNm(){
		String fileName="";
		Random rd = new Random();
		int tmp=0;
		String sb = "";
		StringBuilder sb2 = new StringBuilder();
		
		for(int i=1; i<=27;i++){
			tmp=rd.nextInt(16);
			sb = Integer.toHexString(tmp);
			if(i<19 && i%6==0){
				sb2.append(sb);
				sb2.append("-");
			}
			else if(i==27) {sb2.append(sb);}
		}
		//최종파일명
		fileName=sb2.toString();
		return fileName;
	}
	
	/**
	  * moveFile - 파일이동 및 이름변경
	  * @author 신기환
	  * @param HashMap<String,Object>	
	  * @throws IOException 
	  * @return File
	  */
	public File moveFile(Map<String,Object> map) throws IOException{ 
		String fileName="";
		String rootPath="";
		String finalPath="";
		
		File Beforefile = (File)map.get("PFILE");
		rootPath= map.get("PROOT_PATH").toString(); 
	
		
		//1. 파일명 생성
		fileName=makeHexFileNm();

		//2. 년월일폴더 체크 및 생성
		SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyyMMdd",Locale.KOREA);
		String stDate = formatter1.format(new Date());
		finalPath=rootPath+stDate.substring(0,4)+"/"+stDate.substring(4,6)+"/"+stDate.substring(6,8);
	
		
		File filee = new File(finalPath);
		//디렉토리가 없다면
		if(!filee.exists()){filee.mkdirs();}
		
		//3. 새 파일객체 생성
		//File convFile = new File(file.getOriginalFilename());
		File convFile = new File(filee.getAbsolutePath()+"/"+fileName);
		convFile.createNewFile(); 
		
		//4. 파일복사
		FileInputStream inputStream = new FileInputStream(Beforefile);        
		FileOutputStream outputStream = new FileOutputStream(convFile);
		  
		FileChannel fcin =  inputStream.getChannel();
		FileChannel fcout = outputStream.getChannel();
		  
		long size = fcin.size();
		fcin.transferTo(0, size, fcout);
		  
		fcout.close();
		fcin.close();
		  
		outputStream.close();
		inputStream.close();

	    return convFile;
	}
	
	/**
	  * encryptSeed - SEED 암호화
	  * @author 김종훈
	  * @param normalString
	  * @return String
	  */
	public String encryptSeed(String normalString){
		return kisaSeedCBCHandler.encrypt(normalString);
	}
	
	/**
	  * decryptSeed - SEED 복호화
	  * @author 김종훈
	  * @param encString
	  * @return String
	  */
	public String decryptSeed(String encString){
		return kisaSeedCBCHandler.decrypt(encString);
	}
	
	/**
	  * convertNumberToMoney - 숫자를 돈 형식으로 변환
	  * @author 김종훈
	  * @param money
	  * @return String
	  */
	public String convertNumberToMoney(int number){ 
		return String.format("%,d", number);
	}
	
	/**
	  * convertNumberToHangul - 숫자를 한글로 변환
	  * @author 김종훈
	  * @param money
	  * @return String
	  */
	public String convertNumberToHangul(String money){ 
		String[] han1 = {"","일","이","삼","사","오","육","칠","팔","구"}; 
		String[] han2 = {"","십","백","천"}; 
		String[] han3 = {"","만","억","조","경"}; 
		StringBuilder result = new StringBuilder(); 
		int len = money.length(); 
		for(int i=len-1; i>=0; i--){ 
			result.append(han1[Integer.parseInt(money.substring(len-i-1, len-i))]); 
			if(Integer.parseInt(money.substring(len-i-1, len-i)) > 0) {
				result.append(han2[i%4]);
			}
			if(i%4 == 0) {
				result.append(han3[i/4]); }
			}
		return result.toString(); 
	}
	
	public static String nullSafeToString(Object[] array) {
	    if (array == null) {
	      return NULL_STRING;
	    }
	    int length = array.length;
	    if (length == 0) {
	      return EMPTY_ARRAY;
	    }
	    StringBuilder buffer = new StringBuilder();
	    for (int i = 0; i < length; i++) {
	      if (i == 0) {
	        buffer.append(ARRAY_START);
	      }
	      else {
	        buffer.append(ARRAY_ELEMENT_SEPARATOR);
	      }
	      buffer.append(String.valueOf(array[i]));
	    }
	    buffer.append(ARRAY_END);
	    return buffer.toString();
	  }
	
	 /**
	   * Return a String representation of the specified Object.
	   * <p>Builds a String representation of the contents in case of an array.
	   * Returns <code>"null"</code> if <code>obj</code> is <code>null</code>.
	   * @param obj the object to build a String representation for
	   * @return a String representation of <code>obj</code>
	   */
	  public static String nullSafeToString(Object obj) {
	    if (obj == null) {
	      return NULL_STRING;
	    }
	    if (obj instanceof String) {
	      return (String) obj;
	    }
	    if (obj instanceof Object[]) {
	      return nullSafeToString((Object[]) obj);
	    }
	    if (obj instanceof boolean[]) {
	      return nullSafeToString((boolean[]) obj);
	    }
	    if (obj instanceof byte[]) {
	      return nullSafeToString((byte[]) obj);
	    }
	    if (obj instanceof char[]) {
	      return nullSafeToString((char[]) obj);
	    }
	    if (obj instanceof double[]) {
	      return nullSafeToString((double[]) obj);
	    }
	    if (obj instanceof float[]) {
	      return nullSafeToString((float[]) obj);
	    }
	    if (obj instanceof int[]) {
	      return nullSafeToString((int[]) obj);
	    }
	    if (obj instanceof long[]) {
	      return nullSafeToString((long[]) obj);
	    }
	    if (obj instanceof short[]) {
	      return nullSafeToString((short[]) obj);
	    }
	    String str = obj.toString();
	    return (str != null ? str : EMPTY_STRING);
	  }
	  
	  public static String calTodayYYYYMMDD(){
		  StringBuilder dateToday = new StringBuilder();
		  
		  SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyyMMdd",Locale.KOREA);
		  String stDate = formatter1.format(new Date());
		  
		  dateToday.append(stDate.substring(0,4)+"-");
		  dateToday.append(stDate.substring(4,6)+"-"); 
		  dateToday.append(stDate.substring(6,8)); 
		    
		  return dateToday.toString();
	  }
	  
	  public static String calTodayYYYYMM(){
		  StringBuilder dateToday = new StringBuilder();
		  
		  SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyyMM",Locale.KOREA);
		  String stDate = formatter1.format(new Date());
		  
		  dateToday.append(stDate.substring(0,4)+"-");
		  dateToday.append(stDate.substring(4,6)); 
		    
		  return dateToday.toString();
	  }
	  
	  public static String calTodayYYYYMM(int mm){
		  StringBuilder dateToday = new StringBuilder();
		  Calendar oCalendar = Calendar.getInstance();
		  
		  oCalendar.add(Calendar.MONTH, mm);
		  
		  dateToday.append(oCalendar.get(Calendar.YEAR)+"-"+(String.format("%02d",oCalendar.get(Calendar.MONTH) + 1)));		  
		    
		  return dateToday.toString();
	  }
	  
	  public static String calTodayMM(){
		  
		  SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyyMMdd",Locale.KOREA);
		  String stDate = formatter1.format(new Date());
		  return stDate.substring(4,6);
	  }

	public int insertErrorLog(HttpServletRequest request, String errorNote) throws Exception{
		String currentUri = request.getRequestURI();

		String xmlHttpRequest = request.getHeader("x-requested-with");
		String currentMenuCd = request.getParameter("currentMenu_cd");

		EmpSessionDto empSessionDto = getEmpSessionDto(request);
		String empNo = empSessionDto.getEmp_no();
		String loginAtptIp = getClientIpAddr(request);

		String empNoOriz = empSessionDto.getEmp_no_oriz();

		String crud = request.getParameter("CRUD");

		//logger.debug("currentUri : " + currentUri);
		//logger.debug("xmlHttpRequest : " + xmlHttpRequest);
		//logger.debug("currentMenu_cd : " + currentMenuCd);
		//logger.debug("crud : " + crud);
		//logger.debug("emp_no : " + empNo);
		//logger.debug("login_atpt_ip : " + loginAtptIp);
		//logger.debug("empNoOriz : " + empNoOriz);

		Map<String, Object> logParamMap = new HashMap<String, Object>();

		String scrinPath = "";
		if (currentUri != null) {
			scrinPath = currentUri;
		}

		logParamMap.put("EMP_NO", empNo);
		logParamMap.put("CONN_MENU_CD", currentMenuCd);
		logParamMap.put("CONN_IP", loginAtptIp);
		logParamMap.put("CONN_URI", scrinPath);
		logParamMap.put("CRUD", crud);
		logParamMap.put("REQUEST_WITH", xmlHttpRequest);
		logParamMap.put("EMP_NO_ORIZ", empNoOriz);
		logParamMap.put("ERROR_NOTE", errorNote);
				
		int resultInt = errorService.insertSystemErrorLog(logParamMap);
		
		return resultInt;
	}
	
	/**
	 * Null 문자 체크
	 * 
	 * @param str
	 * @return
	 */
	public String nvl(String str) {
		return nvl(str, "");
	}

	/**
	 * Null 문자 체크
	 * 
	 * @param str
	 * @param replacer
	 * @return
	 */
	public String nvl(String str, String replacer) {
		if (str == null || "".equals(str))
			return replacer;
		else
			return str;
	}
	
	//아이피 가져오기
	public static String getClientIpAddr(HttpServletRequest request) {
	    String ip = request.getHeader("X-Forwarded-For");
	    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) ip = request.getHeader("Proxy-Client-IP");
	    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) ip = request.getHeader("WL-Proxy-Client-IP");
	    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) ip = request.getHeader("HTTP_CLIENT_IP");
	    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) ip = request.getRemoteAddr();

	    return ip;
	}
	
	public void netUseCmd(String cmd){ 
	      
		//cmd=propertyService.getProperty("system.storage.cmd.login");
		try{
			Process p = Runtime.getRuntime().exec(cmd);
		/* BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line = null;
			 
			while((line = br.readLine()) != null){
			System.out.println("netUseCmd =>" +line);*/
		}catch(Exception e){
			
		}
	 }

}
