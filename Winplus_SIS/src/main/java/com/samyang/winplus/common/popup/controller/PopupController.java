package com.samyang.winplus.common.popup.controller;

import java.sql.SQLException;
import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.popup.service.PopupService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;

@RestController
@RequestMapping("/common/popup")
public class PopupController extends BaseController {
	
	@Autowired
	PopupService PopupService;
	
	private final Logger logger = LoggerFactory.getLogger(CommonPopupController.class);
	
	private final static String DEFAULT_PATH = "common/popup";
	
	/* ********************** 예시 **************************************** */
	
	/**
	 * <<API 문서 작성을 위해 아래의 내용을 정확히 써주세요~~!!>>
	 * 
	  * searchMtrlPopup - 팝업 - 자재 조회 팝업   //메서드명과 세부 설명을 적어주세요!
	  * @author 박성호							  
	  * @param request							  
	  * @return ModelAndView					  
	  */
/*	@RequestMapping(value = "searchMtrlPopup.sis", method=RequestMethod.POST)
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
	}*/
	
	/* ******************************************************************** */
	
	
	/**
	  * openSearchCustomerCdPoppup - 팝업 - 고객조회 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchCustomerCdPopup.sis", method=RequestMethod.POST)
	public ModelAndView getSearchCustomerCdPoppupList(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String searchCustomerCd = request.getParameter("searchCustomerCd");
		String searchCustomerNm = request.getParameter("searchCustomerNm");
		String returnMethod = request.getParameter("returnMethod");
		mav.addObject("searchCustomerCd", searchCustomerCd);
		mav.addObject("searchCustomerNm", searchCustomerNm);
		mav.addObject("returnMethod", returnMethod);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchCustomerCdPopup");
		return mav;
	}
	
	/**
	  * openSearchCustomerCdPoppup - 팝업 - 고객조회 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchCustomerTypePopup.sis", method=RequestMethod.POST)
	public ModelAndView getSearchCustomerTypePoppupList(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String searchType = request.getParameter("searchType");
		String searchText = request.getParameter("searchText");
		String departmentKbn = request.getParameter("departmentKbn") == null ? "" : request.getParameter("departmentKbn");
		String ROUTE_DIV = request.getParameter("ROUTE_DIV") == null ? "" : request.getParameter("ROUTE_DIV");
		//logger.debug("ROUTE_DIV : "+ROUTE_DIV);
		//String returnMethod = request.getParameter("returnMethod");
		mav.addObject("searchType", searchType);
		mav.addObject("searchText", searchText);
		mav.addObject("departmentKbn", departmentKbn);
		mav.addObject("ROUTE_DIV", ROUTE_DIV);
		//mav.addObject("returnMethod", returnMethod);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchCustomerTypePopup");
		return mav;
	}
	
	
	/**
	  * searchCustomerCdPopup - 공통고객코드조회
	  * @author 양중호
	  * @param request
	  * @return Map
	  */
	@RequestMapping(value="searchCustomerCdPopup.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchCustomerCdList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		String searchCustomerCd = request.getParameter("searchCustomerCd");
		String searchCustomerNm = request.getParameter("searchCustomerNm");
	    Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("searchCustomerCd", searchCustomerCd);
		paramMap.put("searchCustomerNm", searchCustomerNm);

		List<Map<String, Object>> customerCdList = PopupService.getSearchCustomerCdPopupList(paramMap);
		resultMap.put("customerCdList", customerCdList);
		
		
		return resultMap;
	}
	

	/**
	  * searchCustomerCdPopup - 공통고객 유형별조회
	  * @author 양중호
	  * @param request
	  * @return Map
	  */
	@RequestMapping(value="searchCustomerTypePopup.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchCustomerTypeList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		String searchType = request.getParameter("searchType");
		String searchText = request.getParameter("searchText");
		String departmentKbn = request.getParameter("departmentKbn") == null ? "" : request.getParameter("departmentKbn");
		String ROUTE_DIV = "";
		if(request.getParameter("ROUTE_DIV") == null || request.getParameter("ROUTE_DIV").equals("undefined") || request.getParameter("ROUTE_DIV").equals("")){
			ROUTE_DIV = "RD0001";
		}else{
			ROUTE_DIV = request.getParameter("ROUTE_DIV");
		}
	    Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("searchType", searchType);
		paramMap.put("searchText", searchText);
		paramMap.put("departmentKbn", departmentKbn);
		paramMap.put("ROUTE_DIV", ROUTE_DIV);

		List<Map<String, Object>> customerCdList = PopupService.getSearchCustomerTypePopupList(paramMap);
		resultMap.put("customerCdList", customerCdList);
		
		
		return resultMap;
	}
	
	/**
	  * openSearchCustomerCdPoppup - 팝업 - 담당자조회 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchMemberCdPopup.sis", method=RequestMethod.POST)
	public ModelAndView getSearchMemberCdPoppupList(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String searchChargeMember = request.getParameter("searchChargeMember");
		String cmbBusinessInfCd = request.getParameter("cmbBusinessInfCd");
		String memberTeamCd = request.getParameter("memberTeamCd");
		String enable_yn = request.getParameter("enable_yn");

		mav.addObject("searchMember", searchChargeMember);
		mav.addObject("businessInfCd", cmbBusinessInfCd);
		mav.addObject("memberTeamCd", memberTeamCd);
		mav.addObject("enable_yn", enable_yn);
	
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchMemberCdPopup");
		return mav;
	}
	
	/**
	  * openSearchCustomerCdPoppup2 - 팝업 - 담당자조회 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchMemberCdPopup2.sis", method=RequestMethod.POST)
	public ModelAndView getSearchMemberCdPoppupList2(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String memberNm = request.getParameter("memberNm");
		String cmbBusinessInfCd = request.getParameter("cmbBusinessInfCd");
		String saleChDiv = request.getParameter("saleChDiv");

		mav.addObject("memberNm", memberNm);
		mav.addObject("businessInfCd", cmbBusinessInfCd);
		mav.addObject("saleChDiv", saleChDiv);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchMemberCdPopup2");
		return mav;
	}
	
	/**
	  * searchMemberCdPopup - 공통담당자조회
	  * @author 양중호
	  * @param request
	  * @return Map
	  */
	@RequestMapping(value="searchMemberCdPopup.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchMemberCdList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		
		
		String searchMemberCd = request.getParameter("searchMemberCd") == null ? "" : request.getParameter("searchMemberCd");
		String searchMemberNm = request.getParameter("searchMemberNm") == null ? "" : request.getParameter("searchMemberNm");
		String cmbBusinessInfCd = request.getParameter("cmbBusinessInfCd") == null ? "" : request.getParameter("cmbBusinessInfCd");
		String memberTeamCd = request.getParameter("cmbMemberTeamCd") == null ? "" : request.getParameter("cmbMemberTeamCd");
		String cmbSaleChDiv = request.getParameter("cmbSaleChDiv") == null ? "" : request.getParameter("cmbSaleChDiv");
		
	    Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("searchMemberCd", searchMemberCd);
		paramMap.put("searchMemberNm", searchMemberNm);
		paramMap.put("cmbBusinessInfCd", cmbBusinessInfCd);
		paramMap.put("memberTeamCd", memberTeamCd);
		paramMap.put("cmbSaleChDiv", cmbSaleChDiv);
		
		List<Map<String, Object>> customerCdList = PopupService.getSearchMemberCdPopupList(paramMap);
		
		resultMap.put("customerCdList", customerCdList);
		
		
		return resultMap;
	}
	
