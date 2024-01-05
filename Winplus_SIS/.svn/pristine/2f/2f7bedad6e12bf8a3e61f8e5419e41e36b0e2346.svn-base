package com.samyang.winplus.sis.price.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface PriceReservationDao {

	/**
	  * getPriceReservationHeaderList - 가격변경예약(직영점) - 가격변경예약 헤더 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getPriceReservationHeaderList(Map<String, String> paramMap);

	/**
	  * updatePriceReservationHeader - 가격변경예약(직영점) - 가격변경예약 헤더 저장
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> updatePriceReservationHeader(Map<String, Object> paramMap);

	/**
	  * getPriceReservationDetailList - 가격변경예약(직영점) - 가격변경예약 디테일 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getPriceReservationDetailList(Map<String, String> paramMap);

	/**
	  * updatePriceReservationDetailList - 가격변경예약(직영점) - 가격변경예약 디테일 저장
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> updatePriceReservationDetailList(Map<String, Object> paramMap);

	/**
	  * getPriceInformation - 가격변경예약(직영점) - 가격정보 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	Map<String, Object> getPriceInformation(Map<String, Object> paramMap);

	/**
	  * getPriceScheduleList - 가격변경예정조회 - 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	List<Map<String, Object>> getPriceScheduleList(Map<String, String> paramMap);
}
