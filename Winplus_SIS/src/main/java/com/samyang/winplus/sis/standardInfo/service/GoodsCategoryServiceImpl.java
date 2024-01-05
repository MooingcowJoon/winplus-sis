package com.samyang.winplus.sis.standardInfo.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.sis.standardInfo.dao.GoodsCategoryDao;

@Service("GoodsCategoryService")
public class GoodsCategoryServiceImpl implements GoodsCategoryService {
	
	@Autowired
	GoodsCategoryDao goodsCategoryDao;

	/**
	  * getCategoryMap - 상품분류 항목 조회
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getCategoryMap(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsCategoryDao.getCategoryMap(paramMap);
	}

	/**
	  * updateGoodsCategory - 상품분류관리 - 상품분류 항목 저장
	  * @author 강신영
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public String updateGoodsCategory(Map<String, Object> paramMap) throws SQLException, Exception {
		int chkChildCategoryInt = 0;
		String resultMsg = "";
		
		Object crud = paramMap.get("CRUD");
		if(crud != null) {
			if("C".equals(crud)){
				paramMap.put("PROGRM", "insertGoodsCategory");
				resultMsg = goodsCategoryDao.insertGoodsCategory(paramMap);
			} else if ("U".equals(crud)){
				paramMap.put("PROGRM", "updateGoodsCategory");
				resultMsg = goodsCategoryDao.updateGoodsCategory(paramMap);
			} else if ("D".equals(crud)){
				
				//상품분류 삭제전 하위 상품분류 or 해당 분류를 사용하고 있는 상품 체크
				chkChildCategoryInt = goodsCategoryDao.chkChildCategory(paramMap);
				
				//하위분류 내용 사용 시 상품분류코드 삭제 안됨
				if(chkChildCategoryInt != 0){
					resultMsg = "9999";
				}else{
					resultMsg = goodsCategoryDao.deleteGoodsCategory(paramMap);
				}
			}
		}
		return resultMsg;
	}

	/**
	  * getGoodsCategoryByGoodsList - 상품분류별상품등록 - 상품분류별 상품목록 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getGoodsCategoryByGoodsList(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsCategoryDao.getGoodsCategoryByGoodsList(paramMap);
	}

	/**
	  * updateCategoryByGoods - 상품분류별상품등록 - 상품분류별 상품목록 저장
	  * @author 강신영
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int updateCategoryByGoods(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		int resultInt = 0;		
		for(Map<String, Object> paramMap : paramMapList){
			//System.out.println("paramMap = "+paramMap);
			Object crud = paramMap.get("CRUD");
			if(crud != null) {
				paramMap.put("REG_PROGRM", "updateCategoryByGoods");
				resultInt += goodsCategoryDao.updateCategoryByGoods(paramMap);
			}
		}
		
		return resultInt;
	}
}
