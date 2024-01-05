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
		■ erpTree : Object / 상품분류 목록 DhtmlXTree
		■ cmbGRUP_STATE : Object / 관리상태여부 DhtmlXCombo (공통코드 : YN_CD)
		■ cmbGRUP_LOCAL_CD : Object / 부문관리코드 DhtmlXCombo (공통코드 : GOODS_GRUP)
		■ currentErpTreeId : String / CRUD 시 사용변수
		■ currentErpTreeLvl : String / 트리 레벨 변수
		■ crud : String / CRUD 구분용
	--%>
	var erpLayout;
	var erpLeftLayout;
	var erpRightLayout;
	var erpRibbon;
	var erpTree;	
	var cmbGRUP_STATE;
	var cmbGRUP_LOCAL_CD;
	var currentErpTreeId;
	var currentErpTreeLvl;
	var crud;
	
	$(document).ready(function(){		
		var leftToolbarDomObjId = "div_erp_toolbar";
		initErpLayout();
		initErpLeftLayout();
		initErpRightLayout();

		<%-- Menu DhtmlxToolbar 초기화, 기존 HRIS 폼 메뉴 사용 시 주석 필요 --%>
		initErpGoodsMenuToolbar(leftToolbarDomObjId
				, "<spring:message code='word.common.expands' />"	<%-- 펼침 Text --%>
				, "<spring:message code='word.common.collapse' />"	<%-- 접기 Text --%>
		);
		
		initErpRibbon();
		initErpTree();
		initDhtmlXCombo();
		searchErpTree();
		
		$("#txtGRUP_TOP_CD").keyup && (function(e) { 
				if (!(e.keyCode >48 && e.keyCode<57)) {
					var v = $(this).val();
					$(this).val(v.replace(/[^a-z0-9]/gi,''));
					}
				}); 
		
		$("#txtGRUP_MID_CD").keyup(function(e) { 
				if (!(e.keyCode >48 && e.keyCode<57)) {
					var v = $(this).val();
					$(this).val(v.replace(/[^a-z0-9]/gi,''));
					}
				}); 
		
		$("#txtGRUP_BOT_CD").keyup(function(e) { 
			if (!(e.keyCode >48 && e.keyCode<57)) {
				var v = $(this).val();
				$(this).val(v.replace(/[^a-z0-9]/gi,''));
				}
			}); 
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2U"
			, cells: [
				{id: "a", text: "${menuDto.menu_nm}", header:false, width:300}
				, {id: "b", text: "", header:false, fix_size : [true, true]}
			]
		});
		erpLayout.cells("a").attachObject("div_erp_1");
		erpLayout.cells("b").attachObject("div_erp_2");
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLeftLayout(){
		erpLeftLayout = new dhtmlXLayoutObject({
			parent: "div_erp_1"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "", header:false}
				, {id: "b", text: "", header:false, fix_size : [true, true]}
			]		
		});
	
		erpLeftLayout.cells("a").attachObject("div_erp_toolbar");
		erpLeftLayout.cells("a").setHeight(32);
		erpLeftLayout.cells("b").attachObject("div_erp_tree");
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpRightLayout(){
		erpRightLayout = new dhtmlXLayoutObject({
			parent: "div_erp_2"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "", header:false, width:300}
				, {id: "b", text: "", header:false, fix_size : [true, true]}
			]		
		});
	
		erpRightLayout.cells("a").attachObject("div_erp_ribbon");
		erpRightLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightLayout.cells("b").attachObject("div_erp_contents_wrapper");
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
					//{id : "search_erpTree", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					{id : "add_data", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_data", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_data", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					//, {id : "excel_data", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : true}
					//, {id : "print_data", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, unused : true}	
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpTree"){
			} else if (itemId == "add_data"){
				addData();
			} else if (itemId == "delete_data"){
				deleteData();
			} else if (itemId == "save_data"){
				saveCheck();
			} else if (itemId == "excel_data"){
			} else if (itemId == "print_data"){
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
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
				if(id == "ALL"){
					crud = null;
					currentErpTreeId = null;
					currentErpTreeLvl = 1;
					$erp.clearInputInElement("tb_erp_data");
					document.getElementById("txtGRUP_TOP_CD").readOnly = false;
					document.getElementById("txtGRUP_TOP_CD").className = "input_common";
					document.getElementById("txtGRUP_MID_CD").readOnly = true;
					document.getElementById("txtGRUP_MID_CD").className = "input_common input_readonly";
					document.getElementById("txtGRUP_BOT_CD").readOnly = true;
					document.getElementById("txtGRUP_BOT_CD").className = "input_common input_readonly";
					document.getElementById("div_data_info").textContent = '상품분류 등록/수정 대기중';
				} else {
					crud = null;
					currentErpTreeId = id;
					currentErpTreeLvl = null;
					document.getElementById("txtGRUP_TOP_CD").readOnly = true;
					document.getElementById("txtGRUP_TOP_CD").className = "input_common input_readonly";
					document.getElementById("txtGRUP_MID_CD").readOnly = true;
					document.getElementById("txtGRUP_MID_CD").className = "input_common input_readonly";
					document.getElementById("txtGRUP_BOT_CD").readOnly = true;
					document.getElementById("txtGRUP_BOT_CD").className = "input_common input_readonly";
					searchData();
				}
			}
		});
	}
	<%-- erpTree 조회 Function --%>
	function searchErpTree(){
		document.getElementById("txtGRUP_TOP_CD").readOnly = true;
		document.getElementById("txtGRUP_TOP_CD").className = "input_common input_readonly";
		document.getElementById("txtGRUP_MID_CD").readOnly = true;
		document.getElementById("txtGRUP_MID_CD").className = "input_common input_readonly";
		document.getElementById("txtGRUP_BOT_CD").readOnly = true;
		document.getElementById("txtGRUP_BOT_CD").className = "input_common input_readonly";
		
		erpLayout.progressOn();
		
		$.ajax({
			url : "/common/popup/getGoodsCategoryTreeList.do"
			,data : {}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					var categoryList = data.categoryList;
					var categoryTreeMap = data.categoryTreeMap;
					var categoryTreeDataList = categoryTreeMap.item;
					if($erp.isEmpty(categoryTreeDataList) || $erp.isEmpty(categoryList)){
						$erp.alertMessage({
							"alertMessage" : "info.common.noDataSearch"
							, "alertCode" : null
							, "alertType" : "info"
						});
					} else {
						erpTree.deleteChildItems(0);
						erpTree.parse(categoryTreeMap, 'json');
						//미사용 분류 투명도 설정
						for(var i=0; i<categoryList.length; i++){
							if(categoryList[i].GRUP_STATE == "N"){
								erpTree.setItemStyle(categoryList[i].GRUP_CD,"opacity:0.3;");
							}
						}
						crud = "C";
						currentErpTreeId = null;
						currentErpTreeLvl = 1;
						$erp.clearInputInElement("tb_erp_data");
						document.getElementById("txtGRUP_TOP_CD").readOnly = false;
						document.getElementById("txtGRUP_TOP_CD").className = "input_common";
						document.getElementById("div_data_info").textContent = '상품분류 등록/수정 대기중';
						erpTree.openItem("ALL");
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpTree 관련 Function 끝 --%>
	
	<%--
	**************************************************
	* Data 영역
	**************************************************
	--%>
	
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
			alertCode = null;
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
			url : "/sis/standardInfo/goods/getGoodsCategory.do"
			,data : {
				"GRUP_CD" : currentErpTreeId
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
						
						if(dataMap.GRUP_MID_CD == "0" && dataMap.GRUP_BOT_CD == "0"){
							currentErpTreeLvl = 1;
							document.getElementById("txtGRUP_TOP_CD").readOnly = false;
							document.getElementById("txtGRUP_TOP_CD").className = "input_common";
						}else if(dataMap.GRUP_MID_CD != "0" && dataMap.GRUP_BOT_CD == "0"){
							currentErpTreeLvl = 2;
							document.getElementById("txtGRUP_MID_CD").readOnly = false;
							document.getElementById("txtGRUP_MID_CD").className = "input_common";
						}else{
							currentErpTreeLvl = 3;
							document.getElementById("txtGRUP_BOT_CD").readOnly = false;
							document.getElementById("txtGRUP_BOT_CD").className = "input_common";
						}
						document.getElementById("div_data_info").textContent = '상품분류 수정 중';
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- Data 추가 Function --%>
	function addData(){
		if(crud != "C"){
			var grup_top_cd = document.getElementById("txtGRUP_TOP_CD").value;
			var grup_mid_cd = document.getElementById("txtGRUP_MID_CD").value;
			
			document.getElementById("txtGRUP_TOP_CD").readOnly = true;
			document.getElementById("txtGRUP_TOP_CD").className = "input_common input_readonly";
			document.getElementById("txtGRUP_MID_CD").readOnly = true;
			document.getElementById("txtGRUP_MID_CD").className = "input_common input_readonly";
			document.getElementById("txtGRUP_BOT_CD").readOnly = true;
			document.getElementById("txtGRUP_BOT_CD").className = "input_common input_readonly";

			if(currentErpTreeId != null && currentErpTreeLvl == 3){
				document.getElementById("txtGRUP_BOT_CD").readOnly = false;
				document.getElementById("txtGRUP_BOT_CD").className = "input_common";
				$erp.alertMessage({
					"alertMessage" : "info.sis.category.grup_bot_cd.no_add_subCategorys"
					, "alertCode" : ""
					, "alertType" : "info"
				});
				return false;
			}
			
			$erp.clearInputInElement("tb_erp_data");
			
			if(currentErpTreeId == null && currentErpTreeLvl == 1){
				currentErpTreeLvl = 1;
				document.getElementById("txtGRUP_TOP_CD").readOnly = false;
				document.getElementById("txtGRUP_TOP_CD").className = "input_common";
			}else if(currentErpTreeId != null && currentErpTreeLvl == 1){
				document.getElementById("txtGRUP_TOP_CD").value = grup_top_cd;
				currentErpTreeLvl = 2;
				document.getElementById("txtGRUP_MID_CD").readOnly = false;
				document.getElementById("txtGRUP_MID_CD").className = "input_common";
			}else if(currentErpTreeId != null && currentErpTreeLvl == 2){
				document.getElementById("txtGRUP_TOP_CD").value = grup_top_cd;
				document.getElementById("txtGRUP_MID_CD").value = grup_mid_cd;
				currentErpTreeLvl = 3;
				document.getElementById("txtGRUP_BOT_CD").readOnly = false;
				document.getElementById("txtGRUP_BOT_CD").className = "input_common";
			}
			
			crud = "C";
			document.getElementById("div_data_info").textContent = '상품분류 등록 중';
		}
	}
	
	<%-- Data 저장 유효성 검증 Function --%>
	function isSaveValidate(){
		erpLayout.progressOn();
		
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
	
		var grup_cd = document.getElementById("txtGRUP_CD").value;
		var grup_nm = document.getElementById("txtGRUP_NM").value;
		var grup_top_cd = document.getElementById("txtGRUP_TOP_CD").value;
		var grup_mid_cd = document.getElementById("txtGRUP_MID_CD").value;
		var grup_bot_cd = document.getElementById("txtGRUP_BOT_CD").value;
		var grup_state = cmbGRUP_STATE.getSelectedValue();
		var grup_local_cd = cmbGRUP_LOCAL_CD.getSelectedValue();
		
		if($erp.isEmpty(crud)){
			isValidated = false;
			alertMessage = "error.common.noChanged";
			alertCode = null;
		} else if($erp.isEmpty(grup_nm)){
			isValidated = false;
			alertMessage = "error.sis.category.grup_nm.empty";
			alertCode = null;
		} else if($erp.isLengthOver(grup_nm, 50)){ 
			isValidated = false;
			alertMessage = "error.sis.category.grup_nm.length50Over";
			alertCode = null;
		} else if(
				$erp.isEmpty(currentErpTreeLvl)
				&& currentErpTreeLvl >= 1
				&& $erp.isEmpty(grup_top_cd)
				){
			isValidated = false;
			alertMessage = "error.sis.category.grup_top_cd.empty";
			alertCode = null;
		} else if(
				$erp.isEmpty(currentErpTreeLvl)
				&& currentErpTreeLvl >= 2
				&& $erp.isEmpty(grup_mid_cd)
			){
			isValidated = false;
			alertMessage = "error.sis.category.grup_mid_cd.empty";
			alertCode = null;
		} else if(
				$erp.isEmpty(currentErpTreeLvl)
				&& currentErpTreeLvl == 3
				&& $erp.isEmpty(grup_bot_cd)
			){
			isValidated = false;
			alertMessage = "error.sis.category.grup_bot_cd.empty";
			alertCode = null;
		} else if($erp.isEmpty(grup_state)){
			isValidated = false;
			alertMessage = "error.sis.category.grup_state.empty";
			alertCode = null;
		} else if($erp.isEmpty(grup_local_cd)){
			isValidated = false;
			alertMessage = "error.sis.category.grup_local_cd.empty";
			alertCode = null;
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
	
	function isDeleteValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var grup_cd = document.getElementById("txtGRUP_CD").value;
		var lower_grup_cd = erpTree.getSubItems(grup_cd);		
		
		if($erp.isEmpty(grup_cd)){
			isValidated = false;
			alertMessage = "error.common.noSelectedData";
			alertCode = null;
		}else if(!$erp.isEmpty(lower_grup_cd)){
			isValidated = false;
			alertMessage = "error.sis.category.no_delete_contain_subCategorys";
			alertCode = null;
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
	
	<%-- Data 삭제 Function --%>
	function deleteData(){
		if(!isSearchValidate()) { return false; }
		if(!isDeleteValidate()) { return false; }
		
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
	
	<%-- Data 저장 확인 Function --%>
	function saveCheck(){
		var alertMessage = '<spring:message code="alert.sis.category.saveCheck" />';
		var alertCode = "";
		var alertType = "alert";
		var callbackFunction = function(){
			saveData();
		}
		
		if(crud == "U"){
			$erp.confirmMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
				, "alertCallbackFn" : callbackFunction
			});
		}else{
			saveData();
		}
	}
	
	<%-- Data 저장 Function --%>
	function saveData(){
		if(!isSaveValidate()) { 
			erpLayout.progressOff();
			return false; 
		}
	
		var grup_cd = document.getElementById("txtGRUP_CD").value;
		var grup_nm = document.getElementById("txtGRUP_NM").value;
		var grup_top_cd = document.getElementById("txtGRUP_TOP_CD").value;
		var grup_mid_cd = document.getElementById("txtGRUP_MID_CD").value;
		var grup_bot_cd = document.getElementById("txtGRUP_BOT_CD").value;
		var grup_state = cmbGRUP_STATE.getSelectedValue();
		var grup_local_cd = cmbGRUP_LOCAL_CD.getSelectedValue();
		
		$.ajax({
			url : "/sis/standardInfo/goods/updateGoodsCategory.do"
			,data : {
				"CRUD" : crud
				, "GRUP_CD" : grup_cd
				, "GRUP_NM" : grup_nm
				, "GRUP_TOP_CD" : grup_top_cd
				, "GRUP_MID_CD" : grup_mid_cd
				, "GRUP_BOT_CD" : grup_bot_cd
				, "GRUP_STATE" : grup_state
				, "GRUP_LOCAL_CD" : grup_local_cd
				, "currentErpTreeLvl" : currentErpTreeLvl
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					if(data.resultMsg == "SAVE_SUCCESS"){
						$erp.alertSuccessMesage(onAfterSaveData);
					}else if(data.resultMsg == "DEL_SUCCESS"){
						$erp.alertDeleteMesage(onAfterSaveData);
					}else if(data.resultMsg == "DUPL"){
						$erp.alertMessage({
							"alertMessage" : "error.sis.category.dupl_grup_cd"
							, "alertCode" : null
							, "alertType" : "error"
						});
					}else{
						$erp.alertMessage({
							"alertMessage" : "저장이 완료되었습니다.",
							"alertType" : "alert",
							"isAjax" : false,
							"alertCallbackFn" : function(){
								searchErpTree();
							}
						});
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- Data 저장 후 Function --%>
	function onAfterSaveData(){
		searchErpTree();
	}
	<%-- ■ 자료 상세 (Data) 관련 Function 끝 --%>
	
	<%--
	**************************************************
	* 기타 영역
	**************************************************
	--%>	
	
	<%-- ■ dhtmlxCombo 관련 Function 시작 --%>
	<%-- dhtmlxCombo 초기화 Function --%>
	function initDhtmlXCombo(){
		cmbGRUP_STATE = $erp.getDhtmlXCombo('cmbGRUP_STATE', 'GRUP_STATE', ['YN_CD','YN'], 100, false);
		cmbGRUP_LOCAL_CD = $erp.getDhtmlXCombo('cmbGRUP_LOCAL_CD', 'GRUP_LOCAL_CD', 'GOODS_GRUP', 100, false);
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
	
	<%-- 영문입력 방지  Function 시작--%>
	function fn_press(event,type){
		if(type == "numbers"){
			if(event.keyCode < 48 || event.keyCode > 57 ) 
				return false;
		}
	}
	
</script>
</head>
<body>
	<div id="div_erp_1" class="div_common_contents_full_size">
		<div id="div_erp_toolbar" class="div_toolbar_full_size"  style="display:none"></div>
		<div id="div_erp_tree" class="div_tree_full_size"></div>
	</div>
	<div id="div_erp_2" class="div_common_contents_full_size">
		<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_contents_wrapper" class="div_common_contents_full_size" style="display:none">
			<table id="tb_erp_data" class="tb_erp_common">
				<colgroup>
					<col width="150px" />
					<col width="*" />
				</colgroup>
					<tr>
						<td colspan="2" class="td_subject"><div id="div_data_info" class="common_center">상품분류 등록/수정 대기중</div></td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>상품분류코드</th>
						<td>
							<input type="text" id="txtGRUP_CD" name="GRUP_CD" class="input_common input_readonly" maxlength="20" readonly="readonly">
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>상품분류명</th>
						<td>
							<input type="text" id="txtGRUP_NM" name="GRUP_NM" class="input_common" maxlength="30">
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>대분류</th>
						<td>
							<input type="text" id="txtGRUP_TOP_CD" name="GRUP_TOP_CD" class="input_common" onkeypress="return fn_press(event,'numbers');" maxlength="3">
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>중분류</th>
						<td>
							<input type="text" id="txtGRUP_MID_CD" name="GRUP_MID_CD" class="input_common" onkeypress="return fn_press(event,'numbers');" maxlength="3">
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>소분류</th>
						<td>
							<input type="text" id="txtGRUP_BOT_CD" name="GRUP_BOT_CD" class="input_common" onkeypress="return fn_press(event,'numbers');" maxlength="3">
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>사용여부</th>
						<td>
							<div id="cmbGRUP_STATE"></div>
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>부문관리코드</th>
						<td>
							<div id="cmbGRUP_LOCAL_CD"></div>
						</td>
					</tr>
			</table>
		</div>
	</div>
</body>
</html>