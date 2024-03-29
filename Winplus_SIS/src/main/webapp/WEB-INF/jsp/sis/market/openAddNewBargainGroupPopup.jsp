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

	var erpPopupWindowsCell = parent.erpPopupWindows.window("openAddNewBargainGroupPopup");
	var erpLayout;
	var erpRibbon;
	var cmbPRIORITY_EVENT_YN;
	var cmbORGN_CD;
	var cmbUSE_YN;
	var cmbTITLE_TYPE;
	var erpPopupGrupCheckList;
	var AUTHOR_CD = "${screenDto.author_cd}";
	var orgnCheck = LUI.LUI_orgn_delegate_cd;
	
	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	var todayDate = thisYear + "-" + thisMonth + "-01";
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("새 특매그룹 추가");
		}
		
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		
		document.getElementById("searchDateFrom").value=todayDate;
		document.getElementById("searchDateTo").value=today;
		
		$erp.asyncObjAllOnCreated(function(){
			var searchable = 1;
			var search_cd_Arr = LUI.LUI_searchable_auth_cd.split(",")
			for(var i in search_cd_Arr){
				if(search_cd_Arr[i] == "1" || search_cd_Arr[i] == "5" || search_cd_Arr[i] == "ALL"){
					searchable = 2;
				}else if (search_cd_Arr[i] == "3"){
					searchable = 3;
				}
			}
			
			if(searchable == 1 ){ //직영점단일
				cmbORGN_CD.forEachOption(function(option){
					cmbORGN_CD.setChecked(option.index,false);
				});
				cmbORGN_CD.forEachOption(function(option){
					if(option.value == orgnCheck){
						cmbORGN_CD.setChecked(option.index,true);
					}
				});
			}
		});
		
	});
	
	<%-- ■ erpLayout 초기화 시작 --%>
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id: "a", text: "회원정보", header:false, fix_size : [true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size : [true, true]}
				
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_table");
		erpLayout.cells("a").setHeight(210);
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		
		erpLayout.setSeparatorSize(0, 1);
		erpLayout.setSeparatorSize(1, 1);
	}
	<%-- ■ erpLayout 초기화 끝 --%>
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>
	<%-- erpRibbon 초기화 Function --%>
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
				, skin : ERP_RIBBON_CURRENT_SKINS
				, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
				, items : [
					{type : "block", mode : 'rows', list : [
						{id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					]}
				]	
			});
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "add_erpGrid"){
				addErpGrid();
			}
		});
	}
	
	<%-- addErpGrid 추가 Function --%>
	function addErpGrid(){
		var date_from = document.getElementById("searchDateFrom").value;
		var date_to = document.getElementById("searchDateTo").value;
		var EVENT_NAME = document.getElementById("txtEVENT_NM").value; 
		var TITLE_TYPE = cmbTITLE_TYPE.getSelectedValue();
		var EVENT_NM = TITLE_TYPE + EVENT_NAME;
		var EVENT_TYPE = cmbPRIORITY_EVENT_YN.getSelectedValue();
		var USE_YN = cmbUSE_YN.getSelectedValue();
		var ORGN_CD = cmbORGN_CD.getChecked();
		var ORGN_NM =[];
		var ORGN_CHECK = ORGN_CD.length;
		var EVENT_STRT_DATE = date_from.replace(/\-/g,'');
		var EVENT_END_DATE = date_to.replace(/\-/g,'');
		
		if(EVENT_NAME == ""){
			$erp.alertMessage({
				"alertMessage" : "특매그룹명을 입력해 주세요.",
				"alertType" : "alert",
				"isAjax" : false
			});
		}else if(ORGN_CHECK == 0){
			$erp.alertMessage({
				"alertMessage" : "조직명을 선택해 주세요.",
				"alertType" : "alert",
				"isAjax" : false
			});
		}else if(EVENT_STRT_DATE > EVENT_END_DATE){
			$erp.alertMessage({
				"alertMessage" : "날짜를 확인해 주세요.",
				"alertType" : "alert",
				"isAjax" : false
			});
		}else{
			for (var i=0 ; i < ORGN_CD.length ; i++){
				ORGN_NM[i] = cmbORGN_CD.getOption(ORGN_CD[i]).text;
			}
			if(!$erp.isEmpty(erpPopupGrupCheckList) && typeof erpPopupGrupCheckList === 'function'){
				erpPopupGrupCheckList(EVENT_STRT_DATE, EVENT_END_DATE, EVENT_NM, EVENT_TYPE, ORGN_CD, ORGN_NM, USE_YN, EVENT_NAME);
			}
		}
	}
	
	<%-- dhtmlXCombo 초기화 Function --%> 
	function initDhtmlXCombo(){
		cmbPRIORITY_EVENT_YN = $erp.getDhtmlXCombo("cmbPRIORITY_EVENT_YN", "PRIORITY_EVENT_YN", "PRIORITY_EVENT_YN" , 120);
		cmbORGN_CD = $erp.getDhtmlXComboMulti("cmbORGN_CD", "ORGN_CD", {commonCode : "ORGN_CD",div1 : "MK", div5 : "MK"}, 120, "전체", LUI.LUI_orgn_delegate_cd);
		cmbUSE_YN  = $erp.getDhtmlXCombo('cmbUSE_YN', 'USE_YN', ['YN_CD','YN'], 120);
		
		cmbTITLE_TYPE = new dhtmlXCombo("cmbTITLE_TYPE");
		cmbTITLE_TYPE.setSize(198);
		cmbTITLE_TYPE.readonly(true);
		cmbTITLE_TYPE.addOption([
			{value: "[통합전단]", text: "[통합전단]" ,selected: true}
			,{value: "[자체전단]", text: "[자체전단]"}
			,{value: "[비전단]", text: "[비전단]"}
			,{value: "[업체지원]", text: "[업체지원]"}
			,{value: "[재고소진]", text: "[재고소진]"}
			,{value: "", text: "기타"}
		]);
	}
	
