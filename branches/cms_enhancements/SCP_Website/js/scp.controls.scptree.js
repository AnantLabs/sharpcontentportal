//BEGIN [Needed in case scripts load out of order]
if (typeof(scp_control) == 'undefined')
	eval('function scp_control() {}')
//END [Needed in case scripts load out of order]

scp_control.prototype.initTree = function (oCtl) 
{
	scp.extend(scp.controls.scpTreeNode.prototype, new scp.controls.scpNode);

	scp.controls.controls[oCtl.id] = new scp.controls.scpTree(oCtl);
	scp.controls.controls[oCtl.id].generateTreeHTML();
	return scp.controls.controls[oCtl.id];
}

//------- Constructor -------//
scp_control.prototype.scpTree = function (o)
{
	this.ns = o.id;               //stores namespace for tree
	this.container = o;                    //stores container

	//--- Data Properties ---//  
	//this.xml = scp.getVar(o.id + '_xml');
	this.DOM = new scp.xml.createDocument();
	this.DOM.loadXml(scp.getVar(o.id + '_xml'));

	//--- Appearance Properties ---//
	this.css = scp.dom.getAttr(o, 'css', '');
	this.cssChild = scp.dom.getAttr(o, 'csschild', '');
	this.cssHover = scp.dom.getAttr(o, 'csshover', '');
	this.cssSel = scp.dom.getAttr(o, 'csssel', '');
	this.cssIcon = scp.dom.getAttr(o, 'cssicon', '');

	this.sysImgPath = scp.dom.getAttr(o, 'sysimgpath', '');
	this.imageList = scp.dom.getAttr(o, 'imagelist', '').split(',');
	this.expandImg = scp.dom.getAttr(o, 'expimg', '');
	this.workImg = scp.dom.getAttr(o, 'workimg', 'scpanim.gif');
	this.animf = new Number(scp.dom.getAttr(o, 'animf', '5'));
	this.collapseImg = scp.dom.getAttr(o, 'colimg', '');
	
	this.indentWidth = new Number(scp.dom.getAttr(o, 'indentw', '10'));
	if (this.indentWidth == 0)
		this.indentWidth = 10;
	this.checkBoxes = scp.dom.getAttr(o, 'checkboxes', '0') == '1';
	this.target = scp.dom.getAttr(o, 'target', '');	
	this.defaultJS = scp.dom.getAttr(o, 'js', '');	
	
	this.postBack = scp.dom.getAttr(o, 'postback', '');
	this.callBack = scp.dom.getAttr(o, 'callback', '');
	this.callBackStatFunc = scp.dom.getAttr(o, 'callbackSF', '');
	//if (this.callBackStatFunc != null)
	//	this.callBackStatFunc = eval(this.callBackStatFunc);
	
	//obtain width of expand image
	this.expImgWidth = new Number(scp.dom.getAttr(o, 'expcolimgw', '12'));
	
	this.hoverTreeNode = null;
	this.selTreeNode=null;  
	this.rootNode = null;	
	if (this.container.tabIndex <= 0)
	{
		this.container.tabIndex = 0;
		scp.dom.addSafeHandler(this.container, 'onkeydown', this, 'keydownHandler');
		scp.dom.addSafeHandler(this.container, 'onfocus', this, 'focusHandler');
	}
	else
	{
		var oTxt = document.createElement('input');
		oTxt.type = 'text';
		oTxt.style.width = 0;
		oTxt.style.height = 0;
		oTxt.style.background = 'transparent';
		oTxt.style.border = 0;
		oTxt.style.positioning = 'absolute';
		this.container.parentNode.appendChild(oTxt);
		scp.dom.addSafeHandler(oTxt, 'onkeydown', this, 'keydownHandler');
		scp.dom.addSafeHandler(oTxt, 'onfocus', this, 'focusHandler');
	}	
}

