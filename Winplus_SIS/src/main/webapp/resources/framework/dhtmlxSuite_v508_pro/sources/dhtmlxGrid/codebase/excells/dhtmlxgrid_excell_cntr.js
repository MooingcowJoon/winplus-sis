/*
Product Name: dhtmlxSuite 
Version: 5.0.8 
Edition: Professional 
License: content of this file is covered by DHTMLX Commercial or Enterprise license. Usage without proper license is prohibited. To obtain it contact sales@dhtmlx.com
Copyright UAB Dinamenta http://www.dhtmlx.com
*/

/**
*	@desc: auto counter editor
*	@returns: dhtmlxGrid cell editor object
*	@type: public
*/
function eXcell_cntr(cell){
	this.cell = cell;
	/* #Customized (김종훈) : ReadOnly On/Off 용 */
	if(this.cell.isReadOnlyClass == undefined){
		this.cell.isReadOnlyClass = true;
	}
	if(this.cell.isReadOnlyClass === true){
		/* #Customized (김종훈) : ReadOnly 클래스 적용 */
		if(this.cell.className && this.cell.className != ""){
			if(this.cell.className.indexOf("grid_cell_readonly") == -1){
				this.cell.className += " grid_cell_readonly";
			}
		} else {
			this.cell.className = "grid_cell_readonly";
		}
	}
    this.grid = this.cell.parentNode.grid;
	if (!this.grid._ex_cntr_ready && !this._realfake){
		this.grid._ex_cntr_ready=true;
		if (this.grid._h2)
			this.grid.attachEvent("onOpenEn",function(id){
				this.resetCounter(cell._cellIndex);
			});
		var fix_cnt = function(){ 
			var that=this;
			window.setTimeout(function(){ 
				if (!that.resetCounter) return;
				if (that._fake && !that._realfake && cell._cellIndex<that._fake._cCount) 
					that._fake.resetCounter(cell._cellIndex); 
				else
				    that.resetCounter(cell._cellIndex);
			},1);
			return true;
		};

		this.grid.attachEvent("onBeforeSorting", fix_cnt);
		this.grid.attachEvent("onFilterEnd", fix_cnt);
	}
	
	

	this.edit = function(){}
	this.getValue = function(){
		return this.cell.innerHTML;
	}
	this.setValue = function(val){
		this.cell.style.paddingRight = "2px";
		var cell=this.cell;
		
		window.setTimeout(function(){
			if (!cell.parentNode) return;
			var val=cell.parentNode.rowIndex;
			if (cell.parentNode.grid.currentPage || val<0 || cell.parentNode.grid._srnd) val=cell.parentNode.grid.rowsBuffer._dhx_find(cell.parentNode)+1;
			if (val<=0) return;
			cell.innerHTML = val;
			if (cell.parentNode.grid._fake && cell._cellIndex<cell.parentNode.grid._fake._cCount && cell.parentNode.grid._fake.rowsAr[cell.parentNode.idd]) cell.parentNode.grid._fake.cells(cell.parentNode.idd,cell._cellIndex).setCValue(val);
			cell=null;
		},100);
	}
	
	/* #Customized (김종훈) : ReadOnly Class On/Off 용 */
	this.setReadOnlyClass=function(fl){
		if(fl === true){
			this.cell.isReadOnlyClass = true;
			if(this.cell.className && this.cell.className != ""){
				if(this.cell.className.indexOf("grid_cell_readonly") == -1){
					this.cell.className += " grid_cell_readonly";
				}
			} else {
				this.cell.className = "grid_cell_readonly";
			}
		} else {
			this.cell.isReadOnlyClass = false;
			this.cell.className = this.cell.className.replace(/ grid_cell_readonly/gi, "");
			this.cell.className = this.cell.className.replace(/grid_cell_readonly/gi, "");
		}
	}
}
dhtmlXGridObject.prototype.resetCounter=function(ind){
	/* #Customized (김종훈) : 조회 정보 없음 Row 존재시 카운팅 안함 */
	if(this.getRowIndex("NoDataPrintRow") == 0) return;
	if (this._fake && !this._realfake && ind < this._fake._cCount) this._fake.resetCounter(ind,this.currentPage);
	var i=arguments[0]||0;
	if (this.currentPage)
		i=(this.currentPage-1)*this.rowsBufferOutSize;
	for (i=0; i<this.rowsBuffer.length; i++)
		if (this.rowsBuffer[i] && this.rowsBuffer[i].tagName == "TR" && this.rowsAr[this.rowsBuffer[i].idd])
			this.rowsAr[this.rowsBuffer[i].idd].childNodes[ind].innerHTML=i+1;
}
eXcell_cntr.prototype = new eXcell;
//(c)dhtmlx ltd. www.dhtmlx.com

