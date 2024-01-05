<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">
LUI = JSON.parse('${empSessionDto.lui}');
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmbORGN_CD;
	var searchCheck = false;
	var paramData = {};
	$(document).ready(function(){
		
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		
		initDhtmlXCombo();
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "검색조건", header:false, fix_size : [false, true]}
				, {id: "b", text: "리본영역", header:false, fix_size : [false, true]}
				, {id: "c", text: "그리드영역", header:false, fix_size : [false, true]}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_search_table");
		erpLayout.cells("a").setHeight(38);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
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
// 					 , {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					 , {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					 , {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					 , {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchErpGrid();
			} else if (itemId == "save_erpGrid"){
				saveErpGrid();
			} else if (itemId == "add_erpGrid"){
				
				var isValidated = true;
				var alertMessage = "";
				var alertType = "error";
				if(!searchCheck){
					isValidated = false;
					alertMessage = "조회 이후에 가능한 기능입니다.";
				}
				if(!isValidated){
					$erp.alertMessage({
						"alertMessage" : alertMessage
						, "alertType" : alertType
						, "isAjax" : false
					});
				} else {
					paramData["CRUD"] = "C";
					openDetailpopup(paramData);
				}
			} else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
			} else if(itemId == "excel_erpGrid") {
				$erp.exportDhtmlXGridExcel({
				     "grid" : erpGrid
				   , "fileName" : "밴사_정보_관리"
				   , "isForm" : false
				   , "excludeColumn" : ["NO","CHECK","VAN_SEQ"]
				   , "emptyDown" : false
				});
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["순번", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "VAN_CD", label : ["밴사 코드", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "VAN_NM", label : ["밴사 이름", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "VAN_IP", label:["아이피", "#rspan"], type: "ro", width: "250", sort : "str", align : "center", isHidden : false, isEssential : true, maxLength : 15}
			, {id : "VAN_PORT", label:["포트", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true, maxLength : 6}
			, {id : "USE_YN", label:["사용여부", "#rspan" ], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["USE_CD" , "YN"], isDisabled : true}
			, {id : "VAN_SEQ", label : ["시퀀스", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		
		erpGrid.attachEvent("onKeyPress",onKeyPressed);
		erpGrid.enableBlockSelection();
		erpGrid.enableDistributedParsing(true, 100, 50);
		erpGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		//onRowSelect
		erpGrid.attachEvent("onRowDblClicked", function(rId){
			paramData["VAN_SEQ"] = erpGrid.cells(rId, erpGrid.getColIndexById("VAN_SEQ")).getValue();
			paramData["VAN_CD"] = erpGrid.cells(rId, erpGrid.getColIndexById("VAN_CD")).getValue();
			paramData["CRUD"] = "R"
			
			openDetailpopup(paramData);
		});
	}
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		var dataObj = $erp.dataSerialize("tb_search");//cmb txt chk 이런거 자르고 보냄  
		var paramData = $erp.unionObjArray([LUI,dataObj]);
		erpLayout.progressOn();
		$.ajax({
				url: "/common/pos/VanInfoManagement/getVanInfoManagementList.do"
				, data : paramData
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpGrid);
						var gridDataList = data.gridDataList;
						searchCheck = true;
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
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- deleteErpGrid 삭제 Function --%>
	function deleteErpGrid(){
		var gridRowCount = erpGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		
		var deleteRowIdArray = [];
		var check = "";
		var USE_YN = "";
		var total_count = 0;
		
		for(var i = 0 ; i < RowCountArray.length ; i++){
			check = erpGrid.cells(RowCountArray[i], erpGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(RowCountArray[i]);
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
		
		for(var j = 0; j < deleteRowIdArray.length; j++){
			erpGrid.deleteRow(deleteRowIdArray[j]);
			total_count += 1;
		}
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
		$erp.confirmMessage({
			"alertMessage" : "삭제하시겠습니까? </br> [적용 사항: " + total_count + "건]",
			"alertType" : null,
			"isAjax" : false,
			"alertCallbackFn" : function(){ saveErpGrid(total_count); },
			"alertCallbackFnFalse" : function(){ searchErpGrid(); }
		});
	}
	
	function saveErpGrid(total_count){
		var checkedGridData = $erp.serializeDhtmlXGridData(erpGrid,false,true);

		erpLayout.progressOn();
		$.ajax({
				url: "/common/pos/VanInfoManagement/deleteVanInfo.do"
				, data : checkedGridData
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOff();
					if(total_count == data){
						$erp.alertMessage({
							"alertMessage" : 'info.common.deleteSuccess',
							"alertType" : "info",
							"isAjax" : true,
							"alertCallbackFn" : function(){
								searchErpGrid();
							}
						});
					}else{
						$erp.alertMessage({
							"alertMessage" : 'info.common.noDeleteData',
							"alertType" : "alert",
							"isAjax" : true,
							"alertCallbackFn" : function(){	}
						});
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	
	function openDetailpopup(paramData){
		var option = {
				"win_id"	: "openVanInfopopup"
				,"width"	: 350
				,"height"	: 350
				}

		var closeAfterHeaderSearch = function(){
			this.searchErpGrid();
		}
		var url = "common/pos/VanInfoManagement/openVanInfopopup.sis";
		var onContentLoaded = function(){//팝업 이벤트 추가
			var popWin = this.getAttachedObject().contentWindow;
		
			if(closeAfterHeaderSearch && typeof closeAfterHeaderSearch === 'function'){
				while(popWin.closeAfterHeaderSearch == undefined){
					popWin.closeAfterHeaderSearch = closeAfterHeaderSearch;
				}
			}
			this.progressOff();
		}
		$erp.openPopup(url, {"vanInfo" : JSON.stringify(paramData)}, onContentLoaded, option); 
	}
	
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbVAN_CD = $erp.getDhtmlXComboCommonCode("cmbVAN_CD", "VAN_CD", ["VAN_CD"], 100, "모두조회", false);
		cmbVAN_CD.attachEvent("onChange", function(value, text){
			searchCheck = false;
		});
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- onKeyPressed erpGrid_Keypressed Function --%>
	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpGrid.setCSVDelimiter("\t");
			erpGrid.copyBlockToClipboard()
		}
		if(code==86&&ctrl){
			erpGrid.setCSVDelimiter("\t");
			erpGrid.pasteBlockFromClipboard()
		}
		return true;
	}
</script>


</head>
<body>
	<div id = "div_erp_search_table" class="samyang_div" style="display:none;">
	<table id="tb_search" class="table_search">
			<colgroup>
				<col width="80px;">
				<col width="140px;">
				<col width="12px;">
				<col width="140px;">
				<col width="*">
			</colgroup>
			<tr>
				<th>밴사 이름</th>
				<td>
					<div id="cmbVAN_CD"></div>
				</td>
			</tr>
	</table>
	</div>
	<div id = "div_erp_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
	<div id = "div_erp_grid" class="div_grid_full_size" style="display:none;"></div>
</body>
</html>