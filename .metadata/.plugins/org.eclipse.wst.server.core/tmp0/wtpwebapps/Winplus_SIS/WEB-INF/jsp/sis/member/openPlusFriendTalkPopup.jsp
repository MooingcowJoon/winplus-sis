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

	var erpPopupWindowsCell = parent.erpPopupWindows.window("openPlusFriendTalkPopup");
	var erpLayout;
	var erpMainLayout;
	var erpSubLayout;
	var erpRibbon;
	var erpSendRibbon;
	var erpGrid;
	var orgn_cdList="";
	var phon_noList="";
	var mem_nmList="";
	var orgn_cd ="";
	var mem_no ="";
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("플러스친구톡보내기");
		}
		
		initErpLayout();
		
		initErpMainLayout();
		initErpSubLayout();
		
		initErpRibbon();
		initErpGrid();
		
		$erp.asyncObjAllOnCreated(function(){
			sendPlusFriendTalk();
		});
		
		$('#txtSEND_TALK').keyup(function (e){
			var content = $(this).val();
			$('#counter').html("("+content.length+" / 최대 2000자)");	//글자수 실시간 카운팅

			if (content.length > 2000){
				alert("최대 2000자까지 입력 가능합니다.");
				$(this).val(content.substring(0, 2000));
				$('#counter').html("(2000 / 최대 2000자)");
				}
			});
		
		$("#txtCALLER_NO").keyup(function(e) { 
			if (!(e.keyCode >=37 && e.keyCode<=40)) {
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
				{id: "a", text: "플러스톡친구톡내용", header:false, width:350}
				, {id: "b", text: "회원검색", header:false}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_main_layout");
		erpLayout.cells("b").attachObject("div_erp_sub_layout");
		erpLayout.cells("b").setHeight(300);
		
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
		
	<%-- ■ erpMainLayout 관련 Function 시작 --%>
	<%-- erpMainLayout 초기화 Function --%>
	function initErpMainLayout(){
		erpMainLayout = new dhtmlXLayoutObject({
			parent: "div_erp_main_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "조회조건", header:false , fix_size:[true, true]}
			]
		});
		erpMainLayout.cells("a").attachObject("div_erp_contents");
		erpMainLayout.cells("a").setHeight(300);
	}	
	<%-- ■ erpMainLayout 관련 Function 끝 --%>
		
	<%-- ■ erpSubLayout 관련 Function 시작 --%>
	<%-- erpSubLayout 초기화 Function --%>
	function initErpSubLayout(){
		erpSubLayout = new dhtmlXLayoutObject({
			parent: "div_erp_sub_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				 {id: "a", text: "", header:false, fix_size : [false, true]}
				, {id: "b", text: "", header:false}
				, {id: "c", text: "", header:false}
			]
		});
		erpSubLayout.cells("a").attachObject("div_erp_ribbon");
		erpSubLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpSubLayout.cells("b").attachObject("div_erp_grid");
		erpSubLayout.cells("b").setHeight(500);
		erpSubLayout.cells("c").attachObject("div_erp_send");
		erpSubLayout.cells("c").setHeight(35);
		
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
					 {id : "search_erpGrid", type : "button", text:'회원검색', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 					, {id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
					, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid"){
				openSearchMemberPopup();
			} else if (itemId == "add_erpGrid"){
				addErpGrid();
			} else if (itemId == "delete_erpGrid"){
				deleteErpGrid();
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["순번", "#rspan"], type: "cntr", width: "35", sort : "int", align : "center", isHidden : false, isEssential : false}  
			, {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "35", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "ORGN_CD", label : ["직영점", "#rspan"], type : "combo", width : "75", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			, {id : "UNIQUE_MEM_NO", label:["회원코드(히든)", "#rspan"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true, isEssential : true}
			, {id : "MEM_NO", label:["회원코드", "#rspan"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true, isEssential : true}
			, {id : "MEM_NM", label:["회원명", "#rspan"], type: "ro", width: "95", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "CORP_NM", label:["상호명", "#rspan" ], type: "ro", width: "110", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true}
			, {id : "MEM_ABC", label:["회원분류(ABC)", "#rspan"], type: "combo", width: "90", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : "MEM_ABC"}
			, {id : "HID_PHON_NO", label:["전화번호(히든)", "#rspan"], type: "ro", width: "110", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "PHON_NO", label:["전화번호", "#rspan"], type: "edn", width: "110", sort : "sort", align : "center", isHidden : false, isEssential : true, isDataColumn : true, isSelectAll : true, maxLength : 11}
			];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		
		erpGridDataProcessor = $erp.initGrid(erpGrid, {useAutoAddRowPaste : true, standardColumnId : "PHON_NO", setDuplicationAlertMessageFunction: function(dupName,dupValue){return dupName + "를 입력해주세요.";} ,deleteDuplication : true, overrideDuplication : false, editableColumnIdListOfInsertedRows : ["PHON_NO"], notEditableColumnIdListOfInsertedRows : ["ORGN_CD", "MEM_NM", "CORP_NM", "MEM_ABC"]});
		
		erpGrid.attachEvent("onEndPaste", function(result){
			loadGoods(result);
		});
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- getMemberInformation 회원정보 가져오기 Function --%>
	function loadGoods(result){
		var loadGoodsList = [];
		for(var index in result.newAddRowDataList){
			loadGoodsList.push(result.newAddRowDataList[index]["PHON_NO"]);
		}
		var url = "/common/popup/getMemberInformation.do";
		var send_data = {"loadGoodsList" : loadGoodsList};
		var if_success = function(data){
			var gridDataList = data.gridDataList;
				for(var index in gridDataList){
					erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["PHON_NO"]][1], erpGrid.getColIndexById("ORGN_CD")).setValue(gridDataList[index]["ORGN_CD"]);
					erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["PHON_NO"]][1], erpGrid.getColIndexById("MEM_NM")).setValue(gridDataList[index]["MEM_NM"]);
					erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["PHON_NO"]][1], erpGrid.getColIndexById("CORP_NM")).setValue(gridDataList[index]["CORP_NM"]);
					erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["PHON_NO"]][1], erpGrid.getColIndexById("MEM_ABC")).setValue(gridDataList[index]["MEM_ABC"]);
					erpGrid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["PHON_NO"]][1], erpGrid.getColIndexById("PHON_NO")).setValue(gridDataList[index]["PHON_NO"]);
					result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["PHON_NO"]].push("로드완료");
				}
			var notExistList = [];
			var value;
			var state;
			var dp = erpGrid.getDataProcessor();
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["PHON_NO"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			$erp.deleteGridRows(erpGrid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>[무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			$erp.setDhtmlXGridFooterRowCount(erpGrid);	// 현재 행수 계산
		}
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpSubLayout);
	}
	
	<%-- openSearchMemberPopup 관련Function --%>
	function openSearchMemberPopup(){
		var onClickAddData = function(erpMemberGrid) {
			var isValidated = true;
			var alertMessage = "";
			var alertCode = "";
			var alertType = "error";
			
			if(!isValidated){
				$erp.alertMessage({
					"alertMessage" : alertMessage
					, "alertCode" : alertCode
					, "alertType" : alertType
				});
			}else{
				$erp.copyRowsGridToGrid(erpMemberGrid, erpGrid, ["PHON_NO", "MEM_NO", "ORGN_CD", "MEM_NM", "CORP_NM", "MEM_ABC"], ["PHON_NO", "MEM_NO", "ORGN_CD", "MEM_NM", "CORP_NM", "MEM_ABC"], "checked", "add", [], [], {}, {},function(result){
					$erp.closePopup2("openSearchMemberPopup");
				});
			}
		}
			
		var gridRowCount = erpGrid.getRowsNum();
		if(gridRowCount < 100){
			$erp.openSearchMemberPopup(onClickAddData);
		}
		else{
			$erp.alertMessage({
				"alertMessage" : "최대 100명까지만 추가가능합니다."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
		}
	}
	
	<%-- erpGrid 추가 Function --%>
	<%-- addErpGrid 추가 Function --%>
	function addErpGrid(){
		var gridRowCount = erpGrid.getRowsNum();
		if(gridRowCount < 100){
			var uid = erpGrid.uid();
			erpGrid.addRow(uid);
			erpGrid.selectRow(erpGrid.getRowIndex(uid));
		}else{
			$erp.alertMessage({
				"alertMessage" : "최대 100명까지만 추가가능합니다."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
		}
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}	
	
	<%-- deleteErpGrid 삭제 Function --%>
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
	
	<%-- 부모창에서 받아온 paramMap 내용 조회 Function --%>
	function sendPlusFriendTalk(){
		$erp.copyRowsGridToGrid(parentGrid, erpGrid, ["UNIQUE_MEM_NO","MEM_NO","MEM_NM","CORP_NM","MEM_ABC","PHON_NO", "ORGN_CD"], ["UNIQUE_MEM_NO","MEM_NO","MEM_NM","CORP_NM","MEM_ABC","PHON_NO", "ORGN_CD"], "checked", "new", [], [], {}, {});
	}
	
	<%-- 발송 Function --%>
	function saveSendTalk(){
		var check_list="";
		var gridRowCount = erpGrid.getRowsNum();
		for(var i = 0; i < gridRowCount ; i++){
			var rId = erpGrid.getRowId(i);
			check_list += erpGrid.cells(rId, erpGrid.getColIndexById("PHON_NO")).getValue();
			check_list = check_list.replace(/\-/g,'');
			if(i  < gridRowCount -1){
				check_list += ",";
			}
		}
		
		var phon_check = check_list.indexOf(",,");
		var phon_check2 = check_list[0];
		var phon_check3 = check_list[check_list.length -1];
		
		if($("#txtSEND_TALK").val() =="" ){
			$erp.alertMessage({
				"alertMessage" : "메시지를 입력해주세요."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
		} else if($("#txtCALLER_NO").val() =="" ){
			$erp.alertMessage({
				"alertMessage" : "발신자 번호를 입력해주세요."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
		} else if(phon_check != "-1" || phon_check2 =="," || phon_check3 == ","){
			$erp.alertMessage({
				"alertMessage" : "전화번호를 입력해주세요."
				, "alertCode" : null
				, "alertType" : "alert"
				, "isAjax" : false
			});
		} else{	
				$erp.confirmMessage({
				"alertMessage" : "<span style='color:red; font-weight:bold;'>회원</span> 혹은 <span style='color:red; font-weight:bold;'>비회원 </span>모두에게 발송됩니다.<br>진행하시겠습니까?",
				"alertType" : "alert",
				"isAjax" : false,
				"alertCallbackFn" : function confirmAgain(){
				
				var check_list="";
				var gridRowCount = erpGrid.getRowsNum();
				for(var i = 0; i < gridRowCount ; i++){
					var rId = erpGrid.getRowId(i);
					check_list += erpGrid.cells(rId, erpGrid.getColIndexById("PHON_NO")).getValue();
					check_list = check_list.replace(/\-/g,'');
					if(i < gridRowCount -1){
						check_list += ",";
					}
				}
				
				var str = $('#txtCALLER_NO').val();
				var STR = str.replace(/\-/g,''); 
				
				var obj = {};
				obj["SEND_NUM"] = STR;
				obj["MSG"] = $('#txtSEND_TALK').val();
				obj["MSG_TIT"] = $('#txtTITLE_NM').val();
				obj["PHON_NO"] = check_list;
				
				var gridRowCount = erpGrid.getRowsNum();
				if(gridRowCount <= 100){
					var url = "/common/popup/saveSendTalk.do";
					var send_data = obj;
					var if_success = function(data){
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else{
							$erp.alertMessage({
									"alertMessage" : "발송되었습니다."
									, "alertCode" : null
									, "alertType" : "alert"
									, "isAjax" : false
							});
						}
					}
					var if_error = function(){}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);
				}else{
					$erp.alertMessage({
						"alertMessage" : "최대 100명까지만 발송가능합니다."
						, "alertCode" : null
						, "alertType" : "alert"
						, "isAjax" : false
					});
				}
				
				}
			});
		}
	}
</script>
</head>
<body>
	<div id="div_erp_main_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_contents" class="samyang_div" style="display:none;">
			<table id="tb_erp_data" class="table_search" style="margin-top:10px;">
				<colgroup>
					<col width="60px;">
					<col width="*px;">
				</colgroup>
				<tr>
					<th>제목 :</th>
					<td>
						<input type="text" id="txtTITLE_NM" name="txtTITLE_NM" class="input_common" value="식자재왕" maxlength="100" style="margin:10px; width: 245px;"/>
					</td>	
				</tr>
			</table>
			<table id="tb_erp_data" class="table_search">
				<colgroup>
					<col width="100px;">
					<col width="*px;">
				</colgroup>
				<tr>
					<th style = "font-size: 13px;">보내는 내용 :</th>
				</tr>
			</table>
			<table id="tb_erp_data1" class="table_search">
				<colgroup>
					<col width="340px;">
					<col width="*px;">
				</colgroup>
				<tr>
					<th>
						<textarea id="txtSEND_TALK" name="txtSEND_TALK" class="input_common" style="margin:10px; width:300px; height:380px;"></textarea>
					</th>
				</tr>
				<tr>
					<th style="color:#aaa; font-size: 11px;" id="counter">(0 / 최대 2000자)</th>
				</tr>
			</table>
			<table id="tb_erp_data2" class="table_search">
				<colgroup>
					<col width="120px;">
					<col width="*px;">
				</colgroup>
				<tr>
					<th>발신자 번호입력 :</th>
					<td>
						<input type="text" id="txtCALLER_NO" name="txtCALLER_NO" class="input_phone input_essential" value="031-544-9693" maxlength="20" style="margin:10px; width: 185px;"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="div_erp_sub_layout" class="samyang_div" style="display:none">
		<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_send" class="samyang_div" style="display:none">
			<table id="tb_erp_data3" class="table_search">
				<colgroup>
					<col width="370px">
					<col width="*px">
				</colgroup>
				<tr>
					<th></th>
					<td>
						<input type = "button" id="send_data" class="input_common_button" onclick="saveSendTalk();"  value="발송" style="width: 80px;"/>
						<input type="button" id="" class="input_common_button" value="닫기" onClick="thisOnComplete();" style="width:80px;"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>