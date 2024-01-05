package com.samyang.winplus.common.terminal.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.terminal.service.TerminalManagementService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;


@RequestMapping("/common/terminal")
@RestController
public class TerminalManagementController extends BaseController {
	
	private final static String DEFAULT_PATH = "common/terminal";
	
	@Autowired
	TerminalManagementService terminalManagementService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	/**
	 * 단말기관리 - 직영점단말기관리
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="retailTerminalManagement.sis", method=RequestMethod.POST)
	public ModelAndView retailTerminalManagement(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "retailTerminalManagement");
		return mav;
	}
	
	/**
	  * 시스템관리 - 단말기관리- 직영점단말기관리 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getTerminalList.do", method=RequestMethod.POST)
	public Map<String, Object> getTerminalList(HttpServletRequest request) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
				  
		String ORGN_CD = request.getParameter("ORGN_CD");
		paramMap.put("ORGN_CD", ORGN_CD);
		String TRML_TYPE = request.getParameter("TRML_TYPE");
		paramMap.put("TRML_TYPE", TRML_TYPE);
		try {
			List<Map<String, Object>> gridDataList = terminalManagementService.getTerminalList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}  
	
	/**
	  * 시스템관리 - 단말기관리- 직영점단말기관리 저장
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Transactional
	@RequestMapping(value="saveTerminalList.do", method=RequestMethod.POST)
	public Map<String, Object> saveTerminalList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String CUSER = empSessionDto.getEmp_no();
		String MUSER = empSessionDto.getEmp_no();
		String CPROGRM = "saveTerminalList";
		String MPROGRM = "saveTerminalList";
		String MEMO = "";
		
		int insertResult = 0;
		int deleteResult = 0;
		int updateResult = 0;
		
		try {
			for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
				paramMap = dhtmlxParamMapList.get(i);
				paramMap.put("MEMO", MEMO);
				paramMap.put("CPROGRM", CPROGRM);
				paramMap.put("CUSER", CUSER);
	
				if(paramMap.get("CRUD").equals("C")){
					insertResult = terminalManagementService.addTerminalList(paramMap);
				
				} else if (paramMap.get("CRUD").equals("D")) {
					deleteResult = terminalManagementService.deleteTerminalList(paramMap);
					
				} else if (paramMap.get("CRUD").equals("U")) {
					paramMap.put("MUSER", MUSER);
					paramMap.put("MPROGRM", MPROGRM);
					
					updateResult = terminalManagementService.updateTerminalList(paramMap);
				}
			}
			resultMap.put("insertResult", insertResult);
			resultMap.put("deleteResult", deleteResult);
			resultMap.put("updateResult", updateResult);
		}catch(SQLException e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		} finally {
			if(resultMap.containsKey("isError")) {
				if(resultMap.get("isError") != null && (boolean) resultMap.get("isError")) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				}
			}
		}
		return resultMap;
	}
}
