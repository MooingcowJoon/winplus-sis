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
		□ 변수명 : Type / Description   ( openGoodsOutMkPopup.jsp 센터및 직영점 반품용 )
		■ erpRightLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpRightGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbIN_WARE_CD : Object / 입고창고 DhtmlXCombo  (CODE : WARE_CD )
		■ cmbORD_STATE : Object / 발주진행상태  (CODE : ORD_STATE ) 		 
	--%>
	var thisPopupWindow = parent.erpPopupWindows.window('openOrderInputGridPopup');
	
	var erpRightGridColumns;
	var erpRightGridDataProcessor;	
	var erpRightGridSelectedCustmr_cd;   /* 그리드 rowSelected */
	
	/*  발주서 List 다중선택용  */
	var erpPopupOrderCheckList;
	var erpPopupOrderOnRowSelect;
	
	
	var param_ORGN_DIV_CD  = "";  /* 발주를 요청하는 조직구분  C03, Z01, Z02   */
	var param_ORGN_CD      = "";  /* 발주를 요청하는 조직                 */
    var param_CALL_CHANNEL = "";  /* 호출경로 S:영업관리, P:거래차포털    */
    var param_CUST_DIV_CD  = "";  /* 협력사(공급사) 조직구분코드   B01:센터로발주, A06:팜으로발주, OUT:외부공급사로발주   */
    var param_CUST_CD      = "";  /* 협력사(공급사)코드 */
    var param_CUST_NM      = "";  /* 협력사(공급사)명   */
    var param_ORD_TYPE     = "";  /* 발주유형   */
    
    
	$(document).ready(function(){		
		if(thisPopupWindow){
			thisPopupWindow.setText("${screenDto.scrin_nm}");	
			//thisPopupWindow.denyResize();
			//thisPopupWindow.denyMove();
		}
		
		param_ORGN_DIV_CD  = "${param.ORGN_DIV_CD}"
		param_ORGN_CD      = "${param.ORGN_CD}"
		param_CALL_CHANNEL = "${param.CALL_CHANNEL}"
	    param_CUST_DIV_CD  = "${param.CUST_DIV_CD}"
	    param_CUST_CD      = "${param.CUST_CD}"
		param_CUST_NM      = "${param.CUST_NM}"
	    param_SUPR_CD      = "${param.SUPR_CD}"
		param_SUPR_NM      = "${param.SUPR_NM}"
		param_ORD_TYPE     = "${param.ORD_TYPE}"     /* 발주유형  1물류발주, 2직납발주, 3신선발주, 4착지변경, 5일배발주 */

		document.getElementById("txtSUPR_CD").value  = "${param.SUPR_CD}";
		document.getElementById("Custmr_Name").value = "${param.SUPR_NM}";

	    if(param_SUPR_CD.length == 0){
			document.getElementById("Select_Supr").checked = false;
		} else
		{
			document.getElementById("Select_Supr").checked = true;
		}
		
		console.log("==============openGoodsPricePopup.jsp================");
		console.log("param_ORGN_DIV_CD  =>" + param_ORGN_DIV_CD);
		console.log("param_ORGN_CD      =>" + param_ORGN_CD);
		console.log("param_CALL_CHANNEL =>" + param_CALL_CHANNEL);
		console.log("param_CUST_DIV_CD  =>" + param_CUST_DIV_CD);
		console.log("param_CUST_CD      =>" + param_CUST_CD);
		console.log("param_CUST_NM      =>" + param_CUST_NM);
		console.log("param_SUPR_CD      =>" + param_SUPR_CD);
		console.log("param_SUPR_NM      =>" + param_SUPR_NM);
		console.log("param_ORD_TYPE     =>" + param_ORD_TYPE);
		
		initErpMiddLayout();
		initErpMiddRibbon();	
		initErpMiddGrid();

       // $('input').prop('readonly', true);
        		
	});
	
	
	/*************************************************************/
	/*  1. 중앙layout  대중소 그룹에 선택된 전체상품을 조회한다
    /************************************************************/	
	function initErpMiddLayout(){
		
		erpMiddLayout = new dhtmlXLayoutObject({
			parent   : document.body
			, skin   : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells  : [
							  {id: "a", text: "11111", header:false, }
							, {id: "b", text: "22222", header:false, fix_size:[true, true]}
							, {id: "c", text: "33333", header:false}
						]		
		});
		
		erpMiddLayout.cells("a").attachObject("div_erp_midd_search");
		erpMiddLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpMiddLayout.cells("b").attachObject("div_erp_midd_ribbon");
		erpMiddLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpMiddLayout.cells("c").attachObject("div_erp_midd_grid");
		erpMiddLayout.setSeparatorSize(1, 0);
		
	}
	
	/*********************************************************/
	/* 전체상품 목록선택
	/*********************************************************/
	function initErpMiddRibbon(){
		erpMiddRibbon = new dhtmlXRibbon({
			parent : "div_erp_midd_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						{id : "search_erpMiddGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					  , {id : "add_erpGrid"  ,      type : "button", text:'추가',                                    isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
					  , {id : "excel_erpGri2",      type : "button", text:'화면닫기',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
				]}							
			]
		});
		
		erpMiddRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpMiddGrid"){
		    	search_erpMiddGrid();
		    } else if (itemId == "add_erpGrid"){
				erpMiddLayout.progressOn();
		    	addErpGridData();
				erpMiddLayout.progressOff();
		    } else if (itemId == "excel_erpGri2"){
		    	thisOnComplete(); // 화면닫기
		    }
		});
	}
	
	function addErpGridData() {
		if(!$erp.isEmpty(erpPopupOrderCheckList) && typeof erpPopupOrderCheckList === 'function'){
			erpPopupOrderCheckList(erpMiddGrid);
		}
	}
	
	
	/*********************************************************/
	/* 전체상품목록 조회 
	/*********************************************************/
	function initErpMiddGrid(){
		erpMiddGridColumns = [
			  {id : "NO"           , label:["NO"                  , "#rspan"],       type: "cntr", width: "30",  sort : "int", align : "center", isHidden : true,  isEssential : false}
			, {id : "CHECK"        , label:["#master_checkbox"    , "#rspan"],       type: "ch",   width: "20",  sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "SUPR_CD"      , label:["협력사"              , "#text_filter"], type: "ro",   width: "130", sort : "str", align : "left",   isHidden : true,  isEssential : true}
			, {id : "SUPR_NM"      , label:["협력사명"            , "#text_filter"], type: "ro",   width: "130", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "WARE_CD"      , label:["창고코드"            , "#text_filter"], type: "ro",   width: "130", sort : "str", align : "left",   isHidden : true,  isEssential : true}
			, {id : "WARE_NM"      , label:["창고이름"            , "#text_filter"], type: "ro",   width: "130", sort : "str", align : "left",   isHidden : true,  isEssential : true}
			, {id : "BCD_CD"       , label:["바코드"              , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "GOODS_CD"     , label:["상품코드"            , "#text_filter"], type: "ro",   width:  "70", sort : "str", align : "left",   isHidden : true,  isEssential : true}
			, {id : "BCD_NM"       , label:["상품명"              , "#text_filter"], type: "ro",   width: "250", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "DIMEN_NM"     , label:["규격"                , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "UNIT_NM"      , label:["단위"                , "#text_filter"], type: "ro",   width:  "50", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "GOODS_PRICE"  , label:["구매단가"            , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
			, {id : "UNIT_QTY"     , label:["입수량"              , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true}
			, {id : "DSCD_TYPE"    , label:["반품"                , "#text_filter"], type: "ro",   width:  "50", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "TAX_TYPE"     , label:["과세구분"            , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "MIN_PUR_QTY"  , label:["최소주문수량"        , "#text_filter"], type: "ron",  width: "120", sort : "str", align : "left",   isHidden : false, isEssential : true,  numberFormat : "0,000"}
			, {id : "MIN_PUR_UNIT" , label:["최소주문단위"        , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "MIN_LMT_QTY"  , label:["주문제한수량"        , "#text_filter"], type: "ron",  width: "120", sort : "str", align : "left",   isHidden : false, isEssential : true,  numberFormat : "0,000"}
		];
		
		erpMiddGrid = new dhtmlXGridObject({
			parent: "div_erp_midd_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpMiddGridColumns
		});		
		erpMiddGrid.enableDistributedParsing(true, 100, 50);
		erpMiddGridDataProcessor = $erp.initGrid(erpMiddGrid);
		$erp.initGridDataColumns(erpMiddGrid);		
	}	

	/*********************************************************/
	/* 바코드마스트 상품목록조회
	/*********************************************************/
	function search_erpMiddGrid(){
		/*  Iput validation은 필요없음 조건이 없으면 전체 출력 */
		erpMiddLayout.progressOn();

		console.log("param_ORGN_DIV_CD =>" + param_ORGN_DIV_CD + " param_ORGN_CD =>"+ param_ORGN_CD );
		var goods_nm    = document.getElementById("txtBCD_NM").value;
		var custmr_cd   = "";
        var CALL_URL    = "";
        
		if($('#Select_Supr').is(":checked") == true)  {
			 custmr_cd    = document.getElementById("txtSUPR_CD").value;
		}		

		/* 직발건의 반품이냐 센터의 반품이냐 */
		if ( param_CUST_DIV_CD == "OUT") {
			CALL_URL  = "/sis/order/getBanpumOutBarcodePriceList.do"
			custmr_cd = param_SUPR_CD;
		} else {
			CALL_URL  = "/sis/order/getBanpumMkBarcodePriceList.do"
			custmr_cd = param_CUST_CD;
		}

		$.ajax({
			  url     : CALL_URL
			,data     : {
							  "PARAM_BCD_NM"       : goods_nm
							, "PARAM_ORGN_CD"      : param_ORGN_CD   /* 조직(발주하는 조직)       */
							, "PARAM_CUSTMR_CD"    : custmr_cd       /* 외부협력사의 반품이면 협력사 , 센터구매의반품이면 고객사  */
		 	            }
			,method   : "POST"
			,dataType : "JSON"
			,success  : function(data){
				erpMiddLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpMiddGrid);
					var gridDataList2 = data.gridDataList;
					if($erp.isEmpty(gridDataList2)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpMiddGrid, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpMiddGrid.parse(gridDataList2, 'js');	
						erpMiddGrid.selectRowById(1);   
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpMiddGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpMiddLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}

	
	/****************************************************************************/
    /* 협력사명 선택 팝업호출                                                   */
    /****************************************************************************/	
	function openSearchCustmrGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "1";           // 협력사(매입처) :1,  고객사(매출처): 2
		var ls_CUSTMR_CD  = "";
		
		var onRowSelect = function(id, ind) {
			document.getElementById("txtSUPR_CD").value  = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			ls_CUSTMR_CD                                 = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			
			/* 값이 있으면  */
			if ( ls_CUSTMR_CD ) {
				if(param_ORD_NO) {  /* 발주서 번호가 존재하면 조회 */
					getOrderDeadTimeLeadTime(ls_CUSTMR_CD, 2);  /* 마감시간 이전이면 1 이후이면 2 */
				}
				else
				{
					getOrderDeadTimeLeadTime(ls_CUSTMR_CD, 1);  /* 마감시간 이전이면 1 이후이면 2 */
				}
			}
			
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	/****************************************************************************/
    /* 협력사명 선택 팝업호출                                                   */
    /****************************************************************************/	
	function openSearchCustmrGridPopup2() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "1";            // 협력사(매입처) :1,  고객사(매출처): 2
		var onRowSelect = function(id, ind) {
			document.getElementById("txtSUPR_CD").value  = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
</script>
</head>
<body>				
	<div id="div_erp_midd_search" class="samyang_div" style="display:none">
		<table id="tb_erp_right_data" class="table_search">
			<colgroup>
				<col width="50px">
				<col width="150px">
				<col width="100px">
				<col width="30px">
				<col width="30px">
				<col width="200px">
			</colgroup>
			<tr>
				<th>상품명</th>
			    <td><input type="text" id="txtBCD_NM" name="BCD_NM" class="input_common" maxlength="50" style="width:165px;" onkeydown="$erp.onEnterKeyDown(event, search_erpMiddGrid);"></td>

				<th>협력사포함</th>
				<td><input type="checkbox" id="Select_Supr" name="Select_Goods"/></td>
				<th>협력사</th>
				<td colspan="2">
				     <input type="hidden" id="txtSUPR_CD">
				     <input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled" style="width:163px;"/>
				     <input type="button" id="Custmr_id" value="검 색" class="input_common_button" onclick="openSearchCustmrGridPopup2();"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_midd_ribbon" class="div_ribbon_full_size" style="display:none"></div>	
	<div id="div_erp_midd_grid"   class="div_grid_full_size" style="display:none"></div>			
</body>
	
</html>