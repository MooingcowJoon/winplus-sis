package com.samyang.winplus.sis.standardInfo.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.sis.standardInfo.service.PresetService;

@RequestMapping("/sis/preset")
@RestController
public class PresetController extends BaseController {
	
	private final static String DEFAULT_PATH = "sis/standardInfo/goods";
	
	@Autowired
	PresetService PresetService;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	/**
	 * WpPreset - 프리셋관리
	 * @author 정혜원
	 * @param  request
	 * @return ModelAndView
	 */
	@RequestMapping(value="WpPreset.sis", method=RequestMethod.POST)
	public ModelAndView WpPreset(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "preset");
		return mav;
	}
	
	/**
	 * PresetManagement - 프리셋관리
	 * @author 정혜원
	 * @param  request
	 * @return ModelAndView
	 */
	@RequestMapping(value="PresetManagement.sis", method=RequestMethod.POST)
	public ModelAndView PresetManagement(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "PresetManagement");
		return mav;
	}
	
	
	@RequestMapping(value="getPresetGroupList.do", method=RequestMethod.POST)
	public Map<String, Object> getPresetGroupList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String ORGN_CD = request.getParameter("ORGN_CD");
		
		paramMap.put("ORGN_CD", ORGN_CD);
		
		try{
			List<Map<String, Object>> gridDataList = PresetService.getPresetGroupList(paramMap);
			resultMap.put("gridDataList", gridDataList);
		}catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
	@RequestMapping(value="getPresetDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> getPresetDetailList(HttpServletRequest request) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String ORGN_DIV_CD = request.getParameter("orgn_div_cd");
		String ORGN_CD = request.getParameter("orgn_cd"); // 접속한 마트코드 불러오는걸로 수정 필요
		String PRST_CD = request.getParameter("prst_cd");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
		paramMap.put("ORGN_CD", ORGN_CD);
		paramMap.put("PRST_CD", PRST_CD);
		
		try{
			List<Map<String, Object>> gridDataList = PresetService.getPresetDetailList(paramMap);
			//logger.debug("gridDataList PresetDetail >> " + gridDataList);
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
	 * SavePresetList - 프리셋관리
	 * @author 정혜원
	 * @param  request
	 * @return ModelAndView
	 */
	@RequestMapping(value="SavePresetList.do", method=RequestMethod.POST)
	public Map<String, Object> SavePresetList(HttpServletRequest request) throws SQLException, Exception {
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String EMP_NO = empSessionDto.getEmp_no();
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);
		
		//logger.debug("dhtmlxParammapList >> " + dhtmlxParamMapList);
		
		String ORGN_CD = request.getParameter("ORGN_CD");
		String PRST_CD = "";
		String PRST_NM = "";
		int ORDR = 0;
		String USE_YN = "";
		String CPROGRM = "SavePresetList";
		String MPROGRM = "SavePresetList";
		String CUSER = EMP_NO; //로그인 아이디 정보 가져와서 넣기 (처음등록시에)
		String MUSER = EMP_NO; //로그인 아이디 정보 가져와서 넣기
		Map<String, Object> LastPresetInfo = new HashMap<String, Object>();
		Map<String, Object> InfoParam = new HashMap<String, Object>();
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		int insertResult = 0;
		int deleteResult = 0;
		int updateResult = 0;
		
		
		for(int i = 0 ; i < dhtmlxParamMapList.size() ; i++) {
			ORGN_CD = dhtmlxParamMapList.get(i).get("ORGN_CD").toString();
			if(dhtmlxParamMapList.get(i).get("CRUD").equals("C")){
			
				InfoParam.put("ORGN_CD", ORGN_CD);
				LastPresetInfo = PresetService.getPresetinfoCheck(InfoParam); //추가작업할시 다음번호따기위함
				
				if(LastPresetInfo == null) {
					ORDR = 1;
					PRST_CD = Integer.toString(100);
				} else {
					ORDR = Integer.parseInt(LastPresetInfo.get("ORDR").toString()) + 1;
					PRST_CD = Integer.toString(Integer.parseInt(LastPresetInfo.get("PRST_CD").toString()) + 1);
				}
				
				
				PRST_NM = dhtmlxParamMapList.get(i).get("PRST_NM").toString();
				//logger.debug("PRST_NM >>> " + PRST_NM);
				USE_YN = dhtmlxParamMapList.get(i).get("USE_YN").toString();
				
				paramMap.put("ORGN_CD", ORGN_CD);
				paramMap.put("PRST_CD", PRST_CD);
				paramMap.put("PRST_NM", PRST_NM);
				paramMap.put("ORDR", ORDR);
				paramMap.put("RESP_USER", EMP_NO);
				paramMap.put("USE_YN", USE_YN);
				paramMap.put("CPROGRM", CPROGRM);
				paramMap.put("CUSER", CUSER);
				
				//logger.debug("paramMap >>>> " + paramMap);
				
				insertResult = PresetService.AddPresetMaster(paramMap);
				
			} else if(dhtmlxParamMapList.get(i).get("CRUD").equals("D")) {
				PRST_CD = (dhtmlxParamMapList.get(i).get("PRST_CD")).toString();
				paramMap.put("PRST_CD", PRST_CD);
				paramMap.put("ORGN_CD", ORGN_CD);
				deleteResult = PresetService.deletePresetMaster(paramMap);
			} else if(dhtmlxParamMapList.get(i).get("CRUD").equals("U")) {
				PRST_NM = (dhtmlxParamMapList.get(i).get("PRST_NM")).toString();
				USE_YN = dhtmlxParamMapList.get(i).get("USE_YN").toString();
				PRST_CD = (dhtmlxParamMapList.get(i).get("PRST_CD")).toString();
				
				paramMap.put("PRST_NM", PRST_NM);
				paramMap.put("USE_YN", USE_YN);
				paramMap.put("MUSER", MUSER);
				paramMap.put("MPROGRM", MPROGRM);
				paramMap.put("PRST_CD", PRST_CD);
				paramMap.put("ORGN_CD", ORGN_CD);
				
				updateResult = PresetService.updatePresetMaster(paramMap);
			}
		}
		return resultMap;
	}
	
	/**
	 * getDetailGoodsList - 프리셋관리
	 * @author 정혜원
	 * @param  request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getDetailGoodsList.do", method=RequestMethod.POST)
	public Map<String, Object> getDetailGoodsList(HttpServletRequest request, @RequestParam(value="BCD_CD_LIST") List<String> BCD_CD_LIST, @RequestParam(value="ORGN_CD") String ORGN_CD) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = null;
		List<Map<String, Object>> paramMapList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> resultMapList = new ArrayList<Map<String, Object>>();
		
		for(int i = 0 ; i < BCD_CD_LIST.size() ; i++){
			paramMap = new HashMap<String, Object>();
			paramMap.put("BCD_CD", BCD_CD_LIST.get(i));
			paramMap.put("ORGN_CD", ORGN_CD);
			paramMapList.add(paramMap);
		}
		
		try{
			resultMapList = PresetService.getDetailGoodsList(paramMapList);
			resultMap.put("gridDataList", resultMapList);
		} catch(SQLException e){
			resultMap = commonUtil.getErrorMap(e);
		} catch(Exception e){
			resultMap = commonUtil.getErrorMap(e);
		}
		return resultMap;
	}
	
	/**
	 * getPasteDetailGoodsList - 프리셋관리
	 * @author 정혜원
	 * @param  request
	 * @return Map<String, Object>
	 */
	@RequestMapping(value="getPasteDetailGoodsList.do", method=RequestMethod.POST)
	public Map<String, Object> getPasteDetailGoodsList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		logger.debug("RequestBody >> " + paramMap);
		
		resultMap.put("gridDataList", PresetService.getPasteDetailGoodsList(paramMap));
		return resultMap;
	}
	
	/**
	 * SavePresetDetailList - 프리셋관리
	 * @author 정혜원
	 * @param  request
	 * @return ModelAndView
	 */
	@RequestMapping(value="SavePresetDetailList.do", method=RequestMethod.POST)
	public Map<String, Object> SavePresetDetailList(HttpServletRequest request) throws SQLException, Exception {
		int rowCount = 0;
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> dhtmlxParamMapList = commonUtil.getDhtmlXParamMapList(request);	
		Map<String, Object> detailInfoParam = new HashMap<String, Object>();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String EMP_NO = empSessionDto.getEmp_no();
		
		
		rowCount = dhtmlxParamMapList.size();
		
		String ORGN_CD = "";   // 프리셋상세마트코드
		String ORGN_DIV_CD = ""; // 프리셋상세조직코드
		String PRST_CD = ""; //프리셋상세프리셋코드
		String BCD_CD = ""; //프리셋상세상품바코드
		String GOODS_CD = ""; //프리셋상세상품코드
		int ORDR = 0; //프리셋상세순번
		int prsd_no = 0; // 프리셋상세상품나열순서
		String USE_YN = ""; // 프리셋상세상품사용유무
		String CUSER = EMP_NO; // 프리셋상세상품등록자
		String MUSER = EMP_NO; // 프리셋상세상품수정자
		String CPROGRM = "SavePresetDetailList";
		String MPROGRM = "SavePresetDetailList";
		Map<String, Object> LastPresetDetailInfo = new HashMap<String, Object>();
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		int insertResult = 0;
		int deleteResult = 0;
		int updateResult = 0;
		
		try{
			for(int i = 0 ; i < rowCount ; i++) {
				ORGN_CD = dhtmlxParamMapList.get(i).get("ORGN_CD").toString();
				PRST_CD = dhtmlxParamMapList.get(i).get("PRST_CD").toString();
				BCD_CD = dhtmlxParamMapList.get(i).get("BCD_CD").toString();
				ORGN_DIV_CD = dhtmlxParamMapList.get(i).get("ORGN_DIV_CD").toString();
				GOODS_CD = dhtmlxParamMapList.get(i).get("GOODS_NO").toString();
				USE_YN = dhtmlxParamMapList.get(i).get("USE_YN").toString();
				
				paramMap.put("ORGN_CD", ORGN_CD);
				paramMap.put("PRST_CD", PRST_CD);
				paramMap.put("ORGN_DIV_CD", ORGN_DIV_CD);
				paramMap.put("BCD_CD", BCD_CD);
				paramMap.put("USE_YN", USE_YN);
				paramMap.put("CUSER", CUSER);
				paramMap.put("MUSER", MUSER);
				paramMap.put("ORDR", ORDR);
				paramMap.put("GOODS_CD", GOODS_CD);
				paramMap.put("CPROGRM", CPROGRM);
				
				if(dhtmlxParamMapList.get(i).get("CRUD").equals("C")){
					
					detailInfoParam.put("ORGN_CD", ORGN_CD);
					detailInfoParam.put("PRST_CD", PRST_CD);
					
					LastPresetDetailInfo = PresetService.getPresetDetailinfoCheck(detailInfoParam);//이거는 추가작업할때 다음번호따기위함
					if(LastPresetDetailInfo == null){
						ORDR = 1;
					} else {
						ORDR = Integer.parseInt(LastPresetDetailInfo.get("ORDR").toString()) + 1;
					}
					paramMap.put("ORDR", ORDR);
					
					insertResult = PresetService.AddPresetDetailGoods(paramMap);
					
				} else if(dhtmlxParamMapList.get(i).get("CRUD").equals("D")) {
					paramMap.put("BCD_CD", BCD_CD);
					paramMap.put("PRST_CD", PRST_CD);
					deleteResult = PresetService.deletePresetDetailGoods(paramMap);
				} else if(dhtmlxParamMapList.get(i).get("CRUD").equals("U")) {
					MUSER = EMP_NO; // 수정한 직원(담당자)명 적용 수정필요
					
					paramMap.put("BCD_CD", BCD_CD);
					paramMap.put("PRST_CD", PRST_CD);
					paramMap.put("USE_YN", USE_YN);
					paramMap.put("MUSER", MUSER);
					paramMap.put("MPROGRM", MPROGRM);
					
					updateResult = PresetService.updatePresetDetailGoods(paramMap);
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
	  * 메뉴명
	  * @author 정혜원
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value = "getSearchMarketCD.do", method = RequestMethod.POST)
	public Map<String, Object> getSearchMarketCD(HttpServletRequest request) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String emp_no = empSessionDto.getEmp_no();
		String ORGN_CD = empSessionDto.getOrgn_cd();
		paramMap.put("EMP_NO", emp_no);
		paramMap.put("ORGN_CD", ORGN_CD);
		//logger.debug("paramMap >>> " + paramMap);
		
		try {
			String Cur_Mk_Cd = PresetService.getSearchMarketCD(paramMap).get("ORGN_DELEGATE_CD").toString();
			resultMap.put("ORGN_DELEGATE_CD", Cur_Mk_Cd);
			
			if(Cur_Mk_Cd.equals("200006") ||Cur_Mk_Cd.equals("200007") ||Cur_Mk_Cd.equals("200008") 
					||Cur_Mk_Cd.equals("200009") ||Cur_Mk_Cd.equals("2000010") ||Cur_Mk_Cd.equals("200011") 
					||Cur_Mk_Cd.equals("200012") ||Cur_Mk_Cd.equals("200013")) {
				//logger.debug("매장 계정으로 들어옴");
				resultMap.put("ORGN_TYPE", "Y");
			} else {
				resultMap.put("ORGN_TYPE", "N");
			}
			//logger.debug("resultMap >>> "+resultMap);
		}catch(SQLException e) {
			resultMap = commonUtil.getErrorMap(e);
		}catch(Exception e) {
			resultMap = commonUtil.getErrorMap(e);
		}
		
		return resultMap;
	}
	
}
