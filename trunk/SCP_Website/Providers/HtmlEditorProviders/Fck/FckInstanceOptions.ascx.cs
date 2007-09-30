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
using System.ComponentModel;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using SharpContent.Common;
using SharpContent.Entities.Modules;
using SharpContent.Entities.Portals;
using SharpContent.Framework.Providers;
using SharpContent.Services.Exceptions;
using SharpContent.Services.FileSystem;
using SharpContent.Services.Mail;
using SharpContent.UI.Skins;
using SharpContent.UI.WebControls;
using System.Collections;
using System.Text;

namespace SharpContent.HtmlEditor.FckHtmlEditorProvider
{

    public partial class FckInstanceOptions : SharpContent.Entities.Modules.PortalModuleBase
    {
        protected SharpContent.Entities.Portals.PortalSettings ps;
        private ProviderConfiguration _providerConfiguration = ProviderConfiguration.GetProviderConfiguration(ProviderType);
        private const string ProviderType = "htmlEditor";
        private string _availableToolbarSkins;
        private string _defaultToolbarSkin;
        private string _availableToolbarSets;
        private string _defaultToolbarSet;
        private bool _FCKDebugMode;
        private string _defaultImageGallerySkin;
        private string _defaultFlashGallerySkin;
        private string _defaultLinksGallerySkin;
        private string _StyleExclusions = "";
        private bool _EnhancedSecurityDefault;
        private bool _ShowModuleType;
        protected int ToolbarIdx = 0;
        protected string mInstanceName = "";
        protected string mCtlName = "";


        #region "Event Handlers"

        protected void Page_Load(object sender, System.EventArgs e)
        {
            try
            {
                ps = SharpContent.Common.Globals.GetPortalSettings();
                this.dshThemes.MaxImageUrl = "~/images/plus.gif";
                this.dshThemes.MinImageUrl = "~/images/minus.gif";
                this.dshAvailableStyles.MaxImageUrl = "~/images/plus.gif";
                this.dshAvailableStyles.MinImageUrl = "~/images/minus.gif";
                this.dshEditorAreaCss.MaxImageUrl = "~/images/plus.gif";
                this.dshEditorAreaCss.MinImageUrl = "~/images/minus.gif";
                this.dshOther.MaxImageUrl = "~/images/plus.gif";
                this.dshOther.MinImageUrl = "~/images/minus.gif";
                this.dshToolbarRoles.MaxImageUrl = "~/images/plus.gif";
                this.dshToolbarRoles.MinImageUrl = "~/images/minus.gif";

                ctlURL.FileFilter = "xml";
                ctlUrlCss.FileFilter = "css";

                txtModuleName.Text = this.ModuleConfiguration.ModuleTitle;

                SharpContent.Entities.Modules.Definitions.ModuleDefinitionController dbm = new SharpContent.Entities.Modules.Definitions.ModuleDefinitionController();
                SharpContent.Entities.Modules.Definitions.ModuleDefinitionInfo objm;
                objm = dbm.GetModuleDefinition(this.ModuleConfiguration.ModuleDefID);
                if ((objm != null))
                {
                    txtModuleType.Text = objm.FriendlyName;
                }
                else
                {
                    txtModuleType.Text = SharpContent.Services.Localization.Localization.GetString("NoModuleDefinition.Text", LocalResourceFile);
                }
                if ((UserInfo != null))
                {
                    txtUsername.Text = "[" + UserInfo.Username + "]";
                }
                else
                {
                    txtUsername.Text = SharpContent.Services.Localization.Localization.GetString("NoModuleDefinition.Text", LocalResourceFile);
                }
                if ((Request.QueryString["iname"] != null))
                {
                    this.mInstanceName = Convert.ToString(Request.QueryString["iname"]);
                    txtModuleInstance.Text = this.mInstanceName;
                }
                else
                {
                    txtModuleInstance.Text = SharpContent.Services.Localization.Localization.GetString("NoInstance.Text", LocalResourceFile);
                }
                InitializeCustomData();
            }
            catch (Exception exc)
            {
                Exceptions.LogException(new Exception("Error loading customization control", exc));
            }
        }

