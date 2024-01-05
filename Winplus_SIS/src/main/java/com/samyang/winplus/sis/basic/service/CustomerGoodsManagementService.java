package com.samyang.winplus.sis.basic.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("CustomerGoodsManagementService")
public interface CustomerGoodsManagementService {
	
	/**
	  * insertMkCustomer - 대상거래처 납품업체 등록
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */	
	int insertStdCustomrGoods(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateMkCustomer - 대상거래처 납품업체 수정
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int updateStdCustomrGoods(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * deleteMkCustomer - 대상거래처 납품업체 삭제
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int deleteStdCustomrGoods(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * saveCustomerMkScreenList -  대상거래처 납품업체 C,U,D
	  * @author 손경락
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveStdCustomrGoodsScreenList(List<Map<String, Object>> paramMapList) throws SQLException, Exception;

	/**
 	 * getSearchMasterBarcodeList -  바코드마스터 && 상품마스트에서 상품및  바코드를 가져온다
 	 * @author 손경락
 	 * @param paramMap
 	 */	
    List<Map<String, Object>> getSearchMasterBarcodeList(Map<String, Object> paramMap) throws SQLException, Exception;

    /**
 	 * getSearchTstdCustomerGoodsList -  등록된 주문가능상조회 
 	 * @author 손경락
 	 * @param paramMap
 	 */	
    List<Map<String, Object>> getSearchTstdCustomerGoodsList(Map<String, Object> paramMap) throws SQLException, Exception;
    
    /**
 	 * getSearchMasterBarcodePriceList - 바코드마스터 && 상품마스트에서 상품및  바코드 && 구매단가를 가져온다
 	 * @author 손경락
 	 * @param paramMap
 	 */	
    List<Map<String, Object>> getSearchMasterBarcodePriceList(Map<String, Object> paramMap) throws SQLException, Exception;
	
   /**
	 * getSearchMasterBarcodeLowestPriceList - 상품기준 최저 구매가격 가져오기
	 * @author 손경락
	 * @param paramMap
	 */	
    List<Map<String, Object>> getSearchMasterBarcodeLowestPriceList(Map<String, Object> paramMap) throws SQLException, Exception;
    
	/**
	  * getSearchMasterBarcodeFreshPriceList - 팜센터에서의 신선발주( 팜센터에서 취급하는 상품을  구한다음 외부협력사를 찾는다)
	  * @author 손경락
	  * @param paramMap
	  */	
	 List<Map<String, Object>> getSearchMasterBarcodeFreshPriceList(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/**
	  * getCustmrStdPrice - 고객그룹별_기준가관리(상품별) - 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getCustmrStdPrice(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getCustmrStdPriceGoodsInfo - 고객그룹별_기준가관리(상품별) - 상품추가
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getCustmrStdPriceGoodsInfo(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getCustmrStdPrice - 고객그룹별_기준가관리 - 그룹조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getGrupStdPrice(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getGoodsStdPrice - 고객그룹별_기준가관리 - 상품조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getGoodsStdPrice(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getStdPriceCustmrList - 고객그룹별_기준가관리 - 거래처조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getStdPriceCustmrList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getStdPriceGrupCdCheck - 고객그룹별_기준가관리 - 그룹저장코드 가져오기
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	Map<String, Object> getStdPriceGrupCdCheck(Map<String, Object> grupCdInfoParam) throws SQLException, Exception;
	
	/**
	  * addGrupStdPrice - 고객그룹별_기준가관리 - 그룹추가
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int addGrupStdPrice(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * deleteGrupStdPrice - 고객그룹별_기준가관리 - 그룹삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int deleteGrupStdPrice(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * updateGrupStdPrice - 고객그룹별_기준가관리 - 그룹수정
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int updateGrupStdPrice(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getStdPriceGoodsManagementInfo - 고객그룹별_기준가관리 - 상품추가
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getStdPriceGoodsManagementInfo(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * addGoodsStdPrice - 고객그룹별_기준가관리 - 상품추가
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int addGoodsStdPrice(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * deleteGoodsStdPrice - 고객그룹별_기준가관리 - 상품삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int deleteGoodsStdPrice(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * updateGoodsStdPrice - 고객그룹별_기준가관리 - 상품수정
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int updateGoodsStdPrice(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * addCustmrStdPrice - 고객그룹별_기준가관리(상품별) - 추가
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int addCustmrStdPrice(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * deleteCustmrStdPrice - 고객그룹별_기준가관리(상품별) - 삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int deleteCustmrStdPrice(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * updateCustmrStdPrice - 고객그룹별_기준가관리(상품별) - 수정
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int updateCustmrStdPrice(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getCustmrStdPriceLookUp - 기준가조회(상품별)
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getCustmrStdPriceLookUp(Map<String, Object> paramMap) throws SQLException, Exception;
}
