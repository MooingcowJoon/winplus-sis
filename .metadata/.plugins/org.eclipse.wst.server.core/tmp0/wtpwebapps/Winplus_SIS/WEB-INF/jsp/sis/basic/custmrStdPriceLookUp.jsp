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
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchErpGrid();
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["NO"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "GOODS_NO", label:["상품코드"], type: "ro", width: "95", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "BCD_CD", label:["바코드"], type: "ro", width: "110", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "BCD_NM", label:["상품명"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : true}
// 			, {id : "테스트거래처그룹", label:["테스트거래처그룹", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
// 			, {id : "농협신선물류", label:["농협신선물류", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
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
		erpGrid.enableColumnMove(true)
		erpGrid.splitAt(4);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 조회 Function 시작 --%>
	function searchErpGrid(){
		var colCnt = erpGrid.getColumnsNum();
		if(colCnt != 4){
			for(var j = colCnt ; j > 3 ; j--){
				erpGrid.deleteColumn(j);
			}
		}
		
		var custmr_list = [];
		var label;
		var type;
		var width;
		var sort;
		var align;
		var a = cmbCUSTMR_SALE_PRICE.getOptionsCount();
		var A = cmbCUSTMR_SALE_PRICE.getSelectedIndex();
		var colNum;
		if(A == 0){
			for(var i = 1 ; i < a; i++){
				var column_id = "NO,GOODS_NO,BCD_CD,BCD_NM";
				if(i == a-1){
					custmr_list += cmbCUSTMR_SALE_PRICE.getOptionByIndex(i).text;
				}else{
					custmr_list += cmbCUSTMR_SALE_PRICE.getOptionByIndex(i).text + ",";
				}
				colNum = erpGrid.getColumnsNum();
				label = cmbCUSTMR_SALE_PRICE.getOptionByIndex(i).text;
				type = "ron";
				width = 110;
				sort = "int";
				align = "right";
				column_id += "," + custmr_list;
				
				erpGrid.insertColumn(colNum, label, type, width, sort, align);
				erpGrid.setNumberFormat("0,000", colNum);
			}
		}else{
			var column_id = "NO,GOODS_NO,BCD_CD,BCD_NM";
			custmr_list = cmbCUSTMR_SALE_PRICE.getComboText();
			colNum = erpGrid.getColumnsNum();
			label = cmbCUSTMR_SALE_PRICE.getComboText();
			type = "ron";
			width = 110;
			sort = "int";
			align = "right";
			column_id += "," + cmbCUSTMR_SALE_PRICE.getComboText();
			
			erpGrid.insertColumn(colNum, label, type, width, sort, align);
			erpGrid.setNumberFormat("0,000", colNum);
		}
		erpGrid.setColumnIds(column_id);
		
		var paramData = {};
		paramData["SEARCH_WORD"] = document.getElementById("txtSEARCH_WORD").value;
		paramData["STD_PRICE_GRUP"] = cmbCUSTMR_SALE_PRICE.getSelectedValue();
		paramData["USE_YN"] = 'Y';
		paramData["CUSTMR_LIST"] = custmr_list;
		
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/basic/getCustmrStdPriceLookUp.do"
			,data : JSON.stringify(paramData)
			,method : "POST"
			,contentType : "application/json"
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
	
	<%-- dhtmlxCombo 초기화 Function 시작--%>
	function initDhtmlXCombo(){
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
					<col width="*px"/>
				</colgroup>
				<tr>
					<th>거래처기준가그룹</th>
					<td><div id="cmbCUSTMR_SALE_PRICE"></div> </td>
					<th>검색어</th>
					<td><input type="text" id="txtSEARCH_WORD" name="txtSEARCH_WORD" class="input_common" maxlength="500" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid);"></td>
				</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none;"></div>
</body>
</html>