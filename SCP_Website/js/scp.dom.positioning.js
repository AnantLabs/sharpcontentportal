if (typeof(__scp_m_aNamespaces) == 'undefined')	//include in each scp ClientAPI namespace file for dependency loading
	var __scp_m_aNamespaces = new Array();

function scp_dom_positioning()
{
	this.pns = 'scp.dom';
	this.ns = 'positioning';
	this.dragCtr=null;
	this.dragCtrDims=null;
	this.dependencies = 'scp,scp.dom'.split(',');
	this.isLoaded = false;	
}

scp_dom_positioning.prototype.bodyScrollLeft = function ()
{
	if (window.pageYOffset)
		return window.pageYOffset;
	
	var oBody = (document.compatMode && document.compatMode != "BackCompat") ? document.documentElement : document.body;		
	return oBody.scrollLeft;
}

scp_dom_positioning.prototype.bodyScrollTop = function()
{
	if (window.pageXOffset)
		return window.pageXOffset;

	var oBody = (document.compatMode && document.compatMode != "BackCompat") ? document.documentElement : document.body;
	return oBody.scrollTop;
}

scp_dom_positioning.prototype.viewPortHeight = function()
{
	// supported in Mozilla, Opera, and Safari
  if(window.innerHeight)
		return window.innerHeight;

	var oBody = (document.compatMode && document.compatMode != "BackCompat") ? document.documentElement : document.body;		
	return oBody.clientHeight;	
}

scp_dom_positioning.prototype.viewPortWidth = function()
{
	// supported in Mozilla, Opera, and Safari
	if(window.innerWidth)
		return window.innerWidth;

	var oBody = (document.compatMode && document.compatMode != "BackCompat") ? document.documentElement : document.body;		
	return oBody.clientWidth;	
}


scp_dom_positioning.prototype.dragContainer = function(oCtl)
{
	var iNewLeft=0;
	var iNewTop=0;
	var e = scp.dom.event.object;
	var oCont = scp.dom.getById(oCtl.contID);
	var oTitle = scp.dom.positioning.dragCtr;
	var iScrollTop = this.bodyScrollTop();
	var iScrollLeft = this.bodyScrollLeft();

	if (oCtl.startLeft == null)
		oCtl.startLeft = e.clientX - this.elementLeft(oCont) + iScrollLeft;

	if (oCtl.startTop == null)
		oCtl.startTop = e.clientY - this.elementTop(oCont) + iScrollTop;

	if (oCont.style.position == 'relative')
		oCont.style.position = 'absolute';
	
	iNewLeft = e.clientX - oCtl.startLeft + iScrollLeft;
	iNewTop = e.clientY - oCtl.startTop + iScrollTop;

	if (iNewLeft > this.elementWidth(document.forms[0]))// this.viewPortWidth() + iScrollLeft)
		iNewLeft = this.elementWidth(document.forms[0]);//this.viewPortWidth() + iScrollLeft;
	
	if (iNewTop > this.elementHeight(document.forms[0])) //this.viewPortHeight() + iScrollTop)
		iNewTop = this.elementHeight(document.forms[0]);//this.viewPortHeight() + iScrollTop;
	
	oCont.style.left = iNewLeft + 'px';
	oCont.style.top = iNewTop + 'px';

	if (oTitle != null && oTitle.dragOver != null)
		eval(oCtl.dragOver);
}

scp_dom_positioning.prototype.elementHeight = function (eSrc)
{	
	if (eSrc.offsetHeight == null || eSrc.offsetHeight == 0)
	{
		if (eSrc.offsetParent == null)
			return 0;
		if (eSrc.offsetParent.offsetHeight == null || eSrc.offsetParent.offsetHeight == 0)
		{
			if (eSrc.offsetParent.offsetParent != null)
				return eSrc.offsetParent.offsetParent.offsetHeight; //needed for Konqueror
			else
				return 0;
		}
		else
			return eSrc.offsetParent.offsetHeight;
	}
	else
		return eSrc.offsetHeight;
}

scp_dom_positioning.prototype.elementLeft = function (eSrc)
{	
	return this.elementPos(eSrc).l;
}

