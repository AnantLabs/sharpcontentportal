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
using SharpContent.Common.Utilities;
using SharpContent.Entities.Modules;
using SharpContent.Entities.Portals;
using SharpContent.Entities.Users;
using SharpContent.Security;
using SharpContent.Services.Exceptions;
using SharpContent.Services.Localization;
using SharpContent.Services.Log.EventLog;
using SharpContent.Services.Mail;
using Globals=SharpContent.Common.Globals;
using SharpContent.Security.Membership;
using System.Globalization;

namespace SharpContent.Modules.Admin.PortalManagement
{
    public partial class Signup : PortalModuleBase
    {
        /// <summary>
        /// Page_Load runs when the control is loaded.
        /// </summary>
        /// <history>
        /// 	[cnurse]	5/10/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        protected void Page_Load( Object sender, EventArgs e )
        {
            try
            {
                // ensure portal signup is allowed
                if( ( PortalSettings.ActiveTab.ParentId != PortalSettings.SuperTabId || UserInfo.IsSuperUser == false ) && Convert.ToString( Globals.HostSettings["DemoSignup"] ) != "Y" )
                {
                    Response.Redirect( Globals.NavigateURL( "Access Denied" ), true );
                }

                if( ! Page.IsPostBack )
                {
                    string strFolder = Globals.HostMapPath;
                    if( Directory.Exists( strFolder ) )
                    {
                        // admin.template and a portal template are required at minimum
                        string[] fileEntries = Directory.GetFiles( strFolder, "*.template" );
                        lblMessage.Text = Localization.GetString( "AdminMissing", this.LocalResourceFile );
                        cmdUpdate.Enabled = false;

                        for( int i = 0; i < fileEntries.Length; i++ )
                        {
                            string strFileName = fileEntries[i];
                            if( Path.GetFileNameWithoutExtension( strFileName ) == "admin" )
                            {
                                lblMessage.Text = "";
                                cmdUpdate.Enabled = true;
                            }
                            else
                            {
                                cboTemplate.Items.Add( Path.GetFileNameWithoutExtension( strFileName ) );
                            }
                        }

                        if( cboTemplate.Items.Count == 0 )
                        {
                            lblMessage.Text = Localization.GetString( "PortalMissing", this.LocalResourceFile );
                            cmdUpdate.Enabled = false;
                        }
                        cboTemplate.Items.Insert( 0, new ListItem( Localization.GetString( "None_Specified" ), "-1" ) );
                        cboTemplate.SelectedIndex = 0;
                    }

                    if( PortalSettings.ActiveTab.ParentId == PortalSettings.SuperTabId )
                    {
                        rowType.Visible = true;
                        optType.SelectedValue = "P";
                    }
                    else
                    {
                        rowType.Visible = false;
                        string strMessage = string.Format(Localization.GetString("DemoMessage", this.LocalResourceFile), Convert.ToString((Convert.ToString(Globals.HostSettings["DemoPeriod"]) != "") ? (" for " + Convert.ToString(Globals.HostSettings["DemoPeriod"]) + " days") : ""), Globals.GetDomainName(Request));
                        lblInstructions.Text = strMessage;
                        btnCustomizeHomeDir.Visible = false;
                    }

                    txtHomeDirectory.Text = "Portals/[PortalID]";
                    txtHomeDirectory.Enabled = false;

                    BindQuestions();
                }
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        /// <summary>
        /// BindQuestions gets the reset questions from the Database and binds them to the DropDown
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// </history>
        private void BindQuestions()
        {
            ArrayList arrQuestions = MembershipController.GetPasswordQuestons(CultureInfo.CurrentUICulture.Name);

            string promptValue = Localization.GetString("GlobalPasswordQuestion");
            cboResetQuestion.Items.Add(new ListItem(promptValue, "0"));

            foreach (PasswordQuestionInfo passwordQuestion in arrQuestions)
            {
                cboResetQuestion.Items.Add(new ListItem(passwordQuestion.Text, passwordQuestion.Id.ToString()));
            }
        }

        /// <summary>
        /// cmdCancel_Click runs when the Cancel button is clicked
        /// </summary>
        /// <history>
        /// 	[cnurse]	5/10/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        protected void cmdCancel_Click( object sender, EventArgs e )
        {
            try
            {
                Response.Redirect( Globals.GetPortalDomainName( PortalAlias.HTTPAlias, Request, true ), true );
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        /// <summary>
        /// cmdUpdate_Click runs when the Update button is clicked
        /// </summary>
        /// <history>
        /// 	[cnurse]	5/10/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        protected void cmdUpdate_Click( Object sender, EventArgs e )
        {
            if( Page.IsValid )
            {
                try
                {
                    bool child;
                    string message = String.Empty;
                    string portalAlias;
                    int counter;
                    string serverPath;
                    
                    string childPath = String.Empty;

                    PortalController portalController = new PortalController();
                    PortalSecurity security = new PortalSecurity();

                    // check template validity
                    ArrayList messages = new ArrayList();
                    string schemaFilename = Server.MapPath( "admin/Portal/portal.template.xsd" );
                    string xmlFilename = Globals.HostMapPath + cboTemplate.SelectedItem.Text + ".template";
                    PortalTemplateValidator xval = new PortalTemplateValidator();
                    if( ! xval.Validate( xmlFilename, schemaFilename ) )
                    {
                        message = Localization.GetString( "InvalidTemplate", this.LocalResourceFile );
                        lblMessage.Text = string.Format( message, cboTemplate.SelectedItem.Text + ".template" );
                        messages.AddRange( xval.Errors );
                        lstResults.Visible = true;
                        lstResults.DataSource = messages;
                        lstResults.DataBind();
                        return;
                    }

                    //Set Portal Name
                    txtPortalName.Text = txtPortalName.Text.ToLower();
                    txtPortalName.Text = txtPortalName.Text.Replace("http://", "");

                    //Validate Portal Name
                    if( PortalSettings.ActiveTab.ParentId != PortalSettings.SuperTabId )
                    {
                        child = true;

                        // child portal
                        for( counter = 1; counter <= txtPortalName.Text.Length; counter++ )
                        {
                            if( "abcdefghijklmnopqrstuvwxyz0123456789-".IndexOf(txtPortalName.Text.Substring(counter, 1 )) == 0 )
                            {
                                message += "<br>" + Localization.GetString( "InvalidName", this.LocalResourceFile );
                            }
                        }

                        portalAlias = txtPortalName.Text;
                    }
                    else
                    {
                        child = optType.SelectedValue == "C";

                        if( child )
                        {
                            portalAlias = txtPortalName.Text.Substring(txtPortalName.Text.LastIndexOf("/") + 1);
                        }
                        else
                        {
                            portalAlias = txtPortalName.Text;
                        }

                        string strValidChars = "abcdefghijklmnopqrstuvwxyz0123456789-";
                        if( ! child )
                        {
                            strValidChars += "./:";
                        }

                        for( counter = 1; counter <= portalAlias.Length; counter++ )
                        {
                            if (strValidChars.IndexOf(portalAlias.Substring(counter - 1, 1)) == 0)
                            {
                                message += "<br>" + Localization.GetString( "InvalidName", this.LocalResourceFile );
                            }
                        }
                    }

                    //Validate Password
                    if( txtPassword.Text != txtConfirm.Text )
                    {
                        message += "<br>" + Localization.GetString( "InvalidPassword", this.LocalResourceFile );
                    }

                    serverPath = Globals.GetAbsoluteServerPath( Request );

                    //Set Portal Alias for Child Portals
                    if( message == "" )
                    {
                        if( child )
                        {
                            childPath = serverPath + portalAlias;

                            if( Directory.Exists( childPath ) )
                            {
                                message = Localization.GetString( "ChildExists", this.LocalResourceFile );
                            }
                            else
                            {
                                if( PortalSettings.ActiveTab.ParentId != PortalSettings.SuperTabId )
                                {
                                    portalAlias = Globals.GetDomainName( Request ) + "/" + portalAlias;
                                }
                                else
                                {
                                    portalAlias = txtPortalName.Text;
                                }
                            }
                        }
                    }

                    //Get Home Directory
                    string HomeDir;
                    if( txtHomeDirectory.Text != "Portals/[PortalID]" )
                    {
                        HomeDir = txtHomeDirectory.Text;
                    }
                    else
                    {
                        HomeDir = "";
                    }

                    //Create Portal
                    if( message == "" )
                    {
                        string strTemplateFile = cboTemplate.SelectedItem.Text + ".template";

                        //Attempt to create the portal
                        int intPortalId;
                        try
                        {
                            intPortalId = portalController.CreatePortal( txtTitle.Text, txtFirstName.Text, txtLastName.Text, txtUsername.Text, security.Encrypt( Convert.ToString( Globals.HostSettings["EncryptionKey"] ), txtPassword.Text ), cboResetQuestion.SelectedValue, txtAnswer.Text, txtEmail.Text, txtDescription.Text, txtKeyWords.Text, Globals.HostMapPath, strTemplateFile, HomeDir, portalAlias, serverPath, childPath, child );
                        }
                        catch( Exception ex )
                        {
                            intPortalId = Null.NullInteger;
                            message = ex.Message;
                        }

                        if( intPortalId != - 1 )
                        {
                            // notification
                            UserInfo objUser = UserController.GetUserByName( intPortalId, txtUsername.Text, false );

                            //Create a Portal Settings object for the new Portal
                            PortalSettings newSettings = new PortalSettings();
                            newSettings.PortalAlias = new PortalAliasInfo();
                            newSettings.PortalAlias.HTTPAlias = portalAlias;
                            newSettings.PortalId = intPortalId;
                            string webUrl = Globals.AddHTTP( portalAlias );

                            try
                            {
                                if( PortalSettings.ActiveTab.ParentId != PortalSettings.SuperTabId )
                                {
                                    Mail.SendMail( PortalSettings.Email, txtEmail.Text, PortalSettings.Email + ";" + Convert.ToString( PortalSettings.HostSettings["HostEmail"] ), Localization.GetSystemMessage( newSettings, "EMAIL_PORTAL_SIGNUP_SUBJECT", objUser ), Localization.GetSystemMessage( newSettings, "EMAIL_PORTAL_SIGNUP_BODY", objUser ), "", "", "", "", "", "" );
                                }
                                else
                                {
                                    Mail.SendMail( Convert.ToString( PortalSettings.HostSettings["HostEmail"] ), txtEmail.Text, Convert.ToString( PortalSettings.HostSettings["HostEmail"] ), Localization.GetSystemMessage( newSettings, "EMAIL_PORTAL_SIGNUP_SUBJECT", objUser ), Localization.GetSystemMessage( newSettings, "EMAIL_PORTAL_SIGNUP_BODY", objUser ), "", "", "", "", "", "" );
                                }
                            }
                            catch( Exception )
                            {
                                message = string.Format( Localization.GetString( "SendMail.Error", this.LocalResourceFile ), webUrl, null );
                            }

                            EventLogController objEventLog = new EventLogController();
                            objEventLog.AddLog( portalController.GetPortal( intPortalId ), PortalSettings, UserId, "", EventLogController.EventLogType.PORTAL_CREATED );

                            // Redirect to this new site
                            if( message == Null.NullString )
                            {
                                Response.Redirect( webUrl, true );
                            }
                        }
                    }

                    lblMessage.Text = "<br>" + message + "<br><br>";
                }
                catch( Exception exc ) //Module failed to load
                {
                    Exceptions.ProcessModuleLoadException( this, exc );
                }
            }
        }

        /// <summary>
        /// optType_SelectedIndexChanged runs when the Portal Type is changed
        /// </summary>
        /// <history>
        /// 	[cnurse]	5/10/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        protected void optType_SelectedIndexChanged( object sender, EventArgs e )
        {
            try
            {
                if( optType.SelectedValue == "C" )
                {
                    txtPortalName.Text = Globals.GetDomainName( Request ) + "/";
                }
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        protected void btnCustomizeHomeDir_Click( Object sender, EventArgs e )
        {
            try
            {
                if( txtHomeDirectory.Enabled )
                {
                    btnCustomizeHomeDir.Text = Localization.GetString( "Customize", LocalResourceFile );
                    txtHomeDirectory.Text = "Portals/[PortalID]";
                    txtHomeDirectory.Enabled = false;
                }
                else
                {
                    btnCustomizeHomeDir.Text = Localization.GetString( "AutoGenerate", LocalResourceFile );
                    txtHomeDirectory.Text = "";
                    txtHomeDirectory.Enabled = true;
                }
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        protected void cboTemplate_SelectedIndexChanged( Object sender, EventArgs e )
        {
            try
            {
                if( cboTemplate.SelectedIndex > 0 )
                {
                    string filename = Globals.HostMapPath + cboTemplate.SelectedItem.Text + ".template";
                    XmlDocument xmldoc = new XmlDocument();
                    XmlNode node;
                    xmldoc.Load( filename );
                    node = xmldoc.SelectSingleNode( "//portal/description" );
                    if( node != null && !String.IsNullOrEmpty(node.InnerXml) )
                    {
                        lblTemplateDescription.Visible = true;
                        lblTemplateDescription.Text = Server.HtmlDecode( node.InnerXml );
                    }
                    else
                    {
                        lblTemplateDescription.Visible = false;
                    }
                }
                else
                {
                    lblTemplateDescription.Visible = false;
                }
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }


    }
}