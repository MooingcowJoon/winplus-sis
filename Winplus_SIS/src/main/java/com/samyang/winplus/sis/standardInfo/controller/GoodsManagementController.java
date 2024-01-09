package com.samyang.winplus.sis.standardInfo.controller;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
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

import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;
import com.samyang.winplus.common.system.config.ServerVariable;
import com.samyang.winplus.common.system.file.service.FileService;
import com.samyang.winplus.sis.standardInfo.service.GoodsCategoryService;
import com.samyang.winplus.sis.standardInfo.service.GoodsInformationService;

@RequestMapping("/sis/standardInfo/goods")
@RestController
public class GoodsManagementController {
	
	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	protected CommonUtil commonUtil;
	
	@Autowired
	GoodsCategoryService goodsCategoryService;
	
	@Autowired
	GoodsInformationService goodsInformationService;
	
	@Autowired
	ServerVariable serverVariable;
	
	@Autowired
	FileService fileService;
	
	@SuppressWarnings("unused")
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final static String DEFAULT_PATH = "sis/standardInfo/goods";
	
	/**
	  * 기준정보관리 - 상품관리 - 상품분류관리
	  * @author 강신영
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="goodsCategoryManagement.sis", method=RequestMethod.POST)
	public ModelAndView goodsCategoryManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "goodsCategoryManagement");
		return mav;
	}
	
	/**
	  * getGoodsCategory - 상품분류관리 - 상품분류 항목 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getGoodsCategory.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsCategory(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String grup_cd = request.getParameter("GRUP_CD");
		if(grup_cd == null || grup_cd.length() == 0){
			String errMesage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("GRUP_CD", grup_cd);
			Map<String, Object> categoryMap = goodsCategoryService.getCategoryMap(paramMap);
			resultMap.put("dataMap", categoryMap);
		}
		return resultMap;
	}
	
	/**
	  * updateGoodsCategory - 상품분류관리 - 상품분류 항목 저장
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="updateGoodsCategory.do", method=RequestMethod.POST)
	public Map<String, Object> updateGoodsCategory(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String crud = request.getParameter("CRUD");
		String grup_cd = request.getParameter("GRUP_CD");
		String grup_nm = request.getParameter("GRUP_NM");
		String grup_top_cd = request.getParameter("GRUP_TOP_CD");
		String grup_mid_cd = request.getParameter("GRUP_MID_CD");
		String grup_bot_cd = request.getParameter("GRUP_BOT_CD");
		String grup_state = request.getParameter("GRUP_STATE");
		String grup_local_cd = request.getParameter("GRUP_LOCAL_CD");
		String currentErpTreeLvl = request.getParameter("currentErpTreeLvl");
		int treeLvlInt = 0;
		if(currentErpTreeLvl != null && !currentErpTreeLvl.equals("")) {
			treeLvlInt = Integer.parseInt(currentErpTreeLvl);
		}
		
		if(crud == null || crud.equals("")){				
			String errMesage = messageSource.getMessage("error.common.noChanged", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			if("C".equals(crud) || "U".equals(crud)){
				if(grup_nm == null || grup_nm.equals("")){
					String errMesage = messageSource.getMessage("error.sis.category.grup_nm.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1002";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(grup_nm.length() > 50){
					String errMesage = messageSource.getMessage("error.sis.category.grup_nm.length50Over", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1003";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(treeLvlInt >= 1 && (grup_top_cd == null || grup_top_cd.equals(""))) {
					String errMesage = messageSource.getMessage("error.sis.category.grup_top_cd.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1004";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(treeLvlInt >= 2 && (grup_mid_cd == null || grup_mid_cd.equals(""))) {
					String errMesage = messageSource.getMessage("error.sis.category.grup_mid_cd.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1005";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(treeLvlInt == 3 && (grup_bot_cd == null || grup_bot_cd.equals(""))) {
					String errMesage = messageSource.getMessage("error.sis.category.grup_bot_cd.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1006";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				} else if(grup_state == null || grup_state.equals("")){
					String errMesage = messageSource.getMessage("error.sis.category.grup_state.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1007";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);						
				} else if(grup_local_cd == null || grup_local_cd.equals("")){
					String errMesage = messageSource.getMessage("error.sis.category.grup_local_cd.empty", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1008";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			}
		}
		if(resultMap.keySet().size() == 0){
			if("U".equals(crud) || "D".equals(crud)) {
				if(grup_nm == null || grup_nm.equals("")){
					String errMesage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1009";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}
			}
			
			if(resultMap.keySet().size() == 0){					
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("CRUD", crud);
				paramMap.put("GRUP_CD", grup_cd);
				paramMap.put("GRUP_NM", grup_nm);
				if(grup_top_cd != null && grup_top_cd.equals("")) {
					paramMap.put("GRUP_TOP_CD", "0");
				} else {
					paramMap.put("GRUP_TOP_CD", grup_top_cd);
				}
				if(grup_mid_cd != null && grup_mid_cd.equals("")) {
					paramMap.put("GRUP_MID_CD", "0");
				} else {
					paramMap.put("GRUP_MID_CD", grup_mid_cd);
				}
				if(grup_bot_cd != null && grup_bot_cd.equals("")) {
					paramMap.put("GRUP_BOT_CD", "0");
				} else {
					paramMap.put("GRUP_BOT_CD", grup_bot_cd);
				}
				paramMap.put("GRUP_STATE", grup_state);
				paramMap.put("GRUP_LOCAL_CD", grup_local_cd);
				paramMap.put("treeLvlInt", treeLvlInt);
				paramMap.put("EMP_NO", emp_no);
				
				String resultMsg = goodsCategoryService.updateGoodsCategory(paramMap);
				
				if(resultMsg.equals("9999")){
					
					String errMesage = messageSource.getMessage("error.sis.category.no_delete_child_goods", new Object[1], commonUtil.getDefaultLocale());
					String errCode = "1010";
					resultMap = commonUtil.getErrorMap(errMesage, errCode);
				}else{
					resultMap.put("resultMsg", resultMsg);
				}
			}
		}
		return resultMap;
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 상품분류별상품등록
	  * @author 강신영
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="goodsCategoryByGoodsRegist.sis", method=RequestMethod.POST)
	public ModelAndView goodsCategoryByGoodsRegist(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "goodsCategoryByGoodsRegist");
		return mav;
	}
	
	/**
	  * getGoodsCategoryByGoodsList - 상품분류별상품등록 - 상품분류별 상품목록 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getGoodsCategoryByGoodsList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsCategoryByGoodsList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String grup_top_cd = request.getParameter("GRUP_TOP_CD");
		String grup_mid_cd = request.getParameter("GRUP_MID_CD");
		String grup_bot_cd = request.getParameter("GRUP_BOT_CD");			
		if(grup_top_cd != null && grup_top_cd.equals("")){
			String errMessage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else if(grup_mid_cd != null && grup_mid_cd.equals("")){
			String errMessage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1002";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else if(grup_bot_cd != null && grup_bot_cd.equals("")){
			String errMessage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1003";
			resultMap = commonUtil.getErrorMap(errMessage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("GRUP_TOP_CD", grup_top_cd);
			paramMap.put("GRUP_MID_CD", grup_mid_cd);
			paramMap.put("GRUP_BOT_CD", grup_bot_cd);
			
			List<Map<String, Object>> goodsList = goodsCategoryService.getGoodsCategoryByGoodsList(paramMap);				
			resultMap.put("gridDataList", goodsList);
		}	
		return resultMap;
	}
	
	/**
	  * updateCategoryByGoods - 상품분류별상품등록 - 상품분류별 상품목록 저장
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="updateCategoryByGoods.do", method=RequestMethod.POST)
	public Map<String, Object> updateCategoryByGoods(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		for(Map<String, Object> dhtmlxParamMap : dhtmlxParamMapList){
			dhtmlxParamMap.put("REG_ID", emp_no);
		}
		int resultRowCnt = goodsCategoryService.updateCategoryByGoods(dhtmlxParamMapList);
		resultMap.put("resultRowCnt", resultRowCnt);
		return resultMap;
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 상품정보관리
	  * @author 강신영
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="goodsInformationManagement.sis", method=RequestMethod.POST)
	public ModelAndView goodsInformationManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "goodsInformationManagement");
		return mav;
	}
	
	/**
	  * getGoodsInformationList - 상품정보관리 - 상품정보 목록 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getGoodsInformationList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsInformationList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("paramMap >>> " + paramMap);
		List<Map<String, Object>> informationMap = goodsInformationService.getGoodsInformationList(paramMap);
		resultMap.put("gridDataList", informationMap);
		
		return resultMap;
	}
	
	/**
	  * getGoodsInformation - 상품정보관리 - 상품정보 항목 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getGoodsInformation.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsInformation(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String goods_no = request.getParameter("GOODS_NO");
		if(goods_no == null || goods_no.length() == 0){
			String errMesage = messageSource.getMessage("error.common.noSelectedData", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1001";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		} else {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("GOODS_NO", goods_no);
			Map<String, Object> informationMap = goodsInformationService.getGoodsInformation(paramMap);
			resultMap.put("dataMap", informationMap);
		}
		return resultMap;
	}
	
	/**
	  * updateGoodsInformation - 상품정보관리 - 상품정보 항목 저장
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="updateGoodsInformation.do", method=RequestMethod.POST)
	public Map<String, Object> updateGoodsInformation(HttpServletRequest request,@RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		paramMap.put("PROGRM", "updateGoodsInformation");
		paramMap.put("EMP_NO", emp_no);
		
		//logger.debug("updateGoodsInformation paramMap >>>> " + paramMap );
		
		String crud = paramMap.get("CRUD");
		
		Map<String, Object> dataMap = new HashMap<String, Object>();
		
		if(crud != null && !crud.equals("D")) {
			dataMap = goodsInformationService.updateGoodsInformation(paramMap);
		} else {
			dataMap = goodsInformationService.deleteGoodsInformation(paramMap);
		}
		
		resultMap.put("dataMap", dataMap);
		
		return resultMap;
	}
	
	/**
	  * addGoodsFileInfo - 상품이미지 파일 저장
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  */
//	@RequestMapping(value = "addGoodsFileInfo.do", method = RequestMethod.POST)
//	public Map<String, Object> saveLoanFromPopup(MultipartRequest file_request,HttpServletRequest request, @RequestParam Map<String, Object> paramMap) {
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//		Map<String, String> uploadMap = new HashMap<String, String>();
//		
//		String DIRECTORY_KEY = paramMap.get("DIRECTORY_KEY") == null ? "" : paramMap.get("DIRECTORY_KEY").toString();
//		
//		int ResultCnt = 0;
//		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request); 
//		String EMP_NO = empSessionDto.getEmp_no();
//		
//		uploadMap.put("DIRECTORY_KEY", paramMap.get("DIRECTORY_KEY").toString());
//		
//		Map<String, String> UPLOAD_ATTACH_FILE_SAVE_ROOT_DIRECTORY_LIST = serverVariable.getUploadAttachFileSaveRootDirectoryList();
//		uploadMap.put("DIRECTORY_VALUE", UPLOAD_ATTACH_FILE_SAVE_ROOT_DIRECTORY_LIST.get(paramMap.get("DIRECTORY_KEY")));
//		
//		MultiValueMap<String, MultipartFile> fileMap = file_request.getMultiFileMap();
//		List<Map<String, Object>> attachFileList = fileService.uploadAttachFile(uploadMap, fileMap);
//		
//		paramMap.put("EMP_NO", EMP_NO);
//		
//		try {
//			ResultCnt = goodsInformationService.addGoodsFileInfo(paramMap);
//			resultMap.put("ResultCnt", ResultCnt);
//		}catch(SQLException e) {
//			resultMap = commonUtil.getErrorMap(e);
//		}catch(Exception e) {
//			resultMap = commonUtil.getErrorMap(e);
//		}
//		
//		return resultMap;
//	}
//	
	/**
	  * 기준정보관리 - 상품관리 - 상품일괄등록/수정
	  * @author 강신영
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="goodsBatchRegistModify.sis", method=RequestMethod.POST)
	public ModelAndView goodsBatchRegistModify(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "goodsBatchRegistModify");
		return mav;
	}
	
	/**
	  * getGoodsInformationFromBarcode - 상품일괄등록/수정 - 바코드로 상품정보 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getGoodsInformationFromBarcode.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsInformationFromBarcode(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String bcd_cd = paramMap.get("BCD_CD").toString();
		
		String BCD_YN = "Y";
		StringBuilder base_bcd = new StringBuilder();
		String[] base_bcd_list = bcd_cd.split("");
		
		if(base_bcd_list.length == 13){ //13자리 바코드일경우 유효성검사
			int front_num = Integer.parseInt(base_bcd_list[0]);
			int back_num = 0;
			
			for(int i = 0 ; i < base_bcd_list.length-1 ; i++){
				base_bcd.append(base_bcd_list[i]);
			}
			
			for(int f = 2 ; f < base_bcd_list.length-1 ; f = f+2) {
				front_num += Integer.parseInt(base_bcd_list[f]);
			}
			
			for(int b = 1 ; b < base_bcd_list.length-1 ; b = b+2) {
				back_num += Integer.parseInt(base_bcd_list[b]);
			}
			
			String[] Mid_Last_Num;
			Mid_Last_Num = (String.valueOf(front_num + (back_num * 3))).split("");
			int last_num = 10 - Integer.parseInt(Mid_Last_Num[Mid_Last_Num.length -1]);
			
			StringBuilder result_num = new StringBuilder();
			
			if(last_num == 10) {
				result_num.append(base_bcd.toString());
				result_num.append("0");
			} else {
				result_num.append(base_bcd.toString());
				result_num.append(String.valueOf(last_num));
			}
			
			if(bcd_cd.equals(result_num.toString())){  //정상바코드
				//logger.debug("정상바코드");
				BCD_YN = "Y";
			} else { //비정상바코드
				//logger.debug("비정상바코드");
				BCD_YN = "N";
			}
		} else if(base_bcd_list.length == 12) {
			int front_num = Integer.parseInt(base_bcd_list[0]);
			int back_num = 0;
			
			for(int i = 0 ; i < base_bcd_list.length-1 ; i++){
				base_bcd.append(base_bcd_list[i]);
			}
			
			for(int f = 2 ; f < base_bcd_list.length-1 ; f = f+2) {
				front_num += Integer.parseInt(base_bcd_list[f]);
			}
			
			for(int b = 1 ; b < base_bcd_list.length-1 ; b = b+2) {
				back_num += Integer.parseInt(base_bcd_list[b]);
			}
			
			String[] Mid_Last_Num;
			Mid_Last_Num = (String.valueOf((front_num * 3) + back_num)).split("");
			
			int last_num = 10 - Integer.parseInt(Mid_Last_Num[Mid_Last_Num.length -1]);
			
			StringBuilder result_num = new StringBuilder();
			
			if(last_num == 10) {
				result_num.append(base_bcd.toString());
				result_num.append("0");
			} else {
				result_num.append(base_bcd.toString());
				result_num.append(String.valueOf(last_num));
			}
			
			//logger.debug("bcd_cd >>>" + bcd_cd);
			//logger.debug("result_num >>>" + result_num);
			
			if(bcd_cd.equals(result_num.toString())){  //정상바코드
				BCD_YN = "Y";
			} else { //비정상바코드
				BCD_YN = "N";
			}
		}
		
		try{
			resultMap = goodsInformationService.getGoodsInformationFromBarcode(paramMap);
			if(BCD_YN.equals("N")) {
				resultMap = new HashMap<String, Object>();
				resultMap.put("OLD_NEW", "등록불가바코드");
				resultMap.put("GOODS_NO", "등록불가바코드");
				resultMap.put("GOODS_NM", "등록불가바코드");
				resultMap.put("BCD_NM", "등록불가바코드");
				resultMap.put("GRUP_TOP_NM", "등록불가바코드");
				resultMap.put("GRUP_MID_NM", "등록불가바코드");
				resultMap.put("GRUP_BOT_NM", "등록불가바코드");
			} else {
				if(resultMap == null){
					resultMap = new HashMap<String, Object>();
					resultMap.put("OLD_NEW", "신규상품");
					resultMap.put("GOODS_NO", "조회정보없음");
					resultMap.put("GOODS_NM", "조회정보없음");
					resultMap.put("BCD_NM", "조회정보없음");
					resultMap.put("GRUP_TOP_NM", "조회정보없음");
					resultMap.put("GRUP_MID_NM", "조회정보없음");
					resultMap.put("GRUP_BOT_NM", "조회정보없음");
				}
			}
		} catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	
	/**
	 * updateBatchGoodsInformation - 상품일괄등록/수정 - 상품정보 저장
	 * @author 강신영
	 * @param  request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="updateBatchGoodsInformation.do", method=RequestMethod.POST)
	public Map<String, Object> updateBatchGoodsInformation(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		//적용 직영점 세팅
		Map<String, Object> orgnCdMap = null;
		List<Map<String, Object>> orgnCdList = new ArrayList<Map<String, Object>>();
		
		String orgn_cd = request.getParameter("ORGN_CD");
		if(orgn_cd != null && orgn_cd.equals("ALL")) {
			orgnCdList = goodsInformationService.getAllOrgnCdList();
		} else if(orgn_cd != null && !orgn_cd.equals("")) {
			if(orgn_cd.contains(",")) {
				String[] orgn_cd_array = orgn_cd.split(",");
				for(int i=0; i<orgn_cd_array.length; i++) {
					orgnCdMap = new HashMap<String, Object>();
					orgnCdMap.put("ORGN_CD",orgn_cd_array[i]);
					orgnCdList.add(orgnCdMap);
				}
			}
		}
		
		int newGoodsCnt = 0;
		int modifyGoodsCnt = 0;
		int failGoodsCnt = 0;
		int newBarcodeCnt = 0;
		int modifyBarcodeCnt = 0;
		int failBarcodeCnt = 0;
		
		Map<String, Object> paramMap = null;
		
		Map<String, Object> resultDataMap = null;
		Map<String, Object> newGoodsMap = new HashMap<String, Object>();
		
		//상품정보 일괄 적용
		for(int i=0; i<dhtmlxParamMapList.size(); i++) {
			paramMap = new HashMap<String, Object>();
			paramMap.put("BCD_CD",dhtmlxParamMapList.get(i).get("BCD_CD"));
			paramMap.put("GOODS_NO",dhtmlxParamMapList.get(i).get("GOODS_NO"));
			paramMap.put("GOODS_NM",dhtmlxParamMapList.get(i).get("GOODS_NM"));
			paramMap.put("GRUP_TOP_CD",dhtmlxParamMapList.get(i).get("GRUP_TOP_CD"));
			paramMap.put("GRUP_TOP_NM",dhtmlxParamMapList.get(i).get("GRUP_TOP_NM"));
			paramMap.put("GRUP_MID_CD",dhtmlxParamMapList.get(i).get("GRUP_MID_CD"));
			paramMap.put("GRUP_MID_NM",dhtmlxParamMapList.get(i).get("GRUP_MID_NM"));
			paramMap.put("GRUP_BOT_CD",dhtmlxParamMapList.get(i).get("GRUP_BOT_CD"));
			paramMap.put("GRUP_BOT_NM",dhtmlxParamMapList.get(i).get("GRUP_BOT_NM"));
			paramMap.put("PROGRM", "updateBatchGoodsInformation");
			paramMap.put("EMP_NO", emp_no);
			
			resultDataMap = goodsInformationService.updateBatchGoodsInformation(paramMap);
			if(resultDataMap.get("RESULT_MSG").equals("SAVE_SUCCESS")) {
				++modifyGoodsCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("INS_SUCCESS")) {
				++newGoodsCnt;
				newGoodsMap.put((String) resultDataMap.get("BCD_CD"), resultDataMap.get("INS_GOODS_NO"));
			} else {
				++failGoodsCnt;
			}
		}
		
		//바코드 정보 일괄 적용
		for(int i=0; i<dhtmlxParamMapList.size(); i++) {
			paramMap = new HashMap<String, Object>();
			paramMap.put("BCD_CD",dhtmlxParamMapList.get(i).get("BCD_CD"));
			paramMap.put("BCD_M_CD",dhtmlxParamMapList.get(i).get("BCD_M_CD"));
			paramMap.put("BCD_NM",dhtmlxParamMapList.get(i).get("BCD_NM"));
			if(dhtmlxParamMapList.get(i).get("BCD_CD").equals(dhtmlxParamMapList.get(i).get("BCD_M_CD"))) {
				paramMap.put("BCD_MS_TYPE","M"); //모바코드
			} else {
				paramMap.put("BCD_MS_TYPE","S"); //자바코드
			}
			if(dhtmlxParamMapList.get(i).get("GOODS_NO") != null && !dhtmlxParamMapList.get(i).get("GOODS_NO").equals("")) {
				paramMap.put("GOODS_NO",dhtmlxParamMapList.get(i).get("GOODS_NO"));
			} else {
				paramMap.put("GOODS_NO",newGoodsMap.get(dhtmlxParamMapList.get(i).get("BCD_CD")));
			}
			paramMap.put("PROGRM", "updateBatchGoodsInformation");
			paramMap.put("EMP_NO", emp_no);
			
			resultDataMap = goodsInformationService.updateBatchBarcodeInformation(paramMap);
			if(resultDataMap.get("RESULT_MSG").equals("SAVE_SUCCESS")) {
				++modifyBarcodeCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("INS_SUCCESS")) {
				++newBarcodeCnt;
			} else {
				++failBarcodeCnt;
			}
		}
		
		resultMap.put("NEW_GOODS_CNT",newGoodsCnt);
		resultMap.put("MODIFY_GOODS_CNT",modifyGoodsCnt);
		resultMap.put("FAIL_GOODS_CNT",failGoodsCnt);
		resultMap.put("NEW_BARCODE_CNT",newBarcodeCnt);
		resultMap.put("MODIFY_BARCODE_CNT",modifyBarcodeCnt);
		resultMap.put("FAIL_BARCODE_CNT",failBarcodeCnt);
		
		return resultMap;
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 상품등록요청(직영점)
	  * @author 강신영
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="goodsRegistRequestDirectStore.sis", method=RequestMethod.POST)
	public ModelAndView goodsRegistRequestDirectStore(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "goodsRegistRequestDirectStore");
		return mav;
	}
	
	/**
	  * getGoodsRegistInformationList - 상품등록요청(직영점) - 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getGoodsRegistInformationList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsRegistInformationList(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> registInformationMap = goodsInformationService.getGoodsRegistInformationList(paramMap);
		resultMap.put("gridDataList", registInformationMap);
		
		return resultMap;
	}
	
	/**
	 * updateGoodsRegistInformation - 상품등록요청(직영점) - 저장
	 * @author 강신영
	 * @param  request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="updateGoodsRegistInformation.do", method=RequestMethod.POST)
	public Map<String, Object> updateGoodsRegistInformation(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		Map<String, Object> paramMap = null;
		Map<String, Object> resultDataMap = null;
		StringBuilder base_bcd = null;
		StringBuilder result_num = null;
		int updateCnt = 0;
		
		for(int i=0; i<dhtmlxParamMapList.size(); i++) {
			paramMap = new HashMap<String, Object>();
			paramMap.put("CRUD",dhtmlxParamMapList.get(i).get("CRUD"));
			paramMap.put("REG_DATE",dhtmlxParamMapList.get(i).get("REG_DATE"));
			paramMap.put("SEQ",dhtmlxParamMapList.get(i).get("SEQ"));
			paramMap.put("BCD_CD",dhtmlxParamMapList.get(i).get("BCD_CD"));
			paramMap.put("BCD_M_CD",dhtmlxParamMapList.get(i).get("BCD_M_CD"));
			paramMap.put("BCD_NM",dhtmlxParamMapList.get(i).get("BCD_NM"));
			paramMap.put("GOODS_NM",dhtmlxParamMapList.get(i).get("GOODS_NM"));
			paramMap.put("GRUP_BOT_NM",dhtmlxParamMapList.get(i).get("GRUP_BOT_NM"));
			paramMap.put("DIMEN_NM",dhtmlxParamMapList.get(i).get("DIMEN_NM"));
			paramMap.put("GOODS_EXP_CD",dhtmlxParamMapList.get(i).get("GOODS_EXP_CD"));
			paramMap.put("MAT_TEMPER_INFO",dhtmlxParamMapList.get(i).get("MAT_TEMPER_INFO"));
			paramMap.put("TAX_TYPE",dhtmlxParamMapList.get(i).get("TAX_TYPE"));
			paramMap.put("CUSTMR_NM",dhtmlxParamMapList.get(i).get("CUSTMR_NM"));
			paramMap.put("PUR_PRICE",dhtmlxParamMapList.get(i).get("PUR_PRICE"));
			paramMap.put("SALE_PRICE",dhtmlxParamMapList.get(i).get("SALE_PRICE"));
			paramMap.put("ORGN_CD",dhtmlxParamMapList.get(i).get("ORGN_CD"));
			paramMap.put("RESN",dhtmlxParamMapList.get(i).get("RESN"));
			paramMap.put("PROGRM", "updateGoodsRegistInformation");
			
			paramMap.put("GOODS_STATE", dhtmlxParamMapList.get(i).get("GOODS_STATE"));
			paramMap.put("GOODS_EXP_TYPE", dhtmlxParamMapList.get(i).get("GOODS_EXP_TYPE"));
			paramMap.put("GOODS_PUR_CD", dhtmlxParamMapList.get(i).get("GOODS_PUR_CD"));
			paramMap.put("GOODS_SALE_TYPE", dhtmlxParamMapList.get(i).get("GOODS_SALE_TYPE"));
			paramMap.put("ITEM_TYPE", dhtmlxParamMapList.get(i).get("ITEM_TYPE"));
			paramMap.put("POINT_SAVE_RATE", dhtmlxParamMapList.get(i).get("POINT_SAVE_RATE"));
			paramMap.put("MIN_PUR_QTY", dhtmlxParamMapList.get(i).get("MIN_PUR_QTY"));
			paramMap.put("MIN_PUR_UNIT", dhtmlxParamMapList.get(i).get("MIN_PUR_UNIT"));
			paramMap.put("MIN_ORD_UNIT", dhtmlxParamMapList.get(i).get("MIN_ORD_UNIT"));
			paramMap.put("MIN_ORD_QTY", dhtmlxParamMapList.get(i).get("MIN_ORD_QTY"));
			paramMap.put("MIN_UNIT_QTY", dhtmlxParamMapList.get(i).get("MIN_UNIT_QTY"));
			paramMap.put("RESP_USER", dhtmlxParamMapList.get(i).get("RESP_USER"));
			paramMap.put("PUR_DSCD_TYPE", dhtmlxParamMapList.get(i).get("PUR_DSCD_TYPE"));
			paramMap.put("SALE_DSCD_TYPE", dhtmlxParamMapList.get(i).get("SALE_DSCD_TYPE"));
			paramMap.put("DELI_DD_YN", dhtmlxParamMapList.get(i).get("DELI_DD_YN"));
			paramMap.put("GOODS_TC_TYPE", dhtmlxParamMapList.get(i).get("GOODS_TC_TYPE"));
			paramMap.put("DELI_AREA_YN", dhtmlxParamMapList.get(i).get("DELI_AREA_YN"));
			
			paramMap.put("EMP_NO", emp_no);
			paramMap.put("PROC_STATE", "1");
			paramMap.put("VALID_MSG", "");
			
			/* 바코드 유효성검사 */
			String bcd_cd = dhtmlxParamMapList.get(i).get("BCD_CD").toString();
			base_bcd = new StringBuilder();
			String[] base_bcd_list = bcd_cd.split("");
			
