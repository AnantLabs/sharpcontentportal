<%@ Control Language="C#" AutoEventWireup="true" Inherits="SharpContent.UI.Containers.Container" %>
<%@ Register TagPrefix="scp" TagName="ACTIONS" Src="~/Admin/Containers/SolPartActions.ascx" %>
<%@ Register TagPrefix="scp" TagName="ICON" Src="~/Admin/Containers/Icon.ascx" %>
<%@ Register TagPrefix="scp" TagName="TITLE" Src="~/Admin/Containers/Title.ascx" %>
<%@ Register TagPrefix="scp" TagName="VISIBILITY" Src="~/Admin/Containers/Visibility.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON1" Src="~/Admin/Containers/ActionButton.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON2" Src="~/Admin/Containers/ActionButton.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON3" Src="~/Admin/Containers/ActionButton.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON4" Src="~/Admin/Containers/ActionButton.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON5" Src="~/Admin/Containers/ActionButton.ascx" %>
<table class="containermaster_default" cellspacing="0" cellpadding="5" align="center"
    border="0">
    <tr>
        <td class="containerrow1_default">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="middle" nowrap>
                        <scp:ACTIONS runat="server" ID="SCPACTIONS" />
                    </td>
                    <td valign="middle" nowrap>
                        <scp:ICON runat="server" ID="SCPICON" />
                    </td>
                    <td valign="middle" width="100%" nowrap>
                        <scp:TITLE runat="server" ID="SCPTITLE" />
                        &nbsp;
                    </td>
                    <td valign="middle" nowrap>                        
                        <scp:VISIBILITY runat="server" ID="SCPVISIBILITY" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td id="ContentPane" runat="server" align="center">
        </td>
    </tr>
    <tr>
        <td>
            <hr class="containermaster_default">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="left" valign="middle" nowrap>
                        <scp:ACTIONBUTTON1 runat="server" ID="SCPACTIONBUTTON1" CommandName="AddContent.Action"
                            DisplayIcon="True" DisplayLink="True" />
                    </td>
                    <td align="right" valign="middle" nowrap>
                        <scp:ACTIONBUTTON2 runat="server" ID="SCPACTIONBUTTON2" CommandName="SyndicateModule.Action"
                            DisplayIcon="True" DisplayLink="False" />
                        &nbsp;<scp:ACTIONBUTTON3 runat="server" ID="SCPACTIONBUTTON3" CommandName="PrintModule.Action"
                            DisplayIcon="True" DisplayLink="False" />
                        &nbsp;<scp:ACTIONBUTTON4 runat="server" ID="SCPACTIONBUTTON4" CommandName="ModuleSettings.Action"
                            DisplayIcon="True" DisplayLink="False" />
                        &nbsp;<scp:ACTIONBUTTON5 runat="server" ID="SCPACTIONBUTTON5" CommandName="ModuleHelp.Action"
                            DisplayIcon="True" DisplayLink="False" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<br>
