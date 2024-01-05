package com.samyang.winplus.sis.stock.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("ConversionManagementService")
public interface ConversionManagementService {

	/**
	 * getStockConvHeaderList - 대출입 - 대출입 헤더 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getStockConvHeaderList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getConvInfo - 대출입 정보 조회
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> getConvInfo(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getStockConvDetailList - 대출입 등록/조회 - 대출입 원물 디테일 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getStockOriConvDetailList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getStockConvDetailList - 대출입 등록/조회 - 대출입 대물 디테일 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getStockReplcConvDetailList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getStockConvSeq - 대출입 등록/조회 - 시퀀스 채번
	 * @author 강신영
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String getStockConvSeq() throws SQLException, Exception;
	
	/**
	 * updateConversionDetail - 대출입 등록/조회 - 대출입 디테일 저장
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> updateConversionDetail(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * updateConversionDetail - 대출입 헤더 갱신
	 * @author 강신영
	 * @param paramMap
	 * @throws SQLException
	 * @throws Exception
	 */
	void updateConversionHeader(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * deleteConversionManagementList - 대출입 - 대출입 삭제
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String deleteConversionManagementList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * reqConfirmConv - 대출입 - 대출입 요청
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String reqConfirmConv(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * reqConfirmCancelConv - 대출입 - 대출입 요청취소
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String reqConfirmCancelConv(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getStockConvReqList - 대출입확정 - 대출입요청 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getStockConvReqList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * confirmConvData - 대출입확정 - 대출입 확정
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String confirmConvData(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * confirmCancelConvData - 대출입확정 - 대출입 확정취소
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	String confirmCancelConvData(Map<String, Object> paramMap) throws SQLException, Exception;

}
