<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<!--<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>-->
<script type="text/javascript">
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
				
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbUSE_YN : Object / 사용여부 DhtmlXCombo
	--%>
	<%@ include file="/WEB-INF/jsp/common/include/default_common_header.jsp" %>
	
	var erpLayout;
	var erpGridColumns;
	var erpGrid;
	
	$(document).ready(function(){	
		initErpLayout();
		initErpGrid();
		
		searchInvoiceList();
	});
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "배송조회", header:true, fix_size : [false, true]},
				{id: "b", text: "", header:false, width:380, fix_size : [true, false]},
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_grid");
		erpLayout.cells("a").setHeight(110);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){			
			erpGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
		
	<%-- erpGrid 초기화 Function --%>  
    function initErpGrid(){
        erpGridColumns = [
			{id : "POST_NUM", label:["택배 나눔번호"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "POST_DESC", label:["배송내역"], type: "ro", width: "300", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "POST_NO", label:["송장번호"], type: "ro", width: "200", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "POST_CO", label:["택배사"], type: "ro", width: "100", sort : "str", align : "center", isHidden : true, isEssential : false}
			, {id : "POST_NM", label:["택배사명"], type: "ro", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
		];
        
        erpGrid = new dhtmlXGridObject({
            parent: "div_erp_grid"            
            , skin : ERP_GRID_CURRENT_SKINS
            , image_path : ERP_GRID_CURRENT_IMAGE_PATH          
            , columns : erpGridColumns
        });     
        erpGrid.enableDistributedParsing(true, 100, 50);
        $erp.initGridCustomCell(erpGrid);
        $erp.initGridComboCell(erpGrid);                
        
		erpGrid.attachEvent("onRowSelect", function(rId, cInd){
			var POST_NO = erpGrid.cells(rId, erpGrid.getColIndexById("POST_NO")).getValue();
			var POST_CO = erpGrid.cells(rId, erpGrid.getColIndexById("POST_CO")).getValue();
			var SendURL;
			if(POST_NO != '' && POST_CO != ''){
				if(POST_CO == "01"){ //현대
					SendURL = "http://www.hlc.co.kr/hydex/jsp/tracking/trackingViewCus.jsp?InvNo=" + POST_NO;
				} else if(POST_CO == "02"){ //한진
					SendURL = "http://www.hanjinexpress.hanjin.net/customer/plsql/hddcw07.result?wbl_num=" + POST_NO;
				} else if(POST_CO == "DD002"){ //우체국
					SendURL = "http://service.epost.go.kr/trace.RetrieveRegiPrclDeliv.postal?sid1=" + POST_NO;
				} else if(POST_CO == "DD001"){ //CJ
					SendURL = "http://nexs.cjgls.com/web/info.jsp?slipno=" + POST_NO;
				} else if(POST_CO == "20"){ //로젠
					SendURL = "http://d2d.ilogen.com/d2d/delivery/invoice_tracesearch_link_view.jsp?slipno=" + POST_NO;
				} else if(POST_CO == "22"){ //이노지스
					SendURL = "http://www.innogis.net/Tracking/Tracking_view.asp?invoice=" + POST_NO;
				} else if(POST_CO == "51"){ 
					SendURL = "http://service.epost.go.kr/trace.RetrieveRegiPrclDeliv.postal?sid1=" + POST_NO;
				} else if(POST_CO == "53"){ //CJ
					SendURL = "http://nexs.cjgls.com/web/info.jsp?slipno=" + POST_NO;
				} 
				//window.open(SendURL, "택배조회", "width=800, height=700, toolbar=no, menubar=no, scrollbars=no, resizable=yes");
				//document.getElementById("if_post").src = SendURL;
				erpLayout.cells("b").attachURL(SendURL);
			}
		});
    }
	
	function searchInvoiceList(){
		erpLayout.progressOn();
		$.ajax({
			url : "/tbs/customerorder/searchInvoiceList.do"
			,data : {
				"OCODE" : $('#OCODE').val()
				,"GRP_NUM" : $('#GRP_NUM').val()
 			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(erpGrid, '<spring:message code="grid.noSearchData"/>');
					} else {
						erpGrid.parse(gridDataList, 'js');
						erpGrid.selectRow(0,true,false,true);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
			}
		});
	}
</script>
</head>
<body>
	<input type="hidden" id="OCODE" value="${OCODE}">
	<input type="hidden" id="GRP_NUM" value="${GRP_NUM}">
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>