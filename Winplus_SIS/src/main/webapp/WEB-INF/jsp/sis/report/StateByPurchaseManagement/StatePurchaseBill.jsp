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
	var searchDateFrom;
	var searchDateTo;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function() {
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		
		document.getElementById("searchDateFrom").value=todayDate;
		document.getElementById("searchDateTo").value=today;
	});
	
	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "조회조건영역", header: false, height : 105}
				,{id: "b", text: "리본버튼영역", header: false, fix_size:[true,true]}
				,{id: "c", text: "그리드영역", header: false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
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
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	//SearchErpGrid();
		    	$erp.alertMessage({
					"alertMessage" : "준비 중 입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
		    } else if(itemId == "excel_erpGrid"){
		    	$erp.exportGridToExcel({
		    		"grid" : erpGrid
					, "fileName" : "매입청구서현황(재고)"
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
              {id : "index", label:["담당자명"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "date", label:["일자-번호"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_code", label:["거래처명"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_code", label:["공급가액"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_code", label:["부가세"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_code", label:["합계"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_code", label:["내역보기"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
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
	
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_price_data" class="tb_erp_common">
			<colgroup>
				<col width= "80px" />
				<col width= "270px" />
				<col width= "80px" />
				<col width= "340px" />
				<col width= "*" />
			</colgroup>
			<tr>
				<th>기준일자</th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
					 ~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
				</td>
				<th>회계 No</th>
				<td>
					<input type="text" id="Account_No" name="Account_No"/>
				</td>
			</tr>
			<tr>
				<th>부 서</th>
				<td>
					<input type="text" id="department" name="department"/>
					<input type="button" id="department_Search" value="검 색" class="input_common_button" onclick=""/>
				</td>
				<th>프로젝트</th>
				<td>
					<input type="text" id="Project" name="Project"/>
					<input type="button" id="Project_Search" value="검 색" class="input_common_button" onclick=""/>
				</td>
			</tr>
			<tr>
				<th>거래처</th>
				<td>
					<input type="text" id="WareHouse" name="WareHouse"/>
					<input type="button" id="Ware_Search" value="검 색" class="input_common_button" onclick=""/>
				</td>
				<th>부가세유형</th>
				<td>
					<input type="text" id="WareHouse" name="WareHouse"/>
					<input type="button" id="Ware_Search" value="검 색" class="input_common_button" onclick=""/>
				</td>
			</tr>
			<tr>
				<th>상 태</th>
				<td>
					<input type="radio" id="purchase_bill_status" name="purchase_bill_status" value="all"/> 전체
					<input type="radio" id="purchase_bill_status" name="purchase_bill_status" value="uncheck"/> 미확인
					<input type="radio" id="purchase_bill_status" name="purchase_bill_status" value="check"/> 확인
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>