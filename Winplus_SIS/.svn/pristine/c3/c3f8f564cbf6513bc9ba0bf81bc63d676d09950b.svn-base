package com.samyang.winplus.common.pos.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service("PosVersionManagementService")
public interface PosVersionManagementService {
	List<Map<String, Object>> getPosVersionList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	String PosVersionFileUpload(MultipartFile VerFile,String EMP_NO) throws Exception;
	
	List<Map<String, Object>> getVersionByMarketList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int ConfirmPosVersion(List<Map<String, Object>> paramMapList);
	
	List<Map<String, Object>> getPosVersionConfirmList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	List<Map<String, Object>> saveVersionFileState(List<Map<String, Object>> paramList) throws SQLException, Exception;
	
	List<Map<String, Object>> VersionUploadSave(List<Map<String, Object>> paramList) throws SQLException, Exception;

	Map<String, Object> VersionUploadDelete(Map<String, Object> paramMap);
}
