package com.samyang.winplus.sis.price.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.samyang.winplus.common.system.util.LoofInterface;
import com.samyang.winplus.common.system.util.LoofUtilObject;
import com.samyang.winplus.sis.price.dao.GoodsCenterEventPriceDao;

@Service("GoodsCenterEventPriceService")
public class GoodsCenterEventPriceServiceImpl implements GoodsCenterEventPriceService {

	@Autowired
	GoodsCenterEventPriceDao goodsCenterEventPriceDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public List<Map<String, Object>> getCenterEventList(Map<String, String> paramMap) throws SQLException, Exception {
		return goodsCenterEventPriceDao.getCenterEventList(paramMap);
	}

	@Override
	public int insertCenterEventList(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		int resultRow = 0;

		for(Map<String, Object> paramMap : paramMapList){
			resultRow += goodsCenterEventPriceDao.insertCenterEventList(paramMap);
		}
		return resultRow;
	}

	@Override
	public List<Map<String, Object>> getCenterEventGoodsInfo(Map<String, Object> paramMap) {
		LoofUtilObject l = new LoofUtilObject();
		List<Map<String, Object>> lm = null;
		lm = l.selectAfterLoofBigList((List<String>) paramMap.get("loadGoodsList"), new LoofInterface() {
			@Override
			public Object exec(Object... obj) {
				return goodsCenterEventPriceDao.getCenterEventGoodsInfo((List<String>) obj[0]);
			}
		});
		return lm;
	}

	@Transactional
	@Override
	public void crudCenterEventGoodsList(Map<String, Object> paramMap) {
		LoofUtilObject l = new LoofUtilObject();
		l.loofBigListMapByCRUD(paramMap, new LoofInterface() {
			@Override
			public Object exec(Object...obj) {
				goodsCenterEventPriceDao.insertCenterEventGoodsList((List<Map<String, Object>>) obj[0]);
				goodsCenterEventPriceDao.updateCenterEventGoodsList((List<Map<String, Object>>) obj[2]);
				goodsCenterEventPriceDao.deleteCenterEventGoodsList((List<Map<String, Object>>) obj[3]);
				return null;
			}
		});
	}
	
	@Transactional
	@Override
	public void crudCenterEventGoodsPurList(Map<String, Object> paramMap) {
		LoofUtilObject l = new LoofUtilObject();
		l.loofBigListMapByCRUD(paramMap, new LoofInterface() {
			@Override
			public Object exec(Object...obj) {
				goodsCenterEventPriceDao.insertCenterEventGoodsPurList((List<Map<String, Object>>) obj[0]);
				goodsCenterEventPriceDao.updateCenterEventGoodsPurList((List<Map<String, Object>>) obj[2]);
				goodsCenterEventPriceDao.deleteCenterEventGoodsPurList((List<Map<String, Object>>) obj[3]);
				return null;
			}
		});
	}

	@Override
	public List<Map<String, Object>> getCenterEventGoodsList(Map<String, Object> paramMap) {
		return goodsCenterEventPriceDao.getCenterEventGoodsList(paramMap);
	}

	@Override
	public List<Map<String, Object>> getCenterEventCustmrInfo(Map<String, Object> paramMap) {
		LoofUtilObject l = new LoofUtilObject();
		List<Map<String, Object>> lm = null;
		lm = l.selectAfterLoofBigList((List<String>) paramMap.get("loadCustmrList"), new LoofInterface() {
			@Override
			public Object exec(Object...obj) {
				return goodsCenterEventPriceDao.getCenterEventCustmrInfo((List<String>) obj[0]);
			}
		});
		return lm;
	}

	@Transactional
	@Override
	public void crudCenterEventCustmrList(Map<String, Object> paramMap) {
		LoofUtilObject l = new LoofUtilObject();
		l.loofBigListMapByCRUD(paramMap, new LoofInterface() {
			@Override
			public Object exec(Object...obj) {
				goodsCenterEventPriceDao.insertCenterEventCustmrList((List<Map<String, Object>>) obj[0]);
				goodsCenterEventPriceDao.updateCenterEventCustmrList((List<Map<String, Object>>) obj[2]);
				goodsCenterEventPriceDao.deleteCenterEventCustmrList((List<Map<String, Object>>) obj[3]);
				return null;
			}
		});
	}

	@Override
	public List<Map<String, Object>> getCenterEventCustmrList(Map<String, Object> paramMap) {
		return goodsCenterEventPriceDao.getCenterEventCustmrList(paramMap);
	}
}
