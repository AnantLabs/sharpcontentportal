if (typeof(__scp_m_aNamespaces) == 'undefined')	//include in each scp ClientAPI namespace file for dependency loading
	var __scp_m_aNamespaces = new Array();

function __scp_getParser()
{
	if (scp_xmlhttp.JsXmlHttpRequest != null)
		return 'JS';
	if (scp.dom.browser.isType(scp.dom.browser.InternetExplorer))
		return 'ActiveX'; //'ActiveX';
	else if (typeof(XMLHttpRequest) != "undefined") //(scp.dom.browser.isType(scp.dom.browser.Netscape) || scp.dom.browser.isType(scp.dom.browser.Mozilla)) //(typeof XMLHttpRequest != "undefined");
		return 'Native'; //'Native';
	else
		return 'JS';
	
}

function __scp_cleanupxmlhttp()
{
	for (var i=0; i<scp.xmlhttp.requests.length;i++)
	{
		if (scp.xmlhttp.requests[i] != null)
		{
			if (scp.xmlhttp.requests[i].completed)
			{
				scp.xmlhttp.requests[i].dispose();
				if (scp.xmlhttp.requests.length == 1)
				    scp.xmlhttp.requests = new Array();
				else
				    scp.xmlhttp.requests.splice(i,i);
			}
		}
	}
	//window.status = scp.xmlhttp.requests.length + ' ' + new Date();
}

//scp.xmlhttp Namespace ---------------------------------------------------------------------------------------------------------
function scp_xmlhttp()
{
	this.pns = 'scp';
	this.ns = 'xmlhttp';
	this.dependencies = 'scp,scp.dom'.split(',');
	this.isLoaded = false;
	this.parserName = null;
	this.contextId = 0;
	this.requests = new Array();
	this.cleanUpTimer = null;
}

scp_xmlhttp.prototype.init = function ()
{
	this.parserName = __scp_getParser();
}

scp_xmlhttp.prototype.doCallBack = function(sControlId, sArg, pSuccessFunc, sContext, pFailureFunc, pStatusFunc, bAsync, sPostChildrenId, iType)
{
	var oReq = scp.xmlhttp.createRequestObject();
	var sURL = document.location.href;
	oReq.successFunc = pSuccessFunc;
	oReq.failureFunc = pFailureFunc;
	oReq.statusFunc = pStatusFunc;
	oReq.context = sContext;
	if (bAsync == null)
		bAsync = true;
	
	if (sURL.indexOf('.aspx') == -1)	//fix this for url's that dont have page name in them...  quickfix for now...
		sURL += 'default.aspx';
	
	if (sURL.indexOf('?') == -1)
		sURL += '?';
	else
		sURL += '&';

	
	//sURL += '__scpCAPISCI=' + sControlId + '&__scpCAPISCP=' + encodeURIComponent(sArg);
	
	oReq.open('POST', sURL, bAsync);
	//oReq.send();
	
	sArg = scp.encode(sArg);
		
	if (sPostChildrenId)
		sArg += '&' + scp.dom.getFormPostString($(sPostChildrenId));

	if (iType != 0)
		sArg += '&__scpCAPISCT=' + iType;
		
	oReq.send('__scpCAPISCI=' + sControlId + '&__scpCAPISCP=' + sArg);

	return oReq; //1.3
}

scp_xmlhttp.prototype.createRequestObject = function()
{
	if (this.parserName == 'ActiveX')
	{
		var o = new ActiveXObject('Microsoft.XMLHTTP');
		scp.xmlhttp.requests[scp.xmlhttp.requests.length] = new scp.xmlhttp.XmlHttpRequest(o);
		return scp.xmlhttp.requests[scp.xmlhttp.requests.length-1]; 
	}
	else if (this.parserName == 'Native')
	{
		return new scp.xmlhttp.XmlHttpRequest(new XMLHttpRequest()); 
	}
	else
	{
		var oReq = new scp.xmlhttp.XmlHttpRequest(new scp.xmlhttp.JsXmlHttpRequest());
		scp.xmlhttp.requests[oReq._request.contextId] = oReq;
		return oReq; 
	}	
}

