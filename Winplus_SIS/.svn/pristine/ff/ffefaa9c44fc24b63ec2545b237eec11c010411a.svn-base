package com.samyang.winplus.common.popup.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.samyang.winplus.common.popup.dao.PopupDao;
import com.samyang.winplus.common.system.util.LoofInterface;
import com.samyang.winplus.common.system.util.LoofUtilObject;

@Service("PopupService")
public class PopupServiceImpl implements PopupService {
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	PopupDao PopupDao;

	/**
	  * 고객코드 조회
	  * @author양중호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getSearchCustomerCdPopupList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getSearchCustomerCdPopupList(paramMap);
	}
	
	/**
	  * 고객코드 조회
	  * @author양중호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getSearchCustomerTypePopupList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getSearchCustomerTypePopupList(paramMap);
	}
	
	/**
	  * 담당자 조회
	  * @author양중호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getSearchMemberCdPopupList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getSearchMemberCdPopupList(paramMap);
	}
	
	/**
	  * 사업자 조회
	  * @author양중호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getSearchBusinessCdPopupList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getSearchBusinessCdPopupList(paramMap);
	}

	/**
	  * getOpenCustListPopupContent - 고객명부 조회
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getOpenCustListPopupContent(Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("gridDataList", PopupDao.getOpenCustGridList(paramMap));
		resultMap.put("cardDataList", PopupDao.getOpenCustListCardList(paramMap));
		resultMap.put("custDataContent", PopupDao.getOpenCustContent(paramMap));
		
		return resultMap;
	}
	
	/**
	  * updateOpenCustListPopupContentCUD - 고객명부 저장
	  * @author 이병주
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Transactional
	@Override
	public int updateOpenCustListPopupContentCUD(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.updateOpenCustListPopupContentCUD(paramMap);
	}
	
	/**
	  * updateopenCustListPopupContentOffSet - 고객명부 상계처리
	  * @author 권대림
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Transactional
	@Override
	public int updateopenCustListPopupContentOffSet(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.updateopenCustListPopupContentOffSet(paramMap);
	}	
	
	/**
	  * getOpenSearchSaveMoneyPromotionNamePopupList - 적립금행사조회
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOpenSearchSaveMoneyPromotionNamePopupList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getOpenSearchSaveMoneyPromotionNamePopupList(paramMap);
	}	
	
	/**
	  * getOpenSearchCampainPopupList - 캠페인조회 팝업 목록조회
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOpenSearchCampainPopupList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getOpenSearchCampainPopupList(paramMap);
	}
	
	/**
	  * getOpenSearchBuyPurposePopupList - 구매목적조회
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOpenSearchBuyPurposePopupList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getOpenSearchBuyPurposePopupList(paramMap);
	}
	
	/**
	  * getOpenSearchDeliveryList - 배송목록조회 팝업
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOpenSearchDeliveryList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getOpenSearchDeliveryList(paramMap);
	}	
	
	/**
	  * updateOpenSearchDeliveryCUD - 배송목록조회 팝업 배송지수정
	  * @author 이병주
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Transactional
	@Override
	public int updateOpenSearchDeliveryCUD(Map<String, Object> paramMap) throws SQLException, Exception {
		switch ((String) paramMap.get("CRUD")) {
			case "U":
				return PopupDao.updateOpenSearchDeliveryCUD(paramMap);
			case "C":
				return PopupDao.insertOpenSearchDeliveryCUD(paramMap);				
			default:
				return 0;
		}
	}	
	
	/**
	  * getOpenSearchOrderCustomerList - 배송목록조회 주문고객찾기 팝업
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOpenSearchOrderCustomerList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getOpenSearchOrderCustomerList(paramMap);
	}	
	
	/**
	  * getOpenSearchOrderCustomerDetailList - 배송목록조회 주문고객찾기목록 팝업
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOpenSearchOrderCustomerDetailList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getOpenSearchOrderCustomerDetailList(paramMap);
	}		
	
	/**
	  * getOpenSearchDeliveryDupCheckList - 배송목록조회 중복확인
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOpenSearchDeliveryDupCheckList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getOpenSearchDeliveryDupCheckList(paramMap);
	}
	
	/**
	  * updateSaveDeliveryBatchAssignCUD - 배송지일괄등록 처리
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Transactional
	@Override
	public int updateSaveDeliveryBatchAssignCUD(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		int resultRow = 0;
		
		for(Map<String, Object> paramMap : paramMapList){
			resultRow += PopupDao.updateSaveDeliveryBatchAssignCUD(paramMap);
		}
		
		return resultRow;
	}
	
	/**
	  * getOpenSearchFavoriteGoodsList - 선호상품 목록
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOpenSearchFavoriteGoodsList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getOpenSearchFavoriteGoodsList(paramMap);
	}	
	
	/**
	  * getOpenSearchIntroduceCustomerList - 소개한고객 목록
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOpenSearchIntroduceCustomerList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getOpenSearchIntroduceCustomerList(paramMap);
	}
	
	/**
	  * getOpenSearchCustomerGradeList - 회원등급 목록
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOpenSearchCustomerGradeList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getOpenSearchCustomerGradeList(paramMap);
	}		
	
	/**
	  * getOpenSearchMedicalExaminationByInterviewPopupList - 문진표팝업 목록
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOpenSearchMedicalExaminationByInterviewPopupList(Map<String, Object> paramMap) throws SQLException, Exception {

		switch ((String) paramMap.get("MODE")) {
		case "TABSERVICE1_BIG":
			return PopupDao.getOpenSearchMedicalExaminationByInterviewPopupTabService1BigList(paramMap);		
		case "TABSERVICE1_SMALL":
			return PopupDao.getOpenSearchMedicalExaminationByInterviewPopupTabService1SmallList(paramMap);
		case "TABSERVICE1_SMALLCONTENTS":
			return PopupDao.getOpenSearchMedicalExaminationByInterviewPopupTabService1SmallContentsList(paramMap);
		case "TABSERVICE2_BIG":
			return PopupDao.getOpenSearchMedicalExaminationByInterviewPopupTabService2BigList(paramMap);	
		case "TABSERVICE2_SMALL":
			return PopupDao.getOpenSearchMedicalExaminationByInterviewPopupTabService2SmallList(paramMap);
		case "TABSERVICE2_SMALLCONTENTS":
			return PopupDao.getOpenSearchMedicalExaminationByInterviewPopupTabService1SmallContentsList(paramMap);			
		default:
			return null;
		}
		
	}		
	
	/**
	  * getCustomerCounselhappyCallProcPopupSearch - 해피콜처리 팝업 목록조회
	  * @author 이병주
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getCustomerCounselhappyCallProcPopupSearch(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getCustomerCounselhappyCallProcPopupSearch(paramMap);
	}	
	
	/**
	  * updateCustomerCounselhappyCallProcPopupCUD - 해피콜처리 팝업
	  * @author 이병주
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Transactional
	@Override
	public int updateCustomerCounselhappyCallProcPopupCUD(Map<String,Object> paramMap) throws SQLException, Exception {
		int resultRow = 0;

		resultRow += PopupDao.procedureCustomerCounselhappyCallProcPopupCUD(paramMap);
		resultRow += PopupDao.insertCustomerCounselhappyCallProcPopupCUD(paramMap);
		resultRow += PopupDao.updateCustomerCounselhappyCallProcPopupCUD(paramMap);
		
		return resultRow;
	}
	
	/**
	  * getCallRecordFilePath - 유선 녹취 파일 경로 조회
	  * @author 유가영
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getCallRecordFilePath(Map<String,Object> paramMap) throws SQLException, Exception{
		return PopupDao.getCallRecordFilePath(paramMap);
	}
	
	/**
	  * getMobileCallRecordFilePath - 무선 녹취 파일 경로 조회
	  * @author 유가영
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getMobileCallRecordFilePath(Map<String,Object> paramMap) throws SQLException, Exception{
		return PopupDao.getMobileCallRecordFilePath(paramMap);
	}
	
	/**
	  * getCallingCustomerData - 전화 건 고객 정보 조회
	  * @author 유가영
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getCallingCustomerData(Map<String,Object> paramMap) throws SQLException, Exception{
		return PopupDao.getCallingCustomerData(paramMap);
	}
	
	/**
	  * getMemberStatus - 고객상담 - 상담원 상태 조회
	  * @author 유가영
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getMemberStatus() throws SQLException, Exception{
		return PopupDao.getMemberStatus();
	}
	
	/**
	  * getCheckMemberStatus - 고객상담 - 호전환 이전에 상담원 상태 체크
	  * @author 유가영
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getCheckMemberStatus(Map<String,Object> paramMap) throws SQLException, Exception{
		return PopupDao.getCheckMemberStatus(paramMap);
	}
	
	/**
	  * getCheckMemberStatus - 보관분 조회
	  * @author 주병훈
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getOpenSearchStorageList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getOpenSearchStorageList(paramMap);
	}

	/**
	  * deliveryDelete - 배송목록조회 팝업 배송지수정
	  * @author 하혜민
	  * @param request
	  * @return Map<String, Object>
	  */
	@Override
	public int deliveryDelete(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.deliveryDelete(paramMap);
	}	
	
