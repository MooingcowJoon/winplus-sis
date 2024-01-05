package com.samyang.winplus.common.system.security.xss;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public class XSSRequestWrapper extends HttpServletRequestWrapper {

	public XSSRequestWrapper(HttpServletRequest request) {
		super(request);
	}
	
	@Override
	public String[] getParameterValues(String parameter) {
		String[] values = super.getParameterValues(parameter);
		if (values==null)  {
			return null;
		}
		int count = values.length;
		String[] encodedValues = new String[count];
		
		for (int i = 0; i < count; i++) {
			encodedValues[i] = XSSConverter.cleanXSS(values[i]);
		}		
		return encodedValues;
	}
	
	@Override
	public String getParameter(String parameter) {
		String value = super.getParameter(parameter);
		if (value == null) {
			return null;
		}
		return XSSConverter.cleanXSS(value);
	}
	
	@Override
    public String getHeader(String name) {
    	String value = super.getHeader(name);
    	if (value == null) {
    		return null;
    	}
    	return XSSConverter.cleanXSS(value);
    }
    
    @Override
    public Map<String, String[]> getParameterMap(){
    	Map<String, String[]> originMap = super.getParameterMap();
    	if(originMap == null || originMap.keySet().size() == 0) {
    		return originMap;
    	}
    	
    	Map<String, String[]> returnMap = new HashMap<String, String[]>();
    	
    	for(String key : originMap.keySet()){
    		String[] value = originMap.get(key);
    		if(value == null || value.length == 0) {
    			returnMap.put(key, value);
    		}
    		else {
    			String[] newValue = getNewString(value.length);
    			for(int i = 0 ; i < value.length; i++){
    				newValue[i] = XSSConverter.cleanXSS(value[i]);
    			}
    			returnMap.put(key, newValue);
    		}
    	}
    	
		return returnMap;
    }
    
    public String[] getNewString(int num){
		return new String[num];
	}
}
