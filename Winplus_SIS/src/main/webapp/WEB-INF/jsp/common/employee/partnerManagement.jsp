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
		■ totalLayout : Object / 페이지 Layout DhtmlXLayout
		■ leftRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ leftGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbUSE_YN : Object / 사용여부 DhtmlXCombo  (CODE : 'YN_CD' / 빈 칸 : 전체)
		■ cmbCMMN_YN : Object / 공통여부 DhtmlXCombo  (CODE : 'YN_CD' / 빈 칸 : 전체) 		 
	--%>
	var totalLayout;	
	var leftLayout;
	
	var leftGrid;
	var erpGridColumns;
	var leftRibbon;
	
	var erpGridDataProcessor;	
	var cmbUSE_YN;

	var crud = "";
	
	var DEPT_CD = "800000"; //협력사
	
	$(document).ready(function(){		

		initTotalLayout();
		initLeftLayout();
		initRightLayout();
		
		initReadonlyWhenPageLoad();
		
		//모든 레이아웃 초기화 함수 호출후 등록해주세요.
		$erp.asyncObjAllOnCreated(function(){
			searchLeftGrid();
		});
	});
	
	
	<%-- totalLayout 초기화 Function --%>	
	function initTotalLayout(){
		totalLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2U"
			, cells: [
				{id: "a", text: "사용자 목록", header:true, width:500, fix_size:[true, true]}
				, {id: "b", text: "사용자 정보", header:true}
			]		
		});
		
		totalLayout.cells("a").attachObject("div_left_layout");
		totalLayout.cells("b").attachObject("div_right_layout");
		
		totalLayout.setSeparatorSize(1, 0);
		
		<%-- totalLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(totalLayout, function(names){
			leftLayout.setSizes();
			rightLayout.setSizes();
		});
	}

	function initLeftLayout(){
		leftLayout = new dhtmlXLayoutObject({
			parent: "div_left_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, fix_size:[true, true]}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]			
		});
		
		leftLayout.cells("a").attachObject("div_left_table");
		leftLayout.cells("a").setHeight($erp.getTableHeight(1));

		leftLayout.cells("b").attachObject("div_left_ribbon");
		leftLayout.cells("b").setHeight(36);

		leftLayout.cells("c").attachObject("div_left_grid");
		leftLayout.setSeparatorSize(0, 1); //테이블 리본 사이간격
		leftLayout.setSeparatorSize(1, 1);

		leftLayout.captureEventOnParentResize(totalLayout); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.
		
		//검색조건
		cmbSCH_USE_YN = $erp.getDhtmlXComboCommonCode("cmbSCH_USE_YN", "SHC_USE_YN", ["USE_CD","YN"], 100, null, false, null);
		
		leftRibbon = new dhtmlXRibbon({
			parent : "div_left_ribbon"
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
		
		leftRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_data"){
				searchLeftGrid();
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
		
		erpGridColumns=[
   			{id : "SELECT", label : ["선택"], type : "ra", width : "40", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
   			, {id : "EMP_NO", label:["협력사코드"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "EMP_NM", label:["협력사명"], type: "ro", width: "115", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "ORGN_NM", label:["조직명"], type: "ro", width: "110", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "USE_YN", label:["사용여부"], type: "ro", width: "52", sort : "str", align : "center", isHidden : false, isEssential : false}
   		];
   		
   		leftGrid = new dhtmlXGridObject({
   			parent: "div_left_grid"			
   			, skin : ERP_GRID_CURRENT_SKINS
   			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
   			, columns : erpGridColumns
   		});
		    		
		$erp.initGridCustomCell(leftGrid);
		$erp.initGridComboCell(leftGrid);
		$erp.attachDhtmlXGridFooterRowCount(leftGrid, '<spring:message code="grid.allRowCount" />');

		leftGrid.attachEvent("onCheck", function(rId,cInd){
			if(cInd == this.getColIndexById("SELECT")){
				var empNo = this.cells(rId, this.getColIndexById("EMP_NO")).getValue();
				searchData(empNo);
			}
		});
	}
	
	<%-- rightLayout 초기화 Function --%>	
	function initRightLayout(){
		rightLayout = new dhtmlXLayoutObject({
			parent: "div_right_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "", header:false, fix_size:[true, true]}
			]		
		});

		rightLayout.cells("a").attachObject("div_right_table");
		
		rightLayout.captureEventOnParentResize(totalLayout); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.
		
		//정보테이블
		cmbSEARCHABLE_AUTH_CD = $erp.getDhtmlXComboMulti("cmbSEARCHABLE_AUTH_CD", "SEARCHABLE_AUTH_CD", "SEARCHABLE_AUTH_CD", 135, "전체선택");
		cmbUSE_YN = $erp.getDhtmlXComboCommonCode("cmbUSE_YN", "USE_YN", ["USE_CD","YN"], 135, null, false, null);
	}
	<%-- rightLayout 관련 Function 끝 --%>
	
	<%-- leftGrid 조회 Function --%>
	function searchLeftGrid(){
		totalLayout.progressOn();
		$.ajax({
			url : "/common/employee/getPartnerList.do"
			,data : $erp.unionObjArray([$erp.dataSerialize("table_search", "Q", false), {"DEPT_CD" : DEPT_CD}])
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				totalLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(leftGrid);
					
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(leftGrid, '<spring:message code="grid.noSearchData" />');
					} else {
						leftGrid.parse(gridDataList, 'js');	
					}
				}
				$erp.setDhtmlXGridFooterRowCount(leftGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				totalLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- ■ 자료 (Data) 관련 Function 시작 --%>
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
		totalLayout.progressOn();

		$.ajax({
			url : "/common/employee/getEmp.do"
			,data : {
				"EMP_NO" : empNo
				,"SITE_DIV_CD" : "PS"
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				totalLayout.progressOff();
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
						
						initReadonlyWhenUpdate();

						//멀티 콤보 세팅 시작
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
						//멀티 콤보 세팅 끝
						
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				totalLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- leftGrid 추가 Function --%>
	function addData(){
		crud = "C";
		$erp.clearInputInElement("table_data");
		document.getElementById("div_data_info").textContent = '사용자 등록 중';
		
		var checkedRow = leftGrid.getCheckedRows(leftGrid.getColIndexById("SELECT"));
		
		console.log(checkedRow);
		
		initReadonlyWhenCreate();
	}
	
	<%-- leftGrid 저장 Function --%>
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
		result["DEPT_CD"] = DEPT_CD;
		result["SEARCHABLE_AUTH_CD"] = $.grep(cmbSEARCHABLE_AUTH_CD.getChecked(), function(val){ return val != '';}).join(",");
		result["SITE_DIV_CD"] = "PS";
		
		$.ajax({
			url : "/common/employee/insertEmp.do"
			,data : result
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				totalLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					$erp.alertSuccessMesage(onAfterSaveData);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				totalLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	
	<%-- leftGrid 저장 후 Function --%>
	function onAfterSaveData(){
		$erp.clearInputInElement("table_data");
		searchLeftGrid();
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
	
	<%-- 협력사 검색 Popup 열기 Function --%>	
	function searchCustmrPopup(){
		var pur_sale_type = "1"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		var onRowSelect = function(id, ind) {
// 			document.getElementById("txtEMP_NO").value  = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
// 			document.getElementById("txtEMP_NM").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
// 			document.getElementById("txtCORP_NO").value = this.cells(id, this.getColIndexById("CORP_NO")).getValue();
			$erp.dataAutoBind("table_data", {
				"EMP_NO" : this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue()
				,"EMP_NM" : this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue()
				,"CORP_NO" : this.cells(id, this.getColIndexById("CORP_NO")).getValue()
			});
			
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	//비밀번호 초기화
	function initPassword(){
		if(crud == "U"){
			$erp.confirmMessage({
				"alertMessage" : "비밀번호를 초기화 하시겠습니까?",
				"alertType" : "alert",
				"isAjax" : false,
				"alertCallbackFn" : function(){
					var result = $erp.dataSerialize("table_data"); //domId, 체크박스 리턴 타입("Q"|), isUseNullAble
					result["SITE_DIV_CD"] = "PS";
					
					$.ajax({
						url : "/common/employee/initPassword.do"
						,data : result
						,method : "POST"
						,dataType : "JSON"
						,success : function(data){
							totalLayout.progressOff();
							if(data.isError){
								$erp.ajaxErrorMessage(data);
							} else {			
								$erp.alertSuccessMesage();
							}
						}, error : function(jqXHR, textStatus, errorThrown){
							totalLayout.progressOff();
							$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
						}
					});
				}
			});
		}else{
			$erp.alertMessage({
				"alertMessage" : "선택된 사용자가 없습니다.",
				"alertType" : "alert",
				"isAjax" : false
			});
		}
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
	
</script>
</head>
<body>		

	<div id="div_left_layout" class="samyang_div" style="display:none">
		<div id="div_left_table" class="samyang_div" style="display:none">
			<table id="table_search" class="samyang_div">
				<colgroup>
					<col width="60px"/>
					<col width="80px"/>
					<col width="60px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th>협력사명</th>
					<td>
						<input type="text" id="txtSCH_EMP_NM" class="input_common" style="width:70px" onkeydown="$erp.onEnterKeyDown(event, searchLeftGrid, ['']);" value="">
					</td>
					<th>사용여부</th>
					<td><div id="cmbSCH_USE_YN"></div></td>
				</tr>
			</table>
		</div>
		<div id="div_left_ribbon" class="div_ribbon_full_size"></div>
		<div id="div_left_grid" class="div_grid_full_size"></div>
	</div>
	<div id="div_right_layout" class="samyang_div" style="display:none">
		<div id="div_right_table" class="samyang_div" style="display:none">
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
							<input type="text" id="txtID" class="input_common" maxlength="50" value="" data-isEssential="true">		
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>협력사명</th>
						<td>
							<input type="text" id="txtEMP_NM" name="EMP_NM" class="input_common input_readonly" maxlength="50" style="width: 300px" data-isEssential="true" readonly disabled>
							<input type="button" class="input_common_button" value="검색" onclick="searchCustmrPopup();">
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>협력사번호</th>
						<td>
							<input type="text" id="txtEMP_NO" name="EMP_NO" class="input_common input_readonly" value="" data-isEssential="true" readonly disabled>
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>사업자번호</th>
						<td>
							<input type="text" id="txtCORP_NO" class="input_common input_readonly" maxlength="100" style="width: 300px" value="" data-isEssential="true" data-type="businessNum" readonly disabled>
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>이메일</th>
						<td>
							<input type="text" id="txtEMAIL" class="input_common" maxlength="100" style="width: 300px" value="" data-isEssential="true" data-type="email">
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
					<tr>
						<th colspan="1">비밀번호 초기화</th>
						<td colspan="1">
							<input type="button" class="input_common_button" value="초기화" onclick="initPassword();">
							<span class="span_essential">*사업자등록 번호로 초기화 됩니다.[ - 미포함]</span>
						</td>
					</tr>
			</table>
		</div>
	</div>
	
</body>
</html>