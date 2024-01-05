/*
Product Name: dhtmlxSuite 
Version: 5.0.8 
Edition: Professional 
License: content of this file is covered by DHTMLX Commercial or Enterprise license. Usage without proper license is prohibited. To obtain it contact sales@dhtmlx.com
Copyright UAB Dinamenta http://www.dhtmlx.com
*/

/**
*     @desc: enables block selection mode in grid
*     @type: public
*     @topic: 0
*/
dhtmlXGridObject.prototype.enableBlockSelection = function(mode)
{
	if (typeof this._bs_mode == "undefined"){
		var self = this;
		this.obj.onmousedown = function(e) {
			if (self._bs_mode) self._OnSelectionStart((e||event),this); return true;
		}
		this._CSVRowDelimiter = this.csv.row;
		this.attachEvent("onResize", function() {self._HideSelection(); return true;});
		this.attachEvent("onGridReconstructed", function() {self._HideSelection(); return true;});
		this.attachEvent("onFilterEnd",this._HideSelection);
	}
	if (mode===false){
		this._bs_mode=false;
		return this._HideSelection();
	} else this._bs_mode=true;

	if (!window.dhx4.isIPad){
		var area = this._clip_area = document.createElement("textarea");
		area.style.cssText = "position:absolute; width:1px; height:1px; overflow:hidden; color:transparent; background-color:transparent; bottom:1px; right:1px; border:none;";

		area.onkeydown=function(e){
	            e=e||event;
	            if (e.keyCode == 86 && (e.ctrlKey || e.metaKey))
					self.pasteBlockFromClipboard()
		};
	    document.body.insertBefore(this._clip_area,document.body.firstChild);

		/* #Customized (김종훈) Paging 문제 때문에 주석 처리 문제 시 복구 */ 
	    /*dhtmlxEvent(this.entBox,"click",function(){
	        if (!self.editor && self._clip_area)
	            self._clip_area.select();
	    });*/
	}
}
/**
*     @desc:  affect block selection, so it will copy|paste only visible text , not values behind
*	  @param: mode - true/false
*     @type: public
*     @topic: 0
*/
dhtmlXGridObject.prototype.forceLabelSelection = function(mode)
{
	this._strictText = dhx4.s2b(mode)
}


dhtmlXGridObject.prototype.selectBlock = function(sx, sy, ex, ey)
{
	sy = this.getRowIndex(sy);
	ey = this.getRowIndex(ey);

	this._CreateSelection(sy, sx);
    this._selectionArea = this._RedrawSelectionPos(this.cells2(sy, sx).cell, this.cells2(ey, ex).cell);
    this._ShowSelection();
}

dhtmlXGridObject.prototype._OnSelectionStart = function(event, obj)
{

	var self = this;
	if (event.button == 2) return;
	var src = event.srcElement || event.target;
	if (this.editor){
		if (src.tagName && (src.tagName=="INPUT" || src.tagName=="TEXTAREA"))   return;
		this.editStop();
	}
	
	self.setActive(true);
	var pos = this.getPosition(this.obj);
	var x = event.clientX - pos[0] + (document.body.scrollLeft||(document.documentElement?document.documentElement.scrollLeft:0));
	var y = event.clientY - pos[1] + (document.body.scrollTop||(document.documentElement?document.documentElement.scrollTop:0));
	this._CreateSelection(x-4, y-4);

	if (src == this._selectionObj) {
		this._HideSelection();
		this._startSelectionCell = null;
	} else {
	    while (src && (!src.tagName || src.tagName.toLowerCase() != 'td'))
	        src = src.parentNode;
	    this._startSelectionCell = src;
	}
	
	if (this._startSelectionCell){
		if (!this.callEvent("onBeforeBlockSelected",[this._startSelectionCell.parentNode.idd, this._startSelectionCell._cellIndex]))
			return this._startSelectionCell = null;
	}
	
	    //this._ShowSelection();
	    this.obj.onmousedown = null;
		this.obj[_isIE?"onmouseleave":"onmouseout"] = function(e){ if (self._blsTimer) window.clearTimeout(self._blsTimer); };	    
		this.obj.onmmold=this.obj.onmousemove;
		this._init_pos=[x,y];
	    this._selectionObj.onmousemove = this.obj.onmousemove = function(e) {e = e||event; if (e.preventDefault) e.preventDefault(); else e.returnValue = false;  self._OnSelectionMove(e);}
	    
	    
	    this._oldDMP=document.body.onmouseup;
	    document.body.onmouseup = function(e) {e = e||event; self._OnSelectionStop(e, this); return true; }
	this.callEvent("onBeforeBlockSelection",[]);
	document.body.onselectstart = function(){return false};//avoid text select	    
}

