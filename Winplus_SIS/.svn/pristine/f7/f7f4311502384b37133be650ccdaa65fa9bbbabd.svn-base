package com.samyang.winplus.common.system.file.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
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

import com.microsoft.sqlserver.jdbc.SQLServerException;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.config.ServerVariable;
import com.samyang.winplus.common.system.file.service.FileService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.security.util.HaeSha512;
import com.samyang.winplus.common.system.util.DhtmlXGridExcel;
import com.samyang.winplus.common.system.util.ExceltoJava;


/** 
 * 공통 컨트롤러  
 * @since 2016.10.24
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.10.24	/ 김종훈 / 신규 생성
 *********************************************
 */
@RestController
@RequestMapping("/common/system/file")
public class FileController extends BaseController {
	static Logger logger = LoggerFactory.getLogger(FileController.class);
	
	@Autowired
	FileService fileService;
	
	@Autowired
	DhtmlXGridExcel dhtmlXGridExcel;
	
	/**
	  * xlsUploadParsing - 엑셀 일괄업로드- 기능
	  * @author 김종훈
	  * @param request
	  * @throws Exception 
	  */
	@RequestMapping(value="xlsUploadParsing.do", method=RequestMethod.POST)
	public Map<String, Object> xlsUploadParsing(MultipartRequest request,HttpServletRequest req) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		MultiValueMap<String, MultipartFile> fileMap = request.getMultiFileMap();
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();		

		String [] id = req.getParameterValues("id");
		String [] isHidden = req.getParameterValues("isHidden");
		String [] type = req.getParameterValues("type");
		String [] label = req.getParameterValues("label");
		List<String[]> headerList=new ArrayList<String[]>();
		headerList.add(id);
		headerList.add(isHidden);
		headerList.add(type);
		headerList.add(label);
		
		InputStream is;
		
		//1. 업로드갯수만큼 돌리기
		for(String name : fileMap.keySet()){
			//System.out.println("========================");
			List<MultipartFile> files = fileMap.get(name);
			MultipartFile file = files.get(0);

//			File realfile=commonUtil.convertFile(file,"temp");
			
			//System.out.println("파일명==> "+realfile.getName());
			
			//2. 해쉬맵 파싱
/*				for(int j=0;j<tmpMap.size()-1;j++){
				HashMap<String,Object> dtoMap=new HashMap<String,Object>();
				
				dtoMap.put("ACNT_NO",  (((CMSEA11N12Bean) tmpMap.get("DTO"+j)).getBody_acntno()));
				dtoMap.put("CNTRCT_NO",  (((CMSEA11N12Bean) tmpMap.get("DTO"+j)).getBody_mcode()));
				dtoMap.put("APPLY_GUBN",  (((CMSEA11N12Bean) tmpMap.get("DTO"+j)).getBody_applygubn()));
				dtoMap.put("CMS",  (((CMSEA11N12Bean) tmpMap.get("DTO"+j)).getCms100()));
				resultList.add(dtoMap);
			}*/
			
			//2. 엑셀 파싱
			String ext = "";
			is = file.getInputStream();
			
			//ext = ExceltoJava.getFileExt(realfile.getName());
			ext = ExceltoJava.getFileExt(file.getOriginalFilename());
			//System.out.println("[1]] " +ext);
			//1. vault -> Excelparse
			if(ext != null) {
				if("xls".equalsIgnoreCase(ext)) {
					resultList = ExceltoJava.loadExcelData(is,headerList);
				}else if("xlsx".equalsIgnoreCase(ext)) {
					resultList = ExceltoJava.loadExcelData2007(is,headerList);
				}
			}
			//System.out.println("[[3]] Finished");
			//System.out.println(resultList.toString());
			
			//====파일삭제
//			if(realfile.exists()){realfile.delete();}
		}
		
		resultMap.put("state", true);
		resultMap.put("name", "filename");
		resultMap.put("extra", resultList);
		
