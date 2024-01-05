package com.samyang.winplus.sis.stock.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;


import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.sis.stock.service.StockManagementService;

@RequestMapping("/sis/stock/stockManagement")
@RestController
public class StockManagementController extends BaseController {

private final static String DEFAULT_PATH = "sis/stock/stockManagement";
	
	@Autowired
	StockManagementService stockManagementService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	/**
	  * 재고관리(직영점) - 재고실사 관리
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="stockInspManagement.sis", method=RequestMethod.POST)
	public ModelAndView stockInspManagement(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "stockInspManagement");
		return mav;
	}
	
	/**
	  * 재고관리(직영점) - 재고실사 관리 상단 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getstockInspList.do", method=RequestMethod.POST)
	public Map<String, Object> getstockInspList(HttpServletRequest request) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String SEARCH_FROM_DATE = request.getParameter("SEARCH_FROM_DATE");
		String ORGN_CD = request.getParameter("ORGN_CD");
		
		paramMap.put("SEARCH_FROM_DATE", SEARCH_FROM_DATE);
		paramMap.put("ORGN_CD", ORGN_CD);
		
		try {
			List<Map<String, Object>> gridDataList = stockManagementService.getstockInspList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * 재고관리(직영점) - 재고실사 관리 - 재고실사 데이터 생성
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value = "saveStockInspList.do", method = RequestMethod.POST)
	public Map<String, Object> saveStockInspList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap ) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();	
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String CUSER = empSessionDto.getEmp_no();
		
		paramMap.put("CUSER", CUSER);
		
		int resultRowCnt = 0;
		
		resultRowCnt += stockManagementService.saveStockInspList(paramMap);
		resultMap.put("resultRowCnt", resultRowCnt);
		      
		return resultMap;
	}
	
	/**
	  * 재고관리(직영점) - 재고실사 관리 하단 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getstockInspSubList.do", method=RequestMethod.POST)
	public Map<String, Object> getstockInspSubList(HttpServletRequest request) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String ORGN_DIV_CD = request.getParameter("ORGN_DIV_CD");
		String ORGN_CD = request.getParameter("ORGN_CD");
		String SEARCH_FROM_DATE = request.getParameter("SEARCH_FROM_DATE");
		
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("SEARCH_FROM_DATE", SEARCH_FROM_DATE);
		
		try {
			List<Map<String, Object>> gridDataList = stockManagementService.getstockInspSubList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}

	/**
	  * 재고관리(직영점) - 재고실사 관리 - 부분실사 적용
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */	
	@RequestMapping(value="savePartStockInspList.do", method=RequestMethod.POST)
	public Map<String, Object> savePartStockInspList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap ) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String CUSER = empSessionDto.getEmp_no();
		
		paramMap.put("CUSER", CUSER);
		
		int resultRowCnt = 0;
		
		resultRowCnt += stockManagementService.savePartStockInspList(paramMap);
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}	
		
	/**
	  * 재고관리(직영점) - 재고실사 관리 - 전체실사 적용
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="saveFullStockInspList.do", method=RequestMethod.POST)
	public Map<String, Object> saveFullStockInspList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap ) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String CUSER = empSessionDto.getEmp_no();
		
		paramMap.put("CUSER", CUSER);
		
		int resultRowCnt = 0;
		
		resultRowCnt += stockManagementService.saveFullStockInspList(paramMap);
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}
	
	/**
	  * 재고관리(직영점) - 재고실사 관리 하단 저장
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Transactional
	@RequestMapping(value="saveStockInspSubList.do", method=RequestMethod.POST)
	public Map<String, Object> saveStockInspSubList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String CUSER = empSessionDto.getEmp_no();
		String CPROGRM = "saveStockInspSubList";
		
		int deleteResult = 0;
		int updateResult = 0;
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			paramMap = dhtmlxParamMapList.get(i);
			
			paramMap.put("CPROGRM", CPROGRM);
			paramMap.put("CUSER", CUSER);
			
			if(paramMap.get("CRUD").equals("D")) {
				deleteResult += stockManagementService.deleteStockInspSubList(paramMap);
			} else {
				updateResult += stockManagementService.saveAddStockInspSubList(paramMap);
			}
		}
		
		if((deleteResult+updateResult) == dhtmlxParamMapList.size()) {
			resultMap.put("resultRowCnt", (deleteResult+updateResult));
		}else {
			String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1999";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return resultMap;
	}
	
	/**
	  * 재고관리(직영점) - 분류별 현재고
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="nowStockByCategory.sis", method=RequestMethod.POST)
	public ModelAndView nowStockByCategory(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "nowStockByCategory");
		return mav;
	}
	
	/**
	  * 재고관리(직영점) - 분류별 현재고 - 데이터 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="nowStockByCategoryList.do", method=RequestMethod.POST)
	public Map<String, Object> nowStockByCategoryList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException,Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> categoryMap = new HashMap<String,Object>();
		
		String GRUP_TOP_CD = "";
		String GRUP_MID_CD = "";
		String GRUP_BOT_CD = "";
		
		categoryMap = stockManagementService.nowStockByCategoryTMB(paramMap);
		if(categoryMap != null) {
			GRUP_TOP_CD = categoryMap.get("GRUP_TOP_CD").toString();
			GRUP_MID_CD = categoryMap.get("GRUP_MID_CD").toString();
			GRUP_BOT_CD = categoryMap.get("GRUP_BOT_CD").toString();
		}
		else {
			GRUP_TOP_CD = "ALL";
			GRUP_MID_CD = "0";
			GRUP_BOT_CD = "0";
		}
		
		paramMap.put("GRUP_TOP_CD", GRUP_TOP_CD);
		paramMap.put("GRUP_MID_CD", GRUP_MID_CD);
		paramMap.put("GRUP_BOT_CD", GRUP_BOT_CD);
		
		List<Map<String, Object>> nowStockByCategoryList = stockManagementService.nowStockByCategoryList(paramMap);
		resultMap.put("gridDataList", nowStockByCategoryList);
		
		return resultMap;
	}
	
	/**
	  * 재고관리(직영점) - 단품별 현재고
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="nowStockBySingle.sis", method=RequestMethod.POST)
	public ModelAndView nowStockBySingle(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "nowStockBySingle");
		return mav;
	}
	
	/**
	  * 재고관리(직영점) - 단품별 현재고 - 데이터 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="nowStockBySingleList.do", method=RequestMethod.POST)
	public Map<String, Object> nowStockBySingleList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> categoryMap = new HashMap<String, Object>();
		
		String GRUP_TOP_CD = "";
		String GRUP_MID_CD = "";
		String GRUP_BOT_CD = "";
		
		categoryMap = stockManagementService.nowStockBySingleTMB(paramMap);
		if(categoryMap != null) {
			GRUP_TOP_CD = categoryMap.get("GRUP_TOP_CD").toString();
			GRUP_MID_CD = categoryMap.get("GRUP_MID_CD").toString();
			GRUP_BOT_CD = categoryMap.get("GRUP_BOT_CD").toString();
		}
		else {
			GRUP_TOP_CD = "ALL";
			GRUP_MID_CD = "0";
			GRUP_BOT_CD = "0";
		}
		paramMap.put("GRUP_TOP_CD", GRUP_TOP_CD);
		paramMap.put("GRUP_MID_CD", GRUP_MID_CD);
		paramMap.put("GRUP_BOT_CD", GRUP_BOT_CD);
		
		List<Map<String, Object>> nowStockBySingleList = stockManagementService.nowStockBySingleList(paramMap);
		resultMap.put("gridDataList", nowStockBySingleList);
		
		return resultMap;
	}
	
	
	/**
	  * 재고관리(직영점) - 재고실사 레포트
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="realStockReport.sis", method=RequestMethod.POST)
	public ModelAndView realStockReport(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "realStockReport");
		return mav;
	}
	
	/**
	  * 재고관리(직영점) - 재고변경 이력조회
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="stockChangeHistory.sis", method=RequestMethod.POST)
	public ModelAndView stockChangeHistory(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "stockChangeHistory");
		return mav;
	}
	
	/**
	  * 재고관리(직영점) - 재고변경 이력조회 - 데이터 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="stockChangeHistoryList.do" , method= RequestMethod.POST)
	public Map<String, Object> stockChangeHistoryList(HttpServletRequest request) throws SQLException,Exception{
		Map<String, Object> resultMap= new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Map<String, Object> categoryMap = new HashMap<String, Object>();
		
		String GRUP_CD = request.getParameter("GRUP_CD");
		String SURP_CD = request.getParameter("SURP_CD");
		String SEARCH_DATE_FROM = request.getParameter("SEARCH_DATE_FROM");
		String SEARCH_DATE_TO = request.getParameter("SEARCH_DATE_TO");
		String lossSTOCK = request.getParameter("lossSTOCK");
		String changeSTOCK = request.getParameter("changeSTOCK");
		String Set_Goods = request.getParameter("Set_Goods");
		String Goods_Name = request.getParameter("Goods_Name");
		String ORGN_CD = request.getParameter("ORGN_CD");
		String ORGN_DIV_CD = request.getParameter("ORGN_DIV_CD");
		
		paramMap.put("GRUP_CD", GRUP_CD);
		paramMap.put("SURP_CD", SURP_CD);
		paramMap.put("SEARCH_DATE_FROM", SEARCH_DATE_FROM);
		paramMap.put("SEARCH_DATE_TO", SEARCH_DATE_TO);
		paramMap.put("lossSTOCK", lossSTOCK);
		paramMap.put("changeSTOCK", changeSTOCK);
		paramMap.put("Set_Goods", Set_Goods);
		paramMap.put("Goods_Name", Goods_Name);
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		
		String GRUP_TOP_CD = "";
		String GRUP_MID_CD = "";
		String GRUP_BOT_CD = "";
		
		categoryMap = stockManagementService.stockChangeHistoryTMB(paramMap);
		if(categoryMap != null) {
			GRUP_TOP_CD = categoryMap.get("GRUP_TOP_CD").toString();
			GRUP_MID_CD = categoryMap.get("GRUP_MID_CD").toString();
			GRUP_BOT_CD = categoryMap.get("GRUP_BOT_CD").toString();
		}
		else {
			GRUP_TOP_CD = "ALL";
			GRUP_MID_CD = "0";
			GRUP_BOT_CD = "0";
		}
		paramMap.put("GRUP_TOP_CD", GRUP_TOP_CD);
		paramMap.put("GRUP_MID_CD", GRUP_MID_CD);
		paramMap.put("GRUP_BOT_CD", GRUP_BOT_CD);

		List<Map<String, Object>> stockChangeHistoryList = new ArrayList<Map<String, Object>>();
		
		try {
			stockChangeHistoryList = stockManagementService.stockChangeHistoryList(paramMap);
			resultMap.put("gridDataList", stockChangeHistoryList);
		} catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		} catch (Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;	
	}
	
	/**
	  * 재고관리(직영점) - 분류별 월말재고
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="monStockByCategory.sis", method=RequestMethod.POST)
	public ModelAndView monStockByCategory(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "monStockByCategory");
		return mav;
	}
	
	/**
	  * 재고관리(직영점) - 분류별 월말재고 - 데이터 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="monStockByCategoryList.do", method=RequestMethod.POST)
	public Map<String, Object> monStockByCategoryList(HttpServletRequest request) throws SQLException,Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String,Object>();
		Map<String, Object> categoryMap = new HashMap<String,Object>();
		
		String GRUP_CD = request.getParameter("GRUP_CD");
		String SEARCH_DATE_FROM = request.getParameter("SEARCH_DATE_FROM");
		String SURP_CD = request.getParameter("SURP_CD");
		String TAX_TYPE = request.getParameter("TAX_TYPE");
		String Invalid_Goods = request.getParameter("Invalid_Goods");
		String Select_Goods = request.getParameter("Select_Goods");
		String searchCheck = request.getParameter("searchCheck");
		
		paramMap.put("GRUP_CD", GRUP_CD);
		paramMap.put("SEARCH_DATE_FROM", SEARCH_DATE_FROM);
		paramMap.put("SURP_CD", SURP_CD);
		paramMap.put("TAX_TYPE", TAX_TYPE);
		paramMap.put("Invalid_Goods", Invalid_Goods);
		paramMap.put("Select_Goods", Select_Goods);
		paramMap.put("searchCheck", searchCheck);
		
		String GRUP_TOP_CD = "";
		String GRUP_MID_CD = "";
		String GRUP_BOT_CD = "";
		
		categoryMap = stockManagementService.monStockByCategoryTMB(paramMap);
		if(categoryMap != null) {
			GRUP_TOP_CD = categoryMap.get("GRUP_TOP_CD").toString();
			GRUP_MID_CD = categoryMap.get("GRUP_MID_CD").toString();
			GRUP_BOT_CD = categoryMap.get("GRUP_BOT_CD").toString();
		}
		else {
			GRUP_TOP_CD = "ALL";
			GRUP_MID_CD = "0";
			GRUP_BOT_CD = "0";
		}
		paramMap.put("GRUP_TOP_CD", GRUP_TOP_CD);
		paramMap.put("GRUP_MID_CD", GRUP_MID_CD);
		paramMap.put("GRUP_BOT_CD", GRUP_BOT_CD);

		List<Map<String, Object>> monStockByCategoryList = new ArrayList<Map<String, Object>>();
		
		try {
			monStockByCategoryList = stockManagementService.monStockByCategoryList(paramMap);
			resultMap.put("gridDataList", monStockByCategoryList);
		} catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		} catch (Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;	
	}
	
	/**
	  * 재고관리(직영점) - 단품별 월말재고
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="monStockBySingle.sis", method=RequestMethod.POST)
	public ModelAndView monStockBySingle(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "monStockBySingle");
		return mav;
	}
	
	/**
	  * 재고관리(직영점) - 단품별 월말재고 - 데이터 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="monStockBySingleList.do", method=RequestMethod.POST)
	public Map<String, Object> monStockBySingleList(HttpServletRequest request) throws SQLException,Exception{
		 Map<String, Object> resultMap = new HashMap<String, Object>();
		 Map<String, Object> paramMap = new HashMap<String, Object> ();
		 Map<String, Object> categoryMap = new HashMap<String, Object> ();
		 
		 String GRUP_CD = request.getParameter("GRUP_CD");
		 String SURP_CD = request.getParameter("SURP_CD");
		 String SEARCH_DATE_FROM = request.getParameter("SEARCH_DATE_FROM");
		 String Invalid_Goods = request.getParameter("Invalid_Goods");
		 String Ending_Stock = request.getParameter("Ending_Stock");
		 String Set_Goods = request.getParameter("Set_Goods");
		 String key_word = request.getParameter("KEY_WORD");
		 
		 paramMap.put("GRUP_CD", GRUP_CD);
		 paramMap.put("SURP_CD", SURP_CD);
		 paramMap.put("SEARCH_DATE_FROM", SEARCH_DATE_FROM);
		 paramMap.put("Invalid_Goods",Invalid_Goods);
		 paramMap.put("Ending_Stock",Ending_Stock);
		 paramMap.put("Set_Goods",Set_Goods);
		 paramMap.put("KEY_WORD", key_word);
		 
		 String GRUP_TOP_CD = "";
		 String GRUP_MID_CD = "";
		 String GRUP_BOT_CD = "";
		 
		 categoryMap = stockManagementService.monStockBySingleTMB(paramMap);
		 if(categoryMap != null) {
			GRUP_TOP_CD = categoryMap.get("GRUP_TOP_CD").toString();
			GRUP_MID_CD = categoryMap.get("GRUP_MID_CD").toString();
			GRUP_BOT_CD = categoryMap.get("GRUP_BOT_CD").toString();
		 }
		 else {
			GRUP_TOP_CD = "ALL";
			GRUP_MID_CD = "0";
			GRUP_BOT_CD = "0";
		 }
		 paramMap.put("GRUP_TOP_CD", GRUP_TOP_CD);
		 paramMap.put("GRUP_MID_CD", GRUP_MID_CD);
		 paramMap.put("GRUP_BOT_CD", GRUP_BOT_CD);
	
		 List<Map<String, Object>> monStockBySingleList = new ArrayList<Map<String, Object>>();
			
		 try {
			monStockBySingleList = stockManagementService.monStockBySingleList(paramMap);
			resultMap.put("gridDataList", monStockBySingleList);
		 } catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		 } catch (Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		 }
		 return resultMap;	
	}
}
