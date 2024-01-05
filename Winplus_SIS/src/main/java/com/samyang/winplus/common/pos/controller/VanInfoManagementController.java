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

import com.samyang.winplus.common.pos.service.VanInfoManagementService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;

import net.sf.json.JSONObject;

@RestController
@RequestMapping("/common/pos/VanInfoManagement")
public class VanInfoManagementController extends BaseController{
	@Autowired
	VanInfoManagementService vanInfoManagementService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final static String DEFAULT_PATH = "common/linkedPOS";
	
	/**
	  * 시스템관리 - POS연동관리 - 밴사정보관리 - 헤더 - 열기
	  * @author 한정훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="vanInfoManagement.sis", method=RequestMethod.POST)
	public ModelAndView vanInfoManagement(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "vanInfoManagement");
		return mav;
	}
	
	/**
	  * 시스템관리 - POS연동관리 - 밴사정보관리 - 디테일 - 열기, 조회
	  * @author 한정훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openVanInfopopup.sis", method=RequestMethod.POST)
	public ModelAndView openVanInfopopup(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openVanInfopopup");
		
		String jsonParam = request.getParameter("vanInfo");
		Map<String, Object> paramMap = new HashMap<String, Object>();
		JSONObject vanInfo = JSONObject.fromObject(jsonParam);
		String CRUD = vanInfo.getString("CRUD");
		mav.addObject("CRUD", CRUD);
		
		if(CRUD.equals("U") || CRUD.equals("R")) {
			paramMap.put("VAN_CD", vanInfo.getString("VAN_CD"));
			paramMap.put("VAN_SEQ", vanInfo.getString("VAN_SEQ"));
			Map<String, Object> tableData = vanInfoManagementService.getVanDetailInfo(paramMap);
			mav.addObject("tableData", tableData);
		}else {
			mav.addObject("tableData", null);
		}
		return mav;
	}
	/**
	  * 시스템관리 - POS연동관리 - 밴사정보관리 - 헤더 - 조회
	  * @author 한정훈
	  * @param paramMap
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getVanInfoManagementList.do", method=RequestMethod.POST)
	public Map<String, Object> getVanInfoManagementList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> gridDataList = vanInfoManagementService.getVanInfoManagementList(paramMap);
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
	/**
	  * 시스템관리 - POS연동관리 - 밴사정보관리 - 디테일 - 저장 후 검색
	  * @author 한정훈
	  * @param paramMap
	  * throws SQLException
	  * throws Exception
	  * @return Map<String, Object
	  */
	@RequestMapping(value="crudVanInfo.do", method=RequestMethod.POST)
	public Map<String, Object> crudVanInfo(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		boolean isValidated = true;
		int PORT = Integer.parseInt((String) paramMap.get("PORT"));
		int IP1 = Integer.parseInt((String) paramMap.get("IP1"));
		int IP2 = Integer.parseInt((String) paramMap.get("IP2"));
		int IP3 = Integer.parseInt((String) paramMap.get("IP3"));
		int IP4 = Integer.parseInt((String) paramMap.get("IP4"));
		
		if(PORT < 0 || PORT > 65535) {
			isValidated = false;
		}
		if(IP1 < 0 || IP1 > 255) {
			isValidated = false;		
		}
		if(IP2 < 0 || IP2 > 255) {
			isValidated = false;
		}
		if(IP3 < 0 || IP3 > 255) {
			isValidated = false;
		}
		if(IP4 < 0 || IP4 > 255) {
			isValidated = false;
		}
		resultMap.put("isValidated", isValidated);
		if(!isValidated) {
			
		} else {
			Map<String, Object> tableDataMap = vanInfoManagementService.crudVanInfo(paramMap);
			resultMap.put("tableDataMap", tableDataMap);
		}
		return resultMap;
	}
	/**
	  * 시스템관리 - POS연동관리 - 밴사정보관리 - 헤더 - 삭제
	  * @author 한정훈
	  * @param paramMap
	  * throws SQLException
	  * throws Exception
	  * @return Map<String, Object
	  */
	@RequestMapping(value="deleteVanInfo.do", method=RequestMethod.POST)
	public int deleteVanInfo(HttpServletRequest request) throws SQLException, Exception{
		int deleteCnt = 0;
		Map<String, Object> paramMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		
		for(int i = 0 ; i < dhtmlxParamMapList.size(); i++) {
			paramMap = dhtmlxParamMapList.get(i);
			Map<String, Object> resultMap =  vanInfoManagementService.crudVanInfo(paramMap);
			deleteCnt += (int)resultMap.get("RESULT");
		}
		return deleteCnt;
	}
}
