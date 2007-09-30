<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="SectionHead" Src="~/controls/SectionHeadControl.ascx" %>
<%@ Control Language="C#" AutoEventWireup="true"  Inherits="SharpContent.Modules.Admin.PortalManagement.Signup" CodeFile="Signup.ascx.cs" %>
<table class="Settings" cellSpacing="2" cellPadding="2" width="560" summary="Host Settings Design Table"
	border="0">
	<tr>
		<td vAlign="top" width="560"><scp:sectionhead id="dshPortal" includerule="True" resourcekey="PortalSetup" section="tblPortal"
				text="Portal Setup" cssclass="Head" runat="server"></scp:sectionhead>
			<table id="tblPortal" cellSpacing="0" cellPadding="2" width="525" summary="Basic Settings Design Table"
				border="0" runat="server">
				<tr>
					<td class="Normal" colSpan="2"><asp:label id="lblInstructions" cssclass="Normal" runat="server"></asp:label></td>
				</tr>
				<tr>
					<td align="center" colSpan="2">
						<p><asp:label id="lblMessage" cssclass="NormalRed" runat="server"></asp:label><br>
							<asp:datalist id="lstResults" runat="server" cellpadding="4" cellspacing="0" borderwidth="0" visible="False"
								width="100%">
								<headertemplate>
									<span class="NormalBold">Validation Results</span>
								</headertemplate>
								<itemtemplate>
									<span class="Normal">
										<%# Container.DataItem %>
									</span>
								</itemtemplate>
							</asp:datalist></p>
					</td>
				</tr>
				<tr id="rowType" runat="server">
					<td class="SubHead" width="150"><scp:label id="plType" text="Portal Type:" runat="server" controlname="optType"></scp:label></td>
					<td class="SubHead"><asp:radiobuttonlist id="optType" cssclass="Normal" runat="server" repeatdirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="optType_SelectedIndexChanged">
							<asp:listitem resourcekey="Parent" value="P">Parent</asp:listitem>
							<asp:listitem resourcekey="Child" value="C">Child</asp:listitem>
						</asp:radiobuttonlist></td>
				</tr>
				<tr>
					<td class="SubHead" width="150"><scp:label id="plPortalAlias" text="Portal Alias:" runat="server" controlname="txtPortalName"></scp:label></td>
					<td><asp:textbox id="txtPortalName" cssclass="NormalTextBox" runat="server" width="300" maxlength="128"></asp:textbox><asp:requiredfieldvalidator id="valPortalName" resourcekey="valPortalName.ErrorMessage" cssclass="Normal" runat="server"
							controltovalidate="txtPortalName" errormessage="Portal Name Is Required." display="Dynamic"></asp:requiredfieldvalidator></td>
				</tr>
				<tr>
					<td class="SubHead" valign="top" width="150">
						<scp:label id="plHomeDirectory" text="Home Directory:" runat="server" controlname="txtHomeDirectory"></scp:label></td>
					<td class="NormalTextBox" width="325" nowrap>
						<asp:textbox id="txtHomeDirectory" cssclass="NormalTextBox" runat="server" width="300" maxlength="100"></asp:textbox>&nbsp;<asp:LinkButton CausesValidation="False" ID="btnCustomizeHomeDir" Runat="server" resourcekey="Customize"
							CssClass="CommandButton" OnClick="btnCustomizeHomeDir_Click">Customize</asp:LinkButton></td>
				</tr>
				<tr>
					<td class="SubHead" width="150"><scp:label id="plTitle" text="Title:" runat="server" controlname="txtTitle"></scp:label></td>
					<td><asp:textbox id="txtTitle" cssclass="NormalTextBox" runat="server" width="300" maxlength="128"></asp:textbox></td>
				</tr>
				<tr>
					<td class="SubHead" width="150"><scp:label id="plDescription" text="Description:" runat="server" controlname="txtDescription"></scp:label></td>
					<td><asp:textbox id="txtDescription" cssclass="NormalTextBox" runat="server" width="300" maxlength="500"
							textmode="MultiLine" rows="3"></asp:textbox></td>
				</tr>
				<tr>
					<td class="SubHead" width="150"><scp:label id="plKeyWords" text="KeyWords:" runat="server" controlname="txtKeyWords"></scp:label></td>
					<td><asp:textbox id="txtKeyWords" cssclass="NormalTextBox" runat="server" width="300" maxlength="500"
							textmode="MultiLine" rows="3"></asp:textbox></td>
				</tr>
				<tr>
					<td class="SubHead" width="150" vAlign="top"><scp:label id="plTemplate" text="Template:" runat="server" controlname="cboTemplate"></scp:label></td>
					<td vAlign="top"><asp:dropdownlist id="cboTemplate" cssclass="NormalTextBox" runat="server" width="300" AutoPostBack="True" OnSelectedIndexChanged="cboTemplate_SelectedIndexChanged"></asp:dropdownlist>
						<asp:RequiredFieldValidator id="valTemplate" runat="server" ErrorMessage="Please select a template file" Display="Dynamic"
							ControlToValidate="cboTemplate" InitialValue="-1" resourcekey="valTemplate.ErrorMessage"></asp:RequiredFieldValidator><BR>
						<asp:Label id="lblTemplateDescription" runat="server" CssClass="Normal"></asp:Label></td>
				</tr>
			</table>
			<br>
			<scp:sectionhead id="dshSecurity" includerule="True" resourcekey="SecuritySettings" section="tblSecurity"
				text="Security Settings" cssclass="Head" runat="server"></scp:sectionhead>
			<table id="tblSecurity" cellSpacing="0" cellPadding="2" width="525" summary="Basic Settings Design Table"
				border="0" runat="server">
				<tr>
					<td class="SubHead" width="150"><scp:label id="plFirstName" text="First Name:" runat="server" controlname="txtFirstName"></scp:label></td>
					<td><asp:textbox id="txtFirstName" cssclass="NormalTextBox" runat="server" width="300" maxlength="100"></asp:textbox><asp:requiredfieldvalidator id="valFirstName" resourcekey="valFirstName.ErrorMessage" cssclass="Normal" runat="server"
							controltovalidate="txtFirstName" errormessage="First Name Is Required." display="Dynamic"></asp:requiredfieldvalidator></td>
				</tr>
				<tr>
					<td class="SubHead" width="150"><scp:label id="plLastName" text="Last Name:" runat="server" controlname="txtLastName"></scp:label></td>
					<td><asp:textbox id="txtLastName" cssclass="NormalTextBox" runat="server" width="300" maxlength="100"></asp:textbox><asp:requiredfieldvalidator id="valLastName" resourcekey="valLastName.ErrorMessage" cssclass="Normal" runat="server"
							controltovalidate="txtLastName" errormessage="Last Name Is Required." display="Dynamic"></asp:requiredfieldvalidator></td>
				</tr>
				<tr>
					<td class="SubHead" width="150"><scp:label id="plAccountNumber" text="Account Number:" runat="server" controlname="txtAccountNumber"></scp:label></td>
					<td><asp:textbox id="txtAccountNumber" cssclass="NormalTextBox" runat="server" width="300" maxlength="100"></asp:textbox><asp:requiredfieldvalidator id="valAccountNumber" resourcekey="valAccountNumber.ErrorMessage" cssclass="Normal" runat="server"
							controltovalidate="txtUsername" errormessage="Account Number Is Required." display="Dynamic"></asp:requiredfieldvalidator></td>
				</tr>
				<tr>
					<td class="SubHead" width="150"><scp:label id="plUsername" text="Username:" runat="server" controlname="txtUsername"></scp:label></td>
					<td><asp:textbox id="txtUsername" cssclass="NormalTextBox" runat="server" width="300" maxlength="100"></asp:textbox><asp:requiredfieldvalidator id="valUsername" resourcekey="valUsername.ErrorMessage" cssclass="Normal" runat="server"
							controltovalidate="txtUsername" errormessage="Username Is Required." display="Dynamic"></asp:requiredfieldvalidator></td>
				</tr>
				<tr>
					<td class="SubHead" width="150"><scp:label id="plPassword" text="Password:" runat="server" controlname="txtPassword"></scp:label></td>
					<td><asp:textbox id="txtPassword" cssclass="NormalTextBox" runat="server" width="300" maxlength="20"
							textmode="password"></asp:textbox><asp:requiredfieldvalidator id="valPassword" resourcekey="valPassword.ErrorMessage" cssclass="Normal" runat="server"
							controltovalidate="txtPassword" errormessage="Password Is Required." display="Dynamic"></asp:requiredfieldvalidator></td>
				</tr>
				<tr>
					<td class="SubHead" width="150"><scp:label id="plConfirm" text="Confirm:" runat="server" controlname="txtConfirm"></scp:label></td>
					<td><asp:textbox id="txtConfirm" cssclass="NormalTextBox" runat="server" width="300" maxlength="20"
							textmode="password"></asp:textbox><asp:requiredfieldvalidator id="valConfirm" resourcekey="valConfirm.ErrorMessage" cssclass="Normal" runat="server"
							controltovalidate="txtConfirm" errormessage="Password Confirmation Is Required." display="Dynamic"></asp:requiredfieldvalidator></td>
				</tr>
				<tr>
					<td class="SubHead" width="150"><scp:label id="plQuestion" runat="server" controlname="cboResetQuestion" text="Password Question:"></scp:label></td>
					<td><asp:DropDownList ID="cboResetQuestion" runat="server" CssClass="NormalTextBox" DataTextField="Text" DataValueField="Id"></asp:DropDownList>
					<asp:RequiredFieldValidator id="valQuestion" runat="server" ErrorMessage="Please select a reset question" Display="Dynamic"
							ControlToValidate="cboResetQuestion" InitialValue="0" resourcekey="valQuestion.ErrorMessage"></asp:RequiredFieldValidator></td>
			    </tr>
			    <tr>
					<td class="SubHead" width="150"><scp:label id="plAnswer" runat="server" controlname="txtAnswer" text="Password Answer:"></scp:label></td>
					<td><asp:textbox id="txtAnswer" runat="server" cssclass="NormalTextBox" size="25" maxlength="20"></asp:textbox>
					<asp:requiredfieldvalidator id="valAnswer" resourcekey="valAnswer.ErrorMessage" cssclass="Normal" runat="server"
							controltovalidate="txtAnswer" errormessage="Answer Is Required." display="Dynamic"></asp:requiredfieldvalidator>
                    </td>
			    </tr>
				<tr>
					<td class="SubHead" width="150"><scp:label id="plEmail" text="Email:" runat="server" controlname="txtEmail"></scp:label></td>
					<td><asp:textbox id="txtEmail" cssclass="NormalTextBox" runat="server" width="300" maxlength="100"></asp:textbox><asp:requiredfieldvalidator id="valEmail" resourcekey="valEmail.ErrorMessage" cssclass="Normal" runat="server"
							controltovalidate="txtEmail" errormessage="Email Is Required." display="Dynamic"></asp:requiredfieldvalidator></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<p><asp:linkbutton cssclass="CommandButton" id="cmdUpdate" resourcekey="cmdUpdate" text="Create Portal"
		runat="server" OnClick="cmdUpdate_Click"></asp:linkbutton>&nbsp;&nbsp;
	<asp:linkbutton cssclass="CommandButton" id="cmdCancel" resourcekey="cmdCancel" text="Cancel" runat="server"
		causesvalidation="False" OnClick="cmdCancel_Click"></asp:linkbutton></p>
<asp:label id="lblNote" resourcekey="Note" cssclass="Normal" runat="server"><b>*Note:</b> Once your portal is created, you will need to login using the Administrator information specified above.</asp:label>
