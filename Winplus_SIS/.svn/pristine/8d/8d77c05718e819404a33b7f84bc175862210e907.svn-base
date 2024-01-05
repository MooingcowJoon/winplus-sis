package com.samyang.winplus.common.system.file.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface FileDao {

	/**
	  * 메타데이터 인서트
	  * @author 신기환
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int insertFileMetaData(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 메타데이터 일련번호 가져오기
	  * @author 신기환
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	String getFileMetaDataNo(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 메타데이터 정보 가져오기
	  * @author 신기환
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	List<Map<String, Object>> getFileMetaData(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	 * @author 조승현
	 * @param paramMap
	 * @description 첨부파일 업로드
	 */
	void uploadAttachFile(Map<String, String> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @description 첨부파일들 가져오기
	 */
	List<Map<String, Object>> getAttachFileList(Map<String, String> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @description 첨부파일 삭제하기
	 */
	void deleteAttachFile(Map<String, String> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @description 첨부파일 정보 업데이트
	 */
	void updateAttachFile(Map<String, String> paramMap);

	/**
	 * @author 조승현
	 * @return String
	 * @description 업로드 시간 가져오기(DB현재시간)
	 */
	String getUploadTime();

	/**
	 * @author 조승현
	 * @return Integer
	 * @description 파일 그룹 번호 얻기
	 */
	Integer getFileGrupNo();

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @description 파일정보 가져오기
	 */
	Map<String, Object> getFileInfo(Map<String, String> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws IOException
	 * @description 상품이미지 첨부파일 가져오기
	 */
	List<Map<String, Object>> getAttachGoodsImageFileList(Map<String, String> paramMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @description 상품이미지 첨부파일 삭제하기
	 */
	void deleteAttachGoodsImageFile(Map<String, String> paramMap);
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @description 거래처 계약서 파일 삭제
	 */
	void deleteAttachContractFile(Map<String, String> paramMap);
}
