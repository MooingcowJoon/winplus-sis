package com.samyang.winplus.addin.code.controller;

import java.sql.SQLException;
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

import com.samyang.winplus.addin.code.service.AddInFixedValuesService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;

/** 
 * 엑셀 에드인 값 유효성 체크에 사용
 * @since 2019.06.05
 * @author 조승현
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2019.06.05 / 조승현 / 신규 생성
 *********************************************
 */
@RequestMapping("/addin/fixedvalues")
@RestController
public class AddInFixedValuesController extends BaseController {
	
	static Logger logger = LoggerFactory.getLogger(Thread.currentThread().getStackTrace()[1].getClassName());
	
	@Autowired
	AddInFixedValuesService addInFixedValuesService;
	
	private final static String DEFAULT_PATH = "addin/fixedvalues";
	
	/**
	  * addInFixedValuesManagement - 에드인 고정 값 관리 - 화면 조회
	  * @author 조승현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="addInFixedValuesManagement.sis", method=RequestMethod.POST)
	public ModelAndView commonManagement(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "addInFixedValuesManagement");
		return mav;
	}
	
	/**
	  * SELECT_addInFixedValuesMaster - 고정 값 마스터 조회
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="SELECT_addInFixedValuesMaster.do", method=RequestMethod.POST)
	public Map<String, Object> SELECT_addInFixedValuesMaster(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			List<Map<String, Object>> addInFixedValuesList = addInFixedValuesService.getMaster(paramMap);				
			resultMap.put("gridDataList", addInFixedValuesList);
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
	  * CUD_addInFixedValuesMaster - 고정 값 마스터 저장
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="CUD_addInFixedValuesMaster.do", method=RequestMethod.POST)
	public Map<String, Object> CUD_addInFixedValuesMaster(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		
		try{
			int resultRowCnt = addInFixedValuesService.saveMaster(dhtmlxParamMapList);
			resultMap.put("resultRowCnt", resultRowCnt);
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
	  * SELECT_addInFixedValuesDetail - 고정 값 디테일 조회
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="SELECT_addInFixedValuesDetail.do", method=RequestMethod.POST)
	public Map<String, Object> SELECT_addInFixedValuesDetail(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			List<Map<String, Object>> addInFixedValuesDetailList = addInFixedValuesService.getDetail(paramMap);				
			resultMap.put("gridDataList", addInFixedValuesDetailList);
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
	  * CUD_addInFixedValuesDetail - 고정 값 디테일 저장
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="CUD_addInFixedValuesDetail.do", method=RequestMethod.POST)
	public Map<String, Object> CUD_addInFixedValuesDetail(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		
		try{
			int resultRowCnt = addInFixedValuesService.saveDetail(dhtmlxParamMapList);
			resultMap.put("resultRowCnt", resultRowCnt);
		}catch(SQLException e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}

		return resultMap;
	}
	
}
