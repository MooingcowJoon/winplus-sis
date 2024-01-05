package com.samyang.winplus.sis.standardInfo.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GoodsInformationDao {

	/**
	  * getGoodsInformationList - 상품정보관리 - 상품정보 목록 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getGoodsInformationList(Map<String, Object> paramMap);

	/**
	  * getGoodsInformation - 상품정보관리 - 상품정보 항목 조회
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getGoodsInformation(Map<String, Object> paramMap);

	/**
	  * updateGoodsInformation - 상품정보관리 - 상품정보 항목 저장
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> updateGoodsInformation(Map<String, String> paramMap);

	/**
	  * deleteGoodsInformation - 상품정보관리 - 상품정보 항목 삭제
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> deleteGoodsInformation(Map<String, String> paramMap);

	/**
	  * getGoodsInformationFromBarcode - 상품일괄등록/변경 - 바코드로 상품정보 조회
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> getGoodsInformationFromBarcode(Map<String, Object> paramMap);

	/**
	  * getAllOrgnCdList - 전체 직영점 코드 목록 조회
	  * @author 강신영
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getAllOrgnCdList();

	/**
	  * updateBatchGoodsInformation - 상품일괄등록/변경 - 상품정보 수정
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> updateBatchGoodsInformation(Map<String, Object> paramMap);

	/**
	  * updateBatchBarcodeInformation - 상품일괄등록/변경 - 바코드정보 일괄 수정
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> updateBatchBarcodeInformation(Map<String, Object> paramMap);

	/**
	  * getGoodsRegistInformationList - 상품등록요청(직영점) - 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getGoodsRegistInformationList(Map<String, Object> paramMap);

	/**
	  * updateGoodsRegistInformation - 상품등록요청(직영점) - 저장
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> updateGoodsRegistInformation(Map<String, Object> paramMap);

	/**
	  * validGoodsRegistInformation - 상품등록요청(직영점) - 저장 - 저장된 데이터 검증
	  * @author 강신영
	  * @exception SQLException
	  * @exception Exception
	  */
	void validGoodsRegistInformation();

	/**
	  * getGoodsRegistConfirmList - 상품등록승인관리 - 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getGoodsRegistConfirmList(Map<String, Object> paramMap);

	/**
	  * updateGoodsConfirmApply - 상품등록승인관리 - 승인
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> updateGoodsConfirmApply(Map<String, Object> paramMap);

	/**
	  * updateGoodsConfirmReject - 상품등록승인관리 - 반송
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	Map<String, Object> updateGoodsConfirmReject(Map<String, Object> paramMap);


	/**
	  * getGoodsBalanceList - 저울상품관리 - 저울상품 그룹 조회(Head)
	  * @author 최지민
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getGoodsBalanceList(Map<String, Object> paramMap);

	/**
	  * getGoodsBalanceDetailList - 저울상품관리 - 저울상품 그룹 조회(Detail)
	  * @author 최지민
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getGoodsBalanceDetailList(Map<String, Object> paramMap);

	/**
	  * getBalanceInfoCheck - 저울상품관리 - 저울상품 그룹 저장(Head)
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	Map<String, Object> getBalanceInfoCheck(Map<String, Object> paramMap);

	/**
	  * addBalanceMaster - 저울상품관리 - 저울상품 그룹 저장(Head) -add
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int addBalanceMaster(Map<String, Object> paramMap);

	/**
	  * deleteBalanceMaster - 저울상품관리 - 저울상품 그룹 저장(Head) -delete
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int deleteBalanceMaster(Map<String, Object> paramMap);

	/**
	  * updateBalanceMaster - 저울상품관리 - 저울상품 그룹 저장(Head) -update
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int updateBalanceMaster(Map<String, Object> paramMap);

	/**
	  * getBalanceDetailList - 저울상품관리 - 저울상품 추가(Detail)
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getBalanceDetailList(List<Map<String, Object>> paramMap);

	/**
	  * getBalanceDetailinfoCheck - 저울상품관리 - 저울상품 저장(Detail) 
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	Map<String, Object> getBalanceDetailinfoCheck(Map<String, Object> paramMap);

	/**
	  * addBalanceDetailGoods - 저울상품관리 - 저울상품 저장(Detail) -add
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int addBalanceDetailGoods(Map<String, Object> paramMap);

	/**
	  * deleteBalanceDetailGoods - 저울상품관리 - 저울상품 저장(Detail) -delete
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int deleteBalanceDetailGoods(Map<String, Object> paramMap);

	/**
	  * updateBalanceDetailGoods - 저울상품관리 - 저울상품 저장(Detail) -update
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	int updateBalanceDetailGoods(Map<String, Object> paramMap);
	
	/**
	  * 기준정보관리 - 상품관리 - 퇴출상품관리 조회 
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getGoodsExitList(Map<String, Object> paramMap);

	/**
	  * 기준정보관리 - 상품관리 - 퇴출상품관리 조회 - 대중소구분
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	Map<String, Object> getGoodsExitListTMB(Map<String, Object> paramMap);
	
	/**
	  * 기준정보관리 - 상품관리 - 퇴출상품관리 저장
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	int updateGoodsExitList(Map<String, Object> paramMap);
	
	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 헤더 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getresbarcodeHeaderList(Map<String, Object> paramMap);

	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 디테일 조회
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	List<Map<String, Object>> getresbarcodeDetailList(Map<String, String> paramMap);

	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 바코드 업로드
	  * @author 한정훈
	  * @param request
	  * @return List<Map<String, Object>>
	  */
	List<Map<String, Object>> getRESBCDInfo(Map<String, Object> paramMap);

	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 바코드 저장-추가
	  * @author 한정훈
	  * @param request
	  * @return integer
	  */
	int insertRESBCDList(Map<String, Object> paramMap);

	/**
	  * 기준정보관리 - 상품관리 - 파일그룹번호 등록
	  * @author 조승현
	  * @param paramMap
	  */
	void updateGoodsFileGrupNo(Map<String, Object> paramMap);

	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 바코드 저장-추가
	  * @author 한정훈
	  * @param request
	  * @return integer
	  */
	int updateRESBCDList(Map<String, Object> paramMap);

}