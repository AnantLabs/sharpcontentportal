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
using SharpContent.Entities.Modules;
using SharpContent.Entities.Users;
using SharpContent.Security.Membership;
using SharpContent.Services.Localization;

namespace SharpContent.Modules.Admin.Users
{
    /// Project:    SharpContent
    /// Namespace:  SharpContent.Modules.Admin.Users
    /// Class:      Membership
    /// <summary>
    /// The Membership UserModuleBase is used to manage the membership aspects of a
    /// User
    /// </summary>
    /// <history>
    /// 	[cnurse]	03/01/2006  Created
    /// </history>
    public partial class Membership : UserModuleBase
    {
        public delegate void PasswordUpdatedEventHandler(object sender, PasswordUpdatedEventArgs e);

        private PasswordUpdatedEventHandler PasswordResetEvent;

        private EventHandler MembershipAuthorizedEvent;

        public event PasswordUpdatedEventHandler PasswordReset
        {
            add
            {
                PasswordResetEvent += value;
            }
            remove
            {
                PasswordResetEvent -= value;
            }
        }

        public event EventHandler MembershipAuthorized
        {
            add
            {
                MembershipAuthorizedEvent += value;
            }
            remove
            {
                MembershipAuthorizedEvent -= value;
            }
        }

        private EventHandler MembershipUnAuthorizedEvent;

        public event EventHandler MembershipUnAuthorized
        {
            add
            {
                MembershipUnAuthorizedEvent += value;
            }
            remove
            {
                MembershipUnAuthorizedEvent -= value;
            }
        }

        private EventHandler MembershipUnLockedEvent;

        public event EventHandler MembershipUnLocked
        {
            add
            {
                MembershipUnLockedEvent += value;
            }
            remove
            {
                MembershipUnLockedEvent -= value;
            }
        }

        /// <summary>
        /// Gets the UserMembership associated with this control
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/01/2006  Created
        /// </history>
        public UserMembership UserMembership
        {
            get
            {
                UserMembership membership = null;
                if (User != null)
                {
                    membership = User.Membership;
                }
                return membership;
            }
        }

        /// <summary>
        /// Raises the MembershipAuthorized Event
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/01/2006  Created
        /// </history>
        public void OnMembershipAuthorized(EventArgs e)
        {
            if (MembershipAuthorizedEvent != null)
            {
                MembershipAuthorizedEvent(this, e);
            }
        }

        /// <summary>
        /// Raises the MembershipUnAuthorized Event
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/01/2006  Created
        /// </history>
        public void OnMembershipUnAuthorized(EventArgs e)
        {
            if (MembershipUnAuthorizedEvent != null)
            {
                MembershipUnAuthorizedEvent(this, e);
            }
        }

        /// <summary>
        /// Raises the MembershipUnLocked Event
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/01/2006  Created
        /// </history>
        public void OnMembershipUnLocked(EventArgs e)
        {
            if (MembershipUnLockedEvent != null)
            {
                MembershipUnLockedEvent(this, e);
            }
        }

        /// <summary>
        /// Raises the PasswordUpdated Event
        /// </summary>
        /// <history>
        /// </history>
        public void OnPasswordReset(PasswordUpdatedEventArgs e)
        {
            if (PasswordResetEvent != null)
            {
                PasswordResetEvent(this, e);
            }
        }

        /// <summary>
        /// DataBind binds the data to the controls
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/01/2006  Created
        /// </history>
        public override void DataBind()
        {
            //disable/enable buttons
            if (UserInfo.UserID == User.UserID)
            {
                cmdAuthorize.Visible = false;
                cmdUnAuthorize.Visible = false;
                cmdUnLock.Visible = false;
                cmdPassword.Visible = false;
                cmdResetPassword.Visible = false;
            }
            else
            {
                cmdUnLock.Visible = UserMembership.LockedOut;
                cmdUnAuthorize.Visible = UserMembership.Approved;
                cmdAuthorize.Visible = !UserMembership.Approved;
                cmdPassword.Visible = !UserMembership.UpdatePassword;
                cmdResetPassword.Visible = true;
            }

            MembershipEditor.DataSource = UserMembership;
            MembershipEditor.DataBind();
        }

