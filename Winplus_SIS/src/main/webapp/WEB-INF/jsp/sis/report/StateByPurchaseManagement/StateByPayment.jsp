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
	var ware_name;
	var custmr_cd;
	var department;
	var project;
	var Add_sign;
	
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
				{id: "a", text: "조회조건영역", header: false, height : 85}
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
		    	SearchErpGrid();
		    } else if(itemId == "excel_erpGrid"){
		    	$erp.exportGridToExcel({
		    		"grid" : erpGrid
					, "fileName" : "지급현황"
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
			, {id : "date", label:["거래처코드"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_code", label:["거래처명"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_spec", label:["기초채무"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["재고매입"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["회계매입"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["지급현금"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["지급어음"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["지급합계"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["기타(할인등)차액"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["잔액"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["수급/지급 예정일"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "goods_bcode", label:["비고"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
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
		searchDateFrom = document.getElementById("searchDateFrom").value;
		searchDateTo = document.getElementById("searchDateTo").value;
		ware_name = document.getElementById("hidWare_CD").value;
		custmr_cd = document.getElementById("hidCustmr_CD").value;
		department = document.getElementById("hidDepartment_CD").value;
		project = document.getElementById("hidProject_CD").value;
		Add_sign = document.getElementById("Add_sign").checked;
		
		$.ajax({
			url: "/sis/report/PurchaseManagement/getStateByPaymentList.do"
			, data: {
				"searchDateFrom" : searchDateFrom
				, "searchDateTo" : searchDateTo
				, "ware_name" : ware_name
				, "custmr_cd" : custmr_cd
				, "department" : department
				, "project" : project
				, "Add_sign" : Add_sign
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
	
	
	<%-- openSearchOrgnTreePopup 부서조회 팝업 열림 Function --%>
	function openSearchOrgnTreePopup() {
		var onComplete = function(){
			var erpPopupWindowsCell = erpPopupWindows.window("openSearchOrgnTreePopup");
			if(erpPopupWindowsCell){
				erpPopupWindowsCell.close(); //검색한 결과 적용 후 부서조회 팝업 닫힘
			}        	
		}
		
		var onConfirm = function(id,nm){
			document.getElementById("hidDepartment_CD").value = id;
			document.getElementById("Department_Name").value = nm;
    	}
		$erp.openSearchOrgnTreePopup(onComplete, onConfirm);
	}
	
	<%-- openSearchCustmrGridPopup 고객사 검색 팝업 열림 Function --%>
	function openSearchCustmrGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "1"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		var onRowSelect = function(id, ind) {			
			custmr_cd = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("hidCustmr_CD").value = custmr_cd;
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
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
				<th>기  타</th>
				<td>
					<input type="checkbox" id="Add_sign" name="Add_sign"/>
					<label for="Add_sign">결재방표시</label>
				</td>
			</tr>
			<tr>
				<th>창 고</th>
				<td>
					<input type="hidden" id="hidWare_CD">
					<input type="text" id="Ware_Name" name="Ware_Name" readonly="readonly" disabled="disabled"/>
					<input type="button" id="Ware_Search" value="검 색" class="input_common_button" onclick=""/>
				</td>
				<th>협력사</th>
				<td>
					<input type="hidden" id="hidCustmr_CD">
					<input type="text" id="Custmr_Name" name="Custmr_Name"  readonly="readonly" disabled="disabled"/>
					<input type="button" id="Custmr_Search" value="검 색" class="input_common_button" onclick="openSearchCustmrGridPopup();"/>
				</td>
			</tr>
			<tr>
				<th>부 서</th>
				<td>
					<input type="hidden" id="hidDepartment_CD">
					<input type="text" id="Department_Name" name="Department_Name"  readonly="readonly" disabled="disabled"/>
					<input type="button" id="department_Search" value="검 색" class="input_common_button" onclick="openSearchOrgnTreePopup();"/>
				</td>
				<th>프로젝트</th>
				<td>
					<input type="hidden" id="hidProject_CD">
					<input type="text" id="Project_Name" name="Project_Name"  readonly="readonly" disabled="disabled"/>
					<input type="button" id="Project_Search" value="검 색" class="input_common_button" onclick=""/>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>