package com.samyang.winplus.sis.price.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.market.dao.MarketDao;
import com.samyang.winplus.sis.price.dao.GoodsByPriceSearchDao;

import ch.qos.logback.classic.Logger;

@Service("GoodsByPriceSearchService")
public class GoodsByPriceSearchServiceImpl implements GoodsByPriceSearchService{
	
	@Autowired
	GoodsByPriceSearchDao goodsByPriceSearchDao;
	
	@Autowired
	MarketDao marketDao;
	
	public List<Map<String, Object>> getGoodsByPriceList(Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> GRUP_MAP = new HashMap<String, Object>();
		if(!paramMap.get("GRUP_CD").equals("ALL")) {
			GRUP_MAP = marketDao.getBargainGoodsSearchTMB(paramMap);
			
			paramMap.put("GRUP_TOP_CD", GRUP_MAP.get("GRUP_TOP_CD"));
			paramMap.put("GRUP_MID_CD", GRUP_MAP.get("GRUP_MID_CD"));
			paramMap.put("GRUP_BOT_CD", GRUP_MAP.get("GRUP_BOT_CD"));
		}
		
		return goodsByPriceSearchDao.getGoodsByPriceList(paramMap);
	}
}
