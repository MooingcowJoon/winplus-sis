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

import com.samyang.winplus.common.pos.service.PosMessageManagementService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;

@RestController
@RequestMapping("/common/pos/PosMessageManagement")
public class PosMessageManagementController extends BaseController{
	
	@Autowired
	PosMessageManagementService posMessageManagementService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final static String DEFAULT_PATH = "common/linkedPOS";
	
	/**
	 * 시스템관리 - POS연동관리 - 메시지관리(POS연동) 
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="/messageManagement.sis", method=RequestMethod.POST)
	public ModelAndView messageManagement(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "messageManagement");
		return mav;
	}
	
	
	/**
	 * 시스템관리 - POS연동관리 - 메시지관리(POS연동) - 내역조회
	 * @author 정혜원
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="/getPosMessageList.do", method=RequestMethod.POST)
	public Map<String, Object> getPosMessageList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try{
			List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
			gridDataList = posMessageManagementService.getPosMessageList(paramMap);
		}catch(SQLException e) {
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	 * 시스템관리 - POS연동관리 - 메시지관리(POS연동) - 저장
	 * @author 정혜원
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="SavePosMessageList.do", method=RequestMethod.POST)
	public Map<String, Object> SavePosMessageList(HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		
		int insertResult = 0;
		int deleteResult = 0;
		int updateResult = 0;
		
		String CRUD = "";
		String MK_CD = "";
		String WORKDATE_SEQNO = "";
		String MSG_CD = "";
		String ARGUMENT_CNT = "";
		String ARGUMENT_MASK = "";
		String MSG_KIND = "";
		String MSG_KIND_2 = "";
		String DISP_FG = "";
		String CONFIRM_FG = "";
		String MSG = "";
		String CUSER = empSessionDto.getEmp_no();
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			MK_CD = (dhtmlxParamMapList.get(i).get("MK_CD")).toString();
			WORKDATE_SEQNO = (dhtmlxParamMapList.get(i).get("WORKDATE_SEQNO")).toString();
			MSG_CD = (dhtmlxParamMapList.get(i).get("MSG_CD")).toString();
			ARGUMENT_CNT = (dhtmlxParamMapList.get(i).get("ARGUMENT_CNT")).toString();
			ARGUMENT_MASK = (dhtmlxParamMapList.get(i).get("ARGUMENT_MASK")).toString();
			MSG_KIND = (dhtmlxParamMapList.get(i).get("MSG_KIND")).toString();
			MSG_KIND_2 = (dhtmlxParamMapList.get(i).get("MSG_KIND_2")).toString();
			DISP_FG = (dhtmlxParamMapList.get(i).get("DISP_FG")).toString();
			CONFIRM_FG = (dhtmlxParamMapList.get(i).get("CONFIRM_FG")).toString();
			MSG = (dhtmlxParamMapList.get(i).get("MSG")).toString();
			
			paramMap.put("MK_CD", MK_CD);
			paramMap.put("WORKDATE_SEQNO", WORKDATE_SEQNO);
			paramMap.put("MSG_CD", MSG_CD);
			paramMap.put("ARGUMENT_CNT", ARGUMENT_CNT);
			paramMap.put("ARGUMENT_MASK", ARGUMENT_MASK);
			paramMap.put("MSG_KIND", MSG_KIND);
			paramMap.put("MSG_KIND_2", MSG_KIND_2);
			paramMap.put("DISP_FG", DISP_FG);
			paramMap.put("CONFIRM_FG", CONFIRM_FG);
			paramMap.put("MSG", MSG);
			paramMap.put("CPROGRM", "SavePosMessageList");
			paramMap.put("CUSER", CUSER);
			
			if(dhtmlxParamMapList.get(i).get("CRUD").equals("C")){
				CRUD = "C";
				paramMap.put("CRUD", CRUD);
				
				//insertResult = posMessageManagementService.AddMessageManagementList(paramMap);
			} else if(dhtmlxParamMapList.get(i).get("CRUD").equals("D")) {
				CRUD = "D";
				paramMap.put("CRUD", CRUD);
				
				//deleteResult = posMessageManagementService.DeleteMessageManagementList(paramMap);
			} else if(dhtmlxParamMapList.get(i).get("CRUD").equals("U")) {
				CRUD = "U";
				paramMap.put("CRUD", CRUD);
				//updateResult = posMessageManagementService.UpdateMessageManagementList(paramMap);
			}
		}
		
		return resultMap;
	}
}
