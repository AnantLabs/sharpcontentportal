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
using System.IO;
using System.Web;
using SharpContent.Entities.Portals;
using SharpContent.Common;
using SharpContent.Framework.Providers;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System;

namespace SharpContent.HtmlEditor.FckHtmlEditorProvider
{

    public class FckHtmlEditorProvider : SharpContent.Modules.HTMLEditorProvider.HtmlEditorProvider
    {

        #region " Private members "

        //Define some Helper objects
        private PortalSettings ps;
        private FckEditorControl cntlFck;
        //Private MyCtl As FckCustomEditorWrapper

        //Private configuration container
        private const string ProviderType = "htmlEditor";
        private ProviderConfiguration _providerConfiguration = ProviderConfiguration.GetProviderConfiguration(ProviderType);

        //Private common members
        private string _providerPath;
        private string _RootImageDirectory;
        private string _ControlID;

        //TODO: Remove some old provate members
        private ArrayList _styles;
        private ArrayList _AdditionalToolbars = new ArrayList();
        private string _spellCheck;

        //Private custom members for custom FCK features
        //----------------------------------------------
        //Display customization
        //Toolbar skins to be available to admin users
        private string _availableToolbarSkins;
        //Default toolbar used if no custom values
        private string _defaultToolbarSkin;
        //Available toolbar definitions
        private string _availableToolbarSets;
        //Default toolbar definition if no custom values
        private string _defaultToolbarSet;

        //Default skin used for the image gallery
        private string _defaultImageGallerySkin;
        //Path used to get the gallery page
        private string _ImageGalleryPath;
        //Default wrapper to upload images
        private string _ImageUploadPath;

        //Default skin used for the flash gallery
        private string _defaultFlashGallerySkin;
        //Path used to get the gallery page
        private string _FlashGalleryPath;
        //Default wrapper to upload flash files
        private string _FlashUploadPath;

        //Default skin used for the link gallery
        private string _defaultLinksGallerySkin;
        private string _LinksGalleryPath;

        //dynamic xml file containing style definitions
        private string _DynamicStylesGeneratorPath;
        //Static xml file containing style definitions
        private string _StaticStylesFile;
        //Default mode for xml styles list: Static|Dynamic
        private string _StylesDefaultMode;

        //Default css file containing the editor area css classes
        private string _DynamicCSSGeneratorPath;
        private string _StaticCSSFile;
        private string _CSSDefaultMode;

        //Sets your editor using the source code (jscript) instead of the compiled one
        private bool _UseFCKSource;
        //Sets your provider to show some additional information for debbuging
        private bool _FCKDebugMode;
        //Enables your editor to use additional configurations for security reasons
        private bool _EnhancedSecurityDefault;

        //Path to the fckconfig.js file
        private string _CustomConfigurationPath;
        //path to a custom fckconfig file when the enhanced security is enabled
        private string _SecureConfigurationPath;
        private string _ImageFileFilter;

        private Unit _ForceWidth;
        private Unit _ForceHeight;

        private string _customOptionsDialog;

        private string _optionsOpenMode;

        #endregion

        #region " Provider methods "

