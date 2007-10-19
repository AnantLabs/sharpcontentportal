//General
//for example: instead of each module writing out script found in moduleMaxMin_OnClick have the functionality cached
//

var scp_COL_DELIMITER = String.fromCharCode(16);
var scp_ROW_DELIMITER = String.fromCharCode(15);
var __scp_m_bPageLoaded = false;

window.onload = __scp_Page_OnLoad;

function __scp_ClientAPIEnabled()
{
	return typeof(scp) != 'undefined';
}


function __scp_Page_OnLoad()
{
	if (__scp_ClientAPIEnabled())
	{
		var sLoadHandlers = scp.getVar('__scp_pageload');
		if (sLoadHandlers != null)
			eval(sLoadHandlers);
		
		scp.dom.attachEvent(window, 'onscroll', __scp_bodyscroll);
	}
	__scp_m_bPageLoaded = true;
}

function __scp_KeyDown(iKeyCode, sFunc, e)
{
	if (e == null)
		e = window.event;

	if (e.keyCode == iKeyCode)
	{
		eval(unescape(sFunc));
		return false;
	}
}

function __scp_bodyscroll() 
{
	var oF=document.forms[0];	
	if (__scp_ClientAPIEnabled() && __scp_m_bPageLoaded)
		oF.ScrollTop.value=document.documentElement.scrollTop ? document.documentElement.scrollTop : scp.dom.getByTagName("body")[0].scrollTop;
}

function __scp_setScrollTop(iTop)
{
	if (__scp_ClientAPIEnabled())
	{
		if (iTop == null)
			iTop = document.forms[0].ScrollTop.value;
	
		var sID = scp.getVar('ScrollToControl');
		if (sID != null && sID.length > 0)
		{
			var oCtl = scp.dom.getById(sID);
			if (oCtl != null)
			{
				iTop = scp.dom.positioning.elementTop(oCtl);
				scp.setVar('ScrollToControl', '');
			}
		}
		window.scrollTo(0, iTop);
	}
}

//Focus logic
function __scp_SetInitialFocus(sID)
{
	var oCtl = scp.dom.getById(sID);	
	if (oCtl != null && __scp_CanReceiveFocus(oCtl))
	{
		oCtl.focus();
	}
}	

function __scp_CanReceiveFocus(e)
{
	//probably should call getComputedStyle for classes that cause item to be hidden
	if (e.style.display != 'none' && e.tabIndex > -1 && e.disabled == false && e.style.visible != 'hidden')
	{
		var eParent = e.parentElement;
		while (eParent != null && eParent.tagName != 'BODY')
		{
			if (eParent.style.display == 'none' || eParent.disabled || eParent.style.visible == 'hidden')
				return false;
			eParent = eParent.parentElement;
		}
		return true;
	}
	else
		return false;
}

//Max/Min Script
function __scp_ContainerMaxMin_OnClick(oLnk, sContentID)
{
	var oContent = scp.dom.getById(sContentID);
	if (oContent != null)
	{
		var oBtn = oLnk.childNodes[0];
		var sContainerID = oLnk.getAttribute('containerid');
		var sCookieID = oLnk.getAttribute('cookieid');
		var sCurrentFile = oBtn.src.toLowerCase().substr(oBtn.src.lastIndexOf('/'));
		var sMaxFile;
		var sMaxIcon;
		var sMinIcon;

		if (scp.getVar('min_icon_' + sContainerID))
		{
			sMinIcon = scp.getVar('min_icon_' + sContainerID);
		}
		else
		{
			sMinIcon = scp.getVar('min_icon');
		}

		if (scp.getVar('max_icon_' + sContainerID))
		{
			sMaxIcon = scp.getVar('max_icon_' + sContainerID);
		}
		else
		{
			sMaxIcon = scp.getVar('max_icon');
		}

		sMaxFile = sMaxIcon.toLowerCase().substr(sMaxIcon.lastIndexOf('/'));

		var iNum = 5;
		if (oLnk.getAttribute('animf') != null)
		{
			iNum = new Number(oLnk.getAttribute('animf'));
		}
			
		if (sCurrentFile == sMaxFile)
		{
			oBtn.src = sMinIcon;				
			//oContent.style.display = '';
			scp.dom.expandElement(oContent, iNum);
			oBtn.title = scp.getVar('min_text');
			if (sCookieID != null)
			{
				if (scp.getVar('__scp_' + sContainerID + ':defminimized') == 'true')
					scp.dom.setCookie(sCookieID, 'true', 365, '/');
				else
					scp.dom.deleteCookie(sCookieID, '/');
			}
			else
				scp.setVar('__scp_' + sContainerID + '_Visible', 'true');
		}
		else
		{
			oBtn.src = sMaxIcon;				
			//oContent.style.display = 'none';
			scp.dom.collapseElement(oContent, iNum);
			oBtn.title = scp.getVar('max_text');
			if (sCookieID != null)
			{
				if (scp.getVar('__scp_' + sContainerID + ':defminimized') == 'true')
					scp.dom.deleteCookie(sCookieID, '/');
				else
					scp.dom.setCookie(sCookieID, 'false', 365, '/');				
			}
			else
				scp.setVar('__scp_' + sContainerID + '_Visible', 'false');			
		}
		
		return true;	//cancel postback
	}
	return false;	//failed so do postback
}

