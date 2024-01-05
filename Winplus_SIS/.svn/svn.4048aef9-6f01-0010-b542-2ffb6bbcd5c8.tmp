<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
LUI.exclude_auth_cd = "ALL,1,2,3,4";
LUI.exclude_orgn_type = "CT,OT,PM,PS,CS";
<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 메뉴별화면 조회 DhtmlXGrid
		■ erpGridColumns : Array / erpGrid DhtmlXGrid Header
		■ erpGridDataProcessor : Object/ erpGridDataProcessor DhtmlXDataProcessor
		■ erpDetailGridDataProcessor : Object/ erpGridDataProcessor DhtmlXDataProcessor
		
		■ erpDetailSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpDetailRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpDetailGrid : Object / 화면 조회 DhtmlXGrid
		■ erpDetailGridColumns : Array / erpDetailGrid DhtmlXGrid Header
		■ erpDetailGridDataProcessor : Object/ erpDetailGrid DhtmlXDataProcessor
		
	--%>
	
	var erpLayout;
	var erpSubLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	
	var erpDetailSubLayout;
	var erpDetailGrid;
	var erpDetailGridColumns;
	var cmbORGN_CD;
	var erpGidDataProcessor;
	var erpDetailGridDataProcessor;

	var cmbSearch;
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	var selected_orgn_cd;
	var selected_ord_cd;
	var selected_ord_date;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		
		initErpLayout();
		initDhtmlXCombo();
		
		initErpSubLayout();
		initErpRibbon();
		initErpGrid();
		
		initErpDetailSubLayout();
		initErpDetailGrid();
		
		document.getElementById("todayDate").value=today;
		
		$erp.asyncObjAllOnCreated(function(){
			searchErpGrid();
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4J"
			, cells: [
				{id: "a", text: "점포선택영역", header:false}
				, {id: "b", text: "리본 영역", header:false}
				, {id: "c", text: "판매 목록", header:true}
				, {id: "d", text: "판매 상세 목록", header:true}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_select_combo");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_sub_layout");
		erpLayout.cells("c").setWidth(620);
		erpLayout.cells("d").attachObject("div_erp_detail_sub_layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpSubLayout.setSizes();
			erpDetailSubLayout.setSizes();
			erpGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%--
	**********************************************************************
	* ※ Master 영역
	**********************************************************************
	--%>	
	
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
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					 {id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					 , {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchErpGrid();
			} else if(itemId == "excel_erpGrid") {
				$erp.exportDhtmlXGridExcel({
				     "grid" : erpGrid
				   , "fileName" : "판매현황(실시간)"
				   , "isForm" : false
				   , "excludeColumn" : ["NO"]
				   , "emptyDown" : false
				});
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["순번", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}  
			, {id : "ORGN_CD", label:["조직명", "#rspan"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false, isDisable : true, commonCode : "ORGN_CD"}
			, {id : "ORD_DATE_TIME", label:["판매시간", "#rspan"], type: "ed", width: "90", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "POS_NO", label:["POS번호", "#text_filter"], type: "ed", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "BILL_NO", label:["영수증번호", "#text_filter"], type: "ed", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "SALE_TYPE", label:["판매유형", "#select_filter"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : false,commonCode:["POS_SALE_KIND"], isDisabled : true}
			, {id : "REG_TYPE", label:["상세유형", "#select_filter"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : false,commonCode:["SALE_REG_TYPE"], isDisabled : true}
			, {id : "SALE_AMT", label:["판매금액", "#rspan"], type: "edn", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"} 
			, {id : "UNION_CORP_MEM", label:["상호명[회원명]", "#text_filter"], type: "ed", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEM_NO", label:["회원번호", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "MEM_NM", label:["회원명", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "ORD_CD", label:["거래코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
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
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		
		erpGrid.attachEvent("onRowSelect", function(rId){
			var paramData = {};
			paramData["ORGN_CD"] = erpGrid.cells(rId, erpGrid.getColIndexById("ORGN_CD")).getValue();
			paramData["ORD_CD"] = erpGrid.cells(rId, erpGrid.getColIndexById("ORD_CD")).getValue();
			searchErpDetailGrid(paramData);
		});

		erpGrid.attachEvent("onCellChanged", function (rowId,columnIdx,newValue){
			if(erpGrid.getColumnId(columnIdx) == "SALE_TYPE"){
				if(erpGrid.cells(rowId, columnIdx).getValue() == "1"){//사내소비 보라
					erpGrid.setRowColor(rowId,"#E7C6EC");
					//erpGrid.setRowTextStyle(rowId,"background-color:#FAF9BA");
				}else if(erpGrid.cells(rowId, columnIdx).getValue() == "2"){//비매출 회색
					erpGrid.setRowColor(rowId,"#CCCCCC");
				}//E7C6EC DFC0E4 EAD0F4
			}
			if(erpGrid.getColumnId(columnIdx) == "REG_TYPE"){
				if(erpGrid.cells(rowId, columnIdx).getValue() == "S02"){//반품 빨강
					erpGrid.setRowColor(rowId,"#FAE0D4");
				}
			}
		});
	}
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		var ORGN_DIV_CD = cmbORGN_DIV_CD.getSelectedValue();
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		var POS_NO = cmbPOS_NO.getSelectedValue();
		var ORD_DATE = document.getElementById("todayDate").value;
		erpLayout.progressOn();
		$.ajax({
				url: "/sis/sales/getSalesByRealtimeList.do"
				, data : {
					"ORGN_DIV_CD" : ORGN_DIV_CD
					,"ORGN_CD" : ORGN_CD
					,"POS_NO" : POS_NO
					,"ORD_DATE" : ORD_DATE
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpGrid);
						$erp.clearDhtmlXGrid(erpDetailGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpGrid
								, '<spring:message code="grid.noSearchData" />'
							);
						}else {
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
	
	<%-- erpGrid 조회 Function 끝--%>

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
	
	<%-- ■ erpDetailGrid 관련 Function 시작 --%>	
	<%-- erpDetailGrid 초기화 Function --%>	
	function initErpDetailGrid(){
		erpDetailGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "320", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "SALE_PRICE", label:["기준단가", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "SALE_QTY", label:["수량", "#rspan"], type: "ro", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true}
			, {id : "SALE_AMT", label:["금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "DC_AMT", label:["할인", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "ORGN_CD", label:["점포코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
		];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpDetailGridColumns
		});
		
		$erp.attachDhtmlXGridFooterSummary(erpDetailGrid
				, ["SALE_QTY","SALE_AMT","DC_AMT"]
				,1
				,"합계");
		erpDetailGrid.attachEvent("onKeyPress",onDetailKeyPressed);
		erpDetailGrid.enableBlockSelection();
		erpDetailGrid.enableDistributedParsing(true, 100, 50);
		erpDetailGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpDetailGrid);
		$erp.initGridComboCell(erpDetailGrid);
		$erp.attachDhtmlXGridFooterPaging(erpDetailGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpDetailGrid, '<spring:message code="grid.allRowCount" />');
		
		erpDetailGridDataProcessor = new dataProcessor();
		erpDetailGridDataProcessor.init(erpDetailGrid);
		erpDetailGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpDetailGrid);
	}
	<%-- ■ erpDetailGrid 관련 Function 끝 --%>
	
	<%-- erpDetailGrid 조회 Function --%>
	function searchErpDetailGrid(paramData){
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/sales/getSalesByRealtimeDetailList.do"
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
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
				$erp.setDhtmlXGridFooterSummary(erpDetailGrid
						,["SALE_QTY","SALE_AMT","DC_AMT"]
						,1
						,"합계");
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- erpDetailGrid 조회 Function 끝--%>
	<%-- onKeyPressed 판매내역Grid_Keypressed Function --%>
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
	
	<%-- onDetailKeyPressed 판매detail내역Grid_Keypressed Function --%>
	function onDetailKeyPressed(code,ctrl,shift){
			if(code==67&&ctrl){
				erpDetailGrid.setCSVDelimiter("\t");
				erpDetailGrid.copyBlockToClipboard();
			}
			if(code==86&&ctrl){
				erpDetailGrid.setCSVDelimiter("\t");
				erpDetailGrid.pasteBlockFromClipboard();
			}
			
		
			return true;
	}
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 160, "AllOrOne", false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 110, "AllOrOne", false, LUI.LUI_orgn_cd, function(){
				cmbPOS_NO = $erp.getDhtmlXComboTableCode("cmbPOS_NO", "POS_NO", "/sis/code/getPosNoList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}, {ORGN_CD : cmbORGN_CD.getSelectedValue()}]), 100, "AllOrOne", false, "",function(){
					isJump1 = false;
					if(cmbORGN_CD.getSelectedValue() == undefined || cmbORGN_CD.getSelectedValue() == null || cmbORGN_CD.getSelectedValue() == ""){
						cmbPOS_NO.disable();
					}
				});
			});
			var isJump1 = true;
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				isJump1 = true;
				cmbORGN_CD.unSelectOption();
				isJump1 = false;
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null,function(){
					
				});
			});
			cmbORGN_CD.attachEvent("onChange", function(value, text){
				if(!isJump1){
					cmbPOS_NO.unSelectOption();
					cmbPOS_NO.clearAll();
					$erp.setDhtmlXComboTableCodeUseAjax(cmbPOS_NO, "/sis/code/getPosNoList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}, {ORGN_CD : value}]), "AllOrOne", false, null);
					if(value == undefined || value == null || value == ""){
						cmbPOS_NO.disable();
					} else{
						cmbPOS_NO.enable();
					}
				}
			});
		});
	}
</script>
</head>
<body>
	<div id="div_erp_select_combo" class="samyang_div" style="display:none;">
		<div id="div_erp_select_combo_search" class="samyang_div">
		<table id="tb_erp_data" class="table_search">
			<colgroup>
					<col width="60px"/>
					<col width="120px"/>
					<col width="60px"/>
					<col width="180px"/>
					<col width="60px"/>
					<col width="120px"/>
					<col width="60px"/>
					<col width="120px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th>일자</th>
					<td>
						<input type="text" id="todayDate" name="todayDate" class="input_common input_calendar">
					</td>
					<th>법인구분</th>
					<td>
						<div id="cmbORGN_DIV_CD"></div>
					</td>
					<th>조직명</th>
					<td>
						<div id="cmbORGN_CD"></div>
					</td>
					<th>포스 번호</th>
					<td>
						<div id="cmbPOS_NO"></div>
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