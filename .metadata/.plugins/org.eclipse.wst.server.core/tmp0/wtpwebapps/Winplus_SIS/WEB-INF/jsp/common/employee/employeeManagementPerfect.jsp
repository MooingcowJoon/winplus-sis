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
		■ layout : Object / 페이지 Layout DhtmlXLayout
		
		■ left_layout : Object / 퍼펙트 사용자 목록 DhtmlXLayout
		■ left_layout_ribbon : Object / 퍼펙트 사용자 정보 조회 DhtmlXRibbon
		■ left_layout_ribbon_item_properties : Object / ribbon 이 수행할 기능 속성
		■ left_layout_grid : Object / 사용자 목록 그리드  DhtmlXGrid
		■ left_layout_ribbon_item_properties : Object / grid 가 수행할 기능 속성
		
		■ right_layout : Object / 퍼펙트 사용자 정보 DhtmlXLayout; 
	--%>
		
	var layout;
	
	var left_layout;
	var left_layout_ribbon;
	var left_layout_ribbon_item_properties;
	var left_layout_grid;
	var left_layout_grid_properties;
	
	var right_layout;
	var selectRowNum = 0;
	
	var CRUD = "";

	
	$(document).ready(function(){		
		init_layout_division();
		init_left_layout_division();
		init_left_layout_search();
		init_left_layout_ribbon();
		init_left_layout_grid();
		init_right_layout_division();
		init_right_layout_info();
		initGridAndRibbon();
		initDhtmlXCombo();
	});
	
	<%-- ■ 전체 layout 초기화 시작 --%>
	function init_layout_division() {
		layout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2U"
			, cells: [
				{id: "a", text: "사용자 목록", header:true, width:470, fix_size:[true, true]}
				, {id: "b", text: "사용자 정보", header:true}
			]		
		});
		
		layout.cells("a").attachObject("div_left_layout");
		layout.cells("b").attachObject("div_right_layout");
		
		layout.setSeparatorSize(1, 0);

		$erp.setEventResizeDhtmlXLayout(layout, function(names){
			left_layout.setSizes();
			right_layout.setSizes();
		});

	}
	<%-- ■ 전체 layout 초기화 끝 --%>
	
	<%-- ■ left_layout 초기화 시작 --%>
	function init_left_layout_division(){
		left_layout = new dhtmlXLayoutObject({
			parent: "div_left_layout"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, fix_size:[true, true]}
				, {id: "b", text: "", header:false}
				, {id: "c", text: "", header:false}
			]			
		});
		
		left_layout.cells("a").attachObject("div_left_layout_search");
		left_layout.cells("a").setHeight(38);

		left_layout.cells("b").attachObject("div_left_layout_ribbon");
		left_layout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);

		left_layout.cells("c").attachObject("div_left_layout_grid");
		
		left_layout.setSeparatorSize(0, 1); //테이블 리본 사이간격
		left_layout.setSeparatorSize(1, 0); //리본 크기 조절 방지

	}
	
	function init_left_layout_search(){
		cmbSCH_MEMBER_WAREA = $erp.getDhtmlXCombo('cmbSCH_MEMBER_WAREA', 'MEMBER_WAREA', 'BUSINESS_INF', 145, '미선택', '');
		cmbSCH_MEMBER_USE_YN = $erp.getDhtmlXCombo('cmbSCH_MEMBER_USE_YN', 'MEMBER_USE_YN', ['YN_CD','YN'], 50, true, 'Y');
	}

	function init_left_layout_ribbon(){
		var item_list = [
							{id : "search_data", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true, "num" : "1"}
							, {id : "add_data", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true , "num" : "2"}
							, {id : "delete_data", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true , "num" : "3"}
							, {id : "save_data", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true , "num" : "4"}
						];
		left_layout_ribbon = new dhtmlXRibbon({
			parent : "div_left_layout_ribbon"
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

	<%-- ■ dhtmlxCombo 관련 Function 시작 --%>
	<%-- dhtmlxCombo 초기화 Function --%>
	function initDhtmlXCombo(){
		
		cmbMEMBER_IS_STOCK = $erp.getDhtmlXCombo('cmbMEMBER_IS_STOCK', 'USE_YN', ['YN_CD','YN'], 147, false, 'N');
		cmbMEMBER_IS_PRICE = $erp.getDhtmlXCombo('cmbMEMBER_IS_PRICE', 'USE_YN', ['YN_CD','YN'], 147, false, 'N');
		
	}
	function init_left_layout_grid(){
		var grid_Columns = [
   			{id : "SELECT", label : ["선택"], type : "ra", width : "40", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
   			, {id : "MEMBER_CODE", label:["사용자번호"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "MEMBER_NAME", label:["사용자명"], type: "ro", width: "115", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMBER_TNAME", label:["조직명"], type: "ro", width: "110", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MEMBER_USE_YN", label:["사용여부"], type: "ro", width: "52", sort : "str", align : "center", isHidden : false, isEssential : false}
   		];
   		
		left_layout_grid = new dhtmlXGridObject({
   			parent: "div_left_layout_grid"			
   			, skin : ERP_GRID_CURRENT_SKINS
   			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
   			, columns : grid_Columns
   		});
	}
	<%-- ■ left_layout 초기화 끝 --%>
	
	<%-- ■ right_layout 초기화 시작 --%>
	function init_right_layout_division(){
		right_layout = new dhtmlXLayoutObject({
			parent: "div_right_layout"
				, skin : ERP_LAYOUT_CURRENT_SKINS
				, pattern: "1C"
				, cells: [
					{id: "a", text: "", header:false, fix_size:[true, true]}
				]			
			});
			
		right_layout.cells("a").attachObject("div_right_layout_info");
		
		right_layout.setSeparatorSize(0, 0);

	}
	
	function init_right_layout_info(){
		
		//사용자번호 : 숫자만입력
		$erp.inputControl("txtMEMBER_CODE", 10 , "number");
		
		//지역
		cmbMEMBER_WAREA = $erp.getDhtmlXCombo('cmbMEMBER_WAREA', 'MEMBER_WAREA', 'BUSINESS_INF', 146, '미선택', '', function(){
			cmbMEMBER_WAREA.attachEvent("onChange", function(value, text){
	            $.ajax({
					url : "/common/system/code/getCommonCodeList.do",
					type: "POST",
					dataType : "JSON",
					data : {
					   'CMMN_CD' : 'MEMBER_TEAM'
					   ,'DIV1' : value
					   ,'DIV2' : ''
					   ,'DIV3' : ''
					   ,'DIV4' : ''
					   ,'DIV5' : ''
					},
					success : function (data) {
					   var list = data.commonCodeList;
					   
					   cmbMEMBER_TEAM.unSelectOption();
					   cmbMEMBER_TEAM.clearAll();
					   
					   cmbMEMBER_TEAM.addOption("","미선택","color:black",null,true);      
					   for(var i=0; i < list.length; i++) {
					      cmbMEMBER_TEAM.addOption(list[i].CMMN_DETAIL_CD,list[i].CMMN_DETAIL_CD_NM);
					   }
					   cmbMEMBER_TEAM.setComboValue(cmbMEMBER_TEAM["event_end_hidden_value"]);
					}
            	});
        	});
        });
		
		//팀명
		var comCdArr = new Array();
		var tmpSplit = null;
	    var div1 = '';
	    var div2 = '';
		comCdArr[0] = 'MEMBER_TEAM';
		comCdArr[1] = 'CH01';
		cmbMEMBER_TEAM = $erp.getDhtmlXCombo('cmbMEMBER_TEAM', 'MEMBER_TEAM', comCdArr, 146, "미선택", "", function(){
		    /* cmbMEMBER_TEAM.attachEvent("onChange", function(value, text){
				if(value != '' && value != null){
				   tmpSplit = value.split('##');
				   div1 = tmpSplit[1];
				   div2 = tmpSplit[0];
				}else{
				   div1 = '';
				   div2 = '';
				}
				
				$.ajax({
				   url : "/common/system/code/getCommonCodeList.do",
				   type: "POST",
				   dataType : "JSON",
				   data : {
				      'CMMN_CD' : 'MEMBER_INF'
				      ,'DIV1' : div1
				      ,'DIV2' : div2
				      ,'DIV3' : ''
				      ,'DIV4' : ''
				      ,'DIV5' : ''
				   },
				   success : function (data) {
				      var list = data.commonCodeList;
				      
				      cmbMEMBER_INF.unSelectOption();
				      cmbMEMBER_INF.clearAll();
				      
				      cmbMEMBER_INF.addOption("","모두조회","color:black",null,true);               
				      for(var i=0; i < list.length; i++) {
				         cmbMEMBER_INF.addOption(list[i].CMMN_DETAIL_CD,list[i].CMMN_DETAIL_CD_NM);
				      }
				      
				      cmbMEMBER_INF.selectOption(0);
				   }
				});
			});  */
		});
		
		//직책
		cmbMEMBER_POSITION = $erp.getDhtmlXCombo('cmbMEMBER_POSITION', 'MEMBER_POSITION', 'MEMBER_POSITION', 146, '미선택', '');
		
		//조
		cmbMEMBER_JO = $erp.getDhtmlXCombo('cmbMEMBER_JO', 'MEMBER_JO', 'MEMBER_JO', 146, '미선택', '');
		
		//내선번호 : 숫자만입력
		$erp.inputControl("txtMEMBER_INPHONE", 4 , "number");
		
		//모바일 콜센터 : 모바일 형식만 입력
		$erp.inputControl("txtMEMBER_COMPANYPHONE", 11 , "phone");
		
		//체크박스 - CTI 사용
		chkMEMBER_CTI = $erp.getDhtmlXCheckBox("chkMEMBER_CTI", 'CTI 사용', null, false);
		
		//체크박스 - 아웃바운드
		chkMEMBER_DIVISION = $erp.getDhtmlXCheckBox("chkMEMBER_DIVISION", '아웃바운드', null, false);
		
		//체크박스 - 재주문
		chkMEMBER_REORDER = $erp.getDhtmlXCheckBox("chkMEMBER_REORDER", '재주문', null, false);
		
		//체크박스 - 직원출고허용
		chkMEMBER_MPRICECHK = $erp.getDhtmlXCheckBox("chkMEMBER_MPRICECHK", '직원출고허용', null, false);
		
		//라디오 - 일반,상담실 CAD,상담팀장
		rdoMEMBER_CONSULT = $erp.getDhtmlXRadio('rdoMEMBER_CONSULT','MEMBER_CONSULT',['0','1','2'] , 0 ,['일반','상담실CAD','상담팀장'],'label-right','horizon');
	}
	
	<%-- ■ right_layout 초기화 끝 --%>
	
	
	<%-- ■ 그리드, 리본  기능  초기화 시작 --%>
	function initGridAndRibbon(){
		
		//그리드속성 선언 
		left_layout_grid_properties = {
			"row" : {
				"count_text" : '<spring:message code="grid.allRowCount" />',
				"nodata_text" : '<spring:message code="grid.noSearchData" />',
				"check" : {
					"func" : function(dhtmlXGridObj,rowId,columnIdx){
						CRUD = "U";
						document.getElementById("div_data_info").textContent = '사용자 수정중';
						use_readonly();
						$erp.dataClear("tb_erp_data");
						left_layout_grid.selectRow(left_layout_grid.getRowIndex(rowId));
						selectRowNum = left_layout_grid.getRowIndex(rowId);
					},
					"db_func" :{
						"use_url":"/common/employee/getPerfectEmpDetail.do",
						"send_data" : function(dhtmlXGridObj,rowId,columnIdx){
							var data = $erp.dataSerializeOfGridRow(dhtmlXGridObj,rowId,columnIdx);
/* 							for(a in data){
								console.log(a +" : " + data[a]);
							} */
							return data;
						},
						"if_success" : function(dhtmlXGridObj,rowId,columnIdx,data){
		    		    	$erp.dataClear("tb_erp_data");
		    		    	document.getElementById("div_data_info").textContent = '사용자 수정중';
		    		    	CRUD = "U";
		    		    	$erp.dataAutoBind("tb_erp_data",data.dataMap);
						},
						"if_error" : function(dhtmlXGridObj,rowId,columnIdx){
										
						}
					}
				}
			},
			"footer" : {
				"paging_size" : "100"
			}
		};
		
		//리본 아이템 속성 선언
		left_layout_ribbon_item_properties = {
			
			//조회
			"1" : {
				"func" : function(){
					CRUD = "U";
					document.getElementById("div_data_info").textContent = '사용자 조회/수정 대기중';
					$erp.dataClear("tb_erp_data");
					use_readonly();
				},
				"db_func" : {
					"use_url" : "/common/employee/getPerfectEmpList.do",
					"send_data" : function(){
						var data = $erp.dataSerialize("tb_search");
							return data;
					},
					"if_success" : function(dhtmlXGridObj,gridDataList){
						dhtmlXGridObj.parse(gridDataList,'js');
						left_layout_grid.selectRow(selectRowNum);
					},
					"if_error" : function(dhtmlXGridObj){
									
					}
				}
			},
			
			//추가
			"2" : {
				"func" : function(){
					CRUD = "C";
					document.getElementById("div_data_info").textContent = '사용자 등록중';
					$erp.dataClear("tb_erp_data");
					unuse_readonly();
				}
			},
			
			//삭제
			"3" : {
				"func" : function(){
					var validation_check = true;
					var message = "";
					
					var send_data = $erp.dataSerialize("tb_erp_data");
					var check = function(db_func){
						if(validation_check == true){
							$erp.confirmMessage({
								"alertMessage" : "퇴사처리 하시겠습니까?"
								, "alertCode" : ""
								, "alertType" : "alert"
								, "alertCallbackFn" : function(){
									db_func();
								}
							});
						}else{
							$erp.alertMessage({
								"alertMessage" : message
								, "alertCode" : "사용자 삭제 실패"
								, "alertType" : "error"
								, "isAjax" : false
							});
						}
					}
					
					if(send_data.MEMBER_CODE == ""){
						validation_check = false;
						message = "선택된 사용자 없음";
						return check;
					}
					
					return check;
				},
				"db_func" : { 
					"use_url" : "/common/employee/insertPerfectEmp.do",
					"send_data" : function(){
						var data = $erp.dataSerialize("tb_erp_data");
							data.CRUD = "D";
							return data;
					},
					"if_success" : function(dhtmlXGridObj,gridDataList){
						$erp.dataClear("tb_erp_data");
						use_readonly();
						$erp.confirmMessage({
							"alertMessage" : "퇴사처리 되었습니다."
							, "alertCode" : ""
							, "alertType" : "alert"
							, "alertCallbackFn" : null
						});	
					},
					"if_error" : function(dhtmlXGridObj){
									
					}
				}
				
			},
			
			//저장
			"4" : {
				"func" : function(){
					$('#txtMEMBER_CODE').prop('readOnly',true);
					$('#txtMEMBER_CODE').addClass('input_readonly');
					
					var validation_check = true;
					var message = "";
					var check = function(db_func){
						if(validation_check == true){
							db_func();
						}else {
							$erp.alertMessage({
								"alertMessage" : message
								, "alertCode" : "사용자 저장 실패"
								, "alertType" : "error"
								, "isAjax" : false
							});
						}
					}
					var send_data = $erp.dataSerialize("tb_erp_data");
					
					if( !(CRUD == "C") && !(CRUD == "U")){
						validation_check = false;
						message = "사용자 등록 또는 수정중이 아닙니다";
						return check;
					}
					
					if(send_data.MEMBER_CODE == ""){
						validation_check = false;
						message = "사용자번호 미기입";
						return check;
					}
					if(send_data.MEMBER_NAME == ""){
						validation_check = false;
						message = "사용자이름 미기입";
						return check;
					}
					if(send_data.MEMBER_WAREA == ""){
						validation_check = false;
						message = "사용자지역 미선택";
						return check;
					}
					/* if(send_data.MEMBER_TEAM == ""){
						validation_check = false;
						message = "사용자 팀 미선택";
						return check;
					}
					if(send_data.MEMBER_POSITION == ""){
						validation_check = false;
						message = "사용자직책 미선택";
						return check;
					} */
					
					
					return check;		
				},
				"db_func" : {
					"use_url" : "/common/employee/insertPerfectEmp.do",
					"send_data" : function(){
						var data = $erp.dataSerialize("tb_erp_data");
							data.CRUD = CRUD;
							return data;
					},
					"if_success" : function(dhtmlXGridObj,gridDataList){
						CRUD = "";
						document.getElementById("div_data_info").textContent = '사용자 조회/수정 대기중';
						$erp.dataClear("tb_erp_data");
						use_readonly();
						search_button_click();
					},
					"if_error" : function(dhtmlXGridObj){
									
					}
				}
			}
		};
		
		$erp.initGridAndRibbon(
			layout, //dhtmlx 레이아웃 객체 (전체) progress 용도
			left_layout_grid, //dhtmlx 그리드 객체
			left_layout_grid_properties, //dhtmlx 그리드 속성
			left_layout_ribbon, //dhtmlx 리본 객체
			left_layout_ribbon_item_properties //dhtmlx 리본 item들의 수행 기능 초기화시 필요 속성
		); 
	}
	<%-- ■ 그리드, 리본  기능  초기화 끝 --%>
	
	function search_button_click(){
		left_layout_ribbon.callEvent("onClick", ["search_data"]);
	}

	function use_readonly(){
		$('#txtMEMBER_CODE').prop('readonly', true);
		$('#txtMEMBER_CODE').addClass('input_readonly');
	}
	
	function unuse_readonly(){
		$('input').prop('readonly', false);
		$('input').removeClass('input_readonly');
	}

</script>
</head>
<body>		

	<div id="div_left_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>	
		<div id="div_left_layout_search" class="div_erp_contents_search" style="display:none">
			<table id="tb_search" class="table_search">
				<colgroup>
					<col width="50px"/>
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
		<div id="div_left_layout_ribbon" class="div_ribbon_full_size"></div>
		<div id="div_left_layout_grid" class="div_grid_full_size"></div>
	
	<div id="div_right_layout" class="div_layout_full_size div_sub_layout" style="display:none"></div>
		<div id="div_right_layout_info" class="div_common_contents_full_size" style="display:none">
			<table id="tb_erp_data" class="tb_erp_common">
				<colgroup>
					<col width="200px" />
					<col width="*" />
				</colgroup>
				<tr>
					<td colspan="2" class="td_subject"><div id="div_data_info" class="common_center">사용자 등록/수정 대기중</div></td>
				</tr>

				<tr>
					<td colspan="2" class="td_subject"><div id="div_standardata_info" class="common_center">기본정보</div></td>
				</tr>
				
				<tr>
					<th><span class="span_essential">*</span>사용자번호</th>
					<td>
						<input type="text" id="txtMEMBER_CODE" name="MEMBER_CODE" value="" class="input_readonly" readonly>
					</td>
				</tr>
				<tr>
					<th><span class="span_essential">*</span>이름</th>
					<td>
						<input type="text" id="txtMEMBER_NAME" name="MEMBER_NAME" value="">
					</td>
				</tr>
				
				<tr>
					<th><span class="span_essential">*</span>지역</th>
					<td>
						<div id="cmbMEMBER_WAREA"></div>
					</td>
				</tr>
				<tr>
					<th><span></span>팀명</th>
					<td>
						<div id="cmbMEMBER_TEAM"></div>
					</td>
				</tr>
				<tr>
					<th><span></span>직책</th>
					<td>
						<div id="cmbMEMBER_POSITION"></div>
					</td>
				</tr>
				<tr>
					<th>조</th>
					<td>
						<div id="cmbMEMBER_JO"></div>
					</td>
				</tr>
				<tr>
					<th>내선번호</th>
					<td>
						<input type="text" id="txtMEMBER_INPHONE" name="MEMBER_INPHONE" value="" maxlength="4" >
					</td>
				<tr>
					<th>모바일콜센터</th>
					<td>
						<input type="text" id="txtMEMBER_COMPANYPHONE" name="MEMBER_COMPANYPHONE" value="">
					</td>
				</tr>
				<tr>
					<th rowspan="2">기타정보</th>
					<td>
						<div id="chkMEMBER_CTI"></div>
						<div id="chkMEMBER_DIVISION"></div>
						<div id="chkMEMBER_REORDER"></div>
						<div id="chkMEMBER_MPRICECHK"></div>
					</td>
				</tr>
				<tr>
					
					<td>
						<div id="rdoMEMBER_CONSULT"></div>
					</td>
				</tr>
				<tr>
					<th>직원출고금액</th>
					<td>
						<input type="text" id="txtMEMBER_PRICE" name="MEMBER_PRICE" value="">
					</td>
				</tr>
				<tr>
					<th>선출고 여부</th>
					<td><div id="cmbMEMBER_IS_STOCK"></div></td>	
				</tr>
												<tr>
					<th>단가표사용 유무</th>
					<td><div id="cmbMEMBER_IS_PRICE"></div></td>	
				</tr>


				<tr>
					<td colspan="2" class="td_subject"><div id="div_erp_info" class="common_center">ERP연동정보(영업채널)</div></td>
				</tr>		
				
				<tr>
					<th>고객코드</th>
					<td>
						<input type="text" id="txtMEMBER_ERP_CD" name="MEMBER_ERP_CD" value="">
					</td>
				</tr>				
				<tr>
					<th>고객명</th>
					<td>
						<input type="text" id="txtMEMBER_ERP_NM" name="MEMBER_ERP_NM" value="">
					</td>
				</tr>
				<tr>
					<th>관리구분코드</th>
					<td>
						<input type="text" id="txtMEMBER_ERP_MGMT_CD" name="MEMBER_ERP_MGMT_CD" value="">
					</td>
				</tr>	
				<tr>
					<th>프로젝트코드</th>
					<td>
						<input type="text" id="txtMEMBER_ERP_PJT_CD" name="MEMBER_ERP_PJT_CD" value="">
					</td>
				</tr>				
				<tr>
					<th>납품처코드</th>
					<td>
						<input type="text" id="txtMEMBER_ERP_SHIP_CD" name="MEMBER_ERP_SHIP_CD" value="">
					</td>
				</tr>

				<tr>
					<td colspan="2" class="td_subject"><div id="div_yerp_info" class="common_center">ERP 연동정보(양산공장)</div></td>
				</tr>				
				
				<tr>
					<th>고객코드</th>
					<td>
						<input type="text" id="txtMEMBER_YERP_CD" name="MEMBER_YERP_CD" value="">
					</td>
				</tr>				
				<tr>
					<th>고객명</th>
					<td>
						<input type="text" id="txtMEMBER_YERP_NM" name="MEMBER_YERP_NM" value="">
					</td>
				</tr>
				<tr>
					<th>관리구분코드</th>
					<td>
						<input type="text" id="txtMEMBER_YERP_MGMT_CD" name="MEMBER_YERP_MGMT_CD" value="">
					</td>
				</tr>	
				<tr>
					<th>프로젝트코드</th>
					<td>
						<input type="text" id="txtMEMBER_YERP_PJT_CD" name="MEMBER_YERP_PJT_CD" value="">
					</td>
				</tr>				
				<tr>
					<th>납품처코드</th>
					<td>
						<input type="text" id="txtMEMBER_YERP_SHIP_CD" name="MEMBER_YERP_SHIP_CD" value="">
					</td>
				</tr>

				<tr>
					<td colspan="2" class="td_subject"><div id="div_update_info" class="common_center">수정정보</div></td>
				</tr>	

				<tr>
					<th>수정일</th>
					<td>
						<input type="text" id="txtMOD_DT" name="MOD_DT" class="input_readonly" value="" readonly>
					</td>
				</tr>
				<tr>
					<th>수정자</th>
					<td>
						<input type="text" id="txtMOD_ID" name="MOD_ID" class="input_readonly" value="" readonly>
					</td>
				</tr>
			</table>
		</div>
</body>
</html>