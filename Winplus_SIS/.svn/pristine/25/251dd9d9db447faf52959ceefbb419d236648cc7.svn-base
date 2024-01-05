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

/* 
 * 
 * 	프로그램명 및 최종Update일자 (거래처 포탈에서의 센터로 주문  2019-09-06 12:00:00 )
 * 
 */
@RequestMapping("/sis/order")
@RestController
public class orderPortalSearhController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	OrderSearchService orderSearchService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/order"; // JSP경로


	/**
	  * orderSearch - 발주서조회
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderPortalSearch.sis", method=RequestMethod.POST)
	public ModelAndView orderSearch(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderPortalSearhController.java  orderPortalSearch.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderPortalSearch");
		return mav;
	}
	
	/**
	  * orderCsPortalSearch - CS포털 주문서조회
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderCsPortalSearch.sis", method=RequestMethod.POST)
	public ModelAndView orderCsPortalSearch(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderPortalSearhController.java  orderCsPortalSearch.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderCsPortalSearch");
		return mav;
	}
		
	/**
	  * orderPortalPopup - 거래처포털 발주서 리스트조회
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderPortalPopup.sis", method=RequestMethod.POST)
	public ModelAndView orderPortalPopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderPortalSearhController.java  orderPortalPopup.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderPortalPopup");
		return mav;
	}
		
	
}
