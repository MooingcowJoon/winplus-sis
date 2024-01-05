<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/include/default_resources_header.jsp"/>
<jsp:include page="/WEB-INF/jsp/common/include/default_page_script_header.jsp"/>
<link rel="stylesheet" href="/resources/framework/dhtmlxScheduler_v4.4.0/sources/skins/dhtmlxscheduler_flat.css" />
<style type="text/css">
   .dhxlayout_base_dhx_skyblue .dhxlayout_cont div.dhx_cell_layout div.dhx_cell_cont_layout {
      border-top:1px solid #8baeda;
   }
</style>
<%-- DhtmlxScheduler Not Suite --%>
<script type="text/javascript" src="/resources/framework/dhtmlxScheduler_v4.4.0/sources/dhtmlxscheduler.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxScheduler_v4.4.0/sources/ext/dhtmlxscheduler_year_view.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxScheduler_v4.4.0/sources/locale/locale_ko.js"></script>
<script type="text/javascript" src="/resources/common/js/report.js"></script>
<script type="text/javascript">
	
	
	var erpLayout;
	var erpScheduler;
	var openMonth;
	var alreadyReportDay = "2019-09-01";
	var prevMonthReportDay = "2019-06-20";
	var thisMonth;
	
	
	
	$(document).ready(function(){	
		initErpLayout();
		initErpScheduler();
        var prevBtn = document.getElementsByClassName("dhx_cal_prev_button")[0];
        var nextBtn = document.getElementsByClassName("dhx_cal_next_button")[0];
        initBtnEvent(prevBtn, nextBtn);
	});
	
	function initBtnEvent(prevBtn, nextBtn){
		if(prevBtn.addEventListener){
			prevBtn.addEventListener("click",function(){
	        	colorChange();
	        });
			
			nextBtn.addEventListener("click",function(){
	        	colorChange();
	        });
		} else if(prevBtn.attachEvent) {
			prevBtn.attachEvent("onClick",function(){
	        	colorChange();
	        });
			
			nextBtn.attachEvent("onClick",function(){
	        	colorChange();
	        })
		}
	}
	
	<%-- ■ erpLayout 관련 Function 시작 --%>
	<%-- erpLayout 초기화 Function --%>	
	function initErpLayout(){
		erpLayout = new dhtmlXLayoutObject({
			parent: document.body
			, skin : ERP_LAYOUT_CURRENT_SKINS
			, pattern: "3E"
			, cells: [
				{id: "a", text: "", header:false, height: 20}
				, {id: "b", text: "", header:false, height: 600, fix_size:[true, true]}
				, {id: "c", text: "", header:false}
			]		
		});
		erpLayout.cells("a").attachObject("div_erp_report_make");
		erpLayout.cells("b").attachObject("div_erp_scheduler_wrapper");
		erpLayout.cells("c").attachObject("div_erp_check_list");
		
		erpLayout.setSeparatorSize(2, 1);
		
		$erp.setEventResizeDhtmlXLayout(erpLayout, function(names){
			/* 인자 없으면 새로고침 */
			erpScheduler.setCurrentView();	
			colorChange();
		});
		
	}
	<%-- ■ erpLayout 관련 Function 끝 --%>
	
	function initErpScheduler() {
		erpScheduler=scheduler;      
		erpScheduler.config.readonly = true;      
		erpScheduler.config.start_on_monday = false;
		erpScheduler.config.default_date="%Y-%m-%d", //$("#div_erp_scheduler td")의 aria-label값에 영향을 주는 이름!
		erpScheduler.config.month_date="%Y년 %F",
		erpScheduler.config.load_date="%Y-%m-%d",
		erpScheduler.config.week_date="%l",
		erpScheduler.config.day_date="%F %j일 (%D)",
		erpScheduler.config.hour_date="%H:%i",
		erpScheduler.config.month_day="%d",
		erpScheduler.config.xml_date="%Y-%m-%d %H:%i",
		erpScheduler.config.api_date="%Y-%m-%d %H:%i",
		erpScheduler.config.lightbox.sections[1].time_format = ["%Y", "%m", "%d", "%H:%i"];
		erpScheduler.templates.year_date = function(date) {
			return scheduler.date.date_to_str("%Y" + scheduler.locale.labels.year)(date);
		};
		
		erpScheduler.xy.margin_top=10;
		erpScheduler.xy.margin_left=20;
		erpScheduler.xy.bar_height=15;      
		
		
		erpScheduler.attachEvent("onEmptyClick", function (date,e){
			//console.log(e.path[0].parentNode);
			//e.path[0].parentNode.setAttribute("class", "dhx_customized"); //색깔변경을 위해서 해당 일자의 td 태크의 class값의 이름을 변경해주는 절차!
		});
		
		var today = $erp.getToday("-");
		var year = today.split("-")[0];
		var month = today.split("-")[1]-1;
		var day = today.split("-")[2];
		thisMonth = month+1;
		erpScheduler.init('div_erp_scheduler', new Date(year, month, day), "month");
		colorChange();
	}
	
	function colorChange() {
		var aria_month;
		thisMonth = document.getElementsByClassName("dhx_cal_date")[0].innerHTML;
		thisMonth = (thisMonth.substr(6,2).split('월'))[0];
		var Month_Num = Number(thisMonth);
		
		if(thisMonth < 10){
			thisMonth = "0" + thisMonth;
		}
		
		$("#div_erp_scheduler td").each(function(index, obj){ //나오는 모든 #div_erp_scheduler 아래 모든 td를 돌면서
			console.log(obj.getAttribute('aria-label')); //#div_erp_scheduler td가 가지고 있는 값중에서 aria-label값만 불러옴 
			var checkboxDay = (obj.getAttribute('aria-label').substr(9,2).split('일'))[0]; //해당일자의 일값 가져오기
			var aria_month = obj.getAttribute('aria-label').substr(5,2); //해당일자의 월값 가져오기
			var num = obj.childNodes[0].innerHTML;  // dhx_month_head 에 써있는 숫자값(일자)
			
			if(obj.getAttribute('aria-label') == alreadyReportDay ){
				obj.setAttribute("class", "dhx_customized");
			}
			
			if(aria_month == thisMonth){
				obj.childNodes[0].innerHTML = "<span>" + num + "</span><input type='checkbox' id='chk_"+ num + "' style='margin-left: 10px;margin-top: 5px;float: left;'>";
			}
		});
		
	}
	
	//<input type="checkbox" id="chk_01" style="margin-left: 10px;margin-top: 5px;float: left;">
	//(처음에 체크상태 비워주기)
	function check_btn(btn_nm){
		if(btn_nm == "all_check"){
			//현재화면에 나와있는 모든 체크박스 돌면서 체크처리해주기
		}else if(btn_nm == "all_uncheck"){
			//현재화면에 나와있는 모든 체크박스 돌면서 미체크처리해주기
		}else if(btn_nm == "non_check"){
			//현재화면에 나와있는 처리표시 안된날짜~오늘날짜까지 체크처리
		}
	}
	
