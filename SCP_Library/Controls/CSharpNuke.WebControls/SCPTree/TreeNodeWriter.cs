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
using System.Diagnostics;
using SharpContent.UI.Utilities;
namespace SharpContent.UI.WebControls
{

	internal class TreeNodeWriter : ITreeNodeWriter
	{
		static readonly string[] _expcol = new string[2] {"+", "-"};
		private TreeNode _Node;

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <param name="writer"></param>
		/// <param name="Node"></param>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[jbrinkman]	5/6/2004	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		public void RenderNode(HtmlTextWriter writer, TreeNode Node)
		{
			_Node = Node;
			Render(writer);
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
		///		[Jon Henning] 11/28/2005 Added iscrawler logic
		/// </history>
		/// -----------------------------------------------------------------------------
		protected void Render(HtmlTextWriter writer)
		{
			RenderContents(writer);
			if (_Node.HasNodes && (_Node.IsExpanded || _Node.SCPTree.IsCrawler))
			{
				writer.AddAttribute(HtmlTextWriterAttribute.Class, "Child");
				writer.AddAttribute(HtmlTextWriterAttribute.Width, "100%");
				writer.RenderBeginTag(HtmlTextWriterTag.Div);
				RenderChildren(writer);
				writer.RenderEndTag();
			}
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
		protected void RenderContents(HtmlTextWriter writer)
		{

			RenderOpenTag(writer);
			if (_Node.SCPTree.IndentWidth == 0) _Node.SCPTree.IndentWidth = 9; 
			//keep old default

			if (_Node.Level > 0)
			{
				RenderSpacer(writer, _Node.Level * _Node.SCPTree.IndentWidth);
			}

			RenderExpandNodeIcon(writer);

			RenderNodeCheckbox(writer);

			RenderNodeIcon(writer);

			RenderNodeText(writer);

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
		protected void RenderOpenTag(HtmlTextWriter writer)
		{
			string NodeClass = "Node";

			//writer.AddAttribute(HtmlTextWriterAttribute.Class, GetNodeCss(_Node))
			writer.AddAttribute(HtmlTextWriterAttribute.Name, _Node.ID);
			writer.AddAttribute(HtmlTextWriterAttribute.Id, _Node.ID.Replace(TreeNode._separator, "_"));
			writer.RenderBeginTag(HtmlTextWriterTag.Div);
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
		///		[Jon Henning] 11/28/2005 Added iscrawler logic
		/// </history>
		/// -----------------------------------------------------------------------------
		protected void RenderExpandNodeIcon(HtmlTextWriter writer)
		{
			if (_Node.HasNodes)
			{
				HyperLink _link = new HyperLink();
				Image _image = new Image();
				if (_Node.IsExpanded || _Node.SCPTree.IsCrawler)
				{
					_link.Text = _expcol[1];
					if (!String.IsNullOrEmpty(_Node.SCPTree.ExpandedNodeImage))
					{
						_image.ImageUrl = _Node.SCPTree.ExpandedNodeImage;
					}
				}
				else
				{
					_link.Text = _expcol[0];
					if (!String.IsNullOrEmpty(_Node.SCPTree.CollapsedNodeImage))
					{
						_image.ImageUrl = _Node.SCPTree.CollapsedNodeImage;
					}
				}
				//If _Node.PopulateOnDemand Then	'handled in postback handler
				//	_link.NavigateUrl = ClientAPI.GetPostBackClientHyperlink(_Node.SCPTree, _Node.ID & ",OnDemand")
				//Else
				_link.NavigateUrl = ClientAPI.GetPostBackClientHyperlink(_Node.SCPTree, _Node.ID);
				//End If
				if (!String.IsNullOrEmpty(_image.ImageUrl))
				{
					_link.RenderBeginTag(writer);
					_image.RenderControl(writer);
					_link.RenderEndTag(writer);
				}
				else
				{
					_link.RenderControl(writer);
				}
				_image = null;
				_link = null;
			}
			else
			{
				RenderSpacer(writer, _Node.SCPTree.ExpandCollapseImageWidth);
			}
			writer.Write("&nbsp;");
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
		protected void RenderNodeCheckbox(HtmlTextWriter writer)
		{
			if (_Node.SCPTree.CheckBoxes)
			{
				CheckBox _checkbox = new CheckBox();
				_checkbox.ID = _Node.ID + TreeNode._separator + TreeNode._checkboxIDSufix;
				_checkbox.Checked = _Node.Selected;
				string strJS = "";
				if (!String.IsNullOrEmpty(_Node.JSFunction))
				{
                        if (_Node.JSFunction.EndsWith(";") == false) strJS += _Node.JSFunction + ";";
				}
				if (!String.IsNullOrEmpty(_Node.SCPTree.JSFunction))
				{
                        if (_Node.SCPTree.JSFunction.EndsWith(";") == false) strJS += _Node.SCPTree.JSFunction + ";";
				}

				string strClick = ClientAPI.GetPostBackClientHyperlink(_Node.SCPTree, _Node.ID + ClientAPI.COLUMN_DELIMITER + "Click").Replace("javascript:", "") + ";";
				string strCheck = ClientAPI.GetPostBackClientHyperlink(_Node.SCPTree, _Node.ID + ClientAPI.COLUMN_DELIMITER + "Checked").Replace("javascript:", "") + ";";
				if (_Node.Selected == false)
				{
					if (!String.IsNullOrEmpty(strJS))
					{
						strJS = "if (eval(\"" + strJS.Replace("\"", "\"\"") + "\") != false) ";
                              strJS += strClick + " else " + strCheck;
					}
					else
					{
                              strJS += strClick;
					}
				}
				else
				{
					strJS = strCheck;
				}

				//_checkbox.Attributes.Add("onclick", ClientAPI.GetPostBackClientHyperlink(_Node.SCPTree, _Node.ID & ",Unchecked"))
				//Else
				_checkbox.Attributes.Add("onclick", strJS);
				//End If
				_checkbox.RenderControl(writer);
				_checkbox = null;
				writer.Write("&nbsp;");
			}
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
		protected void RenderNodeIcon(HtmlTextWriter writer)
		{
			Label oSpan = new Label();
			if (!String.IsNullOrEmpty(_Node.CSSIcon))
			{
				oSpan.CssClass = _Node.CSSIcon;
			}
else if (!String.IsNullOrEmpty(_Node.SCPTree.DefaultIconCssClass)) {
				oSpan.CssClass = _Node.SCPTree.DefaultIconCssClass;
			}
			oSpan.RenderBeginTag(writer);

			if (_Node.ImageIndex > -1)
			{
                   NodeImage _NodeImage = _Node.SCPTree.ImageList[_Node.ImageIndex];
				if ((_NodeImage != null))
				{
					Image _image = new Image();
					_image.ImageUrl = _NodeImage.ImageUrl;
					_image.RenderControl(writer);
					writer.Write("&nbsp;");
				}
			}
			oSpan.RenderEndTag(writer);
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
		protected void RenderNodeText(HtmlTextWriter writer)
		{
			//Dim _label As Label = New Label
			HyperLink _link = new HyperLink();
			string strJS = "";

			//_label.Text = _Node.Text
			_link.Text = _Node.Text;

			if (!String.IsNullOrEmpty(_Node.JSFunction))
			{
				if (_Node.JSFunction.EndsWith(";") == false) strJS += _Node.JSFunction + ";";
			}
               else if (!String.IsNullOrEmpty(_Node.SCPTree.JSFunction)) 
               {
				if (_Node.SCPTree.JSFunction.EndsWith(";") == false) strJS += _Node.SCPTree.JSFunction  + ";";
			}

			if (_Node.Enabled)
			{
				switch (_Node.ClickAction) {
					case eClickAction.PostBack:
					case eClickAction.Expand:
						if (!String.IsNullOrEmpty(strJS)) strJS = "if (eval(\"" + strJS.Replace("\"", "\"\"") + "\") != false) ";
                              strJS += ClientAPI.GetPostBackClientHyperlink(_Node.SCPTree, _Node.ID + ClientAPI.COLUMN_DELIMITER + "Click").Replace("javascript:", "");
;
						break;
					case eClickAction.Navigate:
						if (!String.IsNullOrEmpty(strJS)) strJS = "if (eval(\"" + strJS.Replace("\"", "\"\"") + "\") != false) "; 
						if (!String.IsNullOrEmpty(_Node.SCPTree.Target))
						{
							strJS +=  "window.frames." + _Node.SCPTree.Target + ".location.href='" + _Node.NavigateURL + "'; void(0);";
							//FOR SOME REASON THIS DOESNT WORK UNLESS WE HAVE CODE AFTER THE SETTING OF THE HREF...
						}
						else
						{
							strJS += "window.location.href='" + _Node.NavigateURL + "';";
						}

						break;

				}

				_link.NavigateUrl = "javascript:" + strJS;
			}

			if (!String.IsNullOrEmpty(_Node.ToolTip))
			{
				//_label.ToolTip = _Node.ToolTip
				_link.ToolTip = _Node.ToolTip;
			}
			//_label.CssClass = "NodeText"
			//_label.RenderControl(writer)

			string sCSS = GetNodeCss(_Node);
			if (!String.IsNullOrEmpty(sCSS)) _link.CssClass = sCSS; 
			//If _Node.Selected Then
			//	If Len(_Node.SCPTree.DefaultNodeCssClassSelected) > 0 Then _link.CssClass = _Node.SCPTree.DefaultNodeCssClassSelected
			//Else
			//	_link.CssClass = _Node.CSSClass
			//End If

			_link.RenderControl(writer);
		}

		private string GetNodeCss(TreeNode oNode)
		{
			string sNodeCss = oNode.SCPTree.CssClass;

			if (oNode.Level > 0) sNodeCss = oNode.SCPTree.DefaultChildNodeCssClass; 
			if (!String.IsNullOrEmpty(oNode.CSSClass)) sNodeCss = oNode.CSSClass; 

			if (oNode.Selected)
			{
				if (!String.IsNullOrEmpty(oNode.CSSClassSelected))
				{
					sNodeCss += " " + oNode.CSSClassSelected;
				}
				else
				{
                        sNodeCss += " " + oNode.SCPTree.DefaultNodeCssClassSelected;
				}
			}

			return sNodeCss;
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <param name="writer"></param>
		/// <param name="Width"></param>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[jbrinkman]	5/6/2004	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		protected void RenderSpacer(HtmlTextWriter writer, int Width)
		{
			writer.AddStyleAttribute("width", Width.ToString() + "px");
			writer.AddStyleAttribute("height", "1px");
			writer.AddAttribute("src", _Node.SCPTree.SystemImagesPath + "spacer.gif");
			writer.RenderBeginTag(HtmlTextWriterTag.Img);
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
		protected void RenderChildren(HtmlTextWriter writer)
		{
			foreach (TreeNode _elem in _Node.TreeNodes) {
				_elem.Render(writer);
			}
		}

	}
}