        public FckHtmlEditorProvider()
        {
            ps = SharpContent.Entities.Portals.PortalController.GetCurrentPortalSettings();
            // Read the configuration specific information for this provider
            Provider objProvider = (Provider)_providerConfiguration.Providers[_providerConfiguration.DefaultProvider];
            if ((objProvider != null))
            {

                _providerPath = "" + objProvider.Attributes["providerPath"];
                _providerPath = Globals.ResolveUrl(_providerPath.Replace("\\", "/"));
                if (!_providerPath.EndsWith("/"))
                {
                    _providerPath += "/";
                }

                //Read custom provider attributes
                _spellCheck = "" + objProvider.Attributes["spellCheck"];
                _availableToolbarSkins = "" + objProvider.Attributes["AvailableToolbarSkins"];
                _defaultToolbarSkin = "" + objProvider.Attributes["DefaultToolbarSkin"];
                _availableToolbarSets = "" + objProvider.Attributes["AvailableToolBarSets"];
                _defaultToolbarSet = "" + objProvider.Attributes["DefaultToolbarSet"];
                _FCKDebugMode = Convert.ToBoolean("" + objProvider.Attributes["FCKDebugMode"]);
                _UseFCKSource = Convert.ToBoolean("" + objProvider.Attributes["UseFCKSource"]);
                _defaultImageGallerySkin = "" + objProvider.Attributes["DefaultImageGallerySkin"];
                _defaultFlashGallerySkin = "" + objProvider.Attributes["DefaultFlashGallerySkin"];
                _defaultLinksGallerySkin = "" + objProvider.Attributes["DefaultLinksGallerySkin"];
                _ImageGalleryPath = "" + objProvider.Attributes["ImageGalleryPath"];
                _ImageUploadPath = "" + objProvider.Attributes["ImageUploadPath"];
                _FlashGalleryPath = "" + objProvider.Attributes["FlashGalleryPath"];
                _FlashUploadPath = "" + objProvider.Attributes["FlashUploadPath"];
                _LinksGalleryPath = "" + objProvider.Attributes["LinksGalleryPath"];

                _StylesDefaultMode = "" + objProvider.Attributes["StylesDefaultMode"];
                _DynamicStylesGeneratorPath = "" + objProvider.Attributes["DynamicStylesGeneratorPath"];
                _StaticStylesFile = "" + objProvider.Attributes["StaticStylesFile"];

                _CSSDefaultMode = "" + objProvider.Attributes["CSSDefaultMode"];
                _DynamicCSSGeneratorPath = "" + objProvider.Attributes["DynamicCSSGeneratorPath"];
                _StaticCSSFile = "" + objProvider.Attributes["StaticCSSFile"];

                _EnhancedSecurityDefault = Convert.ToBoolean("" + objProvider.Attributes["EnhancedSecurityDefault"]);
                _CustomConfigurationPath = "" + objProvider.Attributes["CustomConfigurationPath"];
                _SecureConfigurationPath = "" + objProvider.Attributes["SecureConfigurationPath"];
                _ImageFileFilter = "" + objProvider.Attributes["ImageAllowedFileTypes"];
                _customOptionsDialog = "" + objProvider.Attributes["CustomOptionsDialog"];
                _optionsOpenMode = "" + objProvider.Attributes["OptionsOpenMode"];

            }
        }

