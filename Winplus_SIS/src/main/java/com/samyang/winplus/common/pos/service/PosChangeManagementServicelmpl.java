package com.samyang.winplus.common.pos.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.pos.dao.PosChangeManagementDao;

@Service("PosChangeManagementService")
public class PosChangeManagementServicelmpl implements PosChangeManagementService {
	
	@Autowired
	PosChangeManagementDao posChangeManagementDao;
	
	@SuppressWarnings("unused")
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public List<Map<String, Object>> getPosPreferences(Map<String, Object> paramMap) throws SQLException, Exception {
		return posChangeManagementDao.getPosPreferences(paramMap);
	}
	
	@Override
	public Map<String, Object> getPosPreferencesInfo(Map<String, Object> paramMap) throws SQLException, Exception {
		return posChangeManagementDao.getPosPreferencesInfo(paramMap);
	}
	
	@Override
	public int savePosPreferencesInfo(Map<String, Object> paramMap) throws SQLException, Exception {
		return posChangeManagementDao.savePosPreferencesInfo(paramMap);
	}
}
