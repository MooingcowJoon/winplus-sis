package com.samyang.winplus.sis.market.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.market.dao.PaymentDao;

@Service("PaymentService")
public class PaymentServiceImpl implements PaymentService{

	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private PaymentDao paymentDao;
	
	/**
	  * 점포업무관리 - 마감관리 - 시제마감입력
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> addTimeDeadlineList(Map<String, Object > paramMap) throws SQLException, Exception {
		return paymentDao.addTimeDeadlineList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getTrustSalesStatusList(Map<String, Object > paramMap) throws SQLException, Exception {
		return paymentDao.getTrustSalesStatusList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getTrustSalesStatusDetailList(Map<String, Object> paramMap)
			throws SQLException, Exception {
		// TODO Auto-generated method stub
		return paymentDao.getTrustSalesStatusDetailList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getTrustPurchaseStatusList(Map<String, Object > paramMap) throws SQLException, Exception {
		return paymentDao.getTrustPurchaseStatusList(paramMap);
	}

	@Override
	public List<Map<String, Object>> getTrustPurchaseStatusDetailList(Map<String, String> paramMap)
			throws SQLException, Exception {
		// TODO Auto-generated method stub
		return paymentDao.getTrustPurchaseStatusDetailList(paramMap);
	}
}
