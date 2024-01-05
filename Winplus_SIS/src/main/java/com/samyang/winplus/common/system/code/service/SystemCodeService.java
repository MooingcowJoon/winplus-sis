package com.samyang.winplus.common.system.code.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("SystemCodeService")
public interface SystemCodeService {
	
	/**
	  * 공통코드 테이블 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getCommonCodeTable(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 공통코드 테이블 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveCommonCodeTable(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
	/**
	  * 공통코드 상세 테이블 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getCommonCodeDetailTable(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 공통코드 상세 테이블 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveCommonCodeDetailTable(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
	/**
	  * 공통코드 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getCommonCodeList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 공통 코드,코드명 목록 조회
	  * @author 조승현
	  * @param request
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getDetailCommonCodeList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 상위코드를 통한 공통코드 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getCommonCodeByUpperCodeList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	
	/**
	  * 트리코드 테이블 조회
	  * @author 조승현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getTreeCodeTable(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 트리코드 테이블 저장
	  * @author 조승현
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int cudTreeCodeTable(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
	/**
	  * 트리상세코드 테이블 조회
	  * @author 조승현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getTreeDetailCodeTable(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 트리상세코드 테이블 저장
	  * @author 조승현
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int cudTreeDetailCodeTable(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
}
