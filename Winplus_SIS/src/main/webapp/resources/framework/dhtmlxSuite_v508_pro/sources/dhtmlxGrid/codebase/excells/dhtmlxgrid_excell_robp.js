/*
Product Name: dhtmlxSuite 
Version: 4.6.1 
Edition: Professional 
License: content of this file is covered by DHTMLX Commercial or Enterprise license. Usage without proper license is prohibited. To obtain it contact sales@dhtmlx.com
Copyright UAB Dinamenta http://www.dhtmlx.com
*/
/* #Customized (김종훈) : 링크 UI를 위한 Custom Cell */
/**
*	@desc: readonly bold pointer cell
*	@returns: dhtmlxGrid cell editor object
*	@type: public
*/
function eXcell_robp(cell){
	if (cell){
		this.cell=cell;
		this.grid=this.cell.parentNode.grid;
		/* #Customized (김종훈) : ReadOnly 클래스 적용 */
		if(this.cell.className && this.cell.className != ""){
			if(this.cell.className.indexOf("grid_cell_readonly") == -1){
				this.cell.className += " grid_cell_readonly";
			}
		} else {
			this.cell.className = "grid_cell_readonly";
		}		
	}
	this.edit=function(){
	}

	this.isDisabled=function(){
		return true;
	}
	this.getValue=function(){
		return this.cell._clearCell?"":this.cell.innerHTML.toString()._dhx_trim();
	}
	
	this.setValue=function(val){
		if (( typeof (val) != "number")&&(!val||val.toString()._dhx_trim() == "")){
			val="&nbsp;"
			this.cell._clearCell=true;
		} else {
			this.cell._clearCell=false;
			/* #Customized (김종훈) : Bold Pointer 클래스 적용 */
			if(this.cell.className && this.cell.className != ""){
				if(this.cell.className.indexOf("grid_cell_bold_pointer") == -1){
					this.cell.className += " grid_cell_bold_pointer";
				}
			} else {
				this.cell.className = "grid_cell_bold_pointer";
			}
		}
		this.setCValue(val);
	}
}
eXcell_robp.prototype=new eXcell;
