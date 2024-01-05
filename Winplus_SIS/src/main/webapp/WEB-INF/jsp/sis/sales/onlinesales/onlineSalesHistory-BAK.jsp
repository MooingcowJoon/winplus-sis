<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header_override.jsp"/>
<script type="text/javascript">
	
	var total_layout;
	var top_layout;
	var mid_layout;
	var ribbon;
	var erp_Grid;
	var ORDER_TYPE
	
	$(document).ready(function() {
		init_total_layout();
		init_top_layout();
		init_mid_layout();
		init_bot_layout();
	});
	
	function init_total_layout() {
		total_layout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern : "3E"
			, cells : [
				{id: "a", text: "검색 조건", header: false, fix_size : [true, true]}
				,{id: "b", text: "버튼 목록", header: false, fix_size:[true,true]}
				,{id: "c", text: "예비 바코드 그리드", header: false, fix_size:[true,true]}
			]
		});
		total_layout.cells("a").attachObject("div_top_layout");
		total_layout.cells("a").setHeight(55);
		total_layout.cells("b").attachObject("div_mid_layout");
		total_layout.cells("b").setHeight(40);
		total_layout.cells("c").attachObject("div_bot_layout");
		
		total_layout.setSeparatorSize(0, 1);
		total_layout.setSeparatorSize(1, 1);
	}
	
	function init_top_layout(){
		chkMONTH = $erp.getDhtmlXCheckBox('chkMONTH', '월단위', '1', false, 'label-left');
		chkMONTH.attachEvent("onChange",function(name, value, checked){
			if(checked){
				$erp.objReadonly(["txtDATE_FR","txtDATE_TO"]);
				$erp.objNotReadonly(["txtMONTH_FR","txtMONTH_TO"]);
				chkDATE.uncheckItem("chkDATE");
			}else{
				$erp.objReadonly(["txtMONTH_FR","txtMONTH_TO"]);
				$erp.objNotReadonly(["txtDATE_FR","txtDATE_TO"]);
				chkDATE.checkItem("chkDATE");
			}
		});
		chkDATE = $erp.getDhtmlXCheckBox('chkDATE', '일단위', '1', false, 'label-left');
		chkDATE.attachEvent("onChange",function(name, value, checked){
			if(checked){
				$erp.objReadonly(["txtMONTH_FR","txtMONTH_TO"]);
				$erp.objNotReadonly(["txtDATE_FR","txtDATE_TO"]);
				chkMONTH.uncheckItem("chkMONTH");
			}else{
				$erp.objReadonly(["txtDATE_FR","txtDATE_TO"]);
				$erp.objNotReadonly(["txtMONTH_FR","txtMONTH_TO"]);
				chkMONTH.checkItem("chkMONTH");
			}
		});
		
		//chkORDER_TYPE = $erp.getDhtmlXCheckBox('chkORDER_TYPE', '거래처', '1', false, 'label-left');
		
		//강제클릭이벤트 발생시켜 체크하기
		chkMONTH.items.checkbox.doClick(chkMONTH._getItemByName("chkMONTH"));
		
		cmbORDER_TYPE = $erp.getDhtmlXComboCommonCode("cmbORDER_TYPE","cmbORDER_TYPE", ["ORDER_TYPE"],110, false, false);
		cmbORDER_TYPE.attachEvent("onChange", function(value, text){
			if(value != "B2B"){
				document.getElementById("div_bot_layout_B2C").style.display = "block";
				document.getElementById("div_bot_layout_B2B").style.display = "none";
			} else {
				document.getElementById("div_bot_layout_B2C").style.display = "none";
				document.getElementById("div_bot_layout_B2B").style.display = "block";
			}
		});
		cmbWMS_STATE = $erp.getDhtmlXComboCommonCode("cmbWMS_STATE","cmbWMS_STATE", ["WMS_STATE"],110, false, false);
		cmbPUR_CONF_STATE = $erp.getDhtmlXComboCommonCode("cmbPUR_CONF_STATE","cmbPUR_CONF_STATE", ["PUR_CONF_STATE"],110, false, false);
		
		cmbGROUPBY = new dhtmlXCombo("cmbGROUPBY")
		cmbGROUPBY.readonly(true);
		cmbGROUPBY.addOption([
			{value: "SALE_DATE", text: "일자별", selected: true, readonly: true}
			,{value: "GOODS_NM", text: "상품별", readonly: true}
			,{value: "ORDER_TYPE", text: "거래처별", readonly: true}
			//,{value: "3", text: "네번째별"}
		]);

		
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
			        		            {id : "search_grid",	type : "button", text:'<spring:message code="ribbon.search" />', 	isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
// 			        		            , {id : "add_grid", 	type : "button", text:'<spring:message code="ribbon.add" />', 		isbig : false, img : "menu/add.gif", 	imgdis : "menu/add_dis.gif", 	disable : true}
// 			        		            , {id : "delete_grid",	type : "button", text:'<spring:message code="ribbon.delete" />', 	isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
// 			        		            , {id : "save_grid", 	type : "button", text:'<spring:message code="ribbon.save" />', 		isbig : false, img : "menu/save.gif", 	imgdis : "menu/save_dis.gif", 	disable : true}
			        		            , {id : "excel_grid", 	type : "button", text:'<spring:message code="ribbon.excel" />', 	isbig : false, img : "menu/excel.gif", 	imgdis : "menu/excel_dis.gif", 	disable : true, unused : false}
//			        		            , {id : "print_grid", 	type : "button", text:'<spring:message code="ribbon.print" />', 	isbig : false, img : "menu/print.gif", 	imgdis : "menu/print_dis.gif", 	disable : true}		
			        		            , {id : "excelForm_grid", type : "button", text:'<spring:message code="ribbon.excelForm" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : false}
										, {id : "excel_grid_upload", type : "button", text:'<spring:message code="ribbon.upload" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true, unused : false}
			        		             ]
							}
				           ]
		});
		ribbon.attachEvent("onClick", function(itemId, bId){
			if(itemId == "search_grid"){
				ORDER_TYPE = cmbORDER_TYPE.getSelectedValue();
				if(ORDER_TYPE != "B2B"){
					searchErpGrid(bot_layout_grid_B2C);
				} else
					searchErpGrid(bot_layout_grid_B2B);
			} else if (itemId == "add_grid"){
					
			} else if (itemId == "delete_grid"){
				
			} else if (itemId == "save_grid"){
				
			} else if (itemId == "excel_grid"){
				ORDER_TYPE = cmbORDER_TYPE.getSelectedValue();
				if(ORDER_TYPE != "B2B"){
					$erp.exportGridToExcel({
						"grid" : bot_layout_grid_B2C
						, "fileName" : "B2C_온라인주문 업로드용"
						, "isOnlyEssentialColumn" : false
						, "excludeColumnIdList" : ['NO','ORDER_TYPE','OUT_WARE_CD','CUSTMR_CD','ORD_CENT_CD','SEND_YN','SALE_VAT','PRINT_YN','PUR_CONF_YN']
						, "isIncludeHidden" : true
						, "isExcludeGridData" : true
					});
				} else
					$erp.exportGridToExcel({
						"grid" : bot_layout_grid_B2B
						, "fileName" : "B2B_온라인주문 업로드용"
						, "isOnlyEssentialColumn" : false
						, "excludeColumnIdList" : ['NO','ORDER_TYPE','OUT_WARE_CD','CUSTMR_CD','ORD_CD','ORD_NO','GOODS_NO','GOODS_NM','DELI_NO','DELI_MEMO','ORD_CENT_CD','SEND_YN','PRINT_YN','PUR_CONF_YN']
						, "isIncludeHidden" : true
						, "isExcludeGridData" : true
					});
			} else if (itemId == "excelForm_grid"){
				ORDER_TYPE = cmbORDER_TYPE.getSelectedValue();
				if(ORDER_TYPE != "B2B"){
					$erp.exportGridToExcel({
						"grid" : bot_layout_grid_B2C
						, "fileName" : "B2C_온라인주문 업로드용"
						, "isOnlyEssentialColumn" : false
						, "excludeColumnIdList" : ['NO','ORDER_TYPE','OUT_WARE_CD','CUSTMR_CD','ORD_CENT_CD','SEND_YN','SALE_VAT','PRINT_YN','PUR_CONF_YN']
						, "isIncludeHidden" : true
						, "isExcludeGridData" : true
					});
				} else
					$erp.exportGridToExcel({
						"grid" : bot_layout_grid_B2B
						, "fileName" : "B2B_온라인주문 업로드용"
						, "isOnlyEssentialColumn" : false
						, "excludeColumnIdList" : ['NO','ORDER_TYPE','OUT_WARE_CD','CUSTMR_CD','ORD_CD','ORD_NO','GOODS_NO','GOODS_NM','DELI_NO','DELI_MEMO','ORD_CENT_CD','SEND_YN','PRINT_YN','PUR_CONF_YN']
						, "isIncludeHidden" : true
						, "isExcludeGridData" : true
					});
			} else if (itemId == "excel_grid_upload"){
				var convertModuleUrl = ""; //엑셀로 컨버트 하는 모듈을 다른것을 사용하고자 할때만 사용
		    	var uploadFileLimitCount = 1; //파일 업로드 개수 제한
		    	var onUploadFile = function(files, uploadData, toGrid){
					$erp.uploadDataParse(this, files, uploadData, toGrid, "ORD_CD", "add", [], ["ORD_CD"]);
				}
		    	var onUploadComplete = function(uploadedFileInfoList, toGrid, result){
		    		//loadSales(result);
		    	}
		    	var onBeforeFileAdd = function(file){};
		    	var onBeforeClear = function(){};
		    	ORDER_TYPE = cmbORDER_TYPE.getSelectedValue();
				if(ORDER_TYPE != "B2B"){
					$erp.excelUploadPopup(bot_layout_grid_B2C, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
				} else
					$erp.excelUploadPopup(bot_layout_grid_B2B, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
			} else if (itemId == "print_grid"){
				
			}
		});
	}
	function searchErpGrid(dhtmlXGridObj) {
		var dataObj = $erp.dataSerialize("tb_search");
		var url = "/sis/sales/onlinesales/getOSHistoryList.do";
		var send_data = $erp.unionObjArray([null,dataObj]);
		var if_success = function(data){
			$erp.clearDhtmlXGrid(dhtmlXGridObj); //기존데이터 삭제
			if($erp.isEmpty(data.gridDataList)){
				//검색 결과 없음
				$erp.addDhtmlXGridNoDataPrintRow(dhtmlXGridObj, '<spring:message code="info.common.noDataSearch" />');
			}else{
				
				dhtmlXGridObj.parse(data.gridDataList,'js');
				gridGroupBy(dhtmlXGridObj);
				$erp.setDhtmlXGridFooterRowCount(dhtmlXGridObj);
			}
		}	
		var if_error = function(){
			
		}
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
	}
	
	function init_bot_layout() {
		erpGrid = {};
		//,"#text_filter" ,"#rspan"
		//type : cntr, ra, ro, ron, robp, ed, edn, chn, combo, dhxCalendarA
		grid_Columns_B2C = [
							{id : "NO", label:["순번"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
							, {id : "SALE_DATE", label:["일자"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "RESV_DATE", label:["납기예정일자"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "OUT_WARE_CD", label:["출하창고"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, commonCode : ["ORGN_CD","CT"]}
							
							, {id : "ORDER_TYPE", label:["주문유형"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "SHIPPER_NM", label:["수령자"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "SHIPPER_ZIP_NO", label:["수령자우편번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "SHIPPER_ADDR", label:["수령자주소"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "SHIPPER_TEL", label:["수령자전화번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "SHIPPER_PHONE", label:["수령자휴대폰번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "GOODS_NM", label:["상품명"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "ORD_QTY", label:["주문수량"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "SC_S_QTY", label:["운임_소"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : true}
							, {id : "SC_M_QTY", label:["운임_중"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : true}
							, {id : "SC_L_QTY", label:["운임_대"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : true}
							, {id : "DELI_PAY_TYPE", label:["선착불유형"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "DELI_MEMO", label:["배송요청메모"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "DELI_NO", label:["배송번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "ORD_CD", label:["주문고유코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "CUSTMR_CD", label:["주문처코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : true}
							, {id : "CUSTMR_NM", label:["주문처명"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}							
		//					, {id : "GOODS_NO", label:["상품번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : true}
							, {id : "BCD_CD", label:["바코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "SALE_PRICE", label:["판매가(단가)"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
		//					, {id : "SALE_VAT", label:["부가세"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "SALE_TOT_PRICE", label:["판매가총액"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
							, {id : "DELI_PRICE", label:["배송비"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "DELI_PRICE_TYPE", label:["배송구분"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "ORD_NO", label:["주문번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "BUY_NM", label:["구매자"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "BUY_TEL", label:["구매자전화번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "BUY_PHONE", label:["구매자휴대폰번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "PAY_DATE", label:["결제일시"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : true}
													
							, {id : "ORD_CENT_CD", label:["납품주문코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "ORD_ONLINE_CD", label:["납품온라인코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "WMS_STATE", label:["WMS상태유형"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "PRINT_YN", label:["출력여부"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
							, {id : "PUR_CONF_STATE", label:["구매확정유형"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		                    ];
		
		bot_layout_grid_B2C = new dhtmlXGridObject({
			parent: "div_bot_layout_B2C"			
				, skin : ERP_GRID_CURRENT_SKINS
				, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
				, columns : grid_Columns_B2C
		});
		$erp.initGrid(bot_layout_grid_B2C,{multiSelect : true});
		
		erpGrid["div_bot_layout_B2C"] = bot_layout_grid_B2C;
		
		document.getElementById("div_bot_layout_B2C").style.display = "block";
		
		//groupBy
		bot_layout_grid_B2C.attachEvent("onPageChangeCompleted", function(){
			bot_layout.progressOn();
			setTimeout(function(){
				gridGroupBy(bot_layout_grid_B2C);
				bot_layout.progressOff();
			}, 10);
		});
		
		//쿠팡팡 판매내역 Grid
		grid_Columns_B2B = [
			{id : "NO", label:["순번"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			
			, {id : "SALE_DATE", label:["일자"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "RESV_DATE", label:["납기예정일자"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "OUT_WARE_CD", label:["출하창고코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "OUT_WARE", label:["출하창고"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			
			, {id : "ORDER_TYPE", label:["주문유형"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "CUSTMR_CD", label:["주문처코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : true}
			, {id : "CUSTMR_NM", label:["주문처명"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "ORD_CD", label:["주문고유코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "ORD_NO", label:["주문번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "BCD_CD", label:["바코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "GOODS_NO", label:["상품번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : true, isEssential : true}
			, {id : "GOODS_NM", label:["상품명"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "SHIPPER_ADDR", label:["수령지"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "DELI_YN", label:["택배구분"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "SHIPPER_NM", label:["수령자"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "SHIPPER_ZIP_NO", label:["수령자우편번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "SHIPPER_TEL", label:["수령자전화번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "SHIPPER_PHONE", label:["수령자휴대폰번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "SALE_PRICE", label:["판매가(단가)"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "SALE_VAT", label:["부가세"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "SALE_TOT_PRICE", label:["판매가총액"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
			, {id : "ORD_QTY", label:["발주수량"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "3333", label:["!@발주번호(없음)@#"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true, numberFormat : "0,000"}
			
			, {id : "DELI_NO", label:["배송번호"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "DELI_MEMO", label:["배송요청메모"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "ORD_CENT_CD", label:["납품주문코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "ORD_ONLINE_CD", label:["납품온라인코드"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "WMS_STATE", label:["WMS상태유형"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "PRINT_YN", label:["출력여부"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
			, {id : "PUR_CONF_STATE", label:["구매확정유형"], type : "ro", width : "100", sort : "str", align : "center", isHidden : false, isEssential : true}
		];
		
		bot_layout_grid_B2B = new dhtmlXGridObject({
			parent: "div_bot_layout_B2B"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : grid_Columns_B2B
		});
		
		bot_layout_grid_B2B.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(bot_layout_grid_B2B);
		$erp.initGridComboCell(bot_layout_grid_B2B);
		$erp.attachDhtmlXGridFooterPaging(bot_layout_grid_B2B, 10);
		$erp.attachDhtmlXGridFooterRowCount(bot_layout_grid_B2B, '<spring:message code="grid.allRowCount" />');
		
		erpGridDataProcessor = new dataProcessor();
		erpGridDataProcessor.init(bot_layout_grid_B2B);
		erpGridDataProcessor.setUpdateMode("off"); //변경되는 값을 서버에 실시간으로 전송하지 않겠다.
		$erp.initGridDataColumns(bot_layout_grid_B2B);
		
		erpGrid["div_bot_layout_B2B"] = bot_layout_grid_B2B;
		
		//groupBy
		bot_layout_grid_B2B.attachEvent("onPageChangeCompleted", function(){
			bot_layout.progressOn();
			setTimeout(function(){
				gridGroupBy(bot_layout_grid_B2B);
				bot_layout.progressOff();
			}, 10);
		});
	}
	function gridGroupBy(dhtmlXGridObj){
		dhtmlXGridObj.groupBy(dhtmlXGridObj.getColIndexById(cmbGROUPBY.getSelectedValue()),["#title","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan","#cspan"]);
	}																			//["#title","#cspan","","#cspan","","","#stat_total"]
</script>
</head>
<body>
	<div id="div_top_layout" class="samyang_div" style="display:none">
		<div id="div_top_layout_search" class="samyang_div">
			<table id="tb_search" class="table">
				<colgroup>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="140px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="*"/>
				</colgroup>
				<tr>
					<th colspan="1"><div id="chkMONTH" style="float:right;"></div></th>
					<td colspan="2">
						<input type="text" id="txtMONTH_FR" class="input_calendar_ym default_date" data-position="" value="" style="float:left;">
						<span style="float:left; margin-left: 4px;">~</span>
						<input type="text" id="txtMONTH_TO" class="input_calendar_ym default_date" data-position="" value="" style="float:left; margin-left: 6px;">
					</td>
					<th colspan="1">온라인 주문 판매 상태</th>
					<td colspan="1"><div id="cmbPUR_CONF_STATE"></div></td>
					<th colspan="1">거래처</th>
					<td colspan="1"><div id="cmbORDER_TYPE"></div></td>
				</tr>
				<tr>
					<th colspan="1"><div id="chkDATE" style="float:right;"></div></th>
					<td colspan="2">
						<input type="text" id="txtDATE_FR" class="input_calendar default_date" data-position="-7" value="" style="float:left;">
						<span style="float:left; margin-left: 4px;">~</span>
						<input type="text" id="txtDATE_TO" class="input_calendar default_date" data-position="" value="" style="float:left; margin-left: 6px;">
					</td>
					<th colspan="1">WMS 전송 상태</th>
					<td colspan="1"><div id="cmbWMS_STATE"></div></td>
					<th colspan="1">정렬방식</th>
					<td colspan="1"><div id="cmbGROUPBY"></div></td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="div_mid_layout" class="div_ribbon_full_size" style="display:none"></div>
	
	<div id="div_bot_layout" class="div_grid_full_size" style="display:none">
		<div id="div_bot_layout_B2C" class="div_grid_full_size" style="display:none"></div>
		<div id="div_bot_layout_B2B" class="div_grid_full_size" style="display:none"></div>	
	</div>
	
</body>
</html>