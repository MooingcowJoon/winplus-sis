package com.samyang.winplus.common.system.authority.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.authority.service.SystemAuthorityService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.model.ScreenDto;


/** 
 * 시스템관리 - 권한관리 컨트롤러  
 * @since 2017.03.21
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2017.03.21 / 김종훈 / 신규 생성
 *********************************************
 */
@RequestMapping("/common/system/authority")
@RestController
public class SystemAuthorityController extends BaseController {
	private final Logger subLogger = LoggerFactory.getLogger(getClass());
	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	SystemAuthorityService systemAuthorityService;
	
	private final static String DEFAULT_PATH = "common/system/authority";
	
	/**
	  * authorityManagement - 권한관리 - 화면 조회
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="authorityManagement.sis", method=RequestMethod.POST)
	public ModelAndView authorityManagement(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "authorityManagement");
		return mav;
	}
	
	
	/**
	  * authorityManagementR1 - 권한관리 - 권한 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="authorityManagementR1.do", method=RequestMethod.POST)
	public Map<String, Object> authorityManagementR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String author_cd = request.getParameter("AUTHOR_CD");
		String use_yn = request.getParameter("USE_YN");			
		if(author_cd != null && author_cd.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.authority.author_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("AUTHOR_CD", author_cd);
			paramMap.put("USE_YN", use_yn);
			
			List<Map<String, Object>> authorList = systemAuthorityService.getAuthorList(paramMap);				
			resultMap.put("gridDataList", authorList);
		}
		return resultMap;
	}
	
	/**
	  * authorityManagementCUD1 - 권한관리 - 권한 목록 저장
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="authorityManagementCUD1.do", method=RequestMethod.POST)
	public Map<String, Object> authorityManagementCUD1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		int resultRowCnt = systemAuthorityService.saveAuthorList(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}	
	
	/**
	  * authorityByMenuManagement - 권한별메뉴관리 - 화면 조회
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="authorityByMenuManagement.sis", method=RequestMethod.POST)
	public ModelAndView authorityByMenuManagement(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "authorityByMenuManagement");
		return mav;
	}
	
	/**
	  * authorityByMenuManagementR1 - 권한별메뉴관리 - 권한 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="authorityByMenuManagementR1.do", method=RequestMethod.POST)
	public Map<String, Object> authorityByMenuManagementR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String author_cd = request.getParameter("AUTHOR_CD");
		String use_yn = request.getParameter("USE_YN");			
		if(author_cd != null && author_cd.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.authority.author_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("AUTHOR_CD", author_cd);
			paramMap.put("USE_YN", use_yn);
			
			List<Map<String, Object>> authorList = systemAuthorityService.getAuthorList(paramMap);				
			resultMap.put("gridDataList", authorList);
		}
		return resultMap;
	}
	
	/**
	  * authorityByMenuManagementR2 - 권한별메뉴관리 - 권한별메뉴 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="authorityByMenuManagementR2.do", method=RequestMethod.POST)
	public Map<String, Object> authorityByMenuManagementR2(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String author_cd = request.getParameter("AUTHOR_CD");
		if(author_cd == null || author_cd.length() == 0){
			String errMessage = messageSource.getMessage("error.adm.system.hr80160.pageName.length100Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("AUTHOR_CD", author_cd);
			
			List<Map<String, Object>> authorList = systemAuthorityService.getAuthorByMenuList(paramMap);				
			resultMap.put("gridDataList", authorList);
		}
		return resultMap;
	}
	
	/**
	  * authorityByMenuManagementCUD1 - 권한별메뉴관리 - 권한별메뉴 목록 저장
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="authorityByMenuManagementCUD1.do", method=RequestMethod.POST)
	public Map<String, Object> authorityByMenuManagementCUD1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
			
//			System.out.println(dhtmlxParamMap);
		}
		int resultRowCnt = systemAuthorityService.saveAuthorByMenuList(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}	
	
	/**
	  * authorityByEmpManagement - 권한별사원관리 - 화면 조회
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="authorityByEmpManagement.sis", method=RequestMethod.POST)
	public ModelAndView authorityByEmpManagement(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "authorityByEmpManagement");
		return mav;
	}
	
	/**
	  * authorityByEmpManagementR1 - 권한별사원관리 - 권한 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="authorityByEmpManagementR1.do", method=RequestMethod.POST)
	public Map<String, Object> authorityByEmpManagementR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String author_cd = request.getParameter("AUTHOR_CD");
		String use_yn = request.getParameter("USE_YN");			
		if(author_cd != null && author_cd.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.authority.author_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("AUTHOR_CD", author_cd);
			paramMap.put("USE_YN", use_yn);
			
			List<Map<String, Object>> authorList = systemAuthorityService.getAuthorList(paramMap);				
			resultMap.put("gridDataList", authorList);
		}
		return resultMap;
	}
	
	/**
	  * authorityByEmpManagementR2 - 권한별사원관리 - 권한별사원 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="authorityByEmpManagementR2.do", method=RequestMethod.POST)
	public Map<String, Object> authorityByEmpManagementR2(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String author_cd = request.getParameter("AUTHOR_CD");
		if(author_cd == null || author_cd.length() == 0){
			String errMessage = messageSource.getMessage("error.adm.system.hr80160.pageName.length100Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("AUTHOR_CD", author_cd);
			
			List<Map<String, Object>> authorList = systemAuthorityService.getAuthorByEmpList(paramMap);				
			resultMap.put("gridDataList", authorList);
		}
		return resultMap;
	}
	
	/**
	  * authorityByEmpManagementR3 - 권한별사원관리 - 전체사원 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="authorityByEmpManagementR3.do", method=RequestMethod.POST)
	public Map<String, Object> authorityByEmpManagementR3(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String user_cd = request.getParameter("USER_CD");
		String orgnDivCd = request.getParameter("USER_DIV_CD");
		if(user_cd != null && user_cd.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.authority.user_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("USER_CD", user_cd);
			paramMap.put("ORGN_DIV_CD", orgnDivCd);
			
			List<Map<String, Object>> authorList = systemAuthorityService.getAuthorTargetList(paramMap);				
			resultMap.put("gridDataList", authorList);
		}
		return resultMap;
	}
	
	/**
	  * authorityByEmpManagementCUD1 - 권한별사원관리 - 권한별사원 목록 저장
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="authorityByEmpManagementCUD1.do", method=RequestMethod.POST)
	public Map<String, Object> authorityByEmpManagementCUD1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		int resultRowCnt = systemAuthorityService.saveAuthorByEmpList(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
	
	/**
	  * 세션 만료 시 noSession 페이지 반환
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="/noSession.sis")
	public ModelAndView noSession(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		commonUtil.execSessionInvalidate(request);
		String pageName = DEFAULT_PATH + "/noSession";
		
		mav.setViewName(pageName);
		return mav;
	}
	
	/**
	  * 세션 만료 시 noSession Ajax 반환
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="/noSession.do", method=RequestMethod.POST)
	public Map<String, Object> noSessionAjax(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			commonUtil.execSessionInvalidate(request);
			String errMesage = messageSource.getMessage("error.common.system.authority.noSession", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "noSession";
			String pageName = "/" +  DEFAULT_PATH + "/noSession.sis";		
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
			resultMap.put("pageName", pageName);
			response.setStatus(403);
		} catch (Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}	
		return resultMap;
	}		
	
	/**
	  * 현재 권한으로 사용 가능 메뉴 트리 맵 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="/getMenuTreeMap.do", method=RequestMethod.POST)
	public Map<String, Object> getMenuTreeMap(HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
			String empNo = empSessionDto.getEmp_no();
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("EMP_NO", empNo);
			List<Map<String, Object>> menuMapList = systemAuthorityService.getMenuMapList(paramMap);
			if(menuMapList.isEmpty()){
				String errMesage = messageSource.getMessage("error.common.system.authority.noMenu", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1001";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
			} else {				
				/* DhtmlxTree 에 맞추어 Result 데이터 재구성 */ 
				Map<String, Object> menuTreeMap = new HashMap<String, Object>();
				menuTreeMap.put("id", "0");
				menuTreeMap.put("item", menuMapList);
				resultMap.put("menuTreeMap", menuTreeMap);
			}			
		} catch (Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}		
	
	/**
	  * 상세 메뉴의 페이지 경로 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="/getScreenPath.do", method=RequestMethod.POST)
	public Map<String, Object> getScreenPath(HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			String menuCd = request.getParameter("MENU_CD");			
			if(menuCd != null && menuCd.length() > 0){
				EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
				Map<String, Object> paramMap = new HashMap<String, Object>();
				String empNo =  empSessionDto.getEmp_no();
				String mainYn = request.getParameter("MAIN_YN");
				paramMap.put("EMP_NO", empNo);
				paramMap.put("MENU_CD", menuCd);
				paramMap.put("MAIN_YN", mainYn);
				
				ScreenDto screenDto = systemAuthorityService.getScreenDto(paramMap);
				if(screenDto != null){
					String scrinPath = screenDto.getScrin_path();
					String menuNm = screenDto.getMenu_nm();
					String authorCd = screenDto.getAuthor_cd();
					
					resultMap.put("scrin_path", scrinPath);
					resultMap.put("menu_nm", menuNm);
					resultMap.put("author_cd", authorCd);
				} else {
					//String errMesage = "요청하신 페이지를 사용할 수 없습니다.";					
					String errMesage = messageSource.getMessage("error.common.system.authority.unablePage", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1002";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			} else {
				//String errMesage = "올바르지 않은 페이지 호출 요청 입니다.";
				String errMesage = messageSource.getMessage("error.common.system.authority.incorrectPageRequest", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1001";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
			}
		} catch (Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * 권한 없는 경우 noAuth 페이지 반환
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="/noAuth.sis")
	public ModelAndView noAuth(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		String pageName = DEFAULT_PATH + "/noAuth";
		
		mav.setViewName(pageName);
		return mav;
	}
	
	/**
	  * 권한 없는 경우 noAuth Ajax 반환
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="/noAuth.do", method=RequestMethod.POST)
	public Map<String, Object> noAuthAjax(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			String errMesage = messageSource.getMessage("error.common.system.authority.noAuth", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "noAuth";
			String pageName = "/" +  DEFAULT_PATH + "/noAuth.sis";		
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
			resultMap.put("pageName", pageName);
			response.setStatus(403);
		} catch (Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}	
		return resultMap;
	}
	
	/**
	  * empAccessLog - 직원접속로그 - 화면
	  * @author 강신영
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="empAccessLog.sis", method=RequestMethod.POST)
	public ModelAndView empAccessLog(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "empAccessLog");
		return mav;
	}
	
	/**
	  * getEmpAccessLogList - 직원접속로그 - 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getEmpAccessLogList.do", method=RequestMethod.POST)
	public Map<String, Object> getEmpAccessLogList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String searchDateFrom = request.getParameter("searchDateFrom");
		String searchDateTo = request.getParameter("searchDateTo");
		String log_type = request.getParameter("LOG_TYPE");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("searchDateFrom", searchDateFrom);
		paramMap.put("searchDateTo", searchDateTo);
		paramMap.put("LOG_TYPE", log_type);
		
		if(searchDateFrom != null && searchDateFrom.length() > 0 && searchDateTo != null && searchDateTo.length() > 0){
			List<Map<String, Object>> empAccessLogList = systemAuthorityService.getEmpAccessLogList(paramMap);				
			resultMap.put("gridDataList", empAccessLogList);
		} else {
			String errMessage = messageSource.getMessage("error.common.date.empty3", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		}
		return resultMap;
	}
	

	/**
	 * 
	 * @author 서준호
	 * @date Jan 10, 2024
	 * @param reqeust
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="empManagementTest.sis", method=RequestMethod.POST)
	public ModelAndView empManagementTest(HttpServletRequest reqeust) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "empManagementTest");
		return mav;
	}
	
	
	@RequestMapping(value="empManagementTestR1.do", method=RequestMethod.POST)
	public Map<String,Object> empManagementTestR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String memb_no = request.getParameter("MEMB_NO");
		String memb_cont_cd = request.getParameter("MEMB_CONT_CD");
		String memb_join_yymmdd_fr = request.getParameter("MEMB_JOIN_YYMMDD_FR");			
		String memb_join_yymmdd_to = request.getParameter("MEMB_JOIN_YYMMDD_TO");			
		if(memb_no != null && memb_no.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.authority.memb_no.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("MEMB_NO", memb_no);
			paramMap.put("MEMB_CONT_CD", memb_cont_cd);
			paramMap.put("MEMB_JOIN_YYMMDD_FR", memb_join_yymmdd_fr);
			paramMap.put("MEMB_JOIN_YYMMDD_TO", memb_join_yymmdd_to);
			
			List<Map<String, Object>> empList = systemAuthorityService.getEmpList(paramMap);				
			resultMap.put("gridDataList", empList);
		}
		return resultMap;
	}
	
	/**
	  * empManagementTestCUD1 - 사원 조회 - 사원 목록 저장 
	  * @author 서준호
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="empManagementTestCUD1.do", method=RequestMethod.POST)
	public Map<String, Object> empManagementTestCUD1(HttpServletRequest request) throws SQLException, Exception {
		subLogger.info("Received AJAX request with body: {}", request.getParameterMap().toString()); // 서브로거 객체로 info 타입 로그 출력 ( 요청 파라미터맵 딕셔너리형태 문자열로 출력)
		Map<String, Object> resultMap = new HashMap<String, Object>();		// ajax json 응답을 위한 딕셔너리 자료형(맵객체) 초기화
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);	// request의 세션 정보 활용하여 세션의 유저정보 dto로 받음
		String emp_no = empSessionDto.getEmp_no();		// 받은 유저세션dto에서 사원번호 빼냄(CUD작업 수행한 직원번호 db저장)
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);  // 각 컬럼 수정정보. request 에 직렬화되어 저장된 리퀘스트바디 파라미터 맵객체에 담아 반환
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){			// 각 컬럼 수정정보에 수정한 직원번호 엔트리 추가
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		int resultRowCnt = systemAuthorityService.saveEmpList(dhtmlxParamMapList);		// 서비스객체 CUD메소드 호출
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
	
	@RequestMapping(value="empManagementTestR2.do", method=RequestMethod.POST)
	public Map<String,Object> empManagementTestR2(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String memb_no = request.getParameter("MEMB_NO");
		if(memb_no != null && memb_no.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.authority.memb_no.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("MEMB_NO", memb_no);
			List<Map<String, Object>> empList = systemAuthorityService.getPjtList(paramMap);				
			resultMap.put("gridDataList", empList);
		}
		return resultMap;
	}
	
	
	/**
	  * empManagementTestCUD2 - 사원 조회 - 사원 목록 저장 
	  * @author 서준호
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="empManagementTestCUD2.do", method=RequestMethod.POST)
	public Map<String, Object> empManagementTestCUD2(HttpServletRequest request) throws SQLException, Exception {
		subLogger.info("Received AJAX request with body: {}", request.getParameterMap().toString()); // 서브로거 객체로 info 타입 로그 출력 ( 요청 파라미터맵 딕셔너리형태 문자열로 출력)
		Map<String, Object> resultMap = new HashMap<String, Object>();		// ajax json 응답을 위한 딕셔너리 자료형(맵객체) 초기화
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);	// request의 세션 정보 활용하여 세션의 유저정보 dto로 받음
		String emp_no = empSessionDto.getEmp_no();		// 받은 유저세션dto에서 사원번호 빼냄(CUD작업 수행한 직원번호 db저장)
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);  // 각 컬럼 수정정보. request 에 직렬화되어 저장된 리퀘스트바디 파라미터 맵객체에 담아 반환
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){			// 각 컬럼 수정정보에 수정한 직원번호 엔트리 추가
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		int resultRowCnt = systemAuthorityService.savePjtList(dhtmlxParamMapList);		// 서비스객체 CUD메소드 호출
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
	
	
	
	/**
	 * @author 서준호
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 * @description 게시글 팝업 열기
	 */
	@RequestMapping(value="searchProjectGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView openBoardPopup(HttpServletRequest request, @RequestParam Map<String, String> paramMap) throws SQLException, Exception{
		ModelAndView mav = new ModelAndView();
		mav.setViewName("common/popup" +"/"+ "openSearchProjectGridPopup");
		return mav;
	}


	
}