        protected void cmdUpdate_Click(object sender, System.EventArgs e)
        {
            try
            {
                string pType = ddlSettingsType.SelectedValue;
                string toolbars = "";
                string nowUseToolbar = "";
                string tval = "";
                foreach (FCKToolbarInfo li in this.FCKToolbarList)
                {
                    tval = li.TBValue.Replace(li.TBName + ":", "");
                    SetFCKModuleSetting(pType, "TBO$" + li.TBName, tval);
                    toolbars += "," + li.TBName;
                    if (tval.Substring(0, 4).ToLower() != "true" & nowUseToolbar == "")
                    {
                        nowUseToolbar = li.TBName.Trim();
                    }
                }
                if (toolbars != "")
                {
                    toolbars = toolbars.Substring(1);
                }
                SetFCKModuleSetting(pType, "TBO", toolbars);
                SetFCKModuleSetting(pType, "TBS", ddlToolbarSkin.SelectedValue);

                SetFCKModuleSetting(pType, "TBE", chkToolbarNotExpanded.Checked.ToString());

                string sel = ddlImageBrowserTheme.SelectedValue;
                SetFCKModuleSetting(pType, "IBS", sel);

                sel = ddlFlashBrowserTheme.SelectedValue;
                SetFCKModuleSetting(pType, "FBS", sel);

                sel = ddlLinkBrowserTheme.SelectedValue;
                SetFCKModuleSetting(pType, "LBS", sel);

                SetFCKModuleSetting(pType, "SEC", chkEnhancedSecurity.Checked.ToString());

                SetFCKModuleSetting(pType, "SDM", rbStyleMode.SelectedValue);
                SetFCKModuleSetting(pType, "SFI", txtStyleFilter.Text.Trim());
                SetFCKModuleSetting(pType, "SCF", ctlURL.Url);

                SetFCKModuleSetting(pType, "CDM", rbCssMode.SelectedValue);
                SetFCKModuleSetting(pType, "CCF", ctlUrlCss.Url);

                SetFCKModuleSetting(pType, "IMG", chkFullImagePath.Checked.ToString());

                SetFCKModuleSetting(pType, "FSW", txtForceWidth.Text);
                SetFCKModuleSetting(pType, "FSH", txtForceHeight.Text);

                SetFCKModuleSetting(pType, "IMF", ddlImageFolder.SelectedValue);


                SetFCKModuleSetting(pType, "ZFC", txtFontColors.Text);
                SetFCKModuleSetting(pType, "ZFN", txtFontNames.Text);
                SetFCKModuleSetting(pType, "ZFF", txtFontFormats.Text);
                SetFCKModuleSetting(pType, "ZFS", txtFontSizes.Text);

                if (pType == "P")
                {

                }


                lblResult.CssClass = "Normal";
                lblResult.Text = string.Format(SharpContent.Services.Localization.Localization.GetString("UpdateSuccess.Text", LocalResourceFile), this.GetLocalizedType(ddlSettingsType.SelectedValue));
            }
            catch (Exception ex)
            {
                lblResult.CssClass = "NormalRed";
                string errMsg = string.Format(SharpContent.Services.Localization.Localization.GetString("UpdateError.Text", LocalResourceFile), this.GetLocalizedType(ddlSettingsType.SelectedValue));
                Exceptions.LogException(new Exception(errMsg, ex));
                lblResult.Text = errMsg + ": " + ex.Message;
            }
        }

        protected void grdToolbars_EditCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
        {
            grdToolbars.EditItemIndex = e.Item.ItemIndex;
            grdToolbars.Columns[1].Visible = false;
            BindToolbarGrid();
            cmdMakeAllUsers.Visible = false;
        }

        protected void grdToolbars_CancelCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
        {
            grdToolbars.EditItemIndex = -1;
            grdToolbars.Columns[1].Visible = true;
            BindToolbarGrid();
            cmdMakeAllUsers.Visible = true;
        }

        protected void cmdCopyFilter_Click(object sender, System.EventArgs e)
        {
            txtStyleFilter.Text = _StyleExclusions;
        }

        protected void grdToolbars_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
        {
            FCKToolbarInfo obj = null;
            CheckBox chkena = null;
            string cRole = String.Empty;
            string strRoles = String.Empty;
            switch (e.Item.ItemType)
            {
                case ListItemType.AlternatingItem:
                case ListItemType.Item:
                    obj = (FCKToolbarInfo)e.Item.DataItem;
                    e.Item.Cells[2].Text = obj.TBName;
                    chkena = (CheckBox)e.Item.Cells[3].Controls[0];
                    string tRoles = String.Empty;
                    strRoles = obj.TBValue;
                    strRoles = strRoles.Replace(obj.TBName + ":", "");
                    if (strRoles != "")
                    {
                        string[] v = strRoles.Split(';');
                        if (v.Length > 0)
                        {
                            chkena.Checked = bool.Parse(v[0]);
                        }
                        if (v.Length > 1)
                        {
                            for (int i = 1; i <= v.Length - 1; i++)
                            {
                                if (v[i] != "")
                                {
                                    cRole = SharpContent.Common.Globals.GetRoleName(Convert.ToInt32(v[i]));
                                    if (cRole != "")
                                    {
                                        tRoles += ", " + cRole;
                                    }
                                }
                            }

                        }
                    }
                    else
                    {
                        chkena.Checked = false;
                    }

                    if (tRoles != "")
                    {
                        tRoles = tRoles.Substring(2);
                    }
                    else
                    {
                        tRoles = SharpContent.Services.Localization.Localization.GetString("NoneRoles.Text", LocalResourceFile);
                    }

                    e.Item.Cells[4].Text = tRoles;
                    break;
                case ListItemType.EditItem:
                    obj = (FCKToolbarInfo)e.Item.DataItem;
                    chkena = (CheckBox)e.Item.Cells[3].Controls[0];
                    CheckBoxList lstroles = (CheckBoxList)e.Item.Cells[4].Controls[0];
                    e.Item.Cells[2].Text = obj.TBName;
                    strRoles = obj.TBValue;
                    strRoles = strRoles.Replace(obj.TBName + ":", "");
                    if (strRoles != "")
                    {
                        string[] v = strRoles.Split(';');
                        if (v.Length > 0)
                        {
                            chkena.Checked = bool.Parse(v[0]);
                        }
                        if (v.Length > 1)
                        {
                            for (int i = 1; i <= v.Length - 1; i++)
                            {
                                if (v[i] != "" && (lstroles.Items.FindByValue(v[i]) != null))
                                {
                                    lstroles.Items.FindByValue(v[i]).Selected = true;
                                }
                            }
                        }
                    }
                    else
                    {
                        chkena.Checked = false;
                    }

                    break;
            }
        }

