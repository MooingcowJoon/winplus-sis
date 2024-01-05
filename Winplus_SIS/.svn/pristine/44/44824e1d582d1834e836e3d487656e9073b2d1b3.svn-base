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
	
	<%--
	※ 전역 변수 선언부 
	□ 변수명 : Type / Description
	■ thisPopupWindow : 현재 팝업 윈도우
	■ total_layout : 전체 페이지 레이아웃 
	
	--%>
	//LUI : 로그인한 유저의 세션 정보에서 그리드 데이터 직렬화시 공통으로 추가 시키고 싶은 데이터를 넣는 객체
	LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2,3,4";
	var AUTHOR_CD = "${screenDto.author_cd}";
	var ORGN_CD = '${param.ORGN_CD}';
	var thisPopupWindow = parent.erpPopupWindows.window('openMemberSearchPopup');
	
	var total_layout;
	
	$(document).ready(function(){
		if(thisPopupWindow){
			thisPopupWindow.setText("${screenDto.scrin_nm}");	
			//thisPopupWindow.denyResize();
			//thisPopupWindow.denyMove();
		}
		
		init_total_layout();
		total_layout.progressOn();
		init_top_layout();
		init_mid_layout();
		init_bottom_layout();
		
		var MEM_NM = document.getElementById("txtMEM_NM").value;
		
		//모든 레이아웃 초기화 함수 호출후 등록해주세요.
		$erp.asyncObjAllOnCreated(function(){
			if(ORGN_CD == undefined || ORGN_CD == null || ORGN_CD == ""){
				cmbORGN_DIV_CD.disable();
			} else {
				cmbORGN_DIV_CD.disable();
				cmbORGN_CD.disable();
			}
			if(MEM_NM){
				ismemberSearch();
			}else{
				total_layout.progressOff();
			}
		});
	});
	
	function init_total_layout(){
		total_layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
				, cells: [
				          {id: "a", text: "${menuDto.menu_nm}", header:true, height:70}
				          , {id: "b", text: "", header:false, fix_size : [true, true]}
				          , {id: "c", text: "", header:false}
				          ]
		});
		
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight($erp.getTableHeight(3));
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(36);
		total_layout.cells("c").attachObject("div_bottom_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
	}
	
	function init_top_layout(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, '${param.ORGN_DIV_CD}', function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, '${param.ORGN_CD}');
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			}); 
		});
		
		chkMEM_STATE_N_INCLUDE = $erp.getDhtmlXCheckBox('chkMEM_STATE_N_INCLUDE', '무효포함', '1', false, 'label-right');
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
// 			        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
// 			        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
			        		             ]
				           }							
				           ]
		});
		
		ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				ismemberSearch();
			}
