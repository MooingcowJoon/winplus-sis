package com.samyang.winplus.common.system.authority.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.samyang.winplus.common.system.model.MenuDto;
import com.samyang.winplus.common.system.model.ScreenDto;

@Repository("SystemAuthorityDao")
public interface SystemAuthorityDao {
	/**
	  * getAuthorList - 권한 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	public List<Map<String, Object>> getAuthorList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * insertAuthor - 권한 등록
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int insertAuthor(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateAuthor - 권한 수정
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updateAuthor(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * deleteAuthor - 권한 삭제
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int deleteAuthor(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getAuthorByMenuList - 권한별메뉴 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	public List<Map<String, Object>> getAuthorByMenuList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * saveAuthorByMenu - 권한별메뉴 저장
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int saveAuthorByMenu(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getAuthorByEmpList - 권한별사원 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	public List<Map<String, Object>> getAuthorByEmpList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * insertAuthorByEmp - 권한별사원 등록
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int insertAuthorByEmp(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateAuthorByEmp - 권한별사원 수정
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updateAuthorByEmp(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * deleteAuthorByEmp - 권한별사원 삭제
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int deleteAuthorByEmp(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getAuthorTargetList - 권한대상목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	public List<Map<String, Object>> getAuthorTargetList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getMenuDtoList - MenuDto 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<MenuDto>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<MenuDto> getMenuDtoList(Map<String, Object> paramMap) throws  SQLException, Exception;
	
	/**
	  * getMenuDto - MenuDto 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return MenuDto
	  * @exception SQLException
	  * @exception Exception
	  */
	MenuDto getMenuDto(Map<String, Object> paramMap) throws  SQLException, Exception;
	
	/**
	  * getScreenDto - ScreenDto 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return ScreenDto
	  * @exception SQLException
	  * @exception Exception
	  */
	ScreenDto getScreenDto(Map<String, Object> paramMap) throws  SQLException, Exception;
	
	/**
	  * getCommonScreenDto - 공통 ScreenDto 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return ScreenDto
	  * @exception SQLException
	  * @exception Exception
	  */
	ScreenDto getCommonScreenDto(Map<String, Object> paramMap) throws  SQLException, Exception;
	
	/**
	  * insertSystemConnLog - 시스템 접속 로그
	  * @author 주병훈
	  * @param paramMap
	  * @return ScreenDto
	  * @exception SQLException
	  * @exception Exception
	  */
	int insertSystemConnLog(Map<String, Object> paramMap) throws  SQLException, Exception;

	/**
	  * getEmpAccessLogList - 직원접속로그 - 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	public List<Map<String, Object>> getEmpAccessLogList(Map<String, Object> paramMap);
}
