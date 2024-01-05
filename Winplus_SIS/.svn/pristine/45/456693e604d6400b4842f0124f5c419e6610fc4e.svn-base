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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.sis.order.service.OrderSearchService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;

@RequestMapping("/sis/order")
@RestController
public class orderSearhController {

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
	@RequestMapping(value="orderSearch.sis", method=RequestMethod.POST)
	public ModelAndView orderSearch(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ orderSearhController.java  orderSearch.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderSearch");
		return mav;
	}

	/**
	  * orderSearchR1 - 발주서조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="orderSearchR1.do", method=RequestMethod.POST)
	public Map<String, Object> menuManagementR1(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderSearhController.java  custmrSearchR1.do ============");
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
		String PARAM_ORD_STATE        = request.getParameter("PARAM_ORD_STATE");
		
		
		////logger.debug("@@@@@@@@@@ cmbPartnerIO    ============" + cmbPartnerIO );
		//logger.debug("@@@@@@@@@@ PARAM_ORGN_DIV_CD    ============" + PARAM_ORGN_DIV_CD );
		////logger.debug("@@@@@@@@@@ PARAM_ORGN_CD  ============" + PARAM_ORGN_CD );
		////logger.debug("@@@@@@@@@@ PARAM_ORD_STR_YYYYMMDD  ============" + PARAM_ORD_STR_YYYYMMDD );
		////logger.debug("@@@@@@@@@@ PARAM_END_STR_YYYYMMDD  ============" + PARAM_END_STR_YYYYMMDD );

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
		paramMap.put("PARAM_ORD_TYPE"        ,    "1");  /* 1:발주, 2:주문 */
		paramMap.put("PARAM_ORD_STATE"       ,    PARAM_ORD_STATE);
		
