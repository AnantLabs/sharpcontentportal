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
using System.Diagnostics;
using SharpContent.Common.Utilities;
using SharpContent.Entities.Modules;
using SharpContent.Entities.Users;
using SharpContent.Security;
using SharpContent.Security.Membership;
using SharpContent.Services.Localization;
using SharpContent.Services.Log.EventLog;
using SharpContent.Services.Mail;
using SharpContent.UI.Skins.Controls;
using System.Collections;
using System.Globalization;
using System.Web.UI.WebControls;

namespace SharpContent.Modules.Admin.Security
{
    /// <summary>
    /// The SendPassword UserModuleBase is used to allow a user to retrieve their password
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <history>
    /// 	[cnurse]	03/21/2006  Created
    /// </history>
    public partial class ResetPassword : UserModuleBase
    {
        private string ipAddress;

        /// <summary>
        /// Gets whether the Captcha control is used to validate the login
        /// </summary>
        /// <history>
        /// 	[cnurse]	03/21/2006  Created
        /// </history>
        protected bool UseCaptcha
        {
            get
            {
                object setting = GetSetting(PortalId, "Security_CaptchaLogin");
                return Convert.ToBoolean(setting);
            }
        }

        /// <summary>
        /// AddLocalizedModuleMessage adds a localized module message
        /// </summary>
        /// <param name="message">The localized message</param>
        /// <param name="type">The type of message</param>
        /// <param name="display">A flag that determines whether the message should be displayed</param>
        /// <history>
        /// 	[cnurse]	03/21/2006  Created
        /// </history>
        private void AddLocalizedModuleMessage(string message, ModuleMessageType type, bool display)
        {
            if (display)
            {
                UI.Skins.Skin.AddModuleMessage(this, message, type);
            }
        }

