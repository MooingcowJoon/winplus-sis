package com.samyang.winplus.sis.order.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("OrderParmSearchDao")
public interface OrderParmSearchDao {
	
    List<Map<String, Object>> getOrderParmSearchList(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/* SavetPurOrdGoodsTemp -팜 발주서집계 등록 && 삭제 */
	public int SavePurOrdGoodsTemp(Map<String, Object> paramMap) throws SQLException, Exception;
    
	/* InsertPurOrdGoodsTemp -팜 발주서집계 등록 */
	public int InsertPurOrdGoodsTemp(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/* UpdatePurOrdGoodsTemp - 발주서집계건 발주요청으로 상태 UPDATE */
	public int UpdatePurOrdGoodsTemp(Map<String, Object> paramMap) throws SQLException, Exception;

	/* DeletePurOrdGoodsTemp - 발주서집계건 발주일자 조건으로 전체삭제(발주일 기준 재집계시) */
	public int DeletePurOrdGoodsTemp(Map<String, Object> paramMap) throws SQLException, Exception;

	/* getPurTempCount - 팜센터에서 당일집계한 Data가 존재하는지확인 */
	public int getPurTempCount(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/* UpdatePurOrdState - 발주마스터 상태 Update  */
	public int UpdatePurOrdState(Map<String, Object> paramMap) throws SQLException, Exception;
	
}