scp_control.prototype.scpTree.prototype = 
{
focusHandler: function (e) 
{
	var oTNode = this.hoverTreeNode;
	if (oTNode == null)
		oTNode = new scp.controls.scpTreeNode(this.rootNode.childNodes(0));
	this.hoverNode(oTNode);
	this.container.onfocus = null;
},

keydownHandler: function (e) 
{
	var KEY_LEFT_ARROW = 37;
	var KEY_UP_ARROW = 38;
	var KEY_RIGHT_ARROW = 39;
	var KEY_DOWN_ARROW = 40;
	var KEY_RETURN = 13;
	var KEY_ESCAPE = 27;
	var iDir = 0;
	var sAxis = '';
	
	if (e.keyCode == KEY_UP_ARROW)
	{
		iDir = -1;
		sAxis = 'y';
	}
	if (e.keyCode == KEY_DOWN_ARROW)
	{
		iDir = 1;
		sAxis = 'y';
	}
	if (e.keyCode == KEY_LEFT_ARROW)
	{
		iDir = -1;
		sAxis = 'x';
	}
	if (e.keyCode == KEY_RIGHT_ARROW)
	{
		iDir = 1;
		sAxis = 'x';
	}
		
	if (iDir != 0)
	{
		var oTNode = this.hoverTreeNode;
		var oNode;
		if (oTNode == null)
			oTNode = new scp.controls.scpTreeNode(this.rootNode.childNodes(0));

		if (sAxis == 'x')
		{
			if (iDir == -1)
			{
				if (oTNode.hasNodes && oTNode.expanded)
					this.collapseNode(oTNode);
				else
					oNode = oTNode.node.parentNode();
			}
			
			if (iDir == 1)
			{
				if (oTNode.hasNodes || oTNode.hasPendingNodes)
				{
					if (oTNode.expanded != true)
						this.expandNode(oTNode);
					else
						oNode = oTNode.node.childNodes(0);
				}
			}
		}
		else if (sAxis == 'y')
		{
			var iNodeIndex = oTNode.node.getNodeIndex('id');
			var oParentNode = oTNode.node.parentNode();
			if (oTNode.hasNodes && oTNode.expanded && iDir > 0)	//if has expanded nodes and going down, select first child
				oNode = oTNode.node.childNodes(0);
			else if (iNodeIndex + iDir < 0)	//if first node was selected and going up, select parent
				oNode = oParentNode;
			else if (iNodeIndex + iDir < oParentNode.childNodeCount())	//if navigated index less than number of nodes contained in parent
			{
				oNode = oParentNode.childNodes(iNodeIndex + iDir);	//navigate there
				if (iDir == -1)		//if going up... look for expanded sibling above (recursively)
				{
					var oTNode2 = new scp.controls.scpTreeNode(oNode);
					while (oTNode2.expanded)	//determine if parent node is expanded, if so find its last child node
					{
						if (oTNode2.node.childNodeCount() == 0)
							break;
						oNode = oTNode2.node.childNodes(oTNode2.node.childNodeCount()-1);	//select last node in parent's collection
						oTNode2 = new scp.controls.scpTreeNode(oNode);	//needed to check expanded property
					}
				}
			}
			else if (oParentNode.nodeName() != 'root')	//logic for last node in collection
			{
				var iNodeIndex = oParentNode.getNodeIndex('id');
				var oTempParent = oParentNode;
				if (iDir == 1)	//if going down... verify that parent node has sibling available to select, if not recursively look for one
				{
					while (oTempParent.nodeName() != 'root' && iNodeIndex + iDir >= oTempParent.parentNode().childNodeCount())	//while index greater than node count
					{
						oTempParent = oTempParent.parentNode();
						iNodeIndex = oTempParent.getNodeIndex('id');
					}
				}
				if (oTempParent.nodeName() != 'root')
					oNode = oTempParent.parentNode().childNodes(iNodeIndex + 1);
			}
		}
		if (oNode != null && oNode.nodeName() != 'root')
			this.hoverNode(new scp.controls.scpTreeNode(oNode));
		
		return false;
	}
	
	if (e.keyCode == KEY_RETURN && this.hoverTreeNode != null)
	{
		this.selectNode(this.hoverTreeNode);
		return false;
	}
	
},

hoverNode: function (oTNode) 
{
	if (this.hoverTreeNode != null)
	{
		this.hoverTreeNode.hover = false;
		this.assignCss(this.hoverTreeNode);
	}
	oTNode.hover = true;
	this.assignCss(oTNode);
	this.hoverTreeNode = oTNode;
},

getXml: function () 
{
	return this.DOM.getXml();
},

expandNode: function (oTNode) 
{
	//PUT CODE TO ONDEMANDFILL HERE
	var oCtr = this.getChildControl(oTNode.id, 'pctr');
	var oExpCol = this.getChildControl(oTNode.id, 'expcol');
	//oCtr.style.display = '';
	oExpCol.src = this.expandImg;
	oTNode.expanded = true;
	oTNode.update();
	this.update();

	if (oTNode.hasPendingNodes)
	{
		var sXml = oTNode.node.getXml();
		oTNode.tree = this;	//need to give reference back to self
		
		if (this.workImg != null)
		{
			var oIcn = this.getChildControl(oTNode.id, 'icn');	
			oIcn.src = this.sysImgPath + this.workImg;
		}
		if (this.callBack.indexOf('[NODEXML]') > -1)
			eval(this.callBack.replace('[NODEXML]', scp.escapeForEval(sXml)));
		else
			eval(this.callBack.replace('[NODEID]', oTNode.id));
		
		oTNode.hasPendingNodes = false;
		oTNode.hasNodes = true;
		this.hoverTreeNode = oTNode;
	}
	else
		scp.dom.expandElement(oCtr, this.animf);
	
	return true;
},

collapseNode: function (oTNode) 
{
	var oCtr = this.getChildControl(oTNode.id, 'pctr');
	var oExpCol = this.getChildControl(oTNode.id, 'expcol');
	//oCtr.style.display = 'none';
	scp.dom.collapseElement(oCtr, this.animf);
	oExpCol.src = this.collapseImg;
	oTNode.expanded = null;
	oTNode.update();
	this.update();
	return true;
},

selectNode: function (oTNode) 
{		
	if (this.selTreeNode != null && this.checkBoxes == false)
	{
		this.selTreeNode.selected = null;
		this.assignCss(this.selTreeNode);
		this.selTreeNode.update('selected');
	}		
	
	if (oTNode.selected)
	{
		oTNode.selected = null;
		this.assignCss(oTNode);
	}
	else
	{
		oTNode.selected = true;
		this.hoverTreeNode = oTNode;
		this.assignCss(oTNode);
		scp.setVar(this.ns + ':selected', oTNode.id);		//BACKWARDS COMPAT ONLY!!!
	}
	oTNode.update('selected');
	
	this.selTreeNode = oTNode;
	this.update();

	var oChk = this.getChildControl(oTNode.id, 'chk');	
	if (oChk != null)
		oChk.checked = oTNode.selected;

	if (oTNode.selected)
	{
		var sJS = '';
		if (this.defaultJS.length > 0)
			sJS = this.defaultJS;
		if (oTNode.js.length > 0)
			sJS = oTNode.js;
		
		if (sJS.length > 0)
		{
			if (eval(sJS) == false)
				return;	//don't do postback if returns false
		}
		
		if (oTNode.clickAction == null || oTNode.clickAction == scp.controls.action.postback)
			eval(this.postBack.replace('[NODEID]', oTNode.id));
		else if (oTNode.clickAction == scp.controls.action.nav)
			scp.dom.navigate(oTNode.url, oTNode.target.length > 0 ? oTNode.target : this.target);
		else if (oTNode.clickAction == scp.controls.action.expand)
		{
			if (oTNode.hasNodes || oTNode.hasPendingNodes)
			{
				if (oTNode.expanded)
					this.collapseNode(oTNode);
				else
					this.expandNode(oTNode);
			}
		}
	}
	
	return true;		
},

assignCss: function (oTNode)
{
	var oText = this.getChildControl(oTNode.id, 't');//, this.container);
	var sNodeCss = this.css;

	if (oTNode.level > 0 && this.cssChild.length > 0)
		sNodeCss = this.cssChild;

	if (oTNode.css.length > 0)
		sNodeCss = oTNode.css;

	//oTNode.hoverCss;

	if (oTNode.hover)
		sNodeCss += ' ' + (oTNode.cssHover.length > 0 ? oTNode.cssHover : this.cssHover);
	if (oTNode.selected)
		sNodeCss += ' ' + (oTNode.cssSel.length > 0 ? oTNode.cssSel : this.cssSel);
	
	oText.className = sNodeCss;
},

update: function () 
{
	scp.setVar(this.ns + '_xml', this.DOM.getXml());
	return true;
},

//--- Event Handlers ---//
callBackStatus: function (result, ctx) 
{
	var oTNode = ctx;
	var oTree = oTNode.tree;
	
	if (oTree.callBackStatFunc != null && oTree.callBackStatFunc.length > 0)
	{
		var oPointerFunc = eval(oTree.callBackStatFunc);
		oPointerFunc(result, ctx);	
	}
},

callBackSuccess: function (result, ctx) 
{
	var oTNode = ctx;
	var oTree = oTNode.tree;
	var oParent = oTNode.node;//.parentNode();
	//oParent.removeChild(oTNode.node);
	
	oTNode.node.appendXml(result);
	//oTNode.node = oParent.childNodes(0);

	if (oTree.workImg != null)
	{
		var oIcn = oTree.getChildControl(oTNode.id, 'icn');
		if (oTNode.image != '')
			oIcn.src = oTNode.image;
		else
			oIcn.src = oTree.imageList[oTNode.imageIndex];		
	}

	//ctx.tree.generateTreeHTML();	
	//get container
	var oCtr = oTree.getChildControl(oTNode.id, 'pctr');
	oTree.renderNode(oTNode.node, oCtr, true);
	
	oTree.update();

	var oCtr = oTree.getChildControl(oTNode.id, 'pctr');
	oTree.expandNode(new scp.controls.scpTreeNode(oTNode.node));

	if (oTree.callBackStatFunc != null && oTree.callBackStatFunc.length > 0)
	{
		var oPointerFunc = eval(oTree.callBackStatFunc);
		oPointerFunc(result, ctx);	
	}
},

callBackFail: function (result, ctx) 
{
	alert(result);
},

nodeExpColClick: function(evt, element)
{
	var oNode = this.DOM.findNode('n', 'id', element.nodeid);
	if (oNode != null)
	{
		var oTNode = new scp.controls.scpTreeNode(oNode);
		
		var oCtr = this.getChildControl(oTNode.id, 'pctr');
		if (oTNode.expanded)
			this.collapseNode(oTNode);
		else
			this.expandNode(oTNode);
	}
},

nodeCheck: function(evt, element)
{
	var oNode = this.DOM.findNode('n', 'id', element.nodeid);
	if (oNode != null)
	{
		this.selectNode(new scp.controls.scpTreeNode(oNode));
	}
},

nodeTextClick: function(evt, element)
{
	var oNode = this.DOM.findNode('n', 'id', element.nodeid);
	if (oNode != null)
	{
		this.selectNode(new scp.controls.scpTreeNode(oNode));
	}
},

nodeTextMOver: function(evt, element)
{
	var oNode = this.DOM.findNode('n', 'id', element.nodeid);
	if (oNode != null)
		this.hoverNode(new scp.controls.scpTreeNode(oNode));
},

nodeTextMOut: function(evt, element)
{
	var oNode = this.DOM.findNode('n', 'id', element.nodeid);
	if (oNode != null)
		this.assignCss(new scp.controls.scpTreeNode(oNode));
},

//--- Generates tree HTML through passed in XML DOM ---//
generateTreeHTML: function () 
{
	this.rootNode = this.DOM.rootNode();
	this.renderNode(null, this.container);
},

renderNode: function (oNode, oCont, bExists) 
{
	var oChildCont = oCont;
	var oTNode;
	
	if (bExists != true)
	{
		if (oNode != null)
		{
			//render node
			oTNode = new scp.controls.scpTreeNode(oNode);
			var oNewContainer;
			oNewContainer = this.createChildControl('DIV', oTNode.id, 'ctr'); //container for Node
			oNewContainer.appendChild(this.renderSpacer((this.indentWidth * oTNode.level) + ((oTNode.hasNodes || oTNode.hasPendingNodes) ? 0 : this.expImgWidth)));	//indent node
			if (oTNode.hasNodes || oTNode.hasPendingNodes)	//if node has children then render expand/collapse icon
				oNewContainer.appendChild(this.renderExpCol(oTNode));
			
			if (this.checkBoxes)
				oNewContainer.appendChild(this.renderCheckbox(oTNode));
			
			var oIconCont = this.renderIconCont(oTNode);
			oNewContainer.appendChild(oIconCont);
			if (oTNode.imageIndex > -1 || oTNode.image != '')	//if node has image 
			{
				oIconCont.appendChild(this.renderIcon(oTNode));
				//oNewContainer.appendChild(this.renderSpacer(10));
			}
			oNewContainer.appendChild(this.renderText(oTNode));	//render text
			oCont.appendChild(oNewContainer);
			this.assignCss(oTNode);
		}
		else
			oNode = this.rootNode;

		if (oTNode != null && (oTNode.hasNodes || oTNode.hasPendingNodes))	//if node has children render container and hide if necessary
		{
			oChildCont = this.createChildControl('DIV', oTNode.id, 'pctr');	//Not using SPAN due to FireFox bug...
			if (oTNode.expanded != true)
				oChildCont.style.display = 'none';
			oCont.appendChild(oChildCont);			
		}				
	}
		
	for (var i=0; i<oNode.childNodeCount(); i++)	//recursively call child rendering
		this.renderNode(oNode.childNodes(i), oChildCont);
},

renderExpCol: function (oTNode) 
{
	var oImg = this.createChildControl('IMG', oTNode.id, 'expcol');
	if ((oTNode.hasNodes || oTNode.hasPendingNodes) && this.expandImg.length)
	{
		if (oTNode.expanded)
			oImg.src = this.expandImg;
		else
			oImg.src = this.collapseImg;
	}
	//oImg.style.width = this.expImgWidth;	
	//oImg.style.cursor = 'hand';	//ie
	oImg.style.cursor = 'pointer';
	//scp.dom.attachEvent(oImg, 'onclick', this.nodeExpColClick);
	//scp.dom.attachEvent(oImg, 'onclick', scp.dom.getObjMethRef(this, 'nodeExpColClick'));
	oImg.onclick = scp.dom.getObjMethRef(this, 'nodeExpColClick');
	
	return oImg;
},

renderIconCont: function (oTNode) 
{
	var oSpan = this.createChildControl('SPAN', oTNode.id, 'icnc');
	if (oTNode.cssIcon.length > 0)
		oSpan.className = oTNode.cssIcon;
	else if (this.cssIcon.length > 0)
		oSpan.className = this.cssIcon;
	
	return oSpan;
},

renderIcon: function (oTNode) 
{
	var oImg = this.createChildControl('IMG', oTNode.id, 'icn');
	if (oTNode.image != '')
		oImg.src = oTNode.image;
	else
		oImg.src = this.imageList[oTNode.imageIndex];
	//oImg.style.paddingRight = 10;	//doesn't work in IE???
	return oImg;
},

renderCheckbox: function (oTNode) 
{
	var oChk = this.createChildControl('INPUT', oTNode.id, 'chk');
	oChk.type = 'checkbox';
	oChk.defaultChecked = oTNode.selected;
	oChk.checked = oTNode.selected;
	
	oChk.onclick = scp.dom.getObjMethRef(this, 'nodeCheck');	
	return oChk;
},

renderSpacer: function (iWidth) 
{
	var oImg = document.createElement('IMG');
	oImg.src = this.sysImgPath + 'spacer.gif';
	oImg.width = iWidth;
	oImg.style.width = iWidth;
	oImg.style.height = '1';
	return oImg;
},

renderText: function (oTNode) 
{
	var oSpan = this.createChildControl('SPAN', oTNode.id, 't');
	oSpan.innerHTML = oTNode.text;	
	oSpan.style.cursor = 'pointer';
	
	if (oTNode.toolTip.length > 0)
		oSpan.title = oTNode.toolTip;
	
	if (oTNode.enabled)
	{
		oSpan.onclick = scp.dom.getObjMethRef(this, 'nodeTextClick');
		if (this.cssHover.length > 0)	//only do this if necessary
		{
			oSpan.onmouseover = scp.dom.getObjMethRef(this, 'nodeTextMOver');
			oSpan.onmouseout = scp.dom.getObjMethRef(this, 'nodeTextMOut');
		}
	}
		
	if (oTNode.selected)
	{
		this.selTreeNode = oTNode;
		this.hoverTreeNode = oTNode;
	}

	return oSpan;
},

createChildControl: function (sTag, sNodeID, sPrefix)
{
	var oCtl = document.createElement(sTag);
	oCtl.ns = this.ns;
	oCtl.nodeid = sNodeID;
	if (scp.controls.length == 1)	//inclusion of ns causes issue with old __dt_scpTreeNode code, so if only one treen then don't use as workaround
		oCtl.id = sPrefix + sNodeID;
	else
		oCtl.id = this.ns + sPrefix + sNodeID;
	return oCtl;
}, 

getChildControl: function (sNodeID, sPrefix)
{
	if (scp.controls.length == 1)
		return scp.dom.getById(sPrefix + sNodeID);	//inclusion of ns causes issue with old __dt_scpTreeNode code, so if only one treen then don't use as workaround
	else
		return scp.dom.getById(this.ns + sPrefix + sNodeID);
}

} //END scpTree

