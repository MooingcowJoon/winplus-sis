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
	console.log(LUI);
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
		■ searchDateFrom : String / 기간(갑) 시작일
		■ searchDateTo : String / 기간(갑) 마지막일
		■ All_checkList : String / 상품지정 상품내역 (상품조회팝업에서 받은 상품리스트)
	--%>
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var searchDateFrom;
	var searchDateTo;
	var cmbPUR_TYPE;
	var cmbGOODS_TAX_YN; 
	var cmbGOODS_MNG_TYPE;
	var All_checkList = "";
	var Code_List = "";
	var goods_grup;
	var custmr_cd;
	var goods_nm;
	var goods_no;
	var sale_type;
	var tax_yn;
	var mng_type;
	var SECH_TYPE = "GRUP";
	var menu_type;
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	$(document).ready(function(){
		if("${menuDto.menu_cd}" == "00612"){
			isValidPage = true;
			LUI.exclude_auth_cd = "1,2,5,6";
			LUI.exclude_orgn_type = "MK";
			document.getElementById("orgn_cd_title").innerHTML = "조직구분";
			menu_type = "CT";
		}else if("${menuDto.menu_cd}" == "00293"){
			isValidPage = true;
			LUI.exclude_auth_cd = "ALL,1,2,3,4";
			LUI.exclude_orgn_type = "OT";
			document.getElementById("orgn_cd_title").innerHTML = "조직명";
			menu_type = "MK";
		}else{
			isValidPage = false;
		}
		
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		
		if(!isValidPage){
			$erp.alertMessage({
				"alertMessage" : "메뉴명이 변경되어 페이지가 제대로 작동하지 않을 수 있습니다. 소스코드를 확인해주세요.",
				"alertCode" : null,
				"alertType" : "error",
				"isAjax" : false
			});
		}
		
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
		erpLayout.cells("a").setHeight(95);
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
		    		, "fileName" : "일레포트-일수불"		
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
			{id : "No", label:["No", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false, isEssential : false}              
			, {id : "STD_DATE", label:["일자", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "ORGN_CD", label:["조직구분", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : "ORGN_CD"}
			, {id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SLIP_QTY", label:["매입수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "SALE_QTY", label:["판매수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false}
			//, {id : "BCD_CD", label:["사내소비수량", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false}
			, {id : "STOCK_QTY", label:["기초수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "STOCK_AMT", label:["기초단가", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : true, isEssential : false}
			, {id : "NEXT_STOCK_QTY", label:["기말수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "NEXT_STOCK_AMT", label:["기말단가", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : true, isEssential : false}
			, {id : "ERP_STOCK_QTY", label:["ERP기초수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : true, isEssential : false}
			, {id : "ERP_STOCK_AMT", label:["ERP기초단가", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : true, isEssential : false}
			, {id : "ERP_NEXT_STOCK_QTY", label:["ERP기말수량", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : true, isEssential : false}
			, {id : "ERP_NEXT_STOCK_AMT", label:["ERP기말단가", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : true, isEssential : false}
        ];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
		});
		
		erpGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
		
		erpGrid.attachEvent("onRowDblClicked", function(rId, cInd){
			var crud = "U";
			var goods_no = erpGrid.cells(rId, erpGrid.getColIndexById("GOODS_NO")).getValue()
			$erp.openGoodsInformationPopup({"GOODS_NO" : goods_no, "CRUD" : crud});
		}); 
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbPUR_TYPE = $erp.getDhtmlXComboCommonCode("cmbPUR_TYPE", "PUR_TYPE", ["PUR_TYPE", "", "CATG"], 100, "모두조회", false, "");
		cmbGOODS_TAX_YN = $erp.getDhtmlXComboCommonCode("cmbGOODS_TAX_YN", "GOODS_TAX_YN", "GOODS_TAX_YN", 100, "모두조회", false, "");
		cmbGOODS_MNG_TYPE = $erp.getDhtmlXComboCommonCode("cmbGOODS_MNG_TYPE", "GOODS_MNG_TYPE", "GOODS_MNG_TYPE", 100, "모두조회", false, "");
		
		var blankData = null;
		if(LUI.LUI_searchable_auth_cd.indexOf("ALL") == 0){
			blankData = "AllOrOne";
		}
		
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, blankData, false, LUI.LUI_orgn_div_cd, function(){
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
		
		chkSearch_Goods = $erp.getDhtmlXCheckBox("chkSearch_Goods", "상품지정", "", false);
		document.getElementById("Goods_Search").disabled = true;
		chkSearch_Goods.attachEvent("onChange", function(name, value, checked){
			if(checked == true){
				document.getElementById("Goods_Search").disabled = false;
			}else {
				document.getElementById("Goods_Search").disabled = true;
			}
		});
	} 
	
	function SearchErpGrid() {
		var paramMap = $erp.dataSerialize("tb_erp_data", "boolean");
		paramMap["DELIGATE_ORGN_DIV_CD"] = 'C';
		paramMap["MENU_TYPE"] = menu_type;
		erpLayout.progressOn();
		$.ajax({
			url: "/sis/report/dayByReport/getSuboolList.do"
			, data: paramMap
			, method: "POST"
			, dataType: "JSON"
			, success: function(data){
				$erp.clearDhtmlXGrid(erpGrid);
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							,  '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
				erpLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	
	<%-- openSearchCustmrGridPopup 공급사검색 팝업 열림 Function --%>
	function openSearchCustmrGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "1"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		var onRowSelect = function(id, ind) {
			document.getElementById("hidCustmr_CD").value = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
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
	
	function openSearchGoodsPopup() {
		var onRowSelect = function(id) {
			document.getElementById("txtGOODS_NM").value = this.cells(id, this.getColIndexById("BCD_NM")).getValue();
			document.getElementById("txtBCD_CD").value = this.cells(id, this.getColIndexById("BCD_CD")).getValue();
			$erp.closePopup2("openSearchGoodsGridPopup");
		}
		
		$erp.openSearchGoodsPopup(onRowSelect, null, {"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue(), "ORGN_CD" : cmbORGN_CD.getSelectedValue()});
	}
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table  id="tb_erp_data" class="table_search">
			<colgroup>
				<col width="70px;">
				<col width="230px;">
			    <col width="90px;">
			    <col width="120px;">
			    <col width="70px;">
			    <col width="120px;">
			    <col width="70px;">
			    <col width="*">
			</colgroup>
			<tr>
				<th>법인구분</th>
				<td>
					<div id="cmbORGN_DIV_CD"></div>
				</td>
				<th id="orgn_cd_title">조직명</th>
				<td colspan="5">
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
			<tr>
				<th>상품분류</th>
				<td>   
					<input type="hidden" id="txtGRUP_CD" value="ALL">
					<input type="text" id="txtGRUP_NM" name="GRUP_NM" readonly="readonly" disabled="disabled" value="전체분류"/>
					<input type="button" id="GoodsGroup_Search" value="검 색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
				</td>
<!-- 				<th>협력사</th> -->
<!-- 				<td colspan="3"> -->
<!-- 					<input type="hidden" id="hidCustmr_CD"> -->
<!-- 					<input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled"/> -->
<!-- 					<input type="button" id="Custmr_Search" value="검 색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/> -->
<!-- 					&nbsp;&nbsp; -->
<!-- 				</td> -->
				<th>
					<div id="chkSearch_Goods"></div>
				</th>
				<td colspan="3">
					<input type="hidden" id="txtBCD_CD">
					<input type="text" id="txtGOODS_NM" name="GOODS_NM" readonly="readonly"/>
					<input type="button" id="Goods_Search" value="검 색" class="input_common_button" onclick="openSearchGoodsPopup();"/>
				</td>
			</tr>
			<tr>
				<th> 기    간 </th>
				<td>
					<input type="text" id="txtsearchDateFrom" name="searchDateFrom" class="input_common input_calendar default_date" data-position="">
					 ~ <input type="text" id="txtsearchDateTo" name="searchDateTo" class="input_common input_calendar default_date" data-position="">
				</td>
				<th>상품유형</th>
				<td>
					<div id="cmbPUR_TYPE"></div>
				</td>
				<th>과세유형</th>
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