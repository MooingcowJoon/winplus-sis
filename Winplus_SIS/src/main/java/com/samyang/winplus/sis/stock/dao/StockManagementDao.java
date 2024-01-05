package com.samyang.winplus.sis.stock.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("StockManagementDao")
public interface StockManagementDao {
	
	/**
	  * 재고관리(직영점) - 재고실사 관리 상단 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getstockInspList(Map<String, Object> paramMap);
	
	/**
	  * 재고관리(직영점) - 재고실사 관리 - 재고실사 데이터 생성
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int saveStockInspList(Map<String, Object> paramMap);
	
	/**
	  * 재고관리(직영점) - 재고실사 관리 하단 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getstockInspSubList(Map<String, Object> paramMap);

	/**
	  * 재고관리(직영점) - 재고실사 관리 - 부분실사 적용
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int savePartStockInspList(Map<String, Object> paramMap);
	
	/**
	  * 재고관리(직영점) - 재고실사 관리 - 전체실사 적용
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int saveFullStockInspList(Map<String, Object> paramMap);
	
	/**
	  * 재고관리(직영점) - 재고실사 관리 하단 저장 -add
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int saveAddStockInspSubList(Map<String, Object> paramMap);
	
	/**
	  * 재고관리(직영점) - 재고실사 관리 하단 저장 -delete
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int deleteStockInspSubList(Map<String, Object> paramMap);
	
	/**
	 * nowStockByCategoryList - 재고관리(직영점) - 분류별 현재고 - 데이터조회
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> nowStockByCategoryList(Map<String, Object> paramMap);
	
	/**
	 * nowStockByCategoryTMB - 재고관리(직영점) - 분류별 현재고 - TMB
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> nowStockByCategoryTMB(Map<String, Object> paramMap);
	
	/**
	 * nowStockByCategoryList - 재고관리(직영점) - 단품별 현재고 - 데이터조회
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> nowStockBySingleList(Map<String, Object> paramMap);
	
	/**
	 * nowStockBySingleTMB - 재고관리(직영점) - 단품별 현재고 - TMB
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> nowStockBySingleTMB(Map<String, Object> paramMap);
	
	/**
	 * stockChangeHistoryList - 재고관리(직영점) - 재고변경 이력조회 - 데이터조회
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> stockChangeHistoryList(Map<String, Object> paramMap);
	
	/**
	 * stockChangeHistoryTMB - 재고관리(직영점) - 재고변경 이력조회 - TMB
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> stockChangeHistoryTMB(Map<String, Object> paramMap);
	
	/**
	 * monStockByCategoryList - 재고관리(직영점) - 분류별 월말재고 - 데이터조회
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> monStockByCategoryList(Map<String, Object> paramMap);

	/**
	 * monStockByCategoryTMB - 재고관리(직영점) - 분류별 월말재고 - TMB
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> monStockByCategoryTMB(Map<String, Object> paramMap);

	/**
	 * monStockByCategoryList - 재고관리(직영점) - 단품별 월말재고 - 데이터조회
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> monStockBySingleList(Map<String, Object> paramMap);

	/**
	 * monStockBySingleTMB - 재고관리(직영점) - 단품별 월말재고 - TMB
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> monStockBySingleTMB(Map<String, Object> paramMap);
}

