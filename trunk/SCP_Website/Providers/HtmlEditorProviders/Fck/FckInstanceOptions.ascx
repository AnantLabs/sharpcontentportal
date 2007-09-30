<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="Sectionhead" Src="~/controls/SectionHeadControl.ascx" %>
<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FckInstanceOptions.ascx.cs" Inherits="SharpContent.HtmlEditor.FckHtmlEditorProvider.FckInstanceOptions" %>
<%@ Register TagPrefix="Portal" TagName="URL" Src="~/controls/URLControl.ascx" %>
<TABLE id="tblEditorOptions" cellSpacing="0" cellPadding="0" width="660" align="center"
	border="0" runat="server" visible="true">
	<TR>
		<TD class="SubHead" vAlign="top" colSpan="2">
			<TABLE id="Table1" cellSpacing="0" cellPadding="0" width="100%" border="0">
				<TR>
					<TD>
						<TABLE id="Table2" cellSpacing="0" cellPadding="0" width="100%" border="0">
							<TR>
								<TD><asp:label id="lblModuleType" runat="server" meta:resourcekey="lblModuleType" CssClass="subhead"></asp:label>&nbsp;<asp:label id="txtModuleType" runat="server" CssClass="normal"></asp:label></TD>
								<TD align="right"><asp:label id="txtUsername" runat="server" CssClass="normal"></asp:label></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
				<TR>
					<TD><asp:label id="lblModuleName" runat="server" meta:resourcekey="lblModuleName" CssClass="subhead"></asp:label>&nbsp;<asp:label id="txtModuleName" runat="server" CssClass="normal"></asp:label></TD>
				</TR>
				<TR>
					<TD><asp:label id="lblModuleInstance" runat="server" meta:resourcekey="lblModuleInstance" CssClass="subhead"></asp:label>&nbsp;<asp:label id="txtModuleInstance" runat="server" CssClass="normal"></asp:label></TD>
				</TR>
			</TABLE>
			<HR width="100%" SIZE="1">
		</TD>
	</TR>
	<TR>
		<TD class="SubHead" vAlign="top" width="239"><scp:label id="plSettingsType" runat="server" suffix=":" controlname="rbSettingsType"></scp:label></TD>
		<TD class="Normal" vAlign="top" style="width: 309px"><asp:radiobuttonlist id="rbSettingsType" runat="server" CssClass="Normal" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rbSettingsType_SelectedIndexChanged">
				<asp:ListItem Value="I" meta:resourcekey="typeInstance" Selected="True">Instance</asp:ListItem>
				<asp:ListItem Value="M" meta:resourcekey="typeModule">Module</asp:ListItem>
				<asp:ListItem Value="P" meta:resourcekey="typePortal">Portal</asp:ListItem>
			</asp:radiobuttonlist></TD>
	</TR>
	<TR>
		<TD width="100%" colSpan="2" height="100%">
			<div id="optionsarea" style="BORDER-RIGHT: #000000 1px dashed; PADDING-RIGHT: 10px; BORDER-TOP: #000000 1px dashed; PADDING-LEFT: 10px; PADDING-BOTTOM: 10px; OVERFLOW: auto; BORDER-LEFT: #000000 1px dashed; WIDTH: 100%; COLOR: #333333; PADDING-TOP: 10px; BORDER-BOTTOM: #000000 1px dashed; HEIGHT: 360px; BACKGROUND-COLOR: #ffffff">
				<table cellSpacing="0" cellPadding="0" border="0">
					<tr>
						<td><scp:sectionhead id="dshThemes" runat="server" meta:resourcekey="dshThemes" cssclass="Head" text="Editor skins"
								includerule="true" section="tblThemes"></scp:sectionhead>
							<TABLE id="tblThemes" cellSpacing="0" cellPadding="0" width="100%" border="0" runat="server">
								<TR>
									<TD class="SubHead" width="230"><scp:label id="plToolbarSkin" runat="server" suffix=":" controlname="ddlToolbarSkin"></scp:label></TD>
									<TD class="Normal"><asp:dropdownlist id="ddlToolbarSkin" runat="server" CssClass="NormalTextBox" Width="296px"></asp:dropdownlist></TD>
								</TR>
								<TR>
									<TD class="SubHead" width="230"><scp:label id="plImageBrowserTheme" runat="server" suffix=":" controlname="ddlImageBrowserTheme"></scp:label></TD>
									<TD class="Normal"><asp:dropdownlist id="ddlImageBrowserTheme" runat="server" CssClass="NormalTextBox" Width="296px"></asp:dropdownlist></TD>
								</TR>
								<TR>
									<TD class="SubHead" width="230"><scp:label id="plFlashBrowserTheme" runat="server" suffix=":" controlname="ddlFlashBrowserTheme"></scp:label></TD>
									<TD class="Normal"><asp:dropdownlist id="ddlFlashBrowserTheme" runat="server" CssClass="NormalTextBox" Width="296px"></asp:dropdownlist></TD>
								</TR>
								<TR>
									<TD class="SubHead" width="230"><scp:label id="plLinkBrowserTheme" runat="server" suffix=":" controlname="ddlLinkBrowserTheme"></scp:label></TD>
									<TD class="Normal"><asp:dropdownlist id="ddlLinkBrowserTheme" runat="server" CssClass="NormalTextBox" Width="296px"></asp:dropdownlist></TD>
								</TR>
							</TABLE>
						</td>
					</tr>
					<TR>
						<TD><scp:sectionhead id="dshAvailableStyles" runat="server" meta:resourcekey="dshAvailableStyles" cssclass="Head"
								text="List of Available editor styles" includerule="true" section="tblAvailableStyles" isexpanded="false"></scp:sectionhead>
							<TABLE id="tblAvailableStyles" cellSpacing="0" cellPadding="0" width="100%" border="0"
								runat="server">
								<TR>
									<TD class="SubHead" width="224"><scp:label id="plStyleMode" runat="server" suffix=":" controlname="txtStyleFilter"></scp:label></TD>
									<TD class="Normal"><asp:radiobuttonlist id="rbStyleMode" runat="server" CssClass="Normal" RepeatDirection="Horizontal" Width="301px">
											<asp:ListItem Value="static" Selected="True">Static</asp:ListItem>
											<asp:ListItem Value="dynamic">Dynamic</asp:ListItem>
											<asp:ListItem Value="url">URL</asp:ListItem>
										</asp:radiobuttonlist></TD>
								</TR>
								<TR>
									<TD class="SubHead" vAlign="top" width="224"><scp:label id="plStyleFilter" runat="server" suffix=":" controlname="txtStyleFilter"></scp:label></TD>
									<TD class="Normal" vAlign="top"><asp:textbox id="txtStyleFilter" runat="server" CssClass="NormalTextBox" Width="400px" TextMode="MultiLine"
											Height="56px"></asp:textbox><BR>
										<asp:linkbutton id="cmdCopyFilter" runat="server" CssClass="CommandButton" CausesValidation="False" OnClick="cmdCopyFilter_Click">Copy host default filter</asp:linkbutton></TD>
								</TR>
								<TR>
									<TD class="SubHead" vAlign="top" width="224"><scp:label id="plPortalStyle" runat="server" suffix=":" controlname="ctlURL"></scp:label></TD>
									<TD class="Normal" vAlign="top"><portal:url id="ctlURL" runat="server" width="250" ShowUrls="true" ShowTabs="False" ShowLog="False"
											ShowTrack="False" Required="False"></portal:url></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD><scp:sectionhead id="dshEditorAreaCss" runat="server" meta:resourcekey="dshEditorAreaCss" cssclass="Head"
								text="Editor Area Css File" includerule="true" section="tblEditorAreaCss" isexpanded="false"></scp:sectionhead>
							<TABLE id="tblEditorAreaCss" cellSpacing="0" cellPadding="0" width="100%" border="0" runat="server">
								<TR>
									<TD class="SubHead" vAlign="top" width="224"><scp:label id="plCssMode" runat="server" suffix=":" controlname="txtStyleFilter"></scp:label></TD>
									<TD class="Normal" vAlign="top"><asp:radiobuttonlist id="rbCssMode" runat="server" CssClass="Normal" RepeatDirection="Horizontal" Width="301px">
											<asp:ListItem Value="static" Selected="True">Static</asp:ListItem>
											<asp:ListItem Value="dynamic">Dynamic</asp:ListItem>
											<asp:ListItem Value="url">URL</asp:ListItem>
										</asp:radiobuttonlist></TD>
								</TR>
								<TR>
									<TD class="SubHead" vAlign="top" width="224"><scp:label id="plPortalCss" runat="server" suffix=":" controlname="txtStyleFilter"></scp:label></TD>
									<TD class="Normal" vAlign="top"><portal:url id="ctlUrlCss" runat="server" width="250" ShowUrls="true" ShowTabs="False" ShowLog="False"
											ShowTrack="False" Required="False"></portal:url></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD><scp:sectionhead id="dshOther" runat="server" meta:resourcekey="dshOther" cssclass="Head" text="Other editor options"
								includerule="true" section="tblOther" isexpanded="false"></scp:sectionhead>
							<TABLE id="tblOther" cellSpacing="0" cellPadding="0" width="100%" border="0" runat="server">
								<TR>
									<TD class="SubHead" width="225"><scp:label id="plToolbarNotExpanded" runat="server" suffix=":" controlname="chkToolbarNotExpanded"></scp:label></TD>
									<TD><asp:checkbox id="chkToolbarNotExpanded" runat="server" CssClass="NormalTextBox"></asp:checkbox></TD>
								</TR>
								<TR>
									<TD class="SubHead" width="225"><scp:label id="plEnhancedSecurity" runat="server" suffix=":" controlname="chkEnhancedSecurity"></scp:label></TD>
									<TD class="Normal"><asp:checkbox id="chkEnhancedSecurity" runat="server" CssClass="NormalTextBox"></asp:checkbox></TD>
								</TR>
								<TR>
									<TD class="SubHead" width="225"><scp:label id="plFullImagePath" runat="server" suffix=":" controlname="chkEnhancedSecurity"></scp:label></TD>
									<TD class="Normal"><asp:checkbox id="chkFullImagePath" runat="server" CssClass="NormalTextBox"></asp:checkbox></TD>
								</TR>
								<TR>
									<TD class="SubHead" width="225"><scp:label id="plForceWidth" runat="server" suffix=":" controlname="chkEnhancedSecurity"></scp:label></TD>
									<TD class="Normal"><asp:textbox id="txtForceWidth" runat="server" CssClass="NormalTextBox" Width="136px"></asp:textbox></TD>
								</TR>
								<TR>
									<TD class="SubHead" width="225"><scp:label id="plForceHeight" runat="server" suffix=":" controlname="chkEnhancedSecurity"></scp:label></TD>
									<TD class="Normal"><asp:textbox id="txtForceHeight" runat="server" CssClass="NormalTextBox" Width="136px"></asp:textbox></TD>
								</TR>
								<TR>
									<TD class="SubHead" width="225"><scp:label id="plImageFolder" runat="server" suffix=":" controlname="chkEnhancedSecurity"></scp:label></TD>
									<TD class="Normal"><asp:dropdownlist id="ddlImageFolder" runat="server" CssClass="NormalTextBox" Width="416px"></asp:dropdownlist></TD>
								</TR>
								<TR>
									<TD class="SubHead" width="225"><scp:label id="plFontColors" runat="server" suffix=":" controlname="chkEnhancedSecurity"></scp:label></TD>
									<TD class="Normal"><asp:textbox id="txtFontColors" runat="server" CssClass="NormalTextBox" Width="416px"></asp:textbox></TD>
								</TR>
								<TR>
									<TD class="SubHead" width="225"><scp:label id="plFontNames" runat="server" suffix=":" controlname="chkEnhancedSecurity"></scp:label></TD>
									<TD class="Normal"><asp:textbox id="txtFontNames" runat="server" CssClass="NormalTextBox" Width="416px"></asp:textbox></TD>
								</TR>
								<TR>
									<TD class="SubHead" width="225"><scp:label id="plFontSizes" runat="server" suffix=":" controlname="chkEnhancedSecurity"></scp:label></TD>
									<TD class="Normal"><asp:textbox id="txtFontSizes" runat="server" CssClass="NormalTextBox" Width="416px"></asp:textbox></TD>
								</TR>
								<TR>
									<TD class="SubHead" width="225"><scp:label id="plFontFormats" runat="server" suffix=":" controlname="chkEnhancedSecurity"></scp:label></TD>
									<TD class="Normal"><asp:textbox id="txtFontFormats" runat="server" CssClass="NormalTextBox" Width="416px"></asp:textbox></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD><scp:sectionhead id="dshToolbarRoles" runat="server" meta:resourcekey="dshToolbarRoles" cssclass="Head"
								text="Toolbar Roles" includerule="true" section="tblToolbarset"></scp:sectionhead>
							<TABLE id="tblToolbarset" cellSpacing="0" cellPadding="0" width="100%" border="0" runat="server">
								<TR>
									<TD class="SubHead" vAlign="top" width="100%" style="height: 171px"><scp:label id="plToolbarSet" runat="server" suffix=":" controlname="lstToolbars"></scp:label><asp:datagrid id="grdToolbars" runat="server" CssClass="Normal" Width="620px" AutoGenerateColumns="False" OnCancelCommand="grdToolbars_CancelCommand" OnEditCommand="grdToolbars_EditCommand" OnItemCommand="grdToolbars_ItemCommand" OnUpdateCommand="grdToolbars_UpdateCommand" OnItemCreated="grdToolbars_ItemCreated" OnItemDataBound="grdToolbars_ItemDataBound">
											<HeaderStyle CssClass="SubHead"></HeaderStyle>
											<Columns>
												<asp:EditCommandColumn ButtonType="LinkButton" UpdateText="Update" CancelText="Cancel" EditText="Edit">
													<HeaderStyle Width="5px"></HeaderStyle>
													<ItemStyle VerticalAlign="Top"></ItemStyle>
												</asp:EditCommandColumn>
												<asp:TemplateColumn>
													<HeaderStyle Width="5px"></HeaderStyle>
													<ItemStyle VerticalAlign="Top"></ItemStyle>
												</asp:TemplateColumn>
												<asp:TemplateColumn HeaderText="Toolbar">
													<HeaderStyle Width="180px"></HeaderStyle>
													<ItemStyle VerticalAlign="Top"></ItemStyle>
												</asp:TemplateColumn>
												<asp:TemplateColumn HeaderText="Disabled">
													<HeaderStyle Width="5px"></HeaderStyle>
													<ItemStyle HorizontalAlign="Center" VerticalAlign="Top"></ItemStyle>
												</asp:TemplateColumn>
												<asp:TemplateColumn HeaderText="ViewRoles">
													<HeaderStyle Width="100%"></HeaderStyle>
													<ItemStyle VerticalAlign="Top"></ItemStyle>
												</asp:TemplateColumn>
											</Columns>
										</asp:datagrid><asp:linkbutton id="cmdMakeAllUsers" runat="server" meta:resourcekey="cmdMakeAllUsers" CssClass="CommandButton"
											CausesValidation="False" OnClick="cmdMakeAllUsers_Click">Include all users to each toolbar</asp:linkbutton></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</table>
			</div>
		</TD>
	</TR>
	<TR>
		<TD vAlign="top" colSpan="2">
			<HR width="100%" SIZE="1">
			<TABLE id="Table4" cellSpacing="0" cellPadding="0" width="100%" border="0">
				<TR>
					<TD class="SubHead"><scp:label id="plApplyTo" runat="server" suffix=":" controlname="ddlSettingsType"></scp:label></TD>
					<TD class="Normal"><asp:dropdownlist id="ddlSettingsType" runat="server" CssClass="NormalTextBox">
							<asp:ListItem Value="I" meta:resourcekey="typeInstance" Selected="True">Instance</asp:ListItem>
							<asp:ListItem Value="M" meta:resourcekey="typeModule">Module</asp:ListItem>
							<asp:ListItem Value="P" meta:resourcekey="typePortal">Portal</asp:ListItem>
						</asp:dropdownlist>&nbsp;&nbsp;
						<asp:linkbutton id="cmdUpdate" runat="server" meta:resourcekey="cmdUpdate" CssClass="CommandButton" CausesValidation="False" OnClick="cmdUpdate_Click">Update</asp:linkbutton>&nbsp;
						<asp:linkbutton id="cmdClear" runat="server" meta:resourcekey="cmdClear" CssClass="CommandButton" CausesValidation="False" OnClick="cmdClear_Click">Clear</asp:linkbutton></TD>
				</TR>
				<TR>
					<TD class="SubHead" colSpan="2"><asp:label id="lblResult" runat="server" CssClass="NormalRed"></asp:label></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
