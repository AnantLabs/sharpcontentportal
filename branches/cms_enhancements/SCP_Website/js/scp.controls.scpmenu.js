//BEGIN [Needed in case scripts load out of order]
if (typeof(scp_control) == 'undefined')
	eval('function scp_control() {}')
//END [Needed in case scripts load out of order]

scp_control.prototype.initMenu = function (oCtl) 
{
	scp.extend(scp.controls.scpMenuNode.prototype, new scp.controls.scpNode);

	scp.controls.controls[oCtl.id] = new scp.controls.scpMenu(oCtl);
	scp.controls.controls[oCtl.id].generateMenuHTML();
	return scp.controls.controls[oCtl.id];
}

//------- Constructor -------//
scp_control.prototype.scpMenu = function (o)
{
	this.ns = o.id;               //stores namespace for menu
	this.container = o;                    //stores container

	//--- Data Properties ---//  
	this.DOM = new scp.xml.createDocument();
	this.DOM.loadXml(scp.getVar(o.id + '_xml'));

	//--- Appearance Properties ---//
	this.mbcss = scp.dom.getAttr(o, 'mbcss', '');
	this.mcss = scp.dom.getAttr(o, 'mcss', '');
	this.css = scp.dom.getAttr(o, 'css', '');
	this.cssChild = scp.dom.getAttr(o, 'csschild', '');
	this.cssHover = scp.dom.getAttr(o, 'csshover', '');
	this.cssSel = scp.dom.getAttr(o, 'csssel', '');
	this.cssIcon = scp.dom.getAttr(o, 'cssicon', '');

	this.sysImgPath = scp.dom.getAttr(o, 'sysimgpath', '');
	this.imagePaths = scp.dom.getAttr(o, 'imagepaths', '').split(',');
	this.imageList = scp.dom.getAttr(o, 'imagelist', '').split(',');
	for (var i=0; i<this.imageList.length; i++)
	{
		var iPos = this.imageList[i].indexOf(']');
		if (iPos > -1)
			this.imageList[i] = this.imagePaths[this.imageList[i].substring(1, iPos)] + this.imageList[i].substring(iPos+1);
	}
	this.urlList = scp.dom.getAttr(o, 'urllist', '').split(',');
	
	this.workImg = scp.dom.getAttr(o, 'workimg', 'scpanim.gif');	
	this.rootArrow = scp.dom.getAttr(o, 'rarrowimg', '');
	this.childArrow = scp.dom.getAttr(o, 'carrowimg', '');
	this.target = scp.dom.getAttr(o, 'target', '');	
	this.defaultJS = scp.dom.getAttr(o, 'js', '');	
	this.postBack = scp.dom.getAttr(o, 'postback', '');
	this.callBack = scp.dom.getAttr(o, 'callback', '');
	this.callBackStatFunc = scp.dom.getAttr(o, 'callbacksf', '');
	this.selMenuNode=null;  
	this.rootNode = null;	
	this.orient = new Number(scp.dom.getAttr(o, 'orient', scp.controls.orient.horizontal));
	
	this.openMenus = new Array();
	this.moutDelay = scp.dom.getAttr(o, 'moutdelay', '1000');
	this.minDelay = new Number(scp.dom.getAttr(o, 'mindelay', 250));

	this.anim = scp.dom.getAttr(o, 'anim', '');	//expand
	this.useTables = (scp.dom.getAttr(o, 'usetables', '1') == '1');
	this.enablePostbackState = (scp.dom.getAttr(o, 'enablepbstate', '0') == '1');
	this.enablePostbackState = true;//F5 in FireFox seems to need this on...  for now always set to true until can provide a workaround.
	this.podInProgress = false;
	
	this.keyboardAccess = (scp.dom.getAttr(o, 'kbaccess', '1') == '1');
	
	this.childControls = null;

	this.hoverMenuNode = null;
	this.selMenuNode=null;  
	this.rootNode = null;	
	if (this.keyboardAccess)
	{
	
		if (this.container.tabIndex <= 0)
		{
			this.container.tabIndex = 0;
			scp.dom.addSafeHandler(this.container, 'onkeydown', this, 'keyboardHandler');
			scp.dom.addSafeHandler(this.container, 'onfocus', this, 'focusHandler');
			scp.dom.addSafeHandler(this.container, 'onblur', this, 'blurHandler');
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
			if (scp.dom.browser.isType(scp.dom.browser.Safari))
			{
				oTxt.style.width = 1;	//safari doesn't like zero
				oTxt.style.height = 1;	
				scp.dom.addSafeHandler(oTxt, 'onkeydown', this, 'keyboardHandler'); //'keydownHandler'); 
				scp.dom.addSafeHandler(this.container.parentNode, 'onkeypress', this, 'safariKeyHandler');	//in order to cancel RETURN (if attach keypress to oTxt, Safari crashes...
			}
			else
				scp.dom.addSafeHandler(oTxt, 'onkeypress', this, 'keyboardHandler');	
			scp.dom.addSafeHandler(oTxt, 'onfocus', this, 'focusHandler');
			scp.dom.addSafeHandler(oTxt, 'onblur', this, 'blurHandler');

			this.container.parentNode.appendChild(oTxt);
		}
	}
}

