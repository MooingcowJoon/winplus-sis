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
import com.samyang.winplus.sis.basic.service.MkCustomerMangementService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;



@RequestMapping("/sis/basic")
@RestController
public class mkCustomerManagementController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	CustmrSearchService custmrSearchService;
	
	@Autowired
	MkCustomerMangementService mkCustomerMangementService;
	
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
	@RequestMapping(value="mkCustomerManagement.sis", method=RequestMethod.POST)
	public ModelAndView purChaseSearch(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ CustmrSearchController.java  custmrSearch.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "mkCustomerManagement");
		return mav;
	}
	
	/**
	  * custmrSearchR1 - 대상거래처 납품업체등록건의 조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="custmrSearchR1Mk.do", method=RequestMethod.POST)
	public Map<String, Object> menuManagementR1Mk(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ mkCustomerManagementController.java  custmrSearchR1Mk.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_ORGN_DIV_CD  = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD      = request.getParameter("PARAM_ORGN_CD");
     
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORGN_DIV_CD",    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD",        PARAM_ORGN_CD);
		
		List<Map<String, Object>> customList = mkCustomerMangementService.getSearchCustmrListMk(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}

	/**
	  * CustomerManagementCUD - 대상거래처 납품업체 C,U,D
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="CustomerManagementCUD.do", method=RequestMethod.POST)
	public Map<String, Object> CustomerManagementCUD(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		
		int resultRowCnt = mkCustomerMangementService.saveCustomerMkScreenList(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}

	/**
	  * 사업장별협력사관리
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="customerManagementByWorkplace.sis", method=RequestMethod.POST)
	public ModelAndView customerManagementByWorkplace(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "customerManagementByWorkplace");
		return mav;
	}
	
	/**
	  * 사업장별협력사관리 - 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getCustmrByWorkplace.do", method=RequestMethod.POST)
	public Map<String, Object> getCustmrByWorkplace(HttpServletRequest request, @RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Map<String, Object>> gridDataList = mkCustomerMangementService.getCustmrByWorkplace(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	
	/**
	  * 사업장별협력사관리 - 거래처 추가
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getCustmrInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getCustmrInfo(HttpServletRequest request) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String CUSTMR_CD = request.getParameter("CUSTMR_CD");
		paramMap.put("CUSTMR_CD", CUSTMR_CD);
		
		try {
			List<Map<String, Object>> gridDataList = mkCustomerMangementService.getCustmrInfo(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	 * 사업장별협력사관리 - 거래처 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="saveCustmrByWorkplace.do", method=RequestMethod.POST)
	public Map<String, Object> saveCustmrByWorkplace(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String CUSER = empSessionDto.getEmp_no();
		String MUSER = empSessionDto.getEmp_no();
		String CPROGRM = "saveCustmrByWorkplace";
		String MPROGRM = "saveCustmrByWorkplace";
		
		int insertResult = 0;
		int updateResult = 0;
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			paramMap = dhtmlxParamMapList.get(i);
			if(paramMap.get("CRUD").equals("C")) {
				paramMap.put("CPROGRM", CPROGRM);
				paramMap.put("CUSER", CUSER);
				
				insertResult = mkCustomerMangementService.saveAddCustmrByWorkplace(paramMap);
			}else if(paramMap.get("CRUD").equals("U")) {
				paramMap.put("MPROGRM", MPROGRM);
				paramMap.put("MUSER", MUSER);
				
				updateResult = mkCustomerMangementService.saveUpdateCustmrByWorkplace(paramMap);
			}
		}
		return resultMap;
	}
}
