package com.samyang.winplus.sis.price.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.popup.service.PopupService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.config.ServerVariable;
import com.samyang.winplus.common.system.file.service.FileService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.sis.price.service.LoanManagementService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RequestMapping("/sis/price")
@RestController
public class LoanManagementController extends BaseController{
	
	private final static String DEFAULT_PATH = "sis/price";
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	LoanManagementService loanManagementService;
	
	@Autowired
	ServerVariable serverVariable;
	
	@Autowired
	PopupService popupService;
	
	@Autowired
	FileService fileService;
	
	/**
	  * LoanManagement - 여신관리
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "LoanManagement.sis", method = RequestMethod.POST)
	public ModelAndView LoanManagement(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "loanManagement");
		return mav;
	}
	
	/**
	  * 여신관리 - 데이터조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getMemberLoanList.do", method = RequestMethod.POST)
	public Map<String, Object> getMemberLoanList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		//logger.debug("getMemberLoanList paramMap >>>> " + paramMap);
		
		try {
			gridDataList = loanManagementService.getMemberLoanList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		
		return resultMap;
	}
	
	/**
	  * saveLoanInfoList - 여신정보 저장
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "saveLoanInfoList.do", method = RequestMethod.POST)
	public Map<String, Object> saveLoanInfoList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = new ArrayList<Map<String, Object>>();
		
		if(!paramMap.isEmpty() || paramMap != null) {
			//logger.debug("saveLoanInfoList paramMap >>> " + paramMap);
		}
		int ResultCnt = 0;
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request); 
		String EMP_NO = empSessionDto.getEmp_no();
		
		dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		
		if(dhtmlxParamMapList.isEmpty() || dhtmlxParamMapList.size() == 0 || dhtmlxParamMapList == null) {
			try {
				ResultCnt = loanManagementService.saveLoanInfoMap(paramMap);
				resultMap.put("ResultCnt", ResultCnt);
			}catch(SQLException e) {
				resultMap = commonUtil.getErrorMap(e);
			}catch(Exception e) {
				resultMap = commonUtil.getErrorMap(e);
			}
		} else {
			for(Map<String, Object> dataParamMap : dhtmlxParamMapList) {
				dataParamMap.put("EMP_NO", EMP_NO);
			}
			
			try {
				ResultCnt = loanManagementService.saveLoanInfoList(dhtmlxParamMapList);
				resultMap.put("ResultCnt", ResultCnt);
			}catch(SQLException e) {
				resultMap = commonUtil.getErrorMap(e);
			}catch(Exception e) {
				resultMap = commonUtil.getErrorMap(e);
			}
		}
		
		return resultMap;
	}
	
	/**
	  * saveLoanFromPopup - 신규 여신등록(팝업) 저장
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "saveLoanFromPopup.do", method = RequestMethod.POST)
	public Map<String, Object> saveLoanFromPopup(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("saveLoanFromPopup paramMap >>> " + paramMap);
		int ResultCnt = 0;
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request); 
		String EMP_NO = empSessionDto.getEmp_no();
		paramMap.put("EMP_NO", EMP_NO);
		String new_loan_cd = "";
		
		try {
			new_loan_cd = loanManagementService.getNewLoanCd(paramMap);
			paramMap.put("NEW_LOAN_CD", new_loan_cd);
			ResultCnt = loanManagementService.saveLoanFromPopup(paramMap);
			resultMap.put("ResultCnt", ResultCnt);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * uploadEviFile - 여신관리 - 해당여신코드 증빙자료 업로드
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "uploadEviFile.do", method = RequestMethod.POST)
	public Map<String, Object> getTradeStatementList(HttpServletRequest request, @RequestParam("EviFile") MultipartFile EviFile) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String resultValue = "";
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request); 
		String EMP_NO = empSessionDto.getEmp_no();
		String LOAN_CD = request.getParameter("LOAN_CD");
		String LOAN_SEQ = request.getParameter("LOAN_SEQ");
		
		paramMap.put("LOAN_CD", LOAN_CD);
		paramMap.put("LOAN_SEQ", LOAN_SEQ);
		paramMap.put("EMP_NO", EMP_NO);
		
		try {
			resultValue = loanManagementService.uploadEviFile(EviFile, paramMap);
			resultMap.put("resultValue", resultValue);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		
		return resultMap;
	}
	
	/**
	  * getCustmrNmList - 거래처이름 불러오기
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getCustmrNmList.do", method = RequestMethod.POST)
	public Map<String, Object> getTradeStatementList(HttpServletRequest request, @RequestParam(value="CUSTMR_CD_LIST") List<String> CUSTMR_CD_LIST) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		try {
			gridDataList = loanManagementService.getCustmrNmList(CUSTMR_CD_LIST);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * getMemberNmList - 여신관리 회원이름 불러오기
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getMemberNmList.do", method = RequestMethod.POST)
	public Map<String, Object> getMemberNmList(HttpServletRequest request, @RequestParam(value="MEMBER_NO_LIST") List<String> MEMBER_NO_LIST, @RequestParam(value="ORGN_CD") String ORGN_CD) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = null;
		List<Map<String, Object>> paramMapList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> resultMapList = new ArrayList<Map<String, Object>>();
		
		for(int i = 0 ; i < MEMBER_NO_LIST.size() ; i++){
			paramMap = new HashMap<String, Object>();
			paramMap.put("MEM_NO", MEMBER_NO_LIST.get(i));
			paramMap.put("ORGN_CD", ORGN_CD);
			paramMapList.add(paramMap);
		}
		
		try{
			resultMapList = loanManagementService.getMemberNmList(paramMapList);
			resultMap.put("gridDataList", resultMapList);
		} catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	
	/**
	  * getNewLoanCd - 신규여신코드 생성
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getNewLoanCd.do", method = RequestMethod.POST)
	public Map<String, Object> getNewLoanCd(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String NEW_LOAN_CD = "";
		//logger.debug("getNewLoanCd paramMap >>> "+paramMap);
		
		try {
			NEW_LOAN_CD = loanManagementService.getNewLoanCd(paramMap);
			//logger.debug("NEW_LOAN_CD >>>> " + NEW_LOAN_CD);
			resultMap.put("NEW_LOAN_CD", NEW_LOAN_CD);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * CdValidationCheck - 여신관리 - 고객코드 유효성체크
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "CdValidationCheck.do", method = RequestMethod.POST)
	public Map<String, Object> CdValidationCheck(HttpServletRequest request, @RequestParam(value="CD_LIST") List<String> CD_LIST, @RequestParam(value="SEARCH_TYPE") String SEARCH_TYPE) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		Map<String, Object> SEARCH_PARAM = new HashMap<String, Object>();
		
		SEARCH_PARAM.put("SEARCH_TYPE", SEARCH_TYPE);
		//logger.debug("CD_LIST >>> " + CD_LIST);
		
		try {
			gridDataList = loanManagementService.CdValidationCheck(SEARCH_PARAM, CD_LIST);
			//logger.debug("gridDataList >>> " + gridDataList);
			for(Map<String, Object> MessageMap : gridDataList) {
				if(MessageMap.get("resultMessage").equals("Unavailable")) {
					MessageMap.put("resultMessage", "사용불가");
				}
			}
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
		  * openAddNewLoanPopup - 신규여신(거래처)추가 팝업
		  * @author 정혜원
		  * @param request
		  * @return ModelAndView
		  */
	@RequestMapping(value = "openAddNewLoanPopup.sis", method = RequestMethod.POST)
	public ModelAndView TellOrder(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("paramMap", paramMap);
		mav.setViewName(DEFAULT_PATH + "/" + "openAddNewLoanPopup");
		return mav;
	}
	
