package com.samyang.winplus.common.pos.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("VanInfoManagementDao")
public interface VanInfoManagementDao {

	List<Map<String, Object>> getVanInfoManagementList(Map<String, Object> paramMap);

	Map<String, Object> getVanDetailInfo(Map<String, Object> paramMap);

	Map<String, Object> saveVanInfo(Map<String, Object> paramMap);

	Map<String, Object> crudVanInfo(Map<String, Object> paramMap);
}
