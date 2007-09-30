//--- scp.diagnostics

if (typeof(__scp_m_aNamespaces) == 'undefined')	//include in each scp ClientAPI namespace file for dependency loading
	var __scp_m_aNamespaces = new Array();

function scp_diagnostics(bVerbose)
{
	this.pns = 'scp';
	this.ns = 'diagnostics';
	this.dependencies = 'scp'.split(',');
	this.isLoaded = false;
	this.verbose = bVerbose;
	this.debugCtl = null;
	this.debugWait = (document.all != null);//(scp.dom.browser.type == 'ie');
	this.debugArray = new Array();
}

var __scp_m_aryHandled=new Array();
function scp_diagnosticTests(oParent)
{
	if (oParent.ns == 'scp')
		scp.diagnostics.clearDebug();
	if (typeof(oParent.UnitTests) == 'function')
	{
		scp.diagnostics.displayDebug('------- Starting ' + oParent.pns + '.' + oParent.ns + ' tests (v.' + (oParent.apiversion ? oParent.apiversion : scp.apiversion) + ') ' + new Date().toString() + ' -------');
		oParent.UnitTests();
	}
	
	for (var obj in oParent)
	{
		if (oParent[obj] != null && typeof(oParent[obj]) == 'object' && __scp_m_aryHandled[obj] == null)
		{
			//if (obj != 'debugCtl')	//what is this IE object???
			if (oParent[obj].pns != null)
				scp_diagnosticTests(oParent[obj]);
		}
		//__scp_m_aryHandled[obj] = true;
	}
}

function __scp_documentLoaded()
{
	scp.diagnostics.debugWait = false;
	scp.diagnostics.displayDebug('document loaded... avoiding Operation Aborted IE bug');
	scp.diagnostics.displayDebug(scp.diagnostics.debugArray.join('\n'));
	
}

scp_diagnostics.prototype.clearDebug = function()
{
	if (this.debugCtl != null)
	{
		this.debugCtl.value = '';
		return true;
	}
	return false;
}

scp_diagnostics.prototype.displayDebug = function(sText)
{
	if (this.debugCtl == null)
	{
		if (scp.dom.browser.type == scp.dom.browser.InternetExplorer)
		{
			var oBody = scp.dom.getByTagName("body")[0];
			if (this.debugWait && oBody.readyState != 'complete')
			{
				scp.debugWait = true;
				this.debugArray[this.debugArray.length] = sText;
				//document.attachEvent('onreadystate', __scp_documentLoaded);
				if (oBody.onload == null || oBody.onload.toString().indexOf('__scp_documentLoaded') == -1)
					oBody.onload = scp.dom.appendFunction(oBody.onload, '__scp_documentLoaded()');
				return;
			}
		}
		this.debugCtl = scp.dom.getById('__scpDebugOutput');
		if (this.debugCtl == null)
		{
			this.debugCtl = scp.dom.createElement('TEXTAREA');
			this.debugCtl.id = '__scpDebugOutput';
			this.debugCtl.rows=10;
			this.debugCtl.cols=100;
			scp.dom.appendChild(oBody, this.debugCtl);
		}
		this.debugCtl.style.display = 'block';
	}
	
	if (scp.diagnostics.debugCtl == null)
		alert(sText);
	else
		scp.diagnostics.debugCtl.value += sText + '\n';
	
	return true;
}

scp_diagnostics.prototype.assertCheck = function (sCom, bVal, sMsg)
{
	if (!bVal)
		this.displayDebug(sCom + ' - FAILED (' + sMsg + ')');
	else if (this.verbose)
		this.displayDebug(sCom + ' - PASSED');
}

scp_diagnostics.prototype.assert = function (sCom, bVal) 
{
  this.assertCheck(sCom, bVal == true, 'Testing assert(boolean) for true');
}

scp_diagnostics.prototype.assertTrue = function (sCom, bVal)
{
  this.assertCheck(sCom, bVal == true, 'Testing assert(boolean) for true');
}

scp_diagnostics.prototype.assertFalse = function (sCom, bVal)
{
  this.assertCheck(sCom, bVal == false, 'Testing assert(boolean) for false');
}

scp_diagnostics.prototype.assertEquals = function (sCom, sVal1, sVal2)
{
  this.assertCheck(sCom, sVal1 == sVal2, 'Testing Equals: ' + __scp_safeString(sVal1) + ' (' + typeof(sVal1) + ') != ' + __scp_safeString(sVal2) + ' (' + typeof(sVal2) + ')');
}

scp_diagnostics.prototype.assertNotEquals = function (sCom, sVal1, sVal2)
{
  this.assertCheck(sCom, sVal1 != sVal2, 'Testing NotEquals: ' + __scp_safeString(sVal1) + ' (' + typeof(sVal1) + ') == ' + __scp_safeString(sVal2) + ' (' + typeof(sVal2) + ')');
}

scp_diagnostics.prototype.assertNull = function (sCom, sVal1)
{
	this.assertCheck(sCom, sVal1 == null, 'Testing null: ' + __scp_safeString(sVal1) + ' (' + typeof(sVal1) + ') != null');
}

scp_diagnostics.prototype.assertNotNull = function (sCom, sVal1)
{
	this.assertCheck(sCom, sVal1 != null, 'Testing for null: ' + __scp_safeString(sVal1) + ' (' + typeof(sVal1) + ') == null');
}

scp_diagnostics.prototype.assertStringLength = function (sCom, sVal1)
{
	this.assertCheck(sCom, ((sVal1 == null) ? false : sVal1.length > 0), 'Testing for string length: ' + __scp_safeString(sVal1) + ' (' + ((sVal1 == null) ? 'null' : sVal1.length) + ')');
}

scp_diagnostics.prototype.assertNaN = function (sCom, sVal1)
{
	this.assertCheck(sCom, isNaN(sVal1), 'Testing for NaN: ' + __scp_safeString(sVal1) + ' (' + typeof(sVal1) + ') is a number');
}

scp_diagnostics.prototype.assertNotNaN = function (sCom, sVal1)
{
	this.assertCheck(sCom, isNaN(sVal1) == false, 'Testing for NotNaN: ' + __scp_safeString(sVal1) + ' (' + typeof(sVal1) + ') is NOT a number');
}

scp_diagnostics.prototype.dependenciesLoaded = function()
{
	return (typeof(scp) != 'undefined');
}

scp_diagnostics.prototype.loadNamespace = function ()
{
	if (this.isLoaded == false)
	{
		if (this.dependenciesLoaded())
		{
			scp.diagnostics = this; 
			this.isLoaded = true;
			scp.loadDependencies(this.pns, this.ns);
		}
	}	
}


function __scp_safeString(s)
{
	if (typeof(s) == 'string' || typeof(s) == 'number')
		return s;
	else
		return typeof(s);
}

__scp_m_aNamespaces[__scp_m_aNamespaces.length] = new scp_diagnostics(true);
for (var i=__scp_m_aNamespaces.length-1; i>=0; i--)
	__scp_m_aNamespaces[i].loadNamespace();


//--- End scp.diagnostics
//scp_diagnosticTests(scp);

scp.dom.setScriptLoaded('scp.diagnostics.js');	//callback for dynamically loaded script