        protected void grdToolbars_ItemCreated(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
        {
            CheckBox chkena = null;
            switch (e.Item.ItemType)
            {
                case ListItemType.AlternatingItem:
                case ListItemType.Item:
                    LinkButton lnkedit = (LinkButton)e.Item.Cells[0].Controls[0];
                    Image imgedit = new Image();
                    imgedit.ImageUrl = "~/images/edit.gif";
                    imgedit.ToolTip = SharpContent.Services.Localization.Localization.GetString("EditToolbar.Text", LocalResourceFile);
                    lnkedit.Controls.Add(imgedit);

                    if (this.ToolbarIdx > 0)
                    {
                        ImageButton imgup = new ImageButton();
                        imgup.ImageUrl = "~/images/up.gif";
                        imgup.ToolTip = SharpContent.Services.Localization.Localization.GetString("imgToolbarUp.Text", LocalResourceFile);
                        imgup.CommandName = "ToolBarUp";
                        imgup.CausesValidation = false;
                        e.Item.Cells[1].Controls.Add(imgup);
                    }

                    if (this.ToolbarIdx < (this.FCKToolbarList.Count - 1))
                    {
                        ImageButton imgdn = new ImageButton();
                        imgdn.ImageUrl = "~/images/dn.gif";
                        imgdn.ToolTip = SharpContent.Services.Localization.Localization.GetString("imgToolbarDn.Text", LocalResourceFile);
                        imgdn.CommandName = "ToolBarDn";
                        imgdn.CausesValidation = false;
                        e.Item.Cells[1].Controls.Add(imgdn);
                    }

                    chkena = new CheckBox();
                    chkena.Enabled = false;
                    e.Item.Cells[3].Controls.Add(chkena);
                    this.ToolbarIdx += 1;
                    break;
                case ListItemType.EditItem:
                    LinkButton lnkupdate = (LinkButton)e.Item.Cells[0].Controls[0];
                    Image imgupdate = new Image();
                    imgupdate.ImageUrl = "~/images/Checked.gif";
                    imgupdate.ToolTip = SharpContent.Services.Localization.Localization.GetString("UpdateToolbar.Text", LocalResourceFile);
                    lnkupdate.CausesValidation = false;
                    lnkupdate.Controls.Add(imgupdate);

                    LinkButton lnkcancel = (LinkButton)e.Item.Cells[0].Controls[2];
                    Image imgcancel = new Image();
                    imgcancel.ImageUrl = "~/images/Cancel.gif";
                    imgcancel.ToolTip = SharpContent.Services.Localization.Localization.GetString("CancelToolbar.Text", LocalResourceFile);
                    lnkcancel.CausesValidation = false;
                    lnkcancel.Controls.Add(imgcancel);

                    chkena = new CheckBox();
                    e.Item.Cells[3].Controls.Add(chkena);
                    CheckBoxList lstroles = new CheckBoxList();
                    lstroles.RepeatColumns = 2;
                    PopulateRoles(lstroles);
                    e.Item.Cells[4].Controls.Add(lstroles);
                    this.ToolbarIdx += 1;
                    break;
            }
        }

        protected void rbSettingsType_SelectedIndexChanged(object sender, System.EventArgs e)
        {
            LoadFCKSettings(rbSettingsType.SelectedValue);

            ddlSettingsType.ClearSelection();
            ddlSettingsType.Items.FindByValue(rbSettingsType.SelectedValue).Selected = true;

            BindToolbarGrid();
        }

        protected void cmdClear_Click(object sender, System.EventArgs e)
        {
            try
            {
                string myToolbars = this._availableToolbarSets;
                string ptype = ddlSettingsType.SelectedValue;
                SetFCKModuleSetting(ptype, "TBO", "");
                SetFCKModuleSetting(ptype, "TBS", "");
                SetFCKModuleSetting(ptype, "IBS", "");
                SetFCKModuleSetting(ptype, "FBS", "");
                SetFCKModuleSetting(ptype, "LBS", "");
                SetFCKModuleSetting(ptype, "TBE", "");
                SetFCKModuleSetting(ptype, "SEC", "");
                string[] v = myToolbars.Split(',');
                foreach (string mt in v)
                {
                    if (mt != "")
                    {
                        SetFCKModuleSetting(ptype, "TBO$" + mt, "");
                    }

                }
                SetFCKModuleSetting(ptype, "SDM", "");
                SetFCKModuleSetting(ptype, "SFI", "");
                SetFCKModuleSetting(ptype, "SCF", "");

                SetFCKModuleSetting(ptype, "CDM", "");
                SetFCKModuleSetting(ptype, "CCF", "");

                SetFCKModuleSetting(ptype, "IMG", "");

                SetFCKModuleSetting(ptype, "FSW", "");
                SetFCKModuleSetting(ptype, "FSH", "");

                SetFCKModuleSetting(ptype, "IMF", "");

                SetFCKModuleSetting(ptype, "ZFC", "");
                SetFCKModuleSetting(ptype, "ZFN", "");
                SetFCKModuleSetting(ptype, "ZFF", "");
                SetFCKModuleSetting(ptype, "ZFS", "");

                //Ask wrapper to load new settings
                //ctlWrapper.LoadFCKCTLSettings(True)
                //LoadFCKSettings(rbSettingsType.SelectedValue)

                lblResult.CssClass = "Normal";
                lblResult.Text = string.Format(SharpContent.Services.Localization.Localization.GetString("CleanSuccess.Text", LocalResourceFile), this.GetLocalizedType(ddlSettingsType.SelectedValue));
            }
            catch (Exception ex)
            {
                lblResult.CssClass = "NormalRed";
                string errMsg = string.Format(SharpContent.Services.Localization.Localization.GetString("CleanError.Text", LocalResourceFile), this.GetLocalizedType(ddlSettingsType.SelectedValue));
                Exceptions.LogException(new Exception(errMsg, ex));
                lblResult.Text = errMsg + ": " + ex.Message;
            }
        }

        protected void grdToolbars_ItemCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
        {
            ArrayList lst;
            int idx = -1;
            switch (e.CommandName.ToLower())
            {
                case "toolbarup":

                    lst = this.FCKToolbarList;
                    FCKToolbarInfo tbInfo;
                    for (int i = 0; i <= lst.Count - 1; i++)
                    {
                        tbInfo = (FCKToolbarInfo)lst[i];
                        if (tbInfo.TBName == grdToolbars.DataKeys[e.Item.ItemIndex].ToString())
                        {
                            idx = i;
                            break; // TODO: might not be correct. Was : Exit For
                        }
                    }

                    if (idx >= 1)
                    {
                        FCKToolbarInfo tTemp = (FCKToolbarInfo)lst[idx];
                        lst.RemoveAt(idx);
                        lst.Insert(idx - 1, tTemp);
                        this.FCKToolbarList = lst;

                    }

                    BindToolbarGrid();
                    break;
                case "toolbardn":
                    lst = this.FCKToolbarList;
                    for (int i = 0; i <= lst.Count - 1; i++)
                    {
                        if (((FCKToolbarInfo)lst[i]).TBName == Convert.ToString(grdToolbars.DataKeys[e.Item.ItemIndex]))
                        {
                            idx = i;
                            break; // TODO: might not be correct. Was : Exit For
                        }
                    }

                    if (idx < lst.Count - 1)
                    {
                        FCKToolbarInfo tTemp = (FCKToolbarInfo)lst[idx];
                        lst.RemoveAt(idx);
                        lst.Insert(idx + 1, tTemp);
                        this.FCKToolbarList = lst;

                    }

                    BindToolbarGrid();
                    break;
            }
        }

        protected void grdToolbars_UpdateCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
        {
            string tbarname = Convert.ToString(grdToolbars.DataKeys[e.Item.ItemIndex]);
            CheckBox chkena = (CheckBox)e.Item.Cells[3].Controls[0];
            CheckBoxList lstroles = (CheckBoxList)e.Item.Cells[4].Controls[0];
            UpdateCustomToolbar(tbarname, chkena.Checked, lstroles);
            grdToolbars.EditItemIndex = -1;
            grdToolbars.Columns[1].Visible = true;
            BindToolbarGrid();
            cmdMakeAllUsers.Visible = true;
        }

        protected void cmdMakeAllUsers_Click(object sender, System.EventArgs e)
        {
            InsertAllUsersToolbars();
            BindToolbarGrid();
        }

        #endregion

        #region "FCKSettings helper functions"

        private void LoadFCKSettings(string pType)
        {
            string MyKey = "";
            this.grdToolbars.EditItemIndex = -1;
            this.grdToolbars.Columns[1].Visible = true;

            string sel = GetFCKModuleSetting(pType, "TBO");
            if (sel.Trim() == "")
            {
                sel = _availableToolbarSets;
            }

            FillToolbarList(sel, pType);

            sel = GetFCKModuleSetting(pType, "TBS");
            if (sel.Trim() == "")
            {
                sel = _defaultToolbarSkin;
            }
            ddlToolbarSkin.ClearSelection();
            if ((ddlToolbarSkin.Items.FindByText(sel) != null))
            {
                ddlToolbarSkin.Items.FindByText(sel).Selected = true;
            }

            sel = GetFCKModuleSetting(pType, "IBS");
            if (sel == "")
            {
                sel = this._defaultImageGallerySkin;
            }
            ddlImageBrowserTheme.ClearSelection();
            if ((ddlImageBrowserTheme.Items.FindByValue(sel) != null))
            {
                ddlImageBrowserTheme.Items.FindByValue(sel).Selected = true;
            }

            sel = GetFCKModuleSetting(pType, "FBS");
            if (sel == "")
            {
                sel = this._defaultFlashGallerySkin;
            }
            ddlFlashBrowserTheme.ClearSelection();
            if ((ddlFlashBrowserTheme.Items.FindByValue(sel) != null))
            {
                ddlFlashBrowserTheme.Items.FindByValue(sel).Selected = true;
            }

            sel = GetFCKModuleSetting(pType, "LBS");
            if (sel == "")
            {
                sel = this._defaultLinksGallerySkin;
            }
            ddlLinkBrowserTheme.ClearSelection();
            if ((ddlLinkBrowserTheme.Items.FindByValue(sel) != null))
            {
                ddlLinkBrowserTheme.Items.FindByValue(sel).Selected = true;
            }

            sel = GetFCKModuleSetting(pType, "TBE");
            if (sel == "")
            {
                chkToolbarNotExpanded.Checked = false;
            }
            else
            {
                chkToolbarNotExpanded.Checked = bool.Parse(sel);
            }

            sel = GetFCKModuleSetting(pType, "SEC");
            if (sel == "")
            {
                chkEnhancedSecurity.Checked = _EnhancedSecurityDefault;
            }
            else
            {
                chkEnhancedSecurity.Checked = bool.Parse(sel);
            }

            sel = GetFCKModuleSetting(pType, "SDM");
            if (sel == "")
            {
                if ((rbStyleMode.Items.FindByValue("static") != null))
                {
                    rbStyleMode.ClearSelection();
                    rbStyleMode.Items.FindByValue("static").Selected = true;
                }
            }
            else
            {
                if ((rbStyleMode.Items.FindByValue(sel) != null))
                {
                    rbStyleMode.ClearSelection();
                    rbStyleMode.Items.FindByValue(sel).Selected = true;
                }
            }

            sel = GetFCKModuleSetting(pType, "SFI");
            txtStyleFilter.Text = sel;


            sel = GetFCKModuleSetting(pType, "SCF");
            if (sel != "")
            {
                if (sel.Length > 7 && sel.Substring(0, 7).ToLower() == "fileid=")
                {
                    string file = sel.Substring(7);
                    SharpContent.Services.FileSystem.FileController db = new SharpContent.Services.FileSystem.FileController();
                    SharpContent.Services.FileSystem.FileInfo objFile = db.GetFileById(Convert.ToInt32(file), ps.PortalId);
                    sel = objFile.Folder + objFile.FileName;
                }

                ctlURL.Url = sel;
            }




            sel = GetFCKModuleSetting(pType, "CDM");
            if (sel == "")
            {
                if ((rbCssMode.Items.FindByValue("static") != null))
                {
                    rbCssMode.ClearSelection();
                    rbCssMode.Items.FindByValue("static").Selected = true;
                }
            }
            else
            {
                if ((rbCssMode.Items.FindByValue(sel) != null))
                {
                    rbCssMode.ClearSelection();
                    rbCssMode.Items.FindByValue(sel).Selected = true;
                }
            }

            sel = GetFCKModuleSetting(pType, "CCF");
            if (sel != "")
            {
                if (sel.Length > 7 && sel.Substring(0, 7).ToLower() == "fileid=")
                {
                    string file = sel.Substring(7);
                    SharpContent.Services.FileSystem.FileController db = new SharpContent.Services.FileSystem.FileController();
                    SharpContent.Services.FileSystem.FileInfo objFile = db.GetFileById(Convert.ToInt32(file), ps.PortalId);
                    sel = objFile.Folder + objFile.FileName;
                }

                ctlUrlCss.Url = sel;
            }



            sel = GetFCKModuleSetting(pType, "IMG");
            if (sel == "")
            {
                chkFullImagePath.Checked = false;
            }
            else
            {
                chkFullImagePath.Checked = Convert.ToBoolean(sel);
            }

            txtForceWidth.Text = GetFCKModuleSetting(pType, "FSW");
            txtForceHeight.Text = GetFCKModuleSetting(pType, "FSH");

            sel = GetFCKModuleSetting(pType, "IMF");
            if (sel != "")
            {
                if ((ddlImageFolder.Items.FindByValue(sel) != null))
                {
                    ddlImageFolder.ClearSelection();
                    ddlImageFolder.Items.FindByValue(sel).Selected = true;
                }
            }

            sel = GetFCKModuleSetting(pType, "ZFC");
            // Font Colors
            if (sel.Trim() != "")
            {
                txtFontColors.Text = sel;
            }

            sel = GetFCKModuleSetting(pType, "ZFN");
            // Font Names
            if (sel.Trim() != "")
            {
                txtFontNames.Text = sel;
            }

            sel = GetFCKModuleSetting(pType, "ZFF");
            // Font Formats
            if (sel.Trim() != "")
            {
                txtFontFormats.Text = sel;
            }

            sel = GetFCKModuleSetting(pType, "ZFS");
            // Font Sizes
            if (sel.Trim() != "")
            {
                txtFontSizes.Text = sel;
            }
        }

        public void SetFCKModuleSetting(string pType, string pName, string pValue)
        {
            string strKey = GetFCKModuleSettingKey(pType, pName);
            switch (pType)
            {
                case "I":
                case "M":
                    if (TabModuleId > 0)
                    {
                        SharpContent.Entities.Modules.ModuleController db = new SharpContent.Entities.Modules.ModuleController();
                        db.UpdateTabModuleSetting(TabModuleId, strKey, pValue);
                        //Update current value for its use while current thread active
                        Settings[strKey] = pValue;
                    }
                    else
                    {
                        strKey = "PROF#" + ps.PortalId.ToString() + "#" + strKey;
                        SharpContent.Entities.Host.HostSettingsController db = new SharpContent.Entities.Host.HostSettingsController();
                        db.UpdateHostSetting(strKey, pValue);
                        //Update current value for its use while current thread active
                        ps.HostSettings[strKey] = pValue;
                    }

                    break;

                case "P":
                    SharpContent.Entities.Host.HostSettingsController hostSettingsController = new SharpContent.Entities.Host.HostSettingsController();
                    hostSettingsController.UpdateHostSetting(strKey, pValue);
                    //Update current value for its use while current thread active
                    ps.HostSettings[strKey] = pValue;
                    break;
            }
        }

        public string GetFCKModuleSetting(string pType, string pName)
        {
            string strKey = GetFCKModuleSettingKey(pType, pName);
            string strValue = "";
            switch (pType)
            {
                case "I":
                case "M":
                    if (TabModuleId > 0)
                    {
                        strValue = "" + Convert.ToString(Settings[strKey]);
                    }
                    else
                    {
                        strKey = "PROF#" + ps.PortalId.ToString() + "#" + strKey;
                        strValue = "" + Convert.ToString(ps.HostSettings[strKey]);
                    }

                    break;
                case "P":
                    strValue = "" + Convert.ToString(ps.HostSettings[strKey]);
                    break;
            }
            return strValue;
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
                        string ctl = "" + System.Web.HttpContext.Current.Request.QueryString["ctl"];
                        if (ctl == "")
                        {
                            ctl = "#!!!!";
                        }
                        strKey += "#" + ctl + "#" + this.mInstanceName;
                    }

                    break;
                case "P":
                    strKey = "SCPFCKP#" + ps.PortalId.ToString() + "#" + pName;
                    break;
            }

