
scp_control.prototype.scpToolBar = function (ns)
{
	this.ns = ns;
	
	this.css = null;
	this.cssButton = null;
	this.cssButtonHover = null;
	this.moutDelay = null;

	this.buttons = [];
	this.relatedCtl = null;
	this.ctr = document.createElement('span');
	this.ctr.style.position = 'relative';	//allow relative positioning without taking up space
	this.ctl = document.createElement('span');
	this.ctr.appendChild(this.ctl);
	this.ctl.style.display = 'none';
	this.moutDelay = 1000;
}

scp_control.prototype.scpToolBar.prototype = 
{

loadDefinition: function(sToolBarId, sNsPrefix, oRelatedCtl, oParent, oInsertBefore, fActionHandler)
{
	var oDef = scp.controls.toolbars[sNsPrefix + ':' + sToolBarId];
	if (oDef == null)	//try and load global toolbar
		oDef = scp.controls.toolbars[sToolBarId];

	if (oDef)
	{
		this.relatedCtl = oRelatedCtl;
		this.css = oDef.css;
		this.cssButton = oDef.cssb;
		this.cssButtonHover = oDef.cssbh;
		for (var i=0; i<oDef.btns.length; i++)
		{
			var oBtn = oDef.btns[i];
			this.addButton(oBtn.key, oBtn.ca, oBtn.css, oBtn.cssh, oBtn.img, oBtn.txt, oBtn.alt, oBtn.js, oBtn.url, fActionHandler, true);
		}
			
		if (oDef.mod)
			this.moutDelay = oDef.mod;
		
		if (oInsertBefore)
			oParent.insertBefore(this.ctr, oInsertBefore);
		else
			oParent.appendChild(this.ctr);	
	}

},

addButton: function (sKey, sClickAct, sCss, sCssHover, sImg, sText, sToolTip, sJs, sUrl, fAction, bVisible)
{
	if (sKey == null)
		sKey = this.buttons.length;
	if (this.cssButton)
		sCss = this.cssButton + ' ' + sCss;
	if (this.cssButtonHover)
		sCssHover = this.cssButtonHover + ' ' + sCssHover;
		
	this.buttons[sKey] = new scp.controls.scpToolBarButton(sKey, sClickAct, sCss, sCssHover, sImg, sText, sToolTip, sJs, sUrl, fAction, bVisible, this);
},

refresh: function()
{
	this.ctl.className = this.css;
	for (var sKey in this.buttons)
	{
		var oBtn = this.buttons[sKey];
		if (oBtn.ctl == null)
		{
			oBtn.render();
			this.ctl.appendChild(oBtn.ctl);
		}
		oBtn.ctl.style.display = (oBtn.visible ? '' : 'none');
	}	
},

show: function(bBeginHide)
{
	scp.cancelDelay(this.ns + 'mout');
	if (this.ctl.style.display != '')
	{
		this.refresh();
		this.ctl.style.display = '';
	}
	if (bBeginHide)
		this.beginHide();
},

beginHide: function()
{
	if (this.moutDelay > 0)
		scp.doDelay(this.ns + 'mout', this.moutDelay, scp.createDelegate(this, this.hide));

}, 

hide: function()
{
	this.ctl.style.display = 'none';
}

}

scp_control.prototype.scpToolBarButton = function (sKey, sClickAct, sCss, sCssHover, sImg, sText, sToolTip, sJs, sUrl, fAction, bVisible, oToolbar)
{
	this.ctl = null;
	this.key = sKey;
	this.clickAction = sClickAct;
	this.tb = oToolbar;
	this.css = sCss;
	this.cssHover = sCssHover;
	this.img = sImg;
	this.tooltip = sToolTip;
	this.txt = sText;
	this.js = sJs;
	this.url = sUrl;
	this.action = fAction;
	this.visible = bVisible;
}

scp_control.prototype.scpToolBarButton.prototype = 
{

render: function ()
{
	if (!this.ctl)
	{
		this.ctl = document.createElement('span');
		this.ctl.className = this.css;
		if (this.tooltip)
			this.ctl.title = this.tooltip;
		this.ctl.key = this.key;
		if (this.img)
		{
			var oImg = document.createElement('img');
			oImg.src = this.img;
			this.ctl.appendChild(oImg);
		}
		if (this.txt)
		{
			var oSpan = document.createElement('span');
			oSpan.innerHTML = this.txt;
			this.ctl.appendChild(oSpan);
		}
		scp.dom.addSafeHandler(this.ctl, 'onmouseover', this, 'mouseOver');
		scp.dom.addSafeHandler(this.ctl, 'onmouseout', this, 'mouseOut');
		if (scp.dom.browser.isType(scp.dom.browser.InternetExplorer))  //ie has issue if contenteditable looses focus to a span (img are ok).  this works for both
			scp.dom.addSafeHandler(this.ctl, 'onmousedown', this, 'click');
		else
			scp.dom.addSafeHandler(this.ctl, 'onclick', this, 'click');
	}
},

click: function () 
{
	if (this.clickAction == 'js')
		eval(this.js);
	else if (this.clickAction == 'navigate')
		scp.dom.navigate(this.url);
	else
		this.action(this, this.tb.relatedCtl);

},

mouseOver: function () 
{
	this.tb.show(false);
	if (this.cssHover)
		this.ctl.className = this.css + ' ' + this.cssHover;
},

mouseOut: function () 
{
	this.tb.beginHide();
	if (this.cssHover)
		this.ctl.className = this.css;
},

getVal: function(sVal, sDef)
{
	return (sVal ? sVal : sDef);
}

}

scp.extend(scp_controls.prototype, scp_control.prototype);
//scp.controls = new scp_controls();

scp.dom.setScriptLoaded('scp.controls.scptoolbar.js');	//callback for dynamically loaded script
