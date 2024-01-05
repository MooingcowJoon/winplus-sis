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
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpLeftGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpLeftGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpLeftGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
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
	var erpMidLayout;
	var erpLeftLayout;
	var erpRightLayout;
	var erpRibbon;	
	var erpRibbonmk;	
	
	var erpLeftGrid;
	var erpRightGrid;
	var erpLeftGridColumns;
	var erpRightGridColumns;
	
	var erpLeftGridDataProcessor;	
	var erpRightGridDataProcessor;	
	
	var cmbPartnerIO;    /* 거래처구분 */
    var cmbSourcing;     /* 소싱그룹           */
	var cmbPartnerPart;  /* 공급사분류코드     */
	var cmbPartnerType;  /* 공급사유형         */
	var erpLeftGridSelectedCustmr_cd;   /* 그리드 rowSelected */
	
	$(document).ready(function(){	
		initMidLayout();
		initLeftLayout();
		initErpLeftRibbon();
		initErpLeftGrid();
		
		/* 우측그리드 */
		initRightLayout();
		initErpRightRibbon();
		initErpRightGrid();
		getLoginOrgInfo();
		
	});
	
	/***************************************************/
	/* Login Id 조직 및 권한구하기 
	/***************************************************/
	function getLoginOrgInfo( ){
		erpMidLayout.progressOn();
		$.ajax({
			url : "/sis/order/getLoginOrgInfo.do"
			,data : { "LoginID"  : "" }
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpMidLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					LOGIN_ORGN_DIV_CD    =  data.gridDataList.ORGN_DIV_CD;
					LOGIN_ORGN_DIV_NM    =  data.gridDataList.ORGN_DIV_CD_NM;
					LOGIN_ORGN_DIV_TYP   =  data.gridDataList.ORGN_DIV_TYPE;
			        LOGIN_ORGN_CD        =  data.gridDataList.DEPT_CD;
			        LOGIN_ORGN_NM        =  data.gridDataList.ORGN_NM;
			        LOGIN_EMP_NO         =  data.gridDataList.EMP_NO;
			        LOGIN_EMP_NM         =  data.gridDataList.EMP_NM;
			        
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
	
	/***************************************************/
	/*  2. SUB Layout( 3U세로 3등분)
    /***************************************************/
	function initMidLayout() {
		
		erpMidLayout = new dhtmlXLayoutObject({
			parent    : document.body
			, skin    : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2U"
			, cells   : [
							{id:"a", text: "대상거래처", header: true,  width:800}
							, {id:"b", text: "닙품거래처", header: true}
						]
		});
		
		erpMidLayout.cells("a").attachObject("div_erp_21_Layout");
		erpMidLayout.cells("b").attachObject("div_erp_22_Layout");
		
		erpMidLayout.setSeparatorSize(1,0);
		erpMidLayout.setSeparatorSize(1,1);
		
	}	
	
	/***************************************************/
	/*  3. 제일좌측 layout에 전체거래처를 출력한다
    /***************************************************/	
	function initLeftLayout(){
		
		erpLeftLayout = new dhtmlXLayoutObject({
			parent   : "div_erp_21_Layout"
			, skin   : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells  : [
							{id: "a", text: "11111", header:false, height:69}
							, {id: "b", text: "22222", header:false, fix_size:[true, true]}
							, {id: "c", text: "33333", header:false}
						]		
		});
		
		erpLeftLayout.cells("a").attachObject("div_erp_contents_search");
		erpLeftLayout.cells("b").attachObject("div_erp_ribbon");
		erpLeftLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftLayout.cells("c").attachObject("div_erp_grid");
		erpLeftLayout.setSeparatorSize(1, 0);
	}

	/***************************************************/
	/*  4. 제일우측 layout에 전체거래처를 출력한다
    /***************************************************/	
	function initRightLayout(){
		     
		erpRightLayout = new dhtmlXLayoutObject({
			parent   : "div_erp_22_Layout"
			, skin   : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells  : [
							 {id: "a", text: "", header:false, height:69}
							, {id: "b", text: "", header:false, fix_size:[true, true]}
							, {id: "c", text: "", header:false}
						]
		});
		
		erpRightLayout.cells("a").attachObject("div_erp_contents_searchmk");
		erpRightLayout.cells("b").attachObject("div_erp_ribbonmk");
		erpRightLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightLayout.cells("c").attachObject("div_erp_gridmk");
		erpRightLayout.setSeparatorSize(1, 0);

		
	}	

	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>	
	function initErpLeftRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						{id : "search_erpLeftGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpLeftGrid"){
				search_erpLeftGrid();
			} 
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	

	/*********************************************************/
	/* 대상거래처( 거래처마스터중에서 전체공급사만 조회)
	/*********************************************************/
	function initErpLeftGrid(){
		erpLeftGridColumns = [
			  {id : "NO"                 , label:["NO"                  , "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK"              , label:["#master_checkbox"    , "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
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
			, {id : "mprogrm"            , label:["수정프로그램"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "mdate"              , label:["수정일시"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "muser"              , label:["수정자"              , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}			
		];
		
		erpLeftGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpLeftGridColumns
		});		
		erpLeftGrid.enableDistributedParsing(true, 100, 50);
		erpLeftGridDataProcessor = $erp.initGrid(erpLeftGrid);
		$erp.initGridDataColumns(erpLeftGrid);	
		erpLeftGridDataProcessor.setUpdateMode("off");

	}

	/*********************************************************/
	/* 매장별 등록된 납품업체(공급사) 조회
	/*********************************************************/
	function initErpRightRibbon(){
		erpRibbonmk = new dhtmlXRibbon({
			parent : "div_erp_ribbonmk"
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
		
		erpRibbonmk.attachEvent("onClick", function(itemId, bId){
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
			, {id : "use_yn"             , label:["사용여부"         , "#text_filter"], type: "combo", width: "50" , sort : "str", align : "left", isHidden : false, isEssential : true,  align : "center", commonCode : ["YN_CD","YN"]}
			, {id : "custmr_cd"          , label:["거래처코드"       , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "custmr_nm"          , label:["거래처명"          , "#text_filter"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "custmr_ceonm"       , label:["대표자명"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "corp_no"            , label:["사업자번호"         , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "taxbill_cd"         , label:["세무신고거래처"       , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "corp_ori_no"        , label:["종사업장번호"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "busi_cond"          , label:["업태"              , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "busi_type"          , label:["업종"              , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "resp_user_nm"       , label:["담당자명"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "ord_resp_user"      , label:["구매담당자"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "cent_resp_user"     , label:["센터담당자"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "tel_no"             , label:["전화번호"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "phon_no"            , label:["담당자 휴대폰"       , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "cuser"              , label:["생성자"              , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "cdate"              , label:["생성일시"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "mprogrm"            , label:["수정프로그램"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : false}
			, {id : "mdate"              , label:["수정일시"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "muser"              , label:["수정자"              , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : false}
			, {id : "ORGN_DIV_CD"        , label:["조직코드"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ORGN_CD"            , label:["매장코드"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
		];
		
		erpRightGrid = new dhtmlXGridObject({
			  parent     : "div_erp_gridmk"
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
	function search_erpLeftGrid(){
		
		erpLeftLayout.progressOn();
		
		var scrin_cd        = document.getElementById("txtSCRIN_CD").value;
		var cmbPartnerIO2   = cmbPartnerIO.getSelectedValue();
		var cmbSourcing2    = cmbSourcing.getSelectedValue();
		var cmbPartnerPart2 = cmbPartnerPart.getSelectedValue();
		var cmbPartnerType2 = cmbPartnerType.getSelectedValue();
		//$erp.dataSerialize("aaa");
		//,data : { "aaa".dataSerialize}
		
		$.ajax({
			url : "/sis/basic/custmrSearchR1.do"
			,data : {
				"SEARCH_VAL"       : scrin_cd
				, "cmbPartnerIO"   : cmbPartnerIO2
				, "cmbPamentDay"   : ""
				, "cmbSourcing"    : cmbSourcing2
				, "cmbPartnerPart" : cmbPartnerPart2
				, "cmbPartnerType" : cmbPartnerType2
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLeftLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpLeftGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpLeftGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpLeftGrid.parse(gridDataList, 'js');	
						search_erpRightGrid();
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpLeftGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLeftLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	

	/*********************************************************/
	/* 대상거래처 납품업체등록건의 조회Function
	/*********************************************************/
	function search_erpRightGrid(){
		
		erpRightLayout.progressOn();
		
		$.ajax({
			url : "/sis/basic/custmrSearchR1Mk.do"
			,data : {
						"PARAM_ORGN_DIV_CD" : LOGIN_ORGN_DIV_CD
						, "PARAM_ORGN_CD" : LOGIN_ORGN_CD
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
		
	/************************************************************/
	/* 선택된 source row의 값을  target으로 복사한다
	/************************************************************/
	function add_erpRightGrid(){
				
		var erpLeftGridRowCount = erpLeftGrid.getRowsNum();
		
		for(var i = 0; i < erpLeftGridRowCount; i++){
			var leftRid = erpLeftGrid.getRowId(i);
			var check   = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("CHECK")).getValue();

			if(check == 1){
				
				var source_custmr_cd     = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("custmr_cd")).getValue();
				var erpRightGridRowCount = erpRightGrid.getRowsNum();
				var isAble = true;
				
				/* Source의 선택된 Key값이 taget에 존재하는경우  skip한다 */
				for(var j = 0; j < erpRightGridRowCount ; j++){
					var rightRid = erpRightGrid.getRowId(j);
					var target_custmr_cd = erpRightGrid.cells(rightRid, erpRightGrid.getColIndexById("custmr_cd")).getValue();
					if(source_custmr_cd == target_custmr_cd){
						isAble = false;
						break;
					}
				}

				/* 선택된 source row의 값을  target으로 복사한다 */ 
				if(isAble === true){
					var uid = erpRightGrid.uid();
					erpRightGrid.addRow(uid);
					
					var custmr_cd      = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("custmr_cd"     )).getValue();
					var custmr_nm      = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("custmr_nm"     )).getValue();
					var custmr_ceonm   = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("custmr_ceonm"  )).getValue();
					var corp_no        = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("corp_no"       )).getValue();
					var taxbill_cd     = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("taxbill_cd"    )).getValue();
					var corp_ori_no    = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("corp_ori_no"   )).getValue();
					var busi_cond      = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("busi_cond"     )).getValue();
					var busi_type      = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("busi_type"     )).getValue();
					var resp_user_nm   = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("resp_user_nm"  )).getValue();
					var ord_resp_user  = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("ord_resp_user" )).getValue();
					var cent_resp_user = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("cent_resp_user")).getValue();
					var tel_no         = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("tel_no"        )).getValue();
					var phon_no        = erpLeftGrid.cells(leftRid, erpLeftGrid.getColIndexById("phon_no"       )).getValue();

					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORGN_DIV_CD"   )).setValue(LOGIN_ORGN_DIV_CD);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORGN_CD"       )).setValue(LOGIN_ORGN_CD);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("custmr_cd"     )).setValue(custmr_cd);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("custmr_nm"     )).setValue(custmr_nm);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("custmr_ceonm"  )).setValue(custmr_ceonm);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("corp_no"       )).setValue(corp_no);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("taxbill_cd"    )).setValue(taxbill_cd);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("corp_ori_no"   )).setValue(corp_ori_no);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("busi_cond"     )).setValue(busi_cond);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("busi_type"     )).setValue(busi_type);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("resp_user_nm"  )).setValue(resp_user_nm);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ord_resp_user" )).setValue(ord_resp_user);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("cent_resp_user")).setValue(cent_resp_user);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("tel_no"        )).setValue(tel_no);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("phon_no"       )).setValue(phon_no);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("use_yn"        )).setValue("Y");
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
	/* 대상거래처 납품업체 등록처리
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
			 url      : "/sis/basic/CustomerManagementCUD.do"
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
		/* 매입-매출처구분 */
		cmbPartnerIO = $erp.getDhtmlXComboCommonCode('cmbPartnerIO', 'cmbPartnerIO', 'PUR_SALE_TYPE', 100, "모두조회", false);
		/* 마감일자(결제기준) */
		cmbPamentDay = $erp.getDhtmlXComboCommonCode('cmbPamentDay', 'cmbPamentDay', 'PAY_STD', 180, "모두조회", false);
		/* 소싱그룹 */
		cmbSourcing = $erp.getDhtmlXComboCommonCode('cmbSourcing', 'cmbSourcing', 'SUPR_GOODS_GRUP', 100, "모두조회", false);
		/* 공급사분류코드 */
		cmbPartnerPart = $erp.getDhtmlXComboCommonCode('cmbPartnerPart', 'cmbPartnerPart', 'SUPR_GRUP_CD', 100, "모두조회", false);
		/* 공급사유형 */
		cmbPartnerType = $erp.getDhtmlXComboCommonCode('cmbPartnerType', 'cmbPartnerType', 'SUPR_TYPE', 100, "모두조회", false);
	}
	
	
</script>
</head>
<body>
	<div id="div_erp_21_Layout" class="samyang_div" style="display:none;">
		<div id="div_erp_contents_search" class="samyang_div" style="display:none;">
			<table class="table_search" id="aaa">
				<colgroup>
					<col width="70px">
					<col width="140px">
					<col width="100px">
					<col width="100px">	
					<col width="100px">
					<col width="*">
				</colgroup>
				<tr>
					<th>검색어</th>
					<td><input type="text" id="txtSCRIN_CD" name="SCRIN_CD" class="input_common" maxlength="505" onkeydown="$erp.onEnterKeyDown(event, search_erpLeftGrid);"></td>
					<th>거래구분</th>
					<td><div id="cmbPartnerIO"></div></td>
					<th>마감일자</th>
					<td><div id="cmbPamentDay"></div></td>
				</tr>
				<tr>
					<th>소싱그룹</th>
					<td><div id="cmbSourcing"></div></td>
					<th>공급사분류</th>
					<td><div id="cmbPartnerPart"></div></td>
					<th>공급사유형</th>
					<td><div id="cmbPartnerType"></div></td>
				</tr>
			</table>
		</div>
		<div id="div_erp_ribbon" class="samyang_div"   style="display:none;"></div>
		<div id="div_erp_grid"   class="samyang_div"   style="display:none;"></div>
	</div>
	<div id="div_erp_22_Layout" class="samyang_div" style="display:none;">
		<div id="div_erp_contents_searchmk" class="samyang_div" style="display:none;">
			<table class="table_search2" id="bbb">
				<colgroup>
					<col width="100px">
					<col width="100px">
					<col width="100px">
					<col width="100px">	
					<col width="100px">
					<col width="*">
				</colgroup>
				<tr>
					<th>검색어</th>
					<td><input type="text" id="txtSCRIN_CD2" name="SCRIN_CD2" class="input_common" maxlength="505" onkeydown="$erp.onEnterKeyDown(event, search_erprRightGrid);"></td>
					<th></th>
					<td colspan="3"> </td>
				</tr>
			</table>
		</div>
		<div id="div_erp_ribbonmk" class="samyang_div" style="display:none;"></div>
		<div id="div_erp_gridmk" class="samyang_div" style="display:none;"></div>
	</div>
</body>
</html>