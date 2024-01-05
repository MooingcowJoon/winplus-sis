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

import com.samyang.winplus.sis.order.service.OrderParmSearchService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;

@RequestMapping("/sis/order")
@RestController
public class orderParmSearhController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	OrderParmSearchService orderParmSearchService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/order"; // JSP경로


	/**
	  * orderParmSearch - 팜 발주서조회
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderParmSearch.sis", method=RequestMethod.POST)
	public ModelAndView orderSearch(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderParmSearhController.java  orderParmSearch.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderParmSearch");
		return mav;
	}

	/**
	  * getOrderParmSearchList - 팜 주문서조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getOrderParmSearchList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchOrderList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderParmSearhController.java  getOrderParmSearchList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_ORGN_DIV_CD      = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD          = request.getParameter("PARAM_ORGN_CD");
		String PARAM_ORGN_DIV_TYP     = request.getParameter("PARAM_ORGN_DIV_TYP");
		String PARAM_ORD_STR_YYYYMMDD = request.getParameter("PARAM_ORD_STR_YYYYMMDD");
		String PARAM_ORD_NO           = request.getParameter("PARAM_ORD_NO");
		String PARAM_IN_WARE_CD       = request.getParameter("PARAM_IN_WARE_CD");
		String PARAM_ORD_TYPE         = request.getParameter("PARAM_ORD_TYPE");
		String LOGIN_CHANNEL          = request.getParameter("LOGIN_CHANNEL");
		
		//logger.debug("@@@ PARAM_ORGN_DIV_CD => " + PARAM_ORGN_DIV_CD + " PARAM_ORGN_DIV_TYP => " + PARAM_ORGN_DIV_TYP );

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORGN_DIV_CD"     ,    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"         ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_ORGN_DIV_TYP"    ,    PARAM_ORGN_DIV_TYP);
		paramMap.put("PARAM_ORD_STR_YYYYMMDD",    PARAM_ORD_STR_YYYYMMDD);
		paramMap.put("PARAM_ORD_NO"          ,    PARAM_ORD_NO);
		paramMap.put("PARAM_IN_WARE_CD"      ,    PARAM_IN_WARE_CD);
		paramMap.put("PARAM_ORD_TYPE"        ,    PARAM_ORD_TYPE);  /* 1:발주, 2:주문 */
		paramMap.put("LOGIN_CHANNEL"         ,    LOGIN_CHANNEL);    /* S: SIS,  P:PORTAL */
		
		List<Map<String, Object>> customList = orderParmSearchService.getOrderParmSearchList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	
	/**
	  * insertOrdTemp - 집계처리 (직영점에서 팜으로 발주요청한건을 집계처리한다)
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="insertOrdTemp.do", method=RequestMethod.POST)
	public Map<String, Object> insertOrdTemp(HttpServletRequest request, @RequestParam Map<String,Object> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderParmSearhController.java  insertOrdTemp.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
        EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();

		String PARAM_ORD_DATE      = request.getParameter("PARAM_ORD_DATE");
		//logger.debug("PARAM_ORD_DATE => " + PARAM_ORD_DATE  );

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORD_DATE"     ,    PARAM_ORD_DATE);
		paramMap.put("REG_ID"             ,    emp_no);
		paramMap.put("PARAM_PROGRM"       ,    "ParmOrderInsert");
		
		int insert_row = orderParmSearchService.SavePurOrdGoodsTemp(paramMap);	
		resultMap.put("gridDataList", Integer.toString(insert_row));
		
		return resultMap;
	}	
	
	
}
