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
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		
		■ erpLeftSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpLeftRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpLeftTree : Object / 상품분류 트리 DhtmlXTree
		
		■ erpRightSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 화면 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / erpRightGrid DhtmlXGrid Header
		■ erpRightGridDataProcessor : Object/ erpRightGridDataProcessor DhtmlXDataProcessor
		
		■ currentErpLeftTreeId : String / 조회 시 사용변수
	--%>
	var erpLayout;
	
	var erpLeftSubLayout;
	var erpLeftRibbon;
	var erpLeftTree;
	
	var erpRightSubLayout;
	var erpRightRibbon;
	var erpRightGrid;
	var erpRightGridColumns;
	var erpRightGridDataProcessor;
	
	var currentErpLeftTreeId;
	
	$(document).ready(function(){
		initErpLayout();
		
		initErpLeftSubLayout();
		initErpLeftRibbon();
		initErpLeftTree();
		
		initErpRightSubLayout();
		initErpRightRibbon();
		initErpRightGrid();
		
		searchErpLeftTree();
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2U"
			, cells: [
				{id: "a", text: "트리레이아웃영역", header:false, width:350, fix_size : [true, true]}
				, {id: "b", text: "그리드레이아웃영역", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_left_sub_layout");
		erpLayout.cells("b").attachObject("div_erp_right_sub_layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpLeftSubLayout.setSizes();
			erpRightSubLayout.setSizes();
			erpRightGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%--
	**********************************************************************
	* ※ Left 영역
	**********************************************************************
	--%>
	<%-- ■ erpLeftSubLayout 관련 Function 시작 --%>
	<%-- erpLeftSubLayout 초기화 Function --%>
	function initErpLeftSubLayout(){
		erpLeftSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_left_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "검색어영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "트리영역", header:false, fix_size : [true, true]}
			]
		});
		erpLeftSubLayout.cells("a").attachObject("div_erp_left_contents_search");
		erpLeftSubLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftSubLayout.cells("b").attachObject("div_erp_left_ribbon");
		erpLeftSubLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftSubLayout.cells("c").attachObject("div_erp_left_tree");
	}	
	<%-- ■ erpLeftSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpLeftRibbon 관련 Function 시작 --%>
	<%-- erpLeftRibbon 초기화 Function --%>
	function initErpLeftRibbon(){
		erpLeftRibbon = new dhtmlXRibbon({
			parent : "div_erp_left_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					 {id : "search_erpLeftTree", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					//  {id : "add_erpLeftTree", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					//, {id : "delete_erpLeftTree", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					//, {id : "save_erpLeftTree", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					//, {id : "excel_erpLeftTree", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					//, {id : "print_erpLeftTree", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}	
				]}							
			]
		});
		
		erpLeftRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpLeftTree"){
				searchErpLeftTree();
		    } else if (itemId == "add_erpLeftTree"){
		    } else if (itemId == "delete_erpLeftTree"){
		    } else if (itemId == "save_erpLeftTree"){
		    } else if (itemId == "excel_erpLeftTree"){
		    } else if (itemId == "print_erpLeftTree"){
		    }
		});
	}
	<%-- ■ erpLeftRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpLeftTree 관련 Function 시작 --%>
	<%-- erpLeftTree 초기화 Function --%>
	function initErpLeftTree(){
		erpLeftTree = new dhtmlXTreeObject({
			parent : "div_erp_left_tree"
			, skin : ERP_TREE_CURRENT_SKINS			
			, image_path : ERP_TREE_CURRENT_IMAGE_PATH
		});
		
		erpLeftTree.attachEvent("onClick", function(id){
			if(!$erp.isEmpty(id)){
				<%-- 자식이 없는 경우(소분류)만 동작함 --%>
				if(!erpLeftTree.hasChildren(id)){
					currentErpLeftTreeId = id;
					searchErpRightContents();
				}
			}
		});
		
		searchErpLeftTree();
	}
	
	<%-- erpLeftTree 조회 Function --%>
	function searchErpLeftTree(){
		erpLeftSubLayout.progressOn();
		
		$.ajax({
			url : "/common/popup/getGoodsCategoryTreeList.do"
			,data : {
				"KEY_WORD" : $("#txtKEY_WORD").val()
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLeftSubLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					var categoryList = data.categoryList;
					var categoryTreeMap = data.categoryTreeMap;
					var categoryTreeDataList = categoryTreeMap.item;
					if($erp.isEmpty(categoryTreeDataList) || $erp.isEmpty(categoryList)){
						$erp.alertMessage({
							"alertMessage" : "info.common.noDataSearch"
							, "alertCode" : null
							, "alertType" : "info"
						});
					} else {
						erpLeftTree.deleteChildItems(0);
						erpLeftTree.parse(categoryTreeMap, 'json');
						//미사용 분류 투명도 설정
						for(var i=0; i<categoryList.length; i++){
							if(categoryList[i].GRUP_STATE == "N"){
								erpLeftTree.setItemStyle(categoryList[i].GRUP_CD,"opacity:0.3;");
							}
						}
						currentErpLeftTreeId = null;
						erpLeftTree.openAllItems("0");
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpRightContents 조회 유효성 검증 Function --%>
	function isSearchErpRightContentsValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(currentErpLeftTreeId)){
			isValidated = false;
			alertMessage = "error.common.noSelectedCategory";
			alertCode = "-1";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
	
	<%-- erpLeftTree 항목 클릭 시 조회 Function --%>
	function searchErpRightContents(){
		if(!isSearchErpRightContentsValidate()) { return false; }
		
		erpRightSubLayout.progressOn();
		
		$.ajax({
			url : "/sis/standardInfo/goods/getGoodsCategory.do"
			,data : {
				"GRUP_CD" : currentErpLeftTreeId
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightSubLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					var dataMap = data.dataMap;
					if($erp.isEmpty(dataMap)){
						$erp.alertMessage({
							"alertMessage" : "grid.noSearchData"
							, "alertCode" : ""
							, "alertType" : "info"
						});
					} else {
						var tbErpRightData = document.getElementById("tb_erp_right_data");
						$erp.clearInputInElement(tbErpRightData);
						$erp.bindTextValue(dataMap, tbErpRightData);
						
						document.getElementById("hidGRUP_TOP_CD").value = "";
						document.getElementById("hidGRUP_MID_CD").value = "";
						document.getElementById("hidGRUP_BOT_CD").value = "";
						document.getElementById("hidGRUP_TOP_CD").value = dataMap.GRUP_TOP_CD;
						document.getElementById("hidGRUP_MID_CD").value = dataMap.GRUP_MID_CD;
						document.getElementById("hidGRUP_BOT_CD").value = dataMap.GRUP_BOT_CD;
						
						searchErpRightGrid();
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpLeftTree 관련 Function 끝 --%>
	
	<%--
	**********************************************************************
	* ※ Right 영역
	**********************************************************************
	--%>
	<%-- ■ erpRightSubLayout 관련 Function 시작 --%>
	<%-- erpRightSubLayout 초기화 Function --%>
	function initErpRightSubLayout(){
		erpRightSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_right_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "대중소분류영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "그리드영역", header:false, fix_size : [true, true]}
			]
		});
		erpRightSubLayout.cells("a").attachObject("div_erp_right_contents_search");
		erpRightSubLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightSubLayout.cells("b").attachObject("div_erp_right_ribbon");
		erpRightSubLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightSubLayout.cells("c").attachObject("div_erp_right_grid");
	}	
	<%-- ■ erpRightSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRightRibbon 관련 Function 시작 --%>
	<%-- erpRightRibbon 초기화 Function --%>
	function initErpRightRibbon(){
		erpRightRibbon = new dhtmlXRibbon({
			parent : "div_erp_right_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					 {id : "search_erpRightGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "add_erpRightGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_erpRightGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erpRightGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					, {id : "excel_erpRightGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					//, {id : "print_erpRightGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}	
				]}							
			]
		});
		
		erpRightRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpRightGrid"){
		    	searchErpRightGrid();
		    } else if (itemId == "add_erpRightGrid"){
		    	openSearchGoodsGridPopup();
		    } else if (itemId == "delete_erpRightGrid"){
		    	deleteErpRightGrid();
		    } else if (itemId == "save_erpRightGrid"){
		    	saveErpRightGrid();
		    } else if (itemId == "excel_erpRightGrid"){
		    	var grup_top_nm = document.getElementById("txtGRUP_TOP_NM").value;
		    	var grup_mid_nm = document.getElementById("txtGRUP_MID_NM").value;
		    	var grup_bot_nm = document.getElementById("txtGRUP_BOT_NM").value;
		    	
		    	$erp.exportGridToExcel({
		    		"grid" : erpRightGrid
					, "fileName" : grup_top_nm+"_"+grup_mid_nm+"_"+grup_bot_nm+"_"+"상품목록"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
		    } else if (itemId == "print_erpRightGrid"){
		    }
		});
	}
	<%-- ■ erpRightRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpRightGrid 관련 Function 시작 --%>	
	<%-- erpRightGrid 초기화 Function --%>	
	function initErpRightGrid(){
		erpRightGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "450", sort : "str", align : "left", isHidden : true, isEssential : true}
			, {id : "GOODS_NM", label:["상품명", "#text_filter"], type: "ro", width: "450", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "GOODS_STATE", label:["상품상태", "#rspan"], type: "combo", width: "75", sort : "str", align : "left", isHidden : false, isEssential : false, commonCode : ["USE_CD", "YN"]}
			, {id : "GOODS_PUR_CD", label:["상품유형", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["PUR_TYPE", null, null, "INFO"]}
			, {id : "GOODS_SALE_TYPE", label:["판매유형", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : "GOODS_MNG_TYPE"}
			, {id : "ITEM_TYPE", label:["품목구분", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : "ITEM_TYPE"}
			//, {id : "POINT_SAVE_RATE", label:["포인트적립율", "#rspan"], type: "ro", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false}
			//, {id : "TAX_TYPE", label:["과세구분", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : "GOODS_TAX_YN"}
			, {id : "MAT_TEMPER_INFO", label:["품온정보", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : "MAT_TEMPER_INFO"}
			, {id : "GOODS_SET_TYPE", label:["세트여부", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["USE_CD", "BIT"]}
			//, {id : "MIN_PUR_UNIT", label:["최소구매단위", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			//, {id : "MIN_PUR_QTY", label:["최소단위수량", "#rspan"], type: "ro", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false}
			//, {id : "MIN_ORD_QTY", label:["수주제한수량", "#rspan"], type: "ro", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "GOODS_DESC", label:["상품설명", "#rspan"], type: "ro", width: "280", sort : "str", align : "left", isHidden : false, isEssential : false}
			//, {id : "GOODS_KEYWD", label:["키워드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			//, {id : "RESP_USER", label:["담당자", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			//, {id : "GOODS_LOAD_CD", label:["적재위치", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			//, {id : "GOODS_EXP_DATE", label:["유통기한", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_TC_TYPE", label:["TC상품여부", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["USE_CD", "YN"]}
			//, {id : "GOODS_STOCK_TYPE", label:["재고관리유형", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["USE_CD", "BIT"]}
			//, {id : "POLI_TYPE", label:["가격정책여부", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["USE_CD", "BIT"]}
			//, {id : "BRADN_TYPE", label:["브랜드여부", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["USE_CD", "BIT"]}
			/* , {id : "", label:["바코드", "#text_filter"], type: "ro", width: "220", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["공급사", "#text_filter"], type: "ro", width: "220", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["매입가", "#rspan"], type: "ron", width: "220", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "", label:["판매가", "#rspan"], type: "ron", width: "220", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "", label:["이익율", "#rspan"], type: "ron", width: "220", sort : "int", align : "right", isHidden : false, isEssential : false} */
		];
		
		erpRightGrid = new dhtmlXGridObject({
			parent: "div_erp_right_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpRightGridColumns
		});
		erpRightGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpRightGrid);
		$erp.initGridComboCell(erpRightGrid);
		$erp.attachDhtmlXGridFooterPaging(erpRightGrid, 100);
		$erp.attachDhtmlXGridFooterRowCount(erpRightGrid, '<spring:message code="grid.allRowCount" />');
		
		erpRightGridDataProcessor = new dataProcessor();
		erpRightGridDataProcessor.init(erpRightGrid);
		erpRightGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpRightGrid);
	}
	
	<%-- erpRightGrid 조회 유효성 검사 Function --%>
	function isSearchErpRightGridValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var grup_top_cd = document.getElementById("hidGRUP_TOP_CD").value;
		var grup_mid_cd = document.getElementById("hidGRUP_MID_CD").value;
		var grup_bot_cd = document.getElementById("hidGRUP_BOT_CD").value;
		
		if($erp.isEmpty(grup_top_cd) || grup_top_cd == ""){
			isValidated = false;
			alertMessage = "error.common.noSelectedCategory";
			alertCode = "-1";
		}
		if($erp.isEmpty(grup_mid_cd) || grup_mid_cd == ""){
			isValidated = false;
			alertMessage = "error.common.noSelectedCategory";
			alertCode = "-2";
		}
		if($erp.isEmpty(grup_bot_cd) || grup_bot_cd == ""){
			isValidated = false;
			alertMessage = "error.common.noSelectedCategory";
			alertCode = "-3";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
	
	<%-- erpRightGrid 조회 Function --%>
	function searchErpRightGrid(){
		if(!isSearchErpRightGridValidate()){
			return;
		}
		
		erpRightSubLayout.progressOn();
		
		var grup_top_cd = document.getElementById("hidGRUP_TOP_CD").value;
		var grup_mid_cd = document.getElementById("hidGRUP_MID_CD").value;
		var grup_bot_cd = document.getElementById("hidGRUP_BOT_CD").value;
		
		$.ajax({
			url : "/sis/standardInfo/goods/getGoodsCategoryByGoodsList.do"
			,data : {
				"GRUP_TOP_CD" : grup_top_cd
				, "GRUP_MID_CD" : grup_mid_cd
				, "GRUP_BOT_CD" : grup_bot_cd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightSubLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpRightGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpRightGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpRightGrid.parse(gridDataList, 'js');
						
						var allRowIds = erpRightGrid.getAllRowIds();
						var allRowArray = allRowIds.split(",");
						for(var i=0; i<allRowArray.length; i++){
							if(erpRightGrid.cells(allRowArray[i],erpRightGrid.getColIndexById("GOODS_STATE")).getValue() == "N"){
								erpRightGrid.setRowTextStyle(allRowArray[i],"opacity:0.3;");
							}
						}
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpRightGrid 관련 Function 끝 --%>
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(){
		if(!isSearchErpRightGridValidate()){
			return;
		}
		
		var onClickAddData = function(erpPopupGrid) {
			var isValidated = true;
			var alertMessage = "";
			var alertCode = "";
			var alertType = "error";
			
			var checkIds = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK"));
			
			if($erp.isEmpty(checkIds) || checkIds == ""){
				isValidated = false;
				alertMessage = "error.sis.goods.search.goods_nm.empty";
				alertCode = "-1";
			}
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					, "alertCode" : alertCode
					, "alertType" : alertType
				});
			}else{
				var checkIdArray = checkIds.split(",");
				
				for(var i=0; i<checkIdArray.length; i++){
					
					$.ajax({
						url : "/sis/standardInfo/goods/getGoodsInformation.do"
						,data : {
							"GOODS_NO" : erpPopupGrid.cells(checkIdArray[i], erpPopupGrid.getColIndexById("GOODS_NO")).getValue()
						}
						,method : "POST"
						,dataType : "JSON"
						,success : function(data){
							if(data.isError){
								$erp.ajaxErrorMessage(data);
							} else {
								var dataMap = data.dataMap;
								if($erp.isEmpty(dataMap)){
									$erp.alertMessage({
										"alertMessage" : "grid.noSearchData"
										, "alertCode" : ""
										, "alertType" : "info"
									});
								} else {
									var searchResult = erpRightGrid.findCell(dataMap.GOODS_NO,erpRightGrid.getColIndexById("GOODS_NO"),false,true);
									if(searchResult == ""){
										var uid = erpRightGrid.uid();
										erpRightGrid.addRow(uid);
										
										erpRightGrid.cells(uid, erpRightGrid.getColIndexById("CHECK")).setValue("1");
										erpRightGrid.cells(uid, erpRightGrid.getColIndexById("GOODS_NO")).setValue(dataMap.GOODS_NO);
										erpRightGrid.cells(uid, erpRightGrid.getColIndexById("GOODS_NM")).setValue(dataMap.GOODS_NM);
										
										$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
									}
								}
							}
						}, error : function(jqXHR, textStatus, errorThrown){
							$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
						}
					});
				}
				
				$erp.closePopup();
			}
		}
		
		$erp.openSearchGoodsPopup(null,onClickAddData, {"SHOW_TYPE" : true});
	}
	
	<%-- erpRightGrid 삭제 Function --%>
	function deleteErpRightGrid(){
		var gridRowCount = erpRightGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpRightGrid.getRowId(i);
			var check = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(rId);
			}
		}
		
		if(deleteRowIdArray.length == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}
		
		for(var i = 0; i < deleteRowIdArray.length; i++){
			erpRightGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
	}
	
	<%-- erpRightGrid 저장 Function --%>
	function saveErpRightGrid(){
		if(erpRightGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpRightGrid);
		if(validResultMap.isError){
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		erpRightSubLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpRightGrid);
		
		var grup_top_cd = document.getElementById("hidGRUP_TOP_CD").value;
		var grup_mid_cd = document.getElementById("hidGRUP_MID_CD").value;
		var grup_bot_cd = document.getElementById("hidGRUP_BOT_CD").value;
		paramData["GRUP_TOP_CD"] = grup_top_cd;
		paramData["GRUP_MID_CD"] = grup_mid_cd;
		paramData["GRUP_BOT_CD"] = grup_bot_cd;
		
		$.ajax({
			url : "/sis/standardInfo/goods/updateCategoryByGoods.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightSubLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.alertSuccessMesage(onAfterSaveErpRightGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpRightSubLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpRightGrid 저장 후 Function --%>
	function onAfterSaveErpRightGrid(){
		searchErpRightGrid();
	}
</script>
</head>
<body>
	<div id="div_erp_left_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_left_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="85px">
				<col width="*">
			</colgroup>
			<tr>
				<th>검색어</th>
				<td>
					<input type="text" id="txtKEY_WORD" name="KEY_WORD" class="input_common" maxlength="10" onkeydown="$erp.onEnterKeyDown(event, searchErpLeftTree);">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_left_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_left_tree" class="div_tree_full_size" style="display:none"></div>
	
	<div id="div_erp_right_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_right_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_right_data" class="table_search">
			<colgroup>
				<col width="70px">
				<col width="150px">
				<col width="70px">
				<col width="150px">
				<col width="70px">
				<col width="*">
			</colgroup>
			<tr>
				<th>대분류</th>
				<td>
					<input type="hidden" id="hidGRUP_TOP_CD">
					<input type="text" id="txtGRUP_TOP_NM" name="GRUP_TOP_NM" class="input_common input_readonly" maxlength="20" readonly="readonly">
				</td>
				<th>중분류</th>
				<td>
					<input type="hidden" id="hidGRUP_MID_CD">
					<input type="text" id="txtGRUP_MID_NM" name="GRUP_MID_NM" class="input_common input_readonly" maxlength="20" readonly="readonly">
				</td>
				<th>소분류</th>
				<td>
					<input type="hidden" id="hidGRUP_BOT_CD">
					<input type="text" id="txtGRUP_BOT_NM" name="GRUP_BOT_NM" class="input_common input_readonly" maxlength="20" readonly="readonly">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_right_ribbon" class="div_ribbon_full_size" style="display:none"></div>	
	<div id="div_erp_right_grid" class="div_grid_full_size" style="display:none"></div>	
</body>
</html>