            return strKey;
        }

        #endregion

        #region "Databinding"

        private void InitializeCustomData()
        {
            try
            {
                //Dim LoadData As String = "" & Convert.ToString(viewstate("FCKADMINOPTIONSSHOW"))
                //If LoadData <> "YES" Then
                Provider objProvider = (Provider)_providerConfiguration.Providers[_providerConfiguration.DefaultProvider];
                _availableToolbarSkins = "" + objProvider.Attributes["AvailableToolbarSkins"];
                _defaultToolbarSkin = "" + objProvider.Attributes["DefaultToolbarSkin"];
                _availableToolbarSets = "" + objProvider.Attributes["AvailableToolBarSets"];
                _defaultToolbarSet = "" + objProvider.Attributes["DefaultToolbarSet"];
                _FCKDebugMode = Convert.ToBoolean(objProvider.Attributes["FCKDebugMode"]);
                _defaultImageGallerySkin = "" + objProvider.Attributes["DefaultImageGallerySkin"];
                _defaultFlashGallerySkin = "" + objProvider.Attributes["DefaultFlashGallerySkin"];
                _defaultLinksGallerySkin = "" + objProvider.Attributes["DefaultLinksGallerySkin"];
                _StyleExclusions = "" + objProvider.Attributes["DynamicStylesGeneratorFilter"];
                _EnhancedSecurityDefault = Convert.ToBoolean("" + objProvider.Attributes["EnhancedSecurityDefault"]);
                if (("" + objProvider.Attributes["ShowModuleType"]).ToLower().Trim() == "false")
                {
                    _ShowModuleType = false;
                }
                else
                {
                    _ShowModuleType = true;
                }

                this.lblModuleType.Visible = _ShowModuleType;
                this.txtModuleType.Visible = _ShowModuleType;

                if (_availableToolbarSets == "")
                {
                    _availableToolbarSets = _defaultToolbarSet;
                }
                if (_availableToolbarSkins == "")
                {
                    _availableToolbarSkins = _defaultToolbarSkin;
                }
                string IsLoaded = "" + Convert.ToString(ViewState["FCKADMINOPTIONSLOADED"]);
                if (IsLoaded != "YES")
                {
                    PopulateFolders();

                    FillDDL(ddlToolbarSkin, _availableToolbarSkins);
                    LoadImageBrowserThemes(ddlImageBrowserTheme);
                    LoadFlashBrowserThemes(ddlFlashBrowserTheme);
                    LoadLinkBrowserThemes(ddlLinkBrowserTheme);

                    LoadFCKSettings(rbSettingsType.SelectedValue);

                    BindToolbarGrid();

                    ViewState["FCKADMINOPTIONSLOADED"] = "YES";
                }
                cmdUpdate.Attributes["onClick"] = "return confirm('" + SharpContent.Services.Localization.Localization.GetString("confirmUpdate.Text", LocalResourceFile) + "');";
                cmdClear.Attributes["onClick"] = "return confirm('" + SharpContent.Services.Localization.Localization.GetString("confirmClear.Text", LocalResourceFile) + "');";
            }
            //End If
            catch (Exception exc)
            {
                Exceptions.LogException(exc);
            }
        }

