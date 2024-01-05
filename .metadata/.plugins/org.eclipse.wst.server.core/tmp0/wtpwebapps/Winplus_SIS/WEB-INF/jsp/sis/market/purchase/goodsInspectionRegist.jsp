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
	LUI.exclude_auth_cd = "ALL,1,2,3,4";
	LUI.exclude_orgn_type = "OT";
	var AUTHOR_CD = "${screenDto.author_cd}";

	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpFrontGrid;
	var erpFrontGridColumns;
	var erpBackGrid;
	var erpBackGridColumns;
	
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		
		initDhtmlXCombo();
		document.getElementById("div_erp_front_grid").style.display = "block";
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false , fix_size:[true, true]}
				, {id: "b", text: "리본영역", header:false , fix_size:[true, true]}
				, {id: "c", text: "그리드영역", header:false , fix_size:[true, true]}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight($erp.getTableHeight(2));
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
	}	
	<%-- ■ erpLayout 관련 Function 끝 --%>

	<%-- ■ erpRibbon 관련 Function 시작 --%>
	function initErpRibbon() {
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpFrontGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					,{id : "add_erpFrontGrid", type : "button", text:'거래명세서추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					,{id : "delete_erpFrontGrid", type : "button", text:'거래명세서삭제', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
					,{id : "excel_erpFrontGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					,{id : "search_erpBackGrid", type : "button", text:'입고예정수량조회', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpFrontGrid"){
				searchErpFrontGrid();
			} else if (itemId == "add_erpFrontGrid"){
				openAddInspData();
			} else if (itemId == "delete_erpFrontGrid"){
				deleteErpFrontGrid();
			} else if (itemId == "excel_erpFrontGrid"){
				var selected_grid;
				var fileName;
				$("#div_erp_grid").children().each(function(index, obj){
					var display = obj.style.display;
					if(display == "block"){
						var id = obj.id;
						var grid_ID = obj.getAttribute("id");
						if(grid_ID == "div_erp_front_grid"){
							selected_grid = erpFrontGrid;
							fileName = "입고검수내역"
						} else if(grid_ID == "div_erp_back_grid"){
							selected_grid = erpBackGrid;
							fileName = "입고예정수량조회내역"
						}
						$erp.exportDhtmlXGridExcel({
							"grid" : selected_grid
							, "fileName" : fileName
							, "isForm" : false
						});
					}
				});
			} else if (itemId == "search_erpBackGrid"){
				searchErpBackGrid();
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	function initErpGrid(){
		
		erpGrid = {};
		
		erpFrontGridColumns = [
			{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			//{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "PUR_TYPE", label : ["구분", "#rspan"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["SLIP_TYPE"]}
			,{id : "CUSTMR_NM", label:["협력사명", "#rspan"], type: "ro", width: "220", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "PUR_DATE", label:["입고일자", "#rspan"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "PUR_YYYYMMDD", label:["입고일자", "#rspan"], type: "ro", width: "75", sort : "str", align : "center", isHidden : false, isEssential : true}
			,{id : "PUR_SLIP_CD", label:["입고번호", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false }
			,{id : "PAY_SUM_AMT", label:["금액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			,{id : "MEMO", label:["메모", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false }
			,{id : "MDATE_YYYYMMDD", label:["수정일시", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false }
			,{id : "PUR_SLIP_CD", label:["PUR_SLIP_CD", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : true, isEssential : true}
			,{id : "CONF_TYPE", label:["확정여부", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : false, isEssential : false}
			,{id : "SEND_TYPE", label:["ERP전송", "#rspan"], type: "ro", width: "85", sort : "str", align : "center", isHidden : false, isEssential : false}
		];
		
		erpFrontGrid = new dhtmlXGridObject({
			parent: "div_erp_front_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpFrontGridColumns
		});
		
		$erp.initGridCustomCell(erpFrontGrid);
		$erp.initGridComboCell(erpFrontGrid);
		$erp.attachDhtmlXGridFooterPaging(erpFrontGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpFrontGrid, '<spring:message code="grid.allRowCount" />');
		
		erpFrontGrid.attachEvent("onRowDblClicked",function(rId,cInd){
			var purSlipCd = erpFrontGrid.cells(rId,erpFrontGrid.getColIndexById("PUR_SLIP_CD")).getValue();
			openAddInspData(purSlipCd);
		});
		
		erpGrid["div_erp_front_grid"] = erpFrontGrid;
		
		erpBackGridColumns = [
			//{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "BCD_NM", label:["품목명", "#rspan"], type: "ro", width: "370", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "PO_TOT_ORD_QTY", label:["입고예정수량", "#rspan"], type: "ron", width: "115", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "PM_TOT_PUR_QTY", label:["입고수량", "#rspan"], type: "ron", width: "115", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "D_TYPE", label:["데이터타입", "#rspan"], type: "ro", width: "88", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "D_TYPE_NM", label:["비고", "#rspan"], type: "ro", width: "88", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpBackGrid = new dhtmlXGridObject({
			parent: "div_erp_back_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpBackGridColumns
		});
		
		$erp.initGridCustomCell(erpBackGrid);
		$erp.initGridComboCell(erpBackGrid);
		$erp.attachDhtmlXGridFooterPaging(erpBackGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpBackGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGrid["div_erp_back_grid"] = erpBackGrid;
	}
	
	function searchErpFrontGrid(){
		document.getElementById("div_erp_front_grid").style.display = "block";
		document.getElementById("div_erp_back_grid").style.display = "none";
		
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var inspDate = document.getElementById("searchInspDate").value.replace(/\-/g,'');
		var orgnCd = cmbORGN_CD.getSelectedValue();
		
		if(inspDate == null || inspDate == ""){
			isValidated = false;
			alertMessage = "입고일자를 지정해야 합니다.";
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
						document.getElementById("searchInspDate").focus();
					}
				}
			});
		}else{
			$.ajax({
				url: "/sis/market/purchase/getGoodsInspectionRegistHeaderList.do" //입고내역 자료 조회
				, data : {
					 "INSP_DATE" : inspDate
					 , "ORGN_CD" : orgnCd
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOn();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpFrontGrid);
						var gridDataList = data.dataMap;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpFrontGrid
								,'<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpFrontGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpFrontGrid);
					erpLayout.progressOff();
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	function deleteErpFrontGrid(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var inspDate = document.getElementById("searchInspDate").value.replace(/\-/g,'');
		var orgnCd = cmbORGN_CD.getSelectedValue();
		
		if(inspDate == null || inspDate == ""){
			isValidated = false;
			alertMessage = "입고일자를 지정해야 합니다.";
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
						document.getElementById("searchInspDate").focus();
					}
				}
			});
		}else{
			var frontGridCheckedRowIds = erpFrontGrid.getCheckedRows(erpFrontGrid.getColIndexById("CHECK"));
			if(frontGridCheckedRowIds == ""){
				$erp.alertMessage({
					"alertMessage" : "error.common.noCheckedData"
					, "alertCode" : null
					, "alertType" : "notice"
				});
			}else{
				var frontGridCheckedRowArray = frontGridCheckedRowIds.split(",");
				
				if(frontGridCheckedRowArray == "NoDataPrintRow" || frontGridCheckedRowArray.length == 0){
					$erp.alertMessage({
						"alertMessage" : "error.common.noCheckedData"
						, "alertCode" : null
						, "alertType" : "notice"
					});
					return;
				}else{
					var frontGridUnikeys = "";
					
					var validTF = true;
					
					for(var i=0; i<frontGridCheckedRowArray.length; i++){
						if(i != frontGridCheckedRowArray.length-1){
							frontGridUnikeys += erpFrontGrid.cells(frontGridCheckedRowArray[i], erpFrontGrid.getColIndexById("PUR_SLIP_CD")).getValue() + ",";
						} else {
							frontGridUnikeys += erpFrontGrid.cells(frontGridCheckedRowArray[i], erpFrontGrid.getColIndexById("PUR_SLIP_CD")).getValue();
						}
						
						if("Y" == erpFrontGrid.cells(frontGridCheckedRowArray[i], erpFrontGrid.getColIndexById("CONF_TYPE")).getValue()){
							validTF = false;
							break;
						}else if("Y" == erpFrontGrid.cells(frontGridCheckedRowArray[i], erpFrontGrid.getColIndexById("SEND_TYPE")).getValue()){
							validTF = false;
							break;
						}
					}
					
					if(!validTF){
						$erp.alertMessage({
							"alertMessage" : "확정 및 ERP전송처리가 되지 않은 거래명세서만 삭제가 가능합니다.",
							"alertType" : "alert",
							"isAjax" : false
						});
						return false;
					}else{
						$erp.confirmMessage({
							"alertMessage" : "체크된 거래명세서를 삭제하시겠습니까?",
							"alertType" : "alert",
							"isAjax" : false,
							"alertCallbackFn" : function(){
								$.ajax({
									url : "/sis/market/purchase/deleteGoodsInspectionRegistList.do"
									, data : {
										"INSP_DATE" : inspDate
										,"ORGN_CD" : orgnCd
										,"UNI_KEYS" : frontGridUnikeys
									}
									,method : "POST"
									,dataType : "JSON"
									,success : function(data) {
										erpLayout.progressOff();
										if(data.isError){
											$erp.ajaxErrorMessage(data);
										}else {
											if(data.resultMsg == "SUCCESS"){
												$erp.clearDhtmlXGrid(erpFrontGrid);
												$erp.alertMessage({
													"alertMessage" : "삭제가 완료 되었습니다.",
													"alertType" : "alert",
													"isAjax" : false,
													"alertCallbackFn" : function(){
														searchErpFrontGrid();
													}
												});
											}else{
												$erp.alertMessage({
													"alertMessage" : "삭제 실패 하였습니다.",
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
	}
	
	function searchErpBackGrid(){
		document.getElementById("div_erp_front_grid").style.display = "none";
		document.getElementById("div_erp_back_grid").style.display = "block";
		
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var inspDate = document.getElementById("searchInspDate").value.replace(/\-/g,'');
		var orgnCd = cmbORGN_CD.getSelectedValue();
		
		if(inspDate == null || inspDate == ""){
			isValidated = false;
			alertMessage = "입고일자를 지정해야 합니다.";
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
						document.getElementById("searchInspDate").focus();
					}
				}
			});
		}else{
			$.ajax({
				url: "/sis/market/purchase/getGoodsExpertRegistList.do" //입고예정수량 자료 조회
				, data : {
					 "INSP_DATE" : inspDate
					 , "ORGN_CD" : orgnCd
				}
				, method : "POST"
				, dataType : "JSON"
				, success : function(data){
					erpLayout.progressOn();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpBackGrid);
						var gridDataList = data.dataMap;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpBackGrid
								,'<spring:message code="grid.noSearchData" />'
							);
						}else {
							erpBackGrid.parse(gridDataList, 'js');
							
							var allRowIds = erpBackGrid.getAllRowIds();
							var allRowArray = allRowIds.split(",");
							for(var i=0; i<allRowArray.length; i++){
								if(erpBackGrid.cells(allRowArray[i],erpBackGrid.getColIndexById("D_TYPE")).getValue() == "PUR"){
									erpBackGrid.cells(allRowArray[i],erpBackGrid.getColIndexById("D_TYPE_NM")).setBgColor("red"); 
								}
							}
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpBackGrid);
					erpLayout.progressOff();
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	function initDhtmlXCombo(){
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
	
	<%-- ■ 기타 Function 시작 --%>
	function enterSearchToGrid(kcode){
		if(kcode == 13){
			document.getElementById("searchInspDate").blur();
			$("#div_erp_grid").children().each(function(index, obj){
				var display = obj.style.display;
				if(display == "block"){
					var id = obj.id;
					var grid_ID = obj.getAttribute("id");
					if(grid_ID == "div_erp_front_grid"){
						searchErpFrontGrid();
					} else if(grid_ID == "div_erp_back_grid"){
						searchErpBackGrid();
					}
				}
			});
		}
	}
	
	function openAddInspData(purSlipCd){
		
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var inspDate = document.getElementById("searchInspDate").value.replace(/\-/g,'');
		var orgnDivCd = cmbORGN_DIV_CD.getSelectedValue();
		var orgnCd = cmbORGN_CD.getSelectedValue();
		
		if(inspDate == null || inspDate == ""){
			isValidated = false;
			alertMessage = "입고일자를 지정해야 합니다.";
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
						document.getElementById("searchInspDate").focus();
					}
				}
			});
		}else{
			var paramMap = new Object();
			paramMap.INSP_DATE = inspDate;
			paramMap.ORGN_DIV_CD = orgnDivCd;
			paramMap.ORGN_CD = orgnCd;
			if(purSlipCd == null || purSlipCd == undefined || purSlipCd == ""){
				paramMap.PUR_SLIP_CD = "";
			}else{
				paramMap.PUR_SLIP_CD = purSlipCd;
			}
			
			var onSaveAfterSearch = function(){
				this.searchErpFrontGrid();
				$erp.closePopup2("openAddInspData");
			}
			
			var url = "/sis/market/purchase/openAddInspData.sis";
			var option = {
					"width" : 850
					,"height" :766
					,"resize" : false
					,"win_id" : "openAddInspData"
			}
			
			var onContentLoaded = function(){
				var popWin = this.getAttachedObject().contentWindow;
				
				if(onSaveAfterSearch && typeof onSaveAfterSearch === 'function'){
					while(popWin.popOnSaveAfterSearch == undefined){
						popWin.popOnSaveAfterSearch = onSaveAfterSearch;
					}
				}
				
				this.progressOff();
			}
			
			$erp.openPopup(url, {"inspInfo" : JSON.stringify(paramMap)}, onContentLoaded, option);
		}
	}
	<%-- ■ 기타 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_table" class="samyang_div" style="display:none">
		<table id = "tb_search_01" class = "table">
			<colgroup>
				<col width="80px">
				<col width="230px">
				<col width="80px">
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
			<tr>
				<th>입고일자</th>
				<td colspan="3">
					<input type="text" id="searchInspDate" name="searchInspDate" class="input_common input_calendar default_date" data-position="" onkeydown="enterSearchToGrid(event.keyCode);">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none">
		<div id="div_erp_front_grid" class="div_grid_full_size" style="display:none"></div>
		<div id="div_erp_back_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>