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
		□ 변수명 : Type / Description ( openGoodsReturnPopup.jsp 교환반품 팝업)
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
	
    var param_CUST_CD      = "";  /* 협력사(공급사)코드 */
    
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
    
	$(document).ready(function(){		
		if(thisPopupWindow){
			thisPopupWindow.setText("${screenDto.scrin_nm}");	
			//thisPopupWindow.denyResize();
			//thisPopupWindow.denyMove();
		}
		
	    param_CUST_CD      = "${param.CUST_CD}"
		console.log("param_CUST_CD      =>" + param_CUST_CD);
		
		document.getElementById("searchordStrDt").value=todayDate;
		document.getElementById("searchordEndDt").value=today;
	    
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
			, {id : "ORD_DATE"     , label:["구매일자"            , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "BCD_CD"       , label:["바코드"              , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "SUPR_CD"      , label:["협력사"              , "#text_filter"], type: "ro",   width: "130", sort : "str", align : "center", isHidden : true,  isEssential : true}
			, {id : "SUPR_NM"      , label:["협력사명"            , "#text_filter"], type: "ro",   width: "130", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "WARE_CD"      , label:["창고코드"            , "#text_filter"], type: "ro",   width: "130", sort : "str", align : "center", isHidden : true,  isEssential : true}
			, {id : "WARE_NM"      , label:["창고이름"            , "#text_filter"], type: "ro",   width: "130", sort : "str", align : "center", isHidden : true,  isEssential : true}
			, {id : "GOODS_CD"     , label:["상품코드"            , "#text_filter"], type: "ro",   width:  "70", sort : "str", align : "left",   isHidden : true,  isEssential : true}
			, {id : "BCD_NM"       , label:["상품명"              , "#text_filter"], type: "ro",   width: "250", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "DIMEN_NM"     , label:["규격"                , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "UNIT_NM"      , label:["단위"                , "#text_filter"], type: "ro",   width:  "50", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "GOODS_PRICE"  , label:["구매단가"            , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
			, {id : "UNIT_QTY"     , label:["입수량"              , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true}
			, {id : "DSCD_TYPE"    , label:["반품"                , "#text_filter"], type: "ro",   width:  "50", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "TAX_TYPE"     , label:["과세구분"            , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "ORD_CD"       , label:["거래코드"            , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "SALE_QTY"     , label:["판매수량"            , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true,  numberFormat : "0,000.00"}
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

		var scrin_searchordStrDt  = document.getElementById("searchordStrDt").value;
		var scrin_searchordEndDt  = document.getElementById("searchordEndDt").value;
		scrin_searchordStrDt      = scrin_searchordStrDt.replace (/-/g, "")
		scrin_searchordEndDt      = scrin_searchordEndDt.replace (/-/g, "")
		var scrn_bcd_nm           = document.getElementById("txtBCD_NM").value;
		var scrn_ord_cd           = document.getElementById("txtORD_CD").value;

		$.ajax({
			  url     : "/sis/order/getReturnMasterBarcodeLowestPriceList.do"
			,data     : {
							  "PARAM_ORD_CD"     : scrn_ord_cd          /* 거래코드  */
							, "PARAM_CUSTMR_CD"  : param_CUST_CD        /* 고객사(취급점cd)  */
							, "PARAM_BCD_NM"     : scrn_bcd_nm          /* 상품명 */
							, "PARAM_STR_DT"     : scrin_searchordStrDt /* 시작일 */
							, "PARAM_END_DT"     : scrin_searchordEndDt /* 종료일 */
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

</script>
</head>
<body>				
	<div id="div_erp_midd_search" class="samyang_div" style="display:none">
		<table id="tb_erp_right_data" class="table_search">
			<colgroup>
				<col width="100px">
				<col width="120px">
				<col width="120px">
				
				<col width="170px">	
				<col width="240px">

				<col width="240px">
				<col width="230px">	
				<col width="*">		
			</colgroup>
			<tr>
				<th>구매기간</th>
				<td colspan="2">
					<input type="text" id="searchordStrDt" name="searchordStrDt" class="input_common input_calendar" > ~
					<input type="text" id="searchordEndDt" name="searchordEndDt" class="input_common input_calendar">
				</td>				
			
				<th>상품명</th>
			    <td><input type="text" id="txtBCD_NM" name="BCD_NM" class="input_common" maxlength="50" style="width:165px;" onkeydown="$erp.onEnterKeyDown(event, search_erpMiddGrid);"></td>

				<th>거래번호</th>
			    <td><input type="text" id="txtORD_CD" name="ORD_CD" class="input_common" maxlength="50" style="width:165px;" onkeydown="$erp.onEnterKeyDown(event, search_erpMiddGrid);"></td>

			</tr>
		</table>
	</div>
	<div id="div_erp_midd_ribbon" class="div_ribbon_full_size" style="display:none"></div>	
	<div id="div_erp_midd_grid"   class="div_grid_full_size" style="display:none"></div>			
</body>
	
</html>