// 			else if (itemId == "add_grid"){
// 			} else if (itemId == "delete_grid"){
// 			} else if (itemId == "save_grid"){
// 			} else if (itemId == "excel_grid"){
// 			} else if (itemId == "print_grid"){
// 			}
		});
	}
	
		
	function init_bottom_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
		                    {id : "NO", label:["NO"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, isEssential : false,numberFormat : "0,000"}
		                    , {id : "ORGN_DIV_CD", label:["법인구분", "#text_filter"], type: "combo", width: "130", sort : "str", align : "center", isDisabled : true, isHidden : false, commonCode : "ORGN_DIV_CD"}
		        			, {id : "ORGN_CD", label:["조직명", "#text_filter"], type: "combo", width: "70", sort : "str", align : "center", isDisabled : true, isHidden : false, commonCode : "ORGN_CD"}
		                    , {id : "UNIQUE_MEM_NM", label:["상호명[회원명]", "#text_filter"], type : "ro", width : "150", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "MEM_NM", label:["회원명", "#text_filter"], type : "ro", width : "80", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "MEM_NO", label:["회원코드", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true}
 		                    , {id : "MEM_BCD", label:["회원바코드", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "PHON_NO", label:["휴대폰", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "TEL_NO01", label:["전화번호1", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "TEL_NO02", label:["전화번호2", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
		                    , {id : "LAST_TRADE_DATE", label:["최근거래일", "#text_filter"], type : "ro", width : "130", sort : "str", align : "center", isHidden : false, isEssential : false}
		                    , {id : "MEM_TYPE_CD", label:["회원유형", "#text_filter"], type : "combo", width : "90", sort : "str", align : "center", isHidden : true, isEssential : true, commonCode : "MEM_TYPE"}
		                    , {id : "ABC_CD", label:["ABC", "#text_filter"], type : "combo", width : "60", sort : "str", align : "center", isHidden : true, isEssential : true, commonCode : "MEM_ABC_CD"}
		                    , {id : "PRICE_POLI", label:["도매등급", "#text_filter"], type : "combo", width : "60", sort : "str", align : "center", isHidden : true, isEssential : true, commonCode : "PRICE_POLI"}
		                    , {id : "CORP_NO", label:["사업자번호", "#text_filter"], type : "businessNum", width : "100", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "CORP_ZIP_NO", label:["우편번호", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "CORP_S_ADDR", label:["상세주소", "#text_filter"], type : "ro", width : "300", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "POINT", label:["포인트", "#text_filter"], type : "ron", width : "60", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "POINT_SUM", label:["누적포인트", "#text_filter"], type : "ron", width : "60", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "CDATE", label:["등록일", "#text_filter"], type : "dhxCalendarA", width : "80", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "MDATE", label:["수정일", "#text_filter"], type : "dhxCalendarA", width : "80", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "BF_M2DATE", label:["모바일신호", "#text_filter"], type : "dhxCalendarA", width : "80", sort : "str", align : "center", isHidden : true, isEssential : true, numberFormat : "0,000"}
		                    , {id : "DELI_MEMO", label:["배송메모", "#text_filter"], type : "ed", width : "300", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    , {id : "ETC_MEMO", label:["기타메모", "#text_filter"], type : "ed", width : "300", sort : "str", align : "center", isHidden : true, isEssential : true}
		                    ];
		
		bottom_layout_grid = new dhtmlXGridObject({
			parent: "div_bottom_layout"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns
		});
		
		var btnConfirm = document.getElementById("btnConfirm");
		var useMultiSelect = "${param.useMultiSelect}";
		
		if(useMultiSelect == "true"){
			$erp.initGrid(bottom_layout_grid,{multiSelect : true});
			
			bottom_layout_grid.attachEvent("onRowSelect",function(rowId,columnIdx){
				var selectedRowList = bottom_layout_grid.getSelectedRowId().split(",");
				if(selectedRowList.length > 1){
					btnConfirm.disabled = false;
				}else{
					btnConfirm.disabled = true;
				}
			});
			
			btnConfirm.style.display="block";

		}else{
			$erp.initGrid(bottom_layout_grid);
			btnConfirm.style.display="none";
		}
		
		bottom_layout_grid.attachEvent("onRowDblClicked", function (rowId,columnIdx){
			total_layout.progressOn();
			thisOnRowDblClick($erp.dataSerializeOfGridRow(bottom_layout_grid, rowId));
			total_layout.progressOff();
			thisOnComplete();
		});
		
		$cm.sisUserGridRightClick(bottom_layout_grid);
	}
	
	function confirm(){
		total_layout.progressOn();
		thisOnConfirm($erp.dataSerializeOfGridByMode(bottom_layout_grid, 'selected'));
		total_layout.progressOff();
		thisOnComplete();
	}
	function ismemberSearch(){
		var ORGN_CD = cmbORGN_CD.getSelectedValue();
		var MEM_NM = $("#txtMEM_NM").val();
		if(MEM_NM.length == 0 && ORGN_CD == ""){
			$erp.confirmMessage({
				"alertMessage" : "검색 속도가 느릴 수 있습니다. </br> 진행하시겠습니까?"
				,"alertType" : "info"
				,"isAjax" : false
				,"alertCallbackFn" : function(){memberSearch(); }
			});
		} else {
			memberSearch();
		}
	}
	function memberSearch(){
		var url = "/sis/member/memberSearch.do";
		var send_data = $erp.dataSerialize("tb_search");
		
		var if_success = function(data){
			$erp.clearDhtmlXGrid(bottom_layout_grid); //기존데이터 삭제
			if($erp.isEmpty(data.gridDataList)){
				//검색 결과 없음
				$erp.addDhtmlXGridNoDataPrintRow(bottom_layout_grid, '<spring:message code="info.common.noDataSearch" />');
			}else{
				bottom_layout_grid.parse(data.gridDataList,'js');
			}
			$erp.setDhtmlXGridFooterRowCount(bottom_layout_grid); // 현재 행수 계산
		}
		
		var if_error = function(){
			
		}
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
		
	}
	
	function presskey() {
		if (window.event.keyCode == 13) {
			memberSearch();
		}
	}
	
</script>
</head>
<body>
	
	<div id="div_top_layout" class="samyang_div" style="display:none">
		<div id="div_top_layout_search" class="samyang_div">
			<table id="tb_search" class="table">
				<colgroup>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
					<col width="110px"/>
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
					<th colspan="1">상호명[회원명]</th>
					<td colspan="1">
						<input type="text" id="txtMEM_NM" style="width:95%" class="input_common" value="${param.MEM_NM}" onkeyup="presskey();"/>
					</td>
					<td colspan="1"><div id="chkMEM_STATE_N_INCLUDE"></div></td>
					<td colspan="7">
						<input type="button" id="btnConfirm" class="input_common_button" value="다중선택완료" onClick="confirm()" style="display: none;" disabled/>
					</td>
				</tr>
			</table>
		</div>
	</div>

	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bottom_layout" class="div_grid_full_size" style="display:none"></div>
	
</body>
</html>