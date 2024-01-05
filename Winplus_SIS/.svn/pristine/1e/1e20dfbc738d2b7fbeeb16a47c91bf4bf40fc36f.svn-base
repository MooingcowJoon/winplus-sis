package com.samyang.winplus.common.organ.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.organ.dao.OrganDao;

@Service("OrganService")
public class OrganServiceImpl implements OrganService {
	@Autowired
	OrganDao organDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public List<Map<String, Object>> getDlvBsnCodeList(Map<String, Object> paramMap) throws SQLException, Exception {
		return organDao.getDlvBsnCodeList(paramMap);
	}

	@Override
	public Map<String, Object> getDlvBsnMap(Map<String, Object> paramMap) throws SQLException, Exception {
		return organDao.getDlvBsnMap(paramMap);
	}

	@Override
	public int saveDlvBsn(Map<String, Object> paramMap) throws SQLException, Exception {
		int resultInt = 0;
		
		Object crud = paramMap.get("CRUD");
		if(crud != null && "C".equals(crud)) {
			int cnt = organDao.getBusinessNumberCheck(paramMap);
			if (cnt > 0){
				//logger.debug("throw new Exception");
				throw new Exception("-1");  // 중복 사업자번호 오류
			}
			resultInt = organDao.insertDlvBsnIfRequest(paramMap);
		}else if(crud != null && "U".equals(crud)) {
			resultInt = organDao.saveDlvBsn(paramMap);
			/* 납품업체 업데이터 시 IF 동작 주석 처리
			if (resultInt > 0){
				resultInt += organDao.insertDlvBsnIfRequest(paramMap);
			}
			*/
		}
		
		
		return resultInt;
	}
	
	@Override
	public int deleteDlvBsn(Map<String, Object> paramMap) throws SQLException, Exception {
		return organDao.deleteDlvBsn(paramMap);
	}
	
	@Override
	public int saveMtrl(List<Map<String, Object>> dhtmlxParamMapList) throws SQLException, Exception {
		int resultInt = 0;

		for(Map<String, Object> paramMap : dhtmlxParamMapList){
			resultInt += organDao.saveMtrl(paramMap);
		}
		
		return resultInt;
	}

	@Override
	public List<Map<String, Object>> getCstmMtrlList(Map<String, Object> paramMap) throws SQLException, Exception {
		return organDao.getCstmMtrlList(paramMap);
	}

	/**
	  * getOrgnList - 조직 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getOrgnList() throws SQLException, Exception {
		List<Map<String, Object>> orgnList = organDao.getOrgnList();
		List<Map<String, Object>> resultCtgrMapList = null;
		if(orgnList != null && !orgnList.isEmpty()){
			resultCtgrMapList = new ArrayList<Map<String, Object>>();
			
			Map<String, Object> hashOrgnMap = new HashMap<String, Object>();
			
			for(Map<String, Object> menuMap : orgnList){
				String orgnCd = (String) menuMap.get("ORGN_CD");
				String orgnNm = (String) menuMap.get("ORGN_NM");
				Short orgnStep = Short.valueOf( menuMap.get("ORGN_STEP").toString() );
				String folderYn = (String) menuMap.get("FOLDER_YN");
								
				/* DhtmlxTree 에 맞추어 데이터 재구성 */ 
				menuMap.put("id", orgnCd);
				menuMap.put("text", orgnNm);
				menuMap.put("folder_yn", folderYn);
				/* 빈 폴더는 이미지가 페이지로 바뀌어서 강제로 이미지 설정 */
				if(folderYn != null && folderYn.equals("Y")){					
					menuMap.put("im0", "folderClosed.gif");
					menuMap.put("im1", "folderOpen.gif");
					menuMap.put("im2", "folderClosed.gif");
				}
				
