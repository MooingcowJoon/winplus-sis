package com.samyang.winplus.sis.price.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("GoodsByPriceSearchDao")
public interface GoodsByPriceSearchDao {
	
	List<Map<String, Object>> getGoodsByPriceList(Map<String, Object> paramMap) throws SQLException, Exception;
}
