package com.samyang.winplus.common.system.file.service;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipOutputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;

import com.samyang.winplus.common.system.config.EnvironmentInitializer;
import com.samyang.winplus.common.system.file.dao.FileDao;

@Service("fileService")
public class FileServiceImpl implements FileService {
	
	@Autowired
	FileDao fileDao;
	
	static Logger logger = LoggerFactory.getLogger(FileServiceImpl.class);

	/**
	  * 메타데이터 인서트
	  * @author 신기환
	  * @param paramMap
	  * @return Integer
	  */
	@Override
	public int insertFileMetaData(Map<String, Object> paramMap) throws SQLException, Exception {
		return  fileDao.insertFileMetaData(paramMap);
	}
	
	/**
	  * 메타데이터 가져오기
	  * @author 신기환
	  * @param paramMap
	  * @return String
	  */
	@Override
	public List<Map<String,Object>> getFileMetaData(Map<String, Object> paramMap) throws SQLException, Exception {
		return fileDao.getFileMetaData(paramMap);
	}

	/**
	  * 메타데이터 일련번호 가져오기
	  * @author 신기환
	  * @param paramMap
	  * @return String
	  */
	@Override
	public String getFileMetaDataNo(Map<String, Object> paramMap) throws SQLException, Exception {
		return fileDao.getFileMetaDataNo(paramMap);
	}

	/**
	  * 메타데이터 정보 가져오기 & zip파일 생성
	  * @author 신기환
	  * @param paramMap
	  * @param [ACUONE - 애큐온전문용 zip] [ETC - 일반 temp성 zip] 
	  * @return String
	  */
	@Override
	public String makeZipFile(Map<String, Object> paramMap,String root, String gubn) throws SQLException, Exception {
		//1. 파일 메타데이터 가져오기
		List<Map<String, Object>> resultMap=fileDao.getFileMetaData(paramMap);
		FileInputStream fis = null;
		FileOutputStream fos = null; 

		//2. zip파일 이름 생성
		SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyyMMddhhmmss", Locale.KOREA);
		String stDate = formatter1.format(new Date());
		//System.out.println("makeZipFile!");
		//System.out.println(root);
		//3. 파일리스트 생성
		List<File> filelist = new ArrayList<File>(); 
		for(int i=0;i<resultMap.size();i++){
//			System.out.println(root.substring(0,root.length()-1)+resultMap.get(i).get("FILE_PATH"));
			File f = getNewFile(root.substring(0,root.length()-1)+resultMap.get(i).get("FILE_PATH")+"/"+resultMap.get(i).get("FILE_NM")); 
			File fe= getNewFile(paramMap.get("ZIP_PATH")+stDate+"_"+paramMap.get("PREG_ID"));
			    
		    //해당 디렉토리의 존재여부를 확인
		      if(!fe.exists()){
		    	  //System.out.println("==================================");
		    	  //System.out.println(fe.getPath());
		    	  fe.mkdirs();
		      }
		      
			//파일복사
			fis = getNewFileInputStream(f);           // 원본파일
			//fos = new FileOutputStream(paramMap.get("ZIP_PATH").toString()+stDate+"_"+paramMap.get("PREG_ID")+"/"+resultMap.get(i).get("REAL_FILE_NM"));   // 복사위치
			fos = getNewFileOutputStream(paramMap.get("ZIP_PATH").toString()+stDate+"_"+paramMap.get("PREG_ID")+"/"+resultMap.get(i).get("DWLD_FILE_NM"));   // 복사위치
			
			byte[] buffer = getNewByte(1024);
			int readcount = 0;
			
			readcount=fis.read(buffer);
			while(readcount != -1) {
				fos.write(buffer, 0, readcount);    // 파일 복사 
				readcount=fis.read(buffer);
			}
			
			fis.close();
			fos.close();
			
			//2-2 복사된파일 가져오기
			//File t = new File(paramMap.get("ZIP_PATH")+stDate+"_"+paramMap.get("PREG_ID")+"/"+resultMap.get(i).get("REAL_FILE_NM"));
			File t = getNewFile(paramMap.get("ZIP_PATH")+stDate+"_"+paramMap.get("PREG_ID")+"/"+resultMap.get(i).get("DWLD_FILE_NM"));
		   
			
			//2-3 파일리스트 추가
			filelist.add(t);
		}
	
		//4. zip 파일 생성
		// 파일을 읽기위한 버퍼
	      byte[] buf = new byte[1024];
	
	      // 압축파일명
	      String zipName ="";
	      if("ACUONE".equals(gubn)){
	    	  //zipName=paramMap.get("ZIP_PATH")+stDate+"_"+paramMap.get("PREG_ID")+"/GDC_"+stDate.substring(0,8)+".zip";
	    	  zipName=paramMap.get("ZIP_PATH")+stDate+"_"+paramMap.get("PREG_ID")+"/GDC_"+stDate+".zip";
	      }
	      else{
	    	  zipName=paramMap.get("ZIP_PATH")+stDate+"_"+paramMap.get("PREG_ID")+"/"+stDate+"_"+paramMap.get("PREG_ID")+".zip";
	      }

	      File ff = new File(zipName);
	      ff.createNewFile();
	      
	      ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipName));
	      //System.out.println("[0] ");
	      
	      //중복파일명 체크된 리스트 생성
