package com.samyang.winplus.sis.member.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.samyang.winplus.common.system.util.LoofInterface;
import com.samyang.winplus.common.system.util.LoofUtilObject;
import com.samyang.winplus.sis.member.dao.MemberDao;


@Service("MemberService")
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	MemberDao memberDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	@Override
	public List<Map<String, String>> getMemberList(Map<String, Object> paramMap) {
		return memberDao.getMemberList(paramMap);
	}

	@Override
	public Map<String, Object> getMemberInfo(Map<String, Object> paramMap) {
		return memberDao.getMemberInfo(paramMap);
	}

	@Override
	public List<Map<String, String>> getMemberGroupComboList(Map<String, Object> paramMap) {
		return memberDao.getMemberGroupComboList(paramMap);
	}

	@Override
	public Map<String, Object> crudMemberInfo(Map<String, Object> paramMap) {
		return memberDao.crudMemberInfo(paramMap);
	}

	@Override
	public List<Map<String, String>> getTransactionHistory(Map<String, Object> paramMap) {
		return memberDao.getTransactionHistory(paramMap);
	}

	@Override
	public List<Map<String, String>> getTaxExemptAmount(Map<String, Object> paramMap) {
		return memberDao.getTaxExemptAmount(paramMap);
	}
	
	@Override
	public List<Map<String, String>> getMemberBestGoodsList(Map<String, Object> paramMap) {
		return memberDao.getMemberBestGoodsList(paramMap);
	}

	@Override
	public List<Map<String, String>> getBestMemberList(Map<String, Object> paramMap) {
		return memberDao.getBestMemberList(paramMap);
	}

	@Override
	public Map<String, Object> getMemberMonthlyTrend(Map<String, Object> paramMap) {
		Map<String,Object> resultMap = new HashMap<String, Object>();
		resultMap.put("gridDataList", memberDao.getMemberMonthlyTrend(paramMap));
		resultMap.put("gridSum", memberDao.getMemberMonthlyTrend_sum(paramMap));
		resultMap.put("gridAvgByMonth", memberDao.getMemberMonthlyTrend_average_byMonth(paramMap));
		resultMap.put("gridAvgByCount", memberDao.getMemberMonthlyTrend_average_byCount(paramMap));
		return resultMap;

	}

	@Transactional
	@Override
	public void crudMemberGoodsPrice(Map<String, Object> paramMap) {
		
		for(Map<String, Object> map : ((List<Map<String, Object>>) paramMap.get("C"))){
			memberDao.insertMemberGoodsPrice(map);
		}
		
		for(Map<String, Object> map : ((List<Map<String, Object>>) paramMap.get("U"))){
			memberDao.updateMemberGoodsPrice(map);
		}
		
		for(Map<String, Object> map : ((List<Map<String, Object>>) paramMap.get("D"))){
			memberDao.deleteMemberGoodsPrice(map);
		}
	}

	@Override
	public List<Map<String, String>> getMemberTransactionLedgerList(Map<String, Object> paramMap) {
		return memberDao.getMemberTransactionLedgerList(paramMap);
	}

	@Override
	public List<Map<String, String>> memberSearch(Map<String, Object> paramMap) {
		return memberDao.memberSearch(paramMap);
	}

	@Override
	@Transactional
	public void updateMemberType(List<Map<String, Object>> paramListMap) {
		for(Map<String,Object> paramMap : paramListMap) {
			memberDao.updateMemberType(paramMap);
		} 
	}

	@Override
	@Transactional
	public void updateMemberABC(List<Map<String, Object>> paramListMap) {
		for(Map<String,Object> paramMap : paramListMap) {
			memberDao.updateMemberABC(paramMap);
		}
	}

	@Override
	@Transactional
	public void updateMemberState(List<Map<String, Object>> paramListMap) {
		for(Map<String,Object> paramMap : paramListMap) {
			memberDao.updateMemberState(paramMap);
		}
	}

	@Override
	@Transactional
	public void updateMemberTaxYN(List<Map<String, Object>> paramListMap) {
		for(Map<String,Object> paramMap : paramListMap) {
			memberDao.updateMemberTaxYN(paramMap);
		}
	}

	@Override
	@Transactional
	public void updateMemberChgAmtType(List<Map<String, Object>> paramListMap) {
		for(Map<String,Object> paramMap : paramListMap) {
			memberDao.updateMemberChgAmtType(paramMap);
		}
	}

	@Override
	public List<Map<String, String>> getMemberDesignationList(Map<String, Object> paramMap) {
		return memberDao.getMemberDesignationList(paramMap);
	}

	@Override
	public List<Map<String, String>> getMemberGroupList(Map<String, Object> paramMap) {
		return memberDao.getMemberGroupList(paramMap);
	}

	@Override
	public List<Map<String, String>> getMemberListInGroup(Map<String, Object> paramMap) {
		return memberDao.getMemberListInGroup(paramMap);
	}
	
	@Transactional
	@Override
	public void crudMemberGroup(Map<String, Object> paramMap) {
		for(Map<String, Object> map : ((List<Map<String, Object>>) paramMap.get("C"))){
			memberDao.insertMemberGroup(map);
		}
		
		for(Map<String, Object> map : ((List<Map<String, Object>>) paramMap.get("U"))){
			memberDao.updateMemberGroup(map);
		}
		
		for(Map<String, Object> map : ((List<Map<String, Object>>) paramMap.get("D"))){
			memberDao.deleteMemberGroup(map);
		}
	}

	@Transactional
	@Override
	public void crudMemberListInGroup(Map<String, Object> paramMap) {
		for(Map<String, Object> map : ((List<Map<String, Object>>) paramMap.get("C"))) {
			memberDao.insertMemberListInGroup(map);
		}
		
		for(Map<String, Object> map : ((List<Map<String, Object>>) paramMap.get("U"))) {
			memberDao.updateMemberListInGroup(map);
		}
		
		for(Map<String, Object> map : ((List<Map<String, Object>>) paramMap.get("D"))) {
			memberDao.deleteMemberListInGroup(map);
		}
	}

	@Override
	public List<Map<String, Object>> getMemberWSalePrice(Map<String, Object> paramMap) {
		LoofUtilObject l = new LoofUtilObject();
		List<Map<String, Object>> lm = null;
		lm = l.selectAfterLoofBigMapList((List<Map<String, Object>>) paramMap.get("loadGoodsList"), new LoofInterface() {
			@Override
			public Object exec(Object... obj) {
				return memberDao.getMemberWSalePrice((List<Map<String,Object>>) obj[0]);
			}
		});
		return lm;
	}
	
	
	@Override
	public List<Map<String, Object>> getMemberGoodsPrice(Map<String, Object> paramMap) {
		return memberDao.getMemberGoodsPrice(paramMap);
	}

	@Override
	public List<Map<String, Object>> getMemberInfoLog(Map<String, Object> paramMap) {
		return memberDao.getMemberInfoLog(paramMap);
	}
	
}
