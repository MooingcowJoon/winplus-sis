package com.samyang.winplus.common.pos.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.microsoft.sqlserver.jdbc.SQLServerException;
import com.samyang.winplus.common.pos.service.PosVersionManagementService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.property.PropertyManagement;

@RestController
@RequestMapping("/common/pos/PosVersionManagement")
public class PosVersionManagementController extends BaseController{
	@Autowired
	PosVersionManagementService posVersionManagementService;
	
	@Autowired
	PropertyManagement propertyService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final static String DEFAULT_PATH = "common/linkedPOS";
	
	private final String Down_Dir = "\\\\192.168.210.17\\sis_file\\version_upload_test";
	
	/**
	  * 시스템관리 - POS연동관리 - 직영점포스관리
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "posVersionManagement.sis", method = RequestMethod.POST)
	public ModelAndView posVersionManagement(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "posVersionManagement");
		return mav;
	}
	
	/**
	  * getPosVersionList
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getPosVersionList.do", method = RequestMethod.POST)
	public Map<String, Object> getPosVersionList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String SEARCH_NM = request.getParameter("SEARCH_NM");
		String DateFrom = request.getParameter("VersionDateFrom");
		String DateTo = request.getParameter("VersionDateTo");
		
		paramMap.put("SEARCH_NM", SEARCH_NM);
		paramMap.put("DateFrom", DateFrom);
		paramMap.put("DateTo", DateTo);
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		try {
			gridDataList = posVersionManagementService.getPosVersionList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		} catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		
		return resultMap;
	}
	
	/**
	  * openPosVersionFileUploadPopup
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openPosVersionFileUploadPopup.sis", method = RequestMethod.POST)
	public ModelAndView openPosVersionFileUploadPopup(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "openPosVersionFileUploadPopup");
		return mav;
	}
	
	/**
	  * uploadPosVersionFile
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	 * @throws Exception 
	  */
	@RequestMapping(value = "uploadPosVersionFile.do", method = RequestMethod.POST)
	public Map<String, Object> uploadPosVersionFile(HttpServletRequest request, @RequestParam("VerFile") MultipartFile VerFile) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		try {
			String resultValue = posVersionManagementService.PosVersionFileUpload(VerFile, emp_no);
			
			resultMap.put("result", resultValue);
			
		} catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * getVersionByMarketList
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getVersionByMarketList.do", method = RequestMethod.POST)
	public Map<String, Object> getVersionByMarketList(HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String ORGN_CD = request.getParameter("SEARCH_MARKET");
		paramMap.put("ORGN_CD", ORGN_CD);
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		try {
			gridDataList = posVersionManagementService.getVersionByMarketList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * getPosVersionConfirmList
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getPosVersionConfirmList.do", method = RequestMethod.POST)
	public Map<String, Object> getPosVersionConfirmList(HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String MS_NO = request.getParameter("MS_NO");
		String SearchDateFrom = request.getParameter("SearchDateFrom");
		String SearchDateTo = request.getParameter("SearchDateTo");
		
		paramMap.put("MS_NO", MS_NO);
		paramMap.put("SearchDateFrom", SearchDateFrom);
		paramMap.put("SearchDateTo", SearchDateTo);
		//logger.debug("getPosVersionCinfirmList paramMap >>> " + paramMap);
		
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		try {
			gridDataList = posVersionManagementService.getPosVersionConfirmList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		} catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * ConfirmPosVersion
	  * @author 한정훈
	  * @param paramMap
	  * @return Map<String, Object>
	  */
	@ResponseBody
	@RequestMapping(value = "ConfirmPosVersion.do", method = RequestMethod.POST)
	public Map<String, Object> ConfirmPosVersion(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int resultRowCnt = posVersionManagementService.ConfirmPosVersion((List<Map<String, Object>>) paramMap.get("listMap"));
		resultMap.put("resultRowCnt", resultRowCnt);
		
		return resultMap;
	}
	
	/**
	  * saveVersionFileState
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "saveVersionFileState.do", method = RequestMethod.POST)
	public Map<String, Object> saveVersionFileState(HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		
		//logger.debug("dhtmlxParamMapList >> " + dhtmlxParamMapList);
		
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		try {
			gridDataList = posVersionManagementService.saveVersionFileState(dhtmlxParamMapList);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * VersionUploadSave
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "VersionUploadSave.do", method = RequestMethod.POST)
	public Map<String, Object> VersionUploadSave(HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String EMP_NO = empSessionDto.getEmp_no();
		
		
		for(Map<String, Object> paramMap : dhtmlxParamMapList) {
			paramMap.put("EMP_NO", EMP_NO);
		}
		
		//logger.debug("dhtmlxParamMapList >>> " + dhtmlxParamMapList);
		
		try {
			gridDataList = posVersionManagementService.VersionUploadSave(dhtmlxParamMapList);
			resultMap.put("gridDataList", gridDataList);
		} catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * getBrowser - 브라우저 버전 체크
	  * @author 신기환
	  * @param request
	  * @throws Exception 
	  */
	private String getBrowser(HttpServletRequest request) { 
		String header = request.getHeader("User-Agent"); 
		if (header.indexOf("MSIE") > -1) { return "MSIE"; } 
		else if (header.indexOf("Chrome") > -1) { return "Chrome"; } 
		else if (header.indexOf("Opera") > -1) { return "Opera"; } 
		else if (header.indexOf("Trident/7.0") > -1){ 
			//IE 11 이상 //IE 버전 별 체크 >> Trident/6.0(IE 10) , Trident/5.0(IE 9) , Trident/4.0(IE 8) 
			return "MSIE"; 
		} 
		return "Firefox"; 
	}
	
	/**
	  * getDisposition - 파일명 특수문자 처리
	  * @author 신기환
	  * @param request
	  * @throws Exception 
	  */
	private String getDisposition(String filename, String browser) throws Exception { 
		String encodedFilename = null; 
		if ("MSIE".equals(browser)) { 
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20"); 
		} 
		else if ("Firefox".equals(browser)) { 
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\""; 
		} 
		else if ("Opera".equals(browser)) { 
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\""; 
		} 
		else if ("Chrome".equals(browser)) { 
			StringBuilder sb = new StringBuilder(); 
			for (int i = 0; i < filename.length(); i++) { 
				char c = filename.charAt(i); 
				if (c > '~') { 
					sb.append(URLEncoder.encode("" + c, "UTF-8")); 
				} 
				else { sb.append(c); } 
			} 
			encodedFilename = sb.toString(); 
		} 
		else {
//			throw new RuntimeException("Not supported browser");
			throw new Exception("Not supported browser");
		} 
		return encodedFilename; 
	}
	
	/**
	  * POS - 버전파일 다운로드
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "downloadVersionFile.do")
	public void downloadVersionFile(HttpServletRequest request, HttpServletResponse response) throws SQLServerException, SQLException, Exception{
		//logger.debug("response >>>> " + response);
		
		String root = "\\\\192.168.210.17";
	    String zipPath = "\\sis_file\\version_upload_test\\";
	    String file_name = request.getParameter("FILE_NAME") == null ? "" : request.getParameter("FILE_NAME");
		
	    
		String cmd = root + zipPath + file_name + ".zip";
	    
	    // 다운로드
	    File tmpFile= new File(cmd);
	    long fileSize = tmpFile.length();   
	
	    BufferedInputStream  bis = null;
	    BufferedOutputStream bos = null;
	    response.reset();
	    
	  //다운로드 한글깨짐 처리
	    String ori_fileName = getDisposition(tmpFile.getName(), getBrowser(request));
	    //logger.debug("tmpFile.getName() >>> " + tmpFile.getName());
	    //logger.debug("getBrowser(request) >>> " + getBrowser(request)); 
	    //logger.debug("ori_fileName >>> " + ori_fileName);

	    response.setHeader("Content-Disposition", "attachment;filename=\""+ori_fileName+"\";");
	    response.setHeader("Content-Type", "application/octet-stream; charset=UTF-8");
	    response.setHeader("Content-Length",            "" + fileSize);
	    response.setHeader("Content-Transfer-Encoding", "binary;");
	    response.setHeader("Pragma",                    "no-cache;");
	    response.setHeader("Expires",                   "-1;");
       
        bis = new BufferedInputStream( new FileInputStream(tmpFile) );
        byte buffer[] = new byte[4096];
        int len = 0;
        bos = new BufferedOutputStream( response.getOutputStream() );

        while((len = bis.read(buffer)) > 0 ){
            bos.write(buffer,0,len);
        }
       
        response.flushBuffer();
        if (bis !=null) bis.close();
        if (bos !=null) bos.close();
        
        //logger.debug("다운로드완료");

	}
	/**
	  * VersionUploadDelete
	  * @author 한정훈
	  * @param paramMap
	  * @return Map<String, Object>
	  * @throws Exception
	  * @throws SQLException
	  */
	@RequestMapping(value="VersionUploadDelete.do", method=RequestMethod.POST)
	public Map<String, Object> VersionUploadDelete(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		//logger.debug("VersionUploadDelete paramMap >>>> " + paramMap);
		Map<String, Object> VersionUploadDelete = posVersionManagementService.VersionUploadDelete(paramMap);
		resultMap.put("result", VersionUploadDelete);
		
		return resultMap;
	}
}
