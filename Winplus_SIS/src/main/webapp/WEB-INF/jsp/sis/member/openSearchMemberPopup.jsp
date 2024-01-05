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

	var erpPopupWindowsCell = parent.erpPopupWindows.window("openSearchMemberPopup");
	var erpLayout;
	var erpRibbon;
	var erpMemberGrid;
	var erpMemberGridColumns;
	var cmbORGN_CD;
	var paramData = {};
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("회원검색");
		}
		
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
	});
	
	<%-- ■ erpLayout 초기화 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "조건정보", header:false}
				,{id: "b", text: "리본정보", header:false, fix_size : [true, true]}
				,{id: "c", text: "그리드정보", header:false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
	}
	<%-- ■ erpLayout 초기화 끝 --%>

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
					, {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchErpGrid();
			}else if (itemId == "add_erpGrid"){
				addErpGrid(); 
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpMemberGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "35", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "ORGN_CD", label:["직영점", "#rspan"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["ORGN_CD" , "MK"]}
			, {id : "MEM_NM", label:["회원명", "#rspan"], type: "ro", width: "95", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "CORP_NM", label:["상호명", "#rspan" ], type: "combo", width: "110", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MEM_ABC", label:["회원분류(ABC)", "#rspan"], type: "combo", width: "90", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode :["MEM_ABC"]}
			, {id : "PHON_NO", label:["전화번호", "#rspan"], type: "ro", width: "110", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "UNIQUE_MEM_NO", label:["회원코드(히든)", "#rspan"], type: "ro", width: "110", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "MEM_NO", label:["회원코드", "#rspan"], type: "ro", width: "110", sort : "str", align : "center", isHidden : true, isEssential : false}
		];
		
		erpMemberGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpMemberGridColumns
		});		
		erpMemberGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpMemberGrid);
		$erp.initGridComboCell(erpMemberGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpMemberGrid, '<spring:message code="grid.allRowCount" />');
		
		erpMemberGridDataProcessor = new dataProcessor();
		erpMemberGridDataProcessor.init(erpMemberGrid);
		erpMemberGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpMemberGrid);
		$erp.attachDhtmlXGridFooterPaging(erpMemberGrid, 100);
				
		 if(!$erp.isEmpty(erpPopupCheckList) && typeof erpPopupCheckList === 'function'){
			 erpMemberGrid.attachEvent("onClickAddData", erpPopupCheckList);
		}
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- erpPopupGrid 조회 Function --%>
	function searchErpGrid(){
		erpLayout.progressOn();
		
		paramData["MEM_NM"] = $("#txtMEM_NM").val();
		paramData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		paramData["MEM_STATE"] = "0";
			
		$.ajax({
			url : "/common/popup/getSearchMember.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpMemberGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpMemberGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpMemberGrid.parse(gridDataList, 'js');	
						
						/* if(!$erp.isEmpty(erpPopupCheckList) && typeof erpPopupCheckList === 'function'){
							erpGrid.attachEvent("onClickAddData", erpPopupCheckList);
						} */
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpMemberGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
			
		});
	}
	<%-- ■ erpPopupGrid 조회 Function 끝--%>
	
	function addErpGrid() {
		var Check_YN = erpMemberGrid.getCheckedRows(erpMemberGrid.getColIndexById("CHECK"));
		if(Check_YN != ""){
			if(!$erp.isEmpty(erpPopupCheckList) && typeof erpPopupCheckList === 'function'){
				erpPopupCheckList(erpMemberGrid);
			}
		} else {
			$erp.alertMessage({
				"alertMessage" : "체크된 항목이 없습니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}
	}
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",");
		var searchable = 1;
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
				searchable = 2;
			}
		}
		
		 if(searchable == 2 ){
			 cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "cmbORGN_CD", ["ORGN_CD", "MK"], 110, "모두조회", false, LUI.LUI_orgn_cd);
		} else {
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 100, null, false, LUI.LUI_orgn_cd);
		}
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>
<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="50px;">
				<col width="140px;">
				<col width="*">
			</colgroup>
			<tr>
			<th>회원명</th>
				<td>
					<input type="text" id="txtMEM_NM" name="txtMEM_NM" class="input_common" maxlength="10" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid);"/>
				</td>
				<th>
					<div id="cmbORGN_CD"></div>
				</th>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>