	/**
	  * openSearchCustomerCdPoppup - 팝업 - 사업자조회 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchBusinessCdPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchBusinessCdPopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String searchBusinessCd = request.getParameter("searchBusinessCd") == null ? "" : request.getParameter("searchBusinessCd");
		String searchBusinessNm = request.getParameter("searchBusinessNm") == null ? "" : request.getParameter("searchBusinessNm");
		
		
		mav.addObject("searchBusinessCd", searchBusinessCd);
		mav.addObject("searchBusinessNm", searchBusinessNm);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchBusinessCdPopup");
		return mav;
	}
	
	/**
	  * searchBusinessCdPopup - 공통사업자조회
	  * @author 양중호
	  * @param request
	  * @return Map
	  */
	@RequestMapping(value="searchBusinessCdPopup.do", method=RequestMethod.POST)
	public Map<String, Object> searchBusinessCdPopup(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		
		
		String searchBusinessCd = request.getParameter("searchBusinessCd") == null ? "" : request.getParameter("searchBusinessCd");
		String searchBusinessNm = request.getParameter("searchBusinessNm") == null ? "" : request.getParameter("searchBusinessNm");
		
		
		
	    Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("searchBusinessCd", searchBusinessCd);
		paramMap.put("searchBusinessNm", searchBusinessNm);
	
		List<Map<String, Object>> businessCdList = PopupService.getSearchBusinessCdPopupList(paramMap);
		
		resultMap.put("businessCdList", businessCdList);
		return resultMap;
	}

	/**
	  * openCustListPopup - 고객명부 조회
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	 * @throws Exception 
	 * @throws SQLException 
	  */
	@RequestMapping(value="openCustListPopup.sis", method=RequestMethod.POST)
	public ModelAndView openCustListPopup(HttpServletRequest request) throws SQLException, Exception{
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openCustListPopup");	
		
		String custCode = request.getParameter("CUST_CODE") == null ? "" : request.getParameter("CUST_CODE");
		mav.addObject("CUST_CODE", custCode);
		return mav;
	}
	
	/**
	  * openCustListPopupContent - 고객명부 정보조회
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openCustListPopupContent.do", method=RequestMethod.POST)
	public Map<String, Object> openCustListPopupContent(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
	
		String custCode = request.getParameter("CUST_CODE") == null ? "" : request.getParameter("CUST_CODE");	

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("CUST_CODE", custCode);	
		paramMap.put("CRUD", "C");
		
		try{
			Map<String,Object> contentData = PopupService.getOpenCustListPopupContent(paramMap);
			resultMap.put("contentData", contentData);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}	
	
	/**
	  * openCustListPopupContentCUD - 고객명부 저장
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openCustListPopupContentCUD.do", method=RequestMethod.POST)
	public Map<String, Object> openCustListPopupContentCUD(HttpServletRequest request) throws SQLException, Exception {
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String member_Cd = empSessionDto.getMember_cd();
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		String memberCode = request.getParameter("MEMBER_CODE") == null ? "" : request.getParameter("MEMBER_CODE");
		String custCode = request.getParameter("CUST_CODE") == null ? "" : request.getParameter("CUST_CODE");
		String custAtte = request.getParameter("CUST_ATTE") == null ? "" : request.getParameter("CUST_ATTE");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("MEMBER_CODE", memberCode);
		paramMap.put("CUST_CODE", custCode);
		paramMap.put("MEMBER_CD", member_Cd);
		paramMap.put("CUST_ATTE", custAtte);
		paramMap.put("CRUD", "U");

		int resultRowCnt = PopupService.updateOpenCustListPopupContentCUD(paramMap);
		PopupService.memberChangeIf();
		
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
	
	
	/**
	  * openCustListPopupContentOffSet - 고객명부 상계처리
	  * @author 권대림
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openCustListPopupContentOffSet.do", method=RequestMethod.POST)
	public Map<String, Object> openCustListPopupContentOffSet(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		String Order_DCIdx = request.getParameter("Order_DCIdx");
		String Order_DComPlete = request.getParameter("Order_DComPlete");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("Order_DCIdx", Order_DCIdx);
		paramMap.put("Order_DComPlete", Order_DComPlete);

		int resultRowCnt = PopupService.updateopenCustListPopupContentOffSet(paramMap);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}	
	
	
	/**
	  * openSearchCustomerCdPoppup - 팝업 - 상품조회 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchGoodsCdPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchGoodsCdPopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String searchGoodsNm = request.getParameter("searchGoodsNm") == null ? "" : request.getParameter("searchGoodsNm");
		String searchGoodsCd = request.getParameter("searchGoodsCd") == null ? "" : request.getParameter("searchGoodsCd");
		
		
		mav.addObject("searchGoodsNm", searchGoodsNm);
		mav.addObject("searchGoodsCd", searchGoodsCd);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchGoodsCdPopup");
		return mav;
	}

	/**
	  * openSearchChmallGoodsCdPopup - 팝업 - 상품조회 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchChmallGoodsCdPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchChmallGoodsCdPopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String searchGoodsNm = request.getParameter("searchGoodsNm") == null ? "" : request.getParameter("searchGoodsNm");
		String searchGoodsCd = request.getParameter("searchGoodsCd") == null ? "" : request.getParameter("searchGoodsCd");
		
		
		mav.addObject("searchGoodsNm", searchGoodsNm);
		mav.addObject("searchGoodsCd", searchGoodsCd);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchChmallGoodsCdPopup");
		return mav;
	}
	
	/**
	  * openSearchCustomerCdPoppup2 - 팝업 - 상품조회 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchGoodsCdPopup2.sis", method=RequestMethod.POST)
	public ModelAndView openSearchGoodsCdPopup2(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		String searchGoodsNm = request.getParameter("searchGoodsNm") == null ? "" : request.getParameter("searchGoodsNm");
		String searchGoodsCd = request.getParameter("searchGoodsCd") == null ? "" : request.getParameter("searchGoodsCd");
		String ORDER_KIND = request.getParameter("ORDER_KIND") == null ? "" : request.getParameter("ORDER_KIND");
		
		mav.addObject("searchGoodsNm", searchGoodsNm);
		mav.addObject("searchGoodsCd", searchGoodsCd);
		mav.addObject("ORDER_KIND", ORDER_KIND);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchGoodsCdPopup2");
		return mav;
	}
	
	/**
	  * openSearchPointPopup - 고객상담 - 적립금조회 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchPointPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchPointPopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		mav.addObject("custCode", custCode);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchPointPopup");
		return mav;
	}
	
	/**
	  * openSearchSaveMoneyPromotionNamePopup - 적립금행사조회 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchSaveMoneyPromotionNamePopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchSaveMoneyPromotionNamePopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		String searchName = request.getParameter("SEARCHNAME") == null ? "" : request.getParameter("SEARCHNAME");
		mav.addObject("SEARCHNAME", searchName);		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchSaveMoneyPromotionNamePopup");	
		return mav;
	}	
	
	/**
	  * openSearchSaveMoneyPromotionNamePopupList - 적립금행사조회
	  * @author 이병주
	  * @param request
	  * @return Map
	  */
	@RequestMapping(value="openSearchSaveMoneyPromotionNamePopupList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchSaveMoneyPromotionNamePopupList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		String searchNm = request.getParameter("SEARCH_NM") == null ? "" : request.getParameter("SEARCH_NM");

	    Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("SEARCH_NM", searchNm);
	
		List<Map<String, Object>> gridDataList = PopupService.getOpenSearchSaveMoneyPromotionNamePopupList(paramMap);
		
		resultMap.put("gridDataList", gridDataList);
		return resultMap;
	}
	
