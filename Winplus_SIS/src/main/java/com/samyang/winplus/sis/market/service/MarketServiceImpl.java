package com.samyang.winplus.sis.market.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.util.LoofInterface;
import com.samyang.winplus.common.system.util.LoofUtilObject;
import com.samyang.winplus.sis.market.dao.MarketDao;

@Service("MarketService")
public class MarketServiceImpl implements MarketSevice{

	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private MarketDao marketDao;
	
	@Override
	public List<Map<String, Object>> getPaymentApprovalHistory(Map<String, String> paramMap) {
		return marketDao.getPaymentApprovalHistory(paramMap);
	}

	@Override
	public List<Map<String, Object>> getStatisticsByCardAcquirerList(Map<String, String> paramMap) {
		return marketDao.getStatisticsByCardAcquirerList(paramMap);
	}

	@Override
	public List<Map<String, Object>> getMoveBetweenMarkets(Map<String, String> paramMap) {
		return marketDao.getMoveBetweenMarkets(paramMap);
	}
	
	/**
	  * 점포업무관리 - 특매관리 - 특매그룹 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getBargainManagementList(Map<String, Object > paramMap) throws SQLException, Exception {
		return marketDao.getBargainManagementList(paramMap);
	}
	
	/**
	  * 점포업무관리 - 특매관리 - 특매상품 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getBargainManagementSubList(Map<String, Object > paramMap) throws SQLException, Exception {
		return marketDao.getBargainManagementSubList(paramMap);
	}
	
	
	/**
	  * 점포업무관리 - 특매관리 - 특매코드 가져오기
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public Map<String, Object> getBargainManagementInfoCheck(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.getBargainManagementInfoCheck(paramMap);
	}
		
	/**
	  * 점포업무관리 - 특매관리 - 특매그룹 추가
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public int addBargainManagementGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.addBargainManagementGoods(paramMap);
	}
	
	/**
	  * 점포업무관리 - 특매관리 - 특매그룹(상품) 삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public int deleteBargainManagementGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.deleteBargainManagementGoods(paramMap);
	}
	
	/**
	  * 점포업무관리 - 특매관리 - 특매그룹 삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public int deleteBargainManagementGrup(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.deleteBargainManagementGrup(paramMap);
	}
	
	/**
	  * 점포업무관리 - 특매관리 - 특매그룹 수정
	  * @author 최지민
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public int updateBargainManagementGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.updateBargainManagementGoods(paramMap);
	}
	
	/**
	  * 점포업무관리 - 특매관리 - 특매상품 추가(TMP)
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public int bargainSubList(List<Map<String, Object>> dhtmlxParamMapList) throws SQLException, Exception {
		int resultRowCnt = 0;
		resultRowCnt = marketDao.deleteBargainSubList();
		if (resultRowCnt != -1) {
			for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList) {
				resultRowCnt +=  marketDao.bargainSubList(dhtmlxParamMap);
			}
		} 
		return resultRowCnt;
	}
	
	/**
	  * 점포업무관리 - 특매관리 - 특매상품 저장
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public int saveBargainSubList(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.saveBargainSubList(paramMap);
	}
	
	/** 
	  * 점포업무관리 - 특매관리 - 업로드한 엑셀 상품정보 가져오기
	  * @author 최지민
	  * @param request
	  * @return List<Map<String,Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getBargainGoodsInfo(Map<String, Object> paramMap) {
		LoofUtilObject l = new LoofUtilObject();
		List<Map<String, Object>> lm = null;
		lm = l.selectAfterLoofBigList((List<String>) paramMap.get("loadGoodsList"), new LoofInterface() {
			@Override
			public Object exec(Object... obj) {
				return marketDao.getBargainGoodsInfo((List<String>) obj[0]);
			}
		});
		return lm;
	}
	
	/**
	  * 점포업무관리 - 특매상품검색
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getBargainGoodsSearch(Map<String, Object > paramMap) throws SQLException, Exception {
		return marketDao.getBargainGoodsSearch(paramMap);
	}
	
	/**
	  * 점포업무관리 - 특매상품검색 -대중소구분
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public Map<String, Object> getBargainGoodsSearchTMB(Map<String, Object > paramMap) throws SQLException, Exception {
		return marketDao.getBargainGoodsSearchTMB(paramMap);
	}
	
	/**
	  * 점포업무관리 - 특매판매내역
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getBargainSalesHistory(Map<String, Object > paramMap) throws SQLException, Exception {
		return marketDao.getBargainSalesHistory(paramMap);
	}
	
	/**
	  * 점포업무관리 - 특매판매내역 -대중소구분
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public Map<String, Object> getBargainSalesHistoryTMB(Map<String, Object > paramMap) throws SQLException, Exception {
		return marketDao.getBargainSalesHistoryTMB(paramMap);
	}
	
	/**
	  * 점포업무관리 - 특매변경이력
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getBargainChangeHistory(Map<String, Object > paramMap) throws SQLException, Exception {
		return marketDao.getBargainChangeHistory(paramMap);
	}
	
	/**
	  * 점포업무관리 - 특매변경이력 - 대중소구분
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public Map<String, Object> getBargainChangeHistoryTMB(Map<String, Object > paramMap) throws SQLException, Exception {
		return marketDao.getBargainChangeHistoryTMB(paramMap);
	}
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Head 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public List<Map<String, Object>> getDoubleMainList(Map<String, Object > paramMap) throws SQLException, Exception {
		return marketDao.getDoubleMainList(paramMap);
	}
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Detail 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public List<Map<String, Object>> getDoubleSubList(Map<String, Object > paramMap) throws SQLException, Exception {
		return marketDao.getDoubleSubList(paramMap);
	}
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Head 추가
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public int saveAddDoubleList(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.saveAddDoubleList(paramMap);
	}
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Head 삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int saveDeleteDoubleList(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.saveDeleteDoubleList(paramMap);
	}
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Head 상품 삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public int saveDeleteGoodsDoubleList(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.saveDeleteGoodsDoubleList(paramMap);
	}
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Head 갱신
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int saveUpdateDoubleList(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.saveUpdateDoubleList(paramMap);
	}

	/**
	  * 점포업무관리 - 이종상품묶음할인 Detail 추가
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int saveAddDoubleSubList(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.saveAddDoubleSubList(paramMap);
	}
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Detail 삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int saveDeleteDoubleSubList(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.saveDeleteDoubleSubList(paramMap);
	}
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Detail 갱신
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int saveUpdateDoubleSubList(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.saveUpdateDoubleSubList(paramMap);
	}

	/**
	  * 점포업무관리 - 이종상품묶음할인 Head Check
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public Map<String, Object> getInfoCheck(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.getInfoCheck(paramMap);
	}
	
	/**
	  * 점포업무관리 - 이종상품묶음판매내역 -조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public List<Map<String, Object>> getDoubleSalesHistory(Map<String, Object > paramMap) throws SQLException, Exception {
		return marketDao.getDoubleSalesHistory(paramMap);
	}	
	
	/**
	  * 점포업무관리 - 이종상품묶음판매내역 -조회(대중소구분)
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public Map<String, Object> getDoubleSalesHistoryTMB(Map<String, Object> paramMap) throws SQLException, Exception {
		return marketDao.getDoubleSalesHistoryTMB(paramMap);
	}
}