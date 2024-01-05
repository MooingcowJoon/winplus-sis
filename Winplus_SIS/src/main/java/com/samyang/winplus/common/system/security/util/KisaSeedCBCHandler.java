package com.samyang.winplus.common.system.security.util;

import org.springframework.stereotype.Repository;

/** 
 * KISA SEED CBC 처리기
 * @since 2017.02.16
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2017.02.16 / 김종훈 / 신규 생성
 *********************************************
 */
@Repository("kisaSeedCBCHandler")
public interface KisaSeedCBCHandler {
	
	/**
	  * decrypt - 복호화
	  * @author 김종훈
	  * @param encString
	  * @return String
	  */
	public String decrypt(String encString);

	/**
	  * encrypt - 암호화
	  * @author 이성현
	  * @param encString
	  * @return String
	  */	
	public String encrypt(String normalString);
}
