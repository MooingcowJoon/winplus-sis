package com.samyang.winplus.sis.sales.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface SalesManagementCenterDao {
	
	/**
	  * getSuprBySupplyHeaderList - 판매관리 - 판매관리(센터) - 납품확인 - 헤더그리드 조회
	  * @author 정혜원
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getSuprBySupplyHeaderList(Map<String, Object> paramMap);
	
	/**
	  * getSuprBySupplyDetailList - 판매관리 - 판매관리(센터) - 납품확인 - 디테일그리드 조회
	  * @author 정혜원
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getSuprBySupplyDetailList(Map<String, Object> paramMap);
	
	/**
	  * saveSuprBySupplyDetailInfo - 판매관리 - 판매관리(센터) - 납품확인 - 디테일그리드 저장
	  * @author 정혜원
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveSuprBySupplyDetailInfo(Map<String, Object> paramMap);
	
	/**
	  * getSuprBySupplyConfirmHeaderList - 판매관리 - 판매관리(센터) - 납품확정 - 헤더그리드 조회
	  * @author 정혜원
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getSuprBySupplyConfirmHeaderList(Map<String, Object> paramMap);
	
	/**
	  * getSuprBySupplyConfirmDetailList - 판매관리 - 판매관리(센터) - 납품확정 - 디테일그리드 조회
	  * @author 정혜원
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getSuprBySupplyConfirmDetailList(Map<String, Object> paramMap);
	
	/**
	 * approvalSuprBySupplyConfirm - 판매관리 - 판매관리(센터) - 납품확정 - 납품내역 승인
	  * @author 정혜원
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception 
	 */
	int approvalSuprBySupplyConfirm(Map<String, Object> paramMap);
	
	/**
	 * cancleSuprBySupplyConfirm - 판매관리 - 판매관리(센터) - 납품확정 - 납품내역 취소
	  * @author 정혜원
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception 
	 */
	int cancleSuprBySupplyConfirm(Map<String, Object> paramMap);
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확정 - 확정금액 저장(디테일)
	  * @author 최지민
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveSupplyConfirm(Map<String, Object> paramMap);
	
	/**
	  * 판매관리 - 판매관리(센터) - 납품확정 - 확정금액 저장(헤더)
	  * @author 최지민
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int updateSupplyConfirm(Map<String, Object> paramMap);
}
