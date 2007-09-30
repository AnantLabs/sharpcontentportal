//BEGIN [Needed in case scripts load out of order]
if (typeof(scp_control) == 'undefined')
	eval('function scp_control() {}')
//END [Needed in case scripts load out of order]

scp_control.prototype.initLabelEdit = function (oCtl) 
{
	if (oCtl)
	{
		scp.controls.controls[oCtl.id] = new scp.controls.scpLabelEdit(oCtl);
		return scp.controls.controls[oCtl.id];
	}
}

//------- Constructor -------//
scp_control.prototype.scpLabelEdit = function (o)
{
	this.ns = o.id;               //stores namespace for control
	this.control = o;                    //stores control
	this.editWrapper = null;	//stores scp wrapper for abstracted edit control
	this.editContainer = null; //stores container of the control (necessary for iframe controls)
	this.editControl = null; //stores reference to underlying edit control (input, span, textarea)
	this.prevText = '';	
	
	this.onblurSave = (scp.dom.getAttr(o, 'blursave', '1') == '1');
	
	this.toolbarId = scp.dom.getAttr(o, 'tbId', '');
	this.nsPrefix = scp.dom.getAttr(o, 'nsPrefix', '');
	this.toolbarEventName = scp.dom.getAttr(o, 'tbEvent', 'onmousemove');
	this.toolbar = null;
	//this.scriptPath = scp.dom.getScriptPath();
	//var oThisScript = scp.dom.getScript('scp.controls.scplabeledit.js');
	//if (oThisScript)
	//	this.scriptPath = oThisScript.src.replace('scp.controls.scplabeledit.js', '');
		
	this.css = o.className;	
	this.cssEdit = scp.dom.getAttr(o, 'cssEdit', '');
	this.cssWork = scp.dom.getAttr(o, 'cssWork', '');
	this.cssOver = scp.dom.getAttr(o, 'cssOver', '');
	this.sysImgPath = scp.dom.getAttr(o, 'sysimgpath', '');
	this.callBack = scp.dom.getAttr(o, 'callback', '');
	this.callBackStatFunc = scp.dom.getAttr(o, 'callbackSF', '');
	this.beforeSaveFunc = scp.dom.getAttr(o, 'beforeSaveF', '');
	this.eventName = scp.dom.getAttr(o, 'eventName', 'onclick');
	this.editEnabled = scp.dom.getAttr(o, 'editEnabled', '1') == '1';
	this.multiLineEnabled = scp.dom.getAttr(o, 'multiline', '0') == '1';
	this.richTextEnabled = scp.dom.getAttr(o, 'richtext', '0') == '1';
	this.supportsCE = (document.body.contentEditable != null);
	if (scp.dom.browser.isType(scp.dom.browser.Safari))		
		this.supportsCE = false;//Safari content editable still buggy...
	this.supportsRichText = (this.supportsCE || (scp.dom.browser.isType(scp.dom.browser.Mozilla) && navigator.productSub >= '20050111'));	//i belive firefox only works well with 1.5 or later, need a better way to detect this!
	
	if (this.eventName != 'none')
		scp.dom.addSafeHandler(o, this.eventName, this, 'performEdit');
	if (this.toolbarId.length > 0)
		scp.dom.addSafeHandler(o, this.toolbarEventName, this, 'showToolBar');
	scp.dom.addSafeHandler(o, 'onmousemove', this, 'mouseMove');
	scp.dom.addSafeHandler(o, 'onmouseout', this, 'mouseOut');
	
}

