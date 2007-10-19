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
using System.Web.Security;
using SharpContent.Common.Utilities;
using SharpContent.Entities.Modules;
using SharpContent.Entities.Users;
using SharpContent.Framework;
using SharpContent.Security;
using SharpContent.Security.Membership;
using SharpContent.Services.Exceptions;

namespace SharpContent.Common.Controls
{
    public partial class Logoff : PageBase
    {
        /// <summary>
        /// Gets the Redirect URL after the user logs out
        /// </summary>
        /// <history>
        /// </history>
        protected string RedirectURL
        {
            get
            {
                string _RedirectURL;

                // check if anonymous users have access to the current page
                if( PortalSettings.ActiveTab.AuthorizedRoles.IndexOf( ";" + Globals.glbRoleAllUsersName + ";" ) != - 1 )
                {
                    // redirect to current page
                    _RedirectURL = Globals.NavigateURL( PortalSettings.ActiveTab.TabID );
                }
                else // redirect to a different page
                {
                    object setting = UserModuleBase.GetSetting( PortalSettings.PortalId, "Redirect_AfterLogout" );

                    if( Convert.ToInt32( setting ) == Null.NullInteger )
                    {
                        if( PortalSettings.HomeTabId != - 1 )
                        {
                            // redirect to portal home page specified
                            _RedirectURL = Globals.NavigateURL( PortalSettings.HomeTabId );
                        }
                        else // redirect to default portal root
                        {
                            _RedirectURL = Globals.GetPortalDomainName(PortalSettings.PortalAlias.HTTPAlias, Request, true) + "/" + Globals.glbDefaultPage;
                        }
                    }
                    else // redirect to after logout page
                    {
                        _RedirectURL = Globals.NavigateURL( Convert.ToInt32( setting ) );
                    }
                }

                return _RedirectURL;
            }
        }

        /// <summary>
        /// Page_Load runs when the control is loaded
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[cnurse]	03/23/2006  Documented
        /// </history>
        protected void Page_Load( Object sender, EventArgs e )
        {
            try
            {
                UserInfo objUserInfo = UserController.GetCurrentUserInfo();
                SharpContent.Entities.Users.UserOnlineController userOnlineController = new SharpContent.Entities.Users.UserOnlineController();
                userOnlineController.DeleteUserOnline(objUserInfo.UserID);

                // Log User Off from Cookie Authentication System
                FormsAuthentication.SignOut();                

                //remove language cookie
                Response.Cookies["language"].Value = "";

                // expire cookies
                if( PortalSecurity.IsInRoles( PortalSettings.AdministratorRoleId.ToString() ) && Request.Cookies["_Tab_Admin_Content" + PortalSettings.PortalId] != null )
                {
                    Response.Cookies["_Tab_Admin_Content" + PortalSettings.PortalId].Value = null;
                    Response.Cookies["_Tab_Admin_Content" + PortalSettings.PortalId].Path = "/";
                    Response.Cookies["_Tab_Admin_Content" + PortalSettings.PortalId].Expires = DateTime.Now.AddYears( - 30 );
                }

                Response.Cookies["portalaliasid"].Value = null;
                Response.Cookies["portalaliasid"].Path = "/";
                Response.Cookies["portalaliasid"].Expires = DateTime.Now.AddYears( - 30 );

                Response.Cookies["portalroles"].Value = null;
                Response.Cookies["portalroles"].Path = "/";
                Response.Cookies["portalroles"].Expires = DateTime.Now.AddYears( - 30 );

                if( Request.Cookies["_Tab_Admin_Preview" + PortalSettings.PortalId] != null )
                {
                    Response.Cookies["_Tab_Admin_Preview" + PortalSettings.PortalId].Value = "False";
                }
                
                // Redirect browser back to portal
                Response.Redirect( RedirectURL, true );
            }
            catch( Exception exc ) //Page failed to load
            {
                Exceptions.ProcessPageLoadException( exc );
            }
        }


    }
}