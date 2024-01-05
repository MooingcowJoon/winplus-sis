package com.samyang.winplus.sis.report.controller;

import java.sql.SQLException;
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
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;
import com.samyang.winplus.sis.report.service.PurchaseManagementService;

@RequestMapping("/sis/report/PurchaseManagement")
@RestController
public class PurchaseManagementController extends BaseController{
	
private final static String DEFAULT_PATH = "sis/report/StateByPurchaseManagement";
		
	@Autowired
	protected CommonUtil commonUtil;
	@Autowired
	BoardService boardService;
	
	@Autowired
	PurchaseManagementService purchaseManagementService;
	
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	/**
	 * 레포트관리 - 구매관리현황 - 거래처별채무 
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="DebtByCustmr.sis", method=RequestMethod.POST)
	public ModelAndView DebtByCustmr(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "DebtByCustmr");
		return mav;
	}
	
	/**
	 * 레포트관리 - 구매관리현황 - 지급현황 
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="StateByPayment.sis", method=RequestMethod.POST)
	public ModelAndView StateByPayment(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "StateByPayment");
		return mav;
	}
	
	/**
	 * 레포트관리 - 구매관리현황 - 매입청구서조회(재고)
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="SearchPurchaseBill.sis", method=RequestMethod.POST)
	public ModelAndView SearchPurchaseBill(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "SearchPurchaseBill");
		return mav;
	}
	
	/**
	 * 레포트관리 - 구매관리현황 - 매입청구서현황(재고)
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="StatePurchaseBill.sis", method=RequestMethod.POST)
	public ModelAndView StatePurchaseBill(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "StatePurchaseBill");
		return mav;
	}
	
	/**
	 * 레포트관리 - 구매관리현황 - 거래처별채무 - 조회내역
	 * @author 정혜원
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getDebtByCustmrList.do", method=RequestMethod.POST)
	public Map<String, Object> getDebtByCustmrList(HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String searchDateFrom = request.getParameter("searchDateFrom");
		String searchDateTo = request.getParameter("searchDateTo");
		String ware_name = request.getParameter("ware_name");
		String custmr_cd = request.getParameter("custmr_cd");
		String department = request.getParameter("department");
		String project = request.getParameter("project");
		String Add_sign = request.getParameter("Add_sign");
		String imply_zero = request.getParameter("imply_zero");
		String imply_stopCustmr = request.getParameter("imply_stopCustmr");
		
		paramMap.put("searchDateFrom", searchDateFrom);
		paramMap.put("searchDateTo", searchDateTo);
		paramMap.put("ware_name", ware_name);
		paramMap.put("custmr_cd", custmr_cd);
		paramMap.put("department", department);
		paramMap.put("project", project);
		paramMap.put("Add_sign", Add_sign);
		paramMap.put("imply_zero", imply_zero);
		paramMap.put("imply_stopCustmr", imply_stopCustmr);
		
		//logger.debug("paramMap >>>> " + paramMap);
		
		/*try{
			List<Map<String, Object>> gridDataList = purchaseManagementService.getDebtByCustmrList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		} catch(Exception e) {
			
		}*/
		
