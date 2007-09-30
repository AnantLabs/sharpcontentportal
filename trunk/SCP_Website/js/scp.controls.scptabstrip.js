//BEGIN [Needed in case scripts load out of order]
if (typeof(scp_control) == 'undefined')
	eval('function scp_control() {}')
//END [Needed in case scripts load out of order]

scp_control.prototype.initTabStrip = function (oCtl) 
{	
	scp.controls.controls[oCtl.id] = new scp.controls.scpTabStrip(oCtl);
	return scp.controls.controls[oCtl.id];
}

//------- Constructor -------//
scp_control.prototype.scpTabStrip = function (o)
{
	this.ns = o.id;               //stores namespace for tabstrip
	this.container = o;                    //stores container
	this.contentContainer = scp.dom.getById(o.id + '_c');
	this.resultCtr = null;
	//--- Appearance Properties ---//

	this.workImg = scp.dom.getAttr(o, 'workImage', '');;	
	this.tabRenderMode = new Number(scp.dom.getAttr(o, 'trm', '0'));		
	this.postBack = scp.dom.getAttr(o, 'postback', '');
	this.callBack = scp.dom.getAttr(o, 'callback', '');
	this.callBackStatFunc = scp.dom.getAttr(o, 'callbackSF', '');
	this.callbackType = scp.dom.getAttr(o, 'cbtype', '0');
	this.tabClickFunc = scp.dom.getAttr(o, 'tabClickF', '');
	this.selectedIndexFunc = scp.dom.getAttr(o, 'selIdxF', '');
		
	scp.dom.addSafeHandler(o, 'onkeyup', this, 'keyUp');
	//scp.dom.addSafeHandler(o, 'onkeydown', this, 'keyDown');
	scp.dom.addSafeHandler(o, 'onkeypress', this, 'keyPress');
	
	this.lblCss = scp.dom.getAttr(o, 'css', '');
	this.lblCssSel = scp.dom.getAttr(o, 'csssel', this.lblCss);
	this.lblCssHover = scp.dom.getAttr(o, 'csshover', '');
	this.lblCssDisabled = scp.dom.getAttr(o, 'cssdisabled', '');
	this.workImg = scp.dom.getAttr(o, 'cssctr', '');
	
	this.pendingLookupId = null;

	this.tabClientIds = scp.dom.getAttr(o, 'tabs', '').split(',');
	this.tabs = new Array();
	this.tabIds = new Array();
	this.selectedIndex = -1;
	this.selectedTab = null;
	
	for (var i=0; i<this.tabClientIds.length; i++)
	{
		var oTab = $(this.tabClientIds[i] + '_l');
		var oIcn = scp.dom.getById(this.tabClientIds[i] + '_i', oTab);
		var oWrk = scp.dom.getById(this.tabClientIds[i] + '_w', oTab);
		var oCtr = $(this.tabClientIds[i]);
		var oscpTab = new scp.controls.scpTab(this, oTab, oCtr, oIcn, oWrk, i);
		oscpTab.selected = (oCtr != null && oCtr.style.display != 'none');  //initial assignment of selected if container exists, otherwise showTab handles this property
		this.tabIds[this.tabIds.length] = oscpTab.tabId;
		this.tabs[oscpTab.tabId] = oscpTab;
		scp.dom.addSafeHandler(oTab, 'onclick', this, 'tabClick');
		scp.dom.addSafeHandler(oTab, 'onmouseover', this, 'tabMouseOver');
		scp.dom.addSafeHandler(oTab, 'onmouseout', this, 'tabMouseOut');
		
		if (oscpTab.selected)
		{
			this.selectedIndex = i;
			this.selectedTab = oscpTab;
		}
		
	}
	        
	this.update();
}

