package com.samyang.winplus.sis.market.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("PaymentService")
public interface PaymentService{
	
	/**
	  * 점포업무관리 - 마감관리 - 시제마감입력
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> addTimeDeadlineList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 결제관리 - 외상매출현황조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getTrustSalesStatusList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 결제관리 - 외상매입현황조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getTrustPurchaseStatusList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 결제관리 - 외상매출상세현황조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getTrustSalesStatusDetailList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 결제관리 - 외상매입상세현황조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getTrustPurchaseStatusDetailList(Map<String, String> paramMap)
			throws SQLException, Exception;
}
