package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("OrderRequestService")
public interface OrderRequestService {

	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return int
	 * @description 주문(발주) 요청서 저장 
	 */	
	int insertReqGoodsTmp(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return int
	 * @description 주문(발주) 요청서 갱신
	 */	
	int updateReqGoodsTmp(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return int
	 * @description PDA발주 요청건 상태변경
	 */	
	int updateTpdaTempStatus(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 주문서 리스트 조회
	 */	
	int deleteReqGoodsTmp(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description  CS포털 팝업 주문요청서 조회
	 */	
	List<Map<String, Object>> getSearchReqGoodsCSportal(Map<String, Object> paramMap)  throws SQLException, Exception;

	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 주문서 리스트 조회
	 */	
	List<Map<String, Object>> getSearchReqGoodsTmp(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 신선발주 주문요청서 조회
	 */	
	List<Map<String, Object>> getSearchReqFreshGoodsTmp(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 협력사 포털 주문요청서 조회
	 */	
	List<Map<String, Object>> getSearchReqGoodsTmpOnly(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return int
	 * @description 주문(발주)요청서 저장
	 */	
	int  saveOrdReqGoodsTmp(List<Map<String, Object>> paramMapList, Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return int
	 * @description 주문(발주)요청서 갱신
	 */	
	int  UpdateOrdReqGoodsTmp(List<Map<String, Object>> paramMapList, Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return int
	 * @description 주문(발주)요청에서 발주서 마스터로 INSERT
	 */	
	int insertSelectTempToOrder(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
	
	/* 발주마스터insert(T_REQ_GOODS_TMP ->T_PUR_ORD ) */
	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return int
	 * @description 발주마스터 저장
	 */	
	int insertSelectTMPtoPurOrd(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/* 발주마스터insert( T_REQ_GOODS_TMP ->T_PUR_ORD_GOODS )  */
	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return int
	 * @description 주문(발주)요청에서 발주서 상세로 INSERT
	 */	
	int insertSelectTMPtoPurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return int
	 * @description 발주마스터 금액 update 
	 */	
	int updatePurordAmount(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return Map<String, String>
	 * @description 주문(발주)요청서 SEQUENCE 채번 조회
	 */	
	Map<String, Object> getPurCurrentOrdSeq(Map<String, Object> paramMap)  throws SQLException, Exception;

	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return String
	 * @description 발주서 EQUENCE 채번 조회
	 */	
    String getPurExtractOrdSeq(Map<String, Object> paramMap)  throws SQLException, Exception;
    
	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return Map<String, String>
	 * @description 공급사 납기예정일자 조회
	 */	
    Map<String, Object>  getReservDateSuply(Map<String, Object> paramMap)  throws SQLException, Exception;

	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return Map<String, String>
	 * @description 물류센터 주문건 납기예정일자 조회
	 */	
    Map<String, Object>  getReservDateWinplus(Map<String, Object> paramMap)  throws SQLException, Exception;

	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return int
	 * @description 주문(발주)요청서 상태 갱신
	 */	
    int updateReqGoodsTmpStatus(Map<String, Object> paramMap) throws SQLException, Exception;
    
	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return Map<String, String>
	 * @description 여신잔액조회
	 */	
	Map<String, Object> getCreditLoanBAL(Map<String, Object> paramMap)  throws SQLException, Exception;	

	/**
	 * @author 손경락 
	 * @param paramMap
	 * @return int 
	 * @description 여신잔액 생성
	 */	
	public int insertTstdMastCreditLoan(Map<String, Object> paramMap) throws SQLException, Exception;    
}
