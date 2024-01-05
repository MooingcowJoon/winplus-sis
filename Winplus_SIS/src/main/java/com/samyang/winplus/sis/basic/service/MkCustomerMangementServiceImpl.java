package com.samyang.winplus.sis.basic.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.basic.dao.MkCustomerMangementDao;
import com.samyang.winplus.sis.basic.service.MkCustomerMangementService;

@Service("MkCustomerMangementService")
public class MkCustomerMangementServiceImpl implements MkCustomerMangementService {
	
	@Autowired
	MkCustomerMangementDao mkCustomerMangementDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	@Override
	public int insertMkCustomer(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateMkCustomer(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteMkCustomer(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}	
	
	@Override
	public List<Map<String, Object>> getSearchCustmrListMk(Map<String, Object> paramMap)  throws SQLException, Exception {
		return mkCustomerMangementDao.getSearchCustmrListMk(paramMap);
	}

	/**
	  * saveCustomerMkScreenList -  대상거래처 납품업체 C,U,D
	  * @author 손경락
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveCustomerMkScreenList(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		int resultInt = 0;		
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");
			//logger.debug("@@@@@@@@@@ MkCustomerMangementServiceImpl.java crud ============" + crud);
			
			if(crud != null) {
				if("C".equals(crud)){
					paramMap.put("PARAM_PROGRM", "insertMkCustomer");
					resultInt += mkCustomerMangementDao.insertMkCustomer(paramMap);
				} else if ("U".equals(crud)){
					paramMap.put("PARAM_PROGRM", "updateMkCustomer");
					resultInt += mkCustomerMangementDao.updateMkCustomer(paramMap);
				} else if ("D".equals(crud)){
					resultInt += mkCustomerMangementDao.deleteMkCustomer(paramMap);
				}
			}
		}
		
		return resultInt;
	}
	
	/**
	  * 사업장별협력사관리 - 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getCustmrByWorkplace(Map<String, Object> paramMap) throws SQLException, Exception {
		return mkCustomerMangementDao.getCustmrByWorkplace(paramMap);
	}
	
	/**
	  * 사업장별협력사관리 - 거래처 추가
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public List<Map<String, Object>> getCustmrInfo(Map<String, Object> paramMap) throws SQLException, Exception {
		return mkCustomerMangementDao.getCustmrInfo(paramMap);
	}
	
	/**
	 * 사업장별협력사관리 - 거래처 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */	
	@Override
	public int saveAddCustmrByWorkplace(Map<String, Object> paramMap) throws SQLException, Exception {
		return mkCustomerMangementDao.saveAddCustmrByWorkplace(paramMap);
	}
	
	/**
	 * 사업장별협력사관리 - 거래처 수정
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */	
	@Override
	public int saveUpdateCustmrByWorkplace(Map<String, Object> paramMap) throws SQLException, Exception {
		return mkCustomerMangementDao.saveUpdateCustmrByWorkplace(paramMap);
	}
}
