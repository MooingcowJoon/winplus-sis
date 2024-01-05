package com.samyang.winplus.sis.partnerportal.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.sis.partnerportal.service.LoanChgHisSearchService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;

@RequestMapping("/sis/partnerportal")
@RestController
public class loanChgHisSearchController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	LoanChgHisSearchService loanChgHisSearchService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/partnerportal"; // JSP경로


	/**
	  * loanChgHisSearch - 거래처 여신변경이력 화면
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="loanChgHisSearch.sis", method=RequestMethod.POST)
	public ModelAndView getloanChgHisSearchList(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ loanChgHisSearchController.java  loloanChgHisSearchanChgHisSearch.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "loanChgHisSearch");
		return mav;
	}

	/**
	  * SaleCentSearchListPopup - 여신변경이력(납품) 상세 팝업화면
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="SaleCentSearchListPopup.sis", method=RequestMethod.POST)
	public ModelAndView SaleCentSearchList(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ loanChgHisSearchController.java  SaleCentSearchListPopup.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "SaleCentSearchListPopup");
		return mav;
	}
	
	/**
	  * getloanChgHisSearchList - 거래처 여신변경이력조회 
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getloanChgHisSearchList.do", method=RequestMethod.POST)
	public Map<String, Object> getloanChgHisSearchList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ loanChgHisSearchController.java  getloanChgHisSearchList.do ============");
 	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_OBJ_CD       = request.getParameter("PARAM_OBJ_CD");
		String PARAM_STR_YYYYMMDD = request.getParameter("PARAM_STR_YYYYMMDD");
		String PARAM_END_YYYYMMDD = request.getParameter("PARAM_END_YYYYMMDD");
		
		//logger.debug("@@@@@@@@@@ PARAM_OBJ_CD  ============" + PARAM_OBJ_CD );
		//logger.debug("@@@@@@@@@@ PARAM_STR_YYYYMMDD  ============" + PARAM_STR_YYYYMMDD );
		//logger.debug("@@@@@@@@@@ PARAM_END_YYYYMMDD  ============" + PARAM_END_YYYYMMDD );

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_OBJ_CD"      ,    PARAM_OBJ_CD);
		paramMap.put("PARAM_STR_YYYYMMDD",    PARAM_STR_YYYYMMDD);
		paramMap.put("PARAM_END_YYYYMMDD",    PARAM_END_YYYYMMDD);

		List<Map<String, Object>> customList = loanChgHisSearchService.getloanChgHisSearchList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}

	/**
	  * getSaleCentSearchList - 거래처 여신변경이력(납품)상세조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSaleCentSearchList.do", method=RequestMethod.POST)
	public Map<String, Object> getSaleCentSearchList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ loanChgHisSearchController.java  getSaleCentSearchList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_OBJ_CD   = request.getParameter("PARAM_OBJ_CD");
		String PARAM_YYYYMMDD = request.getParameter("PARAM_YYYYMMDD");
		
		//logger.debug("@@@@@@@@@@ PARAM_OBJ_CD  ============" + PARAM_OBJ_CD );
		//logger.debug("@@@@@@@@@@ PARAM_YYYYMMDD  ============" + PARAM_YYYYMMDD );

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_OBJ_CD"   ,    PARAM_OBJ_CD);
		paramMap.put("PARAM_YYYYMMDD" ,    PARAM_YYYYMMDD);

		List<Map<String, Object>> customList = loanChgHisSearchService.getSaleCentSearchList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	

	
	
}
