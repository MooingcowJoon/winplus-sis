package com.samyang.winplus.common.system.error.service;

import java.sql.SQLException;
import java.util.Map;

import org.springframework.stereotype.Service;


@Service("ErrorService")
public interface ErrorService {

	/**
	 * 시스템 에러 로그 기록
	 * @author 조승현
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int insertSystemErrorLog(Map<String, Object> paramMap) throws SQLException, Exception;
	
}
