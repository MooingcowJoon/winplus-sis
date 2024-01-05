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
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var ORGN_CD;
	
	
	var cmbSearch;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
	});
	
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin: ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "조회조건영역", header: false, height : 45}
				,{id: "b", text: "리본버튼영역", header: false, fix_size:[true,true]}
				,{id: "c", text: "그리드영역", header: false}
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
	
	function initErpRibbon() {
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "add_erpGrid"){
				AddErpGrid();
			} else if(itemId == "search_erpGrid"){
		    	SearchErpGrid();
		    } else if(itemId == "save_erpGrid"){
		    	SaveErpGrid();
		    } else if(itemId == "delete_erpGrid"){
		    	DeleteErpGrid();
		    }
		});
	}
	
	function initErpGrid() {
		erpGridColumns = [ 
              {id : "NO", label:["순번"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
            , {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "30", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_CD", label:["점포코드"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "WORKDATE_SEQNO", label:["작업일시_순번"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "MSG_CD", label:["메시지코드"], type: "ed", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ARGUMENT_CNT", label:["매개변수 개수"], type: "ed", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "ARGUMENT_MASK", label:["매개변수 종류"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true, commonCode: "ARGUMENT_MASK"}
			, {id : "MSG_KIND", label:["메시지 종류"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true, commonCode : "MSG_KIND"}
			, {id : "MSG_KIND_2", label:["메시지 종류2"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true, commonCode : "MSG_ERROR_KIND"}
			, {id : "DISP_FG", label:["출력구분"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true, commonCode : "DISP_FG"}
			, {id : "CONFIRM_FG", label:["확인구분"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true, commonCode : "CONFIRM_FG"}
			, {id : "MSG", label:["메시지"], type: "ed", width: "400", sort : "str", align : "left", isHidden : false, isEssential : true}
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
		
		cmbSearch = $erp.getDhtmlXComboCommonCode("cmbSearch", "cmbSearch", ["ORGN_CD", "MK"], 80, null, false, LUI.LUI_orgn_cd);
	}
	
	function AddErpGrid() {
		var uid = erpGrid.uid();
		erpGrid.addRow(uid);
		erpGrid.selectRow(erpGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	function SearchErpGrid() {
		ORGN_CD = cmbSearch.getSelectedValue();
		erpLayout.progressOn();
		
		$.ajax({
			url : "/common/pos/PosMessageManagement/getPosMessageList.do"
			,data : {
				"ORGN_CD" : ORGN_CD
			}
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
	
	function DeleteErpGrid() {
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
		
		for(var j = 0; j < deleteRowIdArray.length; j++){
			erpGrid.deleteRow(deleteRowIdArray[j]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	function SaveErpGrid() {
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
		
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);
		$.ajax({
			url : "/common/pos/SavePosMessageList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					SearchErpGrid();
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
		<table  id="tb_erp_price_data" class="tb_erp_common">
			<colgroup>
				<col width="100px" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>직 영 점</th>
				<td>
					<div id="cmbSearch"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>