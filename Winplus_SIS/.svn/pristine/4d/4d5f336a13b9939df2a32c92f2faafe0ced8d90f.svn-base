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
	■ thisPopupWindow : 현재 팝업 윈도우
	■ total_layout : 전체 페이지 레이아웃 
	
	--%>
	var thisPopupWindow = parent.erpPopupWindows.window('openMemberPopup');
	
	var param_MEM_NO = "${param.MEM_NO}";
	
	var total_layout;
	
	$(document).ready(function(){
		if(thisPopupWindow){
			thisPopupWindow.setText("${screenDto.scrin_nm}");	
			//thisPopupWindow.denyResize();
			//thisPopupWindow.denyMove();
		}
		
		init_total_layout();
		init_tabBar();
		init_tab_1();
		
		if(param_MEM_NO){
			getMemberInfo(param_MEM_NO);
		}
		
		init_tab_2();
		init_tab_3();
		init_tab_4();
		init_tab_5();
		init_tab_6();
		
		
	});
	
	<%-- ■ 전체 layout 초기화 시작 --%>
	function init_total_layout() {
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
				, cells: [
				          {id: "a", text: "", header:false, fix_size:[true, false]}
				          ]		
		});
		
		total_layout.cells("a").attachObject("div_tabBar");
		
	}
	<%-- ■ 전체 layout 초기화 끝 --%>
	
	<%-- ■ tab_bar 초기화 시작 --%>
	function init_tabBar(){
		tabBar = new dhtmlXTabBar({
			parent : "div_tabBar"
			, skin : ERP_TABBAR_CURRENT_SKINS
			, close_button : false
			, tabs : [
			          {id: "tab_1", text: "회원정보", active: 1},
			          {id: "tab_2", text: "거래내역"},
			          {id: "tab_3", text: "베스트상품"},
			          {id: "tab_4", text: "월별추이"},
			          {id: "tab_5", text: "회원지정가"},
			          {id: "tab_6", text: "변경로그"}
			          ]
		}); 
		
		tabBar.tabs("tab_1").attachObject("div_tab_1");
		tabBar.tabs("tab_2").attachObject("div_tab_2");
		tabBar.tabs("tab_3").attachObject("div_tab_3");
		tabBar.tabs("tab_4").attachObject("div_tab_4");
		tabBar.tabs("tab_5").attachObject("div_tab_5");
		tabBar.tabs("tab_6").attachObject("div_tab_6");
		
		//tabBar.showInnerScroll();
		tabBar.captureEventOnParentResize(total_layout);
		
	}
	<%-- ■ tab_bar 초기화 끝 --%>
	
	
	<%-- ■ tab_1 초기화  시작 --%>
	function init_tab_1() {
		tab_1 = new dhtmlXLayoutObject({
			parent: "div_tab_1"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4E"
			, cells: [
				{id: "a", text: "", header:false, fix_size:[true, true]},
				{id: "b", text: "", header:false, fix_size:[true, true]},
				{id: "c", text: "", header:false, fix_size:[true, true]},
				{id: "d", text: "", header:false}
			]
		})
		tab_1.registTab(tabBar); //삭제하면 텝선택시 리사이즈가 작동하지 않습니다.
		tab_1.captureEventOnParentResize(tabBar); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.
		
		tab_1.cells("a").attachObject("div_tab_1_table_1");
		tab_1.cells("a").setHeight($erp.getTableHeight(2));
		tab_1.cells("b").attachObject("div_tab_1_table_2");
		tab_1.cells("b").setHeight($erp.getTableHeight(5));
		tab_1.cells("c").attachObject("div_tab_1_table_3");
		tab_1.cells("c").setHeight($erp.getTableHeight(8));
		tab_1.cells("d").attachObject("div_tab_1_table_4");
		
		tab_1.setSeparatorSize(0, 2);
		tab_1.setSeparatorSize(1, 2);
		tab_1.setSeparatorSize(2, 2);
		
		//1
		chkMEM_STATE = $erp.getDhtmlXCheckBox('chkMEM_STATE', '유효', '1', false, 'label-right');
		chkMEM_STATE.attachEvent("onChange",function(id){
			if(chkMEM_STATE.isItemChecked(id) == true){
				$erp.objReadonly("cmbMEM_GRADE");
			}else{
				$erp.objNotReadonly("cmbMEM_GRADE");
			}
		});
		
		cmbMEM_GRADE = $erp.getDhtmlXComboCommonCode("cmbMEM_GRADE", "MEM_GRADE", "MEM_GRADE", 74, null, false, "");
		cmbMK_CD = $erp.getDhtmlXComboCommonCode("cmbMK_CD", "MK_CD", "MK_CD", 80, null, false, "1428");
		
		cmbCORP_TYPE = $erp.getDhtmlXComboCommonCode("cmbCORP_TYPE", "CORP_TYPE", "MEM_TYPE", 130, null, false, "0"); //CORP_TYPE = MEM_TYPE 같음 테이블 컬럼명이 다름
		cmbPRICE_POLI = $erp.getDhtmlXComboCommonCode("cmbPRICE_POLI", "PRICE_POLI", "PRICE_POLI", 74, null, false, "PP1");
		cmbMEM_ABC_CD = $erp.getDhtmlXComboCommonCode("cmbMEM_ABC_CD", "MEM_ABC_CD", "MEM_ABC_CD", 133, null, false, "D");
		
		//id, name, width, 텍스트, 콜백
		cmbGRUP_CD = $erp.getDhtmlXEmptyCombo("cmbGRUP_CD", "GRUP_CD", 133, "-그룹-",function(){
			var url = "/sis/member/getMemberGroupComboList.do";
			var send_data = {};
			var if_success = function(data){
				total_layout.progressOff();
				if($erp.isEmpty(data.comboList)){
					//검색 결과 없음
				}else{
					//필수 기본키 text,value  추가로 커스텀 key:value 등록 가능
					cmbGRUP_CD.setCombo(data.comboList);
				}
			}
			
			var if_error = function(){
				total_layout.progressOff();
			}
			
			total_layout.progressOn();
			
			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error);			
		});



		
		//2
		rdoSEX_TYPE = $erp.getDhtmlXRadioCommonCode("rdoSEX_TYPE", "SEX_TYPE", "SEX_TYPE", 0 , false, "Y");
		
		chkBIRTH_TYPE = $erp.getDhtmlXCheckBox('chkBIRTH_TYPE', '양력', '1', false, 'label-right');
		chkBIRTH_TYPE.attachEvent("onChange",function(id){
			if(chk.isItemChecked(id) == true){
				
			}else{
				
			}
		});	
		
		chkSMS_STATE = $erp.getDhtmlXCheckBox('chkSMS_STATE', 'SMS 수신거부', '1', false, 'label-right');
		chkAPPLY_CASH_STATE = $erp.getDhtmlXCheckBox('chkAPPLY_CASH_STATE', '', '1', false, 'label-right');
		chkAPPLY_CASH_STATE.attachEvent("onChange",function(id){
			if(chkAPPLY_CASH_STATE.isItemChecked(id) == true){
				
			}else{
				
			}
		});	
		cmbSMALL_MONEY_POINT = $erp.getDhtmlXComboCommonCode("cmbSMALL_MONEY_POINT", "SMALL_MONEY_POINT", "SMALL_MONEY_POINT", 130, null, false, "");
	
		cmbAPPLY_CASH_TYPE = $erp.getDhtmlXComboCommonCode("cmbAPPLY_CASH_TYPE", "APPLY_CASH_TYPE", "APPLY_CASH_TYPE", 100, null, false, "");
		
		//사업자 : 1, 개인 : 0
		cmbLAST_CASH_TYPE = $erp.getDhtmlXComboCommonCode("cmbLAST_CASH_TYPE", "LAST_CASH_TYPE", "LAST_CASH_TYPE", 70, null, false, "");
		
		//3
		chkTRUST_YN = $erp.getDhtmlXCheckBox('chkTRUST_YN', '외상거래허용', '1', false, 'label-left');
		chkTRUST_YN.attachEvent("onChange",function(id){
			if(chkTRUST_YN.isItemChecked(id) == true){
				
			}else{
				
			}
		});	
		
		chkTAX_TYPE = $erp.getDhtmlXCheckBox('chkTAX_TYPE', '세금계산서발행', '1', false, 'label-left');
		chkTAX_TYPE.attachEvent("onChange",function(id){
			if(chkTAX_TYPE.isItemChecked(id) == true){
				
			}else{
				
			}
		});	
		
		cmbTRUST_EOD = $erp.getDhtmlXComboCommonCode("cmbTRUST_EOD", "TRUST_EOD", "DAY", 100, null, false, "01");
		
		
	}
	<%-- ■ tab_1 초기화  끝  --%>
	
	<%-- ■ tab_2 초기화  시작 --%>
	function init_tab_2() {
		tab_2 = new dhtmlXLayoutObject({
			parent: "div_tab_2"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, fix_size:[true, true]},
				{id: "b", text: "", header:false, fix_size:[true, true]},
				{id: "c", text: "", header:false}
			]
		});
		tab_2.registTab(tabBar); //삭제하면 텝선택시 리사이즈가 작동하지 않습니다.
		tab_2.captureEventOnParentResize(tabBar); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.
		
		tab_2.cells("a").attachObject("div_tab_2_table");
		tab_2.cells("a").setHeight($erp.getTableHeight(1));
		tab_2.cells("b").attachObject("div_tab_2_ribbon");
		tab_2.cells("b").setHeight(36);
		tab_2.cells("c").attachObject("div_tab_2_grid");
		
		tab_2.setSeparatorSize(0, 1);
		tab_2.setSeparatorSize(1, 1);
		
		chkTAX_SHOW = $erp.getDhtmlXCheckBox('chkTAX_SHOW', '과면세금액보기', '1', false, 'label-right');
		chkTAX_SHOW.attachEvent("onChange",function(id){
			if(chkTAX_SHOW.isItemChecked(id) == true){
				document.getElementById("div_tab_2_grid_1").style.display = "none";
				document.getElementById("div_tab_2_grid_2").style.display = "block";
			}else{
				document.getElementById("div_tab_2_grid_1").style.display = "block";
				document.getElementById("div_tab_2_grid_2").style.display = "none";
			}
		});	
		
		tab_2_ribbon = new dhtmlXRibbon({
			parent : "div_tab_2_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
				           {type : "block"
				        	   , mode : 'rows'
				        		   , list : [
				        		             {id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
				        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
				        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true, unused : true}		
				        		             ]
				           }							
				           ]
		});
		
		tab_2_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				$("#div_tab_2_grid").children().each(function(index, obj){
					var display = obj.style.display; 
					if(display == "block"){
						var id = obj.id;
// 						console.log("id : " + id);
// 						console.log(tab_2_grid[id]);
						var url = obj.getAttribute("data-url");
						var dataObj = $erp.dataSerialize("tab_2_table", null, true);
						
						var if_success = function(data){
							if($erp.isEmpty(data.gridDataList)){
								//검색 결과 없음
								$erp.addDhtmlXGridNoDataPrintRow(tab_2_grid[id], '<spring:message code="info.common.noDataSearch" />');
							}else{
								tab_2_grid[id].parse(data.gridDataList,'js');
							}
							$erp.setDhtmlXGridFooterRowCount(tab_2_grid[id]); // 현재 행수 계산
						}
						
						var if_error = function(){
							$erp.alertMessage({
  	  							"alertMessage" : "조회실패",
  	  							"alertCode" : null,
  	  							"alertType" : "error",
  	  							"isAjax" : false
  	  						});
						}
						
						$erp.UseAjaxRequestInBody(url, dataObj, if_success, if_error, total_layout);
						return false; //loop 종료
					}
				});
			} else if (itemId == "excel_grid"){
				
			} else if (itemId == "print_grid"){
				
			}
		});
		
		//dhtmlx 그리드 객체 담을 오브젝트
		tab_2_grid = {};
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns_1 = [
		                    {id : "NO", 			label:["NO"], 			type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "SALE_TYPE", 	label:["구분"], 			type: "combo", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false, commonCode : "SALES_TYPE"}
		                    , {id : "POS_NO", 		label:["단말"], 			type: "ron", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "EMP_NO", 		label:["계산원"], 			type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "ORD_DATE", 		label:["거래시각"], 		type: "dhxCalendarA", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "SALE_TOT_AMT", label:["거래액"], 	type: "ron", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_CASH", 	label:["현금"], 			type: "ron", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_CARD", 	label:["카드"], 			type: "ron", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_GIFT", 	label:["상품권"], 			type: "ron", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_POINT", 	label:["포인트"], 			type: "ron", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_TRUST", 	label:["외상"], 			type: "ron", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "ADD_POINT",	label:["포인트추가"], 		type: "ron", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    ];
		
		tab_2_grid_1 = new dhtmlXGridObject({
			parent: "div_tab_2_grid_1"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns_1
		});
		$erp.initGrid(tab_2_grid_1);
		tab_2_grid["div_tab_2_grid_1"] = tab_2_grid_1;
		
		document.getElementById("div_tab_2_grid_1").style.display = "block"; //초기값 첫번째 그리드 표시
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns_2 = [
		                    {id : "NO"					, label:["NO"]		, type : "cntr",	width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "SALES_TYPE"		, label:["구분"]		, type: "combo", 	width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false, commonCode : "SALES_TYPE"}
		                    , {id : "TAX_AMT"			, label:["과세"]		, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "TAX_AMT_TARGET"	, label:["과세(대상)"]	, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "TAX_AMT_PUBLISH"	, label:["과세발행"]	, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "VAT_AMT"			, label:["부가세"]		, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "TAX_FREE_AMT"		, label:["면세"]		, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "TAX_FREE_PUBLISH"	, label:["면세발행"]	, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    ];
		
		tab_2_grid_2 = new dhtmlXGridObject({
			parent: "div_tab_2_grid_2"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns_2
		});
		$erp.initGrid(tab_2_grid_2);
		tab_2_grid["div_tab_2_grid_2"] = tab_2_grid_2;
		
	}
	<%-- ■ tab_2 초기화  끝 --%>
	
	<%-- ■ tab_3 초기화 시작 --%>
	function init_tab_3() {
		tab_3 = new dhtmlXLayoutObject({
			parent: "div_tab_3"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
			          {id: "a", text: "", header:false, fix_size:[true, true]},
			          {id: "b", text: "", header:false, fix_size:[true, true]},
			          {id: "c", text: "", header:false}
			          ]
		});
		tab_3.registTab(tabBar); //삭제하면 텝선택시 리사이즈가 작동하지 않습니다.
		tab_3.captureEventOnParentResize(tabBar); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.
		
		tab_3.cells("a").attachObject("div_tab_3_table");
		tab_3.cells("a").setHeight($erp.getTableHeight(1));
		tab_3.cells("b").attachObject("div_tab_3_ribbon");
 		tab_3.cells("b").setHeight(36);
		tab_3.cells("c").attachObject("div_tab_3_grid");
		
		tab_3.setSeparatorSize(0, 1);
		tab_3.setSeparatorSize(1, 1);
		
		//id, name, commonCode, checkPosition, showCode, useYn, cb, labelPosition, direction
		rdoORDER_BY = $erp.getDhtmlXRadioCommonCode("rdoORDER_BY", "ORDER_BY", ["ORDER_BY","BEST_GOODS"], 0 , false, "Y");
		
		chkTOP_COUNT_TAB_3 = $erp.getDhtmlXCheckBox('chkTOP_COUNT_TAB_3', '상위', '1', false, 'label-right');
		chkTOP_COUNT_TAB_3.attachEvent("onChange",function(id){
			if(chk.isItemChecked(id) == true){
				
			}else{
				
			}
		});
		
		tab_3_ribbon = new dhtmlXRibbon({
			parent : "div_tab_3_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
				           {type : "block"
				        	   , mode : 'rows'
				        		   , list : [
				        		             {id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
				        		             , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
				        		             , {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
				        		             , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
				        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
				        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true, unused : true}		
				        		             ]
				           }							
				           ]
		});
		
		tab_3_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				
			} else if (itemId == "add_grid"){
				var uid = tab_3_grid.uid();
				tab_3_grid.addRow(uid);
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				
			} else if (itemId == "print_grid"){
				
			}
		});
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
		                    {id : "NO", 				label:["NO"]	, type : "cntr", 	width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "GOODS_NANE", 		label:["상품명"]	, type: "ron", 		width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "BARCODE", 			label:["바코드"]	, type: "ron", 		width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "DIMENSION", 		label:["규격"]	, type: "ron", 		width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PRICE", 			label:["금액"]	, type: "ron", 		width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "QTY", 				label:["수량"]	, type: "ron", 		width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "CNT", 				label:["횟수"]	, type: "ron", 		width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "TERM", 			label:["주기"]	, type: "ron", 		width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "ONE_TIME_PRICE",	label:["1회금액"]	, type: "ron", 		width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "ONE_TIME_QTY", 	label:["1회수량"]	, type: "ron", 		width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    ];
		
		tab_3_grid = new dhtmlXGridObject({
			parent: "div_tab_3_grid"			
				, skin : ERP_GRID_CURRENT_SKINS 
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		
		$erp.initGrid(tab_3_grid);
		
	}
	<%-- ■ tab_3 초기화 끝 --%>
	
	<%-- ■ tab_4 초기화 시작 --%>
	function init_tab_4() {
		tab_4 = new dhtmlXLayoutObject({
			parent: "div_tab_4"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4E"
			, cells: [
			          {id: "a", text: "", header:false, fix_size:[true, true]},
			          {id: "b", text: "", header:false, fix_size:[true, true]},
			          {id: "c", text: "", header:false, fix_size:[true, true]},
			          {id: "d", text: "", header:false}
			          ]
		});
		
		tab_4.registTab(tabBar); //삭제하면 텝선택시 리사이즈가 작동하지 않습니다.
		tab_4.captureEventOnParentResize(tabBar); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.
		
		tab_4.cells("a").attachObject("div_tab_4_table_1");
		tab_4.cells("a").setHeight($erp.getTableHeight(1));
		tab_4.cells("b").attachObject("div_tab_4_ribbon");
		tab_4.cells("b").setHeight(36);
		tab_4.cells("c").attachObject("div_tab_4_table_2");
		tab_4.cells("c").setHeight($erp.getTableHeight(4));
		tab_4.cells("d").attachObject("div_tab_4_grid");
		
		tab_4.setSeparatorSize(0, 1);
		tab_4.setSeparatorSize(1, 1);
		tab_4.setSeparatorSize(2, 1);
		
		tab_4_ribbon = new dhtmlXRibbon({
			parent : "div_tab_4_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
				           {type : "block"
				        	   , mode : 'rows'
				        		   , list : [
				        		             {id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
				        		             , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
				        		             , {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
				        		             , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 	isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
				        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
				        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true, unused : true}		
				        		             ]
				           }							
				           ]
		});
		
		tab_4_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				
			} else if (itemId == "add_grid"){
				var uid = tab_4_grid.uid();
				tab_4_grid.addRow(uid);
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				
			} else if (itemId == "print_grid"){
				
			}
		});
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
		                    {id : "NO", 			label:["NO"]	, type: "cntr", 	width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "GROUP_DATE", 	label:["년/월"]	, type: "ron", 		width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "MEM_GRADE", label:["등급"]	, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "CASH", 		label:["현금"]	, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "CARD", 		label:["카드"]	, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "GIFT_CARD", 	label:["상품권"]	, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "VISIT_COUNT", 	label:["방문수"]	, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "CONTB", 		label:["기여도"]	, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "POINT_SAVE", 	label:["포인트적립"]	, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    ];
		
		tab_4_grid = new dhtmlXGridObject({
			parent: "div_tab_4_grid"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});

		$erp.initGrid(tab_4_grid);
		
	}
	<%-- ■ tab_4 초기화 끝 --%>
	
	<%-- ■ tab_5 초기화 시작 --%>
	function init_tab_5() {
		tab_5 = new dhtmlXLayoutObject({
			parent: "div_tab_5"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
			          {id: "a", text: "", header:false, fix_size:[true, true]},
			          {id: "b", text: "", header:false, fix_size:[true, true]},
			          {id: "c", text: "", header:false}
			          ]
		});
		
		tab_5.registTab(tabBar); //삭제하면 텝선택시 리사이즈가 작동하지 않습니다.
		tab_5.captureEventOnParentResize(tabBar); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.
		
		tab_5.cells("a").attachObject("div_tab_5_table");
		tab_5.cells("a").setHeight($erp.getTableHeight(1));
		tab_5.cells("b").attachObject("div_tab_5_ribbon");
		tab_5.cells("b").setHeight(36);
		tab_5.cells("c").attachObject("div_tab_5_grid");
		
		tab_5.setSeparatorSize(0, 1);
		tab_5.setSeparatorSize(1, 1);
		
		tab_5_ribbon = new dhtmlXRibbon({
			parent : "div_tab_5_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
				           {type : "block"
			        	   , mode : 'rows'
		        		   , list : [
		        		             {id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
		        		             , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
		        		             , {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
		        		             , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
		        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
		        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true, unused : true}		
		        		             ]
				           }							
				           ]
		});
		
		tab_5_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				
			} else if (itemId == "add_grid"){
				var uid = tab_5_grid.uid();
				tab_5_grid.addRow(uid);
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				
			} else if (itemId == "print_grid"){
				
			}
		});
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
		                    {id : "NO", 			label:["NO"], 		type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "GOODS_NAME", 	label:["상품명"], 		type: "ron", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "DIMENSION", 	label:["규격"], 		type: "ron", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "VARCODE", 		label:["바코드"], 		type: "ron", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PURCHASE_AMT", label:["매입가"], 		type: "ron", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "", 			label:["소매가"], 		type: "ron", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "WSALE_AAMT", 	label:["도매가"], 		type: "ron", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "SALE_TYPE", 	label:["판매방식"], 	type: "ron", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PROF_RATE", 	label:["마진율"], 		type: "ron", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "SALE_AMT", 	label:["판매가"], 		type: "ron", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "CDATE", 		label:["등록일"], 		type: "ron", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "MDATE", 		label:["수정일"], 		type: "ron", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    
		                    ];
		
		tab_5_grid = new dhtmlXGridObject({
			parent: "div_tab_5_grid"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		
		$erp.initGrid(tab_5_grid);
		
	}
	<%-- ■ tab_5 초기화 끝 --%>
	
	<%-- ■ tab_6 초기화 시작 --%>
	function init_tab_6() {
		tab_6 = new dhtmlXLayoutObject({
			parent: "div_tab_6"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
			          {id: "a", text: "", header:false, fix_size:[true, true]},
			          {id: "b", text: "", header:false, fix_size:[true, true]},
			          {id: "c", text: "", header:false}
			          ]
		});
		
		tab_6.registTab(tabBar); //삭제하면 텝선택시 리사이즈가 작동하지 않습니다.
		tab_6.captureEventOnParentResize(tabBar); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.
		
		tab_6.cells("a").attachObject("div_tab_6_table");
		tab_6.cells("a").setHeight($erp.getTableHeight(1));
		tab_6.cells("b").attachObject("div_tab_6_ribbon");
		tab_6.cells("b").setHeight(36);
		tab_6.cells("c").attachObject("div_tab_6_grid");
		
		tab_6.setSeparatorSize(0, 1);
		tab_6.setSeparatorSize(1, 1);
		
		cmbTOTAL_LOG_TYPE = $erp.getDhtmlXComboCommonCode("cmbTOTAL_LOG_TYPE", "TOTAL_LOG_TYPE", "TOTAL_LOG_TYPE", 100, "----- 전체  -----", false, "");
		
		tab_6_ribbon = new dhtmlXRibbon({
			parent : "div_tab_6_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
				           {type : "block"
			        	   , mode : 'rows'
		        		   , list : [
		        		             {id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
		        		             , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
		        		             , {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
		        		             , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
		        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
		        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true, unused : true}		
		        		             ]
				           }							
				           ]
		});
		
		tab_6_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				
			} else if (itemId == "add_grid"){
				var uid = tab_6_grid.uid();
				tab_6_grid.addRow(uid);
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				
			} else if (itemId == "print_grid"){
				
			}
		});
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
		                    {id : "NO", 				label:["NO"], 		type: "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "CHANGE_CONTENT", 	label:["변경내용"], 	type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "CHANGE_BEFORE", 	label:["변경전"], 		type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "CHANGE_AFTER", 	label:["변경후"], 		type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "MDATE", 			label:["변경일시"], 	type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "MUSER", 			label:["변경인"], 		type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
		                    ];
		
		tab_6_grid = new dhtmlXGridObject({
			parent: "div_tab_6_grid"
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : grid_Columns
		});
		
		$erp.initGrid(tab_6_grid);
		
	}
	<%-- ■ tab_6 초기화 끝 --%>
	
	function getMemberInfo(MEM_NO){
		var url = "/sis/member/getMemberInfo.do";
		var send_data = {"MEM_NO" : MEM_NO};
		var if_success = function(data){
			total_layout.progressOff();
			if($erp.isEmpty(data.dataMap)){
				
			}else{
				$erp.dataAutoBind("div_tab_1", data.dataMap);
			}
		}
		
		var if_error = function(){
			total_layout.progressOff();
		}
		total_layout.progressOn();
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error);
	}
	
	function openSearchPostAddrPopup(domObj){	 
		var onComplete = function(data){
			var postAddrMap = $erp.getPostAddrMap(data);
			var ZIP_NO = postAddrMap.new_zip;
			var LOT_ADDRESS = postAddrMap.old_addr;	//지번주소
			var ROAD_ADDRESS = postAddrMap.new_addr;//도로명주소
			console.log(domObj);
			if(domObj.id == "table_3_ZIP_NO"){
				document.getElementById("txtCORP_ZIP_NO").value = ZIP_NO;
				document.getElementById("txtCORP_S_ADDR").value = ROAD_ADDRESS;
				document.getElementById("txtCORP_H_ADDR").value = LOT_ADDRESS;
				
				document.getElementById("txtCORP_ADDR_DETL").focus();
				
			}else if(domObj.id == "table_4_ZIP_NO"){
				document.getElementById("txtDELI_ZIP_NO").value = ZIP_NO;
				document.getElementById("txtDELI_ADDR").value = ROAD_ADDRESS;
				
				document.getElementById("txtDELI_ADDR_DETL").focus();
			}
			
			$erp.closePopup2('ERP_POST_WIN_ID');		
		}
		$erp.openSearchPostAddrPopup2(onComplete, {win_id : "ERP_POST_WIN_ID"});
	}
	
	function crudMemberInfo(){
		var url = "/sis/member/crudMemberInfo.do";
		var send_data = $erp.dataSerialize("div_tab_1", null, true);
		
		send_data = $erp.unionObjArray([send_data,{"MEM_NO" : param_MEM_NO}]);
		
		console.log(send_data);
		
		var if_success = function(data){
			total_layout.progressOff();
			if($erp.isEmpty(data.result)){
				
			}else{
				if(data.result == 1){
					$erp.alertMessage({
						"alertMessage" : 'info.common.saveSuccess',
						"alertType" : "alert",
						"isAjax" : true
					});
				}else{
					$erp.alertMessage({
						"alertMessage" : 'info.common.errorsaveSuccess',
						"alertType" : "alert",
						"isAjax" : true
					});
				}
			}
		}
		
		var if_error = function(){
			total_layout.progressOff();
		}
		
		total_layout.progressOn();
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error);
	}
	
