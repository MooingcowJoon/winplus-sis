package com.samyang.winplus.sis.standardInfo.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;


@Service("PresetService")
public interface PresetService {
	
	List<Map<String, Object>> getPresetList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	List<Map<String, Object>> getPresetGroupList(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	List<Map<String, Object>> getPresetDetailList(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	List<Map<String, Object>> getPresetTempList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int AddPresetMaster(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int deletePresetMaster(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int updatePresetMaster(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int AddPresetDetailGoods(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	int deletePresetDetailGoods(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	int updatePresetDetailGoods(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	List<Map<String, Object>> getDetailGoodsList(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
	Map<String, Object> getPresetinfoCheck(Map<String, Object> paramMap) throws SQLException, Exception;

	Map<String, Object> getPresetDetailinfoCheck(Map<String, Object> paramMap) throws SQLException, Exception;
	
	List<Map<String, Object>> SearchGoods(Map<String, Object> paramMap)  throws SQLException, Exception;

	Map<String, Object> getSearchMarketCD(Map<String, Object> paramMap) throws SQLException, Exception;

	List<Map<String, Object>> getPasteDetailGoodsList(Map<String, Object> paramMap) throws SQLException, Exception;
}
