<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js?ver=33"></script>
<script type="text/javascript">

	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');

	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var paramData = {};
	
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var cmbPUR_SALE_TYPE;
	var cmbUSE_YN;
	var isValidPage;	//페이지가 정상적으로 로드되었는지
	
	$(document).ready(function(){
		if("${menuDto.menu_cd}" == "00499"){
			pageType = "협력사";
			isValidPage = true;
			LUI.exclude_auth_cd = "ALL,1,2";
		}else if("${menuDto.menu_cd}" == "00741"){
			pageType = "고객사";
			isValidPage = true;
			LUI.exclude_auth_cd = "ALL,1,5,6";
			LUI.exclude_orgn_type = "MK";
		}else{
			isValidPage = false;
		}
		
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		
		initDhtmlXCombo();
		
		$erp.asyncObjAllOnCreated(function(){
			cmbPUR_SALE_TYPE.disable();
			searchErpGrid();
		});
	});

	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "조직별거래처리스트", header: true}
				, {id : "b", text: "ribbon", header: false, fix_size:[true, true]}
				, {id : "c", text: "grid", header: false}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight(65);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	function initErpRibbon() {
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					,{id : "add_erpGrid"   , type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					,{id : "save_erpGrid"  , type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchErpGrid();
			} else if (itemId == "add_erpGrid"){
				openSearchCustmrGridPopup();
			} else if (itemId == "save_erpGrid"){
				saveErpGrid();
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_CD", label:["조직명", "#rspan"], type: "combo", width: "110", sort : "str", align : "left", isHidden : false, isEssential : false, commonCode : ["ORGN_CD"], isDisabled : true}
			, {id : "PUR_SALE_TYPE", label:["거래구분", "#rspan"], type: "combo", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false, commonCode : ["PUR_SALE_TYPE"], isDisabled : true}
			, {id : "CUSTMR_GRUP", label:["거래처유형", "#rspan"], type: "combo", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false, commonCode : ["CUSTMR_GRUP"], isDisabled : true}
			, {id : "CUSTMR_CD", label:["거래처코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CUSTMR_NM", label:["거래처명", "#rspan"], type: "ro", width: "230", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CORP_NO", label:["사업자번호", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CUSTMR_CEONM", label:["대표자명", "#rspan"], type: "ro", width: "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "RESP_USER_NM", label:["담당자", "#rspan"], type: "ro", width: "130", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "USE_YN", label:["사용여부", "#rspan"], type: "combo", width: "70", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["USE_CD","YN"]}
			, {id : "CUSER", label:["등록자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "CDATE", label:["등록일시", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MUSER", label:["수정자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MDATE", label:["수정일시", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
			
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
		erpGrid.enableAccessKeyMap(true);
		erpGrid.enableColumnMove(true);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 조회 Function 시작 --%>
	function searchErpGrid(){
		paramData["SEARCH_WORD"] = document.getElementById("txtSEARCH_WORD").value;
		paramData["PUR_SALE_TYPE"] =cmbPUR_SALE_TYPE.getSelectedValue();
		paramData["ORGN_DIV_CD"] = cmbORGN_DIV_CD.getSelectedValue();
		paramData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		paramData["USE_YN"] = cmbUSE_YN.getSelectedValue();
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/basic/getCustmrByWorkplace.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
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
	<%-- ■ erpGrid 조회 Function 끝 --%>
	
	<%-- openSearchCustmrGridPopup 공급사 조회 팝업 열림 Function 시작 --%>
	function openSearchCustmrGridPopup() {
		var PUR_SALE_TYPE = cmbPUR_SALE_TYPE.getSelectedValue();
		var ORGN_DIV_CD = cmbORGN_DIV_CD.getSelectedValue();
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		
		if(PUR_SALE_TYPE == ""){
			$erp.alertMessage({
				"alertMessage" : "거래구분 선택 후 이용가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else if(ORGN_CD == ""){
			$erp.alertMessage({
				"alertMessage" : "추가등록을 위해 법인구분, 조직명을<br> 선택 해 주세요.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else if(PUR_SALE_TYPE == "1"){
			var pur_sale_type = "1"; //협력사(매입처) == "1"
			var onRowSelect = function(id, ind) {			
				custmr_cd = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
				$.ajax({
					url : "/sis/basic/getCustmrInfo.do"
					,data : {
						"CUSTMR_CD" : custmr_cd
					}
					,method : "POST"
					,dataType : "JSON"
					,success : function(data){
						erpLayout.progressOff();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						} else {
							var gridDataList = data.gridDataList;
							if($erp.isEmpty(gridDataList)){
							} else {
								var uid = erpGrid.uid();
								erpGrid.addRow(uid,null,0);
								erpGrid.cells(uid, erpGrid.getColIndexById("ORGN_CD")).setValue(ORGN_CD);
								erpGrid.cells(uid, erpGrid.getColIndexById("USE_YN")).setValue("Y");
								erpGrid.cells(uid, erpGrid.getColIndexById("CUSTMR_CD")).setValue(gridDataList[0].CUSTMR_CD);
								erpGrid.cells(uid, erpGrid.getColIndexById("PUR_SALE_TYPE")).setValue(gridDataList[0].PUR_SALE_TYPE);
								erpGrid.cells(uid, erpGrid.getColIndexById("CUSTMR_GRUP")).setValue(gridDataList[0].CUSTMR_GRUP);
								erpGrid.cells(uid, erpGrid.getColIndexById("CUSTMR_NM")).setValue(gridDataList[0].CUSTMR_NM);
								erpGrid.cells(uid, erpGrid.getColIndexById("CORP_NO")).setValue(gridDataList[0].CORP_NO);
								erpGrid.cells(uid, erpGrid.getColIndexById("CUSTMR_CEONM")).setValue(gridDataList[0].CUSTMR_CEONM);
								erpGrid.cells(uid, erpGrid.getColIndexById("RESP_USER_NM")).setValue(gridDataList[0].RESP_USER_NM);
								$erp.setDhtmlXGridFooterRowCount(erpGrid);
							}
						}
					}, error : function(jqXHR, textStatus, errorThrown){
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
				$erp.closePopup2("openSearchCustmrGridPopup");
			}
			$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
		}else if(PUR_SALE_TYPE == "2"){
			var pur_sale_type = "2"; //고객사(매출처) == "2"
			var onRowSelect = function(id, ind) {			
				custmr_cd = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
				$.ajax({
					url : "/sis/basic/getCustmrInfo.do"
					,data : {
						"CUSTMR_CD" : custmr_cd
					}
					,method : "POST"
					,dataType : "JSON"
					,success : function(data){
						erpLayout.progressOff();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						} else {
							var gridDataList = data.gridDataList;
							if($erp.isEmpty(gridDataList)){
							} else {
								var uid = erpGrid.uid();
								erpGrid.addRow(uid,null,0);
								erpGrid.cells(uid, erpGrid.getColIndexById("ORGN_CD")).setValue(ORGN_CD);
								erpGrid.cells(uid, erpGrid.getColIndexById("USE_YN")).setValue("Y");
								erpGrid.cells(uid, erpGrid.getColIndexById("CUSTMR_CD")).setValue(gridDataList[0].CUSTMR_CD);
								erpGrid.cells(uid, erpGrid.getColIndexById("PUR_SALE_TYPE")).setValue(gridDataList[0].PUR_SALE_TYPE);
								erpGrid.cells(uid, erpGrid.getColIndexById("CUSTMR_GRUP")).setValue(gridDataList[0].CUSTMR_GRUP);
								erpGrid.cells(uid, erpGrid.getColIndexById("CUSTMR_NM")).setValue(gridDataList[0].CUSTMR_NM);
								erpGrid.cells(uid, erpGrid.getColIndexById("CORP_NO")).setValue(gridDataList[0].CORP_NO);
								erpGrid.cells(uid, erpGrid.getColIndexById("CUSTMR_CEONM")).setValue(gridDataList[0].CUSTMR_CEONM);
								erpGrid.cells(uid, erpGrid.getColIndexById("RESP_USER_NM")).setValue(gridDataList[0].RESP_USER_NM);
								$erp.setDhtmlXGridFooterRowCount(erpGrid);
							}
						}
					}, error : function(jqXHR, textStatus, errorThrown){
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
				$erp.closePopup2("openSearchCustmrGridPopup");
			}
			
			$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
		}
	}
	<%-- openSearchCustmrGridPopup 공급사 조회 팝업 열림 Function 끝 --%>
	
	<%-- ■ erpGrid 저장 Function 시작 --%>
	function saveErpGrid(){
		var gridRowCount = erpGrid.getRowsNum();
		var lastRowNum = gridRowCount-1;
		var lastRid = erpGrid.getRowId(lastRowNum);
		var lastRowcheck = erpGrid.cells(lastRid, erpGrid.getColIndexById("CUSTMR_CD")).getValue();
		if(lastRowcheck == null || lastRowcheck == "null" || lastRowcheck == undefined || lastRowcheck == "undefined" || lastRowcheck == "") {
			erpGrid.deleteRow(lastRid);
		}
		
		if(erpGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
			
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);
		$.ajax({
			url : "/sis/basic/saveCustmrByWorkplace.do"
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
	<%-- ■ erpGrid 저장 Function 끝 --%>
	
	<%-- erpGrid 저장 후 Function 시작 --%>
	function onAfterSaveErpGrid(){
		searchErpGrid();
	}
	<%-- erpGrid 저장 후 Function 끝 --%>
	
	
	<%-- ■ onKeyPressed 이종상품그룹 목록Grid_Keypressed Function 시작 --%>
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
	<%-- ■ onKeyPressed 이종상품그룹 목록Grid_Keypressed Function 끝--%>
	
	<%-- dhtmlxCombo 초기화 Function 시작--%>
	function initDhtmlXCombo(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 170, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 120, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			}); 
		});
		
		if(pageType == "협력사"){
			cmbPUR_SALE_TYPE = $erp.getDhtmlXComboCommonCode("cmbPUR_SALE_TYPE", "cmbPUR_SALE_TYPE", ["PUR_SALE_TYPE"], 100, null, false,"1" , false);
		}else if(pageType == "고객사"){
			cmbPUR_SALE_TYPE = $erp.getDhtmlXComboCommonCode("cmbPUR_SALE_TYPE", "cmbPUR_SALE_TYPE", ["PUR_SALE_TYPE"], 100, null, false,"2" ,false);
		}
		
		cmbUSE_YN = $erp.getDhtmlXComboCommonCode('cmbUSE_YN', 'USE_CD',['USE_CD', 'YN'], 100, null, false);
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_table" class="samyang_div" style="display:none;">
		<table id = "tb_search" class = "table_search">
				<colgroup>
					<col width="80px"/>
					<col width="150px"/>
					<col width="80px"/>
					<col width="120px"/>
					<col width="80px"/>
					<col width="175px"/>
					<col width="70px"/>
					<col width="130px"/>
					<col width="70px"/>
					<col width="*px"/>
				</colgroup>
				<tr>
					<th>검색어</th>
					<td><input type="text" id="txtSEARCH_WORD" name="txtSEARCH_WORD" class="input_common" maxlength="500" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid);"></td>
					<th>거래구분</th>
					<td><div id="cmbPUR_SALE_TYPE"></div> </td>
					<th>법인구분</th>
					<td><div id="cmbORGN_DIV_CD"></div></td>
					<th>조직명</th>
					<td><div id="cmbORGN_CD"></div></td>
					<th>사용여부</th>
					<td><div id="cmbUSE_YN"></div></td>
				</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none;"></div>
</body>
</html>