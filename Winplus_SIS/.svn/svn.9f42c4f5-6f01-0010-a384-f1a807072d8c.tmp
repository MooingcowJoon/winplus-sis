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
	
	var isManager = LUI.LUI_is_manager;
	var loginUser = "${empSessionDto.emp_no}";
	
	var pageType = "${menuDto.menu_nm}";
	
	$(document).ready(function(){		
		init_total_layout();
		init_top_layout();
		init_mid_layout();
		init_bot_layout();
		
		//모든 레이아웃 초기화 함수 호출후 등록해주세요.
		$erp.asyncObjAllOnCreated(function(){
			mid_ribbon.callEvent("onClick",["search_grid"]);
		});
	});
	
	<%-- ■ total_layout 초기화 시작 --%>
	function init_total_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
				, cells: [
					{id: "a", text: "게시물 조회 조건", header:true}
					, {id: "b", text: "", header:false, fix_size : [true, true]}
					, {id: "c", text: "", header:false}
					]
		});
		
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight($erp.getTableHeight(3));
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(36);
		total_layout.cells("c").attachObject("div_bot_layout");
		
		total_layout.setSeparatorSize(0, 0);
		total_layout.setSeparatorSize(1, 0);
	}
	<%-- ■ total_layout 초기화 끝 --%>
	
	<%-- ■ top_layout 초기화 시작 --%>
	function init_top_layout(){
		
// 		if(pageType.indexOf("등록/조회") > -1){
// 			cmbBOARD_PUBLISH_SCOPE_WINPLUS = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_WINPLUS", 		"BOARD_PUBLISH_SCOPE_WINPLUS", 	"/sis/code/getBoardPublishScope.do", {"PART" : "WINPLUS"}, 130, "본사", false, "");
// 			cmbBOARD_PUBLISH_SCOPE_MK = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_MK", 				"BOARD_PUBLISH_SCOPE_MK", 		"/sis/code/getBoardPublishScope.do", {"PART" : "MK"}, 130, "직영점", false, "");
// 			cmbBOARD_PUBLISH_SCOPE_P = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_P", 					"BOARD_PUBLISH_SCOPE_P", 		"/sis/code/getBoardPublishScope.do", {"PART" : "P"}, 130, "협력사", false, "");
// 			cmbBOARD_PUBLISH_SCOPE_S = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_S", 					"BOARD_PUBLISH_SCOPE_S", 		"/sis/code/getBoardPublishScope.do", {"PART" : "S"}, 130, "고객사", false, "");
// 		}else{
			if("${empSessionDto.board_publish_scope_part}" == "WINPLUS"){
				cmbBOARD_PUBLISH_SCOPE_WINPLUS = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_WINPLUS", 	"BOARD_PUBLISH_SCOPE_WINPLUS", 	"/sis/code/getBoardPublishScope.do", {"PART" : "WINPLUS"}, 130, "본사", false, "");
				cmbBOARD_PUBLISH_SCOPE_MK = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_MK", 			"BOARD_PUBLISH_SCOPE_MK", 		"/sis/code/getBoardPublishScope.do", {"PART" : "MK"}, 130, "직영점", false, "");
				cmbBOARD_PUBLISH_SCOPE_P = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_P", 				"BOARD_PUBLISH_SCOPE_P", 		"/sis/code/getBoardPublishScope.do", {"PART" : "P"}, 130, "협력사", false, "");
				cmbBOARD_PUBLISH_SCOPE_S = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_S", 				"BOARD_PUBLISH_SCOPE_S", 		"/sis/code/getBoardPublishScope.do", {"PART" : "S"}, 130, "고객사", false, "");
			}else if("${empSessionDto.board_publish_scope_part}" == "MK"){
				cmbBOARD_PUBLISH_SCOPE_MK = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_MK", 			"BOARD_PUBLISH_SCOPE_MK", 		"/sis/code/getBoardPublishScope.do", {"PART" : "MK"}, 130, "직영점", false, "${empSessionDto.board_publish_scope_cd}");
				cmbBOARD_PUBLISH_SCOPE_MK.disable();
			}else if("${empSessionDto.board_publish_scope_part}" == "P"){
				cmbBOARD_PUBLISH_SCOPE_P = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_P", 				"BOARD_PUBLISH_SCOPE_P", 		"/sis/code/getBoardPublishScope.do", {"PART" : "P"}, 130, "협력사", false, "${empSessionDto.board_publish_scope_cd}");
				cmbBOARD_PUBLISH_SCOPE_P.disable();
			}else if("${empSessionDto.board_publish_scope_part}" == "S"){
				cmbBOARD_PUBLISH_SCOPE_S = $erp.getDhtmlXMultiCheckComboTableCode("cmbBOARD_PUBLISH_SCOPE_S", 				"BOARD_PUBLISH_SCOPE_S", 		"/sis/code/getBoardPublishScope.do", {"PART" : "S"}, 130, "고객사", false, "${empSessionDto.board_publish_scope_cd}");
				cmbBOARD_PUBLISH_SCOPE_S.disable();
			}
// 		}
		
		
		var menu_nm = "${screenDto.menu_nm}";
		cmbBOARD_KIND_CD = $erp.getDhtmlXComboCommonCode("cmbBOARD_KIND_CD", "BOARD_KIND_CD", "BOARD_KIND_CD", 130, null, false, "NOTICE", function(){
			cmbBOARD_KIND_CD.forEachOption(function(optionInfo){
				if(menu_nm.indexOf(optionInfo.text) > -1){
					cmbBOARD_KIND_CD.setComboValue(optionInfo.value);
					$erp.objReadonly("cmbBOARD_KIND_CD");
				}
			});
		});
		
		//id, paraName, commonCode, width, text, showCode, initValue, callback, useYN
		cmbBOARD_SEARCH_TYPE = $erp.getDhtmlXComboCommonCode("cmbBOARD_SEARCH_TYPE", "BOARD_SEARCH_TYPE", "BOARD_SEARCH_TYPE", 130, null, false, "00001");
	}
	<%-- ■ top_layout 초기화 끝 --%>
	
	<%-- ■ mid_layout 초기화 시작 --%>
	function init_mid_layout(){
		mid_ribbon = new dhtmlXRibbon({
			parent : "div_mid_layout"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{type : "block"
						, mode : 'rows'
							, list : [
								{id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
								, {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
								, {id : "delete_grid", 	type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
								, {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
								]
					}							
					]
		});
		
		mid_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				searchErpGrid();
			} else if (itemId == "add_grid"){
				openBoardPopup(null);
			} else if (itemId == "delete_grid"){
				//그리드객체, inserted 상태 로우들의 수정 가능 컬럼 id 리스트, inserted 상태 로우들의 수정 불가능 컬럼 id 리스트
				$erp.deleteGridCheckedRows(bot_grid, [], []);

			} else if (itemId == "save_grid"){
				var checked = bot_grid.getCheckedRows(bot_grid.getColIndexById("CHECK"));
				var checkedRows = checked.split(",");
				
				var BOARD_NO_LIST_STRING = "";
				var CUSER = "";
				for(i in checkedRows){
					if(checkedRows[i] == ""){
						mid_ribbon.callEvent("onClick",["search_grid"]);
						return;
					}
					
					CUSER = bot_grid.cells(checkedRows[i], bot_grid.getColIndexById("CUSER")).getValue();
					if(CUSER != loginUser){
						
						$erp.alertMessage({
							"alertMessage" : "해당 게시물의 등록자, 관리자만 변경 가능합니다.",
							"alertCode" : "삭제할 게시글 재확인 필요",
							"alertType" : "error",
							"isAjax" : false
						});
						
						return;
					}
					BOARD_NO_LIST_STRING += bot_grid.cells(checkedRows[i], bot_grid.getColIndexById("BOARD_NO")).getValue() + ","
				}
				
				deleteBoard(BOARD_NO_LIST_STRING);
			}
		});
	}
	<%-- ■ mid_layout 초기화 끝 --%>
	
	<%-- ■ bot_layout 초기화 시작 --%>
	function init_bot_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
				{id : "NO", 					label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
				, {id : "CHECK", 				label:["선택", "#master_checkbox"], type : "ch", width : "40", sort : "int", align : "center"}
				, {id : "BOARD_PUBLISH_SCOPE",	label:["게시범위", "#text_filter"], type: "ro", width: "70", sort : "str", align : "center", isHidden : true, isEssential : false}
				, {id : "BOARD_NO", 			label:["글번호", "#text_filter"], type: "ro", width: "60", sort : "int", align : "center", isHidden : false, isEssential : false}
				, {id : "BOARD_KIND_CD", 		label:["구분", "#text_filter"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : "BOARD_KIND_CD", isDisabled : true}
				, {id : "SUBJECT", 				label:["제목", "#text_filter"], type: "robp", width: "400", sort : "str", align : "left", isHidden : false, isEssential : false}
				, {id : "CONTENT", 				label:["내용", "#text_filter"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : false}
				, {id : "FILE_GRUP_NO", 		label:["파일그룹번호", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
				, {id : "CUSER", 				label:["등록자", "#text_filter"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
				, {id : "CDATE", 				label:["등록일", "#text_filter"], type: "ro", width: "140", sort : "str", align : "center", isHidden : false, isEssential : false}
				, {id : "RDCNT", 				label:["조회수", "#text_filter"], type: "ro", width: "60", sort : "int", align : "center", isHidden : false, isEssential : false}
			];
		
		bot_grid = new dhtmlXGridObject({
			parent: "div_bot_layout"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : grid_Columns
		});
		
		bot_grid.captureEventOnParentResize(total_layout);
		
		$erp.initGrid(bot_grid);
		
		bot_grid.attachEvent("onRowSelect", function(rId, cInd){
			openBoardPopup(rId);
		}); 
		
	}
	<%-- ■ bot_layout 초기화 끝 --%>
	
	function openBoardPopup(rId){
		var paramMap = null;
		if(rId != undefined && rId != null){
			paramMap = $erp.dataSerializeOfGridRow(bot_grid, rId);
		}
		
		if(paramMap == null){
			paramMap = {};
		}
		
		var serializeMap = $erp.dataSerialize("top_table");
		paramMap["BOARD_PUBLISH_SCOPE_WINPLUS"] = serializeMap["BOARD_PUBLISH_SCOPE_WINPLUS"];
		paramMap["BOARD_PUBLISH_SCOPE_MK"] = serializeMap["BOARD_PUBLISH_SCOPE_MK"];
		paramMap["BOARD_PUBLISH_SCOPE_P"] = serializeMap["BOARD_PUBLISH_SCOPE_P"];
		paramMap["BOARD_PUBLISH_SCOPE_S"] = serializeMap["BOARD_PUBLISH_SCOPE_S"];

		var onBoardSaved = function(){
			mid_ribbon.callEvent("onClick", ["search_grid"]);
		};
		
		$erp.openBoardPopup(paramMap, onBoardSaved);
	}

	function isSearchValidate(){
		var isValidated = true;
		var txtSEARCH_STRING = document.getElementById("txtSEARCH_STRING").value;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
	
		if($erp.isLengthOver(txtSEARCH_STRING, 50)){
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

	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
		if(!isSearchValidate()){
			return;
		}
		
		var paramMap = $erp.dataSerialize("top_table");
		paramMap["BOARD_PUBLISH_SCOPE"] = [];
		if(paramMap["BOARD_PUBLISH_SCOPE_WINPLUS"] instanceof Array){
			paramMap["BOARD_PUBLISH_SCOPE"] = paramMap["BOARD_PUBLISH_SCOPE"].concat(paramMap["BOARD_PUBLISH_SCOPE_WINPLUS"]);
		}
		if(paramMap["BOARD_PUBLISH_SCOPE_MK"] instanceof Array){
			paramMap["BOARD_PUBLISH_SCOPE"] = paramMap["BOARD_PUBLISH_SCOPE"].concat(paramMap["BOARD_PUBLISH_SCOPE_MK"]);
		}
		if(paramMap["BOARD_PUBLISH_SCOPE_P"] instanceof Array){
			paramMap["BOARD_PUBLISH_SCOPE"] = paramMap["BOARD_PUBLISH_SCOPE"].concat(paramMap["BOARD_PUBLISH_SCOPE_P"]);
		}
		if(paramMap["BOARD_PUBLISH_SCOPE_S"] instanceof Array){
			paramMap["BOARD_PUBLISH_SCOPE"] = paramMap["BOARD_PUBLISH_SCOPE"].concat(paramMap["BOARD_PUBLISH_SCOPE_S"]);
		}
		
		var url = "/common/board/getBoardList.do";
		var send_data = paramMap;
		var if_success = function(data){
			$erp.clearDhtmlXGrid(bot_grid);
			var gridDataList = data.gridDataList;
			if($erp.isEmpty(gridDataList)){
				$erp.addDhtmlXGridNoDataPrintRow(bot_grid, '<spring:message code="grid.noSearchData" />'
				);
			} else {
				bot_grid.parse(gridDataList, 'js');	
			}
			
			$erp.setDhtmlXGridFooterRowCount(bot_grid);
		}
		
		var if_error = function(XHR, status, error){}
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
	function deleteBoard(BOARD_NO_LIST_STRING){
		var url = "/common/board/deleteBoardList.do";
		var send_data = {"BOARD_NO_LIST_STRING" : BOARD_NO_LIST_STRING};
		var if_success = function(data){
			mid_ribbon.callEvent("onClick", ["search_grid"]);
		}
		
		var if_error = function(XHR, status, error){
		}
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
</script>
</head>
<body>			
	
	<div id="div_top_layout" class="samyang_div" style="display:none">
		<div id="div_top_layout_table" class="samyang_div">
			<table id="top_table" class="table">
			
				<colgroup>
					<col width="70px">
					<col width="70px">
					<col width="70px">
					<col width="70px">
					<col width="70px">
					<col width="70px">
					<col width="70px">
					<col width="70px">
					<col width="70px">
					<col width="*">
				</colgroup>
				
				<tr>
					<th colspan="1">게시범위</th>
					
					<c:choose>
						<c:when test="${empSessionDto.board_publish_scope_part == 'WINPLUS'}">
							<td colspan="2"><div id="cmbBOARD_PUBLISH_SCOPE_WINPLUS"></div></td>
							<td colspan="2"><div id="cmbBOARD_PUBLISH_SCOPE_MK"></div></td>
							<td colspan="2"><div id="cmbBOARD_PUBLISH_SCOPE_P"></div></td>
							<td colspan="3"><div id="cmbBOARD_PUBLISH_SCOPE_S"></div></td>
						</c:when>
						<c:when test="${empSessionDto.board_publish_scope_part == 'MK'}">
							<td colspan="9"><div id="cmbBOARD_PUBLISH_SCOPE_MK"></div></td>
						</c:when>
						<c:when test="${empSessionDto.board_publish_scope_part == 'P'}">
							<td colspan="9"><div id="cmbBOARD_PUBLISH_SCOPE_P"></div></td>
						</c:when>
						<c:when test="${empSessionDto.board_publish_scope_part == 'S'}">
							<td colspan="9"><div id="cmbBOARD_PUBLISH_SCOPE_S"></div></td>
						</c:when>
					</c:choose>
					
					
				</tr>
				
				<tr>
					<th colspan="1">게시타입</th>
					<td colspan="2"><div id="cmbBOARD_KIND_CD"></div></td>
					<th colspan="1">검색조건</th>
					<td colspan="2"><div id="cmbBOARD_SEARCH_TYPE"></div></td>
					<td colspan="4"><input type="text" id="txtSEARCH_STRING" size="43" maxlength="50" onKeydown="$erp.useRibbonOnEnterKey(event, mid_ribbon, 'search_grid')"/></td>
				</tr>
				
			</table>
		</div>
	</div>
	
	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none;"></div>
	
	<div id="div_bot_layout" class="div_grid_full_size" style="display:none"></div>
	
</body>
</html>