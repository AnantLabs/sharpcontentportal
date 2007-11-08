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

        // Modes
        private enum EditMode
        { 
            None = 0,
            Author = 1,
            Publish = 2            
        }

        // Workflow
        private enum WorkflowState
        {
            None = 0,
            Approve = 1,
            Submit = 2,
            Reject = 3,
            Banned = 4
        }

        private string _mode;
        private int _workFlowState;
        private ContentController _contentController;

        #endregion

        #region "Private Properties"

        private ContentController ContentController
        {
            get
            {
                if (_contentController == null)
                {
                    _contentController = new ContentController();
                }
                return _contentController;
            }
        }

        private bool IsNew
        {
            get 
            { 
                return Convert.ToBoolean(ViewState["isNew"]);
            }
            set 
            { 
                ViewState["isNew"] = value;
            }
        }

        private EditMode CurrentEditMode
        {            
            get
            {
                EditMode editMode;
                editMode = (EditMode)Convert.ToInt32(Request.QueryString["mode"]);
                return editMode;
            }
        }

        private WorkflowState CurrentWorkflowState
        {
            get 
            {
                WorkflowState workflowState;
                workflowState = ViewState["currentWorkflowState"] == null ? WorkflowState.None : (WorkflowState)Convert.ToInt32(ViewState["currentWorkflowState"]);
                return workflowState;
            }
            set 
            {
                ViewState["currentWorkflowState"] = Convert.ToInt32(value);
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

        private void BindContentVersionGrid()
        {
            grdContent.DataSource = ContentController.GetContentVersions(ModuleId);
            grdContent.DataBind();
        }

        private void BindVersionComments()
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

                if (!IsNew)
                {
                    contentInfo.ContentId = ContentId;
                }
                contentInfo.ModuleId = ModuleId;
                contentInfo.DeskTopHTML = teContent.Text;
                contentInfo.DesktopSummary = txtDesktopSummary.Text;
                contentInfo.CreatedByUserID = this.UserId;                

                // persist the content
                switch (CurrentWorkflowState)
                {
                    case WorkflowState.None:                        
                        ContentController.UpdateContent(contentInfo);
                        break;
                    case WorkflowState.Reject:
                        contentInfo.WorkflowState = Convert.ToInt32(WorkflowState.None);
                        CurrentWorkflowState = WorkflowState.None;
                        ContentController.UpdateContent(contentInfo);
                        break;
                    default:
                        ContentId = ContentController.AddContent(contentInfo);
                        break;
                }

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
            ContentController.AddContentComment(ContentId, UserId, txtComment.Text);
        }

        private void UpdateContentWorkflow(WorkflowState workflowState)
        {
            CurrentWorkflowState = workflowState;
            ContentController.UpdateContentWorkflow(ContentId, Convert.ToInt32(CurrentWorkflowState));
            BindContentVersionGrid();
            ManageWorkFlowState();
        }

        private void ModuleActionDenied()
        {
            Response.Redirect(SharpContent.Common.Globals.AccessDeniedURL(Localization.GetString("ModuleAction.Error")), true);
        }

        private void ManageWorkFlowState()
        {
            cmdSave.Visible = false;
            cmdPublish.Visible = false;
            cmdApprove.Visible = false;
            cmdSubmit.Visible = false;
            cmdReject.Visible = false;
            cmdBanned.Visible = false;
            switch (CurrentEditMode)
            {
                case EditMode.Author:    
                    
                    tcContentEditor.Items[2].Visible = !IsNew;
                    if (!IsNew)
                    {
                        cmdSubmit.Visible = CurrentWorkflowState == WorkflowState.None;
                    }
                    cmdSave.Visible = CurrentWorkflowState != WorkflowState.Banned;                    
                    break;

                case EditMode.Publish:

                    tcContentEditor.Items[0].Visible = false;
                    tcContentEditor.Items[2].Visible = !IsNew;                    
                    if (!Page.IsPostBack)
                    {
                        mvContentEditor.ActiveViewIndex = 1;
                    }
                    switch (CurrentWorkflowState)
                    {
                        case WorkflowState.Approve:
                            cmdPublish.Visible = true;
                            break;
                        case WorkflowState.Submit:
                            cmdApprove.Visible = true;
                            cmdReject.Visible = true;
                            cmdBanned.Visible = true;
                            break;
                        case WorkflowState.Reject:
                            break;
                        case WorkflowState.Banned:
                            break;
                    }
                    break;
            }
        }

        #endregion

        #region "Public Methods"

        public string WorkFlowStateFlagURL(int commentFlag)
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
                    commentFlagURL = "~/Images/flag-black.gif";
                    break;
            }
            return commentFlagURL;
        }

        #endregion

        #region "Event Handlers"

        protected void Page_Init(object sender, System.EventArgs e)
        {
            cmdUpdateComments.Click += new EventHandler(cmdUpdateComments_Click);
            cmdSave.Click += new EventHandler(cmdSave_Click);
            cmdPublish.Click += new EventHandler(cmdPublish_Click);
            cmdApprove.Click += new EventHandler(cmdWorkflowState_Click);
            cmdSubmit.Click += new EventHandler(cmdWorkflowState_Click);
            cmdReject.Click += new EventHandler(cmdWorkflowState_Click);
            cmdBanned.Click += new EventHandler(cmdWorkflowState_Click);
            cmdCancel.Click += new EventHandler(cmdCancel_Click);
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            try
            {
                if (!Page.IsPostBack)
                {
                    // Get all of the version of content for this module.
                    BindContentVersionGrid();

                    // Get the currently published content for the module.
                    ContentInfo contentInfo = ContentController.GetContent(ModuleId);

                    // Initialize control values if contentInfo is not null.
                    if ((contentInfo != null))
                    {
                        IsNew = false;
                        ContentId = contentInfo.ContentId;

                        teContent.Text = contentInfo.DeskTopHTML;
                        lblPreview.Text = Server.HtmlDecode(contentInfo.DeskTopHTML);
                        txtDesktopSummary.Text = Server.HtmlDecode((string)contentInfo.DesktopSummary);
                        CurrentWorkflowState = (WorkflowState)contentInfo.WorkflowState;
                        grdContent.SelectedIndex = contentInfo.ContentVersion - 1;
                        
                        BindVersionComments();
                    }
                    else
                    {
                        IsNew = true;

                        // Get default content from resource file.
                        teContent.Text = Localization.GetString("AddContent", LocalResourceFile);
                        txtDesktopSummary.Text = "";
                    }

                }

                ManageWorkFlowState();
                
            }

            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        protected void cmdUpdateComments_Click(object sender, EventArgs e)
        {
            UpdateComment();
            BindContentVersionGrid();
            BindVersionComments();
            txtComment.Text = String.Empty;
        }

        protected void cmdSave_Click(object sender, System.EventArgs e)
        {
            // If the user is not a member of the "Content Author" role or an Admin then they can not save content.
            if (PortalSecurity.IsInRole("Content Author") || PortalSecurity.IsInRole(PortalSettings.AdministratorRoleName))
            {                
                int oldContentId = ContentId;
                SaveContent();
                BindContentVersionGrid();
                BindVersionComments();
                if (oldContentId != ContentId)
                {
                    grdContent.SelectedIndex = grdContent.Rows.Count - 1;
                }
                IsNew = false;
                ManageWorkFlowState();
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

        protected void cmdWorkflowState_Click(object sender, System.EventArgs e)
        {
            UpdateContentWorkflow((WorkflowState)Enum.Parse(typeof(WorkflowState), ((CommandButton)sender).CommandName));
        }
       
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

        protected void grdContent_RowEditing(object sender, System.Web.UI.WebControls.GridViewEditEventArgs e)
        {
            grdContent.SelectedIndex = e.NewEditIndex;
            ContentId = Convert.ToInt32(grdContent.DataKeys[e.NewEditIndex].Value);
            ContentInfo contentInfo = ContentController.GetContentById(ContentId);

            teContent.Text = contentInfo.DeskTopHTML;
            lblPreview.Text = Server.HtmlDecode(contentInfo.DeskTopHTML);
            txtDesktopSummary.Text = Server.HtmlDecode(contentInfo.DesktopSummary);
            CurrentWorkflowState = (WorkflowState)contentInfo.WorkflowState;
            BindVersionComments();

            IsNew = false;

            ManageWorkFlowState();
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
