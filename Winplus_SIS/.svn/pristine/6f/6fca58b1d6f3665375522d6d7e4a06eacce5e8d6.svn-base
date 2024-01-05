<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js"></script>
<script type="text/javascript">
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2,3,4";
	LUI.exclude_orgn_type = "OT";
	
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
		■ cmenu : Object / 우클릭메뉴
		■ searchDateFrom : String / 기간 시작일
		■ searchDateTo : String / 기간 마지막일
		■ cmbGOODS_SALES_TYPE : Object / 검색조건(매출유형) DhtmlXCombo
		■ cmbSearch02 : Object / 검색조건(과세구분) DhtmlXCombo
		■ cmbSearch03 : Object / 검색조건(상품유형) DhtmlXCombo
	 --%>
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmenu;
	var searchDateFrom;
	var searchDateTo;
	var cmbGOODS_SALES_TYPE;
	var cmbGOODS_TAX_YN;
	var cmbGOODS_MNG_TYPE;
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		
		$erp.asyncObjAllOnCreated(function(){
		});
	});
	
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(92);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					//, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : false}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	SearchErpGrid();
		    } else if(itemId == "excel_erpGrid"){
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "일레포트-단품별"		
		    		, "isForm" : false
		    	});
		    } else if (itemId == "print_erpGrid"){
		    	$erp.alertMessage({
					"alertMessage" : "준비중입니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false
				});
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid() {
		erpGridColumns = [ //id값 변경필수!
			{id : "NO", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "STD_DATE", label:["일자", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_DIV_CD", label:["법인코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "ORGN_CD", label:["조직코드", "#rspan"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : "ORGN_CD"}
			, {id : "GRUP_TOP_CD", label:["상품분류(대)", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "GRUP_MID_CD", label:["상품분류(중)", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "GRUP_BOT_CD", label:["상품분류(소)", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "GOODS_NM", label:["상품명", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_PUR_CD", label:["상품유형", "#rspan"], type: "combo", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["PUR_TYPE", "", "CATG"]}
			, {id : "GOODS_SALE_TYPE", label:["판매유형", "#rspan"], type: "combo", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true,commonCode : "GOODS_MNG_TYPE"}
			//, {id : "ITEM_TYPE", label:["품목구분", "#rspan"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true,commonCode : ["ITEM_TYPE", "M"]}
			, {id : "STOCK_QTY", label:["기초재고수량", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "NEXT_STOCK_QTY", label:["기말재고수량", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_REG_TYPE_DETL", label:["판매구분", "#rspan"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isDisabled : true, isEssential : false, commonCode : "SALE_REG_TYPE"}
			, {id : "SALE_QTY", label:["판매수량", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_APPR_AMT", label:["판매금액", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_VAT", label:["판매VAT", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_TOT_AMT", label:["판매총액", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_TYPE_DETL", label:["구매구분", "#rspan"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isDisabled : true, isEssential : false, commonCode : "SLIP_TYPE"}
			, {id : "SLIP_QTY", label:["구매수량", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_APPR_AMT", label:["구매금액", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_VAT", label:["구매VAT", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SLIP_TOT_AMT", label:["구매총액", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "TOT_DC_AMT", label:["할인금액", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "TOT_EVENT_DC_AMT", label:["특매할인금액", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "TAX_TYPE", label:["과세구분", "#rspan"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true,commonCode : "GOODS_TAX_YN"}
			, {id : "MAT_TEMPER_INFO", label:["품온정보", "#rspan"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true,commonCode : "MAT_TEMPER_INFO"}
			, {id : "GOODS_TC_TYPE", label:["TC상품유형", "#rspan"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true,commonCode : "TC_TYPE"}
			, {id : "DELI_DD_YN", label:["일배상품여부", "#rspan"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DELI_AREA_YN", label:["착지변경상품여부", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
        ];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
		});
		
		$erp.attachDhtmlXGridFooterSummary(erpGrid,["STOCK_QTY","NEXT_STOCK_QTY","SALE_QTY","SALE_APPR_AMT","SALE_VAT","SALE_TOT_AMT","SLIP_QTY","SLIP_APPR_AMT","SLIP_VAT","SLIP_TOT_AMT","TOT_DC_AMT","TOT_EVENT_DC_AMT"], 1, "합계");
		erpGridDataProcessor = $erp.initGrid(erpGrid);
		
		erpGrid.attachEvent("onRowDblClicked", function(rId, cInd){
			var crud = "U";
			var goods_no = erpGrid.cells(rId, erpGrid.getColIndexById("GOODS_NO")).getValue()
			$erp.openGoodsInformationPopup({"GOODS_NO" : goods_no, "CRUD" : crud});
		}); 
		
		
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbPUR_TYPE = $erp.getDhtmlXComboCommonCode("cmbPUR_TYPE", "PUR_TYPE", ["PUR_TYPE", "", "CATG"], 120, "모두조회", false, "");
		cmbGOODS_TAX_YN = $erp.getDhtmlXComboCommonCode("cmbGOODS_TAX_YN", "GOODS_TAX_YN", "GOODS_TAX_YN", 120, "모두조회", false, "");
		cmbGOODS_MNG_TYPE = $erp.getDhtmlXComboCommonCode("cmbGOODS_MNG_TYPE", "GOODS_MNG_TYPE", "GOODS_MNG_TYPE", 120, "모두조회", false, "");
		
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, "AllOrOne", false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, LUI.LUI_orgn_cd, function(){
				if(cmbORGN_DIV_CD.getSelectedValue() == ""){
					cmbORGN_CD.unSelectOption();
					cmbORGN_CD.clearAll();
				}
			});
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				if(value != ""){
					$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
				}
			}); 
		});
	} 
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	
	function SearchErpGrid() {
		
		if(Number(($("#searchDateFrom").val()).replace(/-/g,'')) > Number(($("#searchDateTo").val()).replace(/-/g,''))) {
			$erp.alertMessage({
				"alertMessage" : "조회기간은 시작일이 종료일 이후일 수 없습니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		} else {
			var paramMap_info = $erp.dataSerialize("tb_erp_data");
			paramMap_info["searchDateFrom"] = ($("#searchDateFrom").val()).replace(/-/g,'');
			paramMap_info["searchDateTo"] = ($("#searchDateTo").val()).replace(/-/g,'');
			paramMap_info["GOODS_PUR_CD"] = cmbPUR_TYPE.getSelectedValue();
			paramMap_info["GOODS_SALE_TYPE"] = cmbGOODS_MNG_TYPE.getSelectedValue();
			paramMap_info["TAX_TYPE"] = cmbGOODS_TAX_YN.getSelectedValue();
			paramMap_info["GOODS_CHECK_YN"] = $("#Select_Goods").is(":checked");
			paramMap_info["DELIGATE_ORGN_DIV_CD"] = "C";
			
			erpLayout.progressOn();
			$.ajax({
				url : "/sis/report/dayByReport/getDayByGoodsList.do"
				,data : paramMap_info
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					erpLayout.progressOff();
					var gridDataList = data.gridDataList;
					$erp.clearDhtmlXGrid(erpGrid);
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpGrid
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpGrid.parse(gridDataList, 'js');
						}
						$erp.setDhtmlXGridFooterSummary(erpGrid,["STOCK_QTY","NEXT_STOCK_QTY","SALE_QTY","SALE_APPR_AMT","SALE_VAT","SALE_TOT_AMT","SLIP_QTY","SLIP_APPR_AMT","SLIP_VAT","SLIP_TOT_AMT","TOT_DC_AMT","TOT_EVENT_DC_AMT"], 1, "합계");
					}
					$erp.setDhtmlXGridFooterRowCount(erpGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	<%-- openSearchCustmrGridPopup 공급사검색 팝업 열림 Function --%>
	function openSearchCustmrGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "1";
		var onRowSelect = function(id, ind) {
			document.getElementById("txthidCustmr_CD").value = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("txtCustmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	<%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
	function openGoodsCategoryTreePopup() {
		var onClick = function(id) {
			document.getElementById("txtGRUP_CD").value = id;
			document.getElementById("txtGoodsGroup_Name").value = this.getItemText(id);
			
			$erp.closePopup2("openGoodsCategoryTreePopup");
		}
		$erp.openGoodsCategoryTreePopup(onClick);
	}
	
	function openGoodsGroupGridPopup() {
		if($('#Select_Goods').is(":checked") == true) {
			var onRowSelect = function(id) {
				document.getElementById("txtGoods_Name").value = this.cells(id, this.getColIndexById("BCD_NM")).getValue();
				document.getElementById("txtBCD_CD").value = this.cells(id, this.getColIndexById("BCD_CD")).getValue();
				$erp.closePopup2("openSearchGoodsGridPopup");
			}
			
			$erp.openSearchGoodsPopup(onRowSelect, null, {"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue(), "ORGN_CD" : cmbORGN_CD.getSelectedValue()});
		}
	}

</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_data" class="table_search">
			<colgroup>
				<col width="70px;">
			    <col width="250px;">
			    <col width="70px">
			    <col width="*">
			</colgroup>
			<tr>
				<th>법인구분</th>
				<td>
					<div id="cmbORGN_DIV_CD"></div>
				</td>
				<th>조직명</th>
				<td>
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
			<tr>
				<th>상품분류</th>
				<td>
					<input type="hidden" id="txtGRUP_CD" value="ALL">
					<input type="text" id="txtGoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" disabled="disabled" value="전체분류"/>
					<input type="button" id="GoodsGroup_Search" value="검 색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
				</td>
<!-- 				<th> -->
<!-- 					<input type="checkbox" id="Select_Custmr" name="Select_Custmr" onchange="openSearchCustmrGridPopup();"/> -->
<!-- 					<label for="Select_Custmr">협력사</label> -->
<!-- 				</th> -->
				<td colspan="2">
<!-- 					<input type="hidden" id="txthidCustmr_CD"> -->
<!-- 					<input type="text" id="txtCustmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled"/> -->
<!-- 					<input type="button" id="Custmr_Search" value="검 색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/> -->
					&nbsp;
					<input type="checkbox" id="Select_Goods" name="Select_Goods" onchange="openGoodsGroupGridPopup();"/>
					<label for="Select_Goods">상품지정</label>
					<input type="hidden" id="txtBCD_CD"/>
					<input type="text" id="txtGoods_Name" name="Goods_Name" readonly="readonly" disabled="disabled"/>
				</td>
			</tr>
		</table>
		<table  id="tb_erp_data2" class="table_search">
			<colgroup>
		    	<col width="70px">
		        <col width="270px">
		        <col width="70px">
		        <col width="150px">
		        <col width="70px">
		        <col width="150px">
		        <col width="70px">
		        <col width="*">
		    </colgroup>
			<tr>
				<th>기      간</th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar default_date" data-position="(start)">
					 ~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar default_date" data-position="">
				</td>
				<th>상품유형</th>
				<td>
					<div id="cmbPUR_TYPE"></div>
				</td>
				<th>과세구분</th>
				<td>
					<div id="cmbGOODS_TAX_YN"></div>
				</td>
				<th>판매유형</th>
				<td>
					<div id="cmbGOODS_MNG_TYPE"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>