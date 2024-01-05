/*
Product Name: dhtmlxVault 
Version: 2.4.1 
Edition: Professional 
License: content of this file is covered by DHTMLX Commercial or Enterprise license. Usage without proper license is prohibited. To obtain it contact sales@dhtmlx.com
Copyright UAB Dinamenta http://www.dhtmlx.com
*/

dhtmlXVaultObject.prototype._initDND = function() {
	
	var that = this;
	
	this.dnd = {};
	
	this._showDNDBox = function() {
		
		if (!this.conf.enabled) return;
		
		if (!this.dnd.box) {
			
			this.dnd.box = document.createElement("DIV");
			this.dnd.box.className = "dhx_vault_dnd_box";
			this.base.appendChild(this.dnd.box);
			this.p_files.className = "dhx_vault_files dhx_vault_dnd_box_over";
			this.dnd.box.style.top = this.p_files.style.top;
			this.dnd.box.style.left = this.p_files.style.left;
			this.dnd.box.style.width = this.p_files.offsetWidth-(this.dnd.box.offsetWidth-this.dnd.box.clientWidth)+"px";
			this.dnd.box.style.height = this.p_files.offsetHeight-(this.dnd.box.offsetHeight-this.dnd.box.clientHeight)+"px";
			this.dnd.box.innerHTML = "<div class='dhx_vault_dnd_box_text' style='margin-top:"+Math.round(this.dnd.box.offsetHeight/2-24)+"px;'>"+this.strings.dnd+"</div>";
			
			this.dnd.box.ondragenter = function(e){
				that.dnd.last_node = e.target;
				if (!e.dataTransfer) return;
				try {
					e.dataTransfer.effectAllowed = "copy";
					e.dataTransfer.dropEffect = "copy";
				} catch(er){};
				e.stopPropagation();
				e.preventDefault();
			}
			this.dnd.box.ondragover = function(e){
				that.dnd.last_node = e.target;
				if (!e.dataTransfer) return;
				e.stopPropagation();
				e.preventDefault();
			}
			this.dnd.box.ondrop = function(e) {
				if (!e.dataTransfer) return;
				try {
					e.dataTransfer.effectAllowed = "copy";
					e.dataTransfer.dropEffect = "copy";
				} catch(er){};
				e.stopPropagation();
				e.preventDefault();
				if (e.dataTransfer.files.length>0) {
					that._parseFilesInInput(e.dataTransfer.files);
				} else {
					that.callEvent("_onNodeDrop",[e.dataTransfer]);
				};
				that._hideDNDBox();
			}
			
		}
	}
	this._hideDNDBox = function() {
		if (this.dnd.box != null) {
			this.dnd.box.ondragenter = null;
			this.dnd.box.ondragover = null;
			this.dnd.box.ondrop = null;
			this.dnd.box.parentNode.removeChild(this.dnd.box);
			this.dnd.box = null;
			this.p_files.className = "dhx_vault_files";
			//
			this.dnd.last_node = null;
			
		}
	}
	this.dnd.last_node = null;
	
	this._doOnWinDragEnter = function(e) { // show box
		that.dnd.last_node = e.target;
		that._showDNDBox();
	}
	this._doOnWinDragLeave = function(e) { // hide box, out of window or esc key
		if (that.dnd.last_node == e.target) {
			window.setTimeout(function(){that._hideDNDBox();},1);  // timeout for IE dnd-artefacts
		};
	}
	
	window.addEventListener("dragenter", this._doOnWinDragEnter, false);
	window.addEventListener("dragleave", this._doOnWinDragLeave, false);
	
	// window.ondragover and window.drop => prevent to open file in a tab in case of incorrect dropping
	this._doOnWinDragOver = function(e) {
		if (!e.dataTransfer) return;
		try {
			e.dataTransfer.effectAllowed = "none";
			e.dataTransfer.dropEffect = "none";
		} catch(er){};
		e.stopPropagation();
		e.preventDefault();
	}
	this._doOnWinDrop = function(e) {
		if (!e.dataTransfer) return;
		e.stopPropagation();
		e.preventDefault();
		that._hideDNDBox();
	}
	
	window.addEventListener("dragover", this._doOnWinDragOver, false);
	window.addEventListener("drop", this._doOnWinDrop, false);
	
	this._unloadDND = function() {
		
		window.removeEventListener("dragenter", this._doOnWinDragEnter, false);
		window.removeEventListener("dragleave", this._doOnWinDragLeave, false);
		window.removeEventListener("dragover", this._doOnWinDragOver, false);
		window.removeEventListener("drop", this._doOnWinDrop, false);
		
		for (var a in this._dndNodesData) {
			if (this._dndNodesData[a].inst_id == this.conf.inst_id) {
				this.removeDraggableNode(this._dndNodesData[a].node);
			}
		}
		
		this._hideDNDBox();
		
		this._showDNDBox = null;
		this._hideDNDBox = null;
		this._doOnWinDragEnter = null;
		this._doOnWinDragLeave = null;
		this._doOnWinDragOver = null;
		this._doOnWinDrop = null;
		this._initDND = null;
		this._unloadDND = null;
		this.dnd = null;
		
		that = null;
	};
};

dhtmlXVaultObject.prototype.strings.dnd = "Drop files here";

// drag custom objects
dhtmlXVaultObject.prototype._dndNodesData = {};

dhtmlXVaultObject.prototype.addDraggableNode = function(node, data) {
	
	if (typeof(window.addEventListener) != "function") return;
	
	if (typeof(node) == "string") node = document.getElementById(node);
	
	if (typeof(node._dhxvault_dnd_id) != "undefined") { // already mapped, support multiple vaults to drop, 1 vault=>1 data
		node = null;
		return;
	}
	
	if (this.conf.inst_id == null) {
		this.conf.inst_id = window.dhx4.newId();
	}
	
	if (this._onNodeDragStart == null) {
		this._onNodeDragStart = function(e) {
			e = e||event;
			e.dataTransfer.setData("text", this._dhxvault_dnd_id);
		}
		this._onNodeDrop = function(dataTransfer) {
			var id = dataTransfer.getData("text");
			if (id != null && this._dndNodesData[id] != null) this.callEvent("onDrop", [this._dndNodesData[id].node, this._dndNodesData[id].data]);
		}
		this.attachEvent("_onNodeDrop", this._onNodeDrop);
	}
	
	var id = String(window.dhx4.newId()); // IE required string here
	node._dhxvault_dnd_id = id;
	this._dndNodesData[id] = {
		inst_id: this.conf.inst_id,
		node: node,
		data: data
	};
	
	node.addEventListener("dragstart", this._onNodeDragStart, false);
	node = null;
	
};

dhtmlXVaultObject.prototype.removeDraggableNode = function(node) {
	
	if (typeof(node) == "string") node = document.getElementById(node);
	
	if (typeof(node._dhxvault_dnd_id) == "undefined") { // not mapped
		node = null;
		return;
	}
	
	this._dndNodesData[node._dhxvault_dnd_id].node = null;
	this._dndNodesData[node._dhxvault_dnd_id].data = null;
	delete this._dndNodesData[node._dhxvault_dnd_id];
	delete node._dhxvault_dnd_id;
	
	node.removeEventListener("dragstart", this._onNodeDragStart);
	node = null;
	
};