dhtmlXGridObject.prototype._getCellByPos = function(x,y){
	x=x;//+this.objBox.scrollLeft;
	if (this._fake)
		x+=this._fake.objBox.scrollWidth;
	y=y;//+this.objBox.scrollTop;
	var _x=0;
	for (var i=0; i < this.obj.rows.length; i++) {
		y-=this.obj.rows[i].offsetHeight;
		if (y<=0) {
			_x=this.obj.rows[i];
			break;
		}
	}
	if (!_x || !_x.idd) return null;
	for (var i=0; i < this._cCount; i++) {
		x-=this.getColWidth(i);
		if (x<=0) {
			while(true){
				if (_x._childIndexes && _x._childIndexes[i+1]==_x._childIndexes[i])
					_x=_x.previousSibling;
				else {
					return this.cells(_x.idd,i).cell;
				}
				
			}
		}
	}
	return null;
}

dhtmlXGridObject.prototype._OnSelectionMove = function(event)
{ 
	
	var self=this;
	this._ShowSelection();
	var pos = this.getPosition(this.obj);
	var X = event.clientX - pos[0] + (document.body.scrollLeft||(document.documentElement?document.documentElement.scrollLeft:0));
	var Y = event.clientY - pos[1] + (document.body.scrollTop||(document.documentElement?document.documentElement.scrollTop:0));

	if ((Math.abs(this._init_pos[0]-X)<5) && (Math.abs(this._init_pos[1]-Y)<5)) return this._HideSelection();
	
	var temp = this._endSelectionCell;
	if(this._startSelectionCell==null)
 		this._endSelectionCell  = this._startSelectionCell = this.getFirstParentOfType(event.srcElement || event.target,"TD");		
	else
		if (event.srcElement || event.target) {
			if ((event.srcElement || event.target).className == "dhtmlxGrid_selection")
				this._endSelectionCell=(this._getCellByPos(X,Y)||this._endSelectionCell);
			else {
				var t = this.getFirstParentOfType(event.srcElement || event.target,"TD");
				if (t.parentNode.idd) this._endSelectionCell = t;
			}
		}
		
	if (this._endSelectionCell){
		if (!this.callEvent("onBeforeBlockSelected",[this._endSelectionCell.parentNode.idd, this._endSelectionCell._cellIndex]))
			this._endSelectionCell = temp;
	}
	
		/*
	//window.status = pos[0]+'+'+pos[1];
	var prevX = this._selectionObj.startX;
	var prevY = this._selectionObj.startY;
	var diffX = X - prevX;
	var diffY = Y - prevY;
	
	if (diffX < 0) {
        this._selectionObj.style.left = this._selectionObj.startX + diffX + 1+"px";
        diffX = 0 - diffX;
	} else {
		this._selectionObj.style.left = this._selectionObj.startX - 3+"px";
	}
	if (diffY < 0) {
		this._selectionObj.style.top = this._selectionObj.startY + diffY + 1+"px";
        diffY = 0 - diffY;
	} else {
		this._selectionObj.style.top = this._selectionObj.startY - 3+"px";
	}
    this._selectionObj.style.width = (diffX>4?diffX-4:0) + 'px';
    this._selectionObj.style.height = (diffY>4?diffY-4:0) + 'px';


/* AUTO SCROLL */
	var BottomRightX = this.objBox.scrollLeft + this.objBox.clientWidth;
	var BottomRightY = this.objBox.scrollTop + this.objBox.clientHeight;
	var TopLeftX = this.objBox.scrollLeft;
	var TopLeftY = this.objBox.scrollTop;

	var nextCall=false;
	if (this._blsTimer) window.clearTimeout(this._blsTimer);	
	
	if (X+20 >= BottomRightX) {
		this.objBox.scrollLeft = this.objBox.scrollLeft+20;
		nextCall=true;
	} else if (X-20 < TopLeftX) {
		this.objBox.scrollLeft = this.objBox.scrollLeft-20;
		nextCall=true;
	}
	if (Y+20 >= BottomRightY && !this._realfake) {
		this.objBox.scrollTop = this.objBox.scrollTop+20;
		nextCall=true;
	} else if (Y-20 < TopLeftY && !this._realfake) {
		this.objBox.scrollTop = this.objBox.scrollTop-20;
		nextCall=true;		
	}
	this._selectionArea = this._RedrawSelectionPos(this._startSelectionCell, this._endSelectionCell);
	

	if (nextCall){ 
		var a=event.clientX;
		var b=event.clientY;
		this._blsTimer=window.setTimeout(function(){self._OnSelectionMove({clientX:a,clientY:b})},100);
	}
	
}

