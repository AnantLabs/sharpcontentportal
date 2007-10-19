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
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;
using System.Xml;

using SharpContent.Common;
using SharpContent.Common.Utilities;
using SharpContent.Entities.Modules;
using SharpContent.Entities.Users;
using SharpContent.Security.Membership;
using SharpContent.Services.Exceptions;
using SharpContent.Services.Localization;
using SharpContent.Services.Mail;
using SharpContent.UI.Skins.Controls;

namespace SharpContent.Modules.Admin.Users
{
    /// <summary>
    /// The Password UserModuleBase is used to manage Users Passwords
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <history>
    /// 	[cnurse]	03/03/2006  created
    /// </history>
    public partial class UserBulkLoad : UserModuleBase
    {
        private bool _loadSuccessful = true;
        private ArrayList _passwordQuestions = new ArrayList();

        #region Private Methods

        /// <summary>
        /// AddLocalizedModuleMessage adds a localized module message
        /// </summary>
        /// <param name="message">The localized message</param>
        /// <param name="type">The type of message</param>
        /// <param name="display">A flag that determines whether the message should be displayed</param>
        /// <history>
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
        /// </history>
        private void AddModuleMessage(string message, ModuleMessageType type, bool display)
        {
            AddLocalizedModuleMessage(Localization.GetString(message, LocalResourceFile), type, display);
        }

        private string GetPasswordQuestionText(int questionId)
        {
            string questionText = String.Empty;
            if (_passwordQuestions.Count == 0)
            {
                _passwordQuestions = MembershipController.GetPasswordQuestons(CultureInfo.CurrentUICulture.Name);
            }
            if (questionId >= 1 && questionId <= _passwordQuestions.Count)
            {
                questionText = ((PasswordQuestionInfo)_passwordQuestions[questionId - 1]).Text;
            }
            return questionText;
        }

        /// <summary>
        /// ParseUser parses the User node in the Users file
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="node">The User node</param>
        private void LoadSCPUsers(Stream xmlStream)
        {
            string logFile = String.Empty;
            string logPath = String.Empty;
            StreamWriter logStream = null;
            XmlDocument doc = new XmlDocument();
            XmlNode xmlRoot = null;

            try
            {
                logFile = Localization.GetString("LogFile", this.LocalResourceFile) + "_" + DateTime.Now.ToString("MMddyyyy_HHmmss") + ".csv";
                logPath = HttpContext.Current.Server.MapPath("\\Portals\\" + PortalSettings.PortalId) + "\\" + logFile;
                logStream = File.CreateText(logPath);
                logStream.WriteLine("account,username,firstname,lastname,status");

                doc.Load(xmlStream);
                xmlRoot = doc.DocumentElement;

                foreach (XmlElement userElement in xmlRoot.SelectNodes("users/user"))
                {
                    logStream.WriteLine(ParseUser(userElement));
                }

                if (_loadSuccessful)
                {
                    AddModuleMessage("UserLoadCompleted", ModuleMessageType.GreenSuccess, true);
                }
                else
                {
                    AddModuleMessage("UserLoadCompletedWithErrors", ModuleMessageType.YellowWarning, true);
                }

            }
            catch
            {
                AddModuleMessage("UserLoadFailure", ModuleMessageType.RedError, true);
            }
            finally
            {
                xmlStream.Close();
                if (logStream != null)
                {
                    trLogFile.Visible = true;
                    lnkLogFile.Text = logFile;
                    lnkLogFile.NavigateUrl = "~/Portals/" + PortalSettings.PortalId + "/" + logFile;
                    logStream.Close();
                }
            }
        }

