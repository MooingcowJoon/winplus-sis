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

import com.samyang.winplus.sis.order.service.OrderInputParmGridPopupService;
                                             
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;
import java.util.Iterator;

@RequestMapping("/sis/order")
@RestController
public class orderInputParmGridPopupController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	OrderInputParmGridPopupService orderInputParmGridPopupService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/order"; // JSP경로


	/**
	  * orderInputGridPopup -   주문서등록 팝업
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderInputParmGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView orderInputGridPopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderInputParmGridPopupController.java  orderInputParmGridPopup.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderInputParmGridPopup");
		return mav;
	}
	
	/**
	  * getParmOrderGoodsPriceList - 팜에서 직영점발주 집계건의 외부공급사로 발주시 상품,최저가(or전체공급사) 가져오기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getParmOrderGoodsPriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getParmOrderGoodsPriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderInputParmGridPopupController.java  getSearchMasterBarcodePriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_ORD_DATE     = request.getParameter("PARAM_ORD_DATE");
		String PARAM_BCD_NM       = request.getParameter("PARAM_BCD_NM");
		String PARAM_CUST_CD      = request.getParameter("PARAM_CUST_CD");
		String PARAM_ROWNUM       = request.getParameter("PARAM_ROWNUM");
 
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORD_DATE"    ,  PARAM_ORD_DATE );
		paramMap.put("PARAM_BCD_NM"      ,  "%"+PARAM_BCD_NM + "%");
		paramMap.put("PARAM_CUST_CD"     ,  PARAM_CUST_CD );
		paramMap.put("PARAM_ROWNUM"      ,  PARAM_ROWNUM );
	
		//logger.debug("PARAM_ORD_DATE =>" + PARAM_ORD_DATE + " PARAM_BCD_NM =>" + PARAM_BCD_NM  + " PARAM_CUST_CD => " + PARAM_CUST_CD );
		
		List<Map<String, Object>> customList = orderInputParmGridPopupService.getParmOrderGoodsPriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}	
	
	/**
	  * getParmOrderGoodsMatrixList - 상품-직영점 단위 팜발주요청조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getParmOrderGoodsMatrixList.do", method=RequestMethod.POST)
	public Map<String, Object> getParmOrderGoodsMatrixList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderInputParmGridPopupController.java  getParmOrderGoodsMatrixList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		String PARAM_ORD_DATE    = request.getParameter("PARAM_ORD_DATE");
		String PARAM_BCD_CD      = request.getParameter("PARAM_BCD_CD");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORD_DATE"   ,  PARAM_ORD_DATE );
		paramMap.put("PARAM_BCD_CD"     ,  PARAM_BCD_CD );
		
		//logger.debug(" PARAM_ORD_DATE  =>" + PARAM_ORD_DATE + " PARAM_BCD_CD =>" + PARAM_BCD_CD );
		
		List<Map<String, Object>> customList = orderInputParmGridPopupService.getParmOrderGoodsMatrixList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}		
	
	
}