dhtmlXGridObject.prototype._OnSelectionStop = function(event)
{
	var self = this;
	if (this._blsTimer) window.clearTimeout(this._blsTimer);	
	this.obj.onmousedown = function(e) {if (self._bs_mode)  self._OnSelectionStart((e||event), this); return true;}
	this.obj.onmousemove = this.obj.onmmold||null;
	this._selectionObj.onmousemove = null;
	document.body.onmouseup = this._oldDMP||null;
	if ( parseInt( this._selectionObj.style.width ) < 2 && parseInt( this._selectionObj.style.height ) < 2) {
		this._HideSelection();
	} else {
	    var src = this.getFirstParentOfType(event.srcElement || event.target,"TD");
	    if ((!src) || (!src.parentNode.idd)){
	    	src=this._endSelectionCell;
    		}
	    while (src && (!src.tagName || src.tagName.toLowerCase() != 'td'))
	        src = src.parentNode;
	    if (!src) 
	    	return this._HideSelection();
	    this._stopSelectionCell = src;
	    this._selectionArea = this._RedrawSelectionPos(this._startSelectionCell, this._stopSelectionCell);
		this.callEvent("onBlockSelected",[]);
	}
	document.body.onselectstart = function(){};//avoid text select
}

dhtmlXGridObject.prototype._RedrawSelectionPos = function(LeftTop, RightBottom)
{

	if (LeftTop.parentNode.grid != RightBottom.parentNode.grid)
		return this._selectionArea;

//	td._cellIndex
//
//	getRowIndex
	var pos = {};
	pos.LeftTopCol = LeftTop._cellIndex;
	pos.LeftTopRow = this.getRowIndex( LeftTop.parentNode.idd );
	pos.RightBottomCol = RightBottom._cellIndex;
	pos.RightBottomRow = this.getRowIndex( RightBottom.parentNode.idd );

	var LeftTop_width = LeftTop.offsetWidth;
	var LeftTop_height = LeftTop.offsetHeight;
	LeftTop = this.getPosition(LeftTop, this.obj);

	var RightBottom_width = RightBottom.offsetWidth;
	var RightBottom_height = RightBottom.offsetHeight;
	RightBottom = this.getPosition(RightBottom, this.obj);

    if (LeftTop[0] < RightBottom[0]) {
		var Left = LeftTop[0];
		var Right = RightBottom[0] + RightBottom_width;
    } else {
    	var foo = pos.RightBottomCol;
        pos.RightBottomCol = pos.LeftTopCol;
        pos.LeftTopCol = foo;
		var Left = RightBottom[0];
		var Right = LeftTop[0] + LeftTop_width;
    }

    if (LeftTop[1] < RightBottom[1]) {
		var Top = LeftTop[1];
		var Bottom = RightBottom[1] + RightBottom_height;
    } else {
    	var foo = pos.RightBottomRow;
        pos.RightBottomRow = pos.LeftTopRow;
        pos.LeftTopRow = foo;
		var Top = RightBottom[1];
		var Bottom = LeftTop[1] + LeftTop_height;
    }

    var Width = Right - Left;
    var Height = Bottom - Top;

	this._selectionObj.style.left = Left + 'px';
	this._selectionObj.style.top = Top + 'px';
	this._selectionObj.style.width =  Width  + 'px';
	this._selectionObj.style.height = Height + 'px';
	return pos;
}

