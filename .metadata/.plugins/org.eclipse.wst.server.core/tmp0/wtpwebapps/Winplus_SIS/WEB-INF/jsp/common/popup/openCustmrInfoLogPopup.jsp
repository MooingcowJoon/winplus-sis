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

	var erpPopupWindowsCell = parent.erpPopupWindows.window("openCustmrInfoLogPopup");	
	
	var erpPopupVault;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("${screenDto.scrin_nm}");	
		}
		
		init_total_layout();
		init_grid_layout();
		
		getCustmrInfoLog("${paramMap.CUSTMR_CD}");
	});

	function getCustmrInfoLog(CUSTMR_CD){
		var url = "/sis/basic/getCustmrInfoLog.do";
		var send_data = {"CUSTMR_CD" : CUSTMR_CD};
		var if_success = function(data){
			$erp.clearDhtmlXGrid(grid); //기존데이터 삭제
			if($erp.isEmpty(data.gridDataList)){
				//검색 결과 없음
				$erp.addDhtmlXGridNoDataPrintRow(grid, '<spring:message code="info.common.noDataSearch" />');
			}else{
				grid.parse(data.gridDataList,'js');
			}
			$erp.setDhtmlXGridFooterRowCount(grid); // 현재 행수 계산
		}
		
		var if_error = function(XHR, status, error){}
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
	<%-- ■ total_layout 초기화 시작 --%>
	function init_total_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "", header:false}
			]
		});
		
		total_layout.cells("a").attachObject("div_total_layout");
	}
	<%-- ■ total_layout 초기화 끝 --%>
	
	<%-- ■ grid_layout 초기화 시작 --%>
	function init_grid_layout(){
		grid_layout = new dhtmlXLayoutObject({
			parent: "div_total_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "", header:false, fix_size:[true, false]}
			]
		});
		grid_layout.captureEventOnParentResize(total_layout); //삭제하면 상위 레이아웃 리사이즈시 자신을 리사이즈 하지 않습니다.		
		
		grid_layout.cells("a").attachObject("div_grid");
		
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
			{id : "CHECK"				, label : ["#master_checkbox", "#rspan"], type : "ch", width : "40", sort : "int", align : "center"}
			, {id : "NO"				, label:["NO"], type: "cntr", width : "30", sort : "int", align : "center"}
			, {id : "CUSTMR_CD"			, label:["거래처코드", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CUSTMR_NM"			, label:["거래처명", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CUSTMR_CEONM"		, label:["대표명", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CORP_NO"			, label:["사업자번호", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "TAXBILL_CD"		, label:["세무신고거래처", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CORP_ORI_NO"		, label:["종사업장번호", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "BUSI_COND"			, label:["업태", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "BUSI_TYPE"			, label:["업종", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CEO_TEL"			, label:["대표자휴대폰", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "RESP_USER_NM"		, label:["담당자명", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "ORD_RESP_USER"		, label:["구매담당자", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CENT_RESP_USER"	, label:["센터담당자", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "TEL_NO"			, label:["전화번호", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "FAX_NO"			, label:["팩스번호", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "PHON_NO"			, label:["담당자휴대폰", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "EMAIL"				, label:["이메일", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "SITEURL"			, label:["홈페이지", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CORP_ZIP_NO"		, label:["사업소재지우편번호", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CORP_ADDR"			, label:["사업소재지주소", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CORP_ADDR_DETL"	, label:["사업소재지상세주소", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "ORD_ZIP_NO"		, label:["우편번호(DM)", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "ORD_ADDR"			, label:["거래처주소(DM)", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "ORD_ADDR_DETL"		, label:["거래처상세주소(DM)", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "DELI_RESPUSER"		, label:["배송담당자", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "PAY_TYPE"			, label:["수금/지급구분", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "PAY_SCHD_1"		, label:["수금/지급예정일 값1", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "PAY_SCHD_2"		, label:["수금/지급예정일 값2", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "PAY_STD"			, label:["결제기준", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "ORD_SALE_TYPE"		, label:["거래유형(영업)구분", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "ORD_SALE_FEE"		, label:["거래유형(영업)", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "ORD_PUR_TYPE"		, label:["거래유형(구매)구분", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "ORD_PUR_FEE"		, label:["거래유형(구매)", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "KEYWD"				, label:["검색창내용", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "MEMO"				, label:["메모", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "EXC_VAT"			, label:["부가세제외", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "PUR_SALE_TYPE"		, label:["매입/매출처구분", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "PUR_TYPE"			, label:["매입유형", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "SUPR_GRUP_CD"		, label:["협력사분류코드", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "SUPR_TYPE"			, label:["협력사유형", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "SUPR_GOODS_GRUP"	, label:["소싱그룹", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "EVENT_YN"			, label:["행사차단", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "GOODS_FEE"			, label:["수수료율(신규상품)", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
// 			, {id : "BF_SEND_GB"		, label:["", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
// 			, {id : "BF_NS_VF"			, label:["", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
// 			, {id : "BF_FEE5"			, label:["", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
// 			, {id : "BF_HEAD"			, label:["", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "MK_INCEN_RATE"		, label:["매장장려금요율", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CENT_INCEN_RATE"	, label:["센터장려금요율", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CLSE_TIME"			, label:["주문마감시간", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "DELI_YOIL"			, label:["배숑요일", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "DELI_DATE"			, label:["배송특정일", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "LEAD_TIME"			, label:["리드타임", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "DELI_AREA_YN"		, label:["", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "MIN_PUR_AMT"		, label:["최저발주금액", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "HACCP_YN"			, label:["HACCP인증여부", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "USE_YN"			, label:["거래처사용여부", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "SUPR_STATE"		, label:["휴/폐업상태", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CLSE_BUSI_DATE"	, label:["휴/폐업일자", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "SUPR_ID"			, label:["협력사ID", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "SUPR_PWD"			, label:["협력사PW", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "SALES_ID"			, label:["고객사ID", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "SALES_PWD"			, label:["고객사PW", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CPROGRM"			, label:["생성프로그램", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CUSER"				, label:["생성자", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "CDATE"				, label:["생성일", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "MPROGRM"			, label:["수정프로그램", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "MUSER"				, label:["수정자", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
			, {id : "MDATE"				, label:["수정일", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center"}
		];
		
		grid = new dhtmlXGridObject({
			parent: "div_grid"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		
		grid.captureEventOnParentResize(total_layout);
		
		$erp.initGrid(grid);
		
	}
	<%-- ■ grid_layout 초기화 끝 --%>
	
</script>
</head>
<body>


	<div id="div_total_layout" class="samyang_div" style="display:none">
		<div id="div_grid" class="div_grid_full_size" style="display:none"></div>
	</div>

</body>
</html>