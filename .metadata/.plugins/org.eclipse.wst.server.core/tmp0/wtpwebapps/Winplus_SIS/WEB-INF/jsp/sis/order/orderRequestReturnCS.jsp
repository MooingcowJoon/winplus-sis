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
		※ 전역 변수 선언부( orderRequestReturnCS.jsp  취급점매반품 프로그램 )
		□ 변수명 : Type / Description
		■ erpRightLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpRightGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbOUT_WARE_CD : Object / 출고창고 DhtmlXCombo  (CODE : CENTER_CD )
		■ cmbORD_STATE : Object / 진행상태  (CODE : ORD_STATE ) 		 
	--%>
	//var thisPopupWindow = parent.erpPopupWindows.window('orderPortalGridPopup');
	
	var CurrentRow = 0;
	var erpRightLayout;
	var erpRightRibbon;	
	var erpRightGrid;
	var erpRightGridColumns;
	var erpRightGridDataProcessor;	
	var cmbOUT_WARE_CD;                  /* 출고창고           */
	var cmbORD_TYPE_CD;                  /* 반품유형           */
	var cmbRESN_CD    ;                  /* 사내소비사유코드   */
	
	var cmbORD_STATE;                    /* 진행상태           */
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
	var GLOVAL_SUPR_CD     = "";        /* 협력사코드 */
	var GLOVAL_SUPR_NM     = "";        /* 협력사이름 */

	
    /*  본사조직으로 로그인후  직영점 선택시 처리하기 위함 */
	var GLOVAL_ORGN_DIV_CD  = "";
	var GLOVAL_ORGN_CD      = "";
	var GLOVAL_ORGN_NM      = "";
	var GLOVAL_ORGN_DIV_TYP = "";

	var All_checkList = "";
	var Code_List = "";

	var GLOVAL_leadtime      = 2;       /* 반품리드타임 기본 2일 */
	var GLOVAL_closetime     = "";      /* 반품마감시간 */
	var GLOVAL_Display1_date = "";
	var GLOVAL_Display2_date = "";
    var	GLOVAL_CHK_CNT       = 1;
    
	var SELECT_LVL           =  "";
	var SELECT_GRUP_TOP_CD   =  "";
	var SELECT_GRUP_MID_CD   =  "";
	var SELECT_GRUP_BOT_CD   =  "";

	$(document).ready(function(){		

		initerpRightLayout();
		initErpRightRibbon();
		
		initErpBackGrid();   // 복사용 Buffer그리드 
		initErpRightGrid();  // 반품서 편집용그리드
		//initDhtmlXCombo();
		
		document.getElementById("txtORD_PATH").value = "1";  /* 반품경로 P(포털), 1, 센터/본사, 2직영점 */
		
		getLoginOrgInfo();
        		
	});
	

	/***************************************************/
	/* Login Id 조직 및 권한구하기 
	/***************************************************/
	function getLoginOrgInfo( ){
		erpRightLayout.progressOn();
		$.ajax({
			url : "/sis/order/getLoginOrgInfo.do"
			,data : { "LoginID"  : "" }
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightLayout.progressOff();
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

					console.log("LOGIN_ORGN_DIV_CD=>"   + LOGIN_ORGN_DIV_CD);          
					console.log("LOGIN_ORGN_DIV_NM=>"   + LOGIN_ORGN_DIV_NM);          
					console.log("LOGIN_ORGN_DIV_TYP=>"  + LOGIN_ORGN_DIV_TYP);          
					console.log("LOGIN_ORGN_CD=>"       + LOGIN_ORGN_CD);          
					console.log("LOGIN_ORGN_NM=>"       + LOGIN_ORGN_NM);          
					console.log("LOGIN_EMP_NO=>"        + LOGIN_EMP_NO);          
					console.log("LOGIN_EMP_NM=>"        + LOGIN_EMP_NM);  
					console.log("LOGIN_CUSTMR_CD=>"     + LOGIN_CUSTMR_CD);          
					console.log("LOGIN_CUSTMR_NM=>"     + LOGIN_CUSTMR_NM);  
					
					initDhtmlXCombo();

					document.getElementById("txtORD_DATE").value     = today;
			        document.getElementById("txtCUST_CD").value      = LOGIN_CUSTMR_CD;    /* 고객cd */
			        document.getElementById("Cust_Name").value       = LOGIN_CUSTMR_NM;    /* 고객명 */
			        
			        document.getElementById("txtRESP_USER").value    = LOGIN_EMP_NO;      /* 처리자 */
			        document.getElementById("RESP_USER_NAME").value  = LOGIN_EMP_NM;      /* 처리자명 */
			        
			        search_ErpRightGrid();
			       
				}
			}, error : function(jqXHR, textStatus, errorThrown){
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
		
		switch (cmv_type_cd) {
	       case "D" :  cmv_type_nm = "구매반품"; cmv_call_nm = "B01"; break;    
	       case "E" :  cmv_type_nm = "교환반품"; cmv_call_nm = "B01"; break;  
	       default  :  cmv_type_nm = ""; break;
	    }  				
		
		var scrin_ORD_DATE = document.getElementById("txtORD_DATE").value;
		scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")
		
		/* ※ 반품요청서  ORD_NO ->  반품일자 + 반품요청거래처 */
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
					        , "PARAM_ORD_NO"      : scrs_ORD_NO         /* 반품번호      */
					        , "PARAM_REQ_DATE"    : scrin_ORD_DATE      /* 반품일자      */
					        , "PARAM_ORD_TYPE"    : cmv_type_cd         /* 주문유형      */
					        , "PARAM_ORD_TYPE_NM" : cmv_type_nm         /* 주문유형명    */
					        , "PARAM_RESP_USER"   : LOGIN_EMP_NO        /* 로그인(처리자)*/
					        , "PARAM_EMP_NM"      : LOGIN_EMP_NM        /* 처리자명      */
					        , "PARAM_SUPR_CD"     : scrin_SUPR_CD       /* 협력사코드    */
					        , "PARAM_SUPR_NM"     : ""                  /* scrin_SUPR_NM    협력사명   @@@@@@@@@@@@@@@@@@@@@@@@@@@   */
					        , "PARAM_CUS_TYPE"    : "1"                 /* 발행구분      */
					        , "PARAM_CUS_T_NM"    : "PC주문"            /* 발행구분명    */
						    , "PARAM_FLAG"        : "1"                 /* 처리상태      */
							, "PARAM_FLAG_NM"     : "반품예정"          /* 처리상태명    */
	                        , "PARAM_ROWNUM"      : 1                   /* 최저가로 가져오려면 2, else 999999 */
							, "PARAM_CUST_DIV_CD" : cmv_call_nm         /* B01물류센타로의 주문, A06신선팜으로주문, OUT외부공급사  */
					        , "PARAM_GOODS_TYPE"  : cmv_type_cd
					        /* 1물류, 2직납, 3신선, 4착지 5일배, 6긴급, 7사내소비 A센터구매품 B직영점(직발)구매반품 C센터판매반품, D판매반품CS, E교환반푼CS*/
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
					    /* 대상을 가져와서 입력영역으로 옮길때 DataProcess CUD => C    반품할 DataProcess의 CUD상태를 일괄 C로 처리한다.     */
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
    /* 1-3.erpRightLayout 초기화                                                */
    /****************************************************************************/	
	function initerpRightLayout(){
		erpRightLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				  {id: "a", text: "구매반품등록", header:true,  height:65}
				, {id: "b", text: ""      , header:false, fix_size:[true, true]}
				, {id: "c", text: ""      , header:false}
			]		
		});
		
		erpRightLayout.cells("a").attachObject("div_erp_contents_search");
		erpRightLayout.cells("b").attachObject("div_erp_ribbon");
		erpRightLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightLayout.cells("c").attachObject("div_erp_grid");
		erpRightLayout.setSeparatorSize(1, 0);
				
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
						, {id : "excel_erpGri2",      type : "button", text:'반품완료',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
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
		    	
		    } else if (itemId == "print_erpGrid"){

		    } else if (itemId == "excel_erpGri2"){
		    	insertSelectPurordandGoodsConfirm(); // 반품확정
		    }
		});
		
	}
		
	/****************************************************************************/
    /* 반품요청서에서 반품서 쪽으로 Insert                                      */
    /****************************************************************************/	
	function insertSelectPurordandGoodsConfirm(){

		if(!isCheckedValidate()) { return false; }
		
		var alertCode = "";
		var alertType = "alert";
		var callbackFunction = function(){
			insertSelectPurordandGoods();
		}
		
		$erp.confirmMessage({
			  "alertMessage" : "정말 반품 완료하시겠습니까?"
			, "alertCode" : alertCode
			, "alertType" : alertType
			, "alertCallbackFn" : callbackFunction
		});
		
	}	
	
	/****************************************************************************/
    /* 반품요청서 Insert Confirm                                                */
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
				"alertMessage" : "임시저장할 반품예정건이 존재하지 않습니다.",
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
			  "alertMessage" : "<br>미입력 수량 및 반품완료건은 저장되지 않습니다.<br/> 정말 임시저장 하시겠습니까?"
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
				"alertMessage" : "대상 선택을 하지않았거나 반품완료할 발주예정건이 없습니다.",
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
    /* 반품요청서에서 반품서 쪽으로 Insert                                      */
    /****************************************************************************/	
	function insertSelectPurordandGoods(){		
	    console.log("===========insertSelectPurordandGoods1===============");
	    $erp.clearDhtmlXGrid(erpBackGrid); //기존데이터 삭제
	    
		$erp.copyRowsGridToGrid(erpRightGrid, erpBackGrid, 
			      [ "NO"              ,     "REQ_DATE"     ,  "ORD_NO"          ,   "ORD_SEQ"      ,   "ORD_TYPE"        ,   "ORD_TYPE_NM"     ,
			        "REQ_CUSTMR_CD"   ,     "CUST_NM"      ,  "SUPR_CUSTMR_CD"  ,   "SUPR_NM"      ,   "BCD_CD"          ,   "WARE_CD"         ,
			        "TAX_TYPE"        ,     "DIMEN_NM"     ,  "UNIT_QTY"        ,   "REQ_QTY"      ,   "GOODS_PRICE"     ,
			        "SUPR_AMT"        ,     "VAT_AMT"      ,  "TOT_AMT"         ,   "RESV_DATE"    ,   "LAND_CHG_TYPE"   ,   "MEMO"            ,
			        "ORD_CUSTMR_TYPE" ,     "RESP_USER"    ,  "FLAG"            ,   "ORGN_DIV_CD"  ,   "ORGN_CD"         ,   "COMP_TOT_AMT" ],
			      [ "NO"              ,     "REQ_DATE"     ,  "ORD_NO"          ,   "ORD_SEQ"      ,   "ORD_TYPE"        ,   "ORD_TYPE_NM"     ,
			        "REQ_CUSTMR_CD"   ,     "CUST_NM"      ,  "SUPR_CUSTMR_CD"  ,   "SUPR_NM"      ,   "BCD_CD"          ,   "WARE_CD"         ,
			        "TAX_TYPE"        ,     "DIMEN_NM"     ,  "UNIT_QTY"        ,   "REQ_QTY"      ,   "GOODS_PRICE"     ,
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
			        "REQ_QTY"      ,  "GOODS_PRICE"     ,   "SUPR_AMT"     ,   "VAT_AMT"         ,   "TOT_AMT"            ,
			        "RESV_DATE"    ,  "LAND_CHG_TYPE"   ,   "MEMO"         ,   "ORD_CUSTMR_TYPE" ,   "ORD_CUSTMR_TYPE_NM" ,   "RESP_USER"  , 
			        "EMP_NM"       ,  "FLAG"            ,   "FLAG_NM"      ,   "ORGN_DIV_CD"     ,   "ORGN_CD"             ,  "UNIT_NM" ],
			        
			      [ "OBJKEY"       ,  "CHECK"           ,   "REQ_DATE"     ,   "ORD_NO"          ,   "ORD_SEQ"             ,  "ORD_TYPE"   ,
			    	"ORD_TYPE_NM"  ,  "REQ_CUSTMR_CD"   ,   "CUST_NM"      ,   "SUPR_CUSTMR_CD"  ,   "SUPR_NM"             ,  "BCD_CD"     ,
			    	"BCD_NM"       ,  "WARE_CD"         ,   "WARE_NM"      ,   "TAX_TYPE"        ,   "DIMEN_NM"            ,  "UNIT_QTY"   ,
			        "REQ_QTY"      ,  "GOODS_PRICE"     ,   "SUPR_AMT"     ,   "VAT_AMT"         ,   "TOT_AMT"             ,
			        "RESV_DATE"    ,  "LAND_CHG_TYPE"   ,   "MEMO"         ,   "ORD_CUSTMR_TYPE" ,   "ORD_CUSTMR_TYPE_NM"  ,  "RESP_USER"  , 
			        "EMP_NM"       ,  "FLAG"            ,   "FLAG_NM"      ,   "ORGN_DIV_CD"     ,   "ORGN_CD"             ,  "UNIT_NM" ],
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

    /******************************************************************************************************/
    /* 마감시간 체크후 반품확정Data로 저장  ( T_REQ_GOODS_TMP -> T_PUR_ORD, T_PUR_ORD_GOODS)로  Insert  )
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
              if(data.gridDataList.return_code == "00"){
                  $erp.alertSuccessMesage(onAfterSaveErpRightGrid);
                  console.log("성공");
              }
          }
  	    
          var if_error = function(data){
              $erp.ajaxErrorMessage(data);
          }
          
          $erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpRightLayout);

    }
	
	/****************************************************************************/
    /* erpRightGrid 초기화                                                      */
    /****************************************************************************/	
	function initErpRightGrid(){
		erpRightGridColumns = [
			      {id : "NO"                   , label:["NO"                , "#rspan"]      ,   type: "cntr", width:  "30", sort : "int", align : "right",  isHidden : false, isEssential : false}
				, {id : "CHECK"                , label:["#master_checkbox"  , "#rspan"]      ,   type: "ch"  , width:  "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
				, {id : "REQ_DATE"             , label:["요청일자"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}			
				, {id : "ORD_NO"               , label:["반품번호"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : true , isEssential : true}
		   	    , {id : "ORD_SEQ"              , label:["일련번호"          , "#text_filter"],   type: "ron" , width:  "60", sort : "int", align : "right",  isHidden : true , isEssential : true}
				, {id : "ORD_TYPE"             , label:["반품유형"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : true,   isEssential : true, commonCode : "ORD_TYPE"}			
				, {id : "ORD_TYPE_NM"          , label:["반품유형"          , "#select_filter"], type: "ro"  , width:  "80", sort : "str", align : "left",   isHidden : false ,  isEssential : false}			
				, {id : "FLAG_NM"              , label:["진행상태"          , "#select_filter"], type: "ro"  , width:  "80", sort : "str", align : "center", isHidden : false ,  isEssential : true}
				, {id : "REQ_CUSTMR_CD"        , label:["고객사CD"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true , isEssential : true}			
				, {id : "CUST_NM"              , label:["고객사명"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true , isEssential : false}			
				, {id : "SUPR_CUSTMR_CD"       , label:["협력사코드"        , "#text_filter"],   type: "ro"  , width:  "80", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "SUPR_NM"              , label:["협력사명"          , "#select_filter"], type: "ed"  , width: "120", sort : "str", align : "left",   isHidden : true , isEssential : false}

				/* ROW INDEX 11 ~ 20 */
				, {id : "BCD_CD"               , label:["바코드"            , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "BCD_NM"               , label:["상품명"            , "#text_filter"],   type: "ed"  , width: "250", sort : "str", align : "left",   isHidden : false, isEssential : false}			
				, {id : "WARE_CD"              , label:["창고코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "WARE_NM"              , label:["창고"              , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false , isEssential : false}
				, {id : "TAX_TYPE"             , label:["과세여부"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : false, isEssential : false}
				, {id : "DIMEN_NM"             , label:["규격"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "UNIT_QTY"             , label:["입수량"            , "#text_filter"],   type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "REQ_QTY"              , label:["수량"              , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "UNIT_NM"              , label:["단위"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			

				/* ROW INDEX 21 ~ 30 */
				, {id : "GOODS_PRICE"          , label:["단가"              , "#text_filter"],   type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}			
				, {id : "SUPR_AMT"             , label:["공급가액"          , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"              , label:["부가세"            , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"              , label:["합계금액"          , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "RESV_DATE"            , label:["반품예정일"        , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false,  isEssential : false}			
				, {id : "LAND_CHG_TYPE"        , label:["착지변경"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}			
				, {id : "RESN_CD"              , label:["사유"              , "#select_filter"], type: "combo", width:"100", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "RETURN_RESN_CD"}			
				, {id : "MEMO"                 , label:["적요"              , "#text_filter"],   type: "ed"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}
				//, {id : "DSCD_TYPE"          , label:["반품가능"          , "#text_filter"],   type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : false, isEssential : true}			
				//, {id : "RESN_CD"            , label:["반품사유코드"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_CUSTMR_TYPE"      , label:["발행구분"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "ORD_CUSTMR_TYPE_NM"   , label:["발행구분"          , "#select_filter"], type: "ro"  , width: "80" , sort : "str", align : "left",   isHidden : true,   isEssential : false}
				, {id : "RESP_USER"            , label:["처리자"            , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true  , isEssential : true}

				/* ROW INDEX 31  */
				, {id : "EMP_NM"               , label:["요청자"            , "#select_filter"], type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false , isEssential : false}
				, {id : "FLAG"                 , label:["반품상태"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,    isEssential : false}
				, {id : "ORGN_DIV_CD"          , label:["조직유형"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}			
				, {id : "ORGN_CD"              , label:["조직코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}			
				, {id : "OBJKEY"               , label:["BCD+공급사CD"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true,   isEssential : false}			
				, {id : "COMP_TOT_AMT"         , label:["합계금액 비교용"   , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : true , isEssential : true,  numberFormat : "0,000"}
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
		// erpRightGrid.enableLightMouseNavigation(true);
		
		//erpRightGrid.enableDistributedParsing(true, 100, 24);
		$erp.attachDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);
		erpRightGridDataProcessor =$erp.initGrid(erpRightGrid);
		$erp.initGridDataColumns(erpRightGrid);
		
		/* onCellChanged onEditCell */ 
		erpRightGrid.attachEvent("onEditCell", function(stage,rId,cInd,nValue,oValue) {

			if ( stage == "2") {
			    var rowIdName =  erpRightGrid.getRowId(cInd);
			    var ll_REQ_QTY     = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("REQ_QTY"     )).getValue();
			    var ll_GOODS_PRICE = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("GOODS_PRICE" )).getValue();
			    var ll_TAX_TYPE    = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("TAX_TYPE"    )).getValue();
			    var ll_use_amt     = 0;

				if ( ll_REQ_QTY < 0  )  {
					ll_REQ_QTY = ll_REQ_QTY * -1;
					erpRightGrid.cells(rId, erpRightGrid.getColIndexById("REQ_QTY"     )).setValue(ll_REQ_QTY);
				}
				
				if ( ll_GOODS_PRICE < 0  ) {
					ll_GOODS_PRICE = ll_GOODS_PRICE * -1;
					erpRightGrid.cells(rId, erpRightGrid.getColIndexById("GOODS_PRICE" )).setValue(ll_GOODS_PRICE);
				}
				
			    /*  공급가액( 단가에 VAT포함 됨 ) */
			    var ll_TOT_AMT  = ll_REQ_QTY  *  ll_GOODS_PRICE;
			    var ll_SUPR_AMT = 0;
			    var ll_VAT      = 0;
			    if  ( ll_TAX_TYPE == "Y") {
			    	ll_SUPR_AMT       = Math.round(ll_TOT_AMT / 1.1 );
			    	ll_VAT            = ll_TOT_AMT  - ll_SUPR_AMT;
			    }  else {
			    	ll_SUPR_AMT       = ll_TOT_AMT;
			    }
			    
			    console.log( " ll_SUPR_AMT : " + ll_SUPR_AMT + " ll_VAT : " + ll_VAT);
			    
			    erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUPR_AMT"   )).setValue(ll_SUPR_AMT);
				erpRightGrid.cells(rId, erpRightGrid.getColIndexById("VAT_AMT"    )).setValue(ll_VAT);
				erpRightGrid.cells(rId, erpRightGrid.getColIndexById("TOT_AMT"    )).setValue(ll_TOT_AMT);

				$erp.setDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);
	
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
    /* erpBackGrid 초기화                                                      */
    /****************************************************************************/	
	function initErpBackGrid(){
		erpBackGridColumns = [
		          {id : "NO"                   , label:["NO"                , "#rspan"]      ,   type: "cntr", width:  "30", sort : "int", align : "right",  isHidden : false, isEssential : false}
				, {id : "CHECK"                , label:["#master_checkbox"  , "#rspan"]      ,   type: "ch"  , width:  "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
				, {id : "REQ_DATE"             , label:["요청일자"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : true}			
				, {id : "ORD_NO"               , label:["요청번호"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : false , isEssential : true}
		   	    , {id : "ORD_SEQ"              , label:["일련번호"          , "#text_filter"],   type: "ron" , width:  "60", sort : "int", align : "right",  isHidden : false , isEssential : true}
				, {id : "ORD_TYPE"             , label:["반품유형"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : false,  isEssential : true, commonCode : "ORD_TYPE"}			
				, {id : "ORD_TYPE_NM"          , label:["반품유형"          , "#select_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false, isEssential : false}			
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
				, {id : "REQ_QTY"              , label:["수량"              , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "UNIT_NM"              , label:["단위"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			

				/* ROW INDEX 21 ~ 30 */
				, {id : "GOODS_PRICE"          , label:["단가"              , "#text_filter"],   type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}			
				, {id : "SUPR_AMT"             , label:["공급가액"          , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"              , label:["부가세"            , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"              , label:["합계금액"          , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "RESV_DATE"            , label:["납기예정일"        , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false,  isEssential : false}			
				, {id : "LAND_CHG_TYPE"        , label:["착지변경"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "RESN_CD"              , label:["사유"              , "#select_filter"], type: "combo", width:"100", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "RETURN_RESN_CD"}			
				, {id : "MEMO"                 , label:["적요"              , "#text_filter"],   type: "ed"  , width: "100", sort : "str", align : "right",  isHidden : false,  isEssential : false}
				//, {id : "DSCD_TYPE"          , label:["반품가능"          , "#text_filter"],   type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : false, isEssential : true}			
				//, {id : "RESN_CD"            , label:["반품사유코드"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_CUSTMR_TYPE"      , label:["발행구분"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "ORD_CUSTMR_TYPE_NM"   , label:["발행구분"          , "#select_filter"], type: "ro"  , width: "80" , sort : "str", align : "left",   isHidden : false,  isEssential : false}
				, {id : "RESP_USER"            , label:["처리자"            , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false , isEssential : true}

				/* ROW INDEX 31  */
				, {id : "EMP_NM"               , label:["요청자"            , "#select_filter"], type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false,  isEssential : false}
				, {id : "FLAG"                 , label:["반품상태"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "FLAG_NM"              , label:["반품상태"          , "#select_filter"], type: "ro"  , width: "80",  sort : "str", align : "center", isHidden : false,  isEssential : true}
				, {id : "ORGN_DIV_CD"          , label:["조직유형"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "ORGN_CD"              , label:["조직코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
				, {id : "OBJKEY"               , label:["BCD+공급사CD"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false,  isEssential : false}			
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
	
	/***************************************************/
	/* 그리드 조회
	/***************************************************/
	function search_ErpRightGrid(){

		erpRightLayout.progressOn();
		GLOVAL_LOAD_USE_AMT = 0;  /* 여신잔액 계산하기위함 */

		var scrin_ORD_DATE  = document.getElementById("txtORD_DATE").value;
		var scrin_CUST_CD   = ""; /* @@@@@@@@@@@@@@@@@@@@@@@@@@ */
		var scrin_RESP_CD   = document.getElementById("txtRESP_USER").value;  /* 담당자 */
		var scrin_ORD_STATE = cmbORD_STATE.getSelectedValue();
		var scrin_ORD_TYPE  = cmbORD_TYPE_CD.getSelectedValue();

		scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")
		
		console.log(" LOGIN_ORGN_DIV_TYP =>" + LOGIN_ORGN_DIV_TYP + " scrin_ORD_DATE=> " + scrin_ORD_DATE + " scrin_ORD_DATE=> " + scrin_ORD_DATE );
		console.log(" ORD_TYPE =>" + scrin_ORD_TYPE );

		$.ajax({
			 url  : "/sis/order/orderRequestSearch.do"
			,data : {
			 	         "PARAM_CUST_DIV_TYP"   : LOGIN_ORGN_DIV_TYP
				       , "PARAM_REQ_DATE"       : scrin_ORD_DATE
				       , "PARAM_REQ_CUSTMR_CD"  : scrin_CUST_CD      /* 고객사    */
				       , "PARAM_SUPR_CUSTMR_CD" : ""                 /* 협력사  20191129 winplus 센터단위로 들어아해서 null처리(WP00000020) */
				       , "PARAM_RESP_USER"      : scrin_RESP_CD      /* 담당자(취급점은 표시하지 않는다) */ 
				       , "PARAM_FLAG"           : scrin_ORD_STATE
				       , "PARAM_ORD_TYPE"       : scrin_ORD_TYPE     /* 1 물류,  2직납, 3신선, 7사내소비, A센터구매품 B직영점(직발)구매반품 C센터판매반품, D판매반품CS, E교환반푼CS */
					   , "PARAM_ORD_PATH"       : "3"                /* 발주를 조회하는 경로 1센터, 2직영점, 3포털발주  6긴급발주  */
					   , "PARAM_RET_YN"         : "Y"                /* 반품여부  */
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
	/*  반품서 등록                         */
	/*****************************************/
	function addErpGrid(){
		openCustomerinputPopup(null);
	}
		
	/*********************************************************/
	/* 반품서 저장  C,U,D
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
		           case  "1" :  ls_message = "구매반품 마감시간이 경과되었습니다."; break;
		           case  "2" :  ls_message = "구매반품 마감시간이 경과되었습니다."; break;
		           case  "9" :  ls_message = "전일자는 구매반품 불가합니다."; break;
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
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpRightLayout);

	}
			
	/*********************************************************/
	/* 반품상품 저장후 재조회
	/*********************************************************/
	function onAfterSaveErpRightGrid(){
		search_ErpRightGrid();
	}
	
	/****************************************************************************/
    /*  상품 가격팝업창에서 Current로 반품내역에서 복사                         */
    /****************************************************************************/	
	function GoodsPricePopup_TO_ErpRightGrid(){

		var scrs_RESN_CD   = cmbRESN_CD.getSelectedValue();
	    var cmv_select_cd  = cmbORD_TYPE_CD.getSelectedValue();
  		var ls_popup       = "";
		if   (cmv_select_cd  == "D")  {
			 ls_popup       = "openGoodsRetCsPopup";
		}
		else  {
			 ls_popup       = "openGoodsReturnPopup";   /* 교환반품*/
		}	    
	    
		var goods_nm       = "";
		var cmv_type_cd    = "";
		var cmv_type_nm    = "";
		var scrin_SUPR_CD  = "";
		var scrin_SUPR_NM  = "";
		
		var scrin_ORD_DATE = document.getElementById("txtORD_DATE").value;
		GLOVAL_SUPR_CD     = "";
		GLOVAL_SUPR_NM     = "";
		scrin_ORD_DATE     = scrin_ORD_DATE.replace (/-/g, "")
		
		if(cmv_select_cd.length == 0){
			$erp.alertMessage({
				"alertMessage" : "반품유형을 선택하세요."
				, "alertCode"  : null
				, "alertType"  : "alert"
				, "isAjax"     : false
			});
			return false;
		}
				
		if(scrs_RESN_CD.length == 0){
			$erp.alertMessage({
				"alertMessage" : "반품사유를 선택하세요."
				, "alertCode"  : null
				, "alertType"  : "alert"
				, "isAjax"     : false
			});
			return false;
		}


		var onRowDblClicked = function(id) {
			//document.getElementById("ORD_NO").value  = this.cells(id, this.getColIndexById("GOODS_NO")).getValue();
			$erp.closePopup2( ls_popup );
		}
		
		if   (cmv_select_cd  == "D") { cmv_type_nm = "구매반품" }
		else if  (cmv_select_cd  == "E") { cmv_type_nm = "교환반품" }
		else cmv_type_nm = "";

		/* ※ 반품요청서  ORD_NO ->  반품일자 + 반품요청거래처 */
		var scrs_ORD_NO    = scrin_ORD_DATE + "_" + LOGIN_CUSTMR_CD;  
		
		var onClickAddData = function(erpPopupGrid) {
			
			var check = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK"));

			if  ( check == "" ) {
			    $erp.closePopup2( ls_popup );
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
					scrin_SUPR_CD       = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("SUPR_CD")).getValue();
					scrin_SUPR_NM       = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("SUPR_NM")).getValue();
					
					var TAX_TYPE        = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("TAX_TYPE")).getValue();
					var DIMEN_NM        = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("DIMEN_NM")).getValue();
					var UNIT_QTY        = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("UNIT_QTY")).getValue();
					var GOODS_PRICE     = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("GOODS_PRICE")).getValue();
					var DSCD_TYPE       = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("DSCD_TYPE")).getValue();
                    /* 그리드에서 그리드로 이동시 UNIQUE하기위한 KEY값 */
					var OBJKEY          = BCD_CD + WARE_CD;
					var UNIT_NM         = erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("UNIT_NM")).getValue();
					
					console.log( " WARE_CD => " + WARE_CD + " WARE_NM => " + WARE_NM + " scrin_SUPR_CD=>" + scrin_SUPR_CD);
					
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("REQ_DATE"      )).setValue(scrin_ORD_DATE);	   /* 요청일자  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_NO"        )).setValue(scrs_ORD_NO);       /* 반품번호  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_TYPE"      )).setValue(cmv_select_cd);	   /* 반품유형  */			
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_TYPE_NM"   )).setValue(cmv_type_nm);	   /* 반품유형  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("REQ_CUSTMR_CD" )).setValue(LOGIN_CUSTMR_CD);   /* 고객사    */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("CUST_NM"       )).setValue(LOGIN_CUSTMR_NM);   /* 고객사명  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("SUPR_CUSTMR_CD")).setValue(scrin_SUPR_CD);     /* 협력사cd  */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("SUPR_NM"       )).setValue(scrin_SUPR_NM);     /* 협력사명  */

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
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("RESN_CD"       )).setValue(scrs_RESN_CD);      /* 사유 */
					
					/* ROW INDEX 21 ~ 30 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_CUSTMR_TYPE"   )).setValue("1");            /* 발행구분 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORD_CUSTMR_TYPE_NM")).setValue("PC주문");       /* 발행구분 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("RESP_USER"         )).setValue(LOGIN_EMP_NO);   /* 처리자 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("EMP_NM"            )).setValue(LOGIN_EMP_NM);   /* 요청자 */

					/* ROW INDEX 31 ~   */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("FLAG"             )).setValue("1");             /* 반품상태 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("FLAG_NM"          )).setValue("반품예정");      /* 반품상태 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORGN_DIV_CD"      )).setValue(DSCD_TYPE);       /* 조직유형 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("ORGN_CD"          )).setValue(DSCD_TYPE);       /* 조직코드 */
					erpBackGrid.cells(curr_row_id, erpBackGrid.getColIndexById("OBJKEY"           )).setValue(OBJKEY);          /* KEY   */
				}
				
			}
			
			if ( curr_row_id > 0) {
				CurrentRow = erpRightGrid.getRowsNum();
                if ( CurrentRow == 0 ) {
    				ObjectToEditBuffer("new");	                
                } else {
    				ObjectToEditBuffer("add");	                
                }
			} 

			erpRightLayout.progressOff();
			
			$erp.closePopup2( ls_popup );
			
		}
		//erpRightLayout.progressOn();
		openGoodsPricePopup(onRowDblClicked, onClickAddData);
	}
		
  	/****************************************************************************/
    /*  상품가격 팝업조회                                                       */
    /****************************************************************************/	
	openGoodsPricePopup = function(onRowDblClicked, onClickAddData) {

	    var cmv_select_cd  = cmbORD_TYPE_CD.getSelectedValue();
  		var ls_popup       = "";
		if   (cmv_select_cd  == "D")  {
			 ls_popup       = "openGoodsRetCsPopup";
		}
		else  {
			 ls_popup       = "openGoodsReturnPopup";   /* 교환반품*/
		}
  		
  		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window( ls_popup );
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
		}

  		var url       =   "";
		var ls_custmr =   "";
		var ll_width  =   1000;
		
		if   (cmv_select_cd  == "D")  {
			 url       = "/sis/order/openGoodsRetCsPopup.sis";   /* openGoodsPricePopup*/
		}
		else  {
			 url       = "/sis/order/openGoodsReturnPopup.sis";   /* 교환반품*/
			 ls_custmr = LOGIN_CUSTMR_CD;
			 ll_width  = 1200;
		}
		
  		/*****************************************************************************************************/
  		/* ※ 이부분은 아주중요함  CUST_DIV_CD파라미터는 단가를 가져오는 구분자임                             */ 
  		/* 반품를 요청하는 조직구분(ORGN_DIV_CD : Z01, Z02), 조직코드 : ORGN_CD(거래처ID)                         */ 
  		/* 협력사(공급사) 조직구분( CUST_DIV_CD : B01 이면 센터로반품)                                       */
  		/*****************************************************************************************************/
		var params = {    "ORGN_DIV_CD"  :  GLOVAL_ORGN_DIV_CD
				        , "ORGN_CD"      :  LOGIN_CUSTMR_CD      /* 고객사(발주요청하는 거래처 ) */ 
				        , "CALL_CHANNEL" :  "S"                  /* S영업관리, P CS포털 */ 
				        , "CUST_DIV_CD"  :  "B01"
				        , "CUST_CD"      :  ls_custmr            /* 공급사코드 */
				        , "CUST_NM"      :  ""                   /* 공급사이름 */
		              }
		
		var option = {
				  "width"  : ll_width
				, "height" : 700
				, "win_id" : ls_popup
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
  	
	/*********************************************************/
	/* 반품상품 삭제처리(그리드상에서만 삭제)
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
				"alertMessage" : "반품완료한 자료는 삭제 불가능합니다.",
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
        /* 직영점 반품유형  */  
		cmbORD_TYPE_CD = $erp.getDhtmlXComboCommonCode('cmbORD_TYPE_CD',   'cmbORD_TYPE_CD', ["ORD_TYPE","","","CS"],   177,  "모두조회",  false, "8");
		/* 진행상태  1:반품예정, 2:주문취소, 3:영업승인, 4:물류승인, 5:주문완료, 6:출고요청  */
		cmbORD_STATE   = $erp.getDhtmlXComboCommonCode('cmbORD_STATE',     'cmbORD_STATE',       ["ORD_STATE","ORD"] ,  177,  "모두조회",  false);   

		/* 반품 사유코드  */
		cmbRESN_CD     = $erp.getDhtmlXComboCommonCode('cmbRESN_CD',       'cmbRESN_CD',    'RETURN_RESN_CD',   177,  "",  false, "01");   
	
	}
	
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>				
	 
	 <div id="div_erp_contents_search" class="samyang_div" style="display:none">
	 	  <table id="aaa" class="table_search" >
			  <colgroup>
				  <col width="80px">
				  <col width="180px">
				  	
				  <col width="90px">
				  <col width="100px">
				  
				  <col width="90px">
				  <col width="180px">
				  
				  <col width="90px">	
				  <col width="180px">
				  
				  <col width="90px">
				  <col width="200px">

				  <col width="*">				
			  </colgroup>
			  <tr>
	 
				  <th>반품유형</th>
				  <td>
				      <div id="cmbORD_TYPE_CD"></div>
				  </td>
	 
				  <th>요청일자</th>
				  <td>
					  <input type="hidden" id="txtORD_PATH">  <!--  주문휴형 : 1:반품, 2:주문  -->
					  <input type="hidden" id="txtORD_RESV_DATE">
					  <input type="text" id="txtORD_DATE" name="txtORD_DATE" class="input_common input_calendar default_date" data-position="">
				  </td>
				
				  <th>담당자명</th>
				  <td>
					  <input type="hidden" id="txtRESP_USER">
					  <input type="text" id="RESP_USER_NAME" name="RESP_USER_NAME" readonly="readonly" disabled="disabled"/>
					  <input type="hidden" id="txtCUST_CD">
					  <input type="hidden" id="Cust_Name" name="Cust_Name" readonly="readonly" disabled="disabled"/>
				  </td>

				  <th>반품사유</th>
				  <td>
				      <div id="cmbRESN_CD"></div>
				  </td>
				  <th>진행상태</th>
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