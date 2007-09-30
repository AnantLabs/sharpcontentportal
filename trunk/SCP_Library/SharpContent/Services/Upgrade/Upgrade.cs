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
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web;
using System.Xml;
using SharpContent.Common;
using SharpContent.Common.Utilities;
using SharpContent.Data;
using SharpContent.Entities.Host;
using SharpContent.Entities.Modules;
using SharpContent.Entities.Modules.Definitions;
using SharpContent.Entities.Portals;
using SharpContent.Entities.Tabs;
using SharpContent.Entities.Users;
using SharpContent.Framework.Providers;
using SharpContent.Modules.Admin.ResourceInstaller;
using SharpContent.Security;
using SharpContent.Security.Membership;
using SharpContent.Security.Permissions;
using SharpContent.Services.FileSystem;
using SharpContent.Services.Log.EventLog;
using SharpContent.Services.Personalization;
using SharpContent.Services.Scheduling;

namespace SharpContent.Services.Upgrade
{
    /// <summary>
    /// The Upgrade class provides Shared/Static methods to Upgrade/Install
    ///	a SharpContent Application
    /// </summary>
    /// <remarks>
    /// </remarks>
    public class Upgrade
    {
        private static DateTime startTime;
        private static bool upgradeMemberShipProvider = true;

        public static TimeSpan RunTime
        {
            get
            {
                DateTime currentTime = DateTime.Now;
                return currentTime.Subtract(startTime);
            }
        }

        /// <summary>
        /// AddAdminPage adds an Admin Tab Page
        /// </summary>
        ///	<param name="Portal">The Portal</param>
        ///	<param name="TabName">The Name to give this new Tab</param>
        ///	<param name="TabIconFile">The Icon for this new Tab</param>
        ///	<param name="IsVisible">A flag indicating whether the tab is visible</param>
        private static TabInfo AddAdminPage(PortalInfo Portal, string TabName, string TabIconFile, bool IsVisible)
        {
            TabController objTabController = new TabController();
            TabInfo AdminPage = objTabController.GetTab(Portal.AdminTabId, Portal.PortalID, false);

            TabPermissionCollection objTabPermissions = new TabPermissionCollection();
            AddPagePermission(ref objTabPermissions, "View", Convert.ToInt32(Portal.AdministratorRoleId));

            //Call AddPage with parentTab = AdminPage & RoleId = AdministratorRoleId
            return AddPage(AdminPage, TabName, TabIconFile, IsVisible, objTabPermissions, true);
        }

        /// <summary>
        /// AddHostPage adds a Host Tab Page
        /// </summary>
        ///	<param name="TabName">The Name to give this new Tab</param>
        ///	<param name="TabIconFile">The Icon for this new Tab</param>
        ///	<param name="IsVisible">A flag indicating whether the tab is visible</param>
        private static TabInfo AddHostPage(string TabName, string TabIconFile, bool IsVisible)
        {
            TabController objTabController = new TabController();
            TabInfo HostPage = objTabController.GetTabByName("Host", Null.NullInteger);

            TabPermissionCollection objTabPermissions = new TabPermissionCollection();
            AddPagePermission(ref objTabPermissions, "View", Convert.ToInt32(Globals.glbRoleSuperUser));

            //Call AddPage with parentTab = Host & RoleId = SupeUser
            return AddPage(HostPage, TabName, TabIconFile, IsVisible, objTabPermissions, true);
        }

        /// <summary>
        /// AddModuleDefinition adds a new Core Module Definition to the system
        /// </summary>
        /// <remarks>
        ///	This overload asumes the module is an Admin module and not a Premium Module
        /// </remarks>
        ///	<param name="DesktopModuleName">The Friendly Name of the Module to Add</param>
        ///	<param name="Description">Description of the Module</param>
        ///	<param name="ModuleDefinitionName">The Module Definition Name</param>
        ///	<returns>The Module Definition Id of the new Module</returns>
        private static int AddModuleDefinition(string DesktopModuleName, string Description, string ModuleDefinitionName)
        {
            //Call overload with Premium=False and Admin=True
            return AddModuleDefinition(DesktopModuleName, Description, ModuleDefinitionName, false, true, Null.NullString, Null.NullString);
        }

        /// <summary>
        /// AddModuleDefinition adds a new Core Module Definition to the system
        /// </summary>
        /// <remarks>
        ///	This overload allows the caller to determine whether the module is an Admin module
        ///	or a Premium Module
        /// </remarks>
        ///	<param name="DesktopModuleName">The Friendly Name of the Module to Add</param>
        ///	<param name="Description">Description of the Module</param>
        ///	<param name="ModuleDefinitionName">The Module Definition Name</param>
        ///	<param name="Premium">A flag representing whether the module is a Premium module</param>
        ///	<param name="Admin">A flag representing whether the module is an Admin module</param>
        ///	<returns>The Module Definition Id of the new Module</returns>
        /// <history>
        /// 	[cnurse]	10/14/2004	documented
        ///     [cnurse]    11/11/2004  removed addition of Module Control (now in AddMOduleControl)
        /// </history>
        private static int AddModuleDefinition(string DesktopModuleName, string Description, string ModuleDefinitionName, bool Premium, bool Admin)
        {
            //Call overload with Controller=NulString and HelpUrl=NullString
            return AddModuleDefinition(DesktopModuleName, Description, ModuleDefinitionName, Premium, Admin, Null.NullString, Null.NullString);
        }

        /// <summary>
        /// AddModuleDefinition adds a new Core Module Definition to the system
        /// </summary>
        /// <remarks>
        ///	This overload allows the caller to determine whether the module has a controller
        /// class
        /// </remarks>
        ///	<param name="DesktopModuleName">The Friendly Name of the Module to Add</param>
        ///	<param name="Description">Description of the Module</param>
        ///	<param name="ModuleDefinitionName">The Module Definition Name</param>
        ///	<param name="Premium">A flag representing whether the module is a Premium module</param>
        ///	<param name="Admin">A flag representing whether the module is an Admin module</param>
        ///	<param name="Controller">The Controller Class string</param>
        ///	<returns>The Module Definition Id of the new Module</returns>
        /// <history>
        /// 	[cnurse]	10/14/2004	documented
        ///     [cnurse]    11/11/2004  removed addition of Module Control (now in AddMOduleControl)
        /// </history>
        private static int AddModuleDefinition(string DesktopModuleName, string Description, string ModuleDefinitionName, bool Premium, bool Admin, string Controller)
        {
            return AddModuleDefinition(DesktopModuleName, Description, ModuleDefinitionName, Premium, Admin, Controller, Null.NullString);
        }

        /// <summary>
        /// AddModuleDefinition adds a new Core Module Definition to the system
        /// </summary>
        /// <remarks>
        ///	This overload allows the caller to determine whether the module has a controller
        /// class
        /// </remarks>
        ///	<param name="DesktopModuleName">The Friendly Name of the Module to Add</param>
        ///	<param name="Description">Description of the Module</param>
        ///	<param name="ModuleDefinitionName">The Module Definition Name</param>
        ///	<param name="Premium">A flag representing whether the module is a Premium module</param>
        ///	<param name="Admin">A flag representing whether the module is an Admin module</param>
        ///	<param name="Controller">The Controller Class string</param>
        ///	<param name="Version">The Module Version</param>
        ///	<returns>The Module Definition Id of the new Module</returns>
        /// <history>
        /// 	[cnurse]	10/14/2004	documented
        ///     [cnurse]    11/11/2004  removed addition of Module Control (now in AddMOduleControl)
        /// </history>
        private static int AddModuleDefinition(string DesktopModuleName, string Description, string ModuleDefinitionName, bool Premium, bool Admin, string Controller, string Version)
        {
            DesktopModuleController objDesktopModules = new DesktopModuleController();

            // check if desktop module exists
            DesktopModuleInfo objDesktopModule = objDesktopModules.GetDesktopModuleByName(DesktopModuleName);
            if (objDesktopModule == null)
            {
                objDesktopModule = new DesktopModuleInfo();

                objDesktopModule.DesktopModuleID = Null.NullInteger;
                objDesktopModule.FriendlyName = DesktopModuleName;
                objDesktopModule.FolderName = DesktopModuleName;
                objDesktopModule.ModuleName = DesktopModuleName;
                objDesktopModule.Description = Description;
                objDesktopModule.Version = Version;
                objDesktopModule.IsPremium = Premium;
                objDesktopModule.IsAdmin = Admin;
                objDesktopModule.BusinessControllerClass = Controller;

                objDesktopModule.DesktopModuleID = objDesktopModules.AddDesktopModule(objDesktopModule);
            }

            ModuleDefinitionController objModuleDefinitions = new ModuleDefinitionController();

            // check if module definition exists
            ModuleDefinitionInfo objModuleDefinition = objModuleDefinitions.GetModuleDefinitionByName(objDesktopModule.DesktopModuleID, ModuleDefinitionName);
            if (objModuleDefinition == null)
            {
                objModuleDefinition = new ModuleDefinitionInfo();

                objModuleDefinition.ModuleDefID = Null.NullInteger;
                objModuleDefinition.DesktopModuleID = objDesktopModule.DesktopModuleID;
                objModuleDefinition.FriendlyName = ModuleDefinitionName;

                objModuleDefinition.ModuleDefID = objModuleDefinitions.AddModuleDefinition(objModuleDefinition);
            }

            return objModuleDefinition.ModuleDefID;
        }

