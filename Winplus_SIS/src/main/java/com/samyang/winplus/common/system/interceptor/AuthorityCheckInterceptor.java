package com.samyang.winplus.common.system.interceptor;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.samyang.winplus.common.system.authority.service.SystemAuthorityService;
import com.samyang.winplus.common.system.config.EnvironmentInitializer;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.model.MenuDto;
import com.samyang.winplus.common.system.model.ScreenDto;
import com.samyang.winplus.common.system.util.CommonUtil;

/** 
 * 권한 확인 인터셉터
 * @since 2016.11.07
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.11.07 / 김종훈 / 신규 생성
 *********************************************
 */
public class AuthorityCheckInterceptor extends HandlerInterceptorAdapter {

	
	/* 필요한 경우 사용 */
	static Logger logger = LoggerFactory.getLogger(AuthorityCheckInterceptor.class);
	
	@Autowired
	CommonUtil commonUtil;
	
	@Autowired
	SystemAuthorityService systemAuthorityService;
	
	/**
	  * 처리 전 호출
	  * @author 김종훈
	  * @param request
	  * @param response
	  * @param response
	  * @return boolean
	  * @exception Exception
	  */
	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        try {       	
        	boolean isAuth = false;
        	boolean isAjax = false;
        	
        	String currentUri = request.getRequestURI();
            int lastDotIndex = currentUri.lastIndexOf(".");
        	String uriExt = currentUri.substring(lastDotIndex);        	
        	String xmlHttpRequest = request.getHeader("x-requested-with");
        	String currentMenuCd = request.getParameter("currentMenu_cd");     
        	
        	EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
    		String empNo = empSessionDto.getEmp_no();
    		String loginAtptIp = CommonUtil.getClientIpAddr(request);
    		
    		String empNoOriz = empSessionDto.getEmp_no_oriz();
        	
        	String crud = request.getParameter("CRUD");
            
            if(".do".equals(uriExt) || xmlHttpRequest != null && "XMLHttpRequest".equals(xmlHttpRequest)){
            	isAjax = true;
            }else if(".portal".equals(uriExt) || xmlHttpRequest != null && "XMLHttpRequest".equals(xmlHttpRequest)){
            	isAjax = true;
            }
            //logger.debug("currentUri : "+currentUri);
            //logger.debug("xmlHttpRequest : "+xmlHttpRequest);
            //logger.debug("currentMenu_cd : "+currentMenuCd);
            //logger.debug("crud : "+crud);
            //logger.debug("emp_no : "+empNo);
            //logger.debug("login_atpt_ip : "+loginAtptIp);
            //logger.debug("empNoOriz : "+empNoOriz);
            
            Map<String, Object> logParamMap = new HashMap<String, Object>();
            
            String scrinPath = "";
        	if(currentUri != null){
        		scrinPath = currentUri;
        	}
        	
        	logParamMap.put("EMP_NO", empNo);
        	logParamMap.put("CONN_MENU_CD", currentMenuCd);
        	logParamMap.put("CONN_IP", loginAtptIp);
        	logParamMap.put("CONN_URI", scrinPath);
        	logParamMap.put("CRUD", crud);
        	logParamMap.put("REQUEST_WITH", xmlHttpRequest);
        	logParamMap.put("EMP_NO_ORIZ", empNoOriz);
            
        	systemAuthorityService.insertSystemConnLog(logParamMap);
            
            Map<String, Object> paramMap = new HashMap<String, Object>();

        	paramMap.put("SCRIN_PATH", scrinPath);
        	
            /* Ajax 별도 처리 필요 시 */
            if(isAjax){
            	isAuth = true;
            } else if(currentMenuCd != null && currentMenuCd.length() > 0 && lastDotIndex > -1 && currentUri.length() > 0){
            	String mainYn = request.getParameter("MAIN_YN");            	
            	paramMap.put("EMP_NO", empSessionDto.getEmp_no());
            	paramMap.put("MENU_CD", currentMenuCd);
            	paramMap.put("MAIN_YN", mainYn);
            	
            	MenuDto menuDto =  systemAuthorityService.getMenuDto(paramMap);
            	if(menuDto != null){
            		ScreenDto screenDto = systemAuthorityService.getScreenDto(paramMap);                	
            		/* ScreenDto 경로와 요청 경로가 같은지 확인 */
                	if(screenDto != null && screenDto.getScrin_path().equals(scrinPath)){             		
                		isAuth = true;
                		request.setAttribute("menuDto", menuDto);
            			request.setAttribute("screenDto", screenDto);
            			request.setAttribute("currentMenu_cd", currentMenuCd);
                	}
            	}
            }
            
            /* 공통화면인 경우 메뉴 권한과 상관 없이 사용 가능 */
            if(!isAuth){
            	ScreenDto screenDto = systemAuthorityService.getCommonScreenDto(paramMap);
        		/* ScreenDto 경로와 요청 경로가 같은지 확인 */
            	if(screenDto != null && screenDto.getScrin_path().equals(scrinPath)){             		
            		isAuth = true;
        			request.setAttribute("screenDto", screenDto);
            	}
            }

            if(!isAuth){
            	String noAuthPath = "/common/system/authority/noAuth.sis";
            	if(isAjax){
            		noAuthPath = "/common/system/authority/noAuth.do";
            	}
            	RequestDispatcher dispatcher = request.getRequestDispatcher(noAuthPath);
        		dispatcher.forward(request, response);
        		return false;
            }
        } catch (Exception e) {
        	if(EnvironmentInitializer.getServerType().equals("LOCAL")) {
        		e.printStackTrace();
        	}
            logger.error(e.toString());
            return false;
        }

        return true;
    }
 
	/**
	  * 처리 후 호출
	  * @author 김종훈
	  * @param request
	  * @param response
	  * @param response
	  * @param modelAndView
	  * @return void
	  * @exception Exception
	  */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
    	super.postHandle(request, response, handler, modelAndView);
    }
 
    /**
	  * 완료 후 호출
	  * @author 김종훈
	  * @param request
	  * @param response
	  * @param response
	  * @param Exception
	  * @return void
	  * @exception Exception
	  */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        super.afterCompletion(request, response, handler, ex);
    }
 
    /**
	  * 동시 처리 시작된 직후
	  * @author 김종훈
	  * @param request
	  * @param response
	  * @param handler
	  * @return void
	  * @exception Exception
	  */
    @Override
    public void afterConcurrentHandlingStarted(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        super.afterConcurrentHandlingStarted(request, response, handler);
    }
}
