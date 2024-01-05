package com.samyang.winplus.sis.sales.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.sales.dao.SalesManagementCenterDao;

@Service("SalesManagementCenterService")
public class SalesManagementCenterServiceImpl implements SalesManagementCenterService{

	@Autowired
	SalesManagementCenterDao salesManagementCenterDao;
	
	@Override
	public List<Map<String, Object>> getSuprBySupplyHeaderList(Map<String, Object> paramMap) 
			throws SQLException, Exception{
		return salesManagementCenterDao.getSuprBySupplyHeaderList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getSuprBySupplyDetailList(Map<String, Object> paramMap) 
			throws SQLException, Exception {
		return salesManagementCenterDao.getSuprBySupplyDetailList(paramMap);
	}
	
	@Override
	public int saveSuprBySupplyDetailInfo(Map<String, Object> paramMap) 
			throws SQLException, Exception{
		return salesManagementCenterDao.saveSuprBySupplyDetailInfo(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getSuprBySupplyConfirmHeaderList(Map<String, Object> paramMap) 
			throws SQLException, Exception{
		return salesManagementCenterDao.getSuprBySupplyConfirmHeaderList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getSuprBySupplyConfirmDetailList(Map<String, Object> paramMap) 
			throws SQLException, Exception{
		return salesManagementCenterDao.getSuprBySupplyConfirmDetailList(paramMap);
	}
	
	@Override
	public int approvalSuprBySupplyConfirm(Map<String, Object> paramMap) 
			throws SQLException, Exception{
		return salesManagementCenterDao.approvalSuprBySupplyConfirm(paramMap);
	}
	
	@Override
	public int cancleSuprBySupplyConfirm(Map<String, Object> paramMap) 
			throws SQLException, Exception{
		return salesManagementCenterDao.cancleSuprBySupplyConfirm(paramMap);
	}
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확정 - 확정금액 저장(디테일)
	  * @author 최지민
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveSupplyConfirm(Map<String, Object> paramMap) 
			throws SQLException, Exception{
		return salesManagementCenterDao.saveSupplyConfirm(paramMap);
	}
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확정 - 확정금액 저장(헤더)
	  * @author 최지민
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int updateSupplyConfirm(Map<String, Object> paramMap) 
			throws SQLException, Exception{
		return salesManagementCenterDao.updateSupplyConfirm(paramMap);
	}
}
