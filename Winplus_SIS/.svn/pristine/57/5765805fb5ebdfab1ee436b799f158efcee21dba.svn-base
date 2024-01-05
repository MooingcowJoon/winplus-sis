package com.samyang.winplus.sis.market.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;
import com.samyang.winplus.sis.market.service.GoodsInspectionRegistService;

import net.sf.json.JSONObject;

@RequestMapping("/sis/market/purchase")
@RestController
public class GoodsInspectionRegistController extends BaseController {
	
	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	protected CommonUtil commonUtil;
	
	@Autowired
	GoodsInspectionRegistService goodsInspectionRegistService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/market/purchase";
	
	/**
	 * 구매관리 - 입고관리 - 입고등록(직영점)
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="goodsInspectionRegist.sis", method=RequestMethod.POST)
	public ModelAndView goodsCategoryManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "goodsInspectionRegist");
		return mav;
	}
	
	/**
	 * getGoodsInspectionRegistHeaderList - 입고검수등록 - 입고검수등록 헤더 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getGoodsInspectionRegistHeaderList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsInspectionRegistHeaderList(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> categoryMap = goodsInspectionRegistService.getGoodsInspectionRegistHeaderList(paramMap);
		resultMap.put("dataMap", categoryMap);
		
		return resultMap;
	}
	
	/**
	 * getGoodsInspectionRegistDetailList - 입고검수등록 - 입고검수등록 디테일 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getGoodsInspectionRegistDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsInspectionRegistDetailList(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> categoryMap = goodsInspectionRegistService.getGoodsInspectionRegistDetailList(paramMap);
		resultMap.put("dataMap", categoryMap);
		
		return resultMap;
	}
	
	/**
	 * updateGoodsInspectionRegistList - 입고검수등록 - 입고검수등록 저장
	 * @author 강신영
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Transactional
	@RequestMapping(value="updateGoodsInspectionRegistList.do", method=RequestMethod.POST)
	public Map<String, Object> updateGoodsInspectionRegistList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String pur_date = request.getParameter("INSP_DATE");
		String orgn_cd = request.getParameter("ORGN_CD");
		String supr_cd = request.getParameter("SUPR_CD");
		String pur_slip_cd = request.getParameter("PUR_SLIP_CD");
		String pur_type = request.getParameter("PUR_TYPE");
		String memo = request.getParameter("MEMO");
		
		if(pur_slip_cd == null || pur_slip_cd.equals("")) {
			StringBuilder sb = new StringBuilder();
			sb.append(pur_date);
			sb.append("_");
			sb.append(goodsInspectionRegistService.getPurMastSeq());
			pur_slip_cd = sb.toString();
		}
		
		Map<String, Object> paramMap = null;
		Map<String, Object> resultDataMap = null;
		int updateCnt = 0;
		
		if(dhtmlxParamMapList.size() == 0) {
			paramMap = new HashMap<String, Object>();
			paramMap.put("PUR_DATE",pur_date);
			paramMap.put("ORGN_CD",orgn_cd);
			paramMap.put("SUPR_CD",supr_cd);
			paramMap.put("PUR_SLIP_CD",pur_slip_cd);
			paramMap.put("PUR_TYPE",pur_type);
			paramMap.put("MEMO",memo);
		}else {
			for(int i=0; i<dhtmlxParamMapList.size(); i++) {
				paramMap = new HashMap<String, Object>();
				paramMap.put("CRUD",dhtmlxParamMapList.get(i).get("CRUD"));
				paramMap.put("PUR_DATE",pur_date);
				paramMap.put("ORGN_CD",orgn_cd);
				paramMap.put("SUPR_CD",supr_cd);
				paramMap.put("PUR_SLIP_CD",pur_slip_cd);
				paramMap.put("PUR_TYPE",pur_type);
				paramMap.put("MEMO",memo);
				
				paramMap.put("BCD_CD",dhtmlxParamMapList.get(i).get("BCD_CD"));
				paramMap.put("PUR_QTY",dhtmlxParamMapList.get(i).get("SALE_QTY"));
				paramMap.put("PUR_PRICE",dhtmlxParamMapList.get(i).get("SALE_PRICE"));
				paramMap.put("PAY_SUM_AMT",dhtmlxParamMapList.get(i).get("PAY_SUM_AMT"));
				if(dhtmlxParamMapList.get(i).get("TAX_YN") != null && !dhtmlxParamMapList.get(i).get("TAX_YN").equals("")) {
					paramMap.put("GOODS_TAX_YN",dhtmlxParamMapList.get(i).get("TAX_YN"));
				} else {
					paramMap.put("GOODS_TAX_YN","N");
				}
				paramMap.put("PUR_SLIP_SEQ",dhtmlxParamMapList.get(i).get("PUR_SLIP_SEQ"));
				paramMap.put("PROGRM", "updateGoodsInspectionRegistList");
				paramMap.put("EMP_NO", emp_no);
				
				resultDataMap = goodsInspectionRegistService.updateGoodsInspectionRegistList(paramMap);
				if(resultDataMap.get("RESULT_MSG").equals("SAVE_SUCCESS")) {
					++updateCnt;
				} else if(resultDataMap.get("RESULT_MSG").equals("INS_SUCCESS")) {
					++updateCnt;
				} else if(resultDataMap.get("RESULT_MSG").equals("DEL_SUCCESS")) {
					++updateCnt;
				}
			}
		}
		
		if(dhtmlxParamMapList.size() == updateCnt) {
			resultMap.put("resultRowCnt", updateCnt);
			goodsInspectionRegistService.updateGoodsInspectionRegistHeader(paramMap);
		} else {
			String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1999";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		}
		
		return resultMap;
	}
	
	/**
	 * deleteGoodsInspectionRegistList - 입고검수등록 - 입고검수등록 삭제
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="deleteGoodsInspectionRegistList.do", method=RequestMethod.POST)
	public Map<String, Object> deleteGoodsInspectionRegistList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			String resultMsg = goodsInspectionRegistService.deleteGoodsInspectionRegistList(paramMap);
			resultMap.put("resultMsg", resultMsg);
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
	 * getGoodsExpertRegistList - 입고검수등록 - 입고예정수량 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getGoodsExpertRegistList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsExpertRegistList(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> categoryMap = goodsInspectionRegistService.getGoodsExpertRegistList(paramMap);
		resultMap.put("dataMap", categoryMap);
		
		return resultMap;
	}
	
	/**
	 * openAddInspData - 입고검수등록 - 거래명세서 등록/조회 팝업
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openAddInspData.sis", method = RequestMethod.POST)
	public ModelAndView openAddInspData(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		
		String inspInfoString = request.getParameter("inspInfo");
		JSONObject jObj = JSONObject.fromObject(inspInfoString);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("INSP_DATE", jObj.get("INSP_DATE"));
		paramMap.put("ORGN_DIV_CD", jObj.get("ORGN_DIV_CD"));
		paramMap.put("ORGN_CD", jObj.get("ORGN_CD"));
		paramMap.put("PUR_SLIP_CD", jObj.get("PUR_SLIP_CD"));
		
		Map<String, Object> inspInfoMap = goodsInspectionRegistService.getInspInfo(paramMap);
		if(inspInfoMap == null) {
			mav.addObject("inspInfo", inspInfoString);
		}else {
			mav.addObject("inspInfo", JSONObject.fromObject(inspInfoMap).toString());
		}
		mav.setViewName(DEFAULT_PATH + "/" + "openAddInspData");
		return mav;
	}
	
	/**
	 * openInspPdaDataPopup - 입고검수등록 - PDA입고내역조회 팝업
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openInspPdaDataPopup.sis", method = RequestMethod.POST)
	public ModelAndView openInspPdaDataPopup(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("ORGN_CD", request.getParameter("ORGN_CD"));
		mav.setViewName(DEFAULT_PATH + "/" + "openInspPdaDataPopup");
		return mav;
	}
	
	/**
	 * getInspPdaDataHeaderList - 입고검수등록 - PDA입고내역 Header 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getInspPdaDataHeaderList.do", method=RequestMethod.POST)
	public Map<String, Object> getInspPdaDataHeaderList(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> inspPdaHeaderList = goodsInspectionRegistService.getInspPdaDataHeaderList(paramMap);
		resultMap.put("dataMap", inspPdaHeaderList);
		
		return resultMap;
	}
	
	/**
	 * getInspPdaDataDetailList - 입고검수등록 - PDA입고내역 Detail 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getInspPdaDataDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getInspPdaDataDetailList(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> inspPdaDetailList = goodsInspectionRegistService.getInspPdaDataDetailList(paramMap);
		resultMap.put("dataMap", inspPdaDetailList);
		
		return resultMap;
	}

}