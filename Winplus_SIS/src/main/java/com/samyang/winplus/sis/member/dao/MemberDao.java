package com.samyang.winplus.sis.member.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("MemberDao")
public interface MemberDao {

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
	 * @description 회원 정보 생성
	 */
	Map<String, Object> crudMemberInfo(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 
	 */
	List<Map<String, String>> getTransactionHistory(Map<String, Object> paramMap);
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return ist<Map<String, String>>
	 * @description 과세 면세 조회
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
	List<Map<String, String>> getMemberMonthlyTrend(Map<String, Object> paramMap);
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, String>
	 * @description 회원 월 합계
	 */
	Map<String, String> getMemberMonthlyTrend_sum(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, String>
	 * @description 회원 월평균
	 */
	Map<String, String> getMemberMonthlyTrend_average_byMonth(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, String>
	 * @description 회원 1회평균
	 */
	Map<String, String> getMemberMonthlyTrend_average_byCount(Map<String, Object> paramMap);
	
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
	 * @description 회원명으로 회원 검색
	 */
	List<Map<String, String>> memberSearch(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 회원 유형 변경
	 */
	void updateMemberType(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 회원 ABC 변경
	 */
	void updateMemberABC(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 회원 상태 변경
	 */
	void updateMemberState(Map<String, Object> paramMap);
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 회원 세금계산서 발행 변경
	 */
	void updateMemberTaxYN(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 회원 소액처리 변경
	 */
	void updateMemberChgAmtType(Map<String, Object> paramMap);

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
	 * @param list
	 * @description 회원그룹 추가
	 */
	void insertMemberGroup(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param list
	 * @description 회원그룹 업데이트
	 */
	void updateMemberGroup(Map<String, Object> paramMap);
	
	/**
	 * @author 조승현
	 * @param list
	 * @description 회원그룹 미사용처리
	 */
	void deleteMemberGroup(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 그룹에 속한 회원 리스트 리턴
	 */
	List<Map<String, String>> getMemberListInGroup(Map<String, Object> paramMap);
	
	/**
	 * @author 조승현
	 * @param list
	 * @description 회원그룹의 회원을 추가
	 */
	void insertMemberListInGroup(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param list
	 * @description 회원그룹의 회원을 업데이트
	 */
	void updateMemberListInGroup(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param list
	 * @description 회원그룹의 회원을 미사용처리
	 */
	void deleteMemberListInGroup(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 회원도매가 가져오기
	 */
	List<Map<String, Object>> getMemberWSalePrice(List<Map<String,Object>> listMap);

	/**
	 * @author 조승현
	 * @param map
	 * @description 회원지정가 추가
	 */
	void insertMemberGoodsPrice(Map<String, Object> map);

	/**
	 * @author 조승현
	 * @param map
	 * @description 회원지정가 업데이트
	 */
	void updateMemberGoodsPrice(Map<String, Object> map);

	/**
	 * @author 조승현
	 * @param map
	 * @description 회원지정가 삭제
	 */
	void deleteMemberGoodsPrice(Map<String, Object> map);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, Object>>
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