function __scp_Help_OnClick(sHelpID)
{
	var oHelp = scp.dom.getById(sHelpID);
	if (oHelp != null)
	{
		if (oHelp.style.display == 'none')
			oHelp.style.display = '';
		else
			oHelp.style.display = 'none';

		return true;	//cancel postback
	}
	return false;	//failed so do postback
}

function __scp_SectionMaxMin(oBtn, sContentID)
{
	var oContent = scp.dom.getById(sContentID);
	if (oContent != null)
	{
		var sMaxIcon = oBtn.getAttribute('max_icon');
		var sMinIcon = oBtn.getAttribute('min_icon');
		if (oContent.style.display == 'none')
		{
			oBtn.src = sMinIcon;				
			oContent.style.display = '';
			scp.setVar(oBtn.id + ':exp', 1);
		}
		else
		{
			oBtn.src = sMaxIcon;				
			oContent.style.display = 'none';
			scp.setVar(oBtn.id + ':exp', 0);
		}
		return true;	//cancel postback
	}
	return false;	//failed so do postback
}

//Drag N Drop
function __scp_enableDragDrop()
{
	var aryConts = scp.getVar('__scp_dragDrop').split(";");	
	var aryTitles;

	for (var i=0; i < aryConts.length; i++)
	{
		aryTitles = aryConts[i].split(" ");
		if (aryTitles[0].length > 0)
		{			
			var oCtr = scp.dom.getById(aryTitles[0]);
			var oTitle = scp.dom.getById(aryTitles[1]);
			if (oCtr != null && oTitle != null)
			{
				oCtr.setAttribute('moduleid', aryTitles[2]);
				scp.dom.positioning.enableDragAndDrop(oCtr, oTitle, '__scp_dragComplete()', '__scp_dragOver()');
			}	
		}
	}
}

var __scp_oPrevSelPane;
var __scp_oPrevSelModule;
var __scp_dragEventCount=0;
function __scp_dragOver()
{
	__scp_dragEventCount++;
	if (__scp_dragEventCount % 75 != 0)	//only calculate position every 75 events
		return;
	
	var oCont = scp.dom.getById(scp.dom.positioning.dragCtr.contID);

	var oPane = __scp_getMostSelectedPane(scp.dom.positioning.dragCtr);
		
	if (__scp_oPrevSelPane != null)	//reset previous pane's border
		__scp_oPrevSelPane.pane.style.border = __scp_oPrevSelPane.origBorder;

	if (oPane != null)
	{		
		__scp_oPrevSelPane = oPane;
		oPane.pane.style.border = '4px double ' + scp_HIGHLIGHT_COLOR;
		var iIndex = __scp_getPaneControlIndex(oCont, oPane);

		var oPrevCtl;
		var oNextCtl;
		for (var i=0; i<oPane.controls.length; i++)
		{
			if (iIndex > i && oPane.controls[i].id != oCont.id)
				oPrevCtl = oPane.controls[i];
			if (iIndex <= i && oPane.controls[i].id != oCont.id)
			{
				oNextCtl = oPane.controls[i];
				break;
			}
		}			
		
		if (__scp_oPrevSelModule != null)
			scp.dom.getNonTextNode(__scp_oPrevSelModule.control).style.border = __scp_oPrevSelModule.origBorder;
			

		if (oNextCtl != null)
		{
			__scp_oPrevSelModule = oNextCtl;
			scp.dom.getNonTextNode(oNextCtl.control).style.borderTop = '5px groove ' + scp_HIGHLIGHT_COLOR;
		}
		else if (oPrevCtl != null)
		{
			__scp_oPrevSelModule = oPrevCtl;
			scp.dom.getNonTextNode(oPrevCtl.control).style.borderBottom = '5px groove ' + scp_HIGHLIGHT_COLOR;
		}
	}
}

function __scp_dragComplete()
{
	var oCtl = scp.dom.getById(scp.dom.positioning.dragCtr.contID);
	var sModuleID = oCtl.getAttribute('moduleid');
	
	if (__scp_oPrevSelPane != null)
		__scp_oPrevSelPane.pane.style.border = __scp_oPrevSelPane.origBorder;

	if (__scp_oPrevSelModule != null)
		scp.dom.getNonTextNode(__scp_oPrevSelModule.control).style.border = __scp_oPrevSelModule.origBorder;
		
	var oPane = __scp_getMostSelectedPane(scp.dom.positioning.dragCtr);
	var iIndex;
	if (oPane == null)
	{
		var oPanes = __scp_Panes();
		for (var i=0; i<oPanes.length; i++)
		{
			if (oPanes[i].id == oCtl.parentNode.id)
				oPane = oPanes[i];
		}
	}	
	if (oPane != null)
	{
		iIndex = __scp_getPaneControlIndex(oCtl, oPane);
		__scp_MoveToPane(oPane, oCtl, iIndex);

		scp.callPostBack('MoveToPane', 'moduleid=' + sModuleID, 'pane=' + oPane.paneName, 'order=' + iIndex * 2); 
	}
}

