<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %> 
<script type="text/javascript">
	<%-- JavaScript 전역 변수 선언 영역 --%>	
	var currentMenu_cd = "${currentMenu_cd}";	
	//var indexLayout = parent.indexLayout;
	//var indexDoc = indexLayout.base.ownerDocument;
	//var indexWindow = indexDoc.defaultView || indexDoc.parentWindow;
	
	<%@ include file="/WEB-INF/jsp/common/include/default_common_header.jsp" %>
	
	<%-- DOM Ready 완료 시 호출 Function --%>
	$(document).ready(function(){
		$.ajaxSetup({
			  data:{ "currentMenu_cd" : currentMenu_cd }			  
		});
	
		<%-- Body Ready 완료 시 버튼 권한 부여 처리 --%>
		$(document.body).ready(bodyReady);
		
		/* document.oncontextmenu = function(){ // 컨텍스트 메뉴금지 - 마우스 오른쪽 버튼 금지
			return false;
		}; */
	});
	
	<%-- 새로고침 뒤로가기 방지 --%>
	$(document).keydown(function (e) {
		/* 새주문서작성 전용 키 기능 시작 */
		if(parent.erpPopupWindows.w != null && parent.erpPopupWindows.w != undefined){
			if(parent.erpPopupWindows.w.openTellOrderCTIPopup != null && parent.erpPopupWindows.w.openTellOrderCTIPopup != undefined){
				if (e.keyCode === 118) {//F7
					if(!$erp.isEmpty(openPastOrderGridPopup) && typeof openPastOrderGridPopup === 'function'){
						openPastOrderGridPopup();
					}
					return false;
				}
				if (e.keyCode === 119) {//F8
					if(!$erp.isEmpty(openSearchGoodsGridPopup) && typeof openSearchGoodsGridPopup === 'function'){
						openSearchGoodsGridPopup();
					}
					return false;
				}
			}
		}
		/* 새주문서작성 전용 키 기능 끝 */
		
        if (e.keyCode === 116) {
        	key_event_noRenew();
            return false;
        }
         
         erpPopupWindowsCell = this.erpPopupWindowsCell;
        
         if (e.keyCode === 27) {
        	if(!$erp.isEmpty(erpPopupWindowsCell)){
				key_event_finish();
	        }
        }
        
        var t = document.activeElement; 
 		if (e.keyCode === 8) { 
 	   		if (t.readOnly){
 	   			key_event_backspace();
	   			return false;
 	        }
 	   		
 	   		if(t.tagName != "INPUT" && t.tagName != "TEXTAREA"){
 	   			key_event_backspace();
	    		return false;
 	   		}
 	    }
    });
	
	function key_event_finish(){
		erpPopupWindowsCell.close();
        return false;
	}
	
	function key_event_backspace(){
        $('body').pgpopup({
            type:'slide', // 팝업형태 (toast, layer, slide)
            msg:'뒤로가기를 하실 수 없습니다.',// 메시지
        	padding:'10px',              // 여백
            width:'50%',                // 토스트폭, %로 지정
            color:'#ffffff',               // 내용 글자색
            bgcolor:'#111111',        // 레이어 배경색, #111111 와 같이 헥사코드 이용
            transparency:'0.8',         // 투명도, 0.8 과 같이 값을 입력, 최대 1
            delay:'2000',                // 얼마의 시간이 지난뒤 사라지게 할것인지 , 1000 = 1초, toast와 slide에만 적용됨
            time:'500',                 // 서서히 보여지는 시간, 1000 = 1초
            direction:'up',               // slide 팝업의 경우 어느방향에서 나타나게 할지의 여부(up,down)
			font_size : '15'		//폰트사이즈

        });
    }
	
	function key_event_noRenew(){
		$('body').pgpopup({
            type:'slide', // 팝업형태 (toast, layer, slide)
            msg:'새로고침을 하실 수 없습니다.',// 메시지
        	padding:'10px',              // 여백
            width:'50%',                // 토스트폭, %로 지정
            color:'#ffffff',               // 내용 글자색
            bgcolor:'#111111',        // 레이어 배경색, #111111 와 같이 헥사코드 이용
            transparency:'0.8',         // 투명도, 0.8 과 같이 값을 입력, 최대 1
            delay:'2000',                // 얼마의 시간이 지난뒤 사라지게 할것인지 , 1000 = 1초, toast와 slide에만 적용됨
            time:'500',                 // 서서히 보여지는 시간, 1000 = 1초
            direction:'up',               // slide 팝업의 경우 어느방향에서 나타나게 할지의 여부(up,down)
			font_size : '15'		//폰트사이즈
        });
	}
	
	function bodyReady(){
		<c:if test='${menuDto != null}'>
		var enableIdPrefix = [];		
			<%-- 조회, 엑셀 권한 --%>
			<c:if test='${menuDto.use_yn == "Y"}'>
				enableIdPrefix.push("search");
				enableIdPrefix.push("reload");		
			</c:if>		
			<%-- 추가 권한 --%>
			<c:if test='${menuDto.adit_yn == "Y"}'>
				enableIdPrefix.push("adit");
				enableIdPrefix.push("add");
			</c:if>
			<%-- 삭제 권한 --%>
			<c:if test='${menuDto.delete_yn == "Y"}'>
				enableIdPrefix.push("delete");
			</c:if>
			<%-- 수정(저장) 권한 --%>
			<c:if test='${menuDto.adit_yn == "Y" || menuDto.delete_yn == "Y" || menuDto.stre_yn == "Y"}'>
				enableIdPrefix.push("stre");
				enableIdPrefix.push("update");
				enableIdPrefix.push("save");
				enableIdPrefix.push("upload");
				enableIdPrefix.push("apply");
				enableIdPrefix.push("reject");
				enableIdPrefix.push("cancel");
				enableIdPrefix.push("send");
				enableIdPrefix.push("download");
				enableIdPrefix.push("draft");
			</c:if>
			<%-- 엑셀 관련 권한 --%>
			<c:if test='${menuDto.excel_yn == "Y"}'>
				enableIdPrefix.push("excel");
			</c:if>
			<%-- 출력 관련 권한 --%>
			<c:if test='${menuDto.print_yn == "Y"}'>
				enableIdPrefix.push("print");
			</c:if>
		
			<%-- 권한 별 버튼 활성화 --%>
			for(var prop in window){			
				if(prop == "webkitStorageInfo") { continue; } 
				if(window[prop] && window[prop].isDhtmlxRibbon){
					var tempDhtmlxRibbon = window[prop];			
					var idArray = tempDhtmlxRibbon._items;
					for(var id in idArray){
						var item = idArray[id];	
						if(item && item.conf && item.type && item.type === "button"){
							tempDhtmlxRibbon.hide(id);	
						}
					}
					for(var i in enableIdPrefix){
						var prefix = enableIdPrefix[i];
						for(var id in idArray){
							var item = idArray[id];
							if(id && prefix.length <= id.length && prefix == id.substring(0, prefix.length)){															
								if(item){
									if(!(item.conf.unused && item.conf.unused === true)){
										tempDhtmlxRibbon.enable(id);		
										tempDhtmlxRibbon.show(id);
									} else {
										tempDhtmlxRibbon.show(id);
									}									
								}
							}
						}
					}
				}
			}
		</c:if>
		
		initDomInputEvent();
	}
	
	function initDomInputEvent(){
		<%-- 정수형 --%>
		initDomInputTextNumber();
		<%-- 실수형 --%>
		initDomInputTextDecimal();
		<%-- 전화번호 (정수 + 하이픈) --%>
		initDomInputTextPhone('<spring:message code="error.common.invalidPhoneNumberFormat" />');
		<%-- 회계형 (정수 + 쉼표) --%>
		initDomInputTextMoney();
		initDomInputTextMoney2();
		<%-- 사업자등록번호 (정수 + 하이픈) --%>
		initDomInputTextBizrNo('<spring:message code="error.common.invalidBizrNoFormat" />');		
		<%-- 날짜 Input Text --%>
		initDomInputTextDate('<spring:message code="error.common.invalidDateFormat" />');
		
		if(window["onAllInputDomReady"] != undefined && window["onAllInputDomReady"] != null && typeof window["onAllInputDomReady"] == "function"){
			window["onAllInputDomReady"]();
		}
	}	
</script>