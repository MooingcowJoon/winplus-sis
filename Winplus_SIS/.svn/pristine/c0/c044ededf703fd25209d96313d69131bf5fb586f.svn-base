package com.samyang.winplus.common.myAccount.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.myAccount.dao.MyAccountDao;

@Service("MyAccountService")
public class MyAccountServiceImpl implements MyAccountService{

	@Autowired
	MyAccountDao myAccountDao;
	
	@Override
	public String passwordChange(Map<String, Object> paramMap) {
		return myAccountDao.passwordChange(paramMap);
	}

}
