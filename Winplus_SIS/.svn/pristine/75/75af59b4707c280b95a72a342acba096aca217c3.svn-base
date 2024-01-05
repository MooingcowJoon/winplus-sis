package com.samyang.winplus.sis.basic.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.basic.dao.CustmrSearchDao;

@Service("CustmrSearchService")
public class CustmrSearchServiceImpl implements CustmrSearchService{
	
	@Autowired
	CustmrSearchDao custmrSearchDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public List<Map<String, Object>> getSearchCustmrList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return custmrSearchDao.getSearchCustmrList(paramMap);
	}
			
	@Override
	public List<Map<String, Object>> getSearchCustomPopup(Map<String, Object> paramMap)  throws SQLException, Exception {
		return custmrSearchDao.getSearchCustomPopup(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getSearchCustmrGroupList(Map<String, String> paramMap) {
		return custmrSearchDao.getSearchCustmrGroupList(paramMap);
	}

	@Override
	public List<Map<String, Object>> getCustmrInfoLog(Map<String, Object> paramMap) {
		return custmrSearchDao.getCustmrInfoLog(paramMap);
	}
	
	/**
	  * 고객사구매가능상품관리 - 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public List<Map<String, Object>> getCustmrGoodsSearch(Map<String, Object> paramMap) {
		return custmrSearchDao.getCustmrGoodsSearch(paramMap);
	}
	
	/**
	  * 고객사구매가능상품관리 - 디테일조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public List<Map<String, Object>> getCustmrGoodsDetailSearch(Map<String, Object> paramMap) {
		return custmrSearchDao.getCustmrGoodsDetailSearch(paramMap);
	}
	
	/**
	 * 고객사구매가능상품관리 - 상품저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */	
	@Override
	public int saveAddCustmrGoodsSearch(Map<String, Object> paramMap) throws SQLException, Exception {
		return custmrSearchDao.saveAddCustmrGoodsSearch(paramMap);
	}
	
	/**
	 * 고객사구매가능상품관리 - 상품수정
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */	
	@Override
	public int saveUpdateCustmrGoodsSearch(Map<String, Object> paramMap) throws SQLException, Exception {
		return custmrSearchDao.saveUpdateCustmrGoodsSearch(paramMap);
	}
}
