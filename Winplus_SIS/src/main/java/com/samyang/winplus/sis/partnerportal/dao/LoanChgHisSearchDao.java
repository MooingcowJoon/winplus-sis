package com.samyang.winplus.sis.partnerportal.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("LoanChgHisSearchDao")
public interface LoanChgHisSearchDao {
	 List<Map<String, Object>> getloanChgHisSearchList(Map<String, Object> paramMap)  throws SQLException, Exception;
	 List<Map<String, Object>> getSaleCentSearchList(Map<String, Object> paramMap)  throws SQLException, Exception;
}
