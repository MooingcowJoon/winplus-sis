package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.order.dao.OrderSearchDao;

@Service("OrderSearchService")
public class OrderSearchServiceImpl implements OrderSearchService{
	
	@Autowired
	OrderSearchDao orderSearchDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public List<Map<String, Object>> getSearchBaljooList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getSearchBaljooList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getSearchOrderList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getSearchOrderList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getOrderManagement(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getOrderManagement(paramMap);
	}
		
	@Override
	public List<Map<String, Object>> getRequestOrderList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getRequestOrderList(paramMap);
	}	
	
	@Override
	public List<Map<String, Object>> getSecondOrderList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getSecondOrderList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getSearchOrderDetailList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getSearchOrderDetailList(paramMap);
	}

	@Override
	public List<Map<String, Object>> getGoodsTreeComboList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getGoodsTreeComboList(paramMap);
	}

	/**
	 * getGoodsTreeList    주문가능상품을 TREE형태로 데이터 조회( getGoodsCategoryTreeList 공통을 기반으로 신규작성 )
	 * 
	 * @author 손락
	 * @param paramMap
	 * @return Map<String, Object>
	 * @throws SQLException
	 * @throws Exception
	 */	
	@Override
	public Map<String, Object> getGoodsTreeList(Map<String, Object> paramMap)  throws SQLException, Exception {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<Map<String, Object>> categoryList = orderSearchDao.getGoodsTreeList(paramMap);
		
		List<Map<String, Object>> resultCategoryMapList = null;
		if(!categoryList.isEmpty()){
			resultCategoryMapList = new ArrayList<Map<String, Object>>();
			
			Map<String, Object> hashCategoryMap = new HashMap<String, Object>();
			
			String grup_cd = "";
			String grup_nm = "";
			String uni_key = "";
			String upper_uni_key = "";
			
			for(Map<String, Object> categoryMap : categoryList){
				grup_cd = "";
				grup_nm = "";
				uni_key = "";
				upper_uni_key = "";
				
				grup_cd = (String) categoryMap.get("GRUP_CD");
				grup_nm = (String) categoryMap.get("GRUP_NM");
				uni_key = (String) categoryMap.get("UNI_KEY");
				upper_uni_key = (String) categoryMap.get("UPPER_UNI_KEY");
				//String folder_yn = (String) categoryMap.get("FOLDER_YN");
				
				/* DhtmlxTree 에 맞추어 데이터 재구성 */
				categoryMap.put("id", grup_cd);
				categoryMap.put("text", grup_nm);
				/* 빈 폴더는 이미지가 페이지로 바뀌어서 강제로 이미지 설정 */
				/*if(folder_yn != null && folder_yn.equals("Y")){
					categoryMap.put("im0", "folderClosed.gif");
					categoryMap.put("im1", "folderOpen.gif");
					categoryMap.put("im2", "folderClosed.gif");
				}*/
				
				hashCategoryMap.put(uni_key, categoryMap);
				
				
				/* 최상위 메뉴 */
				if(upper_uni_key.equals("0_0_0")){
					resultCategoryMapList.add(categoryMap);
				}
			}
			
			/* 하위 메뉴 설정 */
			Map<String, Object> upperCategoryMap = null;
			List<Map<String, Object>> item = null;
			for(Map<String, Object> categoryMap : categoryList){
				upper_uni_key = "";
				upper_uni_key = (String) categoryMap.get("UPPER_UNI_KEY");
				if(upper_uni_key.equals("0_0_0")){
					continue;
				}
				
				/* 상위 메뉴 정보가 없으면 Continue */
				/*String upper_menu_cd = (String) categoryMap.get("UPPER_MENU_CD");
				if(upper_menu_cd == null || upper_menu_cd.equals("")){
					continue;
				}*/
				
				upperCategoryMap = (Map<String, Object>) hashCategoryMap.get(upper_uni_key);
				
				if(upperCategoryMap == null) {
					continue;
				}
				
				item = null;
				if(upperCategoryMap.containsKey("item")){
					item = (List<Map<String, Object>>) upperCategoryMap.get("item");
				} else {
					item = getNewList();
					upperCategoryMap.put("item", item);
				}
				item.add(categoryMap);
			}
		}
		//return resultCategoryMapList;
		
		//Tree와 Grid 데이터 모두 필요하여 변경함
		returnMap.put("categoryList", categoryList);
		returnMap.put("categoryTree", resultCategoryMapList);
		return returnMap;		
		
		
	}
	
	public List<Map<String, Object>> getNewList(){
		return new ArrayList<Map<String, Object>>();
	}	

	@Override
	public Map<String, Object> getGroupCdFromTreeID(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getGroupCdFromTreeID(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getSearchOrderDetailListCopy(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getSearchOrderDetailListCopy(paramMap);
	}
	
	@Override
	public Map<String, Object> getOrderDeadTimeLeadTime(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getOrderDeadTimeLeadTime(paramMap);
	}
	
	@Override
	public Map<String, Object> getBusinessDay(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getBusinessDay(paramMap);
	}
	
	@Override
	public Map<String, Object> getLoginOrgInfo(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getLoginOrgInfo(paramMap);
	}
	
	@Override
	public Map<String, Object> getSelectedOrgInfo(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getSelectedOrgInfo(paramMap);
	}

	@Override
	public Map<String, Object> getOrderCloseTime(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderSearchDao.getOrderCloseTime(paramMap);
	}
	
}