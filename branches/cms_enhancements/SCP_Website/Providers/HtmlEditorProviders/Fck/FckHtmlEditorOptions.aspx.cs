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

using System;
using System.Collections;
using System.ComponentModel;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

using SharpContent;
using SharpContent.Common;
using SharpContent.Common.Utilities;
using SharpContent.Entities.Portals;
using SharpContent.Framework.Providers;
using SharpContent.Security;
using SharpContent.Services.Exceptions;

namespace SharpContent.HtmlEditor.FckHtmlEditorProvider
{
    public partial class FckHtmlEditorOptions : SharpContent.Framework.PageBase
	{
		protected string title = "";
		protected string jsUrl = "";

		private SharpContent.Entities.Portals.PortalSettings ps = SharpContent.Common.Globals.GetPortalSettings();

		private void Page_Load(object sender, System.EventArgs e)
		{
			string strDebug = "Step 0";
			try {
				strDebug = "Step 1";
				title = SharpContent.Services.Localization.Localization.GetString("PageTitle.Text", DSLocalResourceFile);
				this._clientScript.Text = "<SCRIPT Language='JavaScript' src='" + Page.ResolveUrl("~/js/scpcore.js") + "'></SCRIPT>";

                    if (SharpContent.Security.PortalSecurity.IsInRole(ps.AdministratorRoleName))
                    {
                        int mid = -1;
                        if ((Request.QueryString["mid"] != null) && Globals.IsNumeric(Request.QueryString["mid"]))
                        {
                            mid = Convert.ToInt32(Request.QueryString["mid"]);
                        }
                        SharpContent.Entities.Modules.ModuleInfo m = null;
                        SharpContent.Entities.Modules.ModuleController moduleController = new SharpContent.Entities.Modules.ModuleController();
                        if (mid != -1)
                        {
                            m = moduleController.GetModule(mid, ps.ActiveTab.TabID);
                        }
                        else
                        {
                            //Let's try to solve no moduleconfiguration in profile modules
                            string ctl = "" + System.Web.HttpContext.Current.Request.QueryString["ctl"];
                            if (ctl.ToLower() == "profile" | ps.ActiveTab.ParentId == ps.AdminTabId)
                            {
                                //m = db.GetModuleByDefinition(ps.PortalId, "User Accounts")
                                m = new SharpContent.Entities.Modules.ModuleInfo();
                                m.ModuleID = -1;
                                m.TabModuleID = -1;
                                if (ctl.ToLower() == "profile")
                                {
                                    m.ModuleTitle = "Profile";
                                }
                                
                                m.ModulePermissions = new SharpContent.Security.Permissions.ModulePermissionCollection();

                                m.TabID = ps.ActiveTab.TabID;
                                m.PortalID = ps.PortalId;

                            }

                        }
                        if ((m != null))
                        {
                            FckInstanceOptions oAdminOptions = (FckInstanceOptions)Page.LoadControl("FckInstanceOptions.ascx");
                            oAdminOptions.ID = "fckInstanceOptions";
                            oAdminOptions.ModuleConfiguration = m;
                            phControls.Controls.Add(oAdminOptions);
                        }
                        else
                        {
                            phControls.Controls.Add(new LiteralControl(SharpContent.Services.Localization.Localization.GetString("NoModule.Text", DSLocalResourceFile)));
                        }
                    }

                    else
                    {
                        phControls.Controls.Add(new LiteralControl(SharpContent.Services.Localization.Localization.GetString("AccessDenied.Text", DSLocalResourceFile)));
                    }
			}
			catch (Exception exc) {
				Exceptions.LogException(new Exception("Error creating custom options control instance (" + strDebug + ")", exc));
			}

		}

