package com.samyang.winplus.common.system.util;

import java.io.IOException;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class ExceltoJava {
	static Logger logger = LoggerFactory.getLogger(ExceltoJava.class);

	@SuppressWarnings({ "unused", "deprecation" })
	public static String getCellValue(HSSFCell cell) {
		DateFormat	 dFormat = new SimpleDateFormat("yyyy-MM-dd",Locale.KOREA);
	    DecimalFormat df = new DecimalFormat("0");	//소수점 3자리까지 업로드 2013-07-16
	    DecimalFormat dfAdd = new DecimalFormat();
	    
	    String cellValue = "";
		if(cell!=null){
	        switch(cell.getCellType()){ //cell 타입에 따른 데이타 저장
	            case HSSFCell.CELL_TYPE_FORMULA:
	            	cellValue = cell.getCellFormula();
	                break;
	            case HSSFCell.CELL_TYPE_NUMERIC:
	          	  if(HSSFDateUtil.isCellDateFormatted(cell)) {
	          		cellValue = dFormat.format(cell.getDateCellValue());
	          	  } else {
	          		cellValue = dfAdd.format(cell.getNumericCellValue()).replaceAll(",", "");
//	          		cellValue = cell.getNumericCellValue()+"";
	          	  }
	                break;
	            case HSSFCell.CELL_TYPE_STRING:
	            	cellValue = cell.getStringCellValue();
	                break;
	            case HSSFCell.CELL_TYPE_BLANK:
	            	cellValue = "";
	                break;
	            case HSSFCell.CELL_TYPE_ERROR:
	            	cellValue = String.valueOf(cell.getErrorCellValue());
	                break;
	            default:
	        }                        
	    }
		return cellValue;
	}

	@SuppressWarnings({ "unused", "deprecation" })
	public static String getCellValue2007(XSSFCell cell) {
		DateFormat	 dFormat = new SimpleDateFormat("yyyy-MM-dd",Locale.KOREA);
	    DecimalFormat df = new DecimalFormat("0.0000");	//소수점 3자리까지 업로드 2013-07-16
	    DecimalFormat dfAdd = new DecimalFormat();
	    
	    String cellValue = "";
		if(cell != null){
	        switch(cell.getCellType()){ //cell 타입에 따른 데이타 저장
	            case XSSFCell.CELL_TYPE_FORMULA:
	            	cellValue = cell.getCellFormula();
	                break;
	            case XSSFCell.CELL_TYPE_NUMERIC:
	          	  if(HSSFDateUtil.isCellDateFormatted(cell)) {
	          		cellValue = dFormat.format(cell.getDateCellValue());
	          	  } else {
	          		cellValue = dfAdd.format(cell.getNumericCellValue()).replaceAll(",", "");
//	          		cellValue = cell.getNumericCellValue()+"";
//	          		//logger.debug("CELL_TYPE_NUMERIC cellValue : "+cellValue);
	          	  }
	                break;
	            case XSSFCell.CELL_TYPE_STRING:
	            	cellValue = cell.getStringCellValue();
	                break;
	            case XSSFCell.CELL_TYPE_BLANK:
	            	cellValue = "";
	                break;
	            case XSSFCell.CELL_TYPE_ERROR:
	            	cellValue = String.valueOf(cell.getErrorCellValue());
	                break;
	            default:
	        }                        
	    }
		return cellValue;
	}
	
	public static String getFileExt(String fileName) {
		return getFileExt(fileName, false);
	}
	
    private static String getFileExt(String fileName, boolean bool) {
		if (fileName == null || "".equals(fileName.trim())){
			return "";
		}
			

		int idx = fileName.lastIndexOf(".");
		if (idx<0) {
			return "";
		}

		String ext = "";
		if(!bool) {
			ext = fileName.substring(idx + 1);
		} else {
			ext = fileName.substring(idx);
		}

		return ext;
	}
    
  		/**
  		 * 엑셀 파일 xls 인 경우
  		 * @param is
  		 * @param headerList 
  		 * @return 
  		 * @throws IOException 
  		 */
  		@SuppressWarnings({ "unused", "resource" })
		public static List<Map<String, Object>> loadExcelData(InputStream is, List<String[]> headerList) throws IOException {
  			//logger.debug("loadExcelData Start !!!");
  			POIFSFileSystem fs = new POIFSFileSystem(is);
  	        HSSFWorkbook wb = new HSSFWorkbook(fs);
  	        HSSFRow row= null;
  	        
  	        List<Map<String, Object>> resList = new ArrayList<Map<String, Object>>();
  	        List<String[]> list = headerList;
  	        String[] arrId=list.get(0);
  	        String[] arrIsHidden=list.get(1);
  	      	String[] arrType=list.get(2);
  	    	String[] arrLabel=list.get(3);
  	        
  	        HSSFSheet sheet = wb.getSheetAt(0); //시트 가져오기
  	        int rows = sheet.getPhysicalNumberOfRows(); //행 갯수 가져오기
  	        int noOfColumns = sheet.getRow(0).getLastCellNum(); //열 갯수 가져오기
  	        List<Map<String,Object>> imsiList = new ArrayList<Map<String,Object>>();
  	        List<Map<String,Object>> typeList = new ArrayList<Map<String,Object>>();
  	        
  	        /*** value HashMapList 저장 */
  	        for(int j=0; j<rows; j++){	//row 루프
  	        	row = sheet.getRow(j); //row 가져오기
  	        	//System.out.println("row.getLastCellNum() = "+ row.getLastCellNum()+" row.getRowNum() = "+ row.getRowNum()+" rows ="+rows + " j = "+j);
  	        	if(row != null){
  	        		Map<String, Object> map = getNewMap();
  	        		//데이터가 존재하는 마지막셀인지 확인 => 데이터가 없는 셀이면 break
  	        		if(ExceltoJava.getCellValue(row.getCell(0))==null||ExceltoJava.getCellValue(row.getCell(0)).equals("")){
  	        			boolean justify=true;
  	        			for(int x=0;x<noOfColumns;x++){
  	        				if(ExceltoJava.getCellValue(row.getCell(x))!=null&&!ExceltoJava.getCellValue(row.getCell(x)).equals("")){
  	        					justify=false;
  	        				}
  	        			}
  	        			if(justify){
  	        				break;
  	        			}
  	        		}
  	        		for(int x=0;x<noOfColumns;x++){
  	        			String imsicolumn=ExceltoJava.getCellValue(row.getCell(x))==null?"":ExceltoJava.getCellValue(row.getCell(x));
  	        			//헤더인경우
        				if(j==0){
        					//System.out.println("[[HEADER - imsicolumn]] " +imsicolumn);
        					//헤더의 경우 줄바꿈 제거
      	        			imsicolumn = imsicolumn.replace("\n", "");        					
        					for(int k=0;k<arrLabel.length;k++){
        						//System.out.println(arrLabel[k]);
            					//엑셀레이블과 동일한 헤더가 있다면
            					if(arrLabel[k].equals(imsicolumn)){
            						Map<String,Object> tmpList = getNewMap();
            						Map<String,Object> typeMap = getNewMap();
            						tmpList.put(x+"",arrId[k]);
            						typeMap.put(x+"",arrType[k]);
            						imsiList.add(tmpList);
            						typeList.add(typeMap);
            					}
            					else{
            						continue;
            					}
            				}
        				}
        				//컬럼인경우
        				else{
        					//System.out.println("[[BODY - imsicolumn]] " +imsicolumn);
        					for(int l=0;l<imsiList.size();l++){
        					/*	System.out.println("======");
        						System.out.println(imsiList.get(l));
        						System.out.println(typeList.get(l));
        						System.out.println("x = "+x);
        						System.out.println("[imsicolumn]" + imsicolumn);
        						System.out.println("======");*/
        						//System.out.println("[imsiList.get(l).get(x)] = "+imsiList.get(l).get(x+"").toString() + " [x] = "+x+" [imsicolumn] "+imsicolumn);
        						if(imsiList.get(l).containsKey(x+"")){
        							//System.out.println("[[BODY Contains imsicolumn]] " +imsicolumn);
        							//예외처리1 dhxCalendarA
		  	  						if(typeList.get(l).get(x+"").equals("dhxcalendara")){
		  	  							imsicolumn=imsicolumn.replace("-", "");
		  	  						}
		  	  					    else if(typeList.get(l).get(x+"").toString().indexOf("edn") > -1){
		  	  					    	//System.out.println("[PAYAMT edn]" + imsicolumn);
		  	  					    	try{
		  	  					    	imsicolumn=imsicolumn.replaceAll(",", "");
		  	  					 	}
		  	  					    	catch(NumberFormatException e){imsicolumn="";}
		  	  					    }
        							map.put(imsiList.get(l).get(x+"").toString(), imsicolumn);
        						}
        						else{continue;}
        					}
        				}
  	        		}
  	        		if(j!=0){resList.add(map);}
  	        	}
  	        }
  	       // System.out.println("[[1-5]] ");
  	        return resList;
  		}
  		
  		public static Map<String, Object> getNewMap(){
  			return new HashMap<String, Object>();
  		}
  		
  		/**
  		 * 엑셀 파일 xlsx 인 경우
  		 * @param is
  		 * @param headerList 
  		 * @return 
  		 * @throws IOException 
  		 */
  		@SuppressWarnings({ "unused", "resource" })
		public static List<Map<String, Object>> loadExcelData2007(InputStream is, List<String[]> headerList) throws IOException {
  			//logger.debug("loadExcelData2007 Start !!!");
  			
  			XSSFWorkbook  wb = new XSSFWorkbook(is);
  		    XSSFRow row = null;
  	        XSSFSheet sheet = wb.getSheetAt(0); //시트 가져오기
  	        int rows = sheet.getPhysicalNumberOfRows(); //행 갯수 가져오기
  	        int noOfColumns = sheet.getRow(0).getLastCellNum(); //열 갯수 가져오기
  	        //logger.debug("rows [" + rows + "]");
  	        
  	        List<Map<String, Object>> resList = new ArrayList<Map<String, Object>>();
  	        List<String[]> list = headerList;
	        String[] arrId=list.get(0);
	        String[] arrIsHidden=list.get(1);
	      	String[] arrType=list.get(2);
	    	String[] arrLabel=list.get(3);
	    	List<Map<String,Object>> imsiList = new ArrayList<Map<String,Object>>();
	    	List<Map<String,Object>> typeList = new ArrayList<Map<String,Object>>();
	    	
	    	for(int j=0; j<rows; j++){	//row 루프
  	        	row = sheet.getRow(j); //row 가져오기
//  	        	//logger.debug("row.getLastCellNum() = "+ row.getLastCellNum()+" row.getRowNum() = "+ row.getRowNum()+" rows ="+rows + " j = "+j);
  	        	if(row != null){
  	        		Map<String, Object> map = getNewMap();
  	        		//데이터가 존재하는 마지막셀인지 확인 => 데이터가 없는 셀이면 break
  	        		if(ExceltoJava.getCellValue2007(row.getCell(0))==null||ExceltoJava.getCellValue2007(row.getCell(0)).equals("")){
  	        			boolean justify=true;
  	        			for(int x=0;x<noOfColumns;x++){
  	        				if(ExceltoJava.getCellValue2007(row.getCell(x))!=null&&!ExceltoJava.getCellValue2007(row.getCell(x)).equals("")){
  	        					justify=false;
  	        				}
  	        			}
  	        			if(justify){
  	        				break;
  	        			}
  	        		}
  	        		for(int x=0;x<noOfColumns;x++){
  	        			String imsicolumn=ExceltoJava.getCellValue2007(row.getCell(x))==null?"":ExceltoJava.getCellValue2007(row.getCell(x));
  	        			
  	        			//헤더인경우
        				if(j==0){
//        					//logger.debug("[[HEADER - imsicolumn]] " +imsicolumn);
        					//헤더의 경우 줄바꿈 제거
      	        			imsicolumn = imsicolumn.replace("\n", "");
        					for(int k=0;k<arrLabel.length;k++){
        						//System.out.println(arrLabel[k]);
            					//엑셀레이블과 동일한 헤더가 있다면
            					if(arrLabel[k].equals(imsicolumn)){
            						Map<String,Object> tmpList = getNewMap();
            						Map<String,Object> typeMap = getNewMap();
            						tmpList.put(x+"",arrId[k]);
            						typeMap.put(x+"",arrType[k]);
            						imsiList.add(tmpList);
            						typeList.add(typeMap);
            					}
            					else{
            						continue;
            					}
            				}
        				}
        				//컬럼인경우
        				else{
//        					//logger.debug("[[컬럼인경우]]");
        					for(int l=0;l<imsiList.size();l++){
        						/*//logger.debug("======");
        						//logger.debug("imsiList.get("+l+")" + imsiList.get(l));
        						//logger.debug("typeList.get("+l+")" + typeList.get(l));
        						//logger.debug("x : "+x);
        						//logger.debug("[imsicolumn] : " + imsicolumn);
        						//logger.debug("imsiList.get("+l+").containsKey("+x+") : "+imsiList.get(l).containsKey(x+""));
        						//logger.debug("======");*/
//        						//logger.debug("[imsiList.get(l).get(x)] = "+imsiList.get(l).get(x+"").toString() + " [x] = "+x+" [imsicolumn] "+imsicolumn);
//        						//logger.debug("imsiList.get(l).get(x).toString() : "+imsiList.get(l).get(x+""));
//        						//logger.debug("typeList.get(l).get(x).toString() : "+typeList.get(l).get(x+""));
//	  	  					    //logger.debug("imsicolumn : " + imsicolumn);
        						if(imsiList.get(l).containsKey(x+"")){
//        							//logger.debug("true in...");
        							//예외처리1 dhxCalendarA
        							if(typeList.get(l).get(x+"").equals("dhxcalendara")){
		  	  							imsicolumn=imsicolumn.replace("-", "");
		  	  						}
		  	  					    else if(typeList.get(l).get(x+"").toString().indexOf("edn") > -1){
//			  	  					    //logger.debug("typeList.get(l).get(x).toString() : "+typeList.get(l).get(x+""));
//			  	  					    //logger.debug("[PAYAMT edn]" + imsicolumn);
		  	  					    	try{
		  	  					    		imsicolumn=imsicolumn.replaceAll(",", "");
		  	  					    	}
		  	  					    	catch(NumberFormatException e){imsicolumn="";}
		  	  					    }
        							map.put(imsiList.get(l).get(x+"").toString(), imsicolumn);
//        							//logger.debug("true out...");
        						}
        						else{
//        							//logger.debug("false in...");
        							continue;
        						}
        					}
        				}
  	        		}
//  	        		//logger.debug("INSERT Check / j : "+j);
  	        		if(j!=0){
//  	        			//logger.debug("map.toString : "+map.toString());
  	        			resList.add(map);
  	        		}
  	        	}
  	        }
//	    	//logger.debug("resList.toString : "+resList.toString());
	    	return resList;
  		}
  		
  		/**
  		 * 엑셀 파일 xls 인 경우
  		 * @param is
  		 * @param headerList 
  		 * @return 
  		 * @throws IOException 
  		 */
  		@SuppressWarnings({ "unused", "resource" })
		public static List<Map<String, Object>> loadExcelData(InputStream is,String gubn) throws IOException {
  			//logger.debug("loadExcelData Start !!!");
  			POIFSFileSystem fs = new POIFSFileSystem(is);
//  			System.out.println("is start");
  			//logger.debug("is Start !!!");
  	        HSSFWorkbook wb = new HSSFWorkbook(fs);
  	        HSSFRow row= null;
  	        
  	        List<Map<String, Object>> resList = new ArrayList<Map<String, Object>>();

  	        
  	        HSSFSheet sheet = wb.getSheetAt(0); //시트 가져오기
  	        int rows = sheet.getPhysicalNumberOfRows(); //행 갯수 가져오기
  	        int noOfColumns = sheet.getRow(0).getLastCellNum(); //열 갯수 가져오기
  	        List<Map<String,Object>> imsiList = new ArrayList<Map<String,Object>>();
  	        List<Map<String,Object>> typeList = new ArrayList<Map<String,Object>>();
  	        
  	        /*** value HashMapList 저장 */
  	        for(int j=0; j<rows; j++){	//row 루프
  	        	row = sheet.getRow(j); //row 가져오기
  	        	//System.out.println("row.getLastCellNum() = "+ row.getLastCellNum()+" row.getRowNum() = "+ row.getRowNum()+" rows ="+rows + " j = "+j);
  	        	if(row != null){
  	        		Map<String, Object> map = getNewMap();
  	        		//데이터가 존재하는 마지막셀인지 확인 => 데이터가 없는 셀이면 break
  	        		if(ExceltoJava.getCellValue(row.getCell(0))==null||ExceltoJava.getCellValue(row.getCell(0)).equals("")){
  	        			boolean justify=true;
  	        			for(int x=0;x<noOfColumns;x++){
  	        				if(ExceltoJava.getCellValue(row.getCell(x))!=null&&!ExceltoJava.getCellValue(row.getCell(x)).equals("")){
  	        					justify=false;
  	        				}
  	        			}
  	        			if(justify){
  	        				break;
  	        			}
  	        		}
  	        		for(int x=0;x<noOfColumns;x++){
  	        			String imsicolumn=ExceltoJava.getCellValue(row.getCell(x))==null?"":ExceltoJava.getCellValue(row.getCell(x));
  	        			
  	        			//헤더인경우
        				if(j==0){
        					//System.out.println("[[HEADER - imsicolumn]] " +imsicolumn);
            					//엑셀레이블과 동일한 헤더가 있다면
        					if("주문번호".equals(imsicolumn)||"결합상품계약번호".equals(imsicolumn)){
        						continue;
        					}
        				//컬럼인경우
        				}else{
        					//System.out.println("[[BODY - imsicolumn]] " +imsicolumn);
        					for(int l=0;l<imsiList.size();l++){
        					/*	System.out.println("======");
        						System.out.println(imsiList.get(l));
        						System.out.println(typeList.get(l));
        						System.out.println("x = "+x);
        						System.out.println("[imsicolumn]" + imsicolumn);
        						System.out.println("======");*/
        						//System.out.println("[imsiList.get(l).get(x)] = "+imsiList.get(l).get(x+"").toString() + " [x] = "+x+" [imsicolumn] "+imsicolumn);
        						if(imsiList.get(l).containsKey(x+"")){
        							//System.out.println("[[BODY Contains imsicolumn]] " +imsicolumn);
        						
        							map.put(imsiList.get(l).get(x+"").toString(), imsicolumn);
        						}
        						else{continue;}
        					}
        				}
  	        		}
  	        		if(j!=0){resList.add(map);}
  	        	}
  	        }
  	       // System.out.println("[[1-5]] ");
  	        return resList;
  		}
  		
  		/**
  		 * 엑셀 파일 xlsx 인 경우
  		 * @param is
  		 * @param headerList 
  		 * @return 
  		 * @throws IOException 
  		 */
  		@SuppressWarnings({ "unused", "resource" })
		public static List<Map<String, Object>> loadExcelData2007(InputStream is,String gubn) throws IOException {
  			//logger.debug("loadExcelData2007 Start !!!");
  			
  			XSSFWorkbook  wb = new XSSFWorkbook(is);
  		    XSSFRow row = null;
  	        XSSFSheet sheet = wb.getSheetAt(0); //시트 가져오기
  	        int rows = sheet.getPhysicalNumberOfRows(); //행 갯수 가져오기
  	        int noOfColumns = sheet.getRow(0).getLastCellNum(); //열 갯수 가져오기
//  	        //logger.debug("rows [" + rows + "]");
  	        
  	        List<Map<String, Object>> resList = new ArrayList<Map<String, Object>>();
	    	List<Map<String,Object>> imsiList = new ArrayList<Map<String,Object>>();
	    	List<HashMap<String,Object>> typeList = new ArrayList<HashMap<String,Object>>();
	    	
	    	for(int j=0; j<rows; j++){	//row 루프
  	        	row = sheet.getRow(j); //row 가져오기
  	        	//System.out.println("row.getLastCellNum() = "+ row.getLastCellNum()+" row.getRowNum() = "+ row.getRowNum()+" rows ="+rows + " j = "+j);
  	        	if(row != null){
//  	        		//logger.debug("row start!!");
  	        		Map<String, Object> map = getNewMap();
  	        		//데이터가 존재하는 마지막셀인지 확인 => 데이터가 없는 셀이면 break
  	        		if(ExceltoJava.getCellValue2007(row.getCell(0))==null||ExceltoJava.getCellValue2007(row.getCell(0)).equals("")){
  	        			boolean justify=true;
  	        			for(int x=0;x<noOfColumns;x++){
  	        				if(ExceltoJava.getCellValue2007(row.getCell(x))!=null&&!ExceltoJava.getCellValue2007(row.getCell(x)).equals("")){
  	        					justify=false;
  	        				}
  	        			}
  	        			if(justify){
  	        				break;
  	        			}
  	        		}
  	        		for(int x=0;x<noOfColumns;x++){
  	        			String imsicolumn=ExceltoJava.getCellValue2007(row.getCell(x))==null?"":ExceltoJava.getCellValue2007(row.getCell(x));
//  	        			//logger.debug("imsicolumn0=="+imsicolumn);
  	        		//헤더인경우
        				if(j==0){
        					//System.out.println("[[HEADER - imsicolumn]] " +imsicolumn);
        					//엑셀레이블과 동일한 헤더가 있다면
    					if("주문번호".equals(imsicolumn)||"결합상품계약번호".equals(imsicolumn)){
    						continue;
    					}
    				//컬럼인경우
    				}else{
    					//System.out.println("[[BODY - imsicolumn]] " +imsicolumn);
    					for(int l=0;l<imsiList.size();l++){
    					/*	System.out.println("======");
    						System.out.println(imsiList.get(l));
    						System.out.println(typeList.get(l));
    						System.out.println("x = "+x);
    						System.out.println("[imsicolumn]" + imsicolumn);
    						System.out.println("======");*/
    						//System.out.println("[imsiList.get(l).get(x)] = "+imsiList.get(l).get(x+"").toString() + " [x] = "+x+" [imsicolumn] "+imsicolumn);
    						if(imsiList.get(l).containsKey(x+"")){
    							//System.out.println("[[BODY Contains imsicolumn]] " +imsicolumn);
    						
    							map.put(imsiList.get(l).get(x+"").toString(), imsicolumn);
    						}
    						else{continue;}
    					}
    				}
	        		}
	        		if(j!=0){resList.add(map);}
	        	}
  	        }
  	    return resList;
  		}

		@SuppressWarnings("resource")
		public static List<Map<String, Object>> loadExcelDataEvent(InputStream is, String crudEEventIDX) throws IOException {
			//logger.debug("loadExcelData Start !!!");
  			POIFSFileSystem fs = new POIFSFileSystem(is);
  	        HSSFWorkbook wb = new HSSFWorkbook(fs);
  	        HSSFRow row= null;
  	        
  	        List<Map<String, Object>> resList = new ArrayList<Map<String, Object>>();

  	        
  	        HSSFSheet sheet = wb.getSheetAt(0); //시트 가져오기
  	        int rows = sheet.getPhysicalNumberOfRows(); //행 갯수 가져오기
  	        int noOfColumns = sheet.getRow(0).getLastCellNum(); //열 갯수 가져오기
  	        
  	        /*** value HashMapList 저장 */
  	        for(int j=0; j<rows; j++){	//row 루프
  	        	row = sheet.getRow(j); //row 가져오기
  	        	//System.out.println("row.getLastCellNum() = "+ row.getLastCellNum()+" row.getRowNum() = "+ row.getRowNum()+" rows ="+rows + " j = "+j);
  	        	if(row != null){
  	        		Map<String, Object> map = getNewMap();
  	        		//데이터가 존재하는 마지막셀인지 확인 => 데이터가 없는 셀이면 break
  	        		if(ExceltoJava.getCellValue(row.getCell(0))==null||ExceltoJava.getCellValue(row.getCell(0)).equals("")){
  	        			boolean justify=true;
  	        			for(int x=0;x<noOfColumns;x++){
  	        				if(ExceltoJava.getCellValue(row.getCell(x))!=null&&!ExceltoJava.getCellValue(row.getCell(x)).equals("")){
  	        					justify=false;
  	        				}
  	        			}
  	        			if(justify){
  	        				break;
  	        			}
  	        		}
  	        		for(int x=0;x<noOfColumns;x++){
  	        			String imsicolumn=ExceltoJava.getCellValue(row.getCell(x))==null?"":ExceltoJava.getCellValue(row.getCell(x));
  	        			
  	        			//헤더인경우
        				if(j==0){
            				continue;
        				}
        				//컬럼인경우
        				else{
        					map.put(x+"", imsicolumn);
        				}
  	        		}
  	        		map.put(2+"", crudEEventIDX);
  	        		if(j!=0){resList.add(map);}
  	        	}
  	        }
  	       // System.out.println("[[1-5]] ");
  	        return resList;
		}

		@SuppressWarnings("resource")
		public static List<Map<String, Object>> loadExcelData2007Event(InputStream is, String crudEEventIDX) throws IOException {
			//logger.debug("loadExcelData2007Event Start !!!");
  			
  			XSSFWorkbook  wb = new XSSFWorkbook(is);
  		    XSSFRow row = null;
  	        XSSFSheet sheet = wb.getSheetAt(0); //시트 가져오기
  	        int rows = sheet.getPhysicalNumberOfRows(); //행 갯수 가져오기
  	        int noOfColumns = sheet.getRow(0).getLastCellNum(); //열 갯수 가져오기
//  	        //logger.debug("rows [" + rows + "]");
//  	        //logger.debug("crudEEventIDX [" + crudEEventIDX + "]");
  	        
  	        List<Map<String, Object>> resList = new ArrayList<Map<String, Object>>();
	    	
	    	for(int j=0; j<rows; j++){	//row 루프
  	        	row = sheet.getRow(j); //row 가져오기
  	        	//System.out.println("row.getLastCellNum() = "+ row.getLastCellNum()+" row.getRowNum() = "+ row.getRowNum()+" rows ="+rows + " j = "+j);
  	        	if(row != null){
  	        		Map<String, Object> map = getNewMap();
  	        		//데이터가 존재하는 마지막셀인지 확인 => 데이터가 없는 셀이면 break
  	        		if(ExceltoJava.getCellValue2007(row.getCell(0))==null||ExceltoJava.getCellValue2007(row.getCell(0)).equals("")){
  	        			boolean justify=true;
  	        			for(int x=0;x<noOfColumns;x++){
  	        				if(ExceltoJava.getCellValue2007(row.getCell(x))!=null&&!ExceltoJava.getCellValue2007(row.getCell(x)).equals("")){
  	        					justify=false;
  	        				}
  	        			}
  	        			if(justify){
  	        				break;
  	        			}
  	        		}
  	        		for(int x=0;x<noOfColumns;x++){
  	        			String imsicolumn=ExceltoJava.getCellValue2007(row.getCell(x))==null?"":ExceltoJava.getCellValue2007(row.getCell(x));
  	        		//헤더인경우
        				if(j==0){
            				continue;
        				}
        				//컬럼인경우
        				else{
        					map.put(x+"", imsicolumn);
        				}
  	        		}
  	        		map.put(2+"", crudEEventIDX);
  	        		if(j!=0){resList.add(map);}
  	        	}
  	        }
	    	return resList;
		}
}