	/**
	  * openRegistSamplePopup - 고객상담 -샘플등록 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openRegistSamplePopup.sis", method=RequestMethod.POST)
	public ModelAndView openRegistSamplePopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		mav.addObject("custCode", custCode);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openRegistSamplePopup");
		return mav;
	}
	
	/**
	  * openSearchPointPopup - 고객상담 -샘플검색 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openProductSamplePopup.sis", method=RequestMethod.POST)
	public ModelAndView openProductSamplePopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String sampleTxt = request.getParameter("sampleTxt") == null ? "" : request.getParameter("sampleTxt");
		mav.addObject("sampleTxt", sampleTxt);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openProductSamplePopup");
		return mav;
	}
	
	/**
	  * openReservationCallPopup - 고객상담 - 예약콜등록 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openReservationCallPopup.sis", method=RequestMethod.POST)
	public ModelAndView openReservationCallPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		String departmentKbn = request.getParameter("departmentKbn") == null ? "" : request.getParameter("departmentKbn");
		
		mav.addObject("custCode", custCode);
		mav.addObject("departmentKbn", departmentKbn);
		mav.addObject("toDayYYYYMMDD",CommonUtil.calTodayYYYYMMDD());
		
		mav.setViewName(DEFAULT_PATH + "/" + "openReservationCallPopup");
		return mav;
	}
	
	/**
	  * openSearchCampainPopup - 캠페인조회 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchCampainPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchCampainPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		String searchNm = request.getParameter("SEARCH_NM") == null ? "" : request.getParameter("SEARCH_NM");
		String searchDt = request.getParameter("SEARCH_DT") == null ? "" : request.getParameter("SEARCH_DT");
		mav.addObject("SEARCH_NM", searchNm);		
		mav.addObject("SEARCH_DT", searchDt);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchCampainPopup");	
		return mav;
	}	
	
	/**
	  * openSearchCampainPopupList - 캠페인조회 팝업 목록조회
	  * @author 이병주
	  * @param request
	  * @return Map
	  */
	@RequestMapping(value="openSearchCampainPopupList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchCampainPopupList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		String searchNm = request.getParameter("SEARCH_NM") == null ? "" : request.getParameter("SEARCH_NM");
		String searchDt = request.getParameter("SEARCH_DT") == null ? "" : request.getParameter("SEARCH_DT");

	    Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("SEARCH_NM", searchNm);
		paramMap.put("SEARCH_DT", searchDt);
	
		List<Map<String, Object>> gridDataList = PopupService.getOpenSearchCampainPopupList(paramMap);
		
		resultMap.put("gridDataList", gridDataList);
		return resultMap;
	}
	
	/**
	  * openCustomerInfoPopup - 고객상담 -고객정보 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openCustomerInfoPopup.sis", method=RequestMethod.POST)
	public ModelAndView openCustomerInfoPopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		mav.addObject("custCode", custCode);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openCustomerInfoPopup");
		return mav;
	}
	
	/**
	  * openSearchBuyPurposePopup - 구매목적조회 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchBuyPurposePopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchBuyPurposePopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		String searchName = request.getParameter("SEARCHNAME") == null ? "" : request.getParameter("SEARCHNAME");
		mav.addObject("SEARCHNAME", searchName);		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchBuyPurposePopup");	
		return mav;
	}	
	
	/**
	  * openSearchBuyPurposePopupList - 구매목적조회
	  * @author 이병주
	  * @param request
	  * @return Map
	  */
	@RequestMapping(value="openSearchBuyPurposePopupList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchBuyPurposePopupList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		String searchNm = request.getParameter("SEARCH_NM") == null ? "" : request.getParameter("SEARCH_NM");

	    Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("SEARCH_NM", searchNm);
	
		List<Map<String, Object>> gridDataList = PopupService.getOpenSearchBuyPurposePopupList(paramMap);
		
		resultMap.put("gridDataList", gridDataList);
		return resultMap;
	}
	
