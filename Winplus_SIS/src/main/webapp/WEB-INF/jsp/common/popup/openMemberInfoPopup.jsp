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
	
	<%--
	※ 전역 변수 선언부 
	□ 변수명 : Type / Description
	■ thisPopupWindow : 현재 팝업 윈도우
	■ total_layout : 전체 페이지 레이아웃 
	
	--%>
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2,3,4";
	
	var thisPopupWindow = parent.erpPopupWindows.window('openMemberInfoPopup');
	var loanInfo = {};
	var param_MEM_INFO = JSON.parse('${param.MEM_INFO}');
	
	var total_layout;
	var tabBar;
	var tab_1;
	var tab_2;
	var tab_3;
	var tab_4;
	var tab_5;
	var tab_6;
	
	var trust; //외상 돔객체
	var loan;  //여신 돔객체
	
	var busi_cond = ''; //업태
	var corp_zip_no = ''; //우편번호
	
	var loan_yn = 'N'; //여신가능여부
	var loan_amt = null; //여신한도
	var bal_amt = null; //잔액
	
	var trust_yn = 'N'; //외상가능여부
	var trust_cnt = null; //외상횟수
	
	$(document).ready(function(){
		if(thisPopupWindow){
			thisPopupWindow.setText("${screenDto.scrin_nm}");
			//thisPopupWindow.denyResize();
			//thisPopupWindow.denyMove();
		}
		
		init_total_layout();
		total_layout.progressOn();
		init_tabBar();
		init_tab_1();
		init_tab_2();
		init_tab_3();
		init_tab_4();
		init_tab_5();
		init_tab_6();
		
		trust = document.getElementById("trust");
		loan = document.getElementById("loan");
		if(param_MEM_INFO.MEM_NO){
			//모든 레이아웃 초기화 함수 호출후 등록해주세요.
			$erp.asyncObjAllOnCreated(function(){
				getMemberInfo(param_MEM_INFO);
			});
		}else{
			$erp.dataAutoBind("div_tab_1", param_MEM_INFO);
			total_layout.progressOff();
			setLoanDomObj();
		}
	});
	
	function setLoanDomObj(){
		if(trust_yn == 'Y'){
			if(trust_cnt == null){
				trust.innerHTML = '' +
					'<th colspan="1">업태</th>' +	
					'<td colspan="2"><input type="text" id="txtBUSI_COND" class="input_text" value=""/></td>' +
					'<td colspan="6"></td>' +
					'<td colspan="2"></td>';
					
				document.getElementById("txtBUSI_COND").value = busi_cond;
			}else{
				trust.innerHTML = '' + 
					'<th colspan="1">업태</th>' +	
					'<td colspan="2"><input type="text" id="txtBUSI_COND" class="input_text" value=""/></td>' +
					'<td colspan="1" style="font-weight: bold; text-align: right;">외상횟수</td>' +
					'<td colspan="2"><input type="text" id="txtTRUST_CNT" class="input_text input_money input_readonly" value="" readonly disabled/></td>' +
					'<td colspan="3"></td>' + 
					'<td colspan="2"></td>';
					
				document.getElementById("txtBUSI_COND").value = busi_cond;
				document.getElementById("txtTRUST_CNT").value = trust_cnt;
			}
			
		}else if(trust_yn == 'N'){
			trust.innerHTML = '' + 
				'<th colspan="1">업태</th>' +	
				'<td colspan="2"><input type="text" id="txtBUSI_COND" class="input_text" value=""></td>' +
				'<td colspan="6"></td>' + 
				'<td colspan="2"></td>';
			
			document.getElementById("txtBUSI_COND").value = busi_cond;
			
		}
		
		if(loan_yn == 'Y'){
			if(loan_amt == null){
				loan.innerHTML = '' + 
					'<th colspan="1"><input type="button" id="table_3_ZIP_NO" class="input_common_button" value="우편번호" onClick="openSearchPostAddrPopup(this);"/></th>' +
					'<td colspan="2"><input type="text" id="txtCORP_ZIP_NO" class="input_text input_readonly" value="" readonly></td>' +
					'<th colspan="1">정보없음</th>' +
					'<td colspan="5">여신거래는 초기 정보 설정이 필요합니다.&nbsp&nbsp→&nbsp&nbsp<input type="button" id="" class="input_common_button" value="여신등록" onClick="openAddNewLoanPopup();"/></td>' +
					'<td colspan="2"></td>';
				
				document.getElementById("txtCORP_ZIP_NO").value = corp_zip_no;
				
			}else{
				loan.innerHTML = '' + 
					'<th colspan="1"><input type="button" id="table_3_ZIP_NO" class="input_common_button" value="우편번호" onClick="openSearchPostAddrPopup(this);"/></th>' +
					'<td colspan="2"><input type="text" id="txtCORP_ZIP_NO" class="input_text input_readonly" value="" readonly/></td>' +
					'<td colspan="1" style="width: 95%; font-weight: bold; text-align: right;" >여신한도</td>' +
					'<td colspan="2" ><input type="text" id="txtLOAN_AMT" class="input_text input_money input_readonly" value="" readonly disabled/></td>' +
					'<td colspan="1" style="width: 95%; font-weight: bold; text-align: right;" >여신잔액</td>' +
					'<td colspan="2" ><input type="text" id="txtBAL_AMT" class="input_text input_money input_readonly" value="" readonly disabled/></td>' +
					'<td colspan="2"></td>';
				
				document.getElementById("txtCORP_ZIP_NO").value = corp_zip_no;
				document.getElementById("txtLOAN_AMT").value = loan_amt;
				document.getElementById("txtBAL_AMT").value = bal_amt;
			}
			
		}else if(loan_yn == 'N'){
			loan.innerHTML = '' + 
				'<th colspan="1"><input type="button" id="table_3_ZIP_NO" class="input_common_button" value="우편번호" onClick="openSearchPostAddrPopup(this);"/></th>' +
				'<td colspan="2"><input type="text" id="txtCORP_ZIP_NO" class="input_text input_readonly" value="" readonly></td>' +
				'<td colspan="6"></td>' + 
				'<td colspan="2"></td>';
			
			document.getElementById("txtCORP_ZIP_NO").value = corp_zip_no;
		}
	}
	
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
		
		tabBar.attachEvent("onSelect", function(id, lastId){
			if(id != "tab_1"){
				if(param_MEM_INFO.MEM_NO){
					return true;
				}else{
					$erp.alertMessage({
						"alertMessage" : "등록되어있지 않은 회원입니다.<br/>회원정보 저장이 필요합니다.",
						"alertCode" : null,
						"alertType" : "alert",
						"isAjax" : false
					});
					return false;
				}
			}else{
			    return true;
			}
		});
		
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
		tab_1.cells("a").setHeight($erp.getTableHeight(3));
		tab_1.cells("b").attachObject("div_tab_1_table_2");
		tab_1.cells("b").setHeight($erp.getTableHeight(6));
		tab_1.cells("c").attachObject("div_tab_1_table_3");
		tab_1.cells("c").setHeight($erp.getTableHeight(9));
		tab_1.cells("d").attachObject("div_tab_1_table_4");
		
		tab_1.setSeparatorSize(0, 2);
		tab_1.setSeparatorSize(1, 2);
		tab_1.setSeparatorSize(2, 2);
		
		//1
