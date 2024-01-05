package com.samyang.winplus.common.terminal.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.terminal.dao.TerminalManagementDao;

@Service("TerminalManagementService")
public class TerminalManagementServiceImpl implements TerminalManagementService {

	@Autowired
	TerminalManagementDao terminalManagementDao;
	
	/**
	  * 시스템관리 - 단말기관리- 직영점단말기관리 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getTerminalList(Map<String, Object> paramMap) throws SQLException, Exception {
		return terminalManagementDao.getTerminalList(paramMap);
	}
	
	/**
	  * 시스템관리 - 단말기관리- 직영점단말기관리 저장 -add
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int addTerminalList(Map<String, Object> paramMap) throws SQLException, Exception {
		return terminalManagementDao.addTerminalList(paramMap);
	}
	
	/**
	  * 시스템관리 - 단말기관리- 직영점단말기관리조회 저장 -delete 
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int deleteTerminalList(Map<String, Object> paramMap) throws SQLException, Exception {
		return terminalManagementDao.deleteTerminalList(paramMap);
	}
	
	/**
	  * 시스템관리 - 단말기관리- 직영점단말기관리 저장 -update
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int updateTerminalList(Map<String, Object> paramMap) throws SQLException, Exception {
		return terminalManagementDao.updateTerminalList(paramMap);
	}
}
