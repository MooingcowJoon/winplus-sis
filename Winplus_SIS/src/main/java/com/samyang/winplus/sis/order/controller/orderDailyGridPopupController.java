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

import com.samyang.winplus.sis.order.service.OrderInputGridPopupService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;
import java.util.Iterator;

@RequestMapping("/sis/order")
@RestController
public class orderDailyGridPopupController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	OrderInputGridPopupService orderInputGridPopupService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/order"; // JSP경로


	/**
	  * orderDailyGridPopup -   일배상품 주문서등록 팝업
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderDailyGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView orderPortalGridPopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderDailyGridPopupController.java  orderDailyGridPopup.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderDailyGridPopup");
		return mav;
	}
	
	/**
	  * getSearchMasterBarcodeCustmrPriceList -거래처포털  바코드 전문(취급)점 센터주문 최저가 가져오기)
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchMasterBarcodeCustmrPriceList1.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchMasterBarcodeCustmrPriceList1(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderPortalGridPopupController.java  getSearchMasterBarcodeCustmrPriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_LVL          = request.getParameter("PARAM_LVL");
		String PARAM_GRUP_TOP_CD  = request.getParameter("PARAM_GRUP_TOP_CD");
		String PARAM_GRUP_MID_CD  = request.getParameter("PARAM_GRUP_MID_CD");
		String PARAM_GRUP_BOT_CD  = request.getParameter("PARAM_GRUP_BOT_CD");
		String PARAM_BCD_NM       = request.getParameter("PARAM_BCD_NM");
		String PARAM_ORGN_DIV_CD  = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD      = request.getParameter("PARAM_ORGN_CD");
		String PARAM_CUSTMR_CD    = request.getParameter("PARAM_CUSTMR_CD");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_LVL"        ,    PARAM_LVL);
		paramMap.put("PARAM_GRUP_TOP_CD",    PARAM_GRUP_TOP_CD);
		paramMap.put("PARAM_GRUP_MID_CD",    PARAM_GRUP_MID_CD);
		paramMap.put("PARAM_GRUP_BOT_CD",    PARAM_GRUP_BOT_CD);
		paramMap.put("PARAM_BCD_NM"     ,    "%"+PARAM_BCD_NM + "%");
		paramMap.put("PARAM_ORGN_DIV_CD",    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"    ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_CUSTMR_CD"  ,    PARAM_CUSTMR_CD);
		
		//logger.debug(" PARAM_LVL => " + PARAM_LVL );
		//logger.debug(" PARAM_GRUP_TOP_CD =>" + PARAM_GRUP_TOP_CD +" PARAM_GRUP_MID_CD =>" + PARAM_GRUP_MID_CD );
		//logger.debug(" PARAM_GRUP_BOT_CD =>" + PARAM_GRUP_BOT_CD +" PARAM_BCD_NM      =>" + PARAM_BCD_NM  );
		//logger.debug(" PARAM_ORGN_DIV_CD =>" + PARAM_ORGN_DIV_CD +" PARAM_ORGN_CD     =>" + PARAM_ORGN_CD );
		
		List<Map<String, Object>> customList = orderInputGridPopupService.getSearchMasterBarcodeCustmrPriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	

}
