package com.samyang.winplus.sis.stock.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.stock.dao.TransInOutDao;

@Service("TransInOutService")
public class TransInOutServiceImpl implements TransInOutService {
	
	@Autowired
	TransInOutDao transInOutDao;

	/**
	 * 재고이동등록(직영점) - PDA재고이동 Summary 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getPdaTransSummaryList(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.getPdaTransSummaryList(paramMap);
	}
	
	/**
	 * 재고이동등록(직영점) - PDA재고이동 Item 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getPdaTransItemList(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.getPdaTransItemList(paramMap);
	}
	
	/**
	 * 재고이동등록(직영점) - 재고이동 마스터 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getStockTransMastList(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.getStockTransMastList(paramMap);
	}
	
	/**
	 * 재고이동등록(직영점) - 재고이동 디테일 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getStockTransDetlList(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.getStockTransDetlList(paramMap);
	}
	
	/**
	 * 재고이동등록(직영점) - 재고이동 자료 생성
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public String createTransData(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.createTransData(paramMap);
	}
	
	/**
	 * 재고이동등록(직영점) - PDA자료 삭제
	 * @author 강신영
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public String deletePdaData(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.deletePdaData(paramMap);
	}
	
	/**
	 * 재고이동등록(직영점) - 재고이동 요청
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int requestTransData(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.requestTransData(paramMap);
	}
	
	/**
	 * 재고이동등록(직영점) - 재고이동 요청취소
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int requestCancelTransData(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.requestCancelTransData(paramMap);
	}
	
	/**
	 * 재고이동등록(직영점) - 재고이동 품목삭제
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int deleteTransDataItem(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.deleteTransDataItem(paramMap);
	}
	
	/**
	 * 재고이동등록(직영점) - 재고이동 품목등록수정
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int updateTransDataItem(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.updateTransDataItem(paramMap);
	}
	
	/**
	 * 재고이동등록(직영점) - 재고이동 요청 자료 조회
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getStockTransReqList(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.getStockTransReqList(paramMap);
	}
	
	/**
	 * 재고이동확인(직영점) - 재고이동 확정
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int confirmTransData(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.confirmTransData(paramMap);
	}
	
	/**
	 * 재고이동확인(직영점) - 재고이동 확정취소
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int confirmCancelTransData(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.confirmCancelTransData(paramMap);
	}
	
	/**
	 * 재고이동등록(직영점) - 재고이동 자료삭제
	 * @author 강신영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int deleteTransData(Map<String, Object> paramMap) throws SQLException, Exception {
		return transInOutDao.deleteTransData(paramMap);
	}

}