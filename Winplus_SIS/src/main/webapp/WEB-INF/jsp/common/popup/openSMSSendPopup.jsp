<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<!--<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>-->
<script type="text/javascript">
	<%--
		※ 전역 변수 선언부 
		□ 변수명 : Type / Description
		■ erpLayout : Object / 페이지 Layout DhtmlXLayout
				
		■ erpRibbon : Object / 리본형 버튼 목록 DhtmlXRibbon
		■ erpGrid : Object / 표준분류코드 조회 DhtmlXGrid
		■ erpGridColumns : Array / 표준분류코드 DhtmlXGrid Header
		■ erpGridDataProcessor : Object / 데이터프로세서 DhtmlXDataProcessor; 
		■ cmbUSE_YN : Object / 사용여부 DhtmlXCombo
	--%>
	<%@ include file="/WEB-INF/jsp/common/include/default_common_header.jsp" %>
	
	//var erpPopupWindowsCell = parent.erpPopupWindows.window('openSMSSendPopup');
	var erpLayout;
	var erpRightLayout;
	var erpGridColumns;
	var erpGrid;
	var strValue="0";
	
	$(document).ready(function(){	
		/*
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.setText("SMS발송");
		}
		*/
		initErpLayout();
		initErpSubLayout();
		initErpLeftRibbon();
		initErpGrid();
		initContents();
		
		fnSMSTempList();
	});
	
	//var aaa= ${strCallNIdx};
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3T"
			, cells: [
				{id: "a", text: "", header:false, fix_size : [false, true]},
				{id: "b", text: "", header:false, width:380, fix_size : [true, false]},
				{id: "c", text: "", header:false}
			]		
		});
		
		erpLayout.cells("a").attachObject("div_erp_ribbon");
		erpLayout.cells("a").setHeight(ERP_LAYOUT_RIBBON_HEIGHT);
		erpLayout.cells("b").attachObject("div_erp_left_content");
		erpLayout.cells("c").attachObject("div_erp_right_content");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){			
			erpRightLayout.setSizes();
		});
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	<%-- erpLeftRibbon 초기화 Function --%>
	function initErpLeftRibbon(){
		erpLeftRibbon = new dhtmlXRibbon({
			parent : "div_erp_ribbon"
			, skin : ERP_RIBBON_CURRENT_SKINS
			, icons_path : ERP_RIBBON_CURRENT_ICON_PATH
			, items : [
				{type : "block", mode : 'rows', list : [
					{id : "send_erpLeftGrid", type : "button", text:'<spring:message code="word.common.sms" />', isbig : false, img : "menu/send.png", imgdis : "menu/send_dis.png", disable : false}
				]}							
			]
		});
		
		erpLeftRibbon.attachEvent("onClick", function(itemId, bId){
			if (itemId == "send_erpLeftGrid"){
				beforeSmsSend();
		    }
		});
	}
	
	function initErpSubLayout(){
		erpRightLayout = new dhtmlXLayoutObject({
			parent: "div_erp_right_content"
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, fix_size : [false, true]},
				{id: "b", text: "", header:false, fix_size : [false, true]},
				{id: "c", text: "", header:false}
			]		
		});
		
		erpRightLayout.cells("a").attachObject("div_erp_right_content1");
		erpRightLayout.cells("a").setHeight(28);
		erpRightLayout.cells("b").attachObject("div_erp_right_grid");
		erpRightLayout.cells("b").setWidth(100);
		erpRightLayout.cells("c").attachObject("div_erp_right_content2");
		
		<%-- erpLayout 사이즈 변경 시 Event --%>	
		$erp.setEventResizeDhtmlXLayout(erpRightLayout, function(names){			
			erpGrid.setSizes();
		});
	}
	
	<%-- erpGrid 초기화 Function --%>  
    function initErpGrid(){
        erpGridColumns = [
                        {id : "NO", label:["NO"], type: "cntr", width: "30", height: "50", sort : "int", align : "center", isHidden : false, isEssential : false}
                        , {id : "SMS_TMemo", label:["문자내용"], type: "ro", width: "310", height: "50",sort : "int", align : "left", isHidden : false, isEssential : false}
                        , {id : "SMS_TIdx", label:["순번"], type: "ro", width: "80", height: "50", sort : "int", align : "left", isHidden : true, isEssential : false}
                    ];
        
        erpGrid = new dhtmlXGridObject({
            parent: "div_erp_right_grid"            
            , skin : ERP_GRID_CURRENT_SKINS
            , image_path : ERP_GRID_CURRENT_IMAGE_PATH          
            , columns : erpGridColumns
        });     
        erpGrid.enableDistributedParsing(true, 100, 50);
        $erp.initGridCustomCell(erpGrid);
        $erp.initGridComboCell(erpGrid);                
        
        erpGridDataProcessor = new dataProcessor();
        erpGridDataProcessor.init(erpGrid);
        erpGridDataProcessor.setUpdateMode("off");
        
		erpGrid.attachEvent("onRowSelect", function(rId, cInd){
			//txtRADIO = $erp.getDhtmlXRadio('txtRADIO','radio',['A','B'],1,['단문','장문'],'label-right');
			//txtRADIO.setItemValue("B");
			txtCheck.checkItem('txtCheck');
			txtRADIO.checkItem('txtRADIO','20');
			$('#txtSubject').val("(주)윈플러스");
			$('#txtSubject').attr("disabled", false);
			document.getElementById('byteInfo').innerText = "";
			var strSMS_TMemo = erpGrid.cells(rId, erpGrid.getColIndexById("SMS_TMemo")).getValue();
			
			var MEMBER_NAME = document.getElementById("MEMBER_NAME").value;
			var YYYYMMDD = document.getElementById("YYYYMMDD").value;
			var MM = YYYYMMDD.substring(5, 7);
			var CUSTOMER_NAME = document.getElementById("CUSTOMER_NAME").value;
		
			strSMS_TMemo = strSMS_TMemo.replace(/000고객님/gi, CUSTOMER_NAME + "고객님");
			strSMS_TMemo = strSMS_TMemo.replace(/000드림/gi, MEMBER_NAME + " 드림");
			strSMS_TMemo = strSMS_TMemo.replace(/000 드림/gi, MEMBER_NAME + " 드림");
			strSMS_TMemo = strSMS_TMemo.replace(/담당자 000 입니다/gi, "담당자 "+MEMBER_NAME + " 입니다");
			strSMS_TMemo = strSMS_TMemo.replace(/담당자 OOO 입니다/gi, "담당자 "+MEMBER_NAME + " 입니다");
			strSMS_TMemo = strSMS_TMemo.replace(/담당자 000 드림/gi, "담당자 "+MEMBER_NAME + " 드림");
			strSMS_TMemo = strSMS_TMemo.replace(/00월/gi, MM + "월");
			
			var strHtml = "<textarea rows='12' cols='*' id='txtArea' onKeyUp='javascript:fnChkByte(this,90,0)'>";
			strHtml += strSMS_TMemo;
			strHtml += "</textarea>";
				
			document.getElementById('tt').innerHTML =strHtml;
		});
    }
	
	function initContents(){
		var today = $erp.getToday("-",0);
		document.getElementById("txtSTR_DT").value=today;
		
		
		//라디오버튼
        txtRADIO = $erp.getDhtmlXRadio('txtRADIO','txtRADIO',['10','20'],0,['단문','장문'],'label-right');
        $('#txtSubject').attr("disabled", true);
        txtRADIO.attachEvent('onChange', function (name, value){
			if(value == "20"){
				txtCheck.checkItem('txtCheck');
				$('#txtSubject').val("(주)윈플러스");
				$('#txtSubject').attr("disabled", false);
				document.getElementById('byteInfo').innerText = "";
			} else {
				$('#txtSubject').val("");
				$('#txtSubject').attr("disabled", true);
				document.getElementById('byteInfo').innerText = "0/90 Byte";
			}
		});
        
        ontNum = $erp.getDhtmlXRadio('ontNum','ontNum',['A','B','C','D'],0,['1차번호','2차번호','3차번호','수신번호'],'label-right', 'vertical');
        
        cmbTime = new dhtmlXCombo("cmbTime");
		cmbTime.setSize(80);
		cmbTime.addOption([	
			{value: "", text: "시간 선택"},		                   
			{value: "00", text: "00시",selected: true},
			{value: "01", text: "01시"},
			{value: "02", text: "02시"},
			{value: "03", text: "03시"},
			{value: "04", text: "04시"},
			{value: "05", text: "05시"},
			{value: "06", text: "06시"},
			{value: "07", text: "07시"},
			{value: "08", text: "08시"},
			{value: "09", text: "09시"},
			{value: "10", text: "10시"},
			{value: "11", text: "11시"},
			{value: "12", text: "12시"},
			{value: "13", text: "13시"},
			{value: "14", text: "14시"},
			{value: "15", text: "15시"},
			{value: "16", text: "16시"},
			{value: "17", text: "17시"},
			{value: "18", text: "18시"},
			{value: "19", text: "19시"},
			{value: "20", text: "20시"},
			{value: "21", text: "21시"},
			{value: "22", text: "22시"},
			{value: "23", text: "23시"}
		]);
		
		cmbMin = new dhtmlXCombo("cmbMin");
		cmbMin.setSize(80);
		cmbMin.addOption([	
			{value: "", text: "분 선택"},	
			{value: "00", text: "00분",selected: true},
			{value: "01", text: "01분"},
			{value: "02", text: "02분"},
			{value: "03", text: "03분"},
			{value: "04", text: "04분"},
			{value: "05", text: "05분"},
			{value: "06", text: "06분"},
			{value: "07", text: "07분"},
			{value: "08", text: "08분"},
			{value: "09", text: "09분"},
			{value: "10", text: "10분"},
			{value: "11", text: "11분"},
			{value: "12", text: "12분"},
			{value: "13", text: "13분"},
			{value: "14", text: "14분"},
			{value: "15", text: "15분"},
			{value: "16", text: "16분"},
			{value: "17", text: "17분"},
			{value: "18", text: "18분"},
			{value: "19", text: "19분"},
			{value: "20", text: "20분"},
			{value: "21", text: "21분"},
			{value: "22", text: "22분"},
			{value: "23", text: "23분"},
			{value: "24", text: "24분"},
			{value: "25", text: "25분"},
			{value: "26", text: "26분"},
			{value: "27", text: "27분"},
			{value: "28", text: "28분"},
			{value: "29", text: "29분"},
			{value: "30", text: "30분"},
			{value: "31", text: "31분"},
			{value: "32", text: "32분"},
			{value: "33", text: "33분"},
			{value: "34", text: "34분"},
			{value: "35", text: "35분"},
			{value: "36", text: "36분"},
			{value: "37", text: "37분"},
			{value: "38", text: "38분"},
			{value: "39", text: "39분"},
			{value: "40", text: "40분"},
			{value: "41", text: "41분"},
			{value: "42", text: "42분"},
			{value: "43", text: "43분"},
			{value: "44", text: "44분"},
			{value: "45", text: "45분"},
			{value: "46", text: "46분"},
			{value: "47", text: "47분"},
			{value: "48", text: "48분"},
			{value: "49", text: "49분"},
			{value: "50", text: "50분"},
			{value: "51", text: "51분"},
			{value: "52", text: "52분"},
			{value: "53", text: "53분"},
			{value: "54", text: "54분"},
			{value: "55", text: "55분"},
			{value: "56", text: "56분"},
			{value: "57", text: "57분"},
			{value: "58", text: "58분"},
			{value: "59", text: "59분"}
		]);
		
		cmbSMSTEMP = new dhtmlXCombo("cmbSMSTEMP");
		cmbSMSTEMP.setSize(150);
		cmbSMSTEMP.addOption([	
			{value: "0", text: "정보변경/쿠폰발행",selected: true},
			{value: "1", text: "생일고객"},
			{value: "2", text: "해피콜부재시"},
			{value: "3", text: "샘플/리플렛발송"},
			{value: "4", text: "샘플재컨택부재시"},
			{value: "5", text: "예약재통화부재시"},
			{value: "6", text: "이벤트안내문자"},
			{value: "7", text: "무통장입금확인"},
			{value: "8", text: "17안부문자"},
			{value: "9", text: "이벤트안내(명절)"},
			{value: "10", text: "무통장미입금확인"},
			{value: "11", text: "적립금안내"},
			{value: "12", text: "홈쇼핑전용"}
		]);
		
		cmbSMSTEMP.attachEvent('onChange', function (name, value){
			strValue = name;
			fnSMSTempList();
		});
		
		cmbSMSSENDCOTEMP = new dhtmlXCombo("cmbSMSSENDCOTEMP");
		cmbSMSSENDCOTEMP.setSize(150);
		cmbSMSSENDCOTEMP.addOption([	
			{value: "현대택배", text: "현대택배",selected: true},
			{value: "한진택배", text: "한진택배"},
			{value: "우체국택배", text: "우체국택배"},
			{value: "로젠택배", text: "로젠택배"},
			{value: "CJ택배", text: "CJ택배"},
			{value: "직배", text: "직배"},
			{value: "등기", text: "등기"}
		]);
		
		txtRADIO2 = $erp.getDhtmlXRadio('txtRADIO2','txtRADIO2',['A','B'],0,['즉시전송','예약전송'],'label-right');
        $('#txtSTR_DT').attr("disabled", true);
        cmbTime.disable();
		cmbMin.disable();
        txtRADIO2.attachEvent('onChange', function (name, value){
        	if(value == "B"){
        		cmbTime.setComboValue(0);
            	cmbMin.setComboValue(0);
        		$('#txtSTR_DT').attr("disabled", false);
        		cmbTime.enable();
    			cmbMin.enable();
			} else {
				cmbTime.setComboValue("00");
	        	cmbMin.setComboValue("00");
				$('#txtSTR_DT').attr("disabled", true);
		        cmbTime.disable();
				cmbMin.disable();
			}
		});
        
        var comCdArr1 = new Array();
		comCdArr1[0] = 'SMS_SEND_INF';
		comCdArr1[1] = '${empSessionDto.warea_cd}';
        cmbSMSSEND = $erp.getTbsDhtmlXCombo('cmbSMSSEND', 'SMS_SEND_INF', comCdArr1, 120, false);
        
      	//지역
		cmbBUSINESS_INF = $erp.getTbsDhtmlXCombo('cmbBUSINESS_INF', 'SMS_SEND_BUSINESS_INF', 'SMS_SEND_BUSINESS_INF', 150, null, null, function(){
			cmbBUSINESS_INF.attachEvent("onChange", function(value, text){
				$.ajax({
					url : "/common/getTbsCommonCodeList.do",
					type: "POST",
					dataType : "JSON",
					data : {
						'CMMN_CD' : 'SMS_SEND_BANK_INF'
						,'DIV1' : value
						,'DIV2' : ''
						,'DIV3' : ''
						,'DIV4' : ''
						,'DIV5' : ''
					},
					success : function (data) {
						var list = data.commonCodeList;
						
						cmbSANCTION_INF.unSelectOption();
						cmbSANCTION_INF.clearAll();
						
						cmbSANCTION_INF.addOption("","선택","color:black",null,true);		
						for(var i=0; i < list.length; i++) {
							cmbSANCTION_INF.addOption(list[i].CMMN_DETAIL_CD,list[i].CMMN_DETAIL_CD_NM);
						}
						
						cmbSANCTION_INF.selectOption(0);
					}
				});
			});
		});
		
		var comCdArr2 = new Array();
		comCdArr2[0] = 'SMS_SEND_BANK_INF';
		comCdArr2[1] = '${empSessionDto.warea_cd}';
		
		cmbSANCTION_INF = $erp.getTbsDhtmlXCombo('cmbSANCTION_INF', 'SMS_SEND_BANK_INF', comCdArr2, 150, null, null);
		cmbSANCTION_INF.attachEvent("onChange", function(value, text){
			if(value != ""){
				txtCheck.uncheckItem('txtCheck');
				txtRADIO.checkItem('txtRADIO','20');
				$('#txtSubject').val("(주)윈플러스");
				$('#txtSubject').attr("disabled", false);
				document.getElementById('byteInfo').innerText = "";
				var MEMBER_NAME = document.getElementById("MEMBER_NAME").value;
				
				var strSMS_TMemo = "안녕하세요~ 윈플러스 계좌 안내 메세지 입니다.\n입금하실 계좌는 [";
				strSMS_TMemo += text;
				strSMS_TMemo += "] 입니다.\n행복한 하루 되시기 바랍니다~\n담당자:"+MEMBER_NAME;
				
				var strHtml = "<textarea rows='12' cols='*' id='txtArea' onKeyUp='javascript:fnChkByte(this,90,0)'>";
				strHtml += strSMS_TMemo;
				strHtml += "</textarea>";
					
				document.getElementById('tt').innerHTML =strHtml;
			}
		});
		cmbSANCTION_INF.addOption("","선택","color:black",null,true);
      	
		txtCheck = $erp.getDhtmlXCheckBox("txtCheck",'광고유무', 'Y', true, 'label-right');
	}
	
	function fnSMSTempList(){
		
		$.ajax({
			url : "/tbs/customerorder/searchSMSTEMPList.do"
			,data : {
				"strValue" : strValue
 			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					$erp.clearDhtmlXGrid(erpGrid);
					var gridDataList = data.gridDataList;
					if($erp.isEmpty(gridDataList)){
						
					} else {
						erpGrid.parse(gridDataList, 'js');
					}
				}
				
			}, error : function(jqXHR, textStatus, errorThrown){
				
				erpLayout.progressOff();
			}
		});
	}
	
	function fnChkByte(obj, maxByte, gubun){
		var str = obj.value;
		var str_len = str.length;
		 
		var rbyte = 0;
		var rlen = 0;
		var one_char = "";
		var str2 = "";
		 
		for(var i=0; i<str_len; i++){
			one_char = str.charAt(i);
			if(escape(one_char).length > 4){
		    	rbyte += 2;                                         //한글2Byte
			} else {
			    rbyte++;                                            //영문 등 나머지 1Byte
			}
		 
			if(rbyte <= maxByte){
			    rlen = i+1;                                          //return할 문자열 갯수
			}
		}
		
		if(rbyte > maxByte){
		   if(gubun == 0){
			   txtRADIO.checkItem('txtRADIO','20');
			   $('#txtSubject').val("(주)윈플러스");
			   $('#txtSubject').attr("disabled", false);
			   document.getElementById('byteInfo').innerText = "";   
		   }else if(gubun == 1){
			   var alertMessage = "한글 "+(maxByte/2)+"자 / 영문 "+maxByte+"자를 초과 입력할 수 없습니다.";
	    		var alertCode = "-1";
	    		var alertType = "alert";
	    		var isAjax = false;
	    		
	    		$erp.alertMessage({
	    			"alertMessage" : alertMessage
	    			, "alertType" : alertType
	    			, "isAjax" : isAjax
	    		});
			    
			    str2 = str.substr(0,rlen);                                  //문자열 자르기
			    obj.value = str2;
			    fnChkByte(obj, maxByte,1);
		   }
		}else{
			if(gubun == 0){
				txtRADIO.checkItem('txtRADIO','10');
				$('#txtSubject').val("");
				$('#txtSubject').attr("disabled", true);
				document.getElementById('byteInfo').innerText = rbyte+"/90 Byte";  
			}
		}
	}
	
	/**
	 * textarea의 rows보다 라인이 더 입력되면,
	 * 입력받은 이벤트를 무시한다. 
	 * 따라서 onKeyPress 에 걸어줘야 함.
	 */
	function fixRowTextArea(textarea){
		var tn=document.getElementById('txtArea');
		var borderH=(tn.offsetHeight-tn.clientHeight)/2;
		var lineC=(tn.scrollHeight-borderH)/((tn.clientHeight-borderH)/tn.rows);
		 
		if(lineC > 10){
			var alertMessage = "ENTER(줄바꿈)은 10줄 이내 입니다.";
    		var alertCode = "";
    		var alertType = "alert";
    		var isAjax = false;
    		
    		$erp.alertMessage({
    			"alertMessage" : alertMessage
    			, "alertType" : alertType
    			, "isAjax" : isAjax
    		});
		}
	}
	
	function fnSMSSendTemp(){
		txtCheck.uncheckItem('txtCheck');
		txtRADIO.checkItem('txtRADIO','20');
		$('#txtSubject').val("(주)윈플러스");
		$('#txtSubject').attr("disabled", false);
		
		var cmbSMSSENDCOTEMP_CD = cmbSMSSENDCOTEMP.getSelectedValue(); //팀
		document.getElementById('byteInfo').innerText = "";
		var MEMBER_NAME = document.getElementById("MEMBER_NAME").value;
		
		var strSMS_TMemo = "안녕하세요~ 윈플러스 택배관련 안내 메세지 입니다.\n주문하신 제품은 [";
		strSMS_TMemo += cmbSMSSENDCOTEMP_CD;
		strSMS_TMemo += ", 택배번호:";
		strSMS_TMemo += $('#txtSendNum').val();
		strSMS_TMemo += "]로 발송 처리 되었습니다.\n행복한 하루 되시기 바랍니다~\n담당자:"+MEMBER_NAME;
		
		var strHtml = "<textarea rows='12' cols='*' id='txtArea' onKeyUp='javascript:fnChkByte(this,90,0)'>";
		strHtml += strSMS_TMemo;
		strHtml += "</textarea>";
			
		document.getElementById('tt').innerHTML =strHtml;
	}
	
	function beforeSmsSend(){
		var validCheck=true;
		var alertMessage='';
		
		var strtxtRADIO =  $("input[name=txtRADIO]").val(); //단문/장문 유무
		var strtxtSubject = $("#txtSubject").val(); //제목
		if(strtxtRADIO == "20"){
			//장문일 경우 제목이 있는지 체크 
			if(strtxtSubject == ""){
				alertMessage = "제목을 입력하세요.";
				validCheck = false;
			}
		}
		
		//문자 발송 내용 유무 확인
		var strTextarea = $('#txtArea').val();
		if(strTextarea == ''){
			alertMessage = "문자 내용을 입력하세요.";
			validCheck = false;
		}
		
		//선택 번호에 따른 번호 유무 체크
		var strontNum = $("input[name=ontNum]").val();
		var strtxtNumOne = $("#txtNumOne").val(); //1차번호
		var strtxtNumTwo = $("#txtNumTwo").val(); //2차번호
		var strtxtNumThree = $("#txtNumThree").val(); //3차번호
		var strtxtNumFour = $("#txtNumFour").val(); //수신번호
		var RECEIVER = "";
		
		if(strontNum == 'A'){
			RECEIVER = strtxtNumOne;
		} else if(strontNum == 'B'){
			RECEIVER = strtxtNumTwo;
		} else if(strontNum == 'C'){
			RECEIVER = strtxtNumThree;
		} else if(strontNum == 'D'){
			RECEIVER = strtxtNumFour;
		}
		
		if(RECEIVER == ''){
			alertMessage = "선택하신 번호에 전화번호가 없습니다.";
			validCheck = false;
		}
		
		//전송 방법
		var strtxtRADIO2 = $("input[name=txtRADIO2]").val();
		var strcmbTime = cmbTime.getSelectedValue(); //시
		var strcmbMin = cmbMin.getSelectedValue(); //분
		//예약전송일 경우 시간&분 선택
		if(strtxtRADIO2 == 'B'){
			if(strcmbTime == '' ){
	    		alertMessage = "시간(시)을 선택하세요.";
	    		validCheck = false;
			}
			if(strcmbMin == '' ){
				alertMessage = "시간(분)을 선택하세요.";
	    		validCheck = false;
			}
		}
		
		//대표번호
		var strcmbSMSSEND = cmbSMSSEND.getSelectedValue(); //팀
		if(strcmbSMSSEND == ''){
    		alertMessage = "대표번호를 선택하세요.";
    		validCheck = false;
		}
		
		if(!validCheck){
			$erp.alertMessage({
	        	"alertMessage" : alertMessage
	       		, "alertType" : "alert"
	        	, "isAjax" : false
	        });
		}else{
			var CUSTOMER_CODE = $('#CUSTOMER_CODE').val();
			if(CUSTOMER_CODE == ""){
				$erp.confirmMessage({
					"alertMessage" : "고객을 조회하지 않아 고객코드를 불러올 수 없습니다. 고객코드 없이 SMS 발송 시 통화기록에 남겨지지 않습니다. 그래도 발송하시겠습니까?"
					, "alertCode" : ""
					, "alertType" : "alert"
					, "alertCallbackFn" : function(){
						fnSaveSmsSend();
					}
				});
			}else{
				fnSaveSmsSend();
			}
		}
	}

	function fnSaveSmsSend(){
		var strtxtCheck = checkBoxCheckedVal(txtCheck); //광고유무
		var strtxtRADIO =  $("input[name=txtRADIO]").val(); //단문/장문 유무
		var strtxtSubject = $("#txtSubject").val(); //제목
		
		if(strtxtCheck == "0"){
			strtxtCheck = "N";
		}else{
			strtxtCheck = "Y";
		}

		var strTextarea = $('#txtArea').val();
		
		var strontNum = $("input[name=ontNum]").val();
		var strtxtNumOne = $("#txtNumOne").val(); //1차번호
		var strtxtNumTwo = $("#txtNumTwo").val(); //2차번호
		var strtxtNumThree = $("#txtNumThree").val(); //3차번호
		var strtxtNumFour = $("#txtNumFour").val(); //수신번호
		var RECEIVER = "";
		
		if(strontNum == 'A'){
			RECEIVER = strtxtNumOne;
		} else if(strontNum == 'B'){
			RECEIVER = strtxtNumTwo;
		} else if(strontNum == 'C'){
			RECEIVER = strtxtNumThree;
		} else if(strontNum == 'D'){
			RECEIVER = strtxtNumFour;
		}
		
		var strtxtRADIO2 = $("input[name=txtRADIO2]").val();
		var strtxtSTR_DT = $('#txtSTR_DT').val();
		var strcmbTime = cmbTime.getSelectedValue();
		var strcmbMin = cmbMin.getSelectedValue();
		//예약전송일 경우 시간 분 선택
		if(strtxtRADIO2 == 'B'){
			strtxtSTR_DT = strtxtSTR_DT + " " + strcmbTime + ":" + strcmbMin;
		} else { 
			//strtxtSTR_DT = strtxtSTR_DT + "000000";
			strtxtSTR_DT = "";
		}
		
		//대표번호
		var strcmbSMSSEND = cmbSMSSEND.getSelectedValue(); //팀
		var CUSTOMER_CODE = $('#CUSTOMER_CODE').val();

 		$.ajax({
			url : "/tbs/customerorder/insertSMSTEMP.do"
			,data : {
				"SENDER" : strcmbSMSSEND,
				"RECEIVER" : RECEIVER,
				"MESSAGE" : strTextarea,
				"SUBJECT" : strtxtSubject,
				"RESERVE_TIME" : strtxtSTR_DT,
				"SMSMMS" : strtxtRADIO,
				"AD_YN" : strtxtCheck,
				"CUSTOMER_CODE" : CUSTOMER_CODE
 			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				
				erpLayout.progressOff();
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {
					if(data.resultRowCnt2 == 1){
						$erp.alertMessage({
			    			"alertMessage" : "메세지 전송을 완료하였습니다."
			    			, "alertType" : "alert"
			    			, "isAjax" : false
			    			, "alertCallbackFn" : function(){
			    				window.close();
			    			}
			    		});
					}else{
						$erp.alertMessage({
			    			"alertMessage" : "메세지 전송은 완료하였으나, 통화기록 저장에 실패하였습니다. 개발팀에 문의하세요."
			    			, "alertType" : "alert"
			    			, "isAjax" : false
			    		});
					}
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				erpLayout.progressOff();
			}
		});
	}
	
	function checkBoxCheckedVal(obj){      
	   var t = obj.getFormData();
	   var p = "";
	   for (var a in t){
	      //p += a+": "+String(t[a])+"\n";
	      p += t[a];
	   }
	   
	   return p;
	}
</script>
</head>
<body>
	<div id="div_erp_ribbon" class="div_ribbon_full_size" style="display:none"></div>
	<div id="div_erp_left_content" class="div_common_contents_full_size" style="display:none">
		<table id="table_search" class="tb_erp_common" style="margin-top: 1px;">
			<colgroup>
				<col width="110px">
				<col width="90px">
				<col width="60px">
				<col width="30px">
				<col width="*">
			</colgroup>
			<tr>
				<td colspan="4">
					<div id="txtRADIO"></div>
				</td>
				<td>
					<div id="txtCheck"></div>
				</td>
			</tr>
			<tr>
				<th>제목</th>
				<td colspan="4">
					<input type="text" id="txtSubject" value="" style="width:90%;" onKeyUp="javascript:fnChkByte(this,'120',1)"/>
				</td>
			</tr>
			<tr>
				<td colspan="5"><div id ='tt'></div>
					<textarea rows="12" cols="*" id="txtArea" onKeyUp="javascript:fnChkByte(this,'90',0)" style="IME-MODE: active"></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="5" style="text-align: right;"><span id="byteInfo">0/90 Byte</span>&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<th rowspan="4">
					<div id="ontNum"></div>
				</th>
				<td>
					<input type="text" id="txtNumOne" class="input_common input_readonly" value="${strCUSTOMER_THP}" style="width:80px;" maxlength="11" readonly>
					<input type="hidden" id="CUSTOMER_CODE" value="${CUSTOMER_CODE}" >
					<input type="hidden" id="CUSTOMER_NAME" value="${CUSTOMER_NAME}" >
					<input type="hidden" id="MEMBER_NAME" value="${MEMBER_NAME}" >
					<input type="hidden" id="YYYYMMDD" value="${YYYYMMDD}" >
				</td>
				<td colspan="3">
					<div id="txtRADIO2"></div>
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" id="txtNumTwo" class="input_common input_readonly" value="${strCUSTOMER_TCP}" style="width:80px;" maxlength="11" readonly>
				</td>
				<td colspan="3">
					<input type="text" id="txtSTR_DT" name="txtSTR_DT" class="input_calendar" maxlength="10">
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" id="txtNumThree" class="input_common input_readonly" value="${strCUSTOMER_TEMP}" style="width:80px;" maxlength="11" readonly>
				</td>
				<td colspan="2">
					<div id="cmbTime"></div>
				</td>
				<td>
					<div id="cmbMin"></div>
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" id="txtNumFour" class="input_common input_essential" value="" style="width:80px;" maxlength="11" class="input_phone">
				</td>
				<th>
					대표번호
				</th>
				<td colspan="2">
					<div id="cmbSMSSEND"></div>					
				</td>
			</tr>
			<tr>
				<td colspan="5" class="td_subject"><div id="div_data_info" class="common_left">※ <b>수신번호를 꼭 확인해주세요!</b> (팝업을 계속 열어둘 경우 이전 고객의 번호로 지정되어 있을 수 있습니다. 다른 고객의 번호로 발송하고 싶다면 창을 닫고 다시 열어주세요.)</div></td>
			</tr>
		</table>
	</div>
	<div id="div_erp_right_content" class="div_common_contents_full_size" style="display:none"></div>
	<div id="div_erp_right_content1" class="div_common_contents_full_size" style="display:none">
		<table id="table_search" class="tb_erp_common" style="margin-top: 1px;">
			<colgroup>
				<col width="100px">
				<col width="*">
			</colgroup>
			<tr>
				<th>문자템플릿
				</th>
				<td>
					<div id="cmbSMSTEMP"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id="div_erp_right_grid" class="div_grid_full_size" style="display:none"></div>
	<div id="div_erp_right_content2" class="div_common_contents_full_size" style="display:none">
		<table id="table_search" class="tb_erp_common" style="margin-top: 1px;">
			<colgroup>
				<col width="100px">
				<col width="*">
			</colgroup>
			<tr>
				<td colspan="2"><span class='span_essential'>*</span>은행 정보</td>
			</tr>
			<tr>
				<th>지역</th>
				<td>
					<div id="cmbBUSINESS_INF"></div>
				</td>
			</tr>
			<tr>
				<th>은행</th>
				<td>
					<div id="cmbSANCTION_INF"></div>
				</td>
			</tr>
			<tr>
				<td colspan="2"><span class='span_essential'>*</span>발송 정보</td>
			</tr>
			<tr>
				
				<th>택배사</th>
				<td>
					<div id="cmbSMSSENDCOTEMP"></div>
				</td>
			</tr>
			<tr>
				<th>번호</th>
				<td>
					<input type="text" id="txtSendNum" value="" style="width:110px;" class="input_number"/>
					<input type="button" value="택배번호 적용" class="input_common_button" onClick="fnSMSSendTemp();"/>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>