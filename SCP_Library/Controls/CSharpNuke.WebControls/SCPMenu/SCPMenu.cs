//
// Sharp Content Portal - http://www.SharpContentPortal.com
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

using System;
using System.Collections;
using System.ComponentModel;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using System.Xml;
using SharpContent.UI.Utilities;

namespace SharpContent.UI.WebControls
{
	[Designer(typeof(SCPMenuDesigner))]
	public class SCPMenu : WebControl, IPostBackEventHandler, IPostBackDataHandler, SharpContent.UI.Utilities.IClientAPICallbackEventHandler
	{

		#region "Events / Delegates"
		public delegate void SCPMenuEventHandler(object source, SCPMenuEventArgs e);
		public delegate void SCPMenuNodeClickHandler(object source, SCPMenuNodeClickEventArgs e);

		public event SCPMenuNodeClickHandler NodeClick;
		public event SCPMenuEventHandler PopulateOnDemand;
		#endregion

		#region "Member Variables"
		private MenuNodeCollection m_objNodes;
		private NodeImageCollection m_objImages;
		#endregion

		#region "Constructors"
		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		public SCPMenu()
		{
		}
		#endregion

		#region "Properties"
		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Allows developer to force the rendering of the Menu in DownLevel mode
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	2/22/2005	Commented
		/// </history>
		/// -----------------------------------------------------------------------------
		public bool ForceDownLevel {
			get { return (bool)ViewState["ForceDownLevel"]; }
			set { ViewState["ForceDownLevel"] = value; }
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Returns whether the Menu will render DownLevel or not
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	2/22/2005	Commented
		///		[Jon Henning]	3/9/2005	Requiring XML support on client for uplevel
		/// </history>
		/// -----------------------------------------------------------------------------
		[Browsable(false)]
		public bool IsDownLevel {
			get {
				if (ForceDownLevel || this.IsCrawler || SharpContent.UI.Utilities.ClientAPI.BrowserSupportsFunctionality(Utilities.ClientAPI.ClientFunctionality.DHTML) == false || SharpContent.UI.Utilities.ClientAPI.BrowserSupportsFunctionality(Utilities.ClientAPI.ClientFunctionality.XML) == false)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}

		public bool IsCrawler {
			get {
				if (String.IsNullOrEmpty(ViewState["IsCrawler"].ToString()))
				{
					return System.Web.HttpContext.Current.Request.Browser.Crawler;
				}
				else
				{
					return (bool)ViewState["IsCrawler"];
				}

			}
			set { ViewState["IsCrawler"] = value; }
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Location of ClientAPI js files 
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	2/22/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		public string ClientAPIScriptPath {
			get { return SharpContent.UI.Utilities.ClientAPI.ScriptPath; }
// Commented out because it was breaking the build.. (SM 26 Oct)  
// uncommented out, don't understand how this could have broke build - JH 22 Feb 2005
			set { SharpContent.UI.Utilities.ClientAPI.ScriptPath = value; }
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Location of scp.controls.SCPMenu.js file
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// Since 1.1 this path will be the same as the ClientAPI path.
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	2/22/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		public string MenuScriptPath {
			get {
				if (String.IsNullOrEmpty(ViewState["MenuScriptPath"].ToString()))
				{
					return ClientAPIScriptPath;
				}
				else
				{
					return (string)ViewState["MenuScriptPath"];
				}
			}
			set { ViewState["MenuScriptPath"] = value; }
		}


		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Location of system images (i.e. spacer.gif)
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	2/22/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		[Description("Directory to find the images for the menu.  Need to have spacer.gif here!"), DefaultValue("images/")]
		public string SystemImagesPath {
			get {
				if (String.IsNullOrEmpty(ViewState["SystemImagesPath"].ToString()))
				{
					return "images/";
				}
				else
				{
					return (string)ViewState["SystemImagesPath"];
				}
			}
			set { ViewState["SystemImagesPath"] = value; }
		}


		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		[Browsable(true), PersistenceMode(PersistenceMode.InnerProperty)]
		public MenuNodeCollection MenuNodes {
			get {
				if (m_objNodes == null)
				{
					m_objNodes = new MenuNodeCollection(this.ClientID, this);
				}
				return m_objNodes;
			}
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Holds collection of selected node objects
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	4/6/2005	Commented
		/// </history>
		/// -----------------------------------------------------------------------------
		[Browsable(false)]
		public ArrayList SelectedMenuNodes {
			get { return this.MenuNodes.FindSelectedNodes(); }
		}


		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		[Bindable(true), DefaultValue(""), PersistenceMode(PersistenceMode.Attribute)]
		public string RootArrowImage {
			get { return (string)ViewState["RootArrowImage"]; }
			set { ViewState["RootArrowImage"] = value; }
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		[Bindable(true), DefaultValue(""), PersistenceMode(PersistenceMode.Attribute)]
		public string ChildArrowImage {
			get { return (string)ViewState["ChildArrowImage"]; }
			set { ViewState["ChildArrowImage"] = value; }
		}

		[Bindable(true), DefaultValue(""), PersistenceMode(PersistenceMode.Attribute)]
		public string WorkImage {
			get { return (string)ViewState["WorkImage"]; }
			set { ViewState["WorkImage"] = value; }
		}


		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		[Bindable(true), DefaultValue("")]
		public string Target {
			get { return ((string)ViewState["Target"]); }
			set { ViewState["Target"] = value; }
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		[Browsable(true), PersistenceMode(PersistenceMode.InnerProperty)]
		public NodeImageCollection ImageList {
			get {
				if (m_objImages == null)
				{
					m_objImages = new NodeImageCollection();
					if (IsTrackingViewState)
					{
						((IStateManager)m_objImages).TrackViewState();
					}
				}
				return m_objImages;
			}
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		[Bindable(true), DefaultValue(""), PersistenceMode(PersistenceMode.Attribute)]
		public string DefaultNodeCssClass {
			get { return this.CssClass; }
			set { this.CssClass = value; }
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		[Bindable(true), DefaultValue(""), PersistenceMode(PersistenceMode.Attribute)]
		public string DefaultChildNodeCssClass {
			get { return ((string)ViewState["DefaultChildNodeCssClass"]); }
			set { ViewState["DefaultChildNodeCssClass"] = value; }
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		[Bindable(true), DefaultValue(""), PersistenceMode(PersistenceMode.Attribute)]
		public string DefaultNodeCssClassOver {
			get { return ((string)ViewState["DefaultNodeCssClassOver"]); }
			set { ViewState["DefaultNodeCssClassOver"] = value; }
		}

		[Bindable(true), DefaultValue(""), PersistenceMode(PersistenceMode.Attribute)]
		public string DefaultNodeCssClassSelected {
			get { return ((string)ViewState["DefaultNodeCssClassSelected"]); }
			set { ViewState["DefaultNodeCssClassSelected"] = value; }
		}

		[Bindable(true), DefaultValue(""), PersistenceMode(PersistenceMode.Attribute)]
		public string DefaultIconCssClass {
			get { return ((string)ViewState["DefaultIconCssClass"]); }
			set { ViewState["DefaultIconCssClass"] = value; }
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		[Bindable(true), DefaultValue(""), PersistenceMode(PersistenceMode.Attribute)]
		public string MenuBarCssClass {
			get { return ((string)ViewState["MenuBarCssClass"]); }
			set { ViewState["MenuBarCssClass"] = value; }
		}

		[Bindable(true), DefaultValue(""), PersistenceMode(PersistenceMode.Attribute)]
		public string MenuCssClass {
			get { return ((string)ViewState["MenuCssClass"]); }
			set { ViewState["MenuCssClass"] = value; }
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		private ISCPMenuWriter MenuWriter {
			get {
				ISCPMenuWriter oWriter;
				if (this.IsDownLevel)
				{
					oWriter = new SCPMenuWriter(this.IsCrawler);
				}
				else
				{
					oWriter = new SCPMenuUpLevelWriter();
				}
				return oWriter;
			}
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Allows you to have a common JS function be invoked for all nodes, unless
		/// a different JS function is provided on the node level.
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// If the client-side function returns false, the action associated to the node 
		/// selection will be canceled
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	4/6/2005	Commented
		/// </history>
		/// -----------------------------------------------------------------------------
		public string JSFunction {
			get { return ((string)ViewState["JSFunction"]); }
			set { ViewState["JSFunction"] = value; }
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Allows the nodes to be populated on the client 
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	4/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		[Bindable(false), DefaultValue(true), PersistenceMode(PersistenceMode.Attribute)]
		public bool PopulateNodesFromClient {
			get {
				if (ViewState["PopNodesFromClient"] == null)
				{
					return true;
				}
				else
				{
					return ((bool)ViewState["PopNodesFromClient"]);
				}
			}
			set { ViewState["PopNodesFromClient"] = value; }
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// If callbacks are supported/enabled, this javascript function will be invoked
		/// with each status change of the xmlhttp request.
		/// </summary>
		/// <value></value>
		/// <remarks>
		/// The Javascript transport does not raise any events.
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	4/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		[Bindable(true), PersistenceMode(PersistenceMode.Attribute)]
		public string CallbackStatusFunction {
			get { return ((string)ViewState["CallbackStatusFunction"]); }
			set { ViewState["CallbackStatusFunction"] = value; }
		}

		[Bindable(true), DefaultValue(SharpContent.UI.WebControls.Orientation.Horizontal), PersistenceMode(PersistenceMode.Attribute)]
		public SharpContent.UI.WebControls.Orientation Orientation {
			get {
				if (!String.IsNullOrEmpty(ViewState["Orientation"].ToString()))
				{
					return ((Orientation)ViewState["Orientation"]);
					//?
				}
				else
				{
					return Orientation.Horizontal;
				}
			}
			set { ViewState["Orientation"] = value; }
		}

		[Bindable(true), DefaultValue(SharpContent.UI.WebControls.Orientation.Vertical), PersistenceMode(PersistenceMode.Attribute)]
		public SharpContent.UI.WebControls.Orientation SubMenuOrientation {
			get {
				if (!String.IsNullOrEmpty(ViewState["SubMenuOrientation"].ToString()))
				{
					return ((Orientation)ViewState["SubMenuOrientation"]);
					//?
				}
				else
				{
					return Orientation.Vertical;
				}
			}
			set { ViewState["SubMenuOrientation"] = value; }
		}


		[PersistenceMode(PersistenceMode.Attribute), DefaultValue(true)]
		public bool UseTables {
			get {
				if (String.IsNullOrEmpty((string)ViewState["UseTables"]))
				{
					return true;
				}
				else
				{
					return (bool)ViewState["UseTables"];
				}
			}
			set { ViewState["UseTables"] = value; }
		}

		[Description("Number of milliseconds to wait befor hiding sub-menu on mouse out"), Category("Behavior"), PersistenceMode(PersistenceMode.Attribute), DefaultValue(500)]
		public int MouseOutDelay {
			get {
				if (String.IsNullOrEmpty((string)ViewState["MouseOutDelay"]))
				{
					return 500;
				}
				else
				{
					return (int)ViewState["MouseOutDelay"];
				}
			}
			set { ViewState["MouseOutDelay"] = value; }
		}

		[Description("Number of milliseconds to wait befor displaying sub-menu on mouse over"), Category("Behavior"), PersistenceMode(PersistenceMode.Attribute), DefaultValue(250)]
		public int MouseInDelay {
			get {
				if (String.IsNullOrEmpty((string)ViewState["MouseInDelay"]))
				{
					return 250;
				}
				else
				{
					return (int)ViewState["MouseInDelay"];
				}
			}
			set { ViewState["MouseInDelay"] = value; }
		}

		[PersistenceMode(PersistenceMode.Attribute), DefaultValue(false)]
		public bool EnablePostbackState {
			get {
				if (String.IsNullOrEmpty((string)ViewState["EnablePostbackState"]))
				{
					return false;
				}
				else
				{
					return (bool)ViewState["EnablePostbackState"];
				}
			}
			set { ViewState["EnablePostbackState"] = value; }
		}

		#endregion

		#region "OverLoaded Methods"

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Responsible for rendering the SCPMenu and in an uplevel rendering of the Menu, sending down the xml for the child nodes in a ClientAPI variable.
		/// </summary>
		/// <param name="writer"></param>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		///		[Jon Henning 4/6/2005	Commented
		/// </history>
		/// -----------------------------------------------------------------------------
		protected override void Render(HtmlTextWriter writer)
		{
			MenuWriter.RenderMenu(writer, this);
			//added back...??? not sure if this is ok... - urllist needs it
			//If Me.IsDownLevel = False Then SharpContent.UI.Utilities.ClientAPI.RegisterClientVariable(Me.Page, Me.ClientID & "_xml", Me.MenuNodes.ToXml, True)
			foreach (Control oCtl in this.Controls) {
				oCtl.RenderControl(writer);
			}

			if (IsDownLevel == false)
			{
				ClientAPI.RegisterStartUpScript(this.Page, this.ClientID + "_startup", "<script>scp.controls.initMenu($('" + this.ClientID + "'));</script>");
			}
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <param name="e"></param>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		protected override void OnInit(EventArgs e)
		{
			base.OnInit(e);
			if (SharpContent.UI.Utilities.ClientAPI.NeedsSCPVariable(this))
			{
				//This is to allow us to add a control to our parent's control collection...  kindof a hack
				this.Page.Load += ParentOnLoad;
			}
			else
			{
				LoadPostedXML();
			}
		}

		protected void ParentOnLoad(object Sender, System.EventArgs e)
		{
			SharpContent.UI.Utilities.ClientAPI.RegisterSCPVariableControl(this);

			LoadPostedXML();
		}


		protected override void OnLoad(System.EventArgs e)
		{
			if (IsDownLevel && !String.IsNullOrEmpty(ViewState["xml"].ToString())) m_objNodes = new MenuNodeCollection((string)ViewState["xml"], "", this); 

			//RegisterClientScript()
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		protected override object SaveViewState()
		{
			object _baseState = base.SaveViewState();
			object _imagesState = ((IStateManager)ImageList).SaveViewState();
			object[] _newState = new object[2];
			_newState[0] = _baseState;
			_newState[1] = _imagesState;
			return _newState;
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <param name="state"></param>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		protected override void LoadViewState(object state)
		{
			if ((state != null))
			{
				object[] _newState = (object[])state;
				if ((_newState[0] != null))
				{
                        base.LoadViewState(_newState[0]);
				}
				if ((_newState[1] != null))
				{
					((IStateManager)ImageList).LoadViewState(_newState[1]);
				}
			}
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		protected override void TrackViewState()
		{
			base.TrackViewState();
			//CType(Root, IStateManager).TrackViewState()
		}
		#endregion

		#region "Event Handlers"
		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <param name="eventArgument"></param>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	5/6/2005	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		public virtual void RaisePostBackEvent(string eventArgument)
		{
			string[] args = eventArgument.Split(new String[]{ClientAPI.COLUMN_DELIMITER}, StringSplitOptions.None);

			MenuNode Node = MenuNodes.FindNode(args[0]);

			if ((Node != null))
			{
				if (args.Length > 1)
				{
					switch (args[1]) {
						case "Click":
							Node.Click();
							break;
						case "Checked":
							Node.Selected = !Node.Selected;
							break;
						case "OnDemand":
							if (PopulateOnDemand != null) {
								PopulateOnDemand(this, new SCPMenuEventArgs(Node));
							}

							break;
					}
				}
				else
				{
					//assume an event with no specific argument to be a click 
					Node.Click();
				}
			}
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// 
		/// </summary>
		/// <param name="e"></param>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	10/6/2004	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		public virtual void OnNodeClick(SCPMenuNodeClickEventArgs e)
		{
			if (NodeClick != null) {
				NodeClick(this, e);
			}
		}

          protected override void OnPreRender(EventArgs e)
          {
              base.OnPreRender(e);
         	    RegisterClientScript();
		    Page.RegisterRequiresPostBack(this);
		    UpdateNodes(this.MenuNodes);
		    //update all imageindex properties

		    if (!this.IsDownLevel)
		    {
			    SharpContent.UI.Utilities.ClientAPI.RegisterClientVariable(this.Page, this.ClientID + "_xml", this.MenuNodes.ToXml(), true);
		    }
		    else
		    {
			    //If Me.EnablePostbackState Then
			    ViewState["xml"] = this.MenuNodes.ToXml();
		    }

		}

		private void LoadPostedXML()
		{
			string strXML = "";
			//If Me.EnablePostbackState AndAlso Me.IsDownLevel = False Then strXML = SharpContent.UI.Utilities.ClientAPI.GetClientVariable(Me.Page, Me.ClientID & "_xml")
			if (this.IsDownLevel == false) strXML = SharpContent.UI.Utilities.ClientAPI.GetClientVariable(this.Page, this.ClientID + "_xml"); 
			if (!String.IsNullOrEmpty(strXML)) LoadXml(strXML); 
		}

		public bool LoadPostData(string postDataKey, System.Collections.Specialized.NameValueCollection postCollection)
		{
			//We need to process the individual checkboxes
			//If Me.CheckBoxes Then SelectNodes(Nothing, postCollection)
              return false;
		}

		public void RaisePostDataChangedEvent()
		{

		}

		public string RaiseClientAPICallbackEvent(string eventArgument)
		{
			string[] aryArgs = eventArgument.Split(new String[]{ClientAPI.COLUMN_DELIMITER}, StringSplitOptions.None);
			string strNodeXml = "<root>" + aryArgs[0] + "</root>";
			MenuNodeCollection objNodes = new MenuNodeCollection(strNodeXml, "", this);

			MenuNode objNode = objNodes[0];
			if ((objNode != null))
			{
				if (PopulateOnDemand != null) {
					PopulateOnDemand(this, new SCPMenuEventArgs(objNode));
				}
				MenuNode objTNode = this.FindNode(objNode.ID);
				//if whole Menu was populated (i.e. LoadXml, then use the node from the Menu

				if ((objTNode != null))
				{
					return objTNode.XmlNode.InnerXml;
				}
				else
				{
					//if only passed in node object was updated then use that xml.
					return objNode.XmlNode.InnerXml;
				}
			}
			else
			{
				return null;
			}
		}

		#endregion

		#region "Methods"
		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Responsible for inputting the hidden field necessary for the ClientAPI to pass variables back in forth
		/// </summary>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	4/6/2005	Commented
		/// </history>
		/// -----------------------------------------------------------------------------
		[Obsolete("RegisterSCPVariableControl on control level is now obsolete.  Use RegisterSCPVariableControl.WebControls")]
		public void RegisterSCPVariableControl()
		{
			SharpContent.UI.Utilities.ClientAPI.RegisterSCPVariableControl(this);
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Determines if client supports an uplevel rendering, and if so it registers
		/// the appropriate scripts.
		/// </summary>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	4/6/2005	Commented
		/// </history>
		/// -----------------------------------------------------------------------------
		public void RegisterClientScript()
		{
			if (IsDownLevel == false)
			{
				SharpContent.UI.Utilities.ClientAPI.RegisterClientReference(this.Page, SharpContent.UI.Utilities.ClientAPI.ClientNamespaceReferences.scp_dom);
				SharpContent.UI.Utilities.ClientAPI.RegisterClientReference(this.Page, SharpContent.UI.Utilities.ClientAPI.ClientNamespaceReferences.scp_xml);
				SharpContent.UI.Utilities.ClientAPI.RegisterClientReference(this.Page, SharpContent.UI.Utilities.ClientAPI.ClientNamespaceReferences.scp_dom_positioning);
				if (this.PopulateNodesFromClient)
				{
					//AndAlso SharpContent.UI.Utilities.ClientAPI.BrowserSupportsFunctionality(Utilities.ClientAPI.ClientFunctionality.XMLHTTP) Then
					SharpContent.UI.Utilities.ClientAPI.RegisterClientReference(this.Page, SharpContent.UI.Utilities.ClientAPI.ClientNamespaceReferences.scp_xmlhttp);
				}
				if (!ClientAPI.IsClientScriptBlockRegistered(this.Page, "scp.controls.scpmenu.js"))
				{
					ClientAPI.RegisterClientScriptBlock(this.Page, "scp.controls.scpmenu.js", "<script src=\"" + MenuScriptPath + "scp.controls.scpmenu.js\"></script>");
				}
				//If Me.Visible Then
				//	ClientAPI.RegisterStartUpScript(Me.Page, Me.ClientID & "_startup", "<script>scp.controls.initMenu($('" & Me.ClientID & "'));</script>")					  'wrong place
				//End If
			}
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Finds Node by passed in Key. 
		/// </summary>
		/// <param name="strID">ID of node</param>
		/// <returns></returns>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	11/17/2004	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		public MenuNode FindNode(string strID)
		{
			return this.MenuNodes.FindNode(strID);
		}

		/// -----------------------------------------------------------------------------
		/// <summary>
		/// Finds Node by passed in Key. 
		/// </summary>
		/// <param name="strKey">Key of node</param>
		/// <returns></returns>
		/// <remarks>
		/// </remarks>
		/// <history>
		/// 	[Jon Henning]	11/17/2004	Created
		/// </history>
		/// -----------------------------------------------------------------------------
		public MenuNode FindNodeByKey(string strKey)
		{
			return this.MenuNodes.FindNodeByKey(strKey);
		}

		public void LoadXml(string strXml)
		{
			m_objNodes = new MenuNodeCollection(strXml, "", this);
		}

		private void UpdateNodes(MenuNodeCollection objNodes)
		{
			//todo: xpath lookup for img attribute so we don't waste time looping.
			foreach (MenuNode objNode in objNodes) {
				if (!String.IsNullOrEmpty(objNode.Image))
				{
					if (this.ImageList.Contains(new NodeImage(objNode.Image)) == false)
					{
						objNode.ImageIndex = this.ImageList.Add(objNode.Image);
					}
					else
					{
						objNode.ImageIndex = this.ImageList.IndexOf(new NodeImage(objNode.Image));
					}
					objNode.Image = null;
				}
				if (objNode.SCPNodes.Count > 0) UpdateNodes(objNode.MenuNodes); 
			}
		}

		#endregion

         public override void Dispose()
         {
             base.Dispose();
         }

	}
}
