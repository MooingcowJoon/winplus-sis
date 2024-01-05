package com.samyang.winplus.sis.report.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("EtcService")
public interface EtcService {

	/**
	  * 단가변동표 - 단가변동내역 조회
	  * @author 정혜원
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getPriceChangeList(Map<String, Object> paramMap) throws SQLException, Exception;

}
