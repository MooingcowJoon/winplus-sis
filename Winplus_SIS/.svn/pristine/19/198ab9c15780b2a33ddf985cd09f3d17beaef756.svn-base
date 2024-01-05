package com.samyang.winplus.common.board.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.board.service.BoardService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.file.service.FileService;
import com.samyang.winplus.common.system.model.EmpSessionDto;

@RequestMapping("/common/board")
@RestController
public class BoardController extends BaseController {
	
	private final static String DEFAULT_PATH = "common/board";
	
	@Autowired
	BoardService boardService;
	
	@Autowired
	FileService fileService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	/**
	 * @author 조승현
	 * @param request
	 * @return ModelAndView
	 * @description 공지사항 페이지 리턴
	 */
	@RequestMapping(value="noticeBoard.sis", method=RequestMethod.POST)
	public ModelAndView noticeBoard(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "noticeBoard");
		return mav;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @return ModelAndView
	 * @description 사원마당 페이지 리턴
	 */
	@RequestMapping(value="employeeBoard.sis", method=RequestMethod.POST)
	public ModelAndView employeeRecsroom(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "employeeBoard");
		return mav;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 * @description 게시글 팝업 열기
	 */
	@RequestMapping(value="openBoardPopup.sis", method=RequestMethod.POST)
	public ModelAndView openBoardPopup(HttpServletRequest request, @RequestParam Map<String, String> paramMap) throws SQLException, Exception{
		ModelAndView mav = new ModelAndView();
		mav.setViewName("common/popup/" + "openBoardPopup");
		
		if(paramMap.keySet().contains("BOARD_PUBLISH_SCOPE_WINPLUS")) {
			request.setAttribute("BOARD_PUBLISH_SCOPE_WINPLUS", paramMap.get("BOARD_PUBLISH_SCOPE_WINPLUS"));
		}
		if(paramMap.keySet().contains("BOARD_PUBLISH_SCOPE_MK")) {
			request.setAttribute("BOARD_PUBLISH_SCOPE_MK", paramMap.get("BOARD_PUBLISH_SCOPE_MK"));
		}
		if(paramMap.keySet().contains("BOARD_PUBLISH_SCOPE_P")) {
			request.setAttribute("BOARD_PUBLISH_SCOPE_P", paramMap.get("BOARD_PUBLISH_SCOPE_P"));
		}
		if(paramMap.keySet().contains("BOARD_PUBLISH_SCOPE_S")) {
			request.setAttribute("BOARD_PUBLISH_SCOPE_S", paramMap.get("BOARD_PUBLISH_SCOPE_S"));
		}
		
		if(!paramMap.keySet().contains("BOARD_NO")) {
			return mav;
		}
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		boardService.updateReadCount(paramMap);
		Map<String, Object> boardInfo = boardService.getBoardInfo(paramMap);
		boardInfo.put("CRUD", "U");

		Map<String, Object> boardSubjectAndContent = boardService.getBoardSubjectAndContent(paramMap);

		request.setAttribute("boardInfo", new JSONObject(boardInfo).toString());
		request.setAttribute("boardSubject", boardSubjectAndContent.get("SUBJECT"));
		request.setAttribute("boardContent", boardSubjectAndContent.get("CONTENT"));
		request.setAttribute("extra", new JSONArray(fileService.getAttachFileList(paramMap))); //첨부파일
		request.setAttribute("empSessionDto", empSessionDto);
		
		return mav;
	}


	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 게시글 리스트 조회
	 */
	@RequestMapping(value="getBoardList.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> boardList(HttpServletRequest request, @RequestBody Map<String,Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		paramMap.put("LOGIN_USER_BOARD_PUBLISH_SCOPE_CD", empSessionDto.getBoard_publish_scope_cd());
		
		List<Map<String,Object>> gridDataList = boardService.getBoardList(paramMap);
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 메인 홈화면 게시글 조회
	 */
	@RequestMapping(value="mainBoardList.do", method=RequestMethod.POST)
	public Map<String, Object> mainBoardList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		paramMap.put("LOGIN_USER_BOARD_PUBLISH_SCOPE_CD", empSessionDto.getBoard_publish_scope_cd());

		List<Map<String,Object>> gridDataListNotice = boardService.mainBoardList(paramMap);
		resultMap.put("gridDataListNotice", gridDataListNotice);
		
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 게시글 추가, 수정, 삭제
	 */
	@RequestMapping(value="insertBoardPopup.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertBoardPopup(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
//		logger.debug("파라미터 확인 : " + paramMap.toString());
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		
		String CRUD = (String) paramMap.get("CRUD");
		String BOARD_NO = (String) paramMap.get("BOARD_NO");
		String BOARD_KIND_CD = (String) paramMap.get("BOARD_KIND_CD");
		String SUBJECT = (String) paramMap.get("SUBJECT");
		String CONTENT = (String) paramMap.get("CONTENT");
		String CUSER = (String) paramMap.get("CUSER");
		String MUSER = empSessionDto.getEmp_no();

		if(CRUD == null || "".equals(CRUD)){				
			String errMesage = messageSource.getMessage("error.common.noChanged", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else if("C".equals(CRUD) || "U".equals(CRUD) || "D".equals(CRUD)){
			if(CONTENT == null || "".equals(CONTENT) || SUBJECT == null || "".equals(SUBJECT)){
				String errMesage = messageSource.getMessage("error.common.board.content.noData", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1002";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
			} else if(("U".equals(CRUD) || "D".equals(CRUD))&&(BOARD_NO == null || "".equals(BOARD_NO))){
				String errMesage = messageSource.getMessage("error.common.board.boardNo.noData", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1003";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
			} else if(("U".equals(CRUD) || "D".equals(CRUD))&&!CUSER.equals(MUSER)){
				String errMesage = messageSource.getMessage("error.common.system.authority.noAuth", new Object[1], commonUtil.getDefaultLocale());
				String errCode = "1009";
				resultMap = commonUtil.getErrorMap(errMesage, errCode);
			}
		}
		
		if(resultMap.keySet().size() == 0){
			if(CRUD.equals("C")) {
				paramMap.put("CUSER", empSessionDto.getEmp_no());
			}else if(CRUD.equals("U") || CRUD.equals("D")) {
				paramMap.put("MUSER", empSessionDto.getEmp_no());
			}
			
			resultMap.put("dataMap", boardService.insertBoard(paramMap));
		}
		
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws IOException
	 * @description 게시물 다중 삭제
	 */
	@ResponseBody
	@RequestMapping(value="deleteBoardList.do", method=RequestMethod.POST)
	public Map<String, Object> deleteBoardList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws IOException {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		paramMap.put("MUSER", empSessionDto.getEmp_no());
		boardService.deleteBoardList(paramMap);
		return resultMap;
	}
}
