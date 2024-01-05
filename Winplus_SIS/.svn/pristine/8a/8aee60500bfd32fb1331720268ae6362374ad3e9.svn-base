package com.samyang.winplus.common.system.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @Class : LoofUtilObject.java
 * @Description : 
 * @Modification Information  
 * 
 *   수정일          수정자                내용
 * -----------     ----------      ----------------------
 * 2019. 9. 24.      조승현              최초생성
 * 
 * @author 조승현
 * @since 2019. 9. 24.
 * @version 1.0
 */
public class LoofUtilObject {

	public LoofInterface loofInterface;
	
	public int columnCount;
	public int cutSize;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	public void loofBigListMap(List<Map<String,Object>> listMap, LoofInterface loofInterface) {
		this.loofInterface = loofInterface;
		int listSize = listMap.size();
		
		try {
			if(listSize > 0) {
				columnCount = listMap.get(0).keySet().size();
				cutSize = 2000/columnCount;
				
				if(listSize > cutSize) {
					int startIndex = 0;
					int loofCount = (listSize/cutSize) + 1;
					int lastListSize = listSize%cutSize;
					for(int i=0; i<loofCount; i++) {
						if(i == loofCount-1) {//마지막
							loofInterface.exec(listMap.subList(startIndex, startIndex+lastListSize));
						}else {
							loofInterface.exec(listMap.subList(startIndex, startIndex+cutSize));
							startIndex += cutSize;
						}
					}
				}else {
					loofInterface.exec(listMap);
				}
			}
		}catch (Exception e) {
			throw new LoofUtilObjectException(e.getMessage(),e);
		}
	}
	
	public void loofBigListMapByCRUD(Map<String,Object> map, LoofInterface loofInterface) {
		this.loofInterface = loofInterface;
		List<Map<String,Object>> c_listMap = (List<Map<String, Object>>) map.get("C");
//		List<Map<String,Object>> r_listMap = (List<Map<String, Object>>) map.get("R");
		List<Map<String,Object>> u_listMap = (List<Map<String, Object>>) map.get("U");
		List<Map<String,Object>> d_listMap = (List<Map<String, Object>>) map.get("D");
		
		if(c_listMap.size() > 0) {
			columnCount = c_listMap.get(0).keySet().size();
			cutSize = 2000/columnCount;
		}
//		else if(r_listMap.size() > 0) {
//			columnCount = r_listMap.get(0).keySet().size();
//			cutSize = 2000/columnCount;
//		}
		else if(u_listMap.size() > 0) {
			columnCount = u_listMap.get(0).keySet().size();
			cutSize = 2000/columnCount;
		}else if(d_listMap.size() > 0) {
			columnCount = d_listMap.get(0).keySet().size();
			cutSize = 2000/columnCount;
		}else {
			return;
		}
		
		int c_listSize = c_listMap.size();
		int c_startIndex = 0;
		int c_loofCount = (c_listSize/cutSize) + 1;
		int c_lastListSize = c_listSize%cutSize;
		
//		int r_listSize = r_listMap.size();
//		int r_startIndex = 0;
//		int r_loofCount = (r_listSize/cutSize) + 1;
//		int r_lastListSize = r_listSize%cutSize;
		
		
		int u_listSize = u_listMap.size();
		int u_startIndex = 0;
		int u_loofCount = (u_listSize/cutSize) + 1;
		int u_lastListSize = u_listSize%cutSize;
		
		
		int d_listSize = d_listMap.size();
		int d_startIndex = 0;
		int d_loofCount = (d_listSize/cutSize) + 1;
		int d_lastListSize = d_listSize%cutSize;
		
		int max_loofCount = 0;
		if(max_loofCount < c_loofCount) {
			max_loofCount = c_loofCount;
		}
//		else if(max_loofCount < r_loofCount) {
//			max_loofCount = r_loofCount;
//		}
		else if(max_loofCount < u_loofCount) {
			max_loofCount = u_loofCount;
		}else if(max_loofCount < d_loofCount) {
			max_loofCount = d_loofCount;
		}
		
		List<Map<String,Object>> c_part_listMap = null;
//		List<Map<String,Object>> r_part_listMap = null;
		List<Map<String,Object>> u_part_listMap = null;
		List<Map<String,Object>> d_part_listMap = null;
		
		try {
			for(int i=0; i<max_loofCount; i++) {
				if(i == c_loofCount-1) {
					c_part_listMap = c_listMap.subList(c_startIndex, c_startIndex+c_lastListSize);
				}else if(i > c_loofCount-1) {
					c_part_listMap = c_listMap.subList(0, 0);
				}else {
					c_part_listMap = c_listMap.subList(c_startIndex, c_startIndex+cutSize);
					c_startIndex += cutSize;
				}
				
	//			if(i == r_loofCount-1) {
	//				r_part_listMap = r_listMap.subList(r_startIndex, r_startIndex+r_lastListSize);
	//			}else if(i > r_loofCount-1) {
	//				r_part_listMap = r_listMap.subList(0, 0);
	//			}else {
	//				r_part_listMap = r_listMap.subList(r_startIndex, r_startIndex+cutSize);
	//				r_startIndex += cutSize;
	//			}
				
				if(i == u_loofCount-1) {
					u_part_listMap = u_listMap.subList(u_startIndex, u_startIndex+u_lastListSize);
				}else if(i > u_loofCount-1) {
					u_part_listMap = u_listMap.subList(0, 0);
				}else {
					u_part_listMap = u_listMap.subList(u_startIndex, u_startIndex+cutSize);
					u_startIndex += cutSize;
				}
				
				if(i == d_loofCount-1) {
					d_part_listMap = d_listMap.subList(d_startIndex, d_startIndex+d_lastListSize);
				}else if(i > d_loofCount-1) {
					d_part_listMap = d_listMap.subList(0, 0);
				}else {
					d_part_listMap = d_listMap.subList(d_startIndex, d_startIndex+cutSize);
					d_startIndex += cutSize;
				}
				
				loofInterface.exec(c_part_listMap,null,u_part_listMap,d_part_listMap);
			}
		}catch (Exception e) {
			throw new LoofUtilObjectException(e.getMessage(),e);
		}
		
	}
	
