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
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbPartnerIO : Object / 거래처구분(매입 or 매출) DhtmlXCombo  (CODE : PUR_SALE_TYPE )
		■ cmbPamentDay : Object / 마감일자(결제기준) DhtmlXCombo  (CODE : PAY_STD ) 		 
		■ cmbSourcing : Object / 마감일자(결제기준) DhtmlXCombo  (CODE : SUPR_GOODS_GRUP ) 		 
		■ cmbPartnerPart : Object / 공급사분류코드 DhtmlXCombo  (CODE : SUPR_GRUP_CD ) 		 
		■ cmbPartnerType : Object / 공급사유형  DhtmlXCombo  (CODE : SUPR_TYPE ) 		 
	--%>
	var thisPopupWindow = parent.erpPopupWindows.window('openCustmerSearchPopup');
	var erpLayout;
	var erpRibbon;	
	var erpGrid;
	var erpGridColumns;
	var erpGridDataProcessor;	
	var erpGridSelectedCustmr_cd;   /* 그리드 rowSelected */
	var param_CORP_NO = "";
	
	
	$(document).ready(function(){	
		if(thisPopupWindow){
			thisPopupWindow.setText("${screenDto.scrin_nm}");	
		}
		initErpLayout();
		initErpGrid();
		param_CORP_NO = "${param.CORP_NO}"
	    $('input').prop('readonly', true);	
		searchErpGrid(param_CORP_NO);
	});
	
	
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				       // {id: "a", text: "${menuDto.menu_nm}", header:true, height:1}
		    		   {id: "a", text: "", header:false, fix_size:[true, true]}
			]		
		});
		
		//erpLayout.cells("a").attachObject("div_erp_contents_search");
		erpLayout.cells("a").attachObject("div_erp_grid");
		erpLayout.setSeparatorSize(1, 0);
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpGrid.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- erpGrid 초기화 Function --%>	
	function initErpGrid(){
		erpGridColumns = [
			  {id : "NO"            , label:["NO"             ], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "custmr_cd"     , label:["거래처코드"     ], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "custmr_nm"     , label:["거래처명"       ], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "custmr_ceonm"  , label:["대표자명"       ], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "corp_no"       , label:["사업자번호"     ], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "taxbill_cd"    , label:["세무신고거래처" ], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "corp_ori_no"   , label:["종사업장번호"   ], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "busi_cond"     , label:["업태"           ], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "busi_type"     , label:["업종"           ], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "cdate"         , label:["생성일시"       ], type: "ro", width: "110", sort : "str", align : "center", isHidden : false, isEssential : true}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpGridColumns
		});		
		erpGrid.enableDistributedParsing(true, 100, 50);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		$erp.initGrid(erpGrid);
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off");
		$erp.initGridDataColumns(erpGrid);

	}


	<%-- erpGrid 조회 Function --%>
	function searchErpGrid(CORP_NO){
		erpLayout.progressOn();
		
		//$erp.dataSerialize("aaa");
		//,data : { "aaa".dataSerialize}
		
		$.ajax({
			 url      : "/sis/basic/custmrSearchPopup.do"
			,data     : {  "CORP_NO" : CORP_NO }
			,method   : "POST"
			,dataType : "JSON"
			,success  : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpGrid.parse(gridDataList, 'js');	
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
</script>
</head>
<body>	
	<div id="div_erp_grid"   class="div_grid_full_size"   style="display:none"></div>
</body>
</html>