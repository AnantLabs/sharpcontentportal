//
// SharpContent - http://www.SharpContentPortal.com
// Copyright (c) 2002-2007
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
//

using System.Web.Security;

using SharpContent.Entities.Modules;
using SharpContent.Common.Lists;
using SharpContent.Security.Roles;
using SharpContent.Security.Membership;
using SharpContent.Services.Localization;
using SharpContent.Services.Mail;
using SharpContent.UI.Skins;
using System.Collections;
using System;
using SharpContent.Common;
using SharpContent.Common.Utilities;
using SharpContent.Services.Exceptions;
using SharpContent.Entities.Portals;
using SharpContent.Entities.Users;

namespace SharpContent.Modules.Admin.Security
{

    /// -----------------------------------------------------------------------------
    /// <summary>
    /// The MemberServices UserModuleBase is used to manage a User's services
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <history>
    /// 	[cnurse]	03/03/2006
    /// </history>
    /// -----------------------------------------------------------------------------
    partial class MemberServices : UserModuleBase
    {

        #region Delegates

        public delegate void SubscriptionUpdatedEventHandler(object sender, SubscriptionUpdatedEventArgs e);

        #endregion

        #region Events

        public event SubscriptionUpdatedEventHandler SubscriptionUpdated;

        #endregion

        #region Private Members

        private int RoleID = -1;

        #endregion

        #region Private Methods

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// FormatPrice formats the Fee amount and filters out null-values
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="price">The price to format</param>
        ///	<returns>The correctly formatted price</returns>
        /// <history>
        /// 	[cnurse]	9/13/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        /// -----------------------------------------------------------------------------
        private string FormatPrice(float price)
        {
            string _FormatPrice = Null.NullString;
            try
            {
                if (price != Null.NullSingle)
                {
                    _FormatPrice = price.ToString("##0.00");
                }
                else
                {
                    _FormatPrice = "";
                }
            }
            catch (Exception exc)
            {
                //Module failed to load
                Exceptions.ProcessModuleLoadException(this, exc);
            }
            return _FormatPrice;
        }
        private string FormatPrice(object price)
        {
            return FormatPrice(float.Parse(price.ToString()));
        }

        private ArrayList GetRoles(int portalId, int userId)
        {
            RoleController objRoles = new RoleController();

            return objRoles.GetUserRoles(portalId, userId, false);

        }

        private void Subscribe(int roleID, bool cancel)
        {
            RoleController objRoles = new RoleController();
            RoleInfo objRole = objRoles.GetRole(roleID, PortalSettings.PortalId);

            if (objRole.IsPublic & objRole.ServiceFee == 0.0)
            {
                objRoles.UpdateUserRole(PortalId, UserInfo.UserID, roleID, cancel);

                //Raise SubscriptionUpdated Event
                OnSubscriptionUpdated(new SubscriptionUpdatedEventArgs(cancel, objRole.RoleName));
            }
            else
            {
                if (!cancel)
                {
                    Response.Redirect("~/admin/Sales/PayPalSubscription.aspx?tabid=" + TabId + "&RoleID=" + roleID.ToString(), true);
                }
                else
                {
                    Response.Redirect("~/admin/Sales/PayPalSubscription.aspx?tabid=" + TabId + "&RoleID=" + roleID.ToString() + "&cancel=1", true);
                }
            }
        }

        private void UseTrial(int roleID)
        {
            RoleController objRoles = new RoleController();
            RoleInfo objRole = objRoles.GetRole(roleID, PortalSettings.PortalId);

            if (objRole.IsPublic & objRole.TrialFee == 0.0)
            {
                objRoles.UpdateUserRole(PortalId, UserInfo.UserID, roleID, false);

                //Raise SubscriptionUpdated Event
                OnSubscriptionUpdated(new SubscriptionUpdatedEventArgs(false, objRole.RoleName));
            }
            else
            {
                Response.Redirect("~/admin/Sales/PayPalSubscription.aspx?tabid=" + TabId + "&RoleID=" + roleID.ToString(), true);
            }
        }

        #endregion

