/*
Product Name: dhtmlxSuite 
Version: 4.6.1 
Edition: Professional 
License: content of this file is covered by DHTMLX Commercial or Enterprise license. Usage without proper license is prohibited. To obtain it contact sales@dhtmlX.com
Copyright UAB Dinamenta http://www.dhtmlx.com
*/
/* #Customized (김종훈) : 팝업 연결을 위한 Custom Cell */
/**
*	@desc: dhtmlXGrid Popup Cell
*	@returns: dhtmlXGrid cell editor object
*	@type: public
*	@author 김종훈
*/
function eXcell_popup(cell){
	if (cell){
		this.cell=cell;
		if(this.cell.className.indexOf("dhx_popup") == -1){
			if(this.cell.className.length > 0){
				this.cell.className += " ";
			}
			this.cell.className += "dhx_popup"; 
		}		
		this.grid=this.cell.parentNode.grid;
	}
	
	this.edit = function(){
		var parentDhtmlXGridCell = this;
		var columnsMapArray = this.grid.columnsMapArray;		
		/* rowid : this.cell.parentNode.idd */
		/* cellIndex : this.cell._cellIndex */		
		if(columnsMapArray){			
			if(columnsMapArray[this.cell._cellIndex].url){
				var parentDhtmlXGridCellRowId = this.cell.parentNode.idd;
				var parentDhtmlXGridCellIndex = this.cell._cellIndex;
				var popupParam = columnsMapArray[this.cell._cellIndex].popupParam;
				var onContentLoaded = columnsMapArray[this.cell._cellIndex].onContentLoaded;
				var onContentLoadedExtend = function(name){
					var popWin = this.getAttachedObject().contentWindow;
					if(parentDhtmlXGridCell){
						while (popWin.parentDhtmlXGridCell == undefined){
							popWin.parentDhtmlXGridCell = parentDhtmlXGridCell;
							popWin.parentDhtmlXGridCellRowId = parentDhtmlXGridCellRowId;
							popWin.parentDhtmlXGrid = parentDhtmlXGridCell.grid;	
							popWin.parentDhtmlXGridCellIndex = parentDhtmlXGridCellIndex;
						}
					}
					if(onContentLoaded && typeof onContentLoaded === 'function' ){
						onContentLoaded.apply(this, [name]);
					}
					this.progressOff();
				};
				var dhtmlXGridPopupUrl = columnsMapArray[this.cell._cellIndex].url;
				if($erp.isEmpty(popupParam) || typeof popupParam !== 'object'){
					popupParam = {};
				}
				popupParam.currentMenu_cd=currentMenu_cd;				
				popupParam.dhtmlXGridCellValue=this.getValue();								
				popupParam.dhtmlXGridCellText=this.getText();
				
				$erp.openPopup(dhtmlXGridPopupUrl, popupParam, onContentLoadedExtend);
			}
		}		
	}
	
	this.getText = function(){
		return this.cell._clearCell?"":this.cell.innerHTML.toString()._dhx_trim();
	}
	
	this.setText = function(txt){
		if (( typeof (txt) != "number")&&(!txt||txt.toString()._dhx_trim() == "")){
			val="&nbsp;"
			this.cell._clearCell=true;
		} else {
			this.cell._clearCell=false;
		}
		this.cell.innerHTML = txt;
	}
	this.setValue = function(val){
		if (( typeof (val) != "number")&&(!val||val.toString()._dhx_trim() == "")){
			val="&nbsp;"
			this.cell._clearCell=true;
		} else {
			this.cell._clearCell=false;
		}
		if(typeof val === 'object'){
			if(val.value){
				this.setCValue(val.value);
				if(val.text){
					this.setText(val.text);
				}
			} else if(val.text){
				this.setValue(val.text);
			} else {
				this.setValue("");
			}
		} else {
			this.setCValue(val);
		}
	}
	this.setCValue=function(val, val2){
		this.cell.innerHTML=val;
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
	this.getValue = function(){
		if(this.cell.val){
			return this.cell._clearCell?"": this.cell.val;
		} else {
			return this.cell._clearCell?"": this.cell.innerHTML;			
		}
	}
	this.getRowId = function(){
		if(this.cell && this.cell.parentNode && this.cell.parentNode.idd){
			return this.cell.parentNode.idd;
		}
	}
}
eXcell_popup.prototype = new eXcell;
