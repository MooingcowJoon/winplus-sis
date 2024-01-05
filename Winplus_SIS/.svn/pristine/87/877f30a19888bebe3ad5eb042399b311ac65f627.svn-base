package com.samyang.winplus.sis.basic.controller;

import java.sql.SQLException;
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

import com.samyang.winplus.sis.basic.service.CustmrSearchService;
import com.samyang.winplus.sis.basic.service.CustomerAcntManagementService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;



@RequestMapping("/sis/basic")
@RestController
public class CustomerAcntManagementController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	CustmrSearchService custmrSearchService;
	
	@Autowired
	CustomerAcntManagementService customerAcntManagementService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/basic"; // JSP경로


	/**
	  * custmrSearch - 직영점별 납품업체관리의 거래처관리 조회
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="CustomerAcntManagement.sis", method=RequestMethod.POST)
	public ModelAndView purChaseSearch(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ CustomerAcntManagementController.java  CustomerAcntManagement.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "customerAcntManagement");
		return mav;
	}
	
	/**
	  * getSearchCustomerAcntApprList -  등록된 계좌번호 및 승인내역조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchCustomerAcntApprList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchCustomerAcntApprList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ CustomerAcntManagementController.java  getSearchCustomerAcntApprList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		String PARAM_CUSTMR_CD = request.getParameter("PARAM_CUSTMR_CD");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_CUSTMR_CD", PARAM_CUSTMR_CD);
		
		List<Map<String, Object>> customList = customerAcntManagementService.getSearchCustomerAcntApprList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}	
	
	/**
	  * CustomerAcntManagementCUD - 거래처별계좌 및 승인정보 Insert, Update, Delete
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="CustomerAcntManagementCUD.do", method=RequestMethod.POST)
	public Map<String, Object> CustomerAcntManagementCUD(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		
		int resultRowCnt = customerAcntManagementService.saveStdCustomrAcntScreenList(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}	
	
}