	public List<Map<String,Object>> selectAfterLoofBigList(List<String> list, LoofInterface loofInterface) {
		this.loofInterface = loofInterface;
		int listSize = list.size();
		
		List<Map<String,Object>> lm = new ArrayList<Map<String,Object>>();
		
		if(listSize > 0) {
			columnCount = 1;
			cutSize = 2000/columnCount;
			
			if(listSize > cutSize) {
				int startIndex = 0;
				int loofCount = (listSize/cutSize) + 1;
				int lastListSize = listSize%cutSize;
				for(int i=0; i<loofCount; i++) {
					if(i == loofCount-1) {//마지막
						lm.addAll((ArrayList<Map<String,Object>>) loofInterface.exec(list.subList(startIndex, startIndex+lastListSize)));
					}else {
						lm.addAll((ArrayList<Map<String,Object>>) loofInterface.exec(list.subList(startIndex, startIndex+cutSize)));
						startIndex += cutSize;
					}
				}
			}else {
				lm.addAll((ArrayList<Map<String,Object>>) loofInterface.exec(list));
			}
		}
		return lm;
	}
	
	public List<Map<String,Object>> selectAfterLoofBigMapList(List<Map<String, Object>> list, LoofInterface loofInterface) {
		this.loofInterface = loofInterface;
		int listSize = list.size();
		
		List<Map<String,Object>> lm = new ArrayList<Map<String,Object>>();
		
		if(listSize > 0) {
			columnCount = list.get(0).keySet().size();
			cutSize = 2000/columnCount;
			
			if(listSize > cutSize) {
				int startIndex = 0;
				int loofCount = (listSize/cutSize) + 1;
				int lastListSize = listSize%cutSize;
				for(int i=0; i<loofCount; i++) {
					if(i == loofCount-1) {//마지막
						lm.addAll((ArrayList<Map<String,Object>>) loofInterface.exec(list.subList(startIndex, startIndex+lastListSize)));
					}else {
						lm.addAll((ArrayList<Map<String,Object>>) loofInterface.exec(list.subList(startIndex, startIndex+cutSize)));
						startIndex += cutSize;
					}
				}
			}else {
				lm.addAll((ArrayList<Map<String,Object>>) loofInterface.exec(list));
			}
		}
		return lm;
	}
}
