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
using SharpContent.Common;
using SharpContent.Modules.NavigationProvider;
using SharpContent.Services.Exceptions;
using SharpContent.Services.Localization;
using SharpContent.UI.WebControls;

namespace SharpContent.UI.Skins.Controls
{
    /// Project	 : SharpContent
    /// Class	 : TreeViewMenu
    /// <summary>
    /// TreeViewMenu is a Skin Object that creates a Menu using the SCP Treeview Control
    /// to provide a Windows Explore like Menu.
    /// </summary>
    /// <remarks></remarks>
    /// <history>
    /// 	[cnurse]	12/8/2004	created
    /// </history>
    public partial class TreeViewMenu : NavObjectBase
    {
        
        private enum eImageType
        {
            FolderClosed = 0,
            FolderOpen = 1,
            Page = 2,
            GotoParent = 3
        }

        private string _bodyCssClass = "";
        private string _cssClass = "";
        private string _headerCssClass = "";
        private string _headerTextCssClass = "Head";
        private string _headerText = "";
        private string _resourceKey = "";
        private bool _includeHeader = true;
        private string _nodeChildCssClass = "Normal";
        private string _nodeClosedImage = "~/images/folderclosed.gif";
        private string _nodeCollapseImage = "~/images/min.gif";
        private string _nodeCssClass = "Normal";
        private string _nodeExpandImage = "~/images/max.gif";
        private string _nodeLeafImage = "~/images/file.gif";
        private string _nodeOpenImage = "~/images/folderopen.gif";
        private string _nodeOverCssClass = "Normal";
        private string _nodeSelectedCssClass = "Normal";
        private bool _nowrap = false;
        private string _treeCssClass = "";
        private string _treeGoUpImage = "~/images/folderup.gif";
        private int _treeIndentWidth = 10;
        private string _width = "100%";

        private const string MyFileName = "TreeViewMenu.ascx";

        public string BodyCssClass
        {
            get
            {
                if (_bodyCssClass != null) return _bodyCssClass; else return String.Empty;
            }
            set
            {
                _bodyCssClass = value;
            }
        }

        public string CssClass
        {
            get
            {
                if (_cssClass != null) return _cssClass; else return String.Empty;
            }
            set
            {
                _cssClass = value;
            }
        }

        public string HeaderCssClass
        {
            get
            {
                if (_headerCssClass != null) return _headerCssClass; else return String.Empty;
            }
            set
            {
                _headerCssClass = value;
            }
        }

        public string HeaderTextCssClass
        {
            get
            {
                if (_headerTextCssClass != null) return _headerTextCssClass; else return String.Empty;
            }
            set
            {
                _headerTextCssClass = value;
            }
        }

        public string HeaderText
        {
            get
            {
                if (_headerText != null) return _headerText; else return String.Empty;
            }
            set
            {
                _headerText = value;
            }
        }

        public bool IncludeHeader
        {
            get
            {
                return _includeHeader;
            }
            set
            {
                _includeHeader = value;
            }
        }

        public string NodeChildCssClass
        {
            get
            {
                if (_nodeChildCssClass != null) return _nodeChildCssClass; else return String.Empty;
            }
            set
            {
                _nodeChildCssClass = value;
            }
        }

        public string NodeClosedImage
        {
            get
            {
                if (_nodeClosedImage != null) return _nodeClosedImage; else return String.Empty;
            }
            set
            {
                _nodeClosedImage = value;
            }
        }

        public string NodeCollapseImage
        {
            get
            {
                if (_nodeCollapseImage != null) return _nodeCollapseImage; else return String.Empty;
            }
            set
            {
                _nodeCollapseImage = value;
            }
        }

        public string NodeCssClass
        {
            get
            {
                if (_nodeCssClass != null) return _nodeCssClass; else return String.Empty;
            }
            set
            {
                _nodeCssClass = value;
            }
        }

