package com.samyang.winplus.common.system.menu.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.menu.service.SystemMenuService;
import com.samyang.winplus.common.system.model.EmpSessionDto;

/** 
 * 시스템관리 - 메뉴관리 컨트롤러  
 * @since 2017.03.21
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2017.03.22 / 김종훈 / 신규 생성
 *********************************************
 */
@RequestMapping("/common/system/menu")
@RestController
public class SystemMenuController extends BaseController {
	
	@Autowired
	SystemMenuService systemMenuService;
		
	private final static String DEFAULT_PATH = "common/system/menu";
	
	/**
	  * menuManagement - 메뉴관리 - 화면 조회
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="menuManagement.sis", method=RequestMethod.POST)
	public ModelAndView authorityManagement(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "menuManagement");
		return mav;
	}
	
	/**
	  * menuManagementR1 - 메뉴관리 - 메뉴 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="menuManagementR1.do", method=RequestMethod.POST)
	public Map<String, Object> menuManagementR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> allMenuMapList = systemMenuService.getAllMenuMapList();
		if(allMenuMapList.isEmpty()){
			String errMesage = messageSource.getMessage("error.common.system.authority.noMenu", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {				
			/* DhtmlxTree 에 맞추어 Result 데이터 재구성 */ 
			Map<String, Object> menuTreeMap = new HashMap<String, Object>();
			/* 최상위 메뉴를 위한 Root 최상위 메뉴 설정 */
			List<Map<String, Object>> rootMapList = new ArrayList<Map<String, Object>>();
			Map<String, Object> rootMap = new HashMap<String, Object>();				
			
			rootMap.put("id", "#root");
			rootMap.put("text", "Root");
			rootMap.put("item", allMenuMapList);
			rootMapList.add(rootMap);
			
