package com.samyang.winplus.sis.partnerportal.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.partnerportal.dao.LoanChgHisSearchDao;

@Service("LoanChgHisSearchService")
public class LoanChgHisSearchServiceImpl implements LoanChgHisSearchService{
	
	@Autowired
	LoanChgHisSearchDao loanChgHisSearchDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public List<Map<String, Object>> getloanChgHisSearchList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return loanChgHisSearchDao.getloanChgHisSearchList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getSaleCentSearchList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return loanChgHisSearchDao.getSaleCentSearchList(paramMap);
	}

}
