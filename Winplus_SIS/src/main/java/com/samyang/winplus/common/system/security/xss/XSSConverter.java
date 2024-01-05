package com.samyang.winplus.common.system.security.xss;

public class XSSConverter {	
	
	public static String cleanXSS(String value){
		String returnValue = value;		
		returnValue = returnValue.replaceAll("<", "＜").replaceAll(">", "＞");
		returnValue = returnValue.replaceAll("&amp;", "＆");
		returnValue = returnValue.replaceAll("＆amp;", "＆");
		returnValue = returnValue.replaceAll("&", "＆");
		/*returnValue = returnValue.replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");*/
		returnValue = returnValue.replaceAll("'", "&#39;");
		returnValue = returnValue.replaceAll("eval\\((.*)\\)", "");
		returnValue = returnValue.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
		returnValue = returnValue.replaceAll("<script", "");
		return returnValue;
	}
	
	public static String reverseXSS(String value){
		String returnValue = value;		
		returnValue = returnValue.replaceAll("&lt;", "<").replaceAll("&gt;", ">");
		returnValue = returnValue.replaceAll("&#39;", "'");
		/*returnValue = returnValue.replaceAll("&#40;", "(").replaceAll("&#41;", ")");*/
		return returnValue;
	}
}
