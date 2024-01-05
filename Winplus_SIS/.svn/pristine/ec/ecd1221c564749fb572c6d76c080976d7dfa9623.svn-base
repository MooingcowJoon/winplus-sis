<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>

<link rel="stylesheet" href="/resources/framework/dhtmlxScheduler_v4.4.0/sources/skins/dhtmlxscheduler_flat.css" />
<style type="text/css">
	.dhxlayout_base_dhx_skyblue .dhxlayout_cont div.dhx_cell_layout div.dhx_cell_cont_layout {
		border-top:1px solid #8baeda;
	}
</style>
<script type="text/javascript">
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpGrid : Object / DhtmlXGrid
		■ erpDetailGrid : Object / DhtmlXGrid
	--%>
	var erpLayout;
	var erpGrid;
	var erpDetailGrid; 
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	
	$(document).ready(function(){		
		initErpLayout();
		initErpRibbon();
		initErpGrid();
// 		initErpDetailGrid();
		searchErpAllGrid();
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: "div_erp_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"  //4I
			, cells: [
				{id: "a", text: "", header:false, fix_size:[true, true]}
				, {id: "b", text: "공지사항", header:true, fix_size:[false, true]}
// 				, {id: "c", text: "사원마당", header:true, fix_size:[false, true]}
				, {id: "c", text: "", header:false, fix_size:[true, true]}
			]		
		});
		
		//erpLayout.setAutoSize("a;c", "a;b");
		erpLayout.cells("a").attachObject("div_erp_ribbon");
		erpLayout.cells("a").setHeight(38);
		erpLayout.cells("b").attachObject("div_erp_grid");
		erpLayout.cells("b").setHeight(333);
// 		erpLayout.cells("c").attachObject("div_erp_detail_grid");
		erpLayout.cells("c").attachObject("img_erp_home_banner");
		
		//erpLayout.setSeparatorSize(1, 0);
		
		var html = document.body.parentNode;
		var height = html.offsetHeight;
		document.body.style.height = (height-40) + "px";
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
			var html = document.body.parentNode;
			var height = html.offsetHeight;
			document.body.style.height = (height-40) + "px";
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- erpRibbon 초기화 Function --%>
	function initErpRibbon(){
        erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [{type : "block", mode : 'rows', list : [
				{id : "search_boardData", type : "button", text:'<spring:message code="ribbon.reload" />', isbig : false, img : "menu/reload.gif", imgdis : "menu/reload_dis.gif", disable : false}
			]}]
		});
            
        erpRibbon.attachEvent("onClick", function(itemId, bId){
 			if(itemId == "search_boardData"){
 				searchErpAllGrid();
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "BOARD_NO", label:["NO"], type: "ro", width: "60", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "BOARD_KIND_CD", label:["구분"], type: "ro", width: "50", sort : "str", align : "center", isHidden : true, isEssential : true, commonCode : "BOARD_KIND_CD"}
			, {id : "SUBJECT", label:["제목"], type: "ro", width: "578", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "RDCNT", label:["조회수"], type: "ro", width: "45", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CUSER", label:["등록자"], type: "ro", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "CDATE", label:["등록일시"], type: "ro", width: "130", sort : "str", align : "center", isHidden : false, isEssential : false}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
		});		
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 20);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		
		erpGrid.attachEvent("onRowSelect", function(rId, cInd){
			openBoardPopup(rId);
		});
	}
	
	
	<%-- ■ erpDetailGrid 관련 Function 시작 --%>	
	<%-- erpDetailGrid 초기화 Function --%>
// 	function initErpDetailGrid(){
// 		erpDetailGridColumns = [
// 			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
// 			, {id : "BOARD_NO", label:["NO"], type: "ro", width: "60", sort : "int", align : "center", isHidden : false, isEssential : false}
// 			, {id : "BOARD_KIND_CD", label:["구분"], type: "ro", width: "50", sort : "str", align : "center", isHidden : true, isEssential : true, commonCode : "BOARD_KIND_CD"}
// 			, {id : "SUBJECT", label:["제목"], type: "ro", width: "240", sort : "str", align : "left", isHidden : false, isEssential : false}
// 			, {id : "RDCNT", label:["조회수"], type: "ro", width: "45", sort : "int", align : "center", isHidden : false, isEssential : false}
// 			, {id : "CUSER", label:["등록자"], type: "ro", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false}
// 			, {id : "CDATE", label:["등록일시"], type: "ro", width: "110", sort : "str", align : "center", isHidden : false, isEssential : false}
// 		];
		
// 		erpDetailGrid = new dhtmlXGridObject({
// 			parent: "div_erp_detail_grid"			
// 			, skin : ERP_GRID_CURRENT_SKINS
// 			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
// 			, columns : erpDetailGridColumns
// 		});		
// 		$erp.attachDhtmlXGridFooterPaging(erpDetailGrid, 20);
// 		$erp.initGridCustomCell(erpDetailGrid);
// 		$erp.initGridComboCell(erpDetailGrid);
		
// 		erpDetailGrid.attachEvent("onRowSelect", function(rId, cInd){
// 			openBoardPopup(rId);
// 		});
// 	}

	
	<%-- ■ 전체 Grid 관련 Function 시작 --%>
	<%-- 전체 Grid 조회 Function --%>
	function searchErpAllGrid(){
		erpLayout.progressOn();
		$.ajax({
			url : "/common/board/mainBoardList.do"
			,data : {
				"DATE_YN" : "Y"
				, "ORGN_DIV_CD" : LUI.LUI_orgn_div_cd
				, "ORGN_CD" : LUI.LUI_orgn_cd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGrid);
// 					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.gridDataListNotice;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpGrid.parse(gridDataList, 'js');	
					}
// 					var detailGridDataList = data.gridDataListEmp;
// 					if($erp.isEmpty(detailGridDataList)){
// 						$erp.addDhtmlXGridNoDataPrintRow(
// 							erpDetailGrid
// 							, '<spring:message code="grid.noSearchData" />'
// 						);
// 					} else {
// 						erpDetailGrid.parse(detailGridDataList, 'js');	
// 					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ 전체 Grid 관련 Function 끝 --%>
	
	<%-- ■ 팝업 관련 Function 시작 --%>
	function openBoardPopup(rId){

		var paramMap = $erp.dataSerializeOfGridRow(erpGrid, rId);
		
		var parentWindow= window;
		
		$erp.openBoardPopup(paramMap, parentWindow);
	}
	<%-- ■ 팝업 관련 Function 끝 --%>
</script>
</head>
<body style="background-color:#dfe8f6;padding-top:45px;">
	<!-- #634e40 -->
	<div id="div_erp_home_header_wrapper"  class="common_center" style="background-color: #dfe8f6"> 
		<img style="margin:auto; width:250px; margin-bottom:15px;" src="/resources/common/img/default/winplus_logo_image.png">
	</div>
	<div id="div_erp_layout" style="margin:auto;width:975px;height:680px;border:0px solid #fff"></div>
	<div id="div_erp_ribbon" class="div_common_contents_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display: none"></div>
<!-- 	<div id="div_erp_detail_grid" class="div_grid_full_size" style="display: none"></div> -->
	<img id="img_erp_home_banner" src="/resources/common/img/default/winplus_image.png" style="display:none; width:100%;"> 
</body>
</html>