<%@ Register TagPrefix="scp" TagName="SectionHead" Src="~/controls/SectionHeadControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" Assembly="SharpContent" Namespace="SharpContent.UI.WebControls"%>
<%@ Control Language="C#" CodeFile="EditGroups.ascx.cs" AutoEventWireup="true"  Inherits="SharpContent.Modules.Admin.Security.EditGroups" %>
<table class="Settings" cellspacing="2" cellpadding="2" summary="Edit Roles Design Table" border="0">
	<tr>
		<td width="560" valign="top">
			<table id="tblBasic" cellspacing="0" cellpadding="2" width="525" summary="Basic Settings Design Table" border="0" runat="server">
				<tr valign="top">
					<td class="SubHead" width="150"><scp:label id="plRoleGroupName" runat="server" controlname="txtRoleGroupName"></scp:label></td>
					<td align="left" width="325" nowrap>
						<asp:textbox id="txtRoleGroupName" cssclass="NormalTextBox" runat="server" maxlength="50" columns="30" width="300"></asp:textbox><asp:Image ID="Image1" runat="server" BorderStyle="None" ImageUrl="~/images/required.gif" />
						<asp:requiredfieldvalidator id="valRoleGroupName" cssclass="NormalRed" runat="server" resourcekey="valRoleGroupName" controltovalidate="txtRoleGroupName" errormessage="<br>You Must Enter a Valid Name" display="Dynamic"></asp:requiredfieldvalidator>
					</td>
				</tr>
				<tr valign="top">
					<td class="SubHead" width="150"><scp:label id="plDescription" runat="server" controlname="txtDescription"></scp:label></td>
					<td width="325" nowrap><asp:textbox id="txtDescription" cssclass="NormalTextBox" runat="server" maxlength="1000" columns="30" width="300" textmode="MultiLine" height="84px"></asp:textbox></td></tr>
			</table>
		</td>
	</tr>
</table>
<p>
	<scp:commandbutton cssclass="CommandButton" id="cmdUpdate" runat="server" resourcekey="cmdUpdate" imageurl="~/images/save.gif" />
	&nbsp;
	<scp:commandbutton cssclass="CommandButton" id="cmdCancel" runat="server" resourcekey="cmdCancel" imageurl="~/images/lt.gif" />
	&nbsp
	<scp:commandbutton cssclass="CommandButton" id="cmdDelete" runat="server" resourcekey="cmdDelete" imageurl="~/images/delete.gif" />
</p>
