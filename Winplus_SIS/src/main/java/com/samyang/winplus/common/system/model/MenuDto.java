package com.samyang.winplus.common.system.model;

import java.io.Serializable;

public class MenuDto implements Serializable {
	
	private static final long serialVersionUID = 902038584906286086L;
	
	String menu_cd;
	String menu_nm;
	int menu_step;
	String upper_menu_cd;	
	int menu_ordr;
	String folder_yn;
	String scrin_path;
	String use_yn;
	String stre_yn;
	String adit_yn;
	String delete_yn;
	String excel_yn;
	String print_yn;
	
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
	public int getMenu_step() {
		return menu_step;
	}
	public void setMenu_step(int menu_step) {
		this.menu_step = menu_step;
	}
	public String getUpper_menu_cd() {
		return upper_menu_cd;
	}
	public void setUpper_menu_cd(String upper_menu_cd) {
		this.upper_menu_cd = upper_menu_cd;
	}
	public int getMenu_ordr() {
		return menu_ordr;
	}
	public void setMenu_ordr(int menu_ordr) {
		this.menu_ordr = menu_ordr;
	}
	public String getFolder_yn() {
		return folder_yn;
	}
	public void setFolder_yn(String folder_yn) {
		this.folder_yn = folder_yn;
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
	public String getStre_yn() {
		return stre_yn;
	}
	public void setStre_yn(String stre_yn) {
		this.stre_yn = stre_yn;
	}
	public String getAdit_yn() {
		return adit_yn;
	}
	public void setAdit_yn(String adit_yn) {
		this.adit_yn = adit_yn;
	}
	public String getDelete_yn() {
		return delete_yn;
	}
	public void setDelete_yn(String delete_yn) {
		this.delete_yn = delete_yn;
	}
	public String getExcel_yn() {
		return excel_yn;
	}
	public void setExcel_yn(String excel_yn) {
		this.excel_yn = excel_yn;
	}
	public String getPrint_yn() {
		return print_yn;
	}
	public void setPrint_yn(String print_yn) {
		this.print_yn = print_yn;
	}
}
