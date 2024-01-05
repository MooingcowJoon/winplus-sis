<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<%-- <jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/> --%><!-- 기존 -->
<jsp:include page="/WEB-INF/jsp/common/include/default_new_window_script_header.jsp"/><!-- 대체 -->
<script type="text/javascript">
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2,3";
	
	/* 조회컬럼내용 수정 필요 (수정진행중_필요하신사항은 요청주세요.) */
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("autoBindSearchGoodsPopup");
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;
	
	var cmbGOODS_SECH_WORD_TYPE;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	
	//사용자정의함수는 보내는 키 문자열 값과 동일해야 합니다.
	var erpPopupGoodsCheckList;
	var erpPopupGoodsOnRowDblClicked;
	var erpPopupGoodsOnKeyDownEsc;
	
	var param_ORGN_DIV_CD = "${param.ORGN_DIV_CD}";
	var param_ORGN_CD = "${param.ORGN_CD}";
	var param_SHOW_TYPE = "${param.SHOW_TYPE}";
	var param_SEARCH_AUTO = "${param.SEARCH_AUTO}";
	var param_KEY_WORD = "${param.KEY_WORD}";
	var param_BCD_MS_TYPE = "${param.BCD_MS_TYPE}";
	
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("상품조회");	
		}
		initErpPopupLayout();
		initErpPopupRibbon();
		initErpPopupGrid();
		initDhtmlXCombo();
		
		$erp.asyncObjAllOnCreated(function(){
			if(param_SHOW_TYPE != "true"){
				if(param_ORGN_CD != "" && AUTHOR_CD != "99999"){
					cmbORGN_DIV_CD.disable();
					cmbORGN_CD.disable();
				}
			}
			initPageOnLoad();
		});
	});
	
	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "조회조건영역", header : false}
				, {id:"b", text: "리본영역", header : false, fix_size:[true, true]}
				, {id:"c", text: "그리드영역", header : false}
			]
		});
		erpPopupLayout.cells("a").attachObject("div_erp_contents_search");
		if(param_SHOW_TYPE == "true"){
			erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		}else {
			erpPopupLayout.cells("a").setHeight(65);
		}
		erpPopupLayout.cells("b").attachObject("div_erp_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_grid");
		
		erpPopupLayout.setSeparatorSize(1,0);
		<%-- erpPopupLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupGrid.setSizes();
		});
	}
	
	
	<%-- ■ erpPopupRibbon 관련 Function 시작 --%>
	function initErpPopupRibbon(){
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
				]}							
			]
		});
		
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchErpGrid();
			} else if(itemId == "add_erpGrid"){
				addErpGridData();
			}
		});
	}
	<%-- ■ erpPopupRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpPopupGrid 관련 Function 시작 --%>	
	function initErpPopupGrid(){
		erpPopupGridColumns = [
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			,{id : "ORGN_CD", label:["조직명"], type: "combo", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : true, isDisabled: true, commonCode : ["ORGN_CD", "", "", "", "", "MK"]}
			,{id : "GOODS_TOP_CD", label:["대분류코드"], type: "ro", width: "120", sort : "int", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			,{id : "GOODS_MID_CD", label:["중분류코드"], type: "ro", width: "120", sort : "int", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			,{id : "GOODS_BOT_CD", label:["소분류코드"], type: "ro", width: "120", sort : "int", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			,{id : "GOODS_NM", label:["상품명"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : true}
			,{id : "GOODS_NO", label:["상품코드"], type: "ro", width: "120", sort : "int", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			,{id : "BCD_M_CD", label:["모바코드"], type: "ro", width: "120", sort : "int", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			,{id : "BCD_CD", label:["바코드"], type: "ro", width: "97", sort : "int", align : "left", isHidden : false, isEssential : false, isDataColumn : true}
			,{id : "DIMEN_NM", label:["규격"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "UNIT_CD", label:["단위"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : "UNIT_CD"}
			,{id : "UNIT_QTY", label:["입수량"], type: "ron", width: "80", sort : "int", align : "center", isHidden : true, isEssential : false}
			,{id : "DIMEN_WGT", label:["중량(g)"], type: "ron", width: "80", sort : "int", align : "left", isHidden : true, isEssential : false}
			,{id : "BCD_BOX_CD", label:["박스바코드"], type: "ro", width: "100", sort : "int", align : "center", isHidden : true, isEssential : false}
			,{id : "BCD_STOCK_CD", label:["재고소진바코드"], type: "ro", width: "100", sort : "int", align : "center", isHidden : true, isEssential : false}
		];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpPopupGridColumns
		});		
		erpPopupGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPopupGrid);
		$erp.initGridComboCell(erpPopupGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpPopupGrid);
		erpGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpPopupGrid);
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid, 100);
		
		erpPopupGrid.attachEvent("onEnter", function(id,ind){
			addErpGridData();
		});
	}
	
	<%-- erpPopupGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		var txtSearch1 = document.getElementById("txtSearch1").value;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(txtSearch1) || txtSearch1.length < 2) {
			isValidated = false;
			alertMessage = "error.sis.goods.search.notEnoughLength";
			alertCode = "-1";
		}
		
		if($erp.isLengthOver(txtSearch1, 50)){
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
	
	<%-- erpPopupGrid 조회 Function --%>
	function searchErpGrid(){
		if(!isSearchValidate()){
			return;
		}
		
		if(!$erp.isEmpty(erpPopupGoodsOnRowDblClicked) && typeof erpPopupGoodsOnRowDblClicked === 'function'){
			erpPopupGrid.attachEvent("onRowDblClicked", erpPopupGoodsOnRowDblClicked);
		}
		
		if(!$erp.isEmpty(erpPopupGoodsOnKeyDownEsc) && typeof erpPopupGoodsOnKeyDownEsc === 'function'){
			erpPopupGrid.attachEvent("onKeyPress", erpPopupGoodsOnKeyDownEsc);
		}
		
		erpPopupLayout.progressOn();
		var searchType = cmbGOODS_SECH_WORD_TYPE.getSelectedValue();
		var txtSearch1 = $("#txtSearch1").val();
		var ORGN_DIV_CD = "";
		var ORGN_CD = "";
		
		if(param_SHOW_TYPE != "true"){
			ORGN_DIV_CD = cmbORGN_DIV_CD.getSelectedValue();
			ORGN_CD = cmbORGN_CD.getSelectedValue();
		}
		
		$.ajax({
			url : "/common/popup/getGoodsList.do"
			,data : {
				"KEY_WORD" : txtSearch1
				, "SECH_TYPE" : searchType
				, "ORGN_DIV_CD" : ORGN_DIV_CD
				, "ORGN_CD" : ORGN_CD
				, "BCD_MS_TYPE" : param_BCD_MS_TYPE
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpPopupGrid);
					var GoodsList = data.GoodsList;
					if($erp.isEmpty(GoodsList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupGrid
							, '<spring:message code="grid.noSearchData" />'
						);
						document.getElementById("txtSearch1").focus();
					} else {
						erpPopupGrid.parse(GoodsList, 'js');
						window.setTimeout(function(){
							document.getElementById("txtSearch1").focus();
							document.getElementById("txtSearch1").blur();
							erpPopupGrid.selectCell(0,erpPopupGrid.getColIndexById("CHECK"),false,false,true);
						},1);
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function addErpGridData() {
		var Check_YN = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK"));
		if(Check_YN != ""){
			if(!$erp.isEmpty(erpPopupGoodsCheckList) && typeof erpPopupGoodsCheckList === 'function'){
	 			erpPopupGoodsCheckList(erpPopupGrid);
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
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbGOODS_SECH_WORD_TYPE = $erp.getDhtmlXComboCommonCode('cmbGOODS_SECH_WORD_TYPE', 'SearchWord','GOODS_SECH_WORD_TYPE', 80, false, false);

		if(param_SHOW_TYPE == "true"){
			$("#ORGN_DIV_TITLE").css("display", "none");
			$("#ORGN_TITLE").css("display", "none");
			$("#cmbORGN_DIV_CD").css("display", "none");
			$("#cmbORGN_CD").css("display", "none");
		}else{
			
			if(param_ORGN_DIV_CD != ""){
				cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, param_ORGN_DIV_CD, function(){
					cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, param_ORGN_CD);
				});
			} else {
				cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, null, function(){
					cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, null, false, null);
					cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
						cmbORGN_CD.unSelectOption();
						cmbORGN_CD.clearAll();
						$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), null, false, null);
					}); 
				});
			}
		}
	} 
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ 기타 Function 시작 --%>
	function initPageOnLoad(){
		if(param_SEARCH_AUTO == "Y"){
			document.getElementById("txtSearch1").value = param_KEY_WORD;
			searchErpGrid();
		}else{
			document.getElementById("txtSearch1").focus();
		}
	}
	
	function enterSearchToGrid(kcode){
		if(kcode == 13){//enter
			searchErpGrid();
		}
		if(kcode == 27){//esc
			if(!$erp.isEmpty(erpPopupGoodsOnKeyDownEsc) && typeof erpPopupGoodsOnKeyDownEsc === 'function'){
				erpPopupGoodsOnKeyDownEsc(kcode);
			}
		}
	}
	<%-- ■ 기타 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="100px">
				<col width="220px">
				<col width="60px">
				<col width="*">				
			</colgroup>
			<tr>
				<th id="ORGN_DIV_TITLE">법인구분</th>
				<td><div id="cmbORGN_DIV_CD"></div></td>
				<th id="ORGN_TITLE">조직명</th>
				<td><div id="cmbORGN_CD"></div></td>
			</tr>
			<tr>
				<th>검색어</th>
				<td colspan="3">
					<span id="cmbGOODS_SECH_WORD_TYPE" style="float:left;"></span>
					<input type="text" id="txtSearch1" size="12" maxlength="50" onkeydown="enterSearchToGrid(event.keyCode);" style="margin-left:5px;">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>