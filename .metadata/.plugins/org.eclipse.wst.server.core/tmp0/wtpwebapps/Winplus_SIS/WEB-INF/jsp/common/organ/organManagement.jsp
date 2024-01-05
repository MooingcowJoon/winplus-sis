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
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbUSE_YN : Object / 사용여부 DhtmlXCombo  (CODE : 'YN_CD' / 빈 칸 : 전체)
		■ cmbCMMN_YN : Object / 공통여부 DhtmlXCombo  (CODE : 'YN_CD' / 빈 칸 : 전체) 		 
	--%>
	var erpLayout;	
	var erpLeftLayout;

	var erpRibbon;
	
	var erpCodeGrid;
	var erpCodeGridColumns;
	
	var erpTree;	
	var currentErpTreeId;
	
	var erpGridDataProcessor;	
	var cmbUSE_YN;
	
	var SelectedStndCtgrCd;
	var SelectedStndCtgrNm;

	var crud;
	
	$(document).ready(function(){		

		initErpLayout();
		initErpLeftSubLayout();
		initErpRibbon();
		initErpTree();
		initDhtmlXCombo();
		
		initErpRightLayout();
		initErpRightSubLayout();
		
		initErpCodeRibbon();
		initErpCodeGridGrid();
		searchErpTree();
		
		$('input').prop('readonly', true);

	});
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_data", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					, {id : "add_data", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_data", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_data", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					, {id : "excel_data", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : true}
					, {id : "print_data", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, unused : true}	
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_data"){
				searchErpTree();
		    } else if (itemId == "add_data"){
		    	addData();
		    } else if (itemId == "delete_data"){
		    	deleteData();
		    } else if (itemId == "save_data"){
		    	saveData();
		    } else if (itemId == "excel_data"){
		    	
		    } else if (itemId == "print_data"){
		    	
		    }
		});
	}
	
	<%-- ■ dlvRibbon 초기화 Function --%>
	function initErpCodeRibbon(){
		erpCodeRibbon = new dhtmlXRibbon({
			parent : "div_erpCode_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "add_right_data", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_right_data", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_right_data", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}							
			]
		});
		
		erpCodeRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_right_data"){
		    	addErpCodeData();
		    } else if (itemId == "delete_right_data"){
		    	deleteErpCodeData();
		    } else if (itemId == "save_right_data"){
		    	saveErpCodeData();
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2U"
			, cells: [
				{id: "a", text: "조직 목록", header:true, width:400, fix_size:[true, true]}
				, {id: "b", text: "조직 정보", header:true}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_left_sub_layout");
		erpLayout.cells("b").attachObject("div_erp_right_layout");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpLayout.setSizes();
		});
	}


	function initErpLeftSubLayout(){
		erpLeftLayout = new dhtmlXLayoutObject({
			parent: "div_erp_left_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "", header:false}
				, {id: "b", text: "", header:false, fix_size : [true, true]}
			]		
		});

		erpLeftLayout.cells("a").attachObject("div_erp_ribbon");
		erpLeftLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftLayout.cells("b").attachObject("div_erp_tree");
		
		erpLeftLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLeftLayout, function(names){
			erpTree.setSizes();
		});
	}
	<%-- erpRightLayout 초기화 Function --%>	
	function initErpRightLayout(){
		erpRightLayout = new dhtmlXLayoutObject({
			parent: "div_erp_right_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "조직 정보", header:false, fix_size:[true, true]}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
			]		
		});

		erpRightLayout.cells("a").attachObject("div_erp_right_contents");
		erpRightLayout.cells("a").setHeight(340);
		erpRightLayout.cells("a").hideArrow();
		erpRightLayout.cells("b").attachObject("div_erp_right_sub_contents");
		
		erpRightLayout.setSeparatorSize(1, 0);

		<%-- erpRightLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpRightLayout, function(names){
			erpCodeGrid.setSizes();
		})
		
	}
	<%-- erpRightLayout 관련 Function 끝 --%>
	
	<%-- div_erp_right_sub_contents 초기화 Function --%>	
	function initErpRightSubLayout(){
		erpRightSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_right_sub_contents"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "조직별 회계코드", header:true, fix_size:[true, true]}
				, {id: "b", text: "", header:false}
			]		
		});

		erpRightSubLayout.cells("a").attachObject("div_erpCode_ribbon");
		erpRightSubLayout.cells("a").setHeight(65);
		erpRightSubLayout.cells("a").hideArrow();
		erpRightSubLayout.cells("b").attachObject("div_erp_right_grid");
		
		erpRightSubLayout.setSeparatorSize(1, 0);

		<%-- erpRightSubLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpRightSubLayout, function(names){
			erpCodeGrid.setSizes();
		})
		
	}
	<%-- erpRightSubLayout 관련 Function 끝 --%>
	<%-- ■ Layout 관련 Function 끝 --%>
	
	<%-- ■ erpTree 관련 Function 시작 --%>
	<%-- erpTree 초기화 Function --%>
	function initErpTree(){
		erpTree = new dhtmlXTreeObject({
			parent : "div_erp_tree"
			, skin : ERP_TREE_CURRENT_SKINS			
			, image_path : ERP_TREE_CURRENT_IMAGE_PATH
		});
		
		erpTree.attachEvent("onClick", function(id){
			if(!$erp.isEmpty(id)){
				<%-- 최상위 일 경우 완전 초기화 --%>
				if(id == "#root"){
					currentErpTreeId = null;
					$erp.clearInputInElement("tb_erp_data");
				} else {
					crud = null;
					currentErpTreeId = id;
					searchData();
				}
			}
		});
	}
	
	<%-- erpTree 조회 Function --%>
	function searchErpTree(){
		erpLayout.progressOn();

		$.ajax({
			url : "/common/organ/getOrgnList.do"
			,data : {
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					var menuTreeMap = data.menuTreeMap;
					var menuTreeDataList = menuTreeMap.item;
					if($erp.isEmpty(menuTreeDataList)){
						$erp.alertMessage({
							"alertMessage" : "grid.noSearchData"
							, "alertCode" : null
							, "alertType" : "info"
						});
					} else {
						erpTree.deleteChildItems(0);
						
						erpTree.parse(menuTreeMap, 'json');
						currentErpTreeId = null;
						$erp.clearInputInElement("tb_erp_data");
						$erp.clearDhtmlXGrid(erpCodeGrid);
						erpTree.openAllItems("0");
						document.getElementById("div_data_info").textContent = '조직 등록/수정 대기중';
						$('input').prop('readonly', true);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpCodeGrid 관련 Function 시작 --%>
	function initErpCodeGridGrid(){
		erpCodeGridColumns=[
			{id : "NO", label : ["NO"], type : "cntr", width : "48", sort : "int", align : "center", isHidden : false, isEssential : false}	
			, {id : "CHECK", name:"CHECK", label : ["#master_checkbox"], type : "ch", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "ORGN_CD", label:["조직코드"], type: "ro", width: "130", align : "center", isHidden : true, isEssential : false}
			, {id : "ERP_CD", label:["회계코드"], type: "ed", width: "130", align : "left", isHidden : false, isEssential : false}
			, {id : "ERP_NM", label:["회계코드명"], type: "ed", width: "140",align : "left", isHidden : false, isEssential : true}
			, {id : "USE_YN", label:["사용여부"], type: "ro", width: "90",align : "left", isHidden : true, isEssential : false}
			, {id : "REG_DT", label:["생성일"], type: "ro", width: "90",align : "left", isHidden : false, isEssential : false}
			, {id : "REG_ID", label:["생성자"], type: "ro", width: "80",align : "left", isHidden : false, isEssential : false}
			, {id : "MOD_DT", label:["수정일"], type: "ro", width: "90",align : "left", isHidden : false, isEssential : false}
			, {id : "MOD_ID", label:["수정자"], type: "ro", width: "80",align : "left", isHidden : false, isEssential : false}
		];
		
		erpCodeGrid = new dhtmlXGridObject({
			parent: "div_erp_right_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpCodeGridColumns
		});
		
		$erp.initGridCustomCell(erpCodeGrid);
		$erp.initGridComboCell(erpCodeGrid);
		
		erpCodeGridDataProcessor = new dataProcessor();
		erpCodeGridDataProcessor.init(erpCodeGrid);
		erpCodeGridDataProcessor.setUpdateMode("off");
		
		$erp.attachDhtmlXGridFooterRowCount(erpCodeGrid, '<spring:message code="grid.allRowCount" />');
	} 
	
	<%-- erpCodeGrid 저장 Function --%>
	function saveErpCodeData(){
		if(!isErpCodeSaveValidate()) { return false; }	
		
		var paramData = $erp.serializeDhtmlXGridData(erpCodeGrid, false);	
		
		var erpCodeOk = false;
		if(erpCodeGridDataProcessor.getSyncState()){
			erpCodeOk = true;
		}
		
		if(paramData!=null && erpCodeOk == false){
			erpLayout.progressOn();
			$.ajax({
				url : "/common/organ/insertErpCode.do"
				,data : paramData
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						$erp.alertSuccessMesage();
						$erp.clearDhtmlXGrid(erpCodeGrid);
						searchErpRightBottomGrid(document.getElementById("txtORGN_CD").value);
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	<%-- erpCodeGrid 저장 isErpCodeSaveValidate Function --%>
	function isErpCodeSaveValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		var alertMessageParam = "";
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpCodeGrid);
		if(validResultMap.isError){
			isValidated = false;
			alertMessage = validResultMap.errMessage;
			alertCode = validResultMap.errCode;
			alertType = "error";
			alertMessageParam = validResultMap.errMessageParam
		}
			
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
				, "alertMessageParam" : alertMessageParam
			});
		}
		return isValidated;
	}
	
	<%-- erpCodeGrid 추가 Function --%>
	function addErpCodeData(){
		if(crud=='U'){
			var uid = erpCodeGrid.uid();
			erpCodeGrid.addRow(uid);
			erpCodeGrid.selectRow(erpCodeGrid.getRowIndex(uid));
			
			erpCodeGrid.cells(uid, erpCodeGrid.getColIndexById("ORGN_CD")).setValue(document.getElementById("txtORGN_CD").value);
			$erp.setDhtmlXGridFooterRowCount(erpCodeGrid);
		}
	}
	
	<%-- erpCodeGrid 삭제 Function --%>
	function deleteErpCodeData(){
		
		if(crud=='U'){
			var gridRowCount = erpCodeGrid.getRowsNum();
			var isChecked = false;
			
			var deleteRowIdArray = [];
			for(var i = 0; i < gridRowCount; i++){
				var rId = erpCodeGrid.getRowId(i);
				var check = erpCodeGrid.cells(rId, erpCodeGrid.getColIndexById("CHECK")).getValue();
				if(check == "1"){
					deleteRowIdArray.push(rId);
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
			
			for(var i = 0; i < deleteRowIdArray.length; i++){
				erpCodeGrid.cells(deleteRowIdArray[i], erpCodeGrid.getColIndexById("USE_YN")).setValue("N");
				erpCodeGrid.deleteRow(deleteRowIdArray[i]);
			}
			
			$erp.setDhtmlXGridFooterRowCount(erpCodeGrid);
		}
		
	}
	<%-- ■ erpRightBottomLayout event관련 Function 시작 --%>
	<%-- Data 조회 Function --%>
	function searchErpRightBottomGrid(orgnCd){
		erpLayout.progressOn();
		var url = "/common/organ/getErpCodeList.do";
		var data = {
				"ORGN_CD": orgnCd
			};
		var method = "POST";
		doAjax(url, data, method, function(data) {
			erpLayout.progressOff();
			if(data.isError){
				$erp.ajaxErrorMessage(data);
			} else {
				var gridDataList = data.gridDataList;
				if($erp.isEmpty(gridDataList)){
					$erp.addDhtmlXGridNoDataPrintRow(
							erpCodeGrid
						, '<spring:message code="grid.noSearchData" />'
					);
				} else {
					erpCodeGrid.parse(gridDataList, 'js');
				}
			}
			$erp.setDhtmlXGridFooterRowCount(erpCodeGrid);
		});
	}
	
	<%-- ■ Grid 관련 Function 끝 --%>
	
	<%-- ■ 자료 (Data) 관련 Function 시작 --%>
	<%-- Data 조회 유효성 검증 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(currentErpTreeId)){
			isValidated = false;
			alertMessage = "error.common.noSelectedData";
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
	
	<%-- Data 조회 Function --%>
	function searchData(){
		if(!isSearchValidate()) { return false; }
		
		erpLayout.progressOn();

		$.ajax({
			url : "/common/organ/getOrgn.do"
			,data : {
				"ORGN_CD" : currentErpTreeId
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					var dataMap = data.dataMap;				
					if($erp.isEmpty(dataMap)){
						$erp.alertMessage({
							"alertMessage" : "grid.noSearchData"
							, "alertCode" : ""
							, "alertType" : "info"
						});
					} else {						
						crud = "U";
						var tbErpData = document.getElementById("tb_erp_data");
						$erp.clearInputInElement(tbErpData);
						$erp.bindTextValue(dataMap, tbErpData);
						$erp.bindCmbValue(dataMap, tbErpData);
						document.getElementById("OLD_ORGN_NM").value=document.getElementById("txtORGN_NM").value;
						document.getElementById("div_data_info").textContent = '조직 수정 중';
						
						$("#txtORGN_NM").attr("readonly",false); 
						//$("#txtCOST_CENTER").attr("readonly",false);
						$("#txtZIP_NO").attr("readonly",false);
						$("#txtTEL_NO").attr("readonly",false);
						$("#txtADDR").attr("readonly",false);
						$("#txtADDR2").attr("readonly",false);
						
						cmbSEARCHABLE_AUTH_CD.forEachOption(function(option){
							cmbSEARCHABLE_AUTH_CD.setChecked(option.index,false);
						});
						cmbSEARCHABLE_AUTH_CD.forEachOption(function(option){
							if(dataMap.SEARCHABLE_AUTH_CD){
								var SEARCHABLE_AUTH_CD_list = dataMap.SEARCHABLE_AUTH_CD.split(",");
								for(var i in SEARCHABLE_AUTH_CD_list){
									if(option.value == SEARCHABLE_AUTH_CD_list[i]){
										cmbSEARCHABLE_AUTH_CD.setChecked(option.index,true);
									}
								}
							}
						});
						cmbSEARCHABLE_AUTH_CD.callEvent("onClose",[]);
						
						$erp.clearDhtmlXGrid(erpCodeGrid);
						searchErpRightBottomGrid(document.getElementById("txtORGN_CD").value);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpGrid 추가 Function --%>
	function addData(){
		if(crud != "C"){
			var menu_cd = document.getElementById("txtORGN_CD").value;		
			var menu_nm = document.getElementById("OLD_ORGN_NM").value;

			$erp.clearInputInElement("tb_erp_data");
			
			if(!$erp.isEmpty(menu_cd)){		
				document.getElementById("txtUPPER_ORGN_CD").value = menu_cd;
				document.getElementById("txtUPPER_ORGN_NM").value = menu_nm;			
			}
			crud = "C";
			document.getElementById("div_data_info").textContent = '조직 등록 중';
			
			$('input').prop('readonly', true);
			$("#txtORGN_CD").attr("readonly",false); 
			$("#txtORGN_NM").attr("readonly",false); 
			//$("#txtCOST_CENTER").attr("readonly",false);
			$("#txtZIP_NO").attr("readonly",false);
			$("#txtTEL_NO").attr("readonly",false);
			$("#txtADDR").attr("readonly",false);
			$("#txtADDR2").attr("readonly",false);
		}
		
	}
	
	<%-- erpGrid 저장 Function --%>
	function saveData(){
		if(!isSaveValidate()) { return false; }	
		
		var paramData = $erp.serializeDom("tb_erp_data");
		paramData = $erp.unionObjArray([
										paramData 
										, {SEARCHABLE_AUTH_CD : $.grep(cmbSEARCHABLE_AUTH_CD.getChecked(), function(val){ return val != '';}).join(",")}
										, {"CRUD" : crud}
										]);
	
		$.ajax({
			url : "/common/organ/insertOrgn.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					$erp.alertSuccessMesage(onAfterSaveData);
					onAfterSaveData();
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				$("#txtORGN_CD").attr("readonly",true); 
			}
		});
	}
	
	<%-- Data 저장 유효성 검증 Function --%>
	function isSaveValidate(){
		var orgnCd = document.getElementById("txtORGN_CD").value;
		var orgnNm = document.getElementById("txtORGN_NM").value;
		var upperOrgnCd = document.getElementById("txtUPPER_ORGN_CD").value;
		
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";

		if($erp.isEmpty(orgnNm)){
			isValidated = false;
			alertMessage = "error.common.system.master.category.stndCtgrNm.noData";
			alertCode = "-2";
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
	
	<%-- erpGrid 저장 후 Function --%>
	function onAfterSaveData(){
		$erp.clearInputInElement("tb_erp_data");
		searchErpTree();
		crud = "U";
		document.getElementById("div_data_info").textContent = '조직 조회/수정중';
	}
	
	<%-- Data 삭제 Function --%>
	function deleteData(){
		if(!isSearchValidate()) { return false; }
		
		var alertMessage = '<spring:message code="alert.common.deleteData" />';
		var alertCode = "";
		var alertType = "alert";
		var callbackFunction = function(){
			crud = "D";
			saveData();
		}
		
		$erp.confirmMessage({
			"alertMessage" : alertMessage
			, "alertCode" : alertCode
			, "alertType" : alertType
			, "alertCallbackFn" : callbackFunction
		});
	}
	
	//주소검색 팝업
	function openSearchPostAddrPopup(){	 
		var onComplete = function(data){
			var postAddrMap = $erp.getPostAddrMap(data);
			var ZIP_NO = postAddrMap.new_zip;
			var ADDRESS = postAddrMap.new_addr;
			document.getElementById("txtZIP_NO").value = ZIP_NO;
			document.getElementById("txtADDR").value = ADDRESS;
			document.getElementById("txtADDR2").value = '';
			$erp.closePopup2('ERP_POST_WIN_ID');		
		}
		$erp.openSearchPostAddrPopup2(onComplete, {win_id : "ERP_POST_WIN_ID"});
	}
	
	<%--
	**************************************************
	* 기타 영역
	**************************************************
	--%>	
	<%-- ■ dhtmlxCombo 관련 Function 시작 --%>
	<%-- dhtmlxCombo 초기화 Function --%>
	function initDhtmlXCombo(){
		cmbUSE_YN = $erp.getDhtmlXCombo('cmbUSE_YN', 'USE_YN', ['YN_CD','YN'], 135, false);
		cmbORGN_DIV_CD = $erp.getDhtmlXCombo('cmbORGN_DIV_CD', 'ORGN_DIV_CD', 'ORGN_DIV_CD', 135, false);
		
		cmbSEARCHABLE_AUTH_CD = $erp.getDhtmlXComboMulti("cmbSEARCHABLE_AUTH_CD", "SEARCHABLE_AUTH_CD", "SEARCHABLE_AUTH_CD", 135, "전체선택");
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
	<%-- ■ 공통 Function 시작 --%>
	function doAjax(sUrl, oData, sMethod, callBack) {
		$.ajax({
			url : sUrl
			,data : oData
			,method : sMethod
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					return callBack(data);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ 공통 Function 끝 --%>
	
	function openSearchOrgnPopup(){
		var onRowDblClicked = function(rId, cInd){
						
			var orgnCd = this.cells(rId, this.getColIndexById("ORGN_CD")).getValue();
			var orgnNm = this.cells(rId, this.getColIndexById("ORGN_NM")).getValue();
			var orgnDivCd = this.cells(rId, this.getColIndexById("ORGN_DIV_CD")).getValue();
			var orgnDivNM = this.cells(rId, this.getColIndexById("ORGN_DIV_NM")).getValue();
			
			document.getElementById("txtORGN_DELEGATE_CD").value=orgnCd;
			document.getElementById("txtORGN_DELEGATE_NM").value=orgnNm;
			
			$erp.closePopup();			
		}

		$erp.openSearchOrgnPopup('', onRowDblClicked);
	}
</script>
</head>
<body>		
	<div id="div_erp_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_tree" class="div_tree_full_size"></div>		
	<div id="div_erp_left_sub_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size"></div>
	<div id="div_erp_right_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
	<div id="div_erp_right_contents" class="div_common_contents_full_size" style="display:none">
		<table id="tb_erp_data" class="tb_erp_common">
			<colgroup>
				<col width="150px" />
				<col width="250px" />
				<col width="150px" />
				<col width="*" />
			</colgroup>
				<tr>
					<td colspan="4" class="td_subject"><div id="div_data_info" class="common_center">조직 등록/수정 대기중</div></td>
				</tr>
				<tr>
					<th><span class="span_essential">*</span>조직 코드</th>
					<td>
						<input type="text" id="txtORGN_CD" name="ORGN_CD" class="input_common input_essential" maxlength="20">					
					</td>
					<th><span class="span_essential">*</span>조직명</th>
					<td>
						<input type="text" id="txtORGN_NM" name="ORGN_NM" class="input_common input_essential" maxlength="20" width="100">
						<input type="hidden" id="OLD_ORGN_NM">
					</td>
				</tr>
				<tr>
					<th>상위 조직 코드</th>
					<td>
						<input type="text" id="txtUPPER_ORGN_CD" name="UPPER_ORGN_CD" class="input_common input_readonly" maxlength="20" width="100">
					</td>
					<th>상위 조직명</th>
					<td>
						<input type="text" id="txtUPPER_ORGN_NM" name="UPPER_ORGN_NM" class="input_common input_readonly" maxlength="20" width="100">
					</td>
				</tr>
				<tr>
					<th>법인구분</th>
					<td>
						<div id="cmbORGN_DIV_CD"></div>
					</td>
										<th>검색허용권한</th>
					<td>
						<div id="cmbSEARCHABLE_AUTH_CD"></div>
					</td>
				</tr>
				<tr>
					<th>(검색용)대표 조직 코드</th>
					<td>
						<input type="text" id="txtORGN_DELEGATE_CD" name="ORGN_DELEGATE_CD" class="input_common input_readonly input_essential" onkeydown="$erp.onEnterKeyDown(event, openSearchOrgnPopup, ['']);" style="width:100;">
						<input type="button" class="input_common_button" value="검색" onclick="openSearchOrgnPopup();">
					</td>
					<th>(검색용)대표 조직명</th>
					<td>
						<input type="text" id="txtORGN_DELEGATE_NM" name="ORGN_DELEGATE_NM" class="input_common input_readonly input_essential" onkeydown="$erp.onEnterKeyDown(event, openSearchOrgnPopup, ['']);" style="width:100;">
					</td>
				</tr>
				<tr>
					<th>생성자</th>
					<td>
						<input type="text" id="txtREG_ID" name="REG_ID" class="input_common input_readonly" maxlength="20">
					</td>
					<th>생성일자</th>
					<td>
						<input type="text" id="txtREG_DT" name="REG_DT" class="input_common input_readonly" maxlength="20">
					</td>
				</tr>
				<tr>
					<th>수정자</th>
					<td>
						<input type="text" id="txtMOD_ID" name="MOD_ID" class="input_common input_readonly" maxlength="20">
					</td>
					<th>수정일자</th>
					<td>
						<input type="text" id="txtMOD_DT" name="MOD_DT" class="input_common input_readonly" maxlength="20">
					</td>
				</tr>
				<tr>
					<th>사용여부</th>
					<td colspan="3">
						<div id="cmbUSE_YN"></div>
					</td>
				</tr>
				<tr>
					<td colspan="4" class="td_subject"><b>※ 기타 조직정보</b></td>
				</tr>
				<tr>
					<th>우편번호</th>
					<td>
						<input type="text" id="txtZIP_NO" name="ZIP_NO" class="input_common" maxlength="10">
						<input type="button" id="btnSearchPost" class="input_common_button" value="주소검색" onclick="openSearchPostAddrPopup();" />
					</td>
					<th>전화번호</th>
					<td>
						<input type="text" id="txtTEL_NO" name="TEL_NO" class="input_common" maxlength="13">
					</td>
				</tr>
				<tr>
					<th>기본주소</th>
					<td colspan="3">
						<input type="text" id="txtADDR" name="ADDR" class="input_common" style="text-align:left; width:50%;">
					</td>
				</tr>
				<tr>
					<th>상세주소</th>
					<td colspan="3">
						<input type="text" id="txtADDR2" name="ADDR2" class="input_common" style="text-align:left; width:50%;">
					</td>
				</tr>
		</table>
	</div>
	<div id="div_erp_right_sub_contents" class="div_layout_full_size div_sub_layout" style="display:none"></div>	
	<div id="div_erpCode_ribbon" class="div_ribbon_full_size"></div>
	<div id="div_erp_right_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>