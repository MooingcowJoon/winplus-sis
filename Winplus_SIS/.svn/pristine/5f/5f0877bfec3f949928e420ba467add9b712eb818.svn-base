package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.order.dao.PurchaseCloseDao;

@Service("PurchaseCloseService")
public class PurchaseCloseServiceImpl implements PurchaseCloseService {
	
	@Autowired
	PurchaseCloseDao purchaseCloseDao;

	/**
	  * getSuprByPurchaseHeaderList - 구매확정 - 업체별구매내역 헤더 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getSuprByPurchaseHeaderList(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return purchaseCloseDao.getSuprByPurchaseHeaderList(paramMap);
	}

	/**
	  * getSuprByPurchaseDetailList - 구매확정 - 업체별구매내역 디테일 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getSuprByPurchaseDetailList(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return purchaseCloseDao.getSuprByPurchaseDetailList(paramMap);
	}
	
	/**
	 * approvalSuprByPurchase - 구매확정 - 업체별구매내역 승인
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public String approvalSuprByPurchase(Map<String, Object> paramMap) throws SQLException, Exception {
		return purchaseCloseDao.approvalSuprByPurchase(paramMap);
	}
	
	/**
	 * cancelSuprByPurchase - 구매확정 - 업체별구매내역 취소
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public String cancelSuprByPurchase(Map<String, Object> paramMap) throws SQLException, Exception {
		return purchaseCloseDao.cancelSuprByPurchase(paramMap);
	}
	
	/**
	 * confirmPurSendErp - 구매확정 - 구매확정 ERP전송
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public String confirmPurSendErp(Map<String, Object> paramMap) throws SQLException, Exception {
		return purchaseCloseDao.confirmPurSendErp(paramMap);
	}
}
