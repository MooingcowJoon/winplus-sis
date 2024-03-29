package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("OrderSearchService")
public interface OrderSearchService {
	/**
	  * getSearchBaljooList - 발주서조회(자기조직기준)
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */	
	List<Map<String, Object>> getSearchBaljooList(Map<String, Object> paramMap)   throws SQLException, Exception;
	
	/**
	  * getRequestOrderList - CS포털 주문서조회 
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */
	 List<Map<String, Object>> getRequestOrderList(Map<String, Object> paramMap)  throws SQLException, Exception;

	/**
	  * getOrderManagement - 주문서 목록 조회
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getOrderManagement(Map<String, Object> paramMap)   throws SQLException, Exception;
	
	/**
	  * getSearchOrderList - 발주서 목록 조회
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getSearchOrderList(Map<String, Object> paramMap)   throws SQLException, Exception;	
	/**
	  * getSearchOrderDetailList - 발주서상세조회
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */		
	List<Map<String, Object>> getSearchOrderDetailList(Map<String, Object> paramMap)   throws SQLException, Exception;
	
	/**
	  * getSearchOrderDetailListCopy - 기존발주서상세 복사
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */	
	List<Map<String, Object>> getSearchOrderDetailListCopy(Map<String, Object> paramMap)   throws SQLException, Exception;
	
	/**
	  * getGoodsTreeComboList - 상품 대중소 분류 comobo조회
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */	
	List<Map<String, Object>> getGoodsTreeComboList(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/**
	  * getSecondOrderList - 2차 발주목록 조회
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */	
	List<Map<String, Object>> getSecondOrderList(Map<String, Object> paramMap)   throws SQLException, Exception;
	
	/**
	  * getGoodsTreeList - 상품 대중소 분류 조회
	  * @author 손경락
	  * @param paramMap
	  * @return List
	  * @exception SQLException
	  * @exception Exception
	  */	
	Map<String, Object> getGoodsTreeList(Map<String, Object> paramMap)  throws SQLException, Exception;

	/**
	  * getGroupCdFromTreeID - 그룹에서 선택된 TREE ID구하가
	  * @author 손경락
	  * @param paramMap
	  * @return Map
	  * @exception SQLException
	  * @exception Exception
	  */	
	Map<String, Object> getGroupCdFromTreeID(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/**
	  * getBusinessDay - 외부협력사 영업일 구하기
	  * @author 손경락
	  * @param paramMap
	  * @return Map
	  * @exception SQLException
	  * @exception Exception
	  */	
	Map<String, Object> getBusinessDay(Map<String, Object> paramMap)   throws SQLException, Exception;
	
	/**
	  * getOrderDeadTimeLeadTime - 상품별( 일배,신선 발주마감시간) 구하기
	  * @author 손경락
	  * @param paramMap
	  * @return Map
	  * @exception SQLException
	  * @exception Exception
	  */	
	Map<String, Object> getOrderDeadTimeLeadTime(Map<String, Object> paramMap)   throws SQLException, Exception;
	
	/**
	  * getLoginOrgInfo - 로그인정보( 윈플러스, 팜 상호, LOGIN조직, 발주마감시간 LEAD TIME) 구하기
	  * @author 손경락
	  * @param paramMap
	  * @return Map
	  * @exception SQLException
	  * @exception Exception
	  */	
	Map<String, Object> getLoginOrgInfo(Map<String, Object> paramMap)   throws SQLException, Exception;
	
	/**
	  * getSelectedOrgInfo - 선택된 조직정보 구하기
	  * @author 손경락
	  * @param paramMap
	  * @return Map
	  * @exception SQLException
	  * @exception Exception
	  */	
	Map<String, Object> getSelectedOrgInfo(Map<String, Object> paramMap)   throws SQLException, Exception;
	
	/**
	  * getOrderCloseTime - 거개처코드에서 직영점,취급점의 일반상품  발주마감시간 구하기
	  * @author 손경락
	  * @param paramMap
	  * @return Map
	  * @exception SQLException
	  * @exception Exception
	  */	
	Map<String, Object> getOrderCloseTime(Map<String, Object> paramMap)   throws SQLException, Exception;
	
}
