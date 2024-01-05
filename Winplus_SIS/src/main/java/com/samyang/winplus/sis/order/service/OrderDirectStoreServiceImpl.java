package com.samyang.winplus.sis.order.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.order.dao.OrderDirectStoreDao;

@Service("OrderDirectStoreService")
public class OrderDirectStoreServiceImpl implements OrderDirectStoreService {
	
	@Autowired
	OrderDirectStoreDao orderDirectStoreDao;
/*
	*//**
	  * getGoodsInformationList - 상품정보관리 - 상품정보 목록 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  *//*
	@Override
	public List<Map<String, Object>> getGoodsInformationList(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.getGoodsInformationList(paramMap);
	}*/
}
