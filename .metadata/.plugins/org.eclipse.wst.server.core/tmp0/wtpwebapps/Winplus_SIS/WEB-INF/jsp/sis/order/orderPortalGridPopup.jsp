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
		※ 전역 변수 선언부( orderPortalGridPopup.jsp 거래처포털 주문서 등록 프로그램 )
		□ 변수명 : Type / Description
		■ erpRightLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpRightGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbOUT_WARE_CD : Object / 출고창고 DhtmlXCombo  (CODE : CENTER_CD )
		■ cmbORD_STATE : Object / 발주진행상태  (CODE : ORD_STATE ) 		 
	--%>
	var thisPopupWindow = parent.erpPopupWindows.window('orderPortalGridPopup');
	
	var erpRightLayout;
	var erpRightRibbon;	
	var erpRightGrid;
	var erpRightGridColumns;
	var erpRightGridDataProcessor;	
	var cmbOUT_WARE_CD;                  /* 출고창고           */
	var cmbORD_STATE;                    /* 발주진행상태       */
	var cmbOUT_WARE_CD;                  /* 상품조회  협력사   */
	var erpRightGridSelectedCustmr_cd;   /* 그리드 rowSelected */

	var today = $erp.getToday("");

	var LOGIN_ORGN_DIV_CD  = "";
	var LOGIN_ORGN_CD      = "";
	var LOGIN_ORGN_DIV_TYP = "";
	var LOGIN_ORD_NO       = "";
	var LOGIN_CUSTMR_CD    = "";
	var LOGIN_CUSTMR_NM    = "";
	var GLOVAL_SUPR_CD     = "";        /* 협력사코드 : 출고창고 COMBO박스에 선택된 코드  */

    /*  본사조직으로 로그인후  직영점 선택시 처리하기 위함 */
	var GLOVAL_ORGN_DIV_CD  = "";
	var GLOVAL_ORGN_CD      = "";
	var GLOVAL_ORGN_NM      = "";
	var GLOVAL_ORGN_DIV_TYP = "";

	var All_checkList = "";
	var Code_List = "";

	var GLOVAL_leadtime      = 2;       /* 발주리드타임 기본 2일 */
	var GLOVAL_closetime     = "";      /* 발주마감시간 */
	var GLOVAL_Display1_date = "";
	var GLOVAL_Display2_date = "";
    var	GLOVAL_CHK_CNT       = 1;

	var SELECT_LVL           =  "";
	var SELECT_GRUP_TOP_CD   =  "";
	var SELECT_GRUP_MID_CD   =  "";
	var SELECT_GRUP_BOT_CD   =  "";

	$(document).ready(function(){		
		if(thisPopupWindow){
			thisPopupWindow.setText("${screenDto.scrin_nm}");	
			//thisPopupWindow.denyResize();
			//thisPopupWindow.denyMove();
		}
		
		LOGIN_ORGN_DIV_CD   = "${param.LOGIN_ORGN_DIV_CD}"
		LOGIN_ORGN_CD       = "${param.LOGIN_ORGN_CD}"
		LOGIN_ORD_NO        = "${param.LOGIN_ORD_NO}"
	    LOGIN_ORGN_DIV_TYP  = "${param.LOGIN_ORGN_DIV_TYP}"

    	GLOVAL_ORGN_DIV_CD  = "${param.SELECT_ORGN_DIV_CD}"
   		GLOVAL_ORGN_CD      = "${param.SELECT_ORGN_CD}"
	    GLOVAL_ORGN_DIV_TYP = "${param.SELECT_ORGN_DIV_TYP}"
	    LOGIN_CUSTMR_CD     = "${param.LOGIN_CUSTMR_CD}"
	    LOGIN_CUSTMR_NM     = "${param.LOGIN_CUSTMR_NM}"
	    	
		console.log("orderPortalGridPopup.jsp =>  GLOVAL_ORGN_DIV_CD =>" + GLOVAL_ORGN_DIV_CD + " GLOVAL_ORGN_CD=> " + GLOVAL_ORGN_CD );
	    console.log(" LOGIN_ORGN_DIV_TYP => " + LOGIN_ORGN_DIV_TYP);
	    
		initErpLayout();
		initErpRightRibbon();
		
		initErpBackGrid();   // 복사용 Buffer그리드 
		initErpRightGrid();  // 발주서 편집용그리드
		initDhtmlXCombo();
		
		//document.getElementById("txtREQ_DATE").value   = today;
        document.getElementById("txtORD_TYPE").value   = "2";    /* 발주유형 1:발주, 2:주문 */
        document.getElementById("Custmr_Name").value   = "${param.LOGIN_CUSTMR_NM}";    /* 고객명 */
        document.getElementById("txtIN_WARE_CD").value =  LOGIN_CUSTMR_CD;              /* 고객코드(입고창고) */
        
		$erp.asyncObjAllOnCreated(function(){
			search_ErpRightGrid();
		});
        		
	});
	
	/***************************************************/
	/*  1. MAIN Layout(1C)
    /***************************************************/
	function initErpLayout(){
		erpRightLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				  {id: "a", text: "", header:false, height:63}
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
						  {id : "search_ErpGrid",     type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : true}
						//, {id : "add_erpGrid"  ,      type : "button", text:'<spring:message code="ribbon.add" />',    isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
					   	//, {id : "delete_erpGrid",     type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
						//, {id : "save_erpGrid",       type : "button", text:'<spring:message code="ribbon.save" />',   isbig : false, img : "menu/save.gif",   imgdis : "menu/save_dis.gif",   disable : true}
						//, {id : "excel_erpGrid",      type : "button", text:'<spring:message code="ribbon.excel" />',  isbig : false, img : "menu/excel.gif",  imgdis : "menu/excel_dis.gif",  disable : true}
						//, {id : "excel_erpGri1",      type : "button", text:'주문내역복사',                            isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						//, {id : "print_erpRightGrid", type : "button", text:'<spring:message code="ribbon.print" />',  isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif",   disable : true}		
						, {id : "excel_erpGri2",      type : "button", text:'화면닫기',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
				]}							
			]
		});

		
		erpRightRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_ErpGrid"){
		    	search_ErpRightGrid();
		    } else if (itemId == "excel_erpGri2"){
		    	thisOnComplete(); // 화면닫기
		    }
		});
	}
	
	/****************************************************************************/
    /* erpRightGrid 초기화                                                      */
    /****************************************************************************/	
	function initErpRightGrid(){
		erpRightGridColumns = [
			      {id : "NO"               , label:["NO"                , "#rspan"]      , type: "cntr", width:  "30", sort : "int", align : "right",  isHidden : false, isEssential : false}
				, {id : "CHECK"            , label:["#master_checkbox"  , "#rspan"]      , type: "ch"  , width:  "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
                /* 실제화면에 뿌려지는 부분 */
				, {id : "GOODS_CD"         , label:["상품코드"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true, isEssential : true}			
				, {id : "BCD_CD"           , label:["자바코드"          , "#text_filter"], type: "ro"  , width:  "60", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "SUPR_CD"          , label:["협력사코드"        , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "SUPR_NM"          , label:["협력사명"          , "#text_filter"], type: "ro"  , width: "160", sort : "str", align : "left",   isHidden : false, isEssential : false}
				, {id : "BCD_NM"           , label:["상품명"            , "#text_filter"], type: "ro"  , width: "250", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "DIMEN_NM"         , label:["규격"              , "#text_filter"], type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "UNIT_NM"          , label:["단위"              , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false , isEssential : true}
				, {id : "DSCD_TYPE"        , label:["반품가능"          , "#text_filter"], type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "RETN_YN"          , label:["반품"              , "#text_filter"], type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : true , isEssential : true}			
				, {id : "ORD_QTY"          , label:["수량"              , "#text_filter"], type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "PUR_PRICE"        , label:["단가"              , "#text_filter"], type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}			
				, {id : "SUPR_AMT"         , label:["공급가액"          , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"          , label:["부가세"            , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"          , label:["합계금액"          , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "REMK"             , label:["적요"              , "#text_filter"], type: "ro"  , width: "200", sort : "str", align : "right",  isHidden : false, isEssential : false}

				, {id : "ORGN_DIV_CD"      , label:["조직영역코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "ORGN_CD"          , label:["조직코드"          , "#text_filter"], type: "ro"  , width: "200", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "ORD_NO"           , label:["발주번호"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false, isEssential : false}
				, {id : "OUT_WARE_CD"      , label:["출고창고코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "IN_WARE_CD"       , label:["입고창고코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "IN_WARE_NM"       , label:["입고창고"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "PROJ_CD"          , label:["프로젝트코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "PROJ_NM"          , label:["프로젝트명"        , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "DIMEN_WGT"        , label:["중량"              , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}

				, {id : "ORD_TITLE"        , label:["제목"              , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "MEMO"             , label:["메모"              , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "RESN_CD"          , label:["반품사유코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
								
				, {id : "RESV_DATE"        , label:["납기일자"          , "#text_filter"], type: "ro",   width: "80",  sort : "str", align : "center", isHidden : true , isEssential : false}
				, {id : "REQ_DATE"         , label:["발주일시"          , "#text_filter"], type: "ro",   width: "130", sort : "str", align : "center", isHidden : true , isEssential : false}
				, {id : "ORD_TYPE"         , label:["발주유형"          , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "ORD_TYPE_NM"      , label:["발주유형"          , "#text_filter"], type: "ro",   width: "80" , sort : "str", align : "center", isHidden : true , isEssential : false}
				, {id : "ORD_STATE"        , label:["발주상태"          , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "ORD_STATE_NM"     , label:["발주상태"          , "#text_filter"], type: "ro",   width: "80",  sort : "str", align : "center", isHidden : true , isEssential : false}
				, {id : "RETN_YN"          , label:["반품여부"          , "#text_filter"], type: "ro",   width: "80",  sort : "str", align : "center", isHidden : true , isEssential : false}
				, {id : "SEND_FAX_STATE"   , label:["FAX발송"           , "#text_filter"], type: "ro",   width: "80",  sort : "str", align : "center", isHidden : true , isEssential : false}
				, {id : "SEND_EMAIL_STATE" , label:["Email발송"         , "#text_filter"], type: "ro",   width: "80",  sort : "str", align : "center", isHidden : true , isEssential : false}
				, {id : "PRINT_STATE"      , label:["PRINT인쇄상태"     , "#text_filter"], type: "ro",   width: "80",  sort : "str", align : "center", isHidden : true , isEssential : false}
				, {id : "RESP_USER"        , label:["담당자코드"        , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "EMP_NM"           , label:["담당자명"          , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "ORD_CUSTMR"       , label:["발행구분"          , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
		   	    , {id : "ORD_SEQ"          , label:["일련번호"          , "#text_filter"], type: "ron",  width: "100", sort : "int", align : "right",  isHidden : true , isEssential : true}
				, {id : "ORGN_DIV_TYP"     , label:["조직영역유형"      , "#text_filter"], type: "ro",   width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
		];
		
		erpRightGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpRightGridColumns
		});		
		
		/* 마우스 한번 클릭으로  편집가능 */
		erpRightGrid.enableLightMouseNavigation(true);
		
		//erpRightGrid.enableDistributedParsing(true, 100, 24);
		$erp.attachDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);
		erpRightGridDataProcessor =$erp.initGrid(erpRightGrid);
		$erp.initGridDataColumns(erpRightGrid);
		
	}

	/****************************************************************************/
    /* erpBackGrid 초기화                                                      */
    /****************************************************************************/	
	function initErpBackGrid(){
		erpBackGridColumns = [
		   	      {id : "ORD_SEQ"          , label:["일련번호"          , "#text_filter"], type: "ron" , width: "100", sort : "int", align : "right",  isHidden : false , isEssential : true}
			    , {id : "NO"               , label:["NO"                , "#rspan"]      , type: "cntr", width:  "30", sort : "int", align : "right",  isHidden : false, isEssential : false}
				, {id : "CHECK"            , label:["#master_checkbox"  , "#rspan"]      , type: "ch"  , width:  "40", sort : "int", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
                /* 실제화면에 뿌려지는 부분 */
				, {id : "GOODS_CD"         , label:["상품코드"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "BCD_CD"           , label:["자바코드"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "BCD_NM"           , label:["상품명"            , "#text_filter"], type: "ro"  , width: "250", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "DIMEN_NM"         , label:["규격"              , "#text_filter"], type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "DSCD_TYPE"        , label:["반품가능"          , "#text_filter"], type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "RETN_YN"          , label:["반품"              , "#text_filter"], type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : true , isEssential : true}			
				, {id : "ORD_QTY"          , label:["수량"              , "#text_filter"], type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "PUR_PRICE"        , label:["단가"              , "#text_filter"], type: "edn" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}			
				, {id : "SUPR_AMT"         , label:["공급가액"          , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"          , label:["부가세"            , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"          , label:["합계금액"          , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "REMK"             , label:["적요"              , "#text_filter"], type: "ed"  , width: "200", sort : "str", align : "right",  isHidden : false, isEssential : false}

				, {id : "ORGN_DIV_CD"      , label:["조직영역코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORGN_CD"          , label:["조직코드"          , "#text_filter"], type: "ro"  , width: "200", sort : "str", align : "left",   isHidden : true , isEssential : true}
				, {id : "ORD_NO"           , label:["발주번호"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false , isEssential : true}
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
								
				, {id : "RESV_DATE"        , label:["납기일자"          , "#text_filter"], type: "ro", width: "80",  sort : "str", align : "center", isHidden : true , isEssential : true}
				, {id : "REQ_DATE"         , label:["발주일시"          , "#text_filter"], type: "ro", width: "130", sort : "str", align : "center", isHidden : true , isEssential : true}
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
				, {id : "ORGN_DIV_TYP"     , label:["조직영역유형"      , "#text_filter"], type: "ro", width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
		];
		
		erpBackGrid = new dhtmlXGridObject({
			parent: "div_erp_grid"			
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH			
			, columns : erpBackGridColumns
		});			
	}
	

	/***************************************************/
	/* 협력사 주문마감시간 고려  leadetime일 구하기
	/***************************************************/
	function getOrderDeadTimeLeadTime(CUSTMR_CD, mode){
		
		GLOVAL_closetime     = ""; /* 발주마감시간 */
		GLOVAL_Display1_date = "";
		GLOVAL_Display2_date = "";
		GLOVAL_CHK_CNT       = 1;
		
		$.ajax({
			url : "/sis/order/getOrderDeadTimeLeadTime.do"
			,data : { "PARAM_CUSTMR_CD"  : CUSTMR_CD }
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					document.getElementById("BusinessDay").value=data.gridDataList.GET_LEAD_TIME; /* leadtime */
					GLOVAL_CHK_CNT=data.gridDataList.CHK_CNT; /* 마감시간 이전이면 1 이후이면 2 */
					
					console.log("data.gridDataList.CHK_CNT(마감시간 이전이면 1 이후이면 2)=>" +  data.gridDataList.CHK_CNT);
					console.log("data.gridDataList.GET_LEAD_TIME(리드타임일)=>" + data.gridDataList.GET_LEAD_TIME);
					
					GLOVAL_leadtime =data.gridDataList.GET_LEAD_TIME;    /* leadtime */
					GLOVAL_closetime=data.gridDataList.CLSE_TIME+ "00";  /* 발주마감시간  시분+초 */
					document.getElementById("OrderDeadTimeLeadTime").value= data.gridDataList.DISP_CLSE_TIME;
					getBusinessDay(GLOVAL_leadtime,   1, GLOVAL_CHK_CNT, mode);
					if ( mode == 1) {
						getBusinessDay(GLOVAL_leadtime+1, 2, GLOVAL_CHK_CNT, mode);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}	
	
	/*************************************************************************************/
	/* 윈플러스 영업일조회( 비영업일 : 토,일, 기본 ) 
	/* SELECT CMMN_DETAIL_CD_NM  FROM COM_CMMN_CODE_DETAIL WHERE CMMN_CD = 'NONHOLIDAY'
	/* mode( 1:등록 2:조회 ),    chk_cnt ( 마감시간 이전이면 1 이후이면 2)
	/*************************************************************************************/
	function getBusinessDay(leadtime, cnt, chk_cnt, mode){
		var ls_closetime  = "";
		$.ajax({
			url : "/sis/order/getBusinessDay.do"
			,data : { "PARAM_LEAD_TIME"  : leadtime }
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {

				    if ( mode == 1) {   /* 등록인경우만 납기일 Default세팅 */
						document.getElementById("txtRESV_DATE").value=data.gridDataList.YYYY_MM_DD;     /* 납기일을 1영업일로 세팅한다  */
					    if ( cnt == 2) {
							GLOVAL_Display2_date = data.gridDataList.YYYY_MM_DD + " (" +   data.gridDataList.DAY_WEEK  + ")";
							GLOVAL_date = data.gridDataList.YYYY_MM_DD;
							document.getElementById("BusinessDay").value= leadtime + "일 " +GLOVAL_Display2_date;
					    }
					}
					else
					{
						GLOVAL_Display2_date = data.gridDataList.YYYY_MM_DD + " (" +   data.gridDataList.DAY_WEEK  + ")";
						GLOVAL_date = data.gridDataList.YYYY_MM_DD;
						document.getElementById("BusinessDay").value= leadtime + "일 " +GLOVAL_Display2_date;
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}	

	
	/***************************************************/
	/* 그리드 조회
	/***************************************************/
	function search_ErpRightGrid(){

		erpRightLayout.progressOn();
		
		var scrin_txtREQ_DATE  = document.getElementById("txtREQ_DATE").value;
		var scrn_CUSTMR_CD     = "";
		
		scrin_txtREQ_DATE      = scrin_txtREQ_DATE.replace (/-/g, "")
		
		console.log(" orderPortalGridPopup.jsp GLOVAL_ORGN_DIV_CD =>" + GLOVAL_ORGN_DIV_CD + " GLOVAL_ORGN_CD=> " + GLOVAL_ORGN_CD );

		$.ajax({
			url : "/sis/order/openOrderInputSearch.do"
			,data : {
				  "PARAM_ORGN_DIV_CD"  : GLOVAL_ORGN_DIV_CD   
				, "PARAM_ORGN_CD"      : GLOVAL_ORGN_CD
				, "PARAM_ORD_NO"       : LOGIN_ORD_NO
				, "PARAM_ORD_TYPE"     : "2"   /* 1:발주, 2:주문 */
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
						$erp.setDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);

						GLOVAL_ORGN_DIV_CD      = erpRightGrid.cells(1, erpRightGrid.getColIndexById("ORGN_DIV_CD"  )).getValue();     /* 조직영역코드 */
						GLOVAL_ORGN_CD          = erpRightGrid.cells(1, erpRightGrid.getColIndexById("ORGN_CD"      )).getValue();     /* 조직코드     */
						GLOVAL_ORGN_DIV_TYP     = erpRightGrid.cells(1, erpRightGrid.getColIndexById("ORGN_DIV_TYP" )).getValue();     /* 조직영역유형 */
                        
						/***************************************************************************/
						/* 조회후 발주서 마스타 디자인 Ribbon부분의 값을 첫번째 값에서 찾아서 출력 */ 
						/***************************************************************************/
                        document.getElementById("txtREQ_DATE").value    = erpRightGrid.cells(1, erpRightGrid.getColIndexById("REQ_DATE"  )).getValue();
                        document.getElementById("txtORD_NO").value      = erpRightGrid.cells(1, erpRightGrid.getColIndexById("ORD_NO"    )).getValue();   /* 발주번호 */
                        
                        document.getElementById("txtSUPR_CD").value     = erpRightGrid.cells(1, erpRightGrid.getColIndexById("SUPR_CD"   )).getValue();   /* 협력사코드 */
                        document.getElementById("Supr_Name").value      = erpRightGrid.cells(1, erpRightGrid.getColIndexById("SUPR_NM"   )).getValue();   /* 협력사코드 */

                        document.getElementById("txtRESP_USER").value   = erpRightGrid.cells(1, erpRightGrid.getColIndexById("RESP_USER" )).getValue();   /* 담당자코드 */
                        document.getElementById("RESP_USER_NAME").value = erpRightGrid.cells(1, erpRightGrid.getColIndexById("EMP_NM"    )).getValue();   /* 담당자명 */
                        document.getElementById("txtRESV_DATE").value   = erpRightGrid.cells(1, erpRightGrid.getColIndexById("RESV_DATE" )).getValue();   /* 납기일자 */
                        document.getElementById("txtIN_WARE_CD").value  = erpRightGrid.cells(1, erpRightGrid.getColIndexById("IN_WARE_CD" )).getValue();  /* 고객코드(입고창고) */
                        document.getElementById("Custmr_Name").value    = erpRightGrid.cells(1, erpRightGrid.getColIndexById("IN_WARE_NM" )).getValue();  /* 고객명 */
                        
                        cmbOUT_WARE_CD.setComboValue(erpRightGrid.cells(1, erpRightGrid.getColIndexById("OUT_WARE_CD" )).getValue());
                        cmbORD_STATE.setComboValue(erpRightGrid.cells(1, erpRightGrid.getColIndexById("ORD_STATE" )).getValue());                           /* 발주진행상태 */

                       // document.getElementById("CMMN_DETAIL_CD_NM").value= erpRightGrid.cells(1, erpRightGrid.getColIndexById("PROJ_NM" )).getValue();     /* 프로젝트명 */
                        document.getElementById("txtMEMO").value          = erpRightGrid.cells(1, erpRightGrid.getColIndexById("MEMO" )).getValue();        /* 메모  */
                        
                        /* 발주 마감시간 및  마감시간을 적용한 리드타임 일자 및 요일을 display한다 */
                        scrn_CUSTMR_CD                                    = erpRightGrid.cells(1, erpRightGrid.getColIndexById("SUPR_CD"   )).getValue();
        				getOrderDeadTimeLeadTime(scrn_CUSTMR_CD, 2);   /* 마감시간 이전이면 1 이후이면 2 */
                        
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpRightLayout.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	
	
	
	

	/**************************************************
	* 기타 영역
	**************************************************/

	
	/***************************************************/
	/* COMBO박스처리 
	/***************************************************/
	function initDhtmlXCombo(){
		/* 발주진행상태 */
		cmbORD_STATE   = $erp.getDhtmlXComboCommonCode('cmbORD_STATE',     'cmbORD_STATE',    'ORD_STATE',   177,  "",  false, 1);    /* 1:저장, 2:취소, 3;전송, 4:접수, 9:입고 */
    	$erp.objReadonly("cmbORD_STATE");  /* Combo박스 손을 못되게 한다 */
		
	}
	
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>				
	 <div id="div_erp_contents_search" class="div_erp_contents_search" style="display:none">
	 	  <table class="table_search" id="aaa">
			  <colgroup>
				  <col width="100px">
				  <col width="80px">
				  <col width="20px">
			
				  <col width="100px">	
				  <col width="100px">
				  <col width="70px">	
				
				  <col width="80px">
				  <col width="100px">	
				  <col width="130px">
				  <col width="130px">	
				  <col width="*">				
			  </colgroup>
			  <tr>
				  <th>발주일자</th>
				  <td colspan="2">
					  <input type="hidden" id="txtORD_TYPE">  <!--  주문휴형 : 1:발주, 2:주문  -->
					  <input type="text" id="txtREQ_DATE" name="txtREQ_DATE" class="input_common input_calendar default_date" data-position="">
				  </td>
				
				  <th>발주번호</th>
				  <td colspan="5"><input type="text" id="txtORD_NO" name="ORD_NO" readonly="readonly"  disabled="disabled" class="input_common" maxlength="20"  style="text-align:left; width:442px;"></td>

				  <th>담당자명</th>
				  <td>
					  <input type="hidden" id="txtRESP_USER">
					  <input type="text" id="RESP_USER_NAME" name="RESP_USER_NAME" readonly="readonly" disabled="disabled"/>
				  </td>
			  </tr>
			
			  <tr>
				  <th>납기일자</th>
				  <td colspan="2">
					  <input type="text" id="txtRESV_DATE" name="SearchdelStrDt" class="input_common input_calendar">
				  </td>
				
				  <th>고객사</th>
				  <td colspan="2">
					  <input type="hidden" id="txtIN_WARE_CD">  <!--  고객사코드는 Hidden처리한다  -->
					  <input type="text" id="Custmr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled" style="width:160px;"/>
				  </td>

				  <th>협력사</th>
				  <td colspan="2">
					  <input type="hidden" id="txtSUPR_CD">    <!--  협력사코드는 Hidden처리한다  -->
					  <input type="text" id="Supr_Name" name="Custmr_Name" readonly="readonly" disabled="disabled" style="width:160px;"/>
				  </td>				  

				  <th>진행상태</th>
				  <td>
				      <div id="cmbORD_STATE"></div>
				  </td>
			  </tr>
			  
			
	 	  </table>
	 </div>
	 <div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	 <div id="div_erp_grid"   class="div_grid_full_size"   style="display:none"></div>
	 
</body>

	
</html>