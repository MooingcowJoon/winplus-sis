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


	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2,3,4";

	<%--
	※ 전역 변수 선언부 
	□ 변수명 : Type / Description
	■ erpLayout : Object / 페이지 Layout DhtmlXLayout
	■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
	■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
	■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
	■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
	■ searchCheck : String / 리본&더블클릭 조회 체크
	■ grup_cd : String / 더블클릭 조회 시 분류별코드
	  
	--%>

	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpAllGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var searchCheck = "ribbon";
	var grup_cd;

	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		
	});

	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false}
				, {id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드영역", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(72);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpAllGrid.setSizes();
		
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
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchCheck = "ribbon";
				if(document.getElementById("hidGOODS_CATEG_CD").value == ""){
					$erp.alertMessage({
						"alertMessage" : "error.sis.goods.search.grup_nm.empty"
						, "alertType" : "error"
					});
				}
				else{
					isSearchValidate(document.getElementById("hidGOODS_CATEG_CD").value);
				}
			}
		});
	}
	
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid() {
		erpGrid = {};
		erpAllGridColumns = [ 
			 {id : "GRUP_NM", label:["분류명", "#rspan"], type: "ro", width: "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_NUM", label:["상품종수", "#rspan"], type: "ro", width: "70", sort : "str", align : "right", isHidden : false, isEssential : false}
			, {id : "PAY_SUM_AMT", label:["매입가액", "#rspan"], type: "ron", width: "120", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_AMT", label:["판매가액", "#rspan"], type: "ron", width: "120", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "GRNT_AMT", label:["보증금", "#rspan"], type: "ron", width: "70", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "FREE_PUR_AMT", label:["면세재고", "#rspan"], type: "ron", width: "120", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "TAX_PUR_AMT", label:["과세재고", "#rspan"], type: "ron", width: "120", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "COM_AMT", label:["물품가액", "#rspan"], type: "ron", width: "120", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "VAT", label:["부가세", "#rspan"], type: "ron", width: "120", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "GRUP_CD", label:["그룹코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			];
		
		erpAllGrid = new dhtmlXGridObject({
			parent: "div_erp_all_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpAllGridColumns
		});
		
		erpAllGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpAllGrid);
		$erp.initGridComboCell(erpAllGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpAllGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpAllGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpAllGrid);
		$erp.attachDhtmlXGridFooterPaging(erpAllGrid, 100);
		
		erpAllGrid.attachEvent("onRowDblClicked", function(rId){
			var grup_cd = this.cells(rId, this.getColIndexById("GRUP_CD")).getValue();
			//현재선택된 그룹의 depth확인 후 대분류이면 더블클릭시, 해당 대분류내 중분류 조회내역, 중분류였으면 더블클릭시, 해당 중분류내 소분류 조회내역 보여짐처리
			
			searchCheck = "Dbclick";
			isSearchValidate(grup_cd);
		});
		
		erpGrid["div_erp_all_grid"] = erpAllGrid;
		
		document.getElementById("div_erp_all_grid").style.display = "block";
		
	}
	
	<%-- dhtmlXCombo 초기화 Function --%>   
	function initDhtmlXCombo(){
		$('#Custmr_Search').attr("disabled", true);
		
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 150, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 100, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
			$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			});
		});
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ SearchErpGrid 관련 Function 시작 --%>
	function isSearchValidate(grup_cd) {
		$("#div_erp_grid").children().each(function(index, obj){
			var display = obj.style.display;
			if(display == "block"){
				var id = obj.id;
				var grid_ID = obj.getAttribute("id");
				if (grid_ID == "div_erp_all_grid"){
					SearchErpGrid(erpAllGrid, grup_cd);
				}
				else {
				}
				return false;
			}
		});
	}
	
	function SearchErpGrid(grid_data, grup_cd) {
		if($('#ck_Custmr').is(":checked") == true){
			SURP_CD = document.getElementById("hidCustmr_CD").value;
		} else {
			SURP_CD = "";
		}
		
		var paramData = {};
		paramData["ORGN_DIV_CD"] = cmbORGN_DIV_CD.getSelectedValue();
		paramData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		paramData["GRUP_CD"] = grup_cd;
		paramData["Invalid_Goods"] = $('input[name=Invalid_Goods]:checked').length;
		paramData["Select_Goods"] = $('input[name=Select_Goods]:checked').length;
		paramData["searchCheck"] = searchCheck;
		paramData["SURP_CD"] = SURP_CD;
		erpLayout.progressOn();
		$.ajax({
				url: "/sis/stock/stockManagement/nowStockByCategoryList.do"
				, data : paramData
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOn();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(grid_data);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								grid_data
								, '<spring:message code="grid.noSearchData" />'
							);
						}else {
							grid_data.parse(gridDataList, 'js');
							
						}
					}
					$erp.setDhtmlXGridFooterRowCount(grid_data);
					erpLayout.progressOff();
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ SearchErpGrid 관련 Function 끝 --%>
	
	<%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
	function openGoodsCategoryTreePopup() {
		var onClick = function(id) {
			document.getElementById("hidGOODS_CATEG_CD").value = id;
			document.getElementById("GoodsGroup_Name").value = this.getItemText(id);
			
			$erp.closePopup2("openGoodsCategoryTreePopup");
		}
		$erp.openGoodsCategoryTreePopup(onClick);
	}
	
	<%-- openSearchCustmrGridPopup 공급사 조회 팝업 열림 Function --%>
	function openSearchCustmrGridPopup(){
		var pur_sale_type = "1";
		var onRowSelect = function(id, ind) {
			document.getElementById("hidCustmr_CD").value = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
					
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	function checkboxYN(checkedNM) {
		if(checkedNM == 'custmr') {
			if($('#ck_Custmr').is(":checked") == true) {
				$('#Custmr_Search').attr("disabled", false);
			} else {
				$('#Custmr_Search').attr("disabled", true);
			}
		}
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_data" class="table_search">
			<colgroup>
			<col width="70px;">
			<col width="250px;">
			<col width="80px;">
			<col width="160px;">
			<col width="80px;">
			</colgroup>
			<tr>
				<th>상품분류</th>
				<td>
					<input type="hidden" id="hidGOODS_CATEG_CD" value="ALL">
					<input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" disabled="disabled" value ="전체분류"/>
					<input type="button" id="GoodsGroup_Search" value="검색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
				</td>
				<th> 법인구분</th>
				<td>
					<div id="cmbORGN_DIV_CD"></div>
				</td>
				<th>조직명</th>
				<td>
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
		</table>
		<table id="tb_erp_data2" class="table_search">  
			<colgroup>
			<col width="70px;">
			<col width="250;">
			<col width="20;">
			</colgroup>
			<tr>
				<th><input type="checkbox" id="ck_Custmr" name="ck_Custmr" onclick="checkboxYN('custmr');" style="float: center;"/><label for="ck_Custmr">협력사</label></th>
				<td>
					<input type="hidden" id="hidCustmr_CD">
					<input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Custmr_Search" value="검색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/>
				</td>
				<th></th>
				<td>
					<input type="checkbox" id="Invalid_Goods" name="Invalid_Goods"/>
					<label for="Invalid_Goods">무효상품포함</label>
<!-- 					<input type="checkbox" id="Select_Goods" name="Select_Goods"/> -->
<!-- 					<label for="Select_Goods">하위분류표시</label> -->
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none">
		 <div id="div_erp_all_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>