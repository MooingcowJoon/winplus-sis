package com.samyang.winplus.common.system.login.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.model.LoginDto;

@Repository("LoginDao")
public interface LoginDao {	
	/**
	  * getLoginDto - LoginDto 조회
	  * @author 김종훈
	  * @param loginDao
	  * @return LoginDto
	  * @exception SQLException
	  * @exception Exception
	  */
	public LoginDto getLoginDto(LoginDto loginDao) throws SQLException, Exception;
	
	/**
	  * getEmpSessionDto - EmpSessionDto 조회
	  * @author 김종훈
	  * @param loginDao
	  * @return EmpSessionDto
	  * @exception SQLException
	  * @exception Exception
	  */
	public EmpSessionDto getEmpSessionDto(LoginDto loginDto) throws SQLException, Exception;	
	
	/**
	  * insertLoginAtptLog - 로그인 시도 로그 등록
	  * @author 김종훈
	  * @param resultLoginDto
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int insertLoginTryLog(LoginDto resultLoginDto) throws SQLException, Exception;
	
	/**
	  * updateLoginPasswordErrorTime - 로그인 비밀번호 오류 시간 수정
	  * @author 김종훈
	  * @param resultLoginDto
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updateLoginPasswordErrorTime(LoginDto resultLoginDto)  throws SQLException, Exception;

	/**
	  * updatePassword - 비밀번호 변경
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updatePassword(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/**
	  * 사용자별 매뉴 사용 허용 여부 확인
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int getMenuCdCnt(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/**
	  * 로그인 사용자 ID 저장여부 확인
	  * @author 주병훈
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	public Map<String, Object> getEmpNo(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/**
	  * 로그인변경 유효성 확인
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int getLoginChangeCheckCnt(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/**
	  * 로그인변경 유효성 확인
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int getLoginChangeCheckAuth(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/**
	 * @author 조승현
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 * @description 새로추가된 직원 리스트 조회 = 부서가 지정되지 않은 직원
	 */
	public List<Map<String, Object>> getNewUserList() throws SQLException, Exception;

	/**
	  * 내선번호 가져오기
	  * @author 조승현
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	public Map<String, Object> getMemberInPhone(LoginDto resultLoginDto)throws SQLException, Exception;
	
	/**
	  * 내선번호 업데이트
	  * @author 조승현
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updateMemberInPhone(Map<String, Object> paramMap) throws SQLException, Exception;

}