scp_control.prototype.scpMenu.prototype = 
{

//--- Generates menu HTML ---//
getXml: function () 
{
	return this.DOM.getXml();
},

generateMenuHTML: function() 
{
	this.childControls = new Array();
	this.rootNode = this.DOM.rootNode();
	this.container.className = this.mbcss;	

	for (var i=0; i<this.rootNode.childNodeCount(); i++)
		this.renderNode(this.rootNode.childNodes(i), this.container);

	this.update();		
},

renderNode: function(oNode, oCtr)
{
	var oMNode = new scp.controls.scpMenuNode(oNode);
	
	if (oMNode.selected)
		this.selMenuNode = oMNode;
	
	var oMBuilder;	
	if (this.useTables && oMNode.level > 0)
		oMBuilder = new scp.controls.scpMenuTableBuilder(this, oMNode, oCtr);		
	else
		oMBuilder = new scp.controls.scpMenuBuilder(this, oMNode, oCtr);

	if (this.isNodeVertical(oMNode))
		oMBuilder.newRow();

	oMBuilder.newCont();

	if (oMNode.lhtml.length > 0)
		oMBuilder.appendChild(this.renderCustomHTML(oMNode.lhtml));

	var oIcn = this.renderIcon(oMNode);
	oMBuilder.appendChild(oIcn);	//render icon
	if (this.useTables == false || oMNode.level == 0)
		oIcn.className = (oMNode.cssIcon.length > 0 ? oMNode.cssIcon : this.cssIcon);
	else	
		oMBuilder.subcont.className = (oMNode.cssIcon.length > 0 ? oMNode.cssIcon : this.cssIcon);	//assign style to container of icon

	if (oMNode.isBreak == false)
		oMBuilder.appendChild(this.renderText(oMNode), true);	//render text
		
	oMBuilder.newCell();			
	this.renderArrow(oMNode, oMBuilder.subcont);

	if (oMNode.rhtml.length > 0)
		oMBuilder.appendChild(this.renderCustomHTML(oMNode.rhtml));
				
	if (oMNode.toolTip.length > 0)
		oMBuilder.row.title = oMNode.toolTip;

	this.assignCss(oMNode);
	
	if (oMNode.enabled)
		scp.dom.addSafeHandler(oMBuilder.row, 'onclick', this, 'nodeTextClick');
	
	scp.dom.addSafeHandler(oMBuilder.row, 'onmouseover', this, 'nodeMOver');
	scp.dom.addSafeHandler(oMBuilder.row, 'onmouseout', this, 'nodeMOut');
	scp.dom.addSafeHandler(oMBuilder.container, 'onmouseover', this, 'menuMOver');
	scp.dom.addSafeHandler(oMBuilder.container, 'onmouseout', this, 'menuMOut');

	if (oMNode.hasNodes || oMNode.hasPendingNodes)	//if node has children render container and hide if necessary
	{
		var oSub = this.renderSubMenu(oMNode);
		this.container.appendChild(oSub);
		
		for (var i=0; i<oNode.childNodeCount(); i++)	//recursively call child rendering
			this.renderNode(oNode.childNodes(i), oSub);
	}				
},

renderCustomHTML: function (sHTML) 
{
	var oCtr = scp.dom.createElement('span');
	oCtr.innerHTML = sHTML;
	return oCtr;	
},

renderIcon: function (oMNode) 
{
	var oCtr = scp.dom.createElement('span');
	if (oMNode.imageIndex > -1 || oMNode.image != '')
	{
		var oImg = this.createChildControl('img', oMNode.id, 'icn');
		oImg.src = (oMNode.image.length > 0 ? oMNode.image : this.imageList[oMNode.imageIndex]);
		oCtr.appendChild(oImg);
	}
	
	return oCtr;
},

renderArrow: function (oMNode, oCont) 
{
	if (oMNode.hasNodes || oMNode.hasPendingNodes)
	{
		var sImg = (oMNode.level == 0 ? this.rootArrow : this.childArrow);
		if (sImg.length > 0)
		{
			if (this.useTables && oMNode.level > 0)	//do not require tables to need special padding to properly show arrow, place a real image there and have browser space it appropriately
			{
				var oImg = scp.dom.createElement('img');
				oImg.src = sImg;
				oCont.appendChild(oImg);			
			}
			else
			{
				oCont.style.backgroundImage = 'url(' + sImg + ')';
				oCont.style.backgroundRepeat = 'no-repeat';
				oCont.style.backgroundPosition = 'right';			
			}
		}
	}
},

renderText: function (oMNode) 
{
	var oCtr = this.createChildControl('span', oMNode.id, 't');
	oCtr.innerHTML = oMNode.text;	
	oCtr.style.cursor = 'pointer';		
	return oCtr;
},

renderSubMenu: function(oMNode)
{
	var oMBuilder;
	if (this.useTables)
		oMBuilder = new scp.controls.scpMenuTableBuilder(this, oMNode);		
	else
		oMBuilder = new scp.controls.scpMenuBuilder(this, oMNode);
	
	var oSub = oMBuilder.createSubMenu();
	oSub.style.position = 'absolute';
	oSub.style.display = 'none';
	oSub.className = this.mcss;
	return oSub;
},

//---- Methods ---//
hoverNode: function (oMNode) 
{
	if (this.hoverMenuNode != null)
	{
		this.hoverMenuNode.hover = false;
		this.assignCss(this.hoverMenuNode);
	}
	if (oMNode != null)
	{
		oMNode.hover = true;
		this.assignCss(oMNode);
	}
	this.hoverMenuNode = oMNode;
},

__expandNode: function (oContext) 
{
	this.expandNode(oContext, true);
},

expandNode: function (oMNode, bForce) 
{
	scp.cancelDelay(this.ns + 'min');
		
	if (oMNode.hasPendingNodes)
	{
		if (this.podInProgress == false)
		{
			this.podInProgress = true;
			this.showWorkImage(oMNode, true);
			oMNode.menu = this;	//need to give reference back to self
			
			if (this.callBack.indexOf('[NODEXML]') > -1)
				eval(this.callBack.replace('[NODEXML]', scp.escapeForEval(oMNode.node.getXml())));
			else
				eval(this.callBack.replace('[NODEID]', oMNode.id));
		}
	}
	else
	{
		if (this.minDelay == 0 || bForce)	
		{
			this.hideMenus(new scp.controls.scpMenuNode(oMNode.node.parentNode()));	//MinDelay???
			var oSub = this.getChildControl(oMNode.id, 'sub');
			if (oSub != null)
			{
				this.positionMenu(oMNode, oSub);
				this.showSubMenu(oSub, true);				
				this.openMenus[this.openMenus.length] = oMNode;
			}
		}
		else
			scp.doDelay(this.ns + 'min', this.minDelay, scp.createDelegate(this, this.__expandNode), oMNode);
	}
	return true;
},

showSubMenu: function(oSub, bShow)
{
	oSub.style.display = (bShow ? '' : 'none');
	scp.dom.positioning.placeOnTop(oSub, bShow, this.sysImgPath + 'spacer.gif');
},

showWorkImage: function (oMNode, bShow)
{
	if (this.workImg != null)
	{
		var oIcn = this.getChildControl(oMNode.id, 'icn');	
		if (oIcn != null)
		{
			if (bShow)
				oIcn.src = this.sysImgPath + this.workImg;
			else
				oIcn.src = (oMNode.image.length > 0 ? oMNode.image : this.imageList[oMNode.imageIndex]);
		}
	}

},

isNodeVertical: function (oMNode)
{
	return (this.orient == scp.controls.orient.vertical || oMNode.level > 0);
},

hideMenus: function (oMNode) 
{
	for (var i=this.openMenus.length-1; i>=0; i--)
	{
		if (oMNode != null && this.openMenus[i].id == oMNode.id)
			break;
		this.collapseNode(this.openMenus[i]);
		this.openMenus.length = this.openMenus.length-1;
	}
},

collapseNode: function (oMNode) 
{
	var oSub = this.getChildControl(oMNode.id, 'sub');
	if (oSub != null)
	{
		this.showSubMenu(oSub, false);
		oMNode.expanded = null;
		oMNode.update();
		this.update();
		return true;
	}
},

positionMenu: function (oMNode, oMenu)
{
	var oPCtl = this.getChildControl(oMNode.id, 'ctr');
	if (scp.dom.browser.isType(scp.dom.browser.Safari))
	{
		if (oPCtl.tagName == 'TR' && oPCtl.childNodes.length > 0)
			oPCtl = oPCtl.childNodes[oPCtl.childNodes.length-1];	//fix for Safari... use TD instead of TR
	}
		
	var oPDims = new scp.dom.positioning.dims(oPCtl);
	var oMDims = new scp.dom.positioning.dims(oMenu);
	var iScrollLeft = scp.dom.positioning.bodyScrollLeft();
	var iScrollTop = scp.dom.positioning.bodyScrollTop()
	//Max = ViewPort + Scroll - Menu's relative offset
	var iMaxTop = scp.dom.positioning.viewPortHeight() + iScrollTop - oPDims.rot;	
	var iMaxLeft = scp.dom.positioning.viewPortWidth() + iScrollLeft - oPDims.rol;	
	var iNewTop = oPDims.t;
	var iNewLeft = oPDims.l;
	var iStartTop = oPDims.t;
	var iStartLeft = oPDims.l;

	if (this.isNodeVertical(oMNode))
	{
		iNewLeft = oPDims.l + oPDims.w;
		iStartTop = iMaxTop;
	}
	else
	{
		iNewTop = oPDims.t + oPDims.h;
		iStartLeft = iMaxLeft;
	}	
		
	if (iNewTop + oMDims.h >= iMaxTop)	//if menu doesn't fit below...
	{
		if (oPDims.rot + iStartTop - oMDims.h > iScrollTop)	//see if it fits above
			iNewTop = iStartTop - oMDims.h;
		//else						//cause menu to scroll...
	}
	
	if (iNewLeft + oMDims.w > iMaxLeft)	//if menu doesn't fit to right
	{
		if (oPDims.rol + iStartLeft - oMDims.w > iScrollLeft)  //see if it fits to left
			iNewLeft = iStartLeft - oMDims.w;
	}

	oMenu.style.top = iNewTop + 'px';
	oMenu.style.left = iNewLeft + 'px';
},

selectNode: function (oMNode) 
{		
	if (this.selMenuNode != null)	//unselect previously selected node
	{
		this.selMenuNode.selected = null;
		this.selMenuNode.update('selected');
		this.assignCss(this.selMenuNode);
	}		
	
	oMNode.selected = (oMNode.selected ? null : true);
	oMNode.update('selected');
	this.assignCss(oMNode);
	
	this.selMenuNode = oMNode;
	this.update();

	if (oMNode.hasNodes || oMNode.hasPendingNodes)
		this.expandNode(oMNode, true);	//force display

	if (oMNode.selected)
	{
		var sJS = this.defaultJS;
		if (oMNode.js.length > 0)
			sJS = oMNode.js;
		
		this.enablePostbackState = true; 
		this.update();	//update xml even if enablePostbackState = false
		
		if (sJS.length > 0)
		{
			if (eval(sJS) == false)
				return;	//don't do postback if returns false
		}
		
		if (oMNode.clickAction == scp.controls.action.postback)
			eval(this.postBack.replace('[NODEID]', oMNode.id));
		else if (oMNode.clickAction == scp.controls.action.nav)
			scp.dom.navigate(oMNode.getUrl(this), oMNode.target.length > 0 ? oMNode.target : this.target);
	}
	return true;		
},

assignCss: function (oMNode)
{
	var oCtr = this.getChildControl(oMNode.id, 'ctr');		
	var sCss = this.css;

	if (oMNode.level > 0 && this.cssChild.length > 0)
		sCss = this.cssChild;

	if (oMNode.css.length > 0)
		sCss = oMNode.css;

	if (oMNode.hover)
		sCss += ' ' + (oMNode.cssHover.length > 0 ? oMNode.cssHover : this.cssHover);
	if (oMNode.selected)
		sCss += ' ' + (oMNode.cssSel.length > 0 ? oMNode.cssSel : this.cssSel);
	
	oCtr.className = sCss;
},

update: function (bForce) 
{
	if (this.enablePostbackState || bForce)
		scp.setVar(this.ns + '_xml', this.DOM.getXml());
	else
		scp.setVar(this.ns + '_xml', '');
	return true;
},

//--- Event Handlers ---//
focusHandler: function (e) 
{
	var oMNode = this.hoverMenuNode;
	if (oMNode == null)
		oMNode = new scp.controls.scpMenuNode(this.rootNode.childNodes(0));
	this.hoverNode(oMNode);
	this.container.onfocus = null;
},

blurHandler: function (e)
{
	if (this.hoverMenuNode != null)
		this.hoverNode(null);
	this.hideMenus();
},

safariKeyHandler: function (e) 
{
	if (e.keyCode == KEY_RETURN)
	{
		if (this.hoverMenuNode != null && this.hoverMenuNode.enabled)
			this.selectNode(this.hoverMenuNode);
		return false;
	}
},

keyboardHandler: function (e) 
{
	if (e.keyCode == KEY_RETURN)
	{
		if (this.hoverMenuNode != null && this.hoverMenuNode.enabled)
			this.selectNode(this.hoverMenuNode);
		return false;
	}
	
	if (e.keyCode == KEY_ESCAPE)
	{
		this.blurHandler();
		return false;
	}
	
	if (e.keyCode >= KEY_LEFT_ARROW && e.keyCode <= KEY_DOWN_ARROW)
	{
		var iDir = (e.keyCode == KEY_UP_ARROW || e.keyCode == KEY_LEFT_ARROW) ? -1 : 1;
		var sAxis = (e.keyCode == KEY_UP_ARROW || e.keyCode == KEY_DOWN_ARROW) ? 'y' : 'x';

		var oMNode = this.hoverMenuNode;
		var oNewMNode;
		if (oMNode == null)
			oMNode = new scp.controls.scpMenuNode(this.rootNode.childNodes(0));
		
		var bHorRoot = (oMNode.level == 0 && this.orient == scp.controls.orient.horizontal);
		if ((sAxis == 'y' && !bHorRoot) || (bHorRoot && sAxis == 'x'))
		{
			this.hideMenus(new scp.controls.scpMenuNode(oMNode.node.parentNode()));
			oNewMNode = this.__getNextNode(oMNode, iDir);
		}		
		else 
		{
			if (iDir == -1)
			{
				oNewMNode = new scp.controls.scpMenuNode(oMNode.node.parentNode());
				if (oNewMNode.level == 0 && this.orient == scp.controls.orient.horizontal)
					oNewMNode = this.__getNextNode(new scp.controls.scpMenuNode(oMNode.node.parentNode()), iDir);					
				this.hideMenus(oNewMNode);	
					
			}
			else if (iDir == 1)
			{
				if (oMNode.hasNodes || oMNode.hasPendingNodes)
				{
					if (oMNode.expanded != true)
					{
						this.expandNode(oMNode);
						if (this.podInProgress == false)
							oNewMNode = new scp.controls.scpMenuNode(oMNode.node.childNodes(0));
					}
				}
				else
				{
					var oNode = oMNode.node;
					while (oNode.parentNode().nodeName() != 'root')
						oNode = oNode.parentNode();
					oNewMNode = new scp.controls.scpMenuNode(oNode);
					oNewMNode = this.__getNextNode(oNewMNode, iDir);
					this.hideMenus(new scp.controls.scpMenuNode(oNewMNode.node.parentNode()));
				}
			}
		}
		if (oNewMNode != null && oNewMNode.node.nodeName() != 'root')
			this.hoverNode(oNewMNode);
		
		return false;
	}
	
},

__getNextNode: function (oMNode, iDir) 
{
	var oNode;
	var oParentNode = oMNode.node.parentNode();
	var iNodeIndex = oMNode.node.getNodeIndex('id');
	if (iNodeIndex + iDir < 0)	//if first node was selected and going left, select last node
		oNode = oParentNode.childNodes(oParentNode.childNodeCount()-1);
	else if (iNodeIndex + iDir > oParentNode.childNodeCount()-1)
		oNode = oParentNode.childNodes(0);
	else
		oNode = oParentNode.childNodes(iNodeIndex + iDir);
	
	var oRetNode = new scp.controls.scpMenuNode(oNode);	
	if (oRetNode.isBreak)
	{
		iNodeIndex += iDir;	//check next one
		if (iNodeIndex + iDir < 0)
			oNode = oParentNode.childNodes(oParentNode.childNodeCount()-1);
		else if (iNodeIndex + iDir > oParentNode.childNodeCount()-1)
			oNode = oParentNode.childNodes(0);
		else
			oNode = oParentNode.childNodes(iNodeIndex + iDir);
		return new scp.controls.scpMenuNode(oNode);
	}
	else
		return oRetNode;
},

callBackStatus: function (result, ctx) 
{
	var oMNode = ctx;
	var oMenu = oMNode.menu;
	
	if (oMenu.callBackStatFunc != null && oMenu.callBackStatFunc.length > 0)
	{
		var oPtr = eval(oMenu.callBackStatFunc);
		oPtr(result, ctx);	
	}
},

callBackSuccess: function (result, ctx) 
{
	var oMNode = ctx;
	var oNode = oMNode.node;
	var oMenu = oMNode.menu;
	
	oMenu.showWorkImage(oMNode, false);
	oNode.appendXml(result);

	var oSub = oMenu.getChildControl(oMNode.id, 'sub');	
	for (var i=0; i<oNode.childNodeCount(); i++)	
		oMenu.renderNode(oNode.childNodes(i), oSub);
	
	oMNode.hasPendingNodes = false;
	oMNode.hasNodes = true;

	oMenu.update();

	oSub = oMenu.getChildControl(oMNode.id, 'sub');
	oMenu.expandNode(new scp.controls.scpMenuNode(oNode));

	oMenu.callBackStatus(result, ctx);
	oMenu.podInProgress = false;
},

callBackFail: function (result, ctx) 
{
	alert(result);
},

nodeTextClick: function(evt, element)
{
	var oNode = this.DOM.findNode('n', 'id', element.nodeid);
	if (oNode != null)
		this.selectNode(new scp.controls.scpMenuNode(oNode));
},

menuMOver: function(evt, element)
{
	scp.cancelDelay(this.ns + 'mout');
},

menuMOut: function(evt, element)
{
	scp.cancelDelay(this.ns + 'min');
	if (this.moutDelay > 0)
		scp.doDelay(this.ns + 'mout', this.moutDelay, scp.createDelegate(this, this.hideMenus));
	else
		this.hideMenus();
},

nodeMOver: function(evt, element)
{
	var oNode = this.DOM.findNode('n', 'id', element.nodeid);
	if (oNode != null)
	{
		var oMNode = new scp.controls.scpMenuNode(oNode);
		//this.hideMenus(new scp.controls.scpMenuNode(oNode.parentNode())); //MinDelay???
		oMNode.hover = true;
		this.assignCss(oMNode);
		this.expandNode(oMNode);
	}
},

nodeMOut: function(evt, element)
{
	var oNode = this.DOM.findNode('n', 'id', element.nodeid);
	if (oNode != null)
	{
		var oMNode = new scp.controls.scpMenuNode(oNode);
		this.assignCss(oMNode);
	}
},

createChildControl: function (sTag, sNodeID, sPrefix)
{
	var oCtl = scp.dom.createElement(sTag);
	oCtl.ns = this.ns;
	oCtl.nodeid = sNodeID;
	oCtl.id = this.ns + sPrefix + sNodeID;
	this.childControls[oCtl.id] = oCtl; //cache the control for quicker lookups
	return oCtl;
}, 

getChildControl: function (sNodeID, sPrefix)
{
	var sId = this.ns + sPrefix + sNodeID;
	if (this.childControls[sId] != null)	//retrive from cache if available
		return this.childControls[sId];
	else
		return $(sId);
}
}

