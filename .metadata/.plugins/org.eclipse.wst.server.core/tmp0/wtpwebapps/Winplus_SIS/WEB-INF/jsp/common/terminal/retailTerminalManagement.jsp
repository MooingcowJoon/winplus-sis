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

	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmbORGN_CD;
	var searchCheck = false;
	
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
		
		erpLayout.cells("a").attachObject("div_erp_select_combo");
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
					 , {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
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
				var orgn_cd = cmbORGN_CD.getSelectedValue();
				var trml_type = cmbTRML_TYPE.getSelectedValue();
				var isValidated = true;
				var alertMessage = "";
				var alertType = "error";
				if(!searchCheck){
					isValidated = false;
					alertMessage = "조회 이후에 가능한 기능입니다.";
				}
				if(orgn_cd == "" || trml_type == ""){
					isValidated = false;
					alertMessage = "조직명과 단말기 종류를 선택해주세요.";
				}
				if(!isValidated){
					$erp.alertMessage({
						"alertMessage" : alertMessage
						, "alertType" : alertType
						, "isAjax" : false
					});
				} else {
					addErpGrid(orgn_cd, trml_type);
				}
			} else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
			} else if(itemId == "excel_erpGrid") {
				$erp.exportDhtmlXGridExcel({
				     "grid" : erpGrid
				   , "fileName" : "직영점_단말기관리"
				   , "isForm" : false
				   , "excludeColumn" : ["NO","CHECK"]
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
			, {id : "ORGN_CD", label : ["조직명", "#rspan"], type : "combo", width : "130", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			, {id : "TRML_TYPE", label:["단말기종류", "#rspan"], type: "combo", width: "130", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["TRML_TYPE", ""]}
			, {id : "USE_YN", label:["사용여부", "#rspan"], type: "combo", width: "70", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["USE_CD" , "YN"]}
			, {id : "TRML_SERIAL", label:["일련번호", "#rspan"], type: "ed", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, maxLength : 50}
			, {id : "CATID_NO", label:["CATID번호", "#rspan"], type: "ed", width: "100", sort : "int", align : "center", isHidden : false, isEssential : false, maxLength : 20}
			, {id : "TRML_NO", label:["단말기번호", "#rspan"], type: "ron", width: "70", sort : "int", align : "center", isHidden : false, isEssential : true, maxLength : 2}
			, {id : "UNIQUE_KEY", label:["중복체크", "#rspan"], type: "ro", width: "200", sort : "str", align : "center", isHidden : true}
			];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});		
		
// 		erpGrid.attachEvent("onRowPaste", function(rId){
// 			var tmpRowIndex = erpGrid.getRowIndex(rId);
// 			if(erpGrid.getRowId((tmpRowIndex+1)) == undefined || erpGrid.getRowId((tmpRowIndex+1)) == "undefined" ){
// 				addErpGrid();
// 			}
// 		}); 
		
		erpGrid.attachEvent("onKeyPress",onKeyPressed);
		erpGrid.enableBlockSelection();
		erpGrid.enableDistributedParsing(true, 100, 50);
		erpGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
	}
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		var TRML_TYPE = cmbTRML_TYPE.getSelectedValue();
		erpLayout.progressOn();
		$.ajax({
				url: "/common/terminal/getTerminalList.do"
				, data : {
					 "ORGN_CD" : ORGN_CD
					 ,"TRML_TYPE" : TRML_TYPE
				}
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
	<%-- erpGrid 조회 Function 끝--%>
	
	function addErpGrid(orgn_cd, trml_type){
			var uid = erpGrid.uid();
			erpGrid.addRow(uid);
			erpGrid.selectRow(erpGrid.getRowIndex(uid));
			erpGrid.cells(uid, erpGrid.getColIndexById("ORGN_CD")).setValue(orgn_cd);
			erpGrid.cells(uid, erpGrid.getColIndexById("TRML_TYPE")).setValue(trml_type);
			erpGrid.setCellExcellType(uid, erpGrid.getColIndexById("TRML_NO"),"edn");//addrow에만 작성가능
			
			$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	<%-- saveErpGrid 저장 Function --%>
	function saveErpGrid() {
		if(erpGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpGrid);
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		var isValidated = true;
		var isValidated2 = true;
		var alertMessage = "";
		
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);
		var trml_no;
		var trml_type;
		var orgn_cd;
		var trml_serial;
		var unique_key;
		
		var allrowids = erpGrid.getAllRowIds(",");
		var allrowids_arr = allrowids.split(",");
		var dupli_no = "";
		var findedcell_arr;
		var rIdx;
		for(var i in paramData.TRML_NO){
			trml_no = paramData.TRML_NO[i]
			trml_type = paramData.TRML_TYPE[i]
			orgn_cd = paramData.ORGN_CD[i]
			crud = paramData.CRUD[i]
			trml_serial = paramData.TRML_SERIAL[i]
			catid_no = paramData.CATID_NO[i]
			findedcell_arr = erpGrid.findCell(paramData.TRML_NO[i],erpGrid.getColIndexById("TRML_NO"),false,true);

			rIdx = erpGrid.getRowIndex(findedcell_arr[findedcell_arr.length-1][0]);
			if(trml_no.length == 1){
				trml_no = "0" + trml_no
			}
			if(trml_type == "1"){
				if(catid_no == ""){
					isValidated = false;
					alertMessage = "CATID번호가 입력되지 않았습니다.";
					erpGrid.selectCell(rIdx,erpGrid.getColIndexById("CATID_NO"),false,true,true);
				}
			}else if(trml_type == "0" || trml_type == "2"){
				if(trml_serial == ""){
					isValidated = false;
					alertMessage = "일련번호가 입력되지 않았습니다.";
					erpGrid.selectCell(rIdx,erpGrid.getColIndexById("TRML_SERIAL"),false,true,true);
				}
			}
			if(crud == "C"){
				if(Number(trml_no) > 0 && Number(trml_no) < 100){
					unique_key = orgn_cd + "_" + trml_type + "_" + trml_no
					for(var j in allrowids_arr){
						if(unique_key == erpGrid.cells(allrowids_arr[j],erpGrid.getColIndexById("UNIQUE_KEY")).getValue()){
							dupli_no += trml_no + ",";
							isValidated = false;
// 							for(var z=1;z<findedcell.length;z++){
// 								erpGrid.cells(findedcell[z][0],erpGrid.getColIndexById("TRML_NO")).setBgColor('pink');
// 							}
						}
					}
				}else{
					isValidated = false;
					alertMessage = "단말기 번호가 올바르지 않습니다.</br>(01~99)";
				}
			} else if(crud == "U"){
				
			}
		}
		if(dupli_no != ""){
			dupli_no = dupli_no.substr(0, dupli_no.length -1);
			alertMessage = "중복된 단말기 번호를 저장하실 수 없습니다.</br>[중복 번호 : " + dupli_no + "]";
		}
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage,
				"alertType" : "info",
				"isAjax" : false
			});
		}else{
			erpLayout.progressOn();
			$.ajax({
				url : "/common/terminal/saveTerminalList.do"
				,data : paramData
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					erpLayout.progressOff();
					console.log(data)
					if(data.isError){
						if(data.errMessage.split("중복").length > 1){
							data.errMessage = "중복된 단말기 번호를 저장하실 수 없습니다."
						}else if(data.errMessage.split("문자열이나 이진 데이터는 잘립니다").length > 1){
							data.errMessage = "올바르지 않은 형태의 데이터를 저장하실 수 없습니다."
						}
						$erp.ajaxErrorMessage(data);
					}else {
						if(data.deleteResult == 0 && data.insertResult == 0 && data.updateResult == 0){
							$erp.alertMessage({
								"alertMessage" : "변경된 정보가 없습니다.",
								"alertCode" : null,
								"alertType" : "alert",
								"isAjax" : false,
								"alertCallbackFn" : function() {searchErpGrid();}
							});
						} else {
							$erp.alertMessage({
								"alertMessage" : "저장되었습니다.",
								"alertCode" : null,
								"alertType" : "alert",
								"isAjax" : false,
								"alertCallbackFn" : function() {searchErpGrid();}
							});
						}
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	<%-- deleteErpGrid 삭제 Function --%>
	function deleteErpGrid(){
		var gridRowCount = erpGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		
		var deleteRowIdArray = [];
		var check = "";
		var USE_YN = "";
		var dupli_count = 0;
		
		for(var i = 0 ; i < RowCountArray.length ; i++){
			check = erpGrid.cells(RowCountArray[i], erpGrid.getColIndexById("CHECK")).getValue();
			USE_YN = erpGrid.cells(RowCountArray[i], erpGrid.getColIndexById("USE_YN")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(RowCountArray[i]);
				if(USE_YN == "Y"){
					erpGrid.cells(RowCountArray[i], erpGrid.getColIndexById("CHECK")).setValue("0")
					deleteRowIdArray.pop(RowCountArray[i]);
					dupli_count += 1
				}
			}
		}
		
		if(deleteRowIdArray.length == 0 && dupli_count == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}
		
		for(var j = 0; j < deleteRowIdArray.length; j++){
			erpGrid.deleteRow(deleteRowIdArray[j]);
		}
		if(dupli_count != 0){
			$erp.alertMessage({
				"alertMessage" : "단말기의 사용 여부를 확인하세요.</br>[사용 중인 단말기 : " + dupli_count + " 대]"
				,"alertType" : "alert"
				,"isAjax" : false
			});
		}
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbORGN_CD = $erp.getDhtmlXComboCommonCode("SELECT_ORGN", "cmbORGN_CD", ["ORGN_CD","MK"], 100, "모두조회", false);
		cmbTRML_TYPE = $erp.getDhtmlXComboCommonCode("cmbTRML_TYPE", "cmbTRML_TYPE", ["TRML_TYPE"], 100, "모두조회", false);
		
		cmbORGN_CD.attachEvent("onChange", function(value, text){
			searchCheck = false;
			$erp.clearDhtmlXGrid(erpGrid);
		});
		cmbTRML_TYPE.attachEvent("onChange", function(value, text){
			searchCheck = false;
			$erp.clearDhtmlXGrid(erpGrid);
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
	<div id = "div_erp_select_combo" class="samyang_div" style="display:none;">
	<table id="tb_erp_data" class="table_search">
			<colgroup>
				<col width="70px;">
				<col width="140px;">
				<col width="70px;">
				<col width="140px;">
				<col width="*">
			</colgroup>
			<tr>
				<th>조직명</th>
				<td>
					<div id="SELECT_ORGN"></div>
				</td>
				<th>단말기 종류</th>
				<td>
					<div id="cmbTRML_TYPE"></div>
				</td>
			</tr>
	</table>
	</div>
	<div id = "div_erp_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
	<div id = "div_erp_grid" class="div_grid_full_size" style="display:none;"></div>
</body>
</html>