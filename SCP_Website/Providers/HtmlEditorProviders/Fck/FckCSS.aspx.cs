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
using SharpContent.Common;
using SharpContent.Common.Utilities;
using SharpContent.Entities.Portals;
using SharpContent.Security;
using SharpContent.Framework.Providers;
using System.Web.UI.WebControls;
using System.IO;
using System.Web;

namespace SharpContent.HtmlEditor.FckHtmlEditorProvider
{


	/// <summary>
	///     Creates dynamic CSS-Output depending on the current Tab for use instead of FCK-TextArea.css
	/// </summary>
	/// <remarks>
	/// </remarks>
	/// <history>
	/// 	[mhamburger]	10.11.2005	Class Added for CSS support in editarea
	/// </history>
	/// -----------------------------------------------------------------------------
	public partial class FckCSSGenerator : SharpContent.Framework.PageBase
	{

		private void Page_Load(object sender, System.EventArgs e)
		{
			System.Text.StringBuilder sb = new System.Text.StringBuilder();


			//Insert default css
			sb.Append(CssImport(SharpContent.Common.Globals.HostPath + "default.css"));
			//Insert skin stylesheet(s)
			sb.Append(CssImport(PortalSettings.ActiveTab.SkinPath + "skin.css"));
			sb.Append(CssImport(PortalSettings.ActiveTab.SkinSrc.Replace(".ascx", ".css")));
			//Insert portal stylesheet
			sb.Append(CssImport(PortalSettings.HomeDirectory + "portal.css"));

			Response.Clear();
			Response.ClearHeaders();
			Response.ContentType = "text/css";
			//The following line was added just to see if there is more browser compatibility. You can exclude it.
			Response.AddHeader("Content-Disposition", "attachment; filename=FCK_P" + PortalSettings.PortalId.ToString() + "_T" + PortalSettings.ActiveTab.TabID.ToString() + ".css");
			Response.Cache.SetNoServerCaching();
			Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
			Response.Cache.SetNoStore();
			Response.Cache.SetExpires(new DateTime(1900, 1, 1, 0, 0, 0, 0));

			Response.Write(sb.ToString());
			Response.Flush();
			Response.End();

		}

		private string CssImport(string file)
		{
			if (System.IO.File.Exists(Server.MapPath(file)))
			{
				return "@import url(" + Server.UrlPathEncode(file) + ");" + Environment.NewLine;
			}
			else
			{
				return "";
			}

		}

		#region " Web Form Designer Generated Code "

          ////This call is required by the Web Form Designer.
          //[System.Diagnostics.DebuggerStepThrough()]
          //private void InitializeComponent()
          //{

          //}

          ////NOTE: The following placeholder declaration is required by the Web Form Designer.
          ////Do not delete or move it.
          //private object designerPlaceholderDeclaration;

          //private void Page_Init(object sender, System.EventArgs e)
          //{
          //     //CODEGEN: This method call is required by the Web Form Designer
          //     //Do not modify it using the code editor.
          //     InitializeComponent();
          //}

		#endregion


	}


}

