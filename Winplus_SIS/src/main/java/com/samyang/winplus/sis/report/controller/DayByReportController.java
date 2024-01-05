package com.samyang.winplus.sis.report.controller;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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

import com.samyang.winplus.common.board.service.BoardService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.sis.report.service.DayByReportService;

@RequestMapping("/sis/report/dayByReport")
@RestController
public class DayByReportController extends BaseController {
	
	private final static String DEFAULT_PATH = "sis/report/dayByReportManagement";

	private static final String String = null;
	
	@Autowired
	BoardService boardService;
	
	@Autowired
	DayByReportService dayByReportService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	/**
	 * 레포트관리 - 일 - 레포트 
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="dayByReport.sis", method=RequestMethod.POST)
	public ModelAndView dayByReport(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayByReport");
		return mav;
	}
	
	/**
	  * 레포트관리 - 일별종합
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="dayByTotal.sis", method=RequestMethod.POST)
	public ModelAndView dayByTotal(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayByTotal");
		return mav;
	}
	
	
	/**
	  * 레포트관리 - 일_분류별(점포)
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="dayByCategory.sis", method=RequestMethod.POST)
	public ModelAndView dayByCategory(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayByCategory");
		return mav;
	}
	
	/**
	  * 레포트관리 - 일_분류별일자별(점포)
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="dayByCategoryDate.sis", method=RequestMethod.POST)
	public ModelAndView dayByCategoryDate(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayByCategoryDate");
		return mav;
	}
	
	/**
	  * 레포트관리 - 일_분류별비교(점포)
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="dayByCompareCategory.sis", method=RequestMethod.POST)
	public ModelAndView dayByCompareCategory(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayByCompareCategory");
		return mav;
	}
	
	/**
	 * 레포트관리 - 일_단품별
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="dayByGoods.sis", method=RequestMethod.POST)
	public ModelAndView dayByGoods(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayByGoods");
		return mav;
	}
	
	/**
	  * 레포트관리 - 일_일수불
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="dayBySubool.sis", method=RequestMethod.POST)
	public ModelAndView dayBySubool(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayBySubool");
		return mav;
	}
	
	/**
	  * 레포트관리 - 일_수수료공급사별(점포)
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="dayByCustmrFee.sis", method=RequestMethod.POST)
	public ModelAndView dayByCustmrFee(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayByCustmrFee");
		return mav;
	}
	
	/**
	 * 레포트관리 - 일_수수료공급사별(점포) - 공급사 조회
	 * @author 정혜원
	 * @param request
	 * @return Map<String, Object>
	 */
	
	@RequestMapping(value="dayByCustmrFeeList.do", method=RequestMethod.POST)
	public Map<String, Object> dayByCustmrFeeList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String ORGN_DIV_CD = request.getParameter("ORGN_DIV_CD");
		String ORGN_CD = request.getParameter("ORGN_CD");
		//logger.debug("ORGN_DIV_CD >> " + ORGN_DIV_CD);
		//logger.debug("ORGN_CD >> " + ORGN_CD);
		
		String FROM_DATE = request.getParameter("FROM_DATE");
		String TO_DATE = request.getParameter("TO_DATE");
		String PUR_CD_NM = request.getParameter("PUR_CD_NM"); // 2 수수료상품 , 3 임대상품 , 5 수수료+임대
		
		// 0:직영상품, 1:수수료상품, 2:임대상품(GOODS_TYPE)
		
		paramMap.put("FROM_DATE", FROM_DATE);
		paramMap.put("TO_DATE", TO_DATE);
		paramMap.put("PUR_CD_NM", PUR_CD_NM);
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		
		try {
			List<Map<String, Object>> ddCustmrFeeList = new ArrayList<Map<String, Object>>();
			ddCustmrFeeList = dayByReportService.getDayByCustmrFeeList(paramMap);
			resultMap.put("gridDataList", ddCustmrFeeList);
		} catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	
	/**
	 * 레포트관리 - 일_수수료공급사별(점포) - 공급사별 상세조회(단품별, 기간별)
	 * @author 정혜원
	 * @param request
	 * @return Map<String, Object>
	 */
	
	@RequestMapping(value="getDayByCustmrFeeSubList.do", method=RequestMethod.POST)
	public Map<String, Object> getDayByCustmrFeeSubList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String ORGN_DIV_CD = request.getParameter("ORGN_DIV_CD");
		String ORGN_CD = request.getParameter("ORGN_CD");
		String FROM_DATE = request.getParameter("FROM_DATE");
		String TO_DATE = request.getParameter("TO_DATE");
		String PUR_CD_NM = request.getParameter("PUR_CD_NM");
		String SURP_CD = request.getParameter("SURP_CD");
		
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("FROM_DATE", FROM_DATE);
		paramMap.put("TO_DATE", TO_DATE);
		paramMap.put("PUR_CD_NM", PUR_CD_NM);
		paramMap.put("SURP_CD", SURP_CD);
		
		List<Map<String, Object>> ddCustmrFeeSubList = new ArrayList<Map<String, Object>>();
		
