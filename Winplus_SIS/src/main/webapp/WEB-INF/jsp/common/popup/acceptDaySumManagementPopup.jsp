<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript">
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpPopupWindowsCell : Object / 시스템 팝업 윈도우 Cell DhtmlxWindowsCell; 
		■ erpPopupLayout : Object / 페이지 Layout DhtmlxLayout
		■ erpPopupRibbon : Object / 리본형 버튼 목록 DhtmlxRibbon
		■ erpPopupGrid : Object / 표준분류코드 조회 DhtmlxGrid
		■ erpPopupGridColumns : Array / 표준분류코드 DhtmlxGrid Header		
		■ erpPopupGridOnRowDblClicked : Object (Function) / erpPopupGrid 더블 클릭시 실행될 Function
	--%>
	var erpPopupWindowsCell = parent.erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
	
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;	
	
	var erpPopupGridOnRowDblClicked;
	
	var hffc_sttus_cd;
	var saupkuk_cd;
	var bhf_cd;
	var buzplc_cd;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("${screenDto.scrin_nm}");	
		}
		
		initErpPopupLayout();
		initErpPopupGrid();	
		searchErpPopupGrid();
	});
	
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>	
	<%-- erpPopupLayout 초기화 Function --%>	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				 {id: "a", text: "", header:false}
			]		
		});
		erpPopupLayout.cells("a").attachObject("div_erp_popup_grid");
		
		erpPopupLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupGrid.setSizes();
		});
	}
	<%-- ■ erpPopupLayout 관련 Function 끝 --%>	
	
	
	<%-- ■ erpPopupGrid 관련 Function 시작 --%>	
	<%-- erpPopupGrid 초기화 Function --%>	
	function initErpPopupGrid(){
		
		erpGridColumns = [
			{id : "", label:["순번"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "Article_Code", label:["상품코드"], type: "ro", width: "130", sort : "int", align : "left", isHidden : false, isEssential : false}
			, {id : "Article_OCode", label:["약어"], type: "ro", width: "130", sort : "int", align : "left", isHidden : false, isEssential : false}
			, {id : "Order_CQa", label:["수량"], type: "ro", width: "80", sort : "int", align : "ringt", isHidden : false, isEssential : false}
		];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_popup_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
		});		
		
		erpPopupGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPopupGrid);
		$erp.initGridComboCell(erpPopupGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpPopupGrid);
		erpGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpPopupGrid);
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid, 100);
		
		 
		// 더블클릭시 엑셀 저장 
		erpPopupGrid.attachEvent("onRowDblClicked", function(rId, cInd){
			
			var callbackFunction = function(){
				$erp.exportDhtmlXGridExcel({
		             "grid" : erpPopupGrid
		           , "fileName" : "${menuDto.menu_nm}"        
		           , "isForm" : false
		           , "isHiddenPrint" : "Y"
		        }); 
			}
			
			$erp.confirmMessage({
				"alertMessage" : "EXECE로 전환시키겠습니까?"
				, "alertType" : "alert"
				, "alertCallbackFn" : callbackFunction
			});
			
			
		});
	}
	
	<%-- erpPopupGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;		
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var emp_nm = document.getElementById("txtEMP_NM").value;
		
		if($erp.isEmpty(emp_nm) || emp_nm.length < 2) {
			isValidated = false;
			alertMessage = "error.common.ogran.employee.name.notEnoughLength";
			alertCode = "-1";
		} else if(emp_nm.length > 50){
			isValidated = false;
			alertMessage = "error.common.ogran.employee.name.length50Over";
			alertCode = "-2";
		}
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});			
		}
		
		return isValidated;
	}
	
	<%-- erpPopupGrid 조회 Function --%>
	function searchErpPopupGrid(){
		
	//	if(!isSearchValidate()) { return false; }
		
		erpPopupLayout.progressOn();
		
		var pBUSINESS_INF   = "${strBUSINESS_INF}";  //지역

		var pSTR_DT         = "${strSTR_DT}";   
		var pEND_DT         = "${strEND_DT}";   
		var pORDER_DSENDWAY = "${strORDER_DSENDWAY}";   
		var pORDER_DSENDWAY2 = "${strORDER_DSENDWAY2}";  
		var pSEACH_GUBUN    = "${strSEACH_GUBUN}";  
		var pORDER_PRO      = "${strORDER_PRO}";
		
		$.ajax({
			url : "/common/popup/acceptDaySumManagementPopupList.do"
			,data : {
				 "strBUSINESS_INF"     : pBUSINESS_INF 
				, "strSTR_DT"          : pSTR_DT
				, "strEND_DT"          : pEND_DT
				, "strORDER_DSENDWAY"  : pORDER_DSENDWAY
				, "strORDER_DSENDWAY2" : pORDER_DSENDWAY2
				, "strSEACH_GUBUN"     : pSEACH_GUBUN
				, "strORDER_PRO"       : pORDER_PRO
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpPopupGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpPopupGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
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
<div id="div_erp_popup_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>