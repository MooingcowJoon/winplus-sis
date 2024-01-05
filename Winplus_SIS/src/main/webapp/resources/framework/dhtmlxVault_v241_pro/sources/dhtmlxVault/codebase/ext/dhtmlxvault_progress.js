/*
Product Name: dhtmlxVault 
Version: 2.4.1 
Edition: Professional 
License: content of this file is covered by DHTMLX Commercial or Enterprise license. Usage without proper license is prohibited. To obtain it contact sales@dhtmlx.com
Copyright UAB Dinamenta http://www.dhtmlx.com
*/

dhtmlXVaultObject.prototype.setProgressMode = function(mode) {
	this.conf.progress_mode = mode;
};

dhtmlXVaultObject.prototype.list_default.prototype.updateFileStateExtra = function(id, data) {
	
	var item = this.t[id];
	if (item == null) return;
	
	if (data.state == "uploading") {
		item.className = "dhx_vault_file dhx_vault_file_uploading";
		item.childNodes[1].className = "dhx_vault_file_param dhx_vault_file_progress";
		item.childNodes[1].innerHTML = "<div class='dhx_vault_progress'><div class='dhx_vault_progress_bg' style='width:"+data.progress+"%;'>&nbsp;</div></div>"+
						(data.eta!=null?"<span class='progress_eta'>"+data.eta+"</span>":"");
	}
	
	item = null;
	return (data.state == "uploading");
	
};

dhtmlXVaultObject.prototype._etaStart = function(id) {
	
	if (typeof(this.conf.files_time) == "undefined") {
		this.conf.files_time = {};
	}
	
	if (this.conf.files_time[id] == null) {
		this.conf.files_time[id] = {start: new Date().getTime(), end: 0, size: this.file_data[id].size};
	}
	
};

dhtmlXVaultObject.prototype._etaCheck = function(id, progress) {

	var eta = null;
	
	if (this.conf.files_time[id] != null && progress > 0) {
		
		var time = (new Date().getTime()-this.conf.files_time[id].start)/1000;
		var time_left = (time*100/progress-time).toFixed(0);
		
		// time left
		var d = new Date().getTime();
		if ((this.conf.files_time[id].time_upd == null || this.conf.files_time[id].time_upd+1100 < d) && this.conf.files_time[id].start+3000 < d) { // show eta after 3sec of upload
			this.conf.files_time[id].time_left = Math.max(1,time_left);
			this.conf.files_time[id].time_upd = d;
		}
		
		if (this.conf.files_time[id].time_left != null) eta = this._timeHIS(this.conf.files_time[id].time_left);
	}
	
	return eta;
};

dhtmlXVaultObject.prototype._etaEnd = function(id) {
	this.conf.files_time[id] = null;
	delete this.conf.files_time[id];
};

dhtmlXVaultObject.prototype._timeHIS = function(sec) {
	// hours
	var t = ["h","m","s"];
	var r = [];
	var i = 3600;
	for (var q=0; q<3; q++) {
		var h = Math.floor(sec/i);
		sec = sec-h*i;
		if (h > 0 || r.length > 0) r.push(String(h)+t[q]);
		if (i > 1) i = i/60;
	}
	return r.join(" ");
};

