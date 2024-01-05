package com.samyang.winplus.sis.market.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GoodsInspectionRegistDao {

	/**
	  * getGoodsInspectionRegistHeaderList - 입고검수등록 - 입고검수등록 헤더 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getGoodsInspectionRegistHeaderList(Map<String, Object> paramMap);

	/**
	  * getGoodsInspectionRegistDetailList - 입고검수등록 - 입고검수등록 디테일 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getGoodsInspectionRegistDetailList(Map<String, Object> paramMap);

	/**
	  * updateGoodsInspectionRegistList - 입고검수등록 - 입고검수등록 저장
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> updateGoodsInspectionRegistList(Map<String, Object> paramMap);

	/**
	  * updateGoodsInspectionRegistHeader - 입고검수등록 - 입고검수등록 헤더 업데이트
	  * @author 강신영
	  * @param paramMap
	  * @return 
	  * @exception SQLException
	  * @exception Exception
	  */
	void updateGoodsInspectionRegistHeader(Map<String, Object> paramMap);
	
	/**
	 * deleteGoodsInspectionRegistList - 입고검수등록 - 입고검수등록 삭제
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 */
	String deleteGoodsInspectionRegistList(Map<String, Object> paramMap);

	/**
	  * getGoodsExpertRegistList - 입고검수등록 - 입고예정수량 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getGoodsExpertRegistList(Map<String, Object> paramMap);
	
	/**
	 * getInspPdaDataHeaderList - 입고검수등록 - PDA입고내역 Header 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getInspPdaDataHeaderList(Map<String, Object> paramMap);
	
	/**
	 * getInspPdaDataDetailList - 입고검수등록 - PDA입고내역 Detail 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getInspPdaDataDetailList(Map<String, Object> paramMap);
	
	/**
	 * getInspInfo - 입고검수등록 - 거래명세서조회
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 */
	Map<String, Object> getInspInfo(Map<String, Object> paramMap);
	
	/**
	 * getPurMastSeq - 입고검수등록 - 시퀀스 채번
	 * @author 강신영
	 * @return String
	 */
	String getPurMastSeq();
	
}