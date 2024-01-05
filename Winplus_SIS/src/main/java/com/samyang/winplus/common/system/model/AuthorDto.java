package com.samyang.winplus.common.system.model;

import java.io.Serializable;

public class AuthorDto implements Serializable {
	
	private static final long serialVersionUID = -6742008784348729601L;
	
	private String sys_div_cd;
	private String author_cd;
	private String author_nm;
	private String author_scope_cd;	
	
	public String getSys_div_cd() {
		return sys_div_cd;
	}
	public void setSys_div_cd(String sys_div_cd) {
		this.sys_div_cd = sys_div_cd;
	}
	public String getAuthor_cd() {
		return author_cd;
	}
	public void setAuthor_cd(String author_cd) {
		this.author_cd = author_cd;
	}
	public String getAuthor_nm() {
		return author_nm;
	}
	public void setAuthor_nm(String author_nm) {
		this.author_nm = author_nm;
	}
	public String getAuthor_scope_cd() {
		return author_scope_cd;
	}
	public void setAuthor_scope_cd(String author_scope_cd) {
		this.author_scope_cd = author_scope_cd;
	}
}
