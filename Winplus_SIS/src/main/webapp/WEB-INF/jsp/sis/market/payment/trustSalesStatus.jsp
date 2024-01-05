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
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	var total_layout;
	
	var top_layout;
	
	var mid_layout;
	var mid_layout_ribbon;
	
	var bot_layout;
	var bot_layout_grid;
	var cmbORGN_CD;
	
	$(document).ready(function(){		
		init_total_layout();
		init_top_layout();
		init_mid_layout();
		init_bot_layout();
		
		$erp.asyncObjAllOnCreated(function(){
			if(AUTHOR_CD != "99999"){
			cmbORGN_CD.disable();
			}
	      });
		
		
	});
	
	function init_total_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건", header:false, fix_size:[true, true]}
				, {id: "b", text: "리본", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드", header:false}
			]
		});
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight($erp.getTableHeight(2));
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(36);
		total_layout.cells("c").attachObject("div_bot_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
		
	}
	
	function init_top_layout(){
		cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD2","","","2300"], 110, null, false, LUI.LUI_orgn_cd, null, null);
		cmbMEM_TYPE = $erp.getDhtmlXComboCommonCode("cmbMEM_TYPE", "MEM_TYPE", "MEM_TYPE", 110, "회원유형", false, "");
		cmbMEM_ABC = $erp.getDhtmlXComboCommonCode("cmbMEM_ABC", "MEM_ABC", "MEM_ABC", 230, "ABC회원그룹", false, "");
		chkMEM_STATE = $erp.getDhtmlXCheckBox('chkMEM_STATE', '무효포함', '1', false, 'label-right');
	}
	
	function init_mid_layout(){
		ribbon = new dhtmlXRibbon({
			parent : "div_mid_layout"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
				           {
				        	   type : "block"
				        	   , mode : 'rows'
			        		   , list : [
			        		             {id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 			        		             , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
// 			        		             , {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
// 			        		             , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
			        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
			        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true, unused : true}		
			        		             ]
				           }							
				           ]
		});
		
		ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				isSearchValidate();
			} else if (itemId == "add_grid"){
					
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				$erp.exportDhtmlXGridExcel({
				     "grid" : bot_layout_grid
				   , "fileName" : "외상매출현황"
				   , "isForm" : false
				   , "isHiddenPrint" : "Y"
				});
			} else if (itemId == "print_grid"){
				$erp.alertMessage({
	            	"alertMessage" : "준비중입니다.",
					"alertType" : "alert",
					"isAjax" : false
	            });
			}
		});
	}
	
		
	function init_bot_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA

		var grid_Columns = [
		                    {id : "NO", label:["순번", "#rspan"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false,numberFormat : "0,000"}
		                    , {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
							, {id : "MEM_NO", label:["고객코드", "#rspan"], type : "ro", width : "120", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "ORGN_CD", label:["직영점", "#rspan"], type : "ro", width : "120", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "LOAN_CD", label:["여신코드", "#rspan"], type : "ro", width : "120", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "MEM_NM", label:["고객명", "#rspan"], type : "ro", width : "120", sort : "str", align : "left", isHidden : false, isEssential : true}
		//                  , {id : "MEM_ABC", label:["ABC", "#text_filter"], type : "combo", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "MEM_MEM_ABC"}
		                    , {id : "UPD_AMT", label:["전기이월", "#rspan"], type : "ron", width : "150", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "SUM_OUT", label:["외상매출", "#rspan"], type : "ron", width : "150", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "SUM_IN", label:["외상결제", "#rspan"], type : "ron", width : "150", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
//		                    , {id : "4", label:["외상할인", "#rspan"], type : "ron", width : "150", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
//		                    , {id : "5", label:["외상손실", "#rspan"], type : "ron", width : "150", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "BAL_AMT", label:["미수금잔액", "#rspan"], type : "ron", width : "150", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "LOAN_AMT", label:["여신한도금액", "#rspan"], type : "ron", width : "150", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "LAST_DATE", label:["최종거래일시", "#rspan"], type : "ro", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    ];
		
		bot_layout_grid = new dhtmlXGridObject({
			parent: "div_bot_layout"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		$erp.attachDhtmlXGridFooterSummary(bot_layout_grid
											, ["UPD_AMT"
												,"SUM_OUT"
												,"SUM_IN"
//												,"4"
//												,"5"
												,"BAL_AMT"
												,"LOAN_AMT"]
											,1
											,"합계");
		
		$erp.initGrid(bot_layout_grid,{multiSelect : true});
		
 		bot_layout_grid.attachEvent("onRowDblClicked", function (rowId,columnIdx){
 			openDetail();
		}); 
	}
	
	function isSearchValidate() {
	    var fr = $("#txtDATE_FR").val();
	    var to = $("#txtDATE_TO").val();
	    var custmr_nm = $("#txtKEY_WORD").val();
		console.log(custmr_nm)
	    var a = fr.replace(/-/gi,'')
	    var b = to.replace(/-/gi,'')

	    var date = b - a

		var regular_expression = /[~!@#$%^&*()_+|<>?:{}]/;

	        <%--기간 유효성 검사--%>
	        if (date < 0) {
	            $erp.alertMessage({
	            	"alertMessage" : "<기간>이 유효한지 확인하세요.",
					"alertType" : "alert",
					"isAjax" : false
	            });
	        <%--고객명 유효성 검사--%>
	        } else if(custmr_nm != "") {
	        	if(regular_expression.test(custmr_nm) == true) {
	        		$erp.alertMessage({
		            	"alertMessage" : "특수문자로 조회할 수 없습니다.",
						"alertType" : "alert",
						"isAjax" : false
		            });
	        	} else {
	        		searchGrid();
	        	}
	        } else {
	        	searchGrid();
	        }
	}
	
	function searchGrid() {
		var dataObj = $erp.dataSerialize("tb_search");
		var url = "/sis/market/payment/getTrustSalesStatus.do";
		var send_data = $erp.unionObjArray([LUI,dataObj]);
		console.log(send_data);
		var if_success = function(data){
			$erp.clearDhtmlXGrid(bot_layout_grid); //기존데이터 삭제
			if($erp.isEmpty(data.gridDataList)){
				//검색 결과 없음
				$erp.addDhtmlXGridNoDataPrintRow(bot_layout_grid, '<spring:message code="info.common.noDataSearch" />');
			}else{
				bot_layout_grid.parse(data.gridDataList,'js');
			}
			$erp.setDhtmlXGridFooterRowCount(bot_layout_grid); // 현재 행수 계산
			$erp.setDhtmlXGridFooterSummary(bot_layout_grid
											, ["UPD_AMT"
												,"SUM_OUT"
												,"SUM_IN"
//												,"4"
//												,"5"
												,"BAL_AMT"
												,"LOAN_AMT"]
											,1
											,"합계");
		}
		
		var if_error = function(){
			
		}
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
	function openDetail() {
		var selectedRow = bot_layout_grid.getSelectedRowId();
		var ORD_CD;
		var LOAN_CD;
		var MEM_NO;
		if(selectedRow != null){
			ORGN_CD = bot_layout_grid.cells(selectedRow,bot_layout_grid.getColIndexById("ORGN_CD")).getValue();//주문번호
			LOAN_CD = bot_layout_grid.cells(selectedRow,bot_layout_grid.getColIndexById("LOAN_CD")).getValue();//주문번호
			MEM_NO = bot_layout_grid.cells(selectedRow,bot_layout_grid.getColIndexById("MEM_NO")).getValue();//주문번호
		}

        var call_popup_windowName = "openTrustSalesStatusDetail";
        console.log("ORD_CD 주문번호22>> " + ORD_CD);
		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window( call_popup_windowName );
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		var onConfirm = function(){
		}
		var params = {"ORGN_CD" : ORGN_CD
					, "LOAN_CD" : LOAN_CD
					, "MEM_NO" : MEM_NO
		}
			console.log(params);
		var option =  "";
			console.log("openTrustSalesStatusDetail.sis");
		var option =  {
				"win_id" : "openTrustSalesStatusDetail",
				"width"  : 1400,
				"height" : 800
			   }
		var url = "/sis/market/payment/openTrustSalesStatusDetail.sis";
		
		var parentWindow = parent;
		var onContentLoaded = function(){
			var popWin = this.getAttachedObject().contentWindow;
			if(parentWindow && typeof parentWindow === 'object'){
				while(popWin.thisParentWindow == undefined){
					popWin.thisParentWindow = parentWindow;
				}
			}
			if(onConfirm && typeof onConfirm === 'function'){
				while(popWin.thisOnConfirm == undefined){
					popWin.thisOnConfirm = onConfirm;    		
				}
			}
			if(onComplete && typeof onComplete === 'function'){
				while(popWin.thisOnComplete == undefined){
					popWin.thisOnComplete = onComplete;    
				}
			}
			this.progressOff();
		}
		$erp.openPopup(url, params, onContentLoaded, option); 
	}
	
</script>
</head>
<body>		

	<div id="div_top_layout" class="samyang_div" style="display:none">
		<div id="div_top_layout_search" class="samyang_div">
			<table id="tb_search" class="table">
				<colgroup>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th colspan="1">기간</th>
					<td colspan="2">
						<input type="text" id="txtDATE_FR" class="input_calendar default_date" data-position="(1)" value="">
						<span style="float: left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO" class="input_calendar default_date" data-position="" value="" style="float: left; margin-left: 6px;">
					</td>
					<th colspan="1">조직명</th>
					<td colspan="1"><div id="cmbORGN_CD"></div></td>
					<td colspan="5"></td>
				</tr>
				<tr>
					<th colspan="1">고객명</th>
					<td colspan="2"><input type="text" id="txtKEY_WORD" name="KEY_WORD" maxlength="10" onkeydown="" style="width:210px;height:17px"></td>
					<td colspan="1"><div id="cmbMEM_TYPE"></div></td>
					<td colspan="2"><div id="cmbMEM_ABC"></div></td>
					<td colspan="4"><div id="chkMEM_STATE"></div></td>
				</tr>
			</table>
		</div>
	</div>

	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bot_layout" class="div_grid_full_size" style="display:none"></div>
</body>
</html>