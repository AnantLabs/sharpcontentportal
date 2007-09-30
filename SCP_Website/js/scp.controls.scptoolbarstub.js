//this script enables any element on the page to have a toolbar associated.
//the RegisterToolBar method is used on the server-side to do the association.

function __scp_toolbarHandler(sToolBarId, sCtlId, sNsPrefix, fHandler, sEvt, sHideEvt)
{
	var sStatus = scp.dom.scriptStatus('scp.controls.scptoolbar.js');
	if (sStatus == 'complete')
	{
		var oTB = new scp.controls.scpToolBar(sCtlId);
		scp.controls.controls[sToolBarId] = oTB;
		var oCtl = $(sCtlId);
		oTB.loadDefinition(sToolBarId, sNsPrefix, oCtl, oCtl.parentNode, oCtl, fHandler);
		scp.dom.addSafeHandler(oCtl, sEvt, oTB, 'show');
		scp.dom.addSafeHandler(oCtl, sHideEvt, oTB, 'beginHide');
		oTB.show();
	}
	else if (sStatus == '')	//not loaded
		scp.dom.loadScript(scp.dom.getScriptPath() + 'scp.controls.scptoolbar.js', '', function () {__scp_toolbarHandler(sToolBarId, sCtlId, sNsPrefix, fHandler, sEvt, sHideEvt)});
}