</script>
</head>
<body>
	<div id="div_erp_table" class="samyang_div" style="diplay:none;">
			<table id="add_table01" class="table">
				<tr height="40">
					<th colspan="5" style="text-align: center; font-size: 13px;">새 특매그룹 등록</th>
				</tr>
				<tr height="30">
					<th colspan="2" style="text-align: left;">● 기    간</th>
					<td colspan="3">
						<input type="text" id="searchDateFrom" name="searchDateFrom" class="input_common input_calendar">
						<span style="float: left; margin-right: 5px;">~</span> 
						<input type="text" id="searchDateTo" name="searchDateTo" class="input_common input_calendar">
					</td>
				</tr>
				<tr height="30">
					<th colspan="2" style="text-align: left;">● 타이틀</th>
					<td colspan="3">
						<div id = "cmbTITLE_TYPE"></div>
						<input type="text" id="txtEVENT_NM" name="txtEVENT_NM" maxlength="100" style="width: 190px;" class="input_common input_essential">
					</td>
				</tr>
				<tr height="30">
					<th colspan="2" style="text-align: left;">● 조직명</th>
					<td colspan="3">
						<div id="cmbORGN_CD"></div>
					</td>
				</tr>
				<tr height="30">
					<th colspan="2" style="text-align: left;">● 특매구분</th>
					<td colspan="3">
						<div id="cmbPRIORITY_EVENT_YN"></div>
					</td>
				</tr>
				<tr height="30">
					<th colspan="2" style="text-align: left;">● 사용구분</th>
					<td colspan="3">
						<div id="cmbUSE_YN"></div>
					</td>
				</tr>
				<tr height="70">
				<th colspan="5" style="text-align: justify; font-weight: initial;">
				※상품이 우선/일반 그룹에 등록될 경우 우선  → 일반 순서로 특매가 적용됩니다.
				</th>
				</tr>
		</table>
	</div>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
</body>
</html>