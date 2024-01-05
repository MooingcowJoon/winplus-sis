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
	LUI.exclude_auth_cd = "ALL,1,2,3,4";
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openSearchMemberGridPopup");
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var AUTHOR_CD = "${screenDto.author_cd}";
	var ORGN_CD = '${paramMap.ORGN_CD}';
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("회원조회");	
		}
		initErpLayout();
		initErpPopupRibbon();
		initErpPopupGrid();
		initDhtmlXCombo();
		
		$erp.asyncObjAllOnCreated(function(){
			if(ORGN_CD == undefined || ORGN_CD == null || ORGN_CD == ""){
				cmbORGN_DIV_CD.disable();
			} else {
				cmbORGN_DIV_CD.disable();
				cmbORGN_CD.disable();
			}
		});
	});
	
	function initErpLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false, fix_size:[true, true]}
				, {id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드영역", header:false, fix_size:[true, true]}
			]	
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_search");
		erpPopupLayout.cells("a").setHeight(70);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_popup_grid");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupGrid.setSizes();
		});
	}
	
	function initErpPopupRibbon() {
		var use_items = [];
		
		var items_01 = [
			{type : "block", mode : 'rows', list : [
				{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
				, {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
			]}
		];
		
		var items_02 = [
			{type : "block", mode : 'rows', list : [
				{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
			]}
		];
		
		//erpPopupMemberCheckList가 없으면 거래처 여러개 추가버튼 hide
		if($erp.isEmpty(window["erpPopupMemberCheckList"])){
			use_items = items_02;
		} else {
			use_items = items_01;
		}
		
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : use_items
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				isSearchValidate();
			}else if (itemId == "add_erpGrid"){
		    	addErpPopupGrid();
		    }
		});
		
	}
	
	function initErpPopupGrid(){
		erpPopupGridColumns = [
				{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}
				,{id : "ORGN_DIV_CD", label:["법인구분"], type : "combo", width : "140", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_DIV_CD"]}
				,{id : "ORGN_CD", label:["조직명"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD"]}
				,{id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
				,{id : "MEM_NO", label:["회원코드"], type: "ro", width: "50", sort : "str", align : "center", isHidden : false, isEssential : false}
				,{id : "OBJ_CD", label:["여신상세코드"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
				,{id : "UNION_MEM_NM", label:["상호명[회원명]"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : false}
				,{id : "MEM_NM", label:["회원명"], type: "ro", width: "120", sort : "str", align : "center", isHidden : true, isEssential : false}              
				, {id : "TEL_NO01", label:["전화번호01"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}              
				, {id : "TEL_NO02", label:["전화번호02"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}              
				, {id : "PHON_NO", label:["휴대폰번호"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
			];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH	
			, columns : erpPopupGridColumns
		});
		
		//erpPopupMemberCheckList가 없을때, CHECK 박스 컬럼 hide시키기
		if($erp.isEmpty(window["erpPopupMemberCheckList"])){
			erpPopupGrid.setColumnHidden(erpPopupGrid.getColIndexById("CHECK"), true);
		}
		
		$erp.initGridCustomCell(erpPopupGrid);
		$erp.initGridComboCell(erpPopupGrid);
		erpPopupGrid.enableDistributedParsing(true, 100, 50);
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid, '<spring:message code="grid.allRowCount" />');
		
		if(!$erp.isEmpty(window["erpPopupMemberOnRowSelect"]) && typeof window["erpPopupMemberOnRowSelect"] === 'function'){
			erpPopupGrid.attachEvent("onRowDblClicked", erpPopupMemberOnRowSelect);
		}
	}
	
	function isSearchValidate(){
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		var UNION_MEM_NM = $("#txtUNION_MEM_NM").val();
		if(UNION_MEM_NM.length == 0 && ORGN_CD == ""){
			$erp.confirmMessage({
				"alertMessage" : "검색 속도가 느릴 수 있습니다. </br> 진행하시겠습니까?"
				,"alertType" : "info"
				,"isAjax" : false
				,"alertCallbackFn" : function(){searchErpPopupGrid(); }
			});
		} else {
			searchErpPopupGrid();
		}
	}
	
	function searchErpPopupGrid(){
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/common/popup/getSearchMemberList.do"
			,data : {
				"UNION_MEM_NM" : $("#txtUNION_MEM_NM").val()
				,"ORGN_CD" : cmbORGN_CD.getSelectedValue()
				,"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpPopupLayout.progressOff();
				$erp.clearDhtmlXGrid(erpPopupGrid);
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupGrid
							,  '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpPopupGrid.parse(gridDataList, 'js');
					}
					$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function addErpPopupGrid(){
		var Check_YN = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK"));
		if(Check_YN != ""){
			if(!$erp.isEmpty(erpPopupMemberCheckList) && typeof erpPopupMemberCheckList === 'function'){
				erpPopupMemberCheckList(erpPopupGrid);
	 		}
		} else {
			$erp.alertMessage({
				"alertMessage" : "체크된 상품항목이 없습니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}
	}
	
	function initDhtmlXCombo(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 160, null, false, '${paramMap.ORGN_DIV_CD}', function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 160, "AllOrOne", false, '${paramMap.ORGN_CD}', null);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			});
		});
	}
	
	function alertMessage(param){
		$erp.alertMessage(param);
	}
	
	function confirmMessage(param){
		$erp.confirmMessage(param);
	}
	
</script>
</head>
<body>
	<div id="div_erp_popup_layout">
		<div id="div_erp_popup_search" class="div_layout_full_size div_erp_contents_search" style="display:none;">
			<table id="tb_erp_popup_table" class="table_search">
			<colgroup>
				<col width="90px"/>
				<col width="180px"/>
				<col width="80px"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<th>법인구분</th>
				<td>
					<div id="cmbORGN_DIV_CD"></div>
				</td>
				<th>조직명</th>
				<td>
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
			<tr>
				<th>상호명[회원명]</th>
				<td colspan="3">
					<input type="text" id="txtUNION_MEM_NM" name="MEM_NM" style="width: 153px;" onkeyup="if(event.keyCode==13) searchErpPopupGrid()">
				</td>
			</tr>
			</table>
		</div>
		<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_popup_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>