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
using System.Web.UI.WebControls;
using SharpContent.Entities.Modules;
using SharpContent.Services.Exceptions;
using SharpContent.Services.Localization;
using SharpContent.UI.Utilities;
using SharpContent.UI.WebControls;
using TreeNode=SharpContent.UI.WebControls.TreeNode;

namespace SharpContent.Common.Lists
{
    /// <summary>
    /// Manages Entry List
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <history>
    /// 	[tamttt] 20/10/2004	Created
    /// </history>
    public partial class ListEditor : PortalModuleBase
    {
        private ListInfo selListInfo;

        private enum eImageType
        {
            Folder = 0,
            Page = 1
        }

        /// <summary>
        /// Page load, bind tree and enable controls
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected void Page_Load( Object sender, EventArgs e )
        {
            try
            {
                if (!Page.IsPostBack)
                {

                    // configure tree
                    SCPtree.ImageList.Add(ResolveUrl("~/images/folder.gif"));
                    SCPtree.ImageList.Add(ResolveUrl("~/images/file.gif"));
                    SCPtree.IndentWidth = 10;
                    SCPtree.CollapsedNodeImage = ResolveUrl("~/images/max.gif");
                    SCPtree.ExpandedNodeImage = ResolveUrl("~/images/min.gif");

                    BindTree();

                    this.rowListdetails.Visible = false;
                    this.rowEntryGrid.Visible = false;
                    this.rowEntryEdit.Visible = false;

                }

            }
            catch (Exception exc) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        /// <summary>
        /// Populate list entries based on value selected in SCPtree
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected void SCPTree_NodeClick( object source, SCPTreeNodeClickEventArgs e )
        {
            SelectedKey = e.Node.Key;

            InitList();
            BindListInfo();
            BindGrid();
        }

        /// <summary>
        /// Handles events when clicking image button in the grid (Edit/Up/Down)
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected void grdEntries_ItemCommand( object source, DataGridCommandEventArgs e )
        {
            try
            {
                ListController ctlLists = new ListController();
                int entryID = Convert.ToInt32(((DataGrid)source).DataKeys[e.Item.ItemIndex]);

                switch (e.CommandName.ToLower())
                {
                    case "delete":
                        DeleteItem(entryID);
                        InitList();
                        BindGrid();
                        break;
                    case "edit":
                        EnableView(false);
                        EnableEdit(false);

                        ListEntryInfo entry = ctlLists.GetListEntryInfo(entryID);
                        this.txtEntryID.Text = entryID.ToString();
                        this.txtParentKey.Text = entry.ParentKey;
                        this.txtEntryName.Text = entry.ListName;
                        this.txtEntryValue.Text = entry.Value;
                        this.txtEntryText.Text = entry.Text;
                        this.txtEntryName.ReadOnly = true;
                        this.cmdSaveEntry.CommandName = "Update";

                        if (!(entry.DefinitionID == -1))
                        {
                            this.cmdDelete.Visible = true;
                            ClientAPI.AddButtonConfirm(cmdDelete, Localization.GetString("DeleteItem"));
                        }
                        else
                        {
                            this.cmdDelete.Visible = false;
                        }

                        break;
                    case "up":
                        ctlLists.UpdateListSortOrder(entryID, true);
                        InitList();
                        BindGrid();
                        break;
                    case "down":
                        ctlLists.UpdateListSortOrder(entryID, false);
                        InitList();
                        BindGrid();
                        break;
                }

            }
            catch (Exception exc) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        /// <summary>
        /// Handles Add New List command
        /// </summary>
        /// <remarks>
        /// Using "CommandName" property of cmdSaveEntry to determine this is a new list
        /// </remarks>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected void cmdAddList_Click( object sender, EventArgs e )
        {

            EnableView(false);
            EnableEdit(true);

            this.txtParentKey.Text = "";
            this.txtEntryName.Text = "";
            this.txtEntryValue.Text = "";
            this.txtEntryText.Text = "";
            this.txtEntryName.ReadOnly = false;
            this.cmdSaveEntry.CommandName = "SaveList";


            ListController ctlLists = new ListController();
            ddlSelectList.DataSource = ctlLists.GetListInfoCollection();
            ddlSelectList.DataTextField = "DisplayName";
            ddlSelectList.DataValueField = "Key";
            ddlSelectList.DataBind();
            ddlSelectList.Items.Insert(0, new ListItem(Localization.GetString("None_Specified"), ""));

            // Reset dropdownlist
            ddlSelectParent.ClearSelection();
            ddlSelectParent.Enabled = false;
        }

        /// <summary>
        /// Select a list in dropdownlist
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected void ddlSelectList_SelectedIndexChanged( object sender, EventArgs e )
        {

            ListController ctlLists = new ListController();
            string selList = ddlSelectList.SelectedItem.Value;
            string listName = selList.Substring(selList.IndexOf(":") + 1);
            string parentKey = selList.Replace(listName, "").TrimEnd(':');

            ddlSelectParent.Enabled = true;
            ddlSelectParent.DataSource = ctlLists.GetListEntryInfoCollection(listName, parentKey);
            ddlSelectParent.DataTextField = "DisplayName";
            ddlSelectParent.DataValueField = "Key";
            ddlSelectParent.DataBind();
            ddlSelectParent.Items.Insert(0, new ListItem(Localization.GetString("None_Specified"), ""));

        }

        /// <summary>
        /// Handles Add New Entry command
        /// </summary>
        /// <remarks>
        /// Using "CommandName" property of cmdSaveEntry to determine this is a new entry of an existing list
        /// </remarks>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected void cmdAddEntry_Click( object sender, EventArgs e )
        {

            string listName = SelectedKey.Substring(SelectedKey.IndexOf(":") + 1);
            string parentKey = SelectedKey.Replace(listName, "").TrimEnd(':');

            EnableView(false);
            EnableEdit(false);

            this.txtParentKey.Text = parentKey;
            this.txtEntryName.Text = listName;
            this.txtEntryValue.Text = "";
            this.txtEntryText.Text = "";
            this.txtEntryName.ReadOnly = true;
            this.cmdDelete.Visible = false;
            this.cmdSaveEntry.CommandName = "SaveEntry";
        }

        /// <summary>
        /// Handles cmdSaveEntry.Click
        /// </summary>
        /// <remarks>
        /// Using "CommandName" property of cmdSaveEntry to determine action to take (ListUpdate/AddEntry/AddList)
        /// </remarks>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected void cmdSaveEntry_Click( object sender, EventArgs e )
        {
            ListController ctlLists = new ListController();
            ListEntryInfo entry = new ListEntryInfo();
            entry.ListName = txtEntryName.Text;
            entry.Value = txtEntryValue.Text;
            entry.Text = txtEntryText.Text;

            switch (cmdSaveEntry.CommandName.ToLower())
            {
                case "update":
                    entry.ParentKey = txtParentKey.Text;
                    entry.EntryID = Int16.Parse(txtEntryID.Text);

                    ctlLists.UpdateListEntry(entry);

                    InitList();
                    EnableView(true);
                    //BindListInfo()
                    BindGrid();

                    break;
                case "saveentry":
                    entry.ParentKey = txtParentKey.Text;
                    if (EnableSortOrder)
                    {
                        entry.SortOrder = 1;
                    }
                    else
                    {
                        entry.SortOrder = 0;
                    }

                    ctlLists.AddListEntry(entry);

                    InitList();
                    BindListInfo();
                    BindTree();
                    BindGrid();

                    break;
                case "savelist":
                    string strKey = "";
                    string strText = "";
                    if (ddlSelectParent.SelectedIndex != -1)
                    {
                        strKey = ddlSelectParent.SelectedItem.Value;
                        strText = ddlSelectParent.SelectedItem.Text;
                        entry.ParentKey = strKey;
                        strKey += ":";
                        strText += ":";
                    }

                    if (chkEnableSortOrder.Checked)
                    {
                        entry.SortOrder = 1;
                    }
                    else
                    {
                        entry.SortOrder = 0;
                    }

                    ctlLists.AddListEntry(entry);

                    strKey += this.txtEntryName.Text;
                    strText += this.txtEntryName.Text;

                    SelectedKey = strKey;
                    SelectedText = strText;

                    BindTree();
                    InitList();
                    BindListInfo();
                    BindGrid();
                    //Response.Redirect(NavigateURL(TabId))
                    break;
            }

        }

        /// <summary>
        /// Delete List
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected void cmdDeleteList_Click( object sender, EventArgs e )
        {
            string listName = SelectedKey.Substring(SelectedKey.IndexOf(":") + 1);
            string parentKey = SelectedKey.Replace(listName, "").TrimEnd(':');

            ListController ctlLists = new ListController();
            ctlLists.DeleteList(listName, parentKey);

            Response.Redirect(Globals.NavigateURL(TabId));
            //BindTree()            
        }

        /// <summary>
        /// Delete List
        /// </summary>
        /// <remarks>
        /// If deleting entry is not the last one in the list, rebinding the grid, otherwise return back to main page (rebinding SCPTree)
        /// </remarks>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected void cmdDelete_Click( object sender, EventArgs e )
        {
            DeleteItem(Convert.ToInt32(txtEntryID.Text));
        }

        /// <summary>
        /// Cancel
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected void cmdCancel_Click( object sender, EventArgs e )
        {
            try
            {
                if (SelectedKey != "")
                {
                    EnableView(true);
                    BindGrid();
                }
                else
                {
                    this.rowListdetails.Visible = false;
                    this.rowEntryGrid.Visible = false;
                    this.rowEntryEdit.Visible = false;
                }
            }
            catch (Exception exc) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        /// <summary>
        /// Loads top level entry list into SCPTree
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        private void BindTree()
        {
            ListController ctlLists = new ListController();
            ListInfoCollection colLists = ctlLists.GetListInfoCollection();
            Hashtable indexLookup = new Hashtable();

            SCPtree.TreeNodes.Clear();

            foreach (ListInfo Lists in colLists)
            {
                TreeNode node = new TreeNode(Lists.DisplayName);
                node.Key = Lists.Key;
                node.ToolTip = Lists.EntryCount + " entries";
                node.ImageIndex = (int)eImageType.Folder;

                if (Lists.Level == 0)
                {
                    SCPtree.TreeNodes.Add(node);
                }
                else
                {
                    if (indexLookup[Lists.ParentList] != null)
                    {
                        TreeNode parentNode = (TreeNode)(indexLookup[Lists.ParentList]);
                        parentNode.TreeNodes.Add(node);
                    }
                }

                // Add index key here to find it later, should suggest with Joe to add it to SCPTree
                if (indexLookup[Lists.Key] == null)
                {
                    indexLookup.Add(Lists.Key, node);
                }

            }

        }

        private void DeleteItem( int entryId )
        {
            try
            {
                ListController ctlLists = new ListController();

                // If this is the last entry of the list, delete list
                if (SelectedList.Count > 1)
                {
                    ctlLists.DeleteListEntryByID(entryId, true);
                    EnableView(true);
                    InitList();
                    BindListInfo();
                    BindTree();
                    BindGrid();
                }
                else
                {
                    ctlLists.DeleteListEntryByID(entryId, true);
                    BindTree();
                    this.rowListdetails.Visible = false;
                    this.rowEntryGrid.Visible = false;
                    this.rowEntryEdit.Visible = false;
                }

            }
            catch (Exception exc) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }

        }

        /// <summary>
        /// Loads top level entry list
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected TreeNode GetParentNode( string ParentKey )
        {
            for (int i = 0; i < SCPtree.TreeNodes.Count; i++)
            {
                if (SCPtree.TreeNodes[i].Key == ParentKey)
                {
                    return SCPtree.TreeNodes[i];
                }
            }
            return null;
        }

        /// <summary>
        /// Loads top level entry list
        /// </summary>       
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        private void InitList()
        {
            ListController ctlLists = new ListController();
            string listName = SelectedKey.Substring(SelectedKey.IndexOf(":") + 1);
            string parentKey = SelectedKey.Replace(listName, "").TrimEnd(':');

            selListInfo = ctlLists.GetListInfo(listName, parentKey);
            SelectedText = selListInfo.DisplayName;
            EnableSortOrder = selListInfo.EnableSortOrder;
            SystemList = selListInfo.SystemList;

        }

        /// <summary>
        /// Loads top level entry list
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        private void BindListInfo()
        {
            string listName = SelectedText.Substring(SelectedText.IndexOf(":") + 1);
            string parent = SelectedText.Replace(listName, "").TrimEnd(':');

            this.lblListParent.Text = parent;
            this.lblListName.Text = listName;

            this.rowListParent.Visible = (selListInfo.Parent.Length > 0); //(parent.Length > 0)
            if (!SystemList)
            {
                this.cmdDeleteList.Visible = true;
                ClientAPI.AddButtonConfirm(cmdDeleteList, Localization.GetString("DeleteItem"));
            }
            else
            {
                this.cmdDeleteList.Visible = false;
            }

        }

        /// <summary>
        /// Loads top level entry list
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        private void BindGrid()
        {
            EnableView(true);
            foreach (DataGridColumn column in grdEntries.Columns)
            {
                if (column.GetType() == typeof(ImageCommandColumn))
                {
                    //Manage Delete Confirm JS
                    ImageCommandColumn imageColumn = (ImageCommandColumn)column;
                    if (imageColumn.CommandName == "Delete")
                    {
                        imageColumn.OnClickJS = Localization.GetString("DeleteItem");
                        if (SystemList)
                        {
                            column.Visible = false;
                        }
                        else
                        {
                            column.Visible = true;
                        }
                    }
                    //Localize Image Column Text
                    if (imageColumn.CommandName != "")
                    {
                        imageColumn.Text = Localization.GetString(imageColumn.CommandName, this.LocalResourceFile);
                    }

                }
            }

            grdEntries.DataSource = SelectedList; //selList
            grdEntries.DataBind();

            this.lblEntryCount.Text = SelectedList.Count + " entries";

        }

        /// <summary>
        /// Switching to view mode, change controls visibility for viewing
        /// </summary>
        /// <param name="ViewMode">Boolean value to determine View or Edit mode</param>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        private void EnableView( bool ViewMode )
        {
            this.rowListdetails.Visible = true;
            this.rowEntryGrid.Visible = ViewMode;
            this.rowEntryEdit.Visible = (!ViewMode);

        }

        /// <summary>
        /// Switching to edit mode, change controls visibility for editing depends on AddList params
        /// </summary>
        /// <param name="AddList">Boolean value to determine Add or Edit mode</param>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        private void EnableEdit( bool AddList )
        {
            this.rowListdetails.Visible = (!AddList);
            this.rowSelectList.Visible = AddList;
            this.rowSelectParent.Visible = AddList;
            this.rowEnableSortOrder.Visible = (AddList);
            this.rowParentKey.Visible = false;
            this.cmdDelete.Visible = false;
        }

        /// <summary>
        /// Selected list
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        private ListEntryInfoCollection SelectedList
        {
            get
            {
                string listName = SelectedKey.Substring(SelectedKey.IndexOf(":") + 1);
                string parentKey = SelectedKey.Replace(listName, "").TrimEnd(':');

                ListController ctlLists = new ListController();
                return ctlLists.GetListEntryInfoCollection(listName, "", parentKey);
            }
        }

        /// <summary>
        /// Selected parent key
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected string SelectedParentKey
        {
            get
            {
                return ViewState["SelectedParentKey"].ToString();
            }
            set
            {
                ViewState["SelectedParentKey"] = value;
            }
        }

        /// <summary>
        /// Selected key
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected string SelectedKey
        {
            get
            {
                if( ViewState["SelectedKey"] != null )
                {
                    return ViewState["SelectedKey"].ToString();
                }
                else
                {
                    return "";
                }
            }
            set
            {
                ViewState["SelectedKey"] = value;
            }
        }

        /// <summary>
        /// Selected text
        /// </summary>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected string SelectedText
        {
            get
            {
                return ViewState["SelectedText"].ToString();
            }
            set
            {
                ViewState["SelectedText"] = value;
            }
        }

        /// <summary>
        /// Property to determine if this list has custom sort order
        /// </summary>
        /// <remarks>
        /// Up/Down button in datagrid will be visibled based on this property.
        /// If disable, list will be sorted anphabetically
        /// </remarks>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected bool EnableSortOrder
        {
            get
            {
                if( ViewState["EnableSortOrder"] == null )
                {
                    ViewState["EnableSortOrder"] = false;
                }
                return Convert.ToBoolean( ViewState["EnableSortOrder"] );
            }
            set
            {
                ViewState["EnableSortOrder"] = value;
            }
        }

        /// <summary>
        /// Property to determine if this list is system (SCP core)
        /// </summary>
        /// <remarks>
        /// Default entries in system list can not be deleted
        /// Entries in system list is sorted anphabetically
        /// </remarks>
        /// <history>
        ///     [tamttt] 20/10/2004	Created
        /// </history>
        protected bool SystemList
        {
            get
            {
                if( ViewState["SystemList"] == null )
                {
                    ViewState["SystemList"] = false;
                }
                return Convert.ToBoolean( ViewState["SystemList"] );
            }
            set
            {
                ViewState["SystemList"] = value;
            }
        }

    }
}