// 		chkMEM_STATE = $erp.getDhtmlXCheckBox('chkMEM_STATE', '유효', '1', false, 'label-right');
// 		chkMEM_STATE.attachEvent("onChange",function(id){
// 			if(chkMEM_STATE.isItemChecked(id) == true){
// 				$erp.objReadonly("cmbMEM_GRADE");
// 			}else{
// 				$erp.objNotReadonly("cmbMEM_GRADE");
// 			}
// 		});
		
		cmbMEM_STATE = $erp.getDhtmlXComboCommonCode("cmbMEM_STATE", "MEM_STATE", ["USE_CD","YN"], 130, null, false, "Y");
		
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 200, null, false, param_MEM_INFO.ORGN_DIV_CD, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 200, "AllOrOne", false, param_MEM_INFO.ORGN_CD);
			$erp.objReadonly("cmbORGN_DIV_CD");
			$erp.objReadonly("cmbORGN_CD");
		});

		
		cmbMEM_TYPE = $erp.getDhtmlXComboCommonCode("cmbMEM_TYPE", "MEM_TYPE", "MEM_TYPE", 130, null, false, "0"); //MEM_TYPE = MEM_TYPE 같음 테이블 컬럼명이 다름
		cmbPRICE_POLI = $erp.getDhtmlXComboCommonCode("cmbPRICE_POLI", "PRICE_POLI", "PRICE_POLI", 130, null, false, "PP1");
		cmbMEM_ABC = $erp.getDhtmlXComboCommonCode("cmbMEM_ABC", "MEM_ABC", "MEM_ABC", 130, null, false, "D");
		
		//id, name, width, 텍스트, 콜백
// 		cmbGRUP_CD = $erp.getDhtmlXEmptyCombo("cmbGRUP_CD", "GRUP_CD", 133, "-그룹-",function(){
// 			var url = "/sis/member/getMemberGroupList.do";
// 			var send_data = {};
// 			var if_success = function(data){
// 				if($erp.isEmpty(data.comboList)){
// 					//검색 결과 없음
// 				}else{
// 					//필수 기본키 text,value  추가로 커스텀 key:value 등록 가능
// 					cmbGRUP_CD.setCombo(data.comboList);
// 				}
// 			}
			
// 			var if_error = function(){
// 			}
// 			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);			
// 		});

		
		//2
		rdoSEX_TYPE;
		$erp.getDhtmlXRadioCommonCode("rdoSEX_TYPE", "SEX_TYPE", "SEX_TYPE", 0 , false, "Y", function(){
			rdoSEX_TYPE = this;
			this.attachEvent("onChange",function(name, value, checked){
				if(value == '_____'){
					
				}else{
					
				}
			});
			
		});
		
// 		chkBIRTH_TYPE = $erp.getDhtmlXCheckBox('chkBIRTH_TYPE', '양력', '1', false, 'label-right');
// 		chkBIRTH_TYPE.attachEvent("onChange",function(name, value, checked){
// 			if(chkBIRTH_TYPE.isItemChecked(name) == true){
				
// 			}else{
				
