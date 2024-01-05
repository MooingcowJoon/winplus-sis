package com.samyang.winplus.sis.basic.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("VirtualAcntDao")
public interface VirtualAcntDao {

	/**
	 * 기준정보관리 - 가상계좌현황 - 헤더내역조회
	 * @author 한정훈
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getVirtualAcntHeaderList(Map<String, Object> paramMap)  throws SQLException, Exception;
	/**
	 * 기준정보관리 - 가상계좌현황 - 디테일내역조회
	 * @author 한정훈
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getVirtualAcntDetailList(Map<String, String> paramMap)  throws SQLException, Exception;
	/**
	 * 기준정보관리 - 가상계좌현황 - 조회테이블조회
	 * @author 한정훈
	 * @param searchData
	 * @return Map<String, Object>
	 */
	Map<String, Object> getVirtualAcntTableInfo(Map<String, Object> searchData);
}
