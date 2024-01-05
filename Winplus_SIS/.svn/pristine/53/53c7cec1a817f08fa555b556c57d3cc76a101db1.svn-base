package com.samyang.winplus.sis.sales.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("SalesService")
public interface SalesService {
	
	/**
	  * 판매현황(실시간) - 판매목록 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getSalesByRealtimeList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 판매현황(실시간) - 판매목록 detail 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getSalesByRealtimeDetailList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 판매내역조회(회원) - 내역조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getSalesByMemList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 판매내역조회(회원) - 내역디테일조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getSalesByMemSubList(Map<String, Object> paramMap) throws SQLException, Exception;
	/**
	 * 판매내역조회(회원) - 외상매출결제 입력 추가
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int saveAddTrustSales(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * 판매내역조회(회원) - 외상매출결제 입력 수정
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int saveUpdateTrustSales(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 판매내역조회(회원) - 외상매출결제 입력 삭제
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int saveDeleteTrustSales(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 판매내역조회(회원) - 외상매출결제 프로시저
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int saveProAddTrustSales(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	* 판매현황조회(직영점) - 헤더조회
	* @author 한정훈
	* @param paramMap
	* @return List<Map<String, Object>>
	*/
	List<Map<String, Object>> getsalesByStoreHeaderList(Map<String, Object> paramMap);

	/**
	* 판매현황조회(직영점) - 디테일조회
	* @author 한정훈
	* @param paramMap
	* @return List<Map<String, Object>>
	*/
	List<Map<String, Object>> getsalesByStoreDetailList(Map<String, Object> paramMap);
}
