package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("PurchaseCloseService")
public interface PurchaseCloseService {

	/**
	  * getSuprByPurchaseHeaderList - 구매확정 - 업체별구매내역 헤더 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getSuprByPurchaseHeaderList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * getSuprByPurchaseDetailList - 구매확정 - 업체별구매내역 디테일 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getSuprByPurchaseDetailList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * approvalSuprByPurchase - 구매확정 - 업체별구매내역 승인
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String approvalSuprByPurchase(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * cancelSuprByPurchase - 구매확정 - 업체별구매내역 취소
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String cancelSuprByPurchase(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * confirmPurSendErp - 구매확정 - 구매확정 ERP전송
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String confirmPurSendErp(Map<String, Object> paramMap) throws SQLException, Exception;
}