		List<Map<String, Object>> customList = orderSearchService.getSearchOrderList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}

	
	/**
	  * openOrderInputSearch - 발주서(입력/수정) 상세조회 
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="openOrderInputSearch.do", method=RequestMethod.POST)
	public Map<String, Object> openOrderInputSearch(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderSearhController.java  openOrderInputSearch.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_ORGN_DIV_CD = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD     = request.getParameter("PARAM_ORGN_CD");
		String PARAM_ORD_NO      = request.getParameter("PARAM_ORD_NO");
		String PARAM_ORD_TYPE    = request.getParameter("PARAM_ORD_TYPE");
		
		//logger.debug(" PARAM_ORGN_DIV_CD =>" + PARAM_ORGN_DIV_CD + " PARAM_ORGN_CD =>" + PARAM_ORGN_CD +" PARAM_ORD_NO =>" + PARAM_ORD_NO + "PARAM_ORD_TYPE=> "+PARAM_ORD_TYPE );
 
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORGN_DIV_CD"     ,    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"         ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_ORD_NO"          ,    PARAM_ORD_NO);
		/*
		paramMap.put("PARAM_ORD_TYPE"        ,    PARAM_ORD_TYPE);  /*
		2019-11-03 2로 보내다 보내지 않음
		 1:발주, 2:주문 
		*/
		
		List<Map<String, Object>> customList = orderSearchService.getSearchOrderDetailList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	
	/**
	  * getSearchOrderDetailListCopy - 발주서 복사용 상세조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchOrderDetailListCopy.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchOrderDetailListCopy(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderSearhController.java  openOrderInputSearch2.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_ORGN_DIV_CD = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD     = request.getParameter("PARAM_ORGN_CD");
		String PARAM_ORD_NO1     = request.getParameter("PARAM_ORD_NO1");
		String PARAM_ORD_NO2     = request.getParameter("PARAM_ORD_NO2");
		String PARAM_ORD_NO3     = request.getParameter("PARAM_ORD_NO3");
		String PARAM_ORD_NO4     = request.getParameter("PARAM_ORD_NO4");
		String PARAM_ORD_NO5     = request.getParameter("PARAM_ORD_NO5");
		String PARAM_ORD_TYP     = request.getParameter("PARAM_ORD_TYP");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("PARAM_ORGN_DIV_CD"     ,    PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD"         ,    PARAM_ORGN_CD);
		paramMap.put("PARAM_ORD_NO1"         ,    PARAM_ORD_NO1);
		paramMap.put("PARAM_ORD_NO2"         ,    PARAM_ORD_NO2);
		paramMap.put("PARAM_ORD_NO3"         ,    PARAM_ORD_NO3);
		paramMap.put("PARAM_ORD_NO4"         ,    PARAM_ORD_NO4);
		paramMap.put("PARAM_ORD_NO5"         ,    PARAM_ORD_NO5);
		paramMap.put("PARAM_ORD_TYPE"        ,    PARAM_ORD_TYP);  /* 1:발주, 2:주문 */
		//logger.debug(" PARAM_ORGN_DIV_CD =>" + PARAM_ORGN_DIV_CD + " PARAM_ORGN_CD =>" + PARAM_ORGN_CD + " PARAM_ORD_NO1 => " + PARAM_ORD_NO1 );
		
		List<Map<String, Object>> customList = orderSearchService.getSearchOrderDetailListCopy(paramMap);				
		resultMap.put("gridDataList", customList);
		return resultMap;
	}

	/**
	  * getOrderDeadTimeLeadTime - 협력사 주문마감시간 고려  leadetime일 구하기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getOrderDeadTimeLeadTime.do", method=RequestMethod.POST)
	public Map<String, Object> getOrderDeadTimeLeadTime(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderSearhController.java  getOrderDeadTimeLeadTime.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_CUSTMR_CD = request.getParameter("PARAM_CUSTMR_CD");
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_CUSTMR_CD"     , PARAM_CUSTMR_CD);
		//logger.debug("PARAM_CUSTMR_CD =>"  + PARAM_CUSTMR_CD );
		
		Map<String, Object> customList = orderSearchService.getOrderDeadTimeLeadTime(paramMap);				
		resultMap.put("gridDataList", customList);
		return resultMap;
	}	
	
	/**
	  * getBusinessDay -  leadtime일에 해당하는 영업일 구하기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getBusinessDay.do", method=RequestMethod.POST)
	public Map<String, Object> getBusinessDay(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderSearhController.java  getBusinessDay.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
			    
		String PARAM_LEAD_TIME = request.getParameter("PARAM_LEAD_TIME");
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_LEAD_TIME"     , PARAM_LEAD_TIME);
		//logger.debug("PARAM_LEAD_TIME =>"  + PARAM_LEAD_TIME );
		
		Map<String, Object> customList = orderSearchService.getBusinessDay(paramMap);				
		resultMap.put("gridDataList", customList);
		return resultMap;
	}	
	
	/**
	  * getLoginOrgInfo - getLoginOrgInfo
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getLoginOrgInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getLoginOrgInfo(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderSearhController.java  getLoginOrgInfo.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
        EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_EMP_NO"     , emp_no);
		//logger.debug("PARAM_EMP_NO =>"  + emp_no );
		
		Map<String, Object> customList = orderSearchService.getLoginOrgInfo(paramMap);				
		resultMap.put("gridDataList", customList);
		return resultMap;
	}		
	
	/**
	  * getOrderCloseTime - 현재시간 과 발주 마감시간을 구한다
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getOrderCloseTime.do", method=RequestMethod.POST)
	public Map<String, Object> getOrderCloseTime(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ orderSearhController.java  getOrderCloseTime.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
        EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_EMP_NO"     , emp_no);
		//logger.debug("PARAM_EMP_NO =>"  + emp_no );
		
		Map<String, Object> customList = orderSearchService.getOrderCloseTime(paramMap);				
		resultMap.put("gridDataList", customList);
		return resultMap;
	}			
	/**
	  * getSelectedOrgInfo - Combo박스에서 선택된 조직(부서)의 조직영역 구하기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSelectedOrgInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getSelectedOrgInfo(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {

		//logger.debug("@@@@@@@@@@ orderSearhController.java  getSelectedOrgInfo.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		String PARAM_ORGN_CD     = request.getParameter("PARAM_ORGN_CD");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_ORGN_CD"         ,    PARAM_ORGN_CD);

		Map<String, Object> customList = orderSearchService.getSelectedOrgInfo(paramMap);				
		resultMap.put("gridDataList", customList);
		return resultMap;
	}			
	
	/**
	 * @author 손경락
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 센타,공급사에서 취급및 취급점에서 주문가능한 상품list를 COMBO로 출력하기
	 */
	@RequestMapping(value="/getGoodsTreeComboList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsTreeComboList(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		Map <String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> detailCodeList = null;
		detailCodeList = orderSearchService.getGoodsTreeComboList(paramMap);
		resultMap.put("detailCodeList", detailCodeList);
		return resultMap;
	}	
	
	/**
	 * @author 손경락
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 센타,공급사에서 취급및 취급점에서 주문가능한 상품list를 TREE로 출력하기
	 */
	@RequestMapping(value="/getGoodsTreeList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsTreeList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {

		//logger.debug("@@@@@@@@@@ orderSearhController.java  getGoodsTreeList.do ============");

		Map<String, Object>  paramMap  = new HashMap<String, Object>();
		Map <String, Object> resultMap = new HashMap<String, Object>();
		String PARAM_ORGN_DIV_CD       =  request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_CUST_CD           =  request.getParameter("PARAM_CUST_CD");
		String PARAM_CUST_DIV_CD       =  request.getParameter("PARAM_CUST_DIV_CD");
		String PARAM_GOODS_TYPE        =  request.getParameter("PARAM_GOODS_TYPE");
		String OUT_CUST_CD             =  request.getParameter("OUT_CUST_CD");
		
		paramMap.put("PARAM_ORGN_DIV_CD" ,  PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_CUST_CD"     ,  PARAM_CUST_CD);
		paramMap.put("PARAM_CUST_DIV_CD" ,  PARAM_CUST_DIV_CD);
		paramMap.put("PARAM_GOODS_TYPE"  ,  PARAM_GOODS_TYPE);
		paramMap.put("OUT_CUST_CD"       ,  OUT_CUST_CD);
	
		//logger.debug("@@@@@@@@@@ PARAM_ORGN_DIV_CD " + PARAM_ORGN_DIV_CD + " PARAM_CUST_DIV_CD => " +PARAM_CUST_DIV_CD + " PARAM_GOODS_TYPE => " +PARAM_GOODS_TYPE+ " OUT_CUST_CD =>" + OUT_CUST_CD );
		Map<String, Object> allGoodsCategoryMap =  orderSearchService.getGoodsTreeList(paramMap);

		//logger.debug("@@@@@@@@@@ orderSearhController.java Step1  ============");
		
		List<Map<String, Object>> allGoodsCategoryMapList = null;
		if(allGoodsCategoryMap.containsKey("categoryTree")) {
			allGoodsCategoryMapList = (List<Map<String, Object>>) allGoodsCategoryMap.get("categoryTree");
			if(allGoodsCategoryMapList != null && !allGoodsCategoryMapList.isEmpty()){
				/* DhtmlxTree 에 맞추어 Result 데이터 재구성 */ 
				Map<String, Object> categoryTreeMap = new HashMap<String, Object>();
				/* 최상위 메뉴를 위한 Root 최상위 메뉴 설정 */
				List<Map<String, Object>> rootMapList = new ArrayList<Map<String, Object>>();
				Map<String, Object> rootMap = new HashMap<String, Object>();				
				
				rootMap.put("id", "ALL");
				rootMap.put("text", "전체분류");
				rootMap.put("item", allGoodsCategoryMapList);
				rootMapList.add(rootMap);
				
				categoryTreeMap.put("id", "0");
				categoryTreeMap.put("item", rootMapList);	
				resultMap.put("categoryTreeMap", categoryTreeMap);
				resultMap.put("categoryList", (List<Map<String, Object>>) allGoodsCategoryMap.get("categoryList"));
				//logger.debug("@@@@@@@@@@ orderSearhController.java Step2  ============");
				
			} else {				
				String errMesage = messageSource.getMessage("info.common.noDataSearch", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1001";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
			}
		} else {
			String errMesage = messageSource.getMessage("info.common.noDataSearch", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		}

		//logger.debug("@@@@@@@@@@ orderSearhController.java Step3  ============");

		return resultMap;		
		
	}	
	
	/**
	  * getGroupCdFromTreeID - TreeId를 기준으로 대중소 그룹코드를 구하기
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getGroupCdFromTreeID.do", method=RequestMethod.POST)
	public Map<String, Object> getGroupCdFromTreeID(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {

		//logger.debug("@@@@@@@@@@ orderSearhController.java  getSelectedOrgInfo.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		String PARAM_TREE_ID     = request.getParameter("PARAM_TREE_ID");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_TREE_ID"     ,    PARAM_TREE_ID);

		Map<String, Object> customList = orderSearchService.getGroupCdFromTreeID(paramMap);				
		resultMap.put("gridDataList", customList);
		return resultMap;
	}			
	
	
}
