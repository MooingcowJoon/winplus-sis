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
		■ erpPopupWindowsCell : Object / 시스템 팝업 윈도우 Cell DhtmlxWindowsCell; 
		■ erpPopupLayout : Object / 페이지 Layout DhtmlxLayout
		■ erpPopupRibbon : Object / 리본형 버튼 목록 DhtmlxRibbon
		■ erpPopupGrid : Object / 표준분류코드 조회 DhtmlxGrid
		■ erpPopupGridColumns : Array / 표준분류코드 DhtmlxGrid Header		
		■ erpPopupGridOnRowDblClicked : Object (Function) / erpPopupGrid 더블 클릭시 실행될 Function
	--%>
	var erpPopupWindowsCell = parent.erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
	
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;	
	
	var erpPopupGridOnRowDblClicked;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("${screenDto.scrin_nm}");	
		}

		initErpPopupLayout();
		initErpPopupRibbon();
		initErpPopupGrid();	

		searchErpPopupGrid();	
	});
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>	
	<%-- erpPopupLayout 초기화 Function --%>	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "${screenDto.scrin_nm}", header:false, fix_size : [true, true]}
				, {id: "b", text: "", header:false}
			]		
		});
		
		erpPopupLayout.conf.ofs = {b : 4, l : 4, r : 4, t : 4};		

		erpPopupLayout.cells("a").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_grid");
		
		erpPopupLayout.setSeparatorSize(1, 0);
		erpPopupLayout.setSizes();
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupGrid.setSizes();			
		});
	}
	<%-- ■ erpPopupLayout 관련 Function 끝 --%>	
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>	
	<%-- erpPopupLayout 초기화 Function --%>	
	function initErpPopupRibbon(){
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						{id : "search_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}									
				]}							
			]
		});
		
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpPopupGrid"){
		    	searchErpPopupGrid();
		    }
		});
	}
	<%-- ■ erpPopupLayout 관련 Function 끝 --%>	
	
	<%-- ■ erpPopupGrid 관련 Function 시작 --%>	
	<%-- erpPopupGrid 초기화 Function --%>	
	function initErpPopupGrid(){
		erpPopupGridColumns = [
			{id : "NO", label : ["NO"], type :  "cntr", width :  "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "EMP_NO", label:["사용자번호"], type: "ro", width: "80", align : "center", isHidden : true, isEssential : false}
			, {id : "EMP_NO_LOGIN_ADD", label:["변경사용자번호"], type: "ro", width: "80", align : "center", isHidden : false, isEssential : false}
			, {id : "EMP_NM", label:["사용자명"], type: "ro", width: "115", align : "left", isHidden : false, isEssential : false}
			, {id : "ORGN_DIV_NM", label:["조직구분"], type: "ro", width: "80",align : "left", isHidden : false, isEssential : true}
			, {id : "ORGN_NM", label:["조직명"], type: "ro", width: "110", align : "left", isHidden : false, isEssential : false}
			, {id : "DLV_BSN_NM", label:["납품업체명"], type: "ro", width: "110", align : "left", isHidden : false, isEssential : false}
		];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpPopupGridColumns			
		});
		//erpPopupGrid.splitAt(erpPopupGrid.getColIndexById("HRORG_NM"));
		//erpPopupGrid.enableSmartRendering(true);		
		$erp.initGridCustomCell(erpPopupGrid);
		$erp.initGridComboCell(erpPopupGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid, '<spring:message code="grid.allRowCount" />');
		
		<%-- erpPopupGrid Row 더블클릭 시 사용될 Function 상위 Window or Frame 에서 만들어 전달해줌 erp_popup.js도 참조--%>
		if(!$erp.isEmpty(erpPopupGridOnRowDblClicked) && typeof erpPopupGridOnRowDblClicked === 'function'){
			erpPopupGrid.attachEvent("onRowDblClicked", erpPopupGridOnRowDblClicked);
		}
		

	}
	
	
	<%-- erpPopupGrid 조회 Function --%>
	function searchErpPopupGrid(){
		
		erpPopupLayout.progressOn();

		$.ajax({
			url : "/common/popup/searchEmpLoginAddListPopupR1.do"
			,data : {
				"EMP_NO" : "${EMP_NO}"
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpPopupGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						
						
						/* if(data.MTRL_CD.length > 0){
							alert("data.MTRL_CD.length : "+data.MTRL_CD.length);
							document.getElementById("txtMTRL_CD").value=data.MTRL_CD;
							document.getElementById("txtMTRL_NM").value=data.MTRL_NM;
							alert("data.MTRL_CD : " + data.MTRL_CD);
							$erp.closePopup();	
						} */
						
						erpPopupGrid.parse(gridDataList, 'js');

						
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpPopupGrid 관련 Function 끝 --%>		

</script>
</head>
<body>

<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
<div id="div_erp_popup_grid" class="div_grid_full_size" style="display:none"></div>
<div id="div_erp_popup_detail_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>