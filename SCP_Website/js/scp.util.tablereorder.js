//BEGIN [Needed in case scripts load out of order]
if (typeof(scp_utility) == 'undefined')
	eval('function scp_utility() {}')
//END [Needed in case scripts load out of order]


scp_utility.prototype = 
{

tableReorderMove: function(ctl, bUp, sKey)
{
	var oTR = scp.dom.getParentByTagName(ctl, 'tr');

	if (oTR != null)
	{
		var oCtr = oTR.parentNode;
		var iIdx = oTR.rowIndex;
		if (scp.dom.getAttr(oTR, 'origidx', '') == '-1')
			this.tableReorderSetOriginalIndexes(oCtr);

		var iNextIdx = (bUp ? this.tableReorderGetPrev(oCtr, iIdx-1) : this.tableReorderGetNext(oCtr, iIdx+1));
		if (iNextIdx > -1)
		{
			var aryValues = this.getInputValues(oTR);
			var aryValues2;
			var oSwapNode;
			scp.dom.removeChild(oTR);
			if (oCtr.childNodes.length > iNextIdx)
			{
				oSwapNode = oCtr.childNodes[iNextIdx];
				aryValues2 = this.getInputValues(oSwapNode);
				oCtr.insertBefore(oTR, oSwapNode);
			}
			else
				oCtr.appendChild(oTR);
			this.setInputValues(oTR, aryValues);
			if (oSwapNode)
				this.setInputValues(oSwapNode, aryValues2);
			
			scp.setVar(sKey,this.tableReorderGetNewRowOrder(oCtr));
		}
		return true;//handled client-side
	}
	return false;	//cause postback
},

getInputValues: function(oCtl)
{
	var aryInputs = scp.dom.getByTagName('input', oCtl);
	var aryValues = new Array();
	for (var i=0; i<aryInputs.length; i++)
	{
		if (aryInputs[i].type == 'checkbox')
			aryValues[i] = aryInputs[i].checked;
	}
	return aryValues;
},

setInputValues: function(oCtl, aryValues)
{
	var aryInputs = scp.dom.getByTagName('input', oCtl);
	for (var i=0; i<aryInputs.length; i++)
	{
		if (aryInputs[i].type == 'checkbox')
			aryInputs[i].checked = aryValues[i];
	}
},

tableReorderGetNext: function (oParent, iStartIdx)
{
	for (var i=iStartIdx; i<oParent.childNodes.length; i++)
	{
		var oCtl = oParent.childNodes[i];
		if (scp.dom.getAttr(oCtl, 'origidx', '') != '')
			return i;
	}
	return -1;
},

tableReorderGetPrev: function(oParent, iStartIdx)
{
	for (var i=iStartIdx; i>=0; i--)
	{
		var oCtl = oParent.childNodes[i];
		if (scp.dom.getAttr(oCtl, 'origidx', '') != '')
			return i;
	}
	return -1;
},

tableReorderSetOriginalIndexes: function(oParent)
{
	var iIdx=0;
	for (var i=0; i<oParent.childNodes.length; i++)
	{
		var oCtl = oParent.childNodes[i];
		if (scp.dom.getAttr(oCtl, 'origidx', '') != '')
		{
			oCtl.setAttribute('origidx', iIdx.toString());
			iIdx++;
		}
	}
},

tableReorderGetNewRowOrder: function(oParent)
{
	var sIdx;
	var sRet='';
	for (var i=0; i<oParent.childNodes.length; i++)
	{
		var oCtl = oParent.childNodes[i];
		sIdx = scp.dom.getAttr(oCtl, 'origidx', '');
		if (sIdx != '')
			sRet+= (sRet.length>0 ? ',':'') + sIdx;
	}
	return sRet;
},

//doesn't belong here...   Don't use outside core, it will be moved
checkallChecked: function(oCtl, iCellIndex)
{
	var bChecked = oCtl.checked;
	var oTD = scp.dom.getParentByTagName(oCtl, 'td');
	var oTR = oTD.parentNode;
	var oCtr = oTR.parentNode;
	var iOffset=0;
	
	var oTemp;
	for (var i=0; i<iCellIndex;i++) //firefox has text nodes
	{
		if (oTR.childNodes[i].tagName == null)	
			iOffset++;	
	}

	var oChk;
	for (var i=0; i<oCtr.childNodes.length; i++)
	{
		oTR = oCtr.childNodes[i];
		oTD = oTR.childNodes[iCellIndex+iOffset];
		if (oTD != null)
		{
			oChk = scp.dom.getByTagName('input', oTD);
			if (oChk.length > 0)
				oChk[0].checked = bChecked;		
		}
	}
	//return true;
	
}

}

//BEGIN [Needed in case scripts load out of order]
if (typeof(scp_util) != 'undefined')
{
	scp.extend(scp_util.prototype, scp_utility.prototype);
	scp.util = new scp_util();
}
//END [Needed in case scripts load out of order]