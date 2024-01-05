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
	■ searchCheck : String / 리본&더블클릭 조회 체크
    ■ grup_cd : String / 더블클릭 조회 시 분류별코드
	  
	--%>

	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpAllGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var searchCheck = "ribbon";
	var grup_cd;
	
	
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
		erpLayout.cells("a").setHeight(65);
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
		    	searchCheck = "ribbon";
		    	if(document.getElementById("hidGOODS_CATEG_CD").value == ""){
		    		$erp.alertMessage({
		    			"alertMessage" : "error.sis.goods.search.grup_nm.empty"
		    			, "alertType" : "error"
		    		});
		    	}
		    	else{
		    		isSearchValidate(document.getElementById("hidGOODS_CATEG_CD").value);
		    	}
	        } else if(itemId == "excel_erpGrid"){
		    	$erp.exportGridToExcel({
		    		"grid" : erpAllGrid
					, "fileName" : "월말재고(분류별)"
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
			 {id : "GRUP_NM", label:["분류명", "#rspan"], type: "ro", width: "130", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "GRUP_CD", label:["분류코드", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "GOODS_NUM", label:["상품종수", "#rspan"], type: "ro", width: "70", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "PAY_SUM_AMT", label:["매입가액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "SALE_AMT", label:["판매가액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "GRNT_AMT", label:["보증금", "#rspan"], type: "ro", width: "90", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "TAX_PUR_AMT", label:["과세재고", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "COM_AMT", label:["물품가액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "VAT", label:["부가세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : true}
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
		
		erpAllGrid.attachEvent("onRowDblClicked", function(rId){
	    	  var grup_cd = this.cells(rId, this.getColIndexById("GRUP_CD")).getValue();
	    	  //현재선택된 그룹의 depth확인 후 대분류이면 더블클릭시, 해당 대분류내 중분류 조회내역, 중분류였으면 더블클릭시, 해당 중분류내 소분류 조회내역 보여짐처리
	    	   
	          searchCheck = "Dbclick";
	    	  isSearchValidate(grup_cd);
	      });
		
		erpGrid["div_erp_all_grid"] = erpAllGrid;
		
		document.getElementById("div_erp_all_grid").style.display = "block";
		
	}
	   
	<%-- ■ SearchErpGrid 관련 Function 시작 --%>
	   function isSearchValidate(grup_cd) {
		   
			$("#div_erp_grid").children().each(function(index, obj){
				var display = obj.style.display;
				if(display == "block"){
					var id = obj.id;
					var grid_ID = obj.getAttribute("id");
					if (grid_ID == "div_erp_all_grid"){
						console.log("조회영역 보기");
						SearchErpGrid(erpAllGrid, grup_cd);
					} 
					} else {
							console.log("나머지 조회 영역");
						}
					return false;
				
			});
		}   
	
	function SearchErpGrid(grid_data, grup_cd) {	
		   var SEARCH_DATE_FROM = document.getElementById("SEARCH_DATE_FROM").value;
		   var SURP_CD = document.getElementById("txtSUPR_CD").value;
		   var GRUP_CD = grup_cd;
		   var Invalid_Goods = $('input[name=Invalid_Goods]:checked').length;
		   var Select_Goods = $('input[name=Select_Goods]:checked').length;
		   
		   console.log("SEARCH_DATE_FROM >>" + SEARCH_DATE_FROM);
		   console.log("SURP_CD >>" + SURP_CD);
		   console.log("GRUP_CD >>" + GRUP_CD);
		   console.log("Invalid_Goods >>" + Invalid_Goods);
		   console.log("Select_Goods >>" + Select_Goods);
		   
		   	 $.ajax({
					url: "/sis/stock/stockManagement/monStockByCategoryList.do"
					, data : {
						"SEARCH_DATE_FROM" : SEARCH_DATE_FROM
						, "SURP_CD" : SURP_CD
						, "GRUP_CD" : GRUP_CD
						, "Invalid_Goods" : Invalid_Goods
						, "Select_Goods" : Select_Goods
						, "searchCheck" : searchCheck
					}
				   	, method : "POST"
						, dataType : "JSON"
						, success : function(data){
							erpLayout.progressOn();
							if(data.isError){
								$erp.ajaxErrorMessage(data);
							}else {
								$erp.clearDhtmlXGrid(grid_data);
								var gridDataList = data.gridDataList;
								if($erp.isEmpty(gridDataList)){
									$erp.addDhtmlXGridNoDataPrintRow(
										grid_data
										,  '<spring:message code="grid.noSearchData" />'
									);
								}else {
									grid_data.parse(gridDataList, 'js');
									
								}
							}
							$erp.setDhtmlXGridFooterRowCount(grid_data);
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
		
	   
	
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
				<input type="button" id="Custmr_Search" class="input_common_button" value="검색" onClick="openSearchCustmrGridPopup();"/>
	         	</td>
	         	<th></th>
	         	<td>
	         	<input type="checkbox" id="Invalid_Goods" name="Invalid_Goods"/>
	         	<label for="Invalid_Goods">무효포함</label>
	         	<input type="checkbox" id="Select_Goods" name="Select_Goods"/>
	         	<label for="Select_Goods">하위분류표시</label>
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