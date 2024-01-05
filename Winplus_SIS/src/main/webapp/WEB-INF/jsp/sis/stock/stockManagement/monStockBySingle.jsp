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

//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
LUI = JSON.parse('${empSessionDto.lui}');

	<%--
	※ 전역 변수 선언부 
	□ 변수명 : Type / Description
	■ erpLayout : Object / 페이지 Layout DhtmlXLayout
	■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
	■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
	■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
	■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
	■ cmenu : Object / context-menu 우클릭메뉴 dhtmlXMenuObject
	■ searchCheck : String / 리본&더블클릭 조회 체크
	■ grup_cd : String / 더블클릭 조회 시 분류별코드
	  
	--%>

	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpAllGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var crud;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var todayDate = thisYear + "-" + thisMonth 
	

	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
	});

	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false}
				, {id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				, {id: "c", text: "그리드영역", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(97);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpAllGrid.setSizes();
		
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					, {id : "excel_erpGrid", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
		            , {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : false}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	if(document.getElementById("hidGOODS_CATEG_CD").value == ""){
		    		$erp.alertMessage({
		    			"alertMessage" : "error.sis.goods.search.grup_nm.empty"
		    			, "alertType" : "error"
		    		});
		    	}
		    	else{
		    		searchCheck();
		    	}
	        } else if(itemId == "excel_erpGrid"){
		    	$erp.exportGridToExcel({
		    		"grid" : erpAllGrid
					, "fileName" : "월말재고(단품별)"
					, "isOnlyEssentialColumn" : true
					, "excludeColumnIdList" : []
					, "isIncludeHidden" : false
					, "isExcludeGridData" : false
				});
	        } else if (itemId == "print_erpGrid"){
	        	$erp.alertMessage({
					"alertMessage" : "준비 중 입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
	        }
    	 });
	}
	
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid() {
		
		erpGrid = {};
		erpAllGridColumns = [ 
			{id : "index", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "GOODS_NM", label:["상품명", "#rspan"], type: "ro", width: "170", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DIMEN_CD", label:["규격", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_CD", label:["바코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "STOCK_QTY", label:["재고량", "#rspan"], type: "ro", width: "70", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "PUR_PRICE", label:["매입가", "#rspan"], type: "ro", width: "90", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_PRICE", label:["판매가", "#rspan"], type: "ro", width: "90", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "PAY_SUM_AMT", label:["매입가액", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "SALE_AMT", label:["판매가액", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GRNT_AMT", label:["보증금", "#rspan"], type: "ro", width: "70", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "TAX_PUR_AMT", label:["과세재고", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "COM_AMT", label:["물품가액", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "VAT", label:["부가세", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "END_DATE", label:["최종실사일시", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			
	    ];
		
		erpAllGrid = new dhtmlXGridObject({
			parent: "div_erp_all_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpAllGridColumns
		});
		
		erpAllGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpAllGrid);
		$erp.initGridComboCell(erpAllGrid);				
		$erp.attachDhtmlXGridFooterRowCount(erpAllGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpAllGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpAllGrid);
		$erp.attachDhtmlXGridFooterPaging(erpAllGrid, 100);
		
		erpGrid["div_erp_all_grid"] = erpAllGrid;
		document.getElementById("div_erp_all_grid").style.display = "block";
		
		erpAllGrid.attachEvent("onRowDblClicked",function(rId,cInd){
			crud = "U";
			
		});
		
		crud = "R";
			
		
	}
	   
	<%-- erpGrid 조회 확인 Function --%>
	function searchCheck(){
		var alertMessage = '<spring:message code="alert.sis.goods.searchCheck" />';
		var alertType = "alert";
		var callbackFunction = function(){
			SearchErpGrid(erpAllGrid, document.getElementById("hidGOODS_CATEG_CD").value);
		}
		
		var key_word = $("#txtKEY_WORD").val();
		var GRUP_CD = document.getElementById("hidGOODS_CATEG_CD").value;
		
		if(key_word == "" && GRUP_CD == "ALL"){
			$erp.confirmMessage({
				"alertMessage" : alertMessage
				, "alertType" : alertType
				, "alertCallbackFn" : callbackFunction
			});
		}else{
			SearchErpGrid(erpAllGrid, document.getElementById("hidGOODS_CATEG_CD").value);
		}
		
	}
	
	<%-- erpGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		
		var alertMessage = "";
		var alertType = "error";
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
	
	
	<%-- ■ SearchErpGrid 관련 Function 시작 --%>
	   
	   function SearchErpGrid(erpAllGrid) {	
		   if(!isSearchValidate()){
				return;
			}
			
			erpLayout.progressOn();
		   
		   var SEARCH_DATE_FROM = document.getElementById("SEARCH_DATE_FROM").value;
		   var SURP_CD = document.getElementById("txtSUPR_CD").value;
		   var GRUP_CD = document.getElementById("hidGOODS_CATEG_CD").value;
		   var Invalid_Goods = $('input[name=Invalid_Goods]:checked').length;
		   var Ending_Stock = $('input[name=Ending_Stock]:checked').length;
		   var Set_Goods = $("#txtGRUP_CD").val();
		   var key_word = $("#txtKEY_WORD").val();
		   
		   	 $.ajax({
					url: "/sis/stock/stockManagement/monStockBySingleList.do"
					, data : {
						"SEARCH_DATE_FROM" : SEARCH_DATE_FROM,
						"GRUP_CD" : GRUP_CD,
						"SURP_CD" : SURP_CD,
						"Invalid_Goods" : Invalid_Goods,
						"Ending_Stock" : Ending_Stock,
						"Set_Goods" : Set_Goods,
						"KEY_WORD" : key_word
					}
					, method : "POST"
					, dataType : "JSON"
					, success : function(data){
						erpLayout.progressOn();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else {
							$erp.clearDhtmlXGrid(erpAllGrid);
							var gridDataList = data.gridDataList;
							if($erp.isEmpty(gridDataList)){
								$erp.addDhtmlXGridNoDataPrintRow(
								erpAllGrid
									,  '<spring:message code="grid.noSearchData" />'
								);
							}else {
								erpAllGrid.parse(gridDataList, 'js');
								crud = "R";
							}
						}
						$erp.setDhtmlXGridFooterRowCount(erpAllGrid);
						erpLayout.progressOff();
					}, error : function(jqXHR, textStatus, errorThrown){
						erpLayout.progressOff();
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
			}
	   <%-- ■ SearchErpGrid 관련 Function 끝 --%>
		  
	   
	   <%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
	   function openGoodsCategoryTreePopup() {
	      var onClick = function(id) {
	         document.getElementById("hidGOODS_CATEG_CD").value = id;
	         document.getElementById("GoodsGroup_Name").value = this.getItemText(id);
	         
	         $erp.closePopup2("openGoodsCategoryTreePopup");
	      }
	      $erp.openGoodsCategoryTreePopup(onClick);
	   }
	   
	   <%-- openSearchCustmrGridPopup 공급사 조회 팝업 열림 Function --%>
	   function openSearchCustmrGridPopup(){
			var pur_sale_type = "1"; //협력사(매입처) == "1" 고객사(매출처) == "2"
			
			var onRowSelect = function(id, ind) {
				document.getElementById("txtSUPR_CD").value = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
				document.getElementById("txtSUPR_NM").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
				
				$erp.closePopup2("openSearchCustmrGridPopup");
			}
			$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
		}
	   
	   <%-- openGoodsGroupGridPopup 상품집합그룹관리 팝업 열림 Function --%>
	// 상품집합그룹관리 팝업 여는 함수, 상세상품 리스트 가져오는 예시
		function openGoodsGroupGridPopup() {
			if($('#Select_Goods').is(":checked") == true) {
				var useGoodsGrup = function(erpPopupGrid) {
					var check = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("SELECT"));
					console.log(check);
					var checkArray = check.split(",");
					var GRUP_CD_Array = [];
					var GRUP_NM_Array = [];
					
					for(var i = 0 ; i < checkArray.length ; i ++) {
						GRUP_CD_Array.push(erpPopupGrid.cells(checkArray[i], erpPopupGrid.getColIndexById("GRUP_CD")).getValue());
						GRUP_NM_Array.push(erpPopupGrid.cells(checkArray[i], erpPopupGrid.getColIndexById("GRUP_NM")).getValue());
					}
					
					$('#txtGRUP_CD').val(GRUP_CD_Array[0]);
					$('#txtGOODS_NAME').val(GRUP_NM_Array[0]);
					console.log(GRUP_CD_Array[0] + " / " + GRUP_NM_Array[0]);
					$erp.closePopup2("openGoodsGroupGridPopup");
				}
					
				$erp.openGoodsGroupGridPopup(useGoodsGrup);
			}
		}
		
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		 <table id="tb_erp_data" class="table_search">
	         <colgroup>
	            <col width="70px;">
	            <col width="250px;">
	            <col width="75px;">
	        
	         </colgroup>
	         <tr>
	         	<th>상품분류</th>
	            <td>
	               <input type="hidden" id="hidGOODS_CATEG_CD">
	               <input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" disabled="disabled"/>
	               <input type="button" id="GoodsGroup_Search" value="검색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
	         	</td>
	         	<th>마감일자</th>
	         	<td>
	         	<input type="text" id="SEARCH_DATE_FROM" name="SEARCH_DATE_FROM" class="input_calendar_ym default_date" data-position="-1" >
	         	</td>
	         </tr>
	     </table>
	     <table id="tb_erp_data2" class="table_search">  
	     <colgroup>
	         	<col width="70px;">
	            <col width="250;">
	            <col width="20;">
	         </colgroup>
	         <tr>
	         	<th>협력사</th>
	         	<td>
	         	<input type="hidden" id="txtSUPR_CD" class="input_text" value=""/>
				<input type="text" id="txtSUPR_NM" class="input_text" readonly="readonly" disabled="disabled"/>
				<input type="button" id="" class="input_common_button" value="검색" onClick="openSearchCustmrGridPopup();"/>
	         	</td>
	         	<th></th>
	         	<td>
	         	<input type="checkbox" id="Invalid_Goods" name="Invalid_Goods"/>
	         	<label for="Invalid_Goods">무효상품포함</label>
	         	<input type="checkbox" id="Ending_Stock" name="Ending_Stock"/>
	         	<label for="Ending_Stock">기말재고수정분</label>
	         	</td>
	         </tr>
	    </table>
	    <table id="tb_erp_data3" class="table_search"> 
	    <colgroup>
	    		<col width="70px;">
	            <col width="250px;">
	            <col width="20px;">
	         </colgroup>
	         <tr>
	         <th>검색어</th>
	    	<td>
	    		<input type="text" id="txtKEY_WORD" name="txtKEY_WORD" class="input_common" maxlength="10" onkeydown="$erp.onEnterKeyDown(event, searchCheck);"/>
	    	</td>
			 <th></th>
			 <td>
			 	<input type="checkbox" id="Select_Goods" name="Select_Goods" onchange="openGoodsGroupGridPopup();"/>
	    		<label for="Select_Goods">상품집합</label>
	    		<input type="hidden" id="txtGRUP_CD"/>
				<input type="text" id="txtGOODS_NAME" name="txtGOODS_NAME" readonly="readonly" disabled="disabled"/> 
	    	</td>
	        </tr> 	
	    </table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none">
	<div id="div_erp_all_grid" class="div_grid_full_size" style="display:none"></div>
	</div>        
</body>
</html>