        private void PopulateRoles(CheckBoxList chkroles)
        {
            chkroles.Items.Clear();
            SharpContent.Security.Roles.RoleController roleDB = new SharpContent.Security.Roles.RoleController();
            ArrayList rolelist = roleDB.GetPortalRoles(this.PortalId);
            ListItem li;
            foreach (SharpContent.Security.Roles.RoleInfo myRole in rolelist)
            {
                li = new ListItem();
                li.Text = myRole.RoleName;
                li.Value = myRole.RoleID.ToString();
                chkroles.Items.Add(li);
            }
            li = new ListItem();
            li.Value = SharpContent.Common.Globals.glbRoleAllUsers;
            li.Text = SharpContent.Common.Globals.glbRoleAllUsersName;
            chkroles.Items.Insert(0, li);
            li = new ListItem();
            li.Value = SharpContent.Common.Globals.glbRoleUnauthUser;
            li.Text = SharpContent.Common.Globals.glbRoleUnauthUserName;
            chkroles.Items.Insert(0, li);
        }

        private void FillLST(ListBox pddl, string pList, string pType)
        {
            string[] lst = pList.Replace(";", ",").Split(',');
            pddl.Items.Clear();
            string tval = "";
            foreach (string s in lst)
            {
                tval = GetFCKModuleSetting(pType, "TBO$" + s);
                pddl.Items.Add(new ListItem(s, s + ":" + tval));
            }
        }