	/**
	  * uploadLoanEvidence - 선택된 고객의 증빙자료 추가
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "uploadLoanEvidence.do", method = RequestMethod.POST)
	public Map<String, Object> getTradeStatementList(MultipartRequest request, HttpServletRequest hsRequest,@RequestParam Map<String, Object> paramMap) throws IOException{
		Map<String, Object> resultMap = new HashMap<String,Object>();
		Map<String, String> uploadMap = new HashMap<String, String>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(hsRequest);
		String EMP_NO = empSessionDto.getEmp_no();
		
		//logger.debug("uploadLoanEvidence paramMap >>> " + paramMap);
		
		SimpleDateFormat formatdate = new SimpleDateFormat("yyyyMMdd");
		Date date = new Date();
		String TodayDate = formatdate.format(date);
		
		String year = TodayDate.substring(0,4);
		String month = TodayDate.substring(4, 6);
		String day = TodayDate.substring(6, 8);
		String file_path = year + "\\" + month + "\\" + day;
		
		paramMap.put("EMP_NO", EMP_NO);
		paramMap.put("FILE_NM", paramMap.get("EviFileName"));
		paramMap.put("FILE_PATH", "sis_file\\attachFiles\\loan\\"+file_path);
		
		uploadMap.put("DIRECTORY_KEY", paramMap.get("DIRECTORY_KEY").toString());
		
		Map<String, String> UPLOAD_ATTACH_FILE_SAVE_ROOT_DIRECTORY_LIST = serverVariable.getUploadAttachFileSaveRootDirectoryList();
		uploadMap.put("DIRECTORY_VALUE", UPLOAD_ATTACH_FILE_SAVE_ROOT_DIRECTORY_LIST.get(paramMap.get("DIRECTORY_KEY")));
		
		MultiValueMap<String, MultipartFile> fileMap = request.getMultiFileMap();
		List<Map<String, Object>> attachFileList = fileService.uploadAttachFile(uploadMap, fileMap);
		
		try {
			int ResultNum = loanManagementService.uploadLoanEviFile(paramMap);
			resultMap.put("ResultNum", ResultNum);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		//logger.debug("attachFileList >> " + attachFileList);
		
		return resultMap;
	}

	/**
	  * addLoanDetailObj - 기존여신에 고객추가(거래처, 회원)
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "addLoanDetailObj.do", method = RequestMethod.POST)
	public Map<String, Object> addLoanDetailObj(HttpServletRequest request, @RequestParam(value="cd_list") List<String> cd_list, @RequestParam(value="loan_list") List<String> loan_list) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> paramMapList = new ArrayList<Map<String, Object>>();
		Map<String, Object> paramMap = null;
		
		int resultCnt = 0;
		
		for(int i = 0 ; i < cd_list.size() ; i++) {
			paramMap = new HashMap<String, Object>();
			paramMap.put("OBJ_CD", cd_list.get(i));
			paramMap.put("LOAN_CD", loan_list.get(i));
			paramMapList.add(paramMap);
		}
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String EMP_NO = empSessionDto.getEmp_no();
		
		for(Map<String, Object> empParam : paramMapList) {
			empParam.put("EMP_NO", EMP_NO);
		}
		
		resultCnt = loanManagementService.addLoanDetailObj(paramMapList);
		resultMap.put("resultCnt", resultCnt);
		
		return resultMap;
	}
	
	/**
	  * getLoanInfo - 이미등록된 여신코드 상세정보 보기 팝업
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getLoanInfo.do", method = RequestMethod.POST)
	public Map<String, Object> getTradeStatementList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> tableDataMap = new HashMap<String, Object>();
		//logger.debug("paramMap >>> " + paramMap);
		
		tableDataMap = loanManagementService.getLaonInfo(paramMap);
		resultMap.put("dataMap", tableDataMap);
		return resultMap;
	}
	
	/**
	  * getLoanEviFileList - 여신증빙자료 리스트 불러오기
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getLoanEviFileList.do", method = RequestMethod.POST)
	public Map<String, Object> getLoanEviFileList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("FILE_GRUP_NO paramMap >>> " + paramMap);
		
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		gridDataList = loanManagementService.getLoanEviFileList(paramMap);
		
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
	
	/**
	  * loanMemDetailInfo - 여신등록된 회원 정보 가져오기
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "loanMemDetailInfo.do", method = RequestMethod.POST)
	public Map<String, Object> loanMemDetailInfo(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if(paramMap.get("APPLY_TYPE").equals("C")) {
			try {
				resultMap.put("detailInfo", popupService.addMemberInformation(paramMap));
			} catch (SQLException e) {
				resultMap = commonUtil.getErrorMap(e);
			} catch (Exception e) {
				resultMap = commonUtil.getErrorMap(e);
			}
		} else if(paramMap.get("APPLY_TYPE").equals("M")) {
			
		}
		
		
		return resultMap;
	}
}
