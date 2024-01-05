package com.samyang.winplus.sis.market.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.market.dao.TellOrderDao;

@Service("TellOrder")
public class TellOrderServiceImpl implements TellOrderService{
	
	@Autowired
	TellOrderDao tellOrderDao;

	/**
	 * getCIDMemberList - 점포업무관리 - 판매관리 - 전화주문 - 전화번호로 회원목록 검색
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getCIDMemberList(Map<String, Object> paramMap) throws SQLException, Exception {
		return tellOrderDao.getCIDMemberList(paramMap);
	}
	
	/**
	  * getCIDMemberInfo - 점포업무관리 - 판매관리 - 전화주문 - 회원정보검색
	  * @author 정혜원
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getCIDMemberInfo(Map<String, Object> paramMap) 
			throws SQLException, Exception{
		return tellOrderDao.getCIDMemberInfo(paramMap);
	}
	
	/**
	  * getMemOrderHeaderList - 점포업무관리 - 판매관리 - 전화주문 - 회원 주문내역 헤더조회
	  * @author 정혜원
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getMemOrderHeaderList(Map<String, Object> paramMap) 
			throws SQLException, Exception{
		return tellOrderDao.getMemOrderHeaderList(paramMap);
	}
	
	/**
	 * getMemOrderSummaryInfo - 점포업무관리 - 판매관리 - 전화주문 - 회원 주문내역 summary 조회
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getMemOrderSummaryInfo(Map<String, Object> paramMap) throws SQLException, Exception{
		return tellOrderDao.getMemOrderSummaryInfo(paramMap);
	}
	
	/**
	  * getMemOrderDetailList - 점포업무관리 - 판매관리 - 전화주문 - 회원 주문내역 디테일조회
	  * @author 정혜원
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getMemOrderDetailList(Map<String, Object> paramMap) 
			throws SQLException, Exception{
		return tellOrderDao.getMemOrderDetailList(paramMap);
	}
	
	/**
	 * receiptMemOrderList - 점포업무관리 - 판매관리 - 전화주문 - 주문접수완료 처리
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @exception SQLException
	 * @exception Exception
	 */
	@Override
	public int receiptMemOrderList(Map<String, Object> paramMap) throws SQLException, Exception{
		return tellOrderDao.receiptMemOrderList(paramMap);
	}
	
	/**
	 * reOrderMemOrderList - 점포업무관리 - 판매관리 - 전화주문 - 주문취소건 재주문 완료 처리
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @exception SQLException
	 * @exception Exception
	 */
	@Override
	public int reOrderMemOrderList(Map<String, Object> paramMap) throws SQLException, Exception{
		return tellOrderDao.reOrderMemOrderList(paramMap);
	}
	
	/**
	  * cancelMemOrderList - 점포업무관리 - 판매관리 - 전화주문 - 회원 주문취소
	  * @author 정혜원
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int cancelMemOrderList(Map<String, Object> paramMap) throws SQLException, Exception{
		return tellOrderDao.cancelMemOrderList(paramMap);
	}
	
	/**
	* getNewOrderListInfo -새주문서작성팝업 - 상품검색 추가정보조회
	* 
	* @author 최지민
	* @param paramMap
	* @return List<Map<String, Object>>
	* @throws SQLException
	* @throws Exception
	*/
	@Override
	public List<Map<String, Object>> getNewOrderListInfo(Map<String, Object> paramMap) throws SQLException, Exception {
		return tellOrderDao.getNewOrderListInfo(paramMap);
	}
	
