package com.samyang.winplus.sis.member.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.sis.member.service.MemberService;

@RestController
@RequestMapping("/sis/member")
public class MemberController extends BaseController {

	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	private final String DEFAULT_PATH = getDefaultPath(getClass());

	@Autowired
	private MemberService memberService;
	
	@Autowired
	private MessageSource messageSource;
	

	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @param mav
	 * @return mav
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 페이지 호출
	 */
	@RequestMapping(value="memberManagement.sis", method=RequestMethod.POST)
	public ModelAndView memberManagement(HttpServletRequest request, @RequestParam Map<String, String> paramMap, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "memberManagement");
		return mav;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return String
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 리스트 가져오기
	 */
	@ResponseBody
	@RequestMapping(value="getMemberList.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.getMemberList(paramMap));
		return resultMap;
	}
	

	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 정보 조회
	 */
	@ResponseBody
	@RequestMapping(value="getMemberInfo.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberInfo(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("dataMap", memberService.getMemberInfo(paramMap));
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 그룹 리스트
	 */
	@ResponseBody
	@RequestMapping(value="getMemberGroupComboList.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberGroupComboList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("comboList", memberService.getMemberGroupComboList(paramMap));
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 등록,수정,삭제
	 */
	@ResponseBody
	@RequestMapping(value="crudMemberInfo.do", method=RequestMethod.POST)
	public Map<String,Object> crudMemberInfo(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		//logger.debug("paramMap >> " + paramMap);
		Map<String,Object> resultMap = new HashMap<String,Object>();
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String empNo = empSessionDto.getEmp_no();
		paramMap.put("LOGIN_USER", empNo);

		resultMap.put("result", memberService.crudMemberInfo(paramMap));
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 거래내역조회
	 */
	@ResponseBody
	@RequestMapping(value="getTransactionHistory.do", method=RequestMethod.POST)
	public Map<String,Object> getTransactionHistory(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.getTransactionHistory(paramMap));
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 과세 면세 금액 보기
	 */
	@ResponseBody
	@RequestMapping(value="getTaxExemptAmount.do", method=RequestMethod.POST)
	public Map<String,Object> getTaxExemptAmount(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.getTaxExemptAmount(paramMap));
		return resultMap;
	}

	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원의 베스트 상품 조회
	 */
	@ResponseBody
	@RequestMapping(value="getMemberBestGoodsList.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberBestGoodsList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.getMemberBestGoodsList(paramMap));
		return resultMap;
	}

	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @param mav
	 * @return ModelAndView
	 * @throws SQLException
	 * @throws Exception
	 * @description 베스트회원 페이지
	 */
	@RequestMapping(value="bestMember.sis", method=RequestMethod.POST)
	public ModelAndView bestMember(HttpServletRequest request, @RequestParam Map<String, String> paramMap, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "bestMember");
		return mav;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 베스트 회원 조회
	 */
	@ResponseBody
	@RequestMapping(value="getBestMemberList.do", method=RequestMethod.POST)
	public Map<String,Object> getBestMemberList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.getBestMemberList(paramMap));
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원의 월별 추이 조회
	 */
	@ResponseBody
	@RequestMapping(value="getMemberMonthlyTrend.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberMonthlyTrend(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		return memberService.getMemberMonthlyTrend(paramMap);
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원의 상품 지정가 등록, 수정, 삭제
	 */
	@ResponseBody
	@RequestMapping(value="crudMemberGoodsPrice.do", method=RequestMethod.POST)
	public Map<String,Object> crudMemberGoodsPrice(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		memberService.crudMemberGoodsPrice(paramMap);
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @param mav
	 * @return mav
	 * @throws SQLException
	 * @throws Exception
	 * @description 거래 원장 페이지 호출
	 */
	@RequestMapping(value="memberTransactionLedger.sis", method=RequestMethod.POST)
	public ModelAndView memberTransactionLedger(HttpServletRequest request, @RequestParam Map<String, String> paramMap, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "memberTransactionLedger");
		return mav;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 거래원장 리스트
	 */
	@ResponseBody
	@RequestMapping(value="getMemberTransactionLedgerList.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberTransactionLedgerList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.getMemberTransactionLedgerList(paramMap));
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원명으로 회원 검색
	 */
	@ResponseBody
	@RequestMapping(value="memberSearch.do", method=RequestMethod.POST)
	public Map<String,Object> memberSearch(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.memberSearch(paramMap));
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원유형 변경
	 */
	@ResponseBody
	@RequestMapping(value="updateMemberType.do", method=RequestMethod.POST)
	public Map<String,Object> updateMemberType(HttpServletRequest request, @RequestBody List<Map<String, Object>> paramListMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		memberService.updateMemberType(paramListMap);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 abc변경
	 */
	@ResponseBody
	@RequestMapping(value="updateMemberABC.do", method=RequestMethod.POST)
	public Map<String,Object> updateMemberABC(HttpServletRequest request, @RequestBody List<Map<String, Object>> paramListMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		memberService.updateMemberABC(paramListMap);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 상태 변경
	 */
	@ResponseBody
	@RequestMapping(value="updateMemberState.do", method=RequestMethod.POST)
	public Map<String,Object> updateMemberState(HttpServletRequest request, @RequestBody List<Map<String, Object>> paramListMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		memberService.updateMemberState(paramListMap);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 세금계산서 일괄발행 변경
	 */
	@ResponseBody
	@RequestMapping(value="updateMemberTaxYN.do", method=RequestMethod.POST)
	public Map<String,Object> updateMemberTaxYN(HttpServletRequest request, @RequestBody List<Map<String, Object>> paramListMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		memberService.updateMemberTaxYN(paramListMap);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 소액처리 변경
	 */
	@ResponseBody
	@RequestMapping(value="updateMemberChgAmtType.do", method=RequestMethod.POST)
	public Map<String,Object> updateMemberChgAmtType(HttpServletRequest request, @RequestBody List<Map<String, Object>> paramListMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		memberService.updateMemberChgAmtType(paramListMap);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @param mav
	 * @return mav
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원지정가 페이지 리턴
	 */
	@RequestMapping(value="memberDesignation.sis", method=RequestMethod.POST)
	public ModelAndView memberDesignation(HttpServletRequest request, @RequestParam Map<String, String> paramMap, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "memberDesignation");
		return mav;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 지정가 리스트 가져오기
	 */
	@ResponseBody
	@RequestMapping(value="getMemberDesignationList.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberDesignationList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.getMemberDesignationList(paramMap));
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @param mav
	 * @return mav
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 그룹 페이지 리턴
	 */
	@RequestMapping(value="memberGroupManagement.sis", method=RequestMethod.POST)
	public ModelAndView memberGroupManagement(HttpServletRequest request, @RequestParam Map<String, String> paramMap, ModelAndView mav) throws SQLException, Exception {
		mav.setViewName(DEFAULT_PATH + "memberGroupManagement");
		return mav;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원그룹 리스트 리턴
	 */
	@ResponseBody
	@RequestMapping(value="getMemberGroupList.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberGroupList(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.getMemberGroupList(paramMap));
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원그룹 CRUD
	 */
	@ResponseBody
	@RequestMapping(value="crudMemberGroup.do", method=RequestMethod.POST)
	public Map<String,Object> crudMemberGroup(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		memberService.crudMemberGroup(paramMap);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 그룹에 속해있는 회원 리스트 리턴
	 */
	@ResponseBody
	@RequestMapping(value="getMemberListInGroup.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberListInGroup(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.getMemberListInGroup(paramMap));
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원그룹에 회원들을 CRUD
	 */
	@ResponseBody
	@RequestMapping(value="crudMemberListInGroup.do", method=RequestMethod.POST)
	public Map<String,Object> crudMemberListInGroup(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		memberService.crudMemberListInGroup(paramMap);
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원도매가 가져오기
	 */
	@ResponseBody
	@RequestMapping(value="getMemberWSalePrice.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberWSalePrice(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.getMemberWSalePrice(paramMap));
		return resultMap;
	}
	
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원지정가 가져오기
	 */
	@ResponseBody
	@RequestMapping(value="getMemberGoodsPrice.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberGoodsPrice(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.getMemberGoodsPrice(paramMap));
		return resultMap;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 회원 변경 로그 조회
	 */
	@ResponseBody
	@RequestMapping(value="getMemberInfoLog.do", method=RequestMethod.POST)
	public Map<String,Object> getMemberInfoLog(HttpServletRequest request, @RequestBody Map<String, Object> paramMap) throws SQLException, Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("gridDataList", memberService.getMemberInfoLog(paramMap));
		return resultMap;
	}
	
}
