package com.samyang.winplus.common.system.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @Class : LUI.java
 * @Description : 커스텀 어노테이션 생성
 * @Modification Information  
 * 
 *   수정일          수정자                내용
 * -----------     ----------      ----------------------
 * 2019. 8. 15.      조승현              최초생성
 * 
 * @author 조승현
 * @since 2019. 8. 15.
 * @version 1.0
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface LUI { //Login User Info

}
