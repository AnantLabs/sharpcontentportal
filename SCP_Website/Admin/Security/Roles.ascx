<%@ Register TagPrefix="scp" Namespace="SharpContent.UI.WebControls" Assembly="SharpContent" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Control Inherits="SharpContent.Modules.Admin.Security.Roles" CodeFile="Roles.ascx.cs" Language="C#" AutoEventWireup="true"  %>
<table align="left" cellpadding="2" cellspacing="0" border="0" width="100%">
	<tr id="trGroups" runat="server">
		<td width="5%">&nbsp;</td>
		<td width="40%" class="SubHead" align="right"><scp:label id="plRoleGroups" runat="server" suffix="" controlname="cboRoleGroups" /></td>
		<td width="50%" class="Normal">
			<asp:dropdownlist id="cboRoleGroups" Runat="server" AutoPostBack="True" OnSelectedIndexChanged="cboRoleGroups_SelectedIndexChanged" />
			<asp:hyperlink ID="lnkEditGroup" runat="server" ImageUrl="~/images/edit.gif" resourcekey="cmdEdit" />
			<asp:imagebutton ID="cmdDelete" Runat="server" ImageUrl="~/images/delete.gif" OnClick="cmdDelete_Click" resourcekey="cmdDelete" />
		</td>
		<td width="5%">&nbsp;</td>
	</tr>
	<tr height="20">
	    <td colspan="4"></td>
	</tr>
	<tr>
		<td colspan="4">
			<asp:datagrid id="grdRoles" Border="0" CellPadding="4" CellSpacing="0" Width="100%" 
				AutoGenerateColumns="false" EnableViewState="false" runat="server" 
				summary="Roles Design Table" BorderStyle="None" BorderWidth="0px"
				GridLines="None">
				<headerstyle cssclass="NormalBold" verticalalign="Top" horizontalalign="Left"/>
				<itemstyle cssclass="Normal" horizontalalign="Left" />
				<alternatingitemstyle cssclass="DataGrid_AlternatingItem" />
				<edititemstyle cssclass="NormalTextBox" />
				<selecteditemstyle cssclass="NormalRed" />
				<footerstyle cssclass="DataGrid_Footer" />
				<pagerstyle cssclass="DataGrid_Pager" />
				<columns>
					<scp:imagecommandcolumn commandname="Edit" imageurl="~/images/edit.gif" editmode="URL" keyfield="RoleID" ShowImage="True" />
					<scp:imagecommandcolumn commandname="UserRoles" imageurl="~/images/icon_users_16px.gif" editmode="URL" keyfield="RoleID" ShowImage="True" />
					<asp:boundcolumn DataField="RoleName" HeaderText="Name">
					</asp:boundcolumn>
					<asp:boundcolumn DataField="Description" HeaderText="Description">
					</asp:boundcolumn>
					<asp:templatecolumn HeaderText="Fee">
						<itemtemplate>
							<asp:label runat="server" Text='<%#FormatPrice(Convert.ToSingle(DataBinder.Eval(Container.DataItem, "ServiceFee"))) %>' CssClass="Normal" ID="Label1"/>
						</ItemTemplate>
					</asp:templatecolumn>
					<asp:templatecolumn HeaderText="Every">
						<itemtemplate>
							<asp:label runat="server" Text='<%#FormatPeriod(Convert.ToInt32(DataBinder.Eval(Container.DataItem, "BillingPeriod"))) %>' CssClass="Normal" ID="Label2"/>
						</ItemTemplate>
					</asp:templatecolumn>
					<asp:boundcolumn DataField="BillingFrequency" HeaderText="Period">
						<itemstyle cssclass="Normal"></ItemStyle>
					</asp:boundcolumn>
					<asp:templatecolumn HeaderText="Trial">
						<itemtemplate>
							<asp:label runat="server" Text='<%#FormatPrice(Convert.ToSingle(DataBinder.Eval(Container.DataItem, "TrialFee"))) %>' CssClass="Normal" ID="Label3"/>
						</ItemTemplate>
					</asp:templatecolumn>
					<asp:templatecolumn HeaderText="Every">
						<itemtemplate>
							<asp:label runat="server" Text='<%#FormatPeriod(Convert.ToInt32(DataBinder.Eval(Container.DataItem, "TrialPeriod"))) %>' CssClass="Normal" ID="Label4"/>
						</ItemTemplate>
					</asp:templatecolumn>
					<asp:boundcolumn DataField="TrialFrequency" HeaderText="Period">
						<itemstyle cssclass="Normal"></ItemStyle>
					</asp:boundcolumn>
					<asp:templatecolumn HeaderText="Public">
						<itemtemplate>
							<asp:image Runat="server" ID="imgApproved" ImageUrl="~/images/checked.gif" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem,"IsPublic")) %>'/>
							<asp:image Runat="server" ID="imgNotApproved" ImageUrl="~/images/unchecked.gif" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem,"IsPublic"))==false %>'/>
						</ItemTemplate>
					</asp:templatecolumn>
					<asp:templatecolumn HeaderText="Auto">
						<itemtemplate>
							<asp:image Runat="server" ID="Image1" ImageUrl="~/images/checked.gif" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem,"AutoAssignment")) %>'/>
							<asp:image Runat="server" ID="Image2" ImageUrl="~/images/unchecked.gif" Visible='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem,"AutoAssignment"))==false %>'/>
						</ItemTemplate>
					</asp:templatecolumn>
				</Columns>
			</asp:datagrid>
		</td>
	</tr>
</table>