		return resultMap;
	}
	
	/**
	 * 레포트관리 - 구매관리현황 - 지급현황 - 조회내역
	 * @author 정혜원
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getStateByPaymentList.do", method=RequestMethod.POST)
	public Map<String, Object> getStateByPaymentList(HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String searchDateFrom = request.getParameter("searchDateFrom");
		String searchDateTo = request.getParameter("searchDateTo");
		String ware_name = request.getParameter("ware_name");
		String custmr_cd = request.getParameter("custmr_cd");
		String department = request.getParameter("department");
		String project = request.getParameter("project");
		String Add_sign = request.getParameter("Add_sign");
		
		paramMap.put("searchDateFrom", searchDateFrom);
		paramMap.put("searchDateTo", searchDateTo);
		paramMap.put("ware_name", ware_name);
		paramMap.put("custmr_cd", custmr_cd);
		paramMap.put("department", department);
		paramMap.put("project", project);
		paramMap.put("Add_sign", Add_sign);
		
		//logger.debug("paramMap >>>> " + paramMap);
		
		/*try{
			List<Map<String, Object>> gridDataList = purchaseManagementService.getStateByPaymentList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		} catch(Exception e) {
			
		}*/
		
		return resultMap;
	}
	/**
	 * 구매관리 - 구매관리 - 구매내역
	 * @author 한정훈
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="PurchaseStatus.sis", method=RequestMethod.POST)
	public ModelAndView PurchaseStatus(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "PurchaseStatus");
		return mav;
	}
	/**
	 * 구매관리 - 구매관리 - 구매내역 헤더 조회
	 * @author 한정훈
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getPurchaseHeaderStatus.do", method=RequestMethod.POST)
	public Map<String, Object> getPriceReservationHeaderList(HttpServletRequest request,@RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap >>>> " + paramMap);
		List<Map<String, Object>> getPurchaseStatusHeaderSearch = purchaseManagementService.getPurchaseStatusHeaderSearch(paramMap);
		resultMap.put("gridDataList", getPurchaseStatusHeaderSearch);
		
		return resultMap;
	}
	/**
	 * 구매관리 - 구매관리 - 구매내역 디테일 조회
	 * @author 한정훈
	 * @param request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getPurchaseStatusDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getPurchaseStatusDetailList(HttpServletRequest request,@RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap1 >>>> " + paramMap);
		
		List<Map<String, Object>> getPurchaseStatusDetailSearch = purchaseManagementService.getPurchaseStatusDetailList(paramMap);
		resultMap.put("gridDataList", getPurchaseStatusDetailSearch);
		return resultMap;
	}
	
	/**
	 * 구매관리 - 구매금액조정
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="purchaseAmtAdjustment.sis", method=RequestMethod.POST)
	public ModelAndView purchaseAmtAdjustment(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "purchaseAmtAdjustment");
		return mav;
	}
	
	/**
	  * 구매관리 - 구매금액조정 - 헤더조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getPurchaseAmtAdjustment.do", method=RequestMethod.POST)
	public Map<String, Object> getPurchaseAmtAdjustment(HttpServletRequest request,@RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> getPurchaseAmtAdjustment = purchaseManagementService.getPurchaseAmtAdjustment(paramMap);
		resultMap.put("gridDataList", getPurchaseAmtAdjustment);
		
		return resultMap;
	}
	
	/**
	  * 구매관리 - 구매금액조정 - 디테일조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getPurchaseAmtDetailAdjustment.do", method=RequestMethod.POST)
	public Map<String, Object> getPurchaseAmtDetailAdjustment(HttpServletRequest request,@RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> getPurchaseAmtDetailAdjustment = purchaseManagementService.getPurchaseAmtDetailAdjustment(paramMap);
		resultMap.put("gridDataList", getPurchaseAmtDetailAdjustment);
		return resultMap;
	}

	/**
	  * 구매관리 - 구매금액조정 - 확정금액 저장
	  * @author 최지민
	  * @param request
	  * @exception SQLException
	  * @return Integer
	  */
	@RequestMapping(value="savePurchaseAmtAdjustment.do", method=RequestMethod.POST)
	public Map<String, Object> savePurchaseAmtAdjustment(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		int insertResult = 0;
		int updateResult = 0;
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String MUSER = empSessionDto.getEmp_no();
		String MPROGM = "savePurchaseAmtAdjustment";
		
		paramMap.put("MUSER", MUSER);
		paramMap.put("MPROGM", MPROGM);
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			paramMap.put("CONF_AMT_DETL", dhtmlxParamMapList.get(i).get("CONF_AMT_DETL"));
			paramMap.put("PUR_SLIP_CD", dhtmlxParamMapList.get(i).get("PUR_SLIP_CD"));
			paramMap.put("ORGN_CD", dhtmlxParamMapList.get(i).get("ORGN_CD"));
			paramMap.put("ORGN_DIV_CD", dhtmlxParamMapList.get(i).get("ORGN_DIV_CD"));
			paramMap.put("BCD_CD", dhtmlxParamMapList.get(i).get("BCD_CD"));
			try {
				insertResult = insertResult + purchaseManagementService.savePurchaseAmtAdjustment(paramMap);
				updateResult = updateResult + purchaseManagementService.updatePurchaseAmtAdjustment(paramMap);
			}catch(SQLException e) {
				resultMap = commonUtil.getErrorMap(e);
			}catch(Exception e) {
				resultMap = commonUtil.getErrorMap(e);
			}
		}
		return resultMap;
	}
	/**
	 * 센터/구매 업무 - 매입- 매입현황_업체별조회
	 * @author 한정훈
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="purchaseByCompany.sis", method=RequestMethod.POST)
	public ModelAndView purchaseByCompany(ModelAndView mav) {
		mav.setViewName(DEFAULT_PATH + "/" + "purchaseByCompany");
		return mav;
	}
	/**
	 * 센터/구매 업무 - 매입- 매입현황_업체별조회
	 * @author 한정훈
	 * @param paramMap
	 * @exception SQLException
	 * @exception Exception
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getpurchaseByCompanyHeaderList.do", method=RequestMethod.POST)
	public Map<String, Object> getpurchaseByCompanyHeaderList(@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> gridDataList = purchaseManagementService.getpurchaseByCompanyHeaderList(paramMap);
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
	/**
	 * 센터/구매 업무 - 매입- 매입현황_업체별조회 - 상세
	 * @author 한정훈
	 * @param paramMap
	 * @exception SQLException
	 * @exception Exception
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getpurchaseByCompanyDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getpurchaseByCompanyDetailList(@RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> gridDataList = purchaseManagementService.getpurchaseByCompanyDetailList(paramMap);
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
}
