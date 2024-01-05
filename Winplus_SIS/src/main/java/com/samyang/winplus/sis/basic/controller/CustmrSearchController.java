package com.samyang.winplus.sis.basic.controller;

import java.io.IOException;
import java.sql.SQLException;
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

import com.samyang.winplus.sis.basic.service.CustmrSearchService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;

@RequestMapping("/sis/basic")
@RestController
public class CustmrSearchController {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	CustmrSearchService custmrSearchService;
	
	@Autowired
	protected CommonUtil commonUtil;		
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/basic"; // JSP경로


	/**
	  * custmrSearch - 거래처관리 조회
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="custmrSearch.sis", method=RequestMethod.POST)
	public ModelAndView purChaseSearch(HttpServletRequest request) throws SQLException, Exception {
		logger.info("@@@@@@@@@@ CustmrSearchController.java  custmrSearch.sis ============");
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "custmrSearch");
		return mav;
	}

	/**
	  * custmrSearchR1 - 거래처LIST 조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="custmrSearchR1.do", method=RequestMethod.POST)
	public Map<String, Object> menuManagementR1(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ CustmrSearchController.java  custmrSearchR1.do ============");
 	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String search_val     = request.getParameter("SEARCH_VAL");
		String cmbORGN_DIV_CD = request.getParameter("cmbORGN_DIV_CD");
		String cmbORGN_CD     = request.getParameter("cmbORGN_CD");
        String cmbPartnerIO   = request.getParameter("cmbPartnerIO");
        String cmbPamentDay   = request.getParameter("cmbPamentDay");
        String cmbCUSTMR_GRUP = request.getParameter("cmbCUSTMR_GRUP");
        String cmbPartnerPART = request.getParameter("cmbPartnerPart");
        String cmbPartnerTYPE = request.getParameter("cmbPartnerType");
        String cmbYNCD        = request.getParameter("cmbYNCD");
        String cmbBANK_YN     = request.getParameter("cmbBANK_YN");
        
		//logger.debug("@@@@@@@@@@ cmbPartnerIO    ============" + cmbPartnerIO );
		//logger.debug("@@@@@@@@@@ cmbPamentDay    ============" + cmbPamentDay );
		//logger.debug("@@@@@@@@@@ cmbCUSTMR_GRUP  ============" + cmbCUSTMR_GRUP );
		//logger.debug("@@@@@@@@@@ cmbPartnerPART  ============" + cmbPartnerPART );
		//logger.debug("@@@@@@@@@@ cmbPartnerTYPE  ============" + cmbPartnerTYPE );
		//logger.debug("@@@@@@@@@@ cmbYNCD         ============" + cmbYNCD );
        
		if(search_val != null && search_val.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.authority.author_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("Query_value",    "%" + search_val+"%" );
			paramMap.put("cmbORGN_DIV_CD",   cmbORGN_DIV_CD);
			paramMap.put("cmbORGN_CD",   cmbORGN_CD);
			paramMap.put("cmbPartnerIO",   cmbPartnerIO);
			paramMap.put("cmbPamentDay",   cmbPamentDay);
			paramMap.put("cmbCUSTMR_GRUP", cmbCUSTMR_GRUP);
			paramMap.put("cmbPartnerPART", cmbPartnerPART);
			paramMap.put("cmbPartnerTYPE", cmbPartnerTYPE);
			paramMap.put("cmbYNCD"       , cmbYNCD);
			paramMap.put("cmbBANK_YN"       , cmbBANK_YN);
			
			List<Map<String, Object>> customList = custmrSearchService.getSearchCustmrList(paramMap);				
			resultMap.put("gridDataList", customList);
		}
		return resultMap;
	}


	/**
	  * custmrSearchPopup - 동일사업자번호 조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="custmrSearchPopup.do", method=RequestMethod.POST)
	public Map<String, Object> custmrSearchPopup(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
		//logger.debug("@@@@@@@@@@ CustmrSearchController.java  custmrSearchPopup.do ============");
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
        String CORP_NO   = request.getParameter("CORP_NO");
		//logger.debug("@@@@@@@@@@ CORP_NO    ============" + CORP_NO );
       
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("CORP_NO",   CORP_NO);
		List<Map<String, Object>> customList = custmrSearchService.getSearchCustomPopup(paramMap);				
		resultMap.put("gridDataList", customList);

		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws IOException
	 * @description 거래처 그룹 조회
	 */
	@ResponseBody
	@RequestMapping(value="getSearchCustmrGroupList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchCustmrGroupList(@RequestBody Map<String, String> paramMap) throws IOException {
		Map<String, Object> resultMap = new HashMap<String,Object>();

		List<Map<String, Object>> gridDataList = custmrSearchService.getSearchCustmrGroupList(paramMap);
		resultMap.put("gridDataList", gridDataList);	//DHTMLX 결과 리턴 사용
		
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 거래처 정보 로그 조회
	 */
	@ResponseBody
	@RequestMapping(value="getCustmrInfoLog.do", method=RequestMethod.POST)
	public Map<String, Object> getCustmrInfoLog(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("gridDataList", custmrSearchService.getCustmrInfoLog(paramMap));

		return resultMap;
	}
	
	/**
	  * 고객사구매가능상품관리 - 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getCustmrGoodsSearch.do", method=RequestMethod.POST)
	public Map<String, Object> getCustmrGoodsSearch(HttpServletRequest request, @RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> gridDataList = custmrSearchService.getCustmrGoodsSearch(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	
	/**
	  * 고객사구매가능상품관리 - 디테일조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getCustmrGoodsDetailSearch.do", method=RequestMethod.POST)
	public Map<String, Object> getCustmrGoodsDetailSearch(HttpServletRequest request, @RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> gridDataList = custmrSearchService.getCustmrGoodsDetailSearch(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	
	/**
	 * 고객사구매가능상품관리 - 상품저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="saveCustmrGoodsSearch.do", method=RequestMethod.POST)
	public Map<String, Object> saveCustmrGoodsSearch(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String ORGN_DIV_CD = empSessionDto.getOrgn_div_cd();
		String ORGN_CD = empSessionDto.getOrgn_cd();
		String USER = empSessionDto.getEmp_no();
		String PROGRM = "saveCustmrGoodsSearch";
		
		int insertResult = 0;
		int updateResult = 0;
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			paramMap = dhtmlxParamMapList.get(i);
			if(paramMap.get("CRUD").equals("C")) {
				paramMap.put("CPROGRM", PROGRM);
				paramMap.put("CUSER", USER);
				paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
				paramMap.put("ORGN_CD", ORGN_CD);
				
				insertResult = custmrSearchService.saveAddCustmrGoodsSearch(paramMap);
			}else if(paramMap.get("CRUD").equals("U")) {
				paramMap.put("MPROGRM", PROGRM);
				paramMap.put("MUSER", USER);
				
				updateResult = custmrSearchService.saveUpdateCustmrGoodsSearch(paramMap);
			}
		}
		return resultMap;
	}
}
