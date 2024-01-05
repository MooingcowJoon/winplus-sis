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
	var searchCheck = "ribbon";
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;

	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		
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
		    		SearchErpGrid();
		    	}
	         }
		 });
	}
	
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid() {
		
		erpGrid = {};
		
		//======================= 펼쳐보기 ====================================================
		erpAllGridColumns = [ //id값 변경필수!
			{id : "index", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false} 
			, {id : "", label:["공급사코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["공급사", "#rspan"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["구분", "#rspan"], type: "ro", width: "60", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["상품종수", "#rspan"], type: "ro", width: "70", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["매입가액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["판매가액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["보증금", "#rspan"], type: "ro", width: "90", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["면세재고", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["과세재고", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["물품가액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["부가세", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
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
		
	}
	
	<%-- dhtmlXCombo 초기화 Function --%>   
	   function initDhtmlXCombo(){
		   cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, true, null, function(){
		         cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, null);
		         cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
		            cmbORGN_CD.unSelectOption();
		            cmbORGN_CD.clearAll();
		            $erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
		         }); 
		      });
	   } 
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	   
	<%-- ■ SearchErpGrid 관련 Function 시작 --%>
	   
	   function SearchErpGrid(grid_data) {	
		   var ORGN_DIV_CD = cmbORGN_DIV_CD.getSelectedValue();
		   var ORGN_CD = cmbORGN_CD.getSelectedValue();
			
		   	 $.ajax({
					url: "/sis/stock/stockManagement/.do"
					, data : {
						"ORGN_DIV_CD" : ORGN_DIV_CD
						, "ORGN_CD" : ORGN_CD
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
	            <col width="100px;">
	            <col width="250px;">
	             <col width="80px;">
	         </colgroup>
	         <tr>
	         	<th>상품분류</th>
	            <td>
	               <input type="hidden" id="hidGOODS_CATEG_CD">
	               <input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" disabled="disabled"/>
	               <input type="button" id="GoodsGroup_Search" value="검색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
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
	         	<col width="70px;">
	            <col width="250;">
	            <col width="20;">
	         </colgroup>
	         <tr>
	         	<th>공급사</th>
	         	<td>
	         	<input type="hidden" id="txtSUPR_CD" class="input_text" value=""/>
				<input type="text" id="txtSUPR_NM" class="input_text" readonly="readonly" disabled="disabled"/>
				<input type="button" id="" class="input_common_button" value="검색" onClick="openSearchCustmrGridPopup();"/>
	         	</td>
	         	<th></th>
	         	<td>
	         	<input type="checkbox" id="Invalid_Goods" name="Invalid_Goods"/>
	         	<label for="Invalid_Goods">무효상품포함</label>
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