package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.samyang.winplus.sis.order.dao.OrderParmSearchDao;

@Service("OrderParmSearchService")
public class OrderParmSearchServiceImpl implements OrderParmSearchService{
	
	@Autowired
	OrderParmSearchDao orderParmSearchDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public List<Map<String, Object>> getOrderParmSearchList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderParmSearchDao.getOrderParmSearchList(paramMap);
	}
	

	@Transactional
	@Override
	public int SavePurOrdGoodsTemp(Map<String, Object> paramMap) throws SQLException, Exception {
		//logger.debug(" ============OrderParmSearchServiceImpl.java ===============");
		int proces_cnt = 1;
	    
	    //proces_cnt  = orderParmSearchDao.getPurTempCount(paramMap);
		
		////logger.debug("============proces_cnt =>" + proces_cnt);

		if ( proces_cnt > 0 ) {
			//logger.debug("===DeletePurOrdGoodsTemp===");
			orderParmSearchDao.DeletePurOrdGoodsTemp(paramMap);
	    }
		
		//logger.debug("===InsertPurOrdGoodsTemp===");
		return orderParmSearchDao.InsertPurOrdGoodsTemp(paramMap);
	}

	@Override
	public int InsertPurOrdGoodsTemp(Map<String, Object> paramMap) throws SQLException, Exception {
		return 0;
	}
	
	@Override
	public int UpdatePurOrdGoodsTemp(Map<String, Object> paramMap) throws SQLException, Exception {
		return orderParmSearchDao.UpdatePurOrdGoodsTemp(paramMap);
	}
	
	@Override
	public int DeletePurOrdGoodsTemp(Map<String, Object> paramMap) throws SQLException, Exception {
		return orderParmSearchDao.DeletePurOrdGoodsTemp(paramMap);
	}

	@Override
	public int getPurTempCount(Map<String, Object> paramMap) throws SQLException, Exception {
		return orderParmSearchDao.getPurTempCount(paramMap);
	}
	
	@Override
	public int UpdatePurOrdState(Map<String, Object> paramMap) throws SQLException, Exception {
		return orderParmSearchDao.UpdatePurOrdState(paramMap);
	}
	

}
