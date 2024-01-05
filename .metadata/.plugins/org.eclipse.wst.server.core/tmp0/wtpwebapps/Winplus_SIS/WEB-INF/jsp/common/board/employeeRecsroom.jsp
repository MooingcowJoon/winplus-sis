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
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
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
	var onRowDblClicked ;
	$(document).ready(function(){		
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		initErpGrid();
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "${menuDto.menu_nm}", header:true, height:80}
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
						//, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						//, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
						, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : true}
						, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, unused : true}		
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "add_erpGrid"){
		    	addErpGrid();
		    } else if (itemId == "delete_erpGrid"){
		    	//deleteErpGrid();
		    } else if (itemId == "save_erpGrid"){
		    	//saveErpGrid();
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
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "BBS_NO", label:["NO"], type: "ro", width: "60", sort : "int", align : "center", isHidden : true, isEssential : false}
			, {id : "SYS_DIV_NM", label:["구분"], type: "ro", width: "100", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "SJ", label:["제목"], type: "robp", width: "300", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "EMP_NM", label:["등록자"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "REG_DT", label:["등록일"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "RDCNT", label:["조회수"], type: "ro", width: "60", sort : "int", align : "center", isHidden : false, isEssential : false}
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
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
		erpGrid.attachEvent("onRowSelect", function(rId, cInd){
				openNoticeBoardPopup(rId);
		}); 
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		var txtSearch1 = document.getElementById("txtSearch1").value;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isLengthOver(txtSearch1, 50)){
			isValidated = false;
			alertMessage = "error.common.system.menu.scrin_nm.length50Over";
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
	
	function openNoticeBoardPopup(rId){
		
		var BBS_NO = erpGrid.cells(rId, erpGrid.getColIndexById("BBS_NO")).getValue();
		updateReadCount(BBS_NO);
		$erp.closePopup();	
	}
	
	<%-- 조회수 증가 Function --%>
	function updateReadCount(BBS_NO){
		
		if(!isSearchValidate()){
			return;
		}
		erpLayout.progressOn();
		
		var search1 = cmbSearch1.getSelectedValue();
		var txtSearch1 = $("#txtSearch1").val();
		var BBS_DIV_CD= "00003";
		$.ajax({
			url : "/common/board/readBoard.do"
			,data : {
				"SEARCH1" : search1
				, "txtSEARCH1" : txtSearch1
				, "BBS_NO" : BBS_NO
				, "BBS_DIV_CD" : BBS_DIV_CD
				, "SYS_DIV_CD" : "${empSessionDto.sys_div_cd}"
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
			},
			complete:function(){
				var onRowDblClicked = function(rId, cInd){
					$erp.closePopup();			
				}
				var onBeforeClear = function(){
					this.conf.files_added=0;
					this.conf.uploaded_count=0;
					return true;
				}
				var onUploadComplete=function(){
				}
				var onBeforeFileAdd = function(file){
					if (file.size / (1024 * 1024) > 300) {
						var erpPopupWindowsCell = erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
						var popWin = erpPopupWindowsCell.getAttachedObject().contentWindow;
						popWin.alertMessage({
								  "alertMessage" : "error.receive.wrongFileSize"
								, "alertCode" : null
								, "alertType" : "error"
							});
						this.clear();
						return false;
					}
					return true;
				}
				var parentWindow= window;
				$erp.openEmployeeRecsroomPopup(BBS_NO,parentWindow,null,onBeforeClear,onUploadComplete);
			}
		});
	}
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		if(!isSearchValidate()){
			return;
		}
		erpLayout.progressOn();
		
		var search1 = cmbSearch1.getSelectedValue();
		var txtSearch1 = $("#txtSearch1").val();
	
		$.ajax({
			url : "/common/board/readBoard.do"
			,data : {
				"SEARCH1" : search1
				, "txtSEARCH1" : txtSearch1
				, "BBS_DIV_CD" : "00003"
				, "SYS_DIV_CD" : "00001"
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
	<%-- ergGrid 등록 Function--%>
	function addErpGrid(){
		var onBeforeFileAdd = function(file){
			if (file.size / (1024 * 1024) > 300) {
				var erpPopupWindowsCell = erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
				var popWin = erpPopupWindowsCell.getAttachedObject().contentWindow;
				popWin.alertMessage({
						  "alertMessage" : "error.receive.wrongFileSize"
						, "alertCode" : null
						, "alertType" : "error"
					});
				this.clear();
				return false;
			}
			return true;
		}
		var parentWindow= window;
		var onBeforeClear = function(){
			this.conf.files_added=0;
			this.conf.uploaded_count=0;
			return true;
		}
		$erp.insertEmployeeRecsroomPopup(parentWindow, null,onBeforeFileAdd,onBeforeClear);
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	function onAfterSaveerpPopupGrid(){
		searchErpGrid();
	}
	<%--
	**************************************************
	* 기타 영역
	**************************************************
	--%>	
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbSearch1 = $erp.getDhtmlXComboFromSelect("cmbSearch1", "Search1", 80);
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
				<th style="text-align:left;float:right;">
					<select id="cmbSearch1">
						<option value="00001" selected="selected">제목</option>
						<option value="00002">내용</option>
					</select>
				</th>
				<td><input type="text" id="txtSearch1" size="50" maxlength="50"></td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>