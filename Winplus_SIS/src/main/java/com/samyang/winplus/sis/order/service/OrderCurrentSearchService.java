package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("OrderCurrentSearchService")
public interface OrderCurrentSearchService {
	
	
	List<Map<String, Object>> getCurrentSearchOrderList(Map<String, Object> paramMap)   throws SQLException, Exception;
    
}