        private string ManageFullImagePath(string strHTML)
        {
            string manageFullImagePath = String.Empty;
            //TODO: Review this function to handle all possibilities
            PortalSettings _portalSettings = SharpContent.Entities.Portals.PortalController.GetCurrentPortalSettings();
            string myDomain = Globals.GetDomainName(System.Web.HttpContext.Current.Request);
            string strUploadDirectory = RootImageDirectory;
            int p;
            p = myDomain.ToLower().IndexOf("/");
            if (p != 0)
            {
                myDomain = myDomain.Substring(1, p - 1);
            }
            myDomain = Globals.AddHTTP(myDomain);

            p = strHTML.ToLower().IndexOf(@"src=""");
            while (p != -1)
            {
                manageFullImagePath += strHTML.Substring(0, p + 5);

                strHTML = strHTML.Substring(p + 5);

                // add uploaddirectory if we are linking internally
                string strSRC = strHTML.Substring(0, strHTML.IndexOf(@""""));
                if (strSRC.IndexOf("://") == -1 & strSRC.Substring(0, 1) != "/" & strSRC.IndexOf(strUploadDirectory.Substring(strUploadDirectory.IndexOf("Portals/"))) == -1)
                {

                    strHTML = myDomain + strUploadDirectory + strHTML;
                }
                else if (strSRC.IndexOf("://") == -1)
                {
                    strHTML = myDomain + strHTML;
                }


                p = strHTML.ToLower().IndexOf(@"src=""");
            }
            return manageFullImagePath + strHTML;

        }



        #endregion

        #region " Public Properties "

        public string OptionsOpenMode
        {
            get { return _optionsOpenMode; }
        }

        public string CustomOptionsDialog
        {
            get { return _customOptionsDialog; }
        }

        public string ProviderPath
        {
            get { return _providerPath; }
        }

        public bool IsFCKDebug
        {
            get { return _FCKDebugMode; }
        }

        public string DefaultToolbarSet
        {
            get { return _defaultToolbarSet; }
        }

        public string AvailableToolbarSets
        {
            get { return _availableToolbarSets; }
        }

        public string DefaultImageGallerySkin
        {
            get { return _defaultImageGallerySkin; }
        }

        public string DefaultFlashGallerySkin
        {
            get { return _defaultFlashGallerySkin; }
        }

        public string DefaultLinksGallerySkin
        {
            get { return _defaultLinksGallerySkin; }
        }

        public string ImageGalleryPath
        {
            get { return Globals.ResolveUrl(_ImageGalleryPath); }
        }

        public string ImageUploadPath
        {
            get { return Globals.ResolveUrl(_ImageUploadPath); }
        }

        public string FlashGalleryPath
        {
            get { return Globals.ResolveUrl(_FlashGalleryPath); }
        }

        public string FlashUploadPath
        {
            get { return Globals.ResolveUrl(_FlashUploadPath); }
        }

        public string LinksGalleryPath
        {
            get { return Globals.ResolveUrl(_LinksGalleryPath); }
        }

        public string DynamicStylesGeneratorPath
        {
            get { return Globals.ResolveUrl(_DynamicStylesGeneratorPath); }
        }

        public string StaticStylesFile
        {
            get { return Globals.ResolveUrl(_StaticStylesFile); }
        }

        public string StylesDefaultMode
        {
            get { return this._StylesDefaultMode; }
        }

        public bool EnhancedSecurityDefault
        {
            get { return _EnhancedSecurityDefault; }
        }

        public string CustomConfigurationPath
        {
            get { return Globals.ResolveUrl(_CustomConfigurationPath); }
        }

        public string SecureConfigurationPath
        {
            get { return Globals.ResolveUrl(_SecureConfigurationPath); }
        }

        public string DynamicCSSGeneratorPath
        {
            get { return Globals.ResolveUrl(_DynamicCSSGeneratorPath); }
        }

        public string StaticCSSFile
        {
            get { return Globals.ResolveUrl(_StaticCSSFile); }
        }

        public string CSSDefaultMode
        {
            get { return this._CSSDefaultMode; }
        }

        public override System.Web.UI.Control HtmlEditorControl
        {
            get { return cntlFck; }
        }

        public string ImageFileFilter
        {
            get { return _ImageFileFilter; }
        }

        public override string Text
        {
            get
            {
                string strFullImage = "";
                try
                {
                    strFullImage = cntlFck.GetFCKSetting("IMG");
                    if (strFullImage != "" && Convert.ToBoolean(strFullImage))
                    {
                        return ManageFullImagePath(cntlFck.Value);
                    }
                    else
                    {
                        return cntlFck.Value;
                    }
                }
                catch (Exception ex)
                {

                    return cntlFck.Value;
                }



            }

            set { cntlFck.Value = value; }
        }

        public override string ControlID
        {
            get { return _ControlID; }
            set { _ControlID = value; }
        }

        public override System.Collections.ArrayList AdditionalToolbars
        {
            get { return _AdditionalToolbars; }
            set { _AdditionalToolbars = value; }
        }

        public override string RootImageDirectory
        {
            get
            {
                if (String.IsNullOrEmpty(_RootImageDirectory))
                {
                    //Remove the Application Path from the Home Directory
                    if (Common.Globals.ApplicationPath != "")
                    {
                        //Remove the Application Path from the Home Directory
                        return ps.HomeDirectory.Replace(Common.Globals.ApplicationPath, "");
                    }
                    else
                    {
                        return ps.HomeDirectory;
                    }
                }
                else
                {
                    return _RootImageDirectory;
                }
            }
            set { _RootImageDirectory = value; }
        }

        public override Unit Width
        {
            get { return cntlFck.Width; }
            set
            {
                Unit w;
                if (!_ForceWidth.IsEmpty)
                {
                    w = _ForceWidth;
                }
                else
                {
                    w = value;
                }

                cntlFck.Width = w;
            }
        }


        public override Unit Height
        {
            get { return cntlFck.Height; }
            set
            {
                Unit h;
                if (!_ForceHeight.IsEmpty)
                {
                    h = _ForceHeight;
                }
                else
                {
                    h = value;
                }

                cntlFck.Height = h;

            }
        }

        public Unit ForceWidth
        {
            get { return _ForceWidth; }
            set { _ForceWidth = value; }
        }

        public Unit ForceHeight
        {
            get { return _ForceHeight; }
            set { _ForceHeight = value; }
        }
        #endregion

        #region " Public Methods "
        public override void AddToolbar()
        {
            //Must exist because it exists at the base class
        }

        public override void Initialize()
        {
            //Get current portal settings
            PortalSettings _portalSettings = SharpContent.Entities.Portals.PortalController.GetCurrentPortalSettings();

            //Create a new instance of the FCKEditor and pass it our custom properties
            cntlFck = new FckEditorControl();
            cntlFck.ID = ControlID;
            cntlFck.ProviderControl = this;

            //Specify our wrapper paths and custom values for FCKProperties
            //Default values are applied because we don't know the moduleid/tabmoduleid o read custom options
            //The editor was only created, it was not added to the page yet
            string bpath = this.ProviderPath;
            if (this.EnhancedSecurityDefault)
            {
                cntlFck.CustomConfigurationsPath = this.SecureConfigurationPath;
            }
            else
            {
                cntlFck.CustomConfigurationsPath = this.CustomConfigurationPath;
            }
            cntlFck.BasePath = bpath + "FCKeditor/";

            cntlFck.ImageBrowserURL = this.ImageGalleryPath + "?Type=Image&tabid=" + _portalSettings.ActiveTab.TabID + "&RootFolder=" + RootImageDirectory + "&CurrentFolder=/";
            cntlFck.FlashBrowserURL = this.FlashGalleryPath + "?Type=Flash&tabid=" + _portalSettings.ActiveTab.TabID + "&RootFolder=" + RootImageDirectory + "&CurrentFolder=/";

            cntlFck.ImageUploadURL = this.ImageGalleryPath + "?Type=Image&Command=FileUpload&tabid=" + _portalSettings.ActiveTab.TabID + "&RootFolder=" + RootImageDirectory + "&CurrentFolder=/";
            cntlFck.FlashUploadURL = this.FlashGalleryPath + "?Type=Flash&Command=FileUpload&tabid=" + _portalSettings.ActiveTab.TabID + "&RootFolder=" + RootImageDirectory + "&CurrentFolder=/";

            cntlFck.ToolbarSet = _defaultToolbarSet;
            cntlFck.LinkBrowserURL = this.LinksGalleryPath + "?tabid=" + _portalSettings.ActiveTab.TabID;

            cntlFck.SkinPath = bpath + "FCKeditor/editor/skins/" + _defaultToolbarSkin + "/";

            //Don´t autodetect language. Use current SCP language
            cntlFck.AutoDetectLanguage = false;
            string langFile = System.Web.HttpContext.Current.Server.MapPath(bpath + "FCKeditor/editor/lang/" + System.Threading.Thread.CurrentThread.CurrentUICulture.Name + ".js");
            //Let's check xx-YY
            if (System.IO.File.Exists(langFile))
            {
                cntlFck.DefaultLanguage = System.IO.Path.GetFileNameWithoutExtension(langFile);
            }
            else
            {
                //Full locale name does not exist as a file, so use language code only
                cntlFck.DefaultLanguage = System.Threading.Thread.CurrentThread.CurrentUICulture.Name.Substring(0, 2);
            }

            cntlFck.FullPage = false;
            cntlFck.ToolbarCanCollapse = true;

            if (this.StylesDefaultMode.ToLower() == "dynamic")
            {
                cntlFck.StylesXmlPath = DynamicStylesGeneratorPath + "?tabid=" + _portalSettings.ActiveTab.TabID;
            }
            else
            {
                cntlFck.StylesXmlPath = StaticStylesFile;
            }

            if (this.CSSDefaultMode.ToLower() == "dynamic")
            {
                cntlFck.EditorAreaCSS = DynamicCSSGeneratorPath + "?tabid=" + _portalSettings.ActiveTab.TabID;
            }
            else
            {
                cntlFck.EditorAreaCSS = StaticCSSFile;
            }

            cntlFck.FCKSource = _UseFCKSource;

            //MyCtl = New FckCustomEditorWrapper '(Me, cntlFck)
            //MyCtl.MyEditCtl = cntlFck
            //MyCtl.MyProviderControl = Me

            //MyCtl.Width = cntlFck.Width
            //MyCtl.Height = cntlFck.Height


        }

        #endregion

    }
}



