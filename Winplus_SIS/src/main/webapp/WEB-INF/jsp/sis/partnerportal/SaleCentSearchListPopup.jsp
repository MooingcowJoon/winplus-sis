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
		※ 전역 변수 선언부  ( 여신변경이력(납품) 상세 팝업화면 loanChgHisSearch.jsp )
		□ 변수명 : Type / Description
		■ erpRightLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpRightGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbIN_WARE_CD : Object / 입고창고 DhtmlXCombo  (CODE : WARE_CD )
		■ cmbORD_STATE : Object / 발주진행상태  (CODE : ORD_STATE ) 		 
	--%>
	var thisPopupWindow = parent.erpPopupWindows.window('SaleCentSearchListPopup');
	
	var erpRightGridColumns;
	var erpRightGridDataProcessor;	
	var erpRightGridSelectedCustmr_cd;   /* 그리드 rowSelected */
	
	
	var param_OBJ_CD       = "";  /* 거래처코드    */
	var param_YYYYMMDD     = "";  /* 조회일자      */
    
    
	$(document).ready(function(){		
		if(thisPopupWindow){
			thisPopupWindow.setText("${screenDto.scrin_nm}");	
			//thisPopupWindow.denyResize();
			//thisPopupWindow.denyMove();
		}
		
		param_OBJ_CD   = "${param.param_OBJ_CD}"
		param_YYYYMMDD = "${param.param_YYYYMMDD}"
	    
		initErpMiddLayout();
		initErpMiddRibbon();	
		initErpMiddGrid();
		
		search_erpMiddGrid();

       // $('input').prop('readonly', true);
	});
	
	
	/*************************************************************/
	/*  1. 중앙layout  대중소 그룹에 선택된 전체상품을 조회한다
    /************************************************************/	
	function initErpMiddLayout(){
		
		erpMiddLayout = new dhtmlXLayoutObject({
			parent   : document.body
			, skin   : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells  : [
							  {id: "a", text: "11111", header:false, }
							, {id: "b", text: "22222", header:false, fix_size:[true, true]}
						]		
		});
		
		erpMiddLayout.cells("a").attachObject("div_erp_midd_ribbon");
		erpMiddLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpMiddLayout.cells("b").attachObject("div_erp_midd_grid");
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
					    {id : "excel_erpGri2",      type : "button", text:'화면닫기',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
				]}							
			]
		});
		
		erpMiddRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpMiddGrid"){
		    	search_erpMiddGrid();
		    } else if (itemId == "excel_erpGri2"){
		    	thisOnComplete(); // 화면닫기
		    }
		});
	}
	
	/*********************************************************/
	/* 전체상품목록 조회 
	/*********************************************************/
	function initErpMiddGrid(){
		erpMiddGridColumns = [
			  {id : "NO"             , label:["NO"           , "#rspan"],       type: "cntr", width: "30",  sort : "int", align : "center", isHidden : true,  isEssential : false}
			, {id : "TRADE_TYPE_NM"  , label:["거래유형"     , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "BCD_NM"         , label:["상품명"       , "#text_filter"], type: "ro",   width: "350", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "DIMEN_NM"       , label:["규격"         , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "UNIT_NM"        , label:["단위"         , "#text_filter"], type: "ro",   width:  "50", sort : "str", align : "left",   isHidden : false, isEssential : true}
			, {id : "SALE_UNITQTY"   , label:["매입수량"     , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00000"}
			, {id : "SALE_AMT"       , label:["매입금액"     , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
			, {id : "SALE_VAT_AMT"   , label:["VAT"          , "#text_filter"], type: "ron",  width: "100", sort : "str", align : "center", isHidden : false, isEssential : true,  numberFormat : "0,000"}
			, {id : "SALE_TOT_AMT"   , label:["합계금액"     , "#text_filter"], type: "ron",  width: "100", sort : "str", align : "center", isHidden : false, isEssential : true,  numberFormat : "0,000"}
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
	/* 상세내역조회
	/*********************************************************/
	function search_erpMiddGrid(){
		/*  Iput validation은 필요없음 조건이 없으면 전체 출력 */
		erpMiddLayout.progressOn();

		$.ajax({
			  url     : "/sis/partnerportal/getSaleCentSearchList.do"
			,data     : {
							  "PARAM_OBJ_CD"    : param_OBJ_CD
							, "PARAM_YYYYMMDD"  : param_YYYYMMDD
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
	<div id="div_erp_midd_ribbon" class="div_ribbon_full_size" style="display:none"></div>	
	<div id="div_erp_midd_grid"   class="div_grid_full_size" style="display:none"></div>			
</body>
	
</html>