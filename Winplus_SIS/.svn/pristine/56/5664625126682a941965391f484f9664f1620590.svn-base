package com.samyang.winplus.sis.basic.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("CustmrSearchService")
public interface CustmrSearchService {
	
	List<Map<String, Object>> getSearchCustmrList(Map<String, Object> paramMap)   throws SQLException, Exception;
    List<Map<String, Object>> getSearchCustomPopup(Map<String, Object> paramMap)  throws SQLException, Exception;
    List<Map<String, Object>> getSearchCustmrGroupList(Map<String, String> paramMap);
	List<Map<String, Object>> getCustmrInfoLog(Map<String, Object> paramMap);
	
	/**
	  * 고객사구매가능상품관리 - 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getCustmrGoodsSearch(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 고객사구매가능상품관리 - 디테일조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getCustmrGoodsDetailSearch(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 고객사구매가능상품관리 - 상품저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int saveAddCustmrGoodsSearch(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 고객사구매가능상품관리 - 상품수정
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int saveUpdateCustmrGoodsSearch(Map<String, Object> paramMap) throws SQLException, Exception;
}
