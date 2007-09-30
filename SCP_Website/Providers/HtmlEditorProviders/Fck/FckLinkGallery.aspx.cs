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
// File Author(s):
// Mauricio Márquez Anze - http://dnn.tiendaboliviana.com
//
// FCKeditor - The text editor for internet - http://www.fckeditor.net
// Copyright (C) 2003-2006 Frederico Caldeira Knabben
//

using SharpContent.Common;
using SharpContent.Common.Utilities;
using SharpContent.Entities.Portals;
using SharpContent.Security;
using SharpContent;
using System.Web.UI;
using System.Web.UI.HtmlControls;

using System.Web.UI.WebControls;
using System;
using System.Collections;

namespace SharpContent.HtmlEditor.FckHtmlEditorProvider
{

	public partial class FckLinkGallery : SharpContent.Framework.PageBase
	{

		protected string title = "";
		private string mTheme;		

		private void Page_Load(object sender, System.EventArgs e)
		{
			Response.Cache.SetNoServerCaching();
			Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
			Response.Cache.SetNoStore();
			Response.Cache.SetExpires(new DateTime(1900, 1, 1, 0, 0, 0, 0));
			string strTitle = PortalSettings.PortalName + " > " + SharpContent.Services.Localization.Localization.GetString("LinkGallery.Text", DSLocalResourceFile);

			// show copyright credits?
			if (Globals.GetHashValue(SharpContent.Common.Globals.HostSettings["Copyright"], "Y") == "Y")
			{
				strTitle += " ( SCP " + PortalSettings.Version + " )";
			}
			title = strTitle;
			if (!Page.IsPostBack)
			{
				lblTitle.Text = SharpContent.Services.Localization.Localization.GetString("LinkGallery.Text", DSLocalResourceFile);
				cmdSelect.Text = SharpContent.Services.Localization.Localization.GetString("cmdSelect.Text", DSLocalResourceFile);
				ctlURL.ShowTrack = false;
				ctlURL.ShowNewWindow = false;
				ctlURL.ShowLog = false;

			}
			mTheme = "Default";
			if ((Request["FCKTheme"] != null))
			{
				mTheme = Request["FCKTheme"].ToString();
			}

			ManageStyleSheets();
		}

		private void ManageStyleSheets()
		{

			// initialize reference paths to load the cascading style sheets
			Control objCSS = this.FindControl("CSS");
			System.Web.UI.HtmlControls.HtmlGenericControl objLink;
			string ID;

			Hashtable objCSSCache = (Hashtable)DataCache.GetCache("CSS");
			if (objCSSCache == null)
			{
				objCSSCache = new Hashtable();
			}

			if ((objCSS != null))
			{

				// default style sheet ( required )
				ID = Globals.CreateValidID(Common.Globals.HostPath);
				objLink = new HtmlGenericControl("LINK");
				objLink.ID = ID;
				objLink.Attributes["rel"] = "stylesheet";
				objLink.Attributes["type"] = "text/css";
				objLink.Attributes["href"] = Common.Globals.HostPath + "default.css";
				objCSS.Controls.Add(objLink);

				// skin package style sheet
				ID = Globals.CreateValidID(PortalSettings.ActiveTab.SkinPath);
				if (objCSSCache.ContainsKey(ID) == false)
				{
					if (System.IO.File.Exists(Server.MapPath(PortalSettings.ActiveTab.SkinPath) + "skin.css"))
					{
						objCSSCache[ID] = PortalSettings.ActiveTab.SkinPath + "skin.css";
					}
					else
					{
						objCSSCache[ID] = "";
					}
					if (!(Common.Globals.PerformanceSetting == Common.Globals.PerformanceSettings.NoCaching))
					{
						DataCache.SetCache("CSS", objCSSCache);
					}
				}
				if (objCSSCache[ID].ToString() != "")
				{
					objLink = new HtmlGenericControl("LINK");
					objLink.ID = ID;
					objLink.Attributes["rel"] = "stylesheet";
					objLink.Attributes["type"] = "text/css";
					objLink.Attributes["href"] = objCSSCache[ID].ToString();
					objCSS.Controls.Add(objLink);
				}

				// skin file style sheet
                    ID = Globals.CreateValidID(PortalSettings.ActiveTab.SkinSrc.Replace(".ascx", ".css"));
				if (objCSSCache.ContainsKey(ID) == false)
				{
                        if (System.IO.File.Exists(Server.MapPath(PortalSettings.ActiveTab.SkinSrc.Replace(".ascx", ".css"))))
					{
						objCSSCache[ID] = PortalSettings.ActiveTab.SkinSrc.Replace(".ascx", ".css");
					}
					else
					{
						objCSSCache[ID] = "";
					}
					if (!(Common.Globals.PerformanceSetting == Common.Globals.PerformanceSettings.NoCaching))
					{
						DataCache.SetCache("CSS", objCSSCache);
					}
				}
				if (objCSSCache[ID].ToString() != "")
				{
					objLink = new HtmlGenericControl("LINK");
					objLink.ID = ID;
					objLink.Attributes["rel"] = "stylesheet";
					objLink.Attributes["type"] = "text/css";
					objLink.Attributes["href"] = objCSSCache[ID].ToString();
					objCSS.Controls.Add(objLink);
				}



				//Let's load the css file for this theme
				string mCSSfile = this.TemplateSourceDirectory + "/FCKtemplates/LinkBrowser/" + mTheme + "/Styles.css";
				if (System.IO.File.Exists(Server.MapPath(mCSSfile)))
				{
					ID = Globals.CreateValidID(mCSSfile);
					if (objCSSCache.ContainsKey(ID) == false)
					{
						if (mCSSfile != "")
						{
							objCSSCache[ID] = mCSSfile;
						}
						else
						{
							objCSSCache[ID] = "";
						}
						if (SharpContent.Common.Globals.PerformanceSetting != SharpContent.Common.Globals.PerformanceSettings.NoCaching)
						{
							DataCache.SetCache("CSS", objCSSCache);
						}
					}
					if (objCSSCache[ID].ToString() != "")
					{
						if (objCSS.FindControl(ID) == null)
						{
							objLink = new HtmlGenericControl("LINK");
							objLink.ID = ID;
							objLink.Attributes["rel"] = "stylesheet";
							objLink.Attributes["type"] = "text/css";
							objLink.Attributes["href"] = objCSSCache[ID].ToString();
							objCSS.Controls.Add(objLink);
						}
					}
				}

				// portal style sheet
				ID = Globals.CreateValidID(PortalSettings.HomeDirectory);
				objLink = new HtmlGenericControl("LINK");
				objLink.ID = ID;
				objLink.Attributes["rel"] = "stylesheet";
				objLink.Attributes["type"] = "text/css";
				objLink.Attributes["href"] = PortalSettings.HomeDirectory + "portal.css";
				objCSS.Controls.Add(objLink);
			}
		}



