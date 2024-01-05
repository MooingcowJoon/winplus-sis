package com.samyang.winplus.sis.price.controller;

import java.sql.SQLException;
import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.sis.price.service.GoodsCenterEventPriceService;

@RestController
@RequestMapping("/sis/price/")
public class GoodsCenterEventPriceController extends BaseController{

	
	private final static String DEFAULT_PATH = "sis/price";
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	GoodsCenterEventPriceService goodsCenterEventPriceService;

	/**
	 * goodsCenterEventPrice: 단가관리 - 행사가관리(센터) 
	 * @author 강현규
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="goodsCenterEventPrice.sis", method=RequestMethod.POST)
	public ModelAndView goodsByPrice(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "goodsCenterEventPrice");
		return mav;
	}
	
	/**
	 * getCenterEventList : 단가관리 - 행사가관리(센터) 조회 
	 * @author 강현규
	 * @param request
	 * @return Map<String, Object>
	 */
	@ResponseBody
	@RequestMapping(value="getCenterEventList.do", method=RequestMethod.POST)
	public Map<String, Object> getCenterEventList(HttpServletRequest request, @RequestBody Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		//logger.debug("getCenterEventList paramMap >>>> " + paramMap );
		resultMap.put("gridDataList", goodsCenterEventPriceService.getCenterEventList(paramMap));
		
		return resultMap;
	}
	
	/**
	 * insertCenterEventList : 단가관리 - 행사가관리(센터) 저장, 수정 (등록)
	 * @author 강현규
	 * @param request
	 * @return Map<String, Object>
	 */
	@ResponseBody
	@RequestMapping(value="insertCenterEventList.do", method=RequestMethod.POST)
	public Map<String, Object> insertCenterEventList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		int resultRowCnt = goodsCenterEventPriceService.insertCenterEventList((List<Map<String, Object>>) paramMap.get("listMap"));
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 행사할 상품 정보 가져오기
	 */
	@ResponseBody
	@RequestMapping(value="getCenterEventGoodsInfo.do", method=RequestMethod.POST)
	public Map<String,Object> getCenterEventPrice(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", goodsCenterEventPriceService.getCenterEventGoodsInfo(paramMap));
		return resultMap;
	}
	

	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 행사할 상품 리스트 CRUD
	 */
	@ResponseBody
	@RequestMapping(value="crudCenterEventGoodsList.do", method=RequestMethod.POST)
	public Map<String,Object> crudCenterEventGoodsList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		goodsCenterEventPriceService.crudCenterEventGoodsList(paramMap);
		return resultMap;
	}
	
	/**
	 * @author 최지민
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 행사할 상품 리스트 CRUD
	 */
	@ResponseBody
	@RequestMapping(value="crudCenterEventGoodsPurList.do", method=RequestMethod.POST)
	public Map<String,Object> crudCenterEventGoodsPurList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		goodsCenterEventPriceService.crudCenterEventGoodsPurList(paramMap);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 센터 행사상품 리스트 가져오기
	 */
	@ResponseBody
	@RequestMapping(value="getCenterEventGoodsList.do", method=RequestMethod.POST)
	public Map<String,Object> getCenterEventGoodsList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", goodsCenterEventPriceService.getCenterEventGoodsList(paramMap));
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 행사 상품을 적용할 거래처 정보 가져오기
	 */
	@ResponseBody
	@RequestMapping(value="getCenterEventCustmrInfo.do", method=RequestMethod.POST)
	public Map<String,Object> getCenterEventCustmrInfo(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", goodsCenterEventPriceService.getCenterEventCustmrInfo(paramMap));
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 행사 상품을 적용한 거래처 리스트
	 */
	@ResponseBody
	@RequestMapping(value="crudCenterEventCustmrList.do", method=RequestMethod.POST)
	public Map<String,Object> crudCenterEventCustmrList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		goodsCenterEventPriceService.crudCenterEventCustmrList(paramMap);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 
	 */
	@ResponseBody
	@RequestMapping(value="getCenterEventCustmrList.do", method=RequestMethod.POST)
	public Map<String,Object> getCenterEventCustmrList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", goodsCenterEventPriceService.getCenterEventCustmrList(paramMap));
		return resultMap;
	}
}