	/**
	 * saveNewOrderPopupList -새주문서작성팝업 - 상품내역 저장
	 * 
	 * @author 정혜원
	 * @param paramMapList
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> saveNewOrderPopupList(List<Map<String, Object>> paramMapList) throws SQLException, Exception{
		int DetailResultRow = 0;
		int HeaderResultRow = 0;
		String TEL_ORD_CD = "";
		String ORD_TYPE = "1";		// ORD_CHAN_TYPE 1 전화
		String ORD_STATE = "O1";	// O1 최초주문접수
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> HeaderParamMap = new HashMap<String, Object>();
		Map<String, Object> returnMap = new HashMap<String, Object>();

		for(Map<String, Object> paramMap : paramMapList){
			resultMap = tellOrderDao.saveNewOrderPopupList(paramMap);
			DetailResultRow += Integer.parseInt(resultMap.get("RESULT_CNT").toString());
			TEL_ORD_CD = resultMap.get("TEL_ORD_CD").toString();
		}
		
		HeaderParamMap = paramMapList.get(0);
		HeaderParamMap.put("TEL_ORD_CD", TEL_ORD_CD);
		HeaderParamMap.put("ORD_TYPE", ORD_TYPE);
		HeaderParamMap.put("ORD_STATE", ORD_STATE);
		HeaderResultRow = tellOrderDao.saveNewOrderHeader(HeaderParamMap);
		
		returnMap.put("DetailResultRow", DetailResultRow);
		returnMap.put("TEL_ORD_CD", HeaderParamMap.get("TEL_ORD_CD"));
		returnMap.put("HeaderResultRow", HeaderResultRow);
		
		return returnMap;
	}

	/**
	   * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> getOrderListByGroup(Map<String, Object> paramMap) {
		return tellOrderDao.getOrderListByGroup(paramMap);
	}

	/**
	   * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 조회
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@Override
	public Map<String, Object> getMemdata(Map<String, Object> paramMap) {
		return tellOrderDao.getMemdata(paramMap);
	}

	/**
	   * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> getOrderByDate(Map<String, Object> paramMap) {
		return tellOrderDao.getOrderByDate(paramMap);
	}

	/**
	  * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 저장
	  * @author 한정훈
	  * @param request
	  * @return void
	  */
	@Override
	public void saveTellOrderDetailPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		for(Map<String, Object> map : ((List<Map<String, Object>>) paramMap.get("C"))){
			tellOrderDao.insertTellOrderDetail(map);
		}
		
		for(Map<String, Object> map : ((List<Map<String, Object>>) paramMap.get("U"))){
			tellOrderDao.updateTellOrderDetail(map);
		}
		
		for(Map<String, Object> map : ((List<Map<String, Object>>) paramMap.get("D"))){
			tellOrderDao.deleteTellOrderDetail(map);
		}
	}

	/**
	  * 판매관리 - 전화주문관리(직영점) - 주문서조회(전화) - 팝업 - 배송일 저장
	  * @author 한정훈
	  * @param paramMap
	  * @return Map<String, Object>
	  */
	@Override
	public Map<String, Object> updateTellOrderOutWareDate(Map<String, Object> paramMap) {
		return tellOrderDao.updateTellOrderOutWareDate(paramMap);
	}
	
	/**
	 * getDeliOrdCdSeq -새주문서작성팝업 - 주문번호 채번
	 * @author 강신영
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public String getDeliOrdCdSeq() throws SQLException, Exception {
		return tellOrderDao.getDeliOrdCdSeq();
	}
	
	/**
	 * saveOpenNewOrderPopupList -새주문서작성팝업 - 전화주문 저장
	 * @author 강신영
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> saveOpenNewOrderPopupList(Map<String, Object> paramMap) throws SQLException, Exception {
		return tellOrderDao.saveOpenNewOrderPopupList(paramMap);
	}
	
	/**
	 * saveOpenNewOrderPopupHeader -새주문서작성팝업 - 전화주문 저장(헤더)
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int saveOpenNewOrderPopupHeader(Map<String, Object> paramMap) throws SQLException, Exception {
		return tellOrderDao.saveOpenNewOrderPopupHeader(paramMap);
	}
	
	/**
	 * getDeliOrderDetail -새주문서작성팝업 - 전화주문 정보 상세
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getDeliOrderDetail(Map<String, Object> paramMap) throws SQLException, Exception {
		return tellOrderDao.getDeliOrderDetail(paramMap);
	}
	
	/**
	 * getDeliOrderHeader -새주문서작성팝업 - 전화주문 정보 헤더
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getDeliOrderHeader(Map<String, Object> paramMap) throws SQLException, Exception {
		return tellOrderDao.getDeliOrderHeader(paramMap);
	}
}
