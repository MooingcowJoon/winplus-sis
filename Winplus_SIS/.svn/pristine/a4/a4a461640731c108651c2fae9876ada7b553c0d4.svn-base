<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js?ver=30"></script>
<script type="text/javascript">
	<%--
	    ※ 프로그램명 및 최종Update일자 (거래처 포탈에서의 센터로 주문  2019-09-06 12:00:00 )
		※ 전역 변수 선언부 (거래처 포탈에서의 센터로 주문  2019-09-06 12:00:00 )		
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbOUT_WARE_CD : Object / 출고창고 DhtmlXCombo  (CODE : CENTER_CD )
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
	
	var erpLayout;
	var erpRibbon;	
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;	
	var cmbOUT_WARE_CD;             /* 출고창고           */
	var cmbORD_STATE;               /* 발주진행상태       */
	var erpGridSelectedCustmr_cd;   /* 그리드 rowSelected */

	var today     = $erp.getToday("");
	var thisYear  = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay   = today.substring(6,8);
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
					LOGIN_ORGN_DIV_CD    =   data.gridDataList.ORGN_DIV_CD;
					LOGIN_ORGN_DIV_NM    =   data.gridDataList.ORGN_DIV_CD_NM;
					LOGIN_ORGN_DIV_TYP   =   data.gridDataList.ORGN_DIV_TYPE;
			        LOGIN_ORGN_CD        =   data.gridDataList.DEPT_CD;
			        LOGIN_ORGN_NM        =   data.gridDataList.ORGN_NM;
			        LOGIN_EMP_NO         =   data.gridDataList.EMP_NO;
			        LOGIN_EMP_NM         =   data.gridDataList.EMP_NM;
			        LOGIN_CUSTMR_CD      =   data.gridDataList.CUSTMR_CD;
			        LOGIN_CUSTMR_NM      =   data.gridDataList.CUSTMR_NM;
			        
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
						//, {id : "excel_erpGrid",  type : "button", text:'<spring:message code="ribbon.excel" />',  isbig : false, img : "menu/excel.gif",  imgdis : "menu/excel_dis.gif",  disable : true}
						//, {id : "excel_erpGri1",  type : "button", text:'email발송',                               isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						//, {id : "excel_erpGri2",  type : "button", text:'Fax발송',                                 isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "print_erpGrid", type : "button", text:'주문서 출력',   isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif",   disable : true}		
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "add_erpGrid"){
		    	addErpGrid();
		    } else if (itemId == "add_erpGrid1"){
		    	addErpGrid1();
		    } else if (itemId == "delete_erpGrid"){
		    	//deleteErpGrid();
		    } else if (itemId == "save_erpGrid"){
		    	//saveErpGrid();
		    } else if (itemId == "excel_erpGrid"){
		    	
		    } else if (itemId == "excel_erpGri1"){
		    	
		    } else if (itemId == "excel_erpGri2"){
		    	
		    } else if (itemId == "print_erpGrid"){
		    	printOrderSheet();
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
				, {id : "ORGN_CD"          , label:["조직코드"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_NO"           , label:["주문번호"          , "#text_filter"], type: "ro", width: "220", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "OUT_WARE_CD"      , label:["출고창고코드"      , "#text_filter"], type: "ro", width: "180", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "IN_WARE_CD"       , label:["고객사코드"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "IN_WARE_NM"       , label:["고객사"            , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "SUPR_CD"          , label:["협력사코드"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "SUPR_NM"          , label:["협력사명"          , "#text_filter"], type: "ro", width: "160", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "SUPR_AMT"         , label:["공급가액"          , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"          , label:["부가세"            , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"          , label:["합계금액"          , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "GOODS_NM"         , label:["발주상품"          , "#text_filter"], type: "ro", width: "240", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "RESV_DATE"        , label:["납기일자"          , "#text_filter"], type: "ro", width: "90",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "REQ_DATE"         , label:["발주일자"          , "#text_filter"], type: "ro", width: "90",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "ORD_TYPE"         , label:["발주유형"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_TYPE_NM"      , label:["발주유형"          , "#text_filter"], type: "ro", width: "80" , sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "ORD_STATE"        , label:["발주상태"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_STATE_NM"     , label:["발주상태"          , "#text_filter"], type: "ro", width: "70",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "RETN_YN"          , label:["반품여부"          , "#text_filter"], type: "ro", width: "70",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "SEND_FAX_STATE"   , label:["FAX발송"           , "#text_filter"], type: "ro", width: "70",  sort : "str", align : "center", isHidden : true, isEssential : true}
				, {id : "SEND_EMAIL_STATE" , label:["Email발송"         , "#text_filter"], type: "ro", width: "70",  sort : "str", align : "center", isHidden : true, isEssential : true}
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
			
			openCustomerinputPopup(ORD_NO, "1", ORGN_DIV_CD, ORGN_DIV_NM, ORGN_DIV_TYP, ORGN_CD, ORGN_NM,IN_WARE_CD,IN_WARE_NM);
		});
		
		
	}
	
	/****************************************************************************/
    /* 더블클릭시 발주서(입력/수정) 팝업화면 호출                               */
    /****************************************************************************/	
	function openCustomerinputPopup(ORD_NO, GOODS_DIV, ORGN_DIV_CD, ORGN_DIV_NM, ORGN_DIV_TYP, ORGN_CD, ORGN_NM, CUSTMR_CD, CUSTMR_NM){
		var onComplete = function(){
 			var openPopupWindow = erpPopupWindows.window("orderPortalGridPopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
			
		}
		
		var url = "/sis/order/orderPortalGridPopup.sis";  /* 일반상품 발주 */
		var params = {    "SELECT_ORGN_DIV_CD"  : ORGN_DIV_CD
		                , "SELECT_ORGN_DIV_NM"  : ORGN_DIV_NM
		                , "SELECT_ORGN_DIV_TYP" : ORGN_DIV_TYP
				        , "SELECT_ORGN_CD"      : ORGN_CD
				        , "LOGIN_ORGN_NM"       : ORGN_NM
				        , "LOGIN_ORD_NO"        : ORD_NO 
				        , "LOGIN_ORGN_DIV_CD"   : LOGIN_ORGN_DIV_CD
		                , "LOGIN_ORGN_CD"       : LOGIN_ORGN_CD
		                , "LOGIN_ORGN_DIV_TYP"  : LOGIN_ORGN_DIV_TYP
				        , "LOGIN_CUSTMR_CD"     : CUSTMR_CD  /* 고객사 */
				        , "LOGIN_CUSTMR_NM"     : CUSTMR_NM  /* 고객명  */
		              }
		
		var	option = {
						"win_id" : "orderPortalGridPopup",
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
		
		var scrin_ORD_NO          = document.getElementById("txtORD_NO").value;
		var scrin_ORD_STATE       = cmbORD_STATE.getSelectedValue();


		$.ajax({
			url : "/sis/order/getSearchOrderList.do"
			,data : {
						  "PARAM_ORGN_DIV_CD"      : LOGIN_ORGN_DIV_CD
						, "PARAM_ORGN_CD"          : LOGIN_ORGN_CD           //    LOGIN_EMP_NO
						, "PARAM_ORD_STR_YYYYMMDD" : scrin_searchordStrDt
						, "PARAM_ORD_END_YYYYMMDD" : scrin_searchordEndDt
						, "PARAM_ORD_NO"           : scrin_ORD_NO
						, "PARAM_DEL_STR_YYYYMMDD" : ""
						, "PARAM_DEL_END_YYYYMMDD" : ""
						, "PARAM_PROJ_CD"          : ""
						, "PARAM_IN_WARE_CD"       : ""
						, "PARAM_OUT_WARE_CD"      : ""
						, "PARAM_SUPR_CD"          : ""
						, "PARAM_RESP_USER"        : LOGIN_EMP_NO
						, "PARAM_ORD_TYPE"         : "2"         /* 1: 발주, 2:주문   */
						, "LOGIN_CHANNEL"          : "P"         /* S: SIS,  P:PORTAL */
						, "PARAM_ORD_STATE"        : scrin_ORD_STATE
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
	/* COMBO박스처리 
	/***************************************************/
	function initDhtmlXCombo(){
		/* 진행상태  1:발주예정, 2:주문취소, 3:영업승인, 4:물류승인, 5:발주완료, 6:출고요청  */
		cmbORD_STATE   = $erp.getDhtmlXComboCommonCode('cmbORD_STATE',     'cmbORD_STATE',       ["ORD_STATE","ORD"] ,  177,  "모두조회",  false);   
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	function printOrderSheet() {
		var order_no_list = "";
		var selected_resp_user = "";
		var selected_orgn_cd = "";
		var check_rows = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
		var check_list = check_rows.split(",");
		
		for(var i = 0 ; i < check_list.length ; i++){
			if(i == 0){
				order_no_list += erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORD_NO")).getValue();
				selected_orgn_cd += erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORGN_CD")).getValue();
				selected_resp_user += erpGrid.cells(check_list[i], erpGrid.getColIndexById("RESP_USER")).getValue();
			} else {
				order_no_list += "," + erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORD_NO")).getValue();
				selected_orgn_cd += "," + erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORGN_CD")).getValue();
				selected_resp_user += "," + erpGrid.cells(check_list[i], erpGrid.getColIndexById("RESP_USER")).getValue();
			}
		}
		
		var paramInfo = {
				"ORD_NO_LIST" : order_no_list
				, "mrdPath" : "order_sheet_mrd"
				, "mrdFileName" : "cs_order_sheet.mrd"
				, "ORGN_CD" : selected_orgn_cd
				, "RESP_USER" : selected_resp_user
				, "SEARCH_DATE_FROM" : $("#searchordStrDt").val()
				, "SEARCH_DATE_TO" : $("#searchordEndDt").val()
		};
		
		var approvalURL = $CROWNIX_REPORT.openCsOrderSheet("", paramInfo, "발주서출력", "");
		var popObj = window.open(approvalURL, "order_sheet_popup", "width=900,height=1000");
		
		var frm = document.PrintOrderform;
		frm.action = approvalURL;
		frm.target = "order_sheet_popup";
		frm.submit();
	}
</script>
</head>
<body>
	<form name="PrintOrderform" action="" method="post"></form>			
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
				<th>주문기간</th>
				<td colspan="2">
					<input type="text" id="searchordStrDt" name="searchordStrDt" class="input_common input_calendar" > ~
					<input type="text" id="searchordEndDt" name="searchordEndDt" class="input_common input_calendar">
				</td>
				
				<th>주문번호</th>
				<td colspan="2"><input type="text" id="txtORD_NO" name="ORD_NO" class="input_common" maxlength="20" ></td>
				
				<th>진행상태</th>
				<td colspan="3">
				    <div id="cmbORD_STATE"></div>
				</td>

			</tr>
			
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid"   class="div_grid_full_size"   style="display:none"></div>
</body>

	
</html>