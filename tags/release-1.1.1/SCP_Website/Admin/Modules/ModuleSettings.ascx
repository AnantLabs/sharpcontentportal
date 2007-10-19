<%@ Register TagPrefix="Portal" TagName="URL" Src="~/controls/URLControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="SectionHead" Src="~/controls/SectionHeadControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="Skin" Src="~/controls/SkinControl.ascx" %>
<%@ Register TagPrefix="scp" Namespace="SharpContent.Security.Permissions.Controls" Assembly="SharpContent" %>
<%@ Control Language="C#" AutoEventWireup="true"  Inherits="SharpContent.Modules.Admin.Modules.ModuleSettingsPage" CodeFile="ModuleSettings.ascx.cs" %>
<table class="Settings" cellspacing="2" cellpadding="2" width="560" summary="Module Settings Design Table"
	border="0">
	<tr>
		<td style="width: 560;" valign="top">
			<scp:sectionhead id="dshModule" cssclass="Head" runat="server" text="Module Settings" section="tblModule"
				resourcekey="ModuleSettings" includerule="True" />
			<table id="tblModule" cellspacing="2" cellpadding="2" summary="Module Details Design Table"
				border="0" runat="server">
				<tr>
					<td colspan="2"><asp:label id="lblModuleSettingsHelp" cssclass="Normal" runat="server" resourcekey="ModuleSettingsHelp"
							enableviewstate="False">In this section, you can set up the settings that relate to the Module itself. (ie those settings that will be the same in all pages where the Module appears).</asp:label></td>
				</tr>
				<tr>
					<td style="width: 25;"></td>
					<td valign="top" style="width: 475;">
						<scp:sectionhead id="dshDetails" cssclass="Head" runat="server" text="Basic Settings" section="tblDetails"
							resourcekey="GeneralDetails" />
						<table id="tblDetails" cellspacing="2" cellpadding="2" summary="Appearance Design Table"
							border="0" runat="server">
							<tr>
								<td class="SubHead" style="width: 200;"><scp:label id="plTitle" text="Title:" runat="server" controlname="txtTitle"></scp:label></td>
								<td><asp:textbox id="txtTitle" runat="server" cssclass="NormalTextBox" style="width: 250;"></asp:textbox></td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 200;" valign="top"><br/>
									<scp:label id="plPermissions" runat="server" controlname="ctlPermissions" text="Permissions:"></scp:label>
							    </td>							
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
									<table border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td><scp:modulepermissionsgrid id="dgPermissions" runat="server"/></td>
										</tr>
										<tr>
											<td><asp:checkbox id="chkInheritPermissions" cssclass="Normal" autopostback="true" runat="server"
													text="Inherit <b>View</b> permissions from <b>Page</b>" resourcekey="InheritPermissions" OnCheckedChanged="chkInheritPermissions_CheckedChanged" /></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<br/>
						<scp:sectionhead id="dshSecurity" cssclass="Head" runat="server" text="Security Settings" section="tblSecurity"
							resourcekey="Security" isexpanded="False" />
						<table id="tblSecurity" cellspacing="2" cellpadding="2" summary="Security Details Design Table"
							border="0" runat="server">
							<tr>
								<td class="SubHead" style="width: 225;"><scp:label id="plAllTabs" text="Display Module On All Pages?" runat="server" controlname="chkAllTabs"></scp:label></td>
								<td><asp:checkbox id="chkAllTabs" runat="server" font-size="8pt" font-names="Verdana,Arial"></asp:checkbox></td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 225;"><scp:label id="plHeader" text="Header:" runat="server" controlname="txtHeader"></scp:label></td>
								<td valign="top"><asp:textbox id="txtHeader" width="250" cssclass="NormalTextBox" runat="server" textmode="MultiLine"
										rows="6"></asp:textbox></td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 225;"><scp:label id="plFooter" text="Footer:" runat="server" controlname="txtFooter"></scp:label></td>
								<td valign="top"><asp:textbox id="txtFooter" width="250" cssclass="NormalTextBox" runat="server" textmode="MultiLine"
										rows="6"></asp:textbox></td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 150;" valign="top"><scp:label id="plStartDate" runat="server" controlname="txtStartDate" text="Start Date:"></scp:label></td>
								<td>
									<asp:textbox id="txtStartDate" runat="server" cssclass="NormalTextBox" width="120" columns="30"
										maxlength="11"></asp:textbox>&nbsp;
									<asp:hyperlink id="cmdStartCalendar" cssclass="CommandButton" runat="server" resourcekey="Calendar">Calendar</asp:hyperlink>
									<asp:CompareValidator ID="valtxtStartDate" ControlToValidate="txtStartDate" Operator="DataTypeCheck" Type="Date"
										Runat="server" Display="Dynamic" ErrorMessage="<br>Invalid Start Date" resourcekey="valStartDate.ErrorMessage" />
								</td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 150;" valign="top"><scp:label id="plEndDate" runat="server" controlname="txtEndDate" text="End Date:"></scp:label></td>
								<td>
									<asp:textbox id="txtEndDate" runat="server" cssclass="NormalTextBox" width="120" columns="30"
										maxlength="11"></asp:textbox>&nbsp;
									<asp:hyperlink id="cmdEndCalendar" cssclass="CommandButton" runat="server" resourcekey="Calendar">Calendar</asp:hyperlink>
									<asp:CompareValidator ID="valtxtEndDate" ControlToValidate="txtEndDate" Operator="DataTypeCheck" Type="Date"
										Runat="server" Display="Dynamic" ErrorMessage="<br>Invalid End Date" resourcekey="valEndDate.ErrorMessage" />
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<br/>
			<scp:sectionhead id="dshPage" cssclass="Head" runat="server" text="Page Settings" section="tblPage"
				resourcekey="PageSettings" isexpanded="False" includerule="True" />
			<table id="tblPage" cellspacing="0" cellpadding="2" width="525" summary="Advanced Settings Design Table"
				border="0" runat="server">
				<tr>
					<td colspan="2"><asp:label id="lblPageSettingsHelp" cssclass="Normal" runat="server" resourcekey="PageSettingsHelp"
							enableviewstate="False">In this section, you can set up settings specific to this particular occurence of the module.</asp:label></td>
				</tr>
				<tr>
					<td style="width: 25;"></td>
					<td valign="top" style="width: 475;">
						<scp:sectionhead id="dshAppearance" cssclass="Head" runat="server" text="Basic Settings" section="tblAppearance"
							resourcekey="Appearance" />
						<table id="tblAppearance" cellspacing="2" cellpadding="2" summary="Appearance Design Table"
							border="0" runat="server">
							<tr>
								<td class="SubHead" style="width: 200;" valign="top">
									<scp:label id="plIcon" text="Icon:" runat="server" controlname="ctlIcon"></scp:label></td>
								<td style="width: 275;">
									<portal:url id="ctlIcon" runat="server" width="275" showurls="False" showtabs="False" showlog="False"
										showtrack="False" required="False" /></td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 200;"><scp:label id="plAlign" text="Alignment:" runat="server" controlname="cboAlign"></scp:label></td>
								<td valign="top">
									<asp:radiobuttonlist id="cboAlign" cssclass="NormalTextBox" runat="server" repeatdirection="Horizontal">
										<asp:listitem resourcekey="Left" value="left">Left</asp:listitem>
										<asp:listitem resourcekey="Center" value="center">Center</asp:listitem>
										<asp:listitem resourcekey="Right" value="right">Right</asp:listitem>
									</asp:radiobuttonlist>
								</td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 200;"><scp:label id="plColor" text="Color:" runat="server" controlname="txtColor"></scp:label></td>
								<td valign="top"><asp:textbox id="txtColor" width="250" cssclass="NormalTextBox" runat="server" columns="7"></asp:textbox></td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 200;"><scp:label id="plBorder" text="Border:" runat="server" controlname="txtBorder"></scp:label></td>
								<td valign="top">
									<asp:textbox id="txtBorder" width="250" cssclass="NormalTextBox" runat="server" columns="1"></asp:textbox>
									<asp:CompareValidator ID="valBorder" ControlToValidate="txtBorder" Operator="DataTypeCheck" Type="Integer" Runat="server" Display="Dynamic" ErrorMessage="<br>Invalid Border (must be a number between 0 and 9)" resourcekey="valBorder.ErrorMessage" />
								</td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 200;"><scp:label id="plVisibility" text="Visibility:" runat="server" controlname="cboVisibility"></scp:label></td>
								<td>
									<asp:radiobuttonlist id="cboVisibility" cssclass="NormalTextBox" runat="server" repeatdirection="Horizontal">
										<asp:listitem resourcekey="Maximized" value="0">Maximized</asp:listitem>
										<asp:listitem resourcekey="Minimized" value="1">Minimized</asp:listitem>
										<asp:listitem resourcekey="None" value="2">None</asp:listitem>
									</asp:radiobuttonlist>
								</td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 200;"><scp:label id="plDisplayTitle" text="Display Title?" runat="server" controlname="chkDisplayTitle"></scp:label></td>
								<td valign="top"><asp:CheckBox ID="chkDisplayTitle" Runat="server" CssClass="NormalTextBox"></asp:CheckBox></td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 200;"><scp:label id="plDisplayPrint" text="Allow Print?" runat="server" controlname="chkDisplayPrint"></scp:label></td>
								<td valign="top"><asp:CheckBox ID="chkDisplayPrint" Runat="server" CssClass="NormalTextBox"></asp:CheckBox></td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 200;"><scp:label id="plDisplaySyndicate" text="Allow Syndicate?" runat="server" controlname="chkDisplaySyndicate"></scp:label></td>
								<td valign="top"><asp:CheckBox ID="chkDisplaySyndicate" Runat="server" CssClass="NormalTextBox"></asp:CheckBox></td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 200;"><scp:label id="plModuleContainer" text="Module Container:" runat="server" controlname="ctlModuleContainer"></scp:label></td>
								<td valign="top"><scp:skin id="ctlModuleContainer" runat="server"></scp:skin></td>
							</tr>
							<tr id="rowCache" runat="Server">
								<td class="SubHead" style="width: 200;" valign="top"><scp:label id="plCacheTime" runat="server" controlname="txtCacheTime" text="Cache Timeout (seconds):"></scp:label></td>
								<td>
									<asp:textbox id="txtCacheTime" runat="server" cssclass="NormalTextBox" width="250" columns="10"
										maxlength="6"></asp:textbox>
									<asp:CompareValidator ID="valCacheTime" ControlToValidate="txtCacheTime" Operator="DataTypeCheck" Type="Integer"
										Runat="server" Display="Dynamic" ErrorMessage="<br>Invalid Cache Time" resourcekey="valCacheTime.ErrorMessage" />
								</td>
							</tr>
						</table>
						<br/>
						<scp:sectionhead id="dshOther" cssclass="Head" runat="server" text="Advanced Settings" section="tblOther"
							resourcekey="OtherSettings" isexpanded="False" />
						<table id="tblOther" cellspacing="2" cellpadding="2" summary="Security Details Design Table"
							border="0" runat="server">
							<tr>
								<td class="SubHead" style="width: 200;"><scp:label id="plDefault" text="Set As Default Settings?" runat="server" controlname="chkDefault"></scp:label></td>
								<td valign="top"><asp:CheckBox ID="chkDefault" Runat="server" CssClass="NormalTextBox"></asp:CheckBox></td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 200;"><scp:label id="plAllModules" text="Apply To All Modules?" runat="server" controlname="chkAllModules"></scp:label></td>
								<td valign="top"><asp:CheckBox ID="chkAllModules" Runat="server" CssClass="NormalTextBox"></asp:CheckBox></td>
							</tr>
							<tr>
								<td class="SubHead" style="width: 200;"><scp:label id="plTab" text="Move To Tab:" runat="server" controlname="cboTab"></scp:label></td>
								<td><asp:dropdownlist id="cboTab" width="250" datatextfield="TabName" datavaluefield="TabId" cssclass="NormalTextBox"
										runat="server"></asp:dropdownlist></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<br/>
			<scp:sectionhead id="dshSpecific" cssclass="Head" runat="server" text="Module Specific Settings"
				section="tblSpecific" isexpanded="False" includerule="True" />
			<table id="tblSpecific" cellspacing="0" cellpadding="2" width="525" summary="Specific Settings Design Table"
				border="0" runat="server">
                <tr id="rowspecifichelp" runat="server">
                    <td align="left" class="NormalBold" colspan="2">
                        <asp:Image ID="imgSpecificHelp" runat="server" ImageUrl="~/images/help.gif" />
                        <asp:HyperLink ID="lnkSpecificHelp" runat="server"></asp:HyperLink>&nbsp;:&nbsp;
                        <asp:Label ID="lblSpecificSettingsHelp" runat="server" CssClass="Normal" EnableViewState="False" resourcekey="SpecificSettingsHelp">In this section, you can set up settings that are specific for this module.</asp:Label><br />
                        <br />
                    </td>
                </tr>
				<tr>
					<td style="width: 25;"></td>
					<td valign="top" style="width: 475;">
						<asp:panel id="pnlSpecific" runat="server"></asp:panel>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<p>
	<asp:linkbutton cssclass="CommandButton" id="cmdUpdate" resourcekey="cmdUpdate" runat="server" text="Update" OnClick="cmdUpdate_Click"></asp:linkbutton>&nbsp;&nbsp;
	<asp:linkbutton cssclass="CommandButton" id="cmdCancel" resourcekey="cmdCancel" runat="server" text="Cancel" causesvalidation="False" OnClick="cmdCancel_Click"></asp:linkbutton>&nbsp;&nbsp;
	<asp:linkbutton cssclass="CommandButton" id="cmdDelete" resourcekey="cmdDelete" runat="server" text="Delete" causesvalidation="False" OnClick="cmdDelete_Click"></asp:linkbutton>
</p>