	/**
	  * openProductCouponPopup - 상품검색 (쿠폰/프로모션) 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openProductCouponPopup.sis", method=RequestMethod.POST)
	public ModelAndView openProductCouponPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName(DEFAULT_PATH + "/" + "openProductCouponPopup");
		return mav;
	}
	
	/**
	  * openCustomerCouponPopup -  고객검색 (쿠폰/프로모션) 팝업
	  * @author 양중호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openCustomerCouponPopup.sis", method=RequestMethod.POST)
	public ModelAndView openCustomerCouponPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName(DEFAULT_PATH + "/" + "openCustomerCouponPopup");
		return mav;
	}
	
	/**
	  * openSearchDeliveryPopup -  배송조회 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchDeliveryPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchDeliveryPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		mav.addObject("CUST_CODE", custCode);			
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchDeliveryPopup");
		return mav;
	}	
	
	/**
	  * openSearchDeliveryList - 배송목록조회 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openSearchDeliveryList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchDeliveryList(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		Map<String, Object> paramMap = commonUtil.getParamValueMap(request);
		
		try{
			List<Map<String,Object>> gridDataList = PopupService.getOpenSearchDeliveryList(paramMap);			
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}	
	
	/**
	  * openSearchDeliveryCUD - 배송목록조회 팝업 배송지수정
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openSearchDeliveryCUD.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchDeliveryCUD(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		Map<String, Object> paramMap = commonUtil.getParamValueMap(request);
		paramMap.put("MEMBER_CD", commonUtil.getEmpSessionDto(request).getMember_cd());
		paramMap.put("MEMBER_NM", commonUtil.getEmpSessionDto(request).getMember_nm());
		paramMap.put("WAREA_CD", commonUtil.getEmpSessionDto(request).getMember_warea_cd());
		
		int resultRowCnt = PopupService.updateOpenSearchDeliveryCUD(paramMap);
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}	
	
	/**
	  * openSearchOrderCustomerList - 배송목록조회 주문고객찾기 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openSearchOrderCustomerList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchOrderCustomerList(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		Map<String, Object> paramMap = commonUtil.getParamValueMap(request);
		
		try{
			List<Map<String,Object>> gridDataList = PopupService.getOpenSearchOrderCustomerList(paramMap);			
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}	
	
	/**
	  * openSearchDeliveryCustomerPopup - 주문고객찾기 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchDeliveryCustomerPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchDeliveryCustomerPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		
		String searchType = request.getParameter("SEARCHTYPE") == null ? "" : request.getParameter("SEARCHTYPE");
		String searchText = request.getParameter("SEARCHTEXT") == null ? "" : request.getParameter("SEARCHTEXT");
		String searchdeliveryCd = request.getParameter("SEARCHDELIVERYCD") == null ? "" : request.getParameter("SEARCHDELIVERYCD");

		mav.addObject("SEARCHTYPE", searchType);		
		mav.addObject("SEARCHTEXT", searchText);
		mav.addObject("SEARCHDELIVERYCD", searchdeliveryCd);		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchDeliveryCustomerPopup");	
		return mav;
	}	
	
	/**
	  * openSearchOrderCustomerDetailList - 배송목록조회 주문고객찾기목록 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openSearchOrderCustomerDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchOrderCustomerDetailList(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		Map<String, Object> paramMap = commonUtil.getParamValueMap(request);
		
		try{
			List<Map<String,Object>> gridDataList = PopupService.getOpenSearchOrderCustomerDetailList(paramMap);			
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}		
	
	/**
	  * openSearchDeliveryDupCheckList - 배송목록조회 중복확인
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openSearchDeliveryDupCheckList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchDeliveryDupCheckList(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		Map<String, Object> paramMap = commonUtil.getParamValueMap(request);
		
		try{
			List<Map<String,Object>> gridDataList = PopupService.getOpenSearchDeliveryDupCheckList(paramMap);			
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}	
	
	/**
	  * saveDeliveryBatchAssignCUD - 배송지일괄등록 처리
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="saveDeliveryBatchAssignCUD.do", method=RequestMethod.POST)
	public Map<String, Object> saveDeliveryBatchAssignCUD(HttpServletRequest request) throws SQLException, Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String member_cd = empSessionDto.getMember_cd();
		String warea_cd = empSessionDto.getMember_warea_cd();
		
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("MEMBER_CD", member_cd);
			dhtmlxParamMap.put("WAREA_CD", warea_cd);
		}
		
		int resultRowCnt = PopupService.updateSaveDeliveryBatchAssignCUD(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}	
	
	/**
	  * openSearchFavoriteGoodsPopup -  선호상품 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchFavoriteGoodsPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchFavoriteGoodsPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		mav.addObject("CUST_CODE", custCode);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchFavoriteGoodsPopup");
		return mav;
	}	
	
	/**
	  * openSearchFavoriteGoodsList - 선호상품 목록
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openSearchFavoriteGoodsList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchFavoriteGoodsList(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		Map<String, Object> paramMap = commonUtil.getParamValueMap(request);
		
		try{
			List<Map<String,Object>> gridDataList = PopupService.getOpenSearchFavoriteGoodsList(paramMap);			
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}		
	
	/**
	  * openSearchIntroduceCustomerPopup -  소개한고객 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchIntroduceCustomerPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchIntroduceCustomerPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		mav.addObject("CUST_CODE", custCode);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchIntroduceCustomerPopup");
		return mav;
	}		
	
	/**
	  * openSearchIntroduceCustomerList - 소개한고객 목록
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openSearchIntroduceCustomerList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchIntroduceCustomerList(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		Map<String, Object> paramMap = commonUtil.getParamValueMap(request);
		
		try{
			List<Map<String,Object>> gridDataList = PopupService.getOpenSearchIntroduceCustomerList(paramMap);			
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}		
	
	/**
	  * openSearchCustomerGradePopup -  회원등급 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchCustomerGradePopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchCustomerGradePopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		mav.addObject("CUST_CODE", custCode);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchCustomerGradePopup");
		return mav;
	}		
	
	/**
	  * openSearchCustomerGradeList - 회원등급 목록
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openSearchCustomerGradeList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchCustomerGradeList(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		Map<String, Object> paramMap = commonUtil.getParamValueMap(request);
		
		try{
			List<Map<String,Object>> gridDataList = PopupService.getOpenSearchCustomerGradeList(paramMap);			
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}	
	
	/**
	  * openSearchHappyCallProcPopup -  해피콜처리 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchHappyCallProcPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchHappyCallProcPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		
		String param1 = request.getParameter("param1") == null ? "" : request.getParameter("param1");
		String param2 = request.getParameter("param2") == null ? "" : request.getParameter("param2");
		String param3 = request.getParameter("param3") == null ? "" : request.getParameter("param3");
		String param4 = request.getParameter("param4") == null ? "" : request.getParameter("param4");
		String param5 = request.getParameter("param5") == null ? "" : request.getParameter("param5");
		
		mav.addObject("param1", param1);
		mav.addObject("param2", param2);
		mav.addObject("param3", param3);
		mav.addObject("param4", param4);
		mav.addObject("param5", param5);
		
		Map<String, Object> paramMap = commonUtil.getParamValueMap(request);
		Map<String,Object> contentsData = PopupService.getCustomerCounselhappyCallProcPopupSearch(paramMap);			
		request.setAttribute("contentsData", contentsData);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchHappyCallProcPopup");
		return mav;
	}	
	
	/**
	  * customerCounselhappyCallProcPopupCUD - 해피콜처리 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="customerCounselhappyCallProcPopupCUD.do", method=RequestMethod.POST)
	public Map<String, Object> customerCounselhappyCallProcPopupCUD(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		Map<String, Object> paramMap = commonUtil.getParamValueMap(request);
		paramMap.put("MEMBER_CD", commonUtil.getEmpSessionDto(request).getMember_cd());
		paramMap.put("MEMBER_NM", commonUtil.getEmpSessionDto(request).getMember_nm());
		paramMap.put("WAREA_CD", commonUtil.getEmpSessionDto(request).getMember_warea_cd());
		paramMap.put("CRUD", "C");
		
		int resultRowCnt = PopupService.updateCustomerCounselhappyCallProcPopupCUD(paramMap);
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}	
	
	/**
	  * openSearchMedicalExaminationByInterviewPopup -  문진표 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchMedicalExaminationByInterviewPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchMedicalExaminationByInterviewPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		mav.addObject("CUST_CODE", custCode);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchMedicalExaminationByInterviewPopup");
		return mav;
	}		
	
	/**
	  * openSearchMedicalExaminationByInterviewPopupList - 문진표팝업 목록
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openSearchMedicalExaminationByInterviewPopupList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchMedicalExaminationByInterviewPopupList(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		Map<String, Object> paramMap = commonUtil.getParamValueMap(request);
		
		String[] articleCodeList = new String[0];
		List<String> articleCodeArr = new ArrayList<>();		
		if (request.getParameterValues("CHECKLIST") != null) articleCodeList = request.getParameterValues("CHECKLIST");
		for(String item : articleCodeList){
			articleCodeArr.add(item.trim());
		}
		
		paramMap.put("ARTICEL_CODE_LIST", articleCodeArr);
		
		try{
			List<Map<String,Object>> gridDataList = PopupService.getOpenSearchMedicalExaminationByInterviewPopupList(paramMap);			
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}	
	
	/**
	  * openCustomerRegPopup - 고객상담 -고객정보 등록 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openCustomerRegPopup.sis", method=RequestMethod.POST)
	public ModelAndView openCustomerRegPopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();	
		String departmentKbn = request.getParameter("departmentKbn") == null ? "" : request.getParameter("departmentKbn");
		String ROUTE_DIV = request.getParameter("ROUTE_DIV") == null ? "" : request.getParameter("ROUTE_DIV");
		
		mav.addObject("departmentKbn", departmentKbn);
		mav.addObject("ROUTE_DIV", ROUTE_DIV);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openCustomerRegPopup");
		return mav;
	}
	
	/**
	  * openSearchDeliveryPopup2 -  배송조회 팝업
	  * @author 김동현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchDeliveryPopup2.sis", method=RequestMethod.POST)
	public ModelAndView openSearchDeliveryPopup2(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		mav.addObject("CUST_CODE", custCode);			
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchDeliveryPopup2");
		return mav;
	}
	
	/**
	  * openRecordPlayerPopup - 팝업 - 녹취 재생 팝업
	  * @author 유가영
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openRecordPlayerPopup.sis", method=RequestMethod.POST)
	public ModelAndView openRecordPlayerPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		
		String mp3Path = request.getParameter("mp3Path");
		String callDay = request.getParameter("callDay");
		
		int idx = mp3Path.indexOf("+"); 
		callDay = mp3Path.substring(idx+1);
		mp3Path = mp3Path.substring(0, idx);
		
		if(mp3Path.substring(0,1).equals("U")){
			Map<String, Object> paramMap =  new HashMap<String, Object>();
			Map<String, Object> resultMap = new HashMap<String, Object>();
			paramMap.put("CALL_RECORD", mp3Path.substring(1));
			resultMap = PopupService.getCallRecordFilePath(paramMap);
			mp3Path = "http://210.223.33.17/" + (String) resultMap.get("filePath");
		}
		
		mav.addObject("mp3Path", mp3Path);
		mav.addObject("callDay", callDay);
		
		mav.setViewName(DEFAULT_PATH + "/" + "recordPlayerPopup");
		return mav;
	}
	
	/**
	  * openSearchPromotionPopup -  프로모션상세 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchPromotionPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchPromotionPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String promotionCd = request.getParameter("promotionCd") == null ? "" : request.getParameter("promotionCd");
		mav.addObject("PROMOTIONCD", promotionCd);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchPromotionPopup");
		return mav;
	}	
	
	/**
	  * openSearchCustomerCounselCouponPopup -  고객상담 쿠폰 팝업
	  * @author 이병주
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchCustomerCounselCouponPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchCustomerCounselCouponPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		mav.addObject("CUST_CODE", custCode);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchCustomerCounselCouponPopup");
		return mav;
	}
	
	
	/**
	  * telephoneCallPopup - 고객상담 - 전화걸기
	  * @author 조승현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="telephoneCallPopup.sis", method=RequestMethod.POST)
	public ModelAndView telephoneCallPopup(HttpServletRequest request){
		Map<String, Object> paramMap =  new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String member_Cd = empSessionDto.getMember_cd();
		paramMap.put("member_Cd", member_Cd);
		
		String representNumber = "0";
		
		try {
			resultMap = PopupService.getRepresentNumber(paramMap);
			
			if(!resultMap.isEmpty()){
				representNumber = resultMap.get("MyPhone_Number").toString();
			}
		} catch (SQLException e) {
		} catch (Exception e) {
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("representNumber", representNumber);
		mav.setViewName(DEFAULT_PATH + "/" + "telephoneCallPopup");
		return mav;
	}
	
	/**
	  * telephoneReceivePopup - 고객상담 - 전화받기
	  * @author 조승현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="telephoneReceivePopup.sis", method=RequestMethod.POST)
	public ModelAndView telephoneReceivePopup(HttpServletRequest request){
		String calling_Number = request.getParameter("calling_Number");
		String receive_Number = request.getParameter("receive_Number");
		String customer_Code = "";
		String customer_Gender = "";
		String customer_Name = "";
		String customer_Age = "";
		String call_Info = "일반연결";
		String call_Ars = "";
		String call_Dupli = "";
		int cnt;
		
		if(receive_Number.equals("0221838096")){
			call_Info="폐쇄몰";
		}
		
		Map<String, Object> paramMap =  new HashMap<String, Object>();
		List<Map<String,Object>> resultList;
		paramMap.put("calling_Number", calling_Number);
		
		try {
			resultList = PopupService.getCallingCustomerData(paramMap);
			cnt = resultList.size();
			
			if(cnt == 0){
				if(customer_Code.equals("")){
					customer_Code = "48317977"; //신규고객 코드
				}
				if(customer_Name.equals("")){
					customer_Name = "신규고객";
				}
				
			}else{
				customer_Code = (String) resultList.get(0).get("customer_Code");
				customer_Gender = (String) resultList.get(0).get("customer_Gender");
				customer_Name = (String) resultList.get(0).get("customer_Name");
				customer_Age = (String) resultList.get(0).get("customer_Age");
				
				cnt = resultList.size();
				if(cnt > 1){
					for(int i=1; i<cnt; i++){
						call_Dupli += (String) resultList.get(i).get("customer_Code")+"("+ (String) resultList.get(i).get("customer_Name")+")";
						if(i != cnt - 1){
							call_Dupli += " / ";
						}
					}
				}
			}
		} catch (SQLException e) {
			//call_Dupli = e.getMessage();
		} catch (Exception e) {
			//call_Dupli = e.getMessage();
		}
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("calling_Number", calling_Number);
		mav.addObject("receive_Number", receive_Number);
		mav.addObject("customer_Code", customer_Code);
		mav.addObject("customer_Gender", customer_Gender);
		mav.addObject("customer_Name", customer_Name);
		mav.addObject("customer_Age", customer_Age);
		mav.addObject("call_Info", call_Info);
		mav.addObject("call_Ars", call_Ars);
		mav.addObject("call_Dupli", call_Dupli);
		mav.setViewName(DEFAULT_PATH + "/" + "telephoneReceivePopup");
		return mav;
	}
	
	/**
	  * callChangePopup - 고객상담 - 콜 전환 팝업
	  * @author 유가영
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="callChangePopup.sis", method=RequestMethod.POST)
	public ModelAndView callChangePopup(HttpServletRequest request){
		String member_InPhone = request.getParameter("member_InPhone");
		String cti_Flag = request.getParameter("CTI_Flag");
		String inout = request.getParameter("inout");
		ModelAndView mav = new ModelAndView();
		mav.addObject("member_InPhone", member_InPhone);
		mav.addObject("cti_Flag", cti_Flag);
		mav.addObject("inout", inout);
		mav.setViewName(DEFAULT_PATH + "/" + "callChangePopup");
		return mav;
	}
	
	/**
	  * getMemberStatus - 고객상담 - 상담원 상태 조회
	  * @author 유가영
	  * @param request
	  * @return Map
	  */
	@RequestMapping(value="getMemberStatus.do", method=RequestMethod.POST)
	public Map<String, Object> getMemberStatus(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		List<Map<String, Object>> gridDataList = PopupService.getMemberStatus();
		resultMap.put("gridDataList", gridDataList);
		return resultMap;
	}
	
