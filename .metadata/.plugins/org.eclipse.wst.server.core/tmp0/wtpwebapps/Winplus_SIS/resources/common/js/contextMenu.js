
/** 
 * Description 마우스 오른쪽 클릭 컨텍스트 메뉴 사용을 위한 등록
 * @since 2019.08.07
 * @author 조승현
 */

var contextMenu = function () {
	
	/** 
	* Description 
	* @function useGridRightClick
	* @function_Description 그리드 오른쪽 클릭 사용
	* @param dhtmlxGridObj (object) dhtmlx 그리드 객체
	* @param items (list) 아이템 객체 리스트
	* @param onRightClick (function) 오른쪽 클릭 콜백 
	* @author 조승현
	*/
	this.useGridRightClick = function(dhtmlxGridObj, items, onRightClick){
		//그리드 오른쪽 클릭 사용
		var contextMenuObj = new dhtmlXMenuObject({
			parent : dhtmlxGridObj.entBox.id,
			context: true,
			items: items
		});
		
		contextMenuObj.attachEvent("onClick", onRightClick); // onRightClick : 파라미터 3가지  clickItemId, zonedId, cas(ctrl,alt,shift 키 입력 여부 object 형식)
		
		dhtmlxGridObj.enableContextMenu(contextMenuObj);
		
		return contextMenuObj;
	}
	
	
	/** 
	* Description 
	* @function singleSelectValidate
	* @function_Description 단일 선택만 가능 할 때 유효성 체크
	* @param dhtmlxGridObj (object) dhtmlx 그리드 객체
	* @param columnIdList (list) 값이 있는지 확인해야할 컬럼 id 리스트
	* @author 조승현
	*/
	this.singleSelectValidate = function(dhtmlxGridObj, columnIdList){ //1.그리드 객체, 2.값이 있는지 검사해야 하는 컬럼 리스트
		var selectedRowsData = $erp.dataSerializeOfGridByMode(dhtmlxGridObj, "selected");
		
		if(selectedRowsData && selectedRowsData.length>0){
			if(selectedRowsData.length > 1){
				$erp.alertMessage({
					"alertMessage" : "하나의 행만 선택해 주세요.",
					"alertType" : "error",
					"isAjax" : false,
				});
				
				return null;
				
			}else if(selectedRowsData.length == 1){
				var columnId;
				var emptyValueColumnIdList = [];
				for(var i in columnIdList){
					columnId = columnIdList[i];
					if(!selectedRowsData[0][columnId]){
						emptyValueColumnIdList.push(columnId);
					}
				}
				
				var alertCode = "";
				for(var i in emptyValueColumnIdList){
					alertCode += emptyValueColumnIdList[i] + "(" + dhtmlxGridObj.getColLabel(dhtmlxGridObj.getColIndexById(emptyValueColumnIdList[i])) + ")<br>";
				}
				
				//마지막 엔터제거
				alertCode = alertCode.substr(0, alertCode.length - 4);
				
				if(emptyValueColumnIdList.length > 0){
					$erp.alertMessage({
						"alertMessage" : "선택된 행에 정보가 존재하지 않습니다.",
						"alertCode" : alertCode,
						"alertType" : "error",
						"isAjax" : false,
					});
					return null;
				}else{
					return selectedRowsData;
				}
			}
		}else{
			$erp.alertMessage({
				"alertMessage" : "그리드에 선택된 행이 없습니다.",
				"alertType" : "error",
				"isAjax" : false,
			});
			
			return null;
			
		}
		
	}
	
	
	/** 
	* Description 
	* @function singleSelectValidate
	* @function_Description 다중 선택 가능 할 때 유효성 체크
	* @param dhtmlxGridObj (object) dhtmlx 그리드 객체
	* @param columnIdList (list) 값이 있는지 확인해야할 컬럼 id 리스트
	* @author 조승현
	*/
	this.multiSelectValidate = function(dhtmlxGridObj, columnIdList){ //1.그리드 객체, 2.값이 있는지 검사해야 하는 컬럼 리스트
		var selectedRowsData = $erp.dataSerializeOfGridByMode(dhtmlxGridObj, "selected");
		
		if(selectedRowsData && selectedRowsData.length>0){
			var columnId;
			var emptyValueColumnIdList = {};
			for(var i in columnIdList){
				columnId = columnIdList[i];
				if(!selectedRowsData[0][columnId]){
					emptyValueColumnIdList[columnId] = "없음";
				}
			}
			
			var alertCode = "";
			for(var key in emptyValueColumnIdList){
				alertCode += key + "(" + dhtmlxGridObj.getColLabel(dhtmlxGridObj.getColIndexById(key)) + ")<br>";
			}
			
			//마지막 엔터제거
			alertCode = alertCode.substr(0, alertCode.length - 4);
			
			if(emptyValueColumnIdList.length > 0){
				$erp.alertMessage({
					"alertMessage" : "선택된 행에 정보가 존재하지 않습니다.",
					"alertCode" : alertCode,
					"alertType" : "error",
					"isAjax" : false,
				});
				return null;
			}else{
				return selectedRowsData;
			}
			
		}else{
			$erp.alertMessage({
				"alertMessage" : "그리드에 선택된 행이 없습니다.",
				"alertType" : "error",
				"isAjax" : false,
			});
			
			return null;
			
		}
	}
	
	
	/** 
	* Description 
	* @function menuDisable
	* @function_Description 메뉴 비활성화 처리
	* @param contextMenuObj (object) dhtmlx 메뉴 객체
	* @param disableMenuIdList (list) disable 처리해야할 메뉴 id 리스트
	* @author 조승현
	*/
	this.menuDisable = function(contextMenuObj, disableMenuIdList){
		for(var i in disableMenuIdList){
			contextMenuObj.setItemDisabled(disableMenuIdList[i]);
		}
	}
	
	
	/** 
	* Description 
	* @function menuDisable
	* @function_Description 메뉴 비활성화 처리
	* @param contextMenuObj (object) dhtmlx 메뉴 객체
	* @param disableMenuIdList (list) disable 처리해야할 메뉴 id 리스트
	* @author 조승현
	*/
	this.createMenuItemsAsCommonCode = function(contextMenuObj, parentId, cmmn_cd, useYN){
		
		var divParamMap = {};
		var div1;
		var div2;
		var div3;
		var div4;
		var div5;
		if(!$erp.isEmpty(cmmn_cd)){
			if(typeof cmmn_cd === 'object' && $erp.isArray(cmmn_cd)){
				div1 = cmmn_cd[1];
				div2 = cmmn_cd[2];
				div3 = cmmn_cd[3];
				div4 = cmmn_cd[4];
				div5 = cmmn_cd[5];
				cmmn_cd = cmmn_cd[0];
			} else if(typeof cmmn_cd === 'object' && !$erp.isArray(cmmn_cd)){
				div1 = cmmn_cd['div1'];
				div2 = cmmn_cd['div2'];
				div3 = cmmn_cd['div3'];
				div4 = cmmn_cd['div4'];
				div5 = cmmn_cd['div5'];
				cmmn_cd = cmmn_cd['commonCode'];
			}       
		} else {
			return;
		}
		
		if(useYN == undefined || useYN == null){
			useYN = "Y";
		}
		
		$.ajax({
			url : "/common/system/code/getDetailCommonCodeList.do"
			,data : {
				'CMMN_CD' : cmmn_cd
				,'DIV1' : div1
				,'DIV2' : div2
				,'DIV3' : div3
				,'DIV4' : div4
				,'DIV5' : div5
				,'USE_YN' : useYN
			}
			,method : "POST"
			,dataType : "JSON"
			,success : function(data){
				if(data.isError){
					$erp.ajaxErrorMessage(data);
				} else {            
					var detailCommonCodeList = data.detailCommonCodeList;
					
					var detailCommonCodeObj;
					var childId;
					var value;
					var position = 1;
					for(var i in detailCommonCodeList){
						detailCommonCodeObj = detailCommonCodeList[i];
						for(var key in detailCommonCodeObj){
							if(key == 'CMMN_DETAIL_CD'){
								childId = cmmn_cd + "_____" + detailCommonCodeObj[key];
							} else if(key == 'CMMN_DETAIL_CD_NM'){ //CMMN_DETAIL_CD_NM(코드보임), CMMN_DETAIL_NM(코드보이지않음)
								value = detailCommonCodeObj[key];
							}
						}
						contextMenuObj.addNewChild(parentId, position, childId, value);
//						console.log("하위 메뉴 생성 : " + childId);
						position++;
					}
					
				}
			}, error : function(jqXHR, textStatus, errorThrown){
				$erp.ajaxErrorHandler(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	
	/** 
	* Description 
	* @function saveSuccess
	* @function_Description 저장 실패 메세지
	* @author 조승현
	*/
	this.saveSuccess = function(){
		$erp.alertMessage({
			"alertMessage" : "저장 성공",
			"alertType" : "alert",
			"isAjax" : false,
		});
	}
	
	
	/** 
	* Description 
	* @function saveFail
	* @function_Description 저장 실패 메세지
	* @author 조승현
	*/
	this.saveFail = function(){
		$erp.alertMessage({
			"alertMessage" : "저장 실패",
			"alertType" : "alert",
			"isAjax" : false,
		});
	}
	
	
	/** 
	* Description 
	* @function comingSoon
	* @function_Description 준비중 메세지
	* @author 조승현
	*/
	this.comingSoon = function(){
		$erp.alertMessage({
			"alertMessage" : "준비중입니다.",
			"alertType" : "alert",
			"isAjax" : false,
		});
	}
	
	
	/** 
	* Description 
	* @function sisUserGridRightClick
	* @function_Description 그리드 우클릭 회원 관련 메뉴
	* @param dhtmlxGridObj (object) dhtmlx 그리드 객체
	* @author 조승현
	*/
	this.sisUserGridRightClick = function(dhtmlxGridObj){

		var items = [
			{id: "notificationTalk", 			text: "알림톡 발송"},
			{type: "separator"},
			{id: "checkSMS_STATE", 				text: "수신거부요청확인"},
			{type: "separator"},
			{id: "printLABEL", 					text: "라벨 출력"},
			{type: "separator"},
			{id: "changeMEM_TYPE", 				text: "회원 유형 일괄 변경"},
			{id: "changeMEM_ABC", 				text: "회원 ABC분류 일괄변경"},
			{id: "changeMEM_COUPON", 			text: "회원 쿠폰 일괄등록"},
			{id: "changeMEM_SURVEY", 			text: "회원 설문광고 일괄등록"},
			{id: "changeMEM_GROUP", 			text: "회원 그룹에 추가"},
			{id: "changeMEM_STATE", 			text: "회원 상태 일괄변경"},
			{id: "changeTAX_YN", 				text: "회원 계산서 일괄발행 변경"},
			{id: "changeCHG_AMT_TYPE", 			text: "회원 소액처리 일괄 변경"},
			{id: "changePRICE_POLI", 			text: "회원 도매등급 일괄 변경"},
			{type: "separator"},
			{id: "execTAX", 					text: "회원 계산서 발행"},
			{id: "searchAPPR_TRADE", 			text: "회원 승인거래내역 조회"},
			{id: "searchTAX", 					text: "회원 과면세금액조회"}
		];
		
		var onRightClick = function(id, zoneId, cas){
			var selectedRowsData;
			
			var prefixId = id.split("_____")[0];
			var value = id.split("_____")[1];
			
			console.log("id : " + id);
			console.log("prefixId : " + prefixId);
			console.log("value : " + value);
			
			if(prefixId == "notificationTalk"){
				//---------------------------------------------------------------------알림톡 개발후 추가예정
				$cm.comingSoon();
			}else if(prefixId == "checkSMS_STATE"){
				//---------------------------------------------------------------------TBD
				$cm.comingSoon();
			}else if(prefixId == "printLABEL"){
				//---------------------------------------------------------------------정혜원주임님 라벨 출력 팝업창 개발후 추가예정
				$cm.comingSoon();
			}else if(prefixId == "changeMEM_TYPE"){
				//로직없음 하위 메뉴 콜백 사용
			}else if(prefixId == "changeMEM_ABC"){
				//로직없음 하위 메뉴 콜백 사용
			}else if(prefixId == "changeMEM_COUPON"){
				$cm.comingSoon();
			}else if(prefixId == "changeMEM_SURVEY"){ // 설문광고
				$cm.comingSoon();
			}else if(prefixId == "changeMEM_GROUP"){
				
			}else if(prefixId == "changeMEM_STATE"){
				//로직없음 하위 메뉴 콜백 사용
			}else if(prefixId == "changeTAX_YN"){
				//로직없음 하위 메뉴 콜백 사용
			}else if(prefixId == "changeCHG_AMT_TYPE"){
				//로직없음 하위 메뉴 콜백 사용
			}else if(prefixId == "changePRICE_POLI"){
				//로직없음 하위 메뉴 콜백 사용
			}else if(prefixId == "execTAX"){			//세금계산서 발행
				$cm.comingSoon();
			}else if(prefixId == "searchAPPR_TRADE"){	//승인거래 조회
				$cm.comingSoon();
			}else if(prefixId == "searchTAX"){			//과면세금액조회
				$cm.comingSoon();
			}else if(prefixId == "MEM_TYPE"){			//회원유형
				
				selectedRowsData = $cm.multiSelectValidate(dhtmlxGridObj,["MEM_NO"]);
				if(selectedRowsData){
					selectedRowsData = $erp.putKeyAndValueToListMap(selectedRowsData, "update" + prefixId, value);
					
					var url = "/sis/member/updateMemberType.do";
					var send_data = selectedRowsData;
					var if_success = function(data){
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else{
							$cm.saveSuccess();
						}
					}
					
					var if_error = function(){}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
					
				}
				
			}else if(prefixId == "MEM_ABC"){			//회원ABC
				
				selectedRowsData = $cm.multiSelectValidate(dhtmlxGridObj,["MEM_NO"]);
				if(selectedRowsData){
					selectedRowsData = $erp.putKeyAndValueToListMap(selectedRowsData, "update" + prefixId, value);
					
					var url = "/sis/member/updateMemberABC.do";
					var send_data = selectedRowsData;
					var if_success = function(data){
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else{
							$cm.saveSuccess();
						}
					}
					
					var if_error = function(){}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
					
				}
				
			}else if(prefixId == "MEM_STATE"){			//회원상태
				
				selectedRowsData = $cm.multiSelectValidate(dhtmlxGridObj,["MEM_NO"]);
				if(selectedRowsData){
					selectedRowsData = $erp.putKeyAndValueToListMap(selectedRowsData, "update" + prefixId, value);
					
					var url = "/sis/member/updateMemberState.do";
					var send_data = selectedRowsData;
					var if_success = function(data){
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else{
							$cm.saveSuccess();
						}
					}
					
					var if_error = function(){}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
					
				}
				
			}else if(prefixId == "CUST_TAX_YN"){		//회원 세금계산서 일괄 발행 여부
				
				selectedRowsData = $cm.multiSelectValidate(dhtmlxGridObj,["MEM_NO"]);
				if(selectedRowsData){
					selectedRowsData = $erp.putKeyAndValueToListMap(selectedRowsData, "update" + prefixId, value);
					
					var url = "/sis/member/updateMemberTaxYN.do";
					var send_data = selectedRowsData;
					var if_success = function(data){
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else{
							$cm.saveSuccess();
						}
					}
					
					var if_error = function(){}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
					
				}
				
			}else if(prefixId == "CHG_AMT_TYPE"){		//소액처리유형
				
				selectedRowsData = $cm.multiSelectValidate(dhtmlxGridObj,["MEM_NO"]);
				if(selectedRowsData){
					selectedRowsData = $erp.putKeyAndValueToListMap(selectedRowsData, "update" + prefixId, value);
					
					var url = "/sis/member/updateMemberChgAmtType.do";
					var send_data = selectedRowsData;
					var if_success = function(data){
						if(data.isError){
							$erp.ajaxErrorMessage(data);
						}else{
							$cm.saveSuccess();
						}
					}
					
					var if_error = function(){}
					
					$erp.UseAjaxRequestInBody(url, send_data, if_success, if_error, total_layout);
					
				}
				
			}else{
				$erp.alertMessage({
					"alertMessage" : "아직 구현되지 않았습니다. " + id,
					"alertType" : "alert",
					"isAjax" : false,
				});
			}
			
		}
		
		var contextMenuObj = this.useGridRightClick(dhtmlxGridObj, items, onRightClick);
		
		
		//그리드에 필요한 정보 컬럼이 없으면 관련 메뉴 disable 처리
		//메뉴 disable 처리 시작
		var disableMenuIdList = [];
		if(!dhtmlxGridObj.getColIndexById("ORGN_DIV_CD") || !dhtmlxGridObj.getColIndexById("ORGN_CD") || !dhtmlxGridObj.getColIndexById("MEM_NO")){
			disableMenuIdList.push("notificationTalk","changeMEM_TYPE","changeMEM_ABC","changeMEM_COUPON","changeMEM_SURVEY","changeMEM_GROUP",
									"changeMEM_STATE","changeTAX_YN","changeCHG_AMT_TYPE","changePRICE_POLI","execTAX","searchAPPR_TRADE","searchTAX");
		}else if(!dhtmlxGridObj.getColIndexById("GOODS_NO")){
			disableMenuIdList.push("printLABEL");
		}
		this.menuDisable(contextMenuObj, disableMenuIdList);
		//메뉴 disable 처리 끝
		
		
		//공통코드로 하위 메뉴추가
		this.createMenuItemsAsCommonCode(contextMenuObj, "changeMEM_TYPE", "MEM_TYPE");				//회원유형 메뉴 추가
		this.createMenuItemsAsCommonCode(contextMenuObj, "changeMEM_ABC", "MEM_ABC");				//회원 ABC 메뉴 추가
		this.createMenuItemsAsCommonCode(contextMenuObj, "changeMEM_STATE", "MEM_STATE");			//회원 상태 메뉴 추가
		this.createMenuItemsAsCommonCode(contextMenuObj, "changeTAX_YN", "CUST_TAX_YN");			//회원 세금계산서 일괄 발행 여부 메뉴 추가
		this.createMenuItemsAsCommonCode(contextMenuObj, "changeCHG_AMT_TYPE", "CHG_AMT_TYPE");		//소액처리 메뉴 추가
		
	}
	
	/** 
	* Description 
	* @function sisUserGridRightClick
	* @function_Description 그리드 우클릭 거래원장 관련 메뉴
	* @param dhtmlxGridObj (object) dhtmlx 그리드 객체
	* @author 조승현
	*/
	this.sisTransactionLedgerGridRightClick = function(dhtmlxGridObj){

		var items = [
			{id: "notificationTalk", 			text: "알림톡 발송"},
			{id: "userInfo", 					text: "회원정보 보기"},
			{type: "separator"},
			{id: "transactionLedgerListPrint", 	text: "거래원장리스트 인쇄"}
		];
		
		var onRightClick = function(id, zoneId, cas){
			var selectedRowsData;
			
			var prefixId = id.split("_____")[0];
			var value = id.split("_____")[1];
			
			if(id == "notificationTalk"){
				//---------------------------------------------------------------------알림톡 개발후 추가예정
				$cm.comingSoon();
			}else if(id == "userInfo"){
				
				selectedRowsData = $cm.singleSelectValidate(dhtmlxGridObj,["MEM_NO"]);
				if(selectedRowsData){
					$erp.openMemberInfoPopup(selectedRowsData[0].MEM_NO);
				}
				
			}else if(id == "transactionLedgerListPrint"){
				//---------------------------------------------------------------------거래원장인쇄하기 정혜원주임님 개발후 추가예정
				$cm.comingSoon();
			}else{
				$erp.alertMessage({
					"alertMessage" : "아직 구현되지 않았습니다. " + id,
					"alertType" : "alert",
					"isAjax" : false,
				});
			}
		}
		
		var contextMenuObj = this.useGridRightClick(dhtmlxGridObj, items, onRightClick);
		
		
		//그리드에 필요한 정보 컬럼이 없으면 관련 메뉴 disable 처리
		//메뉴 disable 처리 시작
		var disableMenuIdList = [];
		if(!dhtmlxGridObj.getColIndexById("MEM_NO")){
			disableMenuIdList.push("notificationTalk","userInfo","transactionLedgerListPrint");
		}
		this.menuDisable(contextMenuObj, disableMenuIdList);
		//메뉴 disable 처리 끝
	}
}

var $cm = new contextMenu();