		try {
			ddCustmrFeeSubList = dayByReportService.getDayByCustmrFeeSubList(paramMap);
			resultMap.put("gridDataList", ddCustmrFeeSubList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	
	/**
	  * 레포트관리 - 일_분류별과면세(점포)
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="dayByGoodsGroupVat.sis", method=RequestMethod.POST)
	public ModelAndView dayByGoodsGroupVat(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayByGoodsGroupVat");
		return mav;
	}
	
	/**
	 * 레포트관리 - 일_분류별과면세(점포) - 과면세 조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="dayByGoodsGroupVatList.do", method=RequestMethod.POST)
	public Map<String, Object> dayByGoodsGroupVatList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String,Object>();
		Map<String, Object> categoryMap = new HashMap<String,Object>();
		
		String ORGN_DIV_CD = request.getParameter("ORGN_DIV_CD");
		String ORGN_CD = request.getParameter("ORGN_CD");
		String GRUP_CD = request.getParameter("GRUP_CD");
		String SEARCH_FROM_DATE = request.getParameter("SEARCH_FROM_DATE");
		String SEARCH_TO_DATE = request.getParameter("SEARCH_TO_DATE");
		String PUR_CD_NM = request.getParameter("PUR_CD_NM");
		String searchCheck = request.getParameter("searchCheck");
		
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("GRUP_CD", GRUP_CD);
		paramMap.put("SEARCH_FROM_DATE", SEARCH_FROM_DATE);
		paramMap.put("SEARCH_TO_DATE", SEARCH_TO_DATE);
		paramMap.put("PUR_CD_NM", PUR_CD_NM);
		paramMap.put("searchCheck", searchCheck);
		
		String GRUP_TOP_CD = "";
		String GRUP_MID_CD = "";
		String GRUP_BOT_CD = "";
		
		String SECH_TYPE = "T";
		categoryMap = dayByReportService.dayByGoodsGroupVatListTMB(paramMap);
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
			
			if(!GRUP_TOP_CD.equals("GRUP_TOP_CD") && GRUP_MID_CD.equals("0") && GRUP_BOT_CD.equals("0")) {
				SECH_TYPE = "T";
			}
			else if(!GRUP_TOP_CD.equals("GRUP_TOP_CD") && GRUP_MID_CD.equals("GRUP_MID_CD") && GRUP_BOT_CD.equals("0")) {
				SECH_TYPE = "M";
			}
			else if(!GRUP_TOP_CD.equals("GRUP_TOP_CD") && GRUP_MID_CD.equals("GRUP_MID_CD") && GRUP_BOT_CD.equals("GRUP_BOT_CD")) {
				SECH_TYPE = "B";
			}
			else if(!GRUP_MID_CD.equals("0") && GRUP_BOT_CD.equals("0")) {
				GRUP_CD = "ALL";
			}
			
			paramMap.put("SECH_TYPE", SECH_TYPE);
			paramMap.put("GRUP_TOP_CD", GRUP_TOP_CD);
			paramMap.put("GRUP_MID_CD", GRUP_MID_CD);
			paramMap.put("GRUP_BOT_CD", GRUP_BOT_CD);
		
		List<Map<String, Object>> dayByGoodsGroupVatList = new ArrayList<Map<String, Object>>();
		
		try {
			dayByGoodsGroupVatList = dayByReportService.dayByGoodsGroupVatList(paramMap);
			resultMap.put("gridDataList", dayByGoodsGroupVatList);
			} catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	
	/**
	  * 레포트관리 - 일_일자별과면세(점포)
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="dayByDateVat.sis", method=RequestMethod.POST)
	public ModelAndView dayByDateVat(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayByDateVat");
		return mav;
	}
	
	/**
	 * 레포트관리 - 일_일자별과면세(점포)
	 * @author 최지민
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="dayByDateVatList.do", method=RequestMethod.POST)
	public Map<String, Object> dayByDateVatList(HttpServletRequest request) throws SQLException,Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String,Object>();
		Map<String, Object> categoryMap = new HashMap<String,Object>();
		
		String ORGN_DIV_CD = request.getParameter("ORGN_DIV_CD");
		String ORGN_CD = request.getParameter("ORGN_CD");
		String GRUP_CD = request.getParameter("GRUP_CD");
		String SEARCH_FROM_DATE = request.getParameter("SEARCH_FROM_DATE");
		String SEARCH_TO_DATE = request.getParameter("SEARCH_TO_DATE");
		String PUR_CD_NM = request.getParameter("PUR_CD_NM");
		
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("GRUP_CD", GRUP_CD);
		paramMap.put("SEARCH_FROM_DATE", SEARCH_FROM_DATE);
		paramMap.put("SEARCH_TO_DATE", SEARCH_TO_DATE);
		paramMap.put("PUR_CD_NM", PUR_CD_NM);
		
		String GRUP_TOP_CD = "";
		String GRUP_MID_CD = "";
		String GRUP_BOT_CD = "";
		
		categoryMap = dayByReportService.dayByDateVatListTMB(paramMap);
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
	
		List<Map<String, Object>> dayByDateVatList = new ArrayList<Map<String, Object>>();
		
		try {
			dayByDateVatList = dayByReportService.dayByDateVatList(paramMap);
			resultMap.put("gridDataList", dayByDateVatList);
		} catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		} catch (Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;	
	}
	
	/**
	  * 레포트관리 - 일_공급사별(점포)
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="dayByCustmr.sis", method=RequestMethod.POST)
	public ModelAndView dayByCustmr(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayByCustmr");
		return mav;
	}
	
	/**
	  * 레포트관리 - 일_공급사별일자별(점포)
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="dayByCustmrDate.sis", method=RequestMethod.POST)
	public ModelAndView dayByCustmrDate(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayByCustmrDate");
		return mav;
	}
	
	/**
	  * 레포트관리 - 일_판매공급사별(점포)
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="dayBySaleCustmr.sis", method=RequestMethod.POST)
	public ModelAndView dayBySaleCustmr(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "dayBySaleCustmr");
		return mav;
	}
	
	
	/**
	  * 레포트관리 - 일_일수불
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="getSuboolList.do", method=RequestMethod.POST)
	public Map<String, Object> getSuboolList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> SuboolList = new ArrayList<Map<String, Object>>();
		
		try{
			SuboolList = dayByReportService.getSuboolList(paramMap);
			resultMap.put("gridDataList", SuboolList);
		} catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * getDayByGoodsList - 일레포트 - 일_단품별 조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getDayByGoodsList.do", method = RequestMethod.POST)
	public Map<String, Object> getDayByGoodsList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap_info) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		try {
			gridDataList = dayByReportService.getDayByGoodsList(paramMap_info);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	
	/**
	  * getDayByCategoryList - 일레포트 - 일분류별 조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getDayByCategoryList.do", method = RequestMethod.POST)
	public Map<String, Object> getDayByCategoryList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		//logger.debug("getDayByCategoryList paramMap >>> " + paramMap);
		
		try {
			gridDataList = dayByReportService.getDayByCategoryList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	
	/**
	  * getDayByCategoryDateList - 일레포트 - 일분류별일자별 조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	 * @throws ParseException 
	  */
	@RequestMapping(value = "getDayByCategoryDateList.do", method = RequestMethod.POST)
	public Map<String, Object> getDayByCategoryDateList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws ParseException {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		StringBuilder PER_DATE = new StringBuilder();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date FromDate = sdf.parse(paramMap.get("searchDateFrom").toString());
        Date ToDate = sdf.parse(paramMap.get("searchDateTo").toString());
        ArrayList<String> dates = new ArrayList<String>();
        Date currentDate = FromDate;
        while (currentDate.compareTo(ToDate) <= 0) {
            dates.add(sdf.format(currentDate));
            Calendar c = Calendar.getInstance();
            c.setTime(currentDate);
            c.add(Calendar.DAY_OF_MONTH, 1);
            currentDate = c.getTime();
        }
        
        StringBuilder SUM_DATE = new StringBuilder();
        StringBuilder AVG_DATE = new StringBuilder();
        
        for (int i = 0 ; i < dates.size() ; i++) {
        	if(i == 0) {
        		PER_DATE.append("[");
        		PER_DATE.append(dates.get(i).replaceAll("-", ""));
        		PER_DATE.append("]");
        	} else {
        		PER_DATE.append(",[");
        		PER_DATE.append(dates.get(i).replaceAll("-", ""));
        		PER_DATE.append("]");
        	}
        	
        	SUM_DATE.append(",SUM([");
        	SUM_DATE.append(dates.get(i).replaceAll("-", ""));
        	SUM_DATE.append("])");
        	AVG_DATE.append(",AVG([");
        	AVG_DATE.append(dates.get(i).replaceAll("-", ""));
        	AVG_DATE.append("])");
        }
        
        paramMap.put("PER_DATE", PER_DATE.toString());
        paramMap.put("SUM_DATE", SUM_DATE.toString());
        paramMap.put("AVG_DATE", AVG_DATE.toString());
		try {
			gridDataList = dayByReportService.getDayByCategoryDateList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * getDayByCustmrList - 일레포트 - 협력사별조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getDayByCustmrList.do", method = RequestMethod.POST)
	public Map<String, Object> getDayByCustmrList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		try {
			gridDataList = dayByReportService.getDayByCustmrList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	
	/**
	  * getDayByCustmrDetailList - 일레포트 - 협력사별 디테일그리드 조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getDayByCustmrDetailList.do", method = RequestMethod.POST)
	public Map<String, Object> getDayByCustmrDetailList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		try {
			gridDataList = dayByReportService.getDayByCustrmrDetailList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		} catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * getDayByTotalList - 일_일별종합 조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getDayByTotalList.do", method = RequestMethod.POST)
	public Map<String, Object> getDayByTotalList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		try {
			gridDataList = dayByReportService.getDayByTotalList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		} catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
}
