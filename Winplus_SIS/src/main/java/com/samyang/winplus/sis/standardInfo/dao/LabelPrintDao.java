package com.samyang.winplus.sis.standardInfo.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;


@Repository("LabelPrintDao")
public interface LabelPrintDao {
	/**
	 * getBCodeList - 기준정보관리 - 라벨출력
	 * @author 정혜원
	 * @return List<Map<String, Object>>
	 * @exception SQLException
	 * @exception Exception
	 */
	List<Map<String, Object>> getBCodeList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	
	/**
	 * checkMrdFile - 기준정보관리 - 라벨등록 - 공통코드(MRD_FILE) 상세내역 조회
	 * @author 정혜원
	 * @return Map<String, Object>
	 * @exception SQLException
	 * @exception Exception
	 */
	Map<String, Object> checkMrdFile(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * getPdaLabelList - 라벨출력 - PDA내역불러오기
	 * @author 정혜원
	 * @return List<Map<String, Object>>
	 * @exception SQLException
	 * @exception Exception
	 */
	List<Map<String, Object>> getPdaLabelList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * deletePdaLabelList - 라벨출력 - PDA내역불러오기 팝업 - 내역삭제
	 * @author 정혜원
	 * @return Integer
	 * @exception SQLException
	 * @exception Exception
	 */
	int deletePdaLabelList(Map<String, Object> param) throws SQLException, Exception;
	
	/**
	 * updatePdaLabelPrintState - 라벨출력 - PDA내역 출력여부 업데이트
	 * @author 정혜원
	 * @return Integer
	 * @exception SQLException
	 * @exception Exception
	 */
	int updatePdaLabelPrintState(Map<String, Object> param) throws SQLException, Exception;
	
}
