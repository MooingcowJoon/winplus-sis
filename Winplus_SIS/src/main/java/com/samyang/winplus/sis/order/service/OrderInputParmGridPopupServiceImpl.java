package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.samyang.winplus.sis.order.dao.OrderInputParmGridPopupDao;
import com.samyang.winplus.sis.order.service.OrderInputParmGridPopupService;

@Service("OrderInputParmGridPopupService")
public class OrderInputParmGridPopupServiceImpl implements OrderInputParmGridPopupService {
	
	@Autowired
	OrderInputParmGridPopupDao orderInputParmGridPopupDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	/* 팜에서 직영점발주 집계건의 외부공급사로 발주시 상품,최저가(or전체공급사) 가져오기 */
	@Override
	public List<Map<String, Object>> getParmOrderGoodsPriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputParmGridPopupDao.getParmOrderGoodsPriceList(paramMap);
	}
	
	/* 직영점별 상품단위 팜발주요청조회 */
	@Override
	public List<Map<String, Object>> getParmOrderGoodsMatrixList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputParmGridPopupDao.getParmOrderGoodsMatrixList(paramMap);
	}
	
}
