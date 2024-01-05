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
		■ erpPopupWindowsCell : Object / 시스템 팝업 윈도우 Cell DhtmlxWindowsCell; 
		■ erpPopupLayout : Object / 페이지 Layout DhtmlxLayout
		■ erpPopupRibbon : Object / 리본형 버튼 목록 DhtmlxRibbon
		■ erpPopupGrid : Object / 표준분류코드 조회 DhtmlxGrid
		■ erpPopupGridColumns : Array / 표준분류코드 DhtmlxGrid Header		
		■ erpPopupGridOnRowDblClicked : Object (Function) / erpPopupGrid 더블 클릭시 실행될 Function
	--%>
	var erpPopupWindowsCell = parent.erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
	
	var erpPopupLayout;
	var erpPopupRibbon;
	var erpPopupGrid;
	var erpPopupGridColumns;	
	var stplat_cd = '${STPLAT_CD}';
	var stplat_nm = '${STPLAT_NM}';
	var cmbPUCHAS_DIV_CD;
	
	var erpPopupVault;
	var erpPopupVaultUploadUrl;
	var erpPopupVaultFnOnUploadFile;
	var erpPopupVaultFnOnUploadComplete;
	var erpPopupVaultFnOnFileAdd;
	var erpPopupVaultFnOnBeforeClear;



	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("${screenDto.scrin_nm}");	
		}
		//initBindParameter();
		initErpPopupLayout();
		initErpPopupRibbon();
		initDhtmlXCombo();
		initVault();
	});

	
	function initDhtmlXCombo(){
		 cmbPUCHAS_DIV_CD = $erp.getDhtmlXCombo('cmbPUCHAS_DIV_CD', 'cmbPUCHAS_DIV_CD', 'PUCHAS_DIV_CD', 120, false);
		 cmbPUCHAS_DIV_CD.attachEvent("onChange", function(value, text){
			 $('#txtENTRST_DATE_FR').val("");
			 if(value=='Y'){
				 //  $('#txtENTRST_DATE_FR').css("display","inline-block");
				   $('#txtENTRST_DATE_FR').attr("disabled", false);
				   $('#imgCalENTRST_DATE_FR').css("display","inline-block");
			   }
			   else{
				 //  $('#txtENTRST_DATE_FR').css("display","none");
				   $('#txtENTRST_DATE_FR').attr("disabled", true);
				   $('#imgCalENTRST_DATE_FR').css("display","none");
				   
			   }
			});
	}
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>	
	<%-- erpPopupLayout 초기화 Function --%>	
	function initErpPopupLayout(){
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "2E"
			, cells: [
				{id: "a", text: "${screenDto.scrin_nm}", header:false, fix_size : [false, true]}
				, {id: "b", text: "", header:false, fix_size : [false, true]}
			]		
		});
		
		erpPopupLayout.conf.ofs = {b : 4, l : 4, r : 4, t : 4};		
		
		erpPopupLayout.cells("a").attachObject("div_erp_popup_ribbon");
		erpPopupLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupLayout.cells("b").attachObject("div_erp_event");
		
		erpPopupLayout.setSeparatorSize(1, 0);
		erpPopupLayout.setSizes();
		
		<%-- erpLayout 사이즈 변경 시 Event --%>
		$erp.setEventResizeDhtmlXLayout(erpPopupLayout, function(names){
			erpPopupGrid.setSizes();
		});
	}
	<%-- ■ erpPopupLayout 관련 Function 끝 --%>	
	
	<%-- ■ erpPopupLayout 관련 Function 시작 --%>	
	<%-- erpPopupLayout 초기화 Function --%>	
	function initErpPopupRibbon(){
		erpPopupRibbon = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
						{id : "search_erpPopupGrid", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}									
				]}							
			]
		});
		
		erpPopupRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpPopupGrid"){
		    	saveErpPopupGrid();
		    }
		});
	}
	
	<%-- erpPopupGrid 조회 유효성 검사 Function --%>
	function isSearchValidate(){
		var isValidated = true;		
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		//var goods_nm = document.getElementById("txtBIND_GOODS_NM").value;
		
		if($erp.isLengthOver(bind_goods_nm, 200)){
			isValidated = false;
			alertMessage = "error.common.system.common.goods_nm.length200Over";
			alertCode = "-1";
		} 		
		
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
			});
		}
		
		return isValidated;
	}
	
	<%-- erpPopupGrid 조회 Function --%>
	function saveErpPopupGrid(){
		var callbackFunction = function(){
			erpPopupLayout.progressOn();
			$erp.uploadTool(erpPopupVault);
			erpPopupLayout.progressOff();
		}
		if(isSaveDataValidate()){
			$erp.confirmMessage({
				"alertMessage" : '<spring:message code="alert.common.saveData" />'
				, "alertType" : "alert"
				, "alertCallbackFn" : callbackFunction
			});
		}
		else{
			
		}
		
	}
	
	function isSaveDataValidate(){
		var isValidated = true;
		var infoMessage = '<spring:message code="info.common.essentialItem" />';		
		var alertMessage = "error.common.noEssentialData";
		var alertCode = "";
		var alertType = "error";
		var alertCallbackFn;
		var alertCallbackFnParam;
		if(isValidated){			
			$("#tb_erp_event").each(function(i, obj){
				//console.log(obj);
				var resultObj = $erp.getElementEssentialEmpty(obj);
				if(resultObj){
					alertCallbackFnParam = {"obj" : resultObj, "message" : infoMessage};
					alertCallbackFn = function(param){
						$erp.initDhtmlXPopupDom(param.obj, param.message);
					}				
					isValidated = false;
					alertCode = "-2";					
					return false;
				}
			});
			if(isValidated){
				
			}
		}
		if(!isValidated){
			$erp.alertMessage({
				"alertMessage" : alertMessage
				, "alertCode" : alertCode
				, "alertType" : alertType
				, "alertCallbackFn" : alertCallbackFn
				, "alertCallbackFnParam" : alertCallbackFnParam
			});
		}
		
		return isValidated;
	}
	function initVault(){
		//var params = $erp.serializeDhtmlXGridHeader(dhtmlXGridColumnsMapArray);
		var params = {GUBN:"1"};
		var vaultUrl = "/common/insertPuchaseDivCdPopupCUD1.do";
/* 		if(erpPopupVaultUploadUrl){
			vaultUrl = erpPopupVaultUploadUrl;
		} */
	
		erpPopupVault=$erp.getDhtmlXVault('erpPopupVault', vaultUrl, 1, params,'upload');
		//업로드 성공 이벤트
		if(erpPopupVaultFnOnUploadFile && typeof erpPopupVaultFnOnUploadFile === 'function'){
			erpPopupVault.attachEvent("onUploadFile", erpPopupVaultFnOnUploadFile);
		}
		
		if(erpPopupVaultFnOnUploadComplete && typeof erpPopupVaultFnOnUploadComplete === 'function'){
			erpPopupVault.attachEvent("onUploadComplete", erpPopupVaultFnOnUploadComplete);
		}
		
		if(erpPopupVaultFnOnFileAdd && typeof erpPopupVaultFnOnFileAdd === 'function'){
			erpPopupVault.attachEvent("onBeforeFileAdd", erpPopupVaultFnOnFileAdd);
		}
		
		if(erpPopupVaultFnOnBeforeClear && typeof erpPopupVaultFnOnBeforeClear === 'function'){
			erpPopupVault.attachEvent("onBeforeClear", erpPopupVaultFnOnBeforeClear);
		}
	} 
	<%-- ■ erpPopupGrid 관련 Function 끝 --%>		
