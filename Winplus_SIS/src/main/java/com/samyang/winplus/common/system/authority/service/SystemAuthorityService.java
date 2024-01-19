package com.samyang.winplus.common.system.authority.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.model.MenuDto;
import com.samyang.winplus.common.system.model.ScreenDto;

@Service("SystemAuthorityService")
public interface SystemAuthorityService {	
	/**
	  * getAuthorList - 권한 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getAuthorList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * saveAuthorList - 권한 목록 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveAuthorList(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
	/**
	  * getAuthorByMenuList - 권한별메뉴 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getAuthorByMenuList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * saveAuthorByMenuList - 권한별메뉴 목록 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveAuthorByMenuList(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
	/**
	  * getAuthorByEmpList - 권한별사원 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getAuthorByEmpList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * saveAuthorByEmpList - 권한별사원 목록 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveAuthorByEmpList(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
	/**
	  * getAuthorTargetList - 권한대상목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getAuthorTargetList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getMenuMapList - 메뉴 맵 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getMenuMapList(Map<String, Object> paramMap) throws SQLException, Exception;
	/**
	  * getMenuDto - 메뉴 조회 (권한 확인용)
	  * @author 김종훈
	  * @param paramMap
	  * @return MenuDto
	  * @exception SQLException
	  * @exception Exception
	  */
	MenuDto getMenuDto(Map<String, Object> paramMap) throws SQLException, Exception;
	/**
	  * getScreenDto - 화면 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return ScreenDto
	  * @exception SQLException
	  * @exception Exception
	  */
	ScreenDto getScreenDto(Map<String, Object> paramMap) throws SQLException, Exception;
	/**
	  * getCommonScreenDto - 공통 화면 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return ScreenDto
	  * @exception SQLException
	  * @exception Exception
	  */
	ScreenDto getCommonScreenDto(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * insertSystemConnLog - 시스템 접속 로그
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int insertSystemConnLog(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * getEmpAccessLogList - 직원접속로그 - 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getEmpAccessLogList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getEmpList - 직원조회 - 조회
	  * @author 서준호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getEmpList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	
	/**
	  * saveEmpList - 사원조회 - 추가 - 저장
	  * @author 서준호
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveEmpList(List<Map<String, Object>> paramMap) throws SQLException, Exception;
	
	
	/**
	  * getPjtList - 직원조회 - 프로젝트조회
	  * @author 서준호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getPjtList(Map<String, Object> paramMap) throws SQLException, Exception;
	/**
	  * savePjtList - 사원조회 - 추가 - 저장
	  * @author 서준호
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int savePjtList(List<Map<String, Object>> paramMap) throws SQLException, Exception;
	
	
	
}