	/**
	  * getCheckMemberStatus - 고객상담 - 호전환 이전에 상담원 상태 체크
	  * @author 유가영
	  * @param request
	  * @return Map
	  */
	@RequestMapping(value="getCheckMemberStatus.do", method=RequestMethod.POST)
	public Map<String, Object> getCheckMemberStatus(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> paramMap =  new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String,Object>();
		String changeInPhone = request.getParameter("changeInPhone");
		paramMap.put("changeInPhone", changeInPhone);
		resultMap = PopupService.getCheckMemberStatus(paramMap);
		if(resultMap.size() > 1){
			resultMap.clear();
			resultMap.put("memberStatus", "dupli");
		}
		return resultMap;
	}

	/**
	  * telephoneRecording - 고객상담 - 녹취
	  * @author 조승현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="telephoneRecording.sis", method=RequestMethod.POST)
	public ModelAndView telephoneRecording(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.addObject("toDayYYYYMMDD",CommonUtil.calTodayYYYYMMDD());
		mav.setViewName(DEFAULT_PATH + "/" + "telephoneRecording");
		return mav;
	}
	

	/**
	  * openSearchGoodsCdPopup - 팝업 - 윈플러스몰 상품조회 팝업
	  * @author 고용선
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchChmProductPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchChmProductPopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String searchProductName = request.getParameter("ProductName") == null ? "" : request.getParameter("ProductName");
		String searchProductCode = request.getParameter("ProductCode") == null ? "" : request.getParameter("ProductCode");
		
		
		mav.addObject("ProductName", searchProductName);
		mav.addObject("ProductCode", searchProductCode);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchChmProductPopup");
		return mav;
	}	
	
	/**
	  * openSearchChmCouponPopup - 팝업 - 윈플러스몰 쿠폰조회 팝업
	  * @author kang htun kyu
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchChmCouponPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchChmCouponPopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("ICouponName", request.getParameter("ICouponName") == null ? "" : request.getParameter("ICouponName"));
		mav.addObject("ICouponCode", request.getParameter("ICouponCode") == null ? "" : request.getParameter("ICouponCode"));
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchChmCouponPopup");
		return mav;
	}	

	/**
	  * openSearchProductItemPopup - 팝업 - 윈플러스몰 아이템조회 팝업
	  * @author 고용선
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchProductItemPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchProductItemPopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
//		String searchName = request.getParameter("ItemName") == null ? "" : request.getParameter("ItemName");
//		String searchCode = request.getParameter("ItemCode") == null ? "" : request.getParameter("ItemCode");
//		mav.addObject("ItemName", searchName);
//		mav.addObject("ItemCode", searchCode);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchProductItemPopup");
		return mav;
	}	
	
	/**
	  * openSearchFavoriteGoodsPopup -  보관분 팝업
	  * @author 주병훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchStoragePopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchStoragePopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		String custCode = request.getParameter("custCode") == null ? "" : request.getParameter("custCode");
		mav.addObject("CUST_CODE", custCode);
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchStoragePopup");
		return mav;
	}	
	
	/**
	  * openSearchFavoriteGoodsList - 보관분 목록
	  * @author 주병훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openSearchStorageList.do", method=RequestMethod.POST)
	public Map<String, Object> openSearchStorageList(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		Map<String, Object> paramMap = commonUtil.getParamValueMap(request);
		
		try{
			List<Map<String,Object>> gridDataList = PopupService.getOpenSearchStorageList(paramMap);			
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}	
	
	/**
	  * insertImagePopup - 윈플러스몰 - 상품관리 - 이미지 등록 팝업
	  * @author 고용선
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "insertImagePopup.sis", method=RequestMethod.POST)
	public ModelAndView insertImagePopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		String productCode = request.getParameter("ProductCode") == null ? "" : request.getParameter("ProductCode");
		String itemCode = request.getParameter("ItemCode") == null ? "" : request.getParameter("ItemCode");
		String pPakageItemUpdetail = request.getParameter("PPakageItemUpdetail") == null ? "" : request.getParameter("PPakageItemUpdetail");
		String pPakageItemUpdetailM = request.getParameter("PPakageItemUpdetailM") == null ? "" : request.getParameter("PPakageItemUpdetailM");
		String GUBUN  = request.getParameter("GUBUN")  == null ? "" : request.getParameter("GUBUN");
		
		mav.addObject("ProductCode",productCode);
		mav.addObject("ItemCode",itemCode);
		mav.addObject("PPakageItemUpdetail",pPakageItemUpdetail);
		mav.addObject("PPakageItemUpdetailM",pPakageItemUpdetailM);
		mav.addObject("GUBUN",GUBUN);
		mav.setViewName(DEFAULT_PATH + "/" + "insertImagePopup");
		return mav;	
	}
	
	/**
	  * searchMemberCodePopup - 팝업 - 멤버 코드 조회
	  * @author 조승현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchMemberCodePopup.sis", method=RequestMethod.POST)
	public ModelAndView searchMemberCodePopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName(DEFAULT_PATH + "/" + "searchMemberCodePopup");
		return mav;
	}

	/**
	  * deliveryDelete - 배송목록조회 팝업 배송지수정
	  * @author 하혜민
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="deliveryDelete.do", method=RequestMethod.POST)
	public Map<String, Object> deliveryDelete(HttpServletRequest request) throws SQLException, Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ORDER_DIDX", request.getParameter("ORDER_DIDX"));
		paramMap.put("CRUD", "U");
		
		int resultRowCnt = PopupService.deliveryDelete(paramMap);
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}	
	
	/**
	  * openChmImageViewPopup - 윈플러스몰 - 이미지 미리보기 팝업
	  * @author 고용선
	  * @param request
	  * @return ModelAndView
	  */
	@SuppressWarnings("unused")
	@RequestMapping(value = "openChmImageViewPopup.sis", method=RequestMethod.POST)
	public ModelAndView openChmImageViewPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		String root = propertyManagement.getProperty("system.chm.staging.url");
		//공통 param 변수
		String pgmId = request.getParameter("PGM_ID") == null ? "" : request.getParameter("PGM_ID"); 
		String searchCode = request.getParameter("SearchCode") == null ? "" : request.getParameter("SearchCode");
		String searchName = request.getParameter("SearchName") == null ? "" : request.getParameter("SearchName");
		String searchUrl = request.getParameter("SearchUrl") == null ? "" : request.getParameter("SearchUrl");
		String searchType = request.getParameter("SearchType") == null ? "" : request.getParameter("SearchType"); 
		String param1 = request.getParameter("Param1") == null ? "" : request.getParameter("Param1"); 
		String param2 = request.getParameter("Param2") == null ? "" : request.getParameter("Param2"); 
		String param3 = request.getParameter("Param3") == null ? "" : request.getParameter("Param3"); 
		String param4 = request.getParameter("Param4") == null ? "" : request.getParameter("Param4"); 
		String param5 = request.getParameter("Param4") == null ? "" : request.getParameter("Param5"); 

