package com.samyang.winplus.common.terminal.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("TerminalManagementService")
public interface TerminalManagementService {
	
	/**
	  * 시스템관리 - 단말기관리- 직영점단말기관리 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getTerminalList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 시스템관리 - 단말기관리- 직영점단말기관리 저장 -add
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int addTerminalList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 시스템관리 - 단말기관리- 직영점단말기관리조회 저장 -delete 
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int deleteTerminalList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 시스템관리 - 단말기관리- 직영점단말기관리 저장 -update
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int updateTerminalList(Map<String, Object> paramMap) throws SQLException, Exception;

}
