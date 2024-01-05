package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("OrderInputParmGridPopupService")
public interface OrderInputParmGridPopupService {
	
	/* 팜에서 직영점발주 집계건의 외부공급사로 발주시 상품,최저가(or전체공급사) 가져오기 */
	List<Map<String, Object>> getParmOrderGoodsPriceList(Map<String, Object> paramMap)  throws SQLException, Exception;	
  
	/* 직영점별 상품단위 팜발주요청조회 */
	List<Map<String, Object>> getParmOrderGoodsMatrixList(Map<String, Object> paramMap)  throws SQLException, Exception;	
		
}
