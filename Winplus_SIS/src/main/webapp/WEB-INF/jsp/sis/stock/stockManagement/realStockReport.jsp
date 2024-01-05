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
	  
	--%>
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpAllGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		initErpGrid();
		
        document.getElementById("searchDateFrom").value=todayDate;
	    document.getElementById("searchDateTo").value=today;
	
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
		    	if(document.getElementById("cmbLOSS").value == ""){
		    		$erp.alertMessage({
		    			"alertMessage" : "error.sis.goods.search.grup_nm.empty"
		    			, "alertType" : "error"
		    		});
		    	}
		    	else{
		    		$erp.alertMessage({
						"alertMessage" : "준비 중 입니다.",
						"alertType" : "alert",
						"isAjax" : false
					});
		    		//SearchErpGrid();
		    		}
		    	} 
	     	 });
		}
	
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid() {
		
		erpGrid = {};
		
		erpAllGridColumns = [ 
			{id : "index", label:["No", "#rspan"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}              
			, {id : "", label:["전표타이틀", "#rspan"], type: "ro", width: "170", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["조사자", "#rspan"], type: "ro", width: "70", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["실사상품건", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["실사매입가액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
	        , {id : "", label:["실사판매가액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
	        , {id : "", label:["실사전매입가액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["실사전판매가액", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["매입가액차", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["판매가액차", "#rspan"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["전표등록일시", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "", label:["실사적용일시", "#rspan"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
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
	<%-- ■ erpGrid 관련 Function 끝 --%>
	   
	   
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
		   
		   cmbLOSS = new dhtmlXCombo("cmbLOSS");
		   cmbLOSS.setSize(120);
		   cmbLOSS.readonly(true);
		   cmbLOSS.addOption([   
              {value: "00", text: "--로스유형--" ,selected: true}
              ,{value: "01", text: "로스 = 0"}      
              ,{value: "02", text: "로스발생(+)"}      
              ,{value: "03", text: "로스발생(-)"}      
              ,{value: "04", text: "로스발생(모두)"}           
           ]);
	   } 
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	   
	   <%-- ■ SearchErpGrid 관련 Function 시작 --%>
		   function SearchErpGrid(grid_data) {	
			 
				
			   	 $.ajax({
						url: "/sis/stock/stockManagement/.do"
						, data : {
						
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
		  
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
	     <table id="tb_erp_data" class="table_search">  
	     <colgroup>
	         	<col width="80px;">
	            <col width="220px;">
	            <col width="120px;">
	             <col width="230px;">
	             <col width="100px;">
	         </colgroup>
	         <tr>
	         	<th>재고변경일</th>
	            <td>
	               <input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
	                ~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
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
	         	<col width="80px;">
	            <col width="240;">
	            <col width="20;">
	         </colgroup>
	         <tr>
	         	<th></th>
	         	<td>
	         		<div id="cmbLOSS"></div>
	         	</td>
	         	<th></th>
				<td>
					<input type="button" id="byDocument" value="전표별" class="input_common_button" onclick="">
					<input type="button" id="byMajor" value="대분류별" class="input_common_button" onclick="">
					<input type="button" id="byClass" value="중분류별" class="input_common_button" onclick="">
					<input type="button" id="bySupplier" value="공급사별" class="input_common_button" onclick="">
					<input type="button" id="allByDocument" value="전표별 전체단품" class="input_common_button" onclick="">
					<input type="button" id="allByClass" value="중분류별 전체단품" class="input_common_button" onclick="">
					<input type="button" id="allBySupplier" value="공급사별 전체단품" class="input_common_button" onclick="">
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