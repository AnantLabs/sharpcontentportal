//BEGIN [Needed in case scripts load out of order]
if (typeof(scp_control) == 'undefined')
	eval('function scp_control() {}')
//END [Needed in case scripts load out of order]

scp_control.prototype.initTextSuggest = function (oCtl) 
{
	//TODO:DETERMINE WHEN TO LOAD THIS
	//Extends is better than inherits cause inherits overwrites any functions we may have defined specific to scpTextSuggestNode
	scp.extend(scp.controls.scpTextSuggestNode.prototype, new scp.controls.scpNode);
	//scp.controls.scpTextSuggestNode.prototype = new scp.controls.scpNode;
	
	scp.controls.controls[oCtl.id] = new scp.controls.scpTextSuggest(oCtl);
	return scp.controls.controls[oCtl.id];
}

//------- Constructor -------//
scp_control.prototype.scpTextSuggest = function (o)
{
	this.ns = o.id;               //stores namespace for menu
	this.container = o;                    //stores container
	this.resultCtr = null;
	this.DOM = null;
	//--- Appearance Properties ---//
	this.tscss = scp.dom.getAttr(o, 'tscss', '');
	this.css = scp.dom.getAttr(o, 'css', '');
	this.cssChild = scp.dom.getAttr(o, 'csschild', '');
	this.cssHover = scp.dom.getAttr(o, 'csshover', '');
	this.cssSel = scp.dom.getAttr(o, 'csssel', '');
	this.cssIcon = scp.dom.getAttr(o, 'cssicon', '');

	this.sysImgPath = scp.dom.getAttr(o, 'sysimgpath', '');
	this.workImg = 'scpanim.gif';
		
	this.target = scp.dom.getAttr(o, 'target', '');	
	this.defaultJS = scp.dom.getAttr(o, 'js', '');	
	
	this.postBack = scp.dom.getAttr(o, 'postback', '');
	this.callBack = scp.dom.getAttr(o, 'callback', '');
	this.callBackStatFunc = scp.dom.getAttr(o, 'callbackSF', '');
	//if (this.callBackStatFunc != null)
	//	this.callBackStatFunc = eval(this.callBackStatFunc);
		
	this.rootNode=null;
	this.selNode=null;  
	this.selIndex=-1;
	//this.delay = new Array();
	this.lookupDelay = scp.dom.getAttr(o, 'ludelay', '500');
	this.lostFocusDelay = scp.dom.getAttr(o, 'lfdelay', '500');

	this.anim = scp.dom.getAttr(o, 'anim', '');	//expand
	this.inAnimObj = null;
	this.inAnimType = null;
	this.prevText = '';	
	scp.dom.addSafeHandler(o, 'onkeyup', this, 'keyUp');
	//scp.dom.addSafeHandler(o, 'onkeydown', this, 'keyDown');
	scp.dom.addSafeHandler(o, 'onkeypress', this, 'keyPress');
	scp.dom.addSafeHandler(o, 'onblur', this, 'onblur');
	scp.dom.addSafeHandler(o, 'onfocus', this, 'onfocus');

	o.setAttribute('autocomplete', 'off');	
	this.delimiter = scp.dom.getAttr(o, 'del', '');
	this.idtoken = scp.dom.getAttr(o, 'idtok', '');
	this.maxRows = new Number(scp.dom.getAttr(o, 'maxRows', '10'));
	if (this.maxRows == 0)
		this.maxRows = 9999;
	this.minChar = new Number(scp.dom.getAttr(o, 'minChar', '1'));
	this.caseSensitive = scp.dom.getAttr(o, 'casesens', '0') == '1';


	this.prevLookupText = '';
	this.prevLookupOffset = 0;	
}