// 			}
// 		});	
		
		chkSMS_YN = $erp.getDhtmlXCheckBox('chkSMS_YN', '거부', '1', false, 'label-right');
		chkCASH_RECP_YN = $erp.getDhtmlXCheckBox('chkCASH_RECP_YN', '', '1', false, 'label-right');
		chkCASH_RECP_YN.attachEvent("onChange",function(name, value, checked){
			if(chkCASH_RECP_YN.isItemChecked(name) == true){
				$erp.objNotReadonly(["cmbCASH_RECP_TYPE", "txtLAST_CASH_RECP_NO", "cmbLAST_CASH_RECP_TYPE"]);
			}else{
				$erp.objReadonly(["cmbCASH_RECP_TYPE", "txtLAST_CASH_RECP_NO", "cmbLAST_CASH_RECP_TYPE"]);
			}
		});	
		
		cmbCHG_AMT_TYPE = $erp.getDhtmlXComboCommonCode("cmbCHG_AMT_TYPE", "CHG_AMT_TYPE", "CHG_AMT_TYPE", 130, null, false, "");
	
		cmbCASH_RECP_TYPE = $erp.getDhtmlXComboCommonCode("cmbCASH_RECP_TYPE", "CASH_RECP_TYPE", "CASH_RECP_TYPE", 100, null, false, "");
		
		//사업자 : 1, 개인 : 0
		cmbLAST_CASH_RECP_TYPE = $erp.getDhtmlXComboCommonCode("cmbLAST_CASH_RECP_TYPE", "LAST_CASH_RECP_TYPE", "LAST_CASH_RECP_TYPE", 70, null, false, "");
		
		//3
		cmbTRUST_YN = $erp.getDhtmlXComboCommonCode("cmbTRUST_YN", "TRUST_YN", ["YN_CD","YN"], 100, null, false, 'N');
		cmbTRUST_YN.attachEvent("onChange", function(value, text){
			trust_yn = value;
			setLoanDomObj();
		}); 
			
		cmbLOAN_YN = $erp.getDhtmlXComboCommonCode("cmbLOAN_YN", "LOAN_YN", ["YN_CD","YN"], 100, null, false, 'N');
		cmbLOAN_YN.attachEvent("onChange", function(value, text){
			loan_yn = value;
			setLoanDomObj();
		});
		
		chkTAX_YN = $erp.getDhtmlXCheckBox('chkTAX_YN', '세금계산서발행', 'Y', false, 'label-right');
		chkTAX_YN.attachEvent("onChange",function(name, value, checked){
			if(chkTAX_YN.isItemChecked(name) == true){
				
			}else{
				
			}
		});	
		
		cmbPAY_DATE_CD = $erp.getDhtmlXComboCommonCode("cmbPAY_DATE_CD", "PAY_DATE_CD", "DAY", 100, null, false, "01");
		
		
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
		chkTAX_SHOW.attachEvent("onChange",function(name, value, checked){
			if(chkTAX_SHOW.isItemChecked(name) == true){
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
				        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
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
						var dataObj = $erp.unionObjArray([param_MEM_INFO, $erp.dataSerialize("tab_2_table", "Q", true)]);
						
						var if_success = function(data){
							$erp.clearDhtmlXGrid(tab_2_grid[id]); //기존데이터 삭제
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
		                    {id : "NO", 			label:["NO", "#text_filter"], 			type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "SALE_TYPE", 	label:["구분", "#text_filter"], 			type: "combo", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false, commonCode : "SALES_TYPE"}
		                    , {id : "POS_NO", 		label:["단말", "#text_filter"], 			type: "ron", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "EMP_NO", 		label:["계산원", "#text_filter"], 		type: "ro", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "ORD_DATE", 	label:["거래시각", "#text_filter"], 		type: "ro", width: "72", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "SALE_TOT_AMT", label:["거래액", "#text_filter"], 		type: "ron", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_CASH", 	label:["현금", "#text_filter"], 			type: "ron", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_CARD", 	label:["카드", "#text_filter"], 			type: "ron", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_GIFT", 	label:["상품권", "#text_filter"], 			type: "ron", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_POINT", 	label:["포인트", "#text_filter"], 			type: "ron", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_TRUST", 	label:["외상", "#text_filter"], 			type: "ron", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "ADD_POINT",	label:["포인트추가", "#text_filter"], 		type: "ron", width: "60", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
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
		                    {id : "NO"					, label:["NO", "#text_filter"]		, type : "cntr",	width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "SALES_TYPE"		, label:["구분", "#text_filter"]		, type: "combo", 	width: "60"	, sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false, commonCode : "SALES_TYPE"}
		                    , {id : "TAX_AMT"			, label:["과세", "#text_filter"]		, type: "ron", 		width: "60"	, sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "TAX_AMT_TARGET"	, label:["과세(대상)", "#text_filter"]	, type: "ron", 		width: "60"	, sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "TAX_AMT_PUBLISH"	, label:["과세발행", "#text_filter"]	, type: "ron", 		width: "60"	, sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "VAT_AMT"			, label:["부가세", "#text_filter"]		, type: "ron", 		width: "60"	, sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "TAX_FREE_AMT"		, label:["면세", "#text_filter"]		, type: "ron", 		width: "60"	, sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "TAX_FREE_PUBLISH"	, label:["면세발행", "#text_filter"]	, type: "ron", 		width: "60"	, sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
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
		rdoORDER_BY;
		$erp.getDhtmlXRadioCommonCode("rdoORDER_BY", "ORDER_BY", ["ORDER_BY","BEST_GOODS"], 0 , false, "Y", function(){
			rdoORDER_BY = this;
			this.attachEvent("onChange",function(name, value, checked){
				if(value == '_____'){
					
				}else{
					
				}
			});
			
		});
		
		chkTOP_COUNT_TAB_3_chk = $erp.getDhtmlXCheckBox('chkTOP_COUNT_TAB_3_chk', '상위', '1', false, 'label-right');
		chkTOP_COUNT_TAB_3_chk.attachEvent("onChange",function(name, value, checked){
			if(chkTOP_COUNT_TAB_3_chk.isItemChecked(name) == true){
				
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
// 				        		             , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
// 				        		             , {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
// 				        		             , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
				        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
				        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
				        		             ]
				           }
				           ]
		});
		
		tab_3_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				var url = "/sis/member/getMemberBestGoodsList.do";
				var send_data = $erp.unionObjArray([param_MEM_INFO, $erp.dataSerialize("tab_3_table", "Q", true)]);
				var if_success = function(data){
					$erp.clearDhtmlXGrid(tab_3_grid); //기존데이터 삭제
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(tab_3_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						tab_3_grid.parse(data.gridDataList,'js');
					}
					$erp.setDhtmlXGridFooterRowCount(tab_3_grid); // 현재 행수 계산
					
				}
				
				var if_error = function(){
					$erp.alertMessage({
						"alertMessage" : "조회실패",
						"alertCode" : null,
						"alertType" : "error",
						"isAjax" : false
					});
				}
				
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
				
// 			} else if (itemId == "add_grid"){
				
// 			} else if (itemId == "delete_grid"){
				
// 			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				
			} else if (itemId == "print_grid"){
				
			}
		});
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
		                    {id : "NO", 				label:["NO", "#text_filter"]			, type: "cntr", 	width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "GOODS_NO", 		label:["상품번호", "#text_filter"]			, type: "ro", 		width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "GOODS_NM", 		label:["상품명", "#text_filter"]			, type: "ro", 		width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "BCD_CD", 			label:["바코드", "#text_filter"]			, type: "ro", 		width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "TAX_TYPE", 		label:["과세구분", "#text_filter"]			, type: "combo", 	width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false, commonCode : ["USE_CD","YN"], isDisabled : true}
		                    , {id : "GOODS_PUR_CD", 	label:["상품매출유형", "#text_filter"]		, type: "combo", 	width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false, commonCode : ["GOODS_SALES_TYPE"], isDisabled : true}
		                    , {id : "ORD_CNT", 			label:["주문횟수", "#text_filter"]			, type: "ron", 		width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "SUM_AMT", 			label:["총주문액", "#text_filter"]			, type: "ron", 		width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "SUM_QTY", 			label:["총수량", "#text_filter"]			, type: "ron", 		width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "AVG_AMT", 			label:["1회평균주문금액", "#text_filter"]	, type: "ron", 		width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "AVG_QTY",			label:["1회평균주문수량", "#text_filter"]	, type: "ron", 		width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "ORD_MIN_DATE", 	label:["최초 주문일", "#text_filter"]		, type: "ro", 		width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "ORD_MAX_DATE", 	label:["마지막 주문일", "#text_filter"]		, type: "ro", 		width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
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
// 				        		             , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
// 				        		             , {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
// 				        		             , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 	isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
				        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
				        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
				        		             ]
				           }
				           ]
		});
		
		tab_4_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				var url = "/sis/member/getMemberMonthlyTrend.do";
				var send_data = $erp.unionObjArray([param_MEM_INFO, $erp.dataSerialize("tab_4_table_1", "Q", true)]);
				var if_success = function(data){
					$erp.clearDhtmlXGrid(tab_4_grid); //기존데이터 삭제
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(tab_4_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						$erp.dataAutoBind("tab_4_gridSum", data.gridSum);
						$erp.dataAutoBind("tab_4_gridAvgByMonth", data.gridAvgByMonth);
						$erp.dataAutoBind("tab_4_gridAvgByCount", data.gridAvgByCount);
						tab_4_grid.parse(data.gridDataList,'js');
					}
					$erp.setDhtmlXGridFooterRowCount(tab_4_grid); // 현재 행수 계산
				}
				
				var if_error = function(){
					$erp.alertMessage({
						"alertMessage" : "조회실패",
						"alertCode" : null,
						"alertType" : "error",
						"isAjax" : false
					});
				}
				
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
				
// 			} else if (itemId == "add_grid"){
				
// 			} else if (itemId == "delete_grid"){
				
