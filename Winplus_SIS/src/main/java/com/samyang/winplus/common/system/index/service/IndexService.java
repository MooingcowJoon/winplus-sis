package com.samyang.winplus.common.system.index.service;

import java.sql.SQLException;

import org.springframework.stereotype.Service;

@Service("indexService")
public interface IndexService {

	/**
	  * 헬스체크 - 빈페이지
	  * @author 조승현
	  * @param request
	  * @return ModelAndView
	  * @throws Exception 
	  * @throws SQLException 
	  */
	int getHealthcheck() throws SQLException, Exception;
}
