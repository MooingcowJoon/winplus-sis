package com.samyang.winplus.sis.sales.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;


public interface OnlineManagementDao {
	
	/**
	 * @author 한정훈
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 주문서 리스트 조회
	 */
	List<Map<String, Object>> getOnlineOrderList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * @author 한정훈
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 주문서 상세리스트 조회
	 */
	List<Map<String, Object>> getopenOnlineOrderDetail(Map<String, String> paramMap) throws SQLException, Exception;

	/**
	 * @author 한정훈
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 판매관리 - 판매관리(온라인) - 주문서등록(온라인) 엑셀업로드
	 */
	List<Map<String, Object>> getOnlineOrdersInfo(List<Map<String, Object>> ListMap);

	/**
	 * @author 한정훈
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 판매관리 - 판매관리(온라인) - 주문서등록(온라인) 엑셀양식조회
	 */
	List<Map<String, Object>> getOnlineOrderExcelList(Map<String, Object> paramMap);

	/**
	 * @author 한정훈
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 판매관리 - 판매관리(온라인) - 판매내역(온라인) 조회
	 */
	List<Map<String, Object>> getOSHistoryList(Map<String, Object> paramMap);

	/**
	  * 판매관리 - 판매관리(온라인) - 주문서등록(온라인) 저장-추가
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  */
	int insertOnlineOrderList(Map<String, Object> paramMap);

	/**
	  * 판매관리 - 판매관리(온라인) - 주문서등록(온라인) 저장-수정
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  */
	int updateOnlineOrderList(Map<String, Object> paramMap);

	/**
	  * 판매관리 - 판매관리(온라인) - 주문서등록(온라인) 저장-삭제
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  */
	int deleteOnlineOrderList(Map<String, Object> paramMap);

	/**
	  * 판매관리 - 판매관리(온라인) - 주문서등록(온라인) 저장 프로시저 호출
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  */
	int saveOnlineOrderList(String crud);
	/**
	  * 판매관리 - 판매관리(온라인) - 주문서등록(온라인) 엑셀 업로드 B2C
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  */
	List<Map<String, Object>> getOnlineSalesB2CInfo(Map<String, Object> paramMap);

	/**
	  * 판매관리 - 판매관리(온라인) - 주문서등록(온라인) 엑셀 업로드 B2B
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  */
	List<Map<String, Object>> getOnlineSalesB2BInfo(Map<String, Object> paramMap);

	void deletetmpList();
	
	/**
	  * 판매관리 - 판매관리(온라인) - 판매내역(온라인) 엑셀업로드(구매확정)
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> getPurFixInfo(Map<String, Object> paramMap);

	/**
	  * 판매관리 - 판매관리(온라인) - 판매내역(온라인) 저장 - 수정
	  * @author 한정훈
	  * @param request
	  * @return integer
	  */
	List<Map<String, Object>> updateOnlineHistoryList(Map<String, Object> paramMap);

	/**
	 * 판매관리 - 판매관리(온라인) - 판매확정(온라인) 헤더 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, String>>
	  */
	List<Map<String, Object>> getOnlineFixList(Map<String, Object> paramMap);

	/**
	 * 판매관리 - 판매관리(온라인) - 판매확정(온라인) 디테일 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, String>>
	  */
	List<Map<String, Object>> getOnlineFixDetailList(Map<String, Object> paramMap);

	/**
	  * 판매관리 - 판매관리(온라인) - 판매확정(온라인) 저장
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> saveOnlineFixList(Map<String, String> paramMap);

	/**
	  * 판매관리 - 판매관리(온라인) - 판매확정(온라인) 디테일 저장(U)
	  * @author 한정훈
	  * @param request
	  * @return integer
	  */
	int updateOSFDList(Map<String, Object> paramMap);

	/**
	  * 판매관리 - 판매관리(온라인) - 주문서 등록(온라인) - WMS전송
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> TransmissionToWMS(Map<String, Object> paramMap);
}
