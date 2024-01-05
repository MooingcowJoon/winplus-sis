package com.samyang.winplus.sis.price.service;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.samyang.winplus.sis.price.dao.LoanManagementDao;

import ch.qos.logback.classic.Logger;

@Service("LoanManagementService")
public class LoanManagementServiceImpl implements LoanManagementService{
	
	private final String saveDir = "\\\\192.168.210.17\\sis_file\\loan_evi_file";
	
	@Autowired
	LoanManagementDao loanManagementDao;
	
	
	/**
	  * getMemberLoanList - 여신관리 - 여신내역조회
	  * @author 정혜원
	  * @param Map<String, Object>
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> getMemberLoanList(Map<String, Object> paramMap) throws SQLException, Exception{
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		String show_condition = paramMap.get("SHOW_CONDITION").toString();
		
		if(show_condition.equals("ALL")) {
			resultList = loanManagementDao.getMemberLoanAllList(paramMap);
		} else if(show_condition.equals("NEW")) {
			resultList = loanManagementDao.getMemberLoanNewList(paramMap);
		}
		return resultList;
	}
	
	/**
	  * saveLoanInfoList - 여신관리 - 여신내역 결과 그리드 정보저장
	  * @author 정혜원
	  * @param List<Map<String, Object>>
	  * @return Integer
	  */
	@Override
	public int saveLoanInfoList(List<Map<String, Object>> dhtmlxParamMapList) throws SQLException, Exception{
		int resultCnt = 0;
		
		for(Map<String, Object> paramMap : dhtmlxParamMapList) {
			resultCnt += loanManagementDao.saveLoanInfoList(paramMap);
		}
		return resultCnt;
	}
	
