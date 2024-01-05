<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
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
	var erpHeaderGrid;
	
	var erpDetailGridDataProcessor;
	var erpGridDataProcessor;
	
	$(document).ready(function() {
		init_total_layout();
		init_top_layout();
		init_header_mid_layout();
		init_header_layout();
		init_detail_mid_layout();
		init_detail_layout();
	});
	
	
	function init_total_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "5E"
			, cells : [
				{id: "a", text: "검색조건영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "Header리본영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "Header그리드영역", header:false, fix_size : [true, true]}
				,{id: "d", text: "Detail리본영역", header:false, fix_size : [true, true]}
				,{id: "e", text: "Detail그리드영역", header:false, fix_size : [true, true]}
			]
		});
		
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight(40);
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(40);
		total_layout.cells("c").attachObject("div_header_layout_grid");
		total_layout.cells("c").setHeight(250);
		total_layout.cells("d").attachObject("div_detail_layout_ribbon");
		total_layout.cells("d").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		total_layout.cells("e").attachObject("div_detail_layout_grid");
		
		total_layout.setSeparatorSize(1, 1);
		total_layout.setSeparatorSize(2, 1);
		total_layout.setSeparatorSize(3, 2);
		
		<%-- total_layout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(total_layout, function(names){
			erpHeaderGrid.setSizes();
			erpDetailGrid.setSizes();
		});
	}
	
	function init_top_layout() {
		cmbORDER_TYPE = $erp.getDhtmlXComboCommonCode("cmbORDER_TYPE","cmbORDER_TYPE", ["ORDER_TYPE"],110, "모두조회", false);
	}
	
	function init_header_mid_layout(){
		ribbon = new dhtmlXRibbon({
			parent : "div_mid_layout"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpHeaderGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					,{id : "apply_erpHeaderGrid", type : "button", text:'승인 / 취소', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : true}
//					,{id : "delete_erpHeaderGrid", type : "button", text:'취소', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
//					,{id : "excel_erpHeaderGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : true}
// 					, {id : "excel_grid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : true}				
					]}
			]
		});
		
		ribbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpHeaderGrid"){
				isSearchValidate();
			} else if(itemId == "apply_erpHeaderGrid") {
					saveErpGrid(erpHeaderGrid)
			} else if (itemId == "delete_erpHeaderGrid"){
					//saveErpGrid(erpHeaderGrid)
			} else if (itemId == "excel_erpHeaderGrid"){
				$erp.exportGridToExcel({
		    		"grid" : header_layout_grid
					, "fileName" : "판매확정"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			} else if (itemId == "excel_erpHeaderGrid_upload"){
		    }
		});
	}
	
	function init_header_layout(){
		erpHeadrGridColumns = [
			{id : "NO", label:["순번", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox"  , "#rspan"], type: "ch", width: "30", sort : "int", align : "center", isHidden : false}
			, {id : "ORD_TYPE", label:["주문유형", "#rspan"], type: "ro", width: "50", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true}
			, {id : "CUSTMR_CD", label:["주문처코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "CUSTMR_NM", label:["주문처", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "OUT_WARE_CD", label:["출하창고", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD"]}
	
			//		, {id : "ORDER_TYPE", label:["주문유형"], type: "combo", width: "70", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true}
			, {id : "ORD_DATE", label:["거래일시", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "ORD_CD", label:["주문번호", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			
			, {id : "TOT_GOODS_NM", label:["상품명", "#rspan"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : true}
			
			, {id : "SALE_AMT", label:["판매금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat: "0,000"}
			, {id : "SALE_VAT_AMT", label:["부가세액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat: "0,000"}
			, {id : "SALE_TOT_AMT", label:["합계 금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat: "0,000"}

			, {id : "CONF_TYPE", label:["판매확정여부", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "SEND_TYPE", label:["ERP전송여부", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "OLINE_CONF_TYPE", label:["온라인 판매확정여부", "#rspan"], type: "ro", width: "150", sort : "str", align : "center", isHidden : false, isEssential : true}
		
			, {id : "CUSER", label:["생성자", "#rspan"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CDATE"	, label:["생성일", "#rspan"], type : "ro", width : "120", sort : "str", align : "center"}
			, {id : "MUSER", label:["수정자", "#rspan"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "MDATE", label:["수정일", "#rspan"], type : "ro", width : "120", sort : "str", align : "center"}
		];
		
		erpHeaderGrid = new dhtmlXGridObject({
			parent: "div_header_layout_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpHeadrGridColumns
		});
		erpHeaderGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpHeaderGrid);
		$erp.initGridComboCell(erpHeaderGrid);
		$erp.attachDhtmlXGridFooterPaging(erpHeaderGrid, 10);
		$erp.attachDhtmlXGridFooterRowCount(erpHeaderGrid, '<spring:message code="grid.allRowCount" />');
		
		erpHeaderGrid.attachEvent("onRowDblClicked", function(rId){
			var CUSTMR_CD = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("CUSTMR_CD")).getValue();			
			var paramGridData = {};
			paramGridData["ORD_DATE"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORD_DATE")).getValue();
			paramGridData["ORD_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORD_CD")).getValue();
			paramGridData["CUSTMR_CD"] = CUSTMR_CD;
			searchErpDetailGrid(paramGridData);
		});
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpHeaderGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpHeaderGrid);
	}
	
	function init_detail_mid_layout(){
		erpDetailRibbon = new dhtmlXRibbon({
			parent : "div_detail_layout_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}
			]
		});
		
		erpDetailRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "save_erpGrid") {
				saveDetailGrid();
			}
		});
	}
	
	function init_detail_layout(){
		erpDetailGridColumns = [
				  {id : "NO", label:["순번"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
				, {id : "ORD_CD", label:["주문번호"], type : "ro", width : "80", sort : "str", align : "left", isHidden : false, isEssential : true}
				
				, {id : "BCD_CD", label:["바코드"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
				, {id : "BCD_NM", label:["상품명"], type : "ro", width : "250", sort : "str", align : "left", isHidden : false, isEssential : true}
				
				, {id : "PUR_AMT", label:["매입금액"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
				, {id : "SALE_QTY", label:["주문수량"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : false}
				, {id : "SALE_AMT", label:["판매금액"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
				, {id : "SALE_VAT_AMT", label:["부가세액"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
				, {id : "SALE_TOT_AMT", label:["합계금액"], type : "ron", width : "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
				, {id : "CONF_AMT", label:["확정금액"], type : "edn", width : "100", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
				, {id : "CUSTMR_CD", label:["주문처코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : false}
// 				, {id : "SALE_TYPE", label:["판매방식"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
// 				, {id : "GOODS_TYPE", label:["상품유형"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
				];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_detail_layout_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpDetailGridColumns
		});
		$erp.attachDhtmlXGridFooterSummary(erpDetailGrid, [
						"PUR_AMT"
						,"SALE_AMT"
						,"SALE_VAT_AMT"
						,"SALE_QTY"
						,"SALE_TOT_AMT"
						,"CONF_AMT"]
						,1
						,"합계");
		
		erpDetailGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpDetailGrid);
		$erp.initGridComboCell(erpDetailGrid);
		$erp.attachDhtmlXGridFooterPaging(erpDetailGrid, 10);
		$erp.attachDhtmlXGridFooterRowCount(erpDetailGrid, '<spring:message code="grid.allRowCount" />');
		
		erpDetailGridDataProcessor = new dataProcessor();
		erpDetailGridDataProcessor.init(erpDetailGrid);
		erpDetailGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpDetailGrid);
	}
	
	function isSearchValidate(){
		var isValidated = true;
		
		var searchDateFrom = $("#txtDATE_FR").val();
		var searchDateTo = $("#txtDATE_TO").val();
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(searchDateFrom) || $erp.isEmpty(searchDateTo)){
			isValidated = false;
			alertMessage = "error.common.date.empty3";
			alertCode = "-1";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		} else {
			searchHeaderGrid();
		}
	}
	
	function searchHeaderGrid(){
		
		var paramData = {};
		
		var search_date_from = document.getElementById("txtDATE_FR").value;
		var search_date_to = document.getElementById("txtDATE_TO").value;
		var date_from = search_date_from.replace(/\-/g,'');
		var date_to = search_date_to.replace(/\-/g,'');
		paramData["DATE_FR"] = date_from;
		paramData["DATE_TO"] = date_to;
		paramData["ORDER_TYPE"] = cmbORDER_TYPE.getSelectedValue();
		
		if(date_from <= date_to){
			total_layout.progressOn();
			$.ajax({
				url: "/sis/sales/onlinesales/getOnlineFixList.do"
				, data : paramData
				,method : "POST"
					,dataType : "JSON"
					,success : function(data){
						$erp.clearDhtmlXGrid(erpHeaderGrid); //기존데이터 삭제
						init_detail_layout();
						total_layout.progressOff();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						} else {
							var gridDataList = data.gridDataList;
							if($erp.isEmpty(gridDataList)){
								$erp.addDhtmlXGridNoDataPrintRow(
										erpHeaderGrid
									, '<spring:message code="grid.noSearchData" />'
								);
							} else {
								erpHeaderGrid.parse(gridDataList, 'js');
							}
						}
						$erp.setDhtmlXGridFooterRowCount(erpHeaderGrid);
					}, error : function(jqXHR, textStatus, errorThrown){
						total_layout.progressOff();
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
		} else{
			$erp.alertMessage({
				"alertMessage" : "기간이 올바르지 않습니다."
				,"alertCode" : null
				,"alertType" : "alert"
				,"isAjax" : false
				,"alertCallbackFn" : function() {
					document.getElementById("txtDATE_FR").value = $erp.getToday("-");
					document.getElementById("txtDATE_TO").value = $erp.getToday("-");
				}
			});
		}
	}
	
	function searchErpDetailGrid(paramGridData){
		total_layout.progressOn();
		$.ajax({
			url: "/sis/sales/onlinesales/getOnlineFixDetailList.do"
			, data : paramGridData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpDetailGrid, '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpDetailGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
				$erp.setDhtmlXGridFooterSummary(erpDetailGrid
						, [
							"PUR_AMT"
							,"SALE_AMT"
							,"SALE_VAT_AMT"
							,"SALE_QTY"
							,"SALE_TOT_AMT"
							,"CONF_AMT"]
						,1
						,"합계");
				
				total_layout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				total_layout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function saveErpGrid(erpHeaderGrid) {
		if(erpGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		var grid = erpHeaderGrid;
		var CONF_TYPE_LIST ="";
		var ORD_CD_LIST ="";
		var check = 0;
		
		var count = grid.getRowsNum();
		
		for(var j=0;j<count;j++) {
			var rId = grid.getRowId(j);
			var checkvalue = grid.cells(rId,grid.getColIndexById("CHECK")).getValue();
			if(checkvalue == 1){
				check = 1;
			}
		}
		
		var checkedRowIdList = grid.getCheckedRows(grid.getColIndexById("CHECK")).split(",");
		
		if(check == 1) { //체크한 로우
			$erp.confirmMessage({
				"alertMessage" : "판매확정 : 승인/취소 처리하시겠습니까? ",
				"alertType" : "alert",
				"isAjax" : false,
				"alertCallbackFn" : function (){
					total_layout.progressOn();
					
				for(var i in checkedRowIdList){
					var CONF_TYPE = grid.cells(checkedRowIdList[i], grid.getColIndexById("CONF_TYPE")).getValue();
					var ORD_CD = grid.cells(checkedRowIdList[i], grid.getColIndexById("ORD_CD")).getValue();
					var check = grid.cells(checkedRowIdList[i], grid.getColIndexById("CHECK")).getValue();
					CONF_TYPE_LIST += CONF_TYPE + ",";
					ORD_CD_LIST += ORD_CD + ",";
				}
				var data = {
						"CONF_TYPE_LIST" : CONF_TYPE_LIST
						,"ORD_CD_LIST" : ORD_CD_LIST
					};
				
				var data1 = {};
					data1["MUSER"] = "${empSessionDto.emp_no}";
					data1["MPROGRM"] = "OnlineController";
		
					var send_data = $erp.unionObjArray([data,data1]);
						
				$.ajax({
						url : "/sis/sales/onlinesales/saveOnlineFixList.do"
						,data : send_data
						,method : "POST"
						,dataType : "JSON"
						,success : function(data){
							total_layout.progressOff();
							if(data.isError){
								$erp.ajaxErrorMessage(data);
							} else {
								$erp.alertSuccessMesage(function(){
									ribbon.callEvent("onClick", ["search_erpHeaderGrid"]);
								});
							}
						}, error : function(jqXHR, textStatus, errorThrown){
							total_layout.progressOff();
							$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
						}
					});
				}
			});
		} else {
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
				, "alertCallbackFn" : searchHeaderGrid()
			});
		}
	}
	
	function saveDetailGrid() {
		var paramGridData = {};
		var rId = erpHeaderGrid.getSelectedRowId();
		paramGridData["ORD_DATE"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORD_DATE")).getValue();
		paramGridData["ORD_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("ORD_CD")).getValue();
		paramGridData["CUSTMR_CD"] = erpHeaderGrid.cells(rId, erpHeaderGrid.getColIndexById("CUSTMR_CD")).getValue();
		
		if(erpDetailGridDataProcessor.getSyncState()){ //프로세서 상태 검사
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpDetailGrid); //필수 컬럼 검사
		if(validResultMap.isError){
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		var paramData = $erp.serializeDhtmlXGridData(erpDetailGrid);
		
		var CUSTMR_CD_LIST = paramData.CUSTMR_CD;
		var check = 1;
		var custmr_cd
		for(var i in CUSTMR_CD_LIST){
			custmr_cd = CUSTMR_CD_LIST[i]
			if(custmr_cd == "DS00002022"){
				check = -1
			}
		}
		
		if(check == 1){//확정금액 변경 가능 검사
			total_layout.progressOn();
			$.ajax({
				url : "/sis/sales/onlinesales/saveOSFDList.do"
				,data : paramData
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					total_layout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						$erp.alertMessage({
							"alertMessage" : "저장완료",
							"alertType" : "alert",
							"isAjax" : false,
							"alertCallbackFn" : searchErpDetailGrid(paramGridData)
						});
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					total_layout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		} else {
			$erp.alertMessage({
				"alertMessage" : "쿠팡의 확정금액만 변경하실 수 있습니다.",
				"alertType" : "alert",
				"isAjax" : false,
				"alertCallbackFn" : searchErpDetailGrid(paramGridData)
			});
		}
	}
	
</script>
</head>
<body>
<div id="div_top_layout" class="samyang_div" style="display:none">
	<div id="div_top_layout_search" class="samyang_div">
		<table id="tb_search" class="table_search">
				<colgroup>
					<col width="90px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th colspan="1">기 간</th>
					<td colspan="2">
						<input type="text" id="txtDATE_FR" class="input_calendar default_date" data-position="(1)" value="">
						<span style="float: left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO" class="input_calendar default_date" data-position="" value="" style="float: left; margin-left: 6px;">
					</td>
					<th colspan="1">주문유형</th>
					<td colspan="1"><div id="cmbORDER_TYPE"></div></td>
				</tr>
		</table>
	</div>
</div>
	
	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_header_layout_grid" class="div_grid_full_size" style="display:none"></div>
	<div id="div_detail_layout_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_detail_layout_grid" class="div_grid_full_size" style="display:none"></div>
	
</body>
</html>