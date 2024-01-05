package com.samyang.winplus.sis.basic.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.basic.dao.CustomerAcntManagementDao;
import com.samyang.winplus.sis.basic.service.CustomerAcntManagementService;

@Service("CustomerAcntManagementService")
public class CustomerAcntManagementServiceImpl implements CustomerAcntManagementService {
	
	@Autowired
	CustomerAcntManagementDao customerAcntManagementDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	@Override
	public int insertStdCustomrAcnt(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertStdCustomrAcntAppr(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateStdCustomrAcnt(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateStdCustomrAcntAppr(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteStdCustomrAcnt(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}	

	@Override
	public int deleteStdCustomrAcntAppr(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}	
	
	@Override
	public List<Map<String, Object>> getSearchCustomerAcntApprList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return customerAcntManagementDao.getSearchCustomerAcntApprList(paramMap);
	}


	/**
	  * saveStdCustomrAcntScreenList -  거래처별계좌 Insert, Update, Delete
	  * @author 손경락
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveStdCustomrAcntScreenList(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		int resultInt = 0;		
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");
			//logger.debug("@@@@@@@@@@ CustomerAcntManagementServiceImpl.java crud ============" + crud);
			
			if(crud != null) {
				if("C".equals(crud)){
					paramMap.put("PARAM_PROGRM", "CustomerAcntManagement");
					resultInt += customerAcntManagementDao.insertStdCustomrAcnt(paramMap);
					resultInt += customerAcntManagementDao.insertStdCustomrAcntAppr(paramMap);
				} else if ("U".equals(crud)){
					paramMap.put("PARAM_PROGRM", "CustomerAcntManagement");
					resultInt += customerAcntManagementDao.updateStdCustomrAcnt(paramMap);
					/* 승인권자이면  updateStdCustomrAppr도 Update */
				} else if ("D".equals(crud)){
					/* 삭제는 기본적으로 화면에서 막는다 막지않는다면 같이삭제 */
					resultInt += customerAcntManagementDao.deleteStdCustomrAcnt(paramMap);
					resultInt += customerAcntManagementDao.deleteStdCustomrAcntAppr(paramMap);
				}
			}
		}
		
		return resultInt;
	}

}
