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
using System.Globalization;
using System.Security.Permissions;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;

using SharpContent.Common;
using SharpContent.Services.Exceptions;

namespace SharpContent.HtmlEditor.FckHtmlEditorProvider
{

    public enum LanguageDirection
    {
        LeftToRight,
        RightToLeft
    }


    public class FckEditorControl : Control, IPostBackDataHandler
    {

        //Helper object to acces parent module data
        protected FckHtmlEditorProvider providerControl;
        private Hashtable settings;
        protected SharpContent.Entities.Modules.PortalModuleBase parentModule;
        private SharpContent.Entities.Portals.PortalSettings ps = SharpContent.Common.Globals.GetPortalSettings();
        private bool IsAdminUser = false;

        public FckEditorControl() {}

        #region "Base Configurations Properties"


        public FckEditorConfigurations Config
        {
            get
            {
                if (ViewState["Config"] == null)
                {
                    ViewState["Config"] = new FckEditorConfigurations();
                }
                return (FckEditorConfigurations)ViewState["Config"];
            }
        }

        [DefaultValue("")]
        public string Value
        {
            get
            {
                object o = ViewState["Value"];
                if (o == null)
                {
                    return "";
                }
                else
                {
                    return (string)o;
                }
            }
            set { ViewState["Value"] = value; }
        }

        public string BasePath
        {
            get
            {
                object o = ViewState["BasePath"];
                if (o == null)
                {
                    return "";
                }
                else
                {
                    return (string)o;
                }
            }
            set { ViewState["BasePath"] = value; }
        }

        public string ToolbarSet
        {
            get
            {
                object o = ViewState["ToolbarSet"];
                if (o == null)
                {
                    return "SCPDefault";
                }
                else
                {
                    return (string)o;
                }
            }
            set { ViewState["ToolbarSet"] = value; }
        }

        //public string ConfigObject(configProperty)
        //{
        //     get {
        //          object o = ViewState[configProperty];
        //          if (o == null)
        //          {
        //               return "";
        //          }
        //          else
        //          {
        //               return (string)o;
        //          }
        //     }
        //     set { ViewState[configProperty] = value; }
        //}

        #endregion

        #region "Appearence Properties"
        public Unit Width
        {
            get
            {
                object o = ViewState["Width"];
                if (o == null)
                {
                    return Unit.Percentage(300);
                }
                else
                {
                    return (Unit)o;
                }
            }
            set { ViewState["Width"] = value; }
        }
        public Unit Height
        {
            get
            {
                object o = ViewState["Height"];
                if (o == null)
                {
                    return Unit.Percentage(200);
                }
                else
                {
                    return (Unit)o;
                }
            }
            set { ViewState["Height"] = value; }
        }


        #endregion

        #region "Configurations Properties"

        public string CustomConfigurationsPath
        {
            set { Config["CustomConfigurationsPath"] = value; }
        }

        public string EditorAreaCSS
        {
            set { this.Config["EditorAreaCSS"] = value; }
        }

        public string BaseHref
        {
            set { this.Config["BaseHref"] = value; }
        }

        public string SkinPath
        {
            set { this.Config["SkinPath"] = value; }
        }

        public string PluginsPath
        {
            set { this.Config["PluginsPath"] = value; }
        }


        public bool FullPage
        {
            set { this.Config["FullPage"] = (string)(value ? "true" : "false"); }
        }

        public bool Debug
        {
            set { this.Config["Debug"] = (string)(value ? "true" : "false"); }
        }


        public bool AutoDetectLanguage
        {
            set { this.Config["AutoDetectLanguage"] = (string)(value ? "true" : "false"); }
        }


        public string DefaultLanguage
        {
            set { this.Config["DefaultLanguage"] = value; }
        }

        public LanguageDirection ContentLangDirection
        {
            set { this.Config["ContentLangDirection"] = (string)(value == LanguageDirection.LeftToRight ? "ltr" : "rtl"); }
        }

        public bool EnableXHTML
        {
            set { this.Config["EnableXHTML"] = (string)(value ? "true" : "false"); }
        }

        public bool EnableSourceXHTML
        {
            set { this.Config["EnableSourceXHTML"] = (string)(value ? "true" : "false"); }
        }

        public bool FillEmptyBlocks
        {
            set { this.Config["FillEmptyBlocks"] = (string)(value ? "true" : "false"); }
        }

        public bool FormatSource
        {
            set { this.Config["FormatSource"] = (string)(value ? "true" : "false"); }
        }

        public bool FormatOutput
        {
            set { this.Config["FormatOutput"] = (string)(value ? "true" : "false"); }
        }

