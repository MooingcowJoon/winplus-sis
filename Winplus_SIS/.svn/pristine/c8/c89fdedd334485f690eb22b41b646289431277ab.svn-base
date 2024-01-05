package com.samyang.winplus.common.system.menu.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.menu.dao.SystemMenuDao;

@Service("SystemMenuService")
public class SystemMenuServiceImpl implements SystemMenuService {

	@Autowired
	SystemMenuDao systemMenuDao;	

	/**
	  * getAllMenuMapList - 모든 메뉴 맵 목록 조회
	  * @author 김종훈
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAllMenuMapList() throws SQLException, Exception {
		List<Map<String, Object>> menuList = systemMenuDao.getMenuList();
		List<Map<String, Object>> resultMenuMapList = null;
		if(!menuList.isEmpty()){
			resultMenuMapList = new ArrayList<Map<String, Object>>();
			
			Map<String, Object> hashMenuMap = new HashMap<String, Object>();
			
			for(Map<String, Object> menuMap : menuList){
				String menu_cd = (String) menuMap.get("MENU_CD");
				String menu_nm = (String) menuMap.get("MENU_NM");
				Short menu_step = Short.valueOf( menuMap.get("MENU_STEP").toString() );
				String folder_yn = (String) menuMap.get("FOLDER_YN");
								
				/* DhtmlxTree 에 맞추어 데이터 재구성 */ 
				menuMap.put("id", menu_cd);
				menuMap.put("text", menu_nm);
				menuMap.put("folder_yn", folder_yn);
				/* 빈 폴더는 이미지가 페이지로 바뀌어서 강제로 이미지 설정 */
				if(folder_yn != null && folder_yn.equals("Y")){					
					menuMap.put("im0", "folderClosed.gif");
					menuMap.put("im1", "folderOpen.gif");
					menuMap.put("im2", "folderClosed.gif");
				}
				
				hashMenuMap.put(menu_cd, menuMap);
				
				
				/* 최상위 메뉴 */
				if(menu_step == 0){
					resultMenuMapList.add(menuMap);
				}
			}	
			
			/* 하위 메뉴 설정 */
			for(Map<String, Object> menuMap : menuList){
				Short menu_step =  Short.valueOf( menuMap.get("MENU_STEP").toString());
				if(menu_step == 0){
					continue;
				}
				
				/* 상위 메뉴 정보가 없으면 Continue */
				String upper_menu_cd = (String) menuMap.get("UPPER_MENU_CD");
				if(upper_menu_cd == null || upper_menu_cd.equals("")){
					continue;
				}
				
				Map<String, Object> upperMenuMap = (Map<String, Object>) hashMenuMap.get(upper_menu_cd);	
							
				List<Map<String, Object>> item = null;
				if(upperMenuMap.containsKey("item")){
					item = (List<Map<String, Object>>) upperMenuMap.get("item");							
				} else {
					item = getNewList();
					upperMenuMap.put("item", item);
				}
				item.add(menuMap);
			}
		}			
		
		return resultMenuMapList;
	}
	
	public List<Map<String, Object>> getNewList(){
		return new ArrayList<Map<String, Object>>();
	}

	/**
	  * getMenuMap - 메뉴맵 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getMenuMap(Map<String, Object> paramMap) throws SQLException, Exception {
		return systemMenuDao.getMenuMap(paramMap);
	}

	/**
	  * saveMenu - 메뉴 저장
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveMenu(Map<String, Object> paramMap) throws SQLException, Exception {
		int resultInt = 0;
		int chkChildMenuInt = 0;
		
		Object crud = paramMap.get("CRUD");
		if(crud != null) {
			if("C".equals(crud)){
				paramMap.put("REG_PROGRM", "insertMenu");
				resultInt += systemMenuDao.insertMenu(paramMap);
			} else if ("U".equals(crud)){
				paramMap.put("REG_PROGRM", "updateMenu");
				resultInt += systemMenuDao.updateMenu(paramMap);
			} else if ("D".equals(crud)){
				
				//하위 메뉴 존재여부 체크
				chkChildMenuInt = systemMenuDao.chkChildMenu(paramMap);
				
				//하위메뉴 존재 시 메뉴 삭제 안됨
				if(chkChildMenuInt != 0){
					chkChildMenuInt = 9999;
					return chkChildMenuInt;
				}else{
				
					resultInt += systemMenuDao.deleteAuthorByMenu(paramMap);
					
					resultInt += systemMenuDao.deleteMenuByScrin(paramMap);
					
					resultInt += systemMenuDao.deleteMenu(paramMap);
				}
			}
		}
		
		return resultInt;
	}

	/**
	  * getScreenList - 화면 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getScreenList(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return systemMenuDao.getScreenList(paramMap);
	}

	/**
	  * saveScreenList - 화면 목록 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveScreenList(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		int resultInt = 0;		
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");
			if(crud != null) {
				if("C".equals(crud)){
					paramMap.put("REG_PROGRM", "insertScreen");
					resultInt += systemMenuDao.insertScreen(paramMap);
				} else if ("U".equals(crud)){
					paramMap.put("REG_PROGRM", "updateScreen");
					resultInt += systemMenuDao.updateScreen(paramMap);
				} else if ("D".equals(crud)){
					resultInt += systemMenuDao.deleteScrinFirst(paramMap);
					
					resultInt += systemMenuDao.deleteScrinSecond(paramMap);
				}
			}
		}
		
		return resultInt;
	}

	/**
	  * getMenuByScreenList - 메뉴별화면 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getMenuByScreenList(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return systemMenuDao.getMenuByScreenList(paramMap);
	}

	/**
	  * saveMenuByScreenList - 메뉴별화면 목록 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveMenuByScreenList(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		int resultInt = 0;		
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");
			if(crud != null) {
				if("C".equals(crud)){
					paramMap.put("REG_PROGRM", "insertMenuByScreen");
					resultInt += systemMenuDao.insertMenuByScreen(paramMap);
				} else if ("U".equals(crud)){
					paramMap.put("REG_PROGRM", "updateMenuByScreen");
					resultInt += systemMenuDao.updateMenuByScreen(paramMap);
				} else if ("D".equals(crud)){
					resultInt += systemMenuDao.deleteMenuByScreen(paramMap);
				}
			}
		}
		
		return resultInt;
	}
}
