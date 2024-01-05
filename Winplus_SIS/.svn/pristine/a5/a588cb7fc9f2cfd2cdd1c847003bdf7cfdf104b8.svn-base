package com.samyang.winplus.sis.standardInfo.controller;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPClientConfig;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.board.service.BoardService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.code.dao.SystemCodeDao;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonException;
import com.samyang.winplus.sis.standardInfo.service.LabelPrintService;

@RequestMapping("/sis/LabelPrint")
@RestController
public class LabelPrintController extends BaseController{
	
private final static String DEFAULT_PATH = "sis/standardInfo";
	
	@Autowired
	BoardService boardService;
	
	@Autowired
	LabelPrintService labelPrintService;
	
	@Autowired
	SystemCodeDao systemCodeDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	
	private static String saveDir = "D:\\Upload_test";
	
	//서비스로 옮기니깐 오류남 수정필요
	public int upload(String remoteFilePath, String fileName, MultipartFile file, HttpServletRequest request) throws IllegalStateException, IOException, Exception, CommonException{
		int result = -1;
		
		FTPClient ftp = null;
		InputStream fis = null;
		File uploadfile = multipartToFile(file);
		//logger.debug("uploadfile.getPath :: " + uploadfile.getPath());
		//logger.debug("uploadfile.length :: " + uploadfile.length());
		String extension = FilenameUtils.getExtension(fileName);
		//logger.debug("extension >> " + extension);
		
		String url = "192.168.210.14";
		String id = "WinplusMrdDeployer";
		String pwd = "1q2w3e4r!";
		int port = 6021;  // 6022포트 열리면 변경하고, 78번서버에서 포트도 변경해주기(승현대리님한테도 말씀드리기)
		
		try {
			ftp = new FTPClient();
			ftp.setControlEncoding("euc-kr");
			
			FTPClientConfig config = new FTPClientConfig();
			ftp.configure(config);
			
			//logger.debug("connect 이전");
			ftp.connect(url, port);
			//logger.debug("connect 이후");
			int reply = ftp.getReplyCode();
			//logger.debug("reply :: "+reply);
			if(!FTPReply.isPositiveCompletion(reply)){
				ftp.disconnect();
				throw new Exception("Exception in connecting to FTP Server");
			}
			ftp.login(id, pwd);
			ftp.setFileType(FTP.BINARY_FILE_TYPE);
			ftp.enterLocalPassiveMode();
			//logger.debug("getPassivePort : " + String.valueOf(ftp.getPassivePort()));
			ftp.changeWorkingDirectory(remoteFilePath);
			//logger.debug("remoteFilePath : " + remoteFilePath);
			
			try{
				//기존에 파일이 존재하는지 확인 -> 존재하면 파일명변경해주고 새로 저장하기 OR 존재하지 않으면 바로 저장 
			   FTPFile[] ftpfiles = ftp.listFiles("");  // public 폴더의 모든 파일을 list 합니다
			   //logger.debug("ftpfiles >> " + ftpfiles);
		       if (ftpfiles != null) {
		           for (int i = 0; i < ftpfiles.length; i++) {
		               FTPFile exists_file = ftpfiles[i];
		               //System.out.println("파일리스트 >> " + exists_file.getName());  // file.getName(), file.getSize() 등등..

		           }
		       }
				
				fis = new FileInputStream(uploadfile);
				//logger.debug("fis >> " + fis);
				boolean isSuccess = ftp.storeFile(fileName, fis); //fis
				//logger.debug("isSuccess :: " + isSuccess);
				
				if(isSuccess){
					result = 1;
				}else {
					throw new CommonException("파일 업로드를 할 수 없습니다.");
				}
			}catch(IOException ex){
				//System.out.println("1.IO Exception :: "+ ex);
			}finally{
				if(fis != null){
					try{
						fis.close();
						return result;
					} catch(IOException ex) {
						//System.out.println("2.IO Exception :: "+ ex);
					}
				}
			}
			ftp.logout();
		} catch(IOException e){
			//System.out.println("3.IO:: "+ e);
		}finally{
			if(ftp != null && ftp.isConnected()){
				try{
					ftp.disconnect();
					return result;
				}catch(IOException e){
					//System.out.println("4.IO Exception :: "+ e.getMessage());
				}
			}
		}
		
		
		return result;
	}

