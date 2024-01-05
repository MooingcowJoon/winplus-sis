package com.samyang.winplus.sis.basic.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("CardCorpDao")
public interface CardCorpDao {

	List<Map<String, Object>> getCardCorpInfoList(Map<String, String> paramMap);

	int insertCardCorpInfoList(List<Map<String, Object>> paramListMap);
	
	int updateCardCorpInfoList(List<Map<String, Object>> paramListMap);
	
	int deleteCardCorpInfoList(List<Map<String, Object>> paramListMap);

}
