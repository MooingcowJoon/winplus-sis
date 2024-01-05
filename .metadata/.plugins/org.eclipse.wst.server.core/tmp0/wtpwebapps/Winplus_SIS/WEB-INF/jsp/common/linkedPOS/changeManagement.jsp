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

	var erpLayout;
	var erpRibbon;
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;
	var searchDateFrom;
	var searchDateTo;
	var cmbMarketCD;
	var cmbPOS_NO;
	var posNumber;
	
	$(document).ready(function(){
		initErpLayout();
		initErpRibbon();
		initErpGrid();
		initDhtmlXCombo();
	});
	
	function initErpLayout() {
		erpLayout =new dhtmlXLayoutObject({
			parent: document.body
			, skin: ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "조회조건영역", header: false}
				,{id: "b", text: "리본버튼영역", header: false, fix_size:[true,true]}
				,{id: "c", text: "그리드영역", header: false}
			 ]
		});
		
		erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").setHeight(25);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("c").attachObject("div_erp_grid");
		
		erpLayout.setSeparatorSize(1,0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
		});
	}
	
	function initErpRibbon() {
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
				SearchErpGrid();
             }
		});
     }
	
	function initErpGrid() {
		erpGridColumns = [
                {id : "No", label:["No"], type: "cntr", width: "30", sort : "str", align : "left", isHidden : false, isEssential : false}
              , {id : "CDATE", label:["영업시작일"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
              , {id : "ORGN_CD", label:["직영점"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false, isDisabled : true ,commonCode : ["ORGN_CD", "MK"]}
              , {id : "POS_CNT", label:["포스설치대수"], type: "ron", width: "100", sort : "int", align : "center", isHidden : false, isEssential : false}
              , {id : "VAT_TYPE", label:["부가세구분"], type: "combo", width: "100", sort : "str", align : "center", isHidden : false, isEssential : false, isDisabled : true, commonCode : ["USE_CD", "YN"]}
              , {id : "SETTING", label:["환경설정값"], type: "ro", width: "800", sort : "str", align : "left", isHidden : false, isEssential : false}
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
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGrid.attachEvent("onRowDblClicked", function(rId, cInd){
			var ORGN_CD = erpGrid.cells(rId, erpGrid.getColIndexById("ORGN_CD")).getValue();
			openPosPreferencesByMarket(ORGN_CD);
		});
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
			
		erpGrid.attachEvent("onRowSelect", function(rId){
				
		}); 
	}
	
	function openPosPreferencesByMarket(param){
		var params = {
				"ORGN_CD" : param
			}
			var url = "/common/pos/PosChangeManagement/openPosPreferencesByMarket.sis";
			var option = {
					"width" : 600
					, "height" :480
					, "win_id" : "openPosPreferencesByMarket"
			}
			
			var onContentLoaded = function(){
				var popWin = this.getAttachedObject().contentWindow;
		        
		        this.progressOff();
		    }
			
			$erp.openPopup(url, params, onContentLoaded, option);
	}
	
	function SearchErpGrid(){
		var ORGN_CD = cmbMarketCD.getSelectedValue();
		
		$.ajax({
			url: "/common/pos/PosChangeManagement/getPosPreferences.do"
			, data : {
				"ORGN_CD" : ORGN_CD
			}
			, method : "POST"
			, dataType : "JSON"
			, success : function(data){
				erpLayout.progressOn();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					$erp.clearDhtmlXGrid(erpGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							,  '<spring:message code="grid.noSearchData" />'
						);
					}else {
						erpGrid.parse(gridDataList, 'js');
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
				erpLayout.progressOff();
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		
	}
	
	function initDhtmlXCombo(){
		cmbMarketCD = $erp.getDhtmlXComboCommonCode("cmbMarketCD", "MarketCD", ["ORGN_CD", "MK"], 100, "모두조회", false, null);
		
		/* cmbMarketCD의 cmbPOS_NO callbackFunction
		cmbPOS_NO = $erp.getDhtmlXComboTableCode("cmbPOS_NO", "POS_NO", "/sis/code/getPosNoList.do", {"ORGN_CD" : cmbMarketCD.getSelectedValue()}, 100, "AllOrOne", false, null);
			cmbMarketCD.attachEvent("onChange", function(value, text){
				cmbPOS_NO.unSelectOption();
				cmbPOS_NO.clearAll();
	            $erp.setDhtmlXComboTableCodeUseAjax(cmbPOS_NO, "/sis/code/getPosNoList.do", {"ORGN_CD" : value}, "AllOrOne", false, null);
			}); 	
	    }
		*/
	}
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table>
			<colgroup>
				<col width="80px">
				<col width="150px">
				<col width="80px">
				<col width="*">
			</colgroup>
			<tr>
				<th>조직명</th>
				<td>
					<div id="cmbMarketCD"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>