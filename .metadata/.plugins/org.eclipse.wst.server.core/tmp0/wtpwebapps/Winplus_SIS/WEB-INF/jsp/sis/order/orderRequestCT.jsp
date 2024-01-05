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
		※ 전역 변수 선언부( 센터에서 외부협력사 주문서요청 orderRequesCT.jsp )
		□ 변수명 : Type / Description	var cmbORD_TYPE_CD;                  /* 발주유형           */
		
		■ erpRightLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / 류코드 DhtmlXGrid Header
		■ erpRightGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbOUT_WARE_CD : Object / 출고창고 DhtmlXCombo  (CODE : CENTER_CD )
		■ cmbORD_STATE : Object / 진행상태  (CODE : ORD_STATE )
		■ 최종수정일자 : 2019-11-03 (착지변경 기능추가)
	--%>
	//var thisPopupWindow = parent.erpPopupWindows.window('orderPortalGridPopup');
	
	var CurrentRow = 0;
	var erpRightLayout;
	var erpRightRibbon;	
	var erpRightGrid;
	var erpRightGridColumns;
	var erpRightGridDataProcessor;	
	var cmbOUT_WARE_CD;                  /* 출고창고           */
	var cmbMKT_TYPE_CD;                  /* 발행구분(PC/PDA)   */
	var cmv_select_cd = "";
	var cmbCUST_NAME   = "";
	
	
	var cmbORD_STATE;                    /* 주문진행상태       */
	var cmbOUT_WARE_CD;                  /* 상품조회  협력사   */
	var cmbSEND_WARE_CD;                 /* 배송직영점         */
	var erpRightGridSelectedCustmr_cd;   /* 그리드 rowSelected */

	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	var LOGIN_ORGN_DIV_CD  = "";
	var LOGIN_ORGN_CD      = "";
	var LOGIN_ORGN_DIV_TYP = "";
	var LOGIN_CUSTMR_CD    = "";
	var LOGIN_CUSTMR_NM    = "";
	var GLOVAL_SUPR_CD     = "";      /* 협력사코드 : 출고창고 COMBO박스에 선택된 코드  */

    /*  본사조직으로 로그인후  직영점 선택시 처리하기 위함 */
	var GLOVAL_ORGN_DIV_CD  = "";
	var GLOVAL_ORGN_CD      = "";
	var GLOVAL_ORGN_NM      = "";
	var GLOVAL_ORGN_DIV_TYP = "";
    var	GLOVAL_LMT_CNTROL_YN  = "";     /* 주문한도 체크여부 */

	var All_checkList = "";
	var Code_List = "";

	var SELECT_LVL           =  "";
	var SELECT_GRUP_TOP_CD   =  "";
	var SELECT_GRUP_MID_CD   =  "";
	var SELECT_GRUP_BOT_CD   =  "";

	/* 윈플러스 및 윈플러스 거래처정보 KEEP */
	var GLOVL_WINPLUS_CD     = "";
	var GLOVL_WINPLUS_NM     = "";
	var GLOVL_NOR_CLSTIME    = "";
	
	$(document).ready(function(){		

		initErpLayout();
		
		initErpLayout11();
		
		initErpLeftLayout();
		initErpLeftRibbon();
		initErpLeftTree();
		
		initerpRightLayout();
		initErpRightRibbon();
		
		initErpBackGrid();   // 복사용 Buffer그리드 
		initErpRightGrid();  // 주문서 편집용그리드
		//initDhtmlXCombo();
		
		erpLayout.cells("a").collapse();
		document.getElementById("txtORD_PATH").value = "1";  /* 주문경로  P(포털), 1, 센터, 2직영점*/
		getLoginOrgInfo();
        		

	});
	
	/***************************************************/
	/*  1. MAIN Layout(1C)
    /***************************************************/
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent    : document.body
			, skin    : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2U"
			, cells   : [
							  {id:"a", text: "상품목록"  , header: true, width:200}
							, {id:"b", text: "발주서"    , header: true}
						]
		});
		
		erpLayout.cells("a").attachObject("div_erp_20_Layout");
		erpLayout.cells("b").attachObject("div_erp_23_Layout");
		
		erpLayout.setSeparatorSize(1,0);
		erpLayout.setSeparatorSize(1,1);
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
					/*********************************************************************/
					/* ※아주중요 센터레벨에서는 윈플러스(본사)인지 팜인지 결정해야한다   */
					/*********************************************************************/
					if ( LOGIN_ORGN_DIV_CD == "A06") {
				        LOGIN_CUSTMR_CD      =   data.gridDataList.WIN_PARM_CUSTMR_CD   /* 윈플러스 팜  대표코드 */
				        LOGIN_CUSTMR_NM      =   data.gridDataList.WIN_PARM_CUSTMR_NM;
					} else {
				        LOGIN_CUSTMR_CD      =   data.gridDataList.WIN_CUSTMR_CD   /* 윈플러스 대표코드 */
				        LOGIN_CUSTMR_NM      =   data.gridDataList.WIN_CUSTMR_NM;
					}

			        GLOVAL_ORGN_DIV_CD   =   data.gridDataList.ORGN_DIV_CD;
			        GLOVAL_ORGN_DIV_TYP  =   data.gridDataList.ORGN_DIV_TYPE;
					GLOVAL_ORGN_CD       =   data.gridDataList.DEPT_CD;
					GLOVAL_LMT_CNTROL_YN =   data.gridDataList.LMT_CNTROL_YN;   /* 발주한도 체크여부  */
			        
					console.log("LOGIN_ORGN_DIV_CD=>"   + LOGIN_ORGN_DIV_CD);          
					console.log("LOGIN_ORGN_DIV_NM=>"   + LOGIN_ORGN_DIV_NM);          
					console.log("LOGIN_ORGN_DIV_TYP=>"  + LOGIN_ORGN_DIV_TYP);          
					console.log("LOGIN_ORGN_CD=>"       + LOGIN_ORGN_CD);          
					console.log("LOGIN_ORGN_NM=>"       + LOGIN_ORGN_NM);          
					console.log("LOGIN_EMP_NO=>"        + LOGIN_EMP_NO);          
					console.log("LOGIN_EMP_NM=>"        + LOGIN_EMP_NM);  
					console.log("LOGIN_CUSTMR_CD=>"     + LOGIN_CUSTMR_CD);          
					console.log("LOGIN_CUSTMR_NM=>"     + LOGIN_CUSTMR_NM);  
					console.log("GLOVAL_LMT_CNTROL_YN=>"     + GLOVAL_LMT_CNTROL_YN);  
					
					initDhtmlXCombo();					
					document.getElementById("txtORD_DATE").value   = today;
			        document.getElementById("txtCUST_CD").value    = LOGIN_CUSTMR_CD;    /* 고객cd */
			       // document.getElementById("Cust_Name").value     = LOGIN_CUSTMR_NM;    /* 고객명 */
			        
			        GLOVL_WINPLUS_CD                               = data.gridDataList.WIN_CUSTMR_CD; 			        
			        GLOVL_WINPLUS_NM                               = data.gridDataList.WIN_CUSTMR_NM; 	

			        document.getElementById("txtRESP_USER").value   = LOGIN_EMP_NO;      /* 처리자 */
			        document.getElementById("RESP_USER_NAME").value = LOGIN_EMP_NM;      /* 처리자명 */
			        
			        document.getElementById("SendDay").value            = data.gridDataList.DELI_YOIL;        /* 배송요일 */
			        document.getElementById("BusinessDay").value        = data.gridDataList.LEAD_TIME;        /* 리드타임 */
			        
			        document.getElementById("IlbanGoodsDeatline").value = data.gridDataList.CLSE_TIME;        /* 주문마감시간 */
				    /*
			        GLOVL_NOR_CLSTIME   = data.gridDataList.CLSE_TIME.substring(0, 2) + data.gridDataList.CLSE_TIME.substring(3);
			        */
			        /* 전문 취급점이면 최저매입매장 정보를 보여주지 않는다 */
			        if ( LOGIN_ORGN_DIV_TYP == "Z") {
				        erpRightGrid.setColumnHidden(19,true);  /* 전산재고 */
				        erpRightGrid.setColumnHidden(34,true);  /* 최저매입 */
				        erpRightGrid.setColumnHidden(35,true);
				        erpRightGrid.setColumnHidden(36,true);
				        erpRightGrid.setColumnHidden(37,true);
				        erpRightGrid.setColumnHidden(38,true);
			        }
			        //searchErpLeftTree();
			       // $('input').prop('readonly', true);
			        
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}	
	
	
	/***************************************************/
	/*  1-1-1. MAIN Layout(2E)
    /***************************************************/
	function initErpLayout11(){
		erpLayout11 = new dhtmlXLayoutObject({
			parent    : "div_erp_20_Layout"
			, skin    : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "1C"
			, cells   : [
							  {id:"a", text: "상품분류목록" , header: false, width:200}
						]
		});
		
		erpLayout11.cells("a").attachObject("div_erp_21_Layout");
		
		erpLayout11.setSeparatorSize(1,0);
		erpLayout11.setSeparatorSize(1,1);
		
	}	
			
	/************************************************************/
	/*  2. 제일좌측 layout에 상품대중소 그룹을 tree로 출력한다
    /***********************************************************/	
	function initErpLeftLayout(){
		
		erpLeftLayout = new dhtmlXLayoutObject({
			parent: "div_erp_21_Layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				 {id: "a", text: "검색어영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역"  , header:false, fix_size : [true, true]}
				,{id: "c", text: "트리영역"  , header:false, fix_size : [true, true]}
			]
		});
		
		erpLeftLayout.cells("a").attachObject("div_erp_left_search");
		erpLeftLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftLayout.cells("b").attachObject("div_erp_left_ribbon");
		erpLeftLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftLayout.cells("c").attachObject("div_erp_left_tree");
		
	}	

	/************************************************************/
	/*  2-1. 제일좌측 상품대중소 그룹을 tree구성을한다
    /***********************************************************/	
	function initErpLeftTree(){
		erpLeftTree = new dhtmlXTreeObject({
			parent : "div_erp_left_tree"
			, skin : ERP_TREE_CURRENT_SKINS			
			, image_path : ERP_TREE_CURRENT_IMAGE_PATH
		});
		
		/* 대.중.소를 선택시  선택분류단위로 주문가능 상품을 조회한다 */
		erpLeftTree.attachEvent("onClick", function(id){
			
			SELECT_LVL           =  "";
			SELECT_GRUP_TOP_CD   =  "";
			SELECT_GRUP_MID_CD   =  "";
			SELECT_GRUP_BOT_CD   =  "";

			if(!$erp.isEmpty(id)){
				<%-- 자식이 없는 경우(소분류)만 동작함 --%>
				if(!erpLeftTree.hasChildren(id)){
					currentErpLeftTreeId = id;
					//  20191015 searchErpLeftContents();  
					//console.log(" initErpLeftTree id =>" + id);
				}
			}
			
			console.log(" initErpLeftTree id =>" + id);
			
			if ( id == "ALL") {
				search_erpMiddGrid();
			}
			else {
				/* 20191021 */
			    getGroupCdFromTreeID(id);
			}
			
		});
		
		//searchErpLeftTree();
	}
	

	/**************************************************************/
	/* 대.중.소를 선택시  선택분류단위로 주문가능 상품을 조회한다
	/**************************************************************/
	function getGroupCdFromTreeID(id){
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/order/getGroupCdFromTreeID.do"
			,data : { "PARAM_TREE_ID"  : id  }
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					SELECT_LVL           =   data.gridDataList.LVL;
					SELECT_GRUP_TOP_CD   =   data.gridDataList.GRUP_TOP_CD;
					SELECT_GRUP_MID_CD   =   data.gridDataList.GRUP_MID_CD;
					SELECT_GRUP_BOT_CD   =   data.gridDataList.GRUP_BOT_CD;

					console.log("SELECT_LVL=>"  + SELECT_LVL);          
					console.log("SELECT_GRUP_TOP_CD=>"  + SELECT_GRUP_TOP_CD);          
					console.log("SELECT_GRUP_TOP_CD=>"  + SELECT_GRUP_MID_CD);          
					console.log("SELECT_GRUP_TOP_CD=>"  + SELECT_GRUP_TOP_CD);          

					search_erpMiddGrid();
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}	
	
	/************************************************************/
	/*  2-2. 제일좌측 상품대중소 그룹을 tree Controller호출
    /***********************************************************/	
	function searchErpLeftTree(){
		erpLeftLayout.progressOn();
		
		var cmv_type_cd  = cmbORD_TYPE_CD.getSelectedValue();
		var cmv_type_nm  = "";
		
		if  (cmv_type_cd  == "2") { cmv_type_nm = "OT1" }
		else if  (cmv_type_cd  == "4") { cmv_type_nm = "CHG" }
		else cmv_type_nm = "";
		
		if (!GLOVAL_SUPR_CD)   {
			erpLeftLayout.progressOff();
			return;
		}
		if (!cmv_type_cd)      {
			erpLeftLayout.progressOff();
			return;
		}
		
		$.ajax({
			 url      : "/sis/order/getGoodsTreeList.do"
			,data     : {   "PARAM_ORGN_DIV_CD" :  GLOVAL_ORGN_DIV_CD
				           ,"PARAM_CUST_CD"     :  LOGIN_CUSTMR_CD
				           ,"PARAM_CUST_DIV_CD" :  cmv_type_nm   /*  OUT외부공급사, CHG외부공급사 착지변경  */
					       ,"PARAM_GOODS_TYPE"  :  "2"           /* 1물류, 2직납, 3신선, 4착지 5일배  */ 
				           ,"OUT_CUST_CD"       :  GLOVAL_SUPR_CD
				        }
			 
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
				erpLeftLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}	

	/*********************************************************/
	/* 바코드마스트 상품목록조회
	/*********************************************************/
	function search_erpMiddGrid(){
		/*  Iput validation은 필요없음 조건이 없으면 전체 출력 */
		erpRightLayout.progressOn();

		var grup_top_cd  = SELECT_GRUP_TOP_CD;
		var grup_mid_cd  = SELECT_GRUP_MID_CD;
		var grup_bot_cd  = SELECT_GRUP_BOT_CD;
		var selectct_lvl = SELECT_LVL;
		var goods_nm     = "";
		var cmv_type_cd  = cmbORD_TYPE_CD.getSelectedValue();
		var cmv_type_nm  = "";
		var cmv_call_nm  = "";
		
		//  OUT 화면애서 공급사 지정없이  BCD기준으로 최저가 구하기  OT1 반드시공급사를 지정해야함
        if  (cmv_type_cd  == "2") { 
			      cmv_type_nm = "직납발주";
				  cmv_call_nm = "OT1";        
			 }
		else if  (cmv_type_cd  == "4") { 
			      cmv_type_nm = "착지변경";
			      cmv_call_nm = "CHG";
			 }
		else cmv_type_nm = "";

		var scrin_ORD_DATE = document.getElementById("txtORD_DATE").value;
		var scrin_SUPR_CD  = document.getElementById("hidSurp_CD").value;    /* 협력사 */
		var scrin_SUPR_NM  = document.getElementById("Surp_Name").value;      /* 협력사 */
		var scrin_ORGN_CD  = cmbCUST_NAME.getSelectedValue();  //※  로그인 조직인 본사이면 본사발주인데 이때 고객사조직(센터조직)으로 설정한다

		scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")
		
		/* ※ 발주요청서  ORD_NO ->  발주일자 + 발주쵸엉거래처 */
		var scrs_ORD_NO    = scrin_ORD_DATE + "_" + LOGIN_CUSTMR_CD;  

		/**************************************************************/
		/* 2020-01-23  ※ 아주 중요 본사조직이거나  조직코득 없는 경우 */
		/**************************************************************/
		if ( GLOVAL_ORGN_CD = "000000") {
			GLOVAL_ORGN_CD = scrin_ORGN_CD;
		}
		
		$.ajax({
			  url     : "/sis/order/getSearchMasterBarcodeCustmrPriceList.do"
			,data     : {
							  "PARAM_GRUP_TOP_CD" : grup_top_cd
							, "PARAM_GRUP_MID_CD" : grup_mid_cd
							, "PARAM_GRUP_BOT_CD" : grup_bot_cd
							, "PARAM_BCD_NM"      : goods_nm
							, "PARAM_ORGN_DIV_CD" : GLOVAL_ORGN_DIV_CD  /* 로그인 부문   */
 							, "PARAM_ORGN_CD"     : GLOVAL_ORGN_CD      /* 로그인 조직   */
							, "PARAM_CUSTMR_CD"   : LOGIN_CUSTMR_CD     /* 고객          */
					        , "PARAM_CUST_NM"     : LOGIN_CUSTMR_NM     /* 고객사명      */
					        , "PARAM_LVL"         : selectct_lvl
					        , "PARAM_ORD_NO"      : scrs_ORD_NO         /* 주문번호      */
					        , "PARAM_REQ_DATE"    : scrin_ORD_DATE      /* 발주일자      */
					        , "PARAM_ORD_TYPE"    : cmv_type_cd         /* 발주유형      */
					        , "PARAM_ORD_TYPE_NM" : cmv_type_nm         /* 발주유형명    */
					        , "PARAM_RESP_USER"   : LOGIN_EMP_NO        /* 로그인(처리자)*/
					        , "PARAM_EMP_NM"      : LOGIN_EMP_NM        /* 처리자명      */
					        , "PARAM_SUPR_CD"     : scrin_SUPR_CD       /* 협력사코드    */
					        , "PARAM_SUPR_NM"     : scrin_SUPR_NM       /* 협력사명      */
					        , "PARAM_CUS_TYPE"    : "1"                 /* 발행구분      */
					        , "PARAM_CUS_T_NM"    : "PC주문"            /* 발행구분명    */
						    , "PARAM_FLAG"        : "1"                 /* 처리상태      */
							, "PARAM_FLAG_NM"     : "발주예정"          /* 처리상태명    */
							, "PARAM_ROWNUM"      : 1                   /* 최저가로 가져오려면 2, else 999999 */
							, "PARAM_CUST_DIV_CD" : cmv_call_nm         /* B01물류센타로의 주문, A06신선팜으로주문, OUT외부공급사  */
					        , "PARAM_GOODS_TYPE"  : ""                  /* 센터에선 의미 없음   */ 
					        , "OUT_CUST_CD"       : GLOVAL_SUPR_CD
							
		 	            }
			,method   : "POST"
			,dataType : "JSON"
			,success  : function(data){
                erpRightLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpRightGrid); //기존데이터 삭제
					$erp.clearDhtmlXGrid(erpBackGrid);  //기존데이터 삭제
					
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpBackGrid, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						/*********************************************************************************************************************/
					    /* 대상을 가져와서 입력영역으로 옮길때 DataProcess CUD => C    발주할 DataProcess의 CUD상태를 일괄 C로 처리한다.     */
					    /**********************************************************************************************************************/	
					    erpBackGrid.parse(gridDataList, 'js');	
					    CurrentRow = 1;
						ObjectToEditBuffer("new");		
					    //erpRightGrid.selectRowById(1);   
					}
				}
				//$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
				
			}, error : function(jqXHR, textStatus, errorThrown){
				erpRightLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
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
	
	/****************************************************************************/
    /* 1-3.erpRightLayout 초기화                                                */
    /****************************************************************************/	
	function initerpRightLayout(){
		erpRightLayout = new dhtmlXLayoutObject({
			parent: 'div_erp_23_Layout'
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				  {id: "a", text: "", header:false, height:90}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		
		erpRightLayout.cells("a").attachObject("div_erp_contents_search");
		erpRightLayout.cells("b").attachObject("div_erp_ribbon");
		erpRightLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightLayout.cells("c").attachObject("div_erp_grid");
		
		erpRightLayout.setSeparatorSize(1, 0);
		erpRightLayout.captureEventOnParentResize(erpLayout);
				
	}

	/****************************************************************************/
    /* erpRightRibbon 초기화                                                         */
    /****************************************************************************/	
	function initErpRightRibbon(){
		
		/* 전문점 OR 취급점이면 */
		//if ( GLOVAL_ORGN_DIV_CD.substring(0,1)  == "Z") {
        // myToolbar.disableItem(id);

		erpRightRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						  {id : "search_ErpGrid",     type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
		     		    , {id : "add_erpGrid", 	      type : "button", text:'<spring:message code="ribbon.add" />',    isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
					   	, {id : "delete_erpGrid",     type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						, {id : "save_erpGrid",       type : "button", text:'임시저장',                                isbig : false, img : "menu/save.gif",   imgdis : "menu/save_dis.gif",   disable : true}
						, {id : "excel_erpGrid",      type : "button", text:'<spring:message code="ribbon.excel" />',  isbig : false, img : "menu/excel.gif",  imgdis : "menu/excel_dis.gif",  disable : true}
						//, {id : "print_erpRightGrid", type : "button", text:'<spring:message code="ribbon.print" />',  isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif",   disable : true}		
						, {id : "excel_erpGri2",      type : "button", text:'발주완료',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "excel_erpGri1",      type : "button", text:'거래내역조회',                            isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "excel_erpGri4",      type : "button", text:'착지변경불러오기',                        isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "excel_erpGri5",      type : "button", text:'일배발주불러오기',                        isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
				]}							
			]
		});
		
		
		erpRightRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_ErpGrid"){
		    	search_ErpRightGrid();
		    } else if (itemId == "add_erpGrid"){
		    	GoodsPricePopup_TO_ErpRightGrid();		    	
		    } else if (itemId == "delete_erpGrid"){
		    	delete_erpRightGrid()
		    } else if (itemId == "save_erpGrid"){
		    	insertPurordandGoodsConfirm();
		    } else if (itemId == "excel_erpGrid"){
		    	$erp.exportGridToExcel({
		    		"grid" : erpRightGrid
					, "fileName" : "주문서등록(센터)"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
		    } else if (itemId == "excel_erpGri1"){
		    	copy_ErpRightGrid();  /* 최근발주복사 */
		    } else if (itemId == "excel_erpGri2"){
		    	insertSelectPurordandGoodsConfirm(); // 발주확정
		    } else if (itemId == "excel_erpGri4"){
		    	LoadConfirm("4"); // 착지변경불러오기
		    } else if (itemId == "excel_erpGri5"){
		    	CallLoadConfirm("5"); // 일배발주불러오기
		    }
		});
		
	}

    /****************************************************************************/
    /*  착지변경/일배발주 불러오기                                              */
    /****************************************************************************/	
    function CallLoadConfirm( param ){

		var erpRightGridRowCount = erpRightGrid.getRowsNum();	
    	
    	var alertCode = "";
		var alertType = "alert";
		var callbackFunction = function(){
			LoadConfirm(param);
		}
	
		console.log( " param=>" + param );
		
		if  (erpRightGridRowCount > 0) {

	        if ( param  == "4" ) {
	           ls_message = "<br>작업중인 데이타가 있습니다.<br/> 착지변경 불러오기를 하시겠습니까?";
	        }
	        else
	        {
	           ls_message = "<br>작업중인 데이타가 있습니다.<br/> 일배발주 불러오기를 하시겠습니까?";
	        }
	
	   		$erp.confirmMessage({
	   			  "alertMessage" : ls_message
	   			, "alertCode"    : alertCode
	   			, "alertType"    : alertType
	   			, "alertCallbackFn" : callbackFunction
	   		});	

		}
    }
    
		
    /****************************************************************************/
    /*  착지변경/일배발주 불러오기                                              */
    /****************************************************************************/	
    function LoadConfirm( param ){
        
   		var erpRightGridRowCount = erpRightGrid.getRowsNum();
   		var ls_message = "";
   		
        var onRowDblClicked = function(id) {
            document.getElementById("ORD_NO").value  = this.cells(id, this.getColIndexById("ORD_NO")).getValue();
            $erp.closePopup2("orderSearchPopup");
        }
        
        var All_checkList = "";
        var onClickAddData = function(erpPopupGrid) {
            
            var check = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK")); // 조회된 그리드내역 중 선택한 row 번호 문자열로 넘어옴 ex) 1,5,7,10
            console.log(check);
            
            var checkList = check.split(',');
            var last_list_num = checkList.length - 1;
            var cnt  = 0;
            for(var i = 0 ; i < checkList.length ; i ++) {
                if(i != checkList.length ) {
                    cnt = cnt + 1;
                    if ( cnt > 1 ) {
                        All_checkList += ",";
                    } 
                    All_checkList +=  erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("ORD_NO")).getValue();
                } 
            }
            $erp.closePopup2("orderRequestPopup");
            
            console.log("체크된 주문서번호 >> " + All_checkList);
            
            if ( All_checkList != "") {
                 LoadConfirmReturnProcess(All_checkList, param);
            }
        }
        openOrderSecondPopup(onRowDblClicked, onClickAddData, param);
    }
    
    /****************************************************************************/
    /*  착지변경/일배발주 불러오기 팝업화면 호출                                */
    /****************************************************************************/	
    openOrderSecondPopup = function(onRowDblClicked, onClickAddData, param) {

        var onComplete = function(){
            var openPopupWindow = erpPopupWindows.window("orderRequestPopup");
            if(openPopupWindow){
                openPopupWindow.close();
            }        
        }
        
        var onConfirm = function(){
        }

		var scrin_ORD_DATE = document.getElementById("txtORD_DATE").value;
		scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")
		
        /* ORD_TYPE : 1:발주, 2:주문  */
        var url    = "/sis/order/orderRequestPopup.sis";

        var params = {    "ORGN_DIV_CD"   : GLOVAL_ORGN_DIV_CD   /* LOGIN_ORGN_DIV_CD  */ 
                        , "ORGN_CD"       : GLOVAL_ORGN_CD
                        , "ORGN_DIV_TYP"  : GLOVAL_ORGN_DIV_TYP
                        , "ORD_TYPE"      : param                /* 4 착지변경,  5 일배발주 */  
                        , "ORD_DATE"      : scrin_ORD_DATE       /* 발주 요청일자   */
                     }
        
        var option = {
		                  "width"  : 1400
		                , "height" : 700
		                , "win_id" : "orderRequestPopup"
        			 }
        
		var onContentLoaded = function(){
			var popWin = this.getAttachedObject().contentWindow;
	        if(onRowDblClicked && typeof onRowDblClicked === 'function'){
	            while(popWin.erpPopupOrderOnRowSelect == undefined){
	                popWin.erpPopupOrderOnRowSelect = onRowDblClicked;    
	            }
	        }
	        
	        if(onClickAddData && typeof onClickAddData === 'function'){
	        	while(popWin.erpPopupOrderCheckList == undefined){
	        		popWin.erpPopupOrderCheckList = onClickAddData;
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
        

    /******************************************************************************/
    /* 1. 팝업에서 선택한 발주번호를 기준으로 발주내역에서 조회한다.              */
    /*    (상품및 수량은 가져오지만 협력사및 단가는 현재 협력사및 단가)           */
    /* 2. Hidden 그리드에 조회한 내역을 저장한다.                                 */
    /* 3. Hidden 그리드에서 편집그리드로 복사한다( 단 중복상품은 불가하다)        */
    /******************************************************************************/
    function  LoadConfirmReturnProcess(All_checkList, param) {

    	console.log("All_checkList =>" + All_checkList  );

        erpRightLayout.progressOn();

        var scrin_ORD_DATE = document.getElementById("txtORD_DATE").value;
        scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")
        
   		var cmv_type_nm    = "";
   		var cmv_call_nm    = "";
	
   		switch (param) {
   	       case "4" :  cmv_type_nm = "착지변경"; cmv_call_nm = "OUT"; break;    /* 착지변경 */   
   	       case "5" :  cmv_type_nm = "일배발주"; cmv_call_nm = "OUT"; break;    /* 일배발주 */
   	       default  :  cmv_type_nm = ""; break;
   	    }  		

   		
        /*******************************************************/
        /* ※ 발주요청서  ORD_NO ->  발주일자 + 발주요청거래처 */
        /*******************************************************/
        var scrs_ORD_NO    = scrin_ORD_DATE + "_" + LOGIN_CUSTMR_CD;  	
        var scrs_ord_type  = "";
        
    	console.log("scrs_ORD_NO =>" + scrs_ORD_NO )  ;
    	
        $.ajax({
              url : "/sis/order/getSearchPDAOrderBarcodePriceList.do"
            ,data : {
                          "PARAM_ORGN_DIV_CD" : GLOVAL_ORGN_DIV_CD  /* 로그인 부문   */
                        , "PARAM_ORGN_CD"     : GLOVAL_ORGN_CD      /* 로그인 조직   */
                        , "PARAM_CUSTMR_CD"   : LOGIN_CUSTMR_CD     /* 고객          */
                        , "PARAM_CUST_NM"     : LOGIN_CUSTMR_NM     /* 고객사명      */
                        , "PARAM_LVL"         : ""                  /* 착지변경, 일배발주 불러오기시는 필요없음 */
                        , "PARAM_ORD_NO"      : scrs_ORD_NO         /* 발주번호      */
                        , "PARAM_REQ_DATE"    : scrin_ORD_DATE      /* 발주일자      */
                        , "PARAM_ORD_TYPE"    : param               /* 발주유형      */
                        , "PARAM_ORD_TYPE_NM" : cmv_type_nm         /* 발주유형명    */
                        , "PARAM_RESP_USER"   : LOGIN_EMP_NO        /* 로그인(처리자)*/
                        , "PARAM_EMP_NM"      : LOGIN_EMP_NM        /* 처리자명      */
                        , "PARAM_SUPR_CD"     : ""                  /* 협력사코드 : 본사(물류센터)에선 가격정보 최저가의 협력사정보 가져온다    */
                        , "PARAM_SUPR_NM"     : ""                  /* 협력사명   : 본사(물류센터)에선 가격정보 최저가의 협력사정보 가져온다    */
                        , "PARAM_CUS_TYPE"    : "1"                 /* 발행구분      */
                        , "PARAM_CUS_T_NM"    : "PC주문"            /* 발행구분명    */
                        , "PARAM_FLAG"        : "1"                 /* 처리상태      */
                        , "PARAM_FLAG_NM"     : "발주예정"          /* 처리상태명    */
                        , "PARAM_ROWNUM"      : 1                   /* 최저가로 가져오려면 2, else 999999 */
                        , "PARAM_CUST_DIV_CD" : cmv_call_nm         /* B01물류센타로의 주문, A06신선팜으로주문, OUT외부공급사  */
                        , "PARAM_CHANNEL"     : param               /* LOAD 1PDA, 2착지변경, 3일배발주 */
                        , "PARAM_SLT_ORD_NO"  : All_checkList       /* 1차발주한 발주번호  */
                    }            
            ,method : "POST"
            ,dataType : "JSON"
            ,success : function(data){
                erpRightLayout.progressOff();
                if(data.isError){
                    $erp.ajaxErrorMessage(data);
                } else {
                    $erp.clearDhtmlXGrid(erpBackGrid);
                    var gridDataList = data.gridDataList;
                    if($erp.isEmpty(gridDataList)){
                        $erp.addDhtmlXGridNoDataPrintRow(
                              erpBackGrid, '<spring:message code="grid.noSearchData" />'
                        );
                    } else {
                        erpBackGrid.parse(gridDataList, 'js');	
                        /* BackGrip에서 편집용그리드로 전체복사한다 */
                        ObjectToEditBuffer("new");		
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
    /* PDA발주요청서 LOAD                                    */
    /*********************************************************/
    function search_PDA_LOAD(param){
        /*  Iput validation은 필요없음 조건이 없으면 전체 출력 */
        erpRightLayout.progressOn();

        var selectct_lvl = SELECT_LVL;
        var goods_nm     = "";
        var cmv_type_cd  = cmbORD_TYPE_CD.getSelectedValue();
        var cmv_type_nm  = "";
        var cmv_call_nm  = "";
        
        /* 센터에서는 일괄 직납발주 한다 */
        cmv_type_nm = "직납발주";
        cmv_call_nm = "OUT"; 


        var scrin_ORD_DATE = document.getElementById("txtORD_DATE").value;
        var scrin_SUPR_CD  = document.getElementById("hidSurp_CD").value;     /* 협력사 */
        var scrin_SUPR_NM  = document.getElementById("Surp_Name").value;      /* 협력사 */
		var scrin_SEND_WARE_CD  = cmbSEND_WARE_CD.getSelectedValue();

        scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")
        
        /* ※ 발주요청서  ORD_NO ->  발주일자 + 발주요청거래처 */
        var scrs_ORD_NO    = scrin_ORD_DATE + "_" + LOGIN_CUSTMR_CD;  
        var Called_URL     = "";
        
        $.ajax({
              url     : "/sis/order/getSearchPDAOrderBarcodePriceList.do"
            ,data     : {
                              "PARAM_ORGN_DIV_CD" : GLOVAL_ORGN_DIV_CD  /* 로그인 부문   */
                            , "PARAM_ORGN_CD"     : GLOVAL_ORGN_CD      /* 로그인 조직   */
                            , "PARAM_CUSTMR_CD"   : LOGIN_CUSTMR_CD     /* 고객          */
                            , "PARAM_CUST_NM"     : LOGIN_CUSTMR_NM     /* 고객사명      */
                            , "PARAM_LVL"         : selectct_lvl
                            , "PARAM_ORD_NO"      : scrs_ORD_NO         /* 발주번호      */
                            , "PARAM_REQ_DATE"    : scrin_ORD_DATE      /* 발주일자      */
                            , "PARAM_ORD_TYPE"    : cmv_type_cd         /* 발주유형      */
                            , "PARAM_ORD_TYPE_NM" : cmv_type_nm         /* 발주유형명    */
                            , "PARAM_RESP_USER"   : LOGIN_EMP_NO        /* 로그인(처리자)*/
                            , "PARAM_EMP_NM"      : LOGIN_EMP_NM        /* 처리자명      */
                            , "PARAM_SUPR_CD"     : scrin_SUPR_CD       /* 협력사코드    */
                            , "PARAM_SUPR_NM"     : scrin_SUPR_NM       /* 협력사명      */
                            , "PARAM_CUS_TYPE"    : "2"                 /* 발행구분      */
                            , "PARAM_CUS_T_NM"    : "PDA발주"           /* 발행구분명    */
                            , "PARAM_FLAG"        : "1"                 /* 처리상태      */
                            , "PARAM_FLAG_NM"     : "발주예정"          /* 처리상태명    */
                            , "PARAM_ROWNUM"      : 1                   /* 최저가로 가져오려면 2, else 999999 */
                            , "PARAM_CUST_DIV_CD" : cmv_call_nm         /* B01물류센타로의 주문, A06신선팜으로주문, OUT외부공급사  */
                            , "PARAM_CHANNEL"     : param               /* load체널 1PDA, 2착지변경 */
                            , "PARAM_CHG_WARE_CD" : scrin_SEND_WARE_CD  /* 착지변경 배송직영조직 */
                        }
            ,method   : "POST"
            ,dataType : "JSON"
            ,success  : function(data){
                erpRightLayout.progressOff();
                if(data.isError){
                    $erp.ajaxErrorMessage(data);
                } else {
                    $erp.clearDhtmlXGrid(erpRightGrid); //기존데이터 삭제
                    $erp.clearDhtmlXGrid(erpBackGrid);  //기존데이터 삭제
                    
                    var gridDataList = data.gridDataList;
                    if($erp.isEmpty(gridDataList)){
                        $erp.addDhtmlXGridNoDataPrintRow(
                            erpBackGrid, '<spring:message code="grid.noSearchData" />'
                        );
                    } else {
                        /*********************************************************************************************************************/
                        /* 대상을 가져와서 입력영역으로 옮길때 DataProcess CUD => C    발주할 DataProcess의 CUD상태를 일괄 C로 처리한다.     */
                        /**********************************************************************************************************************/	
                        erpBackGrid.parse(gridDataList, 'js');	
                        CurrentRow = 1;
                        ObjectToEditBuffer("new");		
                        //erpRightGrid.selectRowById(1);   
                    }
                }
                //$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
                
            }, error : function(jqXHR, textStatus, errorThrown){
                erpRightLayout.progressOff();
                $erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
            }
        });
    }
		
		
	/****************************************************************************/
    /* 발주요청서에서 주문서 쪽으로 Insert                                      */
    /****************************************************************************/	
	function insertSelectPurordandGoodsConfirm(){

		if(!isCheckedValidate()) { return false; }
		
		var alertCode = "";
		var alertType = "alert";
		var callbackFunction = function(){
			insertSelectPurordandGoods();
		}
		
		$erp.confirmMessage({
			  "alertMessage" : "정말 주문확정 하시겠습니까?"
			, "alertCode" : alertCode
			, "alertType" : alertType
			, "alertCallbackFn" : callbackFunction
		});
		
	}	
	
	/****************************************************************************/
    /* 발주요청서 Insert Confirm                                                */
    /****************************************************************************/	
	function insertPurordandGoodsConfirm(){

		var erpRightGridRowCount = erpRightGrid.getRowsNum();
		var ll_cnt = 0;
		
		if ( erpRightGridRowCount <= 0 ) {
			$erp.alertMessage({
				"alertMessage" : "임시저장할 Data가 존재하지 않습니다.",
				"alertCode" : null,
				"alertType" : "error",
				"isAjax" : false,
			});
			return;
		}
		
		for(var i = 0; i < erpRightGridRowCount; i++){
			var rId    = erpRightGrid.getRowId(i);
			var Status = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("FLAG")).getValue();
		    console.log(" ll_cnt ==> " + ll_cnt);
			if( Status == "1"){
			    ll_cnt = ll_cnt + 1;
			}
		}
		
		if(ll_cnt == 0){
			$erp.alertMessage({
				"alertMessage" : "임시저장할 발주예정건이 존재하지 않습니다.",
				"alertCode" : null,
				"alertType" : "error",
				"isAjax" : false
			});
			return false;
		}
		
		var alertCode = "";
		var alertType = "alert";
		var callbackFunction = function(){
	    	save_ErpRightGrid();
		}
		
		$erp.confirmMessage({
			  "alertMessage" : "<br>미입력 수량 및 발주완료건은 저장되지 않습니다.<br/> 정말 임시저장 하시겠습니까?"
			, "alertCode" : alertCode
			, "alertType" : alertType
			, "alertCallbackFn" : callbackFunction
		});
		
	}		
		
	/****************************************************************************/
    /* 그리드 선택 유효성 검증                                                  */
    /****************************************************************************/	
	function isCheckedValidate(){

		var isValidated = true;
		var gridRowCount = erpRightGrid.getRowsNum();
		var isChecked = false;
		var ll_cnt = 0;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId    = erpRightGrid.getRowId(i);
			var check  = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("CHECK")).getValue();
			var Status = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("FLAG")).getValue();
			//var crud   = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("CRUD")).getValue();
			
			if(check == "1"){
				deleteRowIdArray.push(rId);
				if(Status == "1"){
					   ll_cnt = ll_cnt + 1;
				}
			}
		}
		
		if(ll_cnt ==  0){
			$erp.alertMessage({
				"alertMessage" : "대상 선택을 하지않았거나 발주완료할 발주예정건이 없습니다.",
				"alertCode" : null,
				"alertType" : "error",
				"isAjax" : false
			});
			return false;
		}
		
		if(deleteRowIdArray.length == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode"  : null
				, "alertType"  : "error"
			});
			return false;
		}
		
		return isValidated;
	}
	
	/****************************************************************************/
    /* 발주요청서에서 주문서 쪽으로 Insert                                      */
    /****************************************************************************/	
	function insertSelectPurordandGoods(){		
	    console.log("===========insertSelectPurordandGoods1===============");
	    $erp.clearDhtmlXGrid(erpBackGrid); //기존데이터 삭제
	    
		$erp.copyRowsGridToGrid(erpRightGrid, erpBackGrid, 
			      [ "NO"              ,     "REQ_DATE"        ,       "ORD_NO"          ,       "ORD_SEQ"         ,       "ORD_TYPE"        ,    "ORD_TYPE_NM"     ,
			        "REQ_CUSTMR_CD"   ,     "CUST_NM"         ,       "SUPR_CUSTMR_CD"  ,       "SUPR_NM"         ,       "BCD_CD"          ,    "WARE_CD"         ,
			        "TAX_TYPE"        ,     "DIMEN_NM"        ,       "UNIT_QTY"        ,       "STOCK_QTY"       ,       "REQ_QTY"         ,    "GOODS_PRICE"     ,
			        "SUPR_AMT"        ,     "VAT_AMT"         ,       "TOT_AMT"         ,       "RESV_DATE"       ,       "LAND_CHG_TYPE"   ,    "MEMO"            ,
			        "ORD_CUSTMR_TYPE" ,     "RESP_USER"       ,       "FLAG"            ,       "ORGN_DIV_CD"     ,       "ORGN_CD"         ,    "CHG_WARE_CD"     ,
			        "CHG_WARE_NM"     ,     "ORI_ORD_NO"      ],
			      [ "NO"              ,     "REQ_DATE"        ,       "ORD_NO"          ,       "ORD_SEQ"         ,       "ORD_TYPE"        ,    "ORD_TYPE_NM"     ,
			        "REQ_CUSTMR_CD"   ,     "CUST_NM"         ,       "SUPR_CUSTMR_CD"  ,       "SUPR_NM"         ,       "BCD_CD"          ,    "WARE_CD"         ,
			        "TAX_TYPE"        ,     "DIMEN_NM"        ,       "UNIT_QTY"        ,       "STOCK_QTY"       ,       "REQ_QTY"         ,    "GOODS_PRICE"     ,
			        "SUPR_AMT"        ,     "VAT_AMT"         ,       "TOT_AMT"         ,       "RESV_DATE"       ,       "LAND_CHG_TYPE"   ,    "MEMO"            ,
			        "ORD_CUSTMR_TYPE" ,     "RESP_USER"       ,       "FLAG"            ,       "ORGN_DIV_CD"     ,       "ORGN_CD"         ,    "CHG_WARE_CD"     ,
			        "CHG_WARE_NM"     ,     "ORI_ORD_NO"      ],
			        "checked", "new", [], [],{}, {}, insertSelectPurordandGoods_callback, false );
	    console.log("===========insertSelectPurordandGoods===============");
		
	}

	/****************************************************************************/
    /* 대상을 가져와서 입력영역으로 옮길때 DataProcess CUD => C                 */
    /****************************************************************************/	
	function ObjectToEditBuffer(type){		
	    //var gridRowCount = erpBackGrid.getRowsNum();
	    erpBackGrid.checkAll(true);
	    
	    //console.log("===========insertSelectPurordandGoods3 gridRowCount=> " + gridRowCount );
		$erp.copyRowsGridToGrid(erpBackGrid, erpRightGrid, 
			      [ "OBJKEY"       ,  "CHECK"           ,   "REQ_DATE"     ,   "ORD_NO"          ,   "ORD_SEQ"            ,   "ORD_TYPE"   ,
			    	"ORD_TYPE_NM"  ,  "REQ_CUSTMR_CD"   ,   "CUST_NM"      ,   "SUPR_CUSTMR_CD"  ,   "SUPR_NM"            ,   "BCD_CD"     ,
			    	"BCD_NM"       ,  "WARE_CD"         ,   "WARE_NM"      ,   "TAX_TYPE"        ,   "DIMEN_NM"           ,   "UNIT_QTY"   ,
			        "STOCK_QTY"    ,  "REQ_QTY"         ,   "GOODS_PRICE"  ,   "SUPR_AMT"        ,   "VAT_AMT"            ,   "TOT_AMT"    ,
			        "RESV_DATE"    ,  "LAND_CHG_TYPE"   ,   "MEMO"         ,   "ORD_CUSTMR_TYPE" ,   "ORD_CUSTMR_TYPE_NM" ,   "RESP_USER"  , 
			        "EMP_NM"       ,  "FLAG"            ,   "FLAG_NM"      ,   "ORGN_DIV_CD"     ,   "ORGN_CD"             ,  "UNIT_NM"    ,
			        "CHG_WARE_CD"  ,  "CHG_WARE_NM"     ,   "ORI_ORD_NO"],
			      [ "OBJKEY"       ,  "CHECK"           ,   "REQ_DATE"     ,   "ORD_NO"          ,   "ORD_SEQ"             ,  "ORD_TYPE"   ,
			    	"ORD_TYPE_NM"  ,  "REQ_CUSTMR_CD"   ,   "CUST_NM"      ,   "SUPR_CUSTMR_CD"  ,   "SUPR_NM"             ,  "BCD_CD"     ,
			    	"BCD_NM"       ,  "WARE_CD"         ,   "WARE_NM"      ,   "TAX_TYPE"        ,   "DIMEN_NM"            ,  "UNIT_QTY"   ,
			        "STOCK_QTY"    ,  "REQ_QTY"         ,   "GOODS_PRICE"  ,   "SUPR_AMT"        ,   "VAT_AMT"             ,  "TOT_AMT"    ,
			        "RESV_DATE"    ,  "LAND_CHG_TYPE"   ,   "MEMO"         ,   "ORD_CUSTMR_TYPE" ,   "ORD_CUSTMR_TYPE_NM"  ,  "RESP_USER"  , 
			        "EMP_NM"       ,  "FLAG"            ,   "FLAG_NM"      ,   "ORGN_DIV_CD"     ,   "ORGN_CD"             ,  "UNIT_NM"    ,
			        "CHG_WARE_CD"  ,  "CHG_WARE_NM"     ,   "ORI_ORD_NO"],
			      "checked", type, [], [],{}, {}, callback_lastProdedure, false );
	    console.log("===========insertSelectPurordandGoods4===============");

	}
	
	/****************************************************************************/
    /* 합계금액 및 커서위치                                                     */
    /****************************************************************************/	
	function callback_lastProdedure() {

    	erpRightGrid.selectRowById(CurrentRow);   
		$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
    	
    }

	/****************************************************************************/
    /* 주문서요청( T_REQ_GOODS_TMP -> T_PUR_ORD, T_PUR_ORD_GOODS)로  Insert     */
    /****************************************************************************/	
	function insertSelectPurordandGoods_callback() {
	    var gridRowCount = erpBackGrid.getRowsNum();

	    /*  발주완료시 화면의 입고예정일을 적용한다 */
		var scrin_RESV_DATE = document.getElementById("txtRESV_DATE").value;
		scrin_RESV_DATE     = scrin_RESV_DATE.replace (/-/g, "")
		if($('#Select_RESV_DATE').is(":checked") == true)  {
			document.getElementById("txtORD_RESV_DATE").value = scrin_RESV_DATE;
		}
		else {
			document.getElementById("txtORD_RESV_DATE").value = "";
		}
		

 	    var HEAD = $erp.dataSerialize("aaa");
	    console.log(HEAD);
		
		var BODY = $erp.dataSerializeOfGridByMode(erpBackGrid,"all");  
		console.log(BODY);
		
		var url = "/sis/order/OrderRequestSelectInsert.do";
		
		var send_data = { "HEAD":HEAD, "BODY":BODY}; 
		
		var if_success = function(data){
			if($erp.isEmpty(data.result)){
				$erp.alertSuccessMesage(onAfterSaveErpRightGrid);
			}else{
				if(data.result == BODY.length){
					$erp.alertSuccessMesage(onAfterSaveErpRightGrid);
					console.log("성공");
				}
			}
		}
		
		var if_error = function(data){
			$erp.ajaxErrorMessage(data);
		}
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
		
	}
	
	/****************************************************************************/
    /* erpRightGrid 초기화                                                      */
    /****************************************************************************/	
	function initErpRightGrid(){
		erpRightGridColumns = [
			      {id : "NO"                   , label:["NO"                , "#rspan"]      ,   type: "cntr", width:  "30", sort : "int", align : "right",  isHidden : false, isEssential : false}
				, {id : "CHECK"                , label:["#master_checkbox"  , "#rspan"]      ,   type: "ch"  , width:  "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
				, {id : "REQ_DATE"             , label:["요청일자"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : true}			
				, {id : "ORD_NO"               , label:["발주번호"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : true  , isEssential : true}
		   	    , {id : "ORD_SEQ"              , label:["일련번호"          , "#text_filter"],   type: "ron" , width:  "60", sort : "int", align : "right",  isHidden : true  , isEssential : true}
				, {id : "ORD_TYPE"             , label:["발주유형"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : true ,  isEssential : true, commonCode : "ORD_TYPE"}			
				, {id : "ORD_TYPE_NM"          , label:["발주유형"          , "#select_filter"], type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "FLAG_NM"              , label:["주문상태"          , "#select_filter"], type: "ro"  , width: "70",  sort : "str", align : "center", isHidden : false,  isEssential : true}
				, {id : "REQ_CUSTMR_CD"        , label:["고객사CD"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true ,  isEssential : true}			
				, {id : "CUST_NM"              , label:["고객사명"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true ,  isEssential : false}			
				, {id : "SUPR_CUSTMR_CD"       , label:["협력사코드"        , "#text_filter"],   type: "ro"  , width:  "80", sort : "str", align : "left",   isHidden : true  , isEssential : true}
				, {id : "SUPR_NM"              , label:["협력사명"          , "#select_filter"], type: "ed"  , width: "120", sort : "str", align : "left",   isHidden : false , isEssential : false}

				/* ROW INDEX 11 ~ 20 */
				, {id : "BCD_CD"               , label:["바코드"            , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "BCD_NM"               , label:["상품명"            , "#text_filter"],   type: "ed"  , width: "230", sort : "str", align : "left",   isHidden : false, isEssential : false}			
				, {id : "WARE_CD"              , label:["창고코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false , isEssential : true}
				, {id : "WARE_NM"              , label:["창고"              , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false , isEssential : false}
				, {id : "CHG_WARE_NM"          , label:["배송처"            , "#select_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false ,  isEssential : false}
				, {id : "TAX_TYPE"             , label:["과세여부"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : false, isEssential : false}
				, {id : "DIMEN_NM"             , label:["규격"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "UNIT_QTY"             , label:["입수량"            , "#text_filter"],   type: "ron" , width:  "50", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "STOCK_QTY"            , label:["전산재고"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "REQ_QTY"              , label:["수량"              , "#text_filter"],   type: "edn" , width:  "60", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "UNIT_NM"              , label:["단위"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			

				/* ROW INDEX 21 ~ 30 */
				, {id : "GOODS_PRICE"          , label:["단가"              , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}			
				, {id : "SUPR_AMT"             , label:["공급가액"          , "#text_filter"],   type: "ron" , width:  "80", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"              , label:["부가세"            , "#text_filter"],   type: "ron" , width:  "80", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"              , label:["합계금액"          , "#text_filter"],   type: "ron" , width:  "80", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "RESV_DATE"            , label:["납기예정일"        , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}			
				, {id : "LAND_CHG_TYPE"        , label:["착지변경"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}			
				, {id : "MEMO"                 , label:["적요"              , "#text_filter"],   type: "ed"  , width: "200", sort : "str", align : "left",   isHidden : false,  isEssential : false}
				//, {id : "DSCD_TYPE"          , label:["반품가능"          , "#text_filter"],   type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : false, isEssential : true}			
				//, {id : "RESN_CD"            , label:["반품사유코드"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_CUSTMR_TYPE"      , label:["발행구분"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,    isEssential : false}
				, {id : "ORD_CUSTMR_TYPE_NM"   , label:["발행구분"          , "#select_filter"], type: "ro"  , width: "80" , sort : "str", align : "left",   isHidden : false,    isEssential : false}
				, {id : "RESP_USER"            , label:["처리자"            , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true  , isEssential : true}

				/* ROW INDEX 31  */
				, {id : "EMP_NM"               , label:["요청자"            , "#select_filter"], type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false , isEssential : false}
				, {id : "FLAG"                 , label:["발주상태"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,    isEssential : false}
				//, {id : "MIN_ORGN_CD"          , label:["최저매입매장"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				//, {id : "MIN_ORGN_NM"          , label:["최저매입매장"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				//, {id : "MIN_PUR_DATE"         , label:["최저매입일자"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				//, {id : "MIN_PUR_PRICE"        , label:["최저매입단가"      , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false,  isEssential : false,  numberFormat : "0,000"}
				//, {id : "MIN_PUR_CUSTMR_NM"    , label:["최저매입업체"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}
				
				, {id : "ORGN_DIV_CD"          , label:["조직유형"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}			
				, {id : "ORGN_CD"              , label:["조직코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}			
				, {id : "OBJKEY"               , label:["BCD+공급사CD"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "MIN_LMT_QTY"          , label:["주문제한수량"      , "#text_filter"],   type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}
				, {id : "CHG_WARE_CD"          , label:["배송지"            , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "ORI_ORD_NO"           , label:["원주문서NO"        , "#text_filter"],   type: "ro"  , width: "150", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
		];
		
		erpRightGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpRightGridColumns
		});		
		
		/* 마우스 한번 클릭으로  편집가능 */
		//erpRightGrid.enableLightMouseNavigation(true);
		
		//erpRightGrid.enableDistributedParsing(true, 100, 24);
		$erp.attachDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);
		erpRightGridDataProcessor =$erp.initGrid(erpRightGrid);
		$erp.initGridDataColumns(erpRightGrid);
		
		/* onCellChanged onEditCell */ 
		erpRightGrid.attachEvent("onEditCell", function(stage,rId,cInd,nValue,oValue) {
            console.log( "cInd  =>" + cInd );
			if ( stage == "2" && cInd == 21 ) {
			    var rowIdName =  erpRightGrid.getRowId(cInd);
			    
			    var ll_REQ_QTY     = Number(erpRightGrid.cells(rId, erpRightGrid.getColIndexById("REQ_QTY")).getValue());
			    var ll_GOODS_PRICE = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("GOODS_PRICE" )).getValue();
			    var ll_TAX_TYPE    = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("TAX_TYPE"    )).getValue();
			    
			    var MIN_LMT_QTY    = Number(erpRightGrid.cells(rId, erpRightGrid.getColIndexById("MIN_LMT_QTY" )).getValue());
			    var ll_UNIT_NM     = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("UNIT_NM"    )).getValue();
			    var ll_con_qty     = 0;
			    
			    /* 중량상품이면  100g으로 환산  */
			    if  ( ll_UNIT_NM == "g") {
			    	ll_con_qty = 	ll_REQ_QTY / 100;
			    } else {
			    	ll_con_qty = 	ll_REQ_QTY;
			    }
			    
			    /* 공통ORGN_CD2에  발주한도 체크여부를 체크토록 설정이 되어있으면 발주수량, 한도, 제한수량을 체크한다.*/
			    if  ( GLOVAL_LMT_CNTROL_YN == "Y") {

			    	console.log(" GLOVAL_LMT_CNTROL_YN  => " +  GLOVAL_LMT_CNTROL_YN);
			    	console.log(" REQ_QTY   => " +  ll_REQ_QTY + " MIN_LMT_QTY   => " + MIN_LMT_QTY);
			    	
			    	/* MOQ수량이하이면  경고  */
			    	if  ( ll_REQ_QTY > 0 )  {
	                    if  ( ll_REQ_QTY < MIN_LMT_QTY ) {
				    	     console.log(" 주문수량 < MOQ수량이하 "  );
				    		 validationNotifyConfirm(rId,  $erp.convertToMoney(MIN_LMT_QTY));
				    		 return true;
	                    }
			    	}
			    }
			    
			    /*  공급가액( 단가에 VAT포함 됨 ) */
			    var ll_TOT_AMT  = ll_con_qty  *  ll_GOODS_PRICE;
			    var ll_SUPR_AMT = 0;
			    var ll_VAT      = 0;
			    if  ( ll_TAX_TYPE == "Y") {
			    	ll_SUPR_AMT       = Math.round(ll_TOT_AMT / 1.1 );
			    	ll_VAT            = ll_TOT_AMT  - ll_SUPR_AMT;
			    }  else {
			    	ll_SUPR_AMT       = ll_TOT_AMT;
			    }

			    console.log( "ll_TOT_AMT =>"+ ll_TOT_AMT + " ll_SUPR_AMT : " + ll_SUPR_AMT + " ll_VAT : " + ll_VAT);
			    
			    erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUPR_AMT"   )).setValue(ll_SUPR_AMT);
				erpRightGrid.cells(rId, erpRightGrid.getColIndexById("VAT_AMT"    )).setValue(ll_VAT);
				erpRightGrid.cells(rId, erpRightGrid.getColIndexById("TOT_AMT"    )).setValue(ll_TOT_AMT);

			    ll_SUPR_AMT   = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUPR_AMT"   )).getValue();
			    ll_VAT        = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("VAT_AMT"    )).getValue();
			    console.log( " ll_SUPR_AMT : " + ll_SUPR_AMT + " ll_VAT : " + ll_VAT);
			    
				$erp.setDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);
			    return true;
			}
		    return true;
		});				
		
		/* onRowDblClicked  */ 
		erpRightGrid.attachEvent("onRowDblClicked", function(rId,cInd) {

			if ( cInd == 13) {
				GoodsPricePopup_TO_ErpRightGrid();			
			}

		    return true;
		    
		});				
		
	}

	/****************************************************************************/
    /* 발주요청서에서 주문서 쪽으로 Insert                                      */
    /****************************************************************************/	
	function validationNotifyConfirm( rId, ord_unit ){

		var ll_cnt = 0;
		var ls_message = "주문 수량이 MOQ ("+  ord_unit  + ") 미만입니다.";
	    
		var callbackFunction = function(){
			
		    erpRightGrid.cells(rId, erpRightGrid.getColIndexById("REQ_QTY"  )).setValue(null);
		    erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUPR_AMT" )).setValue(null);
			erpRightGrid.cells(rId, erpRightGrid.getColIndexById("VAT_AMT"  )).setValue(null);
			erpRightGrid.cells(rId, erpRightGrid.getColIndexById("TOT_AMT"  )).setValue(null);
			 
			$erp.setDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);
		}	    
		
		$erp.alertMessage({
			"alertMessage"    : ls_message,
			"alertCode"       : null,
			"alertType"       : "error",
			"isAjax"          : false,
			"alertCallbackFn" : callbackFunction
		});

		return false;	 
		
	}			
	
	/****************************************************************************/
    /* erpBackGrid 초기화                                                      */
    /****************************************************************************/	
	function initErpBackGrid(){
		erpBackGridColumns = [
              {id : "NO"                   , label:["NO"                , "#rspan"]      ,   type: "cntr", width:  "30", sort : "int", align : "right",  isHidden : false, isEssential : false}
            , {id : "CHECK"                , label:["#master_checkbox"  , "#rspan"]      ,   type: "ch"  , width:  "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
            , {id : "REQ_DATE"             , label:["요청일자"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : true}
            , {id : "ORD_NO"               , label:["발주번호"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : false , isEssential : true}
            , {id : "ORD_SEQ"              , label:["일련번호"          , "#text_filter"],   type: "ron" , width:  "60", sort : "int", align : "right",  isHidden : false , isEssential : true}
            , {id : "ORD_TYPE"             , label:["발주유형"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : false,  isEssential : true, commonCode : "ORD_TYPE"}
            , {id : "ORD_TYPE_NM"          , label:["발주유형"          , "#select_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false, isEssential : false}
            , {id : "REQ_CUSTMR_CD"        , label:["고객사CD"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false,  isEssential : true}
            , {id : "CUST_NM"              , label:["고객사명"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false,  isEssential : false}
            , {id : "SUPR_CUSTMR_CD"       , label:["협력사코드"        , "#text_filter"],   type: "ro"  , width:  "80", sort : "str", align : "left",   isHidden : false , isEssential : true}
            , {id : "SUPR_NM"              , label:["협력사명"          , "#select_filter"], type: "ed"  , width: "120", sort : "str", align : "left",   isHidden : false , isEssential : false}

            /* ROW INDEX 11 ~ 20 */
            , {id : "BCD_CD"               , label:["바코드"            , "#text_filter"],   type: "ro"  , width:  "80", sort : "str", align : "center", isHidden : false, isEssential : true}
            , {id : "BCD_NM"               , label:["상품명"            , "#text_filter"],   type: "ed"  , width: "230", sort : "str", align : "left",   isHidden : false, isEssential : false}
            , {id : "WARE_CD"              , label:["창고코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
            , {id : "WARE_NM"              , label:["창고"              , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false, isEssential : false}
			, {id : "CHG_WARE_NM"          , label:["배송처"            , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false ,  isEssential : false}
            , {id : "TAX_TYPE"             , label:["부가세"            , "#text_filter"],   type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : false, isEssential : false}
            , {id : "DIMEN_NM"             , label:["규격"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}
            , {id : "UNIT_NM"              , label:["단위"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}
            , {id : "UNIT_QTY"             , label:["입수량"            , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}
            , {id : "STOCK_QTY"            , label:["전산재고"          , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}
            , {id : "REQ_QTY"              , label:["수량"              , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}

            /* ROW INDEX 21 ~ 30 */
            , {id : "GOODS_PRICE"          , label:["단가"              , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
            , {id : "SUPR_AMT"             , label:["공급가액"          , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
            , {id : "VAT_AMT"              , label:["부가세"            , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
            , {id : "TOT_AMT"              , label:["합계금액"          , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
            , {id : "RESV_DATE"            , label:["납기예정일"        , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false,  isEssential : false}
            , {id : "LAND_CHG_TYPE"        , label:["착지변경"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}
            , {id : "MEMO"                 , label:["적요"              , "#text_filter"],   type: "ed"  , width: "200", sort : "str", align : "right",  isHidden : false,  isEssential : false}
            //, {id : "DSCD_TYPE"          , label:["반품가능"          , "#text_filter"],   type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : false, isEssential : true}
            //, {id : "RESN_CD"            , label:["반품사유코드"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
            , {id : "ORD_CUSTMR_TYPE"      , label:["발행구분"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,    isEssential : false}
            , {id : "ORD_CUSTMR_TYPE_NM"   , label:["발행구분"          , "#select_filter"], type: "ro"  , width: "80" , sort : "str", align : "left",   isHidden : false,    isEssential : false}
            , {id : "RESP_USER"            , label:["처리자"            , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false , isEssential : true}

            /* ROW INDEX 31  */
            , {id : "EMP_NM"               , label:["요청자"            , "#select_filter"], type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false , isEssential : false}
            , {id : "FLAG"                 , label:["발주상태"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true  , isEssential : false}
            , {id : "FLAG_NM"              , label:["발주상태"          , "#select_filter"], type: "ro"  , width: "80",  sort : "str", align : "center", isHidden : false , isEssential : true}
            //, {id : "MIN_ORGN_CD"          , label:["최저매입매장"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}
            //, {id : "MIN_ORGN_NM"          , label:["최저매입매장"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}
            //, {id : "MIN_PUR_DATE"         , label:["최저매입일자"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}
            //, {id : "MIN_PUR_PRICE"        , label:["최저매입단가"      , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false,  isEssential : false,  numberFormat : "0,000"}
            //, {id : "MIN_PUR_CUSTMR_NM"    , label:["최저매입업체"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}

            , {id : "ORGN_DIV_CD"          , label:["조직유형"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}
            , {id : "ORGN_CD"              , label:["조직코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}
            , {id : "OBJKEY"               , label:["BCD+공급사CD"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
			, {id : "MIN_LMT_QTY"          , label:["주문제한수량"      , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
			, {id : "CHG_WARE_CD"          , label:["배송지"            , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
			, {id : "ORI_ORD_NO"           , label:["원주문서NO"        , "#text_filter"],   type: "ro"  , width: "150", sort : "str", align : "left",   isHidden : false ,  isEssential : false}
		];
		
		erpBackGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpBackGridColumns
		});			
		$erp.initGrid(erpBackGrid);
	}
	
	/****************************************************************************/
    /* 협력사명 선택 팝업호출                                                   */
    /****************************************************************************/	
	function openSearchCustmrGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "1";           // 협력사(매입처) :1,  고객사(매출처): 2
		var CURR_CUSTMR_CD  = "";
		
		var onRowSelect = function(id, ind) {
			CURR_CUSTMR_CD                              = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("hidSurp_CD").value = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("Surp_Name").value  = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();

			if(CURR_CUSTMR_CD == ""){
				document.getElementById("Select_Surp_CD").checked = false;
			} else
			{
				document.getElementById("Select_Surp_CD").checked = true;
			}
			
			$erp.closePopup2("openSearchCustmrGridPopup");
			if ( CURR_CUSTMR_CD != GLOVAL_SUPR_CD) {
			    GLOVAL_SUPR_CD = CURR_CUSTMR_CD;
				searchErpLeftTree();
				Surp_Name_change(GLOVAL_SUPR_CD);
			}
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	/****************************************************************************/
    /* 담당자 선택 팝업호출                                                     */
    /****************************************************************************/	
	function openSearchComEmpNoGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var onRowSelect = function(id, ind) {
			document.getElementById("txtRESP_USER").value = this.cells(id, this.getColIndexById("EMP_NO")).getValue();
			document.getElementById("RESP_USER_NAME").value = this.cells(id, this.getColIndexById("EMP_NM")).getValue();
			
			$erp.closePopup();
		}
		$erp.searchComEmpNoPopup(onRowSelect);
		
	}
		
	/***************************************************/
	/* 그리드 조회                                     */
	/***************************************************/
	function search_ErpRightGrid(){

		erpRightLayout.progressOn();
		
		var scrin_ORD_DATE  = document.getElementById("txtORD_DATE").value;
		var scrin_SUPR_CD   = "";
		var scrin_CUST_CD   = document.getElementById("txtCUST_CD").value;    /* 고객사 */
		var scrin_RESP_CD   = "";
		
		var scrin_ORD_STATE = cmbORD_STATE.getSelectedValue();
		var scrin_ORD_TYPE  = cmbORD_TYPE_CD.getSelectedValue();
		var scrin_MKT_TYPE  = cmbMKT_TYPE_CD.getSelectedValue();
		var scrin_ORGN_CD   = cmbCUST_NAME.getSelectedValue();   //※  로그인 조직인 본사이면 본사발주인데 이때 고객사조직(센터조직)으로 설정한다

		/**************************************************************/
		/* 2020-01-23  ※ 아주 중요 본사조직이거나  조직코득 없는 경우 */
		/**************************************************************/
		if ( GLOVAL_ORGN_CD = "000000") {
			GLOVAL_ORGN_CD = scrin_ORGN_CD;
		}
		
		if($('#Select_Surp_CD').is(":checked") == true)  {
			scrin_SUPR_CD   = document.getElementById("hidSurp_CD").value;    /* 협력사 */
		} 		
		
		if($('#Select_RESP_USER').is(":checked") == true)  {
			scrin_RESP_CD   = document.getElementById("txtRESP_USER").value;  /* 담당자 */
		} 		
		scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")
		
		console.log(" LOGIN_ORGN_DIV_TYP =>" + LOGIN_ORGN_DIV_TYP + " scrin_ORD_DATE=> " + scrin_ORD_DATE + " scrin_ORD_DATE=> " + scrin_ORD_DATE );
		console.log(" scrin_MKT_TYPE =>" + scrin_MKT_TYPE + " scrin_CUST_CD => " + scrin_CUST_CD);

		$.ajax({
			 url  : "/sis/order/orderRequestSearch.do"
			,data : {
			 	         "PARAM_CUST_DIV_TYP"   : LOGIN_ORGN_DIV_TYP
				       , "PARAM_REQ_DATE"       : scrin_ORD_DATE
				       , "PARAM_REQ_CUSTMR_CD"  : LOGIN_CUSTMR_CD    /* 고객사 scrin_CUST_CD에서 LOGIN_CUSTMR_CD로 수정  2020-01-23   */
				       , "PARAM_SUPR_CUSTMR_CD" : scrin_SUPR_CD      /* 협력사   */
				       , "PARAM_RESP_USER"      : scrin_RESP_CD      /* 담당자(취급점은 표시하지 않는다) */ 
				       , "PARAM_FLAG"           : scrin_ORD_STATE
				       , "PARAM_ORD_TYPE"       : scrin_ORD_TYPE     /* 1 물류,  2직납, 3신선 */
				       , "PARAM_MKT_TYPE"       : scrin_MKT_TYPE     /* 1.PC,  2.PDA */
				       , "PARAM_ORD_PATH"       : "CT"               /* 경로 1센터, 2직영점, 3포털발주, 6긴급발주 */
				       , "PARAM_ORGN_CD"        : GLOVAL_ORGN_CD     /* 로그인 조직 */
			}
			
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpRightGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpRightGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpRightGrid.parse(gridDataList, 'js');	
						erpRightGrid.selectRowById(1);
						$erp.setDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);
        				//getOrderDeadTimeLeadTime(scrn_CUSTMR_CD, 2);   /* 마감시간 이전이면 1 이후이면 2 */
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
	/* 주문서 저장  C,U,D                                    */
	/*********************************************************/
	function save_ErpRightGrid(){
		
		var HEAD = $erp.dataSerialize("aaa");
		console.log(HEAD);
		var BODY = $erp.dataSerializeOfGridByMode(erpRightGrid,"all");   // all(전체)  state( CUD 변경부문만 처리) 
		console.log(BODY);
		
		var url = "/sis/order/OrderRequestCUD.do";
		
		var send_data = {"HEAD":HEAD, "BODY":BODY};   /*  LIST MAP구조로 Controller로 넘긴다 */
		
		var if_success = function(data){
			if($erp.isEmpty(data.result)){
				$erp.alertSuccessMesage(onAfterSaveErpRightGrid);
			}else{
				if(data.result == BODY.length){
					$erp.alertSuccessMesage(onAfterSaveErpRightGrid);
					console.log("성공");
				}
			}
		}
		
		var if_error = function(data){
			$erp.ajaxErrorMessage(data);
		}
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);

	}
	
	/*********************************************************/
	/* 발주상품 저장후 재조회
	/*********************************************************/
	function onAfterSaveErpRightGrid(){
		search_ErpRightGrid();
	}
	
	/****************************************************************************/
    /*  상품 가격팝업창에서 Current로 발주내역에서 복사                         */
    /****************************************************************************/	
	function GoodsPricePopup_TO_ErpRightGrid(){
		
		var onRowDblClicked = function(id) {
			//document.getElementById("ORD_NO").value  = this.cells(id, this.getColIndexById("GOODS_NO")).getValue();
			$erp.closePopup2("openGoodsPricePopup");
		}
		
		var goods_nm     = "";
		var cmv_type_nm  = "";
		var scrin_SUPR_CD = document.getElementById("hidSurp_CD").value;    /* 협력사 */
		cmv_select_cd     = cmbORD_TYPE_CD.getSelectedValue();
		
		if(cmv_select_cd.length == 0){
			$erp.alertMessage({
				"alertMessage" : "발주유형을 선택하세요."
				, "alertCode"  : null
				, "alertType"  : "alert"
				, "isAjax"     : false
			});
			return false;
	    }
		
		if(scrin_SUPR_CD.length == 0){
			$erp.alertMessage({
				"alertMessage" : "협력사를 선택하세요."
				, "alertCode"  : null
				, "alertType"  : "alert"
				, "isAjax"     : false
			});
			return false;
	    }
		
		if   (cmv_select_cd  == "2") { cmv_type_nm = "직납발주" }
		else if  (cmv_select_cd  == "3") { cmv_type_nm = "신선발주" }
		else cmv_type_nm = "";

		var scrin_ORD_DATE = document.getElementById("txtORD_DATE").value;
		scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")
		
		/* ※ 발주요청서  ORD_NO ->  발주일자 + 발주쵸엉거래처 */
		var scrs_ORD_NO    = scrin_ORD_DATE + "_" + LOGIN_CUSTMR_CD;  

		var onClickAddData = function(erpPopupGrid) {
			
			var check = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK"));

			console.log(check);
			
			var checkList = check.split(',');
			var last_list_num = checkList.length - 1;
			var curr_row_id = 0;
			

			$erp.clearDhtmlXGrid(erpBackGrid);
			var erpBackGridRowCount  = erpBackGrid.getRowsNum();
            //console.log("======erpBackGridRowCount========" + erpBackGridRowCount);

            erpRightLayout.progressOn();
			
			for(var i = 0 ; i < checkList.length ; i ++) {
				if(i != checkList.length ) {
					
					curr_row_id++;
					erpBackGrid.addRow(curr_row_id);			
					
					var BCD_CD          = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("BCD_CD")).getValue();
					var BCD_NM          = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("BCD_NM")).getValue();
					var SUPR_CD         = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("SUPR_CD")).getValue();
					var SUPR_NM         = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("SUPR_NM")).getValue();
					var TAX_TYPE        = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("TAX_TYPE")).getValue();
					var DIMEN_NM        = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("DIMEN_NM")).getValue();
					var UNIT_QTY        = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("UNIT_QTY")).getValue();
					var GOODS_PRICE     = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("GOODS_PRICE")).getValue();
					var DSCD_TYPE       = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("DSCD_TYPE")).getValue();
                    /* 그리드에서 그리드로 이동시 UNIQUE하기위한 KEY값 */
					var OBJKEY          = BCD_CD + SUPR_CD;
					var UNIT_NM         = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("UNIT_NM")).getValue();
					var MIN_LMT_QTY     = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("MIN_LMT_QTY")).getValue();
					
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("REQ_DATE"      )).setValue(scrin_ORD_DATE);	   /* 요청일자  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_NO"        )).setValue(scrs_ORD_NO);       /* 발주번호  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_TYPE"      )).setValue(cmv_select_cd);	   /* 발주유형  */			
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_TYPE_NM"   )).setValue(cmv_type_nm);	   /* 발주유형  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("REQ_CUSTMR_CD" )).setValue(LOGIN_CUSTMR_CD);   /* 고객사    */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("CUST_NM"       )).setValue(LOGIN_CUSTMR_NM);   /* 고객사명  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("SUPR_CUSTMR_CD")).setValue(SUPR_CD);           /* 협력사cd  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("SUPR_NM"       )).setValue(SUPR_NM);           /* 협력사명  */

					/* ROW INDEX 11 ~ 20 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("BCD_CD"        )).setValue(BCD_CD);            /* 바코드 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("BCD_NM"        )).setValue(BCD_NM);            /* 상품명 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("WARE_CD"       )).setValue(LOGIN_ORGN_CD);     /* 창고코드 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("WARE_NM"       )).setValue(LOGIN_ORGN_NM);     /* 창고 */
					
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("TAX_TYPE"      )).setValue(TAX_TYPE);          /* 부가세 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("DIMEN_NM"      )).setValue(DIMEN_NM);          /* 규격 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("UNIT_QTY"      )).setValue(UNIT_QTY);          /* 입수량 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("GOODS_PRICE"   )).setValue(GOODS_PRICE);       /* 단가 */
					
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("UNIT_NM"       )).setValue(UNIT_NM);           /* 단위 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("MIN_LMT_QTY"  )).setValue(MIN_LMT_QTY);        /* 주문제한수량 */

					/* ROW INDEX 21 ~ 30 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_CUSTMR_TYPE"   )).setValue("1");            /* 발행구분 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_CUSTMR_TYPE_NM")).setValue("PC주문");       /* 발행구분 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("RESP_USER"         )).setValue(LOGIN_EMP_NO);   /* 처리자 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("EMP_NM"            )).setValue(LOGIN_EMP_NM);   /* 요청자 */

					/* ROW INDEX 31 ~   */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("FLAG"             )).setValue("1");                 /* 발주상태 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("FLAG_NM"          )).setValue("발주예정");          /* 발주상태 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORGN_DIV_CD"      )).setValue(LOGIN_ORGN_DIV_CD);   /* 조직유형 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORGN_CD"          )).setValue(LOGIN_ORGN_CD);       /* 조직코드 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("OBJKEY"           )).setValue(OBJKEY);              /* KEY   */
				}
				
			}
/* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& */			
			if ( curr_row_id > 0) {
				CurrentRow = erpRightGrid.getRowsNum();
            	ObjectToEditBuffer("add");	                
			}

			erpRightLayout.progressOff();
			
			$erp.closePopup2("openGoodsPricePopup");
			
		}
		openGoodsPricePopup(onRowDblClicked, onClickAddData);
	}
	
  	/****************************************************************************/
    /*  팝업에서 선택된 바코드가 존재하는지를 체크한다                          */
    /****************************************************************************/	
	function SameBarcodeChec() {
		
	}
		
  	/****************************************************************************/
    /*  상품가격 팝업조회                                                       */
    /****************************************************************************/	
	openGoodsPricePopup = function(onRowDblClicked, onClickAddData) {

  		var ls_div_cd = "";  /* 발주유형 */
		var scrin_SUPR_CD  = "";
		var scrin_SUPR_NM  = "";
		if($('#Select_Surp_CD').is(":checked") == true)  {
			scrin_SUPR_CD   = document.getElementById("hidSurp_CD").value;    /* 협력사 */
			scrin_SUPR_NM   = document.getElementById("Surp_Name").value;     /* 협력사 */
		} 		
		
  		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window("openGoodsPricePopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
		}
  		
		switch (cmv_select_cd) {
	       case "1" :  ls_div_cd = "B01"; break;    /* 물류발주 */    
	       case "2" :  ls_div_cd = "OUT"; break;    /* 직납발주 */  
	       case "3" :  ls_div_cd = "A06"; break;    /* 신선발주 */   
	       case "4" :  ls_div_cd = "B01"; break;    /* 착지변경 */   
	       case "5" :  ls_div_cd = "B01"; break;    /* 일배발주 */
	       default  :  ls_div_cd = "B01"; break;
	    }
	
  		/*****************************************************************************************************/
  		/* ※ 이부분은 아주중요함  CUST_DIV_CD파라미터는 단가를 가져오는 구분자임                             */ 
  		/* 발주를 요청하는 조직구분(ORGN_DIV_CD : Z01, Z02), 조직코드 : ORGN_CD(거래처ID)                    */ 
  		/* 협력사(공급사) 조직구분( CUST_DIV_CD : B01 이면 센터로발주)                                       */
  		/*****************************************************************************************************/
  		var url    = "/sis/order/openGoodsPricePopup.sis";
		var params = {    "ORGN_DIV_CD"  :  GLOVAL_ORGN_DIV_CD
				        , "ORGN_CD"      :  LOGIN_CUSTMR_CD      /* 고객사 */ 
				        , "CALL_CHANNEL" :  "S"                  /* S영업관리, P cs포털 */ 
				        , "CUST_DIV_CD"  :  ls_div_cd
				        , "CUST_CD"      :  scrin_SUPR_CD        /* 공급사코드 */
				        , "CUST_NM"      :  scrin_SUPR_NM        /* 공급사이름 */
		             }
		
		var option = {
				  "width"  : 1000
				, "height" : 700
				, "win_id" : "openGoodsPricePopup"
		}
		
		var onContentLoaded = function(){
			var popWin = this.getAttachedObject().contentWindow;
	        if(onRowDblClicked && typeof onRowDblClicked === 'function'){
	            while(popWin.erpPopupOrderOnRowSelect == undefined){
	                popWin.erpPopupOrderOnRowSelect = onRowDblClicked;    
	            }
	        }
	        
	        if(onClickAddData && typeof onClickAddData === 'function'){
	        	while(popWin.erpPopupOrderCheckList == undefined){
	        		popWin.erpPopupOrderCheckList = onClickAddData;
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
    /*  기존주문내역에서 복사                                                   */
    /****************************************************************************/	
	function copy_ErpRightGrid(){
		
	    var ls_select_cd    = cmbORD_TYPE_CD.getSelectedValue();
		if ( ls_select_cd == "" ) {
			$erp.alertMessage({
				"alertMessage" : "발주유형을 선택하세요.",
				"alertCode"    : null,
				"alertType"    : "error",
				"isAjax"       : false
			});
			return false;
		}

		var onRowDblClicked = function(id) {
			document.getElementById("ORD_NO").value  = this.cells(id, this.getColIndexById("ORD_NO")).getValue();
			$erp.closePopup2("orderSearchPopup");
		}
		
		var All_checkList = "";
		var Code_List     = "";
		var SUPR_CD       = "";
		var SUPR_NM       = "";
		
		var onClickAddData = function(erpPopupGrid) {
			
			var check = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK")); // 조회된 그리드내역 중 선택한 row 번호 문자열로 넘어옴 ex) 1,5,7,10
			console.log(check);
			
			var checkList = check.split(',');
			var last_list_num = checkList.length - 1;
			var cnt  = 0;
			for(var i = 0 ; i < checkList.length ; i ++) {
				if(i != checkList.length ) {
					cnt = cnt + 1;
					if ( cnt > 1 ) {
						All_checkList += ",";
						Code_List     += ",";
					} 
					All_checkList +=  erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("ORD_NO")).getValue();
					Code_List     +=  erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("ORD_NO")).getValue();
					SUPR_CD       +=  erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("SUPR_CD")).getValue();
					SUPR_NM       +=  erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("SUPR_NM")).getValue();
				} // 주문서LIST에서 선택된 값
			}
			$erp.closePopup2("orderSearchPopup");
			
			console.log("체크된 주문서번호 >> " + Code_List);
			
			if ( Code_List != "") {
				COPYandPASTE(Code_List, SUPR_CD , SUPR_NM);
			}
		}
	    openOrderSearchPopup(onRowDblClicked, onClickAddData);
	}
	
  	/****************************************************************************/
    /*  기존발주LIST 팝업조회                                                   */
    /****************************************************************************/	
	openOrderSearchPopup = function(onRowDblClicked, onClickAddData) {
		var cmv_type_cd  = cmbORD_TYPE_CD.getSelectedValue();

  		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window("orderSearchPopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
		}

		console.log(" GLOVAL_ORGN_DIV_CD =>" + GLOVAL_ORGN_DIV_CD + " GLOVAL_ORGN_CD=> " + GLOVAL_ORGN_CD + " GLOVAL_ORGN_DIV_TYP  => " + GLOVAL_ORGN_DIV_TYP );
		console.log(" SELECT_ORGN_CD    =>" + GLOVAL_ORGN_CD  );
		
        /* ORD_TYPE : 1:발주, 2:주문  */
  		var url    = "/sis/order/orderSearchPopup.sis";
		var params = {    "ORGN_DIV_CD"    : GLOVAL_ORGN_DIV_CD   /* LOGIN_ORGN_DIV_CD  */ 
				        , "ORGN_CD"        : GLOVAL_ORGN_CD
				        , "ORGN_DIV_TYP"   : GLOVAL_ORGN_DIV_TYP
				        , "ORD_TYPE"       : cmv_type_cd          /* 발주유형 */   
					    , "SELECT_ORGN_CD" : GLOVAL_ORGN_CD
				     }
		var option = {
				  "width"  : 1400
				, "height" : 700
				, "win_id" : "orderSearchPopup"
		}
		
		var onContentLoaded = function(){
			var popWin = this.getAttachedObject().contentWindow;
	        if(onRowDblClicked && typeof onRowDblClicked === 'function'){
	            while(popWin.erpPopupOrderOnRowSelect == undefined){
	                popWin.erpPopupOrderOnRowSelect = onRowDblClicked;    
	            }
	        }
	        
	        if(onClickAddData && typeof onClickAddData === 'function'){
	        	while(popWin.erpPopupOrderCheckList == undefined){
	        		popWin.erpPopupOrderCheckList = onClickAddData;
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
		

	/******************************************************************************/
	/* 1. 팝업에서 선택한 발주번호를 기준으로 발주내역에서 조회한다.              */
	/*    (상품및 수량은 가져오지만 협력사및 단가는 현재 협력사및 단가)           */
	/* 2. Hidden 그리드에 조회한 내역을 저장한다.                                 */
	/* 3. Hidden 그리드에서 편집그리드로 복사한다( 단 중복상품은 불가하다)        */
	/******************************************************************************/
	function COPYandPASTE(ord_no_list, SUPR_CD , SUPR_NM){

		erpRightLayout.progressOn();

		var scrin_ORD_DATE = document.getElementById("txtORD_DATE").value;
        scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")

		var checkList = ord_no_list.split(',');
		var cnt  = 0;
		var myArray = new Array(5);
		
		for(var i = 0 ; i < checkList.length ; i ++) {
			if(i != checkList.length ) {
				cnt = cnt + 1;
				if ( cnt < 6 ) {
					myArray[i] = checkList[i];
				} 
			} 
		}
		
        /* ※ 발주요청서  ORD_NO ->  발주일자 + 발주요청거래처 */
        var scrs_ORD_NO    = scrin_ORD_DATE + "_" + LOGIN_CUSTMR_CD;  	
        var scrs_ord_type  = "";
		console.log("scrs_ORD_NO =>" + scrs_ORD_NO );
		
		$.ajax({
			  url : "/sis/order/getSearchOrderDetailListCopy2.do"
			,data : {
				      "PARAM_ORGN_DIV_CD" : GLOVAL_ORGN_DIV_CD   
			     	, "PARAM_ORGN_CD"     : GLOVAL_ORGN_CD
			     	, "PARAM_ORD_TYP"     : "2"                 // 1:발주, 2:주문
				    , "PARAM_ORD_NO1"     : myArray[0]          // pop화면에서 선택된 N개의 발주번호 */
				    , "PARAM_ORD_NO2"     : myArray[1]          // pop화면에서 선택된 N개의 발주번호 */
				    , "PARAM_ORD_NO3"     : myArray[2]          // pop화면에서 선택된 N개의 발주번호 */
				    , "PARAM_ORD_NO4"     : myArray[3]          // pop화면에서 선택된 N개의 발주번호 */
		    		, "PARAM_ORD_NO5"     : myArray[4]          // pop화면에서 선택된 N개의 발주번호 */
		            , "PARAM_CUSTMR_CD"   : LOGIN_CUSTMR_CD     /* 고객          */
		            , "PARAM_CUST_NM"     : LOGIN_CUSTMR_NM     /* 고객사명      */
		            , "PARAM_ORD_NO"      : scrs_ORD_NO         /* 발주번호      */
		            , "PARAM_REQ_DATE"    : scrin_ORD_DATE      /* 발주일자      */
		            , "PARAM_RESP_USER"   : LOGIN_EMP_NO        /* 로그인(처리자)*/
		            , "PARAM_EMP_NM"      : LOGIN_EMP_NM        /* 처리자명      */
		            , "PARAM_SUPR_CD"     : SUPR_CD             /* 협력사코드    */
		            , "PARAM_SUPR_NM"     : SUPR_NM             /* 협력사명      */
		            , "PARAM_CUS_TYPE"    : "1"                 /* 발행구분      */
		            , "PARAM_CUS_T_NM"    : "PC주문"            /* 발행구분명    */
		            , "PARAM_FLAG"        : "1"                 /* 처리상태      */
		            , "PARAM_FLAG_NM"     : "발주예정"          /* 처리상태명    */
		            , "PARAM_ROWNUM"      : 1                   /* 최저가로 가져오려면 2, else 999999 */
		            , "PARAM_CUST_DIV_CD" : "OUT"               /* B01물류센타로의 주문, A06신선팜으로주문, OUT외부공급사  */		    		
			}
			
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpBackGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							  erpBackGrid, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpBackGrid.parse(gridDataList, 'js');	
						/* BackGrip에서 편집용그리드로 전체복사한다 */
						ObjectToEditBuffer("new");		

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
	/* 발주상품 삭제처리(그리드상에서만 삭제)
	/*********************************************************/
	function delete_erpRightGrid(){
		var gridRowCount = erpRightGrid.getRowsNum();
		var isChecked = false;
		var ll_cnt = 0;
		var Status = "";
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId    = erpRightGrid.getRowId(i);
			var check  = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("CHECK")).getValue();
			var Status = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("FLAG")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(rId);
				if(Status != "1"){
					   ll_cnt = ll_cnt + 1;
				}
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
		
		if(ll_cnt >  0){
			$erp.alertMessage({
				"alertMessage" : "발주완료한 자료는 삭제 불가능합니다.",
				"alertCode" : null,
				"alertType" : "error",
				"isAjax" : false
			});
			return false;
		}	
		
		for(var i = 0; i < deleteRowIdArray.length; i++){
			erpRightGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
	}	

	/**************************************************
	* 기타 영역
	**************************************************/

	
	/***************************************************/
	/* COMBO박스처리 
	/***************************************************/
	function initDhtmlXCombo(){

		/* 발주유형 */
  		cmbORD_TYPE_CD = $erp.getDhtmlXComboCommonCode('cmbORD_TYPE_CD',   'cmbORD_TYPE_CD', ["ORD_TYPE","CT"],   177,  "모두조회",  false);
   	        // $erp.objReadonly("cmbORD_TYPE_CD");  
   	        
  		cmbCUST_NAME   = $erp.getDhtmlXComboCommonCode('cmbCUST_NAME',   'cmbCUST_NAME', ["ORGN_CD","CT"],   177,  null,  false, LOGIN_ORGN_CD);

  		// 센터조직의  거래처 코드를 원할경우 
		//cmbCUST_NAME = $erp.getDhtmlXComboTableCode("cmbCUST_NAME", 	"CUST_NAME", 	"/sis/code/getOrgnCustomerList.do",  null, 130, null, false, LOGIN_CUSTMR_CD);

  		/*  본사사용자이면 조직  고객사( 센터선택) */
  		if  (LOGIN_ORGN_DIV_TYP != "A") {
   	         $erp.objReadonly("cmbCUST_NAME");  
  		}

  		cmbCUST_NAME.attachEvent("onChange", function(value, text){
  			LOGIN_ORGN_CD  = value;
  			LOGIN_ORGN_DIV_TYP = "B";
  			LOGIN_ORGN_DIV_CD  = "B01";
  			LOGIN_ORGN_DIV_NM  = text; 
	        document.getElementById("txtCUST_CD").value    = value;    /* 고객cd */
	        search_ErpRightGrid();
 		}); 
  			
  		
 		cmbORD_TYPE_CD.attachEvent("onChange", function(value, text){
 				var cmv_type_nm  = "";

 				var scrin_SUPR_CD = document.getElementById("hidSurp_CD").value;    /* 협력사 */
 				
				$erp.clearDhtmlXGrid(erpRightGrid); //기존데이터 삭제
				$erp.clearDhtmlXGrid(erpBackGrid);  //기존데이터 삭제
				
 				if  (value  == "2") { 
 					 cmv_type_nm = "OT1";
			         document.getElementById("Select_Surp_CD").checked = true;
 				} 	else if  (value  == "4") {  /* 착지변경 */ 
 					 cmv_type_nm = "CHG";
			         document.getElementById("Select_Surp_CD").checked = true;
			         document.getElementById("IlbanGoodsDeatline").value = GLOVL_NOR_CLSTIME;
 				}   else {
 					 cmv_type_nm = "";
			         document.getElementById("Select_Surp_CD").checked = false;
			         document.getElementById("IlbanGoodsDeatline").value = "";
 				}
 				
 				if ( value == "2" || value == "4")  {
 					if (  GLOVAL_SUPR_CD && scrin_SUPR_CD) {
 		 				erpLayout.cells("a").expand(); /* 상품목록 활성화 */
	 	 				searchErpLeftTree();
 					}
 				}
 			    
 				
 		}); 
		
		/* 발주진행상태  1:발주예정, 2:주문취소, 3:영업승인, 4:물류승인, 5:발주완료, 5:출고요청  */
		cmbORD_STATE   = $erp.getDhtmlXComboCommonCode('cmbORD_STATE',     'cmbORD_STATE',       ["ORD_STATE","ORD"] ,  177,  "모두조회",  false);   
		
		/*  발행구분(PC/PDA) */
		cmbMKT_TYPE_CD   = $erp.getDhtmlXComboCommonCode('cmbMKT_TYPE_CD',  'cmbMKT_TYPE_CD',    'ORD_CUSTMR_TYPE',     177,  "모두조회",  false);   
		
		/* 착지변경 배송직영점 */
		cmbSEND_WARE_CD   = $erp.getDhtmlXComboCommonCode('cmbSEND_WARE_CD', 'cmbSEND_WARE_CD',  ["ORGN_CD","MK"],      135, null, false );
		
		
	}
	
	/* 협력사 변경 changeEvent */
	function Surp_Name_change(curr_cd){
		var cmv_type_cd  = cmbORD_TYPE_CD.getSelectedValue();
		if ( cmv_type_cd == "2" || cmv_type_cd == "4")  {
			if (  curr_cd ) {
 				erpLayout.cells("a").expand(); /* 상품목록 활성화 */
				searchErpLeftTree();
			}
		}
	}
	
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>				
	 <div id="div_erp_20_Layout" class="div_tree_full_size" style="display:none;">	 

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
							<input type="text" id="txtKEY_WORD" name="KEY_WORD" class="input_common" maxlength="10"  onkeydown="$erp.onEnterKeyDown(event, searchErpLeftTree);">
						</td>
					</tr>
				</table>
			</div>
			<div id="div_erp_left_ribbon" class="div_ribbon_full_size" style="display:none"></div>
			<div id="div_erp_left_tree" class="div_tree_full_size" style="display:none"></div>	 
		 </div>
	 </div>

	 
	 <div id="div_erp_23_Layout" class="samyang_div" style="display:none;">

	 <div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
	 	  <table class="table_search" id="aaa">
			  <colgroup>
				  <col width="100px">
				  <col width="250px">
				  	
				  <col width="100px">
				  <col width="230px">
				  
				  <col width="140px">	
				  <col width="230px">
				  
				  <col width="140px">
				  <col width="240px">
				  <col width="*">				
			  </colgroup>
			  <tr>
				  <th>발주유형</th>
				  <td>
				      <div id="cmbORD_TYPE_CD"></div>
				  </td>				 

				  <th>발주일자</th>
				  <td>
					  <input type="hidden" id="txtORD_TYPE">  <!--  주문휴형 : 1:발주, 2:주문  -->
					  <input type="hidden" id="txtORD_PATH">  <!--  주문휴형 : 1:발주, 2:주문  -->
					  <input type="text" id="txtORD_DATE" name="txtORD_DATE" class="input_common input_calendar default_date" data-position="">
				  </td>

				  <th><input type="checkbox" id="Select_RESV_DATE" name="Select_RESV_DATE"/>입고예정일</th>
				  <td>
					  <input type="text" id="txtRESV_DATE" name="txtRESV_DATE" class="input_common input_calendar default_date" data-position="">
					  <input type="hidden" id="txtORD_RESV_DATE">
				  </td>
				
				  <th><input type="checkbox" id="Select_RESP_USER" name="Select_RESP_USER"/> 담당자명</th>
				  <td>
					  <input type="hidden" id="txtRESP_USER">
					  <input type="text" id="RESP_USER_NAME" name="RESP_USER_NAME" readonly="readonly" disabled="disabled"/>
				  </td>
			  </tr>
			
			  <tr>
				  <th><input type="checkbox" id="Select_Surp_CD" name="Select_Surp_CD"/>협력사</th>
				  <td>
					  <input type="hidden" id="hidSurp_CD">
					  <input type="text" id="Surp_Name"  name="Surp_Name" readonly="readonly"   disabled="disabled"/>
					  <input type="button" id="Surp_Search" value="검 색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/>
				  </td>

				  <th>고객사</th>
				  <td>
					  <input type="hidden" id="txtCUST_CD">
				      <div id="cmbCUST_NAME"></div>
				  </td>
				
				  <th>발주진행상태</th>
				  <td>
				      <div id="cmbORD_STATE"></div>
				  </td>

				  <th>발행구분</th>
				  <td>
				      <div id="cmbMKT_TYPE_CD"></div>
				  </td>
			  </tr>

			  <tr>
				  <th>배송요청요일</th>
				  <td><input type="text" id="SendDay" name="SendDay" readonly="readonly"  disabled="disabled" class="input_common" maxlength="20" style="width:172px;"></td>

				  <th>협력사리드타임</th>
				  <td><input type="text" id="BusinessDay" name="BusinessDay" readonly="readonly"  disabled="disabled" class="input_common" maxlength="20" style="width:171px;"></td>

				  <th>주문마감시간</th>
				  <td><input type="text" id="IlbanGoodsDeatline" name="IlbanGoodsDeatline" readonly="readonly"  disabled="disabled" class="input_common" style="width:70px;"></td>
			  
				  <th>배송직영점</th>
				  <td>
				      <div id="cmbSEND_WARE_CD"></div>
				  </td>
				  
			  </tr>
			
	 	  </table>
	 </div>
	 <div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	 <div id="div_erp_grid"   class="div_grid_full_size"   style="display:none"></div>
	 </div>
</body>

	
</html>