//scpMenuBuilder object
scp_control.prototype.scpMenuBuilder = function (oMenu, oMNode, oCont)
{
	this.menu = oMenu;
	this.menuNode = oMNode;
	this.isVertical = oMenu.isNodeVertical(oMNode);
	this.container = oCont;	
	this.row = null;
	this.subcont = null;
}

//scpMenuBuilder specific methods
scp_control.prototype.scpMenuBuilder.prototype = 
{
appendChild: function(oCtl, bNewCell)
{
	this.subcont.appendChild(oCtl);	
},

newCell: function() {},

newCont: function()
{
	if (this.isVertical)
		this.row = this.menu.createChildControl('div', this.menuNode.id, 'ctr');	//container for Node
	else
		this.row = this.menu.createChildControl('span', this.menuNode.id, 'ctr');	//container for Node
	this.subcont = this.row;
	this.container.appendChild(this.subcont);
},

newRow: function()
{
	//if (this.container.childNodes.length > 0)
	//	this.container.appendChild(document.createElement('br'));
},

createSubMenu: function()
{
	return this.menu.createChildControl('DIV', this.menuNode.id, 'sub');	//Not using SPAN due to FireFox bug...
}
}

//scpMenuTableBuilder object inherits scpMenuBuilder
scp_control.prototype.scpMenuTableBuilder = function (oMenu, oMNode, oCont)
{
	this.base = scp.controls.scpMenuBuilder;
	this.base(oMenu, oMNode, oCont);	//invoke base class constructor
	//RootTable???
	/*if (oCont != null && oCont.rows.length > 0)
		this.row = oCont.rows[oCont.rows.length-1];*/
}

