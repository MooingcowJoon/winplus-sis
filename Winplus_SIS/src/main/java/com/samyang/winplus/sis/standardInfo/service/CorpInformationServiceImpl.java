package com.samyang.winplus.sis.standardInfo.service;

import java.sql.SQLException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.standardInfo.dao.CorpInformationDao;

@Service("CorpInformationService")
public class CorpInformationServiceImpl implements CorpInformationService {
	
	@Autowired
	CorpInformationDao corpInformationDao;

	/**
	  * getCorpInformationFromKeyword - 가격변경예약(직영점) - 키워드로 거래처정보 조회
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getCorpInformationFromKeyword(Map<String, Object> paramMap) throws SQLException, Exception {
		return corpInformationDao.getCorpInformationFromKeyword(paramMap);
	}
}
