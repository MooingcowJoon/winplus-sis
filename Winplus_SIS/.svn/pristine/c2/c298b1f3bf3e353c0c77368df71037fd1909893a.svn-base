package com.samyang.winplus.sis.standardInfo.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("GoodsCategoryService")
public interface GoodsCategoryService {
	
	/**
	  * getCategoryMap - 상품분류 항목 조회
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getCategoryMap(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * updateGoodsCategory - 상품분류관리 - 상품분류 항목 저장
	  * @author 강신영
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	String updateGoodsCategory(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * getGoodsCategoryByGoodsList - 상품분류별상품등록 - 상품분류별 상품목록 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getGoodsCategoryByGoodsList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * updateCategoryByGoods - 상품분류별상품등록 - 상품분류별 상품목록 저장
	  * @author 강신영
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int updateCategoryByGoods(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
}
