package com.samyang.winplus.sis.price.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("GoodsCenterEventPriceDao")
public interface GoodsCenterEventPriceDao {

	List<Map<String, Object>> getCenterEventList(Map<String, String> paramMap) throws SQLException, Exception;

	int insertCenterEventList(Map<String, Object> paramMap);

	List<Map<String, Object>> getCenterEventGoodsInfo(List<String> list);

	void insertCenterEventGoodsList(List<Map<String, Object>> list);

	void updateCenterEventGoodsList(List<Map<String, Object>> list);

	void deleteCenterEventGoodsList(List<Map<String, Object>> list);
	
	void insertCenterEventGoodsPurList(List<Map<String, Object>> list);
	
	void updateCenterEventGoodsPurList(List<Map<String, Object>> list);
	
	void deleteCenterEventGoodsPurList(List<Map<String, Object>> list);

	List<Map<String, Object>> getCenterEventGoodsList(Map<String, Object> paramMap);

	List<Map<String, Object>> getCenterEventCustmrInfo(List<String> list);

	void insertCenterEventCustmrList(List<Map<String, Object>> list);

	void updateCenterEventCustmrList(List<Map<String, Object>> list);

	void deleteCenterEventCustmrList(List<Map<String, Object>> list);

	List<Map<String, Object>> getCenterEventCustmrList(Map<String, Object> paramMap);

}
