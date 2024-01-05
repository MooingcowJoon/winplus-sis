package com.samyang.winplus.common.pos.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("PosMessageManagementService")
public interface PosMessageManagementService {
	List<Map<String, Object>> getPosMessageList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int AddMessageManagementList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int DeleteMessageManagementList(Map<String, Object> paramMap) throws SQLException, Exception;

	int UpdateMessageManagementList(Map<String, Object> paramMap) throws SQLException, Exception;
}
