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
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		
		■ cmbORGN_CD : Object / 직영점선택구분 DhtmlXComboMulti (CODE : ORGN_CD / MK)
		■ cmbAPPLY_STATE : Object / 사용여부 DhtmlXCombo (CODE : APPLY_STATE)
	--%>
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_orgn_type = "PS,CS";
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	
	var cmbORGN_CD;
	var cmbAPPLY_STATE;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0, 4);
	var thisMonth = today.substring(4, 6);
	var thisDay = today.substring(6, 8);
// 	var fromDate = thisYear + "-" + thisMonth + "-01";
	var toDate = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		
// 		document.getElementById("searchFromDate").value=fromDate;
		document.getElementById("searchDate").value=toDate;
		
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false, fix_size : [true, true]}
				, {id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				, {id: "c", text: "그리드영역", header:false, fix_size : [true, true]}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						 {id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
						//,{id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
						//,{id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						//,{id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
						,{id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
						//,{id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpGrid"){
				searchErpGrid();
			} else if (itemId == "add_erpGrid"){
			} else if (itemId == "delete_erpGrid"){
		    } else if (itemId == "save_erpGrid"){
		    } else if (itemId == "excel_erpGrid"){
		    	$erp.exportGridToExcel({
		    		"grid" : erpGrid
					, "fileName" : "가격변경예정"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
		    } else if (itemId == "print_erpGrid"){
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "ORGN_CD", label:["대상직영점", "#rspan"], type: "combo", width: "77", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : "ORGN_CD", isDisabled : true}
			,{id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "75", sort : "str", align : "center", isHidden : false, isEssential : false}
			,{id : "BCD_NM", label:["상품명(바코드)", "#text_filter"], type: "ro", width: "450", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "DIMEN_NM", label:["상품규격", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "CHG_TITLE", label : ["가격변경제목", "#text_filter"], type : "ro", width : "260", sort : "str", align : "left", isHidden : false, isEssential : true}
			,{id : "STRT_DATE", label : ["적용일자", "#rspan"], type : "ro", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			,{id : "STRT_TIME_HH", label : ["적용시각", "시"], type : "combo", width : "70", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "HOUR", isDisabled : true}
			,{id : "STRT_TIME_MM", label : ["#cspan", "분"], type : "combo", width : "70", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "MINUTE", isDisabled : true}
			,{id : "APPLY_STATE", label : ["적용상태", "#select_filter"], type : "combo", width : "97", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "APPLY_STATE", isDisabled : true}
			,{id : "B_PUR_PRICE", label:["현재", "매입가"], type: "ron", width: "70", sort : "int", align : "right", isHidden : false, isEssential : false, isDataColumn : true, numberFormat : "0,000"}
			,{id : "B_SALE_PRICE", label:["#cspan", "판매가"], type: "ron", width: "70", sort : "int", align : "right", isHidden : false, isEssential : false, isDataColumn : true, numberFormat : "0,000"}
			,{id : "A_PUR_PRICE", label:["예정", "매입가"], type: "ron", width: "70", sort : "int", align : "right", isHidden : false, isEssential : false, isDataColumn : true, numberFormat : "0,000"}
			,{id : "A_SALE_PRICE", label:["#cspan", "판매가"], type: "ron", width: "70", sort : "int", align : "right", isHidden : false, isEssential : false, isDataColumn : true, numberFormat : "0,000"}
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
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var search_date = $("#searchDate").val();
		
		if($erp.isEmpty(search_date)||$erp.isEmpty(search_date)){
			isValidated = false;
			alertMessage = "error.common.date.empty3";
			alertCode = "-1";
			$("#searchDate").focus();
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		if(!isSearchValidate()){
			return;
		}
		
		erpLayout.progressOn();
		
		var search_date = $("#searchDate").val();
// 		var search_from_date = $("#searchFromDate").val();
		var key_word = $("#txtKEY_WORD").val();
		var orgn_cd = cmbORGN_CD.getSelectedValue();
		var apply_state = cmbAPPLY_STATE.getSelectedValue();
		
		$.ajax({
			url : "/sis/price/getPriceScheduleList.do"
			,data : {
				"search_date" : search_date
// 				,"search_from_date" : search_from_date
				,"key_word" : key_word
				,"orgn_cd" : orgn_cd
				,"apply_state" : apply_state
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
						
						/* 
						var allRowIds = erpGrid.getAllRowIds();
						var allRowArray = allRowIds.split(",");
						for(var i=0; i<allRowArray.length; i++){
							if(erpGrid.cells(allRowArray[i],erpGrid.getColIndexById("GOODS_STATE")).getValue() == "N"){
								erpGrid.setRowTextStyle(allRowArray[i],"opacity:0.3;");
							}
						} */
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		var searchable = 1;
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",")
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "ALL"){
			searchable = 2;
			}
		}
		if(searchable == 1 ){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : ""}]), 120, "모두조회", false, LUI.LUI_orgn_cd);
		}else if(searchable == 2){
			cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","","","","","MK"], 120, "모두조회", false, LUI.LUI_orgn_cd);
		}
		
		cmbAPPLY_STATE = $erp.getDhtmlXComboCommonCode("cmbAPPLY_STATE", "APPLY_STATE", "APPLY_STATE", 120, "모두조회", false, "1");
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="75px">
				<col width="110px">
				<col width="75px">
				<col width="140px">
				<col width="85px">
				<col width="140px">
				<col width="75px">
				<col width="*">
			</colgroup>
			<tr>
				<th>조회일자</th>
<!-- 				<td><input type="text" id="searchFromDate" name="searchFromDate" class="input_common input_calendar input_essential" maxlength="505"> -->
<!-- 				~ -->
				<td><input type="text" id="searchDate" name="searchDate" class="input_common input_calendar input_essential" maxlength="505"></td>
				<th>검색어</th>
				<td>
					<input type="text" id="txtKEY_WORD" name="KEY_WORD" class="input_common" maxlength="10" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid);">
				</td>
				<th>조직명</th>
				<td><div id="cmbORGN_CD"></div></td>
				<th>적용상태</th>
				<td><div id="cmbAPPLY_STATE"></div></td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>