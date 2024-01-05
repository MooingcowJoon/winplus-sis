package com.samyang.winplus.common.system.config;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * @Class : ServerVariable.java
 * @Description : 설정 파일 url 정보 가져오기
 * @Modification Information  
 * 
 *   수정일          수정자                내용
 * -----------     ----------      ----------------------
 * 2019. 11. 21.      조승현              최초생성
 * 
 * @author 조승현
 * @since 2019. 11. 21.
 * @version 1.0
 */
@Component
@EnableConfigurationProperties
@ConfigurationProperties(prefix = "url")
public class ServerVariable {
    private Map<String, String> uploadAttachFileSaveRootDirectoryList = new HashMap<String, String>();

	public Map<String, String> getUploadAttachFileSaveRootDirectoryList() {
		return uploadAttachFileSaveRootDirectoryList;
	}

	public void setUploadAttachFileSaveRootDirectoryList(Map<String, String> uploadAttachFileSaveRootDirectoryList) {
		this.uploadAttachFileSaveRootDirectoryList = uploadAttachFileSaveRootDirectoryList;
	}
    
}