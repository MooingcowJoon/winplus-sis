package com.samyang.winplus.sis.market.controller;

import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;
import com.samyang.winplus.sis.market.service.TellOrderService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RequestMapping("/sis/market/sales")
@RestController
public class TellOrderController extends BaseController {

	@Autowired
	protected CommonUtil commonUtil;
	
	@Autowired
	TellOrderService tellOrderService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/market/sales";
	
	/**
	  * 점포업무관리 - 판매관리 - 전화주문
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="TellOrder.sis", method=RequestMethod.POST)
	public ModelAndView TellOrder(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "tellOrder");
		return mav;
	}
	
	/**
	 * 점포업무관리 - 판매관리 - 전화주문 - 전화번호로 회원목록 불러오기
	 * @param request
	 * @return
	 */
	@RequestMapping(value="getCIDMemberList.do", method=RequestMethod.POST)
	public Map<String, Object> getCIDMemberList(HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String ORGN_DIV_CD = empSessionDto.getOrgn_div_cd();
		String ORGN_CD = empSessionDto.getOrgn_cd();
		String TEL_NO = request.getParameter("TEL_NO");
		
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("TEL_NO", TEL_NO);
		
		List<Map<String, Object>> memberList = null;
		
		try {
			memberList = tellOrderService.getCIDMemberList(paramMap);
			resultMap.put("dataList", memberList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * 점포업무관리 - 판매관리 - 전화주문 - 회원정보 불러오기
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getCIDMemberInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getCIDMemberInfo(HttpServletRequest request){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String ORGN_DIV_CD = empSessionDto.getOrgn_div_cd();
		String ORGN_CD = empSessionDto.getOrgn_cd();
		String MEM_NO = request.getParameter("MEM_NO");
		
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("MEM_NO", MEM_NO);
		
		try {
			Map<String, Object> memberInfoValue = tellOrderService.getCIDMemberInfo(paramMap);
			resultMap.put("dataMap", memberInfoValue);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * 점포업무관리 - 판매관리 - 전화주문 - 해당회원 주문내역 헤더조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getMemOrderHeaderList.do", method=RequestMethod.POST)
	public Map<String, Object> getMemOrderHeaderList(HttpServletRequest request ,@RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> memOrderHeaderList = tellOrderService.getMemOrderHeaderList(paramMap);
			resultMap.put("gridDataList", memOrderHeaderList);
			Map<String, Object> memOrderSummaryMap = tellOrderService.getMemOrderSummaryInfo(paramMap);
			resultMap.put("summaryData", memOrderSummaryMap);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * 점포업무관리 - 판매관리 - 전화주문 - 해당회원 주문내역 디테일조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getMemOrderDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getMemOrderDetailList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> memOrderDetailList = tellOrderService.getMemOrderDetailList(paramMap);
			resultMap.put("dataMapList", memOrderDetailList);
			Map<String, Object> memberInfoValue = tellOrderService.getCIDMemberInfo(paramMap);
			resultMap.put("memInfo", memberInfoValue);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	 * 점포업무관리 - 판매관리 - 전화주문 - 주문접수완료 처리
	 * @author 강신영
	 * @param request
	 * @return Map<String, Object>
	 */
	@Transactional
	@RequestMapping(value="receiptMemOrderList.do", method=RequestMethod.POST)
	public Map<String, Object> receiptMemOrderList(HttpServletRequest request, @RequestParam List<String> paramList){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		int successCnt = 0;
		int resultValue = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String ORGN_DIV_CD = empSessionDto.getOrgn_div_cd();
		String ORGN_CD = empSessionDto.getOrgn_cd();
		
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("emp_no", emp_no);
		
		String errMesage = "";
		String errCode = "";
		boolean vaildTF = true;
		
		try {
			if(vaildTF) {
				for(int i = 0 ; i < paramList.size() ; i++) {
					paramMap.put("TEL_ORD_CD", paramList.get(i));
					resultValue = tellOrderService.receiptMemOrderList(paramMap);
					successCnt += resultValue;
				}
				
				if(paramList.size() == successCnt && paramList.size() > 0) {
					resultMap.put("resultValue", successCnt);
				}else {
					errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
					vaildTF = false;
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			}
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
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
	 * 점포업무관리 - 판매관리 - 전화주문 - 주문취소건 재주문 완료 처리
	 * @author 강신영
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="reOrderMemOrderList.do", method=RequestMethod.POST)
	public Map<String, Object> reOrderMemOrderList(HttpServletRequest request, @RequestParam List<String> paramList){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		int successCnt = 0;
		int resultValue = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String ORGN_DIV_CD = empSessionDto.getOrgn_div_cd();
		String ORGN_CD = empSessionDto.getOrgn_cd();
		
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("emp_no", emp_no);
		
		try {
			
			for(int i = 0 ; i < paramList.size() ; i++) {
				paramMap.put("TEL_ORD_CD", paramList.get(i));
				resultValue = tellOrderService.reOrderMemOrderList(paramMap);
				successCnt += resultValue;
			}
			
			resultMap.put("resultValue", successCnt);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	 * 점포업무관리 - 판매관리 - 전화주문 - 해당회원 주문내역 취소처리
	 * @author 정혜원
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="cancelMemOrderList.do", method=RequestMethod.POST)
	public Map<String, Object> cancelMemOrderList(HttpServletRequest request, @RequestParam List<String> paramList){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		int cancel_cnt = 0;
		int resultValue = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String ORGN_DIV_CD = empSessionDto.getOrgn_div_cd();
		String ORGN_CD = empSessionDto.getOrgn_cd();
		
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("emp_no", emp_no);
		
		try {
			
			for(int i = 0 ; i < paramList.size() ; i++) {
				paramMap.put("TEL_ORD_CD", paramList.get(i));
				resultValue = tellOrderService.cancelMemOrderList(paramMap);
				cancel_cnt += resultValue;
			}
			
			resultMap.put("resultValue", cancel_cnt);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * openNewOrderPopup - 점포업무관리 - 판매관리 - 전화주문 - 새주문서작성팝업
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openNewOrderPopup.sis", method = RequestMethod.POST)
	public ModelAndView openNewOrderPopup(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("memberInfo", request.getParameter("memberInfo"));
		mav.setViewName(DEFAULT_PATH + "/" + "openNewOrderPopup");
		return mav;
	}
	
	/**
	  * 점포업무관리 - 판매관리 - 전화주문 - 새주문서작성 - 거래내역불러오기
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="openTradeStatementGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView openTradeStatementGridPopup(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.addObject("Mem_Info", request.getParameter("Mem_Info"));
		mav.setViewName(DEFAULT_PATH + "/" + "openTradeStatementGridPopup");
		return mav;
	}
	
	/**
	* getOpenNewOrderPopupList -새주문서작성팝업 - 상품검색 추가정보조회
	* 
	* @author 최지민
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="getNewOrderListInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getNewOrderListInfo(HttpServletRequest request) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String ORGN_DIV_CD = empSessionDto.getOrgn_div_cd();
		String ORGN_CD = empSessionDto.getOrgn_cd();
		String GOODS_NO = request.getParameter("GOODS_NO");
		String BCD_CD = request.getParameter("BCD_CD");
		
		paramMap.put("GOODS_NO", GOODS_NO);
		paramMap.put("BCD_CD", BCD_CD);
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		
		try{
			List<Map<String, Object>> gridDataList = tellOrderService.getNewOrderListInfo(paramMap);
			resultMap.put("gridDataList", gridDataList);
		} catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	* saveNewOrderPopupList -새주문서작성팝업 - 상품내역 저장
	* 
	* @author 정혜원
	* @param request
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@RequestMapping(value="saveNewOrderPopupList.do", method=RequestMethod.POST)
	public Map<String, Object> saveNewOrderPopupList(HttpServletRequest request, String SALE_PRICE, String SALE_VAT_AMT, String SALE_QTY, String PAY_SUM_AMT, String SALE_TOT_AMT) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String ORGN_DIV_CD = empSessionDto.getOrgn_div_cd();
		String ORGN_CD = empSessionDto.getOrgn_cd();
		
		List<Map<String,Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		//logger.debug("saveNewOrder List >>> " + dhtmlxParamMapList);
		try {
			for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList) {
				dhtmlxParamMap.put("EMP_NO", emp_no);
				dhtmlxParamMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
				dhtmlxParamMap.put("ORGN_CD", ORGN_CD);
			}
			//logger.debug("새주문서작성 저장 리스트 >>> " + dhtmlxParamMapList);
			resultMap = tellOrderService.saveNewOrderPopupList(dhtmlxParamMapList);
			//logger.debug("Controller resultMap >>>>> " + resultMap);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	/**
	  * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화)
	  * @author 한정훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="TellOrderHistory.sis", method=RequestMethod.POST)
	public ModelAndView TellOrderHistory(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "tellOrderHistory");
		return mav;
	}
	/**
	  * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 회원별 상세 팝업
	  * @author 한정훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openTellOrderHistoryPopup.sis", method = RequestMethod.POST)
	public ModelAndView openTellOrderHistoryPopup(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openTellOrderHistoryPopup");
		
		String tellInfo = request.getParameter("tellInfo");
		mav.addObject("tellInfo", tellInfo);
		
		return mav;
	}
	/**
	  * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 조회
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@ResponseBody
	@RequestMapping(value="getOrderListByGroup.do", method=RequestMethod.POST)
	public Map<String, Object> getOrderListByGroup(HttpServletRequest request, @RequestBody Map<String, Object>paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap >>>> " + paramMap);
		
		List<Map<String, Object>> getOnlineSalesInfo = tellOrderService.getOrderListByGroup(paramMap);
		resultMap.put("gridDataList", getOnlineSalesInfo);
		
		return resultMap;
	}
	/**
	  * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 조회1,2
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getTellOrderinitdata.do", method=RequestMethod.POST)
	public Map<String, Object> getTellOrderinitdata(HttpServletRequest request, @RequestParam Map<String, Object>paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap >>>> " + paramMap);
		Map<String, Object> getMemdata = tellOrderService.getMemdata(paramMap);
		resultMap.put("dataMap", getMemdata);
		
		List<Map<String, Object>> getOrderByDate = tellOrderService.getOrderByDate(paramMap);
		resultMap.put("gridDataList", getOrderByDate);
		
		return resultMap;
	}
	/**
	  * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 조회2
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getMemOrderBodydata.do", method=RequestMethod.POST)
	public Map<String, Object> getMemOrderBodydata(HttpServletRequest request, @RequestParam Map<String, Object>paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap >>>> " + paramMap);
		
		List<Map<String, Object>> getOrderByDate = tellOrderService.getOrderByDate(paramMap);
		resultMap.put("gridDataList", getOrderByDate);
		
		return resultMap;
	}
	/**
	  * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 저장
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@ResponseBody
	@RequestMapping(value="saveTellOrderDetailPopup.do", method=RequestMethod.POST)
	public Map<String, Object> saveTellOrderDetailPopup(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap >>>> " + paramMap);
		tellOrderService.saveTellOrderDetailPopup(paramMap);
		
		return resultMap;
	}
	/**
	  * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 - 배송일 저장
	  * @author 한정훈
	  * @param paramMap
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="updateTellOrderOutWareDate.do", method=RequestMethod.POST)
	public Map<String, Object> updateTellOrderOutWareDate(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> result  = tellOrderService.updateTellOrderOutWareDate(paramMap);
		resultMap.put("result", result);
		return resultMap;
	}
	
	/**
	 * 메인 - CTI 접속
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openCTIWindow.sis")
	public ModelAndView openCTIWindow(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openCTIWindow");
		return mav;
	}
	
	/**
	 * openTellOrderCTIPopup - 전화주문 새주문서 팝업
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openTellOrderCTIPopup.sis", method=RequestMethod.POST)
	public ModelAndView openTellOrderCTIPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		Enumeration<String> requestParams = request.getParameterNames();
		String reqParamKey = "";
		String reqParamValue = "";
		while(requestParams.hasMoreElements()) {
			reqParamKey = requestParams.nextElement();
			reqParamValue = request.getParameter(reqParamKey);
			mav.addObject(reqParamKey, reqParamValue);
		}
		mav.setViewName(DEFAULT_PATH + "/" + "openTellOrderCTIPopup");
		return mav;
	}
	
	/**
	* saveOpenNewOrderPopupList -새주문서작성팝업 - 전화주문 저장 
	* @author 강신영
	* @param request
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@Transactional
	@RequestMapping(value="saveOpenNewOrderPopupList.do", method=RequestMethod.POST)
	public Map<String, Object> saveOpenNewOrderPopupList(HttpServletRequest request) throws SQLException, Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String jsonParam = request.getParameter("paramData");
		JSONObject jObj = JSONObject.fromObject(jsonParam);
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String deli_ord_state = "";
		String deli_out_date = "";
		String mem_no = "";
		String ord_memo = "";
		String orgn_div_cd = "";
		String orgn_cd = "";
		String deli_ord_cd = "";
		
		JSONObject popupGridjObj = null;
		
		JSONArray CRUD = null;
		JSONArray BCD_CD = null;
		JSONArray SALE_PRICE = null;
		JSONArray SALE_QTY = null;
		JSONArray SALE_TOT_AMT = null;
		JSONArray ORD_MEMO = null;
		
		if(jObj.containsKey("DELI_ORD_STATE")) {
			deli_ord_state = jObj.getString("DELI_ORD_STATE");
		}
		
		if(jObj.containsKey("DELI_OUT_DATE")) {
			deli_out_date = jObj.getString("DELI_OUT_DATE");
		}
		
		if(jObj.containsKey("MEM_NO")) {
			mem_no = jObj.getString("MEM_NO");
		}
		
		if(jObj.containsKey("ORD_MEMO")) {
			ord_memo = jObj.getString("ORD_MEMO");
		}
		
		if(jObj.containsKey("ORGN_DIV_CD")) {
			orgn_div_cd = jObj.getString("ORGN_DIV_CD");
		}
		
		if(jObj.containsKey("ORGN_CD")) {
			orgn_cd = jObj.getString("ORGN_CD");
		}
		
		if(jObj.containsKey("DELI_ORD_CD")) {
			deli_ord_cd = jObj.getString("DELI_ORD_CD");
		}
		
		if(jObj.containsKey("POPUP_GRID_DATA")) {
			popupGridjObj = jObj.getJSONObject("POPUP_GRID_DATA");
			if(popupGridjObj.containsKey("CRUD")) {CRUD = popupGridjObj.getJSONArray("CRUD");}
			if(popupGridjObj.containsKey("BCD_CD")) {BCD_CD = popupGridjObj.getJSONArray("BCD_CD");}
			if(popupGridjObj.containsKey("SALE_PRICE")) {SALE_PRICE = popupGridjObj.getJSONArray("SALE_PRICE");}
			if(popupGridjObj.containsKey("SALE_QTY")) {SALE_QTY = popupGridjObj.getJSONArray("SALE_QTY");}
			if(popupGridjObj.containsKey("SALE_TOT_AMT")) {SALE_TOT_AMT = popupGridjObj.getJSONArray("SALE_TOT_AMT");}
			if(popupGridjObj.containsKey("ORD_MEMO")) {ORD_MEMO = popupGridjObj.getJSONArray("ORD_MEMO");}
		}
		
		//추후 사용을 위한 주석
		/*int oriTotAmtSum = 0;
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
		}*/
		
		String errMesage = "";
		String errCode = "";
		boolean vaildTF = true;
		
		//추후 사용을 위한 주석
		/*if(Math.abs(oriTotAmtSum - convTotAmtSum) > 10) {
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
		}*/
		
		try {
			if(vaildTF) {
				if(deli_ord_cd == null || deli_ord_cd.equals("")) {
					deli_ord_cd = tellOrderService.getDeliOrdCdSeq();
				}
				
				Map<String, Object> paramMap = null;
				Map<String, Object> resultDataMap = null;
				int updateCnt = 0;
				
				for(int i=0; i<CRUD.size(); i++) {
					paramMap = new HashMap<String, Object>();
					
					paramMap.put("CRUD",CRUD.get(i));
					paramMap.put("DELI_ORD_STATE",deli_ord_state);
					paramMap.put("DELI_OUT_DATE",deli_out_date);
					paramMap.put("ORGN_DIV_CD",orgn_div_cd);
					paramMap.put("ORGN_CD",orgn_cd);
					paramMap.put("MEM_NO",mem_no);
					paramMap.put("H_ORD_MEMO",ord_memo);
					paramMap.put("DELI_ORD_CD",deli_ord_cd);
					
					paramMap.put("BCD_CD",BCD_CD.get(i));
					paramMap.put("SALE_PRICE",SALE_PRICE.get(i));
					paramMap.put("SALE_QTY",SALE_QTY.get(i));
					paramMap.put("SALE_TOT_AMT",SALE_TOT_AMT.get(i));
					paramMap.put("D_ORD_MEMO",ORD_MEMO.get(i));
					paramMap.put("PROGRM", "saveOpenNewOrderPopupList");
					paramMap.put("EMP_NO", emp_no);
					
					resultDataMap = tellOrderService.saveOpenNewOrderPopupList(paramMap);
					if(resultDataMap.get("RESULT_MSG").equals("SAVE_SUCCESS")) {
						++updateCnt;
					} else if(resultDataMap.get("RESULT_MSG").equals("INS_SUCCESS")) {
						++updateCnt;
					} else if(resultDataMap.get("RESULT_MSG").equals("DEL_SUCCESS")) {
						++updateCnt;
					}
				}
				
				if(CRUD.size() == updateCnt) {
					int hUpdateCnt = 0;
					hUpdateCnt = tellOrderService.saveOpenNewOrderPopupHeader(paramMap);
					if(hUpdateCnt > 0) {
						resultMap.put("resultRowCnt", updateCnt);
					}else {
						errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
						vaildTF = false;
						resultMap = commonUtil.getErrorMap(errMesage, errCode);
					}
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
	 * getDeliOrderInfo -새주문서작성팝업 - 전화주문 정보 조회
	 * @author 강신영
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="getDeliOrderInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getDeliOrderInfo(HttpServletRequest request) throws SQLException, Exception {
		
		String jsonParam = request.getParameter("paramData");
		JSONObject jObj = JSONObject.fromObject(jsonParam);
		
		String orgn_div_cd = "";
		String orgn_cd = "";
		String deli_ord_cd = "";
		
		
		if(jObj.containsKey("ORGN_DIV_CD")) {
			orgn_div_cd = jObj.getString("ORGN_DIV_CD");
		}
		
		if(jObj.containsKey("ORGN_CD")) {
			orgn_cd = jObj.getString("ORGN_CD");
		}
		
		if(jObj.containsKey("DELI_ORD_CD")) {
			deli_ord_cd = jObj.getString("DELI_ORD_CD");
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("ORGN_DIV_CD",orgn_div_cd);
		paramMap.put("ORGN_CD",orgn_cd);
		paramMap.put("DELI_ORD_CD",deli_ord_cd);
		
		try {
			List<Map<String, Object>> deliOrderList = tellOrderService.getDeliOrderDetail(paramMap);
			resultMap.put("dataMapDetail", deliOrderList);
			Map<String, Object> deliOrderMap = tellOrderService.getDeliOrderHeader(paramMap);
			resultMap.put("dataMapHeader", deliOrderMap);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	 * openPastOrderGridPopup - 전화주문 지난거래 불러오기 팝업
	 * @author 강신영
	 * @param request
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 */
	@RequestMapping(value="openPastOrderGridPopup.sis", method=RequestMethod.POST)
	public ModelAndView openPastOrderGridPopup(HttpServletRequest request) throws SQLException, Exception {
		ModelAndView mav = new ModelAndView();
		Enumeration<String> requestParams = request.getParameterNames();
		String reqParamKey = "";
		String reqParamValue = "";
		while(requestParams.hasMoreElements()) {
			reqParamKey = requestParams.nextElement();
			reqParamValue = request.getParameter(reqParamKey);
			mav.addObject(reqParamKey, reqParamValue);
		}
		mav.setViewName(DEFAULT_PATH + "/" + "openPastOrderGridPopup");
		return mav;
	}
}
