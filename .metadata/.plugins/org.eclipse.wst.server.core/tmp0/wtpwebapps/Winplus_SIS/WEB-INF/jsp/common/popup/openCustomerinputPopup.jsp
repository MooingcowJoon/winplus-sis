<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">

	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');

	var thisPopupWindow = parent.erpPopupWindows.window('openCustomerinputPopup');
	var erpTabBar; 
	var erpLayout; 
	var erpTopLayout;
	var erpMidLayout;
	var cmbPUR_SALE_TYPE  = "1";    /* 거래처구분 */
	var cmbPUR_TYPE       = "";    /* 매입유형 */
	var cmbSUPR_GRUP_CD   = "";    /* 협력사분류코드 */
// 	var cmbSUPR_TYPE      = "";    /* 협력사유형 */
	var cmbCUSTMR_GRUP    = "";    /* 거래처 유형 */
	var cmbPAY_STD        = "";     /* 마감일자(결제기준)  */
	var cmbPAY_DATE_TYPE  = "";		/* 정산지급유형  */
	
	var cmbCletimeHour    = "18";   /* 주문시간(hour)  */
	var cmbCletimeMin     = "00";   /* 주문시간(minute) */
	var cmbUSE_YN         = "Y";    /* 사용여부  */
	var cmbEVENT_YN       = "N";    /* 행사차단여부 */
	var cmbHACCP_YN       = "N";     /* HACCP인증여부 */
    var cmbEXC_VAT        = "N";    /* 부가세제외여부 */
	var cmbSUPR_STATE     = "1";    /* 휴폐업상태  */
	var cmbBANK_CD = "";
	var cmbCUSTMR_PRICE_GRUP;
	
	var erpCreditLayout;
	var erpBotSub42Layout;
	
	var erpCustmrGroupGrid;
	var erpCodeGridColumns;
	var crud;
	
	var param_CUSTMR_CD = "11111";
	var param_PUR_SALE_TYPE;
	var param_FILE_GRUP_NO;
	var imsi_corp_no  = "";
	
	var loan_tr; //여신관련정보 돔객체
	var acnt_td; //계좌정보 돔객체
	var acnt_th;
	
	var saved_loan_yn = null;
	var loan_yn = 'N'; //여신가능여부
	var loan_amt = null; //여신한도
	var bal_amt = null; //잔액
	var loanAmt = null;
	var balAmt = null;
	var acnt_no = null;
	
	$(document).ready(function(){
		
		if(thisPopupWindow){
			thisPopupWindow.setText("${screenDto.scrin_nm}");	
			//thisPopupWindow.denyResize();
			//thisPopupWindow.denyMove();
		}
		
		param_CUSTMR_CD = "${param.customer_cd}";
		param_PUR_SALE_TYPE = "${param.pur_sale_type}";
		param_FILE_GRUP_NO = "${param.file_grup_no}"
        //initErpTabBar(); 
        initErpLayout();
        initRibbon();
        initMidLayout();
        initdeliveryLayout();  // 배송요일 &&  최저발주

        initBotSubLayout();    /* 제일하단(4단) 신용 및 여신부분 세로2등분 */
        initBotSub42Layout();  /* 4-2단 계층그룹등록 */
//         initErpCustmrGroupGrid();
		
        initDhtmlXCombo();
        
		loan_tr = document.getElementById("LOAN_TR");
		acnt_th = document.getElementById("acnt_th");
		acnt_td = document.getElementById("acnt_td");

		setAcntDomObj();
		
		if(param_CUSTMR_CD){
			//모든 레이아웃 초기화 함수 호출후 등록해주세요.
			$erp.asyncObjAllOnCreated(function(){
				if(param_PUR_SALE_TYPE == "고객사"){
					cmbBANK_CD.disable();
				}
				searchData(param_CUSTMR_CD);
				getSearchCustmrGroupList(param_CUSTMR_CD);
			});
		}
		else 
		{
			setLoanDomObj();
			addData();
		}
        
        
    }); 

	$(function(){
		var text1 = $('.text1');
		text1.focus(function(){
			text1.val('포커스를 얻었습니다.');
		});
		text1.blur(function(){
			text1.val('포커스를 벗어났습니다. .');
		});
	});
	
	
	function createLOAN_CD(){
		var CUSTMR_CD = document.getElementById("txtCUSTMR_CD").value;
		var CUSTMR_NM = document.getElementById("txtCUSTMR_NM").value;
		var LOAN_CD = document.getElementById("txtLOAN_CD").value;
		if(CUSTMR_CD == undefined || CUSTMR_CD == null || CUSTMR_CD == ""){
			$erp.alertMessage({
				"alertMessage" : "미등록 상태 거래처입니다.<br>먼저 저장이 필요합니다.",
				"alertType" : "alert",
				"isAjax" : false
			});
			return;
		}else if(saved_loan_yn != 'Y'){
			$erp.alertMessage({
				"alertMessage" : "여신 미사용 거래처입니다.<br>먼저 저장이 필요합니다.",
				"alertType" : "alert",
				"isAjax" : false
			});
			return;
		}
		
		var onSaveData = function(){
			searchData(CUSTMR_CD);
		}
		
		if(LOAN_CD == undefined || LOAN_CD == null || LOAN_CD == ""){
			$erp.openAddNewLoanPopup({"popupType" : "add", "loanType" : "C", "CUSTMR_CD" : CUSTMR_CD, "CUSTMR_NM" : CUSTMR_NM}, onSaveData);
		}else{
			$erp.openAddNewLoanPopup({"popupType" : "update", "loanType" : "C", "CUSTMR_CD" : CUSTMR_CD, "CUSTMR_NM" : CUSTMR_NM, "LOAN_CD" : LOAN_CD}, onSaveData);
		}
	}
	
	function setAcntDomObj(){
		if(param_PUR_SALE_TYPE == "협력사"){
			acnt_th.innerHTML = '계좌정보';
			acnt_td.innerHTML = '<input type = "text" id = "txtACNT_NO" name = "ACNT_NO" class = "input_text">';
		}else if(param_PUR_SALE_TYPE =="고객사"){
			acnt_th.innerHTML = '가상계좌발급현황';
			acnt_td.innerHTML = '<input type = "text" id = "txtVRT_ACNT" name = "VRT_ACNT" class = "input_text" style = "width : 120px">';
		}
	}
	
	function setLoanDomObj(){
		if(loan_yn == 'Y'){
			var LOAN_CD = document.getElementById("txtLOAN_CD").value;
			if(LOAN_CD == undefined || LOAN_CD == null || LOAN_CD == ""){
				loan_tr.innerHTML = '\
					<th>여신정보없음</th>\
					<td colspan="8"><input type="button" id="createLOAN_CD" CLASS="input_common_button" value="여신생성" onclick="createLOAN_CD();"></td>\
				';
			}else{
				loan_tr.innerHTML = '\
					<th>여신한도</th>\
					<td colspan = "2"><input type="text" id="txtLOAN_AMT" name="LOAN_AMT" class="input_money" style = "text_align:right; width:125px;" maxlength="50" readonly="readonly">원</td>\
					<th>잔액</th>\
					<td colspan="6">\
						<input type="text" id="txtBAL_AMT" name="BAL_AMT" class="input_money" maxlength="20" readonly="readonly" style = "text_align:right; width:125px;">원\
						<input type="button" id="createLOAN_CD" CLASS="input_common_button" value="여신정보확인" onclick="createLOAN_CD();">\
					</td>\
				';
				document.getElementById("txtLOAN_AMT").value = loanAmt;
				document.getElementById("txtBAL_AMT").value = balAmt;
			}
		}else if(loan_yn == 'N'){
			loan_tr.innerHTML = "";
		}
	}
	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "4E"
			, cells : [
				  {id: "a" , text : "", header : false}
				, {id: "b" , text : "기본정보", header : true}
				, {id: "c" , text : "", header : false}
				, {id: "d" , text : "", header : false, fix_size:[true, true]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_ribbon");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		
		erpLayout.cells("b").attachObject("div_erp_top_layout");
		erpLayout.cells("b").setHeight(200);
		
		erpLayout.cells("c").attachObject("div_erp_mid_layout");
		erpLayout.cells("c").setHeight(177);
		erpLayout.cells("d").attachObject("div_erp_bot_layout");
	//	erpLayout.cells("d").setHeight(100);
		erpLayout.setSeparatorSize(1,0);
	}
	
	
	/* 거래처등록 리본 */
	function initRibbon() {
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					//  {id : "add_data"   , type : "button", text:'<spring:message code="ribbon.add" />'   , isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					//, {id : "delete_data", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					  {id : "save_data"  , type : "button", text:'<spring:message code="ribbon.save" />'  , isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					//, {id : "search_data", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_data"){
				var CUSTMR_CD = document.getElementById('txtCUSTMR_CD').value;
				if(CUSTMR_CD == undefined || CUSTMR_CD == null || CUSTMR_CD == ""){
					$erp.alertMessage({
						"alertMessage" : "등록되어있는 거래처가 아닙니다.",
						"alertType" : "alert",
						"isAjax" : false
					});
					return
				}
				$erp.openCustmrInfoLogPopup({"CUSTMR_CD":CUSTMR_CD});
		    } else if (itemId == "add_data"){
            //if (itemId == "add_data"){
		    	addData();
		    } else if (itemId == "delete_data"){
		    	deleteData();
		    } else if (itemId == "save_data"){
		    	saveData();
		    }
		});
	}


	/****************************************************************************/
    /* 추가버튼 신규입력을 위해  Document Body의 엘리먼트값을 초기화하고        */
    /* readonly 속성을 False한다                                                */
    /****************************************************************************/
	function addData(){
		if(crud != "C"){

			$erp.clearInputInElement("tb_erp_data");
			$erp.clearInputInElement("tb_erp_address");
			$erp.clearInputInElement("tb_erp_send");
			$erp.clearInputInElement("tb_erp_smallbalju");
			$erp.clearInputInElement("tb_erp_level");
			
			crud = "C";
		}
	}
	
	/****************************************************************************/
    /* erpGrid 저장 Function                                                    */
    /****************************************************************************/	
	function saveData(){
		erpLayout.progressOn();
		
		var alertMessage = function(){
			erpLayout.progressOff();
			$erp.alertMessage({
				"alertMessage" : "필수 입력 항목이 남아있습니다.",
				"alertType" : "alert",
				"isAjax" : false
			});
		}
		
		var paramData1 = $erp.tableValidationCheck("tb_erp_data");
		if(paramData1 === false){ //false 가 아닐시 정상(직렬화된 데이터)
			alertMessage();
			return;
		}
		
		var paramData2 = $erp.tableValidationCheck("tb_erp_address");
		if(paramData2 === false){ //false 가 아닐시 정상(직렬화된 데이터)
		alertMessage();
			return;
		}
		
		var paramData3 = $erp.dataSerialize("tb_erp_send");
		
		var paramData4 = $erp.tableValidationCheck("tb_erp_smallbalju");
		if(paramData4 === false){ //false 가 아닐시 정상(직렬화된 데이터)
		alertMessage();
			return;
		}
		
		var paramData5 = $erp.tableValidationCheck("tb_erp_level");
		if(paramData5 === false){ //false 가 아닐시 정상(직렬화된 데이터)
		alertMessage();
			return;
		}
		
		var paramData  = $erp.unionObjArray([paramData1,paramData2,paramData3,paramData4,paramData5]);
		
		//console.log(paramData);
		
		var setEtc0    = {"CRUD" : crud};
		var CUSTMR_NM   = document.getElementById("txtCUSTMR_NM").value;

		/* TODO-JOB 아래의 칼럼은 Define이 덜도어 나중에 처리 */
		var setEtc1 = {"ORD_SALE_TYPE" : "1", "ORD_SALE_FEE"  : "1"};	/* 거래유형(영업)구분, 거래유형(영업)  */
		var setEtc2 = {"ORD_PUR_TYPE"  : "1", "ORD_PUR_FEE"   : "1"};	/* 거래유형(구매)구분, 거래유형(구매)   */ 
		var setEtc3 = {"DELI_DATE"     : "1"};  						/* 배송 특정일          */
		var setEtc4 = {"PAY_TYPE"      : "1", "PAY_SCHD_1" : "1", "PAY_SCHD_2" : "1"};  /* 수금/지급구분, 값1 , 값2*/

		var sval8   = cmbCletimeHour.getSelectedValue();  /* 마감시간시나(hour) */
		var sval9   = cmbCletimeMin.getSelectedValue();   /* 주문마감시간(분) */
		
		var sval1   = "0";
		var sval2   = "0";
		var sval3   = "0";
		var sval4   = "0";
		var sval5   = "0";
		var sval6   = "0";
		var sval7   = "0";
		
		if($('#chkSend_mon').is(":checked") == true)  sval1 = "1";
		if($('#chkSend_tue').is(":checked") == true)  sval2 = "1";
		if($('#chkSend_wed').is(":checked") == true)  sval3 = "1";
		if($('#chkSend_thu').is(":checked") == true)  sval4 = "1";
		if($('#chkSend_fri').is(":checked") == true)  sval5 = "1";
		if($('#chkSend_sat').is(":checked") == true)  sval6 = "1";
		if($('#chkSend_sun').is(":checked") == true)  sval7 = "1";
		
		if(sval8=='' || sval8==null || sval8==undefined || sval8==NaN) sval8 = "18";
		if(sval9=='' || sval9==null || sval9==undefined || sval9==NaN) sval9 = "00";

		var setEtc5 = {"DELI_YOIL" : sval1+sval2+sval3+sval4+sval5+sval6+sval7 };  /* 배송요일 월~일   */
		var setEtc6 = {"CLSE_TIME" : sval8+sval9 };  /* 마감 기간-분 */
	
		var sval10   = document.getElementById("txtGOODS_FEE").value;
		
		if(param_PUR_SALE_TYPE == "협력사"){
			var sval11   = document.getElementById("txtMK_INCEN_RATE").value;
			var sval12   = document.getElementById("txtCENT_INCEN_RATE").value;
		}

		//sval10 =  sval10.replace(/[^-\.0-9]/g, "");
		//sval11 =  sval11.replace(/[^-\.0-9]/g, "");
		//sval12 =  sval12.replace(/[^-\.0-9]/g, "");

		$.extend(paramData, setEtc0);
		$.extend(paramData, setEtc1);
		$.extend(paramData, setEtc2);
		$.extend(paramData, setEtc3);
		$.extend(paramData, setEtc4);
		$.extend(paramData, setEtc5);
		$.extend(paramData, setEtc6);
		
		var IS_WINPLUS = (CUSTMR_NM.indexOf("윈플러스") > -1) == true? "Y" : "N";
		console.log("USE_SCREEN : " + param_PUR_SALE_TYPE);
		console.log("IS_WINPLUS : " + IS_WINPLUS);
		$.extend(paramData, {"USE_SCREEN" : param_PUR_SALE_TYPE, "IS_WINPLUS" : IS_WINPLUS}); //거래처 코드 생성 분기용

		//$.extend(paramData, sval10);		
		//$.extend(paramData, sval11);		
		//$.extend(paramData, sval12);		
	
		$.ajax({
			url : "/sis/basic/insertCustomer.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					$erp.alertMessage({
						"alertMessage" : "저장이 완료되었습니다."
						, "alertType" : "alert"
						, "isAjax" : false
						, "alertCallbackFn" : function(){
							setSearchData(data);
						}
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				/* 거래처코드 칼럼 lock */
				$("#txtCUSTMR_CD").attr("readonly",true); 
			}
		});
	}
	
	/****************************************************************************/
    /* Data 저장 유효성 검증 Function                                           */
    /****************************************************************************/	
	function isSaveValidate(){
		var orgnCd = document.getElementById("txtCUSTMR_CD").value;
		var orgnNm = document.getElementById("txtCUSTMR_NM").value;
		
		var isValidated  = true;
		var alertMessage = "";
		var alertCode    = "";
		var alertType    = "error";

		if($erp.isEmpty(orgnNm)){
			isValidated = false;
			alertMessage = "error.common.system.master.category.stndCtgrNm.noData";
			alertCode = "-2";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
	
	<%-- Data 삭제 Function --%>
	function deleteData(){
		if(!isSearchValidate()) { return false; }
		
		var alertMessage = '<spring:message code="alert.common.deleteData" />';
		var alertCode = "";
		var alertType = "alert";
		var callbackFunction = function(){
			crud = "D";
			saveData();
		}
		
		$erp.confirmMessage({
			"alertMessage" : alertMessage
			, "alertCode" : alertCode
			, "alertType" : alertType
			, "alertCallbackFn" : callbackFunction
		});
	}

	
	<%-- Data 조회 Function --%>
	function searchData( CUSTMR_CD ){
		//if(!isSearchValidate()) { return false; }
		erpLayout.progressOn();

		var  return_yoil;
		
		$.ajax({
			url  : "/sis/basic/getCustomer.do"
			,data : { "CUSTMR_CD" : CUSTMR_CD}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					if($erp.isEmpty(data.dataMap)){
						$erp.alertMessage({
							"alertMessage" : "grid.noSearchData"
							, "alertCode" : ""
							, "alertType" : "info"
						});
					} else {
						setSearchData(data);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function setSearchData(data){
		var dataMap = data.dataMap;	
		crud = "U";
		saved_loan_yn = dataMap.LOAN_YN;
		loan_yn = dataMap.LOAN_YN;
		loan_amt = dataMap.LOAN_AMT;
		bal_amt = dataMap.BAL_AMT;
		acnt_no = dataMap.ACNT_NO;
		
		if(loan_amt == "" || loan_amt == null || loan_amt == undefined){
			loanAmt = loan_amt;
			balAmt = bal_amt;
			
		}else{
			loanAmt = loan_amt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			balAmt = bal_amt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		
		$erp.dataAutoBind("tb_erp_data", dataMap);
		$erp.dataAutoBind("tb_erp_address", dataMap);
		$erp.dataAutoBind("tb_erp_send", dataMap);
		
		$erp.dataAutoBind("tb_erp_smallbalju",dataMap);
		$erp.dataAutoBind("tb_erp_level",dataMap);
		
		return_yoil  = data.dataMap.DELI_YOIL;
		
		document.getElementById("chkSend_mon").checked = false;
		document.getElementById("chkSend_tue").checked = false;
		document.getElementById("chkSend_wed").checked = false;
		document.getElementById("chkSend_thu").checked = false;
		document.getElementById("chkSend_fri").checked = false;
		document.getElementById("chkSend_sat").checked = false;
		document.getElementById("chkSend_sun").checked = false;

		if(return_yoil){
			if ( return_yoil.substr(0,1) == "1" )  document.getElementById("chkSend_mon").checked = true;
			if ( return_yoil.substr(1,1) == "1" )  document.getElementById("chkSend_tue").checked = true;
			if ( return_yoil.substr(2,1) == "1" )  document.getElementById("chkSend_wed").checked = true;
			if ( return_yoil.substr(3,1) == "1" )  document.getElementById("chkSend_thu").checked = true;
			if ( return_yoil.substr(4,1) == "1" )  document.getElementById("chkSend_fri").checked = true;
			if ( return_yoil.substr(5,1) == "1" )  document.getElementById("chkSend_sat").checked = true;
			if ( return_yoil.substr(6,1) == "1" )  document.getElementById("chkSend_sun").checked = true;
		}
		
		setLoanDomObj();
		
		getAttachFileList();
	}
	
	/* 계층그룹등록 리본 */
	function initErpCustmrGroupRibbon(){
		erpCustmrGroupRibbon = new dhtmlXRibbon({
			parent : "div_erp_CustmrGroup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					  {id : "add_right_data", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_right_data", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_right_data", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}							
			]
		});
		
		erpCustmrGroupRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_right_data"){
		    	addErpCodeData();
		    } else if (itemId == "delete_right_data"){
		    	deleteErpCodeData();
		    } else if (itemId == "save_right_data"){
		    	saveErpCodeData();
		    }
		});
	}
	
	function initMidLayout() {
		erpMidLayout = new dhtmlXLayoutObject({
			parent : "div_erp_mid_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2U"
			, cells : [
				  {id:"a", text: "주소정보", header: true, width: 600}
				, {id:"b", text: "배송요일", header: false, fix_size:[true, true]}
			]
		});
		erpMidLayout.cells("a").attachObject("div_erp_addr_condition");
		erpMidLayout.cells("b").attachObject("div_erp_delivery_condition");
		
		erpMidLayout.setSeparatorSize(1,0);
	}

	/* 제일하단(4단) 신용 및 여신부분 세로2등분 */
	function initBotSubLayout() {
		erpCreditLayout = new dhtmlXLayoutObject({
			parent : "div_erp_bot_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2U"
			, cells : [
				  {id:"a", text: "여신/기타", header: true, fix_size:[true, true]}
				, {id:"b", text: "계약서관리" , header: true, fix_size:[true, true]}
			]
		});
		erpCreditLayout.cells("a").attachObject("div_erp_credit_condition");
		erpCreditLayout.cells("a").setHeight(192);
		erpCreditLayout.cells("b").attachObject("div_erp_contract_layout");
		erpCreditLayout.cells("b").setHeight(192);
// 		erpCreditLayout.cells("c").attachObject("div_erp_CustmrGroup_grid");
		
		erpCreditLayout.setSeparatorSize(0,1);
		erpCreditLayout.setSeparatorSize(1,1);

	}
	
	/* 4-1 거래처 소속 그룹 조회 그리드 */
// 	function initErpCustmrGroupGrid(){
// 		erpCodeGridColumns=[
// 			  {id : "NO"      		, label : ["NO"], type : "cntr", width : "45", sort : "int", align : "center", isHidden : false, isEssential : false}	
// 			, {id : "GRUP_CD"  		, label:["그룹코드"], type: "ro", width: "100",align : "left", isHidden : false, isEssential : false}
// 			, {id : "GRUP_NM"  		, label:["그룹명"], type: "ro", width: "110",align : "left", isHidden : false, isEssential : false}
// 			, {id : "USE_YN"  		, label:["사용여부"], type: "ro", width: "90",align : "left", isHidden : false, isEssential : false}
// 			, {id : "CDATE"  		, label:["생성일"], type: "ro", width: "130",align : "left", isHidden : false, isEssential : false}
// 			, {id : "CUSER"  		, label:["생성자"], type: "ro", width: "80",align : "left", isHidden : false, isEssential : false}
// 			, {id : "MDATE"  		, label:["수정일"], type: "ro", width: "130",align : "left", isHidden : false, isEssential : false}
// 			, {id : "MUSER"  		, label:["수정자"], type: "ro", width: "80",align : "left", isHidden : false, isEssential : false}
// 		];
		
// 		erpCustmrGroupGrid = new dhtmlXGridObject({
// 			parent: "div_erp_CustmrGroup_grid"
// 			, skin : ERP_GRID_CURRENT_SKINS
// 			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
// 			, columns : erpCodeGridColumns
// 		});
		
// 		$erp.initGridCustomCell(erpCustmrGroupGrid);
// 		$erp.initGridComboCell(erpCustmrGroupGrid);
		
// 		erpCustmrGroupGridDataProcessor = new dataProcessor();
// 		erpCustmrGroupGridDataProcessor.init(erpCustmrGroupGrid);
// 		erpCustmrGroupGridDataProcessor.setUpdateMode("off");
// 		$erp.attachDhtmlXGridFooterRowCount(erpCustmrGroupGrid, '<spring:message code="grid.allRowCount" />');
		
// 	} 
	
    /* 4-2단 계약서 관리  */	
	function initBotSub42Layout(){
		erpBotSub42Layout = new dhtmlXLayoutObject({
			parent: "div_erp_contract_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				  {id: "a", text: "", header:false, fix_size:[true, true]}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
			]		
		});

		erpBotSub42Layout.cells("a").attachObject("div_erp_contract_ribbon");
		erpBotSub42Layout.cells("a").setHeight(36);
// 		erpBotSub42Layout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		
		
// 		erpBotSub42Layout.cells("a").hideArrow();
		erpBotSub42Layout.cells("b").attachObject("div_erp_contract_grid");
		erpBotSub42Layout.setSeparatorSize(0, 1);

		/*  erpRightSubLayout 사이즈 변경 시 Event */
		$erp.setEventResizeDhtmlXLayout(erpBotSub42Layout, function(names){
			erpCodeGrid.setSizes();
		})
		
		erp_contract_ribbon = new dhtmlXRibbon({
			parent : "div_erp_contract_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{type : "block"
						, mode : 'rows'
							, list : [
// 								  {id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
								  {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
								, {id : "delete_grid", 	type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
								, {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
								]
					}							
				]
		});
		
		erp_contract_ribbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_grid"){
				var onUploadFile = function(files, serverReturnData){ //업로드 파일 수만큼 발생
				};
				var onUploadComplete = function(uploadedFileInfoList, lastServerReturnData){ //전체 파일 업로드 후 발생
					parseAttachFileList(lastServerReturnData);
				};
				var onBeforeFileAdd = function(file){}; //선택한 업로드 파일이 팝업창에 하나씩 추가될때 발생
				var onBeforeClear = function(){};

				var FILE_GRUP_NO = document.getElementById("txtFILE_GRUP_NO").value;
				
				if(FILE_GRUP_NO != undefined && FILE_GRUP_NO != null && FILE_GRUP_NO != ""){
			 		$erp.openAttachFilesUploadPopup({"DIRECTORY_KEY" : "contract", "FILE_GRUP_NO" : FILE_GRUP_NO, "FILE_REG_TYPE" : "contract"}, 10, 0, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
				}else{
					var url = "/common/system/file/getFileGrupNo.do";
					var send_data = {};
					var if_success = function(data){
						document.getElementById("txtFILE_GRUP_NO").value = data.FILE_GRUP_NO;
						var CUSTMR_CD = document.getElementById("txtCUSTMR_CD").value;
						
						if(CUSTMR_CD != undefined && CUSTMR_CD != null && CUSTMR_CD != ""){
							var url = "/sis/basic/updateCustomerFileGrupNo.do";
							var send_data = {"CUSTMR_CD" : CUSTMR_CD, "FILE_GRUP_NO" : data.FILE_GRUP_NO};
							var if_success = function(data){
								if(data.isError){
									console.log("error");
									console.log(data);
								}
							}
							var if_error = function(XHR, status, error){}
							$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
						}
				 		$erp.openAttachFilesUploadPopup({"DIRECTORY_KEY" : "contract", "FILE_GRUP_NO" : data.FILE_GRUP_NO, "FILE_REG_TYPE" : "contract"}, 10, 0, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
					}
					
					var if_error = function(XHR, status, error){}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
				}
				
			} else if (itemId == "delete_grid"){
				//그리드객체, inserted 상태 로우들의 수정 가능 컬럼 id 리스트, inserted 상태 로우들의 수정 불가능 컬럼 id 리스트
				$erp.deleteGridCheckedRows(erp_contract_grid, [], []);
				var url = "/common/system/file/deleteAttachContractFileList.do";
				var CUSTMR_CD = document.getElementById("txtCUSTMR_CD").value;
				var send_data = $erp.dataSerializeOfGridByCRUD(erp_contract_grid, false, {"CUSTMR_CD" : CUSTMR_CD})["D"];
				var if_success = function(data){
					$erp.clearDhtmlXGrid(erp_contract_grid); //기존데이터 삭제
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(erp_contract_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						parseAttachFileList(data.gridDataList);
					}
					$erp.setDhtmlXGridFooterRowCount(erp_contract_grid); // 현재 행수 계산
				}
				
				var if_error = function(XHR, status, error){
					
				}
				
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
			} else if (itemId == "save_grid"){
				$erp.gridValidationCheck(erp_contract_grid, function(){
					var url = "/common/system/file/updateAttachFileList.do";
					var send_data = $erp.dataSerializeOfGridByMode(erp_contract_grid, "updated", true, {"DIRECTORY_KEY" : "contract"});
					var if_success = function(data){
						$erp.clearDhtmlXGrid(erp_contract_grid); //기존데이터 삭제
						if($erp.isEmpty(data.gridDataList)){
							//검색 결과 없음
							$erp.addDhtmlXGridNoDataPrintRow(erp_contract_grid, '<spring:message code="info.common.noDataSearch" />');
						}else{
							parseAttachFileList(data.gridDataList);
						}
						$erp.setDhtmlXGridFooterRowCount(erp_contract_grid); // 현재 행수 계산
					}
					
					var if_error = function(XHR, status, error){
						
					}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
					
				}); //
			}
		});
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
			  {id : "CHECK", 			label : ["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center"}
			, {id : "NO", 				label : ["NO", "#rspan"], type: "cntr", width : "30", sort : "int", align : "center"}
			, {id : "FILE_GRUP_NO", 	label : ["저장위치", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true}
			, {id : "FILE_SEQ", 		label : ["파일번호", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true}
			, {id : "FILE_ORG_NM", 		label : ["파일명", "#text_filter"], type : "ro", width : "250", sort : "str", align : "center"}
			, {id : "DOWNLOAD_BUTTON",	label : ["다운로드", "#text_filter"], type : "button", width : "80", sort : "str", align : "center"}
			, {id : "FILE_REG_TYPE", 	label : ["계약서유형", "#text_filter"], type : "combo", width : "80", sort : "str", align : "center", commonCode : "FILE_REG_TYPE", isEssential : true}
			, {id : "FILE_REG_TYPE_NM", label : ["계약서유형명", "#text_filter"], type : "ro", width : "80", sort : "str", align : "center", isHidden : true, isEssential : true}
			, {id : "REMK", 			label : ["비고", "#text_filter"], type : "ed", width : "200", sort : "str", align : "center"}
			, {id : "CUSER", 			label : ["등록자", "#text_filter"], type : "ro", width : "80", sort : "str", align : "center"}
			, {id : "CDATE", 			label : ["등록일자", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center"}
			, {id : "MUSER", 			label : ["수정자", "#text_filter"], type : "ro", width : "80", sort : "str", align : "center"}
			, {id : "MDATE", 			label : ["수정일자", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center"}
		];
		
		erp_contract_grid = new dhtmlXGridObject({
			parent: "div_erp_contract_grid"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		
		erp_contract_grid.captureEventOnParentResize(erpCreditLayout);
		
		$erp.initGrid(erp_contract_grid);
		
		erp_contract_grid.attachEvent("onRowSelect", function (rowId,columnIdx){
			if(erp_contract_grid.getColumnId(columnIdx) == "DOWNLOAD_BUTTON"){
				var FILE_GRUP_NO = erp_contract_grid.cells(rowId, erp_contract_grid.getColIndexById("FILE_GRUP_NO")).getValue();
				var FILE_SEQ = erp_contract_grid.cells(rowId, erp_contract_grid.getColIndexById("FILE_SEQ")).getValue();
				$erp.requestFileDownload({"FILE_GRUP_NO" : FILE_GRUP_NO, "FILE_SEQ" : FILE_SEQ});
			}
		});
	}
	
	function initdeliveryLayout(){
		erpdeliveryLayout = new dhtmlXLayoutObject({
			parent : "div_erp_delivery_condition"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				  {id: "a", text: "배송요일", header:true, fix_size:[true, true]}
				, {id: "b", text: "발주기준", header:true, fix_size:[true, true]}				
			]
		});
		erpdeliveryLayout.cells("a").attachObject("div_erp_send_condition");  // 배송요일
		erpdeliveryLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		//erpdeliveryLayout.cells("a").setHeight(10);
		
		erpdeliveryLayout.cells("b").attachObject("div_erp_minput_condition"); // 최저발주
		erpdeliveryLayout.setSeparatorSize(1,0);
		//erpdeliveryLayout.cells("b").setHeight(40);
		
	}	


	function initDhtmlXCombo(){
		// 기본정보
		/* 거래처구분(매입/매출) */
		cmbPUR_SALE_TYPE   = $erp.getDhtmlXComboCommonCode('cmbPUR_SALE_TYPE',  'cmbPUR_SALE_TYPE',     'PUR_SALE_TYPE',   80, null, false, param_PUR_SALE_TYPE == "협력사"? "1" : "2");
		$erp.objReadonly("cmbPUR_SALE_TYPE");
		
		if(param_PUR_SALE_TYPE == "협력사"){
			/* 매입유형 */
			cmbPUR_TYPE        = $erp.getDhtmlXComboCommonCode('cmbPUR_TYPE',       'cmbPUR_TYPE',          'PUR_TYPE',        115, "선택", true, cmbPUR_TYPE);
			/* 협력사분류코드 */
			cmbSUPR_GRUP_CD    = $erp.getDhtmlXComboCommonCode('cmbSUPR_GRUP_CD',   'cmbSUPR_GRUP_CD',      'SUPR_GRUP_CD',    115, "선택", true, cmbSUPR_GRUP_CD);
	        /* 협력사유형 */
// 			cmbSUPR_TYPE       = $erp.getDhtmlXComboCommonCode('cmbSUPR_TYPE',      'cmbSUPR_TYPE',         'SUPR_TYPE',       115, "선택", true, cmbSUPR_TYPE);
			/* 거래처 유형 */
			cmbCUSTMR_GRUP = $erp.getDhtmlXComboCommonCode("cmbCUSTMR_GRUP", "cmbCUSTMR_GRUP", ["CUSTMR_GRUP","","P"], 115, null, false, cmbCUSTMR_GRUP);
			cmbBANK_CD = $erp.getDhtmlXComboCommonCode("cmbBANK_CD", "cmbBANK_CD", "BANK_CD", 120, "선택", false);
		}else if(param_PUR_SALE_TYPE == "고객사"){
			/* 거래처 유형 */
			cmbCUSTMR_GRUP = $erp.getDhtmlXComboCommonCode("cmbCUSTMR_GRUP", "cmbCUSTMR_GRUP", ["CUSTMR_GRUP","","S"], 115, null, false, "고객사");
			cmbBANK_CD = $erp.getDhtmlXComboCommonCode("cmbBANK_CD", "cmbBANK_CD", "BANK_CD", 120, null, false,"11");
		}
        
		/* 부가세제외여부 */
		cmbEXC_VAT         = $erp.getDhtmlXComboCommonCode('cmbEXC_VAT',        'cmbEXC_VAT',           ['YN_CD','YN'],           115, null, false, cmbEXC_VAT);
		/* 거래상태여부 */
		cmbUSE_YN          = $erp.getDhtmlXComboCommonCode('cmbUSE_YN',         'cmbUSE_YN',            ['YN_CD','YN'],           115, null , false, cmbUSE_YN);
		/* 마감일자(결제기준) */
		cmbPAY_STD         = $erp.getDhtmlXComboCommonCode('cmbPAY_STD',        'cmbPAY_STD',           'PAY_STD',         115, "선택", false, cmbPAY_STD);
		/* 정산지급유형 */
		cmbPAY_DATE_TYPE   = $erp.getDhtmlXComboCommonCode('cmbPAY_DATE_TYPE',  'cmbPAY_DATE_TYPE',     'PAY_DATE_TYPE',   115, "선택", false, cmbPAY_DATE_TYPE);
		/* 휴폐업상태 */
		cmbSUPR_STATE      = $erp.getDhtmlXComboCommonCode('cmbSUPR_STATE',     'cmbSUPR_STATE',        'SUPER_STATE',     115, "선택", false, cmbSUPR_STATE);
        
		// 발주기준
		/* 주문시간(time) */
		cmbCletimeHour     = $erp.getDhtmlXComboCommonCode('cmbCletimeHour',    'cmbCletimeHour',       'TIME',            115, "선택", false, cmbCletimeHour);
		/* 주문시간(minute) */
		cmbCletimeMin      = $erp.getDhtmlXComboCommonCode('cmbCletimeMin',     'cmbCletimeMin',        'MINUTE',          115, "선택", false, cmbCletimeMin);
		cmbCUSTMR_PRICE_GRUP = $erp.getDhtmlXComboTableCode("cmbCUSTMR_PRICE_GRUP", "CUSTMR_PRICE_GRUP", "/sis/code/getSearchStdPriceCdList.do", null, 115, "모두조회", false);
		// 여신/기타
		/* 신용여신 사용여부 */
		cmbLOAN_YN   	   = $erp.getDhtmlXComboCommonCode("cmbLOAN_YN",  		"cmbLOAN_YN", 			["YN_CD","YN"], 		   115, null, false, 'N', function(){
			cmbLOAN_YN.attachEvent("onChange", function(value, text){
				loan_yn = value;
				setLoanDomObj();
			}); 
		});
		
		/* 행사차단여부 */
		cmbEVENT_YN        = $erp.getDhtmlXComboCommonCode('cmbEVENT_YN',       'cmbEVENT_YN',          ['YN_CD','YN'],           115, null, false, cmbEVENT_YN);
		/* HACCP인증여부 */
		cmbHACCP_YN        = $erp.getDhtmlXComboCommonCode('cmbHACCP_YN',       'cmbHACCP_YN',          ['YN_CD','YN'],           115, null, false, cmbHACCP_YN);
		
	}
	
	//주소1검색 팝업
	function openSearchPostAddrPopup11(){	 
		var onComplete = function(data){
			var postAddrMap = $erp.getPostAddrMap(data);
			var ZIP_NO = postAddrMap.new_zip;
			var ADDRESS = postAddrMap.new_addr;
			document.getElementById("txtCORP_ZIP_NO").value = ZIP_NO;
			document.getElementById("txtCORP_ADDR").value = ADDRESS;
			document.getElementById("txtCORP_ADDR_DETL").value = '';
			$erp.closePopup2('ERP_POST_WIN_ID');		
		}
		$erp.openSearchPostAddrPopup2(onComplete, {win_id : "ERP_POST_WIN_ID"});
	}
	
	//주소2검색 팝업
	function openSearchPostAddrPopup12(){	 
		var onComplete = function(data){
			var postAddrMap = $erp.getPostAddrMap(data);
			var ZIP_NO = postAddrMap.new_zip;
			var ADDRESS = postAddrMap.new_addr;
			document.getElementById("txtORD_ZIP_NO").value = ZIP_NO;
			document.getElementById("txtORD_ADDR").value = ADDRESS;
			document.getElementById("txtORD_ADDR_DETL").value = '';
			$erp.closePopup2('ERP_POST_WIN_ID');		
		}
		$erp.openSearchPostAddrPopup2(onComplete, {win_id : "ERP_POST_WIN_ID"});
	}

	
	//문자 제거
	function removeChar(event) {
        event = event || window.event;
	    var keyID = (event.which) ? event.which : event.keyCode;
	    if (keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39)
	        return;
	    else
	        //숫자와 소수점만 입력가능
	        event.target.value = event.target.value.replace(/[^-\.0-9]/g, "");
	}

	//콤마 찍기
    function comma(obj) {
        var regx = new RegExp(/(-?\d+)(\d{3})/);
        var bExists = obj.indexOf(".", 0);//0번째부터 .을 찾는다.
        var strArr = obj.split('.');
        
        strArr[0] =  strArr[0].replace(/[^-\.0-9]/g, "");
        while (regx.test(strArr[0])) {//문자열에 정규식 특수문자가 포함되어 있는지 체크
            //정수 부분에만 콤마 달기 
            strArr[0] = strArr[0].replace(regx, "$1,$2");//콤마추가하기
        }
        
        // 소수점 문자열이 발견되지 않을 경우 -1 반환
        if (bExists > -1) {
        	strArr[1].length > 2
        	{
        		strArr[1] =  strArr[1].replace(/[^-\.0-9]/g, "");
        		strArr[1] = strArr[1].substring(0,2);
        	}
            obj = strArr[0] + "." + strArr[1];
        } else { //정수만 있을경우 //소수점 문자열 존재하면 양수 반환 
            obj = strArr[0];
        }
        
        return obj;//문자열 반환
    }
	
	//콤마 풀기
	function uncomma(str) {
	    str = "" + str.replace(/,/gi, ''); // 콤마 제거 
	    str = str.replace(/(^\s*)|(\s*$)/g, ""); // trim()공백,문자열 제거 
	    return (new Number(str));//문자열을 숫자로 반환
	}
	
	//input box 콤마달기
	function inputNumberFormat(obj) {
	    obj.value = comma(obj.value);
	}
	
	//input box 콤마풀기 호출
	function uncomma_call(){
	    var input_value = document.getElementById('input1');
	    input_value.value = uncomma(input_value.value);
	}

	
	/*******************************************************/
	/* 동일한 사업자번호가 존재할 경우 표시해준다          */
	/*******************************************************/
	function corpNumberCheck(obj, isSecond) {
		imsi_corp_no   =  obj.value;
	    var  ll_cnt    =  0;
		if($erp.isEmpty(imsi_corp_no)){
           return;
		}
		
		var validResult = $erp.getBusinessNum(imsi_corp_no);
		
		if(validResult == "사업자등록번호 아님"){
			obj.value = "";
			$erp.initDhtmlXPopupDom(obj,"잘못된 사업자등록번호 형식입니다.");
			return;
		}else{
			obj.value = validResult;
		}
		
		if(isSecond == "isSecond"){
			return;
		}

		var lsCustomer_CD = document.getElementById('txtCUSTMR_CD').value;
		erpLayout.progressOn();

		$.ajax({
			      url : "/sis/basic/getCorpNoCount.do"
				,data : { "CORP_NO"     : imsi_corp_no
					    , "CUSTMR_CD"   : lsCustomer_CD					
				}
			
			,method   : "POST"
			,dataType : "JSON"
			,success  : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					if(data.resultRowCnt > 0){
						$erp.alertMessage({
			    			"alertMessage" : "동일한 사업자번호가 존재합니다."
			    			, "alertType" : "alert"
			    			, "isAjax" : false
			    			, "alertCallbackFn" : function(){
			    				window.close();
								/* 사업자번호가 여럿일경우 팝업을 호출한다. */
								openCustomerinputPopup(imsi_corp_no);
			    			}
			    		});
						
					}					
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		
		
	}

	/*******************************************************/
	/*  사업자번호가 여럿일경우 팝업을 호출한다. @@@@@@@@@@*/
	/*******************************************************/
	function openCustomerinputPopup(imsi_corp_no){
		
		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window("openCustmerSearchPopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
	
		var onConfirm = function(){	}
		
		var url    = "/common/popup/openCustmerSearchPopup.sis";
		var params = { "CORP_NO" : imsi_corp_no }
		
		var option = {
				"win_id" : "openCustmerSearchPopup",
				"width"  : 1050,
				"height" : 600
		}
		var parentWindow = parent;
		var onContentLoaded = function(){
			var popWin = this.getAttachedObject().contentWindow;
			if(parentWindow && typeof parentWindow === 'object'){
				while(popWin.thisParentWindow == undefined){
					popWin.thisParentWindow = parentWindow;
				}
			}
			if(onConfirm && typeof onConfirm === 'function'){
				while(popWin.thisOnConfirm == undefined){
					popWin.thisOnConfirm = onConfirm;    		
				}
			}
			if(onComplete && typeof onComplete === 'function'){
				while(popWin.thisOnComplete == undefined){
					popWin.thisOnComplete = onComplete;    
				}
			}
			this.progressOff();
		}	
		
		$erp.openPopup(url, params, onContentLoaded, option); 
	}
	
	//거래처의 계약서 파일 가져오기
	function getAttachFileList(){
		var url = "/common/system/file/getAttachFileList.do";
		var FILE_GRUP_NO = document.getElementById("txtFILE_GRUP_NO").value;
		if(FILE_GRUP_NO != undefined && FILE_GRUP_NO != null && FILE_GRUP_NO != ""){
			var send_data = {"FILE_GRUP_NO" : FILE_GRUP_NO};
			var if_success = function(data){
				$erp.clearDhtmlXGrid(erp_contract_grid); //기존데이터 삭제
				if($erp.isEmpty(data.gridDataList)){
					//검색 결과 없음
					$erp.addDhtmlXGridNoDataPrintRow(erp_contract_grid, '<spring:message code="info.common.noDataSearch" />');
				}else{
					parseAttachFileList(data.gridDataList);
				}
				$erp.setDhtmlXGridFooterRowCount(erp_contract_grid); // 현재 행수 계산
			}
			var if_error = function(XHR, status, error){}
			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
		}else{
			$erp.addDhtmlXGridNoDataPrintRow(erp_contract_grid, '<spring:message code="info.common.noDataSearch" />');
		}
	}
	
	//조회된 파일 정보 파싱
	function parseAttachFileList(gridDataList){
		$erp.clearDhtmlXGrid(erp_contract_grid); //기존데이터 삭제
		erp_contract_grid.parse(gridDataList,'js');
		$erp.setDhtmlXGridFooterRowCount(erp_contract_grid); // 현재 행수 계산
		erp_contract_grid.groupBy(erp_contract_grid.getColIndexById("FILE_REG_TYPE_NM"));
	}
	
	//속한 거래처 그룹 조회
	function getSearchCustmrGroupList(CUSTMR_CD){
		var url = "/sis/basic/getSearchCustmrGroupList.do";
		var send_data = {"CUSTMR_CD" : CUSTMR_CD};
		var if_success = function(data){
			$erp.clearDhtmlXGrid(erpCustmrGroupGrid); //기존데이터 삭제
			if($erp.isEmpty(data.gridDataList)){
				//검색 결과 없음
				$erp.addDhtmlXGridNoDataPrintRow(erpCustmrGroupGrid, '<spring:message code="info.common.noDataSearch" />');
			}else{
				erpCustmrGroupGrid.parse(data.gridDataList,'js');
			}
			$erp.setDhtmlXGridFooterRowCount(erpCustmrGroupGrid); // 현재 행수 계산
		}
		var if_error = function(XHR, status, error){}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
	}
	
	//계좌정보 저장 function
	function saveAcntInfo(param_CUSTMR_CD, anct_no){
		paramData={};
		paramData["ACNT_NO"] = document.getElementById("txtACNT_NO").value;
		paramData["BANK_CD"] = cmbBANK_CD.getSelectedValue();
		paramData["CUSTMR_CD"] = document.getElementById("txtCUSTMR_CD").value;
		
		var anctNo = acnt_no;
		if(anctNo == "" || anctNo == null || anctNo == undefined){
			$erp.alertMessage({
				"alertMessage" : "협력사계좌정보관리 페이지에서 <br>계좌정보를 먼저 등록해주세요.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else{
			$erp.confirmMessage({
				"alertMessage" : "계좌정보가 저장됩니다.<br>진행하시겠습니까?",
				"alertType" : "alert",
				"isAjax" : false,
				"alertCallbackFn" : function confirmAgain(){
					var url = "/sis/basic/saveAcntInfo.do";
					var send_data = paramData;
					var if_success = function(data){
						$erp.alertMessage({
							"alertMessage" : "저장이 완료되었습니다.",
							"alertCode" : null,
							"alertType" : "alert",
							"isAjax" : false
						});
					}
					var if_error = function(){}
							
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
				}
			});
		}
	}
	
</script>
</head>
<body>

	<div id="div_erp_basic_layout"    class="samyang_div" style="display:none">
		
		<!--  1단 리본 -->
		<div id="div_erp_ribbon"      class="samyang_div" style="display:none"></div>
		
		<!--  2단 거래처구분/거래 -->
		<div id="div_erp_top_layout"   class="samyang_div" style="display:none;">

				<table id="tb_erp_data" class="table" >
				<tr>
					<th colspan="2">거래처명</th>
					<td colspan="4"><input type="text" id="txtCUSTMR_NM" name="CUSTMR_NM" class="input_text input_essential" maxlength="50" data-isEssential="true"></td>
					<th colspan="2">거래구분</th>
					<td colspan="3"><div id="cmbPUR_SALE_TYPE" data-isEssential="true"></div> </td>
					<th colspan="2">거래처 유형</th>
					<td colspan="3"><div id="cmbCUSTMR_GRUP" data-isEssential="true"></div> </td>
					<c:choose>
						<c:when test="${param.pur_sale_type == '협력사'}">
							<th colspan="2">기준가그룹</th>
							<td colspan="3"><div id="cmbCUSTMR_PRICE_GRUP"></div> </td>
							<th colspan="2">매입유형</th>
							<td colspan="3"> <div id="cmbPUR_TYPE" data-isEssential="true"></div> </td>
							<th colspan="2">협력사분류</th>
							<td colspan="3"> <div id="cmbSUPR_GRUP_CD" data-isEssential="true"></div> </td>
<!-- 							<td colspan="2" style="display:none;"><div id="cmbSUPR_TYPE" data-isEssential="true" style="display:none;"></div> </td> -->
						</c:when>
						<c:otherwise>
							<th colspan="2">기준가그룹</th>
							<td colspan="13"><div id="cmbCUSTMR_PRICE_GRUP"></div> </td>
						</c:otherwise>
					</c:choose>
					
				</tr>
			
				<tr>
					<th colspan="2">거래처코드</th>
					<td colspan="4">
						<input type="text" id="txtCUSTMR_CD" name="CUSTMR_CD" class="input_text input_readonly" maxlength="10" readonly disabled>
						<input type="hidden" id="txtFILE_GRUP_NO" class="input_text">
					</td>
					<th colspan="2">업태</th>
					<td colspan="3"><input type="text" id="txtBUSI_COND" name="BUSI_COND" class="input_text input_essential" maxlength="50" data-isEssential="true"></td>
					<th colspan="2">전화번호</th>
					<td colspan="3"><input type="text" id="txtTEL_NO" name="TEL_NO" class="input_phone input_essential" style = "text-width:150" maxlength="50" data-isEssential="true"></td>
					<th colspan="2">사업자번호</th>
					<td colspan="3"><input type="text" id="txtCORP_NO" name="CORP_NO" class="input_text input_essential" maxlength="16" data-isEssential="true" data-type="businessNum" onchange="corpNumberCheck(this);"></td>
					<c:choose>
						<c:when test="${param.pur_sale_type == '협력사'}">
							<th colspan="2">구매담당자</th>
						</c:when>
						<c:otherwise>
							<th colspan="2">영업담당자</th>
						</c:otherwise>
					</c:choose>
					<td colspan="3"><input type="text" id="txtORD_RESP_USER" name="ORD_RESP_USER" class="input_text input_essential" style = "width: 120px;" maxlength="50" data-isEssential="true"></td>
					<th colspan="2">센터담당자</th>
					<td colspan="3"><input type="text" id="txtCENT_RESP_USER" name="CENT_RESP_USER" class="input_text" style = "width: 240px;" maxlength="50"></td>
				</tr>
			
				<tr>
					<th colspan="2">이메일</th>
					<td colspan="4"><input type="text" id="txtEMAIL" name="EMAIL" class="input_text input_essential" maxlength="100" data-isEssential="true" data-type="email"></td>
					<th colspan="2">업종</th>
					<td colspan="3"><input type="text" id="txtBUSI_TYPE" name="BUSI_TYPE" class="input_text input_essential" maxlength="50" data-isEssential="true"></td>
					<th colspan="2">팩스</th>
					<td colspan="3"><input type="text" id="txtFAX_NO" name="FAX_NO" class="input_text" maxlength="20"></td>
					<th colspan="2">대표자명</th>
					<td colspan="3"><input type="text" id="txtCUSTMR_CEONM" name="CUSTMR_CEONM" class="input_text input_essential" maxlength="50" data-isEssential="true"></td>
					<th colspan="3">부가세제외여부</th>
					<td colspan="2"><div   id="cmbEXC_VAT"></div></td>
					<th colspan="2">배송담당자</th>
					<td colspan="3"><input type="text" id="txtDELI_RESPUSER" name="DELI_RESPUSER" class="input_text" style = "width: 240px;" maxlength="10"></td>
				</tr>
				<tr>
					<th colspan="3">대표자휴대폰</th>
					<td colspan="3"><input type="text" id="txtCEO_TEL" name="CEO_TEL" class="input_phone"  maxlength="20"></td>
					<th colspan="2">담당자명</th>
					<td colspan="3"><input type="text" id="txtRESP_USER_NM" name="RESP_USER_NM" class="input_text input_essential" maxlength="10" data-isEssential="true"></td>
					<th colspan="2">담당자휴대폰</th>
					<td colspan="3"><input type="text" id="txtPHON_NO" name="PHON_NO" class="input_text input_phone" maxlength="20"></td>
					<th colspan="2">검색창내용</th>
					<td colspan="6"><input type="text" id="txtKEYWD" name="KEYWD" class="input_text" style = "width: 240px;" maxlength="100"></td>
					<th colspan="2">홈페이지</th>
					<td colspan="5"><input type="text" id="txtSITEURL" name="SITEURL" class="input_text" maxlength="50"></td>
				</tr>
				<tr>
					<th colspan="3">종사업장번호</th>
					<td colspan="3">
						<input type="text" id="txtCORP_ORI_NO" name="CORP_ORI_NO" class="input_text" maxlength="16" data-type="businessNum" onchange="corpNumberCheck(this,'isSecond');">
					</td>
					<th colspan="2">휴/폐업일자</th>
					<td colspan="3"><input type="text" id="txtCLSE_BUSI_DATE" name="CLSE_BUSI_DATE" class="input_common input_calendar"></td>
					<th colspan="2">거래상태여부</th>
					<td colspan="3"><div id="cmbUSE_YN"></div> </td>
					<th colspan="2">결제기준</th>
					<td colspan="6">
						<div id="cmbPAY_STD" style="float:left;"></div>
						<div id="cmbPAY_DATE_TYPE" style="float:left;"></div> 
					</td>
					<th colspan="2">휴/폐업상태</th>
					<td colspan="5"><div id="cmbSUPR_STATE" data-isEssential="true"></div></td>
				</tr>
			
				<tr>
					<th id = acnt_th colspan="3"></th>
					<td id = acnt_td colspan="3"></td>
					<td colspan="25">
						<div id = "cmbBANK_CD" style="display: inline-flex;"></div>
						<c:choose>
						<c:when test="${param.pur_sale_type == '협력사'}">
							<input type="button" id="btnBANK_CD" class="input_common_button" value="계좌정보 저장" onclick="saveAcntInfo();" style="display: inline-flex;"/>
						</c:when>
						<c:otherwise>
							<!-- 로직없음 -->
						</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>
		</div>

	    <!--  3단 우편번호/ 배송요일 -->
		<div id="div_erp_mid_layout" class="samyang_div" style="display:none">

		    <!--  3-1단 우편번호 -->
			<div id="div_erp_addr_condition"  class="samyang_div" style="display:none">
				<table id="tb_erp_address" class="tb_erp_common"  style="margin-top:0px;">
		
					<colgroup>
						<col width="100px" />
						<col width="*" />
					</colgroup>
		
					<tr>
						<th>우편번호1</th>
						<td>
							<input type="text" id="txtCORP_ZIP_NO" name="CORP_ZIP_NO" class="input_common input_essential input_readonly" maxlength="10" readonly disabled data-isEssential="true">
							<input type="button" id="btnSearchPost" class="input_common_button" value="주소검색" onclick="openSearchPostAddrPopup11();" />
						</td>
					</tr>
					<tr>
						<th>기본주소1</th>
						<td colspan="2">
							<input type="text" id="txtCORP_ADDR" name="CORP_ADDR" class="input_common input_essential input_readonly" style="text-align:left; width:400px;" readonly disabled data-isEssential="true">
						</td>
					</tr>
					<tr>
						<th>상세주소1</th>
						<td colspan="2">
							<input type="text" id="txtCORP_ADDR_DETL" name="CORP_ADDR_DETL" class="input_common input_essential" style="text-align:left; width:400px" data-isEssential="true">
						</td>
					</tr>
		
					<tr>
						<th>우편번호2</th>
						<td>
							<input type="text" id="txtORD_ZIP_NO" name="ORD_ZIP_NO" class="input_common input_readonly" maxlength="10" readonly disabled>
							<input type="button" id="btnSearchPost2" class="input_common_button" value="주소검색" onclick="openSearchPostAddrPopup12();" />
						</td>
					</tr>
					<tr>
						<th>기본주소2</th>
						<td colspan="2">
							<input type="text" id="txtORD_ADDR" name="ORD_ADDR" class="input_common input_readonly" style="text-align:left; width:400px" readonly disabled>
							
						</td>
					</tr>
					<tr>
						<th>상세주소2</th>
						<td colspan="2">
							<input type="text" id="txtORD_ADDR_DETL" name="ORD_ADDR_DETL" class="input_common" style="text-align:left; width:400px">
						</td>
					</tr>
			
				</table>	
			
			</div>
			
			<!--3-2 배송요일  &&  배송요일 -->
			<div id="div_erp_delivery_condition" class="samyang_div" style="display:none"> </div>
			<div id="div_erp_send_condition" class="samyang_div" style="display:none">
				<table id="tb_erp_send" class="tb_erp_common" style="margin-top:0px;">
		
					<colgroup>
						<col width="100px" />
						<col width="50px" />
						<col width="50px" />
						<col width="50px" />
						<col width="50px" />
						<col width="50px" />
						<col width="50px" />
						<col width="50px" />
						<col width="100px" />
						<col width="50px" />
						<col width="*" />
					</colgroup>
		
					<tr>
						<th>배송요일</th>
						<td>
							<label for="pos_give_point">월</label>
							<input type="checkbox" id="chkSend_mon" name="Select_Goods" style="text: center;"/>
						</td>
						<td>
							<label for="pos_give_point">화</label>
							<input type="checkbox" id="chkSend_tue" name="Select_Goods" style="text: centert;"/>
						</td>
						<td>
							<label for="pos_give_point">수</label>
							<input type="checkbox" id="chkSend_wed" name="Select_Goods" style="text: center;"/>
						</td>
						<td>
							<label for="pos_give_point">목</label>
							<input type="checkbox" id="chkSend_thu" name="Select_Goods" style="text: center;"/>
						</td>
						<td>
							<label for="pos_give_point">금</label>
							<input type="checkbox" id="chkSend_fri" name="Select_Goods" style="text: center;"/>
						</td>
						<td>
							<label for="pos_give_point">토</label>
							<input type="checkbox" id="chkSend_sat" name="Select_Goods" style="text: center;"/>
						</td>
						<td>
							<label for="pos_give_point">일</label>
							<input type="checkbox" id="chkSend_sun" name="Select_Goods" style="text: center;"/>
						</td>
						<th>리드타임</th>
						<td><input type="text" id="txtLEAD_TIME" name="LEAD_TIME" class="input_money" maxlength="20">일</td>
                        <!-- 동일사업자번호 체크용 
 					    <td><input type="text" id="txtCORP_CNT" name="CORP_CNT" class="input_money" ></td>  -->
					</tr>
				</table>	
			</div>	
			
			<div id="div_erp_minput_condition" class="samyang_div" style="display:none">
		
				<table id="tb_erp_smallbalju" class="tb_erp_common" style="margin-top:0px;">
					<colgroup>
						<col width="120px" />
						<col width="150px" />
						<col width="150px" />
						<col width="150px" />
						<col width="*" />
					</colgroup>
					
					<tr>
						<th>최저발주금액</th>
						<td><input type="text" id="txtMIN_PUR_AMT" name="MIN_PUR_AMT" class="input_money" maxlength="50" style="width:125px;"">원</td>
						<th>발주마감시간</th>
						<td><div id="cmbCletimeHour"></div> </td>
						<td><div id="cmbCletimeMin" ></div> </td>
					</tr>
					
				</table>
				
			</div>
			
		</div>
		
		<!-- 4단  신용/여신정보 && 계층그룹 -->
		<div id="div_erp_bot_layout" class="samyang_div" style="display:none">
		    <!-- 4-1단 신용/여신정보  -->
			<div id="div_erp_credit_condition" class="samyang_div" style="display:none">
			
				<table id="tb_erp_level" class="tb_erp_common"  style="margin-top:0px;">
					<colgroup>
						<col width="120px" />
						<col width="120px" />
						<col width="120px" />
						<col width="120px" />
						<col width="120px" />
						<col width="120px" />
						<col width="120px" />
						<col width="120px" />
						<col width="*" />
					</colgroup>
		
					<tr>
						<th colspan="9" style="text-align: center">여신</th>
					</tr>
		
					<tr>
						<th>여신가능여부</th>
						<td colspan="8">
							<div id="cmbLOAN_YN"></div>
							<input type="hidden" id="txtLOAN_CD" class="input_text" value=""/>
						</td>
					</tr>
		
					<tr id="LOAN_TR">
<!-- 						<th>현금보증</th> -->
<!-- 						<td><input type="text" id="txtCASH_AMT" name="CASH_AMT" class="input_money" style = "text_align:right;"  maxlength="50" readonly="readonly"></td> -->
<!-- 						<th>보증증권</th> -->
<!-- 						<td colspan="2"> <input type="text" id="txtGRNT_AMT" name="GRNT_AMT" class="input_money" maxlength="50"  style = "text-align:right;" readonly="readonly"></td> -->
					</tr>
					
					<tr>
						<th colspan="9" style="text-align: center">기타</th>
					</tr>
		
					<tr>
						<c:choose>
							<c:when test="${param.pur_sale_type == '협력사'}">
								<th colspan="1">신규상품수수료율</th>
								<td colspan="2"><input type="text" id="txtGOODS_FEE" name="GOODS_FEE" onfocus="removeChar(event);" style = "text-align:right; width: 125px;" readonly="readonly">%</td>
								<th colspan="1">행사차단여부</th>
								<td colspan="2"><div id="cmbEVENT_YN"></div> </td>
								<th>HACCP인증여부</th>
								<td colspan="3"><div id="cmbHACCP_YN"></div></td>
							</c:when>
							<c:otherwise>
								<th colspan="1">신규상품수수료율</th>
								<td colspan="2"><input type="text" id="txtGOODS_FEE" name="GOODS_FEE" onfocus="removeChar(event);" style = "text-align:right; width: 125px;" readonly="readonly">%</td>
								<th colspan="1">행사차단여부</th>
								<td colspan="4"><div id="cmbEVENT_YN"></div> </td>
								<th style="display :none">HACCP인증여부</th>
								<td style="display :none"><div id="cmbHACCP_YN"></div></td>
							</c:otherwise>
						</c:choose>
					</tr>
					<c:choose>
						<c:when test="${param.pur_sale_type == '협력사'}">
							<tr>
								<th colspan="1">매장장려금요율</th>
								<td colspan="2"><input type="text" id="txtMK_INCEN_RATE" name="MK_INCEN_RATE" onfocus="removeChar(event);" style = "text-align:right; width: 125px;" readonly="readonly">%</td>
								<th colspan="1">센터물류비요율</th>
								<td colspan="6"><input type="text" id="txtCENT_INCEN_RATE" name="CENT_INCEN_RATE" onfocus="removeChar(event);" style = "text-align:right; width: 125px;"readonly="readonly">%</td>
							</tr>
						</c:when>
						<c:otherwise>
							<!-- 로직없음 -->
						</c:otherwise>
					</c:choose>
		
					<tr>
						<th>메모</th>
						<td colspan="8"> <input type="text" id="txtMEMO" name="MEMO" class="input_text" maxlength="50"></td>
				        <!-- textarea 변환시 사용할것
				             <td colspan="3"><textarea rows="10 id="txtMEMO" name="MEMO class="input_text" readonly="readonly" >${CustContent.MEMO}</textarea></td>
				         -->
					</tr>
					
				</table>		
			
<!-- 				<div id="div_erp_CustmrGroup_grid" class="div_grid_full_size" style="display:none"></div> -->
			</div>
				
			<!-- 4-2단 계층그룹 -->
			<div id="div_erp_contract_layout" class="samyang_div" style="display:none">
				<div id="div_erp_contract_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
				<div id="div_erp_contract_grid" class="div_grid_full_size" style="display:none"></div>
		    </div>
			
		</div>
	</div>
		
</body>
</html>