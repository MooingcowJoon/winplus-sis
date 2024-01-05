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
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object/ 그리드변경사항 객체 DhtmlXDataProcessor
	--%>
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "리본영역", header:false, fix_size : [true, true]}
				, {id: "b", text: "그리드영역", header:false, fix_size : [true, true]}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_ribbon");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_grid");
		
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
						//{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
						{id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
						, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
						, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
						, {id : "excelForm_erpGrid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
						//, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpGrid"){
			} else if (itemId == "add_erpGrid"){
				addErpGrid();
			} else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
		    } else if (itemId == "save_erpGrid"){
		    	saveErpGrid();
		    } else if (itemId == "excel_erpGrid"){
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "상품일괄등록수정"
		    		, "isForm" : false
		    	});
		    } else if (itemId == "excelForm_erpGrid"){
		    	$erp.exportDhtmlXGridExcel({
		    		"grid" : erpGrid
		    		, "fileName" : "상품일괄등록수정양식"
		    		, "isForm" : true
		    	});
		    } else if (itemId == "print_erpGrid"){
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "HID_BCD_CD", label:["(자)바코드(히든)", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : false}
			, {id : "HID_BCD_M_CD", label:["(모)바코드(히든)", "#rspan"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : false}
			, {id : "BCD_CD", label:["(자)바코드", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			, {id : "BCD_M_CD", label:["(모)바코드", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			, {id : "OLD_NEW", label:["기존/신규", "#rspan"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : true}
			, {id : "BCD_NM", label:["상품명(바코드)", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			, {id : "GRUP_TOP_CD", label:["대분류코드", "#rspan"], type: "ro", width: "60", sort : "int", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			, {id : "GRUP_TOP_NM", label:["대분류", "#rspan"], type: "ed", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true}
			, {id : "GRUP_MID_CD", label:["중분류코드", "#rspan"], type: "ro", width: "60", sort : "int", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			, {id : "GRUP_MID_NM", label:["중분류", "#rspan"], type: "ed", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true}
			, {id : "GRUP_BOT_CD", label:["소분류코드", "#rspan"], type: "ro", width: "60", sort : "int", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			, {id : "GRUP_BOT_NM", label:["소분류", "#rspan"], type: "ed", width: "60", sort : "int", align : "center", isHidden : false, isEssential : true, isDataColumn : true}
			, {id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			, {id : "GOODS_NM", label:["상품명(대표)", "#text_filter"], type: "ed", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		erpGrid.attachEvent("onKeyPress",onKeyPressed);
		erpGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 1000);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGrid.attachEvent("onRowPaste", function(rId){   //엑셀붙여넣기시 자동으로 행추가
			var tmpRowIndex = erpGrid.getRowIndex(rId);
			if(erpGrid.getRowId((tmpRowIndex+1)) == null || erpGrid.getRowId((tmpRowIndex+1)) == "null" || erpGrid.getRowId((tmpRowIndex+1)) == undefined || erpGrid.getRowId((tmpRowIndex+1)) == "undefined" ){
				addErpGrid();
			}
			
			//처음 입력한 바코드와 다를 경우 정보 가져오기(최초 붙여넣기 시, 붙여넣은 내용 변경 붙여넣기 시)
			if(
				(erpGrid.cells(rId,erpGrid.getColIndexById("BCD_CD")).getValue() != erpGrid.cells(rId,erpGrid.getColIndexById("HID_BCD_CD")).getValue())
					||
				(erpGrid.cells(rId,erpGrid.getColIndexById("BCD_M_CD")).getValue() != erpGrid.cells(rId,erpGrid.getColIndexById("HID_BCD_M_CD")).getValue())
			){
				getGoodsInformation(rId);
			}
		});
		
		erpGrid.attachEvent("onEnter", function(rId, Ind){
			if(
				(erpGrid.cells(rId,erpGrid.getColIndexById("BCD_CD")).getValue() != erpGrid.cells(rId,erpGrid.getColIndexById("HID_BCD_CD")).getValue())
					||
				(erpGrid.cells(rId,erpGrid.getColIndexById("BCD_M_CD")).getValue() != erpGrid.cells(rId,erpGrid.getColIndexById("HID_BCD_M_CD")).getValue())
			){
				getGoodsInformation(rId);
			}
		});
		
		erpGrid.attachEvent("onEditCell", function(stage, rId, Ind){
			if(
				(erpGrid.cells(rId,erpGrid.getColIndexById("BCD_CD")).getValue() != erpGrid.cells(rId,erpGrid.getColIndexById("HID_BCD_CD")).getValue())
					||
				(erpGrid.cells(rId,erpGrid.getColIndexById("BCD_M_CD")).getValue() != erpGrid.cells(rId,erpGrid.getColIndexById("HID_BCD_M_CD")).getValue())
			){
				getGoodsInformation(rId);
			}
		});
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
	}
	
	<%-- addErpGrid 추가 Function --%>
	function addErpGrid(){
		var uid = erpGrid.uid();
		erpGrid.addRow(uid);
		erpGrid.selectRow(erpGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	function deleteErpGrid(){
		var rId = erpGrid.getSelectedRowId();
		if(rId != null){
			erpGrid.deleteRow(rId);
		}
	}
	
	<%-- saveErpGrid 저장 Function --%>
	function saveErpGrid() {
		var allIds = erpGrid.getAllRowIds(",");
		var allIdArray = allIds.split(",");
		if(allIds != ""){
			var lastRowId = allIdArray[allIdArray.length-1];
			var lastRowCheck = erpGrid.cells(lastRowId, erpGrid.getColIndexById("BCD_CD")).getValue();
			if(lastRowCheck == null || lastRowCheck == "null" || lastRowCheck == undefined || lastRowCheck == "undefined" || lastRowCheck == "") {
				erpGrid.deleteRow(lastRowId);//grid row에서 삭제
				allIdArray.splice(allIdArray.length-1);//array 에서 삭제
			}
		}
		
		if(erpGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpGrid);
		
		//신규상품 일 경우 (자)바코드와 (모)바코드 일치 확인
		var tmpDataRows = erpGridDataProcessor.updatedRows;
		var tmpValidTF = true;
		var tmpValidRow;
		for(var i=0; i<tmpDataRows.length; i++){
			if(
					erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("BCD_CD")).getValue() != erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("BCD_M_CD")).getValue()
					&& erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("OLD_NEW")).getValue() == "신규상품"
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1001";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
			if(
					erpGrid.cells(tmpDataRows[i],erpGrid.getColIndexById("BCD_NM")).getValue().length > 50
			){
				tmpValidTF = false;
				validResultMap.isError = true;
				validResultMap.errCode = "-1002";
				tmpValidRow = erpGrid.getRowIndex(tmpDataRows[i]);
				break;
			}
		}
		
		if(!tmpValidTF){
			if(validResultMap.errCode == "-1001"){
				validResultMap.errMessage = "error.sis.goods.b_code.not_match_b_m_code";
			}else if(validResultMap.errCode == "-1002"){
				validResultMap.errMessage = "error.sis.goods.b_code_nm.length50Over";
			}
			validResultMap.errRowIdx = [(tmpValidRow+1)];
			validResultMap.errMessageParam = [(tmpValidRow+1)];
		}
		
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		var deleteRowIdArray = [];
		var t_goods_nm = "";
		for(var i=0; i<allIdArray.length; i++) {
			t_goods_nm = erpGrid.cells(allIdArray[i], erpGrid.getColIndexById("GOODS_NM")).getValue();
			if(t_goods_nm == "조회정보없음"){
				deleteRowIdArray.push(allIdArray[i]);
			}
		}
		
		for(var j=0; j<deleteRowIdArray.length; j++){
			erpGrid.deleteRow(deleteRowIdArray[j]);
		}
		
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);
		/* 
		var orgn_cd = cmbORGN_CD.getChecked();
		var orgn_cd_text = cmbORGN_CD.getComboText();
		if(orgn_cd_text == "전체"){
			orgn_cd_text = "ALL";
		}else{
			orgn_cd_text = orgn_cd.join(",");
		}
		paramData["ORGN_CD"] = orgn_cd_text;
		 */
		$.ajax({
			url : "/sis/standardInfo/goods/updateBatchGoodsInformation.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var dataMsg = "";
					dataMsg = dataMsg+"상품신규등록 : "+data.NEW_GOODS_CNT+"건<br>";
					dataMsg = dataMsg+"상품내용변경 : "+data.MODIFY_GOODS_CNT+"건<br>";
					dataMsg = dataMsg+"상품저장실패 : "+data.FAIL_GOODS_CNT+"건<br>";
					dataMsg = dataMsg+"바코드신규등록 : "+data.NEW_BARCODE_CNT+"건<br>";
					dataMsg = dataMsg+"바코드내용변경 : "+data.MODIFY_BARCODE_CNT+"건<br>";
					dataMsg = dataMsg+"바코드저장실패 : "+data.FAIL_BARCODE_CNT+"건<br>";
					$erp.alertMessage({
						"alertMessage" : dataMsg
						,"alertCode" : null
						, "alertType" : "info"
						,"isAjax" : false
						,"alertCallbackFn" : onAfterSaveErpGrid
					});
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpGrid 저장 후 Function --%>
	function onAfterSaveErpGrid(){
		$erp.clearDhtmlXGrid(erpGrid);
	}
	
	<%-- onKeyPressed erpGrid Function --%>
	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			erpGrid.setCSVDelimiter("\t");
			erpGrid.copyBlockToClipboard();
		}
		if(code==86&&ctrl){
			erpGrid.setCSVDelimiter("\t");
			erpGrid.pasteBlockFromClipboard();
		}
		return true;
	}
	
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- getGoodsInformation 상품정보 가져오기 Function --%>
	
	function getGoodsInformation(rId) {
		var bcd_cd = erpGrid.cells(rId, erpGrid.getColIndexById("BCD_CD")).getValue();
		var bcd_m_cd = erpGrid.cells(rId, erpGrid.getColIndexById("BCD_M_CD")).getValue();
		erpGrid.cells(rId, erpGrid.getColIndexById("HID_BCD_CD")).setValue(bcd_cd);
		erpGrid.cells(rId, erpGrid.getColIndexById("HID_BCD_M_CD")).setValue(bcd_m_cd);
		
		//(자)바코드와 (모)바코드가 다를 경우 (모)바코드의 상품정보를 가져오도록 함
		if(bcd_cd != bcd_m_cd){
			bcd_cd = bcd_m_cd;
		}
		
		$.ajax({
			url : "/sis/standardInfo/goods/getGoodsInformationFromBarcode.do"
			,data : {
				"BCD_CD" : bcd_cd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					if(data.OLD_NEW == "신규상품"){
						erpGrid.setRowColor(rId,"pink");
					}else if(data.OLD_NEW == "등록불가바코드"){
						erpGrid.setRowColor(rId,"#fff98c");
					}else{
						erpGrid.setRowColor(rId,"white");
					}
					erpGrid.cells(rId, erpGrid.getColIndexById("OLD_NEW")).setValue(data.OLD_NEW);
					erpGrid.cells(rId, erpGrid.getColIndexById("BCD_NM")).setValue(data.BCD_NM);
					erpGrid.cells(rId, erpGrid.getColIndexById("GOODS_NO")).setValue(data.GOODS_NO);
					erpGrid.cells(rId, erpGrid.getColIndexById("GOODS_NM")).setValue(data.GOODS_NM);
					erpGrid.cells(rId, erpGrid.getColIndexById("GRUP_TOP_CD")).setValue(data.GRUP_TOP_CD);
					erpGrid.cells(rId, erpGrid.getColIndexById("GRUP_TOP_NM")).setValue(data.GRUP_TOP_NM);
					erpGrid.cells(rId, erpGrid.getColIndexById("GRUP_MID_CD")).setValue(data.GRUP_MID_CD);
					erpGrid.cells(rId, erpGrid.getColIndexById("GRUP_MID_NM")).setValue(data.GRUP_MID_NM);
					erpGrid.cells(rId, erpGrid.getColIndexById("GRUP_BOT_CD")).setValue(data.GRUP_BOT_CD);
					erpGrid.cells(rId, erpGrid.getColIndexById("GRUP_BOT_NM")).setValue(data.GRUP_BOT_NM);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		})
	}
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		//cmbORGN_CD = $erp.getDhtmlXComboMulti('cmbORGN_CD', 'ORGN_CD', 'MK_CD', 120, "전체");
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>