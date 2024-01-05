package com.samyang.winplus.common.organ.controller;

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

import com.samyang.winplus.common.organ.service.OrganService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;

/** 
 * @Package Name : com.samyang.winplus.rdct.mdm.orc.controller 
 * @Class Name : OrganController.java
 * @Description : 조직관리컨트롤러
 * @Modification Information  
 * @
 * @  수정일                  수정자            수정내용
 * @ ---------  ---------   -------------------------------
 * @ 2017. 10. 31.     sungho.park     최초생성
 * 
 * @author sungho.park
 * @since 2017. 10. 31.
 * @version 
 * @see
 * 
 */
@RestController
@RequestMapping("/common/organ")
public class OrganController extends BaseController {
	@Autowired
	OrganService organService;
	
	@SuppressWarnings("unused")
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final static String DEFAULT_PATH = "common/organ";
	
	
	/**
	 * <pre>
	 * 1. 개요 : 납품업체관리
	 * 2. 처리내용 : 납품업체관리 화면조회
	 * </pre>   
	 * @Method Name : supplierManagement
	 * @param request
	 * @return ModelAndView
	 * supplierManagement.jsp
	 */
	@RequestMapping("/supplierManagement.sis")
	public ModelAndView supplierManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "supplierManagement");
		return mav;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 납품업체관리
	 * 2. 처리내용 : 납품업체코드 목록 조회
	 * </pre>   
	 * @Method Name : supplierManagementR1
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "supplierManagementR1.do", method=RequestMethod.POST)
	public Map<String, Object> supplierManagementR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap = commonUtil.getParamValueMap(request);

		List<Map<String, Object>> dlvBsnList = organService.getDlvBsnCodeList(paramMap);	
						
		resultMap.put("gridDataList", dlvBsnList);
		
		return resultMap;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 납품업체관리
	 * 2. 처리내용 : 선택된 납품업체정보 조회
	 * </pre>   
	 * @Method Name : supplierManagementR2
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "supplierManagementR2.do", method=RequestMethod.POST)
	public Map<String, Object> supplierManagementR2(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String dlvBsnCd = request.getParameter("DLV_BSN_CD");
		if(dlvBsnCd == null || dlvBsnCd.length() == 0){
			String errMesage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("DLV_BSN_CD", dlvBsnCd);
			Map<String, Object> dlvBsnMap = organService.getDlvBsnMap(paramMap);
			resultMap.put("dataMap", dlvBsnMap);
		}
		return resultMap;
	}
	
