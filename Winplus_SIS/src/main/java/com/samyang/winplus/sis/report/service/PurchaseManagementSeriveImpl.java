package com.samyang.winplus.sis.report.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.report.dao.PurchaseManagementDao;

@Service("PurchaseManagementService")
public class PurchaseManagementSeriveImpl implements PurchaseManagementService{
	
	@Autowired
	PurchaseManagementDao debtByCustmrDao;

	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public List<Map<String, Object>> getDebtByCustmrList(Map<String, Object> paramMap) throws SQLException, Exception {
		return debtByCustmrDao.getDebtByCustmrList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getPurchaseStatusHeaderSearch(Map<String, String> paramMap) throws SQLException, Exception{
		return debtByCustmrDao.getPurchaseStatusHeaderSearch(paramMap);
	}
	@Override
	public List<Map<String, Object>> getPurchaseStatusDetailList(Map<String, String> paramMap) throws SQLException, Exception{
		return debtByCustmrDao.getPurchaseStatusDetailSearch(paramMap);
	}
	
	/**
	  * 구매관리 - 구매금액조정 - 헤더조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public List<Map<String, Object>> getPurchaseAmtAdjustment(Map<String, String> paramMap) throws SQLException, Exception{
		return debtByCustmrDao.getPurchaseAmtAdjustment(paramMap);
	}
	
	/**
	 * 구매관리 - 구매금액조정 - 디테일조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public List<Map<String, Object>> getPurchaseAmtDetailAdjustment(Map<String, String> paramMap) throws SQLException, Exception{
		return debtByCustmrDao.getPurchaseAmtDetailAdjustment(paramMap);
	}
	
	/**
	  * 구매관리 - 구매금액조정 - 확정금액 저장(디테일)
	  * @author 최지민
	  * @param request
	  * @exception SQLException
	  * @return Integer
	  */
	@Override
	public int savePurchaseAmtAdjustment(Map<String, Object> paramMap) throws SQLException, Exception{
		return debtByCustmrDao.savePurchaseAmtAdjustment(paramMap);
	}
	
	/**
	  * 구매관리 - 구매금액조정 - 확정금액 저장(헤더)
	  * @author 최지민
	  * @param request
	  * @exception SQLException
	  * @return Integer
	  */
	@Override
	public int updatePurchaseAmtAdjustment(Map<String, Object> paramMap) throws SQLException, Exception{
		return debtByCustmrDao.updatePurchaseAmtAdjustment(paramMap);
	}

	/**
	 * 센터/구매 업무 - 매입- 매입현황_업체별조회
	 * @author 한정훈
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> getpurchaseByCompanyHeaderList(Map<String, Object> paramMap) {
		return debtByCustmrDao.getpurchaseByCompanyHeaderList(paramMap);
	}

	/**
	 * 센터/구매 업무 - 매입- 매입현황_업체별조회 - 상세
	 * @author 한정훈
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> getpurchaseByCompanyDetailList(Map<String, Object> paramMap) {
		return debtByCustmrDao.getpurchaseByCompanyDetailList(paramMap);
	}
}
