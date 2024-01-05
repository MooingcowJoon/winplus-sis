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
		■ cmbUSE_YN : Object / 관리상태여부 DhtmlXCombo (공통코드 : YN_CD)
		■ cmbFOLDER_YN : Object / 관리상태여부 DhtmlXCombo (공통코드 : YN_CD)
		■ crud : String / CRUD 구분용
	--%>
	var erpLayout;
	var erpRibbon;
	var erpTree;	
	var currentErpTreeId;
	var cmbUSE_YN;
	var cmbFOLDER_YN;
	var crud;
	
	$(document).ready(function(){		
		initErpLayout();
		initErpRibbon();
		initErpTree();
		initDhtmlXCombo();
		searchErpTree();
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3L"
			, cells: [
				{id: "a", text: "${menuDto.menu_nm}", header:true, width:300}
				, {id: "b", text: "", header:false, fix_size : [true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_tree");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("c").attachObject("div_erp_contents_wrapper");
		
		erpLayout.setSeparatorSize(1, 0);
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
					{id : "add_data", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					, {id : "delete_data", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_data", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					//, {id : "excel_data", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : true}
					//, {id : "print_data", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, unused : true}	
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_data"){
		    	
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
				if(id == "#root"){
					crud = null;
					currentErpTreeId = null;
					$erp.clearInputInElement("tb_erp_data");
					document.getElementById("div_data_info").textContent = '메뉴 등록/수정 대기중';
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
			url : "/common/system/menu/menuManagementR1.do"
			,data : {}
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
						crud = null;
						currentErpTreeId = null;
						$erp.clearInputInElement("tb_erp_data");
						document.getElementById("div_data_info").textContent = '메뉴 등록/수정 대기중';
						erpTree.openAllItems("0");
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
			url : "/common/system/menu/menuManagementR2.do"
			,data : {
				"MENU_CD" : currentErpTreeId
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
						document.getElementById("OLD_MENU_NM").value=document.getElementById("txtMENU_NM").value;
						document.getElementById("div_data_info").textContent = '메뉴 수정 중';
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
			var menu_cd = document.getElementById("txtMENU_CD").value;		
			var menu_nm = document.getElementById("OLD_MENU_NM").value;

			$erp.clearInputInElement("tb_erp_data");
			
			if(!$erp.isEmpty(menu_cd)){		
				document.getElementById("txtUPPER_MENU_CD").value = menu_cd;
				document.getElementById("txtUPPER_MENU_NM").value = menu_nm;			
			}
			crud = "C";
			document.getElementById("div_data_info").textContent = '메뉴 등록 중';
		}
	}
	
	<%-- Data 저장 유효성 검증 Function --%>
	function isSaveValidate(){
		erpLayout.progressOn();
		
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
	
		var menu_nm = document.getElementById("txtMENU_NM").value;
		var menu_ordr = document.getElementById("txtMENU_ORDR").value;
		var use_yn = cmbUSE_YN.getSelectedValue();
		var folder_yn = cmbFOLDER_YN.getSelectedValue();
		
		if($erp.isEmpty(crud)){
			isValidated = false;
			alertMessage = "error.common.noChanged";
			alertCode = "-1";
		} else if($erp.isEmpty(menu_nm)){
			isValidated = false;
			alertMessage = "error.common.system.menu.menu_nm.empty";
			alertCode = "-2";
		} else if($erp.isLengthOver(menu_nm, 50)){ 
			isValidated = false;
			alertMessage = "error.common.system.menu.menu_nm.length50Over";
			alertCode = "-3";
		} else if($erp.isEmpty(menu_ordr) || isNaN(menu_ordr)){
			isValidated = false;
			alertMessage = "error.common.system.menu.menu_ordr.onlyNumber";
			alertCode = "-4";
		} else if($erp.isEmpty(use_yn)){
			isValidated = false;
			alertMessage = "error.common.use_yn.empty";
			alertCode = "-5";
		} else if($erp.isEmpty(folder_yn)){
			isValidated = false;
			alertMessage = "error.common.system.menu.folder_yn.empty";
			alertCode = "-6";
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
		
		var menu_cd = document.getElementById("txtMENU_CD").value;
		var lower_menu_cd = erpTree.getSubItems(menu_cd);		
		
		if($erp.isEmpty(menu_cd)){
			isValidated = false;
			alertMessage = "error.common.noSelectedData";
			alertCode = "-1";
		}else if(!$erp.isEmpty(lower_menu_cd)){
			isValidated = false;
			alertMessage = "error.common.system.menu.no_delete_contain_submenus";
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
	
	<%-- Data 저장 Function --%>
	function saveData(){
		if(!isSaveValidate()) { 
			erpLayout.progressOff();
			return false; 
		}		
	
		var menu_cd = document.getElementById("txtMENU_CD").value;
		var menu_nm = document.getElementById("txtMENU_NM").value;
		var use_yn = cmbUSE_YN.getSelectedValue();
		var folder_yn = cmbFOLDER_YN.getSelectedValue();
		var upper_menu_cd = document.getElementById("txtUPPER_MENU_CD").value;
		var menu_ordr = document.getElementById("txtMENU_ORDR").value;
		
		$.ajax({
			url : "/common/system/menu/menuManagementCUD1.do"
			,data : {
				"CRUD" : crud
				, "MENU_CD" : menu_cd
				, "MENU_NM" : menu_nm
				, "USE_YN" : use_yn
				, "FOLDER_YN" : folder_yn
				, "UPPER_MENU_CD" : upper_menu_cd
				, "MENU_ORDR" : menu_ordr
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					$erp.alertSuccessMesage(onAfterSaveData);					
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
		cmbUSE_YN = $erp.getDhtmlXCombo('cmbUSE_YN', 'USE_YN', ['YN_CD','YN'], 100, false);
		cmbFOLDER_YN = $erp.getDhtmlXCombo('cmbFOLDER_YN', 'FOLDER_YN', ['YN_CD','YN'], 100, false);
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_tree" class="div_tree_full_size"></div>	
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_contents_wrapper" class="div_common_contents_full_size" style="display:none">
		<table id="tb_erp_data" class="tb_erp_common">
			<colgroup>
				<col width="150px" />
				<col width="*" />
			</colgroup>
				<tr>
					<td colspan="2" class="td_subject"><div id="div_data_info" class="common_center">메뉴 등록/수정 대기중</div></td>
				</tr>
				<tr>
					<th><span class="span_essential">*</span>메뉴코드</th>
					<td>
						<input type="text" id="txtMENU_CD" name="MENU_CD" class="input_common input_readonly" maxlength="20" readonly="readonly">					
					</td>
				</tr>
				<tr>
					<th><span class="span_essential">*</span>메뉴명</th>
					<td>
						<input type="text" id="txtMENU_NM" name="MENU_NM" class="input_common" maxlength="20">
						<input type="hidden" id="OLD_MENU_NM">
					</td>
				</tr>
				<tr>
					<th>상위메뉴코드</th>
					<td>
						<input type="text" id="txtUPPER_MENU_CD" name="UPPER_MENU_CD" class="input_common input_readonly" maxlength="20" readonly="readonly">
					</td>
				</tr>
				<tr>
					<th>상위메뉴명</th>
					<td>
						<input type="text" id="txtUPPER_MENU_NM" name="UPPER_MENU_NM" class="input_common input_readonly" maxlength="20" readonly="readonly">
					</td>
				</tr>
				<tr>
					<th><span class="span_essential">*</span>메뉴순번</th>
					<td>
						<input type="text" id="txtMENU_ORDR" name="txtORDBY" class="input_common input_number" maxlength="20">
					</td>
				</tr>
				<tr>
					<th><span class="span_essential">*</span>사용여부</th>
					<td>
						<div id="cmbUSE_YN"></div>
					</td>
				</tr>
				<tr>
					<th><span class="span_essential">*</span>폴더여부</th>
					<td>
						<div id="cmbFOLDER_YN"></div>
					</td>
				</tr>
		</table>
	</div>
</body>
</html>