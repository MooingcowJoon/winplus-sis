package com.samyang.winplus.common.system.index.controller;

import java.net.InetAddress;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.system.base.controller.BaseController;
import com.samyang.winplus.common.system.index.service.IndexService;
import com.samyang.winplus.common.system.model.EmpSessionDto;

/** 
 * 인덱스 컨트롤러  
 * @since 2016.11.07
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.11.07 / 김종훈 / 신규 생성
 *********************************************
 */
@RestController
public class IndexController extends BaseController {

	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	IndexService indexService;
	
	@Value("${datasource.url}")
	private String dbUrl;

	@Value("${servername.name}")
	private String serverName;
	
	/**
	  * Root
	  * @author 김종훈
	  * @param request
	  * @param response
	  * @return ModelAndView
	 * @throws Exception 
	  */
	@RequestMapping(value="/", method=RequestMethod.GET)
	public ModelAndView root(HttpServletRequest request, HttpServletResponse response) throws Exception{
		if(logger.isDebugEnabled()){
			//logger.debug("==================root start =========================");
		}
		ModelAndView mav = new ModelAndView();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String empNo = "";
		if(empSessionDto == null){
			response.sendRedirect("/login.sis"); 
	   	} else {
	   		empNo = empSessionDto.getEmp_no();
	   	}
		
		//왼쪽 메뉴 목록에 숨겨진 표시
		InetAddress inet= InetAddress.getLocalHost();
    	String iNetHostAddress = inet.getHostAddress();
    	//logger.debug("serverName : "+serverName);
		String svrStr = "";
		if ("local".equals(serverName)){
			svrStr = "[LOCAL_"+iNetHostAddress+"]";
		}else if ("dev".equals(serverName)){
			svrStr = "[DEV_"+iNetHostAddress+"]";
		}else if ("real".equals(serverName)){
			svrStr = "[REAL_"+iNetHostAddress+"]";
		}
		
		//logger.debug("svrStr : "+svrStr);
		mav.addObject("svrStr", svrStr);	
		mav.addObject("EMP_NO", empNo);	
		mav.setViewName("index");
		return mav;
	}
	
	/**
	  * index.sis 페이지
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	 * @throws Exception 
	 * @throws SQLException 
	  */
	@SuppressWarnings("unused")
	@RequestMapping(value="/index.sis")
	public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception{
		if(logger.isDebugEnabled()){
			//logger.debug("==================index start =========================");
		}
		ModelAndView mav = new ModelAndView();
		EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
		String empNo = "";
		if(empSessionDto == null){
			response.sendRedirect("/login.sis"); 
	   	} else {
	   		empNo = empSessionDto.getEmp_no();
	   	}

		//왼쪽 메뉴 목록에 숨김 IP 용도
		InetAddress inet= InetAddress.getLocalHost();
    	String iNetHostAddress = inet.getHostAddress();
    	//logger.debug("serverName : "+serverName);
		String svrStr = "";
		if ("local".equals(serverName)){
			svrStr = "[LOCAL_"+iNetHostAddress+"]";
		}else if ("dev".equals(serverName)){
			svrStr = "[DEV_"+iNetHostAddress+"]";
		}else if ("real".equals(serverName)){
			svrStr = "[REAL_"+iNetHostAddress+"]";
		}
		
		//logger.debug("svrStr : "+svrStr);
		mav.addObject("svrStr", svrStr);	
		mav.setViewName("index");
		return mav;
	}		
	
	/**
	  * Home - 화면 조회
	  * @author 김종훈
	  * @param request
	  * @return ModelAndView
	  * @throws Exception 
	  * @throws SQLException 
	  */
	@RequestMapping(value="/home.sis", method=RequestMethod.POST) 
	public ModelAndView home(HttpServletRequest request) throws SQLException, Exception{
		ModelAndView mav = new ModelAndView();
		mav.setViewName("home");
		return mav;
	}
	
	/**
	  * 헬스체크 - 빈페이지
	  * @author 조승현
	  * @param request
	  * @return ModelAndView
	  * @throws Exception 
	  * @throws SQLException 
	  */
	@RequestMapping(value="/healthcheck.do") 
	public String healthcheck(HttpServletRequest request) throws SQLException, Exception{
		int chk = indexService.getHealthcheck();
		return ""+chk;
	}

}
