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
	
	var total_layout;
	
	var mid_layout;
	var mid_layout_ribbon;

	var bottom_layout;
	var bottom_layout_grid;
	
	$(document).ready(function(){		
		init_total_layout();
		init_top_layout();
		init_mid_layout();
		init_bottom_layout();
		
		mid_layout_ribbon.callEvent("onClick",["search_grid"]);
	});
	
	function init_total_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "검색조건", header:false, fix_size:[true, true]}
				, {id: "b", text: "리본", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드", header:false, fix_size:[true, true]}
			]
		});
		
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight($erp.getTableHeight(1));
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(36);
		total_layout.cells("c").attachObject("div_bottom_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
		
	}
	
	<%-- ■ top_layout 초기화 시작 --%>
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
	<%-- ■ top_layout 초기화 끝 --%>
	
	function init_mid_layout(){
		mid_layout_ribbon = new dhtmlXRibbon({
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
// 				        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
// 				        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
				        		             ]
				           }							
				           ]
		});
		
		mid_layout_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				var url = "/sis/basic/getCardCorpInfoList.do";
				var send_data = $erp.dataSerialize("top_table");
				var if_success = function(data){
					$erp.clearDhtmlXGrid(bottom_layout_grid); //기존데이터 삭제
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(bottom_layout_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						bottom_layout_grid.parse(data.gridDataList,'js');
					}
					$erp.setDhtmlXGridFooterRowCount(bottom_layout_grid); // 현재 행수 계산
				}
				
				var if_error = function(){
					
				}
				
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			} else if (itemId == "add_grid"){
				var SELECT_ORGN_DIV_CD = cmbORGN_DIV_CD.getSelectedValue();
				var SELECT_ORGN_CD = cmbORGN_CD.getSelectedValue();
				if(SELECT_ORGN_DIV_CD == ""){
					$erp.alertMessage({
						"alertMessage" : "법인구분를 선택해주세요.",
						"alertType" : "alert",
						"isAjax" : false
					});
					return;
				}else if(SELECT_ORGN_CD == ""){
					$erp.alertMessage({
						"alertMessage" : "조직명를 선택해주세요.",
						"alertType" : "alert",
						"isAjax" : false
					});
					return;
				}
				var uid = bottom_layout_grid.uid();
				bottom_layout_grid.addRow(uid);
				bottom_layout_grid.cells(uid, bottom_layout_grid.getColIndexById("ORGN_DIV_CD")).setValue(SELECT_ORGN_DIV_CD);
				bottom_layout_grid.cells(uid, bottom_layout_grid.getColIndexById("ORGN_CD")).setValue(SELECT_ORGN_CD);
				bottom_layout_grid.setCellExcellType(uid, bottom_layout_grid.getColIndexById("CARDCORP_CD"),"ed");
			} else if (itemId == "delete_grid"){
				$erp.dataDeleteOfCheckedGridRow(bottom_layout_grid);
			} else if (itemId == "save_grid"){
				var url = "/sis/basic/crudCardCorpInfoList.do";
				var send_data = $erp.dataSerializeOfGridByCRUD(bottom_layout_grid);
				var if_success = function(data){
					$erp.clearDhtmlXGrid(bottom_layout_grid); //기존데이터 삭제
					mid_layout_ribbon.callEvent("onClick",["search_grid"]);
					$erp.setDhtmlXGridFooterRowCount(bottom_layout_grid); // 현재 행수 계산
					$erp.alertMessage({
						"alertMessage" : "저장성공",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
				}
				
				var if_error = function(XHR, status, error){
					
				}
				
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			} 
// 			else if (itemId == "excel_grid"){
				
// 			} else if (itemId == "print_grid"){
				
// 			}
		});
	}
	
	function init_bottom_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
							{id : "CHECK", label : ["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "NO", label:["NO"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "ORGN_DIV_CD", label:["법인구분", "#text_filter"], type : "combo", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "ORGN_DIV_CD", isDisabled : true}
		                    , {id : "ORGN_CD", label:["직영점", "#text_filter"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "ORGN_CD", isDisabled : true}
		                    , {id : "CARDCORP_CD", label:["코드", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "CARDCORP_NM", label:["매입사명", "#text_filter"], type : "ed", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "NICK_NM", label:["카드사별칭", "#text_filter"], type : "ed", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "FEE_RATE", label:["수수료", "#text_filter"], type : "edn", width : "60", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000.00%"}
		                    , {id : "DEPO_TERM", label:["입금주기", "#text_filter"], type : "edn", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "SLIP_PUR_TYPE", label:["전표매입사여부", "#text_filter"], type : "edn", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "CDATE", label:["등록일", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "MDATE", label:["수정일", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    ];
		
		bottom_layout_grid = new dhtmlXGridObject({
			parent: "div_bottom_layout"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		$erp.initGrid(bottom_layout_grid,{multiSelect : true});
		bottom_layout_grid.getColumnCombo(bottom_layout_grid.getColIndexById("ORGN_DIV_CD")).disable(true);
		bottom_layout_grid.getColumnCombo(bottom_layout_grid.getColIndexById("ORGN_CD")).disable(true);
		
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
				<tr>
					<th colspan="1">법인구분</th>
					<td colspan="2"><div id="cmbORGN_DIV_CD"></div></td>
					<th colspan="1">조직명</th>
					<td colspan="2"><div id="cmbORGN_CD"></div></td>
					<td colspan="4"></td>
				</tr>
			</table>
		</div>
	</div>

	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bottom_layout" class="div_grid_full_size" style="display:none"></div>
</body>
</html>