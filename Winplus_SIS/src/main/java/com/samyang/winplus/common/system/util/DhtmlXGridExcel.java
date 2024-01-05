package com.samyang.winplus.common.system.util;

import java.awt.Color;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.Comment;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.samyang.winplus.common.system.security.xss.XSSConverter;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


/** 
 * DhtmlXGrid 엑셀 생성
 * @since 2017.07.28
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2017.07.28	/ 김종훈 / 신규 생성
 *********************************************
 */
@Component("dhtmlXGridExcel")
public class DhtmlXGridExcel {

	@Autowired
	CommonUtil commonUtil;
	
	static Logger logger = LoggerFactory.getLogger(DhtmlXGridExcel.class);
	/**
	  * generateDhtmlXGridExcel - DhtmlXGridExcel 생성
	  * @author 김종훈
	  * @param request
	  * @return XSSFWorkbook
	  * @exception IOException
	  * @exception Exception
	  */
	public XSSFWorkbook generateDhtmlXGridExcel(HttpServletRequest request) throws IOException, Exception{
		XSSFWorkbook workbook = new XSSFWorkbook();
		String header = request.getParameter("header");
		String contents = request.getParameter("contents");
		String fileName = request.getParameter("fileName");
		String formYn = request.getParameter("form_yn");
		String strHeaderDepth = request.getParameter("headerDepth");
		int headerDepth = commonUtil.isInteger(strHeaderDepth) ? Integer.parseInt(strHeaderDepth) : 1;
		
		workbook.createSheet(fileName);
		XSSFSheet sheet = workbook.getSheetAt(0);
		
		
		JSONArray headerArray = JSONArray.fromObject(header);
		int colCnt = headerArray.size();
		
		//logger.debug("headerDepth : "+headerDepth);
		//logger.debug("header : "+header);
		
		//logger.debug("colCnt : "+colCnt);
		
		XSSFFont defaultFont = workbook.createFont();
		defaultFont.setFontHeight(10.0);
		defaultFont.setFontName("맑은 고딕");
				
		XSSFCellStyle headerStyle = workbook.createCellStyle();
		headerStyle.setAlignment(HorizontalAlignment.CENTER);
		headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		headerStyle.setFillForegroundColor(new XSSFColor(new Color(230, 230, 230)));
		headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		headerStyle.setFont(defaultFont);
		
		String[][] baseHeaderText = new String[headerDepth][colCnt];
		for(int c = 0; c < colCnt; c++){
			JSONObject column = headerArray.getJSONObject(c);
			JSONArray labelArray = column.getJSONArray("label");
			int labelArraySize = labelArray.size();
			for(int r = 0; r < headerDepth; r++){
				String text = null;
				if(labelArraySize <= r){
					text = "#rspan";
				} else {
					text = labelArray.getString(r);
					if(text.startsWith("#")){
						if(!("#rspan".equals(text) || "#cspan".equals(text))){
							text = "#rspan";
						}
					}
				}
				baseHeaderText[r][c] = text;
			}			
		}
		
		List<Integer> ableRow = new ArrayList<Integer>();
		for(int r = 0; r < headerDepth; r++){
			boolean isAbleRow = false;
			for(int c = 0; c < colCnt; c++){
				if(!baseHeaderText[r][c].equals("#rspan")){
					isAbleRow = true;
					break;
				}
			}
			if(isAbleRow){
				ableRow.add(r);
			}
		}
		
		String[][] headerText = new String[ableRow.size()][colCnt];
		boolean[][] isIgnoreXY = new boolean[ableRow.size()][colCnt];
		int rowCnt = 0;
		for(int r = 0; r < headerDepth; r++){
			if(!ableRow.contains(r)){
				continue;
			}
			for(int c = 0; c < colCnt; c++){				
				headerText[rowCnt][c] = baseHeaderText[r][c];
			}
			sheet.createRow(rowCnt);
			rowCnt++;
		}
		
		JSONObject column = null;
		String columnType = "";
		String columnComboOption = "";
		for(int r = 0; r < rowCnt; r++){
			for(int c = 0; c < colCnt; c++){
				if(isIgnoreXY[r][c]){
					continue;
				}
				String text = headerText[r][c];

				if("#rspan".equals(text)){
					int begin = r;
					//logger.debug("begin : "+begin);
					if(begin - 1 < 0){
						begin = 0;
					} else if(begin >= 0 && !headerText[begin - 1][c].equals("#cspan")){
						begin--;
					}
					int end = r;
					while(end < rowCnt){
						text = headerText[end][c];
						if(!"#rspan".equals(text)){
							break;
						} else {
							isIgnoreXY[end][c] = true;
							end++;
						}
					}
					end--;
					if(begin < end){
						sheet.addMergedRegion(getNewCellRangeAddress(begin, end, c, c));
					}
				} else if ("#cspan".equals(text)){
					int begin = c;
					if(begin >= 0 && !headerText[r][begin - 1].equals("#rspan")){
						begin--;
					}
					int end = c; 
					while(end < colCnt){
						text = headerText[r][end];
						if(!"#cspan".equals(text)){
							break;
						} else {
							isIgnoreXY[r][end] = true;
							end++;
						}
					}
					end--;
					if(begin < end){
						sheet.addMergedRegion(getNewCellRangeAddress(r, r, begin, end));
					}
				} else {
					sheet.getRow(r).createCell(c).setCellStyle(headerStyle);					
					sheet.getRow(r).getCell(c).setCellValue(text);
					if(r == 0) {
						column = headerArray.getJSONObject(c);
						columnType = column.getString("type");
						if(columnType.equals("combo")) {
							if(column.has("comboOption")){
								columnComboOption = column.getString("comboOption");
								columnComboOption = columnComboOption.replace("{", "");
								columnComboOption = columnComboOption.replace("}", "");
								columnComboOption = columnComboOption.replace(",", "\n");
								columnComboOption = columnComboOption.replace("\"", "");
								columnComboOption = "---- 표시용 : 실제입력값 ----" + "\n" + columnComboOption;
								//sheet.getRow(r).getCell(c).setCellComment(createComment(workbook,sheet,"삼양",columnComboOption));
							}
						}
					}
				}
			}
		}
		
		for(int c = 0; c < colCnt; c++){
			column = headerArray.getJSONObject(c);
			int width = column.getInt("width");
			sheet.setColumnWidth(c, width * 40);
		}
		
		if(formYn == null || !formYn.equals("Y")){
			Map<String, XSSFCellStyle> styleMap = new HashMap<String, XSSFCellStyle>();
			XSSFCellStyle leftStyle = workbook.createCellStyle();
			XSSFCellStyle centerStyle = workbook.createCellStyle();
			XSSFCellStyle rightStyle = workbook.createCellStyle();
			leftStyle.setAlignment(HorizontalAlignment.LEFT);
			leftStyle.setVerticalAlignment(VerticalAlignment.CENTER);
			leftStyle.setFont(defaultFont);
			centerStyle.setAlignment(HorizontalAlignment.CENTER);
			centerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
			centerStyle.setFont(defaultFont);
			rightStyle.setAlignment(HorizontalAlignment.RIGHT);
			rightStyle.setVerticalAlignment(VerticalAlignment.CENTER);
			rightStyle.setFont(defaultFont);
			styleMap.put("left", leftStyle);
			styleMap.put("center", centerStyle);
			styleMap.put("right", rightStyle);
			
			JSONArray contentsArray = JSONArray.fromObject(contents);			
			for(int i = 0; i < contentsArray.size(); i++){
				sheet.createRow(rowCnt);
				XSSFRow row = sheet.getRow(rowCnt);
				JSONObject rowMap = contentsArray.getJSONObject(i);
				for(int c = 0; c < colCnt; c++){
					column = headerArray.getJSONObject(c);
					String cId = column.getString("id");
					String type = column.getString("type");
					if(type != null){
						type = type.toLowerCase();
					}
					String align = column.getString("align");
					if(align == null || align.equals("")){
						align = "left";
					}
					align = align.toLowerCase();
					
					String styleKey = align;
					XSSFCellStyle style = null;
					if(type != null && (type.equals("cntr") || type.indexOf("edn") > -1 || type.indexOf("ron") > -1)){
						if(column.containsKey("numberFormat")){
							String numberFormat = column.getString("numberFormat");
							if(numberFormat != null){
								String styleKeyAdd = styleKey + "_"+ numberFormat;
//								styleKey = styleKey + "_"+ numberFormat;
								if(styleMap.containsKey(styleKeyAdd)){
									style = styleMap.get(styleKeyAdd);
								} else {
									style = workbook.createCellStyle();
									XSSFDataFormat format = workbook.createDataFormat();
									if(numberFormat.length() > 1){
										numberFormat = numberFormat.replace("0", "#");
										numberFormat = numberFormat.substring(0, numberFormat.length() - 1) + "0";
									} else {
										numberFormat = "0";
									}
									style.setDataFormat(format.getFormat(numberFormat));
									style.setVerticalAlignment(VerticalAlignment.CENTER);
									if("center".equals(align)){
										style.setAlignment(HorizontalAlignment.CENTER);
									} else if("right".equals(align)){
										style.setAlignment(HorizontalAlignment.RIGHT);
									} else {
										style.setAlignment(HorizontalAlignment.LEFT);
									}
									style.setFont(defaultFont);
									styleMap.put(styleKeyAdd, style);
								}
							}
						} else {
							style = styleMap.get(align);
						}
						String str = null;
						Double value = 0.0;
						if("cntr".equals(type)){
							value = (double) (i + 1);
						} else {
							str = rowMap.getString(cId);
							if(str != null){
								str = str.replace(",", "");
								if(!commonUtil.isDouble(str)){
									if(commonUtil.isInteger(str)){
										value = (double) Integer.parseInt(str);
									}
								} else {
									value = Double.parseDouble(str);
								}
							}
						}
						row.createCell(c).setCellStyle(style);
						row.getCell(c).setCellType(CellType.NUMERIC);
						row.getCell(c).setCellValue(value);
					} else {
						style = styleMap.get(align);
						String value = rowMap.getString(cId);
						if(value == null){
							value = "";
						}
						value = XSSConverter.reverseXSS(value);
						row.createCell(c).setCellStyle(style);
						row.getCell(c).setCellValue(value);
					}
				}
				rowCnt++;
			}
		}
		return workbook;
	}
	
	public CellRangeAddress getNewCellRangeAddress(int begin, int end, int c, int d){
		return new CellRangeAddress(begin, end, c, d);
	}
	
	public Comment createComment(Workbook workbook, Sheet sheet, String author, String commentText) {
        CreationHelper factory = workbook.getCreationHelper();
        Drawing drawing = sheet.createDrawingPatriarch();
        ClientAnchor anchor = factory.createClientAnchor();
        Comment comment = drawing.createCellComment(anchor);
        comment.setString(factory.createRichTextString(commentText));
        comment.setAuthor(author);
        return comment;
    }
}
