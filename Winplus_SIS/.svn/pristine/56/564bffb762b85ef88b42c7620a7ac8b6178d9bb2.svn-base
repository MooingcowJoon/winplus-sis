package com.samyang.winplus.common.system.model;

import java.io.Serializable;

public class LoginDto implements Serializable {
	
	private static final long serialVersionUID = -539408208877065372L;
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	//로그인 시도용
	private String login_id;			//login_id
	private String password;			//비밀번호
	private String site_div_cd;			//사이트구분 : 'SIS','CS'
	
	//로그인 시도후 리턴
	private String emp_no;				//SIS:사번, CS:거래처 코드
	private int password_error_limit;	//비밀번호 오류 가능 횟수 제한
	private int password_error_time;	//비밀번호 오류 횟수
	private String result_cd;			//로그인 시도 후 확인된 에러 코드
	
	//비밀번호 변경시 사용
	private String before_password;		//이전 비밀번호
	
	//로그인 시도 로그 저장용
	private String inOut;				//로그인로그아웃 여부(IN/OUT)
	private String login_atpt_ip;		//ip
	private String login_atpt_dt;		//사용안함
	
	//PDA용 추가
	private String orgn_div_cd;			//조직구분코드
	private String orgn_cd;				//조직코드
	private String result;				//로그인 결과
	
	
	public String getLogin_id() {
		return login_id;
	}
	public void setLogin_id(String login_id) {
		this.login_id = login_id;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getSite_div_cd() {
		return site_div_cd;
	}
	public void setSite_div_cd(String site_div_cd) {
		this.site_div_cd = site_div_cd;
	}
	public String getEmp_no() {
		return emp_no;
	}
	public void setEmp_no(String emp_no) {
		this.emp_no = emp_no;
	}
	public int getPassword_error_limit() {
		return password_error_limit;
	}
	public void setPassword_error_limit(int password_error_limit) {
		this.password_error_limit = password_error_limit;
	}
	public int getPassword_error_time() {
		return password_error_time;
	}
	public void setPassword_error_time(int password_error_time) {
		this.password_error_time = password_error_time;
	}
	public String getResult_cd() {
		return result_cd;
	}
	public void setResult_cd(String result_cd) {
		this.result_cd = result_cd;
	}
	public String getBefore_password() {
		return before_password;
	}
	public void setBefore_password(String before_password) {
		this.before_password = before_password;
	}
	public String getInOut() {
		return inOut;
	}
	public void setInOut(String inOut) {
		this.inOut = inOut;
	}
	public String getLogin_atpt_ip() {
		return login_atpt_ip;
	}
	public void setLogin_atpt_ip(String login_atpt_ip) {
		this.login_atpt_ip = login_atpt_ip;
	}
	public String getLogin_atpt_dt() {
		return login_atpt_dt;
	}
	public void setLogin_atpt_dt(String login_atpt_dt) {
		this.login_atpt_dt = login_atpt_dt;
	}
	public String getOrgn_div_cd() {
		return orgn_div_cd;
	}
	public void setOrgn_div_cd(String orgn_div_cd) {
		this.orgn_div_cd = orgn_div_cd;
	}
	public String getOrgn_cd() {
		return orgn_cd;
	}
	public void setOrgn_cd(String orgn_cd) {
		this.orgn_cd = orgn_cd;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	
	@Override
	public String toString() {
		return "LoginDto [login_id=" + login_id + ", password=" + password + ", site_div_cd=" + site_div_cd
				+ ", emp_no=" + emp_no + ", password_error_limit=" + password_error_limit + ", password_error_time="
				+ password_error_time + ", result_cd=" + result_cd + ", before_password=" + before_password + ", inOut="
				+ inOut + ", login_atpt_ip=" + login_atpt_ip + ", login_atpt_dt=" + login_atpt_dt + ", orgn_div_cd="
				+ orgn_div_cd + ", orgn_cd=" + orgn_cd + ", result=" + result + "]";
	}
	
}