        /// <summary>
        /// ParseUser parses the User node in the Users file
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="node">The User node</param>
        private string ParseUser(XmlNode node)
        {
            string message = String.Empty;
            try
            {
                //Parse the User node                
                string account = XmlUtils.GetNodeValue(node, "account", "");
                string userName = XmlUtils.GetNodeValue(node, "username", "");
                string firstName = XmlUtils.GetNodeValue(node, "firstname", "");
                string lastName = XmlUtils.GetNodeValue(node, "lastname", "");
                string password = XmlUtils.GetNodeValue(node, "password", "");
                string question = XmlUtils.GetNodeValue(node, "question", "");
                string answer = XmlUtils.GetNodeValue(node, "answer", "");
                string email = XmlUtils.GetNodeValue(node, "email", "");
                string locale = XmlUtils.GetNodeValue(node, "locale", "");
                int timeZone = XmlUtils.GetNodeValueInt(node, "timezone", 0);

                UserInfo userInfo = new UserInfo();
                userInfo.PortalID = PortalSettings.PortalId;
                userInfo.FirstName = firstName;
                userInfo.LastName = lastName;
                userInfo.Username = userName;
                userInfo.DisplayName = firstName + " " + lastName;
                if (String.IsNullOrEmpty(password))
                {
                    password = UserController.GeneratePassword();
                }
                userInfo.Membership.Password = password;
                if (String.IsNullOrEmpty(question))
                {
                    question = "1";
                }
                userInfo.Membership.PasswordQuestion = question;
                if (String.IsNullOrEmpty(answer))
                {
                    answer = UserController.GeneratePassword();
                }
                userInfo.Membership.PasswordAnswer = answer;
                userInfo.Email = email;

                userInfo.Membership.Approved = chkAuthorize.Checked;

                userInfo.Profile.FirstName = firstName;
                userInfo.Profile.LastName = lastName;
                userInfo.Profile.PreferredLocale = locale;
                userInfo.Profile.TimeZone = timeZone;

                UserCreateStatus status = UserController.CreateUser(ref userInfo);                

                if (status == UserCreateStatus.Success && chkNotify.Checked)
                {
                    ArrayList custom = new ArrayList();
                    custom.Add(GetPasswordQuestionText(Convert.ToInt32(question)));
                    custom.Add(answer);
                    if (chkAuthorize.Checked)
                    {
                        Mail.SendMail(userInfo, MessageType.UserRegistrationPublic, PortalSettings, custom);
                    }
                    else
                    {
                        Mail.SendMail(userInfo, MessageType.UserRegistrationPrivate, PortalSettings, custom);
                    }
                }
                else if (status != UserCreateStatus.Success)
                {
                    _loadSuccessful = false;
                }

                message = account + "," + userName + "," + firstName + "," + lastName + "," + status.ToString();
            }
            catch (Exception ex)
            {
                message = ex.Message;
                
            }
            return message;
        }

        #endregion

        #region Events

        /// <summary>
        /// Page_Init runs when the control is initated
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	
        /// </history>
        protected void Page_Init(object sender, EventArgs e)
        {
            this.cmdLoad.Click += new EventHandler(cmdLoad_Click);
            this.cmdCancel.Click += new EventHandler(cmdCancel_Click);

            this.cmdLoad.Text = Localization.GetString("cmdLoad", this.LocalResourceFile);
            this.cmdCancel.Text = Localization.GetString("cmdCancel", this.LocalResourceFile);
        }

        /// <summary>
        /// Page_Load runs when the control is loaded
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	
        /// </history>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                lblTitle.Text = Localization.GetString("lblTitle.Text", LocalResourceFile);
            }
        }

        /// <summary>
        /// cmdLoad_Click runs when the Load Button is clicked
        /// </summary>
        /// <history>
        /// </history>
        protected void cmdLoad_Click(Object sender, EventArgs e)
        {
            if (Page.IsPostBack)
            {
                if (!String.IsNullOrEmpty(cmdBrowse.PostedFile.FileName))
                {
                    string postedFile = Path.GetFileName(cmdBrowse.PostedFile.FileName);
                    string strExtension = Path.GetExtension(cmdBrowse.PostedFile.FileName);
                    ArrayList messages = new ArrayList();
                    
                    if (strExtension.ToLower() == ".scp")
                    {
                        LoadSCPUsers(cmdBrowse.PostedFile.InputStream);
                    }
                    else if (strExtension.ToLower() == ".xml")
                    {
                    }
                    else
                    {
                        AddModuleMessage("UserLoadFailure", ModuleMessageType.RedError, true);
                    }
                }
            }
        }

        // <summary>
        /// cmdCancel_Click runs when the Cancel Button is clicked
        /// </summary>
        /// <history>
        /// </history>
        protected void cmdCancel_Click(Object sender, EventArgs e)
        {
            try
            {
                Response.Redirect(Globals.NavigateURL());
            }
            catch (Exception exc) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        #endregion

    }
}