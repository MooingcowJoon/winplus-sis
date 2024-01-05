package com.samyang.winplus.sis.pda.service;

import java.sql.SQLException;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.model.LoginDto;
import com.samyang.winplus.common.system.security.util.HaeSha512;
import com.samyang.winplus.common.system.util.CommonException;
import com.samyang.winplus.sis.pda.dao.PDA_Dao;

/**
 * @Class : PDA_ServiceImpl.java
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
public class PDA_ServiceImpl implements PDA_Service {
	
	@Autowired
	PDA_Dao pda_Dao;
	
	@Autowired
	HaeSha512 haeSha512;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	/**
	  * 사용자 로그인 처리
	  * @author 조승현
	  * @param loginDto
	  * @return LoginDto
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public LoginDto execLogin(LoginDto loginDto) throws SQLException, Exception {
		
//		// 사용자 정보 조회
//		LoginDto resultLoginDto = pda_Dao.getLoginDto(loginDto); //프로시저 사용하여 조회
//		
//		// 사용자 정보 조회 결과가 없으면 바로 리턴 
//		if (resultLoginDto == null) {
//			return null;
//		} else { // 사용자 정보 조회 결과 있으면
//			
//			String password_check_result = resultLoginDto.getPassword_check();
//			
//			if(password_check_result.equals("OK")){ // 비밀번호 일치 => 패스워드 오류 횟수 0
//				resultLoginDto.setPassword_error_time(0);
//			}else if(password_check_result.equals("FAIL")){ // 비밀번호 불일치 => 패스워드 오류 횟수 1증가
//				int password_error_time = resultLoginDto.getPassword_error_time();
//				resultLoginDto.setPassword_error_time(password_error_time+1);
//				
//			}else if(password_check_result.equals("")){ // 비밀번호 미확인상태 => 비밀번호 체크
//				
//				// 사용자입력 비밀번호 암호화
//				String input_password = loginDto.getPassword();
//				String enc_input_password = haeSha512.haeEncrypt(input_password);
//				// //logger.debug("enc_input_password : ["+enc_input_password+"]");
//				
//				// 비밀번호 일치 => 패스워드 오류 횟수 0
//				if(enc_input_password.equals(resultLoginDto.getPassword())){
//					resultLoginDto.setPassword_error_time(0);
//					resultLoginDto.setPassword_check("OK");
//				}
//				// 비밀번호 불일치 => 패스워드 오류 횟수 1증가
//				else {
//					int password_error_time = resultLoginDto.getPassword_error_time();
//					resultLoginDto.setPassword_error_time(password_error_time+1);
//					resultLoginDto.setPassword_check("FAIL");
//				}
//			}
//			
//			// 패스워드 오류 횟수 업데이트
//			if(pda_Dao.updateLoginPasswordErrorTime(resultLoginDto) == 0){
//				throw new CommonException("로그인 Execution 오류 발생 [-2]");
//			}
//	
//			/* 로그인 IP 설정 */
//			resultLoginDto.setLogin_atpt_ip(loginDto.getLogin_atpt_ip());
//			//logger.debug(resultLoginDto.toString());
//		}
			
		return null;
	}
	
	@Override
	public int saveLoginAtptLog(LoginDto loginDto) throws SQLException, Exception {
		return pda_Dao.insertLoginAtptLog(loginDto);
	}
	
}