        /// <summary>
        /// AddPage adds a Tab Page
        /// </summary>
        /// <remarks>
        /// Adds a Tab to a parentTab
        /// </remarks>
        ///	<param name="parentTab">The Parent Tab</param>
        ///	<param name="TabName">The Name to give this new Tab</param>
        ///	<param name="TabIconFile">The Icon for this new Tab</param>
        ///	<param name="IsVisible">A flag indicating whether the tab is visible</param>
        ///	<param name="permissions">Page Permissions Collection for this page</param>
        /// <param name="IsAdmin">Is an admin page</param>
        private static TabInfo AddPage(TabInfo parentTab, string TabName, string TabIconFile, bool IsVisible, TabPermissionCollection permissions, bool IsAdmin)
        {
            int ParentId = Null.NullInteger;
            int PortalId = Null.NullInteger;

            if (parentTab != null)
            {
                ParentId = parentTab.TabID;
                PortalId = parentTab.PortalID;
            }

            return AddPage(PortalId, ParentId, TabName, TabIconFile, IsVisible, permissions, IsAdmin);
        }

        /// <summary>
        /// AddPage adds a Tab Page
        /// </summary>
        ///	<param name="PortalId">The Id of the Portal</param>
        ///	<param name="ParentId">The Id of the Parent Tab</param>
        ///	<param name="TabName">The Name to give this new Tab</param>
        ///	<param name="TabIconFile">The Icon for this new Tab</param>
        ///	<param name="IsVisible">A flag indicating whether the tab is visible</param>
        ///	<param name="permissions">Page Permissions Collection for this page</param>
        /// <param name="IsAdmin">Is and admin page</param>
        private static TabInfo AddPage(int PortalId, int ParentId, string TabName, string TabIconFile, bool IsVisible, TabPermissionCollection permissions, bool IsAdmin)
        {
            TabController objTabs = new TabController();
            TabInfo objTab;

            objTab = objTabs.GetTabByName(TabName, PortalId, ParentId);
            if (objTab == null)
            {
                objTab = new TabInfo();
                objTab.TabID = Null.NullInteger;
                objTab.PortalID = PortalId;
                objTab.TabName = TabName;
                objTab.Title = "";
                objTab.Description = "";
                objTab.KeyWords = "";
                objTab.IsVisible = IsVisible;
                objTab.DisableLink = false;
                objTab.ParentId = ParentId;
                objTab.IconFile = TabIconFile;
                objTab.AdministratorRoles = Null.NullString;
                objTab.IsDeleted = false;
                objTab.TabPermissions = permissions;
                objTab.TabID = objTabs.AddTab(objTab, !IsAdmin);
            }

            return objTab;
        }

        /// <summary>
        /// AddPortal manages the Installation of a new SharpContent Portal
        /// </summary>
        /// <remarks>
        /// </remarks>
        public static int AddPortal(XmlNode node, bool status, int indent)
        {
            try
            {
                int intPortalId;
                string strHostPath = Globals.HostMapPath;
                string strChildPath = "";
                string strDomain = "";

                if (HttpContext.Current != null)
                {
                    strDomain = Globals.GetDomainName(HttpContext.Current.Request, true).Replace("/Install", "");
                }

                string strPortalName = XmlUtils.GetNodeValue(node, "portalname", "");
                if (status)
                {
                    HtmlUtils.WriteFeedback(HttpContext.Current.Response, indent, "Creating Portal: " + strPortalName + "<br>");
                }

                PortalController objPortalController = new PortalController();
                PortalSecurity objSecurity = new PortalSecurity();
                XmlNode adminNode = node.SelectSingleNode("administrator");
                string strFirstName = XmlUtils.GetNodeValue(adminNode, "firstname", "");
                string strLastName = XmlUtils.GetNodeValue(adminNode, "lastname", "");
                string strAccount = XmlUtils.GetNodeValue(adminNode, "account", "");
                string strUserName = XmlUtils.GetNodeValue(adminNode, "username", "");
                string strPassword = XmlUtils.GetNodeValue(adminNode, "password", "");
                string strQuestion = XmlUtils.GetNodeValue(adminNode, "question", "");
                string strAnswer = XmlUtils.GetNodeValue(adminNode, "answer", "");
                string strEmail = XmlUtils.GetNodeValue(adminNode, "email", "");
                string strDescription = XmlUtils.GetNodeValue(node, "description", "");
                string strKeyWords = XmlUtils.GetNodeValue(node, "keywords", "");
                string strTemplate = XmlUtils.GetNodeValue(node, "templatefile", "");
                string strServerPath = Globals.ApplicationMapPath + "\\";
                bool isChild = bool.Parse(XmlUtils.GetNodeValue(node, "ischild", ""));
                string strHomeDirectory = XmlUtils.GetNodeValue(node, "homedirectory", "");

                //Get the Portal Alias
                XmlNodeList portalAliases = node.SelectNodes("portalaliases/portalalias");
                string strPortalAlias = strDomain;
                if (portalAliases.Count > 0)
                {
                    if (portalAliases[0].InnerText != "")
                    {
                        strPortalAlias = portalAliases[0].InnerText;
                    }
                }

                //Create default email
                if (strEmail == "")
                {
                    strEmail = "admin@" + strDomain.Replace("www.", "");
                    //Remove any domain subfolder information ( if it exists )
                    if (strEmail.IndexOf("/") != -1)
                    {
                        strEmail = strEmail.Substring(0, strEmail.IndexOf("/"));
                    }
                }

                if (isChild)
                {

                    strChildPath = strPortalAlias.Substring(strPortalAlias.LastIndexOf("/") + 1 - 1);
                }

                //Create Portal
                intPortalId = objPortalController.CreatePortal(strPortalName, strFirstName, strLastName, strUserName, objSecurity.Encrypt(Convert.ToString(Globals.HostSettings["EncryptionKey"]), strPassword), strQuestion, strAnswer, strEmail, strDescription, strKeyWords, strHostPath, strTemplate, strHomeDirectory, strPortalAlias, strServerPath, strServerPath + strChildPath, isChild);                
                
                if (intPortalId > -1)
                {
                    //Add Extra Aliases
                    foreach (XmlNode portalAlias in portalAliases)
                    {
                        if (!String.IsNullOrEmpty(portalAlias.InnerText))
                        {
                            if (status)
                            {
                                HtmlUtils.WriteFeedback(HttpContext.Current.Response, indent, "Creating Portal Alias: " + portalAlias.InnerText + "<br>");
                            }
                            objPortalController.AddPortalAlias(intPortalId, portalAlias.InnerText);
                        }
                    }
                }

                return intPortalId;
            }
            catch (Exception ex)
            {
                HtmlUtils.WriteFeedback(HttpContext.Current.Response, indent, "<font color='red'>Error: " + ex.Message + "</font><br>");                
                return -1; // failure
            }
        }

        public static string BuildUserTable(IDataReader dr, string header, string message)
        {
            string strWarnings = Null.NullString;
            StringBuilder sbWarnings = new StringBuilder();
            bool hasRows = false;

            sbWarnings.Append("<h3>" + header + "</h3>");
            sbWarnings.Append("<p>" + message + "</p>");
            sbWarnings.Append("<table cellspacing='4' cellpadding='4' border='0'>");
            sbWarnings.Append("<tr>");
            sbWarnings.Append("<td class='NormalBold'>ID</td>");
            sbWarnings.Append("<td class='NormalBold'>UserName</td>");
            sbWarnings.Append("<td class='NormalBold'>First Name</td>");
            sbWarnings.Append("<td class='NormalBold'>Last Name</td>");
            sbWarnings.Append("<td class='NormalBold'>Email</td>");
            sbWarnings.Append("</tr>");
            while (dr.Read())
            {
                hasRows = true;
                sbWarnings.Append("<tr>");
                sbWarnings.Append("<td class='Norma'>" + dr.GetInt32(0) + "</td>");
                sbWarnings.Append("<td class='Norma'>" + dr.GetString(1) + "</td>");
                sbWarnings.Append("<td class='Norma'>" + dr.GetString(2) + "</td>");
                sbWarnings.Append("<td class='Norma'>" + dr.GetString(3) + "</td>");
                sbWarnings.Append("<td class='Norma'>" + dr.GetString(4) + "</td>");
                sbWarnings.Append("</tr>");
            }

            sbWarnings.Append("</table>");

            if (hasRows)
            {
                strWarnings = sbWarnings.ToString();
            }

            return strWarnings;
        }

        /// <summary>
        /// CheckUpgrade checks whether there are any possible upgrade issues
        /// </summary>
        public static string CheckUpgrade()
        {
            DataProvider dataProvider = DataProvider.Instance();
            IDataReader dr;
            string strWarnings = Null.NullString;

            try
            {
                dr = dataProvider.ExecuteReader("CheckUpgrade", null);

                strWarnings = BuildUserTable(dr, "Duplicate SuperUsers", "We have detected that the following SuperUsers have duplicate entries as Portal Users.  Although, no longer supported, these users may have been created in early Betas of SCP v3.0.  You need to be aware that after the upgrade, these users will only be able to log in using the Super User Account's password.");

                if (dr.NextResult())
                {
                    strWarnings += BuildUserTable(dr, "Duplicate Portal Users", "We have detected that the following Users have duplicate entries (they exist in more than one portal).  You need to be aware that after the upgrade, the password for some of these users may have been automatically changed (as the system now only uses one password per user, rather than one password per user per portal). It is important to remember that your Users can always retrieve their password using the Password Reminder feature, which will be sent to the Email addess shown in the table.");
                }
            }
            catch (SqlException ex)
            {
                strWarnings += ex.Message;
            }
            catch (Exception ex)
            {
                strWarnings += ex.Message;
            }

            try
            {
                dr = dataProvider.ExecuteReader("GetUserCount", null);
                dr.Read();
                int userCount = dr.GetInt32(0);
                double time = userCount / 10834;
                if (userCount > 1000)
                {
                    strWarnings += "<br/><h3>More than 1000 Users</h3><p>This SharpContent Database has " + userCount + " users. As the users and their profiles are transferred to a new format, it is estimated that the script will take ~" + time.ToString("F2") + " minutes to execute.</p>";
                }
            }
            catch (Exception ex)
            {
                strWarnings += "\r\n" + "\r\n" + ex.Message;
            }

            return strWarnings;
        }

