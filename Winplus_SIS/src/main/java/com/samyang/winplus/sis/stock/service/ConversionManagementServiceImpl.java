package com.samyang.winplus.sis.stock.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.stock.dao.ConversionManagementDao;

@Service("ConversionManagementService")
public class ConversionManagementServiceImpl implements ConversionManagementService {
	
	@Autowired
	ConversionManagementDao conversionManagementDao;
	
	/**
	 * getStockConvHeaderList - 대출입 - 대출입 헤더 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getStockConvHeaderList(Map<String, Object> paramMap) throws SQLException, Exception {
		return conversionManagementDao.getStockConvHeaderList(paramMap);
	}
	
	/**
	 * getConvInfo - 대출입 정보 조회
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getConvInfo(Map<String, Object> paramMap) throws SQLException, Exception {
		return conversionManagementDao.getConvInfo(paramMap);
	}
	
	/**
	 * getStockConvDetailList - 대출입 등록/조회 - 대출입 원물 디테일 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getStockOriConvDetailList(Map<String, Object> paramMap) throws SQLException, Exception {
		return conversionManagementDao.getStockOriConvDetailList(paramMap);
	}
	
	/**
	 * getStockConvDetailList - 대출입 등록/조회 - 대출입 대물 디테일 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getStockReplcConvDetailList(Map<String, Object> paramMap) throws SQLException, Exception {
		return conversionManagementDao.getStockReplcConvDetailList(paramMap);
	}
	
	/**
	 * getStockConvSeq - 대출입 등록/조회 - 시퀀스 채번
	 * @author 강신영
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public String getStockConvSeq() throws SQLException, Exception {
		return conversionManagementDao.getStockConvSeq();
	}
	
	/**
	 * updateConversionDetail - 대출입 등록/조회 - 대출입 디테일 저장
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> updateConversionDetail(Map<String, Object> paramMap) throws SQLException, Exception {
		return conversionManagementDao.updateConversionDetail(paramMap);
	}
	
	/**
	 * updateConversionDetail - 대출입 헤더 갱신
	 * @author 강신영
	 * @param paramMap
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public void updateConversionHeader(Map<String, Object> paramMap) throws SQLException, Exception {
		conversionManagementDao.updateConversionHeader(paramMap);
	}
	
	/**
	 * deleteConversionManagementList - 대출입 - 대출입 삭제
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public String deleteConversionManagementList(Map<String, Object> paramMap) throws SQLException, Exception {
		return conversionManagementDao.deleteConversionManagementList(paramMap);
	}
	
	/**
	 * reqConfirmConv - 대출입 - 대출입 요청
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public String reqConfirmConv(Map<String, Object> paramMap) throws SQLException, Exception {
		return conversionManagementDao.reqConfirmConv(paramMap);
	}
	
	/**
	 * reqConfirmCancelConv - 대출입 - 대출입 요청취소
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public String reqConfirmCancelConv(Map<String, Object> paramMap) throws SQLException, Exception {
		return conversionManagementDao.reqConfirmCancelConv(paramMap);
	}
	
	/**
	 * getStockConvReqList - 대출입확정 - 대출입요청 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getStockConvReqList(Map<String, Object> paramMap) throws SQLException, Exception {
		return conversionManagementDao.getStockConvReqList(paramMap);
	}
	
	/**
	 * confirmConvData - 대출입확정 - 대출입 확정
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public String confirmConvData(Map<String, Object> paramMap) throws SQLException, Exception {
		return conversionManagementDao.confirmConvData(paramMap);
	}
	
	/**
	 * confirmCancelConvData - 대출입확정 - 대출입 확정취소
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public String confirmCancelConvData(Map<String, Object> paramMap) throws SQLException, Exception {
		return conversionManagementDao.confirmCancelConvData(paramMap);
	}

}
