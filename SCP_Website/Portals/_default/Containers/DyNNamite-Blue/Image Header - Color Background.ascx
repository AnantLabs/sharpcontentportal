<%@ Control language="vb" CodeBehind="~/admin/Containers/container.vb" AutoEventWireup="false"  Inherits="SharpContent.UI.Containers.Container" %>
<%@ Register TagPrefix="scp" TagName="ACTIONS" Src="~/Admin/Containers/SolPartActions.ascx" %>
<%@ Register TagPrefix="scp" TagName="ICON" Src="~/Admin/Containers/Icon.ascx" %>
<%@ Register TagPrefix="scp" TagName="TITLE1" Src="~/Admin/Containers/Title.ascx" %>
<%@ Register TagPrefix="scp" TagName="VISIBILITY" Src="~/Admin/Containers/Visibility.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON5" Src="~/Admin/Containers/ActionButton.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON1" Src="~/Admin/Containers/ActionButton.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON2" Src="~/Admin/Containers/ActionButton.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON3" Src="~/Admin/Containers/ActionButton.ascx" %>
<%@ Register TagPrefix="scp" TagName="ACTIONBUTTON4" Src="~/Admin/Containers/ActionButton.ascx" %>
<TABLE class="containermaster_free" cellSpacing="0" cellPadding="0" align="center" border="0">
<TR>
  <TD class="containerrow1_free">
	<TABLE width="100%" border="0" cellpadding="8" cellspacing="0">
	<tr><td>
		<TABLE width="100%" border="0" cellpadding="0" cellspacing="0">
		  <TR>
			<TD valign="middle" nowrap><scp:ACTIONS runat="server" id="SCPACTIONS" /></TD>
			<TD valign="middle" nowrap><img src="<%= SkinPath %>button.gif" width="17" height="16" hspace="4" vspace="0" border="0" align="absmiddle"></TD>
			<TD valign="middle" nowrap><scp:ICON runat="server" id="SCPICON" /></TD>
			<TD valign="middle" width="100%" nowrap><scp:TITLE1 runat="server" id="SCPTITLE1" /></TD>
			<TD valign="middle" nowrap><scp:VISIBILITY runat="server" id="SCPVISIBILITY" /><scp:ACTIONBUTTON5 runat="server" id="SCPACTIONBUTTON5" CommandName="ModuleHelp.Action" DisplayIcon="True" DisplayLink="False" /></TD>
		  </TR>
		</TABLE>
	</td></tr>
	</table>
  </TD>
</TR>
<tr><td class="containerrow2_free"><img src="<%= SkinPath %>block.gif" width="1" height="1" hspace="0" vspace="0" border="0"></td></tr>
<TR><TD class="containerrow1_free">
	<TABLE width="100%" border="0" cellpadding="20" cellspacing="0">
	<tr><TD id="ContentPane" runat="server" align="center"></TD></TR>
	</TABLE>
	<TABLE width="100%" border="0" cellpadding="5" cellspacing="0">
	  <TR>
		<TD align="left" valign="middle" nowrap><scp:ACTIONBUTTON1 runat="server" id="SCPACTIONBUTTON1" CommandName="AddContent.Action" DisplayIcon="True" DisplayLink="True" /></TD>
		<TD align="right" valign="middle" nowrap><scp:ACTIONBUTTON2 runat="server" id="SCPACTIONBUTTON2" CommandName="SyndicateModule.Action" DisplayIcon="True" DisplayLink="False" />&nbsp;<scp:ACTIONBUTTON3 runat="server" id="SCPACTIONBUTTON3" CommandName="PrintModule.Action" DisplayIcon="True" DisplayLink="False" />&nbsp;<scp:ACTIONBUTTON4 runat="server" id="SCPACTIONBUTTON4" CommandName="ModuleSettings.Action" DisplayIcon="True" DisplayLink="False" /></TD>
	  </TR>
	</TABLE>
</TR></TR>
</TABLE>
<BR>

