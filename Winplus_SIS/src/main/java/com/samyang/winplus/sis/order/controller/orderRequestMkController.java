package com.samyang.winplus.sis.order.controller;

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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.sis.order.service.OrderRequestService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;

@RequestMapping("/sis/order")
@RestController
public class orderRequestMkController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	OrderRequestService orderRequestService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/order"; // JSP경로


	/**
	  * orderSearch - 직영점 발주서등록
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderRequestMk.sis", method=RequestMethod.POST)
	public ModelAndView orderSearch(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderRequestMkController.java  orderRequestMk.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderRequestMk");
		return mav;
	}

	/**
	  * orderRequestMkEM - 직영점 긴급발주서등록
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderRequestMkEM.sis", method=RequestMethod.POST)
	public ModelAndView orderRequestMkEM(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderRequestMkController.java  orderRequestMkEM.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderRequestMkEM");
		return mav;
	}	
}
