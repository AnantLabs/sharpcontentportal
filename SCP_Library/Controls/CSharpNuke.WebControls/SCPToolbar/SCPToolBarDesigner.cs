//
// Sharp Content Portal - http://www.SharpContentPortal.com
// Copyright (c) 2002-2006
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
using SharpContent.UI.WebControls;
using System.ComponentModel;
using System.ComponentModel.Design;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.Design;
using System.IO;


namespace SharpContent.UI.Design.WebControls
{
	public class SCPToolBarDesigner : ControlDesigner
	{
		/// -----------------------------------------------------------------------------
		/// <summary>
		/// This class allows us to render the design time mode with custom HTML
		/// </summary>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	9/20/2006	Commented
		/// </history>
		/// -----------------------------------------------------------------------------
		public override string GetDesignTimeHtml()
		{
			string strText;
			SCPToolBar objToolbar = (SCPToolBar)base.Component;
			StringWriter sw = new StringWriter();
			HtmlTextWriter tw = new HtmlTextWriter(sw);
			Label objLabel;
			Label objPanelTB;
			objPanelTB = new Label();
               objPanelTB.Text = "[" + objToolbar.ID + " toolbar]";
			if (!String.IsNullOrEmpty(objToolbar.CssClass)) objPanelTB.CssClass = objToolbar.CssClass; 
			foreach (SCPToolBarButton objBtn in objToolbar.Buttons) {
				objLabel = new Label();
				if (!String.IsNullOrEmpty(objBtn.CssClass)) objLabel.CssClass = objBtn.CssClass; 
				if (!String.IsNullOrEmpty(objBtn.Text)) objLabel.Text = objBtn.Text; 
				objPanelTB.Controls.Add(objLabel);
			}
			objPanelTB.Style.Add("position", "");
			objPanelTB.Style.Add("top", "0px");
			objPanelTB.Style.Add("left", "0px");

			objPanelTB.RenderControl(tw);
			return sw.ToString();
			return strText;

		}

	}
}
