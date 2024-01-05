package com.samyang.winplus.sis.report.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.market.dao.MarketDao;
import com.samyang.winplus.sis.report.dao.MonByReportDao;

@Service("MonByReportService")
public class MonByReportServiceImpl implements MonByReportService{

	@Autowired
	MonByReportDao monByReportDao;
	
	@Autowired
	MarketDao marketDao;
	
	/**
	 * getMonByGoodsList - 월_단품별 조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getMonByGoodsList(Map<String, Object> paramMap) throws SQLException, Exception{
		paramMap.put("searchDateFrom", paramMap.get("searchDateFrom").toString().replaceAll("-", ""));
		paramMap.put("searchDateTo", paramMap.get("searchDateTo").toString().replaceAll("-", ""));
		if(paramMap.get("GRUP_CD").equals("ALL") || paramMap.get("GRUP_CD").equals("")) {
			paramMap.put("GRUP_TOP_CD", "0");
			paramMap.put("GRUP_MID_CD", "0");
			paramMap.put("GRUP_BOT_CD", "0");

		} else {
			Map<String, Object> goods_grup_cd = marketDao.getBargainGoodsSearchTMB(paramMap);
			paramMap.put("GRUP_TOP_CD", goods_grup_cd.get("GRUP_TOP_CD"));
			paramMap.put("GRUP_MID_CD", goods_grup_cd.get("GRUP_MID_CD"));
			paramMap.put("GRUP_BOT_CD", goods_grup_cd.get("GRUP_BOT_CD"));
		}
		
		return monByReportDao.getMonByGoodsList(paramMap);
	}
	
	/**
	 * getMonByGoodsList - 월_협력사별 조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getMonByCustmrList(Map<String, Object> paramMap) throws SQLException, Exception{
		paramMap.put("searchDateFrom", paramMap.get("searchDateFrom").toString().replaceAll("-", ""));
		paramMap.put("searchDateTo", paramMap.get("searchDateTo").toString().replaceAll("-", ""));
		if(paramMap.get("GRUP_CD").equals("ALL") || paramMap.get("GRUP_CD").equals("")) {
			paramMap.put("GRUP_TOP_CD", "0");
			paramMap.put("GRUP_MID_CD", "0");
			paramMap.put("GRUP_BOT_CD", "0");

		} else {
			Map<String, Object> goods_grup_cd = marketDao.getBargainGoodsSearchTMB(paramMap);
			paramMap.put("GRUP_TOP_CD", goods_grup_cd.get("GRUP_TOP_CD"));
			paramMap.put("GRUP_MID_CD", goods_grup_cd.get("GRUP_MID_CD"));
			paramMap.put("GRUP_BOT_CD", goods_grup_cd.get("GRUP_BOT_CD"));
		}
		return monByReportDao.getMonByCustmrList(paramMap);
	}
	
	/**
	 * getMonByCustrmrDetailList - 월_협력사별 상세조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getMonByCustrmrDetailList(Map<String, Object> paramMap) throws SQLException, Exception{
		return monByReportDao.getMonByCustrmrDetailList(paramMap);
	}
	
	/**
	 * getMonByCategoryList - 월_분류별조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getMonByCategoryList(Map<String, Object> paramMap) throws SQLException, Exception{
		paramMap.put("searchDateFrom", paramMap.get("searchDateFrom").toString().replaceAll("-", ""));
		paramMap.put("searchDateTo", paramMap.get("searchDateTo").toString().replaceAll("-", ""));
		if(paramMap.get("GRUP_CD").equals("ALL") || paramMap.get("GRUP_CD").equals("")) {
			paramMap.put("GRUP_TOP_CD", "0");
			paramMap.put("GRUP_MID_CD", "0");
			paramMap.put("GRUP_BOT_CD", "0");

		} else {
			Map<String, Object> goods_grup_cd = marketDao.getBargainGoodsSearchTMB(paramMap);
			paramMap.put("GRUP_TOP_CD", goods_grup_cd.get("GRUP_TOP_CD"));
			paramMap.put("GRUP_MID_CD", goods_grup_cd.get("GRUP_MID_CD"));
			paramMap.put("GRUP_BOT_CD", goods_grup_cd.get("GRUP_BOT_CD"));
		}
		
		return monByReportDao.getMonByCategoryList(paramMap);
	}
	
	/**
	 * getMonByTotalList - 월_월별종합 조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getMonByTotalList(Map<String, Object> paramMap) throws SQLException, Exception{
		paramMap.put("searchDateFrom", paramMap.get("searchDateFrom").toString().replaceAll("-", ""));
		paramMap.put("searchDateTo", paramMap.get("searchDateTo").toString().replaceAll("-", ""));
		return monByReportDao.getMonByTotalList(paramMap);
	}

}
