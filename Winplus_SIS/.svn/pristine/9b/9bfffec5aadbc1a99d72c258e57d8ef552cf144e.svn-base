<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js?ver=27"></script>
<script type="text/javascript">
	<%--
		※ 전역 변수 선언부 ( 공급사 포털 주문서 접수 및 출고등록 팝업호출 화면  orderSearchManage.jsp) 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbIN_WARE_CD   : Object / 입고창고  DhtmlXCombo  (CODE : WARE_CD )
		■ cmbORD_STATE : Object / 발주진행상태  DhtmlXCombo  (CODE : ORD_STATE ) 		 
		■ Create Date : 2019-08-20
		■ Modify Date :	 
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
	var LOGIN_CUSTMR_CD      =   "";
	var LOGIN_CUSTMR_NM      =   "";
	var Called_program_nm    =   "${screenDto.menu_nm}";
	
	var erpLayout;
	var erpRibbon;	
	var erpGrid;
	var erpGridBack;
	
	var erpGridColumns;
	var erpGridDataProcessor;	
	var cmbIN_WARE_CD;              /* 입고창고           */
	var cmbORD_STATE;               /* 발주진행상태       */
	var erpGridSelectedCustmr_cd;   /* 그리드 rowSelected */

	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;

	var SELECT_REQ_DATE  = "";
	var SELECT_DIS_DATE  = "";
	var SELECT_SUPR_CD   = "";
	var SELECT_ORD_TYPE  = "";
	var SELECT_ORD_NO    = "";
	var SELECT_ORD_STATE = "";
	var SELECT_CUST_NM   = "";
	
	$(document).ready(function(){		
		initErpLayout();
		getLoginOrgInfo();
		//initErpRibbon();
		initErpRibbon();
		initErpGrid();
		initErpGridBack();		
		
		console.log(" Called Menu => " + Called_program_nm);
		 
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
				  {id: "a", text: "${menuDto.menu_nm}", header:true, height:65}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		//erpLayout.cells("d").attachObject("div_erp_grid_back");
		
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
			        LOGIN_CUSTMR_CD      =   data.gridDataList.CUSTMR_CD;
			        LOGIN_CUSTMR_NM      =   data.gridDataList.CUSTMR_NM;
			        
					document.getElementById("hidSurp_CD").value  = data.gridDataList.CUSTMR_CD;
					document.getElementById("Custmr_Name").value = data.gridDataList.CUSTMR_NM;
			        
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
						, {id : "excel_erpGri3",  type : "button", text:'주문취소',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "excel_erpGri6",  type : "button", text:'출고등록',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "print_erpGrid",  type : "button", text:'거래명세서출력',                          isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif",   disable : true}		
				]}	
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "excel_erpGrid"){
		    } else if (itemId == "excel_erpGri3"){
		    	ProcessConfirm("2");     /* 취소 */
		    } else if (itemId == "excel_erpGri6"){
		    	CallorderOutInputPopup();   /* 출고등록 팝업호출 */
		    } else if (itemId == "print_erpGrid"){
		    	printTradeStatement();
		    }
		});
	}
	
	/*********************************************************/
	/* 상태변경전 Confirm
	/*********************************************************/
	function ProcessConfirm(change_ord_statge){
		var alertMessage = '<spring:message code="alert.common.proceedData" />';
		var alertCode = "";
		var alertType = "alert";
		var callbackFunction = function(){
			var crud = "D";
			save_mast_update(change_ord_statge); 
		}
		
		$erp.confirmMessage({
			"alertMessage" : alertMessage
			, "alertCode" : alertCode
			, "alertType" : alertType
			, "alertCallbackFn" : callbackFunction
		});
		
	}
	
		
	/****************************************************************************/
    /* 더블클릭시 발주서(입력/수정) 팝업화면 호출                               */
    /****************************************************************************/	
	function CallorderOutInputPopup(){
		
		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window("orderOutInputPopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
		}
		
	    console.log(" ====SELECT_REQ_DATE  =>" + SELECT_REQ_DATE  + " SELECT_SUPR_CD =>" + SELECT_SUPR_CD + " SELECT_DIS_DATE =>" + SELECT_DIS_DATE);
	    console.log(" ====SELECT_ORD_TYPE  =>" + SELECT_ORD_TYPE  + " SELECT_ORD_NO  =>" + SELECT_ORD_NO);
	    console.log(" ====SELECT_ORD_STATE =>" + SELECT_ORD_STATE + " SELECT_CUST_NM =>" + SELECT_CUST_NM);
		
		var url    = "/sis/supplyportal/orderOutInputPopup.sis";
		var params = {    "LOGIN_REQ_DATE"  : SELECT_REQ_DATE
                        , "LOGIN_DIS_DATE"  : SELECT_DIS_DATE
		                , "LOGIN_SUPR_CD"   : SELECT_SUPR_CD
		                , "LOGIN_ORD_TYPE"  : SELECT_ORD_TYPE
				        , "LOGIN_ORD_NO"    : SELECT_ORD_NO
				        , "LOGIN_ORD_STATE" : SELECT_ORD_STATE
				        , "LOGIN_CUST_NM"   : SELECT_CUST_NM
		              }
		
		var option =  {
						"win_id" : "orderOutInputPopup",
						"width"  : 1500,
						"height" : 900
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

	/*********************************************************/
	/* 발주 요청건 상태Update
	/*********************************************************/
	function save_mast_update(change_ord_statge){
		
		var erpGridRowCount  = erpGrid.getRowsNum();
		var select_cnt       = 0;

		console.log("erpGridRowCount => " + erpGridRowCount);

		$erp.clearDhtmlXGrid(erpGridBack);
		
		var check_rows = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
		var check_list = check_rows.split(",");
		
		if(check_rows == ""){
			$erp.alertMessage({
				"alertMessage" : "1건이상의 주문서를 선택 후 이용가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
			return false;
		} 
		
		
		for(var i = 0 ; i < check_list.length ; i++){
			if(i == 0){
				
				var leftRid     = erpGrid.cells(check_list[i], erpGrid.getColIndexById("NO")).getValue();

				var ORGN_DIV_CD  = erpGrid.cells(leftRid, erpGrid.getColIndexById("ORGN_DIV_CD"  )).getValue();		
				var ORGN_DIV_TYP = erpGrid.cells(leftRid, erpGrid.getColIndexById("ORGN_DIV_TYP" )).getValue();		
				var ORGN_CD      = erpGrid.cells(leftRid, erpGrid.getColIndexById("ORGN_CD"      )).getValue();
				var ORD_NO       = erpGrid.cells(leftRid, erpGrid.getColIndexById("ORD_NO"       )).getValue();	
				var ORD_STATE    = erpGrid.cells(leftRid, erpGrid.getColIndexById("ORD_STATE"    )).getValue();	
				var ORD_TYPE     = erpGrid.cells(leftRid, erpGrid.getColIndexById("ORD_TYPE"     )).getValue();	
				var IN_WARE_CD   = erpGrid.cells(leftRid, erpGrid.getColIndexById("IN_WARE_CD"   )).getValue();	
				
				var TOT_AMT      = erpGrid.cells(leftRid, erpGrid.getColIndexById("TOT_AMT"      )).getValue();	
				var SUPR_CD      = erpGrid.cells(leftRid, erpGrid.getColIndexById("SUPR_CD"      )).getValue();	
                var Commit_flag  = "";
                
				/* 주문서요청서 번호는 발주수 요청서 번호의 19자리를 취한다 */
				/* EX 20191103_WP00000003_0000000182                        */
				var par_ord_no  = ORD_NO.substring( 0, 19 );
				
				/*  발주마스터 취소는 요청서 상태를 저장으로 처리함 */
				if  ( change_ord_statge == "2" ) {
					Commit_flag = "1";
				}   else {
					Commit_flag = change_ord_statge;
				}
				
                console.log("leftRid=>" + leftRid + " Commit_flag =>" + Commit_flag  + " SUPR_CD=>" + SUPR_CD + " ORD_STATE => " + ORD_STATE);
				
				if  ( change_ord_statge != ORD_STATE ) {
				    select_cnt = select_cnt + 1;
					erpGridBack.addRow(select_cnt);
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("ORGN_DIV_CD"  )).setValue(ORGN_DIV_CD);
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("ORGN_DIV_TYP" )).setValue(ORGN_DIV_TYP);
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("ORGN_CD"      )).setValue(ORGN_CD);
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("ORD_NO"       )).setValue(ORD_NO);
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("ORD_STATE"    )).setValue(change_ord_statge);
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("REG_ID"       )).setValue(LOGIN_EMP_NO);
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("IN_WARE_CD"   )).setValue(IN_WARE_CD);      /* 입고창고 취급점은 거래처코드 */
					
					/* 2019-11-03  T_REQ_GOODS_TMP 주문요청서 처리상태 Update용 */
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("FLAG"           )).setValue(Commit_flag);   /* 요청상태 */
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("PARAM_ORD_NO"   )).setValue(par_ord_no);    /* 주문번호 */
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("PARAM_CUST_NO"  )).setValue(SUPR_CD);       /* 공급사코드 */
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("PARAM_CURR_FLAG")).setValue(ORD_STATE);     /* 현재상태 */
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("TOT_AMT"        )).setValue(TOT_AMT);       /* 처리금액 */
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("PARAM_ORD_TYPE" )).setValue(ORD_TYPE);      /* 발주유형 */
				}
			
			}

		}

			
			
		
		console.log(" select_cnt =>" + select_cnt);
		
		if  (select_cnt > 0 )
		{
			var BODY = $erp.dataSerializeOfGridByMode(erpGridBack,"all");   // all(전체)  state( CUD 변경부문만 처리) 
			console.log(BODY);

			var url       = "/sis/order/OrderStateUpdate.do";
			var send_data = {"BODY":BODY};    /*  LIST MAP구조로 Controller로 넘긴다 */
			
			var if_success = function(data){
				erpLayout.progressOff();
				if($erp.isEmpty(data.result)){
					$erp.alertMessage({
						"alertMessage" : 'info.common.saveSuccess',
						"alertType" : "alert",
						"isAjax" : true,
						"alertCallbackFn" : function(){
							searchErpGrid();
						},
						"alertCallbackFnParam" : []
					});
				
				}else{
					$erp.alertMessage({
						"alertMessage" : 'info.common.saveSuccess',
						"alertType" : "alert",
						"isAjax" : true,
						"alertCallbackFn" : function(){
							searchErpGrid();
						},
						"alertCallbackFnParam" : []
					});
				}
			}
			
			var if_error = function(data){
				$erp.ajaxErrorMessage(data);
			}
            erpLayout.progressOn();			
			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
		}
	}	
	
	/****************************************************************************/
    /* erpGrid 초기화                                                           */
    /****************************************************************************/	
	function initErpGrid(){
		erpGridColumns = [
			      {id : "NO"               , label:["NO"                , "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
				, {id : "CHECK"            , label:["선택"              , "#rspan"], type: "ra", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
				, {id : "ORGN_DIV_CD"      , label:["조직영역코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_DIV_TYP"     , label:["조직영역코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_CD"          , label:["조직코드"          , "#text_filter"], type: "ro", width: "220", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_NO"           , label:["주문번호"          , "#text_filter"], type: "ro", width: "200", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "OUT_WARE_CD"      , label:["출고창고코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "IN_WARE_CD"       , label:["입고창고코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "IN_WARE_NM"       , label:["고객사"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "SUPR_CD"          , label:["협력사코드"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "SUPR_NM"          , label:["협력사명"          , "#text_filter"], type: "ro", width: "160", sort : "str", align : "left",   isHidden : false, isEssential : true}
				//, {id : "PROJ_CD"          , label:["프로젝트코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				//, {id : "PROJ_NM"          , label:["프로젝트명"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "SUPR_AMT"         , label:["공급가액"          , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"          , label:["부가세"            , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"          , label:["합계금액"          , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "GOODS_NM"         , label:["발주상품"          , "#text_filter"], type: "ro", width: "200", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "RESV_DATE"        , label:["납기일자"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "REQ_DATE"         , label:["발주일자"          , "#text_filter"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "ORD_TYPE"         , label:["발주유형"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_TYPE_NM"      , label:["발주유형"          , "#text_filter"], type: "ro", width: "80" , sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "ORD_STATE"        , label:["발주상태"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_STATE_NM"     , label:["발주상태"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "RETN_YN"          , label:["반품여부"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "SEND_FAX_STATE"   , label:["FAX발송"           , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true, isEssential : true}
				, {id : "SEND_EMAIL_STATE" , label:["Email발송"         , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true, isEssential : true}
				, {id : "RESP_USER"        , label:["담당자코드"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "EMP_NM"           , label:["담당자명"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "ORGN_DIV_NM"      , label:["조직영역이름"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_DIV_TYP"     , label:["조직영역유형"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_NM"          , label:["조직명"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
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
			var IN_WARE_CD   = this.cells(rowId, this.getColIndexById("IN_WARE_CD")).getValue()
			var IN_WARE_NM   = this.cells(rowId, this.getColIndexById("IN_WARE_NM")).getValue()
			
			openCustomerinputPopup(ORD_NO, ORGN_DIV_CD, ORGN_DIV_NM, ORGN_DIV_TYP, ORGN_CD, ORGN_NM, IN_WARE_CD,IN_WARE_NM);
		});
		
		erpGrid.attachEvent("onCheck", function(rowId, cInd){
		
			console.log(" ======== onClick rowId =>" + rowId + " cInd =>" + cInd);
			SELECT_REQ_DATE  = this.cells(rowId, this.getColIndexById("REQ_DATE")).getValue()
			SELECT_DIS_DATE  = this.cells(rowId, this.getColIndexById("REQ_DATE")).getValue()
			SELECT_REQ_DATE  = SELECT_REQ_DATE.replace (/-/g, "");
			SELECT_SUPR_CD   = this.cells(rowId, this.getColIndexById("SUPR_CD")).getValue()
			SELECT_ORD_TYPE  = this.cells(rowId, this.getColIndexById("ORD_TYPE")).getValue()
			SELECT_ORD_NO    = this.cells(rowId, this.getColIndexById("ORD_NO")).getValue()

			SELECT_ORD_STATE = this.cells(rowId, this.getColIndexById("ORD_STATE")).getValue()
			SELECT_CUST_NM   = this.cells(rowId, this.getColIndexById("IN_WARE_NM")).getValue()
		});


	}

	function initErpGridBack(){
		erpGridColumns = [
				  {id : "ORGN_DIV_CD"      , label:["조직영역코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_DIV_TYP"     , label:["조직영역코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_CD"          , label:["조직코드"          , "#text_filter"], type: "ro", width: "220", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_NO"           , label:["주문번호"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "ORD_STATE"        , label:["진행상태"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "REG_ID"           , label:["처리자"            , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "PARAM_PROGRM"     , label:["프로그램"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "IN_WARE_CD"       , label:["입고창고코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				
				/**  20191103  T_REQ_GOODS_TMP  주문요청서 처리상태 UPDATE 위해 */
				, {id : "FLAG"             , label:["요청상태"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "PARAM_ORD_NO"     , label:["주문번호"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "PARAM_CUST_NO"    , label:["공급사코드"        , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "PARAM_CURR_FLAG"  , label:["현재상태"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "PARAM_ORD_TYPE"   , label:["발주유형"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "TOT_AMT"          , label:["합계금액"          , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : true, isEssential : true,  numberFormat : "0,000"}
				
		];
		
		erpGridBack = new dhtmlXGridObject({
			parent: "div_erp_grid_back"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
		});		
	}

	
	/****************************************************************************/
    /* 더블클릭시 발주서(입력/수정) 팝업화면 호출                               */
    /****************************************************************************/	
	function openCustomerinputPopup(ORD_NO, ORGN_DIV_CD, ORGN_DIV_NM, ORGN_DIV_TYP, ORGN_CD, ORGN_NM, IN_WARE_CD,IN_WARE_NM){
		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window("openOrderInputGridPopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
		}

		var url    = "/common/popup/openOrderInputGridPopup.sis";
		var params = {    "SELECT_ORGN_DIV_CD"  : ORGN_DIV_CD
		                , "SELECT_ORGN_DIV_NM"  : ORGN_DIV_NM
		                , "SELECT_ORGN_DIV_TYP" : ORGN_DIV_TYP
				        , "SELECT_ORGN_CD"      : ORGN_CD
				        , "LOGIN_ORGN_NM"       : ORGN_NM
				        , "LOGIN_ORD_NO"        : ORD_NO 
				        , "LOGIN_ORGN_DIV_CD"   : LOGIN_ORGN_DIV_CD
		                , "LOGIN_ORGN_CD"       : LOGIN_ORGN_CD
		                , "LOGIN_ORGN_DIV_TYP"  : LOGIN_ORGN_DIV_TYP
				        , "LOGIN_CUSTMR_CD"     : IN_WARE_CD      /* 고객사 : 거래처포털에서만 사용 */
				        , "LOGIN_CUSTMR_NM"     : IN_WARE_NM      /* 고객명 : 거래처포털에서만 사용 */
		              }
		
		var option =  {
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
	
	
	
	/***************************************************/
	/* 그리드 조회
	/***************************************************/
	function searchErpGrid(){

		erpLayout.progressOn();
		
		var scrin_searchordStrDt  = document.getElementById("searchordStrDt").value;
		var scrin_searchordEndDt  = document.getElementById("searchordEndDt").value;
		scrin_searchordStrDt      = scrin_searchordStrDt.replace (/-/g, "")
		scrin_searchordEndDt      = scrin_searchordEndDt.replace (/-/g, "")
		var scrin_Surp_CD         = document.getElementById("hidSurp_CD").value;
		
		var scrn_ORGN_DIV_CD      = LOGIN_ORGN_DIV_CD;
		var scrn_ORGN_CD          = LOGIN_ORGN_CD;
		var scrn_MENU             = "SP";

        $.ajax({
			url : "/sis/supplyportal/getSearchOrderList.do"
			,data : {
						  "PARAM_ORGN_DIV_CD"      : "B01"
						, "PARAM_ORGN_CD"          : ""
						, "PARAM_ORD_STR_YYYYMMDD" : scrin_searchordStrDt
						, "PARAM_ORD_END_YYYYMMDD" : scrin_searchordEndDt
						, "PARAM_ORD_NO"           : ""
						, "PARAM_DEL_STR_YYYYMMDD" : ""
						, "PARAM_DEL_END_YYYYMMDD" : ""
						, "PARAM_PROJ_CD"          : ""
						, "PARAM_IN_WARE_CD"       : ""
						, "PARAM_OUT_WARE_CD"      : ""
						, "PARAM_SUPR_CD"          : scrin_Surp_CD
						, "PARAM_RESP_USER"        : ""
						, "PARAM_ORD_TYPE"         : ""          /*  2019-11-03 null처리  1: 물류발주, 2:직납발주, 3:신선발주, 4.착지변경   */
						, "LOGIN_CHANNEL"          : "P"         /*  S: SIS,  P:PORTAL */
					    , "LOGIN_MENU"             : scrn_MENU   /*  호출메뉴 SP 공급사포털  */
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
	/* COMBO박스처리 
	/***************************************************/
	function initDhtmlXCombo(){
		/* 발주진행상태 */
		cmbORD_STATE   = $erp.getDhtmlXComboCommonCode('cmbORD_STATE',   'cmbORD_STATE',  'ORD_STATE',   177,  "모두조회",  true);
		
		/*
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, true, null, function(){
		   cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 135, "AllOrOne", false, null);
		   cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
		      cmbORGN_CD.unSelectOption();
		      cmbORGN_CD.clearAll();
		      $erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
		   }); 
		});
		*/
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	/***************************************************/
	/* 거래명세서출력
	/***************************************************/
	function printTradeStatement() {
		var order_cd_list = "";
		var selected_orgn_div_cd = "";
		var selected_search_date_from = $("#searchordStrDt").val();
		var selected_search_date_to = $("#searchordEndDt").val();
		var check_rows = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
		var check_list = check_rows.split(",");
		
		if(check_rows == ""){
			$erp.alertMessage({
				"alertMessage" : "1건이상의 주문서를 선택 후 이용가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		} else {
		
			for(var i = 0 ; i < check_list.length ; i++){
				if(i == 0){
					order_cd_list += erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORD_NO")).getValue();
					selected_orgn_div_cd += erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORGN_DIV_CD")).getValue();
				} else {
					order_cd_list += "," + erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORD_NO")).getValue();
					selected_orgn_div_cd += "," + erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORGN_DIV_CD")).getValue();
				}
			}
			
			var paramInfo = {
					"ORD_CD_LIST" : order_cd_list
					, "mrdPath" : "trade_statement_mrd"
					, "mrdFileName" : "cs_trade_statement.mrd"
					, "ORGN_DIV_CD" : selected_orgn_div_cd
					, "SEARCH_DATE_FROM" : selected_search_date_from
					, "SEARCH_DATE_TO" : selected_search_date_to
			};
			
			var approvalURL = $CROWNIX_REPORT.openCsTradeStatement("", paramInfo, "거래명세서출력", "");
			var popObj = window.open(approvalURL, "cs_trade_statement_popup", "width=900,height=1000");
			
			popObj.location.href="https://sis-dev.win-plus.co.kr/";
			var frm = document.PrintTradeform;
			frm.action = approvalURL;
			frm.target = "cs_trade_statement_popup";
			frm.submit();
		}
	}
</script>
</head>
<body>
	<form name="PrintTradeform" action="" method="post"></form>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search" id="aaa">
			<colgroup>
				<col width="100px">
				<col width="100px">
				<col width="100px">
				<col width="100px">
				<col width="100px">	
				<col width="100px">	
				<col width="100px">	
				
				<col width="*">				
			</colgroup>
			<tr>
				<th>주문기간</th>
				<td colspan="2">
					<input type="text" id="searchordStrDt" name="searchordStrDt" class="input_common input_calendar" > ~
					<input type="text" id="searchordEndDt" name="searchordEndDt" class="input_common input_calendar">
				</td>
				
				<th>공급사명</th>
				<td colspan="2">
					<input type="hidden" id="hidSurp_CD">
					<input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled"/>
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
	<div id="div_erp_grid_back"   class="div_grid_full_size"   style="display:none"></div>
	
</body>

	
</html>