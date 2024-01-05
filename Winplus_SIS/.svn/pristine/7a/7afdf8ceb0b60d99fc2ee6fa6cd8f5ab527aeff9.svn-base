package com.samyang.winplus.common.system.model;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.samyang.winplus.common.system.annotation.LUI;

public class EmpSessionDto implements Serializable {
	
	private static Logger logger = LoggerFactory.getLogger(EmpSessionDto.class);
	
	private static final long serialVersionUID = -8422008501248213631L;
	
	/*사이트 공통*/
	String login_id;					//아이디
	String result_cd;					//정상로그인 후 메세지를 보여줘야 하는지 용도
	String site_div_cd;					//SIS, CS, PS 로그인 사이트 구분
	@LUI
	String emp_no;						//사번
	@LUI
	String emp_nm;						//이름
	@LUI
	String orgn_delegate_cd;         	//대표조직코드
	String orgn_delegate_nm;         	//대표조직명
	@LUI
	String orgn_cd;						//조직코드
	String orgn_nm;						//조직명
	@LUI
	String searchable_auth_cd;			//검색권한코드
	String message;						//로그인후 보여줘야하는 메세지
	String board_publish_scope_part;	//로그인한 유저가 볼수 있는 게시물 범위 콤보박스 생성용
	String board_publish_scope_cd;		//로그인한 유저가 볼수 있는 게시물 범위 코드
	
	/*===========사이트 구분 : SIS 시작===========*/
	String emp_no_oriz;					// 오리지널 사용자 사번(세션변경 용도)
	String emp_nm_oriz;					// 오리지널 사용자 이름(세션변경 용도)
	@LUI
	boolean is_manager;					//최고관리자 인지
	@LUI
	String orgn_div_cd;					//법인구분코드
	String orgn_div_nm;					//법인구분명
	
	String dlv_duty_cd;					//직책구분코드
	String dlv_bsn_cd;					//업무구분코드
	String mbtlnum;						//사원 핸드폰번호
	String email;						//사원 이메일
	String addr;						//사원 주소
	String orgn_zip_no;					//조직 우편번호
	String orgn_addr;					//조직 주소
	String orgn_addr2;					//조직 상세주소
	String orgn_tel_num;				//조직 전화번호
	boolean is_oper_team;				//사용자의 권한(명)이 최고관리자는 아니지만 최고관리자 권한을 사용해야하는 팀인지
	/*===========사이트 구분 : SIS 끝 ===========*/
	
	/*===========사이트 구분 : CS 시작===========*/
	String custmr_cd;
	String custmr_nm;
	String custmr_ceonm;
	/*===========사이트 구분 : CS 끝  ===========*/
	
	/*담당자 관련 시작 - 사용할 수도 있음 (2019-11-26)*/
	String member_cd; 					//멤버코드
	String member_nm; 					//멤버이름
	String member_warea_cd;  			//지역코드
	String member_warea_nm;  			//지역명
	String member_team_cd;  			//팀코드
	String member_team_nm;				//팀명
	String member_companyMobile_num; 	//상담원 회사지급 mobile 번호
	String member_InPhone;				//내선번호
	String member_CTI;					//CTI 사용여부
	String member_TManager;     		//상담팀장 여부
	
	//CTI 이용 직원용 - 미사용중 (2019-11-26)
//	String call_success_cnt;			//통화성공 횟수
//	String call_out_cnt;				//아웃바운드 시도 횟수
//	String call_in_cnt;					//인바운드 시도 횟수
//	String call_mobile_cnt;				//모바일 시도 횟수
//	String counseler;					//상담사 여부
//	String goal_month;					//목표월
//	String goal_amount;					//목표 금액
//	String achieve_percent;				//달성률
//	String achieve_amount;				//달성 금액
//	String reamain_amount;				//남은 금액
	/*담당자 관련 끝*/
	
	
//	List<AuthorDto> authorDtoList;
//	String sys_div_cd;

	
	//***************************************************************************************************************
	//***************************************************************************************************************
	//***************************************************************************************************************
	//*********************자동 getter 생성시 is로 시작하는 필드도 반드시 get으로 시작해야함*************************
	//***************************************************************************************************************
	//***************************************************************************************************************
	//***************************************************************************************************************
	public String getLogin_id() {
		return login_id;
	}

	public void setLogin_id(String login_id) {
		this.login_id = login_id;
	}

	public String getResult_cd() {
		return result_cd;
	}

