package com.samyang.winplus.sis.price.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service("LoanManagementService")
public interface LoanManagementService{

	/**
	  * getMemberLoanList - 여신관리 - 여신내역조회
	  * @author 정혜원
	  * @param Map<String, Object>
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> getMemberLoanList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * saveLoanInfoList - 여신관리 - 여신내역 결과 그리드 정보저장
	  * @author 정혜원
	  * @param List<Map<String, Object>>
	  * @return Integer
	  */
	int saveLoanInfoList(List<Map<String, Object>> dhtmlxParamMapList) throws SQLException, Exception;
	
	/**
	  * uploadEviFile - 이미 등록된 여신건 증빙자료 업데이트
	  * @author 정혜원
	  * @param MultipartFile 증빙파일
	  * @param Map<String, Object> 저장정보
	  * @return String
	  */
	String uploadEviFile(MultipartFile EviFile, Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * getCustmrNmList - 거래처코드 그리드 붙여넣기 시 거래처 정보 가져오기
	  * @author 정혜원
	  * @param List<String> paramList
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> getCustmrNmList(List<String> paramList) throws SQLException, Exception;

	/**
	  * getCustmrNmList - 거래처코드 그리드 붙여넣기 시 거래처 정보 가져오기
	  * @author 정혜원
	  * @param List<Map<String, Object>>
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> getMemberNmList(List<Map<String, Object>> paramMapList) throws SQLException, Exception;

	/**
	  * getNewLoanCd - 새로운 거래처코드 가져오기
	  * @author 정혜원
	  * @param Map<String, Object>
	  * @return String
	  */
	String getNewLoanCd(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * CdValidationCheck - 사용가능 여신코드 검사
	  * @author 정혜원
	  * @param Map<String,Object>
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> CdValidationCheck(Map<String, Object> SEARCH_PARAM, List<String> CD_LIST) throws SQLException, Exception;
	
	/**
	  * uploadLoanEviFile - 여신 증빙자료 업로드
	  * @author 정혜원
	  * @param Map<String,Object>
	  * @return int
	  */
	int uploadLoanEviFile(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * saveLoanFromPopup - 여신관리 - 여신추가팝업 정보저장
	  * @author 정혜원
	  * @param Map<String, Object>
	  * @return Integer
	  */
	int saveLoanFromPopup(Map<String, Object> paramMap) throws SQLException, Exception;

	int addLoanDetailObj(List<Map<String, Object>> paramMapList);

	/**
	  * getLaonInfo - 여신관리 - 선택한 여신상세정보 불러오기
	  * @author 정혜원
	  * @param Map<String, Object>
	  * @return Map<String, Object>
	  */
	Map<String, Object> getLaonInfo(Map<String, Object> paramMap);

	/**
	  * getLoanEviFileList - 여신관리 - 선택한 여신코드의 증빙자료 리스트 불러오기
	  * @author 정혜원
	  * @param Map<String, Object>
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> getLoanEviFileList(Map<String, Object> paramMap);

	/**
	  * saveLoanInfoMap - 여신관리 - 여신상세내역 수정 저장
	  * @author 정혜원
	  * @param Map<String, Object>
	  * @return Integer
	  */
	int saveLoanInfoMap(Map<String, Object> paramMap) throws SQLException, Exception;
}
