package com.samyang.winplus.common.pos.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("PosChangeManagementService")
public interface PosChangeManagementService {
	List<Map<String, Object>> getPosPreferences(Map<String, Object> paramMap) throws SQLException, Exception;
	
	Map<String, Object> getPosPreferencesInfo(Map<String, Object> paramMap) throws SQLException, Exception;

	int savePosPreferencesInfo(Map<String, Object> paramMap) throws SQLException, Exception;
}