			if(base_bcd_list.length == 13){ //13자리 바코드일경우 유효성검사
				int front_num = Integer.parseInt(base_bcd_list[0]);
				int back_num = 0;
				
				for(int j = 0 ; j < base_bcd_list.length-1 ; j++){
					base_bcd.append(base_bcd_list[j]);
				}
				
				for(int f = 2 ; f < base_bcd_list.length-1 ; f = f+2) {
					front_num += Integer.parseInt(base_bcd_list[f]);
				}
				
				for(int b = 1 ; b < base_bcd_list.length-1 ; b = b+2) {
					back_num += Integer.parseInt(base_bcd_list[b]);
				}
				
				String[] Mid_Last_Num;
				Mid_Last_Num = (String.valueOf(front_num + (back_num * 3))).split("");
				int last_num = 10 - Integer.parseInt(Mid_Last_Num[Mid_Last_Num.length -1]);
				
				result_num = new StringBuilder();
				
				if(last_num == 10) {
					result_num.append(base_bcd.toString());
					result_num.append("0");
				} else {
					result_num.append(base_bcd.toString());
					result_num.append(String.valueOf(last_num));
				}
				
				if(!bcd_cd.equals(result_num.toString())){  //비정상바코드
					paramMap.put("PROC_STATE", "9");
					paramMap.put("VALID_MSG", "바코드생성규칙미준수");
				}
			} else if(base_bcd_list.length == 12) {
				logger.debug("12자리 바코드 테스트");
				int front_num = Integer.parseInt(base_bcd_list[0]);
				int back_num = 0;
				
				for(int j = 0 ; j < base_bcd_list.length-1 ; j++){
					base_bcd.append(base_bcd_list[j]);
				}
				
				for(int f = 2 ; f < base_bcd_list.length-1 ; f = f+2) {
					front_num += Integer.parseInt(base_bcd_list[f]);
				}
				
				for(int b = 1 ; b < base_bcd_list.length-1 ; b = b+2) {
					back_num += Integer.parseInt(base_bcd_list[b]);
				}
				
				String[] Mid_Last_Num;
				Mid_Last_Num = (String.valueOf((front_num * 3) + back_num)).split("");
				
				int last_num = 10 - Integer.parseInt(Mid_Last_Num[Mid_Last_Num.length -1]);
				
				result_num = new StringBuilder();
				
				if(last_num == 10) {
					result_num.append(base_bcd.toString());
					result_num.append("0");
				} else {
					result_num.append(base_bcd.toString());
					result_num.append(String.valueOf(last_num));
				}
				
				if(!bcd_cd.equals(result_num.toString())){  //비정상바코드
					paramMap.put("PROC_STATE", "9");
					paramMap.put("VALID_MSG", "바코드생성규칙미준수");
				}
			}
			