		//공통 변수
		String content = "";
		String mobilePath = "";

		if("M".equals(searchType)) {
			mobilePath = "/MOBILE";
		}
		//PRM_ID 별 처리
		if("EventBasicManagement".equals(pgmId)) {
			content = root+mobilePath+"/eventlist"+searchUrl;			
		} else if("ProductBanner".equals(pgmId)) {
			content = root+"/productbanner"+searchUrl;			
		} else if("BrandBanner".equals(pgmId)) {
			content = root+"/brand"+searchUrl;		
		} else if("EventWinner".equals(pgmId)) {
			root = propertyManagement.getProperty("system.chm.real.url");
			content = root+"/eventwinner"+searchUrl;				
		} else if("EventSearchBanner".equals(pgmId)) {
			content = root+mobilePath+"/searchbanner"+searchUrl;
		} else if("EventManagement".equals(pgmId)) {				// 이벤트 페이지 노출 관리
			root = propertyManagement.getProperty("system.chm.real.url");
			content = root+mobilePath+"/eventpage"+searchUrl;
		} else if("InfoPopup".equals(pgmId)) {
			content = root+mobilePath+"/popup_management"+searchUrl;
			//logger.debug("content ==== "+ content);
		}
		
		//공통 return
		mav.addObject("SearchCode", request.getParameter("SearchCode"));
		mav.addObject("SearchName", request.getParameter("SearchName"));
		mav.addObject("content", content);

