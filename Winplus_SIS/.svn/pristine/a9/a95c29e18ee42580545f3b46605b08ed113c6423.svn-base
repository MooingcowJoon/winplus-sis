package com.samyang.winplus.common.board.service;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;

import com.samyang.winplus.common.board.dao.BoardDao;
import com.samyang.winplus.common.system.config.EnvironmentInitializer;

@Service("BoardService")
public class BoardServiceImpl implements BoardService{
	
	@Autowired
	BoardDao boardDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Value("${url.fileUploadPathList.board_attachFiles_saveRootDirectory}")
	private String saveRootDirectory;

	@Override
	public List<Map<String, Object>> getBoardList(Map<String,Object> paramMap) throws SQLException, Exception {
		return boardDao.getBoardList(paramMap);
	}

	@Override
	public Map<String, Object> getBoardInfo(Map<String,String> paramMap) throws SQLException, Exception{
		return boardDao.getBoardInfo(paramMap);
	}

	@Override
	public int updateReadCount(Map<String, String> paramMap) throws SQLException, Exception {
		return boardDao.updateReadCount(paramMap);
	}
	
	@Override
	public Map<String, Object> insertBoard(Map<String, Object> paramMap) throws SQLException, Exception {
		Object crud = paramMap.get("CRUD");
		Map<String, Object> resultMap = null;;
		if(crud != null) {
			if("C".equals(crud)){
				resultMap = boardDao.insertBoard(paramMap);
			} else if ("U".equals(crud)){
				boardDao.updateBoard(paramMap);
			} else if ("D".equals(crud)){
				boardDao.deleteBoard(paramMap);
			}
		}
		return resultMap;
	}

	@Override
	public List<Map<String, Object>> mainBoardList(Map<String, Object> paramMap) {
		return boardDao.mainBoardList(paramMap);
	}

	@Override
	public void deleteBoardList(Map<String, Object> paramMap) {
		boardDao.deleteBoardList(paramMap);
	}

	@Override
	public Map<String, Object> getBoardSubjectAndContent(Map<String, String> paramMap) {
		return boardDao.getBoardSubjectAndContent(paramMap);
	}
}