			resultDataMap = goodsInformationService.updateGoodsRegistInformation(paramMap);
			if(resultDataMap.get("RESULT_MSG").equals("SAVE_SUCCESS")) {
				++updateCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("INS_SUCCESS")) {
				++updateCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("DEL_SUCCESS")) {
				++updateCnt;
			} else {
			}
		}
		
		if(dhtmlxParamMapList.size() == updateCnt) {
			resultMap.put("resultRowCnt", updateCnt);
			goodsInformationService.validGoodsRegistInformation();
		} else {
			String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1999";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		}
		
		return resultMap;
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 상품등록승인관리
	  * @author 강신영
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="goodsRegistConfirmManagement.sis", method=RequestMethod.POST)
	public ModelAndView goodsRegistConfirmManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "goodsRegistConfirmManagement");
		return mav;
	}
	
	/**
	  * getGoodsRegistConfirmList - 상품등록승인관리 - 조회
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="getGoodsRegistConfirmList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsRegistConfirmList(HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> registConfirmMap = goodsInformationService.getGoodsRegistConfirmList(paramMap);
		resultMap.put("gridDataList", registConfirmMap);
		
		return resultMap;
	}
	
	/**
	  * updateGoodsConfirmApply - 상품등록승인관리 - 승인
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="updateGoodsConfirmApply.do", method=RequestMethod.POST)
	public Map<String, Object> updateGoodsConfirmApply(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		String uniqueids = request.getParameter("uniqueids");
		String[] uniqueidArray = uniqueids.split(",");
		String REG_DATE = null;
		String SEQ = null;
		
		Map<String, Object> paramMap = null;
		Map<String, Object> resultDataMap = null;
		int updateCnt = 0;
		
		for(int i=0; i<uniqueidArray.length; i++) {
			paramMap = new HashMap<String, Object>();
			REG_DATE = uniqueidArray[i].split("_")[0];
			SEQ = uniqueidArray[i].split("_")[1];
			paramMap.put("REG_DATE",REG_DATE);
			paramMap.put("SEQ",SEQ);
			paramMap.put("PROGRM", "updateGoodsConfirmApply");
			paramMap.put("EMP_NO", emp_no);
			
			resultDataMap = goodsInformationService.updateGoodsConfirmApply(paramMap);
			if(resultDataMap.get("RESULT_MSG").equals("SAVE_SUCCESS")) {
				++updateCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("DATA_APPLY")) {
				++updateCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("COMPLETE_APPLY")) {
				++updateCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("DATA_ERROR")) {
				++updateCnt;
			} else {
				
			}
		}
		
		if(uniqueidArray.length == updateCnt) {
			resultMap.put("resultRowCnt", updateCnt);
			resultMap.put("RESULT_MSG", resultDataMap.get("RESULT_MSG"));
		} else {
			String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1999";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		}
		
		return resultMap;
	}
	
	/**
	  * updateGoodsConfirmReject - 상품등록승인관리 - 반송
	  * @author 강신영
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="updateGoodsConfirmReject.do", method=RequestMethod.POST)
	public Map<String, Object> updateGoodsConfirmReject(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		
		String uniqueids = request.getParameter("uniqueids");
		String[] uniqueidArray = uniqueids.split(",");
		String REG_DATE = null;
		String SEQ = null;
		
		Map<String, Object> paramMap = null;
		Map<String, Object> resultDataMap = null;
		int updateCnt = 0;
		
		for(int i=0; i<uniqueidArray.length; i++) {
			paramMap = new HashMap<String, Object>();
			REG_DATE = uniqueidArray[i].split("_")[0];
			SEQ = uniqueidArray[i].split("_")[1];
			paramMap.put("REG_DATE",REG_DATE);
			paramMap.put("SEQ",SEQ);
			paramMap.put("PROGRM", "updateGoodsConfirmReject");
			paramMap.put("EMP_NO", emp_no);
			
			resultDataMap = goodsInformationService.updateGoodsConfirmReject(paramMap);
			if(resultDataMap.get("RESULT_MSG").equals("SAVE_SUCCESS")) {
				++updateCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("INS_SUCCESS")) {
				++updateCnt;
			} else if(resultDataMap.get("RESULT_MSG").equals("DEL_SUCCESS")) {
				++updateCnt;
			} else {
			}
		}
		
		if(uniqueidArray.length == updateCnt) {
			resultMap.put("resultRowCnt", updateCnt);
		} else {
			String errMesage = messageSource.getMessage("error.common.sqlError", new Object[1], commonUtil.getDefaultLocale());
			String errCode = "1999";
			resultMap = commonUtil.getErrorMap(errMesage, errCode);
		}
		
		return resultMap;
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 저울상품관리
	  * @author 최지민
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="goodsBalanceManagement.sis", method=RequestMethod.POST)
	public ModelAndView goodsBalanceManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "goodsBalanceManagement");
		return mav;
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 저울상품관리 - 저울상품 그룹 조회(Head)
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value = "getGoodsBalanceList.do", method = RequestMethod.POST)
	public Map<String, Object> getGoodsBalanceList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = goodsInformationService.getGoodsBalanceList(paramMap);
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
	/**
	  * 기준정보관리 - 상품관리 - 저울상품관리 - 저울상품 목록 조회(Detail)
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value = "getGoodsBalanceDetailList.do", method = RequestMethod.POST)
	public Map<String, Object> getGoodsBalanceDetailList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> gridDataList = goodsInformationService.getGoodsBalanceDetailList(paramMap);
		resultMap.put("gridDataList", gridDataList);
		
		return resultMap;
	}
	/**
	  * 기준정보관리 - 상품관리 - 저울상품관리 - 저울상품 그룹 저장(Head)
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="SaveBalanceList.do", method=RequestMethod.POST)
	public Map<String, Object> SaveBalanceList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String ORGN_CD = empSessionDto.getOrgn_cd();
		String RESP_USER = empSessionDto.getEmp_no();
		String CUSER = empSessionDto.getEmp_no();
		String MUSER = empSessionDto.getEmp_no();
		String CPROGRM = "SaveBalanceList";
		String MPROGRM = "SaveBalanceList";
		String SCALE_CD = "";
		String SCALE_NM = "";
		String USE_YN = "";
	
		Map<String, Object> LastBalanceInfo = new HashMap<String, Object>();
		Map<String, Object> InfoParam = new HashMap<String, Object>();
	
		int insertResult = 0;
		int deleteResult = 0;
		int updateResult = 0;
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			if(dhtmlxParamMapList.get(i).get("CRUD").equals("C")){
				ORGN_CD = dhtmlxParamMapList.get(i).get("ORGN_CD").toString();
				SCALE_NM = dhtmlxParamMapList.get(i).get("SCALE_NM").toString();
				USE_YN = dhtmlxParamMapList.get(i).get("USE_YN").toString();
				
				InfoParam.put("ORGN_CD", ORGN_CD);
				LastBalanceInfo = goodsInformationService.getBalanceInfoCheck(InfoParam); 
				if(LastBalanceInfo == null) {
					SCALE_CD = Integer.toString(100);
				} else {
					SCALE_CD = Integer.toString(Integer.parseInt(LastBalanceInfo.get("SCALE_CD").toString()) + 1);
				}
				paramMap.put("ORGN_CD", ORGN_CD);
				paramMap.put("SCALE_CD", SCALE_CD);
				paramMap.put("SCALE_NM", SCALE_NM);
				paramMap.put("USE_YN", USE_YN);
				paramMap.put("CUSER", CUSER);
				paramMap.put("CPROGRM", CPROGRM);
				paramMap.put("RESP_USER", RESP_USER);
				
				insertResult = goodsInformationService.addBalanceMaster(paramMap);
				
			} else if(dhtmlxParamMapList.get(i).get("CRUD").equals("D")) {
				SCALE_CD = dhtmlxParamMapList.get(i).get("SCALE_CD").toString();
				ORGN_CD = dhtmlxParamMapList.get(i).get("ORGN_CD").toString();
				paramMap.put("SCALE_CD", SCALE_CD);
				paramMap.put("ORGN_CD", ORGN_CD);
				
				deleteResult = goodsInformationService.deleteBalanceMaster(paramMap);
				
			} else if(dhtmlxParamMapList.get(i).get("CRUD").equals("U")) {
				SCALE_NM = dhtmlxParamMapList.get(i).get("SCALE_NM").toString();
				USE_YN = dhtmlxParamMapList.get(i).get("USE_YN").toString();
				SCALE_CD = dhtmlxParamMapList.get(i).get("SCALE_CD").toString();
				ORGN_CD = dhtmlxParamMapList.get(i).get("ORGN_CD").toString();
				paramMap.put("SCALE_NM", SCALE_NM);
				paramMap.put("USE_YN", USE_YN);
				paramMap.put("SCALE_CD", SCALE_CD);
				paramMap.put("ORGN_CD", ORGN_CD);
				paramMap.put("MUSER", MUSER);
				paramMap.put("MPROGRM", MPROGRM);
			
				updateResult = goodsInformationService.updateBalanceMaster(paramMap);
			}
		}
		return resultMap;
	}

	/**
	  * 기준정보관리 - 상품관리 - 저울상품관리 - 저울상품 추가(Detail)
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getBalanceDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getBalanceDetailList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("gridDataList", goodsInformationService.getBalanceDetailList(paramMap));
		return resultMap;
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 저울상품관리 - 저울상품 저장(Detail)
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="saveBalanceDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> saveBalanceDetailList(HttpServletRequest request, String SALE_PRICE) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String ORGN_CD = empSessionDto.getOrgn_cd();
		String CUSER = empSessionDto.getEmp_no();
		String MUSER = empSessionDto.getEmp_no();
		String CPROGRM = "saveBalanceDetailList";
		String MPROGRM = "saveBalanceDetailList";
		String SCALE_CD = "";
		String BCD_CD = "";
		String GOODS_NO = "";
		String USE_YN = "";
		int ORDR = 0;
		
		Map<String, Object> LastBalanceDetailInfo = new HashMap<String, Object>();
		Map<String, Object> detailInfoParam = new HashMap<String, Object>();
		
		int insertResult = 0;
		int deleteResult = 0;
		int updateResult = 0;
		
		for(int i = 0 ; i < dhtmlxParamMapList.size(); i++) {
			if(dhtmlxParamMapList.get(i).get("CRUD").equals("C")){
				ORGN_CD = dhtmlxParamMapList.get(i).get("ORGN_CD").toString();
				SCALE_CD = dhtmlxParamMapList.get(i).get("SCALE_CD").toString();
				BCD_CD = dhtmlxParamMapList.get(i).get("BCD_CD").toString();
				GOODS_NO = dhtmlxParamMapList.get(i).get("GOODS_NO").toString();
				USE_YN = dhtmlxParamMapList.get(i).get("USE_YN").toString();
				
				detailInfoParam.put("ORGN_CD", ORGN_CD);
				detailInfoParam.put("SCALE_CD", SCALE_CD);
				LastBalanceDetailInfo = goodsInformationService.getBalanceDetailinfoCheck(detailInfoParam);
				if(LastBalanceDetailInfo == null){
					ORDR = 1;
					} else {
						ORDR = Integer.parseInt(LastBalanceDetailInfo.get("ORDR").toString()) + 1;
					}
				
				paramMap.put("SCALE_CD", SCALE_CD);
				paramMap.put("ORGN_CD", ORGN_CD);
				paramMap.put("BCD_CD", BCD_CD);
				paramMap.put("USE_YN", USE_YN);
				paramMap.put("GOODS_NO", GOODS_NO);
				paramMap.put("ORDR", ORDR);
				paramMap.put("CUSER", CUSER);
				paramMap.put("CPROGRM", CPROGRM);
				
				insertResult = goodsInformationService.addBalanceDetailGoods(paramMap);
						
			}else if(dhtmlxParamMapList.get(i).get("CRUD").equals("D")) {
				BCD_CD = dhtmlxParamMapList.get(i).get("BCD_CD").toString();
				paramMap.put("BCD_CD", BCD_CD);
							
				deleteResult = goodsInformationService.deleteBalanceDetailGoods(paramMap);
						
			}else if(dhtmlxParamMapList.get(i).get("CRUD").equals("U")) {
				BCD_CD = dhtmlxParamMapList.get(i).get("BCD_CD").toString();
				USE_YN = dhtmlxParamMapList.get(i).get("USE_YN").toString();
				
				paramMap.put("BCD_CD", BCD_CD);
				paramMap.put("USE_YN", USE_YN);
				paramMap.put("MUSER", MUSER);
				paramMap.put("MPROGRM", MPROGRM);
						
				updateResult = goodsInformationService.updateBalanceDetailGoods(paramMap);
			}
		} 
	return resultMap;
	}
	
	/**
	 * 기준정보관리 - 상품관리 - 퇴출상품관리
	 * @author 최지민
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="goodsExitManagement.sis", method=RequestMethod.POST)
	public ModelAndView goodsExitManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "goodsExitManagement");
		return mav;
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 퇴출상품관리 조회 
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getGoodsExitList.do", method=RequestMethod.POST)
	public Map<String, Object> getGoodsExitList(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> categoryMap = new HashMap<String, Object>();
		
		String GRUP_TOP_CD = "";
		String GRUP_MID_CD = "";
		String GRUP_BOT_CD = "";
		
		categoryMap = goodsInformationService.getGoodsExitListTMB(paramMap);
		if(categoryMap != null) {
			GRUP_TOP_CD = categoryMap.get("GRUP_TOP_CD").toString();
			GRUP_MID_CD = categoryMap.get("GRUP_MID_CD").toString();
			GRUP_BOT_CD = categoryMap.get("GRUP_BOT_CD").toString();
		}
		else {
			GRUP_TOP_CD = "ALL";
			GRUP_MID_CD = "0";
			GRUP_BOT_CD = "0";
		}
		
		paramMap.put("GRUP_TOP_CD", GRUP_TOP_CD);
		paramMap.put("GRUP_MID_CD", GRUP_MID_CD);
		paramMap.put("GRUP_BOT_CD", GRUP_BOT_CD);
		
		List<Map<String, Object>> getGoodsExitList = goodsInformationService.getGoodsExitList(paramMap);
		resultMap.put("gridDataList", getGoodsExitList);
	
		return resultMap;
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 퇴출상품관리 저장
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="updateGoodsExitList.do", method=RequestMethod.POST)
	public Map<String, Object> updateGoodsExitList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String MUSER = empSessionDto.getEmp_no();
		String MPROGRM = "updateGoodsExitList";
		String GOODS_STATE =  "";
		String BCD_M_CD =  "";
		String BCD_CD =  "";
		
		int resultRowCnt = 0;
		
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		for(int i = 0 ; i < dhtmlxParamMapList.size(); i++){
			GOODS_STATE = dhtmlxParamMapList.get(i).get("GOODS_STATE").toString();
			BCD_M_CD = dhtmlxParamMapList.get(i).get("BCD_M_CD").toString();
			BCD_CD = dhtmlxParamMapList.get(i).get("BCD_CD").toString();
			
			paramMap.put("MUSER", MUSER);
			paramMap.put("MPROGRM", MPROGRM);
			paramMap.put("GOODS_STATE", GOODS_STATE);
			paramMap.put("BCD_M_CD", BCD_M_CD);
			paramMap.put("BCD_CD", BCD_CD);
			
			resultRowCnt = goodsInformationService.updateGoodsExitList(paramMap);
		}
		return resultMap;
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리
	  * @author 한정훈
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="resbarcodeManagement.sis", method=RequestMethod.POST)
	public ModelAndView resbarcodeManagement(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "resbarcodeManagement");
		return mav;
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 헤더 조회
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@ResponseBody
	@RequestMapping(value="getresbarcodeHeaderList.do", method=RequestMethod.POST)
	public Map<String, Object> getresbarcodeHeaderList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("getresbarcodeHeaderList paramMap >>>> " + paramMap);
		List<Map<String, Object>> getresbarcodeHeaderList = goodsInformationService.getresbarcodeHeaderList(paramMap);
		resultMap.put("gridDataList", getresbarcodeHeaderList);
		
		return resultMap;
	}
	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 디테일 조회
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@RequestMapping(value="getresbarcodeDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getresbarcodeDetailList(HttpServletRequest request, @RequestParam Map<String, String> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("getresbarcodeDetailList paramMap >>>> " + paramMap);
		List<Map<String, Object>> getresbarcodeDetailList = goodsInformationService.getresbarcodeDetailList(paramMap);
		resultMap.put("gridDataList", getresbarcodeDetailList);
		
		return resultMap;
	}
	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 바코드 업로드
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@ResponseBody
	@RequestMapping(value="getRESBCDInfo.do", method=RequestMethod.POST)
	public Map<String, Object> getRESBCDInfo(@RequestBody Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//logger.debug("getRESBCDInfo paramMap >>>> " + paramMap);
		List<Map<String, Object>> getRESBCDInfo = goodsInformationService.getRESBCDInfo(paramMap);
		resultMap.put("gridDataList", getRESBCDInfo);
		
		return resultMap;
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 바코드 저장
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@ResponseBody
	@RequestMapping(value="insertRESBCD.do", method=RequestMethod.POST)
	public Map<String, Object> insertRESBCD(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int resultRowCnt = goodsInformationService.insertRESBCD((List<Map<String, Object>>) paramMap.get("listMap"));
		resultMap.put("resultRowCnt", resultRowCnt);
	
		return resultMap;
	}
	
	@ResponseBody
	@RequestMapping(value="updateGoodsFileGrupNo.do", method=RequestMethod.POST)
	public Map<String, Object> updateGoodsFileGrupNo(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		goodsInformationService.updateGoodsFileGrupNo(paramMap);
		return resultMap;
	}
}
	 