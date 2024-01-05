package com.samyang.winplus.sis.market.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("GoodsInspectionRegistService")
public interface GoodsInspectionRegistService {
	
	/**
	  * getGoodsInspectionRegistHeaderList - 입고검수등록 - 입고검수등록 헤더 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getGoodsInspectionRegistHeaderList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * getGoodsInspectionRegistDetailList - 입고검수등록 - 입고검수등록 디테일 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getGoodsInspectionRegistDetailList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * updateGoodsInspectionRegistList - 입고검수등록 - 입고검수등록 저장
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> updateGoodsInspectionRegistList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * updateGoodsInspectionRegistHeader - 입고검수등록 - 입고검수등록 헤더 업데이트
	  * @author 강신영
	  * @param paramMap
	  * @return 
	  * @exception SQLException
	  * @exception Exception
	  */
	void updateGoodsInspectionRegistHeader(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * deleteGoodsInspectionRegistList - 입고검수등록 - 입고검수등록 삭제
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String deleteGoodsInspectionRegistList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * getGoodsExpertRegistList - 입고검수등록 - 입고예정수량 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getGoodsExpertRegistList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getInspPdaDataHeaderList - 입고검수등록 - PDA입고내역 Header 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getInspPdaDataHeaderList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getInspPdaDataDetailList - 입고검수등록 - PDA입고내역 Detail 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getInspPdaDataDetailList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getInspInfo - 입고검수등록 - 거래명세서조회
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> getInspInfo(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getPurMastSeq - 입고검수등록 - 시퀀스 채번
	 * @author 강신영
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String getPurMastSeq() throws SQLException, Exception;

}
