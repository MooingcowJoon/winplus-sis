<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	
	var orgn_cdList="";
	var mem_noList="";
	
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
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, "AllOrOne", false, LUI.LUI_orgn_cd);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), "AllOrOne", false, null);
			}); 
		});
		
		//1
		chkTRANSACTION = $erp.getDhtmlXCheckBox('chkTRANSACTION', '최종거래', '1', false, 'label-left');
		cmbHOUR_FR = $erp.getDhtmlXComboCommonCode("cmbHOUR_FR", "HOUR_FR", "HOUR", 100, "시간", false, "");
		cmbHOUR_TO = $erp.getDhtmlXComboCommonCode("cmbHOUR_TO", "HOUR_TO", "HOUR", 100, "시간", false, "");
		chkTOP_COUNT_chk = $erp.getDhtmlXCheckBox('chkTOP_COUNT_chk', '상위', '1', true, 'label-left');
		
		//2
		chkJOIN = $erp.getDhtmlXCheckBox('chkJOIN', '등록', '1', false, 'label-left');
		cmbMEM_STATE = $erp.getDhtmlXComboCommonCode("cmbMEM_STATE", "MEM_STATE", ["USE_CD", "YN"], 100, "-회원상태-", false, "Y");
		cmbMEM_TYPE = $erp.getDhtmlXComboCommonCode("cmbMEM_TYPE", "MEM_TYPE", "MEM_TYPE", 100, "-회원유형-", false, "");
		cmbPRICE_POLI = $erp.getDhtmlXComboCommonCode("cmbPRICE_POLI", "PRICE_POLI", "PRICE_POLI", 100, "-도매등급-", false, "");
		cmbMEM_ABC = $erp.getDhtmlXComboCommonCode("cmbMEM_ABC", "MEM_ABC", "MEM_ABC", 100, "---ABC---", false, "");
		//id, name, width, 텍스트, 콜백
		cmbGRUP_CD = $erp.getDhtmlXEmptyCombo("cmbGRUP_CD", "GRUP_CD", 100, "---그룹---",function(){
			var url = "/sis/member/getMemberGroupComboList.do";
			var send_data = {};
			var if_success = function(data){
				if($erp.isEmpty(data.comboList)){
					//검색 결과 없음
				}else{
					//필수 기본키 text,value  추가로 커스텀 key:value 등록 가능
					cmbGRUP_CD.setCombo(data.comboList);
				}
			}
			
			var if_error = function(){
			}
			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
		});
		
		//3
		chkGOODS_NO_chk = $erp.getDhtmlXCheckBox('chkGOODS_NO_chk', '단품지정', '1', false, 'label-left');
		chkRESP_USER_chk = $erp.getDhtmlXCheckBox('chkRESP_USER_chk', '담당자', '1', false, 'label-left');
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
			        		             , {id : "add_erpGrid", type : "button", text:'플러스친구톡보내기',								isbig : false, img : "menu/apply.gif",  imgdis : "menu/apply_dis.gif", disable : false}
			        		             ]
				           }
				           ]
		});
		
		ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				var dataObj = $erp.dataSerialize("tb_search", "Q", false);
				var url = "/sis/member/getBestMemberList.do";
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
				   , "fileName" : "회원"
				   , "isForm" : false
				   , "isHiddenPrint" : "Y"
				});
			} else if (itemId == "print_grid"){
				
			} else if (itemId == "add_erpGrid"){
				openPlusFriendTalkPopup();
			}
		});
	}
	
	function init_bottom_layout(){
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		var grid_Columns = [
				{id : "NO", label:["NO"], type : "cntr", width : "30", sort : "int", align : "center", isHidden : false, numberFormat : "0,000"}
				, {id : "CHECK", label:["#master_checkbox"], type: "ch", width: "35", sort : "int", align : "center", isHidden : false, isDataColumn : false} 
				, {id : "UNIQUE_MEM_NO", label:["회원코드", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true}
				, {id : "MEM_NO", label:["회원코드", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : false}
				, {id : "MEM_NM", label:["회원명", "#text_filter"], type : "ro", width : "80", sort : "str", align : "left", isHidden : true}
				, {id : "UNION_CORP_MEM", label:["상호명[회원명]", "#text_filter"], type : "ro", width : "120", sort : "str", align : "left", isHidden : false}
				, {id : "MEM_BCD", label:["회원바코드", "#text_filter"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false}
				, {id : "CORP_NO", label:["사업자번호", "#text_filter"], type : "businessNum", width : "100", sort : "str", align : "center", isHidden : false}
				, {id : "SUM_SALE_AMT", label:["구매액", "#text_filter"], type : "ron", width : "90", sort : "str", align : "center", isHidden : false, numberFormat : "0,000"}
				, {id : "SUM_INSP_QTY", label:["구매량", "#text_filter"], type : "ron", width : "60", sort : "str", align : "center", isHidden : false, numberFormat : "0,000"}
				, {id : "SUM_PUR_AMT", label:["예정원가", "#text_filter"], type : "ron", width : "60", sort : "str", align : "center", isHidden : false, numberFormat : "0,000"}
				, {id : "COUNT_ORD_CD", label:["거래횟수", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, numberFormat : "0,000"}
				, {id : "POINT", label:["포인트", "#text_filter"], type : "ron", width : "60", sort : "str", align : "right", isHidden : false, numberFormat : "0,000"}
				, {id : "POINT_SUM", label:["누적포인트", "#text_filter"], type : "ron", width : "60", sort : "str", align : "right", isHidden : false, numberFormat : "0,000"}
				, {id : "MIN_ORD_DATE", label:["최초주문일", "#text_filter"], type : "dhxCalendarA", width : "80", sort : "str", align : "center", isHidden : false}
				, {id : "MAX_ORD_DATE", label:["최종구매일", "#text_filter"], type : "dhxCalendarA", width : "80", sort : "str", align : "center", isHidden : false}
				, {id : "CDATE", label:["가입일", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center", isHidden : false}
				, {id : "ORGN_DIV_CD", label:["법인구분", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true}
				, {id : "ORGN_CD", label:["조직명", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true}
				, {id : "CORP_NM", label:["상호명", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true}
				, {id : "MEM_ABC", label:["회원분류", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true}
				, {id : "PHON_NO", label:["전화번호", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true}
				, {id : "ORGN_NM", label:["직영점", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : true}
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
		
		$cm.sisUserGridRightClick(bottom_layout_grid);
	}
	
	function openSearchPostAddrPopup(){
		var onComplete = function(data){
			
			var addressMap = $erp.getAddressMap(data);
			
			document.getElementById("txtZIP_NO").value = addressMap.selectZipNo;
			
			$erp.closePopup2('ERP_POST_WIN_ID');
		}
		$erp.openSearchPostAddrPopup2(onComplete, {win_id : "ERP_POST_WIN_ID"});
	}
	
	<%-- openPlusFriendTalkPopup 플러스 친구톡 보내기 팝업 열림 Function --%>
	function openPlusFriendTalkPopup(){
		var check = bottom_layout_grid.getCheckedRows(bottom_layout_grid.getColIndexById("CHECK"));
		if(check != ""){	
			$erp.openPlusFriendTalkPopup(bottom_layout_grid);
		} else{
			$erp.alertMessage({
				"alertMessage" : "플러스친구톡을 보낼 회원을 체크해주세요.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
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
					<th colspan="1"><div id="chkTRANSACTION" style="float:right; margin-left: 5px"></div></th>
					<td colspan="2">
						<input type="text" id="txtDATE_FR_TRANSACTION" class="input_calendar" style="float:left;">
						<span style="float:left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO_TRANSACTION" class="input_calendar" style="float:left; margin-left: 6px;">
					</td>
					<td colspan="2">
						<div id="cmbHOUR_FR" style="float:left;"></div>
						<span style="float:left; margin-left: 1px;">~</span>
						<div id="cmbHOUR_TO" style="float:left; margin-left: 1px;"></div>
						<div id="cmbORDER_BY" style="float:left; margin-left: 5px;"></div>
					</td>
					<th colspan="1">거래횟수</th>
					<td colspan="1"><input type="text" id="txtTRADE_COUNT" class="input_text" value=""/></td>
					<td colspan="3"></td>
				</tr>
				
				<tr>
					<th colspan="1"><div id="chkJOIN" style="float:right; margin-left: 5px"></div></th>
					<td colspan="2">
						<input type="text" id="txtDATE_FR_JOIN" class="input_calendar" style="float:left;">
						<span style="float:left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO_JOIN" class="input_calendar" style="float:left; margin-left: 6px;">
					</td>
					<td colspan="1"><div id="cmbMEM_STATE"></div></td>
					<td colspan="1"><div id="cmbMEM_TYPE"></div></td>
					<td colspan="1"><div id="cmbPRICE_POLI"></div></td>
					<td colspan="1"><div id="cmbMEM_ABC"></div></td>
					<td colspan="3"><div id="cmbGRUP_CD"></div></td>
				</tr>
				
				<tr>
					<th colspan="1"><div id="chkGOODS_NO_chk" style="float:right; margin-left: 5px"></div></th>
					<td colspan="1"><input type="text" id="txtGOODS_NO" class="input_text" value=""/></td>
					<th colspan="1"><div id="chkRESP_USER_chk" style="float:right; margin-left: 5px"></div></th>
					<td colspan="1"><input type="text" id="txtRESP_USER" class="input_text" value=""/></td>
					<th colspan="1"><input type="button" id="" class="input_common_button" value="우편" onClick="openSearchPostAddrPopup();" style="width: 50px;"/></th>
					<td colspan="1"><input type="text" id="txtZIP_NO" class="input_text" value=""/></td>
					<th colspan="1"><div id="chkTOP_COUNT_chk" style="float:right;"></div></th>
					<td colspan="1"><input type="text" id="txtTOP_COUNT" class="input_text" value="100"/></td>
					<td colspan="2"></td>
				</tr>
				
			</table>
		</div>
	</div>

	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bottom_layout" class="div_grid_full_size" style="display:none"></div>
</body>
</html>