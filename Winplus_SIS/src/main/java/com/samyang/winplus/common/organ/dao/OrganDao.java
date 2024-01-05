package com.samyang.winplus.common.organ.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("organDao")
public interface OrganDao {

	List<Map<String, Object>> getDlvBsnCodeList(Map<String, Object> paramMap) throws SQLException, Exception;

	Map<String, Object> getDlvBsnMap(Map<String, Object> paramMap) throws SQLException, Exception;

	List<Map<String, Object>> getCstmMtrlList(Map<String, Object> paramMap) throws SQLException, Exception;

	int saveDlvBsn(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int insertDlvBsnIfRequest(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int getBusinessNumberCheck(Map<String, Object> paramMap) throws SQLException, Exception;

	int deleteDlvBsn(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int saveMtrl(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 조직 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getOrgnList() throws SQLException, Exception;
	
	/**
	  * 조직 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getOrgn(Map<String, Object> paramMap) throws SQLException, Exception;
	
	
	/**
	  * 조직 입력
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	int insertOrgn(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 조직 수정
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	int updateOrgn(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 조직 삭제
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	int deleteOrgn(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 하위 조직 체크
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	int chkChildCtgr(Map<String, Object> paramMap) throws SQLException, Exception;
	
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
	
	
	
	/**
	  * 조직 리스트 조회(세션) : 자기 공장 제외한 나머지 공장 리스트
	  * @author 정인선
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	public List<Map<String, Object>> getNotOrgnListSession(Map<String, Object> paramMap) throws SQLException, Exception;

	
	
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
	int insertErpCode(Map<String, Object> paramMap) throws SQLException, Exception;
	
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
	int getErpCodeCheck(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 조직별 회계코드 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getErpCodeList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	int saveFacIf(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 조직코드로 조직구분코드 조회
	  * @author 정혜원
	  * @param (String) ORGN_CD
	  * @return (String)
	  * @exception SQLException
	  * @exception Exception
	  */
	String getOrgnDivCdByOrgnCd(String oRGN_CD)  throws SQLException, Exception;
}
