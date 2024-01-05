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
		※ 전역 변수 선언부( 협력사 포털 상품출고등록  orderOutInputPopup )
		□ 변수명 : Type / Description
		■ erpRightLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpRightGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbORD_STATE : Object / 발주진행상태  (CODE : ORD_STATE ) 		 
	--%>
	var thisPopupWindow = parent.erpPopupWindows.window('orderOutInputPopup');
	
	var CurrentRow = 0;
	var erpRightLayout;
	var erpRightRibbon;	
	var erpRightGrid;
	var erpRightGridColumns;
	var erpRightGridDataProcessor;	
	var cmbORD_TYPE_CD;                  /* 발주유형           */
	var cmbORD_STATE;                    /* 발주진행상태       */

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

	var LOGIN_REQ_DATE    = "";
	var LOGIN_DIS_DATE    = "";
	var LOGIN_SUPR_CD     = "";
	var LOGIN_ORD_TYPE    = "";
	var LOGIN_ORD_NO      = "";
	var LOGIN_REQ_ORD_NO  = "";
	var LOGIN_ORD_STATE   = "";
	var LOGIN_CUST_NM     = "";
	
	$(document).ready(function(){		

		LOGIN_REQ_DATE     =  "${param.LOGIN_REQ_DATE}"
		LOGIN_DIS_DATE     =  "${param.LOGIN_DIS_DATE}"
		LOGIN_SUPR_CD      =  "${param.LOGIN_SUPR_CD}"
		LOGIN_ORD_TYPE     =  "${param.LOGIN_ORD_TYPE}"
		LOGIN_ORD_NO       =  "${param.LOGIN_ORD_NO}"
		LOGIN_ORD_STATE    =  "${param.LOGIN_ORD_STATE}"
		LOGIN_CUST_NM      =  "${param.LOGIN_CUST_NM}"
		LOGIN_REQ_ORD_NO   =  LOGIN_ORD_NO.substring(0,19);
	    
		initErpLayout();
		initErpRightRibbon();
		
		initErpRightGrid();  // 발주서 편집용그리드
		
		getLoginOrgInfo();
        		
	});
	
	/***************************************************/
	/*  1. MAIN Layout(1C)
    /***************************************************/
	function initErpLayout(){
		erpRightLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				  {id: "a", text: "", header:false, height:65}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		
		erpRightLayout.cells("a").attachObject("div_erp_contents_search");
		erpRightLayout.cells("b").attachObject("div_erp_ribbon");
		erpRightLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightLayout.cells("c").attachObject("div_erp_grid");
		
		erpRightLayout.setSeparatorSize(1, 0);
	}

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
					
					document.getElementById("txtORD_DATE").value    = LOGIN_DIS_DATE;
					document.getElementById("txtORD_NO").value      = LOGIN_REQ_ORD_NO;
			        document.getElementById("Cust_Name").value      = LOGIN_CUST_NM;    /* 고객명 */
			        document.getElementById("txtRESP_USER").value   = LOGIN_EMP_NO;      /* 처리자 */
			        document.getElementById("RESP_USER_NAME").value = LOGIN_EMP_NM;      /* 처리자명 */
			        
			        search_ErpRightGrid();
			        
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
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
						, {id : "save_erpGrid",       type : "button", text:'<spring:message code="ribbon.save" />',   isbig : false, img : "menu/save.gif",   imgdis : "menu/save_dis.gif",   disable : true}
						, {id : "excel_erpGri2",      type : "button", text:'화면닫기',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
				]}							
			]
		});
		
		
		erpRightRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_ErpGrid"){
		    	search_ErpRightGrid();
		    } else if (itemId == "save_erpGrid"){
		    	insertPurordandGoodsConfirm();
		    } else if (itemId == "excel_erpGri2"){
		    	thisOnComplete(); // 화면닫기
		    }
		});
		
	}
		
	/****************************************************************************/
    /* 발주요청서 Insert Confirm                                                */
    /****************************************************************************/	
	function insertPurordandGoodsConfirm(){

		var erpRightGridRowCount = erpRightGrid.getRowsNum();
		
		if ( erpRightGridRowCount <= 0 ) {
			$erp.alertMessage({
				"alertMessage" : "저장할 Data가 존재하지 않습니다.",
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
			  "alertMessage" : "정말 저장 하시겠습니까?"
			, "alertCode" : alertCode
			, "alertType" : alertType
			, "alertCallbackFn" : callbackFunction
		});
		
	}		
		
	/****************************************************************************/
    /* erpRightGrid 초기화                                                      */
    /****************************************************************************/	
	function initErpRightGrid(){
		erpRightGridColumns = [
			      {id : "NO"                   , label:["NO"                , "#rspan"]      ,   type: "cntr", width:  "30", sort : "int", align : "right",  isHidden : false, isEssential : false}
				, {id : "CHECK"                , label:["#master_checkbox"  , "#rspan"]      ,   type: "ch"  , width:  "40", sort : "int", align : "center", isHidden : true,  isEssential : false, isDataColumn : false}
				, {id : "REQ_DATE"             , label:["요청일자"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true,  isEssential : true}			
				, {id : "ORD_NO"               , label:["발주번호"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : true,  isEssential : true}
		   	    , {id : "ORD_SEQ"              , label:["일련번호"          , "#text_filter"],   type: "ron" , width:  "60", sort : "int", align : "right",  isHidden : true,  isEssential : true}
				, {id : "ORD_TYPE"             , label:["발주유형"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : true,  isEssential : true, commonCode : "ORD_TYPE"}			
				, {id : "ORD_TYPE_NM"          , label:["발주유형"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true,  isEssential : false}			
				, {id : "REQ_CUSTMR_CD"        , label:["고객사CD"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true,  isEssential : true}			
				, {id : "CUST_NM"              , label:["고객사명"          , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true,  isEssential : false}			
				, {id : "SUPR_CUSTMR_CD"       , label:["협력사코드"        , "#text_filter"],   type: "ro"  , width:  "80", sort : "str", align : "left",   isHidden : true,  isEssential : true}
				, {id : "SUPR_NM"              , label:["협력사명"          , "#select_filter"], type: "ro"  , width: "120", sort : "str", align : "left",   isHidden : true,  isEssential : false}

				/* ROW INDEX 11 ~ 20 */
				, {id : "BCD_CD"               , label:["바코드"            , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "BCD_NM"               , label:["상품명"            , "#text_filter"],   type: "ro"  , width: "250", sort : "str", align : "left",   isHidden : false, isEssential : false}			
				, {id : "WARE_CD"              , label:["창고코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "WARE_NM"              , label:["창고"              , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "TAX_TYPE"             , label:["부가세"            , "#text_filter"],   type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : false, isEssential : false}
				, {id : "DIMEN_NM"             , label:["규격"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "UNIT_NM"              , label:["단위"              , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "UNIT_QTY"             , label:["입수량"            , "#text_filter"],   type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "STOCK_QTY"            , label:["전산재고"          , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "right",  isHidden : true , isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "REQ_QTY"              , label:["요청수량"          , "#text_filter"],   type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			

				, {id : "OUT_QTY"              , label:["출고수량"          , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false,  isEssential : true}			
				
				/* ROW INDEX 21 ~ 30 */
				, {id : "GOODS_PRICE"          , label:["발주단가"          , "#text_filter"],   type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false,  isEssential : true,  numberFormat : "0,000"}			
				, {id : "SUPR_AMT"             , label:["공급가액"          , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false,  isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"              , label:["부가세"            , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false,  isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"              , label:["합계금액"          , "#text_filter"],   type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false,  isEssential : true,  numberFormat : "0,000"}
				, {id : "RESV_DATE"            , label:["납기예정일"        , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "center", isHidden : false,  isEssential : false}			
				, {id : "OUT_DATE"             , label:["출고일자"          , "#text_filter"],   type: "ro"  , width: " 70", sort : "str", align : "left",   isHidden : false,  isEssential : true}			
				, {id : "LAND_CHG_TYPE"        , label:["착지변경"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}			
				, {id : "MEMO"                 , label:["적요"              , "#text_filter"],   type: "ro"  , width: "200", sort : "str", align : "right",  isHidden : false,  isEssential : false}
				, {id : "ORD_CUSTMR_TYPE"      , label:["발행구분"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "ORD_CUSTMR_TYPE_NM"   , label:["발행구분"          , "#select_filter"], type: "ro"  , width: "80" , sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "RESP_USER"            , label:["처리자"            , "#text_filter"],   type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : true  , isEssential : true}

				/* ROW INDEX 31  */
				, {id : "EMP_NM"               , label:["요청자"            , "#select_filter"], type: "ro"  , width:  "60", sort : "str", align : "left",   isHidden : false , isEssential : false}
				, {id : "FLAG"                 , label:["발주상태"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "FLAG_NM"              , label:["발주상태"          , "#select_filter"], type: "ro"  , width: "80",  sort : "str", align : "center", isHidden : false , isEssential : true}
				, {id : "ORGN_DIV_CD"          , label:["조직유형"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true,   isEssential : false}			
				, {id : "ORGN_CD"              , label:["조직코드"          , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true,   isEssential : false}			
				, {id : "OBJKEY"               , label:["BCD+공급사CD"      , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true,   isEssential : false}			
		];
		
		erpRightGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpRightGridColumns
		});		
		
		/* 마우스 한번 클릭으로  편집가능 */
		erpRightGrid.enableLightMouseNavigation(true);
		$erp.attachDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);
		erpRightGridDataProcessor =$erp.initGrid(erpRightGrid);
		$erp.initGridDataColumns(erpRightGrid);
				
	}

	/***************************************************/
	/* 그리드 조회
	/***************************************************/
	function search_ErpRightGrid(){

		erpRightLayout.progressOn();
		console.log(" LOGIN_REQ_DATE =>" + LOGIN_REQ_DATE + " LOGIN_SUPR_CD=> " + LOGIN_SUPR_CD + " LOGIN_ORD_TYPE=> " + LOGIN_ORD_TYPE + " LOGIN_REQ_ORD_NO=> " + LOGIN_REQ_ORD_NO);
		    
		$.ajax({
			 url  : "/sis/order/getSearchReqGoodsTmpOnly.do"
			,data : {
			 	         "PARAM_REQ_DATE"   : LOGIN_REQ_DATE
				       , "PARAM_SUPR_CD"    : LOGIN_SUPR_CD      /* 고객사    */
				       , "PARAM_ORD_TYPE"   : LOGIN_ORD_TYPE     /* 협력사    */
				       , "PARAM_ORD_NO"     : LOGIN_REQ_ORD_NO   /* 담당자(취급점은 표시하지 않는다) */ 
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
						/* SYSTEM의 현재날자를 출고일자로 */
						document.getElementById("txtOUT_DATE").value  = today;
						today     = today.replace (/-/g, "")
						document.getElementById("hisPARM_OUT_DATE").value  = today;
						$erp.addDhtmlXGridNoDataPrintRow(
							erpRightGrid, '<spring:message code="grid.noSearchData" />'
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
	
	/*********************************************************/
	/* 발주서 저장  C,U,D
	/*********************************************************/
	function save_ErpRightGrid(){
		
		var HEAD = $erp.dataSerialize("aaa");
		console.log(HEAD);
		var BODY = $erp.dataSerializeOfGridByMode(erpRightGrid,"all");   // all(전체)  state( CUD 변경부문만 처리) 
		console.log(BODY);
		
		var url = "/sis/order/UpdateOrdReqGoodsTmp.do";
		
		var send_data = {"HEAD":HEAD, "BODY":BODY};   /*  LIST MAP구조로 Controller로 넘긴다 */
		
		var if_success = function(data){
			if($erp.isEmpty(data.result)){
				erpRightLayout.progressOff();
			}else{
				if(data.result == BODY.length){
					console.log("성공");
				}
			}
		}
		
		var if_error = function(data){
			$erp.ajaxErrorMessage(data);
		}
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpRightLayout);

	}
	
	
	/***************************************************/
	/* COMBO박스처리 
	/***************************************************/
	function initDhtmlXCombo(){

		/* 발주유형 */
		cmbORD_TYPE_CD = $erp.getDhtmlXComboCommonCode('cmbORD_TYPE_CD',   'cmbORD_TYPE_CD', ["ORD_TYPE","","MK"],   177,  "",  false, LOGIN_ORD_TYPE);
    	$erp.objReadonly("cmbORD_TYPE_CD");  /* Combo박스 손을 못되게 한다 */
		
		/* 발주진행상태  1:저장, 2:취소, 3;전송, 4:접수, 9:입고 */
		cmbORD_STATE   = $erp.getDhtmlXComboCommonCode('cmbORD_STATE',     'cmbORD_STATE',    'ORD_STATE',   177,  "모두조회", false,  LOGIN_ORD_STATE);   
    	$erp.objReadonly("cmbORD_STATE");  /* Combo박스 손을 못되게 한다 */

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
							<input type="text" id="txtKEY_WORD" name="KEY_WORD" class="input_common" maxlength="10" onkeydown="$erp.onEnterKeyDown(event, searchErpLeftTree);">
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
				  <col width="200px">
				  	
				  <col width="180px">
				  <col width="240px">
				  
				  <col width="140px">	
				  <col width="240px">
				  
				  <col width="140px">
				  <col width="240px">
				  <col width="*">				
			  </colgroup>
			  <tr>
				  <th>발주유형</th>
				  <td>
					  <input type="hidden" id="txtCUST_CD">
				      <div id="cmbORD_TYPE_CD"></div>
				  </td>				 

				  <th>발주일자</th>
				  <td>
					  <input type="text" id="txtORD_DATE" name="txtORD_DATE" class="input_common input_calendar default_date" data-position="">
				  </td>

				  <th>발주번호</th>
				  <td><input type="text" id="txtORD_NO" name="ORD_NO" readonly="readonly"  disabled="disabled" class="input_common" maxlength="20"  style="width:171px;"></td>

				  <th>담당자명</th>
				  <td>
					  <input type="hidden" id="txtRESP_USER">
					  <input type="text" id="RESP_USER_NAME" name="RESP_USER_NAME" readonly="readonly" disabled="disabled"/>
				  </td>
			  </tr>
			
			  <tr>
				  <th>고객사</th>
				  <td>
					  <input type="hidden" id="txtCUST_CD">
					  <input type="text" id="Cust_Name" name="Cust_Name" readonly="readonly" disabled="disabled"/>
					  <!-- 
					  <input type="button" id="Cust_Search" value="검 색" class="input_common_button" onclick="openSearchComEmpNoGridPopup();"/>
					   -->
				  </td>
				
				  <th>출고일자</th>
				  <td>
					  <input type="text" id="txtOUT_DATE" name="txtOUT_DATE" class="input_common input_calendar default_date" data-position="">
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
	 </div>
</body>

	
</html>