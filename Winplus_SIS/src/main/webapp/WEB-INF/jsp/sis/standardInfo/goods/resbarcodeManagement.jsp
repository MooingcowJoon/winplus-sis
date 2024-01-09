<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">
	
	var total_layout;
	var top_layout;
	var mid_layout;
	var ribbon;
	var bot_layout;
	var bot_layout_grid;
	var RES_BCD_LIST_STRING = "";
	var erpGridDataProcessor;
	var warning_bcd_rowId_obj = {};
	
	$(document).ready(function() {
		init_total_layout();
		init_top_layout();		
		init_mid_layout();		
		init_bot_layout();
	});
	
	function init_total_layout() {
		total_layout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "검색 조건", header: false, fix_size : [true, true]}
				,{id: "b", text: "버튼 목록", header: false, fix_size:[true,true]}
				,{id: "c", text: "예비 바코드 그리드", header: false, fix_size:[true,true]}
			]
		});
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight(60);
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(40);
		total_layout.cells("c").attachObject("div_bot_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
	}
	
	function init_top_layout(){
		cmbBCD_STATE = $erp.getDhtmlXComboCommonCode("cmbBCD_STATE", "BCD_STATE", ["BCD_STATE"], 110, "모두조회", false, "");
		cmbGRUP_TYPE = $erp.getDhtmlXComboCommonCode("cmbGRUP_TYPE", "GRUP_TYPE", "RES_BCD_GRUP", 110, "모두조회", false, "")
	}
	
	function init_mid_layout(){
		ribbon = new dhtmlXRibbon({
			parent : "div_mid_layout"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
				           {
				        	   type : "block"
				        	   , mode : 'rows'
			        		   , list : [
			        		            {id : "search_grid",	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 			        		            , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
// 			        		            , {id : "delete_grid",	type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
 			        		            , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
			        		            , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true, unused : false}
//			        		            , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
			        		            , {id : "excelForm_grid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
										, {id : "excel_grid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : false}
			        		             ]
							}
				           ]
		});
		ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				isSearchValidate();
			} else if (itemId == "add_grid"){
					
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				saveErpGrid();
			} else if (itemId == "excel_grid"){
				$erp.exportGridToExcel({
					"grid" : bot_layout_grid
					, "fileName" : "예비바코드목록"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			} else if (itemId == "excelForm_grid"){
				$erp.exportGridToExcel({
					"grid" : bot_layout_grid
					, "fileName" : "예비바코드 작성양식"
					, "isOnlyEssentialColumn" : false
					, "excludeColumnIdList" : ['NO','RES_BCD_13','RES_BCD_BOX','BCD_STATE','BCD_MS_TYPE','STRT_DATE','END_DATE','CUSTMR_CD','CUSTMR_NM','GOODS_NO','GOODS_NM','GRUP_TYPE','DIMEN_NM','UNIT_QTY','REMK']
					, "isIncludeHidden" : true
					, "isExcludeGridData" : true
				});
			} else if (itemId == "excel_grid_upload"){
				var convertModuleUrl = ""; //엑셀로 컨버트 하는 모듈을 다른것을 사용하고자 할때만 사용
				var uploadFileLimitCount = 1; //파일 업로드 개수 제한
				var onUploadFile = function(files, uploadData, toGrid){
					$erp.uploadDataParse(this, files, uploadData, toGrid, "RES_BCD_12", "new", [], ["RES_BCD_12"]);
				}
				var onUploadComplete = function(uploadedFileInfoList, toGrid, result){
					loadRESBCD(result,toGrid);
				}
				var onBeforeFileAdd = function(file){};
				var onBeforeClear = function(){};
				$erp.excelUploadPopup(bot_layout_grid, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			
			} else if (itemId == "print_grid"){
			}
		});
	}
	function isSearchValidate() {
		var BCD_WORD = $("#txtBCD_WORD").val();
		var CUSTMR_WORD = $("#txtCUSTMR_WORD").val();
		var regular_expression = /[0-9]/;
		if(BCD_WORD != "") {
			if(regular_expression.test(BCD_WORD) == false) {
				$erp.alertMessage({
					"alertMessage" : "숫자만 입력하세요.",
					"alertType" : "alert",
					"isAjax" : false
				});
			} 			
			else
			searchErpGrid();
		}
		else
		searchErpGrid();
	}
	
	function searchErpGrid() {
		var dataObj = $erp.dataSerialize("tb_search");
		var url = "/sis/standardInfo/goods/getresbarcodeHeaderList.do";
		var send_data = $erp.unionObjArray([null,dataObj]);
		console.log(send_data);
		var if_success = function(data){
			$erp.clearDhtmlXGrid(bot_layout_grid); //기존데이터 삭제
			if($erp.isEmpty(data.gridDataList)){
				//검색 결과 없음
				$erp.addDhtmlXGridNoDataPrintRow(bot_layout_grid, '<spring:message code="info.common.noDataSearch" />');
			}else{
				
				bot_layout_grid.parse(data.gridDataList,'js');
				
				$erp.setDhtmlXGridFooterRowCount(bot_layout_grid);
			}
		}
		var if_error = function(){
		
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
	<%-- erpGrid 저장 Function --%>
	function saveErpGrid(){
    	var isExistWarning = false;
    	var firstWarningRowIndex = -999;
    	var warningRowCount = 0;
    	console.log(warning_bcd_rowId_obj)
    	for(key in warning_bcd_rowId_obj){
    		if(warning_bcd_rowId_obj[key] != null){
    			if(firstWarningRowIndex == -999){
	    			isExistWarning = true;
	    			firstWarningRowIndex = bot_layout_grid.getRowIndex(key);
    			}
    			warningRowCount++;    		
    		}
    	}
    	
    	var exec = function(){
			$erp.gridValidationCheck(bot_layout_grid, function(){
				var data1 = {};
				data1["CUSER"] = "${empSessionDto.emp_no}";
				data1["MUSER"] = "${empSessionDto.emp_no}";
				
				var data = $erp.dataSerializeOfGrid(bot_layout_grid,false,data1);
				console.log(data)
				var url = "/sis/standardInfo/goods/insertRESBCD.do";
				var send_data = {"listMap" : data};
				var if_success = function(data){
					$erp.alertSuccessMesage(function(){
						ribbon.callEvent("onClick", ["search_grid"]);
					});
				}
				var if_error = function(XHR, status, error){
					
				}
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			});
    	}
    	
    	if(isExistWarning){
    		//마지막으로 추가한 로우 선택
			bot_layout_grid.selectRow(firstWarningRowIndex,false,false,true);
			// 1.인덱스
			// 2.선택만 할 것인지 선택 이벤트도 발생시킬 것인지
			// 3.이전 선택유지하면서 추가로 선택 할 것인지(다중선택)
			// 4.그리드의 현재 보이지 않는 위치에 있으면 스크롤 해서 보여줄 것인지
    		
    		$erp.confirmMessage({
				"alertMessage" : "저장할 수 없는 바코드가 있습니다.<br/>초기화 하시겠습니까?<br/>[저장 불가 바코드 수 : " + warningRowCount + "]",
				"alertType" : "alert",
				"isAjax" : false,
				"alertCallbackFn" : function(){
					//init_total_layout();
					$erp.clearDhtmlXGrid(bot_layout_grid);
				},
				"alertCallbackFnParam" : [],
				"alertCallbackFnFalse" : function(){},
				"alertCallbackFnParamFalse" : []
			});
    	}else{
    		exec();
    	}
	}
	
	function init_bot_layout() {
		//"#text_filter" "#rspan"
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
							{id : "NO", label:["순번","#rspan"], type : "cntr", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : true}
		                    , {id : "RES_BCD_12", label:["예비바코드12","#rspan"], type : "ron", width : "110", sort : "int", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
		                    , {id : "RES_BCD_13", label:["예비바코드13", "#text_filter"], type : "ro", width : "110", sort : "str", align : "left", isHidden : false, isEssential : false}
							, {id : "RES_BCD_BOX", label:["박스바코드14", "#text_filter"], type : "ro", width : "110", sort : "str", align : "left", isHidden : false, isEssential : false}
							, {id : "BCD_STATE", label:["사용상태","#rspan"], type : "combo", width : "70", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["BCD_STATE"]}
		                    , {id : "BCD_MS_TYPE", label:["모자구분", "#rspan"], type : "combo", width : "70", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : "BCD_MS_TYPE"}
		                    , {id : "GOODS_NO", label:["상품번호", "#rspan"], type : "ro", width : "100", sort : "str", align : "left", isHidden : true, isEssential : false}
							, {id : "GOODS_NM", label:["상품명", "#text_filter"], type : "ro", width : "300", sort : "str", align : "left", isHidden : false, isEssential : false}
							, {id : "DIMEN_NM", label:["규격명", "#rspan"], type : "ro", width : "50", sort : "str", align : "right", isHidden : false, isEssential : false}
							, {id : "UNIT_QTY", label:["입수량", "#rspan"], type : "ro", width : "50", sort : "str", align : "right", isHidden : false, isEssential : false}
							, {id : "CUSTMR_CD", label:["제조사코드", "#rspan"], type : "ro", width : "120", sort : "str", align : "left", isHidden : true, isEssential : false}
							, {id : "CUSTMR_NM", label:["제조사명", "#text_filter"], type : "ro", width : "150", sort : "str", align : "left", isHidden : false, isEssential : false}
							, {id : "GRUP_TYPE", label:["분류그룹", "#rspan"], type : "combo", width : "120", sort : "str", align : "center", isHidden : false, isDisabled : false, commonCode : "RES_BCD_GRUP"}
		                    , {id : "STRT_DATE", label:["적용시작일", "#rspan"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : false}
							, {id : "END_DATE", label:["적용종료일", "#rspan"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential :false}
							, {id : "REMK", label:["비고", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : true}
		                    ];
		
		bot_layout_grid = new dhtmlXGridObject({
			parent: "div_bot_layout"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		
		$erp.initGrid(bot_layout_grid,{multiSelect : true});
		
		bot_layout_grid.attachEvent("onEndPaste", function(result){
			loadRESBCD(result);
	    });
	}
	
	function loadRESBCD(result,toGrid){
		var data;
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];//신규 데이터
			RES_BCD_LIST_STRING += data["RES_BCD_12"] + ","
		}
		RES_BCD_LIST_STRING = RES_BCD_LIST_STRING.substr(0,RES_BCD_LIST_STRING.length-1);//마지막 콤마 삭제
		
		var url = "/sis/standardInfo/goods/getRESBCDInfo.do";
		var send_data = {"RES_BCD_LIST_STRING" : RES_BCD_LIST_STRING};
		
		var if_success = function(data){
			var gridDataList = data.gridDataList;
			console.log(gridDataList)
			for(var index in gridDataList){
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["RES_BCD_12"]][1], bot_layout_grid.getColIndexById("RES_BCD_12")).setValue(gridDataList[index]["RES_BCD_12"]);

				if(gridDataList[index]["BCD_STATE"] == 'Y'){
					result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["RES_BCD_12"]].push("중복데이터");
				} else if( gridDataList[index]["BCD_STATE"] == 'U'){
					bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["RES_BCD_12"]][1], bot_layout_grid.getColIndexById("REMK")).setValue("바코드 사용중");
				} else if( gridDataList[index]["BCD_STATE"] == 'L'){
					bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["RES_BCD_12"]][1], bot_layout_grid.getColIndexById("REMK")).setValue("바코드 사용금지");
				} else if( gridDataList[index]["BCD_STATE"] == 'N'){
					bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["RES_BCD_12"]][1], bot_layout_grid.getColIndexById("REMK")).setValue("바코드 사용중단");
				}
			}
			
			var notExistList = [];
			var value;
			var state;
			var dp = bot_layout_grid.getDataProcessor();
			var findItem;
			for(var index in result.newAddRowDataList){
				findItem = toGrid.findCell(result.newAddRowDataList[index]["RES_BCD_12"],toGrid.getColIndexById("RES_BCD_12"),true,true);
				console.log(findItem[0][0])
				if(String(Number(result.newAddRowDataList[index]["RES_BCD_12"])).length != 12){
					toGrid.cells(findItem[0][0], toGrid.getColIndexById("REMK")).setValue("12자리 숫자 바코드를 입력하세요.");
					bot_layout_grid.cells(findItem[0][0], bot_layout_grid.getColIndexById("REMK")).setBgColor('pink');

					warning_bcd_rowId_obj[findItem[0][0]] = findItem[0][0];
				}
				else{
					warning_bcd_rowId_obj[findItem[0][0]] = null;
				}
				
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["RES_BCD_12"]];
				state = dp.getState(value[1]);
				if(value.length == 3 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			
			$erp.deleteGridRows(bot_layout_grid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + (result.duplicationCount_in_toGridDataList + notExistList.length) + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			$erp.setDhtmlXGridFooterRowCount(bot_layout_grid); // 현재 행수 계산
			
			toGrid.selectRowById(toGrid.getRowId(result.insertedRowIndexList[0]),false,true,false);//업로드한 정보로 포커싱
    		
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
</script>
</head>
<body>
	<div id="div_top_layout" class="samyang_div" style="display:none">
		<div id="div_top_layout_search" class="samyang_div">
			<table id="tb_search" class="table">
				<colgroup>
					<col width="100px"/>
					<col width="175px"/>
					<col width="100px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="100px"/>
					<col width="100px"/>
					<col width="100px"/>
					<col width="100px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th colspan="1">바코드 검색</th>
					<td colspan="1"><input type="text" id="txtBCD_WORD" name="KEY_WORD" maxlength="12" class="input_common" autocomplete="off" style="width:150px;height:17px" onkeydown="$erp.onEnterKeyDown(event, isSearchValidate);"></td>
					<th colspan="1">사용 상태</th>
					<td colspan="7"><div id="cmbBCD_STATE"></div></td>
				</tr>
				<tr>
					<th colspan="1">제조사 검색</th>
					<td colspan="1"><input type="text" id="txtCUSTMR_WORD" name="KEY_WORD" maxlength="50" class="input_common" autocomplete="off" onkeydown="$erp.onEnterKeyDown(event, isSearchValidate);" style="width:150px;height:17px"></td>
					<th colspan="1">분류 그룹</th>
					<td colspan="7"><div id="cmbGRUP_TYPE"></div></td>
				</tr>	
			</table>
		</div>
	</div>
	
	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bot_layout" class="div_grid_full_size" style="display:none"></div>
		
</body>
</html>