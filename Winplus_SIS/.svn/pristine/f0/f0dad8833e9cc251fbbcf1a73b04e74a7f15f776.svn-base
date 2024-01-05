package com.samyang.winplus.sis.basic.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.sis.basic.service.CustmrSearchService;
import com.samyang.winplus.sis.basic.service.CustomerGoodsManagementService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;



@RequestMapping("/sis/basic")
@RestController
public class CustomerGoodsManagementController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	CustmrSearchService custmrSearchService;
	
	@Autowired
	CustomerGoodsManagementService customerGoodsManagementService;
	
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
	@RequestMapping(value="CustomerGoodsManagement.sis", method=RequestMethod.POST)
	public ModelAndView purChaseSearch(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ CustomerGoodsManagementController.java  CustomerGoodsManagementController.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "customerGoodsManagement");
		return mav;
	}
	
	/**
	  * renewCustomerGoodsManagement - 전문/취급점 구매가능상품관리
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="renewCustomerGoodsManagement.sis", method=RequestMethod.POST)
	public ModelAndView renewCustomerGoodsManagement(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "renewCustomerGoodsManagement");
		return mav;
	}
	
	/**
	  * getSearchMasterBarcodeList - 대.중.소 or 상품검색입력 조건을 바코드상품목록조회 
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchMasterBarcodeList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchMasterBarcodeList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ CustomerGoodsManagementController.java  getSearchMasterBarcodeList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_GRUP_TOP_CD  = request.getParameter("PARAM_GRUP_TOP_CD");
		String PARAM_GRUP_MID_CD  = request.getParameter("PARAM_GRUP_MID_CD");
		String PARAM_GRUP_BOT_CD  = request.getParameter("PARAM_GRUP_BOT_CD");
		String PARAM_BCD_NM       = request.getParameter("PARAM_BCD_NM");
    
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_GRUP_TOP_CD",    PARAM_GRUP_TOP_CD);
		paramMap.put("PARAM_GRUP_MID_CD",    PARAM_GRUP_MID_CD);
		paramMap.put("PARAM_GRUP_BOT_CD",    PARAM_GRUP_BOT_CD);
		paramMap.put("PARAM_BCD_NM"     ,    "%"+PARAM_BCD_NM + "%");
		
		//logger.debug("@@@@@@@@@@ PARAM_GRUP_TOP_CD ============" + PARAM_GRUP_TOP_CD);
		//logger.debug("@@@@@@@@@@ PARAM_GRUP_MID_CD ============" + PARAM_GRUP_MID_CD);
		//logger.debug("@@@@@@@@@@ PARAM_GRUP_BOT_CD ============" + PARAM_GRUP_BOT_CD);
		//logger.debug("@@@@@@@@@@ PARAM_BCD_NM ============" + PARAM_BCD_NM);
		
		List<Map<String, Object>> customList = customerGoodsManagementService.getSearchMasterBarcodeList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	
	/**
	  * CustomerGoodsManagementCUD - 매출처주문가능 상품 C,U,D
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="CustomerGoodsManagementCUD.do", method=RequestMethod.POST)
	public Map<String, Object> CustomerGoodsManagementCUD(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
			//logger.debug( "dhtmlxParamMapList => " +  dhtmlxParamMap.toString()  );
		}

		
		int resultRowCnt = customerGoodsManagementService.saveStdCustomrGoodsScreenList(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
	
	/**
	  * getSearchTstdCustomerGoodsList -  등록된 주문가능상조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchTstdCustomerGoodsList.do", method=RequestMethod.POST)
	public Map<String, Object> menuManagementR1Mk(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ mkCustomerManagementController.java  custmrSearchR1Mk.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_ORGN_DIV_CD = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD     = request.getParameter("PARAM_ORGN_CD");
		String PARAM_CUSTMR_CD   = request.getParameter("PARAM_CUSTMR_CD");
		String PARAM_BCD_NM      = request.getParameter("PARAM_BCD_NM");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORGN_DIV_CD",   PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD",       PARAM_ORGN_CD);
		paramMap.put("PARAM_CUSTMR_CD",     PARAM_CUSTMR_CD);
		paramMap.put("PARAM_BCD_NM"   ,     "%"+PARAM_BCD_NM + "%");
		
		List<Map<String, Object>> customList = customerGoodsManagementService.getSearchTstdCustomerGoodsList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}	
	
	
	/**
	  * getSearchMasterBarcodePriceList - 대.중.소 or 상품검색입력 조건을 바코드상품목록조회(발주서 입력화면)
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchMasterBarcodePriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchMasterBarcodePriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ CustomerGoodsManagementController.java  getSearchMasterBarcodePriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_GRUP_TOP_CD  = request.getParameter("PARAM_GRUP_TOP_CD");
		String PARAM_GRUP_MID_CD  = request.getParameter("PARAM_GRUP_MID_CD");
		String PARAM_GRUP_BOT_CD  = request.getParameter("PARAM_GRUP_BOT_CD");
		String PARAM_BCD_NM       = request.getParameter("PARAM_BCD_NM");
		String PARAM_ORGN_DIV_CD  = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD      = request.getParameter("PARAM_ORGN_CD");
		String PARAM_CUST_CD      = request.getParameter("PARAM_CUST_CD");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_GRUP_TOP_CD",    PARAM_GRUP_TOP_CD);
		paramMap.put("PARAM_GRUP_MID_CD",    PARAM_GRUP_MID_CD);
		paramMap.put("PARAM_GRUP_BOT_CD",    PARAM_GRUP_BOT_CD);
		paramMap.put("PARAM_BCD_NM"     ,    "%"+PARAM_BCD_NM + "%");
		paramMap.put("PARAM_ORGN_DIV_CD",    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"    ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_CUST_CD"    ,    PARAM_CUST_CD);
		
		//logger.debug(" PARAM_GRUP_TOP_CD =>" + PARAM_GRUP_TOP_CD +" PARAM_GRUP_MID_CD =>" + PARAM_GRUP_MID_CD );
		//logger.debug(" PARAM_GRUP_BOT_CD =>" + PARAM_GRUP_BOT_CD +" PARAM_BCD_NM      =>" + PARAM_BCD_NM  );
		//logger.debug(" PARAM_ORGN_DIV_CD =>" + PARAM_ORGN_DIV_CD +" PARAM_ORGN_CD     =>" + PARAM_ORGN_CD );
		//logger.debug(" PARAM_CUST_CD     =>" + PARAM_CUST_CD  );
		
		List<Map<String, Object>> customList = customerGoodsManagementService.getSearchMasterBarcodePriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	
	/**
	  * custmrStdPriceManagement - 고객그룹별_기준가관리(상품별)
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="custmrStdPriceManagement.sis", method=RequestMethod.POST)
	public ModelAndView custmrStdPriceManagement(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "custmrStdPriceManagement");
		return mav;
	}
	
	/**
	  * getCustmrStdPrice - 고객그룹별_기준가관리(상품별) - 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Transactional
	@RequestMapping(value="getCustmrStdPrice.do", method=RequestMethod.POST)
	public Map<String, Object> getCustmrStdPrice(HttpServletRequest request, @RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> gridDataList = customerGoodsManagementService.getCustmrStdPrice(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}finally {
			if(resultMap.containsKey("isError")) {
				if(resultMap.get("isError") != null && (boolean) resultMap.get("isError")) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				}
			}
		}
		return resultMap;
	}
	
	/**
	  * getCustmrStdPriceGoodsInfo - 고객그룹별_기준가관리(상품별) - 상품추가
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getCustmrStdPriceGoodsInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getCustmrStdPriceGoodsInfo(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("gridDataList", customerGoodsManagementService.getCustmrStdPriceGoodsInfo(paramMap));
		return resultMap;
	}
	
	/**
	  * stdPriceManagement - 고객그룹별_기준가관리
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="stdPriceManagement.sis", method=RequestMethod.POST)
	public ModelAndView stdPriceManagement(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "stdPriceManagement");
		return mav;
	}
	
	/**
	  * getGrupStdPrice - 고객그룹별_기준가관리 - 그룹조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Transactional
	@RequestMapping(value="getGrupStdPrice.do", method=RequestMethod.POST)
	public Map<String, Object> getGrupStdPrice(HttpServletRequest request, @RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> gridDataList = customerGoodsManagementService.getGrupStdPrice(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}finally {
			if(resultMap.containsKey("isError")) {
				if(resultMap.get("isError") != null && (boolean) resultMap.get("isError")) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				}
			}
		}
		return resultMap;
	}
	
	/**
	  * custmrStdPriceLookUp - 고객그룹별_기준가조회(상품별)
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="custmrStdPriceLookUp.sis", method=RequestMethod.POST)
	public ModelAndView custmrStdPriceLookUp(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "custmrStdPriceLookUp");
		return mav;
	}
	
	/**
	  * getGoodsStdPrice - 고객그룹별_기준가관리 - 상품조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Transactional
	@RequestMapping(value="getGoodsStdPrice.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsStdPrice(HttpServletRequest request, @RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> gridDataList = customerGoodsManagementService.getGoodsStdPrice(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}finally {
			if(resultMap.containsKey("isError")) {
				if(resultMap.get("isError") != null && (boolean) resultMap.get("isError")) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				}
			}
		}
		return resultMap;
	}
	
	/**
	  * getStdPriceCustmrList - 고객그룹별_기준가관리 - 거래처조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Transactional
	@RequestMapping(value="getStdPriceCustmrList.do", method=RequestMethod.POST)
	public Map<String, Object> getStdPriceCustmrList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> gridDataList = customerGoodsManagementService.getStdPriceCustmrList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}finally {
			if(resultMap.containsKey("isError")) {
				if(resultMap.get("isError") != null && (boolean) resultMap.get("isError")) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				}
			}
		}
		return resultMap;
	}
	
	/**
	  * saveGrupStdPrice - 고객그룹별_기준가관리 - 그룹저장
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Transactional
	@RequestMapping(value="saveGrupStdPrice.do", method=RequestMethod.POST)
	public Map<String, Object> saveGrupStdPrice(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> grupCdInfoParam = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String USER = empSessionDto.getEmp_no();
		String PROGRM="saveGrupStdPrice";
		String CUSTMR_GRUP = "";
		String STD_PRICE_GRUP ="";
		
		Map<String, Object> stdPriceGrupCdInfo = new HashMap<String, Object>();
		
		int insertResult = 0;
		int updateResult = 0;
		int deleteResult = 0;
		
		try {
			for(int i = 0 ; i < dhtmlxParamMapList.size(); i++) {
				paramMap = dhtmlxParamMapList.get(i);
				CUSTMR_GRUP = dhtmlxParamMapList.get(i).get("CUSTMR_GRUP").toString();
				
				paramMap.put("USER", USER);
				paramMap.put("PROGRM", PROGRM);
				if(dhtmlxParamMapList.get(i).get("CRUD").equals("C")){
					grupCdInfoParam.put("CUSTMR_GRUP", CUSTMR_GRUP);
					
					stdPriceGrupCdInfo = customerGoodsManagementService.getStdPriceGrupCdCheck(grupCdInfoParam);
					STD_PRICE_GRUP = stdPriceGrupCdInfo.get("STD_PRICE_GRUP").toString();
					
					paramMap.put("STD_PRICE_GRUP", STD_PRICE_GRUP);
					
					insertResult += customerGoodsManagementService.addGrupStdPrice(paramMap);
				} else if (dhtmlxParamMapList.get(i).get("CRUD").equals("D")) {
					deleteResult += customerGoodsManagementService.deleteGrupStdPrice(paramMap);
				} else if (dhtmlxParamMapList.get(i).get("CRUD").equals("U")) {
					updateResult += customerGoodsManagementService.updateGrupStdPrice(paramMap);
				}
			}
			if((insertResult + deleteResult + updateResult) == dhtmlxParamMapList.size()) {
				resultMap.put("resultRowCnt", (insertResult  + deleteResult + updateResult));
			}else {
				String errMesage = "거래처 그룹은 변경할 수 없습니다.";
				String errCode = "1999";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
			}
		}catch(SQLException e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}finally{
			if(resultMap.containsKey("isError")) {
				if(resultMap.get("isError") != null && (boolean) resultMap.get("isError")) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				}
			}
		}
		return resultMap;
	}
	
	/**
	  * getStdPriceGoodsManagementInfo - 고객그룹별_기준가관리 - 상품추가
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getStdPriceGoodsManagementInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getStdPriceGoodsManagementInfo(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("gridDataList", customerGoodsManagementService.getStdPriceGoodsManagementInfo(paramMap));
		return resultMap;
	}
	
	/**
	  * saveGoodsStdPrice - 고객그룹별_기준가관리 - 상품저장
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Transactional
	@RequestMapping(value="saveGoodsStdPrice.do", method=RequestMethod.POST)
	public Map<String, Object> saveGoodsStdPrice(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String USER = empSessionDto.getEmp_no();
		String PROGRM="saveGoodsStdPrice";
		
		int insertResult = 0;
		int updateResult = 0;
		int deleteResult = 0;
		
		try {
			for(int i = 0 ; i < dhtmlxParamMapList.size(); i++) {
				paramMap = dhtmlxParamMapList.get(i);
				
				paramMap.put("USER", USER);
				paramMap.put("PROGRM", PROGRM);
				if(dhtmlxParamMapList.get(i).get("CRUD").equals("C")){
					insertResult += customerGoodsManagementService.addGoodsStdPrice(paramMap);
				} else if (dhtmlxParamMapList.get(i).get("CRUD").equals("D")) {
					deleteResult += customerGoodsManagementService.deleteGoodsStdPrice(paramMap);
				} else if (dhtmlxParamMapList.get(i).get("CRUD").equals("U")) {
					updateResult += customerGoodsManagementService.updateGoodsStdPrice(paramMap);
				}
			}
			if((insertResult + deleteResult + updateResult) == dhtmlxParamMapList.size()) {
				resultMap.put("resultRowCnt", (insertResult  + deleteResult + updateResult));
			}else {
				String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1999";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
			}
		}catch(SQLException e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}finally{
			if(resultMap.containsKey("isError")) {
				if(resultMap.get("isError") != null && (boolean) resultMap.get("isError")) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				}
			}
		}
		return resultMap;
	}
	
	/**
	  * saveCustmrStdPrice - 고객그룹별_기준가관리(상품별) - 저장
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Transactional
	@RequestMapping(value="saveCustmrStdPrice.do", method=RequestMethod.POST)
	public Map<String, Object> saveCustmrStdPrice(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String USER = empSessionDto.getEmp_no();
		String PROGRM="saveCustmrStdPrice";
		
		int insertResult = 0;
		int updateResult = 0;
		int deleteResult = 0;
		
		try {
			for(int i = 0 ; i < dhtmlxParamMapList.size(); i++) {
				paramMap = dhtmlxParamMapList.get(i);
				
				paramMap.put("USER", USER);
				paramMap.put("PROGRM", PROGRM);
				if(dhtmlxParamMapList.get(i).get("CRUD").equals("C")){
					insertResult += customerGoodsManagementService.addCustmrStdPrice(paramMap);
				} else if (dhtmlxParamMapList.get(i).get("CRUD").equals("D")) {
					deleteResult += customerGoodsManagementService.deleteCustmrStdPrice(paramMap);
				} else if (dhtmlxParamMapList.get(i).get("CRUD").equals("U")) {
					updateResult += customerGoodsManagementService.updateCustmrStdPrice(paramMap);
				}
			}
			if((insertResult + deleteResult + updateResult) == dhtmlxParamMapList.size()) {
				resultMap.put("resultRowCnt", (insertResult  + deleteResult + updateResult));
			}else {
				String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1999";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
			}
		}catch(SQLException e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}finally{
			if(resultMap.containsKey("isError")) {
				if(resultMap.get("isError") != null && (boolean) resultMap.get("isError")) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				}
			}
		}
		return resultMap;
	}
	
	/**
	  * getCustmrStdPriceLookUp - 기준가조회(상품별)
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Transactional
	@ResponseBody
	@RequestMapping(value="getCustmrStdPriceLookUp.do", method=RequestMethod.POST)
	public Map<String, Object> getCustmrStdPriceLookUp(HttpServletRequest request, @RequestBody Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String CUSTMR_LIST = request.getParameter("CUSTMR_LIST");
		CUSTMR_LIST = paramMap.get("CUSTMR_LIST").toString();
		
		String[] CUSTMR_CHECK_LIST = CUSTMR_LIST.split(",");
		
		StringBuilder CUSTMR_GRUP_LIST = new StringBuilder();
		
		ArrayList<String> grups = new ArrayList<String>();
		Collections.addAll(grups, CUSTMR_CHECK_LIST);
		
		for (int i = 0 ; i < grups.size() ; i++) {
			if(i == 0) {
				CUSTMR_GRUP_LIST.append("[");
				CUSTMR_GRUP_LIST.append(grups.get(i));
				CUSTMR_GRUP_LIST.append("]");
			} else {
				CUSTMR_GRUP_LIST.append(",[");
				CUSTMR_GRUP_LIST.append(grups.get(i));
				CUSTMR_GRUP_LIST.append("]");
			}
		}
		
		paramMap.put("CUSTMR_GRUP_LIST", CUSTMR_GRUP_LIST);
		
		try {
			List<Map<String, Object>> gridDataList = customerGoodsManagementService.getCustmrStdPriceLookUp(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}finally {
			if(resultMap.containsKey("isError")) {
				if(resultMap.get("isError") != null && (boolean) resultMap.get("isError")) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				}
			}
		}
		return resultMap;
	}
}
