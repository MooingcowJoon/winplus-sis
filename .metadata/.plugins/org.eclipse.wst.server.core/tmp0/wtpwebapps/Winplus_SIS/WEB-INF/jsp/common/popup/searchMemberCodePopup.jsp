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
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ layout : Object / 퍼펙트 사용자 목록 DhtmlXLayout
		■ layout_ribbon : Object / 퍼펙트 사용자 정보 조회 DhtmlXRibbon
		■ layout_ribbon_item_properties : Object / ribbon 이 수행할 기능 속성
		■ layout_grid : Object / 사용자 목록 그리드  DhtmlXGrid
		■ layout_ribbon_item_properties : Object / grid 가 수행할 기능 속성
	--%>
		
	var layout;
	
	var layout_ribbon;
	var layout_ribbon_item_properties;
	var layout_grid;
	var layout_grid_properties;
	
	var selectRowNum = 0;
	
	$(document).ready(function(){
		var thisPopupWindow = parent.erpPopupWindows.window("searchMemberCodePopup");
		
		if(thisPopupWindow){
			thisPopupWindow.setText("담당자 코드 조회 팝업");
		}
		
		init_layout_division();
		init_layout_division();
		init_layout_search();
		init_layout_ribbon();
		init_layout_grid();
		initGridAndRibbon();
	});
	
	<%-- ■ 전체 layout 초기화 시작 --%>
	function init_layout_division() {
		layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
				, cells: [
					{id: "a", text: "", header:false, fix_size:[true, true]}
					, {id: "b", text: "", header:false}
					, {id: "c", text: "", header:false}
				]		
		});
		
		layout.cells("a").attachObject("div_layout_search");
		layout.cells("a").setHeight(38);

		layout.cells("b").attachObject("div_layout_ribbon");
		layout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);

		layout.cells("c").attachObject("div_layout_grid");
		
		layout.setSeparatorSize(0, 1); //테이블 리본 사이간격
		layout.setSeparatorSize(1, 0); //리본 크기 조절 방지

		$erp.setEventResizeDhtmlXLayout(layout, function(names){
			layout.setSizes();
		});

	}
	
	function init_layout_search(){
		cmbSCH_MEMBER_WAREA = $erp.getTbsDhtmlXCombo('cmbSCH_MEMBER_WAREA', 'MEMBER_WAREA', 'BUSINESS_INF', 145, '미선택', '');
		cmbSCH_MEMBER_USE_YN = $erp.getDhtmlXCombo('cmbSCH_MEMBER_USE_YN', 'MEMBER_USE_YN', ['YN_CD','YN'], 50, true, 'Y');
	}

	function init_layout_ribbon(){
		var item_list = [
							{id : "search_data", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false, "num" : "1"}
						];
		layout_ribbon = new dhtmlXRibbon({
			parent : "div_layout_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{
					type : "block", 
					mode : 'rows', 
					list : item_list
				}
			]
		});
	}

	

	
	function init_layout_grid(){
		var grid_Columns = [
   			{id : "MEMBER_CODE", label:["사용자번호"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MEMBER_NAME", label:["사용자명"], type: "ro", width: "115", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMBER_TNAME", label:["조직명"], type: "ro", width: "110", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMBER_USE_YN", label:["사용여부"], type: "ro", width: "52", sort : "str", align : "center", isHidden : false, isEssential : false}
   		];
   		
		layout_grid = new dhtmlXGridObject({
   			parent: "div_layout_grid"			
   			, skin : ERP_GRID_CURRENT_SKINS
   			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
   			, columns : grid_Columns
   		});
	}
	<%-- ■ 전체 layout 초기화 끝 --%>
	
	<%-- ■ 그리드, 리본  기능  초기화 시작 --%>
	function initGridAndRibbon(){
		
		//그리드속성 선언 
		layout_grid_properties = {
			"row" : {
				"count_text" : '<spring:message code="grid.allRowCount" />',
				"nodata_text" : '<spring:message code="grid.noSearchData" />',
				"double_click" : {
					"func" : function(dhtmlXGridObj,rowId,columnIdx){
						erpPopupGridOnRowDblClicked(dhtmlXGridObj,rowId,columnIdx);
					}
				}
			},
			"footer" : {
				"paging_size" : "100"
			}
		};
		
		//리본 아이템 속성 선언
		layout_ribbon_item_properties = {
			
			//조회
			"1" : {
				"func" : function(){
					
				},
				"db_func" : {
					"use_url" : "/common/employee/getPerfectEmpList.do",
					"send_data" : function(){
						var data = $erp.dataSerialize("tb_search");
							return data;
					},
					"if_success" : function(dhtmlXGridObj,gridDataList){
						dhtmlXGridObj.parse(gridDataList,'js');
					},
					"if_error" : function(dhtmlXGridObj){
									
					}
				}
			}
		};
		
		$erp.initGridAndRibbon(
			layout, //dhtmlx 레이아웃 객체 (전체) progress 용도
			layout_grid, //dhtmlx 그리드 객체
			layout_grid_properties, //dhtmlx 그리드 속성
			layout_ribbon, //dhtmlx 리본 객체
			layout_ribbon_item_properties //dhtmlx 리본 item들의 수행 기능 초기화시 필요 속성
		); 
	}
	<%-- ■ 그리드, 리본  기능  초기화 끝 --%>
	
	function search_button_click(){
		layout_ribbon.callEvent("onClick", ["search_data"]);
	}
	
</script>
</head>
<body>		

	<div id="div_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>	
		<div id="div_layout_search" class="div_erp_contents_search" style="display:none">
			<table id="tb_search" class="table_search">
				<colgroup>
					<col width="30px"/>
					<col width="140px"/>
					<col width="40px"/>
					<col width="80px"/>
					<col width="50px"/>
					<col width="50px"/>
				</colgroup>
				<tr>
					<th>지역</th>
					<td><div id="cmbSCH_MEMBER_WAREA"></div></td>
					<th>사용자</th>
					<td>
						<input type="text" id="txtSCH_MEMBER_NAME" name="MEMBER_NAME" class="input_common" style="width:75px" onkeydown="$erp.onEnterKeyDown(event, search_button_click );">
					</td>
					<th>사용여부</th>
					<td><div id="cmbSCH_MEMBER_USE_YN"></div></td>
	
				</tr>
			</table>
		</div>
		<div id="div_layout_ribbon" class="div_ribbon_full_size"></div>
		<div id="div_layout_grid" class="div_grid_full_size"></div>
</body>
</html>