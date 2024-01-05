package com.samyang.winplus.sis.basic.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("CustomerAcntManagementService")
public interface CustomerAcntManagementService {
	
	int insertStdCustomrAcnt(Map<String, Object> paramMap) throws SQLException, Exception;
	int updateStdCustomrAcnt(Map<String, Object> paramMap) throws SQLException, Exception;
	int deleteStdCustomrAcnt(Map<String, Object> paramMap) throws SQLException, Exception;

	int insertStdCustomrAcntAppr(Map<String, Object> paramMap) throws SQLException, Exception;
	int updateStdCustomrAcntAppr(Map<String, Object> paramMap) throws SQLException, Exception;
	int deleteStdCustomrAcntAppr(Map<String, Object> paramMap) throws SQLException, Exception;
	
    List<Map<String, Object>> getSearchCustomerAcntApprList(Map<String, Object> paramMap) throws SQLException, Exception;
	int saveStdCustomrAcntScreenList(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
    
}
