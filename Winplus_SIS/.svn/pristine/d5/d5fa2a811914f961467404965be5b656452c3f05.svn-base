package com.samyang.winplus.common.popup.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.popup.service.CommonPopupService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;


@RestController
@RequestMapping("/common/popup")
public class CommonPopupController extends BaseController {
	
	@Autowired
	CommonPopupService commonPopupService;
	
	private final Logger logger = LoggerFactory.getLogger(CommonPopupController.class);
	
	private final static String DEFAULT_PATH = "common/popup";
	
	
	/**
	  * xlsUploadPopup - 팝업 - 엑셀업로드 팝업
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "xlsUploadPopup.sis", method=RequestMethod.POST)
	public ModelAndView xlsUploadPopup(HttpServletRequest request, @RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
//		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapListHeader(request);
		mav.addObject("paramMap", paramMap);
		mav.setViewName(DEFAULT_PATH + "/" + "xlsUploadPopup");
		return mav;
	}
	
	/**
	  * searchEmployeePopup - 팝업 - 자재 조회 팝업
	  * @author 박성호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchMtrlPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchMtrlPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String mtrlNm = request.getParameter("MTRL_NM");
		String rpstMtrlYn = request.getParameter("RPST_MTRL_YN");
		String recipe = request.getParameter("RECIPE");
		//logger.debug("RECIPE"+recipe);
		mav.addObject("MTRL_NM", mtrlNm);
		mav.addObject("RPST_MTRL_YN", rpstMtrlYn);
		mav.addObject("RECIPE", recipe);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();

		List<Map<String, Object>> mtrlList = commonPopupService.searchMtrlPopup(paramMap);
		mav.addObject("MTRL_CD_LIST", mtrlList);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchMtrlPopup");
		return mav;
	}

	/**
	  * searchMtrlPopupR1 - 팝업 - 자재 조회 팝업
	  * @author 박성호
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "searchMtrlPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchMtrlPopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String mtrlNm = request.getParameter("MTRL_NM");
		String rpstMtrlYn = request.getParameter("RPST_MTRL_YN");
		String recipe = request.getParameter("RECIPE");
		
		paramMap.put("MTRL_NM", mtrlNm);
		paramMap.put("RPST_MTRL_YN", rpstMtrlYn);
		paramMap.put("RECIPE", recipe);

		List<Map<String, Object>> mtrlList = commonPopupService.searchMtrlPopup(paramMap);	
		
		mtrlNm = "";
		String mtrlCd = "";
		
		if(mtrlList.size() == 1){
			mtrlCd = (String) mtrlList.get(0).get("MTRL_CD");
			mtrlNm = (String) mtrlList.get(0).get("MTRL_NM");
		}
		paramMap.put("MTRL_CD", mtrlCd);
		paramMap.put("MTRL_NM", mtrlNm);
						
		paramMap.put("gridDataList", mtrlList);
		
		return paramMap;
	}
	
	/**
	  * searchMtrlPricePopup - 팝업 - 자재 조회 팝업
	  * @author bumseok.oh
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchMtrlPricePopup.sis", method=RequestMethod.POST)
	public ModelAndView searchMtrlPricePopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String mtrlNm = request.getParameter("MTRL_NM");
		String rpstMtrlYn = request.getParameter("RPST_MTRL_YN");
		
		mav.addObject("MTRL_NM", mtrlNm);
		mav.addObject("RPST_MTRL_YN", rpstMtrlYn);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();

		List<Map<String, Object>> mtrlList = commonPopupService.searchMtrlPricePopup(paramMap);
		mav.addObject("MTRL_CD_LIST", mtrlList);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchMtrlPricePopup");
		return mav;
	}
	
	/**
	  * searchMtrlPricePopupR1 - 팝업 - 자재(가격) 조회 팝업
	  * @author bumseok.oh
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "searchMtrlPricePopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchMtrlPricePopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String mtrlNm = request.getParameter("MTRL_NM");
		String rpstMtrlYn = request.getParameter("RPST_MTRL_YN");
		
		paramMap.put("MTRL_NM", mtrlNm);
		paramMap.put("RPST_MTRL_YN", rpstMtrlYn);

		List<Map<String, Object>> mtrlList = commonPopupService.searchMtrlPricePopup(paramMap);	
		
		mtrlNm = "";
		String mtrlCd = "";
		
		if(mtrlList.size() == 1){
			mtrlCd = (String) mtrlList.get(0).get("MTRL_CD");
			mtrlNm = (String) mtrlList.get(0).get("MTRL_NM");
		}
		paramMap.put("MTRL_CD", mtrlCd);
		paramMap.put("MTRL_NM", mtrlNm);
						
		paramMap.put("gridDataList", mtrlList);
		
		return paramMap;
	}

	/**
	  * searchMtrlAvgModPopup - 팝업 - 자재별 평균단가 변경이력 팝업
	  * @author 박성호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchMtrlAvgModPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchMtrlAvgModPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String mtrlCd = request.getParameter("MTRL_CD");
		String stndMon = request.getParameter("STND_MON");
		String orgnCd = request.getParameter("ORGN_CD");
		
		mav.addObject("MTRL_CD", mtrlCd);
		mav.addObject("STND_MON", stndMon);
		mav.addObject("ORGN_CD", orgnCd);
		mav.setViewName(DEFAULT_PATH + "/" + "searchMtrlAvgModPopup");
		return mav;
	}

	/**
	  * searchMtrlAvgModPopupR1 - 팝업 - 자재별 평균단가 변경이력 팝업
	  * @author 박성호
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "searchMtrlAvgModPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchMtrlAvgModPopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String mtrlCd = request.getParameter("MTRL_CD");
		String stndMon = request.getParameter("STND_MON");
		String orgnCd = request.getParameter("ORGN_CD");
		
		paramMap.put("MTRL_CD", mtrlCd);
		paramMap.put("STND_MON", stndMon);
		paramMap.put("ORGN_CD", orgnCd);
		
		List<Map<String, Object>> mtrlList = commonPopupService.searchMtrlAvgModPopup(paramMap);	
		
		mtrlCd = "";
						
		paramMap.put("gridDataList", mtrlList);
		
		return paramMap;
	}
	
	/**
	  * searchInputPricePopup - 팝업 - 자재 입력단가 상세조회 팝업
	  * @author 박성호
	  * @param request
	  * @return ModelAndView
	  */
	
	@RequestMapping(value = "searchInputPricePopup.sis", method=RequestMethod.POST)
	public ModelAndView searchInputPricePopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String mtrlCd = request.getParameter("MTRL_CD");
		