		mav.setViewName(DEFAULT_PATH + "/" + "openChmImageViewPopup");
		return mav;	
	}	

	/**
	  * openSearchChmEventPopup - 팝업 - 윈플러스몰 행사조회 팝업
	  * @author 고용선
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openSearchChmEventPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchChmEventPopup(HttpServletRequest request) throws SQLException, Exception {
		
		ModelAndView mav = new ModelAndView();
		String searchName = request.getParameter("searchName") == null ? "" : request.getParameter("searchName");
		String searchCode = request.getParameter("searchCode") == null ? "" : request.getParameter("searchCode");
		
		
		mav.addObject("EBasicTitle", searchName);
		mav.addObject("EBasicCode", searchCode);
		
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchChmEventPopup");
		return mav;
	}	
	
	/**
	  * openOrderDSendWayAllChangePopup - 배송지 일괄 변경 팝업
	  * @author 조승현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openOrderDSendWayAllChangePopup.sis", method=RequestMethod.POST)
	public ModelAndView openOrderDSendWayAllChangePopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openOrderDSendWayAllChangePopup");
		return mav;
	}
	
	/**
	 * updateRepresentNm - [전화걸기 팝업] - 대표번호 변경
	 * 
	 * @author 유가영
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="updateRepresentNm.do", method=RequestMethod.POST)
	public Map<String, Object> updateRepresentNm(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String member_cd = empSessionDto.getMember_cd();
		String MyPhone_Number = request.getParameter("MyPhone_Number") == null ? "" : request.getParameter("MyPhone_Number");
		String preNumber = request.getParameter("preNumber") == null ? "" : request.getParameter("preNumber");
		
		paramMap.put("member_cd", member_cd);
		paramMap.put("MyPhone_Number", MyPhone_Number);
		paramMap.put("preNumber", preNumber);
		
		int resultRowCnt = PopupService.updateRepresentNm(paramMap);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}	
	
	/**
	 * openCouponTargetCustomerPopup - 쿠폰 대상고객 추가 팝업
	 * 
	 * @author 유가영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "openCouponTargetCustomerPopup.sis", method=RequestMethod.POST)
	public ModelAndView openCouponTargetCustomerPopup(HttpServletRequest request) throws SQLException, Exception {				
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openCouponTargetCustomerPopup");
		return mav;
	}
	
	
///////////////////////////////////윈플러스 개발 추가///////////////////////////////////
	
	/**
	 * openSlipLogDetailPopup - 전표이력조회 이력보기 팝업
	 * 
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openSlipLogDetailPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSlipLogDetailPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		String Slip_CD = request.getParameter("Slip_CD") == null ? "" : request.getParameter("Slip_CD");
		mav.addObject("Slip_CD", Slip_CD);
		mav.setViewName(DEFAULT_PATH + "/" + "openSlipLogDetailPopup");
		return mav;
	}	
	
	/**
	 * 점포업무관리 - 특매관리- 새 특매그룹 추가 팝업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openAddNewBargainGroupPopup.sis", method=RequestMethod.POST)
	public ModelAndView openAddNewBargainGroupPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("sis/market" + "/" + "openAddNewBargainGroupPopup");
		return mav;
	}
	
	/**
	 * 점포업무관리 - 특매판매내역- 특매그룹선택 팝업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openBargainGroupPointPopup.sis", method=RequestMethod.POST)
	public ModelAndView openBargainGroupPointPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("sis/market" + "/" + "openBargainGroupPointPopup");
		return mav;
	}
	
	/**
	 * 점포업무관리 - 특매판매내역 - 특매그룹선택 팝업 -특매그룹조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getOpenBargainGroupPointList.do", method=RequestMethod.POST)
	public Map<String, Object> getOpenBargainGroupPointList(HttpServletRequest request,@RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> getOpenBargainGroupPointList = PopupService.getOpenBargainGroupPointList(paramMap);
		resultMap.put("gridDataList", getOpenBargainGroupPointList);
		return resultMap;
	}
	
	/**
	 * 점포업무관리 -마감내역 -단말 담당자 마감정보 팜업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openPosManagerInfoPopup.sis", method=RequestMethod.POST)
	public ModelAndView openPosManagerInfoPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("sis/market" + "/" + "openPosManagerInfoPopup");
		return mav;
	}
	
	/**
	 * 점포업무관리 -마감내역 -단말 담당자 마감정보 팜업 -상품권 조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getGiftCardList.do", method=RequestMethod.POST)
	public Map<String, Object> getGiftCardList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = PopupService.getGiftCardList(paramMap);
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
	/**
	 * 점포업무관리 - 단말 담당자 마감정보 팜업 - 마감정보 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="savePosManagementInfo.do", method=RequestMethod.POST)
	public Map<String, Object> savePosManagementInfo(HttpServletRequest request) throws SQLException, Exception{
		Map<String,Object> resultMap = new HashMap<String,Object>();
		Map<String,Object> paramMap = new HashMap<String,Object>();
		
		int resultCnt = 0;
		
		String SALE_CASH_TOT_AMT = request.getParameter("SALE_CASH_TOT_AMT");
		String CLSE_CD = request.getParameter("CLSE_CD");
		String ORGN_CD = request.getParameter("ORGN_CD");
		
		paramMap.put("SALE_CASH_TOT_AMT", SALE_CASH_TOT_AMT);
		paramMap.put("CLSE_CD", CLSE_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		
		resultCnt = PopupService.savePosManagementInfo(paramMap);
		resultMap.put("resultCnt", resultCnt);
		
		return resultMap;
	}
	
	/**
	 * 점포업무관리 - 마감내역- 단말 담당자 마감정보 팜업 - 현금 입금액 입력 팝업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openAddDepositCashPopup.sis", method=RequestMethod.POST)
	public ModelAndView openAddDepositCashPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("sis/market" + "/" + "openAddDepositCashPopup");
		return mav;
	}
	
	/**
	 * 점포업무관리 - 마감내역- 단말 담당자 마감정보 팜업 - 현금 입금액 입력 팝업 - 조회
	 * @author 최지민
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getCashCntList.do", method=RequestMethod.POST)
	public Map<String, Object> getCashCntList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> dataList = PopupService.getCashCntList(paramMap);
		resultMap.put("dataList", dataList);
		
		return resultMap;
	}
	
	
	/**
	 * 점포업무관리 - 마감내역- 단말 담당자 마감정보 팜업 - 현금 입금액 입력 팝업 - 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="saveDepositCash.do", method=RequestMethod.POST)
	public Map<String, Object> saveDepositCash(HttpServletRequest request) throws SQLException, Exception{
		Map<String,Object> resultMap = new HashMap<String,Object>();
		Map<String,Object> paramMap = new HashMap<String,Object>();
		
		int resultCnt = 0;
		
		String SALE_CASH_TOT_AMT = request.getParameter("SALE_CASH_TOT_AMT");
		String CLSE_CD = request.getParameter("CLSE_CD");
		String ORGN_CD = request.getParameter("ORGN_CD");
		String CASH_CNT_01 = request.getParameter("CASH_CNT_01");
		String CASH_CNT_02 = request.getParameter("CASH_CNT_02");
		String CASH_CNT_03 = request.getParameter("CASH_CNT_03");
		String CASH_CNT_04 = request.getParameter("CASH_CNT_04");
		String CASH_CNT_05 = request.getParameter("CASH_CNT_05");
		String CASH_CNT_06 = request.getParameter("CASH_CNT_06");
		String CASH_CNT_07 = request.getParameter("CASH_CNT_07");
		String CASH_CNT_08 = request.getParameter("CASH_CNT_08");
		String CASH_CNT_09 = request.getParameter("CASH_CNT_09");
		String CASH_CNT_10 = request.getParameter("CASH_CNT_10");
		
		paramMap.put("SALE_CASH_TOT_AMT", SALE_CASH_TOT_AMT);
		paramMap.put("CLSE_CD", CLSE_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("CASH_CNT_01", CASH_CNT_01);
		paramMap.put("CASH_CNT_02", CASH_CNT_02);
		paramMap.put("CASH_CNT_03", CASH_CNT_03);
		paramMap.put("CASH_CNT_04", CASH_CNT_04);
		paramMap.put("CASH_CNT_05", CASH_CNT_05);
		paramMap.put("CASH_CNT_06", CASH_CNT_06);
		paramMap.put("CASH_CNT_07", CASH_CNT_07);
		paramMap.put("CASH_CNT_08", CASH_CNT_08);
		paramMap.put("CASH_CNT_09", CASH_CNT_09);
		paramMap.put("CASH_CNT_10", CASH_CNT_10);
		
		resultCnt = PopupService.saveDepositCash(paramMap);
		resultMap.put("resultCnt", resultCnt);
		
		return resultMap;
	}
	
	/**
	 * 점포업무관리 - 마감내역 - 직원선택 팝업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openSelectEmpPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSelectEmpPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("sis/market" + "/" + "openSelectEmpPopup");
		return mav;
	}
	
	/**
	 * 점포업무관리 - 마감내역 - 직원선택 팝업 - 직원조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getSelectEmpList.do", method=RequestMethod.POST)
	public Map<String, Object> getSelectEmpList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = PopupService.getSelectEmpList(paramMap);
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
	
	/**
	 * 재고관리 - 재고실사관리 - 재고실사관리 상세목록 팝업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openStockInspListPopup.sis", method=RequestMethod.POST)
	public ModelAndView openStockInspListPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("sis/stock/stockManagement" + "/" + "openStockInspListPopup");
		return mav;
	}

	/**
	 * 재고관리 - 재고실사관리 - 재고실사관리 상세목록 팝업
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getStockInspListPopup.do", method=RequestMethod.POST)
	public Map<String, Object> getStockInspListPopup(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = PopupService.getStockInspListPopup(paramMap);
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openPlusFriendTalkPopup.sis", method=RequestMethod.POST)
	public ModelAndView openPlusFriendTalkPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("sis/member" + "/" + "openPlusFriendTalkPopup");
		return mav;
	}
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 -회원검색팝업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openSearchMemberPopup.sis", method=RequestMethod.POST)
	public ModelAndView openSearchMemberPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("sis/member" + "/" + "openSearchMemberPopup");
		return mav;
	}
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 -회원검색팝업 조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "getSearchMember.do", method = RequestMethod.POST)
	public Map<String, Object> getSearchMember(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = PopupService.getSearchMember(paramMap);
		resultMap.put("gridDataList", gridDataList);
	
		return resultMap;
	}
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 - 회원추가
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="addSearchMemberList.do", method=RequestMethod.POST)
	public Map<String, Object> addSearchMemberList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = PopupService.addSearchMemberList(paramMap);
		resultMap.put("gridDataList", gridDataList);
	
		return resultMap;
	}

	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 - 회원붙여넣기
	 * @author 최지민
	 * @param request
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="getMemberInformation.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberInformation(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", PopupService.getMemberInformation(paramMap));
		return resultMap;
	}
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 - 발송
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="saveSendTalk.do", method=RequestMethod.POST)
	public Map<String, Object> saveSendTalk(HttpServletRequest request, @RequestBody Map<String,Object> dataMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
	
		int resultRowCnt=0;
		
		resultRowCnt = PopupService.saveSendTalk(dataMap);
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}
	
	/**
	 * 점포업무관리 - 이종상품묶음할인 - 이종상품그룹 등록 팝업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openNewBundleGroupPopup.sis", method=RequestMethod.POST)
	public ModelAndView openNewBundleGroupPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("sis/market" + "/" + "openNewBundleGroupPopup");
		return mav;
	}
	
	/**
	 * 점포업무관리 - 이종상품묶음할인 - 이종상품그룹 수정 팝업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openRetouchBundlePopup.sis", method=RequestMethod.POST)
	public ModelAndView openRetouchBundlePopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("sis/market" + "/" + "openRetouchBundlePopup");
		return mav;
	}
	
	/**
	 * 점포업무관리 - 이종상품묶음할인 - 이종상품그룹 수정 팝업 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="saveBundleGroupInfo.do", method=RequestMethod.POST)
	public Map<String, Object> saveBundleGroupInfo(HttpServletRequest request) throws SQLException, Exception{
		Map<String,Object> resultMap = new HashMap<String,Object>();
		Map<String,Object> paramMap = new HashMap<String,Object>();
		
		int resultCnt = 0;
		
		String MEMO = request.getParameter("MEMO");
		String ORGN_CD = request.getParameter("ORGN_CD");
		String BUDL_CD = request.getParameter("BUDL_CD");
		String BUDL_NM = request.getParameter("BUDL_NM");
		String BUDL_STRT_DATE = request.getParameter("BUDL_STRT_DATE");
		String BUDL_END_DATE = request.getParameter("BUDL_END_DATE");
		String BUDL_STATE = request.getParameter("BUDL_STATE");
		String BUDL_APPLY_UNIT = request.getParameter("BUDL_APPLY_UNIT");
		String BUDL_DC_TYPE = request.getParameter("BUDL_DC_TYPE");
		String BUDL_APPLY_VALUE = request.getParameter("BUDL_APPLY_VALUE");
		String POINT_SAVE_EX_YN = request.getParameter("POINT_SAVE_EX_YN");
		
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("BUDL_CD", BUDL_CD);
		paramMap.put("BUDL_NM", BUDL_NM);
		paramMap.put("BUDL_STRT_DATE", BUDL_STRT_DATE);
		paramMap.put("BUDL_END_DATE", BUDL_END_DATE);
		paramMap.put("BUDL_STATE", BUDL_STATE);
		paramMap.put("BUDL_APPLY_UNIT", BUDL_APPLY_UNIT);
		paramMap.put("BUDL_DC_TYPE", BUDL_DC_TYPE);
		paramMap.put("BUDL_APPLY_VALUE", BUDL_APPLY_VALUE);
		paramMap.put("POINT_SAVE_EX_YN", POINT_SAVE_EX_YN);
		paramMap.put("MEMO", MEMO);
		
		resultCnt = PopupService.saveBundleGroupInfo(paramMap);
		resultMap.put("resultCnt", resultCnt);
		
		return resultMap;
	}
	
	/**
	 * 점포업무관리 - 이종상품묶음할인 - 이종상품그룹 선택 팝업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openDoubleGroupPointPopup.sis", method=RequestMethod.POST)
	public ModelAndView openDoubleGroupPointPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("sis/market" + "/" + "openDoubleGroupPointPopup");
		return mav;
	}
	
	/**
	 * 점포업무관리 - 이종상품묶음할인 - 이종상품그룹 선택 팝업 조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getOpenDoubleGroupPointPopup.do", method=RequestMethod.POST)
	public Map<String, Object> getOpenDoubleGroupPointPopup(HttpServletRequest request,@RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> getOpenDoubleGroupPointPopup = PopupService.getOpenDoubleGroupPointPopup(paramMap);
		resultMap.put("gridDataList", getOpenDoubleGroupPointPopup);
		return resultMap;
	}
	/**
	 * 판매내역조회(회원) - 외상결제입력 팝업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openTrustSalesPopup.sis", method=RequestMethod.POST)
	public ModelAndView openTrustSalesPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openTrustSalesPopup");
		return mav;
	}
	
	/**
	 * 판매내역조회(회원) - 외상매출 팝업
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openAddTrustSalesPopup.sis", method=RequestMethod.POST)
	public ModelAndView openAddTrustSalesPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openAddTrustSalesPopup");
		return mav;
	}
}
