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
		※ 전역 변수 선언부 (orderRequestPopup.jsp  당일기준 착지변경/일배발주건 팝업조회 )
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbPartnerIO : Object / 거래처구분(매입 or 매출) DhtmlXCombo  (CODE : PUR_SALE_TYPE )
		■ cmbPamentDay : Object / 마감일자(결제기준) DhtmlXCombo  (CODE : PAY_STD ) 		 
		■ cmbSourcing : Object / 마감일자(결제기준) DhtmlXCombo  (CODE : SUPR_GOODS_GRUP ) 		 
		■ cmbPartnerPart : Object / 공급사분류코드 DhtmlXCombo  (CODE : SUPR_GRUP_CD ) 		 
		■ cmbPartnerType : Object / 공급사유형  DhtmlXCombo  (CODE : SUPR_TYPE ) 		 
	--%>
	var thisPopupWindow = parent.erpPopupWindows.window('orderRequestPopup');
	var LOGIN_ORGN_DIV_CD  = "";
	var LOGIN_ORGN_CD      = "";
	var LOGIN_ORGN_DIV_TYP = "";
	var LOGIN_ORD_TYPE     = "";
	var LOGIN_ORD_DATE     = "";
	
	var erpLayout;
	var erpRibbon;	
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;	

	/*  발주서 List 다중선택용  */
	var erpPopupOrderCheckList;
	var erpPopupOrderOnRowSelect;
	
	$(document).ready(function(){		
		
		if(thisPopupWindow){
			thisPopupWindow.setText("${screenDto.scrin_nm}");	
		}
		
		LOGIN_ORGN_DIV_CD  = "${param.ORGN_DIV_CD}"
		LOGIN_ORGN_CD      = "${param.ORGN_CD}"
		LOGIN_ORGN_DIV_TYP = "${param.ORGN_DIV_TYP}"
		LOGIN_ORD_TYPE     = "${param.ORD_TYPE}"		
		LOGIN_ORD_DATE     = "${param.ORD_DATE}"
		
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		
		document.getElementById("searchordStrDt").value = LOGIN_ORD_DATE.substring(0,4) + "-" + LOGIN_ORD_DATE.substring(4,6) + "-" + LOGIN_ORD_DATE.substring(6,8);
		
		$erp.asyncObjAllOnCreated(function(){
			searchErpGrid();
		});		
				
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
						, {id : "excel_erpGri1",  type : "button", text:'확인',                                    isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						, {id : "excel_erpGri2",  type : "button", text:'화면닫기',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "excel_erpGri1"){
		    	addErpGridData();
		    } else if (itemId == "excel_erpGri2"){
		    	thisOnComplete(); // 화면닫기
		    }
		});
	}
	
	function addErpGridData() {
		
		var erpGridRowCount  = erpGrid.getRowsNum();
		var select_cnt       = 0;
		
		for(var i = 0; i < erpGridRowCount; i++){

			var leftRid    = erpGrid.getRowId(i);
			var check      = erpGrid.cells(leftRid, erpGrid.getColIndexById("CHECK")).getValue();

			if(check == 1){
				select_cnt = select_cnt + 1;		
			}
		}
		
		if(!$erp.isEmpty(erpPopupOrderCheckList) && typeof erpPopupOrderCheckList === 'function'){
			erpPopupOrderCheckList(erpGrid);
		}
	}
	
	
	/****************************************************************************/
    /* erpGrid 초기화                                                           */
    /****************************************************************************/	
	function initErpGrid(){
		erpGridColumns = [
			      {id : "NO"               , label:["NO"                , "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
				, {id : "CHECK"            , label:["#master_checkbox"  , "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
				, {id : "REQ_DATE"         , label:["발주일자"          , "#text_filter"], type: "ro", width: "130", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "IN_WARE_CD"       , label:["입고창고코드"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "IN_WARE_NM"       , label:["입고창고"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "SUPR_CD"          , label:["협력사코드"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "SUPR_NM"          , label:["협력사명"          , "#text_filter"], type: "ro", width: "160", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "SUPR_AMT"         , label:["공급가액"          , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"          , label:["부가세"            , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"          , label:["합계금액"          , "#text_filter"], type: "ron", width: "90", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "GOODS_NM"         , label:["발주상품"          , "#text_filter"], type: "ro", width: "200", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "RESV_DATE"        , label:["납기일자"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "ORD_TYPE_NM"      , label:["발주유형"          , "#text_filter"], type: "ro", width: "80" , sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "ORD_STATE_NM"     , label:["진행상태"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "ORD_NO"           , label:["발주번호"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
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
			
			var ORGN_DIV_CD = this.cells(rowId, this.getColIndexById("ORGN_DIV_CD")).getValue();
			var ORGN_CD     = this.cells(rowId, this.getColIndexById("ORGN_CD")).getValue();
			var ORD_NO      = this.cells(rowId, this.getColIndexById("ORD_NO")).getValue();
			
			openCustomerinputPopup(ORGN_DIV_CD, ORGN_CD, ORD_NO);
		});
		
	}

	/****************************************************************************/
    /* 더블클릭시 발주서(입력/수정) 팝업화면 호출                               */
    /****************************************************************************/	
	function openCustomerinputPopup(CURR_ORGN_DIV_CD, CURR_ORGN_CD, CURR_ORD_NO){
		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window("openOrderSearchGridPopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
			
		}
		
		/* ORD_TYPE :  1:발주, 2:주문 */
		var url = "/sis/order/openOrderSearchGridPopup.sis";
		var params = {  "ORGN_DIV_CD" : CURR_ORGN_DIV_CD,  "ORGN_CD" : CURR_ORGN_CD,  "ORD_NO" : CURR_ORD_NO, "ORD_TYPE": LOGIN_ORD_TYPE   }
		
		var option = {
				"win_id" : "openOrderSearchGridPopup",
				"width"  : 1420,
				"height" : 850
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

		/* @@@@@@@@@@@@@@@@@  getSearchOrderList.do */
		$.ajax({
			url : "/sis/order/getSecondOrderList.do"
			,data : {
				        "PARAM_REQ_DATE"  : scrin_searchordStrDt
				      , "PARAM_ORD_TYPE"  : LOGIN_ORD_TYPE
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

				<col width="*">				
			</colgroup>
			<tr>
				<th>주문일자</th>
				<td colspan="2">
					<input type="text" id="searchordStrDt" name="searchordStrDt"  style = "text-align:center; width:100px" readonly="readonly" disabled="disabled" >
				</td>
			</tr>
			
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid"   class="div_grid_full_size"   style="display:none"></div>
</body>

	
</html>