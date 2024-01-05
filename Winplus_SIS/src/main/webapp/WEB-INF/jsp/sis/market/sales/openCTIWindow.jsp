<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>전화주문 CTI</title>
<link rel="shortcut icon" href="/resources/common/img/default/winplus_favicon.ico" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/><!-- 기본 -->
<%-- <jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/> --%><!-- 기존 -->
<jsp:include page="/WEB-INF/jsp/common/include/default_new_window_script_header.jsp"/><!-- 대체 -->
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/><!-- 기본 -->
<script type="text/javascript" src="/resources/common/js/report.js"></script>
<link rel="stylesheet" href="/resources/cti/css/cti.css" />
<!-- <script type="text/javascript" src="/resources/cti/js/cti.js"></script> -->
<script type="text/javascript">
	LUI = JSON.parse('${empSessionDto.lui}');
	var erpLayout;
	
	var erpMainLayout;
	var erpMainRibbon;
	var erpMainGrid;
	var erpMainGridColumns;
	
	var cmbSEARCH_TYPE;
	
	var today = $erp.getToday("-");
	
	$(document).ready(function(){
		initErpLayout();
		
		initErpMainLayout();
		initErpMainRibbon();
		initErpMainGrid();
		
		initDhtmlXCombo();
		
		initErpPopupWindows();
		
		$erp.asyncObjAllOnCreated(function(){
			document.getElementById("searchFromDate").value = today;
			document.getElementById("searchToDate").value = today;
			
			webSocketGo();//웹소켓접속
		});
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		if(${empSessionDto.member_CTI != 'Y'}){
			erpLayout = new dhtmlXLayoutObject({
				parent : document.body
				, skin : ERP_LAYOUT_CURRENT_SKINS
				, pattern : "1C"
				, cells : [
					//{id: "a", text: "CTI영역", header: false , fix_size:[true, true]}
					{id : "a", text: "조회그리드영역", header: false}
					//,{id : "c", text: "입력/상세그리드영역", header: false}
				]
			});
			
			//erpLayout.cells("a").attachObject("div_erp_cti_table");
			//erpLayout.cells("a").setHeight($erp.getTableHeight(1));
			erpLayout.cells("a").attachObject("div_erp_main_layout");
			//erpLayout.cells("b").setWidth(800);
			//erpLayout.cells("c").attachObject("div_erp_right_layout");
		}else{
			erpLayout = new dhtmlXLayoutObject({
				parent : document.body
				, skin : ERP_LAYOUT_CURRENT_SKINS
				, pattern : "2E"
				, cells : [
					{id: "a", text: "CTI영역", header: false , fix_size:[true, true]}
					,{id : "b", text: "조회그리드영역", header: false}
					//,{id : "c", text: "입력/상세그리드영역", header: false}
				]
			});
			
			erpLayout.cells("a").attachObject("div_erp_cti_table");
			erpLayout.cells("a").setHeight($erp.getTableHeight(1));
			erpLayout.cells("b").attachObject("div_erp_main_layout");
			//erpLayout.cells("b").setWidth(800);
			//erpLayout.cells("c").attachObject("div_erp_right_layout");
		}
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpMainLayout.setSizes();
			erpMainGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 시작 --%>
	
	<%-- ■ erpMainLayout 관련 Function 시작 --%>
	function initErpMainLayout(){
		erpMainLayout = new dhtmlXLayoutObject({
			parent: "div_erp_main_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false , fix_size:[true, true]}
				,{id: "b", text: "리본영역", header:false , fix_size:[true, true]}
				,{id: "c", text: "요약영역", header:false , fix_size:[true, true]}
				,{id: "d", text: "그리드영역", header:false , fix_size:[true, true]}
			]
		});
		erpMainLayout.cells("a").attachObject("div_erp_main_search_table");
		erpMainLayout.cells("a").setHeight($erp.getTableHeight(2));
		erpMainLayout.cells("b").attachObject("div_erp_main_ribbon");
		erpMainLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpMainLayout.cells("c").attachObject("div_erp_main_summary_table");
		erpMainLayout.cells("c").setHeight($erp.getTableHeight(1));
		erpMainLayout.cells("d").attachObject("div_erp_main_grid");
	}	
	<%-- ■ erpMainLayout 관련 Function 끝 --%>
	
	<%-- ■ erpMainRibbon 관련 Function 시작 --%>
	function initErpMainRibbon() {
		erpMainRibbon = new dhtmlXRibbon({
			parent : "div_erp_main_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpMainGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					,{id : "add_order", type : "button", text:'접수완료', isbig : false, img : "menu/apply.gif", imgdis : "menu/apply_dis.gif", disable : true}
					,{id : "delete_order", type : "button", text:'주문취소', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					,{id : "print_order", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true}
					,{id : "add_new_order", type : "button", text:'새주문서 작성', isbig : false, img : "18/new.gif", imgdis : "18/new_dis.png", disable : true}
				]}
			]
		});
		
		erpMainRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpMainGrid") {
				searchErpMainGrid();
			} else if (itemId == "add_order"){
				receiptMemOrderList();
			} else if (itemId == "delete_order"){
				cancelMemOrderList();
			} else if (itemId == "print_order"){
				printMemOrderList();
			} else if (itemId == "add_new_order"){
				openTellOrderCTIPopup();
			}
		});
	}
	
	function receiptMemOrderList(){
		var check = erpMainGrid.getCheckedRows(erpMainGrid.getColIndexById("CHECK"));
		
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
				all_checkList[i] = erpMainGrid.cells(checkList[i], erpMainGrid.getColIndexById("TEL_ORD_CD")).getValue();
				if("O1" != erpMainGrid.cells(checkList[i], erpMainGrid.getColIndexById("ORD_STATE")).getValue()){
					validTF = false;
				}
			}
			
			if(!validTF){
				$erp.alertMessage({
					"alertMessage" : "[최초주문접수] 주문서만 접수완료가 가능합니다.",
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
						erpLayout.progressOn();
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
									$erp.clearDhtmlXGrid(erpMainGrid);
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
										searchErpMainGrid();
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
		var check = erpMainGrid.getCheckedRows(erpMainGrid.getColIndexById("CHECK"));
		
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
				all_checkList[i] = erpMainGrid.cells(checkList[i], erpMainGrid.getColIndexById("TEL_ORD_CD")).getValue();
				if("O10" != erpMainGrid.cells(checkList[i], erpMainGrid.getColIndexById("ORD_STATE")).getValue()){
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
						erpLayout.progressOn();
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
									$erp.clearDhtmlXGrid(erpMainGrid);
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
										searchErpMainGrid();
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
	
	function printMemOrderList(){
		var check = erpMainGrid.getCheckedRows(erpMainGrid.getColIndexById("CHECK"));
		
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
				all_checkList[i] = erpMainGrid.cells(checkList[i], erpMainGrid.getColIndexById("TEL_ORD_CD")).getValue();
				if("O10" != erpMainGrid.cells(checkList[i], erpMainGrid.getColIndexById("ORD_STATE")).getValue()){
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
				, "ORGN_CD" : LUI.LUI_orgn_delegate_cd
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
	<%-- ■ erpMainRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpMainGrid 관련 Function 시작 --%>
	function initErpMainGrid(){
		erpMainGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "CHECK", label : ["#master_checkbox" , "#rspan"], type : "ch", width : "40", sort : "str", align : "center", isHidden : false, isEssential : false}
			,{id : "ORGN_DIV_CD", label:["조직구분코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "ORGN_CD", label:["조직코드", "#rspan"], type: "ro", width: "60", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "TEL_ORD_CD", label:["전화주문코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "ORD_STATE", label:["주문상태", "#rspan"], type: "combo", width: "140", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode:"DELI_ORD_STATE"}
			,{id : "ORD_DATE", label:["주문일", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "DELI_DATE", label:["배송일", "#rspan"], type: "ro", width: "70", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "MEM_NO", label:["고객코드", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "MEM_NM", label:["고객명", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "PHON_NO", label:["휴대폰", "#rspan"], type: "ro", width: "85", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "TOT_GOODS_NM", label:["전화주문명", "#rspan"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "SALE_TOT_AMT", label:["주문금액", "#rspan"], type: "ron", width: "78", sort : "int", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			,{id : "ORD_RESP_USER", label:["접수자", "#rspan"], type: "ro", width: "65", sort : "str", align : "left", isHidden : false, isEssential : false}
			,{id : "ORD_MEMO", label:["배송메모", "#rspan"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpMainGrid = new dhtmlXGridObject({
			parent: "div_erp_main_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpMainGridColumns
		});	
		
		$erp.initGridCustomCell(erpMainGrid);
		$erp.initGridComboCell(erpMainGrid);
		$erp.attachDhtmlXGridFooterPaging(erpMainGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpMainGrid, '<spring:message code="grid.allRowCount" />');
		
		erpMainGrid.attachEvent("onRowDblClicked",function(rId,cInd){
			//CTI 상태변경 필요할듯.. 체크나..
			var memNo = this.cells(rId, this.getColIndexById("MEM_NO")).getValue();
			var telOrdCd = this.cells(rId, this.getColIndexById("TEL_ORD_CD")).getValue();
			var orgnDivCd = this.cells(rId, this.getColIndexById("ORGN_DIV_CD")).getValue();
			var orgnCd = this.cells(rId, this.getColIndexById("ORGN_CD")).getValue();
			
			var headerParam = {};
			headerParam["MEM_NO"] = memNo;
			headerParam["TEL_ORD_CD"] = telOrdCd;
			headerParam["ORGN_DIV_CD"] = orgnDivCd;
			headerParam["ORGN_CD"] = orgnCd;
			
			openTellOrderCTIPopup(headerParam)
		});
	}
	
	function searchErpMainGrid(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var orgnCd = LUI.LUI_orgn_delegate_cd;
		var searchType = cmbSEARCH_TYPE.getSelectedValue();
		var searchFromDate = document.getElementById("searchFromDate").value.replace(/\-/g,'');
		var searchToDate = document.getElementById("searchToDate").value.replace(/\-/g,'');
		var searchText = document.getElementById("searchText").value;
		
		if($erp.isEmpty(orgnCd)){
			isValidated = false;
			alertMessage = "error.common.organ.employee.deptCd.noData";
		}else if($erp.isEmpty(searchType)){
			isValidated = false;
			alertMessage = "error.common.invalidSearchGbn";
		}else if($erp.isEmpty(searchFromDate) || $erp.isEmpty(searchToDate)){
			isValidated = false;
			alertMessage = "error.common.invalidBeginEndNoDate";
			alertCode = "1";
		}else if(Number(searchFromDate) > Number(searchToDate)) {
			isValidated = false;
			alertMessage = "error.common.invalidBeginEndDate";
			alertCode = "1";
		}
		
		var searchParams = {};
		searchParams.SEARCH_URL = "/sis/market/sales/getMemOrderHeaderList.do" //전화주문 목록 자료 조회
		searchParams.ORGN_CD = orgnCd;
		searchParams.SEARCH_TYPE = searchType;
		searchParams.SEARCH_TEXT = searchText;
		searchParams.SEARCH_FROM_DATE = searchFromDate;
		searchParams.SEARCH_TO_DATE = searchToDate;
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				,"alertType" : alertType
				,"isAjax" : true
				,"alertCallbackFn" : function(){
					if(alertCode == "1"){
						document.getElementById("searchFromDate").focus();
					}
				}
			});
		}else{
			erpMainLayout.progressOn();
			$.ajax({
				url : searchParams.SEARCH_URL
				,data : searchParams
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpMainLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						$erp.clearDhtmlXGrid(erpMainGrid);
						var summaryData = data.summaryData;
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpMainGrid
								,'<spring:message code="grid.noSearchData" />'
							);
						}else {
							document.getElementById("spanO1").innerHTML = summaryData.O1;
							document.getElementById("spanO9").innerHTML = summaryData.O9;
							document.getElementById("spanO10").innerHTML = summaryData.O10;
							document.getElementById("spanD1").innerHTML = summaryData.D1;
							document.getElementById("spanD10").innerHTML = summaryData.D10;
							document.getElementById("spanTOT_CNT").innerHTML = summaryData.TOT_CNT;
							erpMainGrid.parse(gridDataList, 'js');
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpMainGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpMainLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	<%-- ■ erpMainGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	function initDhtmlXCombo(){
		cmbSEARCH_TYPE = new dhtmlXCombo("cmbSEARCH_TYPE");
		cmbSEARCH_TYPE.setSize(100);
		var searchOptionArray = [];
		searchOptionArray.push({value:"ORD_DATE",text:"주문일" ,selected: true});
		searchOptionArray.push({value:"DELI_DATE",text:"배송일"});
		cmbSEARCH_TYPE.clearAll();
		cmbSEARCH_TYPE.addOption(searchOptionArray);
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ 기타 Function 시작 --%>
	function openTellOrderCTIPopup(headerParam){
		var onCloseAndSearch = function(){
			searchErpMainGrid();
			$erp.closePopup2("openTellOrderCTIPopup");
		}
		
		var searchParams;
		
		if(headerParam == null || headerParam == undefined){
			searchParams = {};
		}else{
			searchParams = headerParam;
		}
		
		
		var fnParamMap = new Map();
		fnParamMap.set("erpOnCloseAndSearch",onCloseAndSearch);
		
		openTellOrderCTIPopupCall(searchParams, fnParamMap);
	}
	
	openTellOrderCTIPopupCall = function(searchParams, fnParamMap) {
		var url = "/sis/market/sales/openTellOrderCTIPopup.sis";
		var option = {
				"width" : 850
				,"height" :766
				,"win_id" : "openTellOrderCTIPopup"
		}
		
		var onContentLoaded = function(){
			var popWin = this.getAttachedObject().contentWindow;
			var fnParamKeys = fnParamMap.keys();
			var userDefinedFnKey;
			var userDefinedFnValue;
			do{
				userDefinedFnKey = fnParamKeys.next();
				userDefinedFnValue = fnParamMap.get(userDefinedFnKey.value);
				if(userDefinedFnValue && typeof userDefinedFnValue === 'function'){
					while(popWin[userDefinedFnKey.value] == undefined){
						popWin[userDefinedFnKey.value] = userDefinedFnValue;
					}
				}
			}while(!userDefinedFnKey.done);
			
			this.progressOff();
		}
		
		$erp.openPopup(url, searchParams, onContentLoaded, option);
	}
	
	function enterSearchToMainGrid(kcode){
		if(kcode == 13){
			document.getElementById("searchFromDate").blur();
			document.getElementById("searchToDate").blur();
			searchErpMainGrid();
		}
	}
	<%-- ■ 기타 Function 끝 --%>
	
	
	<%-- ■ CTI Function 시작 --%>
//CTI 상태정보를 저장할 변수
var statusCode;//CTI 상태정보 코드
var statusName;//CTI 상태정보 명칭

var groupCode1;
var groupCode2;
var groupCode3;
var groupCode4;
var groupCode5;

var checkGroupInterval;
//var var_normalize = /[^0-9]/gi; //숫자정규식
var var_normalize =/^(?=.*[*])|(?=.*[0-9])}/;

//웹소켓접속
function webSocketGo(){
	var strServerIp = "203.239.159.165";
	var strServerSocketIp = "203.239.159.165";
	var strServerPort = "7070";
	goWebSocket(strServerIp, strServerSocketIp, strServerPort);
}

//로그인
function loginGo(){
	var strCtiLoginId = document.getElementById("cti_login_id").value;
	var strCtiLoginPwd = document.getElementById("cti_login_pwd").value;
	var strCtiLoginExt = document.getElementById("cti_login_ext").value;
	func_login(strCtiLoginId, strCtiLoginPwd, strCtiLoginExt);
}

//강제로그인
function forceLoginGo(){
	var strCtiLoginId = document.getElementById("cti_login_id").value;
	var strCtiLoginPwd = document.getElementById("cti_login_pwd").value;
	var strCtiLoginExt = document.getElementById("cti_login_ext").value;
	func_forceLogin(strCtiLoginId, strCtiLoginPwd, strCtiLoginExt);
}

//did번호체크
function didCheck(){
	var did = document.getElementById("did");//did체크박스
	var callGroup = document.getElementById("callGroup");//소속그룹
	var outCallNum = document.getElementById("outCallNum");//발신표시번호
	var strAgtExt = document.getElementById("cti_login_ext");//내선번호
	if(did.checked){
		//callGroup.disabled = true;
		outCallNum.innerHTML = strAgtExt.value;
	}else{
		//callGroup.disabled = false;
		chagePhoneNumber();
		//outCallNum.innerHTML = "";
	}
}

//makeCall - did체크
function didCheckMakeCall(){
	var did = document.getElementById("did");//did체크박스
	var outCallNum = document.getElementById("outCallNum").innerHTML;//발신표시번호
	var makeCallNum = document.getElementById("makeCallNum").value;//발신자번호

	if(did.checked){//did체크시 - did번호
		func_makeCall(outCallNum, makeCallNum, '');
	}else{//did해제시 - 그룹대표번호
		func_makeCall('', makeCallNum, '');
	}
}

//소속그룹변경
function changeGroup(){
	var callGroup = document.getElementById("callGroup");//소속그룹
	var outCallNum = document.getElementById("outCallNum");//발신표시번호
	//outCallNum.innerHTML = callGroup.value;
	var sIdx = callGroup.selectedIndex;
	var gCode = groupCode[sIdx].split("-");

	func_changeGroup(gCode[0], gCode[1], gCode[2]);
}

//발신표시번호 변경
function chagePhoneNumber(){
	var callGroup = document.getElementById("callGroup");//소속그룹
	var outCallNum = document.getElementById("outCallNum");//발신표시번호
	//outCallNum.innerHTML = callGroup.value;

	var did = document.getElementById("did");//did체크박스
	var strAgtExt = document.getElementById("cti_login_ext");//내선번호

	if(did.checked){//did체크시 - did번호
		outCallNum.innerHTML = strAgtExt.value;
	}else{//did해제시 - 그룹대표번호
		outCallNum.innerHTML = callGroup.value;

	}
}

//소속그룹선택
function callGroupSelect(sGroupCode1, sGroupCode2, sGroupCode3){
	groupCodeLength = groupCode1.length;//소속그룹갯수
    groupCode = new Array( groupCodeLength );//그룹배열
    sGroupCode = sGroupCode1+"-"+sGroupCode2+"-"+sGroupCode3;//소속그룹(아웃바운드)
	var callGroup = document.getElementById("callGroup");//소속그룹
	var outCallNum = document.getElementById("outCallNum");//발신표시번호

	for(var i=0; i<groupCodeLength; i++){
		groupCode[i] = groupCode1[i]+"-"+groupCode2[i]+"-"+groupCode3[i];
		if( sGroupCode == groupCode[i]){
			callGroup.options[i].selected = true;
			outCallNum.innerHTML = callGroup.options[i].value;
		}
	}
	document.getElementById("checkGroupValue2").value = "Y";
}


//전화번호입력
function phoneSend(phoneNum){
    document.getElementById("makeCallNum").value = phoneNum.replace(var_normalize,"");//숫자만등록
}

//숫자만 입력
function CheckNumeric(e){

	if(window.event){
		//엔터입력시 걸기버튼 활성화시 전화걸기
	     if(event.keyCode == 13){
	         if( document.getElementById("search_call_o").style.display == "inline" ){
	             //func_makeCall(document.getElementById("outCallNum").innerHTML, document.form1.makeCallNum.value, '');
	             didCheckMakeCall();
	         }
	    }

		if( event.keyCode != 42 &&  (event.keyCode < 48 || event.keyCode > 57 ) ){
			return false;
		}
		
	}else if(e){
		//엔터입력시 걸기버튼 활성화시 전화걸기
	     if(e.which == 13){
	         if( document.getElementById("search_call_o").style.display == "inline" ){
	             //func_makeCall(document.getElementById("outCallNum").innerHTML, document.form1.makeCallNum.value, '');
	             didCheckMakeCall();
	         }
	    }

		if( e.which != 42 &&  (e.which < 48 || e.which > 57 ) ){
			return false;
		}
		
	}
	return true;
}

//붙여넣기 금지
function fnPaste(){
	var regex = /\D/ig;
	if(regex.test(window.clipboardData.getData("Text"))){
		setTimeout('phoneSend(document.getElementById("makeCallNum").value)', 100);
		//return false;
	}else{
		return true;
	}
}

//로그인후 그룹정보정보체크
function checkGroupTimeOut(val1, val2, val3){
    if(document.getElementById("checkGroupValue").value == "Y"){
        callGroupSelect(val1, val2, val3);
        func_getAllTellerStatus();
        clearInterval(checkGroupInterval);
    }
}

// 사용안함
function checkGroupTimeOut2(){
    if(document.getElementById("checkGroupValue2").value == "Y"){
        func_getAllTellerStatus();
	}
}

//이미지버튼 나타내기
function showImgPhone(obj){
    document.getElementById(obj).style.display = "inline";
}

//이미지버튼 숨기기
function hiddenImgPhone(obj){
    document.getElementById(obj).style.display = "none";
}

//전화기상태이미지
function changePhoneState(state, stateStr){
    var ts = document.getElementById("tellerStatus");
    var stateCheckCount = 0;
    var stateCheckIdx = 0;
    for(var i=0; i<ts.length; i++){
        if( ts.options[i].value == state){
            stateCheckCount += stateCheckCount + 1;
            stateCheckIdx = i;
        }
    }

    if( stateCheckCount > 0 ){
        ts.options[stateCheckIdx].selected = true;
    }

    if(state=="0300"){//전화대기 - 걸기, 당겨받기
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");showImgPhone("search_pickup_o");
          hiddenImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0310"){//In 전화중 - 받기, 끊기
          hiddenImgPhone("search_call_o");showImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0311"){//In 연결 - 걸기, 끊기, 보류, 블라인드 호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0312"){//In 실패
          changePhoneStateNone();
    }else if(state=="0315"){//In 재연결 - 걸기, 끓기, 보류, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0320"){//호분배 시도 - 받기, 끊기
          hiddenImgPhone("search_call_o");showImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0321"){//호분배 연결 - 걸기, 끊기, 보류, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0322"){//호분배 실패 - X
          changePhoneStateNone();
    }else if(state=="0325"){//호분배재연결 - 걸기, 끊기, 보류, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0330"){//Out 시도 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0331"){//Out 연결 - 걸기, 끊기, 보류, 블라인드 호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0332"){//Out 실패
          changePhoneStateNone();
    }else if(state=="0335"){//Out 재연결 - 걸기, 끊기,보류, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0336"){//CTD 시도
          changePhoneStateNone();
    }else if(state=="0337"){//CTD 성공 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0338"){//CTD 실패
          changePhoneStateNone();
    }else if(state=="0342"){//B-TRNS 시도
          changePhoneStateNone();
    }else if(state=="0343"){//B-TRNS 실패
          changePhoneStateNone();
    }else if(state=="0345"){//B-TRNS 성공
          changePhoneStateNone();
    }else if(state=="0350"){//3자통화시도 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0351"){//3자통화성공
          changePhoneStateNone();
    }else if(state=="0352"){//3자IN통화중 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0353"){//3자OUT통화중 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0354"){//3자통화실패
          changePhoneStateNone();
    }else if(state=="0360"){//픽업시도 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0361"){//픽업대상
          changePhoneStateNone();
    }else if(state=="0362"){//픽업호분배
          changePhoneStateNone();
    }else if(state=="0363"){//픽업In
          changePhoneStateNone();
    }else if(state=="0365"){//픽업실패 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0371"){//HOLD In - 걸기, 끓기, 보류해제, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0372"){//HOLD Div - 걸기, 끊기, 보류해제, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0373"){//HOLD Out - 걸기, 끊기, 보류해제, 블라인드호전환
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");showImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0374"){//HOLD 종료
          changePhoneStateNone();
    }else if(state=="0375"){//HOLD 복귀
          changePhoneStateNone();
    }else if(state=="0376"){//HELD In - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0377"){//HELD Div
          changePhoneStateNone();
    }else if(state=="0378"){//HELD Out - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0380"){//HOut 시도 - 끊기
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
    }else if(state=="0381"){//HOut 연결 - 끊기, 보류, 보류해제, 모니터호전환, 3자통화
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          showImgPhone("search_mo_o");hiddenImgPhone("search_return_o");showImgPhone("search_3_o");
    }else if(state=="0382"){//HOut 실패
          changePhoneStateNone();
    }else if(state=="0383"){//H자동걸기
          changePhoneStateNone();
    }else if(state=="0386"){//H-CTD 시도
          changePhoneStateNone();
    }else if(state=="0387"){//H-CTD 성공
          changePhoneStateNone();
    }else if(state=="0388"){//H-CTD 실패
          changePhoneStateNone();
    }else if(state=="0391"){//호전환 시도
          changePhoneStateNone();
    }else if(state=="0392"){//호전환 성공
          changePhoneStateNone();
    }else if(state=="0393"){//호전환 실패
          changePhoneStateNone();
    }else if(state=="0401"){//보류 OUT 재연결
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          showImgPhone("search_mo_o");hiddenImgPhone("search_return_o");showImgPhone("search_3_o");
    }else if(state=="0402"){//보류 IN 재연결
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          showImgPhone("search_mo_o");hiddenImgPhone("search_return_o");showImgPhone("search_3_o");
    }else if(state=="0403"){//보류 호분배 재연결
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          showImgPhone("search_hung_o");showImgPhone("search_hold_o");showImgPhone("search_holdout_o");
          showImgPhone("search_mo_o");hiddenImgPhone("search_return_o");showImgPhone("search_3_o");
    }else{//연결안됨, 상담원 등록코드
          //changePhoneStateNone();
          //20101126 수정
          showImgPhone("search_call_o");hiddenImgPhone("search_get_o");showImgPhone("search_pickup_o");
          hiddenImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
          //20101126 수정
    }
}

//전화기상태이미지 안나타내기
function changePhoneStateNone(){
          hiddenImgPhone("search_call_o");hiddenImgPhone("search_get_o");hiddenImgPhone("search_pickup_o");
          hiddenImgPhone("search_hung_o");hiddenImgPhone("search_hold_o");hiddenImgPhone("search_holdout_o");
          hiddenImgPhone("search_mo_o");hiddenImgPhone("search_return_o");hiddenImgPhone("search_3_o");
}


/////////////////////////////////////////////////////////////////////모듈 함수 호출/////////////////////////////////////////////////////////////////////

// WebSocket Loading Check
function func_loadingCheck(){
	var rtn;
	rtn = false;
	try{
		/*
		readyState 
		0 - CONNECTING(접속 처리 중)
		1 - OPEN(접속 중)
		2 - CLOSING(연결 종료 중)
		3 - CLOSED(연결 종료 또는 연결 실패)
		*/		
		if(webSocket.readyState == "1"){
			rtn = true;
		}else{
			console.log("CTI서버와 접속되지 않았습니다. \n접속 후 사용하세요.");
			rtn = false;			
		}
	}catch(exception){
		console.log("CTI서버와 접속되지 않았습니다. \n접속 후 사용하세요.");
		rtn = false;
	}
}

//로그인
function func_login(id, password, extension) { 
	if(func_loadingCheck() == false){
		setTimeout ('loginGo()', 3000);
		return;
	}
	if(id == ""){
		console.log("아이디를 입력하세요.");
		return;
	}
	if(password == ""){
		console.log("비밀번호를 입력하세요.");
		return;
	}
	if(extension == ""){
		console.log("내선번호를 입력하세요.");
		return;
	}
	goWebSocketSendMsg("on^login^"+ id + "^" + password + "^" + extension);
}

//강제로그인
function func_forceLogin(id, password, extension){ 
	if(func_loadingCheck() == false){
		return;
	}
	if(id == ""){
		console.log("아이디를 입력하세요.");
		return;
	}
	if(password == ""){
		console.log("비밀번호를 입력하세요.");
		return;
	}
	if(extension == ""){
		console.log("내선번호를 입력하세요.");
		return;
	}
	goWebSocketSendMsg("on^forceLogin^"+ id + "^" + password + "^" + extension);
}

//로그아웃
function func_logout(){ 
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^logout");	
	console.log("로그아웃 되었습니다.");
}

//전화받기
function func_answer(){ 
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^answer");
}

//전화끊기
function func_hangup(){
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^hangup");
}

//비밀번호변경
function func_changePassword(newPassword) {
	if(func_loadingCheck() == false){
		return;
	}
	if(newPassword == ""){
		console.log("비밀번호를 입력하세요.");
		return;
	}
	goWebSocketSendMsg("on^changePassword^"+newPassword);
}

//전화걸기
function func_makeCall(cid, callNum, userData){
	if(func_loadingCheck() == false){
		return;
	}
	if(callNum == ""){
		console.log("전화번호를 입력하세요.");
		return;
	}
	goWebSocketSendMsg("on^makeCall^" + cid + "^" + callNum + "^" + userData);
}

//당겨받기
function func_pickup(){
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^pickup");	
}

//보류
function func_hold(){
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^hold");	
}

//보류해제
function func_unhold(){
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^unhold");	
}

//블라인드 호전환
function func_blindTransfer(callNum, userData){
	if(func_loadingCheck() == false){
		return;
	}
	if(callNum == ""){
		console.log("전화번호를 입력하세요.");
		return;
	}
	goWebSocketSendMsg("on^blindTransfer^" + callNum + "^" + userData);	
}

//모니터 호전환
function func_monitorTransfer(){
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^monitorTransfer");
}

//3자통화
function func_threeWayCall(){
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^threeWayCall"); 
}

//모든 상담원의 상태 요구
function func_getAllTellerStatus(){	
	if(func_loadingCheck() == false){
		return;
	}
	goWebSocketSendMsg("on^getAllTellerStatus");
}

//상담모드변경
function func_changeTellerMode(tellerMode){
	if(func_loadingCheck() == false){
		return;
	}
	if(tellerMode == ""){
		console.log("상담모드를 선택하세요.");
		return;
	}
	goWebSocketSendMsg("on^changeTellerMode^" + tellerMode);	// 0 - 인바운드, 1 - 아웃바운드
}

//상담원상태변경
function func_changeTellerStatus(tellerStatus){
	if(func_loadingCheck() == false){
		return;
	}
	if(tellerStatus == ""){
		console.log("상담원상태를 선택하세요.");
		return;
	}
	goWebSocketSendMsg("on^changeTellerStatus^" + tellerStatus);	// 0 - 인바운드, 1 - 아웃바운드
}

//소속그룹변경
function func_changeGroup(cGroup1, cGroup2, cGroup3){
    if(func_loadingCheck() == false){
	    return;
	}
    goWebSocketSendMsg("on^changeGroup^" + cGroup1 +"^" + cGroup2 + "^" + cGroup3 );
}

/////////////////////////////////////////////////////////////////////모듈 함수 호출/////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////웹소켓응답 에서 함수 호출/////////////////////////////////////////////////////////////////////
// 웹소켓응답메세지에서 호출시켜주는 메소드(함수명을 변경하지 마세요), msg 정의는 별첨(CTI Event.ppt) 파일을 참고하세요.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ctiEvent(msg){
    // 예) msg: 86^데이터1^데이터2^데이터3^데이터4^시간     <--- "86": 스크린팝업, "^": 파라미터 구분자
	var tmpData = msg.split("^");
	
	if(tmpData[0] == "00"){// 로그인 응답
		if(tmpData[4] == "1"){
			console.log("로그인되었습니다.");
	        //callGroupSelect(tmpData[6], tmpData[7], tmpData[8]);//소속그룹선택
            checkGroupInterval = setInterval("checkGroupTimeOut('"+tmpData[6]+"', '"+tmpData[7]+"', '"+tmpData[8]+"')", 1000);
		}else if(tmpData[4] == "2"){
			console.log("아이디가 존재하지 않습니다.");
		}else if(tmpData[4] == "3"){
			console.log("비밀번호가 일치하지 않습니다.");
		}else if(tmpData[4] == "4"){
			console.log("로그온이 중복되었습니다.");
			forceLoginGo();
		}else if(tmpData[4] == "5"){
			console.log("내선번호가 중복되었습니다.");
		}else if(tmpData[4] == "6"){
			console.log("등록이 안된 번호입니다.");
		}else if(tmpData[4] == "7") {
			console.log("상담원기본그룹 오류입니다.");
		}
    }else if(tmpData[0] == "01"){// 강제로그아웃(타 모듈에서 강제로그인 하면 기존의 모듈은 로그아웃 됨으로 기존 모듈에게 로그아웃 메시지 알림.)
    	console.log("강제로그아웃 되었습니다.");

		document.getElementById("status").innerHTML = "연결안됨";
		document.getElementById("transferTryCnt").innerHTML = "0";
		document.getElementById("transferConnectCnt").innerHTML = "0";
		document.getElementById("ibTryCnt").innerHTML = "0";
		document.getElementById("ibConnectCnt").innerHTML = "0";
		document.getElementById("obTryCnt").innerHTML = "0";
		document.getElementById("obConnectCnt").innerHTML = "0";
		document.getElementById("cti_waitting_cnt").innerHTML = "0";
	}else if(tmpData[0] == "02"){// 비밀번호변경 응답
		if(tmpData[4] == "1"){
			console.log("비밀번호가 변경되었습니다.");
		}else if(tmpData[4] == "2") {
			console.log("잘못된 아이디입니다.");
		}else if(tmpData[4] == "3") {
			console.log("잘못된 비밀번호입니다.");
		} 
    }else if(tmpData[0] == "24"){// 소속그룹변경
        if(tmpData[2] == 1){
            console.log("소속그룹이 변경되었습니다.");
            chagePhoneNumber();
        }else if(tmpData[2] == 2){
            console.log("실패");
        }
	}else if(tmpData[0] == "85"){// 상담원 모드 응답
		if(tmpData[1] == document.getElementById("cti_login_id").value){				// 받은 데이터가 로그인한 상담원의 아이디와 같은 경우
			if(tmpData[2] == "0"){
				//document.getElementById("responseMode").value = "인바운드";
			}else if(tmpData[2] == "1"){
				//document.getElementById("responseMode").value = "아웃바운드";
			}
		}
	}else if(tmpData[0] == "86"){// 스크린 팝업
		/*
				팝업타입
		 "01" : 호분배
		 "02" : 인바운드
		 "03" : 인바운드(돌려주기)
		 "04" : 아웃바운드
		 "05" : 오토콜
		 "06" : 당겨받기
		 "07" : 돌려받기
		 "08" : 3자통화


				팝업시점
		 "1" : Ring (팝업타입 "06", "07" 제외)
		 "2" : Answer
		*/
		
		/*
		console.log("[스크린팝업정보]\n팝업타입:" + tmpData[1] +  "\n팝업시점:" + tmpData[2] +  "\nA-1 대표번호:" + tmpData[3] + 
		      "\nA-2 발신자번호:"+ tmpData[4] + "\nA-3 IVR 연동데이터:"+ tmpData[5] + "\nA-4 CALL_ID:"+ tmpData[6] + 
		      "\nA-5 IVR메뉴번호:"+ tmpData[7] + "\nA-6 사용자데이터:"+ tmpData[8] + "\nA-7 녹취파일명:"+ tmpData[9] + 
		      "\nA-8 녹취폴더(녹취일):" + tmpData[10] + "\nB-1 대표번호:" + tmpData[11] + "\nB-2 발신자번호:" + tmpData[12] +
		      "\nB-3 IVR 연동데이터:" + tmpData[13] + "\nB-4 콜아이디:" + tmpData[14] + "\nB-5 IVR메뉴번호:" + tmpData[15] +
		      "\nB-6 사용자데이터:" + tmpData[16]);
*/
		document.getElementById("cti_screen_popup_01").innerHTML = tmpData[1];
		document.getElementById("cti_screen_popup_02").innerHTML = tmpData[2];
		document.getElementById("cti_screen_popup_03").innerHTML = tmpData[3];
		document.getElementById("cti_screen_popup_04").innerHTML = tmpData[4];
		document.getElementById("cti_screen_popup_05").innerHTML = tmpData[5];
		document.getElementById("cti_screen_popup_06").innerHTML = tmpData[6];
		document.getElementById("cti_screen_popup_07").innerHTML = tmpData[7];
		document.getElementById("cti_screen_popup_08").innerHTML = tmpData[8];
		document.getElementById("cti_screen_popup_09").innerHTML = tmpData[9];
		document.getElementById("cti_screen_popup_10").innerHTML = tmpData[10];
		document.getElementById("cti_screen_popup_11").innerHTML = tmpData[11];
		document.getElementById("cti_screen_popup_12").innerHTML = tmpData[12];
		document.getElementById("cti_screen_popup_13").innerHTML = tmpData[13];
		document.getElementById("cti_screen_popup_14").innerHTML = tmpData[14];
		document.getElementById("cti_screen_popup_15").innerHTML = tmpData[15];
		document.getElementById("cti_screen_popup_16").innerHTML = tmpData[16];

		//top.TopView.location.href = "./topFrame.html";
		
	}else if(tmpData[0] == "89"){// 상담원이 변경할 수 있는 상태정보 응답
		document.getElementById("tellerStatus").options.length = 0;
		for(var i=1; i < tmpData.length-1; i+=2) {
			var op = document.getElementById("tellerStatus");
			var addedOpt=document.createElement('OPTION');
			op.add(addedOpt);
			addedOpt.value = tmpData[i];
			addedOpt.text = tmpData[i+1];
		}
	}else if(tmpData[0] == "90"){// CTI 상태정보 응답
		var j = 0;
		statusCode = new Array((tmpData.length-2)/2);
		statusName = new Array((tmpData.length-2)/2);
		for(var i=1; i < tmpData.length-1; i+=2) {
			statusCode[j] = tmpData[i];
			statusName[j] = tmpData[i+1];
			j++;
		}
	}else if(tmpData[0] == "91"){// CTI에 등록된 그룹정보에 대한 응답
        //셀렉트박스 초기화
        var callGroup = document.getElementById("callGroup");
        var callGroupLength = document.getElementById("callGroup").options.length;
        var opts = callGroup.getElementsByTagName("option");

        if( callGroupLength > 0 ){// 그룹이 이미있으면 초기화
            //for(var k=0; k<= callGroupLength ; k++){
                //callGroup.options[k]= null;
            //}
            callGroup.innerHTML = "";
        }

		var j = 0;
        groupCode = new Array( tmpData.length-1 );//그룹배열
		groupCode1 = new Array(((tmpData.length-2)/5));//대그룹코드
		groupCode2 = new Array((tmpData.length-2)/5);//중그룹코드
		groupCode3 = new Array((tmpData.length-2)/5);//소그룹코드
		groupCode4 = new Array((tmpData.length-2)/5);//그룹명
		groupCode5 = new Array((tmpData.length-2)/5);//대표번호
		for(var i=1; i < tmpData.length-1; i+=5) {
			groupCode[j] = tmpData[i] + "-" + tmpData[i+1] + "-" + tmpData[i+2];
			groupCode1[j] = tmpData[i];
			groupCode2[j] = tmpData[i+1];
			groupCode3[j] = tmpData[i+2];
			groupCode4[j] = tmpData[i+3];
			groupCode5[j] = tmpData[i+4];
			var op1 = document.getElementById("callGroup");
			var addedOpt1 = document.createElement('OPTION');
			op1.add(addedOpt1);
			addedOpt1.value = groupCode5[j];
			//addedOpt1.text = tmpData[i+3];
            var splitText = tmpData[i+3].split("-");
			addedOpt1.text = splitText[2];//소그룹
			j++;
		}

		document.getElementById("checkGroupValue").value = "Y";//CTI에 등록된 그룹정보체크

	}else if(tmpData[0] == "93") {			/// 모든상담원상태 요구에 대한 응답
	}else if(tmpData[0] == "94"){// 상담원 상태 변경 
		if(tmpData[1] == document.getElementById("cti_login_id").value) {				// 받은 데이터가 로그인한 상담원의 아이디와 같은 경우
            if(document.getElementById("checkGroupValue2").value == "Y"){
				var callGroup = document.getElementById("callGroup");//소속그룹
				var outCallNum = document.getElementById("outCallNum");//발신표시번호
				var sIdx = callGroup.selectedIndex;
				var gCode = groupCode[sIdx].split("-");

				if(tmpData[8] != gCode[2]){
					for(var i=0; i< groupCode.length; i++){
						gCode2 = groupCode[i].split("-");
						if(tmpData[8] == gCode2[2]){
							callGroup.options[i].selected = true;
							chagePhoneNumber();
							break;
						}
					}
				}
			}

			for(var i=0; i < statusCode.length; i++) {
				if(statusCode[i] == tmpData[5]){
                    document.getElementById("status").innerHTML = statusName[i];
                    changePhoneState(tmpData[5], statusName[i]);//버튼이미지바꾸기
					break;
				}
			}

			document.getElementById("transferTryCnt").innerHTML =  tmpData[9];
			document.getElementById("transferConnectCnt").innerHTML =  tmpData[10];
			document.getElementById("ibTryCnt").innerHTML =  tmpData[11];
			document.getElementById("ibConnectCnt").innerHTML =  tmpData[12];
			document.getElementById("obTryCnt").innerHTML =  tmpData[13];
			document.getElementById("obConnectCnt").innerHTML =  tmpData[14];
		}
	}else if(tmpData[0] == "95"){// 고객대기자수 
		document.getElementById("cti_waitting_cnt").innerText =  tmpData[1];
    }else if(tmpData[0] == "96"){// 상담원 단말 상태 알림 전송
        if(tmpData[4] == "1"){//단말이 교환기에 등록 된 상태
            console.log("전화기가 등록이 되었습니다.\n 상태를 변경해주세요.");
            func_changeTellerStatus("R001");
        }else if(tmpData[4] == "2"){// 단말이 교환기에 미 등록된 상태
            console.log("전화기가 등록되지 않았습니다.");
        }
    } 
}
/////////////////////////////////////////////////////////////////////웹소켓응답 에서 함수 호출/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////웹소켓/////////////////////////////////////////////////////////////////////
//var webSocket;//웹소켓
var webSocket; 
function goWebSocket(serverIp, serverSocketIp, serverPort){
	webSocket = new WebSocket("ws://" + serverSocketIp + ":" + serverPort + "/websocket");//웹소켓생성	

	//웹소켓에 연결될때
	webSocket.onopen = function(event) {
		webSocket.send("on^init^"+ serverIp);
		onOpen(event)
	};

	//메세지가 왔을때 호출되는 메소드지정
	webSocket.onmessage = function(event) {
		onMessage(event)
	};
	
	//웹소켓에 오류날때
	webSocket.onerror = function(event) {
		onError(event)
	};
	
	//웹소켓연결이 끊겼을때
	webSocket.onclose = function(event){
		onClose(event)
	};  		
}

/* 웹소켓 함수 */
function onOpen(event) {
	document.getElementById('messages').value += "웹소켓 접속 연결\n";
}

function onMessage(event) {
	document.getElementById('messages').value += event.data + "\n";
	ctiEvent(event.data);
}

function onError(event) {
	document.getElementById('messages').value += '오류 : ' + event.data + "\n";	
}

function onClose(event){
	document.getElementById('messages').value += "웹소켓 접속 끊김\n";
}

//웹소켓에 메시지 보내기
function goWebSocketSendMsg(strMsg){
	webSocket.send(strMsg);	
}

//웹소켓 접속끊기
function goWebSocketDisconnect(){
	webSocket.close();
}

//자바스크립트오류메시지
window.onerror = function(msg, url, line){
	//console.log("Message : " + msg + "\n URL : " + url + "Line number : " + line);
}
/////////////////////////////////////////////////////////////////////웹소켓/////////////////////////////////////////////////////////////////////
	<%-- ■ CTI Function 끝 --%>
</script>
</head>
<body>
	<form name="PrintMemOrderform" action="" method="post"></form>
	<div id="div_erp_cti_table" class="samyang_div" style="display:none">
		<table id = "tb_search_01" class = "table">
			<colgroup>
				<col width="80px"/>
				<col width="120px"/>
				<col width="80px"/>
				<col width="500px"/>
				<col width="80px"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<th>CTI 여부</th>
				<td>
					${empSessionDto.member_CTI }
				</td>
				<th>ID</th>
				<td>
					<input type="text" name="cti_login_id" id="cti_login_id" value="${empSessionDto.member_warea_nm }">
					<input type="text" name="cti_login_pwd" id="cti_login_pwd" value="0000">
				</td>
				<th>내선번호</th>
				<td>
					<input type="text" name="cti_login_ext" id="cti_login_ext" value="${empSessionDto.member_InPhone }">
					<input type="hidden" name="checkGroupValue" id="checkGroupValue" value="N">
		 			<input type="hidden" name="checkGroupValue2" id="checkGroupValue2" value="N">
		 			<input type="button" value="로그인" onclick="loginGo();">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_main_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_main_search_table" class="samyang_div" style="display:none">
			<table class = "table">
				<colgroup>
					<col width="80px"/>
					<col width="120px"/>
					<col width="80px"/>
					<col width="120px"/>
					<col width="80px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th>조회일자</th>
					<td style="border-right: 1px solid transparent;">
						<div id="cmbSEARCH_TYPE"></div>
					</td>
					<td colspan="4">
						<input type="text" id="searchFromDate" name="searchFromDate" class="input_common input_calendar" style="margin-left:10px;" onkeydown="enterSearchToMainGrid(event.keyCode);">
						<span style="position: fixed;">~</span>
						<input type="text" id="searchToDate" name="searchToDate" class="input_common input_calendar" style="margin-left:10px;" onkeydown="enterSearchToMainGrid(event.keyCode);">
					</td>
				</tr>
				<tr>
					<th>검색어</th>
					<td colspan="5">
						<input type="text" id="searchText" name="searchText" class="input_common" style="width: 200px;" onkeydown="enterSearchToMainGrid(event.keyCode);">
					</td>
				</tr>
			</table>
		</div>
		<div id="div_erp_main_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_main_summary_table" class="samyang_div" style="display:none">
			<table class = "table">
				<colgroup>
					<col width="80px"/>
					<col width="30px"/>
					<col width="60px"/>
					<col width="30px"/>
					<col width="140px"/>
					<col width="30px"/>
					<col width="120px"/>
					<col width="30px"/>
					<col width="60px"/>
					<col width="30px"/>
					<col width="40px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th>최초주문접수</th>
					<td><span id="spanO1">0</span></td>
					<th>주문취소</th>
					<td><span id="spanO9">0</span></td>
					<th>주문접수완료(피킹필요)</th>
					<td><span id="spanO10">0</span></td>
					<th>피킹완료(배송출발)</th>
					<td><span id="spanD1">0</span></td>
					<th>배송완료</th>
					<td><span id="spanD10">0</span></td>
					<th>합계</th>
					<td><span id="spanTOT_CNT">0</span></td>
				</tr>
			</table>
		</div>
		<div id="div_erp_main_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	
	
	
	
	
	
	<div style="display: none;">
		<textarea id="messages" cols="150" rows="10"></textarea>
		<input type="button" value="로그초기화"
			onclick="javascript:document.getElementById('messages').value='';">
	</div>

	<div style="padding: 10px 0 0 10px; display: none;">
		<table style="width: 1186px" border="0" cellspacing="0"
			cellpadding="0">
			<tr>
				<td style="width: 555px; height: 36px" valign="top">
					<!-- CTI 전화 -->
					<table style="width: 550px" border="0" cellspacing="0"
						cellpadding="0">
						<tr>
							<td width="11px"><img
								src="/resources/cti/images/cti/search_left.gif" alt="" title=""></td>
							<td width="55px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x;"
								class="cti_text_bold">전화번호</td>
							<td width="13px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x;"><img
								src="/resources/cti/images/cti/search_line.gif" alt="" title=""></td>
							<td width="102px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 6px; vertical-align: top"><input
								name="makeCallNum" id="makeCallNum" type="text"
								style="width: 90px; ime-mode: disabled"
								onKeyPress="return CheckNumeric();" onPaste="return fnPaste();"
								class="cti_input"></td>
							<td width="358px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 7px; vertical-align: top"><img
								id="search_call_o"
								src="/resources/cti/images/cti/search_call_o.gif"
								onclick="javascript:didCheckMakeCall();" class="cti_call_img"
								alt="걸기" title="걸기"><img id="search_get_o"
								src="/resources/cti/images/cti/search_get_o.gif"
								onclick="javascript:func_answer();" class="cti_call_img"
								alt="받기" title="받기"><img id="search_pickup_o"
								src="/resources/cti/images/cti/search_pickup_o.gif"
								onclick="javascript:func_pickup();" class="cti_call_img"
								alt="당겨받기" title="당겨받기"><img id="search_hung_o"
								src="/resources/cti/images/cti/search_hung_o.gif"
								onclick="func_hangup();" class="cti_call_img" alt="끊기"
								title="끊기"><img id="search_hold_o"
								src="/resources/cti/images/cti/search_hold_o.gif"
								onclick="func_hold();" class="cti_call_img" alt="보류" title="보류"><img
								id="search_holdout_o"
								src="/resources/cti/images/cti/search_holdout_o.gif"
								onclick="func_unhold();" class="cti_call_img" alt="보류해제"
								title="보류해제"><img id="search_mo_o"
								src="/resources/cti/images/cti/search_mo_o.gif"
								onclick="func_monitorTransfer();" class="cti_call_img"
								alt="모니터호전환" title="모니터호전환"><img id="search_return_o"
								src="/resources/cti/images/cti/search_return_o.gif"
								onclick="func_blindTransfer(document.getElementById('makeCallNum').value, '');"
								class="cti_call_img" alt="블라인드호전환" title="블라인드호전환"><img
								id="search_3_o" src="/resources/cti/images/cti/search_3_o.gif"
								onclick="func_threeWayCall();" class="cti_call_img" alt="3자통화"
								title="3자통화"></td>
							<td width="11px"><img
								src="/resources/cti/images/cti/search_right.gif" alt="" title=""></td>
						</tr>
					</table> <!-- CTI 전화 -->
				</td>
				<td width="631px" valign="top">
					<!-- CTI 설정 -->
					<table width="626px" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="11px"><img
								src="/resources/cti/images/cti/search_left.gif" alt="" title=""></td>
							<td width="52px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x;"
								class="cti_text_bold">상태변경</td>
							<td width="13px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x;"><img
								src="/resources/cti/images/cti/search_line.gif" alt="" title=""></td>
							<td width="120px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 7px; vertical-align: top"><select
								name="tellerStatus" id="tellerStatus" style="width: 110px;"
								onchange="javascript:func_changeTellerStatus(this.value);"><option></option></select></td>
							<td width="80px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x;"
								class="cti_text_bold">소속그룹변경</td>
							<td width="13px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"><img
								src="/resources/cti/images/cti/search_line.gif" alt="" title=""></td>
							<td width="141px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 7px;"
								valign="top"><select name="callGroup" id="callGroup"
								style="width: 131px;" onchange="javascrpt:changeGroup();"><option></option></select></td>
							<td width="75px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x;"
								class="cti_text_bold">내번호사용</td>
							<td width="20px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x;"><input
								type="checkbox" class="check" id="did"
								onclick="javascript:didCheck();"></td>
							<td width="90px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x;"><input
								type="button" value="로그아웃" onclick="javascript:func_logout();"></td>
							<td width="11px"><img
								src="/resources/cti/images/cti/search_right.gif" alt="" title=""></td>
						</tr>
					</table> <!-- CTI 설정 -->
				</td>
			</tr>
		</table>

		<table width="1186px" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="761px" height="41px" valign="top">
					<!-- CTI 통계 -->
					<table width="756px" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="11px"><img
								src="/resources/cti/images/cti/search_left.gif" alt="" title=""></td>
							<td width="65px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x;"
								class="cti_text_bold">호분배시도</td>
							<td width="13px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"><img
								src="/resources/cti/images/cti/search_line.gif" alt="" title=""></td>
							<td width="31px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 6px;"><span
								id="transferTryCnt" class="cti_text_nomal">0</span></td>
							<td width="65px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"
								class="cti_text_bold">호분배연결</td>
							<td width="13px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"><img
								src="/resources/cti/images/cti/search_line.gif" alt="" title=""></td>
							<td width="31px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 6px;"><span
								id="transferConnectCnt" class="cti_text_nomal">0</span></td>
							<td width="78px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"
								class="cti_text_bold">인바운드시도</td>
							<td width="13px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"><img
								src="/resources/cti/images/cti/search_line.gif" alt="" title=""></td>
							<td width="31px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 6px;"><span
								id="ibTryCnt" class="cti_text_nomal">0</span></td>
							<td width="78px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"
								class="cti_text_bold">인바운드연결</td>
							<td width="13px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"><img
								src="/resources/cti/images/cti/search_line.gif" alt="" title=""></td>
							<td width="31px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 6px;"><span
								id="ibConnectCnt" class="cti_text_nomal">0</span></td>
							<td width="92px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"
								class="cti_text_bold">아웃바운드시도</td>
							<td width="13px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"><img
								src="/resources/cti/images/cti/search_line.gif" alt="" title=""></td>
							<td width="31px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 6px;"><span
								id="obTryCnt" class="cti_text_nomal">0</span></td>
							<td width="92px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"
								class="cti_text_bold">아웃바운드연결</td>
							<td width="13px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"><img
								src="/resources/cti/images/cti/search_line.gif" alt="" title=""></td>
							<td width="31px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 6px;"><span
								id="obConnectCnt" class="cti_text_nomal">0</span></td>
							<td width="11px"><img
								src="/resources/cti/images/cti/search_right.gif" alt="" title=""></td>
						</tr>
					</table> <!-- CTI 통계 -->
				</td>
				<td width="425px" valign="top">
					<!-- CTI 상태 -->
					<table width="420px" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="11px"><img
								src="/resources/cti/images/cti/search_left.gif" alt="" title=""></td>

							<td width="27px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x;"
								class="cti_text_bold">상태</td>
							<td width="13px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"><img
								src="/resources/cti/images/cti/search_line.gif" alt="" title=""></td>
							<td width="100px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 6px;"><span
								id="status" class="cti_text_nomal">연결안됨</span></td>

							<td width="78px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x;"
								class="cti_text_bold">발신표시번호</td>
							<td width="13px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"><img
								src="/resources/cti/images/cti/search_line.gif" alt="" title=""></td>
							<td width="82px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 6px;"><span
								id="outCallNum" class="cti_text_nomal"></span></td>

							<td width="52px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x;"
								class="cti_text_bold">고객대기</td>
							<td width="13px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x"><img
								src="/resources/cti/images/cti/search_line.gif" alt="" title=""></td>
							<td width="20px"
								style="background-image: url('/resources/cti/images/cti/search_bg.gif'); background-repeat: repeat-x; padding-top: 5px;"
								class="red_12"><span id="cti_waitting_cnt"
								class="cti_text_nomal">0</span></td>

							<td width="11px"><img
								src="/resources/cti/images/cti/search_right.gif" alt="" title=""></td>
						</tr>
					</table> <!-- CTI 상태 -->
				</td>
			</tr>
		</table>
	</div>

	<div style="display: none;">
		<table border="0">
			<tr>
				<td colspan="2">스크린팝업정보</td>
			</tr>
			<tr>
				<td>팝업타입</td>
				<td><span id="cti_screen_popup_01"></span></td>
			</tr>
			<tr>
				<td>팝업시점</td>
				<td><span id="cti_screen_popup_02"></span></td>
			</tr>
			<tr>
				<td>대표번호</td>
				<td><span id="cti_screen_popup_03"></span></td>
			</tr>
			<tr>
				<td>발신자번호</td>
				<td><span id="cti_screen_popup_04"></span></td>
			</tr>
			<tr>
				<td>IVR 연동데이터</td>
				<td><span id="cti_screen_popup_05"></span></td>
			</tr>
			<tr>
				<td>CALL_ID</td>
				<td><span id="cti_screen_popup_06"></span></td>
			</tr>
			<tr>
				<td>IVR메뉴번호</td>
				<td><span id="cti_screen_popup_07"></span></td>
			</tr>
			<tr>
				<td>사용자데이터</td>
				<td><span id="cti_screen_popup_08"></span></td>
			</tr>
			<tr>
				<td>녹취파일명</td>
				<td><span id="cti_screen_popup_09"></span></td>
			</tr>
			<tr>
				<td>녹취폴더(녹취일)</td>
				<td><span id="cti_screen_popup_10"></span></td>
			</tr>
			<tr>
				<td>대표번호</td>
				<td><span id="cti_screen_popup_11"></span></td>
			</tr>
			<tr>
				<td>발신자번호</td>
				<td><span id="cti_screen_popup_12"></span></td>
			</tr>
			<tr>
				<td>IVR 연동데이터</td>
				<td><span id="cti_screen_popup_13"></span></td>
			</tr>
			<tr>
				<td>CALL_ID</td>
				<td><span id="cti_screen_popup_14"></span></td>
			</tr>
			<tr>
				<td>IVR메뉴번호</td>
				<td><span id="cti_screen_popup_15"></span></td>
			</tr>
			<tr>
				<td>사용자데이터</td>
				<td><span id="cti_screen_popup_16"></span></td>
			</tr>
		</table>
	</div>
</body>
</html>