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
	var GLOVAL_ORGN_DIV_CD = "";   
	var GLOVAL_ORGN_CD     = "";
	var GLOVAL_CUSTMR_CD   = "";
	
	var erpLeftTree;
	var currentErpLeftTreeId;
	
	var erpLayout;
	var erpToLayout;
	var erpMiddLayout;
	var erpRightLayout;
	
	var erpToptRibbon;	
	var erpMiddRibbon;	
	var erpRightRibbon;	

	var erpTopGrid;
	var erpMiddGrid;
	var erpRightGrid;
	
	var erpTopGridColumns;
	var erpMiddGridColumns;
	var erpRightGridColumns;
	
	var erpTopGridDataProcessor;	
	var erpMiddGridDataProcessor;	
	var erpRightGridDataProcessor;	
	
	var cmbUSE_YN = "Y";                /* 사용여부       */
	var cmbPartnerIO;                   /* 거래처구분     */
    var cmbSourcing;                    /* 소싱그룹       */
	var cmbPartnerPart;                 /* 공급사분류코드 */
	var cmbPartnerType;                 /* 공급사유형     */
	
	$(document).ready(function(){	

		initErpLayout();
		initErpTopLayout();
		initErpLeftLayout();
		initMiddLayout();
		initErpLeftTree();
		initErpRightLayout();
		
		/* 리본및 그리드 객제생성 */
		initErpTopRibbon();
		initErpTopGrid();	
		
		initErpLeftRibbon();
		
		initErpMiddGrid();
		initErpMiddRibbon();		

		initErpRightRibbon();
		initErpRightGrid();
		
		//initDhtmlXCombo();   /* COMBO객체생성 */
		getLoginOrgInfo();
		
	});
	
	
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
			        GLOVAL_ORGN_DIV_CD   =   data.gridDataList.ORGN_DIV_CD;
					GLOVAL_ORGN_CD       =   data.gridDataList.DEPT_CD;
					
					console.log("GLOVAL_ORGN_DIV_CD=>"   + GLOVAL_ORGN_DIV_CD);          
					console.log("GLOVAL_ORGN_CD=>"       + GLOVAL_ORGN_CD);          
					initDhtmlXCombo();
					
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}	
	
	/***************************************************/
	/*  1. MAIN Layout(1C)
    /***************************************************/
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent    : document.body
			, skin    : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "4T"
			, cells   : [
							  {id:"a", text: "전체매출거래처"  , header: true, height:325}
							, {id:"b", text: "상품분류목록"    , header: true, width:220}
							, {id:"c", text: "전체상품목록"    , header: true, width:700}
							, {id:"d", text: "주문가능상품목록", header: true}
						]
		});
		
		erpLayout.cells("a").attachObject("div_erp_00_Layout");
		erpLayout.cells("b").attachObject("div_erp_21_Layout");
		erpLayout.cells("c").attachObject("div_erp_22_Layout");
		erpLayout.cells("d").attachObject("div_erp_23_Layout");
		
		erpLayout.setSeparatorSize(1,0);
		erpLayout.setSeparatorSize(1,1);

	}

	/***************************************************/
	/*  2. TopLayout(본사기준 : 매출 거래처목록)
    /***************************************************/
	function initErpTopLayout() {
		
		erpTopLayout = new dhtmlXLayoutObject({
			parent   : "div_erp_00_Layout"
			, skin   : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells  : [
							  {id: "a", text: "", header:false }
							, {id: "b", text: "", header:false, fix_size:[false, true]}
							, {id: "c", text: "", header:false}
						]
		});
		
		erpTopLayout.cells("a").attachObject("div_erp_top_search");
		erpTopLayout.cells("a").setHeight("40");
		erpTopLayout.cells("b").attachObject("div_erp_top_ribbon");
		erpTopLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpTopLayout.cells("c").attachObject("div_erp_top_grid");
		erpTopLayout.setSeparatorSize(1, 0);

	}	
	
	/************************************************************/
	/*  3. 제일좌측 layout에 상품대중소 그룹을 tree로 출력한다
    /***********************************************************/	
	function initErpLeftLayout(){
		
		erpLeftLayout = new dhtmlXLayoutObject({
			parent: "div_erp_21_Layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				 {id: "a", text: "검색어영역", header:false, fix_size : [false, true]}
				,{id: "b", text: "리본영역"  , header:false, fix_size : [false, true]}
				,{id: "c", text: "트리영역"  , header:false, fix_size : [false, true]}
			]
		});
		
		erpLeftLayout.cells("a").attachObject("div_erp_left_search");
		erpLeftLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftLayout.cells("b").attachObject("div_erp_left_ribbon");
		erpLeftLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftLayout.cells("c").attachObject("div_erp_left_tree");
		
	}	

	/************************************************************/
	/*  3-1. 제일좌측 상품대중소 그룹을 tree구성을한다
    /***********************************************************/	
	function initErpLeftTree(){
		erpLeftTree = new dhtmlXTreeObject({
			parent : "div_erp_left_tree"
			, skin : ERP_TREE_CURRENT_SKINS			
			, image_path : ERP_TREE_CURRENT_IMAGE_PATH
		});
		
		erpLeftTree.attachEvent("onClick", function(id){
			
			if(!$erp.isEmpty(id)){
				<%-- 자식이 없는 경우(소분류)만 동작함 --%>
				if(!erpLeftTree.hasChildren(id)){
					currentErpLeftTreeId = id;
					searchErpRightContents();  
				}
			}
		});
		
		//searchErpLeftTree();
	}
	
	
	/************************************************************/
	/*  3-2. 제일좌측 상품대중소 그룹을 tree Cntroller호출
    /***********************************************************/	
	function searchErpLeftTree(){
		erpLeftLayout.progressOn();
		
		$.ajax({
			 url      : "/common/popup/getGoodsCategoryTreeList.do"
			,data     : { "KEY_WORD" : $("#txtKEY_WORD").val() }
			,method   : "POST"
			,dataType : "JSON"
			,success  : function(data){
				erpLeftLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					var categoryList = data.categoryList;
					var categoryTreeMap = data.categoryTreeMap;
					var categoryTreeDataList = categoryTreeMap.item;
					if($erp.isEmpty(categoryTreeDataList) || $erp.isEmpty(categoryList)){
						$erp.alertMessage({
							"alertMessage" : "info.common.noDataSearch"
							 , "alertCode" : null
							 , "alertType" : "info"
						});
					} else {
						erpLeftTree.deleteChildItems(0);
						erpLeftTree.parse(categoryTreeMap, 'json');
						//미사용 분류 투명도 설정
						for(var i=0; i<categoryList.length; i++){
							if(categoryList[i].GRUP_STATE == "N"){
								erpLeftTree.setItemStyle(categoryList[i].GRUP_CD,"opacity:0.3;");
							}
						}
						currentErpLeftTreeId = null;
						erpLeftTree.openAllItems("0");
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}	

	/*****************************************************************/
	/*  3-2-1. 상품대중소 trees출력후 click event시 조회 유효성 검증
    /****************************************************************/	
	function isSearchErpRightContentsValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(currentErpLeftTreeId)){
			isValidated = false;
			alertMessage = "error.common.noSelectedCategory";
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
	

	/*****************************************************************/
	/*  3-2-1. 상품대중소 tree출력후 onclick event시 중앙그리드 출력
    /****************************************************************/	
	function searchErpRightContents(){

		if(!isSearchErpRightContentsValidate()) { return false; }
		erpMiddLayout.progressOn();
		
		$.ajax({
			 url      : "/sis/standardInfo/goods/getGoodsCategory.do"
			,data     : {  "GRUP_CD" : currentErpLeftTreeId }
			,method   : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpMiddLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					var dataMap = data.dataMap;
					if($erp.isEmpty(dataMap)){
						$erp.alertMessage({
							"alertMessage" : "grid.noSearchData"
							, "alertCode" : ""
							, "alertType" : "info"
						});
					} else {
						var tbErpRightData = document.getElementById("tb_erp_right_data");
						$erp.clearInputInElement(tbErpRightData);
						$erp.bindTextValue(dataMap, tbErpRightData);
						
						document.getElementById("hidGRUP_TOP_CD").value = "";
						document.getElementById("hidGRUP_MID_CD").value = "";
						document.getElementById("hidGRUP_BOT_CD").value = "";
						document.getElementById("hidGRUP_TOP_CD").value = dataMap.GRUP_TOP_CD;
						document.getElementById("hidGRUP_MID_CD").value = dataMap.GRUP_MID_CD;
						document.getElementById("hidGRUP_BOT_CD").value = dataMap.GRUP_BOT_CD;
						
						/*  onclickevent시 중앙그리드 출력 */
						search_erpMiddGrid();
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}

	
	/*************************************************************/
	/*  4. 중앙layout  대중소 그룹에 선택된 전체상품을 조회한다
    /************************************************************/	
	function initMiddLayout(){
		
		erpMiddLayout = new dhtmlXLayoutObject({
			parent   : "div_erp_22_Layout"
			, skin   : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells  : [
							  {id: "a", text: "11111", header:false, height:69}
							, {id: "b", text: "22222", header:false, fix_size:[true, true]}
							, {id: "c", text: "33333", header:false}
						]		
		});
		
		erpMiddLayout.cells("a").attachObject("div_erp_midd_search");
		erpMiddLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpMiddLayout.cells("b").attachObject("div_erp_midd_ribbon");
		erpMiddLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpMiddLayout.cells("c").attachObject("div_erp_midd_grid");
		erpMiddLayout.setSeparatorSize(1, 0);
		$erp.setEventResizeDhtmlXLayout(erpMiddLayout, function(names){
			erpMiddGrid.setSizes();
		});		
		
	}

	/***************************************************/
	/*  5. 제일우측 layout에 전체거래처를 출력한다
    /***************************************************/	
	function initErpRightLayout(){
		     
		erpRightLayout = new dhtmlXLayoutObject({
			parent   : "div_erp_23_Layout"
			, skin   : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells  : [
							  {id: "a", text: "", header:false}
							, {id: "b", text: "", header:false, fix_size:[true, true]}
							, {id: "c", text: "", header:false}
						]		
		});
		
		erpRightLayout.cells("a").attachObject("div_erp_right_search");
		//erpRightLayout.cells("a").setHeight("40");
		erpRightLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightLayout.cells("b").attachObject("div_erp_right_ribbon");
		erpRightLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightLayout.cells("c").attachObject("div_erp_right_grid");
		erpRightLayout.setSeparatorSize(1, 0);

		$erp.setEventResizeDhtmlXLayout(erpRightLayout, function(names){
			erpRightGrid.setSizes();
		});		
		
	}	
	
	
	/*********************************************************/
	/* 전체상품 목록선택
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
			, {id : "custmr_cd"          , label:["거래처코드"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "custmr_nm"          , label:["거래처명"            , "#text_filter"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "custmr_ceonm"       , label:["대표자명"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "corp_no"            , label:["사업자번호"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "taxbill_cd"         , label:["세무신고거래처"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "corp_ori_no"        , label:["종사업장번호"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "busi_cond"          , label:["업태"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "busi_type"          , label:["업종"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "resp_user_nm"       , label:["담당자명"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ord_resp_user"      , label:["구매담당자"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "cent_resp_user"     , label:["센터담당자"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "tel_no"             , label:["전화번호"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "phon_no"            , label:["담당자 휴대폰"       , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "cuser"              , label:["생성자"              , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "cdate"              , label:["생성일시"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
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
	}	
	
	
	/*********************************************************/
	/* 상품Tree Ribbon
	/*********************************************************/
	function initErpLeftRibbon(){
		erpLeftRibbon = new dhtmlXRibbon({
			parent : "div_erp_left_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					 {id : "search_erpLeftTree", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
				]}							
			]
		});
		
		erpLeftRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpLeftTree"){
				searchErpLeftTree();
		    } 
		});
	}
	
	/*********************************************************/
	/* 전체상품 목록선택
	/*********************************************************/
	function initErpMiddRibbon(){
		erpMiddRibbon = new dhtmlXRibbon({
			parent : "div_erp_midd_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						{id : "search_erpMiddGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
				]}							
			]
		});
		
		erpMiddRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpMiddGrid"){
		    	search_erpMiddGrid();
		    } 
		});
	}
	

	/*********************************************************/
	/* 전체상품목록 조회 
	/*********************************************************/
	function initErpMiddGrid(){
		erpMiddGridColumns = [
			  {id : "NO"                 , label:["NO"                  , "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK"              , label:["#master_checkbox"    , "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "GOODS_NO"           , label:["상품코드"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "BCD_CD"             , label:["자바코드"            , "#text_filter"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "BCD_M_CD"           , label:["모바코드"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "BCD_NM"             , label:["상품명"              , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "DIMEN_NM"           , label:["규격"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "UNIT_CD"            , label:["단위"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "USE_YN"             , label:["사용여부"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "CDATE"              , label:["생성일시"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		];
		
		erpMiddGrid = new dhtmlXGridObject({
			parent: "div_erp_midd_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpMiddGridColumns
		});		
		erpMiddGrid.enableDistributedParsing(true, 100, 50);
		erpMiddGridDataProcessor = $erp.initGrid(erpMiddGrid);
		$erp.initGridDataColumns(erpMiddGrid);		
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
			  {id : "NO"                 , label:["NO"                  , "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK"              , label:["#master_checkbox"    , "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "GOODS_NO"           , label:["상품코드"            , "#text_filter"], type: "ro", width: "80", sort : "str", align : "left",   isHidden : false, isEssential : false}
			, {id : "USE_YN"             , label:["사용여부"            , "#text_filter"], type: "ro", width: "50", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "BCD_CD"             , label:["자바코드"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : false}
			, {id : "BCD_M_CD"           , label:["모바코드"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : false}
			, {id : "BCD_NM"             , label:["상품명"              , "#text_filter"], type: "ro", width: "200", sort : "str", align : "left",   isHidden : false, isEssential : false}
			, {id : "DIMEN_NM"           , label:["규격"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : false}
			, {id : "UNIT_CD"            , label:["단위"                , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : false}
			, {id : "CDATE"              , label:["생성일시"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "CUSTMR_CD"          , label:["거래처코드"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true,  isEssential : true}
			, {id : "ORD_TYPE"           , label:["매입매출구분"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true,  isEssential : true}
			, {id : "ORGN_DIV_CD"        , label:["조직코드"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true,  isEssential : true}
			, {id : "ORGN_CD"            , label:["매장코드"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true,  isEssential : true}
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
		
		erpTopLayout.progressOn();
		
		var scrin_cd        = document.getElementById("txtSCRIN_CD").value;

		//$erp.dataSerialize("aaa");
		//,data : { "aaa".dataSerialize}
		
		$.ajax({
			url : "/sis/basic/custmrSearchR1.do"
			,data : {
				"SEARCH_VAL"       : scrin_cd
				, "cmbPartnerIO"   : "2"              /* 1 매입처, 2 매출처 */
				, "cmbPamentDay"   : ""
				, "cmbSourcing"    : ""
				, "cmbPartnerPart" : ""
				, "cmbPartnerType" : ""
			}
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
	/* 바코드마스트 상품목록조회
	/*********************************************************/
	function search_erpMiddGrid(){
		/*  Iput validation은 필요없음 조건이 없으면 전체 출력 */
		erpMiddLayout.progressOn();
		
		var grup_top_cd = document.getElementById("hidGRUP_TOP_CD").value;
		var grup_mid_cd = document.getElementById("hidGRUP_MID_CD").value;
		var grup_bot_cd = document.getElementById("hidGRUP_BOT_CD").value;
		var goods_nm    = document.getElementById("txtBCD_NM").value;
		
		$.ajax({
			  url     : "/sis/basic/getSearchMasterBarcodeList.do"
			,data     : {
							  "PARAM_GRUP_TOP_CD" : grup_top_cd
							, "PARAM_GRUP_MID_CD" : grup_mid_cd
							, "PARAM_GRUP_BOT_CD" : grup_bot_cd
							, "PARAM_BCD_NM"      : goods_nm
		 	            }
			,method   : "POST"
			,dataType : "JSON"
			,success  : function(data){
				erpMiddLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					
					$erp.clearDhtmlXGrid(erpMiddGrid);
					var gridDataList2 = data.gridDataList;
					if($erp.isEmpty(gridDataList2)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpMiddGrid, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpMiddGrid.parse(gridDataList2, 'js');	
						erpMiddGrid.selectRowById(1);   
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpMiddGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpMiddLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}	

	/*********************************************************/
	/*  등록된 주문가능상품 조회Function
	/*********************************************************/
	function search_erpRightGrid(){
		
		var topRowid = erpTopGrid.getSelectedRowId();
		GLOVAL_CUSTMR_CD   = erpTopGrid.cells(topRowid, erpTopGrid.getColIndexById("custmr_cd" )).getValue();	
		var PARAM_BCD_NM   = document.getElementById("txtBCD_NM2").value;

		erpRightLayout.progressOn();
		
		$.ajax({
			  url     : "/sis/basic/getSearchTstdCustomerGoodsList.do"
			,data     : {
				             "PARAM_ORGN_DIV_CD"    : GLOVAL_ORGN_DIV_CD
				           , "PARAM_ORGN_CD"     : GLOVAL_ORGN_CD
				           , "PARAM_CUSTMR_CD" : GLOVAL_CUSTMR_CD
				           , "PARAM_BCD_NM"    : PARAM_BCD_NM
		 	            }
			,method   : "POST"
			,dataType : "JSON"
			,success  : function(data){
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
		
	/************************************************************/
	/* 선택된 source row의 값을  target으로 복사한다
	/************************************************************/
	function add_erpRightGrid(){
				
		var erpMiddGridRowCount = erpMiddGrid.getRowsNum();
		var topRid              = erpTopGrid.getSelectedRowId();
		GLOVAL_CUSTMR_CD        = erpTopGrid.cells(topRid, erpTopGrid.getColIndexById("custmr_cd" )).getValue();					
		
		for(var i = 0; i < erpMiddGridRowCount; i++){
			var leftRid = erpMiddGrid.getRowId(i);
			var check   = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("CHECK")).getValue();
			
			if(check == 1){
				
				var source_code     = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("BCD_CD")).getValue();
				var erpRightGridRowCount = erpRightGrid.getRowsNum();
				var isAble = true;
				
				/* Source의 선택된 Key값이 taget에 존재하는경우  skip한다 */
				for(var j = 0; j < erpRightGridRowCount ; j++){
					var rightRid = erpRightGrid.getRowId(j);
					var target_code = erpRightGrid.cells(rightRid, erpRightGrid.getColIndexById("BCD_CD")).getValue();
					if(source_code == target_code){
						isAble = false;
						break;
					}
				}

				/* 선택된 source row의 값을  target으로 복사한다 */ 
				if(isAble === true){
					var uid = erpRightGrid.uid();
					erpRightGrid.addRow(uid);
					
					var GOODS_NO = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("GOODS_NO"  )).getValue();		
					var BCD_CD   = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("BCD_CD"   )).getValue();
					var BCD_M_CD = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("BCD_M_CD" )).getValue();					
					var BCD_NM = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("BCD_NM" )).getValue();					
					var DIMEN_NM = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("DIMEN_NM" )).getValue();					
					var UNIT_CD  = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("UNIT_CD"  )).getValue();		
					
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORGN_DIV_CD"   )).setValue(GLOVAL_ORGN_DIV_CD);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORGN_CD"    )).setValue(GLOVAL_ORGN_CD);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("CUSTMR_CD")).setValue(GLOVAL_CUSTMR_CD);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("GOODS_NO" )).setValue(GOODS_NO);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("BCD_CD"   )).setValue(BCD_CD);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("BCD_M_CD" )).setValue(BCD_M_CD);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("BCD_NM" )).setValue(BCD_NM);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("DIMEN_NM" )).setValue(DIMEN_NM);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("UNIT_CD"  )).setValue(UNIT_CD);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("USE_YN"   )).setValue("Y");
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORD_TYPE" )).setValue("0");  /* 0 구매 */
				}
			}
		}
		$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
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
	/* 대상거래처 납품업체 등록전 유효성 검사 
	/*********************************************************/
	function isSaveErpRightGridValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var isMainYesCount = 0;
		var erpRightGridRowCount = erpRightGrid.getRowsNum();
		for(var i = 0; i < erpRightGridRowCount ; i++){
			var rId = erpRightGrid.getRowId(i);
			var tempStatus = erpRightGrid.getDataProcessor().getState(rId);
			var status = "R";
			if(tempStatus == "inserted"){
				status = "C";
			} else if (tempStatus == "updated"){
				status = "U";
			} else if (tempStatus == "deleted") {
				status = "D";
			}

			if(status != "D" ){
				isMainYesCount++;
			}
		}
		
		if(isMainYesCount > 1){
			isValidated = false;
			alertMessage = "error.common.system.menu.menuByScreenManagement.main_yn.mustCountOne";
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
			 url      : "/sis/basic/CustomerGoodsManagementCUD.do"
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
		search_erpRightGrid();
	}
	
	/*********************************************************/
	/* dhtmlXCombo 초기화 Function
	/*********************************************************/
	function initDhtmlXCombo(){
		/* 사용여부 */
		cmbUSE_YN      = $erp.getDhtmlXComboCommonCode('cmbUSE_YN',       'cmbUSE_YN',      ['YN_CD','YN'],           100, "모두조회", false, cmbUSE_YN);
	}
	
</script>
</head>
<body>				
	 <div id="div_erp_00_Layout" class="samyang_div" style="display:none;">
		<div id="div_erp_top_search" class="samyang_div" style="display:none;">
			<table class="table_search" id="aaa">
				<colgroup>
					<col width="50px" />
					<col width="150px" />
					<col width="70px" />
					<col width="150px" />
					<col width="150px" />
					<col width="150px" />
					<col width="150px" />
					<col width="150px" />
					<col width="150px" />
					<col width="*" />
				</colgroup>
				<tr>
					<th>검색어</th>
					<td><input type="text" id="txtSCRIN_CD" name="SCRIN_CD" class="input_common" maxlength="505" onkeydown="$erp.onEnterKeyDown(event, search_erpMiddGrid);"></td>
					<th>거래상태</th>
					<td colspan="7"><div id="cmbUSE_YN"></div></td>
				</tr>
			</table>
		</div>
		<div id="div_erp_top_ribbon" class="samyang_div"   style="display:none;"></div>
		<div id="div_erp_top_grid"   class="samyang_div"   style="display:none;"></div>
	 </div>

     <!-- 상품 대.중.소 Tree출력 -->
	 <div id="div_erp_21_Layout" class="div_tree_full_size" style="display:none;">	 
		<div id="div_erp_left_search" class="samyang_div" style="display:none">
			<table class="table_search">
				<colgroup>
					<col width="50px">
					<col width="*">
				</colgroup>
				<tr>
					<th>검색어</th>
					<td>
						<input type="text" id="txtKEY_WORD" name="KEY_WORD" class="input_common" maxlength="10" onkeydown="$erp.onEnterKeyDown(event, searchErpLeftTree);">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_left_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_left_tree" class="div_tree_full_size" style="display:none"></div>	 
	 </div>
	 

	 <div id="div_erp_22_Layout" class="samyang_div" style="display:none;">
		<div id="div_erp_midd_search" class="samyang_div" style="display:none">
			<table id="tb_erp_right_data" class="table_search">
				<colgroup>
					<col width="50px">
					<col width="140px">
					<col width="50px">
					<col width="50px">
					<col width="50px">
					<col width="50px">
					<col width="50px">
					<col width="50px">
					<col width="50px">
					<col width="50px">
					<col width="50px">
				</colgroup>
				<tr>
					<th colspan="1">상품명</th>
				    <td><input type="text" id="txtBCD_NM" name="BCD_NM" class="input_common" maxlength="50" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid);"></td>
					<th colspan="1">대분류</th>
					<td colspan="2">
						<input type="hidden" id="hidGRUP_TOP_CD">
						<input type="text" id="txtGRUP_TOP_NM" name="GRUP_TOP_NM" class="input_common input_readonly" maxlength="20" readonly="readonly">
					</td>
					<th colspan="1">중분류</th>
					<td colspan="2">
						<input type="hidden" id="hidGRUP_MID_CD">
						<input type="text" id="txtGRUP_MID_NM" name="GRUP_MID_NM" class="input_common input_readonly" maxlength="20" readonly="readonly">
					</td>
					<th colspan="1">소분류</th>
					<td colspan="3">
						<input type="hidden" id="hidGRUP_BOT_CD">
						<input type="text" id="txtGRUP_BOT_NM" name="GRUP_BOT_NM" class="input_common input_readonly" maxlength="20" readonly="readonly">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_midd_ribbon" class="samyang_div" style="display:none"></div>	
		<div id="div_erp_midd_grid"   class="samyang_div" style="display:none"></div>			
	 </div>

	 <div id="div_erp_23_Layout" class="samyang_div" style="display:none;">
		<div id="div_erp_right_search" class="samyang_div" style="display:none;">
			<table class="table_search2" id="bbb">
				<colgroup>
					<col width="50px">
					<col width="100px">
					<col width="100px">
					<col width="100px">	
					<col width="100px">
					<col width="*">				
				</colgroup>
				<tr>
					<th>상품명</th>
					<td><input type="text" id="txtBCD_NM2" name="BCD_NM" class="input_common" maxlength="505" onkeydown="$erp.onEnterKeyDown(event, search_erprRightGrid);"></td>
					<th></th>
                    <td colspan="3"> </td>
				</tr>
			</table>
		</div>
		<div id="div_erp_right_ribbon" class="samyang_div"   style="display:none;"></div>
		<div id="div_erp_right_grid"   class="samyang_div"   style="display:none;"></div>
	 </div>
	 
</body>
</html>