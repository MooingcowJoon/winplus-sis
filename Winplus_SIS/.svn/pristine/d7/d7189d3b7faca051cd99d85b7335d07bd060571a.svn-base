package com.samyang.winplus.sis.basic.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("CustomerIODao")
public interface CustomerIODao {

	/* 거래처등록화면에서의 조회 */
	Map<String, Object> getCustomer(Map<String, Object> paramMap) throws SQLException, Exception;

	/* 동일한 산업자번호가 존재하는지 체크 */
	int getCorpNoCount(Map<String, Object> paramMap) throws SQLException, Exception;

	/* 거래처등록 */
	Map<String,Object> insertCustomer(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/* 거래처갱신 */
	Map<String,Object> updateCustomer(Map<String, Object> paramMap) throws SQLException, Exception;

	/* 거래처 파일 그룹 번호 업데이트 */
	void updateCustomerFileGrupNo(Map<String, String> paramMap);
	
	/**
	 * 거래처정보 - 계좌정보 수정
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */	
	int saveAcntInfo(Map<String, Object> paramMap);

//	 /* 거래처삭제 */
//	 int deleteCustomer(Map<String, Object> paramMap) throws SQLException, Exception;	 
	 
}
