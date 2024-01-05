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
<script type="text/javascript" src="/resources/common/js/report.js?ver=28"></script>
<script type="text/javascript">
	
	LUI = JSON.parse('${empSessionDto.lui}');

	var erpLayout;
	var erpLeftLayout;
	var erpOrderRibbon;
	var erpHeaderGridColumns;
	var erpHeaderGrid;
	var erpDetailGridColumns;
	var erpDetailGrid;
	var cmbMEM_TYPE;
	var cmbMEM_NO;
	var CID_PHONE_NUM = "";
	var member_name = "";
	
	$(document).ready(function(){
		initErpLayout();
		initErpLeftLayout();
		initErpRibbon();
		initErpHeaderGrid();
		initErpDetailGrid();
		initDhtmlXCombo();
		
		$erp.asyncObjAllOnCreated(function(){
			document.getElementById("CID_Phone_Num").value = CID_PHONE_NUM;
			cmbMEM_TYPE.disable();
		});
	});
	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2U"
			, cells : [
				{id: "a", text: "회원정보_주문거래건", header:false}
				,{id: "b", text: "전화주문상세내역", header:true}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_left_layout");
		erpLayout.cells("a").setWidth(800);
		erpLayout.cells("b").attachObject("div_erp_detail_grid");
		
		erpLayout.setSeparatorSize(0, 5);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpLeftLayout.setSizes();
			erpHeaderGrid.setSizes();
			erpDetailGrid.setSizes();
		});
	}
	
	
	
	function initErpLeftLayout(){
		erpLeftLayout = new dhtmlXLayoutObject({
			parent : "div_erp_left_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "4E"
			, cells : [
				{id: "a", text: "회원정보", header:false, fix_size : [true, true]}
				,{id: "b", text: "일자", header:false}
				,{id: "c", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "d", text: "주문내역", header:false}
			]
		});
		
		erpLeftLayout.cells("a").attachObject("div_erp_member_info");
		erpLeftLayout.cells("a").setHeight(170);
		erpLeftLayout.cells("b").attachObject("div_erp_order_date");
		erpLeftLayout.cells("b").setHeight(15);
		erpLeftLayout.cells("c").attachObject("div_erp_order_ribbon");
		erpLeftLayout.cells("c").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftLayout.cells("d").attachObject("div_erp_header_grid");
		
		erpLeftLayout.setSeparatorSize(0, 2);
		erpLeftLayout.setSeparatorSize(1, 2);
	}
	
	
	function initErpRibbon(){
		erpOrderRibbon = new dhtmlXRibbon({
			parent : "div_erp_order_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpHeaderGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					,{id : "add_order", type : "button", text:'접수완료', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : true}
					,{id : "add_reorder", type : "button", text:'재주문', isbig : false, img : "menu/open.gif", imgdis : "menu/open_dis.gif", disable : true}
					,{id : "delete_order", type : "button", text:'주문취소', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					,{id : "add_new_order", type : "button", text:'새주문서 작성', isbig : false, img : "18/new.gif", imgdis : "18/new_dis.png", disable : true}
					,{id : "print_order", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true}
				]}
			]
		});
		
		erpOrderRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpHeaderGrid"){
				isSearchValidate();
			} else if (itemId == "add_order"){
				receiptMemOrderList();
			} else if (itemId == "add_reorder"){
				reOrderMemOrderList();
			} else if (itemId == "delete_order"){
				cancelMemOrderList();
			} else if (itemId == "add_new_order"){
				openNewOrderPopup();
			} else if (itemId == "print_order"){
				printMemOrderList();
			}
		});
	}
	
	function initErpHeaderGrid(){
		erpHeaderGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "CHECK", label : ["선택" , "#rspan"], type : "ch", width : "40", sort : "str", align : "center", isHidden : false, isEssential : false}
			,{id : "ORGN_DIV_CD", label:["조직구분코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "TEL_ORD_CD", label:["전화주문코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "ORD_DATE", label:["주문일자", "#rspan"], type: "ro", width: "134", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "TOT_GOODS_NM", label:["전화주문명", "#rspan"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "SALE_TOT_AMT", label:["주문금액", "#rspan"], type: "ron", width: "78", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "ORD_STATE", label:["주문상태", "#rspan"], type: "combo", width: "140", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode:"DELI_ORD_STATE"}
			,{id : "ORD_MEMO", label:["배송메모", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpHeaderGrid = new dhtmlXGridObject({
			parent: "div_erp_header_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpHeaderGridColumns
		});
		erpHeaderGrid.enableDistributedParsing(true, 100, 50);
		erpHeaderGrid.setNumberFormat("0,000", 6);
		$erp.initGridCustomCell(erpHeaderGrid);
		$erp.initGridComboCell(erpHeaderGrid);
		$erp.attachDhtmlXGridFooterPaging(erpHeaderGrid, 30);
		$erp.attachDhtmlXGridFooterRowCount(erpHeaderGrid, '<spring:message code="grid.allRowCount" />');
		
		erpHeaderGrid.attachEvent("onRowDblClicked", function(rId){
			var tel_ord_cd = this.cells(rId, this.getColIndexById("TEL_ORD_CD")).getValue();
			var orgn_div_cd = this.cells(rId, this.getColIndexById("ORGN_DIV_CD")).getValue();
			var orgn_cd = this.cells(rId, this.getColIndexById("ORGN_CD")).getValue();
			
			var headerParam = {};
			headerParam["TEL_ORD_CD"] = tel_ord_cd
			headerParam["ORGN_DIV_CD"] = orgn_div_cd
			headerParam["ORGN_CD"] = orgn_cd
			
			searchErpDetailGrid(headerParam);
		});
		
		$erp.initGridDataColumns(erpHeaderGrid);
	}
	
	function initErpDetailGrid(){
		erpDetailGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "ORGN_DIV_CD", label:["조직구분코드", "#rspan"], type: "ro", width: "200", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "TEL_ORD_CD", label:["전화주문코드", "#rspan"], type: "ro", width: "100", sort : "left", align : "center", isHidden : true, isEssential : false}
			,{id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "BCD_NM", label:["상품명", "#rspan"], type: "ro", width: "230", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "SALE_PRICE", label:["단가", "#rspan"], type: "ron", width: "67", sort : "int", align : "right", isHidden : false, isEssential : false}
			,{id : "SALE_QTY", label:["수량", "#rspan"], type: "ron", width: "40", sort : "int", align : "right", isHidden : false, isEssential : false}
			,{id : "SALE_TOT_AMT", label:["합계", "#rspan"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false}
		];
		
		erpDetailGrid = new dhtmlXGridObject({
			parent: "div_erp_detail_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpDetailGridColumns
		});
		erpDetailGrid.enableDistributedParsing(true, 100, 50);
		erpDetailGrid.setNumberFormat("0,000", 6);
		erpDetailGrid.setNumberFormat("0,000", 7);
		erpDetailGrid.setNumberFormat("0,000", 8);
		$erp.initGridCustomCell(erpDetailGrid);
		$erp.initGridComboCell(erpDetailGrid);
		$erp.attachDhtmlXGridFooterPaging(erpDetailGrid, 10);
		$erp.attachDhtmlXGridFooterRowCount(erpDetailGrid, '<spring:message code="grid.allRowCount" />');
		
		$erp.initGridDataColumns(erpDetailGrid);
	}
	
	function cidValidCheck(kcode){
		document.getElementById("cidValidMsgSpan").innerHTML = "";
		document.getElementById("hidMemNoSpan").style.display = "none";
		if(kcode == 13){
			searchMemList();
		}
	}
	
	function searchMemList() {
		
		var cidPhoneNum = document.getElementById("CID_Phone_Num").value;
		
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isEmpty(cidPhoneNum) || cidPhoneNum.length < 4) {
			isValidated = false;
			alertMessage = "전화번호를 4자 이상 입력해주세요.";
		}
		
		if($erp.isLengthOver(cidPhoneNum, 50)){
			isValidated = false;
			alertMessage = "전화번호를 50자 이상 입력 할 수 없습니다.";
		} 		
		
		if(!isValidated){
			document.getElementById("cidValidMsgSpan").innerHTML = alertMessage;
		}else{
			document.getElementById("cidValidMsgSpan").innerHTML = "";
			$.ajax({
				url : "/sis/market/sales/getCIDMemberList.do"
				,data : {
					"TEL_NO" : cidPhoneNum
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						var memberList = data.dataList;
						if($erp.isEmpty(memberList)){
							document.getElementById("cidValidMsgSpan").innerHTML = "회원정보를 찾을 수 없습니다.";
						}else {
							if(memberList.length == 1){
								var memListOptionArray = [];
								memListOptionArray.push({value:memberList[0].MEM_NO,text:memberList[0].MEM_NO + ' - ' + memberList[0].MEM_NM + ' - ' + memberList[0].CORP_NM ,selected: true});
								cmbMEM_NO.clearAll();
								cmbMEM_NO.addOption(memListOptionArray);
								searchMemInfo();
							}else{
								var memListOptionArray = [];
								memListOptionArray.push({value: "", text: "선택" ,selected: true});
								for (var i = 0; i<memberList.length; i++){
									memListOptionArray.push({value:memberList[i].MEM_NO,text:memberList[i].MEM_NO + ' - ' + memberList[i].MEM_NM + ' - ' + memberList[i].CORP_NM});
								}
								cmbMEM_NO.clearAll();
								cmbMEM_NO.addOption(memListOptionArray);
								document.getElementById("hidMemNoSpan").style.display = "inline-flex";
							}
						}
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	function searchMemInfo(){
		var memNo = cmbMEM_NO.getSelectedValue();
		
		$.ajax({
			url : "/sis/market/sales/getCIDMemberInfo.do"
			,data : {
				"MEM_NO" : memNo
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					var MemberInfo = data.dataMap;
					if($erp.isEmpty(MemberInfo)){
						document.getElementById("cidValidMsgSpan").innerHTML = "회원정보를 찾을 수 없습니다.";
					}else {
						var tbMemData = document.getElementById("table_mem_info");
						$erp.dataClear(tbMemData);
						$erp.dataAutoBind(tbMemData, MemberInfo);
						member_name = document.getElementById("txtMEM_NM").value;
						isSearchValidate();
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function isSearchValidate(){
		var isValidated = true;
		
		var mem_no = document.getElementById("txtMEM_NO").value;
		var searchDateFrom = document.getElementById("searchDateFrom").value;
		var searchDateTo = document.getElementById("searchDateTo").value;
		var alertMessage = "";
		
		if($erp.isEmpty(searchDateFrom)){
			isValidated = false;
			alertMessage = "검색 날짜는 반드시 입력해야 합니다.";
		}
		
		if($erp.isEmpty(searchDateTo)){
			isValidated = false;
			alertMessage = "검색 날짜는 반드시 입력해야 합니다.";
		}
		
		if($erp.isEmpty(mem_no)){
			isValidated = false;
			alertMessage = "조회된 회원정보가 없습니다."
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage,
				"alertType" : "alert",
				"isAjax" : false
			});
		} else {
			searchErpHeaderGrid();
		}
	}
	
	function searchErpHeaderGrid(){
		if( member_name == "") {
			$erp.alertMessage({
				"alertMessage" : "주문자전화번호로 회원검색 후 이용 가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else {
			var searchDateFrom = document.getElementById("searchDateFrom").value;
			var searchDateTo = document.getElementById("searchDateTo").value;
			if(Number(searchDateFrom.split("-").join("")) > Number(searchDateTo.split("-").join(""))) {
				$erp.alertMessage({
					"alertMessage" : "error.common.invalidBeginEndDate",
					"alertCode" : null,
					"alertType" : "alert",
					"alertCallbackFn" : function() {
						document.getElementById("searchDateFrom").value = $erp.getToday("-");
						document.getElementById("searchDateTo").value = $erp.getToday("-");
					},
				});
			} else {
				var mem_no = document.getElementById("txtMEM_NO").value;
				erpLayout.progressOn();
				$.ajax({
					url : "/sis/market/sales/getMemOrderHeaderList.do"
					,data : {
						"MEM_NO" : mem_no
						, "ORGN_CD" : document.getElementById("txtORGN_CD").value
						, "searchDateFrom" : searchDateFrom
						, "searchDateTo" : searchDateTo
					}
					,method : "POST"
					,dataType : "JSON"
					,success : function(data) {
						erpLayout.progressOff();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else {
							$erp.clearDhtmlXGrid(erpHeaderGrid);
							$erp.clearDhtmlXGrid(erpDetailGrid);
							var gridDataList = data.dataMap;
							if($erp.isEmpty(gridDataList)){
								$erp.addDhtmlXGridNoDataPrintRow(
										erpHeaderGrid
										,  '<spring:message code="grid.noSearchData" />'
								);
								return false;
							}else {
								erpHeaderGrid.parse(gridDataList, 'js');
							}
						}
						$erp.setDhtmlXGridFooterRowCount(erpHeaderGrid);
						erpLayout.progressOff();
					}, error : function(jqXHR, textStatus, errorThrown){
						erpLayout.progressOff();
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
			}
		}
	}
	
	function searchErpDetailGrid(headerParam){
		$.ajax({
			url : "/sis/market/sales/getMemOrderDetailList.do"
			,data : headerParam
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpDetailGrid);
					var gridDataList = data.dataMap;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
								erpDetailGrid
								,  '<spring:message code="grid.noSearchData" />'
						);
						return false;
					}else {
						erpDetailGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpDetailGrid);
				erpLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function receiptMemOrderList(){
		var check = erpHeaderGrid.getCheckedRows(erpHeaderGrid.getColIndexById("CHECK"));
		
		if(check == "") {
			$erp.alertMessage({
				"alertMessage" : "접수완료 할 주문서를 선택해주세요",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
			return false;
		}else{
			var checkList = check.split(',');
			var all_checkList = [];
			
			var validTF = true;
			
			for(var i=0; i<checkList.length; i++){
				all_checkList[i] = erpHeaderGrid.cells(checkList[i], erpHeaderGrid.getColIndexById("TEL_ORD_CD")).getValue();
				if("O1" != erpHeaderGrid.cells(checkList[i], erpHeaderGrid.getColIndexById("ORD_STATE")).getValue()){
					validTF = false;
				}
			}
			
			if(!validTF){
				$erp.alertMessage({
					"alertMessage" : "최초주문접수 주문서만 접수완료가 가능합니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false
				});
				return false;
			}else{
				$erp.confirmMessage({
					"alertMessage" : "선택하신 주문을 정말 접수완료 하시겠습니까?"
					, "alertCode" : ""
					, "alertType" : alert
					, "alertCallbackFn" : function addConfirm(){
						$.ajax({
							url : "/sis/market/sales/receiptMemOrderList.do"
							,data : {
								"paramList" : all_checkList
							}
							,method : "POST"
							,dataType : "JSON"
							,success : function(data) {
								erpLayout.progressOff();
								if(data.isError){
									$erp.ajaxErrorMessage(data);
								}else {
									$erp.clearDhtmlXGrid(erpHeaderGrid);
									var gridDataValue = data.resultValue;
									if(gridDataValue == 0){
										$erp.alertMessage({
											"alertMessage" : "주문접수완료가 실패 하였습니다.",
											"alertType" : "alert",
											"isAjax" : false
										});
										return false;
									}else {
										$erp.alertMessage({
											"alertMessage" : "주문접수완료가 처리 되었습니다.",
											"alertType" : "alert",
											"isAjax" : false
										});
										searchErpHeaderGrid();
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
	
	function reOrderMemOrderList(){
		var check = erpHeaderGrid.getCheckedRows(erpHeaderGrid.getColIndexById("CHECK"));
		
		if(check == "") {
			$erp.alertMessage({
				"alertMessage" : "재주문 할 주문서를 선택해주세요",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
			return false;
		}else{
			var checkList = check.split(',');
			var all_checkList = [];
			
			var validTF = true;
			
			for(var i=0; i<checkList.length; i++){
				all_checkList[i] = erpHeaderGrid.cells(checkList[i], erpHeaderGrid.getColIndexById("TEL_ORD_CD")).getValue();
				if("O9" != erpHeaderGrid.cells(checkList[i], erpHeaderGrid.getColIndexById("ORD_STATE")).getValue()){
					validTF = false;
				}
			}
			
			if(!validTF){
				$erp.alertMessage({
					"alertMessage" : "[주문취소] 주문서만 재주문이 가능합니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false
				});
				return false;
			}else{
				$erp.confirmMessage({
					"alertMessage" : "선택하신 주문서를 재주문 하시겠습니까?<br>(현재시간으로 주문접수완료 상태가 됩니다.)"
					, "alertCode" : ""
					, "alertType" : alert
					, "alertCallbackFn" : function addConfirm(){
						$.ajax({
							url : "/sis/market/sales/reOrderMemOrderList.do"
							,data : {
								"paramList" : all_checkList
							}
							,method : "POST"
							,dataType : "JSON"
							,success : function(data) {
								erpLayout.progressOff();
								if(data.isError){
									$erp.ajaxErrorMessage(data);
								}else {
									$erp.clearDhtmlXGrid(erpHeaderGrid);
									var gridDataValue = data.resultValue;
									if(gridDataValue == 0){
										$erp.alertMessage({
											"alertMessage" : "주문접수완료가 실패 하였습니다.",
											"alertType" : "alert",
											"isAjax" : false
										});
										return false;
									}else {
										$erp.alertMessage({
											"alertMessage" : "주문접수완료가 처리 되었습니다.",
											"alertType" : "alert",
											"isAjax" : false
										});
										searchErpHeaderGrid();
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
	
	function cancelMemOrderList(){
		var check = erpHeaderGrid.getCheckedRows(erpHeaderGrid.getColIndexById("CHECK"));
		
		if(check == "") {
			$erp.alertMessage({
				"alertMessage" : "취소하실 주문서를 선택해주세요.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
			return false;
		}else{
			var checkList = check.split(',');
			var all_checkList = [];
			
			var validTF = true;
			
			for(var i=0; i<checkList.length; i++){
				all_checkList[i] = erpHeaderGrid.cells(checkList[i], erpHeaderGrid.getColIndexById("TEL_ORD_CD")).getValue();
				if("O10" != erpHeaderGrid.cells(checkList[i], erpHeaderGrid.getColIndexById("ORD_STATE")).getValue()){
					validTF = false;
				}
			}
			
			if(!validTF){
				$erp.alertMessage({
					"alertMessage" : "[주문접수완료] 주문서만 주문취소가 가능합니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false
				});
				return false;
			}else{
				$erp.confirmMessage({
					"alertMessage" : "선택하신 주문을 정말 취소하시겠습니까?"
					, "alertCode" : ""
					, "alertType" : alert
					, "alertCallbackFn" : function deleteConfirm(){
						$.ajax({
							url : "/sis/market/sales/cancelMemOrderList.do"
							,data : {
								"paramList" : all_checkList
							}
							,method : "POST"
							,dataType : "JSON"
							,success : function(data) {
								erpLayout.progressOff();
								if(data.isError){
									$erp.ajaxErrorMessage(data);
								}else {
									$erp.clearDhtmlXGrid(erpHeaderGrid);
									var gridDataValue = data.resultValue;
									if(gridDataValue == 0){
										$erp.alertMessage({
											"alertMessage" : "주문취소를 실패했습니다.",
											"alertType" : "alert",
											"isAjax" : false
										});
										return false;
									}else {
										$erp.alertMessage({
											"alertMessage" : "주문취소가 완료되었습니다.",
											"alertType" : "alert",
											"isAjax" : false
										});
										searchErpHeaderGrid();
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
	
	<%-- openNewOrderPopup 새주문서작성 팝업 열림 Function --%>
	function openNewOrderPopup(){
		if( member_name == "") {
			$erp.alertMessage({
				"alertMessage" : "주문자전화번호로 회원검색 후 이용 가능합니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}else {
			var onCloseAndSearch = function(){
				this.isSearchValidate();
			}
			
			var paramMap = new Object();
			paramMap.Mem_Name = document.getElementById("txtMEM_NM").value;
			paramMap.Mem_No = document.getElementById("txtMEM_NO").value;
			paramMap.Corp_Nm = document.getElementById("txtCORP_NM").value;
			paramMap.Mem_Type = cmbMEM_TYPE.getSelectedValue();
			paramMap.Mem_Tel = document.getElementById("txtTEL_NO").value;
			paramMap.Mem_Trust_Cnt = document.getElementById("txtTRUST_CNT").value;
			paramMap.Mem_Addr = document.getElementById("txtADDR").value;
			paramMap.Mem_Zip_No = document.getElementById("txtDELI_ZIP_NO").value;
			paramMap.ORGN_CD = document.getElementById("txtORGN_CD").value;
			paramMap.ORGN_DIV_CD = LUI.LUI_orgn_div_cd;

			$erp.openNewOrderPopup({"memberInfo" : JSON.stringify(paramMap)},onCloseAndSearch);
		}
	}
	
	function printMemOrderList(){
		var check = erpHeaderGrid.getCheckedRows(erpHeaderGrid.getColIndexById("CHECK"));
		
		if(check == "") {
			$erp.alertMessage({
				"alertMessage" : "출력하실 주문서를 선택해주세요.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
			return false;
		}else{
			var checkList = check.split(',');
			var all_checkList = [];
			
			var validTF = true;
			
			for(var i=0; i<checkList.length; i++){
				all_checkList[i] = erpHeaderGrid.cells(checkList[i], erpHeaderGrid.getColIndexById("TEL_ORD_CD")).getValue();
				if("O10" != erpHeaderGrid.cells(checkList[i], erpHeaderGrid.getColIndexById("ORD_STATE")).getValue()){
					validTF = false;
				}
			}
			
			if(!validTF){
				$erp.alertMessage({
					"alertMessage" : "[주문접수완료] 주문서만 출력이 가능합니다.",
					"alertCode" : null,
					"alertType" : "alert",
					"isAjax" : false
				});
				return false;
			}else{
				$erp.confirmMessage({
					"alertMessage" : "선택하신 주문서을 출력하시겠습니까?"
					, "alertCode" : ""
					, "alertType" : alert
					, "alertCallbackFn" : function printConfirm(){
						printPopup(all_checkList);
					}
				});
			}
		}
	}
	
	function printPopup(all_checkList){
		var paramInfo = {
				"ORD_CD_LIST" : all_checkList
				, "ORGN_CD" : $("#txtORGN_CD").val()
				, "MEM_NO" : $("#txtMEM_NO").val()
				, "mrdPath" : "order_sheet_mrd"
				, "mrdFileName" : "mem_order_sheet.mrd"
		};
		
		var approvalURL = $CROWNIX_REPORT.openMemOrderSheet("", paramInfo, "주문내역서출력", "");
		var popObj = window.open(approvalURL, "mem_order_sheet_popup", "width=900,height=1000");
		
		var frm = document.PrintMemOrderform;
		frm.action = approvalURL;
		frm.target = "mem_order_sheet_popup";
		frm.submit();
	}
	
	function initDhtmlXCombo(){
		cmbMEM_TYPE = $erp.getDhtmlXCombo("cmbMEM_TYPE", "MEM_TYPE", "MEM_TYPE" , 120);
		cmbMEM_NO = new dhtmlXCombo("comboMemNoSpan");
		cmbMEM_NO.setSize(300);
		cmbMEM_NO.readonly(true);
		cmbMEM_NO.attachEvent("onChange",function(value,text){
			searchMemInfo();
		});
	}
</script>
</head>
<body>
	<form name="PrintMemOrderform" action="" method="post"></form>
	<div id="div_erp_left_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_member_info" class="samyang_div" style="diplay:none;">
			<table id="table_mem_info" class="table" >
				<colgroup>
					<col width="100px">
					<col width="140px">
					<col width="80px">
					<col width="140px">
					<col width="80px">
					<col width="*">
				</colgroup>
				<tr>
					<th>주문자전화번호</th>
					<td colspan="5">
						<input type="text" id="CID_Phone_Num" name="CID_Phone_Num" class="input_common" style="width: 120px;" placeholder="입력하세요" onkeydown="cidValidCheck(event.keyCode);">
						<input type="button" id="input_phone_num" name="input_phone_num" value="회원검색" class="input_common_button" onclick="searchMemList()">
						<span id="hidMemNoSpan" style="display: none;"><span id="comboMemNoSpan"></span></span>
						<span id="cidValidMsgSpan"></span>
					</td>
				</tr>
				<tr>
					<th colspan="6" style="text-align: center;">회원정보</th>
				</tr>
				<tr>
					<th>회원명</th>
					<td>
						<input type="hidden" id="txtORGN_CD" name="ORGN_CD" class="input_common input_readonly"readonly="readonly" >
						<input type="hidden" id="txtMEM_NO" name="MEM_NO" class="input_common input_readonly" readonly="readonly" >
						<input type="text" id="txtMEM_NM" name="MEM_NM" class="input_common input_readonly" readonly="readonly" style="width: 120px;">
					</td>
					<th>상호명</th>
					<td>
						<input type="text" id="txtCORP_NM" name="CORP_NM" class="input_common input_readonly" readonly="readonly" style="width: 120px;">
					</td>
					<th>회원유형</th>
					<td>
						<div id="cmbMEM_TYPE"></div>
					</td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td>
						<input type="text" id="txtTEL_NO" name="TEL_NO" class="input_common input_readonly" readonly="readonly" style="width: 120px;">
					</td>
					<th>외상건수</th>
					<td style="font-weight:bold;" colspan="3">
						<input type="text" id="txtTRUST_CNT" name="TRUST_CNT" class="input_common input_readonly" readonly="readonly" style="width: 120px;">&nbsp;건
					</td>
				</tr>
				<tr>
					<th>우편번호</th>
					<td colspan="5">
						<input type="text" id="txtDELI_ZIP_NO" name="DELI_ZIP_NO" class="input_common input_readonly" readonly="readonly" style="width: 120px;">
					</td>
				</tr>
				<tr>
					<th>배송지주소</th>
					<td rowspan="2" colspan="5">
						<input type="text" id="txtADDR" name="ADDR" class="input_common input_readonly" readonly="readonly" style="width: 500px;">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_order_date" class="div_erp_contents_search" style="display:none">
			<table>
				<colgroup>
					<col width="100px">
					<col width="*">
				</colgroup>
				<tr>
					<th>일 자</th>
					<td style="width: 250px;">
						<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_calendar default_date" data-position="(start)">
						<span style="float : left;">~</span>
						<input type="text" id="searchDateTo" name="searchDateTo" class="input_calendar default_date" data-position="">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_order_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_header_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	<div id="div_erp_detail_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>