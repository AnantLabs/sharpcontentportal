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
using System.Data;
using System.Web.UI.WebControls;
using SharpContent.Common;
using SharpContent.Common.Utilities;
using SharpContent.Data;
using SharpContent.Entities.Modules;
using SharpContent.Services.Exceptions;
using SharpContent.Services.Localization;

namespace SharpContent.Modules.Admin.SQL
{
    /// <summary>
    /// The SQL PortalModuleBase is used run SQL Scripts on the Database
    /// </summary>
    /// <history>
    /// 	[cnurse]	9/28/2004	Updated to reflect design changes for Help, 508 support
    ///                       and localisation
    /// </history>
    public partial class SQL : PortalModuleBase
    {
        protected Label lblRunAsScript;

        /// <summary>
        /// Page_Load runs when the control is loaded.
        /// </summary>
        /// <history>
        /// 	[cnurse]	9/28/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        ///     [VMasanas]  9/28/2004   Changed redirect to Access Denied
        /// </history>
        protected void Page_Load( Object sender, EventArgs e )
        {
            try
            {
                // Verify that the current user has access to access this page
                if( ! UserInfo.IsSuperUser )
                {
                    Response.Redirect( Globals.NavigateURL( "Access Denied" ), true );
                }
                if( ! Page.IsPostBack )
                {
                    cmdExecute.ToolTip = Localization.GetString( "cmdExecute.ToolTip", this.LocalResourceFile );
                    chkRunAsScript.ToolTip = Localization.GetString( "chkRunAsScript.ToolTip", this.LocalResourceFile );
                }
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        /// <summary>
        /// cmdExecute_Click runs when the Execute button is clicked
        /// </summary>
        /// <history>
        /// 	[cnurse]	9/28/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        protected void cmdExecute_Click( object sender, EventArgs e )
        {
            try
            {
                if( !String.IsNullOrEmpty(txtQuery.Text) )
                {
                    if( chkRunAsScript.Checked )
                    {
                        
                        string strError = Entities.Portals.PortalSettings.ExecuteScript(txtQuery.Text);
                        if (strError == Null.NullString)
                        {
                            lblMessage.Text = Localization.GetString("QuerySuccess", this.LocalResourceFile);
                        }
                        else
                        {
                            lblMessage.Text = strError;
                        }
                    }
                    else
                    {
                        IDataReader dr = DataProvider.Instance().ExecuteSQL( txtQuery.Text );
                        if( dr != null )
                        {
                            grdResults.DataSource = dr;
                            grdResults.DataBind();
                            dr.Close();
                        }
                        else
                        {
                            lblMessage.Text = Localization.GetString( "QueryError", this.LocalResourceFile );
                        }
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