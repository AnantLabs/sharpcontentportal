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
using SharpContent.Services.Exceptions;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System;
using System.Text.RegularExpressions;

namespace SharpContent.HtmlEditor.FckHtmlEditorProvider
{

    public partial class FckImageGallery : FckGalleryBase
    {
        //Inherits System.Web.UI.Page

        protected DataList lstContent;
        protected bool CanWriteThisFolder = false;
        protected bool CanReadThisFolder = false;
        protected string FileFilter;
        protected Label lblError;
        protected TextBox txtCreateFolder;
        protected Button cmdCreateFolderButton;
        protected string mLastError = "";
        protected string title = "";

        private void Page_Load(object sender, System.EventArgs e)
        {
            switch (GalleryType)
            {
                case "image":
                    FileFilter = "" + objProvider.Attributes["ImageAllowedFileTypes"];
                    Title = PortalSettings.PortalName + " > " + SharpContent.Services.Localization.Localization.GetString("ImageGallery.Text", DSLocalResourceFile);
                    break;
                case "flash":
                    FileFilter = "" + objProvider.Attributes["FlashAllowedFileTypes"];
                    title = PortalSettings.PortalName + " > " + SharpContent.Services.Localization.Localization.GetString("FlashGallery.Text", DSLocalResourceFile);
                    break;
                default:
                    throw new Exception("Gallery type not implemented");
                    break;
            }

            if (mCommand == "FileUpload")
            {
                this.UploadNewFile();
                return; // TODO: might not be correct. Was : Exit Sub
            }

            string strColumns = GetFCKTemplateValue("Item.Columns", mTheme, mType);
            if (strColumns != "" && Globals.IsNumeric(strColumns))
            {
                mColumns = Convert.ToInt32(strColumns);
            }


            if (!Page.IsPostBack)
            {
                // Do nothing.
            }            
            else  //Load objects list
            {
                //Custom events?
                string eventArgName = "" + Page.Request.Form["__EVENTARGUMENT"];
                if (eventArgName.Substring(0, 3).ToLower() == "fck")
                {
                    ExecuteFCKCustomEvents(eventArgName);
                }
            }
            InitializeReadWriteAccess();
            RenderFCKTeplate();
            LoadData();
            //Let's load the css file for this theme
            ManageStyleSheets();
        }

        private void InitializeReadWriteAccess()
        {
            try
            {
                string strDirectory = Server.MapPath(SharpContent.Common.Globals.ResolveUrl("~/" + CurrentFolder));
                if (System.IO.Directory.Exists(strDirectory))
                {
                    if (PortalSettings.ActiveTab.ParentId == PortalSettings.SuperTabId)
                    {
                        strDirectory = strDirectory.Substring(SharpContent.Common.Globals.HostMapPath.Length);
                    }
                    else
                    {
                        strDirectory = strDirectory.Substring(PortalSettings.HomeDirectoryMapPath.Length);
                    }
                    string rolesWrite = FileSystemUtils.GetRoles(this.ValidateLastSlash(strDirectory.Replace("\\", "/").TrimEnd('/')), PortalSettings.PortalId, "WRITE");
                    CanWriteThisFolder = PortalSecurity.IsInRoles(rolesWrite);
                    string rolesRead = FileSystemUtils.GetRoles(this.ValidateLastSlash(strDirectory.Replace("\\", "/").TrimEnd('/')), PortalSettings.PortalId, "READ");
                    CanReadThisFolder = PortalSecurity.IsInRoles(rolesRead);
                }
                else
                {
                    CanWriteThisFolder = false;
                    CanReadThisFolder = false;
                }
            }

            catch (Exception ex)
            {
                //wrong directory
                CanWriteThisFolder = false;
                CanReadThisFolder = false;
            }
        }

        private void BindObjectList()
        {
            if (lstContent != null)
            {
                lstContent.DataSource = mObjectsList;
                lstContent.DataBind();
            }

        }


