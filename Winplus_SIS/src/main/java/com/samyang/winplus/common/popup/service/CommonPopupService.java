package com.samyang.winplus.common.popup.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service("commonPopupService")
public interface CommonPopupService {
	/**
	  * 자재코드 목록 조회
	  * @author주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> searchMtrlPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	/**
	  * 자재코드(price) 목록 조회
	  * @author bumseok.oh
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> searchMtrlPricePopup(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	
	/**
	  * 상품코드 목록 조회
	  * @author주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> searchPrdcPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * [제품별표준생산시간관리] 제품목록 조회
	  * @author 유가영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> searchPrdcTimePopup(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * <pre>
	 * 1. 개요 : 납품업체코드 목록 조회 팝업
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : searchDlvBsnPopup
	 * @param paramMap
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> searchDlvBsnPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * <pre>
	 * 1. 개요 : 납품업체코드+가격정보 목록 조회 팝업
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : searchDlvBsnPopup
	 * @param paramMap
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 * @author bumseok.oh
	 */
	List<Map<String, Object>> searchDlvBsnPricePopup(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * <pre>
	 * 1. 개요 : 납품업체코드+가격정보 목록 조회 팝업
	 * 2. 처리내용 :
	 * </pre>   
	 * @Method Name : searchDlvBsnPopup
	 * @param paramMap
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 * @author bumseok.oh
	 */
	List<Map<String, Object>> searchDlvBsnPrices(Map<String, Object> paramMap) throws SQLException, Exception;
	/**
	  * 공장/파트너사 코드 목록 조회
	  * @author 김동현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> searchFacPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 공장/파트너사 코드 목록 조회
	  * @author 김동현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getOrgnPopup(Map<String, Object> paramMap) throws SQLException, Exception;

	List<Map<String, Object>> searchRecipePopup(Map<String, Object> paramMap) throws SQLException, Exception;

	List<Map<String, Object>> searchStndCtgrPopup(Map<String, Object> paramMap) throws SQLException, Exception;

	List<Map<String, Object>> searchDtlCtgrPopup(Map<String, Object> paramMap) throws SQLException, Exception;

	List<Map<String, Object>> searchCstmPopup(Map<String, Object> paramMap) throws SQLException, Exception;

	List<Map<String, Object>> searchCstmByMtrlPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 상품코드 목록 조회
	  * @author 정인선
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> searchPrdcSessionPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	Map<String, Object> searchMtrlDetailPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	List<Map<String,Object>> searchEmpPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	List<Map<String,Object>> searchEmpLoginAddListPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 자재별 평균단가 변경이력 팝업
	  * @author 박성호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> searchMtrlAvgModPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 자재별 입력단가 변경이력 팝업
	  * @author 박성호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> searchInputPricePopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 자재별 입고단가 조회 팝업
	  * @author 박성호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> searchCstmInfoPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 제품별 가공비 조회 팝업
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> searchPrdcProcessPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	/**
	 * getDeliveryProcList- 택배발송처리
	 * @author mi
	 * @param paramMap
	 * @return Map<String, Object>
	 * @exception SQLException
	 * @exception Exception
	 */
	 Map<String, Object> getOpenSearchDeliProcPopup(Map<String,Object> paramMap) throws SQLException, Exception ;
	
	 /**
	  * 통화기록 조회 팝업
	  * @author 김동현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> searchCallHistoryPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 샘플 팝업
	  * @author 김동현
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getOpenSamplePopupList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * 받는날 관리 합산 팝업
	 * @author mi
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @exception SQLException
	 * @exception Exception
	 */
	List<Map<String, Object>> getAcceptDaySumManagementPopup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	 
	/**
	 * getResourcesBuyRegisterPopup - 자재매입 - 등록/수정 
	 * @author mi
	 * @param paramMap
	 * @return Map<String, Object>
	 * @exception SQLException
	 * @exception Exception
	 */
	 Map<String, Object> getResourcesBuyRegisterPopup(Map<String,Object> paramMap) throws SQLException, Exception ;
	
	/**
	 *  getReturnRequestDetail - 고객상담 - 반품요청 
	 * @author 김동현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @exception SQLException
	 * @exception Exception
	 */
	 Map<String, Object>  getReturnRequestDetail(Map<String,Object> paramMap) throws SQLException, Exception ;
	 
	 /**
	  * SMS
	  * @author 주병훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String,Object>> searchSmsList(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	 * searchPreCallData - [고객상담] - 이전 통화기록 조회
	 * 
	 * @author 유가영
	 * @param paramMap
	 * @return List<Map<String,Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String,Object>> searchPreCallData(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	 * searchDetailCallData - [고객상담] - [통화기록 상세조회 팝업] - 통화기록 조회
	 * 
	 * @author 유가영
	 * @param paramMap
	 * @return List<Map<String,Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> searchDetailCallData(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * searchCustomerOrderCallData - [고객주문] - 통화기록 조회 팝업 - 통화기록 조회
	 * 
	 * @author 유가영
	 * @param paramMap
	 * @return List<Map<String,Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String,Object>> searchCustomerOrderCallData(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	 * searchCustomerOrderPaymentData - [고객주문] - 결제내역 조회 팝업 - 결제내역 조회
	 * 
	 * @author 유가영
	 * @param paramMap
	 * @return List<Map<String,Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String,Object>> searchCustomerOrderPaymentData(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * searchDupliCustomerData - [고객상담] - 고객등록 팝업 - 중복고객 리스트 조회
	 * 
	 * @author 유가영
	 * @param paramMap
	 * @return List<Map<String,Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String,Object>> searchDupliCustomerData(Map<String, Object> paramMap) throws SQLException, Exception;	
	
	/**
	 * searchCustomerModData - [고객상담] - 고객정보 수정이력 팝업 - 데이터 조회
	 * 
	 * @author 유가영
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> searchCustomerModData(Map<String, Object> paramMap) throws SQLException, Exception;
	
	
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
	Map<String, Object> getGoodsCategoryTreeList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	
	/**
	 * getCustmrList - [공통] - 거래처조회 팝업 - 데이터 조회
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getCustmrList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getGoodsList - [공통] - 상품조회 팝업 - 데이터 디테일 조회
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getGoodsList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getGoodsInformation - 상품정보 팝업 - 상품정보 조회 - 상품정보 조회
	 * 
	 * @author 강신영
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> getGoodsInformation(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getBcodeList - 상품정보 팝업 - 상품정보 조회 - 바코드 목록 조회
	 * 
	 * @author 강신영
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getBcodeList(Map<String, Object> paramMap);
	
	/**
	 * getGoodsSales - 상품정보 팝업 - 판매정보 조회 
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getGoodsSales(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getGoodsSalesUnder - 상품정보 팝업 - 판매정보 조회 - 판매정보아래 조회
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> getGoodsSalesUnder(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getGoodsStock - 상품정보 팝업 - 재고정보 조회 
	 * 
	 * @author 최지민
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getGoodsStock(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	* getGoodsContents - 상품정보 팝업 - 대중소분류 이름 조회
	* 
	* @author 강신영
	* @return Map<String, Object>
	* @throws SQLException
	* @throws Exception
	*/
	Map<String, Object> getCategoryTMBName(Map<String, Object> paramMap);
	
	/**
	* getGoodsPurInformation - 상품정보 팝업 - 매입정보 조회
	* 
	* @author 정혜원
	* @return List<Map<String, Object>>
	* @throws SQLException
	* @throws Exception
	*/
	List<Map<String, Object>> getGoodsPurInformation(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	* getGoodsPurInfoAVG - 상품정보 팝업 - 매입정보 평균값 조회
	* 
	* @author 정혜원
	* @return List<Map<String, Object>>
	* @throws SQLException
	* @throws Exception
	*/
	List<Map<String, Object>> getGoodsPurInfoAVG(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	* getGoodsModiLog - 상품정보 팝업 - 변경로그 조회
	* 
	* @author 정혜원
	* @return List<Map<String, Object>>
	* @throws SQLException
	* @throws Exception
	*/
	List<Map<String, Object>> getGoodsModiLog(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getGoodsList - [공통] - 상품집합관리팝업 - 상품집합그룹 조회
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getGoodsGroupList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getGoodsGroupCD - [공통] - 상품집합관리팝업 - 상품집합코드조회
	 * 
	 * @param paramMap
	 * @author 정혜원
	 * @return Map<String, Object>
	 */
	Map<String, Object> getGoodsGroupCD(Map<String, Object> paramMap);
	
	/**
	 * addGoodsGroupList - [공통] - 상품집합관리팝업 - 상품집합그룹 추가
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int addGoodsGroupList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * deleteGoodsGroupList - [공통] - 상품집합관리팝업 - 상품집합그룹 삭제
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int deleteGoodsGroupList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * updateGoodsGroupList - [공통] - 상품집합관리팝업 - 상품집합그룹 수정
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int updateGoodsGroupList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getGoodsGroupDetailList - [공통] - 상품집합관리팝업 - 상품집합그룹상세상품 조회
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getGoodsGroupDetailList(Map<String, Object> paramMap)throws SQLException, Exception;
	
	/**
	 * getGoodsGrupSelectedList - [공통] - 상품집합관리팝업 - 상품집합그룹상세상품 추가정보조회
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getGoodsGrupSelectedList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getLastSeqNum - [공통] - 상품집합관리팝업 - 상품집합그룹상세상품 SEQ값 조회
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> getLastSeqNum(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * addGoodsGroupDetailList - [공통] - 상품집합관리팝업 - 상품집합그룹상세상품 추가
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int addGoodsGroupDetailList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * deleteGoodsGroupDetailList - [공통] - 상품집합관리팝업 - 상품집합그룹상세상품 삭제
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int deleteGoodsGroupDetailList(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * updateGoodsGroupDetailList - [공통] - 상품집합관리팝업 - 상품집합그룹상세 업데이트
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return Integer
	 * @throws SQLException
	 * @throws Exception
	 */
	int updateGoodsGroupDetailList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getProjectList - [공통] - 프로젝트조회 팝업 - 데이터 조회
	 * 
	 * @author 손경락
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getProjectList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getProjectList - [공통] - 바코드마스터 팝업 - 바코드마스터에서 상품및 바코드가져온다
	 * 
	 * @author 손경락
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getSearchMasterBarcode(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * getSearchComEmpNo - [공통] - 사원정보 팝업 -  사원정보에서 사원번호,성명,부서,이메일,연락처를 가져온다
	 * 
	 * @author 손경락
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getSearchComEmpNo(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getSearchMemberList - [공통] - 회원조회 팝업 -  회원조회
	 * 
	 * @author 정혜원
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getSearchMemberList(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * addGoodsGrup - 상품그룹추가
	 * 
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> addGoodsGrup(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	 * getPasteGrupGoodsList - 상품그룹상세 바코드 복사붙여넣기
	 * 
	 * @author 정혜원
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 * @throws Exception
	 */
	List<Map<String, Object>> getPasteGrupGoodsList(Map<String, Object> paramMap) throws SQLException, Exception;
	
}
