<%@ Control Language="C#" AutoEventWireup="true"  Inherits="SharpContent.Modules.Admin.Modules.Export" CodeFile="Export.ascx.cs" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<br/>
<table width="560" cellspacing="0" cellpadding="0" border="0" summary="Edit Links Design Table">
    <tr>
        <td class="SubHead"><scp:label id="plFile" runat="server" controlname="lblFile" suffix=":"></scp:label></td>
        <td><asp:Label id="lblFile" runat="server" CssClass="Normal"></asp:Label></td>
    </tr>
</table>
<p>
    <asp:linkbutton id="cmdExport" resourcekey="cmdExport" runat="server" cssclass="CommandButton" text="Import" borderstyle="none" OnClick="cmdExport_Click"></asp:linkbutton>&nbsp;
    <asp:linkbutton id="cmdCancel" resourcekey="cmdCancel" runat="server" cssclass="CommandButton" text="Cancel" borderstyle="none" causesvalidation="False" OnClick="cmdCancel_Click"></asp:linkbutton>
</p>
