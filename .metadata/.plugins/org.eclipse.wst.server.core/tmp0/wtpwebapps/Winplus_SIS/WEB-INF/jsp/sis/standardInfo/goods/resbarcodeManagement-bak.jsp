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
	var mid_layout_ribbon;
	var bot_header_layout;
	var bot_header_layout_grid;
	var bot_detail_layout;
	var bot_detail_layout_ribbon;
	var bot_detail_layout_grid;
	var chkUSED_LOG;
	var RES_BCD_LIST_STRING = "";
	
	$(document).ready(function() {
		init_total_layout();
		init_top_layout();
		
		init_bot_header_layout();
		init_bot_header_layout_ribbon();
		init_bot_header_layout_grid();
		
		init_bot_detial_layout();
		init_bot_detail_layout_ribbon();
		init_bot_detail_layout_grid();
	});
	
	function init_total_layout() {
		total_layout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3T"
			, cells : [
				{id: "a", text: "검색 조건", header:false, fix_size : [true, true]}
				,{id: "b", text: "바코드 목록", header: true, fix_size:[true,true], width: 400}
				,{id: "c", text: "바코드 매칭 상태", header: true, fix_size:[true,true]}
			]
		});
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight(60);
		total_layout.cells("b").attachObject("div_bot_header_layout");
		total_layout.cells("c").attachObject("div_bot_detail_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
	}
	
	function init_top_layout(){
		cmbBCD_STATE = $erp.getDhtmlXComboCommonCode("cmbBCD_STATE", "BCD_STATE", "BCD_STATE", 110, "모두조회", false, "");
		cmbGRUP_TYPE = $erp.getDhtmlXComboCommonCode("cmbGRUP_TYPE", "GRUP_TYPE", "RES_BCD_GRUP", 230, "모두조회", false, "");
//		chkUSED_LOG = $erp.getDhtmlXCheckBox('chkUSED_LOG', '사용이력포함', '0 ', false, 'label-right',null);
		chkLOCK = $erp.getDhtmlXCheckBox('chkLOCK', '잠금포함', '0 ', false, 'label-right',null);
	}							
	
	function init_bot_header_layout() {
		bot_header_layout = new dhtmlXLayoutObject({
			parent : "div_bot_header_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "버튼영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "그리드영역", header:false, fix_size : [true, true]}
			]
		});
		bot_header_layout.cells("a").attachObject("div_bot_header_layout_ribbon");
		bot_header_layout.cells("a").setHeight(40);
		bot_header_layout.cells("b").attachObject("div_bot_header_layout_grid");
		
		bot_header_layout.setSeparatorSize(0, 1);
		bot_header_layout.setSeparatorSize(1, 1);
	}
	
	function init_bot_header_layout_ribbon(){
		ribbon = new dhtmlXRibbon({
			parent : "div_bot_header_layout_ribbon"
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
// 			        		            , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
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
				
			} else if (itemId == "excel_grid"){
				$erp.exportGridToExcel({
		    		"grid" : bot_header_layout_grid
					, "fileName" : "예비바코드목록"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			} else if (itemId == "excelForm_grid"){
				$erp.exportGridToExcel({
					"grid" : bot_header_layout_grid
					, "fileName" : "예비바코드 작성양식"
					, "isOnlyEssentialColumn" : false
					, "excludeColumnIdList" : ['NO','SELECT','REMK']
					, "isIncludeHidden" : true
					, "isExcludeGridData" : true
				});
			} else if (itemId == "excel_grid_upload"){
				var convertModuleUrl = ""; //엑셀로 컨버트 하는 모듈을 다른것을 사용하고자 할때만 사용
		    	var uploadFileLimitCount = 1; //파일 업로드 개수 제한
		    	var onUploadFile = function(files, uploadData, toGrid){
					$erp.uploadDataParse(this, files, uploadData, toGrid, "RES_BCD_12", "add", [], ["RES_BCD_12"]);
				}
		    	var onUploadComplete = function(uploadedFileInfoList, toGrid, result){
		    		loadRESBCD(result);
		    	}
		    	var onBeforeFileAdd = function(file){};
		    	var onBeforeClear = function(){};
		 		$erp.excelUploadPopup(bot_header_layout_grid, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			
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
			searchErpHeaderGrid();
		}
		else
		searchErpHeaderGrid();
	}
	
	function searchErpHeaderGrid() {
		var dataObj = $erp.dataSerialize("tb_search");
				var url = "/sis/standardInfo/goods/getresbarcodeHeaderList.do";
				var send_data = $erp.unionObjArray([null,dataObj]);
				console.log(send_data);
				var if_success = function(data){
					$erp.clearDhtmlXGrid(bot_header_layout_grid); //기존데이터 삭제
					$erp.clearDhtmlXGrid(bot_detail_layout_grid);
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(bot_header_layout_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						bot_header_layout_grid.parse(data.gridDataList,'js');
						
						$erp.setDhtmlXGridFooterRowCount(bot_header_layout_grid);
					}
				}
				
				var if_error = function(){
					
				}
				
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);

	}
	
	function init_bot_header_layout_grid() {
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Header_Columns = [
		                    {id : "NO", label:["순번"], type : "cntr", width : "50", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "SELECT", label : ["선택"], type : "ra", width : "50", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "RES_BCD_12", label:["바코드"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
		                    , {id : "BCD_STATE", label:["사용여부"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["USE_CD", "YN"]}
		                    , {id : "LOCK_YN", label:["잠금여부"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "REMK", label:["비고"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
		                    ];
		
		bot_header_layout_grid = new dhtmlXGridObject({
			parent: "div_bot_header_layout_grid"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Header_Columns
		});
		$erp.initGrid(bot_header_layout_grid,{multiSelect : true});
		
		bot_header_layout_grid.attachEvent("onEndPaste", function(result){
			loadRESBCD(result);
	    });
		
		
		<%-- 라디오 버튼 클릭 이벤트 --%>
		bot_header_layout_grid.attachEvent("onCheck", function(rId,cInd){
			if(cInd == this.getColIndexById("SELECT")){
				/* var USED_LOG = chkUSED_LOG.isItemChecked("chkUSED_LOG")? 'Y' : 'N';
				console.log("chkUSED_LOG : " + chkUSED_LOG); */
				var LOCK_YN = bot_header_layout_grid.cells(rId, bot_header_layout_grid.getColIndexById("LOCK_YN")).getValue();
				console.log("LOCK_YN : " + LOCK_YN);
				if(LOCK_YN == "Y") {
					$erp.alertMessage({
						"alertMessage" : "잠금 상태",
						"alertType" : "alert",
						"isAjax" : false
					});
					total_layout.progressOff();
					$erp.clearDhtmlXGrid(bot_detail_layout_grid);
				} else
				searchDetailGrid();
			}
		 });
	}
	
	function searchDetailGrid() {
		var selectedRowId = bot_header_layout_grid.getCheckedRows(bot_header_layout_grid.getColIndexById("SELECT"));
		//var BCD_MS_TYPE = bot_header_layout_grid.cells(selectedRowId, bot_header_layout_grid.getColIndexById("BCD_MS_TYPE")).getValue();
		var RES_BCD_12 = bot_header_layout_grid.cells(selectedRowId, bot_header_layout_grid.getColIndexById("RES_BCD_12")).getValue();
		var BCD_STATE = bot_header_layout_grid.cells(selectedRowId, bot_header_layout_grid.getColIndexById("BCD_STATE")).getValue();
		
		total_layout.progressOn();
		$.ajax({
			url : "/sis/standardInfo/goods/getresbarcodeDetailList.do"
			,data : {
						"RES_BCD_12"	: RES_BCD_12
						, "BCD_STATE"	: BCD_STATE
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				if(data.isError){
					total_layout.progressOff();
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(bot_detail_layout_grid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
								bot_detail_layout_grid
							, '<spring:message code="grid.noSearchData" />'
						);
						total_layout.progressOff();
					} else {
						bot_detail_layout_grid.parse(gridDataList, 'js');
						total_layout.progressOff();
					}
				}
				$erp.setDhtmlXGridFooterRowCount(bot_detail_layout_grid);	//현재 행 수 계산
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function init_bot_detial_layout() {
		bot_detial_layout = new dhtmlXLayoutObject({
			parent : "div_bot_detail_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "버튼영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "그리드영역", header:false, fix_size : [true, true]}
			]
		});
		bot_detial_layout.cells("a").attachObject("div_bot_detail_layout_ribbon");
		bot_detial_layout.cells("a").setHeight(40);
		bot_detial_layout.cells("b").attachObject("div_bot_detail_layout_grid");
		
		bot_detial_layout.setSeparatorSize(0, 1);
		bot_detial_layout.setSeparatorSize(1, 1);
	}
	
	function init_bot_detail_layout_ribbon() {
		detail_ribbon = new dhtmlXRibbon({
			parent : "div_bot_detail_layout_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
				           {
				        	   type : "block"
				        	   , mode : 'rows'
			        		   , list : [
//			        		             {id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 			        		             {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
// 			        		             , {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
//			        		             , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
			        		             {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true, unused : false}
//			        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
										]
				           }							
				           ]
		});
		detail_ribbon.attachEvent("onClick", function(itemId, bId){
			/* 헤더 영역 조회 및 row 선택 후 클릭 가능 */
			var gridRowCount = bot_header_layout_grid.getRowsNum();
				for(var i = 0; i < gridRowCount; i++){
					var rId = bot_header_layout_grid.getRowId(i);
					var button_validate = bot_header_layout_grid.cells(rId, bot_header_layout_grid.getColIndexById("SELECT")).getValue();
					if(button_validate == 1) {
					
					if(itemId == "search_grid"){
					
					} else if (itemId == "add_grid"){
								$erp.alertMessage({
			            			"alertMessage" : "준비중입니다.",
									"alertType" : "alert",
									"isAjax" : false
								});
					} else if (itemId == "delete_grid"){
						$erp.alertMessage({
			            	"alertMessage" : "준비중입니다.",
							"alertType" : "alert",
							"isAjax" : false
			            });
					} else if (itemId == "save_grid"){
						$erp.alertMessage({
			            	"alertMessage" : "준비중입니다.",
							"alertType" : "alert",
							"isAjax" : false
			            });
					} else if (itemId == "excel_grid"){
						$erp.exportGridToExcel({
				    		"grid" : bot_detail_layout_grid
							, "fileName" : "예비바코드 상세목록"
							, "isOnlyEssentialColumn" : true
							, "excludeColumnIdList" : []
							, "isIncludeHidden" : false
							, "isExcludeGridData" : false
						});
					} else if (itemId == "print_grid"){
						
					}
					return false;
					}
				}
				$erp.alertMessage({
						"alertMessage" : "[바코드 목록]에서 선택 후 이용 가능합니다."
						, "alertType" : "alert"
						, "isAjax" : false
				});
		});
	}
	
	function init_bot_detail_layout_grid() {
		//"#text_filter" "#rspan"
		var grid_Detail_Columns = [
		                    {id : "NO", label:["순번", "#rspan"], type : "cntr", width : "50", sort : "int", align : "center", isHidden : false, isEssential : false}
//		                    , {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
							, {id : "RES_BCD_12", label:["예비바코드12", "#rspan"], type : "ro", width : "100", sort : "str", align : "left", isHidden : true, isEssential : true}
							, {id : "RES_BCD_13", label:["예비바코드13", "#rspan"], type : "ro", width : "150", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "RES_BCD_BOX", label:["박스바코드14", "#rspan"], type : "ro", width : "150", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "BCD_MS_TYPE", label:["모자구분", "#rspan"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, isDisabled : true, commonCode : "BCD_MS_TYPE"}
							, {id : "STRT_DATE", label:["적용시작일", "#rspan"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "END_DATE", label:["적용종료일", "#rspan"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "RES_BCD_12", label:["제조사코드", "#rspan"], type : "ro", width : "100", sort : "str", align : "left", isHidden : true, isEssential : true}
							, {id : "CUSTMR_NM", label:["제조사명", "#rspan"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "GRUP_TYPE", label:["분류그룹", "#rspan"], type : "combo", width : "140", sort : "str", align : "center", isHidden : false, isEssential : true, isDisabled : true, commonCode : "RES_BCD_GRUP"}
							, {id : "BCD_STATE", label:["사용상태", "#rspan"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, isDisabled : true, commonCode : "BCD_STATE"}
							, {id : "GOODS_NO", label:["상품번호", "#rspan"], type : "ro", width : "100", sort : "str", align : "left", isHidden : true, isEssential : true}
							, {id : "GOODS_NM", label:["상품명", "#rspan"], type : "ro", width : "200", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "DIMEN_NM", label:["규격명", "#rspan"], type : "ro", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true}
							, {id : "UNIT_QTY", label:["입수량", "#rspan"], type : "ro", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true}
		                    ];
		
		bot_detail_layout_grid = new dhtmlXGridObject({
			parent: "div_bot_detail_layout_grid"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Detail_Columns
		});
		$erp.initGrid(bot_detail_layout_grid,{multiSelect : true});
		
		/* 디테일 로우 더블 클릭시   */
	}
	//requestAddRowCount						//아무런 처리없이 추가 요청한 데이터 초기 로우수
	//newAddRowDataList							//새로 추가된 로우 데이타 리스트
	//standardColumnValue_indexAndRowId_obj		//기준 컬럼의 값을 key, [인덱스,로우아이디]를 value 로 가진 객체
	//insertedRowIndexList						//로우 상태가 inserted 인 로우인덱스 리스트
	//editableColumnIdListOfInsertedRows		//로우 상태가 inserted 인 로우의 수정가능한 컬럼 Id 리스트
	//notEditableColumnIdListOfInsertedRows		//로우 상태가 inserted 인 로우의 수정불가능한 컬럼 Id 리스트
	//duplicationCount_in_toGridDataList		//toGrid 에 추가중 발생한 중복 데이터 개수
	function loadRESBCD(result){
// 		var loadRESBCDList = [];
		var data;
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];
			RES_BCD_LIST_STRING += data["RES_BCD_12"] + ","
// 			loadRESBCDList.push(data["RES_BCD_12"]);
		}
		
		var url = "/sis/standardInfo/goods/getRESBCDInfo.do";
// 		var send_data = {"loadRESBCDList" : loadRESBCDList};
		var send_data = {"RES_BCD_LIST_STRING" : RES_BCD_LIST_STRING};
		
		console.log(send_data);
		var if_success = function(data){
			var gridDataList = data.gridDataList;
			console.log(gridDataList);
			for(var index in gridDataList){
				bot_header_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["RES_BCD_12"]][1], bot_header_layout_grid.getColIndexById("RES_BCD_12")).setValue(gridDataList[index]["RES_BCD_12"]);
// 				bot_header_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["RES_BCD_12"]][1], bot_header_layout_grid.getColIndexById("BCD_STATE")).setValue(gridDataList[index]["BCD_STATE"]);
//				bot_header_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["RES_BCD_12"]][1], bot_header_layout_grid.getColIndexById("LOCK_YN")).setValue('N');
//				bot_header_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["RES_BCD_12"]][1], bot_header_layout_grid.getColIndexById("USE_YN")).setValue("Y");,'BCD_STATE','LOCK_YN'
				result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["RES_BCD_12"]].push("로드완료");
			} 
			
// 			var notExistList = [];
// 			var value;
// 			var state;
// 			var dp = bot_header_layout_grid.getDataProcessor();
// 			for(var index in result.newAddRowDataList){
// 				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["RES_BCD_12"]];
// 				state = dp.getState(value[1]);
// 				if(value.length == 2 && state == "inserted"){
// 					notExistList.push(value[0]);
// 				}
// 			}
			
// 			$erp.deleteGridRows(bot_header_layout_grid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
// 			$erp.alertMessage({
// 				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>/* [무효  : " + notExistList.length + "개]<br/> */[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
// 				"alertType" : "alert",
// 				"isAjax" : false
// 			});
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>[신규 : " + (result.newAddRowDataList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			if(bot_header_layout_grid.getRowsNum() == 0){
				ribbon.callEvent("onClick",["search_grid"]);
				return;
			}
			
			$erp.setDhtmlXGridFooterRowCount(bot_header_layout_grid); // 현재 행수 계산
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
</script>
</head>
<body>
	<div id="div_top_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_top_layout_search" class="div_common_contents_full_size">
			<table id="tb_search" class="table">
				<colgroup>
					<col width="100px"/>
					<col width="175px"/>
					<col width="100px"/>
					<col width="100px"/>
					<col width="100px"/>
					<col width="100px"/>
					<col width="100px"/>
					<col width="100px"/>
					<col width="100px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th colspan="1">바코드 검색</th>
					<td colspan="1"><input type="text" id="txtBCD_WORD" name="KEY_WORD" maxlength="12" class="input_common" style="width:150px;height:17px" onkeydown="$erp.onEnterKeyDown(event, isSearchValidate);"></td>
					<th colspan="1">사용 상태</th>
					<td colspan="1"><div id="cmbBCD_STATE"></div></td>
					<td colspan="1"><div id="chkLOCK"></div></td>
					<td colspan="3"></td>
				</tr>
				<tr>
					<th colspan="1">제조사 검색</th>
					<td colspan="1"><input type="text" id="txtCUSTMR_WORD" name="KEY_WORD" maxlength="20" onkeydown="$erp.onEnterKeyDown(event, isSearchValidate);" style="width:150px;height:17px"></td>
					<th colspan="1">분류 그룹</th>
					<td colspan="2"><div id="cmbGRUP_TYPE"></div></td>
					<td colspan="5"></td>
				</tr>	
			</table>
		</div>
	</div>
	
	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bot_header_layout" class="div_grid_full_size" style="display:none"></div>
	<div id="div_bot_header_layout_ribbon" class="div_grid_full_size" style="display:none"></div>
	<div id="div_bot_header_layout_grid" class="div_grid_full_size" style="display:none"></div>
	
	<div id="div_bot_detail_layout" class="div_grid_full_size" style="display:none"></div>
	<div id="div_bot_detail_layout_ribbon" class="div_grid_full_size" style="display:none"></div>
	<div id="div_bot_detail_layout_grid" class="div_grid_full_size" style="display:none"></div>
	
	
	
</body>
</html>