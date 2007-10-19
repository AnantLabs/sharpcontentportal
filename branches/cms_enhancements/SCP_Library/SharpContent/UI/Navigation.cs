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
using System.Web;
using System.Web.UI;
using SharpContent.Common;
using SharpContent.Entities.Modules.Actions;
using SharpContent.Entities.Portals;
using SharpContent.Entities.Tabs;
using SharpContent.Entities.Users;
using SharpContent.Security;
using SharpContent.UI.Containers;
using SharpContent.UI.WebControls;

namespace SharpContent.UI
{
    public class Navigation
    {
        public enum NavNodeOptions
        {
            IncludeSelf = 1,
            IncludeParent = 2,
            IncludeSiblings = 4,
            MarkPendingNodes = 8,
        }

        public enum ToolTipSource
        {
            TabName = 0,
            Title = 1,
            Description = 2,
            None = 3,
        }

        /// <summary>
        /// Recursive function to add module's actions to the SCPNodeCollection based off of passed in ModuleActions
        /// </summary>
        /// <param name="objParentAction">Parent action</param>
        /// <param name="objParentNode">Parent node</param>
        /// <param name="objModule">Module to base actions off of</param>
        /// <param name="objUserInfo">User Info Object</param>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[Jon Henning]	8/9/2005	Created
        /// </history>
        /// <param name="objControl"></param>
        private static void AddChildActions(ModuleAction objParentAction, SCPNode objParentNode, ActionBase objModule, UserInfo objUserInfo, Control objControl)
        {
            AddChildActions(objParentAction, objParentNode, objParentNode, objModule, objUserInfo, -1);
        }

