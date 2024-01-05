package com.samyang.winplus.sis.order.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("OrderInputDao")
public interface OrderInputDao {


	/**
	  * insertTpurOrd - 발주서마스터 등록
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int insertTpurOrd(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * insertTpurOrdGoods - 발주서마스터상세 등록
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int insertTpurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateTpurOrd - 발주서마스터 수정
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updateTpurOrd(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateTpurOrdGoods - 발주서마스터상세 수정
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updateTpurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * deleteTpurOrd - 발주서마스터 삭제
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int deleteTpurOrd(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * deleteTpurOrdGoods - 발주서마스터상세 삭제
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int deleteTpurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getTpurOrdCount - 발주서마스터가 있는지 확인
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */    
	public int getTpurOrdCount(Map<String, Object> paramMap) throws SQLException, Exception;
	
	public String GetOrderNumber(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * getSearchPdaOrderBarcodePriceList - PDA수신리스트 가져오기
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */	
	 List<Map<String, Object>> getSearchPdaOrderBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception;	

		/**
	  * updateTpurOrdState - 발주서마스터 진행상태Update
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updateTpurOrdState(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * updateReqGoodsTmpFlag - 주문요청서 처리상태 수정
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updateReqGoodsTmpFlag(Map<String, Object> paramMap) throws SQLException, Exception;

	public int deleteTpurOrdByCancel(Map<String, Object> paramMap) throws SQLException, Exception;
	public int deleteTpurOrdGoodsByCancel(Map<String, Object> paramMap) throws SQLException, Exception;
		
}
