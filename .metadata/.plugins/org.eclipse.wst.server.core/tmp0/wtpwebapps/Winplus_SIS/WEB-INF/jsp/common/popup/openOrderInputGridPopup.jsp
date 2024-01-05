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
		□ 프로그램명 : 센타 발주서등록 ( openOrderInputGridPopup.jsp )
		□ 최종UPDATE : 2019-09-25
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpRightLayout : Object / 페이지 Layout DhtmlXLayout
		■ erpRightRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpRightGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpRightGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpRightGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbIN_WARE_CD : Object / 입고창고 DhtmlXCombo  (CODE : WARE_CD )
		■ cmbORD_STATE : Object / 발주진행상태  (CODE : ORD_STATE ) 		 
	--%>
	var thisPopupWindow = parent.erpPopupWindows.window('openOrderInputGridPopup');
	
	var erpRightLayout;
	var erpRightRibbon;	
	var erpRightGrid;
	var erpRightGridColumns;
	var erpRightGridDataProcessor;	
	var cmbIN_WARE_CD;                   /* 입고창고           */
	var cmbORD_STATE;                    /* 발주진행상태       */
	var erpRightGridSelectedCustmr_cd;   /* 그리드 rowSelected */

	var today = $erp.getToday("");
	var thisYear = today.substring(0,4);
	var thisMonth = today.substring(4,6);
	var thisDay = today.substring(6,8);
	today = thisYear + "-" + thisMonth + "-" + thisDay;
	
	var LOGIN_ORGN_DIV_CD  = "";
	var LOGIN_ORGN_CD      = "";
	var LOGIN_ORGN_DIV_TYP = "";
	var LOGIN_ORD_NO       = "";
	var GLOVAL_SUPR_CD     = "";        /* 협력사코드 : 출고창고 COMBO박스에 선택된 코드  */

    /*  본사조직으로 로그인후  직영점 선택시 처리하기 위함 */
	var GLOVAL_ORGN_DIV_CD  = "";
	var GLOVAL_ORGN_CD      = "";
	var GLOVAL_ORGN_NM      = "";
	var GLOVAL_ORGN_DIV_TYP = "";
	
	
	var All_checkList = "";
	var Code_List = "";

	var GLOVAL_leadtime      = 2;  /*  발주리드타임 기본 2일 */
	var GLOVAL_closetime     = ""; /* 발주마감시간 */
	var GLOVAL_Display1_date = "";
	var GLOVAL_Display2_date = "";
    var	GLOVAL_CHK_CNT       = 1;

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
			    
		console.log("openOrderInputGridPopup.jsp =>  GLOVAL_ORGN_DIV_CD =>" + GLOVAL_ORGN_DIV_CD + " GLOVAL_ORGN_CD=> " + GLOVAL_ORGN_CD );
	    console.log(" LOGIN_ORGN_DIV_TYP => " + LOGIN_ORGN_DIV_TYP);
	    
		initErpLayout();
		initErpRightRibbon();
		
		initErpBackGrid();   // 복사용 Buffer그리드 
		initErpRightGrid();  // 발주서 편집용그리드
		initDhtmlXCombo();
		
		//document.getElementById("txtREQ_DATE").value=today;
        //document.getElementById("txtORD_TYPE").value  = "1";    /* 발주유형 1:발주, 2:주문 */
		        
		if(LOGIN_ORD_NO){
			$erp.asyncObjAllOnCreated(function(){
				search_ErpRightGrid();
				
			});
		}
		else 
		{
			addData();
		}
        		
	});
	

	/***************************************************/
	/*  1-1. MAIN Layout
    /***************************************************/
	function initErpLayout(){
		erpRightLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				  {id: "a", text: "", header:false, height:90}
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
						//, {id : "excel_erpGrid",      type : "button", text:'<spring:message code="ribbon.excel" />',  isbig : false, img : "menu/excel.gif",  imgdis : "menu/excel_dis.gif",  disable : true}
						//, {id : "excel_erpGri1",      type : "button", text:'발주내역복사',                            isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
						//, {id : "print_erpRightGrid", type : "button", text:'<spring:message code="ribbon.print" />',  isbig : false, img : "menu/print.gif",  imgdis : "menu/print_dis.gif",   disable : true}		
						, {id : "excel_erpGri2",      type : "button", text:'화면닫기',                                isbig : false, img : "menu/add.gif",    imgdis : "menu/add_dis.gif",    disable : true}
				]}							
			]
		});
		
		erpRightRibbon.attachEvent("onClick", function(itemId, bId){
		    if(itemId == "search_ErpGrid"){
		    	search_ErpRightGrid();
		    } else if (itemId == "save_erpGrid"){
		    	//save_ErpRightGrid();
		    } else if (itemId == "excel_erpGrid"){
		    } else if (itemId == "print_erpGrid"){

		    } else if (itemId == "excel_erpGri2"){
		    	thisOnComplete(); // 화면닫기
		    }
		});
	}
	
	/************************************************************/
	/* 선택된 source row의 값을  target으로 복사한다  
	/************************************************************/
	function add_erpMiddGrid(){
				
		var erpMiddGridRowCount  = erpMiddGrid.getRowsNum();
		var erpRightGridRowCount = erpRightGrid.getRowsNum();
		var max_ord_seq          = 0;
		var curr_row_id          = 0;
		
		//alert("=======erpRightGridRowCount======"+ erpRightGridRowCount)
		if  ( erpRightGridRowCount > 0 ) {
			  curr_row_id = erpRightGrid.getRowId(erpRightGridRowCount-1);
  		      max_ord_seq = erpRightGrid.cells(curr_row_id, erpRightGrid.getColIndexById("ORD_SEQ")).getValue();
  		      if ( max_ord_seq == "" ) max_ord_seq = 0;
		}
		
		for(var i = 0; i < erpMiddGridRowCount; i++){
			var leftRid = erpMiddGrid.getRowId(i);
			var check   = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("CHECK")).getValue();

			
			if(check == 1){
				
				var source_goods_no  = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("GOODS_NO")).getValue();
				var source_bcd_cd    = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("BCD_CD")).getValue();
				var isAble = true;
				
				/* Source의 선택된 Key값이 taget에 존재하는경우  skip한다 */
				for(var j = 0; j < erpRightGridRowCount ; j++){
					var rightRid = erpRightGrid.getRowId(j);
					var target_goods_no = erpRightGrid.cells(rightRid, erpRightGrid.getColIndexById("GOODS_CD")).getValue();
					var target_bcd_cd   = erpRightGrid.cells(rightRid, erpRightGrid.getColIndexById("BCD_CD")).getValue();
					
					if( (source_goods_no == target_goods_no) && (source_bcd_cd == target_bcd_cd)) {
						isAble = false;
						break;
					}
				}

				/* 선택된 source row의 값을  target으로 복사한다 */ 
				if(isAble === true){
					//var uid = erpRightGrid.uid();
					curr_row_id = curr_row_id + 1;
					var uid = curr_row_id;
					erpRightGrid.addRow(uid);
					
					//var curr_row_id = erpRightGrid.getRowsNum();
					
					var GOODS_NO   = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("GOODS_NO"  )).getValue();		
					var BCD_CD     = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("BCD_CD"    )).getValue();
					var BCD_NM     = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("BCD_NM"    )).getValue();					
					var DIMEN_NM   = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("DIMEN_NM"  )).getValue();					
					var UNIT_NM    = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("UNIT_NM"   )).getValue();		
					var DIMEN_WGT  = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("DIMEN_WGT" )).getValue();		
					var PUR_PRICE  = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("PUR_PRICE" )).getValue();
					var DSCD_TYPE  = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("DSCD_TYPE" )).getValue();
					var CUSTMR_CD  = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("CUSTMR_CD" )).getValue();
					var CUSTMR_NM  = erpMiddGrid.cells(leftRid, erpMiddGrid.getColIndexById("CUSTMR_NM" )).getValue();
                    var VAT        = Math.floor(PUR_PRICE * 0.1);
    			    var TOT_AMT    = PUR_PRICE +  VAT;
    			    
					max_ord_seq    = max_ord_seq + 1;
					
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORGN_DIV_CD" )).setValue(GLOVAL_ORGN_DIV_CD);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORGN_CD"     )).setValue(GLOVAL_ORGN_CD);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORD_NO"      )).setValue(LOGIN_ORD_NO);
					
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("GOODS_CD"    )).setValue(GOODS_NO);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("BCD_CD"      )).setValue(BCD_CD);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("BCD_NM"      )).setValue(BCD_NM);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("DIMEN_NM"    )).setValue(DIMEN_NM);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("UNIT_NM"     )).setValue(UNIT_NM);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("DSCD_TYPE"   )).setValue(DSCD_TYPE);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("DIMEN_WGT"   )).setValue(DIMEN_WGT);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("PUR_PRICE"   )).setValue(PUR_PRICE);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORD_SEQ"     )).setValue(max_ord_seq);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("SUPR_CD"     )).setValue(CUSTMR_CD);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("SUPR_NM"     )).setValue(CUSTMR_NM);
					
					/* 임시로 처리 */
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("SUPR_AMT"   )).setValue(PUR_PRICE);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("VAT_AMT"    )).setValue(VAT);
				    erpRightGrid.cells(uid, erpRightGrid.getColIndexById("TOT_AMT"    )).setValue(TOT_AMT);
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORD_QTY"    )).setValue(1);
					
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORD_STATE"   )).setValue("0");   /* 1:저장           */
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("RETN_YN"     )).setValue("N");   /* 0:정상, 1:반품   */
					erpRightGrid.cells(uid, erpRightGrid.getColIndexById("ORD_CUSTMR"  )).setValue("1");   /* 0:점포발행(센터,공급사로 발주), 1:센터발행(공급사로 발주) */
			
				}
			}
		}
		$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
		
		/* Cursor를 추가한 최종라인으로 위치시킨다 */
		erpRightGridRowCount = erpRightGrid.getRowsNum();
		erpRightGrid.selectRowById(erpRightGridRowCount);

		$erp.setDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);

	}	
	
	/************************************************************/
	/* 발주서 그리드의 Line추가
	/************************************************************/
	function add_erpRightGrid(){
				
		var erpRightGridRowCount = erpRightGrid.getRowsNum();
		var max_ord_seq          = 0;
		var curr_row_id          = 0;

		if  ( erpRightGridRowCount > 0 ) {
			  curr_row_id = erpRightGrid.getRowId(erpRightGridRowCount-1);
  		      max_ord_seq = erpRightGrid.cells(curr_row_id, erpRightGrid.getColIndexById("ORD_SEQ")).getValue();
  		      if ( max_ord_seq == "" ) max_ord_seq = 0;
		}

		curr_row_id    = curr_row_id + 1;
		max_ord_seq    = max_ord_seq + 1;
		erpRightGrid.addRow(curr_row_id);
		erpRightGrid.cells(curr_row_id, erpRightGrid.getColIndexById("ORD_SEQ")).setValue(max_ord_seq);
		
		$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
		
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
				, {id : "BCD_CD"           , label:["바코드"            , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "SUPR_CD"          , label:["협력사코드"        , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "SUPR_NM"          , label:["협력사명"          , "#text_filter"], type: "ro"  , width: "160", sort : "str", align : "left",   isHidden : true,  isEssential : false}
				, {id : "BCD_NM"           , label:["상품명"            , "#text_filter"], type: "ro"  , width: "250", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "DIMEN_NM"         , label:["규격"              , "#text_filter"], type: "ro"  , width:  "70", sort : "str", align : "left",   isHidden : false, isEssential : true}			
				, {id : "UNIT_NM"          , label:["단위"              , "#text_filter"], type: "ro"  , width:  "50", sort : "str", align : "left",   isHidden : false, isEssential : true}
				, {id : "DSCD_TYPE"        , label:["반품가능"          , "#text_filter"], type: "ro"  , width:  "70", sort : "str", align : "center", isHidden : false, isEssential : true}			
				, {id : "RETN_YN"          , label:["반품"              , "#text_filter"], type: "ro"  , width:  "50", sort : "str", align : "center", isHidden : true , isEssential : true}			
				, {id : "ORD_QTY"          , label:["수량"              , "#text_filter"], type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000.00"}			
				, {id : "PUR_PRICE"        , label:["단가"              , "#text_filter"], type: "ron" , width:  "70", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}			
				, {id : "SUPR_AMT"         , label:["공급가액"          , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "VAT_AMT"          , label:["부가세"            , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "TOT_AMT"          , label:["합계금액"          , "#text_filter"], type: "ron" , width: "100", sort : "str", align : "right",  isHidden : false, isEssential : true,  numberFormat : "0,000"}
				, {id : "REMK"             , label:["적요"              , "#text_filter"], type: "ro"  , width: "300", sort : "str", align : "right",  isHidden : false, isEssential : false}

				, {id : "ORGN_DIV_CD"      , label:["조직영역코드"      , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "ORGN_CD"          , label:["조직코드"          , "#text_filter"], type: "ro"  , width: "200", sort : "str", align : "left",   isHidden : true , isEssential : false}
				, {id : "ORD_NO"           , label:["발주번호"          , "#text_filter"], type: "ro"  , width: "100", sort : "str", align : "center", isHidden : true,  isEssential : false}
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
		
		/* onCellChanged onEditCell */ 
		erpRightGrid.attachEvent("onEditCell", function(stage,rId,cInd,nValue,oValue) {

			if ( stage == "2") {
			    var rowIdName =  erpRightGrid.getRowId(cInd);
			    
			    var ll_ORD_QTY   = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("ORD_QTY"   )).getValue();
			    var ll_PUR_PRICE = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("PUR_PRICE" )).getValue();

			    /* 원단위 절사 */
			    var ll_SUPR_AMT  = Math.floor(ll_ORD_QTY  *  ll_PUR_PRICE);
			    var ll_VAT       = Math.floor(ll_SUPR_AMT *  0.1);
			    var ll_TOT_AMT   = ll_SUPR_AMT +  ll_VAT;
			    
			    console.log( " ll_SUPR_AMT : " + ll_SUPR_AMT + " ll_VAT : " + ll_VAT);
			    
			    erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUPR_AMT"   )).setValue(ll_SUPR_AMT);
				erpRightGrid.cells(rId, erpRightGrid.getColIndexById("VAT_AMT"    )).setValue(ll_VAT);
				erpRightGrid.cells(rId, erpRightGrid.getColIndexById("TOT_AMT"    )).setValue(ll_TOT_AMT);

			    ll_SUPR_AMT   = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("SUPR_AMT" )).getValue();
			    ll_VAT        = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("VAT_AMT"  )).getValue();
			    console.log( " ll_SUPR_AMT : " + ll_SUPR_AMT + " ll_VAT : " + ll_VAT);
			    
				$erp.setDhtmlXGridFooterSummary(erpRightGrid,["SUPR_AMT","VAT_AMT","TOT_AMT"]);
			    return true;
			}
		    return true;
		});				
		
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
				, {id : "UNIT_NM"          , label:["단위"              , "#text_filter"], type: "ro"  , width:  "50", sort : "str", align : "left",   isHidden : false , isEssential : true}
				, {id : "DSCD_TYPE"        , label:["반품가능"          , "#text_filter"], type: "ro"  , width:  "70", sort : "str", align : "center", isHidden : false, isEssential : true}			
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

	/****************************************************************************/
    /* 추가버튼 신규입력을 위해  Document Body의 엘리먼트값을 초기화하고        */
    /* readonly 속성을 False한다                                                */
    /****************************************************************************/
	function addData(){
		$erp.clearInputInElement("table_search");
	}
	
	/***************************************************/
	/* 그리드 조회
	/***************************************************/
	function search_ErpRightGrid(){

		erpRightLayout.progressOn();
		
		var scrin_txtREQ_DATE  = document.getElementById("txtREQ_DATE").value;
		var scrn_CUSTMR_CD     = "";
		
		scrin_txtREQ_DATE      = scrin_txtREQ_DATE.replace (/-/g, "")
		
		$.ajax({
			url : "/sis/order/openOrderInputSearch.do"
			,data : {
				  "PARAM_ORGN_DIV_CD"  : GLOVAL_ORGN_DIV_CD   
				, "PARAM_ORGN_CD"      : GLOVAL_ORGN_CD
				, "PARAM_ORD_NO"       : LOGIN_ORD_NO
				, "PARAM_ORD_TYPE"     : "1"    /* 1:발주, 2:주문 */
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
						
						/***************************************************************************/
						/* 조회후 발주서 마스타 디자인 Ribbon부분의 값을 첫번째 값에서 찾아서 출력 */ 
						/***************************************************************************/
                        document.getElementById("txtREQ_DATE").value    = erpRightGrid.cells(1, erpRightGrid.getColIndexById("REQ_DATE"  )).getValue();
                        document.getElementById("txtORD_NO").value      = erpRightGrid.cells(1, erpRightGrid.getColIndexById("ORD_NO"    )).getValue();   /* 발주번호 */
                        document.getElementById("txtSUPR_CD").value     = erpRightGrid.cells(1, erpRightGrid.getColIndexById("SUPR_CD"   )).getValue();   /* 협력사코드 */
                        document.getElementById("Custmr_Name").value    = erpRightGrid.cells(1, erpRightGrid.getColIndexById("SUPR_NM"   )).getValue();   /* 협력사명 */
                        document.getElementById("txtRESP_USER").value   = erpRightGrid.cells(1, erpRightGrid.getColIndexById("RESP_USER" )).getValue();   /* 담당자코드 */
                        document.getElementById("RESP_USER_NAME").value = erpRightGrid.cells(1, erpRightGrid.getColIndexById("EMP_NM"    )).getValue();   /* 담당자명 */
                        document.getElementById("txtRESV_DATE").value   = erpRightGrid.cells(1, erpRightGrid.getColIndexById("RESV_DATE" )).getValue();   /* 납기일자 */
                        cmbIN_WARE_CD.setComboValue(erpRightGrid.cells(1, erpRightGrid.getColIndexById("IN_WARE_CD" )).getValue());
                        cmbORD_STATE.setComboValue(erpRightGrid.cells(1, erpRightGrid.getColIndexById("ORD_STATE" )).getValue());                           /* 발주진행상태 */

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
	
	/*****************************************/
	/*  발주서 등록                         */
	/*****************************************/
	function addErpGrid(){
		openCustomerinputPopup(null);
	}
		
	/***************************************************/
	/* 그리드 삭제 
	/***************************************************/
	function deleteErpGrid(){
		var gridRowCount = erpRightGrid.getRowsNum();
		var isChecked = false;
		
		var deleteRowIdArray = [];
		for(var i = 0; i < gridRowCount; i++){
			var rId = erpRightGrid.getRowId(i);
			var check = erpRightGrid.cells(rId, erpRightGrid.getColIndexById("CHECK")).getValue();
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
			erpRightGrid.deleteRow(deleteRowIdArray[i]);
		}
		
		$erp.setDhtmlXGridFooterRowCount(erpRightGrid);
	}
	
	/*********************************************************/
	/* 발주서 저장  C,U,D
	/*********************************************************/
	function save_ErpRightGrid(){
		
		var ls_in_ware_cd        = cmbIN_WARE_CD.getSelectedValue();
		var erpRightGridRowCount = erpRightGrid.getRowsNum();
		
		if ( erpRightGridRowCount <= 0 ) {
			$erp.alertMessage({
				"alertMessage" : "저장할 Data가 존재하지 않습니다.",
				"alertCode" : "입력할 Data없음",
				"alertType" : "error",
				"isAjax" : false,
			});
			return;
		}
		
		if ( !ls_in_ware_cd ) {
			$erp.alertMessage({
				"alertMessage" : "입고창고를 선택해주세요.",
				"alertCode" : "입고창고 미선택",
				"alertType" : "error",
				"isAjax" : false,
			});
			return;
		}

		var HEAD = $erp.dataSerialize("aaa");
		console.log(HEAD);
		var BODY = $erp.dataSerializeOfGridByMode(erpRightGrid,"all");   // all(전체)  state( CUD 변경부문만 처리) 
		console.log(BODY);
		
		var url = "/sis/order/OrderInputCUD.do";
		
		var send_data = {"HEAD":HEAD, "BODY":BODY};   /*  LIST MAP구조로 Controller로 넘긴다 */
		
		var if_success = function(data){
			erpRightLayout.progressOff();
			if($erp.isEmpty(data.result)){
				erpRightLayout.progressOff();
				
				/* 신규등록인경우 생성된 발주서번호로 재조회한다 */ 
				if( !LOGIN_ORD_NO ){
					document.getElementById("txtORD_NO").value=data.resulOrderNumber;
					LOGIN_ORD_NO = data.resulOrderNumber;
				}

				$erp.alertSuccessMesage(onAfterSaveErpRightGrid);
		
			}else{
				erpRightLayout.progressOff();
				if(data.result == BODY.length){
					$erp.alertSuccessMesage(onAfterSaveErpRightGrid);
					console.log("성공");
				}
			}
		}
		
		var if_error = function(data){
			erpRightLayout.progressOff();
			$erp.ajaxErrorMessage(data);
		}
		
		erpRightLayout.progressOn();
		
		$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpLayout);

	}
	
	/*********************************************************/
	/* 발주상품 저장후 재조회
	/*********************************************************/
	function onAfterSaveErpRightGrid(){
		search_ErpRightGrid();
	}
	
	
  	/****************************************************************************/
    /*  상품가격 팝업조회                                                       */
    /****************************************************************************/	
	openGoodsPricePopup = function(onRowDblClicked, onClickAddData) {

  		var onComplete = function(){
			var openPopupWindow = erpPopupWindows.window("openGoodsPricePopup");
			if(openPopupWindow){
				openPopupWindow.close();
			}        
		}
		
		var onConfirm = function(){
		}
  		
  		/*****************************************************************************************************/
  		/* ※ 이부분은 아주중요함  CUST_DIV_CD파라미터는 단가를 가져오는 구분자임                             */ 
  		/* 발주를 요청하는 조직구분, 조직(입고창고) : ORGN_DIV_CD  , ORGN_CD => 센터에서 발주요청하므로 B01  */ 
  		/* 협력사(공급사) 조직구분이 외부공급사여야함 : OUT으로 세팅                                         */
  		/*****************************************************************************************************/
  		var url    = "/sis/order/openGoodsPricePopup.sis";
		var params = {  "ORGN_DIV_CD" : GLOVAL_ORGN_DIV_CD,  "ORGN_CD" : GLOVAL_ORGN_CD , "CALL_CHANNEL" : "S" , "CUST_DIV_CD" :  "OUT" }
		var option = {
				  "width"  : 1000
				, "height" : 700
				, "win_id" : "openGoodsPricePopup"
		}
		
		var onContentLoaded = function(){
			var popWin = this.getAttachedObject().contentWindow;
	        if(onRowDblClicked && typeof onRowDblClicked === 'function'){
	            while(popWin.erpPopupOrderOnRowSelect == undefined){
	                popWin.erpPopupOrderOnRowSelect = onRowDblClicked;    
	            }
	        }
	        
	        if(onClickAddData && typeof onClickAddData === 'function'){
	        	while(popWin.erpPopupOrderCheckList == undefined){
	        		popWin.erpPopupOrderCheckList = onClickAddData;
	        	}
	        }

	        if(onComplete && typeof onComplete === 'function'){
				while(popWin.thisOnComplete == undefined){
					popWin.thisOnComplete = onComplete;    
				}
			}
	        
	        this.progressOff();
	    }
		
		$erp.openPopup(url, params, onContentLoaded, option);
	}
  	
	/**************************************************
	* 기타 영역
	**************************************************/

	
	/***************************************************/
	/* COMBO박스처리 
	/***************************************************/
	function initDhtmlXCombo(){
		//cmbUSE_YN  = $erp.getDhtmlXCombo('cmbUSE_YN', 'USE_YN', ['YN_CD','YN'], 120, true);
		/* 입고창고 */
		cmbIN_WARE_CD  = $erp.getDhtmlXComboCommonCode('cmbIN_WARE_CD',     'cmbIN_WARE_CD',    ["ORGN_CD","CT"],     135,  "",  true, cmbIN_WARE_CD);
    	$erp.objReadonly("cmbIN_WARE_CD");  /* Combo박스 손을 못되게 한다 */

		/* 발주진행상태 */
		cmbORD_STATE   = $erp.getDhtmlXComboCommonCode('cmbORD_STATE',   'cmbORD_STATE',  'ORD_STATE',   177,  "",  true, cmbORD_STATE);
    	$erp.objReadonly("cmbORD_STATE");  /* Combo박스 손을 못되게 한다 */

	
		cmbIN_WARE_CD.attachEvent("onChange", function(name, value){
			getLoginOrgInfo(name);
		}); 
	
	}
	
	/******************************************************************************/
	/* 센터, 본사조직으로 login후 COMBO박스의 입고창고가 바뀐경우 조직영역 구하기 
	/******************************************************************************/
	function getLoginOrgInfo(ORGN_CD){
		var erpRightGridRowCount = erpRightGrid.getRowsNum();
		
		erpRightLayout.progressOn();
		$.ajax({
			url : "/sis/order/getSelectedOrgInfo.do"
			,data : { "PARAM_ORGN_CD"  : ORGN_CD }
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpRightLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					GLOVAL_ORGN_DIV_CD    =   data.gridDataList.ORGN_DIV_CD;
					GLOVAL_ORGN_DIV_NM    =   data.gridDataList.ORGN_DIV_CD_NM;
					GLOVAL_ORGN_DIV_TYP   =   data.gridDataList.ORGN_DIV_TYPE;
			        GLOVAL_ORGN_CD        =   data.gridDataList.DEPT_CD;
			        GLOVAL_ORGN_NM        =   data.gridDataList.ORGN_NM;
			    	    
					console.log("GLOVAL_ORGN_DIV_CD=>"   + GLOVAL_ORGN_DIV_CD);          
					console.log("GLOVAL_ORGN_DIV_NM=>"   + GLOVAL_ORGN_DIV_NM);          
					console.log("GLOVAL_ORGN_DIV_TYP=>"  + GLOVAL_ORGN_DIV_TYP);          
					console.log("GLOVAL_ORGN_CD=>"       + GLOVAL_ORGN_CD);          
					console.log("GLOVAL_ORGN_NM=>"       + GLOVAL_ORGN_NM);          
					
					/* 본사OR센타조직으로 로그인시 입고창고를 바꾸면  들어가 있는 데이타가의 첫번째Row(HEAD)만 바꾼다 */
					if ( erpRightGridRowCount > 0) {
						 erpRightGrid.cells(1, erpRightGrid.getColIndexById("ORGN_DIV_CD" )).setValue(GLOVAL_ORGN_DIV_CD);
						 erpRightGrid.cells(1, erpRightGrid.getColIndexById("ORGN_CD"     )).setValue(GLOVAL_ORGN_CD);
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}			
	
	
	<%-- ■ dhtmlXCombo 관련 Function 끝 --%>
</script>
</head>
<body>				
	 <div id="div_erp_contents_search" class="samyang_div" style="display:none">
	 	  <table class="table_search" id="aaa">
			  <colgroup>
				  <col width="100px">
				  <col width="100px">
				  <col width="50px">
			
				  <col width="100px">	
				  <col width="100px">
				  <col width="80px">	
				
				  <col width="100px">
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
					  <input type="text" id="txtRESV_DATE" name="SearchdelStrDt" class="input_common input_calendar">
				  </td>
				
				  <th>입고창고</th>
				  <td colspan="2">
				      <div id="cmbIN_WARE_CD"></div>
				  </td>
				
				  <th>진행상태</th>
				  <td>
				      <div id="cmbORD_STATE"></div>
				  </td>
			  </tr>
			  
			  
			  <tr>
				  <th>주문마감시간</th>
				  <td colspan="2"><input type="text" id="OrderDeadTimeLeadTime" name="OrderDeadTimeLeadTime" readonly="readonly"  disabled="disabled" class="input_common" style="width:70px;"></td>

				  <th>리드타임</th>
				  <td colspan="2"><input type="text" id="BusinessDay" name="BusinessDay" readonly="readonly"  disabled="disabled" class="input_common" maxlength="20" ></td>
			  
				  <th>메모</th>
				  <td colspan="4"><input type="text" id="txtMEMO" name="MEMO" class="input_common" maxlength="100" style="width:532px;"></td>
			  </tr>
			
	 	  </table>
	 </div>
	 <div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	 <div id="div_erp_grid"   class="div_grid_full_size"   style="display:none"></div>
</body>

	
</html>