package com.samyang.winplus.sis.code.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.sis.code.service.TableCodeService;

/**
 * @Class : TargetTableCodeController.java
 * @Description : 공통코드 테이블이 아닌
 * 				  특정 테이블 레코드를 이용하여 
 * 				  dhtmlx 콤보,라디오 등등 객체를 만들기위한
 * 				  데이터 리턴 컨트롤러
 * @Modification Information  
 * 
 *   수정일          수정자                내용
 * -----------     ----------      ----------------------
 * 2019. 8. 27.      조승현              최초생성
 * 
 * @author 조승현
 * @since 2019. 8. 27.
 * @version 1.0
 */
@RestController
@RequestMapping("/sis/code")
public class TableCodeController extends BaseController{
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final String DEFAULT_PATH = getDefaultPath(getClass());
	
	@Autowired
	private TableCodeService tableCodeService;

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description T_STD_TRML 테이블에서 로그인 유저의 해당 직영점의 포스 번호리스트 리턴
	 */
	@RequestMapping(value="/getPosNoList.do", method=RequestMethod.POST)
	public Map<String, Object> getPosNoList(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		Map <String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> detailCodeList = null;
		detailCodeList = tableCodeService.getPosNoList(paramMap);
		resultMap.put("detailCodeList", detailCodeList);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description T_STD_CARDCORP 테이블에서 카드발급사 리스트 리턴
	 */
	@RequestMapping(value="/getCardIssuerCorpList.do", method=RequestMethod.POST)
	public Map<String, Object> getCardIssuerCorpList(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		Map <String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> detailCodeList = null;
		detailCodeList = tableCodeService.getCardIssuerCorpList(paramMap);
		resultMap.put("detailCodeList", detailCodeList);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description T_STD_CARDCORP 테이블에서 카드매입사 리스트 리턴
	 */
	@RequestMapping(value="/getCardAcquirerCorpList.do", method=RequestMethod.POST)
	public Map<String, Object> getCardAcquirerCorpList(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		Map <String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> detailCodeList = null;
		detailCodeList = tableCodeService.getCardAcquirerCorpList(paramMap);
		resultMap.put("detailCodeList", detailCodeList);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 로그인한 사용자가 조회 할 수 있는 조직 구분 코드 리스트 리턴
	 */
	@RequestMapping(value="/getSearchableOrgnDivCdList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchableOrgnDivCdList(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		Map <String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> detailCodeList = null;
		detailCodeList = tableCodeService.getSearchableOrgnDivCdList(paramMap);
		resultMap.put("detailCodeList", detailCodeList);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 로그인한 사용자가 조회 할 수 있는 조직 코드 리스트
	 */
	@RequestMapping(value="/getSearchableOrgnCdList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchableOrgnCdList(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		Map <String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> detailCodeList = null;
		detailCodeList = tableCodeService.getSearchableOrgnCdList(paramMap);
		resultMap.put("detailCodeList", detailCodeList);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 게시물 게시범위 가져오기
	 */
	@RequestMapping(value="/getBoardPublishScope.do", method=RequestMethod.POST)
	public Map<String, Object> getBoardPublishScope(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		Map <String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> detailCodeList = tableCodeService.getBoardPublishScope(paramMap);
		resultMap.put("detailCodeList", detailCodeList);
		return resultMap;
	}

	
	/**
	 * @author 손경락
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 게시물 게시범위 가져오기
	 */
	@RequestMapping(value="/getOrgnCustomerList.do", method=RequestMethod.POST)
	public Map<String, Object> getOrgnCustomerList(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		Map <String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> detailCodeList = tableCodeService.getOrgnCustomerList(paramMap);
		resultMap.put("detailCodeList", detailCodeList);
		return resultMap;
	}
	
	/**
	 * @author 한정훈
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 판매 유형에 따른 상세 판매 유형 가져오기
	 */
	@RequestMapping(value="/getSaleRegTypeList.do", method=RequestMethod.POST)
	Map<String, Object> getSaleRegTypeList(@RequestParam Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> detailCodeList = tableCodeService.getSaleRegTypeList(paramMap);
		resultMap.put("detailCodeList", detailCodeList);
		return resultMap;
	}
	
	/**
	 * @author 최지민
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 기준가그룹 가져오기
	 */
	@RequestMapping(value="/getSearchStdPriceCdList.do", method=RequestMethod.POST)
	public Map<String, Object> getSearchStdPriceCdList(@RequestParam Map<String,Object> paramMap) throws SQLException, Exception {
		Map <String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> detailCodeList = tableCodeService.getSearchStdPriceCdList(paramMap);
		resultMap.put("detailCodeList", detailCodeList);
		return resultMap;
	}

}