        private void FillToolbarList(string pList, string pType)
        {
            string[] lst = pList.Replace(";", ",").Split(',');
            string tval = "";
            ArrayList MyLst = new ArrayList();
            foreach (string s in lst)
            {
                tval = GetFCKModuleSetting(pType, "TBO$" + s);
                FCKToolbarInfo o = new FCKToolbarInfo();
                o.TBName = s;
                if (tval == "")
                {
                    tval = "false;" + SharpContent.Common.Globals.glbRoleAllUsers;
                }
                o.TBValue = s + ":" + tval;
                MyLst.Add(o);
            }
            this.FCKToolbarList = MyLst;
        }

        private void PopulateFolders()
        {
            SharpContent.Services.FileSystem.FolderController db = new SharpContent.Services.FileSystem.FolderController();
            ArrayList fLst = db.GetFoldersByPortal(PortalId);
            ddlImageFolder.Items.Clear();
            ddlImageFolder.Items.Add(new ListItem(SharpContent.Services.Localization.Localization.GetString("UseDefault.Text", this.LocalResourceFile), "-1"));
            string rootStr = SharpContent.Services.Localization.Localization.GetString("RootFolder.Text", this.LocalResourceFile);
            foreach (SharpContent.Services.FileSystem.FolderInfo f in fLst)
            {
                ListItem li = new ListItem();
                li.Value = f.FolderID.ToString();
                if (f.FolderPath == "")
                {
                    li.Text = rootStr;
                }
                else
                {
                    li.Text = rootStr + "/" + f.FolderPath;
                }
                ddlImageFolder.Items.Add(li);
            }
        }

