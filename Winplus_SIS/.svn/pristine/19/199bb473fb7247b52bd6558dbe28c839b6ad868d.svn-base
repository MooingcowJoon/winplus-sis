package com.samyang.winplus.common.system.security.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.springframework.stereotype.Component;

@Component("haeSha512")
public class HaeSha512 {
	
 //hae_core_1q2w3e4r!
    
    /**
     * 단방향 암호화 로직으로 암호화된 데이터를 리턴한다.
     * 
     * @param data 암호화 시킬 data
     * @return @return output 암호화된 데이터
     * @throws NoSuchAlgorithmException MessageDigest의 Exception을 Throws 한다.
     */
    public String haeEncrypt(String input) throws NoSuchAlgorithmException {
    	return haeEncrypt(input, null);
    }
    
    /**
     * 
     * 단방향 암호화 로직으로 암호화된 데이터를 리턴한다.
     *
     * @param data 암호화 시킬 data
     * @param key  암호화 시 사용할 Key data
     * @return output 암호화된 데이터
     * @throws NoSuchAlgorithmException MessageDigest의 Exception을 Throws 한다.
     */
    public String haeEncrypt(String input, String keyParam) throws NoSuchAlgorithmException {
        
        String output = null;
        
        StringBuilder sb = new StringBuilder();
        
        MessageDigest md = MessageDigest.getInstance("SHA-512");
        String key = "";
        if (null == keyParam || "".equals(keyParam)) {
        	key = "GOODC9776WWW";
        }
        
        String sum = input + key;
        
        md.update(sum.getBytes());
        
        byte[] msgb = md.digest();
        
        for(int i=0; i < msgb.length; i++) {
            byte temp = msgb[i];
            String str = Integer.toHexString(temp & 0xFF);
            while (str.length() < 2) {
            	String strAdd = "0" + str;
                str = strAdd;
            }
            str = str.substring(str.length() - 2);
            sb.append(str);
        }
        output = sb.toString();
        
        return output;
    }
}