</script>
</head>
<body>
	
	<div id="div_tabBar" class="samyang_div" style="display: none;">
		<div id="div_tab_1" class="samyang_div" style="display: none;">
			<div id="div_tab_1_table_1" class="samyang_div" style="display: none;">
				<table id="tab_1_table_1" class="table">
					<colgroup>
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="80px">
						<col width="60px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="*">
					</colgroup>
					<tr>
						<th align="center"><input type="button" id="" class="input_common_button" value="바코드" onClick="" style="width:100%"/></th>
						<td colspan="2" style="border-left: 0px;"><input type="text" id="txtBCD_MEM_CD" class="input_text" /></td>
						
						<th><div id="chkMEM_STATE" style="float:right;"></div></th>
						<td colspan="1"><div id="cmbMEM_GRADE"></div></td>
<!--삭제예정 						<th align="center" style="border-left: 0px;"><input type="button" id="btnMEM_GRADE" class="input_common_button" value="등급" onClick="" style="width:100%"/></th> -->
<!--삭제예정 						<td colspan="2" style="border-left: 0px;"><input type="text" id="txtMEM_GRADE" class="input_text" readonly ></td> -->
						
						<th align="center"><input type="button" id="" class="input_common_button" value="담당직원" onClick="" style="width:100%"/></th>
						<td colspan="4" style="border-left: 0px;">
							<div id="cmbMK_CD" style="float: left"></div>
							<input type="text" id="txtRESP_USER" class="input_text input_readonly" readonly style="width: 133px; float: left;"/>
						</td>
						
					</tr>
					
					<tr>
						<th>회원유형</th>
						<td colspan="2"><div id="cmbCORP_TYPE"></div></td>
						
						<th>도매등급</th>
						<td colspan="1"><div id="cmbPRICE_POLI"></div></td>
						
						<th>ABC</th>
						<td colspan="2"><div id="cmbMEM_ABC_CD"></div></td>
						
						<th colspan="1">회원그룹</th>
						<td colspan="1"><div id="cmbGRUP_CD"></div></td>
					</tr>
				</table>
			</div>
			
			<div id="div_tab_1_table_2" class="samyang_div" style="display:none;">
				<table id="tab_1_table_2" class="table">
					<colgroup>
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="*">
					</colgroup>
					<tr>
						<th>이름</th>
						<td colspan="2"><input type="text" id="txtMEM_NM" class="input_text" ></td>
						
						<th>가족수</th>
						<td><input type="text" id="txtFAMILY_CNT" class="input_text" ></td>
						<td>인</td>
						
						<td colspan="4"><div id="rdoSEX_TYPE"></div></td>
						
					</tr>
					
					<tr>
						<th>전화1</th>
						<td colspan="2"><input type="text" id="txtTEL_NO01" class="input_text" ></td>
						
						<th>생일</th>
						<td colspan="6">
							<input type="text" id="txtBIRTHDAY" class="input_calendar">
							<div id="chkBIRTH_TYPE"></div>
						</td>
					</tr>
					<tr>
						<th>전화2</th>
						<td colspan="2"><input type="text" id="txtTEL_NO02" class="input_text" ></td>
						
						<th>기념일</th>
						<td colspan="6"><input type="text" id="txtWED_DATE" class="input_calendar"></td>
					</tr>
					
					<tr>
						<th>휴대폰</th>
						<td colspan="2"><input type="text" id="txtPHON_NO" class="input_text" ></td>
						
						<th>E-mail</th>
						<td colspan="2"><input type="text" id="txtEMAIL" class="input_text" ></td>
						
						<td colspan="2"><div id="chkSMS_STATE"></div></td>
						<th colspan="1">소액처리</th>
						<td colspan="1">
							<div id="cmbSMALL_MONEY_POINT"></div>
						</td>
					</tr>
					
					<tr>
						<th>현금영수증</th>
						<td colspan="9">
							<div style="float:left;" id="chkAPPLY_CASH_STATE"></div>
							<div style="float:left;" id="cmbAPPLY_CASH_TYPE"></div>
							<input type="text" id="txtLAST_CASH_NO" class="input_text" style="width: 125px; float:left; margin-left: 5px;" readonly/>
							<div style="float:left; margin-left: 5px;" id="cmbLAST_CASH_TYPE"></div>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="div_tab_1_table_3" class="samyang_div" style="display:none;">
				<table id="tab_1_table_3" class="table">
					<colgroup>
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="50px">
						<col width="90px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="*">
					</colgroup>
					
					<tr>
						<th colspan="3" style="text-align: center">사업자정보</th>
						<th colspan="5" style="text-align: center">거래정보</th>
						<th colspan="2" style="text-align: center">포인트</th>
					</tr>
					
					<tr>
						<th colspan="1">상호</th>
						<td colspan="2"><input type="text" id="txtCORP_NM" class="input_text" ></td>
						
						<td colspan="2" ><div id="chkTRUST_YN" style="float:right; margin-left: 5px"></div></td>
						<th colspan="1" style="width: 95%;" >결제마감(매월)</th>
						<td colspan="2" ><div id="cmbTRUST_EOD"></div></td>
						
						<td colspan="1"><input type="button" id="" class="input_common_button" value="현재포인트" onClick=""/></td>
						<td colspan="1" style="border-left: 0px;"><input type="text" id="txtPOINT" class="input_text" ></td>
					</tr>
					
					<tr>
						<th colspan="1">사업자</th>						
						<td colspan="2"><input type="text" id="txtCORP_NO" class="input_text" ></td>
						
						<td colspan="2" ><div id="chkTAX_TYPE" style="float:right; margin-left: 5px"></div></td>
						<th colspan="1" style="width: 95%;" >기초이월금액</th>
						<td colspan="2" ><input type="text" id="txtTRUST_BASE" class="input_text" ></td>
						
						<td colspan="1"><input type="button" id="" class="input_common_button" value="누적포인트" onClick=""/></td>
						<td colspan="1" style="border-left: 0px;"><input type="text" id="txtPOINT_SUM" class="input_text" ></td>
					</tr>
					
					<tr>
						<th colspan="1">업태</th>						
						<td colspan="2"><input type="text" id="txtBUSI_COND" class="input_text" ></td>
						
						<td colspan="2"></td>
						<th colspan="1" style="width: 95%;" >외상한도</th>
						<td colspan="2" ><input type="text" id="txtTRUST_LIMIT" class="input_text" ></td>
						
						<td colspan="2"></td>
					</tr>
					
					<tr>
						<th colspan="1">업종</th>						
						<td colspan="2"><input type="text" id="txtBUSI_TYPE" class="input_text" ></td>
						
						<td colspan="2"></td>
						<th colspan="1" style="width: 95%;" >외상잔액</th>
						<td colspan="2" ><input type="text" id="txtTRUST_AMT" class="input_text" ></td>
						<td colspan="2"></td>
					</tr>
					
					<tr>
						<th colspan="1"><input type="button" id="table_3_ZIP_NO" class="input_common_button" value="우편번호" onClick="openSearchPostAddrPopup(this);"/></th>
						<td colspan="2"><input type="text" id="txtCORP_ZIP_NO" class="input_text input_readonly" readonly></td>
						<td colspan="7"></td>
					</tr>
					<tr>
						<th colspan="1">도로명</th>
						<td colspan="4"><input type="text" id="txtCORP_S_ADDR" class="input_text input_readonly" readonly></td>
						<th colspan="1">지번</th>
						<td colspan="4"><input type="text" id="txtCORP_H_ADDR" class="input_text input_readonly" readonly></td>
					</tr>
					<tr>
						<th colspan="1">상세주소</th>
						<td colspan="9"><input type="text" id="txtCORP_ADDR_DETL" class="input_text" ></td>
					</tr>
					
				</table>
			</div>
			
			<div id="div_tab_1_table_4" class="samyang_div" style="display:none;">
				<table id="tab_1_table_4" class="table">
					<colgroup>
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="*">
					</colgroup>
					<tr>
						<th colspan="10" style="text-align: center; border-right: 0px;">배달지</th>
					</tr>
					<tr>
						<th colspan="1"><input type="button" id="table_4_ZIP_NO" class="input_common_button" value="우편번호" onClick="openSearchPostAddrPopup(this);"/></th>
						<td colspan="2" style="border-right: 0px;"><input type="text" id="txtDELI_ZIP_NO" class="input_text input_readonly" readonly></td>
						<td colspan="7"></td>
					</tr>
					<tr>
						<th colspan="1">주소</th>
						<td colspan="9"><input type="text" id="txtDELI_ADDR" class="input_text input_readonly" readonly></td>
					</tr>
					<tr>
						<th colspan="1">상세주소</th>
						<td colspan="9"><input type="text" id="txtDELI_ADDR_DETL" class="input_text" ></td>
					</tr>
					<tr>
						<th colspan="1">배송메모</th>
						<td colspan="9"><input type="text" id="txtDELI_MEMO" class="input_text" ></td>
					</tr>
					<tr>
						<th colspan="1">기타메모</th>
						<td colspan="8"><input type="text" id="txtETC_MEMO" class="input_text" ></td>
						<td colspan="1">◀계산시 OPR 하단 표시</td>
					</tr>
					
					<tr>
						<th colspan="1">등록일시</th>
						<td colspan="1">${CDATE}</td>
						<th colspan="1">최종방문</th>
						<td colspan="7">${TRADE_LAST_DATE}</td>
					</tr>
					
					<tr>
						<td colspan="10">
							<input type="button" id="" class="input_common_button" value="닫기" onClick="thisOnComplete();"/>
							<input type="button" id="" class="input_common_button" value="저장" onClick="crudMemberInfo();"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	
		
		<div id="div_tab_2" class="samyang_div" style="display:none;">
			<div id="div_tab_2_table" class="samyang_div" style="display:none;">
				<table id="tab_2_table" class="table">
					<colgroup>
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="*">
					</colgroup>
					<tr>
						<th colspan="1">기간</th>
						<td colspan="4">
							<input type="text" id="txtTAB_2_DATE_FR" class="input_calendar">
							<span style="float: left; margin-right: 5px;">~</span> 
							<input type="text" id="txtTAB_2_DATE_TO" class="input_calendar">
						</td>
						<td colspan="5"><div id="chkTAX_SHOW"></div></td>
					</tr>
				</table>
			</div>
			
			<div id="div_tab_2_ribbon" class="div_ribbon_full_size" style="display:none"></div>
			
			<div id="div_tab_2_grid" class="div_grid_full_size" style="display:none">
				<div id="div_tab_2_grid_1" class="div_grid_full_size" style="display:none" data-url="/sis/member/getTransactionHistory.do"></div>
				<div id="div_tab_2_grid_2" class="div_grid_full_size" style="display:none" data-url="/sis/member/getTaxExemptAmount.do"></div>
			</div>

		</div>
		
		<div id="div_tab_3" class="samyang_div" style="display:none;">
			<div id="div_tab_3_table" class="samyang_div" style="display:none;">
				<table id="tab_3_table" class="table">
					<colgroup>
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="*">
					</colgroup>
					<tr>
						<th colspan="1">기간</th>
						<td colspan="4">
							<input type="text" id="txtTAB_3_DATE_FR" class="input_calendar">
							<span style="float: left; margin-right: 5px;">~</span>
							<input type="text" id="txtTAB_3_DATE_TO" class="input_calendar">
						</td>
						<td colspan="3"><div id="rdoORDER_BY"></div></td>
						<th colspan="1" align="right"><div id="chkTOP_COUNT_TAB_3"></div></th>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
					</tr>
				</table>
			</div>
			<div id="div_tab_3_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
			<div id="div_tab_3_grid" class="div_grid_full_size" style="display:none"></div>
		</div>
		
		<div id="div_tab_4" class="samyang_div" style="display:none;">
			<div id="div_tab_4_table_1" class="samyang_div" style="display:none;">
				<table id="tab_4_table_1" class="table">
					<colgroup>
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="*">
					</colgroup>
					<tr>
						<th colspan="1">기간</th>
						<td colspan="9">
							<input type="text" id="txtTAB_4_DATE_FR" class="input_calendar">
							<span style="float: left; margin-right: 5px;">~</span>
							<input type="text" id="txtTAB_4_DATE_TO" class="input_calendar">
						</td>
					</tr>
				</table>
			</div>
			<div id="div_tab_4_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
			
			<div id="div_tab_4_table_2" class="samyang_div" style="display:none;">
				<table id="tab_4_table_2" class="table">
					<colgroup>
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="*">
					</colgroup>
					<tr>
						<td colspan="1"></td>
						<th colspan="1">구매합계</th>
						<td colspan="1"></td>
						<th colspan="1">현금구매</th>												
						<th colspan="1">카드구매</th>												
						<th colspan="1">상품권구매</th>												
						<th colspan="1">포인트구매</th>												
						<td colspan="1"></td>
						<th colspan="1">방문수</th>
						<th colspan="1">기여도</th>
						<th colspan="1">포인트</th>
					</tr>
					<tr>
						<th colspan="1">합계</th>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
					</tr>
					<tr>
						<th colspan="1">월 평균</th>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
					</tr>
					<tr>
						<th colspan="1">1회평균</th>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"></td>
						<td colspan="1"></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
						<td colspan="1"><input type="text" id="txt" class="input_text" ></td>
					</tr>
					
				</table>
			</div>

			<div id="div_tab_4_grid" class="div_grid_full_size" style="display:none"></div>
		</div>
		
		<div id="div_tab_5" class="samyang_div" style="display:none;">
			<div id="div_tab_5_table" class="samyang_div" style="display:none;">
				<table id="tab_5_table" class="table">
					<colgroup>
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="*">
					</colgroup>
					<tr>
						<th colspan="1">기간</th>
						<td colspan="9">
							<input type="text" id="txtTAB_5_DATE_FR" class="input_calendar">
							<span style="float: left; margin-right: 5px;">~</span> 
							<input type="text" id="txtTAB_5_DATE_TO" class="input_calendar">
						</td>
					</tr>
				</table>
				<div id="div_tab_5_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
				<div id="div_tab_5_grid" class="div_grid_full_size" style="display:none"></div>	
			</div>
			
			

		</div>
		
		<div id="div_tab_6" class="samyang_div" style="display:none;">
			<div id="div_tab_6_table" class="samyang_div" style="display:none;">
				<table id="tab_6_table" class="table">
					<colgroup>
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="*">
					</colgroup>
					<tr>
						<th colspan="1">기간</th>
						<td colspan="4">
							<input type="text" id="txtTAB_5_DATE_FR" class="input_calendar">
							<span style="float: left; margin-right: 5px;">~</span>
							<input type="text" id="txtTAB_5_DATE_TO" class="input_calendar">
						</td>
						<td colspan="5">
							<div id="cmbTOTAL_LOG_TYPE"></div>
						</td>
					</tr>
				</table>
			</div>
			<div id="div_tab_6_ribbon" class="div_ribbon_full_size" style="display:none;"></div>
			<div id="div_tab_6_grid" class="div_grid_full_size" style="display:none"></div>
		</div>
	
	
	</div>


</body>
</html>