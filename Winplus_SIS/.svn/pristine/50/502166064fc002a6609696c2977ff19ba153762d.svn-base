package com.samyang.winplus.sis.standardInfo.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.sis.basic.service.BasicService;

@RequestMapping("/sis/standardInfo")
@RestController
public class CreditCardCompanyManagementController {

	private final static String DEFAULT_PATH = "sis/standardInfo";
	
	
	/**
	  * 기초관리 - 상품분류
	  * @author 조승현
	  * @param request
	  * @return ModelAndView
	  */
	@RequestMapping(value="productDiv.sis", method=RequestMethod.POST)
	public ModelAndView noticeBoard(HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "productDiv");
		return mav;
	}
}
