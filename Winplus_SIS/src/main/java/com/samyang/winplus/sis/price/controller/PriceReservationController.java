package com.samyang.winplus.sis.price.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;
import com.samyang.winplus.sis.price.service.PriceReservationService;

@RequestMapping("/sis/price/")
@RestController
public class PriceReservationController {
	
	private final static String DEFAULT_PATH = "sis/price";
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	protected CommonUtil commonUtil;
	
	@Autowired
	PriceReservationService priceReservationService;
	
	/**
	 * 단가관리 - 가격변경예약(직영점)
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="priceModifyReservation.sis", method=RequestMethod.POST)
	public ModelAndView priceModifyReservation(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "priceModifyReservation");
		return mav;
	}
	
	/**
	 * 단가관리 - 가격변경예약(직영점) - 가격변경예약 헤더 조회
	 * @author 강신영
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getPriceReservationHeaderList.do", method=RequestMethod.POST)
	public Map<String, Object> getPriceReservationHeaderList(HttpServletRequest request,@RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> priceReservationHeaderList = priceReservationService.getPriceReservationHeaderList(paramMap);
		resultMap.put("gridDataList", priceReservationHeaderList);
		
		return resultMap;
	}
	
	/**
	 * 단가관리 - 가격변경예약(직영점) - 가격변경예약 헤더 저장
	 * @author 강신영
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="updatePriceReservationHeaderList.do", method=RequestMethod.POST)
	public Map<String, Object> updatePriceReservationHeaderList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		Map<String, Object> paramMap = null;
		Map<String, Object> resultDataMap = null;
		int updateCnt = 0;
		
		for(int i=0; i<dhtmlxParamMapList.size(); i++) {
			paramMap = new HashMap<String, Object>();
			paramMap.put("CRUD",dhtmlxParamMapList.get(i).get("CRUD"));
			paramMap.put("CHG_SEQ",dhtmlxParamMapList.get(i).get("CHG_SEQ"));
			paramMap.put("ORGN_CD",dhtmlxParamMapList.get(i).get("ORGN_CD"));
			paramMap.put("CHG_TITLE",dhtmlxParamMapList.get(i).get("CHG_TITLE"));
			paramMap.put("STRT_DATE",dhtmlxParamMapList.get(i).get("STRT_DATE"));
			paramMap.put("STRT_TIME_HH",dhtmlxParamMapList.get(i).get("STRT_TIME_HH"));
			paramMap.put("STRT_TIME_MM",dhtmlxParamMapList.get(i).get("STRT_TIME_MM"));
			paramMap.put("CHG_REMK",dhtmlxParamMapList.get(i).get("CHG_REMK"));
			paramMap.put("PROGRM", "updatePriceReservationHeader");
			paramMap.put("EMP_NO", emp_no);
			
			resultDataMap = priceReservationService.updatePriceReservationHeader(paramMap);
			if(resultDataMap.get("RESULT_MSG").equals("SAVE_SUCCESS")) {
				++updateCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("INS_SUCCESS")) {
				++updateCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("DEL_SUCCESS")) {
				++updateCnt;
			} else {
			}
		}
		
		if(dhtmlxParamMapList.size() == updateCnt) {
			resultMap.put("resultRowCnt", updateCnt);
		} else {
			String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1999";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		}
		
		return resultMap;
	}
	
	/**
	 * 단가관리 - 가격변경예약(직영점) - 가격변경예약 디테일 조회
	 * @author 강신영
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getPriceReservationDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getPriceReservationDetailList(HttpServletRequest request,@RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> priceReservationDetailList = priceReservationService.getPriceReservationDetailList(paramMap);
		resultMap.put("gridDataList", priceReservationDetailList);
		
		return resultMap;
	}
	
	/**
	 * 단가관리 - 가격변경예약(직영점) - 가격변경예약 디테일 저장
	 * @author 강신영
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="updatePriceReservationDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> updatePriceReservationDetailList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		String h_orgn_div_cd = request.getParameter("H_ORGN_DIV_CD");
		String h_orgn_cd = request.getParameter("H_ORGN_CD");
		String h_chg_seq = request.getParameter("H_CHG_SEQ");
		
		Map<String, Object> paramMap = null;
		Map<String, Object> resultDataMap = null;
		int updateCnt = 0;
		
		for(int i=0; i<dhtmlxParamMapList.size(); i++) {
			paramMap = new HashMap<String, Object>();
			paramMap.put("CRUD",dhtmlxParamMapList.get(i).get("CRUD"));
			paramMap.put("ORGN_DIV_CD",h_orgn_div_cd);
			paramMap.put("ORGN_CD",h_orgn_cd);
			paramMap.put("CHG_SEQ",h_chg_seq);
			paramMap.put("DETL_SEQ",dhtmlxParamMapList.get(i).get("DETL_SEQ"));
			paramMap.put("BCD_CD",dhtmlxParamMapList.get(i).get("BCD_CD"));
			paramMap.put("GOODS_NO",dhtmlxParamMapList.get(i).get("GOODS_NO"));
			paramMap.put("BCD_NM",dhtmlxParamMapList.get(i).get("BCD_NM"));
			paramMap.put("DIMEN_NM",dhtmlxParamMapList.get(i).get("DIMEN_NM"));
			paramMap.put("CUSTMR_CD",dhtmlxParamMapList.get(i).get("CUSTMR_CD"));
			paramMap.put("PUR_PRICE",dhtmlxParamMapList.get(i).get("A_PUR_PRICE"));
			paramMap.put("SALE_PRICE",dhtmlxParamMapList.get(i).get("A_SALE_PRICE"));
			paramMap.put("PROGRM", "updatePriceReservationDetail");
			paramMap.put("EMP_NO", emp_no);
			
			resultDataMap = priceReservationService.updatePriceReservationDetailList(paramMap);
			if(resultDataMap.get("RESULT_MSG").equals("SAVE_SUCCESS")) {
				++updateCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("INS_SUCCESS")) {
				++updateCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("DEL_SUCCESS")) {
				++updateCnt;
			} else {
			}
		}
		
		if(dhtmlxParamMapList.size() == updateCnt) {
			resultMap.put("resultRowCnt", updateCnt);
		} else {
			String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1999";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		}
		
		return resultMap;
	}
	
	/**
	  * getPriceInformation - 가격변경예약(직영점) - 가격정보 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getPriceInformation.do", method=RequestMethod.POST)
	public Map<String, Object> getPriceInformation(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try{
			resultMap = priceReservationService.getPriceInformation(paramMap);
			if(resultMap == null){
				resultMap = new HashMap<String, Object>();
				resultMap.put("PUR_PRICE", "0");
				resultMap.put("SALE_PRICE", "0");
			}
		} catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	
	/**
	 * 단가관리 - 가격변경예정조회
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="priceModifySchedule.sis", method=RequestMethod.POST)
	public ModelAndView priceModifySchedule(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "priceModifySchedule");
		return mav;
	}
	
	/**
	 * 단가관리 - 가격변경예정조회 - 조회
	 * @author 강신영
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getPriceScheduleList.do", method=RequestMethod.POST)
	public Map<String, Object> getPriceScheduleList(HttpServletRequest request,@RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> priceScheduleList = priceReservationService.getPriceScheduleList(paramMap);
		resultMap.put("gridDataList", priceScheduleList);
		
		return resultMap;
	}
}
