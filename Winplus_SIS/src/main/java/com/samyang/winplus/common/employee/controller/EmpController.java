package com.samyang.winplus.common.employee.controller;

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

import com.samyang.winplus.common.employee.service.EmpService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.security.util.HaeSha512;

/** 
 * @Package Name : com.samyang.winplus.rdct.mdm.orc.controller 
 * @Class Name : EmpController.java
 * @Description : 사용자관리컨트롤러
 * @Modification Information  
 * @
 * @  수정일                  수정자            수정내용
 * @ ---------  ---------   -------------------------------
 * @ 2017. 11. 08.     byunghun.ju     최초생성
 * 
 * @author byunghun.ju
 * @since 2017. 11. 08. 
 * @version 
 * @see
 * 
 */
@RestController
@RequestMapping("/common/employee")
public class EmpController extends BaseController {
	@Autowired
	EmpService empService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final static String DEFAULT_PATH = "common/employee";
	
	
	/**
	 * <pre>
	 * 1. 개요 : 납품업체관리 화면조회
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : supplierManagement
	 * @param request
	 * @return
	 */
	@RequestMapping("/employeeManagement.sis")
	public ModelAndView supplierManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "employeeManagement");
		return mav;
	}
	
	
	/**
	 * employeeManagementPerfect - 사용자관리 (퍼펙트)
	 * @author 조승현
	 * @param request
	 * @return mav
	 */
	@RequestMapping("/employeeManagementPerfect.sis")
	public ModelAndView employeeManagementPerfect(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "employeeManagementPerfect");
		return mav;
	}
	

	/**
	  * getEmpList - 사용자 목록 조회
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getEmpList.do", method=RequestMethod.POST)
	public Map<String, Object> getEmpList(HttpServletRequest request, @RequestParam Map<String,String> paramMap) throws SQLException, Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();

		List<Map<String, Object>> gridDataList = empService.getEmpList(paramMap);
		
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
	
	/**
	  * getOrgn - 조직 조회
	  * @author 주병훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getEmp.do", method=RequestMethod.POST)
	public Map<String, Object> getEmp(HttpServletRequest request, @RequestParam Map<String,String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("dataMap", empService.getEmp(paramMap));
		return resultMap;
	}
	
	/**
	  * insertOrgn - 조직 CUD
	  * @author 주병훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="insertEmp.do", method=RequestMethod.POST)
	public Map<String, Object> insertEmp(HttpServletRequest request) throws SQLException, Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String loginEmpNo = empSessionDto.getEmp_no();
		
		String crud = request.getParameter("CRUD");
		String id = request.getParameter("ID");
		String empNo = request.getParameter("EMP_NO");
		String empNm = request.getParameter("EMP_NM");
		String deptCd = request.getParameter("DEPT_CD");
		String email = request.getParameter("EMAIL");
		String mbtlNum = request.getParameter("MBTLNUM");
		String site_div_cd = request.getParameter("SITE_DIV_CD");
		
		//구버전
//		평문을 sha512 단방향 암호화를 적용함.
//		HaeSha512 haeSha512 = new HaeSha512();
//		String encPassword = haeSha512.haeEncrypt(pwd);
		
		String SEARCHABLE_AUTH_CD = request.getParameter("SEARCHABLE_AUTH_CD");
		
		String useYn = request.getParameter("USE_YN");
		
		String regReqId = loginEmpNo;

		if(crud == null || "".equals(crud)){				
			String errMesage = messageSource.getMessage("error.common.noChanged", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			if("U".equals(crud)){
				if(id == null || "".equals(id)) {
					String errMesage = messageSource.getMessage("error.common.organ.employee.id.noData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "000000";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}else if(empNo == null || "".equals(empNo)){
					String errMesage = messageSource.getMessage("error.common.organ.employee.empNo.noData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "000000";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			}
			if("C".equals(crud) || "U".equals(crud)){
				if(empNm == null || "".equals(empNm)){
					String errMesage = messageSource.getMessage("error.common.organ.employee.empNm.noData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "000000";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}else if(deptCd == null || "".equals(deptCd)){
					String errMesage = messageSource.getMessage("error.common.organ.employee.deptCd.noData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "000000";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}else if(email == null || "".equals(email)){
					String errMesage = messageSource.getMessage("error.common.organ.employee.email.noData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "000000";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}else if(deptCd == null || "".equals(deptCd)){
					String errMesage = messageSource.getMessage("error.common.organ.employee.email.existData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "000000";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			}
		}
		
		if(resultMap.keySet().size() == 0){
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("CRUD", crud);
			paramMap.put("ID", id);
			paramMap.put("EMP_NO", empNo);
			paramMap.put("EMP_NM", empNm);
			paramMap.put("DEPT_CD", deptCd);
			paramMap.put("EMAIL", email);
			paramMap.put("MBTLNUM", mbtlNum);
			paramMap.put("USE_YN", useYn);

			paramMap.put("REG_REQ_ID", regReqId);
			paramMap.put("SEARCHABLE_AUTH_CD", SEARCHABLE_AUTH_CD);
			paramMap.put("SITE_DIV_CD", site_div_cd);
			
			
			int resultRowCnt = empService.insertEmp(paramMap);
			
			if(resultRowCnt == 9999){
				String errMesage = messageSource.getMessage("error.common.system.menu.no_delete_contain_submenus", new Object[1], commonUtil.getDefaultLocale());
				String errCode = null;
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
			}else{
				resultMap.put("resultRowCnt", resultRowCnt);
			}
		}
		
		return resultMap;
	}
	
	
	
	/**
	  * insertPerfectEmp - 퍼펙트 직원 CUD
	  * @author 조승현
	  * @param paramMap
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="insertPerfectEmp.do", method=RequestMethod.POST)
	public Map<String, Object> insertPerfectEmp(HttpServletRequest request,@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String empNoSession = empSessionDto.getMember_cd();
		
		String CRUD = (String) paramMap.get("CRUD");
		String MEMBER_CODE = (String) paramMap.get("MEMBER_CODE");
		String MEMBER_NAME = (String) paramMap.get("MEMBER_NAME");
		String MEMBER_WAREA = (String) paramMap.get("MEMBER_WAREA");
		
		String MOD_ID = empNoSession;

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(CRUD == null || "".equals(CRUD)){				
			String errMesage = messageSource.getMessage("error.common.noChanged", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			if("C".equals(CRUD) || "U".equals(CRUD)){
				if(MEMBER_CODE == null || "".equals(MEMBER_CODE)){
					String errMesage = messageSource.getMessage("error.common.organ.perfect.employee.memberCode.noData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "2000";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
					return resultMap;
				}else if(MEMBER_NAME == null || "".equals(MEMBER_NAME)){
					String errMesage = messageSource.getMessage("error.common.organ.perfect.employee.memberName.noData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "2001";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
					return resultMap;
				}else if(MEMBER_WAREA == null || "".equals(MEMBER_WAREA)){
					String errMesage = messageSource.getMessage("error.common.organ.perfect.employee.memberWarea.noData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "2002";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
					return resultMap;
				}
			}else if("D".equals(CRUD)){
				if(MEMBER_CODE == null || "".equals(MEMBER_CODE)){
					String errMesage = messageSource.getMessage("error.common.organ.perfect.employee.memberCode.noData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "2000";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
					return resultMap;
				}
			}
		}
		
		paramMap.put("MOD_ID", MOD_ID);
		
		int resultRowCnt = empService.insertPerfectEmp(paramMap);
		
		if(resultRowCnt == 9999){
			String errMesage = messageSource.getMessage("error.common.system.menu.no_delete_contain_submenus", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1008";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		}else{
			resultMap.put("resultRowCnt", resultRowCnt);
		}

		return resultMap;
	}
	
	
	/**
	 * <pre>
	 * 1. 개요 : 로그인 추가 목록을 조회 할 수 있다.
	 * 2. 처리내용 : 로그인 추가 목록을 조회
	 * </pre>   
	 * @Method Name : getEmpLoginAddList
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "/getEmpLoginAddList.do", method=RequestMethod.POST)
	public Map<String, Object> getEmpLoginAddList(HttpServletRequest request) throws SQLException, Exception {
		if(logger.isDebugEnabled()){
			//logger.debug("EmpController >> getEmpLoginAddList");
		}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap = commonUtil.getParamValueMap(request);
		List<Map<String, Object>> resultMapList = empService.getEmpLoginAddList(paramMap);	
		
		resultMap.put("gridDataList", resultMapList);
		return resultMap;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 로그인 추가 목록을 저장 할 수 있다.
	 * 2. 처리내용 : 로그인 추가 목록을 저장
	 * </pre>   
	 * @Method Name : saveEmpLoginAddList
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveEmpLoginAddList.do", method=RequestMethod.POST)
	public Map<String, Object> saveEmpLoginAddList(HttpServletRequest request) throws SQLException, Exception {
		if(logger.isDebugEnabled()){
			//logger.debug("EmpController >> saveEmpLoginAddList");
		}
		int resultRowCnt = 0;
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String empNo = empSessionDto.getEmp_no();	
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", empNo);	
			dhtmlxParamMap.put("MOD_ID", empNo);
		}
		
		resultRowCnt = empService.saveEmpLoginAddList(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}
	
	/**
	  * getPerfectEmpList - 퍼펙트 사용자 목록 조회
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getPerfectEmpList.do", method=RequestMethod.POST)
	public Map<String, Object> getPerfectEmpList(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		//paramMap => MEMBER_WAREA, MEMBER_NAME ,MEMBER_USE_YN
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> empList = empService.getPerfectEmpList(paramMap);
		
		resultMap.put("gridDataList", empList);
		
		return resultMap;
	}
	
	/**
	  * getPerfectEmpDetail - 퍼펙트 사용자 정보
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getPerfectEmpDetail.do", method=RequestMethod.POST)
	public Map<String, Object> getPerfectEmpDetail(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		//paramMap => MEMBER_CODE
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> empDetail = empService.getPerfectEmpDetail(paramMap);
		
		resultMap.put("dataMap", empDetail);
		
		return resultMap;
	}
	
	/**
	 * empByGrupMng - 사용자별 그룹 관리
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping("empByGrupMng.sis")
	public ModelAndView empByGrupMng(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "empByGrupMng");
		return mav;
	}
	
	/**
	 * getEmpByGrupList - 사용자별 그룹 관리 - 그룹 조회
	 * @author 강신영
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getEmpByGrupList.do", method=RequestMethod.POST)
	public Map<String, Object> getPresetGroupList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String EMP_NO = empSessionDto.getEmp_no();
		
		paramMap.put("EMP_NO", EMP_NO);
		paramMap.put("GRUP_TYPE", "C");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try{
			List<Map<String, Object>> gridDataList = empService.getEmpByGrupList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	 * saveEmpByGrupList - 사용자별 그룹 관리 - 그룹 저장
	 * @author 강신영
	 * @param  request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="saveEmpByGrupList.do", method=RequestMethod.POST)
	public Map<String, Object> SavePresetDetailList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String EMP_NO = empSessionDto.getEmp_no();
		int resultRowCnt = 0;
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("EMP_NO", EMP_NO);
			dhtmlxParamMap.put("GRUP_TYPE", "C");
		}
		
		resultRowCnt = empService.saveEmpByGrupList(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}
	
	/**
	 * getEmpByGrupDetailList - 사용자별 그룹 관리 - 그룹 상세 조회
	 * @author 정혜원
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getEmpGrupDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getEmpGrupDetailList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String EMP_NO = empSessionDto.getEmp_no();
		String GRUP_CD = request.getParameter("GRUP_CD");
		
		paramMap.put("GRUP_CD", GRUP_CD);
		paramMap.put("EMP_NO", EMP_NO);
		
		try {
			List<Map<String, Object>> DetailGridDataList = empService.getEmpGrupDetailList(paramMap);
			resultMap.put("gridDataList", DetailGridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * saveEmpByGrupDetailList - 사용자별 거래처 그룹관리 - 거래처 상세내역 저장
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "saveEmpByGrupDetailList.do", method = RequestMethod.POST)
	public Map<String, Object> saveEmpByGrupDetailList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String EMP_NO = empSessionDto.getEmp_no();
		int resultRowCnt = 0;
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("EMP_NO", EMP_NO);
			dhtmlxParamMap.put("GRUP_TYPE", "C");
		}
		
		resultRowCnt = empService.saveEmpByGrupDetailList(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}
	
	/**
	  * goodsGroupManagement - 상품그룹관리
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "goodsGroupManagement.sis", method = RequestMethod.POST)
	public ModelAndView TellOrder(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "empGoodsGroupManagement");
		return mav;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @return ModelAndView
	 * @description 사용자관리(협력사) 페이지 리턴
	 */
	@RequestMapping("/partnerManagement.sis")
	public ModelAndView partnerManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "partnerManagement");
		return mav;
	}

	/**
	 * @author 조승현
	 * @param request
	 * @return ModelAndView
	 * @description 사용자관리(고객사) 페이지 리턴
	 */
	@RequestMapping("/customerManagement.sis")
	public ModelAndView customerManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "customerManagement");
		return mav;
	}

	/**
	 * @author 조승현
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 사용자 조회(협력사)
	 */
	@RequestMapping(value="getPartnerList.do", method=RequestMethod.POST)
	public Map<String, Object> getPartnerList(HttpServletRequest request, @RequestParam Map<String,String> paramMap) throws SQLException, Exception {
		//logger.debug("requestParam");
		//logger.debug(paramMap.toString());
		Map<String, Object> resultMap = new HashMap<String, Object>();

		List<Map<String, Object>> gridDataList = empService.getPartnerList(paramMap);
		
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 사용자 조회(고객사)
	 */
	@RequestMapping(value="getCustomerList.do", method=RequestMethod.POST)
	public Map<String, Object> getCustomerList(HttpServletRequest request, @RequestParam Map<String,String> paramMap) throws SQLException, Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();

		List<Map<String, Object>> gridDataList = empService.getCustomerList(paramMap);
		
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 비밀번호 초기화
	 */
	@RequestMapping(value="initPassword.do", method=RequestMethod.POST)
	public Map<String, Object> initPassword(HttpServletRequest request, @RequestParam Map<String,String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		paramMap.put("MUSER", empSessionDto.getEmp_no());
		empService.initPassword(paramMap);
		return resultMap;
	}
}