        /// <summary>
        /// CoreModuleExists determines whether a Core Module exists on the system
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="DesktopModuleName">The Friendly Name of the Module</param>
        ///	<returns>True if the Module exists, otherwise False</returns>
        private static bool CoreModuleExists(string DesktopModuleName)
        {
            bool blnExists;

            DesktopModuleController objDesktopModules = new DesktopModuleController();

            DesktopModuleInfo objDesktopModule = objDesktopModules.GetDesktopModuleByName(DesktopModuleName);
            if (objDesktopModule != null)
            {
                blnExists = true;
            }
            else
            {
                blnExists = false;
            }

            return blnExists;
        }

        /// <summary>
        /// DeleteFiles - clean up deprecated files and folders
        /// </summary>
        /// <param name="strVersion">The Version being Upgraded</param>
        /// </remarks>
        private static string DeleteFiles(string strVersion)
        {

            string strExceptions = "";

            try
            {
                string strListFile = Globals.HostMapPath + strVersion + ".txt";

                if (File.Exists(strListFile))
                {
                    // read list file
                    StreamReader objStreamReader =File.OpenText(strListFile);
                    Array arrPaths = objStreamReader.ReadToEnd().Split(Environment.NewLine.ToCharArray());
                    objStreamReader.Close();

                    // loop through path list
                    foreach (string path in arrPaths)
                    {
                        string strPath = path;
                        if (strPath.Trim() != "")
                        {
                            strPath = Globals.ApplicationMapPath + "\\" + strPath;
                            if (strPath.EndsWith("\\"))
                            {
                                // folder
                                if (Directory.Exists(strPath))
                                {
                                    try // delete the folder
                                    {
                                        Globals.DeleteFolderRecursive(strPath);
                                    }
                                    catch (Exception ex)
                                    {
                                        strExceptions += "Error: " + ex.Message + Environment.NewLine;
                                    }
                                }
                            }
                            else
                            {
                                // file
                                if (File.Exists(strPath))
                                {
                                    try // delete the file
                                    {
                                        File.SetAttributes(strPath, FileAttributes.Normal);
                                        File.Delete(strPath);
                                    }
                                    catch (Exception ex)
                                    {
                                        strExceptions += "Error: " + ex.Message + Environment.NewLine;
                                    }
                                }
                            }
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                strExceptions += "Error: " + ex.Message + Environment.NewLine;
            }

            return strExceptions;

        }

        /// <summary>
        /// ExecuteScript executes a SQl script file
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="script">The script to Execute</param>
        ///	<param name="version">The script version</param>
        private static string ExecuteScript(string script, string version)
        {
            string strExceptions;

            // Get the name of the data provider
            ProviderConfiguration objProviderConfiguration = ProviderConfiguration.GetProviderConfiguration("data");

            // read script file for installation
            string strScriptFile = script;
            StreamReader objStreamReader;
            objStreamReader = File.OpenText(strScriptFile);
            string strScript = objStreamReader.ReadToEnd();
            objStreamReader.Close();

            // execute SQL installation script
            strExceptions = PortalSettings.ExecuteScript(strScript);

            //' perform version specific application upgrades
            if (!String.IsNullOrEmpty(version))
            {
                strExceptions += UpgradeApplication(version);

                // delete files which are no longer used
                strExceptions += DeleteFiles(version);
            }

            // log the results
            try
            {
                StreamWriter objStream;
                objStream = File.CreateText(strScriptFile.Replace("." + objProviderConfiguration.DefaultProvider + ".sql", "") + ".log");
                objStream.WriteLine(strExceptions);
                objStream.Close();
            }
            catch
            {
                // does not have permission to create the log file
            }

            return strExceptions;
        }

        /// <summary>
        /// GetModuleDefinition gets the Module Definition Id of a module
        /// </summary>
        ///	<param name="DesktopModuleName">The Friendly Name of the Module to Add</param>
        ///	<param name="ModuleDefinitionName">The Module Definition Name</param>
        ///	<returns>The Module Definition Id of the Module (-1 if no module definition)</returns>
        private static int GetModuleDefinition(string DesktopModuleName, string ModuleDefinitionName)
        {
            DesktopModuleController objDesktopModules = new DesktopModuleController();

            // get desktop module
            DesktopModuleInfo objDesktopModule = objDesktopModules.GetDesktopModuleByName(DesktopModuleName);
            if (objDesktopModule == null)
            {
                return -1;
            }

            ModuleDefinitionController objModuleDefinitions = new ModuleDefinitionController();

            // get module definition
            ModuleDefinitionInfo objModuleDefinition = objModuleDefinitions.GetModuleDefinitionByName(objDesktopModule.DesktopModuleID, ModuleDefinitionName);
            if (objModuleDefinition == null)
            {
                return -1;
            }

            return objModuleDefinition.ModuleDefID;
        }

        /// <summary>
        /// HostTabExists determines whether a tab of a given name exists under the Host tab
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="TabName">The Name of the Tab</param>
        ///	<returns>True if the Tab exists, otherwise False</returns>
        private static bool HostTabExists(string TabName)
        {
            bool blnExists;

            TabController objTabController = new TabController();

            TabInfo objTabInfo = objTabController.GetTabByName(TabName, Null.NullInteger);
            if (objTabInfo != null)
            {
                blnExists = true;
            }
            else
            {
                blnExists = false;
            }

            return blnExists;
        }       

        /// <summary>
        /// InstallMemberRoleProvider - Installs the MemberRole Provider Db objects
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="strProviderPath">The Path to the Provider Directory</param>
        ///	<param name="xmlDoc">The Portal Config Document</param>
        private static string InstallMemberRoleProvider(string strProviderPath, XmlDocument xmlDoc)
        {
            string strExceptions = "";
            StreamReader objStreamReader;
            string strScript;

            //Parse the script nodes
            XmlNode node = xmlDoc.SelectSingleNode("//SharpContent/MemberRoleProvider");
            if (node != null)
            {
                // Get the name of the data provider to start provider specific scripts
                ProviderConfiguration objProviderConfiguration = ProviderConfiguration.GetProviderConfiguration("data");

                // Loop through the available scripts
                foreach (XmlNode scriptNode in node.SelectNodes("script"))
                {
                    strScript = scriptNode.InnerText;
                    HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Installing Script: " + strScript);
                    //objStreamReader = File.OpenText(strProviderPath + strScript);
                    //strScript = objStreamReader.ReadToEnd();
                    //objStreamReader.Close();
                    strExceptions += ExecuteScript(strProviderPath + strScript, "");
                    HtmlUtils.WriteScriptSuccessError(HttpContext.Current.Response, (strExceptions.Trim() == ""), strProviderPath + strScript.Replace("." + objProviderConfiguration.DefaultProvider + ".sql", ".log"));
                }
            }
            //As we have just done an Install set the Upgrade Flag to false
            upgradeMemberShipProvider = false;

            return strExceptions;
        }

        /// <summary>
        /// UpgradeApplication - This overload is used for general application upgrade operations.
        /// </summary>
        /// <remarks>
        ///	Since it is not version specific and is invoked whenever the application is
        ///	restarted, the operations must be re-executable.
        /// </remarks>
        private static string UpgradeApplication()
        {
            string strExceptions = "";

            try
            {
                // remove the system message module from the admin tab
                // System Messages are now managed through Localization
                if (CoreModuleExists("System Messages"))
                {
                    RemoveCoreModule("System Messages", "Site Admin", "Site Settings", false);
                }

                // add the log viewer module to the admin tab
                int moduleDefId;
                if (CoreModuleExists("Log Viewer") == false)
                {
                    moduleDefId = AddModuleDefinition("Log Viewer", "Allows you to view log entries for portal events.", "Log Viewer");
                    AddModuleControl(moduleDefId, "", "", "Admin/Logging/LogViewer.ascx", "", SecurityAccessLevel.Admin, 0);
                    AddModuleControl(moduleDefId, "Edit", "Edit Log Settings", "Admin/Logging/EditLogTypes.ascx", "", SecurityAccessLevel.Host, 0);

                    //Add the Module/Page to all configured portals
                    AddAdminPages("Log Viewer", "icon_viewstats_16px.gif", true, moduleDefId, "Log Viewer", "icon_viewstats_16px.gif");
                }

                if (CoreModuleExists("Authentication") == false)
                {
                    moduleDefId = AddModuleDefinition("Windows Authentication", "Allows you to manage authentication settings for sites using Windows Authentication.", "Windows Authentication");
                    AddModuleControl(moduleDefId, "", "", "Admin/Security/AuthenticationSettings.ascx", "", SecurityAccessLevel.Admin, 0);

                    //Add the Module/Page to all configured portals
                    AddAdminPages("Authentication", "icon_authentication_16px.gif", true, moduleDefId, "Authentication", "icon_authentication_16px.gif");
                }

                // add the schedule module to the host tab
                TabInfo newPage;
                if (CoreModuleExists("Schedule") == false)
                {
                    moduleDefId = AddModuleDefinition("Schedule", "Allows you to schedule tasks to be run at specified intervals.", "Schedule");
                    AddModuleControl(moduleDefId, "", "", "Admin/Scheduling/ViewSchedule.ascx", "", SecurityAccessLevel.Admin, 0);
                    AddModuleControl(moduleDefId, "Edit", "Edit Schedule", "Admin/Scheduling/EditSchedule.ascx", "", SecurityAccessLevel.Host, 0);
                    AddModuleControl(moduleDefId, "History", "Schedule History", "Admin/Scheduling/ViewScheduleHistory.ascx", "", SecurityAccessLevel.Host, 0);
                    AddModuleControl(moduleDefId, "Status", "Schedule Status", "Admin/Scheduling/ViewScheduleStatus.ascx", "", SecurityAccessLevel.Host, 0);

                    //Create New Host Page (or get existing one)
                    newPage = AddHostPage("Schedule", "icon_scheduler_16px.gif", true);

                    //Add Module To Page
                    AddModuleToPage(newPage, moduleDefId, "Schedule", "icon_scheduler_16px.gif");
                }

                // add the skins module to the admin tab
                if (CoreModuleExists("Skins") == false)
                {
                    moduleDefId = AddModuleDefinition("Skins", "Allows you to manage your skins and containers.", "Skins");
                    AddModuleControl(moduleDefId, "", "", "Admin/Skins/EditSkins.ascx", "", SecurityAccessLevel.Admin, 0);

                    //Add the Module/Page to all configured portals
                    AddAdminPages("Skins", "icon_skins_16px.gif", true, moduleDefId, "Skins", "icon_skins_16px.gif");
                }

                // add the language editor module to the host tab
                if (!CoreModuleExists("Languages"))
                {
                    moduleDefId = AddModuleDefinition("Languages", "The Super User can manage the suported languages installed on the system.", "Languages");
                    AddModuleControl(moduleDefId, "", "", "Admin/Localization/Languages.ascx", "", SecurityAccessLevel.Host, 0);
                    AddModuleControl(moduleDefId, "TimeZone", "TimeZone Editor", "Admin/Localization/TimeZoneEditor.ascx", "", SecurityAccessLevel.Host, 0);
                    AddModuleControl(moduleDefId, "Language", "Language Editor", "Admin/Localization/LanguageEditor.ascx", "", SecurityAccessLevel.Host, 0);
                    AddModuleControl(moduleDefId, "FullEditor", "Language Editor", "Admin/Localization/LanguageEditorExt.ascx", "", SecurityAccessLevel.Host, 0);
                    AddModuleControl(moduleDefId, "Verify", "Resource File Verifier", "Admin/Localization/ResourceVerifier.ascx", "", SecurityAccessLevel.Host, 0);
                    AddModuleControl(moduleDefId, "Package", "Create Language Pack", "Admin/Localization/LanguagePack.ascx", "", SecurityAccessLevel.Host, 0);

                    //Create New Host Page (or get existing one)
                    newPage = AddHostPage("Languages", "icon_language_16px.gif", true);

                    //Add Module To Page
                    AddModuleToPage(newPage, moduleDefId, "Languages", "icon_language_16px.gif");

                    moduleDefId = AddModuleDefinition("Custom Locales", "Administrator can manage custom translations for portal.", "Custom Portal Locale");
                    AddModuleControl(moduleDefId, "", "", "Admin/Localization/LanguageEditor.ascx", "", SecurityAccessLevel.Admin, 0);
                    AddModuleControl(moduleDefId, "FullEditor", "Language Editor", "Admin/Localization/LanguageEditorExt.ascx", "", SecurityAccessLevel.Admin, 0);

                    //Add the Module/Page to all configured portals
                    AddAdminPages("Languages", "icon_language_16px.gif", true, moduleDefId, "Languages", "icon_language_16px.gif");
                }

                // add the Search Admin module to the host tab
                if (CoreModuleExists("Search Admin") == false)
                {
                    moduleDefId = AddModuleDefinition("Search Admin", "The Search Admininstrator provides the ability to manage search settings.", "Search Admin");
                    AddModuleControl(moduleDefId, "", "", "Admin/Search/SearchAdmin.ascx", "", SecurityAccessLevel.Host, 0);

                    //Create New Host Page (or get existing one)
                    newPage = AddHostPage("Search Admin", "icon_search_16px.gif", true);

                    //Add Module To Page
                    AddModuleToPage(newPage, moduleDefId, "Search Admin", "icon_search_16px.gif");

                    //Add the Module/Page to all configured portals
                    //AddAdminPages("Search Admin", "icon_search_16px.gif", True, ModuleDefID, "Search Admin", "icon_search_16px.gif")
                }

                // add the Search Input module
                if (CoreModuleExists("Search Input") == false)
                {
                    moduleDefId = AddModuleDefinition("Search Input", "The Search Input module provides the ability to submit a search to a given search results module.", "Search Input", false, false);
                    AddModuleControl(moduleDefId, "", "", "DesktopModules/SearchInput/SearchInput.ascx", "", SecurityAccessLevel.Anonymous, 0);
                    AddModuleControl(moduleDefId, "Settings", "Search Input Settings", "DesktopModules/SearchInput/Settings.ascx", "", SecurityAccessLevel.Edit, 0);
                }

                // add the Search Results module
                if (CoreModuleExists("Search Results") == false)
                {
                    moduleDefId = AddModuleDefinition("Search Results", "The Search Reasults module provides the ability to display search results.", "Search Results", false, false);
                    AddModuleControl(moduleDefId, "", "", "DesktopModules/SearchResults/SearchResults.ascx", "", SecurityAccessLevel.Anonymous, 0);
                    AddModuleControl(moduleDefId, "Settings", "Search Results Settings", "DesktopModules/SearchResults/Settings.ascx", "", SecurityAccessLevel.Edit, 0);

                    //Add the Search Module/Page to all configured portals
                    AddSearchResults(moduleDefId);
                }

                // add the site wizard module to the admin tab 
                if (CoreModuleExists("Site Wizard") == false)
                {
                    moduleDefId = AddModuleDefinition("Site Wizard", "The Administrator can use this user-friendly wizard to set up the common features of the Portal/Site.", "Site Wizard");
                    AddModuleControl(moduleDefId, "", "", "Admin/Portal/Sitewizard.ascx", "", SecurityAccessLevel.Admin, 0);
                    AddAdminPages("Site Wizard", "icon_sitesettings_16px.gif", true, moduleDefId, "Site Wizard", "icon_sitesettings_16px.gif");
                }

                // add portal alias module
                if (CoreModuleExists("Portal Aliases") == false)
                {
                    moduleDefId = AddModuleDefinition("Portal Aliases", "Allows you to view portal aliases.", "Portal Aliases");
                    AddModuleControl(moduleDefId, "", "", "Admin/Portal/PortalAlias.ascx", "", SecurityAccessLevel.Host, 0);
                    AddModuleControl(moduleDefId, "Edit", "Portal Aliases", "Admin/Portal/EditPortalAlias.ascx", "", SecurityAccessLevel.Host, 0);

                    //Add the Module/Page to all configured portals (with InheritViewPermissions = False)
                    AddAdminPages("Site Settings", "icon_sitesettings_16px.gif", false, moduleDefId, "Portal Aliases", "icon_sitesettings_16px.gif", false);
                }

                //add Lists module and tab
                if (HostTabExists("Lists") == false)
                {
                    moduleDefId = AddModuleDefinition("Lists", "Allows you to edit common lists.", "Lists");
                    AddModuleControl(moduleDefId, "", "", "Admin/Lists/ListEditor.ascx", "", SecurityAccessLevel.Host, 0);

                    //Create New Host Page (or get existing one)
                    newPage = AddHostPage("Lists", "icon_lists_16px.gif", true);

                    //Add Module To Page
                    AddModuleToPage(newPage, moduleDefId, "Lists", "icon_lists_16px.gif");
                }

                // add the feedback settings control
                if (CoreModuleExists("Feedback"))
                {
                    moduleDefId = GetModuleDefinition("Feedback", "Feedback");
                    AddModuleControl(moduleDefId, "Settings", "Feedback Settings", "DesktopModules/Feedback/Settings.ascx", "", SecurityAccessLevel.Edit, 0);
                }

                if (HostTabExists("Superuser Accounts") == false)
                {
                    //add SuperUser Accounts module and tab
                    DesktopModuleController objDesktopModuleController = new DesktopModuleController();
                    DesktopModuleInfo objDesktopModuleInfo;
                    objDesktopModuleInfo = objDesktopModuleController.GetDesktopModuleByName("User Accounts");
                    ModuleDefinitionController objModuleDefController = new ModuleDefinitionController();
                    moduleDefId = objModuleDefController.GetModuleDefinitionByName(objDesktopModuleInfo.DesktopModuleID, "User Accounts").ModuleDefID;

                    //Create New Host Page (or get existing one)
                    newPage = AddHostPage("Superuser Accounts", "icon_users_16px.gif", true);

                    //Add Module To Page
                    AddModuleToPage(newPage, moduleDefId, "Superuser Accounts", "icon_users_32px.gif");
                }

                //add Skins module and tab to Host menu
                if (HostTabExists("Skins") == false)
                {
                    DesktopModuleController objDesktopModuleController = new DesktopModuleController();
                    DesktopModuleInfo objDesktopModuleInfo;
                    objDesktopModuleInfo = objDesktopModuleController.GetDesktopModuleByName("Skins");
                    ModuleDefinitionController objModuleDefController = new ModuleDefinitionController();
                    moduleDefId = objModuleDefController.GetModuleDefinitionByName(objDesktopModuleInfo.DesktopModuleID, "Skins").ModuleDefID;

                    //Create New Host Page (or get existing one)
                    newPage = AddHostPage("Skins", "icon_skins_16px.gif", true);

                    //Add Module To Page
                    AddModuleToPage(newPage, moduleDefId, "Skins", "");
                }

                //Add Search Skin Object
                AddModuleControl(Null.NullInteger, "SEARCH", Null.NullString, "Admin/Skins/Search.ascx", "", SecurityAccessLevel.SkinObject, Null.NullInteger);

                //Add TreeView Skin Object
                AddModuleControl(Null.NullInteger, "TREEVIEW", Null.NullString, "Admin/Skins/TreeViewMenu.ascx", "", SecurityAccessLevel.SkinObject, Null.NullInteger);

                //Add Private Assembly Packager
                moduleDefId = GetModuleDefinition("Module Definitions", "Module Definitions");
                AddModuleControl(moduleDefId, "Package", "Create Private Assembly", "Admin/ModuleDefinitions/PrivateAssembly.ascx", "icon_moduledefinitions_32px.gif", SecurityAccessLevel.Edit, Null.NullInteger);

                //Add Edit Role Groups
                moduleDefId = GetModuleDefinition("Security Roles", "Security Roles");
                AddModuleControl(moduleDefId, "EditGroup", "Edit Role Groups", "Admin/Security/EditGroups.ascx", "icon_securityroles_32px.gif", SecurityAccessLevel.Edit, Null.NullInteger);
                AddModuleControl(moduleDefId, "UserSettings", "Manage User Settings", "Admin/Users/UserSettings.ascx", "~/images/settings.gif", SecurityAccessLevel.Edit, Null.NullInteger);

                //Add User Accounts Controls
                moduleDefId = GetModuleDefinition("User Accounts", "User Accounts");
                AddModuleControl(moduleDefId, "ManageProfile", "Manage Profile Definition", "Admin/Users/ProfileDefinitions.ascx", "icon_users_32px.gif", SecurityAccessLevel.Edit, Null.NullInteger);
                AddModuleControl(moduleDefId, "EditProfileProperty", "Edit Profile Property Definition", "Admin/Users/EditProfileDefinition.ascx", "icon_users_32px.gif", SecurityAccessLevel.Edit, Null.NullInteger);
                AddModuleControl(moduleDefId, "UserSettings", "Manage User Settings", "Admin/Users/UserSettings.ascx", "~/images/settings.gif", SecurityAccessLevel.Edit, Null.NullInteger);
                AddModuleControl(Null.NullInteger, "Profile", "Profile", "Admin/Users/ManageUsers.ascx", "icon_users_32px.gif", SecurityAccessLevel.Anonymous, Null.NullInteger);
                AddModuleControl(Null.NullInteger, "SendPassword", "Send Password", "Admin/Security/SendPassword.ascx", "", SecurityAccessLevel.Anonymous, Null.NullInteger);
                AddModuleControl(Null.NullInteger, "ViewProfile", "View Profile", "Admin/Users/ViewProfile.ascx", "icon_users_32px.gif", SecurityAccessLevel.Anonymous, Null.NullInteger);

                //Update Child Portal subHost.aspx
                PortalAliasController objAliasController = new PortalAliasController();
                ArrayList arrAliases = objAliasController.GetPortalAliasArrayByPortalID(Null.NullInteger);

                foreach (PortalAliasInfo objAlias in arrAliases)
                {
                    //For the alias to be for a child it must be of the form ...../child
                    if (objAlias.HTTPAlias.LastIndexOf("/") != -1)
                    {
                        string childPath = Globals.ApplicationMapPath + "\\" + objAlias.HTTPAlias.Substring(objAlias.HTTPAlias.LastIndexOf("/") + 1);
                        if (Directory.Exists(childPath))
                        {
                            //Folder exists App/child so upgrade

                            //Rename existing file
                            File.Copy(childPath + "\\" + Globals.glbDefaultPage, childPath + "\\old_" + Globals.glbDefaultPage, true);

                            // create the subhost default.aspx file
                            File.Copy(Globals.HostMapPath + "subhost.aspx", childPath + "\\" + Globals.glbDefaultPage, true);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                strExceptions += "Error: " + ex.Message + "\r\n";
                try
                {
                    Exceptions.Exceptions.LogException(ex);
                }
                catch
                {
                    // ignore
                }
            }

            return strExceptions;
        }

        /// <summary>
        /// UpgradeApplication - This overload is used for version specific application upgrade operations.
        /// </summary>
        /// <remarks>
        ///	This should be used for file system modifications or upgrade operations which
        ///	should only happen once. Database references are not recommended because future
        ///	versions of the application may result in code incompatibilties.
        /// </remarks>
        ///	<param name="Version">The Version being Upgraded</param>
        private static string UpgradeApplication(string Version)
        {
            string strExceptions = "";

            try
            {
                switch (Version)
                {
                    case "01.01.01": 
                        //This is the base version and there are not upgrade at this time
                        break;                    
                }
            }
            catch (Exception ex)
            {
                strExceptions += "Error: " + ex.Message + "\r\n";
                try
                {
                    Exceptions.Exceptions.LogException(ex);
                }
                catch
                {
                    // ignore
                }
            }

            return strExceptions;
        }

        /// <summary>
        /// AddAdminPages adds an Admin Page and an associated Module to all configured Portals
        /// </summary>
        ///	<param name="TabName">The Name to give this new Tab</param>
        ///	<param name="TabIconFile">The Icon for this new Tab</param>
        ///	<param name="IsVisible">A flag indicating whether the tab is visible</param>
        ///	<param name="ModuleDefId">The Module Deinition Id for the module to be aded to this tab</param>
        ///	<param name="ModuleTitle">The Module's title</param>
        ///	<param name="ModuleIconFile">The Module's icon</param>
        private static void AddAdminPages(string TabName, string TabIconFile, bool IsVisible, int ModuleDefId, string ModuleTitle, string ModuleIconFile)
        {
            //Call overload with InheritPermisions=True
            AddAdminPages(TabName, TabIconFile, IsVisible, ModuleDefId, ModuleTitle, ModuleIconFile, true);
        }

        /// <summary>
        /// AddAdminPages adds an Admin Page and an associated Module to all configured Portals
        /// </summary>
        ///	<param name="TabName">The Name to give this new Tab</param>
        ///	<param name="TabIconFile">The Icon for this new Tab</param>
        ///	<param name="IsVisible">A flag indicating whether the tab is visible</param>
        ///	<param name="ModuleDefId">The Module Deinition Id for the module to be aded to this tab</param>
        ///	<param name="ModuleTitle">The Module's title</param>
        ///	<param name="ModuleIconFile">The Module's icon</param>
        ///	<param name="InheritPermissions">Modules Inherit the Pages View Permisions</param>
        private static void AddAdminPages(string TabName, string TabIconFile, bool IsVisible, int ModuleDefId, string ModuleTitle, string ModuleIconFile, bool InheritPermissions)
        {
            PortalController objPortals = new PortalController();
            ArrayList arrPortals = objPortals.GetPortals();
            int intPortal;

            //Add Page to Admin Menu of all configured Portals
            for (intPortal = 0; intPortal <= arrPortals.Count - 1; intPortal++)
            {
                PortalInfo objPortal = (PortalInfo)arrPortals[intPortal];

                //Create New Admin Page (or get existing one)
                TabInfo newPage = AddAdminPage(objPortal, TabName, TabIconFile, IsVisible);

                //Add Module To Page
                AddModuleToPage(newPage, ModuleDefId, ModuleTitle, ModuleIconFile, InheritPermissions);
            }
        }

        /// <summary>
        /// AddModuleControl adds a new Module Control to the system
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="ModuleDefId">The Module Definition Id</param>
        ///	<param name="ControlKey">The key for this control in the Definition</param>
        ///	<param name="ControlTitle">The title of this control</param>
        ///	<param name="ControlSrc">Te source of ths control</param>
        ///	<param name="IconFile">The icon file</param>
        ///	<param name="ControlType">The type of control</param>
        ///	<param name="ViewOrder">The vieworder for this module</param>
        private static void AddModuleControl(int ModuleDefId, string ControlKey, string ControlTitle, string ControlSrc, string IconFile, SecurityAccessLevel ControlType, int ViewOrder)
        {
            //Call Overload with HelpUrl = Null.NullString
            AddModuleControl(ModuleDefId, ControlKey, ControlTitle, ControlSrc, IconFile, ControlType, ViewOrder, Null.NullString);
        }

        /// <summary>
        /// AddModuleControl adds a new Module Control to the system
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="ModuleDefId">The Module Definition Id</param>
        ///	<param name="ControlKey">The key for this control in the Definition</param>
        ///	<param name="ControlTitle">The title of this control</param>
        ///	<param name="ControlSrc">Te source of ths control</param>
        ///	<param name="IconFile">The icon file</param>
        ///	<param name="ControlType">The type of control</param>
        ///	<param name="ViewOrder">The vieworder for this module</param>
        ///	<param name="HelpURL">The Help Url</param>
        private static void AddModuleControl(int ModuleDefId, string ControlKey, string ControlTitle, string ControlSrc, string IconFile, SecurityAccessLevel ControlType, int ViewOrder, string HelpURL)
        {
            ModuleControlController objModuleControls = new ModuleControlController();

            // check if module control exists
            ModuleControlInfo objModuleControl = objModuleControls.GetModuleControlByKeyAndSrc(ModuleDefId, ControlKey, ControlSrc);
            if (objModuleControl == null)
            {
                objModuleControl = new ModuleControlInfo();

                objModuleControl.ModuleControlID = Null.NullInteger;
                objModuleControl.ModuleDefID = ModuleDefId;
                objModuleControl.ControlKey = ControlKey;
                objModuleControl.ControlTitle = ControlTitle;
                objModuleControl.ControlSrc = ControlSrc;
                objModuleControl.ControlType = ControlType;
                objModuleControl.ViewOrder = ViewOrder;
                objModuleControl.IconFile = IconFile;
                objModuleControl.HelpURL = HelpURL;

                objModuleControls.AddModuleControl(objModuleControl);
            }
        }

        /// <summary>
        /// AddModuleToPage adds a module to a Page
        /// </summary>
        /// <remarks>
        /// This overload assumes ModulePermissions will be inherited
        /// </remarks>
        ///	<param name="page">The Page to add the Module to</param>
        ///	<param name="ModuleDefId">The Module Deinition Id for the module to be aded to this tab</param>
        ///	<param name="ModuleTitle">The Module's title</param>
        ///	<param name="ModuleIconFile">The Module's icon</param>
        private static void AddModuleToPage(TabInfo page, int ModuleDefId, string ModuleTitle, string ModuleIconFile)
        {
            //Call overload with InheritPermisions=True
            AddModuleToPage(page, ModuleDefId, ModuleTitle, ModuleIconFile, true);
        }

        /// <summary>
        /// AddModuleToPage adds a module to a Page
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="page">The Page to add the Module to</param>
        ///	<param name="ModuleDefId">The Module Deinition Id for the module to be aded to this tab</param>
        ///	<param name="ModuleTitle">The Module's title</param>
        ///	<param name="ModuleIconFile">The Module's icon</param>
        ///	<param name="InheritPermissions">Inherit the Pages View Permisions</param>
        private static void AddModuleToPage(TabInfo page, int ModuleDefId, string ModuleTitle, string ModuleIconFile, bool InheritPermissions)
        {
            ModuleController objModules = new ModuleController();
            ModuleInfo objModule;

            bool blnDuplicate = false;
            foreach (KeyValuePair<int, ModuleInfo> kvp in objModules.GetTabModules(page.TabID))
            {
                objModule = kvp.Value;
                if (objModule.ModuleDefID == ModuleDefId)
                {
                    blnDuplicate = true;
                }
            }

            if (!blnDuplicate)
            {
                objModule = new ModuleInfo();
                objModule.ModuleID = Null.NullInteger;
                objModule.PortalID = page.PortalID;
                objModule.TabID = page.TabID;
                objModule.ModuleOrder = -1;
                objModule.ModuleTitle = ModuleTitle;
                objModule.PaneName = Globals.glbDefaultPane;
                objModule.ModuleDefID = ModuleDefId;
                objModule.CacheTime = 0;
                objModule.IconFile = ModuleIconFile;
                objModule.AllTabs = false;
                objModule.Visibility = VisibilityState.Maximized;
                objModule.InheritViewPermissions = InheritPermissions;

                try
                {
                    objModules.AddModule(objModule);
                }
                catch
                {
                    // error adding module
                }
            }
        }

        /// <summary>
        /// AddPagePermission adds a TabPermission to a TabPermission Collection
        /// </summary>
        ///	<param name="permissions">Page Permissions Collection for this page</param>
        ///	<param name="key">The Permission key</param>
        ///	<param name="roleId">The role given the permission</param>
        private static void AddPagePermission(ref TabPermissionCollection permissions, string key, int roleId)
        {
            PermissionController objPermissionController = new PermissionController();
            PermissionInfo objPermission = (PermissionInfo)objPermissionController.GetPermissionByCodeAndKey("SYSTEM_TAB", key)[0];

            TabPermissionInfo objTabPermission = new TabPermissionInfo();
            objTabPermission.PermissionID = objPermission.PermissionID;
            objTabPermission.RoleID = roleId;
            objTabPermission.AllowAccess = true;
            permissions.Add(objTabPermission);
        }

        /// <summary>
        /// AddSearchResults adds a top level Hidden Search Results Page
        /// </summary>
        ///	<param name="ModuleDefId">The Module Deinition Id for the Search Results Module</param>
        private static void AddSearchResults(int ModuleDefId)
        {
            PortalController objPortals = new PortalController();
            ArrayList arrPortals = objPortals.GetPortals();
            int intPortal;

            //Add Page to Admin Menu of all configured Portals
            for (intPortal = 0; intPortal <= arrPortals.Count - 1; intPortal++)
            {
                TabPermissionCollection objTabPermissions = new TabPermissionCollection();

                PortalInfo objPortal = (PortalInfo)arrPortals[intPortal];

                AddPagePermission(ref objTabPermissions, "View", Convert.ToInt32(Globals.glbRoleAllUsers));
                AddPagePermission(ref objTabPermissions, "View", Convert.ToInt32(objPortal.AdministratorRoleId));
                AddPagePermission(ref objTabPermissions, "Edit", Convert.ToInt32(objPortal.AdministratorRoleId));

                //Create New Page (or get existing one)
                TabInfo newPage = AddPage(objPortal.PortalID, Null.NullInteger, "Search Results", "", false, objTabPermissions, false);

                //Add Module To Page
                AddModuleToPage(newPage, ModuleDefId, "Search Results", "");
            }
        }

        /// <summary>
        /// ExecuteScript executes a special script
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="strFile">The script file to execute</param>
        public static void ExecuteScript(string strFile)
        {
            // Get the name of the data provider
            ProviderConfiguration objProviderConfiguration = ProviderConfiguration.GetProviderConfiguration("data");

            //Execute if script is a provider script
            if (strFile.IndexOf("." + objProviderConfiguration.DefaultProvider) != -1)
            {
                HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Executing Script: " + strFile + "<br>");
                ExecuteScript(strFile, "");
            }
        }

        /// <summary>
        /// ExecuteScripts manages the Execution of Scripts from the Install/Scripts folder.
        /// It is also triggered by InstallSCP and UpgradeSCP
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="strProviderPath">The path to the Data Provider</param>
        public static void ExecuteScripts(string strProviderPath)
        {
            // Get the name of the data provider
            ProviderConfiguration objProviderConfiguration = ProviderConfiguration.GetProviderConfiguration("data");

            string ScriptPath = Globals.ApplicationMapPath + "\\Install\\Scripts\\";
            if (Directory.Exists(ScriptPath))
            {
                string[] arrFiles = Directory.GetFiles(ScriptPath);
                foreach (string tempLoopVar_strFile in arrFiles)
                {
                    string strFile = tempLoopVar_strFile;
                    //Execute if script is a provider script
                    if (strFile.IndexOf("." + objProviderConfiguration.DefaultProvider) != -1)
                    {
                        HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Executing Script: " + strFile + "<br>");
                        ExecuteScript(strFile, "");
                        // delete the file
                        try
                        {
                            File.SetAttributes(strFile, FileAttributes.Normal);
                            File.Delete(strFile);
                        }
                        catch
                        {
                            // error removing the file
                        }
                    }
                }
            }
        }

        /// <summary>
        /// InstallSCP manages the Installation of a new SharpContent Application
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="strProviderPath">The path to the Data Provider</param>
        public static void InstallSCP(string strProviderPath, int installStep)
        {
            string strExceptions = "";
            string strHostPath = Globals.HostMapPath;
            XmlDocument xmlDoc = new XmlDocument();
            string strVersion = "";
            string strScript = "";
            string strLogFile = "";
            string strErrorMessage = "";

            // get current App version from constant (Medium Trust)
            string strAssemblyVersion = Globals.glbAppVersion.Replace(".", "");

            // open the Install Template XML file
            string installTemplate = Config.GetSetting("InstallTemplate");
            try
            {
                xmlDoc.Load(Globals.ApplicationMapPath + "\\Install\\" + installTemplate);
            }
            catch // error
            {
                strErrorMessage += "Failed to load Install template.<br><br>";
            }

            if (strErrorMessage == "")
            {
                // parse host nodes
                XmlNode node = xmlDoc.SelectSingleNode("//SharpContent");
                if (node != null)
                {
                    strVersion = XmlUtils.GetNodeValue(node, "version", "");
                }
                Array arrVersion = strVersion.Split(Convert.ToChar("."));
                int intMajor = Convert.ToInt32(arrVersion.GetValue(0));
                int intMinor = Convert.ToInt32(arrVersion.GetValue(1));
                int intBuild = Convert.ToInt32(arrVersion.GetValue(2));

                ResourceInstaller objResourceInstaller = new ResourceInstaller();                

                switch (installStep)
                {
                    case 0:

                        //Output feedback line
                        HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Installing Version: " + intMajor + "." + intMinor + "." + intBuild + "<br>");

                        //Parse the script nodes
                        node = xmlDoc.SelectSingleNode("//SharpContent/scripts");
                        if (node != null)
                        {
                            // Get the name of the data provider to start provider specific scripts
                            ProviderConfiguration objProviderConfiguration = ProviderConfiguration.GetProviderConfiguration("data");

                            //Output the Default Provider
                            HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "DataProvider: " + objProviderConfiguration.DefaultProvider + "<br>");

                            // Loop through the available scripts
                            foreach (XmlNode scriptNode in node.SelectNodes("script"))
                            {
                                strScript = scriptNode.InnerText + "." + objProviderConfiguration.DefaultProvider + ".sql";
                                HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Installing Script: " + strScript);
                                strExceptions += ExecuteScript(strProviderPath + strScript, "");
                                HtmlUtils.WriteScriptSuccessError(HttpContext.Current.Response, (strExceptions == ""), strProviderPath + strScript.Replace("." + objProviderConfiguration.DefaultProvider + ".sql", ".log"));
                            }
                        }

                        //Optionally Install the memberRoleProvider
                        bool installMemberRole = true;
                        if (Config.GetSetting("InstallMemberRole") != null)
                        {
                            installMemberRole = bool.Parse(Config.GetSetting("InstallMemberRole"));
                        }
                        if (installMemberRole)
                        {
                            HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Installing MemberRole Provider:<br>");
                            strExceptions += InstallMemberRoleProvider(strProviderPath, xmlDoc);
                        }

                        // update the version
                        PortalSettings.UpdateDatabaseVersion(intMajor, intMinor, intBuild);

                        //Call Upgrade with the current DB Version to carry out any incremental upgrades
                        UpgradeSCP(strProviderPath, strVersion.Replace(".", ""));

                        // parse Host Settings if available
                        node = xmlDoc.SelectSingleNode("//SharpContent/settings");
                        if (node != null)
                        {
                            HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Loading Host Settings:<br>");
                            ParseSettings(node);
                        }                        

                        // parse SuperUser if Available
                        node = xmlDoc.SelectSingleNode("//SharpContent/superuser");
                        if (node != null)
                        {
                            HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Configuring SuperUser:<br>");
                            ParseSuperUser(node);
                        }

                        // parse File List if available
                        node = xmlDoc.SelectSingleNode("//SharpContent/files");
                        if (node != null)
                        {
                            HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Loading Host Files:<br>");
                            ParseFiles(node, Null.NullInteger);

                        }
                        
                        break;

                    case 1: 

                        //Install modules if present
                        HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Installing Modules:<br>");
                        objResourceInstaller.Install(true, 2, "modules");

                        //Run any addition scripts in the Scripts folder
                        HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Executing Additional Scripts:<br>");
                        ExecuteScripts(strProviderPath);

                        break;

                    case 2:

                        // parse portal(s) if available
                        XmlNodeList nodes = xmlDoc.SelectNodes("//SharpContent/portals/portal");
                        foreach (XmlNode tempLoopVar_node in nodes)
                        {
                            node = tempLoopVar_node;
                            if (node != null)
                            {
                                int intPortalId = AddPortal(node, true, 0);
                                if (intPortalId > -1)
                                {
                                    HtmlUtils.WriteFeedback(HttpContext.Current.Response, 2, "<font color='green'>Successfully Installed Portal " + intPortalId + ":</font><br>");
                                }
                                else
                                {
                                    HtmlUtils.WriteFeedback(HttpContext.Current.Response, 2, "<font color='red'>Portal failed to install:Error!</font><br>");
                                }
                            }
                        }

                        //Install optional resources if present
                        HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Installing Optional Resources:<br>");
                        objResourceInstaller.Install(true, 2);                        

                        break;

                }

                // We do not need to reload the page if we have completed the last step.
                if (installStep < 2)
                {
                    // Send a new request to the application to initiate the next step
                    string url = HttpContext.Current.Request.RawUrl.Replace("&step=" + installStep, "");
                    HttpContext.Current.Response.Write("<br><br><h2><a href='" + url + "&step=" + (installStep + 1) + "'> Next >> </a></h2><br><br>");
                    HttpContext.Current.Response.End();
                }
            }
            else
            {
                // upgrade error
                StreamReader objStreamReader;
                objStreamReader = File.OpenText(HttpContext.Current.Server.MapPath("~/500.htm"));
                string strHTML = objStreamReader.ReadToEnd();
                objStreamReader.Close();
                strHTML = strHTML.Replace("[MESSAGE]", strErrorMessage);
                if (HttpContext.Current != null)
                {
                    HttpContext.Current.Response.Write(strHTML);
                    HttpContext.Current.Response.End();
                }
            }
        }

        /// <summary>
        /// ParseDesktopModules parses the Host Template's Desktop Modules node
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="node">The Desktop Modules node</param>
        private static void ParseDesktopModules(XmlNode node)
        {
            //TODO - This method is obsolete since the modules are now seperated from the core
            SecurityAccessLevel controlType = SecurityAccessLevel.View;

            // Parse the desktopmodule nodes
            foreach (XmlNode tempLoopVar_desktopModuleNode in node.SelectNodes("desktopmodule"))
            {
                XmlNode desktopModuleNode = tempLoopVar_desktopModuleNode;
                string strDescription = XmlUtils.GetNodeValue(desktopModuleNode, "description", "");
                string strVersion = XmlUtils.GetNodeValue(desktopModuleNode, "version", "");
                string strControllerClass = XmlUtils.GetNodeValue(desktopModuleNode, "businesscontrollerclass", "");

                // Parse the module nodes
                foreach (XmlNode tempLoopVar_moduleNode in desktopModuleNode.SelectNodes("modules/module"))
                {
                    XmlNode moduleNode = tempLoopVar_moduleNode;
                    string strName = XmlUtils.GetNodeValue(moduleNode, "friendlyname", "");

                    HtmlUtils.WriteFeedback(HttpContext.Current.Response, 2, "Installing " + strName + ":<br>");
                    int ModuleDefID = AddModuleDefinition(strName, strDescription, strName, false, false, strControllerClass, strVersion);

                    // Parse the control nodes
                    foreach (XmlNode tempLoopVar_controlNode in moduleNode.SelectNodes("controls/control"))
                    {
                        XmlNode controlNode = tempLoopVar_controlNode;
                        string strKey = XmlUtils.GetNodeValue(controlNode, "key", "");
                        string strTitle = XmlUtils.GetNodeValue(controlNode, "title", "");
                        string strSrc = XmlUtils.GetNodeValue(controlNode, "src", "");
                        string strIcon = XmlUtils.GetNodeValue(controlNode, "iconfile", "");
                        string strType = XmlUtils.GetNodeValue(controlNode, "type", "");
                        switch (XmlUtils.GetNodeValue(controlNode, "type", ""))
                        {
                            case "View":

                                controlType = SecurityAccessLevel.View;
                                break;
                            case "Edit":

                                controlType = SecurityAccessLevel.Edit;
                                break;
                        }
                        string strHelpUrl = XmlUtils.GetNodeValue(controlNode, "helpurl", "");

                        //Add Control to System
                        AddModuleControl(ModuleDefID, strKey, strTitle, strSrc, strIcon, controlType, 0, strHelpUrl);
                    }
                }
            }
        }

        /// <summary>
        /// ParseFiles parses the Host Template's Files node
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="node">The Files node</param>
        ///	<param name="portalId">The PortalId (-1 for Host Files)</param>
        private static void ParseFiles(XmlNode node, int portalId)
        {
            FileController objController = new FileController();

            //Parse the File nodes
            foreach (XmlNode tempLoopVar_fileNode in node.SelectNodes("file"))
            {
                XmlNode fileNode = tempLoopVar_fileNode;
                string strFileName = XmlUtils.GetNodeValue(fileNode, "filename", "");
                string strExtenstion = XmlUtils.GetNodeValue(fileNode, "extension", "");
                long fileSize = long.Parse(XmlUtils.GetNodeValue(fileNode, "size", ""));
                int iWidth = XmlUtils.GetNodeValueInt(fileNode, "width", 0);
                int iHeight = XmlUtils.GetNodeValueInt(fileNode, "height", 0);
                string strType = XmlUtils.GetNodeValue(fileNode, "contentType", "");
                string strFolder = XmlUtils.GetNodeValue(fileNode, "folder", "");

                FolderController objFolders = new FolderController();
                FolderInfo objFolder = objFolders.GetFolder(portalId, strFolder);
                objController.AddFile(portalId, strFileName, strExtenstion, fileSize, iWidth, iHeight, strType, strFolder, objFolder.FolderID, true);
            }
        }

        /// <summary>
        /// ParseSettings parses the Host Template's Settings node
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="node">The settings node</param>
        private static void ParseSettings(XmlNode node)
        {
            HostSettingsController objController = new HostSettingsController();

            //Parse the Settings nodes
            foreach (XmlNode tempLoopVar_settingNode in node.ChildNodes)
            {
                XmlNode settingNode = tempLoopVar_settingNode;
                string strSettingName = settingNode.Name;
                string strSettingValue = settingNode.InnerText;
                XmlAttribute SecureAttrib = settingNode.Attributes["Secure"];
                bool SettingIsSecure = false;
                if (SecureAttrib != null)
                {
                    if (SecureAttrib.Value.ToLower() == "true")
                    {
                        SettingIsSecure = true;
                    }
                }

                string strDomainName = Globals.GetDomainName(HttpContext.Current.Request);

                switch (strSettingName)
                {
                    case "HostURL":

                        if (strSettingValue == "")
                        {
                            strSettingValue = strDomainName;
                        }
                        break;
                    case "HostEmail":

                        if (strSettingValue == "")
                        {
                            strSettingValue = "support@" + strDomainName;

                            //Remove any folders
                            strSettingValue = strSettingValue.Substring(0, strSettingValue.IndexOf("/"));
                        }
                        break;
                }

                objController.UpdateHostSetting(strSettingName, strSettingValue, SettingIsSecure);
            }
            //Need to clear the cache to pick up new HostSettings from the SQLDataProvider script
            DataCache.RemoveCache("GetHostSettings");
        }

        /// <summary>
        /// ParseSuperUser parses the Host Template's SuperUser node
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="node">The SuperUser node</param>
        private static void ParseSuperUser(XmlNode node)
        {
            //Parse the SuperUsers nodes
            string strFirstName = XmlUtils.GetNodeValue(node, "firstname", "");
            string strLastName = XmlUtils.GetNodeValue(node, "lastname", "");
            string strAccount = XmlUtils.GetNodeValue(node, "account", "");
            string strUserName = XmlUtils.GetNodeValue(node, "username", "");
            string strPassword = XmlUtils.GetNodeValue(node, "password", "");
            string strQuestion = XmlUtils.GetNodeValue(node, "question", "");
            string strAnswer = XmlUtils.GetNodeValue(node, "answer", "");
            string strEmail = XmlUtils.GetNodeValue(node, "email", "");
            string strLocale = XmlUtils.GetNodeValue(node, "locale", "");
            int timeZone = XmlUtils.GetNodeValueInt(node, "timezone", 0);

            UserInfo objSuperUserInfo = new UserInfo();
            objSuperUserInfo.PortalID = -1;
            objSuperUserInfo.FirstName = strFirstName;
            objSuperUserInfo.LastName = strLastName;
            objSuperUserInfo.Username = strUserName;
            objSuperUserInfo.DisplayName = strFirstName + " " + strLastName;
            objSuperUserInfo.Membership.Password = strPassword;
            objSuperUserInfo.Membership.PasswordQuestion = strQuestion;
            objSuperUserInfo.Membership.PasswordAnswer = strAnswer;
            objSuperUserInfo.Email = strEmail;
            objSuperUserInfo.IsSuperUser = true;
            objSuperUserInfo.Membership.Approved = true;

            objSuperUserInfo.Profile.FirstName = strFirstName;
            objSuperUserInfo.Profile.LastName = strLastName;
            objSuperUserInfo.Profile.PreferredLocale = strLocale;
            objSuperUserInfo.Profile.TimeZone = timeZone;

            UserController.CreateUser(ref objSuperUserInfo);
        }

        /// <summary>
        /// RemoveCoreModule removes a Core Module from the system
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="DesktopModuleName">The Friendly Name of the Module to Remove</param>
        ///	<param name="ParentTabName">The Name of the parent Tab/Page for this module</param>
        ///	<param name="TabName">The Name to tab that contains the Module</param>
        ///	<param name="TabRemove">A flag to determine whether to remove the Tab if it has no
        ///	other modules</param>
        private static void RemoveCoreModule(string DesktopModuleName, string ParentTabName, string TabName, bool TabRemove)
        {
            TabController objTabs = new TabController();
            ModuleController objModules = new ModuleController();
            int intIndex;
            int intModuleDefId = 0;
            int intDesktopModuleId;

            //Find and remove the Module from the Tab
            switch (ParentTabName)
            {
                case "Host":
                    //TODO - when we have a need to remove a Host Module
                    break;
                case "Site Admin":
                    PortalController objPortals = new PortalController();

                    ArrayList arrPortals = objPortals.GetPortals();                  

                    //Iterate through the Portals to remove the Module from the Tab
                    for (int intPortal = 0; intPortal < arrPortals.Count; intPortal++)
                    {
                        PortalInfo objPortal = (PortalInfo)(arrPortals[intPortal]);

                        int ParentId = objPortal.AdminTabId;
                        TabInfo objTab = objTabs.GetTabByName(TabName, objPortal.PortalID, ParentId);
                        int intCount = 0;

                        //Get the Modules on the Tab
                        foreach (KeyValuePair<int, ModuleInfo> kvp in objModules.GetTabModules(objTab.TabID))
                        {
                            ModuleInfo objModule = kvp.Value;
                            if (objModule.FriendlyName == DesktopModuleName)
                            {
                                //Delete the Module from the Modules list
                                objModules.DeleteModule(objModule.ModuleID);
                                intModuleDefId = objModule.ModuleDefID;
                            }
                            else
                            {
                                intCount += 1;
                            }
                        }

                        //If Tab has no modules optionally remove tab
                        if (intCount == 0 & TabRemove)
                        {
                            objTabs.DeleteTab(objTab.TabID, objTab.PortalID);
                        }
                    }
                    break;
            }

            //Delete all the Module Controls for this Definition
            ModuleControlController objModuleControls = new ModuleControlController();
            ArrayList arrModuleControls = objModuleControls.GetModuleControls(intModuleDefId);
            for (intIndex = 0; intIndex <= arrModuleControls.Count - 1; intIndex++)
            {
                ModuleControlInfo objModuleControl = (ModuleControlInfo)arrModuleControls[intIndex];
                objModuleControls.DeleteModuleControl(objModuleControl.ModuleControlID);
            }

            //Get the Module Definition
            ModuleDefinitionController objModuleDefinitions = new ModuleDefinitionController();
            ModuleDefinitionInfo objModuleDefinition;
            objModuleDefinition = objModuleDefinitions.GetModuleDefinition(intModuleDefId);
            intDesktopModuleId = objModuleDefinition.DesktopModuleID;

            //Delete the Module Definition
            objModuleDefinitions.DeleteModuleDefinition(intModuleDefId);

            //Delete the Desktop Module Control
            DesktopModuleController objDesktopModules = new DesktopModuleController();
            objDesktopModules.DeleteDesktopModule(intDesktopModuleId);
        }

        public static void StartTimer()
        {
            //Start Upgrade Timer
            startTime = DateTime.Now;
        }

        /// <summary>
        /// UpgradeSCP manages the Upgrade of an exisiting SharpContent Application
        /// </summary>
        /// <remarks>
        /// </remarks>
        ///	<param name="strProviderPath">The path to the Data Provider</param>
        ///	<param name="strDatabaseVersion">The current Database Version</param>
        /// <history>
        /// 	[cnurse]	11/06/2004	created (Upgrade code extracted from AutoUpgrade)
        ///     [cnurse]    11/10/2004  version specific upgrades extracted to ExecuteScript
        ///     [cnurse]    01/20/2005  changed to Public so Upgrade can be manually controlled
        /// </history>
        public static void UpgradeSCP(string strProviderPath, string strDatabaseVersion)
        {
            string strExceptions;

            // get current App version from constant (Medium Trust)
            string strAssemblyVersion = Globals.glbAppVersion.Replace(".", "");

            // Get the name of the data provider
            ProviderConfiguration objProviderConfiguration = ProviderConfiguration.GetProviderConfiguration("data");

            // get list of script files
            string strScriptVersion;
            ArrayList arrScriptFiles = new ArrayList();
            string[] arrFiles = Directory.GetFiles(strProviderPath, "*." + objProviderConfiguration.DefaultProvider);
            foreach (string strFile in arrFiles)
            {
                // script file name must conform to ##.##.##.DefaultProviderName
                if (Path.GetFileName(strFile).Length == 9 + objProviderConfiguration.DefaultProvider.Length)
                {
                    strScriptVersion = Path.GetFileNameWithoutExtension(strFile);
                    // check if script file is relevant for upgrade
                    if (Convert.ToInt32(strScriptVersion.Replace(".", "")) > Convert.ToInt32(strDatabaseVersion) && Convert.ToInt32(strScriptVersion.Replace(".", "")) <= Convert.ToInt32(strAssemblyVersion))
                    {
                        arrScriptFiles.Add(strFile);
                    }
                }
            }
            
            arrScriptFiles.Sort();
            
            foreach (string strScriptFile in arrScriptFiles)
            {                
                strScriptVersion = Path.GetFileNameWithoutExtension(strScriptFile);

                Array arrVersion = strScriptVersion.Split(Convert.ToChar("."));
                int intMajor = Convert.ToInt32(arrVersion.GetValue(0));
                int intMinor = Convert.ToInt32(arrVersion.GetValue(1));
                int intBuild = Convert.ToInt32(arrVersion.GetValue(2));

                HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Upgrading to Version: " + intMajor + "." + intMinor + "." + intBuild);

                // verify script has not already been run
                if (!PortalSettings.FindDatabaseVersion(intMajor, intMinor, intBuild))
                {
                    // upgrade database schema
                    PortalSettings.UpgradeDatabaseSchema(intMajor, intMinor, intBuild);

                    // execute script file (and version upgrades) for version
                    strExceptions = ExecuteScript(strScriptFile, strScriptVersion);
                    HtmlUtils.WriteScriptSuccessError(HttpContext.Current.Response, (strExceptions == ""), strScriptFile.Replace("." + objProviderConfiguration.DefaultProvider + ".sql", ".log"));

                    // update the version
                    PortalSettings.UpdateDatabaseVersion(intMajor, intMinor, intBuild);

                    LogInfo objEventLogInfo = new LogInfo();
                    objEventLogInfo.AddProperty("Upgraded SharpContent", "Version: " + intMajor + "." + intMinor + "." + intBuild);
                    // HACK : Modified to not error if object is null.
                    //if (strExceptions.Length > 0)
                    if (!String.IsNullOrEmpty(strExceptions))
                    {
                        objEventLogInfo.AddProperty("Warnings", strExceptions);
                    }
                    else
                    {
                        objEventLogInfo.AddProperty("No Warnings", "");
                    }
                    objEventLogInfo.LogTypeKey = EventLogController.EventLogType.HOST_ALERT.ToString();
                    objEventLogInfo.BypassBuffering = true;
                    //objEventLog.AddLog(objEventLogInfo)
                }
            }

            // perform general application upgrades
            HtmlUtils.WriteFeedback(HttpContext.Current.Response, 0, "Performing General Upgrades: ");
            strExceptions = UpgradeApplication();
            if (!String.IsNullOrEmpty(strExceptions))
            {
                HtmlUtils.WriteScriptSuccessError(HttpContext.Current.Response, true, String.Empty);
                EventLogController objEventLog = new EventLogController();
                LogInfo objEventLogInfo = new LogInfo();
                objEventLogInfo.AddProperty("Upgraded SharpContent", "General");
                objEventLogInfo.AddProperty("Warnings", strExceptions);
                objEventLogInfo.LogTypeKey = EventLogController.EventLogType.HOST_ALERT.ToString();
                objEventLogInfo.BypassBuffering = true;
                objEventLog.AddLog(objEventLogInfo);                
            }
            else
            {
                HtmlUtils.WriteScriptSuccessError(HttpContext.Current.Response, true, String.Empty);
            }

            PortalController objPortalController = new PortalController();
            ArrayList arrPortals;
            arrPortals = objPortalController.GetPortals();
            int j;
            for (j = 0; j <= arrPortals.Count - 1; j++)
            {
                PortalInfo objPortal;
                objPortal = (PortalInfo)arrPortals[j];
                DataCache.RemoveCache("GetTabPermissionsByPortal" + objPortal.PortalID);
            }
        }
    }
}