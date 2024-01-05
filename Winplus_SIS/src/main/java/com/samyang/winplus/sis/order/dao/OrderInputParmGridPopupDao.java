package com.samyang.winplus.sis.order.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("OrderInputParmGridPopupDao")
public interface OrderInputParmGridPopupDao {


	/**
	  * getParmOrderGoodsPriceList - 팜에서 직영점발주 집계건의 외부공급사로 발주시 상품,최저가(or전체공급사) 가져오기
	  * @author 손경락
	  */	
	 List<Map<String, Object>> getParmOrderGoodsPriceList(Map<String, Object> paramMap)  throws SQLException, Exception;	
	                           
	/**
	  * getParmOrderGoodsMatrixList - 직영점별 상품단위 팜발주요청조회
	  * @author 손경락
	  */	
	 List<Map<String, Object>> getParmOrderGoodsMatrixList(Map<String, Object> paramMap)  throws SQLException, Exception;	

	 
}
