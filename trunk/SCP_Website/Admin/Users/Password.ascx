<%@ Control Language="C#" CodeFile="Password.ascx.cs" AutoEventWireup="true" Inherits="SharpContent.Modules.Admin.Users.Password" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" Assembly="SharpContent" Namespace="SharpContent.UI.WebControls"%>
<%@ Register TagPrefix="scp" TagName="SectionHead" Src="~/controls/SectionHeadControl.ascx" %>

<table cellspacing="0" cellpadding="0" border="0" width="400">
	<tr>
		<td>
			<table cellspacing="0" cellpadding="0" summary="Password Management" border="0">
				<tr id="trTitle" runat="server">
					<td colspan="2" valign="bottom"><asp:label id="lblTitle" cssclass="Head" runat="server"></asp:label></td>
				</tr>
				<tr><td colspan="2" height="10"></td></tr>
				<tr height="25">
					<td class="SubHead" width="175"><scp:label id="plLastChanged" runat="server" controlname="lblLastChanged" text="Password last Changed:"></scp:label></td>
					<td>
						<asp:label id = "lblLastChanged" runat="server" cssclass="Normal"></asp:label>
					</td>
				</tr>
				<tr height="25">
					<td class="SubHead" width="175"><scp:label id="plExpires" runat="server" controlname="lblExpires" text="Password Expires:"></scp:label></td>
					<td>
						<asp:label id = "lblExpires" runat="server" cssclass="Normal"></asp:label>
					</td>
				</tr>
			</table>
			<br>
			<asp:panel id="pnlChange" runat="server">
				<scp:sectionhead id="dshChange" cssclass="Head" runat="server" 
					text="Change Password" section="tblChange" resourcekey="ChangePassword" 
					isexpanded="True" includerule="True" />
				<table id="tblChange" runat="server" cellspacing="0" cellpadding="0" width="400" summary="Password Management" border="0">
					<tr><td colspan="2" valign="bottom"><asp:label id="lblChangeHelp" cssclass="Normal" runat="server"></asp:label></td></tr>
					<tr><td colspan="2" height="10"></td></tr>
					<tr id="trOldPassword" runat="server" height="25">
						<td class="SubHead" width="175"><scp:label id="plOldPassword" runat="server" controlname="txtOldPassword" text="Old Password:" Visible="true"></scp:label></td>
						<td><asp:textbox id="txtOldPassword" runat="server" cssclass="NormalTextBox" textmode="Password" size="25" maxlength="20"></asp:textbox></td>
					</tr>
					<tr height="25">
						<td class="SubHead" width="175"><scp:label id="plNewPassword" runat="server" controlname="txtNewPassword" text="New Password:"></scp:label></td>
						<td><asp:textbox id="txtNewPassword" runat="server" cssclass="NormalTextBox" textmode="Password" size="25" maxlength="20"></asp:textbox></td>
					</tr>
					<tr height="25">
						<td class="SubHead" width="175"><scp:label id="plNewConfirm" runat="server" controlname="txtNewConfirm" text="Confirm New Password:"></scp:label></td>
						<td><asp:textbox id="txtNewConfirm" runat="server" cssclass="NormalTextBox" textmode="Password" size="25" maxlength="20"></asp:textbox></td>
					</tr>
					<tr>
						<td colspan="2" align="center"><scp:commandbutton cssclass="CommandButton" id="cmdUpdate" runat="server" resourcekey="ChangePassword" causesvalidation="True" imageurl="~/images/save.gif" />
                            </td>
					</tr>
				</table>
				<br>
			</asp:panel>
		    <asp:panel id="pnlReset" runat="server">
				<scp:sectionhead id="dshReset" cssclass="Head" runat="server" 
					text="Reset Password" section="tblReset" resourcekey="ResetPassword" 
					isexpanded="True" includerule="True" />
				<table id="tblReset" runat="server" cellspacing="0" cellpadding="0" width="400" summary="Password Management" border="0">
					<tr><td colspan="2" valign="bottom"><asp:label id="lblResetHelp" cssclass="Normal" runat="server"></asp:label></td></tr>
					<tr><td colspan="2" height="10"></td></tr>
					<tr id="trQuestion" runat="server" height="25">
						<td class="SubHead" width="175"><scp:label id="plQuestion" runat="server" controlname="cboResetQuestion" text="Password Question:"></scp:label></td>
						<td>
                            <asp:DropDownList ID="cboResetQuestion" runat="server" CssClass="NormalTextBox" DataTextField="Text" DataValueField="Id">
                            </asp:DropDownList></td>
					</tr>
					<tr id="trAnswer" runat="server" height="25">
						<td class="SubHead" width="175"><scp:label id="plAnswer" runat="server" controlname="txtAnswer" text="Password Answer:"></scp:label></td>
						<td><asp:textbox id="txtAnswer" runat="server" cssclass="NormalTextBox" size="25" maxlength="20"></asp:textbox></td>
					</tr>
					<tr>
						<td colspan="2" align="center"><scp:commandbutton cssclass="CommandButton" id="cmdReset" runat="server" resourcekey="ResetPassword" causesvalidation="True" imageurl="~/images/reset.gif" /></td>
					</tr>
				</table>
				<br>
			</asp:panel>
			<asp:panel id="pnlQA" runat="server">
				<scp:sectionhead id="dshQuestionAnswer" cssclass="Head" runat="server" 
					text="CHange Question And Answer" section="tblQA" resourcekey="ChangeQA" 
					isexpanded="True" includerule="True" />
				<table id="tblQA" runat="server" cellspacing="0" cellpadding="0" summary="Password Management" border="0">
					<tr><td colspan="2" valign="bottom"><asp:label id="lblQAHelp" resourcekey="QAHelp" cssclass="Normal" runat="server"></asp:label></td></tr>
					<tr><td colspan="2" height="10"></td></tr>
					<tr height="25">
						<td class="SubHead" width="175"><scp:label id="plQAPassword" runat="server" controlname="txtQAPassword" text="Password:"></scp:label></td>
						<td><asp:textbox id="txtQAPassword" runat="server" cssclass="NormalTextBox" textmode="Password" size="25" maxlength="20"></asp:textbox></td>
					</tr>
					<tr height="25">
						<td class="SubHead" width="175"><scp:label id="plEditQuestion" runat="server" controlname="lblQuetxtEditQuestionstion" text="Password Question:"></scp:label></td>
						<td><asp:DropDownList ID="cboEditQuestion" runat="server" CssClass="NormalTextBox" DataTextField="Text" DataValueField="Id">
                            </asp:DropDownList></td>
					</tr>
					<tr height="25">
						<td class="SubHead" width="175"><scp:label id="plEditAnswer" runat="server" controlname="txtEditAnswer" text="Password Answer:"></scp:label></td>
						<td><asp:textbox id="txtEditAnswer" runat="server" cssclass="NormalTextBox" size="25" maxlength="20"></asp:textbox></td>
					</tr>
					<tr>
						<td colspan="2" align="center"><scp:commandbutton cssclass="CommandButton" id="cmdUpdateQA" runat="server" resourcekey="SaveQA" causesvalidation="True" imageurl="~/images/save.gif" /></td>
					</tr>
				</table>
			</asp:panel>
		</td>
	</tr>
</table>
