package com.samyang.winplus.common.board.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("BoardDao")
public interface BoardDao {

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @description 게시물 리스트 조회
	 */
	List<Map<String, Object>> getBoardList(Map<String,Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @description 게시물 상세 내용 가져오기
	 */
	Map<String, Object> getBoardInfo(Map<String,String> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 게시물 조회수 업데이트
	 */
	int updateReadCount(Map<String,String> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object
	 * @description 게시물 생성
	 */
	Map<String, Object> insertBoard(Map<String,Object> paramMap);
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 게시물 업데이트
	 */
	int updateBoard(Map<String,Object> paramMap);
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Integer
	 * @description 게시물 삭제
	 */
	int deleteBoard(Map<String,Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @description 메인 홈 화면 게시글 가져오기
	 */
	List<Map<String, Object>> mainBoardList(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @description 게시물 다중 삭제
	 */
	void deleteBoardList(Map<String, Object> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @description 게시물 제목 상세내용 가져오기
	 */
	Map<String, Object> getBoardSubjectAndContent(Map<String, String> paramMap);
}
