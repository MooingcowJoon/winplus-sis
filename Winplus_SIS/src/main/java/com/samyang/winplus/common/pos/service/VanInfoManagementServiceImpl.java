package com.samyang.winplus.common.pos.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.samyang.winplus.common.pos.dao.VanInfoManagementDao;

import net.sf.json.JSONObject;

@Service("VanInfoManagementService")

public class VanInfoManagementServiceImpl implements VanInfoManagementService {

	@Autowired
	VanInfoManagementDao vanInfoManagementDao;
	
	@Override
	public List<Map<String, Object>> getVanInfoManagementList(Map<String, Object> paramMap) {
		return vanInfoManagementDao.getVanInfoManagementList(paramMap);
	}

	@Override
	public Map<String, Object> getVanDetailInfo(Map<String, Object> paramMap) {
		return vanInfoManagementDao.getVanDetailInfo(paramMap);
	}

	@Override
	public Map<String, Object> crudVanInfo(Map<String, Object> paramMap) {
		return vanInfoManagementDao.crudVanInfo(paramMap);
	}
}
