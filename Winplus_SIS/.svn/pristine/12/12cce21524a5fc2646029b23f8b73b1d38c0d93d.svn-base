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
		※ 전역 변수 선언부( orderPortalGridPopupCS.jsp 거래처포털 주문서조회의 상세내역조회 )
		□ 변수명 : Type / Description
		■ erpRightLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpRightGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbOUT_WARE_CD : Object / 출고창고 DhtmlXCombo  (CODE : CENTER_CD )
		■ cmbORD_STATE : Object / 발주진행상태  (CODE : ORD_STATE ) 		 
	--%>
	var thisPopupWindow = parent.erpPopupWindows.window('orderPortalGridPopupCS');
	
	var erpRightLayout;
	var erpRightRibbon;	
	var erpRightGrid;
	var erpRightGridColumns;
	var erpRightGridDataProcessor;		

	var LOGIN_ORD_NO       = "";
	var LOGIN_ORD_TYPE     = "";
	var LOGIN_ORD_DATE     = "";

    var	GLOVAL_LOAN_LMT_AMT  = 0;       /* 여신한도       */
    var	GLOVAL_LOAN_BAL_AMT  = 0;       /* 현재여신잔액   */
    var	GLOVAL_LOAD_USE_AMT  = 0;       /* 잔액미반영금액 */

	$(document).ready(function(){		

		if(thisPopupWindow){
			thisPopupWindow.setText("${screenDto.scrin_nm}");	
			//thisPopupWindow.denyResize();
			//thisPopupWindow.denyMove();
		}
		
		LOGIN_ORD_NO   = "${param.LOGIN_ORD_NO}"
	    LOGIN_ORD_TYPE = "${param.LOGIN_ORD_TYPE}"
	    LOGIN_ORD_DATE = "${param.LOGIN_REQ_DATE}"
	    
		console.log("orderPortalGridPopupCS.jsp =>  LOGIN_ORD_NO =>" + LOGIN_ORD_NO + " LOGIN_ORD_TYPE=> " + LOGIN_ORD_TYPE );
	    console.log("LOGIN_ORD_DATE => " + LOGIN_ORD_DATE);
	    
		initerpRightLayout();
		initErpRightRibbon();
		initErpRightGrid();  // 주문서 편집용그리드
		
		document.getElementById("txtORD_DATE").value = LOGIN_ORD_DATE;
		
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
					
			        GLOVAL_LOAN_LMT_AMT  = data.gridDataList.LOAN_LMT_AMT;     /* 여신한도       */
			        GLOVAL_LOAN_BAL_AMT  = data.gridDataList.LOAN_BAL_AMT;     /* 현재여신잔액   */
			        GLOVAL_LOAD_AVL_AMT  = data.gridDataList.LOAN_AVL_AMT;     /* 발주가능금액   */
					console.log("GLOVAL_LOAN_LMT_AMT=>"  + GLOVAL_LOAN_LMT_AMT);          
					console.log("GLOVAL_LOAN_BAL_AMT=>"  + GLOVAL_LOAN_BAL_AMT);          
					console.log("GLOVAL_LOAD_AVL_AMT=>"  + GLOVAL_LOAD_AVL_AMT);   
					
			        document.getElementById("txtLOAN_LMT_AMT").value    = $erp.convertToMoney(GLOVAL_LOAN_LMT_AMT);  /* 여신한도       */
			        document.getElementById("txtLOAN_BAL_AMT").value    = $erp.convertToMoney(GLOVAL_LOAN_BAL_AMT);  /* 현재여신잔액   */
			        document.getElementById("txtLOAN_AVL_AMT").value    = $erp.convertToMoney(GLOVAL_LOAD_AVL_AMT);  /* 발주가능금액   */
			        
			        search_ErpRightGrid();
				}
			}, error : function(jqXHR, textStatus, errorThrown){
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
			 	  {id: "a", text: "주문서조회", header:true, height:63}
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
					    , {id : "excel_erpGri2",      type : "button", text:'화면닫기',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
				]}							
			]
		});
		
		erpRightRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_ErpGrid"){
		    	search_ErpRightGrid();
		    } else if (itemId == "excel_erpGri2"){
		    	thisOnComplete(); // 화면닫기
		    }
		});
		
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
				, {id : "ORD_TYPE_NM"          , label:["주문유형"          , "#select_filter"], type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false , isEssential : false}			
				, {id : "FLAG_NM"              , label:["주문상태"          , "#select_filter"], type: "ro"  , width:  "70", sort : "str", align : "center", isHidden : false ,   isEssential : true}
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
				, {id : "STOCK_QTY"            , label:["전산재고"          , "#text_filter"],   type: "ro"  , width:  "70", sort : "str", align : "right",  isHidden : true,  isEssential : true,  numberFormat : "0,000.00"}			
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
				, {id : "MIN_PUR_QTY"          , label:["최소주문수량"      , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "MIN_PUR_UNIT"         , label:["주문단위"          , "#text_filter"],   type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "CHG_WARE_CD"          , label:["배송지"            , "#text_filter"],   type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
				, {id : "ORG_ORD_NO"           , label:["원주문서NO"        , "#text_filter"],   type: "ro"  , width: "150", sort : "str", align : "left",   isHidden : true ,  isEssential : false}
		];
		
		erpRightGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpRightGridColumns
		});		
		
		//erpRightGrid.enableDistributedParsing(true, 100, 24);
		$erp.attachDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);
		erpRightGridDataProcessor =$erp.initGrid(erpRightGrid);
		$erp.initGridDataColumns(erpRightGrid);
		
	}
	
	/***************************************************/
	/* 그리드 조회
	/***************************************************/
	function search_ErpRightGrid(){

		erpRightLayout.progressOn();

		console.log(" PARAM_ORD_NO =>" + LOGIN_ORD_NO + " PARAM_ORD_TYPE=> " + LOGIN_ORD_TYPE  );

		$.ajax({
			 url  : "/sis/order/getSearchReqGoodsCSportal.do"
			,data : {
			 	         "PARAM_ORD_NO"    : LOGIN_ORD_NO
				       , "PARAM_ORD_TYPE"  : LOGIN_ORD_TYPE
			        }
			
			,method   : "POST"
			,dataType : "JSON"
			,success  : function(data){
				erpRightLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpRightGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
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
	
	/**************************************************
	* 기타 영역
	**************************************************/
	
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>				
	 <div id="" class="samyang_div" style="display:none;">

	 <div id="div_erp_contents_search" class="samyang_div" style="display:none">
	 	  <table id="aaa" class="table_search" >
			  <colgroup>
				  <col width="100px">
				  <col width="150px">
				  	
				  <col width="100px">
				  <col width="200px">
				  
				  <col width="100px">	
				  <col width="200px">
				  
				  <col width="100px">
				  <col width="200px">

				  <col width="100px">
				  <col width="200px">

				  <col width="*">				
			  </colgroup>
			  <tr>
				  <th>주문일자</th>
				  <td>
					  <input type="hidden" id="txtORD_TYPE">  <!--  주문휴형 : 1:발주, 2:주문  -->
					  <input type="text" id="txtORD_DATE" name="txtORD_DATE" class="input_common " data-position=""  readonly="readonly"  disabled="disabled">
				  </td>
				  <th>여신한도</th>
				  <td><input type="text" id="txtLOAN_LMT_AMT" name="LOAN_LMT_AMT" class="input_money" maxlength="50"  readonly="readonly"  disabled="disabled"></td>
				  <th>여신잔액</th>
				  <td><input type="text" id="txtLOAN_BAL_AMT" name="LOAN_BAL_AMT" class="input_money" maxlength="50"  readonly="readonly"  disabled="disabled"></td>
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