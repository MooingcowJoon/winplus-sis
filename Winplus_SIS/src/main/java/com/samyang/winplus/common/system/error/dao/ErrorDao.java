package com.samyang.winplus.common.system.error.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface ErrorDao {

	int insertSystemErrorLog(Map<String, Object> paramMap);
	
}
