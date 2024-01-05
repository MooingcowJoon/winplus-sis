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
		■ cmbCUSTMR_GRUP : Object / 마감일자(결제기준) DhtmlXCombo  (CODE : SUPR_GOODS_GRUP ) 		 
		■ cmbPartnerPart : Object / 공급사분류코드 DhtmlXCombo  (CODE : SUPR_GRUP_CD ) 		 
		■ cmbPartnerType : Object / 공급사유형  DhtmlXCombo  (CODE : SUPR_TYPE ) 		 
	--%>
	var erpLayout;
	var erpRibbon;	
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;	
	var cmbPartnerIO;    /* 거래처구분 */
	var cmbPamentDay;    /* 마감일자(결제기준) */
	var cmbCUSTMR_GRUP;  /* 거래처유형           */
	var cmbPartnerPart;  /* 공급사분류코드     */
// 	var cmbPartnerType;  /* 공급사유형         */
	var erpGridSelectedCustmr_cd;   /* 그리드 rowSelected */
	var cmbYNCD;
	var cmbORGN_CD;
	var cmbORGN_DIV_CD;
	
	var isValidPage;	//페이지가 정상적으로 로드되었는지
	var pageType;		//페이지타입(협력사, 고객사)
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	
	
	$(document).ready(function(){		
		if("${menuDto.menu_cd}" == "00497"){
			pageType = "협력사";
			isValidPage = true;
			LUI.exclude_auth_cd = "ALL,1,2";
		}else if("${menuDto.menu_cd}" == "00671"){
			pageType = "고객사";
			isValidPage = true;
			LUI.exclude_auth_cd = "ALL,1,5,6";
			LUI.exclude_orgn_type = "MK";
		}else{
			isValidPage = false;
		}
		
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		initErpGrid();
		if(!isValidPage){
			$erp.alertMessage({
				"alertMessage" : "메뉴명이 변경되어 페이지가 제대로 작동하지 않을 수 있습니다. 소스코드를 확인해주세요.",
				"alertCode" : null,
				"alertType" : "error",
				"isAjax" : false
			});
		}
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "${menuDto.menu_nm}", header:true, height:67}
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
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
						, {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
						//, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : false}
						//, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, unused : true}		
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "add_erpGrid"){
		    	addErpGrid();
		    } else if (itemId == "delete_erpGrid"){
		    	deleteErpGrid();
		    } else if (itemId == "excel_erpGrid"){
		    	$erp.exportGridToExcel({
		    		"grid" : erpGrid
					, "fileName" : pageType + "_관리"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
		    } else if (itemId == "print_erpGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			  {id : "NO"                 , label:["NO"                            , "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK"              , label:["#master_checkbox"              , "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "custmr_cd"          , label:["거래처코드"                    , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "custmr_nm"          , label:["거래처명"                      , "#text_filter"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "corp_no"            , label:["사업자번호"                    , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "custmr_ceonm"       , label:["대표자명"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "FILE_YN"            , label:["계약서파일등록"                    , "#text_filter"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true, isDisabled : true}
			, {id : "taxbill_cd"         , label:["세무신고거래처"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "corp_ori_no"        , label:["종사업장번호"                  , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "busi_cond"          , label:["업태"                          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "busi_type"          , label:["업종"                          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ceo_tel"            , label:["대표자휴대전화"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "resp_user_nm"       , label:["담당자명"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ord_resp_user"      , label:["구매담당자"                    , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "cent_resp_user"     , label:["센터담당자"                    , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "tel_no"             , label:["전화번호"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "fax_no"             , label:["팩스번호"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "phon_no"            , label:["담당자 휴대폰"                 , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "email"              , label:["이메일"                        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "siteurl"            , label:["홈페이지"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "corp_zip_no"        , label:["우편번호(거래처사업소재지)"    , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "corp_addr"          , label:["상세주소(거래처사업소재지)"    , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ord_zip_no"         , label:["우편번호(거래처우편물주소(DM))", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ord_addr"           , label:["상세주소(거래처우편물주소(DM))", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "deli_respuser"      , label:["배송담당자"                    , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "pay_type"           , label:["수금/지급구분"                 , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "pay_schd_1"         , label:["수금/지급예정일 값1"           , "#text_filter"], type: "ro", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "pay_schd_2"         , label:["수금/지급예정일 값2"           , "#text_filter"], type: "ro", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "pay_std_NM"         , label:["정산지급"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "pay_date_type_NM"   , label:["정산지급유형"                   , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "LOAN_AMT"        	 , label:["여신한도"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "CASH_AMT"           , label:["현금보증"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "GRNT_AMT"           , label:["보증증권"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "CREDIT_AMT"         , label:["신용보증"                          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "ord_sale_type"      , label:["거래유형(영업)구분"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ord_sale_fee"       , label:["거래유형(영업)"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ord_pur_type"       , label:["거래유형(구매)구분"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ord_pur_fee"        , label:["거래유형(구매)"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "keywd"              , label:["검색창내용"                    , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "memo"               , label:["메모"                          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "exc_vat"            , label:["부가세제외"                    , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "pur_sale_type_NM"   , label:["거래처구분"                    , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "pur_type"           , label:["매입유형"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "supr_grup_cd_NM"    , label:["공급사분류"                    , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "supr_type_NM"       , label:["공급사유형"                    , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "custmr_grup_NM" 	 , label:["거래처유형"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "event_yn"           , label:["행사차단"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "goods_fee"          , label:["수수료율(신규상품)"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "mk_incen_rate"      , label:["매장장려금요율"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "cent_incen_rate"    , label:["센터장려금요율"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "clse_time"          , label:["주문마감시간"                  , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "deli_yoil"          , label:["배송 요일"                     , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "deli_date"          , label:["배송 특정일"                   , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "min_pur_amt"        , label:["최저발주금액"                  , "#text_filter"], type: "ro", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "haccp_yn"           , label:["HACCP인증여부"                 , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "supr_state"         , label:["휴/폐업상태"                   , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "clse_busi_date"     , label:["휴/폐업일자"                   , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "supr_id"            , label:["공급사 ID"                     , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "supr_pwd"           , label:["공급사 패스워드"               , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "sales_id"           , label:["매출처 ID"                     , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "sales_pwd"          , label:["매출처 패스워드"               , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "cprogrm"            , label:["생성프로그램"                  , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "cuser"              , label:["생성자"                        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "cdate"              , label:["생성일시"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "mprogrm"            , label:["수정프로그램"                  , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "mdate"              , label:["수정일시"                      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "muser"              , label:["수정자"                        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}			
			, {id : "file_grup_no"       , label:["파일그룹번호"               , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : true}
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
			openCustomerinputPopup(this.cells(rowId, this.getColIndexById("custmr_cd")).getValue(), pageType);
		});
	}

	function openCustomerinputPopup(custmr_cd, pur_sale_type){
		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window("openCustomerinputPopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}
		}
		
		var onConfirm = function(){
		}
		
		var url = "/common/popup/openCustomerinputPopup.sis";
		var params = {"customer_cd" : custmr_cd, "pur_sale_type" : pur_sale_type}
		var option = {
				"win_id" : "openCustomerinputPopup",
				"width"  : 1330,
				"height" : 680
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
    /* 그리드 row더블클릭시 골처조회한다  Function                              */
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
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		var scrin_cd = document.getElementById("txtSCRIN_CD").value;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isLengthOver(scrin_cd, 50)){
			isValidated = false;
			alertMessage = "error.common.system.menu.scrin_nm.length50Over";
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
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		if(!isSearchValidate()){
			return;
		}
		
		erpLayout.progressOn();
		
		console.log(cmbCUSTMR_GRUP.getSelectedValue());
		if(pageType == "협력사"){
			var params = {
				"SEARCH_VAL"       : document.getElementById("txtSCRIN_CD").value
				, "cmbORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
				, "cmbORGN_CD"     : cmbORGN_CD.getSelectedValue()
				, "cmbPartnerIO"   : cmbPartnerIO.getSelectedValue()
				, "cmbPamentDay"   : cmbPamentDay.getSelectedValue()
				, "cmbCUSTMR_GRUP" : cmbCUSTMR_GRUP.getSelectedValue()
				, "cmbPartnerPart" : cmbPartnerPart.getSelectedValue()
// 				, "cmbPartnerType" : cmbPartnerType.getSelectedValue()
				, "cmbYNCD"        : cmbYNCD.getSelectedValue()
				, "pageType" : "DP" 
			};
		}else if(pageType == "고객사"){
			var params = {
				"SEARCH_VAL"       : document.getElementById("txtSCRIN_CD").value
				, "cmbORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
				, "cmbORGN_CD"     : cmbORGN_CD.getSelectedValue()
				, "cmbPartnerIO"   : cmbPartnerIO.getSelectedValue()
				, "cmbPamentDay"   : cmbPamentDay.getSelectedValue()
				, "cmbCUSTMR_GRUP" : cmbCUSTMR_GRUP.getSelectedValue()
				, "cmbYNCD"        : cmbYNCD.getSelectedValue()
				, "pageType" : "DS"
			};
		}
		
		//$erp.dataSerialize("aaa");
		//,data : { "aaa".dataSerialize}
		
		$.ajax({
			url : "/sis/basic/custmrSearchR1.do"
			,data : params
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
	/*  거래처 등록                          */
	/*****************************************/
	function addErpGrid(){
		openCustomerinputPopup(null, pageType);
	}
	
	<%-- erpGrid 삭제 Function --%>
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
	
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%--
	**************************************************
	* 기타 영역
	**************************************************
	--%>	
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		/* 매입-매출처구분 */
		cmbPartnerIO   = $erp.getDhtmlXComboCommonCode('cmbPartnerIO', 'cmbPartnerIO', 'PUR_SALE_TYPE',   100, null, false, pageType == "협력사"? "1" : "2");
		$erp.objReadonly("cmbPartnerIO");
		
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 170, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 120, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			}); 
		});
		
		/* 마감일자(결제기준) */
		cmbPamentDay = $erp.getDhtmlXComboCommonCode('cmbPamentDay', 'cmbPamentDay', 'PAY_STD', 100, "모두조회", false);
		/* 소싱그룹 */
		if(pageType == "협력사"){
			/* 공급사분류코드 */
			cmbPartnerPart = $erp.getDhtmlXComboCommonCode('cmbPartnerPart', 'cmbPartnerPart', 'SUPR_GRUP_CD', 100, "모두조회", false);
			/* 공급사유형 */
//			cmbPartnerType = $erp.getDhtmlXComboCommonCode('cmbPartnerType', 'cmbPartnerType', 'SUPR_TYPE', 100, "모두조회", false);
			cmbCUSTMR_GRUP = $erp.getDhtmlXComboCommonCode("cmbCUSTMR_GRUP", "cmbCUSTMR_GRUP", ["CUSTMR_GRUP","","P"], 100, "모두조회", false, null, null, "Y");
		}else{
			cmbCUSTMR_GRUP = $erp.getDhtmlXComboCommonCode("cmbCUSTMR_GRUP", "cmbCUSTMR_GRUP", ["CUSTMR_GRUP","","S"], 100, "모두조회", false);
		}
		/* 사용여부 */
		cmbYNCD = $erp.getDhtmlXComboCommonCode('cmbYNCD', 'cmbYNCD', ['YN_CD','YN'], 100, "모두조회", false, 'Y');
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>				
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search" id="aaa">
			<colgroup>
				<col width="80px">
				<col width="120px">
				
				<col width="60px">
				<col width="180px">
				
				<col width="60px">
				<col width="130px">
				
				<col width="60px">
				<col width="160px">
				
				<col width="60px">
				<col width="110px">
				
				<col width="80px">
				<col width="120px">
				
				<col width="80px">
				<col width="120px">
				
				<col width="80px">
				<col width="110px">
				
				<col width="80px">
				<col width="*">
			</colgroup>
			<tr>
				<th style="display:none">거래구분</th>
				<td style="display:none"><div id="cmbPartnerIO"></div></td>
				<th>거래처유형</th>
				<td><div id="cmbCUSTMR_GRUP"></div></td>
				<th>법인구분</th>
				<td><div id="cmbORGN_DIV_CD"></div></td>
				<th>조직명</th>
				<td><div id="cmbORGN_CD"></div></td>
				<th>검색어</th>
				<td><input type="text" id="txtSCRIN_CD" name="SCRIN_CD" class="input_common" maxlength="505" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid);"></td>
				<th>마감일자</th>
				<td><div id="cmbPamentDay"></div></td>
				<c:choose>
					<c:when test="${menuDto.menu_cd == '00497'}">
						<th style="display:none">협력사분류</th>
						<td style="display:none"><div id="cmbPartnerPart"></div></td>
<!-- 						<th>협력사유형</th> -->
<!-- 						<td><div id="cmbPartnerType"></div></td> -->
						<th>사용여부</th>
						<td><div id="cmbYNCD"></div></td>
					</c:when>
					<c:otherwise>
						<th>사용여부</th>
						<td colspan="5"><div id="cmbYNCD"></div></td>
					</c:otherwise>
				</c:choose>
				
				
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid"   class="div_grid_full_size"   style="display:none"></div>
</body>
</html>