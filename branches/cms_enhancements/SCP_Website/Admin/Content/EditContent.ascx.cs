//
// Sharp Content Portal - http://www.sharpcontentportal.com
// Copyright (c) 2007
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

using System;
using System.Collections;
using System.Text;
using SharpContent;
using SharpContent.Common;
using SharpContent.Modules.HTML;
using SharpContent.Services.Exceptions;
using SharpContent.Services.Localization;
using SharpContent.UI.Utilities;
using SharpContent.UI.WebControls;
using SharpContent.Common.Utilities;
using SharpContent.Security;

namespace SharpContent.Modules.Content
{

    /// -----------------------------------------------------------------------------
    /// <summary>
    /// The EditHtml PortalModuleBase is used to manage Html
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <history>
    /// </history>
    /// -----------------------------------------------------------------------------
    public partial class EditContent : Entities.Modules.PortalModuleBase
    {

        #region "Private Members"

        protected bool _isNew = true;
        protected string _mode;
        private ContentController _contentController;

        #endregion

        #region "Private Properties"

        private ContentController ContentController
        {
            get {
                if (_contentController == null)
                {
                    _contentController = new ContentController();
                }
                return _contentController;
            }
        }

        #endregion

        #region "Public Properities"

        /// <summary>
        /// Gets and sets the UserId associated with this control
        /// </summary>
        public int ContentId
        {
            get
            {
                int contentId = Null.NullInteger;
                if (ViewState["ContentId"] == null)
                {
                    if (Request.QueryString["ContentId"] != null)
                    {
                        contentId = int.Parse(Request.QueryString["ContentId"]);
                        ViewState["ContentId"] = contentId;
                    }
                }
                else
                {
                    contentId = Convert.ToInt32(ViewState["ContentId"]);
                }
                return contentId;
            }
            set
            {
                ViewState["ContentId"] = value;
            }
        }

        #endregion

        #region "Private Methods"

        private void BindGrid()
        {            
            grdContent.DataSource = ContentController.GetContentVersions(ModuleId);
            grdContent.DataBind();
        }

        private void BindRadioButtonList()
        {
            rdolCommentFlags.Items.Add(new System.Web.UI.WebControls.ListItem("<img src=\"" + ResolveUrl("~/Images/flag-green.gif") + "\" />", "1"));
            rdolCommentFlags.Items.Add(new System.Web.UI.WebControls.ListItem("<img src=\"" + ResolveUrl("~/Images/flag-orange.gif") + "\" />", "2"));
            rdolCommentFlags.Items.Add(new System.Web.UI.WebControls.ListItem("<img src=\"" + ResolveUrl("~/Images/flag-red.gif") + "\" />", "3"));
            rdolCommentFlags.Items.Add(new System.Web.UI.WebControls.ListItem("<img src=\"" + ResolveUrl("~/Images/flag-white.gif") + "\" />", "4"));
            rdolCommentFlags.Items.Add(new System.Web.UI.WebControls.ListItem("None", "0"));
        }

        private void BindComments()
        {
            ArrayList comments;
            comments = ContentController.GetContentComments(ContentId);
            lblComments.Text = String.Empty;
            if (comments.Count > 0)
            {
                StringBuilder sb = new StringBuilder();
                foreach (CommentInfo commentInfo in comments)
                {
                    sb.Append("<p>" + commentInfo.CommentDate.ToString("MM.dd.yyyy HH:mm") + " - ");
                    sb.Append(commentInfo.CreatedByUsername + ": ");
                    sb.Append(commentInfo.Comment + "</p>");
                    sb.AppendLine();
                }
                lblComments.Text = sb.ToString();
            }
        }

