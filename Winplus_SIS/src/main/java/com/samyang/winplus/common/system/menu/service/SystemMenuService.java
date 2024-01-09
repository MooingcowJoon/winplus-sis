package com.samyang.winplus.common.system.menu.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("SystemMenuService")
public interface SystemMenuService {	
	/**
	  * getAllMenuMapList - 모든 메뉴 맵 목록 조회
	  * @author 김종훈
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getAllMenuMapList() throws SQLException, Exception;
	
	/**
	  * getMenuMap - 메뉴맵 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getMenuMap(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * saveMenu - 메뉴 저장
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveMenu(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getScreenList - 화면 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getScreenList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * saveScreenList - 화면 목록 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveScreenList(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
	/**
	  * getMenuByScreenList - 메뉴별화면 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getMenuByScreenList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * saveMenuByScreenList - 메뉴별화면 목록 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveMenuByScreenList(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
	
	
	/**
	  * getScreenListTest - 화면 목록 조회
	  * @author 서준호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getScreenListTest(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * saveScreenListTest - 화면 목록 저장
	  * @author 서준호
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveScreenListTest(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
}