/*	*//**
	 * <pre>
	 * 1. 개요 : 납품업체관리
	 * 2. 처리내용 : 납품업체 정보 저장
	 * </pre>   
	 * @Method Name : supplierManagementCUD1
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 *//*
	@RequestMapping(value="supplierManagementCUD1.do", method=RequestMethod.POST)
	public Map<String, Object> supplierManagementCUD1(HttpServletRequest request) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		//logger.debug("OrganController >> supplierManagementCUD1");
		
		int resultRowCnt = 0;
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String empNo = empSessionDto.getEmp_no();
		
		paramMap = commonUtil.getParamValueMap(request);
		paramMap.put("REG_ID", empNo);
		paramMap.put("MOD_ID", empNo);
		
		try{
			resultRowCnt = organService.saveDlvBsn(paramMap);
			if(resultRowCnt > 0){
				apiService.ifRequestFacRecv(null);
			}
		}catch(Exception ex){
			if("-1".equals(ex.getMessage())){
				String errMesage = messageSource.getMessage("error.common.organ.organ.dlvBsnCd.licensNoCheck", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1001";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
			}else{
				String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "9999";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
				logger.warn(ex.toString());
			}
		}
		
				
		if(crud.equals("R")){
			String errMesage = messageSource.getMessage("error.common.noChanged", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1004";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		}
			
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}*/

	/**
	 * <pre>
	 * 1. 개요 : 납품업체관리
	 * 2. 처리내용 : 해당 업체별 납품 자재정보 저장
	 * </pre>   
	 * @Method Name : supplierManagementCUD2
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "supplierManagementCUD2.do", method=RequestMethod.POST)
	public int supplierManagementCUD2(HttpServletRequest request) throws SQLException, Exception {				
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String empNo = empSessionDto.getEmp_no();
		
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		
		for(Map<String, Object> paramMap : dhtmlxParamMapList){
			paramMap.put("REG_ID", empNo);
			paramMap.put("MOD_ID", empNo);
			
		}
		int resultRowCnt = organService.saveMtrl(dhtmlxParamMapList);

		return resultRowCnt;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 납품업체관리
	 * 2. 처리내용 : 납품업체정보 삭제(사용여부 N 변경)
	 * </pre>   
	 * @Method Name : materialInfoCUD3
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "supplierManagementCUD3.do", method=RequestMethod.POST)
	public int supplierManagementCUD3(HttpServletRequest request) throws SQLException, Exception {				
		
		Map<String, Object> paramMap = new HashMap<String, Object>();

		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String empNo = empSessionDto.getEmp_no();
		
		paramMap = commonUtil.getParamValueMap(request);
		paramMap.put("MOD_REQ_ID", empNo);
		
		int resultRowCnt = organService.deleteDlvBsn(paramMap);

		return resultRowCnt;
	}

	/**
	 * <pre>
	 * 1. 개요 : 납품업체별 자재목록 조회
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : cstmMaterialR1
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "cstmMaterialR1.do", method=RequestMethod.POST)
	public Map<String, Object> cstmMaterialR1(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String dlvBsnCd = request.getParameter("DLV_BSN_CD");
		if(dlvBsnCd == null || dlvBsnCd.length() == 0){
			String errMesage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("DLV_BSN_CD", dlvBsnCd);
			List<Map<String, Object>> materialList = organService.getCstmMtrlList(paramMap);
			resultMap.put("dataList", materialList);
		}
		return resultMap;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 조직정보관리 화면조회
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : organManagement
	 * @param request
	 * @return
	 */
	@RequestMapping("/organManagement.sis")
	public ModelAndView organManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "organManagement");
		return mav;
	}

	/**
	  * getOrgnList - 조직 목록 조회
	  * @author 주병훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getOrgnList.do", method=RequestMethod.POST)
	public Map<String, Object> menuManagementR1(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> allMenuMapList = organService.getOrgnList();
		if(allMenuMapList == null || allMenuMapList.isEmpty()){
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
			rootMap.put("text", "통합영업관리시스템");
			rootMap.put("item", allMenuMapList);
			rootMapList.add(rootMap);
			
			menuTreeMap.put("id", "0");
			menuTreeMap.put("item", rootMapList);	
			resultMap.put("menuTreeMap", menuTreeMap);
		}			
		return resultMap;
	}
	
	/**
	  * getOrgn - 조직 조회
	  * @author 주병훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getOrgn.do", method=RequestMethod.POST)
	public Map<String, Object> getOrgn(HttpServletRequest request) throws SQLException, Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		String ctgrCd = request.getParameter("ORGN_CD");
		if(ctgrCd == null || ctgrCd.length() == 0){
			String errMesage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("ORGN_CD", ctgrCd);
			Map<String, Object> mtrlMap = organService.getOrgn(paramMap);
			resultMap.put("dataMap", mtrlMap);
		}
		return resultMap;
	}
	
	/**
	  * insertOrgn - 조직 CUD
	  * @author 주병훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="insertOrgn.do", method=RequestMethod.POST)
	public Map<String, Object> insertOrgn(HttpServletRequest request) throws SQLException, Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String empNo = empSessionDto.getEmp_no();
		
		paramMap = commonUtil.getParamValueMap(request);
		
		String crud = paramMap.get("CRUD").toString();
		String orgnNm = paramMap.get("ORGN_NM").toString();
		
		String regReqId = empNo;
		paramMap.put("REG_REQ_ID", regReqId);

		if(crud == null || crud.equals("")){				
			String errMesage = messageSource.getMessage("error.common.noChanged", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			if("C".equals(crud) || "U".equals(crud)){
				if(orgnNm == null || "".equals(orgnNm)){
					String errMesage = messageSource.getMessage("error.common.system.master.category.stndCtgrNm.noData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1002";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			}
		}
		if(resultMap.keySet().size() == 0){
			
			if(resultMap.keySet().size() == 0){
				int resultRowCnt = organService.insertOrgn(paramMap);
				
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
	  * getOrgn - 조직 조회
	  * @author 주병훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getOrgnListSession.do", method=RequestMethod.POST)
	public Map<String, Object> getOrgnListSession(HttpServletRequest request) throws SQLException, Exception {

		Map <String, Object> resultMap = new HashMap<String, Object>();

		Map<String, Object> paramMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);

		/*String author_scope_cd = empSessionDto.getAuthor_scope_cd();*/
		String deptCd = empSessionDto.getOrgn_cd();
		String orgnDivCd = request.getParameter("ORGN_DIV_CD");

		paramMap.put("DEPT_CD", deptCd);
		paramMap.put("ORGN_DIV_CD", orgnDivCd);
		
		List<Map<String, Object>> commonCodeList = null;

		commonCodeList = organService.getOrgnListSession(paramMap);
		resultMap.put("commonCodeList", commonCodeList);
		
		return resultMap;
	}
	
	/**
	  * getOrgn - 백화점 조직 조회
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getDepartmentStoreOrgnListSession.do", method=RequestMethod.POST)
	public Map<String, Object> getDepartmentStoreOrgnListSession(HttpServletRequest request) throws SQLException, Exception {

		Map <String, Object> resultMap = new HashMap<String, Object>();

		Map<String, Object> paramMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);

		/*String author_scope_cd = empSessionDto.getAuthor_scope_cd();*/
		String deptCd = empSessionDto.getOrgn_cd();
		String orgnDivCd = request.getParameter("ORGN_DIV_CD");

		paramMap.put("DEPT_CD", deptCd);
		paramMap.put("ORGN_DIV_CD", orgnDivCd);
		
		List<Map<String, Object>> commonCodeList = null;

		commonCodeList = organService.getDepartmentStoreOrgnListSession(paramMap);
		resultMap.put("commonCodeList", commonCodeList);
		
		return resultMap;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 조직관리
	 * 2. 처리내용 : 조직별 회계코드 저장
	 * </pre>   
	 * @Method Name : insertErpCode
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "insertErpCode.do", method=RequestMethod.POST)
	public Map<String, Object> insertErpCode(HttpServletRequest request) throws SQLException, Exception {				
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String empNo = empSessionDto.getEmp_no();

		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> paramMap : dhtmlxParamMapList){
			paramMap.put("REG_ID", empNo);
			paramMap.put("MOD_ID", empNo);
		}
		
		int resultRowCnt = 0;
		Map<String, Object> resultCheckMap = organService.getErpCodeCheck(dhtmlxParamMapList);
		
		int resultCnt = (int) resultCheckMap.get("resultInt");
		String resultStr = (String) resultCheckMap.get("resultStr");
		
		if(resultCnt > 0){
			String errMesage = messageSource.getMessage("error.common.organ.employee.erpCode.overlapData", new Object[1], commonUtil.getDefaultLocale());
			String errCode = resultStr.substring(0, resultStr.length()-1);
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			resultRowCnt = organService.insertErpCode(dhtmlxParamMapList);
			resultMap.put("resultRowCnt", resultRowCnt);
		}

		return resultMap;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 조직관리
	 * 2. 처리내용 : 조직별 회계코드 목록 조회
	 * </pre>   
	 * @Method Name : getErpCodeList
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value = "getErpCodeList.do", method=RequestMethod.POST)
	public Map<String, Object> getErpCodeList(HttpServletRequest request) throws SQLException, Exception {				
		Map<String, Object> resultMap = new HashMap<String, Object>();

		String orgnCd = request.getParameter("ORGN_CD");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ORGN_CD", orgnCd);

		List<Map<String, Object>> erpCodeList = organService.getErpCodeList(paramMap);	
						
		resultMap.put("gridDataList", erpCodeList);
		
		return resultMap;
	}
	
	/**
	 * <pre>
	 *	1. 개요 : 세션에서 공장코드 가져오기
	 *  2. 처리내용 : 세션에서 자기 공장 제외한 나머지 공장 가져오기
	 * </pre>   
	 * @Method Name : getNotOrgnListSession
	 * @param request
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getNotOrgnListSession.do", method=RequestMethod.POST)
	public Map<String, Object> getNotOrgnListSession(HttpServletRequest request) throws SQLException, Exception {

		Map <String, Object> resultMap = new HashMap<String, Object>();

		Map<String, Object> paramMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);

		/*String author_scope_cd = empSessionDto.getAuthor_scope_cd();*/
		String deptCd = empSessionDto.getOrgn_cd();
		String orgnDivCd = request.getParameter("ORGN_DIV_CD");
		
		paramMap.put("DEPT_CD", deptCd);
		paramMap.put("ORGN_DIV_CD", orgnDivCd);
		
		List<Map<String, Object>> commonCodeList = null;

		commonCodeList = organService.getNotOrgnListSession(paramMap);
		resultMap.put("commonCodeList", commonCodeList);
		
		return resultMap;
	}
	
	/**
	  * getOrgnDivCdByOrgnCd - 조직코드로 조직구분코드 불러오기
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getOrgnDivCdByOrgnCd.do", method = RequestMethod.POST)
	public Map<String, Object> getOrgnDivCdByOrgnCd(HttpServletRequest request, @RequestParam String ORGN_CD) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String ORGN_DIV_CD = "";
		
		try {
			ORGN_DIV_CD = organService.getOrnginDivCdByOrgnCd(ORGN_CD);
			resultMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
}
