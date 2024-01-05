package com.samyang.winplus.sis.basic.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.basic.dao.VirtualAcntDao;

@Service("VirtualAcntService")
public class VirtualAcntServiceImpl implements VirtualAcntService{
	
	@Autowired
	VirtualAcntDao virtualAcntDao;

	/**
	  * getVirtualAcntHeaderList - 가상계좌현황 - 헤더내역조회
	  * @author 한정훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getVirtualAcntHeaderList(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return virtualAcntDao.getVirtualAcntHeaderList(paramMap);
	}

	/**
	  * getVirtualAcntDetailList - 가상계좌현황 - 디테일내역조회
	  * @author 한정훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getVirtualAcntDetailList(Map<String, String> paramMap) throws SQLException, Exception{
		// TODO Auto-generated method stub
		return virtualAcntDao.getVirtualAcntDetailList(paramMap);
	}
	/**
	 * 기준정보관리 - 가상계좌현황 - 조회테이블조회
	 * @author 한정훈
	 * @param searchData
	 * @return Map<String, Object>
	 */
	@Override
	public Map<String, Object> getVirtualAcntTableInfo(Map<String, Object> searchData) {
		return virtualAcntDao.getVirtualAcntTableInfo(searchData);
	}
}
