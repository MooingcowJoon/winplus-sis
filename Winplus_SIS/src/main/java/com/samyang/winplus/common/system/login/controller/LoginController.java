package com.samyang.winplus.common.system.login.controller;

import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.employee.service.EmpService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.login.service.LoginService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.model.LoginDto;
import com.samyang.winplus.common.system.property.PropertyManagement;
import com.samyang.winplus.common.system.util.CommonUtil;

/** 
 * 로그인 컨트롤러  
 * @since 2019.11.27
 * @author 조승현
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 
 *********************************************
 */
@RestController
public class LoginController extends BaseController {

	/* Log4j Logger */
	private final Logger logger = LoggerFactory.getLogger(LoginController.class);

	@Autowired
	private LoginService loginService;
	
	@Autowired
	private PropertyManagement propertyManagement;
	
	@Autowired
	private EmpService empService;
	
	@Autowired
	private MessageSource messageSource;
	
	@Value("${chunho.sso.mm.web.security.authorizedGroups}")
	private List<String> authorizedGroups = Collections.emptyList();
	
	/**
	  * 로그인 페이지 조회
	  * @author 조승현
	  * @param request
	  * @param response
	  * @return ModelAndView
	  */
	@RequestMapping(value="/login.sis", method=RequestMethod.GET)
	public ModelAndView login(HttpServletRequest request, HttpServletResponse response) throws SQLException, Exception{
		//logger.debug("************************ Start login.sis ... ");
		ModelAndView mav = new ModelAndView();
		
		String logOutStr = request.getParameter("logout");
		//logger.debug("logOutStr : "+logOutStr);
		
		//로그아웃 요청 스트링이 있을 시에 로그아웃
		if (logOutStr != null && "Y".equals(logOutStr)){
			logout(request, response);
			mav.setViewName("logout");
			return mav;
		}
	
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
//		String emp_no = "";									삭제예정
		
		//세션이 존재할때
		if(empSessionDto != null){
			//logger.debug("************************ go to index.sis...");
			//logger.debug("로그인 정보 : ");
			//logger.debug(empSessionDto.toString());
	
//			emp_no = empSessionDto.getEmp_no();				삭제예정
//			mav.addObject("EMP_NO", emp_no);				삭제예정
			mav.setViewName("index");	// login ->index 
			return mav;
	   	}
		
		
		mav.setViewName("login");
		return mav;
	}
	
