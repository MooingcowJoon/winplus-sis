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
	LUI.exclude_auth_cd = "ALL,1,2";
	
	var erpPopupWindowsCell = parent.erpPopupWindows.window("openAddGoodsGrupPopup");
	var bcd_list = JSON.parse('${param.BCD_CD_LIST}');
	var erpPopupLayout;
	var cmbORGN_DIV_CD;
	var cmbORGN_CD;
	var cmbUSE_YN;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("상품그룹추가");
		}
		initErpPopupLayout();
		initGroupRibbon();
		initDthmlxCombo();
	});
	
	function initErpPopupLayout() {
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text : "리본영역", header : false}
				, {id: "b", text : "상품그룹등록정보영역", header : false}
			]
		});
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_popup_save_condition");
		
		erpPopupLayout.setSeparatorSize(1,0);
	}
	
	function initGroupRibbon() {
		erpGroupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : "rows", list : [
					{id : "save_erp_group_Grid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}           
			]
		});
		
		erpGroupRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "save_erp_group_Grid"){
				saveErpGroup();
			}
		});
	}
	
	function saveErpGroup(){
		var GoodsGrupName = $("#txtGoods_Grup_Name").val();
		console.log(GoodsGrupName);
		
		if(GoodsGrupName == ""){
			$erp.alertMessage({
				"alertMessage" : "상품그룹명은 필수 입력값입니다.",
				"alertCode" : null,
				"alertType" : "alert",
				"isAjax" : false
			});
		} else {
			erpPopupLayout.progressOn();
			$.ajax({
				url : "/common/popup/addGoodsGrup.do"
				,method : "POST"
				,dataType : "JSON"
				,data : {
					"bcd_list" : bcd_list
					,"ORGN_DIV_CD" : cmbORGN_DIV_CD.getSelectedValue()
					, "ORGN_CD" : cmbORGN_CD.getSelectedValue()
					, "GRUP_NM" : GoodsGrupName
					, "GRUP_TYPE" : "G"
					, "USE_YN" : cmbUSE_YN.getSelectedValue()
				}
				,success : function(data){
					erpPopupLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						var orgn_bcd_list_length = bcd_list.length;
						
						if(data.ResultMessage == "SUCCESS"){
							var resultCnt = data.resultCnt;
							$erp.alertMessage({
								"alertMessage" : resultCnt + "/" + orgn_bcd_list_length + " 개의 상품이 그룹명 <br>'" + GoodsGrupName + "' 으로 등록되었습니다.",
								"alertCode" : null,
								"alertType" : "alert",
								"isAjax" : false
							});
						} else {
							$erp.alertMessage({
								"alertMessage" : data.ResultMessage,
								"alertCode" : null,
								"alertType" : "alert",
								"isAjax" : false
							});
						}
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	function initDthmlxCombo(){
		cmbORGN_DIV_CD = $erp.getDhtmlXComboTableCode("cmbORGN_DIV_CD", "ORGN_DIV_CD", "/sis/code/getSearchableOrgnDivCdList.do", LUI, 180, null, true, null, function(){
			cmbORGN_CD = $erp.getDhtmlXComboTableCode("cmbORGN_CD", "ORGN_CD", "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : cmbORGN_DIV_CD.getSelectedValue()}]), 120, null, false, null);
			cmbORGN_DIV_CD.attachEvent("onChange", function(value, text){
				cmbORGN_CD.unSelectOption();
				cmbORGN_CD.clearAll();
				$erp.setDhtmlXComboTableCodeUseAjax(cmbORGN_CD, "/sis/code/getSearchableOrgnCdList.do", $erp.unionObjArray([LUI, {ORGN_DIV_CD : value}]), null, false, null);
			}); 
		});
		
		cmbUSE_YN = $erp.getDhtmlXCombo("cmbUSE_YN", "USE_YN", ["USE_CD" , "YN"], 80, null, "Y");
	}
	
</script>
</head>
<body>
	<div id="div_erp_popup_layout" class="div_layout_full_size" style="display:none">
		<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_popup_save_condition" class="div_erp_contents_search" style="display:none;">
			<table class="table_search">
				<colgroup>
					<col width="85px">
					<col width="180px">
					<col width="75px">
					<col width="*">
				</colgroup>
				<tr>
					<th>법인구분</th>
					<td><div id="cmbORGN_DIV_CD"></div></td>
					<th>조직명</th>
					<td><div id="cmbORGN_CD"></div></td>
				</tr>
				<tr>
					<th>상품그룹명</th>
					<td colspan="3">
						<input type="text" id="txtGoods_Grup_Name" maxlength="24">
					</td>
				</tr>
				<tr>
					<th>사용여부</th>
					<td colspan="3">
						<div id="cmbUSE_YN"></div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
</body>
</html>