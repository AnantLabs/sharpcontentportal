#region SharpContent License
// Sharp Content Portal - http://www.SharpContentPortal.com
// Copyright (c) 2002-2006
// by SharpContent Corporation
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
#endregion
using System;
using System.Collections;
using System.IO;
using System.Web.UI.WebControls;
using System.Xml;
using System.Collections.Generic;
using SharpContent.Common.Utilities;
using SharpContent.Entities.Modules;
using SharpContent.Entities.Portals;
using SharpContent.Entities.Tabs;
using SharpContent.Framework;
using SharpContent.Security;
using SharpContent.Services.Exceptions;
using SharpContent.Services.Localization;
using SharpContent.Services.Log.EventLog;
using SharpContent.UI.Skins;
using SharpContent.UI.Skins.Controls;
using SharpContent.UI.Utilities;
using Calendar=SharpContent.Common.Utilities.Calendar;
using Globals=SharpContent.Common.Globals;

namespace SharpContent.Modules.Admin.Tabs
{
    /// <summary>
    /// The ManageTabs PortalModuleBase is used to manage a Tab/Page
    /// </summary>
    /// <history>
    /// 	[cnurse]	9/10/2004	Updated to reflect design changes for Help, 508 support
    ///                       and localisation
    /// </history>
    public partial class ManageTabs : PortalModuleBase
    {
        private string strAction = "";

        /// <summary>
        /// BindData loads the Controls with Tab Data from the Database
        /// </summary>
        /// <history>
        /// 	[cnurse]	9/10/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        public void BindData()
        {
            TabController objTabs = new TabController();
            TabInfo objTab = objTabs.GetTab( TabId, PortalId, false );

            //Load TabControls
            LoadTabControls( objTab );

            if( objTab != null )
            {
                if( strAction != "copy" )
                {
                    txtTabName.Text = objTab.TabName;
                    txtTitle.Text = objTab.Title;
                    txtDescription.Text = objTab.Description;
                    txtKeyWords.Text = objTab.KeyWords;
                    ctlURL.Url = objTab.Url;
                }
                ctlIcon.Url = objTab.IconFile;
                if( cboTab.Items.FindByValue( objTab.ParentId.ToString() ) != null )
                {
                    cboTab.Items.FindByValue( objTab.ParentId.ToString() ).Selected = true;
                }
                chkHidden.Checked = ! objTab.IsVisible;
                chkDisableLink.Checked = objTab.DisableLink;

                ctlSkin.SkinSrc = objTab.SkinSrc;
                ctlContainer.SkinSrc = objTab.ContainerSrc;

                if( ! Null.IsNull( objTab.StartDate ) )
                {
                    txtStartDate.Text = objTab.StartDate.ToShortDateString();
                }
                if( ! Null.IsNull( objTab.EndDate ) )
                {
                    txtEndDate.Text = objTab.EndDate.ToShortDateString();
                }
                if( objTab.RefreshInterval != Null.NullInteger )
                {
                    txtRefreshInterval.Text = objTab.RefreshInterval.ToString();
                }

                txtPageHeadText.Text = objTab.PageHeadText;
            }

            // copy page options
            cboCopyPage.DataSource = LoadPortalTabs();
            cboCopyPage.DataBind();
            cboCopyPage.Items.Insert( 0, new ListItem( "<" + Localization.GetString( "None_Specified" ) + ">", "-1" ) );
            rowModules.Visible = false;
        }

        /// <summary>
        /// CheckQuota checks whether the Page Quota will be exceeded
        /// </summary>
        /// <history>
        /// 	[cnurse]	11/16/2006	Created
        /// </history>
        private void CheckQuota()
        {

            if (PortalSettings.Pages < PortalSettings.PageQuota | UserInfo.IsSuperUser | PortalSettings.PageQuota == 0)
            {
                cmdUpdate.Enabled = true;
            }
            else
            {
                cmdUpdate.Enabled = false;
                SharpContent.UI.Skins.Skin.AddModuleMessage(this, Localization.GetString("ExceededQuota", this.LocalResourceFile), ModuleMessageType.YellowWarning);
            }

        }

