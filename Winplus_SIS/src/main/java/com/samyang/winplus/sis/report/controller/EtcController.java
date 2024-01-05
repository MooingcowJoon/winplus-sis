package com.samyang.winplus.sis.report.controller;

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
import com.samyang.winplus.sis.report.service.EtcService;

@RequestMapping("/sis/report/etc")
@RestController
public class EtcController extends BaseController{
	
	private final static String DEFAULT_PATH = "sis/report/etc";
	
	@Autowired
	EtcService etcService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	/**
	 * searchSlipLog - 전표이력조회
	 * @author 정혜원
	 * @param  request
	 * @return ModelAndView
	 */
	@RequestMapping(value="searchSlipLog.sis", method=RequestMethod.POST)
	public ModelAndView searchSlipLog(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "searchSlipLog");
		return mav;
	}
	
	/**
	 * bondDebtStatus - 채권/채무 현황
	 * @author 정혜원
	 * @param  request
	 * @return ModelAndView
	 */
	@RequestMapping(value="bondDebtStatus.sis", method=RequestMethod.POST)
	public ModelAndView bondDebtStatus(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "bondDebtStatus");
		return mav;
	}
	
	/**
	 * priceChangeTable - 단가변동표
	 * @author 정혜원
	 * @param  request
	 * @return ModelAndView
	 */
	@RequestMapping(value="priceChangeTable.sis", method=RequestMethod.POST)
	public ModelAndView priceChangeTable(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "priceChangeTable");
		return mav;
	}
	
	/**
	 * summaryTable - 집계표
	 * @author 정혜원
	 * @param  request
	 * @return ModelAndView
	 */
	@RequestMapping(value="summaryTable.sis", method=RequestMethod.POST)
	public ModelAndView summaryTable(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "summaryTable");
		return mav;
	}
	
	/**
	 * searchSlipLog - 전표이력조회 - 작업대상 '협력사' 조회내역
	 * @author 정혜원
	 * @param  request
	 * @return ModelAndView
	 */
	@RequestMapping(value="getCustmrSlipList.do", method=RequestMethod.POST)
	public Map<String, Object> getCustmrSlipList(HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String GOODS_NM = request.getParameter("GOODS_NM");
		
		//logger.debug("GOODS_NM >>>> " + GOODS_NM);
		return resultMap;
	}
	
	/**
	 * searchSlipLog - 전표이력조회 - 작업대상 '품목' 조회내역
	 * @author 정혜원
	 * @param  request
	 * @return ModelAndView
	 */
	@RequestMapping(value="getGoodsSlipList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsSlipList(HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String GOODS_NO = request.getParameter("GOODS_NO");
		
		//logger.debug("GOODS_NO >>>> " + GOODS_NO);
		
		return resultMap;
	}
	
	/**
	  * getPriceChangeList - 단가변동표 조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getPriceChangeList.do", method = RequestMethod.POST)
	public Map<String, Object> getPriceChangeList(HttpServletRequest request ,@RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap 1111 >>> " + paramMap);
		
		String CUSTMR_CD = paramMap.get("CUSTMR_CD").toString().replace("&#39;", "'");
		String BCD_CD = paramMap.get("BCD_CD").toString().replace("&#39;", "'");
		
		paramMap.put("CUSTMR_CD", CUSTMR_CD);
		paramMap.put("BCD_CD", BCD_CD);
		
		//logger.debug("paramMap 2222 >>> " + paramMap);

		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		try {
			gridDataList = etcService.getPriceChangeList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			
		}catch(Exception e) {
			
		}
		
		
		return resultMap;
	}
	
}