/*	      List<String> fileNmList = new ArrayList<String>();
	      String tmpStr="";
	      String patternSp = "(.*)[\\[][\\p{Digit}]{17}[\\]](.*)";
	      String tmp="";
	      String tmpNm="";
	      String tmpNmKey="";
	      for(int i=0;i<filelist.size();i++){
	    	   tmp=filelist.get(i).getName(); //확장자가진 풀네임
	    	   //확장자 가진 풀네임이 정규식에 만족한다면 이름 리플레이스
	    	   if(Pattern.matches(patternSp, tmp)){
	    		   tmpNm=tmp.substring(0,tmp.lastIndexOf(".")); //파일명
		    	   tmpNmKey=tmpNm.substring(tmpNm.length()-19); //파일키문자열
		    	   fileNmList.add(tmpNm.substring(0, tmpNm.length()-19)+tmp.substring(tmp.lastIndexOf(".")));
	    	   }
	    	   //아니면 그냥 이름
	    	   else{
	    		   fileNmList.add(tmp);
	    	   }
	    	  tmp="";
	    	  tmpNm="";
	    	  tmpNmKey="";
	    	  
	      }
	      
	      //중복파일에 대해 파일명 변경
	      fileNmList=modifyDuplicatedNm(fileNmList);
*/
	      // 파일 압축
	      for (int i=0; i<filelist.size(); i++) {
	    	  
	          FileInputStream in = getNewFileInputStream(filelist.get(i).getAbsolutePath());
	          
	          // 압축 항목추가
	          //파일 중복이 있을때 예외처리
	          try{out.putNextEntry(getNewZipEntry(filelist.get(i).getName()));}
	          catch(ZipException e){
	        	  logger.error(e.toString());
	          }
	
	          // 바이트 전송
	          int len;
	          len = in.read(buf);
	          while (len > 0) {
	              out.write(buf, 0, len);
	              len = in.read(buf);
	          }
	  
	          out.closeEntry();
	          in.close();
	      }
	  
	      // 압축파일 작성
	      out.close();
	      //System.out.println("[1] "+zipName);
		return zipName;
	}

	public ZipEntry getNewZipEntry(String name){
		return new ZipEntry(name);
	}
	
	public File getNewFile(String name){
		return new File(name);
	}
	
	public FileInputStream getNewFileInputStream(File file) throws Exception{
		return new FileInputStream(file);
	}
	
	public FileInputStream getNewFileInputStream(String name) throws Exception{
		return new FileInputStream(name);
	}
	
	public FileOutputStream getNewFileOutputStream(String name) throws Exception{
		return new FileOutputStream(name);
	}
	
	public byte[] getNewByte(int num){
		return new byte[num];
	}
	
	
	
	/**
	  * 메타데이터 정보 가져오기 & 단일파일 생성
	  * @author 신기환
	  * @param paramMap
	  * @return String
	  */
	@Override
	public String makeSingleFile(Map<String, Object> paramMap) throws SQLException, Exception {
		//1. 파일 메타데이터 가져오기
		List<Map<String, Object>> resultMap=fileDao.getFileMetaData(paramMap);
		FileInputStream fis = null;
		FileOutputStream fos = null; 
		String root = paramMap.get("ROOT").toString();
		//2. 임시폴더 이름 생성
		SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyyMMddhhmmss", Locale.KOREA);
		String stDate = formatter1.format(new Date());
		//3. 파일리스트 생성
		List<File> filelist = new ArrayList<File>(); 
		for(int i=0;i<resultMap.size();i++){
			//System.out.println(resultMap.get(i).toString());
			File f = getNewFile(root.substring(0,root.length()-1)+resultMap.get(i).get("FILE_PATH")+"/"+resultMap.get(i).get("FILE_NM"));
			File fe= getNewFile(paramMap.get("ZIP_PATH")+stDate+"_"+paramMap.get("PREG_ID"));

		    //해당 디렉토리의 존재여부를 확인
		      if(!fe.exists()){
		    	  //System.out.println("==================================");
		    	  //System.out.println(fe.getPath());
		    	  fe.mkdirs();
		      }
		      
			//파일복사
			fis = getNewFileInputStream(f);           // 원본파일
			//fos = new FileOutputStream(paramMap.get("ZIP_PATH").toString()+stDate+"_"+paramMap.get("PREG_ID")+"/"+resultMap.get(i).get("REAL_FILE_NM"));   // 복사위치
			fos = getNewFileOutputStream(paramMap.get("ZIP_PATH").toString()+stDate+"_"+paramMap.get("PREG_ID")+"/"+resultMap.get(i).get("DWLD_FILE_NM"));   // 복사위치
			
			byte[] buffer = getNewByte(1024);
			int readcount = 0;
			readcount=fis.read(buffer);
			while(readcount != -1) {
				fos.write(buffer, 0, readcount);    // 파일 복사 
				readcount=fis.read(buffer);
			}
			
			fis.close();
			fos.close();
			
			//2-2 복사된파일 가져오기
			//File t = new File(paramMap.get("ZIP_PATH")+stDate+"_"+paramMap.get("PREG_ID")+"/"+resultMap.get(i).get("REAL_FILE_NM"));
			File t = getNewFile(paramMap.get("ZIP_PATH")+stDate+"_"+paramMap.get("PREG_ID")+"/"+resultMap.get(i).get("DWLD_FILE_NM"));

			//2-3 파일리스트 추가
			filelist.add(t);
		}
	

	return filelist.get(0).getAbsolutePath();
	}

	/**
	  * 메타데이터 인서트
	  * @author 신기환
	  * @param paramMap
	  * @return Integer
	  */
	@Override
	public int insertFileMetaData(List<HashMap<String, Object>> list)
			throws SQLException, Exception {
		int result=0;
		for(int i=0;i<list.size();i++){
			result+=fileDao.insertFileMetaData(list.get(i));
		}
		return result;
	}
	
	/**
	  * modifyDuplicatedNm - 중복리스트 를 중복 안되는 요소로 재가공
	  * @author 신기환
	  * @param [List<String>] 리스트	
	  * @throws IOException 
	  * @return [List<String>] 리스트 
	  */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List<String> modifyDuplicatedNm(List<String> fileNmList){    
		List<String> resultList = new ArrayList<String>();
		
		// 데이터를 담을 벡터
		  Vector v = new Vector();
		  // 중복 제거 할 벡터
		  Vector d = new Vector();
		 
		  String tmpNm="";
		  String tmpExt="";
		  // 1. 데이터를 차곡차곡 생성하자.
		  for(int i=0;i<fileNmList.size();i++){
			  //System.out.println(fileNmList.get(i));
			  v.addElement(fileNmList.get(i));
		  }

		  // 3. 데이터가 들어 있는 놈의 사이즈 만큼 뱅뱅 돈다.
		  for (int j = 0 ; j < v.size() ; j++ ) {
		   
		   String vTmp = (String)v.elementAt(j);  // 현재 row의 값을 담아뒀다가
		   Boolean existFlag = false;     // 요놈은 기존에 값이 있는가 없는가 체크하는 깃발 
		   
		   // 4. 최초에는 d 벡터의 값이 없으므로 v벡터의 첫번째 값을 무조건 넣어 준다.
		   if ( d.isEmpty() ) {
		    String[] tmpS = {vTmp,"0"};
		    d.addElement(tmpS);
		   }   
		   
		   // 5. d 벡터에 있는 데이터 수 만큼 돈다. d.size()는 데이터가 들어 갈 수록 늘어 나겠지?
		   for (int z = 0 ; z < d.size() ; z++ ) {
		    String[][] zz = getNewString(d.size(),2);
		    d.copyInto(zz);
		    
		    String[] dTmp = (String[])d.elementAt(z);
		    
		    // 6. d 벡터에 현재 v 벡터의 값이 있으면 진짜 플레그로 변신
		    if ( dTmp[0].equals(vTmp) ) {
		     existFlag = true;
		     // 몇개 들어 있는지 카운트 한다
		     dTmp[1] = Integer.toString(Integer.parseInt(dTmp[1]) + 1);
		    }
		   }
		   
		   // 7. 현재 v벡터의 값이 없다면 d 벡터에 넣는다.
		   if ( !existFlag ) {
		    String[] tmpS = {vTmp,"1"};
		    d.addElement(tmpS);
		   } 
		   
		  }
		  
		  // 8. 결과를 보자.
		  //System.out.println("");
		  //System.out.println("Distinct Vector V : " + d.size() + "종류 (TOTAL " + v.size() + ")");
		  
		  String[][] tt = new String[d.size()][2];
		  d.copyInto(tt);
		  
		  for (int k = 0 ; k < d.size() ; k++ ) {
		   String[] oD = (String[])d.elementAt(k);
		   //System.out.println(o_d[0] + "는 " + o_d[1] + "개가 있다");
		   
		   for(int x=0;x<Integer.parseInt(oD[1]);x++){
			   String tmp = x==0?"":"_"+x;
			   tmpNm=oD[0].substring(0,oD[0].lastIndexOf( "." ));
			   tmpExt=oD[0].substring(oD[0].lastIndexOf( "." )+1);
			   resultList.add(tmpNm+tmp+"."+tmpExt);
				  
		   }
		  }
		  
		  /*for(String data:resultList){
			  System.out.println(data);
			  
		  }*/
	    return resultList;
	}
	
	public String[][] getNewString(int num1, int num2){
		return new String[num1][num2];
	}

	@Override
	public List<Map<String, Object>> uploadAttachFile(Map<String, String> paramMap, MultiValueMap<String, MultipartFile> fileMap) {
		String DIRECTORY_KEY = paramMap.get("DIRECTORY_KEY");			//.yml 에 파일에 선언한 키값
		String saveRootDirectory = paramMap.get("DIRECTORY_VALUE");		//.yml 에 파일에 선언한 벨류값
		String FILE_GRUP_NO = paramMap.get("FILE_GRUP_NO");
		String FILE_REG_TYPE = paramMap.get("FILE_REG_TYPE");
		
		List<Map<String, Object>> boardAttachFilesInfo = null;
		
		for(String fileName : fileMap.keySet()) {
			
			//logger.debug("업로드 위치 키 : " + DIRECTORY_KEY);
			//logger.debug("업로드 위치 : " + saveRootDirectory);
			//logger.debug("업로드 첨부 파일명 : " + fileName);
			
			MultipartFile attachFile = fileMap.get(fileName).get(0);
			
			//원본 파일명
			String orignalFileName = attachFile.getOriginalFilename();
			//logger.debug("업로드 원본 파일명 : " + orignalFileName);
			
			//확장자명
			String exName = attachFile.getOriginalFilename().substring(attachFile.getOriginalFilename().lastIndexOf("."));
			
			//확장자명을 제거한 파일명
			int idx = orignalFileName.lastIndexOf(".");
			String originalOnlyFileName = orignalFileName.substring(0, idx);
			
			
//			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_hh_mm_ss");
//			Date date = new Date();
//			dateFormat.format(date).toString();
			String dateString = fileDao.getUploadTime();
			String year = dateString.substring(0,4);
			String month = dateString.substring(4,6);
			String day = dateString.substring(6,8);
			
			//로컬,개발,리얼 구분 저장용도
			String serverType = EnvironmentInitializer.getServerType();
			
			String finalSaveDirectory = saveRootDirectory + "\\" + serverType + "\\" + year + "\\" + month + "\\" + day + "\\";
			String finalOnlyFileName = originalOnlyFileName + "_" + dateString;
			String finalFilePath = finalSaveDirectory + finalOnlyFileName + exName;
			
			//logger.debug("업로드 최종 저장 위치 : " + finalSaveDirectory);
			//logger.debug("업로드 최종 파일명 : " + finalOnlyFileName);
			//logger.debug("업로드 최종 패스 : " + finalFilePath);
			
			paramMap.put("FILE_GRUP_NO", FILE_GRUP_NO);
			paramMap.put("FILE_REG_TYPE", FILE_REG_TYPE);
			paramMap.put("FILE_ORG_NM", originalOnlyFileName);
			paramMap.put("FILE_NM", finalOnlyFileName);
			paramMap.put("FILE_PATH", finalSaveDirectory);
			paramMap.put("FILE_UID", dateString);
			paramMap.put("FILE_TYPE", exName);
			
			OutputStream out = null;
			try {
				byte[] fileData = attachFile.getBytes();
				File file = new File(finalSaveDirectory);
				
				if(!file.exists()) {
					file.mkdirs();
				}
				
				paramMap.put("FILE_SIZE", String.valueOf(fileData.length));
				out = new FileOutputStream(finalFilePath);
				BufferedOutputStream bout = new BufferedOutputStream(out);
				bout.write(fileData);
				
				if(out != null) {
					out.close();
				}
				
				fileDao.uploadAttachFile(paramMap);
				
				boardAttachFilesInfo = getAttachFileList(paramMap);
				
			} catch (FileNotFoundException e) {
				logger.error(e.toString());
			} catch (IOException e) {
				logger.error(e.toString());
			}
		}
		
		return boardAttachFilesInfo;
	}
	
	@Override
	public List<Map<String, Object>> getAttachFileList(Map<String, String> paramMap) {
		return fileDao.getAttachFileList(paramMap);
	}

	@Override
	public List<Map<String, Object>> deleteAttachFile(Map<String, String> paramMap) {
		fileDao.deleteAttachFile(paramMap);
		return fileDao.getAttachFileList(paramMap);
	}

	@Override
	public List<Map<String, Object>> deleteAttachFileList(List<Map<String, String>> paramMapList) {
		for(Map<String, String> paramMap: paramMapList) {
			fileDao.deleteAttachFile(paramMap);
		}
		return fileDao.getAttachFileList(paramMapList.get(0));
	}

	@Override
	public List<Map<String, Object>> updateAttachFileList(List<Map<String, String>> paramMapList) {
		for(Map<String, String> paramMap: paramMapList) {
			fileDao.updateAttachFile(paramMap);
		}
		return fileDao.getAttachFileList(paramMapList.get(0));
	}
	
	@Override
	public String getUploadTime(){
		return fileDao.getUploadTime();
	}
	
	@Override
	public Integer getFileGrupNo() {
		return fileDao.getFileGrupNo();
	}

	@Override
	public Map<String, Object> getFileInfo(Map<String, String> paramMap) {
		return fileDao.getFileInfo(paramMap);
	}

	@Override
	public void uploadAttachFile2(Map<String, String> paramMap, MultipartFile attachFile) {
		String DIRECTORY_KEY = paramMap.get("DIRECTORY_KEY");			//.yml 에 파일에 선언한 키값
		String saveRootDirectory = paramMap.get("DIRECTORY_VALUE");		//.yml 에 파일에 선언한 벨류값
		String FILE_GRUP_NO = paramMap.get("FILE_GRUP_NO");
		String FILE_REG_TYPE = paramMap.get("FILE_REG_TYPE");
		String FILE_NAME = paramMap.get("FILE_NAME");
		
			
		//logger.debug("업로드 위치 키 : " + DIRECTORY_KEY);
		//logger.debug("업로드 위치 : " + saveRootDirectory);
		//logger.debug("업로드 첨부 파일명 : " + attachFile.getName());
		
		//원본 파일명
		String orignalFileName = attachFile.getOriginalFilename();
		//logger.debug("업로드 원본 파일명 : " + orignalFileName);
		
		//확장자명
		String exName = attachFile.getOriginalFilename().substring(attachFile.getOriginalFilename().lastIndexOf("."));
		
		//확장자명을 제거한 파일명
		int idx = orignalFileName.lastIndexOf(".");
		String originalOnlyFileName = orignalFileName.substring(0, idx);
		
		if(FILE_NAME != null) {
			originalOnlyFileName = FILE_NAME;
		}
		
		
//			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_hh_mm_ss");
//			Date date = new Date();
//			dateFormat.format(date).toString();
		String dateString = fileDao.getUploadTime();
		String year = dateString.substring(0,4);
		String month = dateString.substring(4,6);
		String day = dateString.substring(6,8);
		
		//로컬,개발,리얼 구분 저장용도
		String serverType = EnvironmentInitializer.getServerType();
		
		String finalSaveDirectory = saveRootDirectory + "\\" + serverType + "\\" + year + "\\" + month + "\\" + day + "\\";
		String finalOnlyFileName = originalOnlyFileName + "_" + dateString;
		String finalFilePath = finalSaveDirectory + finalOnlyFileName + exName;
		
		//logger.debug("업로드 최종 저장 위치 : " + finalSaveDirectory);
		//logger.debug("업로드 최종 파일명 : " + finalOnlyFileName);
		//logger.debug("업로드 최종 패스 : " + finalFilePath);
		
		paramMap.put("FILE_GRUP_NO", FILE_GRUP_NO);
		paramMap.put("FILE_REG_TYPE", FILE_REG_TYPE);
		paramMap.put("FILE_ORG_NM", originalOnlyFileName);
		paramMap.put("FILE_NM", finalOnlyFileName);
		paramMap.put("FILE_PATH", finalSaveDirectory);
		paramMap.put("FILE_UID", dateString);
		paramMap.put("FILE_TYPE", exName);
		
		OutputStream out = null;
		try {
			byte[] fileData = attachFile.getBytes();
			File file = new File(finalSaveDirectory);
			
			if(!file.exists()) {
				file.mkdirs();
			}
			
			paramMap.put("FILE_SIZE", String.valueOf(fileData.length));
			out = new FileOutputStream(finalFilePath);
			BufferedOutputStream bout = new BufferedOutputStream(out);
			bout.write(fileData);
			
			if(out != null) {
				out.close();
			}
			
			fileDao.uploadAttachFile(paramMap);
			
		} catch (FileNotFoundException e) {
			logger.error(e.toString());
		} catch (IOException e) {
			logger.error(e.toString());
		}
	}

	@Override
	public List<Map<String, Object>> getAttachGoodsImageFileList(Map<String, String> paramMap) {
		return fileDao.getAttachGoodsImageFileList(paramMap);
	}

	@Override
	public void deleteAttachGoodsImageFile(Map<String, String> paramMap) {
		fileDao.deleteAttachGoodsImageFile(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> deleteAttachContractFileList(List<Map<String, String>> paramMapList) {
		for(Map<String,String> paramMap : paramMapList) {
			fileDao.deleteAttachContractFile(paramMap);
		}
		return fileDao.getAttachFileList(paramMapList.get(0));
	}
}