        /// <summary>
        /// InitializeTab loads the Controls with default Tab Data
        /// </summary>
        /// <history>
        /// 	[cnurse]	9/10/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        public void InitializeTab()
        {
            //Load TabControls
            LoadTabControls( null );

            // Populate Tab Names, etc.
            txtTabName.Text = "";
            txtTitle.Text = "";
            txtDescription.Text = "";
            txtKeyWords.Text = "";

            // tab administrators can only create children of the current tab
            if( PortalSecurity.IsInRoles( PortalSettings.AdministratorRoleName ) == false )
            {
                if( cboTab.Items.FindByValue( TabId.ToString() ) != null )
                {
                    cboTab.Items.FindByValue( TabId.ToString() ).Selected = true;
                }
            }
            else
            {
                // select the <None Specified> option
                cboTab.Items[ 0 ].Selected = true;
            }

            // hide the upload new file link until the tab has been saved
            chkHidden.Checked = false;
            chkDisableLink.Checked = false;

            // page template
            cboTemplate.DataSource = LoadTemplates();
            cboTemplate.DataBind();
            cboTemplate.Items.Insert( 0, new ListItem( "<" + Localization.GetString( "None_Specified" ) + ">", "" ) );
            if( cboTemplate.Items.FindByText( Localization.GetString( "DefaultTemplate", this.LocalResourceFile ) ) != null )
            {
                cboTemplate.Items.FindByText( Localization.GetString( "DefaultTemplate", this.LocalResourceFile ) ).Selected = true;
            }
            else
            {
                cboTemplate.SelectedIndex = 0; // none specified
            }

            // copy page options
            cboCopyPage.DataSource = LoadPortalTabs();
            cboCopyPage.DataBind();
            cboCopyPage.Items.Insert( 0, new ListItem( "<" + Localization.GetString( "None_Specified" ) + ">", "-1" ) );
            rowModules.Visible = false;
        }

