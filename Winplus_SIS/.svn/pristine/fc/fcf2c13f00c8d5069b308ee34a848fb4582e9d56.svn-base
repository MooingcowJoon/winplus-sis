package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("OrderInputService")
public interface OrderInputService {
	
	int insertTpurOrd(Map<String, Object> paramMap) throws SQLException, Exception;
	int insertTpurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int updateTpurOrd(Map<String, Object> paramMap) throws SQLException, Exception;
	int updateTpurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int deleteTpurOrd(Map<String, Object> paramMap) throws SQLException, Exception;
	int deleteTpurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception;

	Map<String, Object>  saveTpurOrdGoodsScreenList(List<Map<String, Object>> paramMapList, Map<String, Object> paramMap) throws SQLException, Exception;
	
	int getTpurOrdCount(Map<String, Object> paramMap) throws SQLException, Exception;
	
	String GetOrderNumber(Map<String, Object> paramMap) throws SQLException, Exception;
   
	List<Map<String, Object>> getSearchPdaOrderBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception;	

	int updateTpurOrdState(Map<String, Object> paramMap) throws SQLException, Exception;

	Map<String, Object>  updateTpurOrdState(List<Map<String, Object>> paramMapList ) throws SQLException, Exception;
	
	int updateReqGoodsTmpFlag(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	public int deleteTpurOrdByCancel(Map<String, Object> paramMap) throws SQLException, Exception;
	public int deleteTpurOrdGoodsByCancel(Map<String, Object> paramMap) throws SQLException, Exception;

	Map<String, Object>  deleteByORderCancel(List<Map<String, Object>> paramMapList ) throws SQLException, Exception;

}
