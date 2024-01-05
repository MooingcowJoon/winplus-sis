package com.samyang.winplus.sis.standardInfo.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.samyang.winplus.common.system.util.CommonUtil;
import com.samyang.winplus.sis.standardInfo.service.CorpInformationService;

@RequestMapping("/sis/standardInfo/corp")
@RestController
public class CorpManagementController {
	
	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	protected CommonUtil commonUtil;
	
	@Autowired
	CorpInformationService corpInformationService;
	
	@SuppressWarnings("unused")
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/standardInfo/corp";
	
	/**
	  * getCorpInformationFromKeyword - 가격변경예약(직영점) - 키워드로 거래처정보 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getCorpInformationFromKeyword.do", method=RequestMethod.POST)
	public Map<String, Object> getCorpInformationFromKeyword(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try{
			resultMap = corpInformationService.getCorpInformationFromKeyword(paramMap);
			if(resultMap == null){
				resultMap = new HashMap<String, Object>();
				resultMap.put("CUSTMR_CD", "조회정보없음");
				resultMap.put("CUSTMR_NM", "조회정보없음");
			}
		} catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
}