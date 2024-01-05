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
public class orderPortalGridPopupController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	OrderInputGridPopupService orderInputGridPopupService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/order"; // JSP경로


	/**
	  * orderPortalGridPopup -   주문서등록 팝업
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderPortalGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView orderPortalGridPopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderPortalGridPopupController.java  orderPortalGridPopup.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderPortalGridPopup");
		return mav;
	}
	
	/**
	  * getSearchMasterBarcodeCustmrPriceList -거래처포털  바코드 전문(취급)점 센터주문 최저가 가져오기)
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchMasterBarcodeCustmrPriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchMasterBarcodeCustmrPriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderPortalGridPopupController.java  getSearchMasterBarcodeCustmrPriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		//logger.debug(" parmaMap =>" + parmaMap  );
	    
		String PARAM_LVL          = request.getParameter("PARAM_LVL");
		String PARAM_GRUP_TOP_CD  = request.getParameter("PARAM_GRUP_TOP_CD");
		String PARAM_GRUP_MID_CD  = request.getParameter("PARAM_GRUP_MID_CD");
		String PARAM_GRUP_BOT_CD  = request.getParameter("PARAM_GRUP_BOT_CD");
		String PARAM_BCD_NM       = request.getParameter("PARAM_BCD_NM");
		String PARAM_ORGN_DIV_CD  = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD      = request.getParameter("PARAM_ORGN_CD");
		String PARAM_CUSTMR_CD    = request.getParameter("PARAM_CUSTMR_CD");
		
		/* 이부분은 발주할 바코드대상정보를 가져올때  Host값을 전달후  발주영역그리드에 바로출력하기위함 */
		String PARAM_CUST_NM      = request.getParameter("PARAM_CUST_NM");       /* 고객사명        */
		String PARAM_ORD_NO       = request.getParameter("PARAM_ORD_NO");        /* 발주번호        */
		String PARAM_REQ_DATE     = request.getParameter("PARAM_REQ_DATE");      /* 발주일자        */
		String PARAM_ORD_TYPE     = request.getParameter("PARAM_ORD_TYPE");      /* 주문유형        */
		String PARAM_ORD_TYPE_NM  = request.getParameter("PARAM_ORD_TYPE_NM");   /* 주문유형명      */
		String PARAM_RESP_USER    = request.getParameter("PARAM_RESP_USER");     /* 로그인(처리자)  */
		String PARAM_EMP_NM       = request.getParameter("PARAM_EMP_NM");        /* 처리자명        */
		String PARAM_SUPR_CD      = request.getParameter("PARAM_SUPR_CD");       /* 협력사코드        */
		String PARAM_SUPR_NM      = request.getParameter("PARAM_SUPR_NM");       /* 협력사명          */
		String PARAM_CUS_TYPE     = request.getParameter("PARAM_CUS_TYPE");      /* 발행구분          */
		String PARAM_CUS_T_NM     = request.getParameter("PARAM_CUS_T_NM");      /* 발행구분명          */
		String PARAM_FLAG         = request.getParameter("PARAM_FLAG");          /* 처리상태          */
		String PARAM_FLAG_NM      = request.getParameter("PARAM_FLAG_NM");       /* 처리상태명          */
	    String OUT_CUST_CD        = request.getParameter("OUT_CUST_CD");         /* 외부공급사 코드 */
	    String PARAM_ROWNUM       = request.getParameter("PARAM_ROWNUM");        /* BCD단위 가져올 수량  1이면 최저가  */
	    String PARAM_CUST_DIV_CD  = request.getParameter("PARAM_CUST_DIV_CD");   /* 발주유형 B01물류센타로의 주문, A06신선팜으로주문, OUT외부공급사  */
	    String PARAM_GOODS_TYPE   = request.getParameter("PARAM_GOODS_TYPE");    /* 1물류, 2직납, 3신선, 4착지 5일배   */
	    	    	    
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_LVL"        ,    PARAM_LVL);
		paramMap.put("PARAM_GRUP_TOP_CD",    PARAM_GRUP_TOP_CD);
		paramMap.put("PARAM_GRUP_MID_CD",    PARAM_GRUP_MID_CD);
		paramMap.put("PARAM_GRUP_BOT_CD",    PARAM_GRUP_BOT_CD);
		paramMap.put("PARAM_BCD_NM"     ,    "%"+PARAM_BCD_NM + "%");
		paramMap.put("PARAM_ORGN_DIV_CD",    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"    ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_CUSTMR_CD"  ,    PARAM_CUSTMR_CD);
		
		paramMap.put("PARAM_CUST_NM"    ,    PARAM_CUST_NM);
		paramMap.put("PARAM_ORD_NO"     ,    PARAM_ORD_NO);
		paramMap.put("PARAM_REQ_DATE"   ,    PARAM_REQ_DATE);
		paramMap.put("PARAM_ORD_TYPE"   ,    PARAM_ORD_TYPE);
		paramMap.put("PARAM_ORD_TYPE_NM",    PARAM_ORD_TYPE_NM);
		paramMap.put("PARAM_RESP_USER"  ,    PARAM_RESP_USER);
		paramMap.put("PARAM_EMP_NM"     ,    PARAM_EMP_NM);
		paramMap.put("PARAM_SUPR_CD"    ,    PARAM_SUPR_CD);
		paramMap.put("PARAM_SUPR_NM"    ,    PARAM_SUPR_NM);
		paramMap.put("PARAM_CUS_TYPE"   ,    PARAM_CUS_TYPE);
		paramMap.put("PARAM_CUS_T_NM"   ,    PARAM_CUS_T_NM);
		paramMap.put("PARAM_FLAG"       ,    PARAM_FLAG);
		paramMap.put("PARAM_FLAG_NM"    ,    PARAM_FLAG_NM);		
		paramMap.put("OUT_CUST_CD"      ,    OUT_CUST_CD);		
		paramMap.put("PARAM_ROWNUM"     ,    PARAM_ROWNUM);		
		paramMap.put("PARAM_CUST_DIV_CD",    PARAM_CUST_DIV_CD);		
		paramMap.put("PARAM_GOODS_TYPE" ,    PARAM_GOODS_TYPE);		
		
		//logger.debug(" PARAM_LVL =>" + PARAM_LVL + " PARAM_CUSTMR_CD => " + PARAM_CUSTMR_CD + " PARAM_ROWNUM =>" + PARAM_ROWNUM);
		//logger.debug(" PARAM_GRUP_TOP_CD =>" + PARAM_GRUP_TOP_CD +" PARAM_GRUP_MID_CD =>" + PARAM_GRUP_MID_CD );
		//logger.debug(" PARAM_GRUP_BOT_CD =>" + PARAM_GRUP_BOT_CD +" PARAM_BCD_NM      =>" + PARAM_BCD_NM  );
		//logger.debug(" PARAM_ORGN_DIV_CD =>" + PARAM_ORGN_DIV_CD +" PARAM_ORGN_CD     =>" + PARAM_ORGN_CD );
		//logger.debug(" PARAM_CUST_DIV_CD =>" + PARAM_CUST_DIV_CD +" PARAM_FLAG        =>" + PARAM_FLAG  + " OUT_CUST_CD=>" + OUT_CUST_CD);
		
		List<Map<String, Object>> customList = orderInputGridPopupService.getSearchMasterBarcodeCustmrPriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	
	/**
	  * getSearchMasterBarcodeCustomerLowestPriceList -  거래처포털 센터주문 상품기준 최저 구매가격 가져오기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchMasterBarcodeCustomerLowestPriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchMasterBarcodeCustomerLowestPriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderPortalGridPopupController.java  getSearchMasterBarcodeCustomerLowestPriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_BCD_NM       = request.getParameter("PARAM_BCD_NM");
		String PARAM_ORGN_DIV_CD  = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD      = request.getParameter("PARAM_ORGN_CD");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_BCD_NM"     ,    "%"+PARAM_BCD_NM + "%");
		paramMap.put("PARAM_ORGN_DIV_CD",    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"    ,    PARAM_ORGN_CD);
		
		//logger.debug(" PARAM_BCD_NM =>" + PARAM_BCD_NM );
		
		List<Map<String, Object>> customList = orderInputGridPopupService.getSearchMasterBarcodeCustomerLowestPriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}	

	
	/**
	  * getReturnMasterBarcodeLowestPriceList -  거래처포털 교한반품 최저가 가져오기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getReturnMasterBarcodeLowestPriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getReturnMasterBarcodeLowestPriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderPortalGridPopupController.java  getReturnMasterBarcodeLowestPriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    
		String PARAM_ORD_CD     = request.getParameter("PARAM_ORD_CD");
		String PARAM_CUSTMR_CD  = request.getParameter("PARAM_CUSTMR_CD");
		String PARAM_BCD_NM     = request.getParameter("PARAM_BCD_NM");
		String PARAM_STR_DT     = request.getParameter("PARAM_STR_DT");
		String PARAM_END_DT     = request.getParameter("PARAM_END_DT");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORD_CD"    ,    PARAM_ORD_CD);
		paramMap.put("PARAM_CUSTMR_CD" ,    PARAM_CUSTMR_CD);
		paramMap.put("PARAM_BCD_NM"    ,    "%"+PARAM_BCD_NM + "%");		
		paramMap.put("PARAM_STR_DT"    ,    PARAM_STR_DT);
		paramMap.put("PARAM_END_DT"    ,    PARAM_END_DT);
		
		//logger.debug("PARAM_ORD_CD =>" + PARAM_ORD_CD + " PARAM_CUSTMR_CD =>" + PARAM_CUSTMR_CD );
		//logger.debug("PARAM_STR_DT =>" + PARAM_STR_DT + " PARAM_END_DT=> " +  PARAM_END_DT  + " PARAM_BCD_NM=> " +  PARAM_BCD_NM  );
		
		List<Map<String, Object>> customList = orderInputGridPopupService.getReturnMasterBarcodeLowestPriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}		
	
	/**
	  * getBanpumBarcodePriceList -  거래처포털 교한반품 최저가 가져오기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getBanpumBarcodePriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getBanpumBarcodePriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderPortalGridPopupController.java  getBanpumBarcodePriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    
		String PARAM_ORGN_CD    = request.getParameter("PARAM_ORGN_CD");
		String PARAM_BCD_NM     = request.getParameter("PARAM_BCD_NM");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORGN_CD" ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_BCD_NM"    ,    "%"+PARAM_BCD_NM + "%");		
		
		logger.debug("PARAM_ORGN_CD =>" + PARAM_ORGN_CD + " PARAM_BCD_NM=> " +  PARAM_BCD_NM  );
		
		List<Map<String, Object>> customList = orderInputGridPopupService.getBanpumBarcodePriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}				

	
	/**
	  * getBanpumMkBarcodePriceList - 직영점 센터반품건의 최저구매가격 가져오기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getBanpumMkBarcodePriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getBanpumMkBarcodePriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderPortalGridPopupController.java  getBanpumMkBarcodePriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    
		String PARAM_ORGN_CD    = request.getParameter("PARAM_ORGN_CD");
		String PARAM_CUSTMR_CD  = request.getParameter("PARAM_CUSTMR_CD");
		String PARAM_BCD_NM     = request.getParameter("PARAM_BCD_NM");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORGN_CD"   ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_CUSTMR_CD" ,   PARAM_CUSTMR_CD);
		paramMap.put("PARAM_BCD_NM"    ,    "%"+PARAM_BCD_NM + "%");		
		
		logger.debug("PARAM_ORGN_CD =>" + PARAM_ORGN_CD + " PARAM_CUSTMR_CD =>" + PARAM_CUSTMR_CD +  " PARAM_BCD_NM=> " +  PARAM_BCD_NM  );
		
		List<Map<String, Object>> customList = orderInputGridPopupService.getBanpumMkBarcodePriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}				

	/**
	  * getBanpumOutBarcodePriceList -   직발 반품건의 최저구매가격 가져오기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getBanpumOutBarcodePriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getBanpumOutBarcodePriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderPortalGridPopupController.java  getBanpumOutBarcodePriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    
		String PARAM_ORGN_CD    = request.getParameter("PARAM_ORGN_CD");
		String PARAM_CUSTMR_CD  = request.getParameter("PARAM_CUSTMR_CD");
		String PARAM_BCD_NM     = request.getParameter("PARAM_BCD_NM");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORGN_CD"   ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_CUSTMR_CD" ,   PARAM_CUSTMR_CD);
		paramMap.put("PARAM_BCD_NM"    ,    "%"+PARAM_BCD_NM + "%");		
		
		logger.debug("PARAM_ORGN_CD =>" + PARAM_ORGN_CD + " PARAM_CUSTMR_CD =>" + PARAM_CUSTMR_CD +  " PARAM_BCD_NM=> " +  PARAM_BCD_NM  );
		
		List<Map<String, Object>> customList = orderInputGridPopupService.getBanpumOutBarcodePriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}				
	
}
