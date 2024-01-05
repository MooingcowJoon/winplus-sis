package com.samyang.winplus.sis.basic.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("CustomerAcntManagementDao")
public interface CustomerAcntManagementDao {


     /**
	  * getSearchCustomerAcntApprList - 등록된 계좌및승인정보조회
	  * @author 손경락
	  */	
	 List<Map<String, Object>> getSearchCustomerAcntApprList(Map<String, Object> paramMap)  throws SQLException, Exception;	 
	 
	/**
	  * insertMkCustomer - 계좌정보등록
	  * @author 손경락insertStdCustomrAcnt
	  */
	int insertStdCustomrAcnt(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * insertStdCustomrAcntAppr - 계좌 승인정보등록
	  * @author 손경락insertStdCustomrAcnt
	  */
	int insertStdCustomrAcntAppr(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateStdCustomrAcnt - 계좌정보갱신
	  * @author 손경락insertStdCustomrAcnt
	  */
	int updateStdCustomrAcnt(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateStdCustomrAcntAppr - 계좌 승인정보갱신
	  * @author 손경락insertStdCustomrAcnt
	  */
	int updateStdCustomrAcntAppr(Map<String, Object> paramMap) throws SQLException, Exception;
	
	
	/**
	  * deleteStdCustomrAcnt - 계좌정보삭제
	  * @author 손경락insertStdCustomrAcnt
	  */
	int deleteStdCustomrAcnt(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * deleteStdCustomrAcntAppr - 계좌 승인정보삭제
	  * @author 손경락insertStdCustomrAcnt
	  */
	int deleteStdCustomrAcntAppr(Map<String, Object> paramMap) throws SQLException, Exception;
}