        protected override void RenderFCKTeplate()
        {

            string MasterTemplate = GetFCKTemplateValue("Master.Template", mTheme, mType);
            //System.Text.RegularExpressions.Regex. r;
            System.Text.RegularExpressions.MatchCollection mList = System.Text.RegularExpressions.Regex.Matches(MasterTemplate, "\\[FCK:(?<TokenName>\\w+)\\]", System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            int LastPos = 0;
            string hText;

            //Show debug info
            if (_FCKDebugMode)
            {
                //Let's build some info for debug
                System.Text.StringBuilder dmText = new System.Text.StringBuilder();
                dmText.Append("<br><br>Debug info (English only):");
                dmText.Append("<br>Application Path=" + SharpContent.Common.Globals.ApplicationPath);
                dmText.Append("<br>Root folder=" + RootFolder);
                dmText.Append("<br>Sub folder=" + this.CurrentObjectFolder);
                dmText.Append("<br>Current folder=" + CurrentFolder);
                dmText.Append("<br>Server folder=" + Server.MapPath(SharpContent.Common.Globals.ResolveUrl("~/" + CurrentFolder)));
                dmText.Append("<br>Folder permissions=" + (string)(this.CanReadThisFolder ? "READ" : "") + " " + (string)(this.CanWriteThisFolder ? "WRITE" : ""));
                dmText.Append("<br>File Filter=" + this.FileFilter);
                if ((PortalSettings != null))
                {
                    dmText.Append("<br>Request.IsAuthenticated=" + Request.IsAuthenticated);
                    dmText.Append("<br>PortalSettings.PortalId=" + PortalSettings.PortalId.ToString());
                    dmText.Append("<br>PortalSettings.PortalName=" + PortalSettings.PortalName);
                    dmText.Append("<br>PortalSettings.TabId=" + PortalSettings.ActiveTab.TabID);
                    dmText.Append("<br>PortalSettings.tabName=" + PortalSettings.ActiveTab.TabName);
                    dmText.Append("<br>PortalSettings.PortalAlias.HTTPAlias=" + PortalSettings.PortalAlias.HTTPAlias);
                }
                dmText.Append("<br>Theme=" + this.Theme);

                PortalSecurity objSecurity = new PortalSecurity();

                if ((Request.UrlReferrer != null))
                {
                    string myURLReferrer = objSecurity.InputFilter(Request.UrlReferrer.ToString(), PortalSecurity.FilterFlag.NoScripting | PortalSecurity.FilterFlag.NoMarkup);
                    dmText.Append("<br>Referrer=" + myURLReferrer);
                }
                if ((Request.RawUrl != null))
                {
                    string myRawURL = objSecurity.InputFilter(Request.RawUrl, PortalSecurity.FilterFlag.NoScripting | PortalSecurity.FilterFlag.NoMarkup);
                    dmText.Append("<br>RawURL=" + myRawURL);
                }

                phContent.Controls.Add(new LiteralControl(dmText.ToString()));
            }


            //Parse master template
            for (int i = 0; i <= mList.Count - 1; i++)
            {

                System.Text.RegularExpressions.Group t = mList[i].Groups["TokenName"];
                if ((t != null))
                {
                    hText = MasterTemplate.Substring(LastPos, mList[i].Index - LastPos);
                    phContent.Controls.Add(new LiteralControl(hText));
                    switch (t.Value.ToLower())
                    {
                        case "gallerytitle":
                            switch (mType)
                            {
                                case "image":
                                    hText = SharpContent.Services.Localization.Localization.GetString("ImageGallery.Text", DSLocalResourceFile);
                                    break;
                                case "flash":
                                    hText = SharpContent.Services.Localization.Localization.GetString("FlashGallery.Text", DSLocalResourceFile);
                                    break;
                            }
                            phContent.Controls.Add(new LiteralControl(hText));
                            break;

                        case "currentfolder":
                            phContent.Controls.Add(new LiteralControl(this.CurrentObjectFolder));
                            break;
                        case "currentfolderlabel":
                            phContent.Controls.Add(new LiteralControl(SharpContent.Services.Localization.Localization.GetString("CurrentFolder.Text", DSLocalResourceFile)));
                            break;
                        case "listcontrol":
                            if (lstContent == null)
                            {
                                lstContent = new DataList();
                                lstContent.EnableViewState = false;
                                lstContent.RepeatDirection = RepeatDirection.Horizontal;
                                lstContent.CssClass = GetFCKTemplateValue("ListControl.CssClass", mTheme, mType);
                                lstContent.ItemStyle.CssClass = GetFCKTemplateValue("ListControl.ItemCssClass", mTheme, mType);
                                lstContent.AlternatingItemStyle.CssClass = GetFCKTemplateValue("ListControl.AlternatingItemCssClass", mTheme, mType);
                                lstContent.SeparatorStyle.CssClass = GetFCKTemplateValue("ListControl.SeparatorCssClass", mTheme, mType);


                                lstContent.RepeatColumns = mColumns;
                                lstContent.ItemDataBound += lstContent_ItemDataBound;

                                phContent.Controls.Add(lstContent);
                            }

                            break;

                        case "filecontrol":
                            if (CanWriteThisFolder)
                            {
                                System.Web.UI.HtmlControls.HtmlInputFile uploadctl = new System.Web.UI.HtmlControls.HtmlInputFile();
                                uploadctl.Attributes.Add("class", GetFCKTemplateValue("UploadControl.CssClass", mTheme, mType));
                                phContent.Controls.Add(uploadctl);
                            }

                            break;

                        case "uploadcommandbutton":
                            if (CanWriteThisFolder)
                            {
                                System.Web.UI.WebControls.Button uploadcmd = new System.Web.UI.WebControls.Button();
                                uploadcmd.Text = SharpContent.Services.Localization.Localization.GetString("cmdUpload.Text", DSLocalResourceFile);
                                uploadcmd.CssClass = GetFCKTemplateValue("UploadCommandButton.CssClass", mTheme, mType);
                                uploadcmd.Click += cmdUpload_Click;
                                phContent.Controls.Add(uploadcmd);
                            }

                            break;

                        case "uploadcommandlink":
                            if (CanWriteThisFolder)
                            {
                                System.Web.UI.WebControls.LinkButton uploadlnk = new System.Web.UI.WebControls.LinkButton();
                                uploadlnk.Text = SharpContent.Services.Localization.Localization.GetString("cmdUpload.Text", DSLocalResourceFile);
                                uploadlnk.CssClass = GetFCKTemplateValue("UploadCommandLink.CssClass", mTheme, mType);
                                uploadlnk.Click += cmdUpload_Click;
                                phContent.Controls.Add(uploadlnk);
                            }

                            break;
                        case "newfolderinputbox":
                            if (CanWriteThisFolder)
                            {
                                if (txtCreateFolder == null)
                                {
                                    txtCreateFolder = new TextBox();
                                    phContent.Controls.Add(txtCreateFolder);
                                }
                            }

                            break;

                        case "createfoldercommandbutton":
                            if (CanWriteThisFolder)
                            {
                                if (this.cmdCreateFolderButton == null)
                                {
                                    this.cmdCreateFolderButton = new System.Web.UI.WebControls.Button();
                                    cmdCreateFolderButton.Text = "Create";
                                    cmdCreateFolderButton.Click += cmdCreateFolderButton_Click;
                                    phContent.Controls.Add(cmdCreateFolderButton);
                                }
                            }

                            break;

                        case "errormessagecontrol":
                            if (lblError == null)
                            {
                                lblError = new System.Web.UI.WebControls.Label();
                                lblError.CssClass = GetFCKTemplateValue("ErrorMessage.CssClass", mTheme, mType);
                                phContent.Controls.Add(lblError);
                            }

                            break;
                    }
                    LastPos = mList[i].Index + mList[i].Length;
                }

            }

            hText = MasterTemplate.Substring(LastPos);
            phContent.Controls.Add(new LiteralControl(hText));

        }

        private bool HasSpaceAvailable(long intSize)
        {
            SharpContent.Entities.Portals.PortalController portalDB = new SharpContent.Entities.Portals.PortalController();
            return portalDB.HasSpaceAvailable(this.PortalSettings.PortalId, intSize);
        }



        private void UploadNewFile()
        {
            System.Web.HttpPostedFile oFile = Request.Files["NewFile"];

            string sErrorNumber = "0";
            string sFileName = "";
            string sNewFileName = "";
            string myErrorMessage = "";

            if ((oFile != null))
            {

                // Map the virtual path to the local server path.
                string sServerDir = Server.MapPath(SharpContent.Common.Globals.ResolveUrl("~/" + CurrentFolder)).Replace("/", "\\");
                string strDirectory;
                if (PortalSettings.ActiveTab.ParentId == PortalSettings.SuperTabId)
                {
                    strDirectory = sServerDir.Substring(SharpContent.Common.Globals.HostMapPath.Length);
                }
                else
                {
                    strDirectory = sServerDir.Substring(PortalSettings.HomeDirectoryMapPath.Length);
                }
                string roles = FileSystemUtils.GetRoles(this.ValidateLastSlash(strDirectory.Replace("\\", "/").TrimEnd('/')), PortalSettings.PortalId, "WRITE");
                if (PortalSecurity.IsInRoles(roles))
                {
                    bool mHasSpace = false;


                    SharpContent.Entities.Portals.PortalController portalDB = new SharpContent.Entities.Portals.PortalController();
                    long intSize = oFile.ContentLength;

                    string[] ver = PortalSettings.Version.Split('.');
                    int vermaj = Convert.ToInt32(ver[0]);
                    int vermin = Convert.ToInt32(ver[1]);
                    int verrev = Convert.ToInt32(ver[2]);
                    if (vermaj > 3 | (vermaj == 3 & vermin >= 3))
                    {
                        mHasSpace = this.HasSpaceAvailable(intSize);
                    }
                    else
                    {
                        long mtam = (long)(long)portalDB.GetPortalSpaceUsed(this.PortalSettings.PortalId) + intSize / (long)1000000;
                        if (mtam <= this.PortalSettings.HostSpace)
                        {
                            mHasSpace = true;
                        }
                    }


                    //The following routine is not used any more
                    //Dim mtam As Long = CLng(portalDB.GetPortalSpaceUsedBytes(Me.PortalSettings.PortalId) + intSize / CLng(1000000))
                    //If mtam <= Me.PortalSettings.HostSpace Then
                    //mHasSpace = True
                    //End If

                    if ((mHasSpace | PortalSettings.HostSpace == 0) | (PortalSettings.ActiveTab.ParentId == PortalSettings.SuperTabId))
                    {


                        // Get the uploaded file name.
                        sFileName = System.IO.Path.GetFileName(oFile.FileName);
                        string strExtension = System.IO.Path.GetExtension(sFileName);

                        if (FileFilter != "" && String.Format("," + FileFilter.ToLower()).IndexOf(String.Format("," + strExtension.ToLower())) == -1 && String.Format("," + PortalSettings.HostSettings["FileExtensions"].ToString().ToUpper()).IndexOf(String.Format("," + strExtension.ToUpper())) == -1)
                        {
                            int iCounter = 0;
                            while ((true))
                            {

                                string sFilePath = System.IO.Path.Combine(sServerDir, sFileName);

                                if (System.IO.File.Exists(sFilePath))
                                {

                                    iCounter += 1;
                                    sFileName = System.IO.Path.GetFileNameWithoutExtension(oFile.FileName) + "(" + iCounter.ToString() + ")" + System.IO.Path.GetExtension(oFile.FileName);

                                    sErrorNumber = "201";
                                    sNewFileName = sFileName;
                                }
                                else
                                {
                                    try
                                    {
                                        oFile.SaveAs(sFilePath);
                                        //AddFile(sFilePath, strExtension, oFile.ContentType)

                                        sErrorNumber = "0";
                                    }
                                    catch (Exception ex)
                                    {
                                        sErrorNumber = "202";
                                    }
                                    break; // TODO: might not be correct. Was : Exit While
                                }
                            }
                        }
                        else
                        {
                            sErrorNumber = "202";
                        }
                    }
                    else
                    {
                        sErrorNumber = "1";
                        myErrorMessage = SharpContent.Services.Localization.Localization.GetString("NoSpaceError.Message", DSLocalResourceFile);
                    }
                }
                else
                {
                    sErrorNumber = "203";
                }
            }
            else
            {
                sErrorNumber = "202";
            }
            Response.Clear();

            Response.Write("<script type=\"text/javascript\">");
            Response.Write("window.parent.OnUploadCompleted(" + sErrorNumber + ",'" + SharpContent.Common.Globals.ResolveUrl("~/" + CurrentFolder + sFileName).Replace("'", "\\\\'") + "','" + sNewFileName + "','" + myErrorMessage + "') ;");
            Response.Write("</script>");



            Response.End();
        }

        private void cmdCreateFolderButton_Click(object sender, System.EventArgs e)
        {
            if ((txtCreateFolder != null))
            {
                string strDebug = "Step 0";
                try
                {
                    strDebug = "Step 1";
                    string strDirectory = Server.MapPath(SharpContent.Common.Globals.ResolveUrl("~/" + CurrentFolder)).TrimEnd('\\') + "\\";
                    string strFolder = txtCreateFolder.Text.Trim();
                    if (!System.IO.Directory.Exists(strDirectory + strFolder))
                    {
                        strDebug = "Step 2: Creating " + strDirectory + strFolder + "(addFolder(portalsettings,\"" + strDirectory + "\",\"" + strFolder + "\")";
                        SharpContent.Common.Utilities.FileSystemUtils.AddFolder(PortalSettings, strDirectory, strFolder);


                        // Set Folder permissions
                        string scpCurrentFolder = CurrentFolder.Substring(CurrentFolder.IndexOf("/", CurrentFolder.IndexOf("/") + 1) + 1);
                        strFolder = ValidateLastSlash(scpCurrentFolder + strFolder);
                        scpCurrentFolder = ValidateLastSlash(scpCurrentFolder);

                        strDebug = "Step 3: Reading new folder info (" + strFolder + ")";
                        SharpContent.Services.FileSystem.FolderController fc = new SharpContent.Services.FileSystem.FolderController();
                        SharpContent.Services.FileSystem.FolderInfo f = fc.GetFolder(PortalSettings.PortalId, strFolder);
                        //Dim parent As SharpContent.Services.FileSystem.FolderInfo = fc.GetFolder(PortalSettings.PortalId, scpCurrentFolder)

                        // Set same permissions as parent
                        strDebug = "Step 4: Reading parent folder permissions (" + scpCurrentFolder + ")";
                        SharpContent.Security.Permissions.FolderPermissionController fp = new SharpContent.Security.Permissions.FolderPermissionController();
                        System.Collections.ArrayList arr = new System.Collections.ArrayList();
                        arr = fp.GetFolderPermissionsByFolder(PortalSettings.PortalId, scpCurrentFolder);

                        strDebug = "Step 5: Copy permissions from parent";
                        foreach (SharpContent.Security.Permissions.FolderPermissionInfo fi in arr)
                        {
                            strDebug = "Step 5.1: Copy permissions from parent(FolderID=" + f.FolderID + ", PermissionID=" + fi.PermissionID + ", Folder=" + strFolder + ")";
                            FileSystemUtils.SetFolderPermission(PortalSettings.PortalId, f.FolderID, fi.PermissionID, fi.RoleID, strFolder);
                        }


                        txtCreateFolder.Text = "";
                        strDebug = "Step 5: Reload Data";
                        LoadData();

                    }
                }
                catch (Exception exc)
                {
                    Exceptions.LogException(new Exception(strDebug, exc));
                }
            }
        }





        private void ExecuteFCKCustomEvents(string myEvent)
        {
            string CommandArgument = "";
            mLastError = "";
            if (myEvent.Length > 11)
            {
                CommandArgument = myEvent.Substring(12);
            }

            switch (myEvent.Substring(0, 11).ToLower())
            {
                case "fckfolderdn":
                    CurrentObjectFolder = CurrentObjectFolder + CommandArgument + "/";
                    break;
                //LoadData()
                case "fckfolderup":
                    string imgf = CurrentObjectFolder;
                    if (imgf != "/")
                    {
                        imgf = imgf.TrimEnd('/');
                        imgf = imgf.Substring(0, imgf.LastIndexOf("/") + 1);
                        CurrentObjectFolder = imgf;
                    }

                    break;
                //LoadData()

                case "fckimagedel":
                    break;
                //TODO: Delete image command
                case "fckfolderdel":
                    break;
                //TODO: Delete folder command
                case "fckimageren":
                    break;
                //TODO: Rename image command
                case "fckfolderren":
                    break;
                //TODO: Rename folder command
                case "fckimageedt":
                    break;
                //TODO: Inplace image edit
            }
        }

        private void LoadFoldersData()
        {
            //Get the list of sub-directories
            string[] strDirectories;
            string strTempDir = Server.MapPath(SharpContent.Common.Globals.ResolveUrl("~/" + CurrentFolder));

            if (System.IO.Directory.Exists(strTempDir))
            {

                strDirectories = System.IO.Directory.GetDirectories(strTempDir, "*");

                string strDirectory;
                string roles;
                int i;

                //Parse directories (only adding those we have permission for

                for (i = 0; i <= strDirectories.Length - 1; i++)
                {
                    if (PortalSettings.ActiveTab.ParentId == PortalSettings.SuperTabId)
                    {
                        strDirectory = strDirectories[i].Substring(SharpContent.Common.Globals.HostMapPath.Length).Replace("\\", "/").TrimEnd('/');
                    }
                    else
                    {
                        strDirectory = strDirectories[i].Substring(PortalSettings.HomeDirectoryMapPath.Length).Replace("\\", "/").TrimEnd('/');
                    }



                    roles = FileSystemUtils.GetRoles(ValidateLastSlash(strDirectory), PortalSettings.PortalId, "READ");

                    string strdir;
                    if (strDirectory.LastIndexOf("/") > 0)
                    {
                        strdir = strDirectory.Substring(strDirectory.LastIndexOf("/") + 1);
                    }
                    else
                    {
                        strdir = strDirectory;
                    }
                    if (PortalSecurity.IsInRoles(roles))
                    {
                        mObjectsList.Add(new FCKNormalFolderObject(this, strdir));
                    }
                }
            }
            else
            {
                Exceptions.LogException(new Exception("Error loading FCK gallery folders: " + Server.MapPath(CurrentFolder)));
            }
        }

        private string ValidateLastSlash(string strFolder)
        {
            string[] ver = PortalSettings.Version.Split('.');
            int vermaj = Convert.ToInt32(ver[0]);
            int vermin = Convert.ToInt32(ver[1]);
            int verrev = Convert.ToInt32(ver[2]);
            bool useSlash = false;
            if ((vermaj == 3 & vermin >= 0 & vermin <= 2) | (vermaj == 4 & vermin == 0))
            {
                return strFolder.TrimEnd('/');
            }
            else if ((vermaj == 3 & vermin == 3 & verrev >= 0 & verrev <= 2) | (vermaj == 4 & vermin == 3 & verrev >= 0 & verrev <= 2))
            {
                return strFolder.TrimEnd('/') + "/";
            }
            else
            {
                if (strFolder == "/" | strFolder == "")
                {
                    return "";
                }
                else
                {
                    return strFolder.TrimEnd('/') + "/";
                }

            }
        }

        private void LoadFilesData()
        {
            string[] strFiles;
            string strDirectory = Server.MapPath(SharpContent.Common.Globals.ResolveUrl("~/" + CurrentFolder));
            if (System.IO.Directory.Exists(strDirectory))
            {

                strFiles = System.IO.Directory.GetFiles(strDirectory, "*");

                string strFile;
                string roles;
                //, rolesup As String
                int i;

                int tam;
                if (PortalSettings.ActiveTab.ParentId == PortalSettings.SuperTabId)
                {
                    tam = SharpContent.Common.Globals.HostMapPath.Length;
                    strDirectory = strDirectory.Substring(SharpContent.Common.Globals.HostMapPath.Length).Replace("\\", "/").TrimEnd('/');
                }
                else
                {
                    tam = PortalSettings.HomeDirectoryMapPath.Length;
                    strDirectory = strDirectory.Substring(PortalSettings.HomeDirectoryMapPath.Length).Replace("\\", "/").TrimEnd('/');
                }


                roles = FileSystemUtils.GetRoles(ValidateLastSlash(strDirectory), PortalSettings.PortalId, "READ");
                //rolesup = FileSystemUtils.GetRoles(ValidateLastSlash(strDirectory.Replace("\", "/").TrimEnd("/"c)), PortalSettings.PortalId, "WRITE")


                if (PortalSecurity.IsInRoles(roles))
                {
                    for (i = 0; i <= strFiles.Length - 1; i++)
                    {
                        strFile = System.IO.Path.GetFileName(strFiles[i]);

                        if (FileFilter.IndexOf(System.IO.Path.GetExtension(strFile).TrimStart('.')) > -1)
                        {
                            switch (mType)
                            {
                                case "image":
                                    mObjectsList.Add(new FCKImageObject(this, SharpContent.Common.Globals.ResolveUrl("~/" + CurrentFolder), strFile, strFile));
                                    break;
                                case "flash":
                                    mObjectsList.Add(new FCKFlashObject(this, SharpContent.Common.Globals.ResolveUrl("~/" + CurrentFolder), strFile, strFile));
                                    break;
                            }
                        }
                    }
                }
            }
            else
            {
                Exceptions.LogException(new Exception("Error loading FCK gallery files: " + strDirectory));
            }
        }

        private void LoadData()
        {
            //Clear list
            mObjectsList.Clear();
            mObjectsList.Sort();
            if (this.CurrentObjectFolder != "/")
            {
                //Make the first object as an up folder link
                mObjectsList.Add(new FCKUpFolderObject(this, SharpContent.Services.Localization.Localization.GetString("GoUp.Text", DSLocalResourceFile)));
            }
            LoadFoldersData();
            LoadFilesData();

            BindObjectList();

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
        //    //CODEGEN: This method call is required by the Web Form Designer
        //    //Do not modify it using the code editor.
        //    InitializeComponent();
        //}

        #endregion

        private void lstContent_ItemDataBound(object sender, System.Web.UI.WebControls.DataListItemEventArgs e)
        {
            switch (e.Item.ItemType)
            {
                case ListItemType.Item:
                case ListItemType.AlternatingItem:
                    FckGalleryObject objImage = (FckGalleryObject)e.Item.DataItem;
                    LinkButton h = (LinkButton)e.Item.FindControl("lnkImage");
                    Image i = (Image)e.Item.FindControl("imgImage");
                    Label l = (Label)e.Item.FindControl("lblImage");
                    //Regex myreg;
                    string myTemplate;
                    string mCommand = String.Empty;
                    double s;
                    string ss = String.Empty;
                    string mCompactChars = String.Empty;
                    int mcc;
                    string mCompact;
                    switch (objImage.FCKType)
                    {
                        case FCKObjectType.FCKUpFolder:




                            e.Item.Controls.Clear();
                            string mFolderimage = "" + GetFCKTemplateValue("FolderUp.Image", mTheme, mType);
                            if (mFolderimage == "")
                            {
                                mFolderimage = this.TemplateSourceDirectory + "/images/up.jpg";
                            }
                            else
                            {
                                mFolderimage = this.TemplateSourceDirectory + "/FCKTemplates/" + mType + "/" + mTheme + "/" + mFolderimage;
                            }

                            mCommand = "FCKFolderUP";
                            myTemplate = GetFCKTemplateValue("FolderUp.Template", mTheme, mType);
                            myTemplate = Regex.Replace(myTemplate, "\\[Folder\\:UpCommand\\]", Page.ClientScript.GetPostBackEventReference(this.lstContent, mCommand), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Folder\\:ImageURL\\]", objImage.ClientPath + objImage.FileName, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Folder\\:Name\\]", objImage.FCKName, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:ThumbWidth\\]", objImage.FCKThumbWidth.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:ThumbHeight\\]", objImage.FCKThumbHeight.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Template\\:Path\\]", this.TemplateSourceDirectory + "/FCKTemplates/" + mType + "Browser/" + mTheme + "/", System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            e.Item.Controls.Add(new System.Web.UI.LiteralControl(myTemplate));
                            break;
                        case FCKObjectType.FCKnormalFolder:
                            e.Item.Controls.Clear();

                            mCommand = "FCKFolderDN_" + objImage.FCKName;
                            myTemplate = GetFCKTemplateValue("FolderDn.Template", mTheme, mType);
                            myTemplate = Regex.Replace(myTemplate, "\\[Folder\\:DnCommand\\]", Page.ClientScript.GetPostBackEventReference(this.lstContent, mCommand), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Folder\\:ImageURL\\]", objImage.ClientPath + objImage.FileName, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Folder\\:Name\\]", objImage.FCKName, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:ThumbWidth\\]", objImage.FCKThumbWidth.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:ThumbHeight\\]", objImage.FCKThumbHeight.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Template\\:Path\\]", this.TemplateSourceDirectory + "/FCKTemplates/" + mType + "Browser/" + mTheme + "/", System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                            //h.CommandName = "FCKFolder"
                            //h.CommandArgument = objImage.FCKName


                            e.Item.Controls.Add(new System.Web.UI.LiteralControl(myTemplate));
                            break;

                        case FCKObjectType.FCKImage:
                            e.Item.Controls.Clear();
                            myTemplate = GetFCKTemplateValue("Item.Template", mTheme, mType);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:SelectJS\\]", "OpenFile('" + objImage.ClientPath + objImage.FileName + "');", System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:Name\\]", objImage.FCKName, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:URL\\]", objImage.ClientPath + objImage.FileName, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:Extension\\]", System.IO.Path.GetExtension(objImage.FileName), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:ThumbWidth\\]", objImage.FCKThumbWidth.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:ThumbHeight\\]", objImage.FCKThumbHeight.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Template\\:Path\\]", this.TemplateSourceDirectory + "/FCKTemplates/" + mType + "Browser/" + mTheme + "/", System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            s = objImage.FCKFileSize;
                            ss = "B";
                            if (s >= 1048576)
                            {
                                ss = "Mb";
                                s = s / 1048576;
                            }
                            else if (s >= 1024)
                            {
                                ss = "Kb";
                                s = s / 1024;
                            }

                            s = System.Math.Round(s, 2);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:Size\\]", objImage.FCKWidth.ToString() + "x" + objImage.FCKHeight.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:Width\\]", objImage.FCKWidth.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:Height\\]", objImage.FCKHeight.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:FileSize\\]", s.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:FileSizeUnit\\]", ss, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                            mCompactChars = "" + GetFCKTemplateValue("Item.CompactNameChars", mTheme, mType);
                            mcc = 0;
                            if (mCompactChars != "" && Globals.IsNumeric(mCompactChars))
                            {
                                mcc = int.Parse(mCompactChars);
                            }

                            if (mcc > 0)
                            {
                                if (objImage.FCKName.Length > mcc)
                                {
                                    mCompact = objImage.FCKName.Substring(0, mcc) + "...";
                                }
                                else
                                {
                                    mCompact = objImage.FCKName;
                                }
                            }
                            else
                            {
                                mCompact = objImage.FCKName;
                            }

                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:CompactName\\]", mCompact, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                            e.Item.Controls.Add(new System.Web.UI.LiteralControl(myTemplate));
                            break;
                        case FCKObjectType.FCKFlash:
                            e.Item.Controls.Clear();
                            myTemplate = GetFCKTemplateValue("Item.Template", mTheme, mType);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:SelectJS\\]", "OpenFlashFile('" + objImage.ClientPath + objImage.FileName + "'," + objImage.FCKWidth + "," + objImage.FCKHeight + ");", System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:Name\\]", objImage.FCKName, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:URL\\]", objImage.ClientPath + objImage.FileName, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:Extension\\]", System.IO.Path.GetExtension(objImage.FileName).TrimStart('.'), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:ThumbWidth\\]", objImage.FCKThumbWidth.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:ThumbHeight\\]", objImage.FCKThumbHeight.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Template\\:Path\\]", this.TemplateSourceDirectory + "/FCKTemplates/" + mType + "Browser/" + mTheme + "/", System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            s = objImage.FCKFileSize;
                            ss = "B";
                            if (s >= 1048576)
                            {
                                ss = "Mb";
                                s = s / 1048576;
                            }
                            else if (s >= 1024)
                            {
                                ss = "Kb";
                                s = s / 1024;
                            }

                            s = System.Math.Round(s, 2);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:Size\\]", objImage.FCKWidth.ToString() + "x" + objImage.FCKHeight.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:Width\\]", objImage.FCKWidth.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:Height\\]", objImage.FCKHeight.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:FileSize\\]", s.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:FileSizeUnit\\]", ss, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Flash\\:Version\\]", ((SWFDump)((FCKFlashObject)objImage).FlashInfo).Version, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Flash\\:FrameRate\\]", ((SWFDump)((FCKFlashObject)objImage).FlashInfo).Framerate.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                            myTemplate = Regex.Replace(myTemplate, "\\[Flash\\:FrameCount\\]", ((SWFDump)((FCKFlashObject)objImage).FlashInfo).Framecount.ToString(), System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                            mCompactChars = "" + GetFCKTemplateValue("Item.CompactNameChars", mTheme, mType);
                            mcc = 0;
                            if (mCompactChars != "" && Globals.IsNumeric(mCompactChars))
                            {
                                mcc = int.Parse(mCompactChars);
                            }

                            if (mcc > 0)
                            {
                                if (objImage.FCKName.Length > mcc)
                                {
                                    mCompact = objImage.FCKName.Substring(0, mcc) + "...";
                                }
                                else
                                {
                                    mCompact = objImage.FCKName;
                                }
                            }
                            else
                            {
                                mCompact = objImage.FCKName;
                            }

                            myTemplate = Regex.Replace(myTemplate, "\\[Image\\:CompactName\\]", mCompact, System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                            e.Item.Controls.Add(new System.Web.UI.LiteralControl(myTemplate));
                            break;
                    }
                    break;
            }
        }

        private void cmdUpload_Click(object sender, System.EventArgs e)
        {

            ShowFCKGalleryError("");
            string r = "";
            System.Web.HttpPostedFile txtfile = Request.Files[0];
            if ((txtfile != null) && txtfile.FileName != "")
            {

                string strDirectory = Server.MapPath(SharpContent.Common.Globals.ResolveUrl("~/" + CurrentFolder));
                if (PortalSettings.ActiveTab.ParentId == PortalSettings.SuperTabId)
                {
                    strDirectory = strDirectory.Substring(SharpContent.Common.Globals.HostMapPath.Length);
                }
                else
                {
                    strDirectory = strDirectory.Substring(PortalSettings.HomeDirectoryMapPath.Length);
                }
                string roles = FileSystemUtils.GetRoles(this.ValidateLastSlash(strDirectory.Replace("\\", "/").TrimEnd('/')), PortalSettings.PortalId, "WRITE");
                if (PortalSecurity.IsInRoles(roles))
                {
                    SharpContent.Entities.Portals.PortalController portalDB = new SharpContent.Entities.Portals.PortalController();
                    long intSize = txtfile.ContentLength;
                    bool mHasSpace = false;

                    string[] ver = PortalSettings.Version.Split('.');
                    int vermaj = Convert.ToInt32(ver[0]);
                    int vermin = Convert.ToInt32(ver[1]);
                    int verrev = Convert.ToInt32(ver[2]);
                    if (vermaj > 3 | (vermaj == 3 & vermin >= 3))
                    {
                        mHasSpace = this.HasSpaceAvailable(intSize);
                    }
                    else
                    {
                        long mtam = (long)(long)portalDB.GetPortalSpaceUsed(this.PortalSettings.PortalId) + intSize / (long)1000000;
                        if (mtam <= this.PortalSettings.HostSpace)
                        {
                            mHasSpace = true;
                        }
                    }

                    if ((mHasSpace | PortalSettings.HostSpace == 0) | (PortalSettings.ActiveTab.ParentId == PortalSettings.SuperTabId))
                    {


                        string strExtension = System.IO.Path.GetExtension(txtfile.FileName);
                        string ParentFolderName = Server.MapPath(SharpContent.Common.Globals.ResolveUrl("~/" + CurrentFolder));
                        if (FileFilter != "" && String.Format("," + FileFilter.ToLower()).Replace(",", ",.").IndexOf(String.Format("," + strExtension.ToLower())) > -1 & String.Format("," + PortalSettings.HostSettings["FileExtensions"].ToString().ToUpper()).IndexOf(String.Format("," + strExtension.ToUpper())) == -1)
                        {
                            r = Globals.UploadFile(ParentFolderName.Replace("/", "\\"), txtfile, false);
                        }

                        else
                        {
                            // trying to upload a file not allowed for current filter
                            r = string.Format(SharpContent.Services.Localization.Localization.GetString("UploadError", this.DSLocalResourceFile), FileFilter, strExtension);
                        }
                    }
                }
            }
            if (r != string.Empty)
            {
                ShowFCKGalleryError(r);
            }
            LoadData();
        }

        private void ShowFCKGalleryError(string msg)
        {
            if ((lblError != null))
            {
                lblError.Text = msg;
            }
        }

    }
}

