package com.samyang.winplus.common.employee.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("empDao")
public interface EmpDao {

	/**
	  * 사용자 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getEmpList(Map<String, String> paramMap) throws SQLException, Exception;
	
	/**
	  * 사용자 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getEmp(Map<String, String> paramMap) throws SQLException, Exception;
	
	
	/**
	  * 사용자 입력
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	int insertEmp(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 사용자 계정 입력
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	int insertEmpAcnt(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 사용자 수정
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	int updateEmp(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 사용자 삭제
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	int deleteEmp(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 중복 이메일 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	int getExistEmail(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 로그인 추가 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getEmpLoginAddList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 로그인 추가 저장
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveEmpLoginAddList(Map<String, Object> paramMap) throws SQLException, Exception;

	
	/**
	  * checkEmpLoginList - 변경 가능한 세션 사원번호 존재여부 확인
	  * @author 조승현
	  * @param param
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int checkEmpLoginList(Map<String, Object> param) throws SQLException, Exception;

	
	/**
	  * getPerfectEmpList - 퍼펙트 사용자 목록 조회
	  * @author 조승현
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> getPerfectEmpList(Map<String, Object> paramMap)throws SQLException, Exception;

	
	/**
	  * getPerfectEmpList - 퍼펙트 사용자 정보
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	Map<String, Object> getPerfectEmpDetail(Map<String, Object> paramMap)throws SQLException, Exception;

	
	/**
	  * insertPerfectEmp - 퍼펙트 사용자 입력
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	int insertPerfectEmp(Map<String, Object> paramMap)throws SQLException, Exception;
	
	/**
	  * insertPerfectEmp - 수정
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	int updatePerfectEmp(Map<String, Object> paramMap)throws SQLException, Exception;

	/**
	  * insertPerfectEmp - 삭제
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	int deletePerfectEmp(Map<String, Object> paramMap)throws SQLException, Exception;
	
	/**
	  * 이용중인 담당자 코드인지 조회
	  * @author 조승현
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int memeberCodeAvailableCheck(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * getEmpByGrupList - 사용자별 그룹 관리 - 그룹 조회
	  * @author 강신영
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> getEmpByGrupList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * saveEmpByGrupList - 사용자별 그룹 관리 - 그룹 저장
	  * @author 강신영
	  * @param request
	  * @return Integer
	  */
	int saveEmpByGrupList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getEmpGrupDetailList - 사용자별 그룹관리 - 그룹 상세조회
	 * @author 정혜원
	 * @param request
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getEmpGrupDetailList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * saveEmpByGrupDetailList - 사용자별 거래처 그룹관리 - 거래처 상세내역 저장
	  * @author 정혜원
	  * @param request
	  * @return Integer
	  */
	int saveEmpByGrupDetailList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @description 사용자 조회(협력사)
	 */
	List<Map<String, Object>> getPartnerList(Map<String, String> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @description 사용자 조회(고객사)
	 */
	List<Map<String, Object>> getCustomerList(Map<String, String> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @description 비밀번호 초기화
	 */
	void initPassword(Map<String, String> paramMap);
	
}
