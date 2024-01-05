package com.samyang.winplus.sis.report.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("MonByReportDao")
public interface MonByReportDao {

	/**
	 * getMonByGoodsList - 월_단품별 조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getMonByGoodsList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * getMonByGoodsList - 월_협력사별 조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getMonByCustmrList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * getMonByCustrmrDetailList - 월_협력사별 상세 조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getMonByCustrmrDetailList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * getMonByCategoryList - 월_분류별 상세 조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getMonByCategoryList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * getMonByCategoryList - 월_월별종합 조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getMonByTotalList(Map<String, Object> paramMap) throws SQLException, Exception;

}
