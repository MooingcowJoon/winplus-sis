package com.samyang.winplus.sis.standardInfo.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("PresetDao")
public interface PresetDao {
	List<Map<String, Object>> getPresetList(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	List<Map<String, Object>> getPresetGroupList(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	List<Map<String, Object>> getPresetDetailList(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	List<Map<String, Object>> getPresetTempList(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	int AddPresetMaster(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	int deletePresetMaster(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	int updatePresetMaster(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	int AddPresetDetailGoods(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	int deletePresetDetailGoods(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	int updatePresetDetailGoods(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	Map<String, Object> getDetailGoodsList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	Map<String, Object> getPresetinfoCheck(Map<String, Object> paramMap) throws SQLException, Exception;
	
	Map<String, Object> getPresetDetailinfoCheck(Map<String, Object> paramMap) throws SQLException, Exception;
	
	List<Map<String, Object>> SearchGoods(Map<String, Object> paramMap)  throws SQLException, Exception;

	Map<String, Object> getSearchMarketCD(Map<String, Object> paramMap);
	
	List<Map<String, Object>> getPasteDetailGoodsList(List<Map<String, Object>> paramMapList);
}
