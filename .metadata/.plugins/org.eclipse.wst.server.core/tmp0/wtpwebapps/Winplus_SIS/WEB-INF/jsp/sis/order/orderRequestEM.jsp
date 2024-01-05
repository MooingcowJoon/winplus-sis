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
		※ 전역 변수 선언부( orderRequestEM.jsp CS포털 긴급주문서요청 프로그램 )
		□ 변수명 : Type / Description
		■ erpRightLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpRightGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbOUT_WARE_CD : Object / 출고창고 DhtmlXCombo  (CODE : CENTER_CD )
		■ cmbORD_STATE : Object / 발주진행상태  (CODE : ORD_STATE ) 		 
	--%>
	//var thisPopupWindow = parent.erpPopupWindows.window('orderPortalGridPopup');
	
	var CurrentRow = 0;
	var erpRightLayout;
	var erpRightRibbon;	
	var erpRightGrid;
	var erpRightGridColumns;
	var erpRightGridDataProcessor;	
	var cmbOUT_WARE_CD;                  /* 출고창고           */
	var cmbORD_TYPE_CD;                  /* 주문유형           */
	
	var cmbORD_STATE;                    /* 발주진행상태       */
	var cmbOUT_WARE_CD;                  /* 상품조회  협력사   */
	var erpRightGridSelectedCustmr_cd;   /* 그리드 rowSelected */

	var today     = $erp.getToday("");
	var thisYear  = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay   = today.substring(6,8);
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	var LOGIN_ORGN_DIV_CD  = "";
	var LOGIN_ORGN_CD      = "";
	var LOGIN_ORGN_DIV_TYP = "";
	var LOGIN_CUSTMR_CD    = "";
	var LOGIN_CUSTMR_NM    = "";
	var GLOVAL_SUPR_CD     = "";        /* 협력사코드 : 출고창고 COMBO박스에 선택된 코드  */

    /*  본사조직으로 로그인후  직영점 선택시 처리하기 위함 */
	var GLOVAL_ORGN_DIV_CD  = "";
	var GLOVAL_ORGN_CD      = "";
	var GLOVAL_ORGN_NM      = "";
	var GLOVAL_ORGN_DIV_TYP = "";

	var All_checkList = "";
	var Code_List = "";

	var GLOVAL_leadtime      = 2;       /* 발주리드타임 기본 2일 */
	var GLOVAL_closetime     = "";      /* 발주마감시간 */
	var GLOVAL_Display1_date = "";
	var GLOVAL_Display2_date = "";
    var	GLOVAL_CHK_CNT       = 1;
    var	GLOVAL_LOAN_LMT_AMT  = 0;       /* 여신한도       */
    var	GLOVAL_LOAN_BAL_AMT  = 0;       /* 현재여신잔액   */
    var	GLOVAL_LOAD_USE_AMT  = 0;       /* 잔액미반영금액 */
    var	GLOVAL_LOAD_AVL_AMT  = 0;       /* 발주가능금액   */
    var GLOVAL_LOAN_YN       = "";      /* 여신관리여부  */
    
    var	GLOVAL_LMT_CNTROL_YN  = "";     /* 발주한도 체크여부 */
    var	GLOVAL_ORD_APPEND_YN  = "";     /* 긴급발주 가능여부 */
    var GLOVAL_ORD_SEC_TIME   = "";     /* 긴급발주 마감시간 */
    var GLOVAL_EM_ORD_CD      = "";     /* 긴급발주가능여부  */
    
	var SELECT_LVL           =  "";
	var SELECT_GRUP_TOP_CD   =  "";
	var SELECT_GRUP_MID_CD   =  "";
	var SELECT_GRUP_BOT_CD   =  "";

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

		document.getElementById("txtORD_PATH").value = "P";  /* 발주경로 P(포털), 1, 센터, 2직영점 */
		
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
							, {id:"b", text: "주문서"    , header: true}
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
					var dataMap          =   data.dataMap;				
					LOGIN_ORGN_DIV_CD    =   data.gridDataList.ORGN_DIV_CD;
					LOGIN_ORGN_DIV_NM    =   data.gridDataList.ORGN_DIV_CD_NM;
					LOGIN_ORGN_DIV_TYP   =   data.gridDataList.ORGN_DIV_TYPE;
			        LOGIN_ORGN_CD        =   data.gridDataList.DEPT_CD;
			        LOGIN_ORGN_NM        =   data.gridDataList.ORGN_NM;
			        LOGIN_EMP_NO         =   data.gridDataList.EMP_NO;
			        LOGIN_EMP_NM         =   data.gridDataList.EMP_NM;
			        LOGIN_CUSTMR_CD      =   data.gridDataList.CUSTMR_CD;
			        LOGIN_CUSTMR_NM      =   data.gridDataList.CUSTMR_NM;

			        GLOVAL_ORGN_DIV_CD   =   data.gridDataList.ORGN_DIV_CD;
			        GLOVAL_ORGN_DIV_TYP  =   data.gridDataList.ORGN_DIV_TYPE;
					GLOVAL_ORGN_CD       =   data.gridDataList.DEPT_CD;

					GLOVAL_LMT_CNTROL_YN =   data.gridDataList.LMT_CNTROL_YN;   /* 발주한도 체크여부  */
					GLOVAL_ORD_APPEND_YN =   data.gridDataList.ORD_APPEND_YN;   /* 긴급발주 가능여부  */
					GLOVAL_ORD_SEC_TIME  =   data.gridDataList.ORD_SEC_TIME;    /* 긴급발주 마감시간  */
					GLOVAL_LOAN_YN       =   data.gridDataList.LOAN_YN;         /* 여신관리여부       */
					GLOVAL_EM_ORD_CD     =   data.gridDataList.EM_ORD_CD;       /* 긴급발주 가능구분  */
						
					console.log("LOGIN_ORGN_DIV_CD=>"   + LOGIN_ORGN_DIV_CD);          
					console.log("LOGIN_ORGN_DIV_NM=>"   + LOGIN_ORGN_DIV_NM);          
					console.log("LOGIN_ORGN_DIV_TYP=>"  + LOGIN_ORGN_DIV_TYP);          
					console.log("LOGIN_ORGN_CD=>"       + LOGIN_ORGN_CD);          
					console.log("LOGIN_ORGN_NM=>"       + LOGIN_ORGN_NM);          
					console.log("LOGIN_EMP_NO=>"        + LOGIN_EMP_NO);          
					console.log("LOGIN_EMP_NM=>"        + LOGIN_EMP_NM);  
					console.log("LOGIN_CUSTMR_CD=>"     + LOGIN_CUSTMR_CD);          
					console.log("LOGIN_CUSTMR_NM=>"     + LOGIN_CUSTMR_NM);  
					console.log("GLOVAL_LMT_CNTROL_YN=>" + GLOVAL_LMT_CNTROL_YN);          
					console.log("GLOVAL_ORD_APPEND_YN=>" + GLOVAL_ORD_APPEND_YN);  
					console.log("GLOVAL_ORD_SEC_TIME =>" + GLOVAL_ORD_SEC_TIME);  
					console.log("GLOVAL_LOAN_YN      =>" + GLOVAL_LOAN_YN);  
					console.log("CLOSE_TIME          =>" + data.gridDataList.CLOSE_TIME);  
					console.log("GLOVAL_EM_ORD_CD    =>" + GLOVAL_EM_ORD_CD)
					initDhtmlXCombo();
                    
					document.getElementById("txtORD_DATE").value        = today;
			        document.getElementById("txtCUST_CD").value         = LOGIN_CUSTMR_CD;    /* 고객cd */
			        document.getElementById("Cust_Name").value          = LOGIN_CUSTMR_NM;    /* 고객명 */

			        document.getElementById("hidSurp_CD").value         = data.gridDataList.WIN_CUSTMR_CD;    /* 협력사cd */
			        document.getElementById("Surp_Name").value          = data.gridDataList.WIN_CUSTMR_NM;    /* 협력사명 */
			        			        
			        document.getElementById("txtRESP_USER").value       = LOGIN_EMP_NO;      /* 처리자 */
			        document.getElementById("RESP_USER_NAME").value     = LOGIN_EMP_NM;      /* 처리자명 */
			        
			        document.getElementById("SendDay").value            = data.gridDataList.DELI_YOIL;        /* 배송요일 */
			        document.getElementById("BusinessDay").value        = data.gridDataList.LEAD_TIME;        /* 리드타임 */
			        
			        /* 긴급주문 마감시간 */
			        document.getElementById("EmergGoodsDeatline").value = data.gridDataList.CLSE_TIME  + " ~ " +
			                                                              GLOVAL_ORD_SEC_TIME.substr(0,2) + ":"+ GLOVAL_ORD_SEC_TIME.substr(2,2);
			        GLOVAL_LOAN_LMT_AMT                                 = data.gridDataList.LOAN_LMT_AMT;     /* 여신한도       */
			        GLOVAL_LOAN_BAL_AMT                                 = data.gridDataList.LOAN_BAL_AMT;     /* 현재여신잔액   */
			        GLOVAL_LOAD_AVL_AMT                                 = data.gridDataList.LOAN_AVL_AMT;     /* 발주가능금액   */

			        document.getElementById("txtLOAN_LMT_AMT").value    = $erp.convertToMoney(GLOVAL_LOAN_LMT_AMT);  /* 여신한도       */
			        document.getElementById("txtLOAN_BAL_AMT").value    = $erp.convertToMoney(GLOVAL_LOAN_BAL_AMT);  /* 현재여신잔액   */
			        document.getElementById("txtLOAN_AVL_AMT").value    = $erp.convertToMoney(GLOVAL_LOAD_AVL_AMT);  /* 발주가능금액   */

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
			        search_ErpRightGrid();
			       
			       // $('input').prop('readonly', true);
			        
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}	
	
	/***************************************************/
	/* 여신잔액 Reload
	/***************************************************/
	function getLoanBAlReLoad( gridDataList ){
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
					var dataMap          =   data.dataMap;				
			        GLOVAL_LOAN_LMT_AMT                               = data.gridDataList.LOAN_LMT_AMT;            /* 여신한도       */
			        GLOVAL_LOAN_BAL_AMT                               = data.gridDataList.LOAN_BAL_AMT;            /* 현재여신잔액   */
			        document.getElementById("txtLOAN_LMT_AMT").value  = $erp.convertToMoney(GLOVAL_LOAN_LMT_AMT);  /* 여신한도       */
			        document.getElementById("txtLOAN_BAL_AMT").value  = $erp.convertToMoney(GLOVAL_LOAN_BAL_AMT);  /* 현재여신잔액   */
			        
					erpRightGrid.parse(gridDataList, 'js');	
					erpRightGrid.selectRowById(1);
					$erp.setDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);

					var rowsNum = erpRightGrid.getRowsNum();
					for(var ii = 0; ii < rowsNum; ii++){
						var rId        = erpRightGrid.getRowId(ii);
						var ll_TOT_AMT = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("TOT_AMT")).getValue();
						var ls_FLAG    = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("FLAG")).getValue();
						if  (ls_FLAG   == "0" ||  ls_FLAG   == "1") {
							if  (!ll_TOT_AMT) { ll_TOT_AMT = 0;	}
							GLOVAL_LOAD_USE_AMT = GLOVAL_LOAD_USE_AMT + ll_TOT_AMT;
						}
					}

					console.log(" @@@@@@@@@@@  GLOVAL_LOAD_USE_AMT =>" + GLOVAL_LOAD_USE_AMT);
					if( GLOVAL_LOAN_YN == "Y") {
					    GLOVAL_LOAD_AVL_AMT = GLOVAL_LOAN_BAL_AMT - GLOVAL_LOAD_USE_AMT;
				        document.getElementById("txtLOAN_AVL_AMT").value    = $erp.convertToMoney(GLOVAL_LOAD_AVL_AMT);  /* 발주가능금액   */			        
				    }
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
		
		$.ajax({
			 url      : "/sis/order/getGoodsTreeList.do"
			,data     : {   "PARAM_ORGN_DIV_CD" :  GLOVAL_ORGN_DIV_CD
				           ,"PARAM_CUST_CD"     :  LOGIN_CUSTMR_CD
				           ,"PARAM_CUST_DIV_CD" :  "B01"  /* 물류센타로의 주문 */ 
					       ,"PARAM_GOODS_TYPE"  :  "1"    /* 1물류, 2직납, 3신선, 4착지 5일배, 긴급6  */ 
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
		GLOVAL_LOAD_USE_AMT = 0;  /* 여신잔액 계산하기위함 */

		var grup_top_cd  = SELECT_GRUP_TOP_CD;
		var grup_mid_cd  = SELECT_GRUP_MID_CD;
		var grup_bot_cd  = SELECT_GRUP_BOT_CD;
		var selectct_lvl = SELECT_LVL;
		var goods_nm     = "";
		var cmv_type_cd  = cmbORD_TYPE_CD.getSelectedValue();
		var cmv_type_nm  = "";
		var cmv_call_nm  = "";
		
		switch (cmv_type_cd) {
	       case "1" :  cmv_type_nm = "물류발주"; cmv_call_nm = "B01"; break;    /* 물류발주 */    
	       case "2" :  cmv_type_nm = "직납발주"; cmv_call_nm = "OUT"; break;    /* 직납발주 */  
	       case "3" :  cmv_type_nm = "신선발주"; cmv_call_nm = "A06"; break;    /* 신선발주 */   
	       case "4" :  cmv_type_nm = "착지변경"; cmv_call_nm = "B01"; break;    /* 착지변경 */   
	       case "5" :  cmv_type_nm = "일배발주"; cmv_call_nm = "B01"; break;    /* 일배발주 */
	       case "6" :  cmv_type_nm = "긴급발주"; cmv_call_nm = "B01"; break;    /* 긴급발주 */
	       default  :  cmv_type_nm = ""; break;
	    }  		

		var scrin_ORD_DATE = document.getElementById("txtORD_DATE").value;
		var scrin_SUPR_CD  = document.getElementById("hidSurp_CD").value;    /* 협력사 */
		var scrin_SUPR_NM  = document.getElementById("Surp_Name").value;      /* 협력사 */
		scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")
		
		/* ※ 발주요청서  ORD_NO ->  주문일자 + 발주요청거래처 */
		var scrs_ORD_NO    = scrin_ORD_DATE + "_" + LOGIN_CUSTMR_CD;  
		
		$.ajax({
			  url     : "/sis/order/getSearchMasterBarcodeCustmrPriceList.do"
			,data     : {
							  "PARAM_GRUP_TOP_CD" : grup_top_cd
							, "PARAM_GRUP_MID_CD" : grup_mid_cd
							, "PARAM_GRUP_BOT_CD" : grup_bot_cd
							, "PARAM_BCD_NM"      : goods_nm
							, "PARAM_ORGN_DIV_CD" : GLOVAL_ORGN_DIV_CD  /* 부문          */
							, "PARAM_ORGN_CD"     : GLOVAL_ORGN_CD      /* 조직          */
							, "PARAM_CUSTMR_CD"   : LOGIN_CUSTMR_CD     /* 고객          */
					        , "PARAM_CUST_NM"     : LOGIN_CUSTMR_NM     /* 고객사명      */
					        , "PARAM_LVL"         : selectct_lvl
					        , "PARAM_ORD_NO"      : scrs_ORD_NO         /* 발주번호      */
					        , "PARAM_REQ_DATE"    : scrin_ORD_DATE      /* 주문일자      */
					        , "PARAM_ORD_TYPE"    : cmv_type_cd         /* 주문유형      */
					        , "PARAM_ORD_TYPE_NM" : cmv_type_nm         /* 주문유형명    */
					        , "PARAM_RESP_USER"   : LOGIN_EMP_NO        /* 로그인(처리자)*/
					        , "PARAM_EMP_NM"      : LOGIN_EMP_NM        /* 처리자명      */
					        , "PARAM_SUPR_CD"     : scrin_SUPR_CD       /* 협력사코드    */
					        , "PARAM_SUPR_NM"     : scrin_SUPR_NM       /* 협력사명      */
					        , "PARAM_CUS_TYPE"    : "1"                 /* 발행구분      */
					        , "PARAM_CUS_T_NM"    : "PC주문"            /* 발행구분명    */
						    , "PARAM_FLAG"        : "1"                 /* 처리상태      */
							, "PARAM_FLAG_NM"     : "주문예정"          /* 처리상태명    */
	                        , "PARAM_ROWNUM"      : 1                   /* 최저가로 가져오려면 2, else 999999 */
							, "PARAM_CUST_DIV_CD" : cmv_call_nm         /* B01물류센타로의 주문, A06신선팜으로주문, OUT외부공급사  */
					        , "PARAM_GOODS_TYPE"  : cmv_type_cd         /* 1물류, 2직납, 3신선, 4착지 5일배  */ 
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
						, {id : "excel_erpGri2",      type : "button", text:'주문완료',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "excel_erpGri1",      type : "button", text:'거래내역조회',                            isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
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
		    	
		    } else if (itemId == "excel_erpGri1"){
		    	copy_ErpRightGrid();  /* 기존주문내역에서 복사 */
		    } else if (itemId == "print_erpGrid"){

		    } else if (itemId == "excel_erpGri2"){
		    	insertSelectPurordandGoodsConfirm(); // 발주확정
		    }
		});		
		
		return true;
		
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
			  "alertMessage" : "정말 주문완료 하시겠습니까?"
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
				"alertMessage" : "임시저장할 주문예정건이 존재하지 않습니다.",
				"alertCode" : null,
				"alertType" : "error",
				"isAjax" : false
			});
			return false;
		}
		
		if  ( GLOVAL_LOAD_AVL_AMT  < 0) {
			$erp.alertMessage({
				"alertMessage" : "여신 잔액이 부족합니다.",
				"alertCode" : null,
				"alertType" : "error",
				"isAjax" : false,
			});
			return;
		}

		var alertCode = "";
		var alertType = "alert";
		var callbackFunction = function(){
	    	save_ErpRightGrid();
		}
		
		$erp.confirmMessage({
			  "alertMessage" : "<br>미입력 수량 및 주문완료건은 저장되지 않습니다.<br/> 정말 임시저장 하시겠습니까?"
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
			var rId   = erpRightGrid.getRowId(i);
			var check  = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("CHECK")).getValue();
			var Status = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("FLAG")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(rId);
				if(Status == "1"){
					   ll_cnt = ll_cnt + 1;
				}
			}
		}
		
		if(ll_cnt ==  0){
			$erp.alertMessage({
				"alertMessage" : "대상 선택을 하지않았거나 주문완료할 주문예정건이 없습니다.",
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
			      [ "NO"              ,     "REQ_DATE"     ,  "ORD_NO"          ,   "ORD_SEQ"      ,   "ORD_TYPE"        ,   "ORD_TYPE_NM"     ,
			        "REQ_CUSTMR_CD"   ,     "CUST_NM"      ,  "SUPR_CUSTMR_CD"  ,   "SUPR_NM"      ,   "BCD_CD"          ,   "WARE_CD"         ,
			        "TAX_TYPE"        ,     "DIMEN_NM"     ,  "UNIT_QTY"        ,   "STOCK_QTY"    ,   "REQ_QTY"         ,   "GOODS_PRICE"     ,
			        "SUPR_AMT"        ,     "VAT_AMT"      ,  "TOT_AMT"         ,   "RESV_DATE"    ,   "LAND_CHG_TYPE"   ,   "MEMO"            ,
			        "ORD_CUSTMR_TYPE" ,     "RESP_USER"    ,  "FLAG"            ,   "ORGN_DIV_CD"  ,   "ORGN_CD"         ,   "COMP_TOT_AMT" ],
			      [ "NO"              ,     "REQ_DATE"     ,  "ORD_NO"          ,   "ORD_SEQ"      ,   "ORD_TYPE"        ,   "ORD_TYPE_NM"     ,
			        "REQ_CUSTMR_CD"   ,     "CUST_NM"      ,  "SUPR_CUSTMR_CD"  ,   "SUPR_NM"      ,   "BCD_CD"          ,   "WARE_CD"         ,
			        "TAX_TYPE"        ,     "DIMEN_NM"     ,  "UNIT_QTY"        ,   "STOCK_QTY"    ,   "REQ_QTY"         ,   "GOODS_PRICE"     ,
			        "SUPR_AMT"        ,     "VAT_AMT"      ,  "TOT_AMT"         ,   "RESV_DATE"    ,   "LAND_CHG_TYPE"   ,   "MEMO"            ,
			        "ORD_CUSTMR_TYPE" ,     "RESP_USER"    ,  "FLAG"            ,   "ORGN_DIV_CD"  ,   "ORGN_CD"         ,   "COMP_TOT_AMT"],
			      "checked", "new", [], [],{}, {}, insertSelectPurordandGoods_callback, false );
	    console.log("===========insertSelectPurordandGoods===============");
	}

	/****************************************************************************/
    /* 대상을 가져와서 입력영역으로 옮길때 DataProcess CUD => C                 */
    /****************************************************************************/	
	function ObjectToEditBuffer(type){		
	    erpBackGrid.checkAll(true);
	    
	    //console.log("===========insertSelectPurordandGoods3 gridRowCount=> " + gridRowCount );
		$erp.copyRowsGridToGrid(erpBackGrid, erpRightGrid, 
			      [ "OBJKEY"       ,  "CHECK"           ,   "REQ_DATE"     ,   "ORD_NO"          ,   "ORD_SEQ"            ,   "ORD_TYPE"   ,
			    	"ORD_TYPE_NM"  ,  "REQ_CUSTMR_CD"   ,   "CUST_NM"      ,   "SUPR_CUSTMR_CD"  ,   "SUPR_NM"            ,   "BCD_CD"     ,
			    	"BCD_NM"       ,  "WARE_CD"         ,   "WARE_NM"      ,   "TAX_TYPE"        ,   "DIMEN_NM"           ,   "UNIT_QTY"   ,
			        "STOCK_QTY"    ,  "REQ_QTY"         ,   "GOODS_PRICE"  ,   "SUPR_AMT"        ,   "VAT_AMT"            ,   "TOT_AMT"    ,
			        "RESV_DATE"    ,  "LAND_CHG_TYPE"   ,   "MEMO"         ,   "ORD_CUSTMR_TYPE" ,   "ORD_CUSTMR_TYPE_NM" ,   "RESP_USER"  , 
			        "EMP_NM"       ,  "FLAG"            ,   "FLAG_NM"      ,   "ORGN_DIV_CD"     ,   "ORGN_CD"             ,  "UNIT_NM" ],
			        
			      [ "OBJKEY"       ,  "CHECK"           ,   "REQ_DATE"     ,   "ORD_NO"          ,   "ORD_SEQ"             ,  "ORD_TYPE"   ,
			    	"ORD_TYPE_NM"  ,  "REQ_CUSTMR_CD"   ,   "CUST_NM"      ,   "SUPR_CUSTMR_CD"  ,   "SUPR_NM"             ,  "BCD_CD"     ,
			    	"BCD_NM"       ,  "WARE_CD"         ,   "WARE_NM"      ,   "TAX_TYPE"        ,   "DIMEN_NM"            ,  "UNIT_QTY"   ,
			        "STOCK_QTY"    ,  "REQ_QTY"         ,   "GOODS_PRICE"  ,   "SUPR_AMT"        ,   "VAT_AMT"             ,  "TOT_AMT"    ,
			        "RESV_DATE"    ,  "LAND_CHG_TYPE"   ,   "MEMO"         ,   "ORD_CUSTMR_TYPE" ,   "ORD_CUSTMR_TYPE_NM"  ,  "RESP_USER"  , 
			        "EMP_NM"       ,  "FLAG"            ,   "FLAG_NM"      ,   "ORGN_DIV_CD"     ,   "ORGN_CD"             ,  "UNIT_NM" ],
			      "checked", type, [], [],{"ORD_TYPE" : "6", "ORD_TYPE_NM":"긴급발주"}, {"ORD_TYPE" : "6", "ORD_TYPE_NM":"긴급발주"}, callback_lastProdedure, false );
	    console.log("===========insertSelectPurordandGoods4===============");

	}
	
	/****************************************************************************/
    /* 합계금액 및 커서위치                                                     */
    /****************************************************************************/	
	function callback_lastProdedure() {

    	erpRightGrid.selectRowById(CurrentRow);   
		$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
    	
    }

    /******************************************************************************************************/
    /* 마감시간 체크후 발주확정Data로 저장  ( T_REQ_GOODS_TMP -> T_PUR_ORD, T_PUR_ORD_GOODS)로  Insert  )
    /******************************************************************************************************/
	function insertSelectPurordandGoods_callback(){
    	
	 	  var HEAD = $erp.dataSerialize("aaa");
		  console.log(HEAD);
         
		  var BODY = $erp.dataSerializeOfGridByMode(erpBackGrid,"all");  
          console.log(BODY);
          
          var url = "/sis/order/OrderRequestSelectInsert.do";
          
  		  var send_data = { "HEAD":HEAD, "BODY":BODY}; 
          
          var if_success = function(data){
              console.log(" @@@@@@@@@@@@@@@@@@ result ");
              console.log(" @@@@@@@@@@@@@@@@@@ data.gridDataList.return_code =>" + data.gridDataList.return_code);
              
              switch (data.gridDataList.return_code) {
                   case  "1" :  ls_message = "물류발주 마감시간이 경과되었습니다."; break;
                   case  "2" :  ls_message = "직납발주 마감시간이 경과되었습니다."; break;
                   case  "3" :  ls_message = "신선발주 마감시간이 경과되었습니다."; break;
                   case  "4" :  ls_message = "착지변경 마감시간이 경과되었습니다."; break;
                   case  "5" :  ls_message = "일배발주 마감시간이 경과되었습니다."; break;
		           case  "6" :  ls_message = "긴급발주 마감시간이 경과되었습니다."; break;
  		           case  "Y" :  ls_message = "변경건 임시저장후 완료하시기 바랍니다."; break;
			       case  "Z" :  ls_message = "긴급주문 가능시간이 도래하지 않았습니다."; break;
                   case  "9" :  ls_message = "전일자는 발주 불가합니다."; break;
                   default :  ls_message = ""; break;
              }
                
              console.log( "ls_message=>"+ ls_message );
              
              if ( data.gridDataList.return_code != "00" ) {
                   $erp.alertMessage({
                     "alertMessage" : ls_message,
                     "alertCode"    : null,
                     "alertType"    : "alert",
                     "isAjax"       : false,
                   });
                   return;
              }				  
              
              if(data.gridDataList.return_code == "00"){
                  $erp.alertSuccessMesage(onAfterSaveErpRightGrid);
                  console.log("성공");
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
				, {id : "REQ_DATE"             , label:["요청일자"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}			
				, {id : "ORD_NO"               , label:["발주번호"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : true , isEssential : true}
		   	    , {id : "ORD_SEQ"              , label:["일련번호"          , "#text_filter"],   type: "ron" , width:  "60", sort : "int", align : "right",  isHidden : true , isEssential : true}
				, {id : "ORD_TYPE"             , label:["주문유형"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : true,  isEssential : true, commonCode : "ORD_TYPE"}			
				, {id : "ORD_TYPE_NM"          , label:["주문유형"          , "#select_filter"], type: "ro"  , width:  "80", sort : "str", align : "left",   isHidden : true , isEssential : false}			
				, {id : "FLAG_NM"              , label:["주문상태"          , "#select_filter"], type: "ro"  , width:  "80", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "REQ_CUSTMR_CD"        , label:["고객사CD"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true , isEssential : true}			
				, {id : "CUST_NM"              , label:["고객사명"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true , isEssential : false}			
				, {id : "SUPR_CUSTMR_CD"       , label:["협력사코드"        , "#text_filter"],   type: "ro"  , width:  "80", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "SUPR_NM"              , label:["협력사명"          , "#select_filter"], type: "ed"  , width: "120", sort : "str", align : "left",   isHidden : true , isEssential : false}

				/* ROW INDEX 11 ~ 20 */
				, {id : "BCD_CD"               , label:["바코드"            , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "BCD_NM"               , label:["상품명"            , "#text_filter"],   type: "ed"  , width: "250", sort : "str", align : "left",   isHidden : false, isEssential : false}			
				, {id : "WARE_CD"              , label:["창고코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "WARE_NM"              , label:["창고"              , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "TAX_TYPE"             , label:["과세여부"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : false, isEssential : false}
				, {id : "DIMEN_NM"             , label:["규격"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "UNIT_QTY"             , label:["입수량"            , "#text_filter"],   type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "STOCK_QTY"            , label:["전산재고"          , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "REQ_QTY"              , label:["수량"              , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "UNIT_NM"              , label:["단위"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			

				/* ROW INDEX 21 ~ 30 */
				, {id : "GOODS_PRICE"          , label:["단가"              , "#text_filter"],   type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}			
				, {id : "SUPR_AMT"             , label:["공급가액"          , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"              , label:["부가세"            , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"              , label:["합계금액"          , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "RESV_DATE"            , label:["납기예정일"        , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false,  isEssential : false}			
				, {id : "LAND_CHG_TYPE"        , label:["착지변경"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}			
				, {id : "MEMO"                 , label:["적요"              , "#text_filter"],   type: "ed"  , width: "200", sort : "str", align : "left",   isHidden : false,  isEssential : false}
				//, {id : "DSCD_TYPE"          , label:["반품가능"          , "#text_filter"],   type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : false, isEssential : true}			
				//, {id : "RESN_CD"            , label:["반품사유코드"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_CUSTMR_TYPE"      , label:["발행구분"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "ORD_CUSTMR_TYPE_NM"   , label:["발행구분"          , "#select_filter"], type: "ro"  , width: "80" , sort : "str", align : "left",   isHidden : true,   isEssential : false}
				, {id : "RESP_USER"            , label:["처리자"            , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true  , isEssential : true}

				/* ROW INDEX 31  */
				, {id : "EMP_NM"               , label:["요청자"            , "#select_filter"], type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false , isEssential : false}
				, {id : "FLAG"                 , label:["발주상태"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,    isEssential : false}
				, {id : "MIN_ORGN_CD"          , label:["최저매입매장"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "MIN_ORGN_NM"          , label:["최저매입매장"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "MIN_PUR_DATE"         , label:["최저매입일자"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "MIN_PUR_PRICE"        , label:["최저매입단가"      , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false,  isEssential : false,  numberFormat : "0,000"}
				, {id : "MIN_PUR_CUSTMR_NM"    , label:["최저매입업체"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "ORGN_DIV_CD"          , label:["조직유형"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}			
				, {id : "ORGN_CD"              , label:["조직코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}			
				, {id : "OBJKEY"               , label:["BCD+공급사CD"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true,   isEssential : false}			
				, {id : "COMP_TOT_AMT"         , label:["합계금액 비교용"   , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : true , isEssential : true,  numberFormat : "0,000"}
				, {id : "MIN_PUR_QTY"          , label:["물류주문단위"      , "#text_filter"],   type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "MIN_PUR_UNIT"         , label:["협력사최소량"      , "#text_filter"],   type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : true, isEssential : true,  numberFormat : "0,000.00"}			
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

			if ( stage == "2") {
			    var rowIdName =  erpRightGrid.getRowId(cInd);
			    var ll_REQ_QTY     =  Number(erpRightGrid.cells(rId, erpRightGrid.getColIndexById("REQ_QTY")).getValue());
			    var ll_GOODS_PRICE =  erpRightGrid.cells(rId, erpRightGrid.getColIndexById("GOODS_PRICE" )).getValue();
			    var ll_TAX_TYPE    =  erpRightGrid.cells(rId, erpRightGrid.getColIndexById("TAX_TYPE"    )).getValue();
			    var ll_UNIT_NM     = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("UNIT_NM"    )).getValue();
			    var ll_con_qty     = 0;
			    var ll_use_amt     =  0;

			    var MIN_PUR_UNIT    = Number(erpRightGrid.cells(rId, erpRightGrid.getColIndexById("MIN_PUR_UNIT" )).getValue());
			    /* 중량상품이면  100g으로 환산  */
			    if  ( ll_UNIT_NM == "g") {
			    	ll_con_qty = 	ll_REQ_QTY / 100;
			    } else {
			    	ll_con_qty = 	ll_REQ_QTY;
			    }

			    /* 공통ORGN_CD2에  발주한도 체크여부를 체크토록 설정이 되어있으면 발주수랴향, 한도, 제한수량을 체크한다.*/
			    if  ( GLOVAL_LMT_CNTROL_YN == "Y") {

			    	console.log(" GLOVAL_LMT_CNTROL_YN  => " +  GLOVAL_LMT_CNTROL_YN);
			    	
                    if  ( MIN_PUR_UNIT > 0 &&  ll_REQ_QTY > 0) {
                    
	    		    	if ( ll_REQ_QTY < MIN_PUR_UNIT ) {
				    		 validationNotifyConfirm(rId,  $erp.convertToMoney(MIN_PUR_UNIT));
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
			    
				var ll_OTOT_AMT = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("TOT_AMT")).getValue();
				if  (!ll_OTOT_AMT) {
					ll_OTOT_AMT = 0;
				}
			    
			    erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUPR_AMT"   )).setValue(ll_SUPR_AMT);
				erpRightGrid.cells(rId, erpRightGrid.getColIndexById("VAT_AMT"    )).setValue(ll_VAT);
				erpRightGrid.cells(rId, erpRightGrid.getColIndexById("TOT_AMT"    )).setValue(ll_TOT_AMT);

				var COMP_TOT_AMT = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("COMP_TOT_AMT")).getValue();
				if  (!COMP_TOT_AMT) {
					COMP_TOT_AMT = 0;
				}
			    ll_SUPR_AMT      = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUPR_AMT"    )).getValue();
			    ll_VAT           = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("VAT_AMT"     )).getValue();
			    
				if( GLOVAL_LOAN_YN == "Y") {
				    ll_use_amt       = ll_TOT_AMT  - ll_OTOT_AMT;
				    GLOVAL_LOAD_USE_AMT = GLOVAL_LOAD_USE_AMT  + ll_use_amt;
				    
				    GLOVAL_LOAD_AVL_AMT = GLOVAL_LOAN_BAL_AMT - GLOVAL_LOAD_USE_AMT;
				    console.log( " =============================");
				    console.log( " CURR_TOT_AMT : " + $erp.convertToMoney(ll_TOT_AMT) + " COMP_TOT_AMT : " + $erp.convertToMoney(COMP_TOT_AMT) +  " BEFO_TOT_AMT : " + $erp.convertToMoney(ll_OTOT_AMT)  ); 
				    console.log( " ll_use_amt : " + $erp.convertToMoney(ll_use_amt) + " LOAD_USE_AMT : " + $erp.convertToMoney(GLOVAL_LOAD_USE_AMT) ); 
				    console.log( " LOAD_AVL_AMT : " + $erp.convertToMoney(GLOVAL_LOAD_AVL_AMT) ); 
			        document.getElementById("txtLOAN_AVL_AMT").value    = $erp.convertToMoney(GLOVAL_LOAD_AVL_AMT);  /* 발주가능금액   */
				}

				$erp.setDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);
	
			    //return true;
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
	function validationNotifyConfirm( rId,  ord_unit ){

		var ll_cnt = 0;
		var ls_message = "주문 수량이 최소주문 수량 ("+  ord_unit  + ") 보다 작습니다.";
		
		var callbackFunction = function(){
			

		    erpRightGrid.cells(rId, erpRightGrid.getColIndexById("REQ_QTY"  )).setValue(null);
		    erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUPR_AMT" )).setValue(null);
			erpRightGrid.cells(rId, erpRightGrid.getColIndexById("VAT_AMT"  )).setValue(null);
			erpRightGrid.cells(rId, erpRightGrid.getColIndexById("TOT_AMT"  )).setValue(null);

			var COMP_TOT_AMT = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("COMP_TOT_AMT")).getValue();
			if  (!COMP_TOT_AMT) {
				COMP_TOT_AMT = 0;
			}
		    ll_SUPR_AMT      = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUPR_AMT"    )).getValue();
		    ll_VAT           = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("VAT_AMT"     )).getValue();
		    
			if( GLOVAL_LOAN_YN == "Y") {
			    ll_use_amt       = ll_TOT_AMT  - ll_OTOT_AMT;
			    GLOVAL_LOAD_USE_AMT = GLOVAL_LOAD_USE_AMT  + ll_use_amt;
			    GLOVAL_LOAD_AVL_AMT = GLOVAL_LOAN_BAL_AMT - GLOVAL_LOAD_USE_AMT;
			    console.log( " CURR_TOT_AMT : " + $erp.convertToMoney(ll_TOT_AMT) + " COMP_TOT_AMT : " + $erp.convertToMoney(COMP_TOT_AMT) +  " BEFO_TOT_AMT : " + $erp.convertToMoney(ll_OTOT_AMT)  ); 
			    console.log( " ll_use_amt : " + $erp.convertToMoney(ll_use_amt) + " LOAD_USE_AMT : " + $erp.convertToMoney(GLOVAL_LOAD_USE_AMT) ); 
			    console.log( " LOAD_AVL_AMT : " + $erp.convertToMoney(GLOVAL_LOAD_AVL_AMT) ); 
		        document.getElementById("txtLOAN_AVL_AMT").value    = $erp.convertToMoney(GLOVAL_LOAD_AVL_AMT);  /* 발주가능금액   */
			}
		    
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
				, {id : "ORD_TYPE"             , label:["주문유형"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : false,  isEssential : true, commonCode : "ORD_TYPE"}			
				, {id : "ORD_TYPE_NM"          , label:["주문유형"          , "#select_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false, isEssential : false}			
				, {id : "REQ_CUSTMR_CD"        , label:["고객사CD"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false,  isEssential : true}			
				, {id : "CUST_NM"              , label:["고객사명"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "SUPR_CUSTMR_CD"       , label:["협력사코드"        , "#text_filter"],   type: "ro"  , width:  "80", sort : "str", align : "left",   isHidden : false , isEssential : true}
				, {id : "SUPR_NM"              , label:["협력사명"          , "#select_filter"], type: "ed"  , width: "120", sort : "str", align : "left",   isHidden : false , isEssential : false}

				/* ROW INDEX 11 ~ 20 */
				, {id : "BCD_CD"               , label:["바코드"            , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "BCD_NM"               , label:["상품명"            , "#text_filter"],   type: "ed"  , width: "250", sort : "str", align : "left",   isHidden : false, isEssential : false}			
				, {id : "WARE_CD"              , label:["창고코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "WARE_NM"              , label:["창고"              , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false, isEssential : false}
				, {id : "TAX_TYPE"             , label:["부가세"            , "#text_filter"],   type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : false, isEssential : false}
				, {id : "DIMEN_NM"             , label:["규격"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "UNIT_QTY"             , label:["입수량"            , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "STOCK_QTY"            , label:["전산재고"          , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "REQ_QTY"              , label:["수량"              , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "UNIT_NM"              , label:["단위"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			

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
				, {id : "ORD_CUSTMR_TYPE"      , label:["발행구분"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "ORD_CUSTMR_TYPE_NM"   , label:["발행구분"          , "#select_filter"], type: "ro"  , width: "80" , sort : "str", align : "left",   isHidden : false,  isEssential : false}
				, {id : "RESP_USER"            , label:["처리자"            , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false , isEssential : true}

				/* ROW INDEX 31  */
				, {id : "EMP_NM"               , label:["요청자"            , "#select_filter"], type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false,  isEssential : false}
				, {id : "FLAG"                 , label:["발주상태"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "FLAG_NM"              , label:["발주상태"          , "#select_filter"], type: "ro"  , width: "80",  sort : "str", align : "center", isHidden : false,  isEssential : true}
				, {id : "MIN_ORGN_CD"          , label:["최저매입매장"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "MIN_ORGN_NM"          , label:["최저매입매장"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "MIN_PUR_DATE"         , label:["최저매입일자"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "MIN_PUR_PRICE"        , label:["최저매입단가"      , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false,  isEssential : false,  numberFormat : "0,000"}
				, {id : "MIN_PUR_CUSTMR_NM"    , label:["최저매입업체"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "ORGN_DIV_CD"          , label:["조직유형"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "ORGN_CD"              , label:["조직코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "OBJKEY"               , label:["BCD+공급사CD"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "MIN_PUR_QTY"          , label:["최소주문수량"      , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false,  isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "MIN_PUR_UNIT"         , label:["최소주문단위"      , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false,  isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "CHG_WARE_CD"          , label:["배송지"            , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "ORI_ORD_NO"           , label:["원주문서NO"        , "#text_filter"],   type: "ro"  , width: "150", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
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
		var ls_CUSTMR_CD  = "";
		
		var onRowSelect = function(id, ind) {
			document.getElementById("txtSUPR_CD").value  = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			//document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	/***************************************************/
	/* 협력사 주문마감시간 고려  leadetime일 구하기
	/***************************************************/
	function getOrderDeadTimeLeadTime(CUSTMR_CD, mode){
		
		GLOVAL_closetime     = ""; /* 발주마감시간 */
		GLOVAL_Display1_date = "";
		GLOVAL_Display2_date = "";
		GLOVAL_CHK_CNT       = 1;
		
		$.ajax({
			url : "/sis/order/getOrderDeadTimeLeadTime.do"
			,data : { "PARAM_CUSTMR_CD"  : CUSTMR_CD }
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					document.getElementById("BusinessDay").value=data.gridDataList.GET_LEAD_TIME; /* leadtime */
					GLOVAL_CHK_CNT=data.gridDataList.CHK_CNT; /* 마감시간 이전이면 1 이후이면 2 */
					
					console.log("data.gridDataList.CHK_CNT(마감시간 이전이면 1 이후이면 2)=>" +  data.gridDataList.CHK_CNT);
					console.log("data.gridDataList.GET_LEAD_TIME(리드타임일)=>" + data.gridDataList.GET_LEAD_TIME);
					
					GLOVAL_leadtime =data.gridDataList.GET_LEAD_TIME;    /* leadtime */
					GLOVAL_closetime=data.gridDataList.CLSE_TIME+ "00";  /* 발주마감시간  시분+초 */
					document.getElementById("OrderDeadTimeLeadTime").value= data.gridDataList.DISP_CLSE_TIME;
					getBusinessDay(GLOVAL_leadtime,   1, GLOVAL_CHK_CNT, mode);
					if ( mode == 1) {
						getBusinessDay(GLOVAL_leadtime+1, 2, GLOVAL_CHK_CNT, mode);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}	
	
	/*************************************************************************************/
	/* 윈플러스 영업일조회( 비영업일 : 토,일, 기본 ) 
	/* SELECT CMMN_DETAIL_CD_NM  FROM COM_CMMN_CODE_DETAIL WHERE CMMN_CD = 'NONHOLIDAY'
	/* mode( 1:등록 2:조회 ),    chk_cnt ( 마감시간 이전이면 1 이후이면 2)
	/*************************************************************************************/
	function getBusinessDay(leadtime, cnt, chk_cnt, mode){
		var ls_closetime  = "";
		$.ajax({
			url : "/sis/order/getBusinessDay.do"
			,data : { "PARAM_LEAD_TIME"  : leadtime }
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {

				    if ( mode == 1) {   /* 등록인경우만 납기일 Default세팅 */
						document.getElementById("txtDELI_DATE").value=data.gridDataList.YYYY_MM_DD;     /* 납기일을 1영업일로 세팅한다  */
					    if ( cnt == 2) {
							GLOVAL_Display2_date = data.gridDataList.YYYY_MM_DD + " (" +   data.gridDataList.DAY_WEEK  + ")";
							GLOVAL_date = data.gridDataList.YYYY_MM_DD;
							document.getElementById("BusinessDay").value= leadtime + "일 " +GLOVAL_Display2_date;
					    }
					}
					else
					{
						GLOVAL_Display2_date = data.gridDataList.YYYY_MM_DD + " (" +   data.gridDataList.DAY_WEEK  + ")";
						GLOVAL_date = data.gridDataList.YYYY_MM_DD;
						document.getElementById("BusinessDay").value= leadtime + "일 " +GLOVAL_Display2_date;
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}	

	/****************************************************************************/
    /* 추가버튼 신규입력을 위해  Document Body의 엘리먼트값을 초기화하고        */
    /* readonly 속성을 False한다                                                */
    /****************************************************************************/
	function addData(){
		$erp.clearInputInElement("table_search");
		
		//$('input').prop('readonly', true);

		//$("#txtCUSTMR_CD").attr("readonly",false); 
		//DocumentAttrReadonlyFalse();
	}
	
	/***************************************************/
	/* 그리드 조회
	/***************************************************/
	function search_ErpRightGrid(){

		erpRightLayout.progressOn();
		GLOVAL_LOAD_USE_AMT = 0;  /* 여신잔액 계산하기위함 */

		var scrin_ORD_DATE  = document.getElementById("txtORD_DATE").value;
		var scrin_SUPR_CD   = document.getElementById("hidSurp_CD").value;    /* 협력사 */
		var scrin_CUST_CD   = document.getElementById("txtCUST_CD").value;    /* 고객사 */
		var scrin_RESP_CD   = document.getElementById("txtRESP_USER").value;  /* 담당자 */
		var scrin_ORD_STATE = cmbORD_STATE.getSelectedValue();
 
		scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")
		
		console.log(" LOGIN_ORGN_DIV_TYP =>" + LOGIN_ORGN_DIV_TYP + " scrin_ORD_DATE=> " + scrin_ORD_DATE + " scrin_ORD_DATE=> " + scrin_ORD_DATE );

		$.ajax({
			 url  : "/sis/order/orderRequestSearch.do"
			,data : {
			 	         "PARAM_CUST_DIV_TYP"   : LOGIN_ORGN_DIV_TYP
				       , "PARAM_REQ_DATE"       : scrin_ORD_DATE
				       , "PARAM_REQ_CUSTMR_CD"  : scrin_CUST_CD      /* 고객사    */
				       , "PARAM_SUPR_CUSTMR_CD" : ""                 /* 협력사  20191129 winplus 센터단위로 들어아해서 null처리(WP00000020) */
				       , "PARAM_RESP_USER"      : scrin_RESP_CD      /* 담당자(취급점은 표시하지 않는다) */ 
				       , "PARAM_FLAG"           : scrin_ORD_STATE
				       , "PARAM_ORD_TYPE"       : "6"                /* 1 물류,  2직납, 3신선, 4착지, 5일배, 6긴급, 7사내소비 */
                                                                     /* A 구매반품(센터), B구매반품(직영점,직발), C구매반품(직영,센터로), D판매반품(CS), E교환반품(CS) */
					   , "PARAM_ORD_PATH"       : "3"                /* 경로 1센터, 2직영점, 3포털발주  */
					   , "PARAM_EME_YN"         : "Y"                /* 긴급발주여부                    */
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
						getLoanBAlReLoad(gridDataList);  /* 여신잔액 Reload */

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
	
	/*****************************************/
	/*  주문서 등록                         */
	/*****************************************/
	function addErpGrid(){
		openCustomerinputPopup(null);
	}
		
	/*********************************************************/
	/* 주문서 저장  C,U,D
	/*********************************************************/
	function save_ErpRightGrid(){
		
        var ls_message = "";
 	    var HEAD = $erp.dataSerialize("aaa");
	    console.log(HEAD);
	    var BODY = $erp.dataSerializeOfGridByMode(erpRightGrid,"all");   // all(전체)  state( CUD 변경부문만 처리) 
	    console.log(BODY);
		
	    var url = "/sis/order/OrderRequestCUD.do";
		
	    var send_data = {"HEAD":HEAD, "BODY":BODY};   /*  LIST MAP구조로 Controller로 넘긴다 */
		
	    var if_success = function(data){
	          console.log(" @@@@@@@@@@@@@@@@@@ result ");
	          console.log(" @@@@@@@@@@@@@@@@@@ data.gridDataList.return_code =>" + data.gridDataList.return_code);
	          
		      switch (data.gridDataList.return_code) {
		           case  "1" :  ls_message = "물류발주 마감시간이 경과되었습니다."; break;
		           case  "2" :  ls_message = "직납발주 마감시간이 경과되었습니다."; break;
		           case  "3" :  ls_message = "신선발주 마감시간이 경과되었습니다."; break;
		           case  "4" :  ls_message = "착지변경 마감시간이 경과되었습니다."; break;
		           case  "5" :  ls_message = "일배발주 마감시간이 경과되었습니다."; break;
		           case  "6" :  ls_message = "긴급발주 마감시간이 경과되었습니다."; break;
		           case  "Z" :  ls_message = "긴급주문 가능시간이 도래하지 않았습니다."; break;
		           case  "9" :  ls_message = "전일자는 발주 불가합니다."; break;
		           default :  ls_message = ""; break;
		      }
		        
		      console.log( "ls_message=>"+ ls_message );
		      
		      if ( data.gridDataList.return_code != "00" ) {
		           $erp.alertMessage({
		             "alertMessage" : ls_message,
		             "alertCode"    : null,
		             "alertType"    : "alert",
		             "isAjax"       : false,
		           });
		           return;
		      }				  
			  
			  if(data.gridDataList.return_code == "00"){
				  $erp.alertSuccessMesage(onAfterSaveErpRightGrid);
				  console.log("성공");
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
			$erp.closePopup2("openGoodsRetCsPopup");
		}
		
		var goods_nm     = "";
		var cmv_type_cd  = cmbORD_TYPE_CD.getSelectedValue();
		var cmv_type_nm  = "긴급발주";

		var scrin_ORD_DATE = document.getElementById("txtORD_DATE").value;
		var scrin_SUPR_CD  = document.getElementById("hidSurp_CD").value;     /* 협력사 */
		var scrin_SUPR_NM  = document.getElementById("Surp_Name").value;      /* 협력사 */
		scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")
		
		/* ※ 발주요청서  ORD_NO ->  주문일자 + 발주요청거래처 */
		var scrs_ORD_NO    = scrin_ORD_DATE + "_" + LOGIN_CUSTMR_CD;  

		var onClickAddData = function(erpPopupGrid) {
			
			var check = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK"));

			if  ( check == "" ) {
				$erp.closePopup2("openGoodsRetCsPopup");
				return;
			}
			
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
					var WARE_CD         = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("WARE_CD")).getValue();
					var WARE_NM         = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("WARE_NM")).getValue();
					var SUPR_CD         = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("SUPR_CD")).getValue();
					var SUPR_NM         = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("SUPR_NM")).getValue();

					var TAX_TYPE        = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("TAX_TYPE")).getValue();
					var DIMEN_NM        = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("DIMEN_NM")).getValue();
					var UNIT_QTY        = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("UNIT_QTY")).getValue();
					var GOODS_PRICE     = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("GOODS_PRICE")).getValue();
					var DSCD_TYPE       = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("DSCD_TYPE")).getValue();
                    /* 그리드에서 그리드로 이동시 UNIQUE하기위한 KEY값 */
					var OBJKEY          = BCD_CD + WARE_CD;
					var UNIT_NM         = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("UNIT_NM")).getValue();
					var MIN_PUR_QTY     = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("MIN_PUR_QTY")).getValue();
					var MIN_PUR_UNIT    = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("MIN_PUR_UNIT")).getValue();
					
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("REQ_DATE"      )).setValue(scrin_ORD_DATE);	   /* 요청일자  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_NO"        )).setValue(scrs_ORD_NO);       /* 발주번호  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_TYPE"      )).setValue(cmv_type_cd);	   /* 주문유형  */			
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_TYPE_NM"   )).setValue(cmv_type_nm);	   /* 주문유형  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("REQ_CUSTMR_CD" )).setValue(LOGIN_CUSTMR_CD);   /* 고객사    */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("CUST_NM"       )).setValue(LOGIN_CUSTMR_NM);   /* 고객사명  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("SUPR_CUSTMR_CD")).setValue(SUPR_CD);           /* 협력사cd  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("SUPR_NM"       )).setValue(SUPR_NM);           /* 협력사명  */

					/* ROW INDEX 11 ~ 20 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("BCD_CD"        )).setValue(BCD_CD);            /* 바코드 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("BCD_NM"        )).setValue(BCD_NM);            /* 상품명 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("WARE_CD"       )).setValue(WARE_CD);           /* 창고코드 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("WARE_NM"       )).setValue(WARE_NM);           /* 창고 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("TAX_TYPE"      )).setValue(TAX_TYPE);          /* 부가세 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("DIMEN_NM"      )).setValue(DIMEN_NM);          /* 규격 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("UNIT_QTY"      )).setValue(UNIT_QTY);          /* 입수량 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("GOODS_PRICE"   )).setValue(GOODS_PRICE);       /* 단가 */

					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("UNIT_NM"       )).setValue(UNIT_NM);           /* 단위 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("MIN_PUR_QTY"   )).setValue(MIN_PUR_QTY);       /* 최소주문수량 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("MIN_PUR_UNIT"  )).setValue(MIN_PUR_UNIT);      /* 최소주문단위 */
					
					/* ROW INDEX 21 ~ 30 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_CUSTMR_TYPE"   )).setValue("1");            /* 발행구분 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_CUSTMR_TYPE_NM")).setValue("PC주문");       /* 발행구분 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("RESP_USER"         )).setValue(LOGIN_EMP_NO);   /* 처리자 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("EMP_NM"            )).setValue(LOGIN_EMP_NM);   /* 요청자 */

					/* ROW INDEX 31 ~   */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("FLAG"             )).setValue("1");             /* 발주상태 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("FLAG_NM"          )).setValue("주문예정");      /* 발주상태 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORGN_DIV_CD"      )).setValue(DSCD_TYPE);       /* 조직유형 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORGN_CD"          )).setValue(DSCD_TYPE);       /* 조직코드 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("OBJKEY"           )).setValue(OBJKEY);          /* KEY   */
				}
				
			}
			
			if ( curr_row_id > 0) {
				CurrentRow = erpRightGrid.getRowsNum();
            	ObjectToEditBuffer("add");	                
			}

			erpRightLayout.progressOff();
			
			$erp.closePopup2("openGoodsRetCsPopup");
			
		}
		openGoodsPricePopup(onRowDblClicked, onClickAddData);
	}
		
  	/****************************************************************************/
    /*  상품가격 팝업조회                                                       */
    /****************************************************************************/	
	openGoodsPricePopup = function(onRowDblClicked, onClickAddData) {

  		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window("openGoodsRetCsPopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
		}
  		
  		/*****************************************************************************************************/
  		/* ※ 이부분은 아주중요함  CUST_DIV_CD파라미터는 단가를 가져오는 구분자임                             */ 
  		/* 발주를 요청하는 조직구분(ORGN_DIV_CD : Z01, Z02), 조직코드 : ORGN_CD(거래처ID)                         */ 
  		/* 협력사(공급사) 조직구분( CUST_DIV_CD : B01 이면 센터로발주)                                       */
  		/*****************************************************************************************************/
  		var url    = "/sis/order/openGoodsRetCsPopup.sis";
		var params = {    "ORGN_DIV_CD"  :  GLOVAL_ORGN_DIV_CD
				        , "ORGN_CD"      :  LOGIN_CUSTMR_CD      /* 고객사 */ 
				        , "CALL_CHANNEL" :  "P" 
				        , "CUST_DIV_CD"  :  "B01" }

		var option = {
				  "width"  : 1000
				, "height" : 700
				, "win_id" : "openGoodsRetCsPopup"
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
				"alertMessage" : "주문유형을 선택하세요.",
				"alertCode"    : null,
				"alertType"    : "error",
				"isAjax"       : false
			});
			return false;
		}
		
		var onRowDblClicked = function(id) {
			document.getElementById("ORD_NO").value  = this.cells(id, this.getColIndexById("ORD_NO")).getValue();
			$erp.closePopup2("orderPortalPopup");
		}
		
		All_checkList = "";
		Code_List     = "";
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
					All_checkList += erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("ORD_NO")).getValue();
					Code_List     +=  erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("ORD_NO")).getValue();
				} // 주문서LIST에서 선택된 값
			}
			$erp.closePopup2("orderPortalPopup");
			
			console.log("체크된 주문서번호 >> " + Code_List);
			
			if ( Code_List != "") {
				COPYandPASTE(Code_List);
			}
			//document.getElementById("ORD_NO").value = All_checkList;
			//document.getElementById("ORD_NO").value = Code_List;
		}
	    openOrderSearchPopup(onRowDblClicked, onClickAddData);
	}
	
  	/****************************************************************************/
    /*  기존발주LIST 팝업조회                                                   */
    /****************************************************************************/	
	openOrderSearchPopup = function(onRowDblClicked, onClickAddData) {

  		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window("orderPortalPopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
		}

		console.log(" GLOVAL_ORGN_DIV_CD =>" + GLOVAL_ORGN_DIV_CD + " GLOVAL_ORGN_CD=> " + GLOVAL_ORGN_CD + " GLOVAL_ORGN_DIV_TYP  => " + GLOVAL_ORGN_DIV_TYP );
		console.log(" SELECT_ORGN_CD    =>" + GLOVAL_ORGN_CD  );
		
        /* ORD_TYPE : 1:발주, 2:주문  */
  		var url    = "/sis/order/orderPortalPopup.sis";
		var params = {    "ORGN_DIV_CD"    : GLOVAL_ORGN_DIV_CD   /* LOGIN_ORGN_DIV_CD  */ 
				        , "ORGN_CD"        : GLOVAL_ORGN_CD
				        , "ORGN_DIV_TYP"   : GLOVAL_ORGN_DIV_TYP
				        , "ORD_TYPE"       : "2"   
					    , "SELECT_ORGN_CD" : GLOVAL_ORGN_CD
				     }
		var option = {
				  "width"  : 1400
				, "height" : 700
				, "win_id" : "orderPortalPopup"
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
	/* 1. 팝업에서 선택한 발주번호를 기준으로 발주내역에서 조회한다.
	/*    (상품및 수량은 가져오지만 협력사및 단가는 현재 협력사및 단가)
	/* 2. Hidden 그리드에 조회한 내역을 저장한다.
	/* 3. Hidden 그리드에서 편집그리드로 복사한다( 단 중복상품은 불가하다)
	/*****************************************************************************/
	function COPYandPASTE(ord_no_list){

		erpRightLayout.progressOn();
        var scrin_ORD_DATE = document.getElementById("txtORD_DATE").value;
        var scrin_SUPR_CD  = document.getElementById("hidSurp_CD").value;     /* 협력사 */
        var scrin_SUPR_NM  = document.getElementById("Surp_Name").value;      /* 협력사 */
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

        /* ※ 발주요청서  ORD_NO ->  주문일자 + 발주요청거래처 */
        var scrs_ORD_NO    = scrin_ORD_DATE + "_" + LOGIN_CUSTMR_CD;  		
		
		$.ajax({
			  url : "/sis/order/getSearchOrderDetailListCopy2.do"
			,data : {
				      "PARAM_ORGN_DIV_CD"  : GLOVAL_ORGN_DIV_CD   
			     	, "PARAM_ORGN_CD"      : GLOVAL_ORGN_CD
			     	, "PARAM_ORD_TYP"      : "2"                 // 1:발주, 2:주문
				    , "PARAM_ORD_NO1"      : myArray[0]          // pop화면에서 선택된 N개의 발주번호 */
				    , "PARAM_ORD_NO2"      : myArray[1]          // pop화면에서 선택된 N개의 발주번호 */
				    , "PARAM_ORD_NO3"      : myArray[2]          // pop화면에서 선택된 N개의 발주번호 */
				    , "PARAM_ORD_NO4"      : myArray[3]          // pop화면에서 선택된 N개의 발주번호 */
		    		, "PARAM_ORD_NO5"      : myArray[4]          // pop화면에서 선택된 N개의 발주번호 */
		            , "PARAM_CUSTMR_CD"   : LOGIN_CUSTMR_CD     /* 고객          */
		            , "PARAM_CUST_NM"     : LOGIN_CUSTMR_NM     /* 고객사명      */
		            , "PARAM_ORD_NO"      : scrs_ORD_NO         /* 발주번호      */
		            , "PARAM_REQ_DATE"    : scrin_ORD_DATE      /* 주문일자      */
		            , "PARAM_RESP_USER"   : LOGIN_EMP_NO        /* 로그인(처리자)*/
		            , "PARAM_EMP_NM"      : LOGIN_EMP_NM        /* 처리자명      */
		            , "PARAM_SUPR_CD"     : scrin_SUPR_CD       /* 협력사코드    */
		            , "PARAM_SUPR_NM"     : scrin_SUPR_NM       /* 협력사명      */
		            , "PARAM_CUS_TYPE"    : "1"                 /* 발행구분      */
		            , "PARAM_CUS_T_NM"    : "PC주문"            /* 발행구분명    */
		            , "PARAM_FLAG"        : "1"                 /* 처리상태      */
		            , "PARAM_FLAG_NM"     : "주문예정"          /* 처리상태명    */
		            , "PARAM_ROWNUM"      : 1                   /* 최저가로 가져오려면 2, else 999999 */
		            , "PARAM_CUST_DIV_CD" : 'B01'               /* B01물류센타로의 주문, A06신선팜으로주문, OUT외부공급사  */		    		
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
				"alertMessage" : "주문완료한 자료는 삭제 불가능합니다.",
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
		/* 주문유형 */
  		cmbORD_TYPE_CD = $erp.getDhtmlXComboCommonCode('cmbORD_TYPE_CD',   'cmbORD_TYPE_CD', ["ORD_TYPE","","EM"],   177,  "",  false, "6");
   	    $erp.objReadonly("cmbORD_TYPE_CD");  

		/* 진행상태  1:주문예정, 2:주문취소, 3:영업승인, 4:물류승인, 5:주문완료, 5:출고요청  */
		cmbORD_STATE   = $erp.getDhtmlXComboCommonCode('cmbORD_STATE',     'cmbORD_STATE',       ["ORD_STATE","ORD"] ,  177,  "모두조회",  false);   
		
	}
	
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>				
	 <div id="div_erp_20_Layout" class="samyang_div" style="display:none;">	 

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
			<div id="div_erp_left_ribbon" class="div_ribbon_full_size" style="display:none"><div id="div_erp_left_tree" class="div_tree_full_size" style="display:none"></div></div>
				 
		 </div>
	 </div>

	 
	 <div id="div_erp_23_Layout" class="samyang_div" style="display:none;">

	 <div id="div_erp_contents_search" class="samyang_div" style="display:none">
	 	  <table id="aaa" class="table_search" >
			  <colgroup>
				  <col width="140px">
				  <col width="200px">
				  	
				  <col width="140px">
				  <col width="200px">
				  
				  <col width="100px">	
				  <col width="200px">
				  
				  <col width="140px">
				  <col width="240px">

				  <col width="*">				
			  </colgroup>
			  <tr>
				  <th>주문유형</th>
				  <td>
				      <div id="cmbORD_TYPE_CD"></div>
				  </td>				 

				  <th>주문일자</th>
				  <td>
					  <input type="hidden" id="txtORD_TYPE">  <!--  주문휴형 : 1:발주, 2:주문  -->
					  <input type="hidden" id="txtORD_PATH">  <!--  주문휴형 : 1:발주, 2:주문  -->
					  <input type="hidden" id="txtORD_RESV_DATE">
				  </td>
									  <input type="text" id="txtORD_DATE" name="txtORD_DATE" class="input_common input_calendar default_date" data-position="">
				  </td>
				
				  <th>담당자명</th>
				  <td>
					  <input type="hidden" id="txtRESP_USER">
					  <input type="text" id="RESP_USER_NAME" name="RESP_USER_NAME" readonly="readonly" disabled="disabled"/>
				  </td>

				  <th>여신한도</th>
				  <td><input type="text" id="txtLOAN_LMT_AMT" name="LOAN_LMT_AMT" class="input_money" maxlength="50"  readonly="readonly"  disabled="disabled"></td>

			  </tr>
			
			  <tr>
				  <th>배송요청요일</th>
				  <td><input type="text" id="SendDay" name="SendDay" readonly="readonly"  disabled="disabled" class="input_common" maxlength="20" style="width:172px;"></td>

				  <th>리드타임</th>
				  <td><input type="text" id="BusinessDay" name="BusinessDay" readonly="readonly"  disabled="disabled" class="input_common" maxlength="20" style="width:30px; text-align: center;">(일)</td>
				
				  <th>진행상태</th>
				  <td>
				      <div id="cmbORD_STATE"></div>
				  </td>

				  <th>여신잔액</th>
				  <td><input type="text" id="txtLOAN_BAL_AMT" name="LOAN_BAL_AMT" class="input_money" maxlength="50"  readonly="readonly"  disabled="disabled"></td>

			  </tr>
			  
			  <tr>
				  <th>주문가능시간</th>
				  <td>
				      <input type="text" id="EmergGoodsDeatline" name="EmergGoodsDeatline" readonly="readonly"  disabled="disabled" class="input_common" style="width:100px; text-align: center;" >
				  </td>
			  
				  <th></th>  <!--협력사-->
				  <td>
				      <input type="hidden" id="IlbaeGoodsDeatline" name="IlbaeGoodsDeatline" readonly="readonly"  disabled="disabled" class="input_common" style="width:40px; text-align: center;" >
					  <input type="hidden" id="hidSurp_CD">
					  <input type="hidden" id="Surp_Name"  name="Surp_Name" readonly="readonly" disabled="disabled"/>
				  </td>

				  <th></th> <!--고객사-->
				  <td>
					  <input type="hidden" id="txtCUST_CD">
					  <input type="hidden" id="Cust_Name" name="Cust_Name" readonly="readonly" disabled="disabled"/>
				  </td>

				  <th>발주가능금액</th>
				  <td><input type="text" id="txtLOAN_AVL_AMT" name="LOAN_AVL_AMT" class="input_money" maxlength="50"  readonly="readonly"  disabled="disabled"></td>
			  </tr>
			
	 	  </table>
	 </div>
	 <div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	 <div id="div_erp_grid"   class="div_grid_full_size"   style="display:none"></div>
	 </div>
</body>

	
</html>