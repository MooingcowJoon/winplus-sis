<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript">
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbPartnerIO : Object / 거래처구분(매입 or 매출) DhtmlXCombo  (CODE : PUR_SALE_TYPE )
		■ cmbPamentDay : Object / 마감일자(결제기준) DhtmlXCombo  (CODE : PAY_STD ) 		 
		■ cmbSourcing : Object / 마감일자(결제기준) DhtmlXCombo  (CODE : SUPR_GOODS_GRUP ) 		 
		■ cmbPartnerPart : Object / 공급사분류코드 DhtmlXCombo  (CODE : SUPR_GRUP_CD ) 		 
		■ cmbPartnerType : Object / 공급사유형  DhtmlXCombo  (CODE : SUPR_TYPE ) 		 
	--%>
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	
	var LOGIN_ORGN_DIV_CD    =   "";
	var LOGIN_ORGN_DIV_NM    =   "";
	var LOGIN_ORGN_DIV_TYP   =   "";
	var LOGIN_ORGN_CD        =   "";
	var LOGIN_ORGN_NM        =   "";
	var LOGIN_EMP_NO         =   "";
	var LOGIN_EMP_NM         =   "";	
	
	var erpLayout;
	var erpRibbon;	
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;	
	var cmbIN_WARE_CD;                 /* 입고창고           */
	var cmbORD_STATE;               /* 발주진행상태       */
	var erpGridSelectedCustmr_cd;   /* 그리드 rowSelected */

	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;

	//console.log("LUI.LUI_orgn_div_cd=>" + LUI.LUI_orgn_div_cd);
	//console.log("LUI.LUI_orgn_cd=>" + LUI.LUI_orgn_cd);
	
	//GLOVAL_ORGN_DIV_CD = LUI.LUI_orgn_div_cd; /* 조직구분코드 */
	//GLOVAL_ORGN_CD     = LUI.LUI_orgn_cd;     /* 조직코드     */
	
	$(document).ready(function(){		
		initErpLayout();
		initErpRibbon();
		getLoginOrgInfo();
		initErpGrid();
		
		document.getElementById("searchordStrDt").value=todayDate;
		document.getElementById("searchordEndDt").value=today;
				
	});
	
	/****************************************************************************/
    /* erpLayout 초기화                                                         */
    /****************************************************************************/	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "${menuDto.menu_nm}", header:true, height:90}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
		});
	}
	
	/***************************************************/
	/* Login Id 조직 및 권한구하기 
	/***************************************************/
	function getLoginOrgInfo( ){
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/order/getLoginOrgInfo.do"
			,data : { "LoginID"  : "" }
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					LOGIN_ORGN_DIV_CD    =   data.gridDataList.ORGN_DIV_CD;
					LOGIN_ORGN_DIV_NM    =   data.gridDataList.ORGN_DIV_CD_NM;
					LOGIN_ORGN_DIV_TYP   =   data.gridDataList.ORGN_DIV_TYPE;
			        LOGIN_ORGN_CD        =   data.gridDataList.DEPT_CD;
			        LOGIN_ORGN_NM        =   data.gridDataList.ORGN_NM;
			        LOGIN_EMP_NO         =   data.gridDataList.EMP_NO;
			        LOGIN_EMP_NM         =   data.gridDataList.EMP_NM;
			        
					console.log("LOGIN_ORGN_DIV_CD=>"   + LOGIN_ORGN_DIV_CD);          
					console.log("LOGIN_ORGN_DIV_NM=>"   + LOGIN_ORGN_DIV_NM);          
					console.log("LOGIN_ORGN_DIV_TYP=>"  + LOGIN_ORGN_DIV_TYP);          
					console.log("LOGIN_ORGN_CD=>"       + LOGIN_ORGN_CD);          
					console.log("LOGIN_ORGN_NM=>"       + LOGIN_ORGN_NM);          
					console.log("LOGIN_EMP_NO=>"        + LOGIN_EMP_NO);          
					console.log("LOGIN_EMP_NM=>"        + LOGIN_EMP_NM);  
					initDhtmlXCombo();
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}		

	/****************************************************************************/
    /* erpRibbon 초기화                                                         */
    /****************************************************************************/	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						  {id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
						, {id : "add_erpGrid",    type : "button", text:'<spring:message code="ribbon.add" />',    isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "save_erpGrid",   type : "button", text:'<spring:message code="ribbon.save" />',   isbig : false, img : "menu/save.gif",   imgdis : "menu/save_dis.gif",   disable : true}
						, {id : "excel_erpGrid",  type : "button", text:'<spring:message code="ribbon.excel" />',  isbig : false, img : "menu/excel.gif",  imgdis : "menu/excel_dis.gif",  disable : true}
						, {id : "excel_erpGri1",  type : "button", text:'email발송',                               isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "excel_erpGri2",  type : "button", text:'Fax발송',                                 isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />',   isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif",   disable : true}		
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "add_erpGrid"){
		    	addErpGrid();
		    } else if (itemId == "delete_erpGrid"){
		    	$erp.alertMessage({
					"alertMessage" : "준비 중 입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
		    	//deleteErpGrid();
		    } else if (itemId == "save_erpGrid"){
		    	$erp.alertMessage({
					"alertMessage" : "준비 중 입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
		    	//saveErpGrid();
		    } else if (itemId == "excel_erpGrid"){
		    	$erp.exportGridToExcel({
		    		"grid" : erpGrid
					, "fileName" : "발주서등록(센터)_OLD"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
		    } else if (itemId == "excel_erpGri1"){
		    	$erp.alertMessage({
					"alertMessage" : "준비 중 입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
		    } else if (itemId == "excel_erpGri2"){
		    	$erp.alertMessage({
					"alertMessage" : "준비 중 입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
		    } else if (itemId == "print_erpGrid"){
		    	$erp.alertMessage({
					"alertMessage" : "준비 중 입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
		    }
		});
	}
	
	/****************************************************************************/
    /* erpGrid 초기화                                                           */
    /****************************************************************************/	
	function initErpGrid(){
		erpGridColumns = [
			      {id : "NO"               , label:["NO"                , "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
				, {id : "CHECK"            , label:["#master_checkbox"  , "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
				, {id : "ORGN_DIV_CD"      , label:["조직영역코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_CD"          , label:["조직코드"          , "#text_filter"], type: "ro", width: "200", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_NO"           , label:["발주번호"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "OUT_WARE_CD"      , label:["OUT_WARE_CD"       , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_NM"          , label:["고객사"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false , isEssential : true}
				, {id : "IN_WARE_CD"       , label:["입고창고코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "IN_WARE_NM"       , label:["입고창고"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "SUPR_CD"          , label:["협력사코드"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "SUPR_NM"          , label:["협력사명"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "PROJ_CD"          , label:["프로젝트코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "PROJ_NM"          , label:["프로젝트명"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true, isEssential : true}
				, {id : "SUPR_AMT"         , label:["공급가액"          , "#text_filter"], type: "ron", width: "80", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"          , label:["부가세"            , "#text_filter"], type: "ron", width: "80", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"          , label:["합계금액"          , "#text_filter"], type: "ron", width: "80", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "GOODS_NM"         , label:["발주상품"          , "#text_filter"], type: "ro", width: "200", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "DELI_DATE"        , label:["납기일자"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "ORD_DATE"         , label:["발주일시"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "ORD_TYPE"         , label:["발주유형"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_TYPE_NM"      , label:["발주유형"          , "#text_filter"], type: "ro", width: "80" , sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "ORD_STATE"        , label:["발주상태"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_STATE_NM"     , label:["발주상태"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "RETN_YN"          , label:["반품여부"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "SEND_FAX_STATE"   , label:["FAX발송"           , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "SEND_EMAIL_STATE" , label:["Email발송"         , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "RESP_USER"        , label:["담당자코드"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "EMP_NM"           , label:["담당자명"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "ORGN_DIV_NM"      , label:["조직영역이름"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_DIV_TYP"     , label:["조직영역유형"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
		});		
		
		erpGrid.enableDistributedParsing(true, 100, 50);
		erpGridDataProcessor =$erp.initGrid(erpGrid);
		$erp.initGridDataColumns(erpGrid);
		
		erpGrid.attachEvent("onRowDblClicked", function(rowId, columnIdx){
			var ORD_NO       = this.cells(rowId, this.getColIndexById("ORD_NO")).getValue()
			var ORGN_DIV_CD  = this.cells(rowId, this.getColIndexById("ORGN_DIV_CD")).getValue()
			var ORGN_DIV_NM  = this.cells(rowId, this.getColIndexById("ORGN_DIV_NM")).getValue()
			var ORGN_DIV_TYP = this.cells(rowId, this.getColIndexById("ORGN_DIV_TYP")).getValue()
			var ORGN_CD      = this.cells(rowId, this.getColIndexById("ORGN_CD")).getValue()
			var ORGN_NM      = this.cells(rowId, this.getColIndexById("ORGN_NM")).getValue()
			
			openCustomerinputPopup(ORD_NO, ORGN_DIV_CD, ORGN_DIV_NM, ORGN_DIV_TYP, ORGN_CD, ORGN_NM);
		});
		
	}

	/****************************************************************************/
    /* 더블클릭시 발주서(입력/수정) 팝업화면 호출                               */
    /****************************************************************************/	
	function openCustomerinputPopup(ORD_NO, ORGN_DIV_CD, ORGN_DIV_NM, ORGN_DIV_TYP, ORGN_CD, ORGN_NM){
		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window("openOrderInputGridPopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
			
		}
		/* ORGN_DIV_TYP 조직유형  센타 : B로 Default 세팅 */
		var url = "/common/popup/openOrderInputGridPopup.sis";
		var params = {    "SELECT_ORGN_DIV_CD"  : ORGN_DIV_CD
		                , "SELECT_ORGN_DIV_NM"  : ORGN_DIV_NM
		                , "SELECT_ORGN_DIV_TYP" : ORGN_DIV_TYP
				        , "SELECT_ORGN_CD"      : ORGN_CD
				        , "LOGIN_ORGN_NM"       : ORGN_NM
				        , "LOGIN_ORD_NO"        : ORD_NO 
				        , "LOGIN_ORGN_DIV_CD"   : LOGIN_ORGN_DIV_CD
		                , "LOGIN_ORGN_CD"       : LOGIN_ORGN_CD
		                , "LOGIN_ORGN_DIV_TYP"  : LOGIN_ORGN_DIV_TYP
		              }
		
		var option = {
				"win_id" : "openOrderInputGridPopup",
				"width"  : 1400,
				"height" : 800
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
	
	
	/****************************************************************************/
    /* 협력사명 선택 팝업호출                                                   */
    /****************************************************************************/	
	function openSearchCustmrGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "1"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		var onRowSelect = function(id, ind) {
			document.getElementById("hidSurp_CD").value = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	/****************************************************************************/
    /* 담당자 선택 팝업호출                                                   */
    /****************************************************************************/	
	function openSearchComEmpNoGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var onRowSelect = function(id, ind) {
			document.getElementById("txtRESP_USER").value = this.cells(id, this.getColIndexById("EMP_NO")).getValue();
			document.getElementById("RESP_USER_NAME").value = this.cells(id, this.getColIndexById("EMP_NM")).getValue();
			
			$erp.closePopup();
		}
		$erp.searchComEmpNoPopup(onRowSelect);
		
	}
	
	/****************************************************************************/
    /* 프로젝트 선택 팝업호출                                                   */
    /****************************************************************************/	
	function openSearchProjectGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var onRowSelect = function(id, ind) {
			document.getElementById("hidProj_CD").value = this.cells(id, this.getColIndexById("CMMN_DETAIL_CD")).getValue();
			document.getElementById("CMMN_DETAIL_CD_NM").value = this.cells(id, this.getColIndexById("CMMN_DETAIL_CD_NM")).getValue();
			
			$erp.closePopup();
		}
		$erp.searchProjectPopup(onRowSelect);
	}
	
	
	/****************************************************************************/
    /* 그리드 row더블클릭시 발주서 조회한다  Function                           */
    /****************************************************************************/	
	function searchErpDetailGrid(){
		if(!isSearchDetailValidate()){
			return;
		}
		erpLayout.progressOn();
		
		$.ajax({
			  url : "/sis/basic/getCustomer.do"
			,data : {
				     "CUSTMR_CD" : erpGridSelectedCustmr_cd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpDetailGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpDetailGrid.parse(gridDataList, 'js');
						erpDetailGrid.expandAll();	
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}

	
	function isSearchDetailValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(erpGridSelectedCustmr_cd)){
			isValidated = false;
			alertMessage = "error.common.noSelectedData";
			alertCode = "-1";
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
	
	/***************************************************/
	/* 그리드 조회
	/***************************************************/
	function searchErpGrid(){

		erpLayout.progressOn();
		
		var scrin_searchordStrDt  = document.getElementById("searchordStrDt").value;
		var scrin_searchordEndDt  = document.getElementById("searchordEndDt").value;
		
		scrin_searchordStrDt      = scrin_searchordStrDt.replace (/-/g, "")
		scrin_searchordEndDt      = scrin_searchordEndDt.replace (/-/g, "")
		
		//alert(" scrin_searchordStrDt===>=" + scrin_searchordStrDt + " scrin_searchordEndDt===>=" + scrin_searchordEndDt);
		var scrin_ORD_NO          = document.getElementById("txtORD_NO").value;
		var scrin_Surp_CD         = document.getElementById("hidSurp_CD").value;
		var scrin_searchdelStrDt  = document.getElementById("searchdelStrDt").value;
		var scrin_searchdelEndDt  = document.getElementById("searchdelEndDt").value;
		
		scrin_searchdelStrDt      = scrin_searchdelStrDt.replace (/-/g, "")
		scrin_searchdelEndDt      = scrin_searchdelEndDt.replace (/-/g, "")
		//alert(" scrin_searchdelStrDt===>=" + scrin_searchdelStrDt + " scrin_searchdelEndDt===>=" + scrin_searchdelEndDt);
		
		var scrin_Proj_CD         = document.getElementById("hidProj_CD").value;
		var scrin_RESP_USER_CD    = document.getElementById("txtRESP_USER").value;
		
		var scrin_InWare_CD       = cmbIN_WARE_CD.getSelectedValue();
		var scrin_ORD_STATE       = cmbORD_STATE.getSelectedValue();

		var scrn_ORGN_DIV_CD      = "";
		var scrn_ORGN_CD          = "";
		
		/* 센터조직이면 login한 조직을 세팅한다 */
	    if ( LOGIN_ORGN_DIV_TYP == "B" ) {
	    	scrn_ORGN_DIV_CD = LOGIN_ORGN_DIV_CD;
	    	scrn_ORGN_CD     = LOGIN_ORGN_CD;
	    }
		
		$.ajax({
			url : "/sis/order/getSearchOrderList.do"
			,data : {
						  "PARAM_ORGN_DIV_CD"      : scrn_ORGN_DIV_CD
						, "PARAM_ORGN_CD"          : scrn_ORGN_CD
						, "PARAM_ORD_STR_YYYYMMDD" : scrin_searchordStrDt
						, "PARAM_ORD_END_YYYYMMDD" : scrin_searchordEndDt
						, "PARAM_ORD_NO"           : scrin_ORD_NO
						, "PARAM_DEL_STR_YYYYMMDD" : scrin_searchdelStrDt
						, "PARAM_DEL_END_YYYYMMDD" : scrin_searchdelEndDt
						, "PARAM_PROJ_CD"          : scrin_Proj_CD
						, "PARAM_IN_WARE_CD"       : scrin_InWare_CD
						, "PARAM_SUPR_CD"          : scrin_Surp_CD
						, "PARAM_RESP_USER"        : scrin_RESP_USER_CD
						, "PARAM_ORD_STATE"        : scrin_ORD_STATE
						, "PARAM_ORD_TYPE"         : ""          /*  2019-11-03 null처리  1: 물류발주, 2:직납발주, 3:신선발주, 4.착지변경   */
						, "LOGIN_CHANNEL"          : "S"         /*  S: SIS,  P:PORTAL */
						, "LOGIN_MENU"             : "CTM"       /*  센터발주서조회  */
					}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpGrid.parse(gridDataList, 'js');	
						erpGrid.selectRowById(1);   
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	/*****************************************/
	/*  발주서 등록                         */
	/*****************************************/
	function addErpGrid(){
		openCustomerinputPopup(null, LOGIN_ORGN_DIV_CD, LOGIN_ORGN_DIV_NM, LOGIN_ORGN_DIV_TYP, LOGIN_ORGN_CD, LOGIN_ORGN_NM);
	}
		
	/***************************************************/
	/* 그리드 삭제 
	/***************************************************/
	function deleteErpGrid(){
		var gridRowCount = erpGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpGrid.getRowId(i);
			var check = erpGrid.cells(rId, erpGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(rId);
			}
		}
		
		if(deleteRowIdArray.length == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}
		
		for(var i = 0; i < deleteRowIdArray.length; i++){
			erpGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	/***************************************************/
	/* 그리드 저장 
	/***************************************************/
	function saveErpGrid(){
		if(erpGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpGrid);
		if(validResultMap.isError){
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode"  : validResultMap.errCode
				, "alertType"  : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);		
		$.ajax({
			url : "/common/system/menu/screenManagementCUD1.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.alertSuccessMesage(onAfterSaveErpGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpGrid 저장 후 Function --%>
	function onAfterSaveErpGrid(){
		searchErpGrid();
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%--
	**************************************************
	* 기타 영역
	**************************************************
	--%>	
	
	/***************************************************/
	/* CPOMBO박스처리 
	/***************************************************/
	function initDhtmlXCombo(){
		/* 입고창고 */
		cmbIN_WARE_CD = $erp.getDhtmlXComboCommonCode('cmbIN_WARE_CD',     'cmbIN_WARE_CD',  ["ORGN_CD","CT"],  135,  "모두조회",  false, cmbIN_WARE_CD);
		
		/* 발주진향상태 */
		cmbORD_STATE   = $erp.getDhtmlXComboCommonCode('cmbORD_STATE',   'cmbORD_STATE',  'ORD_STATE',   177,  "모두조회",  true);
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>				
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search" id="aaa">
			<colgroup>
				<col width="100px">
				<col width="120px">
				<col width="120px">
				
				<col width="170px">	
				<col width="120px">
				<col width="120px">	
				
				<col width="80px">
				<col width="120px">	
				<col width="120px">
				<col width="160px">	
				<col width="*">				
			</colgroup>
			<tr>
				<th>발주기간</th>
				<td colspan="2">
					<input type="text" id="searchordStrDt" name="searchordStrDt" class="input_common input_calendar" > ~
					<input type="text" id="searchordEndDt" name="searchordEndDt" class="input_common input_calendar">
				</td>
				
				<th>발주번호</th>
				<td colspan="2"><input type="text" id="txtORD_NO" name="ORD_NO" class="input_common" maxlength="20" ></td>
				
				<th>협력사명</th>
				<td colspan="2">
					<input type="hidden" id="hidSurp_CD">
					<input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Custmr_Search" value="검 색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/>
				</td>

				<th>담당자명</th>
				<td>
					  <input type="hidden" id="txtRESP_USER">
					  <input type="text" id="RESP_USER_NAME" name="RESP_USER_NAME" readonly="readonly" disabled="disabled"/>
					  <input type="button" id="resp_user_Search" value="검 색" class="input_common_button" onclick="openSearchComEmpNoGridPopup();"/>
				</td>
			</tr>
			
			
			<tr>
				<th>납기일자</th>
				<td colspan="2">
					<input type="text" id="searchdelStrDt" name="searchdelStrDt" class="input_common input_calendar"> ~
					<input type="text" id="searchdelEndDt" name="searchdelEndDt" class="input_common input_calendar">
				</td>
				
				<th>입고창고</th>
				<td colspan="2">
				    <div id="cmbIN_WARE_CD"></div>
				</td>
				
				<th>프로젝트</th>
				<td colspan="2">
					<input type="hidden" id="hidProj_CD">
					<input type="text" id="CMMN_DETAIL_CD_NM" name="CMMN_DETAIL_CD_NM" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Poject_Search" value="검 색" class="input_common_button" onclick="openSearchProjectGridPopup();"/>
				</td>

				<th>발주진행상태</th>
				<td>
				    <div id="cmbORD_STATE"></div>
				</td>
			</tr>
			
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid"   class="div_grid_full_size"   style="display:none"></div>
</body>

	
</html>