        /// <summary>
        /// Page_Init runs when the control is initialised
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/01/2006  Created
        /// </history>
        protected void Page_Init(Object sender, EventArgs e)
        {
            this.cmdAuthorize.Click += new EventHandler(cmdAuthorize_Click);
            this.cmdPassword.Click += new EventHandler(cmdPassword_Click);
            this.cmdResetPassword.Click += new EventHandler(cmdResetPassword_Click);
            this.cmdUnAuthorize.Click += new EventHandler(cmdUnAuthorize_Click);
            this.cmdUnLock.Click += new EventHandler(cmdUnLock_Click);

            this.cmdAuthorize.Text = Localization.GetString("cmdAuthorize", this.LocalResourceFile);
            this.cmdPassword.Text = Localization.GetString("cmdPassword", this.LocalResourceFile);
            this.cmdResetPassword.Text = Localization.GetString("cmdResetPassword", this.LocalResourceFile);
            this.cmdUnAuthorize.Text = Localization.GetString("cmdUnAuthorize", this.LocalResourceFile);
            this.cmdUnLock.Text = Localization.GetString("cmdUnLock", this.LocalResourceFile);
        }

        /// <summary>
        /// Page_Load runs when the control is loaded
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[cnurse]	03/01/2006  Created
        /// </history>
        protected void Page_Load(Object sender, EventArgs e)
        {
            MembershipEditor.LocalResourceFile = this.LocalResourceFile;
        }

        /// <summary>
        /// cmdAuthorize_Click runs when the Authorize User Button is clicked
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/01/2006  Created
        /// </history>
        protected void cmdAuthorize_Click(object sender, EventArgs e)
        {
            //Get the Membership Information from the property editors
            User.Membership = (UserMembership)MembershipEditor.DataSource;

            User.Membership.Approved = true;

            //Update User
            UserController.UpdateUser(PortalId, User);

            OnMembershipAuthorized(EventArgs.Empty);
        }

        /// <summary>
        /// cmdPassword_Click runs when the ChangePassword Button is clicked
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/15/2006  Created
        /// </history>
        protected void cmdPassword_Click(object sender, EventArgs e)
        {
            //Get the Membership Information from the property editors
            User.Membership = (UserMembership)MembershipEditor.DataSource;

            User.Membership.UpdatePassword = true;

            //Update User
            UserController.UpdateUser(PortalId, User);

            DataBind();
        }

        /// <summary>
        /// cmdResetPassword_Click runs when the ChangePassword Button is clicked
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/15/2006  Created
        /// </history>
        protected void cmdResetPassword_Click(object sender, EventArgs e)
        {
            try
            {
                UserController.ResetPassword(User, "", "", true);

                //Get the Membership Information from the property editors
                User.Membership = (UserMembership)MembershipEditor.DataSource;

                User.Membership.UpdatePassword = true;

                //Update User
                UserController.UpdateUser(PortalId, User);
                
                DataBind();

                OnPasswordReset(new PasswordUpdatedEventArgs(PasswordUpdateStatus.Success));

                
                
            }
            catch (Exception)
            {
                OnPasswordReset(new PasswordUpdatedEventArgs(PasswordUpdateStatus.PasswordResetFailed));
            }
        }

        /// <summary>
        /// cmdUnAuthorize_Click runs when the UnAuthorize User Button is clicked
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/01/2006  Created
        /// </history>
        protected void cmdUnAuthorize_Click(object sender, EventArgs e)
        {
            //Get the Membership Information from the property editors
            User.Membership = (UserMembership)MembershipEditor.DataSource;

            User.Membership.Approved = false;

            //Update User
            UserController.UpdateUser(PortalId, User);

            OnMembershipUnAuthorized(EventArgs.Empty);
        }

        /// <summary>
        /// cmdUnlock_Click runs when the Unlock Account Button is clicked
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/01/2006  Created
        /// </history>
        protected void cmdUnLock_Click(Object sender, EventArgs e)
        {
            // update the user record in the database
            bool isUnLocked = UserController.UnLockUser(User);

            if (isUnLocked)
            {
                User.Membership.LockedOut = false;

                OnMembershipUnLocked(EventArgs.Empty);
            }
        }

        /// <summary>
        /// The PasswordUpdatedEventArgs class provides a customised EventArgs class for
        /// the PasswordUpdated Event
        /// </summary>
        /// <history>
        /// </history>
        public class PasswordUpdatedEventArgs
        {
            private PasswordUpdateStatus _UpdateStatus;

            /// <summary>
            /// Constructs a new PasswordUpdatedEventArgs
            /// </summary>
            /// <param name="status">The Password Update Status</param>
            /// <history>
            /// 	[cnurse]	03/08/2006  Created
            /// </history>
            public PasswordUpdatedEventArgs(PasswordUpdateStatus status)
            {
                _UpdateStatus = status;
            }

            /// <summary>
            /// Gets and sets the Update Status
            /// </summary>
            /// <history>
            /// 	[cnurse]	03/08/2006  Created
            /// </history>
            public PasswordUpdateStatus UpdateStatus
            {
                get
                {
                    return _UpdateStatus;
                }
                set
                {
                    _UpdateStatus = value;
                }
            }
        }

    }
}