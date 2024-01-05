package com.samyang.winplus.sis.order.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("OrderRequestDao")
public interface OrderRequestDao {

	/**
	  * insertReqGoodsTmp - 발주요청서등록
	  * @author 손경락
	  * @param paramMap
	  * @return int
	  * @exception SQLException
	  * @exception Exception
	  */	
	public int insertReqGoodsTmp(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateTpdaTempStatus - PDA발주요청서수정
	  * @author 손경락
	  * @param paramMap
	  * @return int
	  * @exception SQLException
	  * @exception Exception
	  */	
	public int updateTpdaTempStatus(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateReqGoodsTmp - 발주요청서수정
	  * @author 손경락
	  * @param paramMap
	  * @return int
	  * @exception SQLException
	  * @exception Exception
	  */	
	public int updateReqGoodsTmp(Map<String, Object> paramMap) throws SQLException, Exception;
	           
	/**
	  * deleteReqGoodsTmp - 발주요청서삭제
	  * @author 손경락
	  * @param paramMap
	  * @return int
	  * @exception SQLException
	  * @exception Exception
	  */	
	public int deleteReqGoodsTmp(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * saveOrdReqGoodsTmp - 발주요청서insert
	  * @author 손경락
	  * @param paramMap
	  * @return int
	  * @exception SQLException
	  * @exception Exception
	  */	
	public int saveOrdReqGoodsTmp(List<Map<String, Object>> paramMapList, Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * UpdateOrdReqGoodsTmp - 발주요청서갱신
	  * @author 손경락
	  * @param paramMap
	  * @return int
	  * @exception SQLException
	  * @exception Exception
	  */	
	public int UpdateOrdReqGoodsTmp(List<Map<String, Object>> paramMapList, Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getSearchReqGoodsTmp - 발주요청서조회
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */	
    List<Map<String, Object>> getSearchReqGoodsTmp(Map<String, Object> paramMap)  throws SQLException, Exception;

	/**
	  * getSearchReqGoodsCSportal - CS포털 팝업 주문요청서 조회
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */	
   List<Map<String, Object>> getSearchReqGoodsCSportal(Map<String, Object> paramMap)  throws SQLException, Exception;
   
    /**
	  * getSearchReqFreshGoodsTmp - 신선 발주가능상품 조회 
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */	
    List<Map<String, Object>> getSearchReqFreshGoodsTmp(Map<String, Object> paramMap)  throws SQLException, Exception;

	/**
	  * getSearchReqGoodsTmpOnly - 공급사 포털 주문요청서 조회
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */	
    List<Map<String, Object>> getSearchReqGoodsTmpOnly(Map<String, Object> paramMap)  throws SQLException, Exception;
    
	/**
	  * insertSelectTempToOrder - 발주TMP에서 발주서마스터 및 상세로 INSERT
	  * @author 손경락
	  * @param paramMap
	  * @return int
	  * @exception SQLException
	  * @exception Exception
	  */	
    public int insertSelectTempToOrder(List<Map<String, Object>> paramMapList, Map<String, Object> paramMap) throws SQLException, Exception;
    
	/**
	  * insertSelectTMPtoPurOrd - 발주마스터insert(T_REQ_GOODS_TMP ->T_PUR_ORD )
	  * @author 손경락
	  * @param paramMap
	  * @return int
	  * @exception SQLException
	  * @exception Exception
	  */	
	public int insertSelectTMPtoPurOrd(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * insertSelectTMPtoPurOrdGoods - 발주마스터상세insert( T_REQ_GOODS_TMP ->T_PUR_ORD_GOODS ) 
	  * @author 손경락
	  * @param paramMap
	  * @return int
	  * @exception SQLException
	  * @exception Exception
	  */	
	public int insertSelectTMPtoPurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * updatePurordAmount - 발주마스터 금액 update 
	  * @author 손경락
	  * @param paramMap
	  * @return int
	  * @exception SQLException
	  * @exception Exception
	  */	
	public int updatePurordAmount(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getPurCurrentOrdSeq - 주문서 SEQUENCE 채번
	  * @author 손경락
	  * @param paramMap
	  * @return Map
	  * @exception SQLException
	  * @exception Exception
	  */	
	Map<String, Object> getPurCurrentOrdSeq(Map<String, Object> paramMap)  throws SQLException, Exception;
    
	/**
	  * getPurExtractOrdSeq - 발주서 SEQUENCE 채번
	  * @author 손경락
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */	    
	String getPurExtractOrdSeq(Map<String, Object> paramMap)  throws SQLException, Exception;
   
	/**
	  * getReservDateSuply - 외부공급사 주문건 입고예정일조회
	  * @author 손경락
	  * @param paramMap
	  * @return Map
	  * @exception SQLException
	  * @exception Exception
	  */	    
    Map<String, Object>  getReservDateSuply(Map<String, Object> paramMap)  throws SQLException, Exception;
	
    /**
	  * getReservDateWinplus - 물류센터주문건 입고예정일조회
	  * @author 손경락
	  * @param paramMap
	  * @return Map
	  * @exception SQLException
	  * @exception Exception
	  */	 
    Map<String, Object>  getReservDateWinplus(Map<String, Object> paramMap)  throws SQLException, Exception;
    
    /**
	  * updateReqGoodsTmpStatus - 주문요청서 처리상태 수정
	  * @author 손경락
	  * @param paramMap
	  * @return int
	  * @exception SQLException
	  * @exception Exception
	  */
    public int updateReqGoodsTmpStatus(Map<String, Object> paramMap) throws SQLException, Exception;
    
    /**
	  * getCreditLoanBAL - 여신잔액조회
	  * @author 손경락
	  * @param paramMap
	  * @return Map
	  * @exception SQLException
	  * @exception Exception
	  */    
	Map<String, Object> getCreditLoanBAL(Map<String, Object> paramMap)  throws SQLException, Exception;	
	
    /**
	  * insertTstdMastCreditLoan - 여신변경이력 insert
	  * @author 손경락
	  * @param paramMap
	  * @return Map
	  * @exception SQLException
	  * @exception Exception
	  */  	
	public int insertTstdMastCreditLoan(Map<String, Object> paramMap) throws SQLException, Exception;
	
}
