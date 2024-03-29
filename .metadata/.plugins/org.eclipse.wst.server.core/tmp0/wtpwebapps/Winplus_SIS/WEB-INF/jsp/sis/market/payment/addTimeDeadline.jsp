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

	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "All,1,2,3";
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var crud;
	var AUTHOR_CD = "${screenDto.author_cd}";

	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		checkYN();
		
		document.getElementById("searchDateFrom").value=todayDate;
		document.getElementById("searchDateTo").value=today;
		
		$erp.asyncObjAllOnCreated(function(){

		})
		
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "검색조건", header: false, fix_size:[false, true]}
				, {id : "b", text: "리본내역", header: false, fix_size:[false, true]}
				, {id : "c", text: "그리드내역", header: false, fix_size:[false, true]}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight(70);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		document.getElementById("TRML_INVALID").innerHTML = '<input type="checkbox" id="trml_invalid" name="trml_invalid" value="all">제외';
		
		erpLayout.setSeparatorSize(1, 0);
		erpLayout.setSeparatorSize(1, 1);
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
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
				]}
			]
		});	
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_erpGrid") {
				searchErpGrid();
			}
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			{id : "NO", label:["순번", "#rspan"], type: "cntr", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_CD", label:["조직명", "#rspan"], type: "combo", width: "75", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : "ORGN_CD"}
			, {id : "TRML_CD", label:["단말", "#rspan"], type: "ro", width: "50", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "EMP_NM", label:["계산원", "#rspan"], type: "ro", width: "70", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "CLSE_REG_DATE", label:["마감일시", "#rspan"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "TOT_AMT", label:["매출액", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false , numberFormat : "0,000"}
			, {id : "COMP_CONSM_AMT", label:["소비액", "#rspan"], type: "ron", width: "60", sort : "str", align : "right", isHidden : false, isEssential : false , numberFormat : "0,000"}
			, {id : "SALE_CASH_AMT", label:["②현금합계", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_CARD_AMT", label:["카드합계", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false , numberFormat : "0,000"}
			, {id : "SALE_GIFT_AMT", label:["상품권합계", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "SALE_POINT_AMT", label:["포인트합계", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "TRUST_SALE_AMT", label:["외상합계", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "RESV_AMT", label:["①준비금", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "MID_OUT_AMT", label:["③중간출금", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "GIFT_CHNG", label:["④상품권거스름", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "CHNG_POINT", label:["⑤거스름적립", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "TRUST_CASH_AMT", label:["⑥외상입금(현금)", "#rspan"], type: "ron", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false , numberFormat : "0,000"}
			, {id : "CASH_FACE_PRICE", label:["입금할현금", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false , numberFormat : "0,000"}
			, {id : "SALE_CASH_TOT_AMT", label:["현금입금", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "IN_CASH_LOSS_AMT", label:["현금과부족", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false , numberFormat : "0,000"}
			, {id : "IN_GIFT_AMT", label:["입금할상품권", "#rspan"], type: "ron", width: "90", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "IN_GIFT_RECV_AMT", label:["상품권입금", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "IN_GIFT_LOSS_AMT", label:["상품권과부족", "#rspan"], type: "ron", width: "90", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "CHNG_AMT", label:["과부족합계", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : false, isEssential : false, numberFormat : "0,000"}
			, {id : "EMP_CD", label:["계산원코드", "#rspan"], type: "ro", width: "70", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "CLSE_CD", label:["마감코드", "#rspan"], type: "ro", width: "70", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "TOT_SALE_CNT", label:["총판매건수", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "TOT_RETN_CNT", label:["총반품건수", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "RETN_CASH_AMT", label:["반품금액(현금)", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "RETN_CARD_AMT", label:["반품금액(카드)", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "RETN_POINT_AMT", label:["반품금액(포인트)", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "RETN_GIFT_AMT", label:["반품금액(상품권)", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "TOT_RETN_AMT", label:["반품액합계", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CASH_AMT", label:["매출합계(현금)", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CARD_AMT", label:["매출합계(카드)", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "GIFT_AMT", label:["매출합계(상품권)", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "POINT_AMT", label:["매츨합계(포인트)", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "TRUST_AMT", label:["매츨합계(외상)", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "TOT_SALE_AMT", label:["판매액합계", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "COMP_CONSM_CNT", label:["사내소비건수", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CUTO_AMT", label:["절사액합계", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "COUP_DC_CNT", label:["쿠폰할인수", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "COUP_DC_AMT", label:["쿠폰할인액", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "POINT_SAVE", label:["포인트적립", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "TRUST_RETN_AMT", label:["외상금액(반품)", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "OPEN_DATE_TIME", label:["개설일시", "#rspan"], type: "ro", width: "150", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "CLSE_DATE_TIME", label:["정산일시", "#rspan"], type: "ro", width: "150", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "SALE_CARD_TMP_AMT", label:["임의등록카드매출", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "RETN_TMP_CARD_AMT", label:["임의등록카드매출", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CASH_AMT2", label:["현금매출", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CASH_CNT_01", label:["50000", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CASH_CNT_02", label:["10000", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CASH_CNT_03", label:["5000", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CASH_CNT_04", label:["1000", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CASH_CNT_05", label:["500", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CASH_CNT_06", label:["100", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CASH_CNT_07", label:["50", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CASH_CNT_08", label:["10", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CASH_CNT_09", label:["십만원권수표", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "CASH_CNT_10", label:["기타수표", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "EMPTY_BOTTILE_CNT", label:["공병수거건수", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
			, {id : "EMPTY_BOTTLE_AMT", label:["공병수거금액", "#rspan"], type: "ron", width: "80", sort : "str", align : "right", isHidden : true, isEssential : false}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		
		erpGrid.enableDistributedParsing(true, 100, 50);
		erpGrid.enableAccessKeyMap(true);
		$erp.initGridCustomCell(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		
		erpGrid.attachEvent("onRowDblClicked", function (rowId,columnIdx){
			$erp.openPosManagerInfoPopup($erp.dataSerializeOfGridRow(erpGrid, rowId));
		});
		
		crud = "R";
	}
	<%-- ■ erpDetailGrid 관련 Function 끝 --%>
	
	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(){
			
		erpLayout.progressOn();
		
		if($('#pos_cd').is(":checked") == true){
			TRML_CD = $("#txtTRML_CD").val();
		} else {
			TRML_CD = "";
		}
		
		if($('#Set_Emp').is(":checked") == true){
			EMP_NM = document.getElementById("Set_EmpNM").value;
			EMP_CD = document.getElementById("Set_EmpCD").value;
		} else {
			EMP_NM = "";
			EMP_CD = "";
		}
		
		var paramData = {};
		paramData["SEARCH_DATE_FROM"] = document.getElementById("searchDateFrom").value;
		paramData["SEARCH_DATE_TO"] = document.getElementById("searchDateTo").value;
		paramData["ORGN_DIV_CD"] = cmbORGN_DIV_CD.getSelectedValue();
		paramData["ORGN_CD"] = cmbORGN_CD.getSelectedValue();
		paramData["EMP_NM"] = EMP_NM;
		paramData["EMP_CD"] = EMP_CD;
		paramData["TRML_CD"] = TRML_CD;
		paramData["TRML_INVALID"] = $('input[name=trml_invalid]:checked').length;
		$.ajax({
			url: "/sis/market/payment/addTimeDeadlineList.do"
			, data : paramData
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
				erpLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	<%-- erpGrid 조회 Function 끝--%>
	
	<%-- initDhtmlXCombo Function 시작 --%>
	function initDhtmlXCombo(){
		$('#Set_EmpNM').attr("disabled", true);
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 180, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 100, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
			$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			});
		});
	}
	
	<%-- openSelectEmpPopup 직원선택 팝업 열림 Function --%>
	function openSelectEmpPopup(){
			var onRowDblClicked = function(id, ind) {
				document.getElementById("Set_EmpCD").value = this.cells(id, this.getColIndexById("EMP_NO")).getValue();
				document.getElementById("Set_EmpNM").value = this.cells(id, this.getColIndexById("EMP_NM")).getValue();
				
				$erp.closePopup2("openSelectEmpPopup");
			}
			$erp.openSelectEmpPopup(onRowDblClicked);
		}
	
	<%-- checkbox 누를때 열리거나 감추는 Function --%>
	function checkYN() {
		if($('#pos_cd').is(":checked") == true) {
			$('#txtTRML_CD').attr("disabled", false);
			$('#trml_invalid').attr("disabled", false);
		}else {
			$('#txtTRML_CD').attr("disabled", true);
			$('#trml_invalid').attr("disabled", true);
		}
	}
	
	function checkboxYN(checkedNM){
		if(checkedNM == 'empnm') {
			if($('#Set_Emp').is(":checked") == true) {
				$('#Set_EmpNM').attr("disabled", true);
				openSelectEmpPopup();
			} 
		}
	}
</script>
</head>
<body>
	<div id="div_erp_table" class="samyang_div" style="display:none">
	<table id="tb_erp_data" class="table_search">
		<colgroup>
			<col width="70px;">
			<col width="100px;">
			<col width="15px">
			<col width="130px">
			<col width="100px">
			<col width="200px;">
			<col width="70px;">
			<col width="*px;">
		</colgroup>
		<tr>
			<th>마감일</th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
				</td>
				<td>~</td>
				<td> 
					<input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
				</td>
				<th> 법인구분</th>
				<td>
					<div id="cmbORGN_DIV_CD"></div>
				</td>
				<th>조직명</th>
				<td>
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
			</table>
	<table id="tb_erp_data2" class="table_search"> 
		<colgroup>
			<col width="25px;">
			<col width="330px;">
			<col width="230px;">
			<col width="*px">
		</colgroup>
		<tr>
			<th></th>
				<td>
					<input type= "hidden" id = "Set_EmpCD"/>
					<input type="checkbox" id="Set_Emp" name="Set_Emp" onclick="checkboxYN('empnm');"/>
					<label for="Set_Emp">계산원</label>
					<input type="text" id="Set_EmpNM" name="Set_EmpNM" maxlength="10" disabled="disabled" /> 
				</td>
				<td>
					<input type="checkbox" id="pos_cd" name="pos" onchange="checkYN();"/>
					<label for="pos_cd">단말</label>
					<input type="text" id="txtTRML_CD" name="pos" maxlength="10" disabled="disabled"  /> 
				</td>
				<td>
					<div id = "TRML_INVALID"></div>
				</td>
			</tr>
	</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>