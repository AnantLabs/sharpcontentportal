<%@ Control language="C#"  AutoEventWireup="true"  Inherits="SharpContent.UI.Containers.Container" %>
<%@ Register TagPrefix="scp" TagName="ACTIONS" Src="~/Admin/Containers/SolPartActions.ascx" %>
<%@ Register TagPrefix="scp" TagName="ICON" Src="~/Admin/Containers/Icon.ascx" %>
<%@ Register TagPrefix="scp" TagName="TITLE" Src="~/Admin/Containers/Title.ascx" %>
<%@ Register TagPrefix="scp" TagName="VISIBILITY" Src="~/Admin/Containers/Visibility.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON1" Src="~/Admin/Containers/ActionButton.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON2" Src="~/Admin/Containers/ActionButton.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON3" Src="~/Admin/Containers/ActionButton.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON4" Src="~/Admin/Containers/ActionButton.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON5" Src="~/Admin/Containers/ActionButton.ascx" %>
      <TABLE class="containermaster_blue" cellSpacing="0" cellPadding="5" align="center" border="0">
        <TR>
          <TD class="containerrow1_blue">
            <TABLE width="100%" border="0" cellpadding="0" cellspacing="0">
              <TR>
                <TD valign="middle" nowrap><scp:ACTIONS runat="server" id="SCPACTIONS" /></TD>
                <TD valign="middle" nowrap><scp:ICON runat="server" id="SCPICON" /></TD>
                <TD valign="middle" width="100%" nowrap>&nbsp;<scp:TITLE runat="server" id="SCPTITLE" /></TD>
                <TD valign="middle" nowrap><scp:VISIBILITY runat="server" id="SCPVISIBILITY" /><scp:ACTIONBUTTON5 runat="server" id="SCPACTIONBUTTON5" CommandName="ModuleHelp.Action" DisplayIcon="True" DisplayLink="False" /></TD>
              </TR>
            </TABLE>
          </TD>
        </TR>
        <TR>
          <TD class="containerrow2_blue" id="ContentPane" runat="server" align="center"></TD>
        </TR>
        <TR>
          <TD class="containerrow2_blue">
            <HR class="containermaster_blue">
            <TABLE width="100%" border="0" cellpadding="0" cellspacing="0">
              <TR>
                <TD align="left" valign="middle" nowrap><scp:ACTIONBUTTON1 runat="server" id="SCPACTIONBUTTON1" CommandName="AddContent.Action" DisplayIcon="True" DisplayLink="True" /></TD>
                <TD align="right" valign="middle" nowrap><scp:ACTIONBUTTON2 runat="server" id="SCPACTIONBUTTON2" CommandName="SyndicateModule.Action" DisplayIcon="True" DisplayLink="False" />&nbsp;<scp:ACTIONBUTTON3 runat="server" id="SCPACTIONBUTTON3" CommandName="PrintModule.Action" DisplayIcon="True" DisplayLink="False" />&nbsp;<scp:ACTIONBUTTON4 runat="server" id="SCPACTIONBUTTON4" CommandName="ModuleSettings.Action" DisplayIcon="True" DisplayLink="False" /></TD>
              </TR>
            </TABLE>
          </TD>
        </TR>
      </TABLE>
      <BR>
