package com.samyang.winplus.sis.market.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.market.dao.EmptyBottleDao;

@Service("EmptyBottleService")
public class EmptyBottleServiceImpl implements EmptyBottleService{

	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private EmptyBottleDao emptyBottleDao;

	@Override
	public List<Map<String, Object>> getEBRHList(Map<String, Object> paramMap) {
		return emptyBottleDao.getEBRHList(paramMap);
	}

	@Override
	public List<Map<String, Object>> getEBRDList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return emptyBottleDao.getEBRDList(paramMap);
	}
	
}
