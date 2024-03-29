<%@ Control Language="C#" CodeFile="User.ascx.cs" AutoEventWireup="true" Inherits="SharpContent.Modules.Admin.Users.User" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" Assembly="SharpContent" Namespace="SharpContent.UI.WebControls"%>
<%@ Register TagPrefix="scp" TagName="SectionHead" Src="~/controls/SectionHeadControl.ascx" %>

<scp:propertyeditorcontrol id="userEditor" runat="Server"
	enableClientValidation = "true"
	sortmode="SortOrderAttribute" 
	labelstyle-cssclass="SubHead" 
	helpstyle-cssclass="Help" 
	editcontrolstyle-cssclass="NormalTextBox" 
	labelwidth="175px" 
	editcontrolwidth="200px" 
	width="375px" 
	editmode="Edit" 
	errorstyle-cssclass="NormalRed"/>
<asp:panel id="pnlAddUser" runat="server" visible="False">
	<table id="tblAddUser" runat="server" width="250">
		<tr height="25">
			<td width="125" class="subhead"><scp:label id="plAuthorize" runat="server" controlname="chkAuthorize" /></td>
			<td width="125" class="normalTextBox"><asp:checkbox id="chkAuthorize" runat="server" checked="True" /></td>
		</tr>
		<tr height="25">
			<td width="125" class="subhead"><scp:label id="plNotify" runat="server" controlname="chkNotify" /></td>
			<td width="125" class="normalTextBox"><asp:checkbox id="chkNotify" runat="server" checked="True" /></td>
		</tr>
	</table>
	<br/>
	<scp:sectionhead id="dshPassword" cssclass="Head" runat="server" 
		text="Password" section="tblPassword" resourcekey="Password" 
		isexpanded="True" includerule="True" />
	<table id="tblPassword" runat="server" cellspacing="0" cellpadding="0" width="350" summary="Password Management" border="0">
		<tr><td colspan="2" valign="bottom"><asp:label id="lblPasswordHelp" cssclass="Normal" runat="server"></asp:label></td></tr>
		<tr><td colspan="2" height="10"></td></tr>
		<tr id="trRandom" runat="server">
			<td width="150" class="subhead"><scp:label id="plRandom" runat="server" controlname="chkRandom" /></td>
			<td width="200" class="normalTextBox"><asp:checkbox id="chkRandom" runat="server" checked="True" /></td>
		</tr>
        <tr height="25">
            <td class="SubHead" width="150">
                <scp:Label ID="plPassword" runat="server" ControlName="txtPassword" Text="Password:" />
            </td>
            <td width="200">
                <asp:TextBox ID="txtPassword" runat="server" CssClass="NormalTextBox" MaxLength="20" size="12" TextMode="Password">
                </asp:TextBox>
                <asp:Image ID="Image1" runat="server" BorderStyle="None" ImageUrl="~/images/required.gif" />
            </td>
        </tr>
        <tr height="25">
            <td class="SubHead" valign="top" width="150">
                <scp:Label ID="plConfirm" runat="server" ControlName="txtConfirm" Text="Confirm Password:" />
            </td>
            <td width="200">
                <asp:TextBox ID="txtConfirm" runat="server" CssClass="NormalTextBox" MaxLength="20" size="12" TextMode="Password">
                </asp:TextBox>
                <asp:Image ID="Image2" runat="server" BorderStyle="None" ImageUrl="~/images/required.gif" />
                </td>
        </tr>
        <tr id="trQuestion" runat="server" height="25" visible="false">
            <td class="SubHead" valign="top" width="175" nowrap>
                <scp:Label ID="plQuestion" runat="server" ControlName="lblQuestion" Text="Password Question:" />
            </td>
            <td nowrap>
                <asp:DropDownList ID="cboQuestion" runat="server" CssClass="NormalTextBox" DataTextField="Text" DataValueField="Id">
                </asp:DropDownList>
                <asp:Image ID="Image3" runat="server" BorderStyle="None" ImageUrl="~/images/required.gif" />
                </td>
        </tr>
        <tr id="trAnswer" runat="server" height="25" visible="false">
            <td class="SubHead" valign="top" width="175">
                <scp:Label ID="plAnswer" runat="server" ControlName="txtAnswer" Text="Password Answer:" />
            </td>
            <td nowrap>
                <asp:TextBox ID="txtAnswer" runat="server" CssClass="NormalTextBox" MaxLength="20" size="25"></asp:TextBox>
                <asp:Image ID="Image4" runat="server" BorderStyle="None" ImageUrl="~/images/required.gif" />
                </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:CustomValidator ID="valPassword" runat="Server" CssClass="NormalRed">
                </asp:CustomValidator>
            </td>
        </tr>
		<tr id="trCaptcha" runat="server">
			<td class="SubHead" width="150" valign="top"><scp:label id="plCaptcha" controlname="ctlCaptcha" runat="server" text="Password:"></scp:label></td>
			<td width="200">
				<scp:captchacontrol id="ctlCaptcha" captchawidth="130" captchaheight="40" cssclass="Normal" ErrorStyle-CssClass="NormalRed" runat="server" />
			</td>
		</tr>
	</table>
</asp:panel>
<asp:Panel ID="pnlUpdate" runat="server" align="center">
    <scp:CommandButton ID="cmdDelete" runat="server" ResourceKey="cmdDelete" ImageUrl="~/images/delete.gif" CausesValidation="False" />
    &nbsp;&nbsp;&nbsp;
    <scp:CommandButton ID="cmdUpdate" runat="server" ResourceKey="cmdUpdate" ImageUrl="~/images/save.gif"
        CausesValidation="True" />
</asp:Panel>
