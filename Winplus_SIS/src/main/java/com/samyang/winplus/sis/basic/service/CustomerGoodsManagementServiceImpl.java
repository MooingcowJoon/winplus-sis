package com.samyang.winplus.sis.basic.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.util.LoofInterface;
import com.samyang.winplus.common.system.util.LoofUtilObject;
import com.samyang.winplus.sis.basic.dao.CustomerGoodsManagementDao;
import com.samyang.winplus.sis.basic.service.CustomerGoodsManagementService;

@Service("CustomerGoodsManagementService")
public class CustomerGoodsManagementServiceImpl implements CustomerGoodsManagementService {
	
	@Autowired
	CustomerGoodsManagementDao customerGoodsManagementDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	@Override
	public int insertStdCustomrGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateStdCustomrGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteStdCustomrGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}	
	
	@Override
	public List<Map<String, Object>> getSearchMasterBarcodeList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return customerGoodsManagementDao.getSearchMasterBarcodeList(paramMap);
	}

	@Override
	public List<Map<String, Object>> getSearchTstdCustomerGoodsList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return customerGoodsManagementDao.getSearchTstdCustomerGoodsList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getSearchMasterBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return customerGoodsManagementDao.getSearchMasterBarcodePriceList(paramMap);
	}

	/**
	  * saveCustomerMkScreenList -  대상거래처 납품업체 C,U,D
	  * @author 손경락
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveStdCustomrGoodsScreenList(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
		int resultInt = 0;		
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");
			//logger.debug("@@@@@@@@@@ CustomerGoodsManagementServiceImpl.java crud ============" + crud);
			
			if(crud != null) {
				if("C".equals(crud)){
					paramMap.put("PARAM_PROGRM", "insertMkCustomer");
					resultInt += customerGoodsManagementDao.insertStdCustomrGoods(paramMap);
				} else if ("U".equals(crud)){
					paramMap.put("PARAM_PROGRM", "updateMkCustomer");
					resultInt += customerGoodsManagementDao.updateStdCustomrGoods(paramMap);
				} else if ("D".equals(crud)){
					resultInt += customerGoodsManagementDao.deleteStdCustomrGoods(paramMap);
				}
			}
		}
		
		return resultInt;
	}
 
	/* 상품기준 최저 구매가격 가져오기 */
	@Override
	public List<Map<String, Object>> getSearchMasterBarcodeLowestPriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return customerGoodsManagementDao.getSearchMasterBarcodeLowestPriceList(paramMap);
	}
	
	/* 팜센터에서의 신선발주( 팜센터에서 취급하는 상품을  구한다음 외부협력사를 찾는다) */
	@Override
	public List<Map<String, Object>> getSearchMasterBarcodeFreshPriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return customerGoodsManagementDao.getSearchMasterBarcodeFreshPriceList(paramMap);
	}
	
	/**
	  * getCustmrStdPrice - 고객그룹별_기준가관리(상품별) - 조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getCustmrStdPrice(Map<String, Object> paramMap)  throws SQLException, Exception {
		return customerGoodsManagementDao.getCustmrStdPrice(paramMap);
	}
	
	/**
	  * getCustmrStdPriceGoodsInfo - 고객그룹별_기준가관리(상품별) - 상품추가
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getCustmrStdPriceGoodsInfo(Map<String, Object> paramMap) throws SQLException, Exception{
		Map<String, Object> resultMap = null;
		List<Map<String, Object>> lm = null;
		String BCD_CD = paramMap.get("loadGoodsList").toString();
		BCD_CD = BCD_CD.replace("[", "");
		BCD_CD = BCD_CD.replace("]", "");
		BCD_CD = BCD_CD.replaceAll(" ", "");
		String[] BCD_CD_LIST = BCD_CD.split(",");
		
		List<Map<String, Object>> goods_list = new ArrayList<Map<String, Object>>();
		for(String bcd_cd : BCD_CD_LIST) {
			resultMap = new HashMap<String, Object>();
			if(!bcd_cd.equals("")) {
				resultMap.put("STD_PRICE_GRUP", paramMap.get("STD_PRICE_GRUP"));
				resultMap.put("BCD_CD", bcd_cd);
				goods_list.add(resultMap);
			}
		}
		LoofUtilObject l = new LoofUtilObject();
		lm = l.selectAfterLoofBigMapList((List<Map<String, Object>>) goods_list, new LoofInterface() {
			@Override
			public Object exec(Object... obj) {
				return customerGoodsManagementDao.getCustmrStdPriceGoodsInfo((List<Map<String,Object>>) obj[0]);
			}
		});
		return lm;
	}
	
	/**
	  * getCustmrStdPrice - 고객그룹별_기준가관리 - 그룹조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getGrupStdPrice(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.getGrupStdPrice(paramMap);
	}
	
	/**
	  * getGoodsStdPrice - 고객그룹별_기준가관리 - 상품조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getGoodsStdPrice(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.getGoodsStdPrice(paramMap);
	}
	
	/**
	  * getStdPriceCustmrList - 고객그룹별_기준가관리 - 거래처조회
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getStdPriceCustmrList(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.getStdPriceCustmrList(paramMap);
	}
	
	/**
	  * getStdPriceGrupCdCheck - 고객그룹별_기준가관리 - 그룹저장코드 가져오기
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public Map<String, Object> getStdPriceGrupCdCheck(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.getStdPriceGrupCdCheck(paramMap);
	}
	
	/**
	  * addGrupStdPrice - 고객그룹별_기준가관리 - 그룹추가
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int addGrupStdPrice(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.addGrupStdPrice(paramMap);
	}
	
	/**
	  * deleteGrupStdPrice - 고객그룹별_기준가관리 - 그룹삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int deleteGrupStdPrice(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.deleteGrupStdPrice(paramMap);
	}
	
	/**
	  * updateGrupStdPrice - 고객그룹별_기준가관리 - 그룹저장
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int updateGrupStdPrice(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.updateGrupStdPrice(paramMap);
	}
	
	/**
	  * getStdPriceGoodsManagementInfo - 고객그룹별_기준가관리 - 상품추가
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getStdPriceGoodsManagementInfo(Map<String, Object> paramMap) {
		LoofUtilObject l = new LoofUtilObject();
		List<Map<String, Object>> lm = null;
		lm = l.selectAfterLoofBigList((List<String>) paramMap.get("loadGoodsList"), new LoofInterface() {
			@Override
			public Object exec(Object... obj) {
				return customerGoodsManagementDao.getStdPriceGoodsManagementInfo((List<String>) obj[0]);
			}
		});
		return lm;
	}
	
	/**
	  * addGoodsStdPrice - 고객그룹별_기준가관리 - 상품추가
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int addGoodsStdPrice(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.addGoodsStdPrice(paramMap);
	}
	
	/**
	  * deleteGoodsStdPrice - 고객그룹별_기준가관리 - 상품삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int deleteGoodsStdPrice(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.deleteGoodsStdPrice(paramMap);
	}
	
	/**
	  * updateGoodsStdPrice - 고객그룹별_기준가관리 - 상품수정
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int updateGoodsStdPrice(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.updateGoodsStdPrice(paramMap);
	}
	
	/**
	  * addCustmrStdPrice - 고객그룹별_기준가관리(상품별) - 추가
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int addCustmrStdPrice(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.addCustmrStdPrice(paramMap);
	}
	

	/**
	  * deleteCustmrStdPrice - 고객그룹별_기준가관리(상품별) - 삭제
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int deleteCustmrStdPrice(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.deleteCustmrStdPrice(paramMap);
	}
	
	/**
	  * updateCustmrStdPrice - 고객그룹별_기준가관리(상품별) - 수정
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int updateCustmrStdPrice(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.updateCustmrStdPrice(paramMap);
	}
	
	/**
	  * getCustmrStdPriceLookUp - 기준가조회(상품별)
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getCustmrStdPriceLookUp(Map<String, Object> paramMap) throws SQLException, Exception {
		return customerGoodsManagementDao.getCustmrStdPriceLookUp(paramMap);
	}
}
