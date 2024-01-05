package com.samyang.winplus.common.system.file.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;


@Service
public interface FileService {
		
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
	  * 메타데이터 가져오기
	  * @author 신기환
	  * @param paramMap
	  * @return String
	  */
	List<Map<String,Object>> getFileMetaData(Map<String, Object> paramMap) throws SQLException, Exception;
	
	/**
	  * 메타데이터 일련번호 가져오기
	  * @author 신기환
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	String getFileMetaDataNo(Map<String, Object> map) throws SQLException, Exception;

	/**
	  * makeZipFile - 메타데이터 정보 가져오기 & zip파일 생성
	  * @author 신기환
	  * @param paramMap
	  * @param root - 루트경로 
	  * @param [ACUONE - 애큐온전문용 zip] [ETC - 일반 temp성 zip] 
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	String makeZipFile(Map<String, Object> paramMap, String root, String gubn) throws SQLException, Exception;

	/**
	  * 단일파일 생성
	  * @author 신기환
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	String makeSingleFile(Map<String, Object> paramMap) throws SQLException, Exception;

	/**
	  * 메타데이터 인서트
	  * @author 신기환
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	int insertFileMetaData(List<HashMap<String, Object>> list) throws SQLException, Exception;

	/**
	 * @author 조승현
	 * @param paramMap
	 * @param fileMap
	 * @return List<Map<String, Object>>
	 * @description 첨부파일 업로드
	 */
	List<Map<String, Object>> uploadAttachFile(Map<String, String> paramMap, MultiValueMap<String, MultipartFile> fileMap);

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, Object>>
	 * @description 첨부파일들 정보 가져오기
	 */
	List<Map<String, Object>> getAttachFileList(Map<String, String> paramMap);
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return List<Map<String, String>>
	 * @description 첨부파일 삭제
	 */
	List<Map<String, Object>> deleteAttachFile(Map<String, String> paramMap);

	/**
	 * @author 조승현
	 * @param paramMapList
	 * @return List<Map<String, Object>>
	 * @description 첨부파일 다중 삭제
	 */
	List<Map<String, Object>> deleteAttachFileList(List<Map<String, String>> paramMapList);

	/**
	 * @author 조승현
	 * @param paramMapList
	 * @return List<Map<String, Object>>
	 * @description 첨부파일들 정보 업데이트
	 */
	List<Map<String, Object>> updateAttachFileList(List<Map<String, String>> paramMapList);

	/**
	 * @author 조승현
	 * @return String
	 * @description 업로드 시간 가져오기(DB현재시간)
	 */
	String getUploadTime();

	/**
	 * @author 조승현
	 * @return
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
	 * @param fileMap
	 * @return List<Map<String, Object>>
	 * @description 첨부파일 업로드 dhtmlx vault 사용안함
	 */
	void uploadAttachFile2(Map<String, String> paramMap, MultipartFile file);

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
	 * @param listMap
	 * @description 거래처 계약서 파일 리스트 삭제
	 */
	List<Map<String, Object>> deleteAttachContractFileList(List<Map<String, String>> paramMapList);
}
