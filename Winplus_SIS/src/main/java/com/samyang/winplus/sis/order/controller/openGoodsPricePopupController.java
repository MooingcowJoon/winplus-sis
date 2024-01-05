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

import com.samyang.winplus.sis.basic.service.CustmrSearchService;
import com.samyang.winplus.sis.basic.service.CustomerGoodsManagementService;
import com.samyang.winplus.sis.order.service.OrderInputGridPopupService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;


@RequestMapping("/sis/order")
@RestController
public class openGoodsPricePopupController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	CustmrSearchService custmrSearchService;
	
	@Autowired
	CustomerGoodsManagementService customerGoodsManagementService;
	
	@Autowired
	OrderInputGridPopupService orderInputGridPopupService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/order"; // JSP경로
	
	/**
	  * openGoodsPricePopup - 발주상품 팝업조회
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  * 
	  */
	@RequestMapping(value="openGoodsPricePopup.sis", method=RequestMethod.POST)
	public ModelAndView openGoodsPricePopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ openGoodsPricePopupController.java  openGoodsPricePopup.sis ============");
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openGoodsPricePopup");
		return mav;
	}
	
	
	/**
	  * openGoodsRetCsPopup - 반품상품 팝업조회( 취급점 전용)
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  * 
	  */
	@RequestMapping(value="openGoodsRetCsPopup.sis", method=RequestMethod.POST)
	public ModelAndView openGoodsRetCsPopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ openGoodsPricePopupController.java  openGoodsRetCsPopup.sis ============");
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openGoodsRetCsPopup");
		return mav;
	}
	
	/**
	  * openGoodsOutMkPopup - 반품상품 팝업조회( 센터/ 직영점 전용)
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  * 
	  */
	@RequestMapping(value="openGoodsOutMkPopup.sis", method=RequestMethod.POST)
	public ModelAndView openGoodsOutMkPopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ oopenGoodsOutMkPopuppenGoodsPricePopupController.java  openGoodsOutMkPopup.sis ============");
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openGoodsOutMkPopup");
		return mav;
	}
	

	/**
	  * openGoodsReturnPopup - 교환반품상품 팝업조회( 취급점 전용)
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  * 
	  */
	@RequestMapping(value="openGoodsReturnPopup.sis", method=RequestMethod.POST)
	public ModelAndView openGoodsReturnPopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ openGoodsPricePopupController.java  openGoodsReturnPopup.sis ============");
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openGoodsReturnPopup");
		return mav;
	}	
	
	/**
	  * getSearchMasterBarcodePriceList2 -  바코드상품목록조회(발주서 입력화면)
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchMasterBarcodePriceList2.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchMasterBarcodePriceList2(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ openGoodsPricePopupController.java  getSearchMasterBarcodePriceList2.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_BCD_NM       = request.getParameter("PARAM_BCD_NM");
		String PARAM_ORGN_DIV_CD  = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD      = request.getParameter("PARAM_ORGN_CD");
  
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_BCD_NM"     ,    "%"+PARAM_BCD_NM + "%");
		paramMap.put("PARAM_ORGN_DIV_CD",    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"    ,    PARAM_ORGN_CD);
		
		//logger.debug(" PARAM_BCD_NM =>" + PARAM_BCD_NM );
		
		List<Map<String, Object>> customList = customerGoodsManagementService.getSearchMasterBarcodePriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	
	
	/**
	  * openOrderInputSearch2 - 주문서복사용 주문서기준으로 현재 센터 최저가적용후 상품및 가격가져오기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchOrderDetailListCopy2.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchOrderDetailListCopy2(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderSearhController.java  openOrderInputSearch2.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_ORD_TYP     = request.getParameter("PARAM_ORD_TYP");
		
		String PARAM_ORGN_DIV_CD  = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD      = request.getParameter("PARAM_ORGN_CD");
		String PARAM_ORD_NO1     = request.getParameter("PARAM_ORD_NO1");
		String PARAM_ORD_NO2     = request.getParameter("PARAM_ORD_NO2");
		String PARAM_ORD_NO3     = request.getParameter("PARAM_ORD_NO3");
		String PARAM_ORD_NO4     = request.getParameter("PARAM_ORD_NO4");
		String PARAM_ORD_NO5     = request.getParameter("PARAM_ORD_NO5");
		String PARAM_CUSTMR_CD    = request.getParameter("PARAM_CUSTMR_CD");
		
		/* 이부분은 발주할 바코드대상정보를 가져올때  Host값을 전달후  발주영역그리드에 바로출력하기위함 */
		String PARAM_CUST_NM      = request.getParameter("PARAM_CUST_NM");       /* 고객사명        */
		String PARAM_ORD_NO       = request.getParameter("PARAM_ORD_NO");        /* 발주번호        */
		String PARAM_REQ_DATE     = request.getParameter("PARAM_REQ_DATE");      /* 발주일자        */
		String PARAM_RESP_USER    = request.getParameter("PARAM_RESP_USER");     /* 로그인(처리자)  */
		String PARAM_EMP_NM       = request.getParameter("PARAM_EMP_NM");        /* 처리자명        */
		String PARAM_SUPR_CD      = request.getParameter("PARAM_SUPR_CD");       /* 협력사코드        */
		String PARAM_SUPR_NM      = request.getParameter("PARAM_SUPR_NM");       /* 협력사명          */
		String PARAM_CUS_TYPE     = request.getParameter("PARAM_CUS_TYPE");      /* 발행구분          */
		String PARAM_CUS_T_NM     = request.getParameter("PARAM_CUS_T_NM");      /* 발행구분명          */
		String PARAM_FLAG         = request.getParameter("PARAM_FLAG");          /* 처리상태          */
		String PARAM_FLAG_NM      = request.getParameter("PARAM_FLAG_NM");       /* 처리상태명          */
	    String PARAM_ROWNUM       = request.getParameter("PARAM_ROWNUM");        /* BCD단위 가져올 수량  1이면 최저가  */
	    String PARAM_CUST_DIV_CD  = request.getParameter("PARAM_CUST_DIV_CD");   /* 발쥬유형 B01물류센타로의 주문, A06신선팜으로주문, OUT외부공급사  */
	    	    	    
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("PARAM_ORGN_DIV_CD",    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"    ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_ORD_NO1"    ,    PARAM_ORD_NO1);
		paramMap.put("PARAM_ORD_NO2"    ,    PARAM_ORD_NO2);
		paramMap.put("PARAM_ORD_NO3"    ,    PARAM_ORD_NO3);
		paramMap.put("PARAM_ORD_NO4"    ,    PARAM_ORD_NO4);
		paramMap.put("PARAM_ORD_NO5"    ,    PARAM_ORD_NO5);
		paramMap.put("PARAM_CUSTMR_CD"  ,    PARAM_CUSTMR_CD);
		
		paramMap.put("PARAM_CUST_NM"    ,    PARAM_CUST_NM);
		paramMap.put("PARAM_ORD_NO"     ,    PARAM_ORD_NO);
		paramMap.put("PARAM_REQ_DATE"   ,    PARAM_REQ_DATE);
		paramMap.put("PARAM_RESP_USER"  ,    PARAM_RESP_USER);
		paramMap.put("PARAM_EMP_NM"     ,    PARAM_EMP_NM);
		paramMap.put("PARAM_SUPR_CD"    ,    PARAM_SUPR_CD);
		paramMap.put("PARAM_SUPR_NM"    ,    PARAM_SUPR_NM);
		paramMap.put("PARAM_CUS_TYPE"   ,    PARAM_CUS_TYPE);
		paramMap.put("PARAM_CUS_T_NM"   ,    PARAM_CUS_T_NM);
		paramMap.put("PARAM_FLAG"       ,    PARAM_FLAG);
		paramMap.put("PARAM_FLAG_NM"    ,    PARAM_FLAG_NM);		
		paramMap.put("PARAM_ROWNUM"     ,    PARAM_ROWNUM);		
		paramMap.put("PARAM_CUST_DIV_CD",    PARAM_CUST_DIV_CD);		
		
		//logger.debug(" PARAM_ORGN_DIV_CD =>" + PARAM_ORGN_DIV_CD +" PARAM_ORGN_CD  =>" + PARAM_ORGN_CD );
		//logger.debug(" PARAM_ORD_NO1     =>" + PARAM_ORD_NO1     +" PARAM_ORD_NO2  =>" + PARAM_ORD_NO2 );
		//logger.debug(" PARAM_CUSTMR_CD   =>" + PARAM_CUSTMR_CD   +" PARAM_FLAG     =>" + PARAM_FLAG  );
		//logger.debug(" PARAM_CUST_DIV_CD =>" + PARAM_CUST_DIV_CD +" PARAM_ROWNUM   =>" + PARAM_ROWNUM  );
		
  	   List<Map<String, Object>> customList = orderInputGridPopupService.getSearchOrderDetailListCopy2(paramMap);				
		resultMap.put("gridDataList", customList);
		return resultMap;
	}	
	
	/**
	  * getSearchMasterBarcodeLowestPriceList -  상품기준 최저 구매가격 가져오기(발주서 입력화면)
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchMasterBarcodeLowestPriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchMasterBarcodeLowestPriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ openGoodsPricePopupController.java  getSearchMasterBarcodeLowestPriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_BCD_NM       = request.getParameter("PARAM_BCD_NM");
		String PARAM_ORGN_DIV_CD  = request.getParameter("PARAM_ORGN_DIV_CD");   /* 발주를 요청하는 조직구분 C03, Z01, Z02 */
		String PARAM_ORGN_CD      = request.getParameter("PARAM_ORGN_CD");       /* 발주를 요청하는 조직              */
		String PARAM_CUST_DIV_CD  = request.getParameter("PARAM_CUST_DIV_CD");   /* 협력사(공급사)  조직구분코드  B01:센터로발주, A06:팜으로발주, OUT:외부공급사로발주 */
		String PARAM_CUST_CD      = request.getParameter("PARAM_CUST_CD");       /* 협력사(공급사)코드                */
		String PARAM_ORD_TYPE     = request.getParameter("PARAM_ORD_TYPE");      /* 발주유형 1물류발주, 2직납발주, 3신선발주, 4착지변경, 5일배발주   */
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_BCD_NM"      ,    "%"+PARAM_BCD_NM + "%");
		paramMap.put("PARAM_ORGN_DIV_CD" ,    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"     ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_CUST_DIV_CD" ,    PARAM_CUST_DIV_CD);
		paramMap.put("PARAM_CUST_CD"     ,    PARAM_CUST_CD);
		paramMap.put("PARAM_ORD_TYPE"    ,    PARAM_ORD_TYPE);
		
		//logger.debug(" PARAM_ORGN_DIV_CD => " + PARAM_ORGN_DIV_CD + " PARAM_ORGN_CD=> " + PARAM_ORGN_CD + " PARAM_CUST_DIV_CD => "+ PARAM_CUST_DIV_CD + " PARAM_BCD_NM =>" + PARAM_BCD_NM );
		
		List<Map<String, Object>> customList = customerGoodsManagementService.getSearchMasterBarcodeLowestPriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
		
	/**
	  * getSearchMasterBarcodeFreshPriceList -  팜센터->협력사 발주시 최저구매가격 가져오기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchMasterBarcodeFreshPriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchMasterBarcodeFreshPriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ openGoodsPricePopupController.java  getSearchMasterBarcodeFreshPriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_BCD_NM       = request.getParameter("PARAM_BCD_NM");
		String PARAM_CUST_CD      = request.getParameter("PARAM_CUST_CD");       /* 협력사(공급사)코드                */
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_BCD_NM"      ,    "%"+PARAM_BCD_NM + "%");
		paramMap.put("PARAM_CUST_CD"     ,    PARAM_CUST_CD);
		
		//logger.debug(" PARAM_BCD_NM => " + PARAM_BCD_NM + " PARAM_CUST_CD=> " + PARAM_CUST_CD  );
		
		List<Map<String, Object>> customList = customerGoodsManagementService.getSearchMasterBarcodeFreshPriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}

}
