package com.samyang.winplus.sis.price.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("GoodsByPriceSearchService")
public interface GoodsByPriceSearchService {
	List<Map<String, Object>> getGoodsByPriceList(Map<String, Object> paramMap) throws SQLException, Exception;
}