        public string NodeExpandImage
        {
            get
            {
                if (_nodeExpandImage != null) return _nodeExpandImage; else return String.Empty;
            }
            set
            {
                _nodeExpandImage = value;
            }
        }

        public string NodeLeafImage
        {
            get
            {
                if (_nodeLeafImage != null) return _nodeLeafImage; else return String.Empty;
            }
            set
            {
                _nodeLeafImage = value;
            }
        }

        public string NodeOpenImage
        {
            get
            {
                if (_nodeOpenImage != null) return _nodeOpenImage; else return String.Empty;
            }
            set
            {
                _nodeOpenImage = value;
            }
        }

        public string NodeOverCssClass
        {
            get
            {
                if (_nodeOverCssClass != null) return _nodeOverCssClass; else return String.Empty;
            }
            set
            {
                _nodeOverCssClass = value;
            }
        }

        public string NodeSelectedCssClass
        {
            get
            {
                if (_nodeSelectedCssClass != null) return _nodeSelectedCssClass; else return String.Empty;
            }
            set
            {
                _nodeSelectedCssClass = value;
            }
        }

        public bool NoWrap
        {
            get
            {
                return _nowrap;
            }
            set
            {
                _nowrap = value;
            }
        }

        public string ResourceKey
        {
            get
            {
                if (_resourceKey != null) return _resourceKey; else return String.Empty;
            }
            set
            {
                _resourceKey = value;
            }
        }

        public string TreeCssClass
        {
            get
            {
                if (_treeCssClass != null) return _treeCssClass; else return String.Empty;
            }
            set
            {
                _treeCssClass = value;
            }
        }

        public string TreeGoUpImage
        {
            get
            {
                if (_treeGoUpImage != null) return _treeGoUpImage; else return String.Empty;
            }
            set
            {
                _treeGoUpImage = value;
            }
        }

        public int TreeIndentWidth
        {
            get
            {
                return _treeIndentWidth;
            }
            set
            {
                _treeIndentWidth = value;
            }
        }

        public string Width
        {
            get
            {
                if (_width != null) return _width; else return String.Empty;
            }
            set
            {
                _width = value;
            }
        }

        /// <summary>
        /// The BuildTree helper method is used to build the tree
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        ///     [cnurse]        12/8/2004   Created
        ///		[Jon Henning]	3/21/06		Updated to handle Auto-expand and AddUpNode
        /// </history>
        private void BuildTree( SCPNode objNode, bool blnPODRequest ) //JH - POD
        {
            bool blnAddUpNode = false;
            SCPNodeCollection objNodes;
            objNodes = GetNavigationNodes( objNode );

            if( blnPODRequest == false )
            {
                switch( Level.ToLower() )
                {
                    case "root":

                        break;
                    case "child":

                        blnAddUpNode = true;
                        break;
                    default:

                        if( Level.ToLower() != "root" && PortalSettings.ActiveTab.BreadCrumbs.Count > 1 )
                        {
                            blnAddUpNode = true;
                        }
                        break;
                }
            }
            //add goto Parent node
            if( blnAddUpNode )
            {
                SCPNode objParentNode = new SCPNode();
                objParentNode.ID = PortalSettings.ActiveTab.ParentId.ToString();
                objParentNode.Key = objParentNode.ID;
                objParentNode.Text = Localization.GetString( "Parent", Localization.GetResourceFile( this, MyFileName ) );
                objParentNode.ToolTip = Localization.GetString( "GoUp", Localization.GetResourceFile( this, MyFileName ) );
                objParentNode.CSSClass = NodeCssClass;
                objParentNode.Image = ResolveUrl( TreeGoUpImage );
                objParentNode.ClickAction = eClickAction.PostBack;
                objNodes.InsertBefore( 0, objParentNode );
            }

            SCPNode objPNode;
            foreach( SCPNode tempLoopVar_objPNode in objNodes ) //clean up to do in processnodes???
            {
                objPNode = tempLoopVar_objPNode;
                ProcessNodes( objPNode );
            }

            this.Bind( objNodes );

            //technically this should always be a SCPtree.  If using dynamic controls Nav.ascx should be used.  just being safe.
            if( this.Control.NavigationControl is SCPTree )
            {
                SCPTree objTree = (SCPTree)this.Control.NavigationControl;
                if( objTree.SelectedTreeNodes.Count > 0 )
                {
                    TreeNode objTNode = (TreeNode)objTree.SelectedTreeNodes[0];
                    if( objTNode.SCPNodes.Count > 0 ) //only expand it if nodes are not pending
                    {
                        objTNode.Expand();
                    }
                }
            }
        }

