/*
Product Name: dhtmlxSuite 
Version: 4.6.1 
Edition: Professional 
License: content of this file is covered by DHTMLX Commercial or Enterprise license. Usage without proper license is prohibited. To obtain it contact sales@dhtmlX.com
Copyright UAB Dinamenta http://www.dhtmlx.com
*/
/* #Customized (김종훈) : 녹취 듣기를 위한 Custom Cell */
/**
*	@desc: dhtmlXGrid Record Cell
*	@returns: dhtmlXGrid cell editor object
*	@type: public
*	@author 김종훈
*/
function eXcell_record(cell){
	if (cell){
		this.cell=cell;
		if(this.cell.className.indexOf("dhx_record") == -1){
			if(this.cell.className.length > 0){
				this.cell.className += " ";
			}
			this.cell.className += "dhx_record"; 
		}		
		this.grid=this.cell.parentNode.grid;
	}
	
	this.edit = function(){
		return true;
	}
	
	this.getText = function(){
		return "";
	}
	
	this.setValue = function(val){
		if (( typeof (val) != "number")&&(!val||val.toString()._dhx_trim() == "")){
			val="&nbsp;"
			this.cell._clearCell=true;
		} else {
			this.cell._clearCell=false;
			
		}
		this.setCValue(val);
	}
	this.setCValue=function(val, val2){
		if(val && val != "" && val !="&nbsp;"){
			this.cell.innerHTML="<input type='button' class='input_common_button' value='듣기' onclick='$erp.openRecordPlayerPopup(\"" + val + "\")' />";
		} else {
			this.cell.innerHTML="&nbsp;"
		}
		
		this.cell.val=val;
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
	this.getTitle = function(){
		return this.cell._clearCell?"": "듣기";
	}
	
	this.getValue = function(){
		return this.cell._clearCell?"": this.cell.val;
	}
	this.getRowId = function(){
		if(this.cell && this.cell.parentNode && this.cell.parentNode.idd){
			return this.cell.parentNode.idd;
		}
	}
}
eXcell_popup.prototype = new eXcell;
