package com.samyang.winplus.sis.report.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("DayByReportService")
public interface DayByReportService {
	List<Map<String, Object>> getSuboolList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	List<Map<String, Object>> getDayByCustmrFeeList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	List<Map<String, Object>> getDayByCustmrFeeSubList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * dayByGoodsGroupVatList - 일_분류별과면세(점포) - 과면세 조회
	 * @author 최지민
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> dayByGoodsGroupVatList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * dayByGoodsGroupVatListTMB - 일_분류별과면세(점포) - 과면세 조회 - 분류별 조회
	 * @author 최지민
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> dayByGoodsGroupVatListTMB(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * dayByDateVatList - 일_일자별과면세(점포) - 과면세 조회
	 * @author 최지민
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> dayByDateVatList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * dayByDateVatListTMB - 일_일자별과면세(점포) - 과면세 조회 - 분류별 조회
	 * @author 최지민
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> dayByDateVatListTMB(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * getDayByGoodsList - 일레포트 - 일_단품별 조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getDayByGoodsList(Map<String, Object> paramMap_info) throws SQLException, Exception;

	/**
	 * getDayByCategoryList - 일레포트 - 일_분류별
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getDayByCategoryList(Map<String, Object> paramMap) throws SQLException, Exception;  

	/**
	 * getDayByCategoryDateList - 일레포트 - 일_분류별일자별
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getDayByCategoryDateList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * getDayByCustmrList - 일레포트 - 협력사별조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getDayByCustmrList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * getDayByCustrmrDetailList - 일레포트 - 협력사별 상세그리드조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getDayByCustrmrDetailList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * getDayByTotalList - 일레포트 - 일별종합 조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getDayByTotalList(Map<String, Object> paramMap) throws SQLException, Exception;

}
