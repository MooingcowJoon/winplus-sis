package com.samyang.winplus.sis.price.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.price.dao.PriceReservationDao;

@Service("PriceReservationService")
public class PriceReservationServiceImpl implements PriceReservationService {
	
	@Autowired
	PriceReservationDao priceReservationDao;

	/**
	  * getPriceReservationHeaderList - 가격변경예약(직영점) - 가격변경예약 헤더 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getPriceReservationHeaderList(Map<String, String> paramMap) throws SQLException, Exception {
		return priceReservationDao.getPriceReservationHeaderList(paramMap);
	}

	/**
	  * updatePriceReservationHeader - 가격변경예약(직영점) - 가격변경예약 헤더 저장
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> updatePriceReservationHeader(Map<String, Object> paramMap) throws SQLException, Exception {
		return priceReservationDao.updatePriceReservationHeader(paramMap);
	}

	/**
	  * getPriceReservationDetailList - 가격변경예약(직영점) - 가격변경예약 디테일 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getPriceReservationDetailList(Map<String, String> paramMap) throws SQLException, Exception {
		return priceReservationDao.getPriceReservationDetailList(paramMap);
	}

	/**
	  * updatePriceReservationDetailList - 가격변경예약(직영점) - 가격변경예약 디테일 저장
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> updatePriceReservationDetailList(Map<String, Object> paramMap) throws SQLException, Exception {
		return priceReservationDao.updatePriceReservationDetailList(paramMap);
	}

	/**
	  * getPriceInformation - 가격변경예약(직영점) - 가격정보 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@Override
	public Map<String, Object> getPriceInformation(Map<String, Object> paramMap) throws SQLException, Exception {
		return priceReservationDao.getPriceInformation(paramMap);
	}

	/**
	  * getPriceScheduleList - 가격변경예정조회 - 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@Override
	public List<Map<String, Object>> getPriceScheduleList(Map<String, String> paramMap) throws SQLException, Exception {
		return priceReservationDao.getPriceScheduleList(paramMap);
	}

}
