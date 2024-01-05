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
	LUI.exclude_auth_cd = "ALL,1";
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var GOODS_NM = ""; //상품명
	var Custmr_Name = ""; //협력사명
	var GoodsGroup_Name = "";   //선택된 상품분류명
	var custmr_cd = ""; //협력사코드
	var cmbORGN_DIV_CD;
	var cmbORGN_CD; 
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	$(document).ready(function(){
		initErpGrid();
		initErpLayout();
		initDhtmlXCombo();
		initErpRibbon();
		
		$erp.asyncObjAllOnCreated(function(){
			if(LUI.LUI_searchable_auth_cd =="3" || LUI.LUI_searchable_auth_cd =="4" || LUI.LUI_searchable_auth_cd =="3,4"){//센터만 우클릭막음
			}else{
				GridContextMenu();
			}
		});
		
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a" , text : "조회조건영역", header : false}
				, {id: "b", text : "리본영역", header : false, fix_size:[true, true]}
				, {id: "c", text : "그리드영역", header : false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_search");
		erpLayout.cells("a").setHeight($erp.getTableHeight(5));
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1,0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
		});
		
	}
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : "rows", list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				//isSearchValidate();
				searchGoodsPrice();
			} else if(itemId == "print_erpGrid"){
				var checked_bcd_list = erpGrid.getCheckedRows(erpGrid.getColIndexById("CHECK")).split(',');
				if(checked_bcd_list[0] == ''){
					$erp.alertMessage({
						"alertMessage" : "출력할 상품을 1개이상 선택해주세요.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
				}else {
					var bcd_cd_list = [];
					for(var i = 0 ; i < checked_bcd_list.length ; i++){
						bcd_cd_list.push(erpGrid.cells(checked_bcd_list[i], erpGrid.getColIndexById("BCD_CD")).getValue());
					}
					
					$erp.openLabelPrintPopup({
						"BCD_LIST" : JSON.stringify(bcd_cd_list)
						, "ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
						, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
					});
				}
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid(){
		erpGridColumns = [
			{id:"NO", label:["NO", "#rspan"], type: "cntr", width: "35", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "CHECK", label : ["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false}
		  , {id : "ORGN_CD", label:["조직명", "#rspan"], type: "combo", width: "100", align : "left",sort : "str", isHidden : false, isDisabled: true, isEssential : false, commonCode : ["ORGN_CD"]}
		  , {id : "BCD_CD", label:["상품바코드", "#text_filter"], type: "ro", width: "130", align : "left", isHidden : false, isEssential : false}
		  , {id : "BCD_NM", label:["상품명", "#text_filter"], type: "ro", width: "320", align : "left", isHidden : false, isEssential : false}
		  , {id : "UNIT_CD", label:["단위", "#rspan"], type: "combo", width: "85", align : "left",sort : "str", isHidden : false, isEssential : false, commonCode : "UNIT_CD"}
		  , {id : "CUSTMR_CD", label:["협력사코드", "#rspan"], type: "ro", width: "100", align : "left",sort : "str" ,isHidden : true, isEssential : false}
		  , {id : "CUSTMR_NM", label:["협력사명", "#rspan"], type: "ro", width: "150", align : "left",sort : "str" ,isHidden : false, isEssential : false}
		  , {id : "USE_YN", label:["단가사용여부", "#rspan"], type: "combo", width: "120", align : "left",sort : "str" ,isHidden : false, isEssential : false, isDisabled : true, commonCode : ["USE_CD", "YN"]}
		  , {id : "PUR_PRICE", label:["입고단가", "#rspan"], type: "ron", width: "100", align : "right",sort : "int" ,isHidden : false, isEssential : false, numberFormat : "0,000"}
		  , {id : "SALE_PRICE", label:["출고단가", "#rspan"], type: "ron", width: "100", align : "right",sort : "int" ,isHidden : false, isEssential : false, numberFormat : "0,000"}
		  , {id : "PROF_RATE", label:["기준판매이익율", "#rspan"], type: "ron", width: "100", align : "right",sort : "int", isHidden : false, isEssential : false, numberFormat : "0.00%"}
		  , {id : "CUR_RATE", label:["이익율", "#rspan"], type: "ron", width: "100", align : "right",sort : "int", isHidden : false, isEssential : false, numberFormat : "0.00%"}
		  , {id : "WSALE_PRICE_01", label:["도매가1", "#rspan"], type: "ron", width: "100", align : "right",sort : "int", isHidden : true, isEssential : false, numberFormat : "0,000"}
		  , {id : "WSALE_PRICE_02", label:["도매가2", "#rspan"], type: "ron", width: "100", align : "right",sort : "int", isHidden : true, isEssential : false, numberFormat : "0,000"}
		  , {id : "WSALE_PRICE_03", label:["도매가3", "#rspan"], type: "ron", width: "100", align : "right",sort : "int", isHidden : true, isEssential : false, numberFormat : "0,000"}
		  , {id : "WSALE_PRICE_04", label:["도매가4", "#rspan"], type: "ron", width: "100", align : "right",sort : "int", isHidden : true, isEssential : false, numberFormat : "0,000"}
		  , {id : "WSALE_PRICE_05", label:["도매가5", "#rspan"], type: "ron", width: "100", align : "right",sort : "int", isHidden : true, isEssential : false, numberFormat : "0,000"}
		  , {id : "ORGN_DIV_CD", label:["법인구분", "#rspan"], type: "combo", width: "150", align : "center",sort : "str", isHidden : true, isEssential : false, commonCode : ["ORGN_DIV_CD"]}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent : "div_erp_grid"
			, skin : ERP_LAYOUT_CURRENT_SKINS
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
	}
	
	function GridContextMenu(){
		var items = [
			{id: "All_Columns",  text: "펼쳐보기"},
			{id: "Part_Columns", text: "줄여보기"},
		];
		
		var onRightClick = function(id, zoneId, cas){
			var selectedRowsData;
			
			var prefixId = id.split("_____")[0];
			var value = id.split("_____")[1];
			
			/* console.log("id : " + id);
			console.log("prefixId : " + prefixId);
			console.log("value : " + value); */
			
			if(prefixId == "All_Columns"){
				console.log("펼쳐보기 클릭");
				erpGrid.setColumnHidden(erpGrid.getColIndexById("WSALE_PRICE_01"),false);
				erpGrid.setColumnHidden(erpGrid.getColIndexById("WSALE_PRICE_02"),false);
				erpGrid.setColumnHidden(erpGrid.getColIndexById("WSALE_PRICE_03"),false);
				erpGrid.setColumnHidden(erpGrid.getColIndexById("WSALE_PRICE_04"),false);
				erpGrid.setColumnHidden(erpGrid.getColIndexById("WSALE_PRICE_05"),false);
				GridContextMenu();
			}else if(prefixId == "Part_Columns"){
				erpGrid.setColumnHidden(erpGrid.getColIndexById("WSALE_PRICE_01"),true);
				erpGrid.setColumnHidden(erpGrid.getColIndexById("WSALE_PRICE_02"),true);
				erpGrid.setColumnHidden(erpGrid.getColIndexById("WSALE_PRICE_03"),true);
				erpGrid.setColumnHidden(erpGrid.getColIndexById("WSALE_PRICE_04"),true);
				erpGrid.setColumnHidden(erpGrid.getColIndexById("WSALE_PRICE_05"),true);
				GridContextMenu();
			}else {
				$erp.alertMessage({
					"alertMessage" : "아직 구현되지 않았습니다. " + id,
					"alertType" : "alert",
					"isAjax" : false
				});
			}
		}
		$cm.useGridRightClick(erpGrid, items , onRightClick);
	}
	
	<%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
	function openGoodsCategoryTreePopup() {
		var onClick = function(id) {
			document.getElementById("txtGRUP_CD").value = id;
			document.getElementById("GoodsGroup_Name").value = this.getItemText(id);
			$erp.closePopup2("openGoodsCategoryTreePopup");
		}
		$erp.openGoodsCategoryTreePopup(onClick);
	}
	
	
	<%-- openSearchCustmrGridPopup 협력사검색 팝업 열림 Function --%>
	function openSearchCustmrGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "1"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		var onRowSelect = function(id, ind) {			
			custmr_cd = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("txtCUSTMR_CD").value = custmr_cd;
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(){
		var All_checkList = ""; // 상품검색 팝업에서 선택된 모든 모든상품
		var Code_List = "";
		
		var onRowDblClicked = function(id) {
			document.getElementById("txtGOODS_NM").value = this.cells(id, this.getColIndexById("BCD_NM")).getValue();
			document.getElementById("txtBCD_CD").value = this.cells(id, this.getColIndexById("BCD_CD")).getValue();
			
			All_checkList = document.getElementById("txtGOODS_NM").value;
			Code_List = document.getElementById("txtBCD_CD").value;
			
			$erp.closePopup2("openSearchGoodsGridPopup");
		}
		
		var onClickAddData = function(erpPopupGrid) {
			
			var check = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK")); // 조회된 그리드내역 중 선택한 row 번호 문자열로 넘어옴 ex) 1,5,7,10
			console.log(check);
			
			var checkList = check.split(',');
			var last_list_num = checkList.length - 1;
			
			for(var i = 0 ; i < checkList.length ; i ++) {
				if(i != checkList.length - 1) {
					All_checkList += erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("GOODS_NM")).getValue() + ",";
					Code_List += erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("BCD_CD")).getValue() + ",";
				} else {
					All_checkList += erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("GOODS_NM")).getValue();
					Code_List += erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("BCD_CD")).getValue();
				}
			}
			
			if(checkList.length > 1) {
				document.getElementById("txtGOODS_NM").value = erpPopupGrid.cells(checkList[0], erpPopupGrid.getColIndexById("BCD_NM")).getValue() + ' 외 ' + (checkList.length-1) + "건";	
			} else {
				document.getElementById("txtGOODS_NM").value = erpPopupGrid.cells(checkList[0], erpPopupGrid.getColIndexById("BCD_NM")).getValue();
			}
			
			document.getElementById("txtBCD_CD").value = Code_List;
			$erp.closePopup2("openSearchGoodsGridPopup");
		}
		$erp.openSearchGoodsPopup(null, onClickAddData, {"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue() , "ORGN_CD" : cmbORGN_CD.getSelectedValue()});
		
	}
	

	function isSearchValidate() {
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($('#ck_Custmr').is(":checked") != true){
			$erp.clearDhtmlXGrid(erpGrid);
			isGoodsValidate();
		} else {
			Custmr_Name = document.getElementById("Custmr_Name").value;
			if(Custmr_Name == null || Custmr_Name == "") {
				$erp.alertMessage({
					"alertMessage" : "error.sis.goods.search.customer_nm.empty",
					"alertType" : "alert"
				});
			} else {
				$erp.clearDhtmlXGrid(erpGrid);
				searchGoodsPrice();
			}
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});	
		}
	}
	
	function isGoodsValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "alert";
		
		if($('#ck_Goods').is(":checked") == true){
			GOODS_NM = document.getElementById("txtGOODS_NM").value;
			if(GOODS_NM == "" || GOODS_NM == null) {
				$erp.alertMessage({
					"alertMessage" : "error.sis.goods.search.goods_nm.empty",
					"alertType" : "alert"
				});
			} else {
				$erp.clearDhtmlXGrid(erpGrid);
				searchGoodsPrice();
			}
		} else {
			GoodsGroup_Name = document.getElementById("GoodsGroup_Name").value;
			if(GoodsGroup_Name == "" || GoodsGroup_Name == null){
				$erp.alertMessage({
					"alertMessage" : "error.sis.goods.search.grup_nm.empty",
					"alertType" : "error"
				});
			} else if(GoodsGroup_Name == "전체분류") {
				$erp.confirmMessage({
					"alertMessage" : "<spring:message code="alert.sis.goods.searchCheck" />"
					, "alertType" : "alert"
					, "alertCallbackFn" : function SearchCatgConfirm(){
						searchGoodsPrice();
					}
				});
			} else {
				$erp.clearDhtmlXGrid(erpGrid);
				searchGoodsPrice();
			}
		}
	}
	
	function searchGoodsPrice() {
		erpLayout.progressOn();
// 		{
// 			"GRUP_CD" : $("#txtGRUP_CD").val()
// 			, "BCD_CD" : $("#txtBCD_CD").val()
// 			, "CUSTMR_CD" : $("#CUSTMR_CD").val()
// 			, "ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
// 			, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
// 			, "KEY_WORD" : $("#txtKEY_WORD").val()
// 		}
		var paramMap = $erp.dataSerialize("tb_erp_data");
		$.ajax({
			url: "/sis/price/getGoodsByPriceList.do"
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
							, '<spring:message code="grid.noSearchData" />'
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
	
	function checkboxYN(checkedNM) {
		if(checkedNM == 'goods'){
			if($('#ck_Goods').is(":checked") == true) {
				$('#Goods_Search').attr("disabled", false);
				$('#Goods_Grup_Search').attr("disabled", false);
			} else {
				$('#Goods_Search').attr("disabled", true);
				$('#Goods_Grup_Search').attr("disabled", true);	
			}
		} else if(checkedNM == 'custmr') {
			if($('#ck_Custmr').is(":checked") == true) {
				$('#Custmr_Search').attr("disabled", false);
			} else {
				$('#Custmr_Search').attr("disabled", true);
			}
		}
	}
	
	function initDhtmlXCombo(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			}); 
		});
		
		cmbPRICE_USE_YN = $erp.getDhtmlXComboCommonCode("cmbPRICE_USE_YN", "USE_YN", ["USE_CD", "YN"], 210, "모두조회", false, "Y");
	}
	
	function openSearchGoodsGrupPopup(){
		var useGoodsGrup = function(erpPopupGrid) {
			var check = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("SELECT"));
			console.log(check);
			var checkArray = check.split(",");
			var GRUP_CD_Array = [];
			var GRUP_NM_Array = [];
			var GRUP_ORGN_CD_Array = [];
			
			for(var i = 0 ; i < checkArray.length ; i ++) {
				GRUP_CD_Array.push(erpPopupGrid.cells(checkArray[i], erpPopupGrid.getColIndexById("GRUP_CD")).getValue());
				GRUP_NM_Array.push(erpPopupGrid.cells(checkArray[i], erpPopupGrid.getColIndexById("GRUP_NM")).getValue());
				GRUP_ORGN_CD_Array.push(erpPopupGrid.cells(checkArray[i], erpPopupGrid.getColIndexById("ORGN_CD")).getValue());
			}
			
			$('#txtGOODS_GRUP_CD').val(GRUP_CD_Array[0]);
			$('#txtGOODS_GRUP_NM').val(GRUP_NM_Array[0]);
			$('#txtGOODS_GRUP_ORGN_CD').val(GRUP_ORGN_CD_Array[0]);
			console.log(GRUP_CD_Array[0] + " / " + GRUP_NM_Array[0]);
			$erp.closePopup2("openGoodsGroupGridPopup");
		}
			
		$erp.openGoodsGroupGridPopup(useGoodsGrup);
	}
	
	function resetText(data){
		if(data == 'group'){
			$("#txtGRUP_CD").val("ALL");
			$("#GoodsGroup_Name").val("전체분류");
		}else if(data == 'goods_nm'){
			$("#txtGOODS_NM").val("");
			$("#txtBCD_CD").val("");
		}else if(data == 'custmr'){
			$("#txtCUSTMR_CD").val("");
			$("#Custmr_Name").val("");
		}else if(data == 'goods_group'){
			$('#txtGOODS_GRUP_CD').val("");
			$('#txtGOODS_GRUP_NM').val("");
		}
	}
	