dhtmlXGridObject.prototype._CreateSelection = function(x, y)
{
	if (this._selectionObj == null) {
		var div = document.createElement('div');
		div.style.position = 'absolute';
        div.style.display = 'none';
        div.className = 'dhtmlxGrid_selection';
		this._selectionObj = div;
		this._selectionObj.onmousedown = function(e){
			e=e||event;
			if (e.button==2 || (_isMacOS&&e.ctrlKey))
				return this.parentNode.grid.callEvent("onBlockRightClick", ["BLOCK",e]);
		}
		this._selectionObj.oncontextmenu=function(e){(e||event).cancelBubble=true;return false;}
		this.objBox.appendChild(this._selectionObj);
	}
    //this._selectionObj.style.border = '1px solid #83abeb';
    this._selectionObj.style.width = '0px';
    this._selectionObj.style.height = '0px';
    //this._selectionObj.style.border = '0px';
	this._selectionObj.style.left = x + 'px';
	this._selectionObj.style.top  = y + 'px';
    this._selectionObj.startX = x;
    this._selectionObj.startY = y;
}

dhtmlXGridObject.prototype._ShowSelection = function()
{
	if (this._selectionObj)
	    this._selectionObj.style.display = '';
}

dhtmlXGridObject.prototype._HideSelection = function()
{
	
	if (this._selectionObj)
	    this._selectionObj.style.display = 'none';
    this._selectionArea = null;
    if (this._clip_area){
    	this._clip_area.value="";
    	this._clip_area.blur();
    }
}
/**
*     @desc: copy content of block selection into clipboard in csv format (delimiter as set for csv serialization)
*     @type: public
*     @topic: 0
*/
dhtmlXGridObject.prototype.copyBlockToClipboard = function()
{
	if (!this._clip_area) return;

	if ( this._selectionArea != null ) {
		var serialized = new Array();
	if (this._mathSerialization)
         this._agetm="getMathValue";
    else if (this._strictText)
    	this._agetm="getTitle";
    else this._agetm="getValue";

    this._serialize_visible = true;

		for (var i=this._selectionArea.LeftTopRow; i<=this._selectionArea.RightBottomRow; i++) {
			var data = this._serializeRowToCVS(this.rowsBuffer[i], null,  this._selectionArea.LeftTopCol, this._selectionArea.RightBottomCol+1);
			if (!this._csvAID)
				serialized[serialized.length] = data.substr( data.indexOf( this.csv.cell ) + 1 );	//remove row ID and add to array
			else
				serialized[serialized.length] = data;
		}
		serialized = serialized.join(this._CSVRowDelimiter);
		
		this._clip_area.value = serialized;
        this._clip_area.select();

	this._serialize_visible = false;
	}
}
/**
*     @desc: paste content of clipboard into block selection of grid
*     @type: public
*     @topic: 0
*/
dhtmlXGridObject.prototype.pasteBlockFromClipboard = function(){
	if (!this._clip_area) return;

	this._clip_area.select();
    var self = this;
    window.setTimeout(function(){
        self._pasteBlockFromClipboard();
        self=null;
    },1);
}
dhtmlXGridObject.prototype._pasteBlockFromClipboard = function()
{
	var serialized = this._clip_area.value;
	if (!serialized) return;

    if (this._selectionArea != null) {
        var startRow = this._selectionArea.LeftTopRow;
        var startCol = this._selectionArea.LeftTopCol;
    } else if (this.cell != null && !this.editor) {
        var startRow = this.getRowIndex( this.cell.parentNode.idd );
        var startCol = this.cell._cellIndex;
    } else {
        return false;
    }

	serialized = this.csvParser.unblock(serialized, this.csv.cell, this.csv.row);

    var endRow = startRow+serialized.length;
    var endCol = startCol+serialized[0].length;
    if (endCol > this._cCount)
		endCol = this._cCount;
    var k = 0;
    for (var i=startRow; i<endRow; i++) {
        var row = this.render_row(i);
        if (row==-1) continue;
        var l = 0;
        for (var j=startCol; j<endCol; j++) {
        	if (this._hrrar[j] && !this._fake){
        		endCol = Math.min(endCol+1, this._cCount);
        		continue;
        	}
        	var ed = this.cells3(row, j);
        	if (ed.isDisabled()) {
        	    l++;
        	    continue;
        	}
        	if (this._onEditUndoRedo)
        		this._onEditUndoRedo(2, row.idd, j, serialized[ k ][ l ], ed.getValue());
        	if (ed.combo){
				var comboVa = ed.combo.values;
				for(var n=0; n<comboVa.length; n++)
					if (serialized[ k ][ l ] == comboVa[n]){
						ed.setValue( ed.combo.keys[ n ]);
						comboVa=null;
						break;
					}
				if (comboVa!=null && ed.editable) ed.setValue( serialized[ k ][ l++ ] );
				else l++;
        	}else
        		ed[ ed.setImage ? "setLabel" : "setValue" ]( serialized[ k ][ l++ ] );
        	ed.cell.wasChanged=true;
        }
        this.callEvent("onRowPaste",[row.idd])
        k++;
    }
    // custom (강신영) 붙여넣기 완료 시 호출 추가함
	this.callEvent("onEndPaste",null);
}

