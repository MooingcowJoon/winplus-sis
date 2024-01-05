package com.samyang.winplus.sis.member.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;


@Service("MemberService")
public interface MemberService {

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 회원 리스트 조회
	 */
	List<Map<String, String>> getMemberList(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @description 회원 정보 조회
	 */
	Map<String, Object> getMemberInfo(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 회원 그룹 콤보 리스트
	 */
	List<Map<String, String>> getMemberGroupComboList(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 회원 정보 저장
	 */
	Map<String, Object> crudMemberInfo(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 거래내역 조회
	 */
	List<Map<String, String>> getTransactionHistory(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description  과세 면세 조회
	 */
	List<Map<String, String>> getTaxExemptAmount(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 회원의 베스트 상품 조회
	 */
	List<Map<String, String>> getMemberBestGoodsList(Map<String, Object> paramMap);
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 베스트 회원 조회
	 */
	List<Map<String, String>> getBestMemberList(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 회원 월별 추이
	 */
	Map<String, Object> getMemberMonthlyTrend(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return
	 * @description 회원의 상품 등록,수정,삭제
	 */
	void crudMemberGoodsPrice(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 거래 원장 조회
	 */
	List<Map<String, String>> getMemberTransactionLedgerList(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 이름으로 회원 검색
	 */
	List<Map<String, String>> memberSearch(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 회원 유형 변경
	 */
	void updateMemberType(List<Map<String, Object>> paramListMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 회원 ABC 변경
	 */
	void updateMemberABC(List<Map<String, Object>> paramListMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 회원 상태 변경
	 */
	void updateMemberState(List<Map<String, Object>> paramListMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 회원 일괄 계산서 발행 여부 수정
	 */
	void updateMemberTaxYN(List<Map<String, Object>> paramListMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 회원 현금영수증 타입 변경
	 */
	void updateMemberChgAmtType(List<Map<String, Object>> paramListMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 회원지정가 리스트 조회
	 */
	List<Map<String, String>> getMemberDesignationList(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 회원그룹 리스트 리턴
	 */
	List<Map<String, String>> getMemberGroupList(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 그룹에 속한 회원 리스트 리턴
	 */
	List<Map<String, String>> getMemberListInGroup(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return
	 * @description 회원 그룹 CRUD
	 */
	void crudMemberGroup(Map<String, Object> paramMap);
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return
	 * @description 회원그룹에 회원을 CRUD
	 */
	void crudMemberListInGroup(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 회원도매가 가져오기
	 */
	List<Map<String, Object>> getMemberWSalePrice(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 회원지정가 가져오기
	 */
	List<Map<String, Object>> getMemberGoodsPrice(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @description 회원 변경 로그 조회
	 */
	List<Map<String, Object>> getMemberInfoLog(Map<String, Object> paramMap);

}