	private File multipartToFile(MultipartFile multipart) throws IllegalStateException, IOException {
		File convFile = new File(multipart.getOriginalFilename());
		convFile.createNewFile();
		FileOutputStream fos = new FileOutputStream(convFile);
		fos.write(multipart.getBytes());
		fos.close();
		return convFile;
	}
	
	
	private String restore(MultipartFile file) {
		
		//원파일 이름
		String orgName = file.getOriginalFilename();
		//logger.debug("orgName :: " + orgName);
		
		//확장자명
		String exName = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
		//logger.debug("exName :: " + exName);
		
		//확장자명을 제거한 파일명
		int idx = orgName.lastIndexOf(".");
		String OnlyFileName = orgName.substring(0, idx);
		
		
		//저장파일이름
		SimpleDateFormat date_dayTime = new SimpleDateFormat("yyMMddHHmmss");
		Date date = new Date();
		String saveName = orgName;
		//logger.debug("saveName :: " + saveName);
		
		
		File fileCHECK = new File(saveDir + "\\" + orgName);
		File BackupFile = new File(saveDir + "\\" + OnlyFileName + "_bak_" + date_dayTime.format(date) + ".mrd");
		
		//logger.debug(fileCHECK + " / " + BackupFile);
		
		if(fileCHECK.exists()){
			//logger.debug("이미 파일명 존재");
			fileCHECK.renameTo(BackupFile);
		}
		
		String filePath = saveDir + "\\" +saveName;
		//logger.debug("filePath :: " + filePath);
		
		//파일카피
		try{
			byte[] fileData = file.getBytes();
			File LabelMRD = new File(saveDir);
			
			if(!LabelMRD.exists()){
				//디렉토리 생성 메서드
				LabelMRD.mkdirs();
				//logger.debug("created directory successfully!");
			}
			
			OutputStream out = new FileOutputStream(filePath);
			BufferedOutputStream bout = new BufferedOutputStream(out);
			bout.write(fileData);
			
			if(bout != null) {
				bout.close();
			}
			
			return saveName;
			
		} catch(IOException e) {
			e.printStackTrace();
			return "mrdFail";
		}
		
	}
	
	
	
	/**
	  * 기준정보관리 - 라벨출력
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="labelprintPopup.sis", method=RequestMethod.POST)
	public ModelAndView labelmanagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		String GOODS_NO_LIST = request.getParameter("GOODS_NO_LIST") == null ? "" : request.getParameter("GOODS_NO_LIST");
		String BCD_LIST = request.getParameter("BCD_LIST") == null ? "" : request.getParameter("BCD_LIST");
		mav.addObject("GOODS_NO_LIST", GOODS_NO_LIST);
		mav.addObject("BCD_LIST", BCD_LIST);
		mav.setViewName(DEFAULT_PATH + "/" + "openLabelPrintPopup");
		return mav;
	}
	
	/**
	  * getBCodeList - 기준정보관리 - 라벨출력 - 상품코드조회
	  * @author 정혜원
	  * @param request
	  * @return Map
	  */
	@RequestMapping(value="getBCodeList.do", method=RequestMethod.POST)
	public Map<String, Object> getBCodeList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String[] BCD_LIST = request.getParameterValues("bcd_list");
		String ORGN_DIV_CD = request.getParameter("ORGN_DIV_CD");
		String ORGN_CD = request.getParameter("ORGN_CD");
		
		StringBuilder paramBCD = new StringBuilder();
		for(int i = 0 ; i < BCD_LIST.length ; i++){
			if(i != BCD_LIST.length-1){
				paramBCD.append("'");
				paramBCD.append(BCD_LIST[i]);
				paramBCD.append("',");
			} else {
				paramBCD.append("'");
				paramBCD.append(BCD_LIST[i]);
				paramBCD.append("'");
			}
		}
		
