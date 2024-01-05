package com.samyang.winplus.common.system.error.service;

import java.sql.SQLException;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.error.dao.ErrorDao;

@Service("ErrorService")
public class ErrorServiceImpl implements ErrorService {
	
	@Autowired
	ErrorDao errorDao;
	
	static Logger logger = LoggerFactory.getLogger(ErrorServiceImpl.class);
	
	/**
	 * 시스템 에러 로그 기록
	 * @author 조승현
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int insertSystemErrorLog(Map<String, Object> paramMap) throws SQLException, Exception{
		return errorDao.insertSystemErrorLog(paramMap);
	}

}
