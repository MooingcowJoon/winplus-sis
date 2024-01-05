package com.samyang.winplus.sis.basic.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.samyang.winplus.sis.basic.dao.CardCorpDao;

@Service("CardCorpService")
public class CardCorpServiceImpl implements CardCorpService{
	
	@Autowired
	CardCorpDao cardCorpDao;

	@Override
	public List<Map<String, Object>> getCardCorpInfoList(Map<String, String> paramMap) {
		return cardCorpDao.getCardCorpInfoList(paramMap);
	}

	@Transactional
	@Override
	public int crudCardCorpInfoList(Map<String, Object> paramMap) {
		int resultCnt = 0;
		resultCnt += cardCorpDao.insertCardCorpInfoList((List<Map<String, Object>>) paramMap.get("C"));
		resultCnt += cardCorpDao.updateCardCorpInfoList((List<Map<String, Object>>) paramMap.get("U"));
		resultCnt += cardCorpDao.deleteCardCorpInfoList((List<Map<String, Object>>) paramMap.get("D"));
		return resultCnt;
	}
	
}
