package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("OrderParmSearchService")
public interface OrderParmSearchService {
	
	List<Map<String, Object>> getOrderParmSearchList(Map<String, Object> paramMap)   throws SQLException, Exception;

	/* SavePurOrdGoodsTemp -팜 발주서집계 등록 && 삭제 */
	int SavePurOrdGoodsTemp(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/* InsertPurOrdGoodsTemp -팜 발주서집계 등록 */
	int InsertPurOrdGoodsTemp(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/* UpdatePurOrdGoodsTemp - 발주서집계건 발주요청으로 상태 UPDATE */
	int UpdatePurOrdGoodsTemp(Map<String, Object> paramMap) throws SQLException, Exception;

	/* DeletePurOrdGoodsTemp - 발주서집계건 발주일자 조건으로 전체삭제(발주일 기준 재집계시) */
	int DeletePurOrdGoodsTemp(Map<String, Object> paramMap) throws SQLException, Exception;

	/* getPurTempCount - 팜센터에서 당일집계한 Data가 존재하는지확인 */
	int getPurTempCount(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/* UpdatePurOrdState - 발주마스터 상태 Update  */
	int UpdatePurOrdState(Map<String, Object> paramMap) throws SQLException, Exception;
	
}
