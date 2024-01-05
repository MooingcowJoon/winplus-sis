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
	LUI.exclude_auth_cd = "All,1,2";
	
	/* 조회컬럼내용 수정 필요 (수정진행중_필요하신사항은 요청주세요.) */
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openSearchGoodsGridPopup");
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;
	var erpPopupGoodsOnRowSelect;
	var erpPopupGoodsCheckList;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var paramORGN_DIV_CD = '${paramMap.ORGN_DIV_CD}';
	var paramORGN_CD = '${paramMap.ORGN_CD}';
	var paramSHOW_TYPE = '${paramMap.SHOW_TYPE}';  //법인구분, 조직명 노출여부 (true = '미노출', (null or false) = '노출')
	var paramDISABLE = '${paramMap.DISABLE}';      //법인구분, 조직명 disable
	var AUTHOR_CD = "${screenDto.author_cd}";
	
	console.log("paramSHOW_TYPE >> " + paramSHOW_TYPE);
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("상품조회");
		}
		initDhtmlXCombo();
		initErpPopupLayout();
		initErpPopupRibbon();
		initErpGrid();
		
		$erp.asyncObjAllOnCreated(function(){
			if(paramDISABLE == 'true'){
				cmbORGN_DIV_CD.disable();
				cmbORGN_CD.disable();
			}
		});
	});
	
	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "", header : false}
				, {id:"b", text: "", header : false, fix_size:[true, true]}
				, {id:"c", text: "", header : false}
			]
		});
		erpPopupLayout.cells("a").attachObject("div_erp_contents_search");
		if(paramSHOW_TYPE == "true"){
			erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		}else {
			erpPopupLayout.cells("a").setHeight(65);
		}
		erpPopupLayout.cells("b").attachObject("div_erp_ribbon");
		erpPopupLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("c").attachObject("div_erp_grid");
		
		erpPopupLayout.setSeparatorSize(1,0);
		<%-- erpPopupLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupGrid.setSizes();
		});
	}
	
	
	<%-- ■ erpPopupRibbon 관련 Function 시작 --%>
	<%-- erpPopupRibbon 초기화 Function --%>	
	function initErpPopupRibbon(){
		var use_items = null;
		
		var items_01 = [
			{type : "block", mode : 'rows', list : [
				{id : "search_erpGrid", type : "button", text:'조회', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
				, {id : "add_erpGrid", type : "button", text:'추가', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : false}
			]}	
		];
		
		var items_02 = [
			{type : "block", mode : 'rows', list : [
				{id : "search_erpGrid", type : "button", text:'조회', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
			]}	
		];
		
		//erpPopupCustmrCheckList가 없으면 거래처 여러개 추가버튼 hide
		if($erp.isEmpty(window["erpPopupGoodsCheckList"])){
			use_items = items_02;
		} else {
			use_items = items_01;
		}
		
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : use_items
		});
		
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if(itemId == "add_erpGrid"){
		    	addErpGridData();
		    }
		});
	}
	<%-- ■ erpPopupRibbon 관련 Function 끝 --%>
	
	<%-- ■ erpPopupGrid 관련 Function 시작 --%>	
	<%-- erpPopupGrid 초기화 Function --%>	
	function initErpGrid(){
		erpPopupGridColumns = [
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "ORGN_CD", label:["조직명"], type: "combo", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : true, isDisabled: true, commonCode : ["ORGN_CD", "", "", "", "", "MK"]}
			, {id : "GOODS_TOP_CD", label:["대분류코드"], type: "ro", width: "120", sort : "int", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			, {id : "GOODS_MID_CD", label:["중분류코드"], type: "ro", width: "120", sort : "int", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			, {id : "GOODS_BOT_CD", label:["소분류코드"], type: "ro", width: "120", sort : "int", align : "center", isHidden : true, isEssential : false, isDataColumn : true}
			, {id : "BCD_NM", label:["상품명"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : false, isDataColumn : true}
			, {id : "GOODS_NM", label:["상품명"], type: "ro", width: "250", sort : "str", align : "left", isHidden : true, isEssential : false, isDataColumn : true}
			, {id : "GOODS_NO", label:["상품코드"], type: "ro", width: "120", sort : "int", align : "left", isHidden : true, isEssential : false, isDataColumn : true}
			, {id : "BCD_M_CD", label:["모바코드"], type: "ro", width: "120", sort : "int", align : "left", isHidden : true, isEssential : false, isDataColumn : true}
			, {id : "BCD_CD", label:["바코드"], type: "ro", width: "150", sort : "int", align : "left", isHidden : false, isEssential : false, isDataColumn : true}
			, {id : "SALE_PRICE", label:["바코드"], type: "ro", width: "150", sort : "int", align : "left", isHidden : true, isEssential : false, isDataColumn : true}
			, {id : "DIMEN_NM", label:["규격"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "UNIT_CD", label:["단위"], type: "combo", width: "100", sort : "str", align : "right", isHidden : false, isEssential : false, isDisabled : true, commonCode : "UNIT_CD"}
			, {id : "UNIT_QTY", label:["입수량"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "DIMEN_WGT", label:["중량(g)"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "BCD_BOX_CD", label:["박스바코드"], type: "ro", width: "100", sort : "int", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_STOCK_CD", label:["재고소진바코드"], type: "ro", width: "100", sort : "int", align : "left", isHidden : false, isEssential : false}
		];
		
		erpPopupGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpPopupGridColumns
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
		
		if($erp.isEmpty(window["erpPopupGoodsCheckList"])){
			erpPopupGrid.setColumnHidden(erpPopupGrid.getColIndexById("CHECK"), true);
		}
		
		if(!$erp.isEmpty(erpPopupGoodsOnRowSelect) && typeof erpPopupGoodsOnRowSelect === 'function'){
			erpPopupGrid.attachEvent("onRowDblClicked", erpPopupGoodsOnRowSelect);
		}
	}
	
	<%-- erpPopupGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;
		var txtSearch1 = document.getElementById("txtSearch1").value;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		if($erp.isLengthOver(txtSearch1, 50)){
			isValidated = false;
			alertMessage = "error.common.system.menu.scrin_nm.length50Over";
			alertCode = "-1";
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
	function searchErpGrid(){
		if(!isSearchValidate()){
			return;
		}
		
		var param_orgn_div_cd = "";
		var param_orgn_cd = "";
		
		if(paramSHOW_TYPE != "true"){
			param_orgn_div_cd = cmbORGN_DIV_CD.getSelectedValue();
			param_orgn_cd = cmbORGN_CD.getSelectedValue();
		}
		
		erpPopupLayout.progressOn();
		$.ajax({
			url : "/common/popup/getGoodsList.do"
			,data : {
				"KEY_WORD" : $("#txtSearch1").val()
				, "SHOW_TYPE" : paramSHOW_TYPE
				, "ORGN_DIV_CD" : param_orgn_div_cd
				, "ORGN_CD" : param_orgn_cd
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				
				erpPopupLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpPopupGrid);
					var GoodsList = data.GoodsList;
					if($erp.isEmpty(GoodsList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						
						erpPopupGrid.parse(GoodsList, 'js');	
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
			
		});
	}
	
	function addErpGridData() {
		var Check_YN = erpPopupGrid.getCheckedRows(erpPopupGrid.getColIndexById("CHECK"));
		if(Check_YN != ""){
			if(!$erp.isEmpty(erpPopupGoodsCheckList) && typeof erpPopupGoodsCheckList === 'function'){
	 			erpPopupGoodsCheckList(erpPopupGrid);
	 		}
		} else {
			$erp.alertMessage({
				"alertMessage" : "체크된 상품항목이 없습니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		}
	}
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		if(paramSHOW_TYPE == "true"){
			$("#ORGN_DIV_TITLE").css("display", "none");
			$("#ORGN_TITLE").css("display", "none");
			$("#cmbORGN_DIV_CD").css("display", "none");
			$("#cmbORGN_CD").css("display", "none");
		}else{
			if(paramORGN_CD != "" && paramORGN_DIV_CD != ""){ // 법인코드, 조직코드 모두 보낸경우(검색권한적용필요)
				cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, paramORGN_DIV_CD, function(){
					cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, paramORGN_CD);
					cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
						cmbORGN_CD.unSelectOption();
						cmbORGN_CD.clearAll();
						$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
					});
				});
			}else if(paramORGN_CD == "" && paramORGN_DIV_CD != ""){ // 법인코드만 보낸경우
				cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, paramORGN_DIV_CD, function(){
					cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, null);
					cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
						cmbORGN_CD.unSelectOption();
						cmbORGN_CD.clearAll();
						$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
					}); 
				});
				cmbORGN_DIV_CD.disable();
			}else if(paramORGN_CD != "" && paramORGN_DIV_CD == ""){ //조직코드만 보낸경우
				console.log(paramORGN_CD);
				$.ajax({
					url : "/common/organ/getOrgnDivCdByOrgnCd.do"
					,data : {
						"ORGN_CD" : paramORGN_CD
					}
					,method : "POST"
					,dataType : "JSON"
					,success : function(data){
						erpPopupLayout.progressOff();
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						} else {
							var ORGN_DIV_CD = data.ORGN_DIV_CD;
							cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, ORGN_DIV_CD, function(){
								cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, paramORGN_CD);
								cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
									cmbORGN_CD.unSelectOption();
									cmbORGN_CD.clearAll();
									$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
								});
							});
						}
					}, error : function(jqXHR, textStatus, errorThrown){
						erpPopupLayout.progressOff();
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
					
				});
			}else if(paramORGN_CD == "" && paramORGN_DIV_CD == ""){ // 법인코드, 조직코드 모두 안보낸경우
				cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
					cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", LUI.LUI_orgn_cd, null);
					cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
						cmbORGN_CD.unSelectOption();
						cmbORGN_CD.clearAll();
						$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
					}); 
				});
			}
		}
	} 
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
</script>
</head>
<body>
	<div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
		<table class="table_search">
			<colgroup>
				<col width="100px">
				<col width="220px">
				<col width="60px">
				<col width="*">				
			</colgroup>
			<tr>
				<th id="ORGN_DIV_TITLE">법인구분</th>
				<td><div id="cmbORGN_DIV_CD"></div></td>
				<th id="ORGN_TITLE">조직명</th>
				<td><div id="cmbORGN_CD"></div></td>
			</tr>
			<tr>
				<th>검색어</th>
				<td colspan="3">
					<input type="text" id="txtSearch1" size="12" maxlength="50" onkeydown="$erp.onEnterKeyDown(event, searchErpGrid, ['']);" style="margin-left:5px; padding-bottom: 3px;">
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" 	class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>