        #region Public Methods

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// DataBind binds the data to the controls
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/13/2006  Created
        /// </history>
        /// -----------------------------------------------------------------------------
        public override void DataBind()
        {

            if (Request.IsAuthenticated)
            {
                grdServices.DataSource = GetRoles(PortalId, UserInfo.UserID);
                grdServices.DataBind();

                // if no service available then hide options
                ServicesRow.Visible = (grdServices.Items.Count > 0);
            }

        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// FormatExpiryDate formats the expiry date and filters out null-values
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="expiryDate">The date to format</param>
        ///	<returns>The correctly formatted date</returns>
        /// <history>
        /// 	[cnurse]	9/13/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        /// -----------------------------------------------------------------------------
        public string FormatExpiryDate(DateTime expiryDate)
        {
            string _FormatExpiryDate = Null.NullString;
            try
            {
                if (!Null.IsNull(expiryDate))
                {
                    if (expiryDate > System.DateTime.Today)
                    {
                        _FormatExpiryDate = expiryDate.ToShortDateString();
                    }
                    else
                    {
                        _FormatExpiryDate = Localization.GetString("Expired", this.LocalResourceFile);
                    }
                }
            }
            catch (Exception exc)
            {
                //Module failed to load
                Exceptions.ProcessModuleLoadException(this, exc);
            }
            return _FormatExpiryDate;
        }
        public string FormatExpiryDate(object expiryDate)
        {
            return FormatExpiryDate(Convert.ToDateTime(expiryDate));
        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// FormatPrice formats the Fee amount and filters out null-values
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="price">The price to format</param>
        ///	<returns>The correctly formatted price</returns>
        /// <history>
        /// 	[cnurse]	01/18/2007 Created
        /// </history>
        /// -----------------------------------------------------------------------------
        public object FormatPrice(float price, int period, string frequency)
        {
            string _FormatPrice = Null.NullString;
            try
            {
                switch (frequency)
                {
                    case "N":
                    case "":
                        _FormatPrice = Localization.GetString("NoFee", this.LocalResourceFile);
                        break;
                    case "O":
                        _FormatPrice = FormatPrice(price);
                        break;
                    default:
                        _FormatPrice = string.Format(Localization.GetString("Fee", this.LocalResourceFile), FormatPrice(price), period, Localization.GetString("Frequency_" + frequency, this.LocalResourceFile));
                        break;
                }
            }
            catch (Exception exc)
            {
                //Module failed to load
                Exceptions.ProcessModuleLoadException(this, exc);
            }
            return _FormatPrice;
        }
        public object FormatPrice(object price, object period, object frequency)
        {
            return FormatPrice(float.Parse(price.ToString()), Convert.ToInt32(period), frequency.ToString());
        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// FormatTrial formats the Trial Fee amount and filters out null-values
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="price">The price to format</param>
        ///	<returns>The correctly formatted price</returns>
        /// <history>
        /// 	[cnurse]	03/28/2007 Created
        /// </history>
        /// -----------------------------------------------------------------------------
        public object FormatTrial(float price, int period, string frequency)
        {
            string _FormatTrial = Null.NullString;
            try
            {
                switch (frequency)
                {
                    case "N":
                    case "":
                        _FormatTrial = Localization.GetString("NoFee", this.LocalResourceFile);
                        break;
                    case "O":
                        _FormatTrial = FormatPrice(price);
                        break;
                    default:
                        _FormatTrial = string.Format(Localization.GetString("TrialFee", this.LocalResourceFile), FormatPrice(price), period, Localization.GetString("Frequency_" + frequency, this.LocalResourceFile));
                        break;
                }
            }
            catch (Exception exc)
            {
                //Module failed to load
                Exceptions.ProcessModuleLoadException(this, exc);
            }
            return _FormatTrial;
        }
        public object FormatTrial(object price, object period, object frequency)
        {
            return FormatTrial(float.Parse(price.ToString()), Convert.ToInt32(period), frequency.ToString());
        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// FormatURL correctly formats a URL
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<returns>The correctly formatted url</returns>
        /// <history>
        /// 	[cnurse]	9/13/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        /// -----------------------------------------------------------------------------
        public string FormatURL()
        {
            string _FormatURL = Null.NullString;
            try
            {
                string strServerPath;

                strServerPath = Request.ApplicationPath;
                if (!strServerPath.EndsWith("/"))
                {
                    strServerPath += "/";
                }

                _FormatURL = strServerPath + "Register.aspx?tabid=" + TabId;
            }
            catch (Exception exc)
            {
                //Module failed to load
                Exceptions.ProcessModuleLoadException(this, exc);
            }
            return _FormatURL;
        }

        public string ServiceText(object subscribed, object expiryDate)
        {            
            return ServiceText(Convert.ToBoolean(subscribed.ToString()), Convert.ToDateTime(expiryDate.ToString()));
        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// ServiceText gets the Service Text (Cancel or Subscribe)
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="Subscribed">The service state</param>
        ///	<returns>The correctly formatted text</returns>
        /// <history>
        /// 	[cnurse]	9/13/2004	Updated to reflect design changes for Help, 508 support
        ///                       and localisation
        /// </history>
        /// -----------------------------------------------------------------------------
        public string ServiceText(bool subscribed, DateTime expiryDate)
        {
            string _ServiceText = Null.NullString;
            try
            {
                if (!subscribed)
                {
                    _ServiceText = Localization.GetString("Subscribe", this.LocalResourceFile);                    
                }
                else
                {
                    _ServiceText = Localization.GetString("Unsubscribe", this.LocalResourceFile);
                    if (!Null.IsNull(expiryDate))
                    {
                        if (expiryDate < System.DateTime.Today)
                        {
                            _ServiceText = Localization.GetString("Renew", this.LocalResourceFile);
                        }
                    }
                }
            }
            catch (Exception exc)
            {
                //Module failed to load
                Exceptions.ProcessModuleLoadException(this, exc);
            }
            return _ServiceText;
        }

        public bool ShowSubscribe(object roleID)
        {
            return (Globals.IsNumeric(roleID)) ? ShowSubscribe(Convert.ToInt32(roleID)) : false;
        }

        public bool ShowSubscribe(int roleID)
        {
            RoleController objRoles = new RoleController();
            bool _ShowSubscribe = Null.NullBoolean;
            RoleInfo objRole = objRoles.GetRole(roleID, PortalSettings.PortalId);

            if (objRole.IsPublic)
            {
                PortalController objPortals = new PortalController();
                PortalInfo objPortal = objPortals.GetPortal(PortalSettings.PortalId);
                if (objRole.ServiceFee == 0.0)
                {
                    _ShowSubscribe = true;
                }
                else if (objPortal != null && !string.IsNullOrEmpty(objPortal.ProcessorUserId))
                {
                    _ShowSubscribe = true;
                }
            }

            return _ShowSubscribe;
        }

        public bool ShowTrial(object roleID)
        {
            return (Globals.IsNumeric(roleID)) ? ShowTrial(Convert.ToInt32(roleID)) : false;
        }

        public bool ShowTrial(int roleID)
        {
            RoleController objRoles = new RoleController();
            bool _ShowTrial = Null.NullBoolean;
            RoleInfo objRole = objRoles.GetRole(roleID, PortalSettings.PortalId);

            if (objRole.IsPublic & objRole.ServiceFee == 0.0)
            {
                _ShowTrial = Null.NullBoolean;
            }
            else if (objRole.IsPublic & objRole.TrialFee == 0.0)
            {
                //Use Trial?
                UserRoleInfo objUserRole = objRoles.GetUserRole(PortalId, UserInfo.UserID, roleID);

                if ((objUserRole == null) || (!objUserRole.IsTrialUsed))
                {
                    _ShowTrial = true;
                }
            }

            return _ShowTrial;
        }
        #endregion

        #region Event Methods

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// Raises the SubscriptionUpdated Event
        /// </summary>
        /// <history>
        /// 	[cnurse]	01/17/2006  Created
        /// </history>
        /// -----------------------------------------------------------------------------
        public void OnSubscriptionUpdated(SubscriptionUpdatedEventArgs e)
        {
            if (SubscriptionUpdated != null)
            {
                SubscriptionUpdated(this, e);
            }
        }

        #endregion

        #region Event Handlers

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// Page_Load runs when the control is loaded
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[cnurse]	03/13/2006
        /// </history>
        /// -----------------------------------------------------------------------------
        private void Page_Load(object sender, System.EventArgs e)
        {
            try
            {
                lblRSVP.Text = "";

                // If this is the first visit to the page, localize the datalist
                if (Page.IsPostBack == false)
                {
                    //Localize the Headers
                    Localization.LocalizeDataGrid(ref grdServices, this.LocalResourceFile);
                }
            }
            catch (Exception exc)
            {
                //Module failed to load
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// cmdRSVP_Click runs when the Subscribe to RSVP Code Roles Button is clicked
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[cnurse]	01/19/2006  created
        /// </history>
        /// -----------------------------------------------------------------------------
        private void cmdRSVP_Click(object sender, System.EventArgs e)
		{

			//Get the RSVP code
			string code = txtRSVPCode.Text;
			bool blnRSVPCodeExists = false;

			if (code != "")
			{
				//Get the roles from the Database
				RoleController objRoles = new RoleController();
				ArrayList arrRoles = objRoles.GetPortalRoles(PortalSettings.PortalId);

				//Parse the roles
                    foreach (RoleInfo objRole in arrRoles)
                    {
					if (objRole.RSVPCode == code)
					{
						//Subscribe User to Role
						objRoles.UpdateUserRole(PortalId, UserInfo.UserID, objRole.RoleID);
						blnRSVPCodeExists = true;
					}
				}

				if (blnRSVPCodeExists)
				{
					lblRSVP.Text = Localization.GetString("RSVPSuccess", this.LocalResourceFile);
					//Reset RSVP Code field
					txtRSVPCode.Text = "";
				}
				else
				{
					lblRSVP.Text = Localization.GetString("RSVPFailure", this.LocalResourceFile);
				}
			}

			DataBind();

		}

        protected void grdServices_ItemCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
        {
            string commandName = e.CommandName;
            int roleID = Convert.ToInt32(e.CommandArgument);


            if (Localization.GetString("Subscribe", this.LocalResourceFile) == commandName || Localization.GetString("Renew", this.LocalResourceFile) == commandName)
            {
                //Subscribe
                Subscribe(roleID, false);
            }
            else if (Localization.GetString("Unsubscribe", this.LocalResourceFile) == commandName)
            {
                //Unsubscribe
                Subscribe(roleID, true);
            }
            else if (Localization.GetString("Unsubscribe", this.LocalResourceFile) == commandName)
            {
                //Unsubscribe
                Subscribe(roleID, true);
            }
            else if ("UseTrial" == commandName)
            {
                //Use Trial
                UseTrial(roleID);
            }

            //Rebind Grid
            DataBind();
        }

        #endregion

        #region Event Args

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// The SubscriptionUpdatedEventArgs class provides a customised EventArgs class for
        /// the SubscriptionUpdated Event
        /// </summary>
        /// <history>
        /// 	[cnurse]	01/17/2006  created
        /// </history>
        /// -----------------------------------------------------------------------------
        public class SubscriptionUpdatedEventArgs
        {

            private bool _cancel;
            private string _roleName;

            /// -----------------------------------------------------------------------------
            /// <summary>
            /// Constructs a new SubscriptionUpdatedEventArgs
            /// </summary>
            /// <param name="cancel">Whether this is a subscription cancellation</param>
            /// <history>
            /// 	[cnurse]	01/17/2006  created
            /// </history>
            /// -----------------------------------------------------------------------------
            public SubscriptionUpdatedEventArgs(bool cancel, string roleName)
            {
                _cancel = cancel;
                _roleName = roleName;
            }

            /// -----------------------------------------------------------------------------
            /// <summary>
            /// Gets and sets whether this was a cancelation
            /// </summary>
            /// <history>
            /// 	[cnurse]	01/17/2006  created
            /// </history>
            /// -----------------------------------------------------------------------------
            public bool Cancel
            {
                get { return _cancel; }
                set { _cancel = value; }
            }

            /// -----------------------------------------------------------------------------
            /// <summary>
            /// Gets and sets the RoleName that was (un)subscribed to
            /// </summary>
            /// <history>
            /// 	[cnurse]	01/17/2006  created
            /// </history>
            /// -----------------------------------------------------------------------------
            public string RoleName
            {
                get { return _roleName; }
                set { _roleName = value; }
            }

        }

        #endregion

    }
}
