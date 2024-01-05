package com.samyang.winplus.sis.order.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface PurchaseCloseDao {

	/**
	  * getSuprByPurchaseHeaderList - 구매확정 - 업체별구매내역 헤더 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getSuprByPurchaseHeaderList(Map<String, Object> paramMap);

	/**
	  * getSuprByPurchaseDetailList - 구매확정 - 업체별구매내역 디테일 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getSuprByPurchaseDetailList(Map<String, Object> paramMap);
	
	/**
	 * approvalSuprByPurchase - 구매확정 - 업체별구매내역 승인
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 */
	String approvalSuprByPurchase(Map<String, Object> paramMap);
	
	/**
	 * cancelSuprByPurchase - 구매확정 - 업체별구매내역 취소
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 */
	String cancelSuprByPurchase(Map<String, Object> paramMap);
	
	/**
	 * confirmPurSendErp - 구매확정 - 구매확정 ERP전송
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 */
	String confirmPurSendErp(Map<String, Object> paramMap);
}