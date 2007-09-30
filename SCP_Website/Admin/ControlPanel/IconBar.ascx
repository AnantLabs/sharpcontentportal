<%@ Control Language="C#" AutoEventWireup="true" Inherits="SharpContent.UI.ControlPanels.IconBar"
    CodeFile="IconBar.ascx.cs" %>
    <table class="ControlPanel" cellspacing="0" cellpadding="0" border="0">
	<tr>
		<td>
<table cellspacing="2" cellpadding="1" width="100%">
    <tr>
        <td align="left" valign="top" width="25%" nowrap>
            &nbsp;<asp:Label ID="lblMode" runat="server" CssClass="SubHead" meta:resourcekey="Mode"
                EnableViewState="False">Mode:</asp:Label>
            <asp:RadioButtonList ID="optMode" CssClass="SubHead" runat="server" RepeatDirection="Horizontal"
                RepeatLayout="Flow" AutoPostBack="True" OnSelectedIndexChanged="optMode_SelectedIndexChanged">
                <asp:ListItem Value="VIEW" meta:resourcekey="ModeView">View</asp:ListItem>
                <asp:ListItem Value="EDIT" meta:resourcekey="ModeEdit">Edit</asp:ListItem>
            </asp:RadioButtonList>
        </td>
        <td align="center" valign="top" width="50%">
            <asp:Label ID="lblCtrlPanelTitle" runat="server" CssClass="SubHead" meta:resourcekey="ControlPanelTitle" Text="Content Control Panel"></asp:Label></td>
        <td align="right" valign="top" width="25%" nowrap>
            <asp:Label ID="lblVisibility" runat="server" CssClass="SubHead" meta:resourcekey="Visibility"
                EnableViewState="False">Hide Control Panel?</asp:Label>
            <asp:LinkButton ID="cmdVisibility" runat="server" CausesValidation="False">
                <asp:Image ID="imgVisibility" runat="server"></asp:Image></asp:LinkButton>&nbsp;
        </td>
    </tr>
    <tr id="rowControlPanel" runat="server">
        <td align="center" valign="top" style="border-top:1px #CCCCCC dotted;">
            <asp:Label ID="lblPageFunctions" runat="server" CssClass="SubHead" EnableViewState="False"><font size="1">Page 
								Functions</font></asp:Label>
            <table cellspacing="0" cellpadding="2" border="0">
                <tr valign="bottom" height="24">
                    <td width="35" align="center" style="height: 24px">
                        <asp:LinkButton ID="cmdAddTabIcon" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="PageFunctions_Click">
                            <asp:Image ID="imgAddTabIcon" runat="server" ImageUrl="~/admin/ControlPanel/images/iconbar_addtab.gif">
                            </asp:Image>
                        </asp:LinkButton></td>
                    <td width="35" align="center" style="height: 24px">
                        <asp:LinkButton ID="cmdEditTabIcon" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="PageFunctions_Click">
                            <asp:Image ID="imgEditTabIcon" runat="server" ImageUrl="~/admin/ControlPanel/images/iconbar_edittab.gif">
                            </asp:Image>
                        </asp:LinkButton></td>
                    <td width="35" align="center" style="height: 24px">
                        <asp:LinkButton ID="cmdDeleteTabIcon" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="PageFunctions_Click">
                            <asp:Image ID="imgDeleteTabIcon" runat="server" ImageUrl="~/admin/ControlPanel/images/iconbar_deletetab.gif">
                            </asp:Image>
                        </asp:LinkButton></td>
                    <td width="35" align="center" style="height: 24px">
                        <asp:LinkButton ID="cmdCopyTabIcon" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="PageFunctions_Click">
                            <asp:Image ID="imgCopyTabIcon" runat="server" ImageUrl="~/admin/ControlPanel/images/iconbar_copytab.gif">
                            </asp:Image>
                        </asp:LinkButton></td>
                    <td width="35" align="center" style="height: 24px">
                        <asp:LinkButton ID="cmdPreviewTabIcon" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="PageFunctions_Click" Visible="False">
                            <asp:Image ID="imgPreviewTabIcon" runat="server" ImageUrl="~/admin/ControlPanel/images/iconbar_previewtab.gif">
                            </asp:Image>
                        </asp:LinkButton></td>
                </tr>
                <tr valign="bottom">
                    <td width="35" align="center" class="Normal" style="height: 23px">
                        <asp:LinkButton ID="cmdAddTab" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="PageFunctions_Click">Add</asp:LinkButton></td>
                    <td width="35" align="center" class="Normal" style="height: 23px">
                        <asp:LinkButton ID="cmdEditTab" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="PageFunctions_Click">Settings</asp:LinkButton></td>
                    <td width="35" align="center" class="Normal" style="height: 23px">
                        <asp:LinkButton ID="cmdDeleteTab" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="PageFunctions_Click">Delete</asp:LinkButton></td>
                    <td width="35" align="center" class="Normal" style="height: 23px">
                        <asp:LinkButton ID="cmdCopyTab" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="PageFunctions_Click">Copy</asp:LinkButton></td>
                    <td width="35" align="center" class="Normal" style="height: 23px">
                        <asp:LinkButton ID="cmdPreviewTab" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="PageFunctions_Click" Visible="False">Preview</asp:LinkButton></td>
                </tr>
            </table>
        </td>
        <td align="center" valign="top" style="border-left:1px #CCCCCC dotted; border-top:1px #CCCCCC dotted; border-right:1px #CCCCCC dotted;">
            <table cellspacing="1" cellpadding="0" border="0">
                <tr>
                    <td align="center">
                        <asp:RadioButtonList ID="optModuleType" CssClass="SubHead" runat="server" RepeatDirection="Horizontal"
                            RepeatLayout="Flow" AutoPostBack="True" OnSelectedIndexChanged="optModuleType_SelectedIndexChanged">
                            <asp:ListItem Value="0" resourcekey="optModuleTypeNew">Add New Module</asp:ListItem>
                            <asp:ListItem Value="1" resourcekey="optModuleTypeExisting">Add Existing Module</asp:ListItem>
                        </asp:RadioButtonList>
                        <table cellspacing="1" cellpadding="0" border="0">
                            <tr valign="bottom">
                                <td class="SubHead" align="right" nowrap>
                                    <asp:Label ID="lblModule" runat="server" CssClass="SubHead" EnableViewState="False">Module:</asp:Label>&nbsp;</td>
                                <td nowrap>
                                    <asp:DropDownList ID="cboTabs" runat="server" CssClass="NormalTextBox" Width="140"
                                        DataValueField="TabID" DataTextField="TabName" Visible="False" AutoPostBack="True"
                                        OnSelectedIndexChanged="cboTabs_SelectedIndexChanged">
                                    </asp:DropDownList><asp:DropDownList ID="cboDesktopModules" runat="server" CssClass="NormalTextBox"
                                        Width="140" DataValueField="DesktopModuleID" DataTextField="FriendlyName">
                                    </asp:DropDownList>&nbsp;&nbsp;</td>
                                <td class="SubHead" align="right" nowrap>
                                    <asp:Label ID="lblPane" runat="server" CssClass="SubHead" EnableViewState="False">Pane:</asp:Label>&nbsp;</td>
                                <td nowrap>
                                    <asp:DropDownList ID="cboPanes" runat="server" CssClass="NormalTextBox" Width="110">
                                    </asp:DropDownList>&nbsp;&nbsp;</td>
                                <td align="center" nowrap>
                                    <asp:LinkButton ID="cmdAddModuleIcon" runat="server" CssClass="CommandButton" CausesValidation="False"
                                        OnClick="AddModule_Click">
                                        <asp:Image runat="server" EnableViewState="False" ID="imgAddModuleIcon" ImageUrl="~/admin/ControlPanel/images/iconbar_addmodule.gif">
                                        </asp:Image>
                                    </asp:LinkButton></td>
                            </tr>
                            <tr valign="bottom">
                                <td class="SubHead" align="right" nowrap>
                                    <asp:Label ID="lblTitle" runat="server" CssClass="SubHead" EnableViewState="False">Title:</asp:Label>&nbsp;</td>
                                <td nowrap>
                                    <asp:DropDownList ID="cboModules" runat="server" CssClass="NormalTextBox" Width="140"
                                        DataValueField="ModuleID" DataTextField="ModuleTitle" Visible="False">
                                    </asp:DropDownList><asp:TextBox ID="txtTitle" runat="server" CssClass="NormalTextBox"
                                        Width="140"></asp:TextBox>&nbsp;&nbsp;</td>
                                <td class="SubHead" align="right" nowrap>
                                    <asp:Label ID="lblPosition" runat="server" CssClass="SubHead" resourcekey="Position"
                                        EnableViewState="False">Insert:</asp:Label>&nbsp;</td>
                                <td nowrap>
                                    <asp:DropDownList ID="cboPosition" runat="server" CssClass="NormalTextBox" Width="110">
                                        <asp:ListItem Value="0" resourcekey="Top">Top</asp:ListItem>
                                        <asp:ListItem Value="-1" resourcekey="Bottom">Bottom</asp:ListItem>
                                    </asp:DropDownList>&nbsp;&nbsp;
                                </td>
                                <td align="center" class="Normal" nowrap>
                                    <asp:LinkButton ID="cmdAddModule" runat="server" CssClass="CommandButton" CausesValidation="False">Add</asp:LinkButton></td>
                            </tr>
                            <tr valign="bottom">
                                <td class="SubHead" align="right" nowrap style="height: 22px">
                                    <asp:Label ID="lblPermission" runat="server" CssClass="SubHead" resourcekey="Permission"
                                        EnableViewState="False">Visibility:</asp:Label>&nbsp;</td>
                                <td nowrap style="height: 22px">
                                    <asp:DropDownList ID="cboPermission" runat="server" CssClass="NormalTextBox" Width="140">
                                        <asp:ListItem Value="0" resourcekey="PermissionView">Same As Page</asp:ListItem>
                                        <asp:ListItem Value="1" resourcekey="PermissionEdit">Page Editors Only</asp:ListItem>
                                    </asp:DropDownList>&nbsp;&nbsp;
                                </td>
                                <td class="SubHead" align="right" nowrap style="height: 22px">
                                    <asp:Label ID="lblAlign" runat="server" CssClass="SubHead" EnableViewState="False">Align:</asp:Label>&nbsp;</td>
                                <td nowrap style="height: 22px">
                                    <asp:DropDownList ID="cboAlign" runat="server" CssClass="NormalTextBox" Width="110">
                                        <asp:ListItem Value="left" resourcekey="Left">Left</asp:ListItem>
                                        <asp:ListItem Value="center" resourcekey="Center">Center</asp:ListItem>
                                        <asp:ListItem Value="right" resourcekey="Right">Right</asp:ListItem>
                                    </asp:DropDownList>&nbsp;&nbsp;
                                </td>
                                <td align="center" nowrap style="height: 22px">
                                    &nbsp;</td>
                            </tr>
                            <tr id="rowInstallModule" runat="server" valign="bottom">
                                <td align="center" colspan="5" width="100%" style="height: 27px">
            <asp:LinkButton ID="cmdInstallFeatures" runat="server" CausesValidation="False" CssClass="CommandButton">Install New Modules</asp:LinkButton></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td align="center" valign="top" style="border-top:1px #CCCCCC dotted;">
            <asp:Label ID="lblCommonTasks" runat="server" CssClass="SubHead" EnableViewState="False"><font size="1">Common 
								Tasks</font></asp:Label>
            <table cellspacing="0" cellpadding="2" border="0">
                <tr valign="bottom" height="24">
                    <td width="35" align="center">
                        <asp:LinkButton ID="cmdSiteIcon" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="CommonTasks_Click">
                            <asp:Image ID="imgSiteIcon" runat="server" ImageUrl="~/admin/ControlPanel/images/iconbar_site.gif">
                            </asp:Image>
                        </asp:LinkButton></td>
                    <td width="35" align="center">
                        <asp:LinkButton ID="cmdUsersIcon" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="CommonTasks_Click">
                            <asp:Image ID="imgUsersIcon" runat="server" ImageUrl="~/admin/ControlPanel/images/iconbar_users.gif">
                            </asp:Image>
                        </asp:LinkButton></td>
                    <td align="center" width="35">
                        <asp:LinkButton ID="cmdRolesIcon" runat="server" CausesValidation="False" CssClass="CommandButton"
                            OnClick="CommonTasks_Click">
                            <asp:Image ID="imgRolesIcon" runat="server" ImageUrl="~/admin/ControlPanel/images/iconbar_roles.gif" />
                        </asp:LinkButton></td>
                    <td width="35" align="center">
                        <asp:LinkButton ID="cmdFilesIcon" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="CommonTasks_Click">
                            <asp:Image ID="imgFilesIcon" runat="server" ImageUrl="~/admin/ControlPanel/images/iconbar_files.gif">
                            </asp:Image>
                        </asp:LinkButton></td>
                    <td width="35" align="center">
                        <asp:HyperLink ID="cmdHelpIcon" runat="server" CssClass="CommandButton" Target="_new">
                            <asp:Image ID="imgHelpIcon" runat="server" ImageUrl="~/admin/ControlPanel/images/iconbar_help.gif">
                            </asp:Image>
                        </asp:HyperLink></td>
                </tr>
                <tr valign="bottom">
                    <td width="35" align="center" class="Normal">
                        <asp:LinkButton ID="cmdSite" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="CommonTasks_Click">Site</asp:LinkButton></td>
                    <td width="35" align="center" class="Normal">
                        <asp:LinkButton ID="cmdUsers" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="CommonTasks_Click">Users</asp:LinkButton></td>
                    <td align="center" class="Normal" width="35">
                        <asp:LinkButton ID="cmdRoles" runat="server" CausesValidation="False" CssClass="CommandButton"
                            OnClick="CommonTasks_Click">Roles</asp:LinkButton></td>
                    <td width="35" align="center" class="Normal">
                        <asp:LinkButton ID="cmdFiles" runat="server" CssClass="CommandButton" CausesValidation="False"
                            OnClick="CommonTasks_Click">Files</asp:LinkButton></td>
                    <td width="35" align="center" class="Normal">
                        <asp:HyperLink ID="cmdHelp" runat="server" CssClass="CommandButton" Target="_new">Help</asp:HyperLink></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</td>
</tr>
</table>
