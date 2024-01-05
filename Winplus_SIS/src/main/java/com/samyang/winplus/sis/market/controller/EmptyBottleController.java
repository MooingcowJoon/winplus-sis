package com.samyang.winplus.sis.market.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.sis.market.service.EmptyBottleService;

@RestController
@RequestMapping("/sis/market/emptybottle")
public class EmptyBottleController extends BaseController{
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final static String DEFAULT_PATH = "sis/market/emptybottle";
	
	@Autowired
	private EmptyBottleService emptyBottleService;

	
	/**
	  * 직영점엄무관리 - 공병관리 - 공병회수반납조회
	  * @author 한정훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="searchEmptyBottleReturn.sis", method=RequestMethod.POST)
	public ModelAndView emptyBottleReturn(HttpServletRequest request, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "/" + "searchEmptyBottleReturn");
		return mav;
	}
	
	/**
	  * 직영점엄무관리 - 공병관리 - 공병회수반납조회 - 헤더 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getEBRHList.do", method=RequestMethod.POST)
	public Map<String, Object> getEBRHList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) 
			throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("getEBRHList paramMap >>>> " + paramMap );
		List<Map<String, Object>> getEBRHList = emptyBottleService.getEBRHList(paramMap);
		resultMap.put("gridDataList", getEBRHList);
		
		return resultMap;
	}
	/**
	  * 직영점엄무관리 - 공병관리 - 공병회수반납조회 - 디테일 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getEBRDList.do", method=RequestMethod.POST)
	public Map<String, Object> getEBRDList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) 
			throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("getEBRDList paramMap >>>> " + paramMap );
		List<Map<String, Object>> getEBRDList = emptyBottleService.getEBRDList(paramMap);
		resultMap.put("gridDataList", getEBRDList);
		
		return resultMap;
	}
}
