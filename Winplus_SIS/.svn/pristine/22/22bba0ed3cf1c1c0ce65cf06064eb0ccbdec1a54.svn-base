package com.samyang.winplus.common.popup.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.popup.dao.CommonPopupDao;
import com.samyang.winplus.common.system.util.LoofInterface;
import com.samyang.winplus.common.system.util.LoofUtilObject;

import ch.qos.logback.classic.Logger;

@Service("commonPopupService")
public class CommonPopupServiceImpl implements CommonPopupService {

	@Autowired
	CommonPopupDao commonPopupDao;
	
	
	/**
	  * 자재 코드 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> searchMtrlPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.searchMtrlPopup(paramMap);
	}

	
	/**
	  * 자재 코드 목록 조회
	  * @author bumseok.oh
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> searchMtrlPricePopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.searchMtrlPricePopup(paramMap);
	}
	
	/**
	  * 상품 코드 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> searchPrdcPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.searchPrdcPopup(paramMap);
	}
	
	/**
	  * [제품별표준생산시간관리] 제품목록 조회
	  * @author 유가영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> searchPrdcTimePopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.searchPrdcTimePopup(paramMap);
	}
	
	/**
	  * 납품업체코드 목록 조회 팝업
	  * @author 박성호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> searchDlvBsnPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.searchDlvBsnPopup(paramMap);
	}
	
		
	/**
	  * 납품업체코드+가격정보 목록 조회 팝업
	  * @author bumseok.oh
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> searchDlvBsnPricePopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.searchDlvBsnPricePopup(paramMap);
	}
	
	/**
	  * 납품업체코드+가격정보
	  * @author bumseok.oh
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> searchDlvBsnPrices(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.searchDlvBsnPrices(paramMap);
	}
	
	//
	/**
	  * 공장/파트너사 코드 목록 조회
	  * @author 김동현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> searchFacPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		
		return commonPopupDao.searchFacNPopup(paramMap);	
	}
	
	/**
	  * getOrgnList - 조직 목록 조회
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOrgnPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getOrgnPopup(paramMap);
	}

	@Override
	public List<Map<String, Object>> searchRecipePopup(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return commonPopupDao.searchRecipePopup(paramMap);
	}

	@Override
	public List<Map<String, Object>> searchStndCtgrPopup(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return commonPopupDao.searchStndCtgrPopup(paramMap);
	}

	@Override
	public List<Map<String, Object>> searchDtlCtgrPopup(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return commonPopupDao.searchDtlCtgrPopup(paramMap);
	}

	@Override
	public List<Map<String, Object>> searchCstmPopup(Map<String, Object> paramMap) 
			throws SQLException, Exception {
		return commonPopupDao.searchCstmPopup(paramMap);
	}

	@Override
	public List<Map<String, Object>> searchCstmByMtrlPopup(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return commonPopupDao.searchCstmByMtrlPopup(paramMap);
	}
	
	/**
	  * 상품 코드 목록 조회
	  * @author 정인선
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> searchPrdcSessionPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.searchPrdcSessionPopup(paramMap);
	}


	@Override
	public Map<String, Object> searchMtrlDetailPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.searchMtrlDetailPopup(paramMap);
	}

	@Override
	public List<Map<String, Object>> searchEmpPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.searchEmpPopup(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> searchEmpLoginAddListPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.searchEmpLoginAddListPopup(paramMap);
	}

	/**
	  * 자재별 평균단가 변경이력 팝업
	  * @author 박성호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> searchMtrlAvgModPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		List<Map<String, Object>> mtrlAvgList = commonPopupDao.searchMtrlAvgModPopup(paramMap);
		
		return mtrlAvgList;
	}

	/**
	  * 자재별 입력단가 변경이력 팝업
	  * @author 박성호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> searchInputPricePopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.searchInputPricePopup(paramMap);
	}

	/**
	  * 자재별 입고단가 조회 팝업
	  * @author 박성호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  */
	@Override
	public List<Map<String, Object>> searchCstmInfoPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		List<Map<String, Object>> warehousePriceList = commonPopupDao.searchCstmInfoPopup(paramMap);
		if(!warehousePriceList.isEmpty() && warehousePriceList.size() > 1){
			for(int i = 0; warehousePriceList.size()-1 > i; i++){
				for(int j = i + 1; warehousePriceList.size() > j; j++){
					if(warehousePriceList.get(i).get("UNIT_AMT").equals(warehousePriceList.get(j).get("UNIT_AMT"))){
						warehousePriceList.remove(j);
					}
				}
			}
		}
		return warehousePriceList;
	}
	
	/**
	  * 제품별 가공비 조회 팝업
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> searchPrdcProcessPopup(Map<String, Object> paramMap) throws SQLException, Exception{
		return commonPopupDao.searchPrdcProcessPopup(paramMap);
	}

	/**
	  * getOpenSearchDeliProcPopup - 택배발송처리 - 상세 
	  * @author mi
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */ 
	@Override
	public Map<String, Object> getOpenSearchDeliProcPopup(Map<String,Object> paramMap) throws SQLException, Exception {
		return  commonPopupDao.getOpenSearchDeliProcPopup(paramMap);
	}
	
	/**
	  * searchCallHistoryPopup - 통화기록 팝업
	  * @author mi
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */ 
	@Override
	public List<Map<String, Object>> searchCallHistoryPopup(Map<String, Object> paramMap) throws SQLException, Exception{
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		Object type = paramMap.get("type");
		
		if("C".equals(type)){
			resultList = commonPopupDao.searchCallHistoryPopup2(paramMap);
		} else {
			resultList = commonPopupDao.searchCallHistoryPopup(paramMap);
		}
		
		return resultList;
	}
	
	/**
	  * getOpenSamplePopupList - 샘플 팝업
	  * @author mi
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */ 
	@Override
	public List<Map<String, Object>> getOpenSamplePopupList(Map<String, Object> paramMap) throws SQLException, Exception{
		return  commonPopupDao.getOpenSamplePopupList(paramMap);
	}
	
	/**
	 * getAcceptDaySumManagementPopup - 받는날 관리 합산팝업
	 * @author mi
	 * @param paramMap
	 * @return Map<String, Object>
	 * @exception SQLException
	 * @exception Exception
	 */ 
	@Override
	public List<Map<String, Object>> getAcceptDaySumManagementPopup(Map<String, Object> paramMap) throws SQLException, Exception{
		return  commonPopupDao.getAcceptDaySumManagementPopup(paramMap);
	}
	
	
	/**
	 * getResourcesBuyRegisterPopup - 자재매입 - 등록/수정 
	 * @author mi
	 * @param paramMap
	 * @return Map<String, Object>
	 * @exception SQLException
	 * @exception Exception
	 */
	 public Map<String, Object> getResourcesBuyRegisterPopup(Map<String,Object> paramMap) throws SQLException, Exception {
			return  commonPopupDao.getResourcesBuyRegisterPopup(paramMap);
	 }
	 
	/**
	 * getReturnRequestDetail - 고객상담 - 반품요청  
	 * @author 김동현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @exception SQLException
	 * @exception Exception
	 */
	 public Map<String, Object>  getReturnRequestDetail(Map<String,Object> paramMap) throws SQLException, Exception {
			return  commonPopupDao. getReturnRequestDetail(paramMap);
	 }
	 
	 /**
	  * SMS
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	 public List<Map<String,Object>> searchSmsList(Map<String, Object> paramMap) throws SQLException, Exception{
		 return commonPopupDao.searchSmsList(paramMap);
	 }
	 
	 /**
	 * searchPreCallData - [고객상담] - 이전 통화기록 조회
	 * 
	 * @author 유가영
	 * @see com.samyang.winplus.common.common.popup.service.CommonPopupService#searchPreCallData(java.util.Map)
	 * @param paramMap
	 * @return List<Map<String,Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	public List<Map<String,Object>> searchPreCallData(Map<String, Object> paramMap) throws SQLException, Exception{
		 return commonPopupDao.searchPreCallData(paramMap);
	}
	
	/**
	 * searchDetailCallData - [고객상담] - [통화기록 상세조회 팝업] - 통화기록 조회
	 * 
	 * @author 유가영
	 * @see com.samyang.winplus.common.common.popup.service.CommonPopupService#searchDetailCallData(java.util.Map)
	 * @param paramMap
	 * @return List<Map<String,Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	public Map<String, Object> searchDetailCallData(Map<String, Object> paramMap) throws SQLException, Exception{
		 return commonPopupDao.searchDetailCallData(paramMap);
	}
	
	/**
	 * searchCustomerOrderCallData - [고객주문] - 통화기록 조회 팝업 - 통화기록 조회
	 * 
	 * @author 유가영
	 * @see com.samyang.winplus.common.common.popup.service.CommonPopupService#searchCustomerOrderCallData(java.util.Map)
	 * @param paramMap
	 * @return List<Map<String,Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	public List<Map<String,Object>> searchCustomerOrderCallData(Map<String, Object> paramMap) throws SQLException, Exception{
		 return commonPopupDao.searchCustomerOrderCallData(paramMap);
	}
	
	/**
	 * searchCustomerOrderPaymentData - [고객주문] - 결제내역 조회 팝업 - 결제내역 조회
	 * 
	 * @author 유가영
	 * @see com.samyang.winplus.common.common.popup.service.CommonPopupService#searchCustomerOrderPaymentData(java.util.Map)
	 * @param paramMap
	 * @return List<Map<String,Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	public List<Map<String,Object>> searchCustomerOrderPaymentData(Map<String, Object> paramMap) throws SQLException, Exception{
		 return commonPopupDao.searchCustomerOrderPaymentData(paramMap);
	}
	
	/**
	 * searchDupliCustomerData - [고객상담] - 고객등록 팝업 - 중복고객 리스트 조회
	 * 
	 * @author 유가영
	 * @see com.samyang.winplus.common.common.popup.service.CommonPopupService#searchDupliCustomerData(java.util.Map)
	 * @param paramMap
	 * @return List<Map<String,Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	public List<Map<String,Object>> searchDupliCustomerData(Map<String, Object> paramMap) throws SQLException, Exception{
		 return commonPopupDao.searchDupliCustomerData(paramMap);
	}
	
	/**
	 * searchCustomerModData - [고객상담] - 고객정보 수정이력 팝업 - 데이터 조회
	 * 
	 * @author 유가영
	 * @see com.samyang.winplus.common.common.popup.service.CommonPopupService#searchCustomerModData(java.util.Map)
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	public Map<String, Object> searchCustomerModData(Map<String, Object> paramMap) throws SQLException, Exception{
		 return commonPopupDao.searchCustomerModData(paramMap);
	}
	
	
///////////////////////////////////윈플러스 개발 추가///////////////////////////////////
	
	
	/**
	 * getGoodsCategoryTreeList - [공통] - 상품분류 트리 팝업 - 데이터 조회
	 * 
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGoodsCategoryTreeList(Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<Map<String, Object>> categoryList = commonPopupDao.getGoodsCategoryTreeList(paramMap);
		List<Map<String, Object>> resultCategoryMapList = null;
		if(!categoryList.isEmpty()){
			resultCategoryMapList = new ArrayList<Map<String, Object>>();
			
			Map<String, Object> hashCategoryMap = new HashMap<String, Object>();
			
			String grup_cd = "";
			String grup_nm = "";
			String uni_key = "";
			String upper_uni_key = "";
			
			for(Map<String, Object> categoryMap : categoryList){
				grup_cd = "";
				grup_nm = "";
				uni_key = "";
				upper_uni_key = "";
				
				grup_cd = (String) categoryMap.get("GRUP_CD");
				grup_nm = (String) categoryMap.get("GRUP_NM");
				uni_key = (String) categoryMap.get("UNI_KEY");
				upper_uni_key = (String) categoryMap.get("UPPER_UNI_KEY");
				//String folder_yn = (String) categoryMap.get("FOLDER_YN");
				
				/* DhtmlxTree 에 맞추어 데이터 재구성 */
				categoryMap.put("id", grup_cd);
				categoryMap.put("text", grup_nm);
				/* 빈 폴더는 이미지가 페이지로 바뀌어서 강제로 이미지 설정 */
				/*if(folder_yn != null && folder_yn.equals("Y")){
					categoryMap.put("im0", "folderClosed.gif");
					categoryMap.put("im1", "folderOpen.gif");
					categoryMap.put("im2", "folderClosed.gif");
				}*/
				
				hashCategoryMap.put(uni_key, categoryMap);
				
				
				/* 최상위 메뉴 */
				if(upper_uni_key.equals("0_0_0")){
					resultCategoryMapList.add(categoryMap);
				}
			}
			
			/* 하위 메뉴 설정 */
			Map<String, Object> upperCategoryMap = null;
			List<Map<String, Object>> item = null;
			for(Map<String, Object> categoryMap : categoryList){
				upper_uni_key = "";
				upper_uni_key = (String) categoryMap.get("UPPER_UNI_KEY");
				if(upper_uni_key.equals("0_0_0")){
					continue;
				}
				
				/* 상위 메뉴 정보가 없으면 Continue */
				/*String upper_menu_cd = (String) categoryMap.get("UPPER_MENU_CD");
				if(upper_menu_cd == null || upper_menu_cd.equals("")){
					continue;
				}*/
				
				upperCategoryMap = (Map<String, Object>) hashCategoryMap.get(upper_uni_key);
				
				if(upperCategoryMap == null) {
					continue;
				}
				
				item = null;
				if(upperCategoryMap.containsKey("item")){
					item = (List<Map<String, Object>>) upperCategoryMap.get("item");
				} else {
					item = getNewList();
					upperCategoryMap.put("item", item);
				}
				item.add(categoryMap);
			}
		}
		//return resultCategoryMapList;
		
		//Tree와 Grid 데이터 모두 필요하여 변경함
		returnMap.put("categoryList", categoryList);
		returnMap.put("categoryTree", resultCategoryMapList);
		return returnMap;
	}
	
	public List<Map<String, Object>> getNewList(){
		return new ArrayList<Map<String, Object>>();
	}
	
	/**
	 * getCustmrList - [공통] - 거래처조회 팝업 - 데이터 조회
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	public List<Map<String, Object>> getCustmrList(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getCustmrList(paramMap);
	}
	
	/**
	 * getGoodsList - [공통] - 상품조회 팝업 - 데이터 디테일 조회
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	public List<Map<String, Object>> getGoodsList(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getGoodsList(paramMap);
	}

	/**
	 * getGoodsInformation - 상품정보 팝업 - 상품정보 조회 - 상품정보 조회
	 * 
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getGoodsInformation(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getGoodsInformation(paramMap);
	}

	/**
	 * getBcodeList - 상품정보 팝업 - 상품정보 조회 - 바코드 목록 조회
	 * 
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getBcodeList(Map<String, Object> paramMap) {
		return commonPopupDao.getBcodeList(paramMap);
	}
	
	/**
	 * getGoodsSales - 상품정보 팝업 - 판매정보 조회 
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getGoodsSales(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getGoodsSales(paramMap);
	}
	
	/**
	 * getGoodsSalesUnder - 상품정보 팝업 - 판매정보 조회 -판매정보아래 조회
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getGoodsSalesUnder(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getGoodsSalesUnder(paramMap);
	}
	
	/**
	 * getGoodsStock - 상품정보 팝업 - 재고정보 조회 
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getGoodsStock(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getGoodsStock(paramMap);
	}
	
	/**
	* getGoodsContents - 상품정보 팝업 - 대중소분류 이름 조회
	* 
	* @author 강신영
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	@Override
	public Map<String, Object> getCategoryTMBName(Map<String, Object> paramMap) {
		return commonPopupDao.getCategoryTMBName(paramMap);
	}

	/**
	* getGoodsPurInformation - 상품정보 팝업 - 매입정보 조회
	* 
	* @author 정혜원
	* @return List<Map<String, Object>>
	* @throws SQLException
	* @throws Exception
	*/
	@Override
	public List<Map<String, Object>> getGoodsPurInformation(Map<String, Object> paramMap) throws SQLException, Exception{
		return commonPopupDao.getGoodsPurInformation(paramMap);
	}
	
	/**
	* getGoodsPurInfoAVG - 상품정보 팝업 - 매입정보 평균값 조회
	* 
	* @author 정혜원
	* @return List<Map<String, Object>>
	* @throws SQLException
	* @throws Exception
	*/
	@Override
	public List<Map<String, Object>> getGoodsPurInfoAVG(Map<String, Object> paramMap) throws SQLException, Exception{
		return commonPopupDao.getGoodsPurInfoAVG(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getGoodsModiLog(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getGoodsModiLog(paramMap);
	}
	
	/**
	 * getGoodsList - [공통] - 상품집합관리팝업 - 상품집합그룹 조회
	 * 
	 * @author 정혜원
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getGoodsGroupList(Map<String, Object> paramMap) {
		return commonPopupDao.getGoodsGroupList(paramMap);
	}
	
	
	/**
	 * getGoodsGroupCD - [공통] - 상품집합관리팝업 - 상품집합코드 조회
	 * 
	 * @param paramMap
	 * @author 정혜원
	 * @return Map<String, Object>
	 */
	@Override
	public Map<String, Object> getGoodsGroupCD(Map<String, Object> paramMap) {
		return commonPopupDao.getGoodsGroupCD(paramMap);
	}
	
	/**
	 * addGoodsGroupList - [공통] - 상품집합관리팝업 - 상품집합그룹 추가
	 * 
	 * @author 정혜원
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int addGoodsGroupList(Map<String, Object> paramMap) {
		return commonPopupDao.addGoodsGroupList(paramMap);
	}
	
	/**
	 * deleteGoodsGroupList - [공통] - 상품집합관리팝업 - 상품집합그룹 삭제
	 * 
	 * @author 정혜원
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int deleteGoodsGroupList(Map<String, Object> paramMap) {
		return commonPopupDao.deleteGoodsGroupList(paramMap);
	}
	
	/**
	 * updateGoodsGroupList - [공통] - 상품집합관리팝업 - 상품집합그룹 수정
	 * 
	 * @author 정혜원
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int updateGoodsGroupList(Map<String, Object> paramMap) {
		return commonPopupDao.updateGoodsGroupList(paramMap);
	}
	
	/**
	 * getGoodsGroupDetailList - [공통] - 상품집합관리팝업 - 상품집합그룹상세상품 조회
	 * 
	 * @author 정혜원
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getGoodsGroupDetailList(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getGoodsGroupDetailList(paramMap);
	}
	
	/**
	 * getGoodsGrupSelectedList - [공통] - 상품집합관리팝업 - 상품집합그룹상세상품 추가정보조회
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getGoodsGrupSelectedList(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getGoodsGrupSelectedList(paramMap);
	}
	
	/**
	 * getLastSeqNum - [공통] - 상품집합관리팝업 - 상품집합그룹상세상품 seq조회
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getLastSeqNum(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getLastSeqNum(paramMap);
	}
	
	
	/**
	 * addGoodsGroupDetailList - [공통] - 상품집합관리팝업 - 상품집합그룹상세상품 추가
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int addGoodsGroupDetailList(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.addGoodsGroupDetailList(paramMap);
	}
	
	/**
	 * addGoodsGroupDetailList - [공통] - 상품집합관리팝업 - 상품집합그룹상세상품 삭제
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int deleteGoodsGroupDetailList(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.deleteGoodsGroupDetailList(paramMap);
	}
	
	/**
	 * updateGoodsGroupDetailList - [공통] - 상품집합관리팝업 - 상품집합그룹상세 업데이트
	 * 
	 * @author 정혜원
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int updateGoodsGroupDetailList(Map<String, Object> paramMap) throws SQLException, Exception{
		return commonPopupDao.updateGoodsGroupDetailList(paramMap);
	}
	
	/**
	 * getProjectList - [공통] - 거래처조회 팝업 - 데이터 조회
	 * 
	 * @author 손경락	
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	public List<Map<String, Object>> getProjectList(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getProjectList(paramMap);
	}	
		
	/**
	 * getProjectList - [공통] - 바코드마스터 && 상품마스트에서 상품및  바코드가져온다
	 * 
	 * @author 손경락	
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	public List<Map<String, Object>> getSearchMasterBarcode(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getSearchMasterBarcode(paramMap);
	}	
	
	
	/**
	 * getSearchComEmpNo - [공통] -  사원정보 팝업 -  사원정보에서 사원번호,성명,부서,이메일,연락처를 가져온다
	 * 
	 * @author 손경락	
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	public List<Map<String, Object>> getSearchComEmpNo(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getSearchComEmpNo(paramMap);
	}	
	
	/**
	 * getSearchMemberList - [공통] -  회원조회 팝업 -  회원조회
	 * 
	 * @author 정혜원	
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getSearchMemberList(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.getSearchMemberList(paramMap);
	}
	
	/**
	 * addGoodsGrup - 상품그룹_등록/조회 - 상품그룹추가
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> addGoodsGrup(Map<String, Object> paramMap) throws SQLException, Exception {
		return commonPopupDao.addGoodsGrup(paramMap);
	}
	
	/**
	 * getPasteGrupGoodsList - 상품그룹_등록/조회 - 상품그룹상세 바코드 복사붙여넣기
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getPasteGrupGoodsList(Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = null;
		List<Map<String, Object>> lm = null;
		String BCD_CD = paramMap.get("loadGoodsList").toString();
		BCD_CD = BCD_CD.replace("[", "");
		BCD_CD = BCD_CD.replace("]", "");
		BCD_CD = BCD_CD.replaceAll(" ", "");
		String[] BCD_CD_LIST = BCD_CD.split(",");
		
		List<Map<String, Object>> goods_list = new ArrayList<Map<String, Object>>();
		for(String bcd_cd : BCD_CD_LIST) {
			resultMap = new HashMap<String, Object>();
			if(!bcd_cd.equals("")) {
				resultMap.put("ORGN_CD", paramMap.get("ORGN_CD"));
				resultMap.put("BCD_CD", bcd_cd);
				goods_list.add(resultMap);
			}
		}
		LoofUtilObject l = new LoofUtilObject();
		lm = l.selectAfterLoofBigMapList((List<Map<String, Object>>) goods_list, new LoofInterface() {
			@Override
			public Object exec(Object... obj) {
				return commonPopupDao.getPasteGrupGoodsList((List<Map<String,Object>>) obj[0]);
			}
		});
		return lm;
	}
}
