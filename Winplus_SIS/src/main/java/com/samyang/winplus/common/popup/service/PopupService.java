package com.samyang.winplus.common.popup.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("PopupService")
public interface PopupService {
	
	
	/**
	  * 고객코드 조회
	  * @author양중호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getSearchCustomerCdPopupList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 고객유형별 조회
	  * @author양중호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getSearchCustomerTypePopupList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 담당자 조회
	  * @author양중호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getSearchMemberCdPopupList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 사업자 조회
	  * @author양중호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getSearchBusinessCdPopupList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * getOpenCustListPopupContent - 고객명부 조회
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getOpenCustListPopupContent(Map<String,Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateOpenCustListPopupContentCUD - 고객명부 저장
	  * @author 이병주
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int updateOpenCustListPopupContentCUD(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	  * updateopenCustListPopupContentOffSet - 고객명부 상계처리
	  * @author 권대림
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int updateopenCustListPopupContentOffSet(Map<String, Object> paramMap) throws SQLException, Exception;		
	
	/**
	  * getOpenSearchSaveMoneyPromotionNamePopupList - 적립금행사조회
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getOpenSearchSaveMoneyPromotionNamePopupList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getopenSearchCampainPopupList - 캠페인조회 팝업 목록조회
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getOpenSearchCampainPopupList(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	  * getOpenSearchBuyPurposePopupList - 구매목적조회
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getOpenSearchBuyPurposePopupList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getOpenSearchDeliveryList - 배송목록조회 팝업
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getOpenSearchDeliveryList(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	  * updateOpenSearchDeliveryCUD - 배송목록조회 팝업 배송지수정
	  * @author 이병주
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int updateOpenSearchDeliveryCUD(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	  * getOpenSearchOrderCustomerList - 배송목록조회 주문고객찾기 팝업
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getOpenSearchOrderCustomerList(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	  * getOpenSearchOrderCustomerDetailList - 배송목록조회 주문고객찾기목록 팝업
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getOpenSearchOrderCustomerDetailList(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	  * getOpenSearchDeliveryDupCheckList - 배송목록조회 중복확인
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getOpenSearchDeliveryDupCheckList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * updateSaveDeliveryBatchAssignCUD - 배송지일괄등록 처리
	  * @author 이병주
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int updateSaveDeliveryBatchAssignCUD(List<Map<String, Object>> paramMapList) throws SQLException, Exception;	
	
	/**
	  * getOpenSearchFavoriteGoodsList - 선호상품 목록
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getOpenSearchFavoriteGoodsList(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	  * getOpenSearchIntroduceCustomerList - 소개한고객 목록
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getOpenSearchIntroduceCustomerList(Map<String, Object> paramMap) throws SQLException, Exception;		
	
	/**
	  * getOpenSearchCustomerGradeList - 회원등급 목록
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getOpenSearchCustomerGradeList(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	  * getOpenSearchMedicalExaminationByInterviewPopupList - 문진표팝업 인체검색 소분류 목록
	  * @author 이병주
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> getOpenSearchMedicalExaminationByInterviewPopupList(Map<String, Object> paramMap) throws SQLException, Exception;		
	
	/**
	  * getCustomerCounselhappyCallProcPopupSearch - 해피콜처리 팝업 목록조회
	  * @author 이병주
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getCustomerCounselhappyCallProcPopupSearch(Map<String,Object> paramMap) throws SQLException, Exception;		
	
	/**
	  * updateCustomerCounselhappyCallProcPopupCUD - 해피콜처리 팝업
	  * @author 이병주
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int updateCustomerCounselhappyCallProcPopupCUD(Map<String,Object> paramMap) throws SQLException, Exception;		
	
	/**
	  * getCallRecordFilePath - 유선 녹취 파일 경로 조회
	  * @author 유가영
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getCallRecordFilePath(Map<String,Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getMobileCallRecordFilePath - 무선 녹취 파일 경로 조회
	  * @author 유가영
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getMobileCallRecordFilePath(Map<String,Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getCallingCustomerData - 전화 건 고객 정보 조회
	  * @author 유가영
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getCallingCustomerData(Map<String,Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getMemberStatus - 고객상담 - 상담원 상태 조회
	  * @author 유가영
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getMemberStatus() throws SQLException, Exception;
	
	/**
	  * getCheckMemberStatus - 고객상담 - 호전환 이전에 상담원 상태 체크
	  * @author 유가영
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getCheckMemberStatus(Map<String,Object> paramMap) throws SQLException, Exception;
	
	/**
	  * getCheckMemberStatus - 보관분 조회
	  * @author 주병훈
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getOpenSearchStorageList(Map<String,Object> paramMap) throws SQLException, Exception;

	/**
	  * deliveryDelete - 배송목록조회 팝업 배송지수정
	  * @author 하혜민
	  * @param request
	  * @return Map<String, Object>
	  */
	int deliveryDelete(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getRepresentNumber - [전화받기 팝업] - 담당자 대표번호 가져오기
	 * 
	 * @author 유가영
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> getRepresentNumber(Map<String,Object> paramMap) throws SQLException, Exception;

	/**
	 * updateRepresentNm - [전화걸기 팝업] - 대표번호 변경
	 * 
	 * @author 유가영
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int updateRepresentNm(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * memberChangeIf - 담당자 변경 윈플러스몰 IF
	 * 
	 * @author 유가영
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int memberChangeIf() throws SQLException, Exception;
	
///////////////////////////////////윈플러스 개발 추가///////////////////////////////////
	
	/**
	 * getOpenBargainGroupPointList - 특매그룹선택 팝업 -특매그룹조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getOpenBargainGroupPointList(Map<String, String> paramMap);

	/**
	 * 점포업무관리 -마감내역 -단말 담당자 마감정보 팜업 -상품권 조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getGiftCardList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 점포업무관리 - 단말 담당자 마감정보 팜업 - 마감정보 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int savePosManagementInfo(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * 점포업무관리 - 마감내역 - 직원선택 팝업 - 직원조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getSelectEmpList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * 점포업무관리 - 마감내역- 단말 담당자 마감정보 팜업 - 현금 입금액 입력 팝업 - 조회
	 * @author 최지민
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> getCashCntList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 점포업무관리 - 마감내역- 단말 담당자 마감정보 팜업 - 현금 입금액 입력 팝업 - 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int saveDepositCash(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 재고관리 - 재고실사관리 - 재고실사관리 상세목록 팝업
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getStockInspListPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 -회원검색팝업 조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getSearchMember(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 - 회원추가
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> addSearchMemberList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 - 회원붙여넣기
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getMemberInformation(Map<String, Object> paramMap);
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 - 발송
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int saveSendTalk(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 점포업무관리 - 이종상품묶음할인 - 이종상품그룹 수정 팝업 저장
	 * @author 최지민
	 * @param request
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int saveBundleGroupInfo(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 점포업무관리 - 이종상품묶음할인 - 이종상품그룹 선택 팝업 조회
	 * @author 최지민
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getOpenDoubleGroupPointPopup(Map<String, String> paramMap) throws SQLException, Exception;
	
	/**
	 * 회원관리 - 베스트회원 -플러스친구톡팝업 - 회원정보가져오기
	 * @author 최지민
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> addMemberInformation(Map<String, Object> paramMap) throws SQLException, Exception;
}
