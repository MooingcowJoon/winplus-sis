/*
name : pgpopup.js
*/
(function($){
	
	var type,padding=10,width=80,color='#ffffff',bgcolor='#111111',transparency=0.8,time=800,delay=800,direction='down',font_size = '10';

	$.fn.pgpopup = function(opt){

		if($('#pgpopupdiv').length>0) return;

		if(opt.type) type = opt.type;

		if(opt.padding) padding = opt.padding;
		if(opt.width) width = opt.width;
		if(opt.color) color = opt.color;
		if(opt.bgcolor) bgcolor = opt.bgcolor;
		if(opt.transparency) transparency = opt.transparency;
		if(opt.time) time = opt.time;
		if(opt.delay) delay = opt.delay;
		if(opt.direction) direction = opt.direction;
		if(opt.msg) msg = opt.msg;
		if(opt.font_size) font_size = opt.font_size;
		
		
		bgcolor = hex2rgb(bgcolor);		
		id = "pgpopupdiv";

		html = '<div id="'+id+'" style="display:none; opacity:0; position:fixed; z-index:9999; border-radius:2px; text-align:center; left:50%; top:50%; background:rgba('+bgcolor+','+transparency+'); width:'+width+'%; "><div style="margin:0 auto; text-aling:center; font-size:'+font_size+'px; color:'+color+'; padding:'+padding+'px;">'+msg+'</div></div>';
		
		$(this).append(html);
		
		id = '#'+id;
		height =$(id).height();
		
		margintop = (height/2)*(-1);
		marginleft = ($(id).width()/2)*(-1);
		
		//TOAST레이어팝업효과
		if(type=='toast'){
			var locationtop = document.body.clientHeight-(height+5);
			var locationleft = document.body.clientWidth-(($(id).width()/2)+10);
			$(id).css({'top':locationtop+'px','left':locationleft+'px','margin-top':margintop+'px','margin-left':marginleft+'px','display':'block'});
			
			$(id).animate({
				opacity:1
			},time,function(){
				$(id).delay(delay).animate({
					opacity:0
					},time,function(){
						$(id).remove();
					});
			});

		}
		
		//TOAST레이어팝업효과
		if(type=='toast2'){
			//var locationtop = document.body.clientHeight-20//-(height+5);
			var locationtop = height+30;
			var locationleft = (document.body.clientWidth/2)//-(($(id).width()/2)+10);
			$(id).css({'top':locationtop+'px','left':locationleft+'px','margin-top':margintop+'px','margin-left':marginleft+'px','display':'block'});
			
			$(id).animate({
				opacity:1
			},time,function(){
				$(id).delay(delay).animate({
					opacity:0
					},time,function(){
						$(id).remove();
					});
			});

		}
		
		//일반 레이어팝업 X 있는것
		if(type=='layer'){

			subhtml = "<div id='pgpopupdivclose' style='border:1px solid #fff; border-radius:2px; color:#fff; margin:0 auto; cursor:pointer; margin-top:10px; padding:5px;' >Close</div>";
			
			$(id+' > div').append(subhtml);


			$(id).css({'margin-top':(margintop-12)+'px','margin-left':marginleft+'px','display':'block'});

			$(id).animate({
				opacity:1
			},time);
			
			$('#pgpopupdivclose').click(function(){
				if($(id).length>0){
					$(id).animate({
					opacity:0
					},time,function(){
						$(id).remove();
					});
				}
			});

		}
		
		//슬라이드팝업
		if(type=='slide'){
			
			$(id).css({'margin-top':'0px','margin-left':'0px','display':'block','left':'0px','opacity':1,'width':'100%','border-radius':'0px'});

			
			if(direction=='up'){
				$(id).css({'top':(height*(-1))+'px','border-bottom-left-radius': '5px','border-bottom-right-radius': '5px'});
				$(id).animate({
					top:'0px'
				},time,function(){
						$(id).delay(delay).animate({
							top:(height*(-1))+'px'
						},time,function(){
							$(id).remove();
							});		
					});				
			}
			if(direction=='down'){
				
				$(id).css({'top':'','bottom':(height*(-1))+'px','border-top-left-radius': '5px','border-top-right-radius': '5px'});
				
				$(id).animate({
					bottom:'0px'
				},time,function(){
						$(id).delay(delay).animate({
							bottom:(height*(-1))+'px'
						},time,function(){
							$(id).remove();
							});		
					});	
			}
			
		}



		function hex2rgb(hexStr){
			var hex = parseInt(hexStr.substring(1), 16);
			var r = (hex & 0xff0000) >> 16;
			var g = (hex & 0x00ff00) >> 8;
			var b = hex & 0x0000ff;
			return r+","+g+","+b;
		}

	}
})(jQuery);

