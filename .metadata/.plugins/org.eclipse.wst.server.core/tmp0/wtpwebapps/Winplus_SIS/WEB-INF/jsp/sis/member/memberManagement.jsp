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
		total_layout.cells("a").setHeight($erp.getTableHeight(7));
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
		
		chkTOP_COUNT_chk = $erp.getDhtmlXCheckBox('chkTOP_COUNT_chk', '상위', '1', false, 'label-right');
		chkRESP_USER_chk = $erp.getDhtmlXCheckBox('chkRESP_USER_chk', '담당자', '1', false, 'label-right');

		//id, name, width, 텍스트, 콜백
		cmbGRUP_CD = $erp.getDhtmlXEmptyCombo("cmbGRUP_CD", "GRUP_CD", 120, "---그룹---",function(){
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
			
			var if_error = function(){}
			$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
		});
		
		//2
		cmbMEM_STATE = $erp.getDhtmlXComboCommonCode("cmbMEM_STATE", "MEM_STATE",  ["USE_CD","YN"], 120, "---전체---", false);
		cmbMEM_TYPE = $erp.getDhtmlXComboCommonCode("cmbMEM_TYPE", "MEM_TYPE", "MEM_TYPE", 120, "---전체---", false, "");
		cmbPRICE_POLI = $erp.getDhtmlXComboCommonCode("cmbPRICE_POLI", "PRICE_POLI", "PRICE_POLI", 120, "---선택---", false, "");
		cmbMEM_ABC = $erp.getDhtmlXComboCommonCode("cmbMEM_ABC", "MEM_ABC", "MEM_ABC", 120, "---ABC---", false, "");
		cmbSMS_YN = $erp.getDhtmlXComboCommonCode("cmbSMS_YN", "SMS_YN", ["YN_CD","YN"], 120, "---전체---", false, "");
		
		cmbCASH_RECP_YN = $erp.getDhtmlXComboCommonCode("cmbCASH_RECP_YN", "CASH_RECP_YN", ["USE_CD","YN"], 80, "-사용여부-", false, "");
		cmbCHG_AMT_TYPE = $erp.getDhtmlXComboCommonCode("cmbCHG_AMT_TYPE", "CHG_AMT_TYPE", "CHG_AMT_TYPE", 120, null, false, "");
	
		cmbCASH_RECP_TYPE = $erp.getDhtmlXComboCommonCode("cmbCASH_RECP_TYPE", "CASH_RECP_TYPE", "CASH_RECP_TYPE", 120, "-현금영수증구분-", false, "");
		
		//사업자 : 1, 개인 : 0
		cmbLAST_CASH_RECP_TYPE = $erp.getDhtmlXComboCommonCode("cmbLAST_CASH_RECP_TYPE", "LAST_CASH_RECP_TYPE", "LAST_CASH_RECP_TYPE", 70, "-구분-", false, "");
		
		//3
		chkJOIN = $erp.getDhtmlXCheckBox('chkJOIN', '등록', '1', false, 'label-right');
		chkTRANSACTION = $erp.getDhtmlXCheckBox('chkTRANSACTION', '최종거래', '1', false, 'label-right');
		
	}
	
	function init_mid_layout(){
		ribbon = new dhtmlXRibbon({
			parent : "div_mid_layout"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{type : "block"
					, mode : 'rows'
					, list : [
						{id : "search_grid", 	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
						, {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
						//, {id : "delete_grid", type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						//, {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
						, {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true}
						, {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}
						]
					}
				]
		});
		
		ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				var dataObj = $erp.dataSerialize("tb_search");
// 				console.log(dataObj);
				var url = "/sis/member/getMemberList.do";
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
			} else if (itemId == "add_grid"){
				var selectORGN_INFO = $erp.dataSerialize("selectORGN_INFO");
				if(selectORGN_INFO.ORGN_CD == ""){
					$erp.alertMessage({
						"alertMessage" : "신규 회원 등록을 위한<br/>법인구분, 조직명를 선택해주세요.",
						"alertType" : "alert",
						"isAjax" : false
					});
				}else{
					$erp.openMemberInfoPopup(selectORGN_INFO);
				}
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				//gridObj, mode(all, checked, selected, state, stateExcludeValue), [columns...]
				
			} else if (itemId == "excel_grid"){
				$erp.alertMessage({
					"alertMessage" : "준비 중 입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			} else if (itemId == "print_grid"){
				$erp.alertMessage({
					"alertMessage" : "준비 중 입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			}
		});
	}
	
		
	function init_bottom_layout(){
		var grid_Columns = [
			{id : "NO", label:["NO"], type : "cntr", width : "35", sort : "int", align : "center", isHidden : false, isEssential : false,numberFormat : "0,000"}
			, {id : "ORGN_DIV_CD", label:["법인구분", "#text_filter"], type : "combo", width : "150", sort : "str", align : "center", isHidden : true, isEssential : true, commonCode : "ORGN_DIV_CD"}
			, {id : "ORGN_CD", label:["조직명", "#text_filter"], type : "combo", width : "80", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : "ORGN_CD"}
			, {id : "MEM_NM", label:["회원명", "#text_filter"], type : "ro", width : "180", sort : "str", align : "left", isHidden : true, isEssential : true}
			, {id : "UNIQUE_MEM_NM", label:["상호명[회원명]", "#text_filter"], type : "ro", width : "180", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "MEM_NO", label:["회원코드", "#text_filter"], type : "ro", width : "60", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "MEM_TYPE", label:["회원유형", "#text_filter"], type : "combo", width : "90", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : "MEM_TYPE"}
			, {id : "MEM_ABC", label:["ABC", "#text_filter"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : "MEM_ABC"}
			, {id : "PRICE_POLI", label:["도매등급", "#text_filter"], type : "combo", width : "60", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : "PRICE_POLI"}
			, {id : "MEM_BCD", label:["회원바코드", "#text_filter"], type : "ro", width : "120", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "CORP_NO", label:["사업자번호", "#text_filter"], type : "businessNum", width : "100", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "TEL_NO01", label:["전화번호1", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "TEL_NO02", label:["전화번호2", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "PHON_NO", label:["휴대폰", "#text_filter"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "CORP_ZIP_NO", label:["우편번호", "#text_filter"], type : "ro", width : "60", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "CORP_ADDR_DETL", label:["상세주소", "#text_filter"], type : "ro", width : "300", sort : "str", align : "left", isHidden : false, isEssential : true}
			, {id : "POINT", label:["포인트", "#text_filter"], type : "ron", width : "70", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "POINT_SUM", label:["누적포인트", "#text_filter"], type : "ron", width : "70", sort : "str", align : "right", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "CDATE", label:["등록일", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "LAST_TRADE_DATE", label:["최근거래일", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "MDATE", label:["수정일", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "BF_M2DATE", label:["모바일신호", "#text_filter"], type : "ro", width : "72", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "DELI_MEMO", label:["배송메모", "#text_filter"], type : "ed", width : "270", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "ETC_MEMO", label:["기타메모", "#text_filter"], type : "ed", width : "270", sort : "str", align : "left", isHidden : false, isEssential : false}
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
			
			document.getElementById("txtPOST").value = addressMap.selectZipNo;
			document.getElementById("txtADDRESS").value = addressMap.selectAddress;
			
			$erp.closePopup2('ERP_POST_WIN_ID');
		}
		$erp.openSearchPostAddrPopup2(onComplete, {win_id : "ERP_POST_WIN_ID"});
	}

</script>
</head>
<body>		

	<div id="div_top_layout" class="samyang_div" style="display:none">
		<div id="div_top_layout_search" class="samyang_div">
			<table id="tb_search" class="table">
				<colgroup>
					<col width="110px"/>
					<col width="130px"/>
					<col width="110px"/>
					<col width="130px"/>
					<col width="110px"/>
					<col width="130px"/>
					<col width="110px"/>
					<col width="130px"/>
					<col width="110px"/>
					<col width="*"/>
				</colgroup>
				<tr id="selectORGN_INFO">
					<th colspan="1">법인구분</th>
					<td colspan="2"><div id="cmbORGN_DIV_CD"></div></td>
					<th colspan="1">조직명</th>
					<td colspan="6"><div id="cmbORGN_CD"></div></td>
				</tr>
				<tr>
					<th colspan="1">상호명[회원명]</th>
					<td colspan="1"><input type="text" id="txtMEM_NM" style="width:95%" class="input_common" autocomplete="off" value="" onkeyup="if(event.keyCode==13){ribbon.callEvent('onClick', ['search_grid']);}"></td>
					<th colspan="1"><div id="chkTOP_COUNT_chk" style="float:right;"></div></th>
					<td colspan="1"><input type="text" id="txtTOP_COUNT" class="input_text" value=""/></td>
					<th colspan="1"><div id="chkRESP_USER_chk" style="float:right;"></div></th>
					<td colspan="5"><input type="text" id="txtRESP_USER" class="input_text" value="" style = "width:120px;"/></td>
				</tr>
				
				<tr>
					<th colspan="1">회원상태</th>
					<td colspan="1"><div id="cmbMEM_STATE"></div></td>
					<th colspan="1">회원유형</th>
					<td colspan="1"><div id="cmbMEM_TYPE"></div></td>
					<th colspan="1">도매등급</th>
					<td colspan="5"><div id="cmbPRICE_POLI"></div></td>
				</tr>
				
				<tr>
					<th colspan="1">ABC</th>
					<td colspan="1"><div id="cmbMEM_ABC"></div></td>
					<th colspan="1">회원그룹</th>
					<td colspan="1"><div id="cmbGRUP_CD"></div></td>
					<th colspan="1">SMS 수신</th>
					<td colspan="5"><div id="cmbSMS_YN"></div></td>
				</tr>
				
				<tr>
					<th colspan="1">소액처리</th>
					<td colspan="1">
						<div id="cmbCHG_AMT_TYPE"></div>
					</td>
					<th colspan="1">현금영수증</th>
					<td colspan="7">
						<div style="float:left;" id="cmbCASH_RECP_YN"></div>
						<div style="float:left;" id="cmbCASH_RECP_TYPE"></div>
						<input type="text" id="txtLAST_CASH_RECP_NO" class="input_text" value="" style="width: 80px; float:left; margin-left: 5px;" readonly/>
						<div style="float:left; margin-left: 5px;" id="cmbLAST_CASH_RECP_TYPE"></div>
					</td>
				</tr>
				
				<tr>
					<th colspan="1">
						<input type="button" id="" class="input_common_button" value="우편" onClick="openSearchPostAddrPopup();" style="width: 50px;"/>
					</th>
					<td colspan="1">
						<input type="text" id="txtZIP_NO" class="input_text" value="" />
					</td>
					<th colspan="1">주소</th>
					<td colspan="7">
						<input type="text" id="txtADDRESS" class="input_text" value="" style = "width:360px;"/>
					</td>
				</tr>
				
				<tr>
					<th colspan="1"><div id="chkJOIN" style="float:left; margin-left: 50px"></div></th>
					<td colspan="2">
						<input type="text" id="txtDATE_FR_JOIN" class="input_calendar default_date" data-position="-7" value="" style="float: left;">
						<span style="float: left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO_JOIN" class="input_calendar default_date" data-position="" value="" style="float: left; margin-left: 6px;">
					</td>
					<th colspan="1"><div id="chkTRANSACTION" style="float:left; margin-left: 40px;"></div></th>
					<td colspan="6">
						<input type="text" id="txtDATE_FR_TRANSACTION" class="input_calendar default_date" data-position="-7" value="" style="float: left;">
						<span style="float: left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO_TRANSACTION" class="input_calendar default_date" data-position="" value="" style="float: left; margin-left: 6px;">
					</td>
				</tr>

			</table>
		</div>
	</div>

	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bottom_layout" class="div_grid_full_size" style="display:none"></div>
</body>
</html>