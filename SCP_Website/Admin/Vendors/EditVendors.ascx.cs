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
using System.Web.UI.WebControls;
using SharpContent.Common.Utilities;
using SharpContent.Entities.Modules;
using SharpContent.Entities.Tabs;
using SharpContent.Services.Exceptions;
using SharpContent.Services.Localization;
using SharpContent.Services.Mail;
using SharpContent.Services.Vendors;
using SharpContent.UI.Skins.Controls;
using SharpContent.UI.Utilities;
using Globals=SharpContent.Common.Globals;

namespace SharpContent.Modules.Admin.Vendors
{
    /// <summary>
    /// The EditVendors PortalModuleBase is used to add/edit a Vendor
    /// </summary>
    /// <history>
    /// 	[cnurse]	9/17/2004	Updated to reflect design changes for Help, 508 support
    ///                       and localisation
    /// </history>
    public partial class EditVendors : PortalModuleBase
    {
        public int VendorID = - 1;

        /// <summary>
        /// AddModuleMessage adds a module message
        /// </summary>
        /// <param name="message">The message</param>
        /// <param name="type">The type of message</param>
        /// <history>
        /// 	[cnurse]	08/24/2006
        /// </history>
        private void AddModuleMessage( string message, ModuleMessageType type )
        {
            UI.Skins.Skin.AddModuleMessage( this, Localization.GetString( message, LocalResourceFile ), type );
        }

