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
using SharpContent;
using SharpContent.Common;
using SharpContent.Modules.HTML;
using SharpContent.Services.Exceptions;
using SharpContent.Services.Localization;
using SharpContent.UI.Utilities;
using SharpContent.UI.WebControls;
using SharpContent.Common.Utilities;

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
            // get Content object
            ContentController contentController = new ContentController();
            grdContent.DataSource = contentController.GetContentVersions(ModuleId);
            grdContent.DataBind();
        }

        private void SaveContent(bool publishContent)
        {
            try
            {
                // create HTMLText object
                ContentController contentController = new ContentController();
                ContentInfo contentInfo = new ContentInfo();

                // set content values
                if (!_isNew)
                {
                    contentInfo.ContentId = ContentId;
                }                
                contentInfo.ModuleId = ModuleId;
                contentInfo.DeskTopHTML = teContent.Text;
                contentInfo.DesktopSummary = txtDesktopSummary.Text;
                contentInfo.CreatedByUserID = this.UserId;
                contentInfo.Publish = publishContent;

                // persist the content
                ContentId = contentController.AddContent(contentInfo);

                // refresh cache
                SynchronizeModule();
                
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        #endregion

        #region "Public Methods"

        #endregion

        #region "Event Handlers"

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
                    // get Content object
                    ContentController contentController = new ContentController();
                    ContentInfo contentInfo = contentController.GetContent(ModuleId);

                    if ((contentInfo != null))
                    {
                        ContentId = contentInfo.ContentId;

                        // initialize control values
                        teContent.Text = contentInfo.DeskTopHTML;
                        txtDesktopSummary.Text = Server.HtmlDecode((string)contentInfo.DesktopSummary);
                        _isNew = false;
                    }
                    else
                    {
                        // get default content from resource file
                        teContent.Text = Localization.GetString("AddContent", LocalResourceFile);
                        txtDesktopSummary.Text = "";
                        _isNew = true;
                    }
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
        /// lbtnEditor_Click runs when the Editor button is clicked
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// </history>
        /// -----------------------------------------------------------------------------
        protected void lbtnEditor_Click(object sender, EventArgs e)
        {
            mvContentEditor.ActiveViewIndex = 0;
        }

        /// -----------------------------------------------------------------------------
        /// <summary>
        /// cmdPreview_Click runs when the preview button is clicked
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// </history>
        /// -----------------------------------------------------------------------------
        protected void cmdPreview_Click(object sender, System.EventArgs e)
        {
            try
            {
                string strDesktopHTML;

                strDesktopHTML = teContent.Text;

                lblPreview.Text = SharpContent.Common.Globals.ManageUploadDirectory(Server.HtmlDecode(strDesktopHTML), PortalSettings.HomeDirectory);
                mvContentEditor.ActiveViewIndex = 1;
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
            SaveContent(false);
            BindGrid();
        }

        protected void cmdPublish_Click(object sender, EventArgs e)
        {
            SaveContent(true);

            // redirect back to portal
            Response.Redirect(SharpContent.Common.Globals.NavigateURL(), true);
        }

        protected void grdContent_RowEditing(object sender, System.Web.UI.WebControls.GridViewEditEventArgs e)
        {
            ContentId = Convert.ToInt32(grdContent.DataKeys[e.NewEditIndex].Value);
            ContentController contentController = new ContentController();
            ContentInfo contentInfo = contentController.GetContentById(ContentId);

            teContent.Text = contentInfo.DeskTopHTML;
            txtDesktopSummary.Text = Server.HtmlDecode((string)contentInfo.DesktopSummary);
            ViewState["IsNew"] = false;
        }

        #endregion

    }

}
