package com.samyang.winplus.sis.order.controller;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.util.CommonUtil;
import com.samyang.winplus.sis.order.service.OrderDirectStoreService;

@RequestMapping("/sis/order")
@RestController
public class OrderDirectStoreController {
	
	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	protected CommonUtil commonUtil;
	
	@Autowired
	OrderDirectStoreService orderDirectStoreService;
	
	@SuppressWarnings("unused")
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/order";
	
	/**
	  * 구매관리 - 발주서상품관리 - 상품분류관리
	  * @author 강신영
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="orderRegistDirectStore.sis", method=RequestMethod.POST)
	public ModelAndView goodsCategoryManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "orderRegistDirectStore");
		return mav;
	}
	/*
	*//**
	  * getGoodsCategory - 상품분류관리 - 상품분류 항목 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  *//*
	@RequestMapping(value="getGoodsCategory.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsCategory(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String grup_cd = request.getParameter("GRUP_CD");
		if(grup_cd == null || grup_cd.length() == 0){
			String errMesage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("GRUP_CD", grup_cd);
			Map<String, Object> categoryMap = goodsCategoryService.getCategoryMap(paramMap);
			resultMap.put("dataMap", categoryMap);
		}
		return resultMap;
	}
	
	*//**
	  * updateGoodsCategory - 상품분류관리 - 상품분류 항목 저장
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  *//*
	@RequestMapping(value="updateGoodsCategory.do", method=RequestMethod.POST)
	public Map<String, Object> updateGoodsCategory(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String crud = request.getParameter("CRUD");
		String grup_cd = request.getParameter("GRUP_CD");
		String grup_nm = request.getParameter("GRUP_NM");
		String grup_top_cd = request.getParameter("GRUP_TOP_CD");
		String grup_mid_cd = request.getParameter("GRUP_MID_CD");
		String grup_bot_cd = request.getParameter("GRUP_BOT_CD");
		String grup_state = request.getParameter("GRUP_STATE");
		String grup_local_cd = request.getParameter("GRUP_LOCAL_CD");
		String currentErpTreeLvl = request.getParameter("currentErpTreeLvl");
		int treeLvlInt = 0;
		if(currentErpTreeLvl != null && !currentErpTreeLvl.equals("")) {
			treeLvlInt = Integer.parseInt(currentErpTreeLvl);
		}
		
		if(crud == null || crud.equals("")){				
			String errMesage = messageSource.getMessage("error.common.noChanged", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			if("C".equals(crud) || "U".equals(crud)){
				if(grup_nm == null || grup_nm.equals("")){
					String errMesage = messageSource.getMessage("error.sis.category.grup_nm.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1002";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(grup_nm.length() > 50){
					String errMesage = messageSource.getMessage("error.sis.category.grup_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1003";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(treeLvlInt >= 1 && (grup_top_cd == null || grup_top_cd.equals(""))) {
					String errMesage = messageSource.getMessage("error.sis.category.grup_top_cd.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1004";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(treeLvlInt >= 2 && (grup_mid_cd == null || grup_mid_cd.equals(""))) {
					String errMesage = messageSource.getMessage("error.sis.category.grup_mid_cd.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1005";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(treeLvlInt == 3 && (grup_bot_cd == null || grup_bot_cd.equals(""))) {
					String errMesage = messageSource.getMessage("error.sis.category.grup_bot_cd.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1006";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(grup_state == null || grup_state.equals("")){
					String errMesage = messageSource.getMessage("error.sis.category.grup_state.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1007";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);						
				} else if(grup_local_cd == null || grup_local_cd.equals("")){
					String errMesage = messageSource.getMessage("error.sis.category.grup_local_cd.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1008";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			}
		}
		if(resultMap.keySet().size() == 0){
			if("U".equals(crud) || "D".equals(crud)) {
				if(grup_nm == null || grup_nm.equals("")){
					String errMesage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1009";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			}
			
			if(resultMap.keySet().size() == 0){					
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("CRUD", crud);
				paramMap.put("GRUP_CD", grup_cd);
				paramMap.put("GRUP_NM", grup_nm);
				if(grup_top_cd != null && grup_top_cd.equals("")) {
					paramMap.put("GRUP_TOP_CD", "0");
				} else {
					paramMap.put("GRUP_TOP_CD", grup_top_cd);
				}
				if(grup_mid_cd != null && grup_mid_cd.equals("")) {
					paramMap.put("GRUP_MID_CD", "0");
				} else {
					paramMap.put("GRUP_MID_CD", grup_mid_cd);
				}
				if(grup_bot_cd != null && grup_bot_cd.equals("")) {
					paramMap.put("GRUP_BOT_CD", "0");
				} else {
					paramMap.put("GRUP_BOT_CD", grup_bot_cd);
				}
				paramMap.put("GRUP_STATE", grup_state);
				paramMap.put("GRUP_LOCAL_CD", grup_local_cd);
				paramMap.put("treeLvlInt", treeLvlInt);
				paramMap.put("EMP_NO", emp_no);
				
				String resultMsg = goodsCategoryService.updateGoodsCategory(paramMap);
				
				if(resultMsg.equals("9999")){
					String errMesage = messageSource.getMessage("error.sis.category.no_delete_child_goods", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1010";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}else{
					resultMap.put("resultMsg", resultMsg);
				}
			}
		}
		return resultMap;
	}*/
}