scp_control.prototype.scpTabStrip.prototype = 
{
//--- Event Handlers ---//

keyPress: function (e, element) 
{
	var KEY_RETURN = 13;
	if(e.keyCode == KEY_RETURN)	//stop from posting
		return false;
},

keyUp: function (e, element) 
{
	var KEY_UP_ARROW = 38;
	var KEY_DOWN_ARROW = 40;
	var KEY_RETURN = 13;
	var KEY_ESCAPE = 27;		
},

tabClick: function(evt, element)
{
	var oTab = this.tabs[scp.dom.getAttr(element, 'tid', '')];
	if (oTab.enabled)
	{
		if (this.raiseEvent('tabClickFunc', evt, element))
			this.showTab(oTab.tabId);			
	}
},

tabMouseOver: function(evt, element)
{
	if (typeof(scp) != 'undefined')
	{
		var oTab = this.tabs[scp.dom.getAttr(element, 'tid', '')];
		oTab.hovered = true;
		oTab.assignCss();
	}
},

tabMouseOut: function(evt, element)
{
	if (typeof(scp) != 'undefined')
	{
		var oTab = this.tabs[scp.dom.getAttr(element, 'tid', '')];
		oTab.hovered = false;
		oTab.assignCss();
	}
},

// Methods

setSelectedIndex: function (iIdx)
{
	return this.showTab(this.tabIds[iIdx]);	
},

showTab: function (sTabId) 
{
    var oTab;
	if (this.needsLookup(sTabId))
	{
	    if (this.pendingLookupId == null)
	    {
			oTab = this.tabs[sTabId];
			oTab.showWork(true);
	        this.pendingLookupId = sTabId;
	        
	        if (this.tabRenderMode == '1') //postback
	        {
				//for (var sId in this.tabs)
				for (var i=0; i<this.tabIds.length;i++)
				{
					oTab = this.tabs[this.tabIds[i]];
					if (oTab.tabId == sTabId)
					{
						oTab.selected = true;
						this.selectedIndex = i;
						this.selectedTab = oTab;
						this.raiseEvent('selectedIndexFunc', null, this);
					}
					else
						oTab.selected = false;
				}
				this.update();
	        }
		    eval(this.callBack.replace('[TABID]', sTabId).replace("'[POST]'", oTab.postMode).replace("[CBTYPE]", oTab.callbackType));
		}
	}
	else
	{
		for (var i=0; i<this.tabIds.length;i++)
		{
			oTab = this.tabs[this.tabIds[i]];
	        if (oTab.tabId == sTabId)
	        {
				oTab.showWork(false);
	            oTab.selected = true;
	            oTab.rendered = true;
	            oTab.container.style.display = '';
	            //oTab.tab.className = oTab.cssSel;
	            oTab.assignCss();
	            this.selectedIndex = i;
	            this.selectedTab = oTab;
	            this.raiseEvent('selectedIndexFunc', null, this);
	        }
	        else 
	        {
	            if (oTab.container != null)
					oTab.container.style.display = 'none';
	            oTab.selected = false;
	            oTab.assignCss();
	        }
	    }
		
        this.update();		
	}
	return oTab;
},

raiseEvent: function(sFunc, evt, element)
{
	if (this[sFunc].length > 0)
	{
		var oPointerFunc = eval(this[sFunc]);
		return oPointerFunc(evt, element) != false;
	}
	return true;
},

update: function()
{
    var ary = new Array();
    for (var i=0; i<this.tabIds.length;i++)
        ary[ary.length] = this.tabs[this.tabIds[i]].serialize();
    
    //alert(ary.join(','));
    scp.setVar(this.ns + '_tabs', ary.join(','));

},

createTab: function (sHTML, sId) 
{
    var oSpan = scp.dom.createElement('span');
    oSpan.innerHTML = sHTML;
    
    var oCtr = oSpan.childNodes[0];
    if (oCtr.id != this.tabs[sId].clientId)
		oCtr = scp.dom.getById(this.tabs[sId].clientId, oSpan); //oSpan.childNodes[0];
    
    //oCtr.parentNode.removeNode(oCtr);
    this.tabs[sId].container = oCtr;
    //oCtr.style.display = 'none';    //?????
    this.contentContainer.appendChild(oCtr);
    return this.tabs[sId];
},

resetTab: function (sId) 
{
	var oTab = this.tabs[sId];
	if (oTab.container != null)
	{
		//oTab.container.style.display = 'none';
		scp.dom.removeChild(oTab.container);
		oTab.container = null;
	}
},

needsLookup: function (sTabId) 
{
    return this.tabs[sTabId].container == null; //scp.dom.getById(sTabId, this.container) == null;
},

callBackStatus: function (result, ctx, req) 
{
	var oTab = ctx;
	
	if (oTab.callBackStatFunc.length > 0)
	{
		var oPointerFunc = eval(oTab.callBackStatFunc);
		oPointerFunc(result, ctx, req);	
	}
	
},

callBackSuccess: function (result, ctx, req) 
{
	var oCtl = ctx;
	if (oCtl.callBackStatFunc != null && oCtl.callBackStatFunc.length > 0)
	{
		var oPointerFunc = eval(oCtl.callBackStatFunc);
		oPointerFunc(result, ctx, req);	
	}
	var oTab = oCtl.createTab(result, oCtl.pendingLookupId);
	oCtl.pendingLookupId = null;
	oCtl.showTab(oTab.tabId);

},

callBackFail: function (result, ctx) 
{
	alert(result);
}

}//end scpTabStrip prototype


