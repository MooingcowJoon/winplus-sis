/** 
 * Description 
 * @Resource ERP Popup Script
 * @since 2017.03.09
 * @author 김종훈
 *
 *********************************************
 * 코드 수정 히스토리
 * 날짜 / 작업자 / 상세
 * 2017.03.09 / 김종훈 / 신규 생성
 *********************************************
 */

/* erp_common.js 에서 먼저 $erp 객체를 선언 해야 함 */
/** 
 * Description 
 * @function = openPopup
 * @function_Description 팝업 열기 공통
 * @param url (String) / Popup Url
 * @param params (object) / Parameter Object
 * @param onContentLoaded (function) / 팝업 열린 후 동작될 Function
 * @param option (object) / 팝업 윈도우 기본 정보 설정
 * @author 김종훈
 */
$erp.openPopup = function(url, params, onContentLoaded, option){
	var tryCount = 0;
	var parentWindow = parent;
	while((erpPopupWindows == undefined || erpPopupWindows == null) && parentWindow && tryCount < 10){
		erpPopupWindows = parentWindow.erpPopupWindows;
		if(erpPopupWindows == undefined || erpPopupWindows == null){
			parentWindow = parentWindow.parent;
		}
	}
	
	if($erp.isEmpty(params)){
		params = {};
	} 
	
	try {
		params.currentMenu_cd = currentMenu_cd;
	} catch (e){}
	
	var win_id;
	
	if(option && option.win_id){
		win_id = option.win_id;
	}
	if(win_id == undefined || win_id == null || win_id == ""){
		win_id = ERP_WINDOWS_DEFAULT_ID;
	}
	
	if(erpPopupWindows){			
		if(erpPopupWindows.window(win_id)){
			return;
		}
		
		var popWinWidth = 1024;
		var popWinHeight = 640;
		var popWinResize = true;
		
		if(option != undefined && option != null && typeof option === 'object'){
			if(option.width != undefined && option.width != null && !isNaN(option.width)){
				/* -0 숫자형 변환 */
				popWinWidth = option.width-0;
			}
			if(option.height != undefined && option.height != null && !isNaN(option.height)){
				/* -0 숫자형 변환 */
				popWinHeight = option.height-0;
			}
			if(option.resize != undefined && option.resize != null && !(option.resize)){
				/* -0 숫자형 변환 */
				popWinResize = option.resize;
			}
		}
		
		var erpPopupWindowsCell = erpPopupWindows.createWindow({
		    id : win_id
		    , left : 0
		    , top : 0
		    , width : popWinWidth
		    , height : popWinHeight
		    , center : true
		    , modal : true
		    , park : false
		    , resize : popWinResize
		    , stick : false
		    , minmax : false
		    , help : false
		    , move : true
		});
		erpPopupWindowsCell.button("minmax").hide();
		erpPopupWindowsCell.button("park").hide();
		erpPopupWindowsCell.keepInViewport(true);
		erpPopupWindowsCell.progressOn();
		
		if(url != undefined && url != null && url.length > 0){
			//console.log(params);
			erpPopupWindowsCell.attachURL(
					url
					, false
					, params
			);						
			if(onContentLoaded && typeof onContentLoaded === 'function' ){
				erpPopupWindowsCell.attachEvent("onContentLoaded", onContentLoaded);
			}
		}
		
		erpPopupWindowsCell["parentWindow"] = window;
		
		return erpPopupWindowsCell;
	}
}

/** 
 * Description 
 * @function openSearchDeptPopup
 * @function_Description 자재 조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 박성호
 */