	public void setResult_cd(String result_cd) {
		this.result_cd = result_cd;
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

	public String getEmp_nm() {
		return emp_nm;
	}

	public void setEmp_nm(String emp_nm) {
		this.emp_nm = emp_nm;
	}

	public String getOrgn_delegate_cd() {
		return orgn_delegate_cd;
	}
	
	public void setOrgn_delegate_cd(String orgn_delegate_cd) {
		this.orgn_delegate_cd = orgn_delegate_cd;
	}
	
	public String getOrgn_delegate_nm() {
		return orgn_delegate_nm;
	}
	
	public void setOrgn_delegate_nm(String orgn_delegate_nm) {
		this.orgn_delegate_nm = orgn_delegate_nm;
	}
	
	public String getOrgn_cd() {
		return orgn_cd;
	}

	public void setOrgn_cd(String orgn_cd) {
		this.orgn_cd = orgn_cd;
	}

	public String getOrgn_nm() {
		return orgn_nm;
	}

	public void setOrgn_nm(String orgn_nm) {
		this.orgn_nm = orgn_nm;
	}
	
	public String getSearchable_auth_cd() {
		return searchable_auth_cd;
	}

	public void setSearchable_auth_cd(String searchable_auth_cd) {
		this.searchable_auth_cd = searchable_auth_cd;
	}

	public String getMessage() {
		return message;
	}
	
	public void setMessage(String message) {
		this.message = message;
	}
	
	public String getBoard_publish_scope_part() {
		return board_publish_scope_part;
	}

	public void setBoard_publish_scope_part(String board_publish_scope_part) {
		this.board_publish_scope_part = board_publish_scope_part;
	}
	
	public String getBoard_publish_scope_cd() {
		return board_publish_scope_cd;
	}

	public void setBoard_publish_scope_cd(String board_publish_scope_cd) {
		this.board_publish_scope_cd = board_publish_scope_cd;
	}

	public String getEmp_no_oriz() {
		return emp_no_oriz;
	}

	public void setEmp_no_oriz(String emp_no_oriz) {
		this.emp_no_oriz = emp_no_oriz;
	}

	public String getEmp_nm_oriz() {
		return emp_nm_oriz;
	}

	public void setEmp_nm_oriz(String emp_nm_oriz) {
		this.emp_nm_oriz = emp_nm_oriz;
	}

	public boolean getIs_manager() {
		return is_manager;
	}

	public void setIs_manager(boolean is_manager) {
		this.is_manager = is_manager;
	}

	public String getOrgn_div_cd() {
		return orgn_div_cd;
	}

	public void setOrgn_div_cd(String orgn_div_cd) {
		this.orgn_div_cd = orgn_div_cd;
	}

	public String getOrgn_div_nm() {
		return orgn_div_nm;
	}

	public void setOrgn_div_nm(String orgn_div_nm) {
		this.orgn_div_nm = orgn_div_nm;
	}

	public String getDlv_duty_cd() {
		return dlv_duty_cd;
	}

	public void setDlv_duty_cd(String dlv_duty_cd) {
		this.dlv_duty_cd = dlv_duty_cd;
	}

	public String getDlv_bsn_cd() {
		return dlv_bsn_cd;
	}

	public void setDlv_bsn_cd(String dlv_bsn_cd) {
		this.dlv_bsn_cd = dlv_bsn_cd;
	}

	public String getMbtlnum() {
		return mbtlnum;
	}

	public void setMbtlnum(String mbtlnum) {
		this.mbtlnum = mbtlnum;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getOrgn_zip_no() {
		return orgn_zip_no;
	}

	public void setOrgn_zip_no(String orgn_zip_no) {
		this.orgn_zip_no = orgn_zip_no;
	}

	public String getOrgn_addr() {
		return orgn_addr;
	}

	public void setOrgn_addr(String orgn_addr) {
		this.orgn_addr = orgn_addr;
	}

	public String getOrgn_addr2() {
		return orgn_addr2;
	}

	public void setOrgn_addr2(String orgn_addr2) {
		this.orgn_addr2 = orgn_addr2;
	}

	public String getOrgn_tel_num() {
		return orgn_tel_num;
	}

	public void setOrgn_tel_num(String orgn_tel_num) {
		this.orgn_tel_num = orgn_tel_num;
	}

	public boolean getIs_oper_team() {
		return is_oper_team;
	}

	public void setIs_oper_team(boolean is_oper_team) {
		this.is_oper_team = is_oper_team;
	}

	public String getCustmr_cd() {
		return custmr_cd;
	}

	public void setCustmr_cd(String custmr_cd) {
		this.custmr_cd = custmr_cd;
	}

	public String getCustmr_nm() {
		return custmr_nm;
	}

	public void setCustmr_nm(String custmr_nm) {
		this.custmr_nm = custmr_nm;
	}

	public String getCustmr_ceonm() {
		return custmr_ceonm;
	}

	public void setCustmr_ceonm(String custmr_ceonm) {
		this.custmr_ceonm = custmr_ceonm;
	}

	public String getMember_cd() {
		return member_cd;
	}

	public void setMember_cd(String member_cd) {
		this.member_cd = member_cd;
	}

	public String getMember_nm() {
		return member_nm;
	}

	public void setMember_nm(String member_nm) {
		this.member_nm = member_nm;
	}

	public String getMember_warea_cd() {
		return member_warea_cd;
	}

	public void setMember_warea_cd(String member_warea_cd) {
		this.member_warea_cd = member_warea_cd;
	}

	public String getMember_warea_nm() {
		return member_warea_nm;
	}

	public void setMember_warea_nm(String member_warea_nm) {
		this.member_warea_nm = member_warea_nm;
	}

	public String getMember_team_cd() {
		return member_team_cd;
	}

	public void setMember_team_cd(String member_team_cd) {
		this.member_team_cd = member_team_cd;
	}

	public String getMember_team_nm() {
		return member_team_nm;
	}

	public void setMember_team_nm(String member_team_nm) {
		this.member_team_nm = member_team_nm;
	}

	public String getMember_companyMobile_num() {
		return member_companyMobile_num;
	}

	public void setMember_companyMobile_num(String member_companyMobile_num) {
		this.member_companyMobile_num = member_companyMobile_num;
	}

	public String getMember_InPhone() {
		return member_InPhone;
	}

	public void setMember_InPhone(String member_InPhone) {
		this.member_InPhone = member_InPhone;
	}

	public String getMember_CTI() {
		return member_CTI;
	}

	public void setMember_CTI(String member_CTI) {
		this.member_CTI = member_CTI;
	}

	public String getMember_TManager() {
		return member_TManager;
	}

	public void setMember_TManager(String member_TManager) {
		this.member_TManager = member_TManager;
	}
	


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---리플랙션 관련 시작---
	private static final Field[] fields = EmpSessionDto.class.getDeclaredFields();
	private static final List<String> fieldNameList = new ArrayList<String>();
	private static final List<Method> fieldGetMethodList = new ArrayList<Method>();
	static {
		String fieldName = "";
		Method getMethod = null;
		for(Field f : fields) {
			fieldName = f.getName();
			fieldNameList.add(fieldName);
			try {
				getMethod = null;
				getMethod = EmpSessionDto.class.getMethod("get" + (fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1)));
				fieldGetMethodList.add(getMethod);
			} catch (NoSuchMethodException e) {
				fieldGetMethodList.add(getMethod);
				//logger.debug("not error : undefined getMethod continue : " + fieldName);
			} catch (SecurityException e) {
				fieldGetMethodList.add(getMethod);
				logger.error(e.toString());
			}
		}
	}
	
	private static final ObjectMapper mapper = new ObjectMapper();
	public String getLui(){
		Map<String,Object> map = new HashMap<String, Object>();
		
		for(java.lang.reflect.Field field : fields){
			LUI lui = field.getAnnotation(LUI.class);
			if(lui != null){
				try {
					map.put("LUI_"+field.getName(),field.get(this));
				} catch (IllegalArgumentException | IllegalAccessException e) {
					logger.error("EmpSessionDto.java 예외발생 : " + e.toString());
				}
			}
		}
		
		String objectToJson = "";
		try {
			objectToJson = mapper.writeValueAsString(map);
		} catch (JsonProcessingException e) {
			logger.error("EmpSessionDto.java 예외발생 : 객체 => json");
		}
		
		return objectToJson;
	}
	
	@Override
	public String toString() {
		String totalString = "***** EmpSessionDto *****\n";
		Method getMethod = null;
		for(int i=0; i<fieldNameList.size(); i++) {
			totalString += fieldNameList.get(i) + " : ";
			try {
				getMethod = fieldGetMethodList.get(i);
				if(getMethod != null) {
					totalString += String.valueOf(fieldGetMethodList.get(i).invoke(this)) + "\n";
				}else {
					totalString += "getter,setter 선언이 되어 있지 않습니다." + "\n";
				}
			} catch (IllegalAccessException e) {
				logger.error(e.toString());
			} catch (IllegalArgumentException e) {
				logger.error(e.toString());
			} catch (InvocationTargetException e) {
				logger.error(e.toString());
			}
		}
		return totalString;
	}
	//---리플랙션 관련 종료---
}
