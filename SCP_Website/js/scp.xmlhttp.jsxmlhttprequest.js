if (scp.xmlhttp != null)
	scp.xmlhttp.parserName = 'JS';

scp_xmlhttp.prototype.JsXmlHttpRequest = function ()
{
	scp.xmlhttp.contextId += 1;
	this.contextId = scp.xmlhttp.contextId;
	this.method = null;
	this.url = null;
	this.async = true;
	this.doc = null;
	
	this.iframe = document.createElement('IFRAME');
	this.iframe.name = 'scpiframe' + this.contextId;
	this.iframe.id = 'scpiframe' + this.contextId;
	this.iframe.src = '';	//TODO:  FIX FOR SSL!!!
	this.iframe.height = 0;
	this.iframe.width = 0;
	this.iframe.style.visibility = 'hidden';
	document.body.appendChild(this.iframe);	
}

scp_xmlhttp.prototype.JsXmlHttpRequest.prototype.open = function (sMethod, sURL, bAsync)
{
	this.method = sMethod;
	this.url = sURL;
	this.async = bAsync;
	
}

scp_xmlhttp.prototype.JsXmlHttpRequest.prototype.send = function (postData)
{
	this.assignIFrameDoc();

	if (this.doc == null)	//opera does not allow access to iframe right away
	{
		window.setTimeout(scp.dom.getObjMethRef(this, 'send'), 1000);
		return;
	}
	this.doc.open();
	this.doc.write('<html><body>');
	this.doc.write('<form name="TheForm" method="post" target="" ');
	var sSep = '?';
	if (this.url.indexOf('?') > -1)
		sSep = '&';
		
	this.doc.write(' action="' + this.url + sSep + '__U=' + this.getUnique() + '">');
	this.doc.write('<input type="hidden" name="ctx" value="' + this.contextId + '">');
	if (postData && postData.length > 0)
	{
		var aryData = postData.split('&');
		for (var i=0; i<aryData.length; i++)
			this.doc.write('<input type="hidden" name="' + aryData[i].split('=')[0] + '" value="' + aryData[i].split('=')[1] + '">');
	}
	this.doc.write('</form></body></html>');
	this.doc.close();

	this.assignIFrameDoc();	//opera needs this reassigned after we wrote to it
	
	this.doc.forms[0].submit();
	
}

scp_xmlhttp.prototype.JsXmlHttpRequest.prototype.assignIFrameDoc = function ()
{
	if (this.iframe.contentDocument) 
		this.doc = this.iframe.contentDocument; 
	else if (this.iframe.contentWindow) 
		this.doc = this.iframe.contentWindow.document; 
	else if (window.frames[this.iframe.name]) 
		this.doc = window.frames[this.iframe.name].document; 

}

scp_xmlhttp.prototype.JsXmlHttpRequest.prototype.getResponseHeader = function (sKey)
{
	this.assignIFrameDoc();
	var oCtl = scp.dom.getById(sKey, this.doc);
	if (oCtl != null)
		return oCtl.value;
	else
		return 'WARNING:  response header not found';
	
}

scp_xmlhttp.prototype.JsXmlHttpRequest.prototype.getUnique = function ()
{
	return new Date().getTime();
}
