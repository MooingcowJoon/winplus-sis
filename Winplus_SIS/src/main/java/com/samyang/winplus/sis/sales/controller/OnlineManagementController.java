package com.samyang.winplus.sis.sales.controller;

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
import com.samyang.winplus.sis.sales.service.OnlineManagementService;

@RequestMapping("/sis/sales/onlinesales")
@RestController
public class OnlineManagementController extends BaseController {
	
	@Autowired
	OnlineManagementService onlineManagementService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final static String DEFAULT_PATH = "sis/sales/onlinesales";
	
	/**
	 * 판매관리 - 판매관리(온라인) - 주문서등록(온라인)
	 * @author 한정훈
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="onlineOrderList.sis", method=RequestMethod.POST)
	public ModelAndView OnlineOrderList(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "onlineOrderList");
		return mav;
	}
	/**
	 * 판매관리 - 판매관리(온라인) - 판매내역(온라인)
	 * @author 한정훈
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="onlineSalesHistory.sis", method=RequestMethod.POST)
	public ModelAndView OnlineSalesHistory(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "onlineSalesHistory");
		return mav;
	}
	/**
	 * 판매관리 - 판매관리(온라인) - 판매확정(온라인)
	 * @author 한정훈
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="onlineSalesFix.sis", method=RequestMethod.POST)
	public ModelAndView OnlineSalesFix(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "onlineSalesFix");
		return mav;
	}
	/**
	  * 판매관리 - 판매관리(온라인) - 주문서등록(온라인) 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@ResponseBody
	@RequestMapping(value="getOnlineOrderList.do", method=RequestMethod.POST)
	public Map<String, Object> getOnlineOrderList(@RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap1 >>>> " + paramMap);
		
		List<Map<String, Object>> getOnlineOrderList = onlineManagementService.getOnlineOrderList(paramMap);
		resultMap.put("gridDataList", getOnlineOrderList);
		
		return resultMap;
	}
	
	/**
	  * 판매관리 - 판매관리(온라인) - 주문서등록(온라인) 저장(CUD)
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@ResponseBody
	@RequestMapping(value="saveOnlineOrderList.do", method=RequestMethod.POST)
	public Map<String, Object> saveOnlineOrderList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> typeAndcnt = onlineManagementService.saveOnlineOrderList((List<Map<String, Object>>) paramMap.get("listMap"));
		resultMap.put("typeAndcnt", typeAndcnt);
		
		return resultMap;
	}
	
	/**
	  * 판매관리 - 판매관리(온라인) - 주문서등록(온라인) 엑셀 업로드 B2C
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@ResponseBody
	@RequestMapping(value="getOnlineSalesB2CInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getOnlineSalesB2CInfo(@RequestBody Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("getOnlineSalesB2CInfo paramMap >>>> " + paramMap);
		List<Map<String, Object>> getOnlineSalesB2CInfo = onlineManagementService.getOnlineSalesB2CInfo(paramMap);
		resultMap.put("gridDataList", getOnlineSalesB2CInfo);
		
		return resultMap;
	}
	
	/**
	  * 판매관리 - 판매관리(온라인) - 주문서등록(온라인) 엑셀 업로드 B2B
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@ResponseBody
	@RequestMapping(value="getOnlineSalesB2BInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getOnlineSalesB2BInfo(@RequestBody Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("getOnlineSalesB2BInfo paramMap >>>> " + paramMap);
		List<Map<String, Object>> getOnlineSalesB2BInfo = onlineManagementService.getOnlineSalesB2BInfo(paramMap);
		resultMap.put("gridDataList", getOnlineSalesB2BInfo);
		
		return resultMap;
	}

	/**
	  * 판매관리 - 판매관리(온라인) - 판매내역(온라인) 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@ResponseBody
	@RequestMapping(value="getOSHistoryList.do", method=RequestMethod.POST)
	public Map<String, Object> getOSHistoryList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap >>>> " + paramMap);
		
		List<Map<String, Object>> getOnlineSalesInfo = onlineManagementService.getOSHistoryList(paramMap);
		resultMap.put("gridDataList", getOnlineSalesInfo);
		
		return resultMap;
	}
	/**
	  * 판매관리 - 판매관리(온라인) - 판매내역(온라인) 엑셀업로드
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@ResponseBody
	@RequestMapping(value="getPurFixInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getPurFixInfo(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap1 >>>> " + paramMap);
		
		List<Map<String, Object>> getPurFixInfo = onlineManagementService.getPurFixInfo(paramMap);
		resultMap.put("gridDataList", getPurFixInfo);
		
		return resultMap;
	}
	
	/**
	  * 판매관리 - 판매관리(온라인) - 판매내역(온라인) 저장(U)
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="saveOnlineHistoryList.do", method=RequestMethod.POST)
	public Map<String, Object> saveOnlineHistoryList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		paramMap.put("CRUD", "U");
		//logger.debug("saveOnlineHistoryList paramMap >>>> " + paramMap);
		List<Map<String, Object>> saveOnlineHistoryList = onlineManagementService.saveOnlineHistoryList(paramMap);
		resultMap.put("Map", saveOnlineHistoryList);
		
		return resultMap;
	}
	
	/**
	  * 판매관리 - 판매관리(온라인) - 판매확정(온라인) 헤더 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getOnlineFixList.do", method=RequestMethod.POST)
	public Map<String, Object> getOnlineFixList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("getOnlineFixList paramMap >>>> " + paramMap);
		List<Map<String, Object>> getOnlineFixList = onlineManagementService.getOnlineFixList(paramMap);
		resultMap.put("gridDataList", getOnlineFixList);
		
		return resultMap;
	}
	
	/**
	  * 판매관리 - 판매관리(온라인) - 판매확정(온라인) 디테일 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getOnlineFixDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getOnlineFixDetailList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("getOnlineFixDetailList paramMap >>>> " + paramMap);
		List<Map<String, Object>> getOnlineFixDetailList = onlineManagementService.getOnlineFixDetailList(paramMap);
		resultMap.put("gridDataList", getOnlineFixDetailList);
		
		return resultMap;
	}
	
	/**
	  * 판매관리 - 판매관리(온라인) - 판매확정(온라인) 헤더 저장(U)
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="saveOnlineFixList.do", method=RequestMethod.POST)
	public Map<String, Object> saveOnlineFixList(HttpServletRequest request, @RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("saveOnlineFixList paramMap >>>> " + paramMap);
		List<Map<String, Object>> saveOnlineFixList = onlineManagementService.saveOnlineFixList(paramMap);
		resultMap.put("data", saveOnlineFixList);
		return resultMap;
	}
	/**
	  * 판매관리 - 판매관리(온라인) - 판매확정(온라인) 디테일 저장(U)
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="saveOSFDList.do", method=RequestMethod.POST)
	public Map<String, Object> saveOSFDList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);

		int resultRowCnt = onlineManagementService.saveOSFDList(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
	/**
	  * 판매관리 - 판매관리(온라인) - 주문서 등록(온라인) - WMS전송
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="TransmissionToWMS.do", method=RequestMethod.POST)
	public Map<String, Object> TransmissionToWMS(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("saveOnlineFixList paramMap >>>> " + paramMap);
		List<Map<String, Object>> TransmissionToWMS = onlineManagementService.TransmissionToWMS(paramMap);
		resultMap.put("gridDataList", TransmissionToWMS);
		return resultMap;
	}
}
