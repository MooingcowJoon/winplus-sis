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
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	
	var erpLayout;
	var erpRibbon;
	
	var erpSubLayout;
	var erpGrid;
	var erpGridColumns;
	var erpDetailSubLayout;
	var erpDetailGrid;
	var erpDetailGridColumns;
	var cmbPUR_TYPE;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	
	$(document).ready(function() {
		initErpLayout();
		initErpRibbon();
		initErpSubLayout();
		initErpGrid();
		initErpDetailSubLayout();
		initErpDetailGrid();
		document.getElementById("searchDateFrom").value = $erp.getToday("-");
		document.getElementById("searchDateTo").value = $erp.getToday("-");
		
		if("${menuDto.menu_cd}" == "00729"){//센터
			if(LUI.LUI_searchable_auth_cd == "1,3,4"){
				LUI.exclude_orgn_type = "MK";//서부법인에서 음성(온라인)만
			}else{
				LUI.exclude_orgn_type = "";
			}
			LUI.exclude_auth_cd = "All,1,";
			isValidPage = true;
			initDhtmlXCombo();
// 			cmbORGN_DIV_CD.disable();
		}else if("${menuDto.menu_cd}" == "00683"){//직영점
			LUI.exclude_auth_cd = "All,1,2,3,4";
			LUI.exclude_orgn_type = "";
			isValidPage = true;
			initDhtmlXCombo();
		}else{
			isValidPage = false;
			initDhtmlXCombo();
		}
		if(!isValidPage){
			$erp.alertMessage({
				"alertMessage" : "메뉴코드가 변경되어 페이지가 정상 작동하지 않을 수 있습니다. 소스코드를 확인해주세요.",
				"alertCode" : null,
				"alertType" : "error",
				"isAjax" : false
			});
		}
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "4J"
			, cells : [
				{id: "a", text: "검색 조건", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "구매 목록", header: false, fix_size:[true,true], width: 700}
				,{id: "d", text: "구매 상세 목록", header: false, fix_size:[true,true]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight($erp.getTableHeight(2));
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_sub_layout");
		erpLayout.cells("d").attachObject("div_erp_detail_sub_layout");
		
		erpLayout.setSeparatorSize(0, 0);
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpSubLayout.setSizes();
			erpDetailSubLayout.setSizes();
			erpGrid.setSizes();
		});
	}
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : "rows", list : [
					 {id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					,{id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
				]}
			]
		});

		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchErpGrid();
			} else if(itemId == "excel_erpGrid"){
				$erp.exportGridToExcel({
					"grid" : erpDetailGrid
					,"fileName" : "상세구매현황"
					,"isOnlyEssentialColumn" : true
					,"excludeColumnIdList" : []
					,"isIncludeHidden" : true
					,"isExcludeGridData" : false
				});
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpSubLayout 관련 Function 시작 --%>
	<%-- erpSubLayout 초기화 Function --%>
	function initErpSubLayout(){
		erpSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "", header:false}
				]
			, fullScreen : true
		});
		erpSubLayout.cells("a").attachObject("div_erp_grid");
		erpSubLayout.setSeparatorSize(1, 0);
	}
	<%-- ■ erpSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>
	function initErpGrid() {
		erpGridColumns = [
			{id : "NO", label:["순번", "#rspan"], type: "cntr", width: "30", sort : "str", align : "center", isHidden : false, isEssential : false}
			,{id : "ORGN_CD", label:["조직명", "#rspan"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["ORGN_CD"], isDisabled : true}
			,{id : "DATE", label:["일자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}  
			,{id : "TOT_GOODS_NM", label:["상품명", "#rspan"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : true}
			//,{id : "PUR_TYPE", label:["매입구분", "#rspan"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["SLIP_TYPE"], isDisabled : true}
			,{id : "TOT_PUR_TAXA_AMT", label:["과세금액", "#rspan"], type: "ron", width: "75", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			,{id : "TOT_PUR_FREE_AMT", label:["면세금액", "#rspan"], type: "ron", width: "75", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			,{id : "TOT_PAY_SUM_AMT", label:["합계금액", "#rspan"], type: "ron", width: "75", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
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
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		
		<%-- 더블 클릭 이벤트 --%>
		erpGrid.attachEvent("onRowDblClicked", function(rId){
			var paramData = {};
			paramData["ORGN_CD"] = erpGrid.cells(rId,erpGrid.getColIndexById("ORGN_CD")).getValue(); 
			paramData["PUR_DATE"] = erpGrid.cells(rId,erpGrid.getColIndexById("DATE")).getValue().split("-").join("");
			searchErpDetailGrid(paramData);
		});
	}
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		var isValidated = true;
		
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		var searchDateFrom = $("#searchDateFrom").val();
		var searchDateTo = $("#searchDateTo").val();
		
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
			searchDateFrom = searchDateFrom.split("-").join("");
			searchDateTo = searchDateTo.split("-").join("");
			var ORGN_DIV_CD = cmbORGN_DIV_CD.getSelectedValue();
			var ORGN_CD = cmbORGN_CD.getSelectedValue();
			if(Number(searchDateFrom) <= Number(searchDateTo)){
				erpLayout.progressOn();
				$.ajax({
					url : "/sis/report/PurchaseManagement/getPurchaseHeaderStatus.do"
					,data : {
						"searchDateFrom" : searchDateFrom
						,"searchDateTo" : searchDateTo
						,"ORGN_DIV_CD" : ORGN_DIV_CD
						,"ORGN_CD" : ORGN_CD
						,"PUR_TYPE" : cmbPUR_TYPE.getSelectedValue()
					}
					,method : "POST"
					,dataType : "JSON"
					,success : function(data){
						erpLayout.progressOff();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						} else {
							$erp.clearDhtmlXGrid(erpGrid);
							initErpDetailGrid();
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
			} else {
				$erp.alertMessage({
					"alertMessage" : "기간이 올바르지 않습니다."
					,"alertType" : "alert"
					,"isAjax" : false
				});
			}
		}
	}
	
	<%--
	**********************************************************************
	* ※ Detail 영역
	**********************************************************************
	--%>
	<%-- ■ erpDetailSubLayout 관련 Function 시작 --%>
	<%-- erpDetailSubLayout 초기화 Function --%>
	function initErpDetailSubLayout(){
		erpDetailSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_detail_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "", header:false, fix_size : [false, true]}
			]
			, fullScreen : true
		});
		erpDetailSubLayout.cells("a").attachObject("div_erp_detail_grid");
		
		erpDetailSubLayout.setSeparatorSize(1, 0);
	}
	<%-- ■ erpDetailSubLayout 관련 Function 끝 --%>
	
	<%-- erpDetailGrid 초기화 Function --%>
	function initErpDetailGrid() {
		erpDetailGridColumns = [
			{id : "NO", label:["순번", "#rspan"], type: "cntr", width: "50", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "SUPR_CD", label:["거래처코드", "#rspan"], type: "ro", width: "50", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "CUSTMR_NM", label:["거래처명", "#rspan"], type: "ro", width: "50", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "350", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "PUR_PRICE", label:["기준단가", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			,{id : "PUR_QTY", label:["수량", "#rspan"], type: "ro", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true}
			,{id : "PAY_SUM_AMT", label:["금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			,{id : "FIX_AMT", label:["확정금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			];
	
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpDetailGridColumns
		});
		$erp.attachDhtmlXGridFooterSummary(erpDetailGrid
											, ["PUR_QTY","PAY_SUM_AMT","FIX_AMT"]
											,1
											,"합계");
		
		$erp.initGridCustomCell(erpDetailGrid);
		$erp.initGridComboCell(erpDetailGrid);
		$erp.attachDhtmlXGridFooterPaging(erpDetailGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpDetailGrid, '<spring:message code="grid.allRowCount" />');
		$erp.initGridDataColumns(erpDetailGrid);
		
		//groupBy
		erpDetailGrid.attachEvent("onPageChangeCompleted", function(){
			erpDetailSubLayout.progressOn();
			setTimeout(function(){
				gridGroupBy(erpDetailGrid);
				erpDetailSubLayout.progressOff();
			}, 10);
		});
		
		
		erpGrid.enableDistributedParsing(true, 100, 50);
	}
	<%-- ■ erpDetailGrid 관련 Function 끝 --%>
	
	<%-- ■ searchErpDetailGrid 관련 Function 시작 --%>
	function searchErpDetailGrid(paramData) {
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/report/PurchaseManagement/getPurchaseStatusDetailList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpDetailGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
							erpDetailGrid.parse(gridDataList, 'js');
							gridGroupBy();
						}
					}
				$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);	//현재 행 수 계산
				$erp.setDhtmlXGridFooterSummary(erpDetailGrid
												,["PUR_QTY","PAY_SUM_AMT","FIX_AMT"]
												,1
												,"합계");
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function gridGroupBy(){
		erpDetailGrid.groupBy(erpDetailGrid.getColIndexById("CUSTMR_NM"),["#title","#cspan","","#cspan","","","#stat_total","#stat_total"]);
	}
	<%-- ■ searchErpDetailGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>
	function initDhtmlXCombo(){
		cmbPUR_TYPE = $erp.getDhtmlXComboCommonCode("cmbPUR_TYPE", "PUR_TYPE", "SLIP_TYPE", 100, "모두조회", false);
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 100, "AllOrOne", false, LUI.LUI_orgn_cd);
				cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
					cmbORGN_CD.unSelectOption();
					cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			});
		});
	}
	
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="samyang_div" style="display:none">
		<div id="div_table_layout" class="samyang_div">
			<table id="table_search" class="table">
				<colgroup>
					<col width="80px">
					<col width="220px">
					<col width="60px">
					<col width="*">
				</colgroup>
				<tr>
					<th>법인구분</th>
					<td>
						<div id="cmbORGN_DIV_CD"></div>
					</td>
					<th>조직명</th>
					<td>
						<div id=cmbORGN_CD></div>
					</td>
				</tr>
				<tr>
					<th>기간</th>
					<td>
						<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
						<span style="float: left;">&nbsp;~&nbsp;</span>
						<input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
					</td>
					<th>상품유형</th>
					<td>
						<div id="cmbPUR_TYPE"></div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
	<div id="div_erp_detail_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_detail_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_detail_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>