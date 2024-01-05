package com.samyang.winplus.sis.stock.controller;

import java.sql.SQLException;
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
import com.samyang.winplus.sis.stock.service.TransInOutService;

@RequestMapping("/sis/stock/transInOut")
@RestController
public class TransInOutController extends BaseController {

	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final static String DEFAULT_PATH = "sis/stock/transInOut";
	
	@Autowired
	private TransInOutService transInOutService;
	
	/**
	 * 재고이동등록(직영점)
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "transInOutRegist.sis", method=RequestMethod.POST)
	public ModelAndView transInOutRegist(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "transInOutRegist");
		return mav;
	}
	
	/**
	 * 재고이동등록(직영점) - PDA재고이동 Summary 자료 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getPdaTransSummaryList.do", method=RequestMethod.POST)
	public Map<String, Object> getPdaTransSummaryList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> gridDataList = transInOutService.getPdaTransSummaryList(paramMap);
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
	 * 재고이동등록(직영점) - PDA재고이동 Item 자료 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getPdaTransItemList.do", method=RequestMethod.POST)
	public Map<String, Object> getPdaTransItemList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> gridDataList = transInOutService.getPdaTransItemList(paramMap);
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
	 * 재고이동등록(직영점) - 재고이동 마스터 자료 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getStockTransMastList.do", method=RequestMethod.POST)
	public Map<String, Object> getStockTransMastList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> gridDataList = transInOutService.getStockTransMastList(paramMap);
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
	 * 재고이동등록(직영점) - 재고이동 디테일 자료 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getStockTransDetlList.do", method=RequestMethod.POST)
	public Map<String, Object> getStockTransDetlList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> gridDataList = transInOutService.getStockTransDetlList(paramMap);
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
	 * 재고이동등록(직영점) - 재고이동 자료 생성
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="createTransData.do", method=RequestMethod.POST)
	public Map<String, Object> createTransData(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String RESP_USER = empSessionDto.getEmp_no();
		
		paramMap.put("RESP_USER", RESP_USER);
		
		try {
			String resultMsg = transInOutService.createTransData(paramMap);
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
	 * 재고이동등록(직영점) - PDA자료 삭제
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="deletePdaData.do", method=RequestMethod.POST)
	public Map<String, Object> deletePdaData(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			String resultMsg = transInOutService.deletePdaData(paramMap);
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
	 * 재고이동등록(직영점) - 재고이동 요청
	 * @author 강신영
	 * @param request
	 * @param paramList
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Transactional
	@RequestMapping(value="requestTransData.do", method=RequestMethod.POST)
	public Map<String, Object> requestTransData(HttpServletRequest request, @RequestParam List<String> paramList) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		int successCnt = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String RESP_USER = empSessionDto.getEmp_no();
		
		paramMap.put("RESP_USER", RESP_USER);
		
		try {
			for(int i = 0 ; i < paramList.size() ; i++) {
				paramMap.put("UNI_KEY", paramList.get(i));
				successCnt += transInOutService.requestTransData(paramMap);
			}
			if(successCnt == paramList.size()) {
				resultMap.put("resultMsg", "SUCCESS");
			}else {
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
	 * 재고이동등록(직영점) - 재고이동 요청취소
	 * @author 강신영
	 * @param request
	 * @param paramList
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="requestCancelTransData.do", method=RequestMethod.POST)
	public Map<String, Object> requestCancelTransData(HttpServletRequest request, @RequestParam List<String> paramList) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		int successCnt = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String RESP_USER = empSessionDto.getEmp_no();
		
		paramMap.put("RESP_USER", RESP_USER);
		
		try {
			for(int i = 0 ; i < paramList.size() ; i++) {
				paramMap.put("UNI_KEY", paramList.get(i));
				successCnt += transInOutService.requestCancelTransData(paramMap);
			}
			if(successCnt == paramList.size()) {
				resultMap.put("resultMsg", "SUCCESS");
			}else {
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
	 * 재고이동등록(직영점) - 재고이동 품목저장
	 * @author 강신영
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Transactional
	@RequestMapping(value="saveTransData.do", method=RequestMethod.POST)
	public Map<String, Object> saveTransData(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String RESP_USER = empSessionDto.getEmp_no();
		
		int deleteResult = 0;
		int updateResult = 0;
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			paramMap = dhtmlxParamMapList.get(i);
			
			paramMap.put("RESP_USER", RESP_USER);
			
			if(paramMap.get("CRUD").equals("D")) {
				deleteResult += transInOutService.deleteTransDataItem(paramMap);
			} else {
				updateResult += transInOutService.updateTransDataItem(paramMap);
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
	 * 재고이동확인(직영점)
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "transInOutConfirm.sis", method=RequestMethod.POST)
	public ModelAndView transInOutConfirm(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "transInOutConfirm");
		return mav;
	}
	
	/**
	 * 재고이동등록(직영점) - 재고이동 요청 자료 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getStockTransReqList.do", method=RequestMethod.POST)
	public Map<String, Object> getStockTransReqList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> gridDataList = transInOutService.getStockTransReqList(paramMap);
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
	 * 재고이동확인(직영점) - 재고이동 확정
	 * @author 강신영
	 * @param request
	 * @param paramList
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Transactional
	@RequestMapping(value="confirmTransData.do", method=RequestMethod.POST)
	public Map<String, Object> confirmTransData(HttpServletRequest request, @RequestParam List<String> paramList) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		int successCnt = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String RESP_USER = empSessionDto.getEmp_no();
		
		paramMap.put("RESP_USER", RESP_USER);
		
		try {
			for(int i = 0 ; i < paramList.size() ; i++) {
				paramMap.put("UNI_KEY", paramList.get(i));
				successCnt += transInOutService.confirmTransData(paramMap);
			}
			if(successCnt == paramList.size()) {
				resultMap.put("resultMsg", "SUCCESS");
			}else {
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
	 * 재고이동확인(직영점) - 재고이동 확정취소
	 * @author 강신영
	 * @param request
	 * @param paramList
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="confirmCancelTransData.do", method=RequestMethod.POST)
	public Map<String, Object> confirmCancelTransData(HttpServletRequest request, @RequestParam List<String> paramList) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		int successCnt = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String RESP_USER = empSessionDto.getEmp_no();
		
		paramMap.put("RESP_USER", RESP_USER);
		
		try {
			for(int i = 0 ; i < paramList.size() ; i++) {
				paramMap.put("UNI_KEY", paramList.get(i));
				successCnt += transInOutService.confirmCancelTransData(paramMap);
			}
			if(successCnt == paramList.size()) {
				resultMap.put("resultMsg", "SUCCESS");
			}else {
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
	 * 재고이동등록(직영점) - 재고이동 자료삭제
	 * @author 강신영
	 * @param request
	 * @param paramList
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Transactional
	@RequestMapping(value="deleteTransData.do", method=RequestMethod.POST)
	public Map<String, Object> deleteTransData(HttpServletRequest request, @RequestParam List<String> paramList) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		int successCnt = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String RESP_USER = empSessionDto.getEmp_no();
		
		paramMap.put("RESP_USER", RESP_USER);
		
		try {
			for(int i = 0 ; i < paramList.size() ; i++) {
				paramMap.put("UNI_KEY", paramList.get(i));
				successCnt += transInOutService.deleteTransData(paramMap);
			}
			if(successCnt == paramList.size()) {
				resultMap.put("resultMsg", "SUCCESS");
			}else {
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