//scp.xmlhttp.XmlHttpRequest Object ---------------------------------------------------------------------------------------------------------
scp_xmlhttp.prototype.XmlHttpRequest = function(o)
{
	this._request = o;
	this.successFunc = null;
	this.failureFunc = null;
	this.statusFunc = null;
	//this._request.onreadystatechange = scp.dom.getObjMethRef(this, 'readyStateChange');
	this._request.onreadystatechange = scp.dom.getObjMethRef(this, 'onreadystatechange');
	this.context = null;
	this.completed = false;
	//this.childNodes = this._doc.childNodes;
}

scp_xmlhttp.prototype.XmlHttpRequest.prototype.dispose = function ()
{
	if (this._request != null)
	{
		this._request.onreadystatechange = new function() {};//stop IE memory leak.  Not sure why can't set to null;
		this._request.abort();
		this._request = null;
		this.successFunc = null;
		this.failureFunc = null;
		this.statusFunc = null;
		this.context = null;
		this.completed = null;
		this.postData = null;	//1.3
	}
}

scp_xmlhttp.prototype.XmlHttpRequest.prototype.open = function (sMethod, sURL, bAsync)
{
	this._request.open(sMethod, sURL, bAsync);
	if (typeof(this._request.setRequestHeader) != 'undefined')
		this._request.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=UTF-8");
	return true;
} 

scp_xmlhttp.prototype.XmlHttpRequest.prototype.send = function (postData)
{
	//this._request.onreadystatechange = this.complete;
	this.postData = postData;
	if (scp.xmlhttp.parserName == 'ActiveX')	
		this._request.send(postData);
	else
		this._request.send(postData);
	return true;
}

scp_xmlhttp.prototype.XmlHttpRequest.prototype.onreadystatechange = function ()
{
	if (this.statusFunc != null)
		this.statusFunc(this._request.readyState, this.context, this); //1.3
		
	if (this._request.readyState == '4')
	{
		this.complete(this._request.responseText);
		if (scp.xmlhttp.parserName == 'ActiveX')
			window.setTimeout(__scp_cleanupxmlhttp, 1);	//cleanup xmlhttp object
	}
}

scp_xmlhttp.prototype.XmlHttpRequest.prototype.complete = function (sRes)
{
	var sStatusCode = this.getResponseHeader('__scpCAPISCSI');
	this.completed=true;

	if (sStatusCode == '200')	
		this.successFunc(sRes, this.context, this);	//1.3
	else
	{
		var sStatusDesc = this.getResponseHeader('__scpCAPISCSDI');
		if (this.failureFunc != null)
			this.failureFunc(sStatusCode + ' - ' + sStatusDesc, this.context, this); //1.3
		else
			alert(sStatusCode + ' - ' + sStatusDesc);
	}
}

scp_xmlhttp.prototype.XmlHttpRequest.prototype.getResponseHeader = function (sKey)
{
	return this._request.getResponseHeader(sKey);
}


scp_xmlhttp.prototype.dependenciesLoaded = function()
{
	return (typeof(scp) != 'undefined' && typeof(scp.dom) != 'undefined');
}

scp_xmlhttp.prototype.loadNamespace = function ()
{
	if (this.isLoaded == false)
	{
		if (this.dependenciesLoaded())
		{
			scp.xmlhttp = this; 
			this.isLoaded = true;
			scp.loadDependencies(this.pns, this.ns);
			scp.xmlhttp.init();
		}
	}	
}

__scp_m_aNamespaces[__scp_m_aNamespaces.length] = new scp_xmlhttp();

for (var i=__scp_m_aNamespaces.length-1; i>=0; i--)
	__scp_m_aNamespaces[i].loadNamespace();