		private void ManageStyleSheets(bool PortalCSS)
		{

			// initialize reference paths to load the cascading style sheets
			Control objCSS = this.FindControl("CSS");
			HtmlGenericControl objLink;
			string ID;

			Hashtable objCSSCache = (Hashtable)DataCache.GetCache("CSS");
			if (objCSSCache == null)
			{
				objCSSCache = new Hashtable();
			}

			if ((objCSS != null))
			{
				if (PortalCSS == false)
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
					ID = Globals.CreateValidID(ps.ActiveTab.SkinPath);
					if (objCSSCache.ContainsKey(ID) == false)
					{
						if (System.IO.File.Exists(Server.MapPath(ps.ActiveTab.SkinPath) + "skin.css"))
						{
							objCSSCache[ID] = ps.ActiveTab.SkinPath + "skin.css";
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
					ID = Globals.CreateValidID(ps.ActiveTab.SkinSrc.Replace(".ascx", ".css"));
					if (objCSSCache.ContainsKey(ID) == false)
					{
                             if (System.IO.File.Exists(Server.MapPath(ps.ActiveTab.SkinSrc.Replace(".ascx", ".css"))))
						{
							objCSSCache[ID] = ps.ActiveTab.SkinSrc.Replace(".ascx", ".css");
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
				}
				else
				{
					// portal style sheet
					ID = Globals.CreateValidID(ps.HomeDirectory);
					objLink = new HtmlGenericControl("LINK");
					objLink.ID = ID;
					objLink.Attributes["rel"] = "stylesheet";
					objLink.Attributes["type"] = "text/css";
					objLink.Attributes["href"] = ps.HomeDirectory + "portal.css";
					objCSS.Controls.Add(objLink);
				}

			}

		}

		private void ManageFavicon()
		{
			string strFavicon = (string)DataCache.GetCache("FAVICON" + ps.PortalId.ToString());
			if (strFavicon == "")
			{
				if (System.IO.File.Exists(ps.HomeDirectoryMapPath + "favicon.ico"))
				{
					strFavicon = ps.HomeDirectory + "favicon.ico";
					if (!(Common.Globals.PerformanceSetting == Common.Globals.PerformanceSettings.NoCaching))
					{
						DataCache.SetCache("FAVICON" + ps.PortalId.ToString(), strFavicon);
					}
				}
			}
			if (strFavicon != "")
			{
				HtmlGenericControl objLink = new HtmlGenericControl("LINK");
				objLink.Attributes["rel"] = "SHORTCUT ICON";
				objLink.Attributes["href"] = strFavicon;

				Control ctlFavicon = this.FindControl("FAVICON");
				ctlFavicon.Controls.Add(objLink);
			}
		}
		#region " Web Form Designer Generated Code "

		//This call is required by the Web Form Designer.
		[System.Diagnostics.DebuggerStepThrough()]
		private void InitializeComponent()
		{

		}

		private void Page_Init(object sender, System.EventArgs e)
		{
			//CODEGEN: This method call is required by the Web Form Designer
			//Do not modify it using the code editor.
			InitializeComponent();

			// avoid client side page caching for authenticated users
			if (Request.IsAuthenticated == true)
			{
				Response.Cache.SetCacheability(System.Web.HttpCacheability.ServerAndNoCache);
			}

			ManageStyleSheets(false);
			//If Not Page.IsClientScriptBlockRegistered("SCPCoreScript") Then
			//Page.RegisterClientScriptBlock("SCPCoreScript", "<SCRIPT Language='JavaScript' src='" & Page.ResolveUrl("~/js/scpcore.js") & "'></SCRIPT>")
			//End If


			// add Favicon
			ManageFavicon();

			// add CSS links
			ManageStyleSheets(true);
		}


		#endregion

		[Browsable(false), DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
		protected string DSLocalResourceFile {
			get {
				string fileRoot;
                    string[] page = Request.ServerVariables["SCRIPT_NAME"].Split(new Char[]{'/'});


				fileRoot = this.TemplateSourceDirectory + "/" + Services.Localization.Localization.LocalResourceDirectory + "/" + page[page.GetUpperBound(0)].ToString() + ".resx";

				return fileRoot;
			}
		}
	}
}