scp_control.prototype.scpTextSuggest.prototype = 
{
//--- Event Handlers ---//

keyPress: function (e, element) 
{
	var KEY_RETURN = 13;
	if(e.keyCode == KEY_RETURN)	//stop from posting
		return false;
},

onblur: function (e, element) 
{
	scp.doDelay(this.ns + 'ob', this.lostFocusDelay, scp.dom.getObjMethRef(this, 'blurHide'));
},

onfocus: function (e, element) 
{
	scp.cancelDelay(this.ns + 'ob');
},

blurHide: function()
{
	this.clearResults(true);
},

keyUp: function (e, element) 
{
	var KEY_UP_ARROW = 38;
	var KEY_DOWN_ARROW = 40;
	var KEY_RETURN = 13;
	var KEY_ESCAPE = 27;
	this.prevText = this.container.value;
	if (e.keyCode == KEY_UP_ARROW)
		this.setNodeIndex(this.selIndex - 1);
	else if(e.keyCode == KEY_DOWN_ARROW)
		this.setNodeIndex(this.selIndex + 1);
	else if(e.keyCode == KEY_RETURN)
	{
		if (this.selIndex > -1)
		{
			this.selectNode(this.getNodeByIndex(this.selIndex));
			this.clearResults(true);
		}
	}
	else if(e.keyCode == KEY_ESCAPE)
		this.clearResults(true);
	else
	{
		scp.cancelDelay(this.ns + 'kd');
		scp.doDelay(this.ns + 'kd', this.lookupDelay, scp.dom.getObjMethRef(this, 'doLookup'));	
	}
		
},

nodeMOver: function(evt, element)
{
	var oNode = this.DOM.findNode('n', 'id', element.nodeid);
	if (oNode != null)
	{
		var oTSNode = new scp.controls.scpTextSuggestNode(oNode);
		oTSNode.hover = true;
		this.assignCss(oTSNode);
	}
},

nodeMOut: function(evt, element)
{
	var oNode = this.DOM.findNode('n', 'id', element.nodeid);
	if (oNode != null)
	{
		var oTSNode = new scp.controls.scpTextSuggestNode(oNode);
		oTSNode.hover = false;
		this.assignCss(oTSNode);
	}
},

nodeClick: function(evt, element)
{
	var oNode = this.DOM.findNode('n', 'id', element.nodeid);
	if (oNode != null)
	{
		var oTSNode = new scp.controls.scpTextSuggestNode(oNode);
		this.selectNode(oTSNode);
		this.clearResults(true);
	}
},

// Methods
getTextOffset: function () 
{
	var iOffset = 0;
	if (this.delimiter.length > 0)
	{
		var ary = this.container.value.split(this.delimiter);
		var iPos = scp.dom.cursorPos(this.container);
		var iLen = 0;
		for (iOffset=0; iOffset<ary.length-1; iOffset++)
		{
			iLen += ary[iOffset].length + 1;
			if (iLen > iPos)
				break;
		}
	}
	return iOffset;
},

setText: function (s, id) 
{
	if (this.idtoken.length > 0)
		s += ' ' + this.idtoken.replace('~', id);
		
	if (this.delimiter.length > 0)
	{
		var ary = this.container.value.split(this.delimiter);
		ary[this.getTextOffset()] = s;

		this.container.value = ary.join(this.delimiter);
		if (this.container.value.lastIndexOf(this.delimiter) != this.container.value.length - 1)
			this.container.value += this.delimiter;
		
	}
	else
		this.container.value = s;

	this.prevText = this.container.value;
},

getText: function () 
{
	if (this.delimiter.length > 0 && this.container.value.indexOf(this.delimiter) > -1)
	{
		var ary = this.container.value.split(this.delimiter);
		return ary[this.getTextOffset()];
	}
	else
		return this.container.value;
},

formatText: function (s) 
{
	if (this.caseSensitive)
		return s;
	else
		return s.toLowerCase();
},

highlightNode: function(iIndex, bHighlight)
{
	if (iIndex > -1)
	{
		var oTSNode = this.getNodeByIndex(iIndex);
		oTSNode.hover = bHighlight;
		this.assignCss(oTSNode);				
	}
},

getNodeByIndex: function(iIndex)
{
	var oEl = this.resultCtr.childNodes[iIndex];
	if (oEl)
	{
		var oNode = this.rootNode.findNode('n', 'id', oEl.nodeid);
		if (oNode)
			return new scp.controls.scpTextSuggestNode(oNode);
	}
},

setNodeIndex: function(iIndex)
{
	if (iIndex > -1 && iIndex < this.resultCtr.childNodes.length)
	{
		this.highlightNode(this.selIndex, false);
		this.selIndex = iIndex;
		this.highlightNode(this.selIndex, true);
	}
},

selectNode: function (oTSNode) 
{		
	if (this.selNode != null)
	{
		this.selNode.selected = null;
		this.assignCss(this.selNode);
	}		
	
	if (oTSNode.selected)
	{
		oTSNode.selected = null;
		this.assignCss(oTSNode);
	}
	else
	{
		oTSNode.selected = true;
		this.assignCss(oTSNode);
	}
	
	this.selNode = oTSNode;

	if (oTSNode.selected)
	{
		this.setText(oTSNode.text, oTSNode.id);
		var sJS = '';
		if (this.defaultJS.length > 0)
			sJS = this.defaultJS;
		if (oTSNode.js.length > 0)
			sJS = oTSNode.js;
		
		if (sJS.length > 0)
		{
			if (eval(sJS) == false)
				return;	//don't do postback if returns false
		}
		
		if (oTSNode.clickAction == null || oTSNode.clickAction == scp.controls.action.postback)
			eval(this.postBack.replace('[TEXT]', this.getText()));
		else if (oTSNode.clickAction == scp.controls.action.nav)
			scp.dom.navigate(oTSNode.url, oTSNode.target.length > 0 ? oTSNode.target : this.target);
	}
	return true;		
},

positionMenu: function ()
{
	var oPDims = new scp.dom.positioning.dims(this.container);
	this.resultCtr.style.left = oPDims.l - scp.dom.positioning.bodyScrollLeft();			
	this.resultCtr.style.top = oPDims.t + oPDims.h;
},

showResults: function()
{
	if (this.resultCtr)
		this.resultCtr.style.display = '';
},

hideResults: function()
{
	if (this.resultCtr)
		this.resultCtr.style.display = 'none';
},

clearResults: function (bHide) 
{
	if (this.resultCtr != null)
		this.resultCtr.innerHTML = '';
	this.selIndex = -1;
	this.selNode = null;
	if (bHide)
		this.hideResults();
},

clear: function () 
{
	this.clearResults();
	this.setText('', '');
},

doLookup: function () 
{
	if (this.getText().length >= this.minChar)
	{
		if (this.needsLookup())
		{
			this.prevLookupOffset = this.getTextOffset();
			this.prevLookupText = this.formatText(this.getText());
			eval(this.callBack.replace('[TEXT]', this.prevLookupText));
		}
		else
			this.renderResults(null);
	}
	else
		this.clearResults();
},

needsLookup: function () 
{
	if (this.DOM == null)
		return true;

	if (this.prevLookupOffset != this.getTextOffset() || this.rootNode == null)
		return true;

	if (this.formatText(this.getText()).indexOf(this.prevLookupText) == 0)	//if starts with previous lookup
	{
		if (this.rootNode.childNodeCount() < this.maxRows)	//if rows are less than max, don't need lookup
			return false;
		
		var oNode;
		var bOneMatch = false;
		var sText = this.getText();
		for (var i=0; i<this.maxRows; i++)
		{
			oNode = new scp.controls.scpTextSuggestNode(this.rootNode.childNodes(i));
			if (this.formatText(oNode.text).indexOf(sText) == 0)	
			{
				if (i==0)	//if first shown node hasn't changed
					return false;
				else 
					bOneMatch = true;
			}
			else if (bOneMatch)	//if found match and a row following has no match then we dont need lookup
				return false;
		}		
	}

	return true;

},

renderResults: function (sXML) 
{
	if (sXML != null)
	{
		this.DOM = new scp.xml.createDocument();
		this.DOM.loadXml(sXML);
	}
	this.rootNode = this.DOM.rootNode();
	if (this.rootNode != null)
	{
		if (this.resultCtr == null)
			this.renderContainer();
			
		this.clearResults();
		for (var i=0; i<this.rootNode.childNodeCount(); i++)
			this.renderNode(this.rootNode.childNodes(i), this.resultCtr);
		this.showResults();
	}
},

renderContainer: function () 
{
	this.resultCtr = document.createElement('DIV');
	this.container.parentNode.appendChild(this.resultCtr);

	this.resultCtr.className = this.tscss;
	this.resultCtr.style.position = 'absolute';
	this.positionMenu();
},

renderNode: function (oNode, oCont) 
{
	var oTSNode;		
	oTSNode = new scp.controls.scpTextSuggestNode(oNode);
	//text must be prefixed by value we are looking for and we must be under the maxRows
	if (this.formatText(oTSNode.text).indexOf(this.formatText(this.getText())) == 0 && oCont.childNodes.length < this.maxRows)
	{
		var oNewContainer = this.createChildControl('DIV', oTSNode.id, 'ctr'); //container for Node
		oNewContainer.appendChild(this.renderText(oTSNode));	//render text

		if (oTSNode.enabled)
		{
			scp.dom.addSafeHandler(oNewContainer, 'onclick', this, 'nodeClick');
			scp.dom.addSafeHandler(oNewContainer, 'onmouseover', this, 'nodeMOver');
			scp.dom.addSafeHandler(oNewContainer, 'onmouseout', this, 'nodeMOut');
		}

		if (oTSNode.toolTip.length > 0)
			oNewContainer.title = oTSNode.toolTip;
			
		oCont.appendChild(oNewContainer);
		this.assignCss(oTSNode);
	}
},

renderText: function (oTSNode) 
{
	var oSpan = this.createChildControl('SPAN', oTSNode.id, 't'); //document.createElement('SPAN');
	oSpan.innerHTML = oTSNode.text;	
	oSpan.style.cursor = 'pointer';
	
	return oSpan;
},

assignCss: function (oTSNode)
{
	var oCtr = this.getChildControl(oTSNode.id, 'ctr'); //scp.dom.getById(__dm_getControlID(this.ns, oTSNode.id, 'ctr'));//, this.container);
	var sNodeCss = this.css;

	if (oTSNode.css.length > 0)
		sNodeCss = oTSNode.css;

	if (oTSNode.hover)
		sNodeCss += ' ' + (oTSNode.cssHover.length > 0 ? oTSNode.cssHover : this.cssHover);
	if (oTSNode.selected)
		sNodeCss += ' ' + (oTSNode.cssSel.length > 0 ? oTSNode.cssSel : this.cssSel);
	
	oCtr.className = sNodeCss;
},

callBackStatus: function (result, ctx) 
{
	var oText = ctx;
	
	if (oText.callBackStatFunc != null && oText.callBackStatFunc.length > 0)
	{
		var oPointerFunc = eval(oText.callBackStatFunc);
		oPointerFunc(result, ctx);	
	}
	
},

callBackSuccess: function (result, ctx) 
{
	var oText = ctx;
	if (oText.callBackStatFunc != null && oText.callBackStatFunc.length > 0)
	{
		var oPointerFunc = eval(oText.callBackStatFunc);
		oPointerFunc(result, ctx);	
	}
	oText.renderResults(result);

},

callBackFail: function (result, ctx) 
{
	alert(result);
},

createChildControl: function (sTag, sNodeID, sPrefix)
{
	var oCtl = document.createElement(sTag);
	oCtl.ns = this.ns;
	oCtl.nodeid = sNodeID;
	oCtl.id = this.ns + sPrefix + sNodeID; //__dm_getControlID(oCtl.ns, oCtl.nodeid, sPrefix);	
	return oCtl;
}, 

getChildControl: function (sNodeID, sPrefix)
{
	return scp.dom.getById(this.ns + sPrefix + sNodeID);
}

}//end scpTextSuggest prototype


scp_control.prototype.scpTextSuggestNode = function (oNode)
{
	this.base = scp.controls.scpNode;
	this.base(oNode);	//invoke base class constructor

	//textsuggest specific attributes
	this.hover = false;
	this.selected = oNode.getAttribute('selected', '0') == '1' ? true : null;
	this.clickAction = oNode.getAttribute('ca', scp.controls.action.none);
}

//scpTextSuggestNode specific methods
scp_control.prototype.scpTextSuggestNode.prototype = 
{
childNodes: function (iIndex)
{
	if (this.node.childNodes[iIndex] != null)
		return new scp.controls.scpTextSuggestNode(this.node.childNodes[iIndex]);
}
}

//BEGIN [Needed in case scripts load out of order]
if (typeof(scp_controls) != 'undefined')
{
	scp.extend(scp_controls.prototype, scp_control.prototype);
	scp.controls = new scp_controls();
}
//END [Needed in case scripts load out of order]