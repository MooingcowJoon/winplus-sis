package com.samyang.winplus.sis.price.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("LoanManagementDao")
public interface LoanManagementDao {
	
	List<Map<String, Object>> getMemberLoanAllList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	List<Map<String, Object>> getMemberLoanNewList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int saveLoanInfoList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int saveLoanFromPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int uploadLoanEviFile(Map<String, Object> paramMap) throws SQLException, Exception;
	
	Map<String, Object> getCustmrNmList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	Map<String, Object> getMemberNmList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	String getNewLoanCd(Map<String, Object> paramMap) throws SQLException, Exception;

	Map<String, Object> CustmrCdValidationCheck(String CUSTMR_CD);
	
	Map<String, Object> MemberCdValidationCheck(Map<String, Object> paramMap);

	int addLoanDetailObj(Map<String, Object> paramMap);
	
	Map<String, Object> getLoanInfo(Map<String, Object> paramMap);

	List<Map<String, Object>> getLoanEviFileList(Map<String, Object> paramMap);
}