	/**
	  * 로그인 처리 Ajax
	  * @author 조승현
	  * @param loginDto
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="/login.do", method=RequestMethod.POST)
	public Map<String, Object> login(HttpServletRequest request, @ModelAttribute LoginDto loginDto) throws SQLException, Exception {
		//logger.debug("========================login.do========================");
		//logger.debug("========================loginDto========================");
		//logger.debug(loginDto.toString());
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		HttpSession httpSession = request.getSession(true);
		httpSession.invalidate();
		httpSession = request.getSession(true);

		/* 클라이언트 IP 가져오기 */
		String client_ip = CommonUtil.getClientIpAddr(request);
        loginDto.setLogin_atpt_ip(client_ip);
		Object result = loginService.loginTry(loginDto); //로그인 시도
		
		
		String message = "";
		String result_cd = "";
		String[] messageParam = new String[1];
		if(result instanceof EmpSessionDto) { // 정상 로그인
			EmpSessionDto empSessionDto = (EmpSessionDto) result;
			if(empSessionDto.getResult_cd() != null) { 	// 특이사항이 있을때
				result_cd = empSessionDto.getResult_cd();
				if(result_cd.equals("-1005")) {											//비밀번호 초기화 상태 변경 필요
					message = "info.common.system.login.initPassword";
				}
				empSessionDto.setMessage(messageSource.getMessage(message, messageParam, commonUtil.getDefaultLocale()));
			}else { 																	// 특이사항 없을때
				//로직없음
			}
			
			/*  디폴트로 페이지 설정 */
			String defaultPage = propertyManagement.getProperty("system.default.defaultPath");
			
			//logger.debug(result.toString());
			
			//세션변경 사용을 위한 오리지널 사원 정보 세팅
			empSessionDto.setEmp_no_oriz(empSessionDto.getEmp_no());
			empSessionDto.setEmp_nm_oriz(empSessionDto.getEmp_nm());
			/* 세션 저장 */
			httpSession.setAttribute("empSessionDto", result);
			//logger.debug("로그인 성공");
			//logger.debug(result.toString());
			resultMap.put("defaultPage", defaultPage);
			
			return resultMap;
			
		}else {  // 로그인 실패
			
			//멘트 동일하게끔 표시
			result_cd = ((LoginDto) result).getResult_cd();
			if(result_cd.equals("-1001")) {																	//존재하지 않는 사용자
//				message = "error.common.system.login.noUser";
				message = "error.common.system.login.incorrectPwd";
			}else if(result_cd.equals("-1002")) {															//비밀번호 오류 횟수 초과
//				message = "error.common.system.login.exceedPwdCnt";
				message = "error.common.system.login.incorrectPwd";
				messageParam[0] = String.valueOf(((LoginDto) result).getPassword_error_limit());
			}else if(result_cd.equals("-1003")) {															//비밀번호 오류
//				message = "error.common.system.login.incorrectPwd";
				message = "error.common.system.login.incorrectPwd";
			}else if(result_cd.equals("-1004")) {															//비밀번호 만료
//				message = "error.common.system.authority.expiredPassword";
				message = "error.common.system.login.incorrectPwd";
			}else {
				message = "error.common.system.login.etcError";
			}
			
			message = messageSource.getMessage(message, messageParam, commonUtil.getDefaultLocale());
			return commonUtil.getErrorMap(message, result_cd);
			
		}
		
	}


	/**
	 * @author 조승현
	 * @param loginDto
	 * @param request
	 * @param response
	 * @throws SQLException
	 * @throws Exception
	 * @description 본래 자기의 세션으로 돌아감
	 */
	@RequestMapping(value="/sessionOut.sis", method=RequestMethod.GET)
	public void sessionOut(@ModelAttribute LoginDto loginDto, HttpServletRequest request, HttpServletResponse response) throws SQLException, Exception {
		
		HttpSession httpSession = request.getSession(false);
		if(httpSession != null){
			EmpSessionDto firstEmpSessionDto = (EmpSessionDto) httpSession.getAttribute("empSessionDto");
			
			String firstEmpNoOriz = firstEmpSessionDto.getEmp_no_oriz();
			String firstEmpNmOriz = firstEmpSessionDto.getEmp_nm_oriz();
			String firstLoginId = firstEmpSessionDto.getLogin_id();
			String firstSiteDivCd = firstEmpSessionDto.getSite_div_cd();
			
			loginDto.setEmp_no(firstEmpNoOriz); // 세션 조회용 사번만 세팅
			loginDto.setSite_div_cd(firstSiteDivCd); // 세션 조회용 사번만 세팅
			
			EmpSessionDto empSessionDto = loginService.getEmpSessionDto(loginDto);
			empSessionDto.setEmp_no_oriz(firstEmpNoOriz);
			empSessionDto.setEmp_nm_oriz(firstEmpNmOriz);
			empSessionDto.setLogin_id(firstLoginId);
			empSessionDto.setSite_div_cd(firstSiteDivCd);
			
			/* 클라이언트 IP 가져오기 */
			String login_atpt_ip = "";
			login_atpt_ip = CommonUtil.getClientIpAddr(request);
	        loginDto.setLogin_atpt_ip(login_atpt_ip);
	        
	        httpSession.setAttribute("empSessionDto", empSessionDto);

			//logger.debug(empSessionDto.toString());
		}
	
		response.sendRedirect("login.sis");
		
	}
	

	/**
	 * @author 조승현
	 * @param request
	 * @param response
	 * @throws Exception
	 * @description 로그아웃 진행
	 */
	@RequestMapping(value="/logout.sis", method=RequestMethod.GET)
	 public void logout(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		
		if(empSessionDto == null){
			response.sendRedirect("login.sis");
			return;
		}
		
		String emp_no = "";
		String login_id = "";
		if(empSessionDto != null) {
			login_id = empSessionDto.getLogin_id();
			emp_no = empSessionDto.getEmp_no();
		}
		
		//로그아웃 로그 저장
		LoginDto loginDto = new LoginDto();
		String login_client_ip = CommonUtil.getClientIpAddr(request);
		loginDto.setLogin_id(login_id);
		loginDto.setEmp_no(emp_no);
		loginDto.setInOut("OUT");
		loginDto.setResult_cd("0");
		loginDto.setLogin_atpt_ip(login_client_ip);
		loginService.saveLoginTryLog(loginDto);
		
		HttpSession session = request.getSession(true);
		session.invalidate();
		
		response.sendRedirect("login.sis"); // url -> login.sis
	 }

	/**
	 * @author 조승현
	 * @param loginDto
	 * @param request
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 * @description 세션 변경
	 */
	@RequestMapping(value="/loginChange.do", method=RequestMethod.POST)
	public Map<String, Object> loginChange(@ModelAttribute LoginDto loginDto, HttpServletRequest request) throws SQLException, Exception {

		String errMessage = null;
		String errCode = "0"; /* 오류 코드 : 0 -  정상 */
		String[] errMessageParam = new String[1];
		
		//해당 사원번호로 세션변경 요청 받음
		String change_to_emp_no = request.getParameter("EMP_NO");
		//logger.debug("change_to_emp_no : "+ change_to_emp_no);
		
		HttpSession httpSession = request.getSession(false);
		
		EmpSessionDto beforeEmpSessionDto = null;
		
		boolean isNotExistSession = false;
		if(httpSession == null){
			isNotExistSession = true;
		}else {
			beforeEmpSessionDto = commonUtil.getEmpSessionDto(request);
			
			if(beforeEmpSessionDto == null) {
				isNotExistSession = true;
			}
		}
		
		if(isNotExistSession) {
			errMessage = "error.common.system.authority.noSession";
			errCode = "noSession";
			errMessage = messageSource.getMessage(errMessage, errMessageParam, commonUtil.getDefaultLocale());
			return commonUtil.getErrorMap(errMessage, errCode);
		}
		
		
		String firstEmpNoOriz = beforeEmpSessionDto.getEmp_no_oriz();
		String firstEmpNmOriz = beforeEmpSessionDto.getEmp_nm_oriz();
		String firstLoginId = beforeEmpSessionDto.getLogin_id();
		String firstSiteDivCd = beforeEmpSessionDto.getSite_div_cd();
		
		//세션 변경 가능여부 체크용 파라미터 세팅
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("CHANGE_TO_EMP_NO", change_to_emp_no);
		paramMap.put("EMP_NO_ORIZ", firstEmpNoOriz);
		
		//현재 로그인되어있는 계정으로 변경할수 있는 세션인지 체크
		int check_result = empService.checkEmpLoginList(paramMap);
		
		EmpSessionDto afterSessionDto = null;
		if(check_result == 1){ //가능
			loginDto.setEmp_no(change_to_emp_no);
			loginDto.setSite_div_cd(firstSiteDivCd);
			afterSessionDto = loginService.getEmpSessionDto(loginDto);
			if (afterSessionDto == null) {
				errMessage = "error.common.system.authority.sessionChangingFail";
				errCode = "-1011";
				errMessage = messageSource.getMessage(errMessage, errMessageParam, commonUtil.getDefaultLocale());
				return commonUtil.getErrorMap(errMessage, errCode);
			}
			//새로운 세션객체에 이전 오리지날 사번 세팅
			afterSessionDto.setEmp_no_oriz(firstEmpNoOriz);
			afterSessionDto.setEmp_nm_oriz(firstEmpNmOriz);
			afterSessionDto.setSite_div_cd(firstSiteDivCd);
			afterSessionDto.setLogin_id(firstLoginId);
		}else{ //불가능
			errMessage = "error.common.system.authority.sessionChangeFail";
			errCode = "-1010";
			errMessage = messageSource.getMessage(errMessage, errMessageParam, commonUtil.getDefaultLocale());
			return commonUtil.getErrorMap(errMessage, errCode);
		}
		
		//logger.debug("변경 후 세션 객체");
		//logger.debug(afterSessionDto.toString());
		
		/*  디폴트로 페이지 설정 */
		String defaultPage = propertyManagement.getProperty("system.default.defaultPath");
	
		/* 세션 저장 */
		httpSession.setAttribute("empSessionDto", afterSessionDto);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("defaultPage", defaultPage);
	
		return resultMap;
	}
	
}