scp_dom_positioning.prototype.elementOverlapScore = function (oDims1, oDims2)
{		
	var iLeftScore = 0;
	var iTopScore = 0;
	if (oDims1.l <= oDims2.l && oDims2.l <= oDims1.r)	//if left of content fits between panel borders
		iLeftScore += (oDims1.r < oDims2.r ? oDims1.r : oDims2.r) - oDims2.l;	//set score based off left of content to closest right border
	if (oDims2.l <= oDims1.l && oDims1.l <= oDims2.r)	//if left of panel fits between content borders
		iLeftScore += (oDims2.r < oDims1.r ? oDims2.r : oDims1.r)  - oDims1.l; //set score based off left of panel to closest right border
	if (oDims1.t <= oDims2.t && oDims2.t <= oDims1.b)	//if top of content fits between panel borders
		iTopScore += (oDims1.b < oDims2.b ? oDims1.b : oDims2.b)  - oDims2.t;	//set score based off top of content to closest bottom border
	if (oDims2.t <= oDims1.t && oDims1.t <= oDims2.b)	//if top of panel fits between content borders
		iTopScore += (oDims2.b < oDims1.b ? oDims2.b : oDims1.b) -  - oDims1.t; //set score based off top of panel to closest bottom border
	
	return iLeftScore * iTopScore;
}

scp_dom_positioning.prototype.elementTop = function (eSrc)
{
	return this.elementPos(eSrc).t;
}

scp_dom_positioning.prototype.elementPos = function (eSrc)
{
	var oPos = new Object();
	oPos.t = 0;	//relative top
	oPos.l = 0; //relative left
	oPos.at = 0; //actual top
	oPos.al = 0; //actual left
	
	var eParent = eSrc;
	
	if (eSrc.style.position == 'absolute')
	{
		oPos.t = eParent.offsetTop;
		oPos.l = eParent.offsetLeft;
	}
		
	while (eParent != null)
	{
		oPos.at += eParent.offsetTop;
		oPos.al += eParent.offsetLeft;
		
		if (eSrc.style.position != 'absolute')
		{
			if (eParent.id == eSrc.id || eParent.style.position != 'relative')
			{
				oPos.t += eParent.offsetTop;
				oPos.l += eParent.offsetLeft;
			}
		}
		
		eParent = eParent.offsetParent;
		if (eParent == null || (eParent.tagName.toUpperCase() == "BODY" && scp.dom.browser.isType(scp.dom.browser.Konqueror)))  //safari no longer needed here
			break;		
	}	
	return oPos;
}

scp_dom_positioning.prototype.elementWidth = function (eSrc)
{
	if (eSrc.offsetWidth == null || eSrc.offsetWidth == 0)
	{
		if (eSrc.offsetParent == null)
			return 0;
		if (eSrc.offsetParent.offsetWidth == null || eSrc.offsetParent.offsetWidth == 0)
		{
			if (eSrc.offsetParent.offsetParent != null)
				return eSrc.offsetParent.offsetParent.offsetWidth; //needed for Konqueror
			else
				return 0;
		}
		else
			return eSrc.offsetParent.offsetWidth

	}
	else
		return eSrc.offsetWidth;
}

scp_dom_positioning.prototype.enableDragAndDrop = function(oContainer, oTitle, sDragCompleteEvent, sDragOverEvent)
{
	scp.dom.attachEvent(document.body, 'onmousemove', __scp_bodyMouseMove);
	scp.dom.attachEvent(document.body, 'onmouseup', __scp_bodyMouseUp);
	scp.dom.attachEvent(oTitle, 'onmousedown', __scp_containerMouseDownDelay);
	
	if (scp.dom.browser.type == scp.dom.browser.InternetExplorer)
		oTitle.style.cursor = 'hand';
	else
		oTitle.style.cursor = 'pointer';
	
	if (oContainer.id.length == 0)
		oContainer.id = oTitle.id + '__scpCtr';
		
	oTitle.contID = oContainer.id;
	if (sDragCompleteEvent != null)
		oTitle.dragComplete = sDragCompleteEvent;
	if (sDragOverEvent != null)
		oTitle.dragOver = sDragOverEvent;
	
	return true;
}

scp_dom_positioning.prototype.placeOnTop = function(oCont, bShow, sSrc)
{
	if (scp.dom.browser.isType(scp.dom.browser.Opera, scp.dom.browser.Opera, scp.dom.browser.Mozilla, scp.dom.browser.Netscape))
		return;	//not needed

	var oIFR=scp.dom.getById('ifr' + oCont.id);
		
	if (bShow)
	{
		if (oIFR == null)
		{
			var oIFR = document.createElement('iframe');
			oIFR.id = 'ifr' + oCont.id;
			if (sSrc != null)
				oIFR.src = sSrc;
			oIFR.style.top = '0px';
			oIFR.style.left = '0px';
			oIFR.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=0)";
			oIFR.scrolling = 'no';
			oIFR.frameBorder = 'no';
			oIFR.style.display = 'none';
			oIFR.style.position = 'absolute';
			oCont.parentNode.appendChild(oIFR);
		}
		var oDims = new scp.dom.positioning.dims(oCont);

		oIFR.style.width=oDims.w;
		oIFR.style.height=oDims.h;
		oIFR.style.top=oDims.t + 'px';
		oIFR.style.left=oDims.l + 'px';
		
		var iIndex = scp.dom.getCurrentStyle(oCont, 'zIndex');
		if (iIndex == null || iIndex == 0)
			oCont.style.zIndex = 1;
		oIFR.style.zIndex=iIndex-1;
		oIFR.style.display="block";
		
	}
	else if (oIFR != null)
		oIFR.style.display='none';
}


