//
// Sharp Content Portal - http://www.sharpcontentportal.com
// Copyright (c) 2002-2005
// by Perpetual Motion Interactive Systems Inc. ( http://www.perpetualmotion.ca )
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

using SharpContent;
using System.Web.UI;
using System.Text.RegularExpressions;
using System.Collections;
using SharpContent.Entities.Modules.Actions;
using SharpContent.Common.Utilities;
using System;
using SharpContent.Modules.HTML;
using SharpContent.Services.Localization;
using SharpContent.Services.Exceptions;

namespace SharpContent.Modules.Content
{

    /// -----------------------------------------------------------------------------
    /// <summary>
    /// The HtmlModule Class provides the UI for displaying the Html
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <history>
    /// </history>
    /// -----------------------------------------------------------------------------
    public partial class ContentModule : Entities.Modules.PortalModuleBase, Entities.Modules.IActionable
    {

        #region "Private Methods"

        //Local tag cache to avoid multiple generations of the same tag
        private Hashtable tagCache;

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// ManageUploadDirectory ensures that all image refs are to the correct directory
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// </history>
        /// -----------------------------------------------------------------------------
        private string ManageUploadDirectory(string strHTML, string strUploadDirectory)
        {
            int p;
            string manageUploadDirectory = string.Empty;

            p = strHTML.ToLower().IndexOf(@"src=""");
            while (p != -1)
            {
                manageUploadDirectory += strHTML.Substring(0, p + 5);

                strHTML = strHTML.Substring(p + 5);

                // add uploaddirectory if we are linking internally
                string strSRC = strHTML.Substring(0, strHTML.IndexOf(@""""));
                if (strSRC.IndexOf("://") == -1 & strSRC.Substring(0, 1) != "/" & strSRC.IndexOf(strUploadDirectory.Substring(strUploadDirectory.IndexOf("Portals/"))) == -1)
                {

                    strHTML = strUploadDirectory + strHTML;
                }

                p = strHTML.ToLower().IndexOf(@"src=""");
            }
            return manageUploadDirectory + strHTML;


        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// Replaces all smart Tags in content with their appropriate values.
        /// </summary>
        /// <param name="content"></param>
        /// <returns>Content with replaced Tags</returns>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// </history>
        /// -----------------------------------------------------------------------------

        private string ProcessTags(string content)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            string retVal = Null.NullString;

            int position = 0;

            //Find all tags used in text
            //The regular expression matches the tag including the square brackets:
            //in "aaa[bbb[ccc]ddd]eee" it matches only "[ccc]"
            if ((content != null))
            {
                foreach (Match _match in Regex.Matches(content, "\\[([^\\[]*?)\\]"))
                {
                    //Append the text before the match to the result
                    sb.Append(content.Substring(position, _match.Index - position));

                    //Process the tag and append the output to the result
                    sb.Append(ProcessTag(_match.Value));

                    //Set the starting point for the next match
                    position = _match.Index + _match.Value.Length;
                }

                //Append the rest of the text to the result
                sb.Append(content.Substring(position));

                retVal = sb.ToString();
            }

            return retVal;
        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// Processes all occurrences of the given tag by the given value in given content
        /// </summary>
        /// <param name="tag"></param>
        /// <returns>Content with replaced Tag</returns>
        /// <remarks>
        /// A hashtable is used to make sure each tag will only be processed once each load.
        /// </remarks>
        /// <history>
        /// </history>
        /// -----------------------------------------------------------------------------
        private string ProcessTag(string tag)
        {

            //Store the tag in the result to keep the text if its not a smarttag
            string retval = tag;
            string[] tagitems = tag.Substring(1, tag.Length - 2).Trim().Split(" ".ToCharArray());
            //Ensure case independency
            tagitems[0] = tagitems[0].ToUpper();
            //Initialize cache if not created
            if (tagCache == null) tagCache = new Hashtable();
            //If we have tag in cache, simply return the cached content
            if (tagCache.ContainsKey(tag))
            {
                retval = tagCache[tag].ToString();
            }
            else
            {
                //Build tag content value if its a known tag
                switch (tagitems[0])
                {
                    case "PORTAL.NAME":
                        retval = PortalSettings.PortalName;
                        tagCache[tag] = retval;
                        break;
                    case "DATE":
                        if (tagitems.Length == 2)
                        {
                            try
                            {
                                retval = DateTime.Now.ToString(tagitems[1]);
                            }
                            catch
                            {
                                retval = DateTime.Now.ToShortDateString();
                            }
                        }
                        else
                        {
                            retval = DateTime.Now.ToShortDateString();
                        }

                        tagCache[tag] = retval;
                        break;
                    case "TIME":
                        if (tagitems.Length == 2)
                        {
                            try
                            {
                                retval = DateTime.Now.ToString(tagitems[1]);
                            }
                            catch
                            {
                                retval = DateTime.Now.ToShortTimeString();
                            }
                        }
                        else
                        {
                            retval = DateTime.Now.ToShortTimeString();
                        }

                        tagCache[tag] = retval;
                        break;
                }
            }

            return retval;
        }

        #endregion

        #region "Event Handlers"
        protected override void OnInit(System.EventArgs e)
        {
            base.OnInit(e);
            //If SharpContent.Entities.Host.HostSettings.GetHostSetting("UseFriendlyUrls") <> "Y" Then
            //    'allow for relative urls
            //    lblContent.UrlFormat = UI.WebControls.UrlFormatType.Relative
            //End If
        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// Page_Load runs when the control is loaded
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// </history>
        /// -----------------------------------------------------------------------------
        private void Page_Load(object sender, System.EventArgs e)
        {
            try
            {

                lblContent.EditEnabled = this.IsEditable;

                // get Content object
                ContentController objHTML = new ContentController();
                ContentInfo objText = objHTML.GetContent(ModuleId);

                // get default content from resource file
                string strContent = Localization.GetString("AddContentFromToolBar.Text", LocalResourceFile);
                if (Entities.Portals.PortalSettings.GetSiteSetting(PortalId, "InlineEditorEnabled") == "False")
                {
                    lblContent.EditEnabled = false;
                    strContent = Localization.GetString("AddContentFromActionMenu.Text", LocalResourceFile);
                }

                if (lblContent.EditEnabled)
                {
                    //localize toolbar
                    foreach (SharpContent.UI.WebControls.SCPToolBarButton objButton in this.tbEIPHTML.Buttons)
                    {
                        objButton.ToolTip = Services.Localization.Localization.GetString("cmd" + objButton.ToolTip, LocalResourceFile);
                    }
                }
                else
                {
                    this.tbEIPHTML.Visible = false;
                }

                // get html
                if ((objText != null))
                {
                    strContent = Server.HtmlDecode((string)objText.DeskTopHTML);
                }

                // handle Smart Tags that might have been used
                strContent = ProcessTags(strContent);

                //add content to module
                lblContent.Controls.Add(new LiteralControl(ManageUploadDirectory(strContent, PortalSettings.HomeDirectory)));

                // menu action handler
                UI.Skins.Skin ParentSkin = UI.Skins.Skin.GetParentSkin(this);
                //We should always have a ParentSkin, but need to make sure
                if ((ParentSkin != null))
                {
                    //Register our EventHandler as a listener on the ParentSkin so that it may tell us when a menu has been clicked.
                    ParentSkin.RegisterModuleActionEvent(this.ModuleId, ModuleAction_Click);
                }
            }

            catch (Exception ex)
            {
                Exceptions.ProcessModuleLoadException(this, ex);
            }
        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// lblContent_UpdateLabel allows for inline editing of content
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// </history>
        /// -----------------------------------------------------------------------------
        private void lblContent_UpdateLabel(object source, UI.WebControls.SCPLabelEditEventArgs e)
        {

            // get Content object
            ContentController contentController = new ContentController();
            ContentInfo contentInfo = contentController.GetContent(ModuleId);

            // check if this is a new module instance
            bool blnIsNew = false;
            if (contentInfo == null)
            {
                contentInfo = new ContentInfo();
                blnIsNew = true;
            }

            // set content values
            contentInfo.ModuleId = ModuleId;
            contentInfo.DeskTopHTML = e.Text;
            contentInfo.CreatedByUserID = this.UserId;

            // save the content
            if (blnIsNew)
            {
                contentController.AddContent(contentInfo);
            }
            else
            {
                contentController.UpdateContent(contentInfo);
            }

            // refresh cache
            SynchronizeModule();

        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// ModuleAction_Click handles all ModuleAction events raised from the skin
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// </history>
        /// -----------------------------------------------------------------------------
        public void ModuleAction_Click(object sender, Entities.Modules.Actions.ActionEventArgs e)
        {

            if (e.Action.Url.Length > 0)
            {
                Response.Redirect(e.Action.Url, true);
            }

        }

        #endregion

        #region "Optional Interfaces"

        public ModuleActionCollection ModuleActions
        {
            get
            {
                Entities.Modules.Actions.ModuleActionCollection Actions = new Entities.Modules.Actions.ModuleActionCollection();
                Actions.Add(GetNextActionID(), Localization.GetString(Entities.Modules.Actions.ModuleActionType.AddContent, LocalResourceFile), Entities.Modules.Actions.ModuleActionType.AddContent, "", "content-edit.gif", EditUrl("mode","1"), false, Security.SecurityAccessLevel.Author, true, false);
                Actions.Add(GetNextActionID(), Localization.GetString("PublishContent.Action", LocalResourceFile), Entities.Modules.Actions.ModuleActionType.AddContent, "", "content-publish.gif", EditUrl("mode", "2"), false, Security.SecurityAccessLevel.Publisher, true, false);
                return Actions;
            }
        }

        #endregion

    }

}

