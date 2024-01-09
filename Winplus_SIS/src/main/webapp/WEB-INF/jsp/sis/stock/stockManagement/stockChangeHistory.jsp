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
	■ cmenu : Object / context-menu 우클릭메뉴 dhtmlXMenuObject
	--%>
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpAllGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var lossSTOCK;
	var cmbINSP_STOCK_STATE;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var All_checkList = "";
	var Code_List = "";
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		initErpGrid();
		
		document.getElementById("searchDateFrom").value=todayDate;
		document.getElementById("searchDateTo").value=today;
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false, fix_size:[true, true]}
				, {id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드영역", header:false}
			]	
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(104);
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
					, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : false}
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
					SearchErpGrid(erpAllGrid, document.getElementById("hidGOODS_CATEG_CD").value);
				}
			} else if(itemId == "excel_erpGrid"){
				$erp.exportGridToExcel({
					"grid" : erpAllGrid
					, "fileName" : "재고변경 이력조회"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			} else if (itemId == "print_erpGrid"){
				$erp.alertMessage({
					"alertMessage" : "준비 중 입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			}
		});
	}
	
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid() {
		erpGrid = {};
		erpAllGridColumns = [ 
			{id : "index", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "APPLY_DATE", label:["실사적용일", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "GOODS_BCD", label:["바코드", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "GOODS_NM", label:["상품명", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "INSP_QTY", label:["실사수량", "#rspan"], type: "ro", width: "80", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "STOCK_BEFR", label:["실사전수량", "#rspan"], type: "ro", width: "80", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "LOSS_QTY", label:["로스량", "#rspan"], type: "ro", width: "80", sort : "str", align : "right", isHidden : false, isEssential : true}
			, {id : "PUR_PRICE", label:["매입단가", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "SALE_PRICE", label:["판매단가", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "INSP_PAY_SUM_AMT", label:["실사매입단가", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "INSP_SALE_AMT", label:["실사판매단가", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "LOSS_PAY_SUM_AMT", label:["로스매입단가", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "LOSS_SALE_AMT", label:["로스판매단가", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : true , numberFormat : "0,000"}
			, {id : "SLIP_DATE", label:["실사등록일", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "INSP_TYPE", label:["비고", "#rspan"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, commonCode : ["INSP_TYPE"]}
			, {id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			
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
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	
	<%-- dhtmlXCombo 초기화 Function --%>
	function initDhtmlXCombo(){
		$('#Custmr_Search').attr("disabled", true);
		$('#Goods_Search').attr("disabled", true);
		
		cmbINSP_STOCK_STATE = $erp.getDhtmlXComboCommonCode("cmbINSP_STOCK_STATE", "INSP_STOCK_STATE", "INSP_STOCK_STATE", 120, "--변경 유형--")
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 180, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 100, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
			$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			});
		});
		
		lossSTOCK = new dhtmlXCombo("lossSTOCK");
		lossSTOCK.setSize(120);
		lossSTOCK.readonly(true);
		lossSTOCK.addOption([   
			{value: "00", text: "--로스 유형--" ,selected: true}
			,{value: "01", text: "로스 = 0"}
			,{value: "02", text: "로스(-)"}
			,{value: "03", text: "로스(+)"}
			,{value: "04", text: "로스(모두)"}
		]);
		
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>

	<%-- ■ SearchErpGrid 관련 Function 시작 --%>
	function SearchErpGrid(erpAllGrid) {
		if($('#ck_Custmr').is(":checked") == true){
			SURP_CD = document.getElementById("txtSUPR_CD").value;
		}else {
			SURP_CD = "";
		}
		
		if($('#ck_Goods').is(":checked") == true){
			Goods_Name1 = document.getElementById("Goods_Name").value;
		}else{
			Goods_Name1 = "";
		}
		
		var SURP_CD = SURP_CD;
		var GRUP_CD = document.getElementById("hidGOODS_CATEG_CD").value;
		var SEARCH_DATE_FROM = document.getElementById("searchDateFrom").value;
		var SEARCH_DATE_TO = document.getElementById("searchDateTo").value;
		var lossSTOCK1 = lossSTOCK.getSelectedValue();
		var changeSTOCK1 = cmbINSP_STOCK_STATE.getSelectedValue();
		var Set_Goods = $("#txtGRUP_CD").val();
		var Goods_Name1 = Goods_Name1;
		var ORGN_DIV_CD = cmbORGN_DIV_CD.getSelectedValue();
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		$.ajax({
			url: "/sis/stock/stockManagement/stockChangeHistoryList.do"
			, data : {
				"SEARCH_DATE_FROM" : SEARCH_DATE_FROM
				, "SEARCH_DATE_TO" : SEARCH_DATE_TO
				, "lossSTOCK" : lossSTOCK1
				, "changeSTOCK" : changeSTOCK1
				, "SURP_CD" : SURP_CD
				, "GRUP_CD" : GRUP_CD
				, "Set_Goods" : Set_Goods
				, "Goods_Name" : Goods_Name1
				, "ORGN_CD" : ORGN_CD
				, "ORGN_DIV_CD" : ORGN_DIV_CD
			}
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
		var pur_sale_type = "1"; //협력사(매입처) == "1" 고객사(매출처) == "2"
			
		var onRowSelect = function(id, ind) {
			document.getElementById("txtSUPR_CD").value = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("txtSUPR_NM").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
				
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
		
	<%-- openGoodsGroupGridPopup 상품집합그룹관리 팝업 열림 Function --%>
	// 상품집합그룹관리 팝업 여는 함수, 상세상품 리스트 가져오는 예시
	function openGoodsGroupGridPopup() {
		if($('#Select_Goods').is(":checked") == true) {
			var useGoodsGrup = function(erpPopupGrid) {
			var SELECT = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("SELECT"));
				var selectArray = SELECT.split(",");
				var GRUP_CD_Array = [];
				var GRUP_NM_Array = [];
							
				for(var i = 0 ; i < selectArray.length ; i ++) {
					GRUP_CD_Array.push(erpPopupGrid.cells(selectArray[i], erpPopupGrid.getColIndexById("GRUP_CD")).getValue());
					GRUP_NM_Array.push(erpPopupGrid.cells(selectArray[i], erpPopupGrid.getColIndexById("GRUP_NM")).getValue());
				}
				$('#txtGRUP_CD').val(GRUP_CD_Array[0]);
				$('#txtGOODS_NAME').val(GRUP_NM_Array[0]);
				$erp.closePopup2("openGoodsGroupGridPopup");
			}
			$erp.openGoodsGroupGridPopup(useGoodsGrup);
		}
	}

	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(){
		var ORGN_DIV_CD = cmbORGN_DIV_CD.getSelectedValue();
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		
		var onRowDblClicked = function(id) {
			document.getElementById("Goods_Name").value = this.cells(id, this.getColIndexById("BCD_NM")).getValue();
			document.getElementById("hid_GOODS_CD").value = this.cells(id, this.getColIndexById("GOODS_NO")).getValue();
			//	document.getElementById("Goods_BCD").value = this.cells(id, this.getColIndexById("GOODS_BCD")).getValue();
					
			$erp.closePopup2("openSearchGoodsGridPopup");
		}
				
		var onClickAddData = function(erpPopupGrid) {
			var check = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK")); // 조회된 그리드내역 중 선택한 row 번호 문자열로 넘어옴 ex) 1,5,7,10
					
			var checkList = check.split(',');
			var last_list_num = checkList.length - 1;
					
			for(var i = 0 ; i < checkList.length ; i ++) {//바코드 가져오는것도 추가할 필요 있음!
				if(i != checkList.length - 1) { 
					All_checkList += erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("BCD_NM")).getValue() + ",";
					Code_List += erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("GOODS_NO")).getValue() + ",";
				} else {
					All_checkList += erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("BCD_NM")).getValue();
					Code_List += erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("GOODS_NO")).getValue();
				}
			}
			console.log("체크된 상품명 >> " + All_checkList);
			console.log("체크된 상품코드 >> " + Code_List);
			
			document.getElementById("Goods_Name").value = All_checkList;
			document.getElementById("hid_GOODS_CD").value = Code_List;
			
			$erp.closePopup2("openSearchGoodsGridPopup");
		}
		$erp.openSearchGoodsPopup(onRowDblClicked, "",{"ORGN_CD":ORGN_CD, "ORGN_DIV_CD":ORGN_DIV_CD});
	}

	function checkboxYN(checkedNM){
		if(checkedNM == 'custmr'){
			if($('#ck_Custmr').is(":checked") == true) {
				$('#Custmr_Search').attr("disabled", false);
			} else {
				$('#Custmr_Search').attr("disabled", true);
			}
		}
	}
	
	function checkboxGoodsYN(checkedNM){
		if(checkedNM == 'goods'){
			if($('#ck_Goods').is(":checked") == true){
				$('#Goods_Search').attr("disabled", false);
			}else{
				$('#Goods_Search').attr("disabled", true);
			}
		}
	}
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_data" class="table_search">
			<colgroup>
				<col width="80px;">
				<col width="230px;">
				<col width="80px;">
				<col width="230px;">
				<col width="80px;">
				<col width="230px;">
				<col width="5px;">
				<col width="*px;">
			</colgroup>
			<tr>
				<th>법인구분</th>
				<td>
					<div id = "cmbORGN_DIV_CD"></div>
				</td>
				<th>조직명</th>
				<td>
					<div id = "cmbORGN_CD"></div>
				</td>
			</tr>
			<tr>
				<th>상품분류</th>
				<td>
					<input type="hidden" id="hidGOODS_CATEG_CD" value="ALL">
					<input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" value="전체분류" readonly="readonly" disabled="disabled" style="width:150px;"/>
					<input type="button" id="GoodsGroup_Search" value="검색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
				</td>
					<th><input type="checkbox" id="ck_Custmr" name="ck_Custmr" onclick="checkboxYN('custmr');" style="float: center;"/>협력사</th>
				<td>
					<input type="hidden" id="txtSUPR_CD"/>
					<input type="text" id="txtSUPR_NM" class="input_text" readonly="readonly" disabled="disabled" style="width:150px;"/>
					<input type="button" id="Custmr_Search" class="input_common_button" value="검색" onClick="openSearchCustmrGridPopup();"/>
				</td>
				<td colspan="2">
					<div id="lossSTOCK"></div>
				</td>
			</tr>
		</table>
		<table id="tb_erp_data2" class="table_search">  
			<colgroup>
				<col width="70px;">
				<col width="255px;">
				<col width="250px;">
				<col width="38px;">
				<col width="280px;">
				<col width="3px;">
				<col width="20px;">
				<col width="*;">
			</colgroup>
			<tr>
				<th>재고변경일</th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
					~<input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
				</td>
				<th>
					<input type="checkbox" id="Select_Goods" name="Select_Goods" onchange="openGoodsGroupGridPopup();"/>
					<label for="Select_Goods">상품집합</label>
					<input type="hidden" id="txtGRUP_CD"/>
					<input type="text" id="txtGOODS_NAME" name="txtGOODS_NAME" readonly="readonly" disabled="disabled" style="width:160px;"/> 
				</th>
				<td></td>
				<th>
					<input type="hidden" id="hid_GOODS_CD">
					<input type="hidden" id="Goods_BCD">
					<input type="checkbox" id="ck_Goods" name="ck_Goods" onclick="checkboxGoodsYN('goods');" style="float: center;"/>
					<label for="Goods_Search" >지정상품</label>
					<input type="text" id="Goods_Name" name="WARE_CATEG_NAME" readonly="readonly" disabled="disabled" style="width:150px;"/>
					<input type="button" id="Goods_Search" value="검색" class="input_common_button" onclick="openSearchGoodsGridPopup();"/>
				</th>
				<td></td>
				<th></th>
				<td>
					<div id ="cmbINSP_STOCK_STATE"></div>
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