        /// <summary>
        /// SaveTabData saves the Tab to the Database
        /// </summary>
        /// <param name="action">The action to perform "edit" or "add"</param>
        /// <history>
        /// 	[cnurse]	9/10/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        public int SaveTabData( string action )
        {
            EventLogController objEventLog = new EventLogController();

            string strIcon = ctlIcon.Url;

            TabController objTabs = new TabController();

            TabInfo objTab = new TabInfo();

            objTab.TabID = TabId;
            objTab.PortalID = PortalId;
            objTab.TabName = txtTabName.Text;
            objTab.Title = txtTitle.Text;
            objTab.Description = txtDescription.Text;
            objTab.KeyWords = txtKeyWords.Text;
            objTab.IsVisible = ! chkHidden.Checked;
            objTab.DisableLink = chkDisableLink.Checked;
            objTab.ParentId = int.Parse( cboTab.SelectedItem.Value );
            objTab.IconFile = strIcon;
            objTab.IsDeleted = false;
            objTab.Url = ctlURL.Url;
            objTab.TabPermissions = dgPermissions.Permissions;
            objTab.SkinSrc = ctlSkin.SkinSrc;
            objTab.ContainerSrc = ctlContainer.SkinSrc;
            objTab.TabPath = Globals.GenerateTabPath(objTab.ParentId, objTab.TabName);
            if( !String.IsNullOrEmpty(txtStartDate.Text) )
            {
                objTab.StartDate = Convert.ToDateTime( txtStartDate.Text );
            }
            else
            {
                objTab.StartDate = Null.NullDate;
            }
            if( !String.IsNullOrEmpty(txtEndDate.Text) )
            {
                objTab.EndDate = Convert.ToDateTime( txtEndDate.Text );
            }
            else
            {
                objTab.EndDate = Null.NullDate;
            }
            int refreshInt;
            if( txtRefreshInterval.Text.Length > 0 && Int32.TryParse(txtRefreshInterval.Text, out refreshInt ) )
            {
                objTab.RefreshInterval = Convert.ToInt32( txtRefreshInterval.Text );
            }
            objTab.PageHeadText = txtPageHeadText.Text;

            if( action == "edit" )
            {
                // trap circular tab reference
                if( objTab.TabID != int.Parse( cboTab.SelectedItem.Value ) && ! IsCircularReference( int.Parse( cboTab.SelectedItem.Value ) ) )
                {
                    objTabs.UpdateTab( objTab );
                    objEventLog.AddLog( objTab, PortalSettings, UserId, "", EventLogController.EventLogType.TAB_UPDATED );
                }
            }
            else // add or copy
            {
                objTab.TabID = objTabs.AddTab( objTab );
                objEventLog.AddLog( objTab, PortalSettings, UserId, "", EventLogController.EventLogType.TAB_CREATED );

                if( int.Parse( cboCopyPage.SelectedItem.Value ) != - 1 )
                {
                    ModuleController objModules = new ModuleController();

                    foreach( DataGridItem objDataGridItem in grdModules.Items )
                    {
                        CheckBox chkModule = (CheckBox)objDataGridItem.FindControl( "chkModule" );
                        if( chkModule.Checked )
                        {
                            int intModuleID = Convert.ToInt32( grdModules.DataKeys[ objDataGridItem.ItemIndex ] );
                            //RadioButton optNew = (RadioButton)objDataGridItem.FindControl( "optNew" );
                            RadioButton optCopy = (RadioButton)objDataGridItem.FindControl( "optCopy" );
                            RadioButton optReference = (RadioButton)objDataGridItem.FindControl( "optReference" );
                            TextBox txtCopyTitle = (TextBox)objDataGridItem.FindControl( "txtCopyTitle" );
                            
                            ModuleInfo objModule = objModules.GetModule( intModuleID, Int32.Parse( cboCopyPage.SelectedItem.Value ), false );
                            if( objModule != null )
                            {
                                if( ! optReference.Checked )
                                {
                                    objModule.ModuleID = Null.NullInteger;
                                }

                                objModule.TabID = objTab.TabID;
                                objModule.ModuleTitle = txtCopyTitle.Text;
                                objModule.ModuleID = objModules.AddModule( objModule );

                                if( optCopy.Checked )
                                {
                                    if( !String.IsNullOrEmpty(objModule.BusinessControllerClass) )
                                    {
                                        object objObject = Reflection.CreateObject( objModule.BusinessControllerClass, objModule.BusinessControllerClass );
                                        if( objObject is IPortable )
                                        {
                                            try
                                            {
                                                string Content = Convert.ToString( ( (IPortable)objObject ).ExportModule( intModuleID ) );
                                                if( !String.IsNullOrEmpty(Content) )
                                                {
                                                    ( (IPortable)objObject ).ImportModule( objModule.ModuleID, Content, objModule.Version, UserInfo.UserID );
                                                }
                                            }
                                            catch( Exception exc )
                                            {
                                                // the export/import operation failed
                                                Exceptions.ProcessModuleLoadException( this, exc );
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    // create the page from a template
                    if( cboTemplate.SelectedItem != null )
                    {
                        if( !String.IsNullOrEmpty(cboTemplate.SelectedItem.Value) )
                        {
                            // open the XML file
                            try
                            {
                                XmlDocument xmlDoc = new XmlDocument();
                                xmlDoc.Load( cboTemplate.SelectedItem.Value );
                                PortalController objPortals = new PortalController();
                                objPortals.ParsePanes( xmlDoc.SelectSingleNode( "//portal/tabs/tab/panes" ), objTab.PortalID, objTab.TabID, PortalTemplateModuleAction.Ignore, new Hashtable() );
                            }
                            catch
                            {
                                // error opening page template
                            }
                        }
                    }
                }
            }

            // url tracking
            UrlController objUrls = new UrlController();
            objUrls.UpdateUrl( PortalId, ctlURL.Url, ctlURL.UrlType, 0, Null.NullDate, Null.NullDate, ctlURL.Log, ctlURL.Track, Null.NullInteger, ctlURL.NewWindow );

            return objTab.TabID;
        }

        /// <summary>
        /// Checks if parent tab will cause a circular reference
        /// </summary>
        /// <param name="intTabId">Tabid</param>
        /// <history>
        /// 	[VMasanas]	28/11/2004	Created
        /// </history>
        private bool IsCircularReference( int intTabId )
        {
            if( intTabId != - 1 )
            {
                TabController objTabs = new TabController();
                TabInfo objtab = objTabs.GetTab( intTabId, PortalId, false );

                if( objtab.Level == 0 )
                {
                    return false;
                }
                else
                {
                    if( TabId == objtab.ParentId )
                    {
                        return true;
                    }
                    else
                    {
                        return IsCircularReference( objtab.ParentId );
                    }
                }
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Deletes Tab
        /// </summary>
        /// <param name="tabId">ID of the parent tab</param>
        /// <remarks>
        /// Will delete tab
        /// </remarks>
        /// <history>
        /// 	[VMasanas]	30/09/2004	Created
        ///     [VMasanas]  01/09/2005  A tab will be deleted only if all descendants can be deleted
        /// </history>
        private bool DeleteTab( int tabId )
        {
            bool bDeleted = true;

            if( tabId != PortalSettings.AdminTabId && tabId != PortalSettings.SplashTabId && tabId != PortalSettings.HomeTabId && tabId != PortalSettings.LoginTabId && tabId != PortalSettings.UserTabId )
            {
                TabController objTabs = new TabController();

                ArrayList tabs = Globals.GetPortalTabs(PortalSettings.DesktopTabs, tabId, false, false, false, false, false);

                if( tabs.Count > 0 )
                {
                    TabInfo objTab = objTabs.GetTab( tabId, PortalId, false );
                    if( objTab != null )
                    {
                        //delete child tabs
                        if( DeleteChildTabs( objTab.TabID ) )
                        {
                            objTab.IsDeleted = true;
                            objTabs.UpdateTab( objTab );

                            EventLogController objEventLog = new EventLogController();
                            objEventLog.AddLog( objTab, PortalSettings, UserId, "", EventLogController.EventLogType.TAB_SENT_TO_RECYCLE_BIN );
                        }
                        else
                        {
                            bDeleted = false;
                        }
                    }
                }
                else
                {
                    bDeleted = false;
                }
            }
            else
            {
                bDeleted = false;
            }

            if( ! bDeleted )
            {
                UI.Skins.Skin.AddModuleMessage( this, Localization.GetString( "DeleteSpecialPage", this.LocalResourceFile ), ModuleMessageType.RedError );
            }

            return bDeleted;
        }

        /// <summary>
        /// Deletes child tabs for the given Tab
        /// </summary>
        /// <param name="intTabid">ID of the parent tab</param>
        /// <returns>True is all child tabs could be deleted</returns>
        /// <remarks>
        /// Will delete child tabs recursively
        /// </remarks>
        /// <history>
        /// 	[VMasanas]	30/09/2004	Created
        ///     [VMasanas]  01/09/2005  A tab will be deleted only if all descendants can be deleted
        /// </history>
        private bool DeleteChildTabs( int intTabid )
        {
            TabController objtabs = new TabController();
            ArrayList arrTabs = objtabs.GetTabsByParentId( intTabid, PortalId );

            bool bDeleted = true;

            foreach( TabInfo objtab in arrTabs )
            {
                if( objtab.TabID != PortalSettings.AdminTabId && objtab.TabID != PortalSettings.SplashTabId && objtab.TabID != PortalSettings.HomeTabId && objtab.TabID != PortalSettings.LoginTabId && objtab.TabID != PortalSettings.UserTabId )
                {
                    //delete child tabs
                    if( DeleteChildTabs( objtab.TabID ) )
                    {
                        objtab.IsDeleted = true;
                        objtabs.UpdateTab( objtab );

                        EventLogController objEventLog = new EventLogController();
                        objEventLog.AddLog( objtab, PortalSettings, UserId, "", EventLogController.EventLogType.TAB_SENT_TO_RECYCLE_BIN );
                    }
                    else
                    {
                        //cannot delete tab, stop deleting and exit
                        bDeleted = false;
                        break;
                    }
                }
                else
                {
                    //cannot delete tab, stop deleting and exit
                    bDeleted = false;
                    break;
                }
            }
            

            return bDeleted;
        }

        private void LoadTabControls( TabInfo objTab )
        {
            int currentTabId;

            if( objTab == null )
            {
                currentTabId = - 1;
            }
            else
            {
                currentTabId = objTab.TabID;
            }
            ArrayList arr;
            arr = Globals.GetPortalTabs(PortalSettings.DesktopTabs, currentTabId, true, true, false, true, true);
            cboTab.DataSource = arr;
            cboTab.DataBind();
            // if editing a tab, load tab parent so parent link is not lost
            // parent tab might not be loaded in cbotab if user does not have edit rights on it
            if( ! PortalSecurity.IsInRoles( PortalSettings.AdministratorRoleName ) && objTab != null )
            {
                if( cboTab.Items.FindByValue( objTab.ParentId.ToString() ) == null )
                {
                    TabController objtabs = new TabController();
                    TabInfo objparent = objtabs.GetTab( objTab.ParentId, objTab.PortalID, false );
                    cboTab.Items.Add( new ListItem( objparent.TabName, objparent.TabID.ToString() ) );
                }
            }
        }

        private ArrayList LoadPortalTabs()
        {
            ArrayList arrTabs = new ArrayList();

            ArrayList arrPortalTabs = Globals.GetPortalTabs(PortalSettings.DesktopTabs, false, true);
            foreach( TabInfo objTab in arrPortalTabs )
            {
                if( PortalSecurity.IsInRoles( objTab.AuthorizedRoles ) )
                {
                    arrTabs.Add( objTab );
                }
            }

            return arrTabs;
        }

        private static ArrayList LoadTemplates()
        {
            ArrayList arrTemplates = new ArrayList();

            string[] arrFiles = Directory.GetFiles(Globals.HostMapPath + "Templates\\", "*.page.template");
            foreach( string strFile in arrFiles )
            {
                arrTemplates.Add( new ListItem( Path.GetFileName( strFile ).Replace( ".page.template", "" ), strFile ) );
            }

            return arrTemplates;
        }

        private static ArrayList LoadTabModules( int TabID )
        {
            ModuleController objModules = new ModuleController();
            ArrayList arrModules = new ArrayList();

            Dictionary<int, ModuleInfo> dict = objModules.GetTabModules( TabID );
            foreach( KeyValuePair<int, ModuleInfo> pair in dict )
            {                
                ModuleInfo objModule = pair.Value;
                if (PortalSecurity.IsInRoles(objModule.AuthorizedEditRoles) && objModule.IsDeleted == false && objModule.AllTabs == false)
                {
                    arrModules.Add(objModule);
                }
            }            

            return arrModules;
        }

        /// <summary>
        /// Gets all children tabs where user has edit access
        /// </summary>
        /// <returns>All the childen tabs where current user has edit permission</returns>
        /// <remarks>
        /// To get desired tabs it first selects children tabs (by using the taborder and level) 
        /// and then filters only those where the user has access
        /// </remarks>
        private ArrayList GetEditableTabs()
        {
            ArrayList arr = new ArrayList();
            int i = 0;
            bool Finished = false;

            while (i < PortalSettings.DesktopTabs.Count & !Finished)
            {
                TabInfo objTab = PortalSettings.DesktopTabs[i] as TabInfo;
                if(objTab != null)
                {
                    if (objTab.TabOrder > PortalSettings.ActiveTab.TabOrder)
                    {
                    
                        if (objTab.Level > PortalSettings.ActiveTab.Level)
                        {
                            // we are in a descendant
                            arr.Add(PortalSettings.DesktopTabs[i]);
                        }
                        else
                        {
                            // exit condition
                            Finished = true;
                        }
                    }
                }
                i += 1;
            }

            if (PortalSecurity.IsInRoles(PortalSettings.AdministratorRoleName))
            {
                // shortcut for admins
                return arr;
            }
            else
            {
                // filter tabs where user has access
                return Globals.GetPortalTabs(arr, PortalSettings.ActiveTab.TabID, false, true, false, true, true);
            }

        }

        private void DisplayTabModules()
        {
            switch( cboCopyPage.SelectedIndex )
            {
                case 0:

                    rowModules.Visible = false;
                    break;
                default: // selected tab

                    grdModules.DataSource = LoadTabModules(Int32.Parse( cboCopyPage.SelectedItem.Value ));
                    grdModules.DataBind();
                    rowModules.Visible = true;
                    break;
            }
        }

        /// <summary>
        /// Page_Load runs when the control is loaded
        /// </summary>
                /// <history>
        /// 	[cnurse]	9/10/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        ///     [VMasanas]  9/28/2004   Changed redirect to Access Denied
        /// </history>
        protected void Page_Load( Object sender, EventArgs e )
        {
            try
            {                
                // Verify that the current user has access to edit this module
                if( PortalSecurity.IsInRoles( PortalSettings.AdministratorRoleName ) == false && PortalSecurity.IsInRoles( PortalSettings.ActiveTab.AdministratorRoles.ToString() ) == false )
                {
                    Response.Redirect( Globals.NavigateURL( "Access Denied" ), true );
                }

                if( ( Request.QueryString["action"] != null ) )
                {
                    strAction = Request.QueryString["action"].ToLower();
                }

                //this needs to execute always to the client script code is registred in InvokePopupCal
                cmdStartCalendar.NavigateUrl = Calendar.InvokePopupCal( txtStartDate );
                cmdEndCalendar.NavigateUrl = Calendar.InvokePopupCal( txtEndDate );

                if( Page.IsPostBack == false )
                {
                    //Set the tab id of the permissions grid to the TabId (Note If in add mode
                    //this means that the default permissions inherit from the parent)
                    if( strAction == "edit" || strAction == "delete" )
                    {
                        dgPermissions.TabID = TabId;
                    }
                    else
                    {
                        dgPermissions.TabID = - 1;
                    }

                    ClientAPI.AddButtonConfirm( cmdDelete, Localization.GetString( "DeleteItem" ) );

                    // load the list of files found in the upload directory
                    ctlIcon.ShowFiles = true;
                    ctlIcon.ShowTabs = false;
                    ctlIcon.ShowUrls = false;
                    ctlIcon.Required = false;

                    ctlIcon.ShowLog = false;
                    ctlIcon.ShowNewWindow = false;
                    ctlIcon.ShowTrack = false;
                    ctlIcon.FileFilter = Globals.glbImageFileTypes;
                    ctlIcon.Width = "275px";

                    // tab administrators can only manage their own tab
                    if( PortalSecurity.IsInRoles( PortalSettings.AdministratorRoleName ) == false )
                    {
                        cboTab.Enabled = false;
                    }

                    ctlSkin.Width = "275px";
                    ctlSkin.SkinRoot = SkinInfo.RootSkin;
                    ctlContainer.Width = "275px";
                    ctlContainer.SkinRoot = SkinInfo.RootContainer;

                    ctlURL.Width = "275px";

                    rowCopySkin.Visible = false;
                    rowCopyPerm.Visible = false;

                    switch( strAction )
                    {
                        case "": // add
                            CheckQuota();
                            InitializeTab();
                            cboCopyPage.SelectedIndex = 0;
                            cmdDelete.Visible = false;
                            break;
                        case "edit":
                            rowCopySkin.Visible = true;
                            rowCopyPerm.Visible = true;
                            BindData();
                            rowTemplate.Visible = false;
                            dshCopy.Visible = false;
                            tblCopy.Visible = false;
                            break;
                        case "copy":
                            CheckQuota();
                            BindData();
                            rowTemplate.Visible = false;
                            if( cboCopyPage.Items.FindByValue( TabId.ToString() ) != null )
                            {
                                cboCopyPage.Items.FindByValue( TabId.ToString() ).Selected = true;
                                DisplayTabModules();
                            }
                            cmdDelete.Visible = false;
                            break;
                        case "delete":

                            if( DeleteTab( TabId ) )
                            {
                                Response.Redirect(Globals.AddHTTP(PortalAlias.HTTPAlias), true);
                            }
                            else
                            {
                                strAction = "edit";
                                BindData();
                                rowTemplate.Visible = false;
                                dshCopy.Visible = false;
                                tblCopy.Visible = false;
                            }
                            break;
                    }
                }
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        /// <summary>
        /// cmdCancel_Click runs when the Cancel Button is clicked
        /// </summary>
                /// <history>
        /// 	[cnurse]	9/10/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        protected void cmdCancel_Click( object sender, EventArgs e )
        {
            try
            {
                string strURL = Globals.NavigateURL();

                if( Request.QueryString["returntabid"] != null )
                {
                    // return to admin tab
                    strURL = Globals.NavigateURL( Convert.ToInt32( Request.QueryString["returntabid"] ) );
                }

                Response.Redirect( strURL, true );
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        /// <summary>
        /// cmdUpdate_Click runs when the Update Button is clicked
        /// </summary>
                /// <history>
        /// 	[cnurse]	9/10/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        protected void cmdUpdate_Click( object Sender, EventArgs e )
        {
            try
            {
                if( Page.IsValid )
                {
                    int intTabId = SaveTabData( strAction );

                    string strURL = Globals.NavigateURL( intTabId );

                    if( Request.QueryString["returntabid"] != null )
                    {
                        // return to admin tab
                        strURL = Globals.NavigateURL( Convert.ToInt32( Request.QueryString["returntabid"].ToString() ) );
                    }
                    else
                    {
                        if( !String.IsNullOrEmpty(ctlURL.Url) || chkDisableLink.Checked )
                        {
                            // redirect to current tab if URL was specified ( add or copy )
                            strURL = Globals.NavigateURL( TabId );
                        }
                    }

                    Response.Redirect( strURL, true );
                }
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        /// <summary>
        /// cmdDelete_Click runs when the Delete Button is clicked
        /// </summary>
                /// <history>
        /// 	[cnurse]	9/10/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        ///     [VMasanas]  30/09/2004  When a parent tab is deleted all child are also marked as deleted.
        /// </history>
        protected void cmdDelete_Click( object Sender, EventArgs e )
        {
            try
            {
                if( DeleteTab( TabId ) )
                {
                    string strURL = Globals.GetPortalDomainName(PortalAlias.HTTPAlias, Request, true);

                    if( Request.QueryString["returntabid"] != null )
                    {
                        // return to admin tab
                        strURL = Globals.NavigateURL( Convert.ToInt32( Request.QueryString["returntabid"].ToString() ) );
                    }

                    Response.Redirect( strURL, true );
                }
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        /// <summary>
        /// cmdGoogle_Click runs when the Submit Page to Google  Button is clicked
        /// </summary>
                /// <history>
        /// 	[cnurse]	9/10/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        protected void cmdGoogle_Click( object sender, EventArgs e )
        {
            try
            {
                string strURL = "";
                string strComments = "";

                strComments += txtTitle.Text;
                if( !String.IsNullOrEmpty(txtDescription.Text) )
                {
                    strComments += " " + txtDescription.Text;
                }
                if( !String.IsNullOrEmpty(txtKeyWords.Text) )
                {
                    strComments += " " + txtKeyWords.Text;
                }

                strURL += "http://www.google.com/addurl?q=" + Globals.HTTPPOSTEncode(Globals.AddHTTP(Globals.GetDomainName(Request)) + "/" + Globals.glbDefaultPage + "?tabid=" + TabId);
                strURL += "&dq=" + Globals.HTTPPOSTEncode(strComments);
                strURL += "&submit=Add+URL";

                Response.Redirect( strURL, true );
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }



        protected void cmdCopySkin_Click(object sender, EventArgs e)
        {
            try
            {
                TabController objtabs = new TabController();
                ArrayList arr = GetEditableTabs();

                objtabs.CopyDesignToChildren(arr, ctlSkin.SkinSrc, ctlContainer.SkinSrc);
            }
            catch (Exception ex)
            {
                Exceptions.ProcessModuleLoadException(this, ex);
            }
        }
        protected void cmdCopyPerm_Click(object sender, EventArgs e)
        {
            try
            {
                TabController objtabs = new TabController();
                ArrayList arr = GetEditableTabs();

                objtabs.CopyPermissionsToChildren(arr, dgPermissions.Permissions);
            }
            catch (Exception ex)
            {
                Exceptions.ProcessModuleLoadException(this, ex);
            }
        }

        protected void cboCopyPage_SelectedIndexChanged( object sender, EventArgs e )
        {
            DisplayTabModules();
        }
    }
}