$erp.openSearchMtrlPopup = function(mtrlNm, onRowDblClicked, rpstMtrlYn, recipe){
	var url = "/common/popup/searchMtrlPopup.sis";
	if(mtrlNm == undefined || mtrlNm == null){
		mtrlNm = "";
	}
	if(rpstMtrlYn == undefined || rpstMtrlYn == null){
		rpstMtrlYn = "";
	}
	if(recipe == undefined || recipe == null){
		recipe = "";
	}
	var params = {
			"MTRL_NM" : mtrlNm
			, "RPST_MTRL_YN" : rpstMtrlYn
			, "RECIPE" : recipe
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 300
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}


/** 
 * Description 
 * @function openSearchDeptPopup
 * @function_Description 자재(Price) 조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author bumseok.oh
 */

$erp.openSearchMtrlPricePopup = function(mtrlNm, rpstMtrlYn, onRowDblClicked){
	var url = "/common/popup/searchMtrlPricePopup.sis";
	if(mtrlNm == undefined || mtrlNm == null){
		mtrlNm = "";
	}
	var params = {
			"MTRL_NM" : mtrlNm
			, "RPST_MTRL_YN" : rpstMtrlYn
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 573
			, height : 500
	};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchFacPopup
 * @function_Description 공장/파트너사 코드 조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 김동현
 */

$erp.openSearchFacPopup = function(facNm, onRowDblClicked, dlvBsnDivCd){
	
	var url = "/common/popup/searchFacPopup.sis";
	if(dlvBsnDivCd == undefined || dlvBsnDivCd == null){
		dlvBsnDivCd = "";
	}
	if(facNm == undefined || facNm == null){
		facNm = "";
	}
	
	// Validate
	var isValidated = true;		
	var alertMessage = "";
	var alertCode = "";
	var alertType = "error";

	var params = {
			"DLV_BSN_DIV_CD" : dlvBsnDivCd,
			"FAC_NM" : facNm
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 300
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

$erp.openStndCtgrPopup = function(searchType, srhStndCtgrNm, stndCtgrCd, srhDtlCtgrNm, onRowDblClicked){
	var stndCtgrDiv = "SCD001";
	var option
	var url
	var params
	
	if(searchType=='STAND'){
		url = "/common/popup/searchStndCtgrPopup.sis";
		params = {
			"STND_CTGR_DIV" : stndCtgrDiv
			,"STND_CTGR_NM" : srhStndCtgrNm
		}
		option = {
				width : 300
				, height : 500
			};
	} else if(searchType=='DETAIL'){
		url = "/common/popup/searchDtlCtgrPopup.sis";
		params = {
			"DTL_CTGR_NM" : srhDtlCtgrNm
			,"STND_CTGR_CD" : stndCtgrCd
		}
		option = {
				width : 470
				, height : 500
			};
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	
	$erp.openPopup(url, params, onContentLoaded, option);
}
/** 
 * Description 
 * @function openMtrlDetailPopup
 * @function_Description 자재 상세정보 팝업 열기
 * @param mtrlCd
 * @author 박성호
 */

$erp.openMtrlDetailPopup = function(mtrlCd){
	var url = "/common/popup/searchMtrlDetailPopup.sis";
	
	var params = {
			"MTRL_CD" : mtrlCd
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
		this.progressOff();
	}
	
	var option = {
			width : 800
			, height : 450
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openInputPriceDetailPopup
 * @function_Description 자재 입력단가 상세조회 팝업 열기
 * @param mtrlCd
 * @author 박성호
 */

$erp.openInputPriceDetailPopup = function(mtrlCd){
	var url = "/common/popup/searchInputPricePopup.sis";
	
	var params = {
			"MTRL_CD" : mtrlCd
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
		this.progressOff();
	}
	
	var option = {
			width : 1050
			, height : 290
		};

	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCstmInfoPopup
 * @function_Description 납품업체 입고단가 정보조회 팝업 열기
 * @param mtrlCd
 * @author 박성호
 */

$erp.openCstmInfoPopup = function(mtrlCd, dlvBsnCd){
	var url = "/common/popup/searchCstmInfoPopup.sis";
	
	var params = {
			"MTRL_CD" : mtrlCd
			, "CSTM_CD" : dlvBsnCd
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
		this.progressOff();
	}
	
	var option = {
			width : 880
			, height : 300
		};

	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchCstmPopup
 * @function_Description 자재별 납품업체코드조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 박성호
 */
$erp.openSearchCstmPopup = function(cstmNm, onRowDblClicked){
	var url = "/common/popup/searchCstmPopup.sis";

	var params = {
			"CSTM_NM" : cstmNm
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 300
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchDlvBsnPopup
 * @function_Description 납품업체코드조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 박성호
 */
$erp.openSearchDlvBsnPopup = function(shrNm, onRowDblClicked, mtrlYn, orgnDivCd){
	var url = "/common/popup/searchDlvBsnPopup.sis";
	var params;
	if(shrNm == undefined || shrNm == null){
		shrNm = "";
	}
	if(mtrlYn == undefined || mtrlYn == null){
		mtrlYn = "N";
	}
	if(orgnDivCd == undefined || orgnDivCd == null){
		orgnDivCd = "";
	}
	
	params = {
			"DLV_BSN_NM" : shrNm
			, "MTRL_CD" : shrNm
			, "MTRL_YN" : mtrlYn
			, "ORGN_DIV_CD" : orgnDivCd
			}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 300
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchDlvPriceBsnPopup
 * @function_Description 납품업체코드조회+납품자재단가 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author bumseok.oh
 */
$erp.openSearchDlvPriceBsnPopup = function(shrNm, onRowDblClicked, mtrlYn){
	var url = "/common/popup/searchDlvBsnPricePopup.sis";
	var params;
	if(shrNm == undefined || shrNm == null){
		shrNm = "";
	}
	if(mtrlYn == undefined || mtrlYn == null){
		mtrlYn = "N";
	}
	params = {
			"DLV_BSN_NM" : shrNm
			, "MTRL_CD" : shrNm
			, "MTRL_YN" : mtrlYn
			}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 500
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchCstmByMtrlPopup
 * @function_Description 자재별납품업체코드조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 박성호
 */
$erp.openSearchCstmByMtrlPopup = function(mtrlNm, onRowDblClicked){
	var url = "/common/popup/searchCstmByMtrlPopup.sis";
	if(mtrlNm == undefined || mtrlNm == null){
		mtrlNm = "";
	}
	var params = {
			"MTRL_NM" : mtrlNm
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 300
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openMtrlAvgModPopup
 * @function_Description 자재별납품업체코드조회 팝업 열기
 * @param mtrlCd
 * @param onRowDblClicked (function) / Function
 * @author 박성호
 */

$erp.openMtrlAvgModPopup = function(mtrlCd, stanYear, month, orgnCd){
	var stndMon = stanYear+month;
	var url = "/common/popup/searchMtrlAvgModPopup.sis";
	
	var params = {
			"MTRL_CD" : mtrlCd
			, "STND_MON" : stndMon
			, "ORGN_CD" : orgnCd
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;

		this.progressOff();
	}
	
	var option = {
			width : 862
			, height : 300
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchPrdcPopup
 * @function_Description 상/제품조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 박성호
 */

$erp.openSearchPrdcPopup = function(ARTICLE_NAME, onRowDblClicked/*, prdcTime*/){
	var url = "/common/popup/searchPrdcPopup.sis";
	
	if(ARTICLE_NAME == undefined || ARTICLE_NAME == null){
		ARTICLE_NAME = "";
	}
	/*if(prdcTime == undefined || prdcTime == null){
		prdcTime = "N";
	}*/

	var params = {
			"ARTICLE_NAME" : ARTICLE_NAME/*
			, "PRDC_TIME" : prdcTime*/
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 405
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchPrdcTimePopup
 * @function_Description [상/제품관리]-[제품별표준생산시간관리]-제품조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 유가영
 */
/*
$erp.openSearchPrdcTimePopup = function(prdcNm, onRowDblClicked){
	var url = "/common/popup/searchPrdcTimePopup.sis";

	if(prdcNm == undefined || prdcNm == null){
		prdcNm = "";
	}

	var params = {
			"PRDC_NM" : prdcNm
			, "PRDC_TIME" : "PD0001"
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 405
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}*/

/** 
 * Description 
 * @function openSearchPrdcSessionPopup
 * @function_Description 상/제품조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 정인선
 */

$erp.openSearchPrdcSessionPopup = function(ARTICLE_NAME, onRowDblClicked/*, prdcTime*/){
	var url = "/common/popup/searchPrdcSessionPopup.sis";
	
	if(ARTICLE_NAME == undefined || ARTICLE_NAME == null){
		ARTICLE_NAME = "";
	}
	/*if(prdcTime == undefined || prdcTime == null){
		prdcTime = "N";
	}*/

	var params = {
			"ARTICLE_NAME" : ARTICLE_NAME
			/*, "PRDC_TIME" : prdcTime*/
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 405
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function searchPrdcProcessPopup
 * @function_Description 상/제품조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 주병훈
 */

$erp.openSearchPrdcProcessPopup = function(ARTICLE_NAME, onRowDblClicked){
	var url = "/common/popup/searchPrdcProcessPopup.sis";
	
	if(ARTICLE_NAME == undefined || ARTICLE_NAME == null){
		ARTICLE_NAME = "";
	}

	var params = {
			"ARTICLE_NAME" : ARTICLE_NAME
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 455
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchRecipePopup
 * @function_Description 레시피 조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 박성호
 */

$erp.openSearchRecipePopup = function(recipeNm, onRowDblClicked, noAcc){
	var url = "/common/popup/searchRecipePopup.sis";
	
	if(recipeNm == undefined || recipeNm == null){
		recipeNm = "";
	}
	if(noAcc == undefined || noAcc == null){
		noAcc = "";
	}

	var params = {
			"RECIPE_NM" : recipeNm
			,"NO_ACC" : noAcc
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 300
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}
/** 
 * Description 
 * @function openSearchDeptPopup
 * @function_Description 카테고리 조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 주병훈
 */

$erp.openSearchStndCtgrPopup = function(stndCtgrNm, onRowDblClicked){
	var url = "/common/popup/searchCtgrPopup.sis";
	if(stndCtgrNm == undefined || stndCtgrNm == null){
		stndCtgrNm = "";
	}
	var params = {
			"STND_CTGR_NM" : stndCtgrNm
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 300
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchOrgnPopup
 * @function_Description 조직 조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 주병훈
 */

$erp.openSearchOrgnPopup = function(orgnNm, onRowDblClicked, orgnDivCd){
	var url = "/common/popup/searchOrgnPopup.sis";
	if(orgnNm == undefined || orgnNm == null){
		orgnNm = "";
	}
	if(orgnDivCd == undefined || orgnDivCd == null){
		orgnDivCd = "";
	}
	var params = {
			"ORGN_NM" : orgnNm
			, "ORGN_DIV_CD" : orgnDivCd
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 600
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchDeptPopup
 * @function_Description 사용자 조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 주병훈
 */

$erp.openSearchEmpPopup = function(empNm, onRowDblClicked){
	var url = "/common/popup/searchEmpPopup.sis";
	if(empNm == undefined || empNm == null){
		empNm = "";
	}

	var params = {
			"EMP_NM" : empNm
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 500
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchDeptPopup
 * @function_Description 사용자 조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 주병훈
 */

$erp.openSearchEmpLoginAddListPopup = function(onRowDblClicked){
	var url = "/common/popup/searchEmpLoginAddListPopup.sis";

	var params = {}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	
	var option = {
			width : 480
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}


/** 
 * Description 
 * @function openTextUploadPopup
 * @function_Description 전문 업로드 팝업 열기
 * @author 신기환
 */
$erp.openTextUploadPopup = function(onUploadFile, onUploadComplete, onFileAdd,onBeforeClear){
	var url = "/common/popup/textUploadPopup.sis";

	var params = {}
	var onContentLoaded = function(){		
		var popWin = this.getAttachedObject().contentWindow;
		if(onUploadFile && typeof onUploadFile === 'function'){
			while(popWin.erpPopupVaultFnOnUploadFile == undefined){
				popWin.erpPopupVaultFnOnUploadFile = onUploadFile;
			}			
		}		
		if(onUploadComplete && typeof onUploadComplete === 'function'){
			while(popWin.erpPopupVaultFnOnUploadComplete == undefined){
				popWin.erpPopupVaultFnOnUploadComplete = onUploadComplete;		
			}
		}		
		if(onFileAdd && typeof onFileAdd === 'function'){
			while(popWin.erpPopupVaultFnOnFileAdd == undefined){
				popWin.erpPopupVaultFnOnFileAdd = onFileAdd;			
			}
		}	
		if(onBeforeClear && typeof onBeforeClear === 'function'){
			while(popWin.erpPopupVaultFnOnBeforeClear == undefined){
				popWin.erpPopupVaultFnOnBeforeClear = onBeforeClear;		
			}
		}	
		this.progressOff();
	}	
	var option = {
			width : 515
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}


/** 
 * Description 
 * @function openSearchPostAddrPopup
 * @function_Description 우편번호, 주소 검색 팝업 열기
 * @param onComplete (function) / Function
 * @author 김종훈
 */
$erp.openSearchPostAddrPopup = function(onComplete){
	var url = "/common/popup/searchPostAddrPopup.sis";

	var params = {}
	var onContentLoaded = function(){		
		var popWin = this.getAttachedObject().contentWindow;
		if(onComplete && typeof onComplete === 'function'){
			while(popWin.erpPopupOnComplete == undefined){
				popWin.erpPopupOnComplete = onComplete;			
			}
		}
		this.progressOff();
	}
	var option = {
			width : 515
			, height : 500
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchPostAddrPopup
 * @function_Description 우편번호, 주소 검색 팝업 열기
 * @param onComplete (function) / Function
 * @author 김종훈
 */
$erp.openSearchPostAddrPopup2 = function(onComplete, windowOption){
    var url = "/common/popup/searchPostAddrPopup.sis";

    var params = {}
    var onContentLoaded = function(){       
        var popWin = this.getAttachedObject().contentWindow;
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;         
            }
        }
        this.progressOff();
    }
    var option = {
            width : 515
            , height : 500
        };
    if(windowOption && typeof windowOption === 'object'){
        for(var i in windowOption){
            option[i] = windowOption[i];
        }
    }
    $erp.openPopup(url, params, onContentLoaded, option);
}


///** 
// * Description 
// * @function xlsUploadPopup
// * @function_Description 엑셀 업로드 팝업 열기
// * @author 신기환
// */
//$erp.xlsUploadPopup = function(params){
//    var onUploadFile;
//    var onUploadComplete;
//    var onBeforeClear;
//    var dhtmlXGridObject;
//    var uploadUrl;
//    var gubn;
//    if(params){
//        onUploadFile = params.onUploadFile;
//        onUploadComplete = params.onUploadComplete;
//        onBeforeClear = params.onBeforeClear;
//        dhtmlXGridObject = params.dhtmlXGridObject;
//        uploadUrl = params.uploadUrl;
//        gubn = params.gubn;
//    } else {
//        return false;
//    }
// 
//    var url = "/common/popup/xlsUploadPopup.sis";
//    var dhtmlXGridColumnsMapArray = dhtmlXGridObject.columnsMapArray;
//    //console.log("dhtmlXGridColumnsMapArray!!");
//    //console.log(dhtmlXGridColumnsMapArray);
//    var params = $erp.serializeDhtmlXGridHeader(dhtmlXGridColumnsMapArray,gubn);
//    //console.log("serializeDhtmlXGridHeader!!");
//    //console.log(params);
//    var onBeforeFileAdd = function(file){
//        //$erp.closePopup();
//        if(file.name.toLowerCase().indexOf("xls")<=-1){
//            var erpPopupWindowsCell = erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
//            var popWin = erpPopupWindowsCell.getAttachedObject().contentWindow;
//            popWin.alertMessage({
//                      "alertMessage" : "error.common.wrongExcelUploadFileType"
//                    , "alertCode" : null
//                    , "alertType" : "error"
//                });
//            this.clear();
//            return false;
//        }
//        if (file.size / (1024 * 1024) > 300) {
//            var erpPopupWindowsCell = erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
//            var popWin = erpPopupWindowsCell.getAttachedObject().contentWindow;
//            popWin.alertMessage({
//                      "alertMessage" : "error.common.wrongFileSize"
//                    , "alertCode" : null
//                    , "alertType" : "error"
//                });
//            this.clear();
//            return false;
//        }
//        return true;
//    }
//    var onContentLoaded = function(){        
//        var popWin = this.getAttachedObject().contentWindow;
//        if(onUploadFile && typeof onUploadFile === 'function'){
//            while(popWin.erpPopupVaultFnOnUploadFile == undefined){
//                popWin.erpPopupVaultFnOnUploadFile = onUploadFile;
//            }            
//        }        
//        if(onUploadComplete && typeof onUploadComplete === 'function'){
//            while(popWin.erpPopupVaultFnOnUploadComplete == undefined){
//                popWin.erpPopupVaultFnOnUploadComplete = onUploadComplete;
//            }
//        }        
//        if(onBeforeFileAdd && typeof onBeforeFileAdd === 'function'){
//            while(popWin.erpPopupVaultFnOnFileAdd == undefined){
//                popWin.erpPopupVaultFnOnFileAdd = onBeforeFileAdd;            
//            }
//        }    
//        if(onBeforeClear && typeof onBeforeClear === 'function'){
//            while(popWin.erpPopupVaultFnOnBeforeClear == undefined){
//                popWin.erpPopupVaultFnOnBeforeClear = onBeforeClear;
//            }
//        }    
//        if(dhtmlXGridColumnsMapArray && typeof dhtmlXGridColumnsMapArray === 'object'){
//            while(popWin.dhtmlXGridColumnsMapArray == undefined){
//                popWin.dhtmlXGridColumnsMapArray=dhtmlXGridColumnsMapArray;
//            }
//        }
//        if(uploadUrl){
//            while(popWin.erpPopupVaultUploadUrl == undefined){
//                popWin.erpPopupVaultUploadUrl=uploadUrl;
//            }
//        }
//        if(gubn){
//            while(popWin.erpPopupVaultgubn == undefined){
//                popWin.erpPopupVaultgubn=gubn;
//            }
//        }
//        this.progressOff();
//        popWin.onLoad();
//    }    
//    var option = {
//            width  : 515
//            , height : 500
//        };
//    $erp.openPopup(url, params, onContentLoaded, option);
//}


/** 
 * Description 
 * @function openBoardPopup
 * @function_Description 게시글 상세뷰 팝업 열기
 * @param paramMap : BOARD_NO(게시물 번호), BOARD_KIND_CD(게시물 구분)
 * @param onRowDblClicked (function) / Function
 * @author 조승현
 */
$erp.openBoardPopup = function(paramMap, onBoardSaved, onBeforeClear, onUploadComplete){
	var url = "/common/board/openBoardPopup.sis";
	
	var params = {};
	
	if(paramMap && typeof paramMap == "object"){
		paramMap.DIRECTORY_KEY = "board";
		params = paramMap;
	}
	
	var option = {
		"win_id" : "openBoardPopup",
		"width"  : 1024,
		"height" : 677
	}

	var parentWindow = window;
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onBoardSaved && typeof onBoardSaved === 'function'){
			while(popWin.onBoardSaved == undefined){
				popWin.onBoardSaved = onBoardSaved;
			}
		}
		if(onBeforeClear && typeof onBeforeClear === 'function'){
			while(popWin.erpPopupVaultFnOnBeforeClear == undefined){
				popWin.erpPopupVaultFnOnBeforeClear = onBeforeClear;
			}
		}
		if(onUploadComplete && typeof onUploadComplete === 'function'){
			while(popWin.erpPopupVaultFnOnUploadComplete == undefined){
				popWin.erpPopupVaultFnOnUploadComplete = onUploadComplete;
			}
		}
		
		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function closePopup
 * @function_Description 팝업 닫기
 * @author 김종훈
 */
$erp.closePopup = function(){
	if(erpPopupWindows == undefined || erpPopupWindows == null){
		erpPopupWindows = parent.erpPopupWindows;
	}
	if(erpPopupWindows){						
		var erpPopupWindowsCell = erpPopupWindows.window(ERP_WINDOWS_DEFAULT_ID);
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}
	}
}

/** 
 * Description 
 * @function closePopup2
 * @function_Description 팝업 닫기
 * @author 김종훈
 */
$erp.closePopup2 = function(ID){
		var erpPopupWindowsCell = erpPopupWindows.window(ID);
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
	}
}

/** 
 * Description 
 * @function openIndividualSettingPopup
 * @function_Description 개인설정 팝업
 * @author 김종훈
 */
$erp.openIndividualSettingPopup = function(){
	var url = "/common/popup/individualSettingPopup.sis";
	var params = {};
	
	var option = {
		"width" : 470,
		"height" : 355
	}

	var onContentLoaded = function(){
		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCustListPopup
 * @function_Description 고객명부 팝업 열기
 * @param custId (str) / 고객코드 
 * @param onRowDblClicked (function) / Function
 * @author 이병주
 */
$erp.openCustListPopup = function(custCode,parentWindow,onRowDblClicked,onBeforeClear,onUploadComplete){
	var url = "/common/popup/openCustListPopup.sis"
	if(custCode == undefined || custCode == null){
		custCode = "";
	}
	var params = {
		"CUST_CODE" : custCode
	}
	var option = {
			"win_id" : "openCustListPopup",
			"width" : 1024,
			"height" :650
	}

	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}
		}
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onBeforeClear && typeof onBeforeClear === 'function'){
			while(popWin.erpPopupVaultFnOnBeforeClear == undefined){
				popWin.erpPopupVaultFnOnBeforeClear = onBeforeClear;
			}
		}
		if(onUploadComplete && typeof onUploadComplete === 'function'){
			while(popWin.erpPopupVaultFnOnUploadComplete == undefined){
				popWin.erpPopupVaultFnOnUploadComplete = onUploadComplete;
			}
		}
		
		this.progressOff();
	}
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openHappyCallDistributionPopup
 * @function_Description 해피콜 팝업 열기
 * @param custId (str) / 고객코드 
 * @param onRowDblClicked (function) / Function
 * @author 이병주
 */
$erp.openHappyCallDistributionPopup = function(custId,parentWindow,onRowDblClicked,onBeforeClear,onUploadComplete){
	var url = "/sis/businessmanagement/business/happyCallDistribution.sis"
	if(custId == undefined || custId == null){
		custId = "";
	}
	var params = {
		"CUST_ID" : custId
	}
	var option = {
			"win_id" : "openHappyCallDistributionPopup",
			"width" : 500,
			"height" :570
	}

	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}
		}
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onBeforeClear && typeof onBeforeClear === 'function'){
			while(popWin.erpPopupVaultFnOnBeforeClear == undefined){
				popWin.erpPopupVaultFnOnBeforeClear = onBeforeClear;
			}
		}
		if(onUploadComplete && typeof onUploadComplete === 'function'){
			while(popWin.erpPopupVaultFnOnUploadComplete == undefined){
				popWin.erpPopupVaultFnOnUploadComplete = onUploadComplete;
			}
		}
		
		this.progressOff();
	}
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCallBackDistributionPopup
 * @function_Description 콜백분배 팝업 열기
 * @param  
 * @param onRowDblClicked (function) / Function
 * @author 이병주
 */
$erp.openCallBackDistributionPopup = function(param,parentWindow,onRowDblClicked,onBeforeClear,onUploadComplete){
	var url = "/sis/businessmanagement/business/callBackDistribution.sis"
	var params = {};
	var option = {
			"win_id" : "openCallBackDistributionPopup",
			"width" : 500,
			"height" :570
	}

	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}
		}
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onBeforeClear && typeof onBeforeClear === 'function'){
			while(popWin.erpPopupVaultFnOnBeforeClear == undefined){
				popWin.erpPopupVaultFnOnBeforeClear = onBeforeClear;
			}
		}
		if(onUploadComplete && typeof onUploadComplete === 'function'){
			while(popWin.erpPopupVaultFnOnUploadComplete == undefined){
				popWin.erpPopupVaultFnOnUploadComplete = onUploadComplete;
			}
		}
		
		this.progressOff();
	}
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openVocConfirmPopup
 * @function_Description 콜백분배 팝업 열기
 * @param  
 * @param onRowDblClicked (function) / Function
 * @author 이병주
 */
$erp.openVocConfirmProcPopup = function(param,parentWindow,onRowDblClicked,onBeforeClear,onUploadComplete){
	var url = "/sis/businessmanagement/business/vocConfirmProc.sis"
	if(param == undefined || param == null){
		param = "";
	}
	var params = {
		"CLAIM_CIDX" : param
	}
	var option = {
			"win_id" : "openVocConfirmProcPopup",
			"width" : 600,
			"height" :730
	}

	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}
		}
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onBeforeClear && typeof onBeforeClear === 'function'){
			while(popWin.erpPopupVaultFnOnBeforeClear == undefined){
				popWin.erpPopupVaultFnOnBeforeClear = onBeforeClear;
			}
		}
		if(onUploadComplete && typeof onUploadComplete === 'function'){
			while(popWin.erpPopupVaultFnOnUploadComplete == undefined){
				popWin.erpPopupVaultFnOnUploadComplete = onUploadComplete;
			}
		}
		
		this.progressOff();
	}
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCallHistoryPopup
 * @function_Description 통화기록 팝업 열기
 * @param  CUSTOMER_SCCODE
 * @param 
 * @author 김동현
 */
$erp.openCallHistoryPopup = function(param,parentWindow){
	var url = "/common/popup/openCallHistoryPopup.sis"
	if(param == undefined || param == null){
		param = "";
	}
	var params = {
		"CUSTOMER_SCCODE" : param
	}
	var option = {
			"win_id" : "openCallHistoryPopup",
			"width" : 450,
			"height" :450
	}

	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
            while(popWin.erpPopupParentWindow == undefined){
                popWin.erpPopupParentWindow = parentWindow;
            }
        }
		
		this.progressOff();
	}
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSamplePopupList
 * @function_Description 샘플 팝업 열기
 * @param  
 * @param onRowDblClicked (function) / Function
 * @author 김동현
 */
$erp.openSamplePopupList = function(param,parentWindow){
	var url = "/common/popup/openSamplePopup.sis"
	if(param == undefined || param == null){
		param = "";
	}
	var params = {
		"CUSTOMER_SCCODE" : param
	}
	var option = {
			"win_id" : "openSamplePopupList",
			"width" : 450,
			"height" :450
	}

	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
            while(popWin.erpPopupParentWindow == undefined){
                popWin.erpPopupParentWindow = parentWindow;
            }
        }
		
		this.progressOff();
	}
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openOrderFormPopup
 * @function_Description 주문서 상세뷰 팝업 열기
 * @param Order_DCIdx (Int) / 주문서 번호 
 * @param 
 * @author 김동현
 */
$erp.openOrderFormPopup = function(strOrderDCIdx, strOrderDDate, strOrderDCCode, strCustomerName , strMemberCode, parentWindow){
    var url = "/sis/dataInput/productApproval/openOrderFormPopup.sis";
    if(strOrderDCIdx == undefined || strOrderDCIdx == null){
        strOrderDCIdx = "";
    }
    
    if(strOrderDDate == undefined || strOrderDDate == null){
        strOrderDDate = "";
    }
    
    if(strOrderDCCode == undefined || strOrderDCCode == null){
    	strOrderDCCode = "";
    }
    
    if(strCustomerName == undefined || strCustomerName == null){
    	strCustomerName = "";
    }
    
    if(strMemberCode == undefined || strMemberCode == null){
    	strMemberCode = "";
    }
    
    var params = {
            "OrderDCIdx" : strOrderDCIdx
            , "OrderDDate" : strOrderDDate
            , "OrderDCCode" : strOrderDCCode
            , "CustomerName" : strCustomerName
            , "MemberCode" : strMemberCode
    }
    
    var option = {
    		"win_id" : "openOrderForm",
    		"width" : 1050,
            "height" :650
    }

    var onContentLoaded = function(){
        var popWin = this.getAttachedObject().contentWindow;
        
        if(parentWindow && typeof parentWindow === 'object'){
            while(popWin.erpPopupParentWindow == undefined){
                popWin.erpPopupParentWindow = parentWindow;
            }
        }
        
        this.progressOff();
    }
    $erp.openPopup(url, params, onContentLoaded, option);
}


/** 
 * Description 
 * @function openCommonCustomerPopup
 * @function_Description 공통고객조회팝업
 * @param 고객코드 고객명 화면에표시할고객코드 화면에표시할고객명
 * @param 
 * @author 양중호
 */
$erp.openCommonCustomerPopup = function(searchCustomerCd, searchCustomerNm, txtCd, txtNm, paramArray, callbackFunction){

    var onRowDblClicked = function(rId, cInd){
		var custCd = this.cells(rId, this.getColIndexById("CUSTOMER_CODE")).getValue();
		var custNm = this.cells(rId, this.getColIndexById("CUSTOMER_NAME")).getValue();
		
		document.getElementById(txtCd).value=custCd;
		document.getElementById(txtNm).value=custNm;
		
		//txtCd, txtNm 말고 추가 데이터가 필요한 경우
		if(paramArray != null && paramArray != '' && paramArray != undefined){
			for(index in paramArray){
				try{
					document.getElementById(paramArray[index]).value = this.cells(rId, this.getColIndexById(paramArray[index])).getValue();					
				}catch(e){}
			}
		}
		
		//id가 다른경우 대비용
		if(callbackFunction != null && callbackFunction != '' && callbackFunction != undefined){
			var rtnArray = [];
			for(index in paramArray){
				try{
					rtnArray[index] = this.cells(rId, this.getColIndexById(paramArray[index])).getValue();					
				}catch(e){}
			}
			callbackFunction(rtnArray);
		}
		
		var erpPopupWindowsCell = erpPopupWindows.window("searchCustomerPopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}
	}
	
	
 	var url = "/common/popup/openSearchCustomerCdPopup.sis";
 	
 	var params = {
			  "searchCustomerCd" : searchCustomerCd
			 ,"searchCustomerNm" : searchCustomerNm
		}
		//$erp.closePopup();
		
	var option = {
			"win_id" : "searchCustomerPopup",
			"width" : 480,
			"height" : 500
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openCommonCustomerPopup
 * @function_Description 공통고객조회팝업
 * @param 고객코드 고객명 화면에표시할고객코드 화면에표시할고객명
 * @param 
 * @author 양중호
 */
$erp.openCommonCustomerTypePopup = function(searchType, searchText, chnKbn, searchCustomerYN, ROUTE_DIV, callbackFunction){

    var onRowDblClicked = function(rId, cInd){
		var custCd = this.cells(rId, this.getColIndexById("CUSTOMER_CODE")).getValue();
		var custNm = this.cells(rId, this.getColIndexById("CUSTOMER_NAME")).getValue();
		var custMemberNm = this.cells(rId, this.getColIndexById("MEMBER_NAME")).getValue();

		//고객상담 고객검색 탭에서 사용
		if(searchCustomerYN != undefined && searchCustomerYN != null && searchCustomerYN == 'Y'){
			document.getElementById("txtYC_CODE_CUSTOMER_SEARCH").value=custCd;
			document.getElementById("txtYC_NAME_CUSTOMER_SEARCH").value=custNm;
			document.getElementById("txtYC_NAMECODE_CUSTOMER_SEARCH").value=custCd + '  ' + custNm + '  ' + custMemberNm;
			
			if(chnKbn=='Y'){
				document.getElementById("txtYC_CODE_CUSTOMER_SEARCH").onchange();
			}			
		}else{
			document.getElementById("txtYC_CODE").value=custCd;
			document.getElementById("txtYC_NAME").value=custNm;
			//document.getElementById("txtYC_TEAM").value=custTeam;
			document.getElementById("txtYC_NAMECODE").value=custCd + '  ' + custNm + '  ' + custMemberNm;
			
			
			if(chnKbn=='Y'){
				document.getElementById("txtYC_CODE").onchange();
			}
		}
		
		if(callbackFunction != undefined && callbackFunction != null){
			callbackFunction();
		}
		
		var erpPopupWindowsCell = erpPopupWindows.window("searchCuustomerTypePopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}
	}
   
 	var url = "/common/popup/openSearchCustomerTypePopup.sis";
 	
 	var params = {
 			"searchType" : searchType
			 ,"searchText" : searchText
			 ,"ROUTE_DIV" : ROUTE_DIV
 	}
		//$erp.closePopup();
		
	var option = {
			"win_id" : "searchCuustomerTypePopup",
			"width" : 700,
			"height" :800
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openCommonCustomerPopup2
 * @function_Description 공통고객조회팝업
 * @param 고객코드 고객명 화면에표시할고객코드 화면에표시할고객명
 * @author 하혜민
 */
$erp.openCommonCustomerTypePopup2 = function(searchType, searchText, chnKbn, searchCustomerYN, ROUTE_DIV){
	
	var onRowDblClicked = function(rId, cInd){
		var custCd = this.cells(rId, this.getColIndexById("CUSTOMER_CODE")).getValue();
		var custNm = this.cells(rId, this.getColIndexById("CUSTOMER_NAME")).getValue();
		var custMemberNm = this.cells(rId, this.getColIndexById("MEMBER_NAME")).getValue();
		
		if(searchCustomerYN != undefined && searchCustomerYN != null && searchCustomerYN == 'Y'){
			document.getElementById("txtYC_CODE_CUSTOMER_SEARCH").value=custCd;
			document.getElementById("txtYC_NAME_CUSTOMER_SEARCH").value=custNm;
			document.getElementById("txtYC_NAMECODE_CUSTOMER_SEARCH").value=custCd + '  ' + custNm + '  ' + custMemberNm;
			
			if(chnKbn=='Y'){
				document.getElementById("txtYC_CODE_CUSTOMER_SEARCH").onchange();
			}			
		}else{
			document.getElementById("txtYC_CODE2").value=custCd;
			document.getElementById("txtYC_NAME2").value=custNm;
			//document.getElementById("txtYC_TEAM").value=custTeam;
			document.getElementById("txtYC_NAMECODE2").value=custCd + '  ' + custNm + '  ' + custMemberNm;
			
			
			if(chnKbn=='Y'){
				document.getElementById("txtYC_CODE2").onchange();
			}
		}
		
		var erpPopupWindowsCell = erpPopupWindows.window("searchCuustomerTypePopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}
	}
	
	
	
	var url = "/common/popup/openSearchCustomerTypePopup.sis";
	
	var params = {
			"searchType" : searchType
			,"searchText" : searchText
			,"ROUTE_DIV" : ROUTE_DIV
	}
	//$erp.closePopup();
	
	var option = {
			"win_id" : "searchCuustomerTypePopup",
			"width" : 700,
			"height" :800
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}


/** 
 * Description 
 * @function openCommonCustomerPopup
 * @function_Description 공통고객조회팝업
 * @param 고객코드 고객명 화면에표시할고객코드 화면에표시할고객명
 * @param 
 * @author 양중호
 */
$erp.openCommonCustomerTypeDepartmentPopup = function(searchType, searchText, chnKbn, searchCustomerYN){

    var onRowDblClicked = function(rId, cInd){
		var custCd = this.cells(rId, this.getColIndexById("CUSTOMER_CODE")).getValue();
		var custNm = this.cells(rId, this.getColIndexById("CUSTOMER_NAME")).getValue();
		var custMemberNm = this.cells(rId, this.getColIndexById("MEMBER_NAME")).getValue();

		//고객상담 고객검색 탭에서 사용
		if(searchCustomerYN != undefined && searchCustomerYN != null && searchCustomerYN == 'Y'){
			document.getElementById("txtYC_CODE_CUSTOMER_SEARCH").value=custCd;
			document.getElementById("txtYC_NAME_CUSTOMER_SEARCH").value=custNm;
			document.getElementById("txtYC_NAMECODE_CUSTOMER_SEARCH").value=custCd + '  ' + custNm + '  ' + custMemberNm;
			
			if(chnKbn=='Y'){
				document.getElementById("txtYC_CODE_CUSTOMER_SEARCH").onchange();
			}			
		}else{
			document.getElementById("txtYC_CODE").value=custCd;
			document.getElementById("txtYC_NAME").value=custNm;
			//document.getElementById("txtYC_TEAM").value=custTeam;
			document.getElementById("txtYC_NAMECODE").value=custCd + '  ' + custNm + '  ' + custMemberNm;
			
			
			if(chnKbn=='Y'){
				document.getElementById("txtYC_CODE").onchange();
			}
		}
		
		var erpPopupWindowsCell = erpPopupWindows.window("searchCuustomerTypePopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}
	}
	
    
   
 	var url = "/common/popup/openSearchCustomerTypePopup.sis";
 	
 	var params = {
			  "searchType" : searchType
			 ,"searchText" : searchText
			 ,"departmentKbn" : 'Y'
		}
		//$erp.closePopup();
		
	var option = {
			"win_id" : "searchCuustomerTypePopup",
			"width" : 700,
			"height" :800
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openCommonCustomerPopup
 * @function_Description 공통고객조회팝업
 * @param 고객코드 고객명 화면에표시할고객코드 화면에표시할고객명
 * @param 
 * @author 양중호
 */
$erp.openCommonCustomerTypePopup1 = function(searchType, searchText, chnKbn, txtCd, txtNm, txtCdNm){

    var onRowDblClicked = function(rId, cInd){
		var custCd = this.cells(rId, this.getColIndexById("CUSTOMER_CODE")).getValue();
		var custNm = this.cells(rId, this.getColIndexById("CUSTOMER_NAME")).getValue();
		var custMemberNm = this.cells(rId, this.getColIndexById("MEMBER_NAME")).getValue();
		
		
		document.getElementById(txtCd).value=custCd;
		document.getElementById(txtNm).value=custNm;
		//document.getElementById("txtYC_TEAM").value=custTeam;
		document.getElementById(txtCdNm).value=custCd + '  ' + custNm + '  ' + custMemberNm;
		
		
		if(chnKbn=='Y'){
			document.getElementById(txtCd).onchange();
		}
		
		var erpPopupWindowsCell = erpPopupWindows.window("searchCuustomerTypePopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}
	}
	
    
   
 	var url = "/common/popup/openSearchCustomerTypePopup.sis";
 	
 	var params = {
			  "searchType" : searchType
			 ,"searchText" : searchText
		}
		//$erp.closePopup();
		
	var option = {
			"win_id" : "searchCuustomerTypePopup",
			"width" : 700,
			"height" :800
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openCommonCustomerPopup
 * @function_Description 공통고객조회팝업
 * @param 담당자명 지역코드 팀코드  화면에표시할담당자코드 화면에표시할담당자명  화면에표시할담당자코드명, 지역/팀/담당 의 콤보박스 selected 할 table의 id, 고객명부에서 사용할 담당직원 , onchage이벤트Yn 
 * @param 
 * @author 양중호
 */

$erp.openCommonMemberPopup = function(searchChargeMember, cmbBusinessInfCd, memberTeamCd,  txtCd, txtNm, txtCdNm, txtTableId, txtCustInfoMemName, cmbName, onchange, enable_yn){
  
	if(enable_yn == undefined || enable_yn == null){
		enable_yn = '0';
	}
	
    var onRowDblClicked = function(rId, cInd){
		var custCd = this.cells(rId, this.getColIndexById("MEMBER_CODE")).getValue();
		var custNm = this.cells(rId, this.getColIndexById("MEMBER_NAME")).getValue();
		
		var custCodeBusiTeamNm = this.cells(rId, this.getColIndexById("FULLCDNMBUSI")).getValue();
		
		if(txtCd != ''){
			document.getElementById(txtCd).value=custCd;
		}
		if(txtNm != ''){
			document.getElementById(txtNm).value=custNm;
		}
		if(txtCdNm != ''){
			document.getElementById(txtCdNm).value = custCd +' ' +custNm;
		}
		if(txtCustInfoMemName != null && txtCustInfoMemName != '' && txtCustInfoMemName != undefined){
			document.getElementById(txtCustInfoMemName).value = custCodeBusiTeamNm;
		}
		
		if(cmbName !='' && cmbName !=undefined){
			
			var addObj =  new Object();     // 객체 값 입력후 main배열의 0번 index에 셋팅 
	    	addObj [cmbName] = custCd;
			
			//부모창의 지역/팀명/담당 셑팅
			if(txtTableId != null && txtTableId != '' && txtTableId != undefined){
				$erp.bindCmbValue(addObj, document.getElementById(txtTableId));
			}		
			
		}else{
			
			//부모창의 지역/팀명/담당 셑팅
			if(txtTableId != null && txtTableId != '' && txtTableId != undefined){
				$erp.bindCmbValue({"MEMBER_INF":custCd}, document.getElementById(txtTableId));
			}
			
			
		}
		
		if(onchange=='Y'){
			document.getElementById(txtCd).onchange();
		}
		
		var erpPopupWindowsCell = erpPopupWindows.window("searchMemberPopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close(); 
		}
	}
	
	
 	var url = "/common/popup/openSearchMemberCdPopup.sis";
 	
 	var params = {
			  "searchChargeMember" : searchChargeMember
			 ,"cmbBusinessInfCd" : cmbBusinessInfCd
			 , "memberTeamCd" : memberTeamCd
			 , "enable_yn" : enable_yn
		}
		//$erp.closePopup();
		
	var option = {
			"win_id" : "searchMemberPopup",
			"width" : 480,
			"height" :500
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openCommonCustomerPopup2
 * @function_Description 공통고객조회팝업
 * @param  
 * @author 주병훈
 */

$erp.openCommonMemberPopup2 = function(cmbBusinessInfCd, saleChDiv, memberNm, onRowDblClicked){
	
 	var url = "/common/popup/openSearchMemberCdPopup2.sis";
 	
 	var params = {
 			"cmbBusinessInfCd" : cmbBusinessInfCd
			, "saleChDiv" : saleChDiv
			, "memberNm" : memberNm
		}
		//$erp.closePopup();
		
	var option = {
			"win_id" : "searchMemberPopup",
			"width" : 480,
			"height" :500
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openCommonCustomerPopup
 * @function_Description 공통고객조회팝업
 * @param 사업자명 화면에표시할사업자코드 화면에표시할사업자명  화면에표시할사업자코드명 
 * @param 
 * @author 양중호
 */

$erp.openCommonBusinessPopup = function(searchBusinessCd, searchBusinessNm,txtCd, txtNm, txtCdNm){
  
    var onRowDblClicked = function(rId, cInd){
		var businessCd = this.cells(rId, this.getColIndexById("RECEIPT_CODE")).getValue();
		var businessNm = this.cells(rId, this.getColIndexById("RECEIPT_NAME")).getValue();
		var businessAdmin = this.cells(rId, this.getColIndexById("RECEIPT_ADMIN")).getValue();

		if(txtCd != ''){
			document.getElementById(txtCd).value=businessCd;
		}
		if(txtNm != ''){
			document.getElementById(txtNm).value=businessNm+'(' + businessAdmin +')';
		}
		if(txtCdNm != ''){
			document.getElementById(txtCdNm).value = businessCd +' ' +businessNm+'(' + businessAdmin +')';
		}
		var erpPopupWindowsCell = erpPopupWindows.window("searchBusinessPopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}
	}
	
	
 	var url = "/common/popup/openSearchBusinessCdPopup.sis";
 	
 	var params = {
			  "searchBusinessCd" : searchBusinessCd
			  ,"searchBusinessNm" : searchBusinessNm
		}
		//$erp.closePopup();
		
	var option = {
			"win_id" : "searchBusinessPopup",
			"width" : 480,
			"height" :500
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openUsePointPopup
 * @function_Description 적립금 팝업
 * @param 주문서 팝업의 적립금 팝업 
 * @param 
 * @author 김동현
 */
$erp.openUsePointPopup = function(onComplete, strOrderDCCode, windowOption){
	var params = {
			"strOrderDCCode" : strOrderDCCode
	}
	
	var url = "/sis/dataInput/productApproval/usePointPopup.sis";
	
	var option = {
			"win_id" : "usePointPopup",
			"width" : 400,
			"height" :280
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCreateCouponPopup
 * @function_Description 쿠폰 팝업
 * @param 주문서 팝업의 쿠폰 팝업 
 * @param 
 * @author 김동현
 */
$erp.openCreateCouponPopup = function(onComplete, strOrderDCCode, windowOption){
	var params = {
			"strOrderDCCode" : strOrderDCCode
	}
	
	var url = "/sis/dataInput/productApproval/createCouponPopup.sis";
	
	var option = {
			"win_id" : "createCouponPopup",
			"width" : 600,
			"height" :600
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}


/** 
 * Description 
 * @function openCommonGoodsPopup
 * @function_Description 공통고객조회팝업
 * @param 상품명 상품코드  화면에표시할상품코드 화면에표시할상품명  화면에표시할상품코드명,  onchage이벤트Yn 
 * @param 
 * @author 양중호
 */

$erp.openCommonGoodsPopup = function(searchGoodsNm, searchGoodsCd, txtCd, txtNm, txtCdNm, onchange, txtOcode){
  
    var onRowDblClicked = function(rId, cInd){
		var goodsCd = this.cells(rId, this.getColIndexById("CODE")).getValue();
		var goodsNm = this.cells(rId, this.getColIndexById("NAME")).getValue();
		var goodsOcode = this.cells(rId, this.getColIndexById("ARTICLE_OCODE")).getValue(); //상품명약어
		
		//var custCodeBusiTeamNm = this.cells(rId, this.getColIndexById("FULLCDNMBUSI")).getValue();
		
		if(txtCd != ''){
			document.getElementById(txtCd).value=goodsCd;
		}
		if(txtNm != ''){
			document.getElementById(txtNm).value=goodsNm;
			//document.getElementById(txtNm).value='';
		}
		if(txtCdNm != ''){
			document.getElementById(txtCdNm).value = goodsCd +' ' +goodsNm;
		}
		if(txtOcode != undefined && txtOcode != null){
			document.getElementById(txtOcode).value = goodsOcode;
		}
		
		/*
		if(txtCustInfoMemName != null && txtCustInfoMemName != '' && txtCustInfoMemName != undefined){
			document.getElementById(txtCustInfoMemName).value = custCodeBusiTeamNm;
		}
		
*/		//부모창의 지역/팀명/담당 셑팅
		/*if(txtTableId != null && txtTableId != '' && txtTableId != undefined){
			$erp.bindCmbValue({"MEMBER_INF":custCd}, document.getElementById(txtTableId));
		}*/
		
		if(onchange=='Y'){
			document.getElementById(txtCd).onchange();
		}
		
		var erpPopupWindowsCell = erpPopupWindows.window("searchGoodsPopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close(); 
		}
	}
	
	
 	var url = "/common/popup/openSearchGoodsCdPopup.sis";
 	
 	var params = {
 			  "searchGoodsCd" : searchGoodsCd
			  ,"searchGoodsNm" : searchGoodsNm
		}
		//$erp.closePopup();
		
	var option = {
			"win_id" : "searchGoodsPopup",
			"width" : 700,
			"height" :800
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openPostWritePopup
 * @function_Description 편지 쓰기 팝업
 * @param 주문서 편지쓰기 팝업 
 * @param 
 * @author 김동현
 */
$erp.openPostWritePopup = function(onComplete, onComplete2, strShippingCustName, strPostWirte, windowOption){
	var params = {
		"strShippingCustName" : strShippingCustName
		,"strPostWirte" : strPostWirte
	}
  
	var url = "/sis/dataInput/productApproval/openPostWritePopup.sis";
  
	var option = {
		"win_id" : "openPostWritePopup",
		"width" : 600,
		"height" :600
	}
  
	var onContentLoaded = function(){
	    var popWin = this.getAttachedObject().contentWindow;
	
	    if(onComplete && typeof onComplete === 'function'){
	    	while(popWin.erpPopupOnComplete == undefined){
	    		popWin.erpPopupOnComplete = onComplete;
	    	}
	    }
	
	    if(onComplete2 && typeof onComplete2 === 'function'){
	    	while(popWin.erpPopupOnComplete2 == undefined){
	    		popWin.erpPopupOnComplete2 = onComplete2;  
			}
		}
        
        this.progressOff();
    }

	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
		}
	}

	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSmsSendList
 * @function_Description SMS 팝업
 * @param 주문서 SMS 팝업 
 * @param 
 * @author 김동현
 */
$erp.openSmsSendList = function(onComplete, strPostWirte, windowOption){
	var params = {
			"strPostWirte" : strPostWirte
	}
	
	var url = "/sis/dataInput/productApproval/openSmsSendList.sis";
	
	var option = {
			"win_id" : "openSmsSendList",
			"width" : 600,
			"height" :600
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openPaymentPopup
 * @function_Description 결제 팝업
 * @param 주문서 결제 팝업 
 * @param 
 * @author 김동현
 */
$erp.openPaymentPopup = function(onComplete, strOrderDCCode, windowOption){
	var params = {
			"strOrderDCCode" : strOrderDCCode
	}
	
	var url = "/sis/dataInput/productApproval/openPaymentPopup.sis";
	
	var option = {
			"win_id" : "openPaymentPopup",
			"width" : 450,
			"height" :400
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openUnknownPopup
 * @function_Description 미확인자 팝업
 * @param 고객상담 미확인자 팝업 
 * @param 
 * @author 김동현
 */
$erp.openUnknownPopup = function(onComplete, custCode, windowOption){
	var params = {
			"custCode" : custCode
	}
	var url = "/common/popup/openUnknownPopup.sis";
	var option = {
			"win_id" : "openUnknownPopup",
			"width" : 800,
			"height" :800
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}


/** 
 * Description 
 * @function openUsePointPopup
 * @function_Description 적립금 팝업
 * @param 고객상담 적립금 팝업 
 * @param 
 * @author 양중호
 */
$erp.openSearchPointPopup = function(onComplete, custCode, windowOption){
	var params = {
			"custCode" : custCode
	}
	var url = "/common/popup/openSearchPointPopup.sis";
	var option = {
			"width" : 700,
			"height" :800
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCommonCustomerPopup
 * @function_Description 공통적립금행사명조회팝업
 * @param 적립금행사명
 * @param 
 * @author 이병주
 */
$erp.openSearchSaveMoneyPromotionNamePopup = function(txtSearchName, callbackFunction){

    var onRowDblClicked = function(rId, cInd){
    	
    	var promotionName = this.cells(rId, this.getColIndexById("ORESERVE_MEMO")).getValue();
    	callbackFunction(promotionName);

		var erpPopupWindowsCell = erpPopupWindows.window("openSearchSaveMoneyPromotionNamePopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}
	}
	
 	var url = "/common/popup/openSearchSaveMoneyPromotionNamePopup.sis";
 	var params = { "SEARCHNAME" : txtSearchName }
	var option = {
			"win_id" : "openSearchSaveMoneyPromotionNamePopup",
			"width" : 480,
			"height" :500
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
 	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openUsePointPopup
 * @function_Description 샘플 팝업
 * @param 고객상담 샘플 팝업 
 * @param 
 * @author 양중호
 */
$erp.openRegistSamplePopup = function(onComplete, custCode, windowOption){
	var params = {
			"custCode" : custCode
	}
	var url = "/common/popup/openRegistSamplePopup.sis";
	var option = {
			"width" : 700,
			"height" :800
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}


/** 
 * Description 
 * @function openUsePointPopup
 * @function_Description 적립금 팝업
 * @param 고객상담 적립금 팝업 
 * @param 
 * @author 양중호
 */
$erp.openProductSamplePopup = function(onComplete, onConfirm, sampleTxt, windowOption){
	
	//alert('onComplete5');
	var params = {
			"sampleTxt" : sampleTxt
	}
	var url = "/common/popup/openProductSamplePopup.sis";
	var option = {
			"width" : 600,
			"height" :600
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onConfirm && typeof onConfirm === 'function'){
            while(popWin.erpPopupOnConfirm == undefined){
                popWin.erpPopupOnConfirm = onConfirm;    
                
            }
        }
        
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openReturnRequestPopup
 * @function_Description 반품요청 팝업
 * @param 고객상담 반품요청 팝업 
 * @param 
 * @author 김동현
 */
$erp.openReturnRequestPopup = function(onComplete, custCode, customerMCode, customerWArea, windowOption){
	var params = {
			"custCode" : custCode,
			"customerMCode" : customerMCode,
			"customerWArea" : customerWArea
	}
	var url = "/common/popup/openReturnRequestPopup.sis";
	var option = {
			"win_id" : "openReturnRequestPopup",
			"width" : 850,
			"height" :700
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        this.progressOff();
    }
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openReservationCallPopup
 * @function_Description 예약콜 팝업
 * @param 고객상담 예약콜 팝업 
 * @param 
 * @author 양중호
 */
$erp.openReservationCallPopup = function(custCode, windowOption, departmentKbn){
	
	var onComplete = function(){
		var erpPopupWindowsCell = erpPopupWindows.window("openReservationCallPopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}        
    }
	var onSelectCustomer = function(custCode){
		customerChange(custCode);
		
		var erpPopupWindowsCell = erpPopupWindows.window("openReservationCallPopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}  
    }

	var params = {
			"custCode" : custCode
			,"departmentKbn" : departmentKbn
	}
	var url = "/common/popup/openReservationCallPopup.sis";
		
	var option = {
			"win_id" : "openReservationCallPopup",
			"width" : 1000,
			"height" : 800
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onSelectCustomer && typeof onSelectCustomer === 'function'){
            while(popWin.erpPopupOnSelectCustomer== undefined){
                popWin.erpPopupOnSelectCustomer = onSelectCustomer;    
                
            }
        }
        
        this.progressOff();
    }
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openSearchCampainPopup
 * @function_Description 캠페인조회팝업
 * @param 캠페인명, 캠페인코드
 * @param 
 * @author 이병주
 */
$erp.openSearchCampainPopup = function(txtSearchNm, txtSearchDt, callbackFunction){

    var onRowDblClicked = function(rId, cInd){
    	
    	var campaignCode = this.cells(rId, this.getColIndexById("CAMPAIGN_CODE")).getValue();
    	var campaignName = this.cells(rId, this.getColIndexById("CAMPAIGN_NAME")).getValue();
    	callbackFunction(campaignName, campaignCode);

		var erpPopupWindowsCell = erpPopupWindows.window("openSearchCampainPopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}
	}
	
 	var url = "/common/popup/openSearchCampainPopup.sis";
 	var params = { "SEARCH_NM" : txtSearchNm, "SEARCH_DT" : txtSearchDt }
	var option = {
			"win_id" : "openSearchCampainPopup",
			"width" : 480,
			"height" :500
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
 	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openCustomerInfoPopup
 * @function_Description 고객정보 팝업
 * @param 고객상담 고객정보 팝업 
 * @param 
 * @author 양중호
 */
$erp.openCustomerInfoPopup = function(custCode, windowOption){

	var onComplete = function(){
		var erpPopupWindowsCell = erpPopupWindows.window("openCustomerInfoPopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}        
    }
	var onSelectCustomer = function(custCode){
		customerChange(custCode);
		
		var erpPopupWindowsCell = erpPopupWindows.window("openCustomerInfoPopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}  
    }

	var params = {
			"custCode" : custCode
	}
	var url = "/common/popup/openCustomerInfoPopup.sis";
		
	var option = {
			"win_id" : "openCustomerInfoPopup",
			"width" : 1024,
			"height" :814
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}	
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onSelectCustomer && typeof onSelectCustomer === 'function'){
            while(popWin.erpPopupOnSelectCustomer== undefined){
                popWin.erpPopupOnSelectCustomer = onSelectCustomer;    
                
            }
        }
        this.progressOff();
    }

	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	
}

/** 
 * Description 
 * @function openCallRecordPopup
 * @function_Description 반품요청 팝업
 * @param 고객상담 반품요청 팝업 
 * @param 
 * @author 김동현
 */
$erp.openCallRecordPopup = function(onComplete, custCode, custNm, customerMCode, customerWArea, windowOption){
	var params = {
			"custCode" : custCode,
			"custNm" : custNm,
			"customerMCode" : customerMCode,
			"customerWArea" : customerWArea
	}
	var url = "/common/popup/openCallRecordPopup.sis";
	var option = {
			"win_id" : "openCallRecordPopup",
			"width" : 850,
			"height" :700
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchBuyPurposePopup
 * @function_Description 구매목적조회팝업
 * @param 
 * @param 
 * @author 이병주
 */
$erp.openSearchBuyPurposePopup = function(txtSearchName, callbackFunction){

    var onRowDblClicked = function(rId, cInd){
    	
    	var disCode = this.cells(rId, this.getColIndexById("DIS_CODE")).getValue();
    	var disName = this.cells(rId, this.getColIndexById("DIS_NAME")).getValue();
    	callbackFunction(disCode, disName);

		var erpPopupWindowsCell = erpPopupWindows.window("openSearchBuyPurposePopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}
	}
	
 	var url = "/common/popup/openSearchBuyPurposePopup.sis";
 	var params = { "SEARCHNAME" : txtSearchName }
	var option = {
			"win_id" : "openSearchBuyPurposePopup",
			"width" : 480,
			"height" :500
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
 	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openVOCClaimPopup
 * @function_Description VOC 클레임 팝업
 * @param VOC 클레임 팝업
 * @author 김동현
 */
$erp.openVOCClaimPopup = function(onComplete, custCode, custNm, customerMCode, customerWArea, windowOption){
	var params = {
			"custCode" : custCode,
			"custNm" : custNm,
			"customerMCode" : customerMCode,
			"customerWArea" : customerWArea
	}
	var url = "/common/popup/openVOCClaimPopup.sis";
	var option = {
			"win_id" : "openVOCClaimPopup",
			"width" : 850,
			"height" :700
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openVOCKindPopup
 * @function_Description VOC 칭찬/제안 팝업
 * @param VOC 칭찬/제안 팝업
 * @author 김동현
 */
$erp.openVOCKindPopup = function(onComplete, custCode, custNm, customerMCode, customerWArea, windowOption){
	var params = {
			"custCode" : custCode,
			"custNm" : custNm,
			"customerMCode" : customerMCode,
			"customerWArea" : customerWArea
	}
	var url = "/common/popup/openVOCKindPopup.sis";
	var option = {
			"win_id" : "openVOCKindPopup",
			"width" : 850,
			"height" :700
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCustInfoSMSPopup
 * @function_Description 개인정보 동의 내역서 보내기
 * @param VOC 칭찬/제안 팝업
 * @author 김동현
 */
$erp.openCustInfoSMSPopup = function(onComplete, windowOption){
	var params = {
	}
	var url = "/common/popup/openCustInfoSMSPopup.sis";
	var option = {
			"win_id" : "CustInfoSMS",
			"width" : 350,
			"height" :300
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openProductCouponPopup
 * @function_Description 상품검색 (쿠폰/프로모션) 팝업
 * @param 상품검색 (쿠폰/프로모션) 팝업
 * @param 
 * @author 양중호
 */
$erp.openProductCouponPopup = function(onComplete, onConfirm, sampleTxt, windowOption){
	
	//alert('onComplete5');
	var params = {
			
	}
	var url = "/common/popup/openProductCouponPopup.sis";
	var option = {
			"width" : 800,
			"height" :800
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onConfirm && typeof onConfirm === 'function'){
            while(popWin.erpPopupOnConfirm == undefined){
                popWin.erpPopupOnConfirm = onConfirm;    
                
            }
        }
        
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCustomerCouponPopup
 * @function_Description 고객검색 (쿠폰/프로모션) 팝업
 * @param 고객검색 (쿠폰/프로모션) 팝업
 * @param 
 * @author 양중호
 */
$erp.openCustomerCouponPopup = function(onComplete, onConfirm, sampleTxt, windowOption){
	
	//alert('onComplete5');
	var params = {
	}
	var url = "/common/popup/openCustomerCouponPopup.sis";
	var option = {
			"width" : 800,
			"height" :800
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onConfirm && typeof onConfirm === 'function'){
            while(popWin.erpPopupOnConfirm == undefined){
                popWin.erpPopupOnConfirm = onConfirm;    
                
            }
        }
        
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openUsePointPopup
 * @function_Description 배송지 팝업
 * @param 고객상담 배송지 팝업 
 * @param 
 * @author 이병주
 */
$erp.openSearchDeliveryPopup = function(onComplete, custCode, windowOption){
	var params = {
			"custCode" : custCode
	}
	var url = "/common/popup/openSearchDeliveryPopup.sis";
	var option = {
			"width" : 1200,
			"height" :800
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function fnOpenSearchDeliveryPopup
 * @function_Description 구매목적조회팝업
 * @param 
 * @param 
 * @author 이병주
 */
$erp.fnOpenSearchDeliveryPopup = function(searchType, searchText, searchDeliveryCd, callbackFunction){

    var onRowDblClicked = function(rId, cInd){
    	
    	var order_didx = this.cells(rId, this.getColIndexById("ORDER_DIDX")).getValue();
    	callbackFunction(order_didx);

		var erpPopupWindowsCell = erpPopupWindows.window("openSearchDeliveryCustomerPopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}
	}
	
 	var url = "/common/popup/openSearchDeliveryCustomerPopup.sis";
 	var params = { 
 		"SEARCHTYPE" : searchType 
 		, "SEARCHTEXT" : searchText
 		, "SEARCHDELIVERYCD" : searchDeliveryCd
 	}
	var option = {
			"win_id" : "openSearchDeliveryCustomerPopup",
			"width" : 480,
			"height" :500
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
 	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openCallBackMovePopup
 * @function_Description 고객검색 (쿠폰/프로모션) 팝업
 * @param 고객검색 (쿠폰/프로모션) 팝업
 * @param 
 * @author 김동현
 */
$erp.openCallBackMovePopup = function(onComplete, onComplete2, strCallNIdx, strCustomerCode, strCallBPhone, strCallNMemo, strCallMEMBER_CODE, strCallMEMBER_WAREA, strCallMEMBER_TEAM, parentWindow){
    
    var params = {
            "strCallNIdx" : strCallNIdx,
            "strCustomerCode" : strCustomerCode,
            "strCallBPhone" : strCallBPhone,
            "strCallNMemo" : strCallNMemo,
            "strCallMEMBER_CODE" : strCallMEMBER_CODE,
            "strCallMEMBER_WAREA" : strCallMEMBER_WAREA,
            "strCallMEMBER_TEAM" : strCallMEMBER_TEAM
    }
    var url = "/sis/customerorder/openCallBackMovePopup.sis";
    var option = {
            "win_id" : "openCallBackMovePopup",
            "width" : 350,
            "height" :500
    }
    var onContentLoaded = function(){
        var popWin = this.getAttachedObject().contentWindow;
        
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onComplete2 && typeof onComplete2 === 'function'){
            while(popWin.erpPopupOnComplete2 == undefined){
                popWin.erpPopupOnComplete2 = onComplete2;    
                
            }
        }
        
        this.progressOff();
    }
    
    $erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchFavoriteGoodsPopup
 * @function_Description 선호상품 팝업
 * @param 선호상품 팝업 
 * @param 
 * @author 이병주
 */
$erp.openSearchFavoriteGoodsPopup = function(onComplete, custCode, windowOption){
	var params = {
			"custCode" : custCode
	}
	var url = "/common/popup/openSearchFavoriteGoodsPopup.sis";
	var option = {
			"width" : 500,
			"height" :500
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchStoragePopup
 * @function_Description 보관분 팝업
 * @param 보관분 팝업 
 * @param 
 * @author 주병훈
 */
$erp.openSearchStoragePopup = function(onComplete, custCode, windowOption){
	var params = {
			"custCode" : custCode
	}
	var url = "/common/popup/openSearchStoragePopup.sis";
	var option = {
			"width" : 1200,
			"height" :500
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchIntroduceCustomerPopup
 * @function_Description 소개한고객 팝업
 * @param 소개한고객 팝업 
 * @param 
 * @author 이병주
 */
$erp.openSearchIntroduceCustomerPopup = function(onComplete, custCode, windowOption){
	var params = {
			"custCode" : custCode
	}
	var url = "/common/popup/openSearchIntroduceCustomerPopup.sis";
	var option = {
			"width" : 550,
			"height" :500
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchCustomerGradePopup
 * @function_Description 회원등급 팝업
 * @param 회원등급 팝업 
 * @param 
 * @author 이병주
 */
$erp.openSearchCustomerGradePopup = function(onComplete, custCode, windowOption){
	var params = {
			"custCode" : custCode
	}
	var url = "/common/popup/openSearchCustomerGradePopup.sis";
	var option = {
			"width" : 550,
			"height" :500
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSMSSemdPopup
 * @function_Description [고객상담]-[SMS발송]
 * @param [고객상담]-[SMS발송]
 * @param 
 * @author 김동현
 */
$erp.openSMSSendPopup = function(onComplete, strCUSTOMER_THP, strCUSTOMER_TCP, strCUSTOMER_TEMP, parentWindow){
    var params = {
    		"strCUSTOMER_THP" : strCUSTOMER_THP,
            "strCUSTOMER_TCP" : strCUSTOMER_TCP,
            "strCUSTOMER_TEMP" : strCUSTOMER_TEMP
	}
    var url = "/sis/customerorder/openSMSSendPopup.sis";
    var option = {
            "win_id" : "openSMSSendPopup",
            "width" : 750,
            "height" :540
    }
    var onContentLoaded = function(){
        var popWin = this.getAttachedObject().contentWindow;
        
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }
    $erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchCustomerGradePopup
 * @function_Description 해피콜처리 팝업
 * @param 해피콜처리 팝업 
 * @param 
 * @author 이병주
 */
$erp.openSearchHappyCallProcPopup = function(onComplete, param1, param2, param3, param4, param5, windowOption){
	var params = {
			"param1" : param1
			, "param2" : param2
			, "param3" : param3
			, "param4" : param4
			, "param5" : param5
	}
	var url = "/common/popup/openSearchHappyCallProcPopup.sis";
	var option = {
			"width" : 550,
			"height" :500
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchMedicalExaminationByInterviewPopup
 * @function_Description 문진표 팝업
 * @param 문진표 팝업 
 * @param 
 * @author 이병주
 */
$erp.openSearchMedicalExaminationByInterviewPopup = function(onComplete, custCode, windowOption){
	var params = {
			"custCode" : custCode
	}
	var url = "/common/popup/openSearchMedicalExaminationByInterviewPopup.sis";
	var option = {
			"width" : 1000,
			"height" :800
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCommonGoodsPopup
 * @function_Description 공통그리드 상품조회팝업
 * @param onRowDblClicked
 * @param 
 * @author 양중호
 */

$erp.openCommonProductPopup = function(onRowDblClicked){
 	var url = "/common/popup/openSearchGoodsCdPopup.sis";
 	
 	var params = {
 			  "searchGoodsCd" : ''
			  ,"searchGoodsNm" : ''
		}
		//$erp.closePopup();
		
	var option = {
			"win_id" : "searchGoodsPopup",
			"width" : 700,
			"height" :800
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openCommonProductPopup
 * @function_Description 공통그리드 상품조회팝업
 * @param onRowDblClicked
 * @param 
 * @author 고용선
 */

$erp.openCommonChmallProductPopup = function(onRowDblClicked){
 	var url = "/common/popup/openSearchChmallGoodsCdPopup.sis";
 	
 	var params = {
 			  "searchGoodsCd" : ''
			  ,"searchGoodsNm" : ''
		}
		//$erp.closePopup();
		
	var option = {
			"win_id" : "searchChmallGoodsPopup",
			"width" : 700,
			"height" :800
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openShippingPlacementPopup
 * @function_Description 고객검색 (쿠폰/프로모션) 팝업
 * @param 고객검색 (쿠폰/프로모션) 팝업
 * @param 
 * @author 김동현
 */
$erp.openShippingPlacementPopup = function(onComplete, onComplete2, strOrderNIdx, parentWindow){
    
    var params = {
            "strOrderNIdx" : strOrderNIdx
    }
    var url = "/sis/customerorder/openShippingPlacementPopup.sis";
    var option = {
            "win_id" : "openShippingPlacementPopup",
            "width" : 1024,
            "height" :700
    }
    var onContentLoaded = function(){
        var popWin = this.getAttachedObject().contentWindow;
        
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onComplete2 && typeof onComplete2 === 'function'){
            while(popWin.erpPopupOnComplete2 == undefined){
                popWin.erpPopupOnComplete2 = onComplete2;    
                
            }
        }
        
        this.progressOff();
    }
    
    $erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCustInfoCleansingPopup
 * @function_Description 클랜징팝업
 * @param 클랜징팝업
 * @author 이병주
 */
$erp.openCustInfoCleansingPopup = function(onComplete, windowOption){
	var params = {
	}
	var url = "/common/popup/openCustInfoCleansingPopup.sis";
	var option = {
			"win_id" : "Cleansing",
			"width" : 300,
			"height" :300
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        this.progressOff();
    }

	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCustomerRegPopup
 * @function_Description 고객정보 등록 팝업
 * @param 고객상담 고객정보 등록 팝업 
 * @param 
 * @author 양중호
 */
$erp.openCustomerRegPopup = function(custCode, windowOption, ROUTE_DIV){

	var onComplete = function(){
		var erpPopupWindowsCell = erpPopupWindows.window("openCustomerRegPopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}        
    }
	var onSelectCustomer = function(custCode){
		customerChange(custCode);
		
		var erpPopupWindowsCell = erpPopupWindows.window("openCustomerRegPopup");
		if(erpPopupWindowsCell){
			erpPopupWindowsCell.close();
		}  
    }

	var params = {
	     "ROUTE_DIV" : ROUTE_DIV
	}
	var url = "/common/popup/openCustomerRegPopup.sis";
		
	var option = {
			"win_id" : "openCustomerRegPopup",
			"width" : 1024,
			"height" :814
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}	
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onSelectCustomer && typeof onSelectCustomer === 'function'){
            while(popWin.erpPopupOnSelectCustomer== undefined){
                popWin.erpPopupOnSelectCustomer = onSelectCustomer;    
                
            }
        }
        this.progressOff();
    }

	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);	
}

/** 
 * Description 
 * @function openUsePointPopup
 * @function_Description 배송지 팝업
 * @param 고객주문 배송지 주소록 
 * @param 
 * @author 김동현
 */
$erp.openSearchDeliveryPopup2 = function(onComplete, onComplete2, custCode, windowOption){
  var params = {
      "custCode" : custCode
  }
  var url = "/common/popup/openSearchDeliveryPopup2.sis";
  var option = {
      "width" : 1200,
      "height" :800
  }
  
  var parentWindow= window;
  
  var onContentLoaded = function(){
    var popWin = this.getAttachedObject().contentWindow;
    
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

        if(onComplete2 && typeof onComplete2 === 'function'){
            while(popWin.erpPopupOnComplete2 == undefined){
                popWin.erpPopupOnComplete2 = onComplete2;    
                
            }
        }
        
        this.progressOff();
    }
  
  if(windowOption && typeof windowOption === 'object'){
    for(var i in windowOption){
      option[i] = windowOption[i];
      }
  }
  
  $erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchPromotionPopup
 * @function_Description 프로모션상세 팝업
 * @param 프로모션상세 팝업 
 * @param 
 * @author 이병주
 */
$erp.openSearchPromotionPopup = function(onComplete, promotionCd, windowOption){
	var params = {
			"promotionCd" : promotionCd
	}
	var url = "/common/popup/openSearchPromotionPopup.sis";
	var option = {
			"width" : 1000,
			"height" :800
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchCustomerCounselCouponPopup
 * @function_Description 고객상담 쿠폰 팝업
 * @param 고객상담 쿠폰 팝업 
 * @param 
 * @author 이병주
 */
$erp.openSearchCustomerCounselCouponPopup = function(onComplete, custCode, windowOption){
	var params = {
			"custCode" : custCode
	}
	var url = "/common/popup/openSearchCustomerCounselCouponPopup.sis";
	var option = {
			"width" : 750,
			"height" :800
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}



/** 
 * Description 
 * @function openSearchOrgnPopup
 * @function_Description 조직 조회 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 주병훈
 */

$erp.openSearchOrgnTreePopup = function(onComplete, onConfirm){
	var url = "/common/popup/searchOrgnTreePopup.sis";

	var params = {
			//"ORGN_NM" : orgnNm
			//, "ORGN_DIV_CD" : orgnDivCd
	}
	var onContentLoaded = function(){
	var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onConfirm && typeof onConfirm === 'function'){
            while(popWin.erpPopupOnConfirm == undefined){
                popWin.erpPopupOnConfirm = onConfirm;    
                
            }
        }
        
        this.progressOff();
	}
	
	var option = {
			"win_id" : "openSearchOrgnTreePopup"
			,width : 400
			, height : 600
		};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openOrderCanclePopup
 * @function_Description 고객검색 (쿠폰/프로모션) 팝업
 * @param 고객검색 (쿠폰/프로모션) 팝업
 * @param 
 * @author 김동현
 */
$erp.openOrderCanclePopup = function(onComplete, onComplete2, strOrderNo, strOrderUser, strOrderDeleteMCode, parentWindow){
    
    var params = {
            "strOrderNo" : strOrderNo
            ,"strOrderUser" : strOrderUser
            ,"strOrderDeleteMCode" : strOrderDeleteMCode
    }
    var url = "/common/popup/openOrderCanclePopup.sis";
    var option = {
            "win_id" : "openOrderCanclePopup",
            "width" : 500,
            "height" :250
    }
    var onContentLoaded = function(){
        var popWin = this.getAttachedObject().contentWindow;
        
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onComplete2 && typeof onComplete2 === 'function'){
            while(popWin.erpPopupOnComplete2 == undefined){
                popWin.erpPopupOnComplete2 = onComplete2;    
                
            }
        }
        
        this.progressOff();
    }
    
    var parentWindow= window;
    $erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openOrderCouponPopup
 * @function_Description 고객검색 (쿠폰/프로모션) 팝업
 * @param 고객검색 (쿠폰/프로모션) 팝업
 * @param 
 * @author 김동현
 */
$erp.openOrderCouponPopup = function(onComplete, onComplete2, strOrderUser, parentWindow){
    
    var params = {
            "strOrderUser" : strOrderUser
    }
    var url = "/common/popup/openOrderCouponPopup.sis";
    var option = {
            "win_id" : "openOrderCouponPopup",
            "width" : 700,
            "height" :700
    }
    var onContentLoaded = function(){
        var popWin = this.getAttachedObject().contentWindow;
        
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onComplete2 && typeof onComplete2 === 'function'){
            while(popWin.erpPopupOnComplete2 == undefined){
                popWin.erpPopupOnComplete2 = onComplete2;    
                
            }
        }
        
        this.progressOff();
    }
    
    var parentWindow= window;
    $erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openOrderCouponPopup
 * @function_Description 고객검색 (쿠폰/프로모션) 팝업
 * @param 고객검색 (쿠폰/프로모션) 팝업
 * @param 
 * @author 김동현
 */
$erp.openOrderCouponPopup1 = function(onComplete, onComplete2, strOrderUser, strARTICLE_CODE, strRId, parentWindow){
    
    var params = {
            "strOrderUser" : strOrderUser
            , "strARTICLE_CODE" : strARTICLE_CODE
            , "strRId" : strRId
    }
    var url = "/common/popup/openOrderCouponPopup1.sis";
    var option = {
            "win_id" : "openOrderCouponPopup1",
            "width" : 700,
            "height" :700
    }
    var onContentLoaded = function(){
        var popWin = this.getAttachedObject().contentWindow;
        
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onComplete2 && typeof onComplete2 === 'function'){
            while(popWin.erpPopupOnComplete2 == undefined){
                popWin.erpPopupOnComplete2 = onComplete2;    
                
            }
        }
        
        this.progressOff();
    }
    
    var parentWindow= window;
    $erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openOrderCouponPopup
 * @function_Description 고객검색 (쿠폰/프로모션) 팝업
 * @param 고객검색 (쿠폰/프로모션) 팝업
 * @param 
 * @author 김동현
 */
$erp.openOrderCouponPopup2 = function(onComplete, onComplete2, strOrderUser, parentWindow){
    
    var params = {
            "strOrderUser" : strOrderUser
    }
    var url = "/common/popup/openOrderCouponPopup2.sis";
    var option = {
            "win_id" : "openOrderCouponPopup2",
            "width" : 700,
            "height" :700
    }
    var onContentLoaded = function(){
        var popWin = this.getAttachedObject().contentWindow;
        
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onComplete2 && typeof onComplete2 === 'function'){
            while(popWin.erpPopupOnComplete2 == undefined){
                popWin.erpPopupOnComplete2 = onComplete2;    
                
            }
        }
        
        this.progressOff();
    }
    
    var parentWindow= window;
    $erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function telephoneCallPopup
 * @function_Description 전화걸기 팝업
 * @param params 전화번호 리스트 
 * @param 
 * @author 조승현
 */
$erp.telephoneCallPopup = function(onComplete ,params, windowOption){

	var url = "/common/popup/telephoneCallPopup.sis";
	var option = {
			"width" : 470,
			"height" : 300
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}


/** 
 * Description 
 * @function telephoneReceivePopup
 * @function_Description 전화받기 팝업
 * @param params [CID , 채널 , 고객전화번호]
 * @param 
 * @author 조승현
 */
$erp.telephoneReceivePopup = function(onComplete ,params, windowOption){

	var url = "/common/popup/telephoneReceivePopup.sis";
	var option = {
			"width" : 600,
			"height" : 220
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}


/** 
 * Description 
 * @function telephoneRecording
 * @function_Description 녹취 팝업
 * @param params [CID , 채널 , 고객전화번호]
 * @param 
 * @author 조승현
 */
$erp.telephoneRecording = function(onComplete ,params, windowOption){

	var url = "/common/popup/telephoneRecording.sis";
	var option = {
			"width" : 1000,
			"height" : 825
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}


/** 
 * Description 
 * @function openSearchSelectPromotionPopup
 * @function_Description 상품검색 (쿠폰/프로모션) 팝업
 * @param 상품검색 (쿠폰/프로모션) 팝업
 * @param 
 * @author 양중호
 */
$erp.openSearchSelectPromotionPopup = function(onComplete, onConfirm, strOrderUser, windowOption){
	
	var params = {
			 "strOrderUser" : strOrderUser
	}                        
	var url = "/common/popup/openSearchSelectPromotionPopup.sis";
	var option = {
			 "win_id" : "openSearchSelectPromotionPopup",
			"width" : 980,
			"height" :800
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onConfirm && typeof onConfirm === 'function'){
            while(popWin.erpPopupOnConfirm == undefined){
                popWin.erpPopupOnConfirm = onConfirm;    
                
            }
        }
        
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function callChangePopup
 * @function_Description 콜 전환 팝업
 * @param  내선번호
 * @param 
 * @author 유가영
 */
$erp.callChangePopup = function(onComplete, param, windowOption){
	var url = "/common/popup/callChangePopup.sis";
	var option = {
			"width" : 605,
			"height" : 700
	}
	var parentWindow= window;
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	$erp.openPopup(url, param, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCustomerCouponPopup
 * @function_Description 고객검색 (쿠폰/프로모션) 팝업
 * @param 고객검색 (쿠폰/프로모션) 팝업
 * @param 
 * @author 양중호
 */
$erp.opensearchOutsideMallGiftPopup = function(onComplete, onConfirm, params, windowOption){
	var url = "/common/popup/openSearchOutsideMallGiftPopup.sis";
	var option = {
			"width" : 800,
			"height" :800
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        if(onConfirm && typeof onConfirm === 'function'){
            while(popWin.erpPopupOnConfirm == undefined){
                popWin.erpPopupOnConfirm = onConfirm;    
                
            }
        }
        this.progressOff();
    }
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function opensearchSpecialEditionGiftPopup
 * @function_Description 특판 제품코드관리 사은품 팝업
 * @param 특판 제품코드관리 사은품 팝업
 * @param 
 * @author 유가영
 */
$erp.openSearchSpecialEditionGiftPopup = function(onComplete, onConfirm, params, windowOption){
	var url = "/common/popup/openSearchSpecialEditionGiftPopup.sis";
	var option = {
			"width" : 800,
			"height" :800
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        if(onConfirm && typeof onConfirm === 'function'){
            while(popWin.erpPopupOnConfirm == undefined){
                popWin.erpPopupOnConfirm = onConfirm;    
                
            }
        }
        this.progressOff();
    }
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCustomerDataChangeMsg
 * @function_Description 개인정보 문자 전송
 * @param params [CID , 채널 , 고객전화번호]
 * @param 
 * @author 유가영
 */
$erp.openCustomerDataChangeMsg = function(onComplete, param, windowOption){

	var url = "/common/popup/openCustomerDataChangeMsg.do";
	var option = {
			"width" : 400,
			"height" : 300
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, param, onContentLoaded, option);
}

/** 
 * Description 
 * @function openOrderPaymentPopup
 * @function_Description 결제 팝업 열기
 * @param 
 * @author 하혜민
 */
$erp.openOrderPaymentPopup = function(onComplete, param, windowOption){
	var url = "/sis/customerpayment/openOrderPaymentPopup.sis";
	var option = {
			width : 700
			, height : 700
		};
	var parentWindow= window;
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	$erp.openPopup(url, param, onContentLoaded, option);
}

/** 
 * Description 
 * @function openOrderReceiptPopup
 * @function_Description 영수증 팝업 열기
 * @param 
 * @param onRowDblClicked (function) / Function
 * @author 유가영
 */
$erp.openOrderReceiptPopup = function(onComplete, param, windowOption) {
	var url = "/sis/customerpayment/openOrderReceiptPopup.sis";
	var option = {
			width : 650
			, height : 700
		};
	var parentWindow= window;
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	$erp.openPopup(url, param, onContentLoaded, option);
}

/** 
 * Description 
 * @function openOrderCancelPopup
 * @function_Description 결제취소 팝업 열기
 * @param 
 * @author 하혜민
 */
$erp.openOrderCancelPopup = function(onComplete, param, windowOption){
	var url = "/sis/customerpayment/openOrderCancelPopup.sis";
	var option = {
			width : 650
			, height : 860
		};
	var parentWindow= window;
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	$erp.openPopup(url, param, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchChmProductPopup
 * @function_Description 윈플러스몰 상품명 검색 팝업 열기
 * @param 상품명 상품코드
 * @author 고용선
 */
$erp.openSearchChmProductPopup = function(searchCd, searchNm, onRowDblClicked){

 	var url = "/common/popup/openSearchChmProductPopup.sis";
 	var params = {
 			  "ProductCode" : searchCd
			  ,"ProductName" : searchNm
	}
	var option = {
			"win_id" : "searchChmProductPopup",
			"width"  : 500,
			"height" : 620
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		this.progressOff();
	}
	var parentWindow = window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}
/** 
 * Description 
 * @function openSearchChmCouponPopup
 * @function_Description 윈플러스몰 쿠폰 검색 팝업 열기
 * @param 쿠폰명 쿠폰코드
 * @author 강현규
 */
$erp.openSearchChmCouponPopup = function(searchCd, searchNm, onRowDblClicked){

 	var url = "/common/popup/openSearchChmCouponPopup.sis";
 	var params = {
 			  "ICouponCode" : searchCd
			  ,"ICouponName" : searchNm
	}
	var option = {
			"win_id" : "searchChmCouponPopup",
			"width"  : 500,
			"height" : 620
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		this.progressOff();
	}
	var parentWindow = window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openSearchProductItemPopup
 * @function_Description 윈플러스몰 아이템 검색 팝업 열기
 * @param 아이템코드 아이템명
 * @author 고용선
 */
$erp.openSearchProductItemPopup = function(onRowDblClicked){

 	var url = "/common/popup/openSearchProductItemPopup.sis";

	var params = {
	}
	
	var option = {
			"win_id" : "searchProductItemPopup",
			"width"  : 500,
			"height" : 620
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		this.progressOff();
	}
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);		 
}

/** 
 * Description 
 * @function openSearchGoodsCdPopup2
 * @function_Description 상품검색 (쿠폰/프로모션) 팝업
 * @param 상품검색 (쿠폰/프로모션) 팝업
 * @param 
 * @author 김동현
 */
$erp.openSearchGoodsCdPopup2 = function(onComplete, onConfirm, windowOption){
	
	var params = {
			 
	}                        
	var url = "/common/popup/openSearchGoodsCdPopup2.sis";
	var option = {
			 "win_id" : "openSearchGoodsCdPopup2",
			 "width" : 700,
             "height" :800
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
        
        if(onConfirm && typeof onConfirm === 'function'){
            while(popWin.erpPopupOnConfirm == undefined){
                popWin.erpPopupOnConfirm = onConfirm;    
                
            }
        }
        
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openInsertImagePopup
 * @function_Description 이미지등록
 * @param param (object)
 * @param onRowDblClicked (function) / Function
 * @author 고용선
 */
$erp.openInsertImagePopup = function(param, onAfterSave,onBeforeClear,parentWindow){
	var url = "/common/popup/insertImagePopup.sis";

	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onAfterSave && typeof onAfterSave === 'function'){
			while(popWin.erpPopupOnAfterSave == undefined){
				popWin.erpPopupOnAfterSave = onAfterSave;
			}
		}
		
		if(onBeforeClear && typeof onBeforeClear === 'function'){
			while(popWin.erpPopupVaultFnOnBeforeClear == undefined){
				popWin.erpPopupVaultFnOnBeforeClear = onBeforeClear;
			}
		}
		
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		this.progressOff();
	}
	
	var option = {
			"width" : 790,
			"height" : 230			
		}
	
	$erp.openPopup(url, param, onContentLoaded, option);
}

/** 
 * Description 
 * @function openImageViewPopup
 * @function_Description 윈플러스몰 관리자 - 이미지 미리보기
 * @param param (object)
 * @param onRowDblClicked (function) / Function
 * @author 고용선
 */
$erp.openImageViewPopup = function(param, parentWindow){
	var url = "/common/popup/openChmImageViewPopup.sis";

	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		this.progressOff();
	}
	
	var option = {
			//"win_id" : "viewChmProductPopup",
			"width"  : 1200,
			"height" : 700
	}
	
	$erp.openPopup(url, param, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchSmsPopup
 * @function_Description SMS 팝업
 * @param param (object)
 * @param onRowDblClicked (function) / Function
 * @author 주병훈
 */
$erp.openSearchSmsPopup = function(onComplete ,params, windowOption){
	var url = "/common/popup/openSearchSmsPopup.sis";

	var option = {
			"width" : 1000,
			"height" : 500
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchChmEventPopup
 * @function_Description 윈플러스몰 행사 검색 팝업 열기
 * @param 행사명 행사코드
 * @author 고용선
 */
$erp.openSearchChmEventPopup = function(searchCd, searchNm, onRowDblClicked){

 	var url = "/common/popup/openSearchChmEventPopup.sis";
 	var params = {
 			  "searchCode" : searchCd
			  ,"searchName" : searchNm
	}
	var option = {
			"win_id" : "searchChmEventPopup",
			"width"  : 500,
			"height" : 620
	}
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGridOnRowDblClicked == undefined){
				popWin.erpPopupGridOnRowDblClicked = onRowDblClicked;
			}			
		}
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
		this.progressOff();
	}
	var parentWindow = window;
	$erp.openPopup(url, params, onContentLoaded, option);	 
}

/** 
 * Description 
 * @function openSearchPreCallDataPopup
 * @function_Description 이전 통화기록 팝업
 * @param param (object)
 * @param onRowDblClicked (function) / Function
 * @author 유가영
 */
$erp.openSearchPreCallDataPopup = function(onComplete ,params, windowOption){
	var url = "/common/popup/openSearchPreCallDataPopup.sis";

	var option = {
			"width" : 1000,
			"height" : 600
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCallCategoryPopup
 * @function_Description 통화 카테고리 팝업
 * @param param (object)
 * @param onComplete (function) / Function
 * @author 유가영
 */
$erp.openCallCategoryPopup = function(onComplete ,params, windowOption){
	var url = "/common/popup/openCallCategoryPopup.sis";

	var option = {
			"width" : 400,
			"height" : 600
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCustomerOrderCallDataPopup
 * @function_Description [고객주문]-통화기록 조회 팝업
 * @param [고객주문]-통화기록 조회 팝업
 * @param 
 * @author 유가영
 */
$erp.openCustomerOrderCallDataPopup = function(onComplete, CUSTOMER_CODE, windowOption){
	var params = {
			"CUSTOMER_CODE" : CUSTOMER_CODE
	}
	var url = "/common/popup/openCustomerOrderCallDataPopup.sis";
	var option = {
			"width" : 600,
			"height" :500
	}
	var parentWindow= window;
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCustomerOrderPaymentDataPopup
 * @function_Description [고객주문]-결제내역 조회 팝업
 * @param [고객주문]-결제내역 조회 팝업
 * @param 
 * @author 유가영
 */
$erp.openCustomerOrderPaymentDataPopup = function(onComplete, OCODE, windowOption){
	var params = {
			"OCODE" : OCODE
	}
	var url = "/common/popup/openCustomerOrderPaymentDataPopup.sis";
	var option = {
			"width" : 1000,
			"height" :400
	}
	var parentWindow= window;
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openDupliCustomerPopup
 * @function_Description 중복고객 리스트 팝업
 * @author 유가영
 */
$erp.openDupliCustomerPopup = function(onComplete ,params, windowOption){

	var url = "/common/popup/openDupliCustomerPopup.sis";
	var option = {
			"width" : 620,
			"height" : 500
	}
	
	var parentWindow= window;
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
                
            }
        }

		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.erpPopupParentWindow == undefined){
				popWin.erpPopupParentWindow = parentWindow;
			}
		}
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCouponTargetCustomerPopup
 * @function_Description 쿠폰 대상고객 추가 팝업
 * @author 유가영
 */
$erp.openCouponTargetCustomerPopup = function(onComplete, onConfirm, params, windowOption){
	var params = {
	}
	var url = "/common/popup/openCouponTargetCustomerPopup.sis";
	var option = {
			"width" : 1200,
			"height" :700
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onComplete && typeof onComplete === 'function'){
            while(popWin.erpPopupOnComplete == undefined){
                popWin.erpPopupOnComplete = onComplete;    
            }
        }
        
        if(onConfirm && typeof onConfirm === 'function'){
            while(popWin.erpPopupOnConfirm == undefined){
                popWin.erpPopupOnConfirm = onConfirm;    
            }
        }
        
        this.progressOff();
    }
	
	if(windowOption && typeof windowOption === 'object'){
		for(var i in windowOption){
			option[i] = windowOption[i];
	    }
	}
	
	var parentWindow= window;
	$erp.openPopup(url, params, onContentLoaded, option);
}

///////////////////////////////////윈플러스 개발 추가///////////////////////////////////

/** 
 * Description 
 * @function openGoodsCategoryTreePopup
 * @function_Description 상품분류 트리 팝업
 * @author 강신영
 */
$erp.openGoodsCategoryTreePopup = function(onClick){
	var params = {
	}
	var url = "/common/popup/openGoodsCategoryTreePopup.sis";
	var option = {
			"width" : 400
			,"height" :700
			,"resize" : false
			,"win_id" : "openGoodsCategoryTreePopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onClick && typeof onClick === 'function'){
			while(popWin.erpPopupTreeOnClick == undefined){
				popWin.erpPopupTreeOnClick = onClick;
			}
		}
		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchCutmrPopup
 * @function_Description 협력사 조회 팝업
 * @author 정혜원
 */
$erp.searchCustmrPopup = function(onRowSelect, pur_sale_type, onClickAddData) {
	if(pur_sale_type == null || pur_sale_type == undefined){
		pur_sale_type = "";
	}
	
	var params = {
			"PUR_SALE_TYPE" : pur_sale_type
	}
	var url = "/common/popup/openSearchCustmrGridPopup.sis";
	var option = {
			"width" : 580
			,"height" :700
			,"win_id" : "openSearchCustmrGridPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onRowSelect && typeof onRowSelect === 'function'){
            while(popWin.erpPopupCustmrOnRowSelect == undefined){
                popWin.erpPopupCustmrOnRowSelect = onRowSelect;    
            }
        }
        
        if(onClickAddData && typeof onClickAddData === 'function'){
        	while(popWin.erpPopupCustmrCheckList == undefined){
        		console.log("확인");
        		popWin.erpPopupCustmrCheckList = onClickAddData;
        	}
        }
        
        this.progressOff();
    }
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/**
 * Description
 * @function autoBindSearchCustmrPopup
 * @function_Description 협력사 조회 팝업(자동 바인드)
 * @author 강신영
 */
$erp.autoBindSearchCustmrPopup = function(searchParams, fnParamMap) {
	var url = "/common/popup/autoBindSearchCustmrPopup.sis";
	var option = {
			"width" : 580
			,"height" :700
			,"win_id" : "autoBindSearchCustmrPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		var fnParamKeys = fnParamMap.keys();
		var userDefinedFnKey;
		var userDefinedFnValue;
		do{
			userDefinedFnKey = fnParamKeys.next();
			userDefinedFnValue = fnParamMap.get(userDefinedFnKey.value);
			if(userDefinedFnValue && typeof userDefinedFnValue === 'function'){
				while(popWin[userDefinedFnKey.value] == undefined){
					popWin[userDefinedFnKey.value] = userDefinedFnValue;
				}
			}
		}while(!userDefinedFnKey.done);
		
		this.progressOff();
	}
	
	$erp.openPopup(url, searchParams, onContentLoaded, option);
}

/**
 * Description
 * @function openSearchGoodsPopup
 * @function_Description 상품조회 팝업
 * @author 정혜원
 */
$erp.openSearchGoodsPopup = function(onRowDblClicked, onClickAddData, paramMap) {
	
	var url = "/common/popup/openSearchGoodsGridPopup.sis";
	var option = {
			"width" : 800
			, "height" :700
			, "win_id" : "openSearchGoodsGridPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onRowDblClicked && typeof onRowDblClicked === 'function'){
            while(popWin.erpPopupGoodsOnRowSelect == undefined){
                popWin.erpPopupGoodsOnRowSelect = onRowDblClicked;    
            }
        }
        
        if(onClickAddData && typeof onClickAddData === 'function'){
        	while(popWin.erpPopupGoodsCheckList == undefined){
        		popWin.erpPopupGoodsCheckList = onClickAddData;
        	}
        }
        
        this.progressOff();
    }
	
	$erp.openPopup(url, paramMap, onContentLoaded, option);
}

/**
 * Description
 * @function autoBindSearchGoodsPopup
 * @function_Description 상품조회 팝업(자동 바인드)
 * @author 강신영
 */
$erp.autoBindSearchGoodsPopup = function(searchParams, fnParamMap) {
	var url = "/common/popup/autoBindSearchGoodsPopup.sis";
	var option = {
			"width" : 800
			,"height" :700
			,"win_id" : "autoBindSearchGoodsPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		var fnParamKeys = fnParamMap.keys();
		var userDefinedFnKey;
		var userDefinedFnValue;
		do{
			userDefinedFnKey = fnParamKeys.next();
			userDefinedFnValue = fnParamMap.get(userDefinedFnKey.value);
			if(userDefinedFnValue && typeof userDefinedFnValue === 'function'){
				while(popWin[userDefinedFnKey.value] == undefined){
					popWin[userDefinedFnKey.value] = userDefinedFnValue;
				}
			}
		}while(!userDefinedFnKey.done);
		
		this.progressOff();
	}
	
	$erp.openPopup(url, searchParams, onContentLoaded, option);
}

/** 
 * Description 
 * @function openGoodsInformationPopup
 * @function_Description 상품정보 팝업
 * @author 강신영
 */
$erp.openGoodsInformationPopup = function(paramMap){
	var url = "/common/popup/openGoodsInformationPopup.sis";
	var option = {
			"width" : 1070
			,"height" :720
			,"resize" : false
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        this.progressOff();
	}
	
	$erp.openPopup(url, paramMap, onContentLoaded, option);
}


/**
 * Description 
 * @function openMemberInfoPopup
 * @function_Description 회원정보팝업 열기
 * @author 조승현
 */
$erp.openMemberInfoPopup = function(MEM_INFO){
	var onComplete = function(){
		var openPopupWindow = erpPopupWindows.window("openMemberInfoPopup");
		if(openPopupWindow){
			openPopupWindow.close();
		}        
	}
	
	var onConfirm = function(){
		
	}
	
	var url = "/common/popup/openMemberInfoPopup.sis";
	var params = {
		"MEM_INFO" : JSON.stringify(MEM_INFO)
	}
	var option = {
			"win_id" : "openMemberInfoPopup",
			"width"  : 1200,
			"height" : 828
	}
	var parentWindow = parent;
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.thisParentWindow == undefined){
				popWin.thisParentWindow = parentWindow;
			}
		}
		if(onConfirm && typeof onConfirm === 'function'){
			while(popWin.thisOnConfirm == undefined){
				popWin.thisOnConfirm = onConfirm;    		
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


/**
 * Description 
 * @function openMemberSearchPopup
 * @function_Description 회원정보팝업 열기
 * @author 조승현
 */
$erp.openMemberSearchPopup = function(send_params,onRowDblClick, onConfirm){
	var onComplete = function(){
		var openPopupWindow = erpPopupWindows.window("openMemberSearchPopup");
		if(openPopupWindow){
			openPopupWindow.close();
		}        
	}
	
	var url = "/common/popup/openMemberSearchPopup.sis";
	var params = send_params;
	var option = {
			"win_id" : "openMemberSearchPopup",
			"width"  : 1000,
			"height" : 800
	}
	var parentWindow = parent;
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.thisParentWindow == undefined){
				popWin.thisParentWindow = parentWindow;
			}
		}
		if(onComplete && typeof onComplete === 'function'){
			while(popWin.thisOnComplete == undefined){
				popWin.thisOnComplete = onComplete;    
			}
		}
		if(onConfirm && typeof onConfirm === 'function'){
			while(popWin.thisOnConfirm == undefined){
				popWin.thisOnConfirm = onConfirm;    		
			}
		}
		if(onRowDblClick && typeof onRowDblClick === 'function'){
			while(popWin.thisOnRowDblClick == undefined){
				popWin.thisOnRowDblClick = onRowDblClick;    		
			}
		}
		this.progressOff();
	}	
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSlipLogDetailPopup
 * @function_Description 전표이력상세팝업
 * @author 정혜원
 */
$erp.openSlipLogDetailPopup = function(Slip_CD) {
	
	var onComplete = function(){
		var openPopupWindow = erpPopupWindows.window("openSlipLogDetailPopup");
		if(openPopupWindow){
			openPopupWindow.close();
		}        
	}
	
	var onConfirm = function(){
		
	}
	
	var url = "/common/popup/openSlipLogDetailPopup.sis";
	var params = {
			"Slip_CD" : Slip_CD
	}
	var option = {
			"width" : 400
			,"height" :700
	}
	
	
	var parentWindow = parent;
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(parentWindow && typeof parentWindow === 'object'){
			while(popWin.thisParentWindow == undefined){
				popWin.thisParentWindow = parentWindow;
			}
		}
		if(onConfirm && typeof onConfirm === 'function'){
			while(popWin.thisOnConfirm == undefined){
				popWin.thisOnConfirm = onConfirm;    		
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

/** 
 * Description 
 * @function openGoodsGroupGridPopup
 * @function_Description 상품집합관리팝업
 * @author 정혜원
 */
$erp.openGoodsGroupGridPopup = function(useGoodsGrup) {
	
	var url = "/common/popup/openGoodsGroupGridPopup.sis";
	var params = {};
	
	var option = {
			"width" : 1000
			, "height" :700
			, "resize" : false
			, "win_id" : "openGoodsGroupGridPopup"
	};
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(useGoodsGrup && typeof useGoodsGrup === 'function'){
            while(popWin.GoodsGroupDetailList == undefined){
                popWin.GoodsGroupDetailList = useGoodsGrup;    
            }
        }
		this.progressOff();
	};
	
	$erp.openPopup(url, params, onContentLoaded, option);
		
}


/** 
 * Description 
 * @function searchProjectPopup
 * @function_Description 프로젝트 조회 팝업
 * @author 손경락
 */
$erp.searchProjectPopup = function(onRowSelect) {
	alert('팝업함수 테스트')
	var params = {
	}
	var url = "/common/popup/openSearchProjectGridPopup.sis";
	var option = {
			"width" : 400
			,"height" :700
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onRowSelect && typeof onRowSelect === 'function'){
            while(popWin.erpPopupCustmrOnRowSelect == undefined){
                popWin.erpPopupCustmrOnRowSelect = onRowSelect;    
            }
        }
        popWin.erpPopupCustmrOnRowSelect=function(){
			alert(('그냥아무것도아님'))
		}
        this.progressOff();
    }
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openLabelPrintPopup
 * @function_Description 라벨출력팝업
 * @author 정혜원
 */
$erp.openLabelPrintPopup = function(paramMap) {
	var url = "/sis/LabelPrint/labelprintPopup.sis";
	var option = {
			"width" : 650
			, "height" :750
			, "resize" : false
			, "win_id" : "openLabelPrintPopup"
	}
	
	var onContentLoaded = function(){
		this.progressOff();
	}
	
	$erp.openPopup(url, paramMap, onContentLoaded, option);
}


/** 
 * Description 
 * @function searchMastBcodeGridPopup
 * @function_Description 바코드마스터 팝업
 * @author 손경락
 * @date  2019-08-19
 */
$erp.searchMastBcodeGridPopup = function(onRowSelect) {
	var params = {
	}
	var url = "/common/popup/openSearchMastBcodeGridPopup.sis";
	var option = {
			"width" : 600
			,"height" :700
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onRowSelect && typeof onRowSelect === 'function'){
            while(popWin.erpPopupCustmrOnRowSelect == undefined){
                popWin.erpPopupCustmrOnRowSelect = onRowSelect;    
            }
        }
        
        this.progressOff();
    }
	
	$erp.openPopup(url, params, onContentLoaded, option);
}


/** 
 * Description 
 * @function searchComEmpNoGridPopup
 * @function_Description 사원마스터 팝업
 * @author 손경락
 * @date  2019-08-19
 */
$erp.searchComEmpNoPopup = function(onRowSelect) {
	var params = {
	}
	
	var url = "/common/popup/openSearchComEmpNoGridPopup.sis";
	
	var option = {
			"width" : 500
			,"height" :700
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
        if(onRowSelect && typeof onRowSelect === 'function'){
            while(popWin.erpPopupCustmrOnRowSelect == undefined){
                popWin.erpPopupCustmrOnRowSelect = onRowSelect;    
            }
        }
        
        this.progressOff();
    }
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function excelUploadPopup
 * @function_Description 엑셀 파일 업로드 팝업 열기
 * @author 조승현
 */
$erp.excelUploadPopup = function(dhtmlXGridObject, convertModuleUrl, uploadFileLimitCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear) {
	var win_id = "excelUploadPopup";
	
	var onUploadFileDefault = function(files, gridDataList){
		if(onUploadFile && typeof onUploadFile == "function"){
			onUploadFile.call(this, files, gridDataList, dhtmlXGridObject);
		}
	}
	
	var lastUploadedFileInfoList;
	var onUploadCompleteDefault = function(uploadedFileInfoList, uploadResult){ //1.dtmlx 기본제공, 2.커스터마이징 파라미터 엑셀파일로 업로드 완료 됐을때만 얻을수 있음
		if(!uploadResult){
			lastUploadedFileInfoList = uploadedFileInfoList;
		}
		if(uploadResult){
			onUploadComplete(lastUploadedFileInfoList, dhtmlXGridObject, uploadResult);
			$erp.setDhtmlXGridFooterRowCount(dhtmlXGridObject);
			$erp.closePopup2(win_id);
		}
	}
	
	var onBeforeClearDefault = function(){
//		this.conf.files_added=0;
//		this.conf.uploaded_count=0;
		
		var returnValue;
		if(onBeforeClear && typeof onBeforeClear == "function"){
			returnValue = onBeforeClear();
		}
		
		//false시 파일추가 취소
		if(returnValue && typeof returnValue == "boolean"){
			return returnValue;
		}else{
			return true;
		}
	}
	
	var onBeforeFileAddDefault = function(file) {
		var limitCount = this.conf.files_limit;
		var addedCount = this.conf.files_added;
		if(limitCount == addedCount){
			var erpPopupWindowsCell = erpPopupWindows.window(win_id);
			var popWin = erpPopupWindowsCell.getAttachedObject().contentWindow;
			popWin.alertMessage({
				"alertMessage" : "더이상 업로드 파일을 추가 할 수 없습니다.",
				"alertCode" : "업로드 파일 개수 제한 : " + limitCount + "개",
				"alertType" : "error",
				"isAjax" : false,
			});
			return false;
		}
		
		if (file.name.toLowerCase().indexOf("xls") <= -1) {
			var erpPopupWindowsCell = erpPopupWindows.window(win_id);
			var popWin = erpPopupWindowsCell.getAttachedObject().contentWindow;
			popWin.alertMessage({
				"alertMessage": "error.common.wrongExcelUploadFileType",
				"alertCode": null,
				"alertType": "error"
			});
			this.clear();
			return false;
		}
		if (file.size / (1024 * 1024) > 50) {
			var erpPopupWindowsCell = erpPopupWindows.window(win_id);
			var popWin = erpPopupWindowsCell.getAttachedObject().contentWindow;
			popWin.alertMessage({
				"alertMessage": "error.common.wrongFileSize",
				"alertCode": null,
				"alertType": "error"
			});
			this.clear();
			return false;
		}
		
		var returnValue;
		if(onBeforeFileAdd && typeof onBeforeFileAdd == "function"){
			returnValue = onBeforeFileAdd(file);
		}
		
		//false시 클리어 취소
		if(returnValue && typeof returnValue == "boolean"){
			return returnValue;
		}else{
			return true;
		}
		
		return true;
	}
	var onContentLoaded = function() {
		var popWin = this.getAttachedObject().contentWindow;
		if (onUploadFileDefault && typeof onUploadFileDefault === 'function') {
			while (popWin.erpPopupVaultFnOnUploadFile == undefined) {
				popWin.erpPopupVaultFnOnUploadFile = onUploadFileDefault;
			}
		}
		if (onUploadCompleteDefault && typeof onUploadCompleteDefault === 'function') {
			while (popWin.erpPopupVaultFnOnUploadComplete == undefined) {
				popWin.erpPopupVaultFnOnUploadComplete = onUploadCompleteDefault;
			}
		}
		if (onBeforeFileAddDefault && typeof onBeforeFileAddDefault === 'function') {
			while (popWin.erpPopupVaultFnOnFileAdd == undefined) {
				popWin.erpPopupVaultFnOnFileAdd = onBeforeFileAddDefault;
			}
		}
		if (onBeforeClearDefault && typeof onBeforeClearDefault === 'function') {
			while (popWin.erpPopupVaultFnOnBeforeClear == undefined) {
				popWin.erpPopupVaultFnOnBeforeClear = onBeforeClearDefault;
			}
		}
		
		//서버의 컨버트 모듈 url : 따로 커스터마이징시 사용
		if (convertModuleUrl && typeof convertModuleUrl == "string") {
			while (popWin.erpPopupVaultUploadUrl == undefined) {
				popWin.erpPopupVaultUploadUrl = convertModuleUrl;
			}
		}else{
			while (popWin.erpPopupVaultUploadUrl == undefined) {
				popWin.erpPopupVaultUploadUrl = "";
			}
		}
		
		while (popWin.uploadTargetGrid == undefined) {
			popWin.uploadTargetGrid = dhtmlXGridObject;
		}
		
		if (uploadFileLimitCount && typeof uploadFileLimitCount === 'number') {
			while (popWin.uploadFileLimitCount == undefined) {
				popWin.uploadFileLimitCount = uploadFileLimitCount;
			}
		}
		
		this.progressOff();
		popWin.onLoad();
	}
	var option = {
		"width" : 515,
		"height" : 500,
		"win_id" : win_id
	};
	
	var url = "/common/popup/xlsUploadPopup.sis";
	var params = {};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openNewOrderPopup
 * @function_Description 새주문서작성 팝업
 * @author 최지민
 */
$erp.openNewOrderPopup = function(paramMap, onCloseAndSearch){
	var url = "/sis/market/sales/openNewOrderPopup.sis";
	var option = {
			"width" : 850
			,"height" :766
			,"resize" : false
			,"win_id" : "openNewOrderPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
		if(onCloseAndSearch && typeof onCloseAndSearch === 'function'){
			while(popWin.popOnCloseAndSearch == undefined){
				popWin.popOnCloseAndSearch = onCloseAndSearch;
			}
		}
		
		this.progressOff();
	}
	
	$erp.openPopup(url, paramMap, onContentLoaded, option);
}

/** 
 * Description 
 * @function openAddNewBargainGroupPopup
 * @function_Description 특매그룹추가 팝업
 * @author 최지민
 */
$erp.openAddNewBargainGroupPopup = function(onClickAddData){
	var params = {
		
	}
	var url = "/common/popup/openAddNewBargainGroupPopup.sis";
	var option = {
			"width" : 400
			,"height" : 360
			,"resize" : false
			,"win_id" : "openAddNewBargainGroupPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;

		if(onClickAddData && typeof onClickAddData === 'function'){
			while(popWin.erpPopupGrupCheckList == undefined){
				popWin.erpPopupGrupCheckList = onClickAddData;
			}
		}

		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openBargainGroupPointPopup
 * @function_Description 특매그룹선택 팝업
 * @author 최지민
 */
$erp.openBargainGroupPointPopup = function(onRowDblClicked) {
	var params = {
	}
	var url = "/common/popup/openBargainGroupPointPopup.sis";
	var option = {
			"width" : 550
			,"height" :450
			,"resize" : false
			,"win_id" : "openBargainGroupPointPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGroupOnRowSelect == undefined){
				popWin.erpPopupGroupOnRowSelect = onRowDblClicked;
			}
		}
		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description
 * @function openPosManagerInfoPopup
 * @function_Description 단말 담당자 마감정보
 * @author 최지민
 */
$erp.openPosManagerInfoPopup = function(CLSE_INFO, onClickClose){
	var params = {
		"CLSE_INFO" : JSON.stringify(CLSE_INFO)
	}
	var url = "/common/popup/openPosManagerInfoPopup.sis";
	var option = {
			"width" : 800
			,"height" :735
			,"resize" : false
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
		if(onClickClose && typeof onClickClose === 'function'){
			while(popWin.erpPopupClose == undefined){
				popWin.erpPopupClose = onClickClose;
			}
		}
		this.progressOff();
	}
	$erp.openPopup(url, params, onContentLoaded, option);
}

/**
 * Description 
 * @function openAddDepositCashPopup
 * @function_Description 현금 지금액 입력
 * @author 최지민
 */
$erp.openAddDepositCashPopup = function(onClickAddData, CLSE_CD, ORGN_CD){
	var params = {
			"CLSE_CD" : CLSE_CD
			,"ORGN_CD" : ORGN_CD
	}
	var url = "/common/popup/openAddDepositCashPopup.sis";
	var option = {
			"width" : 330
			,"height" : 435
			,"resize" : false
			,"win_id" : "openAddDepositCashPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;

		if(onClickAddData && typeof onClickAddData === 'function'){
			while(popWin.erpPopupCheckList == undefined){
				popWin.erpPopupCheckList = onClickAddData;
			}
		}
		
		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description
 * @function openSelectEmpPopup
 * @function_Description 직원선택 팝업
 * @author 최지민
 */
$erp.openSelectEmpPopup = function(onRowDblClicked) {
	var params = {
	}
	var url = "/common/popup/openSelectEmpPopup.sis";
	var option = {
			"width" : 350
			,"height" :500
			,"resize" : false
			,"win_id" : "openSelectEmpPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGroupOnRowSelect == undefined){
				popWin.erpPopupGroupOnRowSelect = onRowDblClicked;
			}
		}
		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description
 * @function openStockInspListPopup
 * @function_Description 재고실사관리 상세목록 팝업
 * @author 최지민
 */
$erp.openStockInspListPopup = function(ORGN_CD, SEARCH_FROM_DATE, STORE_AREA){
	var params = {
			"ORGN_CD" : ORGN_CD
			, "SEARCH_FROM_DATE" : SEARCH_FROM_DATE
			, "STORE_AREA" : STORE_AREA
	}
	var url = "/common/popup/openStockInspListPopup.sis";
	var option = {
			"width" : 650
			,"height" :600
			,"resize" : false
			,"win_id" : "openStockInspListPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description
 * @function openPlusFriendTalkPopup
 * @function_Description 플러스친구톡보내기
 * @author 최지민
 */
$erp.openPlusFriendTalkPopup = function(paramMap){
	
	var onComplete = function(){
		var openPopupWindow = erpPopupWindows.window("openPlusFriendTalkPopup");
		if(openPopupWindow){
			openPopupWindow.close();
		}
	}
	
	var params = {
	}
	var url = "/common/popup/openPlusFriendTalkPopup.sis";
	var option = {
			"width" : 930
			,"height" :650
			,"resize" : false
			,"win_id" : "openPlusFriendTalkPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
		if(onComplete && typeof onComplete === 'function'){
			while(popWin.thisOnComplete == undefined){
				popWin.thisOnComplete = onComplete;
			}
		}
		
		popWin.parentGrid = paramMap;
		this.progressOff();
	}
	
	
	$erp.openPopup(url, {}, onContentLoaded, option);
}

/** 
 * Description
 * @function openSearchMemberPopup
 * @function_Description  회원검색 팝업
 * @author 최지민
 */
$erp.openSearchMemberPopup = function(onClickAddData) {
	var params = {
	}
	var url = "/common/popup/openSearchMemberPopup.sis";
	var option = {
			"width" : 450
			,"height" :600
			,"resize" : false
			,"win_id" : "openSearchMemberPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
		if(onClickAddData && typeof onClickAddData === 'function'){
			while(popWin.erpPopupCheckList == undefined){
				popWin.erpPopupCheckList = onClickAddData;
			}
		}
		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openSearchMemberGridPopup
 * @function_Description  회원조회 팝업
 * @author 정혜원
 */
$erp.openSearchMemberGridPopup = function(onRowDblClicked, onClickAddData, paramMap) {
	
	var url = "/common/popup/openSearchMemberGridPopup.sis";
	var option = {
			"width" : 600
			,"height" :400
			,"resize" : false
			,"win_id" : "openSearchMemberGridPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
        if(onRowDblClicked && typeof onRowDblClicked === 'function'){
            while(popWin.erpPopupMemberOnRowSelect == undefined){
                popWin.erpPopupMemberOnRowSelect = onRowDblClicked;    
            }
        }
        
        if(onClickAddData && typeof onClickAddData === 'function'){
            while(popWin.erpPopupMemberCheckList == undefined){
                popWin.erpPopupMemberCheckList = onClickAddData;    
            }
        }
        
        this.progressOff();
    }
	
	$erp.openPopup(url, paramMap, onContentLoaded, option);
}

/** 
 * Description 
 * @function openAttachFilesUploadPopup
 * @function_Description 게시물 첨부파일 업로드 팝업
 * @param paramMap (object) 파라미터들
 * @param uploadFileLimitCount (int) 첨부파일 제한 수
 * @param existAttachFileCount (int) 현재 첨부되어있는 파일 수
 * @param onUploadFile (function) 업로드 완료시 콜백
 * @param onUploadComplete (function) 업로드 관련 로직 모두 수행후 콜백
 * @param onBeforeFileAdd (function) 파일 추가 전 콜백
 * @param onBeforeClear (function) 초기화 전 콜백
 * @author 조승현
 */
$erp.openAttachFilesUploadPopup = function(paramMap, uploadFileLimitCount, existAttachFileCount, onUploadFile, onUploadComplete, onBeforeFileAdd, onBeforeClear) {
	var win_id = "openAttachFilesUploadPopup";
	
	var lastServerReturnData = null;
	var onUploadFileDefault = function(files, serverReturnData){
		if(onUploadFile && typeof onUploadFile == "function"){
			lastServerReturnData = serverReturnData;
			onUploadFile.call(this, files, serverReturnData);
		}
	}
	
	var uploadReqeustFileCount;
	var onUploadCompleteDefault = function(uploadedFileInfoList){
		uploadReqeustFileCount = uploadedFileInfoList.length;
		onUploadComplete(uploadedFileInfoList, lastServerReturnData);
		$erp.closePopup2(win_id);
	}
	
	var onBeforeClearDefault = function(){
//		this.conf.files_added=0;
//		this.conf.uploaded_count=0;
		
		var returnValue;
		if(onBeforeClear && typeof onBeforeClear == "function"){
			returnValue = onBeforeClear();
		}
		
		//false시 클리어 취소
		if(returnValue && typeof returnValue == "boolean"){
			return returnValue;
		}else{
			return true;
		}
	}
	
	
	var alertShowing = false;
	var alertShowingCount = 0;
	var showAlert_UploadLimitCountOver = false; 		//첨부파일 업로드 개수 초과시 true
	
	var showAlert_UploadImpossibleFileFormat = false;	//첨부 불가능한 파일 확장자 업로드시 true
//	var showAlert_UploadImpossibleFileNameList = [];	//첨부 불가능한 파일명 리스트
	
	var showAlert_UploadfFileSizeOver = false;			//첨부 파일 사이즈 오버시 true
	
	var alertVariableReset = function(){ 				//alert 관련 변수 리셋용
		alertShowingCount--;
		if(alertShowingCount == 0){ //리셋
			alertShowing = false;
			showAlert_UploadLimitCountOver = false; 		//첨부파일 업로드 개수 초과시 true
			showAlert_UploadImpossibleFileFormat = false;	//첨부 불가능한 파일 확장자 업로드시 true
			showAlert_UploadfFileSizeOver = false;			//첨부 파일 사이즈 오버시 true
		}
	}
	
	var onBeforeFileAddDefault = function(file) {
		var isError = false; 								//한번이라도 파일이 추가되면 안되는 상황이 발생시 true
		
		var limitCount = this.conf.files_limit;				//파일 추가 제한 수
		var addedCount = this.conf.files_added;				//파라미터로 넘어온 이파일이 추가되기전 현재까지 팝업창에 추가되어있는 파일수
		
		var erpPopupWindowsCell = erpPopupWindows.window(win_id);
		var popWin = erpPopupWindowsCell.getAttachedObject().contentWindow;
		
		if(limitCount <= existAttachFileCount + addedCount){
			showAlert_UploadLimitCountOver = true;
			isError = true;
		}
		
		if (file.name.toLowerCase().indexOf(".zip") <= -1
			&& file.name.toLowerCase().indexOf(".jpg") <= -1
			&& file.name.toLowerCase().indexOf(".jpeg") <= -1
			&& file.name.toLowerCase().indexOf(".bmp") <= -1
			&& file.name.toLowerCase().indexOf(".gif") <= -1
			&& file.name.toLowerCase().indexOf(".png") <= -1
			&& file.name.toLowerCase().indexOf(".xls") <= -1
			&& file.name.toLowerCase().indexOf(".xlsx") <= -1) {
			
//			showAlert_UploadImpossibleFileNameList.push(file.name);
			showAlert_UploadImpossibleFileFormat = true;
			isError = true;
		}
		
//		console.log("파일사이즈 : " + file.size);
//		console.log("파일사이즈 나누기 : " + file.size / (1024 * 1024));
		if (file.size / (1024 * 1024) > 50) { //50MB 제한
			showAlert_UploadfFileSizeOver = true;
			isError = true;
		}
		
		
		if(showAlert_UploadLimitCountOver && alertShowing == false){
			alertShowing = true;
			alertShowingCount++;
			popWin.alertMessage({
				"alertMessage" : "더이상 업로드 파일을 추가 할 수 없습니다.",
				"alertCode" : "업로드 파일 개수 제한 : " + limitCount + "개",
				"alertType" : "error",
				"isAjax" : false,
				"alertCallbackFn" : alertVariableReset
			});
		}else if(showAlert_UploadImpossibleFileFormat){
			alertShowingCount++;
			popWin.alertMessage({
				"alertMessage": "첨부 할 수 없는 파일<br/>" + file.name + "<br/>가능한타입",
				"alertCode": ".zip, .jpg, .jpeg, .bmp, .gif, .png, .xls, .xlsx",
				"alertType": "error",
				"isAjax" : false,
				"alertCallbackFn" : alertVariableReset
			});
		}else if(showAlert_UploadfFileSizeOver){
			alertShowingCount++;
			popWin.alertMessage({
				"alertMessage": "첨부 파일 최대크기(50MB)를 초과 하였습니다.",
				"alertCode": file.name,
				"alertType": "error",
				"isAjax" : false,
				"alertCallbackFn" : alertVariableReset
			});
		}
		
		if(isError){
			return false;
		}
		
		var returnValue;
		if(onBeforeFileAdd && typeof onBeforeFileAdd == "function"){
			returnValue = onBeforeFileAdd(file);
		}
		
		if(returnValue === false){ // 추가 콜백으로 검사하여 얻은 리턴값이 false면 파일 추가 취소
			return false;
		}
		
		return true;
		
	}
	var onContentLoaded = function() {
		var popWin = this.getAttachedObject().contentWindow;
		if (onUploadFileDefault && typeof onUploadFileDefault === 'function') {
			while (popWin.onUploadFileDefault == undefined) {
				popWin.onUploadFileDefault = onUploadFileDefault;
			}
		}
		if (onUploadCompleteDefault && typeof onUploadCompleteDefault === 'function') {
			while (popWin.onUploadCompleteDefault == undefined) {
				popWin.onUploadCompleteDefault = onUploadCompleteDefault;
			}
		}
		if (onBeforeFileAddDefault && typeof onBeforeFileAddDefault === 'function') {
			while (popWin.onBeforeFileAddDefault == undefined) {
				popWin.onBeforeFileAddDefault = onBeforeFileAddDefault;
			}
		}
		if (onBeforeClearDefault && typeof onBeforeClearDefault === 'function') {
			while (popWin.onBeforeClearDefault == undefined) {
				popWin.onBeforeClearDefault = onBeforeClearDefault;
			}
		}
		
		if (uploadFileLimitCount && typeof uploadFileLimitCount === 'number') {
			while (popWin.uploadFileLimitCount == undefined) {
				popWin.uploadFileLimitCount = uploadFileLimitCount;
			}
		}
		
		if (paramMap != undefined && paramMap != null) {
			while (popWin.paramMap == undefined) {
				popWin.paramMap = paramMap;
			}
		}
		
		this.progressOff();
		popWin.onLoad();
	}
	var option = {
		"width" : 515,
		"height" : 500,
		"win_id" : win_id
	};
	
	var url = "/common/popup/openAttachFilesUploadPopup.sis";
	var params = {};
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openAddGoodsGrupPopup
 * @function_Description  상품리스트 우클릭 상품그룹추가 팝업
 * @author 정혜원
 */
$erp.openAddGoodsGrupPopup = function(paramMap) {
	var url = "/common/popup/openAddGoodsGrupPopup.sis";
	var option = {
			"width" : 560
			,"height" :170
			,"resize" : true
			,"win_id" : "openAddGoodsGrupPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
		this.progressOff();
	}
	
	$erp.openPopup(url, paramMap, onContentLoaded, option);
}

/** 
 * Description 
 * @function openCustmrInfoLogPopup
 * @function_Description 거래처정보 로그 팝업
 * @author 조승현
 */
$erp.openCustmrInfoLogPopup = function(paramMap) {
	var url = "/common/popup/openCustmrInfoLogPopup.sis";
	var option = {
			"width" : 1300
			,"height" :700
			,"resize" : false
			,"win_id" : "openCustmrInfoLogPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		
		this.progressOff();
	}
	
	$erp.openPopup(url, paramMap, onContentLoaded, option);
}

/**
 * Description 
 * @function openNewBundleGroupPopup
 * @function_Description 이종상품그룹추가 팝업
 * @author 최지민
 */
$erp.openNewBundleGroupPopup = function(onClickAddData){
	var params = {
	}
	var url = "/common/popup/openNewBundleGroupPopup.sis";
	var option = {
			"width" : 500
			,"height" :340
			,"resize" : false
			,"win_id" : "openNewBundleGroupPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onClickAddData && typeof onClickAddData === 'function'){
			while(popWin.erpPopupGrupCheckList == undefined){
				popWin.erpPopupGrupCheckList = onClickAddData;
			}
		}
		this.progressOff();
	}
	$erp.openPopup(url, params, onContentLoaded, option);
}

/**
 * Description 
 * @function openNewBundleGroupPopup
 * @function_Description 이종상품그룹수정 팝업
 * @author 최지민
 */
$erp.openRetouchBundlePopup = function(paramMap){
	var params = {
	}
	var url = "/common/popup/openRetouchBundlePopup.sis";
	var option = {
			"width" : 500
			,"height" :340
			,"resize" : false
			,"win_id" : "openRetouchBundlePopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		this.progressOff();
	}
	$erp.openPopup(url, paramMap, onContentLoaded, option);
}

/**
 * Description 
 * @function openDoubleGroupPointPopup
 * @function_Description 이종상품그룹선택 팝업
 * @author 최지민
 */
$erp.openDoubleGroupPointPopup = function(onRowDblClicked, ORGN_CD) {
	var params = {
			"ORGN_CD" : ORGN_CD
	}
	var url = "/common/popup/openDoubleGroupPointPopup.sis";
	var option = {
			"width" : 550
			,"height" : 450
			,"resize" : false
			,"win_id" : "openDoubleGroupPointPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onRowDblClicked && typeof onRowDblClicked === 'function'){
			while(popWin.erpPopupGroupOnRowSelect == undefined){
				popWin.erpPopupGroupOnRowSelect = onRowDblClicked;
			}
		}
		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/** 
 * Description 
 * @function openAddNewLoan
 * @function_Description 신규여신추가팝업
 * @param (Map<String, Object>) - "popupType"   : "add" (이미등록된 회원/거래처 등록) , "new" (신규회원/거래처 등록)
 * @param                       - "loanType"    : "C" (거래처) , "M" (회원) popupType이 add인 경우에만 사용
 * @param                       - "ORGN_DIV_CD" : popupType이 "add" 이고, loanType이 "M" 인경우에만 사용(특정 점포고객만 보고싶을때)
 * @param                       - "ORGN_CD"     : popupType이 "add" 이고, loanType이 "M" 인경우에만 사용(특정 점포고객만 보고싶을때)
 * @author 정혜원
 */
$erp.openAddNewLoanPopup = function(paramMap, onNewSaveData) {
	var params = paramMap;
	var url = "/sis/price/openAddNewLoanPopup.sis";
	var option = {
			"width" : 700
			, "height" :600
			, "win_id" : "openAddNewLoanPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onNewSaveData && typeof onNewSaveData === 'function'){
			while(popWin.erpPopupNewSaveLoanData == undefined){
				popWin.erpPopupNewSaveLoanData = onNewSaveData;
			}
		}
		this.progressOff();
    }
	$erp.openPopup(url, params, onContentLoaded, option);
}

/**
 * Description 
 * @function openTrustSalesPopup
 * @function_Description 외상결제입력 팝업
 * @author 최지민
 */
$erp.openTrustSalesPopup = function(onClickAddData, UNIQUE_MEM_NM, OBJ_CD, LOAN_CD) {
	var params = {
		"UNIQUE_MEM_NM" : UNIQUE_MEM_NM
		, "OBJ_CD" : OBJ_CD
		, "LOAN_CD" : LOAN_CD
	}
	var url = "/common/popup/openTrustSalesPopup.sis";
	var option = {
			"width" : 500
			,"height" :370
			,"resize" : false
			,"win_id" : "openTrustSalesPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onClickAddData && typeof onClickAddData === 'function'){
			while(popWin.erpPopupGrupCheckList == undefined){
				popWin.erpPopupGrupCheckList = onClickAddData;
			}
		}
		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/**
 * Description 
 * @function openAddTrustSalesPopup
 * @function_Description 외상매출 팝업
 * @author 최지민
 */
$erp.openAddTrustSalesPopup = function(onClickAddData, onClickDelData, paramMap) {
	var params = paramMap;
	var url = "/common/popup/openAddTrustSalesPopup.sis";
	var option = {
			"width" : 500
			,"height" :370
			,"resize" : false
			,"win_id" : "openAddTrustSalesPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onClickAddData && typeof onClickAddData === 'function'){
			while(popWin.erpPopupGrupCheckList == undefined){
				popWin.erpPopupGrupCheckList = onClickAddData;
			}
		}
		
		if(onClickDelData && typeof onClickDelData === 'function'){
			while(popWin.erpPopupGrupList == undefined){
				popWin.erpPopupGrupList = onClickDelData;
			}
		}
		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}

/**
 * Description 
 * @function openPdaLabelGridPopup
 * @function_Description PDA라벨내역팝업
 * @author 정혜원
 */
$erp.openPdaLabelGridPopup = function(paramMap, onClickApplyData) {
	console.log("paramMap >> " + paramMap);
	var params = paramMap;
	var url = "/sis/LabelPrint/openPdaLabelGridPopup.sis";
	var option = {
			"width" : 950
			,"height" :700
			,"resize" : false
			,"win_id" : "openPdaLabelGridPopup"
	}
	
	var onContentLoaded = function(){
		var popWin = this.getAttachedObject().contentWindow;
		if(onClickApplyData && typeof onClickApplyData === 'function'){
			while(popWin.erpPopupGoodsCheckList == undefined){
				popWin.erpPopupGoodsCheckList = onClickApplyData;
			}
		}
		this.progressOff();
	}
	
	$erp.openPopup(url, params, onContentLoaded, option);
}