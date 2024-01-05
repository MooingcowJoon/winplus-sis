package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("OrderInputGridPopupService")
public interface OrderInputGridPopupService {
	
	int insertTpurOrd(Map<String, Object> paramMap) throws SQLException, Exception;
	int insertTpurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int updateTpurOrd(Map<String, Object> paramMap) throws SQLException, Exception;
	int updateTpurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int deleteTpurOrd(Map<String, Object> paramMap) throws SQLException, Exception;
	int deleteTpurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception;

	Map<String, Object>  saveTpurOrdGoodsScreenList(List<Map<String, Object>> paramMapList, Map<String, Object> paramMap) throws SQLException, Exception;
	
	int getTpurOrdCount(Map<String, Object> paramMap) throws SQLException, Exception;
	
	String GetOrderNumber(Map<String, Object> paramMap) throws SQLException, Exception;
   
	/* 상품가격정보에서 최저가 가져오기 */
	List<Map<String, Object>> getSearchMasterBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception;	
  
	/* PDA수신리스트를 기준으로 최저가 가져오기 */
	List<Map<String, Object>> getSearchPdaOrderBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception;	
	
	/* 주문서복사용 주문서기준으로 현재 센터 최저가적용후 가져오기 */ 
	List<Map<String, Object>> getSearchOrderDetailListCopy2(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/* 거래처포털  바코드 전문(취급)점 센터주문 최저가 가져오기) */
	List<Map<String, Object>> getSearchMasterBarcodeCustmrPriceList(Map<String, Object> paramMap)  throws SQLException, Exception;	
	
	/* 거래처포털 센터주문 상품기준 최저 구매가격 가져오기  */
	List<Map<String, Object>> getSearchMasterBarcodeCustomerLowestPriceList(Map<String, Object> paramMap)  throws SQLException, Exception;	

	/* 거래처포털 교한반품 최저가 가져오기  */
	List<Map<String, Object>> getReturnMasterBarcodeLowestPriceList(Map<String, Object> paramMap)  throws SQLException, Exception;	

	/**
	 * getBanpumBarcodePriceList - cs포털 일반반품 최저가 가져오기
	 */	
	List<Map<String, Object>> getBanpumBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception;	

	/**
	 * getBanpumMkBarcodePriceList -직영점 센터반품건의 최저구매가격 가져오기
	 */	
	List<Map<String, Object>> getBanpumMkBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception;	

	/**
	 * getBanpumOutBarcodePriceList - 직발 반품건의 최저구매가격 가져오기
	 */	
	List<Map<String, Object>> getBanpumOutBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception;		
	
	/* 센터 착지변경 2차발주 대상 및 최저가 가져오기  */
	List<Map<String, Object>> getSearchCHGOrderBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception;	
	
	/**
	  * 발주(주문)관리  출고예정 정보를 WMS로 전송한다
	  * @author 손경락
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int SP_WMS_SEND_ORD_SALE(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 발주(주문)관리  출고예정 정보를 WMS로 전송한다
	  * @author 손경락
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	 Map<String, Object> SP_WMS_SEND_ORD_SALE(List<Map<String, Object>> paramMapList ) throws SQLException, Exception;

	/**
	  *  발주(주문)관리  입고예정 정보를 WMS로 전송한다
	  * @author 손경락
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int SP_WMS_SEND_ONLINE_ORD(Map<String, Object> paramMap) throws SQLException, Exception;	
}
