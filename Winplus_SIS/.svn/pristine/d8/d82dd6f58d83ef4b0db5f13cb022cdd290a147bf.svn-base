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
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpMiddRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpMiddGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpMiddGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpMiddGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbPartnerIO : Object / 거래처구분(매입 or 매출) DhtmlXCombo  (CODE : PUR_SALE_TYPE )
		■ cmbPamentDay : Object / 마감일자(결제기준) DhtmlXCombo  (CODE : PAY_STD ) 		 
		■ cmbSourcing : Object / 마감일자(결제기준) DhtmlXCombo  (CODE : SUPR_GOODS_GRUP ) 		 
		■ cmbPartnerPart : Object / 공급사분류코드 DhtmlXCombo  (CODE : SUPR_GRUP_CD ) 		 
		■ cmbPartnerType : Object / 공급사유형  DhtmlXCombo  (CODE : SUPR_TYPE ) 		 
	--%>
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	
	var GLOVAL_CUSTMR_CD = "";
	
	var erpLayout;
	var erpToLayout;
	var erpRightLayout;
	
	var erpToptRibbon;
	var erpRightRibbon;

	var erpTopGrid
	var erpRightGrid;
	
	var erpTopGridColumns;
	var erpRightGridColumns;
	
	var erpTopGridDataProcessor;	
	var erpRightGridDataProcessor;	
	
	var cmbUSE_YN = "Y";                /* 사용여부       */
	var cmbPartnerIO;                   /* 거래처구분     */
    var cmbSourcing;                    /* 소싱그룹       */
	var cmbPartnerPart;                 /* 공급사분류코드 */
	var cmbPartnerType;                 /* 공급사유형     */
	var cmbCUSTMR_GRUP;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	
	$(document).ready(function(){	
		LUI.exclude_auth_cd = "ALL,1,2";
		
		initErpLayout();
		initErpTopLayout();
		initErpRightLayout();
		
		/* 리본및 그리드 객제생성 */
		initErpTopRibbon();
		initErpTopGrid();	

		initErpRightRibbon();
		initErpRightGrid();
		
		initDhtmlXCombo();   /* COMBO객체생성 */
		
		$erp.asyncObjAllOnCreated(function(){
			search_erpTopGrid();
		});
	});
	
	
	/***************************************************/
	/*  1. MAIN Layout(1C)
    /***************************************************/
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
							{id:"a", text: "전체협력사목록" , header: true, fix_size:[true, true]}
							, {id:"b", text: "등록계좌목록" , header: true}
						]
		});
		
		erpLayout.cells("a").attachObject("div_erp_00_Layout");
		erpLayout.cells("b").attachObject("div_erp_23_Layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpTopLayout.setSizes();
			erpTopGrid.setSizes();
			erpRightLayout.setSizes();
			erpRightGrid.setSizes();
		});

	}

	/***************************************************/
	/*  2. TopLayout(본사기준 : 매출 거래처목록)
    /***************************************************/
	function initErpTopLayout() {
		erpTopLayout = new dhtmlXLayoutObject({
			parent : "div_erp_00_Layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells : [
							{id: "a", text: "", header:false, fix_size:[true, true]}
							, {id: "b", text: "", header:false, fix_size:[true, true]}
							, {id: "c", text: "", header:false, fix_size:[true, true]}
						]
		});
		erpTopLayout.cells("a").attachObject("div_erp_top_search");
		erpTopLayout.cells("a").setHeight("40");
		erpTopLayout.cells("b").attachObject("div_erp_top_ribbon");
		erpTopLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpTopLayout.cells("c").attachObject("div_erp_top_grid");
	}	
	

	
	/***************************************************/
	/*  5. 제일우측 layout에 전체거래처를 출력한다
    /***************************************************/	
	function initErpRightLayout(){
		erpRightLayout = new dhtmlXLayoutObject({
			parent : "div_erp_23_Layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells : [
							  {id: "a", text: "", header:false, fix_size:[true, true]}
							, {id: "b", text: "", header:false, fix_size:[true, true]}
						]
		});
		erpRightLayout.cells("a").attachObject("div_erp_right_ribbon");
		erpRightLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightLayout.cells("b").attachObject("div_erp_right_grid");
	}	
	
	
	/*********************************************************/
	/* TO목록(거래처) 선택
	/*********************************************************/
	function initErpTopRibbon(){
		erpTopRibbon = new dhtmlXRibbon({
			parent : "div_erp_top_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						{id : "search_erpTopGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
				]}
			]
		});
		
		erpTopRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpTopGrid"){
				search_erpTopGrid();
			}
		});
	}
	
	/*********************************************************/
	/* 대상거래처( 거래처마스터중에서 전체공급사만 조회)
	/*********************************************************/
	function initErpTopGrid(){
		erpTopGridColumns = [
			{id : "NO"                 , label:["NO"                  , "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "custmr_cd"          , label:["거래처코드"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "custmr_nm"          , label:["거래처명"            , "#text_filter"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "custmr_ceonm"       , label:["대표자명"            , "#text_filter"], type: "ro", width: "130", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "cuser"              , label:["생성자"              , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "cdate"              , label:["생성일시"            , "#text_filter"], type: "ro", width: "160", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "muser"              , label:["수정자"            , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "mdate"              , label:["수정일시"            , "#text_filter"], type: "ro", width: "160", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "corp_no"            , label:["사업자번호"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : true}
			, {id : "taxbill_cd"         , label:["세무신고거래처"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : true}
			, {id : "corp_ori_no"        , label:["종사업장번호"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : true}
			, {id : "busi_cond"          , label:["업태"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : true}
			, {id : "busi_type"          , label:["업종"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : true}
			, {id : "resp_user_nm"       , label:["담당자명"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : true}
			, {id : "ord_resp_user"      , label:["구매담당자"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : true}
			, {id : "cent_resp_user"     , label:["센터담당자"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : true}
			, {id : "tel_no"             , label:["전화번호"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : true}
			, {id : "phon_no"            , label:["담당자 휴대폰"       , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : true}
		];
		
		erpTopGrid = new dhtmlXGridObject({
			parent: "div_erp_top_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpTopGridColumns
		});
		erpTopGrid.enableDistributedParsing(true, 100, 50);
		erpTopGridDataProcessor = $erp.initGrid(erpTopGrid);
		$erp.initGridDataColumns(erpTopGrid);
		
		erpTopGrid.attachEvent("onRowDblClicked", function(rId){
			custmr_cd = erpTopGrid.cells(rId, erpTopGrid.getColIndexById("custmr_cd")).getValue();
			search_erpRightGrid(custmr_cd);
		});
	}	
	
	/*********************************************************/
	/* 등록된 주문가능 상품목록 조회
	/*********************************************************/
	function initErpRightRibbon(){

		erpRightRibbon = new dhtmlXRibbon({
			parent : "div_erp_right_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpRightGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					,{id : "add_erpRightGrid"   , type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					,{id : "delete_erpRightGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					,{id : "save_erpRightGrid"  , type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}
			]
		});
		
        erpRightRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpRightGrid"){
		    	search_erpRightGrid();
		    } else if (itemId == "add_erpRightGrid"){
		    	add_erpRightGrid();
		    } else if (itemId == "delete_erpRightGrid"){
		    	delete_erpRightGrid();
		    } else if (itemId == "save_erpRightGrid"){
		    	save_erpRightGrid();
			} 
		});
		
	}
	
	/*********************************************************/
	/* 매장별 등록된 납품업체(공급사) 조회
	/*********************************************************/
	function initErpRightGrid(){
		erpRightGridColumns = [
			  {id : "NO"           , label:["NO"               , "#rspan"],       type: "cntr", width: "30",  sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK"        , label:["#master_checkbox" , "#rspan"],       type: "ch",   width: "40",  sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "SEQ"          , label:["일련번호"         , "#text_filter"], type: "ro",   width: "80",  sort : "str", align : "left",   isHidden : true,  isEssential : false}
			, {id : "CUSTMR_CD"    , label:["거래처코드"       , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : true,  isEssential : true}
			, {id : "BANK_CD"      , label:["은행명"         , "#text_filter"], type: "combo",   width: "130", sort : "str", align : "left",   isHidden : false, isEssential : true, commonCode : "BANK_CD"}
			, {id : "ACNT_NO"      , label:["계좌번호"         , "#text_filter"], type: "ed",   width: "175", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "ACTN_NM"      , label:["예금주"           , "#text_filter"], type: "ed",   width: "130", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "USE_YN"       , label:["사용여부"         , "#select_filter"], type: "combo",   width: "70",  sort : "str", align : "left", isHidden : false, isEssential : true, commonCode : ["USE_CD","YN"]}
			, {id : "CUSER"        , label:["생성자"         , "#text_filter"], type: "ro",   width: "110", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "CDATE"        , label:["생성일시"         , "#text_filter"], type: "ro",   width: "150", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MUSER"        , label:["수정자"         , "#text_filter"], type: "ro",   width: "110", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MDATE"        , label:["수정일시"         , "#text_filter"], type: "ro",   width: "150", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "DEPO_TYPE"    , label:["입급유형"         , "#text_filter"], type: "ed",   width: "100", sort : "str", align : "left",   isHidden : true, isEssential : false}
			, {id : "REQ_DATE"     , label:["승인요청일시"     , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : true, isEssential : false}
			, {id : "REQ_EMP_NO"   , label:["승인요청사원"     , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "APPR_DATE"    , label:["승인일시"         , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "APPR_EMP_NO"  , label:["승인사원"         , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "APPR_STATE"   , label:["승인여부"         , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "REMK"         , label:["비고"             , "#text_filter"], type: "ed",   width: "300", sort : "str", align : "center", isHidden : true, isEssential : true}
			
		];
		
		erpRightGrid = new dhtmlXGridObject({
			parent     : "div_erp_right_grid"
			, skin       : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns    : erpRightGridColumns
		});		
		erpRightGrid.enableDistributedParsing(true, 100, 50);
		erpRightGridDataProcessor = $erp.initGrid(erpRightGrid);
		$erp.initGridDataColumns(erpRightGrid);
		
		erpRightGrid.setEditable(true);
		
	}
	
	/*********************************************************/
	/* 대상거래처 조회 유효성 검사
	/*********************************************************/
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
	
	/*********************************************************/
	/* 대상거래처 조회Function
	/*********************************************************/
	function search_erpTopGrid(){
		console.log(cmbUSE_YN.getSelectedValue());
		erpTopLayout.progressOn();
		var params = {
			"SEARCH_VAL" : document.getElementById("txtSCRIN_CD").value
			, "cmbORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
			, "cmbORGN_CD"     : cmbORGN_CD.getSelectedValue()
			, "cmbPartnerIO"   : "1"
			, "cmbPamentDay"   : cmbPamentDay.getSelectedValue()
			, "cmbCUSTMR_GRUP" : cmbCUSTMR_GRUP.getSelectedValue()
			, "cmbBANK_YN"        : cmbUSE_YN.getSelectedValue()
		}
		
		//$erp.dataSerialize("aaa");
		//,data : { "aaa".dataSerialize}
		
		$.ajax({
			url : "/sis/basic/custmrSearchR1.do"
			,data : params
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpTopLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpTopGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpTopGrid, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpTopGrid.parse(gridDataList, 'js');	
						// 조회후 data가 존재하면 첫번째Row에 cursor를 위치시킨다.
						erpTopGrid.selectRowById(1);   
						//search_erpRightGrid();
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpTopGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpTopLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	/*********************************************************/
	/*  등록된 주문가능상품 조회Function
	/*********************************************************/
	function add_erpRightGrid(){	
		var topRowid     = erpTopGrid.getSelectedRowId();
		var uid          = erpRightGrid.uid();
		GLOVAL_CUSTMR_CD = erpTopGrid.cells(topRowid, erpTopGrid.getColIndexById("custmr_cd" )).getValue();	

		
		erpRightGrid.addRow(uid);
		erpRightGrid.selectRow(erpRightGrid.getRowIndex(uid));
		var count = erpRightGrid.getRowsNum()
		/* SEQ Key값을 추가한다 */
		erpRightGrid.cells(uid, erpRightGrid.getColIndexById("SEQ")).setValue(count);
		erpRightGrid.cells(uid, erpRightGrid.getColIndexById("CUSTMR_CD")).setValue(GLOVAL_CUSTMR_CD);
		erpRightGrid.cells(uid, erpRightGrid.getColIndexById("USE_YN")).setValue("Y");
		
		$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
	}
	
	/*********************************************************/
	/*  등록된 주문가능상품 조회Function
	/*********************************************************/
	function search_erpRightGrid(custmr_cd){
		erpRightLayout.progressOn();
		
		$.ajax({
			url : "/sis/basic/getSearchCustomerAcntApprList.do"
			,data : {
				"PARAM_CUSTMR_CD" : custmr_cd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpRightGrid);
					var gridDataList2 = data.gridDataList;
					if($erp.isEmpty(gridDataList2)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpRightGrid, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpRightGrid.parse(gridDataList2, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpRightLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
		
	/*********************************************************/
	/* 대상거래처 납품업체 삭제처리(그리드상에서만 삭제)
	/*********************************************************/
	function delete_erpRightGrid(){
		var gridRowCount = erpRightGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId   = erpRightGrid.getRowId(i);
			var check = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("CHECK")).getValue();
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
			erpRightGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
	}
	
	/*********************************************************/
	/* 매출처주문가능 상품 C,U,D
	/*********************************************************/
	function save_erpRightGrid(){
		
		if(erpRightGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpRightGrid);
		if(validResultMap.isError){
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode"  : validResultMap.errCode
				, "alertType"  : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		// 유효성체크는 필요있나??
		// if(!isSaveErpRightGridValidate()){ return false; }
		
		erpRightLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpRightGrid);		

		$.ajax({
			 url      : "/sis/basic/CustomerAcntManagementCUD.do"
			,data     :  paramData
			,method   : "POST"
			,dataType : "JSON"
			,success  : function(data){
				erpRightLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.alertSuccessMesage(onAfterSaveErpRightGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpRightLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});		

	}
	
	/*********************************************************/
	/* 대상거래처 납품업체 등록후 자동재조회
	/*********************************************************/
	function onAfterSaveErpRightGrid(){
		var rId = erpTopGrid.getSelectedRowId();
		custmr_cd = erpTopGrid.cells(rId, erpTopGrid.getColIndexById("custmr_cd")).getValue();
		search_erpRightGrid(custmr_cd);
	}
	
	/*********************************************************/
	/* dhtmlXCombo 초기화 Function
	/*********************************************************/
	function initDhtmlXCombo(){
		/* 사용여부 */
		cmbUSE_YN = $erp.getDhtmlXComboCommonCode('cmbUSE_YN', 'USE_CD',['USE_CD', 'YN'], 100, "모두조회", false, "Y");
		/* 마감일자(결제기준) */
		cmbPamentDay   = $erp.getDhtmlXComboCommonCode('cmbPamentDay',   'cmbPamentDay',    'PAY_STD',         100, "모두조회", false, cmbPamentDay);
		/* 소싱그룹 */
		cmbSourcing    = $erp.getDhtmlXComboCommonCode('cmbSourcing',    'cmbSourcing',     'SUPR_GOODS_GRUP', 100, "모두조회", false, cmbSourcing);
		
		/* 공급사분류코드 */
		cmbPartnerPart = $erp.getDhtmlXComboCommonCode('cmbPartnerPart', 'cmbPartnerPart',  'SUPR_GRUP_CD',    100, "모두조회", false, cmbPartnerPart);
        /* 공급사유형 */
		cmbPartnerType = $erp.getDhtmlXComboCommonCode('cmbPartnerType', 'cmbPartnerType',  'SUPR_TYPE',       100, "모두조회", false, cmbPartnerType);
	
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 170, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 120, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			}); 
		});
		
		cmbCUSTMR_GRUP = $erp.getDhtmlXComboCommonCode("cmbCUSTMR_GRUP", "cmbCUSTMR_GRUP", ["CUSTMR_GRUP","","P"], 100, "모두조회", false);
	}
	
</script>
</head>
<body>				
	 <div id="div_erp_00_Layout" class="samyang_div" style="display:none;">
		<div id="div_erp_top_search" class="samyang_div" style="display:none;">
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
					<th>계좌여부</th>
					<td><div id="cmbUSE_YN"></div></td>
					<th style="display:none;">소싱그룹</th>
					<td style="display:none;"><div id="cmbSourcing"></div></td>
					<th style="display:none;">공급사분류</th>
					<td style="display:none;"><div id="cmbPartnerPart"></div></td>
					<th style="display:none;">공급사유형</th>
					<td style="display:none;"><div id="cmbPartnerType"></div></td>
				</tr>
			</table>
		</div>
		<div id="div_erp_top_ribbon" class="samyang_div"   style="display:none;"></div>
		<div id="div_erp_top_grid"   class="div_grid_full_size"   style="display:none;"></div>
	 </div>


	 <div id="div_erp_23_Layout" class="samyang_div" style="display:none;">
		<div id="div_erp_right_ribbon" class="samyang_div"   style="display:none;"></div>
		<div id="div_erp_right_grid"   class="div_grid_full_size"   style="display:none;"></div>
	 </div>
	 
</body>
</html>