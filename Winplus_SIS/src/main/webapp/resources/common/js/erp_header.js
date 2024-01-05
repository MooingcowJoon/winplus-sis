/** 
 * Description 
 * @Resource ERP Header Script
 * @since 2016.10.24
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2016.10.24 / 김종훈 / 신규 생성
 *********************************************
 */

/* jQuery Post Parameter Name Classic Mode Setting */
jQuery.ajaxSettings.traditional = true;
/* 전역 변수 영역 */
/* 디자인 및 스킨 관련 전역 변수는 common header JSP 파일 참조 (JSP의 JSTL 사용을 위하여 분리) */
var isIndex = true;
var compMenu = false;
var powMenu = false;
var menuList = null;

var indexWindow = null;
var indexLayout = null;
var indexSubLayout = null;

var contentsTabBar = null;
var erpMenuToolbar = null;
var erpMenuTree = null;
var erpPopupWindows = null;
var ERP_WINDOWS_DEFAULT_ID = "divErpPopupWindow";
var ERP_WINDOWS_CONSULT_ID = "divErpConsultPopupWindow";

/** 
 * Description 
 * @function logout
 * @function_Description LogOut Page 이동
 * @param 
 * @author 김종훈
 */
function logout(){
	if(contentsTabBar.tabs("00299") != null){
		if(contentsTabBar.tabs("00299").isActive()){
			var attachedObject = contentsTabBar.tabs("00299").getAttachedObject();
			try {
				if(attachedObject.tagName && attachedObject.tagName.toLowerCase() == "iframe"){
					var iframeContent = attachedObject.contentWindow;
					if(id="00299"){
						iframeContent.ippbxLogout();
					}
				}
				attachedObject = undefined;
			} catch (e){}
		}
	}
	
	location.href="/login.sis?logout=Y";	
}
/** 
 * Description 
 * @function sessionOut
 * @function_Description LogOut Page 이동
 * @param 
 * @author 주병훈
 */
function sessionOut(){
	if(contentsTabBar.tabs("00299") != null){
		if(contentsTabBar.tabs("00299").isActive()){
			var attachedObject = contentsTabBar.tabs("00299").getAttachedObject();
			try {
				if(attachedObject.tagName && attachedObject.tagName.toLowerCase() == "iframe"){
					var iframeContent = attachedObject.contentWindow;
					if(id="00299"){
						iframeContent.ippbxLogout();
					}
				}
				attachedObject = undefined;
			} catch (e){}
		}
	}
	
	location.href="/sessionOut.sis";	
}

/** 
 * Description 
 * @function openSearchEmpLoginAddListPopup
 * @function_Description 로그인 변경 리스트 팝업
 * @param 
 * @author 주병훈
 */
