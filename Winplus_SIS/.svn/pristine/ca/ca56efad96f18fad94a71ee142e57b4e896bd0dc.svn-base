<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js?ver=33"></script>
<script type="text/javascript">

	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	
	var cmbCUSTMR_SALE_PRICE;
	var cmbUSE_YN;
	
	$(document).ready(function(){
		LUI.exclude_auth_cd = "ALL,1,5,6";
		LUI.exclude_orgn_type = "MK";
		
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		
		initDhtmlXCombo();
		
		$erp.asyncObjAllOnCreated(function(){
			searchErpGrid();
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "고객그룹별_기준가관리(상품별)", header: true}
				, {id : "b", text: "erp_ribbon", header: false, fix_size:[true, true]}
				, {id : "c", text: "erp_grid", header: false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight(65);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	function initErpRibbon() {
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 					, {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
					, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					, {id : "save_erpGrid"  , type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					, {id : "excelForm_erpGrid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					, {id : "excel_grid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, isHidden : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchErpGrid();
			}else if(itemId == "add_erpGrid") {
				var custmrSP = cmbCUSTMR_SALE_PRICE.getSelectedValue();
				if(custmrSP == "" || custmrSP == null){
					$erp.alertMessage({
						"alertMessage" : "거래처기준가그룹을 선택 후 이용가능합니다."
						, "alertType" : "alert"
						, "isAjax" : false
					});
				}else{
					openSearchGoodsGridPopup();
				}
			}else if (itemId == "save_erpGrid"){
				saveErpGrid();
			}else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
			}else if(itemId == "excel_erpGrid") {
				$erp.exportGridToExcel({
					"grid" : erpGrid
					, "fileName" : "고객그룹별_기준가관리(상품별)"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			}else if(itemId == "excelForm_erpGrid") {
				$erp.exportGridToExcel({
					"grid" : erpGrid
					, "fileName" : "고객그룹별_기준가관리(상품별)_양식"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" :  ['CUSTMR_GRUP','STD_PRICE_GRUP_NM','STRT_DATE','BCD_NM','DIMEN_NM','PUR_PRICE','SALE_PRICE','PROF_RATE','TAX_YN','REMK','USE_YN']
					, "isIncludeHidden" : false
					, "isExcludeGridData" : true
				});
			}else if(itemId == "excel_grid_upload") {
				var convertModuleUrl = ""; //엑셀로 컨버트 하는 모듈을 다른것을 사용하고자 할때만 사용
				var uploadFileLimitCount = 1; //파일 업로드 개수 제한
				var onUploadFile = function(files, uploadData, toGrid){
					$erp.uploadDataParse(this, files, uploadData, toGrid, "BCD_CD", "add", ["BCD_CD"], []);
				}
				var onUploadComplete = function(uploadedFileInfoList, toGrid, result){
					pasteGoods(result);
				}
				var onBeforeFileAdd = function(file){};
				var onBeforeClear = function(){};
				$erp.excelUploadPopup(erpGrid, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "STD_PRICE_GRUP", label:["거래처기준가<br>그룹코드", "#rspan"], type: "ro", width: "85", sort : "str", align : "left", isHidden : false, isEssential : true, isDisabled : true}
			, {id : "STD_PRICE_GRUP_NM", label:["거래처기준가그룹", "#select_filter"], type: "ro", width: "105", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CUSTMR_GRUP", label:["거래처그룹", "#select_filter"], type: "combo", width: "105", sort : "str", align : "left", isHidden : false, isEssential : true, isDisabled : true, commonCode : ['CUSTMR_GRUP']}
			, {id : "STRT_DATE", label:["적용시작일", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "GOODS_NO", label:["상품코드", "#text_filter"], type: "ro", width: "95", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "BCD_CD", label:["바코드", "#text_filter"], type: "ro", width: "110", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "BCD_NM", label:["상품명", "#text_filter"], type: "ro", width: "230", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "PUR_PRICE", label:["기본매입가", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "SALE_PRICE", label:["기준출고가", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "STD_SALE_PRICE", label:["적용출고가", "#rspan"], type: "edn", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true}
			, {id : "PROF_RATE", label:["이익율", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "00.00%"}
			, {id : "TAX_YN", label:["부가세", "#select_filter"], type: "combo", width: "65", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ['USE_CD', 'YN']}
			, {id : "USE_YN", label:["사용", "#select_filter"], type: "combo", width: "65", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ['USE_CD', 'YN']}
			, {id : "REMK", label:["비고", "#rspan"], type: "ro", width: "125", sort : "str", align : "left", isHidden : false, isEssential : true}
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
		erpGrid.enableColumnMove(true);
		erpGrid.setDateFormat("%Y-%m-%d", "%Y-%m-%d");
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		
		erpGrid.attachEvent("onCellChanged", function (rowId,columnIdx,newValue){
			var warning_pr_rowId_obj = {};
			if(erpGrid.getColumnId(columnIdx) == "STD_SALE_PRICE"){
				let sp; 				//정상판매
				let ep; 				//특매판매
				let change_ep;			//할인율
				let change_ep_price;	//할인
				
				sp = erpGrid.cells(rowId, erpGrid.getColIndexById("PUR_PRICE")).getValue();
				ep = erpGrid.cells(rowId, erpGrid.getColIndexById("STD_SALE_PRICE")).getValue();
				
				sp = parseInt(sp);
				ep = parseInt(ep);
				
				change_ep = ((ep-sp)/sp) * 100;
				
				erpGrid.cells(rowId, erpGrid.getColIndexById("PROF_RATE")).setValue(change_ep);
				
				setTimeout(function(){
					if(change_ep < 0){
						erpGrid.cells(rowId, erpGrid.getColIndexById("PROF_RATE")).setBgColor('#F6CED8');
						warning_pr_rowId_obj[rowId] = rowId;
					}
				},50);
			}	
		});
		
		//미사용 상품 투명도조정(페이징될때)
// 		erpGrid.attachEvent("onPageChanged", function(a){
// 			erpLayout.progressOn();
// 			setTimeout(function(){
// 				console.log("fufufufu");
// 				console.log(a);
// 				for(var i=a; i <100; i++){
// 					console.log("dkdkd");
// 					erpGrid.setCellTextStyle("TAX_YN",0,"white;");
// 				}
// 				erpLayout.progressOff();
// 			}, 10);
// 		});
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 조회 Function 시작 --%>
	function searchErpGrid(){
		var paramData = {};
		paramData["SEARCH_WORD"] = document.getElementById("txtSEARCH_WORD").value;
		paramData["STD_PRICE_GRUP"] =cmbCUSTMR_SALE_PRICE.getSelectedValue();
		paramData["USE_YN"] = cmbUSE_YN.getSelectedValue();
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/basic/getCustmrStdPrice.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGrid);
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
	<%-- ■ erpGrid 조회 Function 끝 --%>
	
	<%-- ■ erpGrid 저장 Function 시작 --%>
	function saveErpGrid(){
		var gridRowCount = erpGrid.getRowsNum();
		var lastRowNum = gridRowCount-1;
		var lastRid = erpGrid.getRowId(lastRowNum);
		var lastRowcheck = erpGrid.cells(lastRid, erpGrid.getColIndexById("STD_PRICE_GRUP")).getValue();
		if(lastRowcheck == null || lastRowcheck == "null" || lastRowcheck == undefined || lastRowcheck == "undefined" || lastRowcheck == "") {
			erpGrid.deleteRow(lastRid);
		}
		
		if(erpGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
			
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);
		$.ajax({
			url : "/sis/basic/saveCustmrStdPrice.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.alertSuccessMesage(onAfterSaveErpGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpGrid 저장 Function 끝 --%>
	
	<%-- erpGrid 저장 후 Function 시작 --%>
	function onAfterSaveErpGrid(){
		searchErpGrid();
	}
	<%-- erpGrid 저장 후 Function 끝 --%>
	
	<%-- deleteErpGrid 삭제 Function --%>
	function deleteErpGrid(){
		$erp.confirmMessage({
			"alertMessage" : "삭제시 해당 품목을 다시 사용하기 위해선<br><span style='color:red; font-weight:bold;'>재등록</span>을 해야 합니다.&nbsp재사용을 위해서는<br>사용여부를 <span style='color:red; font-weight:bold;'>'N'</span>으로 설정하시기 바랍니다.<br>진행하시겠습니까?",
			"alertType" : "alert",
			"isAjax" : false,
			"alertCallbackFn" : function confirmAgain(){
		
			var gridRowCount = erpGrid.getAllRowIds(",");
			var RowCountArray = gridRowCount.split(",");
			
			var deleteRowIdArray = [];
			var check = "";
			
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
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpGrid);
			
			saveErpGrid();
			}
		});
	}
	
	<%-- deleteErpGrid 삭제 Function 끝 --%>
	
	<%-- ■ onKeyPressed 고객그룹별_기준가관리Grid_Keypressed Function 시작 --%>
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
	<%-- ■ onKeyPressed 고객그룹별_기준가관리Grid_Keypressed Function 끝--%>
	
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 열림 Function --%>
	function openSearchGoodsGridPopup(){
		var onClickRibbonAddData = function(popupGrid){
			var popup = erpPopupWindows.window("openSearchGoodsGridPopup");
			popup.progressOn();
			$erp.copyRowsGridToGrid(popupGrid, erpGrid, ["BCD_CD","BCD_NM","DIMEN_NM"], ["BCD_CD","BCD_NM","DIMEN_NM"], "checked", "add", ["BCD_CD"], [], {}, {}, function(result){
				popup.progressOff();
				popup.close();
				
				pasteGoods(result);
			},false);
		}
		$erp.openSearchGoodsPopup(null,onClickRibbonAddData,{"ORGN_DIV_CD" : "B01"});
	}
	<%-- openGoodsGridPopup 상품조회 그리드 팝업 끝 Function --%>
	
	<%-- 상품 붙여넣기 function 시작--%>
	function pasteGoods(result){
		var loadGoodsList = [];
		var data;
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];
			loadGoodsList.push(data["BCD_CD"]);
		}
		
		var url = "/sis/basic/getStdPriceGoodsManagementInfo.do";
		var send_data = {"loadGoodsList" : loadGoodsList};
		
		var if_success = function(data){
			var gridDataList = data.gridDataList;
			for(var index in gridDataList){
				erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGrid.getColIndexById("TAX_YN")).setValue('Y');
				erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGrid.getColIndexById("USE_YN")).setValue('Y');
				erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGrid.getColIndexById("PUR_PRICE")).setValue(gridDataList[index]["PUR_PRICE"]);
				erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGrid.getColIndexById("GOODS_NO")).setValue(gridDataList[index]["GOODS_NO"]);
				erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGrid.getColIndexById("BCD_NM")).setValue(gridDataList[index]["BCD_NM"]);
				erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGrid.getColIndexById("DIMEN_NM")).setValue(gridDataList[index]["DIMEN_NM"]);
				erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpGrid.getColIndexById("SALE_PRICE")).setValue(gridDataList[index]["SALE_PRICE"]);
				result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]].push("로드완료");
			}	
			var notExistList = [];
			var value;
			var state;
			var dp = erpGrid.getDataProcessor();
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["BCD_CD"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			$erp.deleteGridRows(erpGrid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			if(erpGrid.getRowsNum() == 0){
				erpGrid.callEvent("onClick",["searchErpGrid"]);
				return;
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpGrid); // 현재 행수 계산
			
		}
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
	}
	<%-- 상품 붙여넣기 function 끝--%>
	
	<%-- dhtmlxCombo 초기화 Function 시작--%>
	function initDhtmlXCombo(){
		cmbUSE_YN = $erp.getDhtmlXComboCommonCode('cmbUSE_YN', 'USE_CD',['USE_CD', 'YN'], 100, "모두조회", false,"Y");
		cmbCUSTMR_SALE_PRICE = $erp.getDhtmlXComboTableCode("cmbCUSTMR_SALE_PRICE", "CUSTMR_SALE_PRICE", "/sis/code/getSearchStdPriceCdList.do", null, 150, "모두조회", false);
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_table" class="samyang_div" style="display:none;">
		<table id = "tb_search" class = "table_search">
				<colgroup>
					<col width="130px"/>
					<col width="155px"/>
					<col width="75px"/>
					<col width="150px"/>
					<col width="70px"/>
					<col width="*px"/>
				</colgroup>
				<tr>
					<th>거래처기준가그룹</th>
					<td><div id="cmbCUSTMR_SALE_PRICE"></div> </td>
					<th>검색어</th>
					<td><input type="text" id="txtSEARCH_WORD" name="txtSEARCH_WORD" class="input_common" maxlength="500" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid);"></td>
					<th>사용여부</th>
					<td><div id="cmbUSE_YN"></div></td>
				</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none;"></div>
</body>
</html>