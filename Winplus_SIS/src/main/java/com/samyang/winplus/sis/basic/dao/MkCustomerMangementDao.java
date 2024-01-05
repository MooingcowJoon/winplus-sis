package com.samyang.winplus.sis.basic.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("MkCustomerMangementDao")
public interface MkCustomerMangementDao {

	/**
	  * getSearchCustmrListMk - 대상거래처 납품업체 조회
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */	
	 List<Map<String, Object>> getSearchCustmrListMk(Map<String, Object> paramMap)  throws SQLException, Exception;
	
	/**
	  * insertMkCustomer - 대상거래처 납품업체 등록
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int insertMkCustomer(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateMkCustomer - 대상거래처 납품업체 수정
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int updateMkCustomer(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * deleteMkCustomer - 대상거래처 납품업체 삭제
	  * @author 손경락
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int deleteMkCustomer(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 사업장별협력사관리 - 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getCustmrByWorkplace(Map<String, Object> paramMap);
	
	/**
	  * 사업장별협력사관리 - 거래처 추가
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */	
	List<Map<String, Object>> getCustmrInfo(Map<String, Object> paramMap);
	
	/**
	 * 사업장별협력사관리 - 거래처 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */	
	int saveAddCustmrByWorkplace(Map<String, Object> paramMap);
	
	/**
	 * 사업장별협력사관리 - 거래처 수정
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */	
	int saveUpdateCustmrByWorkplace(Map<String, Object> paramMap);
}