//dims object
scp_dom_positioning.prototype.dims = function (eSrc)
{
	var bHidden = (eSrc.style.display == 'none');
	
	if (bHidden)
		eSrc.style.display = "";
	
	this.w = scp.dom.positioning.elementWidth(eSrc);
	this.h = scp.dom.positioning.elementHeight(eSrc);
	var oPos = scp.dom.positioning.elementPos(eSrc);
	this.t = oPos.t;
	this.l = oPos.l;
	this.at = oPos.at;	//actual top
	this.al = oPos.al;	//actual left
	this.rot = this.at - this.t; //relative offset top
	this.rol = this.al - this.l; //relative offset left
	
	this.r = this.l + this.w;
	this.b = this.t + this.h;
	
	if (bHidden)
		eSrc.style.display = "none";
	
}

scp_dom_positioning.prototype.dependenciesLoaded = function()
{
	return (typeof(scp) != 'undefined' && typeof(scp.dom) != 'undefined');
}

scp_dom_positioning.prototype.loadNamespace = function ()
{
	if (this.isLoaded == false)
	{		
		if (this.dependenciesLoaded())
		{
			scp.dom.positioning = this; 
			this.isLoaded = true;
			scp.loadDependencies(this.pns, this.ns);
		}
	}	
}

function __scp_containerMouseDownDelay()
{
	var oTitle = scp.dom.event.srcElement;
	scp.doDelay('__scp_dragdrop', 500, __scp_containerMouseDown, oTitle);
}

function __scp_containerMouseDown(oCtl)
{
	//oCtl = scp.dom.event.srcElement;
	while (oCtl.contID == null)
	{
		oCtl = oCtl.parentNode;
		if (oCtl.tagName.toUpperCase() == 'BODY')
			return;
	}
	scp.dom.positioning.dragCtr = oCtl;	//assumption is we can only drag one thing at a time
	oCtl.startTop = null;
	oCtl.startLeft = null;

	var oCont = scp.dom.getById(oCtl.contID);
	if (oCont.style.position == null || oCont.style.position.length == 0)
		oCont.style.position = 'relative';
	
	scp.dom.positioning.dragCtrDims = new scp.dom.positioning.dims(oCont);	//store now so we aren't continually calculating
	
	if (oCont.getAttribute('_b') == null)
	{
		oCont.setAttribute('_b', oCont.style.backgroundColor); 
		oCont.setAttribute('_z', oCont.style.zIndex); 
		oCont.setAttribute('_w', oCont.style.width); 
		oCont.setAttribute('_d', oCont.style.border); 
		oCont.style.zIndex = 9999;
		oCont.style.backgroundColor = scp_HIGHLIGHT_COLOR;
		oCont.style.border = '4px outset ' + scp_HIGHLIGHT_COLOR;
		oCont.style.width = scp.dom.positioning.elementWidth(oCont);
		if (scp.dom.browser.type == scp.dom.browser.InternetExplorer)
			oCont.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=80)';
	}
}

function __scp_bodyMouseUp()
{
	scp.cancelDelay('__scp_dragdrop');
	var oCtl = scp.dom.positioning.dragCtr;
	if (oCtl != null && oCtl.dragComplete != null)
	{
		eval(oCtl.dragComplete);

		var oCont = scp.dom.getById(oCtl.contID);

		oCont.style.backgroundColor = oCont.getAttribute('_b'); 
		oCont.style.zIndex = oCont.getAttribute('_z'); 
		oCont.style.width = oCont.getAttribute('_w'); 
		oCont.style.border = oCont.getAttribute('_d'); 
		oCont.setAttribute('_b', null); 
		oCont.setAttribute('_z', null); 
		if (scp.dom.browser.type == scp.dom.browser.InternetExplorer)
			oCont.style.filter = null;

	}
	
	scp.dom.positioning.dragCtr = null;
}

function __scp_bodyMouseMove()
{
	if (scp.dom.positioning.dragCtr != null)
		scp.dom.positioning.dragContainer(scp.dom.positioning.dragCtr);
}

__scp_m_aNamespaces[__scp_m_aNamespaces.length] = new scp_dom_positioning();
for (var i=__scp_m_aNamespaces.length-1; i>=0; i--)
	__scp_m_aNamespaces[i].loadNamespace();
