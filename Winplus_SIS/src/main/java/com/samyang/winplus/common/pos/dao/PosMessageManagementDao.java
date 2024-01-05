package com.samyang.winplus.common.pos.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("PosMessageManagementDao")
public interface PosMessageManagementDao {
	List<Map<String, Object>> getPosMessageList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int AddMessageManagementList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int DeleteMessageManagementList(Map<String, Object> paramMap) throws SQLException, Exception;

	int UpdateMessageManagementList(Map<String, Object> paramMap) throws SQLException, Exception;
}
