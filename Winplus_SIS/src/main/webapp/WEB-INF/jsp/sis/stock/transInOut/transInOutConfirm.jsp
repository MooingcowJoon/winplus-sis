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

	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');

	var erpLayout;
	var erpTopRibbon;
	var erpTopGrid;
	var erpTopGridColumns;
	var erpBotGrid;
	var erpBotGridColumns;
	
	var cmbORGN_CD;
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		
		initErpLayout();
		initErpTopRibbon();
		initErpTopGrid();
		initErpBotGrid();
		
		initDhtmlXCombo();
		document.getElementById("searchTransDate").value = today;
		
		$erp.asyncObjAllOnCreated(function(){
			
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false , fix_size:[true, true]}
				, {id: "b", text: "상단리본영역", header:false , fix_size:[true, true]}
				, {id: "c", text: "상단그리드영역", header:false , fix_size:[true, true]}
				, {id: "d", text: "하단그리드영역", header:false , fix_size:[true, true]}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight($erp.getTableHeight(1));
		erpLayout.cells("b").attachObject("div_erp_top_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_top_grid");
		erpLayout.cells("c").setHeight(300);
		erpLayout.cells("d").attachObject("div_erp_bot_grid");
	}	
	<%-- ■ erpLayout 관련 Function 끝 --%>

	<%-- ■ erpTopRibbon 관련 Function 시작 --%>
	function initErpTopRibbon() {
		erpTopRibbon = new dhtmlXRibbon({
			parent : "div_erp_top_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpTopGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "save_erpTopGrid", type : "button", text:'이동확정', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : false}
					, {id : "delete_erpTopGrid", type : "button", text:'확정취소', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
				]}
			]
		});	
		
		erpTopRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpTopGrid"){
				searchErpTopGrid();
			} else if (itemId == "save_erpTopGrid"){
				confirmTransData();
			} else if (itemId == "delete_erpTopGrid"){
				confirmCancelTransData();
			}
		});
	}
	
	//재고이동 확정
	function confirmTransData(){
		var topGridCheckedRowIds = erpTopGrid.getCheckedRows(erpTopGrid.getColIndexById("CHECK"));
		if(topGridCheckedRowIds == ""){
			$erp.alertMessage({
				"alertMessage" : "error.common.noCheckedData"
				, "alertCode" : null
				, "alertType" : "notice"
			});
		}else{
			var topGridCheckedRowArray = topGridCheckedRowIds.split(",");
			
			if(topGridCheckedRowArray == "NoDataPrintRow" || topGridCheckedRowArray.length == 0){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
				return;
			}else{
				var topGridCheckKeyArray = [];
				var orgnCd = cmbORGN_CD.getSelectedValue();
				
				var validTF = true;
				var validMsg = "";
				
				for(var i=0; i<topGridCheckedRowArray.length; i++){
					topGridCheckKeyArray[i] = erpTopGrid.cells(topGridCheckedRowArray[i], erpTopGrid.getColIndexById("UNI_KEY")).getValue();
					if("2" != erpTopGrid.cells(topGridCheckedRowArray[i], erpTopGrid.getColIndexById("TRANS_STATE")).getValue()){
						validTF = false;
						validMsg = "이동요청 상태의 데이터만 확정 처리가 가능합니다.";
						break;
					}else if(orgnCd != erpTopGrid.cells(topGridCheckedRowArray[i], erpTopGrid.getColIndexById("IN_ORGN_CD")).getValue()){
						validTF = false;
						validMsg = "이동요청을 받은 직영점에서 확정 처리가 가능합니다.";
						break;
					}
				}
				
				if(!validTF){
					$erp.alertMessage({
						"alertMessage" : validMsg,
						"alertType" : "alert",
						"isAjax" : false
					});
					return false;
				}else{
					$erp.confirmMessage({
						"alertMessage" : "체크된 자료를 이동확정 하시겠습니까?",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							erpLayout.progressOn();
							$.ajax({
								url : "/sis/stock/transInOut/confirmTransData.do" //재고이동 확정
								,data : {
									"paramList" : topGridCheckKeyArray
								}
								,method : "POST"
								,dataType : "JSON"
								,success : function(data) {
									erpLayout.progressOff();
									if(data.isError){
										$erp.ajaxErrorMessage(data);
									}else {
										if(data.resultMsg == "SUCCESS"){
											$erp.clearDhtmlXGrid(erpTopGrid);
											$erp.clearDhtmlXGrid(erpBotGrid);
											$erp.alertMessage({
												"alertMessage" : "이동요청 확정 처리 되었습니다.",
												"alertType" : "alert",
												"isAjax" : false,
												"alertCallbackFn" : function(){
													searchErpTopGrid();
												}
											});
										}else{
											$erp.alertMessage({
												"alertMessage" : "이동요청 확정 처리가 실패 하였습니다.",
												"alertType" : "alert",
												"isAjax" : false
											});
										}
									}
								}, error : function(jqXHR, textStatus, errorThrown){
									erpLayout.progressOff();
									$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
								}
							});
						}
					});
				}
			}
		}
	}
	
	//재고이동 확정취소
	function confirmCancelTransData(){
		var topGridCheckedRowIds = erpTopGrid.getCheckedRows(erpTopGrid.getColIndexById("CHECK"));
		if(topGridCheckedRowIds == ""){
			$erp.alertMessage({
				"alertMessage" : "error.common.noCheckedData"
				, "alertCode" : null
				, "alertType" : "notice"
			});
		}else{
			var topGridCheckedRowArray = topGridCheckedRowIds.split(",");
			
			if(topGridCheckedRowArray == "NoDataPrintRow" || topGridCheckedRowArray.length == 0){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
				return;
			}else{
				var topGridCheckKeyArray = [];
				var orgnCd = cmbORGN_CD.getSelectedValue();
				
				var validTF = true;
				var validMsg = "";
				
				for(var i=0; i<topGridCheckedRowArray.length; i++){
					topGridCheckKeyArray[i] = erpTopGrid.cells(topGridCheckedRowArray[i], erpTopGrid.getColIndexById("UNI_KEY")).getValue();
					if("3" != erpTopGrid.cells(topGridCheckedRowArray[i], erpTopGrid.getColIndexById("TRANS_STATE")).getValue()){
						validTF = false;
						validMsg = "이동확정 상태의 데이터만 확정취소가 가능합니다.";
						break;
					}else if(orgnCd != erpTopGrid.cells(topGridCheckedRowArray[i], erpTopGrid.getColIndexById("IN_ORGN_CD")).getValue()){
						validTF = false;
						validMsg = "이동요청을 받은 직영점에서 확정취소가 가능합니다.";
						break;
					}
				}
				
				if(!validTF){
					$erp.alertMessage({
						"alertMessage" : validMsg,
						"alertType" : "alert",
						"isAjax" : false
					});
					return false;
				}else{
					$erp.confirmMessage({
						"alertMessage" : "체크된 자료를 이동확정취소 하시겠습니까?",
						"alertType" : "alert",
						"isAjax" : false,
						"alertCallbackFn" : function(){
							erpLayout.progressOn();
							$.ajax({
								url : "/sis/stock/transInOut/confirmCancelTransData.do" //재고이동 확정취소
								,data : {
									"paramList" : topGridCheckKeyArray
								}
								,method : "POST"
								,dataType : "JSON"
								,success : function(data) {
									erpLayout.progressOff();
									if(data.isError){
										$erp.ajaxErrorMessage(data);
									}else {
										if(data.resultMsg == "SUCCESS"){
											$erp.clearDhtmlXGrid(erpTopGrid);
											$erp.clearDhtmlXGrid(erpBotGrid);
											$erp.alertMessage({
												"alertMessage" : "이동확정취소가 처리 되었습니다.",
												"alertType" : "alert",
												"isAjax" : false,
												"alertCallbackFn" : function(){
													searchErpTopGrid();
												}
											});
										}else{
											$erp.alertMessage({
												"alertMessage" : "이동확정취소가 실패 하였습니다.",
												"alertType" : "alert",
												"isAjax" : false
											});
										}
									}
								}, error : function(jqXHR, textStatus, errorThrown){
									erpLayout.progressOff();
									$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
								}
							});
						}
					});
				}
			}
		}
	}
	<%-- ■ erpTopRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpTopGrid 관련 Function 시작 --%>	
	function initErpTopGrid(){
		erpTopGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			,{id : "TRANS_DATE", label:["이동일자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "TRANS_YYYYMMDD", label:["이동일자", "#rspan"], type: "ro", width: "75", sort : "str", align : "center", isHidden : false, isEssential : true}
			,{id : "TRANS_NO", label:["이동번호", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false }
			,{id : "OUT_ORGN_CD", label : ["출고직영점", "#rspan"], type : "combo", width : "75", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			,{id : "IN_ORGN_CD", label : ["입고직영점", "#rspan"], type : "combo", width : "75", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["ORGN_CD" , "MK"]}
			,{id : "TOT_GOODS_NM", label:["품목명", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false }
			,{id : "TOT_QTY", label:["수량", "#rspan"], type: "ron", width: "85", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "TRANS_STATE", label : ["처리상태", "#rspan"], type : "combo", width : "135", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["TRANS_STATE"]}
			,{id : "RESP_USER", label:["담당자", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : false, isEssential : false }
			,{id : "UNI_KEY", label:["UNI_KEY", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
		];
		
		erpTopGrid = new dhtmlXGridObject({
			parent: "div_erp_top_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpTopGridColumns
		});
		
		$erp.initGridCustomCell(erpTopGrid);
		$erp.initGridComboCell(erpTopGrid);
		$erp.attachDhtmlXGridFooterPaging(erpTopGrid, 5);
		$erp.attachDhtmlXGridFooterRowCount(erpTopGrid, '<spring:message code="grid.allRowCount" />');
		
		erpTopGrid.attachEvent("onRowDblClicked",function(rId,cInd){
			var TRANS_DATE = erpTopGrid.cells(rId, erpTopGrid.getColIndexById("TRANS_DATE")).getValue();
			var TRANS_NO = erpTopGrid.cells(rId, erpTopGrid.getColIndexById("TRANS_NO")).getValue();
			searchErpBotGrid(TRANS_DATE, TRANS_NO);
		});
	}
	
	function searchErpTopGrid(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var transDate = document.getElementById("searchTransDate").value.replace(/\-/g,'');
		var orgnCd = cmbORGN_CD.getSelectedValue();
		
		if(transDate == null || transDate == ""){
			isValidated = false;
			alertMessage = "이동일자를 지정해야 합니다.";
			alertCode = "1";
		} else if(orgnCd == null || orgnCd == ""){
			isValidated = false;
			alertMessage = "선택된 직영점이 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : alertType
				,"isAjax" : false
				,"alertCallbackFn" : function(){
					if(alertCode == "1"){
						document.getElementById("searchTransDate").focus();
					}
				}
			});
		}else{
			erpLayout.progressOn();
			$.ajax({
				url: "/sis/stock/transInOut/getStockTransReqList.do" //재고이동 요청 자료 조회
				, data : {
					 "TRANS_DATE" : transDate
					 , "ORGN_CD" : orgnCd
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpTopGrid);
						$erp.clearDhtmlXGrid(erpBotGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpTopGrid
								,'<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpTopGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpTopGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	<%-- ■ erpTopGrid 관련 Function 끝 --%>
	
	<%-- ■ erpBotGrid 관련 Function 시작 --%>	
	function initErpBotGrid(){
		erpBotGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "TRANS_DATE", label:["이동일자", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : true, isDataColumn : true}
			,{id : "TRANS_NO", label:["이동번호", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : true, isDataColumn : true}
			,{id : "GOODS_BCD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true, isDataColumn : true}
			,{id : "BCD_NM", label:["품목명", "#rspan"], type: "ro", width: "580", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "TRANS_QTY", label:["수량", "#rspan"], type: "ron", width: "85", sort : "int", align : "right", isHidden : false, isEssential : true, isDataColumn : true, numberFormat : "0,000", isSelectAll: true, maxLength: 7}
			,{id : "TRANS_STATE", label:["처리상태", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : true}
		];
		
		erpBotGrid = new dhtmlXGridObject({
			parent: "div_erp_bot_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpBotGridColumns
		});
		
		$erp.initGridCustomCell(erpBotGrid);
		$erp.initGridComboCell(erpBotGrid);
		$erp.attachDhtmlXGridFooterPaging(erpBotGrid, 20);
		$erp.attachDhtmlXGridFooterRowCount(erpBotGrid, '<spring:message code="grid.allRowCount" />');
		$erp.initGridDataColumns(erpBotGrid);
	}
	
	function searchErpBotGrid(TRANS_DATE,TRANS_NO){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		
		if(TRANS_DATE == null || TRANS_DATE == ""){
			isValidated = false;
			alertMessage = "선택된 이동일자가 없습니다.";
		} else if(TRANS_NO == null || TRANS_NO == ""){
			isValidated = false;
			alertMessage = "선택된 이동번호가 없습니다.";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertType" : alertType
				, "isAjax" : false
			});
		}else{
			erpLayout.progressOn();
			$.ajax({
				url: "/sis/stock/transInOut/getStockTransDetlList.do" //재고이동 디테일 자료 조회
				, data : {
					 "TRANS_DATE" : TRANS_DATE
					 , "TRANS_NO" : TRANS_NO
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpBotGrid);
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpBotGrid
								,'<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpBotGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpBotGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	<%-- ■ erpBotGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	function initDhtmlXCombo(){
		var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",");
		var searchable = 1;
		console.log(search_cd_Arr);
		for(var i in search_cd_Arr){
			if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
				searchable = 2;
			}
		}
		
		 if(searchable == 2 ){
			cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK",null,null,null,"MK"], 100, null, false, LUI.LUI_orgn_cd);
		} else {
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : LUI.LUI_orgn_div_cd}]), 100, null, false, LUI.LUI_orgn_cd);
		}
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ 기타 Function 시작 --%>
	function enterSearchToGrid(kcode){
		if(kcode == 13){
			document.getElementById("searchTransDate").blur();
			searchErpTopGrid();
		}
	}
	<%-- ■ 기타 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_table" class="samyang_div" style="display:none">
		<table id = "tb_search_01" class = "table">
			<colgroup>
				<col width="80px"/>
				<col width="120px"/>
				<col width="80px"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<th>이동일자</th>
				<td>
					<input type="text" id="searchTransDate" name="searchTransDate" class="input_common input_calendar" style="margin-left:10px;" onkeydown="enterSearchToGrid(event.keyCode);">
				</td>
				<th>조직명</th>
				<td>
					<div id="cmbORGN_CD" style="margin-left:10px;"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_top_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_top_grid" class="div_grid_full_size" style="display:none"></div>
	<div id="div_erp_bot_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>