		paramMap.put("BCD_CD", paramBCD.toString());
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		
		try{
			List<Map<String, Object>> gridDataList = labelPrintService.getBCodeList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			logger.error(e.toString());
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	
	/**
	  * uploadMrdFile - 기준정보관리 - 라벨등록 - mrd파일업로드
	  * @author 정혜원
	  * @param request
	  * @return Map
	 * @throws Exception 
	  */
	@RequestMapping(value="uploadMrdFile.do", method=RequestMethod.POST)
	public int uploadMrdFile(HttpServletRequest request, @RequestParam("MrdFile") MultipartFile MrdFile) throws Exception {
		//logger.debug("mrd파일 업로드하러 왔습니다.");
		
		int resultNum = 0;
		String result = restore(MrdFile);
		//logger.debug("결과 >>> " + result);
		
		if(result.equals("mrdFail")){
			//logger.debug("파일업로드 실패");
			resultNum = 0;	
		} else {
			//logger.debug("파일업로드 성공 >>> " + result);
			resultNum = 1;
		}
		
		return resultNum;
	}
	
	/**
	  * getMrdFileList - 기준정보관리 - 라벨등록 - mrd파일업로드
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getMrdFileList.do", method=RequestMethod.POST)
	Map<String, Object> getMrdFileList(HttpServletRequest request) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		
		File dirFile = new File(saveDir);
		File [] fileList = dirFile.listFiles();
		int fileList_LEN = fileList.length;
		if(fileList_LEN == 0){
			result.put("fileList", null);
		}else {
			String [] fileNameList = new String[fileList_LEN];
			for(int i = 0 ; i < fileList_LEN ; i++) {
				if(fileList[i].isFile()){
				    String tempFileName = fileList[i].getName();
				    //logger.debug("FileName="+tempFileName);
				    fileNameList[i] = tempFileName;
				}
			}
			result.put("fileList", fileNameList);
		}
		
		return result;
	}
	
	/**
	  * addMRDCommonCode - 기준정보관리 - 라벨등록 - mrd파일업로드
	  * @author 정혜원
	  * @param request
	  * @return Integer
	  */
	@RequestMapping(value="addMRDCommonCode.do", method=RequestMethod.POST)
	int addMRDCommonCode(HttpServletRequest request) throws Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String MrdFileName = request.getParameter("MrdFileName");
		int result = 0;
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		//확장자명을 제거한 파일명
		int idx = MrdFileName.lastIndexOf(".");
		String OnlyFileName = MrdFileName.substring(0, idx);
		
		
		paramMap.put("CMMN_CD", "MRD_FILE");
		paramMap.put("CMMN_DETAIL_CD", MrdFileName);
		paramMap.put("CMMN_DETAIL_CD_NM", MrdFileName);
		paramMap.put("ORDR", "1");
		paramMap.put("USE_YN", "Y");
		paramMap.put("BEGIN_DATE", "20170101");
		paramMap.put("END_DATE", "29991231");
		paramMap.put("REG_PROGRM", "insertCommonCodeDetail");
		paramMap.put("REG_ID", emp_no);
		
		int MRD_CHECK = Integer.parseInt((labelPrintService.checkMrdFile(paramMap).get("NUM").toString()));
		
		if(MRD_CHECK != 0){
			SimpleDateFormat date_dayTime = new SimpleDateFormat("yyMMddHHmmss");
			Date date = new Date();
			
			OnlyFileName = OnlyFileName + "_bak_" + date_dayTime.format(date) + ".mrd";
			paramMap.put("CMMN_DETAIL_CD", OnlyFileName);
			paramMap.put("CMMN_DETAIL_CD_NM", OnlyFileName);
		}
		
		result = systemCodeDao.insertCommonCodeDetail(paramMap);
		
		//logger.debug("저장되는지 확인필요 >> " + result);
		
		return result;
		
	}
	
	/**
	  * openPdaLabelGridPopup - 데이터전송받은 PDA내역 팝업
	  * @author 정혜원
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value = "openPdaLabelGridPopup.sis", method = RequestMethod.POST)
	public ModelAndView TellOrder(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("param", paramMap);
		mav.setViewName(DEFAULT_PATH + "/" + "openPdaLabelGridPopup");
		return mav;
	}
	
	/**
	  * getPdaLabelList - 데이터전송받은 PDA내역 조회
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getPdaLabelList.do", method = RequestMethod.POST)
	public Map<String, Object> getPdaLabelList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = new ArrayList<Map<String, Object>>();
		
		try {
			gridDataList = labelPrintService.getPdaLabelList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	/**
	  * deletePdaLabelList
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "deletePdaLabelList.do", method = RequestMethod.POST)
	public Map<String, Object> deletePdaLabelList(HttpServletRequest request) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		logger.debug("dhtmlxParamMapList >>>> " + dhtmlxParamMapList);
		
		resultMap.put("resultCNT", labelPrintService.deletePdaLabelList(dhtmlxParamMapList).get("result_cnt"));
		resultMap.put("total_cnt", dhtmlxParamMapList.size());
		
		return resultMap;
	}
	
	/**
	  * updatePdaLabelPrintState
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "updatePdaLabelPrintState.do", method = RequestMethod.POST)
	public Map<String, Object> updatePdaLabelPrintState(HttpServletRequest request) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		logger.debug("dhtmlxParamMapList >>>> " + dhtmlxParamMapList);
		resultMap.put("result", labelPrintService.updatePdaLabelPrintState(dhtmlxParamMapList).get("result_cnt"));
		return resultMap;
	}
	
}
