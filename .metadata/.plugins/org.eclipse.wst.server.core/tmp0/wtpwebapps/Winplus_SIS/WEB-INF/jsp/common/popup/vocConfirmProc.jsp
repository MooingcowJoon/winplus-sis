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
		■ erpWindowsCell : Object / 시스템 팝업 윈도우 Cell DhtmlxWindowsCell; 
		■ erpLayout : Object / 페이지 Layout DhtmlxLayout
		
		■ erpSubLayout : Object / 페이지 Layout DhtmlxLayout
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlxRibbon
	--%>
	var erpPopupWindowsCell = parent.erpPopupWindows.window('openVocConfirmProcPopup');
	var erpLayout;
	var erpRibbon;
	var cmbRESULTYNN;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("${screenDto.scrin_nm}");
		}
		
		initErpLayout();
		initErpRibbon();
		initDhtmlXCombo();
		
		cmbRESULTYNN.uncheckItem('cmbRESULTYNN');
		if('${vocContent.CLAIM_COMPLETE}' == '1') cmbRESULTYNN.checkItem('cmbRESULTYNN');
	});
	
	<%--
	**********************************************************************
	* ※ Master 영역
	**********************************************************************
	--%>	
	
	<%-- ■ erpLayout 관련 Function 시작 --%>	
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "해피콜 분배", header:false, fix_size : [false, false]}
				, {id: "b", text: "", header:false, fix_size : [false, false]}
			]		
		});
		
		erpLayout.conf.ofs = {b : 4, l : 4, r : 4, t : 4};
		erpLayout.setAutoSize("a;b;c;d", "c");
		erpLayout.cells("a").attachObject("div_erp_contents");
		erpLayout.cells("b").attachObject("div_erp_ribbon");
		erpLayout.cells("b").hideArrow();
		erpLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);	
		
		erpLayout.setSeparatorSize(0, 0);
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
//			erpGrid.setSizes();
		});

	}
	<%-- ■ erpLayout 관련 Function 끝 --%>	
	
	<%-- ■ erpRibbon 관련 Function 시작 --%>	
	<%-- erpRibbon 초기화 Function --%>	
	function initErpRibbon(){
		erpRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "save_erpGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
				]}							
			]
		});
		
		erpRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	searchErpGrid();
		    } else if (itemId == "add_erpGrid"){
		    	addErpGrid();
		    } else if (itemId == "delete_erpGrid"){
		    	deleteErpGrid();
		    } else if (itemId == "save_erpGrid"){
		    	saveErpGrid();
		    } else if (itemId == "excel_erpGrid"){
	            $erp.exportDhtmlXGridExcel({
	                "grid" : erpGrid
	              , "fileName" : "고객검색조회_내역"
	              , "isForm" : false
	              , "isHiddenPrint" : "Y"
	           });
		    } else if (itemId == "print_erpGrid"){
		    	
		    } else if (itemId == "record_listening"){
		    	recordListening();
		    }
		});
	}
	<%-- ■ erpRibbon 관련 Function 끝 --%>	
	
	
	<%-- ■ erpData 관련 Function 시작 --%>		
	<%-- erpData 승인 유효성 Function --%>		
	function isApplyValidate(){
		var isValidated = true;

		
		return isValidated;
	}
	
	<%-- erpData 저장 Function --%>		
	function saveErpGrid(){
		if(!isApplyValidate()) { return false }

		var callbackFunction = function(){
			
			erpLayout.progressOn();
	
	 		var cmbBusinessInfCd = cmbBUSINESS_INF.getSelectedValue();
	 		var cmbMemberTeamCd = cmbMEMBER_TEAM.getSelectedValue();
	 		var result = cmbRESULTYNN.isItemChecked('cmbRESULTYNN') ? 1 : 0;
	 		var claimCmemo3 = document.getElementById("CLAIM_CMEMO3").value;
	 		var claimCmemo4 = document.getElementById("CLAIM_CMEMO4").value;
	 		var claimCmemo5 = document.getElementById("CLAIM_CMEMO5").value;
	 		var claimcCidx = document.getElementById("CLAIM_CIDX").value;
	 		
			var param = {
				"BUSINESS_INF_CD" : cmbBusinessInfCd
				, "MEMBER_TEAM_CD" : cmbMemberTeamCd.substring(0, 4)
				, "RESULT" : result
				, "CLAIM_CIDX" : claimcCidx
				, "CLAIM_CMEMO3" : claimCmemo3
				, "CLAIM_CMEMO4" : claimCmemo4
				, "CLAIM_CMEMO5" : claimCmemo5			
			}
			
	 		$.ajax({
				url : "/winplus/businessmanagement/business/vocConfirmProcCUD.do"
				,data : param
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						$erp.alertSuccessMesage(onAfterSaveErpGrid);
						//location.reload(true);
						//this.clear();
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}

		$erp.confirmMessage({
			"alertMessage" : '<spring:message code="alert.common.saveData" />'
			, "alertType" : "alert"
			, "alertCallbackFn" : callbackFunction
		});	
	}
	<%-- ■ erpData 관련 Function 끝 --%>		
	
	<%-- ■ DhtmlxCombo 관련 Function 시작 --%>	
	<%-- DhtmlxCombo 조회 Function --%>
	function initDhtmlXCombo(){
		var comCdArr = new Array();
		
		cmbBUSINESS_INF = $erp.getDhtmlXCombo('cmbBUSINESS_INF', 'BUSINESS_INF', 'BUSINESS_INF', 200, null, "${vocContent.TAREA2}", function(){
			cmbBUSINESS_INF.attachEvent("onChange", function(value, text){
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
						
						cmbMEMBER_TEAM.addOption("","모두조회","color:black",null,true);		
						for(var i=0; i < list.length; i++) {
							cmbMEMBER_TEAM.addOption(list[i].CMMN_DETAIL_CD,list[i].CMMN_DETAIL_CD_NM);
						}
						
						cmbMEMBER_TEAM.selectOption(0);
					}
				});
			});
		});	
		cmbBUSINESS_INF.addOption("","모두조회","color:black",null,true);

		//기초데이터 세팅
		comCdArr[0] = 'MEMBER_TEAM';
		comCdArr[1] = '${vocContent.TAREA2}';
		cmbMEMBER_TEAM = $erp.getDhtmlXCombo('cmbMEMBER_TEAM', 'MEMBER_TEAM', comCdArr, 200, null, "${vocContent.TCODE2}##${vocContent.TAREA2}");

		cmbRESULTYNN = $erp.getDhtmlXCheckBox('cmbRESULTYNN', '완료', '1', false, 'label-right');  
	}
	<%-- ■ DhtmlxCombo 관련 Function 끝 --%>	

	<%-- 고객검색 Function 시작 --%>	
	function searchCust(){
		
		erpLayout.progressOn();
		
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var custCode = $('#CUST_CODE').val();
		
		if(custCode.trim() == ""){
			alertMessage = "error.common.noEssentialData";
			alertCode = "-1";
			
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		
			return false;
		}
		
		$.ajax({
			url : "/winplus/businessmanagement/business/custCodeSearchList.do"
			,data : {
				"CUST_CODE" : custCode
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					if($erp.isEmpty(data.dataList)){
						$('#searchCustYN').val('N');						
						$erp.alertMessage({
							"alertMessage" : 'grid.noSearchData'
							, "alertCode" : '-1'
							, "alertType" : 'error'
						});
					} else {
						$('#CUST_NAME').val(data.dataList.CUSTOMER_NAME);
						$('#searchCustYN').val('Y');

						$('#CUSTOMER_THP').val(data.dataList.CUSTOMER_THP);						
						$('#CUSTOMER_TCP').val(data.dataList.CUSTOMER_TCP);
						$('#CUSTOMER_WAREA').val(data.dataList.CUSTOMER_WAREA);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		
	}

	<%-- erpGrid 저장 후 Function --%>
	function onAfterSaveErpGrid(){
		$erp.closePopup();
//		alert('DATA를 처리 하였습니다.');
	}
		
	function recordListening(){
		var url = "http://210.91.80.153/ippbxmng/member/play_record.jsp?uniqueid=" + '${vocContent.CLAIM_CUNIQUE}';
		//var url = "http://210.223.33.14/ippbxmng/member/play_record.jsp?uniqueid=" + '${vocContent.CLAIM_CUNIQUE}';
		
		var name = "recordListening";
		var windowoption = 'location=0, directories=0,resizable=0,status=0,toolbar=0,menubar=0, width=280px,height=150px,left=0, top=0,scrollbars=0';
		window.open(url, name, windowoption);		
	}
	<%-- 고객검색 Function 끝 --%>	
</script>
</head>
<body>
<div id="div_erp_contents" class="div_common_contents_full_size" style="display:none">
	<table id="tb_contents" class="tb_erp_common" style="margin-top:0px">
		
		<colgroup>
			<col width="100px" />
			<col width="*" />
			<col width="100px" />
			<col width="*" />
		</colgroup>
			<tr>
				<td colspan="4">
					<input type="hidden" id="CLAIM_CIDX" name="CLAIM_CIDX" value="${vocContent.CLAIM_CIDX}">
					<textarea rows="10" id="CLAIM_CMEMO1" name="CLAIM_CMEMO1" class="input_common" style="width:99%;" readonly>${vocContent.CLAIM_CMEMO1}</textarea>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<textarea rows="6" id="CLAIM_CMEMO2" name="CLAIM_CMEMO2" class="input_common" style="width:99%;" readonly>${vocContent.CLAIM_CMEMO2}</textarea>
				</td>
			</tr>
			<tr>
				<th>고객코드</th>
				<td><input type="text" id="searchPrdcNm" name="searchPrdcNm" class="input_common" maxlength="50" style="width:97%;" value="${vocContent.CUSTOMER_CODE}" readonly></td>
				<th>고객명</th>
				<td><input type="text" id="searchPrdcNm" name="searchPrdcNm" class="input_common" maxlength="50" style="width:97%;" value="${vocContent.CUSTOMER_NAME}" readonly></td>				
			</tr>
			<tr>
				<th>이관지역</th>
				<td><div id="cmbBUSINESS_INF"></div></td>
				<th>이관팀명</th>
				<td><div id='cmbMEMBER_TEAM'></div></td>				
			</tr>
			<tr>
				<td colspan="4">
					<textarea rows="5" id="CLAIM_CMEMO3" name="CLAIM_CMEMO3" class="input_common" style="width:99%;background-color:#C0FFFF;border:#C0FFFF 1px solid">${vocContent.CLAIM_CMEMO3}</textarea>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<textarea rows="5" id="CLAIM_CMEMO4" name="CLAIM_CMEMO4" class="input_common" style="width:99%;background-color:#C0FFFF;border:#C0FFFF 1px solid">${vocContent.CLAIM_CMEMO4}</textarea>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<textarea rows="5" id="CLAIM_CMEMO5" name="CLAIM_CMEMO5" class="input_common" style="width:99%;background-color:#C0FFFF;border:#C0FFFF 1px solid">${vocContent.CLAIM_CMEMO5}</textarea>
				</td>
			</tr>		
			<tr>
				<td colspan="4"><div id="cmbRESULTYNN"></div>
					<c:if test="${vocContent.CLAIM_CUNIQUE != null && vocContent.CLAIM_CUNIQUE != ''}">
						<div><input type="button" class="input_common_button" value="녹취듣기" onclick="recordListening();"></div>
					</c:if>					
				</td>
			</tr>	
	</table>
</div>
<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
</body>
</html>