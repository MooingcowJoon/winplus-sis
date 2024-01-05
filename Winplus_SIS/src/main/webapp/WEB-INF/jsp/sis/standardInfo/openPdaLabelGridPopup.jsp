<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	LUI.exclude_auth_cd = "ALL,1,2";
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openPdaLabelGridPopup");

	var erpPopupLayout;
	var erpRibbon;
	var erpPopupGridColumns;
	var erpPopupGrid;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var paramORGN_DIV_CD = '${param.ORGN_DIV_CD}';
	var paramORGN_CD = '${param.ORGN_CD}';
	var paramDISABLE = '${param.DISABLE}';

	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("PDA내역불러오기");
		}
		
		initErpPopupLayout();
		initErpRibbon();
		initErpPopupGrid();
		initDhtmlXCombo();
		
		$erp.asyncObjAllOnCreated(function(){
			if(paramDISABLE == 'true'){
				cmbORGN_DIV_CD.disable();
				cmbORGN_CD.disable();
			}
		});
		
	});

	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
				, cells : [
					{id: "a", text: "검색조건영역", header:false, fix_size:[true, true]}
					,{id: "b", text: "리본영역", header:false, fix_size:[true, true]}
					,{id: "c", text: "그리드영역", header:false, fix_size:[true, true]}
					]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_search");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_popup_grid");
		
		erpPopupLayout.setSeparatorSize(0, 5);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupLayout.setSizes();
			erpPopupGrid.setSizes();
		});
	}
	
	function initErpRibbon() {
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon",
			skin : ERP_RIBBON_CURRENT_SKINS,
			icons_path : ERP_RIBBON_CURRENT_ICON_PATH,
			items : [{
				type : "block",
				mode : 'rows',
				list : [ 
					{id : "search_ribbon", type : "button", text : '<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					, {id : "delete_ribbon",type : "button",text : '<spring:message code="ribbon.delete" />',isbig : false,img : "menu/delete.gif",imgdis : "menu/delete_dis.gif",disable : true} 
					, {id : "add_ribbon",type : "button",text : '적용',isbig : false,img : "menu/apply.gif",imgdis : "menu/apply_dis.gif",disable : true} 
				]
			}]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId) {
			if(itemId == "search_ribbon") {
				searchPdaLabelList();
			}else if (itemId == "delete_ribbon") {
				deletePdaList();
			}else if(itemId == "add_ribbon") {
				applyPdaList();
			}
		});
	}
	
	function initErpPopupGrid(){
		erpPopupGridColumns = [
			  {id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}              
			  , {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			  , {id : "ORGN_DIV_CD", label:["법인구분", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			  , {id : "ORGN_CD", label:["조직명", "#rspan"], type: "combo", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : "ORGN_CD"}
			  , {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "GOODS_NO", label:["상품코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			  , {id : "GOODS_QTY", label:["매수", "#rspan"], type: "ron", width: "40", sort : "int", align : "right", isHidden : false, isEssential : false}
			  , {id : "DATA_TYPE", label:["DATA_TYPE", "#rspan"], type: "ro", width: "80", sort : "str", align : "center", isHidden : true, isEssential : false, isDisabled : true, commonCode : ["YN_CD", "BIT"]}
			  , {id : "FLAG_YN", label:["출력여부", "#rspan"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["YN_CD", "BIT"]}
			  , {id : "CUSER", label:["담당자", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			  , {id : "EMP_NO", label:["담당자", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			  , {id : "EMP_NM", label:["담당자", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "CDATE", label:["PDA등록일시", "#text_filter"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "STORE_AREA", label:["라벨그룹명", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpPopupGridColumns
		});
		
		erpPopupGridDataProcessor = $erp.initGrid(erpPopupGrid, {"rowSize" : 100, "multiSelect" : true, "useAutoAddRowPaste" : true, "deleteDuplication" : false, "overrideDuplication" : false , "editableColumnIdListOfInsertedRows" : ["GOODS_QTY"] , "notEditableColumnIdListOfInsertedRows" : ["ORGN_CD", "GOODS_NO", "BCD_NM", "BCD_CD"]});
	}
	
	function initDhtmlXCombo(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD","ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI,210, null, true, '${param.ORGN_DIV_CD}', function() {
					cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD","ORGN_CD", "/sis/code/getSearchableOrgnCdList.do",$erp.unionObjArray([ LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()} ]), 210, null, false, '${param.ORGN_CD}');
					cmbORGN_DIV_CD.attachEvent("onChange",function(value, text) {
								cmbORGN_CD.unSelectOption();
								cmbORGN_CD.clearAll();
								$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD,"/sis/code/getSearchableOrgnCdList.do",$erp.unionObjArray([ LUI, {ORGN_DIV_CD : value} ]), null, false, null);
					});
		});
	}
	
	function searchPdaLabelList(){
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/sis/LabelPrint/getPdaLabelList.do"
			,method : "POST"
			,dataType : "JSON"
			,data : {
				"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
				, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
			}
			,success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpPopupGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
								erpPopupGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpPopupGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function deletePdaList(){
		var gridRowCount = erpPopupGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpPopupGrid.getRowId(i);
			var check = erpPopupGrid.cells(rId, erpPopupGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(rId);
			}
		}
		
		for(var j = 0; j < deleteRowIdArray.length; j++){
			erpPopupGrid.deleteRow(deleteRowIdArray[j]);
		}
		
		if(deleteRowIdArray.length == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}else {
			var paramData = $erp.serializeDhtmlXGridData(erpPopupGrid);
			erpPopupLayout.progressOn();
			$.ajax({
				url : "/sis/LabelPrint/deletePdaLabelList.do"
				,method : "POST"
				,dataType : "JSON"
				,data : paramData
				,success : function(data){
					erpPopupLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						$erp.clearDhtmlXGrid(erpPopupGrid);
						var resultCNT = data.resultCNT;
						var total_cnt = data.total_cnt;
						$erp.alertMessage({
							"alertMessage" : resultCNT + "/" + total_cnt + " 건이 성공적으로 삭제되었습니다.",
							"alertType" : "info",
							"isAjax" : false,
							"alertCallbackFn" : searchPdaLabelList()
						});
					}
					$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	function applyPdaList(){
		if(erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK")) == ""){
			$erp.alertMessage({
				"alertMessage" : "1개이상의 상품을 선택 후 적용가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else {
			if(!$erp.isEmpty(erpPopupGoodsCheckList) && typeof erpPopupGoodsCheckList === 'function'){
				var paramMap = $erp.serializeDhtmlXGridData(erpPopupGrid);
				$.ajax({
					url : "/sis/LabelPrint/updatePdaLabelPrintState.do"
					,method : "POST"
					,dataType : "JSON"
					,data : paramMap
					,success : function(data){
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						} else {
							erpPopupGoodsCheckList(erpPopupGrid);
						}
					}, error : function(jqXHR, textStatus, errorThrown){
						erpPopupLayout.progressOff();
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
			}
		}
	}
</script>
</head>
<body>
	<div id="div_erp_popup_layout" class="samyang_div" style="display: none;">
		<div id="div_erp_popup_search" class="samyang_div" style="display: none;">
			<table id="table_search" class="table">
				<colgroup>
					<col width="90px">
					<col width="300px">
					<col width="90px">
					<col width="*">
				</colgroup>
				<tr>
					<th>법인구분</th>
					<td>
						<div id="cmbORGN_DIV_CD"></div>
					</td>
					<th>조직명</th>
					<td>
						<div id="cmbORGN_CD"></div>
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_popup_ribbon" class="samyang_div" style="display: none;"></div>
		<div id="div_erp_popup_grid" class="div_grid_full_size" style="display: none;"></div>
	</div>
</body>
</html>