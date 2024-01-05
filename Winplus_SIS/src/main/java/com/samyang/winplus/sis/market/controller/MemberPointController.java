package com.samyang.winplus.sis.market.controller;

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

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.sis.market.service.MemberPointService;

@RestController
@RequestMapping("/sis/market/member")
public class MemberPointController extends BaseController{
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final String DEFAULT_PATH = "sis/market/member";
	
	@Autowired
	private MemberPointService memberPointService;
	
	/**
	  * searchMemberPoint - 회원포인트조회
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "searchMemberPoint.sis", method = RequestMethod.POST)
	public ModelAndView searchMemberPoint(HttpServletRequest request) {
		//logger.debug("DEFAULT_PATH >> " + DEFAULT_PATH);
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "searchMemberPoint");
		return mav;
	}
	
	/**
	  * getMemberPointList - 회원포인트조회 - 조회내역
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getMemberPointList.do", method = RequestMethod.POST)
	public Map<String, Object> getMemberPointList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		//logger.debug("paramMap >>>> " + paramMap);
		
		try {
			gridDataList = memberPointService.getMemberPointList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
}
