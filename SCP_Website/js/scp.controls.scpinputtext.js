//scpInputText is a dynamically loaded script used by the scpLabelEdit control
scp_control.prototype.scpInputText = function (bMultiLine)
{
	if (bMultiLine)
		this.control = document.createElement('textarea');	
	else
	{
		this.control = document.createElement('input');
		this.control.type = 'text';
	}
	this.container = this.control;
	this.initialized = true;
	this.supportsMultiLine = bMultiLine;
	this.isRichText = false;

}

scp_control.prototype.scpInputText.prototype = 
{
focus: function ()
{
	this.control.focus();
	var iChars = this.getText().length;
	if (this.control.createTextRange)
	{
		var oRange = this.control.createTextRange();
		oRange.moveStart('character', iChars);
		oRange.moveEnd('character', iChars);
		oRange.collapse();
		oRange.select();
	}
	else
	{
		this.control.selectionStart = iChars;
		this.control.selectionEnd = iChars;
	}
	//this.control.select();
},

ltrim: function (s) 
{ 
	return s.replace(/^\s*/, "");
},

rtrim: function (s) 
{ 
	return s.replace(/\s*$/, "");
},

getText: function ()
{
	return this.control.value;
},

setText: function (s)
{
	this.control.value = this.rtrim(this.ltrim(s));
}
}
scp.extend(scp_controls.prototype, scp_control.prototype);
//scp.controls = new scp_controls();

scp.dom.setScriptLoaded('scp.controls.scpinputtext.js');	//callback for dynamically loaded script
