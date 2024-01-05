package com.samyang.winplus.common.system.index.service;

import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.index.dao.IndexDao;

@Service("indexService")
public class IndexServiceImpl implements IndexService {
	
	@Autowired
	IndexDao indexDao;

	/**
	  * 헬스체크 - 빈페이지
	  * @author 조승현
	  * @param request
	  * @return ModelAndView
	  * @throws Exception 
	  * @throws SQLException 
	  */
	@Override
	public int getHealthcheck() throws SQLException, Exception {
		return indexDao.getHealthcheck();
	}

}
