package com.samyang.winplus.sis.pda.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.login.controller.LoginController;
import com.samyang.winplus.common.system.login.service.LoginService;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.model.LoginDto;
import com.samyang.winplus.common.system.util.CommonUtil;

@RestController
public class PDA_Contoller extends BaseController {

	private final Logger logger = LoggerFactory.getLogger(LoginController.class);

	@Autowired
	private LoginService loginService;
	
	@Autowired
	private MessageSource messageSource;
	
	
	
	/**
	  * 로그인 처리 Ajax
	  * @author 조승현
	  * @param loginDto
	  * @param request
	  * @return Map<String, Object>
	  */
	@RequestMapping(value="/sis/pda/login.do", method=RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String loginAjax(HttpServletRequest request, @RequestBody LoginDto loginDto) throws SQLException, Exception {
		
		//logger.debug("PDA loginDto : " + loginDto);
		
//		String headerKey = null;
//		for(Enumeration<String> headerName = request.getHeaderNames(); headerName.hasMoreElements();) {
//			headerKey = headerName.nextElement();
//			//logger.debug(headerKey + " : " + request.getHeader(headerKey));
//		}

		/* 클라이언트 IP 가져오기 */
		String client_ip = CommonUtil.getClientIpAddr(request);
        loginDto.setLogin_atpt_ip(client_ip);
		Object result = loginService.loginTry(loginDto); //로그인 시도
		
		String message = "";
		String result_cd = "";
		String[] messageParam = new String[1];
		
		Map<String,Object> resultMap = new HashMap<String,Object>();
		
		if(result instanceof EmpSessionDto) { 											// 정상 로그인
			EmpSessionDto empSessionDto = (EmpSessionDto) result;
			if(empSessionDto.getResult_cd() != null) { 									// 특이사항이 있을때
				result_cd = ((LoginDto) result).getResult_cd();
				if(result_cd.equals("-1005")) {											// 비밀번호 초기화 상태 변경 필요
					message = "info.common.system.login.initPassword";
					message = messageSource.getMessage(message, messageParam, commonUtil.getDefaultLocale());
				}
			}else { 																	// 특이사항 없을떄
				//로직없음
			}
			
			resultMap.put("RESULT", "OK");
			resultMap.put("MESSAGE", message);
			resultMap.put("ORGN_DIV_CD", empSessionDto.getOrgn_div_cd());
			resultMap.put("ORGN_DIV_NM", empSessionDto.getOrgn_div_nm());
			if(empSessionDto.getOrgn_delegate_cd() != null && !empSessionDto.getOrgn_delegate_cd().equals("")) {
				resultMap.put("ORGN_CD", empSessionDto.getOrgn_delegate_cd());
				resultMap.put("ORGN_NM", empSessionDto.getOrgn_delegate_nm());
			}else {
				resultMap.put("ORGN_CD", empSessionDto.getOrgn_cd());
				resultMap.put("ORGN_NM", empSessionDto.getOrgn_nm());
			}
			resultMap.put("USER_NM", empSessionDto.getEmp_nm());
			
		}else {  // 로그인 실패
			
			result_cd = ((LoginDto) result).getResult_cd();
			if(result_cd.equals("-1001")) {																	//존재하지 않는 사용자
				message = "error.common.system.login.noUser";
			}else if(result_cd.equals("-1002")) {															//비밀번호 오류 횟수 초과
				message = "error.common.system.login.exceedPwdCnt";
				messageParam[0] = String.valueOf(((LoginDto) result).getPassword_error_limit());
			}else if(result_cd.equals("-1003")) {															//비밀번호 오류
				message = "error.common.system.login.incorrectPwd";
			}else if(result_cd.equals("-1004")) {															//비밀번호 만료
				message = "error.common.system.authority.expiredPassword";
			}else {
				message = "error.common.system.login.etcError";
			}
			
			message = messageSource.getMessage(message, messageParam, commonUtil.getDefaultLocale());
			
			resultMap.put("RESULT", "FAIL");
			resultMap.put("MESSAGE", message);
			
		}
		//logger.debug("PDA 리턴 값 : " + writeValueAsString(resultMap).toString());
		return writeValueAsString(resultMap);
	}
	
}