scp_control.prototype.scpTab = function(oStrip, oTab, oCtr, oIcn, oWrk, iIdx)
{
	if (oTab != null)
	{
	    this.rendered = (oCtr != null);
	    this.selected = false;
	    this.hovered = false;
	    this.tabIndex = iIdx;
	    this.strip = oStrip;
	    this.tab = oTab;
		this.container = oCtr; 
		this.icon = oIcn;
		this.work = oWrk;
		this.clientId = oTab.id.substring(0, oTab.id.length-2);
		this.tabId = scp.dom.getAttr(oTab, 'tid', '');
		this.css = scp.dom.getAttr(oTab, 'css', oStrip.lblCss);
		this.cssSel = scp.dom.getAttr(oTab, 'csssel', oStrip.lblCssSel);
		this.cssHover = scp.dom.getAttr(oTab, 'csshover', oStrip.lblCssHover);
		this.cssDisabled = scp.dom.getAttr(oTab, 'cssdisabled', oStrip.lblCssDisabled);
		this.postMode = scp.dom.getAttr(oTab, 'postmode', null);
		this.enabled = (scp.dom.getAttr(oTab, 'enabled', '1')) == '1';
		this.callbackType = scp.dom.getAttr(oTab, 'cbtype', oStrip.callbackType);
		if (this.postMode)
			this.postMode = '\'' + this.postMode + '\'';
	}
}

scp_control.prototype.scpTab.prototype = 
{
serialize: function ()
{
    //bitvalues - 1=rendered, 2=selected, 4=enabled (so 7 means rendered, selected, and enabled)
    return this.tabId + '=' + ((this.rendered ? 1 : 0) + (this.selected ? 2 : 0) + + (this.enabled ? 4 : 0));
},
showWork: function (bShow)
{

	if (this.work != null)
	{
		if (bShow)
		{
			this.work.style.display = '';
			if (this.icon != null)
				this.icon.style.display = 'none';
		}
		else
		{
			this.work.style.display = 'none';
			if (this.icon != null)
				this.icon.style.display = '';
		}
	}
},
enable: function()
{
	this.enabled = true;
	
},
disable: function()
{
	this.enabled = false;
},
assignCss: function()
{
	var sCss = '';
	if (this.enabled == false && this.cssDisabled.length > 0)
		sCss = this.cssDisabled;
	else
	{
	    if (this.hovered && this.cssHover.length > 0)
	        sCss = this.cssHover;
	    else
			sCss = (this.selected ? this.cssSel : this.css);
	}
	this.tab.className = sCss;
}
}


//BEGIN [Needed in case scripts load out of order]
if (typeof(scp_controls) != 'undefined')
{
	scp.extend(scp_controls.prototype, scp_control.prototype);
	scp.controls = new scp_controls();
}
//END [Needed in case scripts load out of order]