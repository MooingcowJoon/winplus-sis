package com.samyang.winplus.common.system.model;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

public class ConvertMap extends HashMap<String, Object> implements Serializable{
	
	private static final long serialVersionUID = -5089675497039205340L;
	
	private static Date date = new Date();
	private static SimpleDateFormat d = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private static SimpleDateFormat d_ym = new SimpleDateFormat("yyyy-MM");
	private static SimpleDateFormat d_d = new SimpleDateFormat("yyyy-MM-dd");
	private static StringBuilder sb = new StringBuilder();
	
	@Override
	public Object put(String key, Object value) {
		String upperKey = "";
		if(value != null){
			if(value instanceof java.sql.Timestamp){
				date.setTime(((java.sql.Timestamp) value).getTime());
				upperKey = key.toUpperCase();
				if(upperKey.indexOf("!YM") > -1){
					value = d_ym.format(date);
				}else if(upperKey.indexOf("!D") > -1){
					value = d_d.format(date);
				}else{
					value = d.format(date);
				}
			}else if(value instanceof java.lang.String && ((java.lang.String) value).length() == 6){
				upperKey = key.toUpperCase();
				if(upperKey.indexOf("!YM") > -1){
					value = sb.append(value).insert(4, "-").toString();
					sb.setLength(0);
				}
			}
		}
		return super.put(key, value);
	}
	
}
