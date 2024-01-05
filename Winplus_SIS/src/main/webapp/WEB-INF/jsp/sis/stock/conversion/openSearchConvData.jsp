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
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openSearchConvData");
	var convInfo = JSON.parse('${convInfo}');
	var erpPopupLayout;
	var erpPopupLeftLayout;
	var erpPopupRightLayout;
	var erpPopupLeftGrid;
	var erpPopupLeftGridColumns;
	var erpPopupRightGrid;
	var erpPopupRightGridColumns;
	
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("대출입");
		}
		
		initErpPopupLayout();
		
		initErpPopupLeftLayout();
		initErpPopupLeftGrid();
		
		initErpPopupRightLayout();
		initErpPopupRightGrid();
		initDhtmlXCombo();
		initConvInfo();
	});
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "대출입정보헤더영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "그리드영역(원물)", header:false, fix_size : [true, true]}
				,{id: "c", text: "그리드영역(대물)", header:false, fix_size : [true, true]}
			]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_table");
		erpPopupLayout.cells("a").setHeight($erp.getTableHeight(1));
		erpPopupLayout.cells("b").attachObject("div_erp_popup_left_layout");
		erpPopupLayout.cells("b").setHeight(200);
		erpPopupLayout.cells("c").attachObject("div_erp_popup_right_layout");
	}
	<%-- ■ erpPopupLayout 관련 Function 끝 --%>

	<%-- ■ erpPopupLeftLayout 관련 Function 시작 --%>
	function initErpPopupLeftLayout(){
		erpPopupLeftLayout = new dhtmlXLayoutObject({
			parent: "div_erp_popup_left_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "그리드영역", header:false , fix_size:[true, true]}
			]		
		});
		erpPopupLeftLayout.cells("a").attachObject("div_erp_popup_left_grid");
	}	
	<%-- ■ erpPopupLeftLayout 관련 Function 끝 --%>
	
	<%-- ■ erpPopupLeftGrid 관련 Function 시작 --%>
	function initErpPopupLeftGrid(){
		erpPopupLeftGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false, isEssential : false}
			//{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "HID_BCD_CD", label:["바코드_히든", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "BCD_CD", label:["바코드", "#rspan"], type: "ron", width: "105", sort : "str", align : "left", isHidden : false, isEssential : true, isSelectAll : true, maxLength : 20}
			,{id : "BCD_NM", label:["품목명", "#rspan"], type: "ro", width: "260", sort : "str", align : "left", isHidden : false, isEssential : false, isSelectAll : true, maxLength : 100}
			,{id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "70", sort : "str", align : "center", isHidden : false, isEssential : false}
			,{id : "STD_PRICE", label:["기준단가(VAT제외)", "#rspan"], type: "ron", width: "112", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 20}
			,{id : "CONV_QTY", label:["수량", "#rspan"], type: "ron", width: "50", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 20}
			,{id : "ORI_TOT_AMT", label:["금액(VAT제외)", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 20}
			,{id : "TAX_YN", label : ["부가세여부", "#rspan"], type : "combo", width : "70", sort : "str", align : "center", isHidden : true, isEssential : false, isDisabled : true, commonCode : ["TAX_TYPE"]}
		];
		
		erpPopupLeftGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_left_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupLeftGridColumns
		});
		
		erpPopupLeftGrid.enableDistributedParsing(true, 100, 50);
		var text_style = "text-align:right; font-weight:bold; font-style:normal";
		var tot_style = "text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;";
		erpPopupLeftGrid.attachFooter('합계,#cspan,#cspan,#cspan,#cspan,#cspan,<div id="oriTotalAmt">0</div>,',[tot_style,"","","","","",text_style]);
		$erp.initGridCustomCell(erpPopupLeftGrid);
		$erp.initGridComboCell(erpPopupLeftGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupLeftGrid, '<spring:message code="grid.allRowCount" />');
	}
	
	function calculateFooterValuesLeftGrid(stage){
		document.getElementById("oriTotalAmt").innerHTML = moneyType(sumColumnLeftGrid(erpPopupLeftGrid.getColIndexById("ORI_TOT_AMT")));
	}
	
	function moneyType(amt){
		return amt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function sumColumnLeftGrid(ind){
		var allRowIds = erpPopupLeftGrid.getAllRowIds();
		var allRowArray = [];
		var out = 0;
		var tmpLeftDpState = "";
		
		if(allRowIds != ""){
			allRowArray = allRowIds.split(",");
			for(var i=0; i<allRowArray.length; i++){
				out+= erpPopupLeftGrid.cells(allRowArray[i],ind).getValue()*1;
			}
		}
		return out;
	}
	<%-- ■ erpPopupLeftGrid 관련 Function 끝 --%>
	
	<%-- ■ erpPopupRightLayout 관련 Function 시작 --%>
	function initErpPopupRightLayout(){
		erpPopupRightLayout = new dhtmlXLayoutObject({
			parent: "div_erp_popup_right_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "그리드영역", header:false , fix_size:[true, true]}
			]		
		});
		erpPopupRightLayout.cells("a").attachObject("div_erp_popup_right_grid");
	}	
	<%-- ■ erpPopupRightLayout 관련 Function 끝 --%>
	
	<%-- ■ erpPopupRightGrid 관련 Function 시작 --%>
	function initErpPopupRightGrid(){
		erpPopupRightGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false, isEssential : false}
			//{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "HID_BCD_CD", label:["바코드_히든", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "BCD_CD", label:["바코드", "#rspan"], type: "ron", width: "105", sort : "str", align : "left", isHidden : false, isEssential : true, isSelectAll : true, maxLength : 20}
			,{id : "BCD_NM", label:["품목명", "#rspan"], type: "ro", width: "260", sort : "str", align : "left", isHidden : false, isEssential : false, isSelectAll : true, maxLength : 100}
			,{id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "70", sort : "str", align : "center", isHidden : false, isEssential : false}
			,{id : "STD_PRICE", label:["기준단가(VAT제외)", "#rspan"], type: "ron", width: "112", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 20}
			,{id : "CONV_PRICE", label:["단가(VAT제외)", "#rspan"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000.00", isSelectAll : true, maxLength : 20}
			,{id : "CONV_QTY", label:["수량", "#rspan"], type: "ron", width: "50", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 20}
			,{id : "CONV_TOT_AMT", label:["금액(VAT제외)", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 20}
			,{id : "TAX_YN", label : ["부가세여부", "#rspan"], type : "combo", width : "70", sort : "str", align : "center", isHidden : true, isEssential : false, isDisabled : true, commonCode : ["TAX_TYPE"]}
		];
		
		erpPopupRightGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_right_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupRightGridColumns
		});
		
		erpPopupRightGrid.enableDistributedParsing(true, 100, 50);
		var text_style = "text-align:right; font-weight:bold; font-style:normal";
		var tot_style = "text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;";
		erpPopupRightGrid.attachFooter('합계,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,<div id="replcTotalAmt">0</div>,',[tot_style,"","","","","","",text_style]);
		$erp.initGridCustomCell(erpPopupRightGrid);
		$erp.initGridComboCell(erpPopupRightGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupRightGrid, '<spring:message code="grid.allRowCount" />');
	}
	
	function calculateFooterValuesRightGrid(stage){
		document.getElementById("replcTotalAmt").innerHTML = moneyType(sumColumnRightGrid(erpPopupRightGrid.getColIndexById("CONV_TOT_AMT")));
	}
	
	function moneyType(amt){
		return amt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function sumColumnRightGrid(ind){
		var allRowIds = erpPopupRightGrid.getAllRowIds();
		var allRowArray = [];
		var out = 0;
		var tmpRightDpState = "";
		
		if(allRowIds != ""){
			allRowArray = allRowIds.split(",");
			for(var i=0; i<allRowArray.length; i++){
				out+= erpPopupRightGrid.cells(allRowArray[i],ind).getValue()*1;
			}
		}
		return out;
	}
	<%-- ■ erpPopupRightGrid 관련 Function 끝 --%>
	
	<%-- ■ dhtmlXCombo 관련 Function 시작 --%>
	function initDhtmlXCombo(){
		var convOrgnCd = convInfo.ORGN_CD;
		var convOrgnDivCd = convInfo.ORGN_DIV_CD;
		cmbORGN_DIV_CD = convOrgnDivCd;
		cmbORGN_CD = $erp.getDhtmlXCombo("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","MK",null,null,null,"MK"] , 100, null, convOrgnCd);
		cmbORGN_CD.disable();
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	<%-- ■ 기타 Function 시작 --%>
	function initConvInfo(){
		var convDate = convInfo.CONV_DATE;
		var convYear = convDate.substring(0,4);
		var convMonth = convDate.substring(4,6);
		var convDay = convDate.substring(6,8);
		convDate = convYear + "-" + convMonth + "-" + convDay;
		
		document.getElementById("popConvDate").value = convDate;
		
		if(convInfo.CONV_CD == ""){
			document.getElementById("hidConvCd").value = "";
			document.getElementById("hidConvState").value = "";
			document.getElementById("hidOriSendType").value = "";
			document.getElementById("hidReplcSendType").value = "";
		}else{
			document.getElementById("hidConvCd").value = convInfo.CONV_CD;
			document.getElementById("hidConvState").value = convInfo.CONV_STATE;
			document.getElementById("hidOriSendType").value = convInfo.ORI_SEND_TYPE;
			document.getElementById("hidReplcSendType").value = convInfo.REPLC_SEND_TYPE;
			
			searchErpPopupGrid();
		}
	}
	
	function searchErpPopupGrid(){
		var isValidated = true;
		var alertMessage = "";
		var alertType = "error";
		var alertCode = "";
		
		var orgnDivCd = convInfo.ORGN_DIV_CD;
		var orgnCd = convInfo.ORGN_CD;
		var convCd = convInfo.CONV_CD;
		
		erpPopupLayout.progressOn();
		$.ajax({
			url: "/sis/stock/conversion/getStockConvDetailList.do" //대출입내역 자료 조회
			, data : {
				"ORGN_DIV_CD" : orgnDivCd
				,"ORGN_CD" : orgnCd
				,"CONV_CD" : convCd
			}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpPopupLeftGrid);
					$erp.clearDhtmlXGrid(erpPopupRightGrid);
					var oriGridDataList = data.oriDataMapList;
					var replcGridDataList = data.replcDataMapList;
					if($erp.isEmpty(oriGridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupLeftGrid
							,'<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpPopupLeftGrid.parse(oriGridDataList, 'js');
						//하단 합계 적용
						calculateFooterValuesLeftGrid();
					}
					if($erp.isEmpty(replcGridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupRightGrid
							,'<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpPopupRightGrid.parse(replcGridDataList, 'js');
						//하단 합계 적용
						calculateFooterValuesRightGrid();
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupLeftGrid);
				$erp.setDhtmlXGridFooterRowCount(erpPopupRightGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ 기타 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_popup_table" class="samyang_div" style="diplay:none;">
		<table id = "tb_search_01" class = "table">
			<colgroup>
				<col width="80px"/>
				<col width="120px"/>
				<col width="80px"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<th>대출입일자</th>
				<td>
					<input type="text" id="popConvDate" name="popConvDate" class="input_common" readonly="readonly" disabled="disabled" style="width: 65px;">
				</td>
				<th>직영점</th>
				<td>
					<div id="cmbORGN_CD"></div>
					<input type="hidden" id="hidConvCd" value="">
					<input type="hidden" id="hidConvState" value="">
					<input type="hidden" id="hidOriSendType" value="">
					<input type="hidden" id="hidReplcSendType" value="">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_popup_left_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_popup_left_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
	<div id="div_erp_popup_right_layout" class="samyang_div" style="display:none;">
		<div id="div_erp_popup_right_grid" class="div_grid_full_size" style="display:none"></div>
	</div>
</body>
</html>