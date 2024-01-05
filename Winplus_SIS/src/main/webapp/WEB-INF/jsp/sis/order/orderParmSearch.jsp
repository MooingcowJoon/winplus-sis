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
		□ 프로그램명 : 팜 발주서 lIST조회
		□ 최종UPDATE : 2019-09-25
		※ 전역 변수 선언부 
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

	
	$(document).ready(function(){		
		initErpLayout();
		initErpRibbon();
		getLoginOrgInfo();
		initErpGrid();
		initErpGridBack();		
		
		document.getElementById("searchordStrDt").value=today;
		//document.getElementById("searchordEndDt").value=today;
				
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
						, {id : "excel_erpGri3",  type : "button", text:'발주취소',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "excel_erpGri1",  type : "button", text:'email발송',                               isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "excel_erpGri2",  type : "button", text:'Fax발송',                                 isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "excel_erpGrid"){
		    	$erp.exportGridToExcel({
		    		"grid" : erpGrid
					, "fileName" : "주문취합및발주(팜)"
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
		    } else if (itemId == "excel_erpGri3"){
	     	   ProcessConfirm("2");     /* 발주취소 */
		    }
		    
		});
	}
	

	/*********************************************************/
	/* 상태변경전 Confirm
	/*********************************************************/
	function ProcessConfirm(change_ord_statge){
        /* 주문취소건은 WMS상태를 체크하여 WMS정송완료건은 취소 불가능하도록 한다 */		
		var erpGridRowCount  = erpGrid.getRowsNum();
		var select_cnt       = 0;

		if ( change_ord_statge == "2") {
			for(var i = 0; i < erpGridRowCount; i++){
				var leftRid    = erpGrid.getRowId(i);
				var check      = erpGrid.cells(leftRid, erpGrid.getColIndexById("CHECK")).getValue();
				if(check == 1){
				   select_cnt = select_cnt + 1;
				}
			}		
			
		}
		
	    if ( select_cnt == 0 ) {
			$erp.alertMessage({
				"alertMessage" : "취소할 대상이 없습니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
			return false;
	    }
	    
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
	
	/*********************************************************/
	/* 발주 요청건 상태Update
	/*********************************************************/
	function save_mast_update(change_ord_statge){

		var erpGridRowCount  = erpGrid.getRowsNum();
		var select_cnt       = 0;
		console.log("erpGridRowCount => " + erpGridRowCount);

		$erp.clearDhtmlXGrid(erpGridBack);
		
		for(var i = 0; i < erpGridRowCount; i++){

			var leftRid    = erpGrid.getRowId(i);
			var check      = erpGrid.cells(leftRid, erpGrid.getColIndexById("CHECK")).getValue();

			if(check == 1){
				var ORGN_DIV_CD  = erpGrid.cells(leftRid, erpGrid.getColIndexById("ORGN_DIV_CD"  )).getValue();		
				var ORGN_DIV_TYP = erpGrid.cells(leftRid, erpGrid.getColIndexById("ORGN_DIV_TYP" )).getValue();		
				var ORGN_CD      = erpGrid.cells(leftRid, erpGrid.getColIndexById("ORGN_CD"      )).getValue();
				var REQ_DATE     = erpGrid.cells(leftRid, erpGrid.getColIndexById("REQ_DATE"     )).getValue();	
			  	REQ_DATE         = REQ_DATE.replace (/-/g, "")
				
				var ORD_NO       = erpGrid.cells(leftRid, erpGrid.getColIndexById("ORD_NO"       )).getValue();	
				var ORD_STATE    = erpGrid.cells(leftRid, erpGrid.getColIndexById("ORD_STATE"    )).getValue();	
				var ORD_TYPE     = erpGrid.cells(leftRid, erpGrid.getColIndexById("ORD_TYPE"     )).getValue();	
				var IN_WARE_CD   = erpGrid.cells(leftRid, erpGrid.getColIndexById("IN_WARE_CD"   )).getValue();	
				
				var SUPR_CD      = erpGrid.cells(leftRid, erpGrid.getColIndexById("SUPR_CD"      )).getValue();	
				var TOT_AMT      = erpGrid.cells(leftRid, erpGrid.getColIndexById("TOT_AMT"      )).getValue();	
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
				
                console.log("Commit_flag =>" + Commit_flag  + " SUPR_CD=>" + SUPR_CD + " ORD_STATE => " + ORD_STATE);
				  
				
				if  ( change_ord_statge != ORD_STATE ) {
				    select_cnt = select_cnt + 1;
					erpGridBack.addRow(select_cnt);
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("ORGN_DIV_CD"  )).setValue(ORGN_DIV_CD);
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("ORGN_DIV_TYP" )).setValue(ORGN_DIV_TYP);
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("ORGN_CD"      )).setValue(ORGN_CD);
					erpGridBack.cells(select_cnt, erpGridBack.getColIndexById("REQ_DATE"     )).setValue(REQ_DATE);
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

	
	/***************************************************/
	/*  직영점에서 요청한건을 집계처리함
	/***************************************************/
	function make_total_process(){

		erpLayout.progressOn();
		
		var param_ord_dt  = document.getElementById("searchordStrDt").value;
		param_ord_dt      = param_ord_dt.replace (/-/g, "")
	    
		$.ajax({
			 url  : "/sis/order/insertOrdTemp.do"
			,data : {
					   "PARAM_ORD_DATE"  : param_ord_dt
					}
			,method   : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.alertMessage({
						"alertMessage" : "집계처리중 오류 발생 전산실로 문의바랍니다.",
						"alertCode"    : "집계처리",
						"alertType"    : "error",
						"isAjax"       : false,
					});
				} else {
					
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
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
				, {id : "ORD_NO"           , label:["주문번호"          , "#text_filter"], type: "ro", width: "200", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "IN_WARE_CD"       , label:["입고창고코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "IN_WARE_NM"       , label:["입고창고"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true, isEssential : true}
				, {id : "SUPR_CD"          , label:["협력사코드"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "SUPR_NM"          , label:["협력사명"          , "#text_filter"], type: "ro", width: "160", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "SUPR_AMT"         , label:["공급가액"          , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT"              , label:["부가세"            , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"          , label:["합계금액"          , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "GOODS_NM"         , label:["발주상품"          , "#text_filter"], type: "ro", width: "280", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "RESV_DATE"        , label:["납기예정일"        , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "REQ_DATE"         , label:["발주일자"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
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
			
			var SUPR_CD      = this.cells(rowId, this.getColIndexById("SUPR_CD")).getValue()
		
				openCustomerinputPopup(ORD_NO, ORGN_DIV_CD, ORGN_DIV_NM, ORGN_DIV_TYP, ORGN_CD, ORGN_NM);
		});
		
		
	}
	
	/****************************************************************************/
    /* erpGridBack 초기화                                                           */
    /****************************************************************************/	
	function initErpGridBack(){
		erpGridColumns = [
				  {id : "ORGN_DIV_CD"      , label:["조직영역코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_DIV_TYP"     , label:["조직영역코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_CD"          , label:["조직코드"          , "#text_filter"], type: "ro", width: "220", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "REQ_DATE"         , label:["발주일자"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "ORD_NO"           , label:["주문번호"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "ORD_STATE"        , label:["진행상태"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "REG_ID"           , label:["처리자"            , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "IN_WARE_CD"       , label:["입고창고코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				
				/**  20191103  T_REQ_GOODS_TMP  주문요청서 처리상태 UPDATE 위해 */
				, {id : "FLAG"             , label:["요청상태"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "PARAM_ORD_NO"     , label:["주문번호"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "PARAM_CUST_NO"    , label:["공급사코드"        , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "PARAM_CURR_FLAG"  , label:["현재상태"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "TOT_AMT"          , label:["합계금액"          , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : true, isEssential : true,  numberFormat : "0,000"}
				, {id : "PARAM_ORD_TYPE"   , label:["발주유형"          , "#text_filter"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true , isEssential : true}
		];
		
		erpGridBack = new dhtmlXGridObject({
			parent: "div_erp_grid_back"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
		});		
	}	

	/****************************************************************************/
    /* 더블클릭시 직영점 발주서(입력/수정) 팝업화면 호출                       */
    /****************************************************************************/	
	function openCustomerinputPopup(ORD_NO, ORGN_DIV_CD, ORGN_DIV_NM, ORGN_DIV_TYP, ORGN_CD, ORGN_NM){
		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window("orderInputGridPopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
			
		}
		
		var url = "/sis/order/orderInputGridPopup.sis";
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
				"win_id" : "orderInputGridPopup",
				"width"  : 1400,
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
	
	
	
	/***************************************************/
	/* 그리드 조회
	/***************************************************/
	function searchErpGrid(){

		erpLayout.progressOn();
		
		var scrin_searchordStrDt  = document.getElementById("searchordStrDt").value;
		
		scrin_searchordStrDt      = scrin_searchordStrDt.replace (/-/g, "")
		var scrin_ORD_NO          = document.getElementById("txtORD_NO").value;

		var scrn_ORGN_DIV_CD      = "";
		var scrn_ORGN_CD          = "";
		
	    if ( LOGIN_ORGN_DIV_TYP == "C" ) {
	    	scrn_ORGN_DIV_CD  = LOGIN_ORGN_DIV_CD;
	    	scrn_ORGN_CD      = LOGIN_ORGN_CD;
	    }
	    
		$.ajax({
			url : "/sis/order/getOrderParmSearchList.do"
			,data : {
						  "PARAM_ORGN_DIV_CD"      : scrn_ORGN_DIV_CD
						, "PARAM_ORGN_CD"          : scrn_ORGN_CD
						, "PARAM_ORGN_DIV_TYP"     : LOGIN_ORGN_DIV_TYP
						, "PARAM_ORD_STR_YYYYMMDD" : scrin_searchordStrDt
						, "PARAM_ORD_NO"           : scrin_ORD_NO
						, "PARAM_IN_WARE_CD"       : ""
						, "PARAM_ORD_TYPE"         : "2"         /* 1: 발주, 2:주문   */
						, "LOGIN_CHANNEL"          : "S"         /* S: SIS,  P:PORTAL(팜으로의 주문은 영업관리에서만 한다) */
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
	/* COMBO박스처리 
	/***************************************************/
	function initDhtmlXCombo(){
		
		/* 발주진행상태 */
		// cmbORD_STATE   = $erp.getDhtmlXComboCommonCode('cmbORD_STATE',   'cmbORD_STATE',  'ORD_STATE',   177,  "모두조회",  true);
		
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
				<th>주문일자</th>
				<td colspan="2">
					<input type="text" id="searchordStrDt" name="searchordStrDt" class="input_common input_calendar" >
				</td>
				
				<th>주문번호</th>
				<td colspan="2"><input type="text" id="txtORD_NO" name="ORD_NO" class="input_common" maxlength="20" ></td>


			</tr>
			
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid"   class="div_grid_full_size"   style="display:none"></div>
	<div id="div_erp_grid_back"   class="div_grid_full_size"   style="display:none"></div>
</body>

	
</html>