		mav.addObject("MTRL_CD", mtrlCd);
		mav.setViewName(DEFAULT_PATH + "/" + "searchInputPricePopup");
		return mav;
	}

	@RequestMapping(value = "searchInputPricePopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchInputPricePopupR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String mtrlCd = request.getParameter("MTRL_CD");
		
		paramMap.put("MTRL_CD", mtrlCd);

		List<Map<String, Object>> mtrlList = commonPopupService.searchInputPricePopup(paramMap);	
		
		mtrlCd = "";
						
		paramMap.put("gridDataList", mtrlList);
		
		return paramMap;
	}

	/**
	  * searchCstmInfoPopup - 팝업 - 자재 입고단가 상세조회 팝업
	  * @author 박성호
	  * @param request
	  * @return ModelAndView
	  */
	
	@RequestMapping(value = "searchCstmInfoPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchCstmInfoPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String cstmCd = request.getParameter("CSTM_CD");
		String mtrlCd = request.getParameter("MTRL_CD");
		
		mav.addObject("MTRL_CD", mtrlCd);
		mav.addObject("CSTM_CD", cstmCd);
		mav.setViewName(DEFAULT_PATH + "/" + "searchCstmInfoPopup");
		return mav;
	}

	@RequestMapping(value = "searchCstmInfoPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchCstmInfoPopupR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String cstmCd = request.getParameter("CSTM_CD");
		String mtrlCd = request.getParameter("MTRL_CD");
		
		paramMap.put("MTRL_CD", mtrlCd);
		paramMap.put("CSTM_CD", cstmCd);

		List<Map<String, Object>> mtrlList = commonPopupService.searchCstmInfoPopup(paramMap);	
		mtrlCd = "";
		cstmCd = "";
						
		paramMap.put("gridDataList", mtrlList);
		
		return paramMap;
	}
	
	/**
	  * searchEmployeePopup - 팝업 - 상품 조회 팝업
	  * @author 주병훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchPrdcPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchPrdcPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String ARTICLE_NAME = request.getParameter("ARTICLE_NAME");
		/*String prdcTime = request.getParameter("PRDC_TIME");*/
		
		mav.addObject("ARTICLE_NAME", ARTICLE_NAME);	
		/*mav.addObject("PRDC_TIME", prdcTime);*/
		
		Map<String, Object> paramMap = new HashMap<String, Object>();

		List<Map<String, Object>> prdcCdList = commonPopupService.searchPrdcPopup(paramMap);
		mav.addObject("PRDC_CD_LIST", prdcCdList);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchPrdcPopup");
		return mav;
	}
		
	/**
	  * searchEmployeePopup - 팝업 - 상품 조회 팝업
	  * @author 주병훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "searchPrdcPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchPrdcPopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String ARTICLE_NAME = request.getParameter("ARTICLE_NAME");
		String PRDC_CD = request.getParameter("PRDC_CD");
		/*String prdcTime = request.getParameter("PRDC_TIME");*/
		
		paramMap.put("ARTICLE_NAME", ARTICLE_NAME);
		paramMap.put("PRDC_CD", PRDC_CD);
		/*paramMap.put("PRDC_TIME", prdcTime);*/

		List<Map<String, Object>> prdcCdList = commonPopupService.searchPrdcPopup(paramMap);	
		
		ARTICLE_NAME = "";
		PRDC_CD = "";
		
		if(prdcCdList.size() == 1){
			PRDC_CD = (String) prdcCdList.get(0).get("PRDC_CD");
			ARTICLE_NAME = (String) prdcCdList.get(0).get("ARTICLE_NAME");
		}
		paramMap.put("PRDC_CD", PRDC_CD);
		paramMap.put("ARTICLE_NAME", ARTICLE_NAME);
						
		paramMap.put("gridDataList", prdcCdList);
		
		return paramMap;
	}
	
	/**
	  * searchPrdcSessionPopup - 팝업 - 상품 조회 팝업
	  * @author 정인선
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchPrdcSessionPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchPrdcSessionPopup(HttpServletRequest request) throws SQLException, Exception {
		/*EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);*/
		
		ModelAndView mav = new ModelAndView();
		String ARTICLE_NAME = request.getParameter("ARTICLE_NAME");
		//String prdcTime = request.getParameter("PRDC_TIME");
		
		mav.addObject("ARTICLE_NAME", ARTICLE_NAME);	
		/*mav.addObject("PRDC_TIME", "PD0001");*/
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		/*paramMap.put("FAC_CD", empSessionDto.getDept_cd());*/

		List<Map<String, Object>> prdcCdList = commonPopupService.searchPrdcSessionPopup(paramMap);
		mav.addObject("PRDC_CD_LIST", prdcCdList);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchPrdcSessionPopup");
		return mav;
	}
	
	/**
	  * searchEmployeePopup - 팝업 - 상품 조회 팝업
	  * @author 주병훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "searchPrdcSessionPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchPrdcSessionPopupR1(HttpServletRequest request) throws SQLException, Exception {
		/*EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);*/
		
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String ARTICLE_NAME = request.getParameter("ARTICLE_NAME");
		String ARTICLE_CODE = request.getParameter("ARTICLE_CODE");
		/*String prdcTime = request.getParameter("PRDC_TIME");*/
		
		paramMap.put("ARTICLE_NAME", ARTICLE_NAME);
		paramMap.put("ARTICLE_CODE", ARTICLE_CODE);
		/*paramMap.put("PRDC_TIME", prdcTime);
		paramMap.put("FAC_CD", empSessionDto.getDept_cd());*/

		List<Map<String, Object>> prdcCdList = commonPopupService.searchPrdcSessionPopup(paramMap);	
		
		ARTICLE_NAME = "";
		ARTICLE_CODE = "";
		
		if(prdcCdList.size() == 1){
			ARTICLE_CODE = (String) prdcCdList.get(0).get("ARTICLE_CODE");
			ARTICLE_NAME = (String) prdcCdList.get(0).get("ARTICLE_NAME");
		}
		paramMap.put("ARTICLE_CODE", ARTICLE_CODE);
		paramMap.put("ARTICLE_NAME", ARTICLE_NAME);
						
		paramMap.put("gridDataList", prdcCdList);
		
		return paramMap;
	}
	
	/**
	  * searchPrdcTimePopup - 팝업 - [제품별표준생산시간관리]에서 제품명 검색 팝업
	  * @author 유가영
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchPrdcTimePopup.sis", method=RequestMethod.POST)
	public ModelAndView searchPrdcTimePopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String ARTICLE_NAME = request.getParameter("ARTICLE_NAME");
		/*String prdcTime = request.getParameter("PRDC_TIME");*/
		
		mav.addObject("ARTICLE_NAME", ARTICLE_NAME);	
		/*mav.addObject("PRDC_TIME", prdcTime);*/
		
		//Map<String, Object> paramMap = new HashMap<String, Object>();
		//List<Map<String, Object>> prdcCdList = commonPopupService.searchPrdcPopup(paramMap);
		//mav.addObject("PRDC_CD_LIST", prdcCdList);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchPrdcTimePopup");
		return mav;
	}
	
	/**
	  * searchPrdcTimePopupR1 - 팝업 - 조회 버튼을 눌렀을때
	  * @author 유가영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "searchPrdcTimePopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchPrdcTimePopupR1(HttpServletRequest request) throws SQLException, Exception {

		Map<String, Object> paramMap = new HashMap<String, Object>();
		String ARTICLE_NAME = request.getParameter("ARTICLE_NAME");
		/*String prdcTime = request.getParameter("PRDC_TIME");*/
		
		paramMap.put("ARTICLE_NAME", ARTICLE_NAME);
		/*paramMap.put("PRDC_TIME", prdcTime);*/

		List<Map<String, Object>> prdcCdList = commonPopupService.searchPrdcTimePopup(paramMap);	
		
		ARTICLE_NAME = "";
		
		if(prdcCdList.size() == 1){
			ARTICLE_NAME = (String) prdcCdList.get(0).get("ARTICLE_NAME");
		}
		paramMap.put("ARTICLE_NAME", ARTICLE_NAME);
						
		paramMap.put("gridDataList", prdcCdList);
		
		return paramMap;
	}
	
	
	
	/**
	  * searchEmployeePopup - 팝업 - 레시피 조회 팝업
	  * @author 주병훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "searchRecipePopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchRecipePopupR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String recipeNm = request.getParameter("RECIPE_NM");
		String noAcc = request.getParameter("NO_ACC");
		
		String recipeCd = "";
		
		paramMap.put("RECIPE_NM", recipeNm);
		paramMap.put("NO_ACC", noAcc);

		List<Map<String, Object>> recipeCdList = commonPopupService.searchRecipePopup(paramMap);	
		
		recipeNm = "";
		
		if(recipeCdList.size() == 1){
			recipeCd = (String) recipeCdList.get(0).get("RECIPE_CD");
			recipeNm = (String) recipeCdList.get(0).get("RECIPE_NM");
		}
		paramMap.put("RECIPE_CD", recipeCd);
		paramMap.put("RECIPE_NM", recipeNm);
						
		paramMap.put("gridDataList", recipeCdList);
		
		return paramMap;
	}
	
	/**
	  * mtrlDetailPopup - 팝업 - 자재상세정보 조회 팝업
	  * @author 박성호
	  * @param request
	  * @return ModelAndView
	  */
	
	@RequestMapping(value = "searchMtrlDetailPopup.sis", method=RequestMethod.POST)
	public ModelAndView MtrlDetailPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String mtrlCd = request.getParameter("MTRL_CD");
		mav.addObject("MTRL_CD", mtrlCd);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchMtrlDetailPopup");
		return mav;
	}

	@RequestMapping(value = "searchMtrlDetailPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchMtrlDetailPopupR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String mtrlCd = request.getParameter("MTRL_CD");
		
		paramMap.put("MTRL_CD", mtrlCd);

		Map<String, Object> mtrlMap = commonPopupService.searchMtrlDetailPopup(paramMap);	
						
		paramMap.put("dataMap", mtrlMap);
		
		return paramMap;
	}
	
	@RequestMapping(value = "searchCstmPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchCstmPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String cstmNm = request.getParameter("CSTM_NM");
		if(cstmNm == null || "".equals(cstmNm)){
			cstmNm = "";
		}
		mav.addObject("CSTM_NM", cstmNm);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchCstmPopup");
		return mav;
	}
	
	@RequestMapping(value = "searchCstmPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchCstmPopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String cstmNm = request.getParameter("CSTM_NM");
		String cstmCd = request.getParameter("CSTM_CD");
		
		paramMap.put("CSTM_NM", cstmNm);
		paramMap.put("CSTM_CD", cstmCd);

		List<Map<String, Object>> dlvBsnList = commonPopupService.searchCstmPopup(paramMap);	
		
		cstmNm = "";
		cstmCd = "";
		
		if(dlvBsnList.size() == 1){
			cstmNm = (String) dlvBsnList.get(0).get("CSTM_NM");
			cstmCd = (String) dlvBsnList.get(0).get("CSTM_CD");
		}
		paramMap.put("CSTM_NM", cstmNm);
		paramMap.put("CSTM_CD", cstmCd);
						
		paramMap.put("gridDataList", dlvBsnList);
		
		return paramMap;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 납품업체코드 목록 조회 팝업
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : searchDlvBsnPopup
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "searchDlvBsnPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchDlvBsnPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();

		String dlvBsnNm = request.getParameter("DLV_BSN_NM");
		String dlvBsnCd = request.getParameter("DLV_BSN_NM");
		String mtrlCd = request.getParameter("MTRL_CD");
		String mtrlYn = request.getParameter("MTRL_YN");
		String orgnDivCd = request.getParameter("ORGN_DIV_CD");
		

		mav.addObject("DLV_BSN_NM", dlvBsnNm);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("DLV_BSN_CD", dlvBsnCd);
		paramMap.put("DLV_BSN_NM", dlvBsnNm);
		paramMap.put("MTRL_CD", mtrlCd);
		paramMap.put("MTRL_YN", mtrlYn);
		paramMap.put("ORGN_DIV_CD", orgnDivCd);
		
		List<Map<String, Object>> dlvBsnList = commonPopupService.searchDlvBsnPopup(paramMap);
		mav.addObject("DLV_BSN_CD_LIST", dlvBsnList);
		mav.addObject("DLV_BSN_CD", dlvBsnCd);
		mav.addObject("DLV_BSN_NM", dlvBsnNm);
		mav.addObject("MTRL_CD", mtrlCd);
		mav.addObject("MTRL_YN", mtrlYn);
		mav.addObject("ORGN_DIV_CD", orgnDivCd);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchDlvBsnPopup");
		return mav;
	}

	/**
	 * <pre>
	 * 1. 개요 : 납품업체 코드 조회
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : searchDlvBsnPopupR1
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "searchDlvBsnPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchDlvBsnPopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String dlvBsnNm = request.getParameter("DLV_BSN_NM");
		String dlvBsnCd = request.getParameter("DLV_BSN_CD");
		String orgnDivCd = request.getParameter("ORGN_DIV_CD");
		
		
		String mtrlCd = request.getParameter("MTRL_CD");
		String mtrlYn = request.getParameter("MTRL_YN");
		
		paramMap.put("DLV_BSN_NM", dlvBsnNm);
		paramMap.put("DLV_BSN_CD", dlvBsnCd);
		paramMap.put("ORGN_DIV_CD", orgnDivCd);
		
		paramMap.put("MTRL_CD", mtrlCd);
		paramMap.put("MTRL_YN", mtrlYn);

		List<Map<String, Object>> dlvBsnList = commonPopupService.searchDlvBsnPopup(paramMap);	
		
		dlvBsnNm = "";
		dlvBsnCd = "";
		
		if(dlvBsnList.size() == 1){
			dlvBsnCd = (String) dlvBsnList.get(0).get("DLV_BSN_CD");
			dlvBsnNm = (String) dlvBsnList.get(0).get("DLV_BSN_NM");
		}
		paramMap.put("DLV_BSN_CD", dlvBsnCd);
		paramMap.put("DLV_BSN_NM", dlvBsnNm);
						
		paramMap.put("gridDataList", dlvBsnList);
		
		return paramMap;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 납품업체코드 목록 조회 팝업
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : searchDlvBsnPricePopup
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 * @author bumseok.oh
	 */
	@RequestMapping(value = "searchDlvBsnPricePopup.sis", method=RequestMethod.POST)
	public ModelAndView searchDlvBsnPricePopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		
		String dlvBsnNm = request.getParameter("DLV_BSN_NM");
		
		String dlvBsnCd = request.getParameter("DLV_BSN_NM");
		String mtrlCd = request.getParameter("MTRL_CD");
		String mtrlYn = request.getParameter("MTRL_YN");
		mav.addObject("DLV_BSN_NM", dlvBsnNm);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("DLV_BSN_CD", dlvBsnCd);
		paramMap.put("DLV_BSN_NM", dlvBsnNm);
		paramMap.put("MTRL_CD", mtrlCd);
		paramMap.put("MTRL_YN", mtrlYn);
		
		List<Map<String, Object>> dlvBsnList = commonPopupService.searchDlvBsnPricePopup(paramMap);
		mav.addObject("DLV_BSN_CD_LIST", dlvBsnList);
		mav.addObject("DLV_BSN_CD", dlvBsnCd);
		mav.addObject("DLV_BSN_NM", dlvBsnNm);
		mav.addObject("MTRL_CD", mtrlCd);
		mav.addObject("MTRL_YN", mtrlYn);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchDlvBsnPricePopup");
		return mav;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 납품업체 코드 조회
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : searchDlvBsnPricePopupR1
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 * @author bumseok.oh
	 */
	@RequestMapping(value = "searchDlvBsnPricePopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchDlvBsnPricePopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String dlvBsnNm = request.getParameter("DLV_BSN_NM");
		String dlvBsnCd = request.getParameter("DLV_BSN_CD");
		
		String mtrlCd = request.getParameter("MTRL_CD");
		String mtrlYn = request.getParameter("MTRL_YN");
		
		paramMap.put("DLV_BSN_NM", dlvBsnNm);
		paramMap.put("DLV_BSN_CD", dlvBsnCd);
		
		paramMap.put("MTRL_CD", mtrlCd);
		paramMap.put("MTRL_YN", mtrlYn);

		List<Map<String, Object>> dlvBsnList = commonPopupService.searchDlvBsnPricePopup(paramMap);	
		
		dlvBsnNm = "";
		dlvBsnCd = "";
		
		if(dlvBsnList.size() == 1){
			dlvBsnCd = (String) dlvBsnList.get(0).get("DLV_BSN_CD");
			dlvBsnNm = (String) dlvBsnList.get(0).get("DLV_BSN_NM");
		}
		paramMap.put("DLV_BSN_CD", dlvBsnCd);
		paramMap.put("DLV_BSN_NM", dlvBsnNm);
						
		paramMap.put("gridDataList", dlvBsnList);
		
		return paramMap;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 자재별 납품업체코드 목록 조회 팝업
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : searchCstmByMtrlPopup
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "searchCstmByMtrlPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchCstmByMtrlPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String mtrlNm = request.getParameter("MTRL_NM");
		mav.addObject("MTRL_NM", mtrlNm);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("MTRL_NM", mtrlNm);
		
		List<Map<String, Object>> cstmByMtrlList = commonPopupService.searchCstmByMtrlPopup(paramMap);
		mav.addObject("CSTM_BY_MTRL_LIST", cstmByMtrlList);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchCstmByMtrlPopup");
		return mav;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 자재별 납품업체 코드 조회
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : searchCstmByMtrlPopupR1
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "searchCstmByMtrlPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchCstmByMtrlPopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String mtrlNm = request.getParameter("MTRL_NM");
		
		paramMap.put("MTRL_NM", mtrlNm);

		List<Map<String, Object>> cstmByMtrlList = commonPopupService.searchDlvBsnPopup(paramMap);	
		
		mtrlNm = "";
		
		if(cstmByMtrlList.size() == 1){
			mtrlNm = (String) cstmByMtrlList.get(0).get("MTRL_NM");
		}
		paramMap.put("MTRL_NM", mtrlNm);
						
		paramMap.put("gridDataList", cstmByMtrlList);
		
		return paramMap;
	}
	/**
	  * searchEmployeePopup - 팝업 - 공장/파트너사 조회 팝업
	  * @author 김동현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchFacPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchFacPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String facDvis = request.getParameter("DLV_BSN_DIV_CD");
		String facNm = request.getParameter("FAC_NM");

		mav.addObject("DLV_BSN_DIV_CD", facDvis);		
		mav.addObject("FAC_NM", facNm);		
		
//		Map<String, Object> paramMap = new HashMap<String, Object>();
//
//		List<Map<String, Object>> faclList = commonPopupService.searchFacPopup(paramMap);
//		mav.addObject("FAC_NM_LIST", faclList);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchFacPopup");
		return mav;
	}
	
	/**
	  * searchEmployeePopup - 팝업 - 공장/파트너사 조회 팝업
	  * @author 김동현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "searchFacPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchFacPopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String facDvis = request.getParameter("DLV_BSN_DIV_CD");
		String facCd = request.getParameter("FAC_CD");
		String facNm = request.getParameter("FAC_NM");
		
		paramMap.put("DLV_BSN_DIV_CD", facDvis);
		paramMap.put("FAC_CD", facCd);
		paramMap.put("FAC_NM", facNm);

		List<Map<String, Object>> facList = commonPopupService.searchFacPopup(paramMap);				
		
		facCd = "";
		
		if(facList.size() == 1){
			facCd = (String) facList.get(0).get("FAC_CD");
			facNm = (String) facList.get(0).get("FAC_NM");
		}
		paramMap.put("FAC_CD", facCd);
		paramMap.put("FAC_NM", facNm);
						
		paramMap.put("gridDataList", facList);
		
		return paramMap;
	}
	
	/**
	  * searchOrgnPopup - 팝업 - 조직 조회 팝업
	  * @author 주병훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchOrgnPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchOrgnPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String orgnNm = request.getParameter("ORGN_NM");
		String orgnDivCd = request.getParameter("ORGN_DIV_CD");
		
		mav.addObject("ORGN_NM", orgnNm);		
		mav.addObject("ORGN_DIV_CD", orgnDivCd);		
		
		
//		Map<String, Object> paramMap = new HashMap<String, Object>();
//
//		List<Map<String, Object>> faclList = commonPopupService.searchFacPopup(paramMap);
//		mav.addObject("FAC_CD_LIST", faclList);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchOrgnPopup");
		return mav;
	}
	
	/**
	  * getOrgnPopup - 조직 목록 조회
	  * @author 주병훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getOrgnPopup.do", method=RequestMethod.POST)
	public Map<String, Object> menuManagementR1(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String orgnCd = request.getParameter("ORGN_CD");
		String orgnNm = request.getParameter("ORGN_NM");
		String orgndivCd = request.getParameter("ORGN_DIV_CD");
		
		paramMap.put("ORGN_CD", orgnCd);
		paramMap.put("ORGN_NM", orgnNm);
		paramMap.put("ORGN_DIV_CD", orgndivCd);	

		List<Map<String, Object>> orgnList = commonPopupService.getOrgnPopup(paramMap);	
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("gridDataList", orgnList);
		
		return resultMap;
	}

	/**
	 * <pre>
	 * 1. 개요 :레시피 코드 목록 조회 팝업
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : searchRecipePopup
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "searchRecipePopup.sis", method=RequestMethod.POST)
	public ModelAndView searchRecipePopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String recipeNm = request.getParameter("RECIPE_NM");
		String noAcc = request.getParameter("NO_ACC");
		
		mav.addObject("RECIPE_NM", recipeNm);
		mav.addObject("NO_ACC", noAcc);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("RECIPE_NM", recipeNm);
		paramMap.put("NO_ACC", noAcc);
		
		List<Map<String, Object>> recipeList = commonPopupService.searchRecipePopup(paramMap);
		mav.addObject("RECIPE_NM_LIST", recipeList);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchRecipePopup");
		return mav;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 상/제품카테고리 기준카테고리 선택팝업
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : openStndCtgrPopup
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "searchStndCtgrPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchStndCtgrPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String stndCtgrNm = request.getParameter("STND_CTGR_NM");
		if(stndCtgrNm == null || "".equals(stndCtgrNm)){
			stndCtgrNm = "";
		}
		String stndCtgrDiv = request.getParameter("STND_CTGR_DIV");
		mav.addObject("STND_CTGR_DIV", stndCtgrDiv);
		mav.addObject("STND_CTGR_NM", stndCtgrNm);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("STND_CTGR_DIV", stndCtgrDiv);
		paramMap.put("STND_CTGR_NM", stndCtgrNm);
		
		List<Map<String, Object>> stndCtgrList = commonPopupService.searchStndCtgrPopup(paramMap);
		mav.addObject("STND_CTGR_LIST", stndCtgrList);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchStndCtgrPopup");
		return mav;
	}
	
	@RequestMapping(value = "searchStndCtgrPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchStndCtgrPopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String stndCtgrDiv = request.getParameter("STND_CTGR_DIV");
		String stndCtgrNm = request.getParameter("STND_CTGR_NM");
		
		paramMap.put("STND_CTGR_DIV", stndCtgrDiv);
		paramMap.put("STND_CTGR_NM", stndCtgrNm);

		List<Map<String, Object>> stndCtgrList = commonPopupService.searchStndCtgrPopup(paramMap);	
		
		stndCtgrDiv = "";
		stndCtgrNm = "";
		
		if(stndCtgrList.size() == 1){
			stndCtgrDiv = (String) stndCtgrList.get(0).get("STND_CTGR_DIV");
			stndCtgrNm = (String) stndCtgrList.get(0).get("STND_CTGR_NM");
		}
		paramMap.put("STND_CTGR_DIV", stndCtgrDiv);
		paramMap.put("STND_CTGR_NM", stndCtgrNm);
						
		paramMap.put("gridDataList", stndCtgrList);
		
		return paramMap;
	}
	/**
	 * <pre>
	 * 1. 개요 : 상/제품카테고리 소분류카테고리 선택팝업
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : searchDtlCtgrPopup
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "searchDtlCtgrPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchDtlCtgrPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String srhDtlCtgrNm = request.getParameter("DTL_CTGR_NM");
		if(srhDtlCtgrNm == null || "".equals(srhDtlCtgrNm)){
			srhDtlCtgrNm = "";
		}
		String stndCtgrCd = request.getParameter("STND_CTGR_CD");
		mav.addObject("STND_CTGR_CD", stndCtgrCd);
		mav.addObject("DTL_CTGR_NM", srhDtlCtgrNm);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("STND_CTGR_CD", stndCtgrCd);
		paramMap.put("DTL_CTGR_NM", srhDtlCtgrNm);
		
		List<Map<String, Object>> dtlCtgrList = commonPopupService.searchDtlCtgrPopup(paramMap);
		mav.addObject("STND_CTGR_LIST", dtlCtgrList);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchDtlCtgrPopup");
		return mav;
	}
	
	@RequestMapping(value = "searchDtlCtgrPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchDtlCtgrPopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String srhDtlCtgrNm = request.getParameter("DTL_CTGR_NM");
		String stndCtgrCd = request.getParameter("STND_CTGR_CD");
		
		paramMap.put("DTL_CTGR_NM", srhDtlCtgrNm);
		paramMap.put("STND_CTGR_CD", stndCtgrCd);

		List<Map<String, Object>> dtlCtgrList = commonPopupService.searchDtlCtgrPopup(paramMap);	
		
		srhDtlCtgrNm = "";
		
		if(dtlCtgrList.size() == 1){
			srhDtlCtgrNm = (String) dtlCtgrList.get(0).get("DTL_CTGR_NM");
		}
		paramMap.put("DTL_CTGR_NM", srhDtlCtgrNm);
						
		paramMap.put("gridDataList", dtlCtgrList);
		
		return paramMap;
	}
	
	/**
	  * searchEmployeePopup - 팝업 - 사용자 조회 팝업
	  * @author 주병훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchEmpPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchEmpPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String empNm = request.getParameter("EMP_NM");
		
		mav.addObject("EMP_NM", empNm);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchEmpPopup");
		return mav;
	}
	
	@RequestMapping(value = "searchEmpPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchEmpPopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String empNm = request.getParameter("EMP_NM");
		
		paramMap.put("EMP_NM", empNm);

		List<Map<String, Object>> empList = commonPopupService.searchEmpPopup(paramMap);	
		
		empNm = "";
		
		if(empList.size() == 1){
			empNm = (String) empList.get(0).get("EMP_NM");
		}
		paramMap.put("EMP_NM", empNm);
						
		paramMap.put("gridDataList", empList);
		
		return paramMap;
	}
	
	/**
	  * searchEmployeePopup - 팝업 - 사용자 로그인 추가 조회 팝업
	  * @author 주병훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchEmpLoginAddListPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchEmpLoginAddListPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String empNo = request.getParameter("EMP_NO");
		
		mav.addObject("EMP_NO", empNo);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchEmpLoginAddListPopup");
		return mav;
	}
	
	@RequestMapping(value = "searchEmpLoginAddListPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchEmpLoginAddListPopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		
		
		//String empNo = empSessionDto.getEmp_no();
		//paramMap.put("EMP_NO", empNo);
		
		String emp_no_oriz =  empSessionDto.getEmp_no_oriz();
		paramMap.put("EMP_NO_ORIZ", emp_no_oriz);

		List<Map<String, Object>> empList = commonPopupService.searchEmpLoginAddListPopup(paramMap);	
						
		paramMap.put("gridDataList", empList);
		
		return paramMap;
	}
	
	/**
	  * searchPrdcProcessPopup - 팝업 - 상제품 가공비 조회 팝업
	  * @author 주병훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchPrdcProcessPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchPrdcProcessPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String prdcNm = request.getParameter("PRDC_NM");
		
		mav.addObject("PRDC_NM", prdcNm);	
		
		Map<String, Object> paramMap = new HashMap<String, Object>();

		List<Map<String, Object>> prdcCdList = commonPopupService.searchPrdcProcessPopup(paramMap);
		mav.addObject("PRDC_CD_LIST", prdcCdList);
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchPrdcProcessPopup");
		return mav;
	}
		
	/**
	  * searchPrdcProcessPopup - 팝업 - 상제품 가공비 조회 팝업
	  * @author 주병훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "searchPrdcProcessPopupR1.do", method=RequestMethod.POST)
	public Map<String, Object> searchPrdcProcessPopupR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String prdcNm = request.getParameter("PRDC_NM");
		String prdcCd = request.getParameter("PRDC_CD");
		
		paramMap.put("PRDC_NM", prdcNm);
		paramMap.put("PRDC_CD", prdcCd);

		List<Map<String, Object>> prdcCdList = commonPopupService.searchPrdcProcessPopup(paramMap);	
		
		prdcNm = "";
		prdcCd = "";
		
		if(prdcCdList.size() == 1){
			prdcCd = (String) prdcCdList.get(0).get("PRDC_CD");
			prdcNm = (String) prdcCdList.get(0).get("PRDC_NM");
		}
		paramMap.put("PRDC_CD", prdcCd);
		paramMap.put("PRDC_NM", prdcNm);
						
		paramMap.put("gridDataList", prdcCdList);
		
		return paramMap;
	}
	
	/**
	  * openSearchDeliProcPopup - 택배발송처리 - 상세팝업 
	  * @author mi
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchDeliProcPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchDeliProcPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Map<String, Object> deli_detail = new HashMap<String, Object>();
		
		String strORDER_DCIDX = request.getParameter("ORDER_DCIDX");

		paramMap.put("ORDER_DCIDX", strORDER_DCIDX);
		
		deli_detail = commonPopupService.getOpenSearchDeliProcPopup(paramMap);
		deli_detail.put("CRUD", "U");
		
		request.setAttribute("Deli_Detail", deli_detail);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchDeliProcPopup");
		return mav;
	}
	
	/**
	  * openCallHistoryPopup - 팝업 - 통화 기록 팝업
	  * @author 김동현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openCallHistoryPopup.sis", method=RequestMethod.POST)
	public ModelAndView openCallHistoryPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String CUSTOMER_SCCODE = request.getParameter("CUSTOMER_SCCODE");
		
		mav.addObject("CUSTOMER_SCCODE", CUSTOMER_SCCODE);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openCallHistoryPopup");
		return mav;
	}
	
	/**
	  * searchCallHistoryPopupList - 팝업 - 통화 기록 list 조회
	  * @author 김동현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "searchCallHistoryPopupList.do", method=RequestMethod.POST)
	public Map<String, Object> searchCallHistoryPopupList(HttpServletRequest request) throws SQLException, Exception {				
		String CUSTOMER_SCCODE = request.getParameter("CUSTOMER_SCCODE");
		int tableCode = request.getParameter("tableCode") == null ? 0 : Integer.parseInt(request.getParameter("tableCode"));
		int pagenum_s = request.getParameter("pagenum_s") == null ? 0 : Integer.parseInt(request.getParameter("pagenum_s"));
		int pagenum_e = request.getParameter("pagenum_e") == null ? 0 : Integer.parseInt(request.getParameter("pagenum_e"));
		String type = request.getParameter("type");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("CUSTOMER_SCCODE", CUSTOMER_SCCODE);
		paramMap.put("tableCode", tableCode);
		paramMap.put("pagenum_s", pagenum_s);
		paramMap.put("pagenum_e", pagenum_e);
		paramMap.put("type", type);

		
		List<Map<String, Object>> prdcCdList = commonPopupService.searchCallHistoryPopup(paramMap);	
		
		paramMap.put("gridDataList", prdcCdList);
		return paramMap;
	}
	
	/**
	  * openSamplePopup - 팝업 - 샘플 팝업
	  * @author 김동현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSamplePopup.sis", method=RequestMethod.POST)
	public ModelAndView openSamplePopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String CUSTOMER_SCCODE = request.getParameter("CUSTOMER_SCCODE");
		
		mav.addObject("CUSTOMER_SCCODE", CUSTOMER_SCCODE);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSamplePopup");
		return mav;
	}
	
	/**
	  * openSamplePopupList - 팝업 - 샘플 list 조회
	  * @author 김동현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "openSamplePopupList.do", method=RequestMethod.POST)
	public Map<String, Object> openSamplePopupList(HttpServletRequest request) throws SQLException, Exception {				
		String CUSTOMER_SCCODE = request.getParameter("CUSTOMER_SCCODE");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("CUSTOMER_SCCODE", CUSTOMER_SCCODE);

		List<Map<String, Object>> prdcCdList = commonPopupService.getOpenSamplePopupList(paramMap);	
		paramMap.put("gridDataList", prdcCdList);
		return paramMap;
	}
	
	/**
	  * acceptDaySumManagementPopup -택배발송처리 - 상세팝업 
	  * @author 박성호
	  * @param request
	  * @return ModelAndView
	  */
	
	@RequestMapping(value = "acceptDaySumManagementPopup.sis", method=RequestMethod.POST)
	public ModelAndView acceptDaySumManagementPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String strSTR_DT = request.getParameter("strSTR_DT") == null ? "" : request.getParameter("strSTR_DT");
		String strEND_DT = request.getParameter("strEND_DT") == null ? "" : request.getParameter("strEND_DT");
		
		String strBUSINESS_INF = request.getParameter("strBUSINESS_INF") == null ? "" : request.getParameter("strBUSINESS_INF");	 
		String strORDER_DSENDWAY = request.getParameter("strORDER_DSENDWAY") == null ? "" : request.getParameter("strORDER_DSENDWAY");	 
		String strORDER_DSENDWAY2 = request.getParameter("strORDER_DSENDWAY2") == null ? "" : request.getParameter("strORDER_DSENDWAY2");	 
		String strSEACH_GUBUN = request.getParameter("strSEACH_GUBUN") == null ? "" : request.getParameter("strSEACH_GUBUN");	 
		String strORDER_PRO = request.getParameter("strORDER_PRO") == null ? "" : request.getParameter("strORDER_PRO");	 
		
		mav.addObject("strSTR_DT", strSTR_DT);
		mav.addObject("strEND_DT", strEND_DT);

		mav.addObject("strBUSINESS_INF", strBUSINESS_INF);
		mav.addObject("strORDER_DSENDWAY", strORDER_DSENDWAY);
		mav.addObject("strORDER_DSENDWAY2", strORDER_DSENDWAY2);
		mav.addObject("strSEACH_GUBUN", strSEACH_GUBUN);
		mav.addObject("strORDER_PRO", strORDER_PRO);
		
		/*System.out.println("strORDER_DSENDWAY >>> " + strORDER_DSENDWAY);
		System.out.println("strORDER_DSENDWAY2 >>> " + strORDER_DSENDWAY2);
		System.out.println("strSEACH_GUBUN >>> " + strSEACH_GUBUN);
		System.out.println("strORDER_PRO >>> " + strORDER_PRO);
		*/
		
		mav.setViewName(DEFAULT_PATH + "/" + "acceptDaySumManagementPopup");
		return mav;
	}

	
	/**
	  * openSearchDeliProcPopup - 택배발송처리 - 상세팝업 리스트 
	  * @author mi
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "acceptDaySumManagementPopupList.do", method=RequestMethod.POST)
	public Map<String, Object> acceptDaySumManagementPopupList(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String strSTR_DT = request.getParameter("strSTR_DT") == null ? "" : request.getParameter("strSTR_DT");
		String strEND_DT = request.getParameter("strEND_DT") == null ? "" : request.getParameter("strEND_DT");
		
		String strBUSINESS_INF = request.getParameter("strBUSINESS_INF") == null ? "" : request.getParameter("strBUSINESS_INF");	 
		String strORDER_DSENDWAY = request.getParameter("strORDER_DSENDWAY") == null ? "" : request.getParameter("strORDER_DSENDWAY");	 
		String strORDER_DSENDWAY2 = request.getParameter("strORDER_DSENDWAY2") == null ? "" : request.getParameter("strORDER_DSENDWAY2");	 
		String strSEACH_GUBUN = request.getParameter("strSEACH_GUBUN") == null ? "" : request.getParameter("strSEACH_GUBUN");	 
		String strORDER_PRO = request.getParameter("strORDER_PRO") == null ? "" : request.getParameter("strORDER_PRO");	 
		
		paramMap.put("BUSINESS_INF", strBUSINESS_INF);
		paramMap.put("STR_DT", strSTR_DT);
		paramMap.put("END_DT", strEND_DT);
		paramMap.put("ORDER_DSENDWAY", strORDER_DSENDWAY);  
		paramMap.put("ORDER_DSENDWAY2", strORDER_DSENDWAY2);
		paramMap.put("SEACH_GUBUN", strSEACH_GUBUN);  
		paramMap.put("ORDER_PRO", strORDER_PRO);  
		
		paramMap.put("CRUD", "U");
	try{ 
		List<Map<String, Object>> sumList = commonPopupService.getAcceptDaySumManagementPopup(paramMap);
		resultMap.put("gridDataList", sumList);
		
	}catch(SQLException e){
		resultMap = commonUtil.getErrorMap(e);
	}catch(Exception e){
		resultMap = commonUtil.getErrorMap(e);
	}
	
	return resultMap;
	}
	

	/**
	  * resourcesBuyRegisterPopup - 자재매입 - 자재매입등록 
	  * @author mi
	  * @param request
	  * @return ModelAndView
	  */
	
	@RequestMapping(value = "resourcesBuyRegisterPopup.sis", method=RequestMethod.POST)
	public ModelAndView resourcesBuyRegisterPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Map<String, Object> deli_detail = new HashMap<String, Object>();
		
		String strSUBUL_IDX = request.getParameter("strSUBUL_IDX") == null ? "" : request.getParameter("strSUBUL_IDX");
		String strDT = request.getParameter("strDT") == null ? "" : request.getParameter("strDT");
		//String strMemberWarea = request.getParameter("strMemberWarea") == null ? "" : request.getParameter("strMemberWarea");
		String strSubulName = request.getParameter("strSubulName") == null ? "" : request.getParameter("strSubulName");
		
		paramMap.put("SUBUL_IDX", strSUBUL_IDX);
		
		if(!strSUBUL_IDX.equals("")){
			deli_detail = commonPopupService.getResourcesBuyRegisterPopup(paramMap);
		}else{
			deli_detail.put("Subul_Idx"  , strSUBUL_IDX);
			deli_detail.put("Subul_Date" , strDT);
			deli_detail.put("Subul_BCode", strSubulName);
			deli_detail.put("Subul_ACode", "");
			deli_detail.put("SuBul_AOCode" , "");
			deli_detail.put("SuBul_INQa" , "");
			deli_detail.put("Subul_OUTQa", "");
			deli_detail.put("Subul_Cost", "");
			deli_detail.put("Subul_Amount", "");
			deli_detail.put("Subul_Pay", "");
			deli_detail.put("Subul_DPrice", "");
			deli_detail.put("Subul_Memo", "");
			deli_detail.put("Subul_Memo1", "");
			deli_detail.put("Subul_MCode", "");
			deli_detail.put("Subul_RDate", "");
			deli_detail.put("Subul_CHK", "");
			deli_detail.put("Subul_EDate", "");
			deli_detail.put("Subul_Com", "");
		}

		deli_detail.put("CRUD", "U");
		
		request.setAttribute("Detail", deli_detail);
		
		mav.setViewName(DEFAULT_PATH + "/" + "resourcesBuyRegisterPopup");
		return mav;
	}

	/**
	  * searchPostAddrPopup - 팝업 - 우편번호, 주소 조회 팝업
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchPostAddrPopup.sis", method=RequestMethod.POST)
	public ModelAndView searchPostAddrPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "searchPostAddrPopup");
		return mav;
	}
	
	/**
	  * DeliveryAllProPopup - 팝업 - 택배 샘플 일괄처리 
	  * @author mi
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "DeliveryAllProPopup.sis", method=RequestMethod.POST)
	public ModelAndView DeliveryAllProPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "DeliveryAllProPopup");
		return mav;
	}
	
	/**
	  * openSamplePopup - 팝업 - 샘플 팝업
	  * @author 김동현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openUnknownPopup.sis", method=RequestMethod.POST)
	public ModelAndView openUnknownPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode");
		
		mav.addObject("custCode", custCode);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openUnknownPopup");
		return mav;
	}
	
	/**
	  * openSamplePopup - 팝업 - 샘플 팝업
	  * @author 김동현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openReturnRequestPopup.sis", method=RequestMethod.POST)
	public ModelAndView openReturnRequestPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		String customerMCode = request.getParameter("customerMCode") == null ? "" : request.getParameter("customerMCode");
		String customerWArea = request.getParameter("customerWArea") == null ? "" : request.getParameter("customerWArea");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Map<String, Object> deli_detail = new HashMap<String, Object>();
		
		paramMap.put("custCode", custCode);
		
		if(!custCode.equals("")){
			deli_detail = commonPopupService.getReturnRequestDetail(paramMap);
		}
		
		mav.addObject("custCode", custCode);
		mav.addObject("customerMCode", customerMCode);
		mav.addObject("customerWArea", customerWArea);
		mav.addObject("deli_detail", deli_detail);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openReturnRequestPopup");
		return mav;
	}
	
	/**
	  * openCallRecordPopup - 팝업 - 샘플 팝업
	  * @author 김동현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openCallRecordPopup.sis", method=RequestMethod.POST)
	public ModelAndView openCallRecordPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		String custNm = request.getParameter("custNm") == null ? "" : request.getParameter("custNm");
		String customerMCode = request.getParameter("customerMCode") == null ? "" : request.getParameter("customerMCode");
		String customerWArea = request.getParameter("customerWArea") == null ? "" : request.getParameter("customerWArea");
		
		mav.addObject("custCode", custCode);
		mav.addObject("custNm", custNm);
		mav.addObject("customerMCode", customerMCode);
		mav.addObject("customerWArea", customerWArea);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openCallRecordPopup");
		return mav;
	}
	
	/**
	  * openVOCClaimPopup - 팝업 - 샘플 팝업
	  * @author 김동현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openVOCClaimPopup.sis", method=RequestMethod.POST)
	public ModelAndView openVOCClaimPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		String custNm = request.getParameter("custNm") == null ? "" : request.getParameter("custNm");
		String customerMCode = request.getParameter("customerMCode") == null ? "" : request.getParameter("customerMCode");
		String customerWArea = request.getParameter("customerWArea") == null ? "" : request.getParameter("customerWArea");
		
		mav.addObject("custCode", custCode);
		mav.addObject("custNm", custNm);
		mav.addObject("customerMCode", customerMCode);
		mav.addObject("customerWArea", customerWArea);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openVOCClaimPopup");
		return mav;
	}
	
	/**
	  * openVOCKindPopup - 팝업 - 샘플 팝업
	  * @author 김동현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openVOCKindPopup.sis", method=RequestMethod.POST)
	public ModelAndView openVOCKindPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		String custNm = request.getParameter("custNm") == null ? "" : request.getParameter("custNm");
		String customerMCode = request.getParameter("customerMCode") == null ? "" : request.getParameter("customerMCode");
		String customerWArea = request.getParameter("customerWArea") == null ? "" : request.getParameter("customerWArea");
		
		mav.addObject("custCode", custCode);
		mav.addObject("custNm", custNm);
		mav.addObject("customerMCode", customerMCode);
		mav.addObject("customerWArea", customerWArea);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openVOCKindPopup");
		return mav;
	}
	
	/**
	  * openCustInfoSMSPopup - 팝업 - 샘플 팝업
	  * @author 김동현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openCustInfoSMSPopup.sis", method=RequestMethod.POST)
	public ModelAndView openCustInfoSMSPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName(DEFAULT_PATH + "/" + "openCustInfoSMSPopup");
		return mav;
	}
	
	/**
	 * openInvoiceInfoPopup - 물류/재고 - 운송장정보 나눔팝업
	 * @author mi
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openInvoiceInfoPopup.sis", method=RequestMethod.POST)
	public ModelAndView openInvoiceInfoPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		String strList_INVHDATE = request.getParameter("strList_INVHDATE") == null ? "" : request.getParameter("strList_INVHDATE");
		String strList_INVHNUM = request.getParameter("strList_INVHNUM") == null ? "" : request.getParameter("strList_INVHNUM");
		String strList_INVHIDX = request.getParameter("strList_INVHIDX") == null ? "" : request.getParameter("strList_INVHIDX");
		
		request.setAttribute("strList_INVHDATE", strList_INVHDATE);
		request.setAttribute("strList_INVHNUM", strList_INVHNUM);
		request.setAttribute("strList_INVHIDX", strList_INVHIDX);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openInvoiceInfoPopup");
		return mav;
	}
	
	/**
	  * openCustInfoCleansingPopup - 팝업 - 클랜징 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openCustInfoCleansingPopup.sis", method=RequestMethod.POST)
	public ModelAndView openCustInfoCleansingPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName(DEFAULT_PATH + "/" + "openCustInfoCleansingPopup");
		return mav;
	}
	
	/**
	 * openInvoiceInfoPopup - 현금출납 - 출납등록 팝업
	 * @author mi
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openPaymentPopup.sis", method=RequestMethod.POST)
	public ModelAndView openPaymentPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		String ACCOUNT_IOIDX = request.getParameter("ACCOUNT_IOIDX") == null ? "" : request.getParameter("ACCOUNT_IOIDX");
		String DT = request.getParameter("DT") == null ? "" : request.getParameter("DT");
		
		request.setAttribute("ACCOUNT_IOIDX",  ACCOUNT_IOIDX);
		request.setAttribute("DT",  DT);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openPaymentPopup");
		return mav;
	}
	
	/**
	 * openPaymentTestPopup - 결제 - 결제 테스트 팝업
	 * @author 하혜민
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openPaymentTestPopup.sis", method=RequestMethod.POST)
	public ModelAndView openPaymentTestPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();

		mav.setViewName(DEFAULT_PATH + "/" + "openPaymentTestPopup");
		return mav;
	}
	
	/**
	  * searchOrgnPopup - 팝업 - 조직 조회 팝업
	  * @author 주병훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchOrgnTreePopup.sis", method=RequestMethod.POST)
	public ModelAndView searchOrgnTreePopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "searchOrgnTreePopup");
		return mav;
	}
	
	/**
	 * openOrderCanclePopup - 주문서 삭제 팝업
	 * @author 김동현
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openOrderCanclePopup.sis", method=RequestMethod.POST)
	public ModelAndView openOrderCanclePopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		String strOrderNo = request.getParameter("strOrderNo");
		String strOrderUser = request.getParameter("strOrderUser");
		String strOrderDeleteMCode = request.getParameter("strOrderDeleteMCode");

		mav.addObject("strOrderNo", strOrderNo);
		mav.addObject("strOrderUser", strOrderUser);
		mav.addObject("strOrderDeleteMCode", strOrderDeleteMCode);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openOrderCanclePopup");
		return mav;
	}
	
	/**
	 * openOrderCouponPopup - 주문서 쿠폰 팝업
	 * @author 김동현
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openOrderCouponPopup.sis", method=RequestMethod.POST)
	public ModelAndView openOrderCouponPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		String strOrderUser = request.getParameter("strOrderUser");
		
		mav.addObject("strOrderUser", strOrderUser);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openOrderCouponPopup");
		return mav;
	}
	
	/**
     * openOrderCouponPopup - 주문서 쿠폰 팝업
     * @author 김동현
     * @param request
     * @return ModelAndView
     */
    @RequestMapping(value = "openOrderCouponPopup1.sis", method=RequestMethod.POST)
    public ModelAndView openOrderCouponPopup1(HttpServletRequest request) throws SQLException, Exception {              
        ModelAndView mav = new ModelAndView();
        
        String strOrderUser = request.getParameter("strOrderUser");
        String strARTICLE_CODE = request.getParameter("strARTICLE_CODE");
        String strRId = request.getParameter("strRId");
        
        mav.addObject("strOrderUser", strOrderUser);
        mav.addObject("strARTICLE_CODE", strARTICLE_CODE);
        mav.addObject("strRId", strRId);
        
        mav.setViewName(DEFAULT_PATH + "/" + "openOrderCouponPopup1");
        return mav;
    }
	
	/**
	 * openOrderCouponPopup - 주문서 쿠폰 팝업
	 * @author 김동현
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openOrderCouponPopup2.sis", method=RequestMethod.POST)
	public ModelAndView openOrderCouponPopup2(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		String strOrderUser = request.getParameter("strOrderUser");
		
		mav.addObject("strOrderUser", strOrderUser);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openOrderCouponPopup2");
		return mav;
	}
	
	/**
	 * openOrderCouponPopup - 주문서 쿠폰 팝업
	 * @author 김동현
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openSearchSelectPromotionPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchSelectPromotionPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		String strOrderUser = request.getParameter("strOrderUser");
		
		mav.addObject("strOrderUser", strOrderUser);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchSelectPromotionPopup");
		return mav;
	}
	
	/**
	 * openOrderCouponPopup - 외부몰 사은품 팝업
	 * @author 양중호
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openSearchOutsideMallGiftPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchOutsideMallGiftPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		String articleCd = request.getParameter("articleCd") == null ? "" : request.getParameter("articleCd");
		String itemNum = request.getParameter("itemNum") == null ? "" : request.getParameter("itemNum");
		String kbn = request.getParameter("kbn") == null ? "" : request.getParameter("kbn");
		
		mav.addObject("articleCd", articleCd);
		mav.addObject("itemNum", itemNum);
		mav.addObject("kbn", kbn);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchOutsideMallGiftPopup");
		return mav;
	}

	/**
	 * openSearchSpecialEditionGiftPopup - 특판 제품코드관리 사은품 팝업
	 * 
	 * @author 유가영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "openSearchSpecialEditionGiftPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchSpecialEditionGiftPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		String articleCd = request.getParameter("articleCd") == null ? "" : request.getParameter("articleCd");
		String itemNum = request.getParameter("itemNum") == null ? "" : request.getParameter("itemNum");
		String kbn = request.getParameter("kbn") == null ? "" : request.getParameter("kbn");
		
		mav.addObject("articleCd", articleCd);
		mav.addObject("itemNum", itemNum);
		mav.addObject("kbn", kbn);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchSpecialEditionGiftPopup");
		return mav;
	}
	
	/**
	 * openCustomerDataChangeMsg - 고객정보 제공동의 변경시 문자 팝업
	 * @author 유가영
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openCustomerDataChangeMsg.do", method=RequestMethod.POST)
	public ModelAndView openCustomerDataChangeMsg(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String msg_Flag = request.getParameter("msg_Flag");
		String customerCd = request.getParameter("customerCd");
		int data_provide_yn = Integer.parseInt(request.getParameter("data_provide_yn"));
		int data_sensi_provide_yn = Integer.parseInt(request.getParameter("data_sensi_provide_yn"));
		int data_marketing_yn = Integer.parseInt(request.getParameter("data_marketing_yn"));
		mav.addObject("msg_Flag", msg_Flag);
		mav.addObject("customerCd", customerCd);
		mav.addObject("data_provide_yn", data_provide_yn);
		mav.addObject("data_sensi_provide_yn", data_sensi_provide_yn);
		mav.addObject("data_marketing_yn", data_marketing_yn);
		mav.setViewName(DEFAULT_PATH + "/" + "openCustomerDataChangeMsg");
		return mav;
	}
	
	
	/**
	 * openOrderCouponPopup - 더블행사선택팝업
	 * @author 조승현
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openSearchSelectDoubleEventPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchSelectDoubleEventPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		String strOrderUser = request.getParameter("strOrderUser");
		
		mav.addObject("strOrderUser", strOrderUser);
		mav.addObject("toDayYYYYMMDD",CommonUtil.calTodayYYYYMMDD());
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchSelectDoubleEventPopup");
		return mav;
	}
	
	/**
	 * openSearchSmsPopup - SMS 팝업
	 * @author 주병훈
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openSearchSmsPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchSms(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		String PHONE1 = request.getParameter("PHONE1");
		String PHONE2 = request.getParameter("PHONE2");
		String PHONE3 = request.getParameter("PHONE3");
		
		mav.addObject("PHONE1", PHONE1);
		mav.addObject("PHONE2", PHONE2);
		mav.addObject("PHONE3", PHONE3);
		mav.addObject("toDayYYYYMMDD",CommonUtil.calTodayYYYYMMDD());
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchSmsPopup");
		return mav;
	}
	
	/**
	 * openSearchSmsList - SMS
	 * @author 주병훈
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openSearchSmsList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchSmsList(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();

		String PHONE1 = request.getParameter("PHONE1") == null ? "" : request.getParameter("PHONE1");
		String PHONE2 = request.getParameter("PHONE2") == null ? "" : request.getParameter("PHONE2");
		String PHONE3 = request.getParameter("PHONE3") == null ? "" : request.getParameter("PHONE3");
		
		paramMap.put("PHONE1", PHONE1);
		paramMap.put("PHONE2", PHONE2);
		paramMap.put("PHONE3", PHONE3);
		List<Map<String, Object>> smsList = commonPopupService.searchSmsList(paramMap);

		paramMap.put("gridDataList", smsList);
		
		return paramMap;
	}

	/**
	 * openSearchPreCallDataPopup - [고객상담] - 이전 통화기록 팝업
	 * 
	 * @author 유가영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "openSearchPreCallDataPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchPreCallDataPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String CUSTOMER_CD = request.getParameter("CUSTOMER_CD");
		mav.addObject("CUSTOMER_CD", CUSTOMER_CD);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchPreCallDataPopup");
		return mav;
	}
	
	/**
	 * searchPreCallData - [고객상담] - 이전 통화기록 조회
	 * 
	 * @author 유가영
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "searchPreCallData.do", method=RequestMethod.POST)
	public Map<String, Object> searchPreCallData(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();

		String YEAR = request.getParameter("YEAR") == null ? "" : request.getParameter("YEAR");
		String CUSTOMER_CD = request.getParameter("CUSTOMER_CD") == null ? "" : request.getParameter("CUSTOMER_CD");
		
		paramMap.put("YEAR", YEAR);
		paramMap.put("CUSTOMER_CD", CUSTOMER_CD);
		
		List<Map<String, Object>> callDataList = commonPopupService.searchPreCallData(paramMap);

		paramMap.put("gridDataList", callDataList);
		
		return paramMap;
	}
	
	/**
	 * openCallCategoryPopup - [통화기록총괄] - 통화기록 카테고리 팝업
	 * 
	 * @author 유가영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "openCallCategoryPopup.sis", method=RequestMethod.POST)
	public ModelAndView openCallCategoryPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openCallCategoryPopup");
		return mav;
	}
	
	/**
	 * openCounselCallDataPopup - [고객상담] - 통화기록 상세조회 팝업
	 * 
	 * @author 유가영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "openCounselCallDataPopup.sis", method=RequestMethod.GET)
	public ModelAndView openCounselCallDataPopup(HttpServletRequest request) throws SQLException, Exception {	
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String CALL_DATA_IDX = request.getParameter("CALL_DATA_IDX") == null ? "" : request.getParameter("CALL_DATA_IDX");
		paramMap.put("CALL_DATA_IDX", CALL_DATA_IDX);
		
		Map<String, Object> callDataList = commonPopupService.searchDetailCallData(paramMap);
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("CALL_ORDER_YN", callDataList.get("CALL_ORDER_YN"));
		mav.addObject("CALL_INFO", callDataList.get("CALL_INFO"));
		mav.addObject("CALL_DATA", callDataList.get("CALL_DATA"));
		mav.addObject("CALL_ROUTE", callDataList.get("CALL_ROUTE"));
		mav.addObject("CALL_TRANSFER_YN", callDataList.get("CALL_TRANSFER_YN"));
		mav.addObject("CALL_CATE", callDataList.get("CALL_CATE"));
		mav.addObject("CALL_PRDT", callDataList.get("CALL_PRDT"));
		mav.addObject("CALL_SENSI_INFO", callDataList.get("CALL_SENSI_INFO"));
		mav.addObject("CALL_MARKETING", callDataList.get("CALL_MARKETING"));
		mav.addObject("CALL_CLAIM_YN", callDataList.get("CALL_CLAIM_YN"));
		mav.addObject("CALL_DT", callDataList.get("CALL_DT"));
		mav.setViewName(DEFAULT_PATH + "/" + "openCounselCallDataPopup");
		return mav;
	}
	
	/**
	 * openCustomerOrderCallDataPopup - [고객주문] - 통화기록 조회 팝업
	 * 
	 * @author 유가영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "openCustomerOrderCallDataPopup.sis", method=RequestMethod.GET)
	public ModelAndView openCustomerOrderCallDataPopup(HttpServletRequest request) throws SQLException, Exception {
		String CUSTOMER_CODE = request.getParameter("CUSTOMER_CODE");
		ModelAndView mav = new ModelAndView();
		mav.addObject("CUSTOMER_CODE", CUSTOMER_CODE);
		mav.setViewName(DEFAULT_PATH + "/" + "openCustomerOrderCallDataPopup");
		return mav;
	}

	/**
	 * searchCustomerOrderCallData - [고객주문] - 통화기록 조회 팝업 - 통화기록 조회
	 * 
	 * @author 유가영
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "searchCustomerOrderCallData.do", method=RequestMethod.POST)
	public Map<String, Object> searchCustomerOrderCallData(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();

		String CUSTOMER_CD = request.getParameter("CUSTOMER_CD") == null ? "" : request.getParameter("CUSTOMER_CD");
		paramMap.put("CUSTOMER_CD", CUSTOMER_CD);
		
		List<Map<String, Object>> callDataList = commonPopupService.searchCustomerOrderCallData(paramMap);

		paramMap.put("gridDataList", callDataList);
		
		return paramMap;
	}
	
	/**
	 * openCustomerOrderPaymentDataPopup - [고객주문] - 결제내역 조회 팝업
	 * 
	 * @author 유가영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "openCustomerOrderPaymentDataPopup.sis", method=RequestMethod.GET)
	public ModelAndView openCustomerOrderPaymentDataPopup(HttpServletRequest request) throws SQLException, Exception {
		String OCODE = request.getParameter("OCODE");
		ModelAndView mav = new ModelAndView();
		mav.addObject("OCODE", OCODE);
		mav.setViewName(DEFAULT_PATH + "/" + "openCustomerOrderPaymentDataPopup");
		return mav;
	}
	
	/**
	 * searchCustomerOrderPaymentData - [고객주문] - 결제내역 조회 팝업 - 결제내역 조회
	 * 
	 * @author 유가영
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "searchCustomerOrderPaymentData.do", method=RequestMethod.POST)
	public Map<String, Object> searchCustomerOrderPaymentData(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();

		String OCODE = request.getParameter("OCODE") == null ? "" : request.getParameter("OCODE");
		paramMap.put("OCODE", OCODE);
		
		List<Map<String, Object>> gridDataList = commonPopupService.searchCustomerOrderPaymentData(paramMap);

		paramMap.put("gridDataList", gridDataList);
		
		return paramMap;
	}
	
	/**
	 * searchDupliCustomerData - [고객상담] - 고객등록 팝업 - 중복고객 리스트 조회
	 * 
	 * @author 유가영
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "searchDupliCustomerData.do", method=RequestMethod.POST)
	public Map<String, Object> searchDupliCustomerData(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();

		String PHONE_NM = request.getParameter("PHONE_NM") == null ? "" : request.getParameter("PHONE_NM");
		String ROUTE_DIV = request.getParameter("ROUTE_DIV") == null ? "" : request.getParameter("ROUTE_DIV");
		paramMap.put("PHONE_NM", PHONE_NM);
		paramMap.put("ROUTE_DIV", ROUTE_DIV);
		
		List<Map<String, Object>> gridDataList = commonPopupService.searchDupliCustomerData(paramMap);

		paramMap.put("gridDataList", gridDataList);
		
		return paramMap;
	}
	
	/**
	 * openDupliCustomerPopup - [고객상담] - 고객등록 팝업 - 중복고객 리스트 팝업
	 * 
	 * @author 유가영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "openDupliCustomerPopup.sis", method=RequestMethod.POST)
	public ModelAndView openDupliCustomerPopup(HttpServletRequest request) throws SQLException, Exception {
		String PHONE_NM = request.getParameter("PHONE_NM");
		String ROUTE_DIV = request.getParameter("ROUTE_DIV");
		ModelAndView mav = new ModelAndView();
		mav.addObject("PHONE_NM", PHONE_NM);
		mav.addObject("ROUTE_DIV", ROUTE_DIV);
		mav.setViewName(DEFAULT_PATH + "/" + "openDupliCustomerPopup");
		return mav;
	}
	
	/**
	 * openCustomerModDataPopup - [고객상담] - 고객정보 수정이력 팝업
	 * 
	 * @author 유가영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "openCustomerModDataPopup.sis", method=RequestMethod.GET)
	public ModelAndView openCustomerModDataPopup(HttpServletRequest request) throws SQLException, Exception {	
		String IDX = request.getParameter("IDX") == null ? "" : request.getParameter("IDX");
		ModelAndView mav = new ModelAndView();
		mav.addObject("IDX", IDX);
		mav.setViewName(DEFAULT_PATH + "/" + "openCustomerModDataPopup");
		return mav;
	}
	
	/**
	 * searchCustomerModDataList - [고객상담] - 고객정보 수정이력 팝업 - 데이터 조회
	 * 
	 * @author 유가영
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "searchCustomerModData.do", method=RequestMethod.POST)
	public Map<String, Object> searchCustomerModData(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> paramMap = new HashMap<String, Object>();

		String IDX = request.getParameter("IDX") == null ? "" : request.getParameter("IDX");
		paramMap.put("IDX", IDX);
		
		Map<String, Object> requestContent = commonPopupService.searchCustomerModData(paramMap);
		paramMap.put("requestContent", requestContent);
		
		return paramMap;
	}
	
	
	
	
///////////////////////////////////윈플러스 개발 추가///////////////////////////////////
	
	
	
	/**
	* openGoodsCategoryTreePopup - [공통] - 상품분류 트리 팝업
	* 
	* @author 강신영
	* @return ModelAndView
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value = "openGoodsCategoryTreePopup.sis", method=RequestMethod.POST)
	public ModelAndView openGoodsCategoryTreePopup() throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openGoodsCategoryTreePopup");
		return mav;
	}
	
	/**
	* getGoodsCategoryTreeList - [공통] - 상품분류 트리 팝업 - 데이터 조회
	* 
	* @author 강신영
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@SuppressWarnings("unchecked")
	@RequestMapping(value="getGoodsCategoryTreeList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsCategoryTreeList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String KEY_WORD = request.getParameter("KEY_WORD") == null ? "" : request.getParameter("KEY_WORD");
		String GRUP_STATE = request.getParameter("GRUP_STATE") == null ? "" : request.getParameter("GRUP_STATE");
		paramMap.put("KEY_WORD", KEY_WORD);
		paramMap.put("GRUP_STATE", GRUP_STATE);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> allGoodsCategoryMap = commonPopupService.getGoodsCategoryTreeList(paramMap);
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
		return resultMap;
	}
	
	
	/**
	 * openSearchCustmrGridPopup - 거래처 그리드 팝업
	 * 
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openSearchCustmrGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchCustmrGridPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		String PUR_SALE_TYPE = request.getParameter("PUR_SALE_TYPE") == null ? "" : request.getParameter("PUR_SALE_TYPE");
		mav.addObject("PUR_SALE_TYPE", PUR_SALE_TYPE);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchCustmrGridPopup");
		return mav;
	}
	
	
	/**
	* getCustmrList - [공통] - 거래처조회 팝업- 데이터 조회
	* 
	* @author 정혜원
	* @return List<Map<String, Object>>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="getCustmrList.do", method=RequestMethod.POST)
	public Map<String, Object> getCustmrList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String ORGN_DIV_CD = empSessionDto.getOrgn_div_cd();
		String ORGN_CD = empSessionDto.getOrgn_cd();
		
		paramMap.put("emp_no", emp_no);
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		
		try{
			List<Map<String, Object>> CustmrList = commonPopupService.getCustmrList(paramMap);
			resultMap.put("CustmrList", CustmrList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	 * openSurpGridPopup - 공급사 그리드 팝업
	 * 
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openSurpGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSurpGridPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openSurpGridPopup");
		return mav;
	}
	
	/**
	 * openSearchGoodsGridPopup - 상품조회 그리드 팝업
	 * 
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openSearchGoodsGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchGoodsGridPopup(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.addObject("paramMap", paramMap);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchGoodsGridPopup");
		return mav;
	}
	
	/**
	* getGoodsList - [공통] - 상품조회 팝업- 데이터 조회
	* 
	* @author 정혜원
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="getGoodsList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("getGoodsList paramMap >>>> " + paramMap);
		try{
			List<Map<String, Object>> GoodsList = commonPopupService.getGoodsList(paramMap);
			resultMap.put("GoodsList", GoodsList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	 * openGoodsInformationPopup - 상품정보 팝업
	 * 
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openGoodsInformationPopup.sis", method=RequestMethod.POST)
	public ModelAndView openGoodsInformationPopup(HttpServletRequest request) throws SQLException, Exception {
		String goods_no = request.getParameter("GOODS_NO") == null ? "" : request.getParameter("GOODS_NO");
		String bcd_cd = request.getParameter("BCD_CD") == null ? "" : request.getParameter("BCD_CD");
		String crud = request.getParameter("CRUD") == null ? "" : request.getParameter("CRUD");
		ModelAndView mav = new ModelAndView();
		mav.addObject("GOODS_NO", goods_no);
		mav.addObject("BCD_CD", bcd_cd);
		mav.addObject("CRUD", crud);
		mav.setViewName(DEFAULT_PATH + "/" + "openGoodsInformationPopup");
		return mav;
	}
	
	/**
	* getGoodsContents - 상품정보 팝업 - 상품정보 조회 - 데이터 조회
	* 
	* @author 강신영
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="getGoodsContents.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsContents(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String goods_no = request.getParameter("GOODS_NO");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		paramMap.put("GOODS_NO", goods_no);
		Map<String,Object> goodsMap = commonPopupService.getGoodsInformation(paramMap);
	
		resultMap.put("dataMap", goodsMap);
		
		List<Map<String, Object>> bcodeList = commonPopupService.getBcodeList(paramMap);
		resultMap.put("gridDataList", bcodeList);
		
		return resultMap;
	}
	
	/**
	* getGoodsPurInfo - 상품정보 팝업 - 매입정보 조회 - 데이터 조회
	* 
	* @author 정혜원
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="getGoodsPurInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsPurInfo(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		

		List<Map<String, Object>> GoodsPurInfoList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> GoodsPurInfoAVGList = new ArrayList<Map<String, Object>>();
		
		try {
			if(paramMap.get("GOODS_NO").equals("") || paramMap.get("GOODS_NO") == null) {
				resultMap.put("gridDataList", GoodsPurInfoList);
				resultMap.put("AvgDataList", GoodsPurInfoAVGList);
			} else {
				GoodsPurInfoList = commonPopupService.getGoodsPurInformation(paramMap);
				GoodsPurInfoAVGList = commonPopupService.getGoodsPurInfoAVG(paramMap);
				resultMap.put("gridDataList", GoodsPurInfoList);
				resultMap.put("AvgDataList", GoodsPurInfoAVGList);
			}
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	
	/**
	* getGoodsSales - 상품정보 팝업 - 판매정보 조회 - 데이터 조회
	* 
	* @author 최지민
	* @return List<Map<String, Object>>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="getGoodsSales.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsSales(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> informationMap = commonPopupService.getGoodsSales(paramMap);
		resultMap.put("gridDataList", informationMap);
		
		Map<String, Object> goodsMap = (Map<String, Object>) commonPopupService.getGoodsSalesUnder(paramMap);
		resultMap.put("gridDataMap", goodsMap);
		
		return resultMap;
	}
	
	
	/**
	* getGoodsStock - 상품정보 팝업 - 재고정보 조회 - 데이터 조회
	* 
	* @author 최지민
	* @return List<Map<String, Object>>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="getGoodsStock.do", method=RequestMethod.POST)
	public Map<String,Object> getGoodsStock(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String,Object>> stockMap = commonPopupService.getGoodsStock(paramMap);
		resultMap.put("gridDataList", stockMap);
		
		return resultMap;
	}
	
	
	/**
	* getGoodsModiLog - 상품정보 팝업 - 변경로그조회
	* 
	* @author 정혜원
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="getGoodsModiLog.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsModiLog(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String GOODS_NO = request.getParameter("GOODS_NO");
		String FromDate = request.getParameter("FromDate");
		String ToDate = request.getParameter("ToDate");
		
		paramMap.put("GOODS_NO", GOODS_NO);
		paramMap.put("FROM_DATE", FromDate);
		paramMap.put("TO_DATE", ToDate);
		
		List<Map<String, Object>> GoodsModiLogList = new ArrayList<Map<String, Object>>();
		
		try {
			GoodsModiLogList = commonPopupService.getGoodsModiLog(paramMap);
			resultMap.put("gridDataList", GoodsModiLogList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param mav
	 * @return mav
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 정보창 팝업 열기
	 */
	@RequestMapping(value="openMemberInfoPopup.sis", method=RequestMethod.POST)
	public ModelAndView openMemberInfoPopup(HttpServletRequest request, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "/" + "openMemberInfoPopup");
		return mav;
	}
	
	/**
	  * openCustomerinputPopup - 팝업 - 거래처등록 팝업
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openCustomerinputPopup.sis", method=RequestMethod.POST)
	public ModelAndView openCustomerinputPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav   = new ModelAndView();
		String customer_cd = request.getParameter("customer_cd");
		String pur_sale_type = request.getParameter("pur_sale_type");
		
		mav.addObject("customer_cd",customer_cd);
		mav.addObject("pur_sale_type",pur_sale_type);
		logger.info("@@@@@@@@@@ CustmrSearchController.java  custmrSearch.sis ============");
		mav.setViewName(DEFAULT_PATH + "/" + "openCustomerinputPopup");
		return mav;		
	}
	
	
	/**
	  * openCustmerSearchPopup - 팝업 - 동일사업자번호 팝업
	  * @author 손경락
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openCustmerSearchPopup.sis", method=RequestMethod.POST)
	public ModelAndView openCustmerSearchPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav   = new ModelAndView();
		String imsi_corp_no = request.getParameter("imsi_corp_no");
		
		mav.addObject("imsi_corp_no",imsi_corp_no);
		mav.setViewName(DEFAULT_PATH + "/" + "openCustmerSearchPopup");
		return mav;		
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @param mav
	 * @return mab
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원명으로 회원 검색 팝업 열기 
	 */
	@RequestMapping(value="openMemberSearchPopup.sis", method=RequestMethod.POST)
	public ModelAndView openMemberSearchPopup(HttpServletRequest request, @RequestParam Map<String, String> paramMap, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "/" + "openMemberSearchPopup");
		return mav;
	}
	
	
	/**
	* getGoodsContents - 상품정보 팝업 - 대중소분류 이름 조회
	* 
	* @author 강신영
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="getCategoryTMBName.do", method=RequestMethod.POST)
	public Map<String, Object> getCategoryTMBName(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String grup_cd = request.getParameter("GRUP_CD");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		paramMap.put("GRUP_CD", grup_cd);
		
		Map<String,Object> categoryMap = commonPopupService.getCategoryTMBName(paramMap);
		resultMap.put("dataMap", categoryMap);
		
		return resultMap;
	}
	
	
	/**
	 *  openCustmerSearchPopup - 팝업 - 동일사업자번호 팝업
	 * @author 손경락
	 * @param request
	 * @param paramMap
	 * @param mav
	 * @return mab
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원명으로 회원 검색 팝업 열기 
	 */
	@RequestMapping(value="openSearchProjectGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchProjectGridPopup(HttpServletRequest request, @RequestParam Map<String, String> paramMap, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchProjectGridPopup");
		return mav;
	}
	
	
	/**
	* getProjectList - [공통] - 프로젝트조회 팝업- 데이터 조회
	* 
	* @author 손경락	
	* @return List<Map<String, Object>>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="getProjectList.do", method=RequestMethod.POST)
	public Map<String, Object> getProjectList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String KEY_WORD = request.getParameter("KEY_WORD");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		paramMap.put("KEY_WORD", KEY_WORD);
		
		try{
			List<Map<String, Object>> ProjectList = commonPopupService.getProjectList(paramMap);
			resultMap.put("ProjectList", ProjectList);
		}catch(SQLException e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	/**
	 * openGoodsGroupGridPopup - 상품,거래처집합관리팝업
	 * 
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openGoodsGroupGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView openGoodsGroupGridPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openGoodsGroupGridPopup");
		return mav;
	}
	
	/**
	* SearchGoodsGroupList - [공통] - 상품,거래처집합 팝업- 상품,거래처집합그룹 조회
	* 
	* @author 정혜원
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="SearchGoodsGroupList.do", method=RequestMethod.POST)
	public Map<String, Object> SearchGoodsGroupList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		paramMap.put("emp_no", emp_no);
		
		try{
			List<Map<String, Object>> GoodsGroupList = commonPopupService.getGoodsGroupList(paramMap);
			resultMap.put("gridDataList", GoodsGroupList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	
	/**
	* SaveGoodsGroupList - [공통] - 상품,거래처집합관리 팝업- 상품,거래처집합그룹 추가
	* 
	* @author 정혜원
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="SaveGoodsGroupList.do", method=RequestMethod.POST)
	public Map<String, Object> SaveGoodsGroupList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int insertResult = 0;
		int deleteResult = 0;
		int updateResult = 0;
		int last_grup_cd = 0;
		String GRUP_CD = "";
		
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = null;

		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			paramMap = new HashMap<String, Object>();
			paramMap = dhtmlxParamMapList.get(i);
			if(dhtmlxParamMapList.get(i).get("CRUD").equals("C")){
				GRUP_CD = commonPopupService.getGoodsGroupCD(paramMap).get("GRUP_CD").toString();
				paramMap.put("GRUP_CD", GRUP_CD);
				paramMap.put("USE_YN", "Y");
				paramMap.put("CPROGRM", "SaveGoodsGroupList");
				paramMap.put("CUSER", emp_no);
				paramMap.put("RESP_USER", emp_no);
				insertResult = commonPopupService.addGoodsGroupList(paramMap);
			} else if(dhtmlxParamMapList.get(i).get("CRUD").equals("D")) {
				GRUP_CD = dhtmlxParamMapList.get(i).get("GRUP_CD").toString();
				paramMap.put("GRUP_CD", GRUP_CD);
				paramMap.put("RESP_USER", dhtmlxParamMapList.get(i).get("RESP_USER").toString());
				deleteResult = commonPopupService.deleteGoodsGroupList(paramMap);
			} else if(dhtmlxParamMapList.get(i).get("CRUD").equals("U")) {
				GRUP_CD = dhtmlxParamMapList.get(i).get("GRUP_CD").toString();
				paramMap.put("GRUP_CD", GRUP_CD);
				paramMap.put("MPROGRM", "SaveGoodsGroupList");
				paramMap.put("MUSER", emp_no);
				updateResult = commonPopupService.updateGoodsGroupList(paramMap);
			}
		}
		return resultMap;
	}
	
	/**
	* SearchGoodsGroupDetailList - [공통] - 상품,거래처집합관리 팝업- 상품,거래처집합그룹상세상품 조회
	* 
	* @author 정혜원
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="SearchGoodsGroupDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> SearchGoodsGroupDetailList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try{
			List<Map<String, Object>> gridDataList = commonPopupService.getGoodsGroupDetailList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		} catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	* getGoodsGrupSelectedList - [공통] - 상품,거래처집합관리 팝업- 상품,거래처집합 상세상품 추가정보조회
	* 
	* @author 정혜원
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="getGoodsGrupSelectedList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsGrupSelectedList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String BCD_CD = request.getParameter("BCD_CD");
		String GOODS_NO = request.getParameter("GOODS_NO");
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String ORGN_DIV_CD = empSessionDto.getOrgn_div_cd();
		String ORGN_CD = empSessionDto.getOrgn_cd();
		
		paramMap.put("GOODS_NO", GOODS_NO);
		paramMap.put("BCD_CD", BCD_CD);
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		
		try{
			List<Map<String, Object>> gridDataList = commonPopupService.getGoodsGrupSelectedList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		} catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	
	/**
	* SaveGoodsGroupDetailList - [공통] - 상품,거래처집합관리 팝업- 상품,거래처집합 상세상품 추가
	* 
	* @author 정혜원
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="SaveGoodsGroupDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> SaveGoodsGroupDetailList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int insertResult = 0;
		int deleteResult = 0;
		int updateResult = 0;
		
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		for(Map<String, Object> paramMap : dhtmlxParamMapList) {
			//logger.debug("SaveGoodsGrupDetailList Map >>> " + paramMap);
			if(paramMap.get("CRUD").equals("C")){
				paramMap.put("CPROGRM", "SaveGoodsGroupDetailList");
				paramMap.put("CUSER", emp_no);
				paramMap.put("RESP_USER", emp_no);
				insertResult += commonPopupService.addGoodsGroupDetailList(paramMap);
			} else if(paramMap.get("CRUD").equals("U")) {
				paramMap.put("MPROGRM", "SaveGoodsGroupDetailList");
				paramMap.put("MUSER", emp_no);
				updateResult += commonPopupService.updateGoodsGroupDetailList(paramMap);
			} else if(paramMap.get("CRUD").equals("D")) {
				deleteResult += commonPopupService.deleteGoodsGroupDetailList(paramMap);
			}
		}
		
		//logger.debug("insertResult >> " + insertResult);
		//logger.debug("deleteResult >> " + insertResult);
		//logger.debug("updateResult >> " + insertResult);
		
		resultMap.put("insertResult", insertResult);
		resultMap.put("deleteResult", deleteResult);
		resultMap.put("updateResult", updateResult);
		
		return resultMap;
	}
	
	/**
	  * getPasteGrupGoodsList - 상품그룹상세 바코드 복사 붙여넣기
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getPasteGrupGoodsList.do", method = RequestMethod.POST)
	public Map<String, Object> getPasteGrupGoodsList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		logger.debug("RquestBody >> " + paramMap);
		
		resultMap.put("gridDataList", commonPopupService.getPasteGrupGoodsList(paramMap));
		
		return resultMap;
	}
	
	/**
	 *  openOrderInputGridPopup - 팝업 - 발주서 입력/수정 공통팝업
	 * @author 손경락
	 * @param request
	 * @param paramMap
	 * @param mav
	 * @return mab
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원명으로 회원 검색 팝업 열기 
	 */
	@RequestMapping(value="openOrderInputGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView openOrderInputGridPopup(HttpServletRequest request, @RequestParam Map<String, String> paramMap, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "/" + "openOrderInputGridPopup");
		return mav;
	}
	/**
	 * openOrderInputGridPopup - 팝업 - 바코드마스터 && 상품마스트에서 상품및  바코드가져온다
	 * @author 손경락
	 * @param request
	 * @param paramMap
	 * @param mav
	 * @return mab
	 * @throws SQLException
	 * @throws Exception
	 * @description 상품명으로 바코드&&상품 검색 팝업 열기 
	 * @create date 2019-08-19 12:00:00
	 * @modify date
	 */
	@RequestMapping(value="openSearchMastBcodeGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchMastBcodeGridPopup(HttpServletRequest request, @RequestParam Map<String, String> paramMap, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchMastBcodeGridPopup");
		return mav;
	}
	
	/**
	  * getSearchMasterBarcode -상품검색입력 조건을 바코드상품목록조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchMasterBarcode.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchMasterBarcode(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		String KEY_WORD           = request.getParameter("KEY_WORD");
		Map<String, Object> paramMap  = new HashMap<String, Object>();
		paramMap.put("KEY_WORD"     ,    KEY_WORD );
		
		List<Map<String, Object>> customList = commonPopupService.getSearchMasterBarcode(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}	
	
	/**
	 * openSearchComEmpNoPopup - 팝업 - 사원정보에서 사원번호,성명,부서,이메일,연락처를 가져온다
	 * @author 손경락
	 * @param request
	 * @param paramMap
	 * @param mav
	 * @return mab
	 * @throws SQLException
	 * @throws Exception
	 * @description 상품명으로 바코드&&상품 검색 팝업 열기 
	 * @create date 2019-08-19 12:00:00
	 * @modify date
	 */                    
	@RequestMapping(value="openSearchComEmpNoGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchComEmpNoGridPopup(HttpServletRequest request, @RequestParam Map<String, String> paramMap, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchComEmpNoGridPopup");
		return mav;
	}
	
	
	/**
	  * getSearchComEmpNo - 사원검색입력 조건을 사원정보목록조회
	  * @author 손경락
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSearchComEmpNo.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchComEmpNo(HttpServletRequest request, @RequestParam Map<String,String> parmaMap) throws SQLException, Exception {
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    
		String KEY_WORD               = request.getParameter("KEY_WORD");
		Map<String, Object> paramMap  = new HashMap<String, Object>();
		paramMap.put("KEY_WORD"     ,    KEY_WORD );
		
		List<Map<String, Object>> customList = commonPopupService.getSearchComEmpNo(paramMap);				
		resultMap.put("gridDataList", customList);
		
		return resultMap;
	}
	
	/**
	  * openSearchMemberGridPopup - 회원조회팝업
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchMemberGridPopup.sis", method = RequestMethod.POST)
	public ModelAndView openSearchMemberGridPopup(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("paramMap", paramMap);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchMemberGridPopup");
		return mav;
	}
	
	/**
	  * getSearchMemberList - 회원조회팝업 - 회원조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getSearchMemberList.do", method = RequestMethod.POST)
	public Map<String, Object> getSearchMemberList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		try {
			gridDataList = commonPopupService.getSearchMemberList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}

	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 * @description 게시물 첨부파일 업로드 팝업 오픈
	 */
	@RequestMapping(value = "openAttachFilesUploadPopup.sis", method=RequestMethod.POST)
	public ModelAndView openAttachFilesUploadPopup(HttpServletRequest request, @RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.addObject("paramMap", paramMap);
		mav.setViewName(DEFAULT_PATH + "/" + "openAttachFilesUploadPopup");
		return mav;
	}
	/**
	  * openAddGoodsGrupPopup - 상품리스트 우클릭 상품그룹추가 팝업
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openAddGoodsGrupPopup.sis", method = RequestMethod.POST)
	public ModelAndView openAddGoodsGrupPopup(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("paramMap", paramMap);
		mav.setViewName(DEFAULT_PATH + "/" + "openAddGoodsGrupPopup");
		return mav;
	}
	
	/**
	  * addGoodsGrup - 받아온 상품리스트로 상품그룹에 추가
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "addGoodsGrup.do", method = RequestMethod.POST)
	public Map<String, Object> addGoodsGrup(HttpServletRequest request
			, @RequestParam(value="bcd_list") List<String> BCD_CD_LIST, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String EMP_NO = empSessionDto.getEmp_no();
		StringBuilder param_bcd_list = new StringBuilder();
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> DataMap = new HashMap<String, Object>();
		
		param_bcd_list.append(BCD_CD_LIST.get(0));
		for(int i = 1 ; i < BCD_CD_LIST.size() ; i++) {
			param_bcd_list.append(",");
			param_bcd_list.append(BCD_CD_LIST.get(i));
		}
		
		paramMap.put("RESP_USER", EMP_NO);
		paramMap.put("CPROGRM", "addGoodsGrup");
		paramMap.put("CUSER", EMP_NO);
		paramMap.put("BCD_CD_LIST", param_bcd_list.toString());
		
		int resultCnt = 0;
		
		try {
			DataMap = commonPopupService.addGoodsGrup(paramMap);
			if(DataMap.get("ResultMessage").equals("ERROR")) {
				resultMap.put("ResultMessage", "이미등록된 상품그룹명입니다.<br>새로운 이름으로 등록해주세요.");
			}else {
				//logger.debug("DataMap >> " + DataMap);
				resultMap.put("ResultMessage", "SUCCESS");
				resultMap.put("resultCnt", DataMap.get("CNT"));
			}
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * openCustmrInfoLogPopup - 거래처정보 로그 조회
	  * @author 조승현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openCustmrInfoLogPopup.sis", method = RequestMethod.POST)
	public ModelAndView openCustmrInfoLogPopup(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("paramMap", paramMap);
		mav.setViewName(DEFAULT_PATH + "/" + "openCustmrInfoLogPopup");
		return mav;
	}
	
	/**
	 * autoBindSearchCustmrPopup - 협력사 조회 팝업(자동 바인드)
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="autoBindSearchCustmrPopup.sis", method=RequestMethod.POST)
	public ModelAndView autoBindSearchCustmrPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		Enumeration<String> requestParams = request.getParameterNames();
		String reqParamKey = "";
		String reqParamValue = "";
		while(requestParams.hasMoreElements()) {
			reqParamKey = requestParams.nextElement();
			reqParamValue = request.getParameter(reqParamKey);
			mav.addObject(reqParamKey, reqParamValue);
		}
		mav.setViewName(DEFAULT_PATH + "/" + "autoBindSearchCustmrPopup");
		return mav;
	}
	
	/**
	 * autoBindSearchGoodsPopup - 상품조회 팝업(자동 바인드)
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="autoBindSearchGoodsPopup.sis", method=RequestMethod.POST)
	public ModelAndView autoBindSearchGoodsPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		Enumeration<String> requestParams = request.getParameterNames();
		String reqParamKey = "";
		String reqParamValue = "";
		while(requestParams.hasMoreElements()) {
			reqParamKey = requestParams.nextElement();
			reqParamValue = request.getParameter(reqParamKey);
			mav.addObject(reqParamKey, reqParamValue);
		}
		mav.setViewName(DEFAULT_PATH + "/" + "autoBindSearchGoodsPopup");
		return mav;
	}
}
