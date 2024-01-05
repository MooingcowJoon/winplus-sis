package com.samyang.winplus.sis.sales.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.util.CommonUtil;
import com.samyang.winplus.common.system.util.LoofInterface;
import com.samyang.winplus.common.system.util.LoofUtilObject;
import com.samyang.winplus.sis.sales.dao.OnlineManagementDao;

@Service("OnlineManagementService")
public class OnlineManagementServiceImpl implements OnlineManagementService{

	@Autowired
	protected CommonUtil commonUtil;
	
	@Autowired
	OnlineManagementDao onlineManagementDao;
	
	@Override
	public List<Map<String, Object>> getOnlineOrderList(Map<String, Object> paramMap) throws SQLException, Exception{

		return onlineManagementDao.getOnlineOrderList(paramMap);
	}
	@Override
	public List<Map<String, Object>> getopenOnlineOrderDetail(Map<String, String> paramMap) throws SQLException, Exception{

		return onlineManagementDao.getopenOnlineOrderDetail(paramMap);
	}
	@Override
	public List<Map<String, Object>> getOnlineOrdersInfo(Map<String, Object> paramMap) {
		LoofUtilObject l = new LoofUtilObject();
		List<Map<String, Object>> lm = null;
		lm = l.selectAfterLoofBigMapList((List<Map<String,Object>>) paramMap.get("loadOnlineOrder"), new LoofInterface() {
			@Override
			public Object exec(Object... obj) {
				return onlineManagementDao.getOnlineOrdersInfo((List<Map<String,Object>>) obj[0]);
			}
		});
		return lm;
	}
	@Override
	public List<Map<String, Object>> getOnlineOrderExcelList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return onlineManagementDao.getOnlineOrderExcelList(paramMap);
	}
	@Override
	public List<Map<String, Object>> getOSHistoryList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return onlineManagementDao.getOSHistoryList(paramMap);
	}
	@Override
	public Map<String, Object> saveOnlineOrderList(List<Map<String, Object>> paramMapList) {
		// TODO Auto-generated method stub
		onlineManagementDao.deletetmpList();
		int resultRowCnt = 0;
		Object resultType = null;
		String crud = null;
		
		Map<String, Object> state = new HashMap<String, Object>();
		
		for(Map<String, Object> paramMap : paramMapList){
			crud = (String) paramMap.get("CRUD");
			if(crud != null){				
				if("C".equals(crud)){
					resultRowCnt += onlineManagementDao.insertOnlineOrderList(paramMap);
				} else if("U".equals(crud)){
					resultRowCnt += onlineManagementDao.updateOnlineOrderList(paramMap);
				} else if("D".equals(crud)){
					resultRowCnt += onlineManagementDao.deleteOnlineOrderList(paramMap);
					resultType = 1;
				}
			}
		}
		
		if("C".equals(crud)){
			resultType = onlineManagementDao.saveOnlineOrderList(crud);
		}else if("U".equals(crud)){
			resultType = onlineManagementDao.saveOnlineOrderList(crud);
		}else {
			
		}
		state.put("resultRowCnt", resultRowCnt);
		state.put("resultType", resultType);
		
		return state;
	}
	@Override
	public List<Map<String, Object>> getOnlineSalesB2CInfo(Map<String, Object> paramMap) {
		return onlineManagementDao.getOnlineSalesB2CInfo(paramMap);
	}
	@Override
	public List<Map<String, Object>> getOnlineSalesB2BInfo(Map<String, Object> paramMap) {
		return onlineManagementDao.getOnlineSalesB2BInfo(paramMap);
	}
	@Override
	public List<Map<String, Object>> getPurFixInfo(Map<String, Object> paramMap) {
		return onlineManagementDao.getPurFixInfo(paramMap);
	}
	@Override
	public List<Map<String, Object>> saveOnlineHistoryList(Map<String, Object> paramMap) {
		paramMap.put("crud", "U");
		return onlineManagementDao.updateOnlineHistoryList(paramMap);
	}
	@Override
	public List<Map<String, Object>> getOnlineFixList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return onlineManagementDao.getOnlineFixList(paramMap);
	}
	@Override
	public List<Map<String, Object>> getOnlineFixDetailList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return onlineManagementDao.getOnlineFixDetailList(paramMap);
	}
	@Override
	public List<Map<String, Object>> saveOnlineFixList(Map<String, String> paramMap) {
		// TODO Auto-generated method stub
		return onlineManagementDao.saveOnlineFixList(paramMap);
	}
	@Override
	public int saveOSFDList(List<Map<String, Object>> paramMapList) {
		int resultRow = 0;
		for(Map<String, Object> paramMap : paramMapList){
			Object crud = paramMap.get("CRUD");
			if(crud != null){				
				if("U".equals(crud)){
					resultRow += onlineManagementDao.updateOSFDList(paramMap);
				} 
			}
		}
		return resultRow;
	}
	@Override
	public List<Map<String, Object>> TransmissionToWMS(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return onlineManagementDao.TransmissionToWMS(paramMap);
	}
	
}