        private void ProcessNodes( SCPNode objParent )
        {
            //If Boolean.Parse(GetValue(RootOnly, "False")) AndAlso objParent.HasNodes Then
            //	objParent.HasNodes = False
            //End If

            if( !String.IsNullOrEmpty(objParent.Image) )
            {
                //imagepath applied in provider...
            }
            else if( objParent.HasNodes )
            {
                objParent.Image = ResolveUrl( NodeClosedImage );
            }
            else
            {
                objParent.Image = ResolveUrl( this.NodeLeafImage );
            }

            SCPNode objNode;
            foreach( SCPNode tempLoopVar_objNode in objParent.SCPNodes )
            {
                objNode = tempLoopVar_objNode;
                ProcessNodes( objNode );
            }
        }

        /// <summary>
        /// Sets common properties on SCPTree control
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        ///     [cnurse]        12/8/2004   Created
        /// </history>
        private void InitializeTree()
        {
            if( String.IsNullOrEmpty(this.PathImage) )
            {
                this.PathImage = PortalSettings.HomeDirectory;
            }
            if( String.IsNullOrEmpty(this.PathSystemImage) )
            {
                this.PathSystemImage = ResolveUrl( "~/images/" );
            }
            //SCPTree.IndentWidth = TreeIndentWidth	'FIX!
            if( String.IsNullOrEmpty(this.IndicateChildImageRoot) )
            {
                this.IndicateChildImageRoot = ResolveUrl( NodeExpandImage );
            }
            if( String.IsNullOrEmpty(this.IndicateChildImageSub) )
            {
                this.IndicateChildImageSub = ResolveUrl( NodeExpandImage );
            }
            if( String.IsNullOrEmpty(this.IndicateChildImageExpandedRoot) )
            {
                this.IndicateChildImageExpandedRoot = ResolveUrl( NodeCollapseImage );
            }
            if( String.IsNullOrEmpty(this.IndicateChildImageExpandedSub) )
            {
                this.IndicateChildImageExpandedSub = ResolveUrl( NodeCollapseImage );
            }
            if( String.IsNullOrEmpty(this.CSSNode) )
            {
                this.CSSNode = NodeChildCssClass; //.DefaultChildNodeCssClass
            }
            if( String.IsNullOrEmpty(this.CSSNodeRoot) )
            {
                this.CSSNodeRoot = NodeCssClass; //DefaultNodeCssClass	???
            }
            if( String.IsNullOrEmpty(this.CSSNodeHover) )
            {
                this.CSSNodeHover = NodeOverCssClass; //DefaultNodeCssClassOver
            }
            if( String.IsNullOrEmpty(this.CSSNodeSelectedRoot) )
            {
                this.CSSNodeSelectedRoot = NodeSelectedCssClass; //DefaultNodeCssClassSelected
            }
            if( String.IsNullOrEmpty(this.CSSNodeSelectedSub) )
            {
                this.CSSNodeSelectedSub = NodeSelectedCssClass; //DefaultNodeCssClassSelected
            }
            if( String.IsNullOrEmpty(this.CSSControl) )
            {
                this.CSSControl = TreeCssClass; //CssClass
            }
        }

