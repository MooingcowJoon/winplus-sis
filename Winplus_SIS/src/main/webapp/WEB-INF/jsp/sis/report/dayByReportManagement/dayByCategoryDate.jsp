<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<script type="text/javascript" src="/resources/common/js/report.js"></script>
<script type="text/javascript">
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2,3,4";
	LUI.exclude_orgn_type = "OT";
	
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon4rf
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor
		■ searchDateFrom : String / 기간 시작일
		■ searchDateTo : String / 기간 마지막일
	 --%>
	
	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var cmbREPORT_SEARCH_TYPE;
	var AUTHOR_CD = "${screenDto.author_cd}";

	
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
		
		$erp.asyncObjAllOnCreated(function(){
		});
	});
	
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "일_분류별일자별 조회", header:false}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(95);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
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
					//, {id : "print_erpGrid", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : false}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	SearchErpGrid();
		    } else if(itemId == "excel_erpGrid"){
		    	//추가된 컬럼들은 엑셀에 표시가 안됨(수정필요)
		    	erpGirdExcelPrint();
		    } else if (itemId == "print_erpGrid"){
		    	
		    }
		});
	}
	
	function erpGirdExcelPrint(){
		console.log(erpGrid);
		$erp.exportDhtmlXGridExcel({
    		"grid" : erpGrid
    		, "fileName" : "일레포트-분류별일자별"		
    		, "isForm" : false
    	});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpGrid 관련 Function 시작 --%>
	function initErpGrid() {
		erpGridColumns = [ //id값 변경필수!
              {id : "GRUP_NM", label:["분류명", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false}              
              , {id : "STD_GRUP_CD", label:["분류코드", "#rspan"], type: "ro", width: "100", sort : "str", align : "left", isHidden : true}              
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
		//$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off");//변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		//$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
		
		erpGrid.attachEvent("onRowDblClicked", function(rId, cInd){
			$("#GoodsGroup_Name").val(erpGrid.cells(rId, erpGrid.getColIndexById("GRUP_NM")).getValue());
			$("#hidGOODS_CATEG_CD").val(erpGrid.cells(rId, erpGrid.getColIndexById("STD_GRUP_CD")).getValue());
			SearchErpGrid();
		});
		
	}
	<%-- ■ erpGrid 관련 Function 끝 --%>
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		//cmbREPORT_SEARCH_TYPE = $erp.getDhtmlXComboCommonCode("cmbREPORT_SEARCH_TYPE", "REPORT_SEARCH_TYPE", "REPORT_SEARCH_TYPE", 100, null, "00");
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, "AllOrOne", false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, LUI.LUI_orgn_cd, function(){
				if(cmbORGN_DIV_CD.getSelectedValue() == ""){
					cmbORGN_CD.unSelectOption();
					cmbORGN_CD.clearAll();
				}
			});
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				if(value != ""){
					$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
				}
			}); 
		});
	} 
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
	
	<%-- 조회 관련 function --%>
	function SearchErpGrid() {
		console.log(erpGrid.getRowsNum());
		var colCnt = erpGrid.getColumnsNum();
		if(colCnt != 2){
			for(var j = colCnt ; j > 1 ; j--){
				erpGrid.deleteColumn(j);
			}
		}
		
		if(erpGrid.getRowsNum() != 1){
			for(var k = colCnt ; k > 1 ; k--){
				erpGrid.deleteColumn(k);
			}
		}
		
		var per_date = dateDiff($("#searchDateFrom").val(), $("#searchDateTo").val());
		
		if(per_date > 31){
			$erp.alertMessage({
				"alertMessage" : "조회기간은 31일 이내로 설정해주세요.",
				"alertCode" : null,
				"alertType" : "alert",
				"alertCallbackFn" : $erp.clearDhtmlXGrid(erpGrid),
				"isAjax" : false
			});
		} else {
			var DateList = [];
			getDateRange($("#searchDateFrom").val(), $("#searchDateTo").val(), DateList);
			console.log(DateList);
			$erp.clearDhtmlXGrid(erpGrid);
			var date = "";
			var column_id = "GRUP_NM,STD_GRUP_CD";
			
			var id;
			var label;
			var type;
			var width;
			var sort;
			var align;
			var colNum = erpGrid.getColumnsNum();
			console.log(colNum);
			for(var i = colNum ; i <= per_date+colNum ; i++){
				id = DateList[i-colNum].replace(/\-/g, '');
				label = [DateList[i-colNum].replace(/\-/g, ''), "#rspan"];
				type = "ron";
				width = 80;
				sort = "str";
				align = "right";
				
				erpGrid.insertColumn(i, label, type, width, sort, align);
				erpGrid.setNumberFormat("0,000", i);
				column_id += "," + (DateList[i-colNum].replace(/\-/g, ''));
				
				//insertColumn한 컬럼들 columnsMapArray에 추가 (엑셀다운로드시 추가된 컬럼 적용위함)
				erpGrid.columnsMapArray.push({id:id,label:label,type:type,width:width,sort:sort,align:align});
			}
			console.log(column_id);
			erpGrid.setColumnIds(column_id);
			
			
			
			var paramMap = {
				"searchDateFrom" : $("#searchDateFrom").val()
				, "searchDateTo" : $("#searchDateTo").val()
				, "GRUP_CD" : $("#hidGOODS_CATEG_CD").val()
				, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
				, "ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
				, "DELIGATE_ORGN_DIV_CD" : "C"
			}
			
			erpLayout.progressOn();
			$.ajax({
				url : "/sis/report/dayByReport/getDayByCategoryDateList.do"
				,data : paramMap
				,method : "POST"
				,dataType : "JSON"
				,success : function(data) {
					erpLayout.progressOff();
					var gridDataList = data.gridDataList;
					
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						if($erp.isEmpty(gridDataList) || gridDataList.length == 1){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpGrid
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpGrid.parse(gridDataList, 'js');
							for(var i = 0 ; i < gridDataList.length ; i++){
								if(gridDataList[i].GRUP_NM == '합계'){
									erpGrid.setRowTextStyle(erpGrid.getRowId(i), "background-color : lightpink;");
									//erpGrid.cells(erpGrid.getRowId(i), erpGrid.getColIndexById("GRUP_NM")).setBgColor("pink");
								}
								 else if (gridDataList[i].GRUP_NM == '평균'){
									 erpGrid.setRowTextStyle(erpGrid.getRowId(i), "background-color : lightgreen;");
								} else {
									erpGrid.cells(erpGrid.getRowId(i), erpGrid.getColIndexById("GRUP_NM")).setBgColor("lightyellow");
								}
							}
						}
					}
					//$erp.setDhtmlXGridFooterRowCount(erpGrid);
				}, error : function(jqXHR, textStatus, errorThrown){
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
		
	}
	
	function getDateRange(fromDate, toDate, DateList){ //정해진 기간 사이의 모든 기간 리스트에 넣기
		DateList.length = 0;
        var dateMove = new Date(fromDate);
        var strDate = fromDate;
        if (fromDate == toDate)
        {
            var strDate = dateMove.toISOString().slice(0,10);
            DateList.push(strDate);
        }
        else
        {
            while (strDate < toDate)
            {
                var strDate = dateMove.toISOString().slice(0, 10);
                DateList.push(strDate);
                dateMove.setDate(dateMove.getDate() + 1);
            }
        }
        return DateList;
    }

	function dateDiff(date1, date2) {
	    var diffDate_1 = date1 instanceof Date ? date1 :new Date(date1);
	    var diffDate_2 = date2 instanceof Date ? date2 :new Date(date2);
	 
	    diffDate_1 =new Date(diffDate_1.getFullYear(), diffDate_1.getMonth()+1, diffDate_1.getDate());
	    diffDate_2 =new Date(diffDate_2.getFullYear(), diffDate_2.getMonth()+1, diffDate_2.getDate());
	 
	    var diff = Math.abs(diffDate_2.getTime() - diffDate_1.getTime());
	    diff = Math.ceil(diff / (1000 * 3600 * 24));
	 
	    return diff;
	}

	<%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
	function openGoodsCategoryTreePopup() {
		var onClick = function(id) {
			document.getElementById("hidGOODS_CATEG_CD").value = id;
			document.getElementById("GoodsGroup_Name").value = this.getItemText(id);
			
			$erp.closePopup2("openGoodsCategoryTreePopup");
		}
		$erp.openGoodsCategoryTreePopup(onClick);
	}

</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table id="tb_erp_data" class="table_search">
			<colgroup>
				<col width="70px;">
			    <col width="230px;">
			    <col width="70px">
			    <col width="*">
			</colgroup>
			<tr>
				<th>법인구분</th>
				<td>
					<div id="cmbORGN_DIV_CD"></div>
				</td>
				<th>조직명</th>
				<td>
					<div id="cmbORGN_CD"></div>
				</td>
			</tr>
			<tr>
				<th>상품분류</th>
				<td>
					<input type="hidden" id="hidGOODS_CATEG_CD" value="ALL">
					<input type="text" id="GoodsGroup_Name" name="GoodsGroup_Name" readonly="readonly" value="전체분류" disabled="disabled"/>
					<input type="button" id="GoodsGroup_Search" value="검 색" class="input_common_button" onclick="openGoodsCategoryTreePopup();"/>
<!-- 					<input type="checkbox" id="Select_Goods" name="Select_Goods"/> -->
<!-- 					<label for="Select_Goods">하위분류표시</label> -->
				</td>
			</tr>
		</table>
		<table  id="tb_erp_data2" class="table_search">
			<colgroup>
		    	<col width="70px">
		        <col width="240px">
		        <col width="120px">
		        <col width="*">
		    </colgroup>
			<tr>
				<th>기     간</th>
				<td>
					<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar default_date" data-position="(start)">
					 ~ <input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar default_date" data-position="">
				</td>
<!-- 				<td colspan="2"> -->
<!-- 					 <div id="cmbREPORT_SEARCH_TYPE"></div> -->
<!-- 				</td> -->
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>