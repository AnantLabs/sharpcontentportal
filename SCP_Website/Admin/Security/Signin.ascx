<%@ Control Language="C#" Inherits="SharpContent.Modules.Admin.Security.Signin" CodeFile="Signin.ascx.cs" AutoEventWireup="true" %>
<%@ Register TagPrefix="scp" Assembly="SharpContent" Namespace="SharpContent.UI.WebControls"%>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="Password" Src="~/Admin/Users/Password.ascx" %>
<%@ Register TagPrefix="scp" TagName="Profile" Src="~/Admin/Users/ProfileModule.ascx" %>
<asp:panel id="pnlLogin" runat="server">
	<table cellspacing="0" cellpadding="3" border="0" summary="SignIn Design Table" width="160">	    
		<tr>
			<td colspan="2" class="SubHead" align="center"><scp:label id="plUsername" controlname="txtUsername" runat="server" text="UserName:"></scp:label></td>
		</tr>
		<tr>
			<td colspan="2"  align="center"><asp:textbox id="txtUsername" columns="9" width="130" cssclass="NormalTextBox" runat="server" /></td>
		</tr>
		<tr>
			<td colspan="2" class="SubHead" align="center"><scp:label id="plPassword" controlname="txtPassword" runat="server" text="Password:"></scp:label></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><asp:textbox id="txtPassword" columns="9" width="130" textmode="password" cssclass="NormalTextBox" runat="server" onfocus='this.select()' /></td>
		</tr>
		<tr id="rowVerification1" runat="server" visible="false">
			<td colspan="2" class="SubHead" align="center"><scp:label id="plVerification" controlname="txtVerification" runat="server" text="Verification Code:"></scp:label></td>
		</tr>
		<tr id="rowVerification2" runat="server" visible="false">
			<td colspan="2" align="center"><asp:textbox id="txtVerification" columns="9" width="130" cssclass="NormalTextBox" runat="server" /></td>
		</tr>
		<tr id="trCaptcha1" runat="server">
			<td colspan="2" class="SubHead" align="center"><scp:label id="plCaptcha" controlname="ctlCaptcha" runat="server" text="Password:"></scp:label></td>
		</tr>
		<tr id="trCaptcha2" runat="server">
			<td colspan="2" align="center"><scp:CaptchaControl id="ctlCaptcha" captchawidth="130" captchaheight="40" cssclass="Normal" runat="server" errorstyle-cssclass="NormalRed" /></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><asp:checkbox id="chkCookie" class="Normal" resourcekey="Remember" text="Remember Login" runat="server" /></td>
		</tr>
		<tr>
			<td id="tdLogin" runat="server" width="50%" align="center"><asp:button id="cmdLogin" resourcekey="cmdLogin" cssclass="StandardButton" text="Login" runat="server" width="100%" OnClick="cmdLogin_Click" UseSubmitBehavior="False" /></td>
			<td id="tdRegister" runat="server" width="50%" align="center"><asp:button id="cmdRegister" resourcekey="cmdRegister" cssclass="StandardButton" text="Register" runat="server" width="100%" OnClick="cmdRegister_Click" UseSubmitBehavior="False" /></td>
		</tr>
		<tr height="5"><td colspan="2"></td></tr>
		<tr>
			<td id="tdPassword" runat="server" colspan="2" align="center"><asp:Linkbutton id="cmdPassword" resourcekey="cmdForgotPassword" cssclass="CommandButton" text="Forgot Password?" runat="server" width="100%" OnClick="cmdPassword_Click" /></td>
		</tr>
		<tr>
            <td align="center" colspan="2">
                <asp:Label ID="lblLogin" runat="server" CssClass="Normal"></asp:Label></td>
		</tr>
	</table>
</asp:panel>
<asp:panel id="pnlPassword" runat="server" visible="false">
	<scp:Password id="ctlPassword" runat="server"></scp:Password>
	<asp:panel ID="pnlProceed" runat="Server" Visible="false">
	    <hr width="95%" />
	    <scp:commandbutton cssclass="CommandButton" id="cmdProceed" runat="server" resourcekey="cmdProceed" imageurl="~/images/rt.gif" />
	</asp:panel>
</asp:panel>
<asp:panel id="pnlProfile" runat="server" visible="false">
	<scp:profile id="ctlProfile" runat="server"></scp:profile>
</asp:panel>
