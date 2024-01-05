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
	
	var total_layout;
	
	var top_layout;
	
	var mid_layout;
	var mid_layout_ribbon;
	
	var bottom_layout;
	var bottom_layout_grid;
	
	$(document).ready(function(){		
		init_total_layout();
		init_top_layout();
		init_mid_layout();
		init_bottom_layout();

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
		total_layout.cells("c").attachObject("div_bottom_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
		
	}
	
	function init_top_layout(){
		cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK"], 110, null, false, LUI.LUI_orgn_cd, null, null);

		chkINCLUDE_ZERO_AMT = $erp.getDhtmlXCheckBox('chkINCLUDE_ZERO_AMT', '0값 포함', '1', false, 'label-right');
		cmbTRUST_PURCHASE_TYPE = $erp.getDhtmlXComboCommonCode("cmbTRUST_PURCHASE_TYPE", "TRUST_PURCHASE_TYPE", "TRUST_PURCHASE_TYPE", 230, "외상매입유형", false, null);
		cmbSUPR_PAY_DATE_TYPE = $erp.getDhtmlXComboCommonCode("cmbSUPR_PAY_DATE_TYPE", "SUPR_PAY_DATE_TYPE", "SUPR_PAY_DATE_TYPE", 230, "결제일", false, null);
		chkINCLUDE_UNUSED_SUPR = $erp.getDhtmlXCheckBox('chkINCLUDE_UNUSED_SUPR', '무효포함', '1', false, 'label-right');
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
			        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
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
				     "grid" : bottom_layout_grid
				   , "fileName" : "외상매입현황"
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
	function isSearchValidate() {
	    var fr = $("#txtDATE_FR").val();
	    var to = $("#txtDATE_TO").val();

	    var a = fr.substring(0, 4) + fr.substring(5, 7) + fr.substring(8, 10);
	    var b = to.substring(0, 4) + to.substring(5, 7) + to.substring(8, 10);

	    var date = b - a

		var special_pattern = /[~!@#$%^&*()_+|<>?:{};0-9]/;

	        <%--기간 유효성 검사--%>
	        if (date < 0) {
	            $erp.alertMessage({
	            	"alertMessage" : "시작 날짜와 종료 날짜를 확인하세요.",
					"alertType" : "alert",
					"isAjax" : false
				});
			}
			<%--정상--%>
			else if(date >= 0){
				searchErpGrid();
	        }
	}
	
	function searchErpGrid() {	
		var dataObj = $erp.dataSerialize("tb_search");
		var url = "/sis/market/payment/getTrustPurchaseStatus.do";
		var send_data = $erp.unionObjArray([LUI,dataObj]);
		console.log(send_data);
		var if_success = function(data){
			$erp.clearDhtmlXGrid(bottom_layout_grid); //기존데이터 삭제
			if($erp.isEmpty(data.gridDataList)){
				//검색 결과 없음
				$erp.addDhtmlXGridNoDataPrintRow(bottom_layout_grid, '<spring:message code="info.common.noDataSearch" />');
			}else{
				bottom_layout_grid.parse(data.gridDataList,'js');
			}
			$erp.setDhtmlXGridFooterRowCount(bottom_layout_grid); // 현재 행수 계산
			$erp.setDhtmlXGridFooterSummary(bottom_layout_grid
											, [""
												,""
												,""
												,""
												,""
												,""]
											,1
											,"합계");
		}
		var if_error = function(){
			
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
	function init_bottom_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
		                    {id : "NO", label:["NO"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false,numberFormat : "0,000"}
		                    , {id : "CUSTMR_CD", label:["공급사코드", "#text_filter"], type : "ro", width : "120", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "CUSTMR_NM", label:["공급사명", "#text_filter"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "", label:["전기이월", "#text_filter"], type : "ron", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "", label:["매입금액", "#text_filter"], type : "ron", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "", label:["결제[지급]", "#text_filter"], type : "ron", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "", label:["결제(할인)", "#text_filter"], type : "ron", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "", label:["잔액", "#text_filter"], type : "ron", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "", label:["최종매입", "#text_filter"], type : "ron", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "", label:["상품재고액", "#text_filter"], type : "ron", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    ];
		
		bottom_layout_grid = new dhtmlXGridObject({
			parent: "div_bottom_layout"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		$erp.attachDhtmlXGridFooterSummary(bottom_layout_grid
											, [""
												,""
												,""
												,""
												,""
												,""]
											,1
											,"합계");
		
		$erp.initGrid(bottom_layout_grid,{multiSelect : true});
		
		bottom_layout_grid.attachEvent("onRowDblClicked", function (rowId,columnIdx){
			//!@#!@# 더블클릭시 해당공급사 정보를 파싱하여 "공급사별 거래내역" 페이지가 열려야함
		});
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
						<input type="text" id="txtDATE_FR" class="input_calendar default_date" data-position="-7" value="">
						<span style="float: left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO" class="input_calendar default_date" data-position="" value="" style="float: left; margin-left: 6px;">
					</td>
					<th colspan="1">조직명</th>
					<td colspan="1"><div id="cmbORGN_CD"></div></td>
					<td colspan="5"><div id="chkINCLUDE_UNUSED_SUPR"></div></td>
				</tr>
				<tr>
					<th colspan="1">외상매입액</th>
					<td colspan="1"><div id="chkINCLUDE_ZERO_AMT"></div></td>
					<td colspan="2"><div id="cmbTRUST_PURCHASE_TYPE"></div></td>
					<td colspan="6"><div id="cmbSUPR_PAY_DATE_TYPE"></div></td>
				</tr>

			</table>
		</div>
	</div>

	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bottom_layout" class="div_grid_full_size" style="display:none"></div>
</body>
</html>