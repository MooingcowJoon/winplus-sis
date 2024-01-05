package com.samyang.winplus.sis.supplyportal.controller;

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

@RequestMapping("/sis/supplyportal")
@RestController
public class orderSearchManageController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	OrderSearchService orderSearchService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/supplyportal"; // JSP경로


	/**
	  * orderSearch - 공급사 포털 주문서조회
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderSearchManage.sis", method=RequestMethod.POST)
	public ModelAndView orderSearchManage(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderSearchManageController.java  orderSearchManage.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderSearchManage");
		return mav;
	}

	/**
	  * orderOutInputPopup - 협력사포털 출고등록(취급점 및 전문점에서 요청한 Table에다 출고일자 및 수량만 update)
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderOutInputPopup.sis", method=RequestMethod.POST)
	public ModelAndView orderOutInputPopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderSearchManageController.java  orderOutInputPopup.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderOutInputPopup");
		return mav;
	}
	
	/**
	  * getSearchOrderList - 주문서조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchOrderList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchOrderList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderSheetSearhController.java  getSearchOrderList.do ============");
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
				
		//logger.debug(" PARAM_ORGN_DIV_CD =>" + PARAM_ORGN_DIV_CD + " PARAM_ORGN_CD => " + PARAM_ORGN_CD);

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
		
		List<Map<String, Object>> customList = orderSearchService.getSearchOrderList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	
}
