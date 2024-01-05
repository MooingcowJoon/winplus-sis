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
	var LUI = JSON.parse('${empSessionDto.lui}');
	LUI.exclude_auth_cd = "ALL,1,2,3,4";
	var total_layout;
	
	var top_layout;
	
	var mid_layout;
	var mid_layout_ribbon;
	
	var bottom_layout;
	var bottom_layout_grid;
	
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
		total_layout.cells("a").setHeight($erp.getTableHeight(3));
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(36);
		total_layout.cells("c").attachObject("div_bottom_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
		
	}
	
	function init_top_layout(){
		//1
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			}); 
		});
		
		chkMONTH = $erp.getDhtmlXCheckBox('chkMONTH', '월단위', '1', false, 'label-left');
		chkMONTH.attachEvent("onChange",function(name, value, checked){
			if(checked){
				$erp.objReadonly(["txtDATE_FR","txtDATE_TO"]);
				$erp.objNotReadonly(["txtMONTH_FR","txtMONTH_TO"]);
				chkDATE.uncheckItem("chkDATE");
			}else{
				$erp.objReadonly(["txtMONTH_FR","txtMONTH_TO"]);
				$erp.objNotReadonly(["txtDATE_FR","txtDATE_TO"]);
				chkDATE.checkItem("chkDATE");
			}
		});
		chkDATE = $erp.getDhtmlXCheckBox('chkDATE', '일단위', '1', false, 'label-left');
		chkDATE.attachEvent("onChange",function(name, value, checked){
			if(checked){
				$erp.objReadonly(["txtMONTH_FR","txtMONTH_TO"]);
				$erp.objNotReadonly(["txtDATE_FR","txtDATE_TO"]);
				chkMONTH.uncheckItem("chkMONTH");
			}else{
				$erp.objReadonly(["txtDATE_FR","txtDATE_TO"]);
				$erp.objNotReadonly(["txtMONTH_FR","txtMONTH_TO"]);
				chkMONTH.checkItem("chkMONTH");
			}
		});
		
		//강제클릭이벤트 발생시켜 체크하기
		chkMONTH.items.checkbox.doClick(chkMONTH._getItemByName("chkMONTH"));
		
		
		chkSALE_TYPE_chk = $erp.getDhtmlXCheckBox('chkSALE_TYPE_chk', '거래구분', '1', false, 'label-left');
		cmbSALE_TYPE = $erp.getDhtmlXComboCommonCode("cmbSALE_TYPE", "SALE_TYPE", "WHOLESALE_OR_RETAIL", 100, null, false, "");
		
		//2
		chkREG_TYPE_chk = $erp.getDhtmlXCheckBox('chkREG_TYPE_chk', '출/반', '1', false, 'label-left');
		cmbREG_TYPE = $erp.getDhtmlXComboCommonCode("cmbREG_TYPE", "REG_TYPE", "SALES_OR_RETURNS", 100, null, false, "");

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
			        		             , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
			        		             , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
			        		             ]
				           }
				           ]
		});
		
		ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				var dataObj = $erp.dataSerialize("tb_search");
				if(!dataObj.MEM_NO){
					$erp.alertMessage({
						"alertMessage" : "회원을 검색하여 선택하여 주세요.",
						"alertCode" : "미확인 회원번호",
						"alertType" : "error",
						"isAjax" : false,
					});
					return;
				}
				var url = "/sis/member/getMemberTransactionLedgerList.do";
				var send_data = dataObj;
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
				
			} else if (itemId == "excel_grid"){
				$erp.exportDhtmlXGridExcel({
				     "grid" : bottom_layout_grid
				   , "fileName" : "거래원장"
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
		                    , {id : "MEM_NO", label:["회원코드", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "ORD_DATE", label:["거래일", "#text_filter"], type : "dhxCalendarA", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "SALE_TYPE", label:["거래구분", "#text_filter"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "WHOLESALE_OR_RETAIL"}
		                    , {id : "REG_TYPE", label:["출/반", "#text_filter"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : "SALES_OR_RETURNS"}
		                    , {id : "SALE_TOT_AMT", label:["매출", "#text_filter"], type : "ron", width : "90", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "SUM_INSP_QTY", label:["반품", "#text_filter"], type : "ron", width : "90", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "SUM_PUR_AMT", label:["계산서", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    , {id : "RESN_CD", label:["사유", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
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
		
		$cm.sisTransactionLedgerGridRightClick(bottom_layout_grid);
	}
	
	function openMemeberSearchPopup(){
		var params = {
			"MEM_NM" : document.getElementById("txtMEM_NM").value,
			"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue(),
			"ORGN_CD" : cmbORGN_CD.getSelectedValue(),
			"useMultiSelect" : false //다중선택 사용안함
		}
		
		var onRowDblClick = function(selectedData){
			var txtORGN_DIV_CD = document.getElementById("txtORGN_DIV_CD");
			txtORGN_DIV_CD.value = selectedData.ORGN_DIV_CD;
			var txtORGN_CD = document.getElementById("txtORGN_CD");
			txtORGN_CD.value = selectedData.ORGN_CD;
			var txtMEM_NO = document.getElementById("txtMEM_NO");
			txtMEM_NO.value = selectedData.MEM_NO;
			var txtMEM_NM = document.getElementById("txtMEM_NM");
			txtMEM_NM.value = selectedData.MEM_NM;
// 			console.log("회원번호 : " + txtMEM_NO.value);
// 			console.log("회원이름 : " + txtMEM_NM.value);
		}
		
		var onConfirm = function(selectedDataList){
			//다중선택 사용 안 할 것이므로 로직 없음
		}
		
		$erp.openMemberSearchPopup(params, onRowDblClick, onConfirm);
	}
	
	function enterkey() {
		if (window.event.keyCode == 13) {
			openMemeberSearchPopup();
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
				
				<tr id="ORGN">
					<th colspan="1">법인구분</th>
					<td colspan="2"><div id="cmbORGN_DIV_CD"></div></td>
					<th colspan="1">조직명</th>
					<td colspan="2"><div id="cmbORGN_CD"></div></td>
					<td colspan="4"></td>
				</tr>
				
				<tr>
					<th colspan="1"><div id="chkMONTH" style="float:right;"></div></th>
					<td colspan="2">
						<input type="text" id="txtMONTH_FR" class="input_calendar_ym default_date" data-position="-1" value="" style="float:left;">
						<span style="float:left; margin-left: 4px;">~</span>
						<input type="text" id="txtMONTH_TO" class="input_calendar_ym default_date" data-position="" value="" style="float:left; margin-left: 6px;">
					</td>
					<th colspan="1"><div id="chkDATE" style="float:right;"></div></th>
					<td colspan="2">
						<input type="text" id="txtDATE_FR" class="input_calendar default_date" data-position="-7" value="" style="float:left;">
						<span style="float:left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO" class="input_calendar default_date" data-position="" value="" style="float:left; margin-left: 6px;">
					</td>
					<th colspan="1"><div id="chkSALE_TYPE_chk" style="float:right;"></div></th>
					<td colspan="3"><div id="cmbSALE_TYPE"></div></td>
				</tr>
				
				<tr>
					<th colspan="1" style="padding-right: 8px;">회원지정</th>
					<td colspan="2">
						<input type="text" id="txtMEM_NO" class="input_text input_readonly" value="" style="width:50px;" readonly/>
						<input type="text" id="txtMEM_NM" class="input_text" value="" style="width:120px;" onkeyup="enterkey();"/>
						<input type="hidden" id="txtORGN_DIV_CD"/>
						<input type="hidden" id="txtORGN_CD"/>
						<input type="button" id="" class="input_common_button" value="검색" onClick="openMemeberSearchPopup();"/>
					</td>
					<th colspan="1"><div id="chkREG_TYPE_chk" style="float:right;"></div></th>
					<td colspan="6"><div id="cmbREG_TYPE"></div></td>
				</tr>
				
			</table>
		</div>
	</div>

	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bottom_layout" class="div_grid_full_size" style="display:none"></div>
</body>
</html>