		return resultMap;
	}
	
	/**
	  * uploadTool - 다중파일 업로드
	  * @author 신기환
	  * @param request
	  * @throws Exception 
	  */
	@RequestMapping(value="uploadTool.do", method=RequestMethod.POST)
	public Map<String, Object> uploadTool(MultipartRequest request,HttpServletRequest req) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		MultiValueMap<String, MultipartFile> fileMap = request.getMultiFileMap();
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(req);
		String regId = empSessionDto.getEmp_no();
		String root = propertyManagement.getProperty("system.storage.file.rootpath");
		Map<String, Object> map = new HashMap<String, Object>();
		//업로드갯수만큼 돌리기
		for(String name : fileMap.keySet()){
		//	System.out.println("============/common/uploadTool.erp============");
			List<MultipartFile> files = fileMap.get(name);

			MultipartFile file = files.get(0);
//			String fileNm=file.getName();
		
			//1. 경로에 새 파일 생성 및 저장
			File realfile=commonUtil.convertFile(file,"upload");
			
			//2. 메타데이터 저장
			map.clear();
			String tmp=realfile.getAbsolutePath().replaceAll(realfile.getName(), "");
			tmp=tmp.replaceAll(root, "");
			map.put("PFILE_PATH", tmp.substring(0, tmp.length()-1));
			map.put("PFILE_NM", realfile.getName());
			map.put("PFILE_MG", realfile.length());
			map.put("PREAL_FILE_NM", file.getOriginalFilename());
			map.put("PREG_ID", regId);
		//	System.out.println(map.toString());

/*			System.out.println("파일위치= "+realfile.getAbsolutePath());
			System.out.println("변경된이름= "+realfile.getName());
			System.out.println("파일사이즈= "+realfile.length());
			System.out.println("실제파일명2= "+file.getOriginalFilename());*/

			//3. 메타데이터 인서트
			fileService.insertFileMetaData(map);
			
			//4.메타데이터 일련번호 가져오기
			String no = fileService.getFileMetaDataNo(map);
			map.put("ATCHMNFL_NO", no);
			resultList.add(map);
		}
		
		//4. 메타데이타 전송
		resultMap.put("state", true);
		resultMap.put("name", resultList);
		resultMap.put("extra", resultList);
		
		return resultMap;
	}

	/**
	  * downloadTool - 다중파일 다운로드
	  * @author 신기환
	  * @param request
	  * @throws Exception 
	  */
	@RequestMapping(value="downloadTool.sis", method=RequestMethod.POST)
	public void downloadTool(HttpServletRequest req, HttpServletResponse resp) throws SQLException,IOException, Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String root =propertyManagement.getProperty("system.storage.file.rootpath");
		String zipPath=root.substring(0,root.length()-1)+propertyManagement.getProperty("system.tempfile.zipPath");

		//1. 파라미터 받기
		String atchmnflNo=req.getParameter("ATCHMNFL_NO") == null ? "" : req.getParameter("ATCHMNFL_NO");
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(req);
		String regId = empSessionDto.getEmp_no();
		
		String decodeResult = URLDecoder.decode(atchmnflNo, "UTF-8");

		paramMap.put("PATCHMNFL_NO", decodeResult==null?"":decodeResult);
		paramMap.put("PREG_ID", regId==null?"":regId);
		paramMap.put("ZIP_PATH", zipPath);
		paramMap.put("ROOT", root);
		
		//System.out.println("[1] "+decodeResult);
		String zipFile ="";
		
		//2. Zip 파일 생성
		//단일파일 생성
		if(decodeResult.split(",").length<=1){
			zipFile = fileService.makeSingleFile(paramMap);	
		}
		//다중다운로드 zip파일 생성
		else{
			zipFile = fileService.makeZipFile(paramMap,root,"ELSE");	
		}
		
		
		//System.out.println("[2] "+zipFile);
		
		//3. 다운기능
		File tmpFile= new File(zipFile);
		long fileSize = tmpFile.length();	

		BufferedInputStream  bis = null;
	    BufferedOutputStream bos = null;
	    resp.reset();
	    //System.out.println("[3] "+fileSize);
	    //System.out.println("[3-1] "+tmpFile.getName());
	    
	    //다운로드 한글깨짐 처리
	    String oriFileName = getDisposition(tmpFile.getName(), getBrowser(req));

	    resp.setHeader("Content-Disposition", "attachment;filename=\""+oriFileName+"\";");
		resp.setHeader("Content-Type", "application/octet-stream; charset=UTF-8");
	    resp.setHeader("Content-Length",            "" + fileSize);
	    resp.setHeader("Content-Transfer-Encoding", "binary;");
	    resp.setHeader("Pragma",                    "no-cache;");
	    resp.setHeader("Expires",                   "-1;");
	    
	    bis = new BufferedInputStream( new FileInputStream(tmpFile) );
        byte buffer[] = new byte[4096];
        int len = 0;
        bos = new BufferedOutputStream( resp.getOutputStream() );
        
        len = bis.read(buffer);
        while(len > 0 ){
            bos.write(buffer,0,len);
            len = bis.read(buffer);
        }
        //System.out.println("[4] ");
        resp.flushBuffer();
        if (bis !=null){ bis.close();}
        if (bos !=null){ bos.close();}        
       // System.out.println("[5] ");
        
        //4. 폴더삭제
        String path=tmpFile.getAbsolutePath();
        String fm=tmpFile.getName();
        //System.out.println("=========>"+path);
        //System.out.println("=========>"+fm);
        
        if(decodeResult.split(",").length<=1){
        	path=path.replaceAll(fm, "");
        	commonUtil.deleteDirectory(new File(path.substring(0, path.length()-1)));
        }
        else{
        	commonUtil.deleteDirectory(new File(zipPath+"/"+fm.substring(0,fm.length()-4)));
        }
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
	 * getTempPassword - 임시비밀번호생성
	 * @author 유홍재
	 * @throws Exception 
	 */
	public static String[] getTempPassword() throws NoSuchAlgorithmException,Exception 
	{
		int index = 0;
		char[] charSet = new char[] 
		{
			'0','1','2','3','4','5','6','7','8','9'
			,'A','B','C','D','E','F','G','H','I','J','K','L','M'
			,'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'			
		};
		
		StringBuilder sb = new StringBuilder();
		Random r = new Random();
		for(int i = 0; i < 12; i++)
		{
			index = r.nextInt(35) + 1;
			sb.append(charSet[index]);
		}
		
		HaeSha512 haeSha512 = new HaeSha512();
		String password = sb.toString();
		// 평문을 sha512 단방향 암호화를 적용함.
		String encSp = haeSha512.haeEncrypt(password);
				
		String[] array = {password, encSp};
		
		return array;
	}
	
	@RequestMapping(value="downloadGridExcel.do", method=RequestMethod.POST)
	public void downloadGridExcel(HttpServletRequest request, HttpServletResponse response) throws IOException, Exception {
		XSSFWorkbook workbook = dhtmlXGridExcel.generateDhtmlXGridExcel(request);	
		String pattern = "yyyyMMddHHmmssSSS";
		String fileName = new SimpleDateFormat(pattern, Locale.KOREA).format(new Date()) + ".xlsx";

		/*
		String rootPath = propertyManagement.getProperty("system.storage.file.rootpath");
		String tempPath = propertyManagement.getProperty("system.tempfile.zipPath");
		tempPath = tempPath.replace("\\", "");
		
		
		 * String dirPath =  rootPath + tempPath;
		File dir = new File(dirPath);
		if(!dir.exists() && !dir.isDirectory()){
			dir.mkdirs();
		}
		
		String filePath =dirPath + "\\" + fileName;
		
		
		File file = new File(fileName);
		workbook.write(new FileOutputStream(file));
		
		fileSize =  file.length();
		long file.delete();
		*/
		fileName = request.getParameter("fileName");
		fileName = getDisposition(fileName, getBrowser(request)) + "_" + new SimpleDateFormat(pattern, Locale.KOREA).format(new Date()) + ".xlsx";
		response.setHeader("Content-Disposition", "attachment;filename=\""+fileName+"\";");
		response.setHeader("Content-Type", "application/octet-stream; charset=UTF-8");
		response.setHeader("Content-Length", "");
		response.setHeader("Content-Transfer-Encoding", "binary;");
		response.setHeader("Pragma", "no-cache;");
		response.setHeader("Expires", "-1;");
		workbook.write(response.getOutputStream());
		response.flushBuffer();
	}
	
	/**
	  * downloadURL - 경로 파일 다운로드
	  * @author 유홍재
	  * @param request
	  * @throws Exception 
	  */
	@RequestMapping(value="downloadURL.do", method=RequestMethod.POST)
	public void downloadURL(HttpServletRequest req, HttpServletResponse resp) throws SQLException,IOException, Exception {
//		Map<String, Object> paramMap = new HashMap<String, Object>();
//		String root =propertyManagement.getProperty("system.storage.file.rootpath");
//		String zipPath=root.substring(0,root.length()-1)+propertyManagement.getProperty("system.tempfile.zipPath");

		//System.out.println("[1] "+decodeResult);

		//3. 다운기능
		File tmpFile= new File("/WEB-INF/jsp/business/businessRegistTemplate.xlsx");
		long fileSize = tmpFile.length();	

		BufferedInputStream  bis = null;
	    BufferedOutputStream bos = null;
	    resp.reset();
	    //System.out.println("[3] "+fileSize);
	    //System.out.println("[3-1] "+tmpFile.getName());
	    
	    //다운로드 한글깨짐 처리
	    String oriFileName = getDisposition(tmpFile.getName(), getBrowser(req));

	    resp.setHeader("Content-Disposition", "attachment;filename=\""+oriFileName+"\";");
		resp.setHeader("Content-Type", "application/octet-stream; charset=UTF-8");
	    resp.setHeader("Content-Length",            "" + fileSize);
	    resp.setHeader("Content-Transfer-Encoding", "binary;");
	    resp.setHeader("Pragma",                    "no-cache;");
	    resp.setHeader("Expires",                   "-1;");
	    
	   bis = new BufferedInputStream( new FileInputStream(tmpFile) );
       byte buffer[] = new byte[4096];
       int len = 0;
       bos = new BufferedOutputStream( resp.getOutputStream() );
       
       len = bis.read(buffer);
    		   
       while(len > 0 ){
           bos.write(buffer,0,len);
           len = bis.read(buffer);
       }
       //System.out.println("[4] ");
       //resp.flushBuffer();
	   resp.getOutputStream().write(buffer);
       if (bis !=null){ bis.close();}
       if (bos !=null){ bos.close();}       
      // System.out.println("[5] ");
       
	}
	

	@Autowired
	ServerVariable serverVariable;
	
	/**
	 * @author 조승현
	 * @param request
	 * @param attachFiles
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 첨부파일 업로드
	 */
	@RequestMapping(value="uploadAttachFile.do", method=RequestMethod.POST)
	public Map<String, Object> uploadAttachFile(MultipartRequest request, @RequestParam Map<String, String> paramMap) throws IOException {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		Map<String, String> UPLOAD_ATTACH_FILE_SAVE_ROOT_DIRECTORY_LIST = serverVariable.getUploadAttachFileSaveRootDirectoryList();
		paramMap.put("DIRECTORY_VALUE", UPLOAD_ATTACH_FILE_SAVE_ROOT_DIRECTORY_LIST.get(paramMap.get("DIRECTORY_KEY")));
		
		MultiValueMap<String, MultipartFile> fileMap = request.getMultiFileMap();
		List<Map<String, Object>> attachFileList = fileService.uploadAttachFile(paramMap, fileMap);
		
		resultMap.put("state", true); 					//DHTMLX UPLOAD_SUCCESS 호출
		resultMap.put("name", "WINPLUS_SIS"); 			//DHTMLX 서버명
		resultMap.put("extra", attachFileList);			//DHTMLX 결과 리턴 사용
		
		return resultMap;
	}


	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws IOException
	 * @description 첨부파일 삭제 처리
	 */
	@ResponseBody
	@RequestMapping(value="deleteAttachFile.do", method=RequestMethod.POST)
	public Map<String, Object> deleteAttachFile(@RequestBody Map<String, String> paramMap) throws IOException {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		List<Map<String, Object>> attachFileList = fileService.deleteAttachFile(paramMap);
		resultMap.put("extra", attachFileList);	//DHTMLX 결과 리턴 사용
		
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param response
	 * @throws SQLServerException
	 * @throws SQLException
	 * @throws Exception
	 * @description 파일 다운로드 요청
	 */
	@RequestMapping(value = "requestFileDownload.do")
	public void requestFileDownload(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> paramMap) throws SQLServerException, SQLException, Exception{
		String totalPath = null;
		Map<String, Object> resultMap = fileService.getFileInfo(paramMap);
		String FILE_PATH = (String) resultMap.get("FILE_PATH");
		String FILE_ORG_NM = (String) resultMap.get("FILE_ORG_NM");
		String FILE_UID = (String) resultMap.get("FILE_UID");
		String FILE_TYPE = (String) resultMap.get("FILE_TYPE");
		
		totalPath = FILE_PATH + FILE_ORG_NM + "_" + FILE_UID + FILE_TYPE;
		
	    File file= new File(totalPath);
	    long fileSize = file.length();   
	
	    BufferedInputStream  bis = null;
	    BufferedOutputStream bos = null;
	    response.reset();
	    
	    //다운로드 한글깨짐 처리
	    String FILENAME_AFTER_ENCODING = getDisposition(FILE_ORG_NM + FILE_TYPE, getBrowser(request));
	    //logger.debug("REQEUST BROWSER : " + getBrowser(request)); 
	    //logger.debug("FILENAME : " + file.getName());
	    //logger.debug("FILENAME_AFTER_ENCODING : " + FILENAME_AFTER_ENCODING);

		response.setHeader("Content-Disposition", "attachment;filename=\""+FILENAME_AFTER_ENCODING+"\";");
		response.setHeader("Content-Type", "application/octet-stream; charset=UTF-8");
		response.setHeader("Content-Length",            "" + fileSize);
		response.setHeader("Content-Transfer-Encoding", "binary;");
		response.setHeader("Pragma",                    "no-cache;");
		response.setHeader("Expires",                   "-1;");
      
		bis = new BufferedInputStream(new FileInputStream(file));
		byte buffer[] = new byte[4096];
		int len = 0;
		bos = new BufferedOutputStream(response.getOutputStream());
		while((len = bis.read(buffer)) > 0 ){
			bos.write(buffer,0,len);
		}
		response.flushBuffer();
		if (bis !=null) bis.close();
		if (bos !=null) bos.close();
		
	}
	
	
	/**
	 * @author 조승현
	 * @param paramMapList
	 * @return  Map<String, Object>
	 * @throws IOException
	 * @description 첨부파일들 삭제
	 */
	@ResponseBody
	@RequestMapping(value="deleteAttachFileList.do", method=RequestMethod.POST)
	public Map<String, Object> deleteAttachFileList(@RequestBody List<Map<String, String>> paramMapList) throws IOException {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		List<Map<String, Object>> attachFileList = fileService.deleteAttachFileList(paramMapList);
		resultMap.put("gridDataList", attachFileList);	//DHTMLX 결과 리턴 사용
		
		return resultMap;
	}
	

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws IOException
	 * @description 첨부파일 가져오기
	 */
	@ResponseBody
	@RequestMapping(value="getAttachFileList.do", method=RequestMethod.POST)
	public Map<String, Object> getAttachFileList(@RequestBody Map<String, String> paramMap) throws IOException {
		Map<String, Object> resultMap = new HashMap<String,Object>();

		List<Map<String, Object>> attachFileList = fileService.getAttachFileList(paramMap);
		resultMap.put("gridDataList", attachFileList);	//DHTMLX 결과 리턴 사용
		
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param paramMapList
	 * @return Map<String, Object>
	 * @throws IOException
	 * @description 첨부파일들 업데이트
	 */
	@ResponseBody
	@RequestMapping(value="updateAttachFileList.do", method=RequestMethod.POST)
	public Map<String, Object> updateAttachFileList(@RequestBody List<Map<String, String>> paramMapList) throws IOException {
		Map<String, Object> resultMap = new HashMap<String,Object>();

		List<Map<String, Object>> attachFileList = fileService.updateAttachFileList(paramMapList);
		resultMap.put("gridDataList", attachFileList);	//DHTMLX 결과 리턴 사용
		
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws IOException
	 * @description 파일 그룹 코드 생성
	 */
	@ResponseBody
	@RequestMapping(value="getFileGrupNo.do", method=RequestMethod.POST)
	public Map<String, Object> getFileGrupNo() throws IOException {
		Map<String, Object> resultMap = new HashMap<String,Object>();

		Integer FILE_GRUP_NO = fileService.getFileGrupNo();
		resultMap.put("FILE_GRUP_NO", FILE_GRUP_NO);
		
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param attachFiles
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 첨부파일 업로드 dhtmlx vault 사용안함
	 */
	@RequestMapping(value="uploadAttachFile2.do", method=RequestMethod.POST)
	public Map<String, Object> uploadAttachFile2(@RequestParam Map<String, String> paramMap, @RequestParam("FILE") MultipartFile file) throws IOException {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		Map<String, String> UPLOAD_ATTACH_FILE_SAVE_ROOT_DIRECTORY_LIST = serverVariable.getUploadAttachFileSaveRootDirectoryList();
		paramMap.put("DIRECTORY_VALUE", UPLOAD_ATTACH_FILE_SAVE_ROOT_DIRECTORY_LIST.get(paramMap.get("DIRECTORY_KEY")));
		
		fileService.uploadAttachFile2(paramMap, file);
		
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws IOException
	 * @description 상품이미지 첨부파일 가져오기
	 */
	@ResponseBody
	@RequestMapping(value="getAttachGoodsImageFileList.do", method=RequestMethod.POST)
	public Map<String, Object> getAttachGoodsImageFileList(@RequestBody Map<String, String> paramMap) throws IOException {
		Map<String, Object> resultMap = new HashMap<String,Object>();

		List<Map<String, Object>> attachFileList = fileService.getAttachGoodsImageFileList(paramMap);
		resultMap.put("gridDataList", attachFileList);
		
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws IOException
	 * @description 상품이미지 첨부파일 삭제하기
	 */
	@ResponseBody
	@RequestMapping(value="deleteAttachGoodsImageFile.do", method=RequestMethod.POST)
	public Map<String, Object> deleteAttachGoodsImageFile(@RequestBody Map<String, String> paramMap) throws IOException {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		
		fileService.deleteAttachGoodsImageFile(paramMap);
		
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param listMap
	 * @return Map<String, Object>
	 * @throws IOException
	 * @description 거래처 계약서 파일 리스트 삭제
	 */
	@ResponseBody
	@RequestMapping(value="deleteAttachContractFileList.do", method=RequestMethod.POST)
	public Map<String, Object> deleteAttachContractFileList(@RequestBody List<Map<String,String>> paramMapList) throws IOException {
		Map<String, Object> resultMap = new HashMap<String,Object>();

		List<Map<String,Object>> gridDataList = fileService.deleteAttachContractFileList(paramMapList);
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
}