//scpMenuTableBuilder specific methods
scp_control.prototype.scpMenuTableBuilder.prototype = 
{
appendChild: function(oCtl, bNewCell)
{
	if (bNewCell)
		this.newCell();
	this.subcont.appendChild(oCtl);	
},

newCont: function()
{
	this.subcont = this.newCell();	//TD	
},

newCell: function()
{
	var  oTD = scp.dom.createElement('td');
	this.row.appendChild(oTD);	
	this.subcont = oTD;//
	return oTD;
},

newRow: function()
{
	this.row = this.menu.createChildControl('tr', this.menuNode.id, 'ctr');	//TR
	var oTBs = scp.dom.getByTagName('TBODY', this.container);
	oTBs[0].appendChild(this.row);
},

createSubMenu: function()
{		
	var oSub = this.menu.createChildControl('table', this.menuNode.id, 'sub');
	oSub.border = 0;
	oSub.cellPadding = 0;
	oSub.cellSpacing = 0;
	oSub.appendChild(scp.dom.createElement('tbody'));
	return oSub;
}
}

scp_control.prototype.scpMenuNode = function (oNode)
{
	this.base = scp.controls.scpNode;
	this.base(oNode);	//invoke base class constructor
	
	//menu specific attributes
	this.hover = false;
	this.expanded = oNode.getAttribute('expanded', '0') == '1' ? true : null;
	this.selected = oNode.getAttribute('selected', '0') == '1' ? true : null;
	this.clickAction = oNode.getAttribute('ca', scp.controls.action.postback);
	this.imageIndex = new Number(oNode.getAttribute('iIdx', '-1')); 
	this.urlIndex = new Number(oNode.getAttribute('uIdx', '-1')); 
	this.isBreak = oNode.getAttribute('break', '0') == '1' ? true : false;	//probably move to base scpNode
	this.lhtml = oNode.getAttribute('lhtml', '');
	this.rhtml = oNode.getAttribute('rhtml', '');
}

//scpMenuNode specific methods
scp_control.prototype.scpMenuNode.prototype = 
{
childNodes: function (iIndex)
{
	if (this.node.childNodes[iIndex] != null)
		return new scp.controls.scpMenuNode(this.node.childNodes[iIndex]);
},
getUrl: function (oMenu)
{
	if (this.urlIndex > -1)
		return oMenu.urlList[this.urlIndex] + this.url;
	else
		return this.url;
}
}

//BEGIN [Needed in case scripts load out of order]
if (typeof(scp_controls) != 'undefined')
{
	scp.extend(scp_controls.prototype, scp_control.prototype);
	scp.controls = new scp_controls();
}
//END [Needed in case scripts load out of order]