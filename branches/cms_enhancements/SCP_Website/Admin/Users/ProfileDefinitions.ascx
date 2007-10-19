<%@ Import namespace="SharpContent.Entities.Profile"%>
<%@ Register TagPrefix="scp" Namespace="SharpContent.UI.WebControls" Assembly="SharpContent" %>
<%@ Control Inherits="SharpContent.Modules.Admin.Users.ProfileDefinitions" CodeFile="ProfileDefinitions.ascx.cs" Language="C#" AutoEventWireup="true" %>
<asp:datagrid id="grdProfileProperties" AutoGenerateColumns="false" width="100%" CellPadding="4"
	GridLines="None" cssclass="DataGrid_Container" Runat="server" OnItemCommand="grdProfileProperties_ItemCommand" OnItemCreated="grdProfileProperties_ItemCreated">
	<headerstyle cssclass="NormalBold" verticalalign="Top" horizontalalign="Center" />
	<itemstyle cssclass="DataGrid_Item" horizontalalign="Left" />
	<alternatingitemstyle cssclass="DataGrid_AlternatingItem" />
	<edititemstyle cssclass="NormalTextBox" />
	<selecteditemstyle cssclass="NormalRed" />
	<footerstyle cssclass="DataGrid_Footer" />
	<pagerstyle cssclass="DataGrid_Pager" />
	<columns>
		<scp:imagecommandcolumn CommandName="Edit" Text="Edit" ImageUrl="~/images/edit.gif" HeaderText="Edit" KeyField="PropertyDefinitionID" EditMode="URL" />
		<scp:imagecommandcolumn CommandName="Delete" Text="Delete" ImageUrl="~/images/delete.gif" HeaderText="Del" KeyField="PropertyDefinitionID" />
		<scp:imagecommandcolumn commandname="MoveDown" imageurl="~/images/dn.gif" headertext="Dn" keyfield="PropertyDefinitionID" />
		<scp:imagecommandcolumn commandname="MoveUp" imageurl="~/images/up.gif" headertext="Up" keyfield="PropertyDefinitionID" />
		<scp:textcolumn DataField="PropertyName" HeaderText="Name" Width="100px" />
		<scp:textcolumn DataField="PropertyCategory" HeaderText="Category" Width="100px" />
		<asp:TemplateColumn HeaderText="DataType">
			<ItemStyle Width="100px"></ItemStyle>
			<ItemTemplate>
				<asp:label id="lblDataType" runat="server" Text='<%# DisplayDataType((ProfilePropertyDefinition)Container.DataItem) %>'></asp:label>
			</ItemTemplate>
		</asp:TemplateColumn>
		<scp:textcolumn DataField="Length" HeaderText="Length" />
		<scp:textcolumn DataField="DefaultValue" HeaderText="DefaultValue" Width="100px" />
		<scp:textcolumn DataField="ValidationExpression" HeaderText="ValidationExpression" Width="100px" />
		<scp:checkboxcolumn DataField="Required" HeaderText="Required" AutoPostBack="True" />
		<scp:checkboxcolumn DataField="Visible" HeaderText="Visible" AutoPostBack="True" />
	</columns>
</asp:datagrid>
<br/>
<br/>
<p>
	<scp:commandbutton cssclass="CommandButton" id="cmdUpdate" imageUrl="~/images/save.gif" resourcekey="cmdUpdate"
		runat="server" text="Update" />&nbsp;
	<scp:commandbutton cssclass="CommandButton" id="cmdRefresh" imageUrl="~/images/refresh.gif" resourcekey="cmdRefresh"
		runat="server" text="Refresh" />&nbsp;
</p>
