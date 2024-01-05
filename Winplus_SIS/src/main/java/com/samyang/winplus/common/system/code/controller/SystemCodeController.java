package com.samyang.winplus.common.system.code.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.code.service.SystemCodeService;
import com.samyang.winplus.common.system.model.EmpSessionDto;

/** 
 * 시스템관리 - 코드관리 컨트롤러  
 * @since 2017.03.27
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2017.03.27 / 김종훈 / 신규 생성
 *********************************************
 */
@RequestMapping("/common/system/code")
@RestController
public class SystemCodeController extends BaseController {
	
	@Autowired
	SystemCodeService systemCodeService;
	
	private final static String DEFAULT_PATH = "common/system/code";
	
	/**
	  * commonCodeManagement - 공통코드관리 - 화면 조회
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="commonCodeManagement.sis", method=RequestMethod.POST)
	public ModelAndView commonManagement(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "commonCodeManagement");
		return mav;
	}

	/**
	  * commonCodeManagement - 공통코드관리 - 화면 조회
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="tstCodeManagement1.sis", method=RequestMethod.POST)
	public ModelAndView commonManagement1(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "tstCodeManagement1");
		return mav;
	}

	
	/**
	  * commonCodeManagementR1 - 공통코드관리 - 공통코드목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="commonCodeManagementR1.do", method=RequestMethod.POST)
	public Map<String, Object> commonCodeManagementR1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String cmmn_cd = request.getParameter("CMMN_CD");
		String use_yn = request.getParameter("USE_YN");			
		if(cmmn_cd != null && cmmn_cd.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.common.cmmn_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("CMMN_CD", cmmn_cd);
			paramMap.put("USE_YN", use_yn);
			
			List<Map<String, Object>> commonCodeList = systemCodeService.getCommonCodeTable(paramMap);				
			resultMap.put("gridDataList", commonCodeList);
		}
		return resultMap;
	}
	
	/**
	  * commonCodeManagementCUD1 - 공통코드관리 - 공통코드상세목록 저장
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="commonCodeManagementCUD1.do", method=RequestMethod.POST)
	public Map<String, Object> commonCodeManagementCUD1(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		int resultRowCnt = systemCodeService.saveCommonCodeTable(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
	
	/**
	  * commonCodeManagementR2 - 공통코드관리 - 공통코드상세목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="commonCodeManagementR2.do", method=RequestMethod.POST)
	public Map<String, Object> commonCodeManagementR2(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String cmmn_cd = request.getParameter("CMMN_CD");
		if(cmmn_cd == null || cmmn_cd.equals("")){
			String errMessage = messageSource.getMessage("error.common.system.code.noSelectedCommonCode", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else if(cmmn_cd != null && cmmn_cd.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.common.cmmn_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1002";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("CMMN_CD", cmmn_cd);
			
			List<Map<String, Object>> commonCodeDetailList = systemCodeService.getCommonCodeDetailTable(paramMap);				
			resultMap.put("gridDataList", commonCodeDetailList);
		}
		return resultMap;
	}
	
	/**
	  * commonCodeManagementCUD2 - 공통코드관리 - 공통코드상세목록 저장
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="commonCodeManagementCUD2.do", method=RequestMethod.POST)
	public Map<String, Object> commonCodeManagementCUD2(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		int resultRowCnt = systemCodeService.saveCommonCodeDetailTable(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
	
	/**
	  * getCommonCodeList - 공통코드 목록 조회
	  * @author 김종훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="/getCommonCodeList.do", method=RequestMethod.POST)
	public Map<String, Object> getCommonCodeList(HttpServletRequest request) throws SQLException, Exception {
		Map <String, Object> resultMap = new HashMap<String, Object>();
		String cmmnCd = request.getParameter("CMMN_CD");	// 분류코드
		String div1 = request.getParameter("DIV1");	// 조건1
		String div2 = request.getParameter("DIV2");	// 조건2
		String div3 = request.getParameter("DIV3");	// 조건3
		String div4 = request.getParameter("DIV4");	// 조건4
		String div5 = request.getParameter("DIV5");	// 조건5
		
		String upperCmmnCd = request.getParameter("UPPER_CMMN_CD");	// 상위분류코드
		String upperCmmnDetailCd = request.getParameter("UPPER_CMMN_DETAIL_CD");	// 상위분류상세코드
		String type = request.getParameter("TYPE");// 형식
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);

		String empNo = empSessionDto.getEmp_no();
		/*String author_scope_cd = empSessionDto.getAuthor_scope_cd();*/
		paramMap.put("CMMN_CD", cmmnCd);
		paramMap.put("DIV1", div1);
		paramMap.put("DIV2", div2);
		paramMap.put("DIV3", div3);
		paramMap.put("DIV4", div4);
		paramMap.put("DIV5", div5);
		paramMap.put("EMP_NO", empNo);
		
