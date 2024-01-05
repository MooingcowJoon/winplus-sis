package com.samyang.winplus.sis.basic.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("MkCustomerMangementService")
public interface MkCustomerMangementService {
	
	int insertMkCustomer(Map<String, Object> paramMap) throws SQLException, Exception;
	int updateMkCustomer(Map<String, Object> paramMap) throws SQLException, Exception;
	int deleteMkCustomer(Map<String, Object> paramMap) throws SQLException, Exception;
	int saveCustomerMkScreenList(List<Map<String, Object>> paramMapList) throws SQLException, Exception;
    List<Map<String, Object>> getSearchCustmrListMk(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 사업장별협력사관리 - 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getCustmrByWorkplace(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 사업장별협력사관리 - 협력사 추가
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getCustmrInfo(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 사업장별협력사관리 - 거래처 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int saveAddCustmrByWorkplace(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 사업장별협력사관리 - 거래처 수정
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int saveUpdateCustmrByWorkplace(Map<String, Object> paramMap) throws SQLException, Exception;
}