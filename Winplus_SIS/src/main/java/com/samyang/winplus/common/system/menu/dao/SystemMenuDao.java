package com.samyang.winplus.common.system.menu.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface SystemMenuDao {
	/**
	  * getMenuList - 메뉴 목록 조회
	  * @author 김종훈
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	public List<Map<String, Object>> getMenuList() throws SQLException, Exception;
	
	/**
	  * getMenuMap - 메뉴맵 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	public Map<String, Object> getMenuMap(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * insertMenu - 메뉴 등록
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int insertMenu(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateMenu - 메뉴 수정
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updateMenu(Map<String, Object> paramMap) throws SQLException, Exception;
	
	
	/**
	  * chkChildMenu - 메뉴삭제전 하위 메튜체크
	  * @author 정인선
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int chkChildMenu(Map<String, Object> paramMap) throws SQLException, Exception; 
	
	/**
	  * deleteMenuByScrin - 메뉴화면 권한 삭제
	  * @author 정인선
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int deleteAuthorByMenu(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * deleteMenuByScrin - 메뉴화면등록 삭제
	  * @author 정인선
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int deleteMenuByScrin(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * deleteMenu - 메뉴 삭제
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int deleteMenu(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	  * getScreenList - 화면 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	public List<Map<String, Object>> getScreenList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * insertScreen - 화면 등록
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int insertScreen(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateScreen - 화면 수정
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updateScreen(Map<String, Object> paramMap) throws SQLException, Exception;
	
	
	/**
	  * deleteScrinFirst - 화면 삭제1
	  * @author 정인선
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int deleteScrinFirst(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * deleteScrinFirst - 화면 삭제2
	  * @author 정인선
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int deleteScrinSecond(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * deleteScreen - 화면 삭제
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int deleteScreen(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getMenuByScreenList - 메뉴별화면 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	public List<Map<String, Object>> getMenuByScreenList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * insertMenuByScreen - 메뉴별화면 등록
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int insertMenuByScreen(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateMenuByScreen - 메뉴별화면 수정
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updateMenuByScreen(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * deleteMenuByScreen - 메뉴별화면 삭제
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int deleteMenuByScreen(Map<String, Object> paramMap) throws SQLException, Exception;
}