		paramMap.put("UPPER_CMMN_CD", upperCmmnCd);
		paramMap.put("UPPER_CMMN_DETAIL_CD", upperCmmnDetailCd);
		
		List<Map<String, Object>> commonCodeList = null;
		if (type != null && type.equals("UPPER")) {
			commonCodeList = systemCodeService.getCommonCodeByUpperCodeList(paramMap);
		} else {
			commonCodeList = systemCodeService.getCommonCodeList(paramMap);
		}
		resultMap.put("commonCodeList", commonCodeList);
		
		return resultMap;
	}
	
	/**
	  * getDetailCommonCodeList - 공통코드 리스트
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="/getDetailCommonCodeList.do", method=RequestMethod.POST)
	public Map<String, Object> getDetailCommonCodeList(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		Map <String, Object> resultMap = new HashMap<String, Object>();

		List<Map<String, Object>> detailCommonCodeList = null;
		detailCommonCodeList = systemCodeService.getDetailCommonCodeList(paramMap);
		resultMap.put("detailCommonCodeList", detailCommonCodeList);
		
		return resultMap;
	}
	
	/**
	  * 트리코드관리 - 화면 조회
	  * @author 조승현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="treeCodeManagement.sis", method=RequestMethod.POST)
	public ModelAndView treeCodeManagement(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "treeCodeManagement");
		return mav;
	}
		
	/**
	  * 트리코드관리 - 조회
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getTreeCodeTable.do", method=RequestMethod.POST)
	public Map<String, Object> getTreeCodeTable(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String cmmn_cd = request.getParameter("CMMN_CD");
		String use_yn = request.getParameter("USE_YN");			
		if(cmmn_cd != null && cmmn_cd.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.common.cmmn_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("CMMN_CD", cmmn_cd);
			paramMap.put("USE_YN", use_yn);
			
			List<Map<String, Object>> commonCodeList = systemCodeService.getTreeCodeTable(paramMap);				
			resultMap.put("gridDataList", commonCodeList);
		}
		return resultMap;
	}
	
	/**
	  * 트리코드관리 - CUD
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="cudTreeCodeTable.do", method=RequestMethod.POST)
	public Map<String, Object> cudTreeCodeTable(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		int resultRowCnt = systemCodeService.cudTreeCodeTable(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
	
	/**
	  * 트리상세코드관리 - 조회
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getTreeDetailCodeTable.do", method=RequestMethod.POST)
	public Map<String, Object> getTreeDetailCodeTable(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String TREE_CODE = request.getParameter("TREE_CODE");
		String USE_YN = request.getParameter("USE_YN");			
		if(TREE_CODE != null && TREE_CODE.length() > 50){
			String errMessage = messageSource.getMessage("error.common.system.common.cmmn_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("TREE_CODE", TREE_CODE);
			paramMap.put("USE_YN", USE_YN);
			
			List<Map<String, Object>> commonCodeList = systemCodeService.getTreeDetailCodeTable(paramMap);				
			resultMap.put("gridDataList", commonCodeList);
		}
		return resultMap;
	}
	
	/**
	  * 트리상세코드관리 - CUD
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="cudTreeDetailCodeTable.do", method=RequestMethod.POST)
	public Map<String, Object> cudTreeDetailCodeTable(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		int resultRowCnt = systemCodeService.cudTreeDetailCodeTable(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
}
