package com.samyang.winplus.common.system.code.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.code.dao.SystemCodeDao;
import com.samyang.winplus.common.system.util.CommonException;

@Service("SystemCodeService")
public class SystemCodeServiceImpl implements SystemCodeService {

	@Autowired
	SystemCodeDao systemCodeDao;
		
	/**
	  * 공통코드 테이블 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getCommonCodeTable(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return systemCodeDao.getCommonCodeTable(paramMap);
	}

	/**
	  * 공통코드 테이블 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveCommonCodeTable(List<Map<String, Object>> paramMapList)
			throws SQLException, Exception {
		int resultRow = 0;
		Object[] messageArgs = new Object[]{"",""};
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");			
			if(crud != null){				
				if("C".equals(crud)){
					paramMap.put("REG_PROGRM", "insertCommonCode");
					resultRow += systemCodeDao.insertCommonCode(paramMap);
				} else if("U".equals(crud)){
					paramMap.put("REG_PROGRM", "updateCommonCode");
					resultRow += systemCodeDao.updateCommonCode(paramMap);
				} else if("D".equals(crud)){
					/* 삭제할 경우 상세코드 유무 확인하여 있으면 Exception */
					int commonCodeDetailCount = systemCodeDao.getCommonCodeDetailCount(paramMap);
					if(commonCodeDetailCount > 0){
						messageArgs[0] = paramMap.get("CMMN_CD");
						messageArgs[1] = commonCodeDetailCount;
						throw new CommonException("error.common.system.code.common_code.noDeletedCommonCode", messageArgs);
					} else {
						resultRow += systemCodeDao.deleteCommonCode(paramMap);
					}
				}
			}
		}
		
		return resultRow;
	}
	
	/**
	  * 공통코드 상세 테이블 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */	
	@Override
	public List<Map<String, Object>> getCommonCodeDetailTable(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return systemCodeDao.getCommonCodeDetailTable(paramMap);
	}
	
	/**
	  * 공통코드 상세 테이블 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveCommonCodeDetailTable(List<Map<String, Object>> paramMapList)
			throws SQLException, Exception {
		int resultRow = 0;
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");			
			if(crud != null){				
				if("C".equals(crud)){
					paramMap.put("REG_PROGRM", "insertCommonCodeDetail");
					resultRow += systemCodeDao.insertCommonCodeDetail(paramMap);
				} else if("U".equals(crud)){
					paramMap.put("REG_PROGRM", "updateCommonCodeDetail");
					resultRow += systemCodeDao.updateCommonCodeDetail(paramMap);
				} else if("D".equals(crud)){
					resultRow += systemCodeDao.deleteCommonCodeDetail(paramMap);
				}
			}
		}
		
		return resultRow;
	}
	
	/**
	  * 공통코드 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> getCommonCodeList(Map<String, Object> paramMap) throws SQLException, Exception {
		return systemCodeDao.getCommonCodeList(paramMap);
	}
	
	/**
	  * 공통 코드,코드명 목록 조회
	  * @author 조승현
	  * @param request
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getDetailCommonCodeList(Map<String, Object> paramMap) throws SQLException, Exception {
		return systemCodeDao.getDetailCommonCodeList(paramMap);
	}
	
	/**
	  * getCommonCodeByUpperCodeList - 상위코드를 통한 공통코드 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> getCommonCodeByUpperCodeList(Map<String, Object> paramMap) throws SQLException, Exception{
		return systemCodeDao.getCommonCodeByUpperCodeList(paramMap);
	}
	
	/**
	  * 트리코드 테이블 조회
	  * @author 조승현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getTreeCodeTable(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return systemCodeDao.getTreeCodeTable(paramMap);
	}

	/**
	  * 트리코드 테이블 저장
	  * @author 조승현
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int cudTreeCodeTable(List<Map<String, Object>> paramMapList)
			throws SQLException, Exception {
		int resultRow = 0;
		Object[] messageArgs = new Object[]{"",""};
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");			
			if(crud != null){				
				if("C".equals(crud)){
					paramMap.put("REG_PROGRM", "insertTreeCode");
					resultRow += systemCodeDao.insertTreeCode(paramMap);
				} else if("U".equals(crud)){
					paramMap.put("REG_PROGRM", "updateTreeCode");
					resultRow += systemCodeDao.updateTreeCode(paramMap);
				} else if("D".equals(crud)){
					/* 삭제할 경우 상세코드 유무 확인하여 있으면 Exception */
					int commonCodeDetailCount = systemCodeDao.getTreeDetailCodeCount(paramMap);
					if(commonCodeDetailCount > 0){
						messageArgs[0] = paramMap.get("CMMN_CD");
						messageArgs[1] = commonCodeDetailCount;
						throw new CommonException("error.common.system.code.common_code.noDeletedCommonCode", messageArgs);
					} else {
						resultRow += systemCodeDao.deleteTreeCode(paramMap);
					}
				}
			}
		}
		
		return resultRow;
	}
	
	/**
	  * 트리상세코드 테이블 조회
	  * @author 조승현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */	
	@Override
	public List<Map<String, Object>> getTreeDetailCodeTable(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return systemCodeDao.getTreeDetailCodeTable(paramMap);
	}
	
	/**
	  * 트리상세코드 테이블 저장
	  * @author 조승현
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int cudTreeDetailCodeTable(List<Map<String, Object>> paramMapList)
			throws SQLException, Exception {
		int resultRow = 0;
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");			
			if(crud != null){				
				if("C".equals(crud)){
					paramMap.put("REG_PROGRM", "insertCommonCodeDetail");
					resultRow += systemCodeDao.insertTreeDetailCode(paramMap);
				} else if("U".equals(crud)){
					paramMap.put("REG_PROGRM", "updateCommonCodeDetail");
					resultRow += systemCodeDao.updateTreeDetailCode(paramMap);
				} else if("D".equals(crud)){
					resultRow += systemCodeDao.deleteTreeDetailCode(paramMap);
				}
			}
		}
		
		return resultRow;
	}
}

