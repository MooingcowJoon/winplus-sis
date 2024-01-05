package com.samyang.winplus.sis.standardInfo.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GoodsCategoryDao {

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
	  * insertGoodsCategory - 상품분류 항목 등록
	  * @author 강신영
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	String insertGoodsCategory(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateGoodsCategory - 상품분류 항목 수정
	  * @author 강신영
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	String updateGoodsCategory(Map<String, Object> paramMap) throws SQLException, Exception;
	
	
	/**
	  * chkChildCategory - 상품분류 삭제전 하위 상품분류 or 해당 분류를 사용하고 있는 상품 체크
	  * @author 강신영
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int chkChildCategory(Map<String, Object> paramMap) throws SQLException, Exception; 
	
	/**
	  * deleteGoodsCategory - 상품분류 항목 삭제
	  * @author 강신영
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	String deleteGoodsCategory(Map<String, Object> paramMap) throws SQLException, Exception;

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
	  * updateCategoryByGoods - 상품분류별상품등록 - 상품분류별 상품 저장
	  * @author 강신영
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int updateCategoryByGoods(Map<String, Object> paramMap) throws SQLException, Exception;
}