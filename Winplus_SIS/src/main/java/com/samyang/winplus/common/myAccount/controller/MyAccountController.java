package com.samyang.winplus.common.myAccount.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.myAccount.service.MyAccountService;
import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.model.EmpSessionDto;

@RestController
@RequestMapping("/common/myAccount")
public class MyAccountController extends BaseController{
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	private final String DEFAULT_PATH = getDefaultPath(getClass());
	
	@Autowired
	private MyAccountService myAccountService;

	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @param mav
	 * @return mav
	 * @throws SQLException
	 * @throws Exception
	 * @description 
	 */
	@RequestMapping(value = "myAccount.sis", method = RequestMethod.POST)
	public ModelAndView myAccount(HttpServletRequest request, @RequestParam Map<String, String> paramMap, ModelAndView mav){
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		mav.addObject("ID", empSessionDto.getLogin_id());
		mav.addObject("NAME", empSessionDto.getEmp_nm());
		mav.addObject("MBTLNUM", empSessionDto.getMbtlnum());
		mav.addObject("EMAIL", empSessionDto.getEmail());
		mav.setViewName(DEFAULT_PATH + "myAccount");
		return mav;
	}
	
	/**
	 * @author 조승현
	 * @param request
	 * @param paramMap
	 * @return Map<String,Object>
	 * @description 비밀번호 변경
	 */
	@ResponseBody
	@RequestMapping(value = "passwordChange.do", method = RequestMethod.POST)
	public Map<String,Object> passwordChange(HttpServletRequest request, @RequestBody Map<String,Object> paramMap){
		Map<String,Object> resultMap = new HashMap<String,Object>();
		
		EmpSessionDto empSessionDto= commonUtil.getEmpSessionDto(request);
		
		String ori_emp_no = empSessionDto.getEmp_no_oriz();
		String emp_no = empSessionDto.getEmp_no();
		
		
		if(!ori_emp_no.equals(emp_no)) {
			resultMap.put("result", "타인의 비밀번호는 변경 할 수 없습니다.");
			return resultMap;
		}
		
		
		String LOGIN_ID = empSessionDto.getLogin_id();
		paramMap.put("LOGIN_ID", LOGIN_ID);
		String result = myAccountService.passwordChange(paramMap);
		resultMap.put("result", result);
		return resultMap;
	}
}
