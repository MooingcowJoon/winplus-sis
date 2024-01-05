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
	var thisPopupWindow = parent.erpPopupWindows.window('openTrustSalesStatusDetail');
	var total_layout;
	
	var bot_layout;
	var bot_layout_grid;
	
	$(document).ready(function(){
		if(thisPopupWindow){
			thisPopupWindow.setText('외상매출 상세');
			thisPopupWindow.denyResize();	//창 크기 조절 ㄴㄴ
			//thisPopupWindow.denyMove();	//창 움직이지마!
		}

		init_total_layout();
		init_bot_layout();
		
		searchPopup();
		
		
	});
	
	function init_total_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "그리드", header:false}
			]
		});
		total_layout.cells("a").attachObject("div_bot_layout");
	}
	
	function init_bot_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
		                    //{id : "NO", label:["순번", "#rspan"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false,numberFormat : "0,000"}
		                    {id : "LOAN_CD", label:["여신코드", "#rspan"], type : "ro", width : "120", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "ORGN_CD", label:["직영점", "#rspan"], type : "ro", width : "120", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "MEM_NO", label:["고객코드", "#rspan"], type : "ro", width : "120", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "LOAN_SEQ", label:["순번", "#rspan"], type : "ro", width : "50", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "INDE_AMT", label:["전기이월", "#rspan"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "BAL_AMT", label:["미수금잔액", "#rspan"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "LOAN_AMT", label:["여신한도금액", "#rspan"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "TRUST_CNT", label:["외상횟수", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "TRUST_LIMIT", label:["외상횟수제한", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "CREDIT_AMT", label:["신용보증", "#rspan"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "CASH_AMT", label:["현금보증", "#rspan"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "GRNT_AMT", label:["보증증권", "#rspan"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "IO_NM", label:["입출납유형", "#rspan"], type : "ro", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "CDATE", label:["생성일시", "#rspan"], type : "ro", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    ];
		
		bot_layout_grid = new dhtmlXGridObject({
			parent: "div_bot_layout"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		$erp.attachDhtmlXGridFooterSummary(bot_layout_grid
											, ["INDE_AMT"
												,"BAL_AMT"
												,"LOAN_AMT"
												,"CREDIT_AMT"
												,"CASH_AMT"
												,"GRNT_AMT"]
											,1
											,"합계");
		
		$erp.initGrid(bot_layout_grid,{multiSelect : true});
		
	}
	function searchPopup() {
		total_layout.progressOn();
		var paramData = "${param}"
		console.log("param :" + paramData)
		
		var ORGN_CD = "${param.ORGN_CD}";
		var MEM_NO = "${param.MEM_NO}"
		var LOAN_CD = "${param.LOAN_CD}"
		
		console.log("1"+ORGN_CD);
		console.log("2"+MEM_NO);
		console.log("3"+LOAN_CD);
		
		$.ajax({
			url : "/sis/market/payment/getTrustSalesStatusDetailList.do"
			,data : {
				"ORGN_CD" : ORGN_CD
				,"LOAN_CD" : LOAN_CD
				, "MEM_NO" : MEM_NO
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				total_layout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
								bot_layout_grid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						bot_layout_grid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(bot_layout_grid);
			}, error : function(jqXHR, textStatus, errorThrown){
				total_layout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		
		
	}
	
	
</script>
</head>
<body>		

	
	<div id="div_bot_layout" class="div_grid_full_size" style="display:none"></div>
</body>
</html>