				hashOrgnMap.put(orgnCd, menuMap);
				
				
				/* 최상위 메뉴 */
				if(orgnStep == 0){
					resultCtgrMapList.add(menuMap);
				}
			}	
			
			/* 하위 메뉴 설정 */
			for(Map<String, Object> menuMap : orgnList){
				Short ctgrStep =  Short.valueOf( menuMap.get("ORGN_STEP").toString());
				if(ctgrStep == 0){
					continue;
				}
				
				/* 상위 메뉴 정보가 없으면 Continue */
				String upperOrgnCd = (String) menuMap.get("UPPER_ORGN_CD");
				if(upperOrgnCd == null || upperOrgnCd.equals("")){
					continue;
				}
				
				Map<String, Object> upperOrgnMap = (Map<String, Object>) hashOrgnMap.get(upperOrgnCd);	
							
				List<Map<String, Object>> item = null;
				if(upperOrgnMap.containsKey("item")){
					item = (List<Map<String, Object>>) upperOrgnMap.get("item");							
				} else {
					item = getNewList();
					upperOrgnMap.put("item", item);
				}
				item.add(menuMap);
			}
		}			
		
		return resultCtgrMapList;
	}
	
	public List<Map<String, Object>> getNewList(){
		return new ArrayList<Map<String, Object>>();
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
	public Map<String, Object> getOrgn(Map<String, Object> paramMap) throws SQLException, Exception {
		return organDao.getOrgn(paramMap);
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
	public int insertOrgn(Map<String, Object> paramMap) throws SQLException, Exception {
		int resultInt = 0;
		int chkChildMenuInt = 0;
		
		Object crud = paramMap.get("CRUD");
		
		if(crud != null) {
			if("C".equals(crud)){
				resultInt += organDao.insertOrgn(paramMap);
			} else if ("U".equals(crud)){
				resultInt += organDao.updateOrgn(paramMap);
			} else if ("D".equals(crud)){
				
				//하위 메뉴 존재여부 체크
				chkChildMenuInt = organDao.chkChildCtgr(paramMap);
				
				//하위메뉴 존재 시 메뉴 삭제 안됨
				if(chkChildMenuInt != 0){
					chkChildMenuInt = 9999;
					return chkChildMenuInt;
				}else{
					resultInt += organDao.deleteOrgn(paramMap);
				}
			}
		}
		return resultInt;
	}
	
	/**
	  * 조직 리스트 조회(세션)
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOrgnListSession(Map<String, Object> paramMap) throws SQLException, Exception{
		return organDao.getOrgnListSession(paramMap);
	}
	
	
	/**
	  * 백화점 조직 리스트 조회(세션)
	  * @author 조승현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getDepartmentStoreOrgnListSession(Map<String, Object> paramMap) throws SQLException, Exception{
		return organDao.getDepartmentStoreOrgnListSession(paramMap);
	}

	
	
	/**
	 * <pre>
	 * 1. 개요 : 조직관리
	 * 2. 처리내용 : 조직별 회계코드 저장
	 * </pre>   
	 * @Method Name : insertErpCode
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int insertErpCode(List<Map<String, Object>> dhtmlxParamMapList) throws SQLException, Exception {
		int resultInt = 0;

		for(Map<String, Object> paramMap : dhtmlxParamMapList){
			resultInt += organDao.insertErpCode(paramMap);
		}
		
		return resultInt;
	}
	
	/**
	 * <pre>
	 * 1. 개요 : 조직관리
	 * 2. 처리내용 : 조직별 회계코드 저장 검증
	 * </pre>   
	 * @Method Name : getErpCodeCheck
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getErpCodeCheck(List<Map<String, Object>> dhtmlxParamMapList) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int resultInt = 0;
		StringBuilder resultStr = new StringBuilder();

		for(Map<String, Object> paramMap : dhtmlxParamMapList){
			Object crud = paramMap.get("CRUD");
			if(crud != null) {
				if("C".equals(crud)){
					int cnt = organDao.getErpCodeCheck(paramMap);
					if(cnt>0){
						resultStr.append(paramMap.get("ERP_CD"));
						resultStr.append(",");
						resultInt++;
					}
					if(logger.isDebugEnabled()){
						//logger.debug("resultInt : "+ resultInt);
						//logger.debug("resultStr : "+ resultStr);
					}
				}
			}
		}
		resultMap.put("resultInt", resultInt);
		resultMap.put("resultStr", resultStr.toString());
		
		return resultMap;
	}
	
	/**
	  * 조직별 회계코드 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getErpCodeList(Map<String, Object> paramMap) throws SQLException, Exception{
		return organDao.getErpCodeList(paramMap);
	}
	
	/**
	  * 조직 리스트 조회(세션) : 자기 공장 제외한 나머지 공장
	  * @author 정인선
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getNotOrgnListSession(Map<String, Object> paramMap) throws SQLException, Exception{
		return organDao.getNotOrgnListSession(paramMap);
	}
	
	@Override
	public int saveFacIf(Map<String, Object> paramMap) throws SQLException, Exception {
		logger.info("saveFacIf Start...");
		int resultInt = 0;
		
		Object type = paramMap.get("type");
		Object classification = paramMap.get("classification");
		Object dlvBsnCd = paramMap.get("number");
		Object dlvBsnNm = paramMap.get("name");
//		Object state = paramMap.get("state");
		Object licensNo = paramMap.get("businessNumber");
		
		Object rpstNm = paramMap.get("ownerName");
		Object telNo = paramMap.get("phoneNumber");
		Object faxNo = paramMap.get("faxNumber");
		//Object charNm = paramMap.get("managerName");
		//Object charEmail = paramMap.get("email");
		Object charTelNo = paramMap.get("managerPhoneNumber");
		Object zipCode = paramMap.get("zipCode");
		Object addr = paramMap.get("baseAddress");
		Object addrDtl = paramMap.get("detailAddress");
		
		Object taxType = paramMap.get("taxType");
		
		Object industry = paramMap.get("industry");
		Object sector = paramMap.get("sector");
		Object sapCode = paramMap.get("erpSalesCode");
		Object erpPurchaseCode = paramMap.get("erpPurchaseCode");

		String regId = "MDM IF";
		String useYn = "Y";
		
		String dlvBsnDivCd = "";
		
		if ("10".equals(classification)){
			dlvBsnDivCd = "DBD003";
		}else if ("20".equals(classification)){
			dlvBsnDivCd = "3".equals(type)?"DBD001":"DBD002";
		}else{
			dlvBsnDivCd = "";
		}

		
		paramMap.put("DLV_BSN_CD", dlvBsnCd);
		paramMap.put("DLV_BSN_NM", dlvBsnNm);
		paramMap.put("LICENS_NO", licensNo);
		paramMap.put("DLV_BSN_DIV_CD", dlvBsnDivCd);
		paramMap.put("RPST_NM", rpstNm);
		//paramMap.put("CHAR_NM", charNm);
		//paramMap.put("CHAR_EMAIL", charEmail);
		paramMap.put("CHAR_TEL_NO", charTelNo);
		paramMap.put("TEL_NO", telNo);
		paramMap.put("FAX_NO", faxNo);
		paramMap.put("ZIPCODE", zipCode);
		paramMap.put("ADDR", addr);
		paramMap.put("ADDR_DTL", addrDtl);
		paramMap.put("INDUSTRY", industry);
		paramMap.put("SECTOR", sector);
		paramMap.put("SAPCODE", erpPurchaseCode);
		paramMap.put("ERP_PURCHASE_CODE", sapCode);
		
		paramMap.put("TAX_TYPE", taxType);
		paramMap.put("USE_YN", useYn);

		paramMap.put("REG_ID", regId);

		

		resultInt += organDao.saveFacIf(paramMap);
		logger.info("saveFacIf End... resultInt : "+resultInt);
		return resultInt;
	}
	
	@Override
	public /**
	  * 조직코드로 조직구분코드 불러오기
	  * @author 정혜원
	  * @param String
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	String getOrnginDivCdByOrgnCd(String ORGN_CD) throws SQLException, Exception {
		return  organDao.getOrgnDivCdByOrgnCd(ORGN_CD);
	}
}
