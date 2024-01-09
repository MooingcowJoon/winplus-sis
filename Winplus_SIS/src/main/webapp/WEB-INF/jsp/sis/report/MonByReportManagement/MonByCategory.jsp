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
	 --%>
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmbSearch;
	var cmbPUR_TYPE;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
	});
	
	<%-- ■ erpLayout 관련 Function 끝 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "월_분류별 조회", header:false}
				, {id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드영역", header:false}
			]
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(90);
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
					, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : false}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	SearchErpGrid();
		    } else if(itemId == "excel_erpGrid"){
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "월레포트-분류별"		
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
		erpGridColumns = [ 
			{id : "No", label:["순서", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false}              
			, {id : "GRUP_NM", label:["구분", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false}
			, {id : "GRUP_CD", label:["그룹코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true}
			, {id : "TOT_DC_AMT", label:["할인금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "TOT_EVENT_DC_AMT", label:["특매할인금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_QTY", label:["판매수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_APPR_AMT", label:["판매금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_VAT", label:["판매VAT", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SALE_TOT_AMT", label:["판매총액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_QTY", label:["구매수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_APPR_AMT", label:["구매금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_VAT", label:["구매VAT", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
			, {id : "SLIP_TOT_AMT", label:["구매총액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, numberFormat : "0,000"}
        ];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
		});
		
		$erp.attachDhtmlXGridFooterSummary(erpGrid,["TOT_DC_AMT","TOT_EVENT_DC_AMT","SALE_QTY","SALE_APPR_AMT","SALE_VAT","SALE_TOT_AMT","SLIP_QTY","SLIP_APPR_AMT","SLIP_VAT","SLIP_TOT_AMT"], 1, "합계");
		erpGridDataProcessor = $erp.initGrid(erpGrid);
		
		erpGrid.attachEvent("onRowDblClicked",function(rId, cInd){
			$("#txtGRUP_NM").val(erpGrid.cells(rId, erpGrid.getColIndexById("GRUP_NM")).getValue());
			$("#txtGRUP_CD").val(erpGrid.cells(rId, erpGrid.getColIndexById("GRUP_CD")).getValue());
			SearchErpGrid();
		});
		
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbPUR_TYPE = $erp.getDhtmlXComboCommonCode("cmbPUR_TYPE", "PUR_TYPE", ["PUR_TYPE", "", "CATG"], 150, "모두조회", false);
		
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
		var paramMap = $erp.dataSerialize("tb_search_data");
		paramMap["DELIGATE_ORGN_DIV_CD"] = 'C';
		
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/report/MonByReport/getMonByCategoryList.do"
			,data : paramMap
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				$erp.clearDhtmlXGrid(erpGrid);
				erpLayout.progressOff();
				var gridDataList = data.gridDataList;
				console.log(gridDataList);
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
					$erp.setDhtmlXGridFooterSummary(erpGrid,["TOT_DC_AMT","TOT_EVENT_DC_AMT","SALE_QTY","SALE_APPR_AMT","SALE_VAT","SALE_TOT_AMT","SLIP_QTY","SLIP_APPR_AMT","SLIP_VAT","SLIP_TOT_AMT"], 1, "합계");
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	
	<%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
	function openGoodsCategoryTreePopup() {
		var onClick = function(id) {
			document.getElementById("txtGRUP_CD").value = id;
			document.getElementById("txtGRUP_NM").value = this.getItemText(id);
			
			$erp.closePopup2("openGoodsCategoryTreePopup");
		}
		$erp.openGoodsCategoryTreePopup(onClick);
	}

</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_search_data" class="table_search">
			<colgroup>
				<col width="70px;">
			    <col width="210px;">
			    <col width="70px;">
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
				<th>상품분류 </th>
				<td colspan="3">
					<input type="hidden" id="txtGRUP_CD" value="ALL">
					<input type="text" id="txtGRUP_NM" name="GRUP_NM" readonly="readonly" disabled="disabled" value="전체분류"/>
					<input type="button" id="GoodsGroup_Search" value="검 색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
				</td>
			</tr>
			<tr>
				<th>기간</th>
				<td>
					<input type="text" id="txtsearchDateFrom" name="searchDateFrom" class="input_common input_calendar_ym default_date" data-position="-1">
					 ~ <input type="text" id="txtsearchDateTo" name="searchDateTo" class="input_common input_calendar_ym default_date" data-position="">
				</td>
				<th>매입유형</th>
				<td>
					<div id="cmbPUR_TYPE"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>