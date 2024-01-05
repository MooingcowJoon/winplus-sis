package com.samyang.winplus.sis.stock.controller;

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
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;
import com.samyang.winplus.sis.stock.service.ConversionManagementService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RequestMapping("/sis/stock/conversion")
@RestController
public class ConversionManagementController extends BaseController {
	
	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	protected CommonUtil commonUtil;
	
	@Autowired
	ConversionManagementService conversionManagementService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/stock/conversion";
	
	/**
	 * 직영점업무 - 대출입
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="conversionManagement.sis", method=RequestMethod.POST)
	public ModelAndView conversionManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "conversionManagement");
		return mav;
	}
	
	/**
	 * getStockConvHeaderList - 대출입 - 대출입 헤더 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getStockConvHeaderList.do", method=RequestMethod.POST)
	public Map<String, Object> getStockConvHeaderList(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> convMapList = conversionManagementService.getStockConvHeaderList(paramMap);
		resultMap.put("dataMapList", convMapList);
		
		return resultMap;
	}
	
	/**
	 * openAddConvData - 대출입 등록/조회 팝업
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openAddConvData.sis", method = RequestMethod.POST)
	public ModelAndView openAddConvData(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		
		String convInfoString = request.getParameter("convInfo");
		JSONObject jObj = JSONObject.fromObject(convInfoString);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("CONV_DATE", jObj.get("CONV_DATE"));
		paramMap.put("ORGN_DIV_CD", jObj.get("ORGN_DIV_CD"));
		paramMap.put("ORGN_CD", jObj.get("ORGN_CD"));
		paramMap.put("CONV_CD", jObj.get("CONV_CD"));
		
		Map<String, Object> convInfoMap = conversionManagementService.getConvInfo(paramMap);
		if(convInfoMap == null) {
			mav.addObject("convInfo", convInfoString);
		}else {
			mav.addObject("convInfo", JSONObject.fromObject(convInfoMap).toString());
		}
		mav.setViewName(DEFAULT_PATH + "/" + "openAddConvData");
		return mav;
	}
	
	/**
	 * getStockConvDetailList - 대출입 - 대출입 디테일 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getStockConvDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getStockConvDetailList(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> oriConvMapList = conversionManagementService.getStockOriConvDetailList(paramMap);
		List<Map<String, Object>> replcConvMapList = conversionManagementService.getStockReplcConvDetailList(paramMap);
		resultMap.put("oriDataMapList", oriConvMapList);
		resultMap.put("replcDataMapList", replcConvMapList);
		
		return resultMap;
	}
	
	/**
	 * updateConversionManagementList - 대출입 등록/조회 팝업 - 대출입 등록 저장
	 * @author 강신영
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Transactional
	@RequestMapping(value="updateConversionManagementList.do", method=RequestMethod.POST)
	public Map<String, Object> updateConversionManagementList(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String jsonParam = request.getParameter("paramData");
		JSONObject jObj = JSONObject.fromObject(jsonParam);
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String conv_date = "";
		String orgn_div_cd = "";
		String orgn_cd = "";
		String conv_cd = "";
		JSONObject leftGridjObj = null;
		JSONObject rightGridjObj = null;
		
		JSONArray ori_CRUD = null;
		JSONArray ori_BCD_CD = null;
		JSONArray ori_STD_PRICE = null;
		JSONArray ori_CONV_QTY = null;
		JSONArray ori_ORI_TOT_AMT = null;
		JSONArray ori_TAX_YN = null;
		JSONArray conv_CRUD = null;
		JSONArray conv_BCD_CD = null;
		JSONArray conv_STD_PRICE = null;
		JSONArray conv_CONV_PRICE = null;
		JSONArray conv_CONV_QTY = null;
		JSONArray conv_CONV_TOT_AMT = null;
		JSONArray conv_TAX_YN = null;
		
		if(jObj.containsKey("CONV_DATE")) {
			conv_date = jObj.getString("CONV_DATE");
		}
		
		if(jObj.containsKey("ORGN_DIV_CD")) {
			orgn_div_cd = jObj.getString("ORGN_DIV_CD");
		}
		
		if(jObj.containsKey("ORGN_CD")) {
			orgn_cd = jObj.getString("ORGN_CD");
		}
		
		if(jObj.containsKey("CONV_CD")) {
			conv_cd = jObj.getString("CONV_CD");
		}
		
		if(jObj.containsKey("LEFT_GRID_DATA")) {
			leftGridjObj = jObj.getJSONObject("LEFT_GRID_DATA");
			if(leftGridjObj.containsKey("CRUD")) {ori_CRUD = leftGridjObj.getJSONArray("CRUD");}
			if(leftGridjObj.containsKey("BCD_CD")) {ori_BCD_CD = leftGridjObj.getJSONArray("BCD_CD");}
			if(leftGridjObj.containsKey("STD_PRICE")) {ori_STD_PRICE = leftGridjObj.getJSONArray("STD_PRICE");}
			if(leftGridjObj.containsKey("CONV_QTY")) {ori_CONV_QTY = leftGridjObj.getJSONArray("CONV_QTY");}
			if(leftGridjObj.containsKey("ORI_TOT_AMT")) {ori_ORI_TOT_AMT = leftGridjObj.getJSONArray("ORI_TOT_AMT");}
			if(leftGridjObj.containsKey("TAX_YN")) {ori_TAX_YN = leftGridjObj.getJSONArray("TAX_YN");}
		}
		
		if(jObj.containsKey("RIGHT_GRID_DATA")) {
			rightGridjObj = jObj.getJSONObject("RIGHT_GRID_DATA");
			if(rightGridjObj.containsKey("CRUD")) {conv_CRUD = rightGridjObj.getJSONArray("CRUD");}
			if(rightGridjObj.containsKey("BCD_CD")) {conv_BCD_CD = rightGridjObj.getJSONArray("BCD_CD");}
			if(rightGridjObj.containsKey("STD_PRICE")) {conv_STD_PRICE = rightGridjObj.getJSONArray("STD_PRICE");}
			if(rightGridjObj.containsKey("CONV_PRICE")) {conv_CONV_PRICE = rightGridjObj.getJSONArray("CONV_PRICE");}
			if(rightGridjObj.containsKey("CONV_QTY")) {conv_CONV_QTY = rightGridjObj.getJSONArray("CONV_QTY");}
			if(rightGridjObj.containsKey("CONV_TOT_AMT")) {conv_CONV_TOT_AMT = rightGridjObj.getJSONArray("CONV_TOT_AMT");}
			if(rightGridjObj.containsKey("TAX_YN")) {conv_TAX_YN = rightGridjObj.getJSONArray("TAX_YN");}
		}
		
		int oriTotAmtSum = 0;
		int convTotAmtSum = 0;
		for(int i=0; i<ori_ORI_TOT_AMT.size(); i++) {
			if(ori_CRUD.getString(i).equals("D")) {
				continue;
			} else {
				oriTotAmtSum += ori_ORI_TOT_AMT.getInt(i);
			}
		}
		for(int i=0; i<conv_CONV_TOT_AMT.size(); i++) {
			if(conv_CRUD.getString(i).equals("D")) {
				continue;
			} else {
				convTotAmtSum += conv_CONV_TOT_AMT.getInt(i);
			}
		}
		
		String errMesage = "";
		String errCode = "";
		boolean vaildTF = true;
		
		if(Math.abs(oriTotAmtSum - convTotAmtSum) > 10) {
			errMesage = messageSource.getMessage("error.sis.conversion.tot_amt.diffAmtOver", new Object[1], commonUtil.getDefaultLocale());
			vaildTF = false;
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		}else if(Math.floor(oriTotAmtSum/10.0) < Math.floor(convTotAmtSum/10.0)) {
			errMesage = messageSource.getMessage("error.sis.conversion.tot_amt.notGreaterConv", new Object[1], commonUtil.getDefaultLocale());
			vaildTF = false;
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		}
		
		if(conv_date == null || conv_date.equals("")) {
			errMesage = messageSource.getMessage("error.sis.conversion.conv_date.empty", new Object[1], commonUtil.getDefaultLocale());
			vaildTF = false;
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		}
		
		try {
			if(vaildTF) {
				if(conv_cd == null || conv_cd.equals("")) {
					StringBuilder sb = new StringBuilder();
					sb.append(conv_date);
					sb.append("_");
					sb.append(conversionManagementService.getStockConvSeq());
					conv_cd = sb.toString();
				}
				
				Map<String, Object> paramMap = null;
				Map<String, Object> resultDataMap = null;
				int updateCnt = 0;
				
				for(int i=0; i<ori_CRUD.size(); i++) {
					paramMap = new HashMap<String, Object>();
					paramMap.put("CRUD",ori_CRUD.get(i));
					paramMap.put("CONV_DATE",conv_date);
					paramMap.put("ORGN_DIV_CD",orgn_div_cd);
					paramMap.put("ORGN_CD",orgn_cd);
					paramMap.put("CONV_CD",conv_cd);
					
					paramMap.put("CONV_TYPE","ORI");
					paramMap.put("GOODS_BCD",ori_BCD_CD.get(i));
					paramMap.put("STD_PRICE",ori_STD_PRICE.get(i));
					paramMap.put("CONV_PRICE",ori_STD_PRICE.get(i));
					paramMap.put("CONV_QTY",ori_CONV_QTY.get(i));
					paramMap.put("CONV_TOT_AMT",ori_ORI_TOT_AMT.get(i));
					if(ori_TAX_YN.get(i) != null && !ori_TAX_YN.get(i).equals("")) {
						paramMap.put("GOODS_TAX_YN",ori_TAX_YN.get(i));
					} else {
						paramMap.put("GOODS_TAX_YN","N");
					}
					paramMap.put("PROGRM", "updateConversionManagementList");
					paramMap.put("EMP_NO", emp_no);
					
					resultDataMap = conversionManagementService.updateConversionDetail(paramMap);
					if(resultDataMap.get("RESULT_MSG").equals("SAVE_SUCCESS")) {
						++updateCnt;
					} else if(resultDataMap.get("RESULT_MSG").equals("INS_SUCCESS")) {
						++updateCnt;
					} else if(resultDataMap.get("RESULT_MSG").equals("DEL_SUCCESS")) {
						++updateCnt;
					}
				}
				for(int i=0; i<conv_CRUD.size(); i++) {
					paramMap = new HashMap<String, Object>();
					paramMap.put("CRUD",conv_CRUD.get(i));
					paramMap.put("CONV_DATE",conv_date);
					paramMap.put("ORGN_DIV_CD",orgn_div_cd);
					paramMap.put("ORGN_CD",orgn_cd);
					paramMap.put("CONV_CD",conv_cd);
					
					paramMap.put("CONV_TYPE","CONV");
					paramMap.put("GOODS_BCD",conv_BCD_CD.get(i));
					paramMap.put("STD_PRICE",conv_STD_PRICE.get(i));
					paramMap.put("CONV_PRICE",conv_CONV_PRICE.get(i));
					paramMap.put("CONV_QTY",conv_CONV_QTY.get(i));
					paramMap.put("CONV_TOT_AMT",conv_CONV_TOT_AMT.get(i));
					if(conv_TAX_YN.get(i) != null && !conv_TAX_YN.get(i).equals("")) {
						paramMap.put("GOODS_TAX_YN",conv_TAX_YN.get(i));
					} else {
						paramMap.put("GOODS_TAX_YN","N");
					}
					paramMap.put("PROGRM", "updateConversionManagementList");
					paramMap.put("EMP_NO", emp_no);
					
					resultDataMap = conversionManagementService.updateConversionDetail(paramMap);
					if(resultDataMap.get("RESULT_MSG").equals("SAVE_SUCCESS")) {
						++updateCnt;
					} else if(resultDataMap.get("RESULT_MSG").equals("INS_SUCCESS")) {
						++updateCnt;
					} else if(resultDataMap.get("RESULT_MSG").equals("DEL_SUCCESS")) {
						++updateCnt;
					}
				}
				
				if((ori_CRUD.size() + conv_CRUD.size()) == updateCnt) {
					resultMap.put("resultRowCnt", updateCnt);
					conversionManagementService.updateConversionHeader(paramMap);
				} else {
					errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
					vaildTF = false;
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			}
		}catch(SQLException e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		} finally {
			if(resultMap.containsKey("isError")) {
				if(resultMap.get("isError") != null && (boolean) resultMap.get("isError")) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				}
			}
		}
		
		return resultMap;
	}
	
	/**
	 * deleteConversionManagementList - 대출입 - 대출입 헤더 삭제
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Transactional
	@RequestMapping(value="deleteConversionManagementList.do", method=RequestMethod.POST)
	public Map<String, Object> deleteConversionManagementList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			String resultMsg = conversionManagementService.deleteConversionManagementList(paramMap);
			if(resultMsg != null && resultMsg.equals("SUCCESS")) {
				resultMap.put("resultMsg", resultMsg);
			} else {
				String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1999";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			}
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
	 * reqConfirmConv - 대출입 - 대출입 요청
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Transactional
	@RequestMapping(value="reqConfirmConv.do", method=RequestMethod.POST)
	public Map<String, Object> reqConfirmConv(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		paramMap.put("RESP_USER", emp_no);
		
		try {
			String resultMsg = conversionManagementService.reqConfirmConv(paramMap);
			if(resultMsg != null && resultMsg.equals("SUCCESS")) {
				resultMap.put("resultMsg", resultMsg);
			} else {
				String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1999";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			}
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
	 * reqConfirmCancelConv - 대출입 - 대출입 요청취소
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Transactional
	@RequestMapping(value="reqConfirmCancelConv.do", method=RequestMethod.POST)
	public Map<String, Object> reqConfirmCancelConv(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		paramMap.put("RESP_USER", emp_no);
		
		try {
			String resultMsg = conversionManagementService.reqConfirmCancelConv(paramMap);
			if(resultMsg != null && resultMsg.equals("SUCCESS")) {
				resultMap.put("resultMsg", resultMsg);
			} else {
				String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1999";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			}
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
	 * 직영점업무 - 대출입확정
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="conversionConfirm.sis", method=RequestMethod.POST)
	public ModelAndView conversionConfirm(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "conversionConfirm");
		return mav;
	}
	
	/**
	 * getStockConvReqList - 대출입확정 - 대출입요청 자료 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getStockConvReqList.do", method=RequestMethod.POST)
	public Map<String, Object> getStockConvReqList(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> convMapList = conversionManagementService.getStockConvReqList(paramMap);
		resultMap.put("dataMapList", convMapList);
		
		return resultMap;
	}
	
	/**
	 * openSearchConvData - 대출입확정 조회 팝업
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "openSearchConvData.sis", method = RequestMethod.POST)
	public ModelAndView openSearchConvData(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		
		String convInfoString = request.getParameter("convInfo");
		JSONObject jObj = JSONObject.fromObject(convInfoString);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("CONV_DATE", jObj.get("CONV_DATE"));
		paramMap.put("ORGN_DIV_CD", jObj.get("ORGN_DIV_CD"));
		paramMap.put("ORGN_CD", jObj.get("ORGN_CD"));
		paramMap.put("CONV_CD", jObj.get("CONV_CD"));
		
		Map<String, Object> convInfoMap = conversionManagementService.getConvInfo(paramMap);
		if(convInfoMap == null) {
			mav.addObject("convInfo", convInfoString);
		}else {
			mav.addObject("convInfo", JSONObject.fromObject(convInfoMap).toString());
		}
		mav.setViewName(DEFAULT_PATH + "/" + "openSearchConvData");
		return mav;
	}
	
	/**
	 * confirmConvData - 대출입확정 - 대출입 확정
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Transactional
	@RequestMapping(value="confirmConvData.do", method=RequestMethod.POST)
	public Map<String, Object> confirmConvData(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		paramMap.put("RESP_USER", emp_no);
		
		try {
			String resultMsg = conversionManagementService.confirmConvData(paramMap);
			if(resultMsg != null && resultMsg.equals("SUCCESS")) {
				resultMap.put("resultMsg", resultMsg);
			} else {
				String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1999";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			}
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
	 * confirmCancelConvData - 대출입확정 - 대출입 확정취소
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Transactional
	@RequestMapping(value="confirmCancelConvData.do", method=RequestMethod.POST)
	public Map<String, Object> confirmCancelConvData(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		paramMap.put("RESP_USER", emp_no);
		
		try {
			String resultMsg = conversionManagementService.confirmCancelConvData(paramMap);
			if(resultMsg != null && resultMsg.equals("SUCCESS")) {
				resultMap.put("resultMsg", resultMsg);
			} else {
				String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1999";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			}
		}catch(SQLException e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
}