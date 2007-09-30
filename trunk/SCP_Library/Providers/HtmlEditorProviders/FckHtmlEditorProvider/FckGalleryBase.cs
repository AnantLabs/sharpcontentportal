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
using SharpContent.Framework.Providers;
using System.Web.UI.WebControls;
using SharpContent;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.ComponentModel;
using System.Collections;
using System;
using SharpContent.Services.Exceptions;

namespace SharpContent.HtmlEditor.FckHtmlEditorProvider
{
    public class FckGalleryBase : SharpContent.Framework.PageBase
    {

        //protected string mTheme = "Default";
        protected string mTheme = "";
        protected string mType = "";
        protected string mCommand = "";
        protected int mColumns = 5;
        protected bool _FCKDebugMode;
        protected ProviderConfiguration _providerConfiguration;
        protected const string ProviderType = "htmlEditor";
        public string Title = "";
        protected Provider objProvider;

        protected ArrayList mObjectsList = new ArrayList();

        [Browsable(false), DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public string CurrentObjectFolder
        {
            get
            {
                if (ViewState["CurrentObjectFolder"] == null)
                {
                    ViewState["CurrentObjectFolder"] = "/";
                }
                return ViewState["CurrentObjectFolder"].ToString();
            }
            set { ViewState["CurrentObjectFolder"] = value; }
        }

        [Browsable(false), DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public string RootFolder
        {
            get
            {
                object o = ViewState["RootFolder"];
                if (o == null)
                {
                    return "";
                }
                else
                {
                    return (string)o;
                }
            }
            set { ViewState["RootFolder"] = value; }
        }

        [Browsable(false), DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public string CurrentFolder
        {
            get { return RootFolder + CurrentObjectFolder; }
        }

        [Browsable(false), DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public override string Theme
        {
            get { return mTheme; }
        }

        [Browsable(false), DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public string GalleryType
        {
            get { return mType; }
        }

        [Browsable(false), DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        protected string DSLocalResourceFile
        {
            get
            {
                string fileRoot;
                string[] page = Request.ServerVariables["SCRIPT_NAME"].Split(new String[] { @"/" }, StringSplitOptions.RemoveEmptyEntries);


                fileRoot = this.TemplateSourceDirectory + "/" + Services.Localization.Localization.LocalResourceDirectory + "/" + page[page.GetUpperBound(0)] + ".resx";

                return fileRoot;
            }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            _providerConfiguration = ProviderConfiguration.GetProviderConfiguration(ProviderType);
            objProvider = (Provider)_providerConfiguration.Providers[_providerConfiguration.DefaultProvider];
            if ((objProvider.Attributes["FCKDebugMode"] != null))
            {
                string fckValue = ("" + objProvider.Attributes["FCKDebugMode"]).ToLower();
                if (fckValue == "true" | fckValue == "false")
                {
                    _FCKDebugMode = Convert.ToBoolean(fckValue);
                }
            }
            else
            {
                _FCKDebugMode = false;
            }

            if (Request["Type"] != null)
            {
                mType = Request["Type"].ToLower();
            }
            else
            {
                mType = "";
            }

            if (Request["Command"] != null)
            {
                mCommand = Request["Command"];
            }

            //Let's get the root folder and current relative path
            string rf = String.Empty;

            // ?? in a new .Net 2.0 operator.  String.Empty will be 
            // returned if Request.QueryString["RootFolder"] is null. 
            rf = Request.QueryString["RootFolder"] ?? String.Empty;

            if (rf.EndsWith("/"))
            {
                rf = rf.TrimEnd(new Char[] { '/' });
            }
            if (rf.StartsWith("/"))
            {
                rf = rf.TrimStart(new Char[] { '/' });
            }

            //Have to get rid of application path. This fixes problem with default root directory
            string strAppPath = SharpContent.Common.Globals.ApplicationPath.ToLower().TrimStart(new Char[] { '/' });

            if (strAppPath != "" && rf.ToLower().StartsWith(strAppPath.ToLower()))
            {
                rf = rf.Substring(strAppPath.Length).TrimStart(new Char[] { '/' });
            }
            RootFolder = rf;
            if ((Request.QueryString["CurrentFolder"] != null))
            {
                CurrentObjectFolder = Request.QueryString["CurrentFolder"];
            }
            else
            {
                CurrentObjectFolder = "/";
            }

            //Init default theme (Skin) for gallery
            mTheme = "Default";
            if ((Request["FCKTheme"] != null))
            {
                mTheme = Convert.ToString(Request["FCKTheme"]);
            }

            Response.Cache.SetNoServerCaching();
            Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Response.Cache.SetExpires(new DateTime(1900, 1, 1, 0, 0, 0, 0));

        }

        protected void ManageStyleSheets()
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

                // default style sheet ( required )
                ID = Globals.CreateValidID(Globals.HostPath);
                objLink = new HtmlGenericControl("LINK");
                objLink.ID = ID;
                objLink.Attributes["rel"] = "stylesheet";
                objLink.Attributes["type"] = "text/css";
                objLink.Attributes["href"] = Globals.HostPath + "default.css";
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
                string mCSSfile = this.TemplateSourceDirectory + "/FCKtemplates/" + mType + "Browser/" + mTheme + "/Styles.css";
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
                            objLink = new System.Web.UI.HtmlControls.HtmlGenericControl("LINK");
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

        public string GetFCKTemplateValue(string pPart, string pName, string pObjectType)
        {
            string pType = pObjectType + "Browser";
            string tFolder = this.TemplateSourceDirectory + "/FCKTemplates/" + pType + "/" + pName + "/";
            string r = "";
            string tfile = "";
            if (pPart.ToLower().EndsWith(".template"))
            {
                try
                {
                    tfile = tFolder + pPart + "." + System.Globalization.CultureInfo.CurrentCulture.ToString().ToLower() + ".htm";
                    if (!System.IO.File.Exists(System.Web.HttpContext.Current.Server.MapPath(tfile)))
                    {
                        tfile = tFolder + pPart + ".htm";
                        if (!System.IO.File.Exists(System.Web.HttpContext.Current.Server.MapPath(tfile)))
                        {
                            tfile = "";
                        }
                    }
                    if (tfile != "")
                    {
                        string MyKey = Globals.CreateValidID(tfile);
                        object myData = DataCache.GetCache(MyKey);
                        if (myData == null)
                        {
                            System.IO.StreamReader fs = System.IO.File.OpenText(System.Web.HttpContext.Current.Server.MapPath(tfile));
                            myData = fs.ReadToEnd();
                            fs.Close();
                            Cache.Insert(MyKey, myData, new System.Web.Caching.CacheDependency(System.Web.HttpContext.Current.Server.MapPath(tfile)));
                        }
                        r = Convert.ToString(myData);

                    }
                }
                catch (Exception exc)
                {
                    r = "";
                    Exceptions.LogException(new Exception("Error loading FCKEditor template file: " + tfile, exc));
                }
            }
            else
            {
                try
                {
                    tfile = tFolder + "TemplateData.resx";
                    r = "" + SharpContent.Services.Localization.Localization.GetString(pPart, tfile);
                }
                catch (Exception exc)
                {
                    r = "";
                    Exceptions.LogException(new Exception("Error loading FCKEditor template resource: " + tfile, exc));
                }

            }

            return "" + r;
        }

        protected virtual void RenderFCKTeplate()
        {

        }
    }
}