        public string FormatIndentator
        {
            set { this.Config["FormatIndentator"] = value; }
        }

        public bool GeckoUseSPAN
        {
            set { this.Config["GeckoUseSPAN"] = (string)(value ? "true" : "false"); }
        }

        public bool StartupFocus
        {
            set { this.Config["StartupFocus"] = (string)(value ? "true" : "false"); }
        }


        public bool ForcePasteAsPlainText
        {
            set { this.Config["ForcePasteAsPlainText"] = (string)(value ? "true" : "false"); }
        }

        public bool ForceSimpleAmpersand
        {
            set { this.Config["ForceSimpleAmpersand"] = (string)(value ? "true" : "false"); }
        }

        public int TabSpaces
        {
            set { this.Config["ForceSimpleAmpersand"] = value.ToString(CultureInfo.InvariantCulture); }
        }

        public bool UseBROnCarriageReturn
        {
            set { this.Config["UseBROnCarriageReturn"] = (string)(value ? "true" : "false"); }
        }

        public bool ToolbarStartExpanded
        {
            set { this.Config["ToolbarStartExpanded"] = (string)(value ? "true" : "false"); }
        }

        public bool ToolbarCanCollapse
        {
            set { this.Config["ToolbarCanCollapse"] = (string)(value ? "true" : "false"); }
        }

        public string FontColors
        {
            set { this.Config["FontColors"] = value; }
        }

        public string FontNames
        {
            set { this.Config["FontNames"] = value; }
        }

        public string FontSizes
        {
            set { this.Config["FontSizes"] = value; }
        }

        public string FontFormats
        {
            set { this.Config["FontFormats"] = value; }
        }

        public string StylesXmlPath
        {
            set { this.Config["StylesXmlPath"] = value; }
        }

        public string LinkBrowserURL
        {
            set { this.Config["LinkBrowserURL"] = value; }
        }

        public string LinkBrowserWindowWidth
        {
            set { this.Config["LinkBrowserWindowWidth"] = value; }
        }

        public string LinkBrowserWindowHeight
        {
            set { this.Config["LinkBrowserWindowHeight"] = value; }
        }

        public string ImageBrowserURL
        {
            set { this.Config["ImageBrowserURL"] = value; }
        }

        public string ImageBrowserWindowWidth
        {
            set { this.Config["ImageBrowserWindowWidth"] = value; }
        }

        public string ImageBrowserWindowHeight
        {
            set { this.Config["ImageBrowserWindowHeight"] = value; }
        }

        public string ImageUploadURL
        {
            set { this.Config["ImageUploadURL"] = value; }
        }

        public string FlashBrowserURL
        {
            set { this.Config["FlashBrowserURL"] = value; }
        }

        public string FlashBrowserWindowWidth
        {
            set { this.Config["FlashBrowserWindowWidth"] = value; }
        }

        public string FlashBrowserWindowHeight
        {
            set { this.Config["FlashBrowserWindowHeight"] = value; }
        }

        public string FlashUploadURL
        {
            set { this.Config["FlashUploadURL"] = value; }
        }

        public bool FCKSource
        {
            set { this.Config["fckSource"] = (string)(value ? "true" : "false"); }
        }


        #endregion

