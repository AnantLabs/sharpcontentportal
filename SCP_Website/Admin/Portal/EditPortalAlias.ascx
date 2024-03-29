<%@ Control Language="C#" AutoEventWireup="true"  Inherits="SharpContent.Modules.Admin.Portals.EditPortalAlias" CodeFile="EditPortalAlias.ascx.cs" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<br/>
<table border="0" cellspacing="2" cellpadding="2">
	<tr>
		<td class="SubHead"><scp:label id="plAlias" runat="server" controlname="txtAlias" suffix=":"></scp:label></td>
		<td><asp:TextBox ID="txtAlias" Runat="server" CssClass="NormalTextBox" MaxLength="255" Width="300"/></td>
	</tr>
</table>
<p>
    <asp:linkbutton cssclass="CommandButton" id="cmdUpdate" resourcekey="cmdUpdate" runat="server" text="Update" OnClick="cmdUpdate_Click"></asp:linkbutton>&nbsp;&nbsp;
    <asp:linkbutton cssclass="CommandButton" id="cmdCancel" resourcekey="cmdCancel" runat="server" text="Cancel" causesvalidation="False" borderstyle="none" OnClick="cmdCancel_Click"></asp:linkbutton>&nbsp;&nbsp;
    <asp:linkbutton cssclass="CommandButton" id="cmdDelete" resourcekey="cmdDelete" runat="server" text="Delete" causesvalidation="False" borderstyle="none" OnClick="cmdDelete_Click"></asp:linkbutton>
</p>

