package com.samyang.winplus.common.pos.service;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.samyang.winplus.common.pos.dao.PosVersionManagementDao;
import com.samyang.winplus.common.system.model.EmpSessionDto;

@Service("PosVersionManagementService")
public class PosVersionManagementServiceImpl implements PosVersionManagementService{
	
	@Autowired
	PosVersionManagementDao posVersionManagementDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	//private final String saveDir = "Z:\\version_upload_test";
	private final String saveDir = "\\\\192.168.210.17\\sis_file\\version_upload_test";
	
	
	public List<Map<String, Object>> getPosVersionList(Map<String, Object> paramMap) throws SQLException, Exception {
		return posVersionManagementDao.getPosVersionList(paramMap);
	}
	
	public String PosVersionFileUpload(MultipartFile VerFile, String EMP_NO) throws Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		//logger.debug("VerFile >>> " + VerFile);
		
		//원본파일 이름
		String orgName = VerFile.getOriginalFilename();
		//logger.debug("orgName >>> " + orgName);
		
		//확장자명
		String exName = VerFile.getOriginalFilename().substring(VerFile.getOriginalFilename().lastIndexOf("."));
		//logger.debug("exName >>> " + exName);
		
		//확장자명을 제거한 파일명
		int idx = orgName.lastIndexOf(".");
		String OnlyFileName = orgName.substring(0, idx);
		
		String FILE_IDX = posVersionManagementDao.getVersionFileIndex().get("FILE_IDX").toString();

		//저장파일이름
		SimpleDateFormat DateByDay = new SimpleDateFormat("yyyyMMdd");
		Date date = new Date();
		String Save_Ver_File_Name = DateByDay.format(date).toString();
		
		String filePath = saveDir + "\\" + Save_Ver_File_Name + FILE_IDX + ".zip";
		
		
		paramMap.put("Save_Ver_File_Name", Save_Ver_File_Name);
		paramMap.put("FILE_NM", Save_Ver_File_Name);
		paramMap.put("EMP_NO", EMP_NO);
		
		
		try {
			byte[] fileData = VerFile.getBytes();
			File VersionFile = new File(saveDir);
			
			if(!VersionFile.exists()) {
				VersionFile.mkdirs();
			}
			
			paramMap.put("FILE_SIZE", fileData.length);
			
			OutputStream out = new FileOutputStream(filePath);
			BufferedOutputStream bout = new BufferedOutputStream(out);
			bout.write(fileData);
			
			if(bout != null) {
				bout.close();
			}
			
			int InsertNum = posVersionManagementDao.savePosVersionFile(paramMap);
			//logger.debug("InsertNum >>> " + InsertNum);
			
			return "upload Success";
			
		} catch(IOException e) {
			e.printStackTrace();
			return "upload Fail";
		}
	}
	
	public List<Map<String, Object>> getVersionByMarketList(Map<String, Object> paramMap) throws SQLException, Exception{
		return posVersionManagementDao.getVersionByMarketList(paramMap);
	}
	
	public int ConfirmPosVersion(List<Map<String, Object>> paramMapList) {
			int resultRow = 0;

			for(Map<String, Object> paramMap : paramMapList){
				Object CHECK = paramMap.get("CHECK");
				if(CHECK != null) {
					if("1".equals(CHECK)){
						resultRow += posVersionManagementDao.ConfirmPosVersion(paramMap);
					} 
				}
			}
			return resultRow;
	}
	
	public List<Map<String, Object>> getPosVersionConfirmList(Map<String, Object> paramMap) throws SQLException, Exception{
		return posVersionManagementDao.getPosVersionConfirmList(paramMap);
	}
	
	public List<Map<String, Object>> saveVersionFileState(List<Map<String, Object>> paramList) throws SQLException, Exception {
		List<Map<String, Object>> resultMapList = new ArrayList<Map<String, Object>>();
		int saveValue = 0;
		
		for(Map<String, Object> paramMap : paramList) {
			saveValue += posVersionManagementDao.saveVersionFileState(paramMap);
		}
		
		Map<String, Object> SearchMap = new HashMap<String, Object>();
		SearchMap.put("SEARCH_NM", paramList.get(0).get("SEARCH_NM"));
		SearchMap.put("DateFrom", paramList.get(0).get("DateFrom"));
		SearchMap.put("DateTo", paramList.get(0).get("DateTo"));
		
		if(saveValue != 0) {
			resultMapList = posVersionManagementDao.getPosVersionList(SearchMap);
		}
		
		return resultMapList;
	}
	
	public List<Map<String, Object>> VersionUploadSave(List<Map<String, Object>> paramList) throws SQLException, Exception {
		List<Map<String, Object>> resultMapList = new ArrayList<Map<String, Object>>();
		int saveValue = 0;
		
		for(Map<String, Object> paramMap : paramList) {
			saveValue += posVersionManagementDao.VersionUploadSave(paramMap);
		}
		
		Map<String, Object> SearchMap = new HashMap<String, Object>();
		SearchMap.put("MS_NO", paramList.get(0).get("Search_Market"));
		SearchMap.put("SearchDateFrom", paramList.get(0).get("SearchDateFrom"));
		SearchMap.put("SearchDateTo", paramList.get(0).get("SearchDateTo"));
		
		if(saveValue != 0) {
			resultMapList = posVersionManagementDao.getPosVersionConfirmList(SearchMap);
		}
		
		return resultMapList;
	}

	@Override
	public Map<String, Object> VersionUploadDelete(Map<String, Object> paramMap) {
		return posVersionManagementDao.VersionUploadDelete(paramMap);
	}
}