</script>
</head>
<body>
<div id="div_erp_event" class="div_common_contents_full_size">
		<table id="tb_erp_event" class="tb_erp_common">
			<colgroup>
				<col width="90px" />
				<col width="200px" />
				<col width="90px" />
				<col width="*" />
			</colgroup>
				<tr>
					<td colspan="6" class="td_subject"><div class='div_subject'>▣ 매입구분 정보</div></td>
				</tr>
				<tr>
					<th><span class='span_essential'>*</span>매입구분</th>
					<td>
						<div id="cmbPUCHAS_DIV_CD"></div>						
					</td>
				
					<th>매입일자</th>
					<td>
						<input type="text" id="txtENTRST_DATE_FR" name="BASE_DATE_FR" class="input_common input_calendar">
					</td>
					
				</tr>
				
				<tr>
					<th><span class='span_essential'>*</span>주문번호파일</th>
					<td colspan="3">
						<div id="erpPopupVault" style="width:670px;height: 200px;" class='vault_essential'></div>
					</td>
				</tr>
				<tr>
					<th>매입거절사유</th>
					<td colspan="3">
						<textarea class="textarea_common " id='txtCNSLR_CANCEL_RESN'></textarea>
					</td>
				</tr>
		</table>
</div>
<div id="div_erp_popup_ribbon" class="div_ribbon_full_size" style="display:none"></div>

</body>
</html>