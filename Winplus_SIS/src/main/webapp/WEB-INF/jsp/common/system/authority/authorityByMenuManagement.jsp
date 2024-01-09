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
		■ cmbUSE_YN : Object / 사용여부 DhtmlXCombo (CODE : YN_CD)
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
	
	
	$(document).ready(function(){		
		initErpLayout();
		initErpSubLayout();
		initErpRibbon();
		initErpGrid();
		initErpSubDetailLayout();
		initErpDetailRibbon();
		initErpDetailGrid();
		initDhtmlXCombo();
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2U"
			, cells: [
				{id: "a", text: "권한목록", header:true, width:660}
				, {id: "b", text: "권한별메뉴목록", header:true}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_sub_layout");
		erpLayout.cells("b").attachObject("div_erp_sub_detail_layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpSubLayout.setSizes();
			erpSubDetailLayout.setSizes();
			erpGrid.setSizes();
			erpDetailGrid.setSizes();
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
						//, {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true, isHidden : true}
						//, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true, isHidden : true}
						//, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true, isHidden : true}
						//, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, isHidden : true}
						//, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}		
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "add_erpGrid"){
		    	
		    } else if (itemId == "delete_erpGrid"){
		    	
		    } else if (itemId == "save_erpGrid"){
		    	
		    } else if (itemId == "excel_erpGrid"){
		    	
		    } else if (itemId == "print_erpGrid"){
		    	
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
			, {id : "BEGIN_DATE", label:["시작일자", "#text_filter"], type: "dhxCalendarA", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "END_DATE", label:["종료일자", "#text_filter"], type: "dhxCalendarA", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}			
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
			url : "/common/system/authority/authorityByMenuManagementR1.do"
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
					{id : "save_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}							
			]
		});
		
		erpDetailRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpDetailGrid"){
		    	
		    } else if (itemId == "add_erpDetailGrid"){
		    	
		    } else if (itemId == "delete_erpDetailGrid"){
		    	
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
			{id : "TREE", label:["메뉴", "메뉴명"], type: "tree", width: "250", align : "left", isHidden : false, isEssential : false}			
			, {id : "MENU_CD", label:["#cspan","메뉴코드"], type: "ro", width: "60", align : "center", isHidden : false, isEssential : false}
			, {id : "MENU_USE_YN", label:["#cspan","메뉴사용여부"], type: "ro", width: "70", align : "center", isHidden : false, isEssential : false}
			
			, {id : "USE_YN", label:["권한설정", "조회여부"], type: "ch", width: "70", align : "center", isHidden : false, isEssential : true}
			, {id : "STRE_YN", label:["#cspan", "저장여부"], type: "ch", width: "70", align : "center", isHidden : false, isEssential : true}
			, {id : "ADIT_YN", label:["#cspan", "등록여부"], type: "ch", width: "70", align : "center", isHidden : false, isEssential : true}
			, {id : "DELETE_YN", label:["#cspan", "삭제여부"], type: "ch", width: "70", align : "center", isHidden : false, isEssential : true}
			, {id : "EXCEL_YN", label:["#cspan", "엑셀여부"], type: "ch", width: "70", align : "center", isHidden : false, isEssential : true}
			, {id : "PRINT_YN", label:["#cspan", "출력여부"], type: "ch", width: "70", align : "center", isHidden : false, isEssential : true}
			
			, {id : "REG_PROGRM", label:["등록프로그램", "#rspan"], type: "ro", width: "130", align : "left", isHidden : false, isEssential : false}
			, {id : "REG_ID", label:["등록자", "#rspan"], type: "ro", width: "100", align : "center", isHidden : false, isEssential : false}
			, {id : "REG_DT", label:["등록일시", "#rspan"], type: "ro", width: "140", align : "left", isHidden : false, isEssential : false}
			, {id : "UPD_PROGRM", label:["수정프로그램", "#rspan"], type: "ro", width: "130", align : "left", isHidden : false, isEssential : false}
			, {id : "UPD_ID", label:["수정자", "#rspan"], type: "ro", width: "100", align : "center", isHidden : false, isEssential : false}
			, {id : "UPD_DT", label:["수정일시", "#rspan"], type: "ro", width: "140", align : "left", isHidden : false, isEssential : false}
			, {id : "AUTHOR_CD", label:["권한코드"], type: "ro", width: "60", align : "center", isHidden : true, isEssential : false}
		];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpDetailGridColumns			
		});		
		erpDetailGrid.enableDistributedParsing(true, 100, 50);
		erpDetailGrid.enableTreeCellEdit(false);
		$erp.initGridCustomCell(erpDetailGrid);
		$erp.initGridComboCell(erpDetailGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpDetailGrid, '<spring:message code="grid.allRowCount" />');
		
		erpDetailGridDataProcessor = new dataProcessor();
		erpDetailGridDataProcessor.init(erpDetailGrid);
		erpDetailGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpDetailGrid);
		
		erpDetailGrid.attachEvent("onEditCell", function(stage, rId, cInd, nValue, oValue){
			if (stage == 1){
				if(cInd == this.getColIndexById("USE_YN")
						|| cInd == this.getColIndexById("STRE_YN")
						|| cInd == this.getColIndexById("ADIT_YN")
						|| cInd == this.getColIndexById("DELETE_YN")
						|| cInd == this.getColIndexById("EXCEL_YN")
						|| cInd == this.getColIndexById("PRINT_YN")){		
					var nValue = this.cells(rId , cInd).getValue();
					var subRowIds = this.getAllSubItems(rId).split(",");					
					var erpDp = this.getDataProcessor(); 
					if(subRowIds != ""){
						for(var i = 0; i < subRowIds.length; i++){
							var subRowId = subRowIds[i];
							this.cells(subRowId, cInd).setValue(nValue);
							erpDp.setUpdated(subRowId, true, "updated");
						}
					}
				}
			} else {
				return true;
			}		
		});
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
			url : "/common/system/authority/authorityByMenuManagementR2.do"
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
						erpDetailGrid.expandAll();	
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
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
		
		if(!isSearchValidate()){ return false; }
		
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpDetailGrid);		
		$.ajax({
			url : "/common/system/authority/authorityByMenuManagementCUD1.do"
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
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbUSE_YN = $erp.getDhtmlXCombo('cmbUSE_YN', 'USE_YN', ['YN_CD','YN'], 120, true);
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
</body>
</html>