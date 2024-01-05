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
	
	var top_layout;
	
	var mid_ribbon;
	
	var bottom_grid;
	
	$(document).ready(function(){		
		init_total_layout();
		init_top_layout();
		init_mid_layout();
		init_bottom_layout();
		
	});
	
	function init_total_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건", header:false, fix_size:[true, true]}
				, {id: "b", text: "리본", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드", header:false}
			]
		});
		
		total_layout.cells("a").attachObject("div_top_table");
		total_layout.cells("a").setHeight($erp.getTableHeight(3));
		total_layout.cells("b").attachObject("div_mid_ribbon");
		total_layout.cells("b").setHeight(36);
		total_layout.cells("c").attachObject("div_bottom_grid");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
		
	}
	
	function init_top_layout(){
		cmbSEND_ORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbSEND_ORGN_DIV_CD", "SEND_ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, null, function(){
			cmbSEND_ORGN_CD = $erp.getDhtmlXComboTableCode("cmbSEND_ORGN_CD", "SEND_ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbSEND_ORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, null);
			cmbSEND_ORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbSEND_ORGN_CD.unSelectOption();
				cmbSEND_ORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbSEND_ORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			}); 
		});
		
		cmbRECEIVE_ORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbRECEIVE_ORGN_DIV_CD", "RECEIVE_ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbRECEIVE_ORGN_CD = $erp.getDhtmlXComboTableCode("cmbRECEIVE_ORGN_CD", "RECEIVE_ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbRECEIVE_ORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbRECEIVE_ORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbRECEIVE_ORGN_CD.unSelectOption();
				cmbRECEIVE_ORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbRECEIVE_ORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			}); 
		});
	}
	
	function init_mid_layout(){
		mid_ribbon = new dhtmlXRibbon({
			parent : "div_mid_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
				           {
				        	   type : "block"
				        	   , mode : 'rows'
			        		   , list : [
			        		               {id : "search_purchase", type : "button", text:'<spring:message code="ribbon.loadPurchase" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
			        		             , {id : "search_order", 	type : "button", text:'<spring:message code="ribbon.loadOrder" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
			        		             , {id : "add_goods", 		type : "button", text:'<spring:message code="ribbon.addGoods" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
			        		             , {id : "delete_grid", 	type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
			        		             , {id : "save_grid", 		type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
			        		             , {id : "excel_grid", 		type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
			        		             , {id : "print_grid", 		type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
			        		             ]
				           }							
				           ]
		});
		
		mid_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_purchase"){
				//!@#!@# 구매불러오기
			} else if (itemId == "search_order"){
				//!@#!@# 발주불러오기
			} else if (itemId == "add_goods"){
				var onClickRibbonAddData = function(fromGridObj){
					$erp.copyRowsGridToGrid(fromGridObj, bottom_grid, ["GOODS_NO"], ["GOODS_NO"], "checked", "new");
				}
				
				$erp.openSearchGoodsPopup(null, onClickRibbonAddData);
			} else if (itemId == "delete_grid"){
				$erp.deleteGridCheckedRows(bottom_grid);
			} else if (itemId == "save_grid"){
				if(!(cmbSEND_ORGN_DIV_CD.getSelectedValue() == cmbRECEIVE_ORGN_DIV_CD.getSelectedValue())){
					$erp.alertMessage({
						"alertMessage" : "다른 법인간 점간이동은 할 수 없습니다.",
						"alertType" : "error",
						"isAjax" : false
					});
					return;
				}
				
				//!@#!@# 점간이동 저장
			} else if (itemId == "excel_grid"){
				$erp.exportDhtmlXGridExcel({
				     "grid" : bottom_grid
				   , "fileName" : "${screenDto.scrin_nm}"
				   , "isForm" : false
				   , "isHiddenPrint" : "Y"
				});
			} else if (itemId == "print_grid"){
				
			}
		});
	}
	
		
	function init_bottom_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
							{id : "CHECK", label : ["선택", "#master_checkbox"], type : "ch", width : "40", sort : "int", align : "center"}
							, {id : "GOODS_NO", label:["상품코드", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center"}
							, {id : "GOODS_NM", label:["상품명", "#text_filter"], type: "ro", width: "200", sort : "str", align : "center"}
							, {id : "_____", label:["규격", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center"}
							, {id : "______", label:["수량", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center"}
							, {id : "_______", label:["적요", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center"}
							, {id : "CDATE", label:["등록일", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "MDATE", label:["수정일", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    ];
		
		bottom_grid = new dhtmlXGridObject({
			parent: "div_bottom_grid"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		$erp.initGrid(bottom_grid);
		
	}

</script>
</head>
<body>		

	<div id="div_top_table" class="samyang_div" style="display:none">
		<div id="div_top_table_search" class="samyang_div">
			<table id="tb_search" class="table">
				<colgroup>
					<col width="120px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th colspan="1">이동일자</th>
					<td colspan="1">
						<input type="text" id="txtDATE" class="input_calendar default_date" data-position="-7" value=""/>
					</td>
					<th colspan="1">담당자</th>
					<td colspan="1"><input type="text" id="txtRESP_USER" class="input_text" value=""/></td>
					<td colspan="6"></td>
				</tr>
				<tr>
					<th colspan="1">법인구분(출고)</th>
					<td colspan="2"><div id="cmbSEND_ORGN_DIV_CD"></div></td>
					<th colspan="1">조직명(출고)</th>
					<td colspan="2"><div id="cmbSEND_ORGN_CD"></div></td>
					<td colspan="4"></td>
				</tr>
				<tr>
					<th colspan="1">법인구분(입고)</th>
					<td colspan="2"><div id="cmbRECEIVE_ORGN_DIV_CD"></div></td>
					<th colspan="1">조직명(입고)</th>
					<td colspan="2"><div id="cmbRECEIVE_ORGN_CD"></div></td>
					<td colspan="4"></td>
				</tr>
			</table>
		</div>
	</div>

	<div id="div_mid_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bottom_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>