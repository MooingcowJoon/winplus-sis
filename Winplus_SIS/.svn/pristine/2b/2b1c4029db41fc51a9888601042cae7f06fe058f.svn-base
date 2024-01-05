package com.samyang.winplus.sis.standardInfo.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.standardInfo.dao.LabelPrintDao;

@Service("LabelPrintService")
public class LabelPrintServiceImpl implements LabelPrintService{
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	LabelPrintDao labelPrintDao;
	
	/**
	 * getBCodeList - 기준정보관리 - 라벨출력
	 * @author 정혜원
	 * @return List<Map<String, Object>>
	 * @exception SQLException
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> getBCodeList(Map<String, Object> paramMap) throws SQLException, Exception {
		return labelPrintDao.getBCodeList(paramMap);
	}
	
	/**
	 * checkMrdFile - 기준정보관리 - 라벨등록 - 공통코드(MRD_FILE) 상세내역 조회
	 * @author 정혜원
	 * @return Map<String, Object>
	 * @exception SQLException
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> checkMrdFile(Map<String, Object> paramMap) throws SQLException, Exception {
		return labelPrintDao.checkMrdFile(paramMap);
	}
	
	/**
	 * getPdaLabelList - 라벨출력 - PDA내역불러오기
	 * @author 정혜원
	 * @return List<Map<String, Object>>
	 * @exception SQLException
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> getPdaLabelList(Map<String, Object> paramMap) throws SQLException, Exception {
		return labelPrintDao.getPdaLabelList(paramMap);
	}
	
	/**
	 * deletePdaLabelList - 라벨출력 - PDA내역불러오기 팝업 - 내역삭제
	 * @author 정혜원
	 * @param List<Map<String, Object>>
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> deletePdaLabelList(List<Map<String, Object>> paramMapList) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int TOT_CNT = paramMapList.size();
		int result_cnt = 0;
		logger.debug("paramMapList >>> " + paramMapList);
		for(Map<String, Object> param : paramMapList) {
			result_cnt += labelPrintDao.deletePdaLabelList(param);
		}
		resultMap.put("result_cnt", result_cnt);
		return resultMap;
	}
	
	/**
	 * updatePdaLabelPrintState - 라벨출력 - PDA내역 출력여부 업데이트
	 * @author 정혜원
	 * @param List<Map<String, Object>>
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> updatePdaLabelPrintState(List<Map<String, Object>> paramMapList) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int result_cnt = 0;
		logger.debug("paramMapList >>> " + paramMapList);
		for(Map<String, Object> param : paramMapList) {
			result_cnt += labelPrintDao.updatePdaLabelPrintState(param);
		}
		resultMap.put("result_cnt", result_cnt);
		return resultMap;
	}
	
}
