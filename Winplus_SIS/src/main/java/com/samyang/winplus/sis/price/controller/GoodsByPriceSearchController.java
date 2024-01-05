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
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.sis.price.service.GoodsByPriceSearchService;

@RequestMapping("/sis/price/")
@RestController
public class GoodsByPriceSearchController extends BaseController{
	
	private final static String DEFAULT_PATH = "sis/price";
	
	@Autowired
	GoodsByPriceSearchService goodsByPriceSearchService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	/**
	 * 단가관리 - 품목별단가 조회(센터) 
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="goodsByPrice.sis", method=RequestMethod.POST)
	public ModelAndView goodsByPrice(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "goodsByPrice");
		return mav;
	}
	
	/**
	 * 단가관리 - 품목별단가 조회(센터) 
	 * @author 정혜원
	 * @param request
	 * @return Map<String, Object>
	 */
	
	@RequestMapping(value="getGoodsByPriceList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsByPriceList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String[] arr_bcd_cd;
		StringBuilder BCD_CD = new StringBuilder();
		String param_bcd_cd = ObjectUtils.isEmpty(paramMap.get("BCD_CD")) ? "" : paramMap.get("BCD_CD").toString();
		
		//검색조건
		if(!param_bcd_cd.equals("")){
			arr_bcd_cd = paramMap.get("BCD_CD").toString().split(",");
			for(int i = 0 ; i < arr_bcd_cd.length ; i++) {
				if(i != arr_bcd_cd.length - 1){
					BCD_CD.append("'"); 
					BCD_CD.append(arr_bcd_cd[i]);
					BCD_CD.append("',");
				} else {
					BCD_CD.append("'");
					BCD_CD.append(arr_bcd_cd[i]);
					BCD_CD.append("'");
				}
			}
		}
		
		paramMap.put("BCD_CD", BCD_CD.toString());
		List<Map<String, Object>> GoodsByPriceList = new ArrayList<Map<String, Object>>();
		
		try{
			GoodsByPriceList = goodsByPriceSearchService.getGoodsByPriceList(paramMap);
			resultMap.put("gridDataList", GoodsByPriceList);
		} catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		
		return resultMap;
	}
	
}
