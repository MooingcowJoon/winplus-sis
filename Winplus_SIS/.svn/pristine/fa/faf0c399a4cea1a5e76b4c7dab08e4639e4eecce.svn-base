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
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openPurchaseDetailList");
	var purInfo = JSON.parse('${purInfo}');
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("구매내역상세");
		}
		
		initErpPopupLayout();
		initErpPopupRibbon();
		initErpPopupGrid();
		
		searchErpPopupGrid();
	});
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "리본영역", header:false, fix_size : [true, true]}
				,{id: "b", text: "그리드영역", header:false}
			]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_grid");
	}
	<%-- ■ erpPopupLayout 관련 Function 끝 --%>

	<%-- ■ erpPopupRibbon 관련 Function 시작 --%>
	function initErpPopupRibbon(){
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{type : "block", mode : 'rows', list : [
						{id : "search_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					]}
				]	
			});
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpPopupGrid"){
				searchErpPopupGrid();
			}
		});
	}
	<%-- ■ erpPopupRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpPopupGrid 관련 Function 시작 --%>
	function initErpPopupGrid(){
		erpPopupGridColumns = [
			{id : "NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "left", isHidden : false, isEssential : false}
			//{id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id : "BCD_NM", label:["품목명", "#rspan"], type: "ed", width: "260", sort : "str", align : "left", isHidden : false, isEssential : false, isSelectAll : true, maxLength : 100}
			,{id : "DIMEN_NM", label:["규격", "#rspan"], type: "ro", width: "70", sort : "str", align : "center", isHidden : false, isEssential : false}
			,{id : "PUR_PRICE", label:["윈플러스 제공 정보", "단가"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "PUR_QTY", label:["#cspan", "수량"], type: "ron", width: "50", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "SUPR_AMT", label:["#cspan", "공급가액"], type: "ron", width: "75", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "VAT", label:["#cspan", "부가세"], type: "ron", width: "60", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "PAY_SUM_AMT", label:["#cspan", "총액"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "CLSE_PRICE", label:["협력사 입력 정보", "단가"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "CLSE_QTY", label:["#cspan", "수량"], type: "ron", width: "50", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "CLSE_SUPR_AMT", label:["#cspan", "공급가액"], type: "ron", width: "75", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "CLSE_VAT", label:["#cspan", "부가세"], type: "ron", width: "60", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "CLSE_TOT_AMT", label:["#cspan", "총액"], type: "ron", width: "90", sort : "int", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000", isSelectAll : true, maxLength : 10}
			,{id : "PUR_DATE", label:["거래일자", "#rspan"], type: "ro", width: "75", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "PUR_SLIP_CD", label:["매입코드", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "PUR_SLIP_SEQ", label:["순번", "#text_filter"], type: "ro", width: "140", sort : "str", align : "left", isHidden : true, isEssential : false}
			,{id : "BCD_CD", label:["바코드", "#rspan"], type: "ron", width: "105", sort : "str", align : "left", isHidden : true, isEssential : true, isSelectAll : true, maxLength : 20}
			,{id : "GOODS_TAX_YN", label : ["부가세여부", "#rspan"], type : "combo", width : "70", sort : "str", align : "center", isHidden : true, isEssential : false, isDisabled : true, commonCode : ["TAX_TYPE"]}
			,{id : "CONF_TYPE", label : ["확정여부", "#rspan"], type: "ro", width: "70", sort : "str", align : "center", isHidden : true, isEssential : false}
			,{id : "TAXA_SUPR_AMT", label:["과세물품공급가액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : true, isEssential : false, numberFormat : "0,000"}
			,{id : "TAXA_VAT", label:["과세물품부가세", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : true, isEssential : false, numberFormat : "0,000"}
			,{id : "TAXA_PAY_SUM_AMT", label:["과세물품총액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : true, isEssential : false, numberFormat : "0,000"}
			,{id : "FREE_SUPR_AMT", label:["면세물품액", "#rspan"], type: "ron", width: "100", sort : "int", align : "right", isHidden : true, isEssential : false, numberFormat : "0,000"}
		];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupGridColumns
		});
		
		erpPopupGrid.enableDistributedParsing(true, 100, 50);
		var tot_style = "text-align:right; background-color:#FAE0D4; font-weight:bold; font-style:normal;";
		var text_style ="text-align:right; font-weight:bold; font-style:normal;";
		erpPopupGrid.attachFooter('총 합계,#cspan,#cspan,#cspan,#cspan,<div id="totalSuprAmt" style="text-align:right;">0</div>,<div id="totalVat" style="text-align:right;">0</div>,<div id="totalTotAmt" style="text-align:right;">0</div>,,#cspan,<div id="totalClseSuprAmt" style="text-align:right;">0</div>,<div id="totalClseVat" style="text-align:right;">0</div>,<div id="totalClseTotAmt" style="text-align:right;">0</div>',[tot_style,"","","","",text_style,text_style,text_style,"","",text_style,text_style,text_style]);
		erpPopupGrid.attachFooter('과세합계,#cspan,#cspan,#cspan,#cspan,<div id="totalTaxaSuprAmt" style="text-align:right;">0</div>,<div id="totalTaxaVat" style="text-align:right;">0</div>,<div id="totalTaxaTotAmt" style="text-align:right;">0</div>,,#cspan,#cspan,#cspan,#cspan',[tot_style,"","","","",text_style,text_style,text_style]);
		erpPopupGrid.attachFooter('면세합계,#cspan,#cspan,#cspan,#cspan,<div id="totalFreeSuprAmt" style="text-align:right;">0</div>,<div id="totalFreeVat" style="text-align:right;">0</div>,<div id="totalFreeTotAmt" style="text-align:right;">0</div>,,#cspan,#cspan,#cspan,#cspan',[tot_style,"","","","",text_style,text_style,text_style]);
		$erp.initGridCustomCell(erpPopupGrid);
		$erp.initGridComboCell(erpPopupGrid);
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid, 30);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid, '<spring:message code="grid.allRowCount" />');
	}
	
	function calculateFooterValues(stage){
		document.getElementById("totalSuprAmt").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("SUPR_AMT")));
		document.getElementById("totalVat").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("VAT")));
		document.getElementById("totalTotAmt").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("PAY_SUM_AMT")));
		document.getElementById("totalTaxaSuprAmt").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("TAXA_SUPR_AMT")));
		document.getElementById("totalTaxaVat").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("TAXA_VAT")));
		document.getElementById("totalTaxaTotAmt").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("TAXA_PAY_SUM_AMT")));
		document.getElementById("totalFreeSuprAmt").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("FREE_SUPR_AMT")));
		document.getElementById("totalFreeTotAmt").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("FREE_SUPR_AMT")));
		
		document.getElementById("totalClseSuprAmt").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("CLSE_SUPR_AMT")));
		document.getElementById("totalClseVat").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("CLSE_VAT")));
		document.getElementById("totalClseTotAmt").innerHTML = moneyType(sumColumn(erpPopupGrid.getColIndexById("CLSE_TOT_AMT")));
	}
	
	function moneyType(amt){
		return amt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function sumColumn(ind){
		var allRowIds = erpPopupGrid.getAllRowIds();
		var allRowArray = [];
		var out = 0;
		if(allRowIds != ""){
			allRowArray = allRowIds.split(",");
			for(var i=0; i<allRowArray.length; i++){
				out+= parseFloat(erpPopupGrid.cells(allRowArray[i],ind).getValue());
			}
		}
		return out;
	}
	
	function searchErpPopupGrid(){
		var purDate = purInfo.PUR_DATE;
		var orgnCd = purInfo.ORGN_CD;
		var suprCd = purInfo.SUPR_CD;
		
		$.ajax({
			url: "/sis/order/purchaseClose/getSuprByPurchaseDetailList.do" //입고내역 자료 조회
			, data : {
				 "PUR_DATE" : purDate
				 ,"ORGN_CD" : orgnCd
				 ,"SUPR_CD" : suprCd
			}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpPopupLayout.progressOn();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpPopupGrid);
					var gridDataList = data.dataMap;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupGrid
							,'<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpPopupGrid.parse(gridDataList, 'js');
						erpPopupGrid.groupBy(erpPopupGrid.getColIndexById("PUR_SLIP_CD"),["#title","#cspan","#cspan","#cspan","#cspan","#stat_total","#stat_total","#stat_total","","#cspan","#stat_total","#stat_total","#stat_total"]);
						calculateFooterValues();
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
				erpPopupLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- ■ erpPopupGrid 관련 Function 끝 --%>
</script>
</head>
<body>
	<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_popup_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>