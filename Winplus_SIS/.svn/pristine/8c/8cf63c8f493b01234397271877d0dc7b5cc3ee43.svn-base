package com.samyang.winplus.sis.sales.controller;

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

import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;
import com.samyang.winplus.sis.sales.service.SalesManagementCenterService;

@RequestMapping("/sis/sales/salesManagementCenter")
@RestController
public class SalesManagementCenterController {

	@Autowired
	protected CommonUtil commonUtil;
	
	@Autowired
	SalesManagementCenterService salesManagementCenterService;
	
	@SuppressWarnings("unused")
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final static String DEFAULT_PATH = "sis/sales/salesManagementCenter";
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확인
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="supplyCheck.sis", method=RequestMethod.POST)
	public ModelAndView supplyCheck(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "supplyCheck");
		return mav;
	}
	
	/**
	* 센터/구매 업무 - 판매 - 판매내역(센터)_조회
	* @author 한정훈
	* @param request
	* @return ModelAndView
	*/
	@RequestMapping(value="supplyCheckByCenter.sis", method=RequestMethod.POST)
	public ModelAndView supplyCheckByCenter(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "supplyCheckByCenter");
		return mav;
	}
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확인 - 헤더그리드 조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSuprBySupplyHeaderList.do", method=RequestMethod.POST)
	public Map<String, Object> getSuprBySupplyHeaderList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> SuprBySupplyHeaderList = new ArrayList<Map<String, Object>>();
		
		try {
			SuprBySupplyHeaderList = salesManagementCenterService.getSuprBySupplyHeaderList(paramMap);
			resultMap.put("dataMap", SuprBySupplyHeaderList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확인 - 디테일그리드 조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSuprBySupplyDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getSuprBySupplyDetailList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> SuprBySupplyDetailList = new ArrayList<Map<String, Object>>();
		
		try {
			SuprBySupplyDetailList = salesManagementCenterService.getSuprBySupplyDetailList(paramMap);
			resultMap.put("dataMap", SuprBySupplyDetailList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확인 - 디테일그리드 저장
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="saveSuprBySupplyDetailInfo.do", method=RequestMethod.POST)
	public Map<String, Object> saveSuprBySupplyDetailInfo(HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		int resultValue = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("emp_no", emp_no);
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			paramMap.put("SALE_AMT", dhtmlxParamMapList.get(i).get("SALE_AMT"));
			paramMap.put("SALE_VAT_AMT", dhtmlxParamMapList.get(i).get("SALE_VAT_AMT"));
			paramMap.put("SALE_TOT_AMT", dhtmlxParamMapList.get(i).get("SALE_TOT_AMT"));
			paramMap.put("ORGN_CD", dhtmlxParamMapList.get(i).get("ORGN_CD"));
			paramMap.put("CUSTMR_CD", dhtmlxParamMapList.get(i).get("CUSTMR_CD"));
			paramMap.put("ORD_CD", dhtmlxParamMapList.get(i).get("ORD_CD"));
			paramMap.put("BCD_CD", dhtmlxParamMapList.get(i).get("BCD_CD"));
			try {
				resultValue = resultValue + salesManagementCenterService.saveSuprBySupplyDetailInfo(paramMap);
			}catch(SQLException e) {
				resultMap = commonUtil.getErrorMap(e);
			}catch(Exception e) {
				resultMap = commonUtil.getErrorMap(e);
			}
		}
		
		if(dhtmlxParamMapList.size() == resultValue) {
			resultMap.put("resultMessage", "수정사항이 정상적으로 저장되었습니다.");
		} else{
			resultMap.put("resultMessage", "수정사항이 정상적으로 저장되었습니다.");
		}
		
		return resultMap;
	} 
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확정
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="supplyConfirm.sis", method=RequestMethod.POST)
	public ModelAndView supplyConfirm(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "supplyConfirm");
		return mav;
	}
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확정 - 헤더그리드 조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSuprBySupplyConfirmHeaderList.do", method=RequestMethod.POST)
	public Map<String, Object> getSuprBySupplyConfirmHeaderList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> SuprByPurchaseHeaderList = new ArrayList<Map<String, Object>>();
		
		try {
			SuprByPurchaseHeaderList = salesManagementCenterService.getSuprBySupplyConfirmHeaderList(paramMap);
			resultMap.put("dataMap", SuprByPurchaseHeaderList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확정 - 디테일그리드 조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getSuprBySupplyConfirmDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getSuprBySupplyConfirmDetailList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> SuprByPurchaseDetailList = new ArrayList<Map<String, Object>>();
		
		try {
			SuprByPurchaseDetailList = salesManagementCenterService.getSuprBySupplyConfirmDetailList(paramMap);
			resultMap.put("dataMap", SuprByPurchaseDetailList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확정 - 업체별납품내역 승인
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="approvalSuprBySupplyConfirm.do", method=RequestMethod.POST)
	public Map<String, Object> approvalSuprBySupplyConfirm(HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		int resultValue = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("emp_no", emp_no);
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			if(!dhtmlxParamMapList.get(i).get("SEND_TYPE").equals("ERP")){
				paramMap.put("ORGN_CD", dhtmlxParamMapList.get(i).get("ORGN_CD"));
				paramMap.put("CUSTMR_CD", dhtmlxParamMapList.get(i).get("CUSTMR_CD"));
				paramMap.put("ORD_DATE", dhtmlxParamMapList.get(i).get("ORD_DATE"));
				try {
					resultValue = resultValue + salesManagementCenterService.approvalSuprBySupplyConfirm(paramMap);
				}catch(SQLException e) {
					resultMap = commonUtil.getErrorMap(e);
				}catch(Exception e) {
					resultMap = commonUtil.getErrorMap(e);
				}
			}
		}
		resultMap.put("resultMessage", "요청하신 "+ dhtmlxParamMapList.size() + "건이 모두 정상적으로 승인처리 되었습니다.");
		
		return resultMap;
	}
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확정 - 업체별납품내역 취소
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="cancleSuprBySupplyConfirm.do", method=RequestMethod.POST)
	public Map<String, Object> cancleSuprBySupplyConfirm(HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		int resultValue = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("emp_no", emp_no);
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			if(!dhtmlxParamMapList.get(i).get("SEND_TYPE").equals("ERP")){
				paramMap.put("ORGN_CD", dhtmlxParamMapList.get(i).get("ORGN_CD"));
				paramMap.put("CUSTMR_CD", dhtmlxParamMapList.get(i).get("CUSTMR_CD"));
				paramMap.put("ORD_DATE", dhtmlxParamMapList.get(i).get("ORD_DATE"));
				try {
					resultValue = resultValue + salesManagementCenterService.cancleSuprBySupplyConfirm(paramMap);
				}catch(SQLException e) {
					resultMap = commonUtil.getErrorMap(e);
				}catch(Exception e) {
					resultMap = commonUtil.getErrorMap(e);
				}
			}
		}
		resultMap.put("resultMessage", "요청하신 "+ dhtmlxParamMapList.size() + "건이 모두 정상적으로 취소처리 되었습니다.");
		return resultMap;
	}
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확정 - 확정금액 저장
	  * @author 최지민
	  * @param request
	  * @exception SQLException
	  * @return Integer
	  */
	@RequestMapping(value="saveSupplyConfirm.do", method=RequestMethod.POST)
	public Map<String, Object> saveSupplyConfirm(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		int insertResult = 0;
		int updateResult = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String MUSER = empSessionDto.getEmp_no();
		String MPROGM = "saveSupplyConfirm";
		
		paramMap.put("MUSER", MUSER);
		paramMap.put("MPROGM", MPROGM);
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			paramMap.put("CONF_DETL_AMT", dhtmlxParamMapList.get(i).get("CONF_DETL_AMT"));
			paramMap.put("ORD_CD", dhtmlxParamMapList.get(i).get("ORD_CD"));
			paramMap.put("ORGN_CD", dhtmlxParamMapList.get(i).get("ORGN_CD"));
			paramMap.put("BCD_CD", dhtmlxParamMapList.get(i).get("BCD_CD"));
			try {
				insertResult = insertResult + salesManagementCenterService.saveSupplyConfirm(paramMap);
				updateResult = updateResult + salesManagementCenterService.updateSupplyConfirm(paramMap);
			}catch(SQLException e) {
				resultMap = commonUtil.getErrorMap(e);
			}catch(Exception e) {
				resultMap = commonUtil.getErrorMap(e);
			}
		}
		return resultMap;
	}
}
