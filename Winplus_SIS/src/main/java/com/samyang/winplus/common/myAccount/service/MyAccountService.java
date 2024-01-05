package com.samyang.winplus.common.myAccount.service;

import java.util.Map;

import org.springframework.stereotype.Service;

/**
 * @Class : MyAccountService.java
 * @Description : 내 계정 관련 서비스
 * @Modification Information  
 * 
 *   수정일          수정자                내용
 * -----------     ----------      ----------------------
 * 2019. 12. 15.      조승현              최초생성
 * 
 * @author 조승현
 * @since 2019. 12. 15.
 * @version 1.0
 */
@Service("MyAccountService")
public interface MyAccountService {

	/**
	 * @author 조승현
	 * @param paramMap
	 * @return 변경 결
	 * @description 비밀번호 변경
	 */
	String passwordChange(Map<String, Object> paramMap);

}
