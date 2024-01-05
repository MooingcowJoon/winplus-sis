package com.samyang.winplus.sis.pda.dao;

import java.sql.SQLException;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.samyang.winplus.common.system.model.LoginDto;

@Repository("PDA_Dao")
public interface PDA_Dao {
	
	public LoginDto getLoginDto(LoginDto loginDao) throws SQLException, Exception;

	public int insertLoginAtptLog(LoginDto resultLoginDto) throws SQLException, Exception;
	
	public int updateLoginPasswordErrorTime(LoginDto resultLoginDto) throws SQLException, Exception;

	public String downloadMaster(Map<String, Object> paramMap);
}
