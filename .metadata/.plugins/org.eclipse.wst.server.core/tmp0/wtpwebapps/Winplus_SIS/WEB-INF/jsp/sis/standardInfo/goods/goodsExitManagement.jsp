<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
		
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		--%>

	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var cmbSearch01;
	var cmbSearch02;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		
	})
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false}
				, {id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드영역", header:false}
			]
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(70);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
		
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>

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
					, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : false}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpGrid"){
				if(document.getElementById("hidGOODS_CATEG_CD").value == ""){
					$erp.alertMessage({
						"alertMessage" : "error.sis.goods.search.grup_nm.empty"
						, "alertCode" : "-1"
						, "alertType" : "error"
					});
				}
				else{
					searchCheck();
				}
			}else if (itemId == "save_erpGrid"){
				saveErpGrid();
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>

	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_M_CD", label:["모바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_NM", label:["상품명", "#rspan"], type: "ro", width: "280", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_STATE", label:["상품상태", "#rspan"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["GOODS_STATE"]}
			, {id : "CDATE", label:["상품등록일", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MDATE", label:["미사용/퇴출등록일", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MUSER", label:["등록자", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : false, isEssential : false}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		erpGrid.attachEvent("onKeyPress",onKeyPressed);
		erpGrid.enableBlockSelection();
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

	<%-- erpGrid 조회 확인 Function --%>
	function searchCheck(){
		var alertMessage = '<spring:message code="alert.sis.goods.searchCheck" />';
		var alertCode = "";
		var alertType = "alert";
		var callbackFunction = function(){
			SearchErpGrid(erpGrid, document.getElementById("hidGOODS_CATEG_CD").value);
		}
		
		var key_word = $("#txtKEY_WORD").val();
		var GRUP_CD = document.getElementById("hidGOODS_CATEG_CD").value;
		
		if(key_word == "" && GRUP_CD == "ALL"){
			$erp.confirmMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
				, "alertCallbackFn" : callbackFunction
			});
		}else{
			SearchErpGrid(erpGrid, document.getElementById("hidGOODS_CATEG_CD").value);
		}
		
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
	
	<%-- ■ SearchErpGrid 관련 Function 시작 --%>
	function SearchErpGrid(erpGrid) {
		if(!isSearchValidate()){
			return;
		}
		
		var paramData = {};
		paramData["TAX_YN"] = cmbSearch01.getSelectedValue();
		paramData["GRUP_CD"] = $('#hidGOODS_CATEG_CD').val();
		paramData["KEY_WORD"] = $("#txtKEY_WORD").val();
		paramData["SEARCH_TYPE"] = cmbGOODS_SECH_WORD_TYPE.getSelectedValue();
		paramData["GOODS_STATE"] = cmbSearch02.getSelectedValue();
		erpLayout.progressOn();
		$.ajax({
				url: "/sis/standardInfo/goods/getGoodsExitList.do"
				, data : paramData
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOn();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
								, '<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpGrid.parse(gridDataList, 'js');
							
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpGrid);
					erpLayout.progressOff();
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
	}
	<%-- ■ SearchErpGrid 관련 Function 끝 --%>
	
	<%-- ■ saveErpGrid 관련 Function 시작 --%>
	function saveErpGrid(){
		if(erpGridDataProcessor.getSyncState()){
				$erp.alertMessage({
					"alertMessage" : "error.common.noChanged"
					, "alertCode" : null
					, "alertType" : "error"
				});
				return false;
			}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpGrid);
			if(validResultMap.isError) {
				$erp.alertMessage({
					"alertMessage" : validResultMap.errMessage
					, "alertCode" : validResultMap.errCode
					, "alertType" : "error"
					, "alertMessageParam" : validResultMap.errMessageParam
				});
				return false;
			}
			
			erpLayout.progressOn();
			var paramData = $erp.serializeDhtmlXGridData(erpGrid);
			$.ajax({
				url : "/sis/standardInfo/goods/updateGoodsExitList.do"
				,data : paramData
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.alertSuccessMesage(onAfterSaveErpGrid);
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
	}
	<%-- ■ saveErpGrid 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 저장 후 Function --%>
	function onAfterSaveErpGrid(){
		searchCheck();
	}
	<%-- ■ saveErpGrid 저장 Function 끝--%>
	
	<%-- dhtmlXCombo 초기화 Function --%>   
	function initDhtmlXCombo(){
		cmbSearch01 = $erp.getDhtmlXCombo("cmbSearch01","cmbSearch01", "GOODS_TAX_YN", 100, "모두조회" , null);
		cmbSearch02 = $erp.getDhtmlXCombo("cmbSearch02", "cmbSearch02", "GOODS_STATE", 100, "모두조회", "X");
		cmbGOODS_SECH_WORD_TYPE = $erp.getDhtmlXCombo('cmbGOODS_SECH_WORD_TYPE', 'GOODS_SECH_WORD_TYPE', "GOODS_SECH_WORD_TYPE", 120, false, '');
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- onKeyPressed 저울상품 그룹Grid_Keypressed Function --%>
		function onKeyPressed(code,ctrl,shift){
			if(code==67&&ctrl){
				erpGrid.setCSVDelimiter("\t");
				erpGrid.copyBlockToClipboard()
			}
			
			if(code==86&&ctrl){
				erpGrid.setCSVDelimiter("\t");
				erpGrid.pasteBlockFromClipboard()
			}
			
			return true;
		}
		
	<%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
		function openGoodsCategoryTreePopup() {
			var onClick = function(id) {
				document.getElementById("hidGOODS_CATEG_CD").value = id;
				document.getElementById("txtGOODS_CATEG_NM").value = this.getItemText(id);
				
				$erp.closePopup2("openGoodsCategoryTreePopup");
			};
			$erp.openGoodsCategoryTreePopup(onClick);
		}
	
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_data1" class="table_search">
			<colgroup>
				<col width="70px">
				<col width="180px">
				<col width="70px">
				<col width="120px">
				<col width="70px">
				<col width="*">
			</colgroup>
			<tr>
				<th> 상품분류</th>
				<td>
					<input type="hidden" id="hidGOODS_CATEG_CD" value="ALL">
					<input type="text" id="txtGOODS_CATEG_NM" name="GOODS_CATEG_NM" value="전체분류" class="input_common input_readonly" maxlength="20" readonly="readonly">
					<input type="button" id="btnGoodsCategoryTree" class="input_common_button" value="검색" onclick="openGoodsCategoryTreePopup();" />
				</td>
				<th>과세구분</th>
				<td>
					<div id="cmbSearch01"></div>
				</td>
				<th>상품상태</th>
				<td>
					<div id="cmbSearch02"></div>
				</td>
			</tr>
		</table>
		<table id="tb_erp_data2" class="table_search">
		<colgroup>
			<col width="70px">
			<col width="*">
		</colgroup>
		<tr>
			<th>검색어</th>
			<td>
				<span id="cmbGOODS_SECH_WORD_TYPE" style="float:left;margin-right: 12px;"></span>
				<input type="text" id="txtKEY_WORD" name="txtKEY_WORD" class="input_common" maxlength="10" onkeydown="$erp.onEnterKeyDown(event, searchCheck);"/>
			</td>
			<!-- <th>바코드</th>
			<td>
				<input type="text" id="txtBCD_CD" name="txtBCD_CD" class="input_common" maxlength="10" onkeydown="$erp.onEnterKeyDown(event, searchCheck);"/>
			</td> -->
		</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>