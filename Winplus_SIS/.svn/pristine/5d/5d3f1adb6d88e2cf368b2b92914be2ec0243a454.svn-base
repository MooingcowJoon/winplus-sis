package com.samyang.winplus.common.system.error.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

/** 
 * 오류 컨트롤러  
 * @since 2016.10.24
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.10.24	/ 김종훈 / 신규 생성
 *********************************************
 */  

@RequestMapping("/common/system/error")
@RestController
public class ErrorController {
	
	private final static String DEFAULT_PATH = "common/system/error";
	
	/**
	  * 404 Not Found
	  * @author 김종훈
	  * @param request
	  * @param response
	  * @return ModelAndView
	  */
	@RequestMapping("/notFound.sis")
	public ModelAndView notFound(HttpServletRequest request, HttpServletResponse response){		
		ModelAndView mav = new ModelAndView();		
		mav.setViewName(DEFAULT_PATH + "/notFound");
		return mav;
	}
	
	/**
	  * 405 Not Supported
	  * @author 김종훈
	  * @param request
	  * @param response
	  * @return ModelAndView
	  */
	@RequestMapping("/notSupported.sis")
	public ModelAndView notSupported(HttpServletRequest request, HttpServletResponse response){		
		ModelAndView mav = new ModelAndView();		
		mav.setViewName(DEFAULT_PATH + "/notSupported");
		return mav;
	}
	
	/**
	  * 500 Internal Server Error
	  * @author 김종훈
	  * @param request
	  * @param response
	  * @return ModelAndView
	  */
	@RequestMapping("/internalServerError.sis")
	public ModelAndView internalServerError(HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/internalServerError");
		return mav;
	}
	
	/**
	  * 기타 알 수 없는 오류
	  * @author 김종훈
	  * @param request
	  * @param response
	  * @return ModelAndView
	  */
	@RequestMapping("/unKnownError.sis")
	public ModelAndView unKnownError(HttpServletRequest request, HttpServletResponse response){
		Throwable throwable = (Throwable)request.getAttribute("javax.servlet.error.exception");
		String errMessage = "알 수 없는 오류";
		if(throwable != null) {
			if(throwable instanceof Exception){
				errMessage = ((Exception)throwable).getMessage();
			} else if(throwable instanceof Error){
				errMessage = ((Error)throwable).getMessage();
			}	
		}
		ModelAndView mav = new ModelAndView();
		mav.addObject("errMessage", errMessage);
		mav.setViewName(DEFAULT_PATH + "/unKnownError");
		return mav;
	}
}
