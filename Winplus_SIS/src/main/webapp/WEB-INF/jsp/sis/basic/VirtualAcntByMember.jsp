<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript">
	<%--
	
		■ VirtualAcntByCustomer.jsp			유통사업 업무 - 고객사 - 고객사가상계좌_조회
		
		■ VirtualAcntByMember.jsp			직영점 업무 - 마감/승인 - 신용승인 - 가상계좌현황(회원)_조회
		
		■ 조회시 같은 메소드로 매핑되므로 수정 시 유의
	
	--%>
	LUI = JSON.parse('${empSessionDto.lui}');
	//직영점업무 - 직영점회원가상계좌
	LUI.exclude_auth_cd = "All,1,2,3,4";//직영점만 검색가능
	LUI.exclude_orgn_type = "";//제외시킬 조직코드
	
	var total_layout;
	var top_layout;
	var mid_layout;
	var mid_layout_ribbon;
	var bot_header_layout;
	var bot_header_layout_grid;
	var bot_detail_layout;
	var bot_detail_layout_grid;
	var selectclick = "N";

	$(document).ready(function() {
		init_total_layout();
		init_mid_layout();
		init_bot_header_layout();
		init_bot_detial_layout();
		init_top_layout();
	});
	
	function init_total_layout() {
		total_layout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "4J"
			, cells : [
				{id: "a", text: "검색 조건", header:false, fix_size : [true, true]}
				,{id: "b", text: "미드영역", header:false, fix_size : [true, true]}
				,{id: "c", text: "가상계좌 목록", header: true, fix_size:[true,true], width: 662}
				,{id: "d", text: "가상계좌 상세 목록", header: true, fix_size:[true,true]}
			]
		});
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight(20);
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(36);
		total_layout.cells("c").attachObject("div_bot_header_layout");
		total_layout.cells("d").attachObject("div_bot_detail_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
	}
	
	function init_top_layout(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			});
		});
	}
	
	function init_mid_layout(){
		ribbon = new dhtmlXRibbon({
			parent : "div_mid_layout"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
							{
							type : "block"
							, mode : 'rows'
							, list : [
										{id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
//										, {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
//										, {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
//										, {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
										, {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
									]
							}
							]
		});
		
		ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				selectclick = "N"
				var dataObj = $erp.dataSerialize("tb_search");
				var url = "/sis/basic/getVirtualAcntHeaderList.do";
				var send_data = $erp.unionObjArray([LUI,dataObj]);
				var if_success = function(data){
					$erp.clearDhtmlXGrid(bot_header_layout_grid); //기존데이터 삭제
					$erp.clearDhtmlXGrid(bot_detail_layout_grid);
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(bot_header_layout_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						bot_header_layout_grid.parse(data.gridDataList,'js');
						$erp.setDhtmlXGridFooterRowCount(bot_header_layout_grid);	//현재 행 수 계산
					}
				}
				var if_error = function(){
					
				}
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			} else if (itemId == "add_grid"){
					
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				
			} else if	(itemId == "excel_grid"){
				if(selectclick == "Y") {
					$erp.exportGridToExcel({
						"grid" : bot_detail_layout_grid
						, "fileName" : "가상계좌상세현황"
						, "isOnlyEssentialColumn" : true
						, "excludeColumnIdList" : []
						, "isIncludeHidden" : false
						, "isExcludeGridData" : false
					});
				} else {
					$erp.alertMessage({
						"alertMessage" : "상세 화면 조회 후 이용 가능합니다.",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							//$erp.clearDhtmlXGrid(erpDetailGrid);
						}
					});
				}
			} else if (itemId == "print_grid"){
				
			}
		});
	}
	function init_bot_header_layout() {
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Header_Columns = [
								{id : "NO", label:["순번"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false,numberFormat : "0,000"}
								, {id : "ORGN_DIV_CD", label:["법인구분"], type : "combo", width : "150", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_DIV_CD"]}
								, {id : "ORGN_CD", label:["조직명"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD"]}
								, {id : "VRT_ORG_CD", label:["기관코드(농협)"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : true}
								, {id : "VRT_ORG_CD", label:["기관명(농협)"], type : "combo", width : "130", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["VRT_ORG_CD"]}
								, {id : "TOT_ACNT", label:["총 구좌"], type : "ron", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
								, {id : "ISSU_ACNT", label:["발행 구좌"], type : "ron", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
								, {id : "BAL_ACNT", label:["남은 구좌"], type : "ron", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
								];
		
		bot_header_layout_grid = new dhtmlXGridObject({
			parent: "div_bot_header_layout"
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : grid_Header_Columns
		});
		$erp.initGrid(bot_header_layout_grid,{multiSelect : true});
		
		<%-- 라디오 버튼 클릭 이벤트 --%>
		bot_header_layout_grid.attachEvent("onRowDblClicked", function(rId){
			var VRT_ORG_CD =
				bot_header_layout_grid.cells(rId,bot_header_layout_grid.getColIndexById("VRT_ORG_CD")).getValue();
			searchErpDetailGrid(VRT_ORG_CD);
		 });
	}
	
	function init_bot_detial_layout() {
		var grid_Detail_Columns = [
							{id : "NO", label:["순번", "#rspan"], type : "cntr", width : "36", sort : "int", align : "center", isHidden : false, isEssential : false}
							, {id : "VRT_ORG_CD", label:["기관코드(농협)", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "VRT_ORG_CD", label:["기관명(농협)", "#rspan"], type : "combo", width : "140", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : "VRT_ORG_CD"}
							, {id : "VRT_ACNT", label:["가상계좌번호", "#text_filter"], type : "ro", width : "130", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "OBJ_TARGET", label:["대상", "#rspan"], type : "combo", width : "130", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : "LOAN_APPLY_TYPE"}
							, {id : "OBJ_NM", label:["사업자명", "#text_filter"], type : "ro", width : "130", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "ISSN_DATE", label:["발행일", "#rspan"], type : "ro", width : "130", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "LAST_TRANS_DATE", label:["최종입금일", "#rspan"], type : "ro", width : "130", sort : "str", align : "center", isHidden : false, isEssential : true}
							];
		
		bot_detail_layout_grid = new dhtmlXGridObject({
			parent: "div_bot_detail_layout"
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : grid_Detail_Columns
		});
		$erp.initGrid(bot_detail_layout_grid,{multiSelect : true});
	}
	<%-- ■ erpDetailGrid 관련 Function 끝 --%>
	
	<%-- ■ searchErpDetailGrid 관련 Function 시작 --%>
	function searchErpDetailGrid(VRT_ORG_CD) {
		selectclick = "Y"
		total_layout.progressOn();
		$.ajax({
			url : "/sis/basic/getVirtualAcntDetailList.do"
			,data : {
				"VRT_ORG_CD" : VRT_ORG_CD
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(bot_detail_layout_grid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
								bot_detail_layout_grid
							, '<spring:message code="grid.noSearchData" />'
						);
						total_layout.progressOff();
					} else {
						bot_detail_layout_grid.parse(gridDataList, 'js');
						total_layout.progressOff();
					}
				}
				$erp.setDhtmlXGridFooterRowCount(bot_detail_layout_grid);//현재 행 수 계산
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
</script>
</head>
<body>
	<div id="div_top_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_top_layout_search" class="div_common_contents_full_size">
			<table id="tb_search" class="table">
				<colgroup>
					<col width="90px"/>
					<col width="110px"/>
					<col width="70px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th>법인구분</th>
					<td>
						<div id="cmbORGN_DIV_CD"></div>
					</td>
					<th>조직명</th>
					<td>
						<div id=cmbORGN_CD></div>
					</td>
					
				</tr>
			</table>
		</div>
	</div>
	
	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bot_header_layout" class="div_grid_full_size" style="display:none"></div>
	<div id="div_bot_detail_layout" class="div_grid_full_size" style="display:none"></div>
</body>
</html>