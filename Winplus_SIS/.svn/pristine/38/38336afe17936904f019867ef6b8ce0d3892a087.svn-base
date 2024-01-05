package com.samyang.winplus.common.employee.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.employee.dao.EmpDao;

@Service("EmpService")
public class EmpServiceImpl implements EmpService  {
	@Autowired
	EmpDao empDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	/**
	  * getOrgnList - 조직 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getEmpList(Map<String, String> paramMap) throws SQLException, Exception {
		return empDao.getEmpList(paramMap);
	}
	
	/**
	  * getOrgn - 조직 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getEmp(Map<String, String> paramMap) throws SQLException, Exception {
		return empDao.getEmp(paramMap);
	}
	
	/**
	  * insertOrgn - 조직 저장
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int insertEmp(Map<String, Object> paramMap) throws SQLException, Exception {
		int resultInt = 0;
		String empNo = "";
		
		Object crud = paramMap.get("CRUD");
		empNo = paramMap.get("EMP_NO").toString();
		
		if(crud != null&&empNo != null) {
			if("C".equals(crud)){
				
				paramMap.put("EMP_NO", empNo);
				resultInt += empDao.insertEmp(paramMap);
				if(resultInt!=1){
					throw new Exception();
				}else{
					resultInt += empDao.insertEmpAcnt(paramMap);
					if(resultInt!=2){
						throw new Exception();
					}
				}
				
			} else if ("U".equals(crud)){
				
				resultInt = empDao.updateEmp(paramMap);
				if(resultInt!=1){
					throw new Exception();
				}
				
//				System.out.println("crud : "+crud);
			} else if ("D".equals(crud)){
				
				resultInt += empDao.deleteEmp(paramMap);
			}
		}
		return resultInt;
	}
	
	/**
	  * getExistEmail - 중복 이메일 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int getExistEmail(Map<String, Object> paramMap) throws SQLException, Exception {
		return empDao.getExistEmail(paramMap);
	}
	
	/**
	  * getEmpLoginAddList - 로그인 추가 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getEmpLoginAddList(Map<String, Object> paramMap) throws SQLException, Exception{
		if(logger.isDebugEnabled()){
			//logger.debug("EmpServiceImpl >> getEmpLoginAddList");
		}
		return empDao.getEmpLoginAddList(paramMap);
	}
	
	/**
	  * saveEmpLoginAddList - 로그인 추가 저장
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveEmpLoginAddList(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		if(logger.isDebugEnabled()){
			//logger.debug("EmpServiceImpl >> saveProcCagrList");
		}
		int resultRow = 0;
		for(Map<String, Object> paramMap : paramMapList){
			resultRow += empDao.saveEmpLoginAddList(paramMap);
		}
		return resultRow;
	}

	
	/**
	  * checkEmpLoginList - 변경 가능한 세션 사원번호 존재여부 확인
	  * @author 조승현
	  * @param param
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int checkEmpLoginList(Map<String, Object> paramMap) throws SQLException, Exception {
		return empDao.checkEmpLoginList(paramMap);
	}

	
	/**
	  * getPerfectEmpList - 퍼펙트 사용자 목록 조회
	  * @author 조승현
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> getPerfectEmpList(Map<String, Object> paramMap) throws SQLException, Exception {
		return empDao.getPerfectEmpList(paramMap);
	}

	/**
	  * getPerfectEmpList - 퍼펙트 사용자 정보
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@Override
	public Map<String, Object> getPerfectEmpDetail(Map<String, Object> paramMap) throws SQLException, Exception{
		return empDao.getPerfectEmpDetail(paramMap);
	}

	
	/**
	  * insertPerfectEmp - 퍼펙트 사용자 입력,수정,삭제
	  * @author 조승현
	  * @param request
	  * @return Map<String, Object>
	  */
	@Override
	public int insertPerfectEmp(Map<String, Object> paramMap) throws SQLException, Exception {
		int resultInt = 0;
		Object CRUD = paramMap.get("CRUD");
		
		if(CRUD != null) {
			if("C".equals(CRUD)){
				resultInt += empDao.insertPerfectEmp(paramMap);
			} else if ("U".equals(CRUD)){
				resultInt += empDao.updatePerfectEmp(paramMap);
			} else if ("D".equals(CRUD)){
				resultInt += empDao.deletePerfectEmp(paramMap);
			}
			if(resultInt!=1){
				throw new Exception();
			}
		}
		
		return resultInt;
	}

	/**
	  * 이용중인 담당자 코드인지 조회
	  * @author 조승현
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int memeberCodeAvailableCheck(Map<String, Object> paramMap) throws SQLException, Exception {
		return empDao.memeberCodeAvailableCheck(paramMap);
	}

	/**
	  * getEmpByGrupList - 사용자별 그룹 관리 - 그룹 조회
	  * @author 강신영
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> getEmpByGrupList(Map<String, Object> paramMap) throws SQLException, Exception {
		return empDao.getEmpByGrupList(paramMap);
	}

	/**
	  * saveEmpByGrupList - 사용자별 그룹 관리 - 그룹 저장
	  * @author 강신영
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	@Override
	public int saveEmpByGrupList(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		int resultRow = 0;
		for(Map<String, Object> paramMap : paramMapList){
			resultRow += empDao.saveEmpByGrupList(paramMap);
		}
		return resultRow;
	}
	
	/**
	 * getEmpGrupDetailList - 사용자별 그룹관리 - 그룹 상세조회
	 * @author 정혜원
	 * @param request
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> getEmpGrupDetailList(Map<String, Object> paramMap) throws SQLException, Exception {
		return empDao.getEmpGrupDetailList(paramMap);
	}
	
	/**
	  * saveEmpByGrupDetailList - 사용자별 거래처그룹 관리 - 거래처 상세내역 저장
	  * @author 정혜원
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	@Override
	public int saveEmpByGrupDetailList(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		int resultRow = 0;
		for(Map<String, Object> paramMap : paramMapList){
			resultRow += empDao.saveEmpByGrupDetailList(paramMap);
		}
		return resultRow;
	}

	/**
	  * getPartnerList - 사용자 조회(협력사)
	  * @author 조승현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> getPartnerList(Map<String, String> paramMap) {
		return empDao.getPartnerList(paramMap);
	}

	/**
	  * getCustomerList - 사용자 조회(고객사)
	  * @author 조승현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> getCustomerList(Map<String, String> paramMap) {
		return empDao.getCustomerList(paramMap);
	}

	/**
	  * initPassword - 비밀번호 초기화
	  * @author 조승현
	  * @param paramMap
	  */
	@Override
	public void initPassword(Map<String, String> paramMap) {
		empDao.initPassword(paramMap);
	}
}