        /// <summary>
        /// The Page_Load server event handler on this user control is used
        /// to populate the tree with the Pages.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <remarks>
        /// </remarks>
        /// <history>
        /// 	[cnurse]	12/9/2004	Created
        /// </history>
        protected void Page_Load( Object sender, EventArgs e )
        {
            try
            {
                if( Page.IsPostBack == false )
                {
                    BuildTree( null, false );

                    //Main Table Properties
                    if( !String.IsNullOrEmpty(this.Width) )
                    {
                        tblMain.Width = this.Width;
                    }
                    if( !String.IsNullOrEmpty(this.CssClass) )
                    {
                        tblMain.Attributes.Add( "class", this.CssClass );
                    }

                    //Header Properties
                    if( !String.IsNullOrEmpty(this.HeaderCssClass) )
                    {
                        cellHeader.Attributes.Add( "class", this.HeaderCssClass );
                    }
                    if( !String.IsNullOrEmpty(this.HeaderTextCssClass) )
                    {
                        lblHeader.CssClass = this.HeaderTextCssClass;
                    }

                    //Header Text (if set)
                    if( !String.IsNullOrEmpty(this.HeaderText) )
                    {
                        lblHeader.Text = this.HeaderText;
                    }

                    //ResourceKey overrides if found
                    if( !String.IsNullOrEmpty(this.ResourceKey) )
                    {
                        string strHeader = Localization.GetString( this.ResourceKey, Localization.GetResourceFile( this, MyFileName ) );
                        if( !String.IsNullOrEmpty(strHeader) )
                        {
                            lblHeader.Text = Localization.GetString( this.ResourceKey, Localization.GetResourceFile( this, MyFileName ) );
                        }
                    }

                    //If still not set get default key
                    if( lblHeader.Text == "" )
                    {
                        string strHeader = Localization.GetString( "Title", Localization.GetResourceFile( this, MyFileName ) );
                        if( !String.IsNullOrEmpty(strHeader) )
                        {
                            lblHeader.Text = Localization.GetString( "Title", Localization.GetResourceFile( this, MyFileName ) );
                        }
                        else
                        {
                            lblHeader.Text = "Site Navigation";
                        }
                    }
                    tblHeader.Visible = this.IncludeHeader;

                    //Main Panel Properties
                    if( !String.IsNullOrEmpty(this.BodyCssClass) )
                    {
                        cellBody.Attributes.Add( "class", this.BodyCssClass );
                    }
                    cellBody.NoWrap = this.NoWrap;
                }
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        /// <summary>
        /// The SCPTree_NodeClick server event handler on this user control runs when a
        /// Node (Page) in the TreeView is clicked
        /// </summary>
        /// <remarks>The event only fires when the Node contains child nodes, as leaf nodes
        /// have their NavigateUrl Property set.
        /// </remarks>
        /// <history>
        /// 	[cnurse]	12/9/2004	Created
        /// </history>
        private void SCPTree_NodeClick( NavigationEventArgs args ) //Handles SCPTree.NodeClick
        {
            if( args.Node == null )
            {
                args.Node = Navigation.GetNavigationNode( args.ID, Control.ID );
            }
            Response.Redirect( Globals.ApplicationURL( int.Parse( args.Node.Key ) ), true );
        }

        private void SCPTree_PopulateOnDemand( NavigationEventArgs args ) //Handles SCPTree.PopulateOnDemand
        {
            if( args.Node == null )
            {
                args.Node = Navigation.GetNavigationNode( args.ID, Control.ID );
            }
            BuildTree( args.Node, true );
        }

        protected override void OnInit( EventArgs e )
        {
            InitializeTree();
            InitializeNavControl( this.cellBody, "TreeNavigationProvider" );
            Control.NodeClick += new NavigationProvider.NodeClickEventHandler( SCPTree_NodeClick );
            Control.PopulateOnDemand += new NavigationProvider.PopulateOnDemandEventHandler(SCPTree_PopulateOnDemand);

            base.OnInit( e );
        }
    }
}