function openSearchEmpLoginAddListPopup(sRId, sCInd){

	var onRowDblClicked = function(rId, cInd){
		var empNo = this.cells(rId, this.getColIndexById("EMP_NO_LOGIN_ADD")).getValue();
		
		$.ajax({
			url : "/loginChange.do"
			,data : {
				"EMP_NO" : empNo
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {			
					top.location.href = "/index.sis";
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
		
		$erp.closePopup();			
	}
	
	$erp.openSearchEmpLoginAddListPopup(onRowDblClicked);
}

/** 
 * Description 
 * @function loadScreen
 * @function_Description ERP 상세 화면 불러오기
 * @param menu_cd (String)
 * @param param (Object) / 추가 파라미터
 * @param isReload (boolean) / 이미 열린 화면에 대한 새로고침 여부
 * @author 김종훈
 */
function loadScreen(menu_cd, param, isReload){
	$.ajax({
		url : "/common/system/authority/getScreenPath.do"
		,data : { 
			"MENU_CD" : menu_cd
			, "MAIN_YN" : "Y"
		}		
		,method : "POST"
		,dataType : "JSON"
		,success : function(data){
			if(data.isError){
				$erp.ajaxErrorMessage(data);
			} else {
				var scrin_path = data.scrin_path;
				var menu_nm = data.menu_nm;		
				var isOpen = false;
				
				if(menu_cd == "00743"){	//전화주문신규메뉴
					if(ctiWin == null || ctiWin == undefined || ctiWin.name != "CTIWindow"){
						ctiWin = window.open("", "CTIWindow");
						var ctiForm = document.getElementById("ctiWinForm");
						document.getElementById("ctiWin_currentMenu_cd").value = menu_cd;
						document.getElementById("ctiWin_MAIN_YN").value = "Y";
						ctiForm.target = "CTIWindow";
						ctiForm.action = scrin_path;
						ctiForm.submit();
					}else{
						ctiWin.focus();
					}
				}else{
					if(contentsTabBar.tabs(menu_cd) == undefined || contentsTabBar.tabs(menu_cd) == null){
						contentsTabBar.addTab(menu_cd, menu_nm);
						isOpen = true;
					} else if (isReload === true){
						isOpen = true;
					}
					
					if(isOpen === true){
						if($erp.isEmpty(param) || typeof param !== 'object' || $erp.isArray(param)){
							param = {};
						}
						param.currentMenu_cd = menu_cd;
						param.MAIN_YN = "Y";
						contentsTabBar.tabs(menu_cd).attachURL(scrin_path, false, param);
					}
					contentsTabBar.tabs(menu_cd).setActive();
				}
			}
		}, error : function(jqXHR, textStatus, errorThrown){
			$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
		}
	});
}

var ctiWin

/** 
 * Description 
 * @function closeContentsTabBar
 * @function_Description ERP Contents TabBar 닫기
 * @param isAll (boolean)	/ true : 모든 메뉴 닫기, false : 활성화 된 탭을 제외한 모든 메뉴 닫기
 * @author 김종훈
 */
function closeContentsTabBar(isAll){
	var tabCount = contentsTabBar.getNumberOfTabs();
	if(tabCount == 1){
		var alertMessage = "error.common.noTabCount";
		var alertCode = null;
		var alertType = "error";
		var param = $erp.makeMessageParam(alertMessage, alertCode, alertType);
		$erp.alertMessage(param);
	} else {
		var tabActvId = contentsTabBar.getActiveTab();	
		var tabIds = contentsTabBar.getAllTabs();
		for(var i in tabIds){
			var tabId = tabIds[i];		
			if(tabId == 'main'){ //HOME은 삭제 불가
				continue;
			} else if(tabId == tabActvId){	// 활성화 탭 ID와 같으면 isAll Param이 True일 때만 삭제
				if(isAll == true){
					contentsTabBar.tabs(tabId).close();
				} else {
					continue;
				}
			} else {
				contentsTabBar.tabs(tabId).close();
			}
		}
		if(isAll == true){
			contentsTabBar.tabs('main').setActive();
		} else {
			contentsTabBar.tabs(tabActvId).setActive();
		}
	}	
}

/** 
 * Description 
 * @function initErpMenuTree
 * @function_Description ERP Menu Tree 형식으로 초기화
 * @param parentObjId (String)	/ DhtmlXTree Object를 구성할 Parent Dom Object ID
 * @author 김종훈
 */
function initErpMenuTree(parentDomObjId){
	erpMenuTree = new dhtmlXTreeObject({
		parent : parentDomObjId
		, skin : ERP_TREE_CURRENT_SKINS			
		, image_path : ERP_TREE_CURRENT_IMAGE_PATH
	});
	erpMenuTree.attachEvent("onClick", function(id){
		var subItems = this.getSubItems(id);
		if(subItems && subItems.length > 0) {
			return true;
		}
		var tabCnt = contentsTabBar.getNumberOfTabs();
		if(tabCnt > 30){
			$erp.alertMessage({
				"alertMessage" : "error.common.overTabCount"
				, "alertType" : "error"
			});
			return true;
		}
		loadScreen(id);
	});
	searchErpMenuTree();
}

/** 
 * Description 
 * @function initErpMenuToolbar
 * @function_Description ERP DhtmlXToolbar 초기화
 * @param parentObjId (String)	/ DhtmlXToolbar Object를 구성할 Parent Dom Object ID
 * @param expandsText (String)	/ 펼침 Text
 * @param collapseText (String)	/ 접기 Text
 * @param closeAllTabsText (String)	/ 모든탭닫기 Text
 * @author 김종훈
 */
function initErpMenuToolbar(parentDomObjId, expandsText, collapseText, closeAllTabsText){
	erpMenuToolbar = new dhtmlXToolbarObject({
	    parent : parentDomObjId
	    , image_path : ERP_TOOLBAR_CURRENT_IMAGE_PATH
	    , icons_path : ERP_TOOLBAR_CURRENT_ICON_PATH
	    , items:[
	        {id: "expands", type: "button", text: expandsText, img: "menu/plus.gif"}
	        , {id: "collapse", type: "button", text: collapseText, img: "menu/minus.gif"}
	        , {id: "closeAllTabs", type: "button", text: closeAllTabsText, img: "menu/delete.gif"}
	    ]
	});
	
	erpMenuToolbar.attachEvent("onClick", function(id){
	    if(id == "expands"){
	    	erpMenuTree.openAllItems("0");
	    } else if(id == "collapse"){
	    	erpMenuTree.closeAllItems("0");
	    } else if(id="closeAllTabs"){
	    	contentsTabBar.forEachTab(function(tab){
	    	    var id = tab.getId();
	    	    if(contentsTabBar.t[id].conf.close !== false){
	    	    	tab.close();
	    	    }
	    	});
	    	var tabIds = contentsTabBar.getAllTabs();
	    	if(tabIds.length > 0){
	    		contentsTabBar.tabs(tabIds[0]).setActive();
	    	}
	    }
	});
}

/** 
 * Description 
 * @function initErpLayout
 * @function_Description ERP DhtmlXLayout 초기화
 * @param menuListName (String)	/ 좌측 메뉴 헤더 이름
 * @param topDomObjId (String)	/ 상단 Layout 를 구성할 Parent Dom Object ID
 * @param leftDomObjId (String)	/ 좌측 Layout 를 구성할 Parent Dom Object ID
 * @param contentsDomObjId (String)	/ 중간(우측) Layout 를 구성할 Parent Dom Object ID
 * @author 김종훈
 */
function initErpLayout(menuListName, topDomObjId, leftDomObjId, contentsDomObjId){
	/* 기존 HRIS 폼 메뉴 사용 시 */
	/* , {id: "b", text: "", header:false, width:LAYOUT_LEFT_WIDTH, height:"100%"} */
	indexWindow = window;
	indexLayout = new dhtmlXLayoutObject({
		parent: document.body
		, skin : ERP_LAYOUT_CURRENT_SKINS
		, pattern: "2U"
		, cells: [
			{id: "a", text: menuListName, header:true, width:ERP_INDEX_LAYOUT_LEFT_WIDTH, height:"100%"}
			, {id: "b", text: "", header:false, height:"100%"}
		]		
	});
	
	/* Background Layout Padding 고정 */
	indexLayout.conf.ofs = {b : 0, l : 0, r : 0, t : 0};
	indexLayout.setSizes();

	indexLayout.cells("a").attachObject(leftDomObjId);
	indexLayout.cells("b").attachObject(contentsDomObjId);
	
	indexLayout.attachEvent("onPanelResizeFinish", function(names){	
		if(this.cells("a").getWidth() > ERP_INDEX_LAYOUT_LEFT_WIDTH){
			this.cells("a").setWidth(ERP_INDEX_LAYOUT_LEFT_WIDTH);
		}
		indexSubLayout.setSizes();
		contentsTabBar.setSizes();
	});
	
	indexLayout.attachEvent("onResizeFinish", function(names){	
		indexSubLayout.setSizes();
		contentsTabBar.setSizes();
	});

	indexLayout.attachEvent("onCollapse", function(name){
	    if(name == "a"){
	    	indexSubLayout.setSizes();
	    	contentsTabBar.setSizes();
	    }
	});

	indexLayout.attachEvent("onExpand", function(name){
	    if(name == "a"){
	    	indexSubLayout.setSizes();
	    	contentsTabBar.setSizes();
	    }
	});
}

/** 
 * Description 
 * @function initErpSubLayout
 * @function_Description ERP Sub DhtmlXLayout 초기화
 * @param parentObjId (String)	/ Layout 를 구성할 Parent Dom Object ID
 * @param toolbarDomObjId (String)	/ Menu Toolbar 를 구성할 Parent Dom Object ID
 * @param treeDomObjId (String)	/ Menu Tree 를 구성할 Parent Dom Object ID
 * @author 김종훈
 */
function initErpSubLayout(parentObjId, leftTop1DomObjId, leftTop2DomObjId, toolbarDomObjId, treeDomObjId){
	indexSubLayout = new dhtmlXLayoutObject({
		parent: parentObjId
		, skin : ERP_LAYOUT_CURRENT_SKINS
		, pattern: "4E"
		, cells: [
			{id: "a", text: "", header:false, height : 85,  fix_size: [false, true]}
			, {id: "b", text: "", header:false, height : 50,  fix_size: [false, true]}
			, {id: "c", text: "", header:false, height : ERP_INDEX_LAYOUT_TOOLBAR_HEIGHT,  fix_size: [false, true]}	
			, {id: "d", text: "", header:false}
		]
		, fullScreen : true
	});
	
	indexSubLayout.conf.ofs = {b : 0, l : 0, r : 0, t : 0};
	/* 간격 0px 처리 */
	indexSubLayout.setSeparatorSize(0, 0);
	indexSubLayout.setSizes();
	indexSubLayout.cells("a").attachObject(leftTop1DomObjId);
	indexSubLayout.cells("a").setHeight(85);
	indexSubLayout.cells("b").attachObject(leftTop2DomObjId);
	indexSubLayout.cells("b").setHeight(50);
	indexSubLayout.cells("c").attachObject(toolbarDomObjId);
	indexSubLayout.cells("c").setHeight(ERP_INDEX_LAYOUT_TOOLBAR_HEIGHT);
	indexSubLayout.cells("d").attachObject(treeDomObjId);
}

/** 
 * Description 
 * @function initErpContentsTabBar
 * @function_Description ERP Contents TabBar 초기화
 * @param parentObjId (String)	/ DhtmlXTabBar Object를 구성할 Parent Dom Object ID
 * @author 김종훈
 */
function initErpContentsTabBar(parentObjId){
	contentsTabBar = new dhtmlXTabBar({
		parent : parentObjId
		, skin : ERP_TABBAR_CURRENT_SKINS
		, close_button : true
		, tabs : [
			{ id : "main", text : "HOME", active : true, close : false }
		]
	});	
	//contentsTabBar.tabs("main").attachHTMLString("HomePage");
	contentsTabBar.enableAutoReSize(true);
	contentsTabBar.tabs("main").attachURL("/home.sis", false, {});
	//contentsTabBar = new dhtmlXTabBar(parentObjId);
	//contentsTabBar.setSkin(ERP_TABBAR_CURRENT_SKINS);
	//contentsTabBar.addTab("main", "HOME");	
	//contentsTabBar.tabs("main").setActive();		
	//contentsTabBar.enableTabCloseButton(true);
}

/** 
 * Description 
 * @function searchErpMenuTree
 * @function_Description ERP Menu Tree 조회
 * @author 김종훈
 */
function searchErpMenuTree(){
	indexLayout.cells("b").progressOn();
	$.ajax({
		url : "/common/system/authority/getMenuTreeMap.do"
		,data : {}
		,method : "POST"
		,dataType : "JSON"
		,success : function(data){
			indexLayout.cells("b").progressOff();
			if(data.isError){
				$erp.ajaxErrorMessage(data);
			} else {
				var menuTreeMap = data.menuTreeMap;
				erpMenuTree.parse(menuTreeMap, 'json');
			}
		}, error : function(jqXHR, textStatus, errorThrown){
			indexLayout.cells("b").progressOff();
			$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
		}
	});
}

/** 
 * Description 
 * @function initErpPopupWindows
 * @function_Description ERP 팝업 윈도우 초기화
 * @author 김종훈
 */
function initErpPopupWindows(){
	erpPopupWindows = new dhtmlXWindows({
	    image_path : ERP_WINDOWS_CURRENT_IMAGE_PATH
	    , skin : ERP_WINDOWS_CURRENT_SKINS
	});
	erpPopupWindows.attachViewportTo(document.body);
}

/** 
 * Description 
 * @function initDomInputTextNumber
 * @function_Description ERP Page Input Text 정수형 세팅 (input_number 클래스 가진 것만)
 * @param 
 * @author 김종훈
 */
function initDomInputTextNumber(invalidText){
	$('.input_number[init!="Y"]').keydown(function(e){
		return $erp.isKeyOnlyNumber(event);
	}).blur(function(e){
		var value = $(this).val();
		if(value != ""){
			var value = $(this).val();
			value = value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
			$(this).val(value);
			if(value == "" && !$erp.isEmpty(invalidText)){
				$erp.initDhtmlXPopupDom(e.target, invalidText);
			}
		}
	}).attr("init", "Y");
}

/** 
 * Description 
 * @function initDomInputTextDecimal
 * @function_Description ERP Page Input Text 실수형 세팅 (input_decimal 클래스 가진 것만)
 * @param 
 * @author 김종훈
 */
function initDomInputTextDecimal(invalidText){
	$('.input_decimal[init!="Y"]').keydown(function(e){
		return $erp.isKeyOnlyNumber(event, 'decimal');
	}).blur(function(e){		
		var value = $(this).val();
		if(value != ""){
			value = value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
			$(this).val(value);
			if(value == "" && !$erp.isEmpty(invalidText)){
				$erp.initDhtmlXPopupDom(e.target, invalidText);
			}
		}
	}).attr("init", "Y");
}

/** 
 * Description 
 * @function initDomInputTextPhone
 * @function_Description ERP Page Input Text 숫자 및 하이픈 세팅 (input_phone 클래스 가진 것만)
 * @param 
 * @author 김종훈
 */
function initDomInputTextPhone(invalidText){
	$('.input_phone[init!="Y"]').attr("maxlength", "20").keydown(function(e){
		return $erp.isKeyOnlyNumber(event, 'date');
	}).blur(function(e){		
		var value = $(this).val();
		value = $erp.getPhoneNumberHyphen(value);
		if(value != ""){
			if(!$erp.isPhoneNumber(value)){
				value = "";
			}
			$(this).val(value);
			if(value == "" && !$erp.isEmpty(invalidText)){
				$erp.initDhtmlXPopupDom(e.target, invalidText);
			}
		}
	}).attr("init", "Y");
}

/** 
 * Description 
 * @function initDomInputTextMoney
 * @function_Description ERP Page Input Text Money 타입으로 (input_money 클래스 가진 것만)
 * @param 
 * @author 김종훈
 */
function initDomInputTextMoney(invalidText){
	$('.input_money[init!="Y"]').attr("maxlength", "18").keydown(function(e){
		return $erp.isKeyOnlyNumber(event);
	}).focus(function(e){
		var readonly = e.target.getAttribute("readonly");
		if(readonly){
			return true;
		}		
		var value = $(this).val();
		value = value.replace(/,/g, '');
		$(this).val(value);
	}).blur(function(e){		
		var readonly = e.target.getAttribute("readonly");
		if(readonly){
			return true;
		}		
		
		var value = $(this).val();
		if(value != ""){
			value = value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
			value = $erp.getMoneyFormat(value);
			$(this).val(value);
			if(value == "" && !$erp.isEmpty(invalidText)){
				$erp.initDhtmlXPopupDom(e.target, invalidText);
			}
		}	
	}).attr("init", "Y");
}

/** 
 * Description 
 * @function initDomInputTextMoney
 * @function_Description ERP Page Input Text Money 타입으로 (input_money 클래스 가진 것만)
 * @param 
 * @author 김종훈
 */
function initDomInputTextMoney2(invalidText){
	var regex = /^[-]?\d*$/g;
	
	$('.input_money_m[init!="Y"]').attr("maxlength", "18").keydown(function(e){

		var results = $(this).val().match(/-/g); 
		var resultsNum = 0;
		if(results != null) {
			resultsNum = results.length;
		}

		if(
			($(this).val().indexOf("-") == 0 || resultsNum > 0)
			&& event.keyCode === 109
		){
			return false;
		}else{
			return $erp.isKeyOnlyNumber(event, "input_money_m");
		}

		
	}).focus(function(e){
		var readonly = e.target.getAttribute("readonly");
		if(readonly){
			return true;
		}		
		var value = $(this).val();
		value = value.replace(/,/g, '');
		$(this).val(value);
	}).blur(function(e){		
		var readonly = e.target.getAttribute("readonly");
		if(readonly){
			return true;
		}		
		
		var value = $(this).val();
		if(value != ""){
			value = value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
			value = $erp.getMoneyFormat(value);
			$(this).val(value);
			if(value == "" && !$erp.isEmpty(invalidText)){
				$erp.initDhtmlXPopupDom(e.target, invalidText);
			}
		}	
	}).attr("init", "Y");
}

/** 
 * Description 
 * @function initDomInputTextBizrNo
 * @function_Description ERP Page Input Text 숫자 및 하이픈 세팅 (input_bizrno 클래스 가진 것만)
 * @param 
 * @author 김종훈
 */
function initDomInputTextBizrNo(invalidText){
	$('.input_bizrno[init!="Y"]').attr("maxlength", "12").keydown(function(e){
		return $erp.isKeyOnlyNumber(event, 'date');
	}).blur(function(e){		
		var value = $(this).val();
		if(value != ""){
			value = value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
			var pattern = /^[0-9]{3}-[0-9]{2}-[0-9]{5}$/; 
			if(!pattern.test(value)) { 
				value = "";
			} else {
				if(!$erp.isBizrNoValidate(value)){
					value = "";
				}
			}
			$(this).val(value);
			if(value == "" && !$erp.isEmpty(invalidText)){
				$erp.initDhtmlXPopupDom(e.target, invalidText);
			}
		}
	}).attr("init", "Y");
}


/** 
 * Description 
 * @function initDomInputTextDate
 * @function_Description ERP Page Input Text 날짜형 세팅 (input_calendar 클래스 가진 것만)
 * @param 
 * @author 김종훈
 */
function initDomInputTextDate(invalidText){
	var fnBlur = function(e){
		var value = $(this).val();
		if(value != ""){
			value = value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
			var maxlength = e.target.getAttribute("maxlength")-0;
			if(maxlength == 7 && value.length >= 6){
				value += "01";
			}
			if(!$erp.isDateValidate(value)){
				value = "";
				if(!$erp.isEmpty(invalidText)){
					$erp.initDhtmlXPopupDom(e.target, invalidText);
				}
			} else {
				value = $erp.getDateFormat(value);
			}
			if(maxlength == 7 && value.length == 10){
				value = value.substring(0, 7);
			}
			$(this).val(value);
		}
	};
	
	var fnFocus = function(e){
		$(this)[0].select();
	}
	
	var fnEach = function(i, obj){
		// 날짜 아이콘 추가
		var objId = $(obj).attr("id");
		if(objId){				
			var imgId = "imgCal" + objId.substring(3);
			var img = $("<img>").attr("id", imgId).attr("src", ERP_CALENDAR_CURRENT_ICON_PATH).addClass("img_erp_calendar_button");
			$(obj).after(img);				
			var dhtmlXCalendar = new dhtmlXCalendarObject({
											input : objId
											, button : imgId
										});
			window["calendar_" + objId] = dhtmlXCalendar;
			var maxlength = $(obj)[0].getAttribute("maxlength")-0;
			dhtmlXCalendar.hideTime();
			dhtmlXCalendar.showToday();
			// 1899년 이전 사용불가, 3000년 이후 사용불가
			dhtmlXCalendar.setSensitiveRange("1900-01-01", "2999-12-31");
			
			//data-position 값 소유시 해당 값만큼 날짜 객체에서 증감
			var dataPosition = obj.getAttribute("data-position");
			
			var date = new Date();
			
			if(dataPosition){
				var editType;
				var editMonth;
				var editDay;
				var matchedValue;
				var isMatched = null;
				var lastDay;
				
				isMatched = dataPosition.match(/\-?[0-9]+\:\(\-?[0-9]+\)/);
				if(isMatched != null){
					editType = "N:(N)";
					matchedValue = isMatched[0];
					matchedValue = matchedValue.replace(/\(|\)/g,"");
					matchedValue = matchedValue.split(":");
					editMonth = matchedValue[0];
					editDay = matchedValue[1];
				}else{
					isMatched = dataPosition.match(/\-?[0-9]+\:\([a-z]+\)/);
					if(isMatched != null){
						editType = "N:(START OR END)";
						matchedValue = isMatched[0];
						matchedValue = matchedValue.replace(/\(|\)/g,"");
						matchedValue = matchedValue.split(":");
						editMonth = matchedValue[0];
						editDay = matchedValue[1];
					}else{
						isMatched = dataPosition.match(/\-?[0-9]+\:\-?[0-9]+/);
						if(isMatched != null){
							editType = "N:N";
							matchedValue = isMatched[0];
							matchedValue = matchedValue.replace(/\(|\)/g,"");
							matchedValue = matchedValue.split(":");
							editMonth = matchedValue[0];
							editDay = matchedValue[1];
						}else{
							isMatched = dataPosition.match(/\(\-?[0-9]+\)/);
							if(isMatched != null){
								editType = "(N)";
								matchedValue = isMatched[0];
								matchedValue = matchedValue.replace(/\(|\)/g,"");
								editDay = matchedValue;
							}else{
								isMatched = dataPosition.match(/\([a-z]+\)/);
								if(isMatched != null){
									editType = "(START OR END)";
									matchedValue = isMatched[0];
									matchedValue = matchedValue.replace(/\(|\)/g,"");
									editDay = matchedValue;
								}else{
									isMatched = dataPosition.match(/\-?[0-9]+/);
									if(isMatched != null){
										editType = "N";
										matchedValue = isMatched[0];
										matchedValue = matchedValue.replace(/\(|\)/g,"");
										editDay = matchedValue;
									}else{
										$erp.alertMessage({
											"alertMessage" : "data-position 속성에 잘못된 형식의 값을 입력하였습니다.",
											"alertType" : "error",
											"isAjax" : false
										});
									}
								}
							}
						}
					}
				}
				
				if(editType){
					if(obj.className && obj.className.indexOf("input_calendar_ym") > - 1){
						if(editType == "N:(N)" || editType == "N:(START OR END)" || editType == "N:N"){
							$erp.alertMessage({
								"alertMessage" : "input_calendar_ym 클래스는<br/>날짜(일) 조정이 불가능합니다.",
								"alertType" : "error",
								"isAjax" : false
							});
						}else{
							editMonth = editDay;
							if(editType == "(N)"){
								if(editMonth < 1){
									$erp.alertMessage({
										"alertMessage" : "고정월을 1보다 작은수를 입력하여 날짜(월)를 수정 할 수 없습니다.",
										"alertType" : "error",
										"isAjax" : false
									});
									editMonth = 1;
								}else if(editMonth > 12){
									$erp.alertMessage({
										"alertMessage" : "고정월을 12보다 큰수를 입력하여 날짜(월)를 수정 할 수 없습니다.",
										"alertType" : "error",
										"isAjax" : false
									});
									editMonth = 12;
								}else{
									date.setMonth(parseInt(editMonth));
								}
							}else if(editType == "(START OR END)"){
								if(editMonth == "start"){
									date.setMonth(1);
								}else if(editMonth == "end"){
									date.setMonth(12);
								}else{
									$erp.alertMessage({
										"alertMessage" : "알수없는 문자를 입력하여 <br/>날짜(월)를 수정 할 수 없습니다.유효:start 또는 end",
										"alertType" : "error",
										"isAjax" : false
									});
								}
							}else if(editType == "N"){
								date.setMonth(date.getMonth() + parseInt(editMonth));
							}
						}
						
					}else if(obj.className && obj.className.indexOf("input_calendar") > - 1){
						
						var getLastDay = function(year, month){
							switch (month){
								case 2:
									lastDay = (!(year % 4) && (year % 100) || !(year % 400)) ? 29 : 28;
									break;
								case 4:
								case 6:
								case 9:
								case 11:
									lastDay = 30;
									break;
								default:
									lastDay = 31;
							}
						}
						
						if(editType == "N:(N)"){
							date.setMonth(date.getMonth() + parseInt(editMonth));
							getLastDay(date.getFullYear(), date.getMonth()+1);
							if(lastDay < editDay){
								editDay = lastDay;
							}
							if(editDay < 1){
								$erp.alertMessage({
									"alertMessage" : "고정일을 1보다 작은수를 입력하여 날짜(일)를 수정 할 수 없습니다.",
									"alertType" : "error",
									"isAjax" : false
								});
							}else{
								date.setDate(editDay);
							}
						}else if(editType == "N:(START OR END)"){
							date.setMonth(date.getMonth() + parseInt(editMonth));
							getLastDay(date.getFullYear(), date.getMonth()+1);
							if(editDay == "start"){
								date.setDate(1);
							}else if(editDay == "end"){
								date.setDate(lastDay);
							}else{
								$erp.alertMessage({
									"alertMessage" : "알수없는 문자를 입력하여 <br/>날짜(일)를 수정 할 수 없습니다.유효:start 또는 end",
									"alertType" : "error",
									"isAjax" : false
								});
							}
						}else if(editType == "N:N"){
							date.setMonth(date.getMonth() + parseInt(editMonth));
							date.setDate(date.getDate() + parseInt(editDay));
						}else if(editType == "(N)"){
							getLastDay(date.getFullYear(), date.getMonth()+1);
							if(lastDay < editDay){
								editDay = lastDay;
							}
							if(editDay < 1){
								$erp.alertMessage({
									"alertMessage" : "고정일을 1보다 작은수를 입력하여 날짜(일)를 수정 할 수 없습니다.",
									"alertType" : "error",
									"isAjax" : false
								});
							}else{
								date.setDate(editDay);
							}
						}else if(editType == "(START OR END)"){
							getLastDay(date.getFullYear(), date.getMonth()+1);
							if(editDay == "start"){
								date.setDate(1);
							}else if(editDay == "end"){
								date.setDate(lastDay);
							}else{
								$erp.alertMessage({
									"alertMessage" : "알수없는 문자를 입력하여 <br/>날짜(일)를 수정 할 수 없습니다.유효:start 또는 end",
									"alertType" : "error",
									"isAjax" : false
								});
							}
						}else if(editType == "N"){
							date.setDate(date.getDate() + parseInt(editDay));
						}
					}
				}
			}
			
			var year = date.getFullYear();
			var month = date.getMonth()+1;
			if(month.toString().length == 1){
				month = "0"+month;
			}
			var day = date.getDate();
			if(day.toString().length == 1){
				day = "0"+day;
			}
			
			//default_date 클래스 소유시 날짜 객체를 이용한 기본값 세팅
			var isDefaultDate = (obj.className && obj.className.indexOf("default_date") > - 1);
			if(maxlength == 7){
				dhtmlXCalendar.setDateFormat("%Y-%m");
				dhtmlXCalendar.setMonthPickerMode();
				if(isDefaultDate){
					obj.value = year + "-" + month;
				}
			} else {
				dhtmlXCalendar.setDateFormat("%Y-%m-%d");
				if(isDefaultDate){
					obj.value = year + "-" + month + "-" + day;
				}
			}
			obj.dhtmlXCalendar = dhtmlXCalendar;
			obj.dhtmlXCalendarImage = img[0];			
		}

	};
	
	$('.input_calendar[init!="Y"]').attr("maxlength", "10").keydown(function(e){
		return $erp.isKeyOnlyNumber(event, 'date');
	}).focus(fnFocus).blur(fnBlur).each(fnEach).attr("init", "Y");
	
	$('.input_calendar_ym[init!="Y"]').attr("maxlength", "7").keydown(function(e){
		return $erp.isKeyOnlyNumber(event, 'date');
	}).focus(fnFocus).blur(fnBlur).each(fnEach).attr("init", "Y");
}

/** 
 * Description 
 * @function initConsultStatistics
 * @function_Description 상담통계 초기화
 * @param 
 * @author 김종훈
 */
function initConsultStatistics(){
	$erp.getTodayConsultStatistics();
}

/** 
 * Description 
 * @function attachOnConsultTabClose
 * @function_Description 고객상담 Tab이 Close 될 때 CTI 서버 로그아웃
 * @author 유가영
 */
function attachOnConsultTabClose(){
	contentsTabBar.attachEvent("onTabClose", function(id){
		var attachedObject = this.tabs(id).getAttachedObject();
		try {
			if(attachedObject.tagName && attachedObject.tagName.toLowerCase() == "iframe"){
				var iframeContent = attachedObject.contentWindow;
				if(id="00299"){
					iframeContent.ippbxLogout();
				}
			}
			attachedObject = undefined;
		} catch (e){}
	    return true;
	});
	
	//탭 클릭 시 좌측 트리 선택되도록 함
	contentsTabBar.attachEvent("onTabClick", function(id, lastId){
		erpMenuTree.selectItem(""+id);
	});
}

/** 
 * Description 
 * @function closeWindowEvent
 * @function_Description window 창 닫기 전 CTI 서버 로그아웃
 * @author 유가영
 */
function closeWindowEvent(){
	if(contentsTabBar.tabs("00299") != null){
		if(contentsTabBar.tabs("00299").isActive()){
			var attachedObject = contentsTabBar.tabs("00299").getAttachedObject();
			try {
				if(attachedObject.tagName && attachedObject.tagName.toLowerCase() == "iframe"){
					var iframeContent = attachedObject.contentWindow;
					if(id="00299"){
						iframeContent.ippbxLogout();
					}
				}
				attachedObject = undefined;
			} catch (e){}
		}
	}
}

/** 
 * Description 
 * @function ctiConnection
 * @function_Description 고객상담 화면의 ARS 함수 사용
 * @author 유가영
 */
function ctiArsConnection(mode,kind){
	if(contentsTabBar.tabs("00299") != null){
		if(!contentsTabBar.tabs("00299").isActive()){
			var attachedObject = contentsTabBar.tabs("00299").getAttachedObject();
			try {
				if(attachedObject.tagName && attachedObject.tagName.toLowerCase() == "iframe"){
					var iframeContent = attachedObject.contentWindow;
					if(id="00299"){
						if(mode == 1){
							iframeContent.sipcommand_card('Y',kind);
						}else if(mode == 2){
							iframeContent.sipcommand_card('N',kind);
						}else if(mode == 3){
							iframeContent.sipcommand_cvc('Y',kind);
						}else if(mode == 4){
							iframeContent.sipcommand_cvc('N',kind);
						}
					}
				}
			} catch (e){
			}
		}else{
		}
	}else{
	}
}

/** 
 * Description 
 * @function ctiConnection
 * @function_Description 고객주문 결제팝업에 ARS값 전달
 * @author 유가영
 */
function ctiArsReturnConnection(mode,value,tempKind){
	if(tempKind == "OK003"){
		var attachedObject = contentsTabBar.tabs("00301").getAttachedObject();
		try {
			if(attachedObject.tagName && attachedObject.tagName.toLowerCase() == "iframe"){
				var iframeContent = attachedObject.contentWindow;
				if(id="00301"){
					iframeContent.sendPopupValue(mode,value);
				}
			}
		} catch (e){
		}
	}else{
		var attachedObject = contentsTabBar.tabs("00512").getAttachedObject();
		try {
			if(attachedObject.tagName && attachedObject.tagName.toLowerCase() == "iframe"){
				var iframeContent = attachedObject.contentWindow;
				if(id="00512"){
					iframeContent.sendPopupValue(mode,value);
				}
			}
		} catch (e){
		}
	}
}

/** 
 * Description 
 * @function closeTabBar
 * @function_Description 열려있는 탭들 중 원하는 탭 닫기
 * @author 유가영
 */
function closeTabBar(tabId){
	contentsTabBar.tabs(tabId).close();
}

/** 
 * Description 
 * @function_Description 메뉴 목록 및 고객 상담 단축키로 열고 닫기 (메뉴목록 : esc+1 or 고객상담 : esc+2)
 * @author 조승현
 */
$(document).ready(function(){
	//erpLayout = null;
	var firstKeyDown = false;
	var firstKey = 27, key1 = 49, key2 = 50; // esc:27, 49:1번키, 50:2번키
	var sub_window = $('iframe').prevObject["0"];
	var toggle1 = "1"; //1번키용 토글변수
	var toggle2 = "1"; //2번키용 토글변수
//	console.log(indexWindow);
//	console.log(sub_window);
	if(indexWindow != undefined && indexWindow != null){ //메뉴목록 window 입력 이벤트 컨트롤
		$(indexWindow).keydown(function(e) {
			//console.log(e.keyCode);
			if (e.keyCode == firstKey) {
				firstKeyDown = true;
			}
			if (firstKeyDown){
				if(e.keyCode == key1){
					if(toggle1 == "1"){
						indexLayout.cells("a").collapse();
						toggle1 = "0";
					}else if(toggle1 == "0"){
						indexLayout.cells("a").expand();
						toggle1 = "1";
					}
					return false;
				}else if(e.keyCode == key2){
					if(erpLayout != undefined && erpLayout != null){
						if(toggle2 == "1"){
							erpLayout.cells("a").collapse();
							toggle2 = "0";
						}else if(toggle2 == "0"){
							erpLayout.cells("a").expand();
							toggle2 = "1";
						}
					}
					return false;
				}
			}
			
		}).keyup(function(e){
			if (e.keyCode == firstKey){
				firstKeyDown = false; 
			}
		});
	}
	
	if(sub_window != undefined && sub_window != null){ //iframe window 입력 이벤트 컨트롤
		$(sub_window).keydown(function(e) {
			//console.log(e.keyCode);
			if (e.keyCode == firstKey) {
				firstKeyDown = true;
				if(indexWindow != null && indexWindow != undefined){
					indexWindow.onerror = function(){return true;}
				}
			}
			if (firstKeyDown){
				if(e.keyCode == key1){
					if(toggle1 == "1"){
						indexLayout.cells("a").collapse();
						toggle1 = "0";
					}else if(toggle1 == "0"){
						indexLayout.cells("a").expand();
						toggle1 = "1";
					}
					return false;
				}else if(e.keyCode == key2){
					if(erpLayout != undefined && erpLayout != null){ //이부분에서 참조 에러가 발생 한다 하지만 정상 실행된다.
																	 //참조 에러가 나는데 정상 실행되는 이유는
																	 //이벤트 콜백 자체가 클로저를 이용하다보니  undefined 상태로 인식하지만
																	 //iframe 페이지가 정상 로딩된 후이므로 참조 할 수 있는 상황으로 변했기 때문에
																	 //로그에는 참조에러로 찍히지만 실행은 정상적으로 된다.
																	 //이 에러가 발생하는 타이밍은 메뉴목록 쪽에 포커싱이 잡혀있을때만 발생한다.
																	 //이유는 iframe 쪽으로 포커싱이 넘겨져와 있을때는
																	 //새텝으로 열리는 페이지에서 document.ready가
																	 //다시 실행된 상태기 때문에  클로저가 정상적으로 전역변수를 인식하여
																	 //콘솔에 에러가 찍히지 않는다.
						if(toggle2 == "1"){
							erpLayout.cells("a").collapse();
							toggle2 = "0";
						}else if(toggle2 == "0"){
							erpLayout.cells("a").expand();
							toggle2 = "1";
						}
					}
					return false;
				}
			}
			
		}).keyup(function(e){
			if (e.keyCode == firstKey){
				firstKeyDown = false;
				if(indexWindow != null && indexWindow != undefined){
					indexWindow.onerror = function(){return false;}
				}
			}
		});
	}
})

/** 
 * Description 
 * @function initErpGoodsMenuToolbar
 * @function_Description ERP DhtmlXToolbar 초기화
 * @param parentObjId (String)	/ DhtmlXToolbar Object를 구성할 Parent Dom Object ID
 * @param expandsText (String)	/ 펼침 Text
 * @param collapseText (String)	/ 접기 Text
 * @author 최지민
 */
function initErpGoodsMenuToolbar(parentDomObjId, expandsText, collapseText){
	erpMenuToolbar = new dhtmlXToolbarObject({
		parent : parentDomObjId
		, image_path : ERP_TOOLBAR_CURRENT_IMAGE_PATH
		, icons_path : ERP_TOOLBAR_CURRENT_ICON_PATH
		, items:[
			{id: "expands", type: "button", text: expandsText, img: "menu/plus.gif"}
			, {id: "collapse", type: "button", text: collapseText, img: "menu/minus.gif"}
		]
	});
	
	erpMenuToolbar.attachEvent("onClick", function(id){
		if(id == "expands"){
			erpTree.openAllItems("0");
		} else if(id == "collapse"){
			erpTree.closeAllItems("0");
		}
	});
}