// 			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				
			} else if (itemId == "print_grid"){
				
			}
		});
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
		                    {id : "NO", 			label:["NO", "#text_filter"]		, type: "cntr", 	width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "BY_MONTH", 	label:["년/월", "#text_filter"]		, type: "ro", 		width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "SALE_AMT", 	label:["공급가액", "#text_filter"]		, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "SALE_AMT", 	label:["부가세액", "#text_filter"]		, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "SALE_AMT", 	label:["판매금액", "#text_filter"]		, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_CASH", 	label:["현금", "#text_filter"]		, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_CARD", 	label:["카드", "#text_filter"]		, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_GIFT", 	label:["상품권", "#text_filter"]		, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "PAY_POINT", 	label:["사용포인트", "#text_filter"]	, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
		                    , {id : "ADD_POINT", 	label:["적립포인트", "#text_filter"]	, type: "ron", 		width: "60"	, sort : "str", align : "left", isHidden : false, isEssential : false, numberFormat : "0,000", isDataColumn : false}
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
			, pattern: "2E"
			, cells: [
			          {id: "a", text: "", header:false, fix_size:[true, true]},
			          {id: "b", text: "", header:false, fix_size:[true, true]}
			          ]
		});
		
		tab_5.registTab(tabBar); //삭제하면 텝선택시 리사이즈가 작동하지 않습니다.
		tab_5.captureEventOnParentResize(tabBar); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.
		
		tab_5.cells("a").attachObject("div_tab_5_ribbon");
		tab_5.cells("a").setHeight(36);
		tab_5.cells("b").attachObject("div_tab_5_grid");
		
		tab_5.setSeparatorSize(0, 1);
		
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
		        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
		        		             ]
				           }
				           ]
		});
		
		tab_5_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				var url = "/sis/member/getMemberGoodsPrice.do";
				var send_data = $erp.unionObjArray([param_MEM_INFO, LUI]); //중복된 키값을 가진 객체에는 사용하면안됨
				var if_success = function(data){
					$erp.clearDhtmlXGrid(tab_5_grid); //기존데이터 삭제
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(tab_5_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						tab_5_grid.parse(data.gridDataList,'js');
						
						var PUR_PRICE; //매입가
						var PRICE_POLI_TYPE; //지정율, 지정가
						var MEM_PROF_RATE; //회원 지정이익율
						var MEM_SALE_PRICE; //회원 지정가
						var tmpStdProfitMultiplier; //기준이익배수
						var result;
						for(var index in data.gridDataList){
							PUR_PRICE = data.gridDataList[index]["PUR_PRICE"];
							PRICE_POLI_TYPE = data.gridDataList[index]["PRICE_POLI_TYPE"];
							MEM_PROF_RATE = data.gridDataList[index]["MEM_PROF_RATE"];
							MEM_SALE_PRICE = data.gridDataList[index]["MEM_SALE_PRICE"];
							
							if(PRICE_POLI_TYPE == "0"){
								tmpStdProfitMultiplier = 1-(MEM_PROF_RATE/100);
								result = Math.floor(PUR_PRICE/tmpStdProfitMultiplier);
								tab_5_grid.cells(tab_5_grid.getRowId(index), tab_5_grid.getColIndexById("MEM_SALE_PRICE")).setValue(result);
							}else if(PRICE_POLI_TYPE == "1"){
								result = (MEM_SALE_PRICE-PUR_PRICE)/MEM_SALE_PRICE*100;
								tab_5_grid.cells(tab_5_grid.getRowId(index), tab_5_grid.getColIndexById("MEM_PROF_RATE")).setValue(result);
							}
						}
					}
					$erp.setDhtmlXGridFooterRowCount(tab_5_grid); // 현재 행수 계산
				}
				
				var if_error = function(XHR, status, error){
					
				}
				
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			} else if (itemId == "add_grid"){

				var onClickRibbonAddData = function(fromGrid){
					//상품조회 팝업 업데이트 되면 수정해야함	
					//dataState : checked,selected  //copyType : add,new
					$erp.copyRowsGridToGrid(fromGrid, tab_5_grid, ["BCD_CD", "GOODS_NO", "GOODS_NM", "DIMEN_NM"], ["BCD_CD", "GOODS_NO", "GOODS_NM", "DIMEN_NM"], "checked", "new", [], [], {"PRICE_POLI_TYPE" : 1, "USE_YN" : "Y"}, {"PRICE_POLI_TYPE" : 1, "USE_YN" : "Y"}, function(result){
						
						var loadGoodsList = [];
						for(var index in result.newAddRowDataList){
							loadGoodsList.push({"BCD_CD" : result.newAddRowDataList[index]["BCD_CD"], "ORGN_CD" : param_MEM_INFO.ORGN_CD, "MEM_NO" : param_MEM_INFO.MEM_NO});
						}
						var url = "/sis/member/getMemberWSalePrice.do";
						var send_data = {"loadGoodsList" : loadGoodsList};
						var if_success = function(data){
							var gridDataList = data.gridDataList;
							
							for(var index in gridDataList){
								tab_5_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], tab_5_grid.getColIndexById("PUR_PRICE")).setValue(gridDataList[index]["PUR_PRICE"]);
								tab_5_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], tab_5_grid.getColIndexById("DIMEN_NM")).setValue(gridDataList[index]["DIMEN_NM"]);
								tab_5_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], tab_5_grid.getColIndexById("SALE_PRICE")).setValue(gridDataList[index]["SALE_PRICE"]);
								tab_5_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], tab_5_grid.getColIndexById("PROF_RATE")).setValue(gridDataList[index]["PROF_RATE"]);
								tab_5_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], tab_5_grid.getColIndexById("WSALE_PRICE")).setValue(gridDataList[index]["WSALE_PRICE"]);
