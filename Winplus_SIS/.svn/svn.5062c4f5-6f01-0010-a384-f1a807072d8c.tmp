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
<script type="text/javascript" src="/resources/common/js/report.js?ver=42"></script>
<script type="text/javascript">
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2,3,4";
	LUI.exclude_orgn_type = "OT";
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openLabelPrintPopup");
	
	var check_bcd = '${param.BCD_LIST}';
	var erpPopupLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmbMRD;
	var MrdFile;
	var MrdFileName;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var param_BCD_LIST = [];
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("라벨출력");
		}
		
		if(check_bcd != ''){
			param_BCD_LIST = JSON.parse('${param.BCD_LIST}'); //["818941003123","3052910001254","9556592600025"];
		}
		
		initerpPopupLayout();
		initDhtmlXCombo();
		initErpRibbon();
		initErpGrid();
		
		$erp.asyncObjAllOnCreated(function(){
			var menu_nm = '${menuDto.menu_nm}';
			if(menu_nm == "라벨출력") {
				erpRibbon.hide("search_erpGrid");
			} else {
				erpRibbon.hide("search_pda_data");
				if('${param.ORGN_CD}' != ''){
					cmbORGN_DIV_CD.setComboValue('${param.ORGN_DIV_CD}');
					cmbORGN_CD.setComboValue('${param.ORGN_CD}');
					searchValidationCheck('${param.ORGN_DIV_CD}', '${param.ORGN_CD}');
				} else {
					searchValidationCheck(cmbORGN_DIV_CD.getSelectedValue(), cmbORGN_CD.getSelectedValue());
				}
			}
		});
	});
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>
	<%-- erpPopupLayout 초기화 Function --%>	
	function initerpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "설정영역", header:false}
				, {id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드영역", header:false}
			]		
		});
		erpPopupLayout.cells("a").attachObject("div_erp_contents_search");
		erpPopupLayout.cells("a").setHeight(95);
		erpPopupLayout.cells("b").attachObject("div_erp_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_grid");
		
		erpPopupLayout.setSeparatorSize(1, 0);
		
		<%-- erpPopupLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpGrid.setSizes();
		});
	}
	<%-- ■ erpPopupLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search"/>', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					,{id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add"/>', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
					, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print"/>', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : false}
					, {id : "search_pda_data", type : "button", text:'PDA내역불러오기', isbig : false, img : "menu/open.gif", imgdis : "menu/open_dis.gif", disable : false}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				searchValidationCheck(cmbORGN_DIV_CD.getSelectedValue(), cmbORGN_CD.getSelectedValue());
			}else if (itemId == "print_erpGrid"){
		    	openLabelReport();
		    }else if(itemId == "add_erpGrid"){
		    	openSearchGoodsGridPopup();
		    }else if(itemId == "search_pda_data"){
		    	openPdaLabelGridPopup();
		    } 
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			  {id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}              
			  , {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			  , {id : "ORGN_CD", label:["조직명"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true, commonCode : "ORGN_CD"}
			  , {id : "GOODS_NO", label:["상품코드"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			  , {id : "BCD_NM", label:["상품명"], type: "ro", width: "240", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "BCD_CD", label:["바코드"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			  , {id : "NUM_COPY", label:["매수"], type: "edn", width: "100", sort : "int", align : "right", isHidden : false, isEssential : false}
			  , {id : "PDA_FLAG", label:["PDA로온상품"], type: "ro", width: "80", sort : "str", align : "center", isHidden : true, isEssential : false}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
		});
		
		erpGridDataProcessor = $erp.initGrid(erpGrid, {"rowSize" : 100, "multiSelect" : true, "useAutoAddRowPaste" : true, "deleteDuplication" : false, "overrideDuplication" : false , "editableColumnIdListOfInsertedRows" : ["NUM_QTY"] , "notEditableColumnIdListOfInsertedRows" : ["ORGN_CD", "GOODS_NO", "BCD_NM", "BCD_CD"]});
		
		erpGrid.attachEvent("onCellChanged", function (rowId,columnIdx,newValue){ //숫자 외 문자막기
			if(erpGrid.getColIndexById("NUM_COPY") == columnIdx){
				var check_num = newValue * 1;
				if(check_num == 0){
					erpGrid.cells(rowId, erpGrid.getColIndexById("NUM_COPY")).setValue(1);
				}
				if(isNaN(check_num)){
					erpGrid.cells(rowId, erpGrid.getColIndexById("NUM_COPY")).setValue(1);
				}
			}
		});
	}
	
	function openLabelReport() {
		
		var label_design = cmbMRD.getSelectedValue();
		if(label_design == "" || label_design == null || label_design == undefined){
			$erp.alertMessage({
				"alertMessage" : "error.sis.label_design_no_selected"
				, "alertCode" : null
				, "alertType" : "alert"
			});
			return false;
		}
		
		
		var mrdFileName = label_design;
		var gridRowCount = erpGrid.getRowsNum();
		var selectedBcode = "";
		var copy_num = 1;
	  	var selectRowBcodeArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpGrid.getRowId(i);
			var check = erpGrid.cells(rId, erpGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				selectedBcode = erpGrid.cells(rId, erpGrid.getColIndexById("BCD_CD")).getValue();
				copy_num = Number(erpGrid.cells(rId, erpGrid.getColIndexById("NUM_COPY")).getValue());
				for(var j = 0 ; j < copy_num ; j++){
					selectRowBcodeArray.push(selectedBcode);
				}
			}
		}
		
		if(selectRowBcodeArray.length == 0) {
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}
		
		var resultBCode = "";
		for(var i = 0; i < selectRowBcodeArray.length; i++){
			if(i != 0) {
				resultBCode = resultBCode + "," + selectRowBcodeArray[i];
			} else {
				resultBCode = resultBCode + selectRowBcodeArray[i];
			}
		}
		
		var paramInfo = {
				"reportParam" : resultBCode
				, "mrdPath" : "mrd_upload_test"
				, "mrdFileName" : mrdFileName
				, "ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
				, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
		};
		
		var approvalURL = $CROWNIX_REPORT.openLablePrint("", paramInfo, "라벨출력", "");
		var popObj = window.open(approvalURL, "barcode_popup", "width=900,height=800");
		
		var frm = document.testform;
		frm.action = approvalURL;
		frm.target = "barcode_popup";
		frm.submit();
	}

	<%-- erpGrid 조회 Function --%>
	function searchValidationCheck(ORGN_DIV_CD, ORGN_CD){
		if('${menuDto.menu_nm}' == "라벨출력관리"){
			var rowCount = erpGrid.getRowCount();
			if(rowCount == 0){
				$erp.alertMessage({
					"alertMessage" : "상품추가 후 조회 가능합니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false
				});
			} else {
				searchErpGrid(ORGN_DIV_CD, ORGN_CD)
			}
		} else {
			searchErpGrid(ORGN_DIV_CD, ORGN_CD)
		}
		
	}
	
	function searchErpGrid(ORGN_DIV_CD, ORGN_CD) {
		$.ajax({
			url : "/sis/LabelPrint/getBCodeList.do"
			,method : "POST"
			,dataType : "JSON"
			,data : {
				"bcd_list" : param_BCD_LIST
				, "ORGN_DIV_CD" : ORGN_DIV_CD
				, "ORGN_CD" : ORGN_CD
			}
			,success : function(data){
				erpPopupLayout.progressOff();
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
						var gridRowCount = erpGrid.getRowsNum();
						for(var i = 0 ; i < gridRowCount ; i ++){
							erpGrid.cells(erpGrid.getRowId(i), erpGrid.getColIndexById("NUM_COPY")).setValue(1);
						}
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	
	<%--
	**************************************************
	* 기타 영역
	**************************************************
	--%>	
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbMRD = $erp.getDhtmlXComboCommonCode("cmbMRD", "MRD_FILE", "MRD_FILE" , 200 , "라벨디자인선택", false);
		
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
	         cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, null, false, LUI.LUI_orgn_cd);
	         cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
	            cmbORGN_CD.unSelectOption();
	            cmbORGN_CD.clearAll();
	            $erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), null, false, null);
	         }); 
	     });
	}
	
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- 디자인파일 업로드 관련 Function 시작 --%>
	function FileCheck() {
		MrdFile = event.target.files[0];
		MrdFileName = $("#search_file").val();
	}
	<%-- 디자인파일 업로드 관련 Function 끝 --%>	
	
	function uploadMrdFile() {
		var formData = new FormData();
		formData.append("MrdFile", MrdFile);
		formData.append("MrdFileName", MrdFileName);
		
		if(MrdFileName == "" || MrdFileName == null || MrdFileName == undefined || MrdFileName == "undefined") {
			alert("파일이 선택되지 않았습니다. 선택 후 다시 이용해주세요!");
		} else {
			$.ajax({
				url : "/sis/LabelPrint/uploadMrdFile.do"
				, method : "POST"
				, dataType : "JSON"
				, data : formData
				, processData: false
			    , contentType: false
				, success : function(data){
					erpPopupLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						var resultNum = data;
						if(resultNum == 0){
						} else {
							AddCmbMRDList();
							$('#search_file').val("");
						}
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
				
			});
		}
	}
	
	function AddCmbMRDList(){
		var fileValue = $('#search_file').val().split("\\");
		MrdFileName = fileValue[fileValue.length - 1];
		
		$.ajax({
			url : "/sis/LabelPrint/addMRDCommonCode.do"
			, method : "POST"
			, dataType : "JSON"
			, data : {
				"MrdFileName" : MrdFileName
			}
			, success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$("#MRDTD").empty();
					$("#MRDTD").append("<div id='cmbMRD'></div>");
					cmbMRD = $erp.getDhtmlXComboCommonCode("cmbMRD", "MRD_FILE", "MRD_FILE" , 200 , "라벨디자인선택", false);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
			
		});
	}
	
	function openSearchGoodsGridPopup(){
		var onClickAddData = function(erpGoodsGrid) {
			var check = erpGoodsGrid.getCheckedRows(erpGoodsGrid.getColIndexById("CHECK")); // 조회된 그리드내역 중 선택한 row 번호 문자열로 넘어옴 ex) 1,5,7,10
			
			if(check == ""){
				$erp.alertMessage({
					"alertMessage" : "선택된 상품이 없습니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false
				});
			}else{
				var checkList = check.split(',');
				var uid = "";
				for(var i = 0 ; i < checkList.length ; i ++) {
					uid = erpGrid.uid();
					erpGrid.addRow(uid);
					erpGrid.cells(uid, erpGrid.getColIndexById("BCD_CD")).setValue(erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("BCD_CD")).getValue());				
					erpGrid.cells(uid, erpGrid.getColIndexById("GOODS_NO")).setValue(erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("GOODS_NO")).getValue());				
					erpGrid.cells(uid, erpGrid.getColIndexById("BCD_NM")).setValue(erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("BCD_NM")).getValue());	
					erpGrid.cells(uid, erpGrid.getColIndexById("ORGN_CD")).setValue(erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("ORGN_CD")).getValue());	
					erpGrid.cells(uid, erpGrid.getColIndexById("NUM_COPY")).setValue(1);
					param_BCD_LIST.push(erpGoodsGrid.cells(checkList[i], erpGoodsGrid.getColIndexById("BCD_CD")).getValue());
				}
				$erp.closePopup2("openSearchGoodsGridPopup");
			}
		
	  	}
		$erp.openSearchGoodsPopup(null,onClickAddData, {"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue() , "ORGN_CD" : cmbORGN_CD.getSelectedValue(), "DISABLE" : true});
	}
	
	function openPdaLabelGridPopup(){
		var onClickApplyData = function(popupGrid){
			$erp.copyRowsGridToGrid(popupGrid, erpGrid, ["BCD_CD", "GOODS_NO", "BCD_NM", "ORGN_CD", "GOODS_QTY"], ["BCD_CD", "GOODS_NO", "BCD_NM", "ORGN_CD", "NUM_COPY"], "checked", "new", ["NUM_COPY"],[], null, {"PDA_FLAG" : "PDA"}, function(){
				$erp.closePopup2("openPdaLabelGridPopup");	
			}, false);
		};
		var params = {
						"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue() 
						, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
						, "DISABLE" : true
					};
		$erp.openPdaLabelGridPopup(params, onClickApplyData);
	}
</script>
</head>
<body>
	<form name="testform" action="" method="post"></form>		
	<div id="div_erp_contents_search" class="samyang_div" style="diplay:none;">
		<table id="table_search" class="table">
			<colgroup>
				<col width="100px">
				<col width="230px">
				<col width="80px">
				<col width="*">				
			</colgroup>
			<tr>
				<th style="text-align: right;">법인구분</th>
				<td>
					<div id="cmbORGN_DIV_CD"></div>
				</td>
				<th style="text-align: right;">조직명</th>
				<td>
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
			<tr>
				<th style="text-align: right;">디자인파일<br>등록</th>
				<td colspan="3">
					<input type="file" accept=".mrd" id="search_file" name="search_file" onchange="FileCheck();" style="width: 240px;">
					<input type="button" id="upload_file" name="upload_file" value="디자인 파일 업로드" class="input_common_button" onclick="uploadMrdFile();">
				</td>
			</tr>
			<tr>
				<th style="text-align: right;">라벨디자인</th>
				<td id="MRDTD" colspan="3">
					<div id="cmbMRD"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>