</script>
</head>
<body>
	<div id="div_erp_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_search" class="div_common_contents_full_size" style="display:none">
			<table id="tb_erp_data" class="tb_erp_common">
				<colgroup>
					<col width="80px" />
					<col width="250px" />
					<col width="80px" />
					<col width="*" />
				</colgroup>
				<tr>
					<td colspan="4">
						<span><font style="font-weight: bold;">&nbsp;&nbsp;* 상품명 체크시, 상품분류가 아닌 상품명으로 조회됩니다.</font></span>
					</td>
				</tr>
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
					<td>
						<input type="hidden" id="txtGRUP_CD" value="ALL">
						<input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" value="전체분류" style="width:170px;" value="전체분류" onclick="resetText('group')"/>
						<input type="button" id="GoodsGroup_Search" value="검색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
					</td>
					<th>상품명</th>
					<td>
						<input type="text" id="txtGOODS_NM" name="GOODS_NM" readonly="readonly" style="width:170px;" onclick="resetText('goods_nm')"/>
						<input type="hidden" id="txtBCD_CD" name="BCD_CD"/>
						<input type="button" id="Goods_Search" value="검색" class="input_common_button" onclick="openSearchGoodsGridPopup();"/>
					</td>
				</tr>
				<tr>
					<th>협력사</th>
					<td>
						<input type="hidden" id="txtCUSTMR_CD">
						<input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" style="width:170px;" onclick="resetText('custmr')"/>
						<input type="button" id="Custmr_Search" value="검색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/>				
					</td>
					<th>상품그룹</th>
					<td>
						<input type="hidden" id="txtGOODS_GRUP_CD">
						<input type="hidden" id="txtGOODS_GRUP_ORGN_CD">
						<input type="text" id="txtGOODS_GRUP_NM" name="GOODS_GRUP_NM" readonly="readonly" style="width:170px;" onclick="resetText('goods_group')"/>
						<input type="button" id="Goods_Grup_Search" value="검색" class="input_common_button" onclick="openSearchGoodsGrupPopup()"/>
					</td>
				</tr>
				<tr>
					<th>단가사용여부</th>
					<td>
						<div id="cmbPRICE_USE_YN"></div>
					</td>
					<th>검색어</th>
					<td>
						<input type="text" id="txtKEY_WORD" name="KEY_WORD" placeholder="상품명/바코드" style="width: 170px;" onkeydown="$erp.onEnterKeyDown(event, searchGoodsPrice);">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>