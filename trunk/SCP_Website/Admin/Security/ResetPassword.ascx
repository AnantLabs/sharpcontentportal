<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" Assembly="SharpContent" Namespace="SharpContent.UI.WebControls"%>
<%@ Control Language="C#" Inherits="SharpContent.Modules.Admin.Security.ResetPassword" CodeFile="ResetPassword.ascx.cs" AutoEventWireup="true"  %>
<asp:Panel runat="server" ID="pnlReset">
<table cellspacing="0" cellpadding="3" border="0" summary="SignIn Design Table" width="160">	
	<tr>
		<td width="160" class="SubHead"><scp:label id="plUsername" controlname="txtUsername" runat="server" text="UserName:"></scp:label></td>
	</tr>
	<tr>
		<td width="160"><asp:textbox id="txtUsername" columns="9" width="130" cssclass="NormalTextBox" runat="server" /></td>
	</tr>
	<tr id="trCaptcha1" runat="server">
		<td colspan="2" class="SubHead"><scp:label id="plCaptcha" controlname="ctlCaptcha" runat="server" text="Password:"></scp:label></td>
	</tr>
	<tr id="trCaptcha2" runat="server">
		<td colspan="2"><scp:captchacontrol id="ctlCaptcha" captchawidth="130" captchaheight="40" cssclass="Normal" runat="server" errorstyle-cssclass="NormalRed" /></td>
	</tr>
	<tr>
		<td>
			<table id="tblQA" runat="server">
				<tr height="25">
					<td class="SubHead"><scp:label id="plQuestion" runat="server" controlname="lblQuestion" text="Password Question:"></scp:label></td>
				</tr>
				<tr>
					<td><asp:DropDownList ID="cboResetQuestion" runat="server" CssClass="NormalTextBox" DataTextField="Text" DataValueField="Id"></asp:DropDownList></td>
				</tr>
				<tr height="25">
					<td class="SubHead" width="175"><scp:label id="plAnswer" runat="server" controlname="txtAnswer" text="Password Answer:"></scp:label></td>
				</tr>
				<tr>
					<td><asp:textbox id="txtAnswer" runat="server" cssclass="NormalTextBox" size="25" maxlength="20"></asp:textbox></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td><scp:commandbutton id="cmdResetPassword" imageurl="~/images/password.gif" resourcekey="cmdResetPassword" cssclass="CommandButton" runat="server"/></td>
	</tr>
	<tr>
		<td width="160"><asp:label id="lblLogin" cssclass="Normal" runat="server" /></td>
	</tr>
</table>
</asp:Panel>