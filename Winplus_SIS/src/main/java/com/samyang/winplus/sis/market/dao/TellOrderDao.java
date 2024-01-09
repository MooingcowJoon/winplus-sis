package com.samyang.winplus.sis.market.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface TellOrderDao {

	/**
	 * getCIDMemberList - 점포업무관리 - 판매관리 - 전화주문 - 전화번호로 회원목록 검색
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getCIDMemberList(Map<String, Object> paramMap);
	
	/**
	  * getCIDMemberInfo - 점포업무관리 - 판매관리 - 전화주문 - 회원정보검색
	  * @author 정혜원
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getCIDMemberInfo(Map<String, Object> paramMap);
	
	/**
	  * getMemOrderHeaderList - 점포업무관리 - 판매관리 - 전화주문 - 회원 주문내역 헤더조회
	  * @author 정혜원
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getMemOrderHeaderList(Map<String, Object> paramMap);
	
	/**
	 * getMemOrderSummaryInfo - 점포업무관리 - 판매관리 - 전화주문 - 회원 주문내역 summary 조회
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 */
	Map<String, Object> getMemOrderSummaryInfo(Map<String, Object> paramMap);
	
	/**
	 * getMemOrderDetailList - 점포업무관리 - 판매관리 - 전화주문 - 회원 주문내역 디테일조회
	 * @author 정혜원
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @exception SQLException
	 * @exception Exception
	 */
	List<Map<String, Object>> getMemOrderDetailList(Map<String, Object> paramMap);
	
	/**
	 * receiptMemOrderList - 점포업무관리 - 판매관리 - 전화주문 - 주문접수완료 처리
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @exception SQLException
	 * @exception Exception
	 */
	int receiptMemOrderList(Map<String, Object> paramMap);
	
	/**
	 * reOrderMemOrderList - 점포업무관리 - 판매관리 - 전화주문 - 주문취소건 재주문 완료 처리
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @exception SQLException
	 * @exception Exception
	 */
	int reOrderMemOrderList(Map<String, Object> paramMap);
	
	/**
	 * cancelMemOrderList - 점포업무관리 - 판매관리 - 전화주문 - 회원 주문취소
	 * @author 정혜원
	 * @param paramMap
	 * @return Integer
	 * @exception SQLException
	 * @exception Exception
	 */
	int cancelMemOrderList(Map<String, Object> paramMap);
	
	/**
	 * getNewOrderListInfo - 새주문서작성팝업 - 상품검색 추가정보조회
	 * 
	 * @author 최지민
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getNewOrderListInfo(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * saveNewOrderPopupList - 새주문서작성팝업 - 상품내역 저장
	 * 
	 * @author 정혜원
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> saveNewOrderPopupList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * saveNewOrderPopupList - 새주문서작성팝업 - 전화주문MAST 저장
	 * 
	 * @author 정혜원
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	int saveNewOrderHeader(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	   * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> getOrderListByGroup(Map<String, Object> paramMap);

	/**
	   * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 조회1
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  */
	Map<String, Object> getMemdata(Map<String, Object> paramMap);

	/**
	   * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 조회2
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> getOrderByDate(Map<String, Object> paramMap);

	/**
	   * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 C
	  * @author 한정훈
	  * @param request
	  * @return void
	  */
	void insertTellOrderDetail(Map<String, Object> map);

	/**
	   * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 U
	  * @author 한정훈
	  * @param request
	  * @return void
	  */
	void updateTellOrderDetail(Map<String, Object> map);

	/**
	   * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 D
	  * @author 한정훈
	  * @param request
	  * @return void
	  */
	void deleteTellOrderDetail(Map<String, Object> map);
	
	/**
	  * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 - 배송일 저장
	  * @author 한정훈
	  * @param paramMap
	  * @return Map<String, Object>
	  */
	Map<String, Object> updateTellOrderOutWareDate(Map<String, Object> paramMap);
	
	/**
	 * getDeliOrdCdSeq -새주문서작성팝업 - 주문번호 채번
	 * @author 강신영
	 * @return String
	 */
	String getDeliOrdCdSeq();
	
	/**
	 * saveOpenNewOrderPopupList -새주문서작성팝업 - 전화주문 저장
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 */
	Map<String, Object> saveOpenNewOrderPopupList(Map<String, Object> paramMap);
	
	/**
	 * saveOpenNewOrderPopupHeader -새주문서작성팝업 - 전화주문 저장(헤더)
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 */
	int saveOpenNewOrderPopupHeader(Map<String, Object> paramMap);
	
	/**
	 * getDeliOrderDetail -새주문서작성팝업 - 전화주문 정보 상세
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 */
	List<Map<String, Object>> getDeliOrderDetail(Map<String, Object> paramMap);
	
	/**
	 * getDeliOrderHeader -새주문서작성팝업 - 전화주문 정보 헤더
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 */
	Map<String, Object> getDeliOrderHeader(Map<String, Object> paramMap);
}