/*
Product Name: dhtmlxSuite 
Version: 4.6.1 
Edition: Professional 
License: content of this file is covered by DHTMLX Commercial or Enterprise license. Usage without proper license is prohibited. To obtain it contact sales@dhtmlX.com
Copyright UAB Dinamenta http://www.dhtmlx.com
*/
/* #Customized (김종훈) : 팝업 연결을 위한 Custom Cell */
/**
*	@desc: dhtmlXGrid ReadOnly Text Cell (textContent 전용)
*	@returns: dhtmlXGrid cell editor object
*	@type: public
*	@author 김종훈
*/
function eXcell_ro_txt(cell){
	if (cell){
		this.cell=cell;
		this.grid=this.cell.parentNode.grid;
		/* #Customized (김종훈) : ReadOnly On/Off 용 */
		if(this.cell.isReadOnlyClass == undefined){
			this.cell.isReadOnlyClass = true;
		}
		/* #Customized (김종훈) : ReadOnly 클래스 적용 */
		if(this.cell.isReadOnlyClass === true){
			if(this.cell.className && this.cell.className != ""){
				if(this.cell.className.indexOf("grid_cell_readonly") == -1){
					this.cell.className += " grid_cell_readonly";
				}
			} else {
				this.cell.className = "grid_cell_readonly";
			}
		}
	}
	this.edit=function(){
	}

	this.isDisabled=function(){
		return true;
	}
	
	this.getValue=function(){
		return this.cell._clearCell?"":this.cell.textContent.toString()._dhx_trim();
	}
	
	this.setCValue=function(val, val2){
		this.cell.textContent=val;
		//#__pro_feature:21092006{
		//#on_cell_changed:23102006{
			this.grid.callEvent("onCellChanged", [
				this.cell.parentNode.idd,
				this.cell._cellIndex,
				(arguments.length > 1 ? val2 : val)
			]);
		//#}
		//#}
	}
	
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
eXcell_ro_txt.prototype=new eXcell;