        private void BindToolbarGrid()
        {
            this.ToolbarIdx = 0;
            SharpContent.Services.Localization.Localization.LocalizeDataGrid(ref grdToolbars, LocalResourceFile);
            grdToolbars.DataSource = this.FCKToolbarList;
            grdToolbars.DataKeyField = "TBName";
            grdToolbars.DataBind();
        }

        private void FillDDL(DropDownList pddl, string pList)
        {
            string[] lst = pList.Replace(";", ",").Split(',');
            pddl.Items.Clear();
            foreach (string s in lst)
            {
                pddl.Items.Add(s);
            }
        }

        private void LoadImageBrowserThemes(DropDownList pDdl)
        {
            string[] ff = System.IO.Directory.GetDirectories(Server.MapPath(this.TemplateSourceDirectory + "/FCKTemplates/ImageBrowser/"));
            pDdl.Items.Clear();
            foreach (string f in ff)
            {
                string s = System.IO.Path.GetFileNameWithoutExtension(f);
                pDdl.Items.Add(s);
            }
        }

        private void LoadFlashBrowserThemes(DropDownList pDdl)
        {
            string[] ff = System.IO.Directory.GetDirectories(Server.MapPath(this.TemplateSourceDirectory + "/FCKTemplates/FlashBrowser/"));
            pDdl.Items.Clear();
            foreach (string f in ff)
            {
                string s = System.IO.Path.GetFileNameWithoutExtension(f);
                pDdl.Items.Add(s);
            }
        }

