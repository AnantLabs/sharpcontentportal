<%@ Register TagPrefix="scp" Assembly="SharpContent" Namespace="SharpContent.UI.WebControls" %>
<%@ Control Language="C#" CodeFile="Membership.ascx.cs" AutoEventWireup="true" Inherits="SharpContent.Modules.Admin.Users.Membership" %>
<scp:PropertyEditorControl ID="MembershipEditor" runat="Server" EditMode="View" Width="375px"
    EditControlWidth="200px" LabelWidth="175px" EditControlStyle-CssClass="NormalTextBox"
    HelpStyle-CssClass="Help" LabelStyle-CssClass="SubHead" namedatafield="Name"
    valuedatafield="PropertyValue" SortMode="SortOrderAttribute" DisplayMode="Div" />
<p align="left">
    <table>
        <tr>
            <td nowrap>
                <scp:CommandButton ID="cmdAuthorize" runat="server" ResourceKey="cmdAuthorize" ImageUrl="~/images/authorized.gif"
                    CausesValidation="False" />
                <scp:CommandButton ID="cmdUnAuthorize" runat="server" ResourceKey="cmdUnAuthorize"
                    ImageUrl="~/images/unauthorized.gif" CausesValidation="False" />
            </td>
            <td nowrap>
                <scp:CommandButton ID="cmdUnLock" runat="server" ResourceKey="cmdUnLock" ImageUrl="~/images/icon_lock_16px.gif"
                    CausesValidation="False" />
            </td>
            <td nowrap>
                <scp:CommandButton ID="cmdPassword" runat="server" ResourceKey="cmdPassword" ImageUrl="~/images/action_refresh.gif"
                    CausesValidation="False" />
            </td>
            <td nowrap>
                <scp:CommandButton ID="cmdResetPassword" runat="server" ResourceKey="cmdResetPassword"
                    ImageUrl="~/images/reset.gif" CausesValidation="False" />
            </td>
        </tr>
    </table>
    &nbsp;
</p>
