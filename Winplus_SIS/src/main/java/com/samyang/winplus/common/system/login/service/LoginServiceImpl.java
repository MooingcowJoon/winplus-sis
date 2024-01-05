package com.samyang.winplus.common.system.login.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samyang.winplus.common.system.login.dao.LoginDao;
import com.samyang.winplus.common.system.model.EmpSessionDto;
import com.samyang.winplus.common.system.model.LoginDto;
import com.samyang.winplus.common.system.security.util.HaeSha512;
import com.samyang.winplus.common.system.util.CommonException;
/** 
 * 로그인 서비스 (구현체)
 * @since 2016.11.07
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.11.07 / 김종훈 / 신규 생성
 *********************************************
 */
@Service("loginService")
public class LoginServiceImpl implements LoginService {

	@Autowired
	LoginDao loginDao;
	
	@Autowired
	HaeSha512 haeSha512;
	
	/* slf4j Logger */
	private final Logger logger = LoggerFactory.getLogger(LoginServiceImpl.class);

	/**
	  * 사용자 로그인 시도 로그 입력
	  * @author 김종훈
	  * @param loginDto
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int saveLoginTryLog(LoginDto loginDto) throws SQLException, Exception {
		return loginDao.insertLoginTryLog(loginDto);
	}
	
	/**
	  * 사용자 로그인 처리
	  * @author 조승현
	  * @param loginDto
	  * @return LoginDto
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Object loginTry(LoginDto loginDto) throws SQLException, Exception {
		
		//로그인 가능 확인
		LoginDto resultLoginDto = loginDao.getLoginDto(loginDto);
		
		//로그인 시도 로그 저장
		resultLoginDto.setLogin_atpt_ip(loginDto.getLogin_atpt_ip());
		resultLoginDto.setInOut("IN");
		
		saveLoginTryLog(resultLoginDto);
		
		//로그인 결과
		if(resultLoginDto.getResult_cd().equals("-1001")) { 			//존재하지 않는 사용자
				
		}else if(resultLoginDto.getResult_cd().equals("-1002")) { 		//비밀번호 오류 횟수 초과
			
		}else if(resultLoginDto.getResult_cd().equals("-1003")) { 		//비밀번호 오류
			resultLoginDto.setPassword_error_time(resultLoginDto.getPassword_error_time() + 1);
			loginDao.updateLoginPasswordErrorTime(resultLoginDto);
			
		}else if(resultLoginDto.getResult_cd().equals("-1004")) { 		//비밀번호 만료
			
		}else if(resultLoginDto.getResult_cd().equals("-1005")) { 		//정상로그인 + 비밀번호 초기화 상태 변경 필요 메세지 알림
			resultLoginDto.setPassword_error_time(0);
			loginDao.updateLoginPasswordErrorTime(resultLoginDto);
			
			EmpSessionDto empSessionDto = getEmpSessionDto(resultLoginDto);
			empSessionDto.setLogin_id(resultLoginDto.getLogin_id());
			empSessionDto.setResult_cd(resultLoginDto.getResult_cd());
			empSessionDto.setSite_div_cd(resultLoginDto.getSite_div_cd());
			return empSessionDto;
			
		}else if(resultLoginDto.getResult_cd().equals("0")) {			//정상 로그인
			resultLoginDto.setPassword_error_time(0);
			loginDao.updateLoginPasswordErrorTime(resultLoginDto);
			
			EmpSessionDto empSessionDto = getEmpSessionDto(resultLoginDto);
			empSessionDto.setLogin_id(resultLoginDto.getLogin_id());
			empSessionDto.setSite_div_cd(resultLoginDto.getSite_div_cd());
			return empSessionDto;
		}
		
		return resultLoginDto;
	
	}

	/**
	  * 사용자 로그인 정보를 통한 getEmpSessionDto 조회
	  * @author 조승현
	  * @param loginDto
	  * @return EmpSessionDto
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public EmpSessionDto getEmpSessionDto(LoginDto loginDto) throws SQLException, Exception {
		EmpSessionDto empSessionDto = loginDao.getEmpSessionDto(loginDto);
		return empSessionDto;
	}
	
	/**
	  * 사원 비밀번호 변경
	  * @author 김종훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int updatePassword(Map<String, Object> paramMap) throws SQLException, Exception{
		int resultRowCnt = 0;
		/* 요청 정보가 없는 경우 */
		if(paramMap == null){
			throw new CommonException("error.password.invalidRequest");
		} else {
			String emp_no = (String) paramMap.get("EMP_NO");
			String sys_div_cd = (String) paramMap.get("SYS_DIV_CD");
			String now_password = (String) paramMap.get("NOW_PASSWORD");
			String change_password = (String) paramMap.get("CHANGE_PASSWORD");
			String change_password_recnfrm = (String) paramMap.get("CHANGE_PASSWORD_RECNFRM");
			
			if(emp_no == null || emp_no.equals("")
					|| sys_div_cd == null || sys_div_cd.equals("")
					|| now_password == null || now_password.equals("")
					|| change_password == null || change_password.equals("")
					|| change_password_recnfrm == null || change_password_recnfrm.equals("")
					){
				/* 요청 정보가 하나라도 없는 경우 */
				throw new CommonException("error.password.invalidRequest");
			} else if (!change_password.equals(change_password_recnfrm)){
				/* 비밀번호와 비밀번호 재확인 값이 다른 경우 */
				throw new CommonException("error.password.noSamePasswordConfirm");
			} else {
				/* 비밀번호 길이 : 9 ~ 20자 */
				if(change_password.length() > 20 || change_password.length() < 9){
					throw new CommonException("error.password.invalidPasswordLength");
				} else{
					boolean isAlphabetCaseChar = false;
					boolean isNumberChar = false;
					boolean isSpecialChar = false;
					
					for(int i = 0; i < change_password.length(); i++){
						char word = change_password.charAt(i);
//						System.out.println(i + "번째 문자 : " + String.valueOf(word) + "(" + (int)word + ")");
						/* 영대문자 A~Z - ASCII 65~90 */
						if(word >= 65 && word <= 90){
							isAlphabetCaseChar = true;
						}
						/* 영소문자 a~z - ASCII 97~122 */
						else if (word >= 97 && word <= 122){
							isAlphabetCaseChar = true;
						}
						/* 숫자 0~9 - ASCII 48~57 */
						else if (word >= 48 && word <= 57){
							isNumberChar = true;
						}
						/* 특수문자 !(33) @(64) #(35) $(36) %(37) ^(94) &(38) *(42) ((40)  )(41) -(45) +(43) =(61) */
						else if(word == 33 || word == 64 || word == 35 || word == 36
								|| word == 37 || word == 94 || word == 38 || word == 42
								|| word == 40 || word == 41 || word == 45 || word == 43
								|| word == 61 ){
							isSpecialChar = true;
						} else {
							throw new CommonException("error.password.invalidWord");
						}
					}
					
					/* 문자 형식 하나라도 존재 하지 않는 경우 */
					if(!isAlphabetCaseChar || !isNumberChar || !isSpecialChar){
						throw new CommonException("error.password.noWriteAllCharType");
					} else {
						LoginDto loginDto = new LoginDto();
						loginDto.setLogin_id(emp_no);
						LoginDto resultLoginDto = loginDao.getLoginDto(loginDto);
						if(resultLoginDto == null){
							throw new CommonException("error.password.noEmployee");
						} else {
							String login_now_password = resultLoginDto.getPassword();
							String enc_now_password = haeSha512.haeEncrypt(now_password);
							/* 현재 비밀번호와 입력 비밀번호와 다른지 확인 */
							if(!login_now_password.equals(enc_now_password)){
								throw new CommonException("error.password.invalidNowPassword");
							} else {
								String login_before_password = resultLoginDto.getBefore_password();
								String enc_change_password = haeSha512.haeEncrypt(change_password);
								/* 현재 비밀번호와 변경 비밀번호가 같은 경우 */
								if(login_now_password.equals(enc_change_password)){
									throw new CommonException("error.password.noSameNowPassword");
								}
								/* ※ 2개의 동일 비밀번호를 교대로 사용하지 않습니다. */
								/* 이전 비밀번호와 변경 비밀번호가 같은 경우 */
								else if(login_before_password != null && !login_before_password.equals("")
										&& login_before_password.equals(enc_change_password)){
									throw new CommonException("error.password.noSameBeforePassword");
								}
								/* 유효성 모두 통과 후 비밀번호 변경 진행 */
								else {
									paramMap.put("CHANGE_PASSWORD", enc_change_password);
									resultRowCnt += loginDao.updatePassword(paramMap);
								}
							}
						}
					}
				}
			}
		}
		return resultRowCnt;
	}
	
	/**
	  * 사용자별 매뉴 사용 허용 여부 확인
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int getMenuCdCnt(Map<String, Object> paramMap) throws SQLException, Exception {
		return loginDao.getMenuCdCnt(paramMap);
	}
	
	/**
	  * 로그인 사용자 ID 저장여부 확인
	  * @author 주병훈
	  * @param paramMap
	  * @return Map<String, Object>
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getEmpNo(Map<String, Object> paramMap) throws SQLException, Exception {
		return loginDao.getEmpNo(paramMap);
	}
	
	/**
	  * 로그인변경 유효성 확인
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int getLoginChangeCheckCnt(Map<String, Object> paramMap) throws SQLException, Exception {
		return loginDao.getLoginChangeCheckCnt(paramMap);
	}
	
	/**
	  * 로그인변경 유효성 확인
	  * @author 주병훈
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int getLoginChangeCheckAuth(Map<String, Object> paramMap) throws SQLException, Exception {
		return loginDao.getLoginChangeCheckAuth(paramMap);
	}
	
	
	@Override
	public List<Map<String, Object>> getNewUserList() throws  Exception{

		List<Map<String, Object>> newUserList = loginDao.getNewUserList();
		List<Map<String, Object>> mailList = new ArrayList<>();
		int cnt = newUserList.size();
		for(Map<String, Object> dhtmlxParamMap : newUserList){
			
			Map<String, Object> mailDto = new HashMap<String, Object>();
			
			String empNo = (String) dhtmlxParamMap.get("EMP_NO");
			String empNm = (String) dhtmlxParamMap.get("EMP_NM");
			//String charEmail = (String) dhtmlxParamMap.get("CHAR_EMAIL");
			String instDt = (String) dhtmlxParamMap.get("INST_DT");
			String cntStr = ""+cnt;
		
			
			//String recipient = charEmail;
			String subject = "[배민찬] "+empNm+" 님이 시스템에 신규 가입하셨습니다.("+instDt+")";
			String contents = empNm+"("+empNo+") 님 등 "+ cntStr
					+"명이 신규 등록되었습니다. " +
					"수불/원가 관리시스템에 접속하시어 조직 설정 및 권한 설정을 진행하여 주시기 바랍니다."
					;
			
			//mailDto.put("recipient",recipient);
			mailDto.put("subject",subject);
			mailDto.put("contents",contents);
			
			mailList.add(mailDto);
			
		}
		
		return mailList;
	}
	
	/**
	  * 내선번호 가져오기
	  * @author 조승현
	  * @param paramMap
	  * @return String
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public Map<String, Object> getMemberInPhone(LoginDto resultLoginDto) throws SQLException, Exception {
		return loginDao.getMemberInPhone(resultLoginDto);
	}
	
	/**
	  * 내선번호 업데이트
	  * @author 조승현
	  * @param paramMap
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  */
	@Override
	public int updateMemberInPhone(Map<String, Object> paramMap) throws SQLException, Exception{
		return loginDao.updateMemberInPhone(paramMap);
	}


}

	
	
