package com.samyang.winplus.sis.order.controller;

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

import com.samyang.winplus.sis.order.service.OrderSearchService;
import com.samyang.winplus.common.system.util.CommonUtil;

@RequestMapping("/sis/order")
@RestController
public class orderSheetSearhController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	OrderSearchService orderSearchService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/order"; // JSP경로


	/**
	  * orderSearch - 주문서조회 화면 호출
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderSheetSearch.sis", method=RequestMethod.POST)
	public ModelAndView orderSearch(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderSheetSearhController.java  orderSheetSearch.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderSheetSearch");
		return mav;
	}

	/**
	  * orderSheetConfirm - 긴급주문서 영업승인 화면 조회
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderSheetConfirm.sis", method=RequestMethod.POST)
	public ModelAndView orderSheetConfirm(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderSheetSearhController.java  orderSheetConfirm.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderSheetConfirm");
		return mav;
	}


	/**
	  * orderSheetConfirm2 - 긴급주문서 센터승인 화면 조회
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderSheetConfirm2.sis", method=RequestMethod.POST)
	public ModelAndView orderSheetConfirm2(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderSheetSearhController.java  orderSheetConfirm2.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderSheetConfirm2");
		return mav;
	}
	
	
	/**
	  * orderBaljooSearch - 발주서조회(센터 및 직영점) 화면호출
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderBaljooSearch.sis", method=RequestMethod.POST)
	public ModelAndView orderBaljooSearch(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderSheetSearhController.java  orderBaljooSearch.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderBaljooSearch");
		return mav;
	}

	
	/**
	  * getSearchOrderList - 주문서(발주Data기준) 조회   ( getOrderManagement와 차이 외부협력사도 포함됨)
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchOrderList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchOrderList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		logger.debug("@@@@@@@@@@ orderSheetSearhController.java  getSearchOrderList.do ============");
 	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_ORGN_DIV_CD      = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD          = request.getParameter("PARAM_ORGN_CD");
		String PARAM_ORD_STR_YYYYMMDD = request.getParameter("PARAM_ORD_STR_YYYYMMDD");
		String PARAM_ORD_END_YYYYMMDD = request.getParameter("PARAM_ORD_END_YYYYMMDD");
		String PARAM_DEL_STR_YYYYMMDD = request.getParameter("PARAM_DEL_STR_YYYYMMDD");
		String PARAM_DEL_END_YYYYMMDD = request.getParameter("PARAM_DEL_END_YYYYMMDD");
		String PARAM_ORD_NO           = request.getParameter("PARAM_ORD_NO");
		String PARAM_PROJ_CD          = request.getParameter("PARAM_PROJ_CD");
		String PARAM_IN_WARE_CD       = request.getParameter("PARAM_IN_WARE_CD");
		String PARAM_OUT_WARE_CD      = request.getParameter("PARAM_OUT_WARE_CD");
		String PARAM_SUPR_CD          = request.getParameter("PARAM_SUPR_CD");
		String PARAM_RESP_USER        = request.getParameter("PARAM_RESP_USER");
		String PARAM_ORD_TYPE         = request.getParameter("PARAM_ORD_TYPE");
		String LOGIN_CHANNEL          = request.getParameter("LOGIN_CHANNEL");
		String LOGIN_MENU             = request.getParameter("LOGIN_MENU");
		String PARAM_ORD_PATH         = request.getParameter("PARAM_ORD_PATH");
		
		logger.debug(" PARAM_ORGN_DIV_CD =>" + PARAM_ORGN_DIV_CD + " PARAM_ORGN_CD => " + PARAM_ORGN_CD);
		logger.debug(" LOGIN_CHANNEL =>" + LOGIN_CHANNEL + " LOGIN_MENU => " + LOGIN_MENU + " PARAM_ORD_PATH => " + PARAM_ORD_PATH);


		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORGN_DIV_CD"     ,    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"         ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_ORD_STR_YYYYMMDD",    PARAM_ORD_STR_YYYYMMDD);
		paramMap.put("PARAM_ORD_END_YYYYMMDD",    PARAM_ORD_END_YYYYMMDD);
		paramMap.put("PARAM_DEL_STR_YYYYMMDD",    PARAM_DEL_STR_YYYYMMDD);
		paramMap.put("PARAM_DEL_END_YYYYMMDD",    PARAM_DEL_END_YYYYMMDD);
		paramMap.put("PARAM_ORD_NO"          ,    PARAM_ORD_NO);
		paramMap.put("PARAM_PROJ_CD"         ,    PARAM_PROJ_CD);
		paramMap.put("PARAM_IN_WARE_CD"      ,    PARAM_IN_WARE_CD);
		paramMap.put("PARAM_OUT_WARE_CD"     ,    PARAM_OUT_WARE_CD);
		paramMap.put("PARAM_SUPR_CD"         ,    PARAM_SUPR_CD);
		paramMap.put("PARAM_RESP_USER"       ,    PARAM_RESP_USER);
		paramMap.put("PARAM_ORGN_DIV_CD"     ,    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORD_TYPE"        ,    PARAM_ORD_TYPE);   /* 1:발주, 2:주문 */
		paramMap.put("LOGIN_CHANNEL"         ,    LOGIN_CHANNEL);    /* S: SIS,  P:PORTAL */
		paramMap.put("LOGIN_MENU"            ,    LOGIN_MENU);       /* CT:센터메뉴,  MK 직영점 메뉴 */
		paramMap.put("PARAM_ORD_PATH"        ,    PARAM_ORD_PATH);   /* 거래내역조회하기만 사용  */
		
		List<Map<String, Object>> customList = orderSearchService.getSearchOrderList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}

	/**
	  * getOrderManagement - 윈플러스로의 부문서전용 조회(발주Data기준) 조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getOrderManagement.do", method=RequestMethod.POST)
	public Map<String, Object> getOrderManagement(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		logger.debug("@@@@@@@@@@ orderSheetSearhController.java  getOrderManagement.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_ORGN_DIV_CD      = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD          = request.getParameter("PARAM_ORGN_CD");
		String PARAM_ORD_STR_YYYYMMDD = request.getParameter("PARAM_ORD_STR_YYYYMMDD");
		String PARAM_ORD_END_YYYYMMDD = request.getParameter("PARAM_ORD_END_YYYYMMDD");
		String PARAM_DEL_STR_YYYYMMDD = request.getParameter("PARAM_DEL_STR_YYYYMMDD");
		String PARAM_DEL_END_YYYYMMDD = request.getParameter("PARAM_DEL_END_YYYYMMDD");
		String PARAM_ORD_NO           = request.getParameter("PARAM_ORD_NO");
		String PARAM_PROJ_CD          = request.getParameter("PARAM_PROJ_CD");
		String PARAM_IN_WARE_CD       = request.getParameter("PARAM_IN_WARE_CD");
		String PARAM_OUT_WARE_CD      = request.getParameter("PARAM_OUT_WARE_CD");
		String PARAM_SUPR_CD          = request.getParameter("PARAM_SUPR_CD");
		String PARAM_RESP_USER        = request.getParameter("PARAM_RESP_USER");
		String PARAM_ORD_TYPE         = request.getParameter("PARAM_ORD_TYPE");
		String LOGIN_CHANNEL          = request.getParameter("LOGIN_CHANNEL");
		String LOGIN_MENU             = request.getParameter("LOGIN_MENU");
				
		logger.debug(" PARAM_ORGN_DIV_CD =>" + PARAM_ORGN_DIV_CD + " PARAM_ORGN_CD => " + PARAM_ORGN_CD);
		logger.debug(" LOGIN_CHANNEL =>" + LOGIN_CHANNEL + " LOGIN_MENU => " + LOGIN_MENU);


		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORGN_DIV_CD"     ,    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"         ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_ORD_STR_YYYYMMDD",    PARAM_ORD_STR_YYYYMMDD);
		paramMap.put("PARAM_ORD_END_YYYYMMDD",    PARAM_ORD_END_YYYYMMDD);
		paramMap.put("PARAM_DEL_STR_YYYYMMDD",    PARAM_DEL_STR_YYYYMMDD);
		paramMap.put("PARAM_DEL_END_YYYYMMDD",    PARAM_DEL_END_YYYYMMDD);
		paramMap.put("PARAM_ORD_NO"          ,    PARAM_ORD_NO);
		paramMap.put("PARAM_PROJ_CD"         ,    PARAM_PROJ_CD);
		paramMap.put("PARAM_IN_WARE_CD"      ,    PARAM_IN_WARE_CD);
		paramMap.put("PARAM_OUT_WARE_CD"     ,    PARAM_OUT_WARE_CD);
		paramMap.put("PARAM_SUPR_CD"         ,    PARAM_SUPR_CD);
		paramMap.put("PARAM_RESP_USER"       ,    PARAM_RESP_USER);
		paramMap.put("PARAM_ORGN_DIV_CD"     ,    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORD_TYPE"        ,    PARAM_ORD_TYPE);   /* 1:발주, 2:주문 */
		paramMap.put("LOGIN_CHANNEL"         ,    LOGIN_CHANNEL);    /* S: SIS,  P:PORTAL */
		paramMap.put("LOGIN_MENU"            ,    LOGIN_MENU);       /* CT:센터메뉴,  MK 직영점 메뉴 */
		
		List<Map<String, Object>> customList = orderSearchService.getOrderManagement(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	
	/**
	  * getRequestOrderList - CS포털 주문서조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getRequestOrderList.do", method=RequestMethod.POST)
	public Map<String, Object> getRequestOrderList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		logger.debug("@@@@@@@@@@ orderSheetSearhController.java  getRequestOrderList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_CUSTMR_CD  = request.getParameter("PARAM_CUSTMR_CD");
		String PARAM_STR_DATE   = request.getParameter("PARAM_STR_DATE");
		String PARAM_END_DATE   = request.getParameter("PARAM_END_DATE");
				
		logger.debug(" PARAM_CUSTMR_CD =>" + PARAM_CUSTMR_CD + " PARAM_STR_DATE => " + PARAM_STR_DATE + " PARAM_END_DATE => " + PARAM_END_DATE);

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_CUSTMR_CD",   PARAM_CUSTMR_CD);
		paramMap.put("PARAM_STR_DATE",    PARAM_STR_DATE);
		paramMap.put("PARAM_END_DATE",    PARAM_END_DATE);

		List<Map<String, Object>> customList = orderSearchService.getRequestOrderList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}	
	
	/**
	  * getSecondOrderList - 착지변경 및 일배2차 발주를 위한 1차발주 list조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSecondOrderList.do", method=RequestMethod.POST)
	public Map<String, Object> getSecondOrderList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		logger.debug("@@@@@@@@@@ orderSheetSearhController.java  getSecondOrderList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_REQ_DATE   = request.getParameter("PARAM_REQ_DATE");
		String PARAM_ORD_TYPE   = request.getParameter("PARAM_ORD_TYPE");
				
		logger.debug(" PARAM_REQ_DATE =>" + PARAM_REQ_DATE + " PARAM_ORD_TYPE => " + PARAM_ORD_TYPE);

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_REQ_DATE"  ,  PARAM_REQ_DATE);
		paramMap.put("PARAM_ORD_TYPE"  ,  PARAM_ORD_TYPE);
		
		List<Map<String, Object>> customList = orderSearchService.getSecondOrderList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}	
	
	/**
	  * getSearchBaljooList - 주문서(발주Data기준) 조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchBaljooList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchBaljooList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		logger.debug("@@@@@@@@@@ orderSheetSearhController.java  getSearchBaljooList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_ORGN_DIV_CD      = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD          = request.getParameter("PARAM_ORGN_CD");
		String PARAM_ORD_STR_YYYYMMDD = request.getParameter("PARAM_ORD_STR_YYYYMMDD");
		String PARAM_ORD_END_YYYYMMDD = request.getParameter("PARAM_ORD_END_YYYYMMDD");
		String PARAM_ORD_NO           = request.getParameter("PARAM_ORD_NO");
		String PARAM_DEL_STR_YYYYMMDD = request.getParameter("PARAM_DEL_STR_YYYYMMDD");
		String PARAM_DEL_END_YYYYMMDD = request.getParameter("PARAM_DEL_END_YYYYMMDD");
		String PARAM_SUPR_CD          = request.getParameter("PARAM_SUPR_CD");
		String PARAM_RESP_USER        = request.getParameter("PARAM_RESP_USER");
		String LOGIN_MENU             = request.getParameter("LOGIN_MENU");
				
		logger.debug(" PARAM_ORGN_DIV_CD      =>" + PARAM_ORGN_DIV_CD      + " PARAM_ORGN_CD => " + PARAM_ORGN_CD);
		logger.debug(" PARAM_ORD_STR_YYYYMMDD =>" + PARAM_ORD_STR_YYYYMMDD + " PARAM_ORD_END_YYYYMMDD => " + PARAM_ORD_END_YYYYMMDD);
		logger.debug(" LOGIN_MENU =>" + LOGIN_MENU );

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORGN_DIV_CD"     ,    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"         ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_ORD_STR_YYYYMMDD",    PARAM_ORD_STR_YYYYMMDD);
		paramMap.put("PARAM_ORD_END_YYYYMMDD",    PARAM_ORD_END_YYYYMMDD);
		paramMap.put("PARAM_ORD_NO"          ,    PARAM_ORD_NO);
		paramMap.put("PARAM_DEL_STR_YYYYMMDD",    PARAM_DEL_STR_YYYYMMDD);
		paramMap.put("PARAM_DEL_END_YYYYMMDD",    PARAM_DEL_END_YYYYMMDD);
		paramMap.put("PARAM_SUPR_CD"         ,    PARAM_SUPR_CD);
		paramMap.put("PARAM_RESP_USER"       ,    PARAM_RESP_USER);
 		paramMap.put("LOGIN_MENU"            ,    LOGIN_MENU);       /* CT:센터메뉴,  MK 직영점 메뉴 */
		
		List<Map<String, Object>> customList = orderSearchService.getSearchBaljooList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}

	
	
	/**
	  * openOrderSheetInputSearch - 주문서(입력/수정) 상세조회 
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="openOrderSheetInputSearch.do", method=RequestMethod.POST)
	public Map<String, Object> openOrderSheetInputSearch(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		logger.debug("@@@@@@@@@@ orderSearhController.java  openOrderSheetInputSearch.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_ORGN_DIV_CD = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD     = request.getParameter("PARAM_ORGN_CD");
		String PARAM_ORD_NO      = request.getParameter("PARAM_ORD_NO");
		String PARAM_ORD_TYPE    = request.getParameter("PARAM_ORD_TYPE");
		
		logger.debug(" PARAM_ORGN_DIV_CD =>" + PARAM_ORGN_DIV_CD + " PARAM_ORGN_CD =>" + PARAM_ORGN_CD +" PARAM_ORD_NO =>" + PARAM_ORD_NO );

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORGN_DIV_CD"     ,    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"         ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_ORD_NO"          ,    PARAM_ORD_NO);
		paramMap.put("PARAM_ORD_TYPE"        ,    PARAM_ORD_TYPE);  /* 1:발주, 2:주문 */
		
		List<Map<String, Object>> customList = orderSearchService.getSearchOrderDetailList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	
	
}