</script>
</head>
<body>
	<div id="div_erp_report_make" class="div_erp_contents_search" style="width:100%; height:100%;padding-left: 15px;padding-top: 15px;padding-right: 15px;padding-bottom: 15px;">
		<input type="button" id="all_check" value="모두체크" class="input_common_button" onclick=""/>
		<input type="button" id="all_uncheck" value="모두해제" class="input_common_button" onclick=""/>
		<input type="button" id="mis_check" value="미처리체크" class="input_common_button" onclick=""/>
	</div>
	<div id="div_erp_scheduler_wrapper" class="div_grid_full_size" style="padding-left:10px">
      <div id="div_erp_scheduler" class="dhx_cal_container div_grid_full_size">
         <div class="dhx_cal_navline">
            <div class="dhx_cal_prev_button">&nbsp;</div>
            <!-- <div class="dhx_cal_today_button"></div> -->
            <div class="dhx_cal_next_button">&nbsp;</div>
            <div class="dhx_cal_date"></div>
            <!-- <div class="dhx_cal_tab" name="day_tab"></div>            
              <div class="dhx_cal_tab" name="week_tab"></div>
              <div class="dhx_cal_tab" name="month_tab"></div>
              <div class="dhx_cal_tab" name="year_tab"></div> -->
         </div>
         <div class="dhx_cal_header div_width_full" style="width:100% !important;"></div>
         <div class="dhx_cal_data div_width_full" style="width:100% !important;"></div>
         <div class="dhx_cal_navline">
         </div>
      </div>
   </div>
	<div id="div_erp_check_list" class="div_erp_contents_search" style="width:100%; height:100%;">
		<table>
			<tr>
				<td>
					<input type="checkbox" id="Select_already" name="Select_already"/>
					<label for="Select_already">이미 기록된 수수료공급사 판매분매입작업 실행</label>
				</td>
			</tr>
			<tr>
				<td>
					<input type="checkbox" id="Month_report" name="Month_report"/>
					<label for="Month_report">일 레포트 생성이 끝나면 해당월 월 레포트 생성</label>
				</td>
			</tr>
			<tr>
				<td>
					<input type="checkbox" id="DB_backup" name="DB_backup"/>
					<label for="DB_backup">데이터베이스 전체 백업실행</label>
				</td>
			</tr>
			<tr>
				<td>
					<input type="button" id="make_day_report" value="일-레포트 생성" class="input_common_button" onclick="" style="float: left;"/>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>