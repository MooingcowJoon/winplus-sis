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
		※ 전역 변수 선언부(발주서 현황)
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
						, {id : "excel_erpGrid",  type : "button", text:'<spring:message code="ribbon.excel" />',  isbig : false, img : "menu/excel.gif",  imgdis : "menu/excel_dis.gif",  disable : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchErpGrid();
			} else if (itemId == "excel_erpGrid"){
				$erp.exportGridToExcel({
					"grid" : erpGrid
					, "fileName" : "발주현황(품목별)"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			} 
		});
	}
	
	/****************************************************************************/
	/* erpGrid 초기화                                                           */
	/****************************************************************************/	
	function initErpGrid(){
		erpGridColumns = [
			/* 실제화면에 뿌려지는 부분 */
			  {id : "ORD_NO"           , label:["발주번호"          , "#text_filter"], type: "ro"  , width: "230", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "ORD_SEQ"          , label:["일련번호"          , "#text_filter"], type: "ron" , width: " 70", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "BCD_CD"           , label:["바고드"            , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}			
			, {id : "BCD_NM"           , label:["상품명"            , "#text_filter"], type: "ro"  , width: "250", sort : "str", align : "left",   isHidden : false, isEssential : true}			
			, {id : "DIMEN_NM"         , label:["규격"              , "#text_filter"], type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			
			, {id : "RETN_YN"          , label:["반품"              , "#text_filter"], type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : false, isEssential : true}			
			, {id : "ORD_QTY"          , label:["수량"              , "#text_filter"], type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}			
			, {id : "PUR_PRICE"        , label:["단가"              , "#text_filter"], type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}			
			, {id : "SUPR_AMT"         , label:["공급가액"          , "#text_filter"], type: "edn" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
			, {id : "VAT"              , label:["부가세"            , "#text_filter"], type: "edn" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
			, {id : "SUM_AMT"          , label:["합계금액"          , "#text_filter"], type: "edn" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
			, {id : "REMK"             , label:["적요"              , "#text_filter"], type: "ed"  , width: "80", sort : "str", align : "right",  isHidden : false, isEssential : false}
			, {id : "SUPR_CD"          , label:["협력사코드"        , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "SUPR_NM"          , label:["협력사명"          , "#text_filter"], type: "ro"  , width: "160", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "ORD_STATE"        , label:["발주상태"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "ORD_STATE_NM"     , label:["발주상태"          , "#text_filter"], type: "ro"  , width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}

			, {id : "ORGN_DIV_CD"      , label:["조직영역코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "ORGN_CD"          , label:["조직코드"          , "#text_filter"], type: "ro"  , width: "200", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "ORD_NO"           , label:["발주번호"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "center", isHidden : true , isEssential : true}
			, {id : "ORD_SEQ"          , label:["일련번호"          , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "center", isHidden : true , isEssential : true}
			, {id : "OUT_WARE_CD"      , label:["출고창고코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "IN_WARE_CD"       , label:["입고창고코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "IN_WARE_NM"       , label:["입고창고"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "PROJ_CD"          , label:["프로젝트코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "PROJ_NM"          , label:["프로젝트명"        , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "UNIT_CD"          , label:["단위"              , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "DIMEN_WGT"        , label:["중량"              , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}

			, {id : "ORD_TITLE"        , label:["제목"              , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "MEMO"             , label:["메모"              , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "RESN_CD"          , label:["반품사유코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
							
			, {id : "DELI_DATE"        , label:["납기일자"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
			, {id : "ORD_DATE"         , label:["발주일시"          , "#text_filter"], type: "ro", width: "130", sort : "str", align : "center", isHidden : true , isEssential : true}
			, {id : "ORD_TYPE"         , label:["발주유형"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "ORD_TYPE_NM"      , label:["발주유형"          , "#text_filter"], type: "ro", width: "80" , sort : "str", align : "center", isHidden : true , isEssential : true}
			, {id : "ORD_STATE"        , label:["발주상태"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "ORD_STATE_NM"     , label:["발주상태"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
			, {id : "RETN_YN"          , label:["반품여부"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
			, {id : "SEND_FAX_STATE"   , label:["FAX발송"           , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
			, {id : "SEND_EMAIL_STATE" , label:["Email발송"         , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
			, {id : "PRINT_STATE"      , label:["PRINT인쇄상태"     , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
			, {id : "RESP_USER"        , label:["담당자코드"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "EMP_NM"           , label:["담당자명"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
			, {id : "ORD_CUSTMR"       , label:["발행구분"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
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
	}

	/****************************************************************************/
	/* 바코드 상품 선택 팝업호출                                                */
	/****************************************************************************/	
	function openSearchMastBcodeGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var onRowSelect = function(id, ind) {
			document.getElementById("hidGOODS_NO").value  = this.cells(id, this.getColIndexById("GOODS_NO")).getValue();
			document.getElementById("hidBCD_CD").value    = this.cells(id, this.getColIndexById("BCD_CD")).getValue();
			document.getElementById("BCD_NM").value       = this.cells(id, this.getColIndexById("BCD_NM")).getValue();
			
			$erp.closePopup();
		}
		$erp.searchMastBcodeGridPopup(onRowSelect);
	}
		
	/****************************************************************************/
	/* 협력사명 선택 팝업호출                                                   */
	/****************************************************************************/	
	function openSearchCustmrGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "1";           // 협력사(매입처) :1,  고객사(매출처): 2
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
		var scrin_GOODS_NO        = document.getElementById("hidGOODS_NO").value;
		var scrin_BCD_CD          = document.getElementById("hidBCD_CD").value;
		
		var scrin_Surp_CD         = document.getElementById("hidSurp_CD").value;
		var scrin_searchdelStrDt  = document.getElementById("searchdelStrDt").value;
		var scrin_searchdelEndDt  = document.getElementById("searchdelEndDt").value;
		
		scrin_searchdelStrDt      = scrin_searchdelStrDt.replace (/-/g, "")
		scrin_searchdelEndDt      = scrin_searchdelEndDt.replace (/-/g, "")
		//alert(" scrin_searchdelStrDt===>=" + scrin_searchdelStrDt + " scrin_searchdelEndDt===>=" + scrin_searchdelEndDt);
		
		var scrin_RESP_USER_CD    = document.getElementById("txtRESP_USER").value;
		
		var scrin_InWare_CD       = cmbIN_WARE_CD.getSelectedValue();
		var scrn_ORGN_DIV_CD      = "";
		var scrn_ORGN_CD          = "";
		
		if ( LOGIN_ORGN_DIV_TYP == "C" ) {
			scrn_ORGN_DIV_CD     = LOGIN_EMP_NO;
			scrn_ORGN_CD         = LOGIN_ORGN_CD;
		}
		
		$.ajax({
			url : "/sis/order/orderCurrentSearch.do"
			,data : {
				  "PARAM_ORGN_DIV_CD"      : scrn_ORGN_DIV_CD
				, "PARAM_ORGN_CD"          : scrn_ORGN_CD
				, "PARAM_ORD_STR_YYYYMMDD" : scrin_searchordStrDt
				, "PARAM_ORD_END_YYYYMMDD" : scrin_searchordEndDt
				, "PARAM_GOODS_NO"         : scrin_GOODS_NO
				, "PARAM_BCD_CD"           : scrin_BCD_CD
				, "PARAM_DEL_STR_YYYYMMDD" : scrin_searchdelStrDt
				, "PARAM_DEL_END_YYYYMMDD" : scrin_searchdelEndDt
				, "PARAM_PROJ_CD"          : ""
				, "PARAM_IN_WARE_CD"       : scrin_InWare_CD
				, "PARAM_OUT_WARE_CD"      : ""
				, "PARAM_SUPR_CD"          : scrin_Surp_CD
				, "PARAM_RESP_USER"        : scrin_RESP_USER_CD
				, "PARAM_ORD_TYPE"         : "1"     /* 1: 발주, 2:주문 */
				, "LOGIN_CHANNEL"          : "S"     /* Login채널 S:영업관리, P:거래처포털 */
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
	/* COMBO박스처리 
	/***************************************************/
	function initDhtmlXCombo(){
		/* 입고창고 */
		if ( LOGIN_ORGN_DIV_TYP == "C") {
			cmbIN_WARE_CD = $erp.getDhtmlXComboCommonCode('cmbIN_WARE_CD',     'cmbIN_WARE_CD',  ["ORGN_CD","","","",LOGIN_ORGN_CD],   135,  "",  false, LOGIN_ORGN_CD);
			$erp.objReadonly("cmbIN_WARE_CD");  /* Combo박스 손을 못되게 한다 */
		}
		else /* LOGIN조직 유형이 직영점이 아니면  직영점 선택된 COMBO박스의 조직코드가 입고창고 */
		{
			cmbIN_WARE_CD = $erp.getDhtmlXComboCommonCode('cmbIN_WARE_CD',     'cmbIN_WARE_CD',  ["ORGN_CD","","","","","MK"],  135,  "모두조회",  false, cmbIN_WARE_CD);
			$erp.objNotReadonly("cmbIN_WARE_CD");
		}
		
		/* 발주진행상태 */
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
				<col width="240px">
				
				<col width="100px">	
				<col width="240px">
				
				<col width="100px">
				<col width="240px">
					
				<col width="150px">
				<col width="*">
			</colgroup>
			<tr>
				<th>발주기간</th>
				<td>
					<input type="text" id="searchordStrDt" name="searchordStrDt" class="input_common input_calendar"> ~
					<input type="text" id="searchordEndDt" name="searchordEndDt" class="input_common input_calendar">
				</td>
				
				<th>상품명</th>
				<td>
					<input type="hidden" id="hidGOODS_NO">
					<input type="hidden" id="hidBCD_CD">
					<input type="text" id="BCD_NM" name="BCD_NM" readonly="readonly" disabled="disabled"/>
					<input type="button" id="BCD_NM_Search" value="검 색" class="input_common_button" onclick="openSearchMastBcodeGridPopup();"/>
				</td>

				<th>협력사명</th>
				<td>
					<input type="hidden" id="hidSurp_CD">
					<input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Custmr_Search" value="검 색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/>
				</td>
			</tr>
			
			<tr>
				<th>납기일자</th>
				<td>
					<input type="text" id="searchdelStrDt" name="searchdelStrDt" class="input_common input_calendar"> ~
					<input type="text" id="searchdelEndDt" name="searchdelEndDt" class="input_common input_calendar">
				</td>
				
				<th>입고창고</th>
				<td>
					<div id="cmbIN_WARE_CD"></div>
				</td>
				
				<th>담당자명</th>
				<td>
					<input type="hidden" id="txtRESP_USER">
					<input type="text" id="RESP_USER_NAME" name="RESP_USER_NAME" readonly="readonly" disabled="disabled"/>
					<input type="button" id="resp_user_Search" value="검 색" class="input_common_button" onclick="openSearchComEmpNoGridPopup();"/>
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