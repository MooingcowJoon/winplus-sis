<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js?ver=46"></script>
<script type="text/javascript">
	<%--
	    ※ 프로그램명 및 최종Update일자 (CS포털전용 주문서LIST조회 orderCsPortalSearch.jsp  )
		※ 전역 변수 선언부		
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
						, {id : "print_erpGrid", type : "button", text:'주문서 출력',   isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif",   disable : true}		
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "print_erpGrid"){
		    	printValidationCheck();
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
				, {id : "ORD_NO"           , label:["주문번호"          , "#text_filter"], type: "ro", width: "150", sort : "str", align : "center", isHidden : false , isEssential : true}
				, {id : "ORD_TYPE"         , label:["주문유형"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true  , isEssential : true}
				, {id : "REQ_DATE"         , label:["주문일자"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false , isEssential : true}
				, {id : "ORD_TYPE_NM"      , label:["주문유형"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false , isEssential : true}
				, {id : "FLAG"      	   , label:["진행상태코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true  , isEssential : false}
				, {id : "ORD_STAT_NM"      , label:["진행상태"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false , isEssential : true}
				, {id : "GOODS_NM"         , label:["주문상품"          , "#text_filter"], type: "ro", width: "300", sort : "str", align : "left",   isHidden : false , isEssential : true}
				, {id : "SUPR_AMT"         , label:["공급가액"          , "#text_filter"], type: "ron", width:"100", sort : "str", align : "right",  isHidden : false , isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"          , label:["부가세"            , "#text_filter"], type: "ron", width:"100", sort : "str", align : "right",  isHidden : false , isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"          , label:["합계금액"          , "#text_filter"], type: "ron", width:"100", sort : "str", align : "right",  isHidden : false , isEssential : true,  numberFormat : "0,000"}
				, {id : "EMP_NM"           , label:["담당자명"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true  , isEssential : true}
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
			var ORD_NO         = this.cells(rowId, this.getColIndexById("ORD_NO")).getValue();
			var ORD_TYPE       = this.cells(rowId, this.getColIndexById("ORD_TYPE")).getValue();
			var REQ_DATE       = this.cells(rowId, this.getColIndexById("REQ_DATE")).getValue();
			
			openCustomerinputPopup(ORD_NO,  ORD_TYPE, REQ_DATE );
		});
		
	}
	
	/****************************************************************************/
    /* 더블클릭시 발주서(입력/수정) 팝업화면 호출                               */
    /****************************************************************************/	
	function openCustomerinputPopup(ORD_NO,  ORD_TYPE, REQ_DATE){
		var onComplete = function(){
 			var openPopupWindow = erpPopupWindows.window("orderPortalGridPopupCS");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
			
		}
		
		ORD_NO,  ORD_TYPE, REQ_DATE
		var url = "/sis/order/orderPortalGridPopupCS.sis";  /* 일반상품 발주 */
		var params = {    "LOGIN_ORD_NO"    : ORD_NO
		                , "LOGIN_ORD_TYPE"  : ORD_TYPE
				        , "LOGIN_REQ_DATE"  : REQ_DATE
		              }
		
		var	option = {
						"win_id" : "orderPortalGridPopupCS",
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
		
		$.ajax({
			url : "/sis/order/getRequestOrderList.do"   /* getSearchOrderList */
			,data : {
						  "PARAM_CUSTMR_CD" : LOGIN_CUSTMR_CD
						, "PARAM_STR_DATE"  : scrin_searchordStrDt
						, "PARAM_END_DATE"  : scrin_searchordEndDt
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
	
	/****************/
	/* 주문서 출력  */
	/****************/
	function printValidationCheck() {
		var order_no_list = "";
		var ord_type_list = "";
		var check_rows = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK"));
		var check_list = check_rows.split(",");
		var ord_state_cnt = 0;
		
		if(check_rows == ""){
			$erp.alertMessage({
				"alertMessage" : "출력하실 주문건을 1개이상 선택해주세요.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		} else {
		
			for(var i = 0 ; i < check_list.length ; i++){
				if(erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORD_STAT_NM")).getValue() == "주문완료"){
					if(i == 0){
						order_no_list += erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORD_NO")).getValue();
						ord_type_list += erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORD_TYPE")).getValue();
					} else {
						order_no_list += "," + erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORD_NO")).getValue();
						ord_type_list += "," + erpGrid.cells(check_list[i], erpGrid.getColIndexById("ORD_TYPE")).getValue();
					}
				}else{
					ord_state_cnt += 1;
				}
			}
			
			if(check_list.length == ord_state_cnt){
				$erp.alertMessage({
					"alertMessage" : "'주문완료'상태의 주문건만 출력가능합니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			} else {
				if(ord_state_cnt == 0){
					printOrderSheet(order_no_list, ord_type_list);
				} else {
					$erp.confirmMessage({
						"alertMessage" : "'주문완료'상태의 주문건만 출력가능합니다.<br>선택하신 " + check_list.length + "건 중 " + (check_list.length-ord_state_cnt) + "건을 출력하시겠습니까?",
						"alertType" : "confirm",
						"isAjax" : false,
						"alertCallbackFn" : function() {printOrderSheet(order_no_list, ord_type_list);}
					});
				}
				
				
			}
		}
	}
	
	function printOrderSheet(order_no_list, ord_type_list){
		var paramInfo = {
				"ORD_NO_LIST" : order_no_list
				, "ORD_TYPE_LIST" : ord_type_list
				, "CUSTMR_CD" : LOGIN_CUSTMR_CD
				, "mrdPath" : "order_sheet_mrd"
				, "mrdFileName" : "new_cs_order_sheet.mrd"
				, "SEARCH_DATE_FROM" : $("#searchordStrDt").val()
				, "SEARCH_DATE_TO" : $("#searchordEndDt").val()
		};
		
		var approvalURL = $CROWNIX_REPORT.openNewCsOrderSheet("", paramInfo, "발주서출력", "");
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
				
			</tr>
			
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid"   class="div_grid_full_size"   style="display:none"></div>
</body>

	
</html>