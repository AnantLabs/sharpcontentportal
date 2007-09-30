<%@ Control Language="C#" AutoEventWireup="true" Inherits="SharpContent.Modules.Admin.Search.SearchAdmin" CodeFile="SearchAdmin.ascx.cs" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<table cellSpacing="0" cellPadding="2" width="550" summary="Basic Settings Design Table"
	border="0">
	<tr>
		<td colSpan="2"><asp:label id="lblSearchSettingsHelp" runat="server" enableviewstate="False" cssclass="Normal"></asp:label></td>
	</tr>
	<tr>
		<td class="SubHead" width="200"><scp:label id="plMaxWordLength" runat="server" controlname="txtMaxWordLength" text="Maximum Word Length:"></scp:label></td>
		<td class="NormalTextBox" vAlign="top" width="75"><asp:textbox id="txtMaxWordLength" runat="server" cssclass="NormalTextBox" maxlength="128" width="325"></asp:textbox></td>
	</tr>
	<tr>
		<td class="SubHead" width="200"><scp:label id="plMinWordLength" runat="server" controlname="txtMinWordLength" text="Minimum Word Length:"></scp:label></td>
		<td class="NormalTextBox" vAlign="top" width="75"><asp:textbox id="txtMinWordLength" runat="server" cssclass="NormalTextBox" maxlength="128" width="325"></asp:textbox></td>
	</tr>
	<tr>
		<td class="SubHead" width="200"><scp:label id="plIncludeCommon" runat="server" controlname="chkIncludeCommon" text="Include Common Words:"></scp:label></td>
		<td class="NormalTextBox" vAlign="top" width="75"><asp:CheckBox ID="chkIncludeCommon" Runat="server" CssClass="Normal"></asp:CheckBox></td>
	</tr>
	<tr>
		<td class="SubHead" width="200"><scp:label id="plIncludeNumeric" runat="server" controlname="chkIncludeNumeric" text="Include Numbers:"></scp:label></td>
		<td class="NormalTextBox" vAlign="top" width="75"><asp:CheckBox ID="chkIncludeNumeric" Runat="server" CssClass="Normal"></asp:CheckBox></td>
	</tr>
</table>
<p>
	<asp:linkbutton cssclass="CommandButton" id="cmdUpdate" resourcekey="cmdUpdate" runat="server" text="Update" OnClick="cmdUpdate_Click"></asp:linkbutton>&nbsp;&nbsp;
	<asp:linkbutton cssclass="CommandButton" id="cmdCancel" resourcekey="cmdCancel" runat="server" text="Cancel"
		causesvalidation="False" borderstyle="none" OnClick="cmdCancel_Click"></asp:linkbutton>&nbsp;&nbsp;
	<asp:linkbutton cssclass="CommandButton" id="cmdReIndex" resourcekey="cmdReIndex" runat="server"
		text="Re-Index Content" causesvalidation="False" borderstyle="none" OnClick="cmdReIndex_Click"></asp:linkbutton>&nbsp;&nbsp;
</p>
