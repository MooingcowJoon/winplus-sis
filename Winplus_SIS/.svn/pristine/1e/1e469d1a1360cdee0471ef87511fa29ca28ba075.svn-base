package com.samyang.winplus.sis.stock.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("TransInOutService")
public interface TransInOutService {

	/**
	 * 재고이동등록(직영점) - PDA재고이동 Summary 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getPdaTransSummaryList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동등록(직영점) - PDA재고이동 Item 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getPdaTransItemList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동등록(직영점) - 재고이동 마스터 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getStockTransMastList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동등록(직영점) - 재고이동 디테일 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getStockTransDetlList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동등록(직영점) - 재고이동 자료 생성
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String createTransData(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동등록(직영점) - PDA자료 삭제
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String deletePdaData(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동등록(직영점) - 재고이동 요청
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int requestTransData(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동등록(직영점) - 재고이동 요청취소
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int requestCancelTransData(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동등록(직영점) - 재고이동 품목삭제
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int deleteTransDataItem(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동등록(직영점) - 재고이동 품목등록수정
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int updateTransDataItem(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동등록(직영점) - 재고이동 요청 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getStockTransReqList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동확인(직영점) - 재고이동 확정
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int confirmTransData(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동확인(직영점) - 재고이동 확정취소
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int confirmCancelTransData(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고이동등록(직영점) - 재고이동 자료삭제
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int deleteTransData(Map<String, Object> paramMap) throws SQLException, Exception;

}
