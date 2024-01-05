package com.samyang.winplus.common.employee.model;

import java.io.Serializable;

import org.springframework.web.multipart.MultipartFile;

public class EmpDto implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String EMP_NO = null;
	private String SAUPKUK_CD;
	private String BHF_CD;
	private String BUZPLC_CD;
	private String EMP_NM;
	private String IHIDNUM;
	private String HFFC_STTUS_CD;
	private String EMP_DIV_CD;
	private String LEVEL_CD;
	private String EMP_GRDE_CD;
	private String INDVDL_CPR_DIV_CD;
	private String VAT_YN;
	private String SMS_SEND_YN;
	private String TELNO;
	private String MBTLNUM;
	private String EMAIL;
	private String EMAIL_DOMN;
	private String EMAIL_DOMN_CD;
	private String BRTHDY;
	private String BRTHDY_DIV_CD;
	private String MRNRY_DATE;
	private String ENTRST_DATE;
	private String DISMISS_DATE;
	private String CNFN_EMP_NO;
	private String MENTO_EMP_NO;
	private String FEINSR_SBSCRB_YN;
	private String BIND_GOODS_SLE_POSBL_YN;
	private String ZIP;
	private String ADDR;
	private String ADDR2;
	private String ACNUTNO;
	private String BANK_CD;
	private String DPSTR;
	private String PYMNT_MTH_CD;
	private String DPSTR_RELATE_CD;
	private String REG_NUM;
	private String GRNTY_INSRNC_SBSCRB_YN;
	private String RLRT_MRTGG_PROVD_YN;
	private String WRHOUS_CONFM_POSBL_YN;
	private String CNSGN_CNTRCT_YN;
	private String FEE_LEVEL_CD;
	private String FEE_DEPT_CD;
	private String RM;
	private String DEPT_CD;
	private String SYS_DIV_CD;
	private String FLFL_GRNTY_BEGIN_DATE;
	private String FLFL_GRNTY_END_DATE;
	private String FLFL_GRNTY_AMT;
	private String ELCTRN_SUBSCRPT_YN;
	
	private String REG_PROGRM;
	private String REG_ID;
	private String UPD_PROGRM;
	private String UPD_ID;
	
	private MultipartFile CNSGN_CNTRCT_FILE = null;
	private MultipartFile IDENTIFICATION_FILE = null;
	private MultipartFile BNKB_COPY_FILE = null;
	private MultipartFile RECOMMENDATION_FILE = null;
	private MultipartFile WRITTEN_CONSENT_FILE = null;
	private MultipartFile TRNSCR_FILE = null;
	private MultipartFile AGREE_FILE = null;
	
	private String CNSGN_CNTRCT_FILE_NO;
	private String IDENTIFICATION_FILE_NO;
	private String BNKB_COPY_FILE_NO;
	private String RECOMMENDATION_FILE_NO;
	private String WRITTEN_CONSENT_FILE_NO;
	private String TRNSCR_FILE_NO;
	private String AGREE_FILE_NO;
	
	private String ATCHMNFL_NO;
	private String PAPERS_DIV_CD;
	
	public MultipartFile getRECOMMENDATION_FILE() {
		return RECOMMENDATION_FILE;
	}
	public void setRECOMMENDATION_FILE(MultipartFile rECOMMENDATION_FILE) {
		RECOMMENDATION_FILE = rECOMMENDATION_FILE;
	}
	public MultipartFile getWRITTEN_CONSENT_FILE() {
		return WRITTEN_CONSENT_FILE;
	}
	public void setWRITTEN_CONSENT_FILE(MultipartFile wRITTEN_CONSENT_FILE) {
		WRITTEN_CONSENT_FILE = wRITTEN_CONSENT_FILE;
	}
	public String getRECOMMENDATION_FILE_NO() {
		return RECOMMENDATION_FILE_NO;
	}
	public void setRECOMMENDATION_FILE_NO(String rECOMMENDATION_FILE_NO) {
		RECOMMENDATION_FILE_NO = rECOMMENDATION_FILE_NO;
	}
	public String getWRITTEN_CONSENT_FILE_NO() {
		return WRITTEN_CONSENT_FILE_NO;
	}
	public void setWRITTEN_CONSENT_FILE_NO(String wRITTEN_CONSENT_FILE_NO) {
		WRITTEN_CONSENT_FILE_NO = wRITTEN_CONSENT_FILE_NO;
	}
	public String getEMP_NO() {
		return EMP_NO;
	}
	public void setEMP_NO(String eMP_NO) {
		EMP_NO = eMP_NO;
	}
	public String getSAUPKUK_CD() {
		return SAUPKUK_CD;
	}
	public void setSAUPKUK_CD(String sAUPKUK_CD) {
		SAUPKUK_CD = sAUPKUK_CD;
	}
	public String getBHF_CD() {
		return BHF_CD;
	}
	public void setBHF_CD(String bHF_CD) {
		BHF_CD = bHF_CD;
	}
	public String getBUZPLC_CD() {
		return BUZPLC_CD;
	}
	public void setBUZPLC_CD(String bUZPLC_CD) {
		BUZPLC_CD = bUZPLC_CD;
	}
	public String getEMP_NM() {
		return EMP_NM;
	}
	public void setEMP_NM(String eMP_NM) {
		EMP_NM = eMP_NM;
	}
	public String getIHIDNUM() {
		return IHIDNUM;
	}
	public void setIHIDNUM(String iHIDNUM) {
		IHIDNUM = iHIDNUM;
	}
	public String getHFFC_STTUS_CD() {
		return HFFC_STTUS_CD;
	}
	public void setHFFC_STTUS_CD(String hFFC_STTUS_CD) {
		HFFC_STTUS_CD = hFFC_STTUS_CD;
	}
	public String getEMP_DIV_CD() {
		return EMP_DIV_CD;
	}
	public void setEMP_DIV_CD(String eMP_DIV_CD) {
		EMP_DIV_CD = eMP_DIV_CD;
	}
	public String getLEVEL_CD() {
		return LEVEL_CD;
	}
	public void setLEVEL_CD(String lEVEL_CD) {
		LEVEL_CD = lEVEL_CD;
	}
	public String getEMP_GRDE_CD() {
		return EMP_GRDE_CD;
	}
	public void setEMP_GRDE_CD(String eMP_GRDE_CD) {
		EMP_GRDE_CD = eMP_GRDE_CD;
	}
	public String getINDVDL_CPR_DIV_CD() {
		return INDVDL_CPR_DIV_CD;
	}
	public void setINDVDL_CPR_DIV_CD(String iNDVDL_CPR_DIV_CD) {
		INDVDL_CPR_DIV_CD = iNDVDL_CPR_DIV_CD;
	}
	public String getVAT_YN() {
		return VAT_YN;
	}
	public void setVAT_YN(String vAT_YN) {
		VAT_YN = vAT_YN;
	}
	public String getSMS_SEND_YN() {
		return SMS_SEND_YN;
	}
	public void setSMS_SEND_YN(String sMS_SEND_YN) {
		SMS_SEND_YN = sMS_SEND_YN;
	}
	public String getTELNO() {
		return TELNO;
	}
	public void setTELNO(String tELNO) {
		TELNO = tELNO;
	}
	public String getMBTLNUM() {
		return MBTLNUM;
	}
	public void setMBTLNUM(String mBTLNUM) {
		MBTLNUM = mBTLNUM;
	}
	public String getEMAIL() {
		return EMAIL;
	}
	public void setEMAIL(String eMAIL) {
		EMAIL = eMAIL;
	}
	public String getEMAIL_DOMN() {
		return EMAIL_DOMN;
	}
	public void setEMAIL_DOMN(String eMAIL_DOMN) {
		EMAIL_DOMN = eMAIL_DOMN;
	}
	public String getEMAIL_DOMN_CD() {
		return EMAIL_DOMN_CD;
	}
	public void setEMAIL_DOMN_CD(String eMAIL_DOMN_CD) {
		EMAIL_DOMN_CD = eMAIL_DOMN_CD;
	}
	public String getBRTHDY() {
		return BRTHDY;
	}
	public void setBRTHDY(String bRTHDY) {
		BRTHDY = bRTHDY;
	}
	public String getBRTHDY_DIV_CD() {
		return BRTHDY_DIV_CD;
	}
	public void setBRTHDY_DIV_CD(String bRTHDY_DIV_CD) {
		BRTHDY_DIV_CD = bRTHDY_DIV_CD;
	}
	public String getMRNRY_DATE() {
		return MRNRY_DATE;
	}
	public void setMRNRY_DATE(String mRNRY_DATE) {
		MRNRY_DATE = mRNRY_DATE;
	}
	public String getENTRST_DATE() {
		return ENTRST_DATE;
	}
	public void setENTRST_DATE(String eNTRST_DATE) {
		ENTRST_DATE = eNTRST_DATE;
	}
	public String getDISMISS_DATE() {
		return DISMISS_DATE;
	}
	public void setDISMISS_DATE(String dISMISS_DATE) {
		DISMISS_DATE = dISMISS_DATE;
	}
	public String getCNFN_EMP_NO() {
		return CNFN_EMP_NO;
	}
	public void setCNFN_EMP_NO(String cNFN_EMP_NO) {
		CNFN_EMP_NO = cNFN_EMP_NO;
	}
	public String getMENTO_EMP_NO() {
		return MENTO_EMP_NO;
	}
	public void setMENTO_EMP_NO(String mENTO_EMP_NO) {
		MENTO_EMP_NO = mENTO_EMP_NO;
	}
	public String getFEINSR_SBSCRB_YN() {
		return FEINSR_SBSCRB_YN;
	}
	public void setFEINSR_SBSCRB_YN(String fEINSR_SBSCRB_YN) {
		FEINSR_SBSCRB_YN = fEINSR_SBSCRB_YN;
	}
	public String getBIND_GOODS_SLE_POSBL_YN() {
		return BIND_GOODS_SLE_POSBL_YN;
	}
	public void setBIND_GOODS_SLE_POSBL_YN(String bIND_GOODS_SLE_POSBL_YN) {
		BIND_GOODS_SLE_POSBL_YN = bIND_GOODS_SLE_POSBL_YN;
	}
	public String getZIP() {
		return ZIP;
	}
	public void setZIP(String zIP) {
		ZIP = zIP;
	}
	public String getADDR() {
		return ADDR;
	}
	public void setADDR(String aDDR) {
		ADDR = aDDR;
	}
	public String getADDR2() {
		return ADDR2;
	}
	public void setADDR2(String aDDR2) {
		ADDR2 = aDDR2;
	}
	public String getACNUTNO() {
		return ACNUTNO;
	}
	public void setACNUTNO(String aCNUTNO) {
		ACNUTNO = aCNUTNO;
	}
	public String getBANK_CD() {
		return BANK_CD;
	}
	public void setBANK_CD(String bANK_CD) {
		BANK_CD = bANK_CD;
	}
	public String getDPSTR() {
		return DPSTR;
	}
	public void setDPSTR(String dPSTR) {
		DPSTR = dPSTR;
	}
	public String getPYMNT_MTH_CD() {
		return PYMNT_MTH_CD;
	}
	public void setPYMNT_MTH_CD(String pYMNT_MTH_CD) {
		PYMNT_MTH_CD = pYMNT_MTH_CD;
	}
	public String getDPSTR_RELATE_CD() {
		return DPSTR_RELATE_CD;
	}
	public void setDPSTR_RELATE_CD(String dPSTR_RELATE_CD) {
		DPSTR_RELATE_CD = dPSTR_RELATE_CD;
	}
	public String getREG_NUM() {
		return REG_NUM;
	}
	public void setREG_NUM(String rEG_NUM) {
		REG_NUM = rEG_NUM;
	}
	public String getGRNTY_INSRNC_SBSCRB_YN() {
		return GRNTY_INSRNC_SBSCRB_YN;
	}
	public void setGRNTY_INSRNC_SBSCRB_YN(String gRNTY_INSRNC_SBSCRB_YN) {
		GRNTY_INSRNC_SBSCRB_YN = gRNTY_INSRNC_SBSCRB_YN;
	}
	public String getRLRT_MRTGG_PROVD_YN() {
		return RLRT_MRTGG_PROVD_YN;
	}
	public void setRLRT_MRTGG_PROVD_YN(String rLRT_MRTGG_PROVD_YN) {
		RLRT_MRTGG_PROVD_YN = rLRT_MRTGG_PROVD_YN;
	}
	public String getWRHOUS_CONFM_POSBL_YN() {
		return WRHOUS_CONFM_POSBL_YN;
	}
	public void setWRHOUS_CONFM_POSBL_YN(String wRHOUS_CONFM_POSBL_YN) {
		WRHOUS_CONFM_POSBL_YN = wRHOUS_CONFM_POSBL_YN;
	}
	public String getFEE_LEVEL_CD() {
		return FEE_LEVEL_CD;
	}
	public void setFEE_LEVEL_CD(String fEE_LEVEL_CD) {
		FEE_LEVEL_CD = fEE_LEVEL_CD;
	}
	public String getFEE_DEPT_CD() {
		return FEE_DEPT_CD;
	}
	public void setFEE_DEPT_CD(String fEE_DEPT_CD) {
		FEE_DEPT_CD = fEE_DEPT_CD;
	}
	public String getRM() {
		return RM;
	}
	public void setRM(String rM) {
		RM = rM;
	}
	public MultipartFile getCNSGN_CNTRCT_FILE() {
		return CNSGN_CNTRCT_FILE;
	}
	public void setCNSGN_CNTRCT_FILE(MultipartFile cNSGN_CNTRCT_FILE) {
		CNSGN_CNTRCT_FILE = cNSGN_CNTRCT_FILE;
	}
	public MultipartFile getIDENTIFICATION_FILE() {
		return IDENTIFICATION_FILE;
	}
	public void setIDENTIFICATION_FILE(MultipartFile iDENTIFICATION_FILE) {
		IDENTIFICATION_FILE = iDENTIFICATION_FILE;
	}
	public MultipartFile getBNKB_COPY_FILE() {
		return BNKB_COPY_FILE;
	}
	public void setBNKB_COPY_FILE(MultipartFile bNKB_COPY_FILE) {
		BNKB_COPY_FILE = bNKB_COPY_FILE;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getREG_PROGRM() {
		return REG_PROGRM;
	}
	public void setREG_PROGRM(String rEG_PROGRM) {
		REG_PROGRM = rEG_PROGRM;
	}
	public String getREG_ID() {
		return REG_ID;
	}
	public void setREG_ID(String rEG_ID) {
		REG_ID = rEG_ID;
	}
	public String getUPD_PROGRM() {
		return UPD_PROGRM;
	}
	public void setUPD_PROGRM(String uPD_PROGRM) {
		UPD_PROGRM = uPD_PROGRM;
	}
	public String getUPD_ID() {
		return UPD_ID;
	}
	public void setUPD_ID(String uPD_ID) {
		UPD_ID = uPD_ID;
	}
	public String getDEPT_CD() {
		return DEPT_CD;
	}
	public void setDEPT_CD(String dEPT_CD) {
		DEPT_CD = dEPT_CD;
	}
	public String getCNSGN_CNTRCT_FILE_NO() {
		return CNSGN_CNTRCT_FILE_NO;
	}
	public void setCNSGN_CNTRCT_FILE_NO(String cNSGN_CNTRCT_FILE_NO) {
		CNSGN_CNTRCT_FILE_NO = cNSGN_CNTRCT_FILE_NO;
	}
	public String getIDENTIFICATION_FILE_NO() {
		return IDENTIFICATION_FILE_NO;
	}
	public void setIDENTIFICATION_FILE_NO(String iDENTIFICATION_FILE_NO) {
		IDENTIFICATION_FILE_NO = iDENTIFICATION_FILE_NO;
	}
	public String getBNKB_COPY_FILE_NO() {
		return BNKB_COPY_FILE_NO;
	}
	public void setBNKB_COPY_FILE_NO(String bNKB_COPY_FILE_NO) {
		BNKB_COPY_FILE_NO = bNKB_COPY_FILE_NO;
	}
	public String getATCHMNFL_NO() {
		return ATCHMNFL_NO;
	}
	public void setATCHMNFL_NO(String aTCHMNFL_NO) {
		ATCHMNFL_NO = aTCHMNFL_NO;
	}
	public String getPAPERS_DIV_CD() {
		return PAPERS_DIV_CD;
	}
	public void setPAPERS_DIV_CD(String pAPER_DIV_CD) {
		PAPERS_DIV_CD = pAPER_DIV_CD;
	}
	public String getTRNSCR_FILE_NO() {
		return TRNSCR_FILE_NO;
	}
	public void setTRNSCR_FILE_NO(String tRNSCR_FILE_NO) {
		TRNSCR_FILE_NO = tRNSCR_FILE_NO;
	}
	public MultipartFile getTRNSCR_FILE() {
		return TRNSCR_FILE;
	}
	public void setTRNSCR_FILE(MultipartFile tRNSCR_FILE) {
		TRNSCR_FILE = tRNSCR_FILE;
	}
	public String getSYS_DIV_CD() {
		return SYS_DIV_CD;
	}
	public void setSYS_DIV_CD(String sYS_DIV_CD) {
		SYS_DIV_CD = sYS_DIV_CD;
	}
	public MultipartFile getAGREE_FILE() {
		return AGREE_FILE;
	}
	public void setAGREE_FILE(MultipartFile aGREE_FILE) {
		AGREE_FILE = aGREE_FILE;
	}
	public String getAGREE_FILE_NO() {
		return AGREE_FILE_NO;
	}
	public void setAGREE_FILE_NO(String aGREE_FILE_NO) {
		AGREE_FILE_NO = aGREE_FILE_NO;
	}
	public String getFLFL_GRNTY_BEGIN_DATE() {
		return FLFL_GRNTY_BEGIN_DATE;
	}
	public void setFLFL_GRNTY_BEGIN_DATE(String fLFL_GRNTY_BEGIN_DATE) {
		FLFL_GRNTY_BEGIN_DATE = fLFL_GRNTY_BEGIN_DATE;
	}
	public String getFLFL_GRNTY_END_DATE() {
		return FLFL_GRNTY_END_DATE;
	}
	public void setFLFL_GRNTY_END_DATE(String fLFL_GRNTY_END_DATE) {
		FLFL_GRNTY_END_DATE = fLFL_GRNTY_END_DATE;
	}
	public String getFLFL_GRNTY_AMT() {
		return FLFL_GRNTY_AMT;
	}
	public void setFLFL_GRNTY_AMT(String fLFL_GRNTY_AMT) {
		FLFL_GRNTY_AMT = fLFL_GRNTY_AMT;
	}
	public String getCNSGN_CNTRCT_YN() {
		return CNSGN_CNTRCT_YN;
	}
	public void setCNSGN_CNTRCT_YN(String cNSGN_CNTRCT_YN) {
		CNSGN_CNTRCT_YN = cNSGN_CNTRCT_YN;
	}
	public String getELCTRN_SUBSCRPT_YN() {
		return ELCTRN_SUBSCRPT_YN;
	}
	public void setELCTRN_SUBSCRPT_YN(String eLCTRN_SUBSCRPT_YN) {
		ELCTRN_SUBSCRPT_YN = eLCTRN_SUBSCRPT_YN;
	}

	

}
