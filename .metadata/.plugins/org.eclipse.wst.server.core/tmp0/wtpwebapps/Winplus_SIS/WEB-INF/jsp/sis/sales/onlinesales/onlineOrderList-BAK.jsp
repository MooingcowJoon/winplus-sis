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
	
	var total_layout;
	
	var top_layout;
	
	var mid_layout;
	var mid_layout_ribbon;
	
	var bot_layout;
	var bot_layout_grid;
	
	var excel_layout;
	var excel_grid;
	
	$(document).ready(function(){
		init_total_layout();
		init_top_layout();
		init_mid_layout();
		init_bot_layout();
		init_excel_layout();
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
		total_layout.cells("a").setHeight($erp.getTableHeight(1));
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(36);
		total_layout.cells("c").attachObject("div_bot_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);		
	}
	
	function init_top_layout(){
		cmbORGN_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_CD", "ORGN_CD", ["ORGN_CD","CT"], 220, null, false, false, null, null);
		cmbDATE = $erp.getDhtmlXComboCommonCode("cmbDATE", "DATE_TYPE", "DATE_TYPE", 220, false, false, false, false);
	}
	
	function init_mid_layout(){
		ribbon = new dhtmlXRibbon({
			parent : "div_mid_layout"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
				           {type : "block", mode : 'rows', list : [
			   					{id : "search_grid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
//			   					, {id : "add_grid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
//								, {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : false}
								, {id : "save_grid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true, unused : true} 
								, {id : "excel_grid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : false}
								, {id : "excelForm_grid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
								, {id : "excel_grid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, isHidden : true}				
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
				$erp.alertMessage({
	            	"alertMessage" : "준비중입니다.",
					"alertType" : "alert",
					"isAjax" : false
	            });
			} else if (itemId == "excel_grid"){
				
				gridToExcel();
				
		     } else if(itemId == "excelForm_grid") {
		    	 $erp.exportGridToExcel({
				    	"grid" : bot_layout_grid
						, "fileName" : "판매관리 - (온라인)주문서양식"
						, "isOnlyEssentialColumn" : false
						, "excludeColumnIdList" : ["NO","CHECK","ORD_CD","CUSTMR_NM","RESP_USER","TOT_GOODS_NM","SALE_TOT_AMT","CDATE","ORD_DATE","CONF_TYPE","0"]
						, "isIncludeHidden" : false
						, "isExcludeGridData" : true
					});
				    /* $erp.exportGridToExcel({
				    	"grid" : excel_grid
						, "fileName" : "판매관리 - (온라인)주문서양식"
						, "isOnlyEssentialColumn" : false
						, "excludeColumnIdList" : ["ORD_CD","SALE_UNITQTY","INSP_QTY","PUR_AMT","SALE_AMT","SALE_VAT_AMT","SALE_TOT_AMT",""]
						, "isIncludeHidden" : false
						, "isExcludeGridData" : true
					}); */
			} else if(itemId == "excel_grid_upload") {
				var convertModuleUrl = ""; //엑셀로 컨버트 하는 모듈을 다른것을 사용하고자 할때만 사용
		    	var uploadFileLimitCount = 1; //파일 업로드 개수 제한
		    	var onUploadFile = function(files, uploadData, toGrid){
					$erp.uploadDataParse(this, files, uploadData, toGrid, "CUSTMR_CD", "add", [], ["CUSTMR_CD"]);
				}
		    	var onUploadComplete = function(uploadedFileInfoList, toGrid, result){
		    		loadSales(result);
		    	}
		    	var onBeforeFileAdd = function(file){};
		    	var onBeforeClear = function(){};
		 		$erp.excelUploadPopup(bot_layout_grid, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			
		 		
			} else if (itemId == "print_grid"){
				$erp.alertMessage({
	            	"alertMessage" : "준비중입니다.",
					"alertType" : "alert",
					"isAjax" : false
	            });
			}
		});
	}
	function excel_grid(){
		$erp.exportGridToExcel({
	    	"grid" : excel_grid
			, "fileName" : "판매관리 - (온라인)주문서"
			, "isOnlyEssentialColumn" : false
			, "excludeColumnIdList" : []
			, "isIncludeHidden" : false
			, "isExcludeGridData" : true
		});
	}
	function isSearchValidate() {
	    var fr = $("#txtDATE_FR").val();
	    var to = $("#txtDATE_TO").val();
	    var ORD_CD = $("#ORD_CD").val();
	    var GOODS_NO = $("#GOODS_NO").val();

	    var a = fr.replace(/-/gi,'')
	    var b = to.replace(/-/gi,'')
	    var date = b - a

		var regular_expression = /[~!@#$%^&*()_+|<>?:{};0-9;一-龥]/;
		var regular_expression1 = /[0-9;_]/;
	    

	        <%--기간 유효성 검사--%>
	        if (date < 0) {
	            $erp.alertMessage({
	            	"alertMessage" : "시작 날짜와 종료 날짜를 확인하세요.",
					"alertType" : "alert",
					"isAjax" : false
	            });
	        <%--주문번호 유효성 검사--%>
	        } /* else if(ORD_CD != "") {
				if(!regular_expression.test(ORD_CD)){
		        	$erp.alertMessage({
		            	"alertMessage" : "숫자 또는 밑줄(_)을 입력하세요.",
						"alertType" : "alert",
						"isAjax" : false
		            });
				} 
				else {
		        	searchGrid();
				}
	        }*/
	        <%--상품명 유효성 검사--%>
	        
	        <%--정상--%>
	        else {
	        	searchGrid();
	        }
	}
	
	function searchGrid() {
		var dataObj = $erp.dataSerialize("tb_search");
		var url = "/sis/sales/onlinesales/getOnlineOrderList.do";
		
		var send_data = $erp.unionObjArray([null,dataObj]);
		var if_success = function(data){
			$erp.clearDhtmlXGrid(bot_layout_grid); //기존데이터 삭제
			if($erp.isEmpty(data.gridDataList)){
				//검색 결과 없음
				$erp.addDhtmlXGridNoDataPrintRow(bot_layout_grid, '<spring:message code="info.common.noDataSearch" />');
			}else{
				bot_layout_grid.parse(data.gridDataList,'js');
				$erp.setDhtmlXGridFooterRowCount(bot_layout_grid);
			}
		}
		var if_error = function(){
			
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	} 
	
		
	function init_bot_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
							{id : "NO", label:["순번", "#rspan"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false}
							, {id : "CHECK", label:["#master_checkbox", "#rspan"], type : "ch", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
							, {id : "ORD_CD", label:["주문번호", "#text_filter"], type : "ro", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "CUSTMR_CD", label:["거래처코드", "#rspan"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "CUSTMR_NM", label:["거래처명", "#text_filter"], type : "ro", width : "200", sort : "str", align : "left", isHidden : false, isEssential : true}
		                    , {id : "ORGN_CD", label:["센터", "#rspan"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, isDisabled : true, commonCode : ["ORGN_CD","CT"]}
		                    , {id : "RESP_USER", label:["담당자", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "BCD_CD", label:["상품 코드", "#rspan"], type : "ro", width : "200", sort : "str", align : "left", isHidden : true, isEssential : true} 
		                    , {id : "TOT_GOODS_NM", label:["상품명", "#text_filter"], type : "ro", width : "250", sort : "str", align : "left", isHidden : false, isEssential : true}
		                    , {id : "SALE_TOT_AMT", label:["금액", "#rspan"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "CDATE", label:["등록일자", "#rspan"], type : "ro", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "ORD_DATE", label:["납기일자", "#rspan"], type : "ro", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "CONF_TYPE", label:["진행상태", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "0", label:["비고", "#rspan"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                   ];
		
		bot_layout_grid = new dhtmlXGridObject({
			parent: "div_bot_layout"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		
		$erp.initGrid(bot_layout_grid,{multiSelect : false});
 		bot_layout_grid.attachEvent("onRowDblClicked", function (rowId,columnIdx){
			//더블클릭시 해당 정보를 파싱하여 "	" 페이지가 열려야함
			openOnlineOrder();
		});
	}
	function init_excel_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
							{id : "ORD_CD", label:["주문번호"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "ORGN_CD", label:["센터", "#rspan"], type : "combo", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, isDisabled : true, commonCode : ["ORGN_CD","CT"]}
							, {id : "CUSTMR_CD", label:["거래처코드"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}
			              	, {id : "CUSTMR_NM", label:["거래처명"], type : "ro", width : "200", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "BCD_CD", label:["상품코드"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
							, {id : "GOODS_NM", label:["상품명"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}							
							, {id : "SALE_UNITQTY", label:["단위량"], type : "ro", width : "80", sort : "str", align : "right", isHidden : false, isEssential : true}
				            , {id : "INSP_QTY", label:["단위수량"], type : "ron", width : "80", sort : "str", align : "right", isHidden : false, isEssential : true}
				            , {id : "SALE_QTY", label:["수량"], type : "ro", width : "80", sort : "str", align : "right", isHidden : false, isEssential : true}
				            , {id : "PUR_AMT", label:["매출원가"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
				            , {id : "SALE_AMT", label:["공급가액"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
				            , {id : "SALE_VAT_AMT", label:["부가세액"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
				            , {id : "SALE_TOT_AMT", label:["합계금액"], type : "ron", width : "100", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
				            , {id : "", label:["적요"], type : "ro", width : "200", sort : "str", align : "center", isHidden : false, isEssential : true}
							];
		
		excel_grid = new dhtmlXGridObject({
				parent : "hidden_excel"
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		
		$erp.initGrid(excel_grid,{multiSelect : false});
	}
	function gridToExcel() {
		var dataObj = $erp.dataSerialize("tb_search");
		var url = "/sis/sales/onlinesales/getOnlineOrderExcelList.do";
		
		var send_data = $erp.unionObjArray([null,dataObj]);
		var if_success = function(data){
			$erp.clearDhtmlXGrid(excel_grid); //기존데이터 삭제
			if($erp.isEmpty(data.gridDataList)){
				//검색 결과 없음
				$erp.alertMessage({
	            	"alertMessage" : "출력된 자료 없음",
					"alertType" : "alert",
					"isAjax" : false
	            });
			}else{
				excel_grid.parse(data.gridDataList,'js');
				$erp.exportGridToExcel({
			    	"grid" : excel_grid
					, "fileName" : "판매관리(온라인)주문서"
					, "isOnlyEssentialColumn" : false
					, "excludeColumnIdList" : ["SALE_UNITQTY","PUR_AMT","INSP_QTY",""]
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
			}
		}
		var if_error = function(){
			
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
		
		
	}
	
	
	
	function openOnlineOrder(selectedRow, ORD_CD) {
		var selectedRow = bot_layout_grid.getSelectedRowId();
		var ORD_CD = null;
		if(selectedRow != null){
			ORD_CD = bot_layout_grid.cells(selectedRow,bot_layout_grid.getColIndexById("ORD_CD")).getValue();//주문번호
		}

        var call_popup_windowName = "openOnlineOrderDetail";
		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window( call_popup_windowName );
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		var onConfirm = function(){
		}
		var params = {"SELECTED_ORD_CD" : ORD_CD
//					, "6" : 6
		}
		var option =  "";
		var option =  {
				"win_id" : "openOnlineOrderDetail",
				"width"  : 1400,
				"height" : 800
			   }
		var url = "/sis/sales/onlinesales/openOnlineOrderDetail.sis";
		
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
	
	//requestAddRowCount						//아무런 처리없이 추가 요청한 데이터 초기 로우수
	//newAddRowDataList							//새로 추가된 로우 데이타 리스트
	//standardColumnValue_indexAndRowId_obj		//기준 컬럼의 값을 key, [인덱스,로우아이디]를 value 로 가진 객체
	//insertedRowIndexList						//로우 상태가 inserted 인 로우인덱스 리스트
	//editableColumnIdListOfInsertedRows		//로우 상태가 inserted 인 로우의 수정가능한 컬럼 Id 리스트
	//notEditableColumnIdListOfInsertedRows		//로우 상태가 inserted 인 로우의 수정불가능한 컬럼 Id 리스트
	//duplicationCount_in_toGridDataList		//toGrid 에 추가중 발생한 중복 데이터 개수
	function loadSales(result){
		var loadOnlineOrder = [];
		var data;
		for(var index in result.newAddRowDataList){
			data = result.newAddRowDataList[index];
			loadOnlineOrder.push({"CUSTMR_CD" : data["CUSTMR_CD"], "ORGN_CD" : data["ORGN_CD"]});
		}
		var url = "/sis/sales/onlinesales/getOnlineSalesInfo.do";
		var send_data = {
				"loadOnlineOrder" : loadOnlineOrder
				};		
		var if_success = function(data){
			var gridDataList = data.gridDataList;
			for(var index in gridDataList){
				
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["CUSTMR_CD"]][1], bot_layout_grid.getColIndexById("CUSTMR_CD")).setValue(gridDataList[index]["CUSTMR_CD"]);
				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["CUSTMR_CD"]][1], bot_layout_grid.getColIndexById("CUSTMR_NM")).setValue(gridDataList[index]["CUSTMR_NM"]);
				//bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["ORD_CD"]][1], bot_layout_grid.getColIndexById("TOT_GOODS_NM")).setValue(gridDataList[index]["TOT_GOODS_NM"]);
				//bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["ORD_CD"]][1], bot_layout_grid.getColIndexById("SALE_TOT_AMT")).setValue(gridDataList[index]["SALE_TOT_AMT"]);
// 				bot_layout_grid.cells(result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["CUSTMR_CD"]][1], bot_layout_grid.getColIndexById("RESP_USER")).setValue("HJH");
				result.standardColumnValue_indexAndRowId_obj[gridDataList[index]["CUSTMR_CD"]].push("로드완료");
			} 
			
			var notExistList = [];
			var value;
			var state;
			var dp = bot_layout_grid.getDataProcessor();
			for(var index in result.newAddRowDataList){
				value = result.standardColumnValue_indexAndRowId_obj[result.newAddRowDataList[index]["CUSTMR_CD"]];
				state = dp.getState(value[1]);
				if(value.length == 2 && state == "inserted"){
					notExistList.push(value[0]);
				}
			}
			
			$erp.deleteGridRows(bot_layout_grid, notExistList, result.editableColumnIdListOfInsertedRows, result.notEditableColumnIdListOfInsertedRows);
			$erp.alertMessage({
				"alertMessage" : "[중복 : " + result.duplicationCount_in_toGridDataList + "개]<br/> [무효  : " + notExistList.length + "개]<br/> [신규 : " + (result.newAddRowDataList.length-notExistList.length) + "개]",
				"alertType" : "alert",
				"isAjax" : false
			});
			
			if(bot_layout_grid.getRowsNum() == 0){
				ribbon.callEvent("onClick",["search_grid"]);
				return;
			}
			
			$erp.setDhtmlXGridFooterRowCount(bot_layout_grid); // 현재 행수 계산
		}
		
		var if_error = function(XHR, status, error){
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
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
					<th colspan="1">기 간</th>
					<td colspan="2">
						<input type="text" id="txtDATE_FR" class="input_calendar default_date" data-position="(1)" value="">
						<span style="float: left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO" class="input_calendar default_date" data-position="" value="" style="float: left; margin-left: 6px;">
					</td>
					<th colspan="1">일자 구분</th>
					<td colspan="2"><div id="cmbDATE"></div></td>
					<th colspan="1">센터</th>
					<td colspan="2"><div id="cmbORGN_CD" disabled></div></td>
				</tr>
				<!-- <tr>
					<th colspan="1">주문 번호</th>
					<td colspan="2"><input type="text" id="txtORD_CD" name="KEY_WORD" maxlength="30" onkeydown="" style="width:210px;height:17px"></td>
					<th colspan="1">상품명</th>
					<td colspan="2"><input type="text" id="txtGOODS_NO" name="KEY_WORD" maxlength="30" onkeydown="" style="width:210px;height:17px"></td>
					<td colspan="4"></td>
				</tr> 
				 <tr>
					
					<td colspan="7"></td>
				</tr> -->
			</table>
		</div>
	</div>

	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bot_layout" class="div_grid_full_size" style="display:none"></div>
	<div id="hidden_excel"></div>
</body>
</html>