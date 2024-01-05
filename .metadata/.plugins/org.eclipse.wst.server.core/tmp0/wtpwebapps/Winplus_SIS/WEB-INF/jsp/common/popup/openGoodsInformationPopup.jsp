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
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpPopupWindowsCell : Object / 시스템 팝업 윈도우 Cell DhtmlxWindowsCell; 
		■ erpPopupLayout : Object / 페이지 Layout DhtmlxLayout
		■ erpPopupTabbar : Object / 페이지 Tabbar DhtmlxTabbar
		■ erpPopupTabLayout1 : Object / 상품정보 탭 Layout DhtmlxLayout
		■ erpPopupRibbon1 : Object / 상품정보 리본형 버튼 목록 DhtmlXRibbon
		■ erpPopupGrid1 : Object / 상품정보 바코드 조회 DhtmlXGrid
		■ erpPopupGrid1Columns : Array / 바코드 그리드 컬럼정보 DhtmlXGrid Header
		
		■ crud : String / CRUD 구분용
		■ cmbGOODS_STATE : Object / 상품상태여부 DhtmlXCombo (공통코드 : YN_CD)
		■ cmbTAX_TYPE : Object / 과세여부 DhtmlXCombo (공통코드 : GOODS_TAX_YN)
		■ cmbGOODS_PUR_CD : Object / 상품유형 DhtmlXCombo (공통코드 : PUR_TYPE)
		■ cmbGOODS_SALE_TYPE : Object / 판매유형 DhtmlXCombo (공통코드 : GOODS_SALES_TYPE)
		■ cmbGOODS_STOCK_TYPE : Object / 재고관리유형 DhtmlXCombo (공통코드 : GOODS_MNG_TYPE)
		■ cmbMAT_TEMPER_INFO : Object / 품온정보 DhtmlXCombo (공통코드 : MAT_TEMPER_INFO)
	--%>
	var erpPopupWindowsCell = parent.erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
	var erpPopupLayout;
	var erpPopupTabbar;
	var erpPopupTabLayout1;
	var erpPopupTabSubLayout1
	var erpPopupTabLayout2;
	var erpPopupTabLayout3;
	var erpPopupTabLayout4;
	var erpPopupTabLayout5;
	var erpPopupRibbon1;
	var erpPopupRibbon2;
	var erpPopupRibbon3;
	var erpPopupRibbon4;
	var erpPopupRibbon5;
	var erpPopupGrid1;
	var erpPopupGrid2;
	var erpPopupGrid3;
	var erpPopupGrid4;
	var erpPopupGrid5;
	var erpPopupGrid1Columns;
	var erpPopupGrid2Columns;
	var erpPopupGrid3Columns;
	var erpPopupGrid4Columns;
	var erpPopupGrid5Columns;
	
	var cmbORGN_CD_tab_2;
	var cmbORGN_CD_tab_3;
	var cmbORGN_CD_tab_4;
	
	var tab_1_table_1_2;
	var tab_1_table_1_3;
	var tab_1_table_1_4;
	var tab_1_table_1_5;
	
	var crud;
	var sel_goods_no;
	var sel_bcd_cd;
	var cmbGOODS_STATE;
	var cmbTAX_TYPE;
	var cmbGOODS_PUR_CD;
	var cmbGOODS_SALE_TYPE;
	var cmbGOODS_STOCK_TYPE;
	var cmbMAT_TEMPER_INFO;
	var cmbITEM_TYPE;
	var cmbPB_TYPE;
	var cmbGOODS_SET_TYPE;
	var cmbGOODS_EXP_TYPE;
	var cmbUSE_EXP_TYPE;
	var cmbDELI_DD_YN;
	var cmbDELI_AREA_YN;
	var cmbGOODS_EXP_CD;
	var cmbGOODS_TC_TYPE;
	var cmbPUR_DSCD_TYPE;
	var cmbSALE_DSCD_TYPE;
	var cmbSTORE_TYPE;
	var cmbBRAND_TYPE;
	var cmbPOLI_TYPE;
	var cmbRESP_USER;
	var goodsFileName1;
	var goodsFileName2;
	var goodsFileName3;
	
	$(document).ready(function(){
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("상품정보");
		}
		
		initErpPopupLayout();
		initErpPopupTabbar();
		initErpPopupTabLayout1();
		initErpPopupTabSubLayout1();
		initErpPopupRibbon1();
		initErpPopupGrid1();
		initErpPopupTabLayout2();
		initErpPopupRibbon2();
		initErpPopupGrid2();
		initErpPopupTabLayout3();
		initErpPopupRibbon3();
		initErpPopupGrid3();
		initErpPopupTabLayout4();
		initErpPopupRibbon4();
		initErpPopupGrid4();
		initErpPopupTabLayout5();
		initErpPopupRibbon5();
		initErpPopupGrid5();
		
		crud = "${CRUD}";
		sel_goods_no = "${GOODS_NO}";
		sel_bcd_cd = "${BCD_CD}";
		
		initDhtmlXCombo();
		cmbGOODS_EXP_CD.disable();
		
		tab_1_table_1_2 = document.getElementById("tab_1_table_1_2");
		tab_1_table_1_3 = document.getElementById("tab_1_table_1_3");
		tab_1_table_1_4 = document.getElementById("tab_1_table_1_4");
		tab_1_table_1_5 = document.getElementById("tab_1_table_1_5");
		
		
		$("#txtGOODS_FEE_AMT").keydown(function(key) {
			var returnValue = false;
			if ((key.keyCode >= 48 && key.keyCode <= 57)) {
				returnValue = true;
			}else if ((key.keyCode >= 96 && key.keyCode <= 105)) {
				returnValue = true;
			}else if(key.keyCode == 190 || key.keyCode == 110){
				returnValue = true;
			}else if(key.keyCode == 8 || key.keyCode == 9){
				returnValue = true;
			}
			
			return returnValue;
		});
		
		$("#txtPOINT_SAVE_RATE").keydown(function(key) {
			var returnValue = false;
			if ((key.keyCode >= 48 && key.keyCode <= 57)) {
				returnValue = true;
			}else if ((key.keyCode >= 96 && key.keyCode <= 105)) {
				returnValue = true;
			}else if(key.keyCode == 190 || key.keyCode == 110){
				returnValue = true;
			}else if(key.keyCode == 8 || key.keyCode == 9){
				returnValue = true;
			}
			
			return returnValue;
		});
		
		$erp.asyncObjAllOnCreated(function(){
			if(crud == "U"){
				document.getElementById("txtGOODS_NO").value = sel_goods_no;
				searchErpPopupTab1();
			}
		});
	});
	
	function setDomObj(UNIT_CD){
		if (UNIT_CD == 'Q02' || UNIT_CD == 'Q01' || UNIT_CD == 'Q05' || UNIT_CD == 'Q06' || UNIT_CD == 'W01' || UNIT_CD == 'W02'){ //EA, g, 기획, 낱개, 선물세트
			tab_1_table_1_2.innerHTML = '' +
				'<tr>'+
					'<th colspan="5" style = "text-align:center; width: 250px; padding-top: 15px; padding-bottom: 20px;">이미지 정보 업로드</th>'+
				'</tr>'+
				'<tr>'+
					'<th style = "text-align:left; width: 50px; padding-left: 25px;">상품</th>'+
					'<td style = "width:65px;">'+
						'<input type="file" accept=".gif, .jpg, .png" id="fileGoodsImage" name= "goodsImage" class="input_essential" value="첨부" onchange="uploadGoodsImage(this);" style="width: 73px;"/>&nbsp;/&nbsp;'+
						'<input type="button" id="" class="input_common_button" value="삭제" onclick="deleteImg(' + '\'uploadGoodsImage1\'' + ');" />'+
					'</td>'+
				'</tr>'+
				'<tr>'+
					'<th style = "text-align:left; width: 50px; padding-left: 25px;">상품설명</th>'+
					'<td>'+
						'<input type="file" accept=".gif, .jpg, .png" id="fileGoodsExplImage" name= "goodsExpl" class="input_essential" value="첨부" onchange="uploadGoodsImage(this);" style="width: 73px;" />&nbsp;/&nbsp;'+
						'<input type="button" id="" class="input_common_button" value="삭제" onclick="deleteImg(' + '\'uploadGoodsImage2\'' + ');" />'+
					'</td>'+
				'</tr>'+
				'<tr>'+
					'<th style = "text-align:left; width: 50px; padding-left: 25px;">상품바코드</th>'+
					'<td>'+
						'<input type="file"accept=".gif, .jpg, .png"  id="fileGoodsBcdImage" name= "goodsBcd" class="input_essential" value="첨부" onchange="uploadGoodsImage(this);" style="width: 73px;" />&nbsp;/&nbsp;'+
						'<input type="button" id="" class="input_common_button" value="삭제" onclick="deleteImg(' + '\'uploadGoodsImage3\'' + ');" />'+
					'</td>'+
				'</tr>'
			
			tab_1_table_1_3.innerHTML = '' +
				'<tr>'+
					'<th style = "text-align:center;">상품이미지</th>'+
				'</tr>'+
				'<tr>'+
					'<td style = "width :230px; height:160px;">'+
						'<img id = "uploadGoodsImage1" style = "width :250px; height:160px;"/>'+
					'</td>'+
				'</tr>'
			tab_1_table_1_4.innerHTML = '' +
				'<tr>'+
					'<th style = "text-align:center;">상품설명 이미지</th>'+
				'</tr>'+
				'<tr>'+
					'<td style = "width :230px; height:160px;">'+
						'<img id="uploadGoodsImage2" style = "width :250px; height:160px;"/>'+
					'</td>'+
				'</tr>'
			tab_1_table_1_5.innerHTML = '' +
				'<tr>'+
					'<th style = "text-align:center;">상품바코드 이미지</th>'+
				'</tr>'+
				'<tr>'+
					'<td style = "width :230px; height:160px;">'+
						'<img id="uploadGoodsImage3" style = "width :250px; height:160px;"/>'+
					'</td>'+
				'</tr>'
		}else if (UNIT_CD == 'Q03'){ //박스
			tab_1_table_1_2.innerHTML = '' +
				'<tr>'+
					'<th colspan="5" style = "text-align:center; width: 250px; padding-top: 15px; padding-bottom: 20px;">이미지 정보 업로드</th>'+
				'</tr>'+
				'<tr>'+
					'<th style = "text-align:left; width: 50px; padding-left: 25px;">박스</th>'+
					'<td style = "width:65px;">'+
						'<input type="file" accept=".gif, .jpg, .png" id="fileGoodsImage" name= "goodsImage" class="input_essential" value="첨부" onchange="uploadGoodsImage(this);" style="width: 73px;"/>&nbsp;/&nbsp;'+
						'<input type="button" id="" class="input_common_button" value="삭제" onclick="deleteImg(' + '\'uploadGoodsImage1\'' + ');" />'+
					'</td>'+
				'</tr>'+
				'<tr>'+
					'<th style = "text-align:left; width: 50px; padding-left: 25px;">박스설명</th>'+
					'<td>'+
						'<input type="file" accept=".gif, .jpg, .png" id="fileGoodsExplImage" name= "goodsExpl" class="input_essential" value="첨부" onchange="uploadGoodsImage(this);" style="width: 73px;" />&nbsp;/&nbsp;'+
						'<input type="button" id="" class="input_common_button" value="삭제" onclick="deleteImg(' + '\'uploadGoodsImage2\'' + ');" />'+
					'</td>'+
				'</tr>'+
				'<tr>'+
					'<th style = "text-align:left; width: 50px; padding-left: 25px;">박스바코드</th>'+
					'<td>'+
						'<input type="file" accept=".gif, .jpg, .png" id="fileGoodsBcdImage" name= "goodsBcd" class="input_essential" value="첨부" onchange="uploadGoodsImage(this);" style="width: 73px;" />&nbsp;/&nbsp;'+
						'<input type="button" id="" class="input_common_button" value="삭제" onclick="deleteImg(' + '\'uploadGoodsImage3\'' + ');" />'+
					'</td>'+
				'</tr>'
			tab_1_table_1_3.innerHTML = '' +
				'<tr>'+
					'<th style = "text-align:center;">박스이미지</th>'+
				'</tr>'+
				'<tr>'+
					'<td style = "width :230px; height:160px;">'+
						'<img id = "uploadGoodsImage1" style = "width :250px; height:160px;"/>'+
					'</td>'+
				'</tr>'
			tab_1_table_1_4.innerHTML = '' +
				'<tr>'+
					'<th style = "text-align:center;">박스설명 이미지</th>'+
				'</tr>'+
				'<tr>'+
					'<td style = "width :230px; height:160px;">'+
						'<img id="uploadGoodsImage2" style = "width :250px; height:160px;"/>'+
					'</td>'+
				'</tr>'
			tab_1_table_1_5.innerHTML = '' +	
				'<tr>'+
					'<th style = "text-align:center;">박스바코드 이미지</th>'+
				'</tr>'+
				'<tr>'+
					'<td style = "width :230px; height:160px;">'+
						'<img id="uploadGoodsImage3" style = "width :250px; height:160px;"/>'+
					'</td>'+
				'</tr>'
		}else if (UNIT_CD == 'Q04'){ //번들
			tab_1_table_1_2.innerHTML = '' +
			'<tr>'+
				'<th colspan="5" style = "text-align:center; width: 250px; padding-top: 15px; padding-bottom: 20px;">이미지 정보 업로드</th>'+
			'</tr>'+
			'<tr>'+
				'<th style = "text-align:left; width: 50px; padding-left: 25px;">번들</th>'+
				'<td style = "width:65px;">'+
					'<input type="file" accept=".gif, .jpg, .png" id="fileGoodsImage" name= "goodsImage" class="input_essential" value="첨부" onchange="uploadGoodsImage(this);" style="width: 73px;"/>&nbsp;/&nbsp;'+
					'<input type="button" id="" class="input_common_button" value="삭제" onclick="deleteImg(' + '\'uploadGoodsImage1\'' + ');" />'+
				'</td>'+
			'</tr>'+
			'<tr>'+
				'<th style = "text-align:left; width: 50px; padding-left: 25px;">번들설명</th>'+
				'<td>'+
					'<input type="file" accept=".gif, .jpg, .png" id="fileGoodsExplImage" name= "goodsExpl" class="input_essential" value="첨부" onchange="uploadGoodsImage(this);" style="width: 73px;" />&nbsp;/&nbsp;'+
					'<input type="button" id="" class="input_common_button" value="삭제" onclick="deleteImg(' + '\'uploadGoodsImage2\'' + ');" />'+
				'</td>'+
			'</tr>'+
			'<tr>'+
				'<th style = "text-align:left; width: 50px; padding-left: 25px;">번들바코드</th>'+
				'<td>'+
					'<input type="file" accept=".gif, .jpg, .png" id="fileGoodsBcdImage" name= "goodsBcd" class="input_essential" value="첨부" onchange="uploadGoodsImage(this);" style="width: 73px;" />&nbsp;/&nbsp;'+
					'<input type="button" id="" class="input_common_button" value="삭제" onclick="deleteImg(' + '\'uploadGoodsImage3\'' + ');" />'+
				'</td>'+
			'</tr>'
		tab_1_table_1_3.innerHTML = '' +
			'<tr>'+
				'<th style = "text-align:center;">번들이미지</th>'+
			'</tr>'+
			'<tr>'+
				'<td style = "width :230px; height:160px;">'+
					'<img id = "uploadGoodsImage1" style = "width :250px; height:160px;"/>'+
				'</td>'+
			'</tr>'
		tab_1_table_1_4.innerHTML = '' +
			'<tr>'+
				'<th style = "text-align:center;">번들설명 이미지</th>'+
			'</tr>'+
			'<tr>'+
				'<td style = "width :230px; height:160px;">'+
					'<img id="uploadGoodsImage2" style = "width :250px; height:160px;" />'+
				'</td>'+
			'</tr>'
		tab_1_table_1_5.innerHTML = '' +	
			'<tr>'+
				'<th style = "text-align:center;">번들바코드 이미지</th>'+
			'</tr>'+
			'<tr>'+
				'<td style = "width :230px; height:160px;">'+
					'<img id="uploadGoodsImage3" style = "width :250px; height:160px;"/>'+
				'</td>'+
			'</tr>'
		}else if (UNIT_CD == 'Q05'){ //보루
			tab_1_table_1_2.innerHTML = '' +
			'<tr>'+
				'<th colspan="5" style = "text-align:center; width: 250px; padding-top: 15px; padding-bottom: 20px;">이미지 정보 업로드</th>'+
			'</tr>'+
			'<tr>'+
				'<th style = "text-align:left; width: 50px; padding-left: 25px;">보루</th>'+
				'<td style = "width:65px;">'+
					'<input type="file" accept=".gif, .jpg, .png" id="fileGoodsImage" name= "goodsImage" class="input_essential" value="첨부" onchange="uploadGoodsImage(this);" style="width: 73px;"/>&nbsp;/&nbsp;'+
					'<input type="button" id="" class="input_common_button" value="삭제" onclick="deleteImg(' + '\'uploadGoodsImage1\'' + ');" />'+
				'</td>'+
			'</tr>'+
			'<tr>'+
				'<th style = "text-align:left; width: 50px; padding-left: 25px;">보루설명</th>'+
				'<td>'+
					'<input type="file" accept=".gif, .jpg, .png" id="fileGoodsExplImage" name= "goodsExpl" class="input_essential" value="첨부" onchange="uploadGoodsImage(this);" style="width: 73px;" />&nbsp;/&nbsp;'+
					'<input type="button" id="" class="input_common_button" value="삭제" onclick="deleteImg(' + '\'uploadGoodsImage2\'' + ');" />'+
				'</td>'+
			'</tr>'+
			'<tr>'+
				'<th style = "text-align:left; width: 50px; padding-left: 25px;">보루바코드</th>'+
				'<td>'+
					'<input type="file" accept=".gif, .jpg, .png" id="fileGoodsBcdImage" name= "goodsBcd" class="input_essential" value="첨부" onchange="uploadGoodsImage(this);" style="width: 73px;" />&nbsp;/&nbsp;'+
					'<input type="button" id="" class="input_common_button" value="삭제" onclick="deleteImg(' + '\'uploadGoodsImage3\'' + ');" />'+
				'</td>'+
			'</tr>'
		tab_1_table_1_3.innerHTML = '' +
			'<tr>'+
				'<th style = "text-align:center;">보루이미지</th>'+
			'</tr>'+
			'<tr>'+
				'<td style = "width :230px; height:160px;">'+
					'<img id = "uploadGoodsImage1" style = "width :250px; height:160px;"/>'+
				'</td>'+
			'</tr>'
		tab_1_table_1_4.innerHTML = '' +
			'<tr>'+
				'<th style = "text-align:center;">보루설명 이미지</th>'+
			'</tr>'+
			'<tr>'+
				'<td style = "width :230px; height:160px;">'+
					'<img id="uploadGoodsImage2" style = "width :250px; height:160px;"/>'+
				'</td>'+
			'</tr>'
		tab_1_table_1_5.innerHTML = '' +	
			'<tr>'+
				'<th style = "text-align:center;">보루바코드 이미지</th>'+
			'</tr>'+
			'<tr>'+
				'<td style = "width :230px; height:160px;">'+
					'<img id="uploadGoodsImage3" style = "width :250px; height:160px;"/>'+
				'</td>'+
			'</tr>'
		}
	}
	
	function deleteImg(imgId){
		var selectedRowId = erpPopupGrid1.getCheckedRows(erpPopupGrid1.getColIndexById("SELECT"));
		var FILE_GRUP_NO = erpPopupGrid1.cells(selectedRowId, erpPopupGrid1.getColIndexById("FILE_GRUP_NO")).getValue();
		
		$erp.confirmMessage({
			"alertMessage" : "이미지 정보가 삭제됩니다.<br>진행하시겠습니까?",
			"alertType" : "alert",
			"isAjax" : false,
			"alertCallbackFn" : function confirmAgain(){
				var params = {
					"FILE_GRUP_NO" : FILE_GRUP_NO
					, "FILE_SEQ" : $('#'+imgId).attr('FILE_SEQ')
					, "FILE_ORG_NM" : $('#'+imgId).attr('FILE_ORG_NM')
				};
				var url = "/common/system/file/deleteAttachGoodsImageFile.do";
				var send_data = params;
				var if_success = function(data){
					console.log(data.gridDataList);
					var parent = $('#'+imgId)[0].parentNode;
					$('#'+imgId).remove();
					parent.innerHTML = '<img id="' + imgId + '" style = "width :250px; height:160px;"/>';
				}
				
				var if_error = function(XHR, status, error){}
				
				$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpPopupTabLayout1);
			}
		});
	}
	
	<%-- ■ erpPopupLayout 초기화 시작 --%>
	function initErpPopupLayout() {
		erpPopupLayout = new dhtmlXLayoutObject({
			parent : document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "1C"
			, cells: [
				{id: "a", text: "전체영역", header:false, fix_size:[true, false]}
			]
		});
		erpPopupLayout.cells("a").attachObject("div_erp_popup_tabbar");
	}
	<%-- ■ erpPopupLayout 초기화 끝 --%>
	
	<%-- ■ erpPopupTabbar 초기화 시작 --%>
	function initErpPopupTabbar(){
		erpPopupTabbar = new dhtmlXTabBar({
			parent : "div_erp_popup_tabbar"
			, skin : ERP_TABBAR_CURRENT_SKINS
			, close_button : false
			, tabs : [
						{id: "erp_popup_tab_1", text: "상품정보", active: 1}
						,{id: "erp_popup_tab_2", text: "매입정보", active: 2}
						,{id: "erp_popup_tab_3", text: "판매정보", active: 3}
						,{id: "erp_popup_tab_4", text: "재고정보", active: 4}
						,{id: "erp_popup_tab_5", text: "변경로그", active: 5}
					]
		}); 
		
		erpPopupTabbar.tabs("erp_popup_tab_1").attachObject("div_erp_popup_tab_1");
		erpPopupTabbar.tabs("erp_popup_tab_2").attachObject("div_erp_popup_tab_2");
		erpPopupTabbar.tabs("erp_popup_tab_3").attachObject("div_erp_popup_tab_3");
		erpPopupTabbar.tabs("erp_popup_tab_4").attachObject("div_erp_popup_tab_4");
		erpPopupTabbar.tabs("erp_popup_tab_5").attachObject("div_erp_popup_tab_5");
	}
	<%-- ■ erpPopupTabbar 초기화 끝 --%>
	
	
	<%-- ■ initErpPopupTabLayout1 초기화  시작 --%>
	function initErpPopupTabLayout1() {
		erpPopupTabLayout1 = new dhtmlXLayoutObject({
			parent: "div_erp_popup_tab_1"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4E"
			, cells: [
				{id: "a", text: "리본영역", header:false, fix_size:[true, true]}
				,{id: "b", text: "컨텐츠영역", header:false, fix_size:[true, true]}
				,{id: "c", text: "컨텐츠영역2", header:false, fix_size:[true, true]}
				,{id: "d", text: "그리드영역", header:false, fix_size:[true, true]}
			]
		})
		
		erpPopupTabLayout1.cells("a").attachObject("div_erp_popup_ribbon_1");
		erpPopupTabLayout1.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupTabLayout1.cells("b").attachObject("div_erp_popup_tab_1_tb_1");
		erpPopupTabLayout1.cells("b").setHeight($erp.getTableHeight(6)+110);
		erpPopupTabLayout1.cells("c").attachObject("div_erp_popup_tab_1_tb_2");
		erpPopupTabLayout1.cells("c").setHeight($erp.getTableHeight(5)+50);
		erpPopupTabLayout1.cells("d").attachObject("div_erp_popup_grid_1");
	}
	<%-- ■ initErpPopupTabLayout1 초기화  끝  --%>
	
	<%-- ■ initErpPopupTabLayout1 초기화  시작 --%>
	function initErpPopupTabSubLayout1() {
		erpPopupTabSubLayout1 = new dhtmlXLayoutObject({
			parent: "div_erp_popup_tab_1_tb_2"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4W"
			, cells: [
				{id: "a", text: "컨텐츠영역2_1", header:false, fix_size:[true, true]}
				,{id: "b", text: "컨텐츠영역2_2", header:false, fix_size:[true, true]}
				,{id: "c", text: "컨텐츠영역2_3", header:false, fix_size:[true, true]}
				,{id: "d", text: "컨텐츠영역2_4", header:false, fix_size:[true, true]}
			]
		})
		
		erpPopupTabSubLayout1.cells("a").attachObject("div_erp_popup_tab_1_tb_2_1");
		erpPopupTabSubLayout1.cells("a").setHeight($erp.getTableHeight(5)+60);
		erpPopupTabSubLayout1.cells("b").attachObject("div_erp_popup_tab_1_tb_2_2");
		erpPopupTabSubLayout1.cells("b").setHeight($erp.getTableHeight(5)+60);
		erpPopupTabSubLayout1.cells("c").attachObject("div_erp_popup_tab_1_tb_2_3");
		erpPopupTabSubLayout1.cells("c").setHeight($erp.getTableHeight(5)+60);
		erpPopupTabSubLayout1.cells("d").attachObject("div_erp_popup_tab_1_tb_2_4");
		erpPopupTabSubLayout1.cells("d").setHeight($erp.getTableHeight(5)+60);
		
	}
	<%-- ■ initErpPopupTabLayout1 초기화  끝  --%>
	
	<%-- ■ erpPopupRibbon1 관련 Function 시작 --%>
	<%-- erpPopupRibbon1 초기화 Function --%>
	function initErpPopupRibbon1(){
		erpPopupRibbon1 = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon_1"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpPopup1", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					//,{id : "add_erpPopup1", type : "button", text:'<spring:message code="ribbon.add" />', isbig : false, img : "menu/add.gif", imgdis : "menu/add_dis.gif", disable : true}
					,{id : "delete_erpPopup1", type : "button", text:'<spring:message code="ribbon.delete" />', isbig : false, img : "menu/delete.gif", imgdis : "menu/delete_dis.gif", disable : true}
					,{id : "save_erpPopup1", type : "button", text:'<spring:message code="ribbon.save" />', isbig : false, img : "menu/save.gif", imgdis : "menu/save_dis.gif", disable : true}
					//,{id : "excel_erpPopup1", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					//,{id : "print_erpPopup1", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}	
				]}
			]
		});
		
		erpPopupRibbon1.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpPopup1"){
				searchErpPopupTab1();
			} else if (itemId == "add_erpPopup1"){
				crud = "C";
				document.getElementById("hidGRUP_CD").value = "";
				var tab1Tb1Data = document.getElementById("tab_1_table_1");
				var tab1Tb2Data = document.getElementById("tab_1_table_1_2");
				var tab1Tb3Data = document.getElementById("tab_1_table_1_3");
				var tab1Tb4Data = document.getElementById("tab_1_table_1_4");
				var tab1Tb5Data = document.getElementById("tab_1_table_1_5");
				$erp.clearInputInElement(tab1Tb1Data);
				$erp.clearDhtmlXGrid(erpPopupGrid1);
			} else if (itemId == "delete_erpPopup1"){
				deleteErpPopupTab1();
			} else if (itemId == "save_erpPopup1"){
				saveErpPopupTab1();
			} else if (itemId == "excel_erpPopup1"){
			} else if (itemId == "print_erpPopup1"){
			}
		});
	}
	<%-- ■ erpPopupRibbon1 관련 Function 끝 --%>
	
	<%-- ■ erpPopupGrid1 관련 Function 시작 --%>
	<%-- erpPopupGrid1 초기화 Function --%>
	function initErpPopupGrid1(){
		erpPopupGrid1Columns = [
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "SELECT", label : ["선택"], type : "ra", width : "35", sort : "str", align : "center", isHidden : false, isEssential : false, isDataColumn : false}
			, {id : "GOODS_NO", label:["품목코드"], type: "ro", width: "85", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "FILE_GRUP_NO", label:["파일그룹번호"], type: "ro", width: "120", sort : "str", align : "left", isHidden : true, isEssential : false}
			, {id : "BCD_CD", label:["바코드"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "BCD_MS_TYPE", label:["모/자"], type: "combo", width: "50", sort : "str", align : "center", isHidden : false, isEssential : false, commonCode : "BCD_MS_TYPE"}
			, {id : "BCD_NM", label:["상품명"], type: "ro", width: "250", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DIMEN_NM", label:["규격"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "UNIT_CD", label:["단위"], type: "combo", width: "50", sort : "str", align : "left", isHidden : false, isEssential : false, commonCode : "UNIT_CD"}
			, {id : "UNIT_QTY", label:["입수량"], type: "ron", width: "70", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "CONV_QTY", label:["환산량"], type: "ron", width: "70", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "WGH", label:["중량"], type: "ron", width: "70", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "CAPA_CD", label:["용량단위"], type: "ron", width: "70", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "", label:["용량"], type: "ron", width: "70", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "USE_YN", label:["사용여부"], type: "ro", width: "50", sort : "str", align : "left", isHidden : true, isEssential : false}
		];
		
		erpPopupGrid1 = new dhtmlXGridObject({
			parent: "div_erp_popup_grid_1"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupGrid1Columns
		});
		erpPopupGrid1.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPopupGrid1);
		$erp.initGridComboCell(erpPopupGrid1);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid1, '<spring:message code="grid.allRowCount" />');
		
		erpPopupGrid1.attachEvent("onCheck", function(rId,cInd){
			if(cInd == this.getColIndexById("SELECT")){
				var BCD_CD = this.cells(rId, this.getColIndexById("BCD_CD")).getValue();
				var UNIT_CD = this.cells(rId, this.getColIndexById("UNIT_CD")).getValue();
				var FILE_GRUP_NO = this.cells(rId, this.getColIndexById("FILE_GRUP_NO")).getValue();
				if(FILE_GRUP_NO == undefined || FILE_GRUP_NO == null || FILE_GRUP_NO == ""){
					var url = "/common/system/file/getFileGrupNo.do";
					var send_data = {};
					var if_success = function(data){
						erpPopupGrid1.cells(rId, erpPopupGrid1.getColIndexById("FILE_GRUP_NO")).setValue(data.FILE_GRUP_NO);
						
						var url = "/sis/standardInfo/goods/updateGoodsFileGrupNo.do";
						var send_data = {"BCD_CD" : BCD_CD, "FILE_GRUP_NO" : data.FILE_GRUP_NO};
						var if_success = function(data){}
						var if_error = function(XHR, status, error){}
						$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpPopupTabLayout1);
//						$erp.openAttachFilesUploadPopup({"DIRECTORY_KEY" : "goods", "FILE_GRUP_NO" : data.FILE_GRUP_NO, "FILE_REG_TYPE" : "board"}, uploadFileLimitCount, existAttachFileCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear);
					}
					
					var if_error = function(XHR, status, error){}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpPopupTabLayout1);
				}else{
					var url = "/common/system/file/getAttachGoodsImageFileList.do";
					var send_data = {"FILE_GRUP_NO" : FILE_GRUP_NO};
					var if_success = function(data){
						for(var index in data.gridDataList){
							if(data.gridDataList[index].FILE_ORG_NM.indexOf("_1") != -1){
								$('#uploadGoodsImage1').attr('src', "/common/system/file/requestFileDownload.do?FILE_GRUP_NO="+ data.gridDataList[index].FILE_GRUP_NO +"&FILE_SEQ=" + data.gridDataList[index].FILE_SEQ);
								$('#uploadGoodsImage1').attr('FILE_GRUP_NO', data.gridDataList[index].FILE_GRUP_NO);
								$('#uploadGoodsImage1').attr('FILE_SEQ', data.gridDataList[index].FILE_SEQ);
								$('#uploadGoodsImage1').attr('FILE_ORG_NM', data.gridDataList[index].FILE_ORG_NM);
							}else if(data.gridDataList[index].FILE_ORG_NM.indexOf("_2") != -1){
								$('#uploadGoodsImage2').attr('src', "/common/system/file/requestFileDownload.do?FILE_GRUP_NO="+ data.gridDataList[index].FILE_GRUP_NO +"&FILE_SEQ=" + data.gridDataList[index].FILE_SEQ);
								$('#uploadGoodsImage2').attr('FILE_GRUP_NO', data.gridDataList[index].FILE_GRUP_NO);
								$('#uploadGoodsImage2').attr('FILE_SEQ', data.gridDataList[index].FILE_SEQ);
								$('#uploadGoodsImage2').attr('FILE_ORG_NM', data.gridDataList[index].FILE_ORG_NM);
							}else if(data.gridDataList[index].FILE_ORG_NM.indexOf("_3") != -1){
								$('#uploadGoodsImage3').attr('src', "/common/system/file/requestFileDownload.do?FILE_GRUP_NO="+ data.gridDataList[index].FILE_GRUP_NO +"&FILE_SEQ=" + data.gridDataList[index].FILE_SEQ);
								$('#uploadGoodsImage3').attr('FILE_GRUP_NO', data.gridDataList[index].FILE_GRUP_NO);
								$('#uploadGoodsImage3').attr('FILE_SEQ', data.gridDataList[index].FILE_SEQ);
								$('#uploadGoodsImage3').attr('FILE_ORG_NM', data.gridDataList[index].FILE_ORG_NM);
							}
							
						}
					}
					var if_error = function(XHR, status, error){}
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, erpPopupTabLayout1);
					
				}
				
				setDomObj(UNIT_CD);
			}
		});
	}
	
	<%-- erpPopupTabLayout1 내용 조회 Function --%>
	function searchErpPopupTab1(){
		erpPopupTabLayout1.progressOn();
		var goods_no = document.getElementById("txtGOODS_NO").value;
		
		$.ajax({
			url : "/common/popup/getGoodsContents.do"
			,data : {
				"GOODS_NO" : goods_no
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupTabLayout1.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					crud = "U";
					
					var tab1Tb1Data = document.getElementById("tab_1_table_1");
					var tab1Tb2Data = document.getElementById("tab_1_table_1_2");
					var tab1Tb3Data = document.getElementById("tab_1_table_1_3");
					var tab1Tb4Data = document.getElementById("tab_1_table_1_4");
					var tab1Tb5Data = document.getElementById("tab_1_table_1_5");
					$erp.clearInputInElement(tab1Tb1Data);
					$erp.clearInputInElement(tab1Tb2Data);
					$erp.clearInputInElement(tab1Tb3Data);
					$erp.clearInputInElement(tab1Tb4Data);
					$erp.clearInputInElement(tab1Tb5Data);
					$erp.clearDhtmlXGrid(erpPopupGrid1);
					
					var dataMap = data.dataMap;
					if($erp.isEmpty(dataMap)){
						$erp.alertMessage({
							"alertMessage" : "info.common.noDataSearch"
							, "alertCode" : null
							, "alertType" : "info"
						});
					}else{
						document.getElementById("hidGRUP_CD").value = dataMap.GRUP_CD;
						$erp.dataAutoBind(tab1Tb1Data, dataMap);
					}
					
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						$erp.addDhtmlXGridNoDataPrintRow(
							erpPopupGrid1
							, '<spring:message code="grid.noSearchData" />'
						);
					} else {
						erpPopupGrid1.parse(gridDataList, 'js');
						
						var allRowIds = erpPopupGrid1.getAllRowIds();
						var allRowArray = allRowIds.split(",");
						for(var i=0; i<allRowArray.length; i++){
							if(erpPopupGrid1.cells(allRowArray[i],erpPopupGrid1.getColIndexById("USE_YN")).getValue() == "N"){
								erpPopupGrid1.setRowTextStyle(allRowArray[i],"opacity:0.3;");
							}
						}
						erpPopupGrid1.cells(1, erpPopupGrid1.getColIndexById("SELECT")).changeState(true);
					}
				}
				$erp.setDhtmlXGridFooterRowCount(erpPopupGrid1);
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupTabLayout1.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function isSaveErpPopupTab1Validate(){
		var isValidated = true;
		var alertMessage = "";
		var alertCode = "";
		var alertType = "error";
		
		var goods_nm = document.getElementById("txtGOODS_NM").value;
		var grup_cd = document.getElementById("hidGRUP_CD").value;
		
		if($erp.isEmpty(goods_nm)){
			isValidated = false;
			alertMessage = "error.sis.goods.goods_nm.empty";
			alertCode = "-1";
		} else if($erp.isLengthOver(goods_nm, 50)){
			isValidated = false;
			alertMessage = "error.sis.goods.goods_nm.length50Over";
			alertCode = "-2";
		} else if($erp.isEmpty(grup_cd)){ 
			isValidated = false;
			alertMessage = "error.sis.goods.grup_nm.empty";
			alertCode = "-3";
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
	
	function deleteErpPopupTab1(){
		$erp.confirmMessage({
			"alertMessage" : '<spring:message code="alert.common.deleteData" />'
			, "alertType" : "alert"
			, "alertCallbackFn" : callbackSaveFunction
			, "alertCallbackFnParam" : "D"
		});
	}
	
	function saveErpPopupTab1(){
		if(!isSaveErpPopupTab1Validate()) { 
			return false; 
		}
		
		$erp.confirmMessage({
			"alertMessage" : '<spring:message code="alert.common.saveData" />'
			, "alertType" : "alert"
			, "alertCallbackFn" : callbackSaveFunction
			, "alertCallbackFnParam" : "U"
		});
	}
	
	function callbackSaveFunction(crud){
		erpPopupTabLayout1.progressOn();
		
		var paramData = $erp.dataSerialize("tab_1_table_1");
		var grup_cd = document.getElementById("hidGRUP_CD").value;
		
		var today = new Date();
		var yyyy = today.getFullYear();
		var mm = today.getMonth()+1;
		var dd = today.getDate();
		
		if(dd < 10) {
			dd = '0'+dd;
		}
		
		if (mm < 10) {
			mm = '0'+mm;
		}
		
		var GOODS_IMG_PATH1 = "sis_file\\attachFiles\\goods\\" + yyyy + "\\" + mm + "\\" + dd;
		var GOODS_IMG_PATH2 = "sis_file\\attachFiles\\goods\\" + yyyy + "\\" + mm + "\\" + dd;
		var GOODS_IMG_PATH3 = "sis_file\\attachFiles\\goods\\" + yyyy + "\\" + mm + "\\" + dd;
		
		if (goodsFileName1 == undefined && goodsFileName2 != undefined && goodsFileName3 != undefined){
			GOODS_IMG_PATH1 = "";
		}else if (goodsFileName2 == undefined && goodsFileName1 != undefined && goodsFileName3 != undefined){
			GOODS_IMG_PATH2 = "";
		}else if (goodsFileName3 == undefined && goodsFileName1 != undefined && goodsFileName2 != undefined){
			GOODS_IMG_PATH3 = "";
		}else if(goodsFileName1 == undefined && goodsFileName2 == undefined && goodsFileName3 != undefined){
			GOODS_IMG_PATH1 = "";
			GOODS_IMG_PATH2 = "";
		}else if(goodsFileName2 == undefined && goodsFileName3 == undefined && goodsFileName1 != undefined){
			GOODS_IMG_PATH2 = "";
			GOODS_IMG_PATH3 = "";
		}else if(goodsFileName1 == undefined && goodsFileName3 == undefined && goodsFileName2 != undefined){
			GOODS_IMG_PATH1 = "";
			GOODS_IMG_PATH3 = "";
		}else if(goodsFileName1 == undefined && goodsFileName2 == undefined && goodsFileName3 == undefined){
			GOODS_IMG_PATH1 = "";
			GOODS_IMG_PATH2 = "";
			GOODS_IMG_PATH3 = "";
		}
		
		var selectedRowId = erpPopupGrid1.getCheckedRows(erpPopupGrid1.getColIndexById("SELECT"));
		var BCD_CD = erpPopupGrid1.cells(selectedRowId, erpPopupGrid1.getColIndexById("BCD_CD")).getValue();
		
		paramData["GRUP_CD"] = grup_cd;
		paramData["CRUD"] = crud;
		paramData["BCD_CD"] = BCD_CD;
		paramData["GOODS_IMG_PATH1"] = GOODS_IMG_PATH1;
		paramData["GOODS_IMG_PATH2"] = GOODS_IMG_PATH2;
		paramData["GOODS_IMG_PATH3"] = GOODS_IMG_PATH3;
		
		console.log(paramData);
		$.ajax({
			url : "/sis/standardInfo/goods/updateGoodsInformation.do"
			,data : paramData
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				erpPopupTabLayout1.progressOff();
				var dataMap = data.dataMap;
				if(dataMap.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					if(dataMap.RESULT_MSG == "SAVE_SUCCESS"){
						$erp.alertSuccessMesage(onAfterSaveErpPopupTab1);
					}else if(dataMap.RESULT_MSG == "INS_SUCCESS"){
						document.getElementById("txtGOODS_NO").value = dataMap.INS_GOODS_NO;
						$erp.alertSuccessMesage(onAfterSaveErpPopupTab1);
					}else if(dataMap.RESULT_MSG == "DEL_SUCCESS"){
						$erp.alertDeleteMesage(onAfterDeleteErpPopupTab1);
					}else{
						$erp.alertMessage({
							"alertMessage" : "error.common.sqlError"
							, "alertCode" : "-1"
							, "alertType" : "error"
						});
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpPopupTabLayout1.progressOff();
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	String.prototype.replaceAll = function(value, separator){
		return this.split(value).join(separator);
	}
	
	<%-- Data 저장 후 Function --%>
	function onAfterSaveErpPopupTab1(){
		parent.erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID).parentWindow.searchCheck();
		searchErpPopupTab1();
	}
	
	function onAfterDeleteErpPopupTab1(){
		parent.erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID).parentWindow.searchCheck();
		$erp.closePopup();
	}
	
	<%-- ■ erpPopupGrid1 관련 Function 끝 --%>
	
	<%-- ■ initErpPopupTabLayout2 초기화  시작 --%>
	function initErpPopupTabLayout2() {
		erpPopupTabLayout2 = new dhtmlXLayoutObject({
			parent: "div_erp_popup_tab_2"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false, fix_size:[true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				,{id: "c", text: "그리드영역", header:false, fix_size:[true, true]}
				,{id: "d", text: "평균정보", header:false, fix_size:[true, true]}
			]
		})
		
		erpPopupTabLayout2.cells("a").attachObject("div_erp_popup_search_2");
		erpPopupTabLayout2.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupTabLayout2.cells("b").attachObject("div_erp_popup_ribbon_2");
		erpPopupTabLayout2.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupTabLayout2.cells("c").attachObject("div_erp_popup_grid_2");
		erpPopupTabLayout2.cells("c").setHeight(465);
		erpPopupTabLayout2.cells("d").attachObject("div_erp_popup_content_2");
	}
	<%-- ■ initErpPopupTabLayout2 초기화  끝  --%>
	
	<%-- ■ erpPopupRibbon2 관련 Function 시작 --%>
	<%-- erpPopupRibbon2 초기화 Function --%>
	function initErpPopupRibbon2(){
		erpPopupRibbon2 = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon_2"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpPopup2", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					,{id : "excel_erpPopup2", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					,{id : "print_erpPopup2", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}	
				]}
			]
		});
		
		erpPopupRibbon2.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpPopup2"){
				searchErpPopupTab2();
			}else if (itemId == "excel_erpPopup2"){
				$erp.exportDhtmlXGridExcel({
					"grid" : erpGrid
					, "fileName" : "판매일별_상품매입정보"
					, "isForm" : false
				});
			} else if (itemId == "print_erpPopup2"){
				$erp.alertMessage({
					"alertMessage" : "준비중입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			}
		});
	}
	<%-- ■ erpPopupRibbon2 관련 Function 끝 --%>
	
	<%-- ■ erpPopupGrid2 관련 Function 시작 --%>
	<%-- erpPopupGrid2 초기화 Function --%>
	function initErpPopupGrid2(){
		erpPopupGrid2Columns = [
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_CD", label:["조직명"], type: "combo", width: "80", sort : "str", align : "left", isHidden : false, isDisabled : true, isEssential : false, commonCode : ["ORGN_CD", "", "", "", "", "MK"]}
			, {id : "PUR_DATE", label:["매입일자"], type: "ro", width: "120", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "PUR_QTY", label:["매입량"], type: "ro", width: "50", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "PAY_SUM_AMT", label:["매입액"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "PUR_PRICE", label:["매입단가"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "PUR_TYPE", label:["구분"], type: "ro", width: "50", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "CUSTMR_NM", label:["협력사"], type: "ro", width: "180", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpPopupGrid2 = new dhtmlXGridObject({
			parent: "div_erp_popup_grid_2"	
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH	
			, columns : erpPopupGrid2Columns
		});
		erpPopupGrid2.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPopupGrid2);
		$erp.initGridComboCell(erpPopupGrid2);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid2, '<spring:message code="grid.allRowCount" />');
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid2, 100);
	}
	
	<%-- erpPopupTabLayout2 내용 조회 Function --%>
	function searchErpPopupTab2(){
		var searchDateFrom02 = document.getElementById("searchDateFrom02").value;
		var searchDateTo02 = document.getElementById("searchDateTo02").value;
		if(Number(searchDateFrom02.split("-").join("")) > Number(searchDateTo02.split("-").join(""))) {
			$erp.alertMessage({
				"alertMessage" : "error.common.invalidBeginEndDate",
				"alertCode" : null,
				"alertType" : "alert",
				"alertCallbackFn" : function() {
					document.getElementById("searchDateFrom02").value = $erp.getToday("-");
					document.getElementById("searchDateTo02").value = $erp.getToday("-");
				},
			});
		} else {
			erpPopupTabLayout2.progressOn();
			$.ajax({
				url : "/common/popup/getGoodsPurInfo.do"
				,data : {
					"GOODS_NO" : sel_goods_no
					, "BCD_CD" : sel_bcd_cd
					, "FromDate" : searchDateFrom02
					, "ToDate" : searchDateTo02
					, "ORGN_CD" : cmbORGN_CD_tab_2.getSelectedValue()
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpPopupTabLayout2.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						var gridDataList = data.gridDataList;
						$erp.clearDhtmlXGrid(erpPopupGrid2);
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpPopupGrid2
								,  '<spring:message code="grid.noSearchData" />'
							);
						}else {
							crud = "U";
							
							erpPopupGrid2.parse(gridDataList, 'js');
							
							var AvgDataList = data.AvgDataList;
							var max_pur_price = 0;
							var min_pur_price = 0;
							var avg_pur_price = 0;
							var total_pur_amt = 0;
							var total_pur_qty = 0;
							var avg_pur_qty = 0;
							var total_rent_amt = 0;
							var rent_qty = 0;
							var avg_rent_qty = 0;
							
							console.log(AvgDataList);
							for(var i = 0 ; i < AvgDataList.length ; i++){
								if(AvgDataList[i]["PUR_TYPE"] == "P"){
									max_pur_price += Number(AvgDataList[i]["MAX_PUR_PRICE"]);
									min_pur_price += Number(AvgDataList[i]["MIN_PUR_PRICE"]);
									avg_pur_price += Number(AvgDataList[i]["AVG_PUR_PRICE"]);
									total_pur_amt += Number(AvgDataList[i]["TOTAL_PUR_AMT"]);
									total_pur_qty += Number(AvgDataList[i]["TOTAL_PUR_QTY"]);
									avg_pur_qty += Number(AvgDataList[i]["AVG_PUR_QTY"]);
								} else {
										total_rent_amt += Number(AvgDataList[i]["TOTAL_PUR_AMT"]);
										rent_qty += Number(AvgDataList[i]["TOTAL_PUR_QTY"]);
										avg_rent_qty += Number(AvgDataList[i]["AVG_PUR_QTY"]);
								}
							}
							
							document.getElementById("txtMAX_PUR_PRICE").innerHTML = $erp.getMoneyFormat(max_pur_price);
							document.getElementById("txtMIN_PUR_PRICE").innerHTML = $erp.getMoneyFormat(min_pur_price);
							document.getElementById("txtAVG_PUR_PRICE").innerHTML = $erp.getMoneyFormat(avg_pur_price);
							document.getElementById("txtTOTAL_PUR_AMT").innerHTML = $erp.getMoneyFormat(total_pur_amt);
							document.getElementById("txtTOTAL_PUR_QTY").innerHTML = $erp.getMoneyFormat(total_pur_qty);
							document.getElementById("txtAVG_PUR_QTY").innerHTML = $erp.getMoneyFormat(avg_pur_qty);
							document.getElementById("txtRETN_QTY").innerHTML = $erp.getMoneyFormat(rent_qty);
							document.getElementById("txtTOTAL_RETN_AMT").innerHTML = $erp.getMoneyFormat(total_rent_amt);
							document.getElementById("txtAVG_RETN_QTY").innerHTML = $erp.getMoneyFormat(avg_rent_qty);
						}
						$erp.setDhtmlXGridFooterRowCount(erpPopupGrid2);
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupTabLayout2.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	<%-- ■ erpPopupGrid2 관련 Function 끝 --%>
	
	<%-- ■ initErpPopupTabLayout3 초기화  시작 --%>
	function initErpPopupTabLayout3() {
		erpPopupTabLayout3 = new dhtmlXLayoutObject({
			parent: "div_erp_popup_tab_3"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "4E"
			, cells: [
				{id: "a", text: "컨텐츠영역", header:false, fix_size:[true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				,{id: "c", text: "그리드영역", header:false, fix_size:[true, true]}
				,{id: "d", text: "평균정보", header:false, fix_size:[true,true]}
			]
		})
		
		erpPopupTabLayout3.cells("a").attachObject("div_erp_popup_tab_3_tb_1");
		erpPopupTabLayout3.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupTabLayout3.cells("b").attachObject("div_erp_popup_ribbon_3");
		erpPopupTabLayout3.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupTabLayout3.cells("c").attachObject("div_erp_popup_grid_3");
		erpPopupTabLayout3.cells("d").attachObject("div_erp_popup_tab_3_tb_2");
		erpPopupTabLayout3.cells("d").setHeight(115);
	}
	<%-- ■ initErpPopupTabLayout3 초기화  끝  --%>
	
	<%-- ■ erpPopupRibbon3 관련 Function 시작 --%>
	<%-- erpPopupRibbon3 초기화 Function --%>
	function initErpPopupRibbon3() {
		erpPopupRibbon3 = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon_3"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpPopup3", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					,{id : "excel_erpPopup3", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					,{id : "print_erpPopup3", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}
				]}
			]
		});
		
		erpPopupRibbon3.attachEvent("onClick", function(itemId, bId) {
			if (itemId == "search_erpPopup3") {
				searchErpPopupTab3();
			} else if (itemId == "excel_erpPopup3") {
				$erp.alertMessage({
					"alertMessage" : "준비중입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			} else if (itemId == "print_erpPopup3") {
				$erp.alertMessage({
					"alertMessage" : "준비중입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			}
		});
	}
	<%-- ■ erpPopupRibbon3 관련 Function 끝 --%>
	
	<%-- ■ erpPopupGrid3 관련 Function 시작 --%>
	<%-- erpPopupGrid3 초기화 Function --%>
	function initErpPopupGrid3() {
		erpPopupGrid3Columns = [
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			,{id :"ORGN_CD", label:["조직명"], type:"combo", width:"80", sort:"str", align:"left", isHidden:false, isDisabled : true, isEssential:true, commonCode : ["ORGN_CD", "", "", "", "", "MK"] }
			,{id :"ORD_DATE", label:["판매일시"], type:"ro", width:"130", sort:"str", align:"center", isHidden:false, isEssential:true }
			,{id :"POS_NO", label:["POS번호"], type:"ro", width:"60", sort:"int", align:"center", isHidden:false, isEssential:true }
			,{id :"RESP_USER", label:["계산원"], type:"ro", width:"65", sort:"str", align:"left", isHidden:false, isEssential: true }
			,{id :"SALE_PRICE", label:["판매단가"], type:"ron", width:"80", sort:"int", align:"right", isHidden:false, isEssential:true, numberFormat : "0,000"}
			,{id :"SALE_QTY", label:["판매수량"], type:"ro", width:"70", sort:"int", align:"right", isHidden:false, isEssential:true }
			,{id :"SALE_AMT", label:["판매액"], type:"ron", width:"80", sort:"int", align:"right", isHidden:false, isEssential:true, numberFormat : "0,000" }
			,{id :"MEM_NM", label:["고객"], type:"ro", width:"100", sort:"str", align:"left", isHidden:false, isEssential:true }
			,{id :"CORP_NO", label:["사업자번호"], type:"ro", width:"90", sort:"int", align:"left", isHidden:false, isEssential:true }
			,{id :"CORP_ADDR_DETL", label:["주소"], type:"ro", width:"250", sort:"str", align:"left", isHidden:false, isEssential:true }
		];
		
		erpPopupGrid3 = new dhtmlXGridObject({
			parent : "div_erp_popup_grid_3"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupGrid3Columns
		});
		
		erpPopupGrid3.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPopupGrid3);
		$erp.initGridComboCell(erpPopupGrid3);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid3, '<spring:message code="grid.allRowCount" />');
	}
	
	<%-- erpPopupTabLayout3 내용 조회 Function --%>
	function searchErpPopupTab3() {
		var search_date_from = document.getElementById("SEARCH_DATE_FROM").value;
		var search_date_to = document.getElementById("SEARCH_DATE_TO").value;
		
		if(Number(search_date_from.split("-").join("")) > Number(search_date_to.split("-").join(""))) {
			$erp.alertMessage({
				"alertMessage" : "error.common.invalidBeginEndDate",
				"alertCode" : null,
				"alertType" : "alert",
				"alertCallbackFn" : function() {
					document.getElementById("SEARCH_DATE_FROM").value = $erp.getToday("-");
					document.getElementById("SEARCH_DATE_TO").value = $erp.getToday("-");
				},
			});
		} else {
			erpPopupTabLayout3.progressOn();
			$.ajax({
				url : "/common/popup/getGoodsSales.do"
				,data : {
					"GOODS_NO" : sel_goods_no,
					"BCD_CD" : sel_bcd_cd,
					"SEARCH_DATE_FROM" : search_date_from,
					"SEARCH_DATE_TO" : search_date_to,
					"ORGN_CD" : cmbORGN_CD_tab_3.getSelectedValue()
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpPopupTabLayout3.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} 
					else {
						var tab3Tb1Data = document.getElementById("tab_3_table_1");
						var tab3Tb2Data = document.getElementById("tab_3_table_2");
						$erp.clearInputInElement(tab3Tb1Data);
						$erp.clearInputInElement(tab3Tb2Data);
						$erp.clearDhtmlXGrid(erpPopupGrid3);
						
						var gridDataList = data.gridDataList;
						var gridDataMap =data.gridDataMap
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpPopupGrid3
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpPopupGrid3.parse(gridDataList, 'js');
							crud = "R";
						}
						if($erp.isEmpty(gridDataMap)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpPopupGrid3
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpPopupGrid3.parse(gridDataMap, 'js');
							crud = "R";
							document.getElementById("SALE_QTY").value = gridDataMap.SALE_QTY;
							document.getElementById("SALE_AMT").value = gridDataMap.SALE_AMT.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
							document.getElementById("SALE_CNT").value = gridDataMap.SALE_CNT;
							document.getElementById("SALES_QTY").value = gridDataMap.SALES_QTY;
							document.getElementById("RETURN_QTY").value = gridDataMap.RETURN_QTY;
							document.getElementById("SALES_AMT").value = gridDataMap.SALES_AMT.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
							document.getElementById("RETN_AMT").value = gridDataMap.RETN_AMT.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
							document.getElementById("COUP_AMT").value = gridDataMap.COUP_AMT.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
							document.getElementById("BARG_AMT").value = gridDataMap.BARG_AMT.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
							document.getElementById("AVG_AMT").value = gridDataMap.AVG_AMT.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
							document.getElementById("MEM_AMT").value = gridDataMap.MEM_AMT.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
							document.getElementById("SOBI_QTY").value = "0"; //나중에 다시 변경해야함
							document.getElementById("SOBI_AMT").value = "0"; //나중에 다시 변경해야함
						}
					}
					$erp.setDhtmlXGridFooterRowCount(erpPopupGrid3);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupTabLayout3.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	  }
		
	<%-- ■ erpPopupGrid3 관련 Function 끝 --%>
	
	<%-- ■ initErpPopupTabLayout4 초기화  시작 --%>
	function initErpPopupTabLayout4() {
		erpPopupTabLayout4 = new dhtmlXLayoutObject({
			parent: "div_erp_popup_tab_4"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "컨텐츠영역", header:false, fix_size:[true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				,{id: "c", text: "그리드영역", header:false, fix_size:[true, true]}
			]
		})
		
		erpPopupTabLayout4.cells("a").attachObject("div_erp_popup_tab_4_tb_1");
		erpPopupTabLayout4.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupTabLayout4.cells("b").attachObject("div_erp_popup_ribbon_4");
		erpPopupTabLayout4.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupTabLayout4.cells("c").attachObject("div_erp_popup_grid_4");
	}
	<%-- ■ initErpPopupTabLayout4 초기화  끝  --%>
	
	<%-- ■ erpPopupRibbon4 관련 Function 시작 --%>
	<%-- erpPopupRibbon4 초기화 Function --%>
	function initErpPopupRibbon4() {
		erpPopupRibbon4 = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon_4"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpPopup4", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					,{id : "excel_erpPopup4", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					,{id : "print_erpPopup4", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}
					
				]}
			]
		});
		
		erpPopupRibbon4.attachEvent("onClick", function(itemId, bId) {
			if (itemId == "search_erpPopup4") {
				searchErpPopupTab4();
			} else if (itemId == "excel_erpPopup4") {
				$erp.alertMessage({
					"alertMessage" : "준비중입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			} else if (itemId == "print_erpPopup4") {
				$erp.alertMessage({
					"alertMessage" : "준비중입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			}
		});
	}
	<%-- ■ erpPopupRibbon4 관련 Function 끝 --%>
	
	<%-- ■ erpPopupGrid4 관련 Function 시작 --%>
	<%-- erpPopupGrid4 초기화 Function --%>
	function initErpPopupGrid4() {
		erpPopupGrid4Columns = [
			{id : "NO", label:["NO"], type: "cntr", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "ORGN_CD", label:["조직명"], type: "combo", width: "80", sort : "str", align : "center", isHidden : false, isDisabled : true, isEssential : false, commonCode : ["ORGN_CD", "", "", "", "", "MK"]}
			, {id : "REG_TYPE", label:["구분"], type: "ro", width: "140", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "GOODS_NM", label:["상품명"], type: "ro", width: "140", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "STOCK_QTY", label:["재고량"], type: "ro", width: "75", sort : "int", align : "right", isHidden : false, isEssential : false }
			, {id : "PUR_PRICE", label:["매입가"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false  , numberFormat : "0,000"}
			, {id : "PUR_AMT", label:["매입가액"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false , numberFormat : "0,000"}
			, {id : "SALE_PRICE", label:["판매가"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false , numberFormat : "0,000"}
			, {id : "SALE_AMT", label:["판매가액"], type: "ron", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false , numberFormat : "0,000"}
			, {id : "SALE_QTY", label:["일매출량"], type: "ro", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "STOCK_MIN_QTY", label:["최소재고"], type: "ro", width: "80", sort : "int", align : "right", isHidden : false, isEssential : false}
			, {id : "END_DATE", label:["최종실사일시"], type: "ro", width: "120", sort : "str", align : "center", isHidden : false, isEssential : false}
		];
		
		erpPopupGrid4 = new dhtmlXGridObject({
			parent : "div_erp_popup_grid_4"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupGrid4Columns
		});
		
		erpPopupGrid4.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPopupGrid4);
		$erp.initGridComboCell(erpPopupGrid4);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid4, '<spring:message code="grid.allRowCount" />');
	}
	
	<%-- erpPopupTabLayout4 내용 조회 Function --%>
	function searchErpPopupTab4() {
		var SEARCH_DATE_FROM4 = document.getElementById("SEARCH_DATE_FROM4").value;
		var SEARCH_DATE_TO4 = document.getElementById("SEARCH_DATE_TO4").value; 

		if(Number(SEARCH_DATE_FROM4.split("-").join("")) > Number(SEARCH_DATE_TO4.split("-").join(""))) {
			$erp.alertMessage({
				"alertMessage" : "error.common.invalidBeginEndDate",
				"alertCode" : null,
				"alertType" : "alert",
				"alertCallbackFn" : function() {
					document.getElementById("SEARCH_DATE_FROM4").value = $erp.getToday("-");
					document.getElementById("SEARCH_DATE_TO4").value = $erp.getToday("-");
				}
			});
		} else {
			erpPopupTabLayout4.progressOn();
			$.ajax({
				url : "/common/popup/getGoodsStock.do"
				,data : {
					"GOODS_NO" : sel_goods_no,
					"SEARCH_DATE_FROM4" : SEARCH_DATE_FROM4,
					"SEARCH_DATE_TO4" : SEARCH_DATE_TO4,
					"ORGN_CD" : cmbORGN_CD_tab_4.getSelectedValue()
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpPopupTabLayout4.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}
					else  {
						var tab4Tb1Data = document.getElementById("tab_4_table_1");
						
						$erp.clearInputInElement(tab4Tb1Data);
						$erp.clearDhtmlXGrid(erpPopupGrid4);
						
						var gridDataList = data.gridDataList;
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpPopupGrid4
								, '<spring:message code="grid.noSearchData" />'
							);
						} else {
							erpPopupGrid4.parse(gridDataList, 'js');
							crud = "R";
						}	
					}
					$erp.setDhtmlXGridFooterRowCount(erpPopupGrid4);
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupTabLayout4.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	  }
	<%-- ■ erpPopupGrid4 관련 Function 끝 --%>

	<%-- ■ initErpPopupTabLayout5 초기화  시작 --%>
	function initErpPopupTabLayout5() {
		erpPopupTabLayout5 = new dhtmlXLayoutObject({
			parent: "div_erp_popup_tab_5"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "조회조건영역", header:false, fix_size:[true, true]}
				,{id: "b", text: "리본영역", header:false, fix_size:[true, true]}
				,{id: "c", text: "그리드영역", header:false, fix_size:[true, true]}
			]
		})
		
		erpPopupTabLayout5.cells("a").attachObject("div_erp_popup_search_5");
		erpPopupTabLayout5.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupTabLayout5.cells("b").attachObject("div_erp_popup_ribbon_5");
		erpPopupTabLayout5.cells("b").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpPopupTabLayout5.cells("c").attachObject("div_erp_popup_grid_5");
	}
	<%-- ■ initErpPopupTabLayout5 초기화  끝  --%>
	
	<%-- ■ erpPopupRibbon5 관련 Function 시작 --%>
	<%-- erpPopupRibbon5 초기화 Function --%>
	function initErpPopupRibbon5(){
		erpPopupRibbon5 = new dhtmlXRibbon({
			parent : "div_erp_popup_ribbon_5"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "search_erpPopup5", type : "button", text:'<spring:message code="ribbon.search" />', isbig : false, img : "menu/search.gif", imgdis : "menu/search_dis.gif", disable : false}
					,{id : "excel_erpPopup5", type : "button", text:'<spring:message code="ribbon.excel" />', isbig : false, img : "menu/excel.gif", imgdis : "menu/excel_dis.gif", disable : true}
					,{id : "print_erpPopup5", type : "button", text:'<spring:message code="ribbon.print" />', isbig : false, img : "menu/print.gif", imgdis : "menu/print_dis.gif", disable : true, isHidden : true}	
				]}
			]
		});
		
		erpPopupRibbon5.attachEvent("onClick", function(itemId, bId){
			if (itemId == "search_erpPopup5"){
				searchErpPopupTab5();
			}else if (itemId == "excel_erpPopup5"){
				$erp.exportDhtmlXGridExcel({
					"grid" : erpPopupGrid5
					, "fileName" : "상품_변경로그"
					, "isForm" : false
				});
			} else if (itemId == "print_erpPopup5"){
				$erp.alertMessage({
					"alertMessage" : "준비중입니다.",
					"alertType" : "alert",
					"isAjax" : false
				});
			}
		});
	}
	<%-- ■ erpPopupRibbon5 관련 Function 끝 --%>
	
	<%-- ■ erpPopupGrid5 관련 Function 시작 --%>
	<%-- erpPopupGrid5 초기화 Function --%>
	function initErpPopupGrid5(){
		erpPopupGrid5Columns = [
			{id : "LOG_NUM", label:["NO", "#rspan"], type: "ro", width: "30", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "GOODS_NO", label:["상품코드", "#text_filter"], type: "ro", width: "80", sort : "str", align : "center", isHidden : false, isEssential : false}
			, {id : "GRUP_TOP_CD", label:["대분류코드", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GRUP_MID_CD", label:["중분류코드", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GRUP_BOT_CD", label:["소분류코드", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_NM", label:["상품명", "#text_filter"], type: "ro", width: "200", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_PUR_CD", label:["상품유형", "#text_filter"], type: "ro", width: "80", sort : "int", align : "center", isHidden : false, isEssential : false}
			, {id : "GOODS_SALE_TYPE", label:["판매유형", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "ITEM_TYPE", label:["품목구분", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "POINT_SAVE_RATE", label:["포인트적립율", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "TAX_TYPE", label:["과세구분", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_STATE", label:["상품상태", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MAT_TEMPER_INFO", label:["품온정보", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_SET_TYPE", label:["세트여부", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MIN_PUR_QTY", label:["CS최소주문수량", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MIN_PUR_UNIT", label:["CS최소주문단위", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MIN_ORD_UNIT", label:["최소구매단위", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MIN_ORD_QTY", label:["수주제한수량", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "MIN_UNIT_QTY", label:["최소단위수량", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_DESC", label:["상품설명", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_KEYWD", label:["키워드", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "RESP_USER", label:["담당자", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_LOAD_CD", label:["적재위치", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_EXP_CD", label:["유통기한단위코드", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_EXP_DATE", label:["유통기한", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DSCD_TYPE", label:["폐기반품여부", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DELI_DD_YN", label:["일배상품여부", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_TC_TYPE", label:["TC상품유형", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "DELI_AREA_YN", label:["착지변경상품여부", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "GOODS_STOCK_TYPE", label:["재고관리유형", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "POLI_TYPE", label:["가격정책여부", "#text_filter"], type: "ro", width: "80", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "STOCK_CONF_DATE", label:["재고매입확정일시", "#text_filter"], type: "ro", width: "100", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "CHG_LOG_MEMO", label:["비고", "#text_filter"], type: "ro", width: "500", sort : "str", align : "left", isHidden : false, isEssential : false}
			, {id : "REG_DATE", label:["수정일시", "#text_filter"], type: "ro", width: "150", sort : "str", align : "left", isHidden : false, isEssential : false}
		];
		
		erpPopupGrid5 = new dhtmlXGridObject({
			parent: "div_erp_popup_grid_5"
			, skin : ERP_GRID_CURRENT_SKINS
			, image_path : ERP_GRID_CURRENT_IMAGE_PATH
			, columns : erpPopupGrid5Columns
		});	
		
		erpPopupGrid5.enableDistributedParsing(true, 100, 50);
		$erp.initGridCustomCell(erpPopupGrid5);
		$erp.attachDhtmlXGridFooterPaging(erpPopupGrid5, 100);
		$erp.attachDhtmlXGridFooterRowCount(erpPopupGrid5, '<spring:message code="grid.allRowCount" />');
		
	}
	
	<%-- erpPopupTabLayout5 내용 조회 Function --%>
	function searchErpPopupTab5(){
		var SEARCH_DATE_FROM5 = document.getElementById("searchDateFrom05").value;
		var SEARCH_DATE_TO5 = document.getElementById("searchDateTo05").value;
		
		if(Number(SEARCH_DATE_FROM5.split("-").join("")) > Number(SEARCH_DATE_TO5.split("-").join(""))) {
			$erp.alertMessage({
				"alertMessage" : "error.common.invalidBeginEndDate",
				"alertCode" : null,
				"alertType" : "alert",
				"alertCallbackFn" : function() {
					document.getElementById("SEARCH_DATE_FROM5").value = $erp.getToday("-");
					document.getElementById("SEARCH_DATE_TO5").value = $erp.getToday("-");
				}
			});
		} else {
			erpPopupTabLayout5.progressOn();
			$.ajax({
				url : "/common/popup/getGoodsModiLog.do"
				,data : {
					"GOODS_NO" : sel_goods_no
					, "FromDate" : SEARCH_DATE_FROM5
					, "ToDate" : SEARCH_DATE_TO5
				}
				,method : "POST"
				,dataType : "JSON"
				,success : function(data){
					erpPopupTabLayout5.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					} else {
						var gridDataList = data.gridDataList;
						$erp.clearDhtmlXGrid(erpPopupGrid5);
						if($erp.isEmpty(gridDataList)){
							$erp.addDhtmlXGridNoDataPrintRow(
								erpPopupGrid5
								,  '<spring:message code="grid.noSearchData" />'
							);
						}else {
							crud = "U";
							
							var tab5Tb1Data = document.getElementById("tab_5_table_1");
							$erp.clearInputInElement(tab5Tb1Data);
							
							erpPopupGrid5.parse(gridDataList, 'js');
							var allRowIds = erpPopupGrid5.getAllRowIds();
							var allRowArray = allRowIds.split(",");
							for(var i = 0 ; i < allRowArray.length-1 ; i++){
								for(var j = 2 ; j < 32 ; j++){
									console.log(erpPopupGrid5.cells(allRowArray[i],j));
									console.log(erpPopupGrid5.cells(allRowArray[i+1],j));
									if(erpPopupGrid5.cells(allRowArray[i],j).getValue() != erpPopupGrid5.cells(allRowArray[i+1],j).getValue()){
										erpPopupGrid5.setCellTextStyle(allRowArray[i+1], j, "background-color : #FFFF33; font-weight: bold;");
									}
									
								}
							}
						}
						$erp.setDhtmlXGridFooterRowCount(erpPopupGrid5);
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupTabLayout5.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
	
	
	<%-- ■ erpPopupGrid5 관련 Function 끝 --%>
	
	<%-- ■ dhtmlxCombo 관련 Function 시작 --%>
	<%-- dhtmlxCombo 초기화 Function --%>
	function initDhtmlXCombo(){
		cmbGOODS_STATE = $erp.getDhtmlXCombo('cmbGOODS_STATE', 'GOODS_STATE', ["USE_CD","YN"], 80, false);
		cmbTAX_TYPE = $erp.getDhtmlXCombo('cmbTAX_TYPE', 'TAX_TYPE', 'GOODS_TAX_YN', 75, "미지정");
		cmbGOODS_PUR_CD = $erp.getDhtmlXCombo('cmbGOODS_PUR_CD', 'PUR_TYPE', ["PUR_TYPE", "", "", "INFO"], 100, "미지정");
		cmbGOODS_SALE_TYPE = $erp.getDhtmlXCombo('cmbGOODS_SALE_TYPE', 'GOODS_SALE_TYPE', 'GOODS_MNG_TYPE', 80, "미지정");
		cmbGOODS_STOCK_TYPE = $erp.getDhtmlXCombo('cmbGOODS_STOCK_TYPE', 'GOODS_STOCK_TYPE', 'STOCK_MNG_TYPE', 120, "미지정");
		cmbMAT_TEMPER_INFO = $erp.getDhtmlXCombo('cmbMAT_TEMPER_INFO', 'MAT_TEMPER_INFO', 'MAT_TEMPER_INFO', 60, "미지정");
		cmbITEM_TYPE = $erp.getDhtmlXCombo('cmbITEM_TYPE', 'ITEM_TYPE', 'ITEM_TYPE', 100, "미지정");
		cmbPB_TYPE = $erp.getDhtmlXCombo('cmbPB_TYPE', 'cmbPB_TYPE', 'SUPR_GOODS_GRUP', 100, "미지정");
		cmbGOODS_SET_TYPE = $erp.getDhtmlXCombo('cmbGOODS_SET_TYPE', 'USE_CD', ["USE_CD","BIT"], 100, "미지정");
		cmbDELI_DD_YN = $erp.getDhtmlXCombo('cmbDELI_DD_YN', 'USE_CD', ['YN_CD','YN'], 80, "미지정");
		cmbDELI_AREA_YN = $erp.getDhtmlXCombo('cmbDELI_AREA_YN', 'USE_CD', ['YN_CD','YN'], 120, "미지정");
		cmbGOODS_EXP_TYPE = $erp.getDhtmlXCombo('cmbGOODS_EXP_TYPE', 'VALID_APPLY_TYPE', 'VALID_APPLY_TYPE', 60, "미지정");
		cmbUSE_EXP_TYPE = $erp.getDhtmlXCombo('cmbUSE_EXP_TYPE', 'VALID_APPLY_TYPE', 'VALID_APPLY_TYPE', 60, "미지정");
		cmbGOODS_EXP_CD = $erp.getDhtmlXCombo('cmbGOODS_EXP_CD', 'VALID_TYPE', 'VALID_TYPE', 80, "미지정","02");
		cmbGOODS_TC_TYPE = $erp.getDhtmlXCombo('cmbGOODS_TC_TYPE', 'GOODS_TC_TYPE', 'TC_TYPE', 60, "미지정");
		cmbPUR_DSCD_TYPE = $erp.getDhtmlXCombo('cmbPUR_DSCD_TYPE', 'PUR_DSCD_TYPE', 'DSCD_TYPE', 80, "미지정");
		cmbSALE_DSCD_TYPE = $erp.getDhtmlXCombo('cmbSALE_DSCD_TYPE', 'SALE_DSCD_TYPE', 'DSCD_TYPE', 60, "미지정");
		cmbSTORE_TYPE = $erp.getDhtmlXCombo('cmbSTORE_TYPE', 'STORE_TYPE', ['YN_CD', 'BIT'], 100, "미지정");
		cmbBRAND_TYPE = $erp.getDhtmlXCombo('cmbBRAND_TYPE', 'BRAND_TYPE', ['YN_CD', 'BIT'], 80, "미지정");
		cmbPOLI_TYPE = $erp.getDhtmlXCombo('cmbPOLI_TYPE', 'POLI_TYPE', ['YN_CD', 'BIT'], 100, "미지정");
		cmbRESP_USER = $erp.getDhtmlXComboCommonCode('cmbRESP_USER','RESP_USER', 'GOODS_RESP_ORGN', 100, "미지정", false);
		
		
		cmbORGN_CD_tab_2 = $erp.getDhtmlXComboCommonCode("cmbORGN_CD_tab_2", "ORGN_CD", ["ORGN_CD", "", "", "", "","MK"], 100, "모두조회", false, LUI.LUI_orgn_cd);
		cmbORGN_CD_tab_3 = $erp.getDhtmlXComboCommonCode("cmbORGN_CD_tab_3", "ORGN_CD", ["ORGN_CD", "", "", "", "","MK"], 100, "모두조회", false, LUI.LUI_orgn_cd);
		cmbORGN_CD_tab_4 = $erp.getDhtmlXComboCommonCode("cmbORGN_CD_tab_4", "ORGN_CD", ["ORGN_CD", "", "", "", "","MK"], 100, "모두조회", false, LUI.LUI_orgn_cd);
		
		/*
		cmbGOODS_PUR_CD.attachEvent("onChange", function(value, text){
			if(text.indexOf("수수") != -1){
				document.getElementById("txtGOODS_FEE_AMT").readOnly = false;
				document.getElementById("txtGOODS_FEE_AMT").className = "input_common";
			}else{
				document.getElementById("txtGOODS_FEE_AMT").readOnly = true;
				document.getElementById("txtGOODS_FEE_AMT").className = "input_common input_readonly";
			}
		});
		*/
	}
	<%-- ■ dhtmlxCombo 관련 Function 끝 --%>
	
	<%-- openGoodsCategoryTreePopup 상품분류 트리 팝업 열림 Function --%>
	function openGoodsCategoryTreePopup() {
		var onClick = function(id) {
			if(this.hasChildren(id) == 0){
				$.ajax({
					url : "/common/popup/getCategoryTMBName.do"
					,data : {
						"GRUP_CD" : id
					}
					,method : "POST"
					,dataType : "JSON"
					,success : function(data){
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						} else {
							var dataMap = data.dataMap;
							if($erp.isEmpty(dataMap)){
								$erp.alertMessage({
									"alertMessage" : "info.common.noDataSearch"
									, "alertCode" : null
									, "alertType" : "info"
								});
							}else{
								document.getElementById("hidGRUP_CD").value = id;
								document.getElementById("txtGRUP_TMB_CD_NM").value = dataMap.GRUP_TMB_CD_NM;
							}
						}
					}, error : function(jqXHR, textStatus, errorThrown){
						$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
					}
				});
				$erp.closePopup2("openGoodsCategoryTreePopup");
			}
		};
		$erp.openGoodsCategoryTreePopup(onClick);
	}
	
	<%-- uploadGoodsImage 이미지 정보 업로드 Function --%>
	function uploadGoodsImage(fileDom){
		if(fileDom.files && fileDom.files[0]){
			erpPopupLayout.progressOn();
			var reader = new FileReader();
			reader.onload = function(e){
				if(fileDom.id == "fileGoodsImage"){
					$('#uploadGoodsImage1').attr('src',e.target.result);
					goodsFileName1 = fileDom.files[0].name;
				}else if(fileDom.id == "fileGoodsExplImage"){
					$('#uploadGoodsImage2').attr('src',e.target.result);
					goodsFileName2 = fileDom.files[0].name;
				}else if(fileDom.id == "fileGoodsBcdImage"){
					$('#uploadGoodsImage3').attr('src',e.target.result);
					goodsFileName3 = fileDom.files[0].name;
				}
			}
			reader.readAsDataURL(fileDom.files[0]);
			
			var selectedRowId = erpPopupGrid1.getCheckedRows(erpPopupGrid1.getColIndexById("SELECT"));
			var FILE_GRUP_NO = erpPopupGrid1.cells(selectedRowId, erpPopupGrid1.getColIndexById("FILE_GRUP_NO")).getValue();
			var BCD_CD = erpPopupGrid1.cells(selectedRowId, erpPopupGrid1.getColIndexById("BCD_CD")).getValue();
			
			var formData = new FormData();
			formData.append("FILE", fileDom.files[0]);
			var send_FILE_NAME;
			if(fileDom.id == "fileGoodsImage"){
				send_FILE_NAME = BCD_CD + "_1";
			}else if(fileDom.id == "fileGoodsExplImage"){
				send_FILE_NAME = BCD_CD + "_2";
			}else if(fileDom.id == "fileGoodsBcdImage"){
				send_FILE_NAME = BCD_CD + "_3";
			}
			send_FILE_NAME.value = "goods";
			
			formData.append("DIRECTORY_KEY", "goods");
			formData.append("FILE_GRUP_NO", FILE_GRUP_NO);
			formData.append("FILE_REG_TYPE", "goods");
			formData.append("FILE_NAME", send_FILE_NAME);
			
			$.ajax({
				url: "/common/system/file/uploadAttachFile2.do"
				, data : formData
				, method : "POST"
				, dataType : "JSON"
				, processData: false
				, contentType: false
				, success : function(data){
					erpPopupLayout.progressOff();
					if(data.isError){
						$erp.ajaxErrorMessage(data);
					}else {
						
					}
				}, error : function(jqXHR, textStatus, errorThrown){
					erpPopupLayout.progressOff();
					$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
				}
			});
		}
	}
</script>
</head>
<body>
	<div id="div_erp_popup_tabbar" class="samyang_div" style="display: none;">
		<div id="div_erp_popup_tab_1" class="samyang_div" style="display: none;">
			<div id="div_erp_popup_ribbon_1" class="samyang_div" style="display:none"></div>
			<div id="div_erp_popup_tab_1_tb_1" class="samyang_div" style="display: none;">
				<table id="tab_1_table_1" class="table">
					<colgroup>
						<col width="80px">
						<col width="60px">
						<col width="60px">
						<col width="70px">
						<col width="90px">
						<col width="70px">
						<col width="70px">
						<col width="90px">
						<col width="70px">
						<col width="70px">
						<col width="100px">
						<col width="90px">
						<col width="70px">
						<col width="*">
					</colgroup>
					<tr>
						<th align="center">상품코드</th>
						<td colspan="3">
							<input type="text" id="txtGOODS_NO" name="GOODS_NO" value="${GOODS_CD }" class="input_common input_readonly" readonly="readonly" style="width: 70px;">
							&nbsp;
							<div id="cmbGOODS_STATE" style="display: inline-flex;"></div>
						</td>
						<th align="center"><span class="span_essential">*</span>상품명</th>
						<td colspan="4">
							<input type="text" id="txtGOODS_NM" name="GOODS_NM" class="input_common input_essential" style="width: 250px;">
						</td>
						<th align="center">과세구분</th>
						<td>
							<div id="cmbTAX_TYPE"></div>
						</td>
						<th>가격정책여부</th>
						<td colspan="3">
							<div id="cmbPOLI_TYPE"></div>
						</td>
					</tr>
					<tr>
						<th><span class="span_essential">*</span>상품분류</th>
						<td colspan="6">
							<input type="hidden" id="hidGRUP_CD">
							<input type="text" id="txtGRUP_TMB_CD_NM" name="GRUP_TMB_CD_NM" class="input_common input_readonly" readonly="readonly" style="width: 300px;">
							<input type="button" id="btnGoodsCategoryTree" class="input_common_button" value="상품분류검색" onclick="openGoodsCategoryTreePopup();" />
						</td>
						<th>키워드</th>
						<td colspan="7">
							<input type="text" style="width: 300px;">
						</td>
					</tr>
					<tr>
						<th>상품설명</th>
						<td colspan="14">
							<input type="text" id="txtGOODS_DESC" name="GOODS_DESC" class="input_common" style="width: 400px;">
						</td>
					</tr>
					<tr>
						<th>상품유형</th>
						<td colspan="2">
							<div id="cmbGOODS_PUR_CD"></div>
						</td>
						<!-- <th>수수료율</th>
						<td>
							<input type="text" id="txtGOODS_FEE_AMT" name="GOODS_FEE_AMT" class="input_common" style="width: 50px;">
						</td> -->
						<th>판매유형</th>
						<td>
							<div id="cmbGOODS_SALE_TYPE"></div>
						</td>
						<th>보관유형</th>
						<td>
							<div id="cmbMAT_TEMPER_INFO"></div>
						</td>
						<th>재고관리유형</th>
						<td colspan="2">
							<div id="cmbGOODS_STOCK_TYPE"></div>
						</td>
						<th>포인트<br>적립율</th>
						<td colspan="4">
							<input type="text" id="txtPOINT_SAVE_RATE" name="POINT_SAVE_RATE" class="input_common" value = "0" style="width: 100px; text-align: right;">
						</td>
					</tr>
					<tr>
						<th>품목구분</th>
						<td colspan="2">
							<div id="cmbITEM_TYPE"></div>
						</td>
						<th>적재위치</th>
						<td>
							<input type="text" id="txtGOODS_LOAD_CD" name="GOODS_LOAD_CD" class="input_common" style="width: 70px;">
						</td>
						<th>최소구매<br>단위</th>
						<td>
							<input type="text" id="txtMIN_ORD_UNIT" name="MIN_ORD_UNIT" class="input_common" style="width: 50px;">
						</td>
						<th>최소수주<br>제한수량</th>
						<td colspan="2">
							<input type="text" id="txtMIN_ORD_QTY" name="MIN_ORD_QTY" class="input_common" style="width: 115px; text-align: right;">
						</td>
						<th>최소단위<br>수량</th>
						<td colspan="4">
							<input type="text" id="txtMIN_UNIT_QTY" name="MIN_UNIT_QTY" class="input_common" style="width: 100px; text-align: right;">
						</td>
					</tr>
					<tr>
						<th>세트여부</th>
						<td colspan="2">
							<div id="cmbGOODS_SET_TYPE"></div>
						</td>
						<th>일배상품<br>여부</th>
						<td>
							<div id="cmbDELI_DD_YN"></div>
						</td>
						<th>TC상품유형</th>
						<td>
							<div id="cmbGOODS_TC_TYPE"></div>
						</td>
						<th>착지변경<br>상품여부</th>
						<td colspan="2">
							<div id="cmbDELI_AREA_YN"></div>
						</td>
						<th>담당부서</th>
						<td colspan="4">
							<div id="cmbRESP_USER"></div>
<!-- 							<input type="text" id="txtRESP_USER" name="RESP_USER" class="input_common" readonly="readonly" style="width: 100px;"> -->
						</td>
					</tr>
					<tr>
						<th>PB구분</th>
						<td colspan="2">
							<div id="cmbPB_TYPE"></div>
						</td>
						<th>폐기여부(매입)</th>
						<td>
							<div id="cmbPUR_DSCD_TYPE"></div>
						</td>
						<th>폐기여부(매출)</th>
						<td>
							<div id="cmbSALE_DSCD_TYPE"></div>
						</td>
						<th>사용기한</th>
						<td colspan="2">
							<input type="text" id="txtUSE_EXP_DATE" name="USE_EXP_DATE" class="input_common" style="width: 50px; text-align: right;">
							<div id="cmbUSE_EXP_TYPE" style="display: inline-flex;"></div>
						</td>
						<th>유효기간</th>
						<td colspan="4">
							<div id="cmbGOODS_EXP_CD" style="display: inline-flex;"></div>
							<input type="text" id="txtGOODS_EXP_DATE" name="GOODS_EXP_DATE" class="input_common" style="width: 50px; text-align: right; display: inline-flex;">
							<div id="cmbGOODS_EXP_TYPE" style="display: inline-flex;"></div>
						</td>
					</tr>
					<tr>
						<th>스토어여부</th>
						<td colspan="2">
							<div id="cmbSTORE_TYPE"></div>
						</td>
						<th>브랜드여부</th>
						<td>
							<div id="cmbBRAND_TYPE"></div>
						</td>
						<th>CS최소주문<br>수량</th>
						<td colspan="2">
							<input type="text" style="width: 115px;">
						</td>
						<th>CS최소주문단위</th>
						<td  colspan="6">
							<input type="text" style="width: 115px;">
						</td>
					</tr>
				</table>
			</div>
			<div id="div_erp_popup_tab_1_tb_2" class="samyang_div" style="display: none;">
				<div id =div_erp_popup_tab_1_tb_2_1 class="samyang_div" style="display: none;">
					<table id="tab_1_table_1_2">
					</table>
				</div>
				<div id =div_erp_popup_tab_1_tb_2_2 class="samyang_div" style="display: none;">
					<table id="tab_1_table_1_3">
					</table>
				</div>
				<div id =div_erp_popup_tab_1_tb_2_3 class="samyang_div" style="display: none;">
					<table id="tab_1_table_1_4">
					</table>
				</div>
				<div id =div_erp_popup_tab_1_tb_2_4 class="samyang_div" style="display: none;">
					<table id="tab_1_table_1_5">
					</table>
				</div>
			</div>
			<div id="div_erp_popup_grid_1" class="div_grid_full_size" style="display:none"></div>
		</div>
		<div id="div_erp_popup_tab_2" class="samyang_div" style="display: none;">
			<div id="div_erp_popup_search_2" class="samyang_div" style="display:none">
				<table id="tab_2_table_1" class="table_search">
					<colgroup>
						<col width="80px">
						<col width="110px">
						<col width="80px">
						<col width="*">
					</colgroup>
					<tr>
						<th>조직명</th>
						<td><div id="cmbORGN_CD_tab_2"></div></td>
						<th>판매일</th>
						<td>
							<input type="text" id="searchDateFrom02" name="searchDateFrom02" class ="input_common input_calendar default_date">
							<span style="float: left; margin-right: 5px;"> ~ </span>
							<input type="text" id="searchDateTo02" name="searchDateTo02" class ="input_common input_calendar default_date">
						</td>
					</tr>
				</table>
			</div>
			<div id="div_erp_popup_ribbon_2" class="samyang_div" style="display:none"></div>
			<div id="div_erp_popup_grid_2" class="div_grid_full_size" style="display: none;"></div>
			<div id="div_erp_popup_content_2" class="samyang_div" style="display:none">
				<table id="tab_2_table_2" class="table">
					<colgroup>
						<col width="100px">
						<col width="*">
					</colgroup>
					<tr>
						<th style="text-align:left;">최고단가 :</th>
						<td><span id="txtMAX_PUR_PRICE" style="float:left;"></span></td>
						<th style="text-align:left;">매입액 :</th>
						<td><span id="txtTOTAL_PUR_AMT" style="float:left;"></span></td>
						<th style="text-align:left;">반품액 :</th>
						<td><span id="txtTOTAL_RETN_AMT" style="float:left;"></span></td>
					</tr>
					<tr>
						<th style="text-align:left;">최저단가 :</th>
						<td><span id="txtMIN_PUR_PRICE" style="float:left;"></span></td>
						<th style="text-align:left;">매입량 :</th>
						<td><span id="txtTOTAL_PUR_QTY" style="float:left;"></span></td>
						<th style="text-align:left;">반품량 :</th>
						<td><span id="txtRETN_QTY" style="float:left;"></span></td>
					</tr>
					<tr>
						<th style="text-align:left;">평균단가 :</th>
						<td><span id="txtAVG_PUR_PRICE" style="float:left;"></span></td>
						<th style="text-align:left;">평균매입량 :</th>
						<td><span id="txtAVG_PUR_QTY" style="float:left;"></span></td>
						<th style="text-align:left;">평균반품량 :</th>
						<td><span id="txtAVG_RETN_QTY" style="float:left;"></span></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="div_erp_popup_tab_3" class="samyang_div" style="display: none;"></div>
			<div id="div_erp_popup_ribbon_3" class="samyang_div" style="display:none"></div>
			<div id="div_erp_popup_tab_3_tb_1" class="samyang_div" style="display: none;">
				<table id="tab_3_table_1" class="table_search">
				<colgroup>
					<col width="80px">
					<col width="110px">
					<col width="80px">
					<col width="*">
				</colgroup>	
					<tr>
						<th>조직명</th>
						<td><div id="cmbORGN_CD_tab_3"></div></td>
						<th>판매일</th>
						<td>
						<input type="text" id="SEARCH_DATE_FROM" name="SEARCH_DATE_FROM" class="input_common input_calendar default_date">
						<span style="float: left; margin-right: 5px;"> ~ </span>
						<input type="text" id="SEARCH_DATE_TO" name="SEARCH_DATE_TO" class="input_common input_calendar default_date">
						</td>
					</tr>
				</table>
			</div>
			<div id="div_erp_popup_tab_3_tb_2" class="samyang_div" style="diplay:none;">
				<table id="tab_3_table_2" class="table" >
					<colgroup>
				<col width="">
				</colgroup>
				<tr>
					<th style="text-align:left;">판매량 :</th>
					<td colspan="2">
						<input type="text" id="SALE_QTY" name="SALE_QTY" class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
					<th style="text-align:left;">판매액 :</th>
					<td colspan="2">
						<input type="text" id="SALE_AMT" name="SALE_AMT" class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
					<th style="text-align:left;">쿠폰 :</th>
					<td colspan="2">
						<input type="text" id="COUP_AMT" name="COUP_AMT" class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
					<th style="text-align:left;">건수 :</th>
					<td colspan="2">
						<input type="text" id="SALE_CNT" name=SALE_CNT class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">반품량 :</th>
					<td colspan="2">
						<input type="text" id="RETURN_QTY" name="RETURN_QTY" class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
					<th style="text-align:left;">반품액 :</th>
					<td colspan="2">
						<input type="text" id="RETN_AMT" name="RETN_AMT" class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
					<th style="text-align:left;">특매 :</th>
					<td colspan="2">
						<input type="text" id="BARG_AMT" name="BARG_AMT" class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
					<th style="text-align:left;">평균금액 :</th>
					<td colspan="2">
						<input type="text" id="AVG_AMT" name="AVG_AMT" class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">매출량 :</th>
					<td colspan="2">
						<input type="text" id="SALES_QTY" name="SALES_QTY" class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
					<th style="text-align:left;">매출액 :</th>
					<td colspan="2">
						<input type="text" id="SALES_AMT" name="SALES_AMT" class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
					<th style="text-align:left;">회원매출 :</th>
					<td colspan="5">
						<input type="text" id="MEM_AMT" name="MEM_AMT" class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
				</tr>
				<tr>
					<th style="text-align:left;">소비량 :</th>
					<td colspan="2">
						<input type="text" id="SOBI_QTY" name="SOBI_QTY" class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
					<th style="text-align:left;">소비액 :</th>
					<td colspan="8">
						<input type="text" id="SOBI_AMT" name="SOBI_AMT" class="input_common input_readonly" readonly="readonly" style="background-color: #F2F2F2; width: 120px; text-align:right;">
					</td>
				</tr>
			</table>
			</div>
		</div>
		<div id="div_erp_popup_grid_3" class="div_grid_full_size" style="display:none"></div>	
		<div id="div_erp_popup_tab_4" class="samyang_div" style="display: none;">
			<div id="div_erp_popup_tab_4_tb_1" class="samyang_div" style="display: none;">
				<table id="tab_4_table_1" class="table_search">
				<colgroup>
					<col width="80px">
					<col width="110px">
					<col width="80px">
					<col width="*">
				</colgroup>	
					<tr>
						<th>조직명</th>
						<td><div id="cmbORGN_CD_tab_4"></div></td>
						<th>입고일</th>
						<td>
						<input type="text" id="SEARCH_DATE_FROM4" name="SEARCH_DATE_FROM4" class ="input_common input_calendar_ym default_date" data-position="-1">
						<span style="float: left; margin-right: 5px;"> ~ </span>
				 		<input type="text" id="SEARCH_DATE_TO4" name="SEARCH_DATE_TO4" class ="input_common input_calendar_ym default_date">
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div id="div_erp_popup_ribbon_4" class="samyang_div" style="display:none"></div>
		<div id="div_erp_popup_grid_4" class="div_grid_full_size" style="display:none"></div>
			
		<div id="div_erp_popup_tab_5" class="samyang_div" style="display: none;">
			<div id="div_erp_popup_search_5" class="samyang_div" style="display:none">
				<table id="tab_5_table_1" class="table_search">
					<colgroup>
						<col width="80px">
						<col width="*">
					</colgroup>
					<tr>
						<th>판매일</th>
						<td>
							<input type="text" id="searchDateFrom05" name="searchDateFrom05" class ="input_common input_calendar default_date">
							<span style="float: left; margin-right: 5px;"> ~ </span>
							<input type="text" id="searchDateTo05" name="searchDateTo05" class ="input_common input_calendar default_date">
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div id="div_erp_popup_ribbon_5" class="samyang_div" style="display:none"></div>
		<div id="div_erp_popup_grid_5" class="div_grid_full_size" style="display: none;"></div>
	</body>
</html>