		#region " Web Form Designer Generated Code "

		//This call is required by the Web Form Designer.
		[System.Diagnostics.DebuggerStepThrough()]
		private void InitializeComponent()
		{

		}

		//NOTE: The following placeholder declaration is required by the Web Form Designer.
		//Do not delete or move it.
		private object designerPlaceholderDeclaration;

		private void Page_Init(object sender, System.EventArgs e)
		{
			//CODEGEN: This method call is required by the Web Form Designer
			//Do not modify it using the code editor.
			InitializeComponent();
		}

		#endregion


		protected void cmdSelect_Click(object sender, System.EventArgs e)
		{
			string[] ver = PortalSettings.Version.Split('.');
			int vermaj = Convert.ToInt32(ver[0]);
			int vermin = Convert.ToInt32(ver[1]);
			string link = ctlURL.Url;
			bool bypassLinkclick = false;

			if (link.ToLower().StartsWith("fileid="))
			{
				bool useSlash = false;
				if ((vermaj == 3 & vermin >= 0 & vermin <= 2) | (vermaj == 4 & vermin == 0))
				{
					SharpContent.Services.FileSystem.FileController dbimg = new SharpContent.Services.FileSystem.FileController();
					string id = link.Substring(7);
					SharpContent.Services.FileSystem.FileInfo objimg = dbimg.GetFileById(Convert.ToInt32(id), PortalSettings.PortalId);
					if ((objimg != null))
					{
						link = objimg.Folder + objimg.FileName;
					}
				}

				else
				{
					SharpContent.Services.FileSystem.FileController dbimg = new SharpContent.Services.FileSystem.FileController();
					string id = link.Substring(7);
					SharpContent.Services.FileSystem.FileInfo objimg = dbimg.GetFileById(Convert.ToInt32(id), PortalSettings.PortalId);

					if ((objimg != null))
					{
						if (objimg.StorageLocation == Convert.ToInt32(SharpContent.Services.FileSystem.FolderController.StorageLocationTypes.InsecureFileSystem))
						{
							link = this.PortalSettings.HomeDirectory + objimg.Folder + objimg.FileName;
							bypassLinkclick = true;
						}
					}
				}

			}
			if ((vermaj == 3 & vermin >= 0 & vermin <= 2) | (vermaj == 4 & vermin == 0))
			{
				link = SharpContent.Common.Globals.LinkClickURL(link);
			}
			else
			{
				if (!bypassLinkclick)
				{
					link = SharpContent.Common.Globals.LinkClick(link, this.PortalSettings.ActiveTab.TabID, -1);
				}

			}

			SendResultURL(link);
		}

		public void SendResultURL(string url)
		{
			string sc = "<script language=\"JavaScript\">" + Environment.NewLine + "<!-- " + Environment.NewLine;
               sc += "OpenFile('" + url + "');" + Environment.NewLine;
               sc += "// --> " + Environment.NewLine + "</script>";
			Page.RegisterStartupScript("DSSendResult", sc);
		}

		private string DSLocalResourceFile {
			get {
				string fileRoot;
				string[] page = Request.ServerVariables["SCRIPT_NAME"].Split('/');


				fileRoot = this.TemplateSourceDirectory + "/" + Services.Localization.Localization.LocalResourceDirectory + "/" + page[page.GetUpperBound(0)] + ".resx";

				return fileRoot;
			}
		}

	}




}

