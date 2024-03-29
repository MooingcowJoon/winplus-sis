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
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 메뉴별화면 조회 DhtmlXGrid
		■ erpGridColumns : Array / erpGrid DhtmlXGrid Header
		■ erpGridDataProcessor : Object/ erpGridDataProcessor DhtmlXDataProcessor
		■ erpDetailGridDataProcessor : Object/ erpGridDataProcessor DhtmlXDataProcessor
		
		■ erpDetailSubLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpDetailRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpDetailGrid : Object / 화면 조회 DhtmlXGrid
		■ erpDetailGridColumns : Array / erpDetailGrid DhtmlXGrid Header
		■ erpDetailGridDataProcessor : Object/ erpDetailGrid DhtmlXDataProcessor
		
	--%>
	var erpLayout;
	
	var erpSubLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	
	var erpDetailSubLayout;
	var erpDetailRibbon;
	var erpDetailGrid;
	var erpDetailGridColumns;
	
	var erpGridDataProcessor;
	var erpDetailGridDataProcessor;
	
	var selected_prst_cd;
	var selected_orgn_div_cd;
	var selected_orgn_cd;
	
	var cmbSearch;
	
	// 관리자 로그인시, 선택하여 프리셋그룹 조회할수 있도록 수정필요
	$(document).ready(function(){		
		initErpLayout();		
		
		initErpSubLayout();
		initErpRibbon();
		initErpGrid();
		
		initErpDetailSubLayout();
		initErpDetailRibbon();
		initErpDetailGrid();
		
		$erp.asyncObjAllOnCreated(function(){
			initDhtmlXCombo();
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3T"
			, cells: [
				{id: "a", text: "점포선택영역", header:false}
				, {id: "b", text: "프리셋 그룹관리", header:true, width:410}
				, {id: "c", text: "프리셋그룹별 상품상세", header:true}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_select_combo");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_sub_layout");
		erpLayout.cells("c").attachObject("div_erp_detail_sub_layout");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpSubLayout.setSizes();
			erpDetailSubLayout.setSizes();
			erpGrid.setSizes();
			erpDetailGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%--
	**********************************************************************
	* ※ Master 영역
	**********************************************************************
	--%>	
	
	<%-- ■ erpSubLayout 관련 Function 시작 --%>
	<%-- erpSubLayout 초기화 Function --%>
	function initErpSubLayout(){
		erpSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				 {id: "a", text: "", header:false, fix_size : [false, true]}
				, {id: "b", text: "", header:false}
			]		
			, fullScreen : true
		});
		erpSubLayout.cells("a").attachObject("div_erp_ribbon");
		erpSubLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpSubLayout.cells("b").attachObject("div_erp_grid");
		
		erpSubLayout.setSeparatorSize(1, 0);
	}	
	<%-- ■ erpSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					 {id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					, {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchErpGrid(cmbSearch.getSelectedValue());
			}else if (itemId == "add_erpGrid"){
				addErpGrid();
		    } else if (itemId == "delete_erpGrid"){
		    	deleteErpGrid();
		    } else if (itemId == "save_erpGrid"){
		    	saveErpGrid();
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	
	<%-- erpGrid 추가 Function --%>
	function addErpGrid(){
		var selected_MK = cmbSearch.getSelectedValue();
		/* var DIV3 = cmbSearch.getOption(selected_MK)["DIV3"];
		console.log(DIV3); */
		if(selected_MK == ""){
			$erp.alertMessage({
				"alertMessage" : "프리셋을 추가할 조직명을 상단에서 선택 후<br> 다시 눌러주세요.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else {
			var uid = erpGrid.uid();
			erpGrid.addRow(uid);
			erpGrid.selectRow(erpGrid.getRowIndex(uid));
			erpGrid.cells(uid, erpGrid.getColIndexById("ORGN_CD")).setValue(selected_MK);
			erpGrid.cells(uid, erpGrid.getColIndexById("USE_YN")).setValue("Y");
			$erp.setDhtmlXGridFooterRowCount(erpGrid);
		}
	}
	
	function deleteErpGrid(){
		var gridRowCount = erpGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		
		
		var deleteRowIdArray = [];
		var check = "";
		
		for(var i = 0 ; i < RowCountArray.length ; i++){
			check = erpGrid.cells(RowCountArray[i], erpGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(RowCountArray[i]);
			}
		}
		
		if(deleteRowIdArray.length == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}
		
		for(var j = 0; j < deleteRowIdArray.length; j++){
			erpGrid.deleteRow(deleteRowIdArray[j]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	function saveErpGrid() {
		
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
		paramData["ORGN_CD"] = cmbSearch.getSelectedValue();
		console.log(paramData);
		$.ajax({
			url : "/sis/preset/SavePresetList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					searchErpGrid(cmbSearch.getSelectedValue());
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- erpGrid 추가 Function 끝 --%>
	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			    {id : "ORDR", label:["순번", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}  
			  , {id : "SELECT", label : ["선택", "#rspan"], type : "ra", width : "40", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			  , {id : "ORGN_CD", label:["매장코드", "#rspan"], type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isDisabled : true, isEssential : false, commonCode : "ORGN_CD"}              
			  , {id : "PRST_CD", label:["프리셋코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}              
			  , {id : "ORGN_DIV_CD", label:["조직코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}              
		      , {id : "PRST_NM", label:["프리셋명", "#text_filter"], type: "ed", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			  , {id : "USE_YN", label:["사용유무", "#rspan"], type: "combo", width: "60", sort : "str", align : "left", isHidden : false, isEssential : true, commonCode : ["USE_CD" , "YN"]}
			  , {id : "RESP_USER", label:["담당자", "#rspan"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns			
		});		
		
		erpGrid.attachEvent("onRowPaste", function(rId){
	         var tmpRowIndex = erpGrid.getRowIndex(rId);
	         if(erpGrid.getRowId((tmpRowIndex+1)) == undefined || erpGrid.getRowId((tmpRowIndex+1)) == "undefined" ){
	            addErpGrid();
	         }
	    });
		erpGrid.attachEvent("onKeyPress",onKeyPressed);
		erpGrid.enableBlockSelection();
		erpGrid.enableDistributedParsing(true, 100, 50);
		erpGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		
		erpGrid.attachEvent("onCheck", function(rId,cInd){
			if(cInd == this.getColIndexById("SELECT")){
				var prst_cd = this.cells(rId, this.getColIndexById("PRST_CD")).getValue();
				var orgn_div_cd = this.cells(rId, this.getColIndexById("ORGN_DIV_CD")).getValue();
				var orgn_cd = this.cells(rId, this.getColIndexById("ORGN_CD")).getValue();
				console.log("onCheck prst_cd >> " + prst_cd);
				selected_prst_cd = prst_cd;
				selected_orgn_div_cd = orgn_div_cd;
				selected_orgn_cd = orgn_cd;
				searchErpDetailGrid(prst_cd, orgn_div_cd, orgn_cd);
			}
		 });
		
		
	}
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(ORGN_CD){
		erpLayout.progressOn();
		$.ajax({
			url : "/sis/preset/getPresetGroupList.do"
			,data : {
				"ORGN_CD" : ORGN_CD
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpDetailGrid);
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
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%--
	**********************************************************************
	* ※ Detail 영역
	**********************************************************************
	--%>
	<%-- ■ erpDetailSubLayout 관련 Function 시작 --%>
	<%-- erpDetailSubLayout 초기화 Function --%>
	function initErpDetailSubLayout(){
		erpDetailSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_detail_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				 {id: "a", text: "", header:false, fix_size : [false, true]}
				, {id: "b", text: "", header:false}
			]		
			, fullScreen : true
		});
		erpDetailSubLayout.cells("a").attachObject("div_erp_detail_ribbon");
		erpDetailSubLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpDetailSubLayout.cells("b").attachObject("div_erp_detail_grid");
		
		erpDetailSubLayout.setSeparatorSize(1, 0);
	}	
	<%-- ■ erpDetailSubLayout 관련 Function 끝 --%>
	
	<%-- ■ erpDetailRibbon 관련 Function 시작 --%>
	<%-- erpDetailRibbon 초기화 Function --%>
	function initErpDetailRibbon(){
		erpDetailRibbon = new dhtmlXRibbon({
			parent : "div_erp_detail_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpDetailGrid", type : "button", text:'상품추가', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}    
					//, {id : "add_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erpDetailGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}							
			]
		});
		
		erpDetailRibbon.attachEvent("onClick", function(itemId, bId){
		  if(itemId == "search_erpDetailGrid") {
			  var gridRowCount = erpGrid.getRowsNum();
			  for(var i = 0; i < gridRowCount; i++){
					var rId = erpGrid.getRowId(i);
					var detailcheck = erpGrid.cells(rId, erpGrid.getColIndexById("SELECT")).getValue();
					if(detailcheck == 1) {
						openPresetGoodsAddPopup();
						return false;
					}
				} 
				$erp.alertMessage({
					"alertMessage" : "프리셋 그룹을 선택 후 이용가능합니다."
					, "alertType" : "alert"
					, "isAjax" : false
				});
		  }	else if (itemId == "add_erpDetailGrid"){
				var gridRowCount = erpGrid.getRowsNum();
				for(var i = 0; i < gridRowCount; i++){
					var rId = erpGrid.getRowId(i);
					var detailcheck = erpGrid.cells(rId, erpGrid.getColIndexById("SELECT")).getValue();
					if(detailcheck == 1) {
						addErpDetailGrid();
						return false;
					}
				} 
				$erp.alertMessage({
					"alertMessage" : "프리셋 그룹을 선택 후 이용가능합니다."
					, "alertType" : "alert"
					, "isAjax" : false
				});
			} else if (itemId == "delete_erpDetailGrid"){
				deleteErpDetailGrid();
			} else if (itemId == "save_erpDetailGrid"){
				saveErpDetailGrid();
			}
		});
	}
	<%-- ■ erpDetailRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpDetailGrid 관련 Function 시작 --%>
	<%-- erpDetailGrid 초기화 Function --%>
	function initErpDetailGrid(){
		erpDetailGridColumns = [
				{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			  , {id : "ORGN_CD", label:["점포코드", "#rspan"], type: "ro", width: "60", sort : "int", align : "center", isHidden : true, isEssential : false}
			  , {id : "NO", label:["순서", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			  , {id : "PRST_CD", label:["그룹코드", "#rspan"], type: "ro", width: "60", sort : "int", align : "center", isHidden : true, isEssential : false}
			  , {id : "ORDR", label:["순번", "#rspan"], type: "ro", width: "30", sort : "str", align : "left", isHidden : true, isEssential : false}
			  , {id : "ORGN_DIV_CD", label:["조직코드", "#rspan"], type: "ro", width: "30", sort : "str", align : "left", isHidden : true, isEssential : false}
			  , {id : "GOODS_NO", label:["상품코드", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "BCD_NM", label:["상품명", "#text_filter"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "BCD_CD", label:["바코드", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : true}
			  , {id : "SALE_PRICE", label:["판매가", "#rspan"], type: "ron", width: "60", sort : "int", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000"}
			  , {id : "EVENT_GOODS_PRICE", label:["특매판매가", "#rspan"], type: "ron", width: "70", sort : "int", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000"}
			  , {id : "USE_YN", label:["사용유무", "#select_filter"], type: "combo", width: "60", sort : "str", align : "left", isHidden : false, isEssential : true, commonCode : ["USE_CD", "YN"]}
			  , {id : "CUSER", label:["등록자", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "CDATE", label:["등록일시", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "MUSER", label:["수정자", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "MDATE", label:["수정일시", "#rspan"], type: "ro", width: "90", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpDetailGridColumns
		});		
	
		erpDetailGridDataProcessor = $erp.initGrid(erpDetailGrid, {useAutoAddRowPaste : true, standardColumnId : "BCD_CD", deleteDuplication : true , overrideDuplication : false , editableColumnIdListOfInsertedRows : ["BCD_CD", "USE_YN"], notEditableColumnIdListOfInsertedRows : ["SALE_PRICE", "EVENT_GOODS_PRICE"]})

		erpDetailGrid.attachEvent("onEndPaste", function(result){   //엑셀붙여넣기시 자동으로 행추가
			getDetailGoodsList(result); // 바코드 붙여넣기 완료 시 상품정보 가져오기
	    });
	}
	
	<%-- erpDetailGrid 조회 Function --%>
	function searchErpDetailGrid(prst_cd, orgn_div_cd, orgn_cd){ //프리셋 그룹관리에서 선택한 그룹내 상세 상품내역
		if(prst_cd == ""){
			$erp.alertMessage({
				"alertMessage" : "프리셋 그룹을 저장 후 이용가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else{
			erpLayout.progressOn();
			$.ajax({
				url : "/sis/preset/getPresetDetailList.do"
				,data : {
					"prst_cd" : prst_cd
					, "orgn_div_cd" : orgn_div_cd
					, "orgn_cd" : orgn_cd
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						$erp.clearDhtmlXGrid(erpDetailGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpDetailGrid
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpDetailGrid.parse(gridDataList, 'js');	
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	<%-- erpDetailGrid 조회 Function 끝--%>
	
	<%-- onKeyPressed 프리셋그룹Grid_Keypressed Function --%>
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
	
	<%-- getDetailGoodsList 프리셋그룹별 상품상세리스트 Function --%>
	function getDetailGoodsList(result) {
		erpLayout.progressOn();
		
		var loadGoodsList = [];
		var data;
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];
			loadGoodsList.push(data["BCD_CD"]);
		}
		var url = "/sis/preset/getPasteDetailGoodsList.do";
		var send_data = {
				"loadGoodsList" : loadGoodsList
				, "ORGN_CD" : selected_orgn_cd		
		};
		
		
		var if_success = function(data){
			var gridDataList = data.gridDataList;
			for(var index in gridDataList){
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("BCD_NM")).setValue(gridDataList[index].BCD_NM);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("DIMEN_NM")).setValue(gridDataList[index].DIMEN_NM);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("SALE_PRICE")).setValue(gridDataList[index].SALE_PRICE);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("EVENT_GOODS_PRICE")).setValue(gridDataList[index].EVENT_GOODS_PRICE);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("GOODS_NO")).setValue(gridDataList[index].GOODS_NO);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("BCD_CD")).setValue(gridDataList[index].BCD_CD);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("PRST_CD")).setValue(selected_prst_cd);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("ORGN_CD")).setValue(selected_orgn_cd);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("ORGN_DIV_CD")).setValue(selected_orgn_div_cd);
				erpDetailGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], erpDetailGrid.getColIndexById("USE_YN")).setValue("Y");
				result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]].push("로드완료");
			}
			
			var notExistList = [];
			var value;
			var state;
			var dp = erpDetailGrid.getDataProcessor();
			console.log(dp);
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["BCD_CD"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			$erp.deleteGridRows(erpDetailGrid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>[무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			if(erpDetailGrid.getRowsNum() == 0){
				erpDetailGrid.callEvent("onClick",["searchErpDetailGrid"]);
				return;
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpDetailGrid); // 현재 행수 계산
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
	}
	
	<%-- addErpDetailGrid 추가 Function --%>
	function addErpDetailGrid(){
		var uid = erpDetailGrid.uid();
		erpDetailGrid.addRow(uid);
		erpDetailGrid.selectRow(erpDetailGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
	}
	
	<%-- saveErpDetailGrid 저장 Function --%>
	function saveErpDetailGrid() {
		var gridRowCount = erpDetailGrid.getRowsNum();
		var lastRowNum = gridRowCount-1;
		var lastRid = erpDetailGrid.getRowId(lastRowNum);
		var lastRowcheck = erpDetailGrid.cells(lastRid, erpDetailGrid.getColIndexById("BCD_NM")).getValue();
		if(lastRowcheck == null || lastRowcheck == "null" || lastRowcheck == undefined || lastRowcheck == "undefined" || lastRowcheck == "") {
			erpDetailGrid.deleteRow(lastRid);
		}
		
		 if(erpDetailGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpDetailGrid);
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		} 
		
		var allIds = erpDetailGrid.getAllRowIds(",");
	    var allIdArray = allIds.split(",");
		
		var deleteRowIdArray = [];
		
		for(var i = 0 ; i < allIdArray.length ; i++) {
			var goods_nm = erpDetailGrid.cells(allIdArray[i], erpDetailGrid.getColIndexById("BCD_NM")).getValue();
			if(goods_nm == "조회정보없음"){
				deleteRowIdArray.push(allIdArray[i]);
			}
		}
		
		for(var j = 0 ; j < deleteRowIdArray.length ; j++){
			erpDetailGrid.deleteRow(deleteRowIdArray[j]); 
			//조회정보없는 row가 삭제되도록 하는대신 전체 등록하려는 바코드 중 몇건이 삭제되는지 2/10 등의 알림 메시지 띄울필요 있어보입니다.
		}
		
		erpLayout.progressOn();
		
		var paramData = $erp.serializeDhtmlXGridData(erpDetailGrid);
		$.ajax({
			url : "/sis/preset/SavePresetDetailList.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					searchErpDetailGrid(selected_prst_cd, selected_orgn_div_cd, selected_orgn_cd);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- deleteErpDetailGrid 삭제 Function --%>
	function deleteErpDetailGrid(){
		var gridRowCount = erpDetailGrid.getAllRowIds(",");
		var RowCountArray = gridRowCount.split(",");
		
		var deleteRowIdArray = [];
		var check = "";
		
		for(var i = 0 ; i < RowCountArray.length ; i++){
			check = erpDetailGrid.cells(RowCountArray[i], erpDetailGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(RowCountArray[i]);
			}
		}
		
		if(deleteRowIdArray.length == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}
		
		for(var j = 0; j < deleteRowIdArray.length; j++){
			erpDetailGrid.deleteRow(deleteRowIdArray[j]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
	}
	
	<%-- openPresetGoodsAddPopup 상품검색팝업열림 Function --%>
	function openPresetGoodsAddPopup() {
		var ORGN_DIV_CD = $erp.getOrgnDivCdByOrgnCd(cmbSearch.getSelectedValue());
		
		var onClickAddData = function(erpPopupGrid) {
			//dataState : checked,selected  //copyType : add,new
			var popup = erpPopupWindows.window("openSearchGoodsGridPopup");
			popup.progressOn();
			$erp.copyRowsGridToGrid(erpPopupGrid, erpDetailGrid, ["BCD_CD","BCD_NM", "DIMEN_NM", "GOODS_NO"], ["BCD_CD","BCD_NM", "DIMEN_NM", "GOODS_NO"], "checked", "new", ["BCD_CD"], [], null, {"ORGN_CD" : selected_orgn_cd, "ORGN_DIV_CD" : selected_orgn_div_cd, "PRST_CD" : selected_prst_cd, "USE_YN" : "Y"}, function(result){
				popup.progressOff();
				popup.close();
				console.log(result);
				getDetailGoodsList(result);
			},false);
		}
		
		$erp.openSearchGoodsPopup(null, onClickAddData, {"ORGN_DIV_CD" : selected_orgn_div_cd ,"ORGN_CD" : selected_orgn_cd});
	}
	
	function initDhtmlXCombo(){
		$.ajax({
			url : "/sis/preset/getSearchMarketCD.do"
			,data : {}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var DELEGATE_CD = data.ORGN_DELEGATE_CD;
					var ORGN_TYPE = data.ORGN_TYPE;
					
					if(ORGN_TYPE == "N"){
						cmbSearch = $erp.getDhtmlXComboCommonCode("ORGN_CD", "ORGN_CD", ["ORGN_CD", "MK"], 100, "모두조회", false, null, searchErpGrid(''));
					} else {
						cmbSearch = $erp.getDhtmlXComboCommonCode("ORGN_CD", "ORGN_CD", ["ORGN_CD", "MK"], 100, false, false, DELEGATE_CD, searchErpGrid(DELEGATE_CD));
					}
					
					var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",");
					var searchable = 1;
					console.log(search_cd_Arr);
					for(var i in search_cd_Arr){
						if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
							searchable = 2;
						}
					}

					if(searchable != 2 ){
						 cmbSearch.disable();
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	
</script>
</head>
<body>
	<div id="div_erp_select_combo" class="div_layout_full_size div_common_contents_full_size" style="display:none;">
		<table id="tb_erp_data" class="table_search">
			<colgroup>
				<col width="50px;">
				<col width="190px;">
				<col width="*px;">
			</colgroup>
			<tr>
				<th>조직명</th>
				<td>
					<div id="ORGN_CD"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none;"></div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none;"></div>
	
	<div id="div_erp_detail_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none;"></div>
	<div id="div_erp_detail_ribbon" class="div_ribbon_full_size" style="display:none;"></div>	
	<div id="div_erp_detail_grid" class="div_grid_full_size" style="display:none;"></div>	
</body>
</html>