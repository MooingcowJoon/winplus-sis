package com.samyang.winplus.common.pos.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

@Repository("PosVersionManagementDao")
public interface PosVersionManagementDao {
	List<Map<String, Object>> getPosVersionList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int savePosVersionFile(Map<String, Object> paramMap) throws Exception;
	
	List<Map<String, Object>> getVersionByMarketList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int ConfirmPosVersion(Map<String, Object> paramMap);
	
	List<Map<String, Object>> getPosVersionConfirmList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int saveVersionFileState(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int VersionUploadSave(Map<String, Object> paramMap) throws SQLException, Exception;
	
	Map<String, Object> getVersionFileIndex() throws SQLException, Exception;

	Map<String, Object> VersionUploadDelete(Map<String, Object> paramMap);
}