	/**
	 * getRepresentNumber - [전화받기 팝업] - 담당자 대표번호 가져오기
	 * 
	 * @author 유가영
	 * @see com.samyang.winplus.common.common.popup.service.PopupService#getRepresentNumber(java.util.Map)
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getRepresentNumber(Map<String,Object> paramMap) throws SQLException, Exception{
		return PopupDao.getRepresentNumber(paramMap);
	}
	
	/**
	 * updateRepresentNm - [전화걸기 팝업] - 대표번호 변경
	 * 
	 * @author 유가영
	 * @see com.samyang.winplus.common.common.popup.service.PopupService#updateRepresentNm(java.util.Map)
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int updateRepresentNm(Map<String, Object> paramMap) throws SQLException, Exception {
		String preNumber = paramMap.get("preNumber").toString();
		int resultRowCnt = 0;
		
		if(preNumber.equals("0")){
			resultRowCnt = PopupDao.insertRepresentNm(paramMap);
		}else{
			resultRowCnt = PopupDao.updateRepresentNm(paramMap);
		}
		return resultRowCnt;
	}	
	
	/**
	 * memberChangeIf - 담당자변경 윈플러스몰 IF
	 * 
	 * @author 유가영
	 * @see com.samyang.winplus.common.common.popup.service.PopupService#memberChangeIf()
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int memberChangeIf() throws SQLException, Exception{
		return PopupDao.memberChangeIf();
	}
	
///////////////////////////////////윈플러스 개발 추가///////////////////////////////////
	
	/**
	 * getOpenBargainGroupPointList - 특매그룹선택 팝업 -특매그룹조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> getOpenBargainGroupPointList(Map<String, String> paramMap){
		return PopupDao.getOpenBargainGroupPointList(paramMap);
	}
	
	/**
	 * 점포업무관리 -마감내역 -단말 담당자 마감정보 팜업 -상품권 조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getGiftCardList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getGiftCardList(paramMap);
	}
	
	/**
	 * 점포업무관리 - 단말 담당자 마감정보 팜업 - 마감정보 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int savePosManagementInfo(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.savePosManagementInfo(paramMap);
	}
	
	/**
	 * 점포업무관리 - 마감내역 - 직원선택 팝업 - 직원조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getSelectEmpList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getSelectEmpList(paramMap);
	}
	
	/**
	 * 점포업무관리 - 마감내역- 단말 담당자 마감정보 팜업 - 현금 입금액 입력 팝업 - 조회
		 * @author 최지민
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getCashCntList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getCashCntList(paramMap);
	}
	
	/**
	 * 점포업무관리 - 마감내역- 단말 담당자 마감정보 팜업 - 현금 입금액 입력 팝업 - 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int saveDepositCash(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.saveDepositCash(paramMap);
	}
	
	/**
	 * 재고관리 - 재고실사관리 - 재고실사관리 상세목록 팝업
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getStockInspListPopup(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getStockInspListPopup(paramMap);
	}
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 -회원검색팝업 조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getSearchMember(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.getSearchMember(paramMap);
	}
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 - 회원추가
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> addSearchMemberList(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.addSearchMemberList(paramMap);
	}
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 - 회원붙여넣기
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> getMemberInformation(Map<String, Object> paramMap) {
		LoofUtilObject l = new LoofUtilObject();
		List<Map<String, Object>> lm = null;
		lm = l.selectAfterLoofBigList((List<String>) paramMap.get("loadGoodsList"), new LoofInterface() {
			@Override
			public Object exec(Object... obj) {
				return PopupDao.getMemberInformation((List<String>) obj[0]);
			}
		});
		return lm;
	}
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 - 발송
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int saveSendTalk(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.saveSendTalk(paramMap);
	}
	
	/**
	 * 점포업무관리 - 이종상품묶음할인 - 이종상품그룹 수정 팝업 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public int saveBundleGroupInfo(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.saveBundleGroupInfo(paramMap);
	}
	
	/**
	 * 점포업무관리 - 이종상품묶음할인 - 이종상품그룹 선택 팝업 조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */	
	@Override
	public List<Map<String, Object>> getOpenDoubleGroupPointPopup(Map<String, String> paramMap) throws SQLException, Exception{
		return PopupDao.getOpenDoubleGroupPointPopup(paramMap);
	}
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 - 회원정보가져오기
	 * @author 최지민
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> addMemberInformation(Map<String, Object> paramMap) throws SQLException, Exception {
		return PopupDao.addMemberInformation(paramMap);
	}
}
