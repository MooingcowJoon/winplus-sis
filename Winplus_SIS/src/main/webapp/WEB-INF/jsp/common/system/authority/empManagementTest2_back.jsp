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
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbUSE_YN : Object / 사용여부 DhtmlXCombo  (CODE : 'YN_CD' / 빈 칸 : 전체)
		■ cmbCMMN_YN : Object / 공통여부 DhtmlXCombo  (CODE : 'YN_CD' / 빈 칸 : 전체) 		 
	--%>
	var erpLayout;
	var erpRibbon;	
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;	
	var cmbMEMB_CONT_CD;
	var calMEMB_JOIN_YYMMDD;
	
	
	// 서브디테일레이아웃과 디테일그리드, 디테일그리드컬럼, 데이타프로세서 선언
	var erpSubDetailLayout;
	var erpDetailGrid;
	var erpDetailGridColumns;
	var erpDetailGridDataProcessor;
	
	
	$(document).ready(function(){		
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		initErpGrid();
		initErpSubDetailLayout();
		initErpDetailRibbon();
		initErpDetailGrid();
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "${menuDto.menu_nm}", header:true, height:69}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		
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
						{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
						, {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
						, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
						//, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : true}
						//, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, unused : true}		
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "add_erpGrid"){
		    	addErpGrid();
		    } else if (itemId == "delete_erpGrid"){
		    	deleteErpGrid();
		    } else if (itemId == "save_erpGrid"){
		    	saveErpGrid();
		    } else if (itemId == "excel_erpGrid"){
		    	
		    } else if (itemId == "print_erpGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			  {id : "MEMB_NO",         label:["사원번호", "#text_filter"], type: "ed", width: "100", sort : "int", align : "center", isHidden : false, isEssential : true}
			, {id : "CHECK",      label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "MEMB_NM",      label:["성명(국문)", "#text_filter"], type: "ed", width: "40", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "MEMB_ENG_NM",      label:["성명(영문)", "#text_filter"], type: "ed", width: "40", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MEMB_POSI",   label:["직급", "#text_filter"], type: "ed", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MEMB_RMK",   label:["등급", "#select_filter"], type: "combo", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true,commonCode : ["MEMB_RMK","MR"]}
			, {id : "MEMB_TEL_NO", label:["전화번호", "#text_filter"], type: "ed", width: "300", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "MEMB_JOIN_YYMMDD",     label:["입사일자", "#select_filter"], type: "dhxCalendarA", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "MEMB_CLOS_YYMMDD",    label:["퇴사일자", "#select_filter"], type: "dhxCalendarA", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "MEMB_CONT_CD", label:["계약상태", "#select_filter"],    type: "combo", width: "130", sort : "str", align : "left", isHidden : false, isEssential : false, commonCode : ["MEMB_CONT_CD","MCC"]}
			, {id : "MEMB_EMAIL",     label:["이메일", "#text_filter"],        type: "ed", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MEMB_INTR",     label:["소개자", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_POST_NO", label:["우편번호", "#text_filter"],    type: "ed", width: "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_ADDR",     label:["주소", "#text_filter"],        type: "ed", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MEMB_CATE",     label:["구분", "#text_filter"],       type: "combo", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false , commonCode : ["MEMB_CATE","MC"]}
			, {id : "MEMB_REGS_NO",     label:["등록번호", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_AREA",     label:["업무영역", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_SKILL",     label:["스킬", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_BANK",     label:["은행", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_ACCT_NM",     label:["예금주", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_ACCT_NO",     label:["계좌번호", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_PAY_DAY",     label:["대금지급일", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
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
		erpGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpGrid);
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		var memb_no = document.getElementById("txtMEMB_NO").value;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isLengthOver(memb_no, 50)){
			isValidated = false;
			alertMessage = "error.common.system.authority.MEMB_NO.length50Over";
			alertCode = "-1";
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
		
		var memb_no = document.getElementById("txtMEMB_NO").value;
		var memb_cont_cd = cmbMEMB_CONT_CD.getSelectedValue();
		var memb_join_yymmdd_fr = document.getElementById("txtDATE_FR_JOIN").value;
		var memb_join_yymmdd_to = document.getElementById("txtDATE_TO_JOIN").value;
		
		$.ajax({
			url : "/common/system/authority/empManagementTestR1.do"
			,data : {
				"MEMB_NO" : memb_no
				, "MEMB_CONT_CD" : memb_cont_cd
				, "MEMB_JOIN_YYMMDD_FR" : memb_join_yymmdd_fr
				, "MEMB_JOIN_YYMMDD_TO" : memb_join_yymmdd_to
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
	
	<%-- erpGrid 추가 Function --%>
	function addErpGrid(){
		var uid = erpGrid.uid();
		erpGrid.addRow(uid);
		erpGrid.selectRow(erpGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	<%-- erpGrid 삭제 Function --%>
	function deleteErpGrid(){
		var gridRowCount = erpGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpGrid.getRowId(i);
			var check = erpGrid.cells(rId, erpGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(rId);
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
		
		for(var i = 0; i < deleteRowIdArray.length; i++){
			erpGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	<%-- erpGrid 저장 Function --%>
	function saveErpGrid(){
		if(erpGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpGrid);
		if(validResultMap.isError){
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
			url : "/common/system/authority/empManagementTestCUD1.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.alertSuccessMesage(onAfterSaveErpGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpGrid 저장 후 Function --%>
	function onAfterSaveErpGrid(){
		searchErpGrid();
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%--
	**************************************************
	* 기타 영역
	**************************************************
	--%>	
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbMEMB_CONT_CD = $erp.getDhtmlXCombo('cmbMEMB_CONT_CD', 'cmbMEMB_CONT_CD', ['MEMB_CONT_CD','MCC'], 120, true);
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>				
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="150px">
				<col width="150px">
				<col width="150px">
				<col width="150px">		
				<col width="150px">
				<col width="*">				
			</colgroup>
			<tr>
				<th>사원번호 / 사원명</th>
				<td><input type="text" id="txtMEMB_NO" name="MEMB_NO" class="input_common" maxlength="505" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid);"></td>
				<th>계약상태</th>
				<td><div id="cmbMEMB_CONT_CD"></div></td>
				<th>입사일자</th>
    	  <td colspan="2" style="display: flex; align-items: center;">
            <input type="text" id="txtDATE_FR_JOIN" class="input_calendar default_date" data-position="0" value="" style="float: left;">
            <span style="margin-left: 4px;">~</span>
            <input type="text" id="txtDATE_TO_JOIN" class="input_calendar default_date" data-position="9999-12-31" value="" style="margin-left: 4px;">
        </td>
		</table>
	</div>
	<div id="div_erp_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>