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
	<%--
		※ 전역 변수 선언부 (발주및 주문서 팝업 상세조회)
		□ 변수명 : Type / Description
		■ erpRightLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpRightGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbIN_WARE_CD : Object / 입고창고 DhtmlXCombo  (CODE : WARE_CD )
		■ cmbORD_STATE : Object / 발주진행상태  (CODE : ORD_STATE ) 		 
	--%>
	var thisPopupWindow = parent.erpPopupWindows.window('openOrderSearchGridPopup');
	
	var erpRightLayout;
	var erpRightRibbon;	
	var erpRightGrid;
	var erpRightGridColumns;
	var erpRightGridDataProcessor;	
	var cmbIN_WARE_CD;                   /* 입고창고           */
	var cmbORD_STATE;                    /* 발주진행상태       */
	var erpRightGridSelectedCustmr_cd;   /* 그리드 rowSelected */

	var today = $erp.getToday("");

	var param_ORGN_DIV_CD  = "";
	var param_ORGN_CD      = "";
	var param_ORD_NO       = "";
	var param_ORD_TYPE     = "";         /* ORD_TYPE : 1:발주, 2:주문 */

	$(document).ready(function(){		
		if(thisPopupWindow){
			thisPopupWindow.setText("${screenDto.scrin_nm}");	
			//thisPopupWindow.denyResize();
			//thisPopupWindow.denyMove();
		}
		
		param_ORGN_DIV_CD = "${param.ORGN_DIV_CD}"
		param_ORGN_CD     = "${param.ORGN_CD}"
		param_ORD_NO      = "${param.ORD_NO}"
	    param_ORD_TYPE    = "${param.ORD_TYPE}"

		initerpRightLayout();
		initErpRightRibbon();
		
		initErpGrid();
		initDhtmlXCombo();
		erpRightLayout.progressOn();
		
		document.getElementById("txtORD_DATE").value=today;
		
        $('input').prop('readonly', true);
        
		$erp.asyncObjAllOnCreated(function(){
			search_ErpRightGrid();
		});

	});
	
	
	/****************************************************************************/
    /* 1-3.erpRightLayout 초기화                                                */
    /****************************************************************************/	
	function initerpRightLayout(){
		erpRightLayout = new dhtmlXLayoutObject({
			 parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				  {id: "a", text: "발주서", header:true, height:90}
				, {id: "b", text: "", header:false, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		
		erpRightLayout.cells("a").attachObject("div_erp_contents_search");
		erpRightLayout.cells("b").attachObject("div_erp_ribbon");
		erpRightLayout.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpRightLayout.cells("c").attachObject("div_erp_grid");
		
		erpRightLayout.setSeparatorSize(1, 0);
				
	}

	/****************************************************************************/
    /* erpRightRibbon 초기화                                                         */
    /****************************************************************************/	
	function initErpRightRibbon(){
		erpRightRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					  //{id : "search_erpGrid", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
					  {id : "excel_erpGri2",  type : "button", text:'화면닫기',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
				]}							
			]
		});
		
		erpRightRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_erpGrid"){
		    	search_ErpRightGrid();
		    } else if(itemId == "excel_erpGri2"){
		    	thisOnComplete(); // 화면닫기
		    } 
		});
	}
	
	/****************************************************************************/
    /* erpRightGrid 초기화                                                      */
    /****************************************************************************/	
	function initErpGrid(){
		erpRightGridColumns = [
			      {id : "NO"               , label:["NO"                , "#rspan"]      , type: "cntr", width:  "30", sort : "int", align : "center", isHidden : false, isEssential : false}
				//, {id : "CHECK"            , label:["#master_checkbox"  , "#rspan"]      , type: "ch"  , width:  "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
                /* 실제화면에 뿌려지는 부분 */
				, {id : "GOODS_CD"         , label:["상품코드"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "BCD_CD"           , label:["바고드(자)"        , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "BCD_NM"           , label:["상품명"            , "#text_filter"], type: "ro"  , width: "250", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "DIMEN_NM"         , label:["규격"              , "#text_filter"], type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "DSCD_TYPE"        , label:["반품가능"          , "#text_filter"], type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "RETN_YN"          , label:["반품"              , "#text_filter"], type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : true , isEssential : true}			
				, {id : "BOX_QTY"          , label:["BOX수량"           , "#text_filter"], type: "ron" , width:  "60", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}		
				, {id : "ORD_QTY"          , label:["수량"              , "#text_filter"], type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "PUR_PRICE"        , label:["단가"              , "#text_filter"], type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}			
				, {id : "SUPR_AMT"         , label:["공급가액"          , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT"              , label:["부가세"            , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "SUM_AMT"          , label:["합계금액"          , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "REMK"             , label:["적요"              , "#text_filter"], type: "ro"  , width: "270", sort : "str", align : "right",  isHidden : false, isEssential : false}

				, {id : "ORGN_DIV_CD"      , label:["조직영역코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_CD"          , label:["조직코드"          , "#text_filter"], type: "ro"  , width: "200", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_NO"           , label:["발주번호"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "OUT_WARE_CD"      , label:["출고창고코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "IN_WARE_CD"       , label:["입고창고코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "IN_WARE_NM"       , label:["입고창고"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "SUPR_CD"          , label:["협력사코드"        , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "SUPR_NM"          , label:["협력사명"          , "#text_filter"], type: "ro"  , width: "160", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "PROJ_CD"          , label:["프로젝트코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "PROJ_NM"          , label:["프로젝트명"        , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "UNIT_CD"          , label:["단위"              , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "DIMEN_WGT"        , label:["중량"              , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}

				, {id : "ORD_TITLE"        , label:["제목"              , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "MEMO"             , label:["메모"              , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "RESN_CD"          , label:["반품사유코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
								
				, {id : "DELI_DATE"        , label:["납기일자"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "ORD_DATE"         , label:["발주일시"          , "#text_filter"], type: "ro", width: "130", sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "ORD_TYPE"         , label:["발주유형"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_TYPE_NM"      , label:["발주유형"          , "#text_filter"], type: "ro", width: "80" , sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "ORD_STATE"        , label:["발주상태"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_STATE_NM"     , label:["발주상태"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "RETN_YN"          , label:["반품여부"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "SEND_FAX_STATE"   , label:["FAX발송"           , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "SEND_EMAIL_STATE" , label:["Email발송"         , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "PRINT_STATE"      , label:["PRINT인쇄상태"     , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "RESP_USER"        , label:["담당자코드"        , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "EMP_NM"           , label:["담당자명"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_CUSTMR"       , label:["발행구분"          , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
		   	    , {id : "ORD_SEQ"          , label:["일련번호"          , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "center", isHidden : true , isEssential : true}
		];
		
		erpRightGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpRightGridColumns
		});		
		
		//erpRightGrid.enableDistributedParsing(true, 100, 24);
		$erp.attachDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT","SUM_AMT"]);
		erpRightGridDataProcessor =$erp.initGrid(erpRightGrid);
		$erp.initGridDataColumns(erpRightGrid);
		
		/* onCellChanged onEditCell */ 
		erpRightGrid.attachEvent("onEditCell", function(stage,rId,cInd,nValue,oValue) {
            console.log("호출됨");
			if ( stage == "2") {
				
			    var rowIdName =  erpRightGrid.getRowId(cInd);
			    
			    var ll_ORD_QTY   = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("ORD_QTY"   )).getValue();
			    var ll_PUR_PRICE = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("PUR_PRICE" )).getValue();

			    /* 원단위 절사 */
			    var ll_SUPR_AMT  = ll_ORD_QTY  *  ll_PUR_PRICE;

			    ll_SUPR_AMT      = ll_SUPR_AMT  / 10;
			    ll_SUPR_AMT      = Math.floor(ll_SUPR_AMT);
			    ll_SUPR_AMT      = ll_SUPR_AMT * 10;

			    var ll_VAT       = ll_SUPR_AMT *  0.1;
			    var ll_SUM_AMT   = ll_SUPR_AMT +  ll_VAT;
			    
			    console.log( " ll_SUPR_AMT : " + ll_SUPR_AMT + " ll_VAT : " + ll_VAT);
			    
			    erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUPR_AMT"   )).setValue(ll_SUPR_AMT);
				erpRightGrid.cells(rId, erpRightGrid.getColIndexById("VAT"        )).setValue(ll_VAT);
				erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUM_AMT"    )).setValue(ll_SUM_AMT);

			    ll_SUPR_AMT   = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUPR_AMT"   )).getValue();
			    ll_VAT        = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("VAT"        )).getValue();
			    console.log( " ll_SUPR_AMT : " + ll_SUPR_AMT + " ll_VAT : " + ll_VAT);
			    
				$erp.setDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT","SUM_AMT"]);
			    return true;
			}
			
		});				
		
	}

	
	/****************************************************************************/
    /* 협력사명 선택 팝업호출                                                   */
    /****************************************************************************/	
	function openSearchCustmrGridPopup() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "1";           // 협력사(매입처) :1,  고객사(매출처): 2
		var onRowSelect = function(id, ind) {
			document.getElementById("txtSUPR_CD").value = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("Custmr_Name").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	/****************************************************************************/
    /* 협력사명 선택 팝업호출                                                   */
    /****************************************************************************/	
	function openSearchCustmrGridPopup2() { // this는 클릭시 열리는 팝업창이다.
		var pur_sale_type = "1";           // 협력사(매입처) :1,  고객사(매출처): 2
		var onRowSelect = function(id, ind) {
			document.getElementById("txtSUPR_CD2").value = this.cells(id, this.getColIndexById("CUSTMR_CD")).getValue();
			document.getElementById("Custmr_Name2").value = this.cells(id, this.getColIndexById("CUSTMR_NM")).getValue();
			
			$erp.closePopup2("openSearchCustmrGridPopup");
		}
		$erp.searchCustmrPopup(onRowSelect, pur_sale_type);
	}
	
	/***************************************************/
	/* 그리드 조회
	/***************************************************/
	function search_ErpRightGrid(){

		erpRightLayout.progressOn();
		
		var scrin_txtORD_DATE  = document.getElementById("txtORD_DATE").value;
		
		scrin_txtORD_DATE      = scrin_txtORD_DATE.replace (/-/g, "")
		
		$.ajax({
			url : "/sis/order/openOrderInputSearch.do"
			,data : {
				  "PARAM_ORGN_DIV_CD"  : param_ORGN_DIV_CD   
				, "PARAM_ORGN_CD"      : param_ORGN_CD
				, "PARAM_ORD_NO"       : param_ORD_NO
				, "PARAM_ORD_TYPE"     : param_ORD_TYPE
			}
			
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpRightGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpRightGrid
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpRightGrid.parse(gridDataList, 'js');	
						erpRightGrid.selectRowById(1);
						$erp.setDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT","SUM_AMT"]);
						
						/***************************************************************************/
						/* 조회후 발주서 마스타 디자인 Ribbon부분의 값을 첫번째 값에서 찾아서 출력 */ 
						/***************************************************************************/

                        document.getElementById("txtORD_DATE").value    = erpRightGrid.cells(1, erpRightGrid.getColIndexById("ORD_DATE"  )).getValue();
                        document.getElementById("txtORD_NO").value      = erpRightGrid.cells(1, erpRightGrid.getColIndexById("ORD_NO"    )).getValue();   /* 발주번호 */
                        document.getElementById("txtSUPR_CD").value     = erpRightGrid.cells(1, erpRightGrid.getColIndexById("SUPR_CD"   )).getValue();   /* 협력사코드 */
                        document.getElementById("Custmr_Name").value    = erpRightGrid.cells(1, erpRightGrid.getColIndexById("SUPR_NM"   )).getValue();   /* 협력사명 */
                        document.getElementById("txtRESP_USER").value   = erpRightGrid.cells(1, erpRightGrid.getColIndexById("RESP_USER" )).getValue();   /* 담당자코드 */
                        document.getElementById("RESP_USER_NAME").value = erpRightGrid.cells(1, erpRightGrid.getColIndexById("EMP_NM"    )).getValue();   /* 담당자명 */
                        document.getElementById("txtDELI_DATE").value   = erpRightGrid.cells(1, erpRightGrid.getColIndexById("DELI_DATE" )).getValue();   /* 납기일자 */
                        cmbIN_WARE_CD.setComboValue(erpRightGrid.cells(1, erpRightGrid.getColIndexById("IN_WARE_CD" )).getValue());
                        cmbORD_STATE.setComboValue(erpRightGrid.cells(1, erpRightGrid.getColIndexById("ORD_STATE" )).getValue());                           /* 발주진행상태 */

                        document.getElementById("txtPROJ_CD").value       = erpRightGrid.cells(1, erpRightGrid.getColIndexById("PROJ_CD" )).getValue();     /* 프로젝트CD */
                        document.getElementById("CMMN_DETAIL_CD_NM").value= erpRightGrid.cells(1, erpRightGrid.getColIndexById("PROJ_NM" )).getValue();     /* 프로젝트명 */
                        document.getElementById("txtMEMO").value          = erpRightGrid.cells(1, erpRightGrid.getColIndexById("MEMO" )).getValue();        /* 메모  */
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpRightLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}

			
	/***************************************************/
	/* COMBO박스처리 
	/***************************************************/
	function initDhtmlXCombo(){
		/* 입고창고 */
		cmbIN_WARE_CD  = $erp.getDhtmlXComboCommonCode('cmbIN_WARE_CD',     'cmbIN_WARE_CD',  ["ORGN_CD","","","","","MK"],  135,  "",  false, cmbIN_WARE_CD);
    	$erp.objReadonly("cmbIN_WARE_CD");  /* Combo박스 손을 못되게 한다 */

		/* 발주진행상태 */
		cmbORD_STATE   = $erp.getDhtmlXComboCommonCode('cmbORD_STATE',   'cmbORD_STATE',  'ORD_STATE',   177,  "",  true, cmbORD_STATE);
    	$erp.objReadonly("cmbORD_STATE");   /* Combo박스 손을 못되게 한다 */
	}
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>

</script>
</head>
<body>				
	 <div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
	 	  <table class="table_search" id="aaa">
			  <colgroup>
				  <col width="100px">
				  <col width="100px">
				  <col width="20px">
			
				  <col width="100px">	
				  <col width="100px">
				  <col width="50px">	
				
				  <col width="100px">
				  <col width="100px">	
				  <col width="130px">
				  <col width="130px">	
				  <col width="*">				
			  </colgroup>
			  <tr>
				  <th>발주일자</th>
				  <td colspan="2">
					  <input type="text" id="txtORD_DATE" name="txtORD_DATE" class="input_common input_calendar default_date" data-position="">
				  </td>
				
				  <th>발주번호</th>
				  <td colspan="2"><input type="text" id="txtORD_NO" name="ORD_NO" readonly="readonly"  disabled="disabled" class="input_common" maxlength="20" ></td>

				  <th>협력사명</th>
				  <td colspan="2">
					  <input type="hidden" id="txtSUPR_CD">
					  <input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled"/>
				  </td>

				  <th>담당자명</th>
				  <td>
					  <input type="hidden" id="txtRESP_USER">
					  <input type="text" id="RESP_USER_NAME" name="RESP_USER_NAME" readonly="readonly" disabled="disabled"/>
				  </td>
			  </tr>
			
			  <tr>
				  <th>납기일자</th>
				  <td colspan="2">
					  <input type="text" id="txtDELI_DATE" name="SearchdelStrDt" class="input_common input_calendar">
				  </td>
				
				  <th>입고창고</th>
				  <td colspan="2">
				      <div id="cmbIN_WARE_CD"></div>
				  </td>
				
				  <th>프로젝트</th>
				  <td colspan="2">
					  <input type="hidden" id="txtPROJ_CD">
					  <input type="text" id="CMMN_DETAIL_CD_NM" name="CMMN_DETAIL_CD_NM" readonly="readonly" disabled="disabled"/>
				  </td>

				  <th>발주진행상태</th>
				  <td>
				      <div id="cmbORD_STATE"></div>
				  </td>
			  </tr>
			  <tr>
				  <th>메모</th>
				  <td colspan="10"><input type="text" id="txtMEMO" name="MEMO" class="input_common" maxlength="100" style="width:642px;"></td>
			  </tr>
			
	 	  </table>
	 </div>
	 <div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	 <div id="div_erp_grid"   class="div_grid_full_size"   style="display:none"></div>
</body>

	
</html>