package com.samyang.winplus.sis.report.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.market.dao.MarketDao;
import com.samyang.winplus.sis.report.dao.DayByReportDao;

@Service("DayByReportService")
public class DayByReportServiceImpl implements DayByReportService{
	
	@Autowired
	DayByReportDao dayByReportDao;
	
	@Autowired
	MarketDao marketDao;
	
	/**
	 * getSuboolList - 일레포트 - 일_일수불 조회
	 * 
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return  List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getSuboolList(Map<String, Object> paramMap) throws SQLException, Exception {
		paramMap.put("searchDateFrom", paramMap.get("searchDateFrom").toString().replaceAll("-", ""));
		paramMap.put("searchDateTo", paramMap.get("searchDateTo").toString().replaceAll("-", ""));
		
		if(paramMap.get("GRUP_CD").equals("ALL") || paramMap.get("GRUP_CD").equals("")) {
			paramMap.put("GRUP_TOP_CD", "0");

		} else {
			Map<String, Object> goods_grup_cd = marketDao.getBargainGoodsSearchTMB(paramMap);
			paramMap.put("GRUP_TOP_CD", goods_grup_cd.get("GRUP_TOP_CD"));
			paramMap.put("GRUP_MID_CD", goods_grup_cd.get("GRUP_MID_CD"));
			paramMap.put("GRUP_BOT_CD", goods_grup_cd.get("GRUP_BOT_CD"));
		}
		
		return dayByReportDao.getSuboolList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getDayByCustmrFeeList(Map<String, Object> paramMap) throws SQLException, Exception {
		return dayByReportDao.getDayByCustmrFeeList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getDayByCustmrFeeSubList(Map<String, Object> paramMap) throws SQLException, Exception {
		return dayByReportDao.getDayByCustmrFeeSubList(paramMap);
		
	}
	
	/**
	* dayByGoodsGroupVatList - 일_분류별과면세(점포) - 과면세 조회 
	* 
	* @author 최지민
	* @param paramMap
	* @return List<Map<String, Object>>
	* @throws SQLException
	* @throws Exception
	*/
	@Override
	public List<Map<String, Object>> dayByGoodsGroupVatList(Map<String, Object> paramMap) throws SQLException, Exception {
		return dayByReportDao.dayByGoodsGroupVatList(paramMap);
		}	
	
	/**
	* dayByGoodsGroupVatListTMB - 일_분류별과면세(점포) - 과면세 조회 - 분류별 조회 
	* 
	* @author 최지민
	* @param paramMap
	* @return  Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@Override
	public Map<String, Object> dayByGoodsGroupVatListTMB(Map<String, Object> paramMap) throws SQLException, Exception {
		return dayByReportDao.dayByGoodsGroupVatListTMB(paramMap);
		}	
	
	/**
	* dayByDateVatList - 일_일자별과면세(점포) - 과면세 조회 
	* 
	* @author 최지민
	* @param paramMap
	* @return List<Map<String, Object>>
	* @throws SQLException
	* @throws Exception
	*/
	@Override
	public List<Map<String, Object>> dayByDateVatList(Map<String, Object> paramMap) throws SQLException, Exception {
		return dayByReportDao.dayByDateVatList(paramMap);
		}	
	
	/**
	* dayByDateVatListTMB - 일_일자별과면세(점포) - 과면세 조회 - 분류별 조회 
	* 
	* @author 최지민
	* @param paramMap
	* @return  Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@Override
	public Map<String, Object> dayByDateVatListTMB(Map<String, Object> paramMap) throws SQLException, Exception {
		return dayByReportDao.dayByGoodsGroupVatListTMB(paramMap);
	}	
	
	/**
	   * getDayByGoodsList - 일레포트 - 일_단품별 조회
	   * 
	   * @author 정혜원
	   * @param Map<String, Object>
	   * @return  List<Map<String, Object>>
	   * @throws SQLException
	   * @throws Exception
	   */
	@Override
	public List<Map<String, Object>> getDayByGoodsList(Map<String, Object> paramMap_info) throws SQLException, Exception {
		if(paramMap_info.get("GRUP_CD").equals("ALL") || paramMap_info.get("GRUP_CD").equals("")) {
			paramMap_info.put("GRUP_TOP_CD", "0");

		} else {
			Map<String, Object> goods_grup_cd = marketDao.getBargainGoodsSearchTMB(paramMap_info);
			paramMap_info.put("GRUP_TOP_CD", goods_grup_cd.get("GRUP_TOP_CD"));
			paramMap_info.put("GRUP_MID_CD", goods_grup_cd.get("GRUP_MID_CD"));
			paramMap_info.put("GRUP_BOT_CD", goods_grup_cd.get("GRUP_BOT_CD"));
		}
		return dayByReportDao.getDayByGoodsList(paramMap_info);
	}
	
	/**
	 * getDayByCategoryList - 일레포트 - 일_분류별
	 * 
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return  List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getDayByCategoryList(Map<String, Object> paramMap) throws SQLException, Exception {
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
		return dayByReportDao.getDayByCategoryList(paramMap);
	}
	
	/**
	   * getDayByCategoryDateList - 일레포트 - 일_분류별일자별
	   * 
	   * @author 정혜원
	   * @param Map<String, Object>
	   * @return  List<Map<String, Object>>
	   * @throws SQLException
	   * @throws Exception
	   */
	@Override
	public List<Map<String, Object>> getDayByCategoryDateList(Map<String, Object> paramMap) throws SQLException, Exception {
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
		return dayByReportDao.getDayByCategoryDateList(paramMap);
	}
	
	/**
	 * getDayByCustmrList - 일레포트 - 협력사별조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getDayByCustmrList(Map<String, Object> paramMap) throws SQLException, Exception{
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
		return dayByReportDao.getDayByCustmrList(paramMap);
	}
	
	/**
	 * getDayByCustrmrDetailList - 일레포트 - 협력사별 상세그리드조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getDayByCustrmrDetailList(Map<String, Object> paramMap) throws SQLException, Exception{
		return dayByReportDao.getDayByCustrmrDetailList(paramMap);
	}
	
	/**
	 * getDayByTotalList - 일레포트 - 일별종합 그리드조회
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getDayByTotalList(Map<String, Object> paramMap) throws SQLException, Exception {
		paramMap.put("searchDateFrom", paramMap.get("searchDateFrom").toString().replaceAll("-", ""));
		paramMap.put("searchDateTo", paramMap.get("searchDateTo").toString().replaceAll("-", ""));
		return dayByReportDao.getDayByTotalList(paramMap);
	}
}

