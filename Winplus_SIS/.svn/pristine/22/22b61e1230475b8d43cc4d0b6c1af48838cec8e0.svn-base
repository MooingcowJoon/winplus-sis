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
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		//현재일 전후 1개월간의 데이터 자동조회 추가필요
	});
	
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "조회조건영역", header: false}
				, {id: "b", text: "리본버튼영역", header: false, fix_size:[true,true]}
				, {id: "c", text: "그리드영역", header: false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1,0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
		});
	}
	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	$erp.alertMessage({
					"alertMessage" : "준비 중 입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
		    	//SearchErpGrid();
		    } else if(itemId == "delete_erpGrid"){
		    	DeleteErpGrid();
		    } else if(itemId == "excel_erpGrid"){
		    	$erp.exportGridToExcel({
		    		"grid" : erpGrid
					, "fileName" : "매입청구서조회(재고)"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
		    }
		});
	}
	
	
	function initErpGrid() {
		erpGridColumns = [ //id값 변경필수!
              {id : "index", label:["No"], type: "ro", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "30", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "goods_code", label:["일자-번호"], type: "ro", width: "160", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_spec", label:["거래처명"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["공급가액"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["부가세"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["합계"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["내역보기"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
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
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
			
		erpGrid.attachEvent("onRowSelect", function(rId){
				
		}); 
	}
	
	function SearchErpGrid() {
		var radio_all = document.getElementById("purchase_bill_status_all").checked;
		var radio_uncheck = document.getElementById("purchase_bill_status_uncheck").checked;;
		var radio_check = document.getElementById("purchase_bill_status_check").checked;;
		var result_radio;
		
		if(radio_all == true){
			result_radio = "all";
		} else if(radio_uncheck == true){
			result_radio = "uncheck";
		} else {
			result_radio = "check";
		}
		
		$.ajax({
			url: "" //수정필요
			, data: {
				"result_radio" : result_radio
			}
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
								erpGrid
							,  '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
				erpLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		}); 
	}
	
	function DeleteErpGrid(){
		var gridRowCount = erpGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		
		
		var deleteRowIdArray = [];
		var check = "";
		
		if(gridRowCount == ""){
			$erp.alertMessage({
				"alertMessage" : "info.common.noDataSearch"
				, "alertCode" : null
				, "alertType" : "info"
			});
			return;
		}
		
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
		
		var callbackFunction = function(){
			for(var j = 0; j < deleteRowIdArray.length; j++){
				erpGrid.deleteRow(deleteRowIdArray[j]);
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpGrid);
			//SaveErpGrid();
		}

		$erp.confirmMessage({
			"alertMessage" : "선택하신 매입청구서를 정말 삭제하시겠습니까?"
			, "alertCode" : ""
			, "alertType" : alert
			, "alertCallbackFn" : callbackFunction
		});
	}
	
	function SaveErpGrid(){
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);
		$.ajax({
			url : ""
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
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
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_price_data" class="tb_erp_common">
			<colgroup>
				<col width ="100px" />
				<col width ="*" />
			</colgroup>
			<tr>
				<th>상 태</th>
				<td>
					<input type="radio" id="purchase_bill_status_all" name="purchase_bill_status" value="all" checked/> 전체
					<input type="radio" id="purchase_bill_status_uncheck" name="purchase_bill_status" value="uncheck"/> 미확인
					<input type="radio" id="purchase_bill_status_check" name="purchase_bill_status" value="check"/> 확인
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>