<%@ Control Language="C#" CodeFile="ManageUsers.ascx.cs" AutoEventWireup="true" Inherits="SharpContent.Modules.Admin.Users.ManageUsers" %>
<%@ Register TagPrefix="scp" TagName="label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="sectionHead" Src="~/controls/SectionHeadControl.ascx" %>
<%@ Register TagPrefix="scp" Assembly="SharpContent" Namespace="SharpContent.UI.WebControls"%>
<%@ Register TagPrefix="scp" TagName="membership" Src="~/Admin/Users/Membership.ascx" %>
<%@ Register TagPrefix="scp" TagName="user" Src="~/Admin/Users/User.ascx" %>
<%@ Register TagPrefix="scp" TagName="roles" Src="~/Admin/Security/SecurityRoles.ascx" %>
<%@ Register TagPrefix="scp" TagName="password" Src="~/Admin/Users/Password.ascx" %>
<%@ Register TagPrefix="scp" TagName="profile" Src="~/Admin/Users/ProfileModule.ascx" %>
<%@ Register TagPrefix="scp" TagName="memberServices" Src="~/Admin/Users/MemberServices.ascx" %>
<asp:panel id="pnlTabs" runat="server">
	<table width="450">
		<tr>
			<td nowrap valign="bottom" style="height: 25px">
				<scp:commandbutton id="cmdUser" runat="server" 
					resourcekey="cmdUser" imageurl="~/images/icon_users_16px.gif" 
					causesvalidation="false"  />
			</td>
			<td width="10" style="height: 25px"></td>
			<td nowrap valign="bottom" style="height: 25px">
				<scp:commandbutton id="cmdRoles" runat="server" 
					resourcekey="cmdRoles" imageurl="~/images/icon_securityroles_16px.gif" 
					causesvalidation="false" />
			</td>
			<td width="10" style="height: 25px"></td>
			<td nowrap valign="bottom" style="height: 25px">
				<scp:commandbutton id="cmdPassword" runat="server" 
					resourcekey="cmdPassword" imageurl="~/images/icon_lock_16px.gif" 
					causesvalidation="false" />
			</td>
			<td width="10" style="height: 25px"></td>
			<td nowrap valign="bottom" style="height: 25px">
				<scp:commandbutton id="cmdProfile" runat="server" 
					resourcekey="cmdProfile" imageurl="~/images/icon_users_16px.gif" 
					causesvalidation="false" />
			</td>
			<td width="10" style="height: 25px"></td>
			<td nowrap valign="bottom" style="height: 25px">
				<scp:commandbutton id="cmdServices" runat="server" 
					resourcekey="cmdServices" imageurl="~/images/icon_viewstats_16px.gif" 
					causesvalidation="false" />
			</td>
			<td width="*" style="height: 25px"></td>
		</tr>
			<tr><td colspan="10" height="10"></td></tr>
	</table>
</asp:panel>
<asp:panel id="pnlUser" runat="server">
	<table cellspacing="0" cellpadding="0" summary="User Design Table" border="0" width="725">
		<tr id="trTitle" runat="server">
			<td colspan="3" valign="bottom" style="height: 19px">
				<asp:label id="lblTitle" cssclass="Head" runat="server"></asp:label>
				<asp:image id="imgLockedOut" imageurl="~/images/icon_securityroles_16px.gif" runat="server" visible="False" />
				<asp:image id="imgOnline" imageurl="~/images/userOnline.gif" runat="server" visible="False" /></td>
		</tr>
		<tr id="trHelp" runat="server" visible="false"><td colspan="3" valign="bottom"><asp:label id="lblUserHelp" cssclass="Normal" runat="server"></asp:label></td></tr>
		<tr><td colspan="3" height="10">
            </td></tr>
		<tr id="UserRow" runat="server">
			<td valign="top"><scp:user id="ctlUser" runat="Server" /></td>
			<td width="10" rowspan="5"></td>
			<td valign="top"><scp:Membership id="ctlMembership" runat="Server" /></td>
		</tr>
		<tr><td height="10"></td></tr>
	</table>
</asp:panel>
<asp:panel id="pnlRoles" runat="server" visible="false">
	<scp:roles id="ctlRoles" runat="server"></scp:roles>
</asp:panel>
<asp:panel id="pnlPassword" runat="server" visible="false">
	<scp:Password id="ctlPassword" runat="server"></scp:Password>
</asp:panel>
<asp:panel id="pnlProfile" runat="server" visible="false">
	<scp:Profile id="ctlProfile" runat="server"></scp:Profile>
</asp:panel>
<asp:panel id="pnlServices" runat="server" visible="false">
	<scp:MemberServices id="ctlServices" runat="server"></scp:MemberServices>
</asp:panel>
<asp:panel ID="pnlRegister" runat="server" visible="false">
	<scp:commandbutton id="cmdRegister" runat="server" 
		resourcekey="cmdRegister" imageurl="~/images/save.gif" 
		causesvalidation="True" />
</asp:panel>
