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
	LUI.exclude_auth_cd = "All,1,2,3";
	
	var total_layout;
	
	var top_layout;
	
	var mid_layout_ribbon;
	
	var bottom_layout_grid;
	
	var CRUD = "";
	
	$(document).ready(function(){
		init_total_layout();
		init_top_layout();
		init_mid_layout();
		init_bottom_layout();
		
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
		total_layout.cells("a").setHeight($erp.getTableHeight(5));
		total_layout.cells("b").attachObject("div_mid_ribbon");
		total_layout.cells("b").setHeight(36);
		total_layout.cells("c").attachObject("div_bottom_grid");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
	}
	
	function init_top_layout(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 210, null, false, LUI.LUI_orgn_div_cd, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 210, null, false, LUI.LUI_orgn_cd, function(){
				cmbPOS_NO = $erp.getDhtmlXComboTableCode("cmbPOS_NO", "POS_NO", "/sis/code/getPosNoList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}, {ORGN_CD : cmbORGN_CD.getSelectedValue()}]), 100, "AllOrOne", false, "");
				//카드매입사
				cmbCARD_ACQUIRER_CORP_CD = $erp.getDhtmlXComboTableCode("cmbCARD_ACQUIRER_CORP_CD", "CARD_ACQUIRER_CORP_CD", "/sis/code/getCardAcquirerCorpList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}, {ORGN_CD : cmbORGN_CD.getSelectedValue()}]), 210, "AllOrOne", false, "");
				isJump = false;
			});
			
			var isJump = true;
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				isJump = true;
				cmbORGN_CD.unSelectOption();
				isJump = false;
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), null, false, null);
			});
			cmbORGN_CD.attachEvent("onChange", function(value, text){
				if(!isJump){
					cmbPOS_NO.unSelectOption();
					cmbPOS_NO.clearAll();
					$erp.setDhtmlXComboTableCodeUseAjax(cmbPOS_NO, "/sis/code/getPosNoList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}, {ORGN_CD : value}]), "AllOrOne", false, null);
					
					cmbCARD_ACQUIRER_CORP_CD.unSelectOption();
					cmbCARD_ACQUIRER_CORP_CD.clearAll();
					$erp.setDhtmlXComboTableCodeUseAjax(cmbCARD_ACQUIRER_CORP_CD, "/sis/code/getCardAcquirerCorpList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}, {ORGN_CD : value}]), "AllOrOne", false);
				}
			});
		});

		cmbSTD_DATE_TYPE = $erp.getDhtmlXComboCommonCode("cmbSTD_DATE_TYPE", "STD_DATE_TYPE", "STD_DATE_TYPE", 100, null, false, null);
		
		cmbVAN_CD = $erp.getDhtmlXComboCommonCode("cmbVAN_CD", "VAN_CD", "VAN_CD", 100, "전체", true, null);
		cmbPAY_APP_TYPE = $erp.getDhtmlXComboCommonCode("cmbPAY_APP_TYPE", "PAY_APP_TYPE", "PAY_APP_TYPE", 100, null, false, null,null,"Y");
		
		//chkEASY_CHECKER_YN = $erp.getDhtmlXCheckBox('chkEASY_CHECKER_YN', '체크기사용', '1', false, 'label-right');
	}
	
	function init_mid_layout(){
		mid_layout_ribbon = new dhtmlXRibbon({
			parent : "div_mid_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
							{
								type : "block"
								, mode : 'rows'
								, list : [
										{id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 										, {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
// 										, {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
// 										, {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
										, {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
										, {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
										]
							}
							]
		});
		
		mid_layout_ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				var isValidated = true;
				var alertMessage = "";
				var alertCode = "";
				var alertType = "error";
				var POS_NO = cmbPOS_NO.getSelectedValue();
				var CARD_ACQUIRER_CORP_CD = cmbCARD_ACQUIRER_CORP_CD.getSelectedValue();
				
				if(cmbPOS_NO.getSelectedValue() == null) {
					isValidated = false;
					alertMessage = "pos 단말기 정보를 불러올 수 없습니다.";
				}
				
				if(cmbCARD_ACQUIRER_CORP_CD.getSelectedValue() == null){
					isValidated = false;
					alertMessage = "카드매입사 정보를 불러올 수 없습니다.";
				}
				if(!isValidated){
					$erp.alertMessage({
						"alertMessage" : alertMessage,
						"alertType" : alertType,
						"isAjax" : false
					});
				} else {
					var dataObj = $erp.dataSerialize("tb_search");
					var url = "/sis/market/getPaymentApprovalHistory.do";
					var send_data = $erp.unionObjArray([LUI,dataObj]);
					console.log(send_data);
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
					
					var if_error = function(XHR, status, error){
						
					}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
				}
			} else if (itemId == "add_grid"){
				
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				$erp.exportDhtmlXGridExcel({
					"grid" : bottom_layout_grid
					, "fileName" : "결제승인"
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
							, {id : "ORGN_CD", label:["조직명", "#text_filter"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["ORGN_CD"], isDisabled : true}
							, {id : "APPR_DATE", label:["승인거래일", "#text_filter"], type : "ro", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "APPR_POS_NO", label:["포스번호", "#text_filter"], type : "ro", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "ORD_CD", label:["거래코드", "#text_filter"], type : "ro", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "RESP_USER", label:["담당자", "#text_filter"], type : "ro", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "PAY_APP_TYPE", label:["결제승인유형", "#text_filter"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["PAY_APP_TYPE"], isDisabled : true}
							, {id : "PII_MM", label:["할부", "#text_filter"], type : "ro", width : "80", sort : "str", align : "right", isHidden : false, isEssential : true}
							, {id : "APPR_AMT", label:["승인금액", "#text_filter"], type : "ron", width : "80", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "APPR_NO", label:["승인번호", "#text_filter"], type : "ro", width : "80", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "CARD_ISSUR_CORP_CD", label:["카드발급사코드", "#text_filter"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "CARD_ISSUR_CORP_CD", label:["카드발급사", "#text_filter"], type : "combo", width : "120", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : ["CARD_CD"], isDisabled : true}
//							, {id : "CARD_ISSUR_CORP_NM", label:["카드발급사", "#text_filter"], type : "ro", width : "160", sort : "str", align : "center", isHidden : false, isEssential : false}
							, {id : "CARD_ACQUR_CORP_CD", label:["카드매입사코드", "#text_filter"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "CARD_ACQUR_CORP_NM", label:["카드매입사", "#text_filter"], type : "ro", width : "160", sort : "str", align : "center", isHidden : false, isEssential : false}
							, {id : "APPR_VAN_CD", label:["VAN사코드", "#text_filter"], type : "ro", width : "70", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "APPR_VAN_NM", label:["VAN사", "#text_filter"], type : "ro", width : "70", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "ORD_DATE", label:["판매거래일", "#text_filter"], type : "ro", width : "140", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "CLSE_DATE", label:["판매마감일", "#text_filter"], type : "ro", width : "140", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "CDATE", label:["등록일", "#text_filter"], type : "ro", width : "140", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "MDATE", label:["수정일", "#text_filter"], type : "ro", width : "140", sort : "str", align : "center", isHidden : false, isEssential : true}
							];
		
		bottom_layout_grid = new dhtmlXGridObject({
			parent: "div_bottom_grid"
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH
				, columns : grid_Columns
		});
		$erp.initGrid(bottom_layout_grid,{multiSelect : true});
		
		bottom_layout_grid.attachEvent("onRowDblClicked", function (rowId,columnIdx){
			//!@#!@# 상세내역 팝업 필요함
		});
		
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
					<th colspan="1">기준일유형</th>
					<td colspan="1"><div id="cmbSTD_DATE_TYPE"></div></td>
					<th colspan="1">기간</th>
					<td colspan="2">
						<input type="text" id="txtDATE_FR" class="input_calendar default_date" data-position="(1)" value="">
						<span style="float: left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO" class="input_calendar default_date" data-position="" value="" style="float: left; margin-left: 6px;">
					</td>
					<td colspan="5"></td>
				</tr>
				<tr>
					<th colspan="1">포스번호</th>
					<td colspan="1"><div id="cmbPOS_NO"></div></td>
					<th colspan="1">담당자</th>
					<td colspan="2"><input type="text" id="txtCASHIER" class="input_text" value=""/></td>
					<th colspan="1">VAN사</th>
					<td colspan="4"><div id="cmbVAN_CD"></div></td>
				</tr>
				<tr>
					<th colspan="1">결제승인유형</th>
					<td colspan="1"><div id="cmbPAY_APP_TYPE"></div></td>
<!-- 				<td colspan="1"><div id="chkEASY_CHECKER_YN"></div></td> -->
					<th colspan="1">카드매입사</th>
					<td colspan="7"><div id="cmbCARD_ACQUIRER_CORP_CD"></div></td>
				</tr>
				<tr>
					<th colspan="1">금액구간</th>
					<td colspan="9">
						<input type="text" id="txtAMT_FROM" class="input_money" value="" style="float: left; margin-right: 4px;">
						<span style="float: left; margin-right: 4px;">~</span>
						<input type="text" id="txtAMT_TO" class="input_money" value="" style="float: left; margin-right: 6px;">
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="div_mid_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bottom_grid" class="div_grid_full_size" style="display:none"></div>
</body>
</html>