dhtmlXGridObject.prototype.getSelectedBlock = function() {
	// if block selection exists
	if (this._selectionArea)
		return this._selectionArea;
	else if (this.getSelectedRowId() !== null){
		// if one cell is selected
			return {
				LeftTopRow: this.getSelectedRowId(),
				LeftTopCol: this.getSelectedCellIndex(),
				RightBottomRow: this.getSelectedRowId(),
				RightBottomCol: this.getSelectedCellIndex()
			};
		} else
			return null;
};
//(c)dhtmlx ltd. www.dhtmlx.com


/* #Customized (조승현) 시작 : 붙여넣기시 필요한 로우수만큼 자동으로 늘려 붙여넣기*/
dhtmlXGridObject.prototype.autoAddRowPasteBlockFromClipboard = function(standardColumnId, deleteDuplication, overrideDuplication, editableColumnIdListOfInsertedRows, notEditableColumnIdListOfInsertedRows){
	if (!this._clip_area) return;

	this._clip_area.select();
    var self = this;
    window.setTimeout(function(){
        self._autoAddRowPasteBlockFromClipboard(standardColumnId, deleteDuplication, overrideDuplication, editableColumnIdListOfInsertedRows, notEditableColumnIdListOfInsertedRows);
        self=null;
    },1);
}
dhtmlXGridObject.prototype._autoAddRowPasteBlockFromClipboard = function(standardColumnId, deleteDuplication, overrideDuplication, editableColumnIdListOfInsertedRows, notEditableColumnIdListOfInsertedRows)
{
	var serialized = this._clip_area.value;
	if (!serialized) return;

	var userSelectType;
    if (this._selectionArea != null) {
    	userSelectType = 1;
        var startRow = this._selectionArea.LeftTopRow;
        var startCol = this._selectionArea.LeftTopCol;
    } else if (this.cell != null && !this.editor) {
    	userSelectType = 2;
        var startRow = this.getRowIndex( this.cell.parentNode.idd );
        var startCol = this.cell._cellIndex;
        var tempCell = this.cells(this.row.idd, this.cell._cellIndex);
    } else {
    	userSelectType = 3;
    	if(standardColumnId && typeof standardColumnId == "string"){
    		if(this.getRowId(0) == "NoDataPrintRow"){
    			$erp.clearDhtmlXGrid(this);
    		}
    		var startRow = this.getRowsNum();
    	    var startCol = this.getColIndexById(standardColumnId);
    	}else{
    		var uid = this.uid();
    		this.addRow(uid);
    		
        	$erp.alertMessage({
    			"alertMessage" : "붙여넣기할 시작위치(셀)를 선택해주세요.",
    			"alertType" : "error",
    			"isAjax" : false
    		});
        	
            return false;
    	}
    }
    
    if(window["static_total_layout"] && window["static_total_layout"] instanceof dhtmlXLayoutObject){
    	window["static_total_layout"].progressOff();
    	window["static_total_layout"].progressOn();
    }

    setTimeout(function(){
		serialized = this.csvParser.unblock(serialized, this.csv.cell, this.csv.row);
		var tempDataList = $erp.dataSerializeOfGrid(this);
		var tempEndRowIndex = this.getRowsNum() - 1;
		if((standardColumnId && typeof standardColumnId == "string")){
			var tempEndRow = this.getRowsNum();
			var checkCell;
			var checkCellColumnId;
			for (var i=startRow; i<tempEndRow; i++) { // 선택한 시작 로우가 있을때
				for(var ii=startCol; ii<this.getColumnsNum(); ii++){
					checkCell = this.cells(this.getRowId(i), ii);
					checkCellColumnId = this.getColumnId(ii);
					if (
							(checkCell.isDisabled() && checkCellColumnId == standardColumnId) 							//로우의 기준컬럼이 수정 불가할때
							|| (userSelectType == 1 && checkCellColumnId == standardColumnId) 							//유저가 현재 그리드에 범위 선택을 한 상태일때
							|| (userSelectType == 2 && checkCellColumnId == standardColumnId && tempCell.isDisabled())	//유저 선택한 셀이 있는데 그셀이 수정 불가 셀일 경우
																								) {
						startRow++;
					}
				}
			}
		}
		var enoughRowsNum = tempEndRowIndex - (startRow + (serialized.length - 1));
		
		var dp = this.getDataProcessor();
		
		if(enoughRowsNum < 0){
			for(var i = 0; i<-enoughRowsNum; i++){
				tempDataList.push({CRUD:"C",pasteCreate:true});
			}
			
			this.parse(tempDataList,"js");
			
			if(		   (editableColumnIdListOfInsertedRows && editableColumnIdListOfInsertedRows.constructor == Array)
					|| (notEditableColumnIdListOfInsertedRows && notEditableColumnIdListOfInsertedRows.constructor == Array)	){
				
				var rowIndexList = [];
				for(var index in tempDataList){
					if(tempDataList[index]["CRUD"] == "C"){
						rowIndexList.push(index);
					}
				}
				
				if(editableColumnIdListOfInsertedRows && editableColumnIdListOfInsertedRows.constructor == Array){
					$erp.rowsEditableManagement(this, rowIndexList, editableColumnIdListOfInsertedRows);
				}
				
				if(notEditableColumnIdListOfInsertedRows && notEditableColumnIdListOfInsertedRows.constructor == Array){
					$erp.rowsNotEditableManagement(this, rowIndexList, notEditableColumnIdListOfInsertedRows);
				}
				
			}
			
			
			var state;
			if(dp){
				for(var index in tempDataList){
					state = tempDataList[index]["CRUD"];
					if(state == "C"){
						dp.setUpdated(this.getRowId(index), true, "inserted");
					}else if(state == "U"){
						dp.setUpdated(this.getRowId(index), true, "updated");
					}else if(state == "D"){
						dp.setUpdated(this.getRowId(index), true, "deleted");
					}
				}
			}
		}
	
	    var endRow = startRow+serialized.length;
	    var endCol = startCol+serialized[0].length;
	    if (endCol > this._cCount)
			endCol = this._cCount;
	    var k = 0;
	    var pasteTargetRowIndexObj = {};
	    var cellType;
	    for (var i=startRow; i<endRow; i++) {
	        var row = this.render_row(i);
	        if (row==-1) continue;
	        var l = 0;
	        for (var j=startCol; j<endCol; j++) {
	        	if (this._hrrar[j] && !this._fake){
	        		endCol = Math.min(endCol+1, this._cCount);
	        		continue;
	        	}
	        	var ed = this.cells3(row, j);
	//        	if (ed.isDisabled() && tempDataList[i]["CRUD"] != "C") { //새로생성된 로우가 아니고 수정불가 셀이라면 continue
	        	if (ed.isDisabled()) {
	        	    l++;
	        	    continue;
	        	}
	        	
	        	//새로 생성된 로우라면 셀타입 변경
	        	cellType = this.getCellExcellType(row.idd, j)
	        	if(cellType == "ro"){
	        		this.setCellExcellType(row.idd, j, "ed");
	        	}else if(cellType == "ron"){
	        		this.setCellExcellType(row.idd, j, "edn");
	        	}
	        	
	        	if (this._onEditUndoRedo){
	        		this._onEditUndoRedo(2, row.idd, j, serialized[ k ][ l ], ed.getValue());
	        	}
	        	if (ed.combo){
					var comboVa = ed.combo.values;
					for(var n=0; n<comboVa.length; n++)
						if (serialized[ k ][ l ] == comboVa[n]){
							ed.setValue( ed.combo.keys[ n ]);
							comboVa=null;
							break;
						}
					if (comboVa!=null && ed.editable){
						ed.setValue( serialized[ k ][ l++ ] );
					}else{
						l++;
					}
	        	}else{
	        		if(cellType == "dhxCalendarA"){
	        			ed[ ed.setImage ? "setLabel" : "setValue" ]( serialized[ k ][ l ].replace(/-/g,""));
	        			l++;
	        		}else{
	        			ed[ ed.setImage ? "setLabel" : "setValue" ]( serialized[ k ][ l++ ] );
	        		}
	        	}
	        	ed.cell.wasChanged=true;
	        }
	        pasteTargetRowIndexObj[i] = i;
	        this.callEvent("onRowPaste",[row.idd]);
	        k++;
	    }
	    
		var countObjByStandardColumnValue = {}; //기준 컬럼 값별 개수 
		var standardColumnIndex = null;
		var duplicationRowIndexList = [];
		var duplicationRowIdList = [];
		var newAddRowDataList = []; //붙여넣기 영향을 받은 로우 데이타 리스트
		var beforeDuplicationCount = 0;
		var afterDuplicationCount = 0;
		var tempKeyfirstRowIndexObj = {};
		if(standardColumnId){
			standardColumnIndex = this.getColIndexById(standardColumnId); //중복 검사할 컬럼 인덱스
			
			var isExistDuplicateInDB = false; //true : DB내에 중복 데이터가 존재함
		
			var key;
			var rowId;
			var firstRowId;
			var columnType;
			var rowLength = this.getRowsNum();
			var columnLength = this.getColumnsNum();
			for(var index = 0; index< rowLength; index++){
				rowId = this.getRowId(index);
				key = this.cells(rowId, standardColumnIndex).getValue();
				
				if(countObjByStandardColumnValue[key] == undefined){
					countObjByStandardColumnValue[key] = 0;
					tempKeyfirstRowIndexObj[key] = index;
				}else{
					countObjByStandardColumnValue[key] = ++countObjByStandardColumnValue[key];
					
					if(dp && dp.getState(rowId) != "inserted"){
						isExistDuplicateInDB = true;
					}else{
						duplicationRowIndexList.push(index);
						duplicationRowIdList.push(rowId);
						
						if(tempKeyfirstRowIndexObj[key] < startRow){
							beforeDuplicationCount++;
						}else{
							afterDuplicationCount++;
						}
					}
					
					if(overrideDuplication != undefined && overrideDuplication != null && overrideDuplication === false){
						continue;
					}
					
					if(index < endRow){
						firstRowId = this.getRowId(tempKeyfirstRowIndexObj[key]);
						for(var index2 = 0; index2< columnLength; index2++){
							columnType = this.columnsMapArray[index2]["type"];
							if(columnType == "ro"){
								continue;
							}
							this.cells(firstRowId, index2).setValue(this.cells(rowId, index2).getValue());
						}
					}
				}
			}
			
			if(deleteDuplication == true && j == standardColumnIndex != null){ //중복을 허용 하지 않으면서 중복 제거 컬럼인덱스가 존재할시
				$erp.deleteGridRows(this, duplicationRowIndexList, editableColumnIdListOfInsertedRows, notEditableColumnIdListOfInsertedRows); //그리드객체, 삭제할 로우인덱스리스트
			}
		}
		
		var data;
		var standardColumnValue_indexAndRowId_obj = {};
		var state;
		var insertedRowIndexList = [];
		var requestAddRowCount = serialized.length;
		var finalPasteRowDataListCount = 0;
		for(var index=0; index<this.getRowsNum(); index++){
			rowId = this.getRowId(index);
			if(dp){
				state = dp.getState(rowId);
				if(state == "inserted"){
					insertedRowIndexList.push(index);
				}
			}
			if(index < startRow){
				continue;
			}
			data = $erp.dataSerializeOfGridRow(this, rowId);
			if(finalPasteRowDataListCount < requestAddRowCount - beforeDuplicationCount - afterDuplicationCount){
				newAddRowDataList.push(data);
				finalPasteRowDataListCount++;
			}
			
			if(standardColumnId){
				standardColumnValue_indexAndRowId_obj[data[standardColumnId]] = [index, rowId];
			}
		}
		
//		console.log("finalPasteRowDataListCount : " + finalPasteRowDataListCount); 
//		console.log("requestAddRowCount : " + requestAddRowCount); 
//		console.log("beforeDuplicationCount : " + beforeDuplicationCount); 
//		console.log("afterDuplicationCount : " + afterDuplicationCount); 
		
		var result = {};
		result["requestAddRowCount"] = requestAddRowCount;											//아무런 처리없이 추가 요청한 데이터 초기 로우수
		result["newAddRowDataList"] = newAddRowDataList;											//새로 추가된 로우 데이타 리스트
		result["standardColumnValue_indexAndRowId_obj"] = standardColumnValue_indexAndRowId_obj;	//기준 컬럼의 값을 key, [인덱스,로우아이디]를 value 로 가진 객체
		result["insertedRowIndexList"] = insertedRowIndexList;										//로우 상태가 inserted 인 로우인덱스 리스트
		result["editableColumnIdListOfInsertedRows"] = editableColumnIdListOfInsertedRows;			//로우 상태가 inserted 인 로우의 수정가능한 컬럼 Id 리스트
		result["notEditableColumnIdListOfInsertedRows"] = notEditableColumnIdListOfInsertedRows;	//로우 상태가 inserted 인 로우의 수정불가능한 컬럼 Id 리스트
		result["duplicationCount_in_toGridDataList"] = duplicationRowIndexList.length;				//toGrid 에 추가중 발생한 중복 데이터 개수
//		result["countObjByStandardColumnValue"] = countObjByStandardColumnValue;					//기준 컬럼 값별 개수

		if(window["static_total_layout"] && window["static_total_layout"] instanceof dhtmlXLayoutObject){
			window["static_total_layout"].progressOff();
		}
		
		this.callEvent("onEndPaste",[result]);
    }.bind(this),10);
}
/* #Customized (조승현) 끝 : */