//
// Sharp Content Portal - http://www.SharpContentPortal.com
// Copyright (c) 2002-2005
// by Perpetual Motion Interactive Systems Inc. ( http://www.perpetualmotion.ca )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and 
// to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions 
// of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
// TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
//

using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using SharpContent.UI.Utilities;
namespace SharpContent.UI.WebControls
{

	internal class SCPTreeUpLevelWriter : WebControl, ISCPTreeWriter
	{
		private SCPTree _tree;

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[jbrinkman]	5/6/2004	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		public SCPTreeUpLevelWriter()
		{
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <param name="writer"></param>
		/// <param name="tree"></param>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[jbrinkman]	5/6/2004	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		public void RenderTree(HtmlTextWriter writer, SCPTree tree)
		{

			_tree = tree;
			RenderControl(writer);
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <param name="writer"></param>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[jbrinkman]	5/6/2004	Created
		///		[jhenning] 2/22/2005	Added properties
		/// </history>
		/// -----------------------------------------------------------------------------
		protected override void RenderContents(HtmlTextWriter writer)
		{
			writer.AddAttribute(HtmlTextWriterAttribute.Width, "100%");
			writer.AddAttribute(HtmlTextWriterAttribute.Class, "SCPTree");
			writer.AddAttribute(HtmlTextWriterAttribute.Name, _tree.UniqueID);
			writer.AddAttribute(HtmlTextWriterAttribute.Id, _tree.ClientID);
			//_tree.UniqueID.Replace(":", "_"))

			writer.AddAttribute("sysimgpath", _tree.SystemImagesPath);
			writer.AddAttribute("indentw", _tree.IndentWidth.ToString());
			if (_tree.ExpandCollapseImageWidth != 12)
			{
				writer.AddAttribute("expcolimgw", _tree.ExpandCollapseImageWidth.ToString());
			}
			if (_tree.CheckBoxes) writer.AddAttribute("checkboxes", "1"); 
			if (!String.IsNullOrEmpty(_tree.Target)) writer.AddAttribute("target", _tree.Target); 

			if (_tree.ImageList.Count > 0)
			{
				string strList = "";
				foreach (NodeImage objNodeImage in _tree.ImageList) {
                        strList += (String.IsNullOrEmpty(strList) ? "" : ",") + objNodeImage.ImageUrl;
				}
				writer.AddAttribute("imagelist", strList);
			}

			//css attributes
			if (!String.IsNullOrEmpty(_tree.DefaultNodeCssClass)) writer.AddAttribute("css", _tree.DefaultNodeCssClass); 
			if (!String.IsNullOrEmpty(_tree.DefaultChildNodeCssClass)) writer.AddAttribute("csschild", _tree.DefaultChildNodeCssClass); 
			if (!String.IsNullOrEmpty(_tree.DefaultNodeCssClassOver)) writer.AddAttribute("csshover", _tree.DefaultNodeCssClassOver); 
			if (!String.IsNullOrEmpty(_tree.DefaultNodeCssClassSelected)) writer.AddAttribute("csssel", _tree.DefaultNodeCssClassSelected); 
			if (!String.IsNullOrEmpty(_tree.DefaultIconCssClass)) writer.AddAttribute("cssicon", _tree.DefaultIconCssClass); 

			if (!String.IsNullOrEmpty(_tree.JSFunction)) writer.AddAttribute("js", _tree.JSFunction); 

			if (!String.IsNullOrEmpty(_tree.WorkImage)) writer.AddAttribute("working", _tree.WorkImage); 
			if (_tree.AnimationFrames != 5) writer.AddAttribute("animf", _tree.AnimationFrames.ToString()); 
			writer.AddAttribute("expimg", _tree.ExpandedNodeImage);
			writer.AddAttribute("colimg", _tree.CollapsedNodeImage);
			writer.AddAttribute("postback", ClientAPI.GetPostBackEventReference(_tree, "[NODEID]" + ClientAPI.COLUMN_DELIMITER + "Click"));

			if (_tree.PopulateNodesFromClient)
			{
				if (SharpContent.UI.Utilities.ClientAPI.BrowserSupportsFunctionality(Utilities.ClientAPI.ClientFunctionality.XMLHTTP))
				{
					writer.AddAttribute("callback", SharpContent.UI.Utilities.ClientAPI.GetCallbackEventReference(_tree, "'[NODEXML]'", "this.callBackSuccess", "oTNode", "this.callBackFail", "this.callBackStatus"));
				}
				else
				{
					writer.AddAttribute("callback", ClientAPI.GetPostBackClientHyperlink(_tree, "[NODEID]" + ClientAPI.COLUMN_DELIMITER + "OnDemand"));
				}
				if (!String.IsNullOrEmpty(_tree.CallbackStatusFunction))
				{
					writer.AddAttribute("callbackSF", _tree.CallbackStatusFunction);
				}

			}

			writer.RenderBeginTag(HtmlTextWriterTag.Div);
			writer.RenderEndTag();
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <param name="writer"></param>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[jbrinkman]	5/6/2004	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		protected override void RenderChildren(HtmlTextWriter writer)
		{
			foreach (TreeNode TempNode in _tree.TreeNodes) {
				TempNode.Render(writer);
			}
		}

	}
}
