package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.order.dao.OrderCurrentSearchDao;

@Service("OrderCurrentSearchService")
public class OrderCurrentSearchServiceImpl implements OrderCurrentSearchService{
	
	@Autowired
	OrderCurrentSearchDao orderCurrentSearchDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public List<Map<String, Object>> getCurrentSearchOrderList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderCurrentSearchDao.getCurrentSearchOrderList(paramMap);
	}
	
}