        #region "Rendering"
        protected override void Render(HtmlTextWriter writer)
        {
            writer.Write("<div style=\"width:" + this.Width.ToString() + ";\">");
            if (this.CheckBrowserCompatibility())
            {
                //Include the admin link
                if (this.IsAdminUser)
                {
                    writer.Write("<table width=\"{0}\" height=\"{1}\" border=\"0\" cellpadding=\"0\"", this.Width, this.Height);
                    writer.Write("<tr><td width=\"{0}\" height=\"{1}\"  class=\"normal\">", this.Width, this.Height);
                }

                //Here comes the real FCKeditor render
                string sLink = this.BasePath;
                if (sLink.StartsWith("~")) sLink = this.ResolveUrl(sLink);
                string sFile = (string)(Convert.ToString(Page.Request.QueryString["fcksource"]) == "true" ? "fckeditor.original.html" : "fckeditor.html");
                sLink += "editor/" + sFile + "?InstanceName=" + this.ClientID;
                if (this.ToolbarSet.Length > 0) sLink += "&amp;Toolbar=" + this.ToolbarSet;
                // Render the linked hidden field.
                //writer.Write("<input type=""hidden"" id=""{0}"" name=""{1}"" value=""{2}"" />", Me.ClientID, Me.UniqueID, System.Web.HttpUtility.HtmlEncode(Me.Value))
                writer.Write("<input type=\"hidden\" id=\"{0}\" name=\"{1}\" value=\"{2}\" />", this.ClientID, this.ClientID, System.Web.HttpUtility.HtmlEncode(this.Value));

                // Render the configurations hidden field
                writer.Write("<input type=\"hidden\" id=\"{0}___Config\" value=\"{1}\" />", this.ClientID, this.Config.GetHiddenFieldString());
                // Render the editor IFRAME.
                writer.Write("<iframe id=\"{0}___Frame\" src=\"{1}\" width=\"{2}\" height=\"{3}\" frameborder=\"no\" scrolling=\"no\"></iframe>", this.ClientID, sLink, this.Width, this.Height);

                if (this.IsAdminUser)
                {

                    writer.Write("</td></tr><tr><td width=\"{0}\" class=\"normal\">", this.Width);
                    //Let's create an opener for the options page (4 options to do this


                    string oCtl = "" + System.Web.HttpContext.Current.Request.QueryString["ctl"];
                    string oUrl = providerControl.ProviderPath.TrimEnd(new char[] { '/' }) + "/FckHtmlEditorOptions.aspx?mid=" + parentModule.ModuleId + "&tabid=" + ps.ActiveTab.TabID.ToString() + "&iname=" + this.ID;
                    if (oCtl != "") oUrl += "&ctl=" + oCtl;

                    writer.Write("<a href=\"{0}\" class=\"CommandButton\" id=\"{1}\" name=\"{2}\"", oUrl, this.ClientID + "_ceopener", this.UniqueID + "_ceopener");
                    if (providerControl.OptionsOpenMode.ToLower() == "showmodaldialog" | providerControl.OptionsOpenMode.ToLower() == "open")
                    {
                        writer.Write(" onClick=\"return openfckCustomOptions('{0}','popupwindow');\"", oUrl);

                    }

                    if (providerControl.OptionsOpenMode.ToLower() == "urlnewwindow")
                    {
                        writer.Write(" target=\"_blank\"");
                    }
                    string myResourceFile = providerControl.ProviderPath + "/" + Services.Localization.Localization.LocalResourceDirectory + "/fckinstanceoptions.ascx.resx";
                    writer.Write(">{0}</a>", SharpContent.Services.Localization.Localization.GetString("ShowEditorOptions.Text", myResourceFile));

                    writer.Write("&nbsp;|&nbsp;<a href=\"{0}\" class=\"CommandButton\" id=\"{1}\" name=\"{2}\">{3}</a>", System.Web.HttpContext.Current.Request.RawUrl, this.ClientID + "_cerefresh", this.UniqueID + "_cerefresh", SharpContent.Services.Localization.Localization.GetString("RefreshEditor.Text", myResourceFile));

                    if ((this.providerControl.IsFCKDebug))
                    {
                        System.Text.StringBuilder mydata = new System.Text.StringBuilder();
                        mydata.Append("FCK DEBUG INFORMATION DATA (English only):");
                        mydata.Append("------------------------------------------");
                        mydata.Append("SCP Version=" + parentModule.PortalSettings.Version);
                        mydata.Append("ModuleId=" + this.parentModule.ModuleId.ToString() + Environment.NewLine);
                        mydata.Append("ModuleType=" + Environment.NewLine);
                        mydata.Append("SCPUser=" + this.parentModule.UserId.ToString() + Environment.NewLine);
                        mydata.Append("InstanceName=" + this.ID + Environment.NewLine);
                        string strAppPath = SharpContent.Common.Globals.ApplicationPath;
                        if (strAppPath == "") strAppPath = "Nothing";
                        mydata.Append("ApplicationPath=" + strAppPath + Environment.NewLine);
                        mydata.Append("Image Folder ID=" + GetFCKSetting("IMF") + Environment.NewLine);
                        mydata.Append("ToolbarNotExpanded=" + GetFCKSetting("TBE") + Environment.NewLine);
                        mydata.Append("ToolbarStartExpanded=" + this.Config["ToolbarStartExpanded"].ToString() + Environment.NewLine);
                        mydata.Append("TBE-I-KEY=" + this.GetFCKModuleSettingKey("I", "TBE") + "= " + this.GetFCKSetting_I("TBE") + Environment.NewLine);
                        mydata.Append("TBE-M-KEY=" + this.GetFCKModuleSettingKey("M", "TBE") + "= " + this.GetFCKSetting_M("TBE") + Environment.NewLine);
                        mydata.Append("TBE-P-KEY=" + this.GetFCKModuleSettingKey("P", "TBE") + "= " + this.GetFCKSetting_P("TBE") + Environment.NewLine);
                        mydata.Append("FCK-Config= " + this.Config.GetHiddenFieldString());

                        writer.Write("<br><textarea name=\"dnnfcktestdata\" rows=\"10\" cols=\"80\">" + mydata.ToString() + "</textarea>");
                    }

                    writer.Write("</td></tr></table>");

                }
            }
            else
            {
                writer.Write("<textarea name=\"{0}\" rows=\"4\" cols=\"40\" style=\"width: {1}; height: {2}\" wrap=\"virtual\">{3}</textarea>", this.UniqueID, this.Width, this.Height, System.Web.HttpUtility.HtmlEncode(this.Value));
            }
            writer.Write("</div>");
        }