			menuTreeMap.put("id", "0");
			menuTreeMap.put("item", rootMapList);
			resultMap.put("menuTreeMap", menuTreeMap);
		}			
		return resultMap;
	}
	
	/**
	  * menuManagementR1 - 메뉴관리 - 메뉴 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="menuManagementR2.do", method=RequestMethod.POST)
	public Map<String, Object> menuManagementR2(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String menu_cd = request.getParameter("MENU_CD");
		if(menu_cd == null || menu_cd.length() == 0){
			String errMesage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("MENU_CD", menu_cd);
			Map<String, Object> menuMap = systemMenuService.getMenuMap(paramMap);
			resultMap.put("dataMap", menuMap);
		}
		return resultMap;
	}
	
	/**
	  * menuManagementCUD1 - 메뉴관리 - 메뉴 목록 저장
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="menuManagementCUD1.do", method=RequestMethod.POST)
	public Map<String, Object> menuManagementCUD1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String crud = request.getParameter("CRUD");
		String menu_cd = request.getParameter("MENU_CD");
		String menu_nm = request.getParameter("MENU_NM");
		String upper_menu_cd = request.getParameter("UPPER_MENU_CD");
		String menu_ordr = request.getParameter("MENU_ORDR");
		String use_yn = request.getParameter("USE_YN");
		String folder_yn = request.getParameter("FOLDER_YN");
					
		if(crud == null || crud.equals("")){				
			String errMesage = messageSource.getMessage("error.common.noChanged", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			if("C".equals(crud) || "U".equals(crud)){
				if(menu_nm == null || menu_nm.equals("")){
					String errMesage = messageSource.getMessage("error.common.system.menu.menu_nm.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1002";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(menu_nm.length() > 50){
					String errMesage = messageSource.getMessage("error.common.system.menu.menu_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1003";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(!commonUtil.isInteger(menu_ordr)){
					String errMesage = messageSource.getMessage("error.common.system.menu.menu_ordr.onlyNumber", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1004";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(use_yn == null || use_yn.equals("")){						
					String errMesage = messageSource.getMessage("error.common.use_yn.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1005";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);						
				} else if(folder_yn == null || folder_yn.equals("")){
					String errMesage = messageSource.getMessage("error.common.system.menu.folder_yn.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1006";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			}
		}
		if(resultMap.keySet().size() == 0){
			if("U".equals(crud) || "D".equals(crud)) {
				if(menu_cd == null || menu_cd.equals("")){
					String errMesage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1007";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			}
			
			if(resultMap.keySet().size() == 0){					
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("CRUD", crud);
				paramMap.put("MENU_CD", menu_cd);
				paramMap.put("MENU_NM", menu_nm);
				paramMap.put("UPPER_MENU_CD", upper_menu_cd);
				paramMap.put("MENU_ORDR", menu_ordr);
				paramMap.put("USE_YN", use_yn);
				paramMap.put("FOLDER_YN", folder_yn);
				paramMap.put("REG_ID", emp_no);
				
				int resultRowCnt = systemMenuService.saveMenu(paramMap);
				
				if(resultRowCnt == 9999){
					String errMesage = messageSource.getMessage("error.common.system.menu.no_delete_contain_submenus", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1008";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}else{
					resultMap.put("resultRowCnt", resultRowCnt);
				}
			}
		}
		return resultMap;
	}
	
	/**
	  * screenManagement - 화면관리 - 화면 조회
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="screenManagement.sis", method=RequestMethod.POST)
	public ModelAndView screenManagement(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "screenManagement");
		return mav;
	}

	/**
	  * screenManagementTest - 화면관리테스트 - 화면 조회
	  * @author 서준호
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="screenManagementTest.sis", method=RequestMethod.POST)
	public ModelAndView screenManagementTest(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "screenManagementTest");
		return mav;
	}
	/**
	  * screenManagementR1 - 화면관리 - 화면 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="screenManagementR1.do", method=RequestMethod.POST)
	public Map<String, Object> screenManagementR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String scrin_cd = request.getParameter("SCRIN_CD");
		String use_yn = request.getParameter("USE_YN");
		String cmmn_yn = request.getParameter("CMMN_YN");			
		if(scrin_cd != null && scrin_cd.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.menu.scrin_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("SCRIN_CD", scrin_cd);
			paramMap.put("USE_YN", use_yn);
			paramMap.put("CMMN_YN", cmmn_yn);
			
			List<Map<String, Object>> screenList = systemMenuService.getScreenList(paramMap);				
			resultMap.put("gridDataList", screenList);
		}
		return resultMap;
	}
	/**
	  * screenManagementR1 - 화면관리 - 화면 목록 조회
	  * @author 서준호
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="screenManagementTestR1.do", method=RequestMethod.POST)
	public Map<String, Object> screenManagementTestR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String scrin_cd = request.getParameter("SCRIN_CD");
		String use_yn = request.getParameter("USE_YN");
		String cmmn_yn = request.getParameter("CMMN_YN");			
		if(scrin_cd != null && scrin_cd.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.menu.scrin_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("SCRIN_CD", scrin_cd);
			paramMap.put("USE_YN", use_yn);
			paramMap.put("CMMN_YN", cmmn_yn);
			
			List<Map<String, Object>> screenList = systemMenuService.getScreenListTest(paramMap);				
			resultMap.put("gridDataList", screenList);
		}
		return resultMap;
	}	
	
	/**
	  * screenManagementCUD1 - 화면관리 - 화면 목록 저장
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="screenManagementCUD1.do", method=RequestMethod.POST)
	public Map<String, Object> screenManagementCUD1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		int resultRowCnt = systemMenuService.saveScreenList(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
	
	
	/**
	  * screenManagementTestCUD1 - 화면관리 - 화면 목록 저장
	  * @author 서준호
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="screenManagementTestCUD1.do", method=RequestMethod.POST)
	public Map<String, Object> screenManagementTestCUD1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		int resultRowCnt = systemMenuService.saveScreenListTest(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
	
	/**
	  * menuByScreenManagement - 메뉴별화면관리 - 화면 조회
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="menuByScreenManagement.sis", method=RequestMethod.POST)
	public ModelAndView menuByScreenManagement(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "menuByScreenManagement");
		return mav;
	}
	
	/**
	  * menuByScreenManagementR1 - 메뉴별화면관리 - 메뉴 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="menuByScreenManagementR1.do", method=RequestMethod.POST)
	public Map<String, Object> menuByScreenManagementR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> allMenuMapList = systemMenuService.getAllMenuMapList();
		if(allMenuMapList.isEmpty()){
			String errMesage = messageSource.getMessage("error.common.system.authority.noMenu", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {				
			/* DhtmlxTree 에 맞추어 Result 데이터 재구성 */ 
			Map<String, Object> menuTreeMap = new HashMap<String, Object>();
			/* 최상위 메뉴를 위한 Root 최상위 메뉴 설정 */
			List<Map<String, Object>> rootMapList = new ArrayList<Map<String, Object>>();
			Map<String, Object> rootMap = new HashMap<String, Object>();				
			
			rootMap.put("id", "#root");
			rootMap.put("text", "Root");
			rootMap.put("item", allMenuMapList);
			rootMapList.add(rootMap);
			
			menuTreeMap.put("id", "0");
			menuTreeMap.put("item", rootMapList);	
			resultMap.put("menuTreeMap", menuTreeMap);
		}	
		return resultMap;
	}
	
	/**
	  * menuByScreenManagementR2 - 메뉴별화면관리 - 메뉴별화면 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="menuByScreenManagementR2.do", method=RequestMethod.POST)
	public Map<String, Object> menuByScreenManagementR2(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String menu_cd = request.getParameter("MENU_CD");
		if(menu_cd == null || menu_cd.length() == 0){
			String errMessage = messageSource.getMessage("error.common.system.menu.menu_cd.empty", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("MENU_CD", menu_cd);
			
			Map<String, Object> menuMap = systemMenuService.getMenuMap(paramMap);
			List<Map<String, Object>> menuByScreenList = systemMenuService.getMenuByScreenList(paramMap);
			
			resultMap.put("dataMap", menuMap);
			resultMap.put("gridDataList", menuByScreenList);
		}
		return resultMap;
	}
	
	/**
	  * menuByScreenManagementR3 - 메뉴별화면관리 - 화면 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="menuByScreenManagementR3.do", method=RequestMethod.POST)
	public Map<String, Object> menuByScreenManagementR3(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String scrin_cd = request.getParameter("SCRIN_CD");
		String use_yn = request.getParameter("USE_YN");
		String cmmn_yn = request.getParameter("CMMN_YN");			
		if(scrin_cd != null && scrin_cd.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.menu.scrin_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("SCRIN_CD", scrin_cd);
			paramMap.put("USE_YN", use_yn);
			paramMap.put("CMMN_YN", cmmn_yn);
			
			List<Map<String, Object>> screenList = systemMenuService.getScreenList(paramMap);				
			resultMap.put("gridDataList", screenList);
		}	
		return resultMap;
	}
	
	/**
	  * menuByScreenManagementCUD1 - 메뉴관리 - 메뉴별화면 저장
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="menuByScreenManagementCUD1.do", method=RequestMethod.POST)
	public Map<String, Object> menuByScreenManagementCUD1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		int resultRowCnt = systemMenuService.saveMenuByScreenList(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
}
