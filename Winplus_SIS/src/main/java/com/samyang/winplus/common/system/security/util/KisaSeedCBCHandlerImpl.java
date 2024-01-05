package com.samyang.winplus.common.system.security.util;

import java.io.UnsupportedEncodingException;

import org.apache.commons.codec.binary.Base64;
import org.springframework.stereotype.Repository;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/** 
 * KISA SEED CBC 처리기 (구현체)
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
public class KisaSeedCBCHandlerImpl implements KisaSeedCBCHandler {
		
	/* 개인키 */
	private final static String privateKeyString = "12487531241257897";
	/* CBC키 */
	private final static String cbcKeyString = "924878954241212697";
			
	private final static Logger logger = LoggerFactory.getLogger(KisaSeedCBCHandlerImpl.class);
	
	
	// * 암호화 필요할 때만 주석 풀기
	/*public static void main(String[] args){
		String encString = new KisaSeedCBCHandlerImpl().encrypt("암호화테스트");
		String dd = new KisaSeedCBCHandlerImpl().decrypt("Vh+z711t3EtiK2RIGPH7GZeRpXsIfKVH3V/YtDfVwzh6ZykzGRLRIkPhZhDgUD+XbQo6Pxp6i5PRubf2iUB60v3GyGa4CLOmuGj9hUy+miE=");
		System.out.println(dd);
	}*/
	@Override
	public String encrypt(String normalString){
		String resultStr = null;
				
		try {
			byte[] privateKey = privateKeyString.getBytes();
			byte[] cbcKey = cbcKeyString.getBytes();			
			byte[] normalByte = normalString.getBytes("UTF-8");
			int normalByteLength = normalByte.length;
			
			byte[] encByte = KisaSeedCBC.SEED_CBC_Encrypt(privateKey, cbcKey, normalByte, 0, normalByteLength);		
			resultStr = Base64.encodeBase64String(encByte);
		} catch (UnsupportedEncodingException e) {
			logger.error(e.toString());
			return null;
		}
		
		return resultStr;
	}
	
	/**
	  * decrypt - 복호화
	  * @author 김종훈
	  * @param encString
	  * @return String
	  */
	@Override
	public String decrypt(String encString){
		String resultStr = null;
		try {
			byte[] privateKey = privateKeyString.getBytes();
			byte[] cbcKey = cbcKeyString.getBytes();		
			
			byte[] encByte = Base64.decodeBase64(encString);
			int encByteLength = encByte.length;
			byte[] normalByte = KisaSeedCBC.SEED_CBC_Decrypt(privateKey, cbcKey, encByte, 0, encByteLength);
			resultStr = new String(normalByte, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			logger.error(e.toString());
			return null;
		}
		
		return resultStr;
	}
}
