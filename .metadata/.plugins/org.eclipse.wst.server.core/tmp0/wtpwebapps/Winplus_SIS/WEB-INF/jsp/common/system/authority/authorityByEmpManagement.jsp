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
		
		■ erpSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 메뉴별화면 조회 DhtmlXGrid
		■ erpGridColumns : Array / erpGrid DhtmlXGrid Header
		■ erpGridSelectedAuthor_cd : String / DhtmlXGrid 선택한 Row의 권한코드
		
		■ erpSubDetailLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpDetailRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpDetailGrid : Object / 메뉴별화면 조회 DhtmlXGrid
		■ erpDetailGridColumns : Array / erpDetailGrid DhtmlXGrid Header
		■ erpDetailGridDataProcessor : Object/ erpDetailGrid DhtmlXDataProcessor
		
		■ erpSubRightLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 메뉴별화면 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / erpRightGrid DhtmlXGrid Header
		
		■ cmbUSE_YN : Object / 사용여부 DhtmlXCombo (CODE : YN_CD)
		■ cmbORGN_DIV_CD : Object / 사용자구분코드 DhtmlXCombo (CODE : 00000) <- 코드 변경 필요
	--%>
	var erpLayout;
	var erpSubLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridSelectedAuthor_cd;
	
	var erpSubDetailLayout;
	var erpDetailGrid;
	var erpDetailGridColumns;
	var erpDetailGridDataProcessor;
	
	var cmbUSE_YN;
	var cmbORGN_DIV_CD;
	
	
	$(document).ready(function(){		
		initErpLayout();
		
		initErpSubLayout();
		initErpRibbon();
		initErpGrid();
		
		initErpSubDetailLayout();
		initErpDetailRibbon();
		initErpDetailGrid();
		
		initErpSubRightLayout();
		initErpRightRibbon();
		initErpRightGrid();
		
		initDhtmlXCombo();
		searchErpRightGrid();
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3J"
			, cells: [
				{id: "a", text: "권한목록", header:true, width:710}				
				, {id: "b", text: "전체사원(조직)목록", header:true}
				, {id: "c", text: "권한별사원목록", header:true}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_sub_layout");
		erpLayout.cells("b").attachObject("div_erp_sub_right_layout");
		erpLayout.cells("c").attachObject("div_erp_sub_detail_layout");
		
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpSubLayout.setSizes();
			erpSubDetailLayout.setSizes();
			erpSubRightLayout.setSizes();
			erpGrid.setSizes();
			erpDetailGrid.setSizes();			
			erpRightGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%--
	**************************************************
	* Master 영역
	**************************************************
	--%>
	
	<%-- ■ erpSubLayout 관련 Function 시작 --%>
	<%-- erpSubLayout 초기화 Function --%>
	function initErpSubLayout(){
		erpSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false}
				, {id: "b", text: "", header:false, fix_size : [false, true]}
				, {id: "c", text: "", header:false, fix_size : [false, true]}
			]	
			, fullScreen: true
		});
		erpSubLayout.cells("a").attachObject("div_erp_contents_search");
		erpSubLayout.cells("a").setHeight(38);
		erpSubLayout.cells("b").attachObject("div_erp_ribbon");
		erpSubLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpSubLayout.cells("c").attachObject("div_erp_grid");
		
		erpSubLayout.setSeparatorSize(1, 0);
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
						{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
						//, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, isHidden : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "excel_erpGrid"){
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "AUTHOR_CD", label:["권한코드", "#text_filter"], type: "ro", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "AUTHOR_NM", label:["권한명", "#text_filter"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "AUTHOR_DESC", label:["권한설명", "#text_filter"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BEGIN_DATE_TEXT", label:["시작일자", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "END_DATE_TEXT", label:["종료일자", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}			
			, {id : "USE_YN", label:["사용여부", "#select_filter"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}			
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
		erpGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpGrid);
		
		erpGrid.attachEvent("onRowSelect", function(rId, cInd){
			erpGridSelectedAuthor_cd = this.cells(rId, this.getColIndexById("AUTHOR_CD")).getValue();
			searchErpDetailGrid();
		});
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		var author_cd = document.getElementById("txtAUTHOR_CD").value;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isLengthOver(author_cd, 50)){
			isValidated = false;
			alertMessage = "error.common.system.authority.author_nm.length50Over";
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
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		if(!isSearchValidate()){
			return;
		}
		
		erpLayout.progressOn();
		
		var author_cd = document.getElementById("txtAUTHOR_CD").value;
		var use_yn = cmbUSE_YN.getSelectedValue();
		
		$.ajax({
			url : "/common/system/authority/authorityByEmpManagementR1.do"
			,data : {
				"AUTHOR_CD" : author_cd
				,"USE_YN" : use_yn
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					erpGridSelectedAuthor_cd = null;
					$erp.clearDhtmlXGrid(erpGrid);
					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%--
	**************************************************
	* Detail 영역
	**************************************************
	--%>
	
	<%-- ■ erpSubDetailLayout 관련 Function 시작 --%>
	<%-- erpSubDetailLayout 초기화 Function --%>
	function initErpSubDetailLayout(){
		erpSubDetailLayout = new dhtmlXLayoutObject({
			parent: "div_erp_sub_detail_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "", header:false, width:300}
				, {id: "b", text: "", header:false, fix_size : [false, true]}
			]
			, fullScreen: true
		});
		erpSubDetailLayout.cells("a").attachObject("div_erp_detail_ribbon");
		erpSubDetailLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpSubDetailLayout.cells("b").attachObject("div_erp_detail_grid");
		
		erpSubDetailLayout.setSeparatorSize(0, 0);
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>		
	
	<%-- ■ erpDetailRibbon 관련 Function 시작 --%>
	<%-- erpDetailRibbon 초기화 Function --%>
	function initErpDetailRibbon(){
		erpDetailRibbon = new dhtmlXRibbon({
			parent : "div_erp_detail_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "add_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					//, {id : "excel_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, isHidden : true}
					//, {id : "print_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}	
				]}							
			]
		});
		
		erpDetailRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpDetailGrid"){
		    	
		    } else if (itemId == "add_erpDetailGrid"){
		    	addErpDetailGrid();
		    } else if (itemId == "delete_erpDetailGrid"){
		    	deleteErpDetailGrid();
		    } else if (itemId == "save_erpDetailGrid"){
		    	saveErpDetailGrid();
		    } else if (itemId == "excel_erpDetailGrid"){
		    	
		    } else if (itemId == "print_erpDetailGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpDetailRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpDetailGrid 관련 Function 시작 --%>	
	<%-- erpDetailGrid 초기화 Function --%>	
	function initErpDetailGrid(){
		erpDetailGridColumns = [			
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "USER_CD", label:["사용자코드"], type: "ro", width: "80", align : "center", isHidden : false, isEssential : false}
			, {id : "USER_NM", label:["사용자명"], type: "ro", width: "150", align : "left", isHidden : false, isEssential : false}			
			, {id : "USER_DIV_CD", label:["사용자구분"], type: "ro", width: "70", align : "center", isHidden : false, isEssential : false}
			, {id : "USER_DIV_CD_NM", label:["사용자구분"], type: "ro", width: "70", align : "center", isHidden : false, isEssential : false}
			, {id : "USE_YN", label:["사용여부"], type: "combo", width: "60", align : "center", isHidden : false, isEssential : true, commonCode : ["YN_CD","YN"]}
			, {id : "BEGIN_DATE", label:["시작일자"], type: "dhxCalendarA", width: "80", align : "center", isHidden : false, isEssential : true}
			, {id : "END_DATE", label:["종료일자"], type: "dhxCalendarA", width: "80", align : "center", isHidden : false, isEssential : true}
			, {id : "AUTHOR_CD", label:["권한코드"], type: "ro", width: "60", align : "center", isHidden : true, isEssential : false}
		];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpDetailGridColumns			
		});		
		erpDetailGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpDetailGrid);
		$erp.initGridComboCell(erpDetailGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpDetailGrid, '<spring:message code="grid.allRowCount" />');
		
		erpDetailGridDataProcessor = new dataProcessor();
		erpDetailGridDataProcessor.init(erpDetailGrid);
		erpDetailGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpDetailGrid);
	}
	
	<%-- erpDetailGrid 조회 유효성 검사 Function --%>
	function isSearchDetailValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(erpGridSelectedAuthor_cd)){
			isValidated = false;
			alertMessage = "error.common.noSelectedData";
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
	
	<%-- erpDetailGrid 조회 Function --%>
	function searchErpDetailGrid(){
		if(!isSearchDetailValidate()){
			return;
		}
		erpLayout.progressOn();
		
		$.ajax({
			url : "/common/system/authority/authorityByEmpManagementR2.do"
			,data : {
				"AUTHOR_CD" : erpGridSelectedAuthor_cd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpDetailGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpDetailGrid.parse(gridDataList, 'js');
					}
					$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
				}
				$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpDetailGrid 추가 유효성 검사 Function --%>
	function isAddDetailValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		
		var erpRightGridRowCount = erpRightGrid.getRowsNum();
		
		if(erpRightGridRowCount == 0){
			isValidated = false;
			alertMessage = "선택된 행이 없습니다.";
		}else{
			for(var i = 0; i < erpRightGridRowCount; i++){
				var rightRId = erpRightGrid.getRowId(i);
				var check = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("CHECK")).getValue();
				var userNm = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("USER_NM")).getValue();
				var authNm = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("AUTH_NM")).getValue();
				if(check == 1 && authNm != ""){
					isValidated = false;
					alertMessage = "["+userNm + "] 사용자에 ["+authNm+"] 권한이 이미 지정되었습니다. 권한삭제 후 다시 시도해주세요";
					break;
				}
			}
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertType" : "alert"
				, "isAjax"	: false
			});
		}
		
		return isValidated;
	}
	
	<%-- erpDetailGrid 추가 Function --%>
	function addErpDetailGrid(){
		if(!isSearchDetailValidate()){ return false; }
		if(!isAddDetailValidate()){ return false; }
		
		var erpRightGridRowCount = erpRightGrid.getRowsNum();
		for(var i = 0; i < erpRightGridRowCount; i++){
			var rightRId = erpRightGrid.getRowId(i);
			var check = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("CHECK")).getValue();
			if(check == 1){
				var user_cd = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("USER_CD")).getValue();
				var erpDetailGridRowCount = erpDetailGrid.getRowsNum();
				var isAble = true;
				for(var j = 0; j < erpDetailGridRowCount ; j++){
					var detailRid = erpDetailGrid.getRowId(j);
					var authorityByUser_cd = erpDetailGrid.cells(detailRid, erpDetailGrid.getColIndexById("USER_CD")).getValue();
					if(user_cd == authorityByUser_cd){
						isAble = false;
						break;
					}
				}
				if(isAble === true){
					var uid = erpDetailGrid.uid();
					erpDetailGrid.addRow(uid);
					
					var user_nm = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("USER_NM")).getValue();
					var orgn_div_cd = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("USER_DIV_CD")).getValue();
					var orgn_div_cd_nm = erpRightGrid.cells(rightRId, erpRightGrid.getColIndexById("USER_DIV_CD_NM")).getValue();		
					var use_yn = "Y";
					var begin_date = $erp.getToday("");
					var end_date = "29991231";
					var author_scope_cd = "";
					
					erpDetailGrid.cells(uid, erpDetailGrid.getColIndexById("USER_CD")).setValue(user_cd);
					erpDetailGrid.cells(uid, erpDetailGrid.getColIndexById("USER_NM")).setValue(user_nm);
					erpDetailGrid.cells(uid, erpDetailGrid.getColIndexById("USER_DIV_CD")).setValue(orgn_div_cd);
					erpDetailGrid.cells(uid, erpDetailGrid.getColIndexById("USER_DIV_CD_NM")).setValue(orgn_div_cd_nm);
					erpDetailGrid.cells(uid, erpDetailGrid.getColIndexById("USE_YN")).setValue(use_yn);
					erpDetailGrid.cells(uid, erpDetailGrid.getColIndexById("BEGIN_DATE")).setValue(begin_date);
					erpDetailGrid.cells(uid, erpDetailGrid.getColIndexById("END_DATE")).setValue(end_date);
					erpDetailGrid.cells(uid, erpDetailGrid.getColIndexById("AUTHOR_CD")).setValue(erpGridSelectedAuthor_cd);
				}
			}
		}
		$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
	}
	
	<%-- erpDetailGrid 삭제 Function --%>
	function deleteErpDetailGrid(){
		var gridRowCount = erpDetailGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpDetailGrid.getRowId(i);
			var check = erpDetailGrid.cells(rId, erpDetailGrid.getColIndexById("CHECK")).getValue();
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
			erpDetailGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
	}
	
	<%-- erpDetailGrid 저장 Function --%>
	function saveErpDetailGrid(){
		if(erpDetailGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpDetailGrid);
		if(validResultMap.isError){
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		<%-- 정상적으로 조회 된 것인지 확인 --%>
		if(!isSearchDetailValidate()){ return false; }
		
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpDetailGrid);		
		$.ajax({
			url : "/common/system/authority/authorityByEmpManagementCUD1.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.alertSuccessMesage(onAfterSaveErpDetailGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpDetailGrid 저장 후 Function --%>
	function onAfterSaveErpDetailGrid(){
		searchErpDetailGrid();
	}
	<%-- ■ erpDetailGrid 관련 Function 끝 --%>
	
	<%--
	**************************************************
	* Right 영역
	**************************************************
	--%>
	
	<%-- ■ erpSubRightLayout 관련 Function 시작 --%>
	<%-- erpSubRightLayout 초기화 Function --%>
	function initErpSubRightLayout(){
		erpSubRightLayout = new dhtmlXLayoutObject({
			parent: "div_erp_sub_right_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, width:300}
				, {id: "b", text: "", header:false, fix_size : [false, true]}
				, {id: "c", text: "", header:false, fix_size : [false, true]}
			]
			, fullScreen: true
		});
		
		erpSubRightLayout.cells("a").attachObject("div_erp_right_contents_search");
		erpSubRightLayout.cells("a").setHeight(38);
		erpSubRightLayout.cells("b").attachObject("div_erp_right_ribbon");
		erpSubRightLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpSubRightLayout.cells("c").attachObject("div_erp_right_grid");
		
		erpSubRightLayout.setSeparatorSize(1, 0);
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>		
	
	<%-- ■ erpRightRibbon 관련 Function 시작 --%>
	<%-- erpRightRibbon 초기화 Function --%>
	function initErpRightRibbon(){
		erpRightRibbon = new dhtmlXRibbon({
			parent : "div_erp_right_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpRightGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					//, {id : "add_erpRightGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true, isHidden : true}
					//, {id : "delete_erpRightGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true, isHidden : true}
					//, {id : "save_erpRightGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true, isHidden : true}
					//, {id : "excel_erpRightGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, isHidden : true}
					//, {id : "print_erpRightGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}	
				]}							
			]
		});
		
		erpRightRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpRightGrid"){
		    	searchErpRightGrid();
		    } else if (itemId == "add_erpRightGrid"){
		    	
		    } else if (itemId == "delete_erpRightGrid"){
		    	
		    } else if (itemId == "save_erpRightGrid"){
		    	
		    } else if (itemId == "excel_erpRightGrid"){
		    	
		    } else if (itemId == "print_erpRightGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpRightRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpRightGrid 관련 Function 시작 --%>	
	<%-- erpRightGrid 초기화 Function --%>	
	function initErpRightGrid(){
		erpRightGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "30", align : "center", isHidden : false, isEssential : false}
			, {id : "USER_CD", label:["인사정보", "사원번호<br/>(조직코드)"], type: "ro", width: "80", align : "center", isHidden : false, isEssential : false}
			, {id : "USER_NM", label:["#cspan", "사원명<br/>(조직명)"], type: "ro", width: "150", align : "left", isHidden : false, isEssential : false}			
			, {id : "USER_DIV_CD", label:["#cspan", "사용자구분"], type: "ro", width: "70", align : "center", isHidden : false, isEssential : false}
			, {id : "USER_DIV_CD_NM", label:["#cspan", "사용자구분"], type: "ro", width: "70", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_CD", label:["#cspan","조직코드"], type: "ro", width: "80", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_NM", label:["#cspan","조직명"], type: "ro", width: "250", align : "left", isHidden : false, isEssential : false}
			, {id : "ORGN_NM_FULL", label:["#cspan","조직명(전체)"], type: "ro", width: "250", align : "left", isHidden : false, isEssential : false}	
			, {id : "AUTH_NM", label:["#cspan","권한명"], type: "ro", width: "120", align : "left", isHidden : false, isEssential : false}	
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
		$erp.attachDhtmlXGridFooterPaging(erpRightGrid, 200);
		$erp.attachDhtmlXGridFooterRowCount(erpRightGrid, '<spring:message code="grid.allRowCount" />');
	}
	
	<%-- erpRightGrid 조회 유효성 검사 Function --%>
	function isSearchRightValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var user_cd = document.getElementById("txtUSER_CD").value;
		var orgn_div_cd = "";
		
		if(!$erp.isEmpty(user_cd) && user_cd.length > 50){
			isValidated = false;
			alertMessage = "error.common.system.authority.user_nm.length50Over";
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
	
	<%-- erpRightGrid 조회 Function --%>
	function searchErpRightGrid(){
		if(!isSearchRightValidate()){
			return;
		}		
		erpLayout.progressOn();
		
		var user_cd = document.getElementById("txtUSER_CD").value;
		var orgn_div_cd = cmbORGN_DIV_CD.getSelectedValue();
		
		$.ajax({
			url : "/common/system/authority/authorityByEmpManagementR3.do"
			,data : {
				"USER_CD" : user_cd
				, "USER_DIV_CD" : orgn_div_cd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
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
					}
					$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
				}
				$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpRightGrid 관련 Function 끝 --%>
	
	
	<%--
	**************************************************
	* 기타 영역
	**************************************************
	--%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbUSE_YN = $erp.getDhtmlXCombo('cmbUSE_YN', 'USE_YN', ['YN_CD','YN'], 120, true);
		cmbORGN_DIV_CD = $erp.getDhtmlXCombo('cmbORGN_DIV_CD', 'ORGN_DIV_CD', 'ORGN_DIV_CD', 100, false);
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	
</script>
</head>
<body>
	<div id="div_erp_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
	
	<div id="div_erp_sub_detail_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_detail_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_detail_grid" class="div_grid_full_size" style="display:none"></div>
	
	<div id="div_erp_sub_right_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_right_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_right_grid" class="div_grid_full_size" style="display:none"></div>
	
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="150px">
				<col width="150px">
				<col width="150px">
				<col width="*">				
			</colgroup>
			<tr>
				<th>권한코드/권한명</th>
				<td><input type="text" id="txtAUTHOR_CD" name="AUTHOR_CD" class="input_common" maxlength="505" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid);"></td>
				<th>사용여부</th>
				<td><div id="cmbUSE_YN"></div></td>
			</tr>
		</table>
	</div>
	
	<div id="div_erp_right_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="150px">
				<col width="150px">
				<col width="150px">
				<col width="*">				
			</colgroup>
			<tr>
				<th>사원번호(조직코드)/사원명(조직명)</th>
				<td><input type="text" id="txtUSER_CD" name="USER_CD" class="input_common" maxlength="505" onkeydown="$erp.onEnterKeyDown(event, searchErpRightGrid);"></td>
				<th>사용자구분</th>
				<td><div id="cmbORGN_DIV_CD"></div></td>
			</tr>
		</table>
	</div>
</body>
</html>