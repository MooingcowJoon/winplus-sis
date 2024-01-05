package com.samyang.winplus.addin.code.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("AddInFixedValuesService")
public interface AddInFixedValuesService {
	
	/**
	  * 고정값 마스터 테이블 조회
	  * @author 조승현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getMaster(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 고정값 마스터 테이블 저장
	  * @author 조승현
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveMaster(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
	/**
	  * 고정값 상세 테이블 조회
	  * @author 조승현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getDetail(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 고정값 상세 테이블 저장
	  * @author 조승현
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveDetail(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
}
