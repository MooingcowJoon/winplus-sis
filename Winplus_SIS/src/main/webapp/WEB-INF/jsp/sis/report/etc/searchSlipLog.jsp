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
	
	var erpLayout;
	var erpCustmrGrid;
	var erpGoodsGrid;
	var erpElseGrid;
	var erpBomGrid;
	var erpGridCustmrDataProcessor;
	var erpGridGoodsDataProcessor;
	var erpGridElseDataProcessor;
	var erpGridBomDataProcessor;
	var erpRibbon;
	var cmbSEARCH;
	var cmbLastLog;
	var All_checkList = "";
	var Code_List = "";
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		initDhtmlXCombo();
		initErpLayout();
		initErpRibbon();
		
		document.getElementById("searchDateFrom01").value=todayDate;
		document.getElementById("searchDateTo01").value=today;
		document.getElementById("searchDateFrom02").value=todayDate;
		document.getElementById("searchDateTo02").value=today;
	});
	
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, height:185}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(194);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		
		cmbSEARCH.attachEvent("onChange", function(){
			if(cmbSEARCH.getSelectedValue() == "01"){
				document.getElementById("div_erp_goods_grid").style.display = "none";
				document.getElementById("div_erp_else_grid").style.display = "none";
				document.getElementById("div_erp_bom_grid").style.display = "none";
				document.getElementById("div_erp_custmr_grid").style.display = "block";
			}else if(cmbSEARCH.getSelectedValue() == "02") {
				document.getElementById("div_erp_custmr_grid").style.display = "none";
				document.getElementById("div_erp_else_grid").style.display = "none";
				document.getElementById("div_erp_bom_grid").style.display = "none";
				document.getElementById("div_erp_goods_grid").style.display = "block";
			} else if(cmbSEARCH.getSelectedValue() == "12") {
				document.getElementById("div_erp_custmr_grid").style.display = "none";
				document.getElementById("div_erp_goods_grid").style.display = "none";
				document.getElementById("div_erp_else_grid").style.display = "none";
				document.getElementById("div_erp_bom_grid").style.display = "block";
			} else {
				document.getElementById("div_erp_custmr_grid").style.display = "none";
				document.getElementById("div_erp_goods_grid").style.display = "none";
				document.getElementById("div_erp_bom_grid").style.display = "none";
				document.getElementById("div_erp_else_grid").style.display = "block";
			}
		});
		
		erpLayout.setSeparatorSize(1, 0);
		
		erpGrid = {};
		
		var grid_Columns_1 = [
               {id : "check", label:["#master_checkbox", "#rspan"], type: "ch", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}            
   			, {id : "date", label:["전표종류", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
   			, {id : "goods_code", label:["잠재거래처코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   			, {id : "goods_spec", label:["잠재거래처", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   			, {id : "goods_bcode", label:["관리거래처코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   			, {id : "goods_bcode", label:["담당자코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
   			, {id : "goods_bcode", label:["담당자명", "#rspan"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
   			, {id : "goods_bcode", label:["최종작업구분", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
   			, {id : "log_detail", label:["이력", "#rspan"], type: "link", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}                   
		];
		
		erpCustmrGrid = new dhtmlXGridObject({
			parent: "div_erp_custmr_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : grid_Columns_1
		});
			
		erpCustmrGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpCustmrGrid);
		$erp.initGridComboCell(erpCustmrGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpCustmrGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridCustmrDataProcessor = new dataProcessor();
		erpGridCustmrDataProcessor.init(erpCustmrGrid);
		erpGridCustmrDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpCustmrGrid);
		$erp.attachDhtmlXGridFooterPaging(erpCustmrGrid, 100);
		
		erpGrid["div_erp_custmr_grid"] = erpCustmrGrid;
		
		document.getElementById("div_erp_custmr_grid").style.display = "block";
		
		var grid_Columns_2 = [
			{id : "check", label:["#master_checkbox", "#rspan"], type: "ch", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}            
			, {id : "date", label:["전표종류", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_code", label:["기준상품코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_spec", label:["기준상품명", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["최종작업구분", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["이력", "#rspan"], type: "link", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpGoodsGrid = new dhtmlXGridObject({
			parent: "div_erp_goods_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH		
			, columns : grid_Columns_2
		});
		
		erpGoodsGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpGoodsGrid);
		$erp.initGridComboCell(erpGoodsGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpGoodsGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridGoodsDataProcessor = new dataProcessor();
		erpGridGoodsDataProcessor.init(erpGoodsGrid);
		erpGridGoodsDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGoodsGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGoodsGrid, 100);
		
		erpGrid["div_erp_goods_grid"] = erpGoodsGrid;


		var grid_Columns_3 = [
			{id : "check", label:["#master_checkbox", "#rspan"], type: "ch", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "date", label:["전표종류", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_code", label:["Slip No.", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_spec", label:["기준품목코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["기준품목명", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["담당자코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["담당자명", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["전표종류", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["최종작업구분", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["이력", "#rspan"], type: "link", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
		];

		erpElseGrid = new dhtmlXGridObject({
			parent : "div_erp_else_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : grid_Columns_3
		});

		erpElseGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpElseGrid);
		$erp.initGridComboCell(erpElseGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpElseGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridElseDataProcessor = new dataProcessor();
		erpGridElseDataProcessor.init(erpElseGrid);
		erpGridElseDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpElseGrid);
		$erp.attachDhtmlXGridFooterPaging(erpElseGrid, 100);
		
		erpGrid["div_erp_else_grid"] = erpElseGrid;


		var grid_Columns_4 = [
			{id : "check", label:["#master_checkbox", "#rspan"], type: "ch", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "date", label:["전표종류", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_spec", label:["기준품목코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["BOM버전", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["기준품목명", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["최종작업구분", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["이력", "#rspan"], type: "link", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
		];

		erpBomGrid = new dhtmlXGridObject({
			parent : "div_erp_bom_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : grid_Columns_4
		});

		erpBomGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpBomGrid);
		$erp.initGridComboCell(erpBomGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpBomGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridBomDataProcessor = new dataProcessor();
		erpGridBomDataProcessor.init(erpBomGrid);
		erpGridBomDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpBomGrid);
		$erp.attachDhtmlXGridFooterPaging(erpBomGrid, 100);
		
		erpGrid["div_erp_bom_grid"] = erpBomGrid;
	}
	
	function initErpRibbon() {
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
		    	isSearchValidate();
		    } 
		});
	}
	
	function initDhtmlXCombo() {
		//작업대상
		cmbSEARCH = $erp.getDhtmlXCombo("SEARCH_TARGET", "SEARCH_TARGET", "SEARCH_TARGET" , 110 , false, false, String);
		//최종이력
		cmbLastLog = $erp.getDhtmlXCombo("FINAL_LOG_TYPE", "FINAL_LOG_TYPE", "FINAL_LOG_TYPE" , 110 , false, false, String);
	}
	
	function isSearchValidate() {
		var url_data = "";
		var param_data = {};
		var GOODS_NM = "custmr_grid_check";
		var GOODS_NO = "goods_grid_check";
		var CUSTMR;
		
		$("#div_erp_grid").children().each(function(index, obj){
			var display = obj.style.display;
			if(display == "block"){
				var id = obj.id;
				var grid_ID = obj.getAttribute("id");
				
				if(grid_ID == "div_erp_custmr_grid") {
					console.log("첫번째그리드조회영역");
					url_data = "/sis/report/etc/getCustmrSlipList.do";
					param_data = {
							"GOODS_NM" : GOODS_NM
					}
					SearchErpGrid(url_data, param_data, erpCustmrGrid);
				} else if(grid_ID == "div_erp_goods_grid") {
					console.log("두번째그리드조회영역");
					url_data = "/sis/report/etc/getGoodsSlipList.do";
					param_data = {
							"GOODS_NO" : GOODS_NO
					}
					SearchErpGrid(url_data, param_data, erpGoodsGrid);
				} else if(grid_ID == "div_erp_else_grid") {
					console.log("세번째그리드조회영역");
				} else {
					console.log("나머지그리드조회영역");
					var CMB_work = cmbSEARCH.getSelectedValue();
					
					
				}
				return false;
			}
		});
	}
	
	function SearchErpGrid(data_url, param_data, grid_data) {
		$.ajax({
			url: data_url
			, data: param_data
			, method: "POST"
			, dataType: "JSON"
			, success: function(data){
				erpLayout.progressOn();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							grid_data
							,  '<spring:message code="grid.noSearchData" />'
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
	
	   <%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
	   function openGoodsCategoryTreePopup() {
	      var onClick = function(id) {
	         document.getElementById("hidGOODS_CATEG_CD").value = id;
	         document.getElementById("GoodsGroup_Name").value = this.getItemText(id);
	         
	         $erp.closePopup2("openGoodsCategoryTreePopup");
	      }
	      $erp.openGoodsCategoryTreePopup(onClick);
	   }
	
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(){
		var onRowDblClicked = function(id) {
			document.getElementById("Goods_Name").value = this.cells(id, this.getColIndexById("BCD_NM")).getValue();
			document.getElementById("hid_GOODS_CD").value = this.cells(id, this.getColIndexById("GOODS_NO")).getValue();
			document.getElementById("Goods_BCD").value = this.cells(id, this.getColIndexById("BCD_CD")).getValue();
			
			$erp.closePopup2("openSearchGoodsGridPopup");
		}
		
		var onClickAddData = function(erpPopupGrid) {
			
			var check = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK")); // 조회된 그리드내역 중 선택한 row 번호 문자열로 넘어옴 ex) 1,5,7,10
			console.log(check);
			
			var checkList = check.split(',');
			var last_list_num = checkList.length - 1;
			
			for(var i = 0 ; i < checkList.length ; i ++) {
				if(i != checkList.length - 1) {
					All_checkList += erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("BCD_NM")).getValue() + ",";
					Code_List += erpPopupGrid.cells(checkList[i], erpPopupGrid.getColIndexById("GOODS_NO")).getValue() + ",";
				}else{
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
		
		$erp.openSearchGoodsPopup(onRowDblClicked, onClickAddData);
		
	}
	
	
	<%-- openSearchCustmrGridPopup 고객사 검색 팝업 열림 Function --%>
	function openSearchCustmrGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "2"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		var onRowSelect = function(id, ind) {			
			custmr_cd = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("hidCustmr_CD").value = custmr_cd;
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	<%-- openSlipLogDeatilPopup 전표이력조회상세 팝업 열림 Function --%>
	function openSlipLogDeatilPopup() {
		var Slip_CD = "123456789";
		
		$erp.openSlipLogDetailPopup(Slip_CD);
	}
	
	
	<%-- SearchSelectDate 간편검색 일자선택 Function --%>
	function SearchSelectDate(Selected_Date){
		var nowDate = new Date();
		var nowDayOfWeek = nowDate.getDay();
		var nowDay = nowDate.getDate();
		var nowMonth = nowDate.getMonth();
		var nowYear = nowDate.getYear();
		var nowDayOfWeek = nowDate.getDay();
		
		if(Selected_Date == "금일"){
			document.getElementById("searchDateFrom01").value=today;
			document.getElementById("searchDateTo01").value=today;
			console.log(today);
			isSearchValidate();
		} else if(Selected_Date == "전일"){
			var yesterDate = nowDate.getTime() - (1 * 24 * 60 * 60 * 1000);
			nowDate.setTime(yesterDate);
			
			var yesterYear = nowDate.getFullYear();
			var yesterMonth = nowDate.getMonth() + 1;
			var yesterDay = nowDate.getDate();
			
			if(yesterMonth < 10) {
				yesterMonth = "0" + yesterMonth;
			}
			
			if(yesterDay < 10) {
				yesterDay = "0" + yesterDay;
			}
			
			var resultDate = yesterYear + "-" + yesterMonth + "-"+ yesterDay;
			document.getElementById("searchDateFrom01").value=resultDate;
			document.getElementById("searchDateTo01").value=resultDate;
			console.log(resultDate);
			isSearchValidate();
		} else if(Selected_Date == "금주"){
			
			nowMonth = nowDate.getMonth()  + 1;
			var weekStartDay = nowDay - nowDayOfWeek;
			var weekEndDay = nowDay+(6 - nowDayOfWeek);
			
			if(nowMonth < 10){
				nowMonth = "0" + nowMonth;
			}
			
			if(weekStartDay < 10){
				weekStartDay = "0" + weekStartDay;
			}
			
			if(weekEndDay < 10){
				weekEndDay = "0" + weekEndDay;
			}
			
			nowYear += (nowYear < 2000) ? 1900 : 0; 
			var thisweekStartDate = nowYear + "-" + nowMonth + "-" + weekStartDay;
			var thisweekEndDate = nowYear + "-" + nowMonth + "-" + weekEndDay;
			console.log(thisweekStartDate + "~" + thisweekEndDate);
			document.getElementById("searchDateFrom01").value=thisweekStartDate;
			document.getElementById("searchDateTo01").value=thisweekEndDate;
			isSearchValidate();
		} else if(Selected_Date == "전주"){
			nowMonth = nowDate.getMonth() + 1;
			nowYear += (nowYear < 2000) ? 1900 : 0; 
			var weekStartDay = nowDay - nowDayOfWeek - 7;
			var weekEndDay = nowDay+(6 - nowDayOfWeek - 7);
			
			if(nowMonth < 10){
				nowMonth = "0" + nowMonth;
			}
			
			if(weekStartDay < 10){
				weekStartDay = "0" + weekStartDay;
			}
			
			if(weekEndDay < 10){
				weekEndDay = "0" + weekEndDay;
			}
			
			var prevweekStartDate = nowYear + "-" + nowMonth + "-" + weekStartDay;
			var prevweekEndDate = nowYear + "-" + nowMonth + "-" + weekEndDay;
			document.getElementById("searchDateFrom01").value=prevweekStartDate;
			document.getElementById("searchDateTo01").value=prevweekEndDate;
			console.log(prevweekStartDate + "~" + prevweekEndDate);
			isSearchValidate();
		} else if(Selected_Date == "금월"){
			nowMonth = nowDate.getMonth() + 1;
			if(nowMonth < 10){
				nowMonth = "0" + nowMonth;
			}
			nowYear += (nowYear < 2000) ? 1900 : 0; 
			
			var thismonthStartDate = nowYear + "-" + nowMonth + "-01";
			var thismonthEndDay = new Date(nowYear, nowMonth, 0).getDate();
			var thismonthEndDate = nowYear + "-" + nowMonth + "-" + thismonthEndDay;
			document.getElementById("searchDateFrom01").value=thismonthStartDate;
			document.getElementById("searchDateTo01").value=thismonthEndDate;
			console.log(thismonthStartDate + "~" + thismonthEndDate);
			isSearchValidate();
		} else if(Selected_Date == "전월"){
			nowYear += (nowYear < 2000) ? 1900 : 0; 
			if(nowMonth < 10){
				nowMonth = "0" + nowMonth;
			}
			
			var prevmonthStartDate = nowYear + "-" + nowMonth + "-01";
			var prevmonthEndDay = new Date(nowYear, nowMonth, 0).getDate();
			var prevmonthEndDate = nowYear + "-" + nowMonth + "-" + prevmonthEndDay;
			document.getElementById("searchDateFrom01").value=prevmonthStartDate;
			document.getElementById("searchDateTo01").value=prevmonthEndDate;
			console.log(prevmonthStartDate + "~" + prevmonthEndDate);
			isSearchValidate();
		} else if(Selected_Date == "금년"){
			nowYear += (nowYear < 2000) ? 1900 : 0; 
			
			var thisyearStartDate = nowYear + "-01-01";
			var thisyearEndDate = nowYear + "-12-31";
			document.getElementById("searchDateFrom01").value=thisyearStartDate;
			document.getElementById("searchDateTo01").value=thisyearEndDate;
			console.log(thisyearStartDate + "~" + thisyearEndDate);
			isSearchValidate();
		} else if(Selected_Date == "전년"){
			nowYear = nowDate.getYear()-1;
			
			nowYear += (nowYear < 2000) ? 1900 : 0; 
			
			var prevyearStartDate = nowYear + "-01-01";
			var prevyearEndDate = nowYear + "-12-31";
			document.getElementById("searchDateFrom01").value=prevyearStartDate;
			document.getElementById("searchDateTo01").value=prevyearEndDate;
			console.log(prevyearStartDate + "~" + prevyearEndDate);
			isSearchValidate();
		} else if(Selected_Date == "종료일"){
			alert("준비중입니다.");
		} else {
			
		}
	}
	
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_data" class="tb_erp_common">
			<colgroup>
				<col width="100px" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>기준일자</th>
				<td>
					<input type="text" id="searchDateFrom01" name="searchDateFrom01" class="input_common input_calendar">
					 ~ <input type="text" id="searchDateTo01" name="searchDateTo01" class="input_common input_calendar">
				</td>
				<th>창고</th>
				<td>
					<input type="hidden" id="hidWARE_CD">
					<input type="text" id="Ware_NAME" name="Ware_NAME" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Ware_Search" value="검 색" class="input_common_button" onclick=""/>
				</td>
			</tr>
			<tr>
				<th>작업대상</th>
				<td>
					<div id="SEARCH_TARGET"></div>
				</td>
				<th>창고그룹</th>
				<td>
					<input type="hidden" id="hid_WARE_CATEG_CD">
					<input type="text" id="WARE_CATEG_NAME" name="WARE_CATEG_NAME" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Ware_Categ_Search" value="검 색" class="input_common_button" onclick=""/>
				</td>
			</tr>
			<tr>
				<th>고객사</th>
				<td>
					<input type="hidden" id="hidCustmr_CD">
					<input type="text" id="Custmr_Name" name="CUSTMR_NAME" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Custmr_Search" value="검 색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/>
				</td>
				<th>프로젝트</th>
				<td>
					<input type="hidden" id="hid_PROJECT_CD">
					<input type="text" id="PROJECT_NAME" name="WARE_CATEG_NAME" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Project_Search" value="검 색" class="input_common_button" onclick="openSlipLogDeatilPopup();"/>
				</td>
			</tr>
			<tr>
				<th>거래처계층그룹</th>
				<td>
					<input type="hidden" id="hid_CUSTMR_CATEG_CD">
					<input type="text" id="CUSTMR_CATEG_NAME" name="WARE_CATEG_NAME" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Custmr_Categ_Search" value="검 색" class="input_common_button" onclick=""/>
				</td>
				<th>담당자</th>
				<td>
					<input type="hidden" id="hid_RESP_USER_CD">
					<input type="text" id="RESP_USER_NAME" name="WARE_CATEG_NAME" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Resp_User_Search" value="검 색" class="input_common_button" onclick=""/>
				</td>
			</tr>
			<tr>
				<th>상품그룹</th>
				<td>
					<input type="hidden" id="hidGOODS_CATEG_CD">
	               <input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" disabled="disabled"/>
	               <input type="button" id="GoodsGroup_Search" value="검 색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
				</td>
				<th>최종작업일자(수정일)</th>
				<td>
					<input type="text" id="searchDateFrom02" name="searchDateFrom02" class="input_common input_calendar">
					 ~ <input type="text" id="searchDateTo02" name="searchDateTo02" class="input_common input_calendar">
				</td>
			</tr>
			<tr>
				<th>상품</th>
				<td>
					<input type="hidden" id="hid_GOODS_CD">
					<input type="hidden" id="Goods_BCD">
					<input type="text" id="Goods_Name" name="WARE_CATEG_NAME" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Goods_Search" value="검 색" class="input_common_button" onclick="openSearchGoodsGridPopup();"/>
				</td>
				<th>금액</th>
				<td>
					<input type="text" id="AMT_FROM" name="AMT_FROM" class = "input_money"> ~ <input type="text" id="AMT_TO" name="AMT_TO" class = "input_money">
				</td>
			</tr>
			<tr>
				<th>간편검색</th>
				<td>
					<input type="button" id="thisDay" value="금일" class="input_common_button" onclick="SearchSelectDate(value);">
					<input type="button" id="preDay" value="전일" class="input_common_button" onclick="SearchSelectDate(value);">
					<input type="button" id="thisWeek" value="금주" class="input_common_button" onclick="SearchSelectDate(value);">
					<input type="button" id="preWeek" value="전주" class="input_common_button" onclick="SearchSelectDate(value);">
					<input type="button" id="thisMonth" value="금월" class="input_common_button" onclick="SearchSelectDate(value);">
					<input type="button" id="preMonth" value="전월" class="input_common_button" onclick="SearchSelectDate(value);">
					<input type="button" id="thisYear" value="금년" class="input_common_button" onclick="SearchSelectDate(value);">
					<input type="button" id="preYear" value="전년" class="input_common_button" onclick="SearchSelectDate(value);">
					<input type="button" id="EndDay" value="종료일" class="input_common_button" onclick="SearchSelectDate(value);">
				</td>
				<th>최종이력</th>
				<td>
					<div id="FINAL_LOG_TYPE"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none">
		<div id="div_erp_custmr_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_goods_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_else_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_bom_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>