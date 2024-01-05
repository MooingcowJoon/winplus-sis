package com.samyang.winplus.common.system.security.xss;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.samyang.winplus.common.system.util.CommonUtil;


public class XSSFilter implements Filter {
	
	/* slf4j Logger */
	/* 필요할 때 사용 */
	private final Logger logger = LoggerFactory.getLogger(XSSFilter.class);

	@Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException { // 모든 요청(Request)에 대해서 이 부분이 실행된다.
		HttpServletRequest request = (HttpServletRequest)req;
		
		String urlStr = "";
		
		String uri = request.getRequestURL().toString();
		urlStr = "["+CommonUtil.getClientIpAddr(request)+"] "+uri;
		int imageUrl = uri.lastIndexOf(".gif") 
				+ uri.lastIndexOf(".png") 
				+ uri.lastIndexOf(".jpg") 
				+ uri.lastIndexOf("js") 
				+ uri.lastIndexOf("css") 
				+ uri.lastIndexOf("healthcheck.do");
		
		if(req instanceof MultipartHttpServletRequest){
			if(imageUrl == -6) {
				logger.info("XSSMultipartFilter URL : "+ urlStr); 
			}
			chain.doFilter(new XSSMultipartRequestWrapper(request), res);
		} else {
			if(imageUrl == -6) {
				logger.info("XSSFilter URL : "+ urlStr); 
			}
	        chain.doFilter(new XSSRequestWrapper(request), res);
		}
    }
 
    @Override
    public void init(FilterConfig config) throws ServletException { // 초기화할 때 실행되는 부분
    	// 초기화할 때 실행되는 부분
    }
    
 
    @Override
    public void destroy() {
        // Destory
    }
}

