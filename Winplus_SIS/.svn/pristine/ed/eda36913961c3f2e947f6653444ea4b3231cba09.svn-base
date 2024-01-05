package com.samyang.winplus.sis.stock.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("TransInOutDao")
public interface TransInOutDao {

	/**
	 * 재고이동등록(직영점) - PDA재고이동 Summary 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getPdaTransSummaryList(Map<String, Object> paramMap);
	
	/**
	 * 재고이동등록(직영점) - PDA재고이동 Item 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getPdaTransItemList(Map<String, Object> paramMap);
	
	/**
	 * 재고이동등록(직영점) - 재고이동 마스터 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getStockTransMastList(Map<String, Object> paramMap);
	
	/**
	 * 재고이동등록(직영점) - 재고이동 디테일 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getStockTransDetlList(Map<String, Object> paramMap);
	
	/**
	 * 재고이동등록(직영점) - 재고이동 자료 생성
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 */
	String createTransData(Map<String, Object> paramMap);
	
	/**
	 * 재고이동등록(직영점) - PDA자료 삭제
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 */
	String deletePdaData(Map<String, Object> paramMap);
	
	/**
	 * 재고이동등록(직영점) - 재고이동 요청
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 */
	int requestTransData(Map<String, Object> paramMap);
	
	/**
	 * 재고이동등록(직영점) - 재고이동 요청취소
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 */
	int requestCancelTransData(Map<String, Object> paramMap);
	
	/**
	 * 재고이동등록(직영점) - 재고이동 품목삭제
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 */
	int deleteTransDataItem(Map<String, Object> paramMap);
	
	/**
	 * 재고이동등록(직영점) - 재고이동 품목등록수정
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 */
	int updateTransDataItem(Map<String, Object> paramMap);
	
	/**
	 * 재고이동등록(직영점) - 재고이동 요청 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getStockTransReqList(Map<String, Object> paramMap);
	
	/**
	 * 재고이동확인(직영점) - 재고이동 확정
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 */
	int confirmTransData(Map<String, Object> paramMap);
	
	/**
	 * 재고이동확인(직영점) - 재고이동 확정취소
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 */
	int confirmCancelTransData(Map<String, Object> paramMap);
	
	/**
	 * 재고이동등록(직영점) - 재고이동 자료삭제
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 */
	int deleteTransData(Map<String, Object> paramMap);

}