        /// <summary>
        /// Recursive function to add module's actions to the SCPNodeCollection based off of passed in ModuleActions
        /// </summary>
        /// <param name="objParentAction">Parent action</param>
        /// <param name="objParentNode">Parent node</param>
        /// <param name="objRootNode"></param>
        /// <param name="objModule">Module to base actions off of</param>
        /// <param name="objUserInfo">User Info Object</param>
        /// <param name="intDepth">How many levels deep should be populated</param>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[Jon Henning]	5/15/2006	Created
        /// </history>
        private static void AddChildActions(ModuleAction objParentAction, SCPNode objParentNode, SCPNode objRootNode, ActionBase objModule, UserInfo objUserInfo, int intDepth)
        {
            // Add Menu Items

            foreach (ModuleAction objAction in objParentAction.Actions)
            {
                bool blnPending = IsActionPending(objParentNode, objRootNode, intDepth);
                if (objAction.Title == "~")
                {
                    if (blnPending == false)
                    {
                        //A title (text) of ~ denotes a break
                        objParentNode.SCPNodes.AddBreak();
                    }
                }
                else
                {
                    //if action is visible and user has permission 
                    if (objAction.Visible & PortalSecurity.HasNecessaryPermission(objAction.Secure, (PortalSettings)(HttpContext.Current.Items["PortalSettings"]), objModule.ModuleConfiguration, objUserInfo.UserID.ToString()))
                    {
                        //(if edit mode and not admintab and not admincontrol)
                        if (blnPending)
                        {
                            objParentNode.HasNodes = true;
                        }
                        else
                        {
                            int i = objParentNode.SCPNodes.Add();
                            SCPNode objNode = objParentNode.SCPNodes[i];
                            objNode.ID = objAction.ID.ToString();
                            objNode.Key = objAction.ID.ToString();
                            objNode.Text = objAction.Title; //no longer including SPACE in generic node collection, each control must handle how they want to display
                            // HACK : Modified to not error if object is null.
                            //if (objAction.ClientScript.Length > 0)
                            if (!String.IsNullOrEmpty(objAction.ClientScript))
                            {
                                objNode.JSFunction = objAction.ClientScript;
                                objNode.ClickAction = eClickAction.None;
                            }
                            else
                            {
                                objNode.NavigateURL = objAction.Url;
                                // HACK : Modified to handle null string in objNode.NavigateURL
                                //if (objAction.UseActionEvent == false && objNode.NavigateURL.Length > 0)
                                if (objAction.UseActionEvent == false && !String.IsNullOrEmpty(objNode.NavigateURL))
                                {
                                    objNode.ClickAction = eClickAction.Navigate;
                                }
                                else
                                {
                                    objNode.ClickAction = eClickAction.PostBack;
                                }
                            }
                            objNode.Image = objAction.Icon;

                            if (objAction.HasChildren()) //if action has children then call function recursively
                            {
                                AddChildActions(objAction, objNode, objRootNode, objModule, objUserInfo, intDepth);
                            }
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Assigns common properties from passed in tab to newly created SCPNode that is added to the passed in SCPNodeCollection
        /// </summary>
        /// <param name="objTab">Tab to base SCPNode off of</param>
        /// <param name="objNodes">Node collection to append new node to</param>
        /// <param name="objBreadCrumbs">Hashtable of breadcrumb IDs to efficiently determine node's BreadCrumb property</param>
        /// <param name="objPortalSettings">Portal settings object to determine if node is selected</param>
        /// <remarks>
        /// Logic moved to separate sub to make GetNavigationNodes cleaner
        /// </remarks>
        /// <history>
        /// 	[Jon Henning]	8/9/2005	Created
        /// </history>
        /// <param name="eToolTips"></param>
        private static void AddNode(TabInfo objTab, SCPNodeCollection objNodes, Hashtable objBreadCrumbs, PortalSettings objPortalSettings, ToolTipSource eToolTips)
        {
            SCPNode objNode = new SCPNode();

            if (objTab.Title == "~") // NEW!
            {
                //A title (text) of ~ denotes a break
                objNodes.AddBreak();
            }
            else
            {
                //assign breadcrumb and selected properties
                if (objBreadCrumbs.Contains(objTab.TabID))
                {
                    objNode.BreadCrumb = true;
                    if (objTab.TabID == objPortalSettings.ActiveTab.TabID)
                    {
                        objNode.Selected = true;
                    }
                }

                if (objTab.DisableLink)
                {
                    objNode.Enabled = false;
                }

                objNode.ID = objTab.TabID.ToString();
                objNode.Key = objNode.ID;
                objNode.Text = objTab.TabName;
                objNode.NavigateURL = objTab.FullUrl;
                objNode.ClickAction = eClickAction.Navigate;

                //admin tabs have their images found in a different location, since the SCPNode has no concept of an admin tab, this must be set here
                if (objTab.IsAdminTab)
                {
                    if (objTab.IconFile != "")
                    {
                        objNode.Image = Globals.ApplicationPath + "/images/" + objTab.IconFile;
                    }
                }
                else
                {
                    if (objTab.IconFile != "")
                    {
                        objNode.Image = objTab.IconFile;
                    }
                }

                switch (eToolTips)
                {
                    case ToolTipSource.TabName:
                        objNode.ToolTip = objTab.TabName;
                        break;
                    case ToolTipSource.Title:
                        objNode.ToolTip = objTab.Title;
                        break;
                    case ToolTipSource.Description:
                        objNode.ToolTip = objTab.Description;
                        break;
                }

                objNodes.Add(objNode);
            }
        }

        private static bool IsActionPending(SCPNode objParentNode, SCPNode objRootNode, int intDepth)
        {
            //if we aren't restricting depth then its never pending
            if (intDepth == -1)
            {
                return false;
            }

            //parents level + 1 = current node level
            //if current node level - (roots node level) <= the desired depth then not pending
            if (objParentNode.Level + 1 - objRootNode.Level <= intDepth)
            {
                return false;
            }
            return true;
        }

        private static bool IsTabPending(TabInfo objTab, SCPNode objParentNode, SCPNode objRootNode, int intDepth, Hashtable objBreadCrumbs, int intLastBreadCrumbId, bool blnPOD)
        {
            //
            // A
            // |
            // --B
            // | |
            // | --B-1
            // | | |
            // | | --B-1-1
            // | | |
            // | | --B-1-2
            // | |
            // | --B-2
            // |   |
            // |   --B-2-1
            // |   |
            // |   --B-2-2
            // |
            // --C
            //   |
            //   --C-1
            //   | |
            //   | --C-1-1
            //   | |
            //   | --C-1-2
            //   |
            //   --C-2
            //     |
            //     --C-2-1
            //     |
            //     --C-2-2

            //if we aren't restricting depth then its never pending
            if (intDepth == -1)
            {
                return false;
            }

            //parents level + 1 = current node level
            //if current node level - (roots node level) <= the desired depth then not pending
            if (objParentNode.Level + 1 - objRootNode.Level <= intDepth)
            {
                return false;
            }

            //--- These checks below are here so tree becomes expands to selected node ---'
            if (blnPOD)
            {
                //really only applies to controls with POD enabled, since the root passed in may be some node buried down in the chain
                //and the depth something like 1.  We need to include the appropriate parent's and parent siblings
                //Why is the check for POD required?  Well to allow for functionality like RootOnly requests.  We do not want any children
                //regardless if they are a breadcrumb

                //if tab is in the breadcrumbs then obviously not pending
                if (objBreadCrumbs.Contains(objTab.TabID))
                {
                    return false;
                }

                //if parent is in the breadcrumb and it is not the last breadcrumb then not pending
                //in tree above say we our breadcrumb is (A, B, B-2) we want our tree containing A, B, B-2 AND B-1 AND C since A and B are expanded
                //we do NOT want B-2-1 and B-2-2, thus the check for Last Bread Crumb
                if (objBreadCrumbs.Contains(objTab.ParentId) && intLastBreadCrumbId != objTab.ParentId)
                {
                    return false;
                }
            }

            return true;
            //if depth matters and if parents level + 1 (current node level) - (roots node level) > the desired depth and not a breadcrumb tab and parent tabid not a breadcrumb (or parent breadcrumb is last in chain, thus we mark as pending)
            //If intDepth <> -1 AndAlso objParentNode.Level + 1 - objRootNode.Level > intDepth AndAlso objBreadCrumbs.Contains(objTab.TabID) = False AndAlso (objBreadCrumbs.Contains(objTab.ParentId) = False OrElse intLastBreadCrumbId = objTab.ParentId) Then
            //	Return True
            //Else
            //	Return False
            //End If
        }

        private static bool IsTabSibling(TabInfo objTab, int intStartTabId, Hashtable objTabLookup)
        {
            if (intStartTabId == -1)
            {
                if (objTab.ParentId == -1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else if (objTab.ParentId == ((TabInfo)(objTabLookup[intStartTabId])).ParentId)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private static bool IsTabShown(TabInfo objTab, bool blnAdminMode)
        {
            //if tab is visible, not deleted, not expired (or admin), and user has permission to see it...
            if (objTab.IsVisible && objTab.IsDeleted == false && ((objTab.StartDate < DateTime.Now && objTab.EndDate > DateTime.Now) || blnAdminMode) && PortalSecurity.IsInRoles(objTab.AuthorizedRoles))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Allows for SCPNode object to be easily obtained based off of passed in ID
        /// </summary>
        /// <param name="strID">NodeID to retrieve</param>
        /// <param name="strNamespace">Namespace for node collection (usually control's ClientID)</param>
        /// <param name="objActionRoot">Root Action object used in searching</param>
        /// <param name="objModule">Module to base actions off of</param>
        /// <returns>SCPNode</returns>
        /// <remarks>
        /// Primary purpose of this is to obtain the SCPNode needed for the events exposed by the NavigationProvider
        /// </remarks>
        /// <history>
        /// 	[Jon Henning]	5/15/2006	Created
        /// </history>
        public static SCPNode GetActionNode(string strID, string strNamespace, ModuleAction objActionRoot, ActionBase objModule)
        {
            SCPNodeCollection objNodes = GetActionNodes(objActionRoot, objModule, -1);
            SCPNode objNode = objNodes.FindNode(strID);
            SCPNodeCollection objReturnNodes = new SCPNodeCollection(strNamespace);
            objReturnNodes.Import(objNode);
            objReturnNodes[0].ID = strID;
            return objReturnNodes[0];
        }

        /// <summary>
        /// This function provides a central location to obtain a generic node collection of the actions associated 
        /// to a module based off of the current user's context
        /// </summary>
        /// <param name="objActionRoot">Root module action</param>
        /// <param name="objModule">Module whose actions you wish to obtain</param>
        /// <returns></returns>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[Jon Henning]	8/9/2005	Created
        /// </history>
        /// <param name="objControl"></param>
        public static SCPNodeCollection GetActionNodes(ModuleAction objActionRoot, ActionBase objModule, Control objControl)
        {
            return GetActionNodes(objActionRoot, objModule, -1);
        }

        /// <summary>
        /// This function provides a central location to obtain a generic node collection of the actions associated 
        /// to a module based off of the current user's context
        /// </summary>
        /// <param name="objActionRoot">Root module action</param>
        /// <param name="objModule">Module whose actions you wish to obtain</param>
        /// <param name="intDepth">How many levels deep should be populated</param>
        /// <returns></returns>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[Jon Henning]	5/15/2006	Created
        /// </history>
        public static SCPNodeCollection GetActionNodes(ModuleAction objActionRoot, ActionBase objModule, int intDepth)
        {
            SCPNodeCollection objCol = new SCPNodeCollection(objModule.ClientID);
            if (objActionRoot.Visible)
            {
                objCol.Add();
                SCPNode objRoot = objCol[0];
                objRoot.ID = objActionRoot.ID.ToString();
                objRoot.Key = objActionRoot.ID.ToString();
                objRoot.Text = objActionRoot.Title;
                objRoot.NavigateURL = objActionRoot.Url;
                objRoot.Image = objActionRoot.Icon;
                AddChildActions(objActionRoot, objRoot, objRoot.ParentNode, objModule, UserController.GetCurrentUserInfo(), intDepth);
            }
            return objCol;
        }

        /// <summary>
        /// This function provides a central location to obtain a generic node collection of the actions associated 
        /// to a module based off of the current user's context
        /// </summary>
        /// <param name="objActionRoot">Root module action</param>
        /// <param name="objRootNode">Root node on which to populate children</param>
        /// <param name="objModule">Module whose actions you wish to obtain</param>
        /// <param name="intDepth">How many levels deep should be populated</param>
        /// <returns></returns>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[Jon Henning]	5/15/2006	Created
        /// </history>
        public static SCPNodeCollection GetActionNodes(ModuleAction objActionRoot, SCPNode objRootNode, ActionBase objModule, int intDepth)
        {
            SCPNodeCollection objCol = objRootNode.ParentNode.SCPNodes;
            AddChildActions(objActionRoot, objRootNode, objRootNode, objModule, UserController.GetCurrentUserInfo(), intDepth);
            return objCol;
        }

        /// <summary>
        /// Allows for SCPNode object to be easily obtained based off of passed in ID
        /// </summary>
        /// <param name="strID">NodeID to retrieve</param>
        /// <param name="strNamespace">Namespace for node collection (usually control's ClientID)</param>
        /// <returns>SCPNode</returns>
        /// <remarks>
        /// Primary purpose of this is to obtain the SCPNode needed for the events exposed by the NavigationProvider
        /// </remarks>
        /// <history>
        /// 	[Jon Henning]	8/9/2005	Created
        /// </history>
        public static SCPNode GetNavigationNode(string strID, string strNamespace)
        {
            //                                 
            SCPNodeCollection objNodes = GetNavigationNodes(strNamespace);
            SCPNode objNode = objNodes.FindNode(strID);
            SCPNodeCollection objReturnNodes = new SCPNodeCollection(strNamespace);
            objReturnNodes.Import(objNode);
            objReturnNodes[0].ID = strID;
            return objReturnNodes[0];
        }

        /// <summary>
        /// This function provides a central location to obtain a generic node collection of the pages/tabs included in
        /// the current context's (user) navigation hierarchy
        /// </summary>
        /// <param name="strNamespace">Namespace (typically control's ClientID) of node collection to create</param>
        /// <returns>Collection of SCPNodes</returns>
        /// <remarks>
        /// Returns all navigation nodes for a given user 
        /// </remarks>
        /// <history>
        /// 	[Jon Henning]	8/9/2005	Created
        /// </history>
        public static SCPNodeCollection GetNavigationNodes(string strNamespace)
        {
            return GetNavigationNodes(strNamespace, ToolTipSource.None, -1, -1, 0);
        }

        /// <summary>
        /// This function provides a central location to obtain a generic node collection of the pages/tabs included in
        /// the current context's (user) navigation hierarchy
        /// </summary>
        /// <param name="strNamespace">Namespace (typically control's ClientID) of node collection to create</param>
        /// <param name="eToolTips">Enumerator to determine what text to display in the tooltips</param>
        /// <param name="intStartTabId">If using Populate On Demand, then this is the tab id of the root element to retrieve (-1 for no POD)</param>
        /// <param name="intDepth">If Populate On Demand is enabled, then this parameter determines the number of nodes to retrieve beneath the starting tab passed in (intStartTabId) (-1 for no POD)</param>
        /// <param name="intNavNodeOptions">Bitwise integer containing values to determine what nodes to display (self, siblings, parent)</param>
        /// <returns>Collection of SCPNodes</returns>
        /// <remarks>
        /// Returns a subset of navigation nodes based off of passed in starting node id and depth
        /// </remarks>
        /// <history>
        /// 	[Jon Henning]	8/9/2005	Created
        /// </history>
        public static SCPNodeCollection GetNavigationNodes(string strNamespace, ToolTipSource eToolTips, int intStartTabId, int intDepth, int intNavNodeOptions)
        {
            SCPNodeCollection objCol = new SCPNodeCollection(strNamespace);
            return GetNavigationNodes(new SCPNode(objCol.XMLNode), eToolTips, intStartTabId, intDepth, intNavNodeOptions);
        }

        /// <summary>
        /// This function provides a central location to obtain a generic node collection of the pages/tabs included in
        /// the current context's (user) navigation hierarchy
        /// </summary>
        /// <param name="objRootNode">Node in which to add children to</param>
        /// <param name="eToolTips">Enumerator to determine what text to display in the tooltips</param>
        /// <param name="intStartTabId">If using Populate On Demand, then this is the tab id of the root element to retrieve (-1 for no POD)</param>
        /// <param name="intDepth">If Populate On Demand is enabled, then this parameter determines the number of nodes to retrieve beneath the starting tab passed in (intStartTabId) (-1 for no POD)</param>
        /// <param name="intNavNodeOptions">Bitwise integer containing values to determine what nodes to display (self, siblings, parent)</param>
        /// <returns>Collection of SCPNodes</returns>
        /// <remarks>
        /// Returns a subset of navigation nodes based off of passed in starting node id and depth
        /// </remarks>
        /// <history>
        /// 	[Jon Henning]	8/9/2005	Created
        /// </history>
        public static SCPNodeCollection GetNavigationNodes(SCPNode objRootNode, ToolTipSource eToolTips, int intStartTabId, int intDepth, int intNavNodeOptions)
        {
            int i;
            PortalSettings objPortalSettings = PortalController.GetCurrentPortalSettings();
            bool blnAdminMode = PortalSecurity.IsInRoles(objPortalSettings.AdministratorRoleName) | PortalSecurity.IsInRoles(objPortalSettings.ActiveTab.AdministratorRoles.ToString());
            //bool blnFoundStart = intStartTabId == -1; //if -1 then we want all

            Hashtable objBreadCrumbs = new Hashtable();
            Hashtable objTabLookup = new Hashtable();
            SCPNodeCollection objRootNodes = objRootNode.SCPNodes;
            int intLastBreadCrumbId = 0;
            TabInfo objTab;

            //--- cache breadcrumbs in hashtable so we can easily set flag on node denoting it as a breadcrumb node (without looping multiple times) ---'
            for (i = 0; i <= (objPortalSettings.ActiveTab.BreadCrumbs.Count - 1); i++)
            {
                objBreadCrumbs.Add(((TabInfo)(objPortalSettings.ActiveTab.BreadCrumbs[i])).TabID, 1);
                intLastBreadCrumbId = ((TabInfo)(objPortalSettings.ActiveTab.BreadCrumbs[i])).TabID;
            }

            for (i = 0; i < objPortalSettings.DesktopTabs.Count; i++)
            {
                objTab = (TabInfo)(objPortalSettings.DesktopTabs[i]);
                objTabLookup.Add(objTab.TabID, objTab);
            }

            for (i = 0; i < objPortalSettings.DesktopTabs.Count; i++)
            {
                try
                {
                    objTab = (TabInfo)(objPortalSettings.DesktopTabs[i]);

                    if (IsTabShown(objTab, blnAdminMode)) //based off of tab properties, is it shown
                    {
                        SCPNode objParentNode = objRootNodes.FindNode(objTab.ParentId.ToString());
                        bool blnParentFound = objParentNode != null;
                        if (objParentNode == null)
                        {
                            objParentNode = objRootNode;
                        }
                        SCPNodeCollection objParentNodes = objParentNode.SCPNodes;

                        //If objTab.ParentId = -1 OrElse ((intNavNodeOptions And NavNodeOptions.IncludeRootOnly) = 0) Then
                        if (objTab.TabID == intStartTabId)
                        {
                            //is this the starting tab
                            if ((intNavNodeOptions & (int)NavNodeOptions.IncludeParent) != 0)
                            {
                                //if we are including parent, make sure there is one, then add
                                if (objTabLookup[objTab.ParentId] != null)
                                {
                                    AddNode((TabInfo)(objTabLookup[objTab.ParentId]), objParentNodes, objBreadCrumbs, objPortalSettings, eToolTips);
                                    objParentNode = objRootNodes.FindNode(objTab.ParentId.ToString());
                                    objParentNodes = objParentNode.SCPNodes;
                                }
                            }
                            if ((intNavNodeOptions & (int)NavNodeOptions.IncludeSelf) != 0)
                            {
                                //if we are including our self (starting tab) then add
                                AddNode(objTab, objParentNodes, objBreadCrumbs, objPortalSettings, eToolTips);
                            }
                        }
                        else if (((intNavNodeOptions & (int)NavNodeOptions.IncludeSiblings) != 0) && IsTabSibling(objTab, intStartTabId, objTabLookup))
                        {
                            //is this a sibling of the starting node, and we are including siblings, then add it
                            AddNode(objTab, objParentNodes, objBreadCrumbs, objPortalSettings, eToolTips);
                        }
                        else
                        {
                            if (blnParentFound) //if tabs parent already in hierarchy (as is the case when we are sending down more than 1 level)
                            {
                                //parent will be found for siblings.  Check to see if we want them, if we don't make sure tab is not a sibling
                                if (((intNavNodeOptions & (int)NavNodeOptions.IncludeSiblings) != 0) || IsTabSibling(objTab, intStartTabId, objTabLookup) == false)
                                {
                                    //determine if tab should be included or marked as pending
                                    bool blnPOD = (intNavNodeOptions & (int)NavNodeOptions.MarkPendingNodes) != 0;
                                    if (IsTabPending(objTab, objParentNode, objRootNode, intDepth, objBreadCrumbs, intLastBreadCrumbId, blnPOD))
                                    {
                                        if (blnPOD)
                                        {
                                            objParentNode.HasNodes = true; //mark it as a pending node
                                        }
                                    }
                                    else
                                    {
                                        AddNode(objTab, objParentNodes, objBreadCrumbs, objPortalSettings, eToolTips);
                                    }
                                }
                            }
                            else if ((intNavNodeOptions & (int)NavNodeOptions.IncludeSelf) == 0 && objTab.ParentId == intStartTabId)
                            {
                                //if not including self and parent is the start id then add 
                                AddNode(objTab, objParentNodes, objBreadCrumbs, objPortalSettings, eToolTips);
                            }
                        }
                    }
                    //End If
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }

            return objRootNodes;
        }
    }
}