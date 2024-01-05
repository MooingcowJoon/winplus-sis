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

	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2,3,4";
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDthmlXCombo();
		checkbox_YN('TOP');
		checkbox_YN('MEM');
	});
	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text : "조회조건영역", header : false, fix_size:[true, true]}
				, {id: "b", text : "리본영역", header : false, fix_size:[true, true]}
				, {id: "c", text : "그리드영역", header : false, fix_size:[true, true]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_search");
		erpLayout.cells("a").setHeight(98);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1,0);
		
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
		});
	}
	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpGrid"){
				searchMemberPoint();
			}
		});
	}
	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_DIV_CD", label:["조직구분코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "MEM_NO", label:["회원코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "MEM_NM", label:["회원명", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEM_TYPE", label:["고객유형", "#rspan"], type: "combo", width: "120", sort : "str", align : "left", isHidden : false, isDisabled : true, isEssential : false, commonCode:["MEM_TYPE"]}
			, {id : "POINT", label:["현재포인트", "#rspan"], type: "ro", width: "120", sort : "str", align : "right", isHidden : false, isEssential : false}
			, {id : "POINT_SUM", label:["누적포인트", "#rspan"], type: "ro", width: "85", sort : "str", align : "right", isHidden : false, isEssential : false}
			, {id : "POINT_TYPE", label:["포인트유형", "#rspan"], type: "combo", width: "110", sort : "str", align : "left", isHidden : false, isDisabled : true, isEssential : false, commonCode : ["POINT_TYPE"]}
			, {id : "SAVE_POINT", label:["적립/차감", "#rspan"], type: "ro", width: "110", sort : "str", align : "right", isHidden : false, isEssential : false}
			, {id : "POINT", label:["잔여포인트", "#rspan"], type: "ro", width: "110", sort : "str", align : "right", isHidden : false, isEssential : false}
			, {id : "EMP_NO", label:["담당자코드", "#rspan"], type: "ro", width: "110", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "EMP_NM", label:["담당자", "#rspan"], type: "ro", width: "110", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "CDATE", label:["기록일", "#rspan"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "REMK_MEMO", label:["비고", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
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
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
	}
	
	function initDthmlXCombo(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 200, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 110, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			});
		});
		
		cmbPOINT_TYPE = $erp.getDhtmlXComboCommonCode("cmbPOINT_TYPE", "POINT_TYPE", "POINT_TYPE ", 120, "모두조회", false);
		cmbMEM_TYPE = $erp.getDhtmlXComboCommonCode("cmbMEM_TYPE", "MEM_TYPE", "MEM_TYPE", 120, "모두조회", false);
		cmbMEM_ABC = $erp.getDhtmlXComboCommonCode("cmbMEM_ABC", "MEM_ABC", "MEM_ABC", 120, "모두조회", false);
		cmbGRADE_CD = $erp.getDhtmlXComboCommonCode("cmbGRADE_CD", "cmbGRADE_CD", "MEM_GRADE", 120, "모두조회", false);
	}
	
	function searchMemberPoint(){
		var paramMap = {
				"SEARCH_DATE_FROM" : $("#txtsearchDateFrom").val()
				, "SEARCH_DATE_TO" : $("#txtsearchDateTo").val()
				, "CHECK_TOP" : $("#CHECK_TOP").is(":checked")
				, "TOP_NUM" : $("#txtTOP_NUM").val()
				, "CHECK_MEM" : $("#CHECK_MEM").is(":checked")
				, "ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
				, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
				, "MEM_NO" : $("#txtMEM_NO").val()
				, "MEM_NM" : $("#txtMEM_NM").val()
				, "CHECK_STATE" : $("#CHECK_STATE").is(":checked")
				, "POINT_TYPE" : cmbPOINT_TYPE.getSelectedValue()
				, "MEM_TYPE" : cmbMEM_TYPE.getSelectedValue()
				, "MEM_ABC" : cmbMEM_ABC.getSelectedValue()
				, "GRADE_CD" : cmbGRADE_CD.getSelectedValue()
		}
		
		console.log(paramMap);
		erpLayout.progressOn();
		$.ajax({
			url: "/sis/market/member/getMemberPointList.do"
			, data : paramMap
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							,  '<spring:message code="grid.noSearchData" />'
						);
					}else {
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
	
	function checkbox_YN(chkObj){
		if(chkObj == "TOP"){
			if($("#CHECK_TOP").is(":checked") == false){
				$("#txtTOP_NUM").attr("disabled",true);
			} else {
				$("#txtTOP_NUM").attr("disabled",false);
			}
		} else if(chkObj == "MEM"){
			if($("#CHECK_MEM").is(":checked") == true){
				var ORGN_DIV_CD = $erp.getOrgnDivCdByOrgnCd(cmbORGN_CD.getSelectedValue());
				var paramMap = {
						"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
						, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
				}
				var onRowDblClicked = function(id) {
					$("#txtMEM_NM").val(this.cells(id, this.getColIndexById("MEM_NM")).getValue());
					$("#txtMEM_NO").val(this.cells(id, this.getColIndexById("MEM_NO")).getValue());
					$("#CHECK_MEM").prop("checked", false);
					$erp.closePopup2("openSearchMemberGridPopup");
				}
				
				$erp.openSearchMemberGridPopup(onRowDblClicked, null, paramMap);
			}
		}
	}
	
</script>
</head>
<body>
	<div id="div_erp_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="75px">
				<col width="210px">
				<col width="75px">
				<col width="120px">
				<col width="85px">
				<col width="120px">
				<col width="85px">
				<col width="*">
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
			<tr>
				<th>기준일자</th>
				<td>
					<input type="text" id="txtsearchDateFrom" name="searchDateFrom" class="input_calendar default_date" data-position="(start)">
					~
					<input type="text" id="txtsearchDateTo" name="searchDateTo" class="input_calendar default_date" data-position="">
				</td>
				<th><input type="checkbox" id="CHECK_TOP" onchange="checkbox_YN('TOP')">상위</th>
				<td>
					<input type="text" id="txtTOP_NUM" style="width: 100px;" maxlength="4">
				</td>
				<th><input type="checkbox" id="CHECK_MEM" onchange="checkbox_YN('MEM')">지정회원</th>
				<td>
					<input type="hidden" id="txtMEM_NO">
					<input type="text" id="txtMEM_NM" disabled style="width: 100px;">
				</td>
				<th><input type="checkbox" id="CHECK_STATE">무효포함</th>
			</tr>
			
		</table>
		<table class="table_search">
			<colgroup>
				<col width="75px">
				<col width="130px">
				<col width="75px">
				<col width="130px">
				<col width="85px">
				<col width="130px">
				<col width="75px">
				<col width="130px">
				<col width="75px">
				<col width="*">
			</colgroup>
			<tr>
				<th>적립유형</th>
				<td>
					<div id="cmbPOINT_TYPE"></div>
				</td>
				<th>회원유형</th>
				<td>
					<div id="cmbMEM_TYPE"></div>
				</td>
				<th>회원분류</th>
				<td>
					<div id="cmbMEM_ABC"></div>
				</td>
				<th>회원등급</th>
				<td>
					<div id="cmbGRADE_CD"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>