        private void SaveContent()
        {
            try
            {
                ContentInfo contentInfo = new ContentInfo();

                if (!_isNew)
                {
                    contentInfo.ContentId = ContentId;
                }
                contentInfo.ModuleId = ModuleId;
                contentInfo.DeskTopHTML = teContent.Text;
                contentInfo.DesktopSummary = txtDesktopSummary.Text;
                contentInfo.CreatedByUserID = this.UserId;

                // persist the content
                ContentId = ContentController.AddContent(contentInfo);

                // refresh cache
                SynchronizeModule();

            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        private void PublishContent()
        {            
            ContentController.UpdateContentPublish(ContentId);
        }

        private void UpdateComment()
        {
            ContentController.AddContentComment(ContentId, UserId, txtComment.Text, Convert.ToInt16(rdolCommentFlags.SelectedValue));
        }

        private void ModuleActionDenied()
        {
            Response.Redirect(SharpContent.Common.Globals.AccessDeniedURL(Localization.GetString("ModuleAction.Error")), true);
        }

        #endregion

        #region "Public Methods"

        public string CommentFlagURL(int commentFlag)
        {
            string commentFlagURL = String.Empty;
            switch (commentFlag)
            {
                case 0:
                    commentFlagURL = "~/Images/spacer.gif";
                    break;
                case 1:
                    commentFlagURL = "~/Images/flag-green.gif";
                    break;
                case 2:
                    commentFlagURL = "~/Images/flag-orange.gif";
                    break;
                case 3:
                    commentFlagURL = "~/Images/flag-red.gif";
                    break;
                case 4:
                    commentFlagURL = "~/Images/flag-white.gif";
                    break;
            }
            return commentFlagURL;
        }

        #endregion

        #region "Event Handlers"

        protected void Page_Init(object sender, System.EventArgs e)
        {
            cmdUpdateComments.Click += new EventHandler(cmdUpdateComments_Click);
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
        protected void Page_Load(object sender, System.EventArgs e)
        {
            try
            {
                // get the IsNew state from the ViewState
                _isNew = Convert.ToBoolean(ViewState["IsNew"]);

                if (!Page.IsPostBack)
                {
                    BindGrid();
                    BindRadioButtonList();

                    ContentInfo contentInfo = ContentController.GetContent(ModuleId);

                    if ((contentInfo != null))
                    {
                        ContentId = contentInfo.ContentId;

                        // initialize control values
                        teContent.Text = contentInfo.DeskTopHTML;
                        lblPreview.Text = Server.HtmlDecode(contentInfo.DeskTopHTML);
                        txtDesktopSummary.Text = Server.HtmlDecode((string)contentInfo.DesktopSummary);
                        rdolCommentFlags.Items.FindByValue(contentInfo.CommentFlag.ToString()).Selected = true;
                        _isNew = false;
                        grdContent.SelectedIndex = contentInfo.ContentVersion - 1;

                        BindComments();
                    }
                    else
                    {
                        // get default content from resource file
                        teContent.Text = Localization.GetString("AddContent", LocalResourceFile);
                        txtDesktopSummary.Text = "";
                        _isNew = true;
                    }

                }

                _mode = Request.QueryString["mode"];
                switch (_mode)
                {
                    case "publish":
                        cmdSave.Visible = false;
                        tcContentEditor.Items.RemoveAt(0);
                        if (!Page.IsPostBack)
                        {
                            mvContentEditor.ActiveViewIndex = 1;
                        }
                        break;
                    case "author":
                        //rdolCommentFlags.Enabled = false;
                        cmdPublish.Visible = false;
                        break;
                }

                // save the IsNew state to the ViewState
                ViewState["IsNew"] = _isNew;
            }

            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// cmdCancel_Click runs when the cancel button is clicked
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// </history>
        /// -----------------------------------------------------------------------------
        protected void cmdCancel_Click(object sender, System.EventArgs e)
        {
            try
            {
                Response.Redirect(SharpContent.Common.Globals.NavigateURL(), true);
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// cmdUpdate_Click runs when the update button is clicked
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// </history>
        /// -----------------------------------------------------------------------------
        protected void cmdSave_Click(object sender, System.EventArgs e)
        {
            if (PortalSecurity.IsInRole("Content Author") || PortalSecurity.IsInRole(PortalSettings.AdministratorRoleName))
            {
                int contentId = ContentId;
                SaveContent();
                BindGrid();
                BindComments();
                if (contentId != ContentId)
                {
                    grdContent.SelectedIndex = grdContent.Rows.Count - 1;
                }
            }
            else
            {
                ModuleActionDenied();
            }
        }

        protected void cmdPublish_Click(object sender, EventArgs e)
        {
            if (PortalSecurity.IsInRole("Content Publisher") || PortalSecurity.IsInRole(PortalSettings.AdministratorRoleName))
            {
                PublishContent();
            }
            else
            {
                ModuleActionDenied();
            }
            // redirect back to portal
            Response.Redirect(SharpContent.Common.Globals.NavigateURL(), true);
        }

        protected void cmdUpdateComments_Click(object sender, EventArgs e)
        {
            UpdateComment();
            BindGrid();
            BindComments();
            txtComment.Text = String.Empty;
        }

        protected void grdContent_RowEditing(object sender, System.Web.UI.WebControls.GridViewEditEventArgs e)
        {
            grdContent.SelectedIndex = e.NewEditIndex;
            ContentId = Convert.ToInt32(grdContent.DataKeys[e.NewEditIndex].Value);
            ContentInfo contentInfo = ContentController.GetContentById(ContentId);

            teContent.Text = contentInfo.DeskTopHTML;
            lblPreview.Text = Server.HtmlDecode(contentInfo.DeskTopHTML);
            txtDesktopSummary.Text = Server.HtmlDecode(contentInfo.DesktopSummary);
            rdolCommentFlags.ClearSelection();
            rdolCommentFlags.Items.FindByValue(contentInfo.CommentFlag.ToString()).Selected = true;
            //ContentId = contentInfo.ContentId;
            BindComments();

            ViewState["IsNew"] = false;
        }

        protected void tcContentEditor_Click(object sender, WebCtrls.TabContainerEventArgs e)
        {
            switch (tcContentEditor.Items[e.SelectedTab].Name)
            {
                case "Edit":
                    mvContentEditor.ActiveViewIndex = 0;
                    break;
                case "Preview":
                    lblPreview.Text = Server.HtmlDecode(teContent.Text);
                    mvContentEditor.ActiveViewIndex = 1;
                    break;
                case "Comments":
                    mvContentEditor.ActiveViewIndex = 2;
                    break;
            }
        }

        #endregion        
}

}