        /// <summary>
        /// Page_Load runs when the control is loaded
        /// </summary>
        /// <history>
        /// 	[cnurse]	9/17/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        protected void Page_Load( Object sender, EventArgs e )
        {
            try
            {
                TabController objTabs = new TabController();
                
                bool blnBanner = false;
                bool blnSignup = false;

                if( ( Request.QueryString["VendorID"] != null ) )
                {
                    VendorID = int.Parse( Request.QueryString["VendorID"] );
                }

                if( Request.QueryString["ctl"] != null && VendorID == - 1 )
                {
                    blnSignup = true;
                }

                if( Request.QueryString["banner"] != null )
                {
                    blnBanner = true;
                }

                if( Page.IsPostBack == false )
                {
                    ctlLogo.FileFilter = Globals.glbImageFileTypes;

                    addresssVendor.ModuleId = ModuleId;
                    addresssVendor.StartTabIndex = 4;

                    ClientAPI.AddButtonConfirm( cmdDelete, Localization.GetString( "DeleteItem" ) );

                    ClassificationController objClassifications = new ClassificationController();
                    ArrayList Arr = objClassifications.GetVendorClassifications( VendorID );
                    int i;
                    for( i = 0; i <= Arr.Count - 1; i++ )
                    {
                        ListItem lstItem = new ListItem();
                        ClassificationInfo objClassification = (ClassificationInfo)Arr[i];
                        lstItem.Text = objClassification.ClassificationName;
                        lstItem.Value = objClassification.ClassificationId.ToString();
                        lstItem.Selected = objClassification.IsAssociated;
                        lstClassifications.Items.Add( lstItem );
                    }

                    VendorController objVendors = new VendorController();
                    if( VendorID != - 1 )
                    {
                        VendorInfo objVendor;
                        if( PortalSettings.ActiveTab.ParentId == PortalSettings.SuperTabId && UserInfo.IsSuperUser )
                        {
                            //Get Host Vendor
                            objVendor = objVendors.GetVendor( VendorID, Null.NullInteger );
                        }
                        else
                        {
                            //Get Portal Vendor
                            objVendor = objVendors.GetVendor( VendorID, PortalId );
                        }
                        if( objVendor != null )
                        {
                            txtVendorName.Text = objVendor.VendorName;
                            txtFirstName.Text = objVendor.FirstName;
                            txtLastName.Text = objVendor.LastName;
                            ctlLogo.Url = objVendor.LogoFile;
                            addresssVendor.Unit = objVendor.Unit;
                            addresssVendor.Street = objVendor.Street;
                            addresssVendor.City = objVendor.City;
                            addresssVendor.Region = objVendor.Region;
                            addresssVendor.Country = objVendor.Country;
                            addresssVendor.Postal = objVendor.PostalCode;
                            addresssVendor.Telephone = objVendor.Telephone;
                            addresssVendor.Fax = objVendor.Fax;
                            addresssVendor.Cell = objVendor.Cell;
                            txtEmail.Text = objVendor.Email;
                            txtWebsite.Text = objVendor.Website;
                            chkAuthorized.Checked = objVendor.Authorized;
                            txtKeyWords.Text = objVendor.KeyWords;

                            ctlAudit.CreatedByUser = objVendor.CreatedByUser;
                            ctlAudit.CreatedDate = objVendor.CreatedDate.ToString();
                        }

                        // use dispatch method to load modules
                        Banners objBanners;
                        objBanners = (Banners)this.LoadControl( "~" + this.TemplateSourceDirectory.Remove( 0, Globals.ApplicationPath.Length ) + "/Banners.ascx" );
                        objBanners.ID = "/Banners.ascx";
                        objBanners.VendorID = this.VendorID;
                        objBanners.ModuleConfiguration = ModuleConfiguration;
                        divBanners.Controls.Add( objBanners );

                        Affiliates objAffiliates;

                        objAffiliates = (Affiliates)this.LoadControl( "~" + this.TemplateSourceDirectory.Remove( 0, Globals.ApplicationPath.Length ) + "/Affiliates.ascx" );
                        objAffiliates.ID = "/Affiliates.ascx";
                        objAffiliates.VendorID = this.VendorID;
                        objAffiliates.ModuleConfiguration = ModuleConfiguration;
                        divAffiliates.Controls.Add( objAffiliates );
                    }
                    else
                    {
                        chkAuthorized.Checked = true;
                        pnlAudit.Visible = false;
                        cmdDelete.Visible = false;
                        pnlBanners.Visible = false;
                        pnlAffiliates.Visible = false;
                    }

                    if( blnSignup || blnBanner )
                    {
                        rowVendor1.Visible = false;
                        rowVendor2.Visible = false;
                        pnlVendor.Visible = false;
                        cmdDelete.Visible = false;
                        pnlAudit.Visible = false;

                        if( blnBanner )
                        {
                            cmdUpdate.Visible = false;
                        }
                        else
                        {
                            cmdUpdate.Text = "Signup";
                        }
                    }
                    else
                    {
                        TabInfo objTab;
                        if( PortalSettings.ActiveTab.ParentId == PortalSettings.SuperTabId )
                        {
                            objTab = objTabs.GetTabByName( "Vendors", Null.NullInteger );
                        }
                        else
                        {
                            objTab = objTabs.GetTabByName( "Vendors", PortalId );
                        }
                        if( objTab != null )
                        {
                            ViewState["filter"] = Request.QueryString["filter"];
                        }
                    }
                }
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        /// <summary>
        /// cmdCancel_Click runs when the Cancel button is clicked.
        /// </summary>
        /// <history>
        /// 	[cnurse]	9/17/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        protected void cmdCancel_Click( object sender, EventArgs e )
        {
            try
            {
                Response.Redirect( Globals.NavigateURL( this.TabId, Null.NullString, "filter=" + Convert.ToString( ViewState["filter"] ) ), true );
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        /// <summary>
        /// cmdDelete_Click runs when the Delete button is clicked.
        /// </summary>
        /// <history>
        /// 	[cnurse]	9/17/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        protected void cmdDelete_Click( object sender, EventArgs e )
        {
            try
            {
                if( VendorID != - 1 )
                {
                    VendorController objVendors = new VendorController();
                    objVendors.DeleteVendor( VendorID );
                }
                Response.Redirect( Globals.NavigateURL() );
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        /// <summary>
        /// cmdUpdate_Click runs when the Update button is clicked.
        /// </summary>
        /// <history>
        /// 	[cnurse]	9/17/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        protected void cmdUpdate_Click( object sender, EventArgs e )
        {
            try
            {
                if( Page.IsValid )
                {
                    int intPortalID;
                    if( PortalSettings.ActiveTab.ParentId == PortalSettings.SuperTabId )
                    {
                        intPortalID = - 1;
                    }
                    else
                    {
                        intPortalID = PortalId;
                    }

                    VendorController objVendors = new VendorController();
                    VendorInfo objVendor = new VendorInfo();

                    objVendor.PortalId = intPortalID;
                    objVendor.VendorId = VendorID;
                    objVendor.VendorName = txtVendorName.Text;
                    objVendor.Unit = addresssVendor.Unit;
                    objVendor.Street = addresssVendor.Street;
                    objVendor.City = addresssVendor.City;
                    objVendor.Region = addresssVendor.Region;
                    objVendor.Country = addresssVendor.Country;
                    objVendor.PostalCode = addresssVendor.Postal;
                    objVendor.Telephone = addresssVendor.Telephone;
                    objVendor.Fax = addresssVendor.Fax;
                    objVendor.Cell = addresssVendor.Cell;
                    objVendor.Email = txtEmail.Text;
                    objVendor.Website = txtWebsite.Text;
                    objVendor.FirstName = txtFirstName.Text;
                    objVendor.LastName = txtLastName.Text;
                    objVendor.UserName = UserInfo.UserID.ToString();
                    objVendor.LogoFile = ctlLogo.Url;
                    objVendor.KeyWords = txtKeyWords.Text;
                    objVendor.Authorized = chkAuthorized.Checked;

                    if( VendorID == - 1 )
                    {                        
                        try
                        {
                            VendorID = objVendors.AddVendor(objVendor);
                        }
                        catch
                        {
                            AddModuleMessage("ErrorAddVendor", ModuleMessageType.RedError);
                            return;
                        }
                    }
                    else
                    {
                        VendorInfo objVendorCheck = objVendors.GetVendor( VendorID, intPortalID );
                        if( objVendorCheck != null )
                        {
                            objVendors.UpdateVendor( objVendor );
                        }
                        else
                        {
                            Response.Redirect( Globals.NavigateURL() );
                        }
                    }

                    // update vendor classifications
                    ClassificationController objClassifications = new ClassificationController();
                    objClassifications.DeleteVendorClassifications( VendorID );
                    
                    foreach( ListItem lstItem in lstClassifications.Items )
                    {                    
                        if( lstItem.Selected )
                        {
                            objClassifications.AddVendorClassification( VendorID, int.Parse( lstItem.Value ) );
                        }
                    }

                    if( cmdUpdate.Text == "Signup" )
                    {
                        ArrayList Custom = new ArrayList();
                        Custom.Add( DateTime.Now.ToString() );
                        Custom.Add( txtVendorName.Text );
                        Custom.Add( txtFirstName.Text );
                        Custom.Add( txtLastName.Text );
                        Custom.Add( addresssVendor.Unit );
                        Custom.Add( addresssVendor.Street );
                        Custom.Add( addresssVendor.City );
                        Custom.Add( addresssVendor.Region );
                        Custom.Add( addresssVendor.Country );
                        Custom.Add( addresssVendor.Postal );
                        Custom.Add( addresssVendor.Telephone );
                        Custom.Add( addresssVendor.Fax );
                        Custom.Add( addresssVendor.Cell );
                        Custom.Add( txtEmail.Text );
                        Custom.Add( txtWebsite.Text );

                        string strMessage = Mail.SendMail( txtEmail.Text, PortalSettings.Email, "", Localization.GetSystemMessage( PortalSettings, "EMAIL_VENDOR_REGISTRATION_ADMINISTRATOR_SUBJECT" ), Localization.GetSystemMessage( PortalSettings, "EMAIL_VENDOR_REGISTRATION_ADMINISTRATOR_BODY", Localization.GlobalResourceFile, Custom ), "", "", " ", "", "", "" );

                        if( strMessage == "" )
                        {
                            Custom.Clear();
                            Custom.Add( txtFirstName.Text );
                            Custom.Add( txtLastName.Text );

                            strMessage = Mail.SendMail( PortalSettings.Email, txtEmail.Text, "", Localization.GetSystemMessage( PortalSettings, "EMAIL_VENDOR_REGISTRATION_SUBJECT" ), Localization.GetSystemMessage( PortalSettings, "EMAIL_VENDOR_REGISTRATION_BODY", Localization.GlobalResourceFile, Custom ), "", "", " ", "", "", "" );
                        }
                        else
                        {
                            AddModuleMessage( "EmailErrorAdmin", ModuleMessageType.RedError );
                        }

                        if( strMessage == "" )
                        {
                            Response.Redirect( Globals.NavigateURL( this.TabId, Null.NullString, "filter=" + txtVendorName.Text.Substring( 0, 1 ) ), true );
                        }
                        else
                        {
                            AddModuleMessage( "EmailErrorVendor", ModuleMessageType.RedError );
                        }
                    }
                    else
                    {
                        Response.Redirect( Globals.NavigateURL( this.TabId, Null.NullString, "filter=" + Convert.ToString( ViewState["filter"] ) ), true );
                    }
                }
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }
    }
}