package com.samyang.winplus.sis.basic.controller;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.sis.basic.service.CustomerIOService;

import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;

@RequestMapping("/sis/basic")
@RestController
public class CustomerInputController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	CustomerIOService customerIOService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/basic"; // JSP경로


	/**
	  * custmrSearch - 거래처등록
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="customerInput.sis", method=RequestMethod.POST)
	public ModelAndView purChaseSearch(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ CustomerInputController.java  customerInput.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "customerInput");
		return mav;
	}
	


	/**
	  * insertCustomer - 거래처 CUD
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="insertCustomer.do", method=RequestMethod.POST)
	public Map<String, Object> insertCustomer(HttpServletRequest request, @RequestParam Map<String, Object> p) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap  = commonUtil.getParamValueMap(request);
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String empNo = empSessionDto.getEmp_no();
		
		
		String crud   = paramMap.get("CRUD").toString();
		String orgnNm = paramMap.get("CUSTMR_NM").toString();
		
		String regReqId = empNo;
		
		if(crud == null || crud.equals("")){				
			String errMesage = messageSource.getMessage("error.common.noChanged", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			if("C".equals(crud) || "U".equals(crud)){
				if(orgnNm == null || "".equals(orgnNm)){
					String errMesage = messageSource.getMessage("error.common.system.master.category.stndCtgrNm.noData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1002";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			}
		}

	    /* 신규이면  insert else update */
		if("C".equals(crud)){
			paramMap.put("CPROGRM"    , "CustomerInputController");
			paramMap.put("CUSER"      , regReqId);
			resultMap.put("dataMap", customerIOService.insertCustomer(paramMap));
		}
		else
		{
			paramMap.put("MPROGRM"    , "CustomerInputController");
			paramMap.put("MUSER"      , regReqId);
			resultMap.put("dataMap", customerIOService.updateCustomer(paramMap));
		}
				
		return resultMap;
	}
	
	
	/**
	  * getOrgn - 거래처 조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getCustomer.do", method=RequestMethod.POST)
	public Map<String, Object> getCustomer(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String ctgrCd = request.getParameter("CUSTMR_CD");
		if(ctgrCd == null || ctgrCd.length() == 0){
			String errMesage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("CUSTMR_CD", ctgrCd);
			Map<String, Object> mtrlMap = customerIOService.getCustomer(paramMap);
			resultMap.put("dataMap", mtrlMap);
			
		}
		return resultMap;
	}	
	
	/**
	  * getCorpNoCount - 동일한사업자번호가 존재하는지 체크한다.
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getCorpNoCount.do", method=RequestMethod.POST)
	public Map<String, Object> getCorpNoCount(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap2 = new HashMap<String, Object>();
		String PARAM_CORP_NO   = request.getParameter("CORP_NO");
		String PARAM_CUSTMR_CD = request.getParameter("CUSTMR_CD");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("CORP_NO",   PARAM_CORP_NO);
		paramMap.put("CUSTMR_CD", PARAM_CUSTMR_CD);
		
		int resultRowCnt = customerIOService.getCorpNoCount(paramMap);
		logger.info("@@@@@@@@@@ CustomerInputController.java resultRowCnt  ============" + resultRowCnt);
		resultMap2.put("resultRowCnt", resultRowCnt);

		return resultMap2;
	}
	

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @description 거래처의 파일 그룹 번호 업데이트
	 */
	@ResponseBody
	@RequestMapping(value="updateCustomerFileGrupNo.do", method=RequestMethod.POST)
	public Map<String, Object> updateCustomerFileGrupNo(@RequestBody Map<String, String> paramMap){
		Map<String, Object> resultMap = new HashMap<String,Object>();
		customerIOService.updateCustomerFileGrupNo(paramMap);
		return resultMap;
	}
	
	/**
	 * 거래처정보 - 계좌정보 수정
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="saveAcntInfo.do", method=RequestMethod.POST)
	public Map<String, Object> saveAcntInfo(HttpServletRequest request, @RequestBody Map<String,Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String MUSER = empSessionDto.getEmp_no();
		String MPROGRM = "saveAcntInfo";
		paramMap.put("MPROGRM", MPROGRM);
		paramMap.put("MUSER", MUSER);
		
		int resultRowCnt = customerIOService.saveAcntInfo(paramMap);
		
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
}
