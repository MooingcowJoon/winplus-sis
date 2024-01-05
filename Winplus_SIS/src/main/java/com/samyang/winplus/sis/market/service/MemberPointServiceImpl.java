package com.samyang.winplus.sis.market.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.market.dao.MemberPointDao;

@Service("MemberPointService")
public class MemberPointServiceImpl implements MemberPointService{

	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private MemberPointDao memberPointDao;
	
	/**
	  * 회원포인트조회
	  * @author 정혜원
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	public List<Map<String, Object>> getMemberPointList(Map<String, Object> paramMap) throws SQLException, Exception{
		return memberPointDao.getMemberPointList(paramMap);
	}
}
