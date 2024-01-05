package com.samyang.winplus.sis.market.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("MarketService")
public interface MarketSevice{

	List<Map<String,Object>> getPaymentApprovalHistory(Map<String, String> paramMap);

	List<Map<String,Object>> getStatisticsByCardAcquirerList(Map<String, String> paramMap);

	List<Map<String,Object>> getMoveBetweenMarkets(Map<String, String> paramMap);

	/**
	  * 점포업무관리 - 특매관리 - 특매그룹 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getBargainManagementList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 점포업무관리 - 특매관리 - 특매상품 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getBargainManagementSubList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 특매관리 - 특매코드 가져오기
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */	
	Map<String, Object> getBargainManagementInfoCheck(Map<String, Object> detailInfoParam) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 특매관리 - 특매그룹 추가
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	int addBargainManagementGoods(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 특매관리 - 특매그룹(상품) 삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	int deleteBargainManagementGoods(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 점포업무관리 - 특매관리 - 특매그룹 삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */		
	int deleteBargainManagementGrup(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 특매관리 - 특매그룹 수정
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	int updateBargainManagementGoods(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 특매관리 - 특매상품 추가(TMP)
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	int bargainSubList(List<Map<String, Object>> dhtmlxParamMapList) throws SQLException, Exception;
	
	/**
	  * 점포업무관리 - 특매관리 - 특매상품 저장
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */	
	int saveBargainSubList(Map<String, Object> paramMap)throws SQLException, Exception;
	
	/** 
	  * 점포업무관리 - 특매관리 - 업로드한 엑셀 상품정보 가져오기
	  * @author 최지민
	  * @param request
	  * @return List<Map<String,Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getBargainGoodsInfo(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 점포업무관리 - 특매상품검색
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getBargainGoodsSearch(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 특매상품검색 - 대중소구분
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	Map<String, Object> getBargainGoodsSearchTMB(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 특매판매내역
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getBargainSalesHistory(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 특매판매내역 - 대중소구분
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	Map<String, Object> getBargainSalesHistoryTMB(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 특매변경이력
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getBargainChangeHistory(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 특매변경이력 - 대중소구분
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	Map<String, Object> getBargainChangeHistoryTMB(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Head 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getDoubleMainList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 이종상품묶음할인 Detail 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getDoubleSubList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 이종상품묶음할인 Head 추가
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int saveAddDoubleList(Map<String, Object> paramMap) throws SQLException, Exception;
  
	/**
	  * 점포업무관리 - 이종상품묶음할인 Head 삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int saveDeleteDoubleList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Head 상품 삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int saveDeleteGoodsDoubleList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Head 갱신
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int saveUpdateDoubleList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Detail 추가
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int saveAddDoubleSubList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 점포업무관리 - 이종상품묶음할인 Detail 삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int saveDeleteDoubleSubList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Detail 갱신
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int saveUpdateDoubleSubList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 점포업무관리 - 이종상품묶음할인 Head Check
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */	
	Map<String, Object> getInfoCheck(Map<String, Object> infoParam) throws SQLException, Exception;
	
	/**
	  * 점포업무관리 - 이종상품묶음판매내역 -조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getDoubleSalesHistory(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 점포업무관리 - 이종상품묶음판매내역 -조회(대중소구분)
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	Map<String, Object> getDoubleSalesHistoryTMB(Map<String, Object> paramMap) throws SQLException, Exception;
}