scp_control.prototype.scpTreeNode = function (oNode)
{
	this.base = scp.controls.scpNode;
	this.base(oNode);	//invoke base class constructor

	//tree specific attributes
	this.hover = false;
	this.expanded = oNode.getAttribute('expanded', '0') == '1' ? true : null;
	this.selected = oNode.getAttribute('selected', '0') == '1' ? true : null;
	this.clickAction = oNode.getAttribute('ca', scp.controls.action.postback);
	this.imageIndex = new Number(oNode.getAttribute('imgIdx', '0')); //defaulting to 0 for backwards compat!
	
	//this.checkBox = oNode.getAttribute('checkBox', '0');	//IS THIS NECESSARY?
}

//scpTreeNode specific methods
scp_control.prototype.scpTreeNode.prototype = 
{
childNodes: function (iIndex)
{
	if (this.node.childNodes[iIndex] != null)
		return new scp.controls.scpTreeNode(this.node.childNodes[iIndex]);
}
}

//BACKWARDS COMPAT ONLY!
var DT_ACTION_POSTBACK = 0;
var DT_ACTION_EXPAND = 1;
var DT_ACTION_NONE = 2;
var DT_ACTION_NAV = 3;

function __dt_scpTreeNode(oCtl)
{
	var oNode = scp.controls.controls[oCtl.ns].DOM.findNode('n', 'id', oCtl.nodeid);
	if (oNode != null)
	{
		var oTNode = new scp.controls.scpTreeNode(oNode);
	
		this.ctl = oCtl;
		this.id = oCtl.id;
		this.key = oTNode.key;
		this.nodeID = oCtl.nodeid;	//trim off t
		this.text = oTNode.text;	
		this.serverName = oCtl.name; 
	}
}

//BEGIN [Needed in case scripts load out of order]
if (typeof(scp_controls) != 'undefined')
{
	scp.extend(scp_controls.prototype, scp_control.prototype);
	scp.controls = new scp_controls();
}
//END [Needed in case scripts load out of order]