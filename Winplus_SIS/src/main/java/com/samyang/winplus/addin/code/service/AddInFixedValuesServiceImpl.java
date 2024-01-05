package com.samyang.winplus.addin.code.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.addin.code.dao.AddInFixedValuesDao;

@Service("AddInFixedValuesService")
public class AddInFixedValuesServiceImpl implements AddInFixedValuesService {

	@Autowired
	AddInFixedValuesDao addInFixedValuesDao;
		
	/**
	  * 고정값 마스터 테이블 조회
	  * @author 조승현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getMaster(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return addInFixedValuesDao.getMaster(paramMap);
	}

	/**
	  * 고정값 마스터 테이블 저장
	  * @author 조승현
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveMaster(List<Map<String, Object>> paramMapList)
			throws SQLException, Exception {
		int resultRow = 0;
		Object[] messageArgs = new Object[]{"",""};
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");			
			if(crud != null){				
				if("C".equals(crud)){
					paramMap.put("REG_PROGRM", "insertCommonCode");
					resultRow += addInFixedValuesDao.insertMaster(paramMap);
				} else if("U".equals(crud)){
					paramMap.put("REG_PROGRM", "updateCommonCode");
					resultRow += addInFixedValuesDao.updateMaster(paramMap);
				} else if("D".equals(crud)){
					/* 삭제할 경우 상세코드 유무 확인하여 있으면 Exception */
					int commonCodeDetailCount = addInFixedValuesDao.getDetailCount(paramMap);
					if(commonCodeDetailCount > 0){
						throw new Exception("상세코드가 존재합니다. 개수 : " + commonCodeDetailCount + "<br/>삭제후 다시 시도해주세요.");
					} else {
						resultRow += addInFixedValuesDao.deleteMaster(paramMap);
					}
				}
			}
		}
		
		return resultRow;
	}
	
	/**
	  * 고정값 상세 테이블 조회
	  * @author 조승현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getDetail(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return addInFixedValuesDao.getDetail(paramMap);
	}
	
	/**
	  * 고정값 상세 테이블 저장
	  * @author 조승현
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveDetail(List<Map<String, Object>> paramMapList)
			throws SQLException, Exception {
		int resultRow = 0;
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");			
			if(crud != null){				
				if("C".equals(crud)){
					paramMap.put("REG_PROGRM", "insertCommonCodeDetail");
					resultRow += addInFixedValuesDao.insertDetail(paramMap);
				} else if("U".equals(crud)){
					paramMap.put("REG_PROGRM", "updateCommonCodeDetail");
					resultRow += addInFixedValuesDao.updateDetail(paramMap);
				} else if("D".equals(crud)){
					resultRow += addInFixedValuesDao.deleteDetail(paramMap);
				}
			}
		}
		
		return resultRow;
	}

}

