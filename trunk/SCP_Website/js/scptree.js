
var DT_ACTION_POSTBACK = 0;
var DT_ACTION_EXPAND = 1;
var DT_ACTION_NONE = 2;

function __dt_getClientID(sID)
{
	return sID.replace(new RegExp(':', 'g'), '_');
}

function __dt_ExpandClick(sID, sTreeID)
{
	sID = __dt_getClientID(sID);
	var oTree = scp.dom.getById(sTreeID);
	var sExp = oTree.getAttribute('expimg');
	var sCol = oTree.getAttribute('colimg');
	var oImg = scp.dom.getById('i' + sID);
	var oSpan = scp.dom.getById('s' + sID);

	if (oImg.src.indexOf(sExp) == -1)
	{
		scp.setVar(sTreeID + '_' + sID + ':expanded', 1);
		oSpan.style.display = '';
		oImg.src = sExp;
	}
	else
	{
		scp.setVar(sTreeID + '_' + sID + ':expanded', 0);
		oSpan.style.display = 'none';
		oImg.src = sCol;
	}
	
}


var __dt_m_oPrevSelNode;
var __dt_m_sSelNodeClass;

function __dt_TextClick(sID, sTreeID, eAction)
{
	var sNodeName = sID;
	sID = __dt_getClientID(sID);
	var oTree = scp.dom.getById(sTreeID);
	var oText = scp.dom.getById('t' + sID);
	var oLink = scp.dom.getById('l' + sID);
	
	if (__dt_m_sSelNodeClass == null)
		__dt_m_sSelNodeClass = oTree.getAttribute('selclass');
	if (__dt_m_oPrevSelNode == null && scp.getVar(sTreeID + ':selected') != null)
		__dt_m_oPrevSelNode = new __dt_scpTreeNode(scp.dom.getById('t' + scp.getVar(sTreeID + ':selected')));
		
	if (__dt_m_oPrevSelNode != null)
		__dt_m_oPrevSelNode.ctl.className = __dt_m_oPrevSelNode.className;
		
	__dt_m_oPrevSelNode = new __dt_scpTreeNode(oText);
	oText.className = __dt_m_sSelNodeClass;
	scp.setVar(sTreeID + ':selected', sID);
		
	if (oText.getAttribute('js') != null)
	{
		if (eval(oText.getAttribute('js')) == false)
			return;	//don't do postback if returns false
	}
	if (eAction == null || eAction == DT_ACTION_POSTBACK)
		eval(oTree.getAttribute('postback').replace('[NodeID]', sNodeName));
	else if (eAction == DT_ACTION_EXPAND && oLink != null)
		eval(unescape(oLink.getAttribute('href')));
	
}

function __dt_scpTreeNode(oCtl)
{
	this.ctl = oCtl;
	this.id = oCtl.id;
	this.key = oCtl.getAttribute('key');
	this.nodeID = oCtl.id.substring(1);	//trim off t
	if (oCtl.className != null)
	{
		if (oCtl.getAttribute('origclass') == null)
			this.className = oCtl.className;
		else
		{
			this.className = oCtl.getAttribute('origclass');
		}
	}
	else
		this.className = '';
	this.text = oCtl.innerHTML;	
	this.serverName = oCtl.name; 
}

/*
<div class="scpTree" id="id">
	<div class="Node">
		<a id="lid">
			<img id="iid" plus/minus>
		</a>
		<checkbox id="id_checkbox" />
		<img folder>
		<a id="tid">text</a>	
	</div>
	<span class="Child" id="sid">
		<div class="Node" id="id">
			<span width />
			<a id="lid">
				<img id="iid" plus/minus>
			</a>
			<checkbox id="id_checkbox">
			<img folder>
			<a id="tid">text</a>			
		</div>
		<span class="Child" id="sid">
			<div class="Node" id="id">
				<span width />
				<a id="lid">
					<img id="iid" plus/minus>
				</a>
				<checkbox id="id_checkbox">
				<img folder>
				<a id="tid">text</a>			
			</div>
		</span>
	</span>
</div>
*/
/*
var __dt_m_scpTrees = new Array();

function __dt_scpTree(oCtl)
{
	this.ctl = oCtl;
	this.id = oCtl.id;
	this.nodes = new Array();
	
}

function __dt_populateTreeNodes(oParent)
{
	var oNodes = scp.dom.getByTagName('A', oParent);
	for (var i=0; i<oNodes.length; i++)
	{
		
	}
}

*/