        private void LoadLinkBrowserThemes(DropDownList pDdl)
        {
            string[] ff = System.IO.Directory.GetDirectories(Server.MapPath(this.TemplateSourceDirectory + "/FCKTemplates/LinkBrowser/"));
            pDdl.Items.Clear();
            foreach (string f in ff)
            {
                string s = System.IO.Path.GetFileNameWithoutExtension(f);
                pDdl.Items.Add(s);
            }
        }

        #endregion
        
        private void UpdateCustomToolbar(string pToolbar, bool chkDisabled, CheckBoxList chkRolesList)
        {

            string strRoles = pToolbar + ":" + chkDisabled.ToString();
            foreach (ListItem li in chkRolesList.Items)
            {
                if (li.Selected)
                {
                    strRoles += ";" + li.Value;
                }
            }
            ArrayList MyList = this.FCKToolbarList;

            foreach (FCKToolbarInfo o in MyList)
            {
                if (o.TBName == pToolbar)
                {
                    o.TBValue = strRoles;
                    break; // TODO: might not be correct. Was : Exit For
                }
            }
            this.FCKToolbarList = MyList;
        }

        [Browsable(false), DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        private System.Collections.ArrayList FCKToolbarList
        {
            get
            {
                //TODO: Create better serialization for this
                ArrayList a = new ArrayList();
                if ((ViewState["FCKToolbarList"] != null))
                {
                    string[] lst = ((string)ViewState["FCKToolbarList"]).Split('#');
                    foreach (string s in lst)
                    {
                        if (s != "")
                        {
                            string[] val = s.Split('=');
                            FCKToolbarInfo o = new FCKToolbarInfo();
                            o.TBName = val[0];
                            o.TBValue = val[1];
                            a.Add(o);
                        }
                    }
                }
                return a;
            }
            set
            {
                StringBuilder str = new StringBuilder();
                foreach (FCKToolbarInfo o in value)
                {
                    str.Append(o.TBName + "=" + o.TBValue + "#");
                }
                ViewState["FCKToolbarList"] = str.ToString();
            }
        }

        [Serializable()]
        public class FCKToolbarInfo
        {
            private string _TBName;
            private string _TBValue;
            public string TBName
            {
                get { return _TBName; }
                set { _TBName = value; }
            }
            public string TBValue
            {
                get { return _TBValue; }
                set { _TBValue = value; }
            }

        }

        private void InsertAllUsersToolbars()
        {
            ArrayList MyList = this.FCKToolbarList;
            foreach (FCKToolbarInfo o in MyList)
            {
                string strRoles = o.TBValue;
                //Check if role has been already added
                if (strRoles.IndexOf(";" + SharpContent.Common.Globals.glbRoleAllUsers) < 0)
                {
                    //Make sure that toolbar is not disabled
                    if (strRoles == (o.TBName + ":"))
                    {
                        strRoles += "false";
                    }
                    else if (strRoles.IndexOf(":true") >= 0)
                    {
                        strRoles = strRoles.Replace(":true", ":false");
                    }
                    strRoles += ";" + SharpContent.Common.Globals.glbRoleAllUsers;
                    o.TBValue = strRoles;
                }

            }
            this.FCKToolbarList = MyList;
        }

        private string GetLocalizedType(string pType)
        {
            string r;
            switch (pType)
            {
                case "I":
                    r = SharpContent.Services.Localization.Localization.GetString("typeInstance.Text", LocalResourceFile);
                    break;
                case "M":
                    r = SharpContent.Services.Localization.Localization.GetString("typeModule.Text", LocalResourceFile);
                    break;
                case "P":
                    r = SharpContent.Services.Localization.Localization.GetString("typePortal.Text", LocalResourceFile);
                    break;
                default:
                    r = pType;
                    break;
            }
            return r;
        }
    }
}
