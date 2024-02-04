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
	var cmbMEMB_CONT_CD;
	var calMEMB_JOIN_YYMMDD;
	var erpEmpGridSelectedMEMB_NO;
	// 사원조회 레이아웃
	var erpEmpLayout;
	var erpEmpRibbon;	
	var erpEmpGrid;
	var erpEmpGridColumns;
	var erpEmpGridDataProcessor;	
	// 프로젝트 레이아웃
	var erpPjtLayout;
	var erpPjtGrid;
	var erpPjtRibbon;
	var erpPjtGridColumns;
	var erpPjtGridDataProcessor;
	
	
	// 팝업 레이아웃
	var erpPopupLayout;
	
	$(document).ready(function(){		
		initErpPopupLayout();
		initErpLayout();
		initErpEmpLayout();
		initErpEmpGrid();
		initErpEmpRibbon();
		initDhtmlXCombo();
		
	 	initErpPjtLayout();
		initErpPjtGrid();
		initErpPjtRibbon(); 
	});
	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "1C"
			, cells : [
				{id: "a", text: "프로젝트 조회", header : false, fix_size:[true, true]}
			]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_emp_layout");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			//erpCustmrGrid.setSizes();
		});
	}
	
	
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "사원조회", header:true, width:660}
				, {id: "b", text: "프로젝트 투입이력", header:true}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_emp_layout");
		erpLayout.cells("b").attachObject("div_erp_pjt_layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpEmpLayout.setSizes();
			erpPjtLayout.setSizes();
			erpEmpGrid.setSizes();
			erpPjtGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- erpLayout 초기화 Function --%>	
	function initErpEmpLayout(){
		erpEmpLayout = new dhtmlXLayoutObject({
			parent: "div_erp_emp_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "${menuDto.menu_nm}", header:true, height:69}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		
		erpEmpLayout.cells("a").attachObject("div_erp_contents_search");
		erpEmpLayout.cells("b").attachObject("div_erp_emp_ribbon");
		erpEmpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpEmpLayout.cells("c").attachObject("div_erp_emp_grid");
		
		erpEmpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpEmpLayout, function(names){
			erpLayout.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	
	<%-- erpSubPjtLayout 초기화 Function --%>	
	function initErpPjtLayout(){
		erpPjtLayout = new dhtmlXLayoutObject({
			parent: "div_erp_pjt_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "", header:false, fix_size:[true, true]}
				, {id: "b", text: "", header:false}
			]		
		});
		
		erpPjtLayout.cells("a").attachObject("div_erp_pjt_ribbon");
		erpPjtLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPjtLayout.cells("b").attachObject("div_erp_pjt_grid");
		
		erpPjtLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpPjtLayout, function(names){
			erpPjtGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	
	
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>	
	function initErpEmpRibbon(){
		erpEmpRibbon = new dhtmlXRibbon({
			parent : "div_erp_emp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						{id : "search_erpEmpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
						, {id : "add_erpEmpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
						, {id : "delete_erpEmpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						, {id : "save_erpEmpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
						//, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : true}
						//, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, unused : true}		
				]}							
			]
		});
		
		erpEmpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpEmpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "add_erpEmpGrid"){
		    	addErpGrid();
		    } else if (itemId == "delete_erpEmpGrid"){
		    	deleteErpGrid();
		    } else if (itemId == "save_erpEmpGrid"){
		    	saveErpGrid();
		    } else if (itemId == "excel_erpEmpGrid"){
		    	
		    } else if (itemId == "print_erpEmpGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	<%-- erpRibbon 초기화 Function --%>	
	function initErpPjtRibbon(){
		erpPjtRibbon = new dhtmlXRibbon({
			parent : "div_erp_pjt_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						{id : "search_erpPjtGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
						, {id : "add_erpPjtGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
						, {id : "delete_erpPjtGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						, {id : "save_erpPjtGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
						//, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : true}
						//, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, unused : true}		
				]}							
			]
		});
		
		erpPjtRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpPjtGrid"){
		    	searchErpPjtGrid();
		    } else if (itemId == "add_erpPjtGrid"){
		    	addErpPjtGrid();
		    } else if (itemId == "delete_erpPjtGrid"){
		    	deleteErpPjtGrid();
		    } else if (itemId == "save_erpPjtGrid"){
		    	saveErpPjtGrid();
		    } else if (itemId == "excel_erpPjtGrid"){
		    	
		    } else if (itemId == "print_erpPjtGrid"){
		    	
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpEmpGrid(){
		erpEmpGridColumns = [
			  {id : "MEMB_NO",         label:["사원번호", "#text_filter"], type: "ed", width: "100", sort : "int", align : "center", isHidden : false, isEssential : true}
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
		
		erpEmpGrid = new dhtmlXGridObject({
			parent: "div_erp_emp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpEmpGridColumns
		});		
		erpEmpGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpEmpGrid);
		$erp.initGridComboCell(erpEmpGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpEmpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpEmpGridDataProcessor = new dataProcessor();
		erpEmpGridDataProcessor.init(erpEmpGrid);
		erpEmpGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpEmpGrid);
		
		
		erpEmpGrid.attachEvent("onRowSelect", function(rId, cInd){
			erpEmpGridSelectedMEMB_NO = this.cells(rId, this.getColIndexById("MEMB_NO")).getValue();
			searchErpPjtGrid();
		});
		
	}
	
	<%-- erpSubPjtGrid 초기화 Function --%>	
	function initErpPjtGrid(){
		erpPjtGridColumns = [
			  {id : "PROJECT_ID",         label:["프로젝트id", "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "PROJECT_NM",      label:["프로젝트명", "#text_filter"], type: "ro", width: "40", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "START_DT",     label:["시작일자", "#select_filter"],       type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "END_DT",     label:["종료일자", "#select_filter"],       type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MAIN_CLIENT",   label:["원청(고객사)", "#select_filter"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true,commonCode : ["MEMB_RMK","MR"]}
			, {id : "CONDUCT_CLIENT", label:["수행사", "#text_filter"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "MEMB_CONT_CORP",      label:["계약회사(BP사)", "#text_filter"], type: "ed", width: "40", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MEMB_INV_DAY",   label:["청구일자", "#text_filter"], type: "ed", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MEMB_RCV_MMM",     label:["수령월 ", "#select_filter"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true , commonCode : ["MEMB_RCV_MMM","MMM"]}
			, {id : "MEMB_RCV_DAY",    label:["수령일", "#select_filter"], type: "ed", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "MEMB_RCV_CHK", label:["구분", "#select_filter"],    type: "combo", width: "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_CONT_AMT",     label:["계약금액", "#text_filter"],        type: "ed", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MEMB_REGU_YN",     label:["반정규여부", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_REGU_AMT", label:["반정규금액", "#text_filter"],    type: "ed", width: "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_ORGR_AMT",     label:["실계약금액", "#text_filter"],        type: "ed", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MEMB_CONT_YYMMDD",     label:["계약일자", "#text_filter"],       type: "combo", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false , commonCode : ["MEMB_CATE","MC"]}
			, {id : "MEMB_CONT_NM",     label:["담당자명", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_TEL_NO",     label:["전화번호", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_CONT_FILE_NAME",     label:["계약서", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_CONT_FILE_METH",     label:["경로", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_PROM_YYMMDD",     label:["계약일자", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMB_PROM_FILE_NAME",     label:["계약서", "#text_filter"],       type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
		
			
			];
		
		erpPjtGrid = new dhtmlXGridObject({
			parent: "div_erp_pjt_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpPjtGridColumns
		});		
		erpPjtGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPjtGrid);
		$erp.initGridComboCell(erpPjtGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpPjtGrid, '<spring:message code="grid.allRowCount" />');
		erpPjtGridDataProcessor = new dataProcessor();
		erpPjtGridDataProcessor.init(erpPjtGrid);
		erpPjtGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpPjtGrid);
		
			erpPjtGrid.attachEvent("onRowAdded", function(rId){
		        // Your custom logic here
		        cell = erpPjtGrid.cells(rId,0);
		        openSearchProjectGridPopup();
		        cell.setValue("newValue");
		      });
	}
	function openSearchProjectGridPopup(){
		
		var onRowSelect = function(id, ind) {
			console.log(this.cells(id, this.getColIndexById("PROJECT_ID")).getValue());
			
			var uid = erpPjtGrid.uid();
			erpPjtGrid.addRow(uid);
			erpPjtGrid.selectRow(erpCustmrGrid.getRowIndex(uid));
			//erpPjtGrid.cells(uid, erpPjtGrid.getColIndexById("PROJECT_ID")).setValue(this.getColIndexById("PROJECT_ID")).getValue());
			$erp.setDhtmlXGridFooterRowCount(erpPjtGrid);
			$erp.closePopup2("searchProjectGridPopup");
		}
		
		$erp.searchProjectGridPopup(onRowSelect);
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
		
		erpEmpLayout.progressOn();
		
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
				erpEmpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpEmpGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpEmpGrid
							, '<spring:message code="grid.noSearchData" />'
							
						);
					} else {
						erpEmpGrid.parse(gridDataList, 'js');	
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpEmpGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpEmpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchPjtValidate(){
		var isValidated = true;
		var memb_no = document.getElementById("txtMEMB_NO").value;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isLengthOver(memb_no, 50)){
			isValidated = false;
			alertMessage = "error.common.system.authority.memb_no.length50Over";
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
	
	<%-- erpPjtGrid 조회 Function --%>
	function searchErpPjtGrid(){
		if(!isSearchPjtValidate()){
			return;
		}
		
		erpLayout.progressOn();
		
		var memb_no = erpEmpGridSelectedMEMB_NO
		
		$.ajax({
			url : "/common/system/authority/empManagementTestR2.do"
			,data : {
				"MEMB_NO" : memb_no
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					erpEmpGridSelectedMEMB_NO = null;
					$erp.clearDhtmlXGrid(erpPjtGrid);
					$erp.clearDhtmlXGrid(erpPjtGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPjtGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpPjtGrid.parse(gridDataList, 'js');	
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPjtGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	
	<%-- erpGrid 추가 Function --%>
	function addErpEmpGrid(){
		var uid = erpEmpGrid.uid();
		erpEmpGrid.addRow(uid);
		erpEmpGrid.selectRow(erpEmpGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpEmpGrid);
	}
	
	<%-- erpPjtGrid 추가 Function --%>
	function addErpPjtGrid(){
		var uid = erpPjtGrid.uid();
		erpPjtGrid.addRow(uid);
		erpPjtGrid.selectRow(erpPjtGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpPjtGrid);

		
	}
	
	
	<%-- erpGrid 삭제 Function --%>
	function deleteErpEmpGrid(){
		var gridRowCount = erpEmpGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpEmpGrid.getRowId(i);
			var check = erpEmpGrid.cells(rId, erpEmpGrid.getColIndexById("CHECK")).getValue();
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
			erpEmpGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	
	<%-- erpGrid 삭제 Function --%>
	function deleteErpPjtGrid(){
		var gridRowCount = erpPjtGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpPjtGrid.getRowId(i);
			var check = erpPjtGrid.cells(rId, erpPjtGrid.getColIndexById("CHECK")).getValue();
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
			erpPjtGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	
	<%-- erpGrid 저장 Function --%>
	function saveErpEmpGrid(){
		if(erpEmpGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpEmpGrid);
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
	
	<%-- erpGrid 삭제 Function --%>
	function deleteErpEmpGrid(){
		var gridRowCount = erpEmpGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpEmpGrid.getRowId(i);
			var check = erpEmpGrid.cells(rId, erpEmpGrid.getColIndexById("CHECK")).getValue();
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
			erpEmpGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	
	<%-- erpPjtGrid 삭제 Function --%>
	function deleteErpPjtGrid(){
		var gridRowCount = erpPjtGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpPjtGrid.getRowId(i);
			var check = erpPjtGrid.cells(rId, erpPjtGrid.getColIndexById("CHECK")).getValue();
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
			erpPjtGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	
	<%-- erpPjtGrid 저장 Function --%>
	function saveErpPjtGrid(){
		if(erpPjtGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpPjtGrid);
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
			url : "/common/system/authority/EmpManagementTestCUD2.do"
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
	<div id="div_erp_emp_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_emp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_emp_grid" class="div_grid_full_size" style="display:none"></div>
	
	<div id="div_erp_pjt_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_pjt_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_pjt_grid" class="div_grid_full_size" style="display:none"></div>
	
</body>
</html>