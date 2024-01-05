package com.samyang.winplus.sis.basic.controller;

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
import com.samyang.winplus.sis.basic.service.VirtualAcntService;

@RestController
@RequestMapping("/sis/basic")
public class VirtualAcntController extends BaseController {

	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final String DEFAULT_PATH = "sis/basic";;

	@Autowired
	private VirtualAcntService virtualAcntService;
	
	/**
	 * 유통사업 업무 - 고객사 - 고객사가상계좌_조회
	 * @author 한정훈
	 * @param mav
	 * @return ModelAndView
	 */
	@RequestMapping(value="VirtualAcntByCustomer.sis", method=RequestMethod.POST)
	public ModelAndView VirtualAcntByCustomer(ModelAndView mav) throws SQLException, Exception {
		Map<String, Object> SearchData = new HashMap<String, Object>();
		SearchData.put("ORGN_DIV_CD", "Z01");	//공통코드 참고(VRT_ORG_CD)
		SearchData.put("ORGN_CD", "900000");
		
		Map<String, Object> SearchInfo = virtualAcntService.getVirtualAcntTableInfo(SearchData);
		mav.addObject("SearchInfo", SearchInfo);
		mav.setViewName(DEFAULT_PATH + "/" + "VirtualAcntByCustomer");
		return mav;
	}
	/**
	 * 직영점 업무 - 마감/승인 - 신용승인 - 가상계좌현황(회원)_조회
	 * @author 한정훈
	 * @param mav
	 * @return ModelAndView
	 */
	@RequestMapping(value="VirtualAcntByMember.sis", method=RequestMethod.POST)
	public ModelAndView VirtualAcntByMember(ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "/" + "VirtualAcntByMember");
		return mav;
	}
	
	/**
	 * 기준정보관리 - 가상계좌현황 - 헤더조회내역
	 * @author 한정훈
	 * @param request
	 * @return Map<String, Object>
	 * @exception SQLException
	 * @exception Exception
	 */
	@ResponseBody
	@RequestMapping(value="getVirtualAcntHeaderList.do", method=RequestMethod.POST)
	public Map<String, Object> VirtualAcntHeaderList(@RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap1 >>>> " + paramMap);
		
		List<Map<String, Object>> getPurchaseStatusDetailSearch = virtualAcntService.getVirtualAcntHeaderList(paramMap);
		resultMap.put("gridDataList", getPurchaseStatusDetailSearch);
		
		return resultMap;
	}
	
	/**
	 * 기준정보관리 - 가상계좌현황 - 디테일조회내역
	 * @author 한정훈
	 * @param request
	 * @return Map<String, Object>
	 * @exception SQLException
	 * @exception Exception
	 */
	@RequestMapping(value="getVirtualAcntDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> VirtualAcntDetailList(HttpServletRequest request,@RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap1 >>>> " + paramMap);
		
		List<Map<String, Object>> getPurchaseStatusDetailSearch = virtualAcntService.getVirtualAcntDetailList(paramMap);
		resultMap.put("gridDataList", getPurchaseStatusDetailSearch);
		
		return resultMap;
	}
}
