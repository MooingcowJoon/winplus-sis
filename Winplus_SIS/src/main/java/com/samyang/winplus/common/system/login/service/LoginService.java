package com.samyang.winplus.common.system.login.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.model.LoginDto;

/** 
 * 로그인 서비스  
 * @since 2016.11.07
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.11.07 / 김종훈 / 신규 생성
 *********************************************
 */
@Service("loginService")
public interface LoginService {

	/**
	  * saveLoginAtptLog - 로그인 시도 로그 저장
	  * @author 김종훈
	  * @param loginDto
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveLoginTryLog(LoginDto loginDto) throws SQLException, Exception;
	
	/**
	  * loginTry - 로그인 처리
	  * @author 조승현
	  * @param loginDto
	  * @return Object
	  * @exception SQLException
	  * @exception Exception
	  */
	Object loginTry(LoginDto loginDto) throws SQLException, Exception;

	/**
	  * getEmpSessionDto - 로그인 정보를 통한 EmpSessionDto 조회
	  * @author 김종훈
	  * @param loginDto
	  * @return EmpSessionDto
	  * @exception SQLException
	  * @exception Exception
	  */
	EmpSessionDto getEmpSessionDto(LoginDto loginDto) throws SQLException, Exception;
	
	/**
	  * 사원 비밀번호 변경
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int updatePassword(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 사용자별 메뉴 사용 허용 여부 확인
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int getMenuCdCnt(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 로그인 사용자 ID 저장여부 확인
	  * @author 주병훈
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getEmpNo(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 로그인변경 유효성 확인
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int getLoginChangeCheckCnt(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 로그인변경 유효성 확인
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int getLoginChangeCheckAuth(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * @author 조승현
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 * @description 새로추가된 직원 리스트 조회 = 부서가 지정되지 않은 직원
	 */
	List<Map<String, Object>> getNewUserList() throws  Exception;
	
	/**
	  * 내선번호 가져오기
	  * @author 조승현
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getMemberInPhone(LoginDto resultLoginDto) throws SQLException, Exception;
	
	
	/**
	  * 내선번호 업데이트
	  * @author 조승현
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int updateMemberInPhone(Map<String, Object> paramMap) throws SQLException, Exception;

	


}
