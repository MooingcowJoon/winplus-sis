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
public class orderSearchPopupController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	OrderSearchService orderSearchService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/order"; // JSP경로


	/**
	  * orderSearch - 발주서LIST 조회 팝업
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  * @description 발주기간, 발주번호, 진행상태등으로(본사,직영점, 취급점) 팝업 열기 
	  * 
	  */
	@RequestMapping(value="orderSearchPopup.sis", method=RequestMethod.POST)
	public ModelAndView orderSearchPopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderSearchPopupController.java  orderSearchPopup.sis ============");
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderSearchPopup");
		return mav;
	}
	
	
	/**
	  * orderRequestPopup - 2차발주 대상 호출( 착지변경, 일배발주, 신선발주 )
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  * @description  착지변경, 일배발주, 신선발주를 하기위한 직영점 및 취급점에 발주요청한 LIST를 팝업으로 호출한다. 
	  * 
	  */
	@RequestMapping(value="orderRequestPopup.sis", method=RequestMethod.POST)
	public ModelAndView orderSecondPopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderSearchPopupController.java  orderRequestPopup.sis ============");
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderRequestPopup");
		return mav;
	}
		
	
	/**
	  * openOrderSearchGridPopup - 발주서 상세내역조회 팝업
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  * @description 특정발주서 번호에대한 발주상세내역조회 팝업 
	  * 
	  */
	@RequestMapping(value="openOrderSearchGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView openOrderSearchGridPopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ openOrderSearchGridPopupController.java  openOrderSearchGridPopup.sis ============");
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openOrderSearchGridPopup");
		return mav;
	}
	
}
