package com.samyang.winplus.sis.standardInfo.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.util.LoofInterface;
import com.samyang.winplus.common.system.util.LoofUtilObject;
import com.samyang.winplus.sis.standardInfo.dao.GoodsInformationDao;

@Service("GoodsInformationService")
public class GoodsInformationServiceImpl implements GoodsInformationService {
	
	@Autowired
	GoodsInformationDao goodsInformationDao;

	/**
	  * getGoodsInformationList - 상품정보관리 - 상품정보 목록 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getGoodsInformationList(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.getGoodsInformationList(paramMap);
	}

	/**
	  * getGoodsInformation - 상품정보관리 - 상품정보 항목 조회
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getGoodsInformation(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.getGoodsInformation(paramMap);
	}

	/**
	  * updateGoodsInformation - 상품정보관리 - 상품정보 항목 저장
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> updateGoodsInformation(Map<String, String> paramMap) throws SQLException, Exception {
		return goodsInformationDao.updateGoodsInformation(paramMap);
	}

	/**
	  * deleteGoodsInformation - 상품정보관리 - 상품정보 항목 삭제
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> deleteGoodsInformation(Map<String, String> paramMap) throws SQLException, Exception {
		return goodsInformationDao.deleteGoodsInformation(paramMap);
	}

	/**
	  * getGoodsInformationFromBarcode - 상품일괄등록/변경 - 바코드로 상품정보 조회
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getGoodsInformationFromBarcode(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.getGoodsInformationFromBarcode(paramMap);
	}

	/**
	  * getAllOrgnCdList - 전체 직영점 코드 목록 조회
	  * @author 강신영
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getAllOrgnCdList() throws SQLException, Exception {
		return goodsInformationDao.getAllOrgnCdList();
	}

	/**
	  * updateBatchGoodsInformation - 상품일괄등록/변경 - 상품정보 일괄 수정
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> updateBatchGoodsInformation(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.updateBatchGoodsInformation(paramMap);
	}

	/**
	  * updateBatchBarcodeInformation - 상품일괄등록/변경 - 바코드정보 일괄 수정
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> updateBatchBarcodeInformation(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.updateBatchBarcodeInformation(paramMap);
	}

	/**
	  * getGoodsRegistInformationList - 상품등록요청(직영점) - 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getGoodsRegistInformationList(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.getGoodsRegistInformationList(paramMap);
	}

	/**
	  * updateGoodsRegistInformation - 상품등록요청(직영점) - 저장
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> updateGoodsRegistInformation(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.updateGoodsRegistInformation(paramMap);
	}

	/**
	  * validGoodsRegistInformation - 상품등록요청(직영점) - 저장 - 저장된 데이터 검증
	  * @author 강신영
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public void validGoodsRegistInformation() throws SQLException, Exception {
		goodsInformationDao.validGoodsRegistInformation();
	}

	/**
	  * getGoodsRegistConfirmList - 상품등록승인관리 - 조회
	  * @author 강신영
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getGoodsRegistConfirmList(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.getGoodsRegistConfirmList(paramMap);
	}

	/**
	  * updateGoodsConfirmApply - 상품등록승인관리 - 승인
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> updateGoodsConfirmApply(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.updateGoodsConfirmApply(paramMap);
	}

	/**
	  * updateGoodsConfirmReject - 상품등록승인관리 - 반송
	  * @author 강신영
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> updateGoodsConfirmReject(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.updateGoodsConfirmReject(paramMap);
	}
	
	/**
	  * getGoodsBalanceList - 저울상품관리 - 저울상품 그룹 조회(Head)
	  * @author 최지민
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getGoodsBalanceList(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.getGoodsBalanceList(paramMap);
	}
	
	/**
	  * getGoodsBalanceDetailList - 저울상품관리 - 저울상품 그룹 조회(Detail)
	  * @author 최지민
	  * @param paramMap
	  * @return List<Map<String, Object>>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public List<Map<String, Object>> getGoodsBalanceDetailList(Map<String, Object > paramMap) throws SQLException, Exception {
		return goodsInformationDao.getGoodsBalanceDetailList(paramMap);
	}
	
	/**
	  * getBalanceInfoCheck - 저울상품관리 - 저울상품 그룹 저장(Head)
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public Map<String, Object> getBalanceInfoCheck(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.getBalanceInfoCheck(paramMap);
	}
	
	/**
	  * addBalanceMaster - 저울상품관리 - 저울상품 그룹 저장(Head) -add
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int addBalanceMaster(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.addBalanceMaster(paramMap);
	}
	
	/**
	  * deleteBalanceMaster - 저울상품관리 - 저울상품 그룹 저장(Head) -delete
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int deleteBalanceMaster(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.deleteBalanceMaster(paramMap);
	}
	
	/**
	  * updateBalanceMaster - 저울상품관리 - 저울상품 그룹 저장(Head) -update
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int updateBalanceMaster(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.updateBalanceMaster(paramMap);
	}
	
	/**
	  * getBalanceDetailList - 저울상품관리 - 저울상품 추가(Detail)
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getBalanceDetailList(Map<String, Object> paramMap) throws SQLException, Exception{
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
				resultMap.put("ORGN_CD", paramMap.get("ORGN_CD"));
				resultMap.put("BCD_CD", bcd_cd);
				goods_list.add(resultMap);
			}
		}
		LoofUtilObject l = new LoofUtilObject();
		lm = l.selectAfterLoofBigMapList((List<Map<String, Object>>) goods_list, new LoofInterface() {
			@Override
			public Object exec(Object... obj) {
				return goodsInformationDao.getBalanceDetailList((List<Map<String,Object>>) obj[0]);
			}
		});
		return lm;
	}
	
	/**
	  * getBalanceDetailinfoCheck - 저울상품관리 - 저울상품 저장(Detail) 
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public Map<String, Object> getBalanceDetailinfoCheck(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.getBalanceDetailinfoCheck(paramMap);
	}
	
	/**
	  * addBalanceDetailGoods - 저울상품관리 - 저울상품 저장(Detail) -add
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int addBalanceDetailGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.addBalanceDetailGoods(paramMap);
	}
	
	/**
	  * deleteBalanceDetailGoods - 저울상품관리 - 저울상품 저장(Detail) -delete
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int deleteBalanceDetailGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.deleteBalanceDetailGoods(paramMap);
	}
	
	/**
	  * updateBalanceDetailGoods - 저울상품관리 - 저울상품 저장(Detail) -update
	  * @author 최지민
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int updateBalanceDetailGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.updateBalanceDetailGoods(paramMap);
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 퇴출상품관리 조회 
	  * @author 최지민
	  * @param request
	  * @return List<Map<String, Object>>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getGoodsExitList(Map<String, Object > paramMap) throws SQLException, Exception {
		return goodsInformationDao.getGoodsExitList(paramMap);
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 퇴출상품관리 조회 - 대중소구분
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public Map<String, Object> getGoodsExitListTMB(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.getGoodsExitListTMB(paramMap);
	}
	
	/**
	  * 기준정보관리 - 상품관리 - 퇴출상품관리 저장
	  * @author 최지민
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int updateGoodsExitList(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.updateGoodsExitList(paramMap);
	}

	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 헤더 조회
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getresbarcodeHeaderList(Map<String, Object> paramMap)
			throws SQLException, Exception {
		// TODO Auto-generated method stub
		return goodsInformationDao.getresbarcodeHeaderList(paramMap);
	}

	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 디테일 조회
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getresbarcodeDetailList(Map<String, String> paramMap)
			throws SQLException, Exception {
		// TODO Auto-generated method stub
		return goodsInformationDao.getresbarcodeDetailList(paramMap);
	}

	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 바코드 엑셀 정보 가져오기
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public List<Map<String, Object>> getRESBCDInfo(Map<String, Object> paramMap) throws SQLException, Exception {
		return goodsInformationDao.getRESBCDInfo(paramMap);
	}

	/**
	  * 기준정보관리 - 상품관리 - 예비바코드관리 바코드 저장-추가
	  * @author 한정훈
	  * @param request
	  * @return Map<String, Object>
	  */
	@Override
	public int insertRESBCD(List<Map<String, Object>> paramMapList) {
		int resultRow = 0;

		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");
			if(crud != null) {
				if("C".equals(crud)){
					paramMap.put("CPROGRM", "insertRESBCD");
					resultRow += goodsInformationDao.insertRESBCDList(paramMap);
				} else if("U".equals(crud)){
					paramMap.put("MPROGRM", "updateRESBCD");
					resultRow += goodsInformationDao.updateRESBCDList(paramMap);
				}
			}
		}
		return resultRow;
	}
	/**
	  * 기준정보관리 - 상품관리 - 파일그룹번호 등록
	  * @author 조승현
	  * @param paramMap
	  */
	@Override
	public void updateGoodsFileGrupNo(Map<String, Object> paramMap) {
		goodsInformationDao.updateGoodsFileGrupNo(paramMap);
	}
}
