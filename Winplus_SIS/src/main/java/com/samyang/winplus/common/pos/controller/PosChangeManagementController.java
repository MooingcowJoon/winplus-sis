package com.samyang.winplus.common.pos.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.pos.service.PosChangeManagementService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;

@RestController
@RequestMapping("/common/pos/PosChangeManagement")
public class PosChangeManagementController extends BaseController{
	
	@Autowired
	PosChangeManagementService posChangeManagementService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final static String DEFAULT_PATH = "common/linkedPOS";
	
	/**
	 * 시스템관리 - POS연동관리 - 환경정보관리(POS연동) 
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="changeManagement.sis", method=RequestMethod.POST)
	public ModelAndView messageManagement(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "changeManagement");
		return mav;
	}
	
	/**
	 * 시스템관리 - POS연동관리 - 환경정보관리(POS연동) - 내역조회
	 * @author 정혜원
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getPosPreferences.do", method=RequestMethod.POST)
	public Map<String, Object> getPosPreferences(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();

		try{
			gridDataList = posChangeManagementService.getPosPreferences(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * openPosPreferencesByMarket - 환경정보관리(POS연동) - 상세팝업
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openPosPreferencesByMarket.sis", method = RequestMethod.POST)
	public ModelAndView openPosPreferencesByMarket(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("ORGN_CD", request.getParameter("ORGN_CD"));
		mav.setViewName(DEFAULT_PATH + "/" + "openPosPreferencesByMarket");
		return mav;
	}
	
	/**
	  * getPosPreferencesInfo
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getPosPreferencesInfo.do", method = RequestMethod.POST)
	public Map<String, Object> getPosPreferencesInfo(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> TableDataMap = new HashMap<String, Object>();
		
		try {
			resultMap = posChangeManagementService.getPosPreferencesInfo(paramMap);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * 메뉴명
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "savePosPreferencesInfo.do", method = RequestMethod.POST)
	public Map<String, Object> savePosPreferencesInfo(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int resultValue = 0;
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String EMP_NO = empSessionDto.getEmp_no();
		
		paramMap.put("EMP_NO", EMP_NO);
		paramMap.put("MPROGRM", "savePosPreferencesInfo");
		String MSG_HEAD = paramMap.get("MSG_HEAD").toString();
		String POINT_SAVE_TRUST = paramMap.get("POINT_SAVE_TRUST").toString();
		
		try {
			resultValue += posChangeManagementService.savePosPreferencesInfo(paramMap);
			resultMap.put("resultValue", resultValue);
		} catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
}

