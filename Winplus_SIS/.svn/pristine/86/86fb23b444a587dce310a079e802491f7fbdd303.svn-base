package com.samyang.winplus.sis.basic.controller;

import java.sql.SQLException;
import java.util.HashMap;
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
import com.samyang.winplus.sis.basic.service.CardCorpService;

/**
 * @Class : CardCorpController.java
 * @Description : 신용카드사 관리 컨트롤러
 * @Modification Information  
 * 
 *   수정일          수정자                내용
 * -----------     ----------      ----------------------
 * 2019. 8. 15.      조승현              최초생성
 * 
 * @author 조승현
 * @since 2019. 8. 15.
 * @version 1.0
 */
@RestController
@RequestMapping("/sis/basic")
public class CardCorpController extends BaseController {

	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final String DEFAULT_PATH = getDefaultPath(getClass());

	@Autowired
	private CardCorpService cardCorpService;
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @param mav
	 * @return mav
	 * @throws SQLException
	 * @throws Exception
	 * @description 신용카드사 관리 페이지 호출
	 */
	@RequestMapping(value="cardCorpManagement.sis", method=RequestMethod.POST)
	public ModelAndView cardCorpManagement(HttpServletRequest request, @RequestParam Map<String, String> paramMap, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "cardCorpManagement");
		return mav;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return resultMap
	 * @throws SQLException
	 * @throws Exception
	 * @description 신용카드사 정보 조회
	 */
	@ResponseBody
	@RequestMapping(value="getCardCorpInfoList.do", method=RequestMethod.POST)
	public Map<String,Object> getCardCorpInfoList(HttpServletRequest request, @RequestBody Map<String, String> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", cardCorpService.getCardCorpInfoList(paramMap));
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return resultMap
	 * @throws SQLException
	 * @throws Exception
	 * @description 신용카드사 정보 등록,수정,삭제
	 */
	@ResponseBody
	@RequestMapping(value="crudCardCorpInfoList.do", method=RequestMethod.POST)
	public Map<String,Object> crudCardCorpInfoList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("result", cardCorpService.crudCardCorpInfoList(paramMap));
		return resultMap;
	}
	
}