function __scp_MoveToPane(oPane, oCtl, iIndex)
{

	if (oPane != null)
	{
		var aryCtls = new Array();
		for (var i=iIndex; i<oPane.controls.length; i++)
		{
			if (oPane.controls[i].control.id != oCtl.id)
				aryCtls[aryCtls.length] = oPane.controls[i].control;

			scp.dom.removeChild(oPane.controls[i].control);
		}
		scp.dom.appendChild(oPane.pane, oCtl);
		oCtl.style.top=0;
		oCtl.style.left=0;
		oCtl.style.position = 'relative';
		for (var i=0; i<aryCtls.length; i++)
		{
			scp.dom.appendChild(oPane.pane, aryCtls[i]);
		}
		__scp_RefreshPanes();
	}
	else
	{
		oCtl.style.top=0;
		oCtl.style.left=0;
		oCtl.style.position = 'relative';
	}
}

function __scp_RefreshPanes()
{
	var aryPanes = scp.getVar('__scp_Panes').split(';');
	var aryPaneNames = scp.getVar('__scp_PaneNames').split(';');
	__scp_m_aryPanes = new Array();
	for (var i=0; i<aryPanes.length; i++)
	{
		if (aryPanes[i].length > 0)
			__scp_m_aryPanes[__scp_m_aryPanes.length] = new __scp_Pane(scp.dom.getById(aryPanes[i]), aryPaneNames[i]);
	}
}

var __scp_m_aryPanes;
var __scp_m_aryModules;
function __scp_Panes()
{
	if (__scp_m_aryPanes == null)
	{
		__scp_m_aryPanes = new Array();
		__scp_RefreshPanes();
	}
	return __scp_m_aryPanes;
}

function __scp_Modules(sModuleID)
{
	if (__scp_m_aryModules == null)
		__scp_RefreshPanes();
	
	return __scp_m_aryModules[sModuleID];
}

function __scp_getMostSelectedPane(oContent)
{
	var oCDims = new scp.dom.positioning.dims(oContent);
	var iTopScore=0;
	var iScore;
	var oTopPane;
	for (var i=0; i<__scp_Panes().length; i++)
	{
		var oPane = __scp_Panes()[i];
		var oPDims = new scp.dom.positioning.dims(oPane.pane);
		iScore = scp.dom.positioning.elementOverlapScore(oPDims, oCDims);
		
		if (iScore > iTopScore)
		{
			iTopScore = iScore;
			oTopPane = oPane;
		}
	}
	return oTopPane;
}

function __scp_getPaneControlIndex(oContent, oPane)
{
	if (oPane == null)
		return;
	var oCDims = new scp.dom.positioning.dims(oContent);
	var oCtl;
	if (oPane.controls.length == 0)
		return 0;
	for (var i=0; i<oPane.controls.length; i++)
	{
		oCtl = oPane.controls[i];
		var oIDims = new scp.dom.positioning.dims(oCtl.control);
		if (oCDims.t < oIDims.t)
			return oCtl.index;
	}
	if (oCtl != null)
		return oCtl.index+1;
	else
		return 0;
}

//Objects
function __scp_Pane(ctl, sPaneName)
{
	this.pane = ctl;
	this.id = ctl.id;
	this.controls = new Array();
	this.origBorder = ctl.style.border;
	this.paneName = sPaneName;
	
	var iIndex = 0;
	var strModuleOrder='';
	for (var i=0; i<ctl.childNodes.length; i++)
	{
		var oNode = ctl.childNodes[i];
		if (scp.dom.isNonTextNode(oNode))	
		{
			if (__scp_m_aryModules == null)
				__scp_m_aryModules = new Array();

			//if (oNode.tagName == 'A' && oNode.childNodes.length > 0)
			//	oNode = oNode.childNodes[0];	//scp now embeds anchor tag 
				
			var sModuleID = oNode.getAttribute('moduleid');
			if (sModuleID != null && sModuleID.length > 0)
			{
				strModuleOrder += sModuleID + '~';
				this.controls[this.controls.length] = new __scp_PaneControl(oNode, iIndex);
				__scp_m_aryModules[sModuleID] = oNode.id;
				iIndex+=1;
			}
		}
	}
	this.moduleOrder = strModuleOrder;

}

function __scp_PaneControl(ctl, iIndex)
{
	this.control = ctl;
	this.id = ctl.id;
	this.index = iIndex;
	this.origBorder = ctl.style.border;
	
}
