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
public class orderInputGridPopupController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	OrderInputGridPopupService orderInputGridPopupService;
	
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
	@RequestMapping(value="orderInputGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView orderInputGridPopup(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderInputGridPopupController.java  orderInputGridPopup.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderInputGridPopup");
		return mav;
	}
	
	/**
	  * getSearchMasterBarcodePriceList - 대.중.소 or 상품검색입력 조건을 바코드상품목록조회(발주서 입력화면)
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchMasterBarcodePriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchMasterBarcodePriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderInputGridPopupController.java  getSearchMasterBarcodePriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_GRUP_TOP_CD  = request.getParameter("PARAM_GRUP_TOP_CD");
		String PARAM_GRUP_MID_CD  = request.getParameter("PARAM_GRUP_MID_CD");
		String PARAM_GRUP_BOT_CD  = request.getParameter("PARAM_GRUP_BOT_CD");
		String PARAM_BCD_NM       = request.getParameter("PARAM_BCD_NM");
		String PARAM_ORGN_DIV_CD  = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_CUST_CD      = request.getParameter("PARAM_CUST_CD");
		String PARAM_ROWNUM       = request.getParameter("PARAM_ROWNUM");
		String PARAM_CUST_DIV_CD  = request.getParameter("PARAM_CUST_DIV_CD");  /* 협력사조직구분코드 */
		String PARAM_ORGN_CD      = request.getParameter("PARAM_ORGN_CD");      /* 발주를 요청하는조직  입고창고 */
  
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_GRUP_TOP_CD" ,  PARAM_GRUP_TOP_CD);
		paramMap.put("PARAM_GRUP_MID_CD" ,  PARAM_GRUP_MID_CD);
		paramMap.put("PARAM_GRUP_BOT_CD" ,  PARAM_GRUP_BOT_CD);
		paramMap.put("PARAM_BCD_NM"      ,  "%"+PARAM_BCD_NM + "%");
		paramMap.put("PARAM_ORGN_DIV_CD" ,  "B01" );               /* 직영점에서 호출하는경우 B01 */
		paramMap.put("PARAM_CUST_CD"   ,  PARAM_CUST_CD );
		paramMap.put("PARAM_GUBUN"       ,  "<" );
		paramMap.put("PARAM_ROWNUM"      ,  PARAM_ROWNUM );
		paramMap.put("PARAM_CUST_DIV_CD" ,  PARAM_CUST_DIV_CD );
		paramMap.put("PARAM_ORGN_CD"     ,  PARAM_ORGN_CD );
	
		//logger.debug(" PARAM_GRUP_TOP_CD =>" + PARAM_GRUP_TOP_CD +" PARAM_GRUP_MID_CD =>" + PARAM_GRUP_MID_CD + " PARAM_ORGN_DIV_CD => " + PARAM_ORGN_DIV_CD);
		//logger.debug(" PARAM_GRUP_BOT_CD =>" + PARAM_GRUP_BOT_CD +" PARAM_BCD_NM      =>" + PARAM_BCD_NM  + " PARAM_CUST_CD => " + PARAM_CUST_CD );
		//logger.debug(" PARAM_CUST_DIV_CD =>" + PARAM_CUST_DIV_CD );
		
		List<Map<String, Object>> customList = orderInputGridPopupService.getSearchMasterBarcodePriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}	
	
	/**
	  * getSearchPdaOrderBarcodePriceList -  1. 직영점 PDA로 발주요청건을 센터기준 발주일대비 최저판매가 적용하여 가저오기 
	  *                                      2. 센터 착지변경 2차발주 대상 및 최저가 가져오기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchPDAOrderBarcodePriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchPdaOrderBarcodePriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderInputGridPopupController.java  getSearchPDAOrderBarcodePriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
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
	    String PARAM_CUST_DIV_CD  = request.getParameter("PARAM_CUST_DIV_CD");   /* 발쥬유형 B01물류센타로의 주문, A06신선팜으로주문, OUT외부공급사  */
	    String PARAM_CHANNEL      = request.getParameter("PARAM_CHANNEL");       /* load체널 1PDA, 2착지변경 */
	    String PARAM_SLT_ORD_NO   = request.getParameter("PARAM_SLT_ORD_NO");   /* 원거래 발주번호     */
	    String PARAM_ROWNUM       = request.getParameter("PARAM_ROWNUM");        /* BCD 단위로 가져올 ROW수*/
	    
		Map<String, Object> paramMap = new HashMap<String, Object>();
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
		paramMap.put("PARAM_CUST_DIV_CD",    PARAM_CUST_DIV_CD);		
		paramMap.put("PARAM_SLT_ORD_NO" ,    PARAM_SLT_ORD_NO);		
		paramMap.put("PARAM_ROWNUM"     ,    PARAM_ROWNUM);		
		
		//logger.debug(" PARAM_CUSTMR_CD => " + PARAM_CUSTMR_CD + " PARAM_ROWNUM =>" + PARAM_ROWNUM);
		//logger.debug(" PARAM_ORGN_DIV_CD =>" + PARAM_ORGN_DIV_CD +" PARAM_ORGN_CD     =>" + PARAM_ORGN_CD );
		//logger.debug(" PARAM_CUST_DIV_CD =>" + PARAM_CUST_DIV_CD +" PARAM_FLAG        =>" + PARAM_FLAG );
		//logger.debug(" PARAM_CHANNEL     =>" + PARAM_CHANNEL +    " PARAM_SLT_ORD_NO  =>" + PARAM_SLT_ORD_NO );

        /*  PDA 불러오기 */
		if(PARAM_CHANNEL.equals("1")){
			List<Map<String, Object>> customList1 = orderInputGridPopupService.getSearchPdaOrderBarcodePriceList(paramMap);				
			resultMap.put("gridDataList", customList1);
		}
		else 
		{   /* 착지변경 및 일배발주 */
			List<Map<String, Object>> customList2 = orderInputGridPopupService.getSearchCHGOrderBarcodePriceList(paramMap);				
			resultMap.put("gridDataList", customList2);
		}
		
		return resultMap;
	}
	
	/**
	  * SP_WMS_SEND_ORD_SALE -  발주관련(발주유형 전체)  입/출고 예정정보를 WMS로 전송한다( 인수인계 문서 WMS인터페이스 참조)
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="SP_WMS_SEND_ORD_SALE.do", method=RequestMethod.POST)
	public Map<String, Object> SP_WMS_SEND_ORD_SALE(HttpServletRequest request, @RequestBody Map<String,Object> paramMap) throws SQLException, Exception {
		
		logger.debug("@@@@@@@@@@ orderInputGridPopupController.java  SP_WMS_SEND_ORD_SALE.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    
	    List<Map<String, Object>> paramMapList = (List<Map<String,Object>>) paramMap.get("BODY");
		
		Map<String, Object> returnMap =  orderInputGridPopupService.SP_WMS_SEND_ORD_SALE(paramMapList);
		resultMap.put("resultRowCnt"    , returnMap.get("resultInt"));
		
		return resultMap;
	}			

	
	/**
	  * SP_WMS_SEND_ONLINE_ORD -   발주(주문)관리  입고예정 정보를 WMS로 전송한다
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="SP_WMS_SEND_ONLINE_ORD.do", method=RequestMethod.POST)
	public Map<String, Object> SP_WMS_SEND_ONLINE_ORD(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		
		//logger.debug("@@@@@@@@@@ orderPortalGridPopupController.java  SP_WMS_SEND_ONLINE_ORD.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    
		String PARAM_DATE    = request.getParameter("PARAM_DATE");
		String PARAM_ORD_NO  = request.getParameter("PARAM_ORD_NO");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_DATE"   ,    PARAM_DATE);
		paramMap.put("PARAM_ORD_NO" ,   PARAM_ORD_NO);
		
		logger.debug("PARAM_DATE =>" + PARAM_DATE + " PARAM_ORD_NO =>" + PARAM_ORD_NO    );
		int resultRowCnt = 0;
		
		resultRowCnt = orderInputGridPopupService.SP_WMS_SEND_ONLINE_ORD(paramMap);	
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}				
	
}