        public bool CheckBrowserCompatibility()
        {
            System.Web.HttpBrowserCapabilities oBrowser = Page.Request.Browser;
            //Internet Explorer 5.5+ for Windows
            if ((oBrowser != null) && (oBrowser.Browser == "IE" & (oBrowser.MajorVersion >= 6 | (oBrowser.MajorVersion == 5 & oBrowser.MinorVersion >= 0.5)) & oBrowser.Win32))
            {
                return true;
            }
            else
            {
                if ((this.Page.Request.UserAgent != null))
                {
                    Match oMatch = Regex.Match(this.Page.Request.UserAgent, "(?<=Gecko/)\\d{8}");
                    if (oMatch.Success)
                    {
                        if (Globals.IsNumeric(oMatch.Value))
                        {
                            return int.Parse(oMatch.Value, CultureInfo.InvariantCulture) >= 20030210;
                        }
                        else
                        {
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    return false;
                }
            }
        }

        #endregion

        #region "Postback Handling"

        bool IPostBackDataHandler.LoadPostData(string postDataKey, System.Collections.Specialized.NameValueCollection postCollection)
        {
            string myKey = this.ClientID;
            //Normally it must be postDataKey, but this change is necesary to make it compatuble with the profile module
            //TODO: Must be validated once FTB and the profile module is fixed.
            if ((postCollection[myKey] != null) && postCollection[myKey] != this.Value)
            {
                this.Value = postCollection[myKey];
                return true;
            }
            else
            {
                return false;
            }
        }

        void IPostBackDataHandler.RaisePostDataChangedEvent()
        {
            // Do nothing
        }

        #endregion

        #region "Wrapper additions for SCP"
        //The FCKeditor wrapper was merger with the editor control to optimize and make it more clear

        public FckHtmlEditorProvider ProviderControl
        {
            get { return providerControl; }
            set { providerControl = value; }
        }

        protected override void OnInit(EventArgs e)
        {
            if ((Page != null))
            {
                Page.RegisterRequiresPostBack(this);
                //Ensures that postback is handled
            }
            //Let's find which module we are inside of
            parentModule = (SharpContent.Entities.Modules.PortalModuleBase)FindModuleInstance(this);
            if (parentModule == null || parentModule.ModuleId == -1)
            {
                //The is no real module, then use the "User Accounts" module (Profile editor)
                SharpContent.Entities.Modules.ModuleController db = new SharpContent.Entities.Modules.ModuleController();
                SharpContent.Entities.Modules.ModuleInfo objm = db.GetModuleByDefinition(ps.PortalId, "User Accounts");
                settings = db.GetTabModuleSettings(objm.TabModuleID);
            }
            else
            {
                //Use the parent module to store settigs, so settings are deleted when module is deleted
                settings = parentModule.Settings;
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            //Let's check if we have access to the custom options dialog
            if ((parentModule != null))
            {
                switch (providerControl.CustomOptionsDialog.ToLower())
                {
                    case "host":
                        if (parentModule.UserInfo.IsSuperUser)
                        {
                            this.IsAdminUser = true;
                        }

                        break;
                    case "admin":
                        if (SharpContent.Security.PortalSecurity.IsInRole(ps.AdministratorRoleName))
                        {
                            this.IsAdminUser = true;
                        }

                        break;
                }
                // Let's get custom values
                this.LoadFCKCTLSettings(this.IsAdminUser);
            }


            //This routine renders the needed javascript to open
            //TODO: Enhance this javascript
            if (IsAdminUser & !Page.IsClientScriptBlockRegistered("FCKCustomOptionsOpener"))
            {
                StringBuilder oStr = new StringBuilder();
                oStr.Append("<SCRIPT Language='JavaScript'>" + Environment.NewLine);
                oStr.Append("function openfckCustomOptions(oUrl,oName){" + Environment.NewLine);
                if (providerControl.OptionsOpenMode.ToLower() == "showmodaldialog")
                {
                    oStr.Append("if (window.showModalDialog) {" + Environment.NewLine);
                    oStr.Append("window.showModalDialog(oUrl,oName,\"resizable:yes;center:yes;dialogWidth:750px;dialogHeight:560px\");" + Environment.NewLine);
                    oStr.Append("}" + Environment.NewLine);
                    oStr.Append("else{" + Environment.NewLine);
                }

                oStr.Append("var oWin = window.open(oUrl,oName,\"width=750,height=550,scrollbars,resizable\");" + Environment.NewLine);
                oStr.Append("if (oWin==null || typeof(oWin)==\"undefined\") alert(\"FCKeditor needs you to allow popups for this domain\");" + Environment.NewLine);
                if (providerControl.OptionsOpenMode.ToLower() == "showmodaldialog")
                {
                    oStr.Append("}" + Environment.NewLine);
                }
                oStr.Append("return false;}" + Environment.NewLine);
                oStr.Append("</SCRIPT>" + Environment.NewLine);
                Page.RegisterClientScriptBlock("FCKCustomOptionsOpener", oStr.ToString());
            }
        }

        public static Control FindModuleInstance(Control fCtl)
        {
            System.Web.UI.Control ctl = fCtl.Parent;
            System.Web.UI.Control selectedCtl = null;
            System.Web.UI.Control possibleCtl = null;
            while ((ctl != null))
            {
                if (ctl is SharpContent.Entities.Modules.PortalModuleBase)
                {
                    if (((SharpContent.Entities.Modules.PortalModuleBase)ctl).TabModuleId == SharpContent.Common.Utilities.Null.NullInteger)
                    {
                        if (selectedCtl == null)
                        {
                            possibleCtl = ctl;
                        }
                    }
                    else
                    {
                        selectedCtl = ctl;
                        break; // TODO: might not be correct. Was : Exit While
                    }

                }
                ctl = ctl.Parent;
            }
            if (selectedCtl == null & (possibleCtl != null))
            {
                selectedCtl = possibleCtl;
            }
            return selectedCtl;
        }

        public string GetFCKModuleSettingKey(string pType, string pName)
        {
            string strKey = "";
            switch (pType)
            {
                case "I":
                case "M":
                    strKey = "SCPFCK" + pType + "#" + pName;
                    if (pType == "I")
                    {
                        //Is custom setting for this instance?
                        string ctl = "" + System.Web.HttpContext.Current.Request["ctl"];
                        if (ctl == "")
                        {
                            ctl = "#!!!!";
                        }
                        strKey += "#" + ctl + "#" + this.ID;
                    }

                    break;
                case "P":
                    strKey = "SCPFCKP#" + ps.PortalId.ToString() + "#" + pName;
                    break;
            }

            return strKey;
        }

        public string GetFCKSetting(string pName)
        {
            string MyValue = GetFCKSetting_I(pName);
            if (MyValue == "")
            {
                MyValue = GetFCKSetting_M(pName);
            }
            if (MyValue == "")
            {
                MyValue = GetFCKSetting_P(pName);
            }
            return MyValue;
        }

        public string GetFCKSetting_I(string pName)
        {
            string myKey = GetFCKModuleSettingKey("I", pName);
            // Get instance setting
            string MyValue = "";
            if ((parentModule != null) && parentModule.TabModuleId <= 0)
            {
                myKey = "PROF#" + ps.PortalId.ToString() + "#" + myKey;
                MyValue = "" + Convert.ToString(ps.HostSettings[myKey]);
            }
            else
            {
                MyValue = "" + Convert.ToString(settings[myKey]);
            }
            return MyValue;
        }

        public string GetFCKSetting_M(string pName)
        {
            string myKey = GetFCKModuleSettingKey("M", pName);
            // Get module setting
            string MyValue = "";
            if ((parentModule != null) && parentModule.TabModuleId <= 0)
            {
                myKey = "PROF#" + ps.PortalId.ToString() + "#" + myKey;
                MyValue = "" + Convert.ToString(ps.HostSettings[myKey]);
            }
            else
            {
                MyValue = "" + Convert.ToString(settings[myKey]);
            }
            return MyValue;
        }

        public string GetFCKSetting_P(string pName)
        {
            string myKey = GetFCKModuleSettingKey("P", pName);
            // Get portal setting
            string MyValue = "" + Convert.ToString(ps.HostSettings[myKey]);
            return MyValue;
        }

        public SharpContent.Services.FileSystem.FolderInfo GetFolderInfo(int MyportalId, int MyFolderId)
        {
            SharpContent.Services.FileSystem.FolderController db = new SharpContent.Services.FileSystem.FolderController();
            return db.GetFolderInfo(parentModule.PortalSettings.PortalId, MyFolderId);
        }


        public void LoadFCKCTLSettings(bool mAdmin)
        {
            //Note: Validation was separated to keep better information to trace errors
            string sel = "";

            try
            {
                //Let's find the toolbarset
                string tbset = "";
                string tbOrderList = GetFCKSetting("TBO");
                //Toolbarset order list
                string[] tbOrderItems = tbOrderList.Split(',');
                string lastToolbar = "";
                if (tbOrderList != "")
                {
                    foreach (string tboi in tbOrderItems)
                    {
                        if (tboi != "")
                        {
                            sel = GetFCKSetting("TBO$" + tboi.Trim());
                            if (sel != "")
                            {
                                //We must get all parts
                                string[] v = sel.Split(';');
                                bool tbDisabled = false;
                                if (v.Length > 0)
                                {
                                    tbDisabled = bool.Parse(v[0]);
                                }
                                if (v.Length > 1 & !tbDisabled)
                                {

                                    if (parentModule.UserInfo.IsSuperUser | mAdmin)
                                    {
                                        tbset = tboi;
                                        break; // TODO: might not be correct. Was : Exit For
                                    }
                                    else
                                    {
                                        for (int i = 1; i <= v.Length - 1; i++)
                                        {
                                            if (SharpContent.Security.PortalSecurity.IsInRole(SharpContent.Common.Globals.GetRoleName(Convert.ToInt32(v[i]))))
                                            {
                                                tbset = tboi;
                                                break; // TODO: might not be correct. Was : Exit For
                                            }
                                        }
                                        if (tbset != "")
                                        {
                                            break; // TODO: might not be correct. Was : Exit For
                                        }
                                    }
                                }
                            }
                            else
                            {
                                //tbset = tboi

                            }
                            lastToolbar = tboi;
                        }
                    }

                    if (tbset != "")
                    {
                        this.ToolbarSet = tbset;
                    }
                    else if (lastToolbar != "")
                    {
                        this.ToolbarSet = lastToolbar;
                    }
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Toolbars)", exc));
            }

            //Custom root folder data
            string RootImageDirectory = providerControl.RootImageDirectory;
            try
            {
                //RootImageDirectory = MyProviderControl.RootImageDirectory
                sel = GetFCKSetting("IMF");
                // Custom image folder
                if (sel.Trim() != "" && Globals.IsNumeric(sel))
                {
                    int myFolderId = Convert.ToInt32(sel);
                    if (myFolderId > 0)
                    {
                        //let's validate. It must begin at 1
                        SharpContent.Services.FileSystem.FolderController db = new SharpContent.Services.FileSystem.FolderController();
                        SharpContent.Services.FileSystem.FolderInfo objFolder = null;

                        string[] ver = parentModule.PortalSettings.Version.Split('.');
                        int vermaj = Convert.ToInt32(ver[0]);
                        int vermin = Convert.ToInt32(ver[1]);
                        if (vermaj > 4 | (vermaj == 4 & vermin >= 5))
                        {
                            objFolder = this.GetFolderInfo(parentModule.PortalSettings.PortalId, myFolderId);
                        }
                        else
                        {
                            ArrayList lstObjFolder = db.GetFolder(parentModule.PortalSettings.PortalId, myFolderId);
                            if (lstObjFolder.Count > 0)
                            {
                                objFolder = (SharpContent.Services.FileSystem.FolderInfo)lstObjFolder[0];
                            }
                        }

                        bool useSlash = false;

                        if ((objFolder != null))
                        {
                            RootImageDirectory = parentModule.PortalSettings.HomeDirectory + objFolder.FolderPath;
                            //Set default folders for quick upload
                            this.ImageUploadURL = providerControl.ImageGalleryPath + "?Type=Image&Command=FileUpload&tabid=" + parentModule.PortalSettings.ActiveTab.TabID + "&RootFolder=" + RootImageDirectory + "&CurrentFolder=/";
                            this.FlashUploadURL = providerControl.FlashGalleryPath + "?Type=Flash&Command=FileUpload&tabid=" + parentModule.PortalSettings.ActiveTab.TabID + "&RootFolder=" + RootImageDirectory + "&CurrentFolder=/";
                        }
                    }

                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Root folder)", exc));
            }

            try
            {
                sel = GetFCKSetting("TBS");
                // Toolbar skin
                if (sel.Trim() != "")
                {
                    //_MyEditCtl.ToolbarSet = sel
                    this.SkinPath = this.BasePath + "editor/skins/" + sel + "/";
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Toolbar Skin)", exc));
            }

            try
            {
                string gTheme;
                sel = GetFCKSetting("IBS");
                //Image gallery skin
                if (sel == "")
                {
                    sel = providerControl.DefaultImageGallerySkin;
                }
                this.ImageBrowserURL = providerControl.ImageGalleryPath + "?" + Convert.ToString((sel == "" ? "" : "FCKTheme=" + sel + "&")) + "Type=Image&tabid=" + parentModule.PortalSettings.ActiveTab.TabID + "&RootFolder=" + RootImageDirectory + "&CurrentFolder=/";
                string strVal = GetFCKTemplateValue("Window.Width", sel, "ImageBrowser");
                if (strVal != "")
                {
                    this.ImageBrowserWindowWidth = strVal;
                }
                strVal = GetFCKTemplateValue("Window.Height", sel, "ImageBrowser");
                if (strVal != "")
                {
                    this.ImageBrowserWindowHeight = strVal;
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Image Gallery skin)", exc));
            }

            try
            {
                sel = GetFCKSetting("FBS");
                //Flash gallery skin
                if (sel == "")
                {
                    sel = providerControl.DefaultFlashGallerySkin;
                }
                this.FlashBrowserURL = providerControl.FlashGalleryPath + "?" + Convert.ToString((sel == "" ? "" : "FCKTheme=" + sel + "&")) + "Type=Flash&tabid=" + parentModule.PortalSettings.ActiveTab.TabID + "&RootFolder=" + RootImageDirectory + "&CurrentFolder=/";
                string strVal = GetFCKTemplateValue("Window.Width", sel, "FlashBrowser");
                if (strVal != "")
                {
                    this.FlashBrowserWindowWidth = strVal;
                }
                strVal = GetFCKTemplateValue("Window.Height", sel, "FlashBrowser");
                if (strVal != "")
                {
                    this.FlashBrowserWindowHeight = strVal;
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Flash Gallery skin)", exc));
            }

            try
            {
                sel = GetFCKSetting("LBS");
                //Links gallery skin
                if (sel == "")
                {
                    sel = providerControl.DefaultLinksGallerySkin;
                }
                this.LinkBrowserURL = providerControl.LinksGalleryPath + "?" + Convert.ToString((sel == "" ? "" : "FCKTheme=" + sel + "&")) + "tabid=" + parentModule.PortalSettings.ActiveTab.TabID;
                string strVal = GetFCKTemplateValue("Window.Width", sel, "LinkBrowser");
                if (strVal != "")
                {
                    this.LinkBrowserWindowWidth = strVal;
                }
                strVal = GetFCKTemplateValue("Window.Height", sel, "LinkBrowser");
                if (strVal != "")
                {
                    this.LinkBrowserWindowHeight = strVal;
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Links Gallery Skin)", exc));
            }

            try
            {
                sel = GetFCKSetting("TBE");
                // Toolbar not expanded
                if (sel != "")
                {
                    this.ToolbarStartExpanded = !bool.Parse(sel);
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Toolbar not expanded)", exc));
            }

            try
            {
                sel = GetFCKSetting("SEC");
                // enhanced security
                if (sel != "")
                {
                    bool es = bool.Parse(sel);
                    if (es)
                    {
                        this.CustomConfigurationsPath = providerControl.SecureConfigurationPath;
                    }

                    else
                    {
                        this.CustomConfigurationsPath = providerControl.CustomConfigurationPath;
                    }
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Enhanced security)", exc));
            }

            try
            {
                sel = GetFCKSetting("SDM");
                // StylesDefaultMode
                if (sel != "")
                {
                    switch (sel)
                    {
                        case "dynamic":
                            string mFilter = GetFCKSetting("SFI");
                            this.StylesXmlPath = providerControl.DynamicStylesGeneratorPath + "?tabid=" + parentModule.PortalSettings.ActiveTab.TabID + Convert.ToString((mFilter == "" ? "" : "&FCKStyleFilter=" + SharpContent.Common.Globals.QueryStringEncode(mFilter)));
                            break;
                        case "static":
                            this.StylesXmlPath = providerControl.StaticStylesFile;
                            break;
                        case "url":
                            string myurl = GetFCKSetting("SCF");
                            if (myurl.Trim() != "")
                            {
                                if (myurl.Length > 7 && myurl.Substring(0, 7).ToLower() == "fileid=")
                                {
                                    //Gets filename for FileId
                                    string myFile = myurl.Substring(7);
                                    SharpContent.Services.FileSystem.FileController db = new SharpContent.Services.FileSystem.FileController();
                                    SharpContent.Services.FileSystem.FileInfo objFile = db.GetFileById(Convert.ToInt32(myFile), parentModule.PortalId);
                                    if (objFile == null)
                                    {
                                        this.StylesXmlPath = providerControl.StaticStylesFile;
                                    }
                                    else
                                    {
                                        this.StylesXmlPath = parentModule.PortalSettings.HomeDirectory + objFile.Folder + objFile.FileName;
                                    }
                                }
                                else
                                {
                                    this.StylesXmlPath = myurl;
                                }
                            }
                            else
                            {
                                this.StylesXmlPath = providerControl.StaticStylesFile;
                            }

                            break;
                    }
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Styles .xml mode)", exc));
            }

            try
            {
                sel = GetFCKSetting("CDM");
                // CSSDefaultMode
                if (sel != "")
                {
                    switch (sel)
                    {
                        case "dynamic":
                            this.EditorAreaCSS = providerControl.DynamicCSSGeneratorPath + "?tabid=" + parentModule.PortalSettings.ActiveTab.TabID;
                            break;
                        case "static":
                            this.EditorAreaCSS = providerControl.StaticCSSFile;
                            break;
                        case "url":
                            string myurl = GetFCKSetting("CCF");
                            if (myurl.Trim() != "")
                            {
                                if (myurl.Length > 7 && myurl.Substring(0, 7).ToLower() == "fileid=")
                                {
                                    //Gets filename for FileId
                                    string myFile = myurl.Substring(7);
                                    SharpContent.Services.FileSystem.FileController db = new SharpContent.Services.FileSystem.FileController();
                                    SharpContent.Services.FileSystem.FileInfo objFile = db.GetFileById(Convert.ToInt32(myFile), parentModule.PortalId);
                                    if (objFile == null)
                                    {
                                        this.EditorAreaCSS = providerControl.StaticCSSFile;
                                    }
                                    else
                                    {
                                        this.EditorAreaCSS = parentModule.PortalSettings.HomeDirectory + objFile.Folder + objFile.FileName;
                                    }
                                }
                                else
                                {
                                    this.EditorAreaCSS = myurl;
                                }
                            }
                            else
                            {
                                this.EditorAreaCSS = providerControl.StaticCSSFile;
                            }

                            break;
                    }
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Styles .css mode)", exc));
            }

            try
            {
                sel = GetFCKSetting("FSW");
                // Force Width
                if (sel.Trim() != "")
                {
                    try
                    {
                        providerControl.ForceWidth = Unit.Parse(sel);
                        this.Width = providerControl.ForceWidth;
                    }
                    catch (Exception ex)
                    {
                    }
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Custom Width)", exc));
            }

            try
            {
                sel = GetFCKSetting("FSH");
                // Force Height
                if (sel.Trim() != "")
                {
                    try
                    {
                        providerControl.ForceHeight = Unit.Parse(sel);
                        this.Height = providerControl.ForceHeight;
                    }
                    catch (Exception ex)
                    {
                    }
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Custom height)", exc));
            }

            try
            {
                sel = GetFCKSetting("ZFC");
                // Font Colors
                if (sel.Trim() != "")
                {
                    this.FontColors = sel;
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Font colors)", exc));
            }

            try
            {
                sel = GetFCKSetting("ZFN");
                // Font Names
                if (sel.Trim() != "")
                {
                    this.FontNames = sel;
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Font Names)", exc));
            }

            try
            {
                sel = GetFCKSetting("ZFF");
                // Font Formats
                if (sel.Trim() != "")
                {
                    this.FontFormats = sel;
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Font formats)", exc));
            }

            try
            {
                sel = GetFCKSetting("ZFS");
                // Font Sizes
                if (sel.Trim() != "")
                {
                    this.FontSizes = sel;
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading FCK setting (Font sizes)", exc));
            }
        }

        private string GetFCKTemplateValue(string pPart, string pName, string pType)
        {
            string tfile = providerControl.ProviderPath.TrimEnd('/') + "/FCKTemplates/" + pType + "/" + pName + "/TemplateData.resx";
            return "" + SharpContent.Services.Localization.Localization.GetString(pPart, tfile);
        }



        #endregion

    }
}
