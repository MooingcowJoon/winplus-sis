package com.samyang.winplus.common.organ.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("OrganService")
public interface OrganService {

	List<Map<String, Object>> getDlvBsnCodeList(Map<String, Object> paramMap) throws SQLException, Exception;

	Map<String, Object> getDlvBsnMap(Map<String, Object> paramMap) throws SQLException, Exception;

	int saveDlvBsn(Map<String, Object> paramMap) throws SQLException, Exception;

	List<Map<String, Object>> getCstmMtrlList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * getStndCtgr - 조직 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getOrgnList() throws SQLException, Exception;
	
	/**
	  * getStndCtgr - 조직 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getOrgn(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getStndCtgr - 조직 입력
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int insertOrgn(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 조직 리스트 조회(세션)
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getOrgnListSession(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 백화점 조직 리스트 조회(세션)
	  * @author 조승현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getDepartmentStoreOrgnListSession(Map<String, Object> paramMap) throws SQLException, Exception;

	
	
	int saveMtrl(List<Map<String, Object>> dhtmlxParamMapList) throws SQLException, Exception;
	
	/**
	  * 조직 리스트 조회(세션) : 자기 공장 제외한 나머지 공장 코드 가져오기
	  * @author 정인선
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getNotOrgnListSession(Map<String, Object> paramMap) throws SQLException, Exception;

	int deleteDlvBsn(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * <pre>
	 * 1. 개요 : 조직관리
	 * 2. 처리내용 : 조직별 회계코드 저장
	 * </pre>   
	 * @Method Name : insertErpCode
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int insertErpCode(List<Map<String, Object>> dhtmlxParamMapList) throws SQLException, Exception;
	
	/**
	 * <pre>
	 * 1. 개요 : 조직관리
	 * 2. 처리내용 : 조직별 회계코드 저장 검증
	 * </pre>   
	 * @Method Name : getErpCodeCheck
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> getErpCodeCheck(List<Map<String, Object>> dhtmlxParamMapList) throws SQLException, Exception;
	
	/**
	  * 조직별 회계코드 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getErpCodeList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 납품업체 정보 IF
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int saveFacIf(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 조직코드로 조직구분코드 불러오기
	  * @author 정혜원
	  * @param String
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	String getOrnginDivCdByOrgnCd(String ORGN_CD) throws SQLException, Exception;
	
}
