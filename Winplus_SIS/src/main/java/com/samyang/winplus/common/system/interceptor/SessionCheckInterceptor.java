package com.samyang.winplus.common.system.interceptor;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.util.CommonUtil;

/** 
 * 세션 확인 인터셉터
 * @since 2016.11.07
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.11.07 / 김종훈 / 신규 생성
 *********************************************
 */
public class SessionCheckInterceptor extends HandlerInterceptorAdapter {
	
	/* 필요한 경우 사용 */
	static Logger logger = LoggerFactory.getLogger(SessionCheckInterceptor.class);
	
	@Autowired
	CommonUtil commonUtil;
	
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
        	String xmlHttpRequest = request.getHeader("x-requested-with");
        	String currentUri = request.getRequestURI();        	
            int lastDotIndex = currentUri.lastIndexOf(".");
            String uriExt = "";
            if(lastDotIndex > -1 && currentUri.length() > 0){
            	uriExt = currentUri.substring(lastDotIndex);            	
            }
            /**
             * SessionCheck Exception 적용합니다.
             * bumseok.oh
             * /egovRDCT/src/com/goodc/erp/system/authority/interceptor/SessionCheckInterceptor.java
             */
            //logger.debug("======================================== SessionCheckInterceptor");
            List<String> exceptionArr = new ArrayList<String>();
            exceptionArr.add(".api");
            
            Iterator<String> itr = exceptionArr.iterator();
            
            boolean ifException = false;
            String s = "";
            while(itr.hasNext()){
            	s = itr.next();
            	
            	if(uriExt.equals(s)){
            		ifException = true;
            	}
            }
            
            EmpSessionDto empSessionDto = commonUtil.getEmpSessionDto(request);
            

                if(!ifException && empSessionDto == null){
                	
                	//String noSessionPath = "/system/authority/noSession.sis";
                	String noSessionPath = "/login.sis?message=nosession";
//                	String noSessionPath = "/";
                	
                	//logger.debug("==================================================================================");
                	//logger.debug("==================================================================================");
                	//logger.debug("==================================================================================");
                	//logger.debug("==================================================================================");
                	//logger.debug("==================================================================================");
                	//logger.debug("==================================================================================");
                	//logger.debug("uriExt============================================>"+ uriExt);
                	//logger.debug("xmlHttpRequest============================================>"+ xmlHttpRequest);
                	//logger.debug("==================================================================================");
                	//logger.debug("==================================================================================");
                	//logger.debug("==================================================================================");
                	//logger.debug("==================================================================================");
                	//logger.debug("==================================================================================");
                	//logger.debug("==================================================================================");
                	
                	if(".do".equals(uriExt) || (xmlHttpRequest != null && "XMLHttpRequest".equals(xmlHttpRequest))){
                		noSessionPath = "/common/system/authority/noSession.do";
//                		noSessionPath = "/login.sis?message=nosession";
                	}
                	RequestDispatcher dispatcher = request.getRequestDispatcher(noSessionPath);
            		dispatcher.forward(request, response);
            		//response.sendRedirect("/login.sis?message=nosession");
                    return false;
                }
            
        } catch (Exception e) {
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
