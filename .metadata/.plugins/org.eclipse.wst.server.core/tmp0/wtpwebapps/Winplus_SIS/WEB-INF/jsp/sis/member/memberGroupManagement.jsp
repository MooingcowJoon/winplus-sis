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
	var LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2,3,4";
	var total_layout;
	
	var bot_left_layout;
	var bot_mid_layout;
	var bot_right_layout;
	
	var SELECTED_GRUP_ROW;
	
	$(document).ready(function(){
		init_total_layout();
		init_top_layout();
		init_bot_left_layout();
		init_bot_mid_layout();
		init_bot_right_layout();
		
		//모든 레이아웃 초기화 함수 호출후 등록해주세요.
		$erp.asyncObjAllOnCreated(function(){
			bot_left_ribbon.callEvent("onClick",["search_grid"]);
			bot_right_ribbon.callEvent("onClick",["search_grid"]);
		});
	});
	
	function init_total_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4T"
			, cells: [
				  {id: "a", text: "공통검색조건", header : true, fix_size:[true, true]}
				, {id: "b", text: "그룹리스트", header : true, fix_size:[true, true], width: 500}
				, {id: "c", text: "그룹내회원", header : true, fix_size:[true, true], width: 540}
				, {id: "d", text: "회원리스트", header : true, fix_size:[true, true]}
			]
		});
		
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight($erp.getTableHeight(2));
		total_layout.cells("b").attachObject("div_bot_left_layout");
		total_layout.cells("c").attachObject("div_bot_mid_layout");
		total_layout.cells("d").attachObject("div_bot_right_layout");
		
		total_layout.setSeparatorSize(0, 2);
		total_layout.setSeparatorSize(1, 1);
		total_layout.setSeparatorSize(2, 1);
		
	}
	
	<%-- ■ top_layout 초기화 시작 --%>
	function init_top_layout(){
		top_layout = new dhtmlXLayoutObject({
			parent: "div_top_layout"
				, skin : ERP_LAYOUT_CURRENT_SKINS
				, pattern: "1C"
					, cells: [
						{id: "a", text: "", header:false, fix_size:[true, true]}
						]
		});
		top_layout.captureEventOnParentResize(total_layout); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.		
		
		top_layout.cells("a").attachObject("div_top_layout_table");
		
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, LUI.LUI_orgn_cd, function(){
				cmbORGN_CD.attachEvent("onChange", function(value, text){
					if(value != null){
						bot_left_ribbon.callEvent("onClick",["search_grid"]);
					}
				}); 
			});
			
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			}); 
		});
	}
	<%-- ■ top_layout 초기화 끝 --%>
	
	<%-- ■ bot_left_layout 초기화 시작 --%>
	function init_bot_left_layout(){
		bot_left_layout = new dhtmlXLayoutObject({
			parent: "div_bot_left_layout"
				, skin : ERP_LAYOUT_CURRENT_SKINS
				, pattern: "3E"
					, cells: [
						{id: "a", text: "", header:false, fix_size:[true, true]},
						{id: "b", text: "", header:false, fix_size:[true, true]},
						{id: "c", text: "", header:false, fix_size:[true, true]}
						]
		});
		bot_left_layout.captureEventOnParentResize(total_layout); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.		
		
		bot_left_layout.cells("a").attachObject("div_bot_left_top_layout");
		bot_left_layout.cells("a").setHeight($erp.getTableHeight(1));
		bot_left_layout.cells("b").attachObject("div_bot_left_mid_ribbon");
		bot_left_layout.cells("b").setHeight(36);
		bot_left_layout.cells("c").attachObject("div_bot_left_bot_grid");
		
		bot_left_layout.setSeparatorSize(0, 1);
		bot_left_layout.setSeparatorSize(1, 1);
		
		bot_left_ribbon = new dhtmlXRibbon({
			parent : "div_bot_left_mid_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
						{type : "block"
							, mode : 'rows'
							, list : [
								{id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
								, {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
								, {id : "delete_grid", 	type : "button", text:'<spring:message code="ribbon.selectUnuse" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
								, {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
								,
							]
						}							
					]
		});
		
		
		bot_left_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				inputSELECTED_GRUP_ROW(null);
				var url = "/sis/member/getMemberGroupList.do";
				var send_data = $erp.unionObjArray([$erp.dataSerialize("ORGN"),$erp.dataSerialize("bot_left_top_table")]);
				var if_success = function(data){
					$erp.clearDhtmlXGrid(bot_left_grid); //기존데이터 삭제
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(bot_left_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						bot_left_grid.parse(data.gridDataList,'js');
					}
					$erp.setDhtmlXGridFooterRowCount(bot_left_grid); // 현재 행수 계산
				}
				var if_error = function(XHR, status, error){
				}
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			}else if(itemId == "add_grid"){
				var resultData = $erp.tableValidationCheck("top_table");
				if(resultData === false){ //false 가 아닐시 정상(직렬화된 데이터)
					$erp.alertMessage({
						"alertMessage" : "법인구분과 조직명이 선택 되어있어야 합니다.",
						"alertType" : "alert",
						"isAjax" : false
					});
					return;
				}
				
				var uid = bot_left_grid.uid();
				bot_left_grid.addRow(uid);
				bot_left_grid.cells(uid, bot_left_grid.getColIndexById("GRUP_CD")).setValue("자동설정");
				bot_left_grid.cells(uid, bot_left_grid.getColIndexById("ORGN_DIV_CD")).setValue(cmbORGN_DIV_CD.getSelectedValue());
				bot_left_grid.cells(uid, bot_left_grid.getColIndexById("ORGN_CD")).setValue(cmbORGN_CD.getSelectedValue());
				bot_left_grid.cells(uid, bot_left_grid.getColIndexById("USE_YN")).setValue("Y");
				bot_left_grid.setCellExcellType(uid, bot_left_grid.getColIndexById("GRUP_NM"),"ed");
			}else if(itemId == "delete_grid"){
				$erp.dataDeleteOfCheckedGridRow(bot_left_grid);
			}else if(itemId == "save_grid"){
				var gridData = $erp.dataSerializeOfGridByCRUD(bot_left_grid,true);
				var sumCount_CUD = gridData["C"].length + gridData["U"].length + gridData["D"].length;
				if(sumCount_CUD == 0){
					$erp.alertMessage({
						"alertMessage" : "변경된 항목이 없습니다.",
						"alertType" : "alert",
						"isAjax" : false
					});
					return;
				}
				var url = "/sis/member/crudMemberGroup.do";
				var send_data = gridData;
				var if_success = function(data){
					$erp.clearDhtmlXGrid(bot_left_grid); //기존데이터 삭제
					
					$erp.alertMessage({
						"alertMessage" : "저장성공",
						"alertType" : "alert",
						"isAjax" : false
					});
					
					bot_left_ribbon.callEvent("onClick",["search_grid"]);
				}
				
				var if_error = function(XHR, status, error){
				}
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			}
		});
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
			  {id : "CHECK", label : ["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center"}
			, {id : "SELECT", label : ["선택", "#rspan"], type : "ra", width : "40", sort : "str", align : "center", isDataColumn : false}
			, {id : "ORGN_DIV_CD", label:["법인구분", "#text_filter"], type: "combo", width: "80", sort : "str", align : "center", isDisabled : true, isHidden : true, commonCode : "ORGN_DIV_CD"}
			, {id : "ORGN_CD", label:["조직명", "#text_filter"], type: "combo", width: "80", sort : "str", align : "center", isDisabled : true, isHidden : false, commonCode : "ORGN_CD"}
			, {id : "GRUP_CD", label:["그룹코드", "#text_filter"], type : "ro", width : "50", sort : "str", align : "center", isEssential : true}
			, {id : "GRUP_NM", label:["그룹명", "#text_filter"], type : "ed", width : "200", sort : "str", align : "left", isEssential : true}
			, {id : "USE_YN", label:["사용여부", "#text_filter"], type: "combo", width: "80", sort : "str", align : "center", commonCode : ["USE_CD", "YN"]}
			];
		
		bot_left_grid = new dhtmlXGridObject({
			parent: "div_bot_left_bot_grid"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		bot_left_grid.captureEventOnParentResize(total_layout);
		var bot_left_grid_processor = $erp.initGrid(bot_left_grid);
	
		bot_left_grid.attachEvent("onCheck", function (rowId,columnIdx,state){
			if(bot_left_grid_processor.getState(rowId) == "deleted"){
				if(!state){
					bot_left_grid_processor.setUpdated(rowId, false, "deleted"); //inserted, updated, deleted
				}
			}
			
			if(bot_left_grid.getColIndexById("SELECT") == columnIdx){
				inputSELECTED_GRUP_ROW($erp.dataSerializeOfGridRow(bot_left_grid, rowId));
			}
		});
		
	}
	<%-- ■ bot_left_layout 초기화 끝 --%>
	
	<%-- ■ bot_mid_layout 초기화 시작 --%>
	function init_bot_mid_layout(){
		bot_mid_layout = new dhtmlXLayoutObject({
			parent: "div_bot_mid_layout"
				, skin : ERP_LAYOUT_CURRENT_SKINS
				, pattern: "3E"
					, cells: [
						{id: "a", text: "", header:false, fix_size:[true, true]},
						{id: "b", text: "", header:false, fix_size:[true, true]},
						{id: "c", text: "", header:false, fix_size:[true, true]}
						]
		});
		bot_mid_layout.captureEventOnParentResize(total_layout); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.		
		
		bot_mid_layout.cells("a").attachObject("div_bot_mid_top_layout");
		bot_mid_layout.cells("a").setHeight($erp.getTableHeight(1));
		bot_mid_layout.cells("b").attachObject("div_bot_mid_mid_ribbon");
		bot_mid_layout.cells("b").setHeight(36);
		bot_mid_layout.cells("c").attachObject("div_bot_mid_bot_grid");
		
		bot_mid_layout.setSeparatorSize(0, 1);
		bot_mid_layout.setSeparatorSize(1, 1);
		
		bot_mid_ribbon = new dhtmlXRibbon({
			parent : "div_bot_mid_mid_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{type : "block"
						, mode : 'rows'
							, list : [
								//{id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
								  {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
								, {id : "delete_grid", 	type : "button", text:'<spring:message code="ribbon.selectUnuse" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
								, {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
								]
					}							
					]
		});
		
		var midGridData;
		var rightGridData;
		var existCheckObj;
		var baseCount; //기존 개수
		var duplicationIndexList; //중복 인덱스 리스트
		var duplicationIndex; //중복 인덱스
		var useYN_changeIndexList; //미사용에서 사용처리된 인덱스 리스트
		var useYN_changeIndex; //미사용에서 사용처리된 인덱스
		var addCount; //추가된 개수
		var rowId;
		bot_mid_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				
			} else if (itemId == "add_grid"){
				if(!isExistSELECTED_GRUP_ROW()){
					return;
				}
				
				total_layout.progressOn();
				
				$erp.copyRowsGridToGrid(bot_right_grid, bot_mid_grid, ["MEM_NO"], ["MEM_NO"], "checked", "add", [], [], {"USE_YN":"Y"}, {"ORGN_DIV_CD":SELECTED_GRUP_ROW["ORGN_DIV_CD"], "ORGN_CD":SELECTED_GRUP_ROW["ORGN_CD"], "GRUP_CD":SELECTED_GRUP_ROW["GRUP_CD"], "USE_YN":"Y"});
				
				total_layout.progressOff();
			} else if (itemId == "delete_grid"){
				$erp.deleteGridCheckedRows(bot_mid_grid);
			} else if (itemId == "save_grid"){
				var url = "/sis/member/crudMemberListInGroup.do";
				var send_data = $erp.dataSerializeOfGridByCRUD(bot_mid_grid,true);
				var sumCount_CUD = send_data["C"].length + send_data["U"].length + send_data["D"].length;
				if(sumCount_CUD == 0){
					$erp.alertMessage({
						"alertMessage" : "변경된 항목이 없습니다.",
						"alertType" : "alert",
						"isAjax" : false
					});
					return;
				}
				var if_success = function(data){
					$erp.clearDhtmlXGrid(bot_mid_grid); //기존데이터 삭제
					
					$erp.alertMessage({
						"alertMessage" : "저장성공",
						"alertType" : "alert",
						"isAjax" : false
					});
					
					getMemberListInGroup();
				}
				var if_error = function(XHR, status, error){
				}
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			}
		});
		
		var grid_Columns = [
			{id : "CHECK", label : ["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center"}
			, {id : "GRUP_CD", label:["그룹코드", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center", isHidden : true}
			, {id : "GRUP_NM", label:["그룹명", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center", isHidden : true}
			, {id : "CORP_NM", label:["상호명", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true}
			, {id : "MEM_BCD", label:["회원바코드", "#text_filter"], type: "ro", width: "110", sort : "str", align : "center"}
			, {id : "MEM_NM", label:["회원명", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center", isHidden : true}
			, {id : "UNION_MEM_CORP", label:["상호명[회원명]", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left"}
			, {id : "MEM_NO", label:["회원코드", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center"}
			, {id : "ORGN_DIV_CD", label:["법인구분", "#text_filter"], type: "combo", width: "80", sort : "str", align : "center", isDisabled : true, isHidden : true, commonCode : "ORGN_DIV_CD"}
			, {id : "ORGN_CD", label:["조직명", "#text_filter"], type: "combo", width: "80", sort : "str", align : "center", isDisabled : true, isHidden : true, commonCode : "ORGN_CD"}
			, {id : "USE_YN", label:["사용여부", "#text_filter"], type: "combo", width: "80", sort : "str", align : "center", commonCode : ["USE_CD", "YN"]}
			];
		
		bot_mid_grid = new dhtmlXGridObject({
			parent: "div_bot_mid_bot_grid"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		
		bot_mid_grid.captureEventOnParentResize(total_layout);
		
		var bot_mid_grid_processor = $erp.initGrid(bot_mid_grid);
		
		bot_mid_grid.attachEvent("onCheck", function (rowId,columnIdx,state){
			if(bot_mid_grid_processor.getState(rowId) == "deleted"){
				if(!state){
					bot_mid_grid_processor.setUpdated(rowId, false, "deleted"); //inserted, updated, deleted
				}
			}
		});
	}
	<%-- ■ bot_mid_layout 초기화 끝 --%>
	
	<%-- ■ bot_right_layout 초기화 시작 --%>
	function init_bot_right_layout(){
		bot_right_layout = new dhtmlXLayoutObject({
			parent: "div_bot_right_layout"
				, skin : ERP_LAYOUT_CURRENT_SKINS
				, pattern: "3E"
					, cells: [
						{id: "a", text: "", header:false, fix_size:[true, true]},
						{id: "b", text: "", header:false, fix_size:[true, true]},
						{id: "c", text: "", header:false, fix_size:[true, true]}
					]
		});
		bot_right_layout.captureEventOnParentResize(total_layout); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.		
		
		bot_right_layout.cells("a").attachObject("div_bot_right_top_layout");
		bot_right_layout.cells("a").setHeight($erp.getTableHeight(1));
		bot_right_layout.cells("b").attachObject("div_bot_right_mid_ribbon");
		bot_right_layout.cells("b").setHeight(36);
		bot_right_layout.cells("c").attachObject("div_bot_right_bot_grid");
		
		bot_right_layout.setSeparatorSize(0, 1);
		bot_right_layout.setSeparatorSize(1, 1);
		
		bot_right_ribbon = new dhtmlXRibbon({
			parent : "div_bot_right_mid_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{type : "block"
						, mode : 'rows'
						, list : [
							{id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
						]
					}							
					]
		});
		
		bot_right_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				var url = "/sis/member/getMemberList.do";
				var send_data = $erp.unionObjArray([$erp.dataSerialize("ORGN"),$erp.dataSerialize("bot_right_top_table")]);
				var if_success = function(data){
					$erp.clearDhtmlXGrid(bot_right_grid); //기존데이터 삭제
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(bot_right_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						bot_right_grid.parse(data.gridDataList,'js');
					}
					$erp.setDhtmlXGridFooterRowCount(bot_right_grid); // 현재 행수 계산
				}
				var if_error = function(XHR, status, error){
				}
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			}
		});
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
			{id : "CHECK", label : ["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center"}
			, {id : "MEM_BCD", label:["회원바코드", "#text_filter"], type: "ro", width: "110", sort : "str", align : "center"}
			, {id : "MEM_NM", label:["회원명", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center", isHidden : true}
			, {id : "CORP_NM", label:["상호명", "#text_filter"], type: "ro", width: "140", sort : "str", align : "center", isHidden : true}
			, {id : "UNION_MEM_CORP", label:["상호명[회원명]", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left"}
			
			, {id : "MEM_NO", label:["회원코드", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center"}
			];
		
		bot_right_grid = new dhtmlXGridObject({
			parent: "div_bot_right_bot_grid"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		bot_right_grid.captureEventOnParentResize(total_layout);
		$erp.initGrid(bot_right_grid, {disableProcessor : true});
		
	}
	<%-- ■ bot_right_layout 초기화 끝 --%>
	
	function inputSELECTED_GRUP_ROW(val){
		SELECTED_GRUP_ROW = val;
		if(!SELECTED_GRUP_ROW){
			$erp.clearDhtmlXGrid(bot_mid_grid); //기존데이터 삭제
		}else{
			getMemberListInGroup();
		}
	}

	function isExistSELECTED_GRUP_ROW(){
		var isExist = SELECTED_GRUP_ROW? true : false;
		if(!isExist){
			$erp.alertMessage({
				"alertMessage" : "선택된 그룹이 없습니다.",
				"alertType" : "error",
				"isAjax" : false
			});
		}
		return isExist;
	}
	
	function getMemberListInGroup(){
		var url = "/sis/member/getMemberListInGroup.do";
		if(!isExistSELECTED_GRUP_ROW()){
			return;
		}
		var send_data = $erp.unionObjArray([$erp.dataSerialize("ORGN"), SELECTED_GRUP_ROW,$erp.dataSerialize("bot_mid_top_table")]);
		var if_success = function(data){
			$erp.clearDhtmlXGrid(bot_mid_grid); //기존데이터 삭제
			if($erp.isEmpty(data.gridDataList)){
				//검색 결과 없음
				$erp.addDhtmlXGridNoDataPrintRow(bot_mid_grid, '<spring:message code="info.common.noDataSearch" />');
			}else{
				bot_mid_grid.parse(data.gridDataList,'js');
			}
			
			$erp.setDhtmlXGridFooterRowCount(bot_mid_grid); // 현재 행수 계산
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
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="*">
				</colgroup>
				<tr id="ORGN">
					<th colspan="1">법인구분</th>
					<td colspan="2"><div id="cmbORGN_DIV_CD" data-isEssential="true"></div></td>
					<th colspan="1">조직명</th>
					<td colspan="2"><div id="cmbORGN_CD" data-isEssential="true"></div></td>
					<td colspan="4"></td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="div_bot_left_layout" class="samyang_div" style="display:none">
		<div id="div_bot_left_top_layout" class="samyang_div" style="display:none">
			<div id="div_bot_left_top_layout_table" class="samyang_div">
				<table id="bot_left_top_table" class="table">
					<colgroup>
						<col width="60px">
						<col width="120px">
						<col width="60px">
						<col width="*">
					</colgroup>
					<tr>
						<th colspan="1">회원그룹</th>
						<td colspan="3"><input type="text" id="txtGRUP_NM" class="input_text" value="" onKeydown="$erp.useRibbonOnEnterKey(event,bot_left_ribbon,'search_grid')" style="width:110px;"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="div_bot_left_mid_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
		<div id="div_bot_left_bot_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	

	<div id="div_bot_mid_layout" class="samyang_div" style="display:none">
		<div id="div_bot_mid_top_layout" class="samyang_div" style="display:none">
			<div id="div_bot_mid_top_layout_table" class="samyang_div">
				<table id="bot_mid_top_table" class="table">
					<colgroup>
						<col width="100px">
						<col width="120px">
						<col width="60px">
						<col width="*">
					</colgroup>
					<tr>
						<th colspan="1">상호명[회원명]</th>
						<td colspan="3"><input type="text" id="txtMEM_NM_IN_GROUP" class="input_text" value="" onkeyup="if(event.keyCode==13){getMemberListInGroup();}" style="width:110px;"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="div_bot_mid_mid_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
		<div id="div_bot_mid_bot_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	
	
	<div id="div_bot_right_layout" class="samyang_div" style="display:none">
		<div id="div_bot_right_top_layout" class="samyang_div" style="display:none">
			<div id="div_bot_right_top_layout_table" class="samyang_div">
				<table id="bot_right_top_table" class="table">
					<colgroup>
						<col width="100px">
						<col width="80px">
						<col width="80px">
						<col width="*">
					</colgroup>
					<tr>
						<th colspan="1">상호명[회원명]</th>
						<td colspan="3"><input type="text" id="txtMEM_NM" class="input_text" value="" onKeydown="$erp.useRibbonOnEnterKey(event,bot_right_ribbon,'search_grid')" style="width:110px;"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="div_bot_right_mid_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_bot_right_bot_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	
</body>
</html>