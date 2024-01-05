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
	
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2,3,4";
	var total_layout;
	
	var top_layout;
	
	var mid_layout;
	var mid_layout_ribbon;
	
	var bottom_layout;
	var bottom_layout_grid;
	
	var CRUD = "";
	
	$(document).ready(function(){		
		init_total_layout();
		init_top_layout();
		init_mid_layout();
		init_bottom_layout();
		
		$erp.asyncObjAllOnCreated(function(){
		
		});
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
		total_layout.cells("a").setHeight($erp.getTableHeight(4));
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(36);
		total_layout.cells("c").attachObject("div_bottom_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
		
	}
	
	function init_top_layout(){
// 		cmbORGN_DIV_CD = $erp.getDhtmlXComboCommonCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "ORGN_DIV_CD", 210, "모두조회", false, LUI.LUI_orgn_div_cd);
// 		$erp.objReadonly("cmbORGN_DIV_CD");
// 		cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", LUI, 210, null, false, null);
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 170, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 120, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			}); 
		});

		cmbMEM_ABC = $erp.getDhtmlXComboCommonCode("cmbMEM_ABC", "MEM_ABC", "MEM_ABC", 120, null, false, "");
		
		chkGOODS_UNIT_TYPE_chk = $erp.getDhtmlXCheckBox('chkGOODS_UNIT_TYPE_chk', '관리단위', '1', false, 'label-left');
		cmbGOODS_UNIT_TYPE = $erp.getDhtmlXComboCommonCode("cmbGOODS_UNIT_TYPE", "GOODS_UNIT_TYPE", "GOODS_MNG_TYPE", 120, null, false, "");
		
		chkGOODS_SALES_TYPE_chk = $erp.getDhtmlXCheckBox('chkGOODS_SALES_TYPE_chk', '매출유형', '1', false, 'label-left');
		cmbGOODS_SALES_TYPE = $erp.getDhtmlXComboCommonCode("cmbGOODS_SALES_TYPE", "GOODS_SALES_TYPE", "GOODS_SALES_TYPE", 120, null, false, "");
		
		chkGOODS_TAX_YN_chk = $erp.getDhtmlXCheckBox('chkGOODS_TAX_YN_chk', '과세여부', '1', false, 'label-left');
		cmbGOODS_TAX_YN = $erp.getDhtmlXComboCommonCode("cmbGOODS_TAX_YN", "GOODS_TAX_YN", "GOODS_TAX_YN", 120, null, false, "");
		
	}
	
	function init_mid_layout(){
		ribbon = new dhtmlXRibbon({
			parent : "div_mid_layout"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
				           {
				        	   type : "block"
				        	   , mode : 'rows'
			        		   , list : [
			        		             {id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 			        		             , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
// 			        		             , {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
// 			        		             , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
			        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
			        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
			        		             ]
				           }							
				           ]
		});
		
		ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				var dataObj = $erp.dataSerialize("tb_search");
				var url = "/sis/member/getMemberDesignationList.do";
				var send_data = $erp.unionObjArray([LUI,dataObj]);
				var if_success = function(data){
					$erp.clearDhtmlXGrid(bottom_layout_grid); //기존데이터 삭제
					if($erp.isEmpty(data.gridDataList)){
						//검색 결과 없음
						$erp.addDhtmlXGridNoDataPrintRow(bottom_layout_grid, '<spring:message code="info.common.noDataSearch" />');
					}else{
						bottom_layout_grid.parse(data.gridDataList,'js');
						
						var PUR_PRICE; //매입가
						var PRICE_POLI_TYPE; //지정율, 지정가
						var MEM_PROF_RATE; //회원 지정이익율
						var MEM_SALE_PRICE; //회원 지정가
						var tmpStdProfitMultiplier; //기준이익배수
						var result;
						for(var index in data.gridDataList){
							PUR_PRICE = data.gridDataList[index]["PUR_PRICE"];
							PRICE_POLI_TYPE = data.gridDataList[index]["PRICE_POLI_TYPE"];
							MEM_PROF_RATE = data.gridDataList[index]["MEM_PROF_RATE"];
							MEM_SALE_PRICE = data.gridDataList[index]["MEM_SALE_PRICE"];
							
							if(PRICE_POLI_TYPE == "0"){
								tmpStdProfitMultiplier = 1-(MEM_PROF_RATE/100);
								result = Math.floor(PUR_PRICE/tmpStdProfitMultiplier);
								bottom_layout_grid.cells(bottom_layout_grid.getRowId(index), bottom_layout_grid.getColIndexById("MEM_SALE_PRICE")).setValue(result);
							}else if(PRICE_POLI_TYPE == "1"){
								result = (MEM_SALE_PRICE-PUR_PRICE)/MEM_SALE_PRICE*100;
								bottom_layout_grid.cells(bottom_layout_grid.getRowId(index), bottom_layout_grid.getColIndexById("MEM_PROF_RATE")).setValue(result);
							}
						}
						
					}
					$erp.setDhtmlXGridFooterRowCount(bottom_layout_grid); // 현재 행수 계산
				}
				
				var if_error = function(){
					
				}
				
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
			} else if (itemId == "add_grid"){
					
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				$erp.exportDhtmlXGridExcel({
				     "grid" : bottom_layout_grid
				   , "fileName" : "회원지정가"
				   , "isForm" : false
				   , "isHiddenPrint" : "Y"
				});
			} else if (itemId == "print_grid"){
				
			}
		});
	}
	
		
	function init_bottom_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
				{id : "NO", label:["NO"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false,numberFormat : "0,000"}
				, {id : "ORGN_DIV_CD", label:["법인구분", "#text_filter"], type : "combo", width : "130", sort : "str", align : "center", isHidden : false, commonCode : "ORGN_DIV_CD", isDisabled : true}
				, {id : "ORGN_CD", label:["조직명", "#text_filter"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, commonCode : "ORGN_CD", isDisabled : true}
				, {id : "MEM_NO", label:["회원번호", "#text_filter"], type : "ro", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "MEM_NM", label:["회원명", "#text_filter"], type : "ro", width : "150", sort : "str", align : "center", isHidden : true, isEssential : true}
				, {id : "CORP_NM", label:["상호명", "#text_filter"], type : "ro", width : "150", sort : "str", align : "center", isHidden : true, isEssential : true}
				, {id : "UNION_MEM_CORP", label:["상호명[회원명]", "#text_filter"], type : "ro", width : "100", sort : "str", align : "left", isHidden : false, isEssential : true}
				, {id : "GOODS_NO", label:["상품코드", "#text_filter"], type : "ro", width : "90", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "GOODS_NM", label:["상품명", "#text_filter"], type : "ro", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "BCD_CD", label:["바코드", "#text_filter"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "PUR_PRICE", label:["매입가", "#text_filter"], type : "ron", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
				, {id : "SALE_PRICE", label:["판매가", "#text_filter"], type : "ron", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
				, {id : "PROF_RATE", label:["기준마진율", "#text_filter"], type : "ron", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000.00%"}
				, {id : "PRICE_POLI", label:["도매등급", "#text_filter"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "PRICE_POLI"}
				, {id : "WSALE_PRICE", label:["도매가", "#text_filter"], type : "ron", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
				, {id : "MEM_ABC", label:["ABC", "#text_filter"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "MEM_ABC"}
				, {id : "PRICE_POLI_TYPE", label:["판매방식", "#text_filter"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "SALES_STYLE"}
				, {id : "MEM_PROF_RATE", label:["회원마진율", "#text_filter"], type : "ron", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000.00%"}
				, {id : "MEM_SALE_PRICE", label:["회원지정가", "#text_filter"], type : "ron", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
				, {id : "CDATE", label:["등록일", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "MDATE", label:["수정일", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center", isHidden : false, isEssential : true}
				, {id : "MEM_NO", label:["회원코드", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true, isEssential : true}
		];
		bottom_layout_grid = new dhtmlXGridObject({
			parent: "div_bottom_layout"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : grid_Columns
		});
		$erp.initGrid(bottom_layout_grid,{multiSelect : true});
		
		bottom_layout_grid.attachEvent("onRowDblClicked", function (rowId,columnIdx){
			$erp.openMemberInfoPopup($erp.dataSerializeOfGridRow(bottom_layout_grid, rowId));
		});
		
	}
	
	function openGoodsCategoryTreePopup(){
		var onClick = function(id){
			
			var cateNm = this.getItemText(id);
			$.ajax({
				 url      : "/sis/standardInfo/goods/getGoodsCategory.do"
				,data     : {  "GRUP_CD" : id }
				,method   : "POST"
				,dataType : "JSON"
				,success : function(data){
					total_layout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {			
						var dataMap = data.dataMap;
						if(dataMap == null){
							document.getElementById("txtGRUP_TOP_CD").value = "";
							document.getElementById("txtGRUP_MID_CD").value = "";
							document.getElementById("txtGRUP_BOT_CD").value = "";
							document.getElementById("txtGOODS_CATE_NM").value = "전체분류";
						}else{
							document.getElementById("txtGRUP_TOP_CD").value = dataMap.GRUP_TOP_CD;
							document.getElementById("txtGRUP_MID_CD").value = dataMap.GRUP_MID_CD;
							document.getElementById("txtGRUP_BOT_CD").value = dataMap.GRUP_BOT_CD;
							document.getElementById("txtGOODS_CATE_NM").value = cateNm;
						}
					}
					
					$erp.closePopup2('openGoodsCategoryTreePopup');
				}, error : function(jqXHR, textStatus, errorThrown){
					total_layout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					$erp.closePopup2('openGoodsCategoryTreePopup');
				}
			});
			
		}
		
		$erp.openGoodsCategoryTreePopup(onClick);
	}
	
	function openSearchCustmrGridPopup(){
		var pur_sale_type = "1"; //협력사(매입처) == "1" 고객사(매출처) == "2"
		
		var onRowSelect = function(id, ind) {
			document.getElementById("txtCUSTMR_CD").value = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("txtCUSTMR_NM").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}

</script>
</head>
<body>		

	<div id="div_top_layout" class="samyang_div" style="display:none">
		<div id="div_top_layout_search" class="samyang_div">
			<table id="tb_search" class="table">
				<colgroup>
					<col width="130px"/>
					<col width="130px"/>
					<col width="100px"/>
					<col width="130px"/>
					<col width="100px"/>
					<col width="130px"/>
					<col width="100px"/>
					<col width="130px"/>
					<col width="110px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th colspan="1">법인구분</th>
					<td colspan="2"><div id="cmbORGN_DIV_CD"></div></td>
					<th colspan="1">조직명</th>
					<td colspan="2"><div id="cmbORGN_CD"></div></td>
					<td colspan="4"></td>
				</tr>
				<tr>
					<th colspan="1">분류</th>
					<td colspan="2">
						<input type="hidden" id="txtGRUP_TOP_CD" class="input_text" value=""/>
						<input type="hidden" id="txtGRUP_MID_CD" class="input_text" value=""/>
						<input type="hidden" id="txtGRUP_BOT_CD" class="input_text" value=""/>
						<input type="text" id="txtGOODS_CATE_NM" class="input_text" value="전체분류" style="width:70%; background-color: white;" disabled/>
						<input type="button" id="" class="input_common_button" value="검색" onClick="openGoodsCategoryTreePopup();" style="width:25%"/>
					</td>
					<th colspan="1">협력사</th>
					<td colspan="2">
						<input type="hidden" id="txtCUSTMR_CD" class="input_text" value=""/>
						<input type="text" id="txtCUSTMR_NM" class="input_text" value="" style="width:70%; background-color: white;" disabled/>
						<input type="button" id="" class="input_common_button" value="검색" onClick="openSearchCustmrGridPopup();" style="width:25%"/>
					</td>
					<td colspan="4"></td>
				</tr>
				<tr>
					<th colspan="1">상호명[회원명]/상품명</th>
					<td colspan="2"><input type="text" id="txtSEARCH_WORD" class="input_text" value="" autocomplete="off" onkeyup="if(event.keyCode==13){ribbon.callEvent('onClick', ['search_grid']);}"></td>
					<th colspan="1">바코드</th>
					<td colspan="6"><div id="cmbMEM_ABC"></div></td>
				</tr>
				
				<tr>
					<th colspan="1"><div id="chkGOODS_UNIT_TYPE_chk" style="float: right;"></div></th>
					<td colspan="1"><div id="cmbGOODS_UNIT_TYPE"></div></td>
					<th colspan="1"><div id="chkGOODS_SALES_TYPE_chk" style="float: right;"></div></th>
					<td colspan="1"><div id="cmbGOODS_SALES_TYPE"></div></td>
					<th colspan="1"><div id="chkGOODS_TAX_YN_chk" style="float: right;"></div></th>
					<td colspan="1"><div id="cmbGOODS_TAX_YN"></div></td>
					<td colspan="4"></td>
				</tr>

			</table>
		</div>
	</div>

	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bottom_layout" class="div_grid_full_size" style="display:none"></div>
</body>
</html>