// 								tab_5_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], tab_5_grid.getColIndexById("PROF_RATE")).setValue(gridDataList[index]["PROF_RATE"]);
// 								tab_5_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], tab_5_grid.getColIndexById("RCMD_SALE_PRICE")).setValue(gridDataList[index]["RCMD_SALE_PRICE"]);
//				 				tab_5_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], tab_5_grid.getColIndexById("TAX_YN")).setValue("Y");
//				 				tab_5_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]][1], tab_5_grid.getColIndexById("USE_YN")).setValue("Y");
								result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["BCD_CD"]].push("로드완료");
							}
							var notExistList = [];
							var value;
							var state;
							var dp = tab_5_grid.getDataProcessor();
							for(var index in result.newAddRowDataList){
								value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["BCD_CD"]];
								state = dp.getState(value[1]);
								if(value.length == 2 && state == "inserted"){
									notExistList.push(value[0]);
								}
							}
							$erp.deleteGridRows(tab_5_grid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
							
							$erp.alertMessage({
								"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/>[무효  : " + notExistList.length + "개]<br/>[신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
								"alertType" : "alert",
								"isAjax" : false
							});
							
							var rowIndexList = [];
							for(var i = 0; i<tab_5_grid.getRowsNum(); i++){
								rowIndexList.push(i);
							}
							
// 							console.log("데이타 로드후 컬럼 타입 세팅");
// 							rowsManagement(rowIndexList, 1);
							
							if(tab_5_grid.getRowsNum() == 0){
								tab_5_ribbon.callEvent("onClick",["search_grid"]);
								return;
							}
							
							$erp.setDhtmlXGridFooterRowCount(tab_5_grid); // 현재 행수 계산
						}
						
						var if_error = function(XHR, status, error){
						}
						$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
						
					}, false);
				}
				
				$erp.openSearchGoodsPopup(null, onClickRibbonAddData, {ORGN_DIV_CD : param_MEM_INFO.ORGN_DIV_CD, ORGN_CD : param_MEM_INFO.ORGN_CD});
				
			} else if (itemId == "delete_grid"){
				$erp.deleteGridCheckedRows(tab_5_grid, [], []);

			} else if (itemId == "save_grid"){
				
				$erp.gridValidationCheck(tab_5_grid, function(){
					
					var url = "/sis/member/crudMemberGoodsPrice.do";
					var send_data = $erp.dataSerializeOfGridByCRUD(tab_5_grid, true, {
																						ORGN_DIV_CD : param_MEM_INFO.ORGN_DIV_CD
																						, ORGN_CD : param_MEM_INFO.ORGN_CD
																						, MEM_NO : param_MEM_INFO.MEM_NO
																					 });
					var if_success = function(data){
						
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else{
							$erp.alertMessage({
								"alertMessage" : "저장완료",
								"alertType" : "alert",
								"isAjax" : false,
								"alertCallbackFn" : function(){
									tab_5_ribbon.callEvent("onClick",["search_grid"]);
								},
							});
						}
					}
					
					var if_error = function(){
						$erp.alertMessage({
							"alertMessage" : "저장실패",
							"alertCode" : null,
							"alertType" : "error",
							"isAjax" : false
						});
					}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
					
				}); 
				
			} else if (itemId == "excel_grid"){
				
			} else if (itemId == "print_grid"){
				
			}
		});
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [ //수정해야함
			                    {id : "CHECK", 				label:["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			                    , {id : "NO", 				label:["NO", "#text_filter"], 		type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			                    , {id : "BCD_CD", 			label:["바코드", "#text_filter"], 	type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			                    , {id : "GOODS_NO", 		label:["상품번호", "#text_filter"], 	type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			                    , {id : "GOODS_NM", 		label:["상품명", "#text_filter"], 	type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			                    , {id : "DIMEN_NM", 		label:["규격", "#text_filter"], 		type: "ro", width: "70", sort : "str", align : "left", isHidden : false, isEssential : false}
			                    , {id : "PUR_PRICE", 		label:["매입가", "#text_filter"], 	type: "ron", width: "70", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			                    , {id : "SALE_PRICE", 		label:["판매가", "#text_filter"], 	type: "ron", width: "70", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			                    , {id : "PROF_RATE", 		label:["기준마진율", "#text_filter"], 	type: "ron", width: "70", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000.00%"}
			                    , {id : "WSALE_PRICE", 		label:["도매가", "#text_filter"], 	type: "ron", width: "70", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			                    , {id : "PRICE_POLI_TYPE", 	label:["판매방식", "#text_filter"], 	type: "combo", width: "70", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "PRICE_POLI_TYPE"}
			                    , {id : "MEM_PROF_RATE", 	label:["회원마진율", "#text_filter"], 	type: "ron", width: "70", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000.00%"}
			                    , {id : "MEM_SALE_PRICE", 	label:["회원지정가", "#text_filter"], 	type: "ron", width: "70", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			                    , {id : "USE_YN", 			label:["사용여부", "#text_filter"], 	type: "combo", width: "70", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["USE_CD", "YN"]}
			                    , {id : "CDATE", 			label:["등록일", "#text_filter"], 	type: "ro", width: "72", sort : "str", align : "center", isHidden : false, isEssential : false}
			                    , {id : "MDATE", 			label:["수정일", "#text_filter"], 	type: "ro", width: "72", sort : "str", align : "center", isHidden : false, isEssential : false}
		                    ];
		
		tab_5_grid = new dhtmlXGridObject({
			parent: "div_tab_5_grid"
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : grid_Columns
		});
		
		$erp.initGrid(tab_5_grid);
		
		var cellTypeChanging = false;
		tab_5_grid.attachEvent("onCellChanged", function (rowId,columnIdx,newValue){
			
			if(tab_5_grid.getColumnId(columnIdx) == "PRICE_POLI_TYPE"){
				cellTypeChanging = true;
				rowsManagement([tab_5_grid.getRowIndex(rowId)], newValue);
				cellTypeChanging = false;
			}else if(cellTypeChanging){
				//셀타입 변경중 발생 이벤트는 무시
			}else if(tab_5_grid.getColumnId(columnIdx) == "MEM_PROF_RATE"){
				
				if(tab_5_grid.cells(rowId, columnIdx) instanceof eXcell_ron){
					if(newValue == "Inf,ini.ty%"){
						tab_5_grid.cells(rowId, columnIdx).setValue(0);
					}
				}else if(tab_5_grid.cells(rowId, columnIdx) instanceof eXcell_edn){
					var pur_price = tab_5_grid.cells(rowId, tab_5_grid.getColIndexById("PUR_PRICE")).getValue();
					var str_mem_prof_rate = tab_5_grid.cells(rowId, tab_5_grid.getColIndexById("MEM_PROF_RATE")).getValue();
					if(str_mem_prof_rate == ""){
						str_mem_prof_rate = 0;
					}
					var mem_prof_rate = parseFloat(str_mem_prof_rate);
					var tempRate = mem_prof_rate/100;
					var tmpStdProfitMultiplier = 1-(tempRate); //기준이익배수
					var result = Math.floor(pur_price/tmpStdProfitMultiplier)
					tab_5_grid.cells(rowId, tab_5_grid.getColIndexById("MEM_SALE_PRICE")).setValue(result);
				}
				
			}else if(tab_5_grid.getColumnId(columnIdx) == "MEM_SALE_PRICE"){
				
				if(tab_5_grid.cells(rowId, columnIdx) instanceof eXcell_ron){
					//로직없음
				}else if(tab_5_grid.cells(rowId, columnIdx) instanceof eXcell_edn){
					var pur_price = tab_5_grid.cells(rowId, tab_5_grid.getColIndexById("PUR_PRICE")).getValue();
					var mem_sale_price = parseFloat(tab_5_grid.cells(rowId, tab_5_grid.getColIndexById("MEM_SALE_PRICE")).getValue());
					var result = (mem_sale_price-pur_price)/mem_sale_price*100;
					tab_5_grid.cells(rowId, tab_5_grid.getColIndexById("MEM_PROF_RATE")).setValue(result);
				}
				
			}
			
		});
	}
	
	function rowsManagement(rowIndexList, PRICE_POLI_TYPE_value){
		if(PRICE_POLI_TYPE_value == "0" || PRICE_POLI_TYPE_value == "지정율"){ //지정율
			$erp.rowsEditableManagement(tab_5_grid, rowIndexList, ["MEM_PROF_RATE"]);
			$erp.rowsNotEditableManagement(tab_5_grid, rowIndexList, ["MEM_SALE_PRICE"]);
		}else if(PRICE_POLI_TYPE_value == "1" || PRICE_POLI_TYPE_value == "지정가"){ //지정가
			$erp.rowsEditableManagement(tab_5_grid, rowIndexList, ["MEM_SALE_PRICE"]);
			$erp.rowsNotEditableManagement(tab_5_grid, rowIndexList, ["MEM_PROF_RATE"]);
		}
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
// 		        		             , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
// 		        		             , {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
// 		        		             , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
		        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
// 		        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
		        		             ]
				           }
				           ]
		});
		
		tab_6_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				var url = "/sis/member/getMemberInfoLog.do";
				var send_data = {
						ORGN_DIV_CD : param_MEM_INFO.ORGN_DIV_CD
						, ORGN_CD : param_MEM_INFO.ORGN_CD
						, MEM_NO : param_MEM_INFO.MEM_NO
					};
				var if_success = function(data){
					$erp.clearDhtmlXGrid(tab_6_grid); //기존데이터 삭제
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(tab_6_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						tab_6_grid.parse(data.gridDataList,'js');
					}
					$erp.setDhtmlXGridFooterRowCount(tab_6_grid); // 현재 행수 계산
				}
				
				var if_error = function(XHR, status, error){
					
				}
				
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			} else if (itemId == "add_grid"){
				
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				$erp.exportGridToExcel({
					"grid" : tab_6_grid
					, "fileName" : "회원변경로그"
					, "isOnlyEssentialColumn" : true		//필수컬럼만
					, "excludeColumnIdList" : []			//추가로 제외하고 싶은 컬럼 아이디 리스트
					, "isIncludeHidden" : false				//히든컬럼 포함
					, "isExcludeGridData" : false			//그리드 데이터 제외
				});
			} else if (itemId == "print_grid"){
				
			}
		});
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
		                    {id : "NO", 				label:["NO", "#text_filter"], 		type: "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
		                    , {id : "CHANGE_CONTENT", 	label:["변경내용", "#text_filter"], 	type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "CHANGE_BEFORE", 	label:["변경전", "#text_filter"], 		type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "CHANGE_AFTER", 	label:["변경후", "#text_filter"], 		type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "MDATE", 			label:["수정일", "#text_filter"], 	type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
		                    , {id : "MUSER", 			label:["수정자", "#text_filter"], 		type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : false}
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
	
	function getMemberInfo(MEM_INFO){
		var url = "/sis/member/getMemberInfo.do";
		var send_data = MEM_INFO;
		var if_success = function(data){
			if($erp.isEmpty(data.dataMap)){
				
			}else{
// 				console.log(data.dataMap);
				corp_zip_no = data.dataMap.CORP_ZIP_NO;
				busi_cond = data.dataMap.BUSI_COND;
				
				trust_cnt = data.dataMap.TRUST_CNT;
				loan_amt = data.dataMap.LOAN_AMT;
				bal_amt = data.dataMap.BAL_AMT;
				
				param_MEM_INFO = data.dataMap;
				$erp.dataAutoBind("div_tab_1", data.dataMap);
			}
		}
		
		var if_error = function(){
			
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
	function openSearchPostAddrPopup(domObj){	 
		var onComplete = function(data){
			var addressMap = $erp.getAddressMap(data);
			
			if(domObj.id == "table_3_ZIP_NO"){
				document.getElementById("txtCORP_ZIP_NO").value = addressMap.roadZipNo;
				document.getElementById("txtCORP_R_ADDR").value = addressMap.roadAddress;
				document.getElementById("txtCORP_L_ADDR").value = addressMap.jibunAddress;
				
				document.getElementById("txtCORP_ADDR_DETL").focus();
				
			}else if(domObj.id == "table_4_ZIP_NO"){
				document.getElementById("txtDELI_ZIP_NO").value = addressMap.selectZipNo;
				document.getElementById("txtDELI_ADDR").value = addressMap.selectAddress;
				
				document.getElementById("txtDELI_ADDR_DETL").focus();
			}
			
			$erp.closePopup2('ERP_POST_WIN_ID');
		}
		$erp.openSearchPostAddrPopup2(onComplete, {win_id : "ERP_POST_WIN_ID"});
	}
	function openAddNewLoanPopup(){
		var MEM_NO = document.getElementById("txtMEM_NO").value;
		var MEM_NM = document.getElementById("txtMEM_NM").value;
		var LOAN_CD = document.getElementById("txtLOAN_CD").value;
		
		if(MEM_NO == undefined || MEM_NO == null || MEM_NO == ""){
			$erp.alertMessage({
				"alertMessage" : "미등록 회원입니다.<br>회원 등록 후  다시 진행 해 주세요.",
				"alertType" : "alert",
				"isAjax" : false
			});
			return;
		}
		
		if(LOAN_CD == undefined || LOAN_CD == null || LOAN_CD == ""){
			$erp.openAddNewLoanPopup({"popupType" : "add", "loanType" : "M", "ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue(), "cmbORGN_CD" : cmbORGN_CD.getSelectedValue(), "MEM_NO" : MEM_NO, "MEM_NM" : MEM_NM });
		}else{
			$erp.openAddNewLoanPopup({"popupType" : "update", "loanType" : "M", "ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue(), "cmbORGN_CD" : cmbORGN_CD.getSelectedValue(), "MEM_NO" : MEM_NO, "MEM_NM" : MEM_NM, "LOAN_CD" : LOAN_CD});
		}
	}
	
	function crudMemberInfo(){
		var url = "/sis/member/crudMemberInfo.do";
		var send_data = $erp.dataSerialize("div_tab_1", "Q", true);
		send_data["CASH_AMT"] = loanInfo.CASH_AMT;
		send_data["CREDIT_AMT"] = loanInfo.CREDIT_AMT;
		send_data["EVI_FILE_NM"] = loanInfo.EVI_FILE_NM;
		send_data["EVI_FILE_PATH"] = loanInfo.EVI_FILE_PATH;
		send_data["GRNT_AMT"] = loanInfo.GRNT_AMT;
		send_data["IO_TYPE"] = loanInfo.IO_TYPE;
		send_data["LOAN_CD"] = loanInfo.LOAN_CD;
		send_data["LOCK_FLAG"] = loanInfo.LOCK_FLAG;
		send_data["USE_YN"] = loanInfo.USE_YN;
		
// 		console.log(send_data);
		if(loan_yn=="Y" && trust_yn =="Y"){
			$erp.alertMessage({
				"alertMessage" : "외상/여신거래를 동시에 이용할 수 없습니다.",
				"alertType" : "error",
				"isAjax" : false
			});
		}else{
			var if_success = function(data){
				if($erp.isEmpty(data.result)){
					
				}else{
					if(data.result.ERROR_CNT == 0){
						$erp.alertMessage({
							"alertMessage" : 'info.common.saveSuccess',
							"alertType" : "alert",
							"isAjax" : true,
							"alertCallbackFn" : function(){
								getMemberInfo(data.result);
							},
						});
					}else{
						$erp.alertMessage({
							"alertMessage" : 'info.common.errorsaveSuccess',
							"alertType" : "alert",
							"isAjax" : true,
							"alertCallbackFn" : function(){}
						});
					}
				}
			}
			
			var if_error = function(){
				
			}
			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			
			var formData = new FormData();
			formData.append("EVI_FILE",loanInfo.LOAN_FILE);
			
// 			total_layout.progressOn();
// 			$.ajax({
// 				url : "/sis/price/saveLoanFromPopup.do"
// 				,data : formData
// 				,method : "POST"
// 				,dataType : "JSON"
// 				, processData: false
// 				, contentType: false
// 				,success : function(data) {
// 					total_layout.progressOff();
// 					if(data.isError){
// 						$erp.ajaxErrorMessage(data);
// 					}else {
// 						var resultCnt = data.ResultCnt;
// 						console.log(typeof resultCnt);
// 						if(resultCnt > 0){
// 							$erp.alertMessage({
// 								"alertMessage" : "info.common.saveSuccess.",
// 								"alertType" : "alert",
// 								"isAjax" : false
// 							});
// 						}else {
// 							$erp.alertMessage({
// 								"alertMessage" : "info.common.errorsaveSuccess",
// 								"alertType" : "alert",
// 								"isAjax" : false
// 							});
// 						}
// 					}
// 				}, error : function(jqXHR, textStatus, errorThrown){
// 					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
// 				}
// 			});
		}
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
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="*">
					</colgroup>
					
					<tr>
						<th colspan="2">법인구분</th>
						<td colspan="3"><div id="cmbORGN_DIV_CD"></div></td>
						<th colspan="2">조직명</th>
						<td colspan="4"><div id="cmbORGN_CD"></div></td>
					</tr>
					
					<tr>
						<th colspan="1">회원번호</th>
						<td colspan="2"><input type="text" id="txtMEM_NO" class="input_text input_readonly" value="" readonly disabled/></td>
					
						<th align="center"><input type="button" id="" class="input_common_button" value="바코드" onClick="" style="width:100%"/></th>
						<td colspan="2" style="border-left: 0px;"><input type="text" id="txtMEM_BCD" class="input_text" value=""/></td>
						
						<th colspan="1">회원상태</th>
						<td colspan="4"><div id="cmbMEM_STATE"></div></td>
					</tr>
					
					<tr>
						<th>회원유형</th>
						<td colspan="2"><div id="cmbMEM_TYPE"></div></td>
						
						<th>도매등급</th>
						<td colspan="2"><div id="cmbPRICE_POLI"></div></td>
						
						<th>ABC</th>
						<td colspan="2"><div id="cmbMEM_ABC"></div></td>
						
						<th align="center"><input type="button" id="" class="input_common_button" value="담당직원" onClick="" style="width:100%"/></th>
						<td colspan="1" style="border-left: 0px;">
							<input type="hidden" id="txtRESP_USER" class="input_text input_readonly" value="" readonly/>
							<input type="text" id="txtRESP_USER_NAME" class="input_text input_readonly" value="" readonly style="width: 65px; float: left;"/>
						</td>
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
						<td colspan="2"><input type="text" id="txtMEM_NM" class="input_text" value=""></td>
						
						<th>가족수</th>
						<td><input type="text" id="txtFAMILY_CNT" class="input_text" value=""></td>
						<td>인</td>
						
						<td colspan="4"><div id="rdoSEX_TYPE"></div></td>
						
					</tr>
					
					<tr>
						<th>전화1</th>
						<td colspan="2"><input type="text" id="txtTEL_NO01" class="input_text" value=""></td>
						<td colspan="7"></td>
<!-- 						<th>생일</th> -->
<!-- 						<td colspan="6"> -->
<!-- 							<input type="text" id="txtBIRTH_DATE" class="input_calendar default_date" data-position="" value=""> -->
<!-- 							<div id="chkBIRTH_TYPE"></div> -->
<!-- 						</td> -->
					</tr>
					<tr>
						<th>전화2</th>
						<td colspan="2"><input type="text" id="txtTEL_NO02" class="input_text" value=""></td>
						<td colspan="7"></td>
<!-- 						<th>기념일</th> -->
<!-- 						<td colspan="6"><input type="text" id="txtWED_DATE" class="input_calendar default_date" data-position="" value=""></td> -->
					</tr>
					
					<tr>
						<th>휴대폰</th>
						<td colspan="2"><input type="text" id="txtPHON_NO" class="input_text" value=""></td>
						<th>E-mail</th>
						<td colspan="6"><input type="text" id="txtEMAIL" class="input_text" value=""></td>
					</tr>
					
					<tr>
						<th colspan="1">SMS 수신</th>
						<td colspan="2"><div id="chkSMS_YN"></div></td>
						<th colspan="1">소액처리</th>
						<td colspan="2">
							<div id="cmbCHG_AMT_TYPE"></div>
						</td>
						<td colspan="4"></td>
					</tr>
					
					<tr>
						<th>현금영수증</th>
						<td colspan="9">
							<div style="float:left;" id="chkCASH_RECP_YN"></div>
							<div style="float:left;" id="cmbCASH_RECP_TYPE"></div>
							<input type="text" id="txtLAST_CASH_RECP_NO" class="input_text" value=""style="width: 125px; float:left; margin-left: 5px;" readonly/>
							<div style="float:left; margin-left: 5px;" id="cmbLAST_CASH_RECP_TYPE"></div>
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
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="70px">
						<col width="*">
					</colgroup>
					
					<tr>
						<th colspan="3" style="text-align: center">사업자정보</th>
						<th colspan="6" style="text-align: center">거래정보</th>
						<th colspan="2" style="text-align: center">포인트</th>
					</tr>
					
					<tr>
						<th colspan="1">상호</th>
						<td colspan="2"><input type="text" id="txtCORP_NM" class="input_text" value=""></td>
						
						<fmt:bundle basename="" >
						
							<td colspan="2" ><div id="chkTAX_YN" style="float:left;"></div></td>
							
							<th colspan="1" style="width: 95%;" >결제일</th>
							<td colspan="3" ><div id="cmbPAY_DATE_CD"></div></td>
						
						</fmt:bundle>
						
						
						<td colspan="1"><input type="button" id="" class="input_common_button" value="현재포인트" onClick=""/></td>
						<td colspan="1" style="border-left: 0px;"><input type="text" id="txtPOINT" class="input_text input_money" value=""></td>
					</tr>
					
					<tr>
						<th colspan="1">사업자번호</th>	
						<td colspan="2"><input type="text" id="txtCORP_NO" class="input_text" value="" data-type="businessNum"></td>
						
						<th colspan="1">외상거래</th>
						<td colspan="5" ><div id="cmbTRUST_YN" style="float:left;"></div></td>
						
						<td colspan="1"><input type="button" id="" class="input_common_button" value="누적포인트" onClick=""/></td>
						<td colspan="1" style="border-left: 0px;"><input type="text" id="txtPOINT_SUM" class="input_text input_money" value=""></td>
					</tr>
					
					<tr id="trust">
<!-- 						<th colspan="1">업태</th>						 -->
<!-- 						<td colspan="2"><input type="text" id="txtBUSI_COND" class="input_text" value=""></td> -->
						
<!-- 							<td colspan="1" style="font-weight: bold; text-align: right;">외상횟수</td> -->
<!-- 							<td colspan="2"><input type="text" id="txtTRUST_CNT" class="input_text input_money" value=""/></td> -->
<!-- 							<td colspan="3"></td> -->
						
<!-- 						<td colspan="2"></td> -->
					</tr>
					
					<tr>
						<th colspan="1">업종</th>
						<td colspan="2"><input type="text" id="txtBUSI_TYPE" class="input_text" value=""></td>
						
						<th colspan="1">여신거래</th>
						<td colspan="5"><div id="cmbLOAN_YN" style="float:left;"></div>
						<input type="hidden" id="txtLOAN_CD" class="input_text" value=""/>
						</td>
						<td colspan="2"></td>
					</tr>
					
					<tr id="loan">
<!-- 						<th colspan="1"><input type="button" id="table_3_ZIP_NO" class="input_common_button" value="우편번호" onClick="openSearchPostAddrPopup(this);"/></th> -->
<!-- 						<td colspan="2"><input type="text" id="txtCORP_ZIP_NO" class="input_text input_readonly" value="" readonly></td> -->
						
<!-- 							<td colspan="1" style="width: 95%; font-weight: bold; text-align: right;" >여신한도</td> -->
<!-- 							<td colspan="2" ><input type="text" id="txtLOAN_AMT" class="input_text input_money" value=""></td> -->
<!-- 							<td colspan="1" style="width: 95%; font-weight: bold; text-align: right;" >여신잔액</td> -->
<!-- 							<td colspan="2" ><input type="text" id="txtBAL_AMT" class="input_text input_money" value=""></td> -->
						
<!-- 						<td colspan="2"></td> -->
					</tr>
					
					<tr>
						<th colspan="1">도로명</th>
						<td colspan="10"><input type="text" id="txtCORP_R_ADDR" class="input_text input_readonly" value="" readonly></td>
					</tr>
					
					<tr>
						<th colspan="1">지번</th>
						<td colspan="10"><input type="text" id="txtCORP_L_ADDR" class="input_text input_readonly" value="" readonly></td>
					</tr>
					
					<tr>
						<th colspan="1">상세주소</th>
						<td colspan="10"><input type="text" id="txtCORP_ADDR_DETL" class="input_text" value=""></td>
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
						<td colspan="2" style="border-right: 0px;"><input type="text" id="txtDELI_ZIP_NO" class="input_text input_readonly" value="" readonly></td>
						<td colspan="7"></td>
					</tr>
					<tr>
						<th colspan="1">주소</th>
						<td colspan="9"><input type="text" id="txtDELI_ADDR" class="input_text input_readonly" value="" readonly></td>
					</tr>
					<tr>
						<th colspan="1">상세주소</th>
						<td colspan="9"><input type="text" id="txtDELI_ADDR_DETL" class="input_text" value=""></td>
					</tr>
					<tr>
						<th colspan="1">배송메모</th>
						<td colspan="9"><input type="text" id="txtDELI_MEMO" class="input_text" value=""></td>
					</tr>
					<tr>
						<th colspan="1">기타메모</th>
						<td colspan="8"><input type="text" id="txtETC_MEMO" class="input_text" value=""></td>
						<td colspan="1">◀계산시 OPR 하단 표시</td>
					</tr>
					
					<tr>
						<th colspan="1">등록일시</th>
						<td colspan="3"><input type="text" id="txtCDATE" class="input_text" value=""/></td>
						<th colspan="1">최종방문</th>
						<td colspan="3"><input type="text" id="txtLAST_TRADE_DATE" class="input_text" value=""/></td>
						<td colspan="2"></td>
					</tr>
					
					<tr>
						<td colspan="10">
							<div align="center">
								<input type="button" id="" class="input_common_button" value="닫기" onClick="thisOnComplete();" style="width:60px;"/>
								<input type="button" id="" class="input_common_button" value="저장" onClick="crudMemberInfo();" style="width:60px;"/>
							</div>
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
							<input type="text" id="txtTAB_2_DATE_FR" class="input_calendar default_date" data-position="-1:(1)" value="">
							<span style="float: left; margin-right: 5px;">~</span> 
							<input type="text" id="txtTAB_2_DATE_TO" class="input_calendar default_date" data-position="" value="">
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
							<input type="text" id="txtTAB_3_DATE_FR" class="input_calendar default_date" data-position="-1:(1)" value="">
							<span style="float: left; margin-right: 5px;">~</span>
							<input type="text" id="txtTAB_3_DATE_TO" class="input_calendar default_date" data-position="" value="">
						</td>
						<td colspan="3"><div id="rdoORDER_BY"></div></td>
						<th colspan="1" align="right"><div id="chkTOP_COUNT_TAB_3_chk"></div></th>
						<td colspan="1"><input type="text" id="txtTOP_COUNT_TAB_3" class="input_text input_number" value=""></td>
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
							<input type="text" id="txtTAB_4_DATE_FR" class="input_calendar default_date" data-position="-1:(1)" value="">
							<span style="float: left; margin-right: 5px;">~</span>
							<input type="text" id="txtTAB_4_DATE_TO" class="input_calendar default_date" data-position="" value="">
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
					</colgroup>
					<tr>
						<td colspan="1"></td>
						<th colspan="1">구매합계</th>
						<th colspan="1">공급가액</th>
						<th colspan="1">부가세액</th>
						<th colspan="1">현금구매</th>
						<th colspan="1">카드구매</th>
						<th colspan="1">상품권구매</th>	
						<th colspan="1">포인트구매</th>	
						<th colspan="1">방문수</th>
						<th colspan="1">포인트</th>
					</tr>
					<tr id="tab_4_gridSum">
						<th colspan="1">합계</th>
						<td colspan="1"><input type="text" id="txtSALE_TOT_AMT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtSALE_AMT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtSALE_VAT_AMT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtPAY_CASH" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtPAY_CARD" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtPAY_GIFT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtPAY_POINT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtBILL_NO_CNT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtADD_POINT" class="input_text input_readonly" value="" readonly disabled></td>
					</tr>
					<tr id="tab_4_gridAvgByMonth">
						<th colspan="1">월 평균</th>
						<td colspan="1"><input type="text" id="txtAVG_SALE_TOT_AMT_BYMONTH" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_SALE_AMT_BYMONTH" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_SALE_VAT_AMT_BYMONTH" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_PAY_CASH_BYMONTH" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_PAY_CARD_BYMONTH" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_PAY_GIFT_BYMONTH" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_PAY_POINT_BYMONTH" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_BILL_NO_CNT_BYMONTH" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_ADD_POINT_BYMONTH" class="input_text input_readonly" value="" readonly disabled></td>
					</tr>
					<tr id="tab_4_gridAvgByCount">
						<th colspan="1">1회평균</th>
						<td colspan="1"><input type="text" id="txtAVG_SALE_TOT_AMT_BYCOUNT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_SALE_AMT_BYCOUNT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_SALE_VAT_AMT_BYCOUNT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_PAY_CASH_BYCOUNT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_PAY_CARD_BYCOUNT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_PAY_GIFT_BYCOUNT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"><input type="text" id="txtAVG_PAY_POINT_BYCOUNT" class="input_text input_readonly" value="" readonly disabled></td>
						<td colspan="1"></td>
						<td colspan="1"><input type="text" id="txtAVG_ADD_POINT" class="input_text input_readonly" value="" readonly disabled></td>
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
							<input type="text" id="txtTAB_5_DATE_FR" class="input_calendar default_date" data-position="" value="">
							<span style="float: left; margin-right: 5px;">~</span> 
							<input type="text" id="txtTAB_5_DATE_TO" class="input_calendar default_date" data-position="" value="">
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
							<input type="text" id="txtTAB_6_DATE_FR" class="input_calendar default_date" data-position="" value="">
							<span style="float: left; margin-right: 5px;">~</span>
							<input type="text" id="txtTAB_6_DATE_TO" class="input_calendar default_date" data-position="" value="">
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