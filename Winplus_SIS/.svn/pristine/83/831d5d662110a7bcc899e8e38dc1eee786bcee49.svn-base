package com.samyang.winplus.sis.stock.dao;

import java.util.List;
import java.util.Map;

public interface ConversionManagementDao {
	
	/**
	 * getStockConvHeaderList - 대출입 - 대출입 헤더 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getStockConvHeaderList(Map<String, Object> paramMap);
	
	/**
	 * getConvInfo - 대출입 정보 조회
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 */
	Map<String, Object> getConvInfo(Map<String, Object> paramMap);
	
	/**
	 * getStockConvDetailList - 대출입 등록/조회 - 대출입 원물 디테일 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getStockOriConvDetailList(Map<String, Object> paramMap);
	
	/**
	 * getStockConvDetailList - 대출입 등록/조회 - 대출입 대물 디테일 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getStockReplcConvDetailList(Map<String, Object> paramMap);
	
	/**
	 * getStockConvSeq - 대출입 등록/조회 - 시퀀스 채번
	 * @author 강신영
	 * @return String
	 */
	String getStockConvSeq();
	
	/**
	 * updateConversionDetail - 대출입 등록/조회 - 대출입 디테일 저장
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 */
	Map<String, Object> updateConversionDetail(Map<String, Object> paramMap);
	
	/**
	 * updateConversionDetail - 대출입 헤더 갱신
	 * @author 강신영
	 * @param paramMap
	 */
	void updateConversionHeader(Map<String, Object> paramMap);
	
	/**
	 * deleteConversionManagementList - 대출입 - 대출입 삭제
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 */
	String deleteConversionManagementList(Map<String, Object> paramMap);
	
	/**
	 * reqConfirmConv - 대출입 - 대출입 요청
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 */
	String reqConfirmConv(Map<String, Object> paramMap);
	
	/**
	 * reqConfirmCancelConv - 대출입 - 대출입 요청취소
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 */
	String reqConfirmCancelConv(Map<String, Object> paramMap);
	
	/**
	 * getStockConvReqList - 대출입확정 - 대출입요청 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getStockConvReqList(Map<String, Object> paramMap);
	
	/**
	 * confirmConvData - 대출입확정 - 대출입 확정
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 */
	String confirmConvData(Map<String, Object> paramMap);
	
	/**
	 * confirmCancelConvData - 대출입확정 - 대출입 확정취소
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 */
	String confirmCancelConvData(Map<String, Object> paramMap);

}
