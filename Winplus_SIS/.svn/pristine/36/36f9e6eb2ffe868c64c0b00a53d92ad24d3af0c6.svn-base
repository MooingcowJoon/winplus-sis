package com.samyang.winplus.sis.basic.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.basic.dao.CustomerIODao;
import com.samyang.winplus.sis.basic.service.CustomerIOService;

@Service("CustomerIOService")
public class CustomerIOServiceImpl implements CustomerIOService {
	@Autowired
	CustomerIODao customerIODao;
	
	@Override
	public Map<String, Object> getCustomer(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerIODao.getCustomer(paramMap);
	}

	@Override
	public int getCorpNoCount(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerIODao.getCorpNoCount(paramMap);
	}
	
	@Override
	public Map<String,Object> insertCustomer(Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = customerIODao.insertCustomer(paramMap);
		return customerIODao.getCustomer(resultMap); 
	}
	@Override
	public Map<String,Object> updateCustomer(Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = customerIODao.updateCustomer(paramMap);
		return customerIODao.getCustomer(resultMap); 
	}
//	@Override
//	public void deleteCustomer(Map<String, Object> paramMap) throws SQLException, Exception {
//		customerIODao.deleteCustomer(paramMap);
//	}

	@Override
	public void updateCustomerFileGrupNo(Map<String, String> paramMap) {
		customerIODao.updateCustomerFileGrupNo(paramMap);
	}
	/**
	 * 거래처정보 - 계좌정보 수정
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */	
	@Override
	public int saveAcntInfo(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerIODao.saveAcntInfo(paramMap);
	}
}
