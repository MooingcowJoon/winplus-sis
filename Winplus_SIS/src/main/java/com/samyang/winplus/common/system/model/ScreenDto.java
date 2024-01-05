package com.samyang.winplus.common.system.model;

import java.io.Serializable;

public class ScreenDto implements Serializable {
	
	private static final long serialVersionUID = 2481196087225759183L;
	
	String menu_cd;
	String menu_nm;
	String scrin_cd;
	String scrin_nm;
	String scrin_path;
	String use_yn;
	String cmmn_yn;	
	String author_cd;
	
	public String getMenu_cd() {
		return menu_cd;
	}
	public void setMenu_cd(String menu_cd) {
		this.menu_cd = menu_cd;
	}
	public String getMenu_nm() {
		return menu_nm;
	}
	public void setMenu_nm(String menu_nm) {
		this.menu_nm = menu_nm;
	}
	public String getScrin_cd() {
		return scrin_cd;
	}
	public void setScrin_cd(String scrin_cd) {
		this.scrin_cd = scrin_cd;
	}
	public String getScrin_nm() {
		return scrin_nm;
	}
	public void setScrin_nm(String scrin_nm) {
		this.scrin_nm = scrin_nm;
	}
	public String getScrin_path() {
		return scrin_path;
	}
	public void setScrin_path(String scrin_path) {
		this.scrin_path = scrin_path;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getCmmn_yn() {
		return cmmn_yn;
	}
	public void setCmmn_yn(String cmmn_yn) {
		this.cmmn_yn = cmmn_yn;
	}
	public String getAuthor_cd() {
		return author_cd;
	}
	public void setAuthor_cd(String author_cd) {
		this.author_cd = author_cd;
	}
}
