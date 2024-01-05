package com.samyang.winplus.sis.market.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("MemberPointDao")
public interface MemberPointDao {
	
	/**
	  * 회원포인트조회
	  * @author 정혜원
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getMemberPointList(Map<String, Object> paramMap) throws SQLException, Exception;
}
