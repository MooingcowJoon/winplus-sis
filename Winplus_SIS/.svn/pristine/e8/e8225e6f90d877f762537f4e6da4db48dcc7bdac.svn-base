package com.samyang.winplus.sis.standardInfo.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.samyang.winplus.common.system.util.CommonException;

@Service("LabelPrintService")
public interface LabelPrintService {
	
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
	 * @return Map<String, Object>
	 * @exception SQLException
	 * @exception Exception
	 */
	List<Map<String, Object>> getPdaLabelList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * deletePdaLabelList - 라벨출력 - PDA내역불러오기 팝업 - 내역삭제
	 * @author 정혜원
	 * @param List<Map<String, Object>>
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> deletePdaLabelList(List<Map<String, Object>> paramMapList) throws SQLException, Exception;

	/**
	 * updatePdaLabelPrintState - 라벨출력 - PDA내역 출력여부 업데이트
	 * @author 정혜원
	 * @param List<Map<String, Object>>
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> updatePdaLabelPrintState(List<Map<String, Object>> paramMapList) throws SQLException, Exception;

}
