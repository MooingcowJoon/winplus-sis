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
	■ crud : String / CRUD 구분용
	--%>
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpAllGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var cmbSTOCK;
	var crud;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		initErpGrid();
	
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
		erpLayout.cells("a").setHeight(100);
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
				if(document.getElementById("hidGOODS_CATEG_CD").value == ""){
					$erp.alertMessage({
						"alertMessage" : "error.sis.goods.search.grup_nm.empty"
						, "alertType" : "error"
					});
				}
				else{
					searchCheck();
				}
			}
		});
	}
	
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid() {
		
		erpGrid = {};
		erpAllGridColumns = [ 
			{id : "index", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "ORGN_CD", label:["조직명", "#rspan"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, commonCode : ["ORGN_CD","MK"]}
			, {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "170", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_M_BCD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "PUR_PRICE", label:["매입가", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_PRICE", label:["판매가", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "STOCK_QTY", label:["현재고량", "#rspan"], type: "ro", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false}
			, {id : "PR_PUR_PRICE", label:["현매입가액", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "PR_SALE_PRICE", label:["현판매가액", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "INSP_QTY", label:["실사수량", "#rspan"], type: "ro", width: "80", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "INSP_PUR_AMT", label:["실사매입가액", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "INSP_SALE_AMT", label:["실사판매가액", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "QTY_SUB", label:["수량차", "#rspan"], type: "ro", width: "80", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "PUR_AMT_SUB", label:["매입가액차", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "SALE_AMT_SUB", label:["판매가액차", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "STD_DATE", label:["기존최종실사일", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "END_DATE", label:["적용될실사일", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "GRUP_CD", label:["그룹코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "GRUP_TOP_CD", label:["상", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "GRUP_MID_CD", label:["중", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "GRUP_BOT_CD", label:["하", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : true, isEssential : false}
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
		
		erpGrid["div_erp_all_grid"] = erpAllGrid;
		document.getElementById("div_erp_all_grid").style.display = "block";
			
		erpAllGrid.attachEvent("onRowDblClicked",function(rId,cInd){
			crud = "U";
			openGoodsInformationPopup();
		});
		
		crud = "R";
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	   
	<%-- erpGrid 조회 확인 Function --%>
	function searchCheck(){
		var alertMessage = '<spring:message code="alert.sis.goods.searchCheck" />';
		var alertType = "alert";
		var callbackFunction = function(){
			SearchErpGrid(erpAllGrid, document.getElementById("hidGOODS_CATEG_CD").value);
		}
		
		var key_word = $("#txtKEY_WORD").val();
		var GRUP_CD = document.getElementById("hidGOODS_CATEG_CD").value;
		
		if(key_word == "" && GRUP_CD == "ALL"){
			$erp.confirmMessage({
				"alertMessage" : alertMessage
				, "alertType" : alertType
				, "alertCallbackFn" : callbackFunction
			});
		}else{
			SearchErpGrid(erpAllGrid, document.getElementById("hidGOODS_CATEG_CD").value);
		}
		
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		
		var alertMessage = "";
		var alertType = "error";
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
	
	<%-- dhtmlXCombo 초기화 Function --%>   
	function initDhtmlXCombo(){
		$('#Custmr_Search').attr("disabled", true);
		
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 140, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
			$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			});
		});
		
		cmbSTOCK = new dhtmlXCombo("cmbSTOCK");
		cmbSTOCK.setSize(140);
		cmbSTOCK.readonly(true);
		cmbSTOCK.addOption([   
			{value: "00", text: "모두조회" ,selected: true}
			,{value: "01", text: "재고 > 0"}
			,{value: "02", text: "재고 < 0"}
			,{value: "03", text: "재고 = 0"}
			,{value: "04", text: "재고 0 아님"}
		]);
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ SearchErpGrid 관련 Function 시작 --%>
	function SearchErpGrid(erpAllGrid) {
		if(!isSearchValidate()){
			return;
		}
		
		if($('#ck_Custmr').is(":checked") == true){
			SURP_CD = document.getElementById("hidCustmr_CD").value;
		} else {
			SURP_CD = "";
		}
		
		if($('#Select_Goods').is(":checked") == true){
			Goods_Name = $("#txtGRUP_CD").val();
		} else {
			Goods_Name = "";
		}
		
		var paramData = {};
		paramData["ORGN_DIV_CD"] = cmbORGN_DIV_CD.getSelectedValue();
		paramData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		paramData["cmbSTOCK"] = cmbSTOCK.getSelectedValue(); 
		paramData["SURP_CD"] = SURP_CD;
		paramData["KEY_WORD"] = $("#txtKEY_WORD").val();
		paramData["GRUP_CD"] = document.getElementById("hidGOODS_CATEG_CD").value;
		paramData["Invalid_Goods"] = $('input[name=Invalid_Goods]:checked').length;
		paramData["Goods_Name"] = Goods_Name;
		
		erpLayout.progressOn();
		$.ajax({
			url: "/sis/stock/stockManagement/nowStockBySingleList.do"
			, data : paramData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpLayout.progressOn();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpAllGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpAllGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpAllGrid.parse(gridDataList, 'js');
						crud = "R";
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpAllGrid);
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
		
	<%-- openGoodsInformationPopup 상품정보 팝업 열림 Function --%>
	function openGoodsInformationPopup() {
		var selectedRow = erpAllGrid.getSelectedRowId();
		var goods_no = null;
		var bcd_m_cd = null;
		if(selectedRow != null){
			goods_no = erpAllGrid.cells(selectedRow,erpAllGrid.getColIndexById("GOODS_NO")).getValue();
			bcd_m_cd = erpAllGrid.cells(selectedRow, erpAllGrid.getColIndexById("GOODS_M_BCD")).getValue();
		}
		$erp.openGoodsInformationPopup({"GOODS_NO" : goods_no, "BCD_CD" : bcd_m_cd, "CRUD" : crud}); 
	}
		
	<%-- openGoodsGroupGridPopup 상품집합그룹관리 팝업 열림 Function --%>
	function openGoodsGroupGridPopup() {
		if($('#Select_Goods').is(":checked") == true) {
			var useGoodsGrup = function(erpPopupGrid) {
				var SELECT = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("SELECT"));
				console.log(SELECT);
				var selectArray = SELECT.split(",");
				var GRUP_CD_Array = [];
				var GRUP_NM_Array = [];
				
				for(var i = 0 ; i < selectArray.length ; i ++) {
					GRUP_CD_Array.push(erpPopupGrid.cells(selectArray[i], erpPopupGrid.getColIndexById("GRUP_CD")).getValue());
					GRUP_NM_Array.push(erpPopupGrid.cells(selectArray[i], erpPopupGrid.getColIndexById("GRUP_NM")).getValue());
				}
				
				$('#txtGRUP_CD').val(GRUP_CD_Array[0]);
				$('#txtGOODS_NAME').val(GRUP_NM_Array[0]);
				console.log(GRUP_CD_Array[0] + " / " + GRUP_NM_Array[0]);
				$erp.closePopup2("openGoodsGroupGridPopup");
			}
			
			$erp.openGoodsGroupGridPopup(useGoodsGrup);
		}
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
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_data" class="table_search">
			<colgroup>
			<col width="70px;">
			<col width="240px;">
			<col width="80px;">
<!-- 			<col width="160px;"> -->
<!-- 			<col width="60px;"> -->
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
		</table>
		<table id="tb_erp_data2" class="table_search">
			<colgroup>
			<col width="70px;">
			<col width="240px;">
			<col width="80px;">
			</colgroup>
			<tr>
<!-- 				<th><input type="checkbox" id="ck_Custmr" name="ck_Custmr" onclick="checkboxYN('custmr');" style="float: center;"/>협력사</th> -->
<!-- 				<td> -->
<!-- 					<input type="hidden" id="hidCustmr_CD"> -->
<!-- 					<input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled"/> -->
<!-- 					<input type="button" id="Custmr_Search" value="검색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/> -->
<!-- 				</td> -->
				<th>상품분류</th>
				<td>
					<input type="hidden" id="hidGOODS_CATEG_CD" value="ALL">
					<input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" disabled="disabled" value ="전체분류"/>
					<input type="button" id="GoodsGroup_Search" value="검색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
				</td>
				<th>재고유무</th>
				<td>
					<div id="cmbSTOCK"></div>
				</td>
			</tr>
		</table>
		<table id="tb_erp_data3" class="table_search">
			<colgroup>
			<col width="70px;">
			<col width="240px;">
			<col width="20px;">
			</colgroup>
			<tr>
			<th>검색어</th>
			<td>
				<input type="text" id="txtKEY_WORD" name="txtKEY_WORD" class="input_common" maxlength="10" onkeydown="$erp.onEnterKeyDown(event, searchCheck);" style = "width:200px"/>
			</td>
			<th></th>
				<td>
					<input type="checkbox" id="Invalid_Goods" name="Invalid_Goods" />
					<label for="Invalid_Goods">무효상품포함</label>
					<input type="checkbox" id="Select_Goods" name="Select_Goods" onchange="openGoodsGroupGridPopup();"/>
					<label for="Select_Goods">상품집합</label>
					<input type="hidden" id="txtGRUP_CD"/>
					<input type="text" id="txtGOODS_NAME" name="txtGOODS_NAME" readonly="readonly" disabled="disabled" style = "width:130px"/>
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