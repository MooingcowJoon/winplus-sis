package com.samyang.winplus.common.system.authority.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.authority.dao.SystemAuthorityDao;
import com.samyang.winplus.common.system.model.MenuDto;
import com.samyang.winplus.common.system.model.ScreenDto;

@Service("SystemAuthorityService")
public class SystemAuthorityServiceImpl implements SystemAuthorityService {
	// test commit 2
	@Autowired
	SystemAuthorityDao systemAuthorityDao;
		
	/**
	  * getAuthorList - 권한 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getAuthorList(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return systemAuthorityDao.getAuthorList(paramMap);
	}

	/**
	  * saveAuthorList - 권한 목록 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveAuthorList(List<Map<String, Object>> paramMapList)
			throws SQLException, Exception {
		int resultRow = 0;
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");			
			if(crud != null){				
				if("C".equals(crud)){
					paramMap.put("REG_PROGRM", "insertAuthor");
					resultRow += systemAuthorityDao.insertAuthor(paramMap);
				} else if("U".equals(crud)){
					paramMap.put("REG_PROGRM", "updateAuthor");
					resultRow += systemAuthorityDao.updateAuthor(paramMap);
				} else if("D".equals(crud)){
					resultRow += systemAuthorityDao.deleteAuthor(paramMap);
				}
			}
		}
		
		return resultRow;
	}

	/**
	  * getAuthorByMenuList - 권한별메뉴 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAuthorByMenuList(Map<String, Object> paramMap)
			throws SQLException, Exception {
		List<Map<String, Object>> resultAuthorByMenuList = new ArrayList<Map<String, Object>>();
		Map<String, Map<String, Object>> hashAuthorByMenuMap = new HashMap<String, Map<String, Object>>();
		
		List<Map<String, Object>> authorByMenuList = systemAuthorityDao.getAuthorByMenuList(paramMap);
		
		for(Map<String, Object> authorByMenu : authorByMenuList){
			String menu_cd = (String) authorByMenu.get("MENU_CD");
			Short menu_step = Short.valueOf(authorByMenu.get("MENU_STEP").toString());
			/* DhtmlXTreeGrid 규칙 */
			authorByMenu.put("id", menu_cd);			
			hashAuthorByMenuMap.put(menu_cd, authorByMenu);
			if(menu_step == 0){				
				resultAuthorByMenuList.add(authorByMenu);
			}
		}
		
		for(Map<String, Object> authorByMenu : authorByMenuList){
			Short menu_step = Short.valueOf(authorByMenu.get("MENU_STEP").toString());			
			if(menu_step == 0){				
				continue;
			}
			
			String upper_menu_cd = (String) authorByMenu.get("UPPER_MENU_CD");
			Map<String, Object> upperAuthorByMenuMap = hashAuthorByMenuMap.get(upper_menu_cd);
			
			List<Map<String, Object>> subRowList = null;
			if(upperAuthorByMenuMap.containsKey("rows")){
				subRowList = (List<Map<String, Object>>) upperAuthorByMenuMap.get("rows");
			} else {
				subRowList = getNewList();
				upperAuthorByMenuMap.put("rows", subRowList);
			}
			subRowList.add(authorByMenu);
		}
		
		for(Map<String, Object> authorByMenu : authorByMenuList){
			String folder_yn = (String) authorByMenu.get("FOLDER_YN");
			String menu_nm = (String) authorByMenu.get("MENU_NM");
			Map<String, Object> treeColumn = getNewMap();			
			treeColumn.put("value", " " + menu_nm);
			if(authorByMenu.containsKey("rows") || (folder_yn != null && folder_yn.equals("Y"))){
				treeColumn.put("image", "folder.gif");
			} else {
				treeColumn.put("image", "leaf.gif");
			}
			authorByMenu.put("TREE", treeColumn);
		}
		
		return resultAuthorByMenuList; 
	}

	/**
	  * saveAuthorByMenuList - 권한별메뉴 목록 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveAuthorByMenuList(List<Map<String, Object>> paramMapList)
			throws SQLException, Exception {
		int resultRow = 0;
		for(Map<String, Object> paramMap : paramMapList){
			paramMap.put("REG_PROGRM", "saveAuthorByMenu");
			resultRow += systemAuthorityDao.saveAuthorByMenu(paramMap);
		}
		
		return resultRow;
	}

	/**
	  * getAuthorByEmpList - 권한별사원 목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getAuthorByEmpList(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return systemAuthorityDao.getAuthorByEmpList(paramMap);
	}

	/**
	  * saveAuthorByEmpList - 권한별사원 목록 저장
	  * @author 김종훈
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveAuthorByEmpList(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		int resultRow = 0;
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");			
			if(crud != null){				
				if("C".equals(crud)){
					paramMap.put("REG_PROGRM", "insertAuthorByEmp");
					resultRow += systemAuthorityDao.insertAuthorByEmp(paramMap);
				} else if("U".equals(crud)){
					paramMap.put("REG_PROGRM", "updateAuthorByEmp");
					resultRow += systemAuthorityDao.updateAuthorByEmp(paramMap);
				} else if("D".equals(crud)){
					resultRow += systemAuthorityDao.deleteAuthorByEmp(paramMap);
				}
			}
		}
		
		return resultRow;
	}

	/**
	  * getAuthorTargetList - 권한대상목록 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getAuthorTargetList(Map<String, Object> paramMap)
			throws SQLException, Exception {
		return systemAuthorityDao.getAuthorTargetList(paramMap);
	}
	
	/**
	  * getMenuMapList - 메뉴 맵 목록 조회
	  * @author 김종훈
	  * @param empSessionDto
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getMenuMapList(Map<String, Object> paramMap) throws SQLException, Exception {
		List<MenuDto> menuDtoList = systemAuthorityDao.getMenuDtoList(paramMap);
		List<Map<String, Object>> resultMenuMapList = new ArrayList<Map<String, Object>>();
		if(!menuDtoList.isEmpty()){
			Map<String, Object> hashMenuMap = new HashMap<String, Object>();
			
			int topMenu_step = 0;
			/* 본사영업관리, 지사영업관리 따로 있는 경우를 위하여 Top Menu Step 1까지 검색 */
			while(resultMenuMapList.isEmpty() && topMenu_step <= 1){			
				for(MenuDto menuDto : menuDtoList){
					/* 최초에 한번만 등록 */
					Map<String, Object> menuMap = getNewMap();
					int menu_step =  menuDto.getMenu_step();
					String menu_cd = menuDto.getMenu_cd();
					if(topMenu_step == 0){					
						/* DhtmlxTree 에 맞추어 데이터 재구성 */ 
						String folder_yn = menuDto.getFolder_yn();
						menuMap.put("id", menu_cd);
						menuMap.put("text", menuDto.getMenu_nm());
						menuMap.put("upper_menu_cd", menuDto.getUpper_menu_cd());
						menuMap.put("folder_yn", folder_yn);					
						menuMap.put("menu_step", menu_step);			
						
						/* 빈 폴더는 이미지가 페이지로 바뀌어서 강제로 이미지 설정 */
						if(folder_yn != null && folder_yn.equals("Y")){					
							menuMap.put("im0", "folderClosed.gif");
							menuMap.put("im1", "folderOpen.gif");
							menuMap.put("im2", "folderClosed.gif");
						}
						
						hashMenuMap.put(menu_cd, menuMap);
					}				
					/* 최상위 메뉴 */
					if(menu_step == topMenu_step){
						if(topMenu_step > 0){
							menuMap = (Map<String, Object>) hashMenuMap.get(menu_cd);
						}
						resultMenuMapList.add(menuMap);
					}
				}	
				if(resultMenuMapList.isEmpty()){
					topMenu_step++;
				}
			}
			
			/* 하위 메뉴 설정 */
			for(MenuDto menuDto : menuDtoList){
				int menu_step =  menuDto.getMenu_step();
				if(menu_step == 0){
					continue;
				}
				
				/* 상위 메뉴 정보가 없으면 Continue */
				String upper_menu_cd = menuDto.getUpper_menu_cd();
				if(upper_menu_cd == null || upper_menu_cd.equals("")){
					continue;
				}
				
				String menu_cd = menuDto.getMenu_cd();
				Map<String, Object> menuMap = (Map<String, Object>) hashMenuMap.get(menu_cd);
				Map<String, Object> upperMenuMap = (Map<String, Object>) hashMenuMap.get(upper_menu_cd);	
				
				if(upperMenuMap == null){					
					continue;
				}
				
				/* 상위 메뉴가 폴더가 아니면 Continue */
				Object folder_yn = upperMenuMap.get("folder_yn");
				if(folder_yn != null && folder_yn.equals("N")){
					continue;
				}

				List<Map<String, Object>> item = null;
				if(upperMenuMap.containsKey("item")){
					item = (List<Map<String, Object>>) upperMenuMap.get("item");							
				} else {
					item = getNewList();
					upperMenuMap.put("item", item);
				}
				item.add(menuMap);
			}			

			/* 폴더인데 하위 메뉴가 없는 메뉴 코드 목록 추출 */
			List<String> lostMenuCdList = new ArrayList<String>();
			for(String menu_cd : hashMenuMap.keySet()){
				Map<String, Object> menuMap = (Map<String, Object>) hashMenuMap.get(menu_cd);
				Object folder_yn = menuMap.get("folder_yn");
				int menu_step =  (int) menuMap.get("menu_step");
				if(folder_yn != null && folder_yn.equals("Y")){
					if(!menuMap.containsKey("item")){
						/* 최상위 메뉴면 바로 삭제 */
						if(menu_step == topMenu_step){
							resultMenuMapList.remove(menuMap);
						} else {
							lostMenuCdList.add(menu_cd);
						}
					}
				}
			}
			/* 폴더인데 하위 메뉴가 없는 메뉴 상위 메뉴 접근하여 해당 오류 하위 메뉴 삭제 */
			for(String menu_cd : lostMenuCdList){
				Map<String, Object> menuMap = (Map<String, Object>) hashMenuMap.get(menu_cd);
				Object upper_menu_cd = menuMap.get("upper_menu_cd");
				if(upper_menu_cd != null){
					if(hashMenuMap.containsKey(upper_menu_cd)){
						Map<String, Object> upperMenuMap = (Map<String, Object>) hashMenuMap.get(upper_menu_cd);
						if(upperMenuMap != null&&upperMenuMap.containsKey("item")){

							List<Map<String, Object>> item = (List<Map<String, Object>>) upperMenuMap.get("item");
							item.remove(menuMap);

						}
					}
				}
			}
		}			
		
		return resultMenuMapList;
	}
	
	public Map<String, Object> getNewMap(){
		return new HashMap<String, Object>();
	}
	public List<Map<String, Object>> getNewList(){
		return new ArrayList<Map<String, Object>>();
	}
	/**
	  * getMenuDto - 메뉴 조회 (권한 확인용)
	  * @author 김종훈
	  * @param paramMap
	  * @return MenuDto
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public MenuDto getMenuDto(Map<String, Object> paramMap) throws SQLException, Exception {
		return systemAuthorityDao.getMenuDto(paramMap);
	}
	/**
	  * getScreenDto - ScreenDto 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return ScreenDto
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public ScreenDto getScreenDto(Map<String, Object> paramMap) throws SQLException, Exception {
		return systemAuthorityDao.getScreenDto(paramMap);
	}
	
	/**
	  * getCommonScreenDto - 공통 ScreenDto 조회
	  * @author 김종훈
	  * @param paramMap
	  * @return ScreenDto
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public ScreenDto getCommonScreenDto(Map<String, Object> paramMap) throws SQLException, Exception {
		return systemAuthorityDao.getCommonScreenDto(paramMap);
	}
	
	/**
	  * insertSystemConnLog - 시스템 접속 로그
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int insertSystemConnLog(Map<String, Object> paramMap) throws SQLException, Exception {
		return systemAuthorityDao.insertSystemConnLog(paramMap);
	}

	/**
	  * getEmpAccessLogList - 직원접속로그 - 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getEmpAccessLogList(Map<String, Object> paramMap) {
		return systemAuthorityDao.getEmpAccessLogList(paramMap);
	}
	
	/**
	  * getEmpList - 사원조회 - 조회
	  * @author 서준호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getEmpList(Map<String, Object> paramMap) {
		return systemAuthorityDao.getEmpList(paramMap);
	}
	
	
	/**
	  * saveEmpList - 사원조회 - 추가 - 저장
	  * @author 서준호
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int saveEmpList(List<Map<String, Object>> paramMapList) throws SQLException, Exception{
		int resultInt = 0;		
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");
			if(crud != null) {
				if("C".equals(crud)){
					resultInt += systemAuthorityDao.insertEmp(paramMap);
				} else if ("U".equals(crud)){
					resultInt += systemAuthorityDao.updateEmp(paramMap);
				} else if ("D".equals(crud)){
					resultInt += systemAuthorityDao.deleteEmp(paramMap);
				}
			}
		}
		
		return resultInt;
	}
	
	
	/**
	  * getPjtList - 사원조회 - 조회
	  * @author 서준호
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getPjtList(Map<String, Object> paramMap) {
		return systemAuthorityDao.getPjtList(paramMap);
	}
	
	
	
	
	/**
	  * savePjtList - 사원조회 - 추가 - 저장
	  * @author 서준호
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	public int savePjtList(List<Map<String, Object>> paramMapList) throws SQLException, Exception{
		int resultInt = 0;		
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");
			if(crud != null) {
				if("C".equals(crud)){
					resultInt += systemAuthorityDao.insertPjt(paramMap);
				} else if ("U".equals(crud)){
					resultInt += systemAuthorityDao.updatePjt(paramMap);
				} else if ("D".equals(crud)){
					resultInt += systemAuthorityDao.deletePjt(paramMap);
				}
			}
		}
		
		return resultInt;
	}
	
}