        /// <summary>
        /// AddModuleMessage adds a module message
        /// </summary>
        /// <param name="message">The message</param>
        /// <param name="type">The type of message</param>
        /// <param name="display">A flag that determines whether the message should be displayed</param>
        /// <history>
        /// 	[cnurse]	03/21/2006  Created
        /// </history>
        private void AddModuleMessage(string message, ModuleMessageType type, bool display)
        {
            AddLocalizedModuleMessage(Localization.GetString(message, LocalResourceFile), type, display);
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
        /// Resets the Control to the first load state.
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[jt]	04/14/2007  Created
        /// </history>
        private void ResetControl()
        {            
            UserId = -1;
            User = null;
            try
            {
                cboResetQuestion.SelectedIndex = 0;
            }
            catch
            {
                //Do nothing.
            }
            txtAnswer.Text = String.Empty;
            tblQA.Visible = false;
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            this.cmdResetPassword.Click += new EventHandler(cmdResetPassword_Click);

            this.cmdResetPassword.Text = Localization.GetString("cmdResetPassword", LocalResourceFile);
        }

        /// <summary>
        /// Page_Load runs when the control is loaded
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[cnurse]	03/21/2006  Created
        /// </history>
        protected void Page_Load(Object sender, EventArgs e)
        {
            if (Request.UserHostAddress != null)
            {
                ipAddress = Request.UserHostAddress;
            }

            trCaptcha1.Visible = UseCaptcha;
            trCaptcha2.Visible = UseCaptcha;

            if (UseCaptcha)
            {
                ctlCaptcha.ErrorMessage = Localization.GetString("InvalidCaptcha", this.LocalResourceFile);
                ctlCaptcha.Text = Localization.GetString("CaptchaText", this.LocalResourceFile);
            }
            //Display Question and Answer area if a valid user has been entered.
            if (!Page.IsPostBack)
            {
                tblQA.Visible = false;
            }
        }

        /// <summary>
        /// cmdResetPassword_Click runs when the password reset button is clicked
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[JT]	04/13/2006  Created
        /// </history>
        protected void cmdResetPassword_Click(Object sender, EventArgs e)
        {
            string strMessage = Null.NullString;
            ModuleMessageType moduleMessageType = ModuleMessageType.GreenSuccess;
            bool canReset = true;
            string question = String.Empty;
            string answer = String.Empty;

            if ((UseCaptcha && ctlCaptcha.IsValid) || (!UseCaptcha))
            {
                // No point in continuing if the user has not entered a username.
                if (!String.IsNullOrEmpty(txtUsername.Text.Trim()))
                {
                    PortalSecurity objSecurity = new PortalSecurity();

                    UserInfo objUser = UserController.GetUserByName(PortalSettings.PortalId, txtUsername.Text.Trim(), false);          
                    
                    if (objUser != null && objUser.Membership.Approved && !objUser.Membership.LockedOut)
                    {
                        if (MembershipProviderConfig.RequiresQuestionAndAnswer)
                        {
                            // This is a simple check to see if this is our first or second pass through this event method.
                            if (User.UserID != objUser.UserID)
                            {
                                User = objUser;
                                canReset = false;

                                // Check to see if the user had enter an email and password question.
                                if (!String.IsNullOrEmpty(User.Membership.Email.Trim()) && !String.IsNullOrEmpty(User.Membership.PasswordQuestion.Trim()))
                                {
                                    tblQA.Visible = true;
                                    BindQuestions();
                                    txtAnswer.Text = String.Empty;                                    
                                    strMessage = Localization.GetString("RequiresQAndAEnabled", this.LocalResourceFile);
                                    moduleMessageType = ModuleMessageType.YellowWarning;
                                }
                                else
                                {
                                    strMessage = Localization.GetString("MissingEmailOrQuestion", this.LocalResourceFile);
                                    moduleMessageType = ModuleMessageType.RedError;
                                }                                
                            }
                            else
                            {
                                question = cboResetQuestion.SelectedValue.ToLower();
                                answer = txtAnswer.Text.Trim().ToLower();
                                if (String.IsNullOrEmpty(answer))
                                {
                                    canReset = false;
                                    strMessage = Localization.GetString("EnterAnswer", this.LocalResourceFile);
                                    moduleMessageType = ModuleMessageType.RedError;
                                }
                            }
                        }                        
                    }
                    else
                    {   
                        canReset = false;
                        ResetControl();
                        if (objUser == null)
                        {                            
                            strMessage = Localization.GetString("UsernameError", this.LocalResourceFile);                            
                        }
                        else
                        {
                            if (!objUser.Membership.Approved)
                            {
                                strMessage = Localization.GetString("UserNotAuthorized", this.LocalResourceFile);
                            }
                            else if (objUser.Membership.LockedOut)
                            {
                                strMessage = Localization.GetString("UserLockedOut", this.LocalResourceFile);
                            }
                            else
                            {
                                strMessage = Localization.GetString("AccountDisabled", this.LocalResourceFile);
                            }
                        }
                        moduleMessageType = ModuleMessageType.RedError;
                    }                   

                    if (canReset)
                    {
                        try
                        {
                            UserController.ResetPassword(objUser, question, answer, true);
                            objUser.Membership.UpdatePassword = true;
                            UserController.UpdateUser(PortalId, objUser);
                            Mail.SendMail(objUser, MessageType.PasswordReminder, PortalSettings);
                            strMessage = Localization.GetString("PasswordSent", this.LocalResourceFile);
                            moduleMessageType = ModuleMessageType.GreenSuccess;
                            pnlReset.Visible = false;

                            EventLogController objEventLog = new EventLogController();
                            LogInfo objEventLogInfo = new LogInfo();
                            objEventLogInfo.AddProperty("IP", ipAddress);
                            objEventLogInfo.LogPortalID = PortalSettings.PortalId;
                            objEventLogInfo.LogPortalName = PortalSettings.PortalName;
                            objEventLogInfo.LogUserID = UserId;
                            objEventLogInfo.LogUserName = objSecurity.InputFilter(txtUsername.Text, PortalSecurity.FilterFlag.NoScripting | PortalSecurity.FilterFlag.NoAngleBrackets | PortalSecurity.FilterFlag.NoMarkup);
                            objEventLogInfo.LogTypeKey = "PASSWORD_RESET_SUCCESS";
                            objEventLog.AddLog(objEventLogInfo);                            
                        }
                        catch (Exception)
                        {
                            strMessage = Localization.GetString("PasswordResetError", this.LocalResourceFile);
                            moduleMessageType = ModuleMessageType.RedError; 

                            EventLogController objEventLog = new EventLogController();
                            LogInfo objEventLogInfo = new LogInfo();
                            objEventLogInfo.AddProperty("IP", ipAddress);
                            objEventLogInfo.LogPortalID = PortalSettings.PortalId;
                            objEventLogInfo.LogPortalName = PortalSettings.PortalName;
                            objEventLogInfo.LogUserID = UserId;
                            objEventLogInfo.LogUserName = objSecurity.InputFilter(txtUsername.Text, PortalSecurity.FilterFlag.NoScripting | PortalSecurity.FilterFlag.NoAngleBrackets | PortalSecurity.FilterFlag.NoMarkup);
                            objEventLogInfo.LogTypeKey = "PASSWORD_RESET_FAILURE";
                            objEventLog.AddLog(objEventLogInfo);                           
                        }  
                    }
                }
                else
                {
                    ResetControl();
                    strMessage = Localization.GetString("EnterUsername", this.LocalResourceFile);
                    moduleMessageType = ModuleMessageType.RedError;
                }

                UI.Skins.Skin.AddModuleMessage(this, strMessage, moduleMessageType);
            }
        }
    }
}