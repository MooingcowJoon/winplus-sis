package com.samyang.winplus.common.pos.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("PosChangeManagementDao")
public interface PosChangeManagementDao {
	List<Map<String, Object>> getPosPreferences(Map<String, Object> paramMap) throws SQLException, Exception;
	
	Map<String, Object> getPosPreferencesInfo(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int savePosPreferencesInfo(Map<String, Object> paramMap) throws SQLException, Exception;
}
