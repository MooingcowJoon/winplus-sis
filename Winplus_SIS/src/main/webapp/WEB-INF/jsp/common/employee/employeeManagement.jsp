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
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpLeftGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbUSE_YN : Object / 사용여부 DhtmlXCombo  (CODE : 'YN_CD' / 빈 칸 : 전체)
		■ cmbCMMN_YN : Object / 공통여부 DhtmlXCombo  (CODE : 'YN_CD' / 빈 칸 : 전체) 		 
	--%>
		
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
		
	var erpLayout;	
	var erpLeftLayout;
	
	var erpLeftGrid;
	var erpGridColumns;
	var erpRibbon;
	
	var erpGridDataProcessor;	
	var erpRightBottomGridDataProcessor;
	var cmbUSE_YN;

	var crud = "";
	
	$(document).ready(function(){		

		initErpLayout();
		initErpLeftSubLayout();
		initErpRibbon();
		initErpGrid();
		
		initErpRightLayout();
		initErpRightSubLayout();
		
		initloginAddRibbon();
		initloginAddGrid();
		
		initDhtmlXCombo();
		
		initReadonlyWhenPageLoad();
		
		//모든 레이아웃 초기화 함수 호출후 등록해주세요.
		$erp.asyncObjAllOnCreated(function(){
			searchErpGrid();
		});
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
					//, {id : "excel_data", type : "button", text:'<spring:message code="ribbon.loginChange" />', isbig : false, img : "menu/reload.gif", imgdis : "menu/reload_dis.gif", disable : false}	
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_data"){
				searchErpGrid();
		    } else if (itemId == "add_data"){
		    	addData();
		    } else if (itemId == "delete_data"){
		    	deleteData();
		    } else if (itemId == "save_data"){
		    	saveData();
		    } /* else if (itemId == "excel_data"){
		    	loginChange();
		    } */
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ dlvRibbon 초기화 Function --%>
	function initloginAddRibbon(){
		loginAddRibbon = new dhtmlXRibbon({
			parent : "div_login_add_ribbon"
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
		
		loginAddRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_right_data"){
		    	addLoginAddData();
		    } else if (itemId == "delete_right_data"){
		    	deleteLoginAddData();
		    } else if (itemId == "save_right_data"){
		    	saveErpRightBottomGrid();
		    }
		});
	}
	<%-- ■ Ribbon 관련 Function 끝 --%>
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2U"
			, cells: [
				{id: "a", text: "사용자 목록", header:true, width:550, fix_size:[true, true]}
				, {id: "b", text: "사용자 정보", header:true}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_left_sub_layout");
		erpLayout.cells("b").attachObject("div_erp_right_layout");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpLeftLayout.setSizes();
			erpRightLayout.setSizes();
			erpRightSubLayout.setSizes();
		});
	}

	function initErpLeftSubLayout(){
		erpLeftLayout = new dhtmlXLayoutObject({
			parent: "div_erp_left_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, fix_size:[true, true]}
				, {id: "b", text: "", header:false}
				, {id: "c", text: "", header:false}
			]			
		});
		
		erpLeftLayout.cells("a").attachObject("div_erp_contents_search");
		erpLeftLayout.cells("a").setHeight($erp.getTableHeight(1));

		erpLeftLayout.cells("b").attachObject("div_erp_ribbon");
		erpLeftLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);

		erpLeftLayout.cells("c").attachObject("div_erp_contents");
		erpLeftLayout.setSeparatorSize(0, 1);
		erpLeftLayout.setSeparatorSize(1, 1);

		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLeftLayout, function(names){
			erpLeftGrid.setSizes();
		});
	}
	
	<%-- erpRightLayout 초기화 Function --%>	
	function initErpRightLayout(){
		erpRightLayout = new dhtmlXLayoutObject({
			parent: "div_erp_right_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "", header:false, fix_size:[true, true]}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
			]		
		});

		erpRightLayout.cells("a").attachObject("div_erp_right_content");
		erpRightLayout.cells("a").setHeight(416);
		erpRightLayout.cells("a").hideArrow();
		erpRightLayout.cells("b").attachObject("div_erp_right_sub_contents");
		
		erpRightLayout.setSeparatorSize(1, 0);

		<%-- erpRightLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpRightLayout, function(names){
			erpRightBottomGrid.setSizes();
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
				{id: "a", text: "로그인 변경 사용자 목록", header:true, fix_size:[true, true]}
				, {id: "b", text: "", header:false}
			]		
		});
		
		erpRightSubLayout.cells("a").attachObject("div_login_add_ribbon");
		erpRightSubLayout.cells("a").setHeight(65);
		erpRightSubLayout.cells("a").hideArrow();
		erpRightSubLayout.cells("b").attachObject("div_erp_right_grid");
		
		erpRightSubLayout.setSeparatorSize(1, 0);

		<%-- erpRightSubLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpRightSubLayout, function(names){
			erpRightBottomGrid.setSizes();
		})
		
	}
	<%-- erpRightSubLayout 관련 Function 끝 --%>
	
	function initErpGrid(){
		erpGridColumns=[
   			{id : "SELECT", label : ["선택"], type : "ra", width : "40", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
   			, {id : "EMP_NO", label:["사용자번호"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "EMP_NM", label:["사용자명"], type: "ro", width: "70", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_DELEGATE_NM", label:["대표조직명"], type: "ro", width: "110", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "ORGN_NM", label:["조직명"], type: "ro", width: "110", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "USE_YN", label:["사용여부"], type: "ro", width: "52", sort : "str", align : "center", isHidden : false, isEssential : false}
   		];
   		
   		erpLeftGrid = new dhtmlXGridObject({
   			parent: "div_erp_contents"			
   			, skin : ERP_GRID_CURRENT_SKINS
   			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
   			, columns : erpGridColumns
   		});
		    		
		$erp.initGridCustomCell(erpLeftGrid);
		$erp.initGridComboCell(erpLeftGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpLeftGrid, '<spring:message code="grid.allRowCount" />');

		erpLeftGrid.attachEvent("onCheck", function(rId,cInd){

			if(cInd == this.getColIndexById("SELECT")){
				
				var empNo = this.cells(rId, this.getColIndexById("EMP_NO")).getValue();

				searchData(empNo);
			}
		 });
	}
	
	<%-- dlvGrid 관련 Function 시작 --%>
	function initloginAddGrid(){
		erpRightBottomGridColumns=[
			{id : "NO", label : ["NO"], type : "cntr", width : "48", sort : "int", align : "center", isHidden : false, isEssential : false}	
			, {id : "CHECK", name:"CHECK", label : ["#master_checkbox"], type : "ch", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "EMP_NO", label:["사용자번호"], type: "ro", width: "80", align : "center", isHidden : true, isEssential : false}
			, {id : "EMP_NO_LOGIN_ADD", label:["사용자번호"], type: "ro", width: "80", align : "center", isHidden : false, isEssential : false}
			, {id : "EMP_NM", label:["사용자명"], type: "ro", width: "115", align : "left", isHidden : false, isEssential : false}
			, {id : "ORGN_DIV_NM", label:["조직구분"], type: "ro", width: "80",align : "left", isHidden : false, isEssential : true}
			, {id : "ORGN_NM", label:["조직명"], type: "ro", width: "110", align : "left", isHidden : false, isEssential : false}
			, {id : "USE_YN", label : ["사용여부"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["YN_CD","YN"]}
			, {id : "REG_DT", label:["생성일"], type: "ro", width: "90",align : "left", isHidden : false, isEssential : false}
			, {id : "REG_ID", label:["생성자"], type: "ro", width: "80",align : "left", isHidden : false, isEssential : false}
			, {id : "MOD_DT", label:["수정일"], type: "ro", width: "90",align : "left", isHidden : false, isEssential : false}
			, {id : "MOD_ID", label:["수정자"], type: "ro", width: "80",align : "left", isHidden : false, isEssential : false}
		];
		
		erpRightBottomGrid = new dhtmlXGridObject({
			parent: "div_erp_right_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpRightBottomGridColumns
		});
		
		erpRightBottomGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpRightBottomGrid);
		$erp.initGridComboCell(erpRightBottomGrid);
		
		erpRightBottomGridDataProcessor = new dataProcessor();
		erpRightBottomGridDataProcessor.init(erpRightBottomGrid);
		erpRightBottomGridDataProcessor.setUpdateMode("off");
		
		
		erpRightBottomGrid.attachEvent("onRowSelect", function(rId, cInd){
			var popupOk = true;
			if(typeof rId != "undefined"){
				if(cInd != 3 && cInd != 4){
					popupOk = false;
				}
				if(popupOk){
					var empNo = this.cells(rId, this.getColIndexById("EMP_NO_LOGIN_ADD")).getValue();
					var empNm = this.cells(rId, this.getColIndexById("EMP_NM")).getValue();
					if(empNo=='' || empNm=='')
						openSearchEmpPopup(rId, cInd);
				}
			}
		});
 
		$erp.attachDhtmlXGridFooterRowCount(erpRightBottomGrid, '<spring:message code="grid.allRowCount" />');
	} 
	<%-- dlvGrid 관련 Function 시작 --%>
	
	<%-- erpLeftGrid 조회 Function --%>
	function searchErpGrid(){
		var schEmpNm = document.getElementById("txtSCH_EMP_NM").value;
		var schOrgnDivCd = cmbSCH_ORGN_DIV_CD.getSelectedValue();
		var schUseYn = cmbSCH_USE_YN.getSelectedValue();

		erpLayout.progressOn();

		$.ajax({
			url : "/common/employee/getEmpList.do"
				,data : $erp.dataSerialize("table_search", "Q", false)
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						$erp.clearDhtmlXGrid(erpLeftGrid);
						
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpLeftGrid
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpLeftGrid.parse(gridDataList, 'js');	
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpLeftGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
		});
	}
	
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
	
	<%-- Data 삭제 유효성 검증 Function --%>
	function isDeleteValidate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";

		var empNo = document.getElementById("txtEMP_NO").value;

		if($erp.isEmpty(empNo)){
			isValidated = false;
			alertMessage = "error.common.organ.employee.empNo.noData";
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
	function searchData(empNo){

		erpLayout.progressOn();

		$.ajax({
			url : "/common/employee/getEmp.do"
			,data : {
				"EMP_NO" : empNo
				,"SITE_DIV_CD" : "SIS"
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
						document.getElementById("div_data_info").textContent = '사용자 수정중';
						$erp.dataAutoBind("table_data", dataMap);
						
						$erp.clearDhtmlXGrid(erpRightBottomGrid);
						searchErpRightBottomGrid(empNo);
												
						initReadonlyWhenUpdate();

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
						
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- erpLeftGrid 추가 Function --%>
	function addData(){
		crud = "C";
		$erp.clearInputInElement("table_data");
		document.getElementById("div_data_info").textContent = '사용자 등록 중';
		
		initReadonlyWhenCreate();
	}
	
	<%-- erpLeftGrid 저장 Function --%>
	function saveData(){
		var result;
		if(crud == "C" || crud == "U"){
			result = $erp.tableValidationCheck("table_data");
			if(result === false){
				$erp.alertMessage({
					"alertMessage" : "필수 입력 항목이 남아있습니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
				return;
			}
		}

		result["CRUD"] = crud;
		result["SEARCHABLE_AUTH_CD"] = $.grep(cmbSEARCHABLE_AUTH_CD.getChecked(), function(val){ return val != '';}).join(",");
		result["SITE_DIV_CD"] = "SIS";

		$.ajax({
			url : "/common/employee/insertEmp.do"
			,data : result
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
			}
		});
	}

	
	<%-- erpLeftGrid 저장 후 Function --%>
	function onAfterSaveData(){
		$erp.clearInputInElement("table_data");
		searchErpGrid();
		crud = "";
		document.getElementById("div_data_info").textContent = '사용자 조회/수정 대기중';
	}
	
	<%-- Data 삭제 Function --%>
	function deleteData(){
		
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
	
	<%-- ■ readonly 관련 Function 시작 --%>
	function initReadonlyWhenPageLoad(){
		$('input').prop('readonly', true);
		
		//왼쪽 검색 조건 항상 리드 온리 해제
		$("#txtSCH_EMP_NM").attr("readonly",false);
	}
	
	function initReadonlyWhenUpdate(){
		$('input').prop('readonly', false);
		$(".input_readonly").attr("readonly", true);
		$("#txtID").attr("readonly", true);
		$("#txtEMP_NO").attr("readonly", true);
		
		//왼쪽 검색 조건 항상 리드 온리 해제
		$("#txtSCH_EMP_NM").attr("readonly",false);
	}
	
	function initReadonlyWhenCreate(){
		$('input').prop('readonly', false);
		$(".input_readonly").attr("readonly", true);
		
		//왼쪽 검색 조건 항상 리드 온리 해제
		$("#txtSCH_EMP_NM").attr("readonly",false);
	}
	
	
	
	
	
	<%-- ■ erpRightBottomLayout event관련 Function 시작 --%>
	<%-- Data 조회 Function --%>
	function searchErpRightBottomGrid(sEmpNo){
		erpLayout.progressOn();
		var url = "/common/employee/getEmpLoginAddList.do";
		var data = {
				"EMP_NO": sEmpNo
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
						erpRightBottomGrid
						, '<spring:message code="grid.noSearchData" />'
					);
				} else {
					erpRightBottomGrid.parse(gridDataList, 'js');
				}
			}
			$erp.setDhtmlXGridFooterRowCount(erpRightBottomGrid);
		});
	}
	
	function isErpRightBottomEditValidate(){
		var empNo = document.getElementById("txtEMP_NO").value;

		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		if($erp.isEmpty(empNo)){
			isValidated = false;
			alertMessage = "error.common.noSelectedEmp";
			alertCode = "-22";
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
	
	function addLoginAddData(){
		if(!isErpRightBottomEditValidate()) { return; }	
		
		var empNo = document.getElementById("txtEMP_NO").value;
		
		var uid = erpRightBottomGrid.uid();
		erpRightBottomGrid.addRow(uid);
		var rowIndex = erpRightBottomGrid.getRowIndex(uid);
		erpRightBottomGrid.cells(uid, erpRightBottomGrid.getColIndexById("EMP_NO")).setValue(empNo);
		erpRightBottomGrid.cells(uid, erpRightBottomGrid.getColIndexById("USE_YN")).setValue("Y");
		erpRightBottomGrid.selectRow(rowIndex);
		
		$erp.setDhtmlXGridFooterRowCount(erpRightBottomGrid);
	}
	
	function deleteLoginAddData(){
		if(!isErpRightBottomEditValidate()) { return; }
		
		var gridRowCount = erpRightBottomGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpRightBottomGrid.getRowId(i);
			var check = erpRightBottomGrid.cells(rId, erpRightBottomGrid.getColIndexById("CHECK")).getValue();
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
			erpRightBottomGrid.cells(deleteRowIdArray[i], erpRightBottomGrid.getColIndexById("USE_YN")).setValue("N");
			erpRightBottomGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpRightBottomGrid);
	}
	
	<%-- Data 저장 유효성 검증 Function --%>
	function isErpRightBottomGSaveValidate(){
		var empNo = document.getElementById("txtEMP_NO").value;

		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(empNo)){
			isValidated = false;
			alertMessage = "error.common.noSelectedEmp";
			alertCode = "-5";
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
	
	<%-- Data 저장 Function --%>
	function saveErpRightBottomGrid(){
		if(erpRightBottomGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpRightBottomGrid);
		if(validResultMap.isError){
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		}
		
		if(!isErpRightBottomGSaveValidate()) { return false; }
		erpLayout.progressOn();
		
		var url = "/common/employee/saveEmpLoginAddList.do";
		var paramData = $erp.serializeDhtmlXGridData(erpRightBottomGrid);
		var method = "POST";
		doAjax(url, paramData, method, function(data) {
			erpLayout.progressOff();
			if(data.isError){
				$erp.ajaxErrorMessage(data);
			} else {			
				$erp.alertSuccessMesage(onAfterErpRightBottomGridSaveData);
				onAfterErpRightBottomGridSaveData();
			}
		});
	}
	
	<%-- erpGrid 저장 후 Function --%>
	function onAfterErpRightBottomGridSaveData(){
		
		var empNo = document.getElementById("txtEMP_NO").value;
		
		$erp.clearDhtmlXGrid(erpRightBottomGrid);
		searchErpRightBottomGrid(empNo);
	}
	
	<%-- 로그인 변경 Function --%>	
	/* function loginChange(){

		var id = document.getElementById("txtID").value;
		var empNo = document.getElementById("txtEMP_NO").value;

		if($erp.isEmpty(id)){
			var alertType = "error";
			var alertMessage = "error.common.system.login.loginCommonError";
			var alertCode = "-9";
			
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
			
			return false;
		}
		
		$.ajax({
			url : "/loginChange.do"
			,data : {
				"ID" : id
				, "EMP_NO" : empNo
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					top.location.href = "/index.sis";
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	} */
	
	
	<%-- 조직 검색 Popup 열기 Function --%>	
	function openSearchOrgnPopup(idSuffix){
		
		<%--
		var orgnDivCd = this.cells(rId, this.getColIndexById("ORGN_DIV_CD")).getValue();
		if(orgnDivCd=='00004'||orgnDivCd=='00005'){
			return false
		}
		--%>
		
		if(crud==""){
			return false
		}
		
		if($erp.isEmpty(idSuffix)){
			idSuffix = "";
		}		

		var onRowDblClicked = function(rId, cInd){
						
			var orgnCd = this.cells(rId, this.getColIndexById("ORGN_CD")).getValue();
			var orgnNm = this.cells(rId, this.getColIndexById("ORGN_NM")).getValue();
			var orgnDivCd = this.cells(rId, this.getColIndexById("ORGN_DIV_CD")).getValue();
			var orgnDivNM = this.cells(rId, this.getColIndexById("ORGN_DIV_NM")).getValue();

			
			document.getElementById("txtDEPT_CD").value=orgnCd;
			document.getElementById("txtORGN_NM").value=orgnNm;
			cmbORGN_DIV_CD.setComboValue(orgnDivCd);
			
			$erp.closePopup();			
		}
		
		var srchOrgnNm = document.getElementById("txtORGN_NM" + idSuffix).value; 

		$erp.openSearchOrgnPopup(srchOrgnNm, onRowDblClicked);
	}
	
	<%-- 조직명 변경 시 Event Function --%>
	function onChangeMtrlNm(idSuffix){
		document.getElementById('txtORGN_CD').value='';

		changeContractForm("", idSuffix);
	}
	
	
	<%-- 사용자 검색 Popup 열기 Function --%>
	function openSearchEmpPopup(sRId, sCInd){
		var onRowDblClicked = function(rId, cInd){
			var empNo = this.cells(rId, this.getColIndexById("EMP_NO")).getValue();
			var empNm = this.cells(rId, this.getColIndexById("EMP_NM")).getValue();
			var orgnDivNm = this.cells(rId, this.getColIndexById("ORGN_DIV_NM")).getValue();
			var orgnNm = this.cells(rId, this.getColIndexById("ORGN_NM")).getValue();
			
			var rowNums = erpRightBottomGrid.getRowsNum();
			var isAdd = true;
			for(var i=0; i<rowNums ; i++){
				var gridEmpNo = erpRightBottomGrid.getRowData(erpRightBottomGrid.getRowId(i));
				if(gridEmpNo.EMP_NO == empNo){
					isAdd = false;
					var alertMessage = "error.common.organ.employee.empNo.overlapData";
					var alertCode = "-11";
					var alertType = "error";
					$erp.alertMessage({
						"alertMessage" : alertMessage
						, "alertCode" : alertCode
						, "alertType" : alertType
					});					
				}
			}
			if(isAdd == true){
				if(erpRightBottomGrid.cells(sRId, erpRightBottomGrid.getColIndexById("EMP_NO")).getValue() != ""){
					erpRightBottomGridDataProcessor.setUpdated(sRId,true,"updated");
				}
				erpRightBottomGrid.cells(sRId, erpRightBottomGrid.getColIndexById("EMP_NO_LOGIN_ADD")).setValue(empNo);
				erpRightBottomGrid.cells(sRId, erpRightBottomGrid.getColIndexById("EMP_NM")).setValue(empNm);
				erpRightBottomGrid.cells(sRId, erpRightBottomGrid.getColIndexById("ORGN_DIV_NM")).setValue(orgnDivNm);
				erpRightBottomGrid.cells(sRId, erpRightBottomGrid.getColIndexById("ORGN_NM")).setValue(orgnNm);
				erpRightBottomGrid.cells(sRId, erpRightBottomGrid.getColIndexById("USE_YN")).setValue("Y");
			}
			$erp.closePopup();			
		}
		
		$erp.openSearchEmpPopup("", onRowDblClicked);
	}
	
	<%--
	**************************************************
	* 기타 영역
	**************************************************
	--%>	
	
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
	
	
	<%-- ■ dhtmlxCombo 관련 Function 시작 --%>
	<%-- dhtmlxCombo 초기화 Function --%>
	function initDhtmlXCombo(){
		
		cmbSCH_ORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbSCH_ORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 160, "전체", false);
		cmbSCH_USE_YN = $erp.getDhtmlXComboCommonCode("cmbSCH_USE_YN", "SCH_USE_YN", ["USE_CD", "YN"], 80, null, false, null);
		
		cmbORGN_DIV_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "ORGN_DIV_CD", 160, "전체", false, null);
		cmbORGN_DIV_CD.disable();
		
		cmbDLV_DUTY_CD = $erp.getDhtmlXComboCommonCode("cmbDLV_DUTY_CD", "DLV_DUTY_CD", "DLV_DUTY_CD", 100, null, true, null);
		cmbDLV_BSN_CD = $erp.getDhtmlXComboCommonCode("cmbDLV_BSN_CD", "DLV_BSN_CD", "DLV_BSN_CD", 100, null, true, null);
		
		cmbSEARCHABLE_AUTH_CD = $erp.getDhtmlXComboMulti("cmbSEARCHABLE_AUTH_CD", "SEARCHABLE_AUTH_CD", "SEARCHABLE_AUTH_CD", 135, "전체선택");
		cmbUSE_YN = $erp.getDhtmlXComboCommonCode("cmbUSE_YN", "USE_YN", ["USE_CD", "YN"], 100, null, false, null);
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
	
</script>
</head>
<body>

	<div id="div_erp_left_sub_layout" class="samyang_div" style="display:none"></div>
	<div id="div_erp_contents_search" class="samyang_div" style="display:none">
		<table id="table_search" class="samyang_div">
			<colgroup>
				<col width="60px"/>
				<col width="170px"/>
				<col width="60px"/>
				<col width="80px"/>
				<col width="60px"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<th>법인구분</th>
				<td><div id="cmbSCH_ORGN_DIV_CD"></div></td>
				<th>사용자</th>
				<td>
					<input type="text" id="txtSCH_EMP_NM" class="input_common" style="width:70px" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid, ['']);">
				</td>
				<th>사용여부</th>
				<td><div id="cmbSCH_USE_YN"></div></td>

			</tr>
		</table>
		
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size"></div>
	<div id="div_erp_contents" class="div_grid_full_size"></div>
	
	<div id="div_erp_right_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_right_content" class="div_common_contents_full_size" style="display:none">
			<table id="table_data" class="tb_erp_common">
				<colgroup>
					<col width="150px" />
					<col width="*" />
				</colgroup>
					<tr>
						<td colspan="2" class="td_subject"><div id="div_data_info" class="common_center">사원 등록/수정 대기중</div></td>
					</tr>
					
					<tr>
						<th><span class="span_essential">*</span>아이디</th>
						<td>
							<input type="text" id="txtID" name="ID" class="input_common" maxlength="50" value="" data-isEssential="true">		
						</td>
					</tr>
					
					<tr>
						<th><span class="span_essential">*</span>사원번호</th>
						<td>
							<input type="text" id="txtEMP_NO" name="EMP_NO" class="input_common" maxlength="20" data-isEssential="true">
						</td>
					</tr>
					
					<tr>
						<th><span class="span_essential">*</span>사원명</th>
						<td>
							<input type="text" id="txtEMP_NM" name="EMP_NM" class="input_common" maxlength="20" width="100" data-isEssential="true">
						</td>
					</tr>
					
					<tr>
						<th><span class="span_essential">*</span>조직명</th>
						<td>
							<input type="text" id="txtORGN_NM" name="ORGN_NM" class="input_common input_readonly" maxlength="50" style="width: 300px"  onchange="onChangeOrgnNm('');" onkeydown="$erp.onEnterKeyDown(event, openSearchOrgnPopup, ['']);" data-isEssential="true" readonly disabled>
							<input type="button" class="input_common_button" value="검색" onclick="openSearchOrgnPopup('');">
						</td>
					</tr>	
						
					<tr>
						<th><span class="span_essential">*</span>조직 코드</th>
						<td>
							<input type="text" id="txtDEPT_CD" name="DEPT_CD" class="input_common input_readonly" maxlength="20" width="100" data-isEssential="true" readonly disabled>
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>조직구분</th>
						<td>
							<div id="cmbORGN_DIV_CD" data-isEssential="true"></div>
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>이메일</th>
						<td>
							<input type="text" id="txtEMAIL" class="input_common" maxlength="100" style="width: 300px" value="" data-isEssential="true" data-type="email">
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>핸드폰번호</th>
						<td>
							<input type="text" id="txtMBTLNUM" name="MBTLNUM" class="input_common input_phone" maxlength="20" width="100" data-isEssential="true">
						</td>
					</tr>
					<tr>
						<th>직책구분코드</th>
						<td>
							<div id="cmbDLV_DUTY_CD"></div>
						</td>
					</tr>
					<tr>
						<th>업무구분코드</th>
						<td>
							<div id="cmbDLV_BSN_CD"></div>
						</td>
					</tr>
					<tr>
						<th>검색허용권한</th>
						<td>
							<div id="cmbSEARCHABLE_AUTH_CD"></div>
						</td>
					</tr>
					<tr>
						<th>사용여부</th>
						<td>
							<div id="cmbUSE_YN"></div>
						</td>
					</tr>
					<tr>
						<th>생성자</th>
						<td>
							<input type="text" id="txtREG_ID" name="REG_ID" class="input_common input_readonly" maxlength="20">
						</td>
					</tr>
					<tr>
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
					</tr>
					<tr>
						<th>수정일자</th>
						<td>
							<input type="text" id="txtMOD_DT" name="MOD_DT" class="input_common input_readonly" maxlength="20">
						</td>
					</tr>
			</table>
		</div>
	
	</div>	
	
	<div id="div_erp_right_sub_contents" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_login_add_ribbon" class="div_ribbon_full_size"></div>
		<div id="div_erp_right_grid" class="div_grid_full_size" style="display:none"></div>
	</div>	
</body>
</html>