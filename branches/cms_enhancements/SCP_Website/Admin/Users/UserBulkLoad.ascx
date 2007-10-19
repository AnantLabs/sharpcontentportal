<%@ Control Language="C#" CodeFile="UserBulkLoad.ascx.cs" AutoEventWireup="true" Inherits="SharpContent.Modules.Admin.Users.UserBulkLoad" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" Assembly="SharpContent" Namespace="SharpContent.UI.WebControls" %>
<%@ Register TagPrefix="scp" TagName="SectionHead" Src="~/controls/SectionHeadControl.ascx" %>
<asp:Panel ID="pnlLoad" runat="server" align="center">
<table cellspacing="0" cellpadding="0" summary="User Load" border="0">    
    <tr id="trTitle" runat="server">
        <td colspan="2" valign="bottom">
            <asp:Label ID="lblTitle" CssClass="Head" runat="server" /></td>
    </tr>
    <tr height="25">
        <td colspan="2" valign="bottom"></td>
    </tr>
    <tr>
        <td colspan="2" height="25">
            <asp:Label ID="lblBrowse" resourcekey="lblBrowse" CssClass="Normal" runat="server" /></td>
    </tr>
    <tr height="25">
        <td colspan="2" valign="bottom"></td>
    </tr>
    <tr height="25">
        <td width="175" class="SubHead">
            <scp:Label ID="plFile" runat="server" ControlName="cmdBrowse" />
        </td>
        <td>
            <input id="cmdBrowse" type="file" size="50" name="cmdBrowse" runat="server">
        </td>
    </tr>
    <tr height="25">
        <td width="175" class="subhead">
            <scp:Label ID="plAuthorize" runat="server" ControlName="chkAuthorize" />
        </td>
        <td class="normalTextBox">
            <asp:CheckBox ID="chkAuthorize" runat="server" Checked="True" /></td>
    </tr>
    <tr height="25">
        <td width="175" class="subhead">
            <scp:Label ID="plNotify" runat="server" ControlName="chkNotify" />
        </td>
        <td class="normalTextBox">
            <asp:CheckBox ID="chkNotify" runat="server" Checked="True" /></td>
    </tr>
    <tr id="trLogFile" runat="server" height="25" visible="false">
        <td width="175" class="subhead">
            <scp:Label ID="plLogFile" runat="server" ControlName="chkNotify" />
        </td>
        <td class="normalTextBox">
            <asp:HyperLink ID="lnkLogFile" runat="server" CssClass="CommandButton" /></td>
    </tr>
</table>
</asp:Panel>
<asp:Panel ID="pnlUpdate" runat="server" align="center">
    <br />    
    <scp:CommandButton ID="cmdLoad" runat="server" ResourceKey="cmdLoad" ImageUrl="~/images/save.gif"
        CausesValidation="true" />
        &nbsp;&nbsp;&nbsp;
    <scp:CommandButton ID="cmdCancel" runat="server" ResourceKey="cmdCancel" ImageUrl="~/images/lt.gif"
        CausesValidation="false" />    
</asp:Panel>