scp_control.prototype.scpLabelEdit.prototype = 
{

isEditMode: function()
{
	return (this.control.style.display != '')
},

initToolbar: function()
{
	if (this.toolbar == null)
	{
		var sStatus = scp.dom.scriptStatus('scp.controls.scptoolbar.js');
		if (sStatus == 'complete')
		{
			this.toolbar = new scp.controls.scpToolBar(this.ns);
			this.toolbar.loadDefinition(this.toolbarId, this.nsPrefix, this.control, this.control.parentNode, this.control, scp.createDelegate(this, this.toolbarAction));			
			this.handleToolbarDisplay();
		}
		else if (sStatus == '')	//not loaded
			scp.dom.loadScript(scp.dom.getScriptPath() + 'scp.controls.scptoolbar.js', '', scp.createDelegate(this, this.initToolbar));
	}

},

toolbarAction: function(btn, src)
{
	var sCA = btn.clickAction;
	if (sCA == 'edit')
		this.performEdit();
	else if (sCA == 'save')
	{
		this.persistEdit();
		this.toolbar.hide();
	}
	else if (sCA == 'cancel')
	{
		this.cancelEdit();
		this.toolbar.hide();	
	}	
	else if (this.isFormatButton(sCA))
	{
		if (this.editWrapper)
		{
			var s;
			if (sCA == 'createlink' && scp.dom.browser.isType(scp.dom.browser.InternetExplorer) == false)
				s = prompt(btn.tooltip);
				
			this.editWrapper.focus();
			this.editWrapper.execCommand(sCA, null, s);
		}
	}
		
},

performEdit: function () 
{
	if (this.toolbar)
		this.toolbar.hide();
	this.initEditWrapper();
	if (this.editContainer != null)
	{
		if (scp.dom.browser.isType(scp.dom.browser.Mozilla))
			this.control.style.display = '-moz-inline-box';
		this.editContainer.style.height = scp.dom.positioning.elementHeight(this.control) + 4;
		this.editContainer.style.width = scp.dom.positioning.elementWidth(this.control.parentNode) //'100%';
		this.editContainer.style.display = '';
		//this.editContainer.style.visibility = '';	//firefox workaround... can't do display none
		this.editContainer.style.overflow = 'auto';
		this.editContainer.style.overflowX = 'hidden';

		this.prevText = this.control.innerHTML;
		if (scp.dom.browser.isType(scp.dom.browser.Safari) && this.control.innerText)		//safari gets strange chars... use innerText
			this.prevText = this.control.innerText;
		this.editWrapper.setText(this.prevText);
		this.initEditControl();
		this.control.style.display = 'none';
		this.handleToolbarDisplay();
	}
},

showToolBar: function ()
{
	this.initToolbar();
	if (this.toolbar)
		this.toolbar.show(true);	
},

mouseMove: function () 
{
	if (this.toolbarId.length > 0 && this.toolbarEventName == 'onmousemove')
		this.showToolBar();
	this.control.className = this.css + ' ' + this.cssOver;
},

mouseOut: function () 
{
	//this.initToolbar();
	if (this.toolbar)
		this.toolbar.beginHide();
	this.control.className = this.css;
},


initEditWrapper: function()
{
	if (this.editWrapper == null)
	{
		var bRichText = (this.richTextEnabled && this.supportsRichText);
		var sScript = (bRichText ? 'scp.controls.scprichtext.js' : 'scp.controls.scpinputtext.js');
		
		var sStatus = scp.dom.scriptStatus(sScript);
		if (sStatus == 'complete')
		{
			var oTxt;
			if (this.richTextEnabled && this.supportsRichText)
			{
				var func = scp.dom.getObjMethRef(this, 'initEditControl');
				oTxt = new scp.controls.scpRichText(func);
			}
			else
				oTxt = new scp.controls.scpInputText(this.multiLineEnabled);
					
			this.editWrapper = oTxt;
			this.editContainer = this.editWrapper.container;
			//this.control.parentNode.appendChild(this.editContainer);
			this.control.parentNode.insertBefore(this.editContainer, this.control);
			if (this.richTextEnabled && this.supportsCE)	//control is instantly available (not an iframe)
				this.initEditControl();
		}
		else if (sStatus == '') //not loaded
			scp.dom.loadScript(scp.dom.getScriptPath() + sScript, '', scp.createDelegate(this, this.performEdit));		//should call self or performEdit?
	}
},

initEditControl: function() 
{
	if (this.editWrapper.initialized)
	{
		this.editControl = this.editWrapper.control;
		this.editControl.className = this.control.className + ' ' + this.cssEdit;
		this.editWrapper.focus();
		if (this.editWrapper.supportsCE || this.editWrapper.isRichText == false)	//if browser supports contentEditable or is a simple INPUT control
		{
			if (this.onblurSave)
				scp.dom.addSafeHandler(this.editContainer, 'onblur', this, 'persistEdit');	
			scp.dom.addSafeHandler(this.editControl, 'onkeypress', this, 'handleKeyPress');	
			scp.dom.addSafeHandler(this.editControl, 'onmousemove', this, 'mouseMove');	
			scp.dom.addSafeHandler(this.editControl, 'onmouseout', this, 'mouseOut');	
		}
		else	//IFRAME event handlers
		{
			if (this.onblurSave)
				scp.dom.attachEvent(this.editContainer.contentWindow.document, 'onblur', scp.dom.getObjMethRef(this, 'persistEdit'));	
			scp.dom.attachEvent(this.editContainer.contentWindow.document, 'onkeypress', scp.dom.getObjMethRef(this, 'handleKeyPress'));			
			scp.dom.attachEvent(this.editContainer.contentWindow.document, 'onmousemove', scp.dom.getObjMethRef(this, 'mouseMove'));	
			scp.dom.attachEvent(this.editContainer.contentWindow.document, 'onmouseout', scp.dom.getObjMethRef(this, 'mouseOut'));	
		}
	}
},

persistEdit: function() 
{
	if (this.editWrapper.getText() != this.prevText)
	{
		if (this.raiseEvent('beforeSaveFunc', null, this))
		{			
			this.editControl.className = this.control.className + ' ' + this.cssWork;
			eval(this.callBack.replace('[TEXT]', scp.escapeForEval(this.editWrapper.getText())));
		}
	}
	else
		this.showLabel();
},

raiseEvent: function(sFunc, evt, element)
{
	if (this[sFunc].length > 0)
	{
		var oPtr = eval(this[sFunc]);
		return oPtr(evt, element) != false;
	}
	return true;
},

cancelEdit: function () 
{
	this.editWrapper.setText(this.prevText);
	this.showLabel();
},

callBackStatus: function (result, ctx) 
{
	var oLbl = ctx;
	if (oLbl.callBackStatFunc != null && oLbl.callBackStatFunc.length > 0)
	{
		var oPointerFunc = eval(oLbl.callBackStatFunc);
		oPointerFunc(result, ctx);	
	}	
},

callBackSuccess: function (result, ctx) 
{
	ctx.callBackStatus(result, ctx);
	ctx.showLabel();
},

handleToolbarDisplay: function()
{
	if (this.toolbar)
	{
		var bInEdit = this.isEditMode();
		
		for (var sKey in this.toolbar.buttons)
		{
			if (sKey == 'edit')
				this.toolbar.buttons[sKey].visible = !bInEdit;
			else if (this.isFormatButton(sKey))
				this.toolbar.buttons[sKey].visible = (bInEdit && this.editWrapper && this.editWrapper.isRichText);
			else
				this.toolbar.buttons[sKey].visible = bInEdit;					
		
		}
		this.toolbar.refresh();
	}
},

isFormatButton: function(sKey)
{
	return '~bold~italic~underline~justifyleft~justifycenter~justifyright~insertorderedlist~insertunorderedlist~outdent~indent~createlink~'.indexOf('~' + sKey + '~') > -1;
},

showLabel: function () 
{
	this.control.innerHTML = this.editWrapper.getText();
	this.control.style.display = '';
	this.control.className = this.css;
	//this.editContainer.style.width = 0; //firefox workaround
	//this.editContainer.style.visibility = 'hidden';	//firefox workaround
	this.editContainer.style.display = 'none';
	this.handleToolbarDisplay();
},

callBackFail: function (result, ctx) 
{
	alert(result);
	ctx.cancelEdit();
},

handleKeyPress: function (e) 
{
	if (e == null)
	{
		if (scp.dom.event != null)	//mini hack
			e = scp.dom.event.object;
		else
			e = this.editWrapper.container.contentWindow.event;
	}	
	if (e.keyCode == 13 && this.editWrapper.supportsMultiLine == false)
	{
		this.persistEdit();
		return false;
	}	
	else if (e.keyCode == 27)
		this.cancelEdit();		
}
}


function __dl_getCSS()	//probably a better way to handle this...
{
	var arr = scp.dom.getByTagName('link');
	var s = '';
	for (var i=0; i< arr.length; i++)
	{
		s+= '<LINK href="' + arr[i].href + '" type=text/css rel=stylesheet>';
	}
	return s;
}

//BEGIN [Needed in case scripts load out of order]
if (typeof(scp_controls) != 'undefined')
{
	scp.extend(scp_controls.prototype, scp_control.prototype);
	scp.controls = new scp_controls();
}
//END [Needed in case scripts load out of order]