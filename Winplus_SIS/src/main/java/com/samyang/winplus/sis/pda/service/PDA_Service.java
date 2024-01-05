package com.samyang.winplus.sis.pda.service;

import java.sql.SQLException;

import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.model.LoginDto;

/**
 * @Class : PDA_Service.java
 * @Description : 
 * @Modification Information  
 * 
 *   수정일          수정자                내용
 * -----------     ----------      ----------------------
 * 2019. 7. 8.      조승현              최초생성
 * 
 * @author 조승현
 * @since 2019. 7. 8.
 * @version 1.0
 */
@Service("PDA_Service")
public interface PDA_Service {

	int saveLoginAtptLog(LoginDto loginDto) throws SQLException, Exception;
	
	LoginDto execLogin(LoginDto loginDto) throws SQLException, Exception;

}