	/**
	  * saveLoanFromPopup - 여신관리 - 여신추가팝업 정보저장
	  * @author 정혜원
	  * @param Map<String, Object>
	  * @return Integer
	  */
	@Override
	public int saveLoanFromPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return loanManagementDao.saveLoanFromPopup(paramMap);
	}
	
	/**
	  * uploadEviFile - 이미 등록된 여신건 증빙자료 업데이트
	  * @author 정혜원
	  * @param MultipartFile 증빙파일
	  * @param Map<String, Object> 저장정보
	  * @return String
	  */
	@Override
	public String uploadEviFile(MultipartFile EviFile, Map<String, Object> paramMap) throws SQLException, Exception {
		
		//System.out.println("VerFile >>> " + EviFile);
		
		//원본파일 이름
		String orgName = EviFile.getOriginalFilename();
		//System.out.println("orgName >>> " + orgName);
		
		//확장자명
		String exName = EviFile.getOriginalFilename().substring(EviFile.getOriginalFilename().lastIndexOf("."));
		//System.out.println("exName >>> " + exName);
		
		//확장자명을 제거한 파일명
		int idx = orgName.lastIndexOf(".");
		String OnlyFileName = orgName.substring(0, idx);
		
		
		String saveFilepath = "sis_file\\loan_evi_file\\" + orgName;
		
		
		paramMap.put("FILE_NM", orgName);
		paramMap.put("FILE_PATH", saveFilepath);
		
		
		try {
			byte[] fileData = EviFile.getBytes();
			File EvidenceFile = new File(saveDir);
			
			if(!EvidenceFile.exists()) {
				EvidenceFile.mkdirs();
			}
			
			paramMap.put("FILE_SIZE", fileData.length);
			
			OutputStream out = new FileOutputStream(saveDir+"\\"+orgName);
			BufferedOutputStream bout = new BufferedOutputStream(out);
			bout.write(fileData);
			
			if(bout != null) {
				bout.close();
			}
			
			int InsertNum = loanManagementDao.uploadLoanEviFile(paramMap);
			//System.out.println("InsertNum >>> " + InsertNum);
			
			return "upload Success";
			
		} catch(IOException e) {
			e.printStackTrace();
			return "upload Fail";
		}
	}
	
	/**
	  * getCustmrNmList - 거래처코드 그리드 붙여넣기 시 거래처 정보 가져오기
	  * @author 정혜원
	  * @param List<String> paramList
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> getCustmrNmList(List<String> paramList) throws SQLException, Exception {
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		Map<String, Object> paramMap = null;
		for(String CUSTMR_CD : paramList) {
			paramMap = new HashMap<String, Object>();
			paramMap.put("CUSTMR_CD", CUSTMR_CD);
			resultList.add(loanManagementDao.getCustmrNmList(paramMap));
		}
		
		return resultList;
	}
	
	/**
	  * getCustmrNmList - 거래처코드 그리드 붙여넣기 시 거래처 정보 가져오기
	  * @author 정혜원
	  * @param List<Map<String, Object>>
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> getMemberNmList(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		Map<String, Object> paramMap = null;
		for(Map<String, Object> paramData : paramMapList) {
			paramMap = new HashMap<String, Object>();
			paramMap = loanManagementDao.getMemberNmList(paramData);
			resultList.add(paramMap);
		}
		return resultList;
	}
	
	/**
	  * getNewLoanCd - 새로운 여신코드 가져오기
	  * @author 정혜원
	  * @param Map<String, Object>
	  * @return String
	  */
	@Override
	public String getNewLoanCd(Map<String, Object> paramMap) throws SQLException, Exception {
		//System.out.println("getNewLoanCd paramMap >>> " + paramMap);
		return loanManagementDao.getNewLoanCd(paramMap);
	}
	
	/**
	  * CdValidationCheck - 사용가능 여신코드 검사
	  * @author 정혜원
	  * @param Map<String,Object>
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> CdValidationCheck(Map<String,Object> SEARCH_PARAM, List<String> CD_LIST) throws SQLException, Exception {
		List<Map<String, Object>> resultMessageList = new ArrayList<Map<String, Object>>();
		Map<String, Object> resultMessage = new HashMap<String, Object>();
		Map<String, Object> paramMap = null;
		
		if(SEARCH_PARAM.get("SEARCH_TYPE").equals("C")) {
			for(String CUSTMR_CD : CD_LIST) {
				resultMessage = loanManagementDao.CustmrCdValidationCheck(CUSTMR_CD);
				resultMessageList.add(resultMessage);
			}
		}else {
			for(String CUSTMR_CD : CD_LIST) {
				paramMap = new HashMap<String, Object>();
				paramMap.put("CUSTMR_CD", CUSTMR_CD);
				resultMessage = loanManagementDao.MemberCdValidationCheck(paramMap);
				resultMessageList.add(resultMessage);
			}
		}
		
		//System.out.println("resultMessageList >>> " + resultMessageList);
		return resultMessageList;
	}
	
	/**
	  * uploadLoanEviFile - 여신 증빙자료 업로드
	  * @author 정혜원
	  * @param Map<String,Object>
	  * @return int
	  */
	@Override
	public int uploadLoanEviFile(Map<String, Object> paramMap) throws SQLException, Exception {
		return loanManagementDao.uploadLoanEviFile(paramMap);
	}
	
	@Override
	public int addLoanDetailObj(List<Map<String, Object>> paramMapList) {
		int resultCnt = 0;
		for(Map<String, Object> paramMap : paramMapList) {
			resultCnt += loanManagementDao.addLoanDetailObj(paramMap);
		}
		return resultCnt;
	}
	
	/**
	  * getLaonInfo - 선택한 여신 상세정보 불러오기
	  * @author 정혜원
	  * @param Map<String,Object>
	  * @return Map<String, Object>
	  */
	@Override
	public Map<String, Object> getLaonInfo(Map<String, Object> paramMap) {
		return loanManagementDao.getLoanInfo(paramMap);
	}
	
	/**
	  * getLaonInfo - 선택한 여신 상세정보 불러오기
	  * @author 정혜원
	  * @param Map<String,Object>
	  * @return Map<String, Object>
	  */
	@Override
	public List<Map<String, Object>> getLoanEviFileList(Map<String, Object> paramMap){
		return loanManagementDao.getLoanEviFileList(paramMap);
	}
	
	/**
	  * saveLoanInfoMap - 여신관리 - 여신상세내역 수정 저장
	  * @author 정혜원
	  * @param Map<String, Object>
	  * @return Integer
	  */
	@Override
	public int saveLoanInfoMap(Map<String, Object> paramMap) throws SQLException, Exception{
		return loanManagementDao.saveLoanInfoList(paramMap);
	}
	
}
