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

import com.samyang.winplus.sis.order.service.OrderInputService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;
import java.util.Iterator;

@RequestMapping("/sis/order")
@RestController
public class OrderInputController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	OrderInputService orderInputService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/order"; // JSP경로


	/**
	  * OrderInputCUD - 발주서마스터/상품 C,U,D
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="OrderInputCUD.do", method=RequestMethod.POST)
	public Map<String, Object> OrderInputCUD(HttpServletRequest request, @RequestBody Map<String,Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap  = new HashMap<String, Object>();
		Map<String, Object> HeadMap    = new HashMap<String, Object>();
		
		int index        = 0;
		int ll_SUPR_AMT  = 0;
		int ll_VAT       = 0;
		int ll_SUM_AMT   = 0;
		
		int tot_SUPR_AMT = 0;
		int tot_VAT      = 0;
		int tot_SUM_AMT  = 0;
		String ls_Value1 = "";
		String ls_Value2 = "";
		String ls_Value3 = "";
		String ls_Value4 = "";
		String ls_Value5 = "";
		String ls_Value6 = "";
		String GS_ORGN_DIV_CD = "";
		String GS_ORGN_CD = "";
		
		
        EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();

		//logger.debug(" 1. 넘어온 파라미터 값 확인 "); 
		//logger.debug(  paramMap.toString()  );
        for (String mapkey : paramMap.keySet()){
    		//logger.debug("paramMap Key =>" + mapkey + " value =>" +paramMap.get(mapkey) );
        }    	
        
        //logger.debug(" 2. HEAD부분 Map To Map  변환 "); 
        HeadMap     = (Map<String,Object>) paramMap.get("HEAD");		
        HeadMap.put("REG_ID", emp_no);
	    
		String ls_deli_date =  (String) HeadMap.get("DELI_DATE");
		
		ls_deli_date  = ls_deli_date.replaceAll("-","");
		HeadMap.put("DELI_DATE", ls_deli_date);
		HeadMap.put("ORD_TITLE", "");        
        
        for (String mapkey : HeadMap.keySet()){
    		//logger.debug("Head temptMap  Key =>" + mapkey + " value =>" +HeadMap.get(mapkey) );
        }    	

        //logger.debug(" 3. 디테일 Map To LIST<Map>  변환 "); 
		List<Map<String, Object>> paramMapList = (List<Map<String,Object>>) paramMap.get("BODY");

        //logger.debug(" 3-1. 디테일 Map To LIST<Map>  변환 "); 
		
        /*  LIST<> 변환한값을  점검한다 */
		if(null != paramMapList && paramMapList.size() >0){
			
			for( Map<String, Object> temptMap2 : paramMapList){
	             index++;
	             //logger.debug("SUPR_AMT = "+temptMap2.get("SUPR_AMT")); 
	             Object tmpSUPR_AMT = temptMap2.get("SUPR_AMT");
	             Object tmpVAT = temptMap2.get("VAT");
	             Object tmpSUM_AMT = temptMap2.get("SUM_AMT");
	             
	             if(tmpSUPR_AMT instanceof String) {
		             ll_SUPR_AMT = Integer.parseInt((String) temptMap2.get("SUPR_AMT"));
		             ll_VAT      = Integer.parseInt((String) temptMap2.get("VAT"));
		             ll_SUM_AMT  = Integer.parseInt((String) temptMap2.get("SUM_AMT"));
	             }else {
		             ll_SUPR_AMT = (int) temptMap2.get("SUPR_AMT");
		             ll_VAT      = (int) temptMap2.get("VAT");
		             ll_SUM_AMT  = (int) temptMap2.get("SUM_AMT");
	             }
	             
	             /* List Array 첫번째 index에서 발주서 마스터로 INSERT OR UPDATE할 칼럼을 추출하여 HEAD MAP에  PUT한다 */
	             if ( index == 1)
	             {
	            	 
	            	 GS_ORGN_DIV_CD = (String) temptMap2.get("ORGN_DIV_CD");
	            	 GS_ORGN_CD     = (String) temptMap2.get("ORGN_CD");
	            	 ls_Value1      = (String) temptMap2.get("RETN_YN");
	            	 ls_Value2      = (String) temptMap2.get("RESN_CD");
	            	 ls_Value3      = (String) temptMap2.get("SEND_FAX_STATE");
	            	 ls_Value4      = (String) temptMap2.get("SEND_EMAIL_STATE");
	            	 ls_Value5      = (String) temptMap2.get("PRINT_STATE");
	            	 ls_Value6      = (String) temptMap2.get("ORD_CUSTMR");

	            	 HeadMap.put("OUT_WARE_CD"      , HeadMap.get("OUT_WARE_CD"));
	            	 HeadMap.put("ORD_TYPE"         , HeadMap.get("ORD_TYPE"));  /* 발주유형 1:발주, 2:주문 */
	            	 HeadMap.put("RETN_YN"          , ls_Value1);    /* 반품여부                */   
	            	 HeadMap.put("RESN_CD"          , ls_Value2);    /* 반품사유코드            */      	            	 
	            	 HeadMap.put("SEND_FAX_STATE"   , ls_Value3);    /* 펙스발송상태(여부)      */      	            	 
	            	 HeadMap.put("SEND_EMAIL_STATE" , ls_Value4);    /* Email발송상태(여부)     */      	            	 
	            	 HeadMap.put("PRINT_STATE"      , ls_Value5);    /* PRINT인쇄상태(여부)     */      	            	 
	            	 HeadMap.put("ORD_CUSTMR"       , ls_Value6);    /* 발행구분                */   
	            	 HeadMap.put("ORGN_DIV_CD"      , GS_ORGN_DIV_CD);    /* 발행구분            */   
	            	 HeadMap.put("ORGN_CD"          , GS_ORGN_CD);    /* 발행구분               */   
	             }

	             /* 발주서마스터에 기록하기위해 전제금액을 누적한다 */
	             tot_SUPR_AMT = tot_SUPR_AMT + ll_SUPR_AMT;
	             tot_VAT      = tot_VAT + ll_VAT;
	             tot_SUM_AMT  = tot_SUM_AMT + ll_SUM_AMT;
	             
	             //logger.debug(" ll_SUPR_AMT => " +  ll_SUPR_AMT + " ll_VAT => " +  ll_VAT + " ll_SUM_AMT => " +  ll_SUM_AMT );
	             temptMap2.put("REG_ID", emp_no);
	             
	            // LIST<> 의 각 칼럼들을 DISPLAY한다
				// for(Map.Entry<String, Object> entry: temptMap2.entrySet()){
				//      String key   = entry.getKey();
				//      Object value = entry.getValue();
				//      //temptMap2.put(key,value);
				//      //logger.debug(" 3-3. Index => " +  index + " key => " +  key + " value => " +  value );
			    //	 
				// }
			}
			
			HeadMap.put("SUPR_AMT", tot_SUPR_AMT);
			HeadMap.put("VAT"     , tot_VAT     );        
			HeadMap.put("TOT_AMT" , tot_SUM_AMT );        
		}
		
		
		for( Map<String, Object> temptMap2 : paramMapList){
            index++;
            // LIST<> 의 각 칼럼들을 DISPLAY한다
			 for(Map.Entry<String, Object> entry: temptMap2.entrySet()){
			      String key   = entry.getKey();
			      Object value = entry.getValue();
			      //temptMap2.put(key,value);
			      //logger.debug(" 3-3. Index => " +  index + " key => " +  key + " value => " +  value );
			 }
		}		

        //logger.debug(" 4. 최종 HEAD부분 출력  "); 
        for (String mapkey : HeadMap.keySet()){
    		//logger.debug("Head temptMap  Key =>" + mapkey + " value =>" +HeadMap.get(mapkey) );
        }    	
		
		Map<String, Object> returnMap =  orderInputService.saveTpurOrdGoodsScreenList(paramMapList, HeadMap);
		
		resultMap.put("resultRowCnt"    , returnMap.get("resultInt"));
		resultMap.put("resulOrderNumber", returnMap.get("resulOrderNumber"));
		
		return resultMap;
		
	}
		
	/**
	  * OrderInputCUD - 발주서마스터/상품 C,U,D
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="OrderStateUpdate.do", method=RequestMethod.POST)
	public Map<String, Object> OrderStateUpdate(HttpServletRequest request, @RequestBody Map<String,Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap  = new HashMap<String, Object>();
		
	    //logger.debug(" 1. 넘어온 파라미터 값 확인 "); 
	    //logger.debug(  paramMap.toString()  );
        for (String mapkey : paramMap.keySet()){
   		   //logger.debug("paramMap Key =>" + mapkey + " value =>" +paramMap.get(mapkey) );
        }    	
       
        //logger.debug(" 2. 디테일 Map To LIST<Map>  변환 "); 
	    List<Map<String, Object>> paramMapList = (List<Map<String,Object>>) paramMap.get("BODY");

		Map<String, Object> returnMap =  orderInputService.updateTpurOrdState(paramMapList);
		
		resultMap.put("resultRowCnt"    , returnMap.get("resultInt"));
		
		return resultMap;
		
	}
	
	/**
	  * getSearchMasterBarcodeList - 대.중.소 or 상품검색입력 조건을 바코드상품목록조회 
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchPdaOrderBarcodePriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchPdaOrderBarcodePriceList(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ OrderInputController.java  getSearchPdaOrderBarcodePriceList.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String PARAM_STR_YYYYMMDD = request.getParameter("PARAM_STR_YYYYMMDD");
		String PARAM_ORGN_DIV_CD  = request.getParameter("PARAM_ORGN_DIV_CD");
		String PARAM_ORGN_CD      = request.getParameter("PARAM_ORGN_CD");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("PARAM_STR_YYYYMMDD",    PARAM_STR_YYYYMMDD);
		paramMap.put("PARAM_ORGN_DIV_CD",     PARAM_ORGN_DIV_CD);
		paramMap.put("PARAM_ORGN_CD",         PARAM_ORGN_CD);
		//logger.debug("@@@@@@@@@@ PARAM_STR_YYYYMMDD ============" + PARAM_STR_YYYYMMDD);
		
		List<Map<String, Object>> customList = orderInputService.getSearchPdaOrderBarcodePriceList(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	
	
}
