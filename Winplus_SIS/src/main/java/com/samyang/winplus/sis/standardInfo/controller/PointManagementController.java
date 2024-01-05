package com.samyang.winplus.sis.standardInfo.controller;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.samyang.winplus.common.board.service.BoardService;
import com.samyang.winplus.common.system.base.controller.BaseController;

@RequestMapping("/sis/standardInfo/point")
@RestController
public class PointManagementController extends BaseController{
	
private final static String DEFAULT_PATH = "sis/standardInfo";
	
	@Autowired
	BoardService boardService;
	
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	/**
	 * 기준정보관리 - 포인트관리
	 * @author 정혜원
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping(value="pointManagement.sis", method=RequestMethod.POST)
	public ModelAndView pointManagement(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName(DEFAULT_PATH + "/" + "pointManagement");
		return mav;
	}
}
