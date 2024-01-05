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
	
	var erpLayout;
	var erpRightLayout;
	var erpLeftLayout;
	var erpRibbon;
	var erpAddRibbon;
	var erpRightRibbon;
	var cmbSearch;
	var cmbSubSearch;
	
	
	$(document).ready(function(){		
		initDhtmlXCombo();
		initErpLayout();
		initErpLeftLayout();
		initErpRibbon();
		initErpGrid();
		initErpRightLayout();
		initErpRightRibbon();
	});
	
	function initErpLayout() {
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2U"
			, cells : [
				{id:"a" , text: "포인트 기본설정", header : true, width: 850}
				, {id: "b", text: "포인트적립(구매금액)", header : true}
			]
		});
		
		erpLayout.cells("a").attachObject("div_erp_Left_layout");
		erpLayout.cells("b").attachObject("div_erp_right_layout");
		
		erpLayout.setSeparatorSize(1,0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			erpLeftLayout.setSizes();
			erpRightLayout.setSizes();
		});
		
	}
	
	<%--
	**********************************************************************
	* ※ Left 영역
	**********************************************************************
	--%>
	
	function initErpLeftLayout() {
		erpLeftLayout = new dhtmlXLayoutObject({
			parent : "div_erp_Left_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "2E"
			, cells : [
				{id:"a", text: "", header: false}
				, {id:"b", text: "", header : false, fix_size:[true, true]}
			]
		});
		erpLeftLayout.cells("a").attachObject("div_erp_ribbon");
		erpLeftLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLeftLayout.cells("b").attachObject("div_erp_contents_wrapper");
		
		erpLeftLayout.setSeparatorSize(1,0);
	}
	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "save_data", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}          
				]}
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "save_data"){
				alert("포인트 기본설정 저장!");
			}
		});
	}
	
	
	
	<%--
	**********************************************************************
	* ※ Right 영역
	**********************************************************************
	--%>
	
	function initErpRightLayout() {
		erpRightLayout = new dhtmlXLayoutObject({
			parent : "div_erp_right_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id:"a", text: "", header: false}
				, {id:"b", text: "", header: false, fix_size:[true, true]}
				, {id:"c", text: "", header: false}
			]
		});
		erpRightLayout.cells("a").attachObject("div_erp_right_condition");
		erpRightLayout.cells("a").setHeight(70);
		erpRightLayout.cells("b").attachObject("div_erp_right_Ribbon");
		erpRightLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightLayout.cells("c").attachObject("div_erp_right_grid");
		
		erpRightLayout.setSeparatorSize(1,0);
		
		$erp.setEventResizeDhtmlXLayout(erpRightLayout, function(names){
			erpGrid.setSizes();
		});
	}
	
	function initErpRightRibbon(){
		erpRightRibbon = new dhtmlXRibbon({
			parent : "div_erp_right_Ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "add_erpGrid", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}				                                        
					, {id : "delete_erpGrid", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					, {id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}
			]
		});
		
		erpRightRibbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "add_erpGrid") {
				addErpGrid();
			} else if(itemId == "delete_erpGrid"){
				deleteErpGrid();
			} else if(itemId == "save_erpGrid"){
				saveErpGrid();
			}
		});
	}
	
	function initErpGrid() {
		erpGridColumns = [
			{id:"NO", label:["NO", "#rspan"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			 , {id : "CHECK", label:["#master_checkbox", "#rspan"], type: "ch", width: "40", sort : "int", align : "center", isHidden : false, isEssential : false}
			 , {id : "sprice", label:["구매금액(~원)이상", "#rspan"], type: "ed", width: "150", sort : "int", align : "center", isHidden : false, isEssential : false}
			 , {id : "bprice", label:["구매금액(~원)미만", "#rspan"], type: "ed", width: "150", sort : "int", align : "left", isHidden : false, isEssential : false}
			 , {id : "point", label:["포인트", "#rspan"], type: "ed", width: "80", sort : "int", align : "left", isHidden : false, isEssential : false}
			 , {id : "type", label:["적립방법", "#select_filter"], type: "combo", width: "100", sort : "str", align : "left", isHidden : false, isEssential : true, commonCode: "BONUS_POINT_TYPE"}
		];
		
		erpGrid = new dhtmlXGridObject({
			parent : "div_erp_right_grid"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpGridColumns
		});
		
		erpGrid.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpGrid);
		$erp.attachDhtmlXGridFooterRowCount(erpGrid, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(erpGrid);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(erpGrid);
		$erp.initGridComboCell(erpGrid);
		$erp.attachDhtmlXGridFooterPaging(erpGrid, 100);
	}
	
	function addErpGrid() {
		var uid = erpGrid.uid();
		erpGrid.addRow(uid);
		erpGrid.selectRow(erpGrid.getRowIndex(uid));
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	function deleteErpGrid() {
		var gridRowCount = erpGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0 ; i < gridRowCount; i++){
			var rId = erpGrid.getRowId(i);
			var check = erpGrid.cells(rId, erpGrid.getColIndexById("CHECK")).getValue();
			if(check == "1"){
				deleteRowIdArray.push(rId);
			}
		}
		
		if(deleteRowIdArray.length == 0){
			$erp.alertMessage({
				"alertMessage" : "error.common.noSelectedRow"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return;
		}
		
		for(var i = 0; i < deleteRowIdArray.length; i++){
			erpGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpGrid);
	}
	
	function saveErpGrid() {
		if(erpGridDataProcessor.getSyncState()){
			$erp.alertMessage({
				"alertMessage" : "error.common.noChanged"
				, "alertCode" : null
				, "alertType" : "error"
			});
			return false;
		}
		
		var validResultMap = $erp.validDhtmlXGridEssentialData(erpGrid);
		if(validResultMap.isError) {
			$erp.alertMessage({
				"alertMessage" : validResultMap.errMessage
				, "alertCode" : validResultMap.errCode
				, "alertType" : "error"
				, "alertMessageParam" : validResultMap.errMessageParam
			});
			return false;
		} 
		
		erpLayout.progressOn();
		var paramData = $erp.serializeDhtmlXGridData(erpGrid);
		$.ajax({
			url : ""  //값넣어야합니다!
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data) {
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				}else {
					console.log(data);
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	<%--
	**********************************************************************
	* ※ 기타 영역
	**********************************************************************
	--%>
	
	<%-- dhtmlXCombo 초기화 Function --%>	
	function initDhtmlXCombo(){
		cmbSearch = $erp.getDhtmlXCombo("cmbSearch", "Search", "BONUS_POINT_TYPE" , 110 , "적립방법선택", false, String);
	} 
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
	
</script>
</head>
<body>
	<div id="div_erp_Left_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
		<div id="div_erp_contents_wrapper" class="div_common_contents_full_size" style="display:none">
			<table id="tb_erp_data" class="tb_erp_common">
				<colgroup>
					<col width="200px" />
					<col width="160px" />
					<col width="200px" />
					<col width="*" />
				</colgroup>
				<tr>
					<td colspan="4" class="td_subject"><div id="div_data_info" class="common_left"><b> * 기본포인트</b></div></td>
				</tr>
				<tr>
					<th>현금</th>
					<td>
						<input type="text" id="cash_val" name="cash_val" class="input_common input_number" maxlength="20"> %
					</td>
					<th>카드</th>
					<td>
						<input type="text" id="card_val" name="card_val" class="input_common input_number" maxlength="20"> %
					</td>
				</tr>
				<tr>
					<th>포인트</th>
					<td>
						<input type="text" id="point_val" name="point_val" class="input_common input_number" maxlength="20"> %
					</td>
					<th>상품권</th>
					<td>
						<input type="text" id="gift_val" name="gift_val" class="input_common input_number" maxlength="20"> %
					</td>
				</tr>
				<tr>
					<th>외상</th>
					<td>
						<input type="text" id="trust_val" name="trust_val" class="input_common input_number" maxlength="20"> %
					</td>
				</tr>
				<tr>
					<td colspan="4" class="td_subject">
						<div id="div_data_info" class="common_left">
							<b style="float:left;"> * 포인트 기본 설정    &nbsp;&nbsp;</b>
							<input type="checkbox" id="pos_give_point" name="Select_Goods" style="float: left;"/>
							<label for="pos_give_point" style="float:left;">단말에서 포인트 지불     &nbsp;&nbsp;</label>
							<input type="checkbox" id="limit_point_gift" name="Select_Goods" style="float: left;"/>
							<label for="limit_point_gift" style="float:left;">포인트 지불을 사은품으로 제한</label>
						</div>
					</td>
				</tr>
				<tr>
					<th>포인트지불 사용단위</th>
					<td>
						<input type="text" id="point_unit" name="point_unit" class="input_common input_number" maxlength="20"> 
					</td>
					<th>
						<input type="checkbox" id="ok_pay_accum_point" name="Select_Goods" style="float: left;"/>
						<label for="ok_pay_point">포인트지불가능 누적포인트</label>
					</th>
					<td>
						<input type="text" id="point_unit" name="point_unit" class="input_common input_number" maxlength="20"> 
					</td>
				</tr>
				<tr>
					<th>사용가능한 최소포인트</th>
					<td>
						<input type="text" id="min_point" name="min_point" class="input_common input_number" maxlength="20"> 
					</td>
					<th>
						<input type="checkbox" id="ok_pay_point" name="Select_Goods" style="float: left;"/>
						<label for="ok_pay_point">포인트지불가능 현재(가용)포인트</label>
					</th>
					<td>
						<input type="text" id="point_unit" name="point_unit" class="input_common input_number" maxlength="20"> 
					</td>
				</tr>
				<tr>
					<td colspan="4" class="td_subject"><div id="div_data_info" class="common_left"><b> * 기타 설정</b></div></td>
				</tr>
				<tr>
					<th>새 상품등록시 기본 적립율</th>
					<td>
						<input type="text" id="basic_save" name="basic_save" class="input_common input_number" maxlength="20"> %
					</td>
				</tr>
				<tr>
					<td colspan="4" class="td_subject">
						<div id="div_data_info" class="common_left">
							<b style="float:left;"> * 모바일회원 포인트 설정 &nbsp;&nbsp;</b>
							<input type="checkbox" id="apply_point" name="Select_Goods" style="float: left;"/>
							<label for="apply_point" style="float:left;">포인트 적용</label> 
						</div>
					</td>
				</tr>
				<tr>
					<th>모바일 접속 기록</th>
					<td>
						<input type="text" id="mobile_day" name="mobile_day" size="15" maxlength="20">  일전 까지
					</td>
					<th>적립 포인트</th>
					<td>
						<input type="text" id="save_point" name="save_point" maxlength="20" style="float: left; margin-right: 10px;"/>
						<div id="cmbSearch"></div>
					</td>
				</tr>
				<tr>
					<td colspan="4" class="td_subject"><div id="div_data_info" class="common_left"><b> * 생일/기념일 포인트 설정</b></div></td>
				</tr>
				<tr>
					<th>
						<input type="checkbox" id="ck_prev_birth_point" name="Select_Goods" style="float: left;"/>
						<label for="ck_prev_birth_point">생일/기념일 포인트 적용(몇일전부터)</label>
					</th>
					<td>
						<input type="text" id="pre_birth_point" name="pre_birth_point" class="input_common input_number" maxlength="20">
					</td>
					<th>
						<input type="checkbox" id="ck_next_birth_point" name="Select_Goods" style="float: left;"/>
						<label for="ck_next_birth_point">생일/기념일 포인트 적용(몇일후까지)</label>
					</th>
					<td>
						<input type="text" id="next_birth_point" name="next_birth_point" class="input_common input_number" maxlength="20">
					</td>
				</tr>
				<tr>
					<th>
						<input type="checkbox" id="ck_birth_point" name="Select_Goods" style="float: left;"/>
						<label for="ck_birth_point">생일인 고객포인트(정액)</label>
					</th>
					<td>
						<input type="text" id="birth_point" name="birth_point" class="input_common input_number" maxlength="20">
					</td>
					<th>
						<input type="checkbox" id="ck_sal_point" name="Select_Goods" style="float: left;"/>
						<label for="ck_sal_point">기념일인 고객 포인트(정액)</label>
					</th>
					<td>
						<input type="text" id="sal_point" name="sal_point" class="input_common input_number" maxlength="20">
					</td>
				</tr>
				<tr>
					<td colspan="4" class="td_subject"><div id="div_data_info" class="common_left"><b> * 신규/추천 포인트 설정</b></div></td>
				</tr>
				<tr>
					<th>
						<input type="checkbox" id="ck_new_bonus_time" name="Select_Goods" style="float: left;"/>
						<label for="ck_new_bonus_time">신규 고객 보너스 적용 시점(누적포인트)</label>
					</th>
					<td>
						<input type="text" id="new_bonus_time" name="new_bonus_time" class="input_common input_number" maxlength="20">
					</td>
					<th>
						<input type="checkbox" id="ck_new_bonus_point" name="Select_Goods" style="float: left;"/>
						<label for="ck_new_bonus_point">신규 고객 보너스 포인트(정액)</label>
					</th>
					<td>
						<input type="text" id="new_bonus_point" name="new_bonus_point" class="input_common input_number" maxlength="20">
					</td>
				</tr>
				<tr>
					<th>
						<input type="checkbox" id="ck_rec_bonus_point" name="Select_Goods" style="float: left;"/>
						<label for="ck_rec_bonus_point">추천 고객 보너스 포인트(정액)</label>
					</th>
					<td colspan="3">
						<input type="text" id="rec_bonus_point" name="rec_bonus_point" class="input_common input_number" maxlength="20">
					</td>
				</tr>
				<tr>
					<td colspan="4" class="td_subject"><div id="div_data_info" class="common_left"><b> * 보너스 포인트 적립 설정</b></div></td>
				</tr>
				<tr>
					<td>
						<input type="checkbox" id="pos_give_point" name="Select_Goods" style="float: left;"/>
						<label for="pos_give_point">등급 포인트 적립</label>
					</td>
					<td>
						<input type="checkbox" id="pos_give_point" name="Select_Goods" style="float: left;"/>
						<label for="pos_give_point">회원유형별 포인트 적립</label>
					</td>
					<td>
						<input type="checkbox" id="pos_give_point" name="Select_Goods" style="float: left;"/>
						<label for="pos_give_point">기간별 포인트 적립</label>
					</td>
					<td>
						<input type="checkbox" id="pos_give_point" name="Select_Goods" style="float: left;"/>
						<label for="pos_give_point">요일별 포인트 적립</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="checkbox" id="pos_give_point" name="Select_Goods" style="float: left;"/>
						<label for="pos_give_point">시간대별 포인트 적립</label>
					</td>
					<td>
						<input type="checkbox" id="pos_give_point" name="Select_Goods" style="float: left;"/>
						<label for="pos_give_point">일정금액 구매시 포인트 적립</label>
					</td>
					<td>
						<input type="checkbox" id="pos_give_point" name="Select_Goods" style="float: left;"/>
						<label for="pos_give_point">단체 가입회원 포인트 기부 단말에서 처리 사용</label>
					</td>
					<td>
						<input type="checkbox" id="pos_give_point" name="Select_Goods" style="float: left;"/>
						<label for="pos_give_point">단체 가입회원 포인트 기부시 후원 포인트 적립</label>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="div_erp_right_layout" class="div_layout_full_size div_sub_layout" style="display:none">
		<!-- <div id="div_erp_right_addRibbon" class="div_ribbon_full_size" style="display:none"></div> -->
		<div id="div_erp_right_condition" class="div_common_contents_full_size" style="display:none">
			<table id="tb_erp_price_data" class="tb_erp_common">
				<colgroup>
					<col width="100px" />
					<col width="*" />
				</colgroup>
				<tr>
					<td colspan="4" class="td_subject"><div id="div_data_info" class="common_center"><b>구매금액 범위 추가 (범위는 작은 금액에서 큰 금액 입니다.)</b></div></td>
				</tr>
				<tr>
					<td colspan="4">
						<font color="red">* 정액은 (입력값) 을 추가 적립합니다. (예: 100포인트 추가적립시 100을 입력)</font><br/>
						<font color="red">* 배수는 기본포인트 X (입력값) 을 추가 적립합니다. (예: 기본포인트 두배 행사일 경우 1을 입력)</font>
					</td>
				</tr>
			</table>
		</div>
	<div id="div_erp_right_Ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_right_grid" class="div_common_contents_full_size" style="